#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INFINR30 º Autor ³ Ronilton O. Barros º Data ³  27/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gerenciador de relatorios MCT                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico INDT                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INFINR30()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2  := "de acordo com os parametros informados pelo usuario."
Local cDesc3  := "Despesas Aglutinado"
Local Titulo  := cDesc3
Local aOrd    := {}
Local cArq, nInd, nReg, cCusto, cInd, lAchou, cCCustoI, cCCustoF, vMens, cQry, lHibrido, aRegs, cQPA, lEstorno
Local cFilCTT := CTT->(XFILIAL())
Local cTpImp  := MVISS+";"+MVINSS+";"+MVTAXA+";"+MVTXA
Local vPerg   := {}

Private Limite   := 220
Private Tamanho  := "G"
Private NomeProg := "INFINR30"
Private nTipo    := 15
Private aReturn  := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey := 0
Private cPerg    := PADR("INFINR30",Len(SX1->X1_GRUPO))
Private m_pag    := 01
Private wnrel    := NomeProg
Private cString  := "SE5"
Private cCsvPath := GetTempPath() //path do arquivo texto
Private cCsvArq  := Trim(wnrel)+".xls"  //nome do arquivo csv
Private nHdl     := fCreate(cCsvPath+cCsvArq)   //arquivo para trabalho

aRegs := ValidPerg(cPerg)
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo    := If(aReturn[4]==1,15,18)
cCCustoI := mv_par03
cCCustoF := mv_par04
lHibrido := (mv_par09 == 4)
lEstorno := (mv_par10 == 1)   // Considera estornos

