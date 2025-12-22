#include "totvs.ch"

User Function AAFATE14(xSerie,xDoc)
Local cxForma  := POSICIONE("SE4",1,XFILIAL("SE4")+SF2->F2_COND,"E4_FORMA") 
Local lBoleto  := .F.
Default xDoc   := ""
Default xSerie := ""

If EMpty(xDoc) .Or. Empty(xSerie)
   Return
EndIf

lBoleto := Alltrim(cxForma)$"BO|BOL"

lsendMail := GETMV("MV_XSENDM",.F.,.F.)
If lBoleto .And. lsendMail
   //Boleto encontrado
   if FwALertYesNo("Deseja Utilizar o Boleto do ITAU e enviar para o e-mail do cliente ?")
      //u_AAFINR01()
      // Enviando Email
	  //u_AAFINR01(xSerie , xDoc ,"",.T.)
     If SF2->(FieldPos("F2_XBANCO")) > 0 
	      //ESCREVA  AQUI ALGUMA REGRA PARA SETAR O BANCO DO BOLETO
	      RecLock("SF2", .F.)
	         SF2->F2_XBANCO := "341"
      	MsUnLock()	
      EndIf
   EndIf
Endif

Return

