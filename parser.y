%{
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "SymbolTable.h"
#include "SymbolInfo.h"
#include "ScopeTable.h"

int yyparse(void);
int yylex(void);
extern char* yytext;
extern FILE * yyin;
extern int tableSize;

extern void yyset_debug(int);

FILE *logout;
extern int line_count;
extern char *arr[100];
extern char *final_arr[100];

SymbolTable *table;

void yyerror (const char *s)
{
    fprintf(stderr,"%s\n",s);
    return;
}

%}

%union {
    struct SymbolInfo* sym;
    char *s;
    float f;
    char c;
}

%define parse.error verbose
%verbose
%token COMMA INT ID SEMICOLON FLOAT VOID LCURL RCURL RETURN NOT IF FOR WHILE PRINTLN LPAREN RPAREN
%token CONST_INT CONST_FLOAT LTHIRD RTHIRD
%token INCOP DECOP RELOP LOGICOP ASSIGNOP

%type <c> ADDOP MULOP

%token <f> DOUBLE
//%expect 1

%precedence THEN
%precedence ELSE

%left "<" ">" "<=" ">=" "=" "!="
%left "+" "-"
%left "*" "/"
%left UMINUS 


%%

start : program     {   fprintf(stderr, "start -> program\n");
                        fprintf(logout,"%d : start ->  program\n",line_count);
                    }
      ;

program : program unit {
                            fprintf(stderr, "program -> program unit\n");
                            fprintf(logout,"%d : program -> program unit\n\n",line_count);
                            for(int j = 0; final_arr[j] != NULL; j++)
                            {
                                fprintf(logout,"%s",final_arr[j]);
                            }
                                fprintf(logout,"\n\n");
                        }
        | unit          {
                            fprintf(stderr, "program -> unit\n");
                            fprintf(logout,"%d : program -> unit\n\n",line_count);
                            for(int j = 0; final_arr[j] != NULL; j++)
                            {
                                fprintf(logout,"%s",final_arr[j]);
                            }
                                fprintf(logout,"\n\n");

                        }
        ;

unit : var_dec  {
                    fprintf(stderr, "unit -> var_dec\n");
                    fprintf(logout,"%d : unit -> var_dec\n\n",line_count);
                    for(int j = 0; arr[j] != NULL; j++)
                        {
                            fprintf(logout,"%s",arr[j]);
                        }
                    fprintf(logout,"\n\n");

                }
                |func_declaration {

                fprintf(logout,"%d : unit -> func_declaration\n\n",line_count);
                    for(int j = 0; arr[j] != NULL; j++)
                        {
                            fprintf(logout,"%s",arr[j]);
                        }
                    fprintf(logout,"\n\n");
                }
                |func_definition {

                fprintf(logout,"%d : unit -> func_definition\n\n",line_count);
                    for(int j = 0; arr[j] != NULL; j++)
                        {
                            fprintf(logout,"%s",arr[j]);
                        }
                    fprintf(logout,"\n\n");

                }
                ;

     ;

func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON     {

                fprintf(stderr, "func_declaration -> type_specifier id LPAREN parameter_list RPAREN SEMICOLON\n");
                fprintf(logout,"%d : func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n", line_count);
                for(int j = 0; arr[j] != NULL; j++)
                        {
                            fprintf(logout,"%s",arr[j]);
                        }
                    fprintf(logout,"\n\n");

        }
        | type_specifier ID LPAREN RPAREN SEMICOLON {
                fprintf(stderr, "func_declaration -> type_specifier id LPAREN RPAREN SEMICOLON\n");
                fprintf(logout,"%d : func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n", line_count); 

                for(int j = 0; arr[j] != NULL; j++)
                        {
                            fprintf(logout,"%s",arr[j]);
                        }
                    fprintf(logout,"\n\n");


        }
        ;

func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement {
                fprintf(stderr, "func_definition -> type_specifier ID LPAREN parameter_list RPAREN compound_statement\n");
                fprintf(logout,"%d : func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n", line_count); 

        }
        | type_specifier ID LPAREN RPAREN compound_statement {
                fprintf(stderr, "func_definition -> type_specifier id LPAREN RPAREN compound_statement\n");
                fprintf(logout,"%d : func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n", line_count);    

        }
        ;               


