#INCLUDE "colors.ch"
#INCLUDE "rwmake.ch"
#include "TBICONN.ch"


/*/{protheus.doc}HLINVP02
Processa a Contagem das Cartelas
@author WERMESON GADELHA DO CANTO
@since 19/12/2015
/*/

***********************************************************************************************
****** Rotina    ************ HLINVP02     ****************************************************
***********************************************************************************************
****** Data      ************ 19/12/2015   ****************************************************
***********************************************************************************************
****** Autor     ************ Wermeson Gadelha ******************************************
***********************************************************************************************
****** Descrição ************ *****************************************************************
***********************************************************************************************
***********************************************************************************************
User Function HLINVP02()
	***********************************************************************************************

	Local nOpcao   := 0
	Local aSay     := {}
	Local aButton  := {}
	Local cDesc1   := OemToAnsi("Processa a Contagem das Cartelas")
	Local cDesc2   := OemToAnsi("")
	Local oObj     := Nil
	Private cTitulo:= OemToAnsi("Cartelas")
	Private lEnd   := .F.
	Private cPerg  := PadR("PLESTP07",Len(SX1->X1_GRUPO))
	Private lExp   := .F.

	//Prepare Environment Empresa "01" Filial "01" Tables "SZ4,SZ5,SB7,SBF,SB8,SB1"

	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)

	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )

	aAdd(aButton, { 5,.T.,{|| Pergunte(cPerg,.T.) } } )
	aAdd(aButton, { 1,.T.,{|oObj| nOpcao := 1,oObj:oWnd:End() } } )
	aAdd(aButton, { 2,.T.,{|oObj| oObj:oWnd:End() }} )

	FormBatch( cTitulo, aSay, aButton )

	if nOpcao == 1
		Processa({||RunThis()},"Processando Dados, Aguarde...")
		//MsgRun("Processando Dados, Aguarde...",,{||RunThis()})
	Endif

Return Nil

