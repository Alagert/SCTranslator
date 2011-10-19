<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:uml="http://schema.omg.org/spec/UML/2.3" xmlns:xmi="http://schema.omg.org/spec/XMI/2.1">
  <!-- 
       #define MAX 16 means maximum buffer length for all channels.
       
       Messages are constructed from uml types called triggers. XMI defines it as uml:Trigger. 
       Messages consists of all events wchich can fire transtions in StateMachines.
       
       State names describes a set of all states of all statemachines. Also each state is copied and marked 'Busy'. 
       It means that this particular state is active.
  -->
  <xsl:output method="text" indent="yes" encoding="UTF-8"/>
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="uml:Package">
    #define MAX 16
    
    int pidCounter=0;
    /*messages*/
    mtype={
    <xsl:for-each select="//trigger">
      <xsl:value-of select="@name"/>,
    </xsl:for-each>	
    };
    /*TODO: think about the last comma*/
    
    /*state names*/	
    mtype={
    <xsl:for-each select="//subvertex[@xmi:type = 'uml:State']">
      <xsl:value-of select="@name"/>,<xsl:value-of select="@name"/>_Busy,
    </xsl:for-each>
    <!--todo create right final state-->
    <xsl:for-each select="//subvertex[@xmi:type = 'uml:FinalState']">
      Final
    </xsl:for-each>
    };
    /*TODO: think about the last comma*/
    
    chan <xsl:value-of select="packagedElement/@name"/>_chan = [MAX] of {mtype};
    
    proctype <xsl:value-of select="packagedElement/@name"/>(int procId){
    <xsl:for-each select="//region">
      mtype <xsl:value-of select="@name"/>_Top;
    </xsl:for-each>
    mtype signal;  
    
    evalunconditionals:
    <xsl:for-each select="//transition">
      <xsl:if test="not(trigger)">
	if
	<xsl:variable name="sourceState" select="@source"/>					
	::(<xsl:value-of select="../@name"/>_Top==<xsl:value-of select="//subvertex[@xmi:id=$sourceState]/@name"/>_Busy)->
	
	fi;
      </xsl:if>
    </xsl:for-each>
		
    evalsignals:
    if
    ::(nempty(<xsl:value-of select="packagedElement/@name"/>_chan)) -> <xsl:value-of select="packagedElement/@name"/>_chan?signal ->
    if<xsl:for-each select="packagedElement/packagedElement/region/subvertex">
    <xsl:variable name="transitionId" select="outgoing/@xmi:idref"/>
    <xsl:variable name="triggerId" select="../transition[@xmi:id=$transitionId]/trigger/@xmi:idref"/>
    <xsl:variable name="targetStateId" select="../transition[@xmi:id=$transitionId]/@target"/>
    <xsl:variable name="signalName" select="//packagedElement[@xmi:id=$triggerId]/@name"/>
    <xsl:if test="$signalName!=''">
      <xsl:choose>
	<xsl:when test="region">							
	  ::(<xsl:value-of select="../@name"/>_Top==<xsl:value-of select="@name"/> || <xsl:value-of select="../@name"/>_Top==<xsl:value-of select="@name"/>_Busy) ->
	  if<xsl:for-each select="region/subvertex">
	  <xsl:variable name="localTransitionId" select="outgoing/@xmi:idref"/>
	  <xsl:variable name="localTriggerId" select="../transition[@xmi:id=$localTransitionId]/trigger/@xmi:idref"/>
	  <xsl:variable name="localTargetStateId" select="../transition[@xmi:id=$localTransitionId]/@target"/>
	  <xsl:variable name="localSignalName" select="//packagedElement[@xmi:id=$localTriggerId]/@name"/>
	  ::(<xsl:value-of select="../@name"/>_Top==<xsl:value-of select="@name"/>  &amp;&amp; signal==<xsl:value-of select="$localSignalName"/>) ->
	  <xsl:value-of select="../@name"/>_Top=<xsl:value-of select="//subvertex[@xmi:id=$localTargetStateId]/@name"/>;	
	  </xsl:for-each>::else -> skip;				
	  fi;										
	  ::(<xsl:value-of select="../@name"/>_Top==<xsl:value-of select="@name"/>_Busy  &amp;&amp; signal==<xsl:value-of select="$signalName"/>) ->
	  <xsl:value-of select="../@name"/>_Top=<xsl:value-of select="//subvertex[@xmi:id=$targetStateId]/@name"/>;					
	</xsl:when>
	<xsl:otherwise>
	  ::(<xsl:value-of select="../@name"/>_Top==<xsl:value-of select="@name"/>  &amp;&amp; signal==<xsl:value-of select="$signalName"/>) ->
	  <xsl:value-of select="../@name"/>_Top=<xsl:value-of select="//subvertex[@xmi:id=$targetStateId]/@name"/>;	
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:for-each>
  ::else->skip;
  fi;
  ::else -> skip;
  fi;	
  goto evalsignals;
  }
  
  
  init{
  atomic{
  run <xsl:value-of select="packagedElement/@name"/>(pidCounter);
  pidCounter=pidCounter+1;
  }
  }
  </xsl:template>
</xsl:transform>
