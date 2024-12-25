#include<stdio.h>
#include<string.h>
#include"lex.yy.c"

//structures for identifier, constant, comments, string_literals
typedef struct Ident{
    char* s;
    struct Ident* next;
}ident;

typedef struct cons{
    char* s;
    struct cons* next;
}cons;

typedef struct comm{
    char *s;
    struct comm* next;
}comm;

typedef struct st_literal{
    char*s;
    struct st_literal* next;
}st_literal;

//structure for symbol_table
typedef struct symbolTable{
    ident* head_identifier;
    cons* head_constant;
    comm* head_comment;
    st_literal* head_st_literal;
}symbolTable;


// corresponding functions for structures for creating, and inserting new nodes
cons* create_constant(char *str){
    cons* node = (cons*) malloc (sizeof(cons));
    node->s = (char*)malloc(strlen(str)+1);
    strcpy(node->s,str);
    node->next = NULL;
    return node;
}

ident* create_identifier(char *str){
    ident* node = (ident*) malloc (sizeof(ident));
    node->s = (char*)malloc(strlen(str)+1);
    strcpy(node->s,str);
    node->next = NULL;
    return node;
}

comm* create_comment(char *str){
    comm* node = (comm*) malloc (sizeof(comm));
    node->s = (char*)malloc(strlen(str)+1);
    strcpy(node->s,str);
    node->next = NULL;
    return node;
}

st_literal* create_st_literal(char *str){
    st_literal* node = (st_literal*) malloc (sizeof(st_literal));
    node->s = (char*)malloc(strlen(str)+1);
    strcpy(node->s,str);
    node->next = NULL;
    return node;
}

 ident* check1(char* str, ident* head){
    if(head==NULL){
        // printf("\nk\n");
        head = create_identifier(str);
        return head;
    }
    ident* temp = head;
    ident* prev = NULL;
    while(temp!=NULL){
        int q = strcmp(temp->s,str);
        if(q==0) return head;
        prev = temp;
        temp = temp->next;
    }
    ident* newNode = create_identifier(str);
    prev->next = newNode;
    //  printf("\nl\n");
    return head;
}

cons* check2(char* str, cons* head){
    if(head==NULL){
        head = create_constant(str);
        return head;
    }
    cons* temp = head;
    cons* prev = NULL;
    while(temp!=NULL){
        int q = strcmp(head->s,str);
        if(q==0) return head;
        prev = temp;
        temp = temp->next;
    }
    cons* newNode = create_constant(str);
    prev->next = newNode;
    return head;

}

comm* check3(char* str, comm* head){
    if(head==NULL){
        head = create_comment(str);
        return head;
    }
    comm* temp = head;
    comm* prev = NULL;
    while(temp!=NULL){
        int q = strcmp(head->s,str);
        if(q==0) return head;
        prev = temp;
        temp = temp->next;
    }
    comm* newNode = create_comment(str);
    prev->next = newNode;
    return head;
}

st_literal* check4(char* str, st_literal* head){
    if(head==NULL){
        head = create_st_literal(str);
        return head;
    }
    st_literal* temp = head;
    st_literal* prev = NULL;
    while(temp!=NULL){
        int q = strcmp(head->s,str);
        if(q==0) return head;
        prev = temp;
        temp = temp->next;
    }
    st_literal* newNode = create_st_literal(str);
    prev->next = newNode;
    return head;
}


int main()
{

freopen("output.txt","w",stdout);
int token;

symbolTable T = {NULL,NULL,NULL,NULL};
ident* h1 = T.head_identifier;
cons* h2 = T.head_constant;
comm* h3 = T.head_comment;
st_literal* h4 = T.head_st_literal;

//getting tokens from the lexer
while(token = yylex())
{
    switch (token){
        case Keyword:
            printf("<Keyword,%s>",yytext);
            break;
        case Identifier:
            printf("<Identifier,%s>",yytext);
            h1 = check1(yytext,h1);
            break;
        case Constant:
            printf("<Constant,%s>",yytext);
            h2 =check2(yytext,h2);
            break;
        
        case String_literal:
            printf("<String_literal,%s>",yytext);
            h4=check4(yytext,h4);
            break;
        case Comments:
            printf("<Comments,%s>",yytext);
            h3=check3(yytext,h3);
            break;
        case Punctuator:
            printf("<Punctuator,%s>",yytext);
            break;
        default:
            printf("Syntax error found at line no:%d",yylineno);
            break;
    } 
}


//printing identifiers from the symbol table
ident* temp1 = h1;
printf("\n Identifiers:\n");
while(temp1!=NULL){
    printf("%s \n",temp1->s);
    temp1= temp1->next;
}

//printing constants from the symbol table
cons* temp2 = h2;
printf("\n constants:\n");
while(temp2!=NULL){
    printf("%s \n",temp2->s);
    temp2= temp2->next;
}

//printing comments from the symbol table
comm* temp3 = h3;
printf("\n comments:\n");
while(temp3!=NULL){
    printf("%s \n",temp3->s);
    temp3= temp3->next;
}

//printing string_literals from the symbol table
st_literal* temp4 = h4;
printf("\n string_literals:\n");
while(temp4!=NULL){
    printf("%s \n",temp4->s);
    temp4= temp4->next;
}



fclose(stdout);


}