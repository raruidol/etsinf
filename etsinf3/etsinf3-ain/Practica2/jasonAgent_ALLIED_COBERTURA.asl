debug(3).

// Name of the manager
manager("Manager").

// Team of troop.
team("ALLIED").
// Type of troop.
type("CLASS_SOLDIER").





{ include("jgomas.asl") }




// Plans


/*******************************
*
* Actions definitions
*
*******************************/

/////////////////////////////////
//  GET AGENT TO AIM 
/////////////////////////////////  
/**
* Calculates if there is an enemy at sight.
* 
* This plan scans the list <tt> m_FOVObjects</tt> (objects in the Field
* Of View of the agent) looking for an enemy. If an enemy agent is found, a
* value of aimed("true") is returned. Note that there is no criterion (proximity, etc.) for the
* enemy found. Otherwise, the return value is aimed("false")
* 
* <em> It's very useful to overload this plan. </em>
* 
*/  
+!get_agent_to_aim
<-  ?debug(Mode); if (Mode<=2) { .println("Looking for agents to aim."); }
?fovObjects(FOVObjects);
.length(FOVObjects, Length);

?debug(Mode); if (Mode<=1) { .println("El numero de objetos es:", Length); }

if (Length > 0) {
    +bucle(0);
    +comprobarAliado(0);
    -+posible("false");
    -+aimed("false");
    
    while (aimed("false") & bucle(X) & (X < Length)) {
        
        //.println("En el bucle, y X vale:", X);
        
        .nth(X, FOVObjects, Object);
        // Object structure
        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        .nth(2, Object, Type);
        
        ?debug(Mode); if (Mode<=2) { .println("Objeto Analizado: ", Object); }
        
        if (Type > 1000) {
            ?debug(Mode); if (Mode<=2) { .println("I found some object."); }
        } else {
            // Object may be an enemy
            .nth(1, Object, Team);
            ?my_formattedTeam(MyTeam);
            
            if (Team == 200) {  // Only if I'm ALLIED
				
                ?debug(Mode); if (Mode<=2) { .println("Aiming an enemy. . .", MyTeam, " ", .number(MyTeam) , " ", Team, " ", .number(Team)); }
                +aimed_agent(Object);

                //Evitar el fuego Amigo
                -+aimed("true");
				+comprobarAliado(0);
				
				while(aimed("true") & comprobarAliado(X2) & (X2 < Length)){
 					.nth(X2, FOVObjects, Object2);
 					.nth(2, Object2, Type2);
 					.nth(1, Object2, Team2);
 					if (Type2<1000 & Team2==100){
 						?my_position(PX, PY, PZ);
 						.nth(6,Object,Enemigo);
 						.nth(6,Object2,Aliado);
 						!distancia(pos(PX,PY,PZ),Enemigo);
 						?distancia(DistEn);
 						!distancia(Aliado,Enemigo);
 						?distancia(DistAlEn);
 						!distancia(pos(PX,PY,PZ),Aliado);
 						?distancia(DistAl);
 						// Si la distancia del agente al enemigo es mayor que la suma de distancias entre el agente y un aliado y este y un enemigo, el aliado se encuentra en medio de la linea de tiro
 						if( DistEn+5>=DistAl+DistAlEn ){
 								-aimed_agent(Object);
 								-+aimed("false");
 								
 						}
 					}
 					-+comprobarAliado(X2+1);             
 				
 				}
 				-comprobarAliado(_);
                
            }
            
        }
        
        -+bucle(X+1);
        
    }
    
   
}

-bucle(_).

/////////////////////////////////
//  LOOK RESPONSE
/////////////////////////////////
+look_response(FOVObjects)[source(M)]
    <-  //-waiting_look_response;
        .length(FOVObjects, Length);
        if (Length > 0) {
            ?debug(Mode); if (Mode<=1) { .println("HAY ", Length, " OBJETOS A MI ALREDEDOR:\n", FOVObjects); }
        };    
        -look_response(_)[source(M)];
        -+fovObjects(FOVObjects);
        //.//;
        !look.
      
        
