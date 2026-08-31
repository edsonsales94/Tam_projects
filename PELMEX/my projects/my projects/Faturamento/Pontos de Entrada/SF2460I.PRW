#include "rwmake.ch"
/*_______________________________________________________________________________
¦ Função    ¦ SF2460I    ¦ Autor ¦ Reinaldo Magalhães       ¦ Data ¦ 07/12/2007 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Ponto de entrada para gravar a transportadora na nota fiscal      ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

USER Function Sf2460i
	Local mDoc, mSerie, mTransp
	Local cEspec  := SF2->F2_ESPECI1 
	Local nVolum  := SF2->F2_VOLUME1
	Local nPLiq   := SF2->F2_PLIQUI 
	Local nPBruto := SF2->F2_PBRUTO
    
	mDoc   := SF2->F2_DOC
	mSerie := SF2->F2_SERIE
	mTransp:= Space(6)

	//- Item da nota fiscal de entrada
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+mDoc+mSerie)

	nVolum  := If(nVolum == 0, CalcVol(), nVolum)
	cEspec  := If(Empty(cEspec),VerifEspec(),cEspec)
    nPliq   := If(nPLiq == 0, CalcPLiq(), nPLiq)
    nPBruto := If(nPBruto == 0, CalcPBruto(), nPBruto)
    
    mv_par01 := nVolum
	mv_par02 := cEspec
	mv_par03 := nPBruto
	mv_par04 := nPLiq
    
	//- Pedido de venda
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
		mTransp:= SC5->C5_TRANSP
	Endif

	IF ALLTRIM(cEmpAnt) == "10"
		While ! SD2->(Eof()) .And. SD2->D2_DOC+SD2->D2_SERIE == mDoc+mSerie
			RecLock("SF2",.F.)
			SD2->D2_XFILRES   := SC5->C5_XFILRES
			SD2->D2_XORCRES   := SC5->C5_XORCRES
			MsUnLock()
			SD2->(DbSkip())
		EndDo        
	EndIf

	//Acrescentado por Ulisses Junior em
	cPerg := PADR("NFESAI",Len(SX1->X1_GRUPO))
	CriaSx1(cPerg)

	If Pergunte(cPerg,.T.)
		nVolum	:= mv_par01
		cEspec	:= mv_par02
		nPBruto	:= mv_par03
		nPLiq	:= mv_par04
	EndIf


	//- Atualizando transportadora
	dbSelectArea("SF2")
	RecLock("SF2",.F.)
	SF2->F2_TRANSP	   := mTransp
	SF2->F2_TES		   := SD2->D2_TES
	SF2->F2_ESPECI1	:= cEspec
	SF2->F2_VOLUME1	:= nVolum
	SF2->F2_PLIQUI	   := nPLiq
	SF2->F2_PBRUTO	   := nPBruto
	IF ALLTRIM(cEmpAnt) == "10"
		SF2->F2_XFILRES   := SC5->C5_XFILRES
		SF2->F2_XORCRES   := SC5->C5_XORCRES
	ENDIF
	MsUnLock()

	//PreNota()  // Gera a pré-nota na filial origem da venda
Return

/*_______________________________________________________________________________
¦ Função    ¦ CriaSx1    ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 14/07/2010 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Ponto de entrada para gravar a transportadora na nota fiscal      ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaSx1(cPerg)
	u_InPutSX1(cPerg,"01","Volumes            ?","","","mv_ch1","N",10,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02","Especie            ?","","","mv_ch2","C",15,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03","Peso Bruto         ?","","","mv_ch3","N",15,4,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04","Peso Liquido       ?","","","mv_ch4","N",15,4,0,"G","","","","","mv_par04")
Return Nil

/*_______________________________________________________________________________
¦ Função    ¦ CalcVol    ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 02/08/2010 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Calcula volume para nota fiscal.                                  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CalcVol()
	Local aArea := GetArea()
	Local mVolumes := 0

	/*
	BeginSql Alias "XXX"
	SELECT SUM(C6_XVOLUME) C6_VOLUME
	FROM %Table:SC6% SC6
	WHERE SC6.%NotDel%
	AND C6_NUM = (
	SELECT DISTINCT D2_PEDIDO
	FROM %Table:SD2% SD2
	WHERE SD2.%NotDel%
	AND D2_DOC = %Exp:SF2->F2_DOC%
	AND D2_SERIE = %Exp:SF2->F2_SERIE%
	)
	EndSql
	

	BeginSql Alias "XXX"
		SELECT SUM(C6_XVOLUME) C6_VOLUME
		FROM %Table:SC6% SC6
		WHERE SC6.%NotDel%
		AND EXISTS(
		SELECT DISTINCT D2_PEDIDO, D2_ITEMPV
		FROM %Table:SD2% SD2
		WHERE SD2.%NotDel%
		AND D2_PEDIDO = C6_NUM
		AND D2_ITEMPV = C6_ITEM
		AND D2_DOC = %Exp:SF2->F2_DOC%
		AND D2_SERIE = %Exp:SF2->F2_SERIE%
		)
	EndSql

	mVolumes := XXX->C6_VOLUME
	XXX->(dbClosearea())
    */
	If mVolumes == 0 //.and. SM0->M0_CODIGO <> '20'
		BeginSql Alias "XXX"
			SELECT SUM(D2_QUANT) D2_VOLUME
			FROM %Table:SD2% SD2 (NOLOCK)
			WHERE SD2.%NotDel%
			AND D2_DOC = %Exp:SF2->F2_DOC%
			AND D2_SERIE = %Exp:SF2->F2_SERIE%
		EndSql

		mVolumes := XXX->D2_VOLUME
		XXX->(dbClosearea())
	EndIf

	RestArea(aArea)

