#INCLUDE "rwmake.ch"

/*/
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SEGPER02  º Autor ³ Adson Carlos       º Data ³  28/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Suframa                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
/*/

User Function SEGPER02()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "SEGPER02"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Local cPerg          := PadR("SEGPER02",Len(SX1->X1_GRUPO))
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "SEGPER02" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "SEGPER02" // Coloque aqui o nome do arquivo usado para impressao em disco
Private aCabec       := {}
Private cString      := ""
Private aCol         := {01,19,32,48,57,119,138,176,198}

aCabec := {{"Faixa",20},{"Quantidade",10},{"Valor",16}}
aEval(aCabec,{|aPrm| Cabec1 += Padc(aPrm[01],aPrm[02]) + "|" })

CreatePerg(cPerg)
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return Nil
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return  Nil
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem
	Local aLinha    := {}
	Local _Vector   := {} 
	Local _Vector1  := {}
	Local _Total    := {0,0}
	Local _Total2   := {0,0,0,0}
	Private aExport := {}
	
	cTable := CriaTrab(Nil,.F.)
	SetRegua(MountTable(cTable))
	
	While !(cTable)->(EOF())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@nLin,aCol[01]    Psay (cTable)->FAIXA
		@nLin,aCol[02]+ 2 Psay PADC(ALLTRIM(STR((cTable)->FUNCA)),10)
		@nLin,aCol[03]    Psay PADC(TRANSFORM((cTable)->FUNVAL,"@E 9,999,999.99"),16)
		
		_Total[1] += (cTable)->FUNCA
		_Total[2] += (cTable)->FUNVAL
		
		nLin := nLin + 1
		
		(cTable)->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo
	
	nLin := nLin + 1
	@nLin,aCol[01]    Psay "Total"
	@nLin,aCol[02]+ 2 Psay PADC(ALLTRIM(STR(_Total[1])),10)
	@nLin,aCol[03]    Psay PADC(TRANSFORM(_Total[2],"@E 9,999,999.99"),16)
	nLin := nLin + 2

	_Vector := FunMes()
	@nLin,aCol[01] Psay "Funcionarios no Inicio do Mês: " + ALLTRIM(STR(_Vector[1]))
	nLin := nLin + 1
	@nLin,aCol[01] Psay "Funcionarios Admitidos no Mês: " + ALLTRIM(STR(_Vector[3]))
	nLin := nLin + 1
	@nLin,aCol[01] Psay "Funcionarios Demitidos no Mês: " + ALLTRIM(STR(_Vector[4]))
	nLin := nLin + 1	
	@nLin,aCol[01] Psay "Funcionarios no Fim do Mês: " + ALLTRIM(STR(_Vector[2]))  
	nLin := nLin + 1	
	@nLin,aCol[01] Psay "Mao-de-Obra Feminina: " + ALLTRIM(STR(_Vector[5]))  
	nLin := nLin + 1	
	@nLin,aCol[01] Psay "Mao-de-Obra PNEs: " + ALLTRIM(STR(_Vector[6]))
	nLin := nLin + 1   
	@nLin,aCol[01] Psay "Valor Mao-de-Obra Masculina: " + ALLTRIM(TRANSFORM(_Vector[8],"@E 999,999,999.99"))
	nLin := nLin + 1       
	@nLin,aCol[01] Psay "Valor Mao-de-Obra Feminina: " + ALLTRIM(TRANSFORM(_Vector[7],"@E 999,999,999.99"))
	nLin := nLin + 1    
	@nLin,aCol[01] Psay "Valor PNEs: " + ALLTRIM(TRANSFORM(_Vector[9],"@E 999,999,999.99"))
	nLin := nLin + 2     

	_Vector1 := ValMes()
	@nLin,aCol[01] Psay "INSS:  " + PADC(TRANSFORM(_Vector1[1],"@E 9,999,999.99"),16)
	nLin := nLin + 1
	@nLin,aCol[01] Psay "IRR:   " + PADC(TRANSFORM(_Vector1[2],"@E 9,999,999.99"),16)
	nLin := nLin + 1    
	@nLin,aCol[01] Psay "FGTS:  " + PADC(TRANSFORM(_Vector1[3],"@E 9,999,999.99"),16)
	nLin := nLin + 1
	@nLin,aCol[01] Psay "TOTAL: " + PADC(TRANSFORM(_Vector1[1]+_Vector1[2]+_Vector1[3],"@E 9,999,999.99"),16)
	nLin := nLin + 2               
	@nLin,00 PSAY "Centros de Custo:"
	nLin := nLin + 1
	
	cTable := CriaTrab(Nil,.F.)
	SetRegua(MountTbl2(cTable))     
	
	While !(cTable)->(EOF())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@nLin,aCol[01]    Psay (cTable)->CENTROC
		@nLin,aCol[02]+ 2 Psay SUBSTR(CTT_DESC01,1,25) 
		@nLin,aCol[04]+ 2 Psay ALLTRIM(Str(NUMBERS)) 
		@nLin,aCol[05]+ 2 Psay PADC(TRANSFORM(VALORA,"@E 9,999,999.99"),16)
		
		/*
		iF  (cTable)->CTT_XMAOBR = 'D'   
			_Total2[1] += (cTable)->NUMBERS
			_Total2[2] += (cTable)->VALORA   
		ELSE
		ALTERADO POR WILLIAMS MESSA PARA DESCONSIDERAR O CAMPO PERSONALIZADO DE MAÃO DE OBRA NO CADASTRO DE CENTRO DE CUSTO.*/  
			_Total2[3] += (cTable)->NUMBERS
			_Total2[4] += (cTable)->VALORA
		//ENDIF
		
		nLin := nLin + 1
		
		(cTable)->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo

	nLin := nLin + 1 
	@nLin,aCol[01]    Psay "Total Mod Direta"
	@nLin,aCol[02]+ 2 Psay PADC(ALLTRIM(STR(_Total2[1])),10)
	@nLin,aCol[03]    Psay PADC(TRANSFORM(_Total2[2],"@E 9,999,999.99"),16)  
	nLin := nLin + 1
	@nLin,aCol[01]    Psay "Total Mod Indireta"
	@nLin,aCol[02]+ 2 Psay PADC(ALLTRIM(STR(_Total2[3])),10)
	@nLin,aCol[03]    Psay PADC(TRANSFORM(_Total2[4],"@E 9,999,999.99"),16)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
	
