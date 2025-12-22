#INCLUDE "RWMAKE.CH"
#include "Protheus.Ch"
#include "TopConn.Ch"
#include "TBIConn.Ch"
#include "TbiCode.ch"

/*/{Protheus.doc} BlkUbkUsu

Bloqueio e Desbloqueio de Usuarios do Sistema

@type function
@author Honda Lock
@since 01/10/2017
/*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BDUsuar  บ Autor ณRicardo M M Borgesn บ Data ณ  02/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Bloqueio e Desbloqueio de Usuarios do Sistema              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Administrador 										      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BlkUbkUsu()          

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aOrd           := {}
Private cPerg        := "BKUBUS"

//AjustSX1()

Pergunte(cPerg,.T.)

Processa({|| ProcUsu()}, "Usuarios")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณProcUsu   บ Autor ณ Ricardo M M Borges บ Data ณ  02/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Processa o Bloqueio ou Desblqueio dos Usuแrios             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ProcUsu()

Local nOrdem
Local aAllUsers:= AllUsers()
Local aUser    := {}
Local i        := 0
Local k        := 0            
Local j        := 0
Local aMenu    

//aModulos := fModulos()
//aAcessos := fAcessos() 

/*
Private cCodUsr := RetCodUsr()
Private aGrupos := UsrRetGrp(cCodUsr)
Private cUser   := UsrRetName(cCodUsr)
Private cNomeUsr:= UsrFullName(cCodUsr)
*/

Private _cUsuLiber := Alltrim( GetMv("MV_XUSUINV")) //"P.SIMOES/E.SANTOS/J.DUTRA/A.BELLONI/P.RODRIGUES/R.NORIAKI/R.BORGES/rborges"

//_cUsuLiber += "G.PREVENTI/D.AUGUSTO/S.BORGES/"

IF !ApMsgYesno("Usuแrios Liberados: " + _cUsuLiber + " , Confirma (S/N)? ","Confirma") 
   Return .T.
Endif

//Alert(Usuแrios Liberados: + )

_ncont:=0   

_ncontBloq:=0
                               
For i:=1 to Len(aAllUsers)

	If Upper ( Alltrim( aAllUsers[i][01][02] ) )  $ _cUsuLiber
	
		//----Do Nothing
		
		//ApMsgInfo("USer: " + aAllUsers[i][01][02] + " Name: "+ aAllUsers[i][01][04] + " Nใo Bloqueado!" )
		
		_ncont++
		
		
	Else
          
		If Substr( aAllUsers[i][01][02],1,5 ) = "Admin"		
			//ApMsgInfo("Eh Admin")                        
		Else        
		   _ncontBloq++
		   aAdd(aUser,aAllUsers[i])						
		Endif	
		
	   	//If Alltrim(aAllUsers[i][01][02])>=Alltrim(mv_par01) .and. Alltrim(aAllUsers[i][01][02])<=Alltrim(mv_par02)
	    	  //aAdd(aUser,aAllUsers[i])
	   	//Endif   

	Endif
   
Next
                                     
/*
If mv_par05==1 //ID
   aSort(aUser,,,{ |aVar1,aVar2| aVar1[1][1] < aVar2[1][1]})
Else           //Usuario
   aSort(aUser,,,{ |aVar1,aVar2| aVar1[1][2] < aVar2[1][2]})
Endif   
*/

//ProcRegua(Len(aUser)) //nใo usar
ProcRegua(0)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processa Usuarios ณ       
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู       


