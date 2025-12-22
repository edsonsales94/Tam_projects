#INCLUDE "ACDI011.ch"
#Include "Protheus.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#include "font.CH"
#Include "RWMAKE.ch"
#Include "ApWizard.ch"
#INCLUDE "TBICONN.CH"
#DEFINE _ENTER CHR(13)+CHR(10)
/*
+-----------+------------+----------------+-------------------+-------+---------------+
| Programa  | SOFATP11   | Desenvolvedor  | KEURE (SOLUTII)   | Data  | 03/06/2020    |
+-----------+------------+----------------+-------------------+-------+---------------+
| Descricao | Fonte criado com base no fonte nativo Totvs ACDI011.					  |
| 			| Wizard de impressão de etiquetas										  |
+-----------+-------------------------------------------------------------------------+
| Modulos   | Faturamento                                                             |
+-----------+-------------------------------------------------------------------------+
| Processos |                                                                         |
+-----------+-------------------------------------------------------------------------+
|                  Modificacoes desde a construcao inicial                            |
+----------+-------------+------------------------------------------------------------+
| DATA     | PROGRAMADOR | MOTIVO                                                     |
+----------+-------------+------------------------------------------------------------+
|          |             |                                                            |
+----------+-------------+------------------------------------------------------------+
*/              
User Function PGETIQ01(nOrigem,aParIni)
	Local oPanel
	Local nTam
	Local nTamEti	:= TamSX3("CB0_CODETI")[1]
	Local nOP		:= TamSX3("D3_OP")[1]
	Local nProd		:= TamSX3("B1_COD")[1]

	Local aParReImp	:= {{1,"Etiqueta"		,nTamEti	,"","","CB0"	,If(aParIni==NIL,".T.",".F."),60,.F.},; 
						{1,"Ordem de producao"	,nOP		,"","","SC2"	,If(aParIni==NIL,".T.",".F."),60,.F.},; 
						{1,"Produto"		,nProd		,"","","SB1"	,If(aParIni==NIL,".T.",".F."),60,.F.}}
	Local aRetReImp	:= {Space(nTamEti),Space(nOP),Space(nProd)}

	Local aParFrag	:= {{1,"Etiqueta" ,Space(10),"","","CB02",If(aParIni==NIL,".T.",".F."),60,.F.}}
	Local aRetFrag	:= {Space(10)}

	Local aParOP	:= {{1,"Ordem de Producao" ,Space(13),"","","SC2"	,If(aParIni==NIL,".T.",".F."),60,.F.}}
	Local aRetOP	:= {Space(13)}

	Local aParam	:= {} 

	Local nx:= 1

	Private oWizard
	Private aParImp	:= {{2,"Local de impressao",1,{"000001","000002"},50,"",.F.},;
						{2,"Tipo armazenagem",1,{"Gaiola 1", "Gaiola 2", "Palete", "Fardos"},50,"",.F.}}
	Private aRetImp	:= {Space(6),Space(10)}

	Private oOrigem
	Private aOrigem	:= {}

	Private nTamArm   := TamSX3("B2_LOCAL")[1]
	Private nTamLote  := TamSX3("B8_LOTECTL")[1]
	Private nTamSLote := TamSX3("B8_NUMLOTE")[1]
	Private nTamSerie := TamSX3("BF_NUMSERI")[1]
	Private nTamEnder := Tamsx3("BE_LOCALIZ")[1]

	Private oLbx
	Private aLbx	:= {}
	Private aSvPar	:= {}
	Private cOpcSel	:= ""  // variavel disponivel para infomar a opcao de origem selecionada

	Private lVotar	:= .T.

	DEFAULT nOrigem := 1

	aParam:={	{"Impressão de etiquetas"	,aParOP		,aRetOP		,{|| AWzEti()}},; 
				{"Reimpressão de etiquetas"	,aParReImp	,aRetReImp	,{|| AWzVPR()}},; 
				{"Impressão de Semi-acabado",aParOP		,aRetOP		,{|| AWzVSA()}},; 
				{"Fragmentação de etiquetas",aParFrag	,aRetFrag	,{|| AWzVOP()}} } 

	// carrega parametros vindo da funcao pai
	If aParIni <> NIL  
		For nX := 1 to len(aParIni)              
			nTam := len( aParam[nOrigem,3,nX ] )
			aParam[nOrigem,3,nX ] := Padr(aParIni[nX],nTam )
		Next             
	EndIf 

	For nx:= 1 to len(aParam)                       
		aadd(aOrigem,aParam[nX,1])
	Next

	DEFINE WIZARD oWizard TITLE "Etiqueta de Produto ACD V 12.R02 " ;
		HEADER "Rotina de Impressão de etiquetas termica." ;
		MESSAGE "";
		TEXT "Esta rotina tem por objetivo realizar a impressao das etiquetas termicas de identificação de produto no padrão codigo natural/EAN conforme as opcoes disponives a seguir." ;
		NEXT {|| .T.} ;
			FINISH {|| .T. } ;
		PANEL

	// Primeira etapa
	CREATE PANEL oWizard ;
			HEADER "Informe a origem das informações para impressão" ;
			MESSAGE "" ;
			BACK {|| .T. } ;
			NEXT {|| nc:= 0,aeval(aParam,{|| &("oP"+str(++nc,1)):Hide()} ),&("oP"+str(nOrigem,1)+":Show()"),cOpcSel:= aParam[nOrigem,1],A11WZIniPar(nOrigem,aParIni,aParam) ,.T. } ;
			FINISH {|| .F. } ;
			PANEL
	
	oPanel := oWizard:GetPanel(2)  
	
	oOrigem := TRadMenu():New(30,10,aOrigem,BSetGet(nOrigem),oPanel,,,,,,,,100,8,,,,.T.)
	If aParIni <> NIL
		oOrigem:Disable()
	EndIf	   
		
	// Segunda etapa
	CREATE PANEL oWizard ;
			HEADER "Preencha as solicitacoes abaixo para a selecao do produto" ;
			MESSAGE "" ;
			BACK {|| .T. } ;
			NEXT {|| Eval(aParam[nOrigem,4]) } ;
			FINISH {|| .F. } ;
			PANEL                                  

	oPanel := oWizard:GetPanel(3)    

	For nx:= 1 to len(aParam)
		&("oP"+str(nx,1)) := TPanel():New( 028, 072, ,oPanel, , , , , , 120, 20, .F.,.T. )
		&("oP"+str(nx,1)):align:= CONTROL_ALIGN_ALLCLIENT                                             
		Do Case
			Case nx == 1 // etiqueta
				ParamBox(aParOP,"Parametros...",aParam[nX,3],,,,,,&("oP"+str(nx,1)))
			Case nx == 2 // reimpressao 
				ParamBox(aParReImp,"Parametros...",aParam[nX,3],,,,,,&("oP"+str(nx,1)))
			Case nx == 3 // semi acabado
				ParamBox(aParOP,"Parametros...",aParam[nX,3],,,,,,&("oP"+str(nx,1)))
			Case nx == 4
				ParamBox(aParFrag,"Parametros...",aParam[nX,3],,,,,,&("oP"+str(nx,1)))
		EndCase
		&("oP"+str(nx,1)):Hide()
	Next
		
	CREATE PANEL oWizard ;
			HEADER "Parametrizacao por produto" ;
			MESSAGE "Marque os produtos que deseja imprimir" ;
			BACK {|| lVotar } ;
			NEXT {|| VldaLbx(oWizard:GetPanel(5),nOrigem)} ;
			FINISH {|| .T. } ;
			PANEL
	oPanel := oWizard:GetPanel(4)       
							
	CREATE PANEL oWizard ;
			HEADER "Parametrizacao da impressora" ;
			MESSAGE "Informe o Local de Impressao" ;
			BACK {|| .T. } ;
			NEXT {|| Imprime(nOrigem)} ;  //Processa({ || Imprime(nOrigem)}, OemToAnsi("Gerando e imprimindo etiquetas..."))
			FINISH {|| .T.  } ;
			PANEL
	oPanel := oWizard:GetPanel(5)       
	
	CREATE PANEL oWizard ;
		HEADER "Impressao Finalizada" ;
		MESSAGE "" ;
		BACK {|| fRetImp(nOrigem)} ;
		NEXT {|| .T. } ;
		FINISH {|| .T.  } ;
		PANEL
	
	ACTIVATE WIZARD oWizard CENTERED

