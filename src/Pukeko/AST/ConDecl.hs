{-# OPTIONS_GHC -Wno-unused-top-binds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE PolyKinds #-}
module Pukeko.AST.ConDecl
  ( Some1 (..)
  , Pair1 (..)
  , TConDecl (..)
  , DConDecl (..)
  , tcon2name
  , tcon2dcons
  , dcon2name
  , dcon2flds
  , typeOfDConDecl
  ) where

import Pukeko.Prelude

import qualified Pukeko.AST.Identifier as Id
import           Pukeko.AST.Type
import           Pukeko.AST.Scope
import           Pukeko.Pretty

data Some1 f = forall n. KnownNat n => Some1 (f n)

data Pair1 f g a = Pair1 (f a) (g a)

data TConDecl n = KnownNat n => MkTConDecl
  { _tcon2name  :: Id.TCon
  , _tcon2prms  :: Vector n Id.TVar
  , _tcon2dcons :: [Lctd (DConDecl n)]
  }

data DConDecl n = MkDConDecl
  { _dcon2tcon :: Id.TCon
  , _dcon2name :: Id.DCon
  , _dcon2tag  :: Int
  , _dcon2flds :: [Type (TFinScope n Void)]
  }

typeOfDConDecl :: TConDecl n -> DConDecl n -> Type Void
typeOfDConDecl (MkTConDecl tname prms _) (MkDConDecl tcon dname _ flds)
  | tname /= tcon = bugWith "type and data constructor do not match" (tname, dname)
  | otherwise     = go prms flds
  where
    go ::
      forall n1 n2. (KnownNat n1, KnownNat n2) =>
      Vector n1 Id.TVar -> [Type (TFinScope n2 Void)] -> Type Void
    go xs flds =
      case sameNat (Proxy @n1) (Proxy @n2) of
        Just Refl ->
          let res = mkTApp (TCon tcon) (mkTVars xs)
          in  mkTUni (fmap (MkQVar mempty) xs) (flds *~> res)
        Nothing -> bug "type and data constructor have different arity" (tname, dname)

instance Pretty (TConDecl n) where
  pretty (MkTConDecl tname prms dcons)
    | null dcons =
        pretty tname <+> hsepMap pretty prms
    | otherwise  =
        pretty tname <+> hsepMap pretty prms <+> "=" $$
        nest 2 (vcat (map pretty dcons))

instance Pretty (DConDecl n) where
  pretty (MkDConDecl _ dname _ flds) =
    "|" <+> pretty dname <+> hsepMap (prettyPrec 3) flds

instance Pretty (Some1 TConDecl) where
  pretty (Some1 tcon) = pretty tcon

instance Pretty (Some1 DConDecl) where
  pretty (Some1 dcon) = pretty dcon

instance Show (Some1 TConDecl) where
  show (Some1 tcon) = show tcon

instance Show (Some1 DConDecl) where
  show (Some1 dcon) = show dcon

instance (Show (f a), Show (g a)) => Show (Pair1 f g a) where
  show (Pair1 x y) = show (x, y)

deriving instance Show (TConDecl n)
deriving instance Show (DConDecl n)

makeLenses ''TConDecl
makeLenses ''DConDecl
