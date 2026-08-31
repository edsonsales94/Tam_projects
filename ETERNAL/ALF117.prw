#include "rwmake.ch"

user Function ALF117()
/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³ ALF117 ³ Autor ³ Marcelo Tambosi       ³ Data ³ 31.08.05 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Executa Leitura de Pesos de Entrada Balança Toledo         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Expedição - Faturamento - Unidades c/balanca                 ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
	Local nHandle := 0
	Local cRetDll := 0
	Local nHdl1   := 0
	Local cText   := space(15)
	Local bAcao := {|lFim| LeE_peso(@lFim) }
	Local cTitulo := 'Lendo Pesagem da Balanca'
	Local cMsg := 'Peso ... '
	Local lAborta := .T.
	Private nHdll := 0
	MSOpenPort(nHdll,"COM4:9600,n,8,1")
	cPeso   := space(30)
	nPeso   := 0
	xx := MsRead(nHdll,@cText)
	if !xx
		msgbox("Nao foi possivel pegar informações da porta",,"STOP")
	Else
		nVezes := 0
		nEstab := 0
		cPeso  := "00000"
		Processa( bAcao, cTitulo,cMsg, lAborta )

	Endif

	ncont := 1
	nPeso := val(cPeso)/1000
	cPeso := transform(val(cPeso)/1000,"@E 999,999,999.99999")
	c999_Peso  := cPeso
	n999_peso  := nPeso

Return (npeso)

Static Function LeE_peso(lFim)
	Local lEnd := .f.
	Local nX := 0
	Private cText := "00000"

	nVezes := 0

	ProcRegua(10000)
	While !lEnd

		If lFim
			Exit
		EndIf

		MsRead(nHdll,@cText)
		nVezes ++

		if (val(substr(cText,at("p`",cText)+2,6)) >= 0 .and.  ;
				at("p`",cText) != 0)
			cTemp := substr(cText,at("p`",cText)+2,6)
			nLok := .t.
			For nX := 1 to 5
				//if RetAsc(substr(cTemp,nX,1),1,.T.) < "0" .or. RetAsc(substr(cTemp,nX,1),1,.T.) > "9"
				if substr(cTemp,nX,1) < "0" .or. substr(cTemp,nX,1)> "9"
					nLok := .f.
				Endif
			Next nX
			if nLOK
				cPeso := substr(cText,at("p`",cText)+2,6)
				//IncProc(cPeso)
				IncProc("Peso Liquido na Balança: " + transform(val(cPeso)/1000,"@E 999,999,999.99999"))
			Endif
		Else

		Endif

	Enddo

Return
