#include "TbiConn.ch"
#include "Protheus.ch"

User Function AALOGE01(_cRoman,_cDoc,_cSerie,_cOper,_cdTpRoman,_cdCliente,_cdLoja)

Default _cRoman := ''
Default _cDoc   := ''
Default _cSerie := ''
Default _cOper  := ''
Default _cdTpRoman := "S"
Default _cdCliente := ""
Default _cdLoja    := ""

If Type("cAcesso") = "U"
  Prepare Environment Empresa "01" FILIAL "01" Tables "SZ4,SZE" MODULO "EST"
EndIf

SZ4->(RecLock('SZ4',.T.))
  
  If SZ4->(FieldPos("Z4_TPROMAN")) > 0
     SZ4->Z4_TPROMAN := _cdTpRoman
  Else
     Aviso("[ERRO]","[ERRO] Falta Criar o CAMPO Z4_TPROMAN (TAMANHO: 01, TIPO: CARACTER) , Favor Contate o T.I. ",{'OK'})     
  EndIf
  
  If SZ4->(FieldPos("Z4_CLIFOR")) > 0
     SZ4->Z4_CLIFOR := _cdCliente
  Else
     Aviso("[ERRO]","[ERRO] Falta Criar o CAMPO Z4_CLIFOR (TAMANHO: 06, TIPO: CARACTER) , Favor Contate o T.I. ",{'OK'})     
  EndIf
  
  If SZ4->(FieldPos("Z4_LOJA")) > 0
     SZ4->Z4_LOJA := _cdLoja
  Else
     Aviso("[ERRO]","[ERRO] Falta Criar o CAMPO Z4_LOJA (TAMANHO: 02, TIPO: CARACTER) , Favor Contate o T.I. ",{'OK'})     
  EndIf
  
  SZ4->Z4_ROMANEI := _cRoman
  SZ4->Z4_NUMNF   := _cDoc
  SZ4->Z4_SERIE   := _cSerie
  SZ4->Z4_DATAOP  := Date()
  
  If SZ4->(FieldPos("Z4_HORAOP")) > 0
     SZ4->Z4_HORAOP := Time()
  EndIf
  
  SZ4->Z4_USUARIO := cUserName
  SZ4->Z4_OPERACA := _cOper
  
SZ4->(MsUnlock())

Return Nil