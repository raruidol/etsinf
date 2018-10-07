%{
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include "header.h"
#include "libtds.h"
#include "libgci.h"
extern int yylineno;
extern int dvar;
extern FILE *yyin;
int numErrores ;
%}

%union{
    EXPRES expr;
    int cent;
    char *cadena;
    int tipo;
}

%token TRUE_ FALSE_ INCREMENTO_ DECREMENTO_ INT_ BOOL_ READ_ ASIG_ ASIGSUMA_ ASIGRESTA_ ASIGDIVISION_ ASIGPRODUCTO_ LOGICOAND_ LOGICOOR_ IGUALDAD_ DISTINTO_ MAYOR_ MENOR_ MAYORIGU_ MENORIGU_ OPNEG_ PCOMA_ IBLOCK_ FBLOCK_ PRINT_ ACORCH_ CCORCH_ APAR_ CPAR_ IF_ ELSE_ ELIF_ WHILE_ DO_ LOOP_ UNTIL_ STEP_

%type<expr> tipoSimple expresion expresionLogica expresionIgualdad expresionRelacional expresionAditiva expresionMultiplicativa expresionUnaria expresionSufija instruccionIteracion instruccionLoop
%token<cent> OPSUMA_ OPMULT_ OPDIV_ OPRESTA_ OPRESTO_ CTE_
%token<cadena> ID_
%type <tipo> operadorAsignacion operadorLogico operadorIgualdad operadorRelacional
%type <tipo> operadorAditivo operadorMultiplicativo operadorUnario operadorIncremento

%%
programa: IBLOCK_ secuenciaSentencias FBLOCK_ { emite(FIN,crArgNul(),crArgNul(),crArgNul()); }
;
secuenciaSentencias: sentencia
| secuenciaSentencias sentencia
;
sentencia: declaracion
| instruccion
;
declaracion: tipoSimple ID_ PCOMA_ { if (!insertarTDS($2,$1.tipo,dvar,-1)){yyerror("Elemento ya declarado");}
                                    else { dvar += TALLA_TIPO_SIMPLE; }}
|tipoSimple ID_ ACORCH_ CTE_ CCORCH_ PCOMA_ { int numel = $4; int ref;
                        if ($4 <=0){yyerror("Talla inapropiada del array en la declaracion"); numel=0;}
                        ref = insertaTDArray($1.tipo, numel);
                        if(!insertarTDS($2,T_ARRAY,dvar,ref)){yyerror("Elemento ya declarado");}
                        else { dvar += numel*TALLA_TIPO_SIMPLE;}}
;
tipoSimple: INT_ {$$.tipo = T_ENTERO;}
| BOOL_ {$$.tipo = T_LOGICO;}
;
instruccion: IBLOCK_ listaInstrucciones FBLOCK_
| instruccionEntradaSalida
| instruccionExpresion
| instruccionSeleccion
| instruccionIteracion
| instruccionLoop
;
listaInstrucciones: listaInstrucciones instruccion
|
;
instruccionExpresion: expresion PCOMA_
| PCOMA_
;
instruccionEntradaSalida: READ_ APAR_ ID_ CPAR_ PCOMA_ {
                            SIMB sim = obtenerTDS($3);
                            if(sim.tipo == T_ERROR){yyerror("Objeto no declarado");}
                            else if (sim.tipo == T_LOGICO){yyerror("Tipo incorrecto (I/O)");}
                            else {emite(EREAD, crArgNul(),crArgNul(),crArgPos(sim.desp));}
                            }
| PRINT_ APAR_ expresion CPAR_ PCOMA_ {if($3.tipo != T_ENTERO && $3.tipo != T_ERROR){yyerror("Tipo incorrecto print");}
                                        else {
                                              emite(EWRITE,crArgNul(),crArgNul(),crArgPos($3.pos));}}
