
%{
    #include "expr.tab.h"   
    #include "expr.tab.c"
    
   
%}


%%

"set"       {return set;}
[_a-zA-Z][_a-zA-Z0-9]*        {yylval.id = strdup(yytext); return ID;}
[-]?[0-9]+       {yylval.num = atoi(yytext);return NUM;}
"**"        {return '^';}
[+-/*%]        {return yytext[0];}
"("         {return  '(';}
")"         {return  ')';}
[ \t\n]        {}
.           {printf("Unrecognized character: %s\n", yytext);}

%%

int yywrap(void){return 1;}
