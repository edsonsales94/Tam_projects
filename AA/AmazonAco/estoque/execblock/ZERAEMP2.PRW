//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"
 
/*/{Protheus.doc} User Function ZERAEMP2
Função que executa uma query 
@type  Function
@author Raphael Rage
@since 18/12/2023

*/

User Function ZERAEMP2()
    //Local cCodFor := "000010"
    //Local cNovoNome := "Teste"
    Local nRet := 0
 

//    Local cQuery := "UPDATE "+RetSQLName("SA2") + " "
//   cQuery += " SET A2_NOME:='"+cNovoNome+"' WHERE A2_COD='"+cCodFor+"' AND D_E_L_E_T_='' "

    Local cQuery := "UPDATE SB8010 SET B8_EMPENHO = '',  B8_EMPENH2 = '' FROM SB8010(nolock) WHERE D_E_L_E_T_=''AND B8_LOCAL BETWEEN '' AND '14' AND (B8_EMPENHO<>0 OR B8_EMPENH2 <>0) "
    cQuery += " UPDATE SB2010 SET B2_QEMP= '', B2_RESERVA= '',  B2_RESERV2= '', B2_QEMP2 = '' FROM SB2010 (nolock) WHERE D_E_L_E_T_=''AND B2_LOCAL BETWEEN '' AND '14' AND (B2_QEMP<>0 OR B2_RESERVA <> 0 OR B2_RESERV2 <> 0) "
    cQuery += " UPDATE SBF010 SET BF_EMPENHO= '', BF_EMPEN2= '' FROM SBF010 (nolock) WHERE D_E_L_E_T_=''AND BF_LOCAL BETWEEN '' AND '14' AND (BF_EMPENHO<>0 OR BF_EMPEN2<>0 ) "
    cQuery += " UPDATE SB2060 SET B2_QEMP= '', B2_RESERVA= '',  B2_RESERV2= '', B2_QEMP2 = '', B2_QPEDVEN = '' FROM SB2060 (nolock) WHERE D_E_L_E_T_=''AND B2_LOCAL BETWEEN '' AND '14' AND (B2_QEMP<>0 OR B2_RESERVA <> 0 OR B2_RESERV2 <> 0) "

 
    //Executa a instrução SQL de cQuery
    nRet := TCSQLExec(cQuery)
 
    If(nRet < 0 )
        MsgStop("Erro na execução da query:"+TcSqlError(), "Atenção")
    Else
        MsgAlert("O UPDATE da query foi executado com sucesso!")
    EndIf
 
 
Return
