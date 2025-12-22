#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ M460MARKºAutor  ³ Reinaldo Magalhaes  º Data ³  31/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E para ajustar a taxa contratada.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ .T. ou .F.                                                 º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION M460MARK	

Local lExec    := .F.       
Local lGrava   := .F.
Local dDtMoeda := dDataBase
Local nTxMoeda2:=0,nMoeda3:=0,nMoeda4:=0,nMoeda5:=0,nMoeda6:=0,nMoeda7:=0,nMoeda8:=0

SM2->(DbSetOrder(1))

If SM2->(DbSeek(dDatabase))
   nMoeda2:= SM2->M2_MOEDA2 
   nMoeda3:= SM2->M2_MOEDA3 
   nMoeda4:= SM2->M2_MOEDA4 
   nMoeda5:= SM2->M2_MOEDA5 
   nMoeda6:= SM2->M2_MOEDA6 
   nMoeda7:= SM2->M2_MOEDA7 
   nMoeda8:= SM2->M2_MOEDA8 
Endif

While !lExec

   DEFINE MSDIALOG oDlg TITLE "Informacoes Faturamento " FROM 00,00 TO 230,400 PIXEL
     
   @ 15,001 SAY "Data:"
   @ 15,040 GET dDtMoeda SIZE 40,20 OBJECT oData when .F.

   @ 15,100 SAY "Taxa Dolar:"
   @ 15,140 GET nMoeda2 SIZE 40,20 PICTURE "@E 999999.9999" OBJECT oMoeda2 
  
   @ 30,001 SAY "Taxa UFIR:"
   @ 30,040 GET nMoeda3 SIZE 40,20 PICTURE "@E 999999.9999" OBJECT oMoeda3 

   @ 30,100 SAY "Taxa Euro:"
   @ 30,140 GET nMoeda4 SIZE 40,20 PICTURE "@E 999999.9999" OBJECT oMoeda4 

   @ 45,001 SAY "Taxa CDI:"
   @ 45,040 GET nMoeda5 SIZE 40,20 PICTURE "@E 999999.9999" OBJECT oMoeda5 

   @ 45,100 SAY "Taxa Libras:"
   @ 45,140 GET nMoeda6 SIZE 40,20 PICTURE "@E 999999.9999" OBJECT oMoeda6 

   @ 60,001 SAY "Taxa Franco:"
   @ 60,040 GET nMoeda7 SIZE 40,20 PICTURE "@E 999999.9999" OBJECT oMoeda7 

   @ 60,100 SAY "Taxa Yene:"
   @ 60,140 GET nMoeda8 SIZE 40,20 PICTURE "@E 999999.9999" OBJECT oMoeda8 

   DEFINE SBUTTON oBtn1 FROM 75, 80 TYPE 1 ACTION (lGrava:=.T.,lExec := .T.,oDlg:End()) ENABLE

   ACTIVATE MSDIALOG oDlg CENTERED

Enddo

If lGrava             
   //  .----------------------.
   // |    Gravando moedas     |
   //  '----------------------'
   If SM2->(DbSeek(dDatabase))
      Reclock("SM2",.F.)
   Else
      Reclock("SM2",.T.)
   Endif         
   SM2->M2_DATA   := dDataBase
   SM2->M2_MOEDA1 := 0.00
   SM2->M2_MOEDA2 := nMoeda2 
   SM2->M2_MOEDA3 := nMoeda3 
   SM2->M2_MOEDA4 := nMoeda4 
   SM2->M2_MOEDA5 := nMoeda5 
   SM2->M2_MOEDA6 := nMoeda6 
   SM2->M2_MOEDA7 := nMoeda7 
   SM2->M2_MOEDA8 := nMoeda8 
   MsUnlock()
Endif      
RETURN .T.
