#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ orçfat   ³ Autor ³ ROGERIO OLIVEIRA      ³ Data ³ 20/03128 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Emissão da OP                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ 03/04/14 - Impressao da folha anexa do Controle de OP      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function OP_grafica()

SetPrvt("TITULO,CSTRING,WNREL,CDESC,AORD,TAMANHO")
SetPrvt("ARETURN,CPERG,NLASTKEY,CBCONT,NQUANTITEM,CABEC1")
SetPrvt("COP,CDESCRI,CABEC2,LIMITE,NQUANT,NOMEPROG")
SetPrvt("NTIPO,CPRODUTO,CQTD,CINDSC2,NINDSC2,AARRAY")
SetPrvt("LI,CBTXT,M_PAG,LEND,OPR,I")
SetPrvt("NBEGIN,CCABEC1,CCABEC2,CCABEC3,LSH8,NLARGURA")
SetPrvt("J,L,K,NCARAC,CTEXTO,CESC")
SetPrvt("CCODE,NLIMITE,NIMP,NBORDA,NLIN,AV0")
SetPrvt("AV1,AIMP,CNUMOP,AARRAYPRO,LIMPITEM,NCNTARRAY")
SetPrvt("A01,A02,NX,NI,NL,NY")
SetPrvt("CNUM,CITEM,LIMPCAB,CDESCRI1,CDESCRI2,CCNT")
SetPrvt("AREGS,")

Private _cRecurso,_cPV
Private oPrn
Private _nPag := 1

titulo   := ""
cString  := "SC2"
wnrel    := "MATR820"
cDesc    := "Este programa ira imprimir a Relação das Ordens de Produção - COEL"
aOrd     := {"Por Numero","Por Produto","Por Centro de Custo","Por Prazo de Entrega"}
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
cPerg    := PADR("CMTR820",10)
nLastKey := 0          

//If !ChkFile("SH8",.F.)
//	Help(" ",1,"SH8EmUso")
//	Return
//Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()

if Pergunte(cPerg,.T.)

	oPrn := TMSPrinter():New(Titulo)
	oPrn:Setup()

	oPrn:SetPortrait() //Retrato
	//oPrn:SetLandscape()// Paisagem()
	//oPrn:StartPage()

	RptStatus({|| Procorc()})
	oPrn:Preview()
	oPrn:EndPage()
	oPrn:End()

endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Procorc  ³ Autor ³ FERNANDO AMORIM       ³ Data ³ 12/02/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processa impressao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Uso exclusivo SINTEQUIMICA                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Procorc()

// Definicao de fontes
oFont1 		:= TFont():New("Arial"      	  ,09,08,,.F.,,,,,.F.) //Titulos dos Campos
oFont2 		:= TFont():New("Arial"      	  ,09,10,,.F.,,,,,.F.) //Conteudo dos Campos
oFont3Bold	:= TFont():New("Arial Black"	  ,09,15,,.T.,,,,,.F.) //
oFont4 		:= TFont():New("Arial"      	  ,09,11,,.T.,,,,,.F.) //
oFont5 		:= TFont():New("Arial"      	  ,09,18,,.T.,,,,,.F.) //
oFont6 		:= TFont():New("Arial"      	  ,09,14,,.T.,,,,,.F.) //
oFont7 		:= TFont():New("Arial"           ,09,10,,.T.,,,,,.F.) //Conteudo dos Campos em Negrito
oFont8 		:= TFont():New("Arial"           ,09,09,,.F.,,,,,.F.) //Dados do Cliente
oFont9 		:= TFont():New("Times New Roman" ,09,14,,.T.,,,,,.F.) //
////
////Fontes para o Controle de OP
////
oFont08  := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont08b := TFont():New( "Arial",,08,,.t.,,,,,.f. )
oFont09  := TFont():New( "Arial",,09,,.f.,,,,,.f. )
oFont10  := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont10b := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont10b := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont11  := TFont():New( "Arial",,11,,.f.,,,,,.f. )
oFont11b := TFont():New( "Arial",,11,,.t.,,,,,.f. )
oFont12  := TFont():New( "Arial",,12,,.f.,,,,,.f. )
oFont12b := TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont12BI:= TFont():New( "Arial",,12,,.t.,,,,,.t. )
oFont16BI:= TFont():New( "Arial",,16,,.t.,,,,,.t. )
oFont24b := TFont():New( "Arial",,24,,.t.,,,,,.f. )

CbCont     := ""
nQuantItem := 0
cabec1     := ""
cOp        := ""
nQuant     := 1
nomeprog   := "OP_GRAFICA"
nTipo      := 18
cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
cQtd       := ""
cIndSC2    := CriaTrab(NIL,.F.)
nIndSC2    := 0
aArray     := {} 
LINHA      := 810
_ncont     := 0
cabec1     := ""
cabec2     := ""