Return()

Static Function A11WZIniPar(nOrigem, aParIni,aParam)
/************************************************************************************
*
*
**/
	Local nX
	If aParIni <> NIL
		For nx:= 1 to len(aParIni)
			&( "MV_PAR" + StrZero( nX, 2, 0 ) ) := aParIni[ nX ]
		Next
	EndIf
			
	For nx:= 1 to len(aParam[nOrigem,3])                                    
		&( "MV_PAR" + StrZero( nX, 2, 0 ) ) := aParam[nOrigem,3,nX ]
	Next                       

Return(.T.)

Static Function AWzEti()
/***********************************************************************************
*
*
**/
	Local cOp	:= Padr(MV_PAR01,TamSx3("D3_OP")[1])
	Local nQE
	Local oOk	:= LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO   
	Local nQSD3 := 0
	Local nQSC2 := 0
	Local nSaldo := 0
	Local nEtiEmit := 0
	
	If Empty(cOp).or.Len(Alltrim(cOP))<=6
		MsgAlert("Informar o codigo da ordem de producao com Item e Sequencia ")
		Return(.F.)
	EndIf    


	//Somar tudo aquilo que foi apontado na OP
	//nQSD3:= fApont(cOp)

	aLbx:= {}
	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	If SC2->(DbSeek(xFilial("SC2")+Alltrim(cOp)))
		nQSC2:= SC2->C2_QUANT
		//Somar quantas etiquetas já foram emitidas para essa OP
		nEtiEmit:= fEmitOP(cOp)

		nSaldo:= nQSC2 - nEtiEmit

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			If !(AllTrim(SB1->B1_ZTIPO)$"EP|ES")
				If nQSC2 > 0 .And. nSaldo > 0 // ainda tem saldo pra gerar etiquetas
				    // Alert("1a chamada do ListBoxMar")
					// pra condicionar quantidade a imprimir 
					aadd(aLbx,{.F.,Alltrim(cOp),SB1->B1_COD,SB1->B1_DESC,nQSC2,nEtiEmit,0}) // 
					ListBoxMar(oWizard:GetPanel(4))
					oLbx:SetArray( aLbx )
					oLbx:bLine:= {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7]}}
				Else
					MsgAlert("Nao existe saldo de apontamento de OP para gerar novas etiquetas.")
					Return(.F.)
				EndIf
			Else
			   	//Alert("2a chamada do ListBoxMar")
				aadd(aLbx,{.F.,Alltrim(cOp),SB1->B1_COD,SB1->B1_DESC,nQSC2,nEtiEmit,nSaldo})
				ListBoxMar(oWizard:GetPanel(4))
				oLbx:SetArray( aLbx )
				oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7]}}
			EndIf


		Else
			MsgAlert("Produto nao localizado.")
			Return(.F.)
		EndIf
	Else
		MsgAlert("Nenhuma OP localizada.")
		Return(.F.)
	EndIf
	oLbx:Refresh()
Return(.T.)

Static Function AWzVPR()
/************************************************************************************
*
*
**/
	Local cEti		:= Padr(MV_PAR01,Tamsx3("CB0_CODETI")[1])
	Local cOP		:= Padr(MV_PAR02,Tamsx3("D3_OP")[1])
	Local cProd		:= Padr(MV_PAR03,Tamsx3("B1_COD")[1])
	Local oOk		:= LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO      
	Local nT		:= TamSx3("D3_QUANT")[1]
	Local nD		:= TamSx3("D3_QUANT")[2] 
	Local cChave	:= ""

	Local cTipo	:= ""
	Local nToler:= 0
	Local nGaio1:= 0
	Local nGaio2:= 0
	Local nPale := 0
	Local nPct  := 0

	Local nQVol
	Local nResto               
	Local oOk	:= LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO   
	Local nT	:= TamSx3("D3_QUANT")[1]
	Local nD	:= TamSx3("D3_QUANT")[2] 
	Local nOrdCB0 := 1

	Local cBusca:= ""

	Local cQuery:= ""

	If !Empty(cEti) 
		cBusca:= cEti
		cChave:= "CB0->CB0_FILIAL+Alltrim(CB0->CB0_CODETI) == xFilial('CB0')+Alltrim(cBusca)"
	Endif
	If Empty(cBusca) .And. !Empty(cOP)
		nOrdCB0	:= 7
		cBusca	:= cOP
		cChave	:= "CB0->CB0_FILIAL+Alltrim(CB0->CB0_OP) == xFilial('CB0')+Alltrim(cBusca)"
	Endif
	If Empty(cBusca) .And. !Empty(cProd)
		nOrdCB0	:= 12
		cBusca	:= cProd
		cChave	:= "CB0->CB0_FILIAL+Alltrim(CB0->CB0_CODPRO) == xFilial('CB0')+Alltrim(cBusca)"
	Endif

	If Empty(cBusca)
		MsgAlert("Algum parametro precisa ser informado, ou numero da etiqueta, ou codigo da OP ou codigo do produto")
		Return(.F.)
	EndIf    

	dbSelectArea("CB0")
	CB0->(DbSetOrder(nOrdCB0))
	If !CB0->(dbSeek(xFilial('CB0')+cBusca))
		MsgAlert("Etiqueta nao encontrada.")
		Return(.F.)
	EndIf               

	aLbx:={}
	dbSelectArea("CB0")
	Do While !CB0->(Eof()) .And. &cChave
		SB1->(DbSetOrder(1))
		If !SB1->(DbSeek(xFilial("SB1")+CB0->CB0_CODPRO))
			MsgAlert("Produto ("+AllTrim(CB0->CB0_CODPRO)+") nao encontrado")
			dbSelectArea("CB0")
			CB0->(DbSkip())
			Loop
		EndIf    

		If !CBImpEti(SB1->B1_COD)
			MsgAlert("Este Produto ("+AllTrim(CB0->CB0_CODPRO)+") esta configurado para nao imprimir etiqueta")
			dbSelectArea("CB0")
			CB0->(DbSkip())
			Loop
		EndIf 

		aAdd(aLbx,{.F., CB0->CB0_CODETI, SB1->B1_COD, SB1->B1_DESC, CB0->CB0_OP, CB0->CB0_QTDE, CB0->CB0_ZTIPO})
		//aLbx:={{.F., CB0->CB0_CODETI, SB1->B1_COD, SB1->B1_DESC, CB0->CB0_OP, CB0->CB0_QTDE, CB0->CB0_ZTIPO}}

		dbSelectArea("CB0")
		CB0->(DbSkip())
	EndDo
				
	ListBoxMar(oWizard:GetPanel(4))
	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7]}}
	oLbx:Refresh()
Return(.T.)

