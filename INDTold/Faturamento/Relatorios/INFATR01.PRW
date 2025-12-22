#INCLUDE "PROTHEUS.CH"

#INCLUDE "MATR550.CH"
//#INCLUDE "FIVEWIN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR550  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 04.05.92  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Notas Fiscais                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR550(void)                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Marcello     ³23/08/00³oooooo³Impressao da relacao em outras moedas    ³±±
±±³              ³        ³      ³funcao c550impint                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

/* 
Alteracao realizada por wermeson gadelha no dia de 15 de janeiro de 2008
Solicitado pela Sra. Ester 
Esse fonte é uma modificacao do fonte MATR550, onde este respeita o parametro nao imprimir 
outras moedas sendo totalmente adaptado as necessidades do cliente  
*/

User Function INFATR01() // WER
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt
LOCAL CbCont,wnrel
LOCAL nOrdem,cFiltro := ""
LOCAL tamanho:= "G"
LOCAL titulo := OemToAnsi(STR0001)	//"Relacao de Notas Fiscais"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao de notas fiscais."
LOCAL cDesc2 := ""
LOCAL cDesc3 := ""
LOCAL cString:= "SF2"

PRIVATE aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR550"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := PadR("MTR550", Len(SX1->X1_GRUPO) )
Private limite := 220

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= SPACE(10)
cbcont 	:= 0
li 		:= 80
m_pag 	:= 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1(cPerg)
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De Nota                              ³
//³ mv_par02             // Ate a Nota                           ³
//³ mv_par03             // De Data                              ³
//³ mv_par04             // Ate a Data                           ³
//³ mv_par05             // De Produto                           ³
//³ mv_par06             // Ate o Produto                        ³
//³ mv_par07             // Da Serie                             ³
//³ mv_par08             // Da Serie                             ³
//³ mv_par09             // Mascara para codigo do produto       ³
//³ mv_par10             // Aglutina itens grade                 ³
//³ mv_par11             // De  Grupo                            ³
//³ mv_par12             // Ate Grupo                            ³
//³ mv_par13             // De  Tipo                             ³
//³ mv_par14             // Ate Tipo                             ³
//³ mv_par15             // Utiliza Descricao -Produto ProdxCli  ³
//³ mv_par16             // Qual Moeda                           ³
//³ mv_par17             // Outras moedas                        ³
//³ mv_par18             // Lista Dev. Compras ?                 ³
//³ mv_par19             // De Cliente                           ³
//³ mv_par20             // Ate Cliente                          ³
//³ mv_par21             // Tipo de Relatorio 1 Analitico 2      ³
//³ 						Sintetico                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="MATR550"

// Foi retirado o filtro somente para Localizacoes
// Sergio Fuzinaka - 19.10.01
If cPaisLoc <> "BRA"
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,,.F.)
Else
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
Endif

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

//If ( cPaisLoc#"BRA" )
  //	RptStatus({|lEnd| C550ImpInt(@lEnd,wnRel,cString)},Titulo)
//Else
	If mv_par21==1
		RptStatus({|lEnd| C550Imp(@lEnd,wnRel,cString)},Titulo)
	Else
   		RptStatus({|lEnd| C550ImpSin(@lEnd,wnRel,cString)},Titulo)
    Endif		 		
//Endif
                 
Return

