#INCLUDE "Rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INGPEP01  º Autor ³ RONILTON           º Data ³  01/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geração do arquivo de líquidos e contra-cheques para o     º±±
±±º          ³ Banco Itaú.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPE - Processos                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function INGPEP01()
	Local oDlg
	Local cPerg := PADR("INGPEP01",Len(SX1->X1_GRUPO))
	
	Private nSeq    := 1
	Private nSeqArq := 1
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Exportacao do Arquivo ContraCheque")
	@ 02,10 TO 080,190
	@ 10,018 Say " Esse programa tem finalidade em enviar a estrutura    "
	@ 18,018 Say " formatada em TXT                                      "
	
	@ 60,088 BMPBUTTON TYPE 05 ACTION Pergunte("INGPEP01",.T.)
	@ 60,118 BMPBUTTON TYPE 01 ACTION (Processa({|| Exportacao() },"Processando..."),Close(oDlg))
	@ 60,148 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	
	Activate Dialog oDlg Centered
	
Return

********************************************************************************************************************

Static Function Exportacao()
	Private cArqTxt
	Private nHdl
	Private nFunc  := 0
	Private TMP    := ""
	Private cCampo := ""
	
	cArqTxt := alltrim(MV_PAR18)
	if AT(".TXT",UPPER(MV_PAR18)) == 0
		cArqTxt := alltrim(MV_PAR18)+".TXT"
	Endif
	
	nHdl := fCreate(cArqTxt)
	
	ProcRegua(PesqReg())
	
	TabSRA() // Cria Tabela de Funcionarios TSRA
	
	if !TSRA->(EOF())
		HEADER_A()
		HEADER_L()
		nSeqArq := 2
		While !TSRA->(EOF())
			IncProc()
			DETALHE_A()
			DETALHE_D()
			nSeqArq += 2
			DETALHE_E("1") // Debito
			DETALHE_E("2") // Credito
			DETALHE_F()
			nSeqArq += 1
			nSeq++
			TSRA->(dbSkip())
		EndDo
		TRAILLER_L()
		nSeqArq += 2
		TRAILLER_A()
	Endif
	
	TSRA->(dbCloseArea())
	fClose(nHdl)
	
Return

******************************************************************************************************************

Static Function HEADER_A()  // Header de Arquivo
	Local cLin := ""
	
	cLin := "341" //Codigo do Banco 001 - 003  -> 3
	cLin += "0000" // Lote de Servico 004 - 0007  -> 4
	cLin += "0" // Tipo de registro 008 - 008 -> 1
	cLin += Space(06) // Brancos 009 - 014 -> 6
	cLin += "080" // Layout de Arquivo 015 - 017 -> 3
	cLin += "2" // Tipo da Inscricao da Empresa 2 = CNPJ  018 - 018 -> 1
	cLin += PADL(AllTrim(SM0->M0_CGC),14,"0") // Numero da Inscricao 019 - 032 -> 14
	cLin += Space(20) // Brancos 033 - 052 -> 20
	cLin += PADL(AllTrim(MV_PAR12),05,"0") // Agencia 053 - 057 -> 5
	cLin += Space(01) // Brancos 058 - 058 -> 1
	cLin += PADL(AllTrim(MV_PAR13),12,"0") // Conta 059 - 070 -> 12
	cLin += Space(01) // Brancos 071 - 071 -> 1
	cLin += PADL(AllTrim(MV_PAR14),01,"0") // DAC 072 - 072 -> 1
	cLin += PADR(AllTrim(SM0->M0_NOME),30) // Nome da Empresa 073 - 102 -> 30
	cLin += PADR("BANCO ITAU S/A",30)  // Nome do Banco 103- 132 -> 30
	cLin += Space(10) // Brancos 133 - 142 -> 10
	cLin += "1" // Arquivo-Codigo 1 = Remessa 143 - 143 -> 1
	cLin +=  PADR(CovDt(dDataBase),8) // Data da Geracao 144 - 151 -> 8
	cLin +=  PADR(STRTRAN(Time(),":",""),6) // Hora da Geracao 152 - 157 -> 6
	cLin += Replicate("0",09) // Zeros 158 - 166 -> 09
	cLin += Replicate("0",05) // Unidade de Densidade 167 - 171 -> 5
	cLin += Space(69) // Brancos 172 - 240 -> 69
	cLin += chr(13)+chr(10)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	EndIf
	
