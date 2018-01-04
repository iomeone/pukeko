{-# LANGUAGE DataKinds #-}
module Pukeko.Language.TypeChecker.AST
  ( ModuleInfo
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
import qualified Pukeko.Language.Ident          as Id

data TYPECHECKER

instance Stage TYPECHECKER where
  type StageId     TYPECHECKER = 400
  type StdTopLevel TYPECHECKER = TopLevel


data TopLevel
  = Def Pos Id.EVar (Expr Id.EVar)
  | Asm Pos Id.EVar String

type ModuleInfo = GenModuleInfo 'True
type Module = StdModule TYPECHECKER
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