dbSelectArea("SC6")
dbSetOrder(1)
*
dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2")+mv_par01)

SetRegua(LastRec())

While SC2->(!eof() .and. C2_FILIAL==xFilial("SC2").AND.(C2_NUM+C2_ITEM+C2_SEQUEN) <= ALLTRIM(mv_par02))
	_nCont := _nCont+1

	If _nCont > 1
		
		oPrn:ResetPrinter() 
		
	EndIf
	
	IF LastKEy()==27
		@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	IncRegua()
	
	If  C2_DATPRF < mv_par03 .Or. C2_DATPRF > mv_par04
		dbSkip()
		Loop
	Endif
	
	If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN < xFilial("SC2")+alltrim(mv_par01) .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN > xFilial("SC2")+alltrim(mv_par02)
		dbSkip()
		Loop
	EndIf
		
	If !(Empty(C2_DATRF)) .And. mv_par08 == 2
		dbSkip()
		Loop
	Endif
	
	//-- Valida se a OP deve ser Impressa ou n„o
	If !MtrAValOP(mv_par10, 'SC2')
		dbSkip()
		Loop
	EndIf
	
	cProduto  := SC2->C2_PRODUTO
	nQuant    := SC2->C2_QUANT//SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA//Roger
	_cPV      := SC2->C2_PEDIDO + SC2->C2_ITEMPV
	
	_aAlias := GetArea()
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+cProduto)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	AddAr820(nQuant)
	

	If mv_par07 == 1
	   _cDesc    := SB1->B1_NARRA
	Else
	   _cDesc    := SB1->B1_DESC
    EndIf	
	_cCNew    := SB1->B1_X_CNEW
	cOp       := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"   "    
   _cCodProj := ALLTRIM(SB1->B1_X_PROJ)

	MontStruc()
	
	If mv_par09 == 1
		aSort( aArray,2,, { |x, y| (x[1]+x[7]) < (y[1]+y[7]) } )
	Else
		aSort( aArray,2,, { |x, y| (x[7]+x[1]) < (y[7]+y[1]) } )
	EndIf
	
	_QtdOP     := SC2->C2_QUANT//SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA
	_cSem      := Strzero(CalcSem(SC2->C2_EMISSAO),2)
	_cUM       := aArray[1][4]
	_dDtEntrega:= DTOC(SC2->C2_DATPRF)
	_cStatus   := ""
	_cObs      := ""
	_cPedCli   := ""
	_cPedido   := SC2->C2_PEDIDO+"-"+SC2->C2_ITEMPV
	
	_codCli    := GetAdvFVal("SC5","C5_CLNOMCL",xFilial("SC5")+SC2->C2_PEDIDO,1,"")
	
	If SC2->C2_STATUS == "S"
		_cStatus:= "OP Sacram."
	ElseIf SC2->C2_STATUS == "U"
		_cStatus:= "OP Suspen."
	ElseIf Empty(SC2->C2_STATUS)
		_cStatus:= "OP Normal"
	EndIf
	
	If !(Empty(SC2->C2_OBS))
		_cObs := SC2->C2_OBS
	EndIf  
	IF ( !EMPTY(_cPedido) )
		SC6->(dbSeek(xFilial("SC6")+_cPV+SC2->C2_PRODUTO))                  ///Carlos: 17/03/2015 - a pedido do Gorini
		_cPedCli := SC6->C6_PEDCLI		
	ENDIF
	
	Cabec()
	
	//CORPO PRODUTOS
	corpo_prod()
	
	linha := 840
    
	IF ( RTRIM(_cRecurso) == "060" .AND. !EMPTY(_cPV) ) 
		_cPV := RTRIM(cOP)+"99"
		oPrn:Box(2750,1740,2750,2450)        ////2750,1740
		oPrn:Say(2710,1744,"::::::::::::::::::::::::::::::::::::::::::::::::::",oFont4,340)      ///2710,1744
      oprn:say(2768,1800,"99-EXPEDIÇÃO",oFont2,100)                   ///2768,1800
      MsBar("CODE128",24.3,15.5,_cPV,oPrn,.F.,,,0.025,0.8,.T.,,,.F.)  ///24.3,15.5
		
	ENDIF
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir Relacao de medidas para Cliente == HUNTER DOUGLAS.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	///dbSelectArea("SX3")
	///dbSetOrder(1)
	///dbSeek("SMX")
	///If Found() .And. SC2->C2_DESTINA == "P"
	///	R820Medidas()
	///EndIf
	aArray := {}

	IF ( mv_par13 == 1 )
		oPrn:ResetPrinter() 
		oPrn:EndPage()
		oPrn:StartPage()
		Impr_Anexo(cOP,cProduto,_cDesc,SC2->C2_QUANT)        ///Imprime anexo da OP (controle da ordem de producao)
	ENDIF
	
	dbSelectArea("SC2")
	dbSkip()
	//	EJECT

