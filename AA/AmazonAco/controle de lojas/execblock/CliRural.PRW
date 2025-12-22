#Include "rwmake.ch"

User Function CliRural()                   

/*---------------------------------------------------------------------------------------------------------------------------------------------------
Função executada pelo Gatilho LQ_CLIENTE - 002 
OBJETIVO 1: Demonstrar a Mensagem de PRODUTOR RURAL na Venda Assistida
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/


If SA1->(DbSeek(xFilial("SA1")+M->LQ_CLIENTE+M->LQ_LOJA))
	
	If Alltrim(SA1->A1_TIPO) == "L" // Se o Cliente for Produtor Rural
		Lj7R_Rodape		("C L I E N T E   P R O D U T O R   R U R A L    ---   C L I E N T E   P R O D U T O R   R U R A L   ---  C L I E N T E   P R O D U T O R   R U R A L    ---   C L I E N T E   P R O D U T O R   R U R A L   ---") // Mensagem no Rodapé da Venda Assistida
	Else
		Lj7R_Rodape		("") // Mensagem no Rodapé da Venda Assistida	
	EndIf
	
Endif

Return(M->LQ_CLIENTE)