;
instruccionSeleccion: IF_ APAR_ expresion CPAR_ {if($3.tipo != T_ERROR && $3.tipo != T_LOGICO){yyerror("Se esperaba expresion tipo logica en el if.");
                                                    }
                                                 else {
                                                        $<cent>$ = creaLans(si);
                                                         emite(EIGUAL,crArgPos($3.pos),crArgEnt(0),crArgNul());}}
                      instruccion {
                                                        $<cent>$ = creaLans(si);
                                                        emite(GOTOS,crArgNul(),crArgNul(),crArgNul());
                                                        completaLans($<cent>5,crArgEtq(si));
                                    }

                      restoIf { completaLans($<cent>7,crArgEtq(si)); }



;
restoIf: ELIF_ APAR_ expresion CPAR_ {if($3.tipo != T_ERROR && $3.tipo != T_LOGICO){yyerror("Se esperaba expresion tipo logica en el else_if.");}
                                      else {
                                                          $<cent>$ = creaLans(si);
                                                        emite(EIGUAL,crArgPos($3.pos),crArgEnt(0),crArgNul());}}
         instruccion {
                                                         $<cent>$ = creaLans(si);
                                                        emite(GOTOS,crArgNul(),crArgNul(),crArgNul());
                                                        completaLans($<cent>5,crArgEtq(si)); }
         restoIf  { completaLans($<cent>7,crArgEtq(si)); }
| ELSE_ instruccion
;

instruccionIteracion: WHILE_  { $<cent>$ = si;}

        APAR_ expresion CPAR_ {if($4.tipo != T_LOGICO && $4.tipo != T_ERROR) {yyerror("Se esperaba expresion tipo logica en el while.");}
                                else { { $<cent>$ = creaLans(si);
                                        emite(EIGUAL,crArgPos($4.pos),crArgEnt(0),crArgNul());}}}
        instruccion { emite(GOTOS,crArgNul(),crArgNul(),crArgEtq($<cent>2));
                      completaLans($<cent>6,crArgEtq(si)); }

| DO_ { $<cent>$ = si;}
  instruccion WHILE_ APAR_ expresion CPAR_ {if($6.tipo != T_LOGICO && $6.tipo != T_ERROR){yyerror("Se esperaba expresion tipo logica en el do_while.");}
                                                else {
                                                        emite(EDIST,crArgPos($6.pos),crArgEnt(0),crArgEtq($<cent>2));}}
;
instruccionLoop: LOOP_  { $<cent>$ = si;}
                 instruccion UNTIL_ expresion STEP_  {if($5.tipo != T_LOGICO && $5.tipo != T_ERROR) {yyerror("Se esperaba expresion tipo logica en el until.");}
                                                      else{ $<cent>$ = creaLans(si);
                                                            emite(EIGUAL, crArgPos($5.pos), crArgEnt(1), crArgNul());}
                                                      }
                 expresion { if($8.tipo != T_ENTERO && $8.tipo != T_ERROR) {yyerror("Se esperaba expresion tipo entera en el step.");}
                             emite(GOTOS,crArgNul(),crArgNul(),crArgEtq($<cent>2));
                             completaLans($<cent>7,crArgEtq(si)); }
;

expresion: expresionLogica {$$.pos = $1.pos; $$.tipo = $1.tipo;}
| ID_ operadorAsignacion expresion
    { SIMB sim = obtenerTDS($1); $$.tipo = T_ERROR;
    if(sim.tipo == T_ERROR) {
        yyerror("Objeto no declarado");
    } else {
        if($3.tipo != T_ERROR) {
            if( sim.tipo != $3.tipo) {
                yyerror("Error de tipos en la instruccion de asignacion (expresion)");
            } else {
                $$.tipo = $3.tipo;
                $$.pos = creaVarTemp();
                if($2 == EASIG) {
                    emite(EASIG, crArgPos($3.pos), crArgNul(), crArgPos($$.pos));
                } else {
                    emite($2, crArgPos(sim.desp), crArgPos($3.pos), crArgPos($$.pos));
                }
                emite(EASIG, crArgPos($$.pos), crArgNul(), crArgPos(sim.desp));
            }
        }
    }}

