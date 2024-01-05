%option noyywrap

%{

#include <stdlib.h>
#include <stdio.h>

#include "parser.h"
#include "SymbolTable.h"
#include "SymbolInfo.h"
#include "ScopeTable.h"

void yyerror (char *);
extern YYSTYPE yylval;
extern SymbolTable *table;
extern FILE *logout;
char *arr[100];
char *final_arr[100];

int k; //final_arr count
int i = 0; //arr count
int line_count = 1;

%}


id [a-z]*
DOUBLE (([0-9]+(\.[0-9]*)?)|([0-9]*\.[0-9]+)) 
newline \n

%%

{newline} {
        arr[i] = "\n",final_arr[k] = arr[i];
        i++; k++;
        line_count++;
    }

[ \t]+  {}
(([0-9]+(\.[0-9]*)?)|([0-9]*\.[0-9]+))  {
                        yylval.f = atof(yytext);
                        return DOUBLE;
                    }

"int" {
        memset(&arr,0,sizeof(arr)); i = 0;
        arr[i] = "int "; 
        final_arr[k] = "int ";
        i++; k++;
        return INT;
    }
"float" {
        memset(&arr,0,sizeof(arr)); i = 0;
        arr[i] = "float "; final_arr[k] = "float ";
        i++; k++;
        return FLOAT;
    }
"void"  {
        memset(&arr,0,sizeof(arr)); i = 0;
        arr[i] = "void "; final_arr[k] = "void ";
        i++; k++;
        return VOID;
    }   


";" {
        arr[i] = ";";final_arr[k] = ";";
        i++; k++;
        return SEMICOLON;}
"," {
        arr[i] = ","; final_arr[k] = ",";
        i++; k++;
        return COMMA;
    }
"(" {
        arr[i] = "(";final_arr[k] = "(";
        i++; k++;
        return LPAREN;}
")" {
        arr[i] = ")";final_arr[k] = ")";
        i++; k++;
        return RPAREN;}
"{" {return LCURL;}
"}" {return RCURL;}

{id}    {
        yylval.s = strdup(yytext);
        arr[i] = strdup(yytext); final_arr[k] = strdup(yytext);
        k++; i++;
        for(int j = 1; arr[j] != NULL; j++)
        {
            //fprintf(logout,"%s", arr[j]);
            //fprintf(logout,"arr [%d] %s\n ",j,arr[j]);
        }
        //fprintf(logout,"\n\n");
        return ID;

        }

%%
