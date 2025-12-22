#include "Protheus.ch"
#include "TbiConn.ch"

User Function M410RLIB()
Local _adSaldo := ParamIxb
Local _adArea  := GetArea()

If !EMpty(SC5->C5_ORCRES)
	SC9->(dbSetORder(1))
	SC9->(dbSeek(xFilial("SC9") + SC5->C5_NUM))
	While !SC9->(EOF()) .And. SC9->C9_FILIAL + SC9->C9_PEDIDO == SC5->C5_FILIAL + SC5->C5_NUM
		SC9->(RecLock("SC9",.F.))
		SC9->C9_BLCRED := ""
		SC9->(MsUnlock())
		SC9->(dbSkip())
	EndDo
EndIf

Return _adSaldo

User Function AAJOBE01()
Local cQry   := ""
Local aBloqueio := {}
Local cTable := GetNextAlias()
If Type("cAcesso") = "U"
  Prepare Environment Empresa "01" Filial "01" Tables "SC5,SC6,SC9"
EndIf
cQry += " SELECT * FROM " + RetSqlName("SC5") + " C5 "
cQry += " Left Outer Join " + RetSqlName("SC9") + " C9 on C9_PEDIDO = C5_NUM and C9_FILIAL = C5_FILIAL
cQry += " Left Outer Join " + RetSqlName("SL1") + " L1 on L1_FILIAL = C5_FILIAL ANd L1_NUM = C5_ORCRES
cQry += " WHERE DATEDIFF(day  ,CAST(C9_DATALIB AS DATE), GETDATE()) >= " + Str(SuperGetMv("MV_XBLQDIA",.F.,5))
cQry += " And C5_NOTA    = ''
cQry += " And C5_LIBEROK = ''
cQry += " And C5_BLQ     = ''
cQry += " And C5_ORCRES != ''
cQry += " And C9_BLCRED  = ''
cQry += " And C5.D_E_L_E_T_ = ''
cQry += " And C9.D_E_L_E_T_ = ''

dbUseArea(.T.,"TOPCONN",tcGenQry(,,ChangeQUery(cQRy)),cTable,.T.,.T.)

SC5->(dBSetORder(1))
SC9->(dbSetORder(1))
SZ3->(dbSetORder(1))

While !(cTable)->(EOF())
	SC5->(dbSeek((cTable)->(C5_FILIAL + C5_NUM)))
	If !SeeForm()
		SC9->(dbSeek((cTable)->(C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_PRODUTO) ))
		SC9->(RecLock("SC9",.F.))
		SC9->C9_BLCRED := "02"
		SC9->(MsUnlock())
		
		If SZ3->(dbSeek((cTable)->(C9_FILIAL + C9_PEDIDO + "2")))
			aAdd(aBloqueio,{"Z3_FILIAL" ,SZ3->Z3_FILIAL})
			aAdd(aBloqueio,{"Z3_VENDA"  ,SZ3->Z3_VENDA})
			aAdd(aBloqueio,{"Z3_TIPO"   ,"2"})
			aAdd(aBloqueio,{"Z3_CLIENTE",SZ3->Z3_CLIENTE})
			aAdd(aBloqueio,{"Z3_LOJA"   ,SZ3->Z3_LOJA })
			aAdd(aBloqueio,{"Z3_BLOQUEI",'C' + Rigth(SZ3->Z3_BLOQUEI,1)})
			
			If ExistBlock("AALJ05GRV")
				u_AALJ05GRV(aBloqueio)
			EndIf
		else
			aAdd(aBloqueio,{"Z3_FILIAL",(cTable)->C5_FILIAL})
			aAdd(aBloqueio,{"Z3_VENDA",(cTable)->C5_NUM})
			aAdd(aBloqueio,{"Z3_TIPO","2"})
			aAdd(aBloqueio,{"Z3_CLIENTE",(cTable)->C5_CLIENTE})
			aAdd(aBloqueio,{"Z3_LOJA",(cTable)->C5_LOJACLI })
			aAdd(aBloqueio,{"Z3_TIPOCLI",(cTable)->C5_TIPOCLI})
			aAdd(aBloqueio,{"Z3_VEND",(cTable)->C5_VEND1})
			aAdd(aBloqueio,{"Z3_EMISSAO",(cTable)->C5_EMISSAO})
			aAdd(aBloqueio,{"Z3_ENDENT",(cTable)->C5_ENDENT})
			aAdd(aBloqueio,{"Z3_BAIRROE",(cTable)->C5_BAIRROE})
			aAdd(aBloqueio,{"Z3_MUNE",(cTable)->C5_MUNE})
			aAdd(aBloqueio,{"Z3_ESTE",(cTable)->C5_ESTE})
			aAdd(aBloqueio,{"Z3_DESCONT",(cTable)->C5_DESCONT})
			aAdd(aBloqueio,{"Z3_PESOL",(cTable)->C5_PESOL})
			aAdd(aBloqueio,{"Z3_PESOB",(cTable)->C5_PBRUTO})
			aAdd(aBloqueio,{"Z3_FONEENT",(cTable)->C5_FONEENT})
			aAdd(aBloqueio,{"Z3_OBS1",(cTable)->C5_OBSENT1})
			aAdd(aBloqueio,{"Z3_OBS2",(cTable)->C5_OBSENT2})
			aAdd(aBloqueio,{"Z3_BLOQUEI","C "})
			aAdd(aBloqueio,{"Z3_NOMCLI",Posicione('SA1',1,xFilial("SA1") +  (cTable)->(C5_CLIENTE  + C5_LOJACLI),"A1_NOME") })
			
			If ExistBlock("AALJ05GRV")
				u_AALJ05GRV(aBloqueio)
			EndIf
			
		EndIf
	EndIf
	(cTable)->(dbSkip())
EndDo
(cTable)->(dbCloseArea(cTable))
Return Nil

Static Function SeeForm()
Local lRetLc := .T.
Private aPgtos := {}

SL1->(dbSetOrder(1))
SL4->(dbSetOrder(1))
SA1->(dbSetOrder(1))

SA1->(dBSeek(xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI))
SL1->(dBSeek(SC5->C5_FILIAL + SC5->C5_ORCRES)) // Posiciona no Orcamento de Reserva na Mesma Filial do Pedido, para poder Fazer o Seek Abaixo
SL4->(dbSeek(SL1->L1_FILRES + SL1->L1_ORCRES)) // Posiciona na SL4 do Orcamento Original

While !SL4->(EOF()) .And. SL4->(L4_FILIAL + L4_NUM) == SL1->(L1_FILRES + L1_ORCRES)
	aAdd(aPgtos,{SL4->L4_DATA,SL4->L4_VALOR,SL4->L4_FORMA})
	SL4->(dbSkip())
EndDo
If ExistBlock("LJ7014")
	lRetLC := !u_LJ7014()
EndIf
Return lRetLc


/*powered by DXRCOVRB*/                                                                 