Static Function AWzVOP()
/************************************************************************************
*
*
**/
	Local cEti	:= Padr(MV_PAR01,Tamsx3("CB0_CODETI")[1])
	Local oOk	:= LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO
	Local nQtde
	Local nQE
	Local nQVol
	Local nResto                                            
	Local nT	:= TamSx3("D3_QUANT")[1]
	Local nD	:= TamSx3("D3_QUANT")[2] 

	If Empty(cEti)
		MsgAlert("Necessario informar o codigo da etiqueta.")
		Return(.F.)
	EndIf

	dbSelectArea("CB0")
	CB0->(DbSetOrder(1))
	If !CB0->(dbSeek(xFilial('CB0')+cEti))
		MsgAlert("Etiqueta nao encontrada.")
		Return(.F.)
	Else		
		SB1->(DbSetOrder(1))
		If !SB1->(DbSeek(xFilial('SB1')+CB0->CB0_CODPRO))
			MsgAlert("Produto nao encontrado")
			Return(.F.)
		EndIf    

		If !CBImpEti(SB1->B1_COD)
			MsgAlert("Este Produto esta configurado para nao imprimir etiqueta")
			Return(.F.)
		EndIf 
	EndIf               

	ListBoxMar(oWizard:GetPanel(4))
	aLbx:={}
	aLbx:={{.F., CB0->CB0_CODETI, SB1->B1_COD, SB1->B1_DESC, CB0->CB0_OP, CB0->CB0_QTDE, CB0->CB0_ZTIPO}}
	oLbx:SetArray( aLbx )
	oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7]}}
	oLbx:Refresh()
Return(.T.)

Static Function ListBoxMar(oDlg)
/************************************************************************************
*
*
**/
	Local oChk1
	Local oChk2
	Local lChk1 := .F.
	Local lChk2 := .F.
	Local oOk	:= LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO

	If (oLbx==NIL)
		If (oOrigem:NOPTION==1 .or. oOrigem:NOPTION== 2 .or. oOrigem:NOPTION==3 )
			//aLbx:= {{.F., Space(Tamsx3("D3_OP")[1]), Space(Tamsx3("B1_COD")[1]), Space(Tamsx3("B1_DESC")[1]), 0, 0, 0}}
			If !(Posicione("SB1",1,xFilial("SB1")+AllTrim(aLbx[1,3]),"B1_ZTIPO")$"EP|ES")
				@ 10,10 LISTBOX oLbx FIELDS HEADER " ", "OP", "Produto","Descrição","Apontado","Emitidos","Saldo a emitir","Qtd.Etiq."  SIZE 230,095 OF oDlg PIXEL ;
						ON dblClick(aLbx[oLbx:nAt,1] := !aLbx[oLbx:nAt,1])
				oLbx:SetArray( aLbx )
				oLbx:bLine	:= {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7]}}
				oLbx:bRClicked:= {|| fEditSaldo()}
			Else
				@ 10,10 LISTBOX oLbx FIELDS HEADER " ", "OP", "Produto","Descrição","Apontado","Emitidos","Saldo a emitir","Qtd.Etiq."  SIZE 230,095 OF oDlg PIXEL ;
						ON dblClick(aLbx[oLbx:nAt,1] := !aLbx[oLbx:nAt,1])
				oLbx:SetArray( aLbx )
				oLbx:bLine	:= {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7]}}
				oLbx:bRClicked:= {|| fEditSaldo()}
			EndIf
			// oLbx:bRClicked:= {|| fEditSaldo()}
		Else
			//aLbx:= {{.F., Space(Tamsx3("CB0_CODETI")[1]), Space(Tamsx3("B1_COD")[1]), Space(Tamsx3("B1_DESC")[1]), Space(11), 0}}
			@ 10,10 LISTBOX oLbx FIELDS HEADER " ", "Etiqueta", "Produto","Descrição","OP","Quantidade","Tipo"  SIZE 230,095 OF oDlg PIXEL ;
					ON dblClick(aLbx[oLbx:nAt,1] := !aLbx[oLbx:nAt,1])
			oLbx:SetArray( aLbx )
			oLbx:bLine	:= {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7]}}
		EndIf
		oLbx:align	:= CONTROL_ALIGN_ALLCLIENT

		oP := TPanel():New( 028, 072, ,oDlg, , , , , , 120, 20, .F.,.T. )
		oP:align:= CONTROL_ALIGN_BOTTOM

		@ 5,160 CHECKBOX oChk1 VAR lChk1 PROMPT STR0033 SIZE 70,7 	PIXEL OF oP ON CLICK( aEval( aLbx, {|x| x[1] := lChk1 } ),oLbx:Refresh() ) //"Marca/Desmarca Todos"
		@ 5,230 CHECKBOX oChk2 VAR lChk2 PROMPT STR0034 SIZE 70,7 	PIXEL OF oP ON CLICK( aEval( aLbx, {|x| x[1] := !x[1] } ), oLbx:Refresh() ) //"Inverter a seleção"
	EndIf
Return()
            
Static Function fEditSaldo()
/************************************************************************************
*Esta opcao somente e usada na mpressao de etiqueta.
*Se for usar nas outras opcoes deve-se atentar para a posicao da coluna de qtd.
**/
	Local aParNF	:= {}
	Local aRet		:= {}
	Local nQTDDiv	:= 0

	If (Len(aLbx[1])<=7)
		aAdd(aParNF,{1,"Quantidade",aLbx[oLbx:nAt,7],PesqPict("SD3","D3_QUANT"),"","",".T.",0,.F.})
		aRet:= {0}
		oLbx:ColPos:= 7
		If ParamBox(aParNF,"Editar Saldo",@aRet,,,,,,,,.T.)
			If (aRet[1]>0)
				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				If SB1->(DbSeek(xFilial("SB1")+aLbx[oLbx:nAt,3]))
					nQTDDiv:= Round(SB1->B1_ZPALET,3)
				EndIf

				//If (aRet[1]<aLbx[oLbx:nAt,7]) MODIFICACAO ESPECIFICA PARA MAPA E PALETE
				//If (aRet[1]<nQTDDiv)
					aLbx[oLbx:nAt,7]:= aRet[1]
					oLbx:Refresh()
				//EndIf
			EndIf
		EndIf
	Else
		aAdd(aParNF,{1,"Qtd.Etiq.",aLbx[oLbx:nAt,7],"@E 999","","",".T.",0,.F.})
		aAdd(aParNF,{1,"Qtd./Etiq.",aLbx[oLbx:nAt,7],PesqPict("SD3","D3_QUANT"),"","",".T.",0,.F.})
		aRet:= {0,0}
		oLbx:ColPos:= 7
		If ParamBox(aParNF,"Editar Qtd.",@aRet,,,,,,,,.F.)
			If (aRet[1]>0)
				aLbx[oLbx:nAt,7]:= aRet[1]
			EndIf
			If (aRet[2]>0)
				aLbx[oLbx:nAt,7]:= aRet[2]
			EndIf
			oLbx:Refresh()
		EndIf
	EndIf
Return()

