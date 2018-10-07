%{
#include <stdio.h>
#include "libtds.h"
#include "header.h" 
extern int yylineno;
extern FILE *yyin;
int numErrores ;
%}
%token TRUE_ FALSE_ INCREMENTO_ DECREMENTO_ INT_ BOOL_ READ_ ASIG_ ASIGSUMA_ ASIGRESTA_ ASIGDIVISION_ ASIGPRODUCTO_ LOGICOAND_ LOGICOOR_ IGUALDAD_ DISTINTO_ MAYOR_ MENOR_ MAYORIGU_ MENORIGU_ OPNEG_ PCOMA_ IBLOCK_ FBLOCK_ PRINT_ ACORCH_ CCORCH_ APAR_ CPAR_ IF_ ELSE_ ELIF_ WHILE_ DO_

%union{
	int cent;
	char *cadena;
	int tipo;
}


%type<tipo> declaracion tipoSimple expresion expresionLogica expresionIgualdad expresionRelacional expresionAditiva expresionMultiplicativa expresionUnaria expresionSufija 
%token<cent> OPSUMA_ OPMULT_ OPDIV_ OPRESTA_ OPRESTO_ CTE_
%token<cadena> ID_


%%
programa: IBLOCK_ secuenciaSentencias FBLOCK_
;
secuenciaSentencias: sentencia 
| secuenciaSentencias sentencia
;
sentencia: declaracion
| instruccion
;
declaracion: tipoSimple ID_ PCOMA_ { if (!insertarTDS($2,$1,0,-1)){yyerror("Elemento ya declarado");}}
|tipoSimple ID_ ACORCH_ CTE_ CCORCH_ PCOMA_ { int numel = $4; int ref;
						if ($4 <=0){yyerror("Talla inapropiada del array en la declaracion"); numel=0;}
						ref = insertaTDArray($1, numel);
						if(!insertarTDS($2,T_ARRAY,0,ref)){yyerror("Elemento ya declarado");}}
;
tipoSimple: INT_ {$$ = T_ENTERO;}
| BOOL_ {$$ = T_LOGICO;}
;
instruccion: IBLOCK_ listaInstrucciones FBLOCK_ 
| instruccionEntradaSalida 
| instruccionExpresion 
| instruccionSeleccion 
| instruccionIteracion 
;
listaInstrucciones: listaInstrucciones instruccion 
|
;
instruccionExpresion: expresion PCOMA_ 
| PCOMA_
;
instruccionEntradaSalida: READ_ APAR_ ID_ CPAR_ PCOMA_ {SIMB sim = obtenerTDS($3);
							if(sim.tipo == T_ERROR){yyerror("Objeto no declarado");}
							else if (sim.tipo == T_LOGICO){yyerror("Tipo incorrecto (I/O)");}
							}
| PRINT_ APAR_ expresion CPAR_ PCOMA_ {if($3 != T_ENTERO && $3 != T_ERROR){yyerror("Tipo incorrecto print");}}
;
instruccionSeleccion: IF_ APAR_ expresion CPAR_ {if($3 != T_ERROR && $3 != T_LOGICO){yyerror("Se esperaba expresion tipo logica en el if.");}} instruccion restoIf 
;
restoIf: ELIF_ APAR_ expresion CPAR_ {if($3 != T_ERROR && $3 != T_LOGICO){yyerror("Se esperaba expresion tipo logica en el else_if.");}} instruccion restoIf 
| ELSE_ instruccion 
;
instruccionIteracion: WHILE_ APAR_ expresion CPAR_ {if($3 != T_LOGICO && $3 != T_ERROR) {yyerror("Se esperaba expresion tipo logica en el while.");}} instruccion 
| DO_ instruccion WHILE_ APAR_ expresion CPAR_ {if($5 != T_LOGICO && $5 != T_ERROR){yyerror("Se esperaba expresion tipo logica en el do_while.");}}
;
expresion: expresionLogica {$$ = $1;}
| ID_ operadorAsignacion expresion 	{SIMB sim = obtenerTDS($1); $$ = T_ERROR;
					if(sim.tipo == T_ERROR) {yyerror("Objeto no declarado");}
					else {	if($3 != T_ERROR){
							if( sim.tipo != $3){yyerror("Error de tipos en la instruccion de asignacion (expresion)");}
					}}
					}
| ID_ ACORCH_ expresion CCORCH_ operadorAsignacion expresion 
					{SIMB sim = obtenerTDS($1); $$ = T_ERROR;
					if(sim.tipo == T_ERROR){
						yyerror("Objeto no declarado");
					}else{
						if($6 != T_ERROR){
							if(sim.tipo != T_ARRAY){
								yyerror("El identificador tiene que ser de tipo Array");
							}else{
								DIM dim = obtenerInfoArray(sim.ref);
								if(!((dim.telem == $6)&&($6 == T_ENTERO || $6 == T_LOGICO))){
									yyerror("Error de tipos en la instruccion de asignacion (expresion)");
								}else{ 
									if($3!=T_ENTERO){
										yyerror("El indice del array tiene que ser un entero");
									}else{
										$$ = sim.tipo;
									}
								}
							}
						}
					}}
