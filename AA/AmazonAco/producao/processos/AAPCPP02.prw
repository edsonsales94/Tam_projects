#Include "protheus.ch"
#Include "rwmake.ch"
#include "apvt100.ch"

/*/{Protheus.doc}AAPCPP02
@description
Rotina de apontamento de produção, integrada com a balança Toledo

@author	Bruno Garcia
@since		10/11/2015
@version	P11 R8

@param 		Nao possui,Nao possui,Nao possui,Nao possui
@return	Nao possui,Nao possui,Nao possui,Nao possui
/*/
Static __nRecSD3 := 0

User Function AAPCPP02()
	Local nOpcA := 0
	Local lContinua := .T.
	Local oFont16 := TFont():New("Arial",,-16,.F.,.T.)
	Local oFont18 := TFont():New("Arial",,-18,.F.,.T.)
	Local oFont26 := TFont():New("Arial",,-26,.F.,.T.)
	Local oFont50 := TFont():New("Arial",,-50,.T.,.T.)
	Local aSizeAut   := MsAdvSize(.T.,.F.)
	Local aCabSZ1		:= {}
	//Local lConfirm := .T.
    Local nz 
	Local nY
	
	Private cTitulo := "Apontamento de Produção"
	Private aAponta := {}
	Private cD3Tm	:= "001"
	Private cOP := Space(TamSX3("D3_OP")[1])
	Private oOP := Nil
	Private cProd := "" 
	Private oProd := Nil
	Private oProdSay := Nil
	Private cDescProd := "" 
	Private oDescProd := Nil
	Private oDescSay := Nil 
	Private nQtdOp := 0 
	Private oQtdOp := Nil
	Private oQtdSay := Nil
	Private nQtdAp := 0 
	Private oQtdAp := Nil
	Private oQtdApSay := Nil
	Private nQtdReg := CriaVar("C2_QUANT") 
	Private oQtdReg := Nil
	Private lQtdReg := .F.
	Private oBrowse := Nil
	Private oStaSay := Nil
	Private oOffOnSay := Nil
	Private oColor	:= CLR_BLUE
	Private cStatus	:= ""
	Private lProcPI	:= .F. //se executa rotina de processamento do PI

	Private aFldSZ1 := {}
	Private aLineSZ1 	:= {}
	Private aDadosOP	:= {}
	Private _nRecSC2 := 0
	Private cCorte	:= ""

	Private aCodEtqD3 := {} //controla o codigo seq da etiqueta gerado no campo D3_XCODETI
	Private aOpsOK 	:= {} //para controlar as OP's geradas no processamento de PI
	Private nPerc 	:= GetMv("MV_PERCPRM")

	aSizeAut[5]		:= 610	//Horizontal
	aSizeAut[3]		:= 307	//Largura
	aSizeAut[4]		:= 260	//Altura	
	aSizeAut[6]		:= 600 //Vertical		

	aObjects := {}  
	AAdd( aObjects, { 0,   160, .T., .F. } )
	AAdd( aObjects, { 0,   050, .T., .T. } )

	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],315,;		
	{{015,010,010,100},;	//[1] Ordem de producao [lin,col,lin,col]
	{050,010,045,110},;	//[2] [lin,col,lin,col]
	{075,010,070,110},;	//[3] [lin,col,lin,col]
	{100,010,95,110},;	//[4] [lin,col,lin,col]
	{125,010,120,110},;	//[5] [lin,col,lin,col]
	{aPosObj[2][1] + 015,015,aPosObj[2][1] + 035,015},;	//[6] [lin,col,lin,col]
	{aPosObj[2][1] + 015,220,aPosObj[2][1] + 015,250},;	//[7] [lin,col,lin,col]
	{040,010,aPosObj[1][4] - 010,aPosObj[1][3]-66}} )//[8] TwBrowser	

	// Adiciona os campos a serem exibidos na tela
	//                 Nome        Obrg Edit  F3    When
	AAdd(aFldSZ1, {"Z1_RATEIO",	.T., .F., "   ", {||}} )
	AAdd(aFldSZ1, {"Z1_CODSLIT",.T., .F., "   ", {||}} )
	AAdd(aFldSZ1, {"Z1_QUANT", 	.T., .F., "   ", {||}} )
	AAdd(aFldSZ1, {"Z1_LARG", 	.T., .F., "   ", {||}} )
	AAdd(aFldSZ1, {"Z1_TLARG", 	.T., .F., "   ", {||}} )
	AAdd(aFldSZ1, {"Z1_TPESO",	.T., .F., "   ", {||}} )
	AAdd(aFldSZ1, {"Z1_NROBAR", .T., .F., "   ", {||}} )
	AAdd(aFldSZ1, {"Z1_LOCAL",	.T., .F., "   ", {||}} )


	MontaTabelas(aFldSZ1,@aCabSZ1,@aLineSZ1)

	//+-------------------------------------------------+
	//| Monta a tela para o usuario visualizar consulta |
	//+-------------------------------------------------+
	While lContinua

		cOP := Space(TamSX3("D3_OP")[1])
		nQtdReg := 0
		nOpcA := 0
		lProcPI := .F.
		aCodEtqD3 := {}
		aOpsOK := {} 
		aAponta := {}

		DEFINE MSDIALOG oDlg TITLE cTitulo FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] PIXEL
		oDlg:nStyle := nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_VISIBLE )

		oPanelAll:= tPanel():New(aPosObj[1,1],aPosObj[1,2],"",oDlg,,,,,,aPosObj[1,3],aPosObj[1,4])
		oPanelAll:align:= CONTROL_ALIGN_ALLCLIENT

		@ aPosObj[1][1],aPosObj[1][2] TO aPosObj[1][3]-16,aPosObj[1][4] LABEL "Dados da OP" OF oPanelAll PIXEL

		@ aPosGet[1,1],aPosGet[1,2] SAY "Ordem de Produção:" OF oPanelAll SIZE 100,015 FONT oFont16 PIXEL               
		@ aPosGet[1,3],aPosGet[1,4] MSGET oOP VAR cOP FONT oFont18 PIXEL;
		F3 CpoRetF3('D3_OP');
		VALID ValidaOP(@aAponta) OF oPanelAll PIXEL SIZE 080,015	

		@ aPosGet[2,1],aPosGet[2,2] SAY oProdSay PROMPT "Produto:" OF oPanelAll SIZE 080,015 FONT oFont16 PIXEL               
		@ aPosGet[2,3],aPosGet[2,4] MSGET oProd VAR cProd FONT oFont18 PIXEL;
		When .F. ;
		OF oPanelAll PIXEL SIZE 050,015 	

		@ aPosGet[3,1],aPosGet[3,2] SAY oDescSay PROMPT   "Descrição" OF oPanelAll SIZE 080,015 FONT oFont16 PIXEL               
		@ aPosGet[3,3],aPosGet[3,4] MSGET oDescProd VAR cDescProd FONT oFont18 PIXEL;
		When .F. OF oPanelAll PIXEL SIZE 180,015	

		@ aPosGet[4,1],aPosGet[4,2] SAY oQtdSay PROMPT   "Quantidade Prevista:" OF oPanelAll SIZE 100,015 FONT oFont16 PIXEL               
		@ aPosGet[4,3],aPosGet[4,4] MSGET oQtdOp VAR nQtdOp FONT oFont18 Picture PesqPict("SC2","C2_QUANT") PIXEL;
		When .F. OF oPanelAll PIXEL SIZE 080,015	

		@ aPosGet[5,1],aPosGet[5,2] SAY oQtdApSay PROMPT   "Quantidade Apontada:" OF oPanelAll SIZE 090,015 FONT oFont16 PIXEL               
		@ aPosGet[5,3],aPosGet[5,4] MSGET oQtdAp VAR nQtdAp FONT oFont18 Picture PesqPict("SC2","C2_QUANT") PIXEL;
		When .F. OF oPanelAll PIXEL SIZE 080,015

		oBrowse := TwBrowse():New(aPosGet[8,1],aPosGet[8,2],aPosGet[8,3],aPosGet[8,4],, aCabSZ1 ,,oPanelAll,,,,,/*bDBLClick*/,,,,,,,.F.,,.T.,,.F.,,,)
		oBrowse :SetArray(aLineSZ1)
		oBrowse:bLine := {|| {;
		aLineSZ1[oBrowse:nAt,1],;
		aLineSZ1[oBrowse:nAt,2],;
		Transform(aLineSZ1[oBrowse:nAt,3],'@E 99,999,999,999,999.99'),;
		Transform(aLineSZ1[oBrowse:nAt,4],'@E 99,999,999,999,999.99'),;
		Transform(aLineSZ1[oBrowse:nAt,5],'@E 99,999,999,999,999.99'),;
		Transform(aLineSZ1[oBrowse:nAt,6],'@E 99,999,999,999,999.99'),;
		Transform(aLineSZ1[oBrowse:nAt,7],'@E 99,999,999,999,999.99'),;
		aLineSZ1[oBrowse:nAt,7]} }

		@ aPosObj[2][1],aPosObj[2][2] TO aPosObj[2][3],aPosObj[2][4] LABEL "Informações da Balança" OF oPanelAll PIXEL

		@ aPosGet[6,1],aPosGet[6,2] SAY   "Quantidade Registrada:" OF oPanelAll SIZE 150,020 FONT oFont26 PIXEL               
		@ aPosGet[6,3],aPosGet[6,4] MSGET oQtdReg VAR nQtdReg FONT oFont50 Picture PesqPict("SC2","C2_QUANT") PIXEL;
		When lQtdReg VALID VldQtd(@aAponta) OF oPanelAll PIXEL SIZE 150,025

		@ aPosGet[7,1],aPosGet[7,2] SAY oStaSay PROMPT "Status: " OF oPanelAll SIZE 50,020 FONT oFont16 PIXEL
		@ aPosGet[7,3],aPosGet[7,4] SAY oOffOnSay PROMPT cStatus OF oPanelAll SIZE 50,020 FONT oFont16 COLOR oColor PIXEL

		//oculta objetos 
		AtulizaObj({"oProdSay","oDescSay","oQtdSay","oQtdApSay","oStaSay",;
		"oProd","oDescProd","oQtdOp","oQtdAp","oBrowse","oOffOnSay"},.F.)

		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpcA := IIf(VldAponta(),1,0), IIf(nOpcA == 1,oDlg:End(),)}, {|| lContinua := .F.,oDlg:End()} )

		If nOpcA == 1
			//Begin Transaction
			BeginTran() 
			If lProcPI
				Processa( {|| ProcessPI() }, "Aguarde...", "Gerando apontamento...",.F.)
			Else
				//FMata250(aAponta,.T.)
				//FwAlertInfo("OK")
				Processa( {|| FMata250(aAponta,.T.) }, "Aguarde...", "Gerando apontamento...",.F.)

			EndIf	
			//End Transaction
			EndTran()
			MsUnlockAll()

			//Gera as etiquetas
			Begin Transaction
				If Len(aCodEtqD3) > 0
					dbSelectArea("SD3")
					If dbOrderNickName("SEQETIQ")  //Se encontra a ordem 

						For nY := 1 To Len(aCodEtqD3)
							dbSelectArea("SD3")
							dbOrderNickName("SEQETIQ")
							If dbSeek(xFilial("SD3") + aCodEtqD3[nY])

								//Pesquisa o reristro PR0
								While !SD3->(Eof()) .And. xFilial("SD3") + aCodEtqD3[nY] == SD3->(D3_FILIAL+Alltrim(D3_XCODETI)) // Ajustado com Alltrim() Anizio Cunha 04/03/2024
									If SD3->D3_CF == "PR0"

										//Se for apontamento de PI 
										If lProcPI
											//Gera as etiquetas de acordo com os itens do calculo de corte
											For nZ := 1 To aOpsOK[nY][2]

												//CTXT := "[COD:" + SD3->D3_COD + "]"
												//CTXT += " [NUMSEQ: " + SD3->D3_NUMSEQ + "] "

												//memowrite('teste01.txt',CTXT) 
												aDadosEti := {SD3->D3_QUANT / aOpsOK[nY][2], Nil,Nil,1/*aOpsOK[nY][2]*/,Nil,Nil,Nil,Nil,SD3->D3_LOCAL,SD3->D3_OP,SD3->D3_NUMSEQ,SD3->D3_LOTECTL,Nil,SD3->D3_DTVALID,Nil,;
												Nil,Nil,Nil,"SD3",Nil,Nil,Nil}
												ImpEtiq(aDadosEti,SD3->D3_COD)  		
											Next nZ	  										
										Else
											//TXT := "[COD:" + SD3->D3_COD + "]"
											//CTXT += " [NUMSEQ: " + SD3->D3_NUMSEQ + "] "

											//memowrite('teste01.txt',CTXT) 

											aDadosEti := {SD3->D3_QUANT, Nil,Nil,1,Nil,Nil,Nil,Nil,SD3->D3_LOCAL,SD3->D3_OP,SD3->D3_NUMSEQ,SD3->D3_LOTECTL,Nil,SD3->D3_DTVALID,Nil,;
											Nil,Nil,Nil,"SD3",Nil,Nil,Nil}

											ImpEtiq(aDadosEti,SD3->D3_COD)	  	
										EndIf		  

										Exit
									EndIf

									SD3->(dbSkip())
								EndDo
							Else
								Aviso(cTitulo,"Erro: Não foi possível localizar etiqueta de produção, (SD3-"+aCodEtqD3[nY]+")!" + Chr(10) + Chr(13) +;
								"Solução: Realize o estorno deste apontamento!",{"OK"})
								Exit
							EndIf    		
						Next nY
					Else
						Aviso(cTitulo,"Não foi possível setar o indice de pesquisa do codigo da etiqueta, (SD3-SEQETIQ) !",{"OK"})
					EndIf 
					SD3->(dbCloseArea())
				Else
					Aviso(cTitulo,"Erro na impressão da(s) etiqueta(s), realize o estorno da produção!, SEQETIQ !",{"OK"})
				EndIf
			End Transaction
		EndIf
	EndDo
