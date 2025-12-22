#include "rwmake.ch"       

User Function Cfat41i()   

SetPrvt("NPOS,CPRODUTO,NPRV1,NPRV2,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT41I  ³ Autor ³Ricardo Correa de Souza³ Data ³30/03/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gatilho para Validacao do Produto no Pedido de Venda       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Gatilho Disparado no Campo C6_PRODUTO                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Correa³12/09/01³ Mensagem para Usuario Produtos Importados     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_PRODUTO"})
cProduto := aCols[n,nPos]

nPrv1    := 0
nPrv2    := 0

DbSelectArea("SB5")
DbSetOrder(1)
If !DbSeek(xFilial("SB5")+cProduto)
    MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,13))+", o produto "+Alltrim(cProduto)+" nao esta cadastrado no Complemento de Produtos, portanto voce nao pode incluir este item no pedido. Favor entrar em contato com o responsavel pelo cadastro para que o mesmo providencie a atualizacao.","Validacao Complemento de Produtos","Stop")
    cProduto := ""
Else
    nPrv2    := SB5->B5_PRV2
EndIf

DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1")+cProduto)
    nPrv1    := SB1->B1_PRV1
EndIf 

//----> verifica se o preco 1 esta zerado e preco 2 maior que zero somente para produtos acabados
If nPrv1 <= 0 .And. nPrv2 > 0 .And. SB1->B1_TIPO $ "PA/PP"
    MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,13))+" este produto e negociado em moeda estrangeira. Favor informar o codigo da moeda estrangeira no campo MOEDA para que o sistema converta os valores.","Validacao Produto Importado","Alert")
EndIf

Return(cProduto)  