Static Function RunThis()
	Local cS1 := ""
	Local nS2 := 0
	Local nS3 := 0

	TableX()

	ProcRegua(0)

	If WHDS->(EOF())
		Aviso("ERRO","Sem Dados a Processar",{"Ok"},3)
		WHDS->(dbCLoseArea("WHDS"))
		Return Nil
	EndIF

	While( !WHDS->(EOF()) )

		nS3      := WHDS->CONTAGEM - WHDS->CALC
		cS1      := WHDS->PRODUTO
		nSaldo   := WHDS->CONTAGEM


		//DROR->(dbCloseArea("DROR"))
		Lotes(WHDS->PRODUTO,WHDS->ARMAZEN)

		If DROR->(EOF())

			SB1->( dbSetOrder ( 1 ) )
			SB1->( dbSeek( xFilial ("SB1") + WHDS->PRODUTO ) )

			If SB1->B1_RASTRO = 'L'
				cLote := NextLote(WHDS->PRODUTO,WHDS->ARMAZEN,WHDS->ENDERECO)
			Else
				cLote := " "
			EndIf

			SetValor(WHDS->PRODUTO,WHDS->ARMAZEN,cLote,WHDS->ENDERECO,DTOS(dDatabase + 365),nSaldo)

			If !Empty(cLote)
				SetTables(WHDS->PRODUTO,WHDS->ARMAZEN,cLote,WHDS->ENDERECO,DTOS(dDataBase + 365),0)
			EndIf
			//SetIten(WHDS->CARTELA,WHDS->PRODUTO)

			DROR->(dbCLoseArea("DROR"))
			WHDS->(dbSkip())
			Loop
		EndIf

		// Wermeson
		// Se Tiver LOTE com Saldo NEGATIVO Usar Esta Regra que avalia se o SALDO do LOTE
		// Em questão e Menor 0  e Coloca o Mesmo com 0, para Corrigir esse LOTE no Inventário
		// Está Comentado se for usar esta Descomenta e comenta a De baixo


		/*	While( !DROR->(EOF()) )
	    aAdd(aInfo,{WHDS->PRODUTO,WHDS->ARMAZEN,DROR->B8_LOTECTL,WHDS->ENDERECO,DROR->B8_DTVALID,DROR->B8_SALDO})
	    DROR->(dbSkip())
	EndDo

	For nI := 1 to Len(aInfo)
	    _ndsLote := aInfo[nI][06]
		If _ndsLote < 0
		   _ndsLote := 0
		EndIf
		If nI = Len(aInfo)
		   _ndsLote := nSaldo
		EndIf
	    SetValor(aInfo[nI][01],aInfo[nI][02],aInfo[nI][03],aInfo[nI][04],aInfo[nI][05], _ndsLote )
		//nSaldo := nSaldo - _ndsLote
	Next
		*/

		// Wermeson
		// Se Não Tiver LOTE com Saldo NEGATIVO Usar Esta Regra não avalia se o SALDO e Negativo, Palladium roda Assim hoje,
		// Ou Usa a De cima mesmo, a decisão e sua :*
		if nS3 < 0
			While( !DROR->(EOF()) )
				if nSaldo = 0
					SetValor(WHDS->PRODUTO,WHDS->ARMAZEN,DROR->B8_LOTECTL,WHDS->ENDERECO,DROR->B8_DTVALID,0)
				elseif nSaldo >= DROR->B8_SALDO
					nSaldo := nSaldo - DROR->B8_SALDO
					SetValor(WHDS->PRODUTO,WHDS->ARMAZEN,DROR->B8_LOTECTL,WHDS->ENDERECO,DROR->B8_DTVALID,DROR->B8_SALDO)
				else
					SetValor(WHDS->PRODUTO,WHDS->ARMAZEN,DROR->B8_LOTECTL,WHDS->ENDERECO,DROR->B8_DTVALID,nSaldo)
					nSaldo := 0
				Endif
				IncProc()
				DROR->(dbSkip())
			EndDo
			//SetIten(WHDS->CARTELA,WHDS->PRODUTO)
			DROR->(dbCloseArea("DROR"))
		elseif nS3 > 0
			aInfo := {}
			While( !DROR->(EOF()) )
				If B8_SALDO <= nS3
					aAdd(aInfo,{WHDS->PRODUTO,WHDS->ARMAZEN,DROR->B8_LOTECTL,WHDS->ENDERECO,DROR->B8_DTVALID,B8_SALDO})
					nS3 := nS3 - B8_SALDO
				Else
					aAdd(aInfo,{WHDS->PRODUTO,WHDS->ARMAZEN,DROR->B8_LOTECTL,WHDS->ENDERECO,DROR->B8_DTVALID,nS3})
					nS3 := 0
				EndIf
				DROR->(dbSkip())
			EndDo
			For nI := 1 to Len(aInfo)
				//		     SetValor(aInfo[nI][01],aInfo[nI][02],aInfo[nI][03],aInfo[nI][04],aInfo[nI][05],iIf(nI == Len(aInfo),nS3,0) + aInfo[nI][06])
				SetValor(aInfo[nI][01],aInfo[nI][02],aInfo[nI][03],aInfo[nI][04],aInfo[nI][05],iIf(nI == Len(aInfo),0,0) + aInfo[nI][06])
			Next
			DROR->(dbCloseArea("DROR"))
			//SetIten(WHDS->CARTELA,WHDS->PRODUTO)
		else
			While !DROR->(EOF())
				//	SetValor(WHDS->PRODUTO,WHDS->ARMAZEN,DROR->B8_LOTECTL,WHDS->ENDERECO,DROR->B8_DTVALID,DROR->B8_SALDO)
				SetValor(WHDS->PRODUTO,WHDS->ARMAZEN,DROR->B8_LOTECTL,WHDS->ENDERECO,DROR->B8_DTVALID,0)
				IncProc()
				DROR->(dbSkip())
			EndDo
			//SetIten(WHDS->CARTELA,WHDS->PRODUTO)
			DROR->(dbCloseArea("DROR"))
		EndIf

		IncProc()
		WHDS->(dbSkip())
	EndDo

	WHDS->(dbCloseArea("WHDS"))


Return Nil



Static Function ValidPerg(cPerg)

	PutSX1(cPerg, "01", "De Ano Mes  :", "", "", "mv_ch1 ", "C", 06, 0, 0, "G", "", "", "", "", "mv_par01")
	PutSX1(cPerg, "02", "Ate Ano Mes :", "", "", "mv_ch2 ", "C", 06, 0, 0, "G", "", "", "", "", "mv_par02")
	PutSX1(cPerg, "03", "Do Produto  :", "", "", "mv_ch3 ", "C", 15, 0, 0, "G", "", "", "", "", "mv_par03")
	PutSX1(cPerg, "04", "Ate Produto :", "", "", "mv_ch4 ", "C", 15, 0, 0, "G", "", "", "", "", "mv_par04")
	PutSX1(cPerg, "05", "Do Armazem  :", "", "", "mv_ch5 ", "C", 02, 0, 0, "G", "", "", "", "", "mv_par05")
	PutSX1(cPerg, "06", "Ate Armazem :", "", "", "mv_ch6 ", "C", 02, 0, 0, "G", "", "", "", "", "mv_par06")
	PutSX1(cPerg, "07", "Do Endereco :", "", "", "mv_ch7 ", "C", 15, 0, 0, "G", "", "", "", "", "mv_par07")
	PutSX1(cPerg, "08", "Ate Endereco:", "", "", "mv_ch8 ", "C", 15, 0, 0, "G", "", "", "", "", "mv_par08")
	PutSX1(cPerg, "09", "Da Cartela  :", "", "", "mv_ch9 ", "C", 10, 0, 0, "G", "", "", "", "", "mv_par09")
	PutSX1(cPerg, "10", "Ate Cartela :", "", "", "mv_ch108", "C",10, 0, 0, "G", "", "", "", "", "mv_par10")