Return


Static Function MountTable(cTable)
	Local cQry    := ""
	Local cCampos := " FAIXA, FUNCA, FUNVAL "
//	Local cMesA   := GetMv("MV_FOLMES")
	Local cMesP   := SubStr(mv_par01,3,4)+SubStr(mv_par01,1,2)
//	Local lFlag   := IIf(cMesA == cMesP, .T. ,.F.)
	Local lFlag   := Posicione("RCH",1,xFilial("RCH")+"00001"+right(MV_PAR01,4)+left(MV_PAR01,2)+"01FOL","RCH_STATUS") = "0"
	Local cPedaco := IIf(lFlag, "RC_PD" , "RD_PD")
	
	cQry +=                     " Select Count(*) CONT From (
	cQry += Chr(13) + Chr(10) + " SELECT FAIXA, COUNT(*) FUNCA, SUM(NUM) FUNVAL FROM (
	cQry += Chr(13) + Chr(10) + " SELECT NUM, FAIXA = CASE
	cQry += Chr(13) + Chr(10) + " When NUM < (1.5 * RX_TXT)  Then '1 - Até 1,5'
	cQry += Chr(13) + Chr(10) + " when NUM BETWEEN 1.5*RX_TXT  AND 2*RX_TXT    Then '2 - De 1,5 a 2'
	cQry += Chr(13) + Chr(10) + " when NUM BETWEEN 2*RX_TXT   AND 4*RX_TXT    Then '3 - De 2 a 4'
	cQry += Chr(13) + Chr(10) + " when NUM BETWEEN 4*RX_TXT   AND 6*RX_TXT  Then '4 - De 4 a 6'
	cQry += Chr(13) + Chr(10) + " when NUM BETWEEN 6*RX_TXT   AND 10*RX_TXT  Then '5 - De 6 a 10'
	cQry += Chr(13) + Chr(10) + " when NUM BETWEEN 10*RX_TXT  AND 15*RX_TXT Then '7 - De 10 a 15'
	cQry += Chr(13) + Chr(10) + " Else '8 - Acima de 15' end
	cQry += Chr(13) + Chr(10) + " FROM (
	
	If lFlag
		cQry += Chr(13) + Chr(10) + " SELECT RC_MAT, SUM(NUM) NUM, RX_TXT FROM (	  SELECT RC_MAT,  CASE WHEN RV_TIPOCOD = 1 THEN SUM(RC_VALOR) ELSE SUM(-RC_VALOR) END NUM, 1*  cast(B.RX_TXT as numeric) RX_TXT  FROM " + RetSqlName("SRC") +" RC "
	Else
		cQry += Chr(13) + Chr(10) + " SELECT RD_MAT, SUM(NUM) NUM, RX_TXT FROM (	  SELECT RD_MAT,  CASE WHEN RV_TIPOCOD = 1 THEN SUM(RD_VALOR) ELSE SUM(-RD_VALOR) END NUM, 1*  cast(B.RX_TXT as numeric) RX_TXT  FROM " + RetSqlName("SRD") +" RD "
	ENDIF
	
	cQry += Chr(13) + Chr(10) + "  INNER JOIN " + RetSqlName("SRV") +" RV ON RV_COD = " + cPedaco
	
	cPedaco := IIf(lFlag, "RC_MAT" , "RD_MAT")
	
	cQry += Chr(13) + Chr(10) + "  INNER JOIN " + RetSqlName("SRA") +" RA ON RA_MAT = " + cPedaco
	cQry += Chr(13) + Chr(10) + "  ,(
