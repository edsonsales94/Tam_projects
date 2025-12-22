#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "ap5mail.ch"
#INCLUDE "Fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ HLEDI001 บAutor  ณ Mauro Yokota - Kiboo Data ณ  22/01/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ EDI - Transmissao de dados.                                บฑฑ
ฑฑบ          ณ Honda Lock -> Toyota                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 12                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function HLEDI002

	Local aArea		:= GetArea()
	Local cPerg		:= 'HLEDI002  '
	Local oDlg, oSay1
	Local cLocArq	:= "\EDI_TOYOTA\"
	//	Local cLocNm	:= "Local/Nome do Arquivo: "
	//	Local oLibF		:= LibFunctions():MaLoc()

	ValidPerg(cPerg)

	Pergunte(cPerg,.f.)
	
	Define MsDialog oDlg Title "Gera็ใo de Arquivo EDI - Embalagem" From 189,200 To 325,750 Pixel
	
	@ 004,004 To 045,273 Label "" Pixel Of oDlg
	@ 014,009 Say "Este programa tem o objetivo de gerar arquivo em formato TXT com base nas Notas Fiscais de Saida. " Size 300,018 Color CLR_BLACK Pixel Of oDlg
	@ 024,009 Say "Para gerar o arquivo, selecione os documentos de saida, s้rie e o caminho aonde o  arquivo serแ gravado." Size 300,021 Color CLR_BLACK Pixel Of oDlg
	@ 034,009 Say oSay1 Var (cLocArq) Size 300,021 Color CLR_BLACK Pixel Of oDlg	
	@ 050,004 Button "Parโmetros" 	Size 052,013 Action (Pergunte(cPerg, .T.)) 		Pixel Of oDlg
	@ 050,115 Button "Processar"	Size 052,013 Action (fSetLocF(@cLocArq,oSay1) ) Pixel Of oDlg
	@ 050,221 Button "Sair"       	Size 052,013 Action (oDlg:End()) 				Pixel Of oDlg
	
	Activate MsDialog oDlg Centered
	
	RestArea(aArea)
	
Return Nil

Static Procedure fSetLocF(cLocArq,oSay)

	If MsgYesNo("Confirma a Gera็ใo do EDI?")
		Processa({|| fCrtFEdi(cLocArq)},"Aguarde! Processando dados...")
	Endif

Return Nil

Static Procedure fCrtFEdi(cLocArq)

	Local cLine		:= ""
	Local nSeq		:= StrZero(GetMv("HL_SEQTOY"),5)
	Local nControl	:= ""
