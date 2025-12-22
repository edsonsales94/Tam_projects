#Include "Protheus.Ch"
#Include "Colors.ch"
#Include "Font.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} OGSFATDES

Relatorio de Conferencia Faturamento X Folha p/ Desoneracao.

@type function
@author Fausto Costa
@since 03/09/2012

/*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  | OGSFATDES   บAutor ณFausto Costa       บ	Data ณ 03/09/2012 บฑฑ
ฑฑฬออออออออออุอออออออออออออสออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Conferencia Faturamento X Folha p/ Desoneracaoบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10/11                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function OGSFATDES()

Local oReport
Local cPerg := "OGSFATDES"

If TRepInUse()
	ValidPerg(@cPerg)
	Pergunte(cPerg,.F.)
	
	oReport := ReportDef(cPerg)
	oReport:PrintDialog()
EndIf

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao	 ณReportDef ณ Autor ณ Fausto Costa        ณ Data ณ 03/09/2012 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Montagem do layout do relatorio.                           ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ReportDef(cPerg)

Local oReport, oSection
Local cTitulo := "Relatorio Desonera็ใo para Confer๊ncia Faturamento X Folha de Pagamento"

oReport:= TReport():New("OGSFATDES",cTitulo,"OGSFATDES",{|oReport| PrintReport(oReport)},cTitulo)
oReport:SetPortrait(.T.)
oReport:SetTotalInLine(.F.)

oSection := TRSection():New(oReport,"Relatorio de Conferencia Faturamento com Folha de Pagamento",{"SD2"})

TRCell():New(oSection,"FILIAL"	,, "Filial"			)
TRCell():New(oSection,"EMISSAO"	,, "Emissใo"		)
TRCell():New(oSection,"SERIE"	,, "Serie"			)
TRCell():New(oSection,"DOC"		,, "Nota Fiscal"	)
TRCell():New(oSection,"COD"		,, "Produto"		)
TRCell():New(oSection,"NCM"		,, "NCM"			)
TRCell():New(oSection,"cCodAtiv",, "Codigo Ativ."	)
TRCell():New(oSection,"CFOP"	,, "CFOP"			)
TRCell():New(oSection,"TOTAL"	,, "Valor Total"	)

Return (oReport)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณ Fausto Costa  	 ณ Data ณ 03/09/2012  ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna Notas Fiscais que Faturamento Bruto			      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport(oReport)

Local oSection		:= oReport:Section(1)
Local cQuery 		:= ""
Local cQueryD1 		:= ""
Local aCFOPs		:= XFUNCFRec()
Local cCodNew       := ""
Local cCodNew2      := ""
Local cCodAtiv  	:= "0"
Local cCodAtiv2  	:= "0"
Local aCodAtiv  	:= {}
Local bCodAtiv  	:= {}

cQuery := " SELECT"
cQuery +=		" D2.D2_FILIAL, D2.D2_EMISSAO, D2.D2_DOC, D2.D2_SERIE, D2.D2_COD, B1.B1_POSIPI, D2.D2_CF,"
cQuery +=		" CASE LEFT(D2.D2_CF, 1) WHEN '7' THEN ' '	ELSE B5.B5_CODATIV END AS ZZCODATV,	D2.D2_TOTAL"
// SQL 		-	cQuery +=		" CASE LEFT(D2.D2_CF, 1) WHEN '7' THEN ' '	ELSE B5.B5_CODATIV END AS ZZCODATV,	D2.D2_TOTAL"
// ORACLE 	-	cQuery +=		" CASE WHEN SUBSTR(D2.D2_CF,1,1) = '7' THEN ' '	WHEN SUBSTR(D2.D2_CF,1,1) <> '7' THEN B5.B5_CODATIV END AS ZZCODATV, D2.D2_TOTAL" // Fausto
cQuery += " FROM " + RetSqlName( "SD2" ) + " D2"
cQuery += 		" INNER JOIN " + RetSqlName( "SB1" ) + " B1 ON B1.B1_COD = D2.D2_COD AND B1.D_E_L_E_T_ = ' '"
cQuery += 		" INNER JOIN " + RetSqlName( "SB5" ) + " B5 ON B5.B5_COD = D2.D2_COD AND B5.D_E_L_E_T_ = ' '"
cQuery += " WHERE"
cQuery += 		" D2.D2_FILIAL BETWEEN '"  + MV_PAR01 + "' AND '"+ MV_PAR02 + "' AND"
cQuery += 		" D2.D2_TIPO = 'N'  AND D2.D2_QTDEDEV = '0' AND"
cQuery += 		" D2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' AND"
cQuery += 		" B5.B5_CODATIV >= '"  + MV_PAR05 + "' AND B5.B5_CODATIV <= '"+ MV_PAR06 + "' AND"
cQuery += 		" D2.D_E_L_E_T_ = ' '"
cQuery += " ORDER BY ZZCODATV, D2.D2_DOC, D2.D2_SERIE, D2.D2_COD"

If Select("QRY") <> 0
	QRY->(dbCloseArea())
Endif

TcQuery cQuery Alias "QRY" New


oSection:Init()
oReport:SetMeter(QRY->(LastRec()))

QRY->(dbGoTop())
While !QRY->( Eof() )
	
	oReport:IncMeter()
	
	
	&&&&&&&&&&&&&&& 1o. PASSO - L๓gica para buscar o c๓digo de atividade
	
	If Alltrim(QRY->D2_CF)$ aCFOPs[1] .and. !Alltrim(QRY->D2_CF)$ aCFOPs[2]
		If SB5->(FieldPos('B5_INSPAT')) > 0 .and. SB5->(FieldPos('B5_CODATIV')) > 0
			If SubStr(QRY->D2_CF,1,1) <> "7" .and. (Posicione("SB5",1,xFilial("SB5")+QRY->D2_COD,"B5_INSPAT") == "1")
				cCodAtiv :=	Posicione("SB5",1,xFilial("SB5")+QRY->D2_COD,"B5_CODATIV")
			Else
				cCodAtiv := ""
			EndIf
	
	
			nPos := Ascan(aCodAtiv, { |x| x[1] == cCodAtiv })
			If nPos > 0
				aCodAtiv[nPos,02] += QRY->D2_TOTAL			&& Somat๓rio
			Else
				aAdd(aCodAtiv, {cCodAtiv, QRY->D2_TOTAL} )	&& Adiciona C๓d. Atividade no Vetor para somat๓ria
				nPos := Len(aCodAtiv)
			Endif
    
			&&&&&&&&&&&&&&& 2o. PASSO - Impressใo do registro
			oSection:Cell("FILIAL"	):SetValue(QRY->D2_FILIAL)
			oSection:Cell("EMISSAO"	):SetValue(QRY->D2_EMISSAO)
			oSection:Cell("SERIE"	):SetValue(QRY->D2_SERIE)
			oSection:Cell("DOC"		):SetValue(QRY->D2_DOC)
			oSection:Cell("COD"		):SetValue(QRY->D2_COD)
			oSection:Cell("NCM"		):SetValue(QRY->B1_POSIPI)
			oSection:Cell("cCodAtiv"):SetValue(cCodAtiv)
			oSection:Cell("CFOP"	):SetValue(QRY->D2_CF)
			oSection:Cell("TOTAL"	):SetValue(QRY->D2_TOTAL)
			oSection:PrintLine()            

		Endif
	EndIf
	
	QRY->(dbSkip())
	
	
	&&&&&&&&&&&&&&& 3o. PASSO - Verifica se mudou o c๓digo de atividade e imprime totalizador
	&&&&&&&&&&&&&&&             cCodNew - ้ o c๓digo referente ao pr๓ximo registro
	If Alltrim(QRY->D2_CF)$ aCFOPs[1] .and. !Alltrim(QRY->D2_CF)$ aCFOPs[2]
		If SB5->(FieldPos('B5_INSPAT')) > 0 .and. SB5->(FieldPos('B5_CODATIV')) > 0
			If SubStr(QRY->D2_CF,1,1) <> "7" .and. (Posicione("SB5",1,xFilial("SB5")+QRY->D2_COD,"B5_INSPAT") == "1")
				cCodNew :=	Posicione("SB5",1,xFilial("SB5")+QRY->D2_COD,"B5_CODATIV")
			Else
				cCodNew := ""
			EndIf
		Endif
	EndIf
	
	
	If ((cCodAtiv <> cCodNew) .AND. !(cCodAtiv == "0")) .OR. (QRY->( Eof() ))	&& Compara o c๓digo atividade registro anterior com o atual
		
		oSection:Cell("FILIAL"	):SetValue("")
		oSection:Cell("EMISSAO"	):SetValue("")
		oSection:Cell("SERIE"	):SetValue("")
		oSection:Cell("DOC"		):SetValue("")
		oSection:Cell("COD"		):SetValue("")
		oSection:Cell("NCM"		):SetValue("")
		oSection:Cell("cCodAtiv"):SetValue("Total Receita Bruta:")
		oSection:Cell("CFOP"	):SetValue("")
		oSection:Cell("TOTAL"	):SetValue(aCodAtiv[nPos,02])
		oSection:PrintLine()
		
		aCodAtiv := {}	&& Reinicia Vetor
		oReport:SkipLine()
	EndIf
Enddo
QRY->(dbCloseArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessamento das notas de devolu็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SD1->(DBSETORDER(1))

WHILE SD1->(!EOF())
	IF (SD1->(D1_EMISSAO>=MV_PAR03 .AND. D1_EMISSAO<=MV_PAR04 .AND. D1_FILIAL>=MV_PAR01 .AND. D1_FILIAL<=MV_PAR02 .AND. D1_TIPO=="D"))
		SD2->(dbSetOrder(3))
		If SD2->(dbSeek(xFilial("SD2")+SD1->(D1_NFORI+D1_SERIORI)))
			IF (INSSPAT(SD2->D2_COD,SD2->D2_CF,.T.) .AND. (Alltrim(SD2->D2_CF)$ aCFOPs[1] .AND. !Alltrim(SD2->D2_CF)$ aCFOPs[2]))
				cCodAtiv2 := POSICIONE("SB5",1,XFILIAL("SB5")+SD2->D2_COD,"B5_CODATIV")
				nPos := Ascan(bCodAtiv, { |x| x[1] == cCodAtiv2 })
				If nPos > 0
					bCodAtiv[nPos,02] += SD1->D1_TOTAL			&& Somat๓rio
				Else
					aAdd(bCodAtiv, {cCodAtiv2, SD1->D1_TOTAL} )	&& Adiciona C๓d. Atividade no Vetor para somat๓ria
					nPos := Len(bCodAtiv)
				Endif
		    
		    	&&&&&&&&&&&&&&& 2o. PASSO - Impressใo do registro
		    	oSection:Cell("FILIAL"	):SetValue(SD1->D1_FILIAL)
				oSection:Cell("EMISSAO"	):SetValue(SD1->D1_EMISSAO)
				oSection:Cell("SERIE"	):SetValue(SD1->D1_SERIE)
				oSection:Cell("DOC"		):SetValue(SD1->D1_DOC)
				oSection:Cell("COD"		):SetValue(SD1->D1_COD)
				oSection:Cell("NCM"		):SetValue("")
				oSection:Cell("cCodAtiv"):SetValue(cCodAtiv2)
				oSection:Cell("CFOP"	):SetValue(SD1->D1_CF)
				oSection:Cell("TOTAL"	):SetValue(SD1->D1_TOTAL)
				oSection:PrintLine()

			ENDIF
		ENDIF
	ENDIF

SD1->(dbSkip())

	&&&&&&&&&&&&&&& 3o. PASSO - Verifica se mudou o c๓digo de atividade e imprime totalizador
	&&&&&&&&&&&&&&&             cCodNew - ้ o c๓digo referente ao pr๓ximo registro
	IF (SD1->(D1_EMISSAO>=MV_PAR03 .AND. D1_EMISSAO<=MV_PAR04 .AND. D1_FILIAL>=MV_PAR01 .AND. D1_FILIAL<=MV_PAR02 .AND. D1_TIPO=="D"))
		SD2->(dbSetOrder(3))
		If SD2->(dbSeek(xFilial("SD2")+SD1->(D1_NFORI+D1_SERIORI)))
			IF (Alltrim(SD2->D2_CF)$ aCFOPs[1] .AND. !Alltrim(SD2->D2_CF)$ aCFOPs[2])
				IF(INSSPAT(SD2->D2_COD,SD2->D2_CF,.F.))
					cCodNew2 := POSICIONE("SB5",1,XFILIAL("SB5")+SD2->D2_COD,"B5_CODATIV")
				ENDIF
	   		ENDIF
	   	ENDIF
	EndIf

	If (cCodAtiv2 <> cCodNew2 .AND. cCodAtiv2 <> "0") //.OR. SD1->(Eof()))	&& Compara o c๓digo atividade registro anterior com o atual
	   	oSection:Cell("FILIAL"	):SetValue("")
		oSection:Cell("EMISSAO"	):SetValue("")
		oSection:Cell("SERIE"	):SetValue("")
		oSection:Cell("DOC"		):SetValue("")
		oSection:Cell("COD"		):SetValue("")
		oSection:Cell("NCM"		):SetValue("")
		oSection:Cell("cCodAtiv"):SetValue("Total Exclusoes:")
		oSection:Cell("CFOP"	):SetValue("")
		oSection:Cell("TOTAL"	):SetValue(bCodAtiv[nPos,02])
		oSection:PrintLine()
		
		bCodAtiv := {}	&& Reinicia Vetor
		oReport:SkipLine()
	EndIf
Enddo        

oSection:Finish()

/*/   
	cQueryD1 := " SELECT"
	cQueryD1 +=		" D1.D1_FILIAL, D1.D1_EMISSAO, D1.D1_DOC, D1.D1_SERIE, D1.D1_COD, B1.B1_POSIPI, D1_CF, "
	cQueryD1 +=		" CASE WHEN SUBSTR(D1.D1_CF,1,1) = '3' THEN ' '	WHEN SUBSTR(D1.D1_CF,1,1) <> '3' THEN B5.B5_CODATIV END AS ZZCODATV, D1.D1_TOTAL" // Fausto
	cQueryD1 += " FROM " + RetSqlName( "SD1" ) + " D1"
	cQueryD1 += 		" INNER JOIN " + RetSqlName( "SB1" ) + " B1 ON B1.B1_COD = D1.D1_COD AND B1.D_E_L_E_T_ = ' '"
	cQueryD1 += 		" INNER JOIN " + RetSqlName( "SB5" ) + " B5 ON B5.B5_COD = D1.D1_COD AND B5.D_E_L_E_T_ = ' '"
	cQueryD1 += " WHERE "
	cQueryD1 += 		" D1.D1_FILIAL BETWEEN '"  + MV_PAR01 + "' AND '"+ MV_PAR02 + "' AND"
	cQueryD1 += 		" D1.D1_TIPO = 'D' AND"
	cQueryD1 += 		" D1.D1_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' AND"
	cQueryD1 += 		" D1.D_E_L_E_T_ = ' '"
	cQueryD1 += " ORDER BY ZZCODATV, D1.D1_DOC, D1.D1_SERIE, D1.D1_COD"
        
	If Select("QRY") <> 0
		QRY->(dbCloseArea())
	Endif
	
	TcQuery cQueryD1 Alias "QRY" New	
	//dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQueryD1 ), QRY, .F., .T. )		
		
	oSection1:Init()
	oReport:SetMeter(QRY->(LastRec()))
		
	QRY->(dbGoTop())
	
	While !QRY->( Eof() )
			
		oReport:IncMeter()
		
		If SB5->(FieldPos('B5_INSPAT')) > 0 .AND. SB5->(FieldPos('B5_CODATIV')) > 0
			SD2->(dbSetOrder(3))
			If SD2->(dbSeek(xFilial("SD2")+(QRY)->D1_NFORI + (QRY)->D1_SERIORI))
				If !(Alltrim(SD2->D2_CF)$ aCFOPs[1] .And. !Alltrim(SD2->D2_CF)$ aCFOPs[2] .AND. SubStr(SD2->D2_CF,1,1) <> "7" .AND. (Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"B5_INSPAT") == "1"))					
					dbskip()
					Loop
				EndIf	
		 		cCodAtiv := Posicione("SB5",1,xFilial("SB5")+(QRY)->D1_COD,"B5_CODATIV")
				If !Empty(cCodAtiv)	
					nPos := Ascan(aCodAtiv, { |x| x[1] == cCodAtiv })
					If nPos > 0
						aCodAtiv[nPos,02] += QRY->D1_TOTAL			&& Somat๓rio
					Else
						aAdd(aCodAtiv, {cCodAtiv, QRY->D1_TOTAL} )	&& Adiciona C๓d. Atividade no Vetor para somat๓ria
						nPos := Len(aCodAtiv)
					Endif

					&&&&&&&&&&&&&&& 2o. PASSO - Impressใo do registro
					oSection1:Cell("D1_FILIAL"	):SetValue(QRY->D1_FILIAL)
					oSection1:Cell("D1_EMISSAO"	):SetValue(QRY->D1_EMISSAO)
					oSection1:Cell("D1_SERIE"	):SetValue(QRY->D1_SERIE)
					oSection1:Cell("D1_DOC"		):SetValue(QRY->D1_DOC)
					oSection1:Cell("D1_COD"		):SetValue(QRY->D1_COD)
					oSection1:Cell("B1_POSIPI"	):SetValue(QRY->B1_POSIPI)
					oSection1:Cell("cCodAtiv"	):SetValue(cCodAtiv)
					oSection1:Cell("D1_CF"		):SetValue(QRY->D1_CF)
					oSection1:Cell("D1_TOTAL"	):SetValue(QRY->D1_TOTAL)
					oSection1:PrintLine() 
				EndIf
			EndIf				
		EndIf
		    			
	    QRY->(dbSkip())


		&&&&&&&&&&&&&&& 3o. PASSO - Verifica se mudou o c๓digo de atividade e imprime totalizador
		&&&&&&&&&&&&&&&             cCodNew - ้ o c๓digo referente ao pr๓ximo registro
		If Alltrim(QRY->D1_CF)$ aCFOPs[1] .and. !Alltrim(QRY->D1_CF)$ aCFOPs[2]
			If SB5->(FieldPos('B5_INSPAT')) > 0 .and. SB5->(FieldPos('B5_CODATIV')) > 0
				If SubStr(QRY->D1_CF,1,1) <> "3" .and. (Posicione("SB5",1,xFilial("SB5")+QRY->D1_COD,"B5_INSPAT") == "1")
					cCodNew :=	Posicione("SB5",1,xFilial("SB5")+QRY->D1_COD,"B5_CODATIV")
				Else
					cCodNew := ""
				EndIf
			Endif
		EndIf

	
		If ((cCodAtiv <> cCodNew) .AND. !(cCodAtiv == "0")) .OR. (QRY->( Eof() ))	&& Compara o c๓digo atividade registro anterior com o atual
			oSection1:Cell("D1_FILIAL"	):SetValue("")
			oSection1:Cell("D1_EMISSAO"	):SetValue("")
			oSection1:Cell("D1_SERIE"	):SetValue("")
			oSection1:Cell("D1_DOC"		):SetValue("")
			oSection1:Cell("D1_COD"		):SetValue("")
			oSection1:Cell("B1_POSIPI"	):SetValue("")
			oSection1:Cell("cCodAtiv"	):SetValue("Total:")
			oSection1:Cell("D1_CF"		):SetValue("")
			oSection1:Cell("D1_TOTAL"	):SetValue(aCodAtiv[nPos,02])
			oSection1:PrintLine()
			
			aCodAtiv := {}	&& Reinicia Vetor
			oReport:SkipLine()
		EndIf
	Enddo

