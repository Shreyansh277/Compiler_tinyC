%{
#include"tinyC2_22CS30010_22CS30030.tab.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"tinyC2_22CS30010_22CS30030.h"
%}




identifier-nondigit [a-zA-Z_]
digit [0-9]
non_zero_digit [1-9]

identifier {identifier-nondigit}({identifier-nondigit}|{digit})*

integer_constant ({non_zero_digit}{digit}*)
escape-sequence \\['"\\?abfnrtv]
c-char ([^'\\\\n])|({escape-sequence})
c-char-sequence {c-char}+
character_constant {c-char-sequence}
digit-sequence {digit}+
sign [-+]
exponent-part [eE]{sign}?{digit-sequence}
fractional-constant ({digit-sequence}?\.{digit-sequence})|{digit-sequence}\.
floating-constant  ({fractional-constant}{exponent-part}?)|({digit-sequence}{exponent-part})
constant ({integer_constant})|({floating-constant})|('{c-char-sequence}')

s-char  ([^"\\\n])|\\['"\\?abfnrtv]
s-char-sequence {s-char}+
string-literal \"{s-char}*\"




single_line_comment ("//")[^\n\r]*
multiline_comment  ("/*")([^*]|(\*[^/]))*("*/")
comments {single_line_comment}|{multiline_comment}


%%


"auto" {yylval.id = strdup(yytext); return (AUTO);}
"unsigned" {yylval.id = strdup(yytext); return (UNSIGNED);}
"enum" {yylval.id = strdup(yytext); return (ENUM);}
"restrict" {yylval.id = strdup(yytext); return (RESTRICT);}
"break" {yylval.id = strdup(yytext); return (BREAK);}
"extern" {yylval.id = strdup(yytext); return (EXTERN);}
"return" {yylval.id = strdup(yytext); return (RETURN);}
"void" {yylval.id = strdup(yytext); return (VOID);}
"case" {yylval.id = strdup(yytext); return (CASE);}
"float" {yylval.id = strdup(yytext); return (FLOAT);}
"volatile" {yylval.id = strdup(yytext); return (VOLATILE);}
"short" {yylval.id = strdup(yytext); return (SHORT);}
"char" {yylval.id = strdup(yytext); return (CHAR);}
"for" {yylval.id = strdup(yytext); return (FOR);}
"signed" {yylval.id = strdup(yytext); return (SIGNED);}
"while" {yylval.id = strdup(yytext); return (WHILE);}
"const" {yylval.id = strdup(yytext); return (CONST);}
"goto" {yylval.id = strdup(yytext); return (GOTO);}
"sizeof" {yylval.id = strdup(yytext); return (SIZEOF);}
"_Bool" {yylval.id = strdup(yytext); return (BOOL);}
"continue" {yylval.id = strdup(yytext); return (CONTINUE);}
"if" {yylval.id = strdup(yytext); return (IF);}
"else" {yylval.id = strdup(yytext); return (ELSE);}
"static" {yylval.id = strdup(yytext); return (STATIC);}
"_Complex" {yylval.id = strdup(yytext); return (COMPLEX);}
"default" {yylval.id = strdup(yytext); return (DEFAULT);}
"inline" {yylval.id = strdup(yytext); return (INLINE);}
"struct" {yylval.id = strdup(yytext); return (STRUCT);}
"_Imaginary" {yylval.id = strdup(yytext); return (IMAGINARY);}
"do" {yylval.id = strdup(yytext); return (DO);}
"int" {yylval.id = strdup(yytext); return (INT);}
"switch" {yylval.id = strdup(yytext); return (SWITCH);}
"double" {yylval.id = strdup(yytext); return (DOUBLE);}
"long" {yylval.id = strdup(yytext); return (LONG);}
"typedef" {yylval.id = strdup(yytext); return (TYPEDEF);}
"register" {yylval.id = strdup(yytext); return (REGISTER);}
"union" {yylval.id = strdup(yytext); return (UNION);}

"[" {yylval.id = strdup(yytext); return (LEFT_BRACKET);}
"]" {yylval.id = strdup(yytext); return (RIGHT_BRACKET);}
"(" {yylval.id = strdup(yytext); return (LEFT_PARENTHESIS);}
")" {yylval.id = strdup(yytext); return (RIGHT_PARENTHESIS);}
"{" {yylval.id = strdup(yytext); return (LEFT_BRACE);}
"}" {yylval.id = strdup(yytext); return (RIGHT_BRACE);}
"." {yylval.id = strdup(yytext); return (DOT);}
"->" {yylval.id = strdup(yytext); return (ARROW);}
"++" {yylval.id = strdup(yytext); return (INCREMENT);}
"--" {yylval.id = strdup(yytext); return (DECREMENT);}
"&" {yylval.id = strdup(yytext); return (AMPERSAND);}
"*" {yylval.id = strdup(yytext); return (ASTERISK);}
"+" {yylval.id = strdup(yytext); return (PLUS);}
"-" {yylval.id = strdup(yytext); return (MINUS);}
"~" {yylval.id = strdup(yytext); return (TILDE);}
"!" {yylval.id = strdup(yytext); return (EXCLAMATION);}
"/" {yylval.id = strdup(yytext); return (SLASH);}
"%" {yylval.id = strdup(yytext); return (PERCENT);}
"<<" {yylval.id = strdup(yytext); return (LEFT_SHIFT);}
">>" {yylval.id = strdup(yytext); return (RIGHT_SHIFT);}
"<" {yylval.id = strdup(yytext); return (LESS_THAN);}
">" {yylval.id = strdup(yytext); return (GREATER_THAN);}
"<=" {yylval.id = strdup(yytext);return (LESS_EQUAL);}
">=" {yylval.id = strdup(yytext); return (GREATER_EQUAL);}
"==" {yylval.id = strdup(yytext); return (EQUALS);}
"!=" {yylval.id = strdup(yytext); return (NOT_EQUALS);}
"^" {yylval.id = strdup(yytext); return (CARET);}
"|" {yylval.id = strdup(yytext); return (PIPE);}
"&&" {yylval.id = strdup(yytext); return (AND);}
"||" {yylval.id = strdup(yytext); return (OR);}
"?" {yylval.id = strdup(yytext); return (QUESTION_MARK);}
":" {yylval.id = strdup(yytext); return (COLON);}
";" {yylval.id = strdup(yytext); return (SEMICOLON);}
"..." {yylval.id = strdup(yytext); return (ELLIPSIS);}
"=" {yylval.id = strdup(yytext); return (ASSIGN);}
"*=" {yylval.id = strdup(yytext); return (MULTIPLY_ASSIGN);}
"/=" {yylval.id = strdup(yytext); return (DIVIDE_ASSIGN);}
"%=" {yylval.id = strdup(yytext); return (MODULO_ASSIGN);}
"+=" {yylval.id = strdup(yytext); return (PLUS_ASSIGN);}
"-=" {yylval.id = strdup(yytext); return (MINUS_ASSIGN);}
"<<=" {yylval.id = strdup(yytext); return (LEFT_SHIFT_ASSIGN);}
">>=" {yylval.id = strdup(yytext); return (RIGHT_SHIFT_ASSIGN);}
"&=" {yylval.id = strdup(yytext); return (AND_ASSIGN);}
"^=" {yylval.id = strdup(yytext); return (XOR_ASSIGN);}
"|=" {yylval.id = strdup(yytext); return (OR_ASSIGN);}
"," {yylval.id = strdup(yytext); return (COMMA);}
"#" {yylval.id = strdup(yytext);return (HASH);}

{identifier} {yylval.id = strdup(yytext); return(IDENTIFIER);}
{constant}  {yylval.id = strdup(yytext); return(CONSTANT);} 
{string-literal} {yylval.id = strdup(yytext); return(STRING_LITERAL);}

{single_line_comment}   {}
{multiline_comment}   {}
%%
int yywrap(void)
{
    return 1;
}