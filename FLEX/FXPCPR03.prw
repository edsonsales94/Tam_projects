#include 'protheus.ch'
#include 'totvs.ch'

Static oExcel
Static aEstrut	:= {}

User Function FXPCPR03(cCod, cRev, lExcel, xyFilial)

	Local cDir    := "C:\temp_flex\"//cGetFile( '*.xls|*.xls' , 'Selecionar diretorio', 1, '', .T., nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE, GETF_RETDIRECTORY ),.T., .T. )
	Local cFile   := ""
	Local cDesc   := ""
	DEFAULT cRev		:= ""
	DEFAULT cCod		:= SG1->G1_COD
	DEFAULT lExcel	:= .t.

	oExcel := FwMsExcelEx():New()
	oExcel:AddworkSheet("BOM")
	oExcel:IsWorkSheet("BOM")
	oExcel:AddTable("BOM","Estrutura")

	DBSELECTAREA( "SB1" )
	DBSETORDER( 1 )
	DBSEEK( xFilial("SB1") + cCod)
	cDesc:= SB1->B1_DESC

	If Empty(cRev)
		cRevisao  := SB1->B1_REVATU
	Else
		cRevisao	:= cRev
	Endif

	DBSELECTAREA( "SG1" )
	DBSETORDER( 1 )
	If !DBSEEK( xyFilial + cCod)
		MsgStop("Não foi encontrada estrutura do produto "+alltrim(cCod)+" na filial "+xyFilial)
		Return
	Endif

	cFile := cDir+"estrutura" + STRTRAN(Alltrim(cCod),"/","") + "_" + Alltrim(cRevisao) + ".xls"

	oExcel:AddColumn("BOM","Estrutura","FILIAL")
	oExcel:AddColumn("BOM","Estrutura","CODIGO")
	oExcel:AddColumn("BOM","Estrutura","DESCRICAO")
	oExcel:AddColumn("BOM","Estrutura","UNIDADE MEDIDA")
	oExcel:AddColumn("BOM","Estrutura","GRUPO OPCIONAL")
	oExcel:AddColumn("BOM","Estrutura","ITEM OPCIONAL")
	oExcel:AddColumn("BOM","Estrutura","TIPO")
	oExcel:AddColumn("BOM","Estrutura","ORIGEM")
	oExcel:AddColumn("BOM","Estrutura","CODIGO DO ITEM")
	oExcel:AddColumn("BOM","Estrutura","DESCRICAO DO ITEM")
	oExcel:AddColumn("BOM","Estrutura","QUANTIDADE")
	oExcel:AddColumn("BOM","Estrutura","POSICAO MECANICA")
	oExcel:AddColumn("BOM","Estrutura","NCM")
	oExcel:AddColumn("BOM","Estrutura","DESTAQUE")
	oExcel:AddColumn("BOM","Estrutura","DESC SUFRAMA")
	oExcel:AddColumn("BOM","Estrutura","Obs Gerais")
	oExcel:AddColumn("BOM","Estrutura","PPB")
	oExcel:AddColumn("BOM","Estrutura","DESC PPB")
	
	runStruct(cCod, cRevisao, cDesc,xyFilial)

	If(oExcel:nRows == 0)
		aAux := Array(Len(oExcel:aTable[1,3]), '')
		oExcel:AddRow("BOM","Estrutura", aAux)
	Endif

	oExcel:Activate()
	oExcel:GetXMLFile(cFile)
	oExcel:DeActivate()
	ShellExecute( "Open",lower(cFile), "",cDir, 1 )
	MsgInfo("Arquivo "+cFile+" gerado com sucesso na pasta "+cDir)

Return

