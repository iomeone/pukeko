{-# LANGUAGE ViewPatterns #-}
module Pukeko.FrontEnd.Inferencer
  ( Out
  , inferModule
  )
where

import Pukeko.Prelude
import Pukeko.Pretty

import           Control.Lens (folded)
import           Control.Monad.Extra
import           Control.Monad.Freer.Supply
import           Control.Monad.ST
import qualified Data.List.NE     as NE
import qualified Data.Map.Extended as Map
import qualified Data.Sequence    as Seq
import qualified Data.Set         as Set
import           Data.STRef

import           Pukeko.FrontEnd.Info
import           Pukeko.AST.Expr.Optics
import           Pukeko.AST.Name
import           Pukeko.AST.SystemF
import           Pukeko.AST.Language
import           Pukeko.AST.ConDecl
import           Pukeko.AST.Type       hiding ((~>), (*~>))
import           Pukeko.FrontEnd.Inferencer.UType
import           Pukeko.FrontEnd.Inferencer.Gamma
import           Pukeko.FrontEnd.Inferencer.Unify

type In    = Surface
type Out   = Typed
type Aux s = PreTyped (UType s)

type Cstrs s = Seq (UType s, Name Clss)

data SplitCstrs s = MkSplitCstrs
  { _retained :: Map NameTVar (Set (Name Clss))
  , _deferred :: Cstrs s
  }

type CanInfer s effs =
  (CanUnify s effs, Members [Supply UVarId, NameSource, Reader ModuleInfo] effs)

freshUVar :: forall s effs. CanInfer s effs => Eff effs (UType s)
freshUVar = do
  v <- fresh
  l <- getTLevel @s
  UVar <$> sendM (newSTRef (UFree v l))

generalize :: forall s effs. CanInfer s effs =>
  UType s -> Eff effs (UType s, Set (Name TVar))
generalize = go
  where
    go :: UType s -> Eff effs (UType s, Set (Name TVar))
    go t0 = case t0 of
      UVar uref -> do
        curLevel <- getTLevel @s
        sendM (readSTRef uref) >>= \case
          UFree uid lvl
            | lvl > curLevel -> do
                name <- mkName (Lctd noPos (uvarIdName uid))
                let t1 = UTVar name
                sendM (writeSTRef uref (ULink t1))
                pure (t1, Set.singleton name)
            | otherwise -> pureDefault
          ULink t1 -> go t1
      UTVar{} -> pureDefault
      UTAtm{} -> pureDefault
      UTUni{} -> impossible  -- we have only rank-1 types
      UTApp tf0 tp0 -> do
        (tf1, vsf) <- go tf0
        (tp1, vsp) <- go tp0
        pure (UTApp tf1 tp1, vsf <> vsp)
      where
        pureDefault = pure (t0, mempty)

splitCstr :: forall s effs. CanInfer s effs =>
  UType s -> Name Clss -> Eff effs (SplitCstrs s)
splitCstr t0 clss = do
  (t1, tps) <- sendM (unUTApp t0)
  case t1 of
    UVar uref -> do
      cur_level <- getTLevel @s
      sendM (readSTRef uref) >>= \case
        UFree v l
          | l > cur_level ->
              throwHere
                ("ambiguous type variable in constraint" <+> pretty clss <+> pretty v)
          | otherwise -> pure (MkSplitCstrs mempty (Seq.singleton (t0, clss)))
        ULink{} -> impossible  -- we've unwound 'UTApp's
    UTVar v -> pure (MkSplitCstrs (Map.singleton v (Set.singleton clss)) mempty)
    UTAtm atom -> do
      inst_mb <- lookupInfo info2insts (clss, atom)
      case inst_mb of
        Nothing -> throwNoInst
        Just (SomeInstDecl MkInstDecl{_inst2qvars = qvs}) -> do
          let cstrs = Seq.fromList
                [ (tp, c) | (tp, MkQVar q _) <- zipExact tps qual, c <- toList q ]
          splitCstrs cstrs
          where qual = toList qvs
    UTApp{} -> impossible  -- we've unwound 'UTApp's
    UTUni{} -> impossible  -- we have only rank-1 types
  where
    throwNoInst = do
      p0 <- sendM (prettyUType 1 t0)
      throwHere ("TI: no instance for" <+> pretty clss <+> p0)

splitCstrs :: CanInfer s effs => Cstrs s -> Eff effs (SplitCstrs s)
splitCstrs cstrs = fold <$> traverse (uncurry splitCstr) cstrs

instantiate :: CanInfer s effs =>
  Expr (Aux s) -> UType s -> Eff effs (Expr (Aux s), UType s, Cstrs s)
instantiate e0 t0 = do
  let (qvss, t1) = unUTUni t0
  (env, cstrs) <- fmap unzip . for qvss $ \qvs -> do
    fmap unzip . for qvs $ \(MkQVar q v) -> do
      t <- freshUVar
      pure ((v, t), Seq.fromList (map ((,) t) (toList q)))
  t2 <- sendM (substUType (Map.fromList (concat env)) t1)
  let e1 = foldl (\e -> mkETyApp e . map snd) e0 env
  pure (e1, t2, foldMap fold cstrs)

inferPatn :: CanInfer s effs =>
  Patn In -> UType s -> Eff effs (Patn (Aux s), Map (Name EVar) (UType s))
inferPatn patn t_expr = case patn of
  PWld -> pure (PWld, Map.empty)
  PVar x -> pure (PVar x, Map.singleton x t_expr)
  PCon dcon (_ :: [NoType]) ps0 -> do
    (MkTConDecl tcon params _dcons, MkDConDecl{_dcon2fields = fields})
      <- findInfo info2dcons dcon
    when (length ps0 /= length fields) $
      throwHere ("data constructor" <+> quotes (pretty dcon) <+>
                 "expects" <+> pretty (length fields) <+> "arguments")
    t_params <- traverse (const freshUVar) params
    let t_inst = appTCon tcon (toList t_params)
    unify t_expr t_inst
    let env = Map.fromList (zipExact params t_params)
    let t_fields = map (open1 . fmap (env Map.!)) fields
    (ps1, binds) <- unzip <$> zipWithM inferPatn ps0 t_fields
    pure (PCon dcon (toList t_params) ps1, Map.unions binds)

inferLet :: forall s effs.
  CanInfer s effs => Defn In -> Eff effs (Defn (Aux s), UType s, Cstrs s)
inferLet (MkDefn l0 r0) = do
  (r1, t1, cstrs1) <- withinTScope @s (infer r0)
  (t2, vs2) <- generalize t1
  MkSplitCstrs rs1 ds1 <- splitCstrs cstrs1
  let rs2 = Map.unionWith (<>) rs1 (Map.fromSet (const mempty) vs2)
  let qvs = map (\(v, q) -> MkQVar q v) (Map.toList rs2)
  let t3 = mkUTUni qvs t2
  pure (MkDefn (l0 & bind2type .~ t3) r1, t3, ds1)

-- TODO: It would be nice to use Liquid Haskell to show that the resulting lists
-- have the same length as the input list.
inferRec :: forall s effs. CanInfer s effs =>
  [Defn In] -> Eff effs ([Defn (Aux s)], [UType s], Cstrs s)
inferRec defns0 = do
  let (ls0, rs0) = unzip (map (\(MkDefn (MkBind l NoType) r) -> (l, r)) defns0)
  (rs1, ts1, cstrs1) <- withinTScope @s $ do
    us <- traverse (const freshUVar) ls0
    (rs1, ts1, cstrs1) <-
      unzip3 <$> withinEScope (Map.fromList (zip ls0 us)) (traverse infer rs0)
    zipWithM_ unify us ts1
    pure (rs1, ts1, fold cstrs1)
  (ts2, vs2) <- second fold . unzip <$> traverse generalize ts1
  MkSplitCstrs cstrs_ret1 cstrs_def <- splitCstrs cstrs1
  let cstrs_ret2 = Map.unionWith (<>) cstrs_ret1 (Map.fromSet (const mempty) vs2)
  let qvs = map (\(v, q) -> MkQVar q v) (Map.toList cstrs_ret2)
  let ts3 = fmap (mkUTUni qvs) ts2
  let vs3 = map (UTVar . _qvar2tvar) qvs
  let addETyApp x
        | x `Set.member` Set.fromList ls0 = mkETyApp (EVar x) vs3
        | otherwise                       = EVar x
  let rs2 = map (subst addETyApp) rs1
  let defns1 = zipWith3 (\l0 t3 r2 -> MkDefn (MkBind l0 t3) r2) ls0 ts3 rs2
  pure (defns1, ts3, cstrs_def)

infer :: forall s effs. CanInfer s effs =>
  Expr In -> Eff effs (Expr (Aux s), UType s, Cstrs s)
infer = \case
    ELoc (Lctd pos e0) -> here_ pos $ do
      (e1, t1, cstrs) <- infer e0
      pure (ELoc (Lctd pos e1), t1, cstrs)
    EVar x -> lookupEVar x >>= instantiate (EVar x)
    EAtm a -> typeOfAtom a >>= instantiate (EAtm a) . open
    EApp fun0 arg0 -> do
      (fun1, t_fun, cstrs_fun) <- infer fun0
      (arg1, t_arg, cstrs_arg) <- infer arg0
      t_res <- freshUVar
      unify t_fun (t_arg ~> t_res)
      pure (EApp fun1 arg1, t_res, cstrs_fun <> cstrs_arg)
    ELam (MkBind param NoType) body0 -> do
      t_param <- freshUVar
      (body1, t_body, cstrs) <- withinEScope1 @s param t_param (infer body0)
      let binder = MkBind param t_param
      pure (ELam binder (ETyAnn t_body body1), t_param ~> t_body, cstrs)
    ELet defns0 rhs0 -> do
      (defns1, t_defns, cstrs_defns) <- unzip3 <$> traverse inferLet defns0
      (rhs1, t_rhs, cstrs_rhs) <-
        withinEScope (Map.fromList (zipExact (map nameOf defns0) t_defns)) (infer rhs0)
      pure (ELet defns1 rhs1, t_rhs, fold cstrs_defns <> cstrs_rhs)
    ERec defns0 rhs0 -> do
      (defns1, t_defns, cstrs_defns) <- inferRec defns0
      (rhs1, t_rhs, cstrs_rhs) <-
        withinEScope (Map.fromList (zipExact (map nameOf defns0) t_defns)) (infer rhs0)
      pure (ERec defns1 rhs1, t_rhs, cstrs_defns <> cstrs_rhs)
    EMat expr0 altns0 -> do
      (expr1, t_expr, cstrs0) <- infer expr0
      t_res <- freshUVar
      (altns1, cstrss1) <- fmap NE.unzip . for altns0 $ \(MkAltn patn0 rhs0) -> do
        (patn1, t_binds) <- inferPatn patn0 t_expr
        (rhs1, t_rhs, cstrs1) <- withinEScope t_binds (infer rhs0)
        unify t_res t_rhs
        pure (MkAltn patn1 rhs1, cstrs1)
      pure (EMat expr1 altns1, t_res, cstrs0 <> fold cstrss1)
    ETyCoe c@(MkCoercion dir tcon) e0 -> do
      MkTConDecl _ prms dcons <- findInfo info2tcons tcon
      t_rhs0 <- case dcons of
        Right _ -> throwHere ("type constructor" <+> pretty tcon <+> "is not coercible")
        Left t_rhs0 -> pure t_rhs0
      t_prms <- traverse (const freshUVar) prms
      let t_lhs = appTCon tcon (toList t_prms)
      let env = Map.fromList (zipExact prms t_prms)
      let t_rhs = open1 (fmap (env Map.!) t_rhs0)
      let (t_to, t_from) = case dir of
            Inject  -> (t_lhs, t_rhs)
            Project -> (t_rhs, t_lhs)
      (e1, t1, cstrs) <- infer e0
      unify t_from t1
      pure (ETyAnn t_to (ETyCoe c e1), t_to, cstrs)

inferFuncDecl :: forall s tv effs. CanInfer s effs =>
  FuncDecl In tv -> UType s -> Eff effs (FuncDecl (Aux s) tv)
inferFuncDecl (MkFuncDecl name NoType e0) t_decl = do
    -- NOTE: We do not instantiate the universally quantified type variables in
    -- prenex position of @t_decl@. Turning them into unification variables
    -- would make the following type check:
    --
    -- val f : a -> b
    -- let f = fun x -> x
    let (qvs, t0) = unUTUni1 t_decl
    (e1, t1, cstrs1) <- withinTScope @s (infer e0)
    -- NOTE: This unification should bind all unification variables in @t1@. If
    -- it does not, the quantification step will catch them.
    withQVars @s qvs (unify t0 t1)
    MkSplitCstrs rs1 ds1 <- splitCstrs cstrs1
    assertM (null ds1)  -- the renamer catches free type variables in constraints
    for_ qvs $ \(MkQVar q0 v) -> do
      let q1 = Map.findWithDefault mempty v rs1
      unless (q1 `Set.isSubsetOf` q0) $ do
        let clss = Set.findMin (q1 `Set.difference` q0)
        throwHere ("cannot deduce" <+> pretty clss <+> pretty v <+> "from context")
    pure (MkFuncDecl name t_decl e1)

inferDecl :: forall s effs. CanInfer s effs => Decl In -> Eff effs (Maybe (Decl (Aux s)))
inferDecl = \case
  DType ds -> yield (DType ds)
  DSign{} -> pure Nothing
  DFunc func0 -> do
    t_decl :: UType _ <- open <$> typeOfFunc (nameOf func0)
    func1 <- inferFuncDecl func0 t_decl
    yield (DFunc func1)
  DExtn (MkExtnDecl name NoType s) -> do
    t <- open <$> typeOfFunc name
    yield (DExtn (MkExtnDecl name t s))
  DClss c -> yield (DClss c)
  DInst (MkInstDecl instName clss atom qvs ds0) -> do
    ds1 <- for ds0 $ \mthd -> do
      (_, MkSignDecl _ t_decl0) <- findInfo info2mthds (nameOf mthd)
      let t_inst = mkTApp (TAtm atom) (map (TVar . _qvar2tvar) qvs)
      -- FIXME: renameType
      let t_decl1 = t_decl0 >>= const t_inst
      withQVars @s qvs (inferFuncDecl mthd (open t_decl1))
    yield (DInst (MkInstDecl instName clss atom qvs ds1))
  where
    yield = pure . Just

inferModule' :: forall s effs.
  ( MemberST s effs
  , Members [Reader ModuleInfo, Error Failure, NameSource] effs) =>
  Module In -> Eff effs (Module (Aux s))
inferModule' = module2decls $ \decls ->
  fmap catMaybes . for decls $ \decl -> inferDecl @s decl
                                        & runGamma @s
                                        & evalSupply uvarIds
                                        & runReader (getPos decl)

-- FIXME: We use this set make sure there are /no/ unintended free type variables
-- left in expressions. Make this intention clear through code.
type TQEnv = Set NameTVar

type TQ s = Eff [Reader TQEnv, Reader SourcePos, Error Failure, NameSource, ST s]

localizeTQ :: Foldable t => t QVar -> TQ s a -> TQ s a
localizeTQ qvs = local (setOf (folded . qvar2tvar) qvs <>)

qualType :: UType s -> TQ s Type
qualType = \case
  UTVar x -> (asks (x `Set.member`) >>= assertM) $> TVar x
  UTAtm a -> pure (TAtm a)
  UTApp t1 t2 -> TApp <$> qualType t1 <*> qualType t2
  UTUni{} -> impossible  -- we have only rank-1 types
  UVar uref ->
    sendM (readSTRef uref) >>= \case
      ULink t -> qualType t
      UFree{} -> impossible  -- all unification variables have been generalized

qualDefn :: Defn (Aux s) -> TQ s (Defn Out)
qualDefn (MkDefn (MkBind x t0) e0) = case t0 of
  UTUni (toList -> qvs) t1 -> localizeTQ qvs $ do
    t2  <- mkTUni qvs <$> qualType t1
    e2  <- mkETyAbs qvs <$> qualExpr e0
    pure (MkDefn (MkBind x t2) e2)
  _ -> MkDefn <$> (MkBind x <$> qualType t0) <*> qualExpr e0

qualExpr :: Expr (Aux s) -> TQ s (Expr Out)
qualExpr = \case
  ELoc le -> here le $ ELoc <$> lctd qualExpr le
  EVar x -> pure (EVar x)
  EAtm a -> pure (EAtm a)
  EApp fun arg -> EApp <$> qualExpr fun <*> qualExpr arg
  ELam param body -> ELam <$> bind2type qualType param <*> qualExpr body
  ELet ds e0 -> ELet <$> traverse qualDefn ds <*> qualExpr e0
  ERec ds e0 -> ERec <$> traverse qualDefn ds <*> qualExpr e0
  EMat e0 as -> EMat <$> qualExpr e0 <*> traverse qualAltn as
  ETyCoe c  e0 -> ETyCoe c <$> qualExpr e0
  ETyApp e0 ts -> ETyApp <$> qualExpr e0 <*> traverse qualType ts
  ETyAnn t  e  -> ETyAnn <$> qualType t <*> qualExpr e

qualAltn :: Altn (Aux s) -> TQ s (Altn Out)
qualAltn (MkAltn p e) = MkAltn <$> qualPatn p <*> qualExpr e

qualPatn :: Patn (Aux s) -> TQ s (Patn Out)
qualPatn = \case
  PWld -> pure PWld
  PVar x -> pure (PVar x)
  PCon c ts ps -> PCon c <$> traverse qualType ts <*> traverse qualPatn ps

qualFuncDecl :: FuncDecl (Aux s) tv -> TQ s (FuncDecl Out tv)
qualFuncDecl (MkFuncDecl name type0 body0) = do
  MkDefn (MkBind _ type1) body1 <- qualDefn (MkDefn (MkBind name type0) body0)
  pure (MkFuncDecl name type1 body1)

qualDecl :: Decl (Aux s) -> TQ s (Decl Out)
qualDecl = \case
  DType ds -> pure (DType ds)
  DFunc func -> DFunc <$> qualFuncDecl func
  DExtn (MkExtnDecl x ts s) -> do
    t1 <- case ts of
      UTUni (toList -> qvs) t0 -> localizeTQ qvs (mkTUni qvs <$> qualType t0)
      t0 -> qualType t0
    pure (DExtn (MkExtnDecl x t1 s))
  DClss c -> pure (DClss c)
  DInst (MkInstDecl instName c t qvs ds0) -> do
    ds1 <- for ds0 $ \d0 -> localizeTQ qvs (qualFuncDecl d0)
    pure (DInst (MkInstDecl instName c t qvs ds1))

qualModule :: Module (Aux s) -> Eff [Error Failure, NameSource, ST s](Module Out)
qualModule = module2decls . traverse $ \decl ->
  qualDecl decl
  & runReader mempty
  & runReader (getPos decl)

inferModule :: Members [NameSource, Error Failure] effs =>
  Module In -> Eff effs (Module Out)
inferModule m0 = eitherM throwError pure $ runSTBelowNameSource $ runError $
  runInfo m0 (inferModule' m0) >>= qualModule

instance Monoid (SplitCstrs s) where
  mempty = MkSplitCstrs mempty mempty
  MkSplitCstrs rs1 ds1 `mappend` MkSplitCstrs rs2 ds2 =
    MkSplitCstrs (Map.unionWith (<>) rs1 rs2) (ds1 <> ds2)
