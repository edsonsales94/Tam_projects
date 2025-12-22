#INCLUDE "FINR150.CH"
#Include "PROTHEUS.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINR150	³ Autor ³ Wagner Xavier   	    ³ Data ³ 02.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posi‡„o dos Titulos a Pagar			            		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR150(void)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parƒmetros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IFINR150()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 :=OemToAnsi(STR0001)  //"Imprime a posi‡„o dos titulos a pagar relativo a data base"
Local cDesc2 :=OemToAnsi(STR0002)  //"do sistema."
LOCAL cDesc3 :=""
LOCAL wnrel
LOCAL cString:="SE2"
LOCAL nRegEmp := SM0->(RecNo())
Local dOldDtBase := dDataBase

PRIVATE aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="FINR150"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg	 :="FIN15B"
PRIVATE nJuros  :=0
PRIVATE tamanho:="G"

PRIVATE titulo  := ""
PRIVATE cabec1
PRIVATE cabec2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi(STR0005)  //"Posicao dos Titulos a Pagar"
cabec1 := OemToAnsi(STR0006)  //"Codigo Nome do Fornecedor   PRF-Numero         Tp  Natureza    Data de  Vencto   Vencto  Banco  Valor Original |        Titulos vencidos          | Titulos a vencer | Porta-|  Vlr.juros ou   Dias   Historico     "
cabec2 := OemToAnsi(STR0007)  //"                            Parcela                            Emissao  Titulo    Real                         |  Valor nominal   Valor corrigido |   Valor nominal  | dor   |   permanencia   Atraso               "

//Nao retire esta chamada. Verifique antes !!!
//Ela é necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSx1()
Pergunte("FIN15B",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01 Do Numero ?                   
//³ mv_par02 Ate o Numero ?                
//³ mv_par03 Do Prefixo ?                  
//³ mv_par04 Ate o Prefixo ?               
//³ mv_par05 Da Natureza ?                 
//³ mv_par06 Ate a Natureza ?              
//³ mv_par07 Do Vencimento ?               
//³ mv_par08 Ate o Vencimento ?            
//³ mv_par09 Do Banco ?                    
//³ mv_par10 Ate o Banco ?                 
//³ mv_par11 Do Fornecedor ?               
//³ mv_par12 Ate o Fornecedor ?            
//³ mv_par13 Qual Moeda ?                  
//³ mv_par14 Imprime Provisorios ?         
//³ mv_par15 Converte Venci pela ?         
//³ mv_par16 Imprime Relatorio ?           
//³ mv_par17 Cons.Filiais abaixo ?         
//³ mv_par18 Da Filial ?                   
//³ mv_par19 Ate a Filial ?                
//³ mv_par20 Da Loja ?                     
//³ mv_par21 Ate a Loja ?                  
//³ mv_par22 Considera Adiantam. ?         
//³ mv_par23 Imprime Nome ?                
//³ mv_par24 Outras Moedas ?               
//³ mv_par25 Imprimir Tipos ?         
//³ mv_par26 Nao Imprimir Tipos ?
//³ mv_par27 Somente Tit.p/Fluxo ?
//³ mv_par28 Compoe Saldo por ?
//³ mv_par29 Quanto a Taxa?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	IF TcSrvType() == "AS/400" .and. Select("__SE2") == 0
		ChkFile("SE2",.f.,"__SE2")
	Endif
#ENDIF

wnrel := "FINR150"            //Nome Default do relatorio em Disco
aOrd	:= {OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0010) ,;  //"Por Numero"###"Por Natureza"###"Por Vencimento"
OemToAnsi(STR0011),OemToAnsi(STR0012),OemToAnsi(STR0013),OemToAnsi(STR0014),"Por Bordero" }  //"Por Banco"###"Fornecedor"###"Por Emissao"###"Por Cod.Fornec."
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa150Imp(@lEnd,wnRel,cString)},Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura empresa / filial original    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SM0->(dbGoto(nRegEmp))
cFilAnt := SM0->M0_CODFIL

//Acerta a database de acordo com a database real do sistema
/*Retirado por Alidio
//If mv_par21 == 1    // Considera Data Base
//	dDataBase := dOldDtBase
//Endif	*/

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA150Imp ³ Autor ³ Wagner Xavier 	    ³ Data ³ 02.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posi‡„o dos Titulos a Pagar								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA150Imp(lEnd,wnRel,cString)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd	  - A‡Æo do Codeblock			    				  ³±±
±±³			 ³ wnRel   - T¡tulo do relat¢rio 							  ³±±
±±³			 ³ cString - Mensagem							 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA150Imp(lEnd,wnRel,cString)

LOCAL CbCont
LOCAL CbTxt
LOCAL nOrdem :=0
LOCAL nQualIndice := 0
LOCAL lContinua := .T.
LOCAL nTit0:=0,nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0
LOCAL nTot0:=0,nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTotTit:=0,nTotJ:=0,nTotJur:=0
LOCAL nFil0:=0,nFil1:=0,nFil2:=0,nFil3:=0,nFil4:=0,nFilTit:=0,nFilJ:=0
LOCAL cCond1,cCond2,cCarAnt,nSaldo:=0,nAtraso:=0
LOCAL dDataReaj
LOCAL dDataAnt := dDataBase , lQuebra
LOCAL nMestit0:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
LOCAL dDtContab
LOCAL cIndexSe2
LOCAL cChaveSe2
LOCAL nIndexSE2
LOCAL cFilDe,cFilAte
Local nTotsRec := SE2->(RecCount())
Local aTamFor := TAMSX3("E2_FORNECE")
Local nDecs := Msdecimais(mv_par13)
Local lFr150Flt := EXISTBLOCK("FR150FLT")
Local cFr150Flt := ""
Local cmv_par13,cmv_par14,cmv_par15,cmv_par16,cmv_par17,cmv_par18,cmv_par19,cmv_par20,cmv_par21
Local cmv_par22,cmv_par23,cmv_par24,cmv_par25,cmv_par26,cmv_par27,cmv_par28,cmv_par29

