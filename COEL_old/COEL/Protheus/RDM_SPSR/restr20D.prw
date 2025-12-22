#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "JPEG.CH"   


User Function RESTR20D()

SetPrvt("CPERG,_CPORTA,CINDEXSB1,DINDEXSB1,CCONDICAO,_SALIAS")
SetPrvt("AREGS,I,J,")

/*
-----------------------------------------------------------------------------
|  rdmake    | restr20D  | Autor | FERNANDO AMORIM       | Data | 25.11.10  |
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

Private cPerg := "RESTR20"  // Nome da Pergunte

	IF ! Pergunte(cPerg,.T.)               // Pergunta no SX1
		Return
	Endif

	Processa({|| _EtiQC() })


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

If  mv_par05 == 1
	MSCBPRINTER("S600","LPT1",,,.f.,,,,)
ElseIf mv_par05 == 2
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
	*94...240VCA*RESERVATORIO*
	_cDesc := IIF(RTRIM(SB1->B1_COD)=="NI35HB--P----" , "CONTROLE NIVEL ELETR.NI35*94...240VCA*BOMBA* ",IIF(!EMPTY(SB1->B1_X_DESCC),SB1->B1_X_DESCC,SB1->B1_DESC))         ///Carlos: 01/11/2012 - ATE DEFINIR CAMPO NO CAD.
	_cDesc := IIF(RTRIM(SB1->B1_COD)=="NI35HR--P----" , "CONTROLE NIVEL ELETR.NI35*94...240VCA*RESERVATORIO* ",_cDesc)        ///Carlos: 01/11/2012 - ATE DEFINIR CAMPO NO CAD.
	
	If  mv_par05 == 1  //ZEBRA Z4
	
		 If mv_par06 == 2
			 _cDesc := mv_par07
		 EndIf
		 
		 If mv_par08 == 2
			_dData := mv_par09
		 Else
			_dData := alltrim(STR(Month(dDataBase)))+ "/" + ALLTRIM(STR(YEAR(dDataBase)))
		 EndIf  
		 
		MSCBBEGIN(mv_par02/2,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
		MSCBWRITE("^LH08,16^FS")
	   
		MSCBGRAFIC(0.8,0.5,"COEL") //COLOQUEI O LOGO EM SP ANDRE 22/07/16 
		//MSCBSAY(9.5,0.5,","P","D","18,10")//0.75   12  
		//1a. COLUNA      
		MSCBSAY(9.5,2.5,SUBSTR(ALLTRIM(_cDesc),1,25),"N","B","19,10")//0.75   12                                  //DESCRICAO1 DO PRODUTO
        MSCBSAY(0.4,6.55,SUBSTR(ALLTRIM(_cDesc),26,35),"N","B","19,10")//0.75  12                                     `
//		MSCBSAY(0.4,6.55,SUBSTR(ALLTRIM(_cDesc),1,40),"N","B","19,10")//DESCRICAO
		MSCBSAY(0.4,10.55, alltrim(MV_PAR01),"N","B","18,10")//7   3.0                                       //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(0.4,14.55,alltrim(MV_PAR03+"/"+MV_PAR04),"N","B","18,10")//7     30                                      //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAY(0.4,18.55,_dData,"N","B","18,10")//7  3.0            //MES:ANO
		MSCBSAYBAR(15,14.75,AllTrim("7895113" + ALLTRIM(SB1->B1_CODBAR)),"N","E",6,.f.,.t.,.f.,,2,1,.F.)   //4
		
		//2a. COLUNA

		MSCBGRAFIC(50.0,0.5,"COEL")    //53
		MSCBSAY(60.5,2.5,SUBSTR(ALLTRIM(_cDesc),1,25),"N","B","19,10")//0.75   12                                  //DESCRICAO1 DO PRODUTO
        MSCBSAY(50.0,6.55,SUBSTR(ALLTRIM(_cDesc),26,35),"N","B","19,10")//0.75  12 
//		MSCBSAY(50.0,6.55,SUBSTR(ALLTRIM(_cDesc),1,40),"N","B","18,10")//0.75     62                                //DESCRICAO2 DO PRODUTO
		MSCBSAY(50.0,10.55, alltrim(MV_PAR01),"N","B","18,10")//7      53                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(50.0,14.55,alltrim(MV_PAR03+"/"+MV_PAR04),"N","B","18,10")//7    80                                       //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAY(50.0,18.55,_dData,"N","B","18,10")//7  3.0            //MES:ANO
		MSCBSAYBAR(65,14.55,AllTrim("7895113" + ALLTRIM(SB1->B1_CODBAR)),"N","E",6,.f.,.t.,.f.,,2,1,.F.)   //55
		
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

