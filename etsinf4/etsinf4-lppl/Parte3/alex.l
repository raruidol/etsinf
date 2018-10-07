%{
#include <stdio.h>
#include "header.h"
#include "asin.h"
#include "libtds.h"

void visualizar(char* texto);
extern FILE *yyin;
%}
%option yylineno

letra [A-Za-z]
letraMay [A-Z]
letraMin [a-z]
digito [0-9]
delimitador [ \t\n]+
id {letra}({letra}|{digito}|"_")*
pal_res "int"|"bool"|"cte"|"id"|"read"|"print"|"if"|"elseif"|"while"|"else"|"do"|"true"|"false"
%%
{digito}+             {if(verbosidad) ECHO;yylval.cent= atoi(yytext); return(CTE_);}
{digito}+"."{digito}* {if(verbosidad) ECHO;yylval.cent= atoi(yytext); return(CTE_);}
{digito}*"."{digito}+ {if(verbosidad) ECHO;yylval.cent= atoi(yytext); return(CTE_);}
"int"               {if(verbosidad) ECHO;return(INT_);}
"bool"              {if(verbosidad) ECHO;return(BOOL_);}
"read"              {if(verbosidad) ECHO;return(READ_);}
"print"             {if(verbosidad) ECHO;return(PRINT_);}
"if"                {if(verbosidad) ECHO;return(IF_);}
"elseif"            {if(verbosidad) ECHO;return(ELIF_);}
"while"             {if(verbosidad) ECHO;return(WHILE_);}
"else"              {if(verbosidad) ECHO;return(ELSE_);}
"do"                {if(verbosidad) ECHO;return(DO_);}
"true"              {if(verbosidad) ECHO;return(TRUE_);}
"false"             {if(verbosidad) ECHO;return(FALSE_);}
"//".*              {if(verbosidad) ECHO;}
"+="        {if(verbosidad) ECHO;return(ASIGSUMA_);}
"-="        {if(verbosidad) ECHO;return(ASIGRESTA_);}
"*="        {if(verbosidad) ECHO;return(ASIGPRODUCTO_);}
"/="        {if(verbosidad) ECHO;return(ASIGDIVISION_);}
"&&"        {if(verbosidad) ECHO;return(LOGICOAND_);}
"||"        {if(verbosidad) ECHO;return(LOGICOOR_);}
"=="        {if(verbosidad) ECHO;return(IGUALDAD_);}
"!="        {if(verbosidad) ECHO;return(DISTINTO_);}
">="        {if(verbosidad) ECHO;return(MAYORIGU_);}
"<="        {if(verbosidad) ECHO;return(MENORIGU_);}
"++"        {if(verbosidad) ECHO;return(INCREMENTO_);}
"--"        {if(verbosidad) ECHO;return(DECREMENTO_);}
"="                 {if(verbosidad) ECHO;return(ASIG_);} 
"+"                 {if(verbosidad) ECHO;return(OPSUMA_);} 
"-"                 {if(verbosidad) ECHO;return(OPRESTA_);}
"*"                 {if(verbosidad) ECHO;return(OPMULT_);}
"/"                 {if(verbosidad) ECHO;return(OPDIV_);}
"%"                 {if(verbosidad) ECHO;return(OPRESTO_);}
">"                  {if(verbosidad) ECHO;return(MAYOR_);}
"<"                 {if(verbosidad) ECHO;return(MENOR_);}
"!"                 {if(verbosidad) ECHO;return(OPNEG_);}
{delimitador}       {if(verbosidad) ECHO;}
"["                 {if(verbosidad) ECHO;return(ACORCH_);}
"]"                 {if(verbosidad) ECHO;return(CCORCH_);}
"("                 {if(verbosidad) ECHO;return(APAR_);}
")"                 {if(verbosidad) ECHO;return(CPAR_);}
"{"                 {if(verbosidad) ECHO;return(IBLOCK_);}
"}"                 {if(verbosidad) ECHO;return(FBLOCK_);}
";"                 {if(verbosidad) ECHO;return(PCOMA_);}
{letra}({letra}|{digito}|"_")*          {if(verbosidad) ECHO;yylval.cadena = (char *)malloc(sizeof(char)*yyleng+1); strcpy(yylval.cadena,yytext); return(ID_);}
.		{yyerror("Caracter desconocido");}
%%
