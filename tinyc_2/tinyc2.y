%{
#include <stdio.h>
#include <stdlib.h>
#include<string.h>
#include"tinyC2_22CS30010_22CS30030.h"

struct Node;
typedef struct Node Node;

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}



%}




%union{
    char* id;
    struct Node * node;
}


// Define tokens from lex file
%token <id> AUTO UNSIGNED ENUM RESTRICT BREAK EXTERN RETURN VOID CASE FLOAT VOLATILE SHORT CHAR FOR SIGNED WHILE CONST GOTO SIZEOF BOOL CONTINUE IF ELSE STATIC COMPLEX DEFAULT INLINE STRUCT IMAGINARY DO INT SWITCH DOUBLE LONG TYPEDEF REGISTER UNION
%token <id> IDENTIFIER CONSTANT STRING_LITERAL
%token <id> LEFT_BRACKET RIGHT_BRACKET LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRACE RIGHT_BRACE DOT ARROW INCREMENT DECREMENT AMPERSAND ASTERISK PLUS MINUS TILDE EXCLAMATION SLASH PERCENT LEFT_SHIFT RIGHT_SHIFT LESS_THAN GREATER_THAN LESS_EQUAL GREATER_EQUAL EQUALS NOT_EQUALS CARET PIPE AND OR QUESTION_MARK COLON SEMICOLON ELLIPSIS ASSIGN MULTIPLY_ASSIGN DIVIDE_ASSIGN MODULO_ASSIGN PLUS_ASSIGN MINUS_ASSIGN LEFT_SHIFT_ASSIGN RIGHT_SHIFT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN COMMA HASH
%token SINGLE_LINE_COMMENT MULTI_LINE_COMMENT

%type <node> translation_unit external_declaration function_definition declaration declaration_specifiers init_declarator_list_opt init_declarator_list init_declarator declarator direct_declarator pointer_opt pointer
%type <node> type_qualifier_list_opt type_qualifier_list parameter_type_list parameter_list parameter_declaration compound_statement block_item_list_opt block_item_list block_item
%type <node> statement expression_statement expression_opt selection_statement iteration_statement jump_statement expression assignment_expression conditional_expression assignment_operator assignment_expression_opt
%type <node> logical_OR_expression logical_AND_expression inclusive_OR_expression exclusive_OR_expression AND_expression equality_expression relational_expression shift_expression additive_expression multiplicative_expression
%type <node> cast_expression unary_expression unary_operator postfix_expression primary_expression argument_expression_list_opt argument_expression_list initializer initializer_list designation_opt designation designator_list designator
%type <node> constant_expression type_name specifier_qualifier_list declaration_specifiers_opt identifier_list_opt specifier_qualifier_list_opt declaration_list_opt declaration_list type_specifier storage_class_specifier type_qualifier function_specifier identifier_list labeled_statement
%type <node> dummy

%start dummy


%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

/* Grammar rules */
dummy:
    translation_unit{
        $$ = createnode("start");
        $$ = addnode($$,$1);
        printtree($$,0);
    }
    ;

translation_unit:
    external_declaration {
        $$ = createnode("translation_unit");
        $$ = addnode($$,$1);
    }
    | translation_unit external_declaration{
        $$ = createnode("translation_unit");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
    }
    ;

external_declaration:
    function_definition{
        $$ = createnode("external_declaration");
        $$ = addnode($$,$1);
    }
    | declaration{
        $$ = createnode("external_declaration");
        $$ = addnode($$,$1);
    }
    ;

function_definition:
    declaration_specifiers declarator declaration_list_opt compound_statement{ 
        $$ = createnode("function_definition");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
        $$ = addnode($$,$3);
        $$ = addnode($$,$4);
    }
    ;

declaration_list_opt:
    declaration_list{
        $$ = createnode("declaration_list_opt");
        $$ = addnode($$,$1);
    }
    | {
        $$ = createnode("declaration_list_opt");
        $$ = addnode($$,createnode(NULL));
    }
    ;

