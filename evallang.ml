open Ast 
open Evalexpr 

module VarLog = struct
  type var = string * value
  type t = ((var list) * ((string * defn) list)) ref

  let empty () : t = ref ([], [])

  let find id vl = 
    try Some (List.assoc id (fst !vl)) with _ -> None

  let bind id v vl = 
    let rec helper = function 
      | [] -> [(id, v)]
      | h :: t -> 
        if (fst h) = id then (id, v) :: t 
        else h :: helper t
    in vl := helper (fst !vl), snd !vl

  let expose vl = fst !vl

  let bind_lbl id d vl = 
    let rec helper = function 
      | [] -> [(id, d)] 
      | h :: t -> 
        if (fst h) = id then failwith "parsing error: 2 lbls of same name"
        else h :: helper t 
    in vl := fst !vl, helper (snd !vl)

  let find_lbl id vl = List.assoc id (snd !vl)
end

let rec eval d vl = 
  match d with 
  | DEnd -> ()
  | DDisp (e, d) -> eval_disp e d vl 
  | DAssign (s, e, d) -> eval_assign s e d vl
  | DIf (e, d1, d2, d3) -> eval_if e d1 d2 d3 vl
  | DLabel (s, d) -> eval d vl 
  | DGoto (s, d) -> eval (VarLog.find_lbl s vl) vl
  | _ -> failwith "Unimplemented"

and eval_disp e d vl = 
  let v = e |> eval_expr (VarLog.expose vl) |> fst |> string_of_val in 
  print_endline v;
  eval d vl
and eval_assign s e d vl =
  let v = e |> eval_expr (VarLog.expose vl) |> fst in 
  VarLog.bind s v vl; eval d vl
and eval_if e d1 d2 d3 vl =
  match e |> eval_expr (VarLog.expose vl) |> fst with 
  | Bool true -> eval d1 vl; eval d3 vl
  | Bool false -> eval d2 vl; eval d3 vl
  | _ -> failwith "precondition violated: if guard"

(** [string_of_val e] converts [e] to a string.
    Requires: [e] is a value. *)
let string_of_val (e : expr) : string =
  match e with
  | Val (Num f) -> string_of_float f
  | Val (Bool b) -> string_of_bool b
  | Val (Str s) -> s
  | _ -> failwith "precondition violated: sov"

let rec find_lbls vl = function 
  | DEnd -> vl 
  | DDisp (_, d) -> find_lbls vl d 
  | DAssign (_, _, d) -> find_lbls vl d 
  | DIf (_, _, _, d) -> find_lbls vl d
  | DGoto (_, d) -> find_lbls vl d 
  | DLabel (s, d) -> VarLog.bind_lbl s d vl; find_lbls vl d
  | _ -> failwith "Unimplemented"

let eval_init d = eval d (find_lbls (VarLog.empty ()) d)