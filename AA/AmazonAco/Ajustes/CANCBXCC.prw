//-------------------------------------------------------. 
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------'
#include "Protheus.ch"
#include "RwMake.ch"
User Function CANCBXCC

Local adados:={}
Local cQry  :=""

 dbSelectArea("SE1")
 dbSetOrder(1)
/* Industria
cQry := " SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIENTE,E5_LOJA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_VALOR,E1_MULTA,E1_JUROS,E1_DECRESC,E5_RECONC FROM SE5010 A "
cQry += " INNER JOIN SE1010 B ON B.D_E_L_E_T_='' AND E1_PREFIXO = E5_PREFIXO AND E1_NUM = E5_NUMERO AND E5_PARCELA = E1_PARCELA AND E5_CLIENTE = E1_CLIENTE AND E5_LOJA= E1_LOJA "
cQry += " WHERE E5_DATA BETWEEN '20210401' AND '20210416'  AND E5_TIPO IN ('CC','CD') AND A.D_E_L_E_T_='' AND E5_TIPODOC='VL' "
*///Silves
/*
cQry := " SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIENTE,E5_LOJA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_VALOR,E1_MULTA,E1_JUROS,E1_DECRESC,E5_RECONC FROM SE5050 A "
cQry += " INNER JOIN SE1050 B ON B.D_E_L_E_T_='' AND E1_PREFIXO = E5_PREFIXO AND E1_NUM = E5_NUMERO AND E5_PARCELA = E1_PARCELA AND E5_CLIENTE = E1_CLIENTE AND E5_LOJA= E1_LOJA "
cQry += " WHERE E5_DATA BETWEEN '20210401' AND '20210416'  AND E5_TIPO IN ('CC','CD') AND A.D_E_L_E_T_='' AND E5_TIPODOC='VL' "
*////Alvorada 
/*
cQry := " SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIENTE,E5_LOJA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_VALOR,E1_MULTA,E1_JUROS,E1_DECRESC,E5_RECONC FROM SE5060 A "
cQry += " INNER JOIN SE1060 B ON B.D_E_L_E_T_='' AND E1_PREFIXO = E5_PREFIXO AND E1_NUM = E5_NUMERO AND E5_PARCELA = E1_PARCELA AND E5_CLIENTE = E1_CLIENTE AND E5_LOJA= E1_LOJA "
cQry += " WHERE E5_DATA BETWEEN '20210401' AND '20210416'  AND E5_TIPO IN ('CC','CD') AND A.D_E_L_E_T_='' AND E5_TIPODOC='VL' "
*/
dbUseArea(.T.,"TopConn",TcGenQry(,,ChangeQuery(cQry)),"TRB",.T.,.T.)

dbSelectArea("TRB")
TRB->( DbGoTop() ) 
While !TRB->(EOF())

   
    If SE1->(dbSeek(XFILIAL("SE1")+TRB->E5_PREFIXO+TRB->E5_NUMERO+TRB->E5_PARCELA+TRB->E5_TIPO))

        lMsErroAuto := .F.
        lMsHelpAuto := .T.
        aVet := {}
        aAdd( aVet, { "E1_PREFIXO"   , TRB->E5_PREFIXO     , Nil } )
        aAdd( aVet, { "E1_NUM"       , TRB->E5_NUMERO	   , Nil } )
        aAdd( aVet, { "E1_PARCELA"   , TRB->E5_PARCELA     , Nil } )
        aAdd( aVet, { "E1_TIPO"      , TRB->E5_TIPO        , Nil } )
        aAdd( aVet, { "E1_CLIENTE"   , TRB->E5_CLIENTE     , Nil } )
        aAdd( aVet, { "E1_LOJA"      , TRB->E5_LOJA        , Nil } )
        aAdd( aVet, { "AUTMOTBX"     , "NOR"               , Nil } )
        aAdd( aVet, { "AUTBANCO"     , TRB->E5_BANCO       , Nil } )
        aAdd( aVet, { "AUTAGENCIA"   , TRB->E5_AGENCIA     , Nil } )
        aAdd( aVet, { "AUTCONTA"     , TRB->E5_CONTA       , Nil } )
        aAdd( aVet, { "AUTDTBAIXA"   , dDataBase           , Nil } )
        aAdd( aVet, { "AUTDTCREDITO" , dDataBase           , Nil } )
        aAdd( aVet, { "AUTDESCONT"   , TRB->E1_DECRESC     , Nil } )
        aAdd( aVet, { "AUT_HIST"     , "RBAIXA NORMAL     ", Nil } )
        aAdd( aVet, { "AUTMULTA"     , TRB->E1_MULTA       , Nil } ) 
        aAdd( aVet, { "AUTJUROS"     , TRB->E1_JUROS       , Nil } ) 
        aAdd( aVet, { "AUTVALREC"    , TRB->E5_VALOR       , Nil } ) 
        
        
        MsExecAuto({|x,y| FINA070(x,y) } , aVet, 6)
        
        If lMsErroAuto
            Alert("Ocorreu um erro na baixa do título: "+SE5->E5_PREFIXO+" / "+SE5->E5_NUMERO+" !")
            MostraErro()
            //dbSelectArea("SE1")
        Else
            RecLock("SE1",.F.)
		        SE1->E1_INSTR1 := "EST_AUTO"
		    MsUnlock()
        EndIf	
    EndIf
    TRB->(dbSkip())	
EndDo

dbCloseArea("TRB")

Return