/////////////////////////////////
//  PERFORM ACTIONS
/////////////////////////////////
/**
* Action to do when agent has an enemy at sight.
* 
* This plan is called when agent has looked and has found an enemy,
* calculating (in agreement to the enemy position) the new direction where
* is aiming.
*
*  It's very useful to overload this plan.
* 
*/
+!perform_aim_action
    <-  // Aimed agents have the following format:
        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        ?aimed_agent(AimedAgent);
        ?debug(Mode); if (Mode<=1) { .println("AimedAgent ", AimedAgent); }
        .nth(1, AimedAgent, AimedAgentTeam);
        ?debug(Mode); if (Mode<=2) { .println("BAJO EL PUNTO DE MIRA TENGO A ALGUIEN DEL EQUIPO ", AimedAgentTeam);             }
        ?my_formattedTeam(MyTeam);


        if (AimedAgentTeam == 200) {
    
                .nth(6, AimedAgent, NewDestination);
                ?debug(Mode); if (Mode<=1) { .println("NUEVO DESTINO DEBERIA SER: ", NewDestination); }
          
            }
 .

/**
* Action to do when the agent is looking at.
*
* This plan is called just after Look method has ended.
* 
* <em> It's very useful to overload this plan. </em>
* 
*/
+!perform_look_action .
   /// <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_LOOK_ACTION GOES HERE.") }. 

/**
* Action to do if this agent cannot shoot.
* 
* This plan is called when the agent try to shoot, but has no ammo. The
* agent will spit enemies out. :-)
* 
* <em> It's very useful to overload this plan. </em>
* 
*/  
+!perform_no_ammo_action . 
   /// <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_NO_AMMO_ACTION GOES HERE.") }.
    
/**
     * Action to do when an agent is being shot.
     * 
     * This plan is called every time this agent receives a messager from
     * agent Manager informing it is being shot.
     * 
     * <em> It's very useful to overload this plan. </em>
     * 
     */
+!perform_injury_action .
    ///<- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_INJURY_ACTION GOES HERE.") }. 
        

/////////////////////////////////
//  SETUP PRIORITIES
/////////////////////////////////
/**  You can change initial priorities if you want to change the behaviour of each agent  **/
+!setup_priorities
    <-  +task_priority("TASK_NONE",0);
        +task_priority("TASK_GIVE_MEDICPAKS", 0);
        +task_priority("TASK_GIVE_AMMOPAKS", 0);
        +task_priority("TASK_GIVE_BACKUP", 0);
        +task_priority("TASK_GET_OBJECTIVE",0);
        +task_priority("TASK_ATTACK", 0);
        +task_priority("TASK_RUN_AWAY", 0);
        +task_priority("TASK_GOTO_POSITION", 7000);
        +task_priority("TASK_PATROLLING", 0);
        +task_priority("TASK_WALKING_PATH", 0).   



/////////////////////////////////
//  UPDATE TARGETS
/////////////////////////////////
/**
 * Action to do when an agent is thinking about what to do.
 *
 * This plan is called at the beginning of the state "standing"
 * The user can add or eliminate targets adding or removing tasks or changing priorities
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */

+!update_targets
	<-	?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR UPDATE_TARGETS GOES HERE.") }
    	?posicion(F);
		?tasks(TASKS);
		.length(TASKS,LT);
		?objectivePackTaken(Flag);
		//Al formar
		if(LT==0 & F==false){
			.my_team("comandante",C);
			.println("Ya estoy en posicion!");
			-+posicion(true);
			//Envio mensaje confirmando que estoy formado
			Formado = "formado(true)";
			.send_msg_with_conversation_id(C,tell,Formado,"INT");
			//Registro en creencia mi posicion de formacion
			?my_position(X,Y,Z);
			+mi_posicion(X,Y,Z);
		}
		if(LT==1 & Flag==on){
				.println("Vamos a por todas!");
				.nth(0,TASKS,Vuelta);
				-+Vuelta;
				?task(_,_,_,PosicionBase,_);
				.println(PosicionBase);
				-+PosicionBase;
				?pos(XB,YB,ZB);
				.my_team("comandante",Com);
				.my_team("cobertura",Cov);
				.concat(Cov,Com,Team);		
				// Decirles a todos que vayan a la posición de la bandera para luego seguirme //
				.concat("victoria(",XB,",",YB,",",ZB,")",AcabemosEsto);
				.send_msg_with_conversation_id(Team,tell,AcabemosEsto,"INT");
				
			}
		