If mv_par09 < 3 .Or. lHibrido  // Se não for a opção Contábil ou Base MCT
	Titulo := AllTrim(Titulo)+ " (Base Oficial)"
	If mv_par09 <> 2
		Titulo += If( mv_par09 == 1 , " - Caixa", " - Hibrido")
	Else
		Titulo += " - Competencia"
		cQry   := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE2")+" WHERE D_E_L_E_T_ <> '*' AND "
		
		If mv_par05 == 1    // Considera Filial ==  1-Sim  2-Nao
			cQry += "E2_FILIAL >= '"+mv_par06+"' AND E2_FILIAL <= '"+mv_par07+"' AND "
		Else
			cQry += "E2_FILIAL = '"+xFilial("SE2")+"' AND "
		Endif
		
		/*___________________________________________________________________________________________
		¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
		¦¦+---------------------------------------------------------------------------------------+¦¦
		¦¦¦                 Filtro para titulos com origem do Compras / Financeiro                ¦¦¦
		¦¦+---------------------------------------------------------------------------------------+¦¦
		¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
		cQry += "((E2_ORIGEM <> 'GPEM670' AND E2_TIPO NOT IN "+FormatIn(cTpImp,";")+" AND "
		cQry += "(E2_PARCELA IN (' ','1','A') OR E2_ORIGEM = 'FINA050') AND "
		cQry += "E2_EMIS1 >= '"+Dtos(mv_par01)+"' AND E2_EMIS1 <= '"+Dtos(mv_par02)+"') OR "
		
		/*___________________________________________________________________________________________
		¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
		¦¦+---------------------------------------------------------------------------------------+¦¦
		¦¦¦                       Filtro para titulos com origem da Folha                         ¦¦¦
		¦¦+---------------------------------------------------------------------------------------+¦¦
		¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
		// Ignora títulos de férias. Os mesmos serão pegos em uma rotina específica
		cQry += "(E2_ORIGEM = 'GPEM670' AND E2_VERBAS NOT LIKE '%452%' AND E2_VERBAS NOT LIKE '%444%' AND "
		
		// Acerta filtro da data final para os titulos de 13o e 14o salario
		cDtFinal := Dtos(mv_par02)
		If SubStr(cDtFinal,5,2) == "12"
			cDtFinal := Stuff(cDtFinal,5,2,"14")
		Endif
		
		// Busca a data de competencia do titulo de RH
		cQry += "E2_DATARQ BETWEEN '"+SubStr(Dtos(mv_par01),1,6)+"' AND '"+SubStr(cDtFinal,1,6)+"'))"
		
		// Rotina de Busca de Dados --> INDACFG.PRW
		Processa({|| cArq:= u_INDADCOMP(cQry,mv_par01,mv_par02,"      ","ZZZZZZ",mv_par03,mv_par04,mv_par05,mv_par06,mv_par07,"001",mv_par08,"C") },"Filtro de Dados")
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processando Saidas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aStru := SE5->(dbStruct())
	
	cQry  := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE5")+" WHERE D_E_L_E_T_ <> '*' AND "
	cQry  += "E5_DTDISPO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND "
	
	If mv_par05 == 1    // Considera Filial ==  1-Sim  2-Nao
		cQry += "E5_FILIAL >= '"+mv_par06+"' AND E5_FILIAL <= '"+mv_par07+"' AND "
	Else
		cQry += "E5_FILIAL = '"+xFilial("SE5")+"' AND "
	Endif
	
	cQry += "E5_RECPAG = 'P' AND "+u_CondPadRel()
	
	If mv_par09 <> 2   // Se for Caixa ou Híbrido
		// - D= Ref. Despesas financeiras                           FIN MAT GPE
		Processa({|| cArq := u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par08,"D",.T.) },"Filtro de Dados","Filtrando Saidas...")
		
		// Se for Híbrido, processa a competência para o relatório Gerencial
		If lHibrido
			Processa({|| u_INDADCOMP(Nil,mv_par01,mv_par02,"      ","ZZZZZZ",mv_par03,mv_par04,mv_par05,mv_par06,mv_par07,"001",mv_par08) },"Filtro de Dados")
		Endif
	Else
		cQry += " AND E5_CCD >= '"+mv_par03+"' AND E5_CCD <= '"+mv_par04+"' AND E5_MOTBX = ' '"
		
		// - D= Ref. Despesas financeiras                   FIN MAT GPE
		Processa({|| u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par08,"D",.F.,,,.T.) },"Filtro de Dados","Filtrando Saidas...")
		
		If mv_par08 == 1  // Se considera PA
			// Processa os estornos de PA's
			cQPA := "(E5_MOTBX = ' ' OR (E5_MOTBX = 'DEB' AND E5_TIPO IN "+FormatIn(MVPAGANT,"|")+"))"
			cQry := StrTran(cQry,"E5_MOTBX = ' '", cQPA)
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processando as entrada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQry := StrTran(cQry,"E5_RECPAG = 'P'","E5_RECPAG = 'R'")
	
	// - D= Ref. Despesas financeiras                   FIN MAT GPE
	Processa({|| u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par08,"D",.F.,,,mv_par09==2) },"Filtro de Dados","Filtrando Entradas...")
ElseIf mv_par09 == 3  // Se for a opção Contabil
	Titulo := AllTrim(Titulo)+ " (Base Oficial) - Contabil"
	
	cQry := "SELECT COUNT(*) SOMA FROM "+RetSQLName("CT2")+" CT2 WHERE D_E_L_E_T_ <> '*'"
	cQry += " AND CT2_DATA >= '"+Dtos(mv_par01)+"' AND CT2_DATA <= '"+Dtos(mv_par02)+"'"
	cQry += " AND ((CT2_CCD >= '"+mv_par03+"' AND CT2_CCD <= '"+mv_par04+"')"
	cQry += " OR (CT2_CCC >= '"+mv_par03+"' AND CT2_CCC <= '"+mv_par04+"'))"
	
	If mv_par05 == 1    // Considera Filial ==  1-Sim  2-Nao
		cQry += " AND CT2_FILIAL >= '"+mv_par06+"' AND CT2_FILIAL <= '"+mv_par07+"'"
	Else
		cQry += " AND CT2_FILIAL = '"+xFilial("CT2")+"'"
	Endif
	
	// Rotina de Busca de Dados --> INFINP04.PRW
	Processa({|| cArq := u_INFINP04("TMP",cQry,"D",.T.,.T.,lEstorno) },"Filtro de Dados","Filtrando Saidas...")
Else  // Se for a opção Base MCT
	Titulo := AllTrim(Titulo)+ " (Base MCT)"
	
	cQry := "SELECT COUNT(*) SOMA"
	cQry += " FROM "+RetSQLName("SZ3")+" SZ3"
	cQry += " WHERE SZ3.D_E_L_E_T_ = ' '"
	
	If mv_par05 == 1    // Considera Filial ==  1-Sim  2-Nao
		cQry += " AND SZ3.Z3_FILIAL >= '"+mv_par06+"' AND SZ3.Z3_FILIAL <= '"+mv_par07+"'"
	Else
		cQry += " AND SZ3.Z3_FILIAL = '"+xFilial("SZ3")+"'"
	Endif
	
	cQry += " AND SZ3.Z3_DTDISPO >= '"+Dtos(mv_par01)+"' AND SZ3.Z3_DTDISPO <= '"+Dtos(mv_par02)+"'"
	cQry += " AND SZ3.Z3_CC >= '"+mv_par03+"' AND SZ3.Z3_CC <= '"+mv_par04+"'"
	
	// Rotina de Busca de Dados --> INFINP08.PRW
	Processa({|| cArq := u_INFINP08("TMP",cQry,"D",.T.) },"Filtro de Dados","Filtrando Saidas...")
Endif

// Salva o grupo de perguntas para eventuais mudanças de parâmetros da rotina com o relatório em andamento
aEval( aRegs , {|x| AAdd( vPerg , &(x) ) })

lAchou := .T.   // Flag de pesquisa do C.C. no arquivo temporario

CTT->(dbSetOrder(1))
CTT->(dbSeek(cFilCTT+cCCustoI,.T.))
While !CTT->(Eof()) .And. CTT->CTT_CUSTO <= cCCustoF .And. cFilCTT == CTT->CTT_FILIAL
	// Salva as configuracoes atuais da tabela CTT
	nInd   := CTT->(IndexOrd())
	nReg   := CTT->(Recno())
	cCusto := CTT->CTT_CUSTO
	
	// Se encontrou o ultimo C.C. indexa novamente, pois o indice ja foi perdido com o acesso nas rotinas abaixo
	dbSelectArea("TMP")
	If lAchou
		cInd := CriaTrab(NIL ,.F.)
		IndRegua("TMP",cInd,"E5_CC",,,"Selecionando Registros...")
	Endif
	If lAchou := CTT->(dbSeek(xFilial("CTT")+cCusto))  // dbSeek(cCusto) ALTERADO EM 14/02/2023 ANIZIO CUNHA (NÃO ENCONTRAVA COM dbseek(cCusto))
		dbClearFilter()
		FErase(cInd+OrdBagExt())
		
		vMens    := If( vPerg[9]==1, {"(Caixa)","(Caixa)"},;
						If( vPerg[9]==2, {"(Competencia)","(Competencia)"},;
						If( vPerg[9]==3, {"(Contabil)","(Contabil)"},;
						If( vPerg[9]==4, {"(Caixa)","(Hibrido)"}, {"(Base MCT)","(Base MCT)"}))))
		vMens[1] := " - "+vMens[1]
		vMens[2] := " - "+vMens[2]
		
		u_INFINR11(cCusto,"Despesas de Projetos "+cCusto+vMens[1]           ,"INFINR30","INFINR11",vPerg,.T.,,.F.)
		u_INFINR14(cCusto,"Despesas de RH "+cCusto+vMens[2]                 ,"INFINR30","INFINR14",vPerg,.T.,"001")
		u_INFINR15(cCusto,"Despesas Equipamentos "+cCusto+vMens[1]          ,"INFINR30","INFINR18",vPerg,.T.,"002")
		u_INFINR15(cCusto,"Despesas Obras Civis " +cCusto+vMens[1]          ,"INFINR30","INFINR16",vPerg,.T.,"003")
		u_INFINR15(cCusto,"Despesas Livros e Periodicos "+cCusto+vMens[1]   ,"INFINR30","INFINR17",vPerg,.T.,"004")
		u_INFINR15(cCusto,"Despesas Material de Consumo "+cCusto+vMens[1]   ,"INFINR30","INFINR15",vPerg,.T.,"005")
		u_INFINR12(cCusto,"Despesas de Viagens "+cCusto+vMens[1]            ,"INFINR30","INFINR12",vPerg,.T.,"006")
		u_INFINR13(cCusto,"Despesas de Treinamento "+cCusto+vMens[1]        ,"INFINR30","INFINR13",vPerg,.T.,"007")
		u_INFINR15(cCusto,"Despesas Servicos de Terceiros "+cCusto+vMens[1] ,"INFINR30","INFINR19",vPerg,.T.,"008")
		u_INFINR15(cCusto,"Despesas Intercambio Cientifico "+cCusto+vMens[1],"INFINR30","INFINR20",vPerg,.T.,"012") //RAGE - 28092023
		//u_INFINR15(cCusto,"Despesas Material de Consumo - Infraestrutura "+cCusto+vMens[1]  ,"INFINR30","INFINR15",vPerg,.T.,"013")
		u_INFINR15(cCusto,"Outros Correlatos - Infraestrutura "+cCusto+vMens[1]  ,"INFINR30","INFINR15",vPerg,.T.,"013")
		u_INFINR12(cCusto,"Despesas de Viagens para Treinamento "+cCusto+vMens[1]           ,"INFINR30","INFINR12",vPerg,.T.,"016")
		u_INFINR15(cCusto,"Despesas Material de Consumo - ICM FEE "+cCusto+vMens[1]         ,"INFINR30","INFINR15",vPerg,.T.,"017")
		u_INFINR15(cCusto,"Despesas Outros Correlatos " +cCusto+vMens[1]    ,"INFINR30","INFINR22",vPerg,.T.,"018")
		u_INFINR11(cCusto,"Despesas de Projetos "+cCusto+vMens[2]           ,"INFINR30","INFINR11",vPerg,.T.,,lHibrido)
	Endif
	
	CTT->(dbSetOrder(nInd))
	CTT->(dbGoTo(nReg))
	CTT->(dbSkip())
Enddo

dbSelectArea("TMP")
dbCloseArea()
FErase(cArq+GetDBExtension())

u_INRunExcel(cCsvPath,cCsvArq)  //abrir arquivo csv

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return

Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01",PADR("Da Data                  ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par01")
	u_INPutSX1(cPerg,"02",PADR("Ate a Data               ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02")
	u_INPutSX1(cPerg,"03",PADR("Do Projeto               ",29)+"?","","","mv_ch3","C", 9,0,0,"G","","CTT","","","mv_par03")
	u_INPutSX1(cPerg,"04",PADR("Ate o Projeto            ",29)+"?","","","mv_ch4","C", 9,0,0,"G","","CTT","","","mv_par04")
	u_INPutSX1(cPerg,"05",PADR("Considera Filiais a baixo",29)+"?","","","mv_ch5","N", 1,0,0,"C","","   ","","","mv_par05","Sim","","","","Nao")
	u_INPutSX1(cPerg,"06",PADR("Da Filial                ",29)+"?","","","mv_ch6","C", 2,0,0,"G","","   ","","","mv_par06")
	u_INPutSX1(cPerg,"07",PADR("Ate a Filial             ",29)+"?","","","mv_ch7","C", 2,0,0,"G","","   ","","","mv_par07")
	u_INPutSX1(cPerg,"08",PADR("Considera P.A.           ",29)+"?","","","mv_ch8","N", 1,0,0,"C","","   ","","","mv_par08","Sim","","","","Nao")
	u_INPutSX1(cPerg,"09",PADR("Imprime relatorio por    ",29)+"?","","","mv_ch9","N", 1,0,0,"C","","   ","","","mv_par09","Caixa","","","",;
	"Competencia","","","Contabil","","","Hibrido","","","Base MCT")
	u_INPutSX1(cPerg,"10",PADR("Considera estornos       ",29)+"?","","","mv_cha","N", 1,0,0,"C","","   ","","","mv_par10","Sim","","","","Nao")
Return {"mv_par01","mv_par02","mv_par03","mv_par04","mv_par05","mv_par06","mv_par07","mv_par08","mv_par09","mv_par10"}

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ cMsgFile   ¦ Autor ¦ Nelio Castro Jorio   ¦ Data ¦ 12/09/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Escreve uma linha no aqruivo Csv                              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AddCSV(aItens)
	Local nX
	Local cEnd := Chr(9)
	Local cEOL := CHR(13)+CHR(10)    //retorno de linha
	Local cLin := ""
	
	For nX:=1 To Len(aItens)
		If ValType(aItens[nX]) == "N"
			cLin += LTrim(Transform(aItens[nX],"@E 999,999,999.99"))
		ElseIf ValType(aItens[nX]) == "D"
			cLin += dToC(aItens[nX])
		Else
			cLin += StrTran(StrTran(aItens[nX],CHR(13)," "),CHR(10),"")
		Endif
		cLin += cEnd
	Next
	cLin += cEOL
	
	fWrite(nHdl,cLin)
	
Return .T.
