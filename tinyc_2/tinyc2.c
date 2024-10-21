#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"tinyC2_22CS30010_22CS30030.tab.h"
#include"tinyC2_22CS30010_22CS30030.h"


Node* root = NULL;

Node* createnode(char* s){
    Node * temp = (Node*)malloc(sizeof(Node));
    temp->index = -1;
    temp->id = s;
    for(int i=0;i<10;i++) temp->child[i] = NULL;
    return temp;
}

Node* addnode(Node* parent, Node* q){
    parent->index++;
    parent->child[parent->index] = q;
    return parent;
}

void freetree(Node* tree){
    if(tree){
        for(int i=0;i<10;i++) freetree(tree->child[i]);
        free(tree);
    }
}

void printtree(Node* parent,int level){
    if(parent!=NULL){
        for(int i=0;i<level;i++) printf(" ");
        printf("-->");
        if(parent->id==NULL) printf("NULL \n");
        else printf("%s \n",parent->id);
        for(int i=0;i<=parent->index;i++){
            printtree(parent->child[i],level+1);
        }
    }
    return;
}



int main(int argc, char **argv) {
    FILE *file = freopen("output.txt", "w", stdout);
   
    yyparse();
    
    fclose(file);

    return 0;

}