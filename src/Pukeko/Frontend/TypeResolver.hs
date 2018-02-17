{-# LANGUAGE ViewPatterns #-}
module Pukeko.FrontEnd.TypeResolver
  ( resolveModule
  ) where

import Pukeko.Prelude

import qualified Data.Map     as Map

import           Pukeko.AST.Name
import           Pukeko.AST.SystemF
import           Pukeko.AST.Language
import           Pukeko.AST.ConDecl
import           Pukeko.AST.Type
import qualified Pukeko.AST.Identifier as Id

type In = Surface

data TRState = MkTRState
  { _st2tcons :: Map (Name TCon) TConDecl
  , _st2dcons :: Map Id.DCon (TConDecl, DConDecl)
  }
makeLenses ''TRState

type CanTR effs = Members [Reader SourcePos, State TRState, Error Failure] effs

-- TODO: Use proper terminology in error messages.
trType :: CanTR effs => Type tv -> Eff effs ()
trType = type2tcon_ $ \tcon -> do
  ex <- uses st2tcons (Map.member tcon)
  unless ex (throwHere ("unknown type constructor:" <+> pretty tcon))

insertTCon :: CanTR effs => TConDecl -> Eff effs ()
insertTCon = here' $ \tcon@(nameOf -> tname) -> do
  old <- uses st2tcons (Map.lookup tname)
  when (isJust old) $ throwHere ("duplicate type constructor:" <+> pretty tname)
  modifying st2tcons (Map.insert tname tcon)

insertDCon :: CanTR effs => TConDecl -> DConDecl -> Eff effs ()
insertDCon tcon dcon@MkDConDecl{_dcon2name = unlctd -> dname} = do
  old <- uses st2dcons (Map.lookup dname)
  when (isJust old) $ throwHere ("duplicate data constructor:" <+> pretty dname)
  modifying st2dcons (Map.insert dname (tcon, dcon))

findDCon :: CanTR effs => Id.DCon -> Eff effs Id.DCon
findDCon dcon = do
  ex <- uses st2dcons (Map.member dcon)
  unless ex (throwHere ("unknown data constructor:" <+> pretty dcon))
  pure dcon

-- TODO: Move this check into the renamer.
trDefn :: CanTR effs => Defn In tv ev -> Eff effs ()
trDefn = traverseOf_ (defn2expr . expr2atom . _ACon) findDCon

trDecl :: CanTR effs => Decl In -> Eff effs ()
trDecl top = case top of
  DType tcon@MkTConDecl{_tcon2dcons = dconDecls0} -> do
    insertTCon tcon
    case dconDecls0 of
        Left typ -> trType typ
        Right dconDecls ->
          for_ dconDecls $ here' $ \dcon@MkDConDecl{_dcon2fields = flds} -> do
            for_ flds trType
            insertDCon tcon dcon
  DSign (MkBind _ t) -> trType t
  -- FIXME: Resolve types in class declarations and instance definitions.
  DClss _ -> pure ()
  DInst i -> traverseOf_ inst2defn trDefn i
  DDefn d -> trDefn d
  DExtn _ -> pure ()

resolveModule :: Member (Error Failure) effs => Module In -> Eff effs ()
resolveModule (MkModule decls) =
  traverse_ trDecl decls
  & runReader noPos
  & evalState (MkTRState mempty mempty)
