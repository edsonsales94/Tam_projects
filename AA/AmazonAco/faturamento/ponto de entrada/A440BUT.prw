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

User Function A440BUT()
 Local aBotao :={} 

  SetKey( 9 ,  {||U_fwInvDI()} )
  AAdd(aBotao,{"BPMSRECI",{||U_fwObserv()},"Observações","Observações"})    
  aadd(aBotao,{"POSCLI"  ,{|| If(M->C5_TIPO=="N".And.!Empty(M->C5_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Cliente","Cliente" }) 	//"Posi‡„o de Cliente"

Return aBotao  

//***************************************************************************************************************************

User Function fwObserv()
 Private mInf1	:= M->C5_OBSENT1
 Private mInf2	:= M->C5_OBSENT2
//mInf3	:= M->C5_XOBS3

@ 96,100 To 300,550 Dialog oMen Title "Observações Pedido de Venda " + M->C5_NUM

@ 010,010 Say "Obs. Ent. 1: "
@ 010,045 Get mInf1 Size 147,90  WHEN .F.


@ 025,010 Say "Obs. Ent. 2: "
@ 025,045 Get mInf2 Size 147,90 

@ 050,180 BmpButton Type 1 Action (fSalva(),oMen:End())
Activate Dialog oMen

Return


//***************************************************************************************************************************
Static Function fSalva()

 RecLock("SC7",.F.)
  M->C5_OBSENT1	:= mInf1
  M->C5_OBSENT2	:= mInf2  
 SC7->(MsunLock())

Return Nil 

/*----------------------------------------------------------------------------------||
||       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||      AAAA       LL         LL         EE         CC        KK    KK   SS         ||
||     AA  AA      LL         LL         EE        CC         KK  KK     SS         ||
||    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   ||
||   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  ||
||  AA        AA   LL         LL         EE         CC        KK    KK          SS  ||
|| AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||----------------------------------------------------------------------------------*/