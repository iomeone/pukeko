g_declare_cafs gm$cons_0_0, dict$Ord$Int, dict$Ring$Int, dict$Foldable$List, dict$Monad$IO$ll1, dict$Monad$IO, input, dict$Functor$ListF, dict$Bifunctor$ListF, toList, fromList, main
g_declare_main main

g_globstart gm$cons_0_0, 0
g_updcons 0, 0, 1
g_return

g_globstart gm$cons_0_1, 1
g_updcons 0, 1, 1
g_return

g_globstart gm$cons_0_2, 2
g_updcons 0, 2, 1
g_return

g_globstart gm$cons_0_4, 4
g_updcons 0, 4, 1
g_return

g_globstart gm$cons_1_2, 2
g_updcons 1, 2, 1
g_return

g_globstart id, 1
g_update 1
g_unwind

g_globstart op$u, 3
g_push 2
g_push 2
g_mkap 1
g_push 1
g_updap 1, 4
g_pop 3
g_unwind

g_globstart op$le, 1
g_push 0
g_eval
g_uncons 4
g_pop 1
g_update 4
g_pop 3
g_unwind

g_globstart op$m, 1
g_push 0
g_eval
g_uncons 4
g_pop 2
g_update 3
g_pop 2
g_unwind

g_globstart op$t, 1
g_push 0
g_eval
g_uncons 4
g_pop 3
g_update 2
g_pop 1
g_unwind

g_globstart gm$lt, 2
g_push 1
g_eval
g_push 1
g_eval
g_les
g_update 3
g_pop 2
g_return

g_globstart gm$le, 2
g_push 1
g_eval
g_push 1
g_eval
g_leq
g_update 3
g_pop 2
g_return

g_globstart gm$ge, 2
g_push 1
g_eval
g_push 1
g_eval
g_geq
g_update 3
g_pop 2
g_return

g_globstart gm$gt, 2
g_push 1
g_eval
g_push 1
g_eval
g_gtr
g_update 3
g_pop 2
g_return

g_globstart dict$Ord$Int, 0
g_pushglobal gm$lt, 2
g_pushglobal gm$le, 2
g_pushglobal gm$ge, 2
g_pushglobal gm$gt, 2
g_push 0
g_push 2
g_push 4
g_push 6
g_updcons 0, 4, 5
g_pop 4
g_return

g_globstart gm$neg, 1
g_eval
g_neg
g_update 1
g_return

g_globstart gm$add, 2
g_push 1
g_eval
g_push 1
g_eval
g_add
g_update 3
g_pop 2
g_return

g_globstart gm$sub, 2
g_push 1
g_eval
g_push 1
g_eval
g_sub
g_update 3
g_pop 2
g_return

g_globstart gm$mul, 2
g_push 1
g_eval
g_push 1
g_eval
g_mul
g_update 3
g_pop 2
g_return

g_globstart dict$Ring$Int, 0
g_pushglobal gm$neg, 1
g_pushglobal gm$add, 2
g_pushglobal gm$sub, 2
g_pushglobal gm$mul, 2
g_push 0
g_push 2
g_push 4
g_push 6
g_updcons 0, 4, 5
g_pop 4
g_return

g_globstart foldr, 1
g_push 0
g_eval
g_uncons 2
g_update 3
g_pop 2
g_unwind

g_globstart foldl, 1
g_push 0
g_eval
g_uncons 2
g_pop 1
g_update 2
g_pop 1
g_unwind

g_globstart map, 1
g_push 0
g_eval
g_uncons 1
g_update 2
g_pop 1
g_unwind

g_globstart dict$Foldable$List$ll1, 3
g_push 2
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 2
g_update 2
g_pop 1
g_unwind
g_label .1
g_uncons 2
g_push 1
g_push 4
g_push 4
g_pushglobal dict$Foldable$List, 0
g_pushglobal foldr, 1
g_mkap 4
g_push 1
g_push 4
g_updap 2, 6
g_pop 5
g_unwind
g_label .2

