module Pukeko.GMachine.Builtins
  ( everything
  )
  where

import Pukeko.GMachine.GCode

mkGlobal :: String -> Int -> [GInst String] -> Global
mkGlobal name _arity code =
  let _name = Name name
      _code = GLOBSTART _name _arity : map (fmap Name) code
  in  MkGlobal { _name, _arity, _code }

everything :: [Global]
everything = concat
  [ neg : binops
  , constructors
  , [ if_
    , is_nil, hd, tl
    , fst_, snd_
    , print_, prefix_bind
    , abort
    ]
  ]

neg :: Global
neg = mkGlobal "neg" 1
  [ EVAL
  , NEG
  , UPDATE 1
  , RETURN
  ]

binops :: [Global]
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
    mk name inst = mkGlobal ("prefix_" ++ name) 2
      [ PUSH 1
      , EVAL
      , PUSH 1
      , EVAL
      , inst
      , UPDATE 3
      , POP 2
      , RETURN
      ]

constructors :: [Global]
constructors =
  [ mk "unit"    0 (CONS 0)
  , mk "false"   0 (CONS 0)
  , mk "true"    0 (CONS 1)
  , mk "nil"     0 (CONS 0)
  , mk "cons"    2 (CONS 1)
  , mk "mk_pair" 2 (CONS 0)
  , mk "return"  2 (CONS 0)
  ]
  where
    mk name arity inst = mkGlobal name arity
      [ inst arity
      , UPDATE 1
      , RETURN
      ]

if_ :: Global
if_ = mkGlobal "if" 3
  [ EVAL
  , JUMPZERO ".if_false"
  , SLIDE 1
  , JUMP ".end_if"
  , LABEL ".if_false"
  , POP 1
  , LABEL ".end_if"
  , EVAL
  , UPDATE 1
  , UNWIND
  ]

is_nil, hd, tl :: Global
is_nil = mkGlobal "is_nil" 1
  [ EVAL
  , JUMPZERO ".is_nil"
  , CONS 0 0
  , JUMP ".end_is_nil"
  , LABEL ".is_nil"
  , CONS 1 0
  , LABEL ".end_is_nil"
  , UPDATE 1
  , RETURN
  ]
hd = hd_or_tl "hd" HEAD
tl = hd_or_tl "tl" TAIL
hd_or_tl name inst =
  let dot_empty = "." ++ name ++ "_empty"
  in  mkGlobal name 1
      [ EVAL
      , PUSH 0
      , JUMPZERO dot_empty
      , inst
      , EVAL
      , UPDATE 1
      , UNWIND
      , LABEL dot_empty
      , ABORT
      ]

fst_, snd_ :: Global
fst_ = fst_or_snd "fst" HEAD
snd_ = fst_or_snd "snd" TAIL
fst_or_snd name inst = mkGlobal name 1
  [ EVAL
  , inst
  , EVAL
  , UPDATE 1
  , UNWIND
  ]

print_, prefix_bind :: Global
print_ = mkGlobal "print" 2
  [ EVAL
  , PRINT
  , CONS 0 0 -- unit
  , CONS 0 2 -- pair
  , UPDATE 1
  , RETURN
  ]
prefix_bind = mkGlobal "prefix_bind" 3
  [ PUSH 2
  , PUSH 1
  , MKAP
  , EVAL
  , PUSH 0
  , TAIL
  , PUSH 1
  , HEAD
  , PUSH 4
  , MKAP
  , MKAP
  , UPDATE 5
  , POP 4
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