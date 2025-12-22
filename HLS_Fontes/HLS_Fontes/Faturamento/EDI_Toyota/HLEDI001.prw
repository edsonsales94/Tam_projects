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

User Function HLEDI001
Local aArea		:= GetArea()
Local cPerg		:= 'HLEDI001  '
Local oDlg, oSay1
Local cLocArq	:= "\EDI_TOYOTA\"
//	Local cLocNm	:= "Local/Nome do Arquivo: "
//	Local oLibF		:= LibFunctions():MaLoc()

ValidPerg(cPerg)
Pergunte(cPerg,.f.)

Define MsDialog oDlg Title "Gera็ใo de Arquivo EDI" From 189,200 To 325,680 Pixel

@ 004,004 To 045,240 Label "" Pixel Of oDlg
@ 014,009 Say "Este programa tem o objetivo de gerar arquivo em formato TXT com base nas Notas Fiscais de Saida. " Size 300,018 Color CLR_BLACK Pixel Of oDlg
@ 024,009 Say "Para gerar o arquivo, selecione os documentos de saida, s้rie e o caminho aonde o  arquivo serแ gravado." Size 300,021 Color CLR_BLACK Pixel Of oDlg
@ 034,009 Say oSay1 Var (cLocArq) Size 300,021 Color CLR_BLACK Pixel Of oDlg

@ 050,004 Button "Parโmetros" 	Size 052,013 Action (Pergunte(cPerg, .T.)) Pixel Of oDlg
@ 050,074 Button "Processar"   Size 052,013 Action ( fSetLocF(@cLocArq,oSay1) ) Pixel Of oDlg
@ 050,144 Button "Sair"       	Size 052,013 Action (oDlg:End()) Pixel Of oDlg

Activate MsDialog oDlg Centered

RestArea(aArea)
Return

Static Procedure fSetLocF(cLocArq,oSay)
If MsgYesNo("Confirma a Gera็ใo do EDI?")
	Processa({|| fCrtFEdi(cLocArq)},"Aguarde! Processando dados...")
Endif

Return

Static Procedure fCrtFEdi(cLocArq)
Local cLine		:= ""
Local nSeq		:= StrZero(GetMv("HL_SEQTOY"),5)
//Local cHondaSum := GetMv("NS_HNDSUM")
Local nControl	:= ""
Local nQtdReg	:= 0
Local nSValBrut	:= 0
Local cQry 	:= ""                
Local nItEDI	:= 0                
Local cProdAnt	:= ""
Local aQtdPed	:= {}

//cTexto	:= "Texte de Grava็ใo"
//cNomArqLog	:= "\HLAFAT01_" + DToS(Date()) + "_" +  StrTran(Time(), ":", "") + ".Log"
//MemoWrite(cNomArqLog, cTexto)   
//cArq 	:= fOpen(cArqTxt,2)

Private cArqTxt	:= UPPER("\EDI_TOYOTA\AEM-HLS_"+allTrim(MV_PAR01)+".TXT")

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
	Return
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
nQtLinha	:= 1

