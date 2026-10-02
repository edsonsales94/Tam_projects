#include "totvs.ch"
#INCLUDE "topconn.ch"
#include 'protheus.ch'
#include "TbiConn.ch"

// Alinhamento do método addInLayout
#define LAYOUT_ALIGN_LEFT     1
#define LAYOUT_ALIGN_RIGHT    2
#define LAYOUT_ALIGN_HCENTER  4
#define LAYOUT_ALIGN_TOP      32
#define LAYOUT_ALIGN_BOTTOM   64
#define LAYOUT_ALIGN_VCENTER  128

// Alinhamento para preenchimento dos componentes no TLinearLayout
#define LAYOUT_LINEAR_L2R 0 // LEFT TO RIGHT
#define LAYOUT_LINEAR_R2L 1 // RIGHT TO LEFT
#define LAYOUT_LINEAR_T2B 2 // TOP TO BOTTOM
#define LAYOUT_LINEAR_B2T 3 // BOTTOM TO TOP

#define ALIGN_LEFT          1
#define ALIGN_LEFT_VC       2 // VC = Vertical Centered
#define ALIGN_CENTER        3
#define ALIGN_CENTER_VC     4
#define ALIGN_RIGHT         5
#define ALIGN_RIGHT_VC      6

user function ETTCP01x()
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' TABLES "SX2" MODULO 'FAT'   USER "ADMIN" PASSWORD "Amazonas2027*!"
	//PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' TABLES "SX2" MODULO 'FAT'   USER "ADMIN" PASSWORD "99"
	DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE 'Janela Principal'
	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT (  MsgRun( "Aguarde Processamento" ,, { || u_ETTECP01() } ), oMainWnd:End() )
	//ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT (  MsgRun( "Aguarde Processamento" ,, { || u_zExe134() } ), oMainWnd:End() )
	//ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT (  MsgRun( "Aguarde Processamento" ,, { || teste(oMainWnd) } ), oMainWnd:End() )
	RESET ENVIRONMENT
