#INCLUDE "rwmake.ch"
#include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCOME03  บAutor  ณEner Fredes         บ Data ณ  13/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para o digita็ใo e valida็ใo da data de entrega do    บฑฑ
ฑฑบ          ณ Pedido de Compra                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COMPRAS - PE MA120BUT - PEDIDO DE COMPRA                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function INCOME03()
	Local dDatprf 
	Local nPosDATPRF:= aScan(aHeader, {|x| Alltrim(x[2]) == "C7_DATPRF"})  

//	If fVerDtEnt(CA120NUM)
//		LiberaData() 
//		Return    
//	Else
		fDigitaData()
//	EndIf                           
return
                                           
Static Function fDigitaData
	Local dDatprf 
	Local nPosDATPRF:= aScan(aHeader, {|x| Alltrim(x[2]) == "C7_DATPRF"})  
	DbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(xFilial("SC7")+CA120NUM)
	dDatPrf:= aCols[1,nPosDATPRF]
	
	@ 00,00 TO 120,350 DIALOG oDlg TITLE "Ajusta data de entrega do Pedido"
	
	@ 10, 001 SAY "Data de Entrega do Pedido:"
	@ 10, 040 GET dDatprf SIZE 40,20 PICTURE "@!" OBJECT odDatprf
	@ 30,050 BMPBUTTON TYPE 1 ACTION GrvDataEntrega(oDlg,dDatPrf,nPosDATPRF)
	@ 30,080 BMPBUTTON TYPE 2 ACTION Close(oDlg)

	ACTIVATE DIALOG oDlg CENTERED
	
return


Static Function LiberaData
	Local oPsw, nOpc := 0, cPswFol := Space(14), lRet := .T.
	Local oFont1  := TFont():New("Courier New",,-14,.T.,.T.)
	
	DEFINE MSDIALOG oPsw TITLE "Data de Entrega Preenchido !!" From 8,70 To 15,110 OF oMainWnd
	
	@ 05,005 SAY "Digite a Senha para Libera Digita็ใo da data de Entrega" PIXEL OF oPsw
	@ 15,035 GET cPswFol PASSWORD SIZE 50,10 PIXEL OF oPsw FONT oFont1
	@ 35,010 BUTTON oBut1 PROMPT "&Ok" SIZE 30,12 OF oPsw PIXEL Action IIF(fValidaSenha(cPswFol),(nOpc:=1,oPsw:End()),nOpc:=0)
	@ 35,040 BUTTON oBut2 PROMPT "&Cancela" SIZE 30,12 OF oPsw PIXEL Action (nOpc:=0,oPsw:End())
	
	ACTIVATE MSDIALOG oPsw
	
Return




Static Function fValidaSenha(cSenha)

	If Alltrim(cSenha) <> "1972"
		Alert("Senha Invalida!!")
		Return  
	EndIf
	fDigitaData()

Return .t.

Static function GrvDataEntrega(oDlg,dDatPrf,nPosDATPRF)
	Local nPosITEM:= aScan(aHeader, {|x| Alltrim(x[2]) == "C7_ITEM"})
	Local nItem := 1
	Local cPedido
	Local x 
	Close(oDlg)
	
//	If fVerPedido(CA120NUM)
		cQuery := " UPDATE "+RetSqlName("SC7")
		cQuery += " SET C7_DATPRF = '"+Dtos(dDatPrf)+"'
		cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7")+"' AND C7_NUM = '"+CA120NUM+"'
		TCSQLEXEC(cQuery)
/*		
		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial("SC7")+CA120NUM+aCols[n,nPosITEM])
		While !SC7->(Eof()) .And. SC7->C7_NUM == CA120NUM
			Reclock("SC7",.F.)
			SC7->C7_DATPRF:= dDatPrf
			MSUnlock()
			SC7->(DbSkip())
		End  
		DbSeek(xFilial("SC7")+CA120NUM+aCols[n,nPosITEM])
*/		
  //	EndIf
	  
	DbSelectArea("SZD")  
	SZD->(DbSetOrder(1))
	If SZD->(DbSeek(xFilial("SZD")+CA120NUM))
		While !SZD->(Eof()) .And. ZD_FILIAL =xFilial("SZD") .And. ZD_PEDIDO == CA120NUM
			SZD->(RecLock("SZD",.F.))
			SZD->ZD_DATENTF := dDatPrf
			If dDatPrf >= SZD->ZD_DATA
				SZD->ZD_STAENT := "No Prazo"
			else
				SZD->ZD_STAENT := "Fora do Prazo"
			EndIf
			SZD->(MsUnlock())
			SZD->(DbSkip())
		End
	EndIf
	
	For x := 1 to Len(aCols)
		aCols[x,nPosDATPRF]:= dDatPrf
	Next  
	lGrava:= .F.
return                                                                                 
 


Static Function fVerPedido(cPedido)
	Local lEntregue := .T.
	Local cQuery
	cQuery := " SELECT COUNT(*) ABERTO
	cQuery += " FROM "+RetSqlName("SC7")+" SC7
	cQuery += " WHERE SC7.D_E_L_E_T_ <> '*' AND C7_NUM = '"+cPedido+"' AND  C7_QUANT > C7_QUJE
	dbUseArea(.T.,"TOPCONN",TCGenQry(,	,ChangeQuery(cQuery)),"PED",.F.,.T.)
	If PED->ABERTO > 0
		lEntregue := .F.
	EndIf  
	DbCloseArea("PED")
	DbSelectArea("SC7") 
ReTurn lEntregue


Static Function fVerDtEnt(cPedido)
	Local lDtEntrega := .T.
	Local cQuery
	
	cQuery := " SELECT COUNT(*) ABERTO
	cQuery += " FROM "+RetSqlName("SC7")+" SC7
	cQuery += " WHERE SC7.D_E_L_E_T_ <> '*' AND C7_NUM = '"+cPedido+"' AND  C7_DATPRF = ''
	dbUseArea(.T.,"TOPCONN",TCGenQry(,	,ChangeQuery(cQuery)),"PED",.F.,.T.)
	If PED->ABERTO > 0
		lDtEntrega := .F.
	EndIf  
	
	DbCloseArea("PED")
	DbSelectArea("SC7") 
ReTurn lDtEntrega
