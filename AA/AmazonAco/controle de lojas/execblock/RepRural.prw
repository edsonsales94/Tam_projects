#Include "rwmake.ch"

User Function RepRural()

/*---------------------------------------------------------------------------------------------------------------------------------------------------
Função executada pelo Gatilho LQ_CLIENTE - 003 
OBJETIVO 1: Reprocessar o desconto de ICMS quando o cliente for PRODUTOR RURAL e VICE-VERSA, através da rotina de u_TABPRECO()
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

//u_TabPreco() // Rotina de Definição da Tabela de Preço

Return(M->LQ_CLIENTE)
