%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define the node structure used in the symbol table and expression tree
 struct _Node {
    int nodeType;        
    char *identifier;    
    char operation;      
    struct _Node *nextNode; 
    int value;           
    struct _Node *leftChild, *rightChild; 
};

typedef struct _Node node;


typedef node* SymbolTable;

SymbolTable symTable = NULL; // Initialize the symbol table


int yylex();
void yyerror(char *message);


// Function declarations
SymbolTable addToSymbolTable(SymbolTable symTable, char *identifier);
SymbolTable lookupSymbol(SymbolTable symTable, char *identifier);
void assignValue(SymbolTable symbol, int value);
int retrieveValue(SymbolTable symbol);
SymbolTable createLeafNode(int value);
SymbolTable createOperatorNode(char operation, SymbolTable leftChild, SymbolTable rightChild);
int evaluateExpressionTree(SymbolTable tree);
void destroyExpressionTree(SymbolTable tree);

%}

%union {
   struct _Node * ptr;     // Pointer for symbol table entries or expression trees
    char* id;      // Identifier
    char op;       // Operator
    int num;       // Number
}

%start PROGRAM

%token <id> ID
%token <num> NUM
%token PLUS MINUS MUL DIV MOD EXP SET LP RP
%type <ptr> STATEMENT SET_STATEMENT EXPR_STATEMENT EXPR ARG PROGRAM
%type <op> OPERATOR

%%

PROGRAM:
    STATEMENT PROGRAM
    | STATEMENT
    ;

STATEMENT:
    SET_STATEMENT
    | EXPR_STATEMENT
    ;

SET_STATEMENT:
    LP SET ID NUM RP { 
                        SymbolTable tempSym = addToSymbolTable(symTable, $3);
                        if(tempSym == symTable){
                            tempSym = lookupSymbol(symTable, $3); 
                            assignValue(tempSym, $4); 
                            printf("Variable %s is set to %d\n", $3, retrieveValue(tempSym));
                        }
                        else{
                            symTable = tempSym;
                            assignValue(symTable, $4); 
                            printf("Variable %s is set to %d\n", $3, $4);
                        }
                    }
    | LP SET ID ID RP  { 
                        SymbolTable targetSym = addToSymbolTable(symTable, $3);
                        if(targetSym == symTable) targetSym = lookupSymbol(symTable, $3);
                        else symTable = targetSym;
                        SymbolTable sourceSym = lookupSymbol(symTable, $4); 
                        if (sourceSym) {
                            assignValue(targetSym, retrieveValue(sourceSym)); 
                            printf("Variable %s is set to %d\n", $3, retrieveValue(targetSym));
                        } else {
                            printf("Error: Variable %s not found\n", $4);
                        }
                      }
    | LP SET ID EXPR RP { 
                          SymbolTable targetSym = addToSymbolTable(symTable, $3);
                          if(targetSym == symTable) targetSym = lookupSymbol(symTable, $3);
                          else symTable = targetSym;
                          assignValue(targetSym, evaluateExpressionTree($4)); 
                          printf("Variable %s is set to %d\n", $3, evaluateExpressionTree($4));
                          destroyExpressionTree($4);
                        }
    ;

EXPR_STATEMENT:
    EXPR { 
            printf("Standalone expression evaluates to %d\n", evaluateExpressionTree($1)); 
            destroyExpressionTree($1);
          }
    ;

EXPR:
    LP OPERATOR ARG ARG RP { $$ = createOperatorNode($2, $3, $4); }
    ;

OPERATOR:
    PLUS { $$ = '+'; }
    | MINUS { $$ = '-'; }
    | MUL { $$ = '*'; }
    | DIV { $$ = '/'; }
    | MOD { $$ = '%'; }
    | EXP { $$ = 'E'; }
    ;

ARG:
    ID   { 
            SymbolTable sym = lookupSymbol(symTable, $1); 
            if (sym) {
                $$ = createLeafNode(retrieveValue(sym)); 
            } else {
                printf("Error: Variable %s not found\n", $1);
                $$ = createLeafNode(0);
            }
          }
    | NUM  { $$ = createLeafNode($1); }
    | EXPR { $$ = $1; }
    ;

%%

// Error handling function
void yyerror(char *message){
    printf("Error: %s\n", message);
}
