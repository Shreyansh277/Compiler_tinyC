#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "poly.h"
#include "poly.tab.h"
#include <math.h>

Node *root = NULL;

int flag = 0;

void setatt(Node *root, char *inh);

Node *createnode(char *val)
{
    Node *newNode = (Node *)malloc(sizeof(Node));
    newNode->val = strdup(val);
    newNode->inh = NULL;
    newNode->name = NULL;
    newNode->childPtr = -1;
    for (int i = 0; i < 10; i++)
    {
        newNode->child[i] = NULL;
    }
    return newNode;
}

Node *addchild(Node *parent, Node *child)
{
    parent->childPtr++;
    parent->child[parent->childPtr] = child;
    return parent;
}

void freetree(Node *root)
{
    if (root == NULL)
    {
        return;
    }
    for (int i = 0; i < 10; i++)
    {
        freetree(root->child[i]);
    }
    free(root->val);
    free(root);
}

void print_annotatedTree(Node *root, int level)
{
    if (root == NULL)
    {
        return;
    }

    for (int i = 0; i < level; i++)
    {
        printf("    ");
    }

    if (strcmp(root->val, "S") == 0 || strcmp(root->val, "+") == 0 || strcmp(root->val, "-") == 0 || strcmp(root->val, "^") == 0 || strcmp(root->val, "x") == 0 || strcmp(root->val, "X") == 0)
    {
        if (strcmp(root->val, "S") != 0)
        {
            printf("==> ");
            printf("%s[ ]\n", root->val);
            print_annotatedTree(root->child[0], level + 1);
            print_annotatedTree(root->child[1], level + 1);
            print_annotatedTree(root->child[2], level + 1);
        }
        else
        {
            printf("%s[ ]\n", root->val);
            print_annotatedTree(root->child[0], level);
            print_annotatedTree(root->child[1], level);
            print_annotatedTree(root->child[2], level);
        }
    }
    else if (strcmp(root->val, "P") == 0 || strcmp(root->val, "T") == 0)
    {
        printf("==> %s[ inh= %s]\n", root->val, root->inh);
        print_annotatedTree(root->child[0], level + 1);
        print_annotatedTree(root->child[1], level + 1);
        print_annotatedTree(root->child[2], level + 1);
    }
    else if (strcmp(root->val, "M") == 0)
    {
        printf("==> %s[inh = %s, val = %s]\n", root->val, root->inh, root->name);
        print_annotatedTree(root->child[0], level + 1);
        print_annotatedTree(root->child[1], level + 1);
        print_annotatedTree(root->child[2], level + 1);
    }
    else if (strcmp(root->val, "N") == 0 || strcmp(root->val, "2") == 0 || strcmp(root->val, "3") == 0 || strcmp(root->val, "4") == 0 || strcmp(root->val, "5") == 0 || strcmp(root->val, "6") == 0 || strcmp(root->val, "7") == 0 || strcmp(root->val, "8") == 0 || strcmp(root->val, "9") == 0 || strcmp(root->val, "0") == 0 || strcmp(root->val, "1") == 0)
    {
        if (strcmp(root->val, "N") == 0)
        {
            printf("==> %s[ val = %s ]\n", root->val, root->name);
        }
        else
        {
            printf("==> %s[ val = %s]\n", root->val, root->val);
        }

        print_annotatedTree(root->child[0], level + 1);
        print_annotatedTree(root->child[1], level + 1);
        print_annotatedTree(root->child[2], level + 1);
    }
    else
    {
        // printf("h");
    }

    return;
}

void setatt(Node *root, char *inh)
{
    if (root == NULL)
    {
        return;
    }

    if (strcmp(root->val, "S") == 0)
    {
        // root->inh = NULL;

        if (root->childPtr == 0)
        {
            setatt(root->child[0], "+");
        }
        else if (root->childPtr == 1)
        {
            setatt(root->child[1], root->child[0]->val);
        }
    }
    else if (strcmp(root->val, "P") == 0)
    {
        root->inh = strdup(inh);
        if (root->childPtr == 0)
        {
            setatt(root->child[0], root->inh);
        }
        else if (root->childPtr == 2)
        {
            setatt(root->child[0], root->inh);
            setatt(root->child[2], root->child[1]->val);
        }
    }
    else if (strcmp(root->val, "T") == 0)
    {
        root->inh = strdup(inh);
        if (strcmp(root->child[0]->val, "1") == 0)
        {
            root->child[0]->name = strdup("1");
        }
        else if (strcmp(root->child[0]->val, "N") == 0 && root->childPtr == 0)
        {
            setatt(root->child[0], NULL);
        }
        else if (strcmp(root->child[0]->val, "X") == 0)
        {
            setatt(root->child[0], NULL);
        }
        else if (root->childPtr == 1)
        {
            setatt(root->child[0], NULL);
            setatt(root->child[1], NULL);
        }
    }
    else if (strcmp(root->val, "X") == 0)
    {
        // root->inh = inh;
        if (root->childPtr == 0)
        {
            root->name = strdup("x");
        }
        else if (root->childPtr == 2)
        {
            setatt(root->child[2], NULL);
            if (strcmp(root->child[2]->val, "0") == 0)
            {
                root->name = strdup("1");
            }
            else if (strcmp(root->child[2]->val, "1") == 0)
            {
                root->name = strdup("x");
            }
            else
            {
                char *s = strdup("x^");
                root->name = strdup(strcat(s, root->child[2]->name));
            }
        }
    }
    else if (strcmp(root->val, "N") == 0)
    {
        root->inh = NULL;
        if (root->childPtr == 1)
        {
            setatt(root->child[1], strdup(root->child[0]->val));
            root->name = strdup(root->child[1]->name);
        }
        else if (root->childPtr == 0)
        {
            root->name = strdup(root->child[0]->val);
        }
    }
    else if (strcmp(root->val, "M") == 0)
    {
        root->inh = strdup(inh);
        if (root->childPtr == 0)
        {
            root->name = strdup(strcat(inh, root->child[0]->val));
        }
        else if (root->childPtr == 1)
        {

            setatt(root->child[1], strdup(strcat(root->inh, root->child[0]->val)));
            root->name = strdup(root->child[1]->name);
        }
    }
    else
    {
        for (int i = 0; i < 10; i++)
        {
            setatt(root->child[i], NULL);
        }
    }
}

