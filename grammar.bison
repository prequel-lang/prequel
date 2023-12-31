%define lr.default-reduction accepting

%token NONE

%precedence "is" "is_not"
%left       "or"
%left       "and"
%left       "|"
%left       "^"
%left       "&"
%precedence "~"
%left       "<<" ">>"
%nonassoc   "=" "<>"
%nonassoc   "<" "<=" ">" ">="
%left       "+" "-"
%left       "*" "/" "%" "//"
%precedence "not"
%precedence UNOP

%%

prequel_program
  : opt_module_header
    module
    opt_module_defs                                                          {}
  ;

opt_module_header
  : %empty                                                                   {}
  | module_header                                                            {}
  ;

module_header
  : "@module_name" ":" "\n"                                                  {}
  ;

module
  : instructions                                                             {}
  ;

opt_module_defs
  : %empty                                                                   {}
  | module_def
    opt_module_defs                                                          {}
  ;

module_def
  : module_header
    module                                                                   {}
  ;

opt_instructions
  : %empty                                                                   {}
  | instructions                                                             {}
  ;

instructions
  : instruction "\n"
    opt_instructions                                                         {}
  ;

instruction
  : assignment                                                               {}
  | assignment_random                                                        {}
  | unassign                                                                 {}
  | push                                                                     {}
  | queue                                                                    {}
  | pop                                                                      {}
  | unqueue                                                                  {}
  | if                                                                       {}
  | repeat                                                                   {}
  | procedure_call                                                           {}
  | debugl                                                                   {}
  ;

assignment
  : retvars ":=" expr                                                        {}
  | retvars ":=" mvar opt_indexes ".pop" "(" opt_expr ")"                    {}
  | retvars ":=" mvar opt_indexes ".unqueue" "(" ")"                         {}
  | retvars ":=" procedure_name "(" opt_args ")"                             {}
  | mvar opt_indexes "++"                                                    {}
  | mvar opt_indexes "--"                                                    {}
  | mvar opt_indexes "~~"                                                    {}
  | mvar opt_indexes "+=" expr                                               {}
  | mvar opt_indexes "-=" expr                                               {}
  | mvar opt_indexes "*=" expr                                               {}
  | mvar opt_indexes "/=" expr                                               {}
  | mvar opt_indexes "%=" expr                                               {}
  | mvar opt_indexes "//=" expr                                              {}
  | mvar opt_indexes "&=" expr                                               {}
  | mvar opt_indexes "|=" expr                                               {}
  | mvar opt_indexes "^=" expr                                               {}
  | mvar opt_indexes "<<=" expr                                              {}
  | mvar opt_indexes ">>=" expr                                              {}
  ;

assignment_random
  : mvar opt_indexes ":~" "random"                                           {}
  | mvar opt_indexes ":~" expr                                               {}
  ;

unassign
  : mvar ".unassign"                                                         {}
  ;

push
  : mvar opt_indexes ".push" "(" expr ")"                                    {}
  | mvar opt_indexes ".push" "(" expr "," expr ")"                           {}
  ;

queue
  : mvar opt_indexes ".queue" "(" expr ")"                                   {}
  ;

pop
  : mvar opt_indexes ".pop" "(" opt_expr ")"                                 {}
  ;

unqueue
  : mvar opt_indexes ".unqueue" "(" ")"                                      {}
  ;

if
  : "if" expr "\n"
     opt_instructions
    opt_elsifs
    opt_else
    "endif"                                                                  {}
  ;

opt_elsifs
  : %empty                                                                   {}
  | elsifs                                                                   {}
  ;

elsifs
  : elsif opt_elsifs                                                         {}
  ;

elsif
  : "elsif" expr "\n"
     opt_instructions                                                        {}
  ;

opt_else
  : %empty                                                                   {}
  | else                                                                     {}
  ;

else
  : "else" "\n"
     opt_instructions                                                        {}
  ;

repeat
  : "repeat" "ivar" "\n"
     opt_instructions_repeat
    "endrep"                                                                 {}
  ;

opt_instructions_repeat
  : %empty                                                                   {}
  | instructions_repeat                                                      {}
  ;

instructions_repeat
  : instruction "\n"
    opt_instructions_repeat                                                  {}
  | "repnext" "\n"
    opt_instructions_repeat                                                  {}
  | "repstop" "\n"
    opt_instructions_repeat                                                  {}
  ;

procedure_call
  : procedure_name "(" opt_args ")"                                          {}
  ;

debugl
  : "debugl" "(" debugl_args ")"                                             {}
  ;

opt_indexes
  : %empty                                                                   {}
  | indexes                                                                  {}
  ;

indexes
  : index opt_indexes                                                        {}
  ;

index
  : "[" expr "]"                                                             {}
  ;

