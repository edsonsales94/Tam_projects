#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#include 'tbiconn.ch'

/*/
.----------------------------------------------------------------------------------------------------------------------.
|     Programa     |     AAESTT01      |     Autor     |     Wagner da Gama Corrêa     |     Data     |     09/11/10     |
|------------------------------------------------------------------------------------------------------------------------|
|     Descricao    |     Tela de Calculo de tira slitada                                                                 |
'----------------------------------------------------------------------------------------------------------------------'
/*/

User Function AAESTT01()

	Private cCadastro := "Calculo de Tiras Slitadas"
	Private aRotina   := { {"Pesquisar" ,"AxPesqui"   ,0,1} ,;
	{"Visualizar","u_ESTT01Inc",0,2} ,;
	{"Incluir"   ,"u_ESTT01Inc",0,3} ,;
	{"Alterar"   ,"u_ESTT01Inc",0,4} ,;
	{"Excluir"   ,"u_ESTT01Inc",0,5} }

	Private cAlias0 := "SZ0"
	Private cAlias1 := "SZ1"
	Private cFilSZ0 := SZ0->(xFilial("SZ0"))
	Private cFilSZ1 := SZ1->(xFilial("SZ1"))

	dbSelectArea(cAlias0)
	dbSetOrder(1)
	mBrowse( 6,1,22,75,cAlias0)

Return
/*/
.----------------------------------------------------------------------------------------------------------------------.
|     Função     |     ESTT01Inc     |     Autor     |     Wagner da Gama Correa     |     Data     |     11/11/2009     |
|------------------------------------------------------------------------------------------------------------------------|
|     Descriçäo  |     Inclusão de Cortes de Bobinas                                                                     |
'----------------------------------------------------------------------------------------------------------------------'
/*/
User Function ESTT01Inc(cAlias, nRecNo, nOpc)

	Local nX, nLnh, nCln
	Local nOpcA    := 0
	Local aPos     := { 15, 1, 100, 350}
	Local aAltera  := {}
	Local aButtons := {}

	Private oDlg    := Nil
	Private oGet    := Nil
	Private nPD     := 1
	Private nUsado  := 0
	Private aHeader := {}
	Private aCols   := {}
	Private aTela   := {}
	Private aGets   := {}

	Private cProdSC2 := AllTrim(GetMV("MV_XPRODGEN",.F.,""))

	//Valida o produto informado no parametro
	SB1->(dbSetOrder(1))

	If !SB1->(dbSeek(xFilial("SB1") + PadR(cProdSC2,TamSX3("B1_COD")[1])))
		Aviso( "Inválido!", "O parâmetro MV_XPRODGEN, apresenta um dos seguintes erros: " + Chr(10) + Chr(13) +;
		"1 - O parâmetro não existe" + Chr(10) + Chr(13) + ;
		"2 - O parâmetro esta vazio" + Chr(10) + Chr(13) + ;
		"3 - O valor informado, Ex:(Codigo do produto), não foi encontrado no cadastro de produtos" , {"Ok"} )
		Return Nil
	EndIf

	Private bTotais := {|a,b,c,d| TotalDraw(a,b,c,d) }

	Private vTotal  := { {0, Nil, "Largura",     CLR_HBLUE,"T"},;
	{0, Nil, "Peso"   ,     CLR_GREEN,"D"},;
	{0, Nil, "Sobra LARG.", CLR_HRED ,"L"},;
	{0, Nil, "Sobra PESO",  CLR_HRED ,"E"},;
	{0, Nil, "% Refilo",    CLR_BLACK,"V"} }

	Inclui := (nOpc == 3)
	Altera := (nOpc == 4)

	If nOpc == 4
		Aviso( "Inválido!", "Não é possivel alterar, pois foi gerada uma ordem de produção!" , {"Ok"} )
		Return Nil
	EndIf
	// .---------------------------------------
	//|      Inicia as variaveis para Enchoice
	// '---------------------------------------

	Private bCampo  := {|nField| FieldName(nField) }

	dbSelectArea(cAlias0)
	dbSetOrder(1)
	For nX := 1 To fCount()
		M->&( Eval(bCampo,nX) ) := IIF( nOpc == 3, CriaVar(FieldName(nX),.T.), FieldGet(nX) )
	Next nX

	//  .-------------------
	// |     Monta os aCols
	//  '-------------------
	MontaACols(@aAltera)

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 29,89 OF oMainWnd
	EnChoice( cAlias0, nRecNo, nOpc, , , , , aPos, , 3)

	oGet := MSGetDados():New(100,1,186,350,nOpc,,,,.T.,,,,999,,,,"AlwaysFalse",oDlg)

	If Inclui .Or. Altera
		oGet:oBrowse:bChange := {|| .T. }
		oGet:oBrowse:bChange := {|| ESTT01CpoAlt(oGet:oBrowse,nOpc) }
		ESTT01CpoAlt(oGet:oBrowse,nOpc)
	Endif

	nLnh := 191
	nCln := 005

	For nX:=1 To Len(vTotal)

		If nCln > 275
			nLnh += 015
			nCln := 005
		Endif

		Eval(bTotais,nX,nLnh,nCln)

		nCln += 90
	Next

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA:=1,If(nOpc==2.Or.Obrigatorio(aGets,aTela),oDlg:End(),nOpcA:=0)},;
	{|| nOpcA:=0,oDlg:End() },,aButtons) CENTERED

	If nOpc <> 2 .And. nOpcA == 1
		//Begin Transaction
		BeginTran() 
		ESTT01Grava(nOpc,nRecNo,aAltera)
		//End Transaction
		EndTran()
		MsUnlockAll()
	Endif

