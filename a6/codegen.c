#include "codegen.h"




// Global variables
Symbol symbols[100];  // Symbol table
int symbol_count = 0;
Quad quads[1000];    // Quad table
int quad_count = 1;
int temp_count = 0;  // For generating temporary variables

int blocks[1000];  // For storing the block numbers
int block_count = 1;

Quad target_code[MAX_TARGET_CODE];
int target_code_count = 0;
RegisterDesc registers[MAX_REGISTERS];
int num_registers = 5;


// Initialize register descriptors
void init_registers() {
    for(int i = 0; i < MAX_REGISTERS; i++) {
        registers[i].free = 1;
        registers[i].content_count = 0;
        registers[i].dirty = 0;
    }
}

// Find if value is in a register
int find_in_register(char* value) {
    for(int i = 0; i < num_registers; i++) {
        for(int j = 0; j < registers[i].content_count; j++) {
            if(strcmp(registers[i].contents[j], value) == 0) {
                return i;
            }
        }
    }
    return -1;
}

// Get register score (number of unsaved variables)
int get_register_score(int reg_num) {
    int score = 0;
    for(int i = 0; i < registers[reg_num].content_count; i++) {
        if(registers[reg_num].dirty) {
            score++;
        }
    }
    return score;
}

// Get a free register
int get_free_register() {
    for(int i = 0; i < num_registers; i++) {
        if(registers[i].free) {
            return i;
        }
    }
    return -1;
}

// Save register contents to memory
void save_register(int reg_num) {
    if(registers[reg_num].dirty) {
        for(int i = 0; i < registers[reg_num].content_count; i++) {
            // Only save variables, not temporaries
            if(registers[reg_num].contents[i][0] != '$') {
                emit_target("ST", registers[reg_num].contents[i], 
                          registers[reg_num].contents[i], NULL);
            }
        }
    }
    registers[reg_num].free = 1;
    registers[reg_num].content_count = 0;
    registers[reg_num].dirty = 0;
}

// Allocate register for a value
int allocate_register(char* value) {
    // Check if already in register
    int reg = find_in_register(value);
    if(reg != -1) return reg;
    
    // Try to get a free register
    reg = get_free_register();
    if(reg != -1) {
        registers[reg].free = 0;
        registers[reg].contents[0] = strdup(value);
        registers[reg].content_count = 1;
        return reg;
    }
    
    // Find register with lowest score
    int min_score = INT_MAX;
    int min_reg = 0;
    for(int i = 0; i < num_registers; i++) {
        int score = get_register_score(i);
        if(score < min_score) {
            min_score = score;
            min_reg = i;
        }
    }
    
    // Save and clear the chosen register
    save_register(min_reg);
    registers[min_reg].free = 0;
    registers[min_reg].contents[0] = strdup(value);
    registers[min_reg].content_count = 1;
    
    return min_reg;
}

// Generate target code for arithmetic operation
void gen_arithmetic(Quad* q) {
    // Allocate registers for operands
    int reg1 = allocate_register(q->arg1);
    int reg2 = allocate_register(q->arg2);
    int dest_reg = allocate_register(q->result);

    char r1[10], r2[10], dest[10];
    sprintf(r1, "R%d", reg1);
    sprintf(r2, "R%d", reg2);
    sprintf(dest, "R%d", dest_reg);
    
    // Load values if necessary
    if(!isdigit(q->arg1[0]) && q->arg1[0] != '-') {
        emit_target("LD", r1, q->arg1, NULL);
    }
    if(!isdigit(q->arg2[0]) && q->arg2[0] != '-') {
        emit_target("LD", r2, q->arg2, NULL);
    }
    
    // Emit arithmetic operation
    char op[4];
    if(strcmp(q->op, "+") == 0) strcpy(op, "ADD");
    else if(strcmp(q->op, "-") == 0) strcpy(op, "SUB");
    else if(strcmp(q->op, "*") == 0) strcpy(op, "MUL");
    else if(strcmp(q->op, "/") == 0) strcpy(op, "DIV");
    else if(strcmp(q->op, "%") == 0) strcpy(op, "REM");
    
    emit_target(op,dest, r1, r2);
    
    // Mark destination register as dirty
    registers[dest_reg].dirty = 1;
}