Static Function VldaLbx(oPanel,nOrig)
/************************************************************************************
*Programa para Validar a parametrizacao por produto
*
**/
	Local nx
	Local nMv
	Local lACDI11VL := .T.

	For nX := 1 to Len(aLbx)   
		If aLbx[nx,1] .and. ! Empty(aLbx[nX,3])
			exit
		EndIf	
	Next

	If nX > len(aLbx)
		MsgAlert("Necessario marcar pelo menos um item com quantidade para imprimir!")
		Return(.F.)
	EndIf      

	If (Len(aLbx[1])>7)
		For nX:= 1 to Len(aLbx)   
			If aLbx[nx,1]
				If (aLbx[nx,8]<=0) .Or. (aLbx[nx,9]<=0)
					MsgAlert(OemToAnsi("As quantidades para o item "+AllTrim(Str(nX))+" não foram informadas corretamente!"))
					Return(.F.)
				EndIf	
			EndIf
		Next nX
	EndIf

	If (nOrig==2)//REIMPRESSAO
		aParImp:= {	{2,"Local de impressao",1,{},50,"",.F.}}
		aRetImp:= {Space(6)}
	Else
		aParImp:= {	{2,"Local de impressao",1,{},50,"",.F.},;
					{2,"Tipo armazenagem",1,{},50,"",.F.}}
		aRetImp:= {Space(6),Space(10)}
	EndIf

	dbSelectArea("CB5")
	CB5->(dbSetOrder(1))
	CB5->(dbGoTop())
	Do While !CB5->(Eof())
		aAdd(aParImp[1][4],AllTrim(CB5->CB5_CODIGO))

		dbSelectArea("CB5")
		CB5->(dbSkip())
	EndDo
	dbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+aLbx[1,3]))
		If (nOrig==4)//FRAGMENTACAO
			If (SB1->B1_ZQE>0)
				aAdd(aParImp[2][4],"1 - Fardos")
			EndIf
			If (Len(aParImp[2][4])<=0)
				MsgAlert("Nenhum tipo de armazenagem identificado!")
				Return(.F.)
			EndIf
		ElseIf (nOrig==1.or.nOrig==3)
			If (AllTrim(SB1->B1_ZTIPO)=="SD") //PADRAO
				If (SB1->B1_ZQE>0)
					aAdd(aParImp[2][4],"1 - Fardos")
				EndIf
				If (SB1->B1_ZGAIOL1>0)
					aAdd(aParImp[2][4],"2 - Gaiola 1")
				EndIf
				If (SB1->B1_ZGAIOL2>0)
					aAdd(aParImp[2][4],"3 - Gaiola 2")
				EndIf
				If (SB1->B1_ZPALET>0)
					aAdd(aParImp[2][4],"4 - Palete")
				EndIf
			Else
				If (SB1->B1_ZQE>0)
					aAdd(aParImp[2][4],"1 - Fardos")
				EndIf
			EndIf
			If (Len(aParImp[2][4])<=0)
				MsgAlert("Nenhum tipo de armazenagem identificado!")
				Return(.F.)
			EndIf
		EndIf
	EndIf
	ParamBox(aParImp,"Parametros...",aRetImp,,,,,,oPanel)

	aSvPar := {}

	For nMv := 1 To 40
		aAdd( aSvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
	Next nMv                     

Return(.T.)

Static Function Imprime(nOrig)
/************************************************************************************
*
*
**/
	Local cLocImp	:= MV_PAR01
	Local cTipo		:= ""
	Local nQtde		:= 0
	Local nToler	:= 0
	Local nQTDDiv	:= 0
	Local nQTDEtiq	:= 0
	Local nQTDRes	:= 0
	Local nSA		:= 0
	Local cEtqAnt	:= ""
	Local cOPEtq	:= ""
	Local nX, nI
	Local nPosEti	:= 0
	Local nTOTEti	:= Len(aLbx)
	Local cEtiLOG	:= ""
	Local cNumOP	:= ""
	Local nQtdApon	:= 0
	Private aRecCB0	:= {}

	If (nOrig!=2)//DIFERENTE DE REIMPRESSAO
		cTipo:= MV_PAR02 //1 - Fardos | 2 - Gaiola 1 | 3 - Gaiola 2 | 4 - Palete
		cTipo:= SubStr(AllTrim(cTipo),1,1)
	EndIf

	If !MsgYesNo("Confirma a Impressao de Etiquetas?")
		Return(.F.)
	EndIf

	//ProcRegua(nTOTEti)
	//ProcessMessages()

	For nX:= 1 to Len(aLbx)   
		//nPosEti++
		//IncProc(OemToAnsi("Processando etiqueta "+AllTrim(Str(nPosEti))+" de "+AllTrim(Str(nTOTEti))+"."))
		//ProcessMessages()

		If !aLbx[nx,1]
			Loop
		EndIf	

		/*
		If (nOrig==2)//REIMPRESSAO
			cTipo:= AllTrim(aLbx[nX][7]) //1 - Fardos | 2 - Gaiola 1 | 3 - Gaiola 2 | 4 - Palete
		EndIf
		*/

		cEtqAnt:= ""
		Do case 
		case (nOrig==1)
			cOPEtq	:= AllTrim(aLbx[nX,2])
			nQtdApon:= aLbx[nX,7]
		CASE (nOrig==2)//TRATAMENTO PARA REIMPRESSAO
			dbSelectArea("CB0")
			CB0->(DbSetOrder(1))
			If !CB0->(dbSeek(xFilial("CB0")+aLbx[nX,2]))
				MsgAlert("Etiqueta "+AllTrim(aLbx[nX,2])+" nao encontrada.")
				Loop
			Else
				aAdd(aRecCB0,CB0->(RecNo()))
				Loop
			EndIf	

		Case nOrig == 3 // Tratamento semi-acabado 
			dbSelectArea("SC2")
			SC2->(DbSetOrder(1))
			If !SC2->(dbSeek(xFilial("SC2")+aLbx[nX,2]))
				MsgAlert("OP "+AllTrim(aLbx[nX,2])+" nao encontrada.")
				Loop
			Else
				nQtdApon:= aLbx[nX,5]
				nQTDDiv:= Round(SB1->B1_ZGAIOL1,3)
				if SB1->B1_ZGAIOL1 == 0 
				  ALERT("CAMPO: SB1-.>B1_ZGAIOL1 ZERADO !")
				ENDIF
				nQtde	:= Round(nQtdApon,3) //QTD APONTADA

				// nQTDEtiq:= Int((nQtde/nQTDDiv))

				nQTDRes	:= aLbx[nX,7]

				cOPEtq	:= AllTrim(aLbx[nX,2])
				cEtqAnt	:= ""
				dbSelectArea("CB0")
				CB0->(DbSetOrder(1))
				cTipo:= AllTrim(aLbx[nX][7]) //1 - Fardos | 2 - Gaiola 1 | 3 - Gaiola 2 | 4 - Palete
				For nSa:=1 To ((aLbx[nX,7])/nQTDDiv)
					fGravaCB0((nQTDDiv),AllTrim(cTipo),cEtqAnt,cOPEtq)
					ImpSA(nSa)
				Next
				nx++
				Loop
			EndIf	
		

		case nOrig==4  /// TRATAMENTO PARA FRAGMENTACAO | REMOVER REGISTRO DA CB0
			nQtdApon:= aLbx[nX,6]
			cOPEtq	:= AllTrim(aLbx[nX,5])
			cEtqAnt	:= AllTrim(aLbx[nX,2])
			dbSelectArea("CB0")
			CB0->(DbSetOrder(1))
			If !CB0->(dbSeek(xFilial("CB0")+aLbx[nX,2]))
				MsgAlert("Etiqueta "+AllTrim(aLbx[nX,2])+" nao encontrada.")
				Loop
			Else
				If RecLock("CB0",.F.)
					CB0->(dbDelete())
					CB0->(MsUnLock())
				EndIf
			EndIf		
		ENDCASE

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+aLbx[nx,3]))
			If (Len(aLbx[nx])<=7) //SE O ARRAY FOR MENOR OU IGUAL A 7 SIGNIFICA QUE NAO É PRODUTO ESPECIAL
				nToler	:= Round(SB1->B1_ZTOLER,3)
				nQtde	:= Round(nQtdApon,3) //QTD APONTADA
				If (AllTrim(cTipo)=="1") //FARDO
					nQTDDiv:= Round(SB1->B1_ZQE,3)
					If (nQtde<nQTDDiv)
						nQTDDiv:= 0
					EndIf
				ElseIf (AllTrim(cTipo)=="2") //GAIOLA 1
					nQTDDiv:= Round(SB1->B1_ZGAIOL1,3)
				ElseIf (AllTrim(cTipo)=="3") // GAIOLA 2
					nQTDDiv:= Round(SB1->B1_ZGAIOL2,3)
				Else //PALETE
					nQTDDiv:= Round(SB1->B1_ZPALET,3)
				EndIf
				nQTDEtiq:= Int((nQtde/nQTDDiv))
				//nQTDRes	:= Round((nQtde-(nQTDDiv*nQTDEtiq)),3)
				nQTDRes	:= Round((nQtde-(nQTDEtiq*nQTDDiv)),3)

				If (nQTDRes>0) //TRATAR O RESTO SEMPRE COMO FARDO
					If (AllTrim(cTipo)=="1") //FARDO
						If (nToler>0) //SE HOUVER TOLERANCIA DEVE VALIDAR A TOLERANCO PRA VER SE CRIA NO FARDO OU ADICIONA JUNTO A OUTRO ITEM
							//If ((Round((nQTDRes/nQTDDiv),3)*100)<=nToler) //SE ESTIVER DENTRO DA TOLERANCIA
							If (nQTDRes<=nToler) //SE ESTIVER DENTRO DA TOLERANCIA
								nQTDEtiq--
								fGravaCB0((nQTDRes+nQTDDiv),"1",cEtqAnt,cOPEtq)
							Else //SE ESTIVER FORA DA TOLERANCIA
								fGravaCB0(nQTDRes,"1",cEtqAnt,cOPEtq)
							EndIf
						Else //25/06/2020 - SOLICITACAO EDMAR NOS TESTES - SE NAO HOUVER TOLERANCIA NAO DEVE CRIAR ETIQUETA.
							//fGravaCB0(nQTDRes,"1",cEtqAnt,cOPEtq)
						EndIf
					Else //SE NAO FOR FARDO DEVE SEMPRE GERAR UM NOVO FARDO COM O RESTANTE DOS PACOTES
						If (nQTDEtiq<=0)
							fGravaCB0(nQTDRes,"1",cEtqAnt,cOPEtq)
						Else
							If MsgYesNo("Deseja gerar etiqueta de palete para esta quebra? Quantidade= "+AllTrim(Str(nQTDRes)))
								fGravaCB0(nQTDRes,"1",cEtqAnt,cOPEtq)
							EndIf
						EndIf
					EndIf
				EndIf
			Else//SE FOR PRODUTOS ESPECIAIS DEVE PEGAR AS QUANTIDADES INFORMADAS PELO USUARIO
				nQTDEtiq:= aLbx[nx][8]
				nQTDDiv	:= aLbx[nx][9]
			EndIf

			For nI:= 1 To nQTDEtiq
				fGravaCB0(nQTDDiv,AllTrim(cTipo),cEtqAnt,cOPEtq)
			Next nI
		EndIf
	Next nX

	//APOS GRAVAR DEVE IMPRIMIR A ETIQUETA
	If (Len(aRecCB0)>0)
		Do Case 
			Case nOrig == 3
				// Alert("Em desenvolvimento")
			OTHERWISE

				If !CB5SetImp(cLocImp)  
					MsgAlert("Local de Impressao "+cLocImp+" nao Encontrado!")
					Return(.F.)
				EndIf	
				MSCBChkStatus(.F.)
		  		 cEtiLOG:= "Processo de geracao finalizado."+_ENTER+_ENTER+"Etiquetas geradas:"+_ENTER
		  		For nI:=1 To Len(aRecCB0)
				 dbSelectArea("CB0")
				 CB0->(dbGoTo(aRecCB0[nI]))
			 	   If !CB0->(Eof())
					  DbSelectArea("SB1")
					  SB1->(DbSetOrder(1))
					   If SB1->(DbSeek(xFilial("SB1")+CB0->CB0_CODPRO))
							cEtiLOG	+= AllTrim(CB0->CB0_CODETI)+" - "+AllTrim(CB0->CB0_CODPRO)+" "+AllTrim(SB1->B1_DESC)+" - "+AllTrim(Str(CB0->CB0_QTDE))+_ENTER
							cNumOP	:= AllTrim(CB0->CB0_OP)+Space(TamSX3("D3_OP")[1]-Len(AllTrim(CB0->CB0_OP))) //FOI CRIADA ESTA VARIAVEL PORQUE O CAMPO CB0_OP ESTA COM TAMANHO DIFERENTE DE D3_OP
							MSCBBEGIN(1,6,90) //124.5 Tamanho da etiqueta     
							MSCBBOX(15,02,87,48) //COLUNA | LINHA | COLUNA | LINHA					
							If (nOrig==2)//TRATAMENTO PARA REIMPRESSAO
								MSCBSAY(65,04,"REIMPRESSAO","N","0","020,020")
							EndIf
							IIf (SM0->M0_CODIGO=="02",MSCBSAY(19,04,"Empresa: Isotech","N","0","040,040"),MSCBSAY(19,04,"Empresa: Prestige","N","0","040,040"))
							MSCBSAY(63,07,dToc(CB0->CB0_DTNASC),"N","0","020,020")
							MSCBSAY(76,07,CB0->CB0_ZHORA,"N","0","020,020")
        			           //       col,linha					
							MSCBSAY(19 ,12,AllTrim(CB0->CB0_CODPRO),"N","0","025,025")
							MSCBSAY(35 ,12,SubStr(AllTrim(SB1->B1_DESC),1,45),"N","0","025,025")
							//MSCBSAY(12,20,SubStr(AllTrim(SB1->B1_DESC),51,50),"N","0","025,025")
							DbSelectArea("SC6")
							DbSetOrder(1)
							DBSEEK(xfilial("SC6")+SC2->C2_PEDIDO)
							DbSelectArea("SA1")
							DbSetOrder(1)
							MSCBSAY(19,18,"CLIENTE:","N","0","020,020")	
							if DBSEEK( xfilial("SA1")+SC6->C6_CLI )
							  MSCBSAY(32,18,ALLTRIM(SA1->A1_NREDUZ),"N","0","030,030")
							ENDIF
							MSCBSAY(19,23,SB1->B1_XCODCLI,"N","0","030,030")
							MSCBSAY(50,23,SB1->B1_XMODELO,"N","0","030,030")
							MSCBSAY(19,30,"PV : ","N","0","020,020")
							MSCBSAY(19,33,AllTrim(SC2->C2_PEDIDO),"N","0","030,030")
							MSCBSAY(33,30,"OP","N","0","020,020")
							MSCBSAY(33,33,ALLTRIM(CB0->CB0_OP),"N","0","030,030")
							/*/
							 MSCBSayBar( nXmm, nYmm ,cConteudo ,cRotaÁ„o ,cTypePrt ,
							 [ nAltura ] ,[ *lDigver ] ,[ lLinha ] ,[ *lLinBaixo ] ,[ cSubSetIni ],
							 [ nLargura ] ,[ nRelacao ] ,[ lCompacta ] ,[ lSerial ] ,[ cIncr ], [ lZerosL ] )

							/*/
							// MSCBSAYBAR(50,31,CB0->CB0_OP,"N","MB07",7,.F.,.F.,.F.,,2,1,.T.,.F.,"1",.T.)
							MSCBSAY(60,30,"QTD","N","0","020,020")
							MSCBSAY(60,33,AllTrim(Str(CB0->CB0_QTDE))+" "+SB1->B1_UM,"N","0","030,030")
							//IIF(SB1->B1_GRUPO=="3026",MSCBSAY(73,30,"c/b","N","0","030,030"),"")
							//IIF(SB1->B1_GRUPO=="3026",MSCBSAY(75,33,SB1->B1_XTPCALC,"N","0","030,030"),"")
							// MSCBSAYBAR(40,40,STR(CB0->CB0_QTDE),"N","MB07",7,.F.,.F.,.F.,,3,2,.F.,.F.,"1",.T.)
							MSCBSAYBAR(19,37,CB0->CB0_CODETI,"N","MB07",6,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
							MSCBSAY(65,38,"Rohs OK","N","0","040,040")
							MSCBEND()			
						EndIf
			    	EndIf
		    	Next nI
				MSCBCLOSEPRINTER()
	    ENDCASE
		
		//Help( " ",1,"MENSGERETIQ",,cEtiLOG,3,1)
		lVotar:= .F.
	elseif nOrig # 3
		
		MsgAlert("Nenhuma etiqueta gerada!")
		Return(.F.)
	EndIf
Return(.T.)

Static Function fEmitOP(cOp)
/*************************************************************************************
*Função para retornar quantas etiquetas foram emitidas para determinada OP.
*Não pode emitir mais etiquetas que produto apontado na SD3
*Keure em 03/06/2020
**/
	Local nQtde	:= 0
	Local nToler:= 0
	Local nGaio1:= 0
	Local nGaio2:= 0
	Local nPale	:= 0
	Local nPct	:= 0

	DbSelectArea("CB0")
	CB0->(DbSetOrder(7))
	If CB0->(DbSeek(xFilial("CB0")+Alltrim(cOp)))
		Do While !CB0->(Eof()) .And. CB0->CB0_FILIAL==xFilial("CB0") .And. AllTrim(CB0->CB0_OP)==Alltrim(cOp)
			nQtde+= CB0->CB0_QTDE

			DbSelectArea("CB0")
			CB0->(DbSkip())
		EndDo
		/*
		//Verificar o tipo da etiqueta, pois cada uma tem um comportamento de cálculo
		//precisamos voltar para quantidade de pacotes, pois sempre é apontado na OP em pacotes
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+CB0->CB0_CODPRO))
			nToler	:= SB1->B1_ZTOLER
			nGaio1	:= SB1->B1_ZGAIOL1
			nGaio2	:= SB1->B1_ZGAIOL2
			nPale	:= SB1->B1_ZPALET
			nPct	:= SB1->B1_ZPCT
			nQE		:= SB1->B1_ZQE
		EndIf

		If (AllTrim(CB0->CB0_ZTIPO)=="1") //Fardos
			nQtde+= nQE
		ElseIf (AllTrim(CB0->CB0_ZTIPO)=="2") //Gaiola 1
			nQtde+= nGaio1
		ElseIf (AllTrim(CB0->CB0_ZTIPO)=="3") //Gaiola 2
			nQtde+= nGaio2
		ElseIf (AllTrim(CB0->CB0_ZTIPO)=="4") //Palete
			nQtde+= nPale
		Endif
		*/
	EndIf
Return(nQtde)

Static Function fApont(cOp)
/********************************************************************
*Função que soma a quantidade apontada para a OP
*
**/
	Local cQuery := ""
	Local cAlias := GetNextAlias()
	Local nQuant := 0

	fCloseArea(cAlias)	
	cQuery:= " SELECT SUM(D3_QUANT) AS SOMASD3 FROM "+RetSqlName("SD3")+" "
	cQuery+= " WHERE D3_CF IN ('PR1','PR0')"
	cQuery+= " AND D3_ESTORNO = ' '"
	cQuery+= " AND D3_OP = '"+cOp+"'"
	cQuery+= " AND D3_FILIAL = '"+xFilial("SD3")+"'"
	cQuery+= " AND D_E_L_E_T_ <> '*' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
		
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	IF !(cAlias)->(Eof())
		nQuant:= (cAlias)->SOMASD3
	ENDIF
	fCloseArea(cAlias)	
Return(nQuant)

Static Function fCloseArea(pParTabe)
/***********************************************
* Funcao para verificar se existe tabela e exclui-la
*
****/
	If (Select(pParTabe)!= 0)
		dbSelectArea(pParTabe)
		(pParTabe)->(dbCloseArea())
		If File(pParTabe+GetDBExtension())
			FErase(pParTabe+GetDBExtension())
		EndIf
	EndIf
Return()

Static Function fGravaCB0(nQtd,cTP,cAntigEtq,cOPE)
/***********************************************
*
*
****/
	Local cQuery	:= ""
	Local aRecCB0	:= {}
	Local cMaxCOD	:= "0000000001"

	If (Select("QCB0")!=0)
		fCloseArea("QCB0")
	EndIf
	cQuery:= " SELECT MAX(CB0_CODETI) AS MAXETI"
	cQuery+= " FROM "+RetSqlName("CB0")+" CB0"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QCB0",.F.,.T.)
		
	DbSelectArea("QCB0")
	QCB0->(DbGoTop())
	If !QCB0->(Eof())
		cMaxCOD:= StrZero((Val(AllTrim(QCB0->MAXETI))+1),10)
	EndIf
	fCloseArea("QCB0")

	dbSelectArea("CB0")
	If RecLock("CB0",.T.)
		Replace CB0_FILIAL	With xFilial("CB0"),;
				CB0_CODETI	With cMaxCOD,;
				CB0_DTNASC	With dDataBase,;
				CB0_CODPRO	With SB1->B1_COD,;
				CB0_QTDE	With nQtd,;
				CB0_LOCAL	With AllTrim(SB1->B1_LOCPAD),;
				CB0_LOCALI	With AllTrim(SB1->B1_LOCALIZ),;
				// CB0_ZTIPO	With cTP,;
				CB0_CODET2	With cAntigEtq,;
				CB0_STSTF 	With IIF(SM0->M0_CODIGO=="01".AND.SB1->B1_TIPO="PI".AND.SB1->B1_GRUPO<>"3001","0"," "),;
				CB0_ZHORA	With TIME(),;
				CB0_OP		With cOPE
		CB0->(MsUnLock())

		aAdd(aRecCB0,CB0->(RecNo()))
	EndIf
Return()

Static Function fRetImp(nOrigem)
/************************************************************************************
*
*
**/
	Local oOk	:= LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO   
	Local lRet	:= .F.
	Local nEtiEmit:= 0

	If (nOrigem==1)
		lRet:= .T.
		oLbx:nAt:= 1
		nEtiEmit:= fEmitOP(aLbx[oLbx:nAt][2])
		aLbx[oLbx:nAt][6]:= nEtiEmit
		aLbx[oLbx:nAt][7]:= aLbx[oLbx:nAt][5]-nEtiEmit
		If (Len(aLbx[oLbx:nAt])<=7)
			oLbx:bLine:= {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7]}}
		Else
			//aLbx[oLbx:nAt][8]:= 0
			//aLbx[oLbx:nAt][9]:= 0
			//oLbx:bLine:= {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7],aLbx[oLbx:nAt,8],aLbx[oLbx:nAt,9]}}
		EndIf
		oLbx:Refresh()
	Else
		MsgAlert(OemToAnsi("Opção indisponível!"))
	EndIf