Return

Static Function MontaTabelas(aCampos,aHeader,aItens)
	Local nX

	If Len(aItens) > 0
		aDel(aItens,Len(aItens))
		aSize(aItens,0)
	Endif

	AAdd( aItens , {} )

	aHeader := {}

	SX3->(dbSetOrder(2))
	For nX:=1 To Len(aCampos)
		If SX3->(dbSeek(aCampos[nX,1]))
			AAdd( aHeader , Trim(X3Titulo()) )
			AAdd( aItens[Len(aItens)] , CriaVar(aCampos[nX,1]) )
		Endif
	Next
Return

Static Function AtulizaObj(aObjects,lVisible)
	Local nX := 0

	For nX := 1 To Len(aObjects)
		If lVisible
			&(aObjects[nX]):Show()	
		Else
			&(aObjects[nX]):Hide()
		EndIf 
	Next nX

Return 

Static Function ValidaOP(aAponta)
	Local lRet := .T.
	Local cFilSZ1 := ""
	Local aItens := {}
	Local nX := 0
	Local nQtdAglu := 0

	SC2->(DbSetOrder(1)) //C2_FILIAL + C2_NUM
	SB1->(DbSetOrder(1))  //B1_FILIAL + B1_COD

	//oculta objetos, para garantir a consulta de outra OP quando for PA ou PI 
	AtulizaObj({"oProdSay","oDescSay","oQtdSay","oQtdApSay","oStaSay",;
	"oProd","oDescProd","oQtdOp","oQtdAp","oOffOnSay","oBrowse"},.F.)
	lQtdReg := .F.
	nQtdReg := CriaVar("C2_QUANT")
	oQtdReg:Refresh()
	lProcPI := .F.

	If SC2->(dbSeek(xFilial("SC2") + cOp))
		SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))

		If Empty(SB1->B1_RASTRO) .Or. Empty(SB1->B1_LOCALIZ)
			Alert("O produto informado na OP, não possui controle de lote ou endereço!")
			Return .F.
		EndIf

		cProd := SB1->B1_COD
		cDescProd := SB1->B1_DESC
		nQtdOp := SC2->C2_QUANT
		nQtdAp := SC2->C2_QUJE

		//Verifica se a OP possui foi gerado pela rotina de calculo de corte
		If Empty(SC2->C2_XCORTE)

			If MsgBox(" Há integração com a balança?","Integração com a balança","YESNO")
				MsgRun("Verificando a conexão com a balança..., Aguarde...",,{|| fCaptura(@nQtdReg)})
			EndIf	

			AtulizaObj({"oProdSay","oDescSay","oQtdSay","oQtdApSay","oStaSay",;
			"oProd","oDescProd","oQtdOp","oQtdAp","oOffOnSay"},.T.)

			//Preenche o vetor para realizar o apontamento do PA
			aAponta := {cD3Tm,;
			SC2->(C2_NUM + C2_ITEM + C2_SEQUEN),;
			SC2->C2_PRODUTO,;
			nQtdReg,;
			"PR0",;
			SC2->C2_LOCAL,;
			PADR(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN),Len(SD3->D3_DOC)),;
			dDataBase}	

			If nQtdReg == 0 
				//Habilita o campo da quantidade
				lQtdReg := .T.
			EndIf	 				
		Else
			lProcPI	:= .T.
			//Exibi o Browse
			AtulizaObj({"oBrowse"},.T.)

			//Habilita o campo da quantidade
			lQtdReg := .T.

			//Preenche o TwBrowser com os itens do calculo de corte
			If Len(aLineSZ1) > 0
				aDel(aLineSZ1,Len(aLineSZ1))
				aSize(aLineSZ1,0)
			Endif		

			cFilSZ1 := xFilial("SZ1") 
			aDadosOP := {} 
			SZ1->(dbSetOrder(1))
			SB1->(dbSetOrder(1))

			If SZ1->(dbSeek(xFilial("SZ1") + SC2->C2_XCORTE))
				While SZ1->(!EOF()) .And. SZ1->(Z1_FILIAL + Z1_NUM) == (cFilSZ1 + SC2->C2_XCORTE)  
					AAdd(aLineSZ1 , {})
					For nX:=1 To Len(aFldSZ1)
						AAdd( aLineSZ1[Len(aLineSZ1)] , SZ1->&(aFldSZ1[nX,1]) )
					Next
					AAdd(aLineSZ1[Len(aLineSZ1)] , SZ1->(Recno()))				


					//Pesquisa dados do produto
					SB1->(dbSeek(xFilial("SB1") + SZ1->Z1_CODSLIT))

					//Preenche o vetor para gerar as OP's "Filhas" do calculo de corte
					AAdd(aItens,{SZ1->Z1_FILIAL	,;
					SZ1->Z1_NUM	,;
					SZ1->Z1_CODSLIT,;
					SB1->B1_UM     ,;
					SZ1->Z1_RATEIO ,;
					SZ1->Z1_LOCAL  ,;
					SZ1->Z1_QUANT  ,;
					SC2->C2_RECURSO })
					SZ1->(dbSkip())				
				EndDo
			Else
				FExibiMsg("Não foi localizado o calculo de corte (SZ1)!")
				Return .F.
			EndIf

			//Ordena os dados por produto		
			ASORT(aItens, , , {|x,y| x[3] > y[3]})

			//Aglutina os itens por produto e % de rateio
			nX := 1
			nQtdAglu := 0
			While nX <= Len(aItens)  
				cProd := aItens[nX][3]
				While nX <= Len(aItens) .And. cProd == aItens[nX][3]
					nQtdAglu += aItens[nX][5]
					nX++
				EndDo
				AAdd(aDadosOp,{aItens[nX-1][1],;
				aItens[nX-1][2],;
				aItens[nX-1][3],;
				aItens[nX-1][4],;
				nQtdAglu,; 
				aItens[nX-1][6],;
				aItens[nX-1][7],;
				aItens[nX-1][8]} )
				nQtdAglu := 0					  
			EndDo
			oBrowse:Refresh()
		EndIf

		//Guarda o Recno da OP "Mae", para atualiza o campo C2_QUJE
		_nRecSC2 := SC2->(Recno())	
		cCorte := SC2->C2_XCORTE

	Else
		FExibiMsg("Ordem de produção não localizada!")
		lRet := .F. 

		cOP := Space(TamSX3("D3_OP")[1])
		oOP:Refresh()
	EndIf