Return
/*/
.----------------------------------------------------------------------------------------------------------------------.
|     Função     |     TotalDraw     |     Autor     |     Wagner da Gama Correa     |     Data     |     03/12/2010     |
|------------------------------------------------------------------------------------------------------------------------|
|     Descriçäo  |     Exibe os totais do Corte                                                                          |
'----------------------------------------------------------------------------------------------------------------------'
/*/
Static Function TotalDraw(z,nLnh,nCln)

	@ nLnh,nCln+00 SAY "Total " + vTotal[z,3] PIXEL OF oDlg COLOR vTotal[z,4]
	@ nLnh,nCln+50 SAY vTotal[z,2] VAR vTotal[z,1] Picture IIF( z <> 2, "@E 9999999.99", "@E 9999.999") SIZE 30,10 PIXEL OF oDlg COLOR vTotal[z,4]

Return
/*/
.-----------------------------------------------------------------------------------------------------------------------.
|     Função     |     ESTT01Vld     |     Autor      |     Wagner da Gama Correa     |     Data     |     03/12/2010     |
|-------------------------------------------------------------------------------------------------------------------------|
|     Descriçäo  |     Valida os campos do container                                                                      |
'-----------------------------------------------------------------------------------------------------------------------'
/*/
User Function ESTT01Vld()
	Local cVar := ReadVar()
	Local nDel := Len(aCols[1])
	Local lRet := .T.
	Local nPItem := AScan( aHeader , {|x| Trim(x[2]) == "Z1_CODSLIT" })
	Local nX := 0

	SB1->(dbSetOrder(1))
	If cVar == "M->Z0_COD"
		lRet := ExistCpo("SB1")
	ElseIf cVar == "M->Z1_CODSLIT"

		//Valida inclusao dos itens	
		For nX := 1 To Len(aCols)
			  If nX <> n .And. aCols[nX,nPItem] == M->&(cVar) 
			    Return ExistChav("SX5","01")
			    Exit
			  Endif
		Next 

		/*If aScan( aCols, {|x| x[1] == M->Z1_CODSLIT} ) <> 0
		MsgStop("Produto já foi informado na planilha de corte.")
		Return .F.
		EndIf*/

		If lRet := ExistCpo("SB1")
			SB1->(dbSeek(XFILIAL("SB1")+M->Z1_CODSLIT))

			If !SB1->B1_TIPO $ "PI"
				MsgAlert("Selecione apenas produto intermediário!","Atenção")
				Return .F.
			EndIf
		Endif

		If lRet
			_nEspessura := M->Z0_ESPESS

			If Posicione("SB1", 1, xFilial("SB1") + M->Z1_CODSLIT, "B1_XESPESS") <> _nEspessura
				MsgStop("Espessura da Bobina Slitada deve ser igual a da Bobina Principal.")
				Return .F.
			EndIf
		EndIf	

	ElseIf cVar $ "M->Z1_LARG / M->Z1_QUANT"
		vTotal[1,1] := 0
		vTotal[2,1] := 0
		vTotal[3,1] := 0
		vTotal[4,1] := 0
		vTotal[5,1] := 0
       
		nPQuant := aScan( aHeader, {|x| AllTrim(x[2]) == "Z1_QUANT"})
		nPLarg  := aScan( aHeader, {|x| AllTrim(x[2]) == "Z1_LARG" })
		nTLarg  := aScan( aHeader, {|x| AllTrim(x[2]) == "Z1_TLARG" })
		
		aCols[n,nTLarg] := aCols[n,nPQuant] * aCols[n,nPLarg] 

		For w:=1 To Len(aCols)
			If w = n
				vTotal[1,1] += Round( &cVar * aCols[w, IIF( AllTrim(cVar)=="M->Z1_QUANT", nPLarg, nPQuant)], 2)
				vTotal[2,1] += Round( Round( ((M->Z0_PESO * 1000) - M->Z0_REFILO) / vTotal[1,1], 0) * Round( &cVar * aCols[w, IIF( AllTrim(cVar)=="M->Z1_QUANT", nPLarg, nPQuant)], 2) / 1000, 3)
			Else
				vTotal[1,1] += Round( aCols[w, nPLarg] * aCols[w, nPQuant], 2)
				vTotal[2,1] += Round( Round( ((M->Z0_PESO * 1000) - M->Z0_REFILO) / aCols[w, nTLarg], 0) * Round( aCols[w, nPLarg] * aCols[w, nPQuant], 2) / 1000, 3)
			EndIF
		Next

		vTotal[1,2]:Refresh()
		vTotal[2,2]:Refresh()

		vTotal[3,1] := M->Z0_LARG - vTotal[1,1]
		vTotal[4,1] := (M->Z0_PESO - (M->Z0_REFILO/1000)) - vTotal[2,1]
		vTotal[5,1] := ((M->Z0_REFILO/1000) / M->Z0_PESO ) * 100

		If vTotal[1,1] > M->Z0_LARG
			MsgStop("Largura Total maior que a largura da Bobina.")
			lRet := .F.
		EndIf

		vTotal[3,2]:Refresh()
		vTotal[4,2]:Refresh()
		vTotal[5,2]:Refresh()

	Endif

