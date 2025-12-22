//-------------------------------------------------------.
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------'
#include "protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ HLCTBP12   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 29/10/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para importar o arquivo de DI do Transfer Price        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function HLCTBP12()

	//-------------------------------------------------------.
	// Declaração das variaveis Locais                        |
	//-------------------------------------------------------'
	Local nOpcao  := 0
	Local aSay    := {}
	Local aButton := {}
	Local cDesc1  := OemToAnsi("Este programa ira gerar arquivo texto referente aos dados ")
	Local cDesc2  := OemToAnsi("para análise de compras")
	Local cDesc3  := OemToAnsi("Confirma execucao?")
	Local o       := Nil
	Local oWnd    := Nil
	Local cMsg    := ""
	//-------------------------------------------------------.
	// Declaração das variaveis privadas                      |
	//-------------------------------------------------------'
	Private Titulo    := OemToAnsi("Geracao de registro de compras")
	Private lEnd      := .F.
	Private NomeProg  := "HlbCtb12"
	Private lCopia    := .F.
	Private cPerg     := "HLB012"
	Private cArq := Space(50), cFilDe := Space(02), cFilAte := Space(02), cDIde := Space(12), cDIate := Space(12)
	Private cFornDe := Space(06), cFornAte := Space(06), cProdDe := Space(15), cProdAte := Space(15)
	Private dDataDe := AvcTod("//"), dDataAte := AvcTod("//")

	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, Space(80))
	aAdd( aSay, Space(80))
	aAdd( aSay, Space(80))
	aAdd( aSay, cDesc3 )

	//aAdd(aButton, { 5,.T.,{|| Pergunte(cPerg,.T.) } } )
	aAdd(aButton, { 5,.T.,{||  cArq := ValidPerg() } } )
	aAdd(aButton, { 1,.T.,{|o| nOpcao := 1,o:oWnd:End() } } )
	aAdd(aButton, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( Titulo, aSay, aButton )

	If nOpcao == 1
		Processa({|| ArqHlb12() }, "Aguarde...", "Processando informações...", .T. )
	Endif

Return

//+-------------------------------------------------------------------------------------------------
//| Programa..: ArqHlb06()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 17/05/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Coleta de dados da tabela de notas fiscais de entrada - SF1 e SD1
//+-------------------------------------------------------------------------------------------------
*--------------------------*
Static Function ArqHlb12()
	*--------------------------*

	If !Empty(cArq)
		GeraArq()
		Ext->(dbGoTop())
	EndIf


	If !Empty(cArq)
		//Ferase(cInd)
		Ext->(dbCloseArea())
	EndIf

Return
***********************************
Static Function ValidPerg()
	***********************************
	Local cExt := "Arquivos TXT | *.TXT"
	Local cAux := ""


	PutSX1(cPerg,"01","   Arq.Import    : ","","","mv_ch1","C",99,0,0,"G","","DIR","","","mv_par01")

	Pergunte(cPerg,.T.)

Return mv_PAR01

*-------------------------------*
Static Function ValidaArq(cArq)
	*-------------------------------*
	Local cAux := cArq
	Local lTem := .T.

	If !Empty(cAux)
		cAux := Upper(AllTrim(cAux))
		If !("." $ cAux)
			cAux += ".TXT"
			If !(lTem := File(cAux))
				cAux := StrTran(cAux,".TXT",".DBF")
				lTem := File(cAux)
			Endif
		Else
			lTem := File(cAux)
		Endif

		If !lTem
			Alert("Arquivo de Origem não existe !")
			Return .F.
		Endif

		cArq := cAux
	Endif

Return .T.


//+-------------------------------------------------------------------------------------------------
//| Programa..: Grava()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 17/05/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Grava as informações coletadas em arquivo texto na pasta especificada
//+-------------------------------------------------------------------------------------------------

****************************************
Static Function Grava(cTxt,lFecha,cArq)
	****************************************
	Local cFileName, cTmpFile, cPath, cString := cTxt

	cPath := "\Transfer price\"
	cFileName := cPath +cArq+".txt"
	cTmpFile  := cPath +cArq+".tmp"


	If lFecha == NIL .Or. lFecha == .F.
		If !File(cTmpFile)
			fHandle:=FCREATE(cTmpFile)
		Else
			fHandle := FOPEN(cTmpFile,2)
		Endif
		cString := cTxt+CHR(13)+CHR(10)
		FSEEK(fHandle,0,2)
		FWRITE(fHandle,cString)
		FCLOSE(fHandle)
	Else
		If File(cFileName)
			FErase(cFileName)
		Endif
		FRename(cTmpFile, cFileName)
		If lCopia
			MsgInfo("Foi gerado arquivo de Compras, arquivo: "+cFileName,"Informacao")
			//MsgInfo("Processo finalizado com sucesso!","Final")
		Else
			MsgInfo("Nao ha dados a gerar para os parametros informados!","Final")
		EndIf

	Endif

Return


//+-------------------------------------------------------------------------------------------------
//| Programa..: Grava()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 13/07/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Lê o arquivo TXT e gera estrutura em DBF
//+-------------------------------------------------------------------------------------------------

Static Function GeraArq()
	Local aMat := {},cArqTxt, cArqDbf
	Local cDI, cInv, cDtBl, cDtDI, cDtVenc, cPart
	Local nPrazo, nQtd, nFob, cMFob, nFrete, cMFrete
	Local nSeguro, cMSeguro
	Local aStruct := {{"NR_DI"     ,"C",12,0},;
		{"INVOICE"   ,"C",15,0},;
		{"DT_BL"     ,"C",10,0},;
		{"DT_DI"     ,"C",10,0},;
		{"DT_VENCIME","C",10,0},;
		{"PRAZO_VENC","N",04,0},;
		{"QTD"       ,"N",17,3},;
		{"FOB"       ,"N",17,2},;
		{"MOEDA_FOB" ,"C",03,0},;
		{"FRETE"     ,"N",17,2},;
		{"MOEDA_FRET","C",03,0},;
		{"SEGURO"    ,"N",17,2},;
		{"MOEDA_SEGU","C",03,0},;
		{"CD_PART_NU","C",15,0}}


	aadd(aMat,{"LINHA","C",155})
	// cArqTxt := CriaTrab(aMat,.T.)
	// Use (cArqTxt) Alias Wrk new

	// dbSelectArea("Wrk")
	// Append From (cArq) Sdf
	// Wrk->(dbGoTop())

	// Instancio o objeto
	oTable  := FwTemporaryTable():New( "Wrk" )
	// Adiciono os campos na tabela
	oTable:SetFields( aMat )
	// Adiciono os índices da tabela
	// oTable:AddIndex( '01' , { "NR_DI+CD_PART_NU+INVOICE" })
	// Crio a tabela no banco de dados
	oTable:Create()
	//------------------------------------
	//Pego o alias da tabela temporária
	//------------------------------------
	cArqTxt := oTable:GetAlias()

	// cArqDbf := CriaTrab(aStruct,.T.)
	// If Select("Ext") <> 0
	//   dbCloseArea("Ext")
	// EndIf
	// dbUseArea(.T.,,cArqDbf,"Ext")
	// cInd:= CriaTrab(Nil,.F.)
	// IndRegua("Ext",cInd,"NR_DI+CD_PART_NU+INVOICE",,,"Selecionando registros...")

	// Instancio o objeto
	oTable2  := FwTemporaryTable():New( "Ext" )
	// Adiciono os campos na tabela
	oTable2:SetFields( aStruct )
	// Adiciono os índices da tabela
	oTable2:AddIndex( '01' , { "NR_DI+CD_PART_NU+INVOICE" })
	// Crio a tabela no banco de dados
	oTable2:Create()
	//------------------------------------
	//Pego o alias da tabela temporária
	//------------------------------------
	cArqDbf := oTable2:GetAlias()

	While !Wrk->(Eof())
		//0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111
		//0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555
		//1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
		//06/0492266-8  HLB002/06-P   01/04/200629/04/200605/05/2006003000000000000001000000000000200000002200000000000000000222000000000000000110220 ED-9900016-000

		cDI			:= Alltrim(SubStr(Wrk->LINHA,001,014))		// DI
		cInv		:= Alltrim(SubStr(Wrk->LINHA,015,014))		// INVOICE
		cDtBl		:= SubStr(Wrk->LINHA,029,010)				// DATA BL
		cDtDI		:= SubStr(Wrk->LINHA,039,010)				// DATA DI
		cDtVenc		:= SubStr(Wrk->LINHA,049,010)				// DATA VENCIMENTO
		nPrazo		:= Val(Alltrim(SubStr(Wrk->LINHA,059,004)))	// PRAZO VENCIMENTO
		nQtd		:= Val(Alltrim(SubStr(Wrk->LINHA,063,017)))	// QUANTIDADE
		nFob		:= Val(Alltrim(SubStr(Wrk->LINHA,080,017)))	// VALOR FOB
		cMFob		:= Alltrim(SubStr(Wrk->LINHA,097,003))	  	// MOEDA FOB
		nFrete		:= Val(Alltrim(SubStr(Wrk->LINHA,100,017)))	// VALOR FRETE
		cMFrete		:= Alltrim(SubStr(Wrk->LINHA,117,003))		// MOEDA FRETE
		nSeguro		:= Val(Alltrim(SubStr(Wrk->LINHA,120,017)))	// VALOR SEGURO
		cMSeguro	:= Alltrim(SubStr(Wrk->LINHA,137,003))		// MOEDA SEGURO
		cPart		:= Alltrim(SubStr(Wrk->LINHA,140,015))		// CÓDIGO PRODUTO

		If !eMPTY(cPart)
			RecLock("SZQ",.T.)
			SZQ->ZQ_FILIAL  := XFILIAL("SZQ")
			SZQ->ZQ_DI      := cDI
			SZQ->ZQ_INVOICE := cInv
			SZQ->ZQ_DTBL    := CtOD(cDtBl)
			SZQ->ZQ_DTDI    := CtOD(cDtDI)
			SZQ->ZQ_DTVENC  := CtOD(cDtVenc)
			SZQ->ZQ_PRAZO   := nPrazo
			SZQ->ZQ_QTD     := nQtd
			SZQ->ZQ_FOB     := nFob
			SZQ->ZQ_MOEDA   := cMFob
			SZQ->ZQ_FRETE   := nFrete
			SZQ->ZQ_MOEDFRE := cMFrete
			SZQ->ZQ_SEGURO  := nSeguro
			SZQ->ZQ_MOEDSEG := cMSeguro
			SZQ->ZQ_PRODUTO := cPart
			SZQ->(MsUnlock())
		ENDIF
		Wrk->(dbSkip())
	End
	Wrk->(dbCloseArea())

Return


Return Nil

/***********************************************************************************
*       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
*      AAAA       LL         LL         EE         CC        KK    KK   SS         *
*     AA  AA      LL         LL         EE        CC         KK  KK     SS         *
*    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   *
*   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  *
*  AA        AA   LL         LL         EE         CC        KK    KK          SS  *
* AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
************************************************************************************
*         I want to change the world, but nobody gives me the source code!         *
***********************************************************************************/
