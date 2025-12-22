#Include "Protheus.ch"
#Include "Topconn.ch"

/*---------------------------------------------------------------------------------------------------------------------------------------------------
Função chamada pelo Gatilho A2_CGC Sequencia 009 
OBJETIVO 1: Calcular o Código do Fornecedor e Loja quando tiver o mesmo CGC (Matriz e Filial);
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

User Function SEQFORN()

Local cQuery,cQuery2,cCodForn,cAlias,nCont


//Conta quantas vezes as iniciais do CNPJs do mesmo Fornecedor está cadastrado e atribui ao campo Loja 
cAlias 	:= ALIAS()
nCont 	:= 0

cQuery := " SELECT COUNT(A2_COD) AS QTD"
cQuery += " FROM "+RetSQLName("SA2")
cQuery += " WHERE SUBSTRING(A2_CGC,1,8) = '"+SUBSTRING(M->A2_CGC,1,8)+"' AND D_E_L_E_T_ <> '*'"
dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"FOR1",.F.,.T.)

If FOR1->QTD > 0
	nCont :=  FOR1->QTD + 1
	cLoja := StrZero(nCont,2)
	M->A2_LOJA 	:= cLoja
Else
    cLoja := "01"
EndIf

DbSelectArea("FOR1")
DbCloseArea("FOR1")

//Identifica o código Fornecedor já cadastado com as iniciais do mesmo CNPJ e atribui ao campo Código
cQuery2 := " SELECT A2_COD "
cQuery2 += " FROM "+RetSQLName("SA2")
cQuery2 += " WHERE SUBSTRING(A2_CGC,1,8) = '"+SUBSTRING(M->A2_CGC,1,8)+"' AND D_E_L_E_T_ <> '*'"
dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery2)),"FOR2",.F.,.T.)

If nCont > 0
	M->A2_COD 	:= FOR2->A2_COD
Else
	M->A2_COD 	:= GETSXENUM("SA2","A2_COD")                                                                                                       
EndIf

DbSelectArea("FOR2")
DbCloseArea("FOR2")

DbSelectArea(cAlias)
return(cLoja)
