#include "rwmake.ch"
//#include "Protheus.ch" 

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INFINP01   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 25/04/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para atualizaçãos dos parametros de fechamentos        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/          
  
User Function INCTBA01()//INFINP01()

  Local dDatIO, dDatFin

  dDatIO  := getmv("MV_ULMES") 
  dDatFin := getmv("MV_DATAFIN") 
  @00,00 TO 120,350 DIALOG oDlg TITLE "Ajustes Fechamentos"

  @10, 001 SAY "Fechamento Entrada/saida:"
  @10, 085 GET dDatIO SIZE 40,20 PICTURE "@!" OBJECT odDatIO

  @25, 001 SAY "Fechamento Financeiro:
  @25, 085 GET dDatFin SIZE 40,20 PICTURE "@!" OBJECT odDatFin
  
  @40,050 BMPBUTTON TYPE 1 ACTION GrvDataEntrega(oDlg,dDatIO,dDatFin)
  @40,080 BMPBUTTON TYPE 2 ACTION Close(oDlg)

  ACTIVATE DIALOG oDlg CENTERED

return

//////////////////////////////////////////////////
Static function GrvDataEntrega(oDlg,dDatIO,dDatFin)
  
  PutMv("MV_ULMES",dDatIO) 
  PutMv("MV_DATAFIN",dDatFin)  
  
  Close(oDlg)
  
return                                                                                 
