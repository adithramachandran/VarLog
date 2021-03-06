{
  open Parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let lletter = ['a'-'z']
let uletter = ['A'-'Z']
let float = digit+ '.'? digit*
let word = (uletter | lletter) (uletter | lletter | digit | '_')*
let symbol = ('!' | ['#'-'~'])+
let string = '"' (word | digit | white | symbol)+ '"'
let endchar = '\n'*
let comment = '`' (word | digit | white | symbol | endchar)* '`'

rule read =
  parse 
  | comment { END }
  | string { STRING (Lexing.lexeme lexbuf) }
  | white { read lexbuf }
  | "." { DOT }
  | "GRAPH" { GRAPH }
  | "NEWTON" { NEWTON }
  | "SOLVE" {SOLVE}
  | "EXEC" { EXEC }
  | "SETSCALE" { SETSCALE }
  | "INTEGRAL" {INTEGRAL}
  | "DERIVATIVE" {DERIVATIVE}
  | "DISP" { DISP }
  | "GETKEY" { GETKEY }
  | "PROMPT" { PROMPT }
  | "OUTPUT" { OUTPUT }
  | "RANDINT" { RANDINT }
  | "LINE" { LINE }
  | "<-" { RARROW }
  | "[" { LBRACKET }
  | "]" { RBRACKET }
  | "{" { LCURLY }
  | "}" { RCURLY }
  | "->" { ARROW }
  | "*" { TIMES }
  | "+" { PLUS }
  | "-" { SUBT }
  | "/" { DIV }
  | "^" { POW }
  | "C" { COMB }
  | "P" { PERM }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "," {COMMA}
  | "<=" { LEQ }
  | ">=" { GEQ }
  | "!=" { NEQ }
  | "=" { EQ }
  | "<" { LT }
  | ">" { GT }
  | "NOT" { NOT }
  | "XOR" { XOR }
  | "NXOR" { NXOR }
  | "NAND" { NAND }
  | "NOR" { NOR }
  | "!&" { NAND }
  | "!|" { NOR }
  | "&" { AND }
  | "|" { OR }
  | "AND" { AND }
  | "OR" { OR }
  | "SIN" {SIN}
  | "COS" {COS}
  | "TAN" {TAN}
  | "!" { EXCL }
  | "$" { DOLLAR }
  | "RED" { RED }
  | "GREEN" { GREEN }
  | "BLUE" { BLUE }
  | "YELLOW" { YELLOW }
  | "BLACK" { BLACK }
  | "ARCTAN" {ARCTAN}
  | "ARCCOS" {ARCCOS}
  | "ARCSIN" {ARCSIN}
  | "2x2" {TWOVAR}
  | "3x3" {THREEVAR}
  | float { NUM (float_of_string (Lexing.lexeme lexbuf)) }
  | "VAR" { VAR }
  | "?" { QUESTION }
  | ":" { COLON }
  | "STRUCT" { STRUCT }
  | "CLASS" { CLASS }
  | "GOSUB" { GOTOSUB }
  | "RETURN" { RETURN }
  | "GOTO" { GOTO }
  | "LBL" { LBL }
  | "END" { END }
  | "IF" { IF }
  | "THEN" { THEN } 
  | "ELSE" { ELSE }
  | "true" { BOOL (bool_of_string (Lexing.lexeme lexbuf)) }
  | "false" { BOOL (bool_of_string (Lexing.lexeme lexbuf)) }
  | "FUN" {FUN}
  | "MATRIX" {MATRIX}
  | "VARMAT" { VARMAT }
  | "WHILE" { WHILE }
  | endchar { END }
  | word { NAME (Lexing.lexeme lexbuf) }
  | eof { EOF }