#define MAX 0

int pidCounter=0;
/*messages*/
mtype={	msg0,
	msg1,
	ack,
	};
/*TODO: think about the last comma*/

/*state names*/	
mtype={
	ChannelA_State0,
	ChannelA_State1,
	ChannelA_State2,
	ChannelA_Initial,
	ChannelB_State0,
	ChannelB_State1,
	ChannelB_Initial,
	Receiver_State0,
	Receiver_State1,
	Receiver_State2,
	Receiver_State3,
	Receiver_State4,
	Receiver_State5,
	Receiver_Initial,
	Sender_State1,
	Sender_State2,
	Sender_State3,
	Sender_State4,
	Sender_State5,
	Sender_State6,
	Sender_Initial,
	UserA_State1,
	UserA_State2,
	UserA_Initial,
	UserB_State1,
	UserB_State2,
	UserB_Initial,
	};
/*TODO: think about the last comma*/


chan ChannelA_Receiver=[MAX] of {mtype};
chan ChannelB_Sender=[MAX] of {mtype};
chan Receiver_ChannelB=[MAX] of {mtype};
chan Receiver_UserB=[MAX] of {mtype};
chan Sender_ChannelA=[MAX] of {mtype};
chan UserA_Sender=[MAX] of {mtype};
	
proctype ChannelA(int procId){

mtype EA_Region1_Top=ChannelA_Initial;
mtype signal;

evalunconditionals:
if					
::(EA_Region1_Top==ChannelA_Initial) ->
	EA_Region1_Top=ChannelA_State0;
	goto evalunconditionals;
::else->skip;
fi;

if	
::(EA_Region1_Top==ChannelA_State1)->
	EA_Region1_Top=ChannelA_State0;
	goto evalunconditionals;					
::(EA_Region1_Top==ChannelA_State1)->
	ChannelA_Receiver!msg0;
	EA_Region1_Top=ChannelA_State0;	
	goto evalunconditionals;					
::(EA_Region1_Top==ChannelA_State2)->
	ChannelA_Receiver!msg1;
	EA_Region1_Top=ChannelA_State0;	
	goto evalunconditionals;					
::(EA_Region1_Top==ChannelA_State2)->
	EA_Region1_Top=ChannelA_State0;
	goto evalunconditionals;					
::else -> skip;	
fi;	

evalsignals:

if
:: Sender_ChannelA?signal;								
fi;

if
::(EA_Region1_Top==ChannelA_State0  && signal==msg1) ->
	EA_Region1_Top=ChannelA_State2;			
	goto evalunconditionals;
::(EA_Region1_Top==ChannelA_State0  && signal==msg0) ->
	EA_Region1_Top=ChannelA_State1;			
	goto evalunconditionals;
::else->skip;
fi;

goto evalsignals;			
}		
	
proctype ChannelB(int procId){


mtype EA_Region2_Top=ChannelB_Initial;

mtype signal;



evalunconditionals:
if					
::(EA_Region2_Top==ChannelB_Initial) ->
EA_Region2_Top=ChannelB_State0;
goto evalunconditionals;
::else->skip;
fi;

if	
::(EA_Region2_Top==ChannelB_State1)->
	EA_Region2_Top=ChannelB_State0;	
	goto evalunconditionals;				
::(EA_Region2_Top==ChannelB_State1)->
	ChannelB_Sender!ack;
	EA_Region2_Top=ChannelB_State0;
	goto evalunconditionals;				
::else -> skip;	
fi;	
evalsignals:

if
:: Receiver_ChannelB?signal;								
fi;

if
::(EA_Region2_Top==ChannelB_State0  && signal==ack) ->
	EA_Region2_Top=ChannelB_State1;				
	goto evalunconditionals;	
::else->skip;
fi;

goto evalsignals;			
}		

proctype Receiver(int procId){

mtype EA_Region3_Top=Receiver_Initial;
mtype signal;

evalunconditionals:
if					
::(EA_Region3_Top==Receiver_Initial) ->
	EA_Region3_Top=Receiver_State0;
	goto evalunconditionals;
::else->skip;
fi;

if	
::(EA_Region3_Top==Receiver_State1)->
	Receiver_UserB!msg0;
	EA_Region3_Top=Receiver_State2;
	goto evalunconditionals;					
::(EA_Region3_Top==Receiver_State2)->
	Receiver_ChannelB!ack;
	EA_Region3_Top=Receiver_State3;	
	goto evalunconditionals;					
::(EA_Region3_Top==Receiver_State4)->
	Receiver_UserB!msg1;
	EA_Region3_Top=Receiver_State5;	
	goto evalunconditionals;					
::(EA_Region3_Top==Receiver_State5)->
	Receiver_ChannelB!ack;
	EA_Region3_Top=Receiver_State0;
	goto evalunconditionals;					
::else -> skip;	
fi;	

evalsignals:

if
:: ChannelA_Receiver?signal;								
fi;

if
::(EA_Region3_Top==Receiver_State0  && signal==msg1) ->
	EA_Region3_Top=Receiver_State5;			
	goto evalunconditionals;
::(EA_Region3_Top==Receiver_State0  && signal==msg0) ->
	EA_Region3_Top=Receiver_State1;			
	goto evalunconditionals;
::(EA_Region3_Top==Receiver_State3  && signal==msg0) ->
	EA_Region3_Top=Receiver_State2;			
	goto evalunconditionals;
::(EA_Region3_Top==Receiver_State3  && signal==msg1) ->
	EA_Region3_Top=Receiver_State4;			
	goto evalunconditionals;
::else->skip;
fi;

goto evalsignals;			
}		
	