Return lRet

Static Function VldQtd(aAponta)
	Local lRet := .T.

	If	nQtdReg = 0
		FExibiMsg("Inválido!" + Chr(10) + Chr(13) + "Informe a quantidade da produção!")
		lRet := .F.
	Else
		If !lProcPI
			If Len(aAponta) > 0 
				aAponta[4] := nQtdReg
			Else
				FExibiMsg("Inválido!" + Chr(10) + Chr(13) + "Não foi possível atualizar informações da produção!")
				lRet := .F.
			EndIf
		EndIf	  	
	EndIf 
Return lRet

Static Function VldAponta(lConfirm)
	Local lRet := .T.

	If Empty(cOP)
		FExibiMsg("Informe o numero da OP!")
		lRet := .F.
	EndIf

	If lRet .And. nQtdReg = 0
		FExibiMsg("Inválido!" + Chr(10) + Chr(13) + "Informe a quantidade da produção!")
		lRet := .F.
	EndIf
	lConfirm := lRet
Return lRet

Static Function fCaptura(nQtdReg)
	//Local cCfg := "COM2:4800,N,7,1"
	Local cT := ""
	Local nLoop := 5000
	//Local nPosVal := 0
	Local cPeso := ""
	Private nHdll := 0

	// Abre a porta serial conforme configuração do parâmetro.
	// A velocidade de 4800 foi a que eu consegui a melhor leitura,
	// embora a configuração da máquina estivesse a 9600.
	//nHandle := LoadLibrary("SERIAL.DLL") 

	
	//MsOpenPort(nHdll,"COM2:4800,n,7,1")  //Abertura da porta de comunicação com Impressora de Codigo de Barras. 

	// Executa a leitura em um loop para determinar a estabilidade do peso.
	Do While nLoop > 0
		msRead(nHdll,@cT)

		If Len(cT) >= 18
			cPeso := SubStr(cT,At(" 0",cT) +1 ,6)
			nQtdReg := Val(cPeso)
			If nQtdReg > 0  
				exit
			EndIf	
			cT := ""
		EndIf

		nLoop--
	EndDo

	//Fecha a porta serial
	MsClosePort(nHdll)     // COMENTADO EM 28/06/2019 POR WLAD

	cStatus := IIf(nQtdReg > 0,"On-Line","Off-Line")
	oColor	 := IIf(nQtdReg > 0,CLR_GREEN,CLR_RED)
	oOffOnSay:Refresh() 
