#include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INCTBP10   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 07/09/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de integração entre Protheus x WEX                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INCTBP10()
	Local cPerg   := PADR("INCTBP10",Len(SX1->X1_GRUPO))
	Local aSay    := {}
	Local aButton := {}
	Local nOpc    := 0
	Local cTitulo := "Integração Protheus x WEX"
	Local cDesc1  := "Essa rotina irá processar a integração dos dados contábeis, folha de"
	Local cDesc2  := "pagamento e documentos de entrada com o banco de dados WEX.         "
	Local lOk     := .F.
	
	ValidPerg(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	Endif
	
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	
	aAdd( aButton, { 5, .T., {|x| Pergunte(cPerg) }} )
	aAdd( aButton, { 1, .T., {|x| nOpc := 1, oDlg:End() }} )
	aAdd( aButton, { 2, .T., {|x| nOpc := 2, oDlg:End() }} )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpc == 1
		GravaCCusto()
		If mv_par03 == 1
			Processa( {|| lOk := GravaNotas()    } , "Integrando Notas Fiscais de Entrada" )
		Endif
		If mv_par04 == 1
			Processa( {|| lOk := GravaContabil() } , "Integrando Contabilização" )
		Endif
		If mv_par05 == 1
			Processa( {|| lOk := GravaFolha()    } , "Integrando Folha de Pagamento" )
		Endif
	Endif
	
Return

Static Function GravaFolha()
	Local nC, aGrv, cGrava
	Local cQryWex := ""
	Local cQryIns := ""
	Local cQrySel := ""
	Local cQryFil := ""
	Local cCmpAdi := ""
	Local cAnoMes := SubStr(DtoS(mv_par01),1,6)

	Private cCsvPath := GetTempPath() //path do arquivo texto
	Private cCsvArq  := "EVENTOSRH.xls"  //nome do arquivo csv
	Private nHdl     := fCreate(cCsvPath+cCsvArq)   //arquivo para trabalho
	
	cQryWex := " DECLARE @nControle int"+CRLF
	cQryWex += " SET @nControle =(SELECT ISNULL(MAX(CONTROLE),0)+1 FROM [WEXWEB].[Totvs_Wex].dbo.LOG010 )"+CRLF
	cQryWex += " IF (SELECT COUNT(*)REGIS FROM [WEXWEB].[Totvs_Wex].dbo.EVENTOSRH WHERE ANOMES = '"+cAnoMes+"') > 1"+CRLF
	cQryWex += "      BEGIN "+CRLF
	cQryWex += "        UPDATE [WEXWEB].[Totvs_Wex].dbo.EVENTOSRH SET FLAG = 'D'"+CRLF
	cQryWex += "        FROM [WEXWEB].[Totvs_Wex].dbo.EVENTOSRH"+CRLF
	cQryWex += "        WHERE FLAG <> 'D' "+CRLF
	cQryWex += "        AND ANOMES >= '" + SubStr(DtoS(mv_par01),1,6) + "'"+CRLF
	cQryWex += "        AND ANOMES <= '" + SubStr(DtoS(mv_par02),1,6) + "'"+CRLF
	cQryWex += "      END "+CRLF
	cQryWex += CRLF
	cQryWex += " INSERT INTO [WEXWEB].[Totvs_Wex].dbo.LOG010(CONTROLE,ID_USER,[USER],ORIGEM,DATA)"
	cQryWex += " VALUES (@nControle,'"+__cUserID+"','"+SubStr(cUsuario,7,15)+"','EVENTOS RH',GETDATE())"+CRLF
	
	cQryIns := "Insert into [WEXWEB].[Totvs_Wex].dbo.EVENTOSRH ("+CRLF
	cQryIns += " RA_FILIAL, RA_MAT, RA_NOME, RA_CC, RA_ADMISSA, RA_DEMISSA, RJ_DESC, RA_SALARIO, TOTALFIM, RA_CODFUNC, ANOMES, CONTROLE,"
	cQryIns += " FLAG, RA_CATFUNC, RA_SITFOLH, RD_CC, FOL_PROV"+CRLF
	
	// Campos adicionais de valores
	cCmpAdi  := ", GRPCONTABIL" //, FOL_DESC, FER_PROV, FER_DESC, P13_PROV, P13_DESC, PD799, INSS, FGTS, PIS, ENCARGOS, PLSAUDE, PLODONT, AUX_ALIM,"+CRLF
	//cCmpAdi  += " AUX_OUT, AUX_REF, AUX_TRANSP, BENEFICIOS, PROVFER, PROV13o, PROVTOT, PROVDEM, PROVISAO, PERCCUSTO "+CRLF
	
	cQrySel := "SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, CT2.CCUSTO, SRA.RA_ADMISSA, SRA.RA_DEMISSA, SRJ.RJ_DESC, SRA.RA_SALARIO, CT2.LIQUIDO,"+CRLF
	cQrySel += " SRA.RA_CODFUNC, '"+cAnoMes+"' AS RA_DATARQ, @nControle AS CONTROLE, FLAG = 'A', SRA.RA_CATFUNC, SRA.RA_SITFOLH, CT2.CCUSTO AS RD_CC,"+CRLF
	cQrySel += " SRA.RA_SALARIO AS FOL_PROV"
	
	cQryFil := " FROM "+RetSQLName("SRA")+" SRA"+CRLF
	cQryFil += " INNER JOIN "+RetSQLName("SRJ")+" SRJ ON SRJ.D_E_L_E_T_ = ' ' AND SRJ.RJ_FUNCAO = SRA.RA_CODFUNC"+CRLF    // AND SRJ.RJ_FILIAL = SRA.RA_FILIAL
	cQryFil += " INNER JOIN ("+CRLF
	cQryFil += " SELECT CT2.FILIAL,CT2.FUNCIONARIO, CT2.CCUSTO, CT2.CT1_GRUPO AS GRPCONTABIL, SUM(CT2.CT2_VALORD) AS CT2_VALORD, SUM(CT2.CT2_VALORC) AS CT2_VALORC,"+CRLF
	cQryFil += " SUM(CT2.CT2_VALORD - CT2.CT2_VALORC) AS LIQUIDO"+CRLF
	cQryFil += " FROM ("+CRLF
	cQryFil += " 	SELECT CT2.CT2_FILIAL AS FILIAL,CT2.CT2_ITEMD AS FUNCIONARIO, CT2.CT2_CCD AS CCUSTO, CT1.CT1_GRUPO, SUM(CT2.CT2_VALOR) AS CT2_VALORD, 0 AS CT2_VALORC"+CRLF
	cQryFil += " 	FROM "+RetSQLName("CT2")+" CT2"+CRLF
	cQryFil += " 	INNER JOIN "+RetSQLName("CT1")+" CT1 ON CT1.D_E_L_E_T_ = ' ' AND CT1.CT1_CONTA = CT2.CT2_DEBITO AND CT1.CT1_GRUPO = '001' AND CT1.CT1_XMCT = 'S'"+CRLF
	cQryFil += " 	WHERE CT2.D_E_L_E_T_ = ' '"+CRLF
	cQryFil += " 	AND CT2.CT2_LOTE NOT IN ('009960')"+CRLF
	cQryFil += " 	AND (CT2.CT2_KEY <> 'XX' OR SUBSTRING(CT2.CT2_ROTINA,1,3) = 'GPE')"+CRLF
	cQryFil += " 	AND CT2.CT2_VALOR <> 0"+CRLF
	cQryFil += " 	AND CT2.CT2_CCD <> ' '"+CRLF
	cQryFil += " 	AND CT2.CT2_LP NOT IN ('530','532','597','801','805','820','509','512','514','515','531','564','565','581','589','591','655','656','806','807','814','815','816')"+CRLF
	cQryFil += " 	AND CT2.CT2_TPSALD = '1' AND CT2.CT2_CANC <> 'S'"+CRLF
	cQryFil += " 	AND CT2.CT2_ROTINA <> 'CTBA211'"+CRLF
	cQryFil += " 	AND CT2.CT2_ITEMD <> ' '"+CRLF
	cQryFil += " 	AND CT2.CT2_DATA >= '"+DtoS(mv_par01)+"'"+CRLF
	cQryFil += " 	AND CT2.CT2_DATA <= '"+DtoS(mv_par02)+"'"+CRLF
	cQryFil += " 	GROUP BY CT2.CT2_FILIAL, CT2.CT2_ITEMD, CT2.CT2_CCD, CT1.CT1_GRUPO"+CRLF
	cQryFil += " UNION ALL"+CRLF
	cQryFil += " 	SELECT CT2.CT2_FILIAL AS FILIAL, CT2.CT2_ITEMC AS FUNCIONARIO, CT2.CT2_CCC AS CCUSTO, CT1.CT1_GRUPO, 0 AS CT2_VALORD, SUM(CT2.CT2_VALOR) AS CT2_VALORC"+CRLF
	cQryFil += " 	FROM "+RetSQLName("CT2")+" CT2"+CRLF
	cQryFil += " 	INNER JOIN "+RetSQLName("CT1")+" CT1 ON CT1.D_E_L_E_T_ = ' ' AND CT1.CT1_CONTA = CT2.CT2_CREDIT AND CT1.CT1_GRUPO = '001' AND CT1.CT1_XMCT = 'S'"+CRLF
	cQryFil += " 	WHERE CT2.D_E_L_E_T_ = ' '"+CRLF
	cQryFil += " 	AND CT2.CT2_LOTE NOT IN ('009960')"+CRLF
	cQryFil += " 	AND (CT2.CT2_KEY <> 'XX' OR SUBSTRING(CT2.CT2_ROTINA,1,3) = 'GPE')"+CRLF
	cQryFil += " 	AND CT2.CT2_VALOR <> 0"+CRLF
	cQryFil += " 	AND CT2.CT2_CCC <> ' '"+CRLF
	cQryFil += " 	AND CT2.CT2_LP NOT IN ('530','532','597','801','805','820','509','512','514','515','531','564','565','581','589','591','655','656','806','807','814','815','816')"+CRLF
	cQryFil += " 	AND CT2.CT2_TPSALD = '1' AND CT2.CT2_CANC <> 'S'"+CRLF
	cQryFil += " 	AND CT2.CT2_ROTINA <> 'CTBA211'"+CRLF
	cQryFil += " 	AND CT2.CT2_ITEMC <> ' '"+CRLF
	cQryFil += " 	AND CT2.CT2_DATA >= '"+DtoS(mv_par01)+"'"+CRLF
	cQryFil += " 	AND CT2.CT2_DATA <= '"+DtoS(mv_par02)+"'"+CRLF
	cQryFil += " 	GROUP BY CT2.CT2_FILIAL, CT2.CT2_ITEMC, CT2.CT2_CCC, CT1.CT1_GRUPO"+CRLF
	cQryFil += " ) CT2"+CRLF
	cQryFil += " GROUP BY CT2.FILIAL,CT2.FUNCIONARIO, CT2.CCUSTO, CT2.CT1_GRUPO"+CRLF
	cQryFil += " ) CT2 ON CT2.FILIAL = SRA.RA_FILIAL AND CT2.FUNCIONARIO = SRA.RA_MAT"+CRLF
	cQryFil += " WHERE SRA.D_E_L_E_T_ = ' '"
	
	cGrava := cQryWex+cQryIns+cCmpAdi+")"+cQrySel+cCmpAdi+cQryFil

	MemoWrite( cCsvPath + "FOLHA_WEX.txt", cGrava )

	If TCSQlExec(cGrava) < 0
		MsgAlert("Erro no processamento da Integração da Folha com o WEX","ATENÇÃO")
		Alert("TCSQLError() " + TCSQLError())
	Else
		MsgInfo("Integração da Folha concluída com sucesso !","Protheus x WEX")

		cQry := "SELECT *"
		cQry += " FROM [WEXWEB].[Totvs_Wex].dbo.EVENTOSRH WEX"
		cQry += " WHERE WEX.FLAG <> 'D'"
		cQry += " AND ANOMES >= '" + SubStr(DtoS(mv_par01),1,6) + "'"
		cQry += " AND ANOMES <= '" + SubStr(DtoS(mv_par02),1,6) + "'"

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"WEX",.T.,.T.)

		If !(Bof() .And. Eof())
			aGrv := {}
			For nC:=1 To FCount()
				AAdd( aGrv , WEX->(FieldName(nC)) )
			Next
			u_AddCSV(aGrv)
		Endif
		
		While !Eof()

			aGrv := {}
			For nC:=1 To FCount()
				AAdd( aGrv , WEX->(FieldGet(nC)) )
			Next
			u_AddCSV(aGrv)

			dbSkip()
		Enddo
		dbCloseArea()
		
		u_INRunExcel(cCsvPath,cCsvArq)   //abrir arquivo csv
	EndIf
	