declaration_list:
    declaration {
        $$ = createnode("declaration_list");
        $$ = addnode($$,$1);
    }
    | declaration_list declaration{
        $$ = createnode("declaration_list");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
    }
    ;
    
assignment_expression_opt:
    assignment_expression
    {
        $$ = createnode("assignment_expression_opt");
        $$ = addnode($$,$1);
    }
    |
        {
        $$ = createnode("assignment_expression_opt");
        $$ = addnode($$,createnode(NULL));
    }



declaration:
    declaration_specifiers init_declarator_list_opt SEMICOLON{
        $$ = createnode("declaration");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
        $$ = addnode($$,createnode($3));
    }
    ;



declaration_specifiers: 
    type_specifier declaration_specifiers_opt{ 
        $$ = createnode("declaration_specifiers");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
    }
    | storage_class_specifier declaration_specifiers_opt
    { 
        $$ = createnode("declaration_specifiers");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
    }
    | type_qualifier declaration_specifiers_opt
    { 
        $$ = createnode("declaration_specifiers");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
    }
    | function_specifier declaration_specifiers_opt
    { 
        $$ = createnode("declaration_specifiers");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
    }
    ;

declaration_specifiers_opt:
    declaration_specifiers{
        $$ = createnode("declaration_specifiers_opt");
        $$ = addnode($$,$1);
    }
    | {
        $$ = createnode("declaration_specifiers_opt");
        $$ = addnode($$,createnode("NULL"));
    }
    ;

identifier_list_opt:
    identifier_list{
        $$ = createnode("identifier_list_opt");
        $$ = addnode($$,$1);
    }
    | {
        $$ = createnode("identifier_list_opt");
        $$ = addnode($$,createnode("NULL"));
    }
    ;

specifier_qualifier_list_opt:
    specifier_qualifier_list{
        $$ = createnode("specifier_qualifier_list_opt");
        $$ = addnode($$,$1);
    }
    | {
        $$ = createnode("specifier_qualifier_list_opt");
        $$ = addnode($$,createnode("NULL"));
    }
    ;
init_declarator_list_opt:
    init_declarator_list
    { 
        $$ = createnode("init_declarator_list_opt");
        $$ = addnode($$,$1);
    }
    | /* empty */
    { 
        $$ = createnode("init_declarator_list_opt");
        $$ = addnode($$,createnode(NULL));
    }
    ;