/* COMENTADO FELIPE
oprn:endpage()  

oPrn:ResetPrinter()  
oPrn:Refresh() 
oprn:StartPage() 
*/
EndDO

Ms_Flush()       

dbSelectArea("SH8")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ClosFile("SH8")

dbSelectArea("SC2")
If aReturn[8] == 4
	RetIndex("SC2")
	Ferase(cIndSC2+OrdBagExt())
EndIf

Return

//-------funções do usuario----------------------------//

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
Static function Cabec()

//DADOS DO CABEÇALHO
fVerifLin()

oPrn:Say(005,001,".",oFont4,100)

oPrn:Box(020,020,200,700)
oPrn:Box(020,700,200,1800)
oPrn:Box(020,1800,200,2450)

oPrn:Say(050,100,"ORDEM DE PRODUCAO N°. ",oFont4,100)
oPrn:Say(090,100,ALLTRIM(cOp),oFont5,150)

oPrn:Say(050,720,"CODIGO: ",oFont4,100)
oPrn:Say(090,720,SC2->C2_PRODUTO,oFont5,100)          

IF ( !EMPTY(_cCNew) )                            ///Codigo antigo
	oPrn:Say(0160,1630,"<"+RTRIM(_cCNew)+">",oFont1,100)          
ENDIF	

oPrn:Say(050,1850,"DATA ENTREGA: ",oFont4,100)
oPrn:Say(050,2200,TransForm(_dDtEntrega,"@D 99/99/9999"),oFont4,100)
oPrn:Say(110,1850,"Emissao: " + TransForm(SC2->C2_EMISSAO,"@D 99/99/9999"),oFont4,100)
oPrn:Say(110,2210,"PG.: " + ALLTRIM(STR(_nCont)),oFont4,100)
/*
oPrn:Box(220,020,400,700)
oPrn:Box(220,700,400,1800)
oPrn:Box(220,1800,400,2450)
*/
oPrn:Box(220,020,400,560)
oPrn:Box(220,560,400,1200)
oPrn:Box(220,1200,400,1800)
oPrn:Box(220,1800,400,2450)

oPrn:Say(250,100,"PEDIDO COEL Nº.",oFont4,100)
oPrn:Say(290,100,_cPedido,oFont5,150)
oPrn:Say(250,580,"PEDIDO CLIENTE Nº.",oFont4,100)
oPrn:Say(290,580,_cPedCli,oFont5,150)
oPrn:Say(250,1220,"COD.PROD. CLIENTE: ",oFont4,100)
oPrn:Say(290,1220,"",oFont5,100)
oPrn:Say(250,1850,"QUANTIDADE ",oFont4,100)
oPrn:Say(290,1850,TransForm(_QtdOP,"@E 9,999,999"),oFont5,100)

oPrn:Box(420,020,560,2450)
oPrn:Say(445,050,"DESC.PRODUTO: ",oFont4,100)
If Len(Alltrim(_cDesc)) > 100
	oPrn:Say(445,400,Substr(_cDesc,1,100),oFont4) 
	oPrn:Say(495,400,Substr(_cDesc,101,100),oFont4) 
Else
	oPrn:Say(445,400,_cDesc,oFont4,100)
Endif
//CLIENTE
SAORCFATS()//salva área de trabalho
dbSelectArea("SA1") //SELECIONA AREA CLIENTES
dbSetOrder(1)  //SELECIONA INDICE CODIGO/LOJA

oPrn:Box(560,020,720,1620)      ///560,020,720,1740
oPrn:Box(560,1620,720,2450)     ///560,1740,720,2450
oprn:say(565,1870,"Produto Calibragem",oFont1,100)     ///570,1930
oPrn:Say(595,050,"CLIENTE: ",oFont2,100)
oPrn:Say(595,230,_codCli,oFont2,100)          ///595,300

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
   If !Empty(SB1->B1_CLANT)
      _cCodCal:=_cCodProj+alltrim(SB1->B1_CLANT) 
   Else
      _cCodCal  :=_cCodProj+alltrim(SC2->C2_PRODUTO)
   EndIf
Else      
   _cCodCal  :=_cCodProj+alltrim(SC2->C2_PRODUTO)
EndIf

_cCodCalib:= STRTRAN(_cCodCal,"-",".")