#IFDEF TOP
	Local nI := 0
	Local aStru := SE2->(dbStruct())
#ENDIF

Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
PRIVATE dBaixa := dDataBase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para Filtrar 										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Localiza‡”es ArgentinaÄÙ
If lFr150Flt
	cFr150Flt := EXECBLOCK("Fr150FLT",.f.,.f.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impress„o do Cabe‡alho e Rodap‚ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := OemToAnsi(STR0015)  //"* indica titulo provisorio, P indica Saldo Parcial"
cbcont := 0
li 	 := 80
m_pag  := 1

nOrdem := aReturn[8]
cMoeda := LTrim(Str(mv_par13))
Titulo += OemToAnsi(STR0035)+GetMv("MV_MOEDA"+cMoeda)  //" em "

// Anulado os tipos de pagamentos antecipados para nao deixar os valores negativos, em 20/10/2004 - Ronilton
MVPAGANT := "XXX"
mv_par22 := 1 // Considera o parametro Imprime Adiantamento, como sendo sempre 'Sim'

dbSelectArea ( "SE2" )
Set Softseek On

If mv_par17 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par18
	cFilAte:= mv_par19
Endif

//Acerta a database de acordo com o parametro
//Retirado por Alidio
//If mv_par21 == 1    // Considera Data Base
//	dDataBase := mv_par33
//Endif

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte
	
	dbSelectArea("SE2")
	cFilAnt := SM0->M0_CODFIL
	
	#IFDEF TOP
		if TcSrvType() != "AS/400"
			cQuery := "SELECT * "
			cQuery += "  FROM "+	RetSqlName("SE2")
			cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
			cQuery += "   AND D_E_L_E_T_ <> '*' "
		endif
	#ENDIF
	
	If nOrdem == 1
		SE2->(dbSetOrder(1))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
		#ENDIF
		cCond1 := "E2_PREFIXO <= mv_par04"
		cCond2 := "E2_PREFIXO"
		titulo += OemToAnsi(STR0016)  //" - Por Numero"
		nQualIndice := 1
	Elseif nOrdem == 2
		SE2->(dbSetOrder(2))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par05,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par05,.T.)
		#ENDIF
		cCond1 := "E2_NATUREZ <= mv_par06"
		cCond2 := "E2_NATUREZ"
		titulo += OemToAnsi(STR0017)  //" - Por Natureza"
		nQualIndice := 2
	Elseif nOrdem == 3
		SE2->(dbSetOrder(3))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
		#ENDIF
		cCond1 := "E2_VENCREA <= mv_par08"
		cCond2 := "E2_VENCREA"
		titulo += OemToAnsi(STR0018)  //" - Por Vencimento"
		nQualIndice := 3
	Elseif nOrdem == 4 
	    cChaveSe2 := "E2_FILIAL+E2_PORTADO+E2_AGENCIA+E2_CONTA+E2_VENCREA+E2_PREFIXO+E2_NUM"     
		SE2->(dbSetOrder(15))   // Novo indice criado para ordenar a agencia, valor anterior  (4)
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par09,.T.)
			else
				cOrder := SqlOrder(cChaveSe2)
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par09,.T.)
		#ENDIF
		cCond1 := "E2_PORTADO <= mv_par10"
	    cCond2 := "E2_AGENCIA"               // Testes Alidio                     //	cCond2 := "E2_PORTADO"
		titulo += OemToAnsi(STR0031)  //" - Por Banco"
		nQualIndice := 15  // Valor anterior 4 , alterado para 15 para atender a ordem agencia
	Elseif nOrdem == 6
		SE2->(dbSetOrder(5))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2"),.T.)   //Valor Anterior dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)  Alidio
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2"),.T.)  //Valor anterior	dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)  Alidio
		#ENDIF
		cCond1 := "E2_EMISSAO"     // Valor anterior  "E2_EMISSAO <= mv_par14"  Alidio
		cCond2 := "E2_EMISSAO"
		titulo += OemToAnsi(STR0019)  //" - Por Emissao"
		nQualIndice := 5
	Elseif nOrdem == 7
		SE2->(dbSetOrder(6))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par11,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par11,.T.)
		#ENDIF
		cCond1 := "E2_FORNECE <= mv_par12"
		cCond2 := "E2_FORNECE"
		titulo += OemToAnsi(STR0020)  //" - Por Cod.Fornecedor"
		nQualIndice := 6
	Elseif nOrdem == 8
		cChaveSe2 := "E2_FILIAL+E2_NUMBOR"
		SE2->(dbSetOrder(6))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				cIndexSe2 := CriaTrab(nil,.f.)
				IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi(STR0021))  // //"Selecionando Registros..."
				nIndexSE2 := RetIndex("SE2")
				dbSetOrder(nIndexSe2+1)
				dbSeek(xFilial("SE2"))
			else
				cOrder := SqlOrder(cChaveSe2)
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par11,.T.)
		#ENDIF
		cCond1 := "E2_PORTADO <= mv_par10"
		cCond2 := "E2_NUMBOR"
		titulo += " - Por Bordero"
		nQualIndice := 7
	Else
		cChaveSe2 := "E2_FILIAL+E2_NOMFOR+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				cIndexSe2 := CriaTrab(nil,.f.)
				IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi(STR0021))  // //"Selecionando Registros..."
				nIndexSE2 := RetIndex("SE2")
				dbSetOrder(nIndexSe2+1)
				dbSeek(xFilial("SE2"))
			else
				cOrder := SqlOrder(cChaveSe2)
			endif
		#ELSE
			cIndexSe2 := CriaTrab(nil,.f.)
			IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi(STR0021))  // //"Selecionando Registros..."
			nIndexSE2 := RetIndex("SE2")
			dbSetIndex(cIndexSe2+OrdBagExt())
			dbSetOrder(nIndexSe2+1)
			dbSeek(xFilial("SE2"))
		#ENDIF
		cCond1 := "E2_FORNECE <= mv_par12"
		cCond2 := "E2_FORNECE+E2_LOJA"
		titulo += OemToAnsi(STR0022)  //" - Por Fornecedor"
		nQualIndice := IndexOrd()
	EndIF
	
	If mv_par16 == 1
		titulo += OemToAnsi(STR0023)  //" - Analitico"
	Else
		titulo += OemToAnsi(STR0024)  // " - Sintetico"
		cabec1 := OemToAnsi(STR0033)  // "                                                                                          |        Titulos vencidos         |    Titulos a vencer     |           Valor dos juros ou                       (Vencidos+Vencer)"
		cabec2 := OemToAnsi(STR0034)  // "                                                                                          | Valor nominal   Valor corrigido |      Valor nominal      |            com. permanencia                                         "
	EndIf
	
	dbSelectArea("SE2")
	cFilterUser:=aReturn[7]
	
	Set Softseek Off
	
	#IFDEF TOP
		if TcSrvType() != "AS/400"
			cQuery += " AND E2_NUM     BETWEEN '"+ mv_par01+ "' AND '"+ mv_par02 + "'"
			cQuery += " AND E2_PREFIXO BETWEEN '"+ mv_par03+ "' AND '"+ mv_par04 + "'"
			cQuery += " AND (E2_MULTNAT = '1' OR (E2_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'))"
			cQuery += " AND E2_VENCREA BETWEEN '"+ DTOS(mv_par07)+ "' AND '"+ DTOS(mv_par08) + "'"
			cQuery += " AND E2_PORTADO BETWEEN '"+ mv_par09+ "' AND '"+ mv_par10 + "'"
			cQuery += " AND E2_FORNECE BETWEEN '"+ mv_par11+ "' AND '"+ mv_par12 + "'"
			//			cQuery += " AND E2_EMISSAO BETWEEN '"+ DTOS(mv_par13)+ "' AND '"+ DTOS(mv_par14) + "'"    Alidio
			cQuery += " AND E2_LOJA    BETWEEN '"+ mv_par20 + "' AND '"+ mv_par21 + "'"
			//cQuery += " AND E2_EMISSAO <= '" + DTOS(dDataBase) +"'"  // Enibido em 21/12/04 - Ronilto
			If !Empty(mv_par25) // Deseja imprimir apenas os tipos do parametro 25
				cQuery += " AND E2_TIPO IN "+FormatIn(mv_par25,";")
			ElseIf !Empty(Mv_par26) // Deseja excluir os tipos do parametro 31
				cQuery += " AND E2_TIPO NOT IN "+FormatIn(mv_par26,";")
			EndIf
			If mv_par27 == 1
				cQuery += " AND E2_FLUXO <> 'N'"
			Endif
			cQuery += " ORDER BY "+ cOrder
			
			cQuery := ChangeQuery(cQuery)
			
			dbSelectArea("SE2")
			dbCloseArea()
			dbSelectArea("SA2")
			
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)
			
			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		endif
	#ENDIF
	
	SetRegua(nTotsRec)
