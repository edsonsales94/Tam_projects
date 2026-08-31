#Include "Protheus.ch"

/*/
±±ºDescricao ³ Retorna o valor liquido do Título para o CNAB a Receber º±±
±±º          ³ Abatendo os impostos do título original                 º±±
±±º Autor    ³ Microsiga				               º±±
±±º Data     ³ 30/07/2015								               º±±
/*/                                                                      

user function AMFINE01()

 nValor   := 0  
 cJuros   :=""
 nVlrAbat :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
 nValor   := (SE1->E1_SALDO-(nVlrAbat+SE1->E1_DECRESC)) * 100


IF !SA1->A1_XJURBOL$"N" 

    cJuros :=  STRZERO(nValor*SE1->E1_PORCJUR,13)                                                                                                                                                                                                                                                                                                                                                                                             
else
    cJuros :=REpli("0",13)

Endif

RETURN cJuros 
    