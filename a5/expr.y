%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "intcodegen.h"
    int yylex();
    void yyerror(char *s);
%}

%union {int num; char* id; char op; struct argvals *args;}
%start PROGRAM
%token <num> NUM
%token set
%token <id> ID 
%token <op> '+' '-' '*' '/' '%' '^'
%type <args> EXPR STMT SETSTMT ARG EXPRSTMT
%type <op> OP

%%

PROGRAM :   STMT PROGRAM  
        |   STMT
        ;
STMT    :   SETSTMT {Reg_loc = 2;}
        |   EXPRSTMT {Reg_loc = 2;}
        ;
SETSTMT :   '(' set ID NUM ')'  {
                    head = add_to_symbol_Table($3);
                    printf("\tMEM[%d] = %d;\n", Curr_Mem_loc, $4);
                    printf("\tmprn(MEM, %d);\n", Curr_Mem_loc);
                }
        |   '(' set ID ID ')'   {
                    head = add_to_symbol_Table($3);
                    printf("\tR[0] = MEM[%d];\n", find_mem_loc($4));
                    printf("\tMEM[%d] = R[0];\n", Curr_Mem_loc);
                    printf("\tmprn(MEM, %d);\n", Curr_Mem_loc);
                }
        |   '(' set ID {Reg_loc = 2;} EXPR ')'   {
                    head = add_to_symbol_Table($3);
                    if($5->In_mem==1){
                        printf("\tMEM[%d] = MEM[%d];\n", Curr_Mem_loc, $5->memorylocation);
                    }
                    else{
                        printf("\tMEM[%d] = R[%d];\n", Curr_Mem_loc, $5->regidx);
                    }
                    printf("\tmprn(MEM, %d);\n", Curr_Mem_loc);
                    R_0_status = 0;
                    
                }   
        ;
EXPRSTMT:   EXPR   {
                    Reg_loc = 2;
                    printf("\teprn(R, %d);\n", $1->regidx);
                    R_0_status = 0;
            }
        ;
EXPR    :   '(' OP ARG {
                if($3->type==2){ // if ARG1 is EXPR
                    Reg_loc++;
                }
            }
            ARG ')'  {

        handleArgument($3, 0);  
        handleArgument($5, 1);  

        if ($2 == '^') {
            handlePowerOperation($3, $5);
        } else {
            handleArithmeticOperation($2, $3, $5);
        }

        $$ = createResultNode(Reg_loc, Mem_loc);

            }
        ;
OP      :   '+'     {
                    $$ = '+';
                }
        |   '-'     {
                    $$ = '-';
                }
        |   '*'     {
                    $$ = '*';
                }
        |   '/'     {
                    $$ = '/';
                }
        |   '%'     {
                    $$ = '%';
                }
        |   '^'     {
                    $$ = '^';
                }
        ;
ARG     :   ID      {
                    $$ = create_arg_node(0,$1,0,-1,-1);
                 }
        |   NUM    {

                    $$ = create_arg_node(1,"",0,-1,$1);
            }
        
        |   EXPR   { 
                    $$ = $1;
            }
        ;
%%