While TXArq->(!Eof())
	
	nControl := TxArq->F2_DOC+TXArq->F2_SERIE
	
	cLine := "AE1"
	cLine += Right(StrZero(Val(TXArq->F2_DOC),6),6)
	cLine += Left(TXArq->F2_SERIE+Space(4),4)
	cLine += Right(DTOS(TXArq->F2_EMISSAO),6)
	cLine += Right(StrZero(Val(TXArq->NITEM),3),3)
	cLine += Right(StrZero(TXArq->F2_VALBRUT*100,17),17)
	cLine += '2'
	cLine += Left(TXArq->D2_CF+Space(5),5)
	cLine += Right(StrZero(TXArq->F2_VALICM*100,17),17)
	cLine += Right(DTOS(TXArq->E1_VENCTO),6) //StrZero(0,6)
	cLine += '00' //Iif(TXArq->F4_DUPLIC == 'S','02','01')
	cLine += Right(StrZero(TXArq->F2_VALIPI*100,17),17)
	cLine += Left(TXArq->C5_XCODFAB+Space(3),3)	//'J  '
	cLine += Right(DTOS(TXArq->F2_EMISSAO),6)
	cLine += StrZero(0,4)
	cLine += Left(TXArq->CFOP+Space(15),15)
	cLine += Right(DTOS(TXArq->F2_ZZDTSAI),6)
	cLine += Left(Alltrim(TXArq->F2_ZZHRSAI),2)+Right(Alltrim(TXArq->F2_ZZHRSAI),2)
	cLine := fCplPos(cLine)
	fWrite(cArq,cLine)
	nQtLinha	++
	
	cLine := "NF2"
	cLine += Right(StrZero(TXArq->F2_DESPESA*100,12),12)
	cLine += Right(StrZero(TXArq->F2_FRETE*100,12),12)
	cLine += Right(StrZero(TXArq->F2_SEGURO*100,12),12)
	cLine += Right(StrZero(TXArq->F2_DESCONT*100,12),12)
	cLine += Right(StrZero(TXArq->F2_BASEICM*100,12),12)
	cLine += Right(StrZero(TXArq->VLDESCICMS*100,12),12)
	cLine += Right(StrZero(Val(TXArq->D2_NFORI),6),6)
	cLine += Right(DTOS(TXArq->F1_EMISSAO),6)
	cLine += Left(TXArq->D2_SERIORI+Space(4),4)
	cLine += 'AB1'
	cLine += Left((TXArq->D2_CF+Space(5)),5)
	cLine += StrZero(0,12) //Iif(Empty(TXArq->D2_CODISS),Right(StrZero(TXArq->D2_TOTAL,13,2),0),13), StrZero(0,13))
	cLine += Space(15)
	cLine := fCplPos(cLine)
	fWrite(cArq,cLine)
	nQtLinha	++
	
	
	nSValBrut += TXArq->F2_VALBRUT
	While TXArq->(!Eof()) .And. nControl == TxArq->F2_DOC+TXArq->F2_SERIE     
		If cProdAnt == TXArq->D2_COD                    
			TXArq->(DbSkip())
			loop
		Else    
			cProdAnt := TXArq->D2_COD
		EndIf
		nItEDI++   
		aQtdPed := retQtdPed()
		cLine := "AE2"
		cLine += Right(StrZero(nItEDI,3),3)
		cLine += Right(StrZero(Val(TXArq->C6_PEDCLI),12),12) 	//			cLine += "            "
		cLine += TXArq->C6_XCODPRD+Left(Alltrim(TXArq->A7_CODCLI)+Space(28),28)
		cLine += Right(StrZero(aQtdPed[1]*100,09),09)
		cLine += Left(TXArq->D2_UM+Space(2),2)
		cLine += Left(TXArq->B1_POSIPI+Space(10),10)
		cLine += Right(StrZero(TXArq->D2_IPI*100,4),4)
		cLine += Right(StrZero(TXArq->D2_PRCVEN*100000,12),12)
		cLine += Space(9)
		cLine += Left(TXArq->D2_UM+Space(2),2)
		cLine += Right(StrZero(aQtdPed[1]*100,09),09)
		cLine += Left(TXArq->D2_UM+Space(2),2)
		cLine += Left(TXArq->C6_XTPFORN+Space(1),1)
		cLine += Right(StrZero(TXArq->D2_DESC*100,4),4)
		cLine += Right(StrZero(TXArq->D2_DESCON*100,11),11)
		cLine += Space(5)
		cLine := fCplPos(cLine)
		fWrite(cArq,cLine)
		nQtLinha	++
		
		cLine := "AE4"
		cLine += Right(StrZero(TXArq->D2_PICM*100,4),4)
		cLine += Right(StrZero(aQtdPed[2]*100,17),17)
		cLine += Right(StrZero(aQtdPed[3]*100,17),17)
		cLine += Right(StrZero(aQtdPed[4]*100,17),17)
		cLine += Left(TXArq->D2_CLASFIS+Space(2),2)
		cLine += Space(30)
		cLine += StrZero(0,6)
		cLine += Space(13)
		cLine += Right(StrZero(TXArq->D2_PESO*100,5),5)
		cline += Space(1)
		cLine += Right(StrZero(aQtdPed[1]*TXArq->D2_PRCVEN*100,12),12)
		cLine += Left(TXArq->F4_SITTRIB,1)
 		cLine := fCplPos(cLine)
		fWrite(cArq,cLine)
		nQtLinha	++
		
		cQuery := "SELECT C6_XKAMBAN, C6_XDATKAM, C6_XQTDKAM, C6_XITENS "
  		cQuery += "FROM "+RetSqlName('SC6')+" "
  		cQuery += "WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND "
  		cQuery += "      C6_NUM = '"+TXArq->D2_PEDIDO+"' AND "
  		cQuery += "      C6_PRODUTO = '"+TXArq->D2_COD+"' AND "
  		cQuery += "      D_E_L_E_T_ = ' '"
		If Select("TTMP") <> 0
			TTMP->(dbCloseArea())
		Endif
		TCQUERY cQuery NEW ALIAS "TTMP"
		TcSetField('TTMP','C6_XDATKAM','D',8,0)
		dbSelectArea("TTMP")
		dbGotop()
		While !Eof()		
			cLine := "AE9"
			cLine += Left(TTMP->C6_XKAMBAN,12)
			cLine += Right(DTOS(TTMP->C6_XDATKAM),6)
			cLine += Right(StrZero(Val(TTMP->C6_XQTDKAM),9),9)
			cLine += Right(StrZero(Val(TTMP->C6_XITENS)*100,9),9)
			cLine += Space(89)
			cLine := fCplPos(cLine)
			fWrite(cArq,cLine)
			nQtLinha	++
			dbSkip()
		Enddo			
		
		dbSelectArea("TXArq")		
		cLine := "AE7"
		cLine += StrZero(0,12)
		cLine += Left(TXArq->D2_CF+Space(5),5)
		cLine += Right(StrZero(aQtdPed[5]*100,17),17)
		cLine += Right(StrZero(aQtdPed[6]*100,17),17)
		cLine += StrZero(0,14) // Verificar...
		cLine += Right(StrZero(TXArq->D2_PESO*100,5),5)
		cLine += StrZero(0,12) //Iif(Empty(TXArq->D2_CODISS),Right(StrZero(TXArq->D2_TOTAL,13,2),0),13), Space(13))
		cLine += Space(43)
		cLine := fCplPos(cLine)
		fWrite(cArq,cLine)
		nQtLinha	++
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
nQtLinha	++

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
Return

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
aAdd(aRegs, {cPerg, "02", "Serie"        				,"" ,"" ,"mv_ch2", "C", 03, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
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

cQry := "SELECT	'ITP' AS ITP, " +CRLF
cQry += "		ISNULL((SELECT A1_CGC FROM "+RetSqlName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = SF2.F2_CLIENTE AND A1_LOJA = SF2.F2_LOJA AND D_E_L_E_T_ = ' ' ),'') AS CGCRECP, " +CRLF
cQry += "		'AE1' AS AE1, " +CRLF
cQry += "		SF2.F2_DOC, " +CRLF
cQry += "		SF2.F2_SERIE, " +CRLF
cQry += "		SF2.F2_EMISSAO, " +CRLF
cQry += "		(SELECT MAX(D2_ITEM) FROM "+RetSqlName('SD2')+" WHERE D2_FILIAL = '"+xFilial('SD2')+"' AND D2_DOC = SF2.F2_DOC AND D2_SERIE = SF2.F2_SERIE AND D_E_L_E_T_ = ' ' ) AS NITEM, " +CRLF
cQry += "		SF2.F2_VALBRUT, " +CRLF
cQry += "		SD2.D2_CF, " +CRLF
cQry += "		SF2.F2_VALICM, " +CRLF
cQry += "		(SELECT MAX(E1_VENCTO) FROM "+RetSqlName('SE1')+" WHERE E1_FILIAL = '"+xFilial('SE1')+"' AND E1_NUM = SF2.F2_DOC AND E1_PREFIXO = SF2.F2_SERIE AND E1_CLIENTE = SF2.F2_CLIENTE AND E1_LOJA = SF2.F2_LOJA AND D_E_L_E_T_ = ' ' ) AS E1_VENCTO, " +CRLF
cQry += "		(SELECT F4_DUPLIC FROM "+RetSqlName('SF4')+" WHERE F4_FILIAL = '"+xFilial('SF4')+"' AND F4_CODIGO = SD2.D2_TES AND D_E_L_E_T_ = ' ') AS F4_DUPLIC, " +CRLF
cQry += "		SD2.D2_VALIPI, " +CRLF
cQry += "		(SELECT X5_DESCRI FROM "+RetSqlName('SX5')+" WHERE X5_FILIAL = '"+xFilial('SX5')+"' AND X5_TABELA = '13' AND X5_CHAVE = SD2.D2_CF AND D_E_L_E_T_ = ' ') AS CFOP, " +CRLF
cQry += "		(SELECT MAX(C6_ENTREG) FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND D_E_L_E_T_ = ' ' ) AS F2_ZZDTSAI, " +CRLF
cQry += "		(SELECT MAX(C6_HORA) FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND D_E_L_E_T_ = ' ' ) AS F2_ZZHRSAI, " +CRLF
cQry += "		(SELECT C5_XCODINT FROM "+RetSqlName('SC5')+" WHERE C5_FILIAL = '"+xFilial('SC5')+"' AND C5_NUM = SD2.D2_PEDIDO  AND D_E_L_E_T_ = ' ') AS C5_XCODINT, " +CRLF
cQry += "		(SELECT C5_XLOCEMB FROM "+RetSqlName('SC5')+" WHERE C5_FILIAL = '"+xFilial('SC5')+"' AND C5_NUM = SD2.D2_PEDIDO  AND D_E_L_E_T_ = ' ') AS C5_XLOCEMB, " +CRLF
cQry += "		(SELECT C5_XCODFAB FROM "+RetSqlName('SC5')+" WHERE C5_FILIAL = '"+xFilial('SC5')+"' AND C5_NUM = SD2.D2_PEDIDO  AND D_E_L_E_T_ = ' ') AS C5_XCODFAB, " +CRLF
//		cQry += "		SF2.F2_ZZDTSAI, " +CRLF
//		cQry += "		SF2.F2_ZZHRSAI, " +CRLF
cQry += "		'NF2' AS NF2, " +CRLF
cQry += "		SF2.F2_DESPESA, " +CRLF
cQry += "		SF2.F2_FRETE, " +CRLF
cQry += "		SF2.F2_SEGURO, " +CRLF
cQry += "		SF2.F2_DESCONT, " +CRLF
cQry += "		SF2.F2_BASEICM, " +CRLF
cQry += "		(SELECT SUM(D2_DESCZFR) FROM "+RetSqlName('SD2')+" WHERE D2_FILIAL = '"+xFilial('SD2')+"' AND D2_DOC = SF2.F2_DOC AND D2_SERIE = SF2.F2_SERIE AND D_E_L_E_T_ = ' ' ) AS VLDESCICMS, " +CRLF
cQry += "		SD2.D2_NFORI, " +CRLF
cQry += "		ISNULL((SELECT F1_EMISSAO FROM "+RetSqlName('SF1')+" WHERE F1_FILIAL = '"+xFilial('SF1')+"' AND F1_DOC = SD2.D2_NFORI AND F1_SERIE = SD2.D2_SERIORI AND D_E_L_E_T_ = ' '),'') AS F1_EMISSAO, " +CRLF
cQry += "		SD2.D2_SERIORI, " +CRLF
cQry += "		SD2.D2_CF, " +CRLF
cQry += "		SD2.D2_CODISS, " +CRLF
cQry += "		SD2.D2_TOTAL, " +CRLF
cQry += "		'AE2' AS AE2, " +CRLF
cQry += "		SD2.D2_ITEM, " +CRLF
cQry += "		(SELECT C6_PEDCLI FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ' ) AS C6_PEDCLI, " +CRLF
cQry += "		(SELECT C6_XTPFORN FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_XTPFORN, " +CRLF
cQry += "		(SELECT C6_XCODPRD FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_XCODPRD, " +CRLF
cQry += "		ISNULL((SELECT A7_CODCLI FROM "+RetSqlName('SA7')+" WHERE A7_FILIAL = '"+xFilial('SA7')+"' AND A7_CLIENTE = SF2.F2_CLIENTE AND A7_LOJA = SF2.F2_LOJA AND A7_PRODUTO = SD2.D2_COD AND D_E_L_E_T_ = ' '),'') AS A7_CODCLI, " +CRLF
cQry += "		SD2.D2_QUANT, " +CRLF
cQry += "		SD2.D2_UM, " +CRLF
cQry += "		ISNULL((SELECT B1_POSIPI FROM "+RetSqlName('SB1')+" WHERE B1_FILIAL = '"+xFilial('SB1')+"' AND B1_COD = SD2.D2_COD AND B1_LOCPAD = SD2.D2_LOCAL AND D_E_L_E_T_ = ' ' ),'') AS B1_POSIPI, " +CRLF
cQry += "		SD2.D2_IPI, " +CRLF
cQry += "		SD2.D2_PRCVEN, " +CRLF
cQry += "		SD2.D2_DESC, " +CRLF
cQry += "		SD2.D2_DESCON, " +CRLF
cQry += "		SD2.D2_PEDIDO, " +CRLF
cQry += "		SD2.D2_ITEMPV, " +CRLF
cQry += "		'AE4' AS AE4, " +CRLF
cQry += "		SD2.D2_PICM, " +CRLF
cQry += "		SD2.D2_BASEICM, " +CRLF
cQry += "		SD2.D2_VALICM, " +CRLF
cQry += "		SD2.D2_VALIPI, " +CRLF
cQry += "		SF2.F2_VALIPI, " +CRLF
cQry += "		SD2.D2_CLASFIS, " +CRLF
cQry += "		SD2.D2_PESO, " +CRLF
cQry += "		SD2.D2_TOTAL, " +CRLF
cQry += "		(SELECT F4_SITTRIB FROM "+RetSqlName('SF4')+" WHERE F4_FILIAL = '"+xFilial('SF4')+"' AND F4_CODIGO = SD2.D2_TES AND D_E_L_E_T_ = ' ') AS F4_SITTRIB, " +CRLF
cQry += "		'AE7' AS AE7, " +CRLF
cQry += "		SD2.D2_CF, " +CRLF
cQry += "		SD2.D2_BRICMS, " +CRLF
cQry += "		SD2.D2_ICMSRET, " +CRLF
cQry += "		'VERIFICAR' AS VERIF, " +CRLF
cQry += "		SD2.D2_PESO, " +CRLF
cQry += "		SD2.D2_TOTAL, " +CRLF
cQry += "		SD2.D2_LOTECTL, " +CRLF
cQry += "		'AE8' AS AE8, " +CRLF
cQry += "		SD2.D2_NFORI, " +CRLF
cQry += "		SD2.D2_SERIORI, " +CRLF
cQry += "		ISNULL((SELECT F1_EMISSAO FROM "+RetSqlName('SF1')+" WHERE F1_FILIAL = '"+xFilial('SF1')+"' AND F1_DOC = SD2.D2_NFORI AND F1_SERIE = SD2.D2_SERIORI AND D_E_L_E_T_ = ' '),'') AS F1_EMISSAO, " +CRLF
cQry += "		ISNULL((SELECT D1_ITEM FROM "+RetSqlName('SD1')+" WHERE D1_FILIAL = '"+xFilial('SD1')+"' AND D1_DOC = SD2.D2_NFORI AND D1_SERIE = SD2.D2_SERIORI AND D_E_L_E_T_ = ' '),'') AS D1_ITEM, " +CRLF
cQry += "		SD2.D2_COD " +CRLF
cQry += "FROM "+RetSqlName('SF2')+" SF2 INNER JOIN "+RetSqlName('SD2')+" SD2 " +CRLF
cQry += "		ON SF2.F2_FILIAL 	=	SD2.D2_FILIAL	AND " +CRLF
cQry += "		SF2.F2_DOC			=	SD2.D2_DOC 		AND " +CRLF
cQry += "		SF2.F2_SERIE		=	SD2.D2_SERIE	AND " +CRLF
cQry += "		SF2.D_E_L_E_T_		=	' '				AND " +CRLF
cQry += "		SD2.D_E_L_E_T_		=	' '				AND " +CRLF
cQry += "		SF2.F2_FILIAL		=	'"+xFilial('SF2')+"' AND " +CRLF
cQry += "		SF2.F2_DOC 			= '"+Mv_Par01+"' AND " +CRLF
cQry += "		SF2.F2_SERIE		= '"+Mv_Par02+"' " +CRLF
//cQry += "		SF2.F2_DOC 			BETWEEN '"+Mv_Par01+"' AND '"+Mv_Par03+"' AND " +CRLF
//cQry += "		SF2.F2_SERIE		BETWEEN '"+Mv_Par02+"' AND '"+Mv_Par04+"' " +CRLF
cQry += "GROUP BY " +CRLF
cQry += "		SF2.F2_DOC, " +CRLF
cQry += "		SF2.F2_SERIE, " +CRLF
cQry += "		SF2.F2_CLIENTE, " +CRLF
cQry += "		SF2.F2_LOJA, " +CRLF
cQry += "		SF2.F2_EMISSAO, " +CRLF
cQry += "		SF2.F2_VALBRUT, " +CRLF
cQry += "		SD2.D2_CF, " +CRLF
cQry += "		SF2.F2_VALICM, " +CRLF
cQry += "		SD2.D2_VALIPI, " +CRLF
cQry += "		SF2.F2_VALIPI, " +CRLF
//	cQry += "		SF2.F2_ZZDTSAI, " +CRLF
//		cQry += "		SF2.F2_ZZHRSAI, " +CRLF
cQry += "		SF2.F2_DESPESA, " +CRLF
cQry += "		SF2.F2_FRETE, " +CRLF
cQry += "		SF2.F2_SEGURO, " +CRLF
cQry += "		SF2.F2_DESCONT, " +CRLF
cQry += "		SF2.F2_BASEICM, " +CRLF
cQry += "		SD2.D2_NFORI, " +CRLF
cQry += "		SD2.D2_SERIORI, " +CRLF
cQry += "		SD2.D2_TOTAL, " +CRLF
cQry += "		SD2.D2_ITEM, " +CRLF
cQry += "		SD2.D2_COD, " +CRLF
cQry += "		SD2.D2_QUANT, " +CRLF
cQry += "		SD2.D2_UM, " +CRLF
cQry += "		SD2.D2_LOCAL, " +CRLF
cQry += "		SD2.D2_IPI, " +CRLF
cQry += "		SD2.D2_PRCVEN, " +CRLF
cQry += "		SD2.D2_DESC, " +CRLF
cQry += "		SD2.D2_DESCON, " +CRLF
cQry += "		SD2.D2_PICM, " +CRLF
cQry += "		SD2.D2_BASEICM, " +CRLF
cQry += "		SD2.D2_VALICM, " +CRLF
cQry += "		SD2.D2_CLASFIS, " +CRLF
cQry += "		SD2.D2_PESO, " +CRLF
cQry += "		SD2.D2_TES, " +CRLF
cQry += "		SD2.D2_BRICMS, " +CRLF
cQry += "		SD2.D2_ICMSRET, " +CRLF
cQry += "		SD2.D2_PEDIDO, " +CRLF
cQry += "		SD2.D2_ITEMPV, " +CRLF
cQry += "		SD2.D2_LOTECTL, " +CRLF
cQry += "		SD2.D2_CODISS " +CRLF
cQry += "ORDER BY  " +CRLF
cQry += "		SF2.F2_DOC, " +CRLF
cQry += "		SF2.F2_SERIE, " +CRLF
cQry += "		SD2.D2_ITEM, " +CRLF
cQry += "		SD2.D2_COD " +CRLF

