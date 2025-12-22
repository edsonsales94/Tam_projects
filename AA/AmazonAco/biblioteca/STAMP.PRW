#INCLUDE "rwmake.ch"
#Include "Protheus.ch"
#include "AP5MAIL.ch"
#include "tbiconn.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.ch"

User Function STAMP()

Local nI, cConfig, aConfig

//Cria uma nova conexão com um banco (SGBD) através do DBAccess
TCLink()

//Habilita o Dbaccess e acrescentar o campo STAMP nas novas tabelas
TCConfig('SETUSEROWSTAMP=ON')

// Habilita criar o campo para tabelas já existentes (Para usar esse segundo comando ( AUTOSTAMP ) , você deve primeiro habilitar o primeiro (USEROWSTAMP)
TCCONfig("SETAUTOSTAMP=ON")

// Faz o Dbaccess acrescentar a coluna sem precisar recriar a tabela 

//CHAMADA PARA O GRUPO 010

    TCRefresh("SA2010")
    TCRefresh("SB1010")
    TCRefresh("SBM010")
    TCRefresh("SBM010")
    TCRefresh("SC7010")
    TCRefresh("SD1010")
    TCRefresh("CT1010")
    TCRefresh("CT2010")
    TCRefresh("CTS010")
    TCRefresh("CTT010")
    TCRefresh("CTD010")
    TCRefresh("SA1010")
    TCRefresh("SA3010")
    TCRefresh("SC5010")
    TCRefresh("SC6010")
    TCRefresh("SCT010")
    TCRefresh("SD2010")
    TCRefresh("SF4010")
    TCRefresh("SF5010")
    TCRefresh("SA6010")
    TCRefresh("SE1010")
    TCRefresh("SE2010")
    TCRefresh("SE5010")
    TCRefresh("SED010")
    TCRefresh("FJ1010")
    TCRefresh("FJ2010")
    TCRefresh("FJ3010")
    TCRefresh("SB2010")
    TCRefresh("SB9010")
    TCRefresh("SD3010")
    TCRefresh("NNR010")
//FINALIZA GRUPO 010


//ABRE CHAMADA GRUPO 060
    TCRefresh("SA2060")
    TCRefresh("SB1060")
    TCRefresh("SBM060")
    TCRefresh("SBM060")
    TCRefresh("SC7060")
    TCRefresh("SD1060")
    TCRefresh("CT1060")
    TCRefresh("CT2060")
    TCRefresh("CTS060")
    TCRefresh("CTT060")
    TCRefresh("CTD060")
    TCRefresh("SA1060")
    TCRefresh("SA3060")
    TCRefresh("SC5060")
    TCRefresh("SC6060")
    TCRefresh("SCT060")
    TCRefresh("SD2060")
    TCRefresh("SF4060")
    TCRefresh("SF5060")
    TCRefresh("SA6060")
    TCRefresh("SE1060")
    TCRefresh("SE2060")
    TCRefresh("SE5060")
    TCRefresh("SED060")
    TCRefresh("FJ1060")
    TCRefresh("FJ2060")
    TCRefresh("FJ3060")
    TCRefresh("SB2060")
    TCRefresh("SB9060")
    TCRefresh("SD3060")
    TCRefresh("NNR060")
//FINALIZA CHAMADA GRUPO 060

//Após execução desligar as chaves para não criar em outras tabelas do sistema desnecessárias
TCCONfig("SETUSEROWSTAMP=OFF")
TCCONfig("SETAUTOSTAMP=OFF")

//Encerra a conexão especificada com o DBAccess
TCUnlink()

Return