MsBar("CODE128",5.5,14.6,alltrim(_cCodCalib),oPrn,.F.,,,0.025,0.8,.T.,,,.F.)    ///LIN, 5.5 COL, 14.30,025,0.8 -- COd barras largura5.5,15.3

//oPrn:Say(620,250,alltrim(SA1->A1_COD),oFont4,100)        //CNPJ CLIENTE
oPrn:Say(665,050,"OBS: ",oFont2,100)

oPrn:Say(665,300,_cObs,oFont4,100)  //CONTATO         

return

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
static function corpo_prod()

//DESCRIMINAÇÃO DOS PRODUTOS
oPrn:Box(740,020,800,2450)

oPrn:Box(740,020,3040,1390)
oPrn:Box(740,020,3040,0300)
oPrn:Box(740,1390,3040,1740)
oPrn:Box(740,1740,3040,2450)
oprn:say(760,050,"COMPONENTES ",oFont1,100)
oprn:say(760,700,"DESCRICAO ",oFont1,100)
oprn:say(760,1500,"QTD ",oFont1,100)
oprn:say(760,1930,"OPERACAO ",oFont1,100) 

	dbSelectArea("SD4")
	dbSetOrder(2)
	dbSeek(xFilial("SD4")+cOp)
	                                         
	While !Eof() .And. D4_FILIAL+D4_OP == xFilial("SD4")+cOp
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no produto desejado                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SD4->D4_COD)
		
		  If SD4->D4_QUANT > 0
			oPrn:Say(Linha,045,SD4->D4_COD,oFont2,100)
			oPrn:Say(Linha,350,subs(SB1->B1_DESC,1,50),oFont2,100)
			oPrn:say(Linha,1420,TransForm(SD4->D4_QUANT,"@E 9,999,999.99"),oFont2,100)                                        // CODIGO PRODUTO
		  Else
		    oPrn:Say(Linha,045,SD4->D4_COD,oFont2,100)
		    oPrn:Say(Linha,350,"REIMPRESSAO- "+subs(SB1->B1_DESC,1,40),oFont2,100)
		    oPrn:say(Linha,1420,TransForm(SD4->D4_QTDEORI,"@E 9,999,999.99"),oFont2,100)                                        // CODIGO PRODUTO
		  Endif
		
		dbSelectArea("SD4")
		dbSkip()
		Linha:=Linha+40      
		
	Enddo
	
	_cRecurso := " "
	If mv_par05 == 1

 		RotOper()       // IMPRIME ROTEIRO DAS OPERACOES
		
   EndIf
                                             
      
return

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
static function rodape()
//COND PAGTO
oPrn:Box(2340,020,2410,2460)
oPrn:Say(2360,050,"Condição de pagamento: ",oFont4,100 )  //COND PAG
dbSelectArea("SE4") //SELECIONA AREA
dbSetOrder(1)  //SELECIONA INDICE
dbSeek(xFilial()+SCJ->CJ_CONDPAG,.T.)
oPrn:Say(2360,750,ALLTRIM(SE4->E4_DESCRI),oFont4,100 )  //COND PAG
oPrn:Say(2360,1250,".",oFont4,100 )  //COND PAG
dbSelectArea("SCK")

//OBS
oPrn:Box(2430,020,2600,2460)
oPrn:Say(2450,050,"Observações:",oFont2,100 )  //obs
IF LEN(ALLTRIM(SCJ->CJ_OBSFINA)) > 100
	oPrn:Say(2480,050,SUBSTR(ALLTRIM(SCJ->CJ_OBSFINA),1,100),oFont2,100 )  //obs
	oPrn:Say(2510,050,SUBSTR(ALLTRIM(SCJ->CJ_OBSFINA),101,99),oFont2,100 )  //obs
ELSE
	oPrn:Say(2480,050,ALLTRIM(SCJ->CJ_OBSFINA),oFont2,100 )  //obs
ENDIF

// VENDEDOR
oPrn:Box(2620,020,2750,2460)
dbSelectArea("SA3") //SELECIONA VENDEDOR
dbSetOrder(1)  //SELECIONA INDICE FILIAL/CODIGO
dbSeek(xFilial()+SA1->A1_VEND, .T.)
oprn:say(2640,050,"VENDEDOR: ",oFont2,100)
oprn:say(2640,0350,ALLTRIM(SA3->A3_NREDUZ),oFont4,100) //NOME VEND
oprn:say(2690,050,"Operador:",oFont2,100)
oprn:say(2690,350,SUBSTR(cusuario,7,15),oFont4,100)
RAORCFATS()//restaura área de trabalho

//RODAPE
oPrn:Box(2770,020,3150,2460)
IF File("LGRL01.bmp")
	oPrn:SayBitmap( 2790,1000,"LGRL01.bmp",300, 300 )
