#include "rwmake.ch"

User Function RCOMM01()

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

_cAuxNota:= ""          //----> Numero da nota auxiliar (anterior)
_cNumPed := ""          //----> Numero do pedido a ser gravado (GETSX8NUM())
_nItem   := 0           //----> Item do pedido a ser gravado

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Selecionando Registros Nota de Entrada")
Return

Static Function RunProc()

DbSelectArea("SD1")
DbSeek(xFilial("SD1"))
ProcRegua(LastRec())

Do While Eof() == .f. .And. Alltrim(SD1->D1_FILIAL) == Alltrim(xFilial("SD1"))
	
	IncProc("Processando Nota Nr. "+SD1->D1_DOC)
	
	If !Marked("D1_OK")
		DbSkip()
		Loop
	Else
		If Empty(SD1->D1_CLPVTRA)
			
			GravaSC5()
			
			_cAuxNota := SD1->D1_DOC
			
			DbSelectArea("SD1")
			RecLock("SD1",.f.)
			SD1->D1_CLPVTRA := _cNumPed
			SD1->D1_OK      := Space(02)
			MsUnLock()
		Else
			MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", o item "+SD1->D1_COD+" da nota fiscal "+SD1->D1_DOC+"/"+SD1->D1_SERIE+" ja tem pedido gerado com nr. "+SD1->D1_CLPVTRA+" portanto nao sera gerado.","Pedido Ja Existe","Alert")
		EndIf
	EndIf
	DbSelectArea("SD1")
	DbSkip()
EndDo

Return(nil)

Static Function GravaSC5()
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
	DBUSEAREA(.T.,"TOPCONN","SC6010","SC6010",.T.)
	DBUSEAREA(.T.,"TOPCONN","SC5010","SC5010",.T.)
    TcCanOpen("SC5010","SC50101")
	ORDLISTADD("SC50101")
	
If _cAuxNota #SD1->D1_DOC
	
	_cNumPed := GetSX8Num("P21") //----> buscando a numeracao do pedido
	ConfirmSX8()                 //----> a ser gravado
	
	MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", avise o pessoal do faturamento que o numero do pedido gerado para transferencia Sao Roque da nota "+SD1->D1_DOC+"/"+SD1->D1_SERIE+" ‚: "+_cNumPed,"Numero do Pedido de Venda","Alert")
	
	While .T.
        DbSelectArea("SC5010")
        DbSetOrder(1)
        DbSeek(xFilial("SC5010")+_cNumPed)
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
    
	DbSelectArea("SC5010")
	RecLock("SC5010",.t.)
	SC5010->C5_FILIAL  := "01"
	SC5010->C5_NUM     := _cNumPed
	SC5010->C5_TIPO    := "N"
	SC5010->C5_CLIENTE := "000649"
	SC5010->C5_LOJACLI := "02"
	SC5010->C5_TIPOCLI := "R"
	SC5010->C5_CONDPAG := "999"
	SC5010->C5_TABELA  := "1"
	SC5010->C5_VEND1   := "90001"
	SC5010->C5_EMISSAO := Date()
	SC5010->C5_TIPLIB  := "2"
	SC5010->C5_LOJAENT := "02"
	SC5010->C5_CLNOMCL := "COEL"
	SC5010->C5_CLPARC  := "N"
	SC5010->C5_CLANTE  := "N"
	SC5010->C5_CLATEND := "TRANSF.P/S.ROQUE"
	SC5010->C5_TRANSP  := "100002"
	MsUnlock()
	

	If SD1->D1_CLPT == "T" // Tipo de Material e "TRANSFERENCIA"
		_nItem:=1
		GravaSC6()
		If SB1->B1_IPI == 0
			SC6010->C6_TES     := "513" // Aliquota IPI reduzida a zero
			SC6010->C6_CF      := "5152"
			SC6010->C6_CLASFIS := Posicione("SF4",1,xFilial("SF4")+SC6010->C6_TES,"F4_SITTRIB")
		Else
			SC6010->C6_TES     := "512"
			SC6010->C6_CF      := "5152"
			SC6010->C6_CLASFIS := Posicione("SF4",1,xFilial("SF4")+SC6010->C6_TES,"F4_SITTRIB")
		EndIf
		MsUnLock()
	ElseIf SD1->D1_CLPT == "C" // Tipo de Material e "CONSUMO"
		_nItem:=1
		GravaSC6()
		SC6010->C6_TES     := "535"
		SC6010->C6_CF      := "5557"
		SC6010->C6_CLASFIS := Posicione("SF4",1,xFilial("SF4")+SC6010->C6_TES,"F4_SITTRIB")
		MsUnLock()
		MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", este pedido trata-se de Material de Consumo","TIPO DO MATERIAL","ALERT")
	ElseIf SD1->D1_CLPT == "A" // Tipo de Material e "ATIVO IMOBILIZADO"
		_nItem:=1
		GravaSC6()
		SC6010->C6_TES     := "532"
		SC6010->C6_CF      := "5552"
		SC6010->C6_CLASFIS := Posicione("SF4",1,xFilial("SF4")+SC6010->C6_TES,"F4_SITTRIB")
		MsUnLock()
		MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", este pedido trata-se de Ativo Imobilizado","TIPO DO MATERIAL","ALERT")
	Else
		MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", o item "+SD1->D1_COD+" da nota fiscal "+SD1->D1_DOC+"/"+SD1->D1_SERIE+" nao foi classificado (A,C ou T), portanto nao sera gerado pedido para este item","TIPO DO MATERIAL","ALERT")
		// DbSelectArea("SC5")
		// RecLock("SC5",.f.)
		//     DbDelete()
		// MsUnLock()
	EndIf