Return lRet
/*/
.-------------------------------------------------------------------------------------------------------------------------.
|     Função     |     ESTT01Grava     |      Autor     |     Wagner da Gama Correa     |     Data     |     06/12/2010     |
|---------------------------------------------------------------------------------------------------------------------------|
|     Descriçäo  |     Grava os dados da tabela de Cortes                                                                   |
'-------------------------------------------------------------------------------------------------------------------------'
/*/
Static Function ESTT01Grava(nOpc,nRecNo,aAltera)

	Local nX, nY, x, nDel
	Local vDel := {}
	Local cOP := ""
	Local lRollBack	:= .F.

	// .-----------------------------
	//| Se for inclusão ou alteração
	// '-----------------------------

	If nOpc == 3 .Or. nOpc == 4
		// .------------------------------------------------
		//|     Grava os dados referente ao Corte da Slitter
		// '------------------------------------------------
		dbSelectArea(cAlias0)
		RecLock(cAlias0,Inclui)
		For nX := 1 To fCount()
			If "FILIAL" $ FieldName(nX)
				FieldPut(nX,cFilSZ0)
				FieldPut(FieldPos(Z0_NUM), M->Z0_NUM)
			Else
				FieldPut(nX,M->&(Eval(bCampo,nX)))
			Endif
		Next nX
		MsUnLock()

		nDel := Len(aHeader) + 1

		dbSelectArea(cAlias1)
		dbSetOrder(1)
	Endif

	// .-------------------
	//|    Se for inclusão
	// '-------------------
	If nOpc == 3
		// .----------------------------------------------------
		//|     Grava os dados referente aos cabeçalho de corte
		// '----------------------------------------------------
		For nX := 1 To Len(aCols)
			If !aCols[nX][nDel] .And. !Empty(aCols[nX][2])
				RecLock(cAlias1,.T.)
				For nY := 1 To Len(aHeader)			    
					if Trim(aHeader[nY,2]) == 'Z1_NROBAR'
						SZ1->Z1_NROBAR := _GetMaxInformation(aCols[nX,nY], Trim(aHeader[nY,2]) )
					Else
						FieldPut(FieldPos(Trim(aHeader[nY,2])), _GetMaxInformation(aCols[nX,nY], Trim(aHeader[nY,2]) ) )
					EndIf
				Next nY
				SZ1->Z1_FILIAL := cFilSZ1
				SZ1->Z1_NUM    := M->Z0_NUM
				SZ1->Z1_RATEIO := (SZ1->Z1_TPESO / M->Z0_PESO) * 100
				MsUnLock()
			Endif
		Next nX

		cOP := u_AAPCPC04() //GETNUMSC2() // mudanca solicitado pelo sr. Romulo no dia 05/04/2018 - Realizada por Wermeson
		//cOP := GETNUMSC2() // Retornado por Diego em 03/05/18 a Pedido do Francisco pois a alteração acima  estava gerando problemas com a numeração
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1") + PadR(cProdSC2,TamSX3("B1_COD")[1])))

		_xdRecurso := ""

		_xdRecurso := ""
		If SuperGetMv("MV_XRECSC2",.F.,"S") == "S"
			_xdRecurso := _getRecurso()  
		EndIf

		aDadosOp := {M->Z0_FILIAL,;
		cOP,;
		"01",;
		"001",;
		SB1->B1_COD,;
		SB1->B1_UM,;
		M->Z0_LOCAL,;
		(M->Z0_PESO * 1000) - M->Z0_REFILO,;
		M->Z0_NUM,;
		_xdRecurso}

		//Gera a OP principal do calculo de corte
		lRollBack := FMata650(aDadosOp,3)

		If lRollBack
			Alert("Foram encontrados erros na inclusão da OP, o ROLLBACK dos registros foi realizado!")
			Return
		EndIf

		//Gera o empenho
		lRollBack := FMata380(aDadosOp,3)
		If lRollBack
			Alert("Foram encontrados erros na inclusão do Empenho, o ROLLBACK dos registros foi realizado!")
			Return
		EndIf

		Aviso(cCadastro,"Ordem de produção gerada: " + Alltrim(cOP),{"OK"})
		//Desmonta("I")

		//Sucata("I")
	Endif

	//  .--------------------
	// |     Se for alteracao
	//  '--------------------
	If nOpc == 4
		//  .--------------------------------------------------
		// |     Grava os dados referente aos Cortes de Slitter
		//  '--------------------------------------------------
		For nX := 1 To Len(aCols)
			//  .-------------------------------------------------------------------------.
			// |      Caso os itens adicionados à mais estejam deletados, então ignora     |
			//  '-------------------------------------------------------------------------'
			If Empty(aCols[nX,2]) .or. nX > Len(aAltera) .and. aCols[nX,nDel]
				Loop
			Endif

			If nX <= Len(aAltera)
				dbGoTo(aAltera[nX]) // Posiciona no registro da Posicao
				RecLock(cAlias1,.F.)
			Else
				RecLock(cAlias1,.T.)
				SZ1->Z1_FILIAL := cFilSZ1
				SZ1->Z1_NUM    := M->Z0_NUM
			Endif

			If aCols[nX,nDel]
				dbDelete()
			Else
				For nY := 1 To Len(aHeader)
					FieldPut( FieldPos(Trim(aHeader[nY,2])), aCols[nX,nY] )
				Next
			Endif
			MsUnLock()
		Next nX
	Endif

	//  .-------------------
	// |     Se for exclusão
	//  '-------------------
	If nOpc == 5

		/*If !EstT01Leg(2,M->Z0_NUM)
		Alert("Verifique a ordem de produção deste calculo de corte!")
		Return Nil	
		EndIf*/
		_xdOP := getNumOP(SZ0->Z0_NUM, xFilial('SC2'))
		lContinue := .T.
		If EMpty(_xdOP)
			lContinue := AViso('Atencao','OP não encontradao para este calculo de corte,Deseja Prosseguir?',{'Sim','Nao'}) == 01
		ELse
			SC2->(dbSetORder(1))
			SC2->(dbSeek(xFilial('SC2') + _xdOP ))

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + PadR(SC2->C2_PRODUTO,TamSX3("B1_COD")[1]) ) )

			aDadosOp := {SZ0->Z0_FILIAL,;
			SC2->C2_NUM,;
			SC2->C2_ITEM,;
			SC2->C2_SEQUEN,;
			SB1->B1_COD,;
			SB1->B1_UM,;
			SZ0->Z0_LOCAL,;
			(SZ0->Z0_PESO * 1000) - SZ0->Z0_REFILO,;
			SZ0->Z0_NUM,;
			"" }

			//Gera a OP principal do calculo de corte
			// Estorna o Empenho
			lRollBack := FMata380(aDadosOp,5)
			If lRollBack
				Alert("Foram encontrados erros na inclusão do Empenho, o ROLLBACK dos registros foi realizado!")
				Return
			EndIf
			// Estorna a OP
			lRollBack := FMata650(aDadosOp,5)

			If lRollBack
				Alert("Foram encontrados erros na Exclusão da OP, o ROLLBACK dos registros foi realizado!")
				Return
			EndIf

			//Desmonta("E")
			//Sucata("E")			
		EndIf
		//  .-------------------------------------------------
		// |     Exclui os dados referente ao Corte de Bobina
		//  '-------------------------------------------------
		If lCOntinue
			dbSelectArea(cAlias0)
			dbGoTo(nRecNo)
			RecLock(cAlias0,.F.)
			dbDelete()
			MsUnLock()

			//  .----------------------------------------------------------
			// |     Exclui os dados referente aos itens de Corte de Bobina
			//  '----------------------------------------------------------
			dbSelectArea(cAlias1)
			dbSetOrder(1)
			For nX := 1 To Len(aCols)
				If !Empty(aCols[nX,2])
					dbGoTo(aAltera[nX]) // Posiciona no registro da Posicao
					RecLock(cAlias1,.F.)
					dbDelete()
					MsUnLock()
				Endif
			Next nX
		EndIf
	Endif

