#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_ITEMS 1000
#define MAX_NAME_LENGTH 100

struct Item {
    char name[MAX_NAME_LENGTH];
    int count;
};

struct Item commands[MAX_ITEMS];
struct Item environments[MAX_ITEMS];
int command_count = 0;
int environment_count = 0;
int inline_math_count = 0;
int displayed_math_count = 0;

extern FILE* yyin;
extern int yylex();

void count_item(struct Item items[], int *item_count, const char *name) {
    for (int i = 0; i < *item_count; i++) {
        if (strcmp(items[i].name, name) == 0) {
            items[i].count++;
            return;
        }
    }
    if (*item_count < MAX_ITEMS) {
        strncpy(items[*item_count].name, name, MAX_NAME_LENGTH - 1);
        items[*item_count].name[MAX_NAME_LENGTH - 1] = '\0';
        items[*item_count].count = 1;
        (*item_count)++;
    } else {
        fprintf(stderr, "Warning: Maximum number of items reached\n");
    }
}

void count_command(char *cmd) {
    count_item(commands, &command_count, cmd);
}

void count_environment(char *env) {
    count_item(environments, &environment_count, env);
}

void count_inline_math() {
    inline_math_count++;
}

void count_displayed_math() {
    displayed_math_count++;
}

void print_statistics() {
    printf("Commands used:\n");
    for (int i = 0; i < command_count; i++) {
        printf("%s (%d)\n", commands[i].name, commands[i].count);
    }

    printf("\nEnvironments used:\n");
    for (int i = 0; i < environment_count; i++) {
        printf("%s (%d)\n", environments[i].name, environments[i].count);
    }

    printf("\n%d math equations found\n", inline_math_count);
    printf("%d displayed equations found\n", displayed_math_count);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input = fopen(argv[1], "r");
    if (!input) {
        perror("Error opening file");
        return 1;
    }

    yyin = input;
    yylex();
    fclose(input);

    print_statistics();
    return 0;
}

#include "lex.yy.c"