//	cQry += Chr(13) + Chr(10) + "  select RX_TXT from " + RetSqlName("SRX") +" "
//	cQry += Chr(13) + Chr(10) + "  WHERE RX_COD = (select max(RX_COD) from " + RetSqlName("SRX") +" "
//	cQry += Chr(13) + Chr(10) + "  WHERE RX_TIP = 11)
//	cQry += Chr(13) + Chr(10) + "  and RX_TIP = 11
//	cQry += Chr(13) + Chr(10) + "  group by RX_TXT

	//Marcio Macedo 02/03/2018 -Mudança de Tabela para pegar Salaio Minimo
	cQry += Chr(13) + Chr(10) + "  select SUBSTRING(RCC_CONTEU,13,12) RX_TXT "
	cQry += Chr(13) + Chr(10) + "  FROM " + RetSqlName("RCC") +" "
	cQry += Chr(13) + Chr(10) + "  WHERE RCC_SEQUEN = (select max(RCC_SEQUEN) FROM " + RetSqlName("RCC") +" "
	cQry += Chr(13) + Chr(10) + "  WHERE RCC_CODIGO = 'S004') "
	cQry += Chr(13) + Chr(10) + "  AND RCC_CODIGO = 'S004' "
	//----------------------------------	
	cQry += Chr(13) + Chr(10) + "  ) B
	cQry += Chr(13) + Chr(10) + " WHERE RV_SUFRAMA = 'S'
	
	If lFlag
		cQry += Chr(13) + Chr(10) + " AND RC.D_E_L_E_T_ = ' '
//		cQry += Chr(13) + Chr(10) + " AND RC_PD NOT IN ('200','201','204','205','206','323','324')
	Else
		cQry += Chr(13) + Chr(10) + " AND RD_DATARQ = '" + cMesP +"' "          
//		cQry += Chr(13) + Chr(10) + " AND RD_PD NOT IN ('200','201','204','205','206','323','324')
		cQry += Chr(13) + Chr(10) + " AND RD.D_E_L_E_T_ = ' '
	ENDIF
	
	cQry += Chr(13) + Chr(10) + " AND RV.D_E_L_E_T_ = ' '
	//cQry += Chr(13) + Chr(10) + " --AND RA_SITFOLH not in ('D','E')
	cQry += Chr(13) + Chr(10) + " AND RA.D_E_L_E_T_ = ' '
	cQry += Chr(13) + Chr(10) + " AND RA_CATFUNC NOT IN ('E','P','A') 
//	cQry += Chr(13) + Chr(10) + " AND RA_ADMISSA < '" + soma1(cMesP) +"01' "
//	cQry += Chr(13) + Chr(10) + " AND  (RA_DEMISSA > '" + cMesP  +"01'  OR RA_DEMISSA = ' ')  "
	cQry += Chr(13) + Chr(10) + " AND RA_FILIAL BETWEEN '01' AND '01' "
	
	If lFlag
		cQry += Chr(13) + Chr(10) + " GROUP BY RC_MAT, RV_TIPOCOD, RX_TXT                          
		cQry += Chr(13) + Chr(10) + " ) A GROUP BY RC_MAT, RX_TXT  ) B GROUP BY RC_MAT, NUM, RX_TXT
	Else
		cQry += Chr(13) + Chr(10) + " GROUP BY RD_MAT, RV_TIPOCOD, RX_TXT
		cQry += Chr(13) + Chr(10) + " ) A GROUP BY RD_MAT, RX_TXT  ) B GROUP BY RD_MAT, NUM, RX_TXT
	ENDIF                                                                        
	
	cQry += Chr(13) + Chr(10) + ") X
	cQry += Chr(13) + Chr(10) + " GROUP BY FAIXA
	cQry += Chr(13) + Chr(10) + " ) Y
	
	MemoWrit("LOLIMP.sql",cQry)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTable,.T.,.T.)
	nCont := (cTable)->CONT
	(cTable)->(dbCloseArea(cTable))
	cQry := StrTran(cQry,"Count(*) CONT",cCampos)
	cQry += Chr(13) + Chr(10) + " order by FAIXA
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTable,.T.,.T.)   
	MemoWrit("LOLIMP.sql",cQry)
	
Return nCont

