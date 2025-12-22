#include "RWMAKE.CH"
/*_____________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+--------------------------+¦¦
¦¦¦ Função    ¦ MS520VL    ¦                              ¦ Data ¦ 01/10/2007               ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+--------------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para excluir o detalhamento da receita da NF de saida      ¦¦¦
¦¦+-----------+-----------------------------------------------------------------------------+¦¦
¦¦¦ Retorno   ¦ .T. ou .F.                                                                  ¦¦¦
¦¦+-----------+-----------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MS520VLD

Local cAlias:= Alias()
Local nRecno:= Recno()
Local nIndex:= IndexOrd()
Local cChave2 := ""
Local cForPd := SubStr(GetMv("MV_UNIAO"),1,6)   // Fornecedor dos titulos de impostos
Local cInss  := SubStr(GetMv("MV_FORINSS"),1,6) // Fornecedor dos titulos de impostos de INSS
Local cIss   := SubStr(GetMv("MV_MUNIC"),1,6)   // Fornecedor dos titulos de impostos de ISS

Local uChave,cBuscaPIS,cBuscaCOF
Local cBuscaIss := ""

uChave:= SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
cChave2:= SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC)
dbSelectArea("SZ6")
dbSetOrder(1)
If dbSeek(xFilial("SZ6")+"7"+uChave)
	RecLock("SZ6",.F.)
	dbDelete()
	MsUnLock()
Endif

cBuscaCOF := SF2->(F2_SERIE+F2_DOC+AllTrim(F2_XPARCOF))+"TX "+PadR(AllTrim(cForPd),6)+"00"
cBuscaIss := PadR(cIss,6) + "00" + SF2->(F2_SERIE+F2_DOC)

SE1->(DbSEtOrder(2))
If SE1->(DbSeek(xFilial("SE1")+cChave2))
	While xFilial("SE1")+cChave2 == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
		if SE1->E1_SALDO == SE1->E1_VALOR
			SE1->(RecLock("SE1",.F.))
			SE1->(DbDelete())
			SE1->(MsUnlock())
		else
			MsgBox("Não é Possível a Exclusão do Registro Enquanto este Estiver Baixado")
		EndIf
		SE1->(DbSkip())
	End
EndIf
//  .----------------------------.
// |     Contas a pagar - ISS     |
//  '----------------------------'
SE2->(DbSetOrder(6))
if SE2->(DbSeek(xFilial("SE2")+cBuscaIss))
	while xFilial("SE2") + cBuscaIss == SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
		If SE2->E2_SALDO == SE2->E2_VALOR .And. AllTrim(SE2->E2_ORIGEM) == "MATA460"
			SE2->(RecLock("SE2",.F.))
			SE2->(dbDelete())
			SE2->(MsUnLock())
		else
			MsgBox("Não é Possível a Exclusão do Registro Enquanto este Estiver Baixado")
		EndIf
		SE2->(DbSkip())
	End
EndIf


SE2->(DbSetOrder(1))
iF SE2->(dbSeek(XFILIAL("SE2")+cBuscaCOF))
	If SE2->E2_SALDO <> SE2->E2_VALOR .And. AllTrim(SE2->E2_ORIGEM) <> "MATA460"
		MsgBox("Não é Possível a Exclusão do Registro Enquanto este Estiver Baixado")
	else
		SE2->(RecLock("SE2",.F.))
		SE2->(dbDelete())
		SE2->(MsUnLock())
	Endif
EndIf

dbSelectArea(cAlias)
dbSetOrder(nIndex)
dbGoto(nRecno)
Return .T.