Return(lRet)

User Function fFATP11BRW()
/***************************************************************************
*
*
**/
	Private cCadastro	:= OemToAnsi("Produtos Separados")
	Private aRotina		:= {{"Pesquisar"	,"AxPesqui"	,0,1},;
							{"Visualizar"	,"AxVisual"	,0,2}}
	
	mBrowse(6,8,22,71,"CB9")
Return()

User Function fFATP11Inv()
/***************************************************************************
*
*
**/
	Local cQuery:= ""
	Local aProdu:= {}
	Local nPos	:= 0
	Local aVetor:= {}
	Local nI

	If Select("SX6") == 0
		//NAO UTILIZAR LICENCA
		RPCSetType(3)
		//PREPARA O AMBIENTE PARA EXECUÃ‡ÃƒO POR WORKFLOW
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	EndIf   

	cQuery:= " SELECT CB0_ZTIPO, CB0_CODPRO, CB0_LOCAL, CB0_QTDE, B1_ZQE "
	cQuery+= " FROM "+RetSqlName("CB0")+" CB0 "
	cQuery+= " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=CB0_CODPRO AND SB1.D_E_L_E_T_<>'*' "
	cQuery+= " WHERE CB0.D_E_L_E_T_<>'*' "
	//cQuery+= " AND CB0_CODPRO IN ('9071006','9071007','9074014','9071004','9071042','9071044','9071043') "
	cQuery+= " ORDER BY CB0_CODPRO, CB0_LOCAL "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QCB0",.F.,.T.)
		
	DbSelectArea("QCB0")
	QCB0->(DbGoTop())
	Do While !QCB0->(Eof())
		nPos:= aScan(aProdu, {|x| AllTrim(x[1])==AllTrim(QCB0->CB0_CODPRO) .And. AllTrim(x[2])==AllTrim(QCB0->CB0_LOCAL)})
		If (nPos<=0)
			aAdd(aProdu, {AllTrim(QCB0->CB0_CODPRO),AllTrim(QCB0->CB0_LOCAL),0})
			nPos:= Len(aProdu)
		EndIf

		If (AllTrim(QCB0->CB0_ZTIPO)=="1") //Fardos
			aProdu[nPos][3]+= QCB0->CB0_QTDE
		Else
			aProdu[nPos][3]+= Round((QCB0->CB0_QTDE/QCB0->B1_ZQE),3)
		EndIf

		DbSelectArea("QCB0")
		QCB0->(DbSkip())
	EndDo
	DbSelectArea("QCB0")
	QCB0->(DbCloseArea())

	For nI:= 1 To Len(aProdu)
		aVetor :=   {;
					{"B7_FILIAL", xFilial("SB7")		,Nil},;
					{"B7_COD"	, AllTrim(aProdu[nI][1]),Nil},;
					{"B7_DOC"	, "ACDDEL001"			,Nil},;
					{"B7_QUANT"	, aProdu[nI][3]			,Nil},;
					{"B7_LOCAL"	, AllTrim(aProdu[nI][2]),Nil},;
					{"B7_DATA"	, Date()				,Nil} }

		lMsErroAuto:= .F.
		MSExecAuto({|x,y,z| mata270(x,y,z)},aVetor,.T.,3)
		If lMsErroAuto
			MostraErro()
		EndIf
	Next nI

	MsgBox("Fim do processo.")
	RESET ENVIRONMENT
	RpcClearEnv()
