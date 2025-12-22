#INCLUDE "Font.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Rwmake.CH"  

/*---------------------------------------------------------------------------------------------------------------------------------------------------
Providenciado Adson Carlos 
ExecBlock executado no LJ7001 apos tudo ser liberado com o intuito de imprimir o orcamento como um relatorio grafico ou matricial
----------------------------------------------------------------------------------------------------------------------------------------------------*/				

User Function AALOJE04()     
  
  Local oBut1, oBut2
  Private nLastKe1    := 0  
  
  //alert("cheguemo")
  @ 200,1 TO 380,350 DIALOG oLeTxt TITLE OemToAnsi("Orcamentos")
  @ 02,10 TO 080,190
  
  @ 10,018 Say " Escolha o tipo de orcamento a ser impresso   		"
  @ 18,018 Say " IMPRESSORA LASER / MATRICIAL                       "
  @ 26,018 Say "                                                    "
  
  oBut1:=tButton():New(60,98 ,"Laser    "  ,oLeTxt,{||First()} ,23,11,,,,.T.)       
  oBut2:=tButton():New(60,128,"Matricial",oLeTxt,{||Second()},23,11,,,,.T.)

  Activate Dialog oLeTxt Centered 

Return Nil

                                  
Static Function First()

Close(oLeTxt)
U_ORCBRAS(SL1->L1_NUM)
nLastke1 := 1

Return

Static Function Second()

Close(oLeTxt)
U_Orcamen()
nLastke1 := 1

Return
