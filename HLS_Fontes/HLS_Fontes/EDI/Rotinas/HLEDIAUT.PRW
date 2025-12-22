#include "ap5mail.ch"
#include "Protheus.Ch"
#include "TopConn.Ch"
#include "TBIConn.Ch"
/*/{protheus.doc}HLEDIAUT
EDI - Transmissao de dados automatica
@author Alessandro Freire
@since 24/10/2008
/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHLEDIAUT  บAutor  ณAlessandro Freire   บ Data ณ  24/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEDI - Transmissao de dados automแtica                       บฑฑ
ฑฑบ          ณHonda Lock                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HLEDIAUT()

	//ConOut(VarInfo("ParamIxb", ParamIxb))

	RPCSetType(3)
	Prepare Environment EMPRESA "01" FILIAL "01" MODULO "05"

	ConOut("Inicio Job EDI - Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]")

	FS_HLEDIAUT()

	ConOut("Final Job EDI - Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]")

	Reset Environment

Return(Nil)

Static Function FS_HLEDIAUT()

	Local cTmp            := CriaTrab( nil, .f. )
	Local cPathServer     := GetMv( "MV_HLEDI" )
	Local cArquivo        := ""
	Local cLine           := ""
	Local nHdl            := -1
	Local nHdl2           := -1
	Local nQtLines        := 0
	Local nSeq            := StrZero(GetMv("MV_SEQEDI"),6)
	Local aArea		      := GetArea()
	Local nSValBrut       := 0
	Local cAssunto        := "Monitoramento EDI em " + DtoC(dDataBase) + " เs " + SubStr( Time(),1,5 ) + "-"
	Local cBody           := ""
	Local cBodyLoop       := ""
	Local cLogConsole     := ""
	//Local CRLF            := Chr(13) + Chr(10)

	Private lEnd      	:= .F.											// ABORTA ROTINA
	Private _lAbort   	:= .F.											// HABILITA BOTAO CANCELA
	Private cQry		:= ""

	cQry := fConsSQL()
	cQry := ChangeQuery( cQry )

	TCQUERY cQry NEW ALIAS &(cTmp)

	PutMv("HL_DTULIDE", dDataBase )
	PutMv("HL_HRULIDE", SubStr(Time(),1,5))

	// Cria a pasta dos arquivos do cliente, caso necessแrio.
	// Padrao: Protheus_Data\EDI\C๓digo_Loja
	cFolder := Trim(cPathServer)

	// Retira o ๚ltimo slash do caminho, caso houver
	If SubStr( cFolder, Len(cFolder),1 ) == "\"
		cFolder := SubStr( cFolder, 1, Len( cFolder ) - 1 )
	EndIf

	// Cria a pasta
	nDirOk  := MakeDir( cFolder )
	// 0 = pasta criada
	// 5 = pasta jแ existe
	// outros = erro na cria็ใo
	If nDirOk <> 0 .and. nDirOk <> 5
		cBody += "Erro na Cria็ใo da pasta " + cFolder + CRLF
		Return( nil )
	Else
		cBody += "arquivos gerados na pasta " + cFolder + CRLF
	EndIf

	nSeq := StrZero(GetMv("MV_SEQEDI"),5)

	dbSelectArea(cTmp)
	dbGoTop()
	While ! Eof()

		cEDI := Posicione("SA1", 1, xFilial("SA1") + (cTMP)->F2_CLIENTE + (cTMP)->F2_LOJA, "A1_ZZEDI")

		If Upper( cEDI ) <> "S"
			ConOut("Nota Fiscal - [" + (cTmp)->F2_DOC + "/" + (cTmp)->F2_SERIE + "] do cliente " + (cTMP)->F2_CLIENTE + " loja " + (cTMP)->F2_LOJA + " nใo gerou EDI - Campo A1_ZZEDI = 'N'")

			dbSelectArea(cTmp)
			DBSkip()
			Loop
		EndIf

		// Cria o arquivo
		// cNameFile := SubString(DtoS(dDataBase),3,4)+SubStr( StrTran(Time(),":",""),1,4 ) + ".TXT"
		cNameFile := "HL" + nSeq + ".TXT"
		nHdl      := FCreate( cFolder + "\" + cNameFile, 0 )
		nHdl2     := FCreate( cFolder + "\BACKUP\" + cNameFile, 0 ) // Arquivo de Backup

		// Se nใo criou o arquivo, vai para o pr๓ximo cliente
		If nHdl < 0
			dbSkip()
			Loop
		EndIf

		cBodyLoop += "Arquivo: " + cNameFile
		cLogConsole := "Arquivo: " + cNameFile
		// aqui
		&& HEADER DO PROCESSO.
		nQtLines:=1
		cLine := "ITP"
		cLine += "004"
		cLine += "19"
		cLine += nSeq
		cLine += Right(DTOS(dDataBase),6) + Left(Time(),2)+SubStr(Time(),4,2)+Right(Time(),2)
		cLine += SM0->M0_CGC
		cLine += (cTmp)->CGCRECP
		cLine += " 6380987"
		cLine += "00000000"
		cLine += Left(SM0->M0_NOMECOM,25)
		cLine += Left("HONDA AUTOMOVEIS BRASIL",25)
		FWrite( nHdl, cLine + CRLF)		// ****** GRAVA REGISTRO ******
		FWrite( nHdl2, cLine + CRLF)		// ****** GRAVA REGISTRO ******

		cControl  := SubStr((cTmp)->F2_DOC,1,6)+(cTmp)->F2_SERIE
		cBodyLoop += " - Nota Fiscal: " + SubStr((cTmp)->F2_DOC,1,6) + " " + (cTmp)->F2_SERIE+CRLF

		cLogConsole += " - Nota Fiscal: " + SubStr((cTmp)->F2_DOC,1,6) + " " + (cTmp)->F2_SERIE

		nQtLines++
		cLine := "AE1"
		cLine += Right(StrZero(Val(SubStr((cTmp)->F2_DOC,1,6)),6),6)
		cLine += Left((cTmp)->F2_SERIE+Space(4),4)
		cLine += SubStr( (cTmp)->F2_EMISSAO,3 )
		cLine += Right(StrZero(Val((cTmp)->NITEM),3),3)
		cLine += SubStr(StrZero((cTmp)->F2_VALBRUT,18,2),1,15)+SubStr(StrZero((cTmp)->F2_VALBRUT,18,2),17,2)
		cLine += '2'
		cLine += Left((cTmp)->D2_CF+Space(5),5)
		cLine += SubStr(StrZero((cTmp)->F2_VALICM,18,2),1,15)+SubStr(StrZero((cTmp)->F2_VALICM,18,2),17,2)
		If Empty((cTmp)->E1_VENCTO)
			cLine += StrZero(0,6)
		Else
			cLine += SubStr( (cTmp)->E1_VENCTO,3 ) //StrZero(0,6)
		EndIf
		cLine += Iif((cTmp)->F4_DUPLIC == 'S','02','01')
		//cLine += SubStr(StrZero((cTmp)->D2_VALIPI,18,2),1,15)+SubStr(StrZero((cTmp)->D2_VALIPI,18,2),17,2) -- comentado para gerar a soma de IPI neste bloco LL 24/05
		cLine += SubStr(StrZero((cTmp)->F2_VALIPI,18,2),1,15)+SubStr(StrZero((cTmp)->F2_VALIPI,18,2),17,2) // ajustado por Luciano em 24/05/2019
		cLine += Substr((cTmp)->C6_ZZIDEXP,1,3) //'AB1, ABC' - add Luciano Lamberti para pegar o campo correto do EDI - 29-01-19
		//cLine += Iif(((cTmp)->C6_TIPOP == 'E0'.or.(cTmp)->C6_TIPOP == 'E5'.or.(cTmp)->C6_TIPOP == 'E7'),'KDC','ABD')
		//cLine += If ( (cTmp)->C6_TIPOP == 'AP', 'ABC', If(((cTmp)->C6_TIPOP == 'E0'.or.(cTmp)->C6_TIPOP == 'E5'.or.(cTmp)->C6_TIPOP == 'E7'),'KDC','ABD')) //add Luciano - Pedido E1 - Itirapina
		cLine += SubStr( (cTmp)->F2_EMISSAO, 3 )
		cLine += StrZero(0,4)
		cLine += Left((cTmp)->CFOP+Space(15),15)
		cLine += SubStr( (cTmp)->F2_ZZDTSAI,3 )
		cLine += Left(Alltrim((cTmp)->F2_ZZHRSAI),2)+Right(Alltrim((cTmp)->F2_ZZHRSAI),2)
		FWrite( nHdl, cLine + CRLF)		// ****** GRAVA REGISTRO ******
		FWrite( nHdl2, cLine + CRLF)		// ****** GRAVA REGISTRO ******

		nQtLines++
		cLine := "NF2"
		cLine += SubStr(StrZero((cTmp)->F2_DESPESA,13,2),1,10)+SubStr(StrZero((cTmp)->F2_DESPESA,13,2),12,2)
		cLine += SubStr(StrZero((cTmp)->F2_FRETE,13,2),1,10)+SubStr(StrZero((cTmp)->F2_FRETE,13,2),12,2)
		cLine += SubStr(StrZero((cTmp)->F2_SEGURO,13,2),1,10)+SubStr(StrZero((cTmp)->F2_SEGURO,13,2),12,2)
		cLine += SubStr(StrZero((cTmp)->F2_DESCONT,13,2),1,10)+SubStr(StrZero((cTmp)->F2_DESCONT,13,2),12,2)
		cLine += SubStr(StrZero((cTmp)->F2_BASEICM,13,2),1,10)+SubStr(StrZero((cTmp)->F2_BASEICM,13,2),12,2)
		cLine += SubStr(StrZero((cTmp)->VLDESCICMS,13,2),1,10)+SubStr(StrZero((cTmp)->VLDESCICMS,13,2),12,2)
		cLine += Right(StrZero(Val((cTmp)->D2_NFORI),6),6)
		cLine += SubStr( (cTmp)->F1_EMISSAO, 3 )
		cLine += Left((cTmp)->D2_SERIORI+Space(4),4)
		cLine += Substr((cTmp)->C6_ZZIDEXP,1,3) //'AB1' - add Luciano Lamberti para pegar o campo correto do EDI - 29-01-19
		//cLine += Iif(((cTmp)->C6_TIPOP == 'E0'.or.(cTmp)->C6_TIPOP == 'E5'.or.(cTmp)->C6_TIPOP == 'E7'),'KDC','ABD')
		//cLine += If ( (cTmp)->C6_TIPOP == 'AP', 'ABC', If(((cTmp)->C6_TIPOP == 'E0'.or.(cTmp)->C6_TIPOP == 'E5'.or.(cTmp)->C6_TIPOP == 'E7'),'KDC','ABD')) //add Luciano - Pedido E1 - Itirapina
		cLine += Left(((cTmp)->D2_CF+Space(5)),5)
		cLine += StrZero(0,12) //Iif(Empty((cTmp)->D2_CODISS),Right(oLibF:RmPntVig(StrZero((cTmp)->D2_TOTAL,13,2),0),13), StrZero(0,13))
		FWrite( nHdl, cLine + CRLF)		// ****** GRAVA REGISTRO ******
		FWrite( nHdl2, cLine + CRLF)		// ****** GRAVA REGISTRO ******

		nSValBrut += (cTmp)->F2_VALBRUT
		nControl  := SubStr((cTmp)->F2_DOC,1,6)+(cTmp)->F2_SERIE
		cChave    := xFilial("SE2")+(cTmp)->F2_DOC+(cTmp)->F2_SERIE
		While (cTmp)->(!Eof()) .And. nControl == SubStr((cTmp)->F2_DOC,1,6)+(cTmp)->F2_SERIE

			nQtLines++
			cLine := "AE2"
			cLine += Right(StrZero(Val((cTmp)->D2_ITEM),3),3)
			cLine += Left(Alltrim((cTmp)->C6_PEDCLI)+Space(12),12) //			cLine += "            "
			cLine += Left(Alltrim((cTmp)->B1_CODMATR)+Space(30),30)
			cLine += SubStr(StrZero((cTmp)->D2_QUANT,10,2),1,7)+SubStr(StrZero((cTmp)->D2_QUANT,10,2),9,2)
			cLine += Left((cTmp)->D2_UM+Space(2),2)
			cLine += Left((cTmp)->B1_POSIPI+Space(10),10)
			cLine += SubStr(StrZero((cTmp)->D2_IPI,5,2),1,2)+SubStr(StrZero((cTmp)->D2_IPI,5,2),4,2)
			cLine += SubStr(StrZero((cTmp)->D2_PRCVEN,13,2),1,10)+SubStr(StrZero((cTmp)->D2_PRCVEN,13,2),12,2)
			cLine += Space(9)
			cLine += Left((cTmp)->D2_UM+Space(2),2)
			cLine += SubStr(StrZero((cTmp)->D2_QUANT,10,2),1,7)+SubStr(StrZero((cTmp)->D2_QUANT,10,2),9,2)
			cLine += Left((cTmp)->D2_UM+Space(2),2)
			cLine += "N"//Left((cTmp)->F4_ZZTPVEN+Space(1),1)
			cLine += SubStr(StrZero((cTmp)->D2_DESC,5,2),1,2)+SubStr(StrZero((cTmp)->D2_DESC,5,2),4,2)
			cLine += SubStr(StrZero((cTmp)->D2_DESCON,12,2),1,9)+SubStr(StrZero((cTmp)->D2_DESCON,12,2),11,2)
			cLine += Space(4)
			FWrite( nHdl, cLine + CRLF)		// ****** GRAVA REGISTRO ******
			FWrite( nHdl2, cLine + CRLF)		// ****** GRAVA REGISTRO ******

			nQtLines++
			cLine := "AE4"
			cLine += SubStr(StrZero((cTmp)->D2_PICM,5,2),1,2)+SubStr(StrZero((cTmp)->D2_PICM,5,2),4,2)
			cLine += SubStr(StrZero((cTmp)->D2_BASEICM,18,2),1,15)+SubStr(StrZero((cTmp)->D2_BASEICM,18,2),17,2)
			cLine += SubStr(StrZero((cTmp)->D2_VALICM,18,2),1,15)+SubStr(StrZero((cTmp)->D2_VALICM,18,2),17,2)
			cLine += SubStr(StrZero((cTmp)->D2_VALIPI,18,2),1,15)+SubStr(StrZero((cTmp)->D2_VALIPI,18,2),17,2)
			cLine += Left((cTmp)->D2_CLASFIS+Space(2),2)
			cLine += Space(36)
			cLine += Right(StrZero(Val((cTmp)->C6_NFFATUR),6),6)
			cLine += Left((cTmp)->C6_NFSERIE+Space(2),2)
			cLine += Right(StrZero((Val((cTmp)->C6_ITEMFAT)*100),5),5)
			cLine += SubStr(StrZero((cTmp)->D2_PESO,6,2),1,3)+SubStr(StrZero((cTmp)->D2_PESO,6,2),5,2)
			cline += Space(1)
			cLine += SubStr(StrZero((cTmp)->D2_TOTAL,13,2),1,10)+SubStr(StrZero((cTmp)->D2_TOTAL,13,2),12,2)
			cLine += Left((cTmp)->F4_SITTRIB,1)
			FWrite( nHdl, cLine + CRLF)		// ****** GRAVA REGISTRO ******
			FWrite( nHdl2, cLine + CRLF)		// ****** GRAVA REGISTRO ******

			nQtLines++
			cLine := "AE7"
			cLine += Space(12)
			cLine += Left((cTmp)->D2_CF+Space(5),5)
			cLine += SubStr(StrZero((cTmp)->D2_BRICMS,18,2),1,15)+SubStr(StrZero((cTmp)->D2_BRICMS,18,2),17,2)
			cLine += SubStr(StrZero((cTmp)->D2_ICMSRET,18,2),1,15)+SubStr(StrZero((cTmp)->D2_ICMSRET,18,2),17,2)
			cLine += StrZero(0,13) // Verificar...
			cLine += SubStr(StrZero((cTmp)->D2_PESO,7,2),1,4)+SubStr(StrZero((cTmp)->D2_PESO,7,2),6,2)
			cLine += StrZero(0,12) //Iif(Empty((cTmp)->D2_CODISS),Right(oLibF:RmPntVig(StrZero((cTmp)->D2_TOTAL,13,2),0),13), Space(13))
			cLine += Left((cTmp)->C6_SLIPNUM+Space(14),14) //Left((cTmp)->C6_PEDCLI+Space(14),14) // verificar com o Cliente o conteudo do campo
			cLine += Left((cTmp)->C6_TIPOP,02) //Space(2) //Left((cTmp)->C6_TPEDIDO+Space(2),2) // verificar com o Cliente o conteudo do campo
			cLine += Left((cTmp)->C6_SEPEN+Space(10),10) //Space(10) // Left((cTmp)->C6_NUMSERIE+Space(10),10) // verificar com o Cliente o conteudo do campo
			cLine += Left((cTmp)->C6_LOTEHAB+Space(12),12)

			cLine += "CPI"
			cLine += Space(2)
			FWrite( nHdl, cLine + CRLF)		// ****** GRAVA REGISTRO ******
			FWrite( nHdl2, cLine + CRLF)		// ****** GRAVA REGISTRO ******

			nQtLines++
			cLine := "AE8"
			cLine += Right(StrZero(Val((cTmp)->D2_NFORI),6),6)
			cLine += Left((cTmp)->D2_SERIORI+Space(4),4)
			cLine += Space(6)
			cLine += Space(3)
			cLine += Space(16)
			cLine += Space(17)
			cLine += Space(10)
			cLine += Space(63)
			FWrite(nHdl, cLine + CRLF)		// ****** GRAVA REGISTRO ******
			FWrite(nHdl2, cLine + CRLF)		// ****** GRAVA REGISTRO ******

			(cTmp)->(DbSkip())
		Enddo

		nQtLines++
		cLine := "FTP"
		cLine += nSeq
		cLine += StrZero(nQtLines+1,9)
		cLine += SubStr(StrZero(nSValBrut,18,2),1,15)+SubStr(StrZero(nSValBrut,18,2),17,2)
		cLine += '0'
		FWrite( nHdl, cLine + CRLF)		// ****** GRAVA REGISTRO ******
		FWrite( nHdl2, cLine + CRLF)		// ****** GRAVA REGISTRO ******

		fClose(nHdl)
		fClose(nHdl2)

		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSeek( cChave )
		RecLock( "SF2", .F. )
		SF2->F2_ZZEDI := "x"
		MsUnlock()

		// Incrementa o n๚mero sequencial do EDI em cada arquivo
		PutMv("MV_SEQEDI", (Val(nSeq)+1))

		ConOut("Processando [" + cLogConsole + "]")

		dbSelectArea( cTmp )

	Enddo
	If Empty( cBodyLoop )
		cBodyLoop := "SEM ARQUIVOS A ENVIAR"
		cAssunto  += "SEM ARQUIVOS A ENVIAR"
	Endif

	dbCloseArea()

	MonitMail( cAssunto, cBody + cBodyLoop )

Return( nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfConsSQL  บAutor  ณAlessandro Freire   บ Data ณ  24/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a String da Consulta                                 บฑฑ
ฑฑบ          ณHonda Lock                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fConsSQL()

	cQry := "SELECT	'ITP' AS ITP, "
	cQry += "		ISNULL((SELECT TOP 1 A1_CGC FROM "+RetSqlName('SA1')+" WHERE A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = SF2.F2_CLIENTE AND A1_LOJA = SF2.F2_LOJA AND D_E_L_E_T_ = ' ' ),'') AS CGCRECP, "
	cQry += "		'AE1' AS AE1, "
	cQry += "		SF2.F2_CLIENTE, "
	cQry += "		SF2.F2_LOJA, "
	cQry += "		SF2.F2_DOC, "
	cQry += "		SF2.F2_SERIE, "
	cQry += "		SF2.F2_EMISSAO, "
	cQry += "		(SELECT MAX(D2_ITEM) FROM "+RetSqlName('SD2')+" WHERE D2_FILIAL = '"+xFilial('SD2')+"' AND D2_DOC = SF2.F2_DOC AND D2_SERIE = SF2.F2_SERIE AND D_E_L_E_T_ = ' ' ) AS NITEM, "
	cQry += "		SF2.F2_VALBRUT, "
	cQry += "		SD2.D2_CF, "
	cQry += "		SF2.F2_VALICM, "
	cQry += "		(SELECT MAX(E1_VENCTO) FROM "+RetSqlName('SE1')+" WHERE E1_FILIAL = '"+xFilial('SE1')+"' AND E1_NUM = SF2.F2_DOC AND E1_PREFIXO = SF2.F2_SERIE AND E1_CLIENTE = SF2.F2_CLIENTE AND E1_LOJA = SF2.F2_LOJA AND D_E_L_E_T_ = ' ' ) AS E1_VENCTO, "
	cQry += "		(SELECT TOP 1F4_DUPLIC FROM "+RetSqlName('SF4')+" WHERE F4_FILIAL = '"+xFilial('SF4')+"' AND F4_CODIGO = SD2.D2_TES AND D_E_L_E_T_ = ' ') AS F4_DUPLIC, "
	//cQry += "		SD2.D2_VALIPI, "  -- comentado para gerar a soma de IPI neste bloco LL 24/05
	cQry += "		SF2.F2_VALIPI, " //AJUSTADO LUCIANO LAMBERTI - 24/05/2019
	cQry += "		(SELECT TOP 1 X5_DESCRI FROM "+RetSqlName('SX5')+" WHERE X5_FILIAL = '"+xFilial('SX5')+"' AND X5_TABELA = '13' AND X5_CHAVE = SD2.D2_CF AND D_E_L_E_T_ = ' ') AS CFOP, "
	cQry += "		(SELECT MAX(C6_ENTREG) FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND D_E_L_E_T_ = ' ' ) AS F2_ZZDTSAI, "
	cQry += "		(SELECT MAX(C6_HORA) FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND D_E_L_E_T_ = ' ' ) AS F2_ZZHRSAI, "
	cQry += "		'NF2' AS NF2, "
	cQry += "		SF2.F2_DESPESA, "
	cQry += "		SF2.F2_FRETE, "
	cQry += "		SF2.F2_SEGURO, "
	cQry += "		SF2.F2_DESCONT, "
	cQry += "		SF2.F2_BASEICM, "
	cQry += "		(SELECT TOP 1SUM(D2_DESCZFR) FROM "+RetSqlName('SD2')+" WHERE D2_FILIAL = '"+xFilial('SD2')+"' AND D2_DOC = SF2.F2_DOC AND D2_SERIE = SF2.F2_SERIE AND D_E_L_E_T_ = ' ' ) AS VLDESCICMS, "
	cQry += "		SD2.D2_NFORI, "
	cQry += "		ISNULL((SELECT TOP 1 F1_EMISSAO FROM "+RetSqlName('SF1')+" WHERE F1_FILIAL = '"+xFilial('SF1')+"' AND F1_DOC = SD2.D2_NFORI AND F1_SERIE = SD2.D2_SERIORI AND D_E_L_E_T_ = ' '),'') AS F1_EMISSAO, "
	cQry += "		SD2.D2_SERIORI, "
	cQry += "		SD2.D2_CF, "
	cQry += "		SD2.D2_CODISS, "
	cQry += "		SD2.D2_TOTAL, "
	cQry += "		'AE2' AS AE2, "
	cQry += "		SD2.D2_ITEM, "
	cQry += "		(SELECT TOP 1 C6_PEDCLI FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ' ) AS C6_PEDCLI, "
	cQry += "		ISNULL((SELECT TOP 1 B1_CODMATR FROM "+RetSqlName('SB1')+" WHERE B1_FILIAL = '"+xFilial('SB1')+"' AND B1_COD = SD2.D2_COD AND D_E_L_E_T_ = ' ' ),'') AS B1_CODMATR, "
	cQry += "		SD2.D2_QUANT, "
	cQry += "		SD2.D2_UM, "
	cQry += "		ISNULL((SELECT TOP 1 B1_POSIPI FROM "+RetSqlName('SB1')+" WHERE B1_FILIAL = '"+xFilial('SB1')+"' AND B1_COD = SD2.D2_COD AND D_E_L_E_T_ = ' ' ),'') AS B1_POSIPI, "
	cQry += "		(SELECT TOP 1 C6_NFFATUR FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ' ) AS C6_NFFATUR, "
	cQry += "		(SELECT TOP 1 C6_NFSERIE FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ' ) AS C6_NFSERIE, "
	cQry += "		(SELECT TOP 1 C6_ITEMFAT FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ' ) AS C6_ITEMFAT, "
	cQry += "		(SELECT C6_ZZIDEXP C6 FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ' ) AS C6_ZZIDEXP, " // ADD LUCIANO LAMBERTI
	cQry += "		SD2.D2_IPI, "
	cQry += "		SD2.D2_PRCVEN, "
	cQry += "		SD2.D2_DESC, "
	cQry += "		SD2.D2_DESCON, "
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
	cQry += "		(SELECT TOP 1 C6_PEDCLI FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_PEDCLI, "
	cQry += "		(SELECT TOP 1 C6_NUMSERI FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_NUMSERIE, "
	cQry += "		(SELECT TOP 1 C6_SLIPNUM FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_SLIPNUM, "
	cQry += "		(SELECT TOP 1 C6_SEPEN FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_SEPEN, "
	cQry += "		(SELECT TOP 1 C6_TIPOP FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_TIPOP, "
	cQry += "		(SELECT TOP 1 C6_LOTEHAB FROM "+RetSqlName('SC6')+" WHERE C6_FILIAL = '"+xFilial('SC6')+"' AND C6_NUM = SD2.D2_PEDIDO AND C6_ITEM = SD2.D2_ITEMPV AND D_E_L_E_T_ = ' ') AS C6_LOTEHAB, "		//ACRESCENTADO POR RODRIGO BREDA 22/05/2013 PARA TRAZER LOTE CORRETO
	cQry += "		SD2.D2_LOTECTL "
	cQry += "FROM "+RetSqlName('SF2')+" SF2 INNER JOIN "+RetSqlName('SD2')+" SD2 "
	cQry += "		ON SF2.F2_FILIAL 	=	SD2.D2_FILIAL	AND "
	cQry += "		SF2.F2_DOC			=	SD2.D2_DOC 		AND "
	cQry += "		SF2.F2_SERIE		=	SD2.D2_SERIE	AND "
	cQry += "		SF2.D_E_L_E_T_		=	' '				AND "
	cQry += "		SD2.D_E_L_E_T_		=	' '				AND "
	cQry += "		SF2.F2_FILIAL		=	'"+xFilial('SF2')+"' AND "
	cQry += "		SF2.F2_ZZEDI = ' ' "
	cQry += "GROUP BY "
	cQry += "		SF2.F2_DOC, "
	cQry += "		SF2.F2_SERIE, "
	cQry += "		SF2.F2_CLIENTE, "
	cQry += "		SF2.F2_LOJA, "
	cQry += "		SF2.F2_EMISSAO, "
	cQry += "		SF2.F2_VALBRUT, "
	cQry += "		SD2.D2_CF, "
	cQry += "		SF2.F2_VALICM, "
	//cQry += "		SD2.D2_VALIPI, "
	cQry += "		SF2.F2_VALIPI, " // Ajustado Luciano Lamberti - 24-05-19
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
	cQry += "		SD2.D2_VALIPI, "
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

****************************************************************************************

static Function MonitMail( cAssunto, cMensagem )

	Local cMailServer := GETMV("MV_RELSERV")
	Local cMailContX  := GETMV("MV_RELACNT")
	Local cMailSenha  := GETMV("MV_RELAPSW")
	Local cMailDest   := GETMV("MV_HLEDIM" )
	Local lConnect    := .f.
	Local lEnv        := .f.
	Local lFim        := .f.

	CONNECT SMTP SERVER cMailServer ACCOUNT cMailContX PASSWORD cMailSenha RESULT lConnect

	IF GetMv("MV_RELAUTH")
		MailAuth( cMailContX, cMailSenha )
	EndIF

	If (lConnect)  // testa se a conexใo foi feita com sucesso
		SEND MAIL FROM cMailContX TO cMailDest SUBJECT cAssunto BODY cMensagem RESULT lEnv
	Endif

	If ! lEnv
		GET MAIL ERROR cErro
	EndIf

	DISCONNECT SMTP SERVER RESULT lFim


Return(nil)
