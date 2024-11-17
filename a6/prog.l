%{
    /* Include necessary header file for the parser */
    #include "prog.tab.h"
%}

/* Define regex patterns for identifiers and numbers */
IDENT_START  [a-zA-Z_]
NUMBER       [0-9]
IDENT        {IDENT_START}({IDENT_START}|{NUMBER})*
NUMB         [+-]?[0-9]+

%%

"loop while"  { return LOOP_WHILE_KWRD; }
"set"         { return SET; }
"when"        { return WHEN; }
{IDENT}       { 
                  yylval.str = strdup(yytext); 
                  return ID; 
                }
{NUMB}        { 
                  yylval.num = atoi(yytext); 
                  return NUMB; 
                }
"+"           { return ADD; }
"-"           { return SUB; }
"*"           { return MUL; }
"/"           { return DIV; }
"%"           { return MOD; }
"("           { return LPAREN; }
")"           { return RPAREN; }
"="           { return EQ; }
"/="          { return NEQ; }
"<"           { return LT; }
"<="          { return LTE; }
">"           { return GT; }
">="          { return GTE; }
[ \t\n]+      { /* do nothing */ }
.             { /* do nothing or print error if necessary */ }

%%

/* Function to handle end-of-file or input wrapping */
int yywrap(void) {
    return 1;  /* Return 1 to indicate the end of input */
}
