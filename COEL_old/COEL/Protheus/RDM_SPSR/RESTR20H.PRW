#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "JPEG.CH"   


User Function RESTR20H()

SetPrvt("CPERG,_CPORTA,CINDEXSB1,DINDEXSB1,CCONDICAO,_SALIAS")
SetPrvt("AREGS,I,J,")

/*
-----------------------------------------------------------------------------
|  rdmake    | restr20H  | Autor | ROGERIO OLIVEIRA     | Data | 12.11.21   |
-----------------------------------------------------------------------------
|  Descricao | Rotina de impressao de etiquetas com codigo de Barras        |
|            | COM LOGOTIPO - SEM AMARRAR A OP                 		        |
-----------------------------------------------------------------------------
|  ALTERADO: SOLICITACAO DO SERGIO                                          |
-----------------------------------------------------------------------------

MV_PAR01 = CODIGO DO PRODUTO,C,15
MV_PAR02 = QUANTIDADE DE ETIQUETAS,N
MV_PAR03 = ORDEM DE PRODUCAO,C,11
MV_PAR04 = PORTA DE IMPRESSORA
*/

Private cPerg := "RESTR20H"  // Nome da Pergunte

	IF ! Pergunte(cPerg,.T.)               // Pergunta no SX1
		Return
	Endif
                            
	Processa({|| _EtiQC() })

Return

//-----------------------------------------------------------------------------

Static Function _EtiQC()

Local	_cData1:= DTOS(dDatabase)

///
_cDesc  := IIF(RTRIM(SB1->B1_COD)=="NI35HB--P----" , "CONTROLE NIVEL ELETR.NI35*94...240VCA*BOMBA* ",IIF(!EMPTY(SB1->B1_X_DESCC), SB1->B1_X_DESCC , SB1->B1_DESC ) )         ///Carlos: 01/11/2012 - ATE DEFINIR CAMPO NO CAD.

_cDesc  := IIF(RTRIM(SB1->B1_COD)=="NI35HR--P----" , "CONTROLE NIVEL ELETR.NI35*94...240VCA*RESERVATORIO* ",_cDesc)        ///Carlos: 01/11/2012 - ATE DEFINIR CAMPO NO CAD.

_cData1 := Substr(_cData1,5,2)+Substr(_cData1,3,2)

If  mv_par04 == 1
	MSCBPRINTER("S600","LPT1",,,.f.,,,,)
Else
	MSCBPRINTER("S300","COM1:9600,N,8,0",Nil,42) //Seta tipo de impressora no padrao ZPL  42
EndIf

MSCBCHKStatus(.f.)
MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL.GRF")

MSCBBEGIN(mv_par02/2,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
MSCBWRITE("^LH08,16^FS")


//1a. COLUNA                                           `
MSCBGRAFIC(0.5,0.5,"COEL")   //3.0                                                                    //LOGOTIPO
MSCBSAY(9.5,0.5,SUBSTR(ALLTRIM(_cDesc),1,25),"P","D","18,10")//0.75   12                                  //DESCRICAO1 DO PRODUTO
MSCBSAY(9.5,3.3,SUBSTR(ALLTRIM(_cDesc),26,25),"P","D","18,10")//0.75  12                                   //DESCRICAO2 DO PRODUTO
MSCBSAY(0.5,6.1,SUBSTR(ALLTRIM(_cDesc),51,30),"P","D","18,10")//0.75  12                                   //DESCRICAO2 DO PRODUTO
MSCBSAY(0.5,8.9,SUBSTR(ALLTRIM(_cDesc),81,30),"P","D","18,10")//0.75  12                                   //DESCRICAO2 DO PRODUTO

MSCBSAY(0.5,11.3,alltrim(MV_PAR01),"N","D","18,10")//7   3.0                                       //CODIGO DO PRODUTO CHUMBADO P TESTE
MSCBSAY(33.5,11.3,alltrim(MV_PAR03),"N","D","18,10")//7     30                                      //NUMERO DA OP CHUMBADO P TESTE
MSCBSAYBAR(1.5,15.55,AllTrim("7895113" + ALLTRIM(SB1->B1_CODBAR)),"N","E",6,.f.,.t.,.f.,,2,1,.F.)   //4
MSCBSAYBAR(27.5,15.55,alltrim(_cData1),"N","C",6,.f.,.t.,.f.,,2,1,.F.) //30  //monta codigo de barras 9,25CHUMBADO P TESTE

//2a. COLUNA
MSCBGRAFIC(50.0,0.5,"COEL")    //53                                                                    //LOGOTIPO
MSCBSAY(59.0,0.5,SUBSTR(ALLTRIM(_cDesc),1,25),"P","D","18,10")//0.75      62                               //DESCRICAO1 DO PRODUTO
MSCBSAY(59.0,3.3,SUBSTR(ALLTRIM(_cDesc),26,25),"P","D","18,10")//0.75     62                                //DESCRICAO2 DO PRODUTO
MSCBSAY(50.0,6.1,SUBSTR(ALLTRIM(_cDesc),51,30),"P","D","18,10")//0.75     62                                //DESCRICAO2 DO PRODUTO
MSCBSAY(50.0,8.9,SUBSTR(ALLTRIM(_cDesc),81,30),"P","D","18,10")//0.75     62                                //DESCRICAO2 DO PRODUTO

MSCBSAY(50.0,11.3,alltrim(MV_PAR01),"N","D","18,10")//7      53                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
MSCBSAY(83.0,11.3,alltrim(MV_PAR03),"N","D","18,10")//7    80                                       //NUMERO DA OP CHUMBADO P TESTE
MSCBSAYBAR(52.0,15.55,AllTrim("7895113" + ALLTRIM(SB1->B1_CODBAR)),"N","E",6,.f.,.t.,.f.,,2,1,.F.)   //55
MSCBSAYBAR(78.0,15.55,alltrim(_cData1),"N","C",6,.f.,.t.,.f.,,2,1,.F.) //81  //monta codigo de barras 9,25CHUMBADO P TESTE

MSCBEND() //Fim da Imagem da Etiqueta
MSCBClosePrinter()
		
Return