Return
/*/
_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ESTT01Del  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 11/11/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validar delecao dos itens                                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function _GetNroBar()
   
   Local xInf := 0
   
   nPQuant := aScan( aHeader, {|x| AllTrim(x[2]) == "Z1_QUANT"})
   nPLarg  := aScan( aHeader, {|x| AllTrim(x[2]) == "Z1_LARG" })
   nTLarg  := aScan( aHeader, {|x| AllTrim(x[2]) == "Z1_TLARG" })
   
   
       
Return _GetMaxInformation(aCols[nX][],_xdCpo)

Static Function _GetMaxInformation(_xdInf,_xdCpo)
	Local _adSX3    := SX3->(GetArea())
	Local _cdReturn := ""

	if _xdCpo == 'Z1_NROBAR'
		//alert(_cdReturn)
		cd := "asjhfa"
	EndIf

	SX3->(dbSetORder(2))
	SX3->(dbSeek(_xdCpo))    
	If ValType(_xdInf) == "N"
		_cdReturn := Round(_xdInf,SX3->X3_DECIMAL)
		if SX3->X3_DECIMAL == 0
			_cdReturn := Int(_cdReturn)
		EndIf
	Else
		_cdreturn := _xdInf
	EndIf
	SX3->(RestArea(_adSX3))

Return _cdReturn

User Function ESTT01Del()
	Local lRet := .T.
	/*
	Local x, nPos
	Local lRet := .T.
	Local nDel := Len(aCols[1])

	If nPD == 1 .and. !aCols[n,nDel] // Na delecao da linha - 2a. passagem
	If lRet := !Movimento(,aCols[n,2])   // Se não encontrou movimentações
	If !Empty(aCols[n,2])   // Se foi informado o chassis
	vTotal[1,1]--
	vTotal[1,2]:Refresh()
	nPos := AScan(vTotal,{|x| x[5] == aCols[n,1] })
	vTotal[nPos,1]--
	vTotal[nPos,2]:Refresh()
	Endif
	Endif
	ElseIf nPD == 1 .And. aCols[n,nDel]  // Na recuperacao da linha - 1a. passagem
	For x:=1 To Len(aCols)
	If aCols[x,2] == aCols[n,2] .And. x <> n .And. !aCols[x,nDel]
	If lRet := ExistChav("SX5","01")
	Exit
	Endif
	Endif
	Next
	Endif
	nPD := If( nPD == 2 , 1, nPD + 1)
	*/
Return lRet

