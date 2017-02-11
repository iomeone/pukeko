{-# LANGUAGE TemplateHaskell #-}
module CoreLang.GMachine.Compiler
  ( compile
  , GProg
  )
  where

import Control.Monad.Except
import Control.Monad.Reader hiding (asks, local)
import Control.Monad.Writer
import Data.Label.Derive
import Data.Label.Monadic
import Data.Map (Map)

import qualified Data.Map as Map

import CoreLang.GMachine.GCode
import CoreLang.Language.Syntax

import qualified  CoreLang.GMachine.Builtins as Builtins

data Context = MkContext
  { _offsets :: Map Ident Int
  , _depth   :: Int
  }
mkLabels [''Context]

emptyContext :: Context
emptyContext = MkContext { _offsets = undefined, _depth = undefined }

newtype CC a = CC { unCC :: ExceptT String (ReaderT Context (Writer GCode)) a }
  deriving ( Functor, Applicative, Monad
           , MonadError String
           , MonadReader Context
           , MonadWriter GCode
           )

-- compile :: MonadError String m => Expr () -> m GProg
compile expr =
  case expr of
    Let { _isrec = True, _defns, _body = Var { _ident = main } } -> do
      let cc = mapM_ ccDefn (Builtins.uncompiled ++ _defns)
          (res, code) = runWriter (runReaderT (runExceptT (unCC cc)) emptyContext)
      case res of
        Left error -> throwError error
        Right ()   -> return $ GProg $ concat
          [ [ PUSHGLOBAL (Name (unIdent main))
            , EVAL
            , PRINT
            , EXIT
            ]
          , Builtins.compiled
          , code
          ]
    _ -> throwError "Expression is not in form generated by lambda lifter"


ccDefn :: Defn a -> CC ()
ccDefn MkDefn{ _patn = MkPatn{ _ident }, _expr } = do
  let (patns, body) =
        case _expr of
          Lam { _patns, _body } -> (_patns, _body)
          _                     -> ([]    , _expr)
      n = length patns
      (idents, _) = unzipPatns patns
  tell [GLOBSTART (name _ident) n]
  let offs = Map.fromList (zip idents [n, n-1 ..])
  local offsets (const offs) $ local depth (const n) $ do
    ccExpr body
    tell [UPDATE (n+1), POP n, UNWIND]

ccExpr :: Expr a -> CC ()
ccExpr expr =
  case expr of
    Var { _ident } -> do
      MkContext { _offsets, _depth } <- ask
      case Map.lookup _ident _offsets of
        Nothing     -> tell [PUSHGLOBAL (name _ident)]
        Just offset -> tell [PUSH (_depth - offset)]
    Num { _int } -> tell [PUSHINT _int]
    Ap { _fun, _arg } -> do
      ccExpr _arg
      local depth succ $ ccExpr _fun
      tell [MKAP]
    ApOp { _annot, _op, _arg1, _arg2 } -> ccExpr $
      Ap { _annot
         , _fun = Ap { _annot
                     , _fun = Var { _annot, _ident = _op }
                     , _arg = _arg1 }
         , _arg = _arg2 }
    Lam { } -> throwError "All lambdas should be lifted by now"
    Let { _isrec = False, _defns, _body } -> do
      let n = length _defns
          (idents, _, rhss) = unzipDefns3 _defns
      zipWithM_ (\rhs k -> local depth (+k) $ ccExpr rhs) rhss [0 ..]
      localDecls idents n $ ccExpr _body
      tell [SLIDE n]
    Let { _isrec = True, _defns, _body } -> do
      let n = length _defns
          (idents, _, rhss) = unzipDefns3 _defns
      tell [ALLOC n]
      localDecls idents n $ do
        zipWithM_ (\rhs k -> ccExpr rhs >> tell [UPDATE (n-k)]) rhss [0 ..]
        ccExpr _body
      tell [SLIDE n]
    Pack { } -> throwError "Constructors are not supported yet"
    If { _annot, _cond, _then, _else } -> ccExpr $
      Ap { _annot
         , _fun = Ap { _annot
                     , _fun = Ap { _annot
                                 , _fun = Var { _annot, _ident = MkIdent "if" }
                                 , _arg = _cond }
                     , _arg = _then }
         , _arg = _else }
    Rec { } -> throwError "Records are not supported yet"
    Sel { } -> throwError "Records are not supported yet"

localDecls :: [Ident] -> Int -> CC a -> CC a
localDecls idents n cc = do
  d <- asks depth
  let offs = Map.fromList (zip idents [d+1 ..])
  local offsets (Map.union offs) $ local depth (+n) $ cc

name :: Ident -> Name
name ident = Name (unIdent ident)