Return

Static Function ProcessPI()
	Local lRollBack	:= .F.
	Local nX := 0
	//Local aDadosEti := {}
	Local cProdEmp := ""

	SZ0->(dbSetOrder(1))
	If SZ0->(dbSeek(xFilial("SZ0") + cCorte))
		cProdEmp := SZ0->Z0_COD
	Else
		Alert("O produto do calculo de corte, não foi localizado!")
		Return		
	EndIf	

	ProcRegua(0)

	//Atualiza a quantidade, com o calculo do % de rateio e qtd registrada
	For nX := 1 To Len(aDadosOP)
		aDadosOP[nX][5] := (ROUND((((nQtdReg * aDadosOP[nX][5]) / 100) / aDadosOP[nX][7]),0)) * aDadosOP[nX][7]
	Next nX

	//Gera as OP's do calculo de corte
	For nX := 1 To Len(aDadosOP)
		lRollBack := FMata650(aDadosOP[nX],@aOpsOK,3) // Inclusao

		If lRollBack
			Alert("Foram encontrados erros no processamento da OP's, a operaçao de ROLLBACK foi realizada!")
			Return
		EndIf

		//Gera o empenho base para a meteria prima
		lRollBack := FMata380({cProdEmp,; //D4_COD - Codigo
		"03",; //D4_LOCAL - Local
		aOpsOK[Len(aOpsOK)][1],;  //D4_OP  - Codigo da OP
		dDataBase,; // D4_DATA
		aDadosOP[nX][5],; // D4_QTDEORI
		aDadosOP[nX][5],; // D4_QUANT
		aDadosOP[nX][8]},3) //DC_LOCALIZ
		If lRollBack
			Alert("Foram encontrados erros no processamento da OP's, a operaçao de ROLLBACK foi realizada!")
			Return
		EndIf

		// inicio alteracao Wermeson 16/01 
		SD4->(dbSetOrder(2))

		If !( SD4->(dbSeek(xFilial("SD4") + aOpsOK[Len(aOpsOK)][1] )) )	
			Reclock("SD4",.T.)
			SD4->D4_FILIAL  := xFilial("SD4")
			SD4->D4_COD     := cProdEmp
			SD4->D4_LOCAL   := "03"
			SD4->D4_OP      := aOpsOK[Len(aOpsOK)][1]
			SD4->D4_DATA    := dDataBase
			SD4->D4_QTDEORI := aDadosOP[nX][5]
			SD4->D4_QUANT   := aDadosOP[nX][5]
			SD4->D4_TRT     := "   "       
			//D4_QTSEGUM  := 0
			SD4->( msUnlock())   


			Reclock("SDC", .T.)
			SDC->DC_FILIAL  := xFilial("SDC")
			SDC->DC_ORIGEM  := "SD3" 
			SDC->DC_PRODUTO := cProdEmp
			SDC->DC_LOCAL   := "03"
			SDC->DC_LOCALIZ := aDadosOP[nX][8]
			SDC->DC_QUANT	:= aDadosOP[nX][5]
			SDC->DC_OP  	:= aOpsOK[Len(aOpsOK)][1]
			SDC->DC_TRT   	:= "   "  
			SDC->DC_QTDORIG := aDadosOP[nX][5] 
			//SDC->DC_QTSEGUM	:= TMP1->D4_QTSEGUM 
			SDC->( MsUnlock())       
		Endif

		// fim alteracao wermeson 	
	Next nX

	//Realiza os apontamentos da OP's geradas
	SC2->(DbSetOrder(1)) //C2_FILIAL + C2_NUM
	For nX := 1 To Len(aOpsOK)

		If SC2->(dbSeek(xFilial("SC2") + aOpsOK[nX][1]))	
			//Preenche o vetor para realizar o apontamento
			aAponta := {cD3Tm,;
			SC2->(C2_NUM + C2_ITEM + C2_SEQUEN),;
			SC2->C2_PRODUTO,;
			SC2->C2_QUANT,;
			"PR0",;
			SC2->C2_LOCAL,;
			PADR(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN),Len(SD3->D3_DOC)),;
			dDataBase}

			lRollBack := FMata250(aAponta,.F.)

			If lRollBack
				Alert("Foram encontrados erros no apontamento das OP's, a operaçao de ROLLBACK foi realizada!")
				Return
			EndIf

			//SD3->(dbGoTo(__nRecSD3)) 

			//AAdd(aDadosEti,{{(SD3->D3_QUANT / aOpsOK[nX][2]), Nil,Nil,aOpsOK[nX][2],Nil,Nil,Nil,Nil,SD3->D3_LOCAL,SD3->D3_OP,SD3->D3_NUMSEQ,SD3->D3_LOTECTL,Nil,SD3->D3_DTVALID,Nil,;
			//Nil,Nil,Nil,Nil,Nil,Nil,Nil},SD3->D3_COD}) 

		EndIf				
	Next nX

	/*/Imprime as etiquetas
	For nX := 1 To Len(aDadosEti)
	ImpEtiq(aDadosEti[nX][1],aDadosEti[nX][2])
	Next nX*/

	//Atualiza o saldo da OP princial
	SC2->(dbGoTo(_nRecSC2))
	RecLock("SC2",.F.)
	SC2->C2_QUJE += nQtdReg                                             
	MsUnLock()

