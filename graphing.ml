open Graphics



(* let _ = size_x ()
   let _ = size_y () *)
(* let _ = plot 100 100
   let _ = plot 101 101
   let _ = plot 102 102
   let _ = plot 103 103
   let _ = plot 104 104
   let _ = plot 105 105
   let _ = plot 106 106
   let _ = plot 107 107 *)






let linear a b inputs = b

(* 
let draw_string_v s =

  let (xi,yi) = Graphics.current_point()
  and l = String.length s
  and (_,h) = Graphics.text_size s
  in
  Graphics.draw_char s.[0];
  for i=1 to l-1 do
    let (_,b) = Graphics.current_point()
    in Graphics.moveto xi (b-h);
    Graphics.draw_char s.[i]
  done;
  let (a,_) = Graphics.current_point() in Graphics.moveto a yi *)



(* let _ = moveto 2 130 *)
(* let _ = draw_string_v "abscissa" *)

(* let _ = moveto 135 280  *)
(* let _ = draw_string_v "ordinate" *)

(* 
let scale ((a,b,c,d) : (int * int * int * int)) : unit = 
  match (a,b,c,d) with 
  | a -> begin 
     *)

(** [xpix_to_coord x] is the coordinate value for the pixel [x]
    pixels away from the left bound of the graph. *)


(* 
let _ = moveto 0 (ycoord_to_pix (0. |> func |> xpix_to_coord) |> int_of_float) 
*)

let rec graph_func xi xa yi ya x f =
  let _ = open_graph "" in
  let _ = set_window_title "Graph 2-D Functions" in
  let window_height = 800 in
  let window_width = 800 in

  let x_min = xi in
  let x_max = xa in
  let y_min = yi in
  let y_max = ya in

  let pixel_width = 
    (x_max -. x_min) /. (float_of_int window_width) in
  let pixel_height = 
    (y_max -. y_min) /. (float_of_int window_height) in

  let _ = resize_window window_width window_height in

  let _ = moveto 0 (window_height / 2) in
  let _ = Graphics.lineto window_width (window_height / 2) in

  let _ = moveto (window_width / 2) 0 in
  let _ = Graphics.lineto (window_width / 2) window_height in

  let xpix_to_coord x = x_min +. pixel_width *. x in

  let ycoord_to_pix y = (y -. y_min) /. pixel_height in

  let _ = moveto 0 (ycoord_to_pix (0. |> f |> xpix_to_coord) |> int_of_float) 
  in

  let rec helper x = 
    if x >= window_width then () 
    else begin
      Graphics.lineto 
        x 
        (x 
         |> float_of_int 
         |> xpix_to_coord 
         |> f
         |> ycoord_to_pix 
         |> int_of_float); 
      helper (x+1)
    end
  in helper 0

(* let _ = graph_func 0 func *)