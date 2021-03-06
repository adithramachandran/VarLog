(** 
   This is the module in which inputs are parsed, the AST is sent to eval,
   and the results are sent back to repl.
*)
open Ast 
open Graphing 
open Eval

exception No_keyword 
exception DeterminantZero 

(** [interp s] interprets [s] by lexing and parsing it, 
    evaluating it, and returning either the value in the case of an expression
    input or an indication on the successfulness of the operation otherwise, 
    besides the side-effects entailed *)
val interp : string -> string