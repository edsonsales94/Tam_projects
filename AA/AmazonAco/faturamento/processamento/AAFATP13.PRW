#include 'Protheus.ch'
#include 'ApWebSrv.ch'
#Include 'TopConn.Ch'
#include "Tbiconn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Fileio.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#DEFINE Imp_Spool      	2

//GERAÇÃO ARQUIVOS
User Function AAFATP13(cXEmp,cXFil)
    Local    cQry    := ""
    Private  _cAlias := CriaTrab(NIL,.F.)
    Private dData	   := DATE()
    //VERIFICAR COMO FUNCIONARA COM OUTRAS EMPRESAS
    //RPCSetType(3)  //Nao consome licensas
    //RpcSetEnv(cXEmp,cXFil,,,,GetEnvServer(),{ }) //Abertura do ambiente em rotinas automáticas
    RpcClearEnv()
    RpcSetType(3)
    Prepare Environment Empresa cXEmp Filial cXFil MODULO "FAT" TABLES "SF2", "SD2", "SA1", "SE1"
    
    ConOut(Padc("Start - JOB Envio de Boletos - AmazonAço - Protheus  ==> "+Dtoc(dData)+" "+Time(),100))

    //cQry += "  SELECT  F2_FILIAL,F2_XBANCO,F2_DOC,F2_SERIE,F2_CLIENTE,F2_CLIENT,F2_LOJA,E1_XCONTA,E1_PARCELA,E1_NUM  FROM " +RetSQLName("SF2")+" SF2  "
    //cQry += "  INNER JOIN " +RetSQLName("SE1")+" SE1  ON SE1.D_E_L_E_T_='' AND F2_DOC = E1_NUM AND F2_SERIE = E1_PREFIXO AND F2_CLIENT = E1_CLIENTE AND F2_LOJA = E1_LOJA AND SE1.D_E_L_E_T_=''  "
    //cQry += "  WHERE F2_EMISSAO = '"+DTOS(DATE())+"' AND SF2.D_E_L_E_T_ = '' AND F2_XBANCO <> '' AND E1_SALDO > 0 AND E1_XCONTA ='' "

    cQry += "  SELECT  F2_FILIAL,F2_XBANCO,F2_DOC,F2_SERIE,F2_CLIENTE,F2_CLIENT,F2_LOJA,E1_XCONTA,E1_PARCELA,E1_NUM  FROM " +RetSQLName("SF2")+" SF2  "
    cQry += "  INNER JOIN " +RetSQLName("SE1")+" SE1  ON SE1.D_E_L_E_T_='' AND F2_DOC = E1_NUM AND F2_SERIE = E1_PREFIXO AND F2_CLIENT = E1_CLIENTE AND F2_LOJA = E1_LOJA AND SE1.D_E_L_E_T_=''  "
    cQry += "  WHERE F2_EMISSAO >= '20210113' AND SF2.D_E_L_E_T_ = '' AND F2_XBANCO <> '' AND E1_SALDO > 0 AND E1_XENVIO!='S'  AND (E1_XCONTA ='341' OR E1_XCONTA='') "

    MEMOWRITE('AAFATP13.SQL',cQry)

    dbUseArea( .T., "TOPCONN", TcGenQry(,, cQry ), _cAlias , .T., .F. )

    dbSelectArea("SF2")
    DBSETORDER(1)
    //qout("cabou a query")

    While !(_cAlias)->(Eof())
        If SF2->(DBSEEK( (_cAlias)->F2_FILIAL+(_cAlias)->F2_DOC+(_cAlias)->F2_SERIE+(_cAlias)->F2_CLIENTE+(_cAlias)->F2_LOJA))
            ConOut("Proc- JOB Envio de Boletos - AmazonAço - Protheus - NroDocumento  ==> " +SF2->F2_DOC)
            u_AAFINR01( SF2->F2_SERIE , SF2->F2_DOC ,"",.T.)
            SLEEP(5000)
            (_cAlias)->(DBSKIP())
        endif
    EndDo
    ConOut(Padc("End - JOB Envio de Boletos - AmazonAço - Protheus  ==> "+Dtoc(dData)+" "+Time(),100))
    RpcClearEnv() 
Return .T.
