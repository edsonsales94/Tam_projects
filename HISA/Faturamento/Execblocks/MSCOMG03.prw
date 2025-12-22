#Include "Protheus.ch" 
#INCLUDE "rwmake.ch"
#Include "Topconn.ch"

/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MSCOMG03   ¦ Autor ¦Orismar Silva         ¦ Data ¦ 08/04/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦Rotina que gera o codigo do Cliente/Fornecedor e Loja                      ¦¦¦
¦¦¦GATILHOS: A1_CGC (Cliente) / A2_CGC (Fornecedor)                           ¦¦¦
¦¦¦CONTRA DOMINIO: A1_LOJA / A2_LOJA ,REGRA: U_SEQCLIFOR("C")/U_SEQCLIFOR("F")¦¦¦ 
¦¦+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

User Function MSCOMG03()

Local cQuery,cAlias
Local cNum := M->C5_PEDCLI
Local nQtd := 0
Local cNPV := ""

if !Empty(M->C5_PEDCLI)            
	
	cQuery := " SELECT COUNT(C5_PEDCLI) AS QTD,C5_NUM"
	cQuery += " FROM "+RetSQLName("SC5")
	cQuery += " WHERE D_E_L_E_T_ = ''"
	cQuery += " AND C5_FILIAL = '"+XFILIAL("SC5")+"'"
	cQuery += " AND C5_PEDCLI = '"+M->C5_PEDCLI+"'"
	cQuery += " GROUP BY C5_NUM "
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"TBH",.T.,.F.)
   DbSelectArea("TBH")
   Dbgotop()  
   While !Eof()  
      nQtd += TBH->QTD
      if nQtd > 1
         cNPV += ","+TBH->C5_NUM
      else
        cNPV += TBH->C5_NUM
      endif
      dbSkip()
   End

	If nQtd > 0
		//Alert("Número do pedido do cliente já utilizado em outro pedido de venda ["+cNPV+"] !","Atenção")
		If !MsgBox("Número do pedido do cliente já utilizado em outro(s) pedido(s) de venda: ["+cNPV+"] !"+chr(13)+ chr(10)+"Deseja utilizar o mesmo número do pedido do cliente ?","A T E N Ç Ã O","YESNO")
		   cNum := ""
		Endif	
	EndIf
   
   TBH->(DbCloseArea())
endif
dbSelectArea(cAlias)

Return(cNum) 
