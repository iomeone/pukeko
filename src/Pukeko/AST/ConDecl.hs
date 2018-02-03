{-# OPTIONS_GHC -Wno-unused-top-binds #-}
{-# LANGUAGE ViewPatterns #-}
module Pukeko.AST.ConDecl
  ( TConDecl (..)
  , DConDecl (..)
  , tcon2name
  , tcon2dcons
  , dcon2name
  , dcon2flds
  , typeOfDCon
  ) where

import Pukeko.Prelude

import qualified Pukeko.AST.Identifier as Id
import           Pukeko.AST.Type
import           Pukeko.AST.Scope
import           Pukeko.Pretty

data TConDecl = MkTConDecl
  { _tcon2name  :: Lctd Id.TCon
  , _tcon2prms  :: [Id.TVar]
  , _tcon2dcons :: Either (Type (TScope Int Void)) [DConDecl]
  }

data DConDecl = MkDConDecl
  { _dcon2tcon :: Id.TCon
  , _dcon2name :: Lctd Id.DCon
  , _dcon2tag  :: Int
  , _dcon2flds :: [Type (TScope Int Void)]
  }

typeOfDCon :: TConDecl -> DConDecl -> Type Void
typeOfDCon
  (MkTConDecl (unlctd -> tname) prms _) (MkDConDecl tcon dname _ flds)
  | tname /= tcon = bugWith "type and data constructor do not match" (tname, dname)
  | otherwise     =
      let res = mkTApp (TCon tcon) (mkTVars prms)
      in  mkTUni (map (MkQVar mempty) prms) (flds *~> res)

instance HasPos TConDecl where
  getPos = getPos . _tcon2name

instance HasPos DConDecl where
  getPos = getPos . _dcon2name

instance Pretty TConDecl where
  pretty (MkTConDecl tname prms dcons0) =
    case dcons0 of
      Left typ -> lhs <+> "=" <+> pretty typ
      Right dcons
        | null dcons -> lhs
        | otherwise  -> lhs <+> "=" $$ nest 2 (vcatMap pretty dcons)
    where
      lhs = pretty tname <+> hsepMap pretty prms

instance Pretty DConDecl where
  pretty (MkDConDecl _ dname _ flds) =
    "|" <+> pretty dname <+> hsepMap (prettyPrec 3) flds

deriving instance Show TConDecl
deriving instance Show DConDecl

makeLenses ''TConDecl
makeLenses ''DConDecl