Return

********************************************************************************************************************

Static Function TRAILLER_A()
	Local cLin := ""
	
	cLin := "341" //Codigo do Banco 001 - 003  -> 3
	cLin += "9999" // Lote de Servico 004 - 0007  -> 4
	cLin += "9" // Tipo de registro 008 - 008 -> 1
	cLin += Space(09)// Brancos 009 - 017 -> 9
	cLin += PADL(1,06,"0") // Qtd Lote 018 - 023 -> 6
	cLin += PADL(STRZERO(nSeqArq,5),06,"0") // Numero Sequencial 024 - 029 -> 6
	cLin += Space(211)// Brancos 030 - 240 -> 171
	cLin += chr(13)+chr(10)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	EndIf
	
Return

********************************************************************************************************************

Static Function HEADER_L()  // Header de Lote
	Local cLin := ""
	
	cLin := "341" //Codigo do Banco 001 - 003  -> 3
	cLin += "0001" // Lote de Servico 004 - 0007  -> 4
	cLin += "1" // Tipo de registro 008 - 008 -> 1
	cLin += "C" // Tipo da Operacao C = Credito 009 - 009 -> 1
	cLin += "30" // Tipo do Pagamento 010 - 011 -> 2
	cLin += "01" // Forma de Pagamento 012 - 013 -> 2
	cLin += "040" // Layout do Lote 014 - 016 -> 3
	cLin += Space(01) // Brancos 017 - 017 -> 1
	cLin += "2" // Tipo da Inscricao da Empresa 2 = CNPJ  018 - 018 -> 1
	cLin += PADL(AllTrim(SM0->M0_CGC),14,"0") // Numero da Inscricao 019 - 032 -> 14
	cLin += Space(20) // Brancos 033 - 052 -> 20
	cLin += PADL(AllTrim(MV_PAR12),05,"0") // Agencia 053 - 057 -> 5
	cLin += Space(01) // Brancos 058 - 058 -> 1
	cLin += PADL(AllTrim(MV_PAR13),12,"0") // Conta 059 - 070 -> 12
	cLin += Space(01) // Brancos 071 - 071 -> 1
	cLin += PADL(AllTrim(MV_PAR14),01,"0") // DAC 072 - 072 -> 1
	cLin += PADR(AllTrim(SM0->M0_NOME),30) // Nome da Empresa 073 - 102 -> 30
	cLin += "01" // Finalidade do Lote 103- 104 -> 02
	cLin += Space(28)  // Finalidade do Lote (Restante) 105- 132 -> 28
	cLin += Space(10) // Historico C/C 133 - 142 -> 10
	cLin += PADR(SM0->M0_ENDCOB,30) // Endereco da Empresa 143 - 172 -> 30
	cLin += PADL(SUBSTR(SM0->M0_ENDCOB,25,5),05,"0") // Numero 173 - 177 -> 5  ???????
	cLin += PADR(SM0->M0_COMPCOB,15) // Complemento 178 - 192 -> 15
	cLin += PADR(SM0->M0_CIDCOB,20) // Cidade 193 - 212 -> 20
	cLin += PADL(SM0->M0_CEPCOB,08,"0") // CEP 213 - 220 -> 8
	cLin += PADR(SM0->M0_ESTCOB,02) // Estado 221 - 222 -> 2
	cLin += Space(08) // Brancos 123 - 230 -> 8
	cLin += Space(10) // Ocorrencias 131 - 240 -> 10
	cLin += chr(13)+chr(10)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	EndIf
	
Return
********************************************************************************************************************

Static Function TRAILLER_L()
	Local cLin := ""
	
	cLin := "341" //Codigo do Banco 001 - 003  -> 3
	cLin += "0001" // Lote de Servico 004 - 0007  -> 4
	cLin += "5" // Tipo de registro 008 - 008 -> 1
	cLin += Space(09)// Brancos 009 - 017 -> 9
	cLin += PADL(STRZERO(nSeqArq,5),06,"0") // Numero Sequencial 018 - 023 -> 6
	cLin += PADL(CovNum(SomaTotal("0047")),18,"0") //Total de ValorPago 024 - 041 -> 1 ?????
	cLin += Replicate("0",18) // Zeros 042 - 059 -> 18
	cLin += Space(171)// Brancos 060 - 230 -> 171
	cLin += Space(10)// Brancos 231 - 240 -> 10
	cLin += chr(13)+chr(10)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	EndIf
	
