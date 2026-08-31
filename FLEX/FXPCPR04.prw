#include 'protheus.ch'
#include 'totvs.ch''

User Function FXPCPR04()
	
	Local cxFunV := ".T."

	Local oDlgParam
	Local oSay1, oSay2, oSay3
	Local oGet1, oGet2, oGet3
	Local oButton1, oButton2

	Private cCod := Space(TamSx3("B1_COD")[1])
	Private cRev := Space(TamSx3("B1_REVATU")[1])
	Private cxFIlz := xfilial("SG1")
    //Private aPergs := {}
	
	//Buscar do item posicionado Eusébio em 06/06/23
	//IF FUNNAME() = 'PCPA200'
	IF FWISINCALLSTACK('PCPA200')
		cCod   := SG1->G1_COD 
		cRev   := POSICIONE("SB1",1,xfilial("SB1")+SG1->G1_COD,"B1_REVATU")
	ELSE
		cxFunV := "u_fpcpr4x()"
	ENDIF
	/*
	aAdd(aPergs, {1, "Filial",   cxFIlz,  "", ".T."  , "",    ".T.", 20, .T.})
	aAdd(aPergs, {1, "Produto",  cCod,    "", cxFunV , "SB1", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Revisão",  cRev,    "", ".T."  , "",    ".T.", 120, .T.})

	If ParamBox(aPergs, "Informe os parâmetros")
		// cCod    := MV_PAR01
		// cRev    := MV_PAR02
		// cFilAnt := MV_PAR03

		if !(Empty(Alltrim(cCod))) .AND. !(Empty(Alltrim(cRev)))
			cRev := MV_PAR03
		  	u_FXPCPR03(cCod, cRev)
		endif
	Endif
	*/
	//Nova tela de parâmetros - Miguel 14/11/2024
	DEFINE MSDIALOG oDlgParam TITLE "Exportar Estrutura" FROM 000, 000  TO 210, 330 COLORS 0, 16777215 PIXEL

		@ 006, 007 SAY oSay1 PROMPT "Filial" SIZE 052, 008 OF oDlgParam COLORS 0, 16777215 PIXEL
		@ 006, 070 MSGET oGet1 VAR cxFIlz SIZE 020, 010 OF oDlgParam COLORS 0, 16777215 /*READONLY*/ PIXEL 
		
		@ 021, 007 SAY oSay2 PROMPT "Produto" SIZE 052, 008 OF oDlgParam COLORS 0, 16777215 PIXEL
		@ 021, 070 MSGET oGet2 VAR cCod SIZE 090, 010 F3 "SB1" OF oDlgParam COLORS 0, 16777215 /*READONLY*/ PIXEL VALID fpcpr4x()
		
		@ 036, 007 SAY oSay3 PROMPT "Revisão" SIZE 052, 008 OF oDlgParam COLORS 0, 16777215 PIXEL
		@ 036, 070 MSGET oGet3 VAR cRev SIZE 030, 010 OF oDlgParam COLORS 0, 16777215 /*READONLY*/ PIXEL 
		
		@ 066, 10 BUTTON oButton1 PROMPT "CONFIRMAR" SIZE 054, 015 OF oDlgParam PIXEL ACTION (oDlgParam:End(),lCancel:= .F.)
		@ 066, 85 BUTTON oButton2 PROMPT "CANCELAR" SIZE 054, 015 OF oDlgParam PIXEL ACTION (oDlgParam:End(),lCancel:=.T.)

	ACTIVATE MSDIALOG oDlgParam //CENTERED

	If lCancel
		Return()
	Endif

	if !(Empty(Alltrim(cCod))) .AND. !(Empty(Alltrim(cRev)))
		fwMsgRun(,{||u_FXPCPR03(cCod, cRev,.t.,cxFIlz)},"Gerando relatório da estrutura...","Aguarde...")
	endif

Return

//alterado a filial
Static Function fpcpr4x()
	cFilAnt:= cxFIlz
	cRev := POSICIONE("SB1",1,xFilial("SB1")+cCod,"B1_REVATU")
Return .T.