parameter_list  : parameter_list COMMA type_specifier ID {

                fprintf(stderr, "parameter_list -> parameter_list COMMA type_specifier ID\n");
                fprintf(logout,"%d : parameter_list  : parameter_list COMMA type_specifier ID\n\n", line_count);    
                for(int j = 0; arr[j] != NULL; j++)
                        {
                            fprintf(logout,"%s",arr[j]);
                        }
                    fprintf(logout,"\n\n");

        }
        | parameter_list COMMA type_specifier {
                fprintf(stderr, "parameter_list -> parameter_list COMMA type_specifier\n");
                fprintf(logout,"%d : parameter_list  : parameter_list COMMA type_specifier\n\n", line_count);   

        }
        | type_specifier ID {
                fprintf(stderr, "parameter_list -> type_specifier ID\n");
                fprintf(logout,"%d : parameter_list : type_specifier ID\n\n", line_count);  
                for(int j = 0; arr[j] != NULL; j++)
                        {
                            fprintf(logout,"%s",arr[j]);
                        }
                    fprintf(logout,"\n\n");
        }
        | type_specifier {
                fprintf(stderr, "parameter_list -> type_specifier\n");
                fprintf(logout,"%d :  parameter_list : type_specifier \n\n", line_count);   

        }
        ;


compound_statement : LCURL statements RCURL {
    fprintf(stderr, "compound_statement -> LCURL statements RCURL\n");
    fprintf(logout,"compound_statement : LCURL statements RCURL\n\n");
}
            | LCURL RCURL
            ;

var_dec: type_specifier declaration_list SEMICOLON {

                    fprintf(stderr, "var_dec -> type_specifier declaration_list SEMICOLON \n");
                    fprintf(logout,"%d : var_dec: type_specifier declaration_list SEMICOLON \n\n", line_count);

                    for(int j = 0; arr[j] != NULL; j++)
                        {
                            fprintf(logout,"%s",arr[j]);
                        }
                    fprintf(logout,"\n\n");

            }
        ;            

type_specifier : INT    {fprintf(stderr, "type_specifier -> INT\n");
                            fprintf(logout,"%d : type_specifier-> INT\n\n%s\n\n", line_count,yytext);
                        }
               | FLOAT  {fprintf(stderr, "type_specifier ->FLOAT\n");
                            fprintf(logout,"%d : type_specifier-> FLOAT\n\n%s\n\n",line_count, yytext);

                        }
               | VOID   {fprintf(stderr, "type_specifier -> VOID\n");
                            fprintf(logout,"%d : type_specifier-> VOID\n\n%s\n\n",line_count, yytext);

                         }
               ;        

declaration_list : declaration_list COMMA ID {

                        fprintf(stderr, "declaration_list -> declaration_list COMMA ID\n");  
                        fprintf(logout,"%d : declaration_list -> declaration_list COMMA ID\n\n",line_count);
                        for(int j = 1; arr[j+1] != NULL; j++)
                        {
                            fprintf(logout,"%s",arr[j]);
                        }
                            fprintf(logout,"\n\n");
                       }
                 | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD {

                        fprintf(stderr, "declaration_list -> declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n");      
                        fprintf(logout,"%d : declaration_list -> declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n",line_count);
                        for(int j = 1; arr[j+1] != NULL; j++)
                        {
                            fprintf(logout,"%s",arr[j]);
                        }
                            fprintf(logout,"\n\n");

                        }
                 |ID    {
                        fprintf(stderr, "declaration_list -> ID\n");
                        fprintf(logout,"%d : declaration_list -> ID\n\n",line_count);
                        for(int j = 1; arr[j+1] != NULL; j++)
                        {
                            fprintf(logout,"%s",arr[j]);
                        }
                            fprintf(logout,"\n\n");
                        }
                 |ID LTHIRD CONST_INT RTHIRD {

                        fprintf(stderr, "declaration_list -> ID LTHIRD CONST_INT RTHIRD\n"); 
                        fprintf(logout,"%d : declaration_list -> ID LTHIRD CONST_INT RTHIRD\n",line_count);
                        for(int j = 1; arr[j+1] != NULL; j++)
                        {
                            fprintf(logout,"%s",arr[j]);
                        }
                            fprintf(logout,"\n\n");

                        }
                 ;  

statements : statement {
    fprintf(stderr, "statements -> statement\n");
    fprintf(logout,"%d : statements : statement\n\n",line_count);
    fprintf(logout, "%s\n\n",yytext);
}
       | statements statement
       ;

statement : var_dec
      | expression_statement
      | compound_statement
      | FOR LPAREN expression_statement expression_statement expression RPAREN statement
      | IF LPAREN expression RPAREN statement
      | WHILE LPAREN expression RPAREN statement
      | PRINTLN LPAREN ID RPAREN SEMICOLON
      | RETURN expression SEMICOLON  {
            fprintf(stderr, "statement -> RETURN expression SEMICOLON\n");
            fprintf(logout,"%d : statement : RETURN expression SEMICOLON\n\n",line_count);
            fprintf(logout, "%s\n\n",yytext);
      }
      ;