Static Function runStruct(cCod,cRevisao, cDesc, xyFilial)

	Local nItem
	Local nPI		:= 0
	Local aPIs	    := {}
	Local cXDescPr  := ""

	DBSELECTAREA( "SG1" )
	DBSETORDER( 1 )
	DBSEEK( xyFilial + cCod)

	DBSELECTAREA( "SB1" )
	DBSETORDER( 1 )
	DBSEEK( xFilial("SB1") + cCod)
	// cRevisao  := SB1->B1_REVATU
	cDesc     := SB1->B1_DESC 
	cUm		  := SB1->B1_UM

	while !(SG1->(EOF())) .AND. Alltrim(SG1->G1_COD) == Alltrim(cCod)

		if SG1->G1_REVINI <= cRevisao .AND. SG1->G1_REVFIM >= cRevisao .AND. DtoS(SG1->G1_FIM) >= DtoS(dDatabase)

			DBSELECTAREA( "SB1" )
			DBSETORDER( 1 )
			DBSEEK( xFilial("SB1") + SG1->G1_COMP)
			cOrigem  := IIF(Alltrim(SB1->B1_ORIGEM) == "0", "NACIONAL","IMPORTADO")
			cUm		 := SB1->B1_UM
			cXDescPr := Alltrim(removespecial(SB1->B1_DESC)) // antes do campo
			if !empty(SB1->B1_XDESCES)
				cXDescPr := removespecial(alltrim(SB1->B1_XDESCES)) 
			ENDIF

			aItem:= {}
			aadd(aItem,Alltrim(SG1->G1_FILIAL))
			aadd(aItem,Alltrim(SG1->G1_COD))
			aadd(aItem,Alltrim(cDesc))
			aadd(aItem,Alltrim(cUm))
			aadd(aItem,Alltrim(SG1->G1_GROPC))
			aadd(aItem,Alltrim(SG1->G1_OPC))
			aadd(aItem,Alltrim(SG1->G1_XTIPO))
			aadd(aItem,cOrigem)
			aadd(aItem,Alltrim(SG1->G1_COMP))
			aadd(aItem,cXDescPr)
			aadd(aItem,SG1->G1_QUANT)
			aadd(aItem,Alltrim(SG1->G1_XPSMECA))
			aadd(aItem,Alltrim(SB1->B1_POSIPI))
			aadd(aItem,Alltrim(SG1->G1_XNCMDES))
			aadd(aItem,Alltrim(SG1->G1_XDESCSU))
			aadd(aItem,Alltrim(SG1->G1_XNVE))
			aadd(aItem,Alltrim(SG1->G1_XPPB))
			aadd(aItem,Alltrim(SG1->G1_XDESPPB))

			oExcel:AddRow("BOM","Estrutura",aItem)
			//AADD( aEstrut,aItem)
			
			if Alltrim(SB1->B1_TIPO) == "PI"
				AADD( aPIs, {SG1->G1_COMP, SB1->B1_REVATU, SB1->B1_DESC} )
				// cComp		 := SG1->G1_COMP
				// cRevcomp := SB1->B1_REVATU
			endif

		endif

		SG1->(DBSKIP())
	end

	for nPI := 1 to Len(aPIs)
		runStruct(aPIs[nPI,1] ,aPIs[nPI,2], aPIs[nPI,3],xyFilial)
	next

Return


Static Function removespecial(cString,cEspecial,cNovoChar)
	Local cNovaString	:= ''
	Local cvalidos		:= '0123456789abcdefghijklmnopqrstuvwxyz .,-+/'
	Local cChar			:= ''
	Local nX

	If EMPTY(cString)
		Return cString
	EndIf

	cNovaString := LOWER(cString)

	If Empty(cEspecial)
		cvalidos	+= ''
	Else
		cNovaString := StrTran(cNovaString,cEspecial,cNovoChar)
		Return cNovaString
	EndIf

	For nX:=1 to Len(cNovaString)
		cChar := SubStr(cNovaString, nX, 1)
		If !(cChar $ cValidos)
			cNovaString := StrTran(cNovaString, cChar, '*')
		EndIf
	Next

	cNovaString := StrTRan(cNovaString, '*', IIF(Empty(cNovoChar),'',cNovoChar))
	cNovaString := Alltrim(Upper(cNovaString))
Return cNovaString