int evalexp(Node *root, int x)
{
    if (strcmp(root->val, "S") == 0)
    {
        return evalexp(root->child[root->childPtr], x);
    }
    else if (strcmp(root->val, "P") == 0)
    {
        if (root->childPtr == 0)
        {
            return evalexp(root->child[0], x);
        }
        else if (root->childPtr == 2)
        {
            int left = evalexp(root->child[0], x);
            int right = evalexp(root->child[2], x);
            if (strcmp(root->child[1]->val, "+") == 0)
            {
                return left + right;
            }
            else if (strcmp(root->child[1]->val, "-") == 0)
            {
                return left + right;
            }
        }
    }
    else if (strcmp(root->val, "T") == 0)
    {

        int sign = (strcmp(root->inh, "-") == 0) ? -1 : 1;

        if (strcmp(root->child[0]->val, "1") == 0)
        {
            return sign * 1;
        }
        else if (root->childPtr == 0)
        {
            if (strcmp(root->child[0]->val, "N") == 0)
            {
                return sign * atoi(root->child[0]->name);
            }
            else
            {
                return sign * evalexp(root->child[0], x);
            }
        }
        else if (root->childPtr == 1)
        {

            return sign * atoi(root->child[0]->name) * evalexp(root->child[1], x);
        }
    }
    else if (strcmp(root->val, "X") == 0)
    {
        if (root->childPtr == 0)
        {
            return x;
        }
        else if (root->childPtr == 2)
        {

            return pow(x, atoi(root->child[2]->name));
        }
    }
    return 0;
}

void printderivative(Node *root, int sign)
{
    if (root == NULL)
    {
        return;
    }

    if (strcmp(root->val, "S") == 0)
    {
        printderivative(root->child[root->childPtr], sign);
    }
    else if (strcmp(root->val, "P") == 0)
    {

        sign = (strcmp(root->inh, "-") == 0) ? -1 : 1;
        if (root->childPtr == 0)
        {
            printderivative(root->child[0], sign);
        }
        else if (root->childPtr == 2)
        {

            printderivative(root->child[0], sign);

            sign = (strcmp(root->child[1]->val, "-") == 0) ? -1 : 1;

            printderivative(root->child[2], sign);
        }
    }
    else if (strcmp(root->val, "T") == 0)
    {

        sign = (strcmp(root->inh, "-") == 0) ? -1 : 1;

        if (strcmp(root->child[0]->val, "X") == 0)
        {
            if (root->child[0]->childPtr == 0)
            {

                if (flag || sign == -1)
                {
                    printf("%c1 ", (sign == -1) ? '-' : '+');
                }
                else
                {
                    printf("1 ");
                }
                flag = 1;
            }
            else if (root->child[0]->childPtr == 2)
            {

                int power = atoi(root->child[0]->child[2]->name);
                if (flag || sign == -1)
                {
                    printf("%c%d", (sign == -1) ? '-' : '+', power);
                }
                else
                {
                    printf("%d", power);
                }
                int new_power = power - 1;
                if (new_power == 1)
                {
                    printf("x ");
                }
                else if (new_power > 1)
                {
                    printf("x^%d ", new_power);
                }
                flag = 1;
            }
        }

        else if (root->childPtr == 1)
        {
            int num = atoi(root->child[0]->name);
            int num2 = atoi(root->child[1]->child[2]->name);

            int new_coefficient = num * num2;

            if (flag || sign == -1)
            {
                printf("%c%d", (sign == -1) ? '-' : '+', new_coefficient);
            }
            else
            {
                printf("%d", new_coefficient);
            }

            int new_exponent = num2 - 1;

            if (new_exponent == 1)
            {
                printf("x ");
            }
            else if (new_exponent > 1)
            {
                printf("x^%d ", new_exponent);
            }

            flag = 1;
        }
    }
}

int main(int argc, char **argv)
{
    FILE *file = freopen("output.txt", "w", stdout);
    yyparse();
    setatt(root, NULL);

    printf("+++ The annotated parse tree is:\n");

    if (root)
    {
        print_annotatedTree(root, 0);
    }
    else
    {
        printf("No parse tree generated.\n");
    }

    for (int i = -5; i <= 5; i++)
    {
        printf(" +++ f(%d)=%d\n", i, evalexp(root, i));
    }

    printf("Derivative of the function is:\n");
    printf("+++ f'(x) = ");
    printderivative(root, 0);

    fclose(file);

    freetree(root);
    return 0;
}