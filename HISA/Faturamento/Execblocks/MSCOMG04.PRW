#Include "Protheus.ch" 
#INCLUDE "rwmake.ch"
#Include "Topconn.ch"

/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MSCOMG04   ¦ Autor ¦Orismar Silva         ¦ Data ¦ 01/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦Rotina para consulta se o produto pertence a tabela de preço informada na  ¦¦¦
¦¦¦rotina de orçamento.                                                       ¦¦¦
¦¦+---------------------------------------------------------------------------+¦¦
¦¦¦GATILHOS: CK_PRODUTO                                                       ¦¦¦
¦¦¦CONTRA DOMINIO: CK_PRODUTO,REGRA: U_MSCOMG04(M->CJ_TABELA,M->CK_PRODUTO)   ¦¦¦ 
¦¦+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

USER Function MSCOMG04(cTabela,cProduto)

Local cQuery,cAlias
Local cProd  := cProduto


if !Empty(cTabela)

	cQuery := " SELECT DA1_CODPRO"
	cQuery += " FROM "+RetSQLName("DA1")
	cQuery += " WHERE D_E_L_E_T_ = ''"
	cQuery += " AND DA1_FILIAL = '"+XFILIAL("DA1")+"'"
	cQuery += " AND DA1_CODTAB = '"+cTabela+"'"
	cQuery += " AND DA1_CODPRO = '"+cProduto+"'"
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"TBH",.T.,.F.)
   DbSelectArea("TBH")
   Dbgotop()  
   
   if Eof()  
      Aviso("ATENÇÃO","Produto não pertence a Tabela de Preço informada !",{"OK"})
      cProd  := CriaVar("CK_PRODUTO")
   End

   TBH->(DbCloseArea())
else 
   Aviso("ATENÇÃO","Favor informar a Tabela de Preço !",{"OK"})  
   cProd  := CriaVar("CK_PRODUTO")
endif
dbSelectArea(cAlias)

Return cProd
