#include "Protheus.ch"

User Function MA440MNU()

/*   If ExistBlock("AAFATR03")
      aAdd(aRotina, { "Ordem de Carregamento","U_AA440MUC"	,0,4,0 ,NIL} 	)	//"Conhecimento"
   EndIf*/
   If existBlock("AAFATR04")
      aAdd(aRotina, { "Comprovante de Entrega","U_AA440MUA"	,0,4,0 ,NIL} 	)	//"Conhecimento"
   ENdIf
   If existBlock("AAFATR02")
      aAdd(aRotina, { "Lista de Separação     ","U_AA440MUB"	,0,4,0 ,NIL} 	)	//"Conhecimento"
   EndIf
   If existBlock("AAFATR20")
      aAdd(aRotina, { "Lista de Separação 2   ","U_AA440MUF"	,0,4,0 ,NIL} 	)	//"Conhecimento"
   EndIf
Return Nil

User Function AA440MUA()
   U_AAFATR04(SC5->C5_NUM, SC5->C5_FILIAL, , , ,.F.) // Nao IMprimir Itens Bloqueados a pedido do Adelson
//   AAFATR04(_cdPedido,_cdFilial,_cdOrcamento,_cdFilialO,lSetPrint,lBloc)
Return Nil

User Function AA440MUB()
   U_AAFATR02(SC5->C5_NUM, SC5->C5_FILIAL)
Return Nil

User Function AA440MUC()
   U_AAFATR20(SC5->C5_NUM, SC5->C5_FILIAL)
Return Nil

User Function AA440MUF()
   U_AAFATR03(SC5->C5_FILIAL,SC5->C5_NUM, .F.)// Nao IMprimir Itens Bloqueados a pedido do Adelson   
Return Nil