g_globstart dict$Foldable$List$ll2, 3
g_push 2
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 2
g_update 2
g_pop 1
g_unwind
g_label .1
g_uncons 2
g_push 1
g_push 1
g_push 5
g_push 5
g_mkap 2
g_push 4
g_pushglobal dict$Foldable$List, 0
g_pushglobal foldl, 1
g_updap 4, 6
g_pop 5
g_unwind
g_label .2

g_globstart dict$Foldable$List, 0
g_pushglobal dict$Foldable$List$ll1, 3
g_pushglobal dict$Foldable$List$ll2, 3
g_push 0
g_push 2
g_updcons 0, 2, 3
g_pop 2
g_return

g_globstart replicate, 2
g_pushint 0
g_push 1
g_pushglobal dict$Ord$Int, 0
g_pushglobal op$le, 1
g_mkap 3
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_push 1
g_pushint 1
g_push 2
g_pushglobal dict$Ring$Int, 0
g_pushglobal op$m, 1
g_mkap 3
g_pushglobal replicate, 2
g_mkap 2
g_push 2
g_updcons 1, 2, 3
g_pop 2
g_return
g_jump .2
g_label .1
g_pop 1
g_pushglobal gm$cons_0_0, 0
g_update 3
g_pop 2
g_unwind
g_label .2

g_globstart pure, 1
g_push 0
g_eval
g_uncons 2
g_update 3
g_pop 2
g_unwind

g_globstart op$gge, 1
g_push 0
g_eval
g_uncons 2
g_pop 1
g_update 2
g_pop 1
g_unwind

g_globstart op$s$ll1, 2
g_update 2
g_pop 1
g_unwind

g_globstart op$s, 3
g_push 2
g_pushglobal op$s$ll1, 2
g_mkap 1
g_push 2
g_push 2
g_pushglobal op$gge, 1
g_updap 3, 4
g_pop 3
g_unwind

g_globstart sequence$ll1, 3
g_push 2
g_push 2
g_cons 1, 2
g_push 1
g_pushglobal pure, 1
g_updap 2, 4
g_pop 3
g_unwind

g_globstart sequence$ll2, 3
g_push 2
g_push 1
g_pushglobal sequence$ll1, 3
g_mkap 2
g_push 2
g_push 2
g_pushglobal sequence, 2
g_mkap 2
g_push 2
g_pushglobal op$gge, 1
g_updap 3, 4
g_pop 3
g_unwind

g_globstart sequence, 2
g_push 1
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_pushglobal gm$cons_0_0, 0
g_push 1
g_pushglobal pure, 1
g_updap 2, 3
g_pop 2
g_unwind
g_label .1
g_uncons 2
g_push 1
g_push 3
g_pushglobal sequence$ll2, 3
g_mkap 2
g_push 1
g_push 4
g_pushglobal op$gge, 1
g_updap 3, 5
g_pop 4
g_unwind
g_label .2

g_globstart traverse_$ll1, 4
g_push 3
g_push 3
g_push 3
g_mkap 1
g_push 2
g_pushglobal op$s, 3
g_updap 3, 5
g_pop 4
g_unwind

g_globstart traverse_, 3
g_pushglobal gm$cons_0_0, 0
g_push 1
g_pushglobal pure, 1
g_mkap 2
g_push 3
g_push 2
g_pushglobal traverse_$ll1, 4
g_mkap 2
g_push 3
g_pushglobal foldr, 1
g_updap 3, 4
g_pop 3
g_unwind

g_globstart gm$seq, 2
g_eval
g_pop 1
g_update 1
g_unwind

g_globstart gm$puti, 1
g_eval
g_print
g_updcons 0, 0, 1
g_return

g_globstart gm$geti, 1
g_pop 1
g_input
g_update 1
g_return

g_globstart dict$Monad$IO$ll1, 0
g_pushglobal gm$cons_0_2, 2
g_update 1
g_unwind

g_globstart dict$Monad$IO$ll2, 1
g_push 0
g_pushglobal dict$Monad$IO$ll1, 0
g_updap 1, 2
g_pop 1
g_unwind

