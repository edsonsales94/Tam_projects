#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#include "ap5mail.ch"

/*/
#############################################################################
±±ºPrograma  ³INCOMW01  º Autor ³ ENER FREDES        º Data ³  15/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Controle de Time out Para reenvia do Pedido de Compra      º±±
#############################################################################
±±ºUso       ³ INDT                                                       º±±
#############################################################################
/*/

User Function INCOMT01()  
	Private cServerHttp

	Prepare Environment Empresa "01" Filial "01" Tables "SC1,SC7,SC8,SCR"

	cServerHttp := Getmv("MV_SERHTTP")
	QOUT ("------------------ Executanto W02TIM01 - fCOMT01a() em "+Dtoc(Date())+" as "+Time())
	fCOMT01a()  
	QOUT ("------------------ Executanto W02TIM01 - fCOMT01b() em "+Dtoc(Date())+" as "+Time())
	fCOMT01b()  
Return        

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina que gerencia o o follow-up dos pedidos de compra³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
Static Function fCOMT01a
	Local cQuery	:= ""
	Local cArea		:= GetNextAlias()
	Local cMens		:= ""
	Local cTitulo	:= ""
	Local cEmail	:= ""
	                           
	cQuery := " SELECT C7_FILIAL,C7_NUM,C7_EMISSAO,C7_DATPRF,ISNULL(ZD_DATENV,'') AS ZD_DATENV,ISNULL(ZD_DATAEF,'') AS ZD_DATAEF,ISNULL(ZD_COMP,'') AS ZD_COMP 
	cQuery += " FROM "+RetSQLName("SC7")+ " SC7
	cQuery += " LEFT OUTER JOIN "+RetSQLName("SZD")+ " SZD ON SZD.D_E_L_E_T_ = '' AND C7_FILIAL = ZD_FILIAL AND C7_NUM = ZD_PEDIDO
	cQuery += " WHERE SC7.D_E_L_E_T_ = ''
	cQuery += " AND C7_RESIDUO = '' AND C7_CONTRA = ''
	cQuery += " AND C7_QUANT > C7_QUJE
	cQuery += " AND C7_CONAPRO = 'L'
	cQuery += " AND C7_EMISSAO >= '20100101'
	//cQuery += " AND (ISNULL(ZD_COMP,'') = '' OR ISNULL(ZD_DATENV,'') = '' OR ISNULL(ZD_DATAEF,'') = '' OR C7_DATPRF = '') 
	cQuery += " AND (ISNULL(ZD_COMP,'') = '' OR ISNULL(ZD_DATENV,'') = ''  OR C7_DATPRF = '') 
	cQuery += " GROUP BY C7_FILIAL,C7_NUM,C7_EMISSAO,C7_DATPRF,ZD_DATENV,ZD_DATAEF,ZD_COMP
	cQuery += " ORDER BY C7_FILIAL,C7_EMISSAO,C7_NUM
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),cArea,.F.,.T.)
	TcSetField(cArea,"C7_EMISSAO","D")
	TcSetField(cArea,"ZD_DATENV","D")
	TcSetField(cArea,"ZD_DATAEF","D")
	TcSetField(cArea,"C7_DATPRF","D")

	DbSelectArea("SAJ")
	DbSetOrder(1)
	DbSeek(xFilial("SAJ")+"CONTRO")
	While !SAJ->(Eof()) .And. SAJ->AJ_GRCOM == "CONTRO"
		cEmail += IIf(Empty(cEmail),"",";")+AllTrim(UsrRetMail(SAJ->AJ_USER))
		SAJ->(DbSkip())
	End
	             
	
	(cArea)->(DbGotop())
	While !(cArea)->(Eof())                            
	
		cMens := '<html>
		cMens += '<head>
		cMens += u_INCOMWST(.F.)

		If (cArea)->C7_FILIAL = "01"
			cDescFil := "Manaus"   
		ElseIf (cArea)->C7_FILIAL = "02"
			cDescFil := "Brasilia"
		ElseIf (cArea)->C7_FILIAL = "03"
			cDescFil := "Recife"
  		Else
			cDescFil := "São Paulo"
		EndIf

		If Empty((cArea)->ZD_COMP)    
			If (Date() - (cArea)->C7_EMISSAO) >= 2
				cMens += " <p> Pedido de Compra à " + StrZero(Date() - (cArea)->C7_EMISSAO,4) + " dias sem Comprador Alocado </p>"
			EndIf
		EndIf
		
		If Empty((cArea)->C7_DATPRF)    
			If (Date() - (cArea)->C7_EMISSAO) >= 2
				cMens += " <p> Pedido de Compra à " + StrZero(Date() - (cArea)->C7_EMISSAO,4) + " dias sem Data de Previsão de Entrega Informada </p>"
			EndIf
		EndIf
		
		If Empty((cArea)->ZD_DATENV)    
			If (Date() - (cArea)->C7_EMISSAO) >= 2
				cMens += " <p> Pedido de Compra à " + StrZero(Date() - (cArea)->C7_EMISSAO,4) + " dias sem Data de Envio ao Fornecedor no Follow-up </p>"
			EndIf
		EndIf
		/* Comentado por Diego por solicitação da Usuaria Amanda Araujo
		If Empty((cArea)->ZD_DATAEF)    
			If (Date() - (cArea)->C7_EMISSAO) >= 2
				cMens += " <p> Pedido de Compra à " + StrZero(Date() - (cArea)->C7_EMISSAO,4) + " dias sem Data de Entrega do Fornecedor no Follow-up </p>"
			EndIf
		EndIf
		*/
		cTitulo := "<TIME-OUT> Pedido de Compra "+(cArea)->C7_NUM+" do Site "+cDescFil+" com pendências de Informações"
		cMens += u_INCOMW03((cArea)->C7_FILIAL,(cArea)->C7_NUM) 

		If !Empty((cArea)->ZD_COMP)    
			SY1->(DbSetOrder(1))
			SY1->(DbSeek(xFilial("SY1")+(cArea)->ZD_COMP))
			cEmail += IIf(Empty(cEmail),"",";")+Alltrim(SY1->Y1_EMAIL)
		EndIf
				
		cMens += "</Html>"

		u_INMEMAIL(cTitulo,cMens,cEmail)
		
		(cArea)->(DbSkip())
	End
	DbSelectArea(cArea) 
	DbCloseArea(cArea)
