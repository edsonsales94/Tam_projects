#include "totvs.ch" 
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwizard.ch"

/*/{Protheus.doc} BHAPCP05

Rotina de apontamento de produção

@author    Paulo Romualdo
@since     14/11/2017
@version   Protheus 12

/*/

User Function BHAPCP05()

	Local 	oSize		:= nil
	Local 	oNewPag		:= nil
	Local 	oPanel		:= nil
	Local 	oStepWiz	:= nil
	Local 	oDlg1		:= nil
	Local 	oPanelBkg	:= nil
	Local 	oGet1		:= nil
	Local 	lOpen		:= .F.	
	Local 	cTitulo		:= "Apontamento de Producao" 

	Private cNumOP		:= Space(TamSX3("C2_NUM")[1] + TamSX3("C2_ITEM")[1] + TamSX3("C2_SEQUEN ")[1] + TamSX3("G2_CODIGO")[1]) 
	Private cOrdProd	:= ""  		
	Private cOperac		:= Space(TamSX3("G2_CODIGO")[1])	
	Private cCodRecur 	:= Space(TamSX3("H1_CODIGO")[1])	
	Private cCodCmba	:= Space(6)//space(tamSx3("Z06_CODIGO")[1])
	Private cCodCarr	:= Space(6)//space(tamSx3("Z06_CODIGO")[1])	
	Private nPesoCmba	:= 0
	Private nPesoCarr	:= 0
	Private nPesoTot	:= 0
	Private nPesoUnit	:= 0
	Private nAmostra	:= 0
	Private nQtdApont	:= 0
	Private cIDUser		:= Space(tamSx3("H6_OPERADO")[1])
	Private cCodUser	:= ""
	Private cPassword	:= Space(20)
	Private cObserv		:= ""
	Private lIncApon	:= .F.

	Private nCol1		:= 008
	Private nCol2		:= 160
	Private nCol3		:= 290
	Private nSltLin		:= 50	
	Private nSayTamCom	:= 135
	Private nsayTamLar	:= 025
	Private nGetTamCom	:= 120
	Private nGetTamLar	:= 025
	Private nGetTamVlr	:= 180

	Private oFontSay	:= TFont():New('Courier new',,50,.T.,.T.)
	Private oFontGet	:= TFont():New('Courier new',,40,.T.,.T.)
	Private oFontBtn	:= TFont():New('Courier new',,50,.T.,.T.)

	Private oSay5		:= Nil
	Private oSay99		:= Nil
	Private oSay98		:= Nil
	
	Private _cCodPro	:= "" // variavel utilizada na consulta padrao ZZSG21		
	Private _cCodRot	:= "" // variavel utilizada na consulta padrao ZZSG21	
	Private bCancel		:= { || lOpen := .T., oDlg1:end() }
	Private bFinish		:= { || iif( valida_pg3(@oGet1), runRotAut(@cObserv), Nil) }
	Private oGetUsr		:= Nil
	Private lOsys		:= .F.
	
	oSize := FWDefSize():New(.T.)
	oSize:AddObject("HEADER", 100, 100, .T., .T. )  
	oSize:lProp := .T.  	
	oSize:Process() 		
//oSize:aWindSize[1]

    //DEFINE DIALOG oDlg1 TITLE cTitulo PIXEL //STYLE nOR(  WS_VISIBLE ,  WS_POPUP )
    //oDlg1:nWidth  := 1700
    //oDlg1:nHeight := 900
    //oPanelBkg:= tPanel():New(0,0,"",oDlg1,,,,,,600,600)
    //oPanelBkg:Align := CONTROL_ALIGN_ALLCLIENT
    
	//oDlg1 := MSDialog():New(oSize:aWindSize[1], oSize:aWindSize[2], oSize:aWindSize[3], oSize:aWindSize[4], cTitulo,,,.F.,,,,,,.T.,,,.T. )
	oDlg1 := MSDialog():New(0, 0, 900, 1700, cTitulo,,,.F.,,,,,,.T.,,,.T. )
	oPanelBkg:= tPanel():New(-65,oSize:GetDimension("DETAIL","COLINI"),"",oDlg1,,,,,,oSize:GetDimension("HEADER","XSIZE"),oSize:GetDimension("HEADER","YSIZE")+80)
	//oPanelBkg:= tPanel():New(0,0,"",oDlg1,,,,,,600,600)
    oPanelBkg:Align := CONTROL_ALIGN_ALLCLIENT
	oStepWiz:= FwWizardControl():New(oPanelBkg)//Instancia a classe FWWizard         
	//	oStepWiz:ActiveUISteps(.F.)

	// Tela 1 - Informações da Produção
	oNewPag := oStepWiz:AddStep("1")	
	oNewPag:SetConstruction({ |Panel|cria_pg1(Panel, @oGet1) })
	oNewPag:SetCancelAction({|| Eval(bCancel), .T.})
	oNewPag:SetNextAction({|| valida_pg1(@oGet1) })

	// Tela 2 - Quantidade
	oNewPag := oStepWiz:AddStep("2", {|Panel|cria_pg2(Panel)})
	oNewPag:SetCancelAction({ || Eval(bCancel), .T. })
	oNewPag:SetNextAction({ || valida_pg2() })
	oNewPag:SetPrevAction({|| zeraCont(), .T., .T.})
	oNewPag:SetPrevTitle("Voltar")

	// Tela 3 - Usuário/Operador
	oNewPag := oStepWiz:AddStep("3", {|Panel| cria_pg3(Panel, @oGet1)})
	oNewPag:SetCancelAction({|| Eval(bCancel), .F.})
	oNewPag:SetNextAction({|| runFinish()  })
	oNewPag:SetCancelWhen({||.F.})	

	oStepWiz:Activate()

	oDlg1:Activate(,,,.T.)

	oStepWiz:Destroy()

