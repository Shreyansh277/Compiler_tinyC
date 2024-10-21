
#include <stdio.h>
#include <stdlib.h>
#include "aux.c"
#include "lex.yy.c"
#include"intcodegen.h"

    // function to add id to the table
    Symbol_Table *add_to_symbol_Table(char *id) 
    {
        // if already exits 
        Symbol_Table *temp = head;
        while(temp != NULL) {
            if(strcmp(temp->id, id) == 0) {
                Curr_Mem_loc = temp->location;
                return head;
            }
            temp = temp->next;
        }

        // if not exits
        Symbol_Table *new = (Symbol_Table *)malloc(sizeof(Symbol_Table));
        new->id = id;
        new->location = Mem_loc;
        Curr_Mem_loc = Mem_loc;
        new->next = head;
        head = new;
        Mem_loc++;
        return head;
    }

    // function to get location of id
    int find_mem_loc(char *id) 
    {
        Symbol_Table *temp = head;
        while(temp != NULL) {
            if(strcmp(temp->id, id) == 0) {
                return temp->location;
            }
            temp = temp->next;
        }

        // if id doesn't exist in the table then add it to the table  
        Symbol_Table *new = (Symbol_Table *)malloc(sizeof(Symbol_Table));
        new->id = id;
        new->location = Mem_loc;
        new->next = head;
        head = new;
        Mem_loc++;
        return Mem_loc-1;
    }

    
     Arg* create_arg_node(int type, char* id, int In_mem, int regidx, int value){
        Arg *temp = (Arg *)malloc(sizeof(Arg));
        temp->type = type;
        temp->id = id;
        temp->In_mem = In_mem;
        temp->regidx = regidx;
        temp->value = value;
        return temp;
    }
Arg *createResultNode(int regIdx, int memLoc) {
    Arg *temp = (Arg*)malloc(sizeof(Arg));
    temp->type = 2; // Type for an expression result
    
    // If registers are full, store result in memory
    if (regIdx >= 12) {
        temp->regidx = -1; // No register available
        temp->In_mem = 1; // Result is in memory
        temp->memorylocation = memLoc;
        printf("\tMEM[%d] = R[0];\n", memLoc); // Store result from R[0] into memory
        memLoc++; // Increment memory location for future use
    } else {
        temp->regidx = regIdx; // Use register for result
        temp->In_mem = 0; // Result is in a register
    }

    temp->value = -1; // Not a literal value
    return temp;
}

void handleArgument(struct argvals *arg, int regIdx) {
    // If it's an ID (a variable)
    if (arg->type == 0) { 
        if (regIdx < 12) {  // If there is an available register
            loadMemoryToRegister(arg, regIdx); // Load the value from memory to register
        } else {  // If no registers are available
            storeMemoryFromRegister(arg); // Spill to memory
        }
    } 
    // If the value is already in memory
    else if (arg->In_mem == 1) { 
        loadMemoryToRegisterByLocation(arg, regIdx); // Load value from memory to register
    }
}

void storeMemoryFromRegister(struct argvals *arg) {
    printf("\tMEM[%d] = R[0];\n", Mem_loc); // Spill register R[0] to memory
    arg->memorylocation = Mem_loc;  // Record the memory location in the arg node
    Mem_loc++;  // Increment memory location counter
}



void loadMemoryToRegister(Arg *arg, int regIdx) {
    if (R_0_status == 0) {
        printf("\tR[0] = MEM[%d];\n", find_mem_loc(arg->id));
        arg->regidx = 0;
        R_0_status = 1;
    } else {
        printf("\tR[1] = MEM[%d];\n", find_mem_loc(arg->id));
        arg->regidx = 1;
        R_0_status = 0;
    }
}

void loadMemoryToRegisterByLocation(Arg *arg, int regIdx) {
    if (R_0_status == 0) {
        printf("\tR[0] = MEM[%d];\n", arg->memorylocation);
        arg->regidx = 0;
        R_0_status = 1;
    } else {
        printf("\tR[1] = MEM[%d];\n", arg->memorylocation);
        arg->regidx = 1;
        R_0_status = 0;
    }
}

void handlePowerOperation(Arg *arg1, Arg *arg2) {
    printf("\tR[%d] = pwr(", (Reg_loc < 12) ? Reg_loc : 0);
    printArgument(arg1);
    printf(",");
    printArgument(arg2);
    printf(");\n");
}

void handleArithmeticOperation(char op, struct argvals *arg1, struct argvals *arg2) {
    // Load values into registers if they are in memory
    if (arg1->In_mem == 1) {
        printf("\tR[1] = MEM[%d];\n", arg1->memorylocation); // Load from memory to R[1]
    }

    if (arg2->In_mem == 1) {
        printf("\tR[2] = MEM[%d];\n", arg2->memorylocation); // Load from memory to R[2]
    }

    // Perform arithmetic using registers or memory
    printf("\tR[%d] = ", (Reg_loc < 12) ? Reg_loc : 0); // Use register if available, otherwise use R[0]

    // Operand 1 (check if it's in memory or a register)
    if (arg1->In_mem == 1) {
        printf("R[1]");
    } else {
        printf("R[%d]", arg1->regidx);
    }

    // Operator
    printf(" %c ", op);

    // Operand 2 (check if it's in memory or a register)
    if (arg2->In_mem == 1) {
        printf("R[2]");
    } else {
        printf("R[%d]", arg2->regidx);
    }

    printf(";\n");
}



void printArgument(Arg *arg) {
    if (arg->type == 0) {
        printf("R[%d]", arg->regidx);
    } else if (arg->type == 1) {
        printf("%d", arg->value);
    } else if (arg->type == 2) {
        printf("R[%d]", arg->regidx);
    }
}



int main(){
    printf("#include <stdio.h>\n#include <stdlib.h>\n#include \"aux.c\"\n\nint main ( )\n{");
    printf("\n    int R[12];\n    int MEM[65536];\n\n");
    yyparse();
    printf("\n\texit(0);\n");
    printf("}");
}

void yyerror(char *s){
    fprintf(stderr, "%s\n", s);
}

