g_declare_globals C.0.0, 0, C.0.1, 1, C.0.2, 2, C.0.3, 3, C.1.2, 2, B.le, 2, B.sub, 2, B.mul, 2, B.seq, 2, B.puti, 1, B.geti, 1, functorIO, 0, monadIO, 0, print, 0, input, 0, functorFox2, 1, poly, 1, mono, 1, bifunctorListF, 0, main, 0, id.L1, 1, compose.L1, 3, foldableList.foldr.L1, 3, replicate.L1, 2, semi.L1, 2, semi.L2, 3, sequence.L1, 3, sequence.L2, 3, sequence.L3, 2, traverse_.L1, 3, functorIO.map.L1, 3, functorIO.map.L2, 2, monadIO.pure.L2, 1, monadIO.bind.L1, 3, monadIO.bind.L2, 2, io.L1, 3, io.L2, 2, fix.L1, 1, unFix.L1, 1, cata.L1, 2, ana.L1, 2, fix2.L1, 1, unFix2.L1, 1, functorFox2.map.L1, 2, functorListF.map.L1, 0, bifunctorListF.bimap.L1, 3, toList.L1, 1, fromList.L1, 1, main.L1, 0, main.L2, 1, main.L3, 1
g_declare_main main

g_globstart C.0.0, 0
g_updcons 0, 0, 1
g_return

g_globstart C.0.1, 1
g_updcons 0, 1, 1
g_return

g_globstart C.0.2, 2
g_updcons 0, 2, 1
g_return

g_globstart C.0.3, 3
g_updcons 0, 3, 1
g_return

g_globstart C.1.2, 2
g_updcons 1, 2, 1
g_return

g_globstart B.le, 2
g_push 1
g_eval
g_push 1
g_eval
g_leq
g_update 3
g_pop 2
g_return

g_globstart B.sub, 2
g_push 1
g_eval
g_push 1
g_eval
g_sub
g_update 3
g_pop 2
g_return

g_globstart B.mul, 2
g_push 1
g_eval
g_push 1
g_eval
g_mul
g_update 3
g_pop 2
g_return

g_globstart B.seq, 2
g_eval
g_pop 1
g_update 1
g_unwind

g_globstart B.puti, 1
g_eval
g_print
g_updcons 0, 0, 1
g_return

g_globstart B.geti, 1
g_pop 1
g_input
g_update 1
g_return

g_globstart functorIO, 0
g_pushglobal functorIO.map.L2
g_updcons 0, 1, 1
g_return

g_globstart monadIO, 0
g_pushglobal monadIO.bind.L2
g_pushglobal monadIO.pure.L2
g_pushglobal functorIO
g_updcons 0, 3, 1
g_return

g_globstart print, 0
g_pushglobal B.puti
g_pushglobal io.L2
g_updap 1, 1
g_unwind

g_globstart input, 0
g_pushglobal C.0.0
g_pushglobal B.geti
g_pushglobal io.L1
g_updap 2, 1
g_unwind

g_globstart functorFox2, 1
g_push 0
g_pushglobal functorFox2.map.L1
g_mkap 1
g_updcons 0, 1, 2
g_pop 1
g_return

g_globstart poly, 1
g_pushglobal unFix.L1
g_push 1
g_pushglobal poly
g_mkap 1
g_pushglobal id.L1
g_push 3
g_eval
g_proj 0
g_push 0
g_slide 1
g_mkap 2
g_pushglobal compose.L1
g_mkap 2
g_pushglobal fix2.L1
g_pushglobal compose.L1
g_updap 2, 2
g_pop 1
g_unwind

g_globstart mono, 1
g_pushglobal unFix2.L1
g_push 1
g_pushglobal mono
g_mkap 1
g_pushglobal id.L1
g_push 3
g_eval
g_proj 0
g_push 0
g_slide 1
g_mkap 2
g_pushglobal compose.L1
g_mkap 2
g_pushglobal fix.L1
g_pushglobal compose.L1
g_updap 2, 2
g_pop 1
g_unwind