g_globstart dict$Monad$IO$ll3, 3
g_push 2
g_push 1
g_mkap 1
g_eval
g_uncons 2
g_push 1
g_push 1
g_push 5
g_updap 2, 6
g_pop 5
g_unwind

g_globstart dict$Monad$IO$ll4, 2
g_push 1
g_push 1
g_pushglobal dict$Monad$IO$ll3, 3
g_updap 2, 3
g_pop 2
g_unwind

g_globstart dict$Monad$IO, 0
g_pushglobal dict$Monad$IO$ll2, 1
g_pushglobal dict$Monad$IO$ll4, 2
g_push 0
g_push 2
g_updcons 0, 2, 3
g_pop 2
g_return

g_globstart io$ll1, 3
g_push 1
g_push 1
g_mkap 1
g_push 3
g_push 1
g_cons 0, 2
g_push 1
g_pushglobal gm$seq, 2
g_updap 2, 5
g_pop 4
g_unwind

g_globstart io, 2
g_push 1
g_push 1
g_pushglobal io$ll1, 3
g_updap 2, 3
g_pop 2
g_unwind

g_globstart print, 1
g_push 0
g_pushglobal gm$puti, 1
g_pushglobal io, 2
g_updap 2, 2
g_pop 1
g_unwind

g_globstart input, 0
g_pushglobal gm$cons_0_0, 0
g_pushglobal gm$geti, 1
g_pushglobal io, 2
g_updap 2, 1
g_unwind

g_globstart fix, 1
g_update 1
g_unwind

g_globstart unFix, 1
g_update 1
g_unwind

g_globstart cata, 2
g_pushglobal unFix, 1
g_push 2
g_push 2
g_pushglobal cata, 2
g_mkap 2
g_push 2
g_pushglobal map, 1
g_mkap 2
g_pushglobal op$u, 3
g_mkap 2
g_push 2
g_pushglobal op$u, 3
g_updap 2, 3
g_pop 2
g_unwind

g_globstart ana, 2
g_push 1
g_push 2
g_push 2
g_pushglobal ana, 2
g_mkap 2
g_push 2
g_pushglobal map, 1
g_mkap 2
g_pushglobal op$u, 3
g_mkap 2
g_pushglobal fix, 1
g_pushglobal op$u, 3
g_updap 2, 3
g_pop 2
g_unwind

g_globstart bimap, 1
g_push 0
g_eval
g_uncons 1
g_update 2
g_pop 1
g_unwind

g_globstart fix2, 1
g_update 1
g_unwind

g_globstart unFix2, 1
g_update 1
g_unwind

g_globstart dict$Functor$Fix2$ll1, 2
g_pushglobal unFix2, 1
g_push 2
g_push 2
g_pushglobal dict$Functor$Fix2, 1
g_mkap 1
g_pushglobal map, 1
g_mkap 2
g_push 3
g_push 3
g_pushglobal bimap, 1
g_mkap 3
g_pushglobal op$u, 3
g_mkap 2
g_pushglobal fix2, 1
g_pushglobal op$u, 3
g_updap 2, 3
g_pop 2
g_unwind

g_globstart dict$Functor$Fix2, 1
g_push 0
g_pushglobal dict$Functor$Fix2$ll1, 2
g_mkap 1
g_push 0
g_updcons 0, 1, 3
g_pop 2
g_return

g_globstart poly, 1
g_pushglobal unFix, 1
g_push 1
g_pushglobal poly, 1
g_mkap 1
g_pushglobal id, 1
g_push 3
g_pushglobal bimap, 1
g_mkap 3
g_pushglobal op$u, 3
g_mkap 2
g_pushglobal fix2, 1
g_pushglobal op$u, 3
g_updap 2, 2
g_pop 1
g_unwind

