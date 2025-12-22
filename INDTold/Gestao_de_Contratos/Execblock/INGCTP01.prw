#include "RWMAKE.CH"

/*
Rotina....: INGCTP01
Tipo......: Função para pegar o valor dos campos na tabela CNB e atribuir a CNE
Autor.....: Ana Claudia Reis da Silva
Analista..: Adelson Veras
Data......: 01/12/2008
Objetivo..:

*/
USER FUNCTION INGCTP01()
	Local cChave := xFilial("CNB")+M->CND_CONTRA+M->CND_REVISA+M->CND_NUMERO
	//Local cChave := xFilial("CNB")+M->CND_CONTRA+M->CND_REVISA+M->CND_NUMERO+aCols[n][1]
	Local cVar   := readvar()
	Local aArea  := getArea()
	//Blah
	Local oModel := FWModelActive()
	Local cxItem := oModel:GetValue('CNEDETAIL','CNE_ITEM')

	cChave += cxItem 
	
	CNB->(dbSetOrder(1))
	CNB->(dbSeek(cChave))
	
	if (&cVar == "1") .AND. !Empty(M->CND_NUMERO)
		/*
		aCols[n][Ascan( aHeader , {|y| "CNE_XCLVL"  == Alltrim(y[2])})] := CNB->CNB_XCLVL
		aCols[n][Ascan( aHeader , {|y| "CNE_XITEMC" == Alltrim(y[2])})] := CNB->CNB_XITEMC
		aCols[n][Ascan( aHeader , {|y| "CNE_CC"     == Alltrim(y[2])})] := CNB->CNB_XCC
		aCols[n][Ascan( aHeader , {|y| "CNE_CONTA"  == Alltrim(y[2])})] := CNB->CNB_XCONTA
		aCols[n][Ascan( aHeader , {|y| "CNE_XVIAGE" == Alltrim(y[2])})] := CNB->CNB_XVIAGE
		aCols[n][Ascan( aHeader , {|y| "CNE_XTREIN" == Alltrim(y[2])})] := CNB->CNB_XTREIN
		*/
		oModel:SetValue('CNEDETAIL','CNE_XCLVL' ,CNB->CNB_XCLVL )
		oModel:SetValue('CNEDETAIL','CNE_XITEMC',CNB->CNB_XITEMC)
		oModel:SetValue('CNEDETAIL','CNE_CC'    ,CNB->CNB_XCC   )		
		oModel:SetValue('CNEDETAIL','CNE_CONTA' ,CNB->CNB_XCONTA)
		oModel:SetValue('CNEDETAIL','CNE_XVIAGE',CNB->CNB_XVIAGE)
		oModel:SetValue('CNEDETAIL','CNE_XTREIN',CNB->CNB_XTREIN)
	EndIF
	
	RestArea(aArea)
	
Return .T.