For i:=1 to Len(aUser)          

	If Substr(aUser[i][01][02],1,5) <> "Admin"

	    IncProc("Processando User ID: " + aUser[i][01][01] ) //ID) 
	    
	    PswBlock(aUser[i][01][02])  
	   
	    //If aUser[i][01][02]="rborges"	   
	       			//If MV_PAR03 = 1	     //Bloqueia
	    	   				//ApMsgInfo("Achou rborges","Info")
		       				//ApMsgInfo(If(aUser[i][01][17],"Bloqueado","Desbloqueado"))
							//PswBlock(aUser[i][01][02])  
	       			//ElseIf MV_PAR03 = 2    //Desbloqueia               
		       				//ApMsgInfo("Achou rborges","Info")
		       				//ApMsgInfo(If(aUser[i][01][17],"Bloqueado","Desbloqueado"))
			       //Endif	
			  //Exit	      
	    //Endif
	
	Endif
   
                
Next i        

ApMsgAlert("Fim de Processamento")

ApMsgInfo("Total Liberados.:" + Alltrim(strzero(_ncont,6)) )   

ApMsgInfo("Total Bloqueados:" + Alltrim(strzero(_ncontBloq,6)) )  


Return

            
                          
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ AjustaSX1ณ Autor ณ Carlos G. Berganton   ณ Data ณ 15/03/04 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica as perguntas incluกndo-as caso no existam        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustSX1()

Local aArea	    := GetArea()
Local cPerg		:= "BKUBUS"
Local aRegs		:= {}
Local i

/*
AAdd(aRegs,{"01","Do ID..............?","mv_ch1","C",06,0,0,"G","mv_par01",""   ,""       })
AAdd(aRegs,{"02","Ate ID.............?","mv_ch2","C",06,0,0,"G","mv_par02",""   ,""       })
*/

AAdd(aRegs,{"01","Do Usuario.........?","mv_ch1","C",15,0,0,"G","mv_par01",""   ,""       })
AAdd(aRegs,{"02","Ate Usuario........?","mv_ch1","C",15,0,0,"G","mv_par02",""   ,""       })
AAdd(aRegs,{"03","Bloqueia/Desbloqueia?","mv_ch9","N",01,0,0,"C","mv_par09","Blo","Des"   })

dbSelectArea("SX1")
dbSetOrder(1)
For i:=1 to Len(aRegs)
	dbSeek(cPerg+aRegs[i][1])
	If !Found() .or. aRegs[i][2]<>X1_PERGUNT
		RecLock("SX1",!Found())
           SX1->X1_GRUPO   := cPerg
           SX1->X1_ORDEM   := aRegs[i][01]
           SX1->X1_PERGUNT := aRegs[i][02]
           SX1->X1_VARIAVL := aRegs[i][03]
           SX1->X1_TIPO    := aRegs[i][04]
           SX1->X1_TAMANHO := aRegs[i][05]
           SX1->X1_DECIMAL := aRegs[i][06]
           SX1->X1_PRESEL  := aRegs[i][07]
           SX1->X1_GSC     := aRegs[i][08]
           SX1->X1_VAR01   := aRegs[i][09]
           SX1->X1_DEF01   := aRegs[i][10]
           SX1->X1_DEF02   := aRegs[i][11]
		MsUnlock()
	Endif
Next

RestArea(aArea)

Return

   /*	
   @ nLin,000 pSay "I N F O R M A C O E S   D O   U S U A R I O"
   nLin+=1
   @ nLin,000 pSay "User ID.........................: "+aUser[i][01][01] //ID
   nLin+=1
   @ nLin,000 pSay "Usuario.........................: "+aUser[i][01][02] //Usuario
   nLin+=1
   @ nLin,000 pSay "Nome Completo...................: "+aUser[i][01][04] //Nome Completo
   nLin+=1
   @ nLin,000 pSay "Validade........................: "+DTOC(aUser[i][01][06]) //Validade
   nLin+=1
   @ nLin,000 pSay "Acessos para Expirar............: "+AllTrim(Str(aUser[i][01][07])) //Expira em n acessos
   nLin+=1
   @ nLin,000 pSay "Autorizado a Alterar Senha......: "+If(aUser[i][01][08],"Sim","Nao") //Autorizado a Alterar Senha
   nLin+=1
   */