| ID_ ACORCH_ expresion CCORCH_ operadorAsignacion expresion
                    {
                    SIMB sim = obtenerTDS($1); $$.tipo = T_ERROR;
                    if(sim.tipo == T_ERROR){
                        yyerror("Objeto no declarado");
                    }else{
                        if($6.tipo != T_ERROR){
                            if(sim.tipo != T_ARRAY){
                                yyerror("El identificador tiene que ser de tipo Array");
                            }else{
                                DIM dim = obtenerInfoArray(sim.ref);
                                if(!((dim.telem == $6.tipo)&&($6.tipo == T_ENTERO || $6.tipo == T_LOGICO))){
                                    yyerror("Error de tipos en la instruccion de asignacion (expresion)");
                                }else{
                                    if($3.tipo !=T_ENTERO){
                                        yyerror("El indice del array tiene que ser un entero");
                                    }else{
                    $$.tipo = $6.tipo;
                    $$.pos = creaVarTemp();
                    if($5 == EASIG){
                        emite(EVA,crArgPos(sim.desp),crArgPos($3.pos),crArgPos($6.pos));
                    }
                    else {
                        int tempv = creaVarTemp();
                        emite(EAV,crArgPos(sim.desp),crArgPos($3.pos),crArgPos(tempv));
                        emite($5,crArgPos(tempv),crArgPos($6.pos),crArgPos(tempv));
                        emite(EVA,crArgPos(sim.desp),crArgPos($3.pos),crArgPos(tempv));
                    }
                    emite(EAV,crArgPos(sim.desp),crArgPos($3.pos),crArgPos($$.pos));
                                        }
                                    }
                                }
                            }
                        }
                    }
;

expresionLogica
    : expresionIgualdad {$$.pos = $1.pos; $$.tipo = $1.tipo;}
    | expresionLogica operadorLogico expresionIgualdad
    {
        if ($1.tipo == T_LOGICO && $3.tipo == T_LOGICO) {
            $$.tipo = T_LOGICO;
        } else {
            $$.tipo = T_ERROR;
            yyerror("los tipos no coinciden (logica)");
        }
        $$.pos = creaVarTemp();
        int temp = creaVarTemp();
        emite(EASIG, crArgEnt(1), crArgNul(), crArgPos($$.pos));
        emite($2,crArgPos($1.pos),crArgPos($3.pos),crArgPos(temp));
        emite(EMAYEQ, crArgPos(temp), crArgEnt(1), crArgEtq(si+2));
        emite(EASIG, crArgEnt(0), crArgNul(), crArgPos($$.pos));
    }
;
expresionIgualdad: expresionRelacional {$$.pos = $1.pos; $$.tipo = $1.tipo;}
| expresionIgualdad operadorIgualdad expresionRelacional
                                                        {
                                                        if ($1.tipo ==  $3.tipo == T_ENTERO) {$$.tipo = T_LOGICO;}
                                                        else {$$.tipo = T_ERROR; yyerror("los tipos no coinciden (igualdad)");}
                                                            $$.pos = creaVarTemp();
                                                            emite(EASIG, crArgEnt(1), crArgNul(), crArgPos($$.pos));
                                                            emite($2,crArgPos($1.pos),crArgPos($3.pos),crArgEtq(si+2));
                                                            emite(EASIG, crArgEnt(0), crArgNul(), crArgPos($$.pos));
                                                        }
