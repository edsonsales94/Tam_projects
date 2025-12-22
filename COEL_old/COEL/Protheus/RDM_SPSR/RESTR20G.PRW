#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "JPEG.CH"   


User Function RESTR20G()

SetPrvt("CPERG,_CPORTA,CINDEXSB1,DINDEXSB1,CCONDICAO,_SALIAS")
SetPrvt("AREGS,I,J,")

/*
-----------------------------------------------------------------------------
|  rdmake    | restr20  | Autor | FERNANDO AMORIM       | Data | 25.11.10   |
-----------------------------------------------------------------------------
|  Descricao | Rotina de impressao de etiquetas com codigo de Barras        |
|            | COM LOGOTIPO                                   		        |
-----------------------------------------------------------------------------
|  ALTERADO:                                                                |
-----------------------------------------------------------------------------

MV_PAR01 = CODIGO DO PRODUTO,C,15
MV_PAR02 = QUANTIDADE DE ETIQUETAS,N
MV_PAR03 = FORNECEDOR,C,20
MV_PAR04 = DI/NF,C,20
MV_PAR05 = DATA
MV_PAR06 = PORTA DA IMPRESSORA,N,1
*/

Private cPerg := "RESTR20G"  // Nome da Pergunte

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

cIndexSB1 := CriaTrab(nil,.f.)
DbSelectArea("SB1")
dIndexSB1 :="B1_COD"
cCondicao :="B1_FILIAL = '"+xFilial("SB1")+"' .AND. "
cCondicao := cCondicao + 'B1_COD     == "'+ mv_par01 +'" '

IndRegua("SB1",cIndexSB1,dIndexSB1,,cCondicao,"Selecionando Produtos..." )
SB1->(DBGoTop())

If  mv_par06 == 1
	MSCBPRINTER("S600","LPT1",,,.f.,,,,)
ElseIf mv_par06 == 2
	MSCBPRINTER("S300","COM1:9600,N,8,0",Nil,42) //Seta tipo de impressora no padrao ZPL  42
EndIf

MSCBCHKStatus(.f.)
//MSCBLOADGRF("LOGO.GRF") //Carrega o logotipo para impressora
MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL.GRF")
//Seta Impressora (Zebra)

ProcRegua(SB1->(RecCount()))

While  ! SB1->(eof())
	
	IncProc("Imprimindo Etiqueta...")
	
	_cData1:= DTOS(dDatabase)
	_cData1:= Substr(_cData1,5,2)+Substr(_cData1,3,2)

	If  mv_par06 == 1  //ZEBRA Z4
	
		_dData := mv_par05
		 
		MSCBBEGIN(mv_par02/2,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
		MSCBWRITE("^LH08,16^FS")
	   
		//MSCBGRAFIC(0.8,0.5,"COEL") //COLOQUEI O LOGO EM SP ANDRE 22/07/16 
		//MSCBSAY(9.5,0.5,","P","D","18,10")//0.75   12  
		//1a. COLUNA                                           `
		MSCBSAY(1.1,0.01,"Cod.: "+alltrim(MV_PAR01),"N","B","17")//DESCRICAO
		MSCBSAY(1.1,4.01, "Forn.: "+alltrim(MV_PAR03),"N","B","16.8")//7   3.0                                       //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(1.1,8.01,"NF/DI: "+alltrim(MV_PAR04),"N","B","16.8")//7     30                                      //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAY(1.1,12.01,"Data: "+_dData,"N","B","16.8")//7  3.0            //MES:ANO
		MSCBSAY(1.1,15.15,"Local: "+alltrim(SB1->B1_CLNOVO),"N","B","16.8")//7  3.0            //MES:ANO
		MSCBSAYBAR(10,18,ALLTRIM(SB1->B1_COD),"N","C",6,.f.,.f.,.f.,,2,1,.F.)   //4
		
		//2a. COLUNA

		//MSCBGRAFIC(52.0,0.5,"COEL")    //53
		//MSCBGRAFIC(0.510.5,"COEL") //COLOQUEI O LOGO EM SP ANDRE 22/07/16
		MSCBSAY(50.5,0.01,"Cod.: "+alltrim(MV_PAR01),"N","B","17")//0.75     62                                //DESCRICAO2 DO PRODUTO
		MSCBSAY(50.5,4.01, "Forn.: "+alltrim(MV_PAR03),"N","B","16.8")//7      53                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(50.5,8.01,"NF/DI: "+alltrim(MV_PAR04),"N","B","16.8")//7    80                                       //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAY(50.5,12.01,"Data: "+_dData,"N","B","16.8")//7  3.0            //MES:ANO
		MSCBSAY(50.5,15.15,"Local: "+alltrim(SB1->B1_CLNOVO),"N","B","16.8")//7  3.0            //MES:ANO
		MSCBSAYBAR(60,18,ALLTRIM(SB1->B1_COD),"N","C",6,.f.,.f.,.f.,,2,1,.F.)   //55
		
		MSCBEND() //Fim da Imagem da Etiqueta
		
	Else
		MSGBOX("PARAMETRO NÃO PERMITIDO")
	EndIf
	
	SB1->(DbSkip())
End
//MSCBCLOSEPRINTER()

dbSelectArea("SB1")
RetIndex("SB1")
Ferase(cIndexSB1+OrdBagExt())
Return