ENDIF
If SM0->M0_CODIGO == "03"
oPrn:Say(3100,450,"Sistema da Qualidade e Ambiental certificado segundo normas ISO 9001:2015 e ISO 14001:2004",oFont2,100 )  //obs
EndIf
return
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function SAORCFATS()   // salva a area atual
_cALIAS := Alias()
_cRECNO := Recno()
_cORDEM := IndexOrd()
Return()

Static Function RAORCFATS()  //restaura area salva
DbSelectArea(_cALIAS)
DBGOTO(_cRECNO)
DbSetOrder(_cORDEM)
Return()

//-------------------------------------------------------//
Static Function MontStruc()

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no produto desejado                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSeek(xFilial()+SD4->D4_COD)
	If SD4->D4_QUANT > 0
		nQuant:=SD4->D4_QUANT
		AddAr820()
	EndIf
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return

////////////////////////////////////////////////////////////////
Static Function AddAr820()
////////////////////////////////////////////////////////////////
cDesc := SB1->B1_DESC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se imprime nome cientifico do produto. Se Sim    ³
//³ verifica se existe registro no SB5 e se nao esta vazio    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07 == 1
/*
	dbSelectArea("SB5")
	dbSeek(xFilial()+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
	*/
	cDesc := SB1->B1_NARRA     // Descricao completa para a OP B1_NARRA
	
ElseIf mv_par07 == 2
	cDesc := SB1->B1_DESC
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se imprime descricao digitada ped.venda, se sim  ³
	//³ verifica se existe registro no SC6 e se nao esta vazio    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SC2->C2_DESTINA == "P"
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+SC2->C2_NUM+SC2->C2_ITEM)
		If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
			cDesc := C6_DESCRI
		ElseIf C6_PRODUTO #SB1->B1_COD
			dbSelectArea("SB5")
			dbSeek(xFilial()+SB1->B1_COD)
			If Found() .and. !Empty(B5_CEME)
				cDesc := B5_CEME
			EndIf
		EndIf
	EndIf
EndIf

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial()+cProduto+SB1->B1_COD)