// Generate target code for assignment
void gen_assignment(Quad* q) {
    int dest_reg = allocate_register(q->result);
    char dest[10];
    sprintf(dest, "R%d", dest_reg);
    // If source is constant
    if(isdigit(q->arg1[0]) || q->arg1[0] == '-') {
        emit_target("LDI", dest, q->arg1, NULL);
    }
    // If source is variable or temporary
    else {
        int src_reg = allocate_register(q->arg1);
        emit_target("LD", dest, q->arg1, NULL);
    }
    
    registers[dest_reg].dirty = 1;
}

// Generate target code for conditional jump
void gen_conditional_jump(Quad* q) {
    int reg1 = allocate_register(q->arg1);
    int reg2 = allocate_register(q->arg2);
    
    char r1[10], r2[10];
    sprintf(r1, "R%d", reg1);
    sprintf(r2, "R%d", reg2);

    // Load values if necessary
    if(!isdigit(q->arg1[0]) && q->arg1[0] != '-') {
        emit_target("LD", r1, q->arg1, NULL);
    }
    if(!isdigit(q->arg2[0]) && q->arg2[0] != '-') {
        emit_target("LD", r2, q->arg2, NULL);
    }
    
    // Convert condition to jump instruction
    char* jmp_op;
    if(strcmp(q->op, "==") == 0) jmp_op = "JEQ";
    else if(strcmp(q->op, "!=") == 0) jmp_op = "JNE";
    else if(strcmp(q->op, "<") == 0) jmp_op = "JLT";
    else if(strcmp(q->op, "<=") == 0) jmp_op = "JLE";
    else if(strcmp(q->op, ">") == 0) jmp_op = "JGT";
    else if(strcmp(q->op, ">=") == 0) jmp_op = "JGE";
    
    emit_target(jmp_op, r1, r2, q->result);
}

// Generate target code for all quads in a block
void gen_block_code(int block_start, int block_end) {
    init_registers();
    
    for(int i = block_start; i < block_end; i++) {
        if(strcmp(quads[i].op, "+") == 0 || 
           strcmp(quads[i].op, "-") == 0 ||
           strcmp(quads[i].op, "*") == 0 ||
           strcmp(quads[i].op, "/") == 0 ||
           strcmp(quads[i].op, "%") == 0) {
            gen_arithmetic(&quads[i]);
        }
        else if(strcmp(quads[i].op, "=") == 0) {
            gen_assignment(&quads[i]);
        }
        else if(strcmp(quads[i].op, "ifFalse") == 0) {
            gen_conditional_jump(&quads[i]);
        }
        else if(strcmp(quads[i].op, "goto") == 0) {
            emit_target("JMP", quads[i].result, NULL, NULL);
        }
    }
    
    // Save all dirty registers at end of block
    for(int i = 0; i < num_registers; i++) {
        if(registers[i].dirty) {
            save_register(i);
        }
    }
}

// Print target code
void print_target_code() {
    printf("\nTarget Assembly Code:\n");
    for(int i = 0; i < target_code_count; i++) {
        printf("%d : ", i + 1);
        printf("%s ", target_code[i].op);
        
        if(target_code[i].result)
            printf("%s ", target_code[i].result);
        if(target_code[i].arg1)
            printf("%s ", target_code[i].arg1);
        if(target_code[i].arg2)
            printf("%s", target_code[i].arg2);
        
        printf("\n");
    }
}

// Main function to generate target code
void generate_target_code() {
    target_code_count = 0;
    
    // Find block boundaries and generate code for each block
    int block_start = 1;
    for(int i = 2; i < quad_count; i++) {
        if(blocks[i] == 1) {
            gen_block_code(block_start, i - 1);
            block_start = i;
        }
    }
    // Generate code for the last block
    if(block_start < quad_count) {
        gen_block_code(block_start, quad_count - 1);
    }
    
    print_target_code();
}

// Generates a new temporary variable
char* newtemp() {
    char temp[10];
    sprintf(temp, "$%d", ++temp_count);
    return strdup(temp);
}

