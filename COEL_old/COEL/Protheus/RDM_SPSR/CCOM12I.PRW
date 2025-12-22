#include "rwmake.ch"        

User Function ccom12i()     


SetPrvt("_ACAMPO,_CCAMPO,_CCPO,_LMARK,AROTINA,CCADASTRO")
SetPrvt("CMARCA,_ACAMPOS,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CCOM12I  ³ Autor ³Ricardo Correa de Souza³ Data ³04.08.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Browse Notas Entrada para Geracao de Pedidos Sao Roque (PV)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

*---------------------------------------------------------------------------*
* Criacao do MarkBrowse do Arquivo SD1 (Itens de Notas de Entrada)          *
*---------------------------------------------------------------------------*

_aCampo  := {}
_cCampo  := "D1_OK"
_cCpo    := "SD1->D1_CLPVTRA"
_lMark   := .f.

DbSelectArea("SD1")
DbSetOrder(1)
DbGoTop()

aRotina   := { { "Pesquisa"  ,"AxPesqui" ,0,1},;
               { "Gera Pedidos",'Execblock("CCOM13I",.F.,.F.)',0,4}  }           

cCadastro := "Geracao de Pedidos de Transferencia"

cmarca    := getmark()

_aCampos  := {{"D1_OK","",""},{"D1_DOC","","Nota Fiscal"},;
             {"D1_COD","","Produto"},{"D1_CLPT","","Tipo Transf"},{"D1_QUANT","","Quantidade"},;
             {"D1_DTDIGIT","","Data Digitacao"},{"D1_CLPVTRA","","Pedido Venda"}}

MarkBrow("SD1",_cCampo,_cCpo,_aCampos,_lMark,cMarca)

Return(nil)

