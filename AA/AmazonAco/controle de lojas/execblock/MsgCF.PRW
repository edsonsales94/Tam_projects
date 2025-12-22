#INCLUDE "Rwmake.ch"

User Function MsgCF()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Função executada pelo PARAMETRO MV_LJFISMS = &(u_MsgCF)
OBJETIVO 1: Imprimir as referências dos produtos no final do Cupom Fiscal
OBJETIVO 2: Imprimir o nome da Caixa, a Série do Cupom Fiscal e o número do PDV
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

Local   mMensagem 	:= ''+CHR(13)+CHR(10)
Local   nItem  		:= 0
DbSelectArea("SA3")
DbSetOrder(1)

DbSelectArea("SL1")

DbSelectArea("SL2")
DbGotop()

SA3->(DbSeek(xFilial("SA3")+SL1->L1_VEND))

mMensagem +=''+CHR(13)+CHR(10)+"Vendedor : "+SA3->A3_COD+"-"+SA3->A3_NREDUZ     
mMensagem +=''+CHR(13)+CHR(10)+"Cliente  : "+SA1->A1_COD+"-"+SA1->A1_NREDUZ
mMensagem +=''+CHR(13)+CHR(10)+"Caixa    : "+Alltrim(cUserName)+" - Serie: "+SLG->LG_SERIE+" - PDV: "+SLG->LG_PDV      
mMensagem +=''+CHR(13)+CHR(10)+"ID    	 : "+SL1->L1_ENTBRAS+" - Pedido : "+SL1->L1_PEDRES     

Return(mMensagem)