%{
#include "poly.tab.h"
%}

D [2-9]
space [ \t\n]
spaces {space}+


%%

"+" {yylval.id=strdup(yytext); return PLUS; }
"-" {yylval.id=strdup(yytext); return MINUS; }
"^" {yylval.id=strdup(yytext); return POW; }
"0" {yylval.id=strdup(yytext); return ZERO; }
"1" {yylval.id=strdup(yytext); return ONE; }
"x" {yylval.id=strdup(yytext); return VAR; }
{D} { yylval.id=strdup(yytext); return DIGIT; }

{spaces} { /* Ignore */ }
. { printf("Error: Invalid character: %s\n", yytext); }

%%

int yywrap(void)
{
    return 1;
}
