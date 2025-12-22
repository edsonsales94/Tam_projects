#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "JPEG.CH"   


User Function RESTR20C()

SetPrvt("CPERG,_CPORTA,CINDEXSB1,DINDEXSB1,CCONDICAO,_SALIAS")
SetPrvt("AREGS,I,J,")

/*
-----------------------------------------------------------------------------
|  rdmake    | restr20c  | Autor | Rogerio Batista      | Data | 14.08.19   |
-----------------------------------------------------------------------------
|  Descricao | Rotina de impressao de etiquetas de PI com codigo de Barras  |
|            | COM LOGOTIPO                                   		        |
-----------------------------------------------------------------------------
|  ALTERADO:                                                                |
-----------------------------------------------------------------------------

MV_PAR01 = Produto De  
MV_PAR02 = Produto Até 
MV_PAR03 = Tipo
MV_PAR04 = Quantidade
MV_PAR05 = Impressora    
MV_PAR06 = Localizacao
*/

Private cPerg := "RESTR20C"  // Nome da Pergunte

IF ! Pergunte(cPerg,.T.)               // Pergunta no SX1
	Return
Endif    

Processa({|| _EtiQC() })


Return

//-----------------------------------------------------------------------------

Static Function _EtiQC()

Local nColI   := mv_par07

cIndexSB1 := CriaTrab(nil,.f.)
DbSelectArea("SB1")
dIndexSB1 :="B1_COD"
cCondicao :="B1_FILIAL = '"+xFilial("SB1")+"' .AND. "   
cCondicao := cCondicao + 'B1_COD >= "'+ mv_par01 +'"  .AND. B1_COD <= "'+ mv_par02 +'" .AND. B1_TIPO == "'+ mv_par03 +'"' 

//cCondicao := cCondicao + 'B1_TIPO = "'+ mv_par03 +'" .AND. "

IndRegua("SB1",cIndexSB1,dIndexSB1,,cCondicao,"Selecionando Produtos..." )
SB1->(DBGoTop())

 ProcRegua(SB1->(RecCount()))

While  ! SB1->(eof())  
_cImprime:= .t.
/*
dbselectarea("SB2")
dbSetOrder(1)       
If dbSeek(xfilial("SB2")+SB1->B1_COD+"02")
   If SB2->B2_QATU <= 0
    _cImprime:= .f.
   EndIf
EndIf
*/
If _cImprime 	            

_cCod    :=	ALLTRIM(SB1->B1_COD)
_cDescri :=	LEFT(SB1->B1_DESC,40) 
	 
_cCod1    := STRTRAN(_cCod,"_"," ")  	                             
_cDescri1 := STRTRAN(_cDescri,"_"," ") 

IncProc("Imprimindo Etiqueta...")
	
IF ( mv_par05==1 ) 
	MSCBPRINTER("S600","LPT1",,,.f.,,,,)
	MSCBCHKSTATUS(.F.)
	
	MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL-L3T.GRF")
 
	
	MSCBBEGIN(MV_PAR04,4) 
	MSCBWRITE("^LH08,16^FS")
	MSCBGRAFIC(nColI+1.0,0.30,"COEL-L3T")   //1.0,0.25   (+3.0)                                                  //LOGOTIPO 
	
	MSCBSAY(nColI+1.0,12.85,"CODIGO: "+_cCod1,"P","D","46,10")     //"P","D","46,10")
	MSCBSAY(nColI+1.0,20.85,"DESCR: "+_cDescri1,"P","D","40,06")   //"P","D","40,06")
	MSCBLINEH(nColI+1.0,25.85,65,3)
	MSCBSAY(nColI+1.0,28.45,"QTY.: ","P","D","46,04")
	MSCBLINEH(nColI+1.0,36.55,65,3)
	
	MSCBSAY(nColI+1.0,40.55,"LOCACAO: "+iif(Empty(mv_par06),LEFT(SB1->B1_CLNOVO,15),mv_par06),"P","D","46,10")
	MSCBLINEH(nColI+1.0,49.05,65,3)
	MSCBSAYBAR(nColI+1.0,52.40,ALLTRIM(SB1->B1_COD),"N","C",8,.f.,.t.,.f.,,2,1,.F.)  //C
	
ELSE 
	MSCBPRINTER("SM400","LPT1",,,.f.,,,,)
	MSCBCHKSTATUS(.F.)               
	
	MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL-L3T.GRF")
		
	MSCBBEGIN(MV_PAR04,4) 
	MSCBWRITE("^LH08,16^FS")
	MSCBGRAFIC(nColI+1.0,0.30,"COEL-L3T")   //1.0,0.25   (+3.0)                                                  //LOGOTIPO 
	
	MSCBSAY(nColI+1.5,17.00,"CODIGO: "+_cCod1,"N","B","40,18")     //"P","D","40,06")
	MSCBSAY(nColI+1.5,32.00,"MODELO:"+_cDescri1,"N","B","40,20")   //"P","D","40,06")
	MSCBLINEH(nColI+1.5,47.00,65,3)
	MSCBSAY(nColI+1.5,51.00,"QTY.: ","N","B","46,20")
	MSCBLINEH(nColI+1.5,66.00,65,3)
	
	MSCBSAY(nColI+1.5,75.00,"LOCACAO: "+iif(Empty(mv_par06),LEFT(SB1->B1_CLNOVO,15),mv_par06),"P","D","46,20")
	MSCBLINEH(nColI+1.5,88.00,65,3)
	MSCBSAYBAR(nColI+10.0,98.00,ALLTRIM(SB1->B1_COD),"N","C",16,.f.,.t.,.f.,,3,2,.F.)    //40 
ENDIF

MSCBEND()
MSCBClosePrinter()
EndIf
SB1->(DbSkip())
End
MSCBCLOSEPRINTER()

dbSelectArea("SB1")
RetIndex("SB1")
Ferase(cIndexSB1+OrdBagExt())
Return


Return(_lRet)               