Return
User Function ETTECP01()
	Local oStepWiz	As Object
	Local o1stPage	As Object
	Local o2stPage	As Object
	Local o3stPage	As Object
	Local aCoords	As Array

	Private cAliasTmp := GetNextAlias()
	Private cPath    :=upper(Alltrim(GetMv('KD_FN01_06',,'c:\TMP\')))//Pasta padrão dos Arquivos csv
	Private cFileCSV    := ''
	Private aProcesso:={}
	Private aLancto:={}
	Private cNameTabTmp
	Private aCampos

	Private aOrdemServ      :={}
	Private dDtPrvInicial   :=Date()
	Private dDtPrvFinal     :=Date()
	Private dDtAgenda	    :=Date()
	Private cTurnoAgenda    :="M"
 	Private aCbmTurno    	:={'M=Manhã', 'T=Tarde', 'N=Noite'}  
	Private aCbmModTransp	:={'T=Terrestre', 'F=Fluvial'}  
	Private cPrvTurno       :="   "
	Private cModTransp      :=" "
	Private cStatusSO       :="    "
	Private aDataOS         :={}
	Private aHeadCampos     :={}
	Private aAtendimento    :={}
	Private aRotas          :={}
	Private aRotaAtual      :={}
	Private aEquipes        :={}
	Private aMembros        :={}
	Private aEquipeAtual    :={}
	Private aAddEquipe    	:={}
	Private oColBrOS , oBrOS
	Private oColBrGrp, oBrGrp
	Private oColBrRota, oBrRota
	Private oColBrFunc, oBrEquipe,oPlBrwEq
	Private oTreeRota		:=nil 
	Private oTreeMembros	:=nil 
	Private oTreeEqui		:=nil 
	Private oTreAddEq		:=nil 
	Private oTreZX2			:=nil  //Agendamento 
	Private cNumAtend       :=""
	Private nIdxRota		:=0
	Private nIdxEquipe		:=0
	Private oFont1
	Private oFontCabec

	Private oBrw1
	Private oBrw2

    /* Define o tipo e tamanho da fonte */
	Define Font oFont1     Name "Verdana" Size 9,18
	Define Font oFontCabec Name "Verdana" Bold Size 7,18

	aCoords := FWGetDialogSize()
 	oStepWiz := FWWizardControl():New(/*oDlg*/,{aCoords[3]*0.97 , aCoords[4]*0.97})
	oStepWiz:ActiveUISteps()


	o1stPage := oStepWiz:AddStep("1STSTEP",{|Panel| Tela_Pg1(Panel)})
	o1stPage:SetStepDescription(OemToAnsi('Seleção de O.S.'))
	o1stPage:SetNextTitle(OemToAnsi('Avançar'))
	o1stPage:SetNextAction({|| Val_Pg1() })
	o1stPage:SetCancelAction({|| .T.})

	o2stPage := oStepWiz:AddStep("2STSTEP",{|Panel| Tela_Pg2(Panel)})
	o2stPage:SetStepDescription(OemToAnsi('Formação de Equipe'))
	o2stPage:SetNextTitle(OemToAnsi('Avançar'))
	o2stPage:SetNextAction({|| Val_Pg2() })
	o2stPage:SetCancelAction({|| .T.})
	o2stPage:SetPrevWhen({|| .F. })
    //o2stPage:SetPrevAction({|| ConOut('Ação não permitida'), .F.})

	o3stPage := oStepWiz:AddStep("3STSTEP",{|Panel| Tela_Pg3(Panel)})
	o3stPage:SetStepDescription(OemToAnsi('Atendimento x Equipe'))
	o3stPage:SetNextTitle(OemToAnsi('Finalizar'))
	o3stPage:SetNextAction({|| Val_Pg3() })
	o3stPage:SetCancelAction({|| .T.})
	//o3stPage:SetPrevAction({|| ConOut('Ação não permitida'), .F.})
	o3stPage:SetPrevWhen({|| .F. })

	oStepWiz:Activate()
  
    /* DestrÃ³i o objeto no fechamento total do Wizard */
    oStepWiz:Destroy()	
	ConfirmSX8()
Return



Static Function Tela_Pg1(oPanel)

	Define Font oFont1     Name "Verdana" Size 7,15
	Define Font oFontCabec Name "Verdana" Bold Size 7,15
	oBodyLyt := tLinearLayout():New(oPanel, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, ,)

	// Divide Frame central com 3 Paineis
	oPaneTopo := tPanel():New(0,0,,oBodyLyt,,.T.,,,,0,0)
	oPaneCentro:= tPanel():New(0,0,,oBodyLyt,,.T.,,,,0,0)
	oPaneRodape := tPanel():New(0,0,,oBodyLyt,,.T.,,,,0,0)
	oBodyLyt:addInLayout(oPaneTopo,,10)
	oBodyLyt:addInLayout(oPaneCentro,,80)
	oBodyLyt:addInLayout(oPaneRodape,,10)

	//Topo
	oTopPLyt:= tLinearLayout():New(oPaneTopo, LAYOUT_LINEAR_L2R, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	//oTopPLyt:SetCSS("QFrame{ padding: 7px; background-color: #a5d0f5;}")
	oTopPLyt:setCss("QWidget{padding: 7px;}")

	oSayDtPrvIni  := TSay():New(,,{||'Dt.Prevista.:'},oTopPLyt,,oFontCabec,,,,.T.,,,50,10)
	oDtDtPrvIni   := TGet():New( /*nRow*/,/*nCol*/ ,/*bSetGet*/ { | u | If( PCount() == 0, dDtPrvInicial, dDtPrvInicial := u ) },/*oWnd*/oPaneTopo,/*nWidth*/25,/*nHeight*/ 010,/*cPict*/ "@D",/* bValid */, CLR_BLUE, CLR_HGRAY,oFont1,/*uParam12*/ ,/*uParam13*/ ,.T./*lPixel*/ ,/*uParam15*/ ,/*uParam16*/ ,/*bWhen*/ ,/*uParam18*/,/*uParam19*/,/*bChange*/,/*lReadOnly*/ .f. , /*lPassword*/.F. ,/*uParam23*/,/*cReadVar*/ "dDtPrvInicial",/*uParam25*/,/*uParam26*/,/*uParam27*/,/*lHasButton*/.f., /*lNoButton*/.f.,/*uParam30*/ .f.,/*cLabelText*/,/*nLabelPos*/,/*oLabelFont*/oFont1,/*nLabelColor*/CLR_BLACK,/*cPlaceHold*/, /*lPicturePriority*/,/*lFocSel*/)
	oDtDtPrvFin   := TGet():New( /*nRow*/,/*nCol*/ ,/*bSetGet*/ { | u | If( PCount() == 0, dDtPrvFinal  , dDtPrvFinal := u ) },/*oWnd*/oPaneTopo,/*nWidth*/25,/*nHeight*/ 010,/*cPict*/ "@D",/* bValid */, CLR_BLUE, CLR_HGRAY,oFont1,/*uParam12*/ ,/*uParam13*/ ,.T./*lPixel*/ ,/*uParam15*/ ,/*uParam16*/ ,/*bWhen*/ ,/*uParam18*/,/*uParam19*/,/*bChange*/,/*lReadOnly*/ .f. , /*lPassword*/.F. ,/*uParam23*/,/*cReadVar*/ "dDtPrvFinal",/*uParam25*/,/*uParam26*/,/*uParam27*/,/*lHasButton*/.f., /*lNoButton*/.f.,/*uParam30*/ .f.,/*cLabelText*/,/*nLabelPos*/,/*oLabelFont*/oFont1,/*nLabelColor*/CLR_BLACK,/*cPlaceHold*/, /*lPicturePriority*/,/*lFocSel*/)
	oTopPLyt:addInLayout(oSayDtPrvIni)
	oTopPLyt:addInLayout(oDtDtPrvIni)
	oTopPLyt:addInLayout(oDtDtPrvFin)

 	oSayTurnoPrv  := TSay():New(,,{||'Turno.Prv.:'},oTopPLyt,,oFontCabec,,,,.F.,,,50,10)
	oGetTurnoPrv  := TGet():New( /*nRow*/,/*nCol*/ ,/*bSetGet*/ { | u | If( PCount() == 0, cPrvTurno, cPrvTurno := u ) },/*oWnd*/oPaneTopo,/*nWidth*/30,/*nHeight*/ 010,/*cPict*/ "@D",{||u_fTurno()}/* bValid */, CLR_BLUE, CLR_HGRAY,oFont1,/*uParam12*/ ,/*uParam13*/ ,.T./*lPixel*/ ,/*uParam15*/ ,/*uParam16*/ ,/*bWhen*/ ,/*uParam18*/,/*uParam19*/,/*bChange*/,/*lReadOnly*/ .f. , /*lPassword*/.F. ,/*uParam23*/,/*cReadVar*/ "cPrvTurno",/*uParam25*/,/*uParam26*/,/*uParam27*/,/*lHasButton*/.f., /*lNoButton*/.f.,/*uParam30*/ .f.,/*cLabelText*/,/*nLabelPos*/,/*oLabelFont*/oFont1,/*nLabelColor*/CLR_BLACK,/*cPlaceHold*/, /*lPicturePriority*/,/*lFocSel*/)
	oTopPLyt:addInLayout(oSayTurnoPrv)
	oTopPLyt:addInLayout(oGetTurnoPrv)

	oSayMdTransp  := TSay():New(,,{||'Md.Transp.:'},oTopPLyt,,oFontCabec,,,,.T.,,,50,10)
	//oGetMdTransp  := TGet():New( /*nRow*/,/*nCol*/ ,/*bSetGet*/ { | u | If( PCount() == 0, cModTransp, cModTransp := u ) },/*oWnd*/oPaneTopo,/*nWidth*/25,/*nHeight*/ 010,/*cPict*/ "@D",{||u_fMdTransp() }/* bValid */, CLR_BLUE, CLR_HGRAY,oFont1,/*uParam12*/ ,/*uParam13*/ ,.T./*lPixel*/ ,/*uParam15*/ ,/*uParam16*/ ,/*bWhen*/ ,/*uParam18*/,/*uParam19*/,/*bChange*/,/*lReadOnly*/ .f. , /*lPassword*/.F. ,/*uParam23*/,/*cReadVar*/ "cModTransp",/*uParam25*/,/*uParam26*/,/*uParam27*/,/*lHasButton*/.f., /*lNoButton*/.f.,/*uParam30*/ .f.,/*cLabelText*/,/*nLabelPos*/,/*oLabelFont*/oFont1,/*nLabelColor*/CLR_BLACK,/*cPlaceHold*/, /*lPicturePriority*/,/*lFocSel*/)
	oGetMdTransp  := TComboBox():New(,, {|u| Iif(PCount() > 0 , cModTransp := u, cModTransp)}, aCbmModTransp, 40, 10, oPaneTopo, , /*{|| fAtuCmb()}*/, /*bValid*/, /*nClrText*/, /*nClrBack*/, .t., oFont1)
	oTopPLyt:addInLayout(oSayMdTransp)
	oTopPLyt:addInLayout(oGetMdTransp)

	oSayStatus  := TSay():New(,,{||'Status:'},oTopPLyt,,oFontCabec,,,,.T.,,,50,10)
	oGetStatus  := TGet():New( /*nRow*/,/*nCol*/ ,/*bSetGet*/ { | u | If( PCount() == 0, cStatusSO, cStatusSO := u ) },/*oWnd*/oPaneTopo,/*nWidth*/25,/*nHeight*/ 010,/*cPict*/ "@D",{|| u_fOS_Status()}/* bValid */, CLR_BLUE, CLR_HGRAY,oFont1,/*uParam12*/ ,/*uParam13*/ ,.T./*lPixel*/ ,/*uParam15*/ ,/*uParam16*/ ,/*bWhen*/ ,/*uParam18*/,/*uParam19*/,/*bChange*/,/*lReadOnly*/ .f. , /*lPassword*/.F. ,/*uParam23*/,/*cReadVar*/ "cStatusSO",/*uParam25*/,/*uParam26*/,/*uParam27*/,/*lHasButton*/.f., /*lNoButton*/.f.,/*uParam30*/ .f.,/*cLabelText*/,/*nLabelPos*/,/*oLabelFont*/oFont1,/*nLabelColor*/CLR_BLACK,/*cPlaceHold*/, /*lPicturePriority*/,/*lFocSel*/)
	oTopPLyt:addInLayout(oSayStatus)
	oTopPLyt:addInLayout(oGetStatus)

	oSayDtAgenda	:= TSay():New(,,{||'Dt.Agend.:'},oTopPLyt,,oFontCabec,,,,.T.,,,50,10)
	oGetDtAgenda   	:= TGet():New( /*nRow*/,/*nCol*/ ,/*bSetGet*/ { | u | If( PCount() == 0, dDtAgenda, dDtAgenda := u ) },/*oWnd*/oPaneTopo,/*nWidth*/25,/*nHeight*/ 010,/*cPict*/ "@D",/* bValid */, CLR_BLUE, CLR_HGRAY,oFont1,/*uParam12*/ ,/*uParam13*/ ,.T./*lPixel*/ ,/*uParam15*/ ,/*uParam16*/ ,/*bWhen*/ ,/*uParam18*/,/*uParam19*/,/*bChange*/,/*lReadOnly*/ .f. , /*lPassword*/.F. ,/*uParam23*/,/*cReadVar*/ "dDtAgenda",/*uParam25*/,/*uParam26*/,/*uParam27*/,/*lHasButton*/.f., /*lNoButton*/.f.,/*uParam30*/ .f.,/*cLabelText*/,/*nLabelPos*/,/*oLabelFont*/oFont1,/*nLabelColor*/CLR_BLACK,/*cPlaceHold*/, /*lPicturePriority*/,/*lFocSel*/)
	oTopPLyt:addInLayout(oSayDtAgenda)
	oTopPLyt:addInLayout(oGetDtAgenda)

	oSayTurnoAge  := TSay():New(,,{||'Turno.Agend.:'},oTopPLyt,,oFontCabec,,,,.T.,,,50,10)
	//oGetTurnoAge  := TGet():New( /*nRow*/,/*nCol*/ ,/*bSetGet*/ { | u | If( PCount() == 0, cTurnoAgenda, cTurnoAgenda := u ) },/*oWnd*/oPaneTopo,/*nWidth*/60,/*nHeight*/ 010,/*cPict*/ "@D",{||u_fTurno()}/* bValid */, CLR_BLUE, CLR_HGRAY,oFont1,/*uParam12*/ ,/*uParam13*/ ,.T./*lPixel*/ ,/*uParam15*/ ,/*uParam16*/ ,/*bWhen*/ ,/*uParam18*/,/*uParam19*/,/*bChange*/,/*lReadOnly*/ .f. , /*lPassword*/.F. ,/*uParam23*/,/*cReadVar*/ "cTurnoAgenda",/*uParam25*/,/*uParam26*/,/*uParam27*/,/*lHasButton*/.f., /*lNoButton*/.f.,/*uParam30*/ .f.,/*cLabelText*/,/*nLabelPos*/,/*oLabelFont*/oFont1,/*nLabelColor*/CLR_BLACK,/*cPlaceHold*/, /*lPicturePriority*/,/*lFocSel*/)
	oGetTurnoAge  := TComboBox():New(,, {|u| Iif(PCount() > 0 , cTurnoAgenda := u, cTurnoAgenda)}, aCbmTurno, 40, 10, oPaneTopo, , /*{|| fAtuCmb()}*/, /*bValid*/, /*nClrText*/, /*nClrBack*/, .t., oFont1)
 
	oTopPLyt:addInLayout(oSayTurnoAge)
	oTopPLyt:addInLayout(oGetTurnoAge)

	oBtAtualiza := TButton():New( , , "Atualiza", oTopPLyt,{||fAtuOrderServ() },50,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTopPLyt:addInLayout(oBtAtualiza)


	//Centro
	oCentLyt := tLinearLayout():New(oPaneCentro, LAYOUT_LINEAR_L2R, CONTROL_ALIGN_ALLCLIENT, 0, 0)

	oPlnCent1 := tPanel():New(0,0,,oCentLyt,,.T.,,,,0,0)
	oPlnCent2 := tPanel():New(0,0,,oCentLyt,,.T.,,,,0,0)
	oPlnCent3 := tPanel():New(0,0,,oCentLyt,,.T.,,,,0,0)

	oPlnCent1:SetCss("TPanel{background-color : #9e214d; }")
	oPlnCent2:SetCss("TPanel{background-color : #d6dbdb; }")
	oPlnCent3:SetCss("TPanel{background-color : #2aae8d; }")
	oCentLyt:addInLayout(oPlnCent1,,60)
	oCentLyt:addInLayout(oPlnCent2,,5)
	oCentLyt:addInLayout(oPlnCent3,,35)

	//oAdPlnC1 := tLinearLayout():New(oPlnCent1, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	//pnlOrdemServ(@oAdPlnC1)
	pnlOrdemServ(@oPlnCent1)

	//Divide a tela de 3 partes para centralizar o Botões 
	oAdPlnC2 := tLinearLayout():New(oPlnCent2, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	oPlnCt21 := tPanel():New(0,0,,oAdPlnC2,,.T.,,,,0,0)
	oPlnCt22 := tPanel():New(0,0,,oAdPlnC2,,.T.,,,,0,0)
	oPlnCt23 := tPanel():New(0,0,,oAdPlnC2,,.T.,,,,0,0)
	oPlnCt21:SetCss("TPanel{background-color : #d6dbdb; }")
	oPlnCt22:SetCss("TPanel{background-color : #d6dbdb; }")
	oPlnCt23:SetCss("TPanel{background-color : #d6dbdb; }")
	oAdPlnC2:addInLayout(oPlnCt21,,30)
	oAdPlnC2:addInLayout(oPlnCt22,,40)
	oAdPlnC2:addInLayout(oPlnCt23,,30)
	
	//Cria Botões 
	oPlnC221 := tLinearLayout():New(oPlnCt22, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)

	oBtAddInd := TButton():New( 0,20 , ">", oPlnC221,{|| AddAtend( oBrOS,.f.)  },,,,,.F.,.T.,.F.,,.F.,,,.F. )
	oPlnC221:addInLayout(oBtAddInd)
	oBtAddGrp := TButton():New( 0,20 , ">>", oPlnC221,{|| AddAtend( oBrOS,.T.)},,,,,.F.,.T.,.F.,,.F.,,,.F. )
	oPlnC221:addInLayout(oBtAddGrp)
	oBtDelInd := TButton():New( 0,20, "<<", oPlnC221,{|| DelAtend( oBrGrp)},,,,,.F.,.T.,.F.,,.F.,,,.F. )
	oPlnC221:addInLayout(oBtDelInd)

	//oAdPlnC3 := tLinearLayout():New(oPlnCent3, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlGrpOrdem(@oPlnCent3)


	// Grid do Rodapé
	oRodPLyt:= tLinearLayout():New(oPaneRodape, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	oRodPLyt:SetCSS("QFrame{ margin: 0px; background-color: #e8caf1;}")

	oSayRMs1    := TSay():New(,,{||'Seleção de O.S. '},oRodPLyt,,oFont1,,,,.T.,,,300,10)
	oRodPLyt:addInLayout(oSayRMs1)

Return ( Nil )

/*/ valida o Processo 1/*/
Static Function Val_Pg1(oPanel)
	Local lRet := .F.

	if Empty(dDtPrvInicial )
		MsgInfo("Informe a data Inicial da Ordem de Serviço","Erro")
		Return(lRet)
	Endif 
	if Empty(dDtPrvFinal   )
		MsgInfo("Informe a data Previsão Final da Ordem de Serviço ","Erro")
		Return(lRet)
	Endif 
	if Empty(dDtAgenda	    )
		MsgInfo("Informe a data de programação do Agendamento","Erro")
		Return(lRet)
	Endif 
	if Empty(cTurnoAgenda  )
		MsgInfo("Informe o Turno da Ordem de Serviço selecionada","Erro")
		Return(lRet)
	Endif 
	if Empty(cPrvTurno)
		MsgInfo("Informe o Turno da programação de Atendimento","Erro")
		Return(lRet)
	Endif 
	if Empty(cModTransp)
		MsgInfo("Informe a Modalidade de Transporte  ","Erro")
		Return(lRet)
	Endif 
	if Empty(cStatusSO)
		MsgInfo("Informe os Status da Ordem de Serviço ","Erro")
		Return(lRet)
	Endif 

	Processa( {|| lRet:=ProcRotas() }, "Processando arquivo..." )
	Processa( {|| RunMembros(dDtAgenda,cTurnoAgenda,cModTransp) }, "Processando  membros equipes..." )
	Processa( {|| RunEquipe(dDtAgenda,cTurnoAgenda,cModTransp) }, "Processando equipes..." )

Return ( lRet )
/*/ Rotina que agrupa as OS das Rotas para vinculo com Equipes /*/
Static Function ProcRotas()
	Local nI
	Local nPos
	aRotas      := {}
	For nI:=1 to Len(aAtendimento)
		nPos := aScan(aRotas,{|x| x[1] == aAtendimento[nI][2]  })
		if nPos!=0
			aadd(aRotas[nPos,2],aAtendimento[nI])
		else
			aadd(aRotas ,{aAtendimento[nI][2],{aAtendimento[nI]},.f.})
		Endif
	Next

Return !Empty(aRotas)



Static Function Tela_Pg2(oPanel)
	Define Font oFont1     Name "Verdana" Size 7,15
	Define Font oFontCabec Name "Verdana" Bold Size 7,15

	oBodyLyt := tLinearLayout():New(oPanel, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)

	// Divide Frame central com 3 Paineis
	oPaneTopo 	:= tPanel():New(0,0,,oBodyLyt,,.T.,,,,0,0)
	oPaneCentro	:= tPanel():New(0,0,,oBodyLyt,,.T.,,,,0,0)
	oPaneRodape := tPanel():New(0,0,,oBodyLyt,,.T.,,,,0,0)
	oBodyLyt:addInLayout(oPaneTopo,,30)
	oBodyLyt:addInLayout(oPaneCentro,,65)
	oBodyLyt:addInLayout(oPaneRodape,,5)

	//Topo
	oTopPLyt:= tLinearLayout():New(oPaneTopo, LAYOUT_LINEAR_L2R, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	oPlnTop1 := tPanel():New(0,0,,oTopPLyt,,.T.,,,,0,0)
	oPlnTop2 := tPanel():New(0,0,,oTopPLyt,,.T.,,,,0,0)
	oTopPLyt:addInLayout(oPlnTop1,,70)
	oTopPLyt:addInLayout(oPlnTop2,,30)
	
	//oPlTop11 := tLinearLayout():New(oPlnTop1, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlBrwRota(@oPlnTop1)
	//oPlTop12 := tLinearLayout():New(oPlnTop2, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlBrwFunc(@oPlnTop2)

	//Centro
	oCentLyt := tLinearLayout():New(oPaneCentro, LAYOUT_LINEAR_L2R, CONTROL_ALIGN_ALLCLIENT, 0, 0)

	oPlnCent1 := tPanel():New(0,0,,oCentLyt,,.T.,,,,0,0)
	oPlnCent2 := tPanel():New(0,0,,oCentLyt,,.T.,,,,0,0)
	oPlnCent3 := tPanel():New(0,0,,oCentLyt,,.T.,,,,0,0)
	oPlnCent4 := tPanel():New(0,0,,oCentLyt,,.T.,,,,0,0)

	oPlnCent1:SetCss("TPanel{background-color : #9e214d; }")
	oPlnCent2:SetCss("TPanel{background-color : #d6dbdb; }")
	oPlnCent3:SetCss("TPanel{background-color : #2aae8d; }")
	oPlnCent4:SetCss("TPanel{background-color : #93d714; }")
	oCentLyt:addInLayout(oPlnCent1,,20)
	oCentLyt:addInLayout(oPlnCent2,,20)
	oCentLyt:addInLayout(oPlnCent3,,30)
	oCentLyt:addInLayout(oPlnCent4,,30)
	//Centro 1
	oAdPlnC1 := tLinearLayout():New(oPlnCent1, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlTree(@oAdPlnC1)

	//Centro 4 de Membro antes das equipes 
	oAdPlnC4 := tLinearLayout():New(oPlnCent4, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlMembTree(@oAdPlnC4)

	//Centro 2
	oAdPlnC2 := tLinearLayout():New(oPlnCent2, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlEqTree(@oAdPlnC2)

	//Centro 3
	oAdPlnC3 := tLinearLayout():New(oPlnCent3, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	//Divide na vertical em três quadro

	oPlnCt31 := tPanel():New(0,0,,oAdPlnC3,,.T.,,,,0,0)
	oPlnCt32 := tPanel():New(0,0,,oAdPlnC3,,.T.,,,,0,0)
	// oPlnCt31:SetCss("TPanel{background-color : #d919b6; }")
	// oPlnCt32:SetCss("TPanel{background-color : #d6dbd7; }")
	oAdPlnC3:addInLayout(oPlnCt31,,80)
	oAdPlnC3:addInLayout(oPlnCt32,,20)
	
	//Painel Tree de Adicionar Equipe 
	oPlCt312 := tLinearLayout():New(oPlnCt31, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlAdEqTree(@oPlCt312)
	//Painel Botão de Criar Equipe e importar Equipe 
	oPlCt322 := tLinearLayout():New(oPlnCt32, LAYOUT_LINEAR_L2R, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlAdEqBtn(@oPlCt322)


	// Grid do Rodapé
	oRodPLyt:= tLinearLayout():New(oPaneRodape, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	oRodPLyt:SetCSS("QFrame{ margin: 0px; background-color: #f0f1e6;}")

	oSayRMs1    := TSay():New(,,{||'Seleção de O.S. '},oRodPLyt,,oFont1,,,,.T.,,,300,10)
	oRodPLyt:addInLayout(oSayRMs1)


Return ( Nil )

/*/ 
	valida o Processo 2
/*/
Static Function Val_Pg2(oPanel)

	if Empty(aEquipes) .or. Empty(aRotas)
		MsgInfo("Não existe movimentos de atendimento ou Equipes","Erro")
		Return(.F.)
	Endif 
	//Zera Brose da Seleção de Equipe e Rota 
	nIdxRota		:=0
	nIdxEquipe		:=0
	aRotaAtual      :={}
	aEquipeAtual    :={}
	
	ASize(aEquipeAtual, Len(aEquipeAtual))
	if ValType(oBrEquipe)=="O"
		oBrEquipe:setArray( aEquipeAtual )
		oBrEquipe:Refresh()
	Endif

	ASize(aRotaAtual, Len(aRotaAtual))
	if ValType(oBrRota)=="O"
		oBrRota:setArray( aRotaAtual )
		oBrRota:Refresh()
	Endif
Return .T.

Static Function Tela_Pg3(oPanel)

	Define Font oFont1     Name "Verdana" Size 7,15
	Define Font oFontCabec Name "Verdana" Bold Size 7,15

	oP3Body := tLinearLayout():New(oPanel, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)

	// Divide Frame central com 3 Paineis
	oP3PnTopo 	:= tPanel():New(0,0,,oP3Body,,.T.,,,,0,0)
	oP3PnCentro	:= tPanel():New(0,0,,oP3Body,,.T.,,,,0,0)
	oP3PnRodape := tPanel():New(0,0,,oP3Body,,.T.,,,,0,0)
	oP3Body:addInLayout(oP3PnTopo,,65)
	oP3Body:addInLayout(oP3PnCentro,,30)
	oP3Body:addInLayout(oP3PnRodape,,5)

	//Topo
	oP3TpPLt:= tLinearLayout():New(oP3PnCentro, LAYOUT_LINEAR_L2R, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	oP3PnTp1 := tPanel():New(0,0,,oP3TpPLt,,.T.,,,,0,0)
	oP3PnTp2 := tPanel():New(0,0,,oP3TpPLt,,.T.,,,,0,0)
	oP3TpPLt:addInLayout(oP3PnTp1,,70)
	oP3TpPLt:addInLayout(oP3PnTp2,,30)
	
	//oP3Top11 := tLinearLayout():New(oP3PnTp1, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlBrwRota(@oP3PnTp1)
	//oP3Top12 := tLinearLayout():New(oP3PnTp2, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlBrwFunc(@oP3PnTp2)

	//Centro
	op3CtLyt := tLinearLayout():New(oP3PnTopo, LAYOUT_LINEAR_L2R, CONTROL_ALIGN_ALLCLIENT, 0, 0)

	oP3PnCt1 := tPanel():New(0,0,,op3CtLyt,,.T.,,,,0,0)
	oP3PnCt2 := tPanel():New(0,0,,op3CtLyt,,.T.,,,,0,0)
	oP3PnCt3 := tPanel():New(0,0,,op3CtLyt,,.T.,,,,0,0)

	oP3PnCt1:SetCss("TPanel{background-color : #9e214d; }")
	oP3PnCt2:SetCss("TPanel{background-color : #d6dbdb; }")
	oP3PnCt3:SetCss("TPanel{background-color : #2aae8d; }")

	op3CtLyt:addInLayout(oP3PnCt1,,20)
	op3CtLyt:addInLayout(oP3PnCt2,,20)
	op3CtLyt:addInLayout(oP3PnCt3,,60)

	//Centro 1
	oP3APnC1 := tLinearLayout():New(oP3PnCt1, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlTree(@oP3APnC1)


	//Centro 2
	oP3APnC2 := tLinearLayout():New(oP3PnCt2, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlEqTree(@oP3APnC2)

	//Centro 3
	oP3APnC3 := tLinearLayout():New(oP3PnCt3, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	//Divide na vertical em três quadro

	oPlnCt31 := tPanel():New(0,0,,oP3APnC3,,.T.,,,,0,0)
	oPlnCt32 := tPanel():New(0,0,,oP3APnC3,,.T.,,,,0,0)
	// oPlnCt31:SetCss("TPanel{background-color : #d919b6; }")
	// oPlnCt32:SetCss("TPanel{background-color : #d6dbd7; }")
	oP3APnC3:addInLayout(oPlnCt31,,90)
	oP3APnC3:addInLayout(oPlnCt32,,10)
	
	//Painel Tree de Adicionar Equipe 
	oP3Ct312 := tLinearLayout():New(oPlnCt31, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlAtenTree(@oP3Ct312)
	//Painel Botão de Criar Equipe e importar Equipe 
	oP3Ct322 := tLinearLayout():New(oPlnCt32, LAYOUT_LINEAR_L2R, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	pnlBtnRota(@oP3Ct322)


	// Grid do Rodapé
	oRodPLyt:= tLinearLayout():New(oP3PnRodape, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 0, 0)
	oRodPLyt:SetCSS("QFrame{ margin: 0px; background-color: #f0f1e6;}")

	oSayRMs1    := TSay():New(,,{||'Seleção de O.S. '},oRodPLyt,,oFont1,,,,.T.,,,300,10)
	oRodPLyt:addInLayout(oSayRMs1)


Return ( Nil )

/*/ 
	valida o Processo 3
/*/
Static Function Val_Pg3(oPanel)
Local lOk:=.t.
Return lOk





/*/ Cria um novo calculo de processamento  de arquivo de Status/*/
Static Function BjCriaZTA(nTotal)
	Local cIdCalculo:=""
	DBSelectArea("ZTA")
	if RecLock("ZTA",.T.)
		ZTA->ZTA_ID:=GetSXENum("ZTA","ZTA_ID")
		ZTA->ZTA_DATA:=FwTimeStamp(3)
		ZTA->ZTA_REGIS1:=nTotal
		ZTA->ZTA_DESCRI:="ALTERNATE"
		ZTA->(MsUnLock())
		cIdCalculo:=ZTA->ZTA_ID
		//Confirma Id do Processamento
		ConfirmSX8()
	Endif
Return cIdCalculo

/*/ Browse de Ordem de Serviço  /*/
Static function pnlOrdemServ(oWorner)
	Local cTitBarra	:= "Ordem de Serviço"
	Local aData		:= {}
	aData:=UpdDataOS()
	aHeadCampos :=aData[1]
	aDataOS     :=aData[2]
	skBrow(@oWorner,@aDataOS/*aData*/,aHeadCampos/*aCampos*/,cTitBarra/*Titulos na Barra*/,@oColBrOS, @oBrOS,,,.f.,.F.,"")
	oBrOS:SetFocus()
Return

/*/ Update de Browse de Ordem de Serviço/*/
Static Function UpdDataOS()
	Local cQuery	:= ""
	Local aData
	Local cTurnoIn:=StrTran(Alltrim(cPrvTurno),"*",''/*cReplace*/,/*nStart*/,/*nCount*/)
	Local cMdTraIn:=StrTran(Alltrim(cModTransp),"*",''/*cReplace*/,/*nStart*/,/*nCount*/)
	Local cStatuIn:=StrTran(Alltrim(cStatusSO),"*",''/*cReplace*/,/*nStart*/,/*nCount*/)

	cQuery += " SELECT "+IIf( Upper(TcGetDb()) $ '/ORACLE/'," ' ' as xOk "," xOk=' ' ")+",AB6_NUMOS,AB6_XSTATU,AB6_XTIPO,AB6_XDTSAG,AB6_XTUSOL,AB6_CODCLI,A1_NOME,AB6_EMISSA,AB6_STATUS,"
	cQuery += " AB7_CODPRB,AAG_DESCRI,AB6_XTPVEI,AB7_MEMO1,AA3_CODLOC,"
	cQuery += " ABS_DESCRI,ABS_END,ABS_BAIRRO,ABS_MUNIC,ABS_ESTADO "
	cQuery += " FROM "+RetSqlName("AB6")+" AB6 "
	cQuery += "  INNER JOIN "+RetSqlName("AB7")+" AB7 ON AB7.D_E_L_E_T_ <>'*' AND AB7_FILIAL = AB6_FILIAL AND AB7_NUMOS = AB6_NUMOS AND AB7_CODCLI = AB6_CODCLI AND AB7_LOJA = AB6_LOJA "
	cQuery += "  INNER JOIN "+RetSqlName("AAG")+" AAG ON AAG_FILIAL='"+xFilial("AAG")+"' AND AB7_CODPRB=AAG_CODPRB AND AAG.D_E_L_E_T_<> '*'  "
	cQuery += "  INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.D_E_L_E_T_ <>'*' AND SA1.A1_FILIAL ='"+xFilial("SA1")+"' AND A1_COD=AB6_CODCLI AND A1_LOJA=AB6_LOJA"
	cQuery += "  LEFT  JOIN "+RetSqlName("AA3")+" AA3 ON   AA3_FILIAL='"+xFilial("AA3")+"'  AND  AA3_CODPRO=AB7_CODPRO AND  AA3_NUMSER=AB7_NUMSER  AND AA3_CODCLI=AB7_CODCLI AND AA3_LOJA=AB7_LOJA  AND AA3.D_E_L_E_T_ <> '*' "
	cQuery += "  LEFT  JOIN "+RetSqlName("ABS")+" ABS ON ABS_FILIAL=AA3_FILIAL AND ABS_LOCAL=AA3_CODLOC AND ABS.D_E_L_E_T_ <>'*' "
	cQuery += "  WHERE AB6.D_E_L_E_T_ <>'*' "
	cQuery += "  AND  AB6_FILIAL = '"+xFilial("AB6")+"'"
	cQuery += "  AND  AB6_XROTA = ' ' "

	//IF !empty(dDtPrvInicial)
	    cQuery += " AND AB6_XDTSAG >= '" +DtoS(dDtPrvInicial)+ "' "
	//EndIF

	//IF !empty(dDtPrvFinal)
	    cQuery += " AND AB6_XDTSAG <= '" +DtoS(dDtPrvFinal)+ "' "
	//EndIF
	cTurnoIn:=SepararCaracteres(cTurnoIn,';')
	//IF !empty(cTurnoIn)
	    cQuery += " AND AB6_XTUSOL IN " +FormatIn(cTurnoIn,";")+ " "
	//EndIF
	
	cMdTraIn:=SepararCaracteres(cMdTraIn,';')
	//IF !empty(cMdTraIn)
	    cQuery += " AND AB6_XTIPO IN " +FormatIn(cMdTraIn,";")+ " "
	//EndIF
	
	cStatuIn:=SepararCaracteres(cStatuIn,';')
	//IF !empty(cStatuIn)
	    cQuery += " AND AB6_XSTATU IN " +FormatIn(cStatuIn,";")+ " "
	//EndIF

	cQuery  += ' ORDER BY AB6_FILIAL,AB6_CODCLI,AB6_NUMOS'

	aData:=SKSqlToArray(cQuery)
Return aData

Static function pnlGrpOrdem(oWorner)
	Local cTitBarra:="Programação de Atendimento"
	Local aHeadAtendimento:=aClone(aHeadCampos)
	ASize(aHeadAtendimento, Len(aHeadAtendimento) + 1)
	AIns(aHeadAtendimento, 2)
	aHeadAtendimento[2]:="ZX2_COD"
	skBrow(@oWorner,@aAtendimento/*aData*/,@aHeadAtendimento/*aCampos*/,cTitBarra/*Titulos na Barra*/,@oColBrGrp, @oBrGrp,,,.F.,.F.,"")
Return


Static function pnlBrwRota(oWorner)
	Local lCond:=.T.
	Local cTitulo
	Local bHeader

	private aHeader:={}
	Private nI:=0
	Default nPlnWidth :=100
	Default nPlnnHeigth:=100
	aRotaAtual:={}

	if !Empty(nIdxRota) .and. nIdxRota <= Len(aRotaAtual)
		aRotaAtual:=aClone(aRotas[nIdxRota,2])
		ADel(aRotaAtual, 2)
		ASize(aRotaAtual, Len(aRotaAtual) - 1)
	Endif 

	dbselectarea("SX3")
	while lCond
		nI:=nI+1
		if nI>Len(aHeadCampos)
			lCond:=.f.
			nI:=1
			loop
		Endif
		cTitulo := Alltrim(RetTitle(aHeadCampos[nI]))
		bHeader :="{ |X| aRotaAtual[oBrRota:At(),"+cValToChar(nI)+"] }"
		aadd(aHeader,{cTitulo,&(bHeader),GetSx3Cache( aHeadCampos[nI] , "X3_TIPO" ),GetSx3Cache( aHeadCampos[nI] , "X3_PICTURE" ),1,GetSx3Cache( aHeadCampos[nI] , "X3_TAMANHO" ),GetSx3Cache( aHeadCampos[nI] , "X3_DECIMAL" )})
	end

	//Browse de funcionarios - principal
	oBrRota:= FWBrowse():New()
	oBrRota:SetDataArray()
	oBrRota:SetArray(aRotaAtual)
	oBrRota:SetColumns(aHeader)
	oBrRota:SetOwner(oWorner)
	oBrRota:DisableConfig()
	oBrRota:DisableReport()
	oBrRota:DisableFilter()
	oBrRota:DisableSeek()
	oBrRota:DisableSaveConfig()
	oBrRota:Activate()
	//oWorner:addInLayout(oPanel)
Return

/*/ Browse de equipes /*/
Static function pnlBrwFunc(oWorner)
	Local cCampo:=""
	private aCpBrwEq:={}
	Default nPlnWidth :=50
	Default nPlnnHeigth:=50
	Default aEquipeAtual:={}

	cCampo:="AA1_CODTEC"
	aadd(aCpBrwEq,{;
					"Código",;
					{ |X| aEquipeAtual[oBrEquipe:At(),4] },;
					GetSx3Cache( cCampo , "X3_TIPO" ),;
					GetSx3Cache( cCampo , "X3_PICTURE" ),;
					1,;
					GetSx3Cache( cCampo , "X3_TAMANHO" ),;
					GetSx3Cache( cCampo , "X3_DECIMAL" );
					})
	cCampo:="AA1_XTIPO"
	aadd(aCpBrwEq,{;
					"Tipo",;
					{ |X| aEquipeAtual[oBrEquipe:At(),3] },;
					GetSx3Cache( cCampo , "X3_TIPO" ),;
					GetSx3Cache( cCampo , "X3_PICTURE" ),;
					1,;
					GetSx3Cache( cCampo , "X3_TAMANHO" ),;
					GetSx3Cache( cCampo , "X3_DECIMAL" );
					})

	cCampo:="AA1_NOMTEC"
	aadd(aCpBrwEq,{;
					"Nome",;
					{ |X| aEquipeAtual[oBrEquipe:At(),5] },;
					GetSx3Cache( cCampo , "X3_TIPO" ),;
					GetSx3Cache( cCampo , "X3_PICTURE" ),;
					1,;
					GetSx3Cache( cCampo , "X3_TAMANHO" ),;
					GetSx3Cache( cCampo , "X3_DECIMAL" );
					})					

	//Browse de funcionarios - principal
	oBrEquipe:= FWBrowse():New()
	oBrEquipe:SetDataArray()
	oBrEquipe:SetArray(aEquipeAtual)
	oBrEquipe:SetColumns(aCpBrwEq)
	oBrEquipe:SetOwner(oWorner)
	oBrEquipe:DisableConfig()
	oBrEquipe:DisableReport()
	oBrEquipe:DisableFilter()
	oBrEquipe:DisableSeek()
	oBrEquipe:DisableSaveConfig()
	oBrEquipe:Activate()
	//oWorner:addInLayout(oPlBrwEq)
Return


Static function SKSqlToArray(cQuery)
	Local aStru
	Local cAlias 	:= getnextAlias()
	Local nQueryRet
	Local lAchou	:=.F.
	lOCAL aCampos	:={}
	Local nTotReg	:=0

	nQueryRet := TCSQLEXEC(cQuery)
	If nQueryRet < 0
		msgstop("ERRO NA QUERY: " + chr(10) + TCSQLError())
		return({aCampos,Array(0),lAchou})
	Endif
	//cQuery:=TcGenQry2(,, cQuery,{})
	//dbUseArea(.T.,"TOPCONN",cQuery,cAlias)
	TCQUERY (cQuery) NEW ALIAS &(cAlias) NEW
	DbSelectArea(cAlias)
	aStru   := (cAlias)->(DbStruct())
	aEval(aStru,{|aCampo| aadd(aCampos,aCampo[1]) })

	nTotReg := Contar(cAlias,"!Eof()")
	aItens:={}
	dbSelectArea(cAlias)
	(cAlias)->(DbGotop())
	while (cAlias)->(!eof())
        /* Grava linha de campos da tabela */
		aLinha:={}
		aEval(aStru,{|aCampo| aadd(aLinha,(cAlias)->&(aCampo[1])) })
		aadd(aItens,aLinha)
		(cAlias)->(dbSkip())
		lAchou:=.t.
	end
	(cAlias)->(DBCloseArea())
Return (iIf(lAchou,{aCampos,aItens,lAchou},{aCampos,Array(0),lAchou}))



Static Function skBrow(oWorner,aData,aCampos,cTitBarra,oColumn, oBrowse,nPlnWidth , nPlnnHeigth,lDClick,lFilter,cFilter)
	Local oPanel
	Local lCond:=.T.
	Local cTitulo

	private  aHeader:={}
	Private nI:=0
	Default  nPlnWidth :=100
	Default  nPlnnHeigth:=100
	Default lDClick:=.f.
	Default lFilter:=.f.

	

	dbselectarea("SX3")
	while lCond
		nI:=nI+1
		if nI>Len(aCampos)
			lCond:=.f.
			nI:=1
			loop
		Endif
		If !EMPTY(GetSx3Cache(aCampos[nI], "X3_TAMANHO" ))
			cTitulo := Alltrim(RetTitle(aCampos[nI]))
			if  Alltrim(aCampos[nI]) == "AB7_MEMO1"
				AEval(aData,{|x| x[nI]:= MSMM(x[nI]) },/*nStart*/,/*nCount*/)
			Endif
			bHeader :="{ |X| aData[oBrowse:At(),"+cValToChar(nI)+"] }"
			aadd(aHeader,{cTitulo,&(bHeader),GetSx3Cache( aCampos[nI] , "X3_TIPO" ),GetSx3Cache( aCampos[nI] , "X3_PICTURE" ),1,GetSx3Cache( aCampos[nI] , "X3_TAMANHO" ),GetSx3Cache( aCampos[nI] , "X3_DECIMAL" )})
		Endif 
	end

	//Browse de funcionarios - principal
	oBrowse := FWBrowse():New()
	oBrowse:AddMarkColumns({|| If( !Empty(aData[oBrowse:nAt][1]), 'LBOK', 'LBNO') }, {|| MarkLine( oBrowse ) }, {|| MarkAll( oBrowse ), oBrowse:Refresh() })
	oBrowse:SetDataArray()
	oBrowse:SetArray(aData)
	oBrowse:SetColumns(aHeader)
	//oBrowse:SetAlias(cAlias)
	oBrowse:SetOwner(oWorner)
	oBrowse:DisableConfig()
	oBrowse:DisableReport()
	oBrowse:DisableFilter()
	oBrowse:DisableSeek()
	oBrowse:DisableSaveConfig()
	// oBrowse:SetBlkBackColor( {||"#D6E4EA"} )
	//Define o bloco de código executado na validação da linha
	oBrowse:SetLineOk( {||.T.} )

	// if lFilter
	// 	oBrowse:SetFilterDefault(  cFilter  )
	// Endif
	// //oBrowse:AddLegend( "aData[oBrowse:At(),1] == '1' ", "GREEN"	, "Sim",,.F. ) //"Autorizada"
	// //oBrowse:AddLegend( "aData[oBrowse:At(),1] <> '1' ", "RED"	, "Não",,.F. ) //"Autorizada"
	// if lDClick
	// 	oBrowse:SetDoubleClick( {|| dClick(@aData,oBrowse:At()), oBrowse:UpdateBrowse() } )
	// Endif
	oBrowse:Activate()

	//oWorner:addInLayout(oPanel)

Return ( Nil )



//Chama função para Altera Valor de Credito 
Static function dClick(aData,nPos)
Return nil



Static Function MarkLine( oBrwMark As Object  )
	Local lAdd
	Default oBrwMark := {}

	If Empty(oBrwMark:oDATA:aARRAY[oBrwMark:AT()][oBrwMark:COLPOS()])
		oBrwMark:oDATA:aARRAY[oBrwMark:AT()][oBrwMark:COLPOS()] := "ok"
		lAdd:=.T.
	Else
		oBrwMark:oDATA:aARRAY[oBrwMark:AT()][oBrwMark:COLPOS()] :=""
		lAdd:=.F.
	EndIf

	//AtuBanSel( oBrwMark,lAdd )
	oBrwMark:Refresh()
Return( Nil )

/*/{Protheus.doc} F70MarlAll()
Função do Header click para selecionar todos os registros na FwBrowse.

@author Adriano Sato
@since  19/11/2020
@version 12.1.027
/*/
Static Function MarkAll( oBrwMark As Object  )
	Local nX 	 As Numeric
	Local lMarca As String
	Local lAdd

	Default oBrwMark := {}

	If Empty(oBrwMark:oDATA:aARRAY[1][1])
		lMarca := "ok"
		lAdd:=.T.
	Else
		lMarca := ""
		lAdd:=.F.
	EndIf

	For nX := 1 To LEN(oBrwMark:oDATA:aARRAY)
		oBrwMark:oDATA:aARRAY[nX][1] := lMarca
	Next nX

	oBrwMark:Refresh()
Return( Nil )


Static Function AddAtend( oBrwMark As Object ,lGrupo  )

	Local nX 		As Numeric
	Local aItem
	Local cOS       :=""
	Local aAuxData  :=AClone(aDataOS)
	Local cNumAtend :=""
	Local lIndvidual:= !lGrupo
	Local lPrimeiro := .f.

	Default oBrwMark := {}
	For nX := 1 To Len(aAuxData) //Len(oBrwMark:ODATA:AARRAY)
		If !Empty(aAuxData[nX][1]) //!Empty(oBrwMark:ODATA:AARRAY[nX][1])
			if lIndvidual
				cNumAtend :=u_fSeqZX2Num() //GetSXENum("ZX2","ZX2_COD")
			Endif
			if !lPrimeiro .and. lGrupo
				cNumAtend :=u_fSeqZX2Num() //GetSXENum("ZX2","ZX2_COD")
				lPrimeiro :=.t.
			Endif

			aItem       :=aAuxData[nX]
			cOS         :=aItem[2]
			aItem[1]    :=""
			// // 1. Aumenta o tamanho do array para não perder o último elemento
			ASize(aItem, Len(aItem) + 1)
			// // 2. Insere um espaço vazio na primeira posição (move o resto para a direita)
			AIns(aItem, 2)
			// // 3. Atribui o novo valor à primeira posição
			aItem[2] := cNumAtend
			AAdd(aAtendimento, aItem )

			//Deleta item do Browse de OS
			// 1. Busca a OS no Acols aDataOS[2]
			nPos := aScan(aDataOS,{|x| x[2] == cOS  })
			// 2. Remove o item do Array e atualiza o tamanho dele
			ADel(aDataOS, nPos)
			ASize(aDataOS, Len(aDataOS) - 1)
		EndIf
	Next nX

	ASize(aAtendimento, Len(aAtendimento))
	ASize(aDataOS, Len(aDataOS))
	// 3. Atualiza o objeto visual do Browse
	oBrwMark:SetArray(aDataOS) // Sincroniza o array atualizado
	oBrwMark:Refresh()           // Força a tela a se redesenhar
	oBrGrp:SetArray(aAtendimento) // Sincroniza o array atualizado
	oBrGrp:Refresh()           // Força a tela a se redesenhar
Return( Nil )


Static Function DelAtend( oBrwMark As Object )

	Local nX 		As Numeric
	Local aItem
	Local cOS       :=""
	Local aAuxData  :=AClone(aAtendimento)

	Default oBrwMark := {}
	For nX := 1 To Len(aAuxData) //Len(oBrwMark:ODATA:AARRAY)
		If !Empty(aAuxData[nX][1]) //!Empty(oBrwMark:ODATA:AARRAY[nX][1])

			aItem       :=aAuxData[nX]
			ADel(aItem, 2)
			ASize(aItem, Len(aItem) - 1)
			cOS         :=aItem[2]
			aItem[1]    :=""
			AAdd(aDataOS, aItem )

			//Deleta item do Browse de OS
			// 1. Busca a OS no Acols aDataOS[2]
			nPos := aScan(aAtendimento,{|x| x[3] == cOS  })
			// 2. Remove o item do Array e atualiza o tamanho dele
			ADel(aAtendimento, nPos)
			ASize(aAtendimento, Len(aAtendimento) - 1)
		EndIf
	Next nX

	ASize(aAtendimento, Len(aAtendimento))
	ASize(aDataOS, Len(aDataOS))
	// 3. Atualiza o objeto visual do Browse
	oBrGrp:SetArray(aAtendimento) // Sincroniza o array atualizado
	oBrGrp:Refresh()           // Força a tela a se redesenhar
	oBrOS:SetArray(aDataOS) // Sincroniza o array atualizado
	oBrOS:Refresh()           // Força a tela a se redesenhar
Return( Nil )

/*/ Rotina de Turno de Trabalho /*/
User Function fTurno()
	Local MvPar
	Local MvParDef := ""
	Local aItems := {}
	Local aArea := GetArea()
	Local cTitulo:="Turno"
	Local lReturn :=.f.

	Default lTipoRet := .T.
	IF lTipoRet
		MvPar := &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
		MvRet := Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF

	AAdd(aItems, "M - " + "Manhã")		//"Fase 1"
	AAdd(aItems, "T - " + "Tarde")		//"Fase 2"
	AAdd(aItems, "N - " + "Noite")		//"Fase 3"
	MvParDef := "MTN"
	IF lTipoRet .and. f_Opcoes(@MvPar/*uVarRet*/, cTitulo /*cTitulo*/, aItems/*aOpcoes*/, MvParDef/*cOpcoes*/,/*nLin1*/ ,/*nCol1*/ ,;
			.F./*l1Elem*/ ,1 /*nTam*/,3/*nElemRet*/,/*lMultSelect*,/*lComboBox*/,/*cCampo*/,/*lNotOrdena*/,/*lNotPesq*/,;
	 /*lForceRetArr*/,/*cF3*/)  
			&MvRet := MvPar
		lReturn :=.T.                                                                          // Devolve Resultado
	EndIF
	RestArea(aArea) 								 // Retorna Alias
Return ( IF( lTipoRet , .T. , MvParDef ) )


/*/ Rotina de Modalidade de Transporte /*/
User Function fMdTransp()
	Local MvPar
	Local MvParDef := ""
	Local aItems := {}
	Local aArea := GetArea()
	Local cTitulo:="Modalidade de Transporte"
	Local lReturn :=.f.

	Default lTipoRet := .T.
	IF lTipoRet
		MvPar := &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
		MvRet := Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF

	AAdd(aItems, "T - " + "Terrestre")		//"Fase 1"
	AAdd(aItems, "F - " + "Fluvial")		//"Fase 2"
	MvParDef := "TM"
	IF lTipoRet .and. f_Opcoes(@MvPar/*uVarRet*/, cTitulo /*cTitulo*/, aItems/*aOpcoes*/, MvParDef/*cOpcoes*/,/*nLin1*/ ,/*nCol1*/ ,;
			.F./*l1Elem*/ ,1 /*nTam*/,2/*nElemRet*/,/*lMultSelect*,/*lComboBox*/,/*cCampo*/,/*lNotOrdena*/,/*lNotPesq*/,;
	 /*lForceRetArr*/,/*cF3*/)  
			&MvRet := MvPar
		lReturn :=.T.                                                                          // Devolve Resultado
	EndIF
	RestArea(aArea) 								 // Retorna Alias
Return ( IF( lTipoRet , .T. , MvParDef ) )

/*/ Rotina de Status de Ordem de Serviço /*/
User Function fOS_Status()
	Local MvPar
	Local MvParDef := ""
	Local aItems := {}
	Local aArea := GetArea()
	Local cTitulo:="Status da Ordem de Serviço"
	Local lReturn :=.f.

	Default lTipoRet := .T.
	IF lTipoRet
		MvPar := &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
		MvRet := Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF

	AAdd(aItems, "P - " + "Prevista")		//"Fase 1"
	AAdd(aItems, "A - " + "Agendada")		//"Fase 2"
	AAdd(aItems, "R - " + "Remarcada")		//"Fase 2"
	AAdd(aItems, "N - " + "Não Executada")	//"Fase 2"
	MvParDef := "PARN"
	IF lTipoRet .and. f_Opcoes(@MvPar/*uVarRet*/, cTitulo /*cTitulo*/, aItems/*aOpcoes*/, MvParDef/*cOpcoes*/,/*nLin1*/ ,/*nCol1*/ ,;
			.F./*l1Elem*/ ,1 /*nTam*/,4/*nElemRet*/,/*lMultSelect*,/*lComboBox*/,/*cCampo*/,/*lNotOrdena*/,/*lNotPesq*/,;
	 /*lForceRetArr*/,/*cF3*/)  
			&MvRet := MvPar
		lReturn :=.T.                                                                          // Devolve Resultado
	EndIF
	RestArea(aArea) 								 // Retorna Alias
Return ( IF( lTipoRet , .T. , MvParDef ) )


Static function pnlTree(oWorner)
	Local cBmp1 := "PMSEDT3"
	Local cBmp2 := "PMSDOC"
	Local nY ,nX

	//Criando o DbTree
	oTreeRota := DBTree():New(;
	,;              //nTop
	,;              //nLeft
	,;              //nBottom
	,;              //nRight
	oWorner,;       //oWnd
    {||fUpdTree(oTreeRota:GetCargo())},; //bChange
	,;                              //bRClick
	.T.;                            //lCargo
	)

	oTreeRota:Align := CONTROL_ALIGN_ALLCLIENT
// Cria a Tree
	oTreeRota:BeginUpdate()

// Prepara o objeto para receber os itens
	oTreeRota:SetScroll(1,.T.) // Habilita a barra de rolagem horizontal

	oTreeRota:SetScroll(2,.T.) // Habilita a barra de rolagem vertical
	for nX := 1 to Len(aRotas)
		cId := aRotas[nX][1]
		oTreeRota:AddItem("Rota: "+cId+Space(60),cId, cBmp1 ,cBmp2,,,1)

		If oTreeRota:TreeSeek(cId)
			for nY := 1 to Len(aRotas[nX][2])
				cId := aRotas[nX][2][nY][3]
				oTreeRota:AddItem("O.S.:"+cId+"-"+aRotas[nX][2][nY][13] , aRotas[nX][1]+"."+cId, "FOLDER10",,,,2)
			next
		endif
	next
	oTreeRota:EndUpdate() // Finaliza a criação dos itens
	oWorner:addInLayout(oTreeRota)
Return


Static Function fUpdTree(cCargo)
	Local nEncon := aScan(aRotas,{|x| AllTrim(x[1]) == cCargo })
	If nEncon > 0
		nIdxRota	:=	nEncon
		SetBrwRota(nEncon)
	Else
		nIdxRota	:=	0
		aRotaAtual:={}
		ASize(aRotaAtual, Len(aRotaAtual))
		if ValType(oBrRota)=="O"
			oBrRota:setArray( aRotaAtual )
			oBrRota:Refresh()
		Endif
	EndIf
Return



/*/ Set Browse Rota Selecionada  /*/
Static Function SetBrwRota(nIdxRota)

	if !Empty(nIdxRota) .and. nIdxRota <= Len(aRotas)
		aRotaAtual:=aClone(aRotas[nIdxRota,2])
		aEval( aRotaAtual, {|x| ADel(x, 2),ASize(x, Len(x) - 1) } )
	Endif 

    if ValType(oBrRota)=="O"
        oBrRota:setArray( aRotaAtual )
        oBrRota:nAt:=1
        oBrRota:GoTop(.t.)
        oBrRota:Refresh()
    Endif
Return

/*/ Tree de formação de Equipe  /*/
Static function pnlAdEqTree(oWorner)
	Local cBmp1 := "PMSEDT3"
	Local cBmp2 := "PMSDOC"

	//Criando o DbTree
	oTreAddEq := DBTree():New(;
	,;              //nTop
	,;              //nLeft
	,;              //nBottom
	,;              //nRight
	oWorner,;       //oWnd
    ,; //bChange
	{||fDelEqTree(oTreAddEq:GetCargo())},;//bRClick
	.T.;                            //lCargo
	)

	oTreAddEq:Align := CONTROL_ALIGN_ALLCLIENT
// Cria a Tree
	oTreAddEq:BeginUpdate()
// Prepara o objeto para receber os itens
	oTreAddEq:SetScroll(1,.T.) // Habilita a barra de rolagem horizontal
	oTreAddEq:SetScroll(2,.T.) // Habilita a barra de rolagem vertical

	oTreAddEq:AddItem("Ajudante: "+Space(60) ,"A"+Space(20), cBmp1 ,cBmp2,,,1)
	oTreAddEq:AddItem("Aju.Periculosidade: "+Space(60) ,"P"+Space(20), cBmp1 ,cBmp2,,,1)
	oTreAddEq:AddItem("Morotista: "+Space(60),"M"+Space(20), cBmp1 ,cBmp2,,,1)
	oTreAddEq:AddItem("Veículo: "+Space(60)  ,"V"+Space(20), cBmp1 ,cBmp2,,,1)
	oTreAddEq:EndUpdate() // Finaliza a criação dos itens
	oWorner:addInLayout(oTreAddEq)
Return

Static Function fDelEqTree(cCargo)
	Local aCargo	:=StrTokArr(cCargo, '.')
	Local cTipMembro:=iif(Len(aCargo)>=2, aCargo[1],'')
	Local cCodMembro:=iif(Len(aCargo)>=2, Alltrim(aCargo[2]),'')
	Local nPosMb1	:= aScan(aMembros,{|x| AllTrim(x[1]) == Alltrim(cTipMembro) })
	Local nPosMb2	:= iif(nPosMb1>0,aScan(aMembros[nPosMb1][2],{|x| AllTrim(x[4]) == Alltrim(cCodMembro) }),0)
	Local nPosEq1	:= aScan(aAddEquipe,{|x| AllTrim(x[1]) == Alltrim(cTipMembro) })
	Local nPosEq2	:= iif(nPosEq1>0,aScan(aAddEquipe[nPosEq1][2],{|x| AllTrim(x[4]) == Alltrim(cCodMembro) }),0)
	Local cBmp1 := "PMSEDT3"
	Local cBmp2 := "PMSDOC"

	If nPosMb2 > 0 .and.  nPosEq2 > 0 .and. aMembros[nPosMb1,2,nPosMb2,1]
		//If MsgYesNo('Confirma exclusao?', 'Exclusao')			
			//Verifica se Items já existe 
			If oTreAddEq:TreeSeek(cCargo)
				oTreAddEq:DelItem()
			Endif
			ADel(aAddEquipe[nPosEq1][2], nPosEq2)
			ASize(aAddEquipe[nPosEq1][2], Len(aAddEquipe[nPosEq1][2])-1)
			oTreAddEq:PTRefresh()

			//Altera tree de membros 
			aMembros[nPosMb1,2,nPosMb2,1]:=.F.
			oTreeMembros:ChangeBmp(cBmp1,cBmp2,,,cCargo)
			oTreeMembros:PTRefresh()
		//EndIf
	EndIf
Return 

static Function SetMembro(cCargo,lAtivo)
	Local aCargo	:=StrTokArr(cCargo, '.')
	Local cTipMembro:=iif(Len(aCargo)>=2, aCargo[1],'')
	Local cCodMembro:=iif(Len(aCargo)>=2, Alltrim(aCargo[2]),'')
	Local nPosMb1	:= aScan(aMembros,{|x| AllTrim(x[1]) == Alltrim(cTipMembro) })
	Local nPosMb2	:= iif(nPosMb1>0,aScan(aMembros[nPosMb1][2],{|x| AllTrim(x[4]) == Alltrim(cCodMembro) }),0)
	Local cAtBmp1 	:= "PMSEDT3"
	Local cAtBmp2 	:= "PMSDOC"
	Local cBlBmp1	:= "PMSEDT1"
	Local cBlBmp2	:= "PMSEDT1"
	if lAtivo 
		aMembros[nPosMb1,2,nPosMb2,1]:=.F.
		oTreeMembros:ChangeBmp(cAtBmp1,cAtBmp2,,,cCargo)
		oTreeMembros:PTRefresh()
	else 
		aMembros[nPosMb1,2,nPosMb2,1]:=.T.
		oTreeMembros:ChangeBmp(cBlBmp1,cBlBmp2,,,cCargo)
		oTreeMembros:PTRefresh()
	Endif 

Return nil 

/*/ Mosta Tree de Motorista e Ajudaste /*/
Static function pnlMembTree(oWorner)
	Local cBmp1 := "PMSEDT3"
	Local cBmp2 := "PMSDOC"
	Local nY ,nX
	Local cIdFilho, cIdPai

	//Criando o DbTree
	oTreeMembros := DBTree():New(;
	,;              //nTop
	,;              //nLeft
	,;              //nBottom
	,;              //nRight
	oWorner,;       //oWnd
    {||fUpdMembTree(oTreeMembros:GetCargo())},; //bChange
	{||fDbcMembTree(oTreeMembros:GetCargo())},;//bRClick
	.T.;                            //lCargo
	)

	oTreeMembros:Align := CONTROL_ALIGN_ALLCLIENT
	// Cria a Tree
	oTreeMembros:BeginUpdate()
	// Prepara o objeto para receber os itens
	oTreeMembros:SetScroll(1,.T.) // Habilita a barra de rolagem horizontal
	oTreeMembros:SetScroll(2,.T.) // Habilita a barra de rolagem vertical
	//oTreeMembros:AddItem("Membros da Equipe"+Space(80),'###'+Replicate('0',nTamSeq),cBmp1,cBmp2,1)
	for nX := 1 to Len(aMembros)
		cIdPai 	:= Alltrim(aMembros[nX][1])
		cDesc	:= iif(aMembros[nX][1]=="M","Motorista",iif(aMembros[nX][1]=="A","Ajudante",iif(aMembros[nX][1]=="P","Aju.Periculosidade","Veículo")))
		oTreeMembros:AddItem(cIdPai+" - "+cDesc+Space(60),cIdPai+Space(20) , cBmp1 ,cBmp2,,,1)

		For nY := 1 to Len(aMembros[nX][2])
			cIdFilho := Alltrim(aMembros[nX][2][nY][4])
			cDesc	 := Alltrim(aMembros[nX][2][nY][5])
			oTreeMembros:TreeSeek(cIdPai)
			oTreeMembros:AddItem(cIdFilho+"-"+cDesc, cIdPai+"."+cIdFilho , cBmp1,,,,2)
		next

	next
	oTreeMembros:EndUpdate() // Finaliza a criação dos itens
	oTreeMembros:Show()
	oWorner:addInLayout(oTreeMembros)
Return


Static Function fUpdMembTree(cCargo)
Return

Static Function fDbcMembTree(cCargo)
	Local aCargo	:=StrTokArr(cCargo, '.')
	Local cTipMembro:=iif(Len(aCargo)>=2, aCargo[1],'')
	Local cCodMembro:=iif(Len(aCargo)>=2, Alltrim(aCargo[2]),'')
	Local nPosMb1	:= aScan(aMembros,{|x| AllTrim(x[1]) == Alltrim(cTipMembro) })
	Local nPosMb2	:= iif(nPosMb1>0,aScan(aMembros[nPosMb1][2],{|x| AllTrim(x[4]) == Alltrim(cCodMembro) }),0)
	Local nPosEq1	:= aScan(aAddEquipe,{|x| AllTrim(x[1]) == Alltrim(cTipMembro) })
	Local nPosEq2	:= iif(nPosEq1>0,aScan(aAddEquipe[nPosEq1][2],{|x| AllTrim(x[4]) == Alltrim(cCodMembro) }),0)
	Local cBmp1 	:= "PMSEDT3"
	Local cBmp2 	:= "PMSEDT4"
	Local cIdPai,cIdFilho,cDesc

	If nPosMb2 > 0 .and.  nPosEq2 == 0 .and. !aMembros[nPosMb1,2,nPosMb2,1]

		cIdPai 	:= Alltrim(aMembros[nPosMb1][1])
		cDesc	:= iif(aMembros[nPosMb1][1]=="M","Motorista",iif(aMembros[nPosMb1][1]=="A","Ajudante",iif(aMembros[nPosMb1][1]=="P","Aju.Periculosidade","Veículo")))
		//Verifica se Items já existe 
		If !oTreAddEq:TreeSeek(cTipMembro)
			oTreAddEq:AddItem(cIdPai+" - "+cDesc+Space(60),cIdPai+Space(20) , cBmp1 ,cBmp2,,,1)
		Endif
		cIdFilho := Alltrim(aMembros[nPosMb1][2][nPosMb2][4])
		cDesc	 := Alltrim(aMembros[nPosMb1][2][nPosMb2][5])
		oTreAddEq:AddItem(cIdFilho+"-"+cDesc, cIdPai+"."+cIdFilho , cBmp1,,,,2)

		if Empty(nPosEq1)
			aadd(aAddEquipe,{cTipMembro,{}})
		Endif 
		nPosEq1	:= aScan(aAddEquipe,{|x| AllTrim(x[1]) == Alltrim(cTipMembro) })
		aadd(aAddEquipe[nPosEq1][2],aClone(aMembros[nPosMb1,2,nPosMb2]))
		//Desabilota o coloborador
		aMembros[nPosMb1,2,nPosMb2,1]:=.T.
		oTreAddEq:PTRefresh()
		
		//Altera tree de membros 
		oTreeMembros:ChangeBmp("PMSEDT1","PMSEDT1",,,cCargo)
		oTreeMembros:PTRefresh()
	EndIf
Return


/*/ Processa Array inicial com todos Atendentes da Equipe/*/
Static Function RunMembros(dData,Turno,cModTrasp)
	Local cAliasTmp     := GetNextAlias()
	Local nContador:=nTotReg:=0
	Local aItem:={}
	Local cModTrpSql:="%'"+cModTrasp+"'%"
	Local cTurnoSql:="%'"+Turno+"'%"
	Local cDataSql :="%'"+DtoS(dData)+"'%"
	Local cCampo1 :="%"+IIf( Upper(TcGetDb()) $ '/ORACLE/',"AA1_XTIPO||AA1_CODTEC","AA1_XTIPO+AA1_CODTEC")+"%"
	Local cCampo2 :="%"+IIf( Upper(TcGetDb()) $ '/ORACLE/',"ZX1_TIPO||ZX1_ID_AA1","ZX1_TIPO+ZX1_ID_AA1")+"%"

	aMembros:={}
	BeginSql Alias cAliasTmp
		%NoParser%
		SELECT * FROM (	
			SELECT AA1_XTIPO,AA1_FILIAL,AA1_CODTEC,AA1_NOMTEC,AA1_XPLACA,R_E_C_N_O_ as RECAA1     
			FROM %table:AA1% AA1  
			WHERE AA1.%NotDel% 
			and  AA1_XTIPO IN ('M','A','P')
			AND  AA1_FILIAL = %EXP:xfilial("AA1")% 
			AND  AA1_ALOCA  = '1'
			AND AA1_XMDTRP = %EXP:cModTrpSql% 
			UNION 
			SELECT 'V' AS AA1_XTIPO, DA3_FILIAL,DA3_COD,DA3_DESC,DA3_PLACA,R_E_C_N_O_ as RECDA3
			FROM %table:DA3% DA3 
			where DA3.%NotDel% 
			AND DA3_ATIVO<>'2'
			AND DA3_XMDTRP = %EXP:cModTrpSql% 
			AND DA3_FILIAL = %EXP:xfilial("DA3")% 
		) TRX 
		WHERE  NOT %EXP:cCampo1%  IN 
			(SELECT %EXP:cCampo2%  FROM %table:ZX0% ZX0 
			inner join %table:ZX1%  ZX1 ON ZX1_FILIAL=ZX0_FILIAL AND ZX1_ID_ZX0=ZX0_COD AND ZX1.ZX1_STATUS='1'  AND ZX1.%NotDel% 
			WHERE ZX0.ZX0_DTINI=%EXP:cDataSql% 
			AND ZX0_TURNO =%EXP:cTurnoSql% 
			AND ZX0.%NotDel% 
			AND ZX0.ZX0_STATUS=' ' 
			)
		ORDER BY AA1_XTIPO,AA1_CODTEC 
	EndSql

	nTotReg := Contar(cAliasTmp,"!Eof()")

	(cAliasTmp)->(DbGoTop())
	procRegua(nTotReg)
	While  (cAliasTmp)->(!Eof())
		cCond1:=(cAliasTmp)->AA1_XTIPO
		aItem:={}
		While  (cAliasTmp)->(!Eof()) .and. cCond1 == (cAliasTmp)->AA1_XTIPO
			nContador++
			IncProc(cValToChar(nContador) + ' de ' + cValToChar(nTotReg))
			aadd(aItem,{;
				.f. ,; //reservado 
				(cAliasTmp)->RECAA1,;
				(cAliasTmp)->AA1_XTIPO,;
				(cAliasTmp)->AA1_CODTEC,;
				(cAliasTmp)->AA1_NOMTEC,;
				(cAliasTmp)->AA1_XPLACA;
				};
			)
			(cAliasTmp)->(DBSkip(/*nReg*/))
		End
		aadd(aMembros,{cCond1,aItem})
	end
	(cAliasTmp)->(dbCloseArea())
Return !Empty(aMembros)

/*/ Equipes quandro 2 /*/


/*/ Mosta Tree de Motorista e Ajudaste /*/
Static function pnlEqTree(oWorner)

	//Criando o DbTree
	oTreeEqui := DBTree():New(;
	,;              //nTop
	,;              //nLeft
	,;              //nBottom
	,;              //nRight
	oWorner,;       //oWnd
    {||fUpdEqTree(oTreeEqui:GetCargo())},; //bChange
	{||fExcEqTree(oTreeEqui:GetCargo())},; //bRClick
	.T.;                            //lCargo
	)

	oTreeEqui:Align := CONTROL_ALIGN_ALLCLIENT
// Cria a Tree
	oTreeEqui:BeginUpdate()

// Prepara o objeto para receber os itens
	oTreeEqui:SetScroll(1,.T.) // Habilita a barra de rolagem horizontal

	oTreeEqui:SetScroll(2,.T.) // Habilita a barra de rolagem vertical
	UpdTreEqui()
	oTreeEqui:EndUpdate() // Finaliza a criação dos itens
	oWorner:addInLayout(oTreeEqui)
Return

/*/Clique Botão Esquerdo do Tree Equipes/*/
Static Function fUpdEqTree(cCargo)
	Local nEncon := aScan(aEquipes,{|x| AllTrim(x[1]) == cCargo })
	If nEncon > 0
		nIdxEquipe:=nEncon
		SetBrwEq(nEncon)
	Else
		nIdxEquipe :=0
		aEquipeAtual:={}
		ASize(aEquipeAtual, Len(aEquipeAtual))
		if ValType(oBrEquipe)=="O"
			oBrEquipe:setArray( aEquipeAtual )
			oBrEquipe:Refresh()
		Endif
	EndIf
Return

/*/Clique Botão Direito do Tree Equipes para Exclusão /*/
Static Function fExcEqTree(cCargo)
	if oTreeEqui:Nivel()==1 .and. u_ETTCP03B(cCargo)
		RunEquipe(dDtAgenda,cTurnoAgenda,cModTransp)
		UpdTreEqui()
		UpdTreMembros()
		if ValType(oBrEquipe)=="O"
			aEquipeAtual:={}
			ASize(aEquipeAtual,0)
			oBrEquipe:setArray( aEquipeAtual )
			oBrEquipe:Refresh()
		Endif
	Endif 
Return


/*/ Set Browse Rota Selecionada  /*/
Static Function SetBrwEq(nIndex)
	if !Empty(nIndex) .and. nIndex <= Len(aEquipes)
		aEquipeAtual:=aClone(aEquipes[nIndex,2])
	Endif 
    if ValType(oBrEquipe)=="O" 
        oBrEquipe:setArray( aEquipeAtual )
        oBrEquipe:GoTop(.t.)
        oBrEquipe:Refresh()
    Endif
Return

/*/ Processa Array inicial com todos Atendentes da Equipe/*/
Static Function RunEquipe(dData,cTurno,cModTrasp)
	Local cAliasTmp     := GetNextAlias()
	Local nContador:=nTotReg:=0
	Local aItem:={}
	Local cModTrpSql:="%'"+cModTrasp+"'%"
	Local cDtAgSql:="%'"+Dtos(dData)+"'%"
	Local cTurnSql:="%'"+cTurno+"'%"
	aEquipes:={}
	ASize(aEquipes,0)
	BeginSql Alias cAliasTmp
		%NoParser%
		select ZX0_COD,ZX0_TURNO,ZX1.ZX1_TIPO,ZX1_ID_AA1,AA1_NOMTEC    
		from %table:ZX0% ZX0
		inner join %table:ZX1% ZX1 ON ZX1_FILIAL=ZX0_FILIAL AND ZX1_ID_ZX0=ZX0_COD AND ZX1.ZX1_STATUS='1'  AND ZX1.%NotDel% 
		INNER JOIN %table:AA1% AA1 ON AA1.AA1_FILIAL =%EXP:xfilial("AA1")%  AND AA1_CODTEC=ZX1.ZX1_ID_AA1 AND AA1.%NotDel% 
		WHERE ZX0.%NotDel% 
		AND ZX0.ZX0_TURNO =%Exp:cTurnSql%	    
		AND ZX0.ZX0_DTINI >=%Exp:cDtAgSql%	    
		AND ZX0.ZX0_DTFIM <=%Exp:cDtAgSql%	    
		AND ZX0_FILIAL = %EXP:xfilial("ZX0")% 
		AND ZX0_STATUS ='1'
		AND ZX0_XMDTRP = %EXP:cModTrpSql% 
		AND ZX1.ZX1_TIPO IN ('A','M','P')
		UNION 
		select ZX0_COD,ZX0_TURNO,ZX1.ZX1_TIPO,ZX1_ID_AA1,DA3_DESC    
		from %table:ZX0% ZX0
		inner join %table:ZX1% ZX1 ON ZX1_FILIAL=ZX0_FILIAL AND ZX1_ID_ZX0=ZX0_COD AND ZX1.ZX1_STATUS='1'  AND ZX1.%NotDel% 
		INNER JOIN %table:DA3% DA3 ON DA3.DA3_FILIAL =%EXP:xfilial("DA3")%  AND DA3_COD=ZX1.ZX1_ID_AA1 AND DA3.%NotDel% AND DA3.DA3_ATIVO='1' 
		WHERE ZX0.%NotDel% 
		AND ZX0.ZX0_TURNO =%Exp:cTurnSql%	    
		AND ZX0.ZX0_DTINI >=%Exp:cDtAgSql%	    
		AND ZX0.ZX0_DTFIM <=%Exp:cDtAgSql%
		AND ZX0_XMDTRP = %EXP:cModTrpSql% 	    
		AND ZX0_FILIAL = %EXP:xfilial("ZX0")% 
		AND ZX0_STATUS ='1'
		AND ZX1.ZX1_TIPO IN ('V')
		ORDER BY ZX0_COD,ZX0_TURNO,ZX1_TIPO,ZX1_ID_AA1,AA1_NOMTEC
	EndSql

	nTotReg := Contar(cAliasTmp,"!Eof()")

	(cAliasTmp)->(DbGoTop())
	procRegua(nTotReg)
	While  (cAliasTmp)->(!Eof())
		cCond1:=(cAliasTmp)->ZX0_COD
		aItem:={}
		While  (cAliasTmp)->(!Eof()) .and. cCond1 == (cAliasTmp)->ZX0_COD
			nContador++
			IncProc(cValToChar(nContador) + ' de ' + cValToChar(nTotReg))
			aadd(aItem,{;
				(cAliasTmp)->ZX0_COD,;
				(cAliasTmp)->ZX0_TURNO,;
				(cAliasTmp)->ZX1_TIPO,;
				(cAliasTmp)->ZX1_ID_AA1,;
				(cAliasTmp)->AA1_NOMTEC;
				};
			)
			(cAliasTmp)->(DBSkip(/*nReg*/))
		End
		aadd(aEquipes,{cCond1,aItem,.f.})
	end
	ASize(aEquipes,Len(aEquipes))
	(cAliasTmp)->(dbCloseArea())
Return !Empty(aEquipes)


Static Function pnlAdEqBtn(oWoner)
	Local cCSucess 	:=BtnCircular("#00FA9A"/*background*/,"#00000"/*cCorText*/,"10"/*pTamanho*/,"#32CD32"/*backHover*/,"#FFF"/*textHover*/,15/*Radius */)
	Local cCCancel 	:=BtnCircular("#0eb0e6"/*background*/,"#00000"/*cCorText*/,"10"/*pTamanho*/,"#2246b2"/*backHover*/,"#FFF"/*textHover*/,15/*Radius */)


	oBtAtualizar := TButton():New( , , "Criar Equipe", oWoner,{||fCriaEquipe()}, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
	oBtAtualizar:SetCSS( cCSucess )
	
	oBtCancela := TButton():New( , , "Importar Equipe", oWoner,{||fImpEquipe()}, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
	oBtCancela:SetCSS( cCCancel )

	oWoner:addInLayout(oBtAtualizar)
	oWoner:addInLayout(oBtCancela)

Return nil

Static Function pnlBtnRota(oWoner)
	Local cCSucess 	:=BtnCircular("#78a1f3"/*background*/,"#00000"/*cCorText*/,"10"/*pTamanho*/,"#3814c5"/*backHover*/,"#FFF"/*textHover*/,15/*Radius */)
	oBtAtualizar := TButton():New( , , "Criar Rota", oWoner,{||fCriaRota()}, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
	oBtAtualizar:SetCSS( cCSucess )
	
	oWoner:addInLayout(oBtAtualizar)

Return nil


Static  Function BtnCircular(background,cCorText,pTamanho,backHover,textHover,radius)
	Local cCorFundo:=iif(background=nil,"#DCDCDC",background)
	Local cCorTexto:=iif(cCorText=nil,"#00000",cCorText)
	Local cTamanho:=iif(pTamanho=nil,"16",pTamanho)
	Local cbackhover:=iif(backhover=nil,"#A9A9A9",backhover)
	Local ctextHover:=iif(textHover=nil,"#FFFAFA",textHover)
	Local cCssBtn := ""
	cCssBtn +="QPushButton { font-family: Arial, Helvetica, sans-serif } "
	cCssBtn +="QPushButton { color: "+cCorTexto+" } "
	cCssBtn +="QPushButton { font-size: "+cTamanho+"px } "
	cCssBtn +="QPushButton { font-weight: bold } "
	cCssBtn += "QPushButton { border: 2px solid #CECECE }"
	cCssBtn += "QPushButton { padding: 10px }"

	cCssBtn +="QPushButton { background-color: "+cCorFundo+" } "
	cCssBtn +="QPushButton { border-radius: "+cValtoChar(radius)+"%} "
	cCssBtn +="QPushButton { width: "+cValtoChar(radius)+"% }"
	cCssBtn +="QPushButton { height: "+cValtoChar(radius)+"% }"

	cCssBtn +="QPushButton:hover { color: "+ctextHover+" }"
	cCssBtn +="QPushButton:hover {  border: 2px solid #0000FF }"
	cCssBtn +="QPushButton:hover {  background-color: "+cbackhover+"}"

Return cCssBtn

Static Function fCriaEquipe()
Local aEquiAdd:={}
Local cTipMembro:=""
Local cCodMembro:=""
Local ix, ij 
Local cBmp1 := "PMSEDT3"
Local cBmp2 := "PMSDOC"

	For ix:=1 to Len(aAddEquipe)
		if Len(aAddEquipe[iX])<=2 .and. ValType(aAddEquipe[iX][2])=="A"
			For ij:=1 to Len(aAddEquipe[iX][2])
				cTipMembro	:=aAddEquipe[iX][2][ij][3]
				cCodMembro	:=aAddEquipe[iX][2][ij][4]
				aadd(aEquiAdd,{cTipMembro,cCodMembro})
			Next 
		Endif 
	Next 

	if u_ETTCP03A(cTurnoAgenda,dDtAgenda,aEquiAdd,cModTransp)
		RunEquipe(dDtAgenda,cTurnoAgenda,cModTransp)
		UpdTreEqui()
		aAddEquipe    	:={}
		ASize(aAddEquipe, 0)
		oTreAddEq:Reset()
		oTreAddEq:AddItem("Ajudante: "+Space(60) ,"A"+Space(20), cBmp1 ,cBmp2,,,1)
		oTreAddEq:AddItem("Aju.Periculosidade: "+Space(60) ,"P"+Space(20), cBmp1 ,cBmp2,,,1)
		oTreAddEq:AddItem("Morotista: "+Space(60),"M"+Space(20), cBmp1 ,cBmp2,,,1)
		oTreAddEq:AddItem("Veículo: "+Space(60)  ,"V"+Space(20), cBmp1 ,cBmp2,,,1)
		oTreAddEq:PTRefresh()
	Endif 
Return nil 

/*/ Incluir dados no Tree de Equipes /*/
Static function UpdTreEqui()
	Local cBmp1 := "PMSEDT3"
	Local cBmp2 := "PMSDOC"
	Local nY ,nX
	Local cId,cDesc,cCodEq,cTurno,cTipo,cCodTec,cNome,cCargo 	
	oTreeEqui:Reset()
	For nX := 1 to Len(aEquipes)
			cId 	:= aEquipes[nX][1]
			oTreeEqui:AddItem("Equipe:"+cId+Space(80),cId, cBmp1 ,cBmp2,,,1)
			If oTreeEqui:TreeSeek(cId)
				For nY := 1 to Len(aEquipes[nX][2])
					cCodEq 	:= aEquipes[nX][2][nY][1] 
					cTurno 	:= aEquipes[nX][2][nY][2]
					cTipo 	:= aEquipes[nX][2][nY][3]
					cCodTec := aEquipes[nX][2][nY][4]
					cNome 	:= aEquipes[nX][2][nY][5]
					cDesc	:= cCodTec+" ("+cTipo+") "+cNome 
					cId		:= cCodEq+"."+cCodTec
					cCargo	:=cTipo+"."+cCodTec
					oTreeEqui:AddItem(cDesc,cCodTec, "FOLDER10",,,,2)
					SetMembro(cCargo,.f.)
				next
			endif
	Next
Return nil 

/*/ Update de Membros e Equipes  valida se existe membros em uma equipe ou em um formação de equipe /*/
Static function UpdTreMembros()
	Local nY ,nX
	Local cIdPai,cIdFilho,lStatus
	Local cCargo 
	Local aCoord	:={}


	For nX := 1 to Len(aMembros)
		cIdPai 	:= aMembros[nX][1]
		For nY := 1 to Len(aMembros[nX][2])
			lStatus := .F.
			aCoord	:={}
			cIdFilho:= aMembros[nX][2][nY][4] 
			cCargo	:=cIdPai+"."+cIdFilho
			// Varre as linhas da aEquipes
			aEval(aEquipes, { |aLinha| ;
				aEval(aLinha[2], { |x, nCol| ;
					If( Alltrim(x[4]) == Alltrim(cIdFilho), (lStatus := .T.,aadd(aCoord,x[4])), Nil) ;
				}) ;
			})
			SetMembro(cCargo,!lStatus)
		next
	Next
Return nil 



/*/ Separa os caracteres de String com um caracter informado/*/
Static  Function SepararCaracteres(cTexto,cSeparador)
    Local cNovoTexto := ""
    Local nI := 0
    Local nTam := Len(cTexto)

    For nI := 1 To nTam
        // Adiciona o caractere atual
        cNovoTexto += SubStr(cTexto, nI, 1)
        // Se não for o último caractere, adiciona o ponto e vírgula
        If nI < nTam
            cNovoTexto += cSeparador
        EndIf
    Next nI
Return cNovoTexto

/*/ Função do Botão de Atualizar Ordem de Serviço na Tela Inicial /*/
Static Function fAtuOrderServ()
	aData:=UpdDataOS()
	aHeadCampos :=aClone(aData[1])
	aDataOS     :=aClone(aData[2])
	
	ASize(aDataOS,Len(aDataOS)	)
	// 1. Informa ao Browse que o Array foi modificado/redefinido
	oBrOS:SetArray( aDataOS )
	// 2. Força o componente a recalcular o tamanho e as linhas do Array
	oBrOS:Reset()
	// 3. Redesenha o componente na tela para o usuário
	oBrOS:Refresh()
	oBrOS:SetFocus()

	aAtendimento:={}
	ASize(aAtendimento,Len(aAtendimento)	)
	oBrGrp:SetArray( aAtendimento )
	// 2. Força o componente a recalcular o tamanho e as linhas do Array
	oBrGrp:Reset()
	// 3. Redesenha o componente na tela para o usuário
	oBrGrp:Refresh()
Return nil 

Static Function fImpEquipe()
Local cCodEquipe:=SelEquipe(dDtAgenda-1)
Return cCodEquipe

/*/ Tela de seleção Equipe do dia Anterior para Importação /*/
Static Function SelEquipe(dData)
Local cQuery 	:=""
Local cCampoOk	:="ZX0_Ok"
Local cCampoRet	:="RECZX0"
Local aFields 	:={}
Local cTitulo	:="Seleção Equipe "
Local cSubTitulo:="Lista Equipes"
	Default cFornece:=""
	Default cLoja:=""
	Default dDtVenc:=ctod("//")
	Default nValor:=0
    aAdd( aFields, {"ZX0_COD"       ,FWX3Titulo("ZX0_COD"   )	    ,TamSX3("ZX0_COD"   )[1]})
    aAdd( aFields, {"ZX0_TURNO"     ,FWX3Titulo("ZX0_TURNO" )	    ,TamSX3("ZX0_TURNO" )[1]})
    aAdd( aFields, {"ZX1_TIPO"   	,FWX3Titulo("ZX1_TIPO")			,TamSX3("ZX1_TIPO")[1]})
    aAdd( aFields, {"ZX1_TIPO"      ,FWX3Titulo("ZX1_TIPO"  )	    ,TamSX3("ZX1_TIPO"  )[1]})
    aAdd( aFields, {"ZX1_ID_AA1"    ,FWX3Titulo("ZX1_ID_AA1")	    ,TamSX3("ZX1_ID_AA1")[1]})
    aAdd( aFields, {"AA1_NOMTEC"    ,FWX3Titulo("AA1_NOMTEC")	    ,TamSX3("AA1_NOMTEC")[1]})
	
	cQuery += "	SELECT ZX0_COD,ZX0_TURNO,ZX1.ZX1_TIPO,ZX1_ID_AA1,AA1_NOMTEC "
	cQuery += "	from "+RetSqlName("ZX0")+" ZX0 "
	cQuery += "	inner join "+RetSqlName("ZX1")+" ZX1 ON ZX1_FILIAL=ZX0_FILIAL AND ZX1_ID_ZX0=ZX0_COD AND ZX1.ZX1_STATUS='1'  AND ZX1.D_E_L_E_T_<>'*' "
	cQuery += "	INNER JOIN "+RetSqlName("AA1")+" AA1 ON AA1.AA1_FILIAL ='"+xFilial("AA1")+"' AND AA1_CODTEC=ZX1.ZX1_ID_AA1 AND AA1.D_E_L_E_T_<>'*' "
	cQuery += "	WHERE ZX0.D_E_L_E_T_<>'*' "
	//cQuery += "	AND ZX0.ZX0_TURNO =%Exp:cTurnSql% "
	cQuery += "	AND ZX0_FILIAL = '"+xFilial("ZX0")+"'"
	if !Empty(dData)
		cQuery += "	AND ZX0_DTINI>='"+DtoS(dData)+"' AND ZX0_DTFIM <= '"+DtoS(dData)+"' "
	Endif 

	cQuery += "	ORDER BY ZX0_COD,ZX0_TURNO,ZX1.ZX1_TIPO,ZX1_ID_AA1,AA1_NOMTEC

Return u_SG_BrwOk(cQuery,aFields,cCampoOk,cCampoRet,cTitulo,cSubTitulo)

/*/ Rotina que abre um mark browse de seleção de unico registro  /*/
User  Function SG_BrwOk(cQuery,aFields,cCampOk,cCampRet,cTitulo,cSubTitulo)
    Local aColumns := {}
    Private cAlias := GetNextAlias()
    Private aReturn:=nil
    Private oModal

    oFontM := TFont():New('Courier new',,12,.T.)
    //Alimenta o array de Campos
    f_Campos(aFields,@aColumns)

    oModal:= FWDialogModal():New()
    oModal:SetEscClose(.F.)
    oModal:setTitle(cTitulo) 
    oModal:setSubTitle(cSubTitulo)

    //Seta a largura e altura da janela em pixel
    oModal:setSize(250, 350)

    oModal:createDialog()

    oContainer := TPanel():New( ,,, oModal:getPanelMain() )
    oContainer:Align := CONTROL_ALIGN_ALLCLIENT

    oBrwData:=FWMarkBrowse():New()
    oBrwData:SetIgnoreARotina(.T.)
    oBrwData:SetMenuDef( "" )

    oModal:addCloseButton({|| aReturn:=fReturn(oBrwData,cCampOk,cCampRet)}, "Cofirmar")
    
    oBrwData:SetColumns( aColumns )
    oBrwData:SetDataQuery()
    oBrwData:SetQuery( cQuery )
    oBrwData:SetAlias( cAlias )
    oBrwData:SetMenuDef('')
    oBrwData:SetFieldMark( cCampOk )
    oBrwData:setOwner( oContainer )
    oBrwData:SetAfterMark({ || fMark(oBrwData,cCampOk,(cAlias )->(Recno())) }) 
    oBrwData:Activate()
    oModal:Activate()

	FreeObj(oModal/*oObj*/)
	FreeObj(oBrwData/*oObj*/)
	FreeObj(oContainer/*oObj*/)

return aReturn


/*/ Rotina que retorna String com as Ordem Marcadas para usar no filtro do relatório /*/
Static Function f_Campos(aFields,aColumns)
    Local nContFlds
   
    For nContFlds := 1 To Len( aFields )
        AAdd( aColumns, FWBrwColumn():New() )
        aColumns[Len(aColumns)]:SetData( &("{ || " + aFields[nContFlds][1] + " }") )
        aColumns[Len(aColumns)]:SetTitle( aFields[nContFlds][2] )
        aColumns[Len(aColumns)]:SetSize( aFields[nContFlds][3] )
        aColumns[Len(aColumns)]:SetID( aFields[nContFlds] )
    Next nContFlds
Return nil


/*/ Rotina que retorna String com Query usada no tela de filtro /*/
Static function fMark(oBrowse,cCampoOk,nRecAtual)
    local _cAlias	:=	oBrowse:Alias()
    local aRest		:=	GetArea()
    (_cAlias)->(DbGoTop())
    while (_cAlias)->(!Eof())
            if (_cAlias)->(Recno())!= nRecAtual .and.  RECLOCK( _cAlias, .f. )
                (_cAlias)->&(cCampoOk):=""
                (_cAlias)->(MSUNLOCK())
            Endif
        (_cAlias)->(DbSkip())
    end
    RestArea(aRest)
    oBrowse:refresh(.F.)
Return .T.

/*/ Rotina que retorna String com os Registros Marcados /*/
Static Function fReturn(oBrowse,cCampoOk,cCampoRet)
    Local xOrdem:={}
    local _cAlias	:=	oBrowse:Alias()
    (_cAlias)->(DbGoTop())
    while (_cAlias)->(!Eof())
        If !Empty((_cAlias)->&(cCampoOk)) 
            aadd(xOrdem,(_cAlias)->&(cCampoRet))
        Endif
        (_cAlias)->(DbSkip())
    end
    oModal:OOWNER:END()
return xOrdem

/*/ Rotina de criação de Rota de atendimento de Ordem de Serviço/*/
Static Function fCriaRota()
Local aOS:={}
Local cTipMembro:=""
Local cCodMembro:=""
Local ix 
Local cBlBmp1 := "PMSEDT4"
Local cBlBmp2 := "FOLDER7"
	//Se Não tiver equipe selecionada ou Rota não processa 
	if Empty(nIdxRota) .or. Empty(nIdxEquipe)
		MsgInfo("Erro Equipe ou Rota não selecionados","Erro")
		Return nil 
	Endif 
	//Verifa se Equipe ou Rota já foram usadas 
	lUsado:=.f. 
	//Se não encontrou indice de Equipe no array aEquipes
	if Len(aEquipes) < nIdxEquipe
		MsgInfo("Erro Equipe não selecionados","Erro")
		Return nil 
	Endif   
	if Len(aRotas) < nIdxRota 
		MsgInfo("Erro Rota não selecionados","Erro")
		Return nil 	
	Endif   	
	if aRotas[nIdxRota][3] == .T.
		MsgInfo("Rota Bloqueada. Registro já Criados","Erro")
		Return nil 
	Endif 
	if aEquipes[nIdxEquipe][3] == .T.
		MsgInfo("Equipe Bloqueada. Registro já Criados","Erro")
		Return nil 
	Endif 

	For ix:=1 to Len(aRotaAtual)
		aadd(aOS,aRotaAtual[ix][2])
	Next 
	cNumEquipe:=aEquipes[nIdxEquipe][1]

	if u_ETTCP02A(cTurnoAgenda,dDtAgenda,cNumEquipe,aOS,aRotas[nIdxRota][1])
		aRotas[nIdxRota][3] := .T.
		aEquipes[nIdxEquipe][3]:= .T.
		//Adiciona os vinculos 
		If !oTreZX2:TreeSeek("00000000000")
			oTreZX2:AddItem("Atendimentos"+Space(60),cIdPai+Space(20) ,"FOLDER13" ,"AGENDA",,,1)
		Endif
		oTreZX2:AddItem(aRotas[nIdxRota][1]+" x "+cNumEquipe, aRotas[nIdxRota][1]+"."+cNumEquipe , "PMSEDT2",,,,2)
		oTreZX2:PTRefresh()

		oTreeRota:ChangeBmp(cBlBmp1,cBlBmp2,,,aRotas[nIdxRota][1])
		oTreeRota:PTRefresh()

		oTreeEqui:ChangeBmp(cBlBmp1,cBlBmp2,,,cNumEquipe)
		oTreeEqui:PTRefresh()
		//Atualiza Tree ZX2
		//UPDBrwZX2(cTurnoAgenda,dDtAgenda)
	Endif 
Return nil 

/*/ Mosta Tree de Motorista e Ajudaste /*/
Static function pnlAtenTree(oWorner)
	Local cBmp1 := "PMSEDT3"
	Local cBmp2 := "PMSDOC"
	Local nY ,nX
	Local cId,cDesc

	//Criando o DbTree
	oTreZX2 := DBTree():New(;
	,;              //nTop
	,;              //nLeft
	,;              //nBottom
	,;              //nRight
	oWorner,;       //oWnd
    /*{||fUpdEqTree(oTreeEqui:GetCargo())}*/,; //bChange
	/*{||fExcEqTree(oTreeEqui:GetCargo())}*/,; //bRClick
	.T.;                            //lCargo
	)


	//oTreZX2:Align := CONTROL_ALIGN_ALLCLIENT
	// Cria a Tree
	oTreZX2:BeginUpdate()

	// Prepara o objeto para receber os itens
	oTreZX2:SetScroll(1,.T.) // Habilita a barra de rolagem horizontal

	oTreZX2:SetScroll(2,.T.) // Habilita a barra de rolagem vertical
	//UpdTreZX2(dDtAgenda,cTurnoAgenda)
	oTreZX2:AddItem("Atendimentos"+Space(60),"00000000000", "FOLDER13" ,"AGENDA",,,1)
	oTreZX2:EndUpdate() // Finaliza a criação dos itens
	oWorner:addInLayout(oTreZX2)
Return


/*/ Incluir dados no Tree de Equipes /*/
Static function UpdTreZX2(dData,cTurno)
	Local cBmp1 := "PMSEDT3"
	Local cBmp2 := "PMSDOC"
	Local cId
	Local cAliasTmp     := GetNextAlias()
	Local nContador:=nTotReg:=0
	Local cDtAgSql:="%'"+Dtos(dData)+"'%"
	Local cTurnSql:="%'"+cTurno+"'%"

	BeginSql Alias cAliasTmp
		%NoParser%
		select ZX2.ZX2_FILIAL,ZX2.ZX2_COD,ZX2.ZX2_DTPRO,ZX2.ZX2_STATUS,ZX2.ZX2_EQUIPE   
		FROM %table:ZX2%  ZX2
		WHERE ZX2.%NotDel% 
		AND ZX2.ZX2_DTPRO=%Exp:cDtAgSql%	    
		AND ZX2.ZX2_TURNOP=%Exp:cTurnSql%	    
		AND ZX2.ZX2_FILIAL = %EXP:xfilial("ZX2")% 
		ORDER BY ZX2_FILIAL,ZX2_COD,ZX2.ZX2_DTPRO,ZX2.ZX2_STATUS
	EndSql

	

	(cAliasTmp)->(DbGoTop())
	procRegua(nTotReg)
	oTreZX2:Reset()
	nEquipe:=0
	While  (cAliasTmp)->(!Eof())
		IncProc(cValToChar(nContador) + ' de ' + cValToChar(nTotReg))
		nEquipe++
		cId 	:= (cAliasTmp)->ZX2_COD
		// Insere itens
		oTreZX2:AddItem("Atendimento:"+cId,cId, "FOLDER5" ,,,,1)

		If oTreZX2:TreeSeek(cId)
			oTreZX2:AddItem("O.S.",cId+".OS", "FOLDER10",,,,2)
		Endif 


			ZX3->(DbSetOrder(1))//ZX3_FILIAL, ZX3_ID_ZX2, ZX3_VERSAO, ZX3_ITEM, R_E_C_N_O_, D_E_L_E_T_
			ZX3->(DbSeek((cAliasTmp)->ZX2_FILIAL+(cAliasTmp)->ZX2_COD))
			While  ZX3->(!Eof()) .and.(cAliasTmp)->ZX2_FILIAL == ZX3->ZX3_FILIAL .AND. (cAliasTmp)->ZX2_COD == ZX3->ZX3_ID_ZX2
				If oTreZX2:TreeSeek(cId+".OS")
					oTreZX2:AddItem(ZX3->ZX3_ID_OS,ZX3->ZX3_ID_OS, "FOLDER6",,,,2)
				Endif 

				ZX3->(DBSkip(/*nReg*/))
			End

		If oTreZX2:TreeSeek(cId)
			oTreZX2:AddItem("Equipe",cId+".EQ", "FOLDER10",,,,2)
		Endif 

			ZX1->(DbSetOrder(1))//ZX1_FILIAL, ZX1_ID_ZX0, ZX1_VERSAO, ZX1_ID_AA1, ZX1_TIPO, R_E_C_N_O_, D_E_L_E_T_
			ZX1->(DbSeek((cAliasTmp)->ZX2_FILIAL+(cAliasTmp)->ZX2_EQUIPE))

			While  ZX1->(!Eof()) .and.(cAliasTmp)->ZX2_FILIAL == ZX1->ZX1_FILIAL .AND. (cAliasTmp)->ZX2_EQUIPE == ZX1->ZX1_ID_ZX0
				If oTreZX2:TreeSeek(cId+".EQ")
					oTreZX2:AddItem(ZX1->ZX1_ID_AA1+Space(80),ZX1->ZX1_ID_AA1, "FOLDER6",,,,3)
				Endif 
				ZX1->(DBSkip(/*nReg*/))
			End
		(cAliasTmp)->(DBSkip(/*nReg*/))
	end
	oTreZX2:PTRefresh()
	(cAliasTmp)->(dbCloseArea())
Return nil 


/*/ Rotina que pega a Sequencia de numero para formação de Equipe/*/
User Function fSeqZX2Num()
Local cNumero:=PadL(GetSXENum("ZX2","ZX2_COD"),TamSx3("ZX2_COD")[1],"0")
    While  ZX2->(!Eof()) .and. ZX2->(DbSeek(xFilial("ZX2")+cNumero))
        cNumero:=PadL(GetSXENum("ZX2","ZX2_COD"),TamSx3("ZX2_COD")[1],"0")
    End
Return cNumero 

