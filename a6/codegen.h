#ifndef CODEGEN_H
#define CODEGEN_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <ctype.h>

extern int yyparse();
extern int yylex();

#define MAX_TARGET_CODE 1000
#define MAX_REGISTERS 5


// Symbol table structure
typedef struct {
    char *name;
    int offset;
} Symbol;

// Quad structure for intermediate code
typedef struct {
    char *op;
    char *arg1;
    char *arg2;
    char *result;
} Quad;

// Register descriptor structure
typedef struct {
    int free;              // 1 if register is free, 0 if occupied
    char* contents[10];    // Variables/temporaries currently in register
    int content_count;     // Number of variables/temporaries in register
    int dirty; 
} RegisterDesc;



char* newtemp();
void emit(char *op, char *arg1, char *arg2, char *result);
void emit_target(char* op, char* dest, char* src1, char* src2);
int lookup_symbol(char *name);
void insert_symbol(char *name);
void backpatch(int quad_num, int target);
void initialiseBlocks();
void addBlock(int label);
void printBlockLeaders();
void printBlocks();




#endif