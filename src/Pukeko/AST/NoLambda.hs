{-# LANGUAGE TemplateHaskell #-}
module Pukeko.AST.NoLambda
  ( Name (..)
  , Module
  , TopLevel (..)
  , Expr (..)
  , Defn (..)
  , Altn (..)
  , mkAp
  , unzipDefns
  , zipMaybe
  )
where

import Pukeko.Prelude
import Pukeko.Pretty

import Data.Aeson.TH

newtype Name = MkName{unName :: String}
  deriving (Eq, Ord)

data Expr
  = Local   {_name :: Name, _idx :: Int}
  | Global  {_name :: Name}
  | External{_name :: Name}
  | Pack    {_tag, _arity :: Int}
  | Num     {_int :: Int}
  | Ap      {_fun :: Expr, _args :: [Expr]}
  | Let     {_defn :: Defn, _body :: Expr}
  | LetRec  {_defns :: [Defn], _body :: Expr}
  | Match   {_expr  :: Expr, _altns :: [Altn]}
  deriving (Show)

data Defn = MkDefn{_lhs :: Name, _rhs :: Expr}
  deriving (Show)

data Altn = MkAltn{_binds :: [Maybe Name], _rhs :: Expr}
  deriving (Show)

data TopLevel
  = Def{ _name :: Name, _binds :: [Maybe Name], _body :: Expr}
  | Asm{ _name :: Name}
  deriving (Show)

type Module = [TopLevel]

mkAp :: Expr -> [Expr] -> Expr
mkAp expr []    = expr
mkAp _fun _args = Ap{_fun, _args}

unzipDefns :: [Defn] -> ([Name], [Expr])
unzipDefns = unzip . map (\MkDefn{_lhs,_rhs} -> (_lhs, _rhs))

zipMaybe :: [Maybe a] -> [b] -> [(a, b)]
zipMaybe idents = catMaybes . zipWith (\ident x -> (,) <$> ident <*> pure x) idents

instance Pretty Name where
  pretty (MkName name) = pretty name

prettyBind :: Maybe Name -> Doc
prettyBind = maybe "_" pretty

prettyAltn :: Int -> Altn -> Doc
prettyAltn tag MkAltn{_binds, _rhs} = hang
    (hsep ["|", braces (pretty tag), hsep (map prettyBind _binds), "->"])
    2
    (pretty _rhs)

instance Pretty Expr

instance PrettyPrec Expr where
  prettyPrec prec expr =
    case expr of
      Local{_name, _idx} -> pretty _name <> brackets (pretty _idx)
      Global{_name} -> "@" <> pretty _name
      External{_name} -> "$" <> pretty _name
      Pack{ _tag, _arity } -> "Pack" <> braces (pretty _tag <> "," <> pretty _arity)
      Num{ _int } -> pretty _int
      Ap{ _fun, _args } ->
        maybeParens (prec > 0) $ hsep $
          prettyPrec 1 _fun : map (prettyPrec 1) _args
      Let{_defn, _body} ->
        vcat
        [ sep
          [ "let" <+> pretty _defn
          , "in"
          ]
        , pretty _body
        ]
      LetRec{_defns, _body} ->
        case _defns of
          [] -> impossible  -- maintained invariant
          defn0:defns ->
                vcat
                [ sep
                  [ vcat $
                    ("let rec" <+> pretty defn0) :
                    map (\defn -> "and" <+> pretty defn) defns
                  , "in"
                  ]
                , pretty _body
                ]
      Match { _expr, _altns } ->
        maybeParens (prec > 0) $ vcat $
        ("match" <+> pretty _expr <+> "with") :
        zipWith prettyAltn [0..] _altns

instance Pretty Defn where
  pretty MkDefn{_lhs, _rhs} = hang (pretty _lhs <+> "=") 2 (pretty _rhs)

instance Pretty TopLevel where
  pretty top = case top of
    Def{_name, _binds, _body} -> hang
      (hsep [ "let"
            , pretty _name
            , hsep (map prettyBind _binds)
            , "="
            ])
      2
      (pretty _body)
    Asm{_name} -> "asm" <+> pretty _name

instance Pretty Module where
  pretty = vcatMap pretty

instance Show Name where
  show (MkName x) = x

$(deriveJSON serdeJsonOptions ''Name)
$(deriveJSON serdeJsonOptions ''Expr)
$(deriveJSON serdeJsonOptions ''Defn)
$(deriveJSON serdeJsonOptions ''Altn)
$(deriveJSON serdeJsonOptions ''TopLevel)
