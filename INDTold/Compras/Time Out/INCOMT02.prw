#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#include "ap5mail.ch"                                                                                         	

/*/
#############################################################################
ฑฑบPrograma  ณINCOMT02  บ Autor ณ ENER FREDES        บ Data ณ  21/08/09   บฑฑ
#############################################################################
ฑฑบDescricao ณ Controle de Time out Para reenvia de Solicitacao de comprasบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ INDT                                                       บฑฑ
#############################################################################
/*/

User Function INCOMT02()  
	QOUT ("------------------ Executanto W05TIM01 - FCOMT02a() em "+Dtoc(Date())+" as "+Time())
	FCOMT02a()
	QOUT ("------------------ Executanto W05TIM01 - FCOMT02b() em "+Dtoc(Date())+" as "+Time())
	FCOMT02b()
Return

/* TIME OUT PARA SOLICITAวรO SEM COMPRADOR ALOCADO*/

Static Function FCOMT02a()  
	Local cServerHttp
	Local cEmail := ""
	Local cDescFil := ""
	Local cTitulo := ""
	Local cMens := ""           
	Local ndias := 0

	Prepare Environment Empresa "01" Filial "01" Tables ""
  
	cQuery := " SELECT C1_FILIAL,C1_EMISSAO,C1_NUM FROM "+RetSQLName("SC1")+" SC1"
	cQuery += " WHERE SC1.D_E_L_E_T_ <> '*'  
	cQuery += " AND C1_RESIDUO <> 'S'
	cQuery += " AND C1_CODCOMP = ''
	cQuery += " AND C1_QUANT > C1_QUJE
	cQuery += " GROUP BY C1_FILIAL,C1_EMISSAO,C1_NUM
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
		
		If nDias > 2
			If SC1TMP->C1_FILIAL = "01"
				cDescFil := "Manaus"   
			ElseIf SC1TMP->C1_FILIAL = "02"
				cDescFil := "Brasilia"
			ElseIf SC1TMP->C1_FILIAL = "03"
				cDescFil := "Recife"
		  	Else
				cDescFil := "Sใo Paulo"
			EndIf
			cTitulo := "TIME-OUT Solicitacใo de Compra ("+cDescFil+")"+SC1TMP->C1_NUM+" sem comprador Alocado เ "+StrZero(nDias,4)+" dias"
			cMens := '<html>
			cMens += '<head>
			cMens += '<meta http-equiv="Content-Language" content="en-us">
			cMens += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
			cMens += '<title>Solicita็ใo de Compra</title>
			cMens += u_INCOMWST(.F.)
			cMens += '</head>
			cMens += '<form method="POST" action="">
			cMens += '<body>
			cMens += "<p>Solicita็ใo de Compras sem comprador แ "+StrZero(nDias,4)+" dias </p>" 
			cMens += U_INCOMW02(SC1TMP->C1_FILIAL,SC1TMP->C1_NUM)
			cMens += '</body>
			cMens += '</form>
			cMens += "</html> 
			U_INMEMAIL(cTitulo,cMens,cEmail)
		EndIf
		SC1TMP->(DbSkip())
	End
	QOUT("FIM DO TIMEOUT FCOMT02a")
	DbselectArea("SC1TMP")
	DbCloseArea("SC1TMP")
Return
           
/* TIME OUT PARA SOLICITAวรO SEM PEDIDO DE COMPRA*/

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
				cDescFil := "Sใo Paulo"
			EndIf

			If !Empty(SC1TMP->C1_CODCOMP)    
				SY1->(DbSetOrder(1))
				SY1->(DbSeek(xFilial("SY1")+SC1TMP->C1_CODCOMP))
				cEmail += IIf(Empty(cEmail),"",";")+Alltrim(SY1->Y1_EMAIL)
			EndIf
		
			cTitulo := "TIME-OUT Solicitacใo de Compra ("+cDescFil+")"+SC1TMP->C1_NUM+" sem Pedido de Compra เ "+StrZero(nDias,4)+" dias"
			cMens := '<html>
			cMens += '<head>
			cMens += '<meta http-equiv="Content-Language" content="en-us">
			cMens += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
			cMens += '<title>Solicita็ใo de Compra</title>
			cMens += u_INCOMWST(.F.)
			cMens += '</head>
			cMens += '<form method="POST" action="">
			cMens += '<body>
			cMens += "<P>Solicita็ใo de Compras sem Pedido de Compra แ "+StrZero(nDias,4)+" dias </p>" 
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
           