Return()

User Function fTSTIMPCB()
	Local oDLG
	Local nMaxBot	:= 600
	Local nMaxRig	:= 800
	Local cNumOP	:= ""

	If Select("SX6") == 0
		//NAO UTILIZAR LICENCA
		RPCSetType(3)
		//PREPARA O AMBIENTE PARA EXECUÃ‡ÃƒO POR WORKFLOW
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	EndIf   

	CB5SetImp("000001")  
	// MSCBPRINTER("ZEBRA","LPT1", NIL, NIL, .F., NIL, NIL, NIL, , NIL, .F.)
	MSCBChkStatus(.F.)
	dbSelectArea("CB0")
	CB0->(dbGoTop())
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+CB0->CB0_CODPRO))
		cNumOP:= AllTrim(CB0->CB0_OP)+Space(TamSX3("D3_OP")[1]-Len(AllTrim(CB0->CB0_OP))) //FOI CRIADA ESTA VARIAVEL PORQUE O CAMPO CB0_OP ESTA COM TAMANHO DIFERENTE DE D3_OP
		MSCBBEGIN(1,6)
		//MSCBBOX(10,02,20,20) //COLUNA | LINHA | COLUNA | LINHA

		MSCBBOX(07,04,24,20)
		MSCBBOX(24,04,96,20)
		MSCBSAY(77,06,"Data: 17/06/2020","N","0","020,020")
		MSCBSAY(25,06,"REIMPRESSAO","N","0","050,050")
		MSCBSAY(25,15,"Identificacao de produto","N","0","030,030")
		MSCBBOX(07,20,96,36)
		MSCBSAY(09,22,AllTrim(CB0->CB0_CODPRO),"N","0","040,040")
		MSCBSAY(09,27,SubStr(AllTrim(SB1->B1_DESC),1,50),"N","0","025,025")
		MSCBSAY(09,32,SubStr(AllTrim(SB1->B1_DESC),51,50),"N","0","025,025")
		MSCBBOX(07,36,96,41)
		MSCBSAY(09,37,"OP: "+AllTrim(CB0->CB0_OP)+" produzida em "+AllTrim(dToc(Posicione("SD3",1,CB0->CB0_FILIAL+cNumOP+CB0->CB0_CODPRO,"D3_EMISSAO")))+".","N","0","030,030")
		MSCBBOX(07,41,96,46)
		MSCBSAY(09,42,"Quantidade:","N","0","030,030")
		MSCBSAY(30,42,AllTrim(Str(CB0->CB0_QTDE)),"N","0","030,030")
		MSCBSAYBAR(22,40,CB0->CB0_CODETI,"N","MB07",7,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)
		sConteudo:=MSCBEND()
	EndIf
	MSCBCLOSEPRINTER()
	DEFINE MSDIALOG oDlg FROM 000,000 TO nMaxBot,nMaxRig PIXEL TITLE OemToAnsi("Etiqueta")
	TMultiGet():New(005,005,{|u| if(PCount()>0,sConteudo:=u,sConteudo)},oDlg,(nMaxRig/2)-5,(nMaxBot/2)-5,,.T.,,,,.T.,OemToAnsi("Etiqueta"),,,,,.F.)
	Activate MsDialog oDlg Center

	RESET ENVIRONMENT
	RpcClearEnv()
