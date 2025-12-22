#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "JPEG.CH"   


User Function RESTR20F()

SetPrvt("CPERG,_CPORTA,CINDEXSB1,DINDEXSB1,CCONDICAO,_SALIAS")
SetPrvt("AREGS,I,J,")

/*
-----------------------------------------------------------------------------
|  rdmake    | restr20F  | Autor | ROGERIO OLIVEIRA     | Data | 22.04.21   |
-----------------------------------------------------------------------------
|  Descricao | Rotina de impressao de etiquetas com codigo de Barras        |
|            | COM LOGOTIPO                                   		        |
-----------------------------------------------------------------------------
|  ALTERADO:                                                                |
-----------------------------------------------------------------------------

MV_PAR01 = CODIGO DO PRODUTO,C,15
MV_PAR02 = QUANTIDADE DE ETIQUETAS,N
MV_PAR03 = NUMERO DA OP,C,6
MV_PAR04 = ITEM DA OP
MV_PAR05 = PORTA DA IMPRESSORA,N,1
*/

Private cPerg := "RESTR20F"  // Nome da Pergunte

/*IF ( M->cNumEmp == "0301" )
	f_etqmanaus()                          ///Carlos: 09/04/2015
ELSE*/
	IF ! Pergunte(cPerg,.T.)               // Pergunta no SX1
		Return
	Endif
                            
	Processa({|| _EtiQC() })
//ENDIF

Return

//-----------------------------------------------------------------------------

Static Function _EtiQC()

Local nColI   := 10

//cIndexSB1 := CriaTrab(nil,.f.)
DbSelectArea("SF2")
dbSetOrder(1)
If dbSeek(xfilial("SF2")+MV_PAR01+MV_PAR02)

//While  ! SF2->(eof()) .AND. SF2->F2_DOC+SF2->F2_SERIE==MV_PAR01+MV_PAR02
	
	IncProc("Imprimindo Etiqueta...")
	
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xfilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA))

IF ( mv_par05==1 ) 
	MSCBPRINTER("S600","LPT1",,,.f.,,,,)
	MSCBCHKSTATUS(.F.)
	
	MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL-L3T.GRF")
 
	
	MSCBBEGIN(1,4) 
	MSCBWRITE("^LH08,16^FS")
	MSCBGRAFIC(nColI+2.0,0.30,"COEL-L3T")   //1.0,0.25   (+3.0)                                                  //LOGOTIPO 
	
	MSCBSAY(nColI+2.0,12.85,"NOTA FISCAL: "+mv_par01+" "+mv_par02,"P","D","46,10")     //"P","D","46,10")
	MSCBSAY(nColI+2.0,20.85,"COMERCIAL/INVOICE: "+mv_par03,"P","D","40,06")   //"P","D","40,06")
	//MSCBLINEH(nColI+2.0,25.85,65,3)
	MSCBSAY(nColI+2.0,28.45,"QTY.VOLUME:    "+MV_PAR04,"P","D","46,04")
	//MSCBLINEH(nColI+2.0,36.55,65,3)
	
	MSCBSAY(nColI+2.0,40.55,"CUSTOMER/CLIENTE: "+SA1->A1_NREDUZ,"P","D","46,10")
	//MSCBLINEH(nColI+2.0,49.05,65,3)
	MSCBSAY(nColI+2.0,52.40,"COUNTRY/PAIS: "+SA1->A1_MUN,"P","D","46,10")  
	
ELSE 
	MSCBPRINTER("SM400","LPT1",,,.f.,,,,)
	MSCBCHKSTATUS(.F.)               
	
	MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL-L3T.GRF")
		
	MSCBBEGIN(1,2) 
	MSCBWRITE("^LH08,16^FS")
	MSCBGRAFIC(nColI+1,0.30,"COEL-L3T")   //1.0,0.25   (+3.0)                                                  //LOGOTIPO 
	
    MSCBSAY(nColI+1,25.00,"NOTA FISCAL: "+mv_par01+" "+mv_par02,"N","B","40,18")     //"P","D","46,10")
	MSCBSAY(nColI+1,45.00,"COMERCIAL/INVOICE: "+mv_par03,"N","B","40,20")   //"P","D","40,06")
	//MSCBLINEH(nColI+4,40.00,65,3)
	MSCBSAY(nColI+1,65.00,"QTY.VOLUME:  "+MV_PAR04,"N","B","46,20")
	//MSCBLINEH(nColI+4,53.00,65,3)
	
	MSCBSAY(nColI+1,85.00,"CUSTOMER/CLIENTE: "+SA1->A1_NREDUZ,"N","B","46,20")
	//MSCBLINEH(nColI+4,65.00,65,3)
	MSCBSAY(nColI+1,105.00,"COUNTRY/PAIS: "+SA1->A1_MUN,"N","B","46,20")
ENDIF
/*
    MSCBSAY(nColI+1.5,17.00,"CODIGO: "+_cCod1,"N","B","40,18")     //"P","D","40,06")
	MSCBSAY(nColI+1.5,32.00,"MODELO:"+_cDescri1,"N","B","40,20")   //"P","D","40,06")
	MSCBLINEH(nColI+1.5,47.00,65,3)
	MSCBSAY(nColI+1.5,51.00,"QTY.: ","N","B","46,20")
	MSCBLINEH(nColI+1.5,66.00,65,3)
	
	MSCBSAY(nColI+1.5,75.00,"LOCACAO: "+iif(Empty(mv_par06),LEFT(SB1->B1_CLNOVO,15),mv_par06),"P","D","46,20")
	MSCBLINEH(nColI+1.5,88.00,65,3)
	MSCBSAYBAR(nColI+40.0,98.00,ALLTRIM(SB1->B1_COD),"N","C",16,.f.,.t.,.f.,,3,2,.F.)    //16
*/
MSCBEND()
MSCBClosePrinter() 
Endif
//MSCBCLOSEPRINTER()

Return