QRY->(dbCloseArea())
oSection1:Finish()
/*/
Return


// FUNวAO DE VALIDAวรO DO SB5
STATIC FUNCTION INSSPAT(cProd,cCF,cCod)

SB5->(DBSETORDER(1))
IF SB5->(DBSEEK(XFILIAL("SB5")+cProd))
    IF  (SB5->B5_CODATIV >= MV_PAR05 .AND. SB5->B5_CODATIV <= MV_PAR06)
		IF cCod
			IF SB5->B5_INSPAT == "1" .AND. SB5->B5_CODATIV <> ""
				IF SUBSTR(cCF,1,1) <> "7"
					cCodAtiv := SB5->B5_CODATIV
				ELSE 
					cCodAtiv := ""
				ENDIF
			ENDIF
		ELSE
			IF ((SB5->B5_INSPAT == "1" .AND. SB5->B5_CODATIV <> "") .AND. SUBSTR(cCF,1,1) <> "7")
				cCodNew := SB5->B5_CODATIV
			ELSE 
				cCodNew := ""
			ENDIF
		ENDIF       
		RETURN (.T.)
	ENDIF
	RETURN (.F.) 
ELSE
	RETURN (.F.)
ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณ Fausto Costa  	 ณ Data ณ 03/09/2012  ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se existe um grupo de perguntas caso contrario o    บฑฑ
ฑฑบ          ณ o grupo de perguntas e criado.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
DbSetOrder(1)

cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
PutSx1(cPerg,"01", "Filial De ?          	 "	, 	"", "", "MV_CH1", "C", 02	, 0, 0, "G", ""				, "   ", "", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSx1(cPerg,"02", "Filial Ate ?          	 "	, 	"", "", "MV_CH2", "C", 02	, 0, 0, "G", ""				, "   ", "", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSx1(cPerg,"03", "Data De ?          		 "	, 	"", "", "MV_CH3", "D", 08	, 0, 0, "G", "NaoVazio()"	, "   ", "", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSx1(cPerg,"04", "Data Ate ?          	 "	, 	"", "", "MV_CH4", "D", 08	, 0, 0, "G", "NaoVazio()"	, "   ", "", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSx1(cPerg,"05", "Codigo de Atividade de?	 "	, 	"", "", "MV_CH5", "C", 08	, 0, 0, "G", ""				, "   ", "", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSx1(cPerg,"06", "Codigo de Atividade ate? "	, 	"", "", "MV_CH6", "C", 08	, 0, 0, "G", ""				, "   ", "", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next i

DbSelectArea(_sAlias)

Return .T.