Return()



/*/{Protheus.doc} AWzVSA
	(long_description)
	@type  Static Function
	@author user
	@since 29/12/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function AWzVSA()
	Local cOp	:= Padr(MV_PAR01,TamSx3("D3_OP")[1])
	Local nQE
	Local oOk	:= LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO   
	Local nQSD3 := 0
	Local nQSC2 := 0
	Local nSaldo := 0
	Local nEtiEmit := 0

	If Empty(cOp).or.Len(Alltrim(cOP))<=6
		MsgAlert("Informar o codigo da ordem de producao com Item e Sequencia ")
		Return(.F.)
	EndIf    

	//Somar tudo aquilo que foi apontado na OP
	//nQSD3:= fApont(cOp)

	aLbx:= {}
	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	If SC2->(DbSeek(xFilial("SC2")+Alltrim(cOp)))
		nQSC2:= SC2->C2_QUANT
		//Somar quantas etiquetas já foram emitidas para essa OP
		nEtiEmit:= fEmitOP(cOp)
		nQTDDiv:= Round(SB1->B1_ZGAIOL1,3)
		nSaldo:= nQSC2 - (nEtiEmit/nQTDDiv)

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			If !(AllTrim(SB1->B1_ZTIPO)$"EP|ES")
				If nQSC2 > 0 .And. nSaldo > 0 // ainda tem saldo pra gerar etiquetas
				    // Alert("1a chamada do ListBoxMar")
					// pra condicionar quantidade a imprimir 
					
					nQtde	:= nSaldo //QTD APONTADA
					nQTDEtiq:= Int((nQtde/nQTDDiv)) 

					aadd(aLbx,{.F.,Alltrim(cOp),SB1->B1_COD,SB1->B1_DESC,nQSC2,nEtiEmit,nQTDEtiq})
					ListBoxMar(oWizard:GetPanel(4))
					oLbx:SetArray( aLbx )
					oLbx:bLine:= {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7]}}
				Else
					MsgAlert("Nao existe saldo de apontamento de OP para gerar novas etiquetas.")
					Return(.F.)
				EndIf
			Else
				nQTDDiv:= Round(SB1->B1_ZGAIOL1,3)
				nQtde	:= nSaldo //QTD APONTADA
				nQTDEtiq:= Int((nQtde/nQTDDiv)) 

			   	//Alert("2a chamada do ListBoxMar")
				aadd(aLbx,{.F.,Alltrim(cOp),SB1->B1_COD,SB1->B1_DESC,nQSC2,nEtiEmit,nQTDEtiq})
				ListBoxMar(oWizard:GetPanel(4))
				oLbx:SetArray( aLbx )
				oLbx:bLine := {|| {Iif(aLbx[oLbx:nAt,1],oOk,oNo),aLbx[oLbx:nAt,2],aLbx[oLbx:nAt,3],aLbx[oLbx:nAt,4],aLbx[oLbx:nAt,5],aLbx[oLbx:nAt,6],aLbx[oLbx:nAt,7]}}
			EndIf


		Else
			MsgAlert("Produto nao localizado.")
			Return(.F.)
		EndIf
	Else
		MsgAlert("Nenhuma OP localizada.")
		Return(.F.)
	EndIf
	oLbx:Refresh()
Return(.T.)


Static Function ImpSA(nETQ)
Local lAdjustToLegacy := .F.
Local lDisableSetup := .T.
Local cLocal := "\spool"
Local oPrint  := Nil
Local cNomeCli :=""
Private oFont06 := TFont():New('Arial',9,06,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont07 	    := TFont():New('Arial',9,07,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont08 	    := TFont():New('Arial',9,08,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont09 	    := TFont():New('Arial',9,09,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont10 	    := TFont():New('Arial',9,10,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont11 	    := TFont():New('Arial',9,11,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont12 	    := TFont():New('Arial',9,12,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont13 	    := TFont():New('Arial',9,13,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont14 	    := TFont():New('Arial',9,14,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont17 	    := TFont():New('Arial',9,17,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont20 	    := TFont():New('Arial',9,20,.T.,.T.,5,.T.,5,.T.,.F.)



	SB1->(DbSetOrder(1))
	If !SB1->(DbSeek(xFilial('SB1')+SC2->C2_PRODUTO))
		MsgAlert("Produto nao encontrado")
		Return(.F.)
	EndIf    

	If !CBImpEti(SB1->B1_COD)
		MsgAlert("Este Produto esta configurado para nao imprimir etiqueta")
		Return(.F.)
	EndIf 
    

// cLocal := GetTempPath(.T.,.T.) // C:\DOCUME~1\ADMINI~1\CONFIG~1\Temp\2\
cLocal := GetTempPath() // C:\DOCUME~1\ADMINI~1\CONFIG~1\Temp\2\



/*
GetTempPath([lLocal], [lWeb])
Parâmetros
lLocal - lógico
Indica se verdadeiro (.T.), é procurado o diretório temporário do SmartClient ou, falso (.F.), do Application Server. Valor padrão: .T.
lWeb - lógico	Força o retorno do diretorio web temporario (para uso no SmartClient HTML). Valor padrão: .F.	

Retorno
cRet
caractere
Retorna o caminho da pasta temporária do sistema atual.
*/

