%{
#include "prova1.tab.h"
#include <stdlib.h>
#include <string.h>

void yyerror(const char *msg);
%}

%option noyywrap

%%
"//".* { }

"print"           { return PRINT; }
"concat"          { return CONCAT; }
"length"          { return LENGTH; }

[0-9]+(\.[0-9]+)? { yylval.val = atof(yytext); return NUM; }

\"[^"\n]*\"       { 
                    yytext[strlen(yytext)-1] = '\0';
                    yylval.str = strdup(yytext + 1); 
                    return STRING; 
                  }

[a-z_][a-z0-9_]* { 
                    yylval.id = strdup(yytext); 
                    return ID; 
                 }

"="               { return ASSIGN; }
"+"               { return PLUS; }
"-"               { return MINUS; }
"*"               { return TIMES; }
"/"               { return DIV; }
"("               { return LPAR; }
")"               { return RPAR; }
","               { return COMMA; }
"\n"              { return EOL; }

[ \t\r]           { }
.                 { return ERROR; }

%%