/*/
.-------------------------------------------------------------------------------------------------------------------------.
|     Função     |     ESTT01CpoAlt     |     Autor     |     Wagner da Gama Correa     |     Data     |     06/12/2010     |
|---------------------------------------------------------------------------------------------------------------------------|
|     Descriçäo  |     Habilita a leitura dos campos conforme condicao                                                      |
'-------------------------------------------------------------------------------------------------------------------------'
/*/
Static Function ESTT01CpoAlt(oGet,nOpc)
Return .T.
/*/
.-----------------------------------------------------------------------------------------------------------------------.
¦     Função     ¦     MontaaCols     ¦     Autor     ¦     Wagner da Gama Corrêa     ¦     Data     ¦     18/11/2010     ¦
¦-------------------------------------------------------------------------------------------------------------------------¦
¦     Descriçäo  ¦     Cria a variavel vetor aCols                                                                        ¦
'-----------------------------------------------------------------------------------------------------------------------'
/*/
Static Function MontaaCols(aAltera)
	Local nCols, nUsado, nX, nPos

	//  .-------------------
	// |     Monta o aHeader
	//  '-------------------
	CriaHeader()

	//  .-----------------------------------------------------------------------
	//  |     Monta o aCols com os dados referentes ao Itens do Corte de Slitter
	//  '-----------------------------------------------------------------------
	nCols  := 0
	nUsado := Len(aHeader)

	If Inclui
		//  .-----------------------------------------
		//  |     Monta o aCols com uma linha em branco
		//  '-----------------------------------------
		aColsBlank(cAlias1,@aCols,nUsado)
	Else
		//  .----------------------------------------
		// |     Carrega os dados do corte de slitter
		//  '----------------------------------------
		dbSelectArea(cAlias1)
		dbSetOrder(1)
		dbSeek(cFilSZ1+M->Z0_NUM, .T.)
		While !Eof() .and. cFilSZ1+M->Z0_NUM == Z1_FILIAL+Z1_NUM

			aAdd(aCols,Array(nUsado+1))
			nCols ++

			For nX := 1 To nUsado
				If ( aHeader[nX][10] != "V")
					aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
				Else
					aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
				Endif
			Next nX

			aCols[nCols][nUsado+1] := .F.
			aAdd( aAltera , Recno() )

			dbSkip()
		EndDo
	Endif

Return .T.
/*/
.-----------------------------------------------------------------------------------------------------------------------.
¦     Função     ¦     aColsBlank     ¦     Autor     ¦     Wagner da Gama Correa     ¦     Data     ¦     18/11/2010     ¦
|-------------------------------------------------------------------------------------------------------------------------|
¦     Descriçäo  ¦ Cria array de itens em branco                                                                          ¦
'-----------------------------------------------------------------------------------------------------------------------'
/*/
Static Function aColsBlank(cAlias,aArray,nUsado)
	Local cCampos := "Z1_FILIAL,Z1_NUM,Z1_RATEIO"

	If !Empty(cCampos)
		aArray := {}
		aAdd(aArray,Array(nUsado+1))
		nUsado := 0
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek(cAlias1)
		While !Eof() .And. SX3->X3_ARQUIVO == cAlias1
			If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And.;
			!(Trim(SX3->X3_CAMPO) $ cCampos)
				nUsado++
				aArray[1][nUsado] := CriaVar(Trim(SX3->X3_CAMPO),.T.)
			Endif
			dbSkip()
		Enddo
		aArray[1][nUsado+1] := .F.
	Endif

Return

/*/
.-----------------------------------------------------------------------------------------------------------------------.
¦     Função     ¦     CriaHeader     ¦     Autor     ¦     Wagner da Gama Correa     ¦     Data     ¦     18/11/2010     ¦                                         |
|-------------------------------------------------------------------------------------------------------------------------|
¦     Descriçäo  ¦     Cria a variavel vetor aHeader                                  ¦                                   |
'-----------------------------------------------------------------------------------------------------------------------'
/*/
Static Function CriaHeader()
	Local cCampos := "Z1_FILIAL,Z1_NUM,Z1_RATEIO"
	nUsado  := 0
	aHeader := {}

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias1)
	While ( !Eof() .And. SX3->X3_ARQUIVO == cAlias1 )
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. !(Trim(X3_CAMPO) $ cCampos) )

			aAdd(aHeader,{ Trim(X3Titulo()), ;
			SX3->X3_CAMPO   , ;
			SX3->X3_PICTURE , ;
			SX3->X3_TAMANHO , ;
			SX3->X3_DECIMAL , ;
			SX3->X3_VALID   , ;
			SX3->X3_USADO   , ;
			SX3->X3_TIPO    , ;
			SX3->X3_ARQUIVO , ;
			SX3->X3_CONTEXT } )
			nUsado++

		Endif
		dbSkip()
	End

Return
/*/
.-----------------------------------------------------------------------------------------------------------------------.
|     Função     |     Desmonta     |     Autor      |     Wagner da Gama Correa                                          |
|-------------------------------------------------------------------------------------------------------------------------|
|     Descriçäo  |     Efetua a desmontagem automática do produto                                                         |
'-----------------------------------------------------------------------------------------------------------------------'
/*/

Static Function Desmonta( _cOpcao )

	Private lMsErroAuto := .F.

	_cArea := GetArea()

	aAutoCab := {  {"cProduto",   SZ0->Z0_COD                                                , Nil},;
	{"cLocOrig",   SZ0->Z0_Local,												Nil},;
	{"nQtdOrig",   (SZ0->Z0_PESO * 1000) - SZ0->Z0_REFILO                      , Nil},;
	{"nQtdOrigSe", ConvUM( SZ0->Z0_COD, SZ0->Z0_PESO - SZ0->Z0_REFILO,, 2)     , Nil},;
	{"cDocumento", "C" + Right(AllTrim(SZ0->Z0_NUM),8)                         , Nil},;
	{"cNumLote",   CriaVar("D3_NUMLOTE")                                       , Nil},;
	{"cLoteDigi",  CriaVar("D3_LOTECTL")                                       , Nil},;
	{"dDtValid",   CriaVar("D3_DTVALID")                                       , Nil},;
	{"nPotencia",  CriaVar("D3_POTENCI")                                       , Nil},;
	{"cLocaliza",  CriaVar("D3_LOCALIZ")                                       , Nil},;
	{"cNumSerie",  CriaVar("D3_NUMSERI")                                       , Nil}}

	dbSelectArea("SZ1")
	dbSetOrder(1)
	dbSeek( xFilial("SZ1") + SZ0->Z0_NUM, .T.)

	aAutoItens := {}

	While !Eof() .and. SZ0->Z0_NUM = SZ1->Z1_NUM

		aAdd( aAutoItens, { {"D3_COD",     SZ1->Z1_CODSLIT                                                , Nil}, ;
		{"D3_LOCAL",   SZ1->Z1_Local, 													Nil}, ;
		{"D3_QUANT",   SZ1->Z1_TPESO * 1000                                            , Nil}, ;
		{"D3_QTSEGUM", ConvUM(SZ1->Z1_TPESO, SZ1->Z1_TPESO * 1000,, 2)                 , Nil}, ;
		{"D3_RATEIO" , SZ1->Z1_RATEIO                                                  , Nil} })

		dbSelectArea("SZ1")
		dbSkip()
	End

	If _cOpcao == "I"
		MSExecAuto({|v,x,y,z| Mata242(v,x,y,z)},aAutoCab,aAutoItens,3,.T.)

		If lMsErroAuto
			Mostraerro()
		EndIf

	Else
		Private lMsErroAuto := .F.
		dbSelectArea('SD3')	              
		SD3->(dbSetOrder(2))
		iF SD3->(dbSeek( xFilial('SD3') + "C"+Right(AllTrim(SZ0->Z0_NUM),8) + SZ0->Z0_COD ))
			MSExecAuto({|v,x,y,z| Mata242(v,x,y,z)},aAutoCab,aAutoItens,5,.T.)

			If lMsErroAuto
				Mostraerro()
			EndIf
		Else
			alert('ERRO')
		EndIF
	EndIf

	RestArea( _cArea )