Return

Static Function FMata650(aDadosOP,aOpsOK,nOpc)
	Local cOrdem		:= u_AAPCPC04() // GETNUMSC2() // mudanca solicitado pelo sr. Romulo no dia 05/04/2018 - Realizada por Wermeson
	Local cItem 	:= "01"
	Local cSeq		:= "001"
	Local cLocal := IIf(Empty(aDadosOP[6]),"01",aDadosOP[6])                                                                                                                     
	Local aMata650 := {}
	Private lMsErroAuto := .F.  

	aAdd(aMata650,{"C2_FILIAL" 	, aDadosOP[1] ,Nil})
	aAdd(aMata650,{"C2_NUM"     , cOrdem     		,Nil})
	aAdd(aMata650,{"C2_ITEM"    , cItem    	,Nil})
	aAdd(aMata650,{"C2_SEQUEN" 	, cSeq       	,Nil})
	aAdd(aMata650,{"C2_PRODUTO" , aDadosOP[3] ,Nil})
	aAdd(aMata650,{"C2_UM"      , aDadosOP[4] ,Nil})
	aAdd(aMata650,{"C2_QUANT"   , aDadosOP[5] ,Nil})
	aAdd(aMata650,{"C2_LOCAL"   , cLocal   	,Nil})
	aAdd(aMata650,{"C2_DATPRI" 	, dDataBase   ,Nil})
	aAdd(aMata650,{"C2_DATPRF" 	, dDataBase   ,Nil})
	aAdd(aMata650,{"C2_EMISSAO" , dDataBase   ,Nil})
	aAdd(aMata650,{"C2_TPOP"    , "F"         ,Nil})
	aAdd(aMata650,{"AUTEXPLODE" , "N"         ,Nil})
	aAdd(aMata650,{"C2_XCORTE"  , aDadosOP[2] ,Nil})
	aAdd(aMata650,{"C2_XLINHA"  , aDadosOP[8] ,Nil})
	aAdd(aMata650,{"C2_RECURSO" , aDadosOP[8] ,Nil})

	MSExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc) //Inclusao

	If lMsErroAuto
		MostraErro()
		DisarmTransaction() 
	Else
		AAdd(aOpsOK,{cOrdem + cItem + cSeq,aDadosOP[7]})
	EndIf
Return lMsErroAuto

