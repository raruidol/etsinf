%{
#include <stdio.h>
extern int yylineno;
extern FILE *yyin;
int numErrores ;
%}
%token ID_ CTE_ OPSUMA_ OPMULT_ TRUE_ FALSE_ INCREMENTO_ DECREMENTO_ OPRESTA_ OPDIV_ OPRESTO_ INT_ BOOL_ READ_ ELIF_ ELSE_ IF_ WHILE_ DO_ ASIG_ ASIGSUMA_ ASIGRESTA_ ASIGDIVISION_ ASIGPRODUCTO_ LOGICOAND_ LOGICOOR_ IGUALDAD_ DISTINTO_ MAYOR_ MENOR_ MAYORIGU_ MENORIGU_ OPNEG_ PCOMA_ IBLOCK_ FBLOCK_ PRINT_ ACORCH_ CCORCH_ APAR_ CPAR_


%%
programa: IBLOCK_ secuenciaSentencias FBLOCK_
;
secuenciaSentencias: sentencia
| secuenciaSentencias sentencia
;
sentencia: declaracion
| instruccion
;
declaracion: tipoSimple ID_ PCOMA_
|tipoSimple ID_ ACORCH_ CTE_ CCORCH_ PCOMA_
;
tipoSimple: INT_
| BOOL_
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
instruccionEntradaSalida: READ_ APAR_ ID_ CPAR_ PCOMA_
| PRINT_ APAR_ expresion CPAR_ PCOMA_
;
instruccionSeleccion: IF_ APAR_ expresion CPAR_ instruccion restoIf
;
restoIf: ELIF_ APAR_ expresion CPAR_ instruccion restoIf
| ELSE_ instruccion
;
instruccionIteracion: WHILE_ APAR_ expresion CPAR_ instruccion
| DO_ instruccion WHILE_ APAR_ expresion CPAR_
;
expresion: expresionLogica
| ID_ operadorAsignacion expresion
| ID_ ACORCH_ expresion CCORCH_ operadorAsignacion expresion
;
expresionLogica: expresionIgualdad
| expresionLogica operadorLogico expresionIgualdad
;
expresionIgualdad: expresionRelacional
| expresionIgualdad operadorIgualdad expresionRelacional
;
expresionRelacional: expresionAditiva
| expresionRelacional operadorRelacional expresionAditiva
;
expresionAditiva: expresionMultiplicativa
| expresionAditiva operadorAditivo expresionMultiplicativa
;
expresionMultiplicativa: expresionUnaria
| expresionMultiplicativa operadorMultiplicativo expresionUnaria
;
expresionUnaria: expresionSufija
| operadorUnario expresionUnaria
| operadorIncremento ID_
;
expresionSufija: APAR_ expresion CPAR_
| ID_ operadorIncremento
| ID_ ACORCH_ expresion CCORCH_
| ID_
| CTE_
| TRUE_
| FALSE_
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
