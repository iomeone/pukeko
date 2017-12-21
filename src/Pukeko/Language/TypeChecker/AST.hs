{-# LANGUAGE DataKinds #-}
module Pukeko.Language.TypeChecker.AST
  ( TypeCon
  , ExprCon
  , Module
  , TopLevel (..)
  , Defn
  , Expr
  , Altn
  , Patn
  ) where

import           Control.Lens

import           Pukeko.Language.AST.Classes
import           Pukeko.Language.AST.Std
import qualified Pukeko.Language.KindChecker.AST as KC
import qualified Pukeko.Language.Ident           as Id

data TYPECHECKER

type TypeCon = KC.TypeCon
type ExprCon = KC.ExprCon

instance Stage TYPECHECKER where
  type ExprConOf TYPECHECKER = ExprCon
  type HasLam    TYPECHECKER = 'True
  type HasMat    TYPECHECKER = 'True

type Module = [TopLevel]

data TopLevel
  = Def Pos Id.EVar (Expr Id.EVar)
  | Asm Pos Id.EVar String

type Defn = StdDefn TYPECHECKER
type Expr = StdExpr TYPECHECKER
type Altn = StdAltn TYPECHECKER
type Patn = StdPatn TYPECHECKER

makePrisms ''TopLevel

instance HasLhs TopLevel where
  type Lhs TopLevel = Id.EVar
  lhs f = \case
    Def w x t -> fmap (\x' -> Def w x' t) (f x)
    Asm w x s -> fmap (\x' -> Asm w x' s) (f x)