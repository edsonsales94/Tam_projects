#Include "Rwmake.ch"


**Função criada por Ulisses Jr em 03/03/08 para gatilho
**do nome do cliente/fornecedor quando o pedido
**for de beneficiamento ou devolução

User Function PCliFor()
	Local cNome := ""
	Local cChave:= M->C5_CLIENTE+If(!Empty(M->C5_LOJACLI),M->C5_LOJACLI,"")

	If M->C5_TIPO $ "DB"
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(XFILIAL()+M->C5_CLIENTE+M->C5_LOJACLI))
		cNome := SA2->A2_NOME
	Else
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(XFILIAL()+M->C5_CLIENTE+M->C5_LOJACLI))
		cNome := SA1->A1_NOME
	Endif

Return cNome