Return
/*/
.-----------------------------------------------------------------------------------------------------------------------.
|     Função     |     Sucata     |     Autor      |     Wagner da Gama Correa                                            |
|-------------------------------------------------------------------------------------------------------------------------|
|     Descriçäo  |     Efetua a desmontagem automática do produto                                                         |
'-----------------------------------------------------------------------------------------------------------------------'
/*/
Static Function Sucata( _cOpcao)

	Private lMsErroAuto := .F.

	_cArea := GetArea()

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial()+SZ0->Z0_COD))

	//Cabecalho a Incluir
	aAuto := {}
	aAdd( aAuto , { "S"+Right(AllTrim(SZ0->Z0_NUM),8), dDataBase})  //Cabecalho

	//Itens a Incluir
	aItem := {}
	aAdd( aItem, SZ0->Z0_COD         ) // D3_COD
	aAdd( aItem, SB1->B1_DESC        ) // D3_DESCRI
	aAdd( aItem, SB1->B1_UM          ) // D3_UM
	aAdd( aItem, SZ0->Z0_Local       ) // D3_LOCAL
	aAdd( aItem, ""                  ) // D3_LOCALIZ

	//aAdd( aItem, SZ0->Z0_COD         ) // D3_COD
	//dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial()+GetMv("MV_XCODSUC")))


	aAdd( aItem, SB1->B1_COD         ) // D3_COD
	aAdd( aItem, SB1->B1_DESC        ) // D3_DESCRI
	aAdd( aItem, SB1->B1_UM          ) // D3_UM
	aAdd( aItem, GetMv("MV_XSUCATA") ) // D3_LOCAL
	aAdd( aItem, ""                  ) // D3_LOCALIZ
	aAdd( aItem, ""                  ) // D3_NUMSERI
	aAdd( aItem, ""                  ) // D3_LOTECTL
	aAdd( aItem, ""                  ) // D3_NUMLOTE
	aAdd( aItem, Ctod("")            ) // D3_DTVALID (Lote)
	aAdd( aItem, 0                   ) // D3_POTENCI
	aAdd( aItem, SZ0->Z0_REFILO      ) // D3_QUANT
	aAdd( aItem, 0                   ) // D3_QTSEGUM
	aAdd( aItem, ""                  ) // D3_ESTORNO
	aAdd( aItem, ""                  ) // D3_NUMSEQ
	aAdd( aItem, ""                  ) // D3_LOTECTL
	aAdd( aItem, Ctod("")            ) // D3_DTVALID (Lote)
	aAdd( aItem, ""                  ) // D3_ITEMGRD
	
	aAdd(aAuto,aItem)
	
    alert(_cOpcao)
    alert(SZ0->Z0_REFILO )
    alert('Hey Sucata')
	If _cOpcao == "I" .and. SZ0->Z0_REFILO <> 0
		MSExecAuto({|x,y| MATA261(x,y)},aAuto, 3)

		If lMsErroAuto
			Mostraerro()
		EndIf

	ElseIf _cOpcao == "E" .And. SZ0->Z0_REFILO <> 0
		_xFil   := FwCodFil()
		_xEmp   := FwCodEmp()
		_aArea  := getArea()

		//RPCClearEnv()
		//RpcSetType(3)
		//RpcSetEnv(_xEmp , _xFil)
		dbSelectArea('SD3')	              
		SD3->(dbSetOrder(2))
		iF SD3->(dbSeek( xFilial('SD3') + "S"+Right(AllTrim(SZ0->Z0_NUM),8) + SZ0->Z0_COD ))

			aAuto := {}
			MSExecAuto({|x,y| mata261(x,y)},aAuto,6)          
			//PUBLIC cFilial := SD3->D3_FILIAL
			//MSExecAuto({|x,y| MATA261(x,y)},aAuto, 5) 

			//MSExecAuto({|x,y| MATA261(x,y)},aAuto, 6)
			/*
			Private lMA261Cpo  := (ExistBlock('MA261CPO')) //-- Ponto de entrada para adicionar campos no aHeader
			Private lMA261Exc  := (ExistBlock('MA261EXC')) //-- Ponto de entrada na gravacao do estorno
			Private lMA261Est  := (ExistBlock('MA261EST')) //-- Ponto de entrada para verificar se estorno eh possivel
			Private lAutoMa261 := .T.
			private cCusMed    := GetMV('MV_CUSMED')
			Private nTotal     := 0
			Private nHdlPrv    := 0
			Private cLoteEst   := ''
			Private cArquivo   := ''
			Private lCriaHeade := .T.
			Private aRegSD3    := {}
			Private aMemos     := {}  
			Private NFCICALC   := 0
			a261Estorn("SD3",SD3->(Recno()), 6)
			*/
			If lMsErroAuto
				Mostraerro()
			EndIf
		EndIf

		restArea( _aArea )
	EndIf        

	RestArea( _cArea )
