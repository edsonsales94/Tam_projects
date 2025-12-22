#include "Protheus.ch"  
#include "rwmake.ch" 
#include "TopConn.ch"
#include "TBIConn.ch"

/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ M410STTS   ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 19/12/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada executado após todas as alterações no arquivo¦¦¦
¦¦¦           ¦ de pedidos terem sido feita.(Gerar pedido de devolução)       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function M410STTS() 

                  
Local ccAlias := ALIAS()                               
Local nPosOrc := aScan(aHeader,{|x| alltrim(x[02]) == "C6_NUMORC" }) 
Local nNumOrc := SUBSTR(aCols[n,nPosOrc],1,6)
Local _nOper  := PARAMIXB[1]

if _nOper = 5 //Exclusão

   if !EMPTY(nNumOrc)
      /*
      dbSelectArea("SCJ")
      dbSetOrder(1)
      if dbSeek(xFilial("SCJ")+nNumOrc)
         RecLock("SCJ",.F.)
         SCJ->CJ_STATUS := 'A' "
         MsUnlock()      
      endif 
   
      dbSelectArea("SCK")
      dbSetOrder(1)
      if dbSeek(xFilial("SCK")+nNumOrc)
         RecLock("SCK",.F.)
         SCK->CK_NUMPV := ''
         MsUnlock()      
      endif 
      */  
      cQuery := "UPDATE "+RetSqlname("SCJ")+" "
	  cQuery += "SET CJ_STATUS = 'A' "
	  cQuery += "WHERE D_E_L_E_T_ = '' "
      cQuery += "AND CJ_FILIAL = '"+XFILIAL("SCJ")+"'"
      cQuery += "AND CJ_NUM = '"+nNumOrc+"'"
	  TcSqlExec(cQuery)
      *
      cQuery := "UPDATE "+RetSqlname("SCK")+" "
	  cQuery += "SET CK_NUMPV = '' "
	  cQuery += "WHERE D_E_L_E_T_ = '' "
      cQuery += "AND CK_FILIAL = '"+XFILIAL("SCK")+"'"
      cQuery += "AND CK_NUM = '"+nNumOrc+"'"
	  TcSqlExec(cQuery)
      *   
   endif
     
endif
*

*
DbSelectArea(ccAlias)
*
Return                          