init_declarator_list:
    init_declarator
    { 
        $$ = createnode("init_declarator_list");
        $$ = addnode($$,$1);
    }
    | init_declarator_list COMMA init_declarator
    { 
        $$ = createnode("init_declarator_list");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

init_declarator:
    declarator
    { 
        $$ = createnode("init_declarator");
        $$ = addnode($$,$1);
    }
    | declarator ASSIGN initializer
    { 
        $$ = createnode("init_declarator");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

declarator:
    pointer_opt direct_declarator
    { 
        $$ = createnode("declarator");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
    }
    ;

direct_declarator:
    IDENTIFIER {
        $$ = createnode("direct_declarator");
        $$ = addnode($$,createnode($1));
    }
    | LEFT_PARENTHESIS declarator RIGHT_PARENTHESIS
    {
        $$ = createnode("direct_declarator");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
        $$ = addnode($$,createnode($3));
    }
    | direct_declarator LEFT_BRACKET type_qualifier_list_opt assignment_expression_opt RIGHT_BRACKET
    {
        $$ = createnode("direct_declarator");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,$4);
        $$ = addnode($$,createnode($5));
    }
    | direct_declarator LEFT_BRACKET STATIC type_qualifier_list_opt assignment_expression RIGHT_BRACKET
    {
        $$ = createnode("direct_declarator");
        $$ = addnode($$,$1);
         $$ = addnode($$,createnode($2));
        $$ = addnode($$,createnode($3));
        $$ = addnode($$,$4);
        $$ = addnode($$,$5);
        $$ = addnode($$,createnode($6));
    }
    | direct_declarator LEFT_BRACKET type_qualifier_list STATIC assignment_expression RIGHT_BRACKET
    {
        $$ = createnode("direct_declarator");
        $$ = addnode($$,$1);
         $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
        $$ = addnode($$,$5);
        $$ = addnode($$,createnode($6));
    }
    | direct_declarator LEFT_BRACKET type_qualifier_list_opt ASTERISK RIGHT_BRACKET
    {
        $$ = createnode("direct_declarator");
        $$ = addnode($$,$1);
         $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
        $$ = addnode($$,createnode($5));
    }
    | direct_declarator LEFT_PARENTHESIS parameter_type_list RIGHT_PARENTHESIS
    {
        $$ = createnode("direct_declarator");
        $$ = addnode($$,$1);
         $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
    }
    | direct_declarator LEFT_PARENTHESIS identifier_list_opt RIGHT_PARENTHESIS
    {
        $$ = createnode("direct_declarator");
        $$ = addnode($$,$1);
         $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
    }
    ;

pointer_opt:
    pointer
    {
        $$ = createnode("pointer_opt");
        $$ = addnode($$,$1);
    }
    | /* empty */
    {
        $$ = createnode("pointer_opt");
        $$ = addnode($$,createnode(NULL));
    }
    ;

pointer:
    ASTERISK type_qualifier_list_opt
    {
        $$ = createnode("pointer");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
    }
    | ASTERISK type_qualifier_list_opt pointer
    {
        $$ = createnode("pointer");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
        $$ = addnode($$,$3);
    }
    ;

type_qualifier_list_opt:
    type_qualifier_list
    {
        $$ = createnode("type_qualifier_list_opt");
        $$ = addnode($$,$1);
    }
    | /* empty */
    
    {
        $$ = createnode("type_qualifier_list_opt");
        $$ = addnode($$,createnode(NULL));
    }
    ;

type_qualifier_list:
    type_qualifier
    {
        $$ = createnode("type_qualifier_list");
        $$ = addnode($$,$1);
    }
    | type_qualifier_list type_qualifier
    {
        $$ = createnode("type_qualifier_list");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
    }
    ;


parameter_type_list:
    parameter_list
    {
        $$ = createnode("parameter_type_list");
        $$ = addnode($$,$1);
    }
    | parameter_list COMMA ELLIPSIS
    {
        $$ = createnode("parameter_type_list");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,createnode($3));
    }
    ;

parameter_list:
    parameter_declaration
    {
        $$ = createnode("parameter_list");
        $$ = addnode($$,$1);
    }
    | parameter_list COMMA parameter_declaration
    {
        $$ = createnode("parameter_list");
         $$ = addnode($$,createnode($2));
        $$ = addnode($$,$1);
        $$ = addnode($$,$3);
       
    }
    ;

parameter_declaration:
    declaration_specifiers declarator
    {
        $$ = createnode("parameter_declaration");
        $$ = addnode($$,$1);
    }
    | declaration_specifiers
    {
        $$ = createnode("parameter_declaration");
        $$ = addnode($$,$1);
    }
    ;

identifier_list:
    IDENTIFIER
    {
        $$ = createnode("identifier_list");
        $$ = addnode($$,createnode($1));
    }
    | identifier_list COMMA IDENTIFIER
    {
        $$ = createnode("identifier_list");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,createnode($3));

    }


