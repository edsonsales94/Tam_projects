#Include "Protheus.ch"
#Include "Rwmake.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  HLRPCP10  ºAutor  ³Luciano Lamberti    º Data ³  20/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relação de Pedidos sem Saldo								  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlterações³ 															  ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PCP				                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function HLRPCP10()

	Local cPerg	:= "HLRPCP10"
	ValidPerg(cPerg)

	If !Pergunte(cPerg,.t.)
		Return ( .t. )
	EndIf

	MsgRun("Aguarde, Gerando Planilha ...","",{|| CursorWait(),HLRPCP10(),CursorArrow()})

Return


/**********************/
Static Function HLRPCP10()

	Local aStru		:= {}
	Local aRegs		:= {}
	Local cArq		:= "PEDBLOQ" + SM0->M0_CODIGO + ".CSV"
	Local cStrQry := "("

	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSelectArea("SB2")
	dbSetOrder(1)


	// MONTA CABECALHO EXCEL
	aStru := {	{"PEDIDO"				, "C", 06, 0},; //00
		{"PRODUTO"  			, "C", 30, 0},; //01
		{"QTD VENDA"			, "N", 15, 0},; //02
		{"ESTOQUE"				, "N", 15, 0},;	//03
		{"DIFERENCA"			, "N", 15, 0}} //04


	cStrQry += ")"

	cQuery := "SELECT "+ CRLF
	cQuery += "		SC6.C6_NUM, SC6.C6_PRODUTO, sum(SC6.C6_QTDVEN) AS QTD_VENDA , SB2.B2_QATU, ((SB2.B2_QATU)-sum(SC6.C6_QTDVEN)) AS DIFERENCA"+ CRLF
	cQuery += "FROM "+ RetSqlTab("SC6") +" "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SB2") +" "+ CRLF
	cQuery += "			ON 	"+ RetSqlDel("SB2") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SB2") +" "+ CRLF
	cQuery += "				AND SB2.B2_COD = SC6.C6_PRODUTO"+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SC6") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SC6") +" "+ CRLF
	cQuery += "		AND SB2.B2_LOCAL = '03' "+ CRLF
	cQuery += "		AND SC6.C6_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "+ CRLF
	cQuery += "GROUP BY "+ CRLF
	cQuery += "		SC6.C6_NUM, SC6.C6_PRODUTO,SB2.B2_QATU  "+ CRLF
	memoWrite("\SQL\HLRPCP10.SQL",cQuery)

	MPSysOpenQuery( cQuery, "QRY" ) // dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

	QRY->(dbGotop())

	While QRY->(!EOF())


		cCamposRA := Alltrim(QRY->C6_NUM)+";"													// 00
		cCamposRA += Alltrim(QRY->C6_PRODUTO)+";"														// 01
		cCamposRA += AllTrim(cValtoChar(QRY->QTD_VENDA))+";"            								      		// 03
		cCamposRA += AllTrim(cValtoChar(QRY->B2_QATU))+";"              									  		// 04
		cCamposRA += AllTrim(cValtoChar(QRY->DIFERENCA))+";"              									   		// 05



		AAdd(aRegs,cCamposRA)


		QRY->(DbSkip())

	EndDo

	CriaExcel(aStru,aRegs,cArq)

	QRY->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaExcel ºAutor  ³Luciano Lamberti    º Data ³  20/04/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relação de Pedidos sem Saldo                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Generico 								                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaExcel(aStru,aRegs,cArq)

	Local cDirDocs 	:= MsDocPath()
	Local cPath		:= AllTrim(GetTempPath())
	Local oExcelApp
	Local cCrLf 	:= Chr(13) + Chr(10)
	Local nHandle
	Local nX

	ProcRegua(Len(aRegs)+2)

	nHandle := MsfCreate( "C:\totvs\" + cArq , 0 )

	If nHandle > 0

		// Grava o cabecalho do arquivo

		IncProc("Aguarde! Gerando arquivo de integração com Excel...")

		aEval(aStru, {|e,nX| fWrite(nHandle, e[1] + If(nX < Len(aStru), ";", "") ) } )

		fWrite(nHandle, cCrLf ) // Pula linha

		For nX := 1 to Len(aRegs)
			IncProc("Aguarde! Gerando arquivo de integração com Excel...")
			fWrite(nHandle,aRegs[nX])
			fWrite(nHandle, cCrLf ) // Pula linha
		Next

		IncProc("Aguarde! Abrindo o arquivo..." )

		fClose(nHandle)

		//	CpyS2T( cDirDocs + "\" + cArq , cPath, .T. )
		CpyS2T( cDirDocs + "\totvs" + "\" + cArq , cPath, .T. )

		If ! ApOleClient('MsExcel')
			MsgAlert("Excel nao instalado!")
			Return
		Else
			MsgAlert( "Arquivo: "+AllTrim(cArq)+" criado com sucesso!")

			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open("C:\totvs\" +cArq ) // Abre a planilha
			oExcelApp:SetVisible(.T.)
		EndIf
	Else
		MsgAlert( "Falha na criacao do arquivo" )
	Endif

Return


/******************************/
Static Function ValidPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs   := {}
	Local i, j

	dbSelectArea("SX1")
	dbSetOrder(1)

	cPerg := Padr(cPerg, Len(X1_GRUPO))

	aAdd(aRegs,{cPerg,"01","Pedido de      ","Pedido De      ","Pedido De      ","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","XM0"})
	aAdd(aRegs,{cPerg,"02","Pedido Até     ","Pedido Até     ","Pedido Até     ","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","XM0"})


	For i := 1 to Len(aRegs)
		If 	!dbSeek( cPerg + aRegs[i,2] )
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock("SX1")
		Endif
	Next

	dbSelectArea(_sAlias)

Return