;
expresionRelacional: expresionAditiva {$$.pos = $1.pos; $$.tipo = $1.tipo;}
| expresionRelacional operadorRelacional expresionAditiva
                                            {
                                            if ($1.tipo == T_ENTERO && $3.tipo == T_ENTERO) {$$.tipo = T_LOGICO;}
                                            else {$$.tipo = T_ERROR; yyerror("los tipos no coinciden (relacional)");}
                                            $$.pos = creaVarTemp();
                                            emite(EASIG, crArgEnt(1), crArgNul(), crArgPos($$.pos));
                                            emite($2,crArgPos($1.pos),crArgPos($3.pos),crArgEtq(si+2));
                                            emite(EASIG, crArgEnt(0), crArgNul(), crArgPos($$.pos));
                                            }
;
expresionAditiva: expresionMultiplicativa {$$.pos = $1.pos; $$.tipo = $1.tipo;}
| expresionAditiva operadorAditivo expresionMultiplicativa
                                            {
                                            if ($1.tipo != T_ENTERO && $1.tipo != T_ERROR || $3.tipo != T_ENTERO && $1.tipo != T_ERROR) {
                                                $$.tipo = T_ERROR; yyerror("los tipos no coinciden (aditiva)");
                                            }
                                            else {$$.tipo = T_ENTERO;
                                                $$.pos = $1.pos;
                                                emite($2,crArgPos($1.pos),crArgPos($3.pos),crArgPos($$.pos));}
                                            }


;
expresionMultiplicativa: expresionUnaria {$$.pos = $1.pos; $$.tipo = $1.tipo;}
| expresionMultiplicativa operadorMultiplicativo expresionUnaria
                                    {
                                    if ($1.tipo != T_ENTERO && $1.tipo != T_ERROR || $3.tipo != T_ENTERO && $1.tipo != T_ERROR) {
                                        $$.tipo = T_ERROR; yyerror("los tipos no coinciden (multiplicativa)");
                                    }
                                    else {$$.tipo = T_ENTERO;
                                        $$.pos = $1.pos;
                                        emite($2,crArgPos($1.pos),crArgPos($3.pos),crArgPos($$.pos));}

                                    }
;
expresionUnaria: expresionSufija {$$.pos = $1.pos; $$.tipo = $1.tipo;}
| operadorUnario expresionUnaria     {
                                    if($2.tipo != T_LOGICO && $2.tipo != T_ERROR){yyerror("Tipo inapropiado. (unaria)"); $$.tipo = T_ERROR;}
                                    else{$$ = $2;
                                        $$.pos = creaVarTemp();
                                        emite(EASIG,crArgEnt(0),crArgNul(),crArgPos($$.pos));
                                        emite(EDIST,crArgPos($2.pos),crArgEnt(0),crArgEtq(si+2));
                                        emite(EASIG,crArgEnt(1),crArgNul(),crArgPos($$.pos));
                                        }
                                    }
| operadorIncremento ID_     {
                            SIMB sim = obtenerTDS($2); $$.tipo = T_ERROR;
                            if(sim.tipo == T_ERROR) {yyerror("Objeto no declarado");}
                            else {
                                if(sim.tipo == T_LOGICO) {yyerror("Tipo inapropiado. (unaria)");$$.tipo = T_ERROR;}
                                else{$$.tipo = sim.tipo;
                                      $$.pos = creaVarTemp();
                                      emite($1,crArgPos(sim.desp),crArgEnt(1),crArgPos(sim.desp));
                                      emite(EASIG, crArgPos(sim.desp) ,crArgNul() ,crArgPos($$.pos));
                                     }
                                }
                            }

;
expresionSufija: APAR_ expresion CPAR_ {$$.pos = $2.pos; $$.tipo = $2.tipo;}
| ID_ operadorIncremento     {
                            SIMB sim = obtenerTDS($1); $$.tipo = T_ERROR;
                            if(sim.tipo == T_ERROR) {yyerror("Objeto no declarado");}
                            else {    if(sim.tipo == T_LOGICO) {yyerror("Tipo inapropiado. (sufija)");$$.tipo = T_ERROR;}
                            else {$$.tipo = sim.tipo;}}
                                $$.pos= creaVarTemp();
                                emite(EASIG, crArgPos(sim.desp) ,crArgNul() ,crArgPos($$.pos) );
                    emite($2, crArgPos(sim.desp) ,crArgEnt(1) ,crArgPos(sim.desp) );
                            }