Else    
//	DBUSEAREA(.T.,"TOPCONN","SC5010","SC5010",.T.)
//	DBUSEAREA(.T.,"TOPCONN","SC6010","SC6010",.T.)
//    TcCanOpen("SC5010","SC50101")
//	ORDLISTADD("SC50101")
	If SD1->D1_CLPT == "T" // Tipo de Material e "TRANSFERENCIA"
		_nItem:=_nItem+1
		GravaSC6()
		If SB1->B1_IPI == 0
			SC6010->C6_TES     := "513" // Aliquota IPI reduzida a zero
			SC6010->C6_CF      := "5152"
			SC6010->C6_CLASFIS := Posicione("SF4",1,xFilial("SF4")+SC6010->C6_TES,"F4_SITTRIB")
		Else
			SC6010->C6_TES     := "512"
			SC6010->C6_CF      := "5152"
			SC6010->C6_CLASFIS := Posicione("SF4",1,xFilial("SF4")+SC6010->C6_TES,"F4_SITTRIB")
		EndIf
		MsUnLock()
	ElseIf SD1->D1_CLPT == "C" // Tipo de Material e "CONSUMO"
		_nItem:=_nItem+1
		GravaSC6()
		SC6010->C6_TES     := "535"
		SC6010->C6_CF      := "5557"
		SC6010->C6_CLASFIS := Posicione("SF4",1,xFilial("SF4")+SC6010->C6_TES,"F4_SITTRIB")
		MsUnLock()
	ElseIf SD1->D1_CLPT == "A" // Tipo de Material e "ATIVO IMOBILIZADO"
		_nItem:=_nItem+1
		GravaSC6()
		SC6010->C6_TES     := "532"
		SC6010->C6_CF      := "5552"
		SC6010->C6_CLASFIS := Posicione("SF4",1,xFilial("SF4")+SC6010->C6_TES,"F4_SITTRIB")
		MsUnLock()
	Else
		MsgBox("Atencao Sr.(a)"+SubStr(cUsuario,7,15)+", o item "+SD1->D1_COD+" da nota fiscal "+SD1->D1_DOC+"/"+SD1->D1_SERIE+" nao foi classificado (A,C ou T), portanto nao sera gerado pedido para este item","TIPO DO MATERIAL","ALERT")
	EndIf
EndIf

if SD1->D1_TES == "002"
	reclock("SC6010",.F.)
	SC6010->C6_TES:= "570"
	SC6010->C6_CF := "5152"
	SC6010->C6_CLASFIS := Posicione("SF4",1,xFilial("SF4")+SC6010->C6_TES,"F4_SITTRIB")
	msunlock()
elseif SD1->D1_TES == "058"
	reclock("SC6010",.F.)
	SC6010->C6_TES:= "562"
	SC6010->C6_CF := "5152"
	SC6010->C6_CLASFIS := Posicione("SF4",1,xFilial("SF4")+SC6010->C6_TES,"F4_SITTRIB")
	msunlock()
endif

dbSelectArea("SC5010")
DbCloseArea()

dbSelectArea("SC6010")
DbCloseArea()

Return(nil)   

Static Function GravaSC6()
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

       
DbSelectArea("SC6010")
RecLock("SC6010",.t.)

SC6010->C6_FILIAL  := "01"
SC6010->C6_ITEM    := StrZero(_nItem,2)
SC6010->C6_PRODUTO := SD1->D1_COD
SC6010->C6_QTDVEN  := SD1->D1_QUANT

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD1->D1_COD)

If SB1->B1_TIPO == "MP" .OR. SB1->B1_TIPO == "MC" .OR. SB1->B1_TIPO == "AT"
	SC6010->C6_PRCVEN  := SD1->D1_VUNIT
	SC6010->C6_VALOR   := Round(SD1->D1_QUANT * SD1->D1_VUNIT,2)
Else
	SC6010->C6_PRCVEN  := Round(SB1->B1_PRV1*0.30,2)
	SC6010->C6_VALOR   := Round((SD1->D1_QUANT * (SB1->B1_PRV1*0.30)),2)
EndIf

SC6010->C6_PRUNIT  := SB1->B1_PRV1
SC6010->C6_DESCRI  := SB1->B1_DESC
SC6010->C6_NUM     := _cNumPed
SC6010->C6_UM      := SB1->B1_UM
SC6010->C6_MOEDA   := 1
SC6010->C6_SEGUM   := SB1->B1_SEGUM
SC6010->C6_LOCAL   := SB1->B1_LOCPAD
SC6010->C6_CLI     := "000649"
SC6010->C6_ENTREG  := Date()
SC6010->C6_LOJA    := "02"

Return(nil)


