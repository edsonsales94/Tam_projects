#include "ap5mail.CH"                  
#include "PROTHEUS.CH"
#include "RWMAKE.CH"

/*
Rotina....: CN120ENCMD
Tipo......: Ponto de Entrada chamado apos o encerramento da medição do contrato
Autor.....: Ana Claudia Reis da Silva
Analista..: Adelson Veras
Data......: 24/11/2008
Objetivo..:            
*/
USER FUNCTION CN120ENCMD()

LOCAL cNum		:= ""
Local cChave    :=  xFilial("CNE")+SC7->(C7_CONTRA+C7_CONTREV+C7_PLANILH+C7_MEDICAO)
Local cTipo     := "2"

cNum  := SC7->C7_NUM

CNE->(dbSetOrder(1))
CNE->(dbSeek(cChave))
SC7->(dbSetOrder(1))

While !CNE->(Eof()) .AND. cChave == xFilial("CNE")+CNE->(CNE_CONTRA+CNE_REVISA+CNE_NUMERO+CNE_NUMMED)

  If SC7->(dbSeek(xFilial("SC7")+cNum+"0"+CNE->CNE_ITEM))  
	SC7->(RecLock("SC7",.F.))
   	SC7->C7_CC      := CNE->CNE_XCC
      SC7->C7_CONTA	  := CNE->CNE_XCONTA
      SC7->C7_ITEMCTA := CNE->CNE_XITEMC
	   SC7->C7_CLVL    := CNE->CNE_XCLVL                     
	MsUnLock()
  EndIf
  CNE->(dbSkip())
End
                               
Return