Return


Static Function FMata650(aDadosOP,nOpc)
	Local aMata650 := {}
	Private lMsErroAuto := .F.  

	AAdd(aMata650,{"C2_FILIAL" 	, aDadosOP[01] ,Nil})
	AAdd(aMata650,{"C2_NUM"     , aDadosOP[02] ,Nil})
	AAdd(aMata650,{"C2_ITEM"    , aDadosOP[03] ,Nil})
	AAdd(aMata650,{"C2_SEQUEN" 	, aDadosOP[04] ,Nil})
	AAdd(aMata650,{"C2_PRODUTO" , aDadosOP[05] ,Nil})
	AAdd(aMata650,{"C2_UM"      , aDadosOP[06] ,Nil})
	AAdd(aMata650,{"C2_LOCAL"   , aDadosOP[07] ,Nil})

	if nOpc != 05
		AAdd(aMata650,{"C2_QUANT"   , aDadosOP[08] ,Nil})
		AAdd(aMata650,{"C2_XCORTE"  , aDadosOP[09] ,Nil})
		AAdd(aMata650,{"C2_XLINHA"  , aDadosOP[10] ,Nil})
		AAdd(aMata650,{"C2_RECURSO" , aDadosOP[10] ,Nil})
		AAdd(aMata650,{"C2_STATUS"  , "N"          ,Nil})
		AAdd(aMata650,{"C2_DATPRI" 	, dDataBase    ,Nil})
		AAdd(aMata650,{"C2_DATPRF" 	, dDataBase    ,Nil})
		AAdd(aMata650,{"C2_EMISSAO" , dDataBase    ,Nil})
		AAdd(aMata650,{"C2_TPOP"    , "F"          ,Nil})
		AAdd(aMata650,{"AUTEXPLODE" , "N"          ,Nil})	
	EndIf

	MSExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)

	If lMsErroAuto
		MostraErro()
		DisarmTransaction()  
	EndIf
Return lMsErroAuto

Static Function FMata380(aDadosOP,nOpc)

	Local aVetor := {}
	Local aEmpen := {}

	Private lMsErroAuto := .F.

	aVetor:={   {"D4_COD"     ,M->Z0_COD		  ,Nil},; //COM O TAMANHO EXATO DO CAMPO
	{"D4_LOCAL"   ,aDadosOp[7]        ,Nil},;
	{"D4_OP"      ,aDadosOp[2] + aDadosOp[3] + aDadosOp[4]  ,Nil},;
	{"D4_DATA"    ,dDatabase          ,Nil},;
	{"D4_QTDEORI" ,aDadosOp[8]        ,Nil},;
	{"D4_QUANT"   ,aDadosOp[8]        ,Nil},;
	{"D4_TRT"     ,"   "              ,Nil},;
	{"D4_QTSEGUM" ,0                  ,Nil}}

	AADD(aEmpen,{aDadosOp[8]	,;   // SD4->D4_QUANT
	PadR(aDadosOp[10],TamSX3("DC_LOCALIZ")[1]),;  // DC_LOCALIZ
	""		,;  // DC_NUMSERI
	0       	,;  // D4_QTSEGUM
	.F.}) 

	MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,nOpc,aEmpen) 

	If lMsErroAuto
		MostraErro()
		DisarmTransaction() 
	EndIf

Return lMsErroAuto

