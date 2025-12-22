#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT110GRV  บ Autor ณ ENER FREDES        บ Data ณ  02/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ  PE executado ap๓s a confirma็ใo da SC depois da grava็ใo  บฑฑ
ฑฑบ          ณ  das tabelas. serแ usado para Bloquear a SC                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COMPRAS - Solicita็ใo de Compra                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/        

              
User function MT110GRV()        
	Local cEmail := ""
	Local cDescFil := ""
	Local cTitulo := ""
	Local cMens := ""           
	Local cAlias := ALIAS()

	cQuery := " UPDATE "+RetSqlName("SC1")
	cQuery += " SET C1_APROV = 'B'
	cQuery += " WHERE D_E_L_E_T_ = ''
	cQuery += " AND C1_FILIAL = '"+xFilial("SC1")+"'
	cQuery += " AND C1_NUM = '"+CA110NUM+"' AND C1_QUANT <> C1_QUJE
	TCSQLEXEC(cQuery)

	DbSelectArea("SAJ")
	DbSetOrder(1)
	DbSeek(xFilial("SAJ")+"CONTRO")
	While !SAJ->(Eof()) .And. SAJ->AJ_GRCOM == "CONTRO"
		cEmail += IIf(Empty(cEmail),"",";")+AllTrim(UsrRetMail(SAJ->AJ_USER))
		SAJ->(DbSkip())
	End                  
	
	
	If xFilial("SC1") = "01"
		cDescFil := "Manaus"   
	ElseIf xFilial("SC1") = "02"
		cDescFil := "Brasilia"
	ElseIf xFilial("SC1") = "03"
		cDescFil := "Recife"
  	Else
		cDescFil := "Sใo Paulo"
	EndIf
	If INCLUI          
		SC1->(DbSetOrder(1))
		If SC1->(DbSeek(xFilial("SC1")+CA110NUM))
			cTitulo := "Inclusใo de Solicitacใo de Compra - "+cDescFil+" - "+CA110NUM
			cMens := "Inclusใo de Solicitacใo de Compra 
			cMens += "<P></P>"
			cMens += "<br>Filial : "+cDescFil
			cMens += "<br>Numero : "+CA110NUM
			cMens += "<br>Emissใo : "+DToc(SC1->C1_EMISSAO)
			cMens += "<br>Solicitante : "+SC1->C1_SOLICIT
			U_INMEMAIL(cTitulo,cMens,cEmail)
		EndIf    
	EndIf
	DbSelectArea(cAlias)
Return .T.
