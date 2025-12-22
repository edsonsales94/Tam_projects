
/*/{Protheus.doc} TROCA_COMP

Este programa tem como objetivo realizar a troca automatica de componentes da estrutura conforme parametros informados pelo usuário.

@type function
@author Honda Lock
@since 01/10/2017

/*/

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// TROCA_COMP()
// ~~~~~~~~~~~~
//
// Este programa tem como objetivo realizar a troca automatica de componentes da estrutura conforme parametros informados pelo usuário.
//
// MV_PAR01 - Do Produto ?
// MV_PAR02 - Até o Produto ?
// MV_PAR03 - Componente de ?
// MV_PAR04 - Componente ate ?
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------

  User Function TROCA_COMP()
  
  If Pergunte("TRCCOMP")
     
     If MsgYesNo("Tem certeza que deseja realizar a substituição do camponente?")
        ALTERCOMP()       
     Endif
     
  Endif
  
  Return
  
//---------------------------------------------------------------------------------------------------------------------------------------------------------------

  Static Function ALTERCOMP()
                         
  cQry := "UPDATE "+RetSqlName("SG1")+" SET G1_COMP = '"+MV_PAR04+"' "
  cQry += " WHERE D_E_L_E_T_ = '' "
  cQry += "   AND G1_COD >= '"+MV_PAR01+"' "
  cQry += "   AND G1_COD <= '"+MV_PAR02+"' "
  cQry += "   AND G1_COMP = '"+MV_PAR03+"' "
          
  TcSqlExec(cQry)

  Alert("ATUALIZAÇÃO REALIZADA COM SUCESSO!")
  
  Return()

//---------------------------------------------------------------------------------------------------------------------------------------------------------------