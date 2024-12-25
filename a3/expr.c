#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

int yyparse();

typedef struct TreeNode {
    int nodeType;            
    char *identifier;        
    char operatorSymbol;     
    struct TreeNode *next;   
    int value;               
    struct TreeNode *left, *right; 
} TreeNode;

typedef TreeNode* SymbolTable;

SymbolTable addToSymbolTable(SymbolTable table, char *identifier) {
    TreeNode *current = table;
    while (current) {
        if (strcmp(current->identifier, identifier) == 0) return table;
        current = current->next;
    }
    TreeNode *newNode = (TreeNode *)malloc(sizeof(TreeNode));
    newNode->identifier = (char *)malloc((strlen(identifier) + 1) * sizeof(char));
    strcpy(newNode->identifier, identifier);
    newNode->next = table;
    newNode->value = 0;  
    return newNode;
}



SymbolTable lookupSymbol(SymbolTable table, char *identifier)
{
    TreeNode *current = table;
    while (current) {
        if (strcmp(current->identifier, identifier) == 0) return current;
        current = current->next;
    }
    return NULL;
}

void assignValue(SymbolTable symbol, int value) {
    if (symbol) {
        symbol->value = value;
    }
}

int retrieveValue(SymbolTable symbol) {
    if (symbol) {
        return symbol->value;
    }
    return 0;
}

SymbolTable createLeafNode(int value) {
    SymbolTable leafNode = (SymbolTable)malloc(sizeof(TreeNode));
    leafNode->nodeType = 0; 
    leafNode->value = value;
    leafNode->left = leafNode->right = NULL;
    return leafNode;
}

SymbolTable createOperatorNode(char operatorSymbol, SymbolTable leftChild, SymbolTable rightChild) {
    SymbolTable operatorNode = (SymbolTable)malloc(sizeof(TreeNode));
    operatorNode->nodeType = 1; 
    operatorNode->operatorSymbol = operatorSymbol;
    operatorNode->left = leftChild;
    operatorNode->right = rightChild;
    return operatorNode;
}

int evaluateExpressionTree(SymbolTable tree) {
    if (tree->nodeType == 0) {
        return tree->value;
    }
    int leftValue = evaluateExpressionTree(tree->left);
    int rightValue = evaluateExpressionTree(tree->right);
    switch (tree->operatorSymbol) {
        case '+': return leftValue + rightValue;
        case '-': return leftValue - rightValue;
        case '*': return leftValue * rightValue;
        case '/': return leftValue / rightValue;
        case '%': return leftValue % rightValue;
        case 'E': {  
            int result = 1;
            for (int i = 0; i < rightValue; i++) {
                result *= leftValue;
            }
            return result;
        }
        default: return 0;
    }
}

void destroyExpressionTree(SymbolTable tree) {
    if (tree) {
        destroyExpressionTree(tree->left);
        destroyExpressionTree(tree->right);
        free(tree);
    }
}

int main() {
    yyparse();
    return 0;
}