Static Function CreatePerg(cPerg)
	Local nPerg := Len(SX1->X1_PERGUNT)
	SKPutSX1(cPerg,"01","Data Referencia: (MMAAAA)","Data Referencia: ","Data Referencia: ","mv_ch1","C",6,0,0,"G","","","","","mv_par01")
Return Nil


Static Function FunMes()
	Local _aFun  := {}
	Local _cQry  := ""
	Local _DataI := SubStr(mv_par01,3,4)+SubStr(mv_par01,1,2)+'01'
	Local _DataF := SubStr(mv_par01,3,4)+Soma1(SubStr(mv_par01,1,2))+'01'   
//	Local cMesA   := GetMv("MV_FOLMES")
	Local cMesP   := SubStr(mv_par01,3,4)+SubStr(mv_par01,1,2)
//	Local lFlag   := IIf(cMesA == cMesP, .T. ,.F.)
	Local lFlag   := Posicione("RCH",1,xFilial("RCH")+"00001"+right(MV_PAR01,4)+left(MV_PAR01,2)+"01FOL","RCH_STATUS") = "0"
	Local cPedaco := IIf(lFlag, "RC_PD" , "RD_PD")

	_cQry += Chr(13) + Chr(10) + " SELECT COUNT(*) ANTES FROM " + RetSqlName("SRA") +" "
	_cQry += Chr(13) + Chr(10) + " WHERE  RA_DEMISSA = '' AND RA_CATFUNC NOT IN ('E','P','A')  "
	_cQry += Chr(13) + Chr(10) + " AND RA_ADMISSA < '" + _DataI + "' OR
	_cQry += Chr(13) + Chr(10) + " (RA_DEMISSA >= '" + _DataI + "' AND RA_CATFUNC NOT IN ('E','P','A'))  "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"FUN1",.T.,.T.)
	aAdd(_aFun,FUN1->ANTES)
	_cQry  := ""
	FUN1->(dbCloseArea("FUN1"))
	
	_cQry += Chr(13) + Chr(10) + " SELECT COUNT(*) DEPOIS FROM " + RetSqlName("SRA") +" "
	_cQry += Chr(13) + Chr(10) + " WHERE  RA_DEMISSA = '' AND D_E_L_E_T_ = '' AND RA_CATFUNC NOT IN ('E','P','A')  "
	_cQry += Chr(13) + Chr(10) + " AND RA_ADMISSA < '" + _DataF + "' OR
	_cQry += Chr(13) + Chr(10) + " (RA_DEMISSA >= '" + _DataF + "' AND RA_CATFUNC NOT IN ('E','P','A') ) "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"FUN2",.T.,.T.)
	aAdd(_aFun,FUN2->DEPOIS) 
	_cQry  := ""
	FUN2->(dbCloseArea("FUN2"))

	_cQry += Chr(13) + Chr(10) + " SELECT COUNT(*) ADM FROM " + RetSqlName("SRA") +" "
	_cQry += Chr(13) + Chr(10) + " WHERE D_E_L_E_T_ = ''  AND RA_ADMISSA BETWEEN '" + _DataI + "' AND '" + _DataF + "' AND  RA_CATFUNC NOT IN ('E','P','A')  "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"FUN3",.T.,.T.)
	aAdd(_aFun,FUN3->ADM) 
	_cQry  := ""
	FUN3->(dbCloseArea("FUN3"))
	
	_cQry += Chr(13) + Chr(10) + " SELECT COUNT(*) DEM FROM " + RetSqlName("SRA") +" "
	_cQry += Chr(13) + Chr(10) + " WHERE RA_DEMISSA BETWEEN '" + _DataI + "' AND '" + _DataF + "' AND  RA_CATFUNC NOT IN ('E','P','A') "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"FUN4",.T.,.T.)
	aAdd(_aFun,FUN4->DEM) 
	_cQry  := ""
	FUN4->(dbCloseArea("FUN4"))     
	
	_cQry += Chr(13) + Chr(10) + " 	SELECT ( "
	_cQry += Chr(13) + Chr(10) + " 	SELECT COUNT(*) FROM " + RetSqlName("SRA") +" "
	_cQry += Chr(13) + Chr(10) + " 	WHERE  RA_DEMISSA = '' AND D_E_L_E_T_ = '' AND RA_CATFUNC NOT IN ('E','P','A') "
	_cQry += Chr(13) + Chr(10) + " 	AND RA_SEXO = 'F' "
	_cQry += Chr(13) + Chr(10) + " 	AND RA_DEFIFIS <> '1' "	
	_cQry += Chr(13) + Chr(10) + " 	AND RA_ADMISSA < '" + _DataF + "' OR "
	_cQry += Chr(13) + Chr(10) + " 	(RA_DEMISSA >= '" + _DataI + "' AND RA_SEXO = 'F' AND RA_CATFUNC NOT IN ('E','P','A') ) ) "
	_cQry += Chr(13) + Chr(10) + " 	MULH, "
	_cQry += Chr(13) + Chr(10) + " 	( "
	_cQry += Chr(13) + Chr(10) + " 	SELECT COUNT(*) FROM " + RetSqlName("SRA") +" "
	_cQry += Chr(13) + Chr(10) + " 	WHERE  RA_DEMISSA = '' AND D_E_L_E_T_ = '' AND RA_CATFUNC NOT IN ('E','P') "  
	_cQry += Chr(13) + Chr(10) + " 	AND RA_DEFIFIS = '1' "
	_cQry += Chr(13) + Chr(10) + " 	AND RA_ADMISSA < '" + _DataF + "' OR "
	_cQry += Chr(13) + Chr(10) + " 	(RA_DEMISSA >= '" + _DataI + "' AND RA_DEFIFIS = '1' AND RA_CATFUNC NOT IN ('E','P') ) ) DEFIS "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"FUN5",.T.,.T.)
	aAdd(_aFun,FUN5->MULH) 
	aAdd(_aFun,FUN5->DEFIS) 
	_cQry  := ""
	FUN5->(dbCloseArea("FUN5"))     
	
	_cQry += Chr(13) + Chr(10) + " SELECT RA_SEXO, SUM(NUM) NUM FROM ( "

	If lFlag
		_cQry += Chr(13) + Chr(10) + " SELECT RC_MAT MATRI, RA_SEXO, CASE WHEN RV_TIPOCOD = 1 THEN SUM(RC_VALOR) ELSE SUM(-RC_VALOR) END NUM FROM " + RetSqlName("SRC") +" RC "
		_cQry += Chr(13) + Chr(10) + "  INNER JOIN " + RetSqlName("SRA") +" RA ON RC_MAT = RA_MAT "
	Else
		_cQry += Chr(13) + Chr(10) + " SELECT RD_MAT MATRI, RA_SEXO, CASE WHEN RV_TIPOCOD = 1 THEN SUM(RD_VALOR) ELSE SUM(-RD_VALOR) END NUM FROM " + RetSqlName("SRD") +" RD "
		_cQry += Chr(13) + Chr(10) + "  INNER JOIN " + RetSqlName("SRA") +" RA ON RD_MAT = RA_MAT "  	
	ENDIF
	
	_cQry += Chr(13) + Chr(10) + "  INNER JOIN " + RetSqlName("SRV") +" RV ON RV_COD = " + cPedaco  	

	If lFlag
		_cQry += Chr(13) + Chr(10) + " WHERE RC.D_E_L_E_T_ = ' ' " 
	Else
		_cQry += Chr(13) + Chr(10) + " WHERE RD_DATARQ = '" + cMesP +"' AND RD.D_E_L_E_T_ = ' ' "   
	ENDIF
	
	_cQry += Chr(13) + Chr(10) + " AND RV.D_E_L_E_T_ = ' '  "
	_cQry += Chr(13) + Chr(10) + " AND RA.D_E_L_E_T_ = ' ' AND RV_SUFRAMA = 'S' "     
	_cQry += Chr(13) + Chr(10) + " AND RA_CATFUNC NOT IN ('E','P','A')  
	_cQry += Chr(13) + Chr(10) + " AND RA_FILIAL BETWEEN '01' AND '01' "
	
	If lFlag
		_cQry += Chr(13) + Chr(10) + " GROUP BY RC_MAT, RV_TIPOCOD, RA_SEXO  ) X group by RA_SEXO ORDER BY RA_SEXO "
	Else	
		_cQry += Chr(13) + Chr(10) + " GROUP BY RD_MAT, RV_TIPOCOD, RA_SEXO  ) X GROUP BY RA_SEXO ORDER BY RA_SEXO "
	EndIf	
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"FUN6",.T.,.T.) 
	iF FUN6->(EOF())
		aAdd(_aFun,0)       
	ELSE
		aAdd(_aFun,FUN6->NUM)       
	ENDIF
	FUN6->(DBsKIP())     
	iF FUN6->(EOF())
		aAdd(_aFun,0)       
	ELSE
		aAdd(_aFun,FUN6->NUM)       
	ENDIF   
	_cQry  := ""
	FUN6->(dbCloseArea("FUN6"))    
	
	_cQry += Chr(13) + Chr(10) + " SELECT SUM(NUM) NUM FROM (

	If lFlag
		_cQry += Chr(13) + Chr(10) + " SELECT  CASE WHEN RV_TIPOCOD = 1 THEN SUM(RC_VALOR) ELSE SUM(-RC_VALOR) END NUM FROM " + RetSqlName("SRC") +" RC "
		_cQry += Chr(13) + Chr(10) + "  INNER JOIN " + RetSqlName("SRA") +" RA ON RC_MAT = RA_MAT "
	Else
		_cQry += Chr(13) + Chr(10) + " SELECT  CASE WHEN RV_TIPOCOD = 1 THEN SUM(RD_VALOR) ELSE SUM(-RD_VALOR) END NUM FROM " + RetSqlName("SRD") +" RD "
		_cQry += Chr(13) + Chr(10) + "  INNER JOIN " + RetSqlName("SRA") +" RA ON RD_MAT = RA_MAT "  	
	ENDIF
	
	_cQry += Chr(13) + Chr(10) + "  INNER JOIN " + RetSqlName("SRV") +" RV ON RV_COD = " + cPedaco  	

	If lFlag                                         
		_cQry += Chr(13) + Chr(10) + " WHERE RC.D_E_L_E_T_ = ' ' " 
	Else
		_cQry += Chr(13) + Chr(10) + " WHERE RD_DATARQ = '" + cMesP +"' AND RD.D_E_L_E_T_ = ' ' "   
	ENDIF
	
	_cQry += Chr(13) + Chr(10) + " AND RV.D_E_L_E_T_ = ' ' "
	_cQry += Chr(13) + Chr(10) + " AND RA.D_E_L_E_T_ = ' ' "
	_cQry += Chr(13) + Chr(10) + " AND RV_SUFRAMA = 'S'
	_cQry += Chr(13) + Chr(10) + " AND RA_CATFUNC NOT IN ('E','P') AND RA_DEFIFIS = '1' "
	_cQry += Chr(13) + Chr(10) + " AND RA_FILIAL BETWEEN '01' AND '01' GROUP BY RV_TIPOCOD ) X "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"FUN7",.T.,.T.)
	aAdd(_aFun,FUN7->NUM)          
	_cQry  := ""	
	FUN7->(dbCloseArea("FUN7"))  
	