/*	
	If MV_MULNATP .And. nOrdem == 2
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Guardando parametros anteriores   ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        cmv_par13:= mv_par13
        cmv_par14:= mv_par14
        cmv_par15:= mv_par15
        cmv_par16:= mv_par16
        cmv_par17:= mv_par17
        cmv_par18:= mv_par18
        cmv_par19:= mv_par19
        cmv_par20:= mv_par20
        cmv_par21:= mv_par21
        cmv_par22:= mv_par22
        cmv_par23:= mv_par23
        cmv_par24:= mv_par24
        cmv_par25:= mv_par25
        cmv_par26:= mv_par26
        cmv_par27:= mv_par27
        cmv_par28:= mv_par28
        cmv_par29:= mv_par29
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Modificando parametros para adequar a funcao Finr155() ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        mv_par13:= Ctod(Space(6))   //- Da Emissao ?                  
        mv_par14:= dDataBase        //- Ate a Emissao ?               
        mv_par18:= Ctod("01/01/05") //- Da data contabil ?           
        mv_par19:= Ctod("31/12/06") //- Ate data contabil ?           
        mv_par21:= 2                //- Compoem Saldo Retroativo ? 1=Sim 2=Nao    
        mv_par33:= dDataBase        //- Data Base ?                   
        mv_par36:= 1                //- Tit. Emissao Futura? 1=Sim 2=Nao          

        mv_par15:= cmv_par13        //- Qual Moeda ?                  13 
        mv_par16:= cmv_par14        //- Imprime Provisorios ?         14
        mv_par17:= cmv_par15        //- Converte Venci pela ?         15       
        mv_par20:= cmv_par16        //- Imprime Relatorio ?           16
        mv_par22:= cmv_par17        //- Cons.Filiais abaixo ?         17
        mv_par23:= cmv_par18        //- Da Filial ?                   18
        mv_par24:= cmv_par19        //- Ate a Filial ?                19
        mv_par25:= cmv_par20        //- Da Loja ?                     20
        mv_par26:= cmv_par21        //- Ate a Loja ?                  21
        mv_par27:= cmv_par22        //- Considera Adiantam. ?         22
        mv_par28:= cmv_par23        //- Imprime Nome ?                23
        mv_par29:= cmv_par24        //- Outras Moedas ?               24
        mv_par30:= cmv_par25        //- Imprimir Tipos ?              25
        mv_par31:= cmv_par26        //- Nao Imprimir Tipos ?          26
        mv_par32:= cmv_par27        //- Somente Tit.p/Fluxo ?         27
        mv_par34:= cmv_par28        //- Compoe Saldo por ?            28
        mv_par35:= cmv_par29        //- Quanto a Taxa?                29
	
		Finr155(cFr150Flt, lEnd, @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ )
		
		#IFDEF TOP
			if TcSrvType() != "AS/400"
				dbSelectArea("SE2")
				dbCloseArea()
				ChKFile("SE2")
				dbSetOrder(1)
			endif
		#ENDIF
		If Empty(xFilial("SE2"))
			Exit
		Endif
		dbSelectArea("SM0")
		dbSkip()
		Loop
	Endif
*/	
	While &cCond1 .and. !Eof() .and. lContinua .and. E2_FILIAL == xFilial("SE2")
		
		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0025)  //"CANCELADO PELO OPERADOR"
			Exit
		End
		
		IncRegua()
		
		dbSelectArea("SE2")
		
		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega data do registro para permitir ³
		//³ posterior analise de quebra por mes.	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)
		
		cCarAnt := &cCond2
		
		While &cCond2 == cCarAnt .and. !Eof() .and. lContinua .and. E2_FILIAL == xFilial("SE2")
			
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0025)  //"CANCELADO PELO OPERADOR"
				Exit
			End
			
			IncRegua()
			
			dbSelectArea("SE2")
			
			//- Filtro de usuario 
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSkip()
				Loop
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario no ponto de entrada.             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lFr150flt
				If &cFr150flt
					DbSkip()
					Loop
				Endif
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se trata-se de abatimento ou provisorio, ou ³
			//³ Somente titulos emitidos ate a data base				   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF SE2->E2_TIPO $ MVABATIM //.Or. SE2 -> E2_EMISSAO > dDataBase  // Enibido em 21/12/04 - Ronilto
				dbSkip()
				Loop
			EndIF
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ser  impresso titulos provis¢rios		   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF E2_TIPO $ MVPROVIS .and. mv_par14 == 2
				dbSkip()
				Loop
			EndIF
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ser  impresso titulos de Adiantamento	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par22 == 2
				dbSkip()
				Loop
			EndIF
			
			// dDtContab para casos em que o campo E2_EMIS1 esteja vazio
			// compatibilizando com a vers„o 2.04 que n„o gerava para titulos
			// de ISS e FunRural
			
			dDtContab := Iif(Empty(SE2->E2_EMIS1),SE2->E2_EMISSAO,SE2->E2_EMIS1)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se esta dentro dos parametros ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF E2_NUM < mv_par01      .OR. E2_NUM > mv_par02 .OR. ;
				E2_PREFIXO < mv_par03  .OR. E2_PREFIXO > mv_par04 .OR. ;
				E2_NATUREZ < mv_par05  .OR. E2_NATUREZ > mv_par06 .OR. ;
				E2_VENCREA < mv_par07  .OR. E2_VENCREA > mv_par08 .OR. ;
				E2_PORTADO < mv_par09  .OR. E2_PORTADO > mv_par10 .OR. ;
				E2_FORNECE < mv_par11  .OR. E2_FORNECE > mv_par12 .OR. ;
				E2_LOJA    < mv_par20  .OR. E2_LOJA    > mv_par21 //.OR. ;
				
				//		E2_EMISSAO < mv_par13  .OR. E2_EMISSAO > mv_par14 .OR. ;   Alidio
				//		E2_EMISSAO > dDataBase .OR. dDtContab  < mv_par18 .OR. ;   Alidio
				//					E2_LOJA    < mv_par25  .OR. E2_LOJA    > mv_par26 .OR. ;
				//		dDtContab  > mv_par19  .Or. !&(fr150IndR())                Alidio
				
				dbSkip()
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se titulo, apesar do E2_SALDO = 0, deve aparecer ou ³
			//³ nÆo no relat¢rio quando se considera database (mv_par21 = 1) ³
			//³ ou caso nÆo se considere a database, se o titulo foi totalmen³
			//³ te baixado.																  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SE2")
			//		IF !Empty(SE2->E2_BAIXA) .and. Iif(mv_par21 == 2 ,SE2->E2_SALDO == 0 ,;
			//				IIF(mv_par28 == 1,(SE2->E2_SALDO == 0 .and. SE2->E2_BAIXA <= dDataBase),.F.))
			//			dbSkip()
			//			Loop
			//		EndIF
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se deve imprimir outras moedas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par24 == 2 // nao imprime
				if SE2->E2_MOEDA != mv_par13 //verifica moeda do campo=moeda parametro
					dbSkip()
					Loop
				endif
			Endif
			
			dbSelectArea("SA2")
			MSSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
			dbSelectArea("SE2")
			
			dDataReaj := IIF(SE2->E2_VENCREA < dDataBase ,;
			IIF(mv_par15=1,dDataBase,SE2->E2_VENCREA),;
			dDataBase)
			
			//	If mv_par21 == 1
			//		nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par13,dDataReaj,,SE2->E2_LOJA,,If(cPaisLoc=="BRA",If(mv_par29==1,SE2->E2_TXMOEDA,Nil),0),IIF(mv_par28 == 2,3,1)) // 1 = DT BAIXA    3 = DT DIGIT
			// Subtrai decrescimo para recompor o saldo na data escolhida.
			//		If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_DECRESC > 0 .And. SE2->E2_SDDECRE == 0
			nSAldo -= SE2->E2_DECRESC
			//			Endif
			// Soma Acrescimo para recompor o saldo na data escolhida.
			//			If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_ACRESC > 0 .And. SE2->E2_SDACRES == 0
			nSAldo += SE2->E2_ACRESC
			//			Endif
			//		Else
			nSaldo := xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,mv_par13,dDataReaj,ndecs+1,If(cPaisLoc=="BRA",If(mv_par29==1,SE2->E2_TXMOEDA,Nil),0))
			//	Endif
			//		If ! (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. ;
			//		   ! ( MV_PAR21 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
			//			nSaldo-=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",mv_par13,dDataReaj,SE2->E2_FORNECE,SE2->E2_LOJA)
			//		EndIf
			
			nSaldo:=Round(NoRound(nSaldo,3),2)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Desconsidera caso saldo seja menor ou igual a zero   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nSaldo <= 0
				dbSkip()
				Loop
			Endif
			
			IF li > 58
				nAtuSM0 := SM0->(Recno())
				SM0->(dbGoto(nRegSM0))
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				SM0->(dbGoTo(nAtuSM0))
			EndIF
			
			If mv_par16 == 1
				@li,	0 PSAY SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+SubStr( SE2->E2_NOMFOR, 1, 15 )
				li := IIf (aTamFor[1] > 6,li+1,li)
				@li, 26 PSAY SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA
				If SE2->E2_ORIGEM <> 'MATA100'
  				  @li, 47 PSAY SE2->E2_PEDIDO
  				Else 
  				  li := fVerPedNf(SE2->E2_FILIAL,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_FORNECE,SE2->E2_LOJA,li)
  				EndIf  
				@li, 55 PSAY SE2->E2_TIPO
				@li, 59 PSAY SE2->E2_NATUREZ
				@li, 70 PSAY SE2->E2_EMISSAO
				@Li, 81 PSAY SE2->E2_VENCTO
				@li, 92 PSAY SE2->E2_VENCREA
				@li,104 PSAY xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par13,SE2->E2_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",If(mv_par29==1,SE2->E2_TXMOEDA,Nil),0)) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture PesqPict("SE2","E2_VALOR",14,mv_par13)
			EndIf
			#IFDEF TOP
				If TcSrvType() == "AS/400"
					dbSetOrder( nQualIndice )
				Endif
			#ELSE
				dbSetOrder( nQualIndice )
			#ENDIF
			
			If dDataBase > SE2->E2_VENCREA 		//vencidos
				If mv_par16 == 1
					@ li, 120 PSAY nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture TM(nSaldo,14,nDecs)
				EndIf
				nJuros:=0
				dBaixa:=dDataBase
				fa080Juros(mv_par13)
				dbSelectArea("SE2")
				If mv_par16 == 1
					@li,137 PSAY (nSaldo+nJuros) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture TM(nSaldo+nJuros,14,nDecs)
				EndIf
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par13,SE2->E2_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",If(mv_par29==1,SE2->E2_TXMOEDA,Nil),0))
					nTit1 -= nSaldo
					nTit2 -= nSaldo+nJuros
					nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par13,SE2->E2_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",If(mv_par29==1,SE2->E2_TXMOEDA,Nil),0))
					nMesTit1 -= nSaldo
					nMesTit2 -= nSaldo+nJuros
				Else
					nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par13,SE2->E2_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",If(mv_par29==1,SE2->E2_TXMOEDA,Nil),0))
					nTit1 += nSaldo
					nTit2 += nSaldo+nJuros
					nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par13,SE2->E2_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",If(mv_par29==1,SE2->E2_TXMOEDA,Nil),0))
					nMesTit1 += nSaldo
					nMesTit2 += nSaldo+nJuros
				Endif
				nTotJur += (nJuros)
				nMesTitJ += (nJuros)
			Else				  //a vencer
				If mv_par16 == 1
					@li,155 PSAY nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture TM(nSaldo,14,nDecs)
				EndIf
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par13,SE2->E2_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",If(mv_par29==1,SE2->E2_TXMOEDA,Nil),0))
					nTit3 -= nSaldo
					nTit4 -= nSaldo
					nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par13,SE2->E2_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",If(mv_par29==1,SE2->E2_TXMOEDA,Nil),0))
					nMesTit3 -= nSaldo
					nMesTit4 -= nSaldo
				Else
					nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par13,SE2->E2_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",If(mv_par29==1,SE2->E2_TXMOEDA,Nil),0))
					nTit3 += nSaldo
					nTit4 += nSaldo
					nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par13,SE2->E2_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",If(mv_par29==1,SE2->E2_TXMOEDA,Nil),0))
					nMesTit3 += nSaldo
					nMesTit4 += nSaldo
				Endif
			Endif
			If mv_par16 == 1