g_globstart mono, 1
g_pushglobal unFix2, 1
g_push 1
g_pushglobal mono, 1
g_mkap 1
g_pushglobal id, 1
g_push 3
g_pushglobal bimap, 1
g_mkap 3
g_pushglobal op$u, 3
g_mkap 2
g_pushglobal fix, 1
g_pushglobal op$u, 3
g_updap 2, 2
g_pop 1
g_unwind

g_globstart dict$Functor$ListF, 0
g_pushglobal id, 1
g_pushglobal dict$Bifunctor$ListF, 0
g_pushglobal bimap, 1
g_mkap 2
g_push 0
g_updcons 0, 1, 2
g_pop 1
g_return

g_globstart dict$Bifunctor$ListF$ll1, 3
g_push 2
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_pushglobal gm$cons_0_0, 0
g_update 4
g_pop 3
g_unwind
g_label .1
g_uncons 2
g_push 1
g_push 4
g_mkap 1
g_push 1
g_push 4
g_mkap 1
g_updcons 1, 2, 6
g_pop 5
g_return
g_jump .2
g_label .2

g_globstart dict$Bifunctor$ListF, 0
g_pushglobal dict$Bifunctor$ListF$ll1, 3
g_push 0
g_updcons 0, 1, 2
g_pop 1
g_return

g_globstart toList$ll1, 1
g_push 0
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_pushglobal gm$cons_0_0, 0
g_update 2
g_pop 1
g_unwind
g_label .1
g_uncons 2
g_push 1
g_push 1
g_updcons 1, 2, 4
g_pop 3
g_return
g_jump .2
g_label .2

g_globstart toList, 0
g_pushglobal dict$Bifunctor$ListF, 0
g_pushglobal mono, 1
g_mkap 1
g_pushglobal toList$ll1, 1
g_pushglobal dict$Functor$ListF, 0
g_pushglobal cata, 2
g_mkap 2
g_pushglobal op$u, 3
g_updap 2, 1
g_unwind

g_globstart fromList$ll1, 1
g_push 0
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_pushglobal gm$cons_0_0, 0
g_update 2
g_pop 1
g_unwind
g_label .1
g_uncons 2
g_push 1
g_push 1
g_updcons 1, 2, 4
g_pop 3
g_return
g_jump .2
g_label .2

g_globstart fromList, 0
g_pushglobal fromList$ll1, 1
g_pushglobal dict$Functor$ListF, 0
g_pushglobal ana, 2
g_mkap 2
g_pushglobal dict$Bifunctor$ListF, 0
g_pushglobal poly, 1
g_mkap 1
g_pushglobal op$u, 3
g_updap 2, 1
g_unwind

g_globstart main$ll1, 1
g_push 0
g_pushint 2
g_pushglobal dict$Ring$Int, 0
g_pushglobal op$t, 1
g_updap 3, 2
g_pop 1
g_unwind

g_globstart main$ll2, 1
g_push 0
g_pushglobal fromList, 0
g_mkap 1
g_pushglobal main$ll1, 1
g_pushglobal dict$Bifunctor$ListF, 0
g_pushglobal dict$Functor$Fix2, 1
g_mkap 1
g_pushglobal map, 1
g_mkap 3
g_pushglobal toList, 0
g_mkap 1
g_pushglobal print, 1
g_pushglobal dict$Foldable$List, 0
g_pushglobal dict$Monad$IO, 0
g_pushglobal traverse_, 3
g_updap 4, 2
g_pop 1
g_unwind

g_globstart main$ll3, 1
g_pushglobal main$ll2, 1
g_pushglobal input, 0
g_push 2
g_pushglobal replicate, 2
g_mkap 2
g_pushglobal dict$Monad$IO, 0
g_pushglobal sequence, 2
g_mkap 2
g_pushglobal dict$Monad$IO, 0
g_pushglobal op$gge, 1
g_updap 3, 2
g_pop 1
g_unwind

g_globstart main, 0
g_pushglobal main$ll3, 1
g_pushglobal input, 0
g_pushglobal dict$Monad$IO, 0
g_pushglobal op$gge, 1
g_updap 3, 1
g_unwind