Return

********************************************************************************************************************

Static Function DETALHE_A()  // Detalhe segmento A
	Local cLin := ""
	
	cLin := "341" //Codigo do Banco 001 - 003  -> 3
	cLin += "0001" // Lote de Servico 004 - 0007  -> 4
	cLin += "3" // Tipo de registro 008 - 008 -> 1
	cLin += PADL(STRZERO(nSeq,5),05,"0") // Numero Sequencial 009 - 013 ->
	cLin += "A" // Seguimento 014 - 014 -> 1
	cLin += "000" // Tipo do Movimento 015 - 017 -> 3
	cLin += "000" // Zero 018 - 020 -> 3
	cLin += "341" // Branco Favorecido 021 - 023 -> 3
	cLin += "0" // Zero 024 - 024 -> 1
	cLin += SUBSTR(TSRA->RA_BCDEPSA,4,4) // Codigo Agencia Favorecido 025 - 028 -> 4
	cLin += Space(01) // Branco 029 - 029 -> 1
	cLin += Replicate("0",07) // Zeros 030 - 036 -> 7
	cLin += SUBSTR(TSRA->RA_CTDEPSA,1,5) // Numero C/C 037 - 041 -> 5
	cLin += Space(01) // Branco 042 - 042 -> 1
	cLin += SUBSTR(TSRA->RA_CTDEPSA,6,1) // DAC 043 - 043 -> 1
	cLin += SUBSTR(TSRA->RA_NOME,1,30) // Nome do Favorecido 044 - 073 -> 30
	cLin += PADR(TSRA->RA_MAT,20) // NUM.DOC.ATRIB. 074 - 093 -> 20
	cLin += CovDt(MV_PAR15) // DATA CREDITO 094 - 101 -> 8
	cLin += "REA" // TIPO MOEDA "REA" 102 - 104 -> 3
	cLin += Replicate("0",15) // Zero 105 - 119 -> 15
	cLin += PADL(CovNum(SomaVerbas("0047")),15,"0")  // Valor do Credito 120 - 134 -> 15  // ??????
	cLin += Space(15) // Nosso Numero 135 - 149 -> 15
	cLin += Space(05) // Branco 050 - 054 -> 5
	cLin += Replicate("0",08) // Data Efetiva do Pg 155 - 162 -> 8
	cLin += Replicate("0",15) // Valor Efetivo 163 - 177 -> 15
	cLin += Space(18) // Finalidade Detalhe 178 - 195 -> 18
	cLin += Space(02) // Branco 196 - 197 -> 2
	cLin += Replicate("0",06) // Numero do Documento 198 - 203 -> 6
	cLin += PADL(TSRA->RA_CIC,14,"0") // Numero da CPF 204 - 217 -> 14
	cLin += Space(12) // Literal 218 - 229 -> 12
	cLin += Space(1) // Aviso ao Favorecido 230 - 230 -> 1
	cLin += Space(10) // Ocorrencia 231 - 240 -> 10
	cLin += chr(13)+chr(10)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	EndIf
	
Return

********************************************************************************************************************

