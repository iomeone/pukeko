module Pukeko.GMachine.Builtins
  ( everything
  , binops
  )
  where

import Pukeko.GMachine.GCode
import Pukeko.Language.ADT (Constructor (..))
import Pukeko.Language.Ident

mkGlobal :: String -> Int -> [GInst String] -> Global
mkGlobal name _arity code =
  let _name = Name name
      _code = GLOBSTART _name _arity : map (fmap Name) code
  in  MkGlobal { _name, _arity, _code }

everything :: [Constructor] -> [Global]
everything constrs = concat
  [ neg : map (snd . snd) binops
  , map mkConstr constrs
  , [ return_, print_, input, prefix_bind
    , abort
    ]
  ]

-- TODO: Produce more efficient code in Redex mode.
neg :: Global
neg = mkGlobal "neg" 1
  [ EVAL
  , NEG
  , UPDATE 1
  , RETURN
  ]

binops :: [(Ident, (Inst, Global))]
binops =
  [ mk "add" ADD
  , mk "sub" SUB
  , mk "mul" MUL
  , mk "div" DIV
  , mk "mod" MOD
  , mk "lt"  LES
  , mk "le"  LEQ
  , mk "eq"  EQV
  , mk "ne"  NEQ
  , mk "ge"  GEQ
  , mk "gt"  GTR
  ]
  where
    mk name inst = (MkIdent prefix_name, (fmap Name inst, global))
      where
        prefix_name = "prefix_" ++ name
        global = mkGlobal prefix_name 2
          [ PUSH 1
          , EVAL
          , PUSH 1
          , EVAL
          , inst
          , UPDATE 3
          , POP 2
          , RETURN
          ]

mkConstr :: Constructor -> Global
mkConstr MkConstructor{ _name, _tag, _fields } =
  let arity = length _fields
  in  mkGlobal (unIdent _name) arity
      [ CONS _tag arity
      , UPDATE 1
      , RETURN
      ]

return_, print_, input, prefix_bind :: Global
return_ = mkGlobal "return" 2
  [ CONS 0 2
  , UPDATE 1
  , RETURN
  ]
print_ = mkGlobal "print" 2
  [ EVAL
  , PRINT
  , CONS 0 0 -- unit
  , CONS 0 2 -- pair
  , UPDATE 1
  , RETURN
  ]
input = mkGlobal "input" 1
  [ INPUT
  , CONS 0 2 -- pair
  , UPDATE 1
  , RETURN
  ]
prefix_bind = mkGlobal "prefix_bind" 3
  [ PUSH 2
  , PUSH 1
  , MKAP 1
  , EVAL
  , UNCONS 2
  , PUSH 3
  , MKAP 2
  , UPDATE 4
  , POP 3
  , UNWIND
  ]

abort :: Global
abort = mkGlobal "abort" 0 [ABORT]

{-
type IO a = World -> (a, World)

print :: Int -> IO ()
print n world = {- print it -}; ((), world)

return :: a -> IO a
return x world = (x, world)

bind :: IO a -> (a -> IO b) -> IO b
bind m f world =
  let (x, world') = m world in f x world'
-}
