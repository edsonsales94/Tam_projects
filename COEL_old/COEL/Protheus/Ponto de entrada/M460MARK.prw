#INCLUDE "rwmake.ch"
#include "topconn.ch"

/***********************/
User Function M460MARK()
//alert(funname())  
 
Local aParam := PARAMIXB
Local aMarca := aParam[1]
Local aInverte := aParam[2]

Local _cTipo	:= ""
Local _aAreaSC6 := sc6->(GetArea())
Local aFiltro := Eval(bFiltraBrw,1)
Local cFilSC9 := aFiltro[1]
Local cQrySC9 := aFiltro[2]
Local cFilBrw := aFiltro[3]
Local cQryBrw := aFiltro[4]
Local cCond := cFilSC9
Local lRet	:= .F.

_Alias := Alias()
_Index := IndexOrd()
_Regis := Recno()
_Filial := xFilial()

Dbselectarea("SC9")
AliaSC9 := Alias()
IndeSC9 := IndexOrd()
RecnSC9 := Recno()
nRegFilt := RecNo()

Dbselectarea("SC9")
cIndice := "C9_AGREG+"+IndexKey()
cArq	:= CriaTrab(NIL,.F.)
If aInverte
cCond += " .And. C9_OK <> '"+aMarca+"' "
Else
cCond += " .And. C9_OK = '"+aMarca+"' "
EndIf
cCond += " .And. C9_NFISCAL == '"+Space(Len(C9_NFISCAL))+"'"
cCond += " .And. C9_BLEST == '"+Space(Len(C9_BLEST))+"' .And. C9_BLCRED == '"+Space(Len(C9_BLCRED))+"'"

IndRegua("SC9",cArq,cIndice,,cCond,OemToAnsi("Selecionando Registros…"))

nIndex := RetIndex("SC9")
#IFNDEF TOP
dbSetIndex(cArq+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
nIndFilt := nIndex + 1

//===========================================================================

//If cEmpAnt == “01” .And. cFilAnt $ SuperGetMV(“SP_FILCOL”, Nil, “02/11”)
DbSelectarea("SC9")
SC9->(DbGotop())
While !SC9->(EOF())

dbSelectArea("SA1")
dbSetOrder(1) // FILIAL + CODIGO + LOJA
SA1->(dbSeek(xFilial("SA1") + SC9->C9_CLIENTE + SC9->C9_LOJA))

dbSelectArea("SB1")
dbSetOrder(1) // FILIAL + CODIGO + LOJA
SA1->(dbSeek(xFilial("SB1") + SC9->C9_PRODUTO ))

DbSelectarea("SC6")
DbSetorder(1) //FILIAL + NUM + ITEM + PRODUTO
DbSeek(SC9->C9_FILIAL + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO)

DbSelectarea("SC5")
DbSetorder(1) //FILIAL + NUM + ITEM + PRODUTO
DbSeek(SC9->C9_FILIAL + SC9->C9_PEDIDO )

lRet := U_M410PVNF()

IF !lRet
Exit
Endif

SC9->( DbSkip() )
EndDo

//————————————————————————————————————————————

nIndex := RetIndex("SC9")
Set Filter To
RestArea(_aAreaSC6)

Dbselectarea(AliaSC9)
Dbsetorder(IndeSC9)

Dbselectarea(_AliaS)
Dbsetorder(_Index)

Return(lRet) 
/*
Local _cMarca := ParamIxb[1]
Local _lInvert := ParamIxb[2]
Local _lRet    := .T.
Local _cPedido := Space(6)
Local _aArea   := GetArea()
Local _cAreaSC5:= SC5->(GetArea())
Local _cAreaSC6:= SC6->(GetArea())
Local _cAreaSC9:= SC9->(GetArea())
Local _cAreaSA1:= SA1->(GetArea())
Local _cTransp := ""
Local _lMarcado:= .f.

_cCliente := SC9->(C9_CLIENTE+C9_LOJA)

DBSELECTAREA("SA1")
SA1->( Dbsetorder(1) )   

If SA1->( Dbseek(xFilial("SA1") + _cCliente) )
	If SA1->A1_MSBLQL == '1'
		Alert("Cadastro do cliente bloqueado, favor entrar em contato com o Depto. Financeiro **A1_MSBLQL")
		_lRet:= .F.
    Else
    	_lRet:= .T.
    
	ENDIF
Endif              

SC5->(RestArea(_cAreaSC5))
SC6->(RestArea(_cAreaSC6))
SC9->(RestArea(_cAreaSC9)) 
SA1->(RestArea(_cAreaSA1))
RestArea(_aArea)

Return(_lRet)
*/
