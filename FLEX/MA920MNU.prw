#INCLUDE "PROTHEUS.CH"


/*/{Protheus.doc} MA920MNU
Funcao para manutencao da data de entrega da Nfe
@type function
@author Anizio Cunha
@since 28/10/2019
@version 1.0
/*/

USER FUNCTION MA920MNU()

	Local aArea:= GetArea()

	Aadd(aRotina,{"Atualiz. Dt Entrega","U_AtuDtEnt", 0 , 2 , 0 , NIL}) //"novo"

	RestArea(aArea)
RETURN


User Function AtuDtEnt()

	Local cFil := SD2->D2_FILIAL
	Local cDoc:= SD2->D2_DOC
	Local cSer:= SD2->D2_SERIE
	Local oGroup,oSay1,Serie,oTFont,oSay2,oGroup1,oSay3,oDtEnt,oSay4,oObs
	Local cSerie,cDoc,dDtEnt:=Stod(""),cObs:=Space(40)
	Local nOldDtEnt//:= SF2->F2_XDTENTR

	Define Font oFnt3 Name "Ms Sans Serif" Bold
	oTFont := TFont():New('Courier new',,16,.T.)

	Dbselectarea("SF2")
	Dbsetorder(1)
	If SF2->(DBSEEK(cFil+cDoc+cSer))
		nOldDtEnt:= SF2->F2_XDTENTR
		cSerie:=SF2->F2_SERIE
		cDoc:=SF2->F2_DOC
		dDtEnt	:= nOldDtEnt//Dtoc(SF2->F2_XDTENTR)
		cObs 	:= SF2->F2_XOBSENT
		Define Msdialog oDlg Title "Manut. Entrega Nf-e" From 150,5 to 500,370 Pixel

		oGroup:= TGroup():New(010,02,060,180,'Dados da Nota Fiscal: ',oDlg,,,.T.)
		//serie
		@ 020,05 SAY oSay1 PROMPT "Serie: " SIZE 30,12 OF oGroup CENTER PIXEL Font oTFont
		@ 030,05 MSGET oSerie VAR cSerie SIZE 050,016 OF oGroup PIXEL Font oTFont WHEN .F.

		//numero da nfe
		@ 020,060 SAY oSay2 PROMPT "Documento: " SIZE 40,12 OF oGroup CENTER PIXEL Font oTFont
		@ 030,060 MSGET oDoc VAR cDoc SIZE 060,016 OF oGroup PIXEL Font oTFont WHEN .F.

		oGroup1:= TGroup():New(070,02,160,180,'Informações: ',oDlg,,,.T.)
		//Data Entrega
		@ 080,05 SAY oSay3 PROMPT "Data Entrega: " SIZE 60,12 OF oGroup1 CENTER PIXEL Font oTFont
		@ 090,05 MSGET oDtEnt VAR dDtEnt SIZE 050,015 OF oGroup1 PIXEL Font oTFont WHEN .T. PICTURE "@D"
		//dDtEnt	:= Dtoc(SF2->F2_XDTENTR)
		//Obs:
		@ 110,05 SAY oSay4 PROMPT "Observação: " SIZE 60,12 OF oGroup1 CENTER PIXEL Font oTFont
		@ 120,05 MSGET oObs VAR cObs SIZE 170,025 OF oGroup1 PIXEL Font oTFont WHEN .T. PICTURE "@!"


		DEFINE SBUTTON FROM 160,060 TYPE 1 ACTION ( UpDtDados(cSerie,cDoc,dDtEnt,cObs),oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 160,120 TYPE 2 ACTION ( oDlg:End()) ENABLE OF oDlg


		Activate Msdialog oDlg Centered

	Else

	EndIf

Return

Static Function UpDtDados(cSerie,cDoc,dDtEnt,cObs)

	If Empty(dDtEnt) .OR. Empty(cObs)
		MsgInfo("Preencher os campos Data e Observação.","Campo(s) Vazio(s)")
		Return
	EndIf

	Dbselectarea("SF2")
	Dbsetorder(1)
	If SF2->(DBSEEK(xFilial("SF2")+cDoc+cSerie))
		If MsgYesnO("Para a Nota: "+cSerie+"-"+cDoc+"  Deseja realmente atualizar?","Atualiza Entrega")
			RecLock("SF2",.F.)
			SF2->F2_XDTENTR:=cTod(Dtoc(dDtEnt))
			SF2->F2_XOBSENT:=ALLTRIM(cObs)
			MsUnlock()
			MsAguarde({|lFim| Processa(@lFim)},"Processamento","Aguarde a finalização do processamento...")

		Else
			MsgInfo("Cancelado pelo(a) Operador(a)!","Fim")
			oDlg:End()
		EndIf
	endif
Return

/*
	Processa : Função de callback de processamento assíncrono.

	Parâmetros:
		lFim - Flag de cancelamento passada por referência.

	A cada iteração, verifica se o usuário solicitou o fim do processamento.
	Se lFim for verdadeiro, exibe mensagem de cancelamento e interrompe o loop.
	Caso contrário, atualiza o texto de progresso com a linha atual.
*/
Static Function Processa(lFim)
	Local i

	For i := 1 to 1000
		If lFim
			MsgInfo("Cancelado!","Fim")
			Exit
		Endif

		MsProcTxt("Lendo "+Alltrim(str(i)))
	Next
Return
