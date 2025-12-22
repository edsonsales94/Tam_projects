#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  AALOJE03  ¦ Autor ¦ Alexsandro Jesus	  ¦ Data ¦ 10/12/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Execblock de impressão de dados adicionais no cupom fiscal    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AALOJE03()
Local cCliente, cMensagem

SA3->(dbSetOrder(1))
SA3->(dbSeek(XFILIAL("SA3")+SL1->L1_VEND))
SA1->(dbSetOrder(1))
SA1->(dbSeek(XFILIAL("SA1")+SL1->(L1_CLIENTE+L1_LOJA)))
SL2->(dbSetOrder(1))
SL2->(dbSeek(SL1->(L1_FILIAL+L1_NUM),.T.))
cCliente  := ""
cCliente  += PADR(alltrim("Cliente:"+SA1->A1_COD + "/" + SA1->A1_LOJA+"-" + SUBSTR(SA1->A1_NOME,1,30)),48)
cCliente  += PADR(ALLTRIM("End:" + SUBSTR(SA1->A1_END,1,44)),48)
cMensagem := cCliente
cMensagem += PADR(AllTrim("Vendedor:" + ALLTRIM(SL1->L1_VEND) + "-" + SUBSTR(SA3->A3_NREDUZ,1,39)),48)
cMensagem += PadR("Orcamento:"+SL1->L1_NUM + "/" + SL1->L1_FILIAL,48)
cMensagem += PADR(GetMV("MV_XMENCUP"),48) //"Obrigado e Volte Sempre !"

Return(cMensagem)