g_globstart bifunctorListF, 0
g_pushglobal bifunctorListF.bimap.L1
g_updcons 0, 1, 1
g_return

g_globstart main, 0
g_pushglobal main.L3
g_pushglobal input
g_pushglobal monadIO.bind.L1
g_updap 2, 1
g_unwind

g_globstart id.L1, 1
g_update 1
g_unwind

g_globstart compose.L1, 3
g_push 2
g_push 2
g_mkap 1
g_push 1
g_updap 1, 4
g_pop 3
g_unwind

g_globstart foldableList.foldr.L1, 3
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
g_pushglobal foldableList.foldr.L1
g_mkap 3
g_push 1
g_push 4
g_updap 2, 6
g_pop 5
g_unwind
g_label .2

g_globstart replicate.L1, 2
g_pushint 0
g_push 1
g_eval
g_leq
g_jumpcase .0, .1
g_label .0
g_pop 1
g_push 1
g_pushint 1
g_push 2
g_pushglobal B.sub
g_mkap 2
g_pushglobal replicate.L1
g_mkap 2
g_push 2
g_updcons 1, 2, 3
g_pop 2
g_return
g_jump .2
g_label .1
g_pop 1
g_pushglobal C.0.0
g_update 3
g_pop 2
g_unwind
g_label .2

g_globstart semi.L1, 2
g_update 2
g_pop 1
g_unwind

g_globstart semi.L2, 3
g_push 2
g_pushglobal semi.L1
g_mkap 1
g_push 2
g_push 2
g_eval
g_proj 2
g_push 0
g_slide 1
g_updap 2, 4
g_pop 3
g_unwind

g_globstart sequence.L1, 3
g_push 2
g_push 2
g_cons 1, 2
g_push 1
g_eval
g_proj 1
g_push 0
g_slide 1
g_updap 1, 4
g_pop 3
g_unwind

g_globstart sequence.L2, 3
g_push 2
g_push 1
g_pushglobal sequence.L1
g_mkap 2
g_push 2
g_push 2
g_pushglobal sequence.L3
g_mkap 2
g_push 2
g_eval
g_proj 2
g_push 0
g_slide 1
g_updap 2, 4
g_pop 3
g_unwind

g_globstart sequence.L3, 2
g_push 1
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_pushglobal C.0.0
g_push 1
g_eval
g_proj 1
g_push 0
g_slide 1
g_updap 1, 3
g_pop 2
g_unwind
g_label .1
g_uncons 2
g_push 1
g_push 3
g_pushglobal sequence.L2
g_mkap 2
g_push 1
g_push 4
g_eval
g_proj 2
g_push 0
g_slide 1
g_updap 2, 5
g_pop 4
g_unwind
g_label .2

g_globstart traverse_.L1, 3
g_push 2
g_push 2
g_mkap 1
g_push 1
g_pushglobal semi.L2
g_updap 2, 4
g_pop 3
g_unwind

g_globstart functorIO.map.L1, 3
g_push 2
g_push 2
g_mkap 1
g_eval
g_uncons 2
g_push 1
g_push 1
g_push 4
g_mkap 1
g_updcons 0, 2, 6
g_pop 5
g_return

g_globstart functorIO.map.L2, 2
g_push 1
g_push 1
g_pushglobal functorIO.map.L1
g_updap 2, 3
g_pop 2
g_unwind

g_globstart monadIO.pure.L2, 1
g_push 0
g_pushglobal C.0.2
g_updap 1, 2
g_pop 1
g_unwind

g_globstart monadIO.bind.L1, 3
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

g_globstart monadIO.bind.L2, 2
g_push 1
g_push 1
g_pushglobal monadIO.bind.L1
g_updap 2, 3
g_pop 2
g_unwind

g_globstart io.L1, 3
g_push 1
g_push 1
g_mkap 1
g_push 3
g_push 1
g_cons 0, 2
g_push 1
g_pushglobal B.seq
g_updap 2, 5
g_pop 4
g_unwind