| ID_ ACORCH_ expresion CCORCH_
                    {
                        $$.tipo = T_ERROR;
                        SIMB sim = obtenerTDS($1);
                        if(sim.tipo == T_ERROR){
                            yyerror("Objeto no declarado");
                        }else{
                            if(sim.tipo != T_ARRAY){
                                yyerror("Se esperaba un identificador de tipo Array");$$.tipo = T_ERROR;
                            }else{
                                if ($3.tipo != T_ENTERO ) {yyerror("Error de indexacion del array (sufija)");$$.tipo = T_ERROR;}
                                else {
                                    DIM dim = obtenerInfoArray(sim.ref);
                                    //if($3.pos < 0 || $3.pos >= dim.nelem){
                                    //    yyerror("El indice del array esta fuera del rango");$$.tipo = T_ERROR;
                                    //}else{
                                        $$.tipo = dim.telem;
                                        $$.pos = creaVarTemp();
                                        emite(EAV, crArgPos(sim.desp), crArgPos($3.pos), crArgPos($$.pos));
                                    //    }
                                    }
                                }
                            }
                    }
| ID_     {
        SIMB sim = obtenerTDS($1); $$.tipo = T_ERROR;
        if(sim.tipo == T_ERROR) {yyerror("Objeto no declarado");}
        else{
        $$.tipo = sim.tipo;
        $$.pos = creaVarTemp();
        emite(EASIG, crArgPos(sim.desp), crArgNul(), crArgPos($$.pos));
        }
    }

| CTE_    {
        $$.tipo = T_ENTERO;
        $$.pos = creaVarTemp();
        emite(EASIG, crArgEnt($1), crArgNul(), crArgPos($$.pos));
        }

| TRUE_ {
        $$.tipo = T_LOGICO;
        $$.pos = creaVarTemp();
        emite(EASIG, crArgEnt(1), crArgNul(), crArgPos($$.pos));
        }

| FALSE_ {
        $$.tipo = T_LOGICO;
        $$.pos = creaVarTemp();
        emite(EASIG, crArgEnt(0), crArgNul(), crArgPos($$.pos));
        }
;
operadorAsignacion: ASIG_ {$$ = EASIG;}
| ASIGSUMA_ {$$ = ESUM;}
| ASIGRESTA_ {$$ = EDIF;}
| ASIGPRODUCTO_ {$$ = EMULT;}
| ASIGDIVISION_ {$$ = EDIVI;}
;
operadorLogico: LOGICOAND_ {$$ = EMULT;}
| LOGICOOR_ {$$=ESUM;}
;
operadorIgualdad: IGUALDAD_ {$$ = EIGUAL;}
| DISTINTO_ {$$ = EDIST;}
;
operadorRelacional: MAYOR_ {$$ = EMAY;}
| MENOR_ {$$ = EMEN;}
| MAYORIGU_ {$$ = EMAYEQ;}
| MENORIGU_ {$$ = EMENEQ;}
;
operadorAditivo: OPSUMA_ {$$ = ESUM;}
| OPRESTA_ {$$ = EDIF;}
;
operadorMultiplicativo: OPMULT_ {$$ = EMULT;}
| OPDIV_ {$$ = EDIVI;}
| OPRESTO_ {$$ = RESTO;}
;
operadorUnario: OPSUMA_ {$$ = ESUM;}
| OPRESTA_ {$$ = EDIF;}
| OPNEG_   {$$ = ESIG;}
;
operadorIncremento: INCREMENTO_ {$$=ESUM;}
| DECREMENTO_ {$$=EDIF;}
;

%%