Static Function FMata380(aDadosEmp,nOpc)

	Local aVetor := {}
	Local aEmpen := {}

	Private lMsErroAuto := .F.

	aVetor:={   {"D4_COD"     ,aDadosEmp[1]		  ,Nil},; //COM O TAMANHO EXATO DO CAMPO
	{"D4_LOCAL"   ,aDadosEmp[2]      ,Nil},;
	{"D4_OP"      ,aDadosEmp[3],Nil},;
	{"D4_DATA"    ,aDadosEmp[4]        ,Nil},;
	{"D4_QTDEORI" ,aDadosEmp[5]      ,Nil},;
	{"D4_QUANT"   ,aDadosEmp[6]      ,Nil},;
	{"D4_TRT"     ,"   "            ,Nil},;
	{"D4_QTSEGUM" ,0                ,Nil}}

	AADD(aEmpen,{aDadosEmp[6],;   // SD4->D4_QUANT
	PadR(aDadosEmp[7],TamSX3("DC_LOCALIZ")[1]),;  // DC_LOCALIZ
	""		,;  // DC_NUMSERI
	0       	,;  // D4_QTSEGUM
	.F.}) 
    U_ZCONOUT("[AAPCPP02-FMata380] - Before FWVetByDic")
	cLogText := VarInfo("",aVetor,NIL,.F.,.F.)
    cLogText := Left(cLogText,Len(cLogText)-2)
    U_ZCONOUT("[AAPCPP02-FMata380] - " + cLogText)
	aVetor := FWVetByDic(aVetor, "SD3")
	U_ZCONOUT("[AAPCPP02-FMata380] - After FWVetByDic")
	cLogText := VarInfo("",aVetor,NIL,.F.,.F.)
    cLogText := Left(cLogText,Len(cLogText)-2)
    U_ZCONOUT("[AAPCPP02-FMata380] - " + cLogText)
    U_ZCONOUT("[AAPCPP02-FMata380] - Before ExecAuto")

	//MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,nOpc,aEmpen) 

	if nOpc == 3
		Reclock("SD4", .t.)
			SD4->D4_FILIAL  := XFILIAL("SD4")
			SD4->D4_COD     := aDadosEmp[1]	
			SD4->D4_LOCAL   := aDadosEmp[2]	
			SD4->D4_OP      := aDadosEmp[3]	 
			SD4->D4_DATA    := aDadosEmp[4]	
			SD4->D4_QUANT   := aDadosEmp[6]	
			SD4->D4_QTDEORI := aDadosEmp[5]	
		MSUNLOCK()
  	EndIf  

	/*If lMsErroAuto
		xdErro := MostraErro()
		U_ZCONOUT("[AAPCPP02-FMata380] - Inside Erro")
		U_ZCONOUT(xdErro)
		DisarmTransaction() 
	EndIf*/

Return lMsErroAuto

Static Function GetNextCode(cTbl,cCpo)

	nTam := TamSX3(cCpo)[01]

	_xQry := " Select isNull( MAX(" + cCpo + "), Replicate('0'," + Str(nTam) + ") ) XCODETI from " + RetSqlName(cTbl)    

	xTbl := MpSysOpenQuery(_xQry)

	cRet := Soma1((xTbl)->XCODETI)
	(xTbl)->(dbCloseArea())

	FreeUsedCode()
	Help := .T.	// Nao apresentar Help MayUse
	While !FreeForUse(cTbl,PADR(cRet,nTam),.F.)
		cRet := Proximo(cRet)
		Help := .T.  // Nao apresentar Help MayUse
	Enddo
	Help := .F.	// Habilito o help novamente

	//Return PADR(cBase+cRet,nTam)
Return _xdCode


