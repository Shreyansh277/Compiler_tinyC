#ifndef TINYC_22CS30010_22CS30030_H
#define TINYC_22CS30010_22CS30030_H


#include <stdio.h>
#include <stdlib.h>
#include"tinyC2_22CS30010_22CS30030.tab.h"


typedef struct Node {
    char *id;
    struct Node* child[10];
    int index;
} Node;

extern Node *root;


// Function to create a new node with an ID
Node* createnode(char* s);

// Function to add a child node to the parent node
Node* addnode(Node* parent, Node* child);

// Function to free the memory allocated to the tree
void freetree(Node* tree);

// Function to print the tree with a specific level of indentation
void printtree(Node* parent, int level);


int yyparse(void);
int yylex();
void yyerror(const char *s);


#endif