Return


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÌ,>l->l->¿
//³Rotina que envia email para o fluxo de aprovação do Pedido de compra³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÌ,>l->l->Ù
ENDDOC*/
Static Function fCOMT01b
	Local cQuery	:= ""
	Local cArea		:= GetNextAlias()
	Local cMens		:= ""
	Local cTitulo	:= ""
	Local cEmail	:= ""
	Local cUserSol	:= ""
	Local cNumSC	:= ""

	cQuery := " SELECT CR_FILIAL,CR_NUM,CR_USER,AK_NOME,CR_EMISSAO FROM "+RetSQLName("SCR")+ " SCR
	cQuery += " INNER JOIN "+RetSQLName("SAK")+ " SAK ON CR_USER = AK_USER
	cQuery += " WHERE SCR.D_E_L_E_T_ = ''
	cQuery += " AND CR_TIPO IN ('PC','AE')
	cQuery += " AND CR_STATUS = '02'
	cQuery += " AND CR_EMISSAO >= '20100101'
	cQuery += " AND CR_EMISSAO < '"+Dtos(Date())+"'
	cQuery += " ORDER BY CR_FILIAL,CR_NUM

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),cArea,.F.,.T.)
	TcSetField(cArea,"CR_EMISSAO","D")
	(cArea)->(DbGotop())
	While !(cArea)->(Eof())                            
		cNumSC := Posicione("SC7",1,(cArea)->CR_FILIAL+(cArea)->CR_NUM,"C7_NUMSC")
		cUserSol := Posicione("SC1",1,(cArea)->CR_FILIAL+cNumSC,"C1_USER")
		
      cEmail := AllTrim(UsrRetMail(cUserSol)) //AllTrim(UsrRetMail(SC1->C1_USER))  // WERMESON 
      cEmail += ";"+AllTrim(UsrRetMail((cArea)->CR_USER)) //";"+AllTrim(UsrRetMail(SCR->CR_USER)) // WERMESON       
		      
		cMens := '<html>
		cMens += '<head>
		cMens += u_INCOMWST(.F.)

		If (cArea)->CR_FILIAL = "01"
			cDescFil := "Manaus"   
		ElseIf (cArea)->CR_FILIAL = "02"
			cDescFil := "Brasilia"
		ElseIf (cArea)->CR_FILIAL = "03"
			cDescFil := "Recife"
  		Else
			cDescFil := "São Paulo"
		EndIf

		If Date() > (cArea)->CR_EMISSAO
			cMens += " <p> O Sr." + aLLTRIM((cArea)->AK_NOME)+" ainda não liberou o Pedido abaixo...</p>
		EndIf
		
		cTitulo := "<TIME-OUT> Liberaçao do pedido"+(cArea)->CR_NUM+" do Site "+cDescFil+" pendente"
		
		cMens += u_INCOMW03((cArea)->CR_FILIAL,(cArea)->CR_NUM)
		cMens += '</html>

		u_INMEMAIL(cTitulo,cMens,cEmail)
		(cArea)->(DbSkip())
	End
	DbSelectArea(cArea) 
	DbCloseArea(cArea)
Return