Static Function DETALHE_D()  // Detalhe segmento D
	Local cLin := ""
	
	cLin := "341" //Codigo do Banco 001 - 003  -> 3
	cLin += "0001" // Lote de Servico 004 - 0007  -> 4
	cLin += "3" // Tipo de registro 008 - 008 -> 1
	cLin += PADL(STRZERO(nSeq,5),05,"0") // Numero Sequencial 009 - 013 ->
	cLin += "D" // Seguimento 014 - 014 -> 1
	cLin += Space(03) // Brancos 015 - 017 -> 3
	cLin += MV_PAR16 // Mes/Ano Pag. 018 - 023 -> 3
	cLin += PADR(TSRA->CTT_DESC01,15) // C.Custo  024 - 038 -> 15
	cLin += PADR(TSRA->RA_MAT,15) // Funcionario 039 - 053 -> 15
	cLin += PADR(TSRA->RJ_DESC,30) // Branco 054 - 083 -> 30
	// ?????????????????????????????
	if TSRA->RA_SITFOLH = 'F'
		cLin += PADL(CovDt(BuscaData("I")),8,"0") //PER FERIAS DE 084 - 091 -> 8   Inicio
		cLin += PADL(CovDt(BuscaData("F")),8,"0") //PER FERIAS ATE 092 - 099 -> 8  Fim
	Else
		cLin += PADL("",8,"0") //PER FERIAS DE 084 - 091 -> 8
		cLin += PADL("",8,"0") //PER FERIAS ATE 092 - 099 -> 8
	Endif
	cLin += PADL(ALLTRIM(TSRA->RA_DEPIR),2,"0") //Dependente 100 - 101 -> 2
	cLin += PADL(ALLTRIM(TSRA->RA_DEPSF),2,"0") //Dependente 102 - 103 -> 2
	cLin += PADL(TSRA->RA_HRSEMAN,2,"0") //Dependente 104 - 105 -> 2
	cLin += PADL(CovNum(SomaVerbas("0013,0014,0019,0020")),15,"0") // Salario Contribuicao 106 - 120 -> 15   Ex:99900
	cLin += PADL(CovNum(SomaVerbas("0109,0018")),15,"0") // FGTS 121 - 135 -> 15   Ex:99900
	cLin += PADL(CovNum(SomaCredito("1")),15,"0") // Tot. Credito 136 - 150 -> 15   Ex:99900  Credito
	cLin += PADL(CovNum(SomaCredito("2")),15,"0") // Tot. Credito 151 - 165 -> 15   Ex:99900  Debito
	cLin += PADL(CovNum(SomaVerbas("0047,0021")),15,"0") // Liquido de Pag. 166 - 180 -> 15   Ex:99900
	cLin += PADL(CovNum(SomaVerbas("0318")),15,"0") // Salario Base 181 - 195 -> 15   Ex:99900
	cLin += PADL(CovNum(SomaVerbas("0015,0016,0027,0100")),15,"0") // Base IRRF 196 - 210 -> 15   Ex:99900
	cLin += PADL(CovNum(SomaVerbas("0017,0108")),15,"0") // Base FGTS 211 - 225 -> 15   Ex:99900
	cLin += PADL(MV_PAR17,2,"0") // Periodo de Disponibilizacao 226 - 227 -> 2
	cLin += Space(03) // Brancos 228 - 230 -> 3
	cLin += Space(10) // Codigo Ocorrencia Retorno 231 - 240 -> 10
	cLin += chr(13)+chr(10)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	EndIf
	
Return

********************************************************************************************************************

Static Function CovNum(nNum)
	Local  nI,nD
	
	nI := int(nNum)
	nd := (nNum - nI)*100
	
Return(ALLTRIM(STR(nI))+STRZERO(nD,2))

********************************************************************************************************************

Static Function CovDt(dDt)
Return STRzero(DAY(dDt),2)+STRZERO(MONTH(dDt),2) + STRZERO(YEAR(dDt),4)

********************************************************************************************************************