Return _aFun



Static Function ValMes()
	Local _aVal  := {}
	Local _cQry  := ""
//	Local cMesA   := GetMv("MV_FOLMES")
	Local _DataI := SubStr(mv_par01,3,4)+SubStr(mv_par01,1,2)+'01'
	Local _DataF := SubStr(mv_par01,3,4)+Soma1(SubStr(mv_par01,1,2))+'01'    
	Local cMesP   := SubStr(mv_par01,3,4)+SubStr(mv_par01,1,2)
//	Local lFlag   := IIf(cMesA == cMesP, .T. ,.F.)
	Local lFlag   := Posicione("RCH",1,xFilial("RCH")+"00001"+right(MV_PAR01,4)+left(MV_PAR01,2)+"01FOL","RCH_STATUS") = "0"
	Local cPedaco := IIf(lFlag, "RC_PD" , "RD_PD")

	If lFlag                                                                                         
		_cQry += Chr(13) + Chr(10) + " SELECT  SUM(RC_VALOR) INSS FROM " + RetSqlName("SRC") + " RC "
		_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName("SRV") +" RV ON RV_COD = RC_PD "
		_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName("SRA") +" RA ON RA_MAT = RC_MAT "
	Else
		_cQry += Chr(13) + Chr(10) + " SELECT  SUM(RD_VALOR) INSS FROM " + RetSqlName("SRD") + " RD "
		_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName("SRV") +" RV ON RV_COD = RD_PD "
		_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName("SRA") +" RA ON RA_MAT = RD_MAT "
	EndIf
	_cQry += Chr(13) + Chr(10) + "   WHERE RV_COD in ('405','406','407')                      
	If lFlag                                                   
		_cQry += Chr(13) + Chr(10) + "   AND RC.D_E_L_E_T_ = ' '                                     
	Else
		_cQry += Chr(13) + Chr(10) + "   AND RD_DATARQ = '" + SubStr(_DataI,1,6) + "'
		_cQry += Chr(13) + Chr(10) + "   AND RD.D_E_L_E_T_ = ' '
	EndIf
	_cQry += Chr(13) + Chr(10) + "   AND RV.D_E_L_E_T_ = ' '
	_cQry += Chr(13) + Chr(10) + "   AND RA.D_E_L_E_T_ = ' '
	_cQry += Chr(13) + Chr(10) + "   AND RA_FILIAL BETWEEN '01' AND '01' 

	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"FUN1",.T.,.T.)
	
	aAdd(_aVal,FUN1->INSS)
	_cQry  := ""
	
	FUN1->(dbCloseArea("FUN1"))

	If lFlag                                                                                         
		_cQry += Chr(13) + Chr(10) + " SELECT  SUM(RC_VALOR) IRR FROM " + RetSqlName("SRC") + " RC "
		_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName("SRV") +" RV ON RV_COD = RC_PD "
		_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName("SRA") +" RA ON RA_MAT = RC_MAT "
	Else
		_cQry += Chr(13) + Chr(10) + " SELECT  SUM(RD_VALOR) IRR FROM " + RetSqlName("SRD") + " RD "
		_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName("SRV") +" RV ON RV_COD = RD_PD "
		_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName("SRA") +" RA ON RA_MAT = RD_MAT "
	EndIf

	_cQry += Chr(13) + Chr(10) + "   WHERE RV_COD in ('411','412','414','415','408','413')       
	If lFlag                                                   
		_cQry += Chr(13) + Chr(10) + "   AND RC.D_E_L_E_T_ = ' '                                     
	Else
		_cQry += Chr(13) + Chr(10) + "   AND RD_DATARQ = '" + SubStr(_DataI,1,6) + "'
		_cQry += Chr(13) + Chr(10) + "   AND RD.D_E_L_E_T_ = ' '
	EndIf
	_cQry += Chr(13) + Chr(10) + "   AND RV.D_E_L_E_T_ = ' '
	_cQry += Chr(13) + Chr(10) + "   AND RA.D_E_L_E_T_ = ' '
	_cQry += Chr(13) + Chr(10) + "   AND RA_FILIAL BETWEEN '01' AND '01' 
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"FUN2",.T.,.T.)
	
	aAdd(_aVal,FUN2->IRR)
	_cQry  := ""
	
	FUN2->(dbCloseArea("FUN2"))
	
	If lFlag                                                                                         
		_cQry += Chr(13) + Chr(10) + " SELECT  SUM(RC_VALOR) FGTS FROM " + RetSqlName("SRC") + " RC "
		_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName("SRV") +" RV ON RV_COD = RC_PD "
		_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName("SRA") +" RA ON RA_MAT = RC_MAT "
	Else
		_cQry += Chr(13) + Chr(10) + " SELECT  SUM(RD_VALOR) FGTS FROM " + RetSqlName("SRD") + " RD "
		_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName("SRV") +" RV ON RV_COD = RD_PD "
		_cQry += Chr(13) + Chr(10) + "   INNER JOIN " + RetSqlName("SRA") +" RA ON RA_MAT = RD_MAT "
	EndIf
	_cQry += Chr(13) + Chr(10) + "   WHERE RV_COD in ('736','738')    
	If lFlag                                                   
		_cQry += Chr(13) + Chr(10) + "   AND RC.D_E_L_E_T_ = ' '                                     
	Else
		_cQry += Chr(13) + Chr(10) + "   AND RD_DATARQ = '" + SubStr(_DataI,1,6) + "'
		_cQry += Chr(13) + Chr(10) + "   AND RD.D_E_L_E_T_ = ' '
	EndIf
	_cQry += Chr(13) + Chr(10) + "   AND RV.D_E_L_E_T_ = ' '
	_cQry += Chr(13) + Chr(10) + "   AND RA.D_E_L_E_T_ = ' '
	_cQry += Chr(13) + Chr(10) + "   AND RA_FILIAL BETWEEN '01' AND '01' 

	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"FUN3",.T.,.T.)
	
	aAdd(_aVal,FUN3->FGTS)
	_cQry  := ""
	
	FUN3->(dbCloseArea("FUN3"))
	
