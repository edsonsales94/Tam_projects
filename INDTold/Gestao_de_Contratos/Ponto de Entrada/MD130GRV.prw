#include "ap5mail.CH"                  
#include "PROTHEUS.CH"
#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MD130GRV   ¦ Autor ¦ Jean Vicente         ¦ Data ¦ 19/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦Ponto de entrada é executado antes da gravação da medição do   ¦¦¦
¦¦¦           ¦Contrato                                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MD130GRV()
   
   Local ExpN1 := PARAMIXB[1]  //2- Visualizar; 3- Incluir; 4- Alterar; 5-Excluir
	Local aArea := GetArea()  
   Local cMens := '<font face="Arial" size=2>A medição '+CND->CND_NUMMED+",
   Local cTit := " Exclusão da Medição "+CND->CND_NUMMED 
   Local cEmail := "" 
   Local cUsrMed := ""
 	
 	IF ExpN1 == 3 .OR. ExpN1 == 4
			// Posicina no Centro de Custo
			CTT->(dbSetOrder(1))
	     	CTT->(dbSeek(xFilial("CTT")+ACOLS[1][4]))
	 
	     	M->CND_APROV := CTT->CTT_APROV

 	ELSEIF ExpN1 == 5
 	
	  		SCR->(dbSetOrder(1))
	  		SCR->(dbSeek(xFilial("CND")+"MD"+Trim(CND->CND_NUMMED),.T.)) 
	  
	  		While !SCR->(Eof()) .And. xFilial("CND")+"MD"+Trim(CND->CND_NUMMED) == SCR->CR_FILIAL+SCR->CR_TIPO+Trim(SCR->CR_NUM)
	    		
		    		If SCR->CR_STATUS == "02" .And. !(SCR->CR_NIVEL $ "04")  // Se encontrou o próximo a liberar e o nível não for 03  //AL_CATAPRV <> C
		                cEmail += If( Empty(cEmail) , "", ";") + AllTrim(UsrRetMail(SCR->CR_USER  ) )                  
		                cUsrMed := UsrRetName(CND->CND_XUSER)               
		         EndIf             
		    		
		    		SCR->(dbSkip())
	  		End
			
			cMens += " foi excluída pelo gestor de contratos: "+ ALLTRIM(cUsrMed) +". Este documento não estará presente na rotina de liberação de documentos. " 
			
			If !Empty(cEmail)
	      		MsgRun("Enviando e-mail aos aprovadores","",{|| U_INMEMAIL(cTit,cMens,cEmail)	 })
	   		Endif
 	ELSE 
 		
 		Return      	
 	ENDIF
 
	RestArea(aArea)
Return 