Static Function FMata250(aAponta,lProcPA)
	//Local aDadosEti := {}
	Local aVetor := {}
	Local cQry := ""
	//Local cCodEtiD3 := GetNextCode("SD3","D3_XCODETI")
	Local cCodEtiD3 := GetSXENum("SD3","D3_XCODETI")
	Local cIntegra  := "M" //FLAG PARA IDENTIFICAR O APONTAMENTO MANUAL
	Private lMsErroAuto := .F.

	If lProcPA
		ProcRegua(0)
	EndIf	

	cId := "["+cUserName + "][" + DTOS(ddatabase) + "][" + Time() + "]"
	_cdHora := Time()
	cSql  := " INSERT INTO ADIST(CID,LINHA,POS01,POS02,POS03,POS04,POS05,POS06,POS07,POS08) "
	cExec := cSql + " Values( "
	cExec += "'" + cId + "',"
	cExec += "'" + "xxx" + "',"
	cExec += "'" + aAponta[1] + "',"
	cExec += "'" + aAponta[2] + "',"
	cExec += "'" + aAponta[3] + "',"
	cExec += "'" + Str(aAponta[4]) + "',"
	cExec += "'0',"
	cExec += "'" + aAponta[5] + "',"
	cExec += "'" + aAponta[6] + "',"
	cExec += "'" + DTOC(aAponta[8]) + "' ) "

	tcSqlExec(cExec)
	U_ZCONOUT('[CRAP 01]' + 'CHAMANDO MATA250 AUTOMATICA ')

	SC2->(DbSetOrder(1))
	SC2->(DbSeek(xFilial("SC2")+aAponta[2]))

	nTotal := (SC2->C2_QUANT- SC2->C2_QUJE)
	nQtdMaior := 0 
	If  aAponta[4] > nTotal  
		If nPerc > 0
			If Abs(nTotal)- aAponta[4] > SC2->C2_QUANT*(nPerc/100) 
			Else
				nQtdMaior := Abs( Abs(nTotal)- aAponta[4] )
			EndIf
		EndIf
	EndIf


	aAdd(aVetor,{"D3_TM"		, aAponta[1]	, NIL})
	aAdd(aVetor,{"D3_OP"		, aAponta[2]	, NIL})
	aAdd(aVetor,{"D3_COD"		, aAponta[3]	, NIL})
	aAdd(aVetor,{"D3_QUANT"	    , aAponta[4]	, NIL})
	aAdd(aVetor,{"D3_CF"		, aAponta[5]	, NIL})
	aAdd(aVetor,{"D3_LOCAL"     , aAponta[6]    , Nil})
	//aAdd(aVetor,{"D3_DOC"		, aAponta[7]	, NIL})
	aAdd(aVetor,{"D3_EMISSAO"	, aAponta[8]	, NIL})
	aAdd(aVetor,{"D3_XDATA"	    , Date()     	, NIL})
	aAdd(aVetor,{"D3_XHORA"	    , _cdHora	    , NIL})
	aAdd(aVetor,{"D3_XCODETI"	, cCodEtiD3	    , NIL})
	aAdd(aVetor,{"D3_XINTEGR"	, cIntegra	    , NIL})
	
	If SB1->B1_RASTRO == "L" .And. GetMv("MV_RASTRO") == "S"
		// Alterado por Wladimir  - se tiver contyrole de corrida, pegar o lote mais antigo 
		If SuperGetMv("MV_XCORRI",.F.,.F.) 	.and. SB1->B1_XCTLCOR=="S"
			
			_mNumOP  := aAponta[2]                                                                      // Num Op
			_mCtrl := "N"   // Flag para retornar o num ero do lote da corrida
			
			// Procura produto com controle de corrida
			dbSelectArea("SD4")
			dbSetOrder(2)
			dbSeek(xFIlial("SD4")+_mNumOP)
			While !eof() .and. trim(D4_OP) == _mNumOP
				_mCtrl   := Posicione("SB1",1,xFIlial("SB1")+SD4->D4_COD,"B1_XCTLCOR")                          // Verifica se controla corrida do produto
				If _mCtrl == "S"
					_mProd := SD4->D4_COD
					EXIT
				Endif
				dbSkip()
			Enddo
			//Alert(_mProd)			
			_mSaldo  := 0
			// If  _mGrupo $ _XGrpcor
			// Se controlar corrida pela o lote
			If _mCtrl == "S"
			
				cQry := ""
				cQry += "SELECT BF_LOTECTL AS BF_LOTECTL "
				cQry += "FROM SBF010 "
				cQry += "WHERE D_E_L_E_T_ = '' "
				cQry += "AND BF_FILIAL = '"+xFilial("SBF")+"' "
				cQry += "AND BF_QUANT > 0  AND BF_LOCAL= '03' "
				cQry += "AND BF_PRODUTO = '"+_mProd+"' "

								
				dbUseArea(.T., "TOPCONN",TCGENQRY(,,cQry),"TRB1",.F.,.T.)
				
				U_ZCONOUT("Irá gravar....com o Lote Correto....")
				aAdd(aVetor,{"D3_LOTECTL" ,TRB1->BF_LOTECTL  		,NIL})
				aAdd(aVetor,{"D3_DTVALID" ,dDataBase + 60			,NIL})
				
				TRB1->(dbCloseArea())
			Endif
				
		Else
			//Customizar para trazer Left(Dtos(dDataBase),6) + o lote do componente
			//o lote do componente está na SD5 e SB8. 

			aAdd(aVetor,{"D3_LOTECTL" ,Left(Dtos(dDataBase),6) ,NIL})
			aAdd(aVetor,{"D3_DTVALID" ,dDataBase + 60			 ,NIL})
		Endif
	EndIf
	/*If nQtdMaior>0
	aAdd(aMata250,{"D3_QTMAIOR" , nQtdMaior ,NIL})
	EndIf*/
	U_ZCONOUT("[AAPCPP02] - Before FWVetByDic")
	cLogText := VarInfo("",aVetor,NIL,.F.,.F.)
    cLogText := Left(cLogText,Len(cLogText)-2)
    U_ZCONOUT("[AAPCPP02] - " + cLogText)
	aVetor := FWVetByDic(aVetor, "SD3")
	U_ZCONOUT("[AAPCPP02] - After FWVetByDic")
	cLogText := VarInfo("",aVetor,NIL,.F.,.F.)
    cLogText := Left(cLogText,Len(cLogText)-2)
    U_ZCONOUT("[AAPCPP02] - " + cLogText)
    U_ZCONOUT("[AAPCPP02] - Before ExecAuto")

	MSExecAuto({|x,y| MATA250(x,y)},aVetor,3)
    
	If lMsErroAuto
		xErro := MostraErro()
		U_ZCONOUT("[AAPCPP02] - Erro")
		U_ZCONOUT(xErro)
		DisarmTransaction() 
		RollBackSX8()
	Else
		//Adiciona o codigo da etiqueta pra buscar as informaçoes do apontamento de producao
		ConfirmSX8()
		AAdd(aCodEtqD3,cCodEtiD3)		 
	EndIf
Return lMsErroAuto

Static Function FExibiMsg(cString)		//Exibi Mensagem no sistema
	Local nTempo := 2
	Local oFont18 := TFont():New('Arial', ,-18, ,.T.)

	DEFINE MSDIALOG oDlgMsg TITLE OemToAnsi("Apontamento de Produção") FROM Resolucao(5),Resolucao(0) To Resolucao(10),Resolucao(50) OF oMainWnd

	@ Resolucao(0),Resolucao(0) MSPANEL oPanelT PROMPT "" SIZE Resolucao(200),Resolucao(50) OF oDlgMsg CENTERED LOWERED  // "Botoes"
	oPanelT:Align := CONTROL_ALIGN_TOP

	@ Resolucao(5),Resolucao(20) SAY cString SIZE Resolucao(200),Resolucao(50) PIXEL OF oPanelT FONT oFont18 COLOR CLR_BLUE

	oTimer := TTimer():New(1000*nTempo , {|| oDlgMsg:End() }, oDlgMsg )
	oTimer:Activate()

	ACTIVATE MSDIALOG oDlgMsg CENTERED

Return

