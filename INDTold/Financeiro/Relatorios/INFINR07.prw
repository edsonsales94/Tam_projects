#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INFINR07 º Autor ³ Ener Fredes        º Data ³  29/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório para conciliacao contabil                        º±±
±±º          ³ 										                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ INDT                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INFINR07
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Posição de PA's "
Local titulo        := "Conciliacao Contabil"
Local nLin          := 80
Local Cabec1        := ""
Local Cabec2        := ""
Local aOrd          := {}
Local cPerg         := PADR("INFINR07",Len(SX1->X1_GRUPO))

Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "INFINR07" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "INFINR07" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SE2"

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//              1               2                    3                 4                   5
Cabec1 := Padr("Dt.Emissao",12)+Padr("Dt.Pgto",12)+Padr("Historico",45)+Padl("Vlr Previsto",20)+Padl("Vlr Pago",20)+Padl("Total Pago",20)

Processa({|| ExecProc(Cabec1,Cabec2,Titulo,nLin) }, "Filtrando dados")
Return

Static Function ExecProc(Cabec1,Cabec2,Titulo,nLin)
	Local cQuery          
	Local cHistorico
	Private aDados := {}  

	cQuery := " SELECT E2_FILIAL,E2_PREFIXO,E2_NUM,A2_CONTA,E2_EMISSAO,A2_NOME,E2_VALOR,E2_TIPO,ISNULL(E5_VALOR,0) E5_VALOR,ISNULL(E5_DATA,'') E5_DATA
	cQuery += " FROM "+RetSqlName("SE2")+" SE2 
	cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_FILIAL = E2_FILIAL AND A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2.D_E_L_E_T_ = '' 
	cQuery += " LEFT OUTER JOIN "+RetSqlName("SE5")+" SE5 ON E5_FILIAL = E2_FILIAL AND E5_NUMERO = E2_NUM AND E5_PREFIXO = E2_PREFIXO AND E5_PARCELA = E2_PARCELA AND E5_TIPO = E2_TIPO AND E5_CLIFOR = E2_FORNECE AND E5_LOJA = E2_LOJA AND SE5.D_E_L_E_T_ = '' 
	cQuery += " WHERE SE2.D_E_L_E_T_ = '' 
	cQuery += " AND E2_TIPO NOT IN('PR','PA')
	cQuery += " AND E2_FILIAL  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQuery += " AND E2_EMISSAO BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"'
	cQuery += " AND A2_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'
	cQuery += " ORDER BY E2_EMISSAO,E2_FORNECE


	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"PREV",.T.,.T.)
	TCSetField("PREV","E2_EMISSAO","D",8,0)	
	TCSetField("PREV","E5_DATA","D",8,0)	
	DbSelectArea("PREV")
	DbGotop()
	While !PREV->(Eof())	
		AAdd(aDados,{PREV->E2_FILIAL,PREV->A2_CONTA,PREV->E2_EMISSAO,PREV->E5_DATA,PREV->E2_PREFIXO,PREV->E2_NUM,PREV->A2_NOME,PREV->E2_VALOR,PREV->E5_VALOR})
		PREV->(DbSkip())	
	End
	DbSelectArea("PREV")
	DbCloseArea("PREV")
	
	If MV_PAR08 == 2
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Else  
		Processa({|| RunExcel()},Titulo)
	EndIf	 
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  01/12/06   º±±
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
	Local nCol01 := 0
	Local nCol02 := nCol01 + 12
	Local nCol03 := nCol02 + 12
	Local nCol04 := nCol03 + 50
	Local nCol05 := nCol04 + 20
	Local nCol06 := nCol05 + 20
	Local nTotPrev := 0
	Local nTotPgto := 0
	Local nDiaPrev := 0
	Local nDiaPgto := 0
	Local dData := cTod("//")
	Local cHistorico := ""
	Local nPgto := 0
	Local nCont := 1
	Local x
	SetRegua(Len(aDados))
		
	For x := 1 to Len(aDados)
		Incregua()
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		If MV_PAR07 == 1
			If !Empty(dData)
				If dData <> aDados[x,3]
					@nLin,nCol02 PSAY Padl("Total "+Dtoc(dData),50)
					@nLin,nCol04 PSAY Transform(nDiaPrev,"@E 999,999,999.99")
					@nLin,nCol05 PSAY Transform(nDiaPgto,"@E 999,999,999.99")
					nDiaPrev := 0               
					nDiaPgto := 0
					nLin++
					@nLin,nCol01 PSAY Replicate("-",132)
					nLin++
				EndIf
			EndIf
		EndIf	
		@nLin,nCol01 PSAY Dtoc(aDados[x,3])
		@nLin,nCol02 PSAY Dtoc(aDados[x,4])
		If cHistorico <> Left(aDados[x,5]+" "+aDados[x,6]+" "+aDados[x,7],45)
			@nLin,nCol03 PSAY Left(aDados[x,5]+" "+aDados[x,6]+" "+aDados[x,7],45)
			@nLin,nCol04 PSAY Transform(aDados[x,8],"@E 999,999,999.99")          
			nPgto := aDados[x,9]
			nCont := 1
		Else
			@nLin,nCol03 PSAY Space(45)
			@nLin,nCol04 PSAY Space(14)
			nPgto += aDados[x,9]
			nCont ++
		EndIf
		@nLin,nCol05 PSAY Transform(aDados[x,9],"@E 999,999,999.99")
		If x < Len(aDados)
			If cHistorico <> Left(aDados[x+1,5]+" "+aDados[x+1,6]+" "+aDados[x+1,7],45)
				If nCont > 1
					@nLin,nCol06 PSAY Transform(nPgto,"@E 999,999,999.99")          
				EndIf
			EndIf	
      EndIf
		nTotPrev += aDados[x,8]
		nTotPgto += aDados[x,9]
		nDiaPrev += aDados[x,8]
		nDiaPgto += aDados[x,9]
		nLin++                  
		cHistorico := Left(aDados[x,5]+" "+aDados[x,6]+" "+aDados[x,7],45)
		dData := aDados[x,3]
	Next
	If nCont > 1
		@nLin,nCol06 PSAY Transform(nPgto,"@E 999,999,999.99")          
	EndIf
	If MV_PAR07 == 1
		If !Empty(dData)
			@nLin,nCol02 PSAY Padl("Total "+Dtoc(dData),50)
			@nLin,nCol04 PSAY Transform(nDiaPrev,"@E 999,999,999.99")
			@nLin,nCol05 PSAY Transform(nDiaPgto,"@E 999,999,999.99")
			nDiaPrev := 0               
			nDiaPgto := 0
			nLin++
			@nLin,nCol01 PSAY Replicate("-",132)
			nLin++
		EndIf
	EndIf
	nLin+= 2
	@nLin,nCol02 PSAY Padl("Total",50)
	@nLin,nCol04 PSAY Transform(nTotPrev,"@E 999,999,999.99")
	@nLin,nCol05 PSAY Transform(nTotPgto,"@E 999,999,999.99")

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return