compound_statement:
    LEFT_BRACE block_item_list_opt RIGHT_BRACE
    {
        $$ = createnode("compound_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
        $$ = addnode($$,createnode($3));

    }
    ;

block_item_list_opt:
    block_item_list
        {
        $$ = createnode("block_item_list_opt");
        $$ = addnode($$,$1);
    }
    | /* empty */
            {
        $$ = createnode("block_item_list_opt");
        $$ = addnode($$,createnode(NULL));
    }
    
    ;

block_item_list:
    block_item
       {
        $$ = createnode("block_item_list");
        $$ = addnode($$,$1);
    }
    | block_item_list block_item
      {
        $$ = createnode("block_item_list");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
    }
    ;

block_item:
    declaration
      {
        $$ = createnode("block_item");
        $$ = addnode($$,$1);
    }
    | statement
      {
        $$ = createnode("block_item");
        $$ = addnode($$,$1);
    }
    ;

statement:
    expression_statement
          {
        $$ = createnode("statement");
        $$ = addnode($$,$1);
    }
    | compound_statement
              {
        $$ = createnode("statement");
        $$ = addnode($$,$1);
    }
    | selection_statement
              {
        $$ = createnode("statement");
        $$ = addnode($$,$1);
    }
    | iteration_statement
              {
        $$ = createnode("statement");
        $$ = addnode($$,$1);
    }
    | jump_statement
              {
        $$ = createnode("statement");
        $$ = addnode($$,$1);
    }
    | labeled_statement
              {
        $$ = createnode("statement");
        $$ = addnode($$,$1);
    }
    ;

labeled_statement:
    IDENTIFIER COLON statement
              {
        $$ = createnode("labeled_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    | CASE constant_expression COLON statement
    {
        $$ = createnode("labeled_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
        $$ = addnode($$,createnode($3));
        $$ = addnode($$,$4);
    }
    | DEFAULT COLON statement
             {
        $$ = createnode("labeled_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    
    ;

expression_statement:
    expression_opt SEMICOLON
             {
        $$ = createnode("expression_statement");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
    }
    ;

expression_opt:
    expression
    {
        $$ = createnode("expression_opt");
        $$ = addnode($$,$1);
    }
    
    | /* empty */
    {
        $$ = createnode("expression_opt");
        $$ = addnode($$,createnode(NULL));
    }
    ;

selection_statement:
    IF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS statement  %prec LOWER_THAN_ELSE{
       

        $$ = createnode("selection_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
        $$ = addnode($$,$5);
    }
    | IF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS statement ELSE statement{
        
        $$ = createnode("selection_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
        $$ = addnode($$,$5);
        $$ = addnode($$,createnode($6));
        $$ = addnode($$,$7);
    }
    | SWITCH LEFT_PARENTHESIS expression RIGHT_PARENTHESIS statement{
        $$ = createnode("selection_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
        $$ = addnode($$,$5);
    }
    ;

iteration_statement:
    WHILE LEFT_PARENTHESIS expression RIGHT_PARENTHESIS statement{
        $$ = createnode("iteration_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
        $$ = addnode($$,$5);
    }
    | DO statement WHILE LEFT_PARENTHESIS expression RIGHT_PARENTHESIS SEMICOLON{
        $$ = createnode("iteration_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
        $$ = addnode($$,createnode($3));
        $$ = addnode($$,createnode($4));
        $$ = addnode($$,$5);
        $$ = addnode($$,createnode($6));
        $$ = addnode($$,createnode($7));
    }
    | FOR LEFT_PARENTHESIS expression_opt SEMICOLON expression_opt SEMICOLON expression_opt RIGHT_PARENTHESIS statement{
        $$ = createnode("iteration_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
        $$ = addnode($$,$5);
        $$ = addnode($$,createnode($6));
        $$ = addnode($$,$7);
        $$ = addnode($$,createnode($8));
        $$ = addnode($$,$9);
    }
    | FOR LEFT_PARENTHESIS declaration expression_opt SEMICOLON expression_opt RIGHT_PARENTHESIS statement{
        $$ = createnode("iteration_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,$4);
        $$ = addnode($$,createnode($5));
        $$ = addnode($$,$6);
        $$ = addnode($$,createnode($7));
        $$ = addnode($$,$8);
    }
    ;

jump_statement:
    GOTO IDENTIFIER SEMICOLON{
        $$ = createnode("jump_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,createnode($3));
    }
    | CONTINUE SEMICOLON{
        $$ = createnode("jump_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,createnode($2));
    }
    | BREAK SEMICOLON{
        $$ = createnode("jump_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,createnode($2));
    }
    | RETURN expression_opt SEMICOLON{
        $$ = createnode("jump_statement");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
        $$ = addnode($$,createnode($3));
    }
    ;

expression:
    assignment_expression
            {
        $$ = createnode("expression");
        $$ = addnode($$,$1);
    }
    | expression COMMA assignment_expression
           {
        $$ = createnode("expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

assignment_expression:
    conditional_expression
                {
        $$ = createnode("assignment_expression");
        $$ = addnode($$,$1);
    }
    | unary_expression assignment_operator assignment_expression
                    {
        $$ = createnode("assignment_expression");
        $$ = addnode($$,$1);
         $$ = addnode($$,$2);
          $$ = addnode($$,$3);
    }
    ;

conditional_expression:
    logical_OR_expression
                    {
        $$ = createnode("conditional_expression");
        $$ = addnode($$,$1);
    }
    | logical_OR_expression QUESTION_MARK expression COLON conditional_expression
    {
        $$ = createnode("conditional_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
        $$ = addnode($$,$5);
    }
    ;

assignment_operator:
    ASSIGN 
    {
        $$ = createnode("assignment_operator");
        $$ = addnode($$,createnode($1));
    }
    | MULTIPLY_ASSIGN 
        {
        $$ = createnode("assignment_operator");
        $$ = addnode($$,createnode($1));
    }
    | DIVIDE_ASSIGN 
        {
        $$ = createnode("assignment_operator");
        $$ = addnode($$,createnode($1));
    }
    | MODULO_ASSIGN 
        {
        $$ = createnode("assignment_operator");
        $$ = addnode($$,createnode($1));
    }
    | PLUS_ASSIGN 
        {
        $$ = createnode("assignment_operator");
        $$ = addnode($$,createnode($1));
    }
    | MINUS_ASSIGN
        {
        $$ = createnode("assignment_operator");
        $$ = addnode($$,createnode($1));
    }
    | LEFT_SHIFT_ASSIGN 
        {
        $$ = createnode("assignment_operator");
        $$ = addnode($$,createnode($1));
    }
    | RIGHT_SHIFT_ASSIGN 
        {
        $$ = createnode("assignment_operator");
        $$ = addnode($$,createnode($1));
    }
    | AND_ASSIGN 
        {
        $$ = createnode("assignment_operator");
        $$ = addnode($$,createnode($1));
    }
    | XOR_ASSIGN 
        {
        $$ = createnode("assignment_operator");
        $$ = addnode($$,createnode($1));
    }
    | OR_ASSIGN
        {
        $$ = createnode("assignment_operator");
        $$ = addnode($$,createnode($1));
    }
    ;

logical_OR_expression:
    logical_AND_expression
        {
        $$ = createnode("logical_OR_expression");
        $$ = addnode($$,$1);
    }
    | logical_OR_expression OR logical_AND_expression
            {
        $$ = createnode("logical_OR_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

logical_AND_expression:
    inclusive_OR_expression
            {
        $$ = createnode("logical_AND_expression");
        $$ = addnode($$,$1);
    }
    | logical_AND_expression AND inclusive_OR_expression
               {
        $$ = createnode("logical_AND_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

inclusive_OR_expression:
    exclusive_OR_expression
            {
        $$ = createnode("inclusive_OR_expression");
        $$ = addnode($$,$1);
    }
    | inclusive_OR_expression PIPE exclusive_OR_expression
                   {
        $$ = createnode("inclusive_OR_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

exclusive_OR_expression:
    AND_expression
            {
        $$ = createnode("exclusive_OR_expression");
        $$ = addnode($$,$1);
    }
    | exclusive_OR_expression CARET AND_expression
                   {
        $$ = createnode("exclusive_OR_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

AND_expression:
    equality_expression
            {
        $$ = createnode("AND_expression");
        $$ = addnode($$,$1);
    }
    | AND_expression AMPERSAND equality_expression
                   {
        $$ = createnode("AND_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

equality_expression:
    relational_expression
                {
        $$ = createnode("equality_expression");
        $$ = addnode($$,$1);
    }
    | equality_expression EQUALS relational_expression
                   {
        $$ = createnode("equality_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    | equality_expression NOT_EQUALS relational_expression
        {
        $$ = createnode("equality_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

relational_expression:
    shift_expression
                {
        $$ = createnode("relational_expression");
        $$ = addnode($$,$1);
    }
    | relational_expression LESS_THAN shift_expression
            {
        $$ = createnode("relational_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    | relational_expression GREATER_THAN shift_expression
             {
        $$ = createnode("relational_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    | relational_expression LESS_EQUAL shift_expression
             {
        $$ = createnode("relational_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    | relational_expression GREATER_EQUAL shift_expression
             {
        $$ = createnode("relational_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

shift_expression:
    additive_expression
                {
        $$ = createnode("shift_expression");
        $$ = addnode($$,$1);
    }
    | shift_expression LEFT_SHIFT additive_expression
             {
        $$ = createnode("shift_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    | shift_expression RIGHT_SHIFT additive_expression
                 {
        $$ = createnode("shift_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

additive_expression:
    multiplicative_expression
                {
        $$ = createnode("additive_expression");
        $$ = addnode($$,$1);
    }
    | additive_expression PLUS multiplicative_expression
                 {
        $$ = createnode("additive_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    | additive_expression MINUS multiplicative_expression
                     {
        $$ = createnode("additive_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

multiplicative_expression:
    cast_expression
        {
        $$ = createnode("multiplicative_expression");
        $$ = addnode($$,$1);
    }
    | multiplicative_expression ASTERISK cast_expression
     {
        $$ = createnode("multiplicative_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    | multiplicative_expression SLASH cast_expression
         {
        $$ = createnode("multiplicative_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    | multiplicative_expression PERCENT cast_expression
         {
        $$ = createnode("multiplicative_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }
    ;

cast_expression:
    unary_expression
            {
        $$ = createnode("cast_expression");
        $$ = addnode($$,$1);
    }
    | LEFT_PARENTHESIS type_name RIGHT_PARENTHESIS cast_expression
     {
        $$ = createnode("cast_expression");
         $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
           $$ = addnode($$,createnode($3));
        $$ = addnode($$,$4);
    }
    ;

unary_expression:
    postfix_expression
     {
        $$ = createnode("unary_expression");
        $$ = addnode($$,$1);
    }
    | INCREMENT unary_expression
    {
        $$ = createnode("unary_expression");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
    }
    | DECREMENT unary_expression
        {
        $$ = createnode("unary_expression");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
    }
    | unary_operator cast_expression
        {
        $$ = createnode("unary_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
    }
    | SIZEOF unary_expression
        {
        $$ = createnode("unary_expression");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
    }
    | SIZEOF LEFT_PARENTHESIS type_name RIGHT_PARENTHESIS
        {
        $$ = createnode("unary_expression");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
    }
    ;

unary_operator:
    AMPERSAND 
    {
        $$ = createnode("unary_operator");
        $$ = addnode($$,createnode($1));
    }
    | ASTERISK
    {
        $$ = createnode("unary_operator");
        $$ = addnode($$,createnode($1));
    }
    | PLUS
    {
        $$ = createnode("unary_operator");
        $$ = addnode($$,createnode($1));
    }
    | MINUS 
    {
        $$ = createnode("unary_operator");
        $$ = addnode($$,createnode($1));
    }
    | TILDE 
    {
        $$ = createnode("unary_operator");
        $$ = addnode($$,createnode($1));
    }
    | EXCLAMATION
    {
        $$ = createnode("unary_operator");
        $$ = addnode($$,createnode($1));
    }
    ;

postfix_expression:
    primary_expression
    {
        $$ = createnode("postfix_expression");
        $$ = addnode($$,$1);
    }
    | postfix_expression LEFT_BRACKET expression RIGHT_BRACKET
      {
        $$ = createnode("postfix_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
    }
    
    | postfix_expression LEFT_PARENTHESIS argument_expression_list_opt RIGHT_PARENTHESIS
      {
        $$ = createnode("postfix_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,createnode($4));
    }
    | postfix_expression DOT IDENTIFIER
     {
        $$ = createnode("postfix_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
       $$ = addnode($$,createnode($3));
      
    }
    | postfix_expression ARROW IDENTIFIER
     {
        $$ = createnode("postfix_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,createnode($3));
        
    }
    | postfix_expression INCREMENT
     {
        $$ = createnode("postfix_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
     
    }
    | postfix_expression DECREMENT
     {
        $$ = createnode("postfix_expression");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));

    }
    | LEFT_PARENTHESIS type_name RIGHT_PARENTHESIS LEFT_BRACE initializer_list RIGHT_BRACE
     {
        $$ = createnode("postfix_expression");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
       $$ = addnode($$,createnode($3));
        $$ = addnode($$,createnode($4));
         $$ = addnode($$,$5);
       $$ = addnode($$,createnode($6));
    }
    | LEFT_PARENTHESIS type_name RIGHT_PARENTHESIS LEFT_BRACE initializer_list COMMA RIGHT_BRACE
     {
        $$ = createnode("postfix_expression");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
       $$ = addnode($$,createnode($3));
        $$ = addnode($$,createnode($4));
         $$ = addnode($$,$5);
       $$ = addnode($$,createnode($6));
       $$ = addnode($$,createnode($7));
    }
    ;

primary_expression:
    IDENTIFIER
                    {
        $$ = createnode("primary_expression");
        $$ = addnode($$,createnode($1));
    }
    | CONSTANT
      {
        $$ = createnode("primary_expression");
        $$ = addnode($$,createnode($1));
    }

    | STRING_LITERAL
     {
        $$ = createnode("primary_expression");
        $$ = addnode($$,createnode($1));
    }
    | LEFT_PARENTHESIS expression RIGHT_PARENTHESIS
     {
        $$ = createnode("primary_expression");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
        $$ = addnode($$,createnode($3));
    }
    ;

argument_expression_list_opt:
    argument_expression_list
                {
        $$ = createnode("argument_expression_list_opt");
        $$ = addnode($$,$1);
    }
    | /* empty */
                    {
        $$ = createnode("argument_expression_list_opt");
        $$ = addnode($$,createnode(NULL));
    }
    
    ;

argument_expression_list:
    assignment_expression
            {
        $$ = createnode("argument_expression_list");
        $$ = addnode($$,$1);
    }
    | argument_expression_list COMMA assignment_expression
                {
        $$ = createnode("argument_expression_list");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
    }

    ;

initializer:
    assignment_expression
        {
        $$ = createnode("initializer");
        $$ = addnode($$,$1);
    }
    | LEFT_BRACE initializer_list RIGHT_BRACE
            {
        $$ = createnode("initializer");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
        $$ = addnode($$,createnode($3));
    }
    | LEFT_BRACE initializer_list COMMA RIGHT_BRACE
                {
        $$ = createnode("initializer");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
        $$ = addnode($$,createnode($3));
        $$ = addnode($$,createnode($4));
    }
    ;

initializer_list:
    designation_opt initializer
    {
        $$ = createnode("initializer_list");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
    }
    | initializer_list COMMA designation_opt initializer
    {
        $$ = createnode("initializer_list");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
        $$ = addnode($$,$3);
        $$ = addnode($$,$4);
    }
    ;

designation_opt:
    designation
         {
        $$ = createnode("designation_opt");
        $$ = addnode($$,$1);
    }
    | /* empty */
             {
        $$ = createnode("designation_opt");
        $$ = addnode($$,createnode(NULL));
    }

    ;

designation:
    designator_list ASSIGN
                             {
        $$ = createnode("designation");
        $$ = addnode($$,$1);
        $$ = addnode($$,createnode($2));
    }
    ;

designator_list:
    designator
     {
        $$ = createnode("designator_list");
        $$ = addnode($$,$1);
    }
    | designator_list designator
                         {
        $$ = createnode("designator_list");
        $$ = addnode($$,$1);
        $$ = addnode($$,$2);
    }
    ;

designator:
    LEFT_BRACKET constant_expression RIGHT_BRACKET
                   {
        $$ = createnode("designator");
        $$ = addnode($$,createnode($1));
        $$ = addnode($$,$2);
        $$ = addnode($$,createnode($3));
    }
    | DOT IDENTIFIER
                  {
        $$ = createnode("designator");
        $$ = addnode($$,createnode($1));
       $$ = addnode($$,createnode($2));
    }
    ;

constant_expression:
    conditional_expression
               {
        $$ = createnode("constant_expression");
        $$ = addnode($$,$1);
    }
    ;

type_name:
    specifier_qualifier_list
           {
        $$ = createnode("type_name");
        $$ = addnode($$,$1);
    }
    ;

specifier_qualifier_list:
    type_specifier specifier_qualifier_list_opt
            {
        $$ = createnode("specifier_qualifier_list");
        $$ = addnode($$,$1);
         $$ = addnode($$,$2);
    }
    | type_qualifier specifier_qualifier_list_opt
           {
        $$ = createnode("specifier_qualifier_list");
        $$ = addnode($$,$1);
         $$ = addnode($$,$2);
    }
    ;


storage_class_specifier:
     EXTERN
             {
        $$ = createnode("storage_class_specifier");
        $$ = addnode($$,createnode($1));
    }
    | STATIC
            {
        $$ = createnode("storage_class_specifier");
        $$ = addnode($$,createnode($1));
    }
    | AUTO
            {
        $$ = createnode("storage_class_specifier");
        $$ = addnode($$,createnode($1));
    }
    | REGISTER
            {
        $$ = createnode("storage_class_specifier");
        $$ = addnode($$,createnode($1));
    }
    ;


type_specifier:
    VOID
        {
        $$ = createnode("type_specifier");
        $$ = addnode($$,createnode($1));
    }
    | CHAR
            {
        $$ = createnode("type_specifier");
        $$ = addnode($$,createnode($1));
    }
    | SHORT
            {
        $$ = createnode("type_specifier");
        $$ = addnode($$,createnode($1));
    }
    | INT
            {
        $$ = createnode("type_specifier");
        $$ = addnode($$,createnode($1));
    }
    | LONG
            {
        $$ = createnode("type_specifier");
        $$ = addnode($$,createnode($1));
    }

    | FLOAT
            {
        $$ = createnode("type_specifier");
        $$ = addnode($$,createnode($1));
    }
    | DOUBLE
            {
        $$ = createnode("type_specifier");
        $$ = addnode($$,createnode($1));
    }
    | SIGNED
            {
        $$ = createnode("type_specifier");
        $$ = addnode($$,createnode($1));
    }
    | UNSIGNED
            {
        $$ = createnode("type_specifier");
        $$ = addnode($$,createnode($1));
    }
    | BOOL
            {
        $$ = createnode("type_specifier");
        $$ = addnode($$,createnode($1));
    }
    | COMPLEX
            {
        $$ = createnode("type_specifier");
        $$ = addnode($$,createnode($1));
    }
    | IMAGINARY
            {
        $$ = createnode("type_specifier");
        $$ = addnode($$,createnode($1));
    }
    ;


type_qualifier:
    CONST
        {
        $$ = createnode("type_qualifier");
        $$ = addnode($$,createnode($1));
    }
    | RESTRICT
        {
        $$ = createnode("type_qualifier");
        $$ = addnode($$,createnode($1));
    }
    | VOLATILE
    {
        $$ = createnode("type_qualifier");
        $$ = addnode($$,createnode($1));
    }
    ;

function_specifier: 
    INLINE
    {
        $$ = createnode("function_specifier");
        $$ = addnode($$,createnode($1));
    }
    ;



%%