proctype Sender(int procId){

mtype EA_Region4_Top=Sender_Initial;
mtype signal;

evalunconditionals:
if					
::(EA_Region4_Top==Sender_Initial) ->
	EA_Region4_Top=Sender_State1;
	goto evalunconditionals;
::else->skip;
fi;

if	
::(EA_Region4_Top==Sender_State2)->
	Sender_ChannelA!msg0;
	EA_Region4_Top=Sender_State3;	
	goto evalunconditionals;				
::(EA_Region4_Top==Sender_State3)->
	EA_Region4_Top=Sender_State2;		
	goto evalunconditionals;					
::(EA_Region4_Top==Sender_State5)->
	Sender_ChannelA!msg1;
	EA_Region4_Top=Sender_State6;		
	goto evalunconditionals;					
::(EA_Region4_Top==Sender_State6)->
	EA_Region4_Top=Sender_State5;
	goto evalunconditionals;						
::else -> skip;	
fi;	

evalsignals:

if
:: ChannelB_Sender?signal;	
:: UserA_Sender?signal;								
fi;

if
::(EA_Region4_Top==Sender_State1  && signal==msg0) ->
	EA_Region4_Top=Sender_State2;			
	goto evalunconditionals;
::(EA_Region4_Top==Sender_State3  && signal==ack) ->
	EA_Region4_Top=Sender_State4;			
	goto evalunconditionals;
::(EA_Region4_Top==Sender_State4  && signal==msg1) ->
	EA_Region4_Top=Sender_State5;	
	goto evalunconditionals;
::(EA_Region4_Top==Sender_State6  && signal==ack) ->
	EA_Region4_Top=Sender_State1;			
	goto evalunconditionals;
::else->skip;
fi;

goto evalsignals;			
}		
	
proctype UserA(int procId){

mtype EA_Region5_Top=UserA_Initial;
mtype signal;

evalunconditionals:
if					
::(EA_Region5_Top==UserA_Initial) ->
	EA_Region5_Top=UserA_State1;
	goto evalunconditionals;
::else->skip;
fi;

if	
::(EA_Region5_Top==UserA_State1)->
	UserA_Sender!msg1;
	EA_Region5_Top=UserA_State2;		
	goto evalunconditionals;				
::(EA_Region5_Top==UserA_State2)->
	UserA_Sender!msg0;
	EA_Region5_Top=UserA_State1;	
	goto evalunconditionals;				
::else -> skip;	
fi;		
}		
	
proctype UserB(int procId){

mtype EA_Region6_Top=UserB_Initial;
mtype signal;

evalunconditionals:
if					
::(EA_Region6_Top==UserB_Initial) ->
	EA_Region6_Top=UserB_State1;
	goto evalunconditionals;
::else->skip;
fi;

if	
::else -> skip;	
fi;	

evalsignals:

if
:: Receiver_UserB?signal;								
fi;

if
::(EA_Region6_Top==UserB_State1  && signal==msg1) ->
	EA_Region6_Top=UserB_State2;			
	goto evalunconditionals;
::(EA_Region6_Top==UserB_State2  && signal==msg0) ->
	EA_Region6_Top=UserB_State1;			
	goto evalunconditionals;
::(EA_Region6_Top==UserB_Initial  && signal==msg0) ->
	EA_Region6_Top=UserB_State1;			
	goto evalunconditionals;	
::else->skip;
fi;

goto evalsignals;			
}		
				
		
		
init{
	atomic{	
		run ChannelA(pidCounter);
		pidCounter=pidCounter+1;
	
		run ChannelB(pidCounter);
		pidCounter=pidCounter+1;
	
		run Receiver(pidCounter);
		pidCounter=pidCounter+1;
	
		run Sender(pidCounter);
		pidCounter=pidCounter+1;
	
		run UserA(pidCounter);
		pidCounter=pidCounter+1;
	
		run UserB(pidCounter);
		pidCounter=pidCounter+1;	
	}
}
	