expression_statement    : SEMICOLON         
            | expression SEMICOLON 
            ;

variable : ID   {
                    fprintf(stderr, "variable -> ID\n");
                    fprintf(logout,"%d : variable : ID\n\n",line_count);
                    fprintf(logout, "%s\n\n",yytext);
}   
     | ID LTHIRD expression RTHIRD 
     ;

 expression : logic_expression  {
        fprintf(stderr, "expression -> logic_expression\n");
        fprintf(logout,"%d : expression : logic_expression\n\n",line_count);
        fprintf(logout, "%s\n\n",yytext);
 }
       | variable ASSIGNOP logic_expression     
       ;

logic_expression : rel_expression   
         | rel_expression LOGICOP rel_expression    
         ;

rel_expression  : simple_expression {
    fprintf(stderr, "rel_expression  -> simple_expression \n");
    fprintf(logout,"%d : rel_expression : simple_expression\n\n",line_count);
    fprintf(logout, "%s\n\n",yytext);
}
        | simple_expression RELOP simple_expression 
        ;

simple_expression : term {
    fprintf(stderr, "simple_expression -> term\n");
    fprintf(logout,"%d : simple_expression : term \n\n",line_count);
    fprintf(logout, "%s\n\n",yytext);
} 
          | simple_expression ADDOP term {
            fprintf(stderr, "simple_expression -> simple_expression ADDOP(%c) term\n", $2);
            fprintf(logout,"simple_expression : simple_expression ADDOP(%c) term \n\n", $2);
            fprintf(logout, "%s\n\n",yytext);
          }
          ;

term :  unary_expression {
                fprintf(stderr, "term -> unary_expression\n");
                fprintf(logout,"%d : term : unary_expression\n\n",line_count);
                fprintf(logout, "%s\n\n",yytext);
            }
     |  term MULOP unary_expression {
                fprintf(stderr, "term -> term MULOP(%c) unary_expression \n", $2);
                fprintf(logout,"%d : term -> term MULOP(%c) unary_expression\n\n", line_count, $2);
                fprintf(logout, "%s\n\n",yytext);
            }
     ;

unary_expression : ADDOP unary_expression  
         | NOT unary_expression 
         | factor {
            fprintf(stderr, "unary_expression -> factor\n");
            fprintf(logout,"%d : unary_expression : factor\n\n",line_count);
            fprintf(logout, "%s\n\n",yytext);
         }
         ;

factor  : variable {
    fprintf(stderr, "factor -> variable\n");
    fprintf(logout,"%d : factor : variable\n\n",line_count);
    fprintf(logout, "%s\n\n",yytext);
}
    | ID LPAREN argument_list RPAREN
    | LPAREN expression RPAREN
    | CONST_INT 
    | CONST_FLOAT
    | variable INCOP 
    | variable DECOP
    ;

argument_list : arguments
              |
              ;

arguments : arguments COMMA logic_expression
          | logic_expression
          ;

MULOP : '*' { $$ = '*'; fprintf(stderr, "MULOP*\n"); }
      | '/' { $$ = '/'; fprintf(stderr, "MULOP/\n"); }

ADDOP : '+' { $$ = '+'; fprintf(stderr, "ADDOP+\n"); }
      | '-' { $$ = '-'; fprintf(stderr, "ADDOP-\n"); }

%%

int main(int argc, char *argv[])
{
    FILE *fp ;
    char *progname= argv[0];
/*  int token = 0; */

    if (argc>1 && strcasecmp(argv[1], "-d")==0) {
#if defined(YYDEBUG)
        yydebug= 1;
        yyset_debug(1);
#else
        fprintf(stderr, "sorry, it was compiled without -DYYDEBUG\n");
#endif
        --argc;
        ++argv;
    }

    if (argc<2) {
        fprintf(stderr, "usage: %s [-d] inputfile\n", progname);
        exit(1);
    }

    if ((fp = fopen(argv[1],"r")) == NULL) {
        fprintf(stderr,"cannot open file '%s': %s\n", argv[1], strerror(errno));
        exit(1);
    }

    logout = fopen("log.txt","w");
    if (logout==NULL) {
        fprintf(stderr,"cannot open file '%s': %s\n", "log.txt", strerror(errno));
        exit(1);
    }

    yyin = fp;
    yyparse();

    fclose(fp);
    fclose(logout);
    return 0;

}
