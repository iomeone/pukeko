external print : Int -> IO Unit = "print"
let id$ll1 : ∀a. a -> a =
      fun @a ->
        fun (x : a) ->
          let y : a = x in
          y
let id : ∀a. a -> a = fun @a -> id$ll1 @a
let main : IO Unit = print (id @Int 0)
