g_declare_globals C.0.0, 0, C.0.1, 1, C.0.2, 2, C.0.4, 4, C.1.2, 2, B.eq, 2, B.lt, 2, B.le, 2, B.ge, 2, B.gt, 2, B.neg, 1, B.add, 2, B.sub, 2, B.mul, 2, B.seq, 2, B.puti, 1, B.geti, 1, eq, 1, le, 1, lt, 1, empty, 1, append, 1, add, 1, sub, 1, eqInt, 0, ordInt, 0, ringInt, 0, monoidInt, 0, foldr, 1, foldl, 1, length, 1, map, 1, monoidList, 0, functorList, 0, foldableList, 0, bind, 1, monadIO, 0, print, 0, input, 0, ints, 0, solve_aux, 1, solve, 1, main, 0, monoidInt.empty, 0, monoidList.empty, 0, foldMap.L1, 3, foldMap.L2, 3, length.L1, 1, monoidList.append.L1, 2, functorList.map.L1, 2, foldableList.foldr.L1, 3, foldableList.foldl.L1, 3, take.L1, 2, replicate.L1, 2, zip_with.L1, 3, monadIO.pure.L1, 0, monadIO.pure.L2, 1, monadIO.bind.L1, 3, monadIO.bind.L2, 2, io.L1, 3, io.L2, 2, diff.L1, 2, ints.L1, 2, solve_aux.L1, 3, solve_aux.L2, 2, main.L1, 1
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

g_globstart C.0.4, 4
g_updcons 0, 4, 1
g_return

g_globstart C.1.2, 2
g_updcons 1, 2, 1
g_return

g_globstart B.eq, 2
g_push 1
g_eval
g_push 1
g_eval
g_eqv
g_update 3
g_pop 2
g_return

g_globstart B.lt, 2
g_push 1
g_eval
g_push 1
g_eval
g_les
g_update 3
g_pop 2
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

g_globstart B.ge, 2
g_push 1
g_eval
g_push 1
g_eval
g_geq
g_update 3
g_pop 2
g_return

g_globstart B.gt, 2
g_push 1
g_eval
g_push 1
g_eval
g_gtr
g_update 3
g_pop 2
g_return

g_globstart B.neg, 1
g_eval
g_neg
g_update 1
g_return

g_globstart B.add, 2
g_push 1
g_eval
g_push 1
g_eval
g_add
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

g_globstart eq, 1
g_push 0
g_eval
g_proj 0
g_update 2
g_pop 1
g_unwind

g_globstart le, 1
g_push 0
g_eval
g_proj 2
g_update 2
g_pop 1
g_unwind

g_globstart lt, 1
g_push 0
g_eval
g_proj 3
g_update 2
g_pop 1
g_unwind

g_globstart empty, 1
g_push 0
g_eval
g_proj 0
g_update 2
g_pop 1
g_unwind

g_globstart append, 1
g_push 0
g_eval
g_proj 1
g_update 2
g_pop 1
g_unwind

g_globstart add, 1
g_push 0
g_eval
g_proj 1
g_update 2
g_pop 1
g_unwind

g_globstart sub, 1
g_push 0
g_eval
g_proj 2
g_update 2
g_pop 1
g_unwind

g_globstart eqInt, 0
g_pushglobal B.eq
g_updcons 0, 1, 1
g_return

g_globstart ordInt, 0
g_pushglobal B.lt
g_pushglobal B.le
g_pushglobal B.gt
g_pushglobal B.ge
g_updcons 0, 4, 1
g_return

g_globstart ringInt, 0
g_pushglobal B.mul
g_pushglobal B.sub
g_pushglobal B.add
g_pushglobal B.neg
g_updcons 0, 4, 1
g_return

g_globstart monoidInt, 0
g_pushglobal B.add
g_pushglobal monoidInt.empty
g_updcons 0, 2, 1
g_return

g_globstart foldr, 1
g_push 0
g_eval
g_proj 0
g_update 2
g_pop 1
g_unwind

g_globstart foldl, 1
g_push 0
g_eval
g_proj 1
g_update 2
g_pop 1
g_unwind

g_globstart length, 1
g_pushglobal length.L1
g_pushglobal monoidInt
g_push 2
g_pushglobal foldMap.L2
g_updap 3, 2
g_pop 1
g_unwind

