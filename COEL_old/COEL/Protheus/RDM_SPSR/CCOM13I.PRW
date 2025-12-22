#include "rwmake.ch"

User Function Ccom13i()
                                                                                                                       
Local _aVetor     := {}
Local lMsErroAuto := .F.
Local nReg        := 0
Local _cQuery      := ""

SetPrvt("_CAUXNOTA,_CNUMPED,_NITEM,_CULTNUM,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CCOM13I  ³ Autor ³Ricardo Correa de Souza³ Data ³10.08.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao de Pedidos de Transferencia para Sao Roque         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

_cAuxNota := ""          //----> Numero da nota auxiliar (anterior)
_cNumPed  := ""          //----> Numero do pedido a ser gravado (GETSX8NUM())
_nItem    := 0           //----> Item do pedido a ser gravado
cString   := "TSD1"
lContinua := .t.

Processa({||RunProc()},"Selecionando Registros Nota de Entrada")
Return

Static Function RunProc()

//dbSelectArea("SD1")

//_cQuery := ""
_cQuery := " SELECT * "
_cQuery := _cQuery + "FROM SD1"+ SM0->M0_CODIGO + "0 "
_cQuery := _cQuery + " WHERE "
_cQuery := _cQuery + " D1_FILIAL   =  '"+xFilial("SD1")     +"' AND "
_cQuery := _cQuery + " D1_DTDIGIT = '"+Dtos(ddatabase)+"' AND "
_cQuery := _cQuery + " D_E_L_E_T_  <> '*' "
_cQuery := _cQuery + " ORDER BY D1_DOC "
_cQuery := ChangeQuery(_cQuery)
//TCQuery _cQuery NEW ALIAS "TSD1"

dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"TSD1", .F., .T.)

//ProcRegua(LastRec())

dbSelectArea( "TSD1" )
dbGoBottom()
nReg := Recno()
dbGoTop()

ProcRegua( nReg ) // Numero de registros a processar


//DbSelectArea("SD1")
//DbSetFilter([||!Empty(D1_OK) .And. IncProc("Filtrando Registros Marcados")],"!Empty(D1_OK)")

//DbSeek(xFilial("SD1"))
//ProcRegua(LastRec())

Do While !Eof() //== .f. .And. Alltrim(SD1->D1_FILIAL) == Alltrim(xFilial("SD1"))
	
	IncProc("Processando Nota Nr. "+TSD1->D1_DOC)
	
	If !Marked("D1_OK")
		DbSkip()
		Loop
	Else
		If Empty(TSD1->D1_CLPVTRA)
			
			GravaSC5()
			
			_cAuxNota := TSD1->D1_DOC

			DbSelectArea("SD1")
			RecLock("SD1",.f.)
			SD1->D1_CLPVTRA := _cNumPed
			SD1->D1_OK      := Space(02)
			MsUnLock()

		Else
			MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", o item "+TSD1->D1_COD+" da nota fiscal "+TSD1->D1_DOC+"/"+TSD1->D1_SERIE+" ja tem pedido gerado com nr. "+TSD1->D1_CLPVTRA+" portanto nao sera gerado.","Pedido Ja Existe","Alert")
		EndIf
	EndIf
	DbSelectArea("TSD1")
	DbSkip()
EndDo

DbSelectArea("TSD1")
DbCloseArea("TSD1")
//__RetProc()

Return(nil)


Static Function GravaSC5()

If _cAuxNota #TSD1->D1_DOC
	
	_cNumPed:= GetSX8Num("SC5")
	
	ConfirmSX8() // Busca a numeracao do pedido de venda no SX8
	MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", avise o pessoal do faturamento que o numero do pedido gerado para transferencia Sao Roque da nota "+TSD1->D1_DOC+"/"+TSD1->D1_SERIE+" ‚: "+_cNumPed,"Numero do Pedido de Venda","Alert")
	
	While .T.
		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek(xFilial("SC5")+_cNumPed)
		If found()
			_cUltNum := Val(SubStr(_cNumPed,1,6))
			_cUltNum := _cUltNum + 1
			_cUltNum := StrZero(_cUltNum,6)
			
			_cNumPed := _cUltNum
			
			MsgStop("Seu Pedido passou para "+_cNumPed+". Avise o administrador do sistema sobre essa modificacao.")
			
			Loop
		Else
			Exit
		EndIf
	EndDo
	
	DbSelectArea("SC5")
	RecLock("SC5",.T.)
	SC5->C5_FILIAL  := xFilial("SC5")
	SC5->C5_NUM     := _cNumPed
	SC5->C5_TIPO    := "N"
	SC5->C5_CLIENTE := "000649"
	SC5->C5_LOJACLI := "02"
	SC5->C5_TIPOCLI := "R"
	SC5->C5_CONDPAG := "999"
	SC5->C5_TABELA  := "1"
	SC5->C5_VEND1   := "90001"
	SC5->C5_EMISSAO := Date()
	SC5->C5_TIPLIB  := "2"
	SC5->C5_LOJAENT := "02"
	SC5->C5_CLNOMCL := "COEL"
	SC5->C5_CLPARC  := "N"
	SC5->C5_CLANTE  := "N"
	SC5->C5_CLATEND := "TRANSF.P/S.ROQUE"
	SC5->C5_TRANSP  := "100002"
	MsUnlock()
	
	If TSD1->D1_CLPT == "T" // Tipo de Material e "TRANSFERENCIA"
		_nItem:=1
		GravaSC6()
		If SB1->B1_IPI == 0
			SC6->C6_TES     := "513" // Aliquota IPI reduzida a zero
			SC6->C6_CF      := "5152"
			SC6->C6_CLASFIS := ALLTRIM(SB1->B1_ORIGEM)+"00"
		Else
			SC6->C6_TES     := "512"
			SC6->C6_CF      := "5152"
			SC6->C6_CLASFIS := ALLTRIM(SB1->B1_ORIGEM)+"00"
		EndIf
		MsUnLock()
	ElseIf TSD1->D1_CLPT == "C" // Tipo de Material e "CONSUMO"
		_nItem:=1
		GravaSC6()
		SC6->C6_TES     := "569"
		SC6->C6_CF      := "5557"
		SC6->C6_CLASFIS := ALLTRIM(SB1->B1_ORIGEM)+"41"
		MsUnLock()
		MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", este pedido trata-se de Material de Consumo","TIPO DO MATERIAL","ALERT")
	ElseIf TSD1->D1_CLPT == "A" // Tipo de Material e "ATIVO IMOBILIZADO"
		_nItem:=1
		GravaSC6()
		SC6->C6_TES     := "532"
		SC6->C6_CF      := "5552"
		SC6->C6_CLASFIS := ALLTRIM(SB1->B1_ORIGEM)+"40"
		MsUnLock()
		MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", este pedido trata-se de Ativo Imobilizado","TIPO DO MATERIAL","ALERT")
	Else
		MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", o item "+TSD1->D1_COD+" da nota fiscal "+TSD1->D1_DOC+"/"+TSD1->D1_SERIE+" nao foi classificado (A,C ou T), portanto nao sera gerado pedido para este item","TIPO DO MATERIAL","ALERT")
		DbSelectArea("SC5")
		RecLock("SC5",.f.)
		DbDelete()
		MsUnLock()
		lContinua := .f.
	EndIf
