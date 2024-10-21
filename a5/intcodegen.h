#ifndef INT_CODE_GEN_H
#define INT_CODE_GEN_H
#include <stdio.h>
#include <stdlib.h>
#include<string.h>

    typedef struct table {
        char *id;
        int location;
        struct table *next;
    }Symbol_Table;

Symbol_Table *head = NULL;

    int Mem_loc = 0; // memory offset
    int Reg_loc = 2; // register offset
    int Curr_Mem_loc = 0; // current memory location
    int R_0_status = 0;  // flag to check if R[0] is used or not


    // structure to store the arguments
    typedef struct argvals{
        int type; // 0 for id, 1 for num, 2 for expr
        char *id;
        int regidx;
        int value;
        int In_mem;
        int memorylocation;
    }Arg;

Symbol_Table *add_to_symbol_Table(char *id);

void generate_code(char* s);

int find_mem_loc(char *id);

Arg* create_arg_node(int type, char* id, int In_mem, int regidx, int value);
Arg* createResultNode(int regIdx, int memLoc);
void loadMemoryToRegister(struct argvals *arg, int regIdx);
void loadMemoryToRegisterByLocation(struct argvals *arg, int regIdx);
void handlePowerOperation(struct argvals *arg1, struct argvals *arg2);
void handleArithmeticOperation(char op, struct argvals *arg1, struct argvals *arg2);
void printArgument(struct argvals *arg);
void handleArgument(struct argvals *arg, int regIdx);
void yyerror(char *s);
void storeMemoryFromRegister(Arg *arg);

#endif