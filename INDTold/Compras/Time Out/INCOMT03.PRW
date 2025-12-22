#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#include "ap5mail.ch"                                                                                         	

/*/
#############################################################################
±±ºPrograma  ³INCOMT03  º Autor ³ ENER FREDES        º Data ³  02/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envia Email para Inclusão de Pré-Nota                      º±±
#############################################################################
/*/

User Function INCOMT03(cDoc,cSerie,cFornece,cUser,cTime,dData,nValor,dDtEmissao)  
	Local cEmail := ""
	Local cMens := ""           
	Local cTitulo := "" 
	Local cQuery  := ""       
	Local cAlias := ALIAS()
	
	cQuery += " SELECT AN_USER,AN_EMAIL FROM "+ RetSqlName("SAN") 
	cQuery += " WHERE AN_EVENTO = '005' AND D_E_L_E_T_ = ''"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)), "COMT03"  ,.T.,.T.)

	While !COMT03->(Eof())                                 
		If !Empty(COMT03->AN_EMAIL)
			cEmail += IIf(Empty(cEmail),"",";")+Alltrim(COMT03->AN_EMAIL)
		Else
			cEmail += IIf(Empty(cEmail),"",";")+AllTrim(UsrRetMail(COMT03->AN_USER))
		EndIf		
		COMT03->(DbSkip())
	End  
	DbSelectArea("COMT03")
	DbCloseArea("COMT03")
	
	DbSelectArea(cAlias)
	
	If xFilial("SF1") = "01"
		cDescFil := "Manaus"   
	ElseIf xFilial("SF1") = "02"
		cDescFil := "Brasilia"
	ElseIf xFilial("SF1") = "03"
		cDescFil := "Recife"
  	Else
		cDescFil := "São Paulo"
	EndIf

	cTitulo := "TIME-OUT Inclusão de Pré - Nota "+cDoc+" - "+Alltrim(cFornece)+""
	cMens := '<html>
	cMens += '<head>
	cMens += '<meta http-equiv="Content-Language" content="en-us">
	cMens += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
	cMens += '<title>Solicitação de Compra</title>
	cMens += u_INCOMWST(.F.)
	cMens += '</head>
	cMens += '<form method="POST" action="">
	cMens += '<body>
	cMens += "<P>Nota Fiscal "+cDoc+" - "+cFornece+" </p>" 
	cMens += ' <table border="0" width="80%" id="table2">

	cMens += '<tr><td width="20%" ><font size="2" ><b>Usuário:</b></font></td><td width="40%" align="Left"><font size="2" >'+cUser+'</font></td></tr>
	cMens += '<tr><td width="20%" ><font size="2" ><b>Nro.Nota:</b></font></td><td width="40%" align="Left"><font size="2" >'+cDoc+'</font></td></tr>
	cMens += '<tr><td width="20%" ><font size="2" ><b>Série:</b></font></td><td width="40%" align="Left"><font size="2" >'+cSerie+'</font></td></tr>
	cMens += '<tr><td width="20%" ><font size="2" ><b>Fornecedor:</b></font></td><td width="40%" align="Left"><font size="2" >'+cFornece+'</font></td></tr>
	cMens += '<tr><td width="20%" ><font size="2" ><b>Dt.Emissao:</b></font></td><td width="40%" align="Left"><font size="2" >'+DToc(dDtEmissao)+'</font></td></tr>
	cMens += '<tr><td width="20%" ><font size="2" ><b>Dt.Entrada:</b></font></td><td width="40%" align="Left"><font size="2" >'+DToc(dData)+'</font></td></tr>
	cMens += '<tr><td width="20%" ><font size="2" ><b>Hr.Entrada:</b></font></td><td width="40%" align="Left"><font size="2" >'+cTime+'</font></td></tr>
	cMens += '<tr><td width="20%" ><font size="2" ><b>Valor:</b></font></td><td width="40%" align="Left"><font size="2" >'+Transform(nValor,"@E 999,999,999.99")+'</font></td></tr>
	
	cMens += '</table>'
	
	cMens += "</p>" 
	cMens += '</body>
	cMens += '</form>
	cMens += "</html> 
	U_INMEMAIL(cTitulo,cMens,cEmail)