Return Nil

Static Function TableX()

	Local cQry := ""
	Local _SZ4 := RetSqlName("SZ4")
	Local _SZ5 := RetSqlName("SZ5")

	//cQry += " Select PRODUTO,ARMAZEN,SUM(CONTAGEM) CONTAGEM,Sum(Z5_QATU) CALC,' ' ENDERECO"
	//cQry += " (
	cQry += " Select  Z5_COD PRODUTO,Z5_LOCAL ARMAZEN,' ' ENDERECO,
	cQry += "         Z4_DATA DATA,Sum(Z5_QATU) CALC,Max(Z5_FINAL) FINAL,
	cQry += "         Sum(case
	cQry += "            when Z5_DIRV1 != 'D' then Z5_QTDE1
	cQry += "            else case
	cQry += "                  when Z5_DIRV2 != 'D' then Z5_QTDE2
	cQry += "                  else Z5_QTDE3
	cQry += "                 End
	cQry += "         End ) as CONTAGEM
	cQry += " From " + _SZ4 + " Z4 "
	cQry += "  Inner Join (
	cQry += "    Select * From " + _SZ5 + "  Where D_E_L_E_T_ <> '*' "
	cQry += "    ) Z5 on Z4_FILIAL = Z5_FILIAL And Z5_NUM = Z4_NUM "
	cQry += " Where Z4.D_E_L_E_T_ <> '*' "
	cQry += "   And SubString(Z4_DATA,1,6)    BetWeen '" + mv_par01 + "' And '" + mv_par02 + "' "
	cQry += "   And Z5_COD     BetWeen '" + mv_par03 +"' And '" + mv_par04 + "'"
	cQry += "   And Z5_LOCAL   BetWeen '" + mv_par05 + "' And '" + mv_par06 + "'"
	cQry += "   And Z4_NUM     BetWeen '" + mv_par09 + "' And '" + mv_par10 + "'"
	cQry += "   And Z5_FINAL != '7' "
	cQry += "   And Z5_FILIAL = '" + SZ5->(xFilial("SZ5")) + "'"
	cQry += "   group by Z5_LOCAL,Z5_COD,Z4_DATA "
	cQry += "   order by PRODUTO "

	Memowrit("PLESTP07_1.SQL",cQry)

	MPSysOpenQuery( cQry, "WHDS" ) // dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "WHDS", .T., .F. )

Return Nil

Static Function LOTES(cProduto,cArmazen)//,cEndereco,lNegativo,lB8)

	Local cQry := ""
	Local _SBF := RetSqlName("SBF")
	Local _SB8 := RetSqlName("SB8")

	cQry += " Select * from " + _SB8 + " B8 "
	cQry += " inner join SB1010 AS SB1 ON SB1.D_E_L_E_T_ = '' AND B1_COD = B8_PRODUTO AND B1_RASTRO = 'L' "
	cQry += " Where B8.D_E_L_E_T_ = ' ' "
	cQry += " And B8_FILIAL = '" + xFilial("SB8") + "'"
	cQry += " And B8_FILIAL  = B8_FILIAL "
	cQry += " And B8_PRODUTO = '" + cProduto  + "'
	cQry += " And B8_LOCAL   = '" + cArmazen  + "'
	cQry += " And B8_SALDO > 0 "
	cQry += " Order By B8_DTVALID DESC,B8_LOTECTL

	//cQry += " Order By B8_DTVALID DESC
	//,BF_PRODUTO ASC,BF_LOCAL ASC,BF_LOCALIZ ASC,BF_LOTECTL ASC

	Memowrit("PLESTP07_2.SQL",cQry)

	MPSysOpenQuery( cQry, "DROR" ) // dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "DROR", .T., .F. )

Return Nil