Return cQryWex+cQryIns+cCmpAdi+")"+cQrySel+cCmpAdi+cQryFil

Static Function GravaContabil()
	Local cFunc := "INDT_RUB_" + SM0->M0_CODIGO
	Local nRet  := 0
	
	MsgRun("Gravando dados contábeis",,{|| nRet := TCSQLExec(cFunc+" '"+DtoS(mv_par01)+"','"+DtoS(mv_par02)+"','"+__cUserID+"','"+SubStr(cUsuario,7,15)+"'" ) })

	If nRet < 0
		MsgAlert("Erro no processamento da Integração Contábil com o WEX","ATENÇÃO")
		Alert("TCSQLError() " + TCSQLError())
	Else
		MsgInfo("Integração Contábil concluída com sucesso !","Protheus x WEX")
	EndIf

Return

Static Function GravaNotas()
	Local cQryWex := ""
	Local cQryIns := ""
	Local cQrySel := ""
	Local cQryFil := ""
	
	cQryWex := " DECLARE @nControle int"+CRLF
	cQryWex += " SET @nControle =(SELECT ISNULL(MAX(CONTROLE),0)+1 FROM [WEXWEB].[Totvs_Wex].dbo.LOG010 )"+CRLF
	cQryWex += " IF (SELECT COUNT(*)REGIS FROM [WEXWEB].[Totvs_Wex].dbo.NFISCAL WHERE EMISSAO >= '"+DtoS(mv_par01)+"' AND EMISSAO <= '"+DtoS(mv_par02)+"') > 1"+CRLF
	cQryWex += "      BEGIN "+CRLF
	cQryWex += "        UPDATE [WEXWEB].[Totvs_Wex].dbo.NFISCAL SET FLAG = 'D'"+CRLF
	cQryWex += "        FROM [WEXWEB].[Totvs_Wex].dbo.NFISCAL"+CRLF
	cQryWex += "        WHERE EMISSAO >= '"+DtoS(mv_par01)+"' AND EMISSAO <= '"+DtoS(mv_par02)+"' AND FLAG <> 'D' "+CRLF
	cQryWex += "      END "+CRLF
	cQryWex += CRLF
	cQryWex += " INSERT INTO [WEXWEB].[Totvs_Wex].dbo.LOG010(CONTROLE,ID_USER,[USER],ORIGEM,DATA)"
	cQryWex += " VALUES (@nControle,'"+__cUserID+"','"+SubStr(cUsuario,7,15)+"','NFISCAL',GETDATE())"+CRLF
	
	cQryIns := "Insert into [WEXWEB].[Totvs_Wex].dbo.NFISCAL ("+CRLF
	cQryIns += " FILIAL, NOTA, SERIE, FORNECEDOR, LOJA, EMISSAO, NOMEFOR, PRODUTO, DESCRICAO, VALOR, CONTROLE, FLAG)"+CRLF
	
	cQrySel := "SELECT SD1.D1_FILIAL, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_DTDIGIT, SD1.A2_NOME,"+CRLF
	cQrySel += " SD1.D1_COD, SD1.B1_DESC, SD1.D1_TOTAL, @nControle AS CONTROLE, FLAG = 'A'"+CRLF
	
	cQryFil := " FROM ("+CRLF
	cQryFil += " SELECT SD1.D1_FILIAL, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_DTDIGIT, SUBSTRING(SA2.A2_NOME,1,30) AS A2_NOME, SD1.D1_COD,"+CRLF
	cQryFil += " SUBSTRING(SB1.B1_DESC,1,30) AS B1_DESC, SUM(CT2.CT2_VALOR) AS D1_TOTAL"+CRLF
	cQryFil += " FROM "+RetSQLName("CT2")+" CT2"+CRLF
	cQryFil += " INNER JOIN ("+CRLF
	cQryFil += " 	SELECT SD1.D1_FILIAL, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_DTDIGIT, SD1.D1_COD, SD1.D1_ITEM, SUM(SD1.D1_TOTAL) AS D1_TOTAL"+CRLF
	cQryFil += " 	FROM "+RetSQLName("SD1")+" SD1"+CRLF
	cQryFil += " 	WHERE SD1.D_E_L_E_T_ = ' '"+CRLF
	cQryFil += " 	GROUP BY SD1.D1_FILIAL, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_DTDIGIT, SD1.D1_COD, SD1.D1_ITEM"+CRLF
	cQryFil += " ) SD1 ON SD1.D1_FILIAL+SD1.D1_DOC+SD1.D1_SERIE+SD1.D1_FORNECE+SD1.D1_LOJA+SD1.D1_COD+SD1.D1_ITEM = CT2.CT2_KEY"+CRLF
	cQryFil += " INNER JOIN "+RetSQLName("SA2")+" SA2 ON SA2.D_E_L_E_T_ = ' ' AND SA2.A2_FILIAL = SD1.D1_FILIAL AND SA2.A2_COD = SD1.D1_FORNECE AND SA2.A2_LOJA = SD1.D1_LOJA"+CRLF
	cQryFil += " INNER JOIN "+RetSQLName("SB1")+" SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SD1.D1_COD"+CRLF
	cQryFil += " INNER JOIN "+RetSQLName("CT1")+" CT1 ON CT1.D_E_L_E_T_ = ' ' AND CT1.CT1_CONTA = CT2.CT2_DEBITO AND CT1.CT1_XMCT = 'S'"
	cQryFil += " WHERE CT2.D_E_L_E_T_ = ' '"+CRLF
	cQryFil += " AND CT2.CT2_LOTE NOT IN ('009960')"+CRLF
	cQryFil += " AND (CT2.CT2_KEY <> 'XX' OR SUBSTRING(CT2.CT2_ROTINA,1,3) = 'GPE')"+CRLF
	cQryFil += " AND CT2.CT2_VALOR <> 0 AND (CT2.CT2_CCD <> ' ' OR CT2.CT2_CCC <> ' ')"+CRLF
	cQryFil += " AND CT2.CT2_LP NOT IN ('530','532','597','801','805','820','509','512','514','515','531','564','565','581','589','591','655','656','806','807','814','815','816')"+CRLF
	cQryFil += " AND CT2.CT2_TPSALD = '1' AND CT2.CT2_CANC <> 'S'"+CRLF
	cQryFil += " AND CT2.CT2_ROTINA <> 'CTBA211'"+CRLF
	//cQryFil += " AND SUBSTRING(CT2.CT2_DEBITO,1,6) IN "+FormatIn(cContas,",")+CRLF
	cQryFil += " AND CT2.CT2_DATA >= '"+DtoS(mv_par01)+"'"+CRLF
	cQryFil += " AND CT2.CT2_DATA <= '"+DtoS(mv_par02)+"'"+CRLF
	cQryFil += " GROUP BY SD1.D1_FILIAL, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_DTDIGIT, SUBSTRING(SA2.A2_NOME,1,30), SD1.D1_COD, SUBSTRING(SB1.B1_DESC,1,30)"+CRLF
	cQryFil += ") AS SD1"+CRLF
	
	If TCSQlExec(cQryWex+cQryIns+cQrySel+cQryFil) < 0
		MsgAlert("Erro no processamento da Integração da Notas com o WEX","ATENÇÃO")
		Alert("TCSQLError() " + TCSQLError())
	Else
		MsgInfo("Integração das Notas concluída com sucesso !","Protheus x WEX")
	EndIf

