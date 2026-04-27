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

%type <val> expr
%type <str> sexpr
%type <str> arg_list

%%

program:
    | program line
    ;

line:
    EOL
    | stmt EOL
    | error EOL { yyerrok; }
    ;

stmt:
    ID ASSIGN expr
    | ID ASSIGN sexpr
    | PRINT expr           { printf("%g\n", $2); }
    | PRINT sexpr          { printf("%s\n", $2); }
    | PRINT LPAR expr RPAR { printf("%g\n", $3); }
    | PRINT LPAR sexpr RPAR { printf("%s\n", $3); }
    ;

expr:
    NUM                     { $$ = $1; }
    | ID                    { $$ = 0; }
    | expr PLUS expr        { $$ = $1 + $3; }
    | expr MINUS expr       { $$ = $1 - $3; }
    | expr TIMES expr       { $$ = $1 * $3; }
    | expr DIV expr         { $$ = ($3 != 0) ? ($1 / $3) : 0; }
    | LPAR expr RPAR        { $$ = $2; }
    | LENGTH LPAR sexpr RPAR { $$ = strlen($3); }
    ;

sexpr:
    STRING                  { $$ = $1; }
    | ID                    { $$ = ""; }
    | CONCAT LPAR arg_list RPAR { $$ = $3; }
    | LPAR sexpr RPAR       { $$ = $2; }
    ;

arg_list:
    sexpr                   { $$ = $1; }
    | arg_list COMMA sexpr  { 
        char *res = malloc(strlen($1) + strlen($3) + 1);
        strcpy(res, $1);
        strcat(res, $3);
        $$ = res;
    }
    ;

%%