Return(cQry)


Static Function retQtdPed()
	Local aRet	:= {0,0,0,0,0,0}
	cQuery := "SELECT SUM(D2_QUANT) AS D2_QUANT, " 
	cQuery += " SUM(D2_BASEICM) AS D2_BASEICM, "
	cQuery += " SUM(D2_VALICM) AS D2_VALICM, "
	cQuery += " SUM(D2_VALIPI) AS D2_VALIPI, "
	cQuery += " SUM(D2_BRICMS) AS D2_BRICMS, "
	cQuery += " SUM(D2_ICMSRET) AS D2_ICMSRET "
	cQuery += "FROM "+RetSqlName('SD2')+" "
	cQuery += "WHERE D2_FILIAL = '"+xFilial('SD2')+"' AND "
	cQuery += "      D2_DOC = '"+TXArq->F2_DOC+"' AND "
	cQuery += "      D2_SERIE = '"+TXArq->F2_SERIE+"' AND "
	cQuery += "      D2_COD = '"+TXArq->D2_COD+"' AND "
	cQuery += "      D_E_L_E_T_ = ' '"                     
	
	TCQUERY cQuery NEW ALIAS "QRYTMP"

	If QRYTMP->(!Eof())	
		aRet[1] := QRYTMP->D2_QUANT
		aRet[2] := QRYTMP->D2_BASEICM
		aRet[3] := QRYTMP->D2_VALICM
		aRet[4] := QRYTMP->D2_VALIPI
		aRet[5] := QRYTMP->D2_BRICMS
		aRet[6] := QRYTMP->D2_ICMSRET
	EndIf
	QRYTMP->(dbCloseArea())
Return aRet
