#include "RWMAKE.CH"

User Function MT097END() 
	Local cDocto    := PARAMIXB[1] 
	Local cTipoDoc  := PARAMIXB[2]
	Local nOpcao    := PARAMIXB[3]
   Local cFilter := SCR->(dbFilter())    
   Local _adArea := GetArea()

	If Alltrim(cTipoDoc) = "PC" .And. nOpcao == 2 
//  	u_INEnviaEmail(xFilial("SC7"),Alltrim(cDocto),"",1,"")   // Envia e-mail para os aprovadore
	ElseIf nOpcao == 3                       
		cQuery := " UPDATE "+RetSqlName("SCR")
		cQuery += " SET CR_STATUS = '02'
		cQuery += " WHERE CR_FILIAL = '"+xFilial("SCR")+"' AND CR_NUM = '"+cDocto+"' AND CR_TIPO = '"+cTipoDoc+"' AND CR_STATUS = '04'
		TCSQLEXEC(cQuery)

  		Alert("Este botão está desabilitado. Usar o botão Reprovar!!!")
		u_INEnviaEmail(xFilial("SC7"),Alltrim(cDocto),"",2,"")   // Envia e-mail para os aprovadore
	EndIf 
	   cFilter := SubStr(cFilter,21,len(cFilter))//StrTran(cFilter,'CR_FILIAL=="' + SCR->(xFilial("SA2"))+ '".And.',"" )   
   //Aviso('',cFilter,{''},3) 
   dbSelectArea("SCR")
   Set Filter To &(cFilter)
   RestArea(_adArea)

Return 
