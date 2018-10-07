debug(3).

// Name of the manager
manager("Manager").

// Team of troop.
team("ALLIED").
// Type of troop.
type("CLASS_MEDIC").




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
                //El comandante no dispara
                //-+aimed("true");
                
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
            ///?debug(Mode); if (Mode<=1) { .println("HAY ", Length, " OBJETOS A MI ALREDEDOR:\n", FOVObjects); }
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
/**  You can change initial priorities if you want to change the behaviour of each agent  **/+!setup_priorities
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
		?bandera(OX,OY,OZ);
		?objectivePackTaken(Flag);
		?tasks(TASKS);
		.my_team("ALLIED", T1);
		.my_team("cobertura", Cov);
		.my_team("comandante", C);
		.my_name(N);
		?formados(F);
		.length(TASKS,LT);
		if(F==8){
			!add_task(task(5000,"TASK_GOTO_POSITION",self,pos(X,Y,Z),""));
			!al_ataque(OX,OY,OZ, Cov);
			.println("Tomad la bandera!");
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

	
//Solo el comandante
	
+!a_formar(Batallon)
	<-
	.length(Batallon, Len);
	+loop(0);
	?my_position(X,Y,Z);
	if(Len>0){
		while( loop(I) & (I<Len) ){
			.println("Orden enviada", I);
			?posicionesform(K);
			.nth(I, Batallon, Soldado);
			.concat("en_posicion(",X+K,",",Y,",",Z+5,")",Posi);
			.send_msg_with_conversation_id(Soldado,tell,Posi,"INT");
			-+posicionesform(K+4);
			-+loop(I+1);
			}
		.println("fin del envio de ordenes");
		-loop(_);
		-posicionesform(_);
	}
.
	

+!al_ataque(X,Y,Z,Batallon)
	<-
	!add_task(task(5000,"TASK_GOTO_POSITION",self,pos(X,Y,Z),""));
	.length(Batallon, Len);
	+loop(0);
	if(Len>0){
		while(loop(I) & (I<Len)){
			.println("Orden enviada", I);
			?posicionesatt(K);
			.nth(I, Batallon, Soldado);
			.concat("en_posicion_bandera(",X+K,",",Y,",",Z,")",Posicion);
			.send_msg_with_conversation_id(Soldado,tell,Posicion,"INT");
			-+posicionesatt(K+5);
			-+loop(I+1);
			}
		.println("fin del envio de ordenes");
		-loop(_);
		-posicionesatt(_);
	}
.


+formado(X)[source(A)] 
    <-
    ?formados(F);
	.println(F+1);
    -+formados(F+1);
	-formado(_);
    .
+victoria(X1,Y1,Z1)[source(A)] 
	<-
	-+tasks([]);
    -victoria(_);
	.println("Vamos a la base!");
	!add_task(task(5000,"TASK_GOTO_POSITION",A,pos(X1,Y1,Z1),""));
	-+state(standing);
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
       
       ?my_ammo_threshold(At);
       ?my_ammo(Ar);
       
       if (Ar <= At) { 
          ?my_position(X, Y, Z);
          
         .my_team("fieldops_ALLIED", E1);
         //.println("Mi equipo intendencia: ", E1 );
         .concat("cfa(",X, ", ", Y, ", ", Z, ", ", Ar, ")", Content1);
         .send_msg_with_conversation_id(E1, tell, Content1, "CFA");
       
       
       }
       
       ?my_health_threshold(Ht);
       ?my_health(Hr);
       
       if (Hr <= Ht) {  
          ?my_position(X, Y, Z);
          
         .my_team("medic_ALLIED", E2);
         //.println("Mi equipo medico: ", E2 );
         .concat("cfm(",X, ", ", Y, ", ", Z, ", ", Hr, ")", Content2);
         .send_msg_with_conversation_id(E2, tell, Content2, "CFM");

       }
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
   		.register("JGOMAS","comandante");
		.println("Ahora soy el comandante");
		.wait(5000);
        ?my_position(X,Y,Z);
		+base_positon(X,Y,Z);
		+formados(1);
        +check(false);
		+posicionesform(-8);
		+posicionesatt(-15);
		-+objectivePackTaken(off);
		?objective(OX,OY,OZ);
		+bandera(OX,OY,OZ);
		.my_team("cobertura", Cov);
		.println(Cov);
		!a_formar(Cov);
		.println("A formar!");
.  