Return _aVal    

Static Function MountTbl2(cTable)
	Local cQry    := ""
	//Local cCampos := " 	CENTROC, CTT_DESC01, NUMBERS, VALORA, CTT_XMAOBR "
	Local cCampos := " 	CENTROC, CTT_DESC01, NUMBERS, VALORA   "
//	Local cMesA   := GetMv("MV_FOLMES")
	Local cMesP   := SubStr(mv_par01,3,4)+SubStr(mv_par01,1,2)
//	Local lFlag   := IIf(cMesA == cMesP, .T. ,.F.)
	Local lFlag   := Posicione("RCH",1,xFilial("RCH")+"00001"+right(MV_PAR01,4)+left(MV_PAR01,2)+"01FOL","RCH_STATUS") = "0"
	Local cPedaco := IIf(lFlag, "RC_PD" , "RD_PD") 
	Local cPedac2 := IIf(lFlag, "RC_MAT" ,"RD_MAT")
	Local cPedac3 := IIf(lFlag, "RC_CC"  ,"RD_CC")
	
	cQry +=                     " Select Count(*) CONT From (         
	cQry += Chr(13) + Chr(10) + " select CENTROC, CTT_DESC01, COUNT(RA_MAT) NUMBERS, SUM(NUM) VALORA FROM " + RetSqlName("SRA") +" RA  "  
	cQry += Chr(13) + Chr(10) + " INNER JOIN (  "  
	cQry += Chr(13) + Chr(10) + " SELECT "+cPedac2+", CENTROC, SUM(NUM) NUM FROM ("   
	
	If lFlag
		cQry += Chr(13) + Chr(10) + " SELECT  RC_MAT, "+cPedac3+" CENTROC, CASE WHEN RV_TIPOCOD = 1 THEN SUM(RC_VALOR) ELSE SUM(-RC_VALOR) END NUM FROM  " + RetSqlName("SRC") +" RC "
	Else
		cQry += Chr(13) + Chr(10) + " SELECT  RD_MAT, "+cPedac3+" CENTROC, CASE WHEN RV_TIPOCOD = 1 THEN SUM(RD_VALOR) ELSE SUM(-RD_VALOR) END NUM FROM  " + RetSqlName("SRD") +" RD "
	ENDIF

	cQry += Chr(13) + Chr(10) + " INNER JOIN " + RetSqlName("SRV") +" RV ON RV_COD = " + cPedaco + " "
	cQry += Chr(13) + Chr(10) + " INNER JOIN " + RetSqlName("SRA") +" RA ON RA_MAT = " + cPedac2 + " "
	cQry += Chr(13) + Chr(10) + " WHERE RV_SUFRAMA = 'S' "
	cQry += Chr(13) + Chr(10) + " AND RV.D_E_L_E_T_ = ' ' "
	cQry += Chr(13) + Chr(10) + " AND RA.D_E_L_E_T_ = ' ' "
	If lFlag
		cQry += Chr(13) + Chr(10) + " AND RC.D_E_L_E_T_ = ' ' "
	Else
		cQry += Chr(13) + Chr(10) + " AND RD_DATARQ = '" + cMesP +"' "
		cQry += Chr(13) + Chr(10) + " AND RD.D_E_L_E_T_ = ' ' "
	ENDIF	
	cQry += Chr(13) + Chr(10) + " AND RA_FILIAL BETWEEN '01' AND '01' 
	cQry += Chr(13) + Chr(10) + " AND RA_CATFUNC NOT IN ('E','P','A')   "
	cQry += Chr(13) + Chr(10) + "  GROUP BY " + cPedac2 + " , "+cPedac3+" , RV_TIPOCOD "
	cQry += Chr(13) + Chr(10) + " ) F GROUP BY " + cPedac2 + ", CENTROC "
	cQry += Chr(13) + Chr(10) + " )X ON RA_MAT = " + cPedac2 + " "
	cQry += Chr(13) + Chr(10) + " INNER JOIN " + RetSqlName("CTT") +" CTT ON CTT_CUSTO = CENTROC AND CTT.D_E_L_E_T_ = ' ' "
	//cQry += Chr(13) + Chr(10) + " GROUP BY CENTROC, CTT_DESC01, CTT_XMAOBR
	cQry += Chr(13) + Chr(10) + " GROUP BY CENTROC, CTT_DESC01
	cQry += Chr(13) + Chr(10) + " ) Y
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTable,.T.,.T.)
	nCont := (cTable)->CONT
	(cTable)->(dbCloseArea(cTable))
	cQry := StrTran(cQry,"Count(*) CONT",cCampos)
	cQry += Chr(13) + Chr(10) + " order by CENTROC
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTable,.T.,.T.)
	
	MEMOWRIT('SEGPER02',cQry)