Else
	If TSD1->D1_CLPT == "T" // Tipo de Material e "TRANSFERENCIA"
		_nItem:=_nItem+1
		GravaSC6()
		If SB1->B1_IPI == 0
			SC6->C6_TES     := "513" // Aliquota IPI reduzida a zero
			SC6->C6_CF      := "5152"
			SC6->C6_CLASFIS := ALLTRIM(SB1->B1_ORIGEM)+"00"
		Else
			SC6->C6_TES     := "512"
			SC6->C6_CF      := "5152"
			SC6->C6_CLASFIS := ALLTRIM(SB1->B1_ORIGEM)+"00"
		EndIf
		MsUnLock()
	ElseIf TSD1->D1_CLPT == "C" // Tipo de Material e "CONSUMO"
		_nItem:=_nItem+1
		GravaSC6()
		SC6->C6_TES     := "569"
		SC6->C6_CF      := "5557"
		SC6->C6_CLASFIS := ALLTRIM(SB1->B1_ORIGEM)+"41"
		MsUnLock()
	ElseIf TSD1->D1_CLPT == "A" // Tipo de Material e "ATIVO IMOBILIZADO"
		_nItem:=_nItem+1
		GravaSC6()
		SC6->C6_TES     := "532"
		SC6->C6_CF      := "5552"
		SC6->C6_CLASFIS := ALLTRIM(SB1->B1_ORIGEM)+"40"
		MsUnLock()
	Else
		MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", o item "+TSD1->D1_COD+" da nota fiscal "+TSD1->D1_DOC+"/"+TSD1->D1_SERIE+" nao foi classificado (A,C ou T), portanto nao sera gerado pedido para este item","TIPO DO MATERIAL","ALERT")
		DbSelectArea("SC5")
		RecLock("SC5",.f.)
		DbDelete()
		MsUnLock()
		lContinua := .f.
	EndIf
EndIf

If lContinua
	if TSD1->D1_TES == "002"
		reclock("SC6",.F.)
		SC6->C6_TES:= "570"
		SC6->C6_CF := "5152"
		SC6->C6_CLASFIS := ALLTRIM(SB1->B1_ORIGEM)+"00"
		msunlock()
	elseif TSD1->D1_TES == "058"
		reclock("SC6",.F.)
		SC6->C6_TES:= "562"
		SC6->C6_CF := "5152"
		SC6->C6_CLASFIS := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"SUBS(SB1->B1_ORIGEM,1,1) + SF4->F4_SITTRIB")
		msunlock()
	endif
EndIf


Return(nil)

Static Function GravaSC6()

DbSelectArea("SC6")
RecLock("SC6",.T.)
SC6->C6_FILIAL  := xFilial("SC6")
SC6->C6_ITEM    := StrZero(_nItem,2)
SC6->C6_PRODUTO := TSD1->D1_COD
SC6->C6_QTDVEN  := TSD1->D1_QUANT

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+TSD1->D1_COD)

If SB1->B1_TIPO == "MP" .OR. SB1->B1_TIPO == "MC" .OR. SB1->B1_TIPO == "AT"
	SC6->C6_PRCVEN  := TSD1->D1_VUNIT
	SC6->C6_VALOR   := Round(TSD1->D1_QUANT * TSD1->D1_VUNIT,2)
Else
	SC6->C6_PRCVEN  := Round(SB1->B1_PRV1*0.30,2)
	SC6->C6_VALOR   := Round((TSD1->D1_QUANT * (SB1->B1_PRV1*0.30)),2)
EndIf

SC6->C6_PRUNIT  := SB1->B1_PRV1
SC6->C6_DESCRI  := SB1->B1_DESC
SC6->C6_NUM     := SC5->C5_NUM
SC6->C6_UM      := SB1->B1_UM
SC6->C6_MOEDA   := 1
SC6->C6_SEGUM   := SB1->B1_SEGUM
SC6->C6_LOCAL   := SB1->B1_LOCPAD
SC6->C6_CLI     := SC5->C5_CLIENTE
SC6->C6_ENTREG  := Date()
SC6->C6_LOJA    := SC5->C5_LOJACLI

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna ao ponto de sua chamada - GRAVASC5                                *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Return(nil)