Return (lOpen)

// Construção da página 1
Static Function cria_pg1(oPanel, oGet1)

	Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9, oSay10, oSay11 := Nil 
	Local oGet2, oGet3, oGet4, oGet5 := Nil

	Local nLin			:= 10
	Local cDesPro		:= ""	
	Local cDesOper		:= ""
	Local cDesRecur		:= ""
	Local cDesCmba		:= ""
	Local cDesCarr		:= ""

	Local bSearchOP		:= { || cDesPro 	:= getOProduc(), cDesOper := getRoteiro() }
	//	Local bSearchRot	:= { || cDesOper 	:= getRoteiro() }
	Local bSearchRec	:= { || cDesRecur	:= getRecurso() }
	Local bSearchCmb	:= { || cDesCmba	:= getCacamba() }			
	Local bSearchCar	:= { || cDesCarr	:= getCarrinh() }

	oSay1 := TSay():New( nLin,nCol1,{||"OP"},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,nSayTamCom,nsayTamLar)
	oGet1 := TGet():New( nLin,nCol2,{|u| If(PCount()>0,cNumOP:=u,cNumOP)},oPanel,nGetTamCom+40,nGetTamLar,'@!',{ || Eval(bSearchOP) },CLR_BLACK,CLR_WHITE,oFontGet,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC2","",,)	

	oGet1:setFocus()

	nLin  += nSltLin

	oSay2 := TSay():New( nLin,nCol1,{||"Produto"},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,nSayTamCom,nsayTamLar)
	oSay3 := TSay():New( nLin,nCol2,{|u| If(PCount()>0,cDesPro:=u,cDesPro)},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,250,025)

	nLin  += nSltLin

	oSay4 := TSay():New( nLin,nCol1,{||"Operacao"},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,nSayTamCom,nsayTamLar)
	//oGet2 := TGet():New( nLin,nCol2,{|u| If(PCount()>0,cOperac:=u,cOperac)},oPanel,nGetTamCom,nGetTamLar,'@!',{ || Eval(bSearchRot) },CLR_BLACK,CLR_WHITE,oFontGet,,,.T.,"",,,.F.,.F.,,.F.,.F.,"BHSG21","",,)	
	oSay5 := TSay():New( nLin,nCol2,{|u| If(PCount()>0,cDesOper:=u,cDesOper)},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,350,025)

	nLin  += nSltLin

	oSay6 := TSay():New( nLin,nCol1,{||"Maquina"},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,nSayTamCom,nsayTamLar)
	oGet3 := TGet():New( nLin,nCol2,{|u| If(PCount()>0,cCodRecur:=u,cCodRecur)},oPanel,nGetTamCom,nGetTamLar,'@!',{ || Eval(bSearchRec) },CLR_BLACK,CLR_WHITE,oFontGet,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SH1","",,)
	oSay7 := TSay():New( nLin,nCol3,{|u| If(PCount()>0,cDesRecur:=u,cDesRecur)},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,250,025)

	nLin  += nSltLin

	oSay8 := TSay():New( nLin,nCol1,{||"Cacamba"},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,nSayTamCom,nsayTamLar)
	oGet4 := TGet():New( nLin,nCol2,{|u| If(PCount()>0,cCodCmba:=u,cCodCmba)},oPanel,nGetTamCom,nGetTamLar,'@!',{ || Eval(bSearchCmb) },CLR_BLACK,CLR_WHITE,oFontGet,,,.T.,"",,,.F.,.F.,,.F.,.F.,"Z06","",,)
	oSay9 := TSay():New( nLin,nCol3,{|u| If(PCount()>0,cDesCmba:=u,cDesCmba)},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,250,025)

	nLin  += nSltLin

	oSay10 := TSay():New( nLin,nCol1,{||"Carrinho"},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,nSayTamCom,nsayTamLar)
	oGet5 := TGet():New( nLin,nCol2,{|u| If(PCount()>0,cCodCarr:=u,cCodCarr)},oPanel,nGetTamCom,nGetTamLar,'@!',{ || Eval(bSearchCar) },CLR_BLACK,CLR_WHITE,oFontGet,,,.T.,"",,,.F.,.F.,,.F.,.F.,"Z06","",,)
	oSay11 := TSay():New( nLin,nCol3,{|u| If(PCount()>0,cDesCarr:=u,cDesCarr)},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,250,025)

Return

Static Function valida_pg1(oGet1)

	Local aArea		:= GetArea()
	Local aAreaSC2	:= SC2->(GetArea())
	Local aAreaSG2	:= SG2->(GetArea())
	Local aAreaSH1	:= SH1->(GetArea())
	Local aAreaZ06	:= Z06->(GetArea())

	Local cMsg		:= ""
	Local cGrupo	:= GetMv("MV_BHOSYS1")  // parametro que indica as maquinas com terminal Osys
	Local lRet 		:= .T. 

	// TIRAR - INSERIDO PARA TESTE			
	//Return (lRet)

	SC2->(dbSetOrder(1)) // C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
	if SC2->(dbSeek(FWxFilial("SC2")+cOrdProd))
		if !empty (SC2->C2_DATRF)
			cMsg := "Ordem de Producao ENCERRADA" + CRLF + CRLF
			lRet := .F. 
		endif
	else	
		cMsg := "Ordem de Producao Invalida" + CRLF + CRLF
		lRet := .F.
	endif

	SG2->(dbSetOrder(1)) // G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC
	if !SG2->(dbSeek(FWxFilial("SG2")+padr(_cCodPro,tamSx3("G2_PRODUTO")[1])+padr(_cCodRot,tamSx3("G2_CODIGO")[1])+padr(cOperac,tamSx3("G2_OPERAC")[1])))
		cMsg += "Operacao Invalida" + CRLF + CRLF
		lRet := .F.
	endif

	SH1->(dbSetOrder(1)) // H1_FILIAL+H1_CODIGO
	if SH1->(dbSeek(FWxFilial("SH1")+padr(cCodRecur,tamSx3("H1_CODIGO")[1])))
		if SH1->H1_LINHAPR $ cGrupo
			//cMsg += "Equipamento com terminal Osys. Apontamento não permitido" + CRLF + CRLF
			//lRet := .F.
			lOsys := .T.
		endif
	else
		cMsg += "Maquina Invalida" + CRLF + CRLF
		lRet := .F.	
	endif

	Z06->(dbSetOrder(1)) // Z06_FILIAL+Z06_CODIGO
	if !Z06->(dbSeek(FWxFilial("Z06")+padr(cCodCmba,tamSx3("Z06_CODIGO")[1])))
		cMsg += "Cacamba Invalida" + CRLF + CRLF
		lRet := .F.
	endif

	Z06->(dbSetOrder(1)) // Z06_FILIAL+Z06_CODIGO
	if !Z06->(dbSeek(FWxFilial("Z06")+padr(cCodCarr,tamSx3("Z06_CODIGO")[1])))
		cMsg += "Carrinho Invalido" + CRLF + CRLF
		lRet := .F.
	endif

	if fLastOP() .AND. U_IsBHACD(_cCodPro)			
		cMsg += "Apontamento da Ultima Operacao permitida somente no Coletor" + CRLF + CRLF
		lRet := .F. 		
	endif 

	if !lRet
		showMsg(cMsg)
		oGet1:setFocus()
	endif

	Z06->(RestArea(aAreaZ06))
	SH1->(RestArea(aAreaSH1))
	SG2->(RestArea(aAreaSG2))
	SC2->(RestArea(aAreaSC2))
	RestArea(aArea)

Return (lRet)

// Construção da página 2
Static Function cria_pg2(oPanel)

	Local oSay1, oSay2, oSay3, oSay4 := Nil 
	Local oGet1, oGet2, oGet3, oGet4, oGet5 := Nil
	Local oBtn1 	:= Nil					
	Local oBrowse	:= Nil	
	Local nLin		:= 15
	Local aView		:= {}
	Local cObsBalan	:= "" 	

	oBtn1 := TButton():New(10,80,"P E S A R",oPanel,{|| getBalanca() /*Processa({|lEnd| cObsBalan := "Aguarde Leitura da Balanca", getBalanca(@lEnd)}, "Aguardando leitura da balança ","",.T.)*/},170,35,,oFontBtn,,.T.,,"",,,,.F. )

	nLin  += nSltLin

	oSay1 := TSay():New( nLin,nCol1,{||"Peso Total"},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,nSayTamCom+30,nSayTamLar)	
	oGet1 := TGet():New( nLin,nCol2,{|u| If(PCount()>0,nPesoTot:=u,nPesoTot)},oPanel,nGetTamVlr,nGetTamLar,'@E 99,999,999.999999',,CLR_BLACK,CLR_WHITE,oFontGet,,,.T.,"",,{|| .F. },.F.,.F.,,.F.,.F.,,"",,)

	oGet1:setFocus()

	nLin  += nSltLin
	//oSay5 := TSay():New( nLin,nCol1,{|u| If(PCount()>0,cObsBalan:=u,cObsBalan)},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,500,025)
	oSay2 := TSay():New( nLin,nCol1,{||"Peso Unit."},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,nSayTamCom+30,nSayTamLar)
	oGet2 := TGet():New( nLin,nCol2,{|u| If(PCount()>0,nPesoUnit:=u,nPesoUnit)},oPanel,nGetTamVlr,nGetTamLar,'@E 99,999,999.999999',,CLR_BLACK,CLR_WHITE,oFontGet,,,.T.,"",,{|| .F. },.F.,.F.,,.F.,.F.,"","",,)

	nLin  += nSltLin
	//oSay99 := TSay():New( nLin,nCol1,{|u| If(PCount()>0,cObsBalan:=u,cObsBalan)},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_RED,CLR_YELLOW,500,025)  
	oSay3 := TSay():New( nLin,nCol1,{||"Amostragem"},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,nSayTamCom+30,nSayTamLar)
	oGet3 := TGet():New( nLin,nCol2,{|u| If(PCount()>0,nAmostra:=u,nAmostra)},oPanel,nGetTamVlr,nGetTamLar,'@E 99,999,999.999999',,CLR_BLACK,CLR_WHITE,oFontGet,,,.T.,"",,{|| .F. },.F.,.F.,,.F.,.F.,"","",,)

	nLin  += nSltLin
	//oSay98 := TSay():New( nLin,nCol1,{|u| If(PCount()>0,cObsBalan:=u,cObsBalan)},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_RED,CLR_YELLOW,500,025)
	oSay4 := TSay():New( nLin,nCol1,{||"Qtd Apontada"},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,nSayTamCom+30,nSayTamLar)
	oGet4 := TGet():New( nLin,nCol2,{|u| If(PCount()>0,nQtdApont:=u,nQtdApont)},oPanel,nGetTamVlr,nGetTamLar,'@E 99,999,999.999999',,CLR_BLACK,CLR_WHITE,oFontGet,,,.T.,"",,{|| .F. },.F.,.F.,,.F.,.F.,"","",,)	
	nLin  += nSltLin

	oSay5 := TSay():New( nLin,nCol1,{|u| If(PCount()>0,cObsBalan:=u,cObsBalan)},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,500,025)
	oSay99 := TSay():New( nLin,nCol2+140,{|u| ""},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_RED,CLR_YELLOW,500,025)  
	oSay98 := TSay():New( nLin,nCol2+280,{|u| ""},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_RED,CLR_YELLOW,500,025)

	aView := getAcumul()

	oBrowse := TCBrowse():New(15,350,300,230,,,, oPanel,,,,,{|| oBrowse:Refresh()},,,,,,, .F.,, .T.,, .F.,,, .F.)		
	oBrowse:SetArray(aView) 

	oBrowse:AddColumn(TCColumn():New("OPERACAO"		, {|| aView[oBrowse:nAt, 1]},,,, "LEFT", 040,  .F., .F.,,,, .F.,))
	oBrowse:AddColumn(TCColumn():New("DESCRICAO"	, {|| aView[oBrowse:nAt, 2]},,,, "LEFT", 100,  .F., .F.,,,, .F.,))
	oBrowse:AddColumn(TCColumn():New("QUANTIDADE"	, {|| aView[oBrowse:nAt, 3]},,,, "RIGHT", 100,  .F., .F.,,,, .F.,))

	oBrowse:Refresh() 


Return

// Validação do botão Próximo da página 2
Static Function valida_pg2()

	Local cMsg	:= ""
	Local lRet 	:= .T.

	if nQtdApont <= 0 
		cMsg += "Quantidade apontada zerado" + CRLF + CRLF
		lRet := .F.
	Elseif nPesoTot <= 0 
		cMsg += "Peso total zerado" + CRLF + CRLF
		lRet := .F.
	Elseif nPesoUnit <= 0 
		cMsg += "Peso unitário zerado" + CRLF + CRLF
		lRet := .F.
	Elseif nAmostra <= 0 
		cMsg += "Quantidade de amostra zerada" + CRLF + CRLF
		lRet := .F.	
	endif

	if !lRet
		showMsg(cMsg)	
	endif

Return (lRet)

// Construção da página 3
Static Function cria_pg3(oPanel, oGet1)

	Local oSay1, oSay2, oSay3 := Nil 
	Local oGet2 := Nil				
	Local oBtn1, oBtn2, oBtn3 := Nil

	Local nLin := 15		

	oSay1 := TSay():New( nLin,nCol1,{||"Usuario"},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,nSayTamCom,nSayTamLar)
	oGet1 := TGet():New( nLin,nCol2,{|u| If(PCount()>0,cIDUser:=u,cIDUser)},oPanel,nGetTamCom+50,nGetTamLar,,,CLR_BLACK,CLR_WHITE,oFontGet,,,.T.,"",,,.F.,.F.,,.F.,.F.,,"",,)

	oGet1:setFocus()
	oGet1:bLostFocus :={|| oGetUsr := oGet1}

	TButton():New(nLin, 		380, "1", oPanel, {||  RefreshGet("1")}, 050, 035,,oFontBtn,, .T.,, "",,,, .F.)	
	TButton():New(nLin, 		480, "2", oPanel, {||  RefreshGet("2")}, 050, 035,,oFontBtn,, .T.,, "",,,, .F.)	
	TButton():New(nLin, 		580, "3", oPanel, {||  RefreshGet("3")}, 050, 035,,oFontBtn,, .T.,, "",,,, .F.)	
	TButton():New(nLin + 040, 	380, "4", oPanel, {||  RefreshGet("4")}, 050, 035,,oFontBtn,, .T.,, "",,,, .F.)	
	TButton():New(nLin + 040,	480, "5", oPanel, {||  RefreshGet("5")}, 050, 035,,oFontBtn,, .T.,, "",,,, .F.)	
	TButton():New(nLin + 040, 	580, "6", oPanel, {||  RefreshGet("6")}, 050, 035,,oFontBtn,, .T.,, "",,,, .F.)
	TButton():New(nLin + 080, 	380, "7", oPanel, {||  RefreshGet("7")}, 050, 035,,oFontBtn,, .T.,, "",,,, .F.)	
	TButton():New(nLin + 080, 	480, "8", oPanel, {||  RefreshGet("8")}, 050, 035,,oFontBtn,, .T.,, "",,,, .F.)	
	TButton():New(nLin + 080, 	580, "9", oPanel, {||  RefreshGet("9")}, 050, 035,,oFontBtn,, .T.,, "",,,, .F.)
	TButton():New(nLin + 120, 	480, "0", oPanel, {||  RefreshGet("0")}, 050, 035,,oFontBtn,, .T.,, "",,,, .F.)
	TButton():New(nLin + 120, 	580, "C", oPanel, {||  RefreshGet("C")}, 050, 035,,oFontBtn,, .T.,, "",,,, .F.)

	nLin  += nSltLin		

	oSay2 := TSay():New( nLin,nCol1,{||"Senha"},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,nSayTamCom,nSayTamLar)
	oGet2 := TGet():New( nLin,nCol2,{|u| If(PCount()>0,cPassword:=u,cPassword)},oPanel,nGetTamCom+50,nGetTamLar,,,CLR_BLACK,CLR_WHITE,oFontGet,,,.T.,"",,,.F.,.F.,,.F.,.T.,,"",,)			

	oGet2:bLostFocus :={|| oGetUsr := oGet2}

	nLin  += nSltLin + 20

	oSay3 := TSay():New(nLin + 55, nCol1, {|u| If(PCount()>0,cObserv:=u,cObserv)},oPanel,,oFontSay,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,600,025)

	nLin  += nSltLin + nSltLin

	oBtn1 := TButton():New(nLin, 080, "CONCLUIR",	oPanel, {|| Eval(bFinish)},	120, 035,, oFontBtn,, .T.,, "",,,, .F.)	
	oBtn2 := TButton():New(nLin, 260, "REIMPRIMIR",	oPanel, {|| printEtiq()},	150, 035,, oFontBtn,, .T.,, "",,,, .F.)
	oBtn3 := TButton():New(nLin, 460, "SAIR",		oPanel, {|| Eval(bCancel)},	120, 035,, oFontBtn,, .T.,, "",,,, .F.)

Return

// Validação do botão Próximo da página 2
Static Function valida_pg3(oGet1)

	Local lRet 		:= .T.
	Local cMsg		:= ""		

	cCodUser := getCodUsr(cIDUser)

	if !usrExist(cCodUser)
		cMsg := "Usuario Invalido" + CRLF + CRLF		
		lRet := .F.  	
	else
		__cUserID := cCodUser 
	endif

	if !pswName(cPassword)
		cMsg += "Senha Invalida " + CRLF + CRLF
		lRet := .F.
	endif

	If !lRet
		cIDUser 	:= Space(TamSx3("H6_OPERADO")[1])
		cPassword	:= Space(20)

		showMsg(cMsg)

		oGet1:setFocus()

	EndIf

Return lRet

Static Function getCodUsr(cUser)

	Local cAlias 	:= ""
	Local cSavOrd 	:= ""
	Local cCodRet	:= ""
	Default cUser 	:= CUSERNAME

	cAlias	:= Alias()
	cSavOrd := IndexOrd()
	cCodRet := CriaVar("AN_USER")

	PswOrder(2)
	If PswSeek(cUser)
		cCodRet := PswRet(1)[1][1]
	EndIf

	If !Empty(cAlias)
		dbSelectArea(cAlias)
		dbSetOrder(cSavOrd)
	Endif

Return cCodRet

Static Function getOProduc(cDesPro)

	Local aArea		:= GetArea()
	Local aAreaSC2	:= SC2->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())

	Local cRet		:= ""
	Local nTamOP	:= tamSx3("C2_NUM")[1] + tamSx3("C2_ITEM")[1] + tamSx3("C2_SEQUEN")[1]

	cOrdProd 		:= subStr(cNumOP,1,nTamOP)
	cOperac			:= ""

	SC2->(dbSetOrder(1)) // C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
	if SC2->(dbSeek(FWxFilial("SC2")+cOrdProd))

		SB1->(dbSetOrder(1)) // B1_FILIAL+B1_COD
		if SB1->(dbSeek(FWxFilial("SB1")+SC2->C2_PRODUTO))
			_cCodPro := SC2->C2_PRODUTO
			cRet 	 := allTrim(SC2->C2_PRODUTO) + "-" + allTrim(SB1->B1_DESC)
		endif

		if empty(SC2->C2_ROTEIRO)
			_cCodRot := "01"
		else
			_cCodRot := SC2->C2_ROTEIRO
		endif

		// Operacao informada no código da etiqueta da OP.
		cOperac := allTrim(subStr(cNumOP,nTamOP+1,tamSx3("G2_OPERAC")[1]))	

	endif

	SB1->(RestArea(aAreaSB1))
	SC2->(RestArea(aAreaSC2))
	RestArea(aArea)

Return (cRet)

Static Function getRoteiro(cDesOper)

	Local aArea		:= GetArea()
	Local aAreaSG2	:= SG2->(GetArea())
	Local cRet		:= ""

	SG2->(dbSetOrder(1)) // G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC
	if SG2->(dbSeek(FWxFilial("SG2")+padr(_cCodPro,tamSx3("G2_PRODUTO")[1])+padr(_cCodRot,tamSx3("G2_CODIGO")[1])+padr(cOperac,tamSx3("G2_OPERAC")[1])))
		cRet := SG2->G2_OPERAC+"-"+SG2->G2_DESCRI
	endif

	SG2->(RestArea(aAreaSG2))
	RestArea(aArea)

Return (cRet)

Static Function getRecurso()

	Local aArea		:= GetArea()
	Local aAreaSH1	:= SH1->(GetArea())
	Local cRet		:= ""

	SH1->(dbSetOrder(1)) // H1_FILIAL+H1_CODIGO
	if SH1->(dbSeek(FWxFilial("SH1")+padr(cCodRecur,tamSx3("H1_CODIGO")[1])))
		cRet := SH1->H1_DESCRI
	endif

	SH1->(RestArea(aAreaSH1))
	RestArea(aArea)

Return (cRet)

Static Function getCacamba()

	Local aArea		:= GetArea()
	Local aAreaZ06	:= Z06->(GetArea())
	Local cRet		:= ""

	Z06->(dbSetOrder(1)) // Z06_FILIAL+Z06_CODIGO
	if Z06->(dbSeek(FWxFilial("Z06")+padr(cCodCmba,tamSx3("Z06_CODIGO")[1])))
		cRet	  := allTrim( transform(Z06->Z06_PESO, pesqPict("Z06", "Z06_PESO"))) + "   KG"		
		nPesoCmba := Z06->Z06_PESO					 	
	endif

	Z06->(RestArea(aAreaZ06))
	RestArea(aArea)

return (cRet)

Static Function getCarrinh()

	Local aArea		:= GetArea()
	Local aAreaZ06	:= Z06->(GetArea())
	Local cRet		:= ""

	Z06->(dbSetOrder(1)) // Z06_FILIAL+Z06_CODIGO
	if Z06->(dbSeek(FWxFilial("Z06")+padr(cCodCarr,tamSx3("Z06_CODIGO")[1])))
		cRet 		:= allTrim( transform(Z06->Z06_PESO, pesqPict("Z06", "Z06_PESO"))) + "   KG"
		nPesoCarr 	:= Z06->Z06_PESO		 	
	endif

	Z06->(RestArea(aAreaZ06))
	RestArea(aArea)

Return (cRet)

Static Function showMsg(cTextMsg)

	Local oDlg1 	:= nil
	Local oSize		:= nil
	Local oBtn1		:= nil

	Local oMGet1	:= ""
	Local cTitulo   := "Aviso" 
	Local oFont	:= TFont():New('Courier new',,30,.T.,.T.)

	oSize := FWDefSize():New(.T.)
	oSize:AddObject( "HEADER", 100, 100, .T., .T. )  
	oSize:lProp := .T.  	
	oSize:Process() 		

	//oDlg1 	:= MSDialog():New(oSize:aWindSize[1], oSize:aWindSize[2], oSize:aWindSize[3], oSize:aWindSize[4],cTitulo,,,.F.,,,,,,.T.,,,.T. )
	oDlg1 	:= MSDialog():New(0, 0, 900, 1700,cTitulo,,,.F.,,,,,,.T.,,,.T. )
	
	//oMGet1 	:= TMultiGet():New(05,05,{|u| If(PCount()>0,cTextMsg:=u,cTextMsg)},oDlg1,oSize:GetDimension("HEADER","XSIZE")-50,oSize:GetDimension("HEADER","YSIZE")-75,oFont,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
	oMGet1 	:= TMultiGet():New(05,05,{|u| If(PCount()>0,cTextMsg:=u,cTextMsg)},oDlg1,825,380,oFont,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
	
	//oBtn1   := TButton():New(oSize:GetDimension("HEADER","YSIZE")-20,oSize:GetDimension("HEADER","XSIZE")-105, "OK", oDlg1,{|| oDlg1:End()},100,30,,oFontBtn,,.T.,,"",,,,.F. )
	oBtn1   := TButton():New(400,725, "OK", oDlg1,{|| oDlg1:End()},100,30,,oFontBtn,,.T.,,"",,,,.F. )
	
	oBtn1:setFocus()

	oDlg1:Activate(,,,.T.)

Return Nil

Static Function getBalanca()

	Local cCfgCOM3	:= AllTrim(GetMV("BH_CFGBALM")) //"COM3:4800,E,7,2" 
	Local cCfgCOM4	:= AllTrim(GetMV("BH_CFGBALC")) //"COM4:4800,E,7,2"
	Local lLeitura  := .F.

	oSay5:SetText("Aguardando peso balança:")
	
	oSay99:SetText("M E S A")
	oSay99:SetColor(CLR_YELLOW)

	oSay98:SetText("C H A O")
	oSay98:SetColor(CLR_YELLOW)
	
	If U_LerBal(cCfgCOM3,, @nPesoUnit, @nAmostra, "Balanca de Mesa", 49) //Lê balança de mesa

//		nPesoTot 	:= 3000
//		nPesoUnit 	:= 1 
//		nAmostra 	:= 3

		If nPesoUnit > 0 .And. nAmostra > 0

			oSay5:SetText("Aguardando peso balança:")

			oSay99:SetColor(CLR_GREEN)
 
			If U_LerBal(cCfgCOM4, @nPesoTot,,, "Balanca de Chão", 34) //Lê balança de chão
				
				//nPesoTot 	:= 3000
				
				If nPesoTot > 0

					nQtdApont := Round(((nPesoTot - nPesoCmba - nPesoCarr)) / nPesoUnit, 0) + nAmostra

					oSay98:SetColor(CLR_GREEN)
					
					lLeitura := .T.
					
				Else

					nPesoTot 	:= 0
					nPesoUnit 	:= 0
					nAmostra	:= 0

					ShowMsg("Peso não encontrado. Favor realizar a pesagem novamente [Balança de Chão]")

				EndIf

			EndIf

		Else

			nPesoTot 	:= 0
			nPesoUnit 	:= 0
			nAmostra	:= 0

			ShowMsg("Peso não encontrado. Favor realizar a pesagem novamente [Balança de Mesa]")

		EndIf

	EndIf

	If !lLeitura	
	
		oSay5:SetText("")
		oSay98:SetText("")
		oSay99:SetText("")

	Endif		


Return Nil

//IncTime([<cTime>],<nIncHours>,<nIncMinuts>,<nIncSeconds> ) -> Somar 
//DecTime<cTime>],<nDecHours>,<nDecMinuts>,<nDecSeconds> ) -> Subtrair
Static Function runRotAut(cObserv)

	Local aMata681		:= {} 
	Local cHoraIni		:= time()
	Local cHoraFin		:= IncTime(cHoraIni, 0 , 1 , 0 )
	Local cError		:= "" 
	Local lRet			:= .T.

	Private lMsErroAuto := .F.
	Private	lMsHelpAuto := .F.

	if lIncApon
	
		cError := "Apontamento de produção já inserido"
	
		showMsg(cError)
	
		Return lRet
	
	endif
	
	If !lOsys
	
		SC2->(dbSetOrder(1)) // C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
		SC2->(dbSeek(FWxFilial("SC2")+cOrdProd))
	
		aMata681 := {	{"H6_FILIAL", 	FWxFilial("SH6"), 	Nil}, ;
						{"H6_OP", 		cOrdProd, 			Nil}, ;
						{"H6_PRODUTO", 	_cCodPro, 			Nil}, ;
						{"H6_OPERAC", 	cOperac, 			Nil}, ; 
						{"H6_RECURSO", 	cCodRecur, 			Nil}, ;
						{"H6_OPERADO", 	cCodUser, 			Nil}, ;
						{"H6_DTAPONT", 	dDataBase, 			Nil}, ;
						{"H6_PT", 		"P", 				Nil}, ;
						{"H6_DATAINI", 	dDataBase, 			Nil}, ;
						{"H6_HORAINI", 	cHoraIni, 			Nil}, ;
						{"H6_DATAFIN", 	dDataBase, 			Nil}, ;
						{"H6_HORAFIN", 	cHoraFin, 			Nil}, ;
						{"H6_LOCAL", 	SC2->C2_LOCAL, 		Nil}, ;
						{"H6_QTDPROD",	nQtdApont, 			Nil}}
	
		MSExecAuto({|x| MATA681(x)},aMata681)
		
	EndIf
	
	if lMsErroAuto
	
		cError := mostraErro("\sql\","AUTO_ERR" + Alltrim(cNumOP) + Substr(Time(),1,2) + Substr(Time(),4,2) + ".log")
	
		showMsg(cError)
	
		lRet  := .F.
	
	else				
	
		lIncApon := .T.
		
		If lOsys
			cObserv  := "**** Apontamento realizado pelo Osys! ****"
		Else
			cObserv  := "**** Inserido apontamento com sucesso! ****"
		EndIf
			
		printEtiq() // Imprime etiqueta
	
	endif

Return (lRet)

Static Function runFinish()
	Eval(bFinish)
return .F.

Static Function getAcumul()

	Local cQuery 		:= ""
	Local cAlias		:= GetNextAlias()
	Local aData			:= {}

	cQuery := "SELECT H6_OPERAC, G2_DESCRI, SUM(H6_QTDPROD) H6_QTDPROD "
	cQuery += "FROM " + retSqlName("SH6") + " H6 "

	cQuery += "INNER JOIN " + retSqlName("SG2") + " G2 ON "
	cQuery +=		"G2_FILIAL 			= '" + FWxFilial("SG2") + "' "
	cQuery +=		"AND G2_PRODUTO 	= H6_PRODUTO "
	cQuery +=		"AND G2_CODIGO  	= '" + _cCodRot + "' "
	cQuery +=		"AND G2_OPERAC  	= H6_OPERAC "
	cQuery +=		"AND G2.D_E_L_E_T_ 	= ' ' " 

	cQuery += "WHERE "
	cQuery +=		"H6_FILIAL 			= '" + FWxFilial("SH6") + "' "
	cQuery +=		"AND H6_OP 			= '" + cOrdProd + "' "
	cQuery +=		"AND H6.D_E_L_E_T_ 	= ' ' "
	cQuery += "GROUP BY H6_OPERAC, G2_DESCRI "
	cQuery += "ORDER BY H6_OPERAC "

	if select(cAlias) <> 0
		(cAlias)->(dbCloseArea())
	endif

	TcQuery cQuery Alias &cAlias New

	(cAlias)->(dbGoTop())
	
	while (cAlias)->(!eof())  

		aadd(aData, {(cAlias)->H6_OPERAC, (cAlias)->G2_DESCRI, transForm((cAlias)->H6_QTDPROD ,PesqPict("SH6","H6_QTDPROD"))})

		(cAlias)->(dbSkip())

	endDo

	(cAlias)->(dbCloseArea())

	if len(aData) == 0
		aadd(aData, {"", "", 0})
	endif

return (aData)

Static Function printEtiq()

	Local cError := ""

	if lIncApon
	
		// Imprime etiqueta
		U_BHRPCP01(@cError, cOrdProd, _cCodPro, _cCodRot, cOperac, cCodRecur, cCodUser, round(nPesoTot,6), round(nPesoUnit,6), nAmostra, nQtdApont, round(nPesoCmba,6), round(nPesoCarr,6), lOsys)

		if !empty(cError)
			showMsg(cError)
		endif
		
	endif
	
Return

Static Function RefreshGet(cNumber)

	If cNumber == "C"
		oGetUsr:cText("")
	Else
		oGetUsr:cText(AllTrim(oGetUsr:cText) + cNumber)
	EndIf

Return Nil

Static Function fLastOP()

	Local aArea		:= GetArea()	
	Local aAreaSG2	:= SG2->(GetArea())

	Local cOperAtu	:= cOperac
	Local cOperUlt 	:= ""	
	Local lRet 		:= .F.

	SG2->(dbSetOrder(1)) // G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC
	SG2->(dbSeek(FWxFilial("SG2")+padr(_cCodPro,tamSx3("G2_PRODUTO")[1])+padr(_cCodRot,tamSx3("G2_CODIGO")[1])+padr(cOperac,tamSx3("G2_OPERAC")[1])))

	while SG2->(!eof()) .AND. SG2->G2_FILIAL+SG2->G2_PRODUTO+SG2->G2_CODIGO == FWxFilial("SG2")+padr(_cCodPro,tamSx3("G2_PRODUTO")[1])+padr(_cCodRot,tamSx3("G2_CODIGO")[1])

		cOperUlt := SG2->G2_OPERAC

		SG2->(dbSkip())

	endDo

	if cOperAtu == cOperUlt
		lRet := .T.       
	endif

	SG2->(RestArea(aAreaSG2))	
	RestArea(aArea)

Return (lRet)


Static Function ZeraCont()

	nAmostra :=0
	nPesoTot :=0
	nPesoUnit := 0
	nQtdApont := 0 

	oSay5:SetText("")
	oSay98:SetText("")
	oSay99:SetText("")
		
Return Nil