Return mVolumes

/*_______________________________________________________________________________
¦ Função    ¦ CalcPLiq    ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 02/08/2010 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Calcula peso liquido para nota fiscal.                             ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CalcPLiq()
Local aArea := GetArea()
Local nPLiq := 0

BeginSql Alias "YYY"
SELECT SUM(PL)PESOLIQ
FROM(
SELECT D2_QUANT * B1_PESO PL
FROM %Table:SD2% SD2 (NOLOCK)
INNER JOIN %Table:SB1% SB1 (NOLOCK) ON D2_COD = B1_COD AND SB1.%NotDel% 
WHERE SD2.%NotDel%
AND D2_DOC = %Exp:SF2->F2_DOC%
AND D2_SERIE = %Exp:SF2->F2_SERIE%
)TB
EndSql

nPLiq := YYY->PESOLIQ
YYY->(dbClosearea())
RestArea(aArea)

Return nPLiq


/*_______________________________________________________________________________
¦ Função    ¦ CalcPBruto    ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 02/08/2010 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Calcula peso bruto para nota fiscal.                             ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CalcPBruto()
Local aArea := GetArea()
Local nPBruto := 0

BeginSql Alias "KKK"
SELECT SUM(PB)PESOBRUTO
FROM(
SELECT D2_QUANT * B1_PESBRU PB
FROM %Table:SD2% SD2 (NOLOCK)
INNER JOIN %Table:SB1% SB1 (NOLOCK) ON D2_COD = B1_COD AND SB1.%NotDel% 
WHERE SD2.%NotDel%
AND D2_DOC = %Exp:SF2->F2_DOC%
AND D2_SERIE = %Exp:SF2->F2_SERIE%
)TB
EndSql

nPBruto := KKK->PESOBRUTO
KKK->(dbClosearea())
RestArea(aArea)

Return nPBruto



/*_______________________________________________________________________________
¦ Função    ¦ VerifEspec ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 02/08/2010 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Verifica a especie a ser utilizada na nota fiscal.                ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function VerifEspec()
	Local mEspecie := ""

	Do Case
		Case SD2->D2_UM == "PC"
			mEspecie := "PECAS"
		Case SD2->D2_UM == "UN"
			mEspecie := "UNIDADE"
		Case SD2->D2_UM == "MT"
			mEspecie := "METROS"
		Case SD2->D2_UM == "M3"
			mEspecie := "M3"
		Case SD2->D2_UM == "KG"
			//mEspecie := If(SM0->M0_CODIGO == "20","TAMBOR","KILOS")
			nEspecie := 'QUILOS'
		Case SD2->D2_UM == "VL"
			mEspecie := "VOLUMES"
		Case SD2->D2_UM == "BL"
			mEspecie := "BLOCO"
	EndCase

Return mEspecie

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PreNota    ¦ Autor ¦ Arlindo Vieira       ¦ Data ¦ 29/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de geração da pré-nota de entrada de transferência     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PreNota()
	Local cAlias := Alias()
	Local vTot   := { 0, 0, 0}

	SB1->(dbSetOrder(1))

	// Posiciona no item da nota fiscal
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE),.T.))

	// Posiciona no Pedido de Venda
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))

	// Caso os campos de reserva não estejam preenchidos
	If Empty(SC5->C5_XORCRES) .Or. Empty(SC5->C5_XFILRES)
		Return   // Sai da rotina pois não se trata de um nota de transferência
	Endif

	While !SD2->(Eof()) .And. SF2->(F2_FILIAL+F2_DOC+F2_SERIE) == SD2->(D2_FILIAL+D2_DOC+D2_SERIE)

		// Posiciona no cadastro de produtos
		SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))

		// Grava o item da nota de entrada
		RecLock("SD1",.T.)
		SD1->D1_FILIAL  := SC5->C5_XFILRES
		SD1->D1_ITEM    := StrZero(Val(SD2->D2_ITEM),Len(D1_ITEM))
		SD1->D1_COD     := SD2->D2_COD
		SD1->D1_X_DESCR := SB1->B1_DESC
		SD1->D1_UM      := SD2->D2_UM
		SD1->D1_QUANT   := SD2->D2_QUANT
		SD1->D1_VUNIT   := SD2->D2_PRCVEN
		SD1->D1_TOTAL   := SD1->D1_VUNIT  * SD1->D1_QUANT
		SD1->D1_FORNECE := SD2->D2_CLIENTE
		SD1->D1_LOJA    := SD2->D2_LOJA
		SD1->D1_LOCAL   := SD2->D2_LOCAL
		SD1->D1_DOC     := SD2->D2_DOC
		SD1->D1_SERIE   := SD2->D2_SERIE
		SD1->D1_EMISSAO := dDataBase
		SD1->D1_DTDIGIT := dDataBase
		SD1->D1_GRUPO   := SB1->B1_GRUPO
		SD1->D1_TIPO    := "N"
		SD1->D1_TP      := SB1->B1_TIPO
		SD1->D1_PICM    := SD2->D2_PICM
		SD1->D1_BASEICM := SD2->D2_BASEICM
		SD1->D1_VALICM  := SD2->D2_VALICM
		SD1->D1_CUSTO   := SD2->D2_CUSTO1
		MsUnLock()

		// Acumula os valores da nota
		vTot[1] += SD1->D1_TOTAL
		vTot[2] += SD1->D1_BASEICM
		vTot[3] += SD1->D1_VALICM

		SD2->(dbSkip())
	Enddo

	If vTot[1] > 0   // Se encontrou itens
		// Grava o cabeçalho da nota de entrada
		RecLock("SF1",.T.)
		SF1->F1_FILIAL  := SC5->C5_XFILRES
		SF1->F1_DOC     := SF2->F2_DOC
		SF1->F1_SERIE   := SF2->F2_SERIE
		SF1->F1_FORNECE := SF2->F2_CLIENTE
		SF1->F1_LOJA    := SF2->F2_LOJA
		SF1->F1_EMISSAO := dDataBase
		SF1->F1_EST     := SF2->F2_EST
		SF1->F1_VALBRUT := vTot[1]
		SF1->F1_VALMERC := vTot[1]
		SF1->F1_BASEICM := vTot[2]
		SF1->F1_VALICM  := vTot[3]
		SF1->F1_TIPO    := "N"
		SF1->F1_DTDIGIT := dDataBase
		SF1->F1_ESPECIE := "NFE"
		MsUnLock()
	Endif
	dbSelectArea(cAlias)

Return
