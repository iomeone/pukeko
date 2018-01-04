{-# LANGUAGE DataKinds #-}
-- | AST generated by the introduction of de Bruijn indices.
module Pukeko.Language.Renamer.AST
  ( Module
  , TopLevel (..)
  , Defn
  , Expr
  , Altn
  , Patn
  )
where

import qualified Data.Vector.Sized as Vec

import           Pukeko.Language.AST.Std
import qualified Pukeko.Language.AST.ConDecl as Con
import qualified Pukeko.Language.Ident       as Id
import qualified Pukeko.Language.Type        as Ty

data RENAMER

instance Stage RENAMER where
  type StageId RENAMER = 100

type Module = [TopLevel]

data TopLevel
  =           TypDef Pos [Con.TConDecl]
  |           Val    Pos Id.EVar (Ty.Type Ty.Closed)
  | forall n. TopLet Pos (Vec.Vector n (Defn Id.EVar))
  | forall n. TopRec Pos (Vec.Vector n (Defn (FinScope n Id.EVar)))
  |           Asm    Pos Id.EVar String

type Defn = StdDefn RENAMER
type Expr = StdExpr RENAMER
type Altn = StdAltn RENAMER
type Patn = StdPatn RENAMER