/*                         

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C550IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR550			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C550Imp(lEnd,WnRel,cString)

LOCAL nCt := 0
LOCAL nAcD1  := 0, nAcD2 := 0, nAcD3 := 0, nAcD4 := 0, nAcD5 := 0, nAcD6:= 0, nAcD7 := 0
LOCAL nAcN1  := 0, nAcN2 := 0, nAcN3 := 0, nAcN4 := 0, nAcN5 := 0
LOCAL nAcN6  := 0, nAcG1 := 0, nAcG2 := 0, nAcG3 := 0, nAcG4 := 0
LOCAL nAcG5  := 0, nAcG6 := 0, nAcG7 := 0, nVlrISS := 0,nCompIcm := 0
LOCAL lContinua	:= .T., dEmisAnt
#IFDEF TOP
	LOCAL cQuery := ""
#ELSE
	LOCAL cCondicao
#ENDIF
LOCAL nReg     	:=0
LOCAL nTotQuant	:=0
LOCAL nTotal   	:=0
LOCAL nTotIcm  	:=0
LOCAL nTotIPI  	:=0
LOCAL nTotRet   :=0
LOCAL cCf      	:=""
LOCAL cTes    	:=""
LOCAL cLocal   	:=""
LOCAL cItemPv  	:=""
LOCAL cNumPed  	:=""
LOCAL nPrcVen  	:=0
LOCAL cMascara 	:=GetMv("MV_MASCGRD")
LOCAL nTamRef  	:=Val(Substr(cMascara,1,2))
LOCAL tamanho	:= "G"
LOCAL nICMDesp 	:= 0 , nIPIDesp:= 0
LOCAL cabec1,cabec2
Local dEmiDia := dDataBase
Local cNota   := ""
Local cSerie  := ""
Local nICMSRet:= 0
Local nFrete  := 0
Local nFretAut:= 0
Local nIcmAuto:= 0
Local nSeguro := 0
Local nDespesa:= 0
Local nValIPI := 0
Local nValICM := 0
Local nValISS := 0
Local cTipoNF := 0 
Local lFretAut:= GetNewPar("MV_FRETAUT",.T.)
Local lQuery  := .F.
Local cFil	  := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01
imprime  := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If xFilial("SF2") == "01"
   cFil:= " (Manaus)"
 ElseIf xFilial("SF2") == "02"
   cFil:= " (Brasília)"
 ElseIf xFilial("SF2") == "03"
   cFil:= " (Recife)" 
 ElseIf xFilial("SF2") == "04"
   cFil:= " (São Paulo)" 
EndIf  
titulo := Alltrim(STR0005) + " - " + GetMv("MV_MOEDA" + STR(mv_par16,1)) +" "+ UPPER(AllTrim(cFil)) //"RELACAO DAS NOTAS FISCAIS  "  

//titulo := STR0005 + " - " + GetMv("MV_MOEDA" + STR(mv_par16,1)) //"RELACAO DAS NOTAS FISCAIS  "
Cabec1 := STR0006	//"PRODUTO          DESCRICAO                       QUANTIDADE        VALOR UNITARIO VALOR MERCADORIA ALMOX CFO TES PEDIDO/IT        VALOR IPI         VALOR ICM        VALOR ISS          DESP. ACESSORIAS               TOTAL"
// 0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
Cabec2 := space(94)+"Periodo: "+ SubStr(dTos(mv_par03),7,2) +"/"+ SubStr(dTos(mv_par03),5,2) +"/"+ SubStr(dTos(mv_par03),1,4)+;
		  " a " + SubStr(dTos(mv_par04),7,2) +"/"+ SubStr(dTos(mv_par04),5,2) +"/"+ SubStr(dTos(mv_par04),1,4)
    	
    	lQuery := .T.
		cAliasSF2 := GetNextAlias()
		cAliasSD2 := cAliasSF2
		
		//campos do SF2
		cQuery:="SELECT F2_DOC,F2_SERIE,F2_EMISSAO,F2_TIPO,F2_ICMSRET"
		cQuery+=",F2_FRETE,F2_FRETAUT,F2_ICMAUTO,F2_SEGURO,F2_DESPESA,F2_VALBRUT "
		cQuery+=",F2_VALIPI,F2_VALICM,F2_VALISS,SF2.R_E_C_N_O_ SF2RECNO "
		
		//campos do SD2
		cQuery+=",D2_DOC,D2_SERIE,D2_COD,D2_GRUPO,D2_TP,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_GRADE,D2_CF,D2_TES,D2_LOCAL,D2_ITEMPV,D2_PEDIDO"
		cQuery+=",D2_PRCVEN,D2_ICMSRET,D2_QUANT,D2_TOTAL,D2_EMISSAO,D2_VALIPI,D2_CODISS,D2_VALISS,D2_VALICM"
		
		//CAMPOS DO SE1
		cQuery+=",E1_MOEDA, E1_VALOR "
		
		cQuery+="FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SE1")+" SE1 WHERE "
		cQuery+="F2_FILIAL='"+xFilial("SF2")+"'"
		cQuery+=" AND F2_DOC>='"+mv_par01+"' AND F2_DOC<='"+mv_par02+"'"
		cQuery+=" AND F2_EMISSAO>='"+DTOS(mv_par03)+"' AND F2_EMISSAO<='"+DTOS(mv_par04)+"'"
		cQuery+=" AND F2_SERIE>='"+mv_par07+"' AND F2_SERIE<='"+mv_par08+"'"
		cQuery+=" AND F2_CLIENTE>='"+mv_par19+"' AND F2_CLIENTE<='"+mv_par20+"'"
		cQuery+=" AND NOT ("+IsRemito(2,"F2_TIPODOC")+")"
		If MV_PAR18==2
			cQuery+=" AND F2_TIPO<>'D'"
		Endif
		 
		if mv_par17 == 2   //nao imprimir notas com moeda diferente da escolhida
			cQuery+=" AND E1_MOEDA=" + AllTrim(str(mv_par16))
		endif

		cQuery+=" AND SF2.D_E_L_E_T_<>'*' "
		cQuery+=" AND D2_FILIAL='"+xFilial("SD2")+"' AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA"
		cQuery+=" AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE"
		cQuery+=" AND D2_COD>='"+mv_par05+"' AND D2_COD<='"+mv_par06+"'"
		cQuery+=" AND D2_GRUPO>='"+mv_par11+"' AND D2_GRUPO<='"+mv_par12+"'"
		cQuery+=" AND D2_TP>='"+mv_par13+"' AND D2_TP<='"+mv_par14+"'"
		cQuery+=" AND SD2.D_E_L_E_T_=''" 
		
		cQuery+=" AND SE1.D_E_L_E_T_<>'*' "
		cQuery+=" AND E1_NUM = F2_DOC "
		cQuery+=" AND E1_PREFIXO = F2_SERIE "
		cQuery+=" AND E1_FILIAL = F2_FILIAL "
		cQuery+=" AND E1_LOJA = F2_LOJA "
		cQuery+=" AND E1_CLIENTE = F2_CLIENTE " 
		
		cQuery+=" ORDER BY F2_EMISSAO,F2_DOC,F2_SERIE,D2_COD,D2_ITEM"
		cQuery:=ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSF2,.F.,.T.)
		TCSetField(cAliasSF2,"F2_EMISSAO","D",8,0)
		TCSetField(cAliasSD2,"D2_EMISSAO","D",8,0)	


//SetRegua(cAliasSF2->(RecCount()))
While !Eof() .and. lContinua

	IF lEnd
		@Prow()+1,001 PSAY STR0007		//"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif

  //	IncRegua()

	dEmisAnt := F2_EMISSAO
	
	If !lQuery
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(cFilial+SF2->F2_DOC+SF2->F2_SERIE)
	Endif

	nCt     := 1      
	nTotRet := 0
	cNota	:= (cAliasSF2)->F2_DOC
	cSerie	:= (cAliasSF2)->F2_SERIE
	nICMSRet:= (cAliasSF2)->F2_ICMSRET
	nFrete	:= (cAliasSF2)->F2_FRETE
	nFretAut:= (cAliasSF2)->F2_FRETAUT
	nIcmAuto:= (cAliasSF2)->F2_ICMAUTO
	nSeguro	:= (cAliasSF2)->F2_SEGURO
	nDespesa:= (cAliasSF2)->F2_DESPESA
	nValIPI	:= (cAliasSF2)->F2_VALIPI
	nValICM	:= (cAliasSF2)->F2_VALICM
	nValISS	:= (cAliasSF2)->F2_VALISS
	cTipoNF	:= (cAliasSF2)->F2_TIPO

	While !Eof() .and. D2_DOC+D2_SERIE == cNota+cSerie

		If !lQuery
			If D2_COD < mv_par05 .Or. D2_COD > mv_par06 .Or. D2_GRUPO < mv_par11 .Or. ;
					D2_GRUPO > mv_par12 .Or. D2_TP < mv_par13 .Or. D2_TP > mv_par14 .Or. ;
					D2_SERIE < mv_par07 .Or. D2_SERIE > mv_par08
				dbSkip()
				Loop
			Endif
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida o produto conforme a mascara         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet:=ValidMasc(SD2->D2_COD,MV_PAR09)

		If !lRet
			dbSkip()
			Loop
		Endif
		
		If !Empty(aReturn[7])
			If lQuery
				SF2->(MsGoto((cAliasSF2)->SF2RECNO))
			Endif
			If !SF2->(&(aReturn[7]))
				dbSkip()
				Loop			
		    EndIf
		EndIf

		If li > 52
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		EndIf

		If nCt == 1
			If (cAliasSD2)->D2_TIPO $ "BD"
				dbSelectArea("SA2")
				dbSetOrder(1)
				dbSeek(xFilial()+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
                @Li ,   0 PSAY STR0008+A2_COD+" "+A2_LOJA+" - "+A2_NOME+" "+STR0009+DTOC((cAliasSF2)->F2_EMISSAO)+STR0010+(cAliasSD2)->D2_TIPO     //"FORNECEDOR : "###"EMISSAO : "###" TIPO DA NOTA : "
			Else
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek(xFilial()+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
                @Li ,   0 PSAY STR0011+A1_COD+" "+A1_LOJA+" - "+A1_NOME+" "+STR0009+DTOC((cAliasSF2)->F2_EMISSAO)+STR0010+(cAliasSD2)->D2_TIPO     //"CLIENTE    : "###"EMISSAO : "###" TIPO DA NOTA : "
			EndIf
			nCt++
			Li++
			dbSelectArea((cAliasSD2))
		EndIf

		@Li , 0 PSAY IIF(D2_GRADE == "S".And. MV_PAR10 == 1,Substr(D2_COD,1,nTamRef),D2_COD)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Utiliza Descricao conforme mv_par15         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF mv_par15 == 1
			dbSelectArea("SB1");dbSetOrder(1);dbSeek(xFilial()+(cAliasSD2)->D2_COD)
            @li , 16 PSAY Substr(B1_DESC,1,29)
		Else
			dbSelectArea("SA7");dbSetOrder(2)
			If dbSeek(xFilial()+(cAliasSD2)->D2_COD+SD2->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
                @li , 16 PSAY Substr(A7_DESCCLI,1,29)
			Else
				dbSelectArea("SB1");dbSetOrder(1);dbSeek(xFilial()+(cAliasSD2)->D2_COD)
                @li , 16 PSAY Substr(B1_DESC,1,29)
			Endif
		Endif

		dbSelectArea(cAliasSD2)
		cCf      :=D2_CF
		cTes     :=D2_TES
		cLocal   :=D2_LOCAL
		cItemPv  :=D2_ITEMPV
		cNumPed  :=D2_PEDIDO
		nTotQuant:=0
		nTotal   :=0
		nTotICM  :=0
		nTotIPI  :=0
		nPrcVen  :=D2_PRCVEN

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)
		
		If SF4->F4_INCSOL == "S"
			nTotRet += (cAliasSD2)->D2_ICMSRET
		Endif	

		dbSelectArea(cAliasSD2)

		nReg := 0
		If (cAliasSD2)->D2_GRADE == "S" .And. MV_PAR10 == 1
			cProdRef:= Substr((cAliasSD2)->D2_COD,1,nTamRef)
			While !Eof() .And. cProdRef == Substr((cAliasSD2)->D2_COD,1,nTamRef) ;
					.And. (cAliasSD2)->D2_GRADE == "S" .And. cNumPed == D2_PEDIDO
				nTotQuant+= D2_QUANT
				nTotal   += IIF(!((cAliasSF2)->F2_TIPO $ "IP"),D2_TOTAL,0)
				If (cAliasSF2)->F2_TIPO == "I"
					nCompIcm+=xMoeda(D2_TOTAL,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)
				EndIf

				nTotIPI  += D2_VALIPI

				If Empty(D2_CODISS) .And. SD2->D2_VALISS == 0 // ISS
					nTotIcm  += D2_VALICM
				EndIf
				nReg     := Recno()
				dbSkip()
				If !lQuery
					If SD2->D2_COD < mv_par05 .Or. SD2->D2_COD > mv_par06 .Or.;
							SD2->D2_GRUPO	< mv_par11 .Or. SD2->D2_GRUPO > mv_par12
						dbSkip()
						Loop
					Endif
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida o produto conforme a mascara       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRet:=ValidMasc((cAliasSD2)->D2_COD,MV_PAR09)
				If !lRet
					dbSkip()
					Loop
				Endif
			End
			If !lQuery
				If nReg > 0
					dbGoto(nReg)
					nReg:=0
				Endif
			Endif

            @Li , 46 PSAY nTotQuant      PICTURE PESQPICTQT("D2_QUANT",16)
            @Li , 63 PSAY xMoeda(nPrcVen    ,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO) PICTURE PESQPICT("SD2","D2_PRCVEN",16)
            @Li , 80 PSAY xMoeda(nTotal     ,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO) PICTURE TM((D2_TOTAL),16)
            @Li ,100 PSAY cLocal
            @Li ,103 PSAY cCF
			@Li ,109 PSAY cTes
			@Li ,113 PSAY cNumPed
			@Li ,120 PSAY cItemPV
			@Li ,123 PSAY xMoeda(nTotIPI	,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO) PICTURE TM(D2_VALIPI,16)
			@Li ,141 PSAY xMoeda(nTotICM	,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO) PICTURE TM(D2_VALICM,16)
			nAcN1 += nTotQuant

			If SF4->F4_AGREG <> "N"   
			    If mv_par17 == 2
   			     nAcN2 += (cAliasSD2)->E1_VALOR 
   			     Else
   			     nAcN2 += xMoeda(nTotal	,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO) //WER
   			    EndIf  			     

				If SF4->F4_AGREG == "D"
					nAcN2 -= xMoeda(nTotICM,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)
				EndIf
            EndIf

			nAcN4 += xMoeda(nTotICM,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)
			nAcN5 += xMoeda(nTotIPI,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)
		Else
            @Li , 46 PSAY D2_QUANT       PICTURE PESQPICTQT("D2_QUANT",16)
            @Li , 63 PSAY xMoeda(D2_PRCVEN  ,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)    PICTURE PESQPICT("SD2","D2_PRCVEN",16)
            @Li , 80 PSAY xMoeda(D2_TOTAL   ,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)    PICTURE TM((D2_TOTAL),16)
            @Li ,100 PSAY D2_LOCAL
            @Li ,103 PSAY D2_CF
			@Li ,109 PSAY D2_TES
			@Li ,113 PSAY D2_PEDIDO
			@Li ,120 PSAY D2_ITEMPV
			@Li ,123 PSAY xMoeda(D2_VALIPI,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)	PICTURE TM(D2_VALIPI,16)
			
			If Empty(D2_CODISS) .And. SD2->D2_VALISS == 0 // ISS
				@Li ,141 PSAY xMoeda(D2_VALICM,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)	PICTURE TM(D2_VALICM,16)
			Endif
			nAcN1 += D2_QUANT

			If SF4->F4_AGREG <> "N"  
			    If mv_par17 == 2
   		           nAcN2 += IIF(!((cAliasSF2)->F2_TIPO $ "IP"),(cAliasSD2)->E1_VALOR,0)  
   			     Else
   			       nAcN2 += IIF(!((cAliasSF2)->F2_TIPO $ "IP"),xMoeda(D2_TOTAL,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO),0) //WER
   			    EndIf    
 
			   If SF4->F4_AGREG == "D"
				   nAcN2 -= xMoeda(D2_VALICM,1,MV_PAR16,SD2->D2_EMISSAO)
			   EndIf
			Endif

			If (cAliasSF2)->F2_TIPO == "I"
				nCompIcm+=xMoeda(D2_TOTAL,1,MV_PAR16,SD2->D2_EMISSAO)
			EndIf
			If Empty(D2_CODISS) .And. (cAliasSD2)->D2_VALISS == 0 // ISS
				nAcN4 += xMoeda(D2_VALICM,1,MV_PAR16,SD2->D2_EMISSAO)
			EndIf

			nAcN5 += xMoeda(D2_VALIPI,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)
			

		Endif
		Li++
		dEmiDia := (cAliasSD2)->D2_EMISSAO
		If nReg==0
			dbSkip()
		Endif
	End // Nota

	If (nAcN2+nAcN4+nAcN5) # 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se nota tem ICMS Solidario, imprime.			             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nICMSRet > 0
			@Li , 0   PSAY STR0012	//"ICMS SOLIDARIO ------------> "
			@Li , 204 PSAY nICMSRet Picture PesqPict("SF2","F2_ICMSRET",16)
			Li++
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se nota tem ICMS Ref.Frete Autonomo, imprime.                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nICMAuto > 0
			@Li , 0   PSAY STR0029	//"ICMS REF.FRETE AUTONOMO ---> "
			@Li , 204 PSAY nICMAuto Picture PesqPict("SF2","F2_ICMAUTO",16)
			Li++
		EndIf

		nAcN3 := xMoeda(nFrete+nSeguro+nDespesa,1,MV_PAR16,dEmiDia)
		If nAcN3 != 0 .Or. nFretAut != 0
			nIPIDesp := xMoeda(nValIPI,1,MV_PAR16,dEmiDia) - nAcN5
			nICMDesp := xMoeda(nValICM,1,MV_PAR16,dEmiDia) - nAcN4
			nAcN5 := xMoeda(nValIPI,1,MV_PAR16,dEmiDia)
			nAcN4 := xMoeda(nValICM,1,MV_PAR16,dEmiDia)
			@Li ,  0 PSAY STR0013	//"DESPESAS ACESSORIAS -------> "
			@Li ,123 PSAY nIPIDesp      PICTURE TM(D2_VALIPI	,16)
			@Li ,141 PSAY nICMDesp      PICTURE TM(D2_VALICM	,16)
			@Li ,184 PSAY nAcN3+nFretAut PICTURE TM(nAcN3		,16)
			Li++
		EndIf
		nAcN6 := nAcN2 + nAcN3 + nAcN5 + xMoeda(nTotRet,1,MV_PAR16,dEmiDia) +If(lFretAut,nIcmAuto,0) // WERMESON GADELHA
		nVlrISS:= xMoeda(nValISS,1,MV_PAR16,dEmiDia)
		@Li ,   0 PSAY STR0014+cNota+" / "+cSerie+" ---->"		//"TOTAL DA NOTA - "
        @Li ,  46 PSAY nAcN1    PICTURE PESQPICTQT("D2_QUANT",16)
        @Li ,  80 PSAY nAcN2    PICTURE TM(nAcN2    ,16)
		@Li , 123 PSAY nAcN5    PICTURE TM(nAcN5	,16)
		@Li , 141 PSAY nAcN4    PICTURE TM(nAcN4	,16)
		@Li , 158 PSAY nVlrISS  PICTURE TM(nVlrISS	,16)
		@Li , 184 PSAY nAcN3+nFretAut PICTURE TM(nAcN3	,16)
		@Li , 204 PSAY nAcN6    PICTURE TM(nAcN6	,16)
		Li++
		@Li , 00 PSAY replicate("-", limite)
		// @Li ,  0 PSAY __PrtThinLine() WERMESO VOLTAR
		Li++
		nAcG1 += nAcN1
		nAcG2 += nAcN2
		nAcG3 += nAcN3+nFretAut
		nAcG4 += nAcN4
		nAcG5 += nAcN5
		nAcG6 += nAcN6
		nAcG7 += nVlrISS
	EndIf

	nAcD1 += nAcN1
	nAcD2 += nAcN2
	nAcD3 += nAcN3+nFretAut
	nAcD4 += nAcN4
	nAcD5 += nAcN5
	nAcD6 += nAcN6
	nAcD7 += nVlrISS

	nAcn1 := 0
	nAcn2 := 0
	nAcn3 := 0
	nAcn4 := 0
	nAcn5 := 0
	nAcn6 := 0
    nVlrISS := 0
	nCompIcm := 0

	dbSelectArea(cAliasSF2)
	If !lQuery
		dbSkip()
	Endif

	If nAcd1+nAcD4+nAcD5 > 0 .And. ( dEmisAnt != F2_EMISSAO .Or. Eof() )
		Li++
		@Li ,  0 PSAY STR0015+dtoc(dEmisAnt)		//"TOTAL DO DIA  ----> "
        @Li , 46 PSAY nAcD1 PICTURE PESQPICTQT("D2_QUANT",16)
        @Li , 80 PSAY nAcD2 PICTURE TM(nAcD2,16)
		@Li ,123 PSAY nAcD5 PICTURE TM(nAcD5,16)
     	@Li ,141 PSAY nAcD4 PICTURE TM(nAcD4,16)
		@Li ,158 PSAY nAcD7 PICTURE TM(nAcD7,16)
		@Li ,184 PSAY nAcD3 PICTURE TM(nAcD3,16)
		@Li ,204 PSAY nAcD6 PICTURE TM(nAcD6,16)
		Li++
		@Li ,  0 PSAY __PrtThinLine() //WER VOLTAR
		Li+=2
		nAcD1 := 0
		nAcD2 := 0
		nAcD3 := 0
		nAcD4 := 0
		nAcD5 := 0
		nAcD6 := 0
		nAcD7 := 0
	Endif

End // Documento, Serie
If nACG1 <> 0 .Or. nACG2 <> 0 .Or. nACG5 <> 0 .Or. nACG4 <> 0 .Or. nACG7 <> 0 .Or. nACG3 <> 0 .Or. nACG6 <> 0 
	IF li >= 52
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	EndIf
	
	@Li ,  0 PSAY STR0016	//"TOTAL GERAL            ---->"
	@Li , 46 PSAY nAcG1 PICTURE PESQPICTQT("D2_QUANT",16)
	@Li , 80 PSAY nAcG2 PICTURE TM(nAcG2,16)
	@Li ,123 PSAY nAcG5	PICTURE TM(nAcG5,16)
	@Li ,141 PSAY nAcG4	PICTURE TM(nAcG4,16)
	@Li ,158 PSAY nAcG7	PICTURE TM(nAcG7,16)
	@Li ,184 PSAY nAcG3	PICTURE TM(nAcG3,16)
	@Li ,204 PSAY nAcG6	PICTURE TM(nAcG6,16)
	Li++
	roda(cbcont,cbtxt,tamanho)
EndIf	
If lQuery
	DbSelectArea(cAliasSF2)
	DbCloseArea()
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve condicao original ao SF2 e apaga arquivo de trabalho.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RetIndex("SF2")
	dbSelectArea("SF2")
	dbClearFilter()
	dbSetOrder(1)

	cIndex += OrdBagExt()
	If File(cIndex)
		Ferase(cIndex)
	Endif
Endif

dbSelectArea("SD2")
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C550IMPSIM³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR550			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C550ImpSin(lEnd,WnRel,cString)

LOCAL nCt := 0
LOCAL dDatAnt:= CTOD('  /  /  ')
LOCAL nAcD1  := 0, nAcD2 := 0, nAcD3 := 0, nAcD4 := 0, nAcD5 := 0, nAcD6:= 0, nAcD7 := 0
LOCAL nAcN1  := 0, nAcN2 := 0, nAcN3 := 0, nAcN4 := 0, nAcN5 := 0
LOCAL nAcN6  := 0, nAcG1 := 0, nAcG2 := 0, nAcG3 := 0, nAcG4 := 0
LOCAL nAcG5  := 0, nAcG6 := 0, nAcG7 := 0, nVlrISS := 0,nCompIcm := 0
LOCAL lContinua	:= .T. 
lOCAL dEmisAnt
LOCAL cCondicao
LOCAL nReg     	:=0
LOCAL nTotQuant	:=0
LOCAL nTotal   	:=0
LOCAL nTotIcm  	:=0
LOCAL nTotIPI  	:=0
LOCAL nTotRet   :=0
LOCAL cCf      	:=""
LOCAL cTes    	:=""
LOCAL cLocal   	:=""
LOCAL cItemPv  	:=""
LOCAL cNumPed  	:=""
LOCAL nPrcVen  	:=0
LOCAL cMascara 	:=GetMv("MV_MASCGRD")
LOCAL nTamRef  	:=Val(Substr(cMascara,1,2))
LOCAL nTamLin  	:=Val(Substr(cMascara,4,2))
LOCAL nTamCol  	:=Val(Substr(cMascara,7,2))
LOCAL tamanho	:= "G"
LOCAL limite 	:= 220
LOCAL nICMDesp 	:= 0 , nIPIDesp:= 0
LOCAL cabec1,cabec2,cabec3
Local dEmiDia := dDataBase
Local cNota   := ""
Local cSerie  := ""
Local nICMSRet:= 0
Local nFrete  := 0
Local nFretAut:= 0
Local nIcmAuto:= 0
Local nSeguro := 0
Local nDespesa:= 0
Local nValIPI := 0
Local nValICM := 0
Local nValISS := 0
Local cTipoNF := 0 
Local lFretAut:= GetNewPar("MV_FRETAUT",.T.)
Local lQuery  := .F.
Local cFil	  := ""	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01
imprime  := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If xFilial("SF2") == "01"
   cFil:= " (Manaus)"
 ElseIf xFilial("SF2") == "02"
   cFil:= " (Brasília)"
 ElseIf xFilial("SF2") == "03"
   cFil:= " (Recife)" 
 ElseIf xFilial("SF2") == "04"
   cFil:= " (São Paulo)" 
EndIf  
titulo := Alltrim(STR0005) + " - " + GetMv("MV_MOEDA" + STR(mv_par16,1)) +" "+ UPPER(AllTrim(cFil)) //"RELACAO DAS NOTAS FISCAIS  "  
Cabec1 := STR0028	//"DETALHES DAS NOTAS                             QUANTIDADE        VALOR UNITARIO VALOR MERCADORIA ARMAZ CFO   TES PEDIDO/IT        VALOR IPI         VALOR ICM        VALOR ISS          DESP. ACESSORIAS               TOTAL"	
// 0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
Cabec2 := space(94)+"Periodo: "+ SubStr(dTos(mv_par03),7,2) +"/"+ SubStr(dTos(mv_par03),5,2) +"/"+ SubStr(dTos(mv_par03),1,4)+;
		  " a " + SubStr(dTos(mv_par04),7,2) +"/"+ SubStr(dTos(mv_par04),5,2) +"/"+ SubStr(dTos(mv_par04),1,4)
    	
		lQuery := .T.
		cAliasSF2 := GetNextAlias()
		cAliasSD2 := cAliasSF2
		
		//campos do SF2
		cQuery:="SELECT F2_DOC,F2_SERIE,F2_EMISSAO,F2_TIPO,F2_ICMSRET"
		cQuery+=",F2_FRETE,F2_FRETAUT,F2_ICMAUTO,F2_SEGURO,F2_DESPESA,F2_VALBRUT"
		cQuery+=",F2_VALIPI,F2_VALICM,F2_VALISS,SF2.R_E_C_N_O_ SF2RECNO "
		
		//campos do SD2
		cQuery+=",D2_DOC,D2_SERIE,D2_COD,D2_GRUPO,D2_TP,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_GRADE,D2_CF,D2_TES,D2_LOCAL,D2_ITEMPV,D2_PEDIDO"
		cQuery+=",D2_PRCVEN,D2_ICMSRET,D2_QUANT,D2_TOTAL,D2_EMISSAO,D2_VALIPI,D2_CODISS,D2_VALISS,D2_VALICM "
		
		//CAMPOS DO SE1
		cQuery+=",E1_MOEDA, E1_VALOR "
		
		cQuery+="FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SE1")+" SE1 WHERE "
		cQuery+="F2_FILIAL='"+xFilial("SF2")+"'"
		cQuery+=" AND F2_DOC>='"+mv_par01+"' AND F2_DOC<='"+mv_par02+"'"
		cQuery+=" AND F2_EMISSAO>='"+DTOS(mv_par03)+"' AND F2_EMISSAO<='"+DTOS(mv_par04)+"'"
		cQuery+=" AND F2_SERIE>='"+mv_par07+"' AND F2_SERIE<='"+mv_par08+"'"
		cQuery+=" AND F2_CLIENTE>='"+mv_par19+"' AND F2_CLIENTE<='"+mv_par20+"'"
		cQuery+=" AND NOT ("+IsRemito(2,"F2_TIPODOC")+")"
		
		If MV_PAR18==2
			cQuery+=" AND F2_TIPO<>'D'"
		Endif                                                                  
			
		if mv_par17 == 2   //nao imprimir notas com moeda diferente da escolhida
			cQuery+=" AND E1_MOEDA=" + AllTrim(str(mv_par16))
		endif
						
		cQuery+=" AND SF2.D_E_L_E_T_<>'*' "
		cQuery+=" AND D2_FILIAL='"+xFilial("SD2")+"' AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA"
		cQuery+=" AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE"
		cQuery+=" AND D2_COD>='"+mv_par05+"' AND D2_COD<='"+mv_par06+"'"
		cQuery+=" AND D2_GRUPO>='"+mv_par11+"' AND D2_GRUPO<='"+mv_par12+"'"
		cQuery+=" AND D2_TP>='"+mv_par13+"' AND D2_TP<='"+mv_par14+"'"
		cQuery+=" AND SD2.D_E_L_E_T_=''"
		
		cQuery+=" AND SE1.D_E_L_E_T_<>'*' "
		cQuery+=" AND E1_NUM = F2_DOC "
		cQuery+=" AND E1_PREFIXO = F2_SERIE "
		cQuery+=" AND E1_FILIAL = F2_FILIAL "
		cQuery+=" AND E1_LOJA = F2_LOJA "
		cQuery+=" AND E1_CLIENTE = F2_CLIENTE " 
				
		cQuery+=" ORDER BY F2_EMISSAO,F2_DOC,F2_SERIE,D2_COD,D2_ITEM"  
		
		cQuery:=ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSF2,.F.,.T.)
		TCSetField(cAliasSF2,"F2_EMISSAO","D",8,0)                             		
		TCSetField(cAliasSD2,"D2_EMISSAO","D",8,0)

While !Eof() .and. lContinua

	IF lEnd
		@Prow()+1,001 PSAY STR0007		//"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif

//	IncRegua()

	dEmisAnt := F2_EMISSAO
	
	If !lQuery
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(cFilial+SF2->F2_DOC+SF2->F2_SERIE)
	Endif

	nCt     := 1      
	nTotRet := 0
	cNota	:= (cAliasSF2)->F2_DOC
	cSerie	:= (cAliasSF2)->F2_SERIE
	nICMSRet:= (cAliasSF2)->F2_ICMSRET
	nFrete	:= (cAliasSF2)->F2_FRETE
	nFretAut:= (cAliasSF2)->F2_FRETAUT	
	nIcmAuto:= (cAliasSF2)->F2_ICMAUTO
	nSeguro	:= (cAliasSF2)->F2_SEGURO
	nDespesa:= (cAliasSF2)->F2_DESPESA
	nValIPI	:= (cAliasSF2)->F2_VALIPI
	nValICM	:= (cAliasSF2)->F2_VALICM
	nValISS	:= (cAliasSF2)->F2_VALISS
	cTipoNF	:= (cAliasSF2)->F2_TIPO
	
	While !Eof() .and. D2_DOC+D2_SERIE == cNota+cSerie

		If !lQuery
			If D2_COD < mv_par05 .Or. D2_COD > mv_par06 .Or. D2_GRUPO < mv_par11 .Or. ;
					D2_GRUPO > mv_par12 .Or. D2_TP < mv_par13 .Or. D2_TP > mv_par14 .Or. ;
					D2_SERIE < mv_par07 .Or. D2_SERIE > mv_par08
				dbSkip()
				Loop
			Endif
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida o produto conforme a mascara         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet:=ValidMasc(SD2->D2_COD,MV_PAR09)

		If !lRet
			dbSkip()
			Loop
		Endif

		If !Empty(aReturn[7])
			If lQuery
				SF2->(MsGoto((cAliasSF2)->SF2RECNO))
			Endif
			If !SF2->(&(aReturn[7]))
				dbSkip()
				Loop			
		    EndIf
		EndIf
		
		If li > 52
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		EndIf

		If nCt == 1
			If (cAliasSD2)->D2_TIPO $ "BD"
				dbSelectArea("SA2")
				dbSetOrder(1)
				dbSeek(xFilial()+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)

			Else
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek(xFilial()+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)

			EndIf
			nCt++
			Li++
			dbSelectArea((cAliasSD2))
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Utiliza Descricao conforme mv_par15         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF mv_par15 == 1
			dbSelectArea("SB1");dbSetOrder(1);dbSeek(xFilial()+(cAliasSD2)->D2_COD)

		Else
			dbSelectArea("SA7");dbSetOrder(2)
			If dbSeek(xFilial()+(cAliasSD2)->D2_COD+SD2->D2_CLIENTE+(cAliasSD2)->D2_LOJA)

			Else
			 	dbSelectArea("SB1");dbSetOrder(1);dbSeek(xFilial()+(cAliasSD2)->D2_COD)

			Endif
		Endif

		dbSelectArea(cAliasSD2)
		cCf      :=D2_CF
		cTes     :=D2_TES
		cLocal   :=D2_LOCAL
		cItemPv  :=D2_ITEMPV
		cNumPed  :=D2_PEDIDO
		nTotQuant:=0
		nTotal   :=0
		nTotICM  :=0
		nTotIPI  :=0
		nPrcVen  :=D2_PRCVEN

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)
		
		If SF4->F4_INCSOL == "S"
			nTotRet += (cAliasSD2)->D2_ICMSRET
		Endif	

		dbSelectArea(cAliasSD2)

		nReg := 0
		If (cAliasSD2)->D2_GRADE == "S" .And. MV_PAR10 == 1
			cProdRef:= Substr((cAliasSD2)->D2_COD,1,nTamRef)
			While !Eof() .And. cProdRef == Substr((cAliasSD2)->D2_COD,1,nTamRef) ;
					.And. (cAliasSD2)->D2_GRADE == "S" .And. cNumPed == D2_PEDIDO
				nTotQuant+= D2_QUANT
				nTotal   += IIF(!((cAliasSF2)->F2_TIPO $ "IP"),D2_TOTAL,0)
				If (cAliasSF2)->F2_TIPO == "I"
					nCompIcm+=xMoeda(D2_TOTAL,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)
				EndIf

				nTotIPI  += D2_VALIPI

				If Empty(D2_CODISS) .And. SD2->D2_VALISS == 0 // ISS
					nTotIcm  += D2_VALICM
				EndIf
				nReg     := Recno()
				dbSkip()
				If !lQuery
					If SD2->D2_COD < mv_par05 .Or. SD2->D2_COD > mv_par06 .Or.;
							SD2->D2_GRUPO	< mv_par11 .Or. SD2->D2_GRUPO > mv_par12
						dbSkip()
						Loop
					Endif
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida o produto conforme a mascara       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRet:=ValidMasc((cAliasSD2)->D2_COD,MV_PAR09)
				If !lRet
					dbSkip()
					Loop
				Endif
			End
			
			If !lQuery
				If nReg > 0
					dbGoto(nReg)
					nReg:=0
				Endif
			Endif

    		nAcN1 += nTotQuant

			If SF4->F4_AGREG <> "N"   
			    If mv_par17 == 2
   			     nAcN2 += (cAliasSD2)->E1_VALOR 
   			     Else
   			     nAcN2 += xMoeda(nTotal	,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO) //WER
   			    EndIf  
   			    			
			   If SF4->F4_AGREG == "D"
				   nAcN2 -= xMoeda(nTotICM,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)
			   EndIf
            EndIf

			nAcN4 += xMoeda(nTotICM,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)
			nAcN5 += xMoeda(nTotIPI,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)
		Else
    		
			If Empty(D2_CODISS) .And. SD2->D2_VALISS == 0 // ISS
	
			Endif
			nAcN1 += D2_QUANT

			If SF4->F4_AGREG <> "N"  
			    
			    If mv_par17 == 2
   			     nAcN2 += IIF(!((cAliasSF2)->F2_TIPO $ "IP"),(cAliasSD2)->E1_VALOR,0) 
   			     Else
   			     nAcN2 += IIF(!((cAliasSF2)->F2_TIPO $ "IP"),xMoeda(D2_TOTAL,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO),0) //WER
   			    EndIf    
   			    
				If SF4->F4_AGREG = "D"
					nAcN2 -= xMoeda(D2_VALICM,1,MV_PAR16,SD2->D2_EMISSAO)
				EndIf
			Endif

			If (cAliasSF2)->F2_TIPO == "I"
				nCompIcm+=xMoeda(D2_TOTAL,1,MV_PAR16,SD2->D2_EMISSAO)
			EndIf
			If Empty(D2_CODISS) .And. (cAliasSD2)->D2_VALISS == 0 // ISS
				nAcN4 += xMoeda(D2_VALICM,1,MV_PAR16,SD2->D2_EMISSAO)
			EndIf

			nAcN5 += xMoeda(D2_VALIPI,1,MV_PAR16,(cAliasSD2)->D2_EMISSAO)

		Endif
		dEmiDia := (cAliasSD2)->D2_EMISSAO
		If nReg==0
			dbSkip()
		Endif
	End // Nota

	If (nAcN2+nAcN4+nAcN5) # 0
		nAcN3 := xMoeda(nFrete+nSeguro+nDespesa,1,MV_PAR16,dEmiDia)
		If nAcN3 != 0 .Or. nFretAut != 0
			nIPIDesp := xMoeda(nValIPI,1,MV_PAR16,dEmiDia) - nAcN5
			nICMDesp := xMoeda(nValICM,1,MV_PAR16,dEmiDia) - nAcN4
			nAcN5 := xMoeda(nValIPI,1,MV_PAR16,dEmiDia)
			nAcN4 := xMoeda(nValICM,1,MV_PAR16,dEmiDia)
		EndIf
		nAcN6 := nAcN2 + nAcN3 + nAcN5 + xMoeda(nTotRet,1,MV_PAR16,dEmiDia) +If(lFretAut,nIcmAuto,0)
		nVlrISS:= xMoeda(nValISS,1,MV_PAR16,dEmiDia)
	  	@Li ,   0 PSAY STR0014+cNota+" / "+cSerie+" ---->"		    // "TOTAL DA NOTA - "
        @Li ,  46 PSAY nAcN1    PICTURE PESQPICTQT("D2_QUANT",16)   // QTDE
        @Li ,  80 PSAY nAcN2    PICTURE TM(nAcN2    ,16)            //
		@Li , 123 PSAY nAcN5    PICTURE TM(nAcN5	,16)            //
		@Li , 141 PSAY nAcN4    PICTURE TM(nAcN4	,16)
		@Li , 158 PSAY nVlrISS  PICTURE TM(nVlrISS	,16)
		@Li , 184 PSAY nAcN3+nFretAut PICTURE TM(nAcN3	,16)
		@Li , 204 PSAY nAcN6    PICTURE TM(nAcN6	,16)
		Li++  
		@Li , 00 PSAY replicate("-", limite)
		// @Li ,  0 PSAY __PrtThinLine() //WER VOLTAR
		Li++
		nAcG1 += nAcN1
		nAcG2 += nAcN2
		nAcG3 += nAcN3+nFretAut
		nAcG4 += nAcN4
		nAcG5 += nAcN5
		nAcG6 += nAcN6
		nAcG7 += nVlrISS
	EndIf

	nAcD1 += nAcN1
	nAcD2 += nAcN2
	nAcD3 += nAcN3+nFretAut
	nAcD4 += nAcN4
	nAcD5 += nAcN5
	nAcD6 += nAcN6
	nAcD7 += nVlrISS

	nAcn1 := 0
	nAcn2 := 0
	nAcn3 := 0
	nAcn4 := 0
	nAcn5 := 0
	nAcn6 := 0
    nVlrISS := 0
	nCompIcm := 0

	dbSelectArea(cAliasSF2)
	If !lQuery
		dbSkip()
	Endif

	If nAcd1+nAcD4+nAcD5 > 0 .And. ( dEmisAnt != F2_EMISSAO .Or. Eof() )
		Li++
	   	@Li ,  0 PSAY STR0015+dtoc(dEmisAnt)		//"TOTAL DO DIA  ----> "
        @Li , 46 PSAY nAcD1 PICTURE PESQPICTQT("D2_QUANT",16)
        @Li , 80 PSAY nAcD2 PICTURE TM(nAcD2,16)
		@Li ,123 PSAY nAcD5 PICTURE TM(nAcD5,16)
     	@Li ,141 PSAY nAcD4 PICTURE TM(nAcD4,16)
		@Li ,158 PSAY nAcD7 PICTURE TM(nAcD7,16)
		@Li ,184 PSAY nAcD3 PICTURE TM(nAcD3,16)
		@Li ,204 PSAY nAcD6 PICTURE TM(nAcD6,16)
				
		Li++
		@Li ,  0 PSAY __PrtThinLine() //WER VOLTAR
		Li+=2
		nAcD1 := 0
		nAcD2 := 0
		nAcD3 := 0
		nAcD4 := 0
		nAcD5 := 0
		nAcD6 := 0
		nAcD7 := 0
	Endif

End // Documento, Serie
If nACG1 <> 0 .Or. nACG2 <> 0 .Or. nACG5 <> 0 .Or. nACG4 <> 0 .Or. nACG7 <> 0 .Or. nACG3 <> 0 .Or. nACG6 <> 0 
	IF li >= 52
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	EndIf
	
	
	@Li ,  0 PSAY STR0016	//"TOTAL GERAL            ---->"
	@Li , 46 PSAY nAcG1 PICTURE PESQPICTQT("D2_QUANT",16)
	@Li , 80 PSAY nAcG2 PICTURE TM(nAcG2,16)
	@Li ,123 PSAY nAcG5	PICTURE TM(nAcG5,16)
	@Li ,141 PSAY nAcG4	PICTURE TM(nAcG4,16)
	@Li ,158 PSAY nAcG7	PICTURE TM(nAcG7,16)
	@Li ,184 PSAY nAcG3	PICTURE TM(nAcG3,16)
	@Li ,204 PSAY nAcG6	PICTURE TM(nAcG6,16)
	Li++
	roda(cbcont,cbtxt,tamanho)
EndIf
If lQuery
	DbSelectArea(cAliasSF2)
	DbCloseArea()
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve condicao original ao SF2 e apaga arquivo de trabalho.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RetIndex("SF2")
	dbSelectArea("SF2")
	dbClearFilter()
	dbSetOrder(1)

	cIndex += OrdBagExt()
	If File(cIndex)
		Ferase(cIndex)
	Endif
Endif

dbSelectArea("SD2")
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Leonardo Gentile    º Data ³  18/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR550 AP6                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

AADD(aHelpPor,"Indica se os itens da nota serao     ")
AADD(aHelpPor,"impressos (analitico),nao (sintetico)")

AADD(aHelpSpa,"Indica si los itemes de la factura   ")
AADD(aHelpSpa,"seran impresos (analitico) o no      ")
AADD(aHelpSpa,"(sintetico).                         ")

cKey := "P.MTR55021."                                                                                                                                                                                                     

u_INPutSx1(cPerg,"21","Tipo do relatório  :","Tipo de Informe","Report Type?","mv_chl","N",01,0,0,"C","","","","","mv_par21","Analitico","Analitico","Detailed","","Sintetico","Sintetic","Sumaarized","","","","","","","","","")

PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return