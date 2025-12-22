#include "rwmake.ch"        

User Function Cfat20i()     

SetPrvt("_AAREA,_CTABPRC,_CFILIAL,_NPRCVEN,_CPRCVEN,_NPRCTAB")
SetPrvt("_NTAXA,_NVALMIN,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT20I  ³ Autor ³Ronie e Rosimeire Goes ³ Data ³ 30/06/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gatilho para calculo do preco unitario no orcamento levando ³±±
±±³          ³em consideracao : Preco Unitario - Desconto Padrao + Tx Fin ³±±
±±³          ³Validacao do preco calculado qto a tabela de preco minimo   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Desconto padrao e'trazido de tabela especifica do cliente  ³±±
±±³          ³ SZ2 que ja foi trazido por gatilho para o CJ_CLDESC        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Orcamento de Venda e Pedido de Venda                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/
_aArea := {Alias(),IndexOrd(),Recno()}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o preco unitario de acordo com a tabela de preco escolhido      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cTabPrc := M->CJ_TABELA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa Produtos ou Compl. Produtos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If _cTabPrc <> "1"
   dbSelectArea("SB5")
   _cFilial := xFilial("SB5")
Else
   dbSelectArea("SB1")
   _cFilial := xFilial("SB1")
Endif

dbSetOrder(1)
If dbSeek(_cFilial+TMP1->CK_PRODUTO)
   If Alias()=="SB1"
      _nPrcVen := Round(SB1->B1_PRV1,2)
   Else
      _cPrcVen := "SB5->B5_PRV"+_cTabPrc
      _nPrcVen := &_cPrcVen
   Endif
       TMP1->CK_PRUNIT := _nPrcVen
Endif
_nPrcTab:= _nPrcVen

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Aplica no preco unitario o desconto padrao do Cliente com base no SZ2    ³
//³ que foi trazido por gatilho para o CJ_CLDESC                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_nPrcVen := Round(_nPrcVen-((_nPrcVen*M->CJ_CLDESC)/100),2)

//If M->CJ_CLTXFI=="S"       //Desabilitado em 02/10/99 visto que estava gerando duplicidade
//   dbSelectArea("SE4")
//   dbSetOrder(1)
//   dbSeek(xFilial()+CJ_CONDPAG)
//   _ntaxa:= SE4->E4_ACRSFIN
//   
//   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//   //³ Aplica no preco unitario a taxa financeiro da cond. de pagto. escolhida  ³
//   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//
//   _nPrcVen := _nPrcVen + ((_nPrcVen*_ntaxa)/100)
//Endif

_nValMin:= posicione("SB5",1,_cFilial+SB1->B1_COD,iif(_cTabPrc=="2","B5_PRV6","B5_PRV7"))


if _nPrcVen < _nValMin
   MSGBOX("Preco de Tabela          --> R$ "+transform(_nPrcTab,"@E 999,999,999.99")+space(44)+"Preco Minimo               --> R$ "+transform(_nValMin,"@E 999,999,999.99")+space(36)+"Preco com Descontos --> R$ "+transform(_nPrcVen,"@E 999,999,999.99"),"Alerta Precos","ALERT")
   TMP1->CK_OBSERVA:="PRECO CALC.P/CLIENTE C/DESC.PADRAO"+STR(_nPrcVen,14,2)
endif

_nPrcVen:=IIF(_nPrcVen < _nValMin,_nValMin,_nPrcVen)
dbSelectArea(_aArea[1])
dbSetOrder(_aArea[2])

TMP1->CK_PRCVEN:=Round(_nPrcVen,2)
//TMP1->CK_VALOR:=Round(TMP1->CK_QTDVEN*_nPrcVen,2)
//TMP1->CK_DESCONT:=100-((TMP1->CK_PRCVEN/TMP1->CK_PRUNIT)*100)
//TMP1->CK_VALDESC:=Round(((TMP1->CK_PRUNIT*TMP1->CK_DESCONT)/100)*TMP1->CK_QTDVEN,2)

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return(TMP1->CK_PRUNIT)
Return(TMP1->CK_PRUNIT)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