Static Function ValidPerg(cPerg)
	Local _sAlias := Alias()
	Local i, j 
	DbSelectArea("SX1")
	DbSetOrder(1)
	aRegs :={}
	
	AADD(aRegs,{cPerg,"01","Do Centro Custo    ?","","","mv_ch01","C",09,0,0,"G","","mv_par01",;
	"","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"02","Ate o Centro Custo ?","","","mv_ch02","C",09,0,0,"G","","mv_par02",;
	"","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"03","Da Matricula  ?","","","mv_ch03","C",06,0,0,"G","","mv_par03",;
	"","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"04","Ate a Matricula  ?","","","mv_ch04","C",06,0,0,"G","","mv_par04",;
	"","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"05","Situacao (Funcionario) ?","","","mv_ch05","C",20,0,0,"G","fSituacao()","mv_par05",;
	"","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Categoria (Funcionario) ?","","","mv_ch06","C",20,0,0,"G","fCategoria()","mv_par06",;
	"","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Do Banco/Agencia ?", "","", "mv_ch07","C", 08, 0,0,"G","", "MV_PAR07","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08","Ate Banco/Agencia ?", "","", "mv_ch08","C", 08, 0,0,"G","", "MV_PAR08","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"09","Da Conta Corrente ?", "","", "mv_ch09","C", 12, 0,0,"G","", "MV_PAR09","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10","Até Conta Corrente ?", "","", "mv_ch10","C", 12, 0,0,"G","", "MV_PAR10","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	
	aAdd(aRegs,{cPerg,"11","Banco da Empresa ?", "","", "mv_ch11","C", 3, 0,0,"G","", "MV_PAR11","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"12","Agencia da Empresa ?", "","", "mv_ch12","C", 5, 0,0,"G","", "MV_PAR12","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"13","Conta da Empresa ?", "","", "mv_ch13","C", 12, 0,0,"G","", "MV_PAR13","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"14","DAC ?", "","", "mv_ch14","C", 1, 0,0,"G","", "MV_PAR14","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"15","Data Referente ao Credito?", "","", "mv_ch15","D", 8, 0,0,"G","", "MV_PAR15","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"16","MesAno Referencia do Doc.?", "","", "mv_ch16","C", 6, 0,0,"G","", "MV_PAR16","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"17","Prazo Holerite ?", "","", "mv_ch17","N", 2, 0,0,"G","", "MV_PAR17","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"18","Salvar Arquivo em ?", "","", "mv_ch18","C", 40, 0,0,"G","", "MV_PAR18","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"19","Mensagem 1 ?", "","", "mv_ch19","C", 48, 0,0,"G","", "MV_PAR19","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"20","Mensagem 2 ?", "","", "mv_ch20","C", 48, 0,0,"G","", "MV_PAR20","","","","",;
	"","","","","","","","","","","","","","","","","","","","","",""})
	
	For i:=1 to Len(aRegs)
		If !DbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)
	
Return

********************************************************************************************************************

Static Function PesqReg()
	Local cQry
	Local cAlias := Alias()
	Local nRet   := 0
	
	//-- Tabela de Funcionarios
	cQry := "SELECT COUNT(*) TOTAL"
	cQry += " FROM"
	cQry += " (SELECT SRA.RA_FILIAL, SRA.RA_MAT"
	cQry += QueryPadrao(xFilial("SRA"),,,,.T.)
	cQry += FormataStr("SRA.RA_CATFUNC",MV_PAR06)
	cQry += FormataStr("SRA.RA_SITFOLH",MV_PAR05)
	cQry += " GROUP BY SRA.RA_FILIAL, SRA.RA_MAT) A"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
	nRet := TMP->TOTAL
	dbCloseArea()
	dbSelectArea(cAlias)
	
Return nRet

********************************************************************************************************************

Static Function TabSRA()
	Local cQry, cCampos
	
	cCampos := "SRA.RA_FILIAL, SRA.RA_BCDEPSA, SRA.RA_CTDEPSA, SRA.RA_NASC, SRA.RA_NOME, SRA.RA_MAT, SRA.RA_CIC, SRA.RA_CC, SRA.RA_CODFUNC, "
	cCampos += "SRA.RA_SITFOLH, SRA.RA_DEPIR, SRA.RA_DEPSF, SRA.RA_HRSEMAN, CTT.CTT_DESC01, SRJ.RJ_DESC "
	
	//-- Tabela de Funcionarios
	cQry := "SELECT "+cCampos
	cQry += QueryPadrao(xFilial("SRA"),,,,.T.)
	cQry += FormataStr("SRA.RA_CATFUNC",MV_PAR06)
	cQry += FormataStr("SRA.RA_SITFOLH",MV_PAR05)
	cQry += " GROUP BY "+cCampos
	cQry += " ORDER BY SRA.RA_FILIAL, SRA.RA_MAT"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TSRA",.T.,.T.)
	
Return

********************************************************************************************************************

Static Function FormataStr(cCampo,cString)
	Local nX
	Local cRet := ""
	
	cString := StrTran(RTrim(cString),"*","")
	
	If !Empty(cString)
		For nX:=1 To Len(cString)
			cRet += SubStr(cString,nX,1)+","
		Next
		cRet := " AND "+cCampo+" IN "+FormatIn(PADR(cRet,Len(cRet)-1),",")
	Endif
	
Return cRet

********************************************************************************************************************

Static Function SomaTotal(cVerbas)
	Local cQry
	Local cAlias := Alias()
	Local nRet   := 0
	
	//-- Tabela de Funcionarios
	cQry := "SELECT SUM(SRC.RC_VALOR) TOTAL "
	cQry += QueryPadrao(xFilial("SRA"),,,cVerbas)
	cQry += FormataStr("SRA.RA_CATFUNC",MV_PAR06)
	cQry += FormataStr("SRA.RA_SITFOLH",MV_PAR05)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
	nRet := TMP->TOTAL
	dbCloseArea()
	dbSelectArea(cAlias)
	
Return nRet

********************************************************************************************************************

Static Function SomaVerbas(cVerbas)
	Local cQry
	Local cAlias := Alias()
	Local nRet   := 0
	
	//-- Tabela Soma de Vebas
	cQry := "SELECT SUM(SRC.RC_VALOR) TOTAL"
	cQry += QueryPadrao(TSRA->RA_FILIAL,TSRA->RA_MAT,,cVerbas)
	cQry += FormataStr("SRA.RA_CATFUNC",MV_PAR06)
	cQry += FormataStr("SRA.RA_SITFOLH",MV_PAR05)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
	nRet := TMP->TOTAL
	dbCloseArea()
	dbSelectArea(cAlias)
	
Return nRet

********************************************************************************************************************

Static Function BuscaData(cTipo)
	Local cQry
	Local cAlias := Alias()
	Local cRet
	
	cQry := "SELECT RH_MAT, MAX(RH_DATAINI) DATAINI, MAX(RH_DATAFIM) DATAFIM"
	cQry += " FROM "+RetSqlName("SRH")
	cQry += " WHERE D_E_L_E_T_ = ' '"
	cQry += " AND RH_FILIAL = '"+TSRA->RA_FILIAL+"'"
	cQry += " AND RH_MAT = '"+TSRA->RA_MAT+"'"
	cQry += " GROUP BY RH_MAT"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
	
	if cTipo = "I" // Inicio
		cRet := STOD(TMP->DATAINI)
	Else  // Fim
		cRet := STOD(TMP->DATAFIM)
	Endif
	
	TMP->(dbCloseArea())
	dbSelectArea(cAlias)
	
Return cRet

********************************************************************************************************************

Static Function SomaCredito(cTipo)
	Local cQry
	Local cAlias := Alias()
	Local nRet   := 0
	//-- Tabela Soma de Vebas
	
	cQry := "SELECT SUM(SRC.RC_VALOR) TOTAL"
	cQry += QueryPadrao(TSRA->RA_FILIAL,TSRA->RA_MAT,cTipo)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
	nRet := TMP->TOTAL
	dbCloseArea()
	dbSelectArea(cAlias)
	
Return nRet

********************************************************************************************************************

Static Function DETALHE_E(cTipo)  // Detalhe segmento E
	Local cQry
	Local cLin    := ""
	Local cAlias  := Alias()
	Local cModelo := Space(30)+Space(05)+Replicate("0",15)
	Local nPos    := 1
	Local nX 
	cLin := "341" //Codigo do Banco 001 - 003  -> 3
	cLin += "0001" // Lote de Servico 004 - 0007  -> 4
	cLin += "3" // Tipo de registro 008 - 008 -> 1
	cLin += PADL(STRZERO(nSeq,5),05,"0") // Numero Sequencial 009 - 013 ->
	cLin += "E" // Seguimento 014 - 014 -> 1
	cLin += Space(03) // Brancos 015 - 017 -> 3
	cLin += cTipo // Tipo do Movimento 1 = Debito, 2 = Credito 018 - 018 -> 1
	
	cQry := "SELECT SRC.RC_MAT, SRV.RV_COD, SRV.RV_TIPOCOD, SRV.RV_DESC, SRC.RC_VALOR"
	cQry += QueryPadrao(TSRA->RA_FILIAL,TSRA->RA_MAT,cTipo)
	cQry += " ORDER BY SRC.RC_MAT, SRV.RV_COD, SRV.RV_TIPOCOD"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
	dbSelectArea("TMP")
	
	if TMP->(EOF())
		cLin := cModelo
	Else
		While !TMP->(EOF())
			if nPos == 5 // Cria Novo Detalhe segmento E
				// Final do Seguimento E
				cLin += Space(12) // Brancos 219 - 230 -> 3
				cLin += Space(10) // Codigo Ocorrencia Retorno 231 - 240 -> 10
				cLin += chr(13)+chr(10)
				
				If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				EndIf
				// Inicio do Novo seguimento E
				cLin := "341" //Codigo do Banco 001 - 003  -> 3
				cLin += "0001" // Lote de Servico 004 - 0007  -> 4
				cLin += "3" // Tipo de registro 008 - 008 -> 1
				cLin += PADL(STRZERO(nSeq,5),05,"0") // Numero Sequencial 009 - 013 ->
				cLin += "E" // Seguimento 014 - 014 -> 1
				cLin += Space(03) // Brancos 015 - 017 -> 3
				cLin += cTipo // Tipo do Movimento 1 = Debito, 2 = Credito 018 - 018 -> 1
				nSeqArq += 1
				nPos := 1
			Endif
			cLin += PADR(TMP->RV_COD+"-"+TMP->RV_DESC,30)+Space(05)+PADL(CovNum(TMP->RC_VALOR),15,"0")
			nPos++
			TMP->(dbSkip())
		Enddo
		// Preenche o resto do campo
		For nx := nPos to 4
			cLin += cModelo
		Next
	Endif
	
	cLin += Space(12) // Brancos 219 - 230 -> 3
	cLin += Space(10) // Codigo Ocorrencia Retorno 231 - 240 -> 10
	cLin += chr(13)+chr(10)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	EndIf
	
	nSeqArq += 1
	
	TMP->(dbCloseArea())
	dbSelectArea(cAlias)
	
Return

********************************************************************************************************************

Static Function QueryPadrao(cFil,cMat,cTipo,cVerbas,lParam)
	Local cRet
	
	cRet := " FROM "+RetSqlName("SRC")+" SRC"
	cRet += " INNER JOIN "+RetSqlName("SRA")+" SRA ON SRA.D_E_L_E_T_ = ' ' AND SRA.RA_FILIAL = SRC.RC_FILIAL AND SRA.RA_MAT = SRC.RC_MAT"
	
	If lParam <> Nil .And. lParam
		cRet += " AND SRA.RA_BCDEPSA BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
		cRet += " AND SRA.RA_CTDEPSA BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
	Endif
	
	cRet += " INNER JOIN "+RetSqlName("SRJ")+" SRJ ON SRJ.D_E_L_E_T_ = ' ' AND SRJ.RJ_FUNCAO = SRA.RA_CODFUNC"
	cRet += " INNER JOIN "+RetSqlName("SRV")+" SRV ON SRV.D_E_L_E_T_ = ' ' AND SRV.RV_COD = SRC.RC_PD"
	
	If cTipo <> Nil
		cRet += " AND SRV.RV_TIPOCOD = '"+cTipo+"'"
	Endif
	If cVerbas <> Nil
		cRet += " AND SRV.RV_CODFOL IN "+FormatIn(cVerbas,",")
	Endif
	
	cRet += " INNER JOIN "+RetSqlName("CTT")+" CTT ON CTT.D_E_L_E_T_ = ' ' AND CTT.CTT_CUSTO = SRA.RA_CC"
	cRet += " WHERE SRC.D_E_L_E_T_ = ' '"
	cRet += " AND SRC.RC_FILIAL = '"+cFil+"'"
	
	If lParam <> Nil .And. lParam
		cRet += " AND SRC.RC_CC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
		cRet += " AND SRC.RC_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
	ElseIf cMat <> Nil
		cRet += " AND SRC.RC_MAT = '"+cMat+"'"
	Endif
	
Return cRet

********************************************************************************************************************

Static Function DETALHE_F()  // Detalhe segmento F
	Local cLin := ""
	Local cMsgAniver := "*** O INDT LHE DESEJA UM FELIZ ANIVERSARIO. ***"
	
	cLin := "341" //Codigo do Banco 001 - 003  -> 3
	cLin += "0001" // Lote de Servico 004 - 0007  -> 4
	cLin += "3" // Tipo de registro 008 - 008 -> 1
	cLin += PADL(STRZERO(nSeq,5),05,"0") // Numero Sequencial 009 - 013 ->
	cLin += "F" // Seguimento 014 - 014 -> 1
	cLin += Space(03) // Brancos 015 - 017 -> 3
	cLin += PADR(MV_PAR19+MV_PAR20 + iif(SUBSTR(TSRA->RA_NASC,5,2) = SUBSTR(MV_PAR16,1,2) ,cMsgAniver,""),144) // Mensagem 018 - 161 -> 144
	cLin += Space(69) // Brancos 162 - 230 -> 69
	cLin += Space(10) // Codigo Ocorrencia Retorno 231 - 240 -> 10
	
	cLin += chr(13)+chr(10)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	EndIf
	
Return