Static Function ImpEtiq(aEtiqueta,cProduto)
	Local cImp	:= Alltrim(GetMv("MV_IACD04"))

	Local nQtde   := aEtiqueta[1]
	Local cCodSep := aEtiqueta[2]
	Local cCodID  := aEtiqueta[3]
	Local nCopias := aEtiqueta[4]
	Local cNFEnt  := aEtiqueta[5]
	Local cSeriee := aEtiqueta[6]
	Local cFornec := aEtiqueta[7]
	Local cLojafo := aEtiqueta[8]
	Local cArmazem:= aEtiqueta[9]
	Local cOP     := aEtiqueta[10]
	Local cNumSeq := aEtiqueta[11]
	Local cLote   := aEtiqueta[12]
	Local cSLote  := aEtiqueta[13]
	Local dValid  := aEtiqueta[14]
	Local cCC  	  := aEtiqueta[15]
	Local cLocOri  := aEtiqueta[16]
	Local cOPREQ   := aEtiqueta[17]
	Local cNumSerie:= aEtiqueta[18]
	Local cOrigem  := aEtiqueta[19]
	Local cEndereco:= aEtiqueta[20]
	Local cPedido  := aEtiqueta[21]
	Local nResto   := aEtiqueta[22]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Funcao utilizada para verificar a ultima versao dos fontes      ³
	//³ SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
	//| cliente, assim verificando a necessidade de uma atualizacao     |
	//| nestes fontes. NAO REMOVER !!!							        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
		Final("Atualizar SIGACUS.PRW !!!")
	Endif
	IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
		Final("Atualizar SIGACUSA.PRX !!!")
	Endif
	IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
		Final("Atualizar SIGACUSB.PRX !!!")
	Endif

	//CBChkTemplate()

	If ! CB5SetImp(cImp,IsTelNet())
		Aviso(cTitulo,"Codigo do local de impressao invalido!",{"OK"})
		Return .f.
	EndIF

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProduto))

	cCodID := GeraCB0('01',{SB1->B1_COD,nQtde,cCodSep,cNFEnt,cSeriee,cFornec,cLojafo,cPedido,cEndereco,cArmazem,cOp,cNumSeq,NIL,NIL,NIL,cLote,cSLote,dValid,cCC,cLocOri,NIL,cOPReq,cNumserie,cOrigem})
	
	//if dtos(ddatabase) != '20161008'
	
	//Chamada da Função para geração da Etiqueta.
	
	If ExistBlock('IMG01')
		ExecBlock('IMG01',,,{nQtde,cCodSep,cCodID,nCopias,cNFEnt,cSeriee,cFornec,cLojafo,cArmazem,cOP,cNumSeq,cLote,cSLote,dValid,cCC,cLocOri,cOPREQ,;
		cNumSerie,cOrigem,cEndereco,cPedido,0,nResto})			
	EndIf

	MSCBCLOSEPRINTER()   
	                                
	                                
	//EndIf
Return .T.

//----------------------------------------------------------
/*/{Protheus.doc} Resolucao
@description Função para tratar o tamanho da resolução da tela.
@author		Bruno Garcia
@version	1.0
@since		02/06/2014
@return		Nil, Nil, Nil
@param nTam,Inteiro,Obrigatório,contêm o valor em pixels da posiçao do objeto.
/*/
//----------------------------------------------------------
Static Function Resolucao(nTam)                                                         
	Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³mento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam) 

Static Function SetRecAAPCP()
	__nRecSD3 := SD3->(Recno())
Return

/*/{Protheus.doc}GeraCB0
@description
Rotina Auxiliar para gerar o registro na tabela CB0

@author	Bruno Garcia
@since		24/05/2016
@version	P11 R8

@param 	Nao possui,Nao possui,Nao possui,Nao possui
@return	Nao possui,Nao possui,Nao possui,Nao possui
/*/
Static Function GeraCB0(cTipo,aConteudo)
	Local cSeq := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica numero do ultimo Sequencial utilizado                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSeq := Soma1(Pad(GetMV("MV_CODCB0"),TamSx3("CB0_CODETI")[1]),TamSx3("CB0_CODETI")[1])
	While !MayIUseCode( "CB0_CODETI"+xFilial("CB0")+cSeq)  //verifica se esta na memoria, sendo usado
		cSeq := Soma1(cSeq)// busca o proximo numero disponivel 
	EndDo 

	RecLock("CB0",.T.)
	CB0->CB0_FILIAL := xFilial("CB0")
	CB0->CB0_CODETI := cSeq
	CB0->CB0_DTNASC := dDataBase
	CB0->CB0_TIPO   := cTipo	

	CB0->CB0_CODPRO := CBChk(aConteudo,1,CB0_CODPRO)
	CB0->CB0_QTDE   := CBChk(aConteudo,2,CB0_QTDE)
	CB0->CB0_USUARIO:= CBChk(aConteudo,3,CB0_USUARIO)
	CB0->CB0_NFENT  := CBChk(aConteudo,4,CB0_NFENT)
	CB0->CB0_SERIEE := CBChk(aConteudo,5,CB0_SERIEE)
	CB0->CB0_FORNEC := CBChk(aConteudo,6,CB0_FORNEC)
	CB0->CB0_LOJAFO := CBChk(aConteudo,7,CB0_LOJAFO)
	CB0->CB0_PEDCOM := CBChk(aConteudo,8,CB0_PEDCOM)
	CB0->CB0_LOCALI := CBChk(aConteudo,9,CB0_LOCALI)
	CB0->CB0_LOCAL  := CBChk(aConteudo,10,CB0_LOCAL)
	CB0->CB0_OP     := CBChk(aConteudo,11,CB0_OP)
	CB0->CB0_NUMSEQ := CBChk(aConteudo,12,CB0_NUMSEQ)
	CB0->CB0_NFSAI  := CBChk(aConteudo,13,CB0_NFSAI)
	CB0->CB0_SERIES := CBChk(aConteudo,14,CB0_SERIES)
	CB0->CB0_CODET2 := CBChk(aConteudo,15,CB0_CODET2)
	CB0->CB0_LOTE   := CBChk(aConteudo,16,CB0_LOTE)
	CB0->CB0_SLOTE  := CBChk(aConteudo,17,CB0_SLOTE)
	CB0->CB0_DTVLD  := CBChk(aConteudo,18,CB0_DTVLD)
	CB0->CB0_CC     := CBChk(aConteudo,19,CB0_CC)
	CB0->CB0_LOCORI := CBChk(aConteudo,20,CB0_LOCORI)
	CB0->CB0_PALLET := CBChk(aConteudo,21,CB0_PALLET)
	CB0->CB0_OPREQ  := CBChk(aConteudo,22,CB0_OPREQ)
	CB0->CB0_NUMSER := CBChk(aConteudo,23,CB0_NUMSER)
	CB0->CB0_ORIGEM := CBChk(aConteudo,24,CB0_ORIGEM)

	If CB0->(FieldPos("CB0_ITNFE"))>0
		CB0->CB0_ITNFE  := CBChk(aConteudo,25,CB0_ITNFE)
	EndIf
	MsUnLock()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o sequencial da etiqueta gerada                        ³
	//³ Utilize sempre GetMv para posicionar o SX6. N„o use SEEK !!! ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Garante que o sequencial do cheque seja sempre superior ao numero anterior
	If GetMv("MV_CODCB0") < cSeq
		PutMv("MV_CODCB0",cSeq)
	Endif

Return cSeq

Static Function CBChk(aConteudo,nItem,xDef)
	local uRet := xDef
	If nItem <= len(aConteudo) .and. aConteudo[nItem] <> NIL
		uRet:= aConteudo[nItem]
	EndIf
Return uRet