;
					  
expresionLogica: expresionIgualdad {$$ = $1;}
| expresionLogica operadorLogico expresionIgualdad 
					{ if ($1 == T_LOGICO && $3 == T_LOGICO) {$$ = T_LOGICO;}
					else {$$ = T_ERROR; yyerror("los tipos no coinciden (logica)");$$ = T_ERROR;}}
;
expresionIgualdad: expresionRelacional {$$ = $1;}
| expresionIgualdad operadorIgualdad expresionRelacional 
					{if ($1 ==  $3 == T_ENTERO) {$$ = T_LOGICO;}
					else {$$ = T_ERROR; yyerror("los tipos no coinciden (igualdad)");$$ = T_ERROR;}}
;
expresionRelacional: expresionAditiva {$$ = $1;}
| expresionRelacional operadorRelacional expresionAditiva 
					{ if ($1 == T_ENTERO && $3 == T_ENTERO) {$$ = T_LOGICO;}
					else {$$ = T_ERROR; yyerror("los tipos no coinciden (relacional)");$$ = T_ERROR;}}
;
expresionAditiva: expresionMultiplicativa {$$ = $1;}
| expresionAditiva operadorAditivo expresionMultiplicativa 
					{if ($1 == $3 == T_ENTERO) {$$ = $1;}
					else {$$ = T_ERROR; yyerror("los tipos no coinciden (aditiva)");$$ = T_ERROR;}}
;
expresionMultiplicativa: expresionUnaria {$$ = $1;}
| expresionMultiplicativa operadorMultiplicativo expresionUnaria 
					{ if ($1 == $3 == T_ENTERO) {$$ = $1;}
					else {$$ = T_ERROR; yyerror("los tipos no coinciden (multiplicativa)");$$ = T_ERROR;}}
;
expresionUnaria: expresionSufija {$$ = $1;}
| operadorUnario expresionUnaria {if($2 != T_LOGICO){yyerror("Tipo inapropiado. (unaria)"); $$ = T_ERROR;}
				  else{$$ = $2;}}
| operadorIncremento ID_ {SIMB sim = obtenerTDS($2); $$ = T_ERROR;
					if(sim.tipo == T_ERROR) {yyerror("Objeto no declarado");}
					else {	if(sim.tipo == T_LOGICO) {yyerror("Tipo inapropiado. (unaria)");$$ = T_ERROR;}
						else{$$=sim.tipo;}}}
;
expresionSufija: APAR_ expresion CPAR_ {$$ = $2;} 
| ID_ operadorIncremento { SIMB sim = obtenerTDS($1); $$ = T_ERROR;
					if(sim.tipo == T_ERROR) {yyerror("Objeto no declarado");}
					else {	if(sim.tipo == T_LOGICO) {yyerror("Tipo inapropiado. (sufija)");$$ = T_ERROR;}
						else {$$ = sim.tipo;}}}

| ID_ ACORCH_ expresion CCORCH_ 
					{
						$$ = T_ERROR;
						SIMB sim = obtenerTDS($1);
						if(sim.tipo == T_ERROR){
							yyerror("Objeto no declarado");
						}else{
							if(sim.tipo != T_ARRAY){
								yyerror("Se esperaba un identificador de tipo Array");$$ = T_ERROR;
							}else{
								if ($3 != T_ENTERO ) {yyerror("Error de indexacion del array (sufija)");$$ = T_ERROR;}
								else {
									DIM dim = obtenerInfoArray(sim.ref);
									if($3 < 0 || $3 > dim.nelem){
										yyerror("El indice del array esta fuera del rango");$$ = T_ERROR;
									}else{
										$$ = dim.telem;
										}
									}
								}
							}
					}
| ID_ 					{ SIMB sim = obtenerTDS($1); $$ = T_ERROR;
					if(sim.tipo == T_ERROR) {yyerror("Objeto no declarado");}
					else{$$ = sim.tipo;} } 
| CTE_ {$$ = T_ENTERO;}
| TRUE_ {$$ = T_LOGICO;}
| FALSE_ {$$ = T_LOGICO;}
;
operadorAsignacion: ASIG_ 
| ASIGSUMA_ 
| ASIGRESTA_ 
| ASIGPRODUCTO_ 
| ASIGDIVISION_ 
;
operadorLogico: LOGICOAND_ 
| LOGICOOR_ 
;
operadorIgualdad: IGUALDAD_ 
| DISTINTO_ 
;
operadorRelacional: MAYOR_ 
| MENOR_ 
| MAYORIGU_ 
| MENORIGU_ 
;
operadorAditivo: OPSUMA_ 
| OPRESTA_ 
;
operadorMultiplicativo: OPMULT_ 
| OPDIV_ 
| OPRESTO_ 
;
operadorUnario: OPSUMA_ 
| OPRESTA_ 
| OPNEG_ 
;
operadorIncremento: INCREMENTO_
| DECREMENTO_ 
;

%%