expr
  : "(" expr ")"                                                             {}
  | expr "or" expr                                                           {}
  | expr "and" expr                                                          {}
  | "not" expr                                                               {}
  | expr "is" expr_type                                                      {}
  | expr "is_not" expr_type                                                  {}
  | expr "=" expr                                                            {}
  | expr "<>" expr                                                           {}
  | expr "<" expr                                                            {}
  | expr "<=" expr                                                           {}
  | expr ">" expr                                                            {}
  | expr ">=" expr                                                           {}
  | expr "+" expr                                                            {}
  | expr "-" expr                                                            {}
  | expr "*" expr                                                            {}
  | expr "/" expr                                                            {}
  | expr "%" expr                                                            {}
  | expr "//" expr                                                           {}
  | "~" expr                                                                 {}
  | expr "|" expr                                                            {}
  | expr "^" expr                                                            {}
  | expr "&" expr                                                            {}
  | expr "<<" expr                                                           {}
  | expr ">>" expr                                                           {}
  | "-" expr %prec UNOP                                                      {}
  | "+" expr %prec UNOP                                                      {}
  | "[" opt_exprs "]" opt_indexes                                            {}
  | number                                                                   {}
  | "evar" opt_indexes                                                       {}
  | "evar" opt_indexes ".length"                                             {}
  | "evar" opt_indexes ".size"                                               {}
  | "evar" opt_indexes ".nsize"                                              {}
  | "evar" opt_indexes ".lsize"                                              {}
  | "evar" opt_indexes ".indexof" "(" expr ")"                               {}
  | "evar" opt_indexes ".indexof" "(" expr "," expr ")"                      {}
  | mvar opt_indexes                                                         {}
  | mvar opt_indexes ".length"                                               {}
  | mvar opt_indexes ".size"                                                 {}
  | mvar opt_indexes ".nsize"                                                {}
  | mvar opt_indexes ".lsize"                                                {}
  | mvar opt_indexes ".indexof" "(" expr ")"                                 {}
  | mvar opt_indexes ".indexof" "(" expr "," expr ")"                        {}
  | math_factor                                                              {}
  ;

number
  : "decimal"                                                                {}
  | "binary"                                                                 {}
  | "hexadecimal"                                                            {}

math_factor
  : "math.abs" "(" expr ")"                                                  {}
  | "math.acos" "(" expr ")"                                                 {}
  | "math.asin" "(" expr ")"                                                 {}
  | "math.atan" "(" expr ")"                                                 {}
  | "math.atan2" "(" expr "," expr ")"                                       {}
  | "math.ceil" "(" expr ")"                                                 {}
  | "math.cos" "(" expr ")"                                                  {}
  | "math.e"                                                                 {}
  | "math.exp" "(" expr ")"                                                  {}
  | "math.exp2" "(" expr ")"                                                 {}
  | "math.floor" "(" expr ")"                                                {}
  | "math.log" "(" expr ")"                                                  {}
  | "math.log2" "(" expr ")"                                                 {}
  | "math.max" "(" expr "," expr ")"                                         {}
  | "math.min" "(" expr "," expr ")"                                         {}
  | "math.pi"                                                                {}
  | "math.pow" "(" expr "," expr ")"                                         {}
  | "math.round" "(" expr ")"                                                {}
  | "math.sign" "(" expr ")"                                                 {}
  | "math.sin" "(" expr ")"                                                  {}
  | "math.sqrt" "(" expr ")"                                                 {}
  | "math.tan" "(" expr ")"                                                  {}
  ;

opt_expr
  : %empty                                                                   {}
  | expr                                                                     {}
  ;

opt_exprs
  : %empty                                                                   {}
  | exprs                                                                    {}
  ;

exprs
  : expr opt_comma                                                           {}
  | expr "," exprs                                                           {}
  ;

opt_comma
  : %empty                                                                   {}
  | ","                                                                      {}
  ;

expr_type
  : "number"                                                                 {}
  | "list"                                                                   {}
  | "empty"                                                                  {}
  | "procedure"                                                              {}
  | "undefined"                                                              {}
  ;

procedure_name
  : "evar"                                                                   {}
  | "call"                                                                   {}
  | "return"                                                                 {}
  ;

opt_args
  : %empty                                                                   {}
  | args                                                                     {}
  ;

args
  : arg opt_comma                                                            {}
  | arg "," args                                                             {}
  ;

arg
  : expr                                                                     {}
  | "@module_name"                                                           {}
  | mvar_ref                                                                 {}
  | "string"                                                                 {}
  ;

mvar_ref
  : "&" mvar opt_indexes                                                     {}
  ;

retvars
  : retvar opt_comma                                                         {}
  | retvar "," retvars                                                       {}
  ;

retvar
  : mvar opt_indexes                                                         {}
  ;

mvar
  : "ivar"                                                                   {}
  | "csvar"                                                                  {}
  ;

debugl_args
  : debugl_arg opt_comma                                                     {}
  | debugl_arg "," debugl_args                                               {}
  ;

debugl_arg
  : expr                                                                     {}
  | "string"                                                                 {}
  ;

%%

{
/*

ivar
  = ivar_start_char { ivar_char }

ivar_start_char
  = "_"
  | alpha

ivar_char
  = "_"
  | alphanum

csvar
  = "!" ivar [ @module_name ]

evar
  = ivar "." ivar { "." ivar }

@module_name
  = "@" module_name_start_char { module_name_char }

module_name_start_char
  = "_"
  | alpha

module_name_char
  = "_"
  | alphanum

alphanum
  = alpha
  | d_digit

decimal
  = d_digit { d_digit } [ "." d_digit { d_digit } ]

binary
  = "0b" b_digit { b_digit } [ "." b_digit { b_digit } ]

hexadecimal
  = "0x" h_digit { h_digit } [ "." h_digit { h_digit } ]

string
  = """ { string_char } """

alpha
  = "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i"
  | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r"
  | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z"
  | "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I"
  | "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R"
  | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z"

d_digit
  = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"

b_digit
  = "0" | "1"

h_digit
  = d_digit
  | "a" | "b" | "c" | "d" | "e" | "f"
  | "A" | "B" | "C" | "D" | "E" | "F"

string_char
  = "\\"
  | "\""
  | "\n"
  | not_backslash_char   // ascii code between 32 and 126, except "\"

"\n"
  = line_feed_char       // ascii code 10

*/
}
