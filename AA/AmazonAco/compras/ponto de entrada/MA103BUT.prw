#INCLUDE "rwmake.ch"
#include "Protheus.ch"  
#INCLUDE "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MA103BUT   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 28/08/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para inclusão de botão na rotina de pré-nota ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ (Cont.)   ¦ de entrada.                                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function MA103BUT()
 Local aBotao :={} 

  SetKey( 9 ,  {||U_fwInvDI()} )
  AAdd(aBotao,{"BPMSRECI",{||U_fwInvDI()},"Invoice/DI","Invoice/DI"})  

Return aBotao  

//***************************************************************************************************************************

User Function fwInvDI()
  Local oInvoice := nil  
  Local oDI      := Nil  
  Local oHawb    := Nil  
  Local nPosDI   := aScan(aHeader, {|x| Alltrim(x[2]) == "D1_XDI"})  
  Local nPosInv  := aScan(aHeader, {|x| Alltrim(x[2]) == "D1_XINVOIC"})  
  Local nPosHawb := aScan(aHeader, {|x| Alltrim(x[2]) == "D1_XHAWB"})  
  Local cInvoice := aCols[1,nPosInv]  
  Local cDI      := aCols[1,nPosDI]
  Local cHawb    := aCols[1,nPosHawb]
   
  @00,00 TO 200,350 DIALOG oDlg TITLE "Informações Notas Importação"
 
  @10, 010 Say "Invoice :" Size 35,80 Of oDlg Pixel   //Font oFnt3
  @10, 060 GET cInvoice    Size 90,20 PICTURE "@!" OBJECT oInvoice
 
  @25, 010 Say "D.I. :"    Size 35,08 Of oDlg Pixel   //Font oFnt3 
  @25, 060 GET cDI         Size 90,20 PICTURE "@!" OBJECT oDI

  @40, 010 Say "HAWB :"    Size 35,08 Of oDlg Pixel   //Font oFnt3 
  @40, 060 GET cHawb       Size 90,20 PICTURE "@!" OBJECT oHawb
  
  @60,050 BMPBUTTON TYPE 1 ACTION fGravar(oDlg,cInvoice,nPosInv, cDI, nPosDI, cHawb, nPosHawb)
  @60,080 BMPBUTTON TYPE 2 ACTION Close(oDlg)

  ACTIVATE DIALOG oDlg CENTERED

Return

//***************************************************************************************************************************

Static function fGravar(oDlg,cInvoice,nPosInv, cDI, nPosDI, cHawb, nPosHawb)
  Local x  
  Close(oDlg)
  For x := 1 to Len(aCols)
    aCols[x,nPosInv]  := cInvoice
    aCols[x,nPosDI]   := cDI
    aCols[x,nPosHawb] := cHawb
  Next    
return