.
	
+en_posicion(X,Y,Z)[source(A)] 
	<-	-en_posicion(_,_,_);
    	!add_task(task(5500,"TASK_GOTO_POSITION",A,pos(X,Y,Z),""));
		?tasks(TASKS);
		.println(TASKS);
		.println("A la orden!");
		-+state(standing);
	.
+en_posicion_bandera(X,Y,Z)[source(A)] 
	<-	-en_posicion_bandera(_,_,_);
    	!add_task(task(5500,"TASK_GOTO_POSITION",A,pos(X,Y,Z),""));
		?tasks(TASKS);
		.println(TASKS);
		.println("Banzai!");
		-+state(standing);
	.
+victoria(X1,Y1,Z1)[source(A)] 
	<-
	-+tasks([]);
    -victoria(_);
	.println("Vamos a la base!");
	!add_task(task(5000,"TASK_GOTO_POSITION",A,pos(X1,Y1,Z1),""));
	-+state(standing);
	.
	
+!distancia(pos(X1,Y1,Z1), pos(X2,Y2,Z2))
 	<-
	//Distancia euclidea entre dos puntos
 	D=math.sqrt((X1-X2)*(X1-X2)+(Y1-Y2)*(Y1-Y2)+(Z1-Z2)*(Z1-Z2));
 	-+distancia(D);
 .


	
/////////////////////////////////
//  CHECK MEDIC ACTION (ONLY MEDICS)
/////////////////////////////////
/**
 * Action to do when a medic agent is thinking about what to do if other agent needs help.
 *
 * By default always go to help
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
 +!checkMedicAction
     <-  -+medicAction(on).
      // go to help
      
      
/////////////////////////////////
//  CHECK FIELDOPS ACTION (ONLY FIELDOPS)
/////////////////////////////////
/**
 * Action to do when a fieldops agent is thinking about what to do if other agent needs help.
 *
 * By default always go to help
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
 +!checkAmmoAction
     <-  -+fieldopsAction(on).
      //  go to help



/////////////////////////////////
//  PERFORM_TRESHOLD_ACTION
/////////////////////////////////
/**
 * Action to do when an agent has a problem with its ammo or health.
 *
 * By default always calls for help
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
+!performThresholdAction
       <-
       
       ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_TRESHOLD_ACTION GOES HERE.") }

       .
       
/////////////////////////////////
//  ANSWER_ACTION_CFM_OR_CFA
/////////////////////////////////

     

    
+cfm_agree[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_agree GOES HERE.")};
      -cfm_agree.  

+cfa_agree[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfa_agree GOES HERE.")};
      -cfa_agree.  

+cfm_refuse[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_refuse GOES HERE.")};
      -cfm_refuse.  

+cfa_refuse[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfa_refuse GOES HERE.")};
      -cfa_refuse.  



/////////////////////////////////
//  Initialize variables
/////////////////////////////////

+!init
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR init GOES HERE.")}
   	-+tasks([]);
	.register("JGOMAS","cobertura");
	.println("Me encargare de la cobertura");
	.wait(6000);
    -+objectivePackTaken(off);
	?my_position(X,Y,Z);
	+base_positon(X,Y,Z);
    ?objective(OX,OY,OZ);
	+bandera(OX,OY,OZ);
	+posicion(false);
	
.  



