module CoreLang.Language.Parser 
  ( parseExpr
  , parseType
  )
  where

import Control.Monad.Except
import Text.Parsec
import Text.Parsec.Expr
import Text.Parsec.Language
import qualified Text.Parsec.Token    as Token

import CoreLang.Language.Operator (Spec (..))
import CoreLang.Language.Syntax
import CoreLang.Language.Type (Type, var, (~>), app, record)

import qualified CoreLang.Language.Operator as Operator

parseExpr :: MonadError String m => String -> String -> m (Expr SourcePos)
parseExpr file code = 
  case parse (expr <* eof) file code of
    Left error  -> throwError (show error)
    Right expr -> return expr

parseType :: MonadError String m => String -> m Type
parseType code = 
  case parse (type_ <* eof) "<input>" code of
    Left error -> throwError (show error)
    Right expr -> return expr


type Parser = Parsec String ()

coreLangDef :: LanguageDef st
coreLangDef = haskellStyle
  { Token.reservedNames =
      [ "fun"
      , "let", "letrec", "and", "in"
      , "if", "then", "else"
      -- , "case", "of"
      , "Pack"
      ]
  , Token.reservedOpNames = ["=", "->", ":", "."] ++ Operator.names
  }

Token.TokenParser
  { Token.identifier
  , Token.reserved
  , Token.reservedOp
  , Token.natural
  , Token.parens
  , Token.braces
  , Token.comma
  , Token.commaSep
  } =
  Token.makeTokenParser coreLangDef

nat :: Parser Int
nat = fromInteger <$> natural

equals, arrow :: Parser ()
equals  = reservedOp "="
arrow   = reservedOp "->"

ident, typeName  :: Parser Ident
ident = MkIdent <$> identifier
typeName = lookAhead lower *> ident

typeVar :: Parser Type
typeVar = var <$> (lookAhead upper *> identifier)

type_, atype :: Parser Type
type_ =
  buildExpressionParser
    [ [ Infix (arrow *> pure (~>)) AssocRight ] ]
    ( app <$> typeName <*> many atype
      <|> atype
    )
  <?> "type"
atype = choice
  [ typeVar
  , app <$> typeName <*> pure []
  , record <$> braces (commaSep ((,) <$> ident <*> asType))
  , parens type_
  ]
  
asType :: Parser Type
asType = reservedOp ":" *> type_

patn :: Bool -> Parser (Patn SourcePos)
patn needParens =
  if needParens then
    MkPatn <$> getPosition <*> ident <*> pure Nothing
    <|> 
    parens (MkPatn <$> getPosition <*> ident <*> (Just <$> asType))
  else
    MkPatn <$> getPosition <*> ident <*> optionMaybe asType
  <?> "declaration"

defn :: Parser (Defn SourcePos)
defn = 
  MkDefn <$> patn False <*> (equals *> expr)
  <?> "definition"

expr, aexpr1, aexpr :: Parser (Expr SourcePos)
expr =
  choice
    [ Let <$> getPosition
          <*> (reserved "let" *> pure False <|> reserved "letrec" *> pure True )
          <*> sepBy1 defn (reserved "and")
          <*> (reserved "in" *> expr)
    , Lam <$> getPosition 
          <*> (reserved "fun" *> many1 (patn True))
          <*> (arrow *> expr)
    , If  <$> getPosition 
          <*> (reserved "if"   *> expr) 
          <*> (reserved "then" *> expr)
          <*> (reserved "else" *> expr)
    , let partialAp = do
            pos <- getPosition
            foldl1 (Ap pos) <$> many1 aexpr
      in  buildExpressionParser operatorTable partialAp
    ]
  <?> "expression"
aexpr1 = choice
  [ Var <$> getPosition <*> ident
  , Num <$> getPosition <*> nat
  , reserved "Pack" *> braces (Pack <$> getPosition <*> nat <*> (comma *> nat))
  , parens expr
  , Rec <$> getPosition <*> braces (commaSep defn)
  ]
aexpr = do
  pos <- getPosition
  foldl (Sel pos) <$> aexpr1 <*> many (reservedOp "." *> ident)

operatorTable = map (map f) (reverse Operator.table)
  where
    f MkSpec { _name, _assoc } =
      Infix (ApOp <$> getPosition <*> (reservedOp _name *> pure (MkIdent _name))) _assoc