Static Function RunExcel()
	Local oExcelApp                           
	Local cArqTxt   := "C:\Temp\INFINR07.xls"
	Local nTotPrev := 0
	Local nTotPgto := 0
	Local cHistorico := ""
	Local nPgto := 0
	Local nCont := 1
	Local x
	Private nHdl       := fCreate(cArqTxt)
	Private cLinha     := ""
	
	cLinha := "Dt.Emissao"+Chr(9)
	cLinha += "Dt.Pgto"+Chr(9)
	cLinha += "Historico"+Chr(9)
	cLinha += "Vlr Previsto"+Chr(9)
	cLinha += "Vlr Pago"+Chr(9) 
	cLinha += "Total Pago"+Chr(9)
	cLinha += chr(13)+chr(10)
	fWrite(nHdl,cLinha,Len(cLinha))
	
	ProcRegua(Len(aDados))
		
	For x := 1 to Len(aDados)
		IncProc()

		cLinha := Dtoc(aDados[x,3])+Chr(9)
		cLinha += Dtoc(aDados[x,4])+Chr(9)
		If cHistorico <> Left(aDados[x,5]+" "+aDados[x,6]+" "+aDados[x,7],45)
			cLinha += Left(aDados[x,5]+" "+aDados[x,6]+" "+aDados[x,7],45)+Chr(9)
			cLinha += Alltrim(Str(aDados[x,8]))+Chr(9)
			nPgto := aDados[x,9]
			nCont := 1
		Else
			cLinha += Chr(9)+Chr(9)
			nPgto += aDados[x,9]
			nCont ++
		EndIf
		cLinha += Alltrim(Str(aDados[x,9]))+Chr(9)
		If x < Len(aDados)
			If cHistorico <> Left(aDados[x+1,5]+" "+aDados[x+1,6]+" "+aDados[x+1,7],45)
				If nCont > 1
					cLinha += Alltrim(Str(nPgto))+Chr(9)
				EndIf
			EndIf	
      EndIf
		cLinha += chr(13)+chr(10)
		fWrite(nHdl,cLinha,Len(cLinha))
		nTotPrev += aDados[x,8]
		nTotPgto += aDados[x,9]
		cHistorico := Left(aDados[x,5]+" "+aDados[x,6]+" "+aDados[x,7],45)
	Next

	cLinha := Chr(9)+Chr(9)
	cLinha += "Total:"+Chr(9)
	cLinha += Alltrim(Str(nTotPrev))+Chr(9)
	cLinha += Alltrim(Str(nTotPgto))+Chr(9)
	cLinha += chr(13)+chr(10)
	fWrite(nHdl,cLinha,Len(cLinha))

	fClose(nHdl)     
	If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
		MsgStop( 'MsExcel nao instalado' ) 
		Return
	EndIf  
	oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cArqTxt) 
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.  
Return             

Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01","Da Filial        ?","Da Filial        ?","Da Filial        ?","mv_ch1","C",02,0,0,"G","","   ","","","mv_par01")
	u_INPutSX1(cPerg,"02","Ate a Filial     ?","Ate a Filial     ?","Ate a Filial     ?","mv_ch2","C",02,0,0,"G","","   ","","","mv_par02")
	u_INPutSX1(cPerg,"03","Da Emissao       ?","Da Emissao       ?","Da Emissao       ?","mv_ch3","D",08,0,0,"G","","   ","","","mv_par03")
	u_INPutSX1(cPerg,"04","Ate Emissao      ?","Ate Emissao      ?","Ate Emissao      ?","mv_ch4","D",08,0,0,"G","","   ","","","mv_par04")
	u_INPutSX1(cPerg,"05","Da Conta         ?","Da Conta         ?","Da Conta         ?","mv_ch5","C",20,0,0,"G","","CT1","","","mv_par05")
	u_INPutSX1(cPerg,"06","Ate a Conta      ?","Ate a Conta      ?","Ate a Conta      ?","mv_ch6","C",20,0,0,"G","","CT1","","","mv_par06")
   u_INPutSx1(cPerg,"07","Totaliza Periodo ?","Totaliza Periodo ?","Totaliza Periodo ?","mv_ch7","N",01,0,0,"C","",""   ,"","","mv_par07","Sim","","","","Não","","","","","","","","","","","")
   u_INPutSx1(cPerg,"08","Gera em Excel    ?","Gera em Excel    ?","Gera em Excel    ?","mv_ch8","N",01,0,0,"C","",""   ,"","","mv_par08","Sim","","","","Não","","","","","","","","","","","")
Return