Return nCont        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PutSx1    ³ Autor ³Wagner                 ³ Data ³ 14/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria uma pergunta usando rotina padrao                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SKPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

LOCAL aArea := GetArea()
Local cKey
Local lPort := .f.
Local lSpa  := .f.
Local lIngl := .f. 

If .T. //GetVersao(.F.) < "12"

	cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."
	
	cPyme    := Iif( cPyme 		== Nil, " ", cPyme		)
	cF3      := Iif( cF3 		== NIl, " ", cF3		)
	cGrpSxg  := Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
	cCnt01   := Iif( cCnt01		== Nil, "" , cCnt01 	)
	cHelp	 := Iif( cHelp		== Nil, "" , cHelp		)
	
	dbSelectArea( "SX1" )
	dbSetOrder( 1 )
	
	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )
	
	If !( DbSeek( cGrupo + cOrdem ))
	
	    cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa	:= If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng	:= If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
	
		Reclock( "SX1" , .T. )
	
		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid
	
		Replace X1_VAR01   With cVar01
	
		Replace X1_F3      With cF3
		Replace X1_GRPSXG  With cGrpSxg
	
		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif
	
		Replace X1_CNT01   With cCnt01
		If cGSC == "C"			// Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1
	
			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2
	
			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3
	
			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4
	
			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif
	
		Replace X1_HELP  With cHelp
	
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
		MsUnlock()
	Else
	
	   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
	   lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
	   lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)
	
	   If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort 
	         SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa 
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif
	
	RestArea( aArea )
Endif	
Return