g_globstart io.L2, 2
g_push 1
g_push 1
g_pushglobal io.L1
g_updap 2, 3
g_pop 2
g_unwind

g_globstart fix.L1, 1
g_update 1
g_unwind

g_globstart unFix.L1, 1
g_update 1
g_unwind

g_globstart cata.L1, 2
g_pushglobal unFix.L1
g_push 2
g_push 2
g_pushglobal cata.L1
g_mkap 2
g_push 2
g_eval
g_proj 0
g_push 0
g_slide 1
g_mkap 1
g_pushglobal compose.L1
g_mkap 2
g_push 2
g_pushglobal compose.L1
g_updap 2, 3
g_pop 2
g_unwind

g_globstart ana.L1, 2
g_push 1
g_push 2
g_push 2
g_pushglobal ana.L1
g_mkap 2
g_push 2
g_eval
g_proj 0
g_push 0
g_slide 1
g_mkap 1
g_pushglobal compose.L1
g_mkap 2
g_pushglobal fix.L1
g_pushglobal compose.L1
g_updap 2, 3
g_pop 2
g_unwind

g_globstart fix2.L1, 1
g_update 1
g_unwind

g_globstart unFix2.L1, 1
g_update 1
g_unwind

g_globstart functorFox2.map.L1, 2
g_pushglobal unFix2.L1
g_push 1
g_pushglobal functorFox2
g_mkap 1
g_push 3
g_push 1
g_eval
g_proj 0
g_push 0
g_slide 1
g_mkap 1
g_slide 1
g_push 3
g_push 3
g_eval
g_proj 0
g_push 0
g_slide 1
g_mkap 2
g_pushglobal compose.L1
g_mkap 2
g_pushglobal fix2.L1
g_pushglobal compose.L1
g_updap 2, 3
g_pop 2
g_unwind

g_globstart functorListF.map.L1, 0
g_pushglobal id.L1
g_pushglobal bifunctorListF.bimap.L1
g_updap 1, 1
g_unwind

g_globstart bifunctorListF.bimap.L1, 3
g_push 2
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_pushglobal C.0.0
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

g_globstart toList.L1, 1
g_push 0
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_pushglobal C.0.0
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

g_globstart fromList.L1, 1
g_push 0
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_pushglobal C.0.0
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

g_globstart main.L1, 0
g_pushint 2
g_pushglobal B.mul
g_updap 1, 1
g_unwind

g_globstart main.L2, 1
g_pushglobal toList.L1
g_pushglobal functorListF.map.L1
g_cons 0, 1
g_pushglobal cata.L1
g_mkap 2
g_pushglobal bifunctorListF
g_pushglobal mono
g_mkap 1
g_pushglobal bifunctorListF
g_pushglobal functorFox2
g_mkap 1
g_pushglobal bifunctorListF
g_pushglobal poly
g_mkap 1
g_pushglobal fromList.L1
g_pushglobal functorListF.map.L1
g_cons 0, 1
g_pushglobal ana.L1
g_mkap 2
g_push 5
g_push 1
g_mkap 1
g_push 2
g_mkap 1
g_slide 2
g_pushglobal main.L1
g_push 2
g_eval
g_proj 0
g_push 0
g_slide 1
g_mkap 2
g_slide 1
g_push 0
g_push 2
g_mkap 1
g_push 3
g_mkap 1
g_slide 3
g_pushglobal C.0.0
g_pushglobal C.0.2
g_mkap 1
g_pushglobal print
g_pushglobal monadIO
g_pushglobal traverse_.L1
g_mkap 2
g_pushglobal foldableList.foldr.L1
g_updap 3, 2
g_pop 1
g_unwind

g_globstart main.L3, 1
g_pushglobal input
g_push 1
g_pushglobal replicate.L1
g_mkap 2
g_pushglobal monadIO
g_pushglobal sequence.L3
g_mkap 2
g_pushglobal main.L2
g_push 1
g_pushglobal monadIO.bind.L1
g_updap 2, 3
g_pop 2
g_unwind