Static Function SetValor(cProduto,cArmazen,cLote,cEndereco,dValid,nValor)

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+cProduto))

	SB7->(RecLock("SB7",.T.))
	SB7->B7_FILIAL := xFilial("SB7")
	SB7->B7_COD    := cProduto
	SB7->B7_LOCAL  := cArmazen
	SB7->B7_TIPO   := SB1->B1_TIPO
	SB7->B7_DOC    := SubStr(DTOS(dDataBase),1,6)
	SB7->B7_QUANT  := nValor
	SB7->B7_QTSEGUM:= iIf(SB1->B1_TIPCONV = "M",SB1->B1_CONV*nValor,iIf(SB1->B1_TIPCONV = "D",nValor/SB1->B1_CONV,0))
	SB7->B7_DATA   := dDataBase
	SB7->B7_LOTECTL:= cLote
	SB7->B7_NUMLOTE:= ""
	SB7->B7_DTVALID:= stod(dValid)
	SB7->B7_LOCALIZ:= cEndereco
	SB7->B7_NUMSERI:= ""
	SB7->B7_TPESTR := ""
	SB7->B7_OK     := "1"
	SB7->B7_ESCOLHA:= "S"
	SB7->B7_CONTAGE:= "1"
	SB7->B7_NUMDOC := ""
	SB7->B7_SERIE  := ""
	SB7->B7_FORNECE:= ""
	SB7->B7_LOJA   := ""

	SB7->(MsUnlock())

Return Nil

Static Function SetIten(cCartela,cProduto)
	Local cQry := ""

	/* cQry := " Update SZ5010 "
   cQry += " Set Z5_FINAL = '7'"
   cQry += " From SZ4010 A,SZ5010 B
   cQry += " Where B.D_E_L_E_T_ = ' ' And A.D_E_L_E_T_ = ' '"
   cQry += " And Z5_FILIAL = '" + xFilial("SZ5") + "'"
   cQry += " And Z4_FILIAL = '" + xFilial("SZ4") + "'"
   cQry += " And Z5_COD = '" + cProduto + "'"
   cQry += " And Z4_NUM = Z5_NUM
   cQry += " And Z4_NUM = '" + cCartela + "'
	cQry += " And SubString(Z4_DATA) BetWeen '" + mv_par01 + "' And '" + mv_par02 + "'"               */

	/*   If SZ5->(dbseek(xFilial("SZ5") + cCartela + cProduto))
      SZ5->(RecLock("SZ5",.F.))
        SZ5->Z5_FINAL := '7'
      SZ5->(MsUnlock())
   EndIF
	*/
Return Nil

Static Function SetTables(cProduto,cArmazen,cLote,cEndereco,dValid,nValor)


	Local aArea := {}
	Local nTam  := 20
	Local lBFGer:= .F.

	aArea := SX3->(GetArea())
	SX3->(dBSetOrder(3))
	SX3->(dbSeek("BF_NUMSERI"))
	nTam := SX3->X3_TAMANHO
	SX3->(RestArea(aArea))

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+cProduto))

	/* SBF->(dbSetOrder(1))
   If !SBF->(dbSeek(xFilial("SBF")+cArmazen+cEndereco+cProduto+Space(nTam)+cLote))
       SBF->(RecLock("SBF",.T.))
         SBF->BF_FILIAL := xFilial("SBF")
         SBF->BF_PRODUTO:= cProduto
         SBF->BF_LOCAL  := cArmazen
         SBF->BF_PRIOR  := "ZZZ"
         SBF->BF_LOCALIZ:= cEndereco
         SBF->BF_LOTECTL:= cLote
         SBF->BF_QUANT  := 0
         SBF->BF_QTSEGUM:= iIf(SB1->B1_TIPCONV = "M",SB1->B1_CONV*nValor,iIf(SB1->B1_TIPCONV = "D",nValor/SB1->B1_CONV,0))
       SBF->(MsUnlock())
       lBFGer := .T.
	EndIf                    */


	SB8->(dbSetOrder(3))
	If !SB8->(dbSeek(xFilial("SB8")+cProduto+cArmazen+cLote)) // lBFGer
		SB8->(RecLock("SB8",.T.))
		SB8->B8_FILIAL := xFilial("SB8")
		SB8->B8_QTDORI := 0
		SB8->B8_PRODUTO:= cProduto
		SB8->B8_LOCAL  := cArmazen
		SB8->B8_DATA   := dDataBase
		SB8->B8_DTVALID:= dDataBase + 365
		SB8->B8_SALDO  := 0
		SB8->B8_LOTECTL:= cLote
		SB8->B8_SALDO2 := iIf(SB1->B1_TIPCONV = "M",SB1->B1_CONV*nValor,iIf(SB1->B1_TIPCONV = "D",nValor/SB1->B1_CONV,0))
		SB8->B8_QTDORI2:= iIf(SB1->B1_TIPCONV = "M",SB1->B1_CONV*nValor,iIf(SB1->B1_TIPCONV = "D",nValor/SB1->B1_CONV,0))
		SB8->(MsUnlock())
	EndIf

Return Nil

Static Function SALDO(cProduto,cArmazen,cEndereco)

	Local cQry   := ""
	Local _SBF   := RetSqlName("SBF")
	Local _SB8   := RetSqlName("SB8")
	Local nSaldo := 0

	cQry += " Select Sum(B8_SALDO) QATU
	cQry += " From " + _SBF + " BF
	cQry += " Left Outer Join (Select * From " + _SB8 + " Where D_E_L_E_T_ <> '*'
	cQry += "                  ) B8 on B8_FILIAL = BF_FILIAL
	cQry += "                      And B8_PRODUTO= BF_PRODUTO
	cQry += "                      ANd B8_LOCAL   = BF_LOCAL
	cQry += "                      ANd B8_LOTECTL = BF_LOTECTL
	cQry += " Where BF.D_E_L_E_T_ <> '*'
	cQry += " And BF_FILIAL  = B8_FILIAL "
	cQry += " And BF_PRODUTO = '" + cProduto  + "'
	cQry += " And BF_LOCALIZ = '" + cEndereco + "'
	cQry += " And BF_LOCAL   = '" + cArmazen  + "'
	cQry += " And B8_DTVALID > '" + DTOS(dDataBase) + "'
	cQry += " And BF_FILIAL  = '" + xFilial("SBF") +   "'
	cQry += " And B8_SALDO   > 0
	cQry += " Order By B8_DTVALID DESC

	Memowrit("PLESTP07_3.SQL",cQry)

	MPSysOpenQuery( cQry, "SALDO" ) // dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "SALDO", .T., .F. )
	nSaldo := SALDO->QATU
	SALDO->(dbCloseArea("SALDO"))

Return nSaldo

/*Static Function NextLote(cProduto,cArmazen,cEndereco)
Local cQry   := ""
Local _SB8   := RetSqlName("SB8")
Local cLote  := 0

cQry += " Select isNull(MAX(B8_LOTECTL),'" + Space(10) + " ' ) LOTE
cQry += " From " + _SB8 + " B8
cQry += " Where B8.D_E_L_E_T_ <> '*'
cQry += " And B8_FILIAL  = '" + xFilial("SB7") + "'"
cQry += " And B8_PRODUTO     = '" + cProduto  + "'
//cQry += " And B7_LOCALIZ = '" + cEndereco + "'
cQry += " And B8_LOCAL   = '" + cArmazen  + "'
//cQry += " And B7_DOC     = '" + SubStr(DTOS(dDataBase),1,6) + "'"
//cQry += " And B8_LOTECTL like 'IF%'"



dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "LOTE", .T., .F. )
//if LOTE->(EOF())
//   cLote := "IF"+SubStr(DTOS(dDataBase),5,2)+SubStr(DTOS(dDataBase),3,2)+"0001"
//   else
cNum := Soma1(SubStr(LOTE->LOTE,7,4))
//EndIF
cLote := "151218001" //"IF"+SubStr(DTOS(dDataBase),5,2)+SubStr(DTOS(dDataBase),3,2)+cNum
LOTE->(dbCloseArea("LOTE"))  */
Static Function NextLote(cProduto,cArmazen,cEndereco)
	Local cQry   := ""
	Local _SB8   := RetSqlName("SB8")
	Local cLote  := 0

	cQry += " Select B8_LOTECTL LOTE
	cQry += " From " + _SB8 + " B8
	cQry += " Where B8.D_E_L_E_T_ <> '*'
	cQry += " And B8_FILIAL  = '" + xFilial("SB7") + "'"
	cQry += " And B8_PRODUTO     = '" + cProduto  + "'
	cQry += " And B8_LOCAL   = '" + cArmazen  + "'
	cQry += " And B8_SALDO >= '0' "

	MPSysOpenQuery( cQry, "LOTE" ) // dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "LOTE", .T., .F. )
	//if LOTE->(EOF())
	//   cLote := "IF"+SubStr(DTOS(dDataBase),5,2)+SubStr(DTOS(dDataBase),3,2)+"0001"
	//   else
	cNum := LOTE
	//EndIF
	cLote := cNum
	LOTE->(dbCloseArea("LOTE"))
Return cLote
