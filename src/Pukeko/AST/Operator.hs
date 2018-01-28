module Pukeko.AST.Operator
  ( Spec (..)
  , Assoc (..)
  , table
  , letters
  , aprec
  , mangle
  )
where

import Pukeko.Prelude

import qualified Data.Map as Map

data Assoc = AssocLeft | AssocRight | AssocNone

data Spec = MkSpec{ _sym :: String, _prec :: Int, _assoc :: Assoc }

mangleTable :: Map Char Char
mangleTable = Map.fromList
  [ ('+', 'p'), ('-', 'm'), ('*', 't'), ('/', 'd'), ('%', 'r')
  , ('=', 'e'), ('<', 'l'), ('>', 'g'), ('!', 'n')
  , ('&', 'a'), ('|', 'o'), (';', 's'), (':', 'c')
  ]

mangle :: String -> Maybe String
mangle "" = Nothing
mangle xs = ("op$" ++) <$> traverse (`Map.lookup` mangleTable) xs

letters :: [Char]
letters = Map.keys mangleTable

mkSpec :: Assoc -> String -> Spec
mkSpec _assoc _sym = case mangle _sym of
  Just _  -> MkSpec{ _sym, _prec = undefined, _assoc }
  Nothing -> bugWith "invalid operator name" _sym

left, right, none :: String -> Spec
left  = mkSpec AssocLeft
right = mkSpec AssocRight
none  = mkSpec AssocNone

table :: [[Spec]]
table = fixPrecs
  [ [left ">>=", left ";"]
  , [right "||"]
  , [right "&&"]
  , map none ["<" , "<=", "==", "!=", ">=", ">" ]
  , [right "+", none "-"]
  , [right "*", none "/", none "%"]
  ]

aprec :: Int
aprec = length table + 1

fixPrecs :: [[Spec]] -> [[Spec]]
fixPrecs = zipWith (\prec -> map (\spec -> spec { _prec = prec })) [1 ..]
