// poly.h
#ifndef POLY_H
#define POLY_H
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"poly.tab.h"
#include<math.h>





typedef struct Node {
    char *val;
    char *inh;
    char* name;
    int childPtr;
    struct Node *child[10];
} Node;


extern Node *root;

// Function to create a new node
Node *createnode(char* val);

// Function to add a child to a parent node
Node *addchild(Node *parent, Node* child);

// Function to free the tree
void freetree(Node *root);

// function of set attribute
void setatt(Node *root, char *inh);


// Function to print the tree
void print_annotatedTree(Node *root ,int level);

int yyparse(void);
int yylex();
void yyerror(const char *s);

#endif // POLY_H