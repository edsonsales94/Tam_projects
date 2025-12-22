#include "rwmake.ch"

User Function Cfat80i()

SetPrvt("NPOS,CPRODUTO,NPRV1,NPRV2,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT80I  ³ Autor ³Rogerio B. de Oliveira ³ Data ³08/03/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gatilho para Validacao do Produto quanto a tabela de precos³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Gatilho Disparado no Campo C6_PRODUTO e CK_PRODUTO         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/


_aArea := GetArea()
_cRot  := AllTrim(FunName())

If _cRot == "MATA410"
	
	nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_PRODUTO"})
	cProduto := aCols[n,nPos]
	
	If cNivel <= 5
	  
	If M->C5_TIPO == "N"
		
		DbSelectArea("DA1")
		DbSetOrder(1)
		If !DbSeek(xFilial("DA1")+M->C5_TABELA+cProduto)
			MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,13))+", o produto "+Alltrim(cProduto)+" nao esta cadastrado na Tabela de Precos, portanto voce nao pode incluir este item no pedido. Favor entrar em contato com o responsavel pelo cadastro para que o mesmo providencie a atualizacao.","Validacao Tabela de Precos","Stop")
			cProduto := ""
		EndIf
		
	EndIf
    EndIf
Else
	
	cProduto   := M->CK_PRODUTO
	If _cRot <> "RFATM01"
		DbSelectArea("DA1")
		DbSetOrder(1)
		If !DbSeek(xFilial("DA1")+M->CJ_TABELA+cProduto)
			MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,13))+", o produto "+Alltrim(cProduto)+" nao esta cadastrado na Tabela de Precos, portanto voce nao pode incluir este item no orcamento. Favor entrar em contato com o responsavel pelo cadastro para que o mesmo providencie a atualizacao.","Validacao Tabela de Precos","Stop")
			cProduto := ""
		EndIf
	EndIf
EndIf

Return(cProduto)