// Emits a new quad into the quad table
void emit(char *op, char *arg1, char *arg2, char *result) {
    if (quad_count >= 1000) {
        fprintf(stderr, "Quad table overflow\n");
        exit(1);
    }
    quads[quad_count].op = strdup(op);
    quads[quad_count].arg1 = arg1 ? strdup(arg1) : NULL;
    quads[quad_count].arg2 = arg2 ? strdup(arg2) : NULL;
    quads[quad_count].result = result ? strdup(result) : NULL;

    quad_count++;
}

// Emit target code instruction
void emit_target(char* op, char* dest, char* src1, char* src2) {
    target_code[target_code_count].op = strdup(op);
    target_code[target_code_count].result = dest ? strdup(dest) : NULL;
    target_code[target_code_count].arg1 = src1 ? strdup(src1) : NULL;
    target_code[target_code_count].arg2 = src2 ? strdup(src2) : NULL;
    target_code_count++;
}


// Searches the symbol table for a symbol by name; returns the index or -1 if not found
int lookup_symbol(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) {
            return i;
        }
    }
    return -1;
}

// Inserts a symbol into the symbol table
void insert_symbol(char *name) {
    if (symbol_count >= 100) {
        fprintf(stderr, "Symbol table overflow\n");
        exit(1);
    }
    symbols[symbol_count].name = strdup(name);
    symbols[symbol_count].offset = symbol_count;  // Offset could be different in actual code generation
    symbol_count++;
}

// Backpatches the quad at `quad_num` to jump to `target`
void backpatch(int quad_num, int target) {
    if (quad_num < 0 || quad_num >= quad_count) {
        fprintf(stderr, "Invalid quad number for backpatching  - %d\n", quad_num);
        return;
    }
    // Update the result field of the specified quad for jump targets
    char target_str[10];
    sprintf(target_str, "%d", target);
    quads[quad_num].result = strdup(target_str);
}

// Prints the intermediate three-address code
void print_quads() {
    printf("Three-Address Code (Quads):\n");
    printf("-----------------------------------------------------------------\n");
    printf("Index       |     Op     |    Arg1    |    Arg2    |   Result   |\n");
    printf("-----------------------------------------------------------------\n");
    for (int i = 1; i < quad_count; i++) {
        printf(" %-10d | %-10s | %-10s | %-10s | %-10s |\n",
               i,   
               quads[i].op,
               quads[i].arg1 ? quads[i].arg1 : "",
               quads[i].arg2 ? quads[i].arg2 : "",
               quads[i].result ? quads[i].result : "");
    }
    printf("-----------------------------------------------------------------\n");
}

void initialiseBlocks() {
    for (int i = 0; i < 1000; i++) {
        blocks[i] = 0;
    }
    blocks[1] = 1;
    
}

void addBlock(int index){
    if(index < 0 || index >= 1000) {
        fprintf(stderr, "Invalid block index\n");
        return;
    }
    blocks[index] = 1;
    block_count++;
}

void printBlockLeaders() {
    printf("Block Leaders (Instruction Index):\n");
    for (int i = 0; i < 1000; i++) {
        if (blocks[i] == 1) {
            printf("%d ", i);
        }
    }
}

void printBlocks(){
    int blockIndex = 1;
    for(int i=1;i<quad_count;i++){
        if(blocks[i] == 1){
            printf("\nBlock %d:\n", blockIndex);
            blockIndex++;
        }
        if(strcmp(quads[i].op, "ifFalse") == 0){
            printf("\t%d: %s (%s) %s %s\n", i, quads[i].op, quads[i].arg1, quads[i].arg2, quads[i].result);
        }
        else if(strcmp(quads[i].op, "goto") == 0){
            printf("\t%d: %s %s\n", i, quads[i].op,quads[i].result);
        }
        else if(strcmp(quads[i].op, "=") == 0){
            printf("\t%d: %s %s %s \n", i, quads[i].result, quads[i].op, quads[i].arg1);
        }
        else {
            printf("\t%d: %s = %s %s %s\n", i, quads[i].result, quads[i].arg1, quads[i].op, quads[i].arg2);
        }
    
    }
}



int main() {

    initialiseBlocks();
    yyparse();
    // print_quads();
    // printBlockLeaders();
    printBlocks();
    generate_target_code();

    return 0;
}