Static Function EstT01Leg(nLeg,cOp)
	Local aArea   := GetArea()
	Local lRet 		  := .F.
	Local cAliasTemp  := ""
	Local cQuery 	  := ""
	Local nRegSD3	  := 0						//Contador da tabela SD3
	Local nRegSH6	  := 0                      //Contador da tabela SH6
	Local dEmissao	  := dDatabase

	dbSelectArea("SC2")
	dbOrderNickName("CALCCORTE")

	If dbSeek(xFilial("SC2") + cOp)
		If nLeg == 2 .Or. nLeg == 3 .Or. nLeg == 4
			#IFDEF TOP
			cAliasTemp:= "SD3TMP"
			cQuery	  := "  SELECT COUNT(*) AS RegSD3, MAX(D3_EMISSAO) AS EMISSAO "
			cQuery	  += "   FROM " + RetSqlName('SD3')
			cQuery	  += "   WHERE D3_FILIAL   = '" + xFilial('SD3')+ "'"
			cQuery	  += "     AND D3_OP 	   = '" + SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) + "'"
			cQuery	  += "     AND D3_ESTORNO <> 'S' "
			cQuery	  += "     AND D_E_L_E_T_  = ' '"
			cQuery    += " 	   GROUP BY D3_EMISSAO "
			cQuery    := ChangeQuery(cQuery)
			dbUseArea (.T., "TOPCONN", TCGENQRY(,,cQuery), cAliasTemp, .F., .T.)

			If !SD3TMP->(Eof())
				dEmissao := STOD(SD3TMP->EMISSAO)
				nRegSD3 := SD3TMP->RegSD3
			EndIf

			cAliasTemp:= "SH6TMP"
			cQuery	  := "  SELECT COUNT(*) AS RegSH6 "
			cQuery	  += "   FROM " + RetSqlName('SH6')
			cQuery	  += "   WHERE H6_FILIAL   = '" + xFilial('SH6')+ "'"
			cQuery	  += "     AND H6_OP 	   = '" + SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) + "'"
			cQuery	  += "     AND D_E_L_E_T_  = ' '"
			cQuery    := ChangeQuery(cQuery)
			dbUseArea ( .T., "TOPCONN", TCGENQRY(,,cQuery), cAliasTemp, .F., .T.)

			If !SH6TMP->(Eof())
				nRegSH6 := SH6TMP->RegSH6
			EndIf
			#ELSE
			SD3->(DbSetOrder(1))
			If SD3->(MsSeek(xFilial('SD3')+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)))
				dEmissao := STOD(DTOS(SD3->D3_EMISSAO))
				While !SD3->(Eof()) .And. SD3->(D3_FILIAL+D3_OP) == xFilial("SD3")+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
					If SD3->D3_EMISSAO > dEmissao
						dEmissao := STOD(DTOS(SD3->D3_EMISSAO))
					EndIf
					SD3->(DbSkip())
					nRegSD3 := nRegSD3 + 1
				EndDo
			EndIf

			SH6->(DbSetOrder(1))
			If SH6->(MsSeek(xFilial('SH6')+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)))
				nRegSH6 := 1
			EndIf
			#ENDIF
		EndIf


		Do Case
			Case nLeg == 1
			lRet := SC2->C2_TPOP == "P" //Prevista
			Case nLeg == 2
			lRet := SC2->C2_TPOP == "F" .And. Empty(SC2->C2_DATRF) .And. (nRegSD3 < 1 .And. nRegSH6 < 1) .And. (Max(dDataBase - SC2->C2_DATPRI,0) < If(SC2->C2_DIASOCI==0,1,SC2->C2_DIASOCI)) //Em aberto
			Case nLeg == 3
			lRet := SC2->C2_TPOP == "F" .And. Empty(SC2->C2_DATRF) .And. (nRegSD3 > 0 .Or. nRegSH6 > 0) .And. (Max((ddatabase - dEmissao),0) > If(SC2->C2_DIASOCI >= 0,-1,SC2->C2_DIASOCI)) //Iniciada
			Case nLeg == 4
			lRet := SC2->C2_TPOP == "F" .And. Empty(SC2->C2_DATRF) .And. (Max((ddatabase - dEmissao),0) > SC2->C2_DIASOCI .Or. Max((ddatabase - SC2->C2_DATPRI),0) > SC2->C2_DIASOCI)   //Ociosa
			Case nLeg == 5
			lRet := SC2->C2_TPOP == "F" .And. !Empty(SC2->C2_DATRF) .And. SC2->(C2_QUJE < C2_QUANT)  //Enc.Parcialmente
			Case nLeg == 6
			lRet := SC2->C2_TPOP == "F" .And. !Empty(SC2->C2_DATRF) .And. SC2->(C2_QUJE >= C2_QUANT) //Enc.Totalmente
		EndCase

		#IFDEF TOP
		If nLeg == 2 .Or. nLeg == 3 .Or. nLeg == 4
			SD3TMP->(DbCloseArea())
			SH6TMP->(DbCloseArea())
		EndIf
		#ENDIF
	Else
		lRet := .F.	
	EndIf	
	RestArea(aArea)
Return lRet


Static Function _getRecurso()


	Local  oDlg
	Private _xdRecurso := Space(25)
	//Prepare Environment Empresa '01' Filial '01' tables 'SH1'

	oDlg := TDialog():New(00,00,150,210,'Recurso',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	oDlg:lEscClose := .F.
	odRecurso := TGet():New( 02,02,{|u| if( Pcount( )>0, _xdRecurso := u, _xdRecurso) },oDlg,096,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,_xdRecurso,,,,,,,"Selecione o Recurso a ser alocado na OP",1)
	odRecurso:cF3 := "SH1"

	SButton():New(22,002,01,{|| oDlg:End() },oDlg,.T.,,)    
	oDlg:Activate(,,,.T.,{|| Valid(_xdRecurso) },, )

Return _xdRecurso

Static Function Valid()
	Local lRet := .T.

	If Empty(_xdRecurso)
		lRet := Aviso('Atenção','Deseja realmente deixar o recurso em branco?',{'Sim','Não'} ) == 01
	Else
		SH1->(dbSetOrder(1))
		lRet := SH1->(dbSeek(xFilial('SH1') + _xdRecurso))
		If !lRet
			Aviso('Atenção','Recurso informado não encontrado, informe um válido !',{'ok'} )
		Else
			lRet := u_MTA650A1(_xdRecurso,"N","",M->Z0_NUM)
		EndIf      
	EndIf

Return lRet

Static Function getNumOP(xdCalcCorte,xdFilial)
	Default xdCalcCorte := ""
	_xdOp := ""
	_xQry := ""
	_xQry += " Select * From " + RetSqlName("SC2") + " C2 "
	_xQry += "  Where C2.D_E_L_E_T_ = ' ' "
	_xQry += "  And C2_XCORTE = '" + xdCalcCorte + "'"
	_xQry += "  And C2_FILIAL = '" + xdFilial + "'"

	_xdTbl := MpSysOpenQuery(_xQry)

	If !(_xdTbl)->(Eof())
		_xdOp := (_xdTbl)->C2_NUM+(_xdTbl)->C2_ITEM+(_xdTbl)->C2_SEQUEN
	EndIf

Return _xdOp