//	Local nQtdReg	:= 0
	Local nSValBrut	:= 0
	Local cQry 		:= ""
	//Local cHondaSum := GetMv("NS_HNDSUM")	
	//cTexto	:= "Texte de Grava็ใo"
	//cNomArqLog	:= "\HLAFAT01_" + DToS(Date()) + "_" +  StrTran(Time(), ":", "") + ".Log"
	//MemoWrite(cNomArqLog, cTexto)   
	//cArq 	:= fOpen(cArqTxt,2)
	
	Private cArqTxt	:= UPPER("\EDI_TOYOTA\AEM-HLS-EMB_"+allTrim(MV_PAR01)+".TXT")
	
	//cArq 	:= fCreate(UPPER(cArqTxt),FC_NORMAL)
	cArq 	:= fCreate(UPPER(cArqTxt),,,.F.)
	/*
	Local cFile := "d:\teste.txt"
	Local nF1 := fCreate(upper(cFile),,,.f.)
	*/
	fConsSQL(@cQry)
	
	If Select("TXArq") <> 0
		TXArq->(dbCloseArea())
	Endif           
	
	TcQuery cQry New Alias "TXArq"
	
	TcSetField('TXArq','F2_EMISSAO','D',8,0)
	TcSetField('TXArq','F2_ZZDTSAI','D',8,0)
	TcSetField('TXArq','F1_EMISSAO','D',8,0)
	TcSetField('TXArq','E1_VENCTO' ,'D',8,0)
	
	If TXArq->(Eof())

		Aviso("ATENวรO","Nใo existem informa็๕es a serem geradas.",{'Ok'})

		Return Nil

	Endif

	cCnpjRec := TXArq->CGCRECP
	cLocEmb	 := TXArq->C5_XLOCEMB

	&& HEADER DO PROCESSO.
	cLine := "ITP"
	cLine += "004"
	cLine += "17"
	cLine += nSeq
	cLine += Right(DTOS(dDataBase),6) + Left(Time(),2)+SubStr(Time(),4,2)+Right(Time(),2)
	cLine += "08735007000244"
	cLine += TXArq->CGCRECP
	cLine += "120717  "
	cLine += TXArq->C5_XCODINT
	cLine += "MINEBEA ACCESSSOLUTIONS SAO PAULO"
	cLine += "TOYOTA DO BRASIL LTDA    "
	cLine += Space(09)
	cLine := fCplPos(cLine)

	fWrite(cArq,cLine)

	nQtLinha := 1
	
	While TXArq->(!Eof())
		
		nControl := TxArq->F2_DOC+TXArq->F2_SERIE
		
		cLine := "AE1"
		cLine += Right(StrZero(Val(TXArq->F2_DOC),6),6)
		cLine += Left(TXArq->F2_SERIE+Space(4),4)
		cLine += Right(DTOS(TXArq->F2_EMISSAO),6)
		cLine += Right(StrZero(Val(TXArq->NITEM),3),3)
		cLine += Right(StrZero(TXArq->F2_VALBRUT*100,17),17)
		cLine += PadL(AllTrim(TXArq->D2_CF), 5, "0")
		cLine += Space(1)
		cLine += Right(StrZero(TXArq->F2_VALICM*100,17),17)
		cLine += Right(DTOS(TXArq->F2_EMISSAO),6) //StrZero(0,6)
		cLine += '03' //Iif(TXArq->F4_DUPLIC == 'S','02','01')
		cLine += Right(StrZero(TXArq->D2_VALIPI*100,17),17)
		cLine += Left(TXArq->C5_XCODFAB+Space(3),3)	//'J  '
		cLine += Right(DTOS(TXArq->F2_EMISSAO),6)
		cLine += StrZero(0,4)
		cLine += Left(TXArq->CFOP+Space(15),15)
		cLine += Right(DTOS(TXArq->F2_ZZDTSAI),6)
		cLine += Left(Alltrim(TXArq->F2_ZZHRSAI),2)+Right(Alltrim(TXArq->F2_ZZHRSAI),2)
		cLine := fCplPos(cLine)
	
		fWrite(cArq,cLine)
	
		nQtLinha++
		
		cLine := "NF2"
		cLine += replicate("0",78)
		cLine += space(18)
		cLine += replicate("0",12)     
		cLine := fCplPos(cLine)
		
		fWrite(cArq,cLine)
		
		nQtLinha++          
		
		While TXArq->(!Eof()) .And. nControl == TxArq->F2_DOC+TXArq->F2_SERIE
			
			cLine := "AE2"
			cLine += Right(StrZero(Val(TXArq->D2_ITEM),3),3)
			cLine += Replicate("0", 12) //space(12)
			cLine += allTrim(TXArq->C6_XTPFORN)
			cLine += space(1)
			cLine += PadR(Alltrim(TXArq->A7_CODCLI),29," ")				 //29 e 30 posicionamento do campo 
			cLine += Right(StrZero(Int(TXArq->D2_QUANT),08),08)
			cLine += Left(TXArq->D2_UM+Space(2),2)
			cLine += padl(allTrim(TXArq->B1_POSIPI),10,"0") 
			cLine += replicate("0",4)		
			cLine += Right(StrZero(TXArq->D2_PRCVEN*100000,12),12)
			cLine += Right(StrZero(Int(TXArq->D2_QUANT),09),09)
			cLine += Left(TXArq->D2_UM+Space(2),2)        
			cLine += Right(StrZero(Int(TXArq->D2_QUANT),09),09)
			cLine += Left(TXArq->D2_UM+Space(2),2)        
			cLine += "P" //space(1)
			cLine += Replicate("0",15)
			cLine := fCplPos(cLine)
			
			fWrite(cArq,cLine)
			
			nQtLinha++
			
			cLine := "AE4"
			cLine += replicate("0",56)
			cLine += "2"
			cLine += space(55)		
			cLine += Right(StrZero(TXArq->D2_TOTAL*100,12),12)
	 		cLine := fCplPos(cLine)
	 		
			fWrite(cArq,cLine)
			
			nQtLinha++	 
			
			TXArq->(DbSkip())	
			
		Enddo
		
	Enddo           
	
	cLine := "AE3"
	cLine += cCnpjRec
	cLine += cCnpjRec
	cLine += cLocEmb
	cLine += "      "
	cLine += Space(79)
	cLine := fCplPos(cLine)
	
	fWrite(cArq,cLine)
	
	nQtLinha++
	
	cLine := "FTP"
	cLine += nSeq
	cLine += StrZero(	nQtLinha+1,9)
	cLine += Right(StrZero(nSValBrut*100,17),17)
	cLine += '0'
	cLine += Space(93)
	cLine := fCplPos(cLine)

	fWrite(cArq,cLine)
	
	fClose(cArq)

	PutMv("HL_SEQTOY", (Val(nSeq)+1))

	Aviso('ATENวรO','Arquivo '+cArqTxt+' Gerado com Sucesso!',{'Ok'})

