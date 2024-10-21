%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h" 
int yylex();
void yyerror(char* message);
%}

whitespace  [ \t\n]
skip_spaces {whitespace}+
digit       [0-9]
digits      {digit}+
fraction    \.{digits}
exponent    [Ee][+-]?{digits}
num_pattern [-+]?{digits}{fraction}?{exponent}?
identifier  [a-zA-Z_]+

%%

"set"       { return(SET); }
{skip_spaces} { /* Ignore spaces and tabs */ }
{num_pattern} { yylval.num = atoi(yytext); return(NUM); }
"("         { return(LP); }
")"         { return(RP); }
"**"        { yylval.id = strdup(yytext); return(EXP); }
"+"         { yylval.id = strdup(yytext); return(PLUS); }
"-"         { yylval.id = strdup(yytext); return(MINUS); }
"*"         { yylval.id = strdup(yytext); return(MUL); }
"/"         { yylval.id = strdup(yytext); return(DIV); }
"%"         { yylval.id = strdup(yytext); return(MOD); }
{identifier} { yylval.id = strdup(yytext); return(ID); }
.           { /* Ignore */ }

%%

int yywrap(void) { return 1; }
