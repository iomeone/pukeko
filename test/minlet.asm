g_declare_cafs main
g_declare_main main

g_globstart print, 2
g_eval
g_print
g_cons 0, 0
g_cons 0, 2
g_update 1
g_return

g_globstart id, 1
g_push 0
g_push 0
g_slide 1
g_update 2
g_pop 1
g_unwind

g_globstart main, 0
g_pushint 0
g_pushglobal id, 1
g_mkap
g_pushglobal print, 2
g_mkap
g_update 1
g_pop 0
g_unwind