//				@Li,165 PSAY SE2->E2_PORTADO
//				@Li,173 PSAY SE2->E2_AGENCIA   // Testes Alidio Ribeiro 
				@Li,176 PSAY u_NomeFilial(SE2->E2_FILIAL)			
			EndIf
			If nJuros > 0
				If mv_par16 == 1
					@Li,173 PSAY nJuros Picture PesqPict("SE2","E2_JUROS",12,mv_par13)
				EndIf
				nJuros := 0
			Endif
			
			IF dDataBase > E2_VENCREA
				nAtraso:=dDataBase-E2_VENCTO
				IF Dow(E2_VENCTO) == 1 .Or. Dow(E2_VENCTO) == 7
					IF Dow(dBaixa) == 2 .and. nAtraso <= 2
						nAtraso:=0
					EndIF
				EndIF
				nAtraso:=IIF(nAtraso<0,0,nAtraso)
				IF nAtraso>0
					If mv_par16 == 1
					//	@li,189 PSAY nAtraso Picture "9999"
					EndIf
				EndIF
			EndIF
			If mv_par16 == 1
///				@li,181 PSAY SUBSTR(SE2->E2_HIST,1,24)+ ;
///				IIF(E2_TIPO $ MVPROVIS,"*"," ")+ ;
///				Iif(nSaldo == xMoeda(E2_VALOR,E2_MOEDA,mv_par13,dDataReaj,ndecs+1,If(cPaisLoc=="BRA",If(mv_par29==1,SE2->E2_TXMOEDA,Nil),0))," ","P")
			EndIf
			@li,181 PSAY SE2->E2_NUMBOR
			@li,188 PSAY SE2->E2_NUMCONT
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega data do registro para permitir ³
			//³ posterior analise de quebra por mes.	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)
			
			dbSkip()
			nTotTit ++
			nMesTTit ++
			nFiltit++
			nTit5 ++
			If mv_par16 == 1
				li ++
			EndIf
			
		EndDO
		
		IF nTit5 > 0 .and. nOrdem != 1
			SubTot150(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)
			If mv_par16 == 1
				li++
			EndIf
		EndIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quebra por mes		 		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lQuebra := .F.
		If nOrdem == 3 .and. Month(SE2->E2_VENCREA) # Month(dDataAnt)
			lQuebra := .T.
		Elseif nOrdem == 6 .and. Month(SE2->E2_EMISSAO) # Month(dDataAnt)
			lQuebra := .T.
		Endif
		If lQuebra .and. nMesTTit # 0
			ImpMes150(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nDecs)
			nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
		Endif
		
		dbSelectArea("SE2")
		
		nTot0 += nTit0
		nTot1 += nTit1
		nTot2 += nTit2
		nTot3 += nTit3
		nTot4 += nTit4
		nTotJ += nTotJur
		
		nFil0 += nTit0
		nFil1 += nTit1
		nFil2 += nTit2
		nFil3 += nTit3
		nFil4 += nTit4
		nFilJ += nTotJur
		Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur
	Enddo
	
	dbSelectArea("SE2")		// voltar para alias existente, se nao, nao funciona
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir TOTAL por filial somente quan-³
	//³ do houver mais do que 1 filial.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if mv_par17 == 1 .and. SM0->(Reccount()) > 1
		ImpFil150(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj,nDecs)
	Endif
	Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ
	If Empty(xFilial("SE2"))
		Exit
	Endif
	
	#IFDEF TOP
		if TcSrvType() != "AS/400"
			dbSelectArea("SE2")
			dbCloseArea()
			ChKFile("SE2")
			dbSetOrder(1)
		endif
	#ENDIF
	
	dbSelectArea("SM0")
	dbSkip()
