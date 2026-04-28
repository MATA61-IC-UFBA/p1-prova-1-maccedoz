%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
void yyerror(const char *msg);
%}

%union {
    float val;
    char *str;
    char *id;
}

%token <val> NUM
%token <str> STRING
%token <id> ID
%token PRINT CONCAT LENGTH EOL ERROR
%token PLUS MINUS TIMES DIV ASSIGN LPAR RPAR COMMA

%left PLUS MINUS
%left TIMES DIV

%%

program:
    /* empty */
    | program line
    ;

line:
    EOL
    | stmt EOL
    ;

stmt:
    ID ASSIGN expr
    | PRINT print_args
    | PRINT LPAR print_args RPAR
    | expr
    ;

print_args:
    expr
    | print_args COMMA expr
    ;

expr:
    NUM
    | STRING
    | ID
    | expr PLUS expr
    | expr MINUS expr
    | expr TIMES expr
    | expr DIV expr
    | LPAR expr RPAR
    | LENGTH LPAR expr RPAR
    | CONCAT LPAR concat_args RPAR
    ;

concat_args:
    expr COMMA expr
    | concat_args COMMA expr
    ;

%%
