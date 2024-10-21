%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "poly.h"

struct Node;
// typedef struct Node Node;

void yyerror(const char* s)
{
    fprintf(stderr, "%s\n", s);
}
%}

// Define tokens
%token <id> PLUS MINUS POW ZERO ONE VAR DIGIT
%type <node> S P T X N M
%start S


%union {
    char* id;
    struct Node* node;
}




%%
// Grammer rule 

S: 
    P
    {
        root = createnode("S");
        root = addchild(root, $1);
    }
    | PLUS P
    {
        root = createnode("S");
        root = addchild(root, createnode($1));
        root = addchild(root, $2);
    }
    |MINUS P
    {
        root = createnode("S");
        root = addchild(root, createnode($1));
        root = addchild(root, $2);
    }
    ;


P:
    T PLUS P
    {
        $$ = createnode("P");
        $$ = addchild($$, $1);
        $$ = addchild($$, createnode($2));
        $$ = addchild($$, $3);
    }
    |T MINUS P
    {
        $$ = createnode("P");
        $$ = addchild($$, $1);
        $$ = addchild($$, createnode($2));
        $$ = addchild($$, $3);
    }
    |T
    {
        $$ = createnode("P");
        $$ = addchild($$, $1);
    }
    ;

T: 
    ONE
    {
        $$ = createnode("T");
        $$ = addchild($$, createnode($1));
    }
    |N
    {
        $$ = createnode("T");
        $$ = addchild($$, $1);
    }
    |X
    {
        $$ = createnode("T");
        $$ = addchild($$, $1);
    }
    |N X
    {
        $$ = createnode("T");
        $$ = addchild($$, $1);
        $$ = addchild($$, $2);
    }
    ;

X:
    VAR
    {
        $$ = createnode("X");
        $$ = addchild($$, createnode($1));
    }
    | VAR POW N
    {
        $$ = createnode("X");
        $$ = addchild($$, createnode($1));
        $$ = addchild($$, createnode($2));
        $$ = addchild($$, $3);
    }

N:
    DIGIT
    {
        $$ = createnode("N");
        $$ = addchild($$, createnode($1));
    }
    | DIGIT M
    {
        $$ = createnode("N");
        $$ = addchild($$, createnode($1));
        $$ = addchild($$, $2);
    }
    | ONE M
    {
        $$ = createnode("N");
        $$ = addchild($$, createnode($1));
        $$ = addchild($$, $2);
    }
    ;

M:
    DIGIT
    {
        $$ = createnode("M");
        $$ = addchild($$, createnode($1));
    }
    | DIGIT M
    {
        $$ = createnode("M");
        $$ = addchild($$, createnode($1));
        $$ = addchild($$, $2);
    }
    | ONE M
    {
        $$ = createnode("M");
        $$ = addchild($$, createnode($1));
        $$ = addchild($$, $2);
    }
    | ZERO
    {
        $$ = createnode("M");
        $$ = addchild($$, createnode($1));
    }
    | ONE
    {
        $$ = createnode("M");
        $$ = addchild($$, createnode($1));
    }
    | ZERO M
    {
        $$ = createnode("M");
        $$ = addchild($$, createnode($1));
        $$ = addchild($$, $2);
    }
    ;

%%