dbSelectArea("SB2")
dbSeek(xFilial()+SB1->B1_COD)
dbSelectArea("SD4")
AADD(aArray,{SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuant,SUBS(SG1->G1_OBSERV,1,70),D4_TRT } ) //nQuant
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MontStruc³ Autor ³ Ary Medeiros          ³ Data ³ 19/10/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta um array com a estrutura do produto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MontStruc(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade base a ser explodida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

Return(nil)

/////////////////////////////////////////////////////////////////
Static Function CalcSem(_data)	     
/////////////////////////////////////////////////////////////////
cRefer := "01/01/" + AllTrim( Str( Year( _data ), 4 ) )
dRefer := CToD( cRefer )
nAcres := Dow( dRefer ) - 1
nSem   := ( _data - dRefer ) + nAcres
nSem   := nSem / 7
nSem   := if( Subst( Str( nSem, 12, 2 ), 11, 2 )=="00", Int(nSem), Int(nSem)+1 )

Return( nSem )

///////////////////////////////////////////////////////////////////////////////////
Static Function RotOper()
///////////////////////////////////////////////////////////////////////////////////
_cOperac := "  " 

dbSelectArea("SG2")
dbSeek(xFilial("SG2")+aArray[1][1])

IF FOUND()
	
	_cRecurso := SG2->G2_RECURSO
	
	While !Eof() .And. G2_FILIAL+G2_PRODUTO == xFilial("SG2")+aArray[1][1]
		
				  _cOperac := SG2->G2_OPERAC
				  
		        If SG2->G2_OPERAC == "01"
         		   oprn:say(0830,1800,SG2->G2_OPERAC+"-"+SG2->G2_DESCRI,oFont2,100)  
         		ElseIf SG2->G2_OPERAC == "02"
                   oprn:say(1070,1800,SG2->G2_OPERAC+"-"+SG2->G2_DESCRI,oFont2,100)    ///1110
         		ElseIf SG2->G2_OPERAC == "03"
                   oprn:say(1310,1800,SG2->G2_OPERAC+"-"+SG2->G2_DESCRI,oFont2,100)    ///1390
                ElseIf SG2->G2_OPERAC == "04"
                   oprn:say(1550,1800,SG2->G2_OPERAC+"-"+SG2->G2_DESCRI,oFont2,100)    ///1670
                ElseIf SG2->G2_OPERAC == "05"
                   oprn:say(1790,1800,SG2->G2_OPERAC+"-"+SG2->G2_DESCRI,oFont2,100)    ///1950
                ElseIf SG2->G2_OPERAC == "06"
                   oprn:say(2030,1800,SG2->G2_OPERAC+"-"+SG2->G2_DESCRI,oFont2,100)    ///2230
                ElseIf SG2->G2_OPERAC == "07"
                   oprn:say(2270,1800,SG2->G2_OPERAC+"-"+SG2->G2_DESCRI,oFont2,100)    ///2510
                ElseIf SG2->G2_OPERAC == "08"
                   oprn:say(2510,1800,SG2->G2_OPERAC+"-"+SG2->G2_DESCRI,oFont2,100)    ///2790
                ElseIf SG2->G2_OPERAC == "09"
                   oprn:say(2750,1800,SG2->G2_OPERAC+"-"+SG2->G2_DESCRI,oFont2,100)    ///2790

                EndIf
                
		
		dbSelectArea("SG2")
		dbSkip()
		
	EndDo
	
Endif

oPrn:Box(0800,1740,1040,2450)
oPrn:Box(1040,1740,1280,2450)
oPrn:Box(1280,1740,1520,2450)
oPrn:Box(1520,1740,1760,2450)
oPrn:Box(1760,1740,2000,2450)
oPrn:Box(2000,1740,2240,2450) 
oPrn:Box(2240,1740,2480,2450) 
oPrn:Box(2480,1740,2720,2450) 
oPrn:Box(2720,1740,2960,2450) 
	
Do Case
   Case _cOperac == "01"
   		MsBar("CODE128",08,15.5,alltrim(cOp)+"01",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
   Case _cOperac == "02"
         MsBar("CODE128",08,15.5,alltrim(cOp)+"01",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",10.0,15.5,alltrim(cOp)+"02",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
   Case _cOperac == "03"
         MsBar("CODE128",08,15.5,alltrim(cOp)+"01",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",10.0,15.5,alltrim(cOp)+"02",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",12.0,15.5,alltrim(cOp)+"03",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
   Case _cOperac == "04"
         MsBar("CODE128",08,15.5,alltrim(cOp)+"01",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",10.0,15.5,alltrim(cOp)+"02",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",12.0,15.5,alltrim(cOp)+"03",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",14.0,15.5,alltrim(cOp)+"04",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
   Case _cOperac == "05"
         MsBar("CODE128",08,15.5,alltrim(cOp)+"01",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",10.0,15.5,alltrim(cOp)+"02",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",12.0,15.5,alltrim(cOp)+"03",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",14.0,15.5,alltrim(cOp)+"04",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",16.0,15.5,alltrim(cOp)+"05",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
   Case _cOperac == "06"
         MsBar("CODE128",08,15.5,alltrim(cOp)+"01",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",10.0,15.5,alltrim(cOp)+"02",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",12.0,15.5,alltrim(cOp)+"03",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",14.0,15.5,alltrim(cOp)+"04",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",16.0,15.5,alltrim(cOp)+"05",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",18,15.5,alltrim(cOp)+"06",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
   Case _cOperac == "07"
         MsBar("CODE128",08,15.5,alltrim(cOp)+"01",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",10.0,15.5,alltrim(cOp)+"02",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",12.0,15.5,alltrim(cOp)+"03",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",14.0,15.5,alltrim(cOp)+"04",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",16.0,15.5,alltrim(cOp)+"05",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",18,15.5,alltrim(cOp)+"06",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",20.0,15.5,alltrim(cOp)+"07",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)

   Case _cOperac == "08"
         MsBar("CODE128",08,15.5,alltrim(cOp)+"01",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)           ///08 - 10.4 - 12.8 - 15.2 - 17.6 - 20 - 22.4 - 24.8
         MsBar("CODE128",10.0,15.5,alltrim(cOp)+"02",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",12.0,15.5,alltrim(cOp)+"03",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",14.0,15.5,alltrim(cOp)+"04",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",16.0,15.5,alltrim(cOp)+"05",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",18,15.5,alltrim(cOp)+"06",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",20.0,15.5,alltrim(cOp)+"07",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",22.0,15.5,alltrim(cOp)+"08",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)

   Case _cOperac == "09"
         MsBar("CODE128",08,15.5,alltrim(cOp)+"01",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)           ///08 - 10.4 - 12.8 - 15.2 - 17.6 - 20 - 22.4 - 24.8
         MsBar("CODE128",10.0,15.5,alltrim(cOp)+"02",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",12.0,15.5,alltrim(cOp)+"03",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",14.0,15.5,alltrim(cOp)+"04",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",16.0,15.5,alltrim(cOp)+"05",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",18,15.5,alltrim(cOp)+"06",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",20.0,15.5,alltrim(cOp)+"07",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",22.0,15.5,alltrim(cOp)+"08",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)
         MsBar("CODE128",24.0,15.5,alltrim(cOp)+"09",oPrn,.F.,,,0.025,0.8,.T.,,,.F.)

   EndCase 
  
Return Li             

////////////////////////////////////////////////////////////////////////
Static Function fVerifLin()
////////////////////////////////////////////////////////////////////////
//2200
//If Linha > 2200

	_nPag += 1

	If _nPag > 1
		oPrn:EndPage()
		oPrn:StartPage()
	EndIf
	
	Linha := 810

//Endif

Return

///////////////////////////////////////////////////////////////////////////////////////
Static Function Impr_Anexo(_cOP,_cCod,_cMod,_nKit)   
///////////////////////////////////////////////////////////////////////////////////////
Local nTamLin
Local nLin,  cNumPat := ""
Local cBitMap  := "\SYSTEM\LGRL0301.BMP"
Local cEmpresa := Capital(Alltrim(SM0->M0_NOMECOM))  ///+IIF(M->cNumEmp=="0301", " - Manaus" , IIF(M->cNumEmp=="0302" , " - São Paulo" , "" ) )

oPrn:SetFont(oFont24b)
oPrn:Box(050,110,2912,2330)        //2720
oPrn:Box(052,112,2910,2328)        //2943
oPrn:SayBitMap(0060,0120,cBitMap,0480,0200)
oPrn:Say(0160,0840,OemToAnsi("CONTROLE DE ORDEM DE PRODUÇÃO"),oFont16bi,120)   
oPrn:Say(0270,0120,cEmpresa,oFont12b ,100)
oPrn:Line(0330,0110,0330,2330)
oPrn:Say(0340,0120,"O.P.:  "+_cOP,oFont12b ,100)
oPrn:Say(0340,1440,"KIT:  "+LTRIM(TRANSF(_nKit,"@E 99,999")),oFont12b ,100)
oPrn:Say(0404,0120,"MODELO:  "+LEFT(_cMod,44),oFont12b ,100)
oPrn:Say(0404,1440,"CODIGO:  "+RTRIM(_cCod),oFont12b ,100)
oPrn:Line(0460,0110,0460,2330)
oPrn:Line(0330,1430,0460,1430)     
*
oPrn:Say(0470,1860,"V  I  S  T  O  S",oFont12b ,80)
oPrn:Line(0520,1690,0520,2330)
oPrn:Say(0540,0120,"DATA",oFont12b ,80)
oPrn:Say(0540,0400,"ENTREGA",oFont12b ,50)
oPrn:Say(0540,0690,"ACUMULADO",oFont12b ,50)
oPrn:Say(0540,1020,"SALDO KIT",oFont12b ,50)     
oPrn:Say(0540,1300,"LOTE",oFont12b ,50)     
oPrn:Say(0540,1700,"EXPEDIÇÃO",oFont12b ,50)
oPrn:Say(0540,2020,"PRODUÇÃO",oFont12b ,50)
oPrn:Line(0600,0110,0600,2330)              
*
nLin    := 600
nTamLin := 60
For nLinha := 1 to 14
	 nLin += nTamLin
	 oPrn:Line(nLin,110,nLin,2330)
Next
*
oPrn:Line(0460,0390,nLin,0390)     
oPrn:Line(0460,0680,nLin,0680)     
oPrn:Line(0460,1010,nLin,1010)     
oPrn:Line(0460,1290,nLin,1290)     
oPrn:Line(0460,1690,nLin,1690)     
oPrn:Line(0520,2010,nLin,2010)
*
oPrn:Line(1460,0110,1460,2330)
oPrn:Say(1470,0120,"ROTEIRO DAS OPERAÇÕES",oFont08b ,50)
oPrn:Line(1510,0110,1510,2330)
oPrn:Say(1515,0420,"E  N  T  R  A  D  A",oFont08b ,50)
oPrn:Line(1550,0310,1550,0770)
oPrn:Say(1560,0120,"OPERAÇÃO",oFont08b ,50)
oPrn:Say(1560,0320,"DATA",oFont08b ,50)
oPrn:Say(1560,0560,"QUANTIDADE",oFont08b ,50)
oPrn:Say(1515,0950,"S   A   I   D   A  S",oFont08b ,50)
oPrn:Line(1550,0770,1550,1410)
oPrn:Say(1560,0780,"QUANTIDADE",oFont08b ,50)
oPrn:Say(1560,0990,"QUANTIDADE",oFont08b ,50)
oPrn:Say(1560,1200,"QUANTIDADE",oFont08b ,50)
oPrn:Say(1560,1420,"OBSERVAÇÃO",oFont08b ,50)
*
nLin    := 1540
nTamLin := 60
For nLinha := 1 to 22
	nLin += nTamLin
	oPrn:Line(nLin,110,nLin,2330)
Next
*
nLin := 2912
oPrn:Line(1510,0310,nLin,0310)     
oPrn:Line(1550,0550,nLin,0550)     
oPrn:Line(1510,0770,nLin,0770)     
oPrn:Line(1550,0980,nLin,0980)     
oPrn:Line(1550,1190,nLin,1190)     
oPrn:Line(1510,1410,nLin,1410)

Ms_Flush()       

Return

/////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
/////////////////////////////////////////////////////////////////////////
   _sAlias := Alias()
   DbSelectArea("SX1")
   DbSetOrder(1)
   aRegs :={} //Grupo|Ordem| Pegunt                         | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01      | Def01              | DefSPA1 | DefEng1 | CNT01 | var02 | Def02            | DefSPA2 | DefEng2 | CNT02 | var03 | Def03           | DefSPA3 | DefEng3 | CNT03 | var04 | Def04 | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
   aAdd(aRegs,{ cPerg,"01" , "Da O.P.                     ?",   ""   ,  ""    , "mv_ch1" , "C" ,   13   ,   0   ,   0   , "G" , "          "  , "mv_op_de"   , "                " , "     " , "     " , "   " , "   " , "              " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SC2" , "    " })
   aAdd(aRegs,{ cPerg,"02" , "Até a O.P.                  ?",   ""   ,  ""    , "mv_ch2" , "C" ,   13   ,   0   ,   0   , "G" , "          "  , "mv_op_ate"  , "                " , "     " , "     " , "   " , "   " , "              " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SC2" , "    " })
   aAdd(aRegs,{ cPerg,"03" , "Da Data                     ?",   ""   ,  ""    , "mv_ch3" , "D" ,   08   ,   0   ,   0   , "G" , "          "  , "mv_data_de" , "                " , "     " , "     " , "   " , "   " , "              " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"04" , "Até a Data                  ?",   ""   ,  ""    , "mv_ch4" , "D" ,   08   ,   0   ,   0   , "G" , "          "  , "mv_data_ate", "                " , "     " , "     " , "   " , "   " , "              " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"05" , "Roteiro de Operações        ?",   ""   ,  ""    , "mv_ch5" , "N" ,   01   ,   0   ,   1   , "C" , "          "  , "mv_par05"   , "Sim             " , "     " , "     " , "   " , "   " , "Não           " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"06" , "Imprime Cod. Barras         ?",   ""   ,  ""    , "mv_ch6" , "N" ,   01   ,   0   ,   1   , "C" , "          "  , "mv_par06"   , "Sim             " , "     " , "     " , "   " , "   " , "Não           " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"07" , "Descrição Produto           ?",   ""   ,  ""    , "mv_ch7" , "N" ,   01   ,   0   ,   2   , "C" , "          "  , "mv_par07"   , "Descr.Cient.    " , "     " , "     " , "   " , "   " , "Descr.Generica" , "     " , "     " , "   " , "   " , "Pedido Venda " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
	aAdd(aRegs,{ cPerg,"08" , "Impr. OP Encerrada          ?",   ""   ,  ""    , "mv_ch8" , "N" ,   01   ,   0   ,   1   , "C" , "          "  , "mv_par08"   , "Sim             " , "     " , "     " , "   " , "   " , "Não           " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"09" , "Impr. por Ordem de          ?",   ""   ,  ""    , "mv_ch9" , "N" ,   01   ,   0   ,   1   , "C" , "          "  , "mv_par09"   , "Codigo          " , "     " , "     " , "   " , "   " , "Sequencia     " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"10" , "Considera OPs               ?",   ""   ,  ""    , "mv_cha" , "N" ,   01   ,   0   ,   1   , "C" , "          "  , "mv_par10"   , "Firmes          " , "     " , "     " , "   " , "   " , "Previstas     " , "     " , "     " , "   " , "   " , "Ambas        " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"11" , "Item Neg. na Estrutura      ?",   ""   ,  ""    , "mv_chb" , "N" ,   01   ,   0   ,   1   , "C" , "          "  , "mv_par11"   , "Imprime         " , "     " , "     " , "   " , "   " , "Não Imprime   " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"12" , "Imprime Lote/S.Lote         ?",   ""   ,  ""    , "mv_chc" , "N" ,   01   ,   0   ,   2   , "C" , "          "  , "mv_par12"   , "Sim             " , "     " , "     " , "   " , "   " , "Não           " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })
   aAdd(aRegs,{ cPerg,"13" , "Imprime Anexo Contr. OP     ?",   ""   ,  ""    , "mv_chd" , "N" ,   01   ,   0   ,   2   , "C" , "          "  , "mv_par13"   , "Sim             " , "     " , "     " , "   " , "   " , "Não           " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "    " })

	For i:=1 to Len(aRegs)
		If !DbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)

Return