Return Nil
	
Static Function fCplPos(cLine)

	Local cRet 	:= AllTrim(cLine)
	Local nI	:= 0
	
	If Len(cRet) < 128

		For nI := Len(cRet) to 127
			cRet += ' '
		Next nI

	Endif

	cRet += Chr(13)+Chr(10)
	
Return(cRet)

Static Function ValidPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	Local lRet := .t.
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/	Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Nota Fiscal"     			,"" ,"" ,"mv_ch1", "C", 09, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "ZZSF2"})
	aAdd(aRegs, {cPerg, "02", "Serie"        			,"" ,"" ,"mv_ch2", "C", 03, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	//aAdd(aRegs, {cPerg, "03", "Ate Nota Fiscal"      		,"" ,"" ,"mv_ch3", "C", 09, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "ZZSF2"})
	//aAdd(aRegs, {cPerg, "04", "Ate Serie"	        		,"" ,"" ,"mv_ch4", "C", 03, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	
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
	Next
	
	dbSelectArea(_sAlias)

Return(lRet)

Static Procedure fConsSQL(cQry)

	cQry := "SELECT	'ITP' AS ITP, "
	cQry += "		ISNULL((SELECT TOP 1 A1_CGC FROM "+RetSqlName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = SF2.F2_CLIENTE AND A1_LOJA = SF2.F2_LOJA AND D_E_L_E_T_ = ' ' ),'') AS CGCRECP, "
	cQry += "		'AE1' AS AE1, "
	cQry += "		SF2.F2_DOC, "
	cQry += "		SF2.F2_SERIE, "
	cQry += "		SF2.F2_EMISSAO, "
	cQry += "		(SELECT MAX(D2_ITEM) FROM "+RetSqlName('SD2')+" WHERE D2_FILIAL = '"+xFilial('SD2')+"' AND D2_DOC = SF2.F2_DOC AND D2_SERIE = SF2.F2_SERIE AND D_E_L_E_T_ = ' ' ) AS NITEM, "
	cQry += "		SF2.F2_VALBRUT, "
	cQry += "		SD2.D2_CF, "
	cQry += "		SF2.F2_VALICM, "
	cQry += "		(SELECT MAX(E1_VENCTO) FROM "+RetSqlName('SE1')+" WHERE E1_FILIAL = '"+xFilial('SE1')+"' AND E1_NUM = SF2.F2_DOC AND E1_PREFIXO = SF2.F2_SERIE AND E1_CLIENTE = SF2.F2_CLIENTE AND E1_LOJA = SF2.F2_LOJA AND D_E_L_E_T_ = ' ' ) AS E1_VENCTO, "
	cQry += "		(SELECT TOP 1 F4_DUPLIC FROM "+RetSqlName('SF4')+" WHERE F4_FILIAL = '"+xFilial('SF4')+"' AND F4_CODIGO = SD2.D2_TES AND D_E_L_E_T_ = ' ') AS F4_DUPLIC, "
	cQry += "		SD2.D2_VALIPI, "
	cQry += "		(SELECT TOP 1 X5_DESCRI FROM "+RetSqlName('SX5')+" WHERE X5_FILIAL = '"+xFilial('SX5')+"' AND X5_TABELA = '13' AND X5_CHAVE = SD2.D2_CF AND D_E_L_E_T_ = ' ') AS CFOP, "
	cQry += "		(SELECT MAX(C6_ENTREG) FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND D_E_L_E_T_ = ' ' ) AS F2_ZZDTSAI, "
	cQry += "		(SELECT MAX(C6_HORA) FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND D_E_L_E_T_ = ' ' ) AS F2_ZZHRSAI, "
	cQry += "		(SELECT TOP 1 C5_XCODINT FROM "+RetSqlName('SC5')+" WHERE C5_FILIAL = '"+xFilial('SC5')+"' AND C5_NUM = SD2.D2_PEDIDO  AND D_E_L_E_T_ = ' ') AS C5_XCODINT, "
	cQry += "		(SELECT TOP 1 C5_XLOCEMB FROM "+RetSqlName('SC5')+" WHERE C5_FILIAL = '"+xFilial('SC5')+"' AND C5_NUM = SD2.D2_PEDIDO  AND D_E_L_E_T_ = ' ') AS C5_XLOCEMB, "
	cQry += "		(SELECT TOP 1 C5_XCODFAB FROM "+RetSqlName('SC5')+" WHERE C5_FILIAL = '"+xFilial('SC5')+"' AND C5_NUM = SD2.D2_PEDIDO  AND D_E_L_E_T_ = ' ') AS C5_XCODFAB, "
	//		cQry += "		SF2.F2_ZZDTSAI, "
	//		cQry += "		SF2.F2_ZZHRSAI, "
	cQry += "		'NF2' AS NF2, "
	cQry += "		SF2.F2_DESPESA, "
	cQry += "		SF2.F2_FRETE, "
	cQry += "		SF2.F2_SEGURO, "
	cQry += "		SF2.F2_DESCONT, "
	cQry += "		SF2.F2_BASEICM, "
	cQry += "		(SELECT SUM(D2_DESCZFR) FROM "+RetSqlName('SD2')+" WHERE D2_FILIAL = '"+xFilial('SD2')+"' AND D2_DOC = SF2.F2_DOC AND D2_SERIE = SF2.F2_SERIE AND D_E_L_E_T_ = ' ' ) AS VLDESCICMS, "
	cQry += "		SD2.D2_NFORI, "
	cQry += "		ISNULL((SELECT TOP 1 F1_EMISSAO FROM "+RetSqlName('SF1')+" WHERE F1_FILIAL = '"+xFilial('SF1')+"' AND F1_DOC = SD2.D2_NFORI AND F1_SERIE = SD2.D2_SERIORI AND D_E_L_E_T_ = ' '),'') AS F1_EMISSAO, "
	cQry += "		SD2.D2_SERIORI, "
	cQry += "		SD2.D2_CF, "
	cQry += "		SD2.D2_CODISS, "
	cQry += "		SD2.D2_TOTAL, "
	cQry += "		'AE2' AS AE2, "
	cQry += "		SD2.D2_ITEM, "
	cQry += "		(SELECT TOP 1 C6_PEDCLI FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ' ) AS C6_PEDCLI, "
	cQry += "		(SELECT TOP 1 C6_XTPFORN FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_XTPFORN, "
	cQry += "		(SELECT TOP 1 C6_XCODPRD FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_XCODPRD, "
	cQry += "		ISNULL((SELECT TOP 1 A7_CODCLI FROM "+RetSqlName('SA7')+" WHERE A7_FILIAL = '"+xFilial('SA7')+"' AND A7_CLIENTE = SF2.F2_CLIENTE AND A7_LOJA = SF2.F2_LOJA AND A7_PRODUTO = SD2.D2_COD AND D_E_L_E_T_ = ' '),'') AS A7_CODCLI, "
	cQry += "		SD2.D2_QUANT, "
	cQry += "		SD2.D2_UM, "
	cQry += "		ISNULL((SELECT B1_POSIPI FROM "+RetSqlName('SB1')+" WHERE B1_FILIAL = '"+xFilial('SB1')+"' AND B1_COD = SD2.D2_COD AND B1_LOCPAD = SD2.D2_LOCAL AND D_E_L_E_T_ = ' ' ),'') AS B1_POSIPI, "
	cQry += "		SD2.D2_IPI, "
	cQry += "		SD2.D2_PRCVEN, "
	cQry += "		SD2.D2_DESC, "
	cQry += "		SD2.D2_DESCON, "
	cQry += "		SD2.D2_PEDIDO, "
	cQry += "		SD2.D2_ITEMPV, "
	cQry += "		'AE4' AS AE4, "
	cQry += "		SD2.D2_PICM, "
	cQry += "		SD2.D2_BASEICM, "
	cQry += "		SD2.D2_VALICM, "
	cQry += "		SD2.D2_VALIPI, "
	cQry += "		SD2.D2_CLASFIS, "
	cQry += "		SD2.D2_PESO, "
	cQry += "		SD2.D2_TOTAL, "
	cQry += "		(SELECT TOP 1 F4_SITTRIB FROM "+RetSqlName('SF4')+" WHERE F4_FILIAL = '"+xFilial('SF4')+"' AND F4_CODIGO = SD2.D2_TES AND D_E_L_E_T_ = ' ') AS F4_SITTRIB, "
	cQry += "		'AE7' AS AE7, "
	cQry += "		SD2.D2_CF, "
	cQry += "		SD2.D2_BRICMS, "
	cQry += "		SD2.D2_ICMSRET, "
	cQry += "		'VERIFICAR' AS VERIF, "
	cQry += "		SD2.D2_PESO, "
	cQry += "		SD2.D2_TOTAL, "
	cQry += "		SD2.D2_LOTECTL, "
	cQry += "		'AE8' AS AE8, "
	cQry += "		SD2.D2_NFORI, "
	cQry += "		SD2.D2_SERIORI "
	//cQry += "		ISNULL((SELECT F1_EMISSAO FROM "+RetSqlName('SF1')+" WHERE F1_FILIAL = '"+xFilial('SF1')+"' AND F1_DOC = SD2.D2_NFORI AND F1_SERIE = SD2.D2_SERIORI AND D_E_L_E_T_ = ' '),'') AS F1_EMISSAO, "
	//cQry += "		ISNULL((SELECT D1_ITEM FROM "+RetSqlName('SD1')+" WHERE D1_FILIAL = '"+xFilial('SD1')+"' AND D1_DOC = SD2.D2_NFORI AND D1_SERIE = SD2.D2_SERIORI AND D_E_L_E_T_ = ' '),'') AS D1_ITEM "
	cQry += "FROM "+RetSqlName('SF2')+" SF2 INNER JOIN "+RetSqlName('SD2')+" SD2 "
	cQry += "		ON SF2.F2_FILIAL 	=	SD2.D2_FILIAL	AND "
	cQry += "		SF2.F2_DOC			=	SD2.D2_DOC 		AND "
	cQry += "		SF2.F2_SERIE		=	SD2.D2_SERIE	AND "
	cQry += "		SF2.D_E_L_E_T_		=	' '				AND "
	cQry += "		SD2.D_E_L_E_T_		=	' '				AND "
	cQry += "		SF2.F2_FILIAL		=	'"+xFilial('SF2')+"' AND "
	cQry += "		SF2.F2_DOC 			= '"+Mv_Par01+"' AND "
	cQry += "		SF2.F2_SERIE		= '"+Mv_Par02+"' "
	//cQry += "		SF2.F2_DOC 			BETWEEN '"+Mv_Par01+"' AND '"+Mv_Par03+"' AND "
	//cQry += "		SF2.F2_SERIE		BETWEEN '"+Mv_Par02+"' AND '"+Mv_Par04+"' "
	cQry += "GROUP BY "
	cQry += "		SF2.F2_DOC, "
	cQry += "		SF2.F2_SERIE, "
	cQry += "		SF2.F2_CLIENTE, "
	cQry += "		SF2.F2_LOJA, "
	cQry += "		SF2.F2_EMISSAO, "
	cQry += "		SF2.F2_VALBRUT, "
	cQry += "		SD2.D2_CF, "
	cQry += "		SF2.F2_VALICM, "
	cQry += "		SD2.D2_VALIPI, "
	//	cQry += "		SF2.F2_ZZDTSAI, "
	//		cQry += "		SF2.F2_ZZHRSAI, "
	cQry += "		SF2.F2_DESPESA, "
	cQry += "		SF2.F2_FRETE, "
	cQry += "		SF2.F2_SEGURO, "
	cQry += "		SF2.F2_DESCONT, "
	cQry += "		SF2.F2_BASEICM, "
	cQry += "		SD2.D2_NFORI, "
	cQry += "		SD2.D2_SERIORI, "
	cQry += "		SD2.D2_TOTAL, "
	cQry += "		SD2.D2_ITEM, "
	cQry += "		SD2.D2_COD, "
	cQry += "		SD2.D2_QUANT, "
	cQry += "		SD2.D2_UM, "
	cQry += "		SD2.D2_LOCAL, "
	cQry += "		SD2.D2_IPI, "
	cQry += "		SD2.D2_PRCVEN, "
	cQry += "		SD2.D2_DESC, "
	cQry += "		SD2.D2_DESCON, "
	cQry += "		SD2.D2_PICM, "
	cQry += "		SD2.D2_BASEICM, "
	cQry += "		SD2.D2_VALICM, "
	cQry += "		SD2.D2_CLASFIS, "
	cQry += "		SD2.D2_PESO, "
	cQry += "		SD2.D2_TES, "
	cQry += "		SD2.D2_BRICMS, "
	cQry += "		SD2.D2_ICMSRET, "
	cQry += "		SD2.D2_PEDIDO, "
	cQry += "		SD2.D2_ITEMPV, "
	cQry += "		SD2.D2_LOTECTL, "
	cQry += "		SD2.D2_CODISS "
	cQry += "ORDER BY  "
	cQry += "		SF2.F2_DOC, "
	cQry += "		SF2.F2_SERIE, "
	cQry += "		SD2.D2_ITEM "

Return(cQry)