Return

Static Function GravaCCusto()
	Local cQryIns := ""
	Local cQrySel := ""
	Local cQryFil := ""
	
	cQryIns := "Insert into [WEXWEB].[wex-custos].dbo.CENTROCUSTO (Codigo, Nome)"+CRLF
	cQrySel := "SELECT CTT.CTT_CUSTO, CTT.CTT_DESC01"+CRLF
	cQryFil :=  "FROM "+RetSQLName("CTT")+" CTT"+CRLF
	cQryFil +=  " LEFT OUTER JOIN [WEXWEB].[wex-custos].dbo.CENTROCUSTO WEX ON WEX.Codigo = CTT.CTT_CUSTO"+CRLF
	cQryFil +=  " WHERE CTT.D_E_L_E_T_ = ' '"+CRLF
	cQryFil +=  " AND CTT.CTT_CLASSE = '2'"+CRLF
	cQryFil +=  " AND CTT.CTT_BLOQ <> '1'"+CRLF
	cQryFil +=  " AND WEX.Codigo IS NULL"+CRLF
	
	If TCSQlExec(cQryIns+cQrySel+cQryFil) < 0
		MsgAlert("Erro no processamento da Integração dos Centros de Custo com o WEX","ATENÇÃO")
		Alert("TCSQLError() " + TCSQLError())
	Endif
	
Return

Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01", PADR("Da Data                    ",29)+"?", "", "", "mv_ch1", "D", 8, 0, 0, "G", "", "   ", "", "", "mv_par01")
	u_INPutSX1(cPerg,"02", PADR("Ate a Data                 ",29)+"?", "", "", "mv_ch2", "D", 8, 0, 0, "G", "", "   ", "", "", "mv_par02")
	u_INPutSX1(cPerg,"03", PADR("Integrar Notas de entrada  ",29)+"?", "", "", "mv_ch3", "N", 1, 0, 0, "C", "", "   ", "", "", "mv_par03","Sim","","","","Nao")
	u_INPutSX1(cPerg,"04", PADR("Integrar Contabilidade     ",29)+"?", "", "", "mv_ch4", "N", 1, 0, 0, "C", "", "   ", "", "", "mv_par04","Sim","","","","Nao")
	u_INPutSX1(cPerg,"05", PADR("Integrar Folha de Pagamento",29)+"?", "", "", "mv_ch5", "N", 1, 0, 0, "C", "", "   ", "", "", "mv_par05","Sim","","","","Nao")
Return
