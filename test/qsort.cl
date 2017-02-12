letrec foldr f y0 xs =
  if is_nil xs then
    y0
  else f (hd xs) (foldr f y0 (tl xs))
in
letrec take n xs =
  if n <= 0 || is_nil xs then
    nil
  else
    cons (hd xs) (take (n-1) (tl xs))
in
let print_list = foldr print (neg 1) in
letrec gen f x = cons x (gen f (f x)) in
let numbers = take 112 (gen (fun x -> (23*x) % 113) 1) in
letrec partition p xs =
  if is_nil xs then
    mk_pair nil nil
  else
    let x = hd xs in
    let yzs = partition p (tl xs) in
    let ys = fst yzs in
    let zs = snd yzs in
    if p (hd xs) then
      mk_pair (cons x ys) zs
    else
      mk_pair ys (cons x zs)
in
letrec append xs ys =
  if is_nil xs then
    ys
  else
    cons (hd xs) (append (tl xs) ys)
in
letrec qsort xs =
  if is_nil xs then
    nil
  else
    let x = hd xs in
    let yzs = partition (fun y -> y < x) (tl xs) in
    append (qsort (fst yzs)) (cons x (qsort (snd yzs)))
in
let main = print_list (qsort numbers) in
main
