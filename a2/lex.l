%{
#include <iostream>
#include <string>

#define MAX_SYMBOLS 100
#define MAX_NUMS 100

extern int yylval;
extern std::string symbolTable[MAX_SYMBOLS];
extern int numTable[MAX_NUMS];
extern int symbolTableSize;
extern int numTableSize;

extern int addToSymbolTable(const std::string& id);
extern int addToNumTable(int num);
%}

%%

"+"       { yylval = '+'; return '+'; }
"-"       { yylval = '-'; return '-'; }
"*"       { yylval = '*'; return '*'; }
"/"       { yylval = '/'; return '/'; }
"%"       { yylval = '%'; return '%'; }

"("       { return '('; }
")"       { return ')'; }

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval = addToSymbolTable(yytext);
    return yylval;
}

[-]?[0-9]+ {
    yylval = addToNumTable(std::atoi(yytext));
    return yylval;
}

[\t\n\r ]+  { /* ignore whitespace */ }

.          { std::cerr << "*** Error: Invalid token " << yytext << " found" << std::endl; exit(1); }

%%

int yywrap() {
    return 1;
}

std::string symbolTable[MAX_SYMBOLS];
int numTable[MAX_NUMS];
int symbolTableSize = 0;
int numTableSize = 0;

void reportError(const std::string& message) {
    std::cerr << "*** Error: " << message << std::endl;
    exit(1);
}

// Function to add an identifier to the symbol table and return its index
int addToSymbolTable(const std::string& id) {
    for (int i = 0; i < symbolTableSize; ++i) {
        if (symbolTable[i] == id) {
            return i;  // Identifier already in the table
        }
    }
    if (symbolTableSize >= MAX_SYMBOLS) {
        reportError("Symbol table overflow");
    }
    symbolTable[symbolTableSize] = id;
    return symbolTableSize++;
}

// Function to add a number to the number table and return its index
int addToNumTable(int num) {
    for (int i = 0; i < numTableSize; ++i) {
        if (numTable[i] == num) {
            return i;  // Number already in the table
        }
    }
    if (numTableSize >= MAX_NUMS) {
        reportError("Number table overflow");
    }
    numTable[numTableSize] = num;
    return numTableSize++;
}

