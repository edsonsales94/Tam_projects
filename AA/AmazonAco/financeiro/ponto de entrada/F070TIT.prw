#include "Protheus.ch"
#include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FA070TIT   ¦ Autor ¦ Adson Carlos         ¦ Data ¦ 23/05/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada antes da confirmcao da Baixa                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FA070TIT()

	Local lRet      := .F.
	Local cArea     := GetArea()
	Local cConta    := space(20)
	Local nOpc      := 0
	Private _Superv := ""
	
	IF (ALLTRIM(cMotBx) <> "NORMAL" .AND. ALLTRIM(cMotBx) <> "DEVOLUCAO")
		lRet      := VldFolder()
		
		If lRet
			
			@ 96,100 To 200,320 Dialog oMen Title "Informar Conta Debito"
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

	DbSelectArea("SE1")   
	Reclock("SE1",.F.)
	SE1->E1_XCONTBX := cConta
	SE1->E1_XUSRBX  := _Superv
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

Static Function VldSenha(cSenha)

	Local cCodUsr := ""
	Local aUsr 	:= StrToKArr(GetMv("MV_USUFINA"),',')
	Local _Errou  := .F.
	Local _Achou  := .F.
	Local lRet    := .T.  
	
	
	
	For nX:=1 To Len(aUsr)
  
		cCodUsr := aUsr[nX]
		PswOrder(1)
		PswSeek(cCodUsr)
		If lRet := PswName(Alltrim(cSenha))
			_aUser  := PswRet()
			_Achou  := .T.
			_Superv := _aUser[1,2]
		Else
			_Errou  := .T.
		Endif	
	Next nX
	
	
	If _Errou .And. !_Achou
		Alert("Senha Inválida, verifique a senha digitada !")
		lRet := .F.
	EndIf
	
Return(_Achou)