EndDO

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL

IF li != 80
	If mv_par16 == 1
		li +=2
	Endif
	ImpTot150(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)
	cbcont := 1
	roda(cbcont,cbtxt,"G")
EndIF
Set Device To Screen

#IFNDEF TOP
	dbSelectArea( "SE2" )
	dbClearFil()
	RetIndex( "SE2" )
	If !Empty(cIndexSE2)
		FErase (cIndexSE2+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSetOrder(1)
	else
		dbSelectArea( "SE2" )
		dbClearFil()
		RetIndex( "SE2" )
		If !Empty(cIndexSE2)
			FErase (cIndexSE2+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubTot150 ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR SUBTOTAL DO RELATORIO 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubTot150() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SubTot150(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)

DEFAULT nDecs := Msdecimais(mv_par13)

If mv_par16 == 1
	li++
EndIf

IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

If nOrdem == 1 .Or. nOrdem == 4 .Or. nOrdem == 6
	@li,000 PSAY OemToAnsi(STR0026)  //"S U B - T O T A L ----> "
	@li,028 PSAY "Agencia.:"+" "+cCarAnt      // Teste Alidio -adelson
ElseIf nOrdem == 3
    @li,000 PSAY OemToAnsi(STR0026)  //"S U B - T O T A L ----> Geradado devido a coflito de concatenação - Adelson "
	@li,028 PSAY cCarAnt      // Correção devido a erro de Concatenação (caracter+data) - Adelson
ElseIf nOrdem == 2
	dbSelectArea("SED")
	dbSeek(xFilial("SED")+cCarAnt)
	@li,000 PSAY cCarAnt +" "+SED->ED_DESCRIC
Elseif nOrdem == 5
	@Li,000 PSAY IIF(mv_par23 == 1,SA2->A2_NREDUZ,SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
ElseIf nOrdem == 7
	@li,000 PSAY SA2->A2_COD+" "+SA2->A2_LOJA+" "+SA2->A2_NOME+" "+Substr(SA2->A2_TEL,1,15)
Elseif nOrdem == 8
	@Li,000 PSAY Padr("Bordero " +cCarAnt,50)
Endif
if mv_par16 == 1
	@li,104 PSAY nTit0		 Picture TM(nTit0,14,nDecs)
endif
@li,120 PSAY nTit1		 Picture TM(nTit1,14,nDecs)
@li,137 PSAY nTit2		 Picture TM(nTit2,14,nDecs)
@li,155 PSAY nTit3		 Picture TM(nTit3,14,nDecs)
/*If nTotJur > 0
	@li,173 PSAY nTotJur 	 Picture TM(nTotJur,12,nDecs) inibido para não aprecer mais 0.00 - adelson
 Endif*/
@li,204 PSAY nTit2+nTit3 Picture TM(nTit2+nTit3,16,nDecs)
li++
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpTot150 ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpTot150() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function ImpTot150(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par13)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0027)  //"T O T A L   G E R A L ----> "
@li,028 PSAY "("+ALLTRIM(STR(nTotTit))+" "+IIF(nTotTit > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")"  //"TITULOS"###"TITULO"
if mv_par16 == 1
	@li,096 PSAY nTot0		 Picture TM(nTot0,14,nDecs)
endif
@li,112 PSAY nTot1		 Picture TM(nTot1,14,nDecs)
@li,129 PSAY nTot2		 Picture TM(nTot2,14,nDecs)
@li,147 PSAY nTot3		 Picture TM(nTot3,14,nDecs)
//@li,173 PSAY nTotJ		 Picture TM(nTotJ,12,nDecs) - adelson
@li,204 PSAY nTot2+nTot3 Picture TM(nTot2+nTot3,16,nDecs)
li+=2
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpMes150 ³ Autor ³ Vinicius Barreira	  ³ Data ³ 12.12.94   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpMes150() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function ImpMes150(nMesTot0,nMesTot1,nMesTot2,nMesTot3,nMesTot4,nMesTTit,nMesTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par13)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0030)  //"T O T A L   D O  M E S ---> "
@li,028 PSAY "("+ALLTRIM(STR(nMesTTit))+" "+IIF(nMesTTit > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")"  //"TITULOS"###"TITULO"
if mv_par16 == 1
	@li,096 PSAY nMesTot0   Picture TM(nMesTot0,14,nDecs)
endif
@li,112 PSAY nMesTot1	Picture TM(nMesTot1,14,nDecs)
@li,129 PSAY nMesTot2	Picture TM(nMesTot2,14,nDecs)
@li,147 PSAY nMesTot3	Picture TM(nMesTot3,14,nDecs)
// @li,173 PSAY nMesTotJ	Picture TM(nMesTotJ,12,nDecs) - adelson
@li,204 PSAY nMesTot2+nMesTot3 Picture TM(nMesTot2+nMesTot3,16,nDecs)
li+=2
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ImpFil150³ Autor ³ Paulo Boschetti 	     ³ Data ³ 01.06.92³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpFil150()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico				   									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpFil150(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par13)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0032)+" "+cFilAnt  //"T O T A L   F I L I A L ----> "
if mv_par16 == 1
	@li,096 PSAY nFil0        Picture TM(nFil0,14,nDecs)
endif
@li,112 PSAY nFil1        Picture TM(nFil1,14,nDecs)
@li,129 PSAY nFil2        Picture TM(nFil2,14,nDecs)
@li,147 PSAY nFil3        Picture TM(nFil3,14,nDecs)
//@li,173 PSAY nFilJ		  Picture TM(nFilJ,12,nDecs) - adelson
@li,204 PSAY nFil2+nFil3 Picture TM(nFil2+nFil3,16,nDecs)
li+=2
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fr150Indr ³ Autor ³ Wagner           	  ³ Data ³ 12.12.94   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fr150IndR()
Local cString
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATENCAO !!!!                                               ³
//³ N„o adiconar mais nada a chave do filtro pois a mesma est  ³
//³ com 254 caracteres.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString := 'E2_FILIAL="'+xFilial()+'".And.'
cString += '(E2_MULTNAT="1" .OR. (E2_NATUREZ>="'+mv_par05+'".and.E2_NATUREZ<="'+mv_par06+'")).And.'
cString += 'E2_FORNECE>="'+mv_par11+'".and.E2_FORNECE<="'+mv_par12+'".And.'
cString += 'DTOS(E2_VENCREA)>="'+DTOS(mv_par07)+'".and.DTOS(E2_VENCREA)<="'+DTOS(mv_par08)+'"'
//cString += 'DTOS(E2_EMISSAO)>="'+DTOS(mv_par13)+'".and.DTOS(E2_EMISSAO)<="'+DTOS(mv_par14)+'"'   // Alidio
If !Empty(mv_par25) // Deseja imprimir apenas os tipos do parametro 30
	cString += '.And.E2_TIPO$"'+mv_par25+'"'
ElseIf !Empty(Mv_par26) // Deseja excluir os tipos do parametro 31
	cString += '.And.!(E2_TIPO$'+'"'+mv_par26+'")'
EndIf
IF mv_par27 == 1  // Apenas titulos que estarao no fluxo de caixa
	cString += '.And.(E2_FLUXO!="N")'
Endif

Return cString

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PutDtBase³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 18/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta parametro database do relat[orio.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Finr150.                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PutDtBase()
Local _sAlias	:= Alias()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek("FIN15033")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	MsUnlock()
Endif

dbSelectArea(_sAlias)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Claudio D. de Souza º Data ³08.07.2004   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Insere novas perguntas ao sx1                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR150                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

Aadd( aHelpPor, "Indica que o valor será convertido de  "  )
Aadd( aHelpPor, 'acordo com a "Taxa contradada" ou  de  '  )
Aadd( aHelpPor, 'acordo com a "Taxa normal". Se for esco-' )
Aadd( aHelpPor, 'lhida "Taxa contratada", o valor será  '  )
Aadd( aHelpPor, "convertido pela taxa contradada para o "  )
Aadd( aHelpPor, 'titulo. Se for escolhida "Taxa Normal" '  )
Aadd( aHelpPor, 'o valor será convertido pela taxa da   '  )
Aadd( aHelpPor, 'data base do sistema, ou se o titulo   '  )
Aadd( aHelpPor, 'estiver vencido, pela taxa da data     '  )
Aadd( aHelpPor, 'informada na pergunta'             		  )
Aadd( aHelpPor, '"Converte Venci Por?"'  		              )

Aadd( aHelpSpa, "Indica que el valor se convertira de "	)
Aadd( aHelpSpa, 'acuerdo con la "Tasa contratada" o la' 	)
Aadd( aHelpSpa, '"Tasa normal". Si se elige la ' 			)
Aadd( aHelpSpa, '"Tasa contratada", el valor se  '     	)
Aadd( aHelpSpa, "convertira por la tasa contratada para"	)
Aadd( aHelpSpa, 'el titulo. Si se elige la "Tasa Normal"')
Aadd( aHelpSpa, 'el valor se convertira por la tasa de la')
Aadd( aHelpSpa, 'fecha base del sistema o, si el titulo'	)
Aadd( aHelpSpa, 'estuviera vencido, por la tasa de la '	)
Aadd( aHelpSpa, 'fecha informada en la pregunta '			)
Aadd( aHelpSpa, '"¿Convierte Venc Por?"' )

Aadd( aHelpEng, "Determine if the value will be converted "	)
Aadd( aHelpEng, 'according to the "Hired rate" or to the  '	)
Aadd( aHelpEng, '"Normal rate". If a "Hired rate" is '  		)
Aadd( aHelpEng, 'chosen, the value will be converted by'		)
Aadd( aHelpEng, "the rate hired for the bill. However, if "	)
Aadd( aHelpEng, 'a "Normal rate" is chosen, the value will'	)
Aadd( aHelpEng, 'be converted by the rate of the system   '	)
Aadd( aHelpEng, 'base date, or if the bill is due, this   '	)
Aadd( aHelpEng, 'will be converted by the rate of the '		)
Aadd( aHelpEng, 'informed date found in query'					)
Aadd( aHelpEng, '"Convert Due Date By?"'							)

u_INPutSx1( "FIN15B", "29","Quanto a Taxa?","¿Cuanto a tasa?","How about rate?","mv_cht","N",1,0,1,"C","","","","",;
"mv_par29","Taxa Contratada","Tasa contratada","Hired Rate","","Taxa Normal","Tasa Normal","Normal Rate","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return

Static Function fVerPedNf(cFil,cSerie,cDoc,cFornece,cLoja,nLin)
  Local cQuery := ""
  Local cCount := 0
  Local cPedido := ""
  cQuery := " SELECT D1_PEDIDO
  cQuery += " FROM "+RetSqlName("SD1")+" SD1
  cQuery += " WHERE D_E_L_E_T_ <> '*' AND D1_FILIAL = '"+cFil+"' AND D1_DOC = '"+cDoc+"' AND  D1_SERIE = '"+cSerie+"' AND D1_FORNECE = '"+cFornece+"' AND D1_LOJA = '"+cLoja+"'
  cQuery += " GROUP BY D1_PEDIDO
  dbUseArea(.T.,"TOPCONN",TCGenQry(,	,ChangeQuery(cQuery)),"PED",.F.,.T.)
  While !PED->(Eof())
    cPedido += PED->D1_PEDIDO+","
    PED->(DbSkip())             
    cCount++
  End       
  If !Empty(cPedido)
    cPedido := Left(cPedido,Len(cPedido)-1)
    @nLin, 47 PSAY cPedido
    If cCount > 1
      nLin++
    EndIf  
  EndIf  
  
  DbCloseArea("PED")
  DbSelectArea("SE2") 

Return nLin
