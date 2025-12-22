#include "Protheus.ch"
#include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FA080TIT   ¦ Autor ¦ Adson Carlos         ¦ Data ¦ 25/05/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada antes da confirmação da Baixa                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FA080TIT()

	Local lRet      := .F.
	Local cArea     := GetArea()
	Local cConta    := space(20)
	Local nOpc      := 0
	Private _Superv := ""
	
	IF (ALLTRIM(cMotBx) <> "NORMAL" .And. ALLTRIM(cMotBx) <> "DEBITO CC" .And. ALLTRIM(cMotBx) <> "DEVOLUCAO" .And. ALLTRIM(cMotBx) <> "VENDOR" .And. ALLTRIM(cMotBx) <> "ADT FUNC" .And. ALLTRIM(cMotBx) <> "F CAPITAL")
		lRet      := VldFolder()
		
		If lRet
			
			@ 96,100 To 200,320 Dialog oMen Title "Informar Conta Credito"
			@ 010,010 Say "Conta Contabil: "
			@ 010,056 Get cConta  Picture "@!" when .T. Size 40,10 F3 "CT1"
			
			@ 030,010 BmpButton Type 1 Action IIF(fwGravar(cConta),(nOpc:=1,oMen:End()),nOpc:=0)
			@ 030,075 BmpButton Type 2 Action (oMen:End())
			
			Activate Dialog oMen Centered
			
			lRet := (nOpc == 1)
			RestArea(cArea)
			
		EndIf
		
	ELSE
		
		lRet := .T.
		
	ENDIF
	
Return lRet


Static Function fwGravar(cConta)

	DbSelectArea("SE2")
	Reclock("SE2",.F.)
	SE2->E2_XCONTBX  := cConta
	SE2->E2_XUSRBX   := _Superv
	MsUnlock()
	
Return .T.

/* Valida a entrada que sao informacoes confidenciais */
Static Function VldFolder()

	Local oPsw, nOpc := 0, cPswFol := Space(25), lRet := .T.
	
	DEFINE MSDIALOG oPsw TITLE "Senha" From 8,70 To 13,90 OF oMainWnd
	
	@ 05,005 SAY "Senha" PIXEL OF oPsw
	@ 05,035 GET cPswFol PASSWORD SIZE 30,10 PIXEL OF oPsw
	@ 20,010 BUTTON oBut1 PROMPT "&Ok" SIZE 30,12 OF oPsw PIXEL;
	Action IIF(VldSenha(cPswFol),(nOpc:=1,oPsw:End()),nOpc:=0)
	@ 20,051 BUTTON oBut2 PROMPT "&Cancela" SIZE 30,12 OF oPsw PIXEL;
	Action (nOpc:=0,oPsw:End())
	
	ACTIVATE MSDIALOG oPsw
	
	lRet := (nOpc == 1)
	
Return(lRet)

Static Function VldSenha(cPsw)

	Local cCodUsr := ""
	Local _Loop   := Alltrim(StrTran(GetMv("MV_USUFINA"),","))
	Local _Limit  := Len(_Loop)/6
	Local _Errou  := .F.
	Local _Achou  := .F.
	Local lRet    := .T.
	
	PswOrder(1)
	For _Inc := 1 to _Limit
		cCodUsr := SubStr(_Loop,1,6)
		PswSeek(cCodUsr)
		If lRet := PswName(cPsw)
			_aUser  := PswRet()
			_Achou  := .T.
			_Superv := _aUser[1,4]
		Else
			_Errou  := .T.
		Endif
		_Loop := SubStr(_Loop,7,Len(_Loop)-6)
	Next _Inc
	
	If _Errou .And. !_Achou
		Alert("Senha Inválida, verifique a senha digitada !")
		lRet := .F.
	EndIf
	
Return(_Achou)