g_globstart map, 1
g_push 0
g_eval
g_proj 0
g_update 2
g_pop 1
g_unwind

g_globstart monoidList, 0
g_pushglobal monoidList.append.L1
g_pushglobal monoidList.empty
g_updcons 0, 2, 1
g_return

g_globstart functorList, 0
g_pushglobal functorList.map.L1
g_updcons 0, 1, 1
g_return

g_globstart foldableList, 0
g_pushglobal foldableList.foldl.L1
g_pushglobal foldableList.foldr.L1
g_updcons 0, 2, 1
g_return

g_globstart bind, 1
g_push 0
g_eval
g_proj 1
g_update 2
g_pop 1
g_unwind

g_globstart monadIO, 0
g_pushglobal monadIO.bind.L2
g_pushglobal monadIO.pure.L2
g_updcons 0, 2, 1
g_return

g_globstart print, 0
g_pushglobal B.puti
g_pushglobal io.L2
g_updap 1, 1
g_unwind

g_globstart input, 0
g_pushglobal C.0.0
g_pushglobal B.geti
g_pushglobal io.L2
g_updap 2, 1
g_unwind

g_globstart ints, 0
g_alloc 1
g_push 0
g_pushglobal ints.L1
g_updap 1, 1
g_pushint 1
g_push 1
g_updap 1, 2
g_pop 1
g_unwind

g_globstart solve_aux, 1
g_push 0
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_pushglobal C.0.0
g_pushglobal C.0.0
g_updcons 1, 2, 2
g_pop 1
g_return
g_jump .2
g_label .1
g_uncons 2
g_push 0
g_push 2
g_pushglobal solve_aux.L2
g_mkap 1
g_pushglobal monoidList
g_pushglobal foldableList
g_pushglobal foldMap.L2
g_updap 4, 4
g_pop 3
g_unwind
g_label .2

g_globstart solve, 1
g_pushglobal ints
g_push 1
g_pushglobal take.L1
g_mkap 2
g_push 1
g_pushglobal replicate.L1
g_mkap 2
g_pushglobal solve_aux
g_updap 1, 2
g_pop 1
g_unwind

g_globstart main, 0
g_pushglobal main.L1
g_pushglobal input
g_pushglobal monadIO
g_pushglobal bind
g_updap 3, 1
g_unwind

g_globstart monoidInt.empty, 0
g_pushint 0
g_update 1
g_return

g_globstart monoidList.empty, 0
g_pushglobal C.0.0
g_update 1
g_unwind

g_globstart foldMap.L1, 3
g_push 2
g_push 2
g_mkap 1
g_push 1
g_pushglobal append
g_updap 2, 4
g_pop 3
g_unwind

g_globstart foldMap.L2, 3
g_push 1
g_pushglobal empty
g_mkap 1
g_push 3
g_push 3
g_pushglobal foldMap.L1
g_mkap 2
g_push 2
g_pushglobal foldr
g_updap 3, 4
g_pop 3
g_unwind

g_globstart length.L1, 1
g_pushint 1
g_update 2
g_pop 1
g_return

g_globstart monoidList.append.L1, 2
g_push 0
g_push 2
g_pushglobal C.1.2
g_pushglobal foldableList
g_pushglobal foldr
g_updap 4, 3
g_pop 2
g_unwind

g_globstart functorList.map.L1, 2
g_push 1
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_pushglobal C.0.0
g_update 3
g_pop 2
g_unwind
g_label .1
g_uncons 2
g_push 1
g_push 3
g_pushglobal functorList
g_pushglobal map
g_mkap 3
g_push 1
g_push 4
g_mkap 1
g_updcons 1, 2, 5
g_pop 4
g_return
g_jump .2
g_label .2

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
g_pushglobal foldableList
g_pushglobal foldr
g_mkap 4
g_push 1
g_push 4
g_updap 2, 6
g_pop 5
g_unwind
g_label .2

g_globstart foldableList.foldl.L1, 3
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
g_pushglobal foldableList
g_pushglobal foldl
g_updap 4, 6
g_pop 5
g_unwind
g_label .2

g_globstart take.L1, 2
g_pushint 0
g_push 1
g_pushglobal ordInt
g_pushglobal le
g_mkap 3
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_push 1
g_eval
g_jumpcase .3, .4
g_label .3
g_pop 1
g_pushglobal C.0.0
g_update 3
g_pop 2
g_unwind
g_label .4
g_uncons 2
g_push 1
g_pushint 1
g_push 4
g_pushglobal ringInt
g_pushglobal sub
g_mkap 3
g_pushglobal take.L1
g_mkap 2
g_push 1
g_updcons 1, 2, 5
g_pop 4
g_return
g_jump .5
g_label .5
g_jump .2
g_label .1
g_pop 1
g_pushglobal C.0.0
g_update 3
g_pop 2
g_unwind
g_label .2

g_globstart replicate.L1, 2
g_pushint 0
g_push 1
g_pushglobal ordInt
g_pushglobal le
g_mkap 3
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_push 1
g_pushint 1
g_push 2
g_pushglobal ringInt
g_pushglobal sub
g_mkap 3
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

g_globstart zip_with.L1, 3
g_push 1
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
g_push 4
g_eval
g_jumpcase .3, .4
g_label .3
g_pop 1
g_pushglobal C.0.0
g_update 6
g_pop 5
g_unwind
g_label .4
g_uncons 2
g_push 1
g_push 4
g_push 6
g_pushglobal zip_with.L1
g_mkap 3
g_push 1
g_push 4
g_push 7
g_mkap 2
g_updcons 1, 2, 8
g_pop 7
g_return
g_jump .5
g_label .5
g_jump .2
g_label .2

g_globstart monadIO.pure.L1, 0
g_pushglobal C.0.2
g_update 1
g_unwind

g_globstart monadIO.pure.L2, 1
g_push 0
g_pushglobal monadIO.pure.L1
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

g_globstart diff.L1, 2
g_push 0
g_eval
g_jumpcase .0, .1
g_label .0
g_pop 1
g_pushglobal C.0.0
g_update 3
g_pop 2
g_unwind
g_label .1
g_uncons 2
g_push 3
g_eval
g_jumpcase .3, .4
g_label .3
g_pop 3
g_update 2
g_pop 1
g_unwind
g_label .4
g_uncons 2
g_push 0
g_push 3
g_pushglobal ordInt
g_pushglobal lt
g_mkap 3
g_eval
g_jumpcase .6, .7
g_label .6
g_pop 1
g_push 0
g_push 3
g_pushglobal eqInt
g_pushglobal eq
g_mkap 3
g_eval
g_jumpcase .9, .10
g_label .9
g_pop 1
g_push 1
g_push 5
g_pushglobal diff.L1
g_updap 2, 7
g_pop 6
g_unwind
g_label .10
g_pop 1
g_push 1
g_push 4
g_pushglobal diff.L1
g_updap 2, 7
g_pop 6
g_unwind
g_label .11
g_jump .8
g_label .7
g_pop 1
g_push 5
g_push 4
g_pushglobal diff.L1
g_mkap 2
g_push 3
g_updcons 1, 2, 7
g_pop 6
g_return
g_jump .8
g_label .8
g_jump .5
g_label .5
g_jump .2
g_label .2

g_globstart ints.L1, 2
g_pushint 1
g_push 2
g_pushglobal ringInt
g_pushglobal add
g_mkap 3
g_push 1
g_mkap 1
g_push 2
g_updcons 1, 2, 3
g_pop 2
g_return

g_globstart solve_aux.L1, 3
g_pushglobal C.0.0
g_push 3
g_push 2
g_pushglobal ringInt
g_pushglobal add
g_mkap 3
g_cons 1, 2
g_push 1
g_cons 1, 2
g_push 3
g_push 2
g_pushglobal ringInt
g_pushglobal sub
g_mkap 3
g_cons 1, 2
g_push 2
g_pushglobal diff.L1
g_updap 2, 4
g_pop 3
g_unwind

g_globstart solve_aux.L2, 2
g_pushglobal ints
g_push 1
g_push 3
g_pushglobal solve_aux.L1
g_mkap 1
g_pushglobal zip_with.L1
g_mkap 3
g_pushglobal solve_aux
g_mkap 1
g_push 2
g_pushglobal C.1.2
g_mkap 1
g_pushglobal functorList
g_pushglobal map
g_updap 3, 3
g_pop 2
g_unwind

g_globstart main.L1, 1
g_push 0
g_pushglobal solve
g_mkap 1
g_pushglobal foldableList
g_pushglobal length
g_mkap 2
g_pushglobal print
g_updap 1, 2
g_pop 1
g_unwind