Return

/* TIME OUT PARA SOLICITAÇÃO SEM COMPRADOR ALOCADO*/
Static Function FCOMT02b()  
	Local cServerHttp
	Local cEmail := ""
	Local cDescFil := ""
	Local cTitulo := ""
	Local cMens := ""           
	Local ndias := 0

	Prepare Environment Empresa "01" Filial "01" Tables ""
  
	cQuery := " SELECT C1_FILIAL,C1_EMISSAO,C1_NUM,C1_CODCOMP FROM "+RetSQLName("SC1")+" SC1"
	cQuery += " WHERE SC1.D_E_L_E_T_ <> '*'  
	cQuery += " AND C1_RESIDUO <> 'S'
	cQuery += " AND C1_CODCOMP <> ''
	cQuery += " AND C1_PEDIDO = ''
	cQuery += " AND C1_QUANT > C1_QUJE
	cQuery += " GROUP BY C1_FILIAL,C1_EMISSAO,C1_NUM,C1_CODCOMP
	cQuery += " ORDER BY C1_FILIAL,C1_NUM

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"SC1TMP",.F.,.T.)
	TcSetField("SC1TMP","C1_EMISSAO","D")

	DbSelectArea("SAJ")
	DbSetOrder(1)
	DbSeek(xFilial("SAJ")+"CONTRO")
	While !SAJ->(Eof()) .And. SAJ->AJ_GRCOM == "CONTRO"
		cEmail += IIf(Empty(cEmail),"",";")+AllTrim(UsrRetMail(SAJ->AJ_USER))
		SAJ->(DbSkip())
	End                  
	While !SC1TMP->(Eof())
		ndias := (Date() - SC1TMP->C1_EMISSAO)
		
		If nDias > 5
			If SC1TMP->C1_FILIAL = "01"
				cDescFil := "Manaus"   
			ElseIf SC1TMP->C1_FILIAL = "02"
				cDescFil := "Brasilia"
			ElseIf SC1TMP->C1_FILIAL = "03"
				cDescFil := "Recife"
		  	Else
				cDescFil := "São Paulo"
			EndIf

			If !Empty(SC1TMP->C1_CODCOMP)    
				SY1->(DbSetOrder(1))
				SY1->(DbSeek(xFilial("SY1")+SC1TMP->C1_CODCOMP))
				cEmail += IIf(Empty(cEmail),"",";")+Alltrim(SY1->Y1_EMAIL)
			EndIf
		
			cTitulo := "TIME-OUT Solicitacão de Compra ("+cDescFil+")"+SC1TMP->C1_NUM+" sem Pedido de Compra à "+StrZero(nDias,4)+" dias"
			cMens := '<html>
			cMens += '<head>
			cMens += '<meta http-equiv="Content-Language" content="en-us">
			cMens += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
			cMens += '<title>Solicitação de Compra</title>
			cMens += u_INCOMWST(.F.)
			cMens += '</head>
			cMens += '<form method="POST" action="">
			cMens += '<body>
			cMens += "<P>Solicitação de Compras sem Pedido de Compra á "+StrZero(nDias,4)+" dias </p>" 
			cMens += U_INCOMW02(SC1TMP->C1_FILIAL,SC1TMP->C1_NUM)
			cMens += '</body>
			cMens += '</form>
			cMens += "</html> 
			U_INMEMAIL(cTitulo,cMens,cEmail)
		EndIf
		SC1TMP->(DbSkip())
	End
	QOUT("FIM DO TIMEOUT FCOMT02b")
	DbselectArea("SC1TMP")
	DbCloseArea("SC1TMP")
Return
           



