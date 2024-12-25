%{
#include <stdio.h>
void yyerror(const char *s);
int yylex();

extern int quad_count;

%}

%code requires {
    #include "codegen.h"
}

%union{
    char *str;
    int num;
    struct {
        char *addr;    // Address for expressions
        int truelist;  // For boolean expressions
        int falselist; // For boolean expressions
        int nextlist;  // For statements
    } code;
}

// Token declarations
%token <str> ID
%token <num> NUMB 
%token SET WHEN LOOP_WHILE_KWRD
%token <str> ADD SUB MUL DIV MOD 
%token <str> EQ NEQ LT GT LTE GTE LPAREN RPAREN

// Non-terminal declarations
%type <code> LIST STMT ASGN COND LOOP EXPR ATOM
%type <str> OPER RELN
%type <num> M BOOL

%%

program : LIST
        ;

LIST    : STMT
        {
            $$ = $1;
        }
        | STMT LIST
        {
            $$ = $1; //change for branching
        }
        ;

STMT    : ASGN
        {
            $$ = $1;
        }
        | COND
        {

        }
        | LOOP
        {

        }
        ;

ASGN    : LPAREN SET ID ATOM RPAREN
        {
            emit("=", $4.addr, "", $3);
        }
        ;

COND    : LPAREN WHEN BOOL LIST M RPAREN
        {
            backpatch($3, $5);
            addBlock($3+1);
            addBlock($5);
        }
        ;

LOOP    : LPAREN LOOP_WHILE_KWRD BOOL LIST M RPAREN
        {
            backpatch($3, $5+1);
            addBlock($5+1);
            addBlock($3+1);   
            char gotoLabel[20];
            sprintf(gotoLabel, "%d", $3);
            emit("goto", "", "", gotoLabel);
            addBlock($3);

        }
        ;

EXPR    : LPAREN OPER ATOM ATOM RPAREN
        {
            $$.addr = newtemp();
            emit($2, $3.addr, $4.addr, $$.addr);
        }
        ;

BOOL    : LPAREN RELN ATOM ATOM RPAREN
        {
            $$ = quad_count;
            char arg1[20];
            sprintf(arg1, "%s %s %s", $3.addr, $2, $4.addr);
            emit("ifFalse", arg1, "goto", "");
        }
        ;

ATOM    : ID
        {
            $$.addr = $1;
        }
        | NUMB
        {
            // Convert int to string
            char buffer[20];
            sprintf(buffer, "%d", $1);
            $$.addr = strdup(buffer); 
        }
        | EXPR
        {
            $$ = $1;
        }
        ;

OPER    : ADD { $$ = "+"; }
        | SUB { $$ = "-"; }
        | MUL { $$ = "*"; }
        | DIV { $$ = "/"; }
        | MOD { $$ = "%"; }
        ;

RELN    : EQ  { $$ = "=="; }
        | NEQ { $$ = "/="; }
        | LT  { $$ = "<"; }
        | GT  { $$ = ">"; }
        | LTE { $$ = "<="; }
        | GTE { $$ = ">="; }
        ;
M       :
        {$$ = quad_count;}

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parser error: %s\n", s);
}