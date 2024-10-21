#include <iostream>
#include <stack>
#include <string>
#include <fstream>
#include <cstdlib>

extern "C" {
    #include "lex.yy.c"  // Include the lex-generated file
}

#define MAX_SYMBOLS 100
#define MAX_NUMS 100

// Define constants for operations
const int ADD = 1;
const int SUB = 2;
const int MUL = 3;
const int DIV = 4;
const int MOD = 5;

// Symbol and Number Tables


struct ParseTreeNode {
    int type;  // 1 for OPERATOR, 2 for IDENTIFIER, 3 for NUMBER
    int data;  // For operation code, symbol table index, or number table index
    ParseTreeNode* left;
    ParseTreeNode* right;

    ParseTreeNode(int t, int d = 0) : type(t), data(d), left(nullptr), right(nullptr) {}
};
// Function prototypes
ParseTreeNode* parseExpression();
ParseTreeNode* parseArg();
ParseTreeNode* parseOperator();
void evaluateExpression(ParseTreeNode* root);
void printParseTree(ParseTreeNode* node, int depth);
void reportError(const std::string& message);

// Token handling
int yylval;

// Declare external functions
extern int addToSymbolTable(const std::string& id);
extern int addToNumTable(int num);
extern void reportError(const std::string& message);

void nextToken() {
    yylex();  // Call the lex-generated function to get the next token
    std::cout << yytext << std::endl;
}

// Recursive descent parser
ParseTreeNode* parseExpression() {
    if (*yytext == '(') {
        nextToken();
        ParseTreeNode* opNode = parseOperator();
        ParseTreeNode* leftArg = parseArg();
        ParseTreeNode* rightArg = parseArg();
        if (*yytext == ')') {
            nextToken();
            opNode->left = leftArg;
            opNode->right = rightArg;
            return opNode;
        } else {
            reportError("Right parenthesis expected in place of " + std::string(yytext));
        }
    } else {
        reportError("Left parenthesis expected in place of " + std::string(yytext));
    }
    return nullptr;
}

ParseTreeNode* parseOperator() {
    int operation;
    switch (*yytext) {
        case '+': operation = ADD; break;
        case '-': operation = SUB; break;
        case '*': operation = MUL; break;
        case '/': operation = DIV; break;
        case '%': operation = MOD; break;
        default:
            reportError("Invalid operator " + std::string(yytext));
    }
    nextToken();
    return new ParseTreeNode(1, operation);  // 1 for OPERATOR
}

ParseTreeNode* parseArg() {
    if (*yytext == '(') {
        return parseExpression();
    } else if (std::isalpha(yytext[0])) {
        ParseTreeNode* idNode = new ParseTreeNode(2, yylval);  // 2 for IDENTIFIER
        nextToken();
        return idNode;
    } else if (std::isdigit(yytext[0])||yytext[0]=='-') {
        ParseTreeNode* numNode = new ParseTreeNode(3, yylval);  // 3 for NUMBER
        nextToken();
        return numNode;
    } else {
        reportError("ID/NUM/LP expected in place of " + std::string(yytext));
    }
    return nullptr;
}

// Error reporting function


// Print the parse tree in a specific format
void printParseTree(ParseTreeNode* node, int depth = 0) {
    if (!node) return;

    for (int i = 0; i < depth; ++i) std::cout << "---> ";
    switch (node->type) {
        case 1: {  // OPERATOR
            std::string opStr;
            switch (node->data) {
                case ADD: opStr = "+"; break;
                case SUB: opStr = "-"; break;
                case MUL: opStr = "*"; break;
                case DIV: opStr = "/"; break;
                case MOD: opStr = "%"; break;
            }
            std::cout << "OP(" << opStr << ")\n";
            printParseTree(node->left, depth + 1);
            printParseTree(node->right, depth + 1);
            break;
        }
        case 2:  // IDENTIFIER
            std::cout << "ID(" << symbolTable[node->data] << ")\n";
            break;
        case 3:  // NUMBER
            std::cout << "NUM(" << numTable[node->data] << ")\n";
            break;
    }
}

// Evaluate the expression recursively
int evaluate(ParseTreeNode* node) {
    if (!node) return 0;

    if (node->type == 3) {  // NUMBER
        return numTable[node->data];
    } else if (node->type == 2) {  // IDENTIFIER
        return std::stoi(symbolTable[node->data]);  // Assuming all values are integers
    } else if (node->type == 1) {  // OPERATOR
        int leftValue = evaluate(node->left);
        int rightValue = evaluate(node->right);
        switch (node->data) {
            case ADD: return leftValue + rightValue;
            case SUB: return leftValue - rightValue;
            case MUL: return leftValue * rightValue;
            case DIV: return leftValue / rightValue;
            case MOD: return leftValue % rightValue;
            default: reportError("Unknown operator");
        }
    }
    return 0;  // Should never reach here
}

// Evaluate expression after reading variable values
void evaluateExpression(ParseTreeNode* root) {
    std::cout << "Reading variable values from the input" << std::endl;
    for (int i = 0; i < symbolTableSize; ++i) {
        std::cout << symbolTable[i] << " = ";
        std::cin >> symbolTable[i];
    }

    int result = evaluate(root);
    std::cout << "The expression evaluates to " << result << std::endl;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <input_file>" << std::endl;
        return 1;
    }

    // Open the input file
    FILE* inputFile = fopen(argv[1], "r");
    if (!inputFile) {
        std::cerr << "Error opening file: " << argv[1] << std::endl;
        return 1;
    }
    yyin = inputFile;

    // Initialize the first token
    nextToken();

    // Parse the expression
    ParseTreeNode* root = parseExpression();

    // Print parse tree
    std::cout << "Parsing is successful" << std::endl;
    printParseTree(root);

    // Evaluate the expression
    evaluateExpression(root);

    // Close the input file
    fclose(inputFile);

    return 0;
}