#Include "rwmake.ch"
#Include "topconn.ch"
/*_______________________________________________________________________________
¦ Função    ¦ GQREENTR    ¦ Autor ¦ Ulisses Junior          ¦ Data ¦ 07/01/2008 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Ponto de Entrada após inclusão do título de no contas a pagar     ¦
---------------------------------------------------------------------------------
¦ Utilização¦ Atualizar a data de vencimento para o título de PIS, COFINS e CSLL¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function Gqreentr()
	Local x
	Local cQry   := ""
	Local nRecno := SE2->(Recno())
	Local _cArea := GetArea(), aParc := {}
	Local cChave := SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
	Local nOrder := SE2->(IndexOrd())
	Local cNumDi := SF1->F1_XNUMDI, cNumLI  := SF1->F1_XNUMLI , nTxCamb := SF1->F1_XTXCAMB
	Local cMens  := SF1->F1_XMENS , nVolum  := SF1->F1_VOLUME1, cEspec  := SF1->F1_ESPECI1
	Local nPBruto:= SF1->F1_PBRUTO, nPLiq   := SF1->F1_PLIQUI , dDtCamb := SF1->F1_XDTCAMB
	Local cNfCli := SF1->F1_XNFCLI, cEmpres := SF1->F1_XEMPRES, cNomCli := SF1->F1_XNOMCLI
	Local aPesos := {}
	Local lOk    := .T.
	Local cEndereco := PADR(GetMv("MV_XENDTRN",.F.,"TRANSITORIO"),Len(SBF->BF_LOCALIZ))
	Local aItem   := {}
	SE2->(dbSetOrder(6))
	SE2->(dbGoTop())
	SE2->(dbSeek(cChave,.T.))

	While !SE2->(Eof()) .And. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) = cChave
		aParc := {}

		If !Empty(SE2->E2_PARCPIS)
			aadd(aParc,SE2->E2_PARCPIS)
		EndIf

		If !Empty(SE2->E2_PARCCOF)
			aadd(aParc,SE2->E2_PARCCOF)
		EndIf

		If !Empty(SE2->E2_PARCSLL)
			aadd(aParc,SE2->E2_PARCSLL)
		EndIf

		If day(SE2->E2_EMIS1) > 15
			dDate := LastDay(SE2->E2_EMIS1)+15
		Else
			dDate := LastDay(SE2->E2_EMIS1)
		EndIf

		While dDate <> DataValida(dDate)
			dDate--
		End

		For x:= 1 to Len(aParc)
			cSql := "UPDATE "+RetSqlName("SE2")+" SET E2_VENCREA = '"+dtos(dDate)+"', E2_VENCTO = '"+dtos(dDate)+"' "
			cSql += "WHERE E2_PREFIXO = '"+SE2->E2_PREFIXO+"' AND E2_NUM = '"+SE2->E2_NUM+"' AND "
			cSql += "E2_FORNECE = '"+GetMv("MV_UNIAO")+"' AND E2_LOJA = '00' AND E2_PARCELA = '"+aParc[x]+"' AND "
			cSql += "E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ <> '*' "
			TCSqlExec(cSql)
		Next

		SE2->(dbSkip())
	Enddo

	SE2->(dbSetOrder(nOrder))
	SE2->(dbGoTo(nRecno))

	RestArea(_cArea)

	nVolum  := If( nVolum == 0   , CalcVol()   , nVolum)
	cEspec  := If( Empty(cEspec) , VerifEspec(), cEspec)
	aPesos  := CalcPeso()
	nPBruto := aPesos[01]
	nPliq   := aPesos[02]

	//Diego Inicio
	cPerg := PADR("NFECUSTO",Len(SX1->X1_GRUPO))
	CriaSx1(cPerg)

	If Pergunte(cPerg,.T.)
		cNumDi  := mv_par01
		cNumLI  := mv_par02
		nTxCamb := mv_par03
		dDtCamb := mv_par04
		cMens   := mv_par05
		nVolum  := If(!Empty(mv_par06),mv_par06,nVolum)
		cEspec  := If(!Empty(mv_par07),mv_par07,cEspec)
		nPBruto := If(!Empty(mv_par08),mv_par08,nPBruto)
		nPLiq   := If(!Empty(mv_par09),mv_par09,nPLiq)
		cNfCli  := mv_par10
		cEmpres := mv_par11
		cNomCli := mv_par12
	EndIf

	RecLock("SF1",.F.)
	SF1->F1_XNUMDI  := cNumDi
	SF1->F1_XNUMLI  := cNumLI
	SF1->F1_XTXCAMB := nTxCamb
	SF1->F1_XDTCAMB := dDtCamb
	SF1->F1_XMENS   := cMens
	SF1->F1_VOLUME1 := nVolum
	SF1->F1_ESPECI1 := cEspec
	SF1->F1_PBRUTO  := nPBruto
	SF1->F1_PLIQUI  := nPLiq
	SF1->F1_XNFCLI  := cNfCli
	SF1->F1_XEMPRES := cEmpres
	SF1->F1_XNOMCLI := cNomCli
	SF1->(MsUnLock())

	If MsgYesNo("Deseja endereçar automaticamente os itens dessa nota ?","Endereçamento")
		Enderecar()	
	Endif


Return

Static Function Enderecar()
	Local lLocalizado := .F.
	Local cLocaliz    := ""

	DbSelectArea("SD1")
	DbSetorder(1)
	nRecNo:=RecNo()
	DbGoTop()

	DbSelectArea("SF4")
	DbSetorder(1)
	DbGoTop()

	DbSelectArea("SBE") // Endereços
	DbSetOrder(9)       // Produto+Local+Localização

	DbSelectArea("SDA") //Cabeçalho de Itens a Endereçar
	DbSetorder(1)

	DbSelectArea("SDB") //Itens a Endereçar
	DbSetorder(1)

	DbSelectArea("SBF") // Saldo por Endereço
	DbSetOrder(1)

	DBSelectArea("SB1")
	DbSetOrder(1)

	DBSelectArea("SB2")
	DbSetOrder(1)


	SD1->(DbSeek(xFilial()+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	Do While !SD1->(Eof()) .And. SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA==SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

		SB1->(DbSeek(xFilial()+SD1->D1_COD))
		If SB1->B1_LOCALIZ == "S"
			If SF4->(DbSeek(xFilial()+SD1->D1_TES)) // Verifica o TES do Produto
				If SF4->F4_ESTOQUE == "S"  .And.	SD1->D1_QUANT <> 0 .AND. SD1->D1_LOCAL== "01" // Se movimentar estoque e for armazem 01
					cLocaliz   := PADR(GetMv("MV_XENDTRN",.F.,"TRANSITORIO"),Len(SBF->BF_LOCALIZ))
					lLocalizado:= .T.
				EndIf
			EndIf

			If lLocalizado .And. !Empty(cLocaliz)

				cLocal := SD1->D1_LOCAL //Armazém do Item na NF

				If SDA->(DbSeek(xFilial()+SD1->D1_COD+cLocal+SD1->D1_NUMSEQ+SD1->D1_DOC))

					cCod  	:= SD1->D1_COD
					cItem 	:= SD1->D1_ITEM
					cDoc  	:= SD1->D1_DOC
					cSerie  := SD1->D1_SERIE
					cCliFor := SD1->D1_FORNECE
					cLoja   := SD1->D1_LOJA
					cTipoNF := SD1->D1_TIPO
					cOrigem := "SD1"
					nQuant	:= SD1->D1_QUANT
					dData 	:= SF1->F1_DTDIGIT
					cNumSeq := SD1->D1_NUMSEQ

					RecLock("SDA",.F.)
					SDA->DA_SALDO := 0
					MsunLock()

					RecLock("SDB",.T.)
					SDB->DB_FILIAL   := xFilial("SDB")
					SDB->DB_ITEM     := cItem
					SDB->DB_PRODUTO  := cCod
					SDB->DB_LOCAL    := cLocal
					SDB->DB_LOCALIZ  := cLocaliz
					SDB->DB_DOC      := cDoc
					SDB->DB_SERIE    := cSerie
					SDB->DB_CLIFOR   := cCliFor
					SDB->DB_LOJA     := cLoja
					SDB->DB_TIPONF   := cTipoNF
					SDB->DB_TM 	     := "499"
					SDB->DB_ORIGEM   := cOrigem
					SDB->DB_QUANT    := nQuant
					SDB->DB_DATA     := dData
					SDB->DB_NUMSEQ   := cNumSeq
					SDB->DB_TIPO     := "D"
					//SDB->DB_OCORRE	 := "GQR1"
					MsUnLock()

					IF SBF->(DbSeek(xFilial("SBF")+ALLTRIM(SD1->D1_LOCAL)+ALLTRIM(cLocaliz)+SPACE(4)+ALLTRIM(SD1->D1_COD)))              
						//BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE                                                                                       
						Reclock("SBF",.F.)
						SBF->BF_QUANT := SBF->BF_QUANT + nQuant
						MsUnLock()

					Else

						Reclock("SBF",.T.)
						SBF->BF_FILIAL  := xFilial("SBF")
						SBF->BF_PRODUTO := cCod
						SBF->BF_LOCAL   := cLocal
						SBF->BF_PRIOR   := ""
						SBF->BF_LOCALIZ := cLocaliz
						SBF->BF_QUANT   := nQuant
						MsUnLock()

					EndIf

					If SB2->(DbSeek(xFilial()+SDB->DB_PRODUTO+cLocal))
						RecLock("SB2",.F.)
						SB2->B2_QACLASS := SB2->B2_QACLASS - nQuant
						MsUnLock()
					Endif

				EndIf

			EndIf
		EndIf
		SD1->(DbSkip())
	EndDo


	SD1->(DbGoto(nRecNo))

Return


Static Function CriaSx1(cPerg)
	u_InPutSX1(cPerg,"01","Numero DI          ?","","","mv_ch1","C",20,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02","Numero LI          ?","","","mv_ch2","C",20,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03","Taxa Cambial       ?","","","mv_ch3","N",17,4,0,"G","","","","","mv_par03")
	u_InPutSx1(cPerg,"04","Dt Taxa Cambial    ?","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05","Mensagem           ?","","","mv_ch5","C",30,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06","Volumes            ?","","","mv_ch6","N",10,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07","Especie            ?","","","mv_ch7","C",15,0,0,"G","","","","","mv_par07")
	u_InPutSX1(cPerg,"08","Peso Bruto         ?","","","mv_ch8","N",15,2,0,"G","","","","","mv_par08")
	u_InPutSX1(cPerg,"09","Peso Liquido       ?","","","mv_ch9","N",15,2,0,"G","","","","","mv_par09")
	u_InPutSx1(cPerg,"10","Nf de Saida        ?","","","mv_chA","C",09,0,0,"G","","","","","mv_par10")
	u_InPutSx1(cPerg,"11","Empresa            ?","","","mv_chB","C",30,0,0,"G","","","","","mv_par11")
	u_InPutSx1(cPerg,"12","Cliente            ?","","","mv_chC","C",30,0,0,"G","","","","","mv_par12")
Return Nil

/*_______________________________________________________________________________
¦ Função    ¦ CalcVol    ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 23/08/2010 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Calcula volume para nota fiscal.                                  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CalcVol()
	Local aArea    := GetArea()
	Local mVolumes := 0

	If SD1->D1_COD <> 'ZCAPA'
		BeginSql Alias "XXX"
			SELECT SUM(D1_QUANT) D1_VOLUME
			FROM %Table:SD1% SD1
			WHERE SD1.%NotDel%
			AND D1_DOC = %Exp:SF1->F1_DOC%
			AND D1_SERIE = %Exp:SF1->F1_SERIE%
			AND D1_FORNECE = %Exp:SF1->F1_FORNECE%
			AND D1_LOJA = %Exp:SF1->F1_LOJA%
		EndSql

		mVolumes := XXX->D1_VOLUME
		XXX->(dbClosearea())
	EndIf

	RestArea(aArea)

Return mVolumes

/*_______________________________________________________________________________
¦ Função    ¦ VerifEspec ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 23/08/2010 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Verifica a especie a ser utilizada na nota fiscal.                ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function VerifEspec()
	Local mEspecie := ""

	Do Case
		Case SD1->D1_UM == "PC"
		mEspecie := "PECAS"
		Case SD1->D1_UM == "MT"
		mEspecie := "METROS"
		Case SD1->D1_UM == "M3"
		mEspecie := "M3"
		Case SD1->D1_UM == "KG"
		mEspecie := If(SM0->M0_CODIGO == "20","TAMBOR","KILOS")
		Case SD1->D1_UM == "VL"
		mEspecie := "VOLUMES"
		Case SD1->D1_UM == "BL"
		mEspecie := "BLOCO"
	EndCase

Return mEspecie

/*_______________________________________________________________________________
¦ Função    ¦ CalcPeso   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 23/08/2010 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Calcula pesos para nota fiscal.                                   ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CalcPeso()
	Local aArea  := GetArea()
	Local aPesos := {}

	BeginSql Alias "XXX"
		SELECT SUM(B1_PESO) D1_PESOL, SUM(B1_PESBRU) D1_PBRUTO
		FROM %Table:SB1% SB1
		INNER JOIN %Table:SD1% SD1
		ON (D1_FILIAL = %xFilial:SD1% AND SD1.%Notdel%
		AND D1_COD = B1_COD
		AND D1_DOC = %Exp:SF1->F1_DOC%
		AND D1_SERIE = %Exp:SF1->F1_SERIE%
		AND D1_FORNECE = %Exp:SF1->F1_FORNECE%
		AND D1_LOJA = %Exp:SF1->F1_LOJA% )
		WHERE SB1.%NotDel%
	EndSql

	aPesos := { XXX->D1_PBRUTO, XXX->D1_PESOL}
	XXX->(dbClosearea())

	RestArea(aArea)

Return aPesos