// FErase( clocal+cFile+".pdf" )

// oPrint := TMSPrinter():New(OemToAnsi('Codigo de barras semi acabado'))
// oPrint:SetPortrait() // tmsprinter
// oPrint:Setup()  // tmsprinter

// oPrint:= FWMSPrinter():New("etiqueta.rel", IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
// IMP_SPOOL
oPrint:= FWMSPrinter():New("etiqueta.rel",, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
oPrint:Setup()
//oPrint:setDevice(IMP_PDF)
oPrint:cPathPDF := cLocal
// oPrinter:SetResolution(72)
oPrint:SetPortrait()
// oPrinter:SetPaperSize(DMPAPER_A4) 
// oPrinter:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior 
oPrint:StartPage()  // tmsprinter
// TMSPrinter(): Box ( [ nRow], [ nCol], [ nBottom], [ nRight], [ uParam5] ) -
// oPrint:Box( 10,10,600,900 )
nLin := 06
ncol := 07
nSalto := 20
oPrint:Say( nLin, ncol+10, "Etiqueta Produto Semiacabado:")
oPrint:Say(nLin, ncol+130, "Data:"+Dtoc(dDataBase))
nLin += 13							
oPrint:Say(nLin, ncol+130, "Hora:"+Time())


// oPrinter:Say( 33,10,"REIMPRESSAO",oFont10,,,,3)	
nLin += nSalto							
oPrint:Say( nLin,ncol,"Empresa: "+SM0->M0_NOME,oFont10,,,,3)		
nLin += nSalto
oPrint:Say( nLin,ncol,AllTrim(SC2->C2_PRODUTO),oFont14,,,,3)	
nLin += nSalto
oPrint:Say(nLin,ncol,SubStr(AllTrim(SB1->B1_DESC),1,45),oFont14,,,,3)
nLin += nSalto
oPrint:Say(nLin,ncol,SubStr(AllTrim(SB1->B1_DESC),46,50),oFont10,,,,3)
nLin += nSalto

DbSelectArea("SC6")
DbSetOrder(1)
if DBSEEK(xfilial("SC6")+SC2->C2_PEDIDO)
DbSelectArea("SA1")
DbSetOrder(1)
  DBSEEK( xfilial("SA1")+SC6->c6_cli )
  cNomeCli := SA1->A1_NREDUZ
Else 
  dbSelectArea("SBM")
  dbSeek(xfilial("SBM")+SB1->B1_GRUPO)
  cNomeCli := SBM->BM_DESC
Endif 
oPrint:Say(nLin,ncol,"CLIENTE:",oFont10,,,,3)	
oPrint:Say(nLin,50,cNomeCli,oFont10,,,,3)
nLin += nSalto
oPrint:Say(nLin,ncol,SB1->B1_XCODCLI,oFont10,,,,3)
nLin += nSalto
oPrint:Say(nLin,ncol,SB1->B1_XMODELO,oFont10,,,,3)
nLin += nSalto
oPrint:Say(nLin,ncol,"Operador:     ",oFont10,,,,3)
oPrint:Say(nLin,ncol+60,"Turno:     ",oFont10,,,,3)
nLin += nSalto
oPrint:Say(nLin,ncol,"OP:",oFont10,,,,3)
oPrint:Say(nLin,ncol+20,ALLTRIM(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN),oFont10,,,,3)
oPrint:Say(nLin,ncol+110,"QTD:",oFont10,,,,3)
oPrint:Say(nLin,ncol+130,AllTrim(Str(CB0->CB0_QTDE))+" "+SB1->B1_UM,oFont10,,,,3)
nLin += nSalto
oPrint:Say(nLin,ncol,"Etiqueta: "+Space(1)+CB0->CB0_CODETI,oFont10,,,,3)
oPrint:Say(nLin,ncol+110,"Rohs OK",oFont17,,,,3)
//Impressao Codigo de Barra
nLinC		:= 19.00	//Linha que será impresso o Código de Barra
nColC		:= 0.5		//Coluna que será impresso o Código de Barra
nWidth	 	:= 0.0164	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
nHeigth   	:= 0.3		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
lBanner		:= .F.		//Se imprime a linha com o código embaixo da barra. Default .T.
nPFWidth	:= 60		//Número do índice de ajuste da largura da fonte. Default 1
nPFHeigth	:= 60		//Número do índice de ajuste da altura da fonte. Default 1
lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
oPrint:FWMSBAR("CODE128" , nLinC , nColC,CB0->CB0_CODETI , oPrint,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,lBanner,/*oFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
//TmsPrinter
oPrint:EndPage()

If nETQ == 1 .AND. CB0->CB0_QTDE # 0
	oPrint:Preview()
	FreeObj(oPrint)
    oPrint := Nil
	Return
EndIf 

IF CB0->CB0_QTDE == 0
	Alert("ETIQUETA ZERADA NADA A IMPRIMIR - AJUSTE NA TABELA CB0 ")
EndIf

if oPrint:nModalResult == PD_OK .AND. CB0->CB0_QTDE # 0
	oPrint:Preview()
EndIf

FreeObj(oPrint)
oPrint := Nil

Return
