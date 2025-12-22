#Include "protheus.ch"
#Include "rwmake.ch"
 
/*/{Protheus.doc}MT250GREST
@description
Exclui a etiqueta gerada no apontamento de produçao.

@author	Bruno Garcia
@since		19/05/2016
@version	P11 R8

@Alterado: Williams Messa
@Data: 09/02/2021
@Doc: Não estava posicionando corretamente para deletar a etiqueta.

@param 	Nao possui,Nao possui,Nao possui,Nao possui
@return	Nao possui,Nao possui,Nao possui,Nao possui
/*/

User Function MT250GREST()

Local aOKs   := {}
Local lErro  := .F.
Local nX
Local cQry   :=""

cQry :=" SELECT CB0_CODETI,CB0_CODPRO,CB0_NUMSEQ,CB0_QTDE,CB0_NFSAI,CB0_SERIES,R_E_C_N_O_ AS RECNO FROM  " + RetSQLName("CB0")
cQry +=" WHERE  CB0_NUMSEQ = '" + SD3->D3_NUMSEQ + "'"

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"CB0T",.T.,.T.)

CB0T->(dbSelectArea("CB0T"))
CB0T->(dbGoTop())

While !CB0T->(Eof()) .And. CB0T->CB0_NUMSEQ == SD3->D3_NUMSEQ  
   
   If ! Empty(CB0T->CB0_NFSAI+CB0T->CB0_SERIES)
      lErro:=.t.
	   AutoGrLog("Etiqueta "+CB0T->CB0_CODETI+" possui nota de saida - "+CB0T->CB0_NFSAI+'-'+CB0T->CB0_SERIES)
	Endif

   If Alltrim(CB0T->CB0_CODETI) <>"" .And. !lErro
      aadd(aOKs,CB0T->RECNO)	   
	EndIf

   CB0T->(DbSkip())
Enddo
//Fecha a área
CB0T->(dbCloseArea())

If lErro
   MostraErro()			
   Return .f.
EndIf
		
If !Empty(aOKs)
   For nX:= 1 to Len(aOKs)
      CB0->(DbGoto(aOKs[nX]))
      Reclock("CB0",.F.)
 	   CB0->(DbDelete())
	   CB0->(MsUnlock())
	Next
Endif

LOGPEDIDO()
Return Nil

Static FUnction LOGPEDIDO()    
  Local aDados := {}
  
   aAdd(aDados,{'Z5_PEDIDO' ,SC2->C2_XPEDIDO})
   aAdd(aDados,{'Z5_PRODUTO',SC2->C2_PRODUTO})
   aAdd(aDados,{'Z5_DATA'   ,dDataBase})
   aAdd(aDados,{'Z5_HORA'   ,SubStr(Time(),1,5)})
   aAdd(aDados,{'Z5_USER'   ,cUserName})
   aAdd(aDados,{'Z5_OP'     ,SC2->(C2_NUM + C2_ITEM + C2_SEQUEN)})
   aAdd(aDados,{'Z5_ENTREGA',STOD('  /  /  ')}  )
   aAdd(aDados,{'Z5_OBS'    ,"MOVIMENTO DE PRODUCAO ESTORNADO" })
   
   If(SC2->C2_QUJE == SC2->C2_QUANT)
      aAdd(aDados,{'Z5_STATUS' ,"3"})
   else      
      aAdd(aDados,{'Z5_STATUS' ,"2"})
   EndIf
      
   If ExistBlock("AALOGE02")
      u_AALOGE02(aDados)
   EndIf

Return
