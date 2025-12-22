#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"
#include "tbiconn.ch

#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2
#define CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE

/*/{protheus.doc}GESD3NFIMP
Listagem do Pr้-Inventแrio.
@author Cassandra J. Silv
@since 05/11/2010
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ HLESTR01  บ Autor ณ Cassandra J. Silva บ Data ณ 05/11/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณ Listagem do Pr้-Inventแrio.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10 - TopConnect - Especํfico                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HLESTR01()	&& HL  - Honda Lock
	&& EST - Estoque
	&& R   - Relat๓rio
	&& 01  - No. Sequencial

	Local oTelaPrinc

	Define MsDialog oTelaPrinc Title "Emissใo da Listagem para Pr้-Inventแrio" From 0,0 To 250,430 Pixel
	Define Font oBold Name "Arial" Size 0,-13 Bold
	@ 000,000 Bitmap oBmp ResName "LOGIN" Of oTelaPrinc Size 30,120 NoBorder When .f. Pixel
	@ 003,040 Say "LISTAGEM PRษ-INVENTมRIO" Font oBold Pixel
	@ 014,030 To 016,400 Label '' Of oTelaPrinc  Pixel
	@ 020,124 Button "Exportar"		Size 40,13 Pixel Of oTelaPrinc Action Processa({|| PrintRel(oTelaPrinc) },"Processando...")
	@ 020,166 Button "Importar"    	Size 40,13 Pixel Of oTelaPrinc Action fImpExcel()
	@ 040,166 Button "Sair"       	Size 40,13 Pixel Of oTelaPrinc Action oTelaPrinc:End()
	Activate MsDialog oTelaPrinc Centered

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PrintRel  บ Autor ณ Cassandra J. Silva บ Data ณ 05/11/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณ Filtra e Imprime os dados do Relat๓rio.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10 - TopConnect - Especํfico                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintRel(oTelaPrinc)

	Local nLin 	     := 3000
	Local nCol	     := 0020
	Local nMais      := 0120
	Local nAux       := 0000
	Local nHdl       := 0000
	Local cQuery     := ""
	Local cDirDocs   := MsDocPath()
	Local Titulo     := "LISTAGEM PRษ-INVENTมRIO"
	Local cPerg      := "HLESTR01"
	Local cAlmox     := ""
	Private	oPrint
	Private nPag	 := 0
	Private	nTamProd := 0
	Private	nTamCodHL:= 0
	Private	nTamUM   := 0
	Private	nTamTipo := 0
	Private	nTamLote := 0
	Private	nTamDtVal:= 0
	Private	nTamSld  := 0
	Private	nTamAlm  := 0
	Private	nTamEnd  := 0
	Private cArquivo := CriaTrab(,.F.)
	Private	oPrint   := TMSPrinter():New("LISTAGEM PRษ-INVENTมRIO")
	Private nMaxCol  := 3350
	Private cFLogo   := "lgrl01.bmp"
	Private oFont10  := tFont():New("Arial",,09,,.f.,,,,.f.,.f.,,,,,,oPrint)
	Private oFont10b := tFont():New("Arial",,10,,.t.,,,,.f.,.f.,,,,,,oPrint)
	Private oFont11  := tFont():New("Arial",,11,,.f.,,,,.f.,.f.,,,,,,oPrint)
	Private oFont11b := tFont():New("Arial",,11,,.t.,,,,.f.,.f.,,,,,,oPrint)
	Private oFont12  := tFont():New("Arial",,10,,.f.,,,,.f.,.f.,,,,,,oPrint)
	Private oFont12b := tFont():New("Arial",,11,,.t.,,,,.f.,.f.,,,,,,oPrint)
	Private oFont14  := tFont():New("Arial",,14,,.f.,,,,.f.,.f.,,,,,,oPrint)
	Private oFont14b := tFont():New("Arial",,14,,.t.,,,,.f.,.f.,,,,,,oPrint)
	Private oFont16b := tFont():New("Arial",,16,,.t.,,,,.f.,.t.,,,,,,oPrint)
	Private	oBrush	 := TBrush():New(,4)
	Private	oPen	 := TPen():New(0,5,CLR_BLACK)
	Private lImpLote  := .F.

	ValidPerg(cPerg)
	If !Pergunte(cPerg,.T.)
		Return Nil
	Endif

	lImpLote := .F.
	If Upper(Alltrim(MV_PAR05)) <= "PA" .and. Upper(Alltrim(MV_PAR06)) >= "PA"
		lImpLote := .T.
	Endif

	If Upper(Alltrim(MV_PAR05)) == "PA" .or. Upper(Alltrim(MV_PAR06)) == "PA"
		lImpLote := .T.
	Endif

	oTelaPrinc:End()
	If File(cDirDocs+"\"+cArquivo+".csv")
		fErase(cDirDocs+"\"+cArquivo+".csv")	 && Se existe apaga o arquivo
	Endif

	&& Cria arquivo csv:
	nHdl	:=	MSFCreate(cDirDocs+"\"+cArquivo+".csv")
	fWrite(nHdl, "Produto;C๓digo HL;Unidade;Tipo;Grupo;Armazem;Lote;Validade Lote;Saldo Lote;Endereco;Qdte. Inventariada;Contagem1;Contagem2;Diferen็a;Contagem3" + Chr(13) + Chr(10))
	If lImpLote
		nTamProd   := 380
		nTamCodHL  := 900
		nTamUM     := 100
		nTamTipo   := 150
		nTamLote   := 300
		nTamDtVal  := 250
		nTamSld    := 300
		nTamAlm    := 150
		nTamEnd    := 400

	Else
		nTamProd   := 400
		nTamCodHL  := 900
		nTamUM     := 200
		nTamTipo   := 200
		nTamAlm    := 200
		nTamEnd    := 500
	Endif

	cQuery := " SELECT"

	If lImpLote
		cQuery +=		" SB1.B1_COD, SB1.B1_DESC, SB1.B1_UM, SB1.B1_TIPO, SB1.B1_GRUPO, SB1.B1_LOCPAD, SB2.B2_LOCAL, SB8.B8_LOTECTL, SB8.B8_DTVALID, SB8.B8_SALDO, SB8.B8_LOCAL"
	Else
		cQuery +=		" SB1.B1_COD, SB1.B1_DESC, SB1.B1_UM, SB1.B1_TIPO, SB1.B1_GRUPO, SB1.B1_LOCPAD, SB2.B2_LOCAL, SB8.B8_LOCAL"
	Endif

	cQuery += " FROM "+RetSqlName("SB1")+" SB1"
	cQuery +=		" INNER JOIN "+RetSqlName("SB2")+" SB2 ON"
	cQuery +=				" SB2.B2_FILIAL = '"+xFilial("SB2")+"' AND"
	cQuery +=				" SB2.B2_COD = SB1.B1_COD AND"
	cQuery +=				" SB2.B2_LOCAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND"
	cQuery +=				" SB2.D_E_L_E_T_ = ' '"
	cQuery +=		" LEFT JOIN "+RetSqlName("SB8")+" SB8 ON"
	cQuery +=				" SB8.B8_FILIAL = '"+xFilial("SB8")+"' AND"
	cQuery +=				" SB8.B8_PRODUTO = SB1.B1_COD AND"
	cQuery +=				" SB8.B8_SALDO > 0 AND"
	cQuery +=				" SB8.D_E_L_E_T_ = ' '"
	cQuery += " WHERE"
	cQuery +=		" SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND"
	cQuery +=		" SB1.B1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND"
	cQuery +=		" SB1.B1_TIPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND"
	cQuery +=		" SB1.B1_GRUPO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND"
	cQuery +=		" SB1.B1_MSBLQL <> '1' AND"
	cQuery +=		" SB1.D_E_L_E_T_ = ' '"

	If lImpLote
		cQuery += " GROUP BY"
		cQuery +=		" SB1.B1_COD, SB1.B1_DESC, SB1.B1_UM, SB1.B1_TIPO, SB1.B1_GRUPO, SB1.B1_LOCPAD, SB2.B2_LOCAL, SB8.B8_LOTECTL, SB8.B8_DTVALID, SB8.B8_SALDO, SB8.B8_LOCAL"
		cQuery += " ORDER BY"
		cQuery +=		" SB1.B1_COD, SB1.B1_LOCPAD, SB2.B2_LOCAL, SB8.B8_LOTECTL, SB8.B8_LOCAL"
	Else
		cQuery += " GROUP BY"
		cQuery +=		" SB1.B1_COD, SB1.B1_DESC, SB1.B1_UM, SB1.B1_TIPO, SB1.B1_GRUPO, SB1.B1_LOCPAD, SB2.B2_LOCAL, SB8.B8_LOCAL"
		cQuery += " ORDER BY"
		cQuery +=		" SB1.B1_COD, SB1.B1_LOCPAD, SB2.B2_LOCAL, SB8.B8_LOCAL"
	Endif

	If Select("QRY") <> 0
		QRY->(dbCloseArea())
	Endif

	TcQuery cQuery Alias "QRY" New

	QRY->(dbGoTop())

	ProcRegua(QRY->(RecCount()))

	oPrint:SetLandscape()	// Impressao deitada SetPortrait() em pe
	oPrint:Setup()
	ImpCab(@nLin)

	Do While QRY->(!Eof())

		cAlmox := ""

		If Empty(cAlmox)
			cAlmox := QRY->B2_LOCAL
		Endif

		If Empty(cAlmox)
			cAlmox := QRY->B8_LOCAL
		Endif

		If nLin > 2000
			nPag := nPag+1
			nLin := nLin + nMais
			oPrint:Say(nLin+015,nCol + (nMaxCol/2), "Contado por: ________________________________________          Digitado por: ________________________________________          Verificado por: __________________________________________    "  ,oFont12b,,,,PAD_CENTER)
			nLin := nLin + nMais
			oPrint:Say(nLin+015,nCol + (nMaxCol/2), "Observa็๕es: ____________________________________________________________________________________________________________________________Pแgina:" + STR(nPag)  ,oFont12b,,,,PAD_CENTER)

			oPrint:EndPage()
			ImpCab(@nLin)
			nCol  := 20
		Endif

		If lImpLote
			nAux := nCol
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && C๓digo
			oPrint:Say(nLin+015,nAux+015, QRY->B1_COD  ,oFont12)
			nAux+=nTamProd
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Descri็ใo (C๓digo HL)

			If Len(Alltrim(QRY->B1_DESC)) > 40
				oPrint:Say(nLin+010,nAux+015, Substr(QRY->B1_DESC,01,40)  ,oFont10)
				oPrint:Say(nLin+035,nAux+015, Substr(QRY->B1_DESC,41,40)  ,oFont10)
			Else
				oPrint:Say(nLin+015,nAux+015, Substr(QRY->B1_DESC,1,40)  ,oFont12)
			Endif

			nAux+=nTamCodHL
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && UM
			oPrint:Say(nLin+015,nAux+015, QRY->B1_UM  ,oFont12)
			nAux+=nTamUM
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Tipo
			oPrint:Say(nLin+015,nAux+015, QRY->B1_TIPO  ,oFont12)
			nAux+=nTamTipo
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Lote
			oPrint:Say(nLin+015,nAux+015, QRY->B8_LOTECTL  ,oFont12)
			nAux+=nTamLote
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Validade
			oPrint:Say(nLin+015,nAux+015, DTOC(STOD(QRY->B8_DTVALID))  ,oFont12)
			nAux+=nTamDtVal
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Saldo
			//oPrint:Say(nLin+015,nAux+nTamSld-15, Transform(QRY->B8_SALDO, "@E 999,999,999.99")  ,oFont12,,,,PAD_RIGHT)
			nAux+=nTamSld
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Almoxarifado
			oPrint:Say(nLin+015,nAux+015, cAlmox  ,oFont12)
			nAux+=nTamAlm
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Endere็o
			oPrint:Say(nLin+015,nAux+015, ""  ,oFont12)
			nAux+=nTamEnd
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Quantidade
			oPrint:Say(nLin+015,nAux+015, " "  ,oFont12)

		Else
			nAux := nCol
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && C๓digo
			oPrint:Say(nLin+010,nAux+015, QRY->B1_COD  ,oFont12)
			nAux+=nTamProd
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Descri็ใo (C๓digo HL)
			oPrint:Say(nLin+010,nAux+015, Substr(QRY->B1_DESC,1,60)  ,oFont12)
			nAux+=nTamCodHL
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && UM
			oPrint:Say(nLin+010,nAux+015, QRY->B1_UM  ,oFont12)
			nAux+=nTamUM
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Tipo
			oPrint:Say(nLin+010,nAux+015, QRY->B1_TIPO  ,oFont12)
			nAux+=nTamTipo
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Grupo
			oPrint:Say(nLin+010,nAux+015, QRY->B1_GRUPO  ,oFont12)
			nAux+=200
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Almoxarifado
			oPrint:Say(nLin+010,nAux+015, cAlmox  ,oFont12)
			nAux+=nTamAlm
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Endere็o
			oPrint:Say(nLin+010,nAux+015, ""  ,oFont12)
			nAux+=nTamEnd
			oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Quantidade
			oPrint:Say(nLin+010,nAux+015, " "  ,oFont12)
		Endif
		nLin := nLin + nMais

		If lImpLote
			If !Empty(QRY->B8_LOTECTL)
				fWrite(nHdl, 	QRY->B1_COD + ";" +;									&& 01- Produto
				QRY->B1_DESC + ";" +;									&& 02- C๓digo HL
				QRY->B1_UM + ";" +;										&& 03- Unidade
				QRY->B1_TIPO + ";" +;									&& 04- Tipo
				QRY->B1_GRUPO + ";" +;									&& 05- Grupo
				cAlmox + ";" +;											&& 06- Armazem
				"LT "+QRY->B8_LOTECTL + ";" +;							&& 07- Lote
				DTOC(STOD(QRY->B8_DTVALID)) + ";" +;					&& 08- Validade Lote
				Transform(QRY->B8_SALDO, "@E 999,999,999.99") + ";" +;	&& 09- Saldo Lote
				";" +;													&& 10- Endere็o
				";" +;													&& 11- Qtde. Inventariada
				";" +;													&& 12- Contagem 1
				";" +;													&& 13- Contagem 2
				";" +;													&& 14- Diferen็a
				Chr(13) + Chr(10) )										&& 15- Contagem 3
			Else
				fWrite(nHdl, 	QRY->B1_COD + ";" +;									&& 01- Produto
				QRY->B1_DESC + ";" +;									&& 02- C๓digo HL
				QRY->B1_UM + ";" +;										&& 03- Unidade
				QRY->B1_TIPO + ";" +;									&& 04- Tipo
				QRY->B1_GRUPO + ";" +;									&& 05- Grupo
				cAlmox + ";" +;	 										&& 06- Armazem
				QRY->B8_LOTECTL + ";" +;								&& 07- Lote
				DTOC(STOD(QRY->B8_DTVALID)) + ";" +;					&& 08- Validade Lote
				Transform(QRY->B8_SALDO, "@E 999,999,999.99") + ";" +;	&& 09- Saldo Lote
				";" +;													&& 10- Endere็o
				";" +;													&& 11- Qtde. Inventariada
				";" +;													&& 12- Contagem 1
				";" +;													&& 13- Contagem 2
				";" +;													&& 14- Diferen็a
				Chr(13) + Chr(10) )										&& 15- Contagem 3
			Endif
		Else
			fWrite(nHdl, 	QRY->B1_COD + ";" +;				&& 01- Produto
			QRY->B1_DESC + ";" +;				&& 02- C๓digo HL
			QRY->B1_UM + ";" +;					&& 03- Unidade
			QRY->B1_TIPO + ";" +;				&& 04- Tipo
			QRY->B1_GRUPO + ";" +;				&& 05- Grupo
			cAlmox + ";" +;						&& 06- Armazem
			";" +;								&& 07- Lote
			";" +;								&& 08- Validade Lote
			";" +;								&& 09- Saldo Lote
			";" +;								&& 10- Endere็o
			";" +;								&& 11- Qtde. Inventariada
			";" +;								&& 12- Contagem 1
			";" +;								&& 13- Contagem 2
			";" +;								&& 14- Diferen็a
			Chr(13) + Chr(10) )					&& 15- Contagem 3
		Endif

		QRY->(dbSkip())
	Enddo

	nLin := nLin + nMais
	nPag := nPag+1
	oPrint:Say(nLin+015,nCol + (nMaxCol/2), "                                                                                                                                  Pแgina:" +STR(nPag)  ,oFont12b)

	QRY->(dbCloseArea())

	&& Fecha arquivo csv:
	fClose(nHdl)
	fExpExcel()

	oPrint:EndPage()
	Ms_Flush()

	Define MsDialog oDlg Title "Emissใo da Listagem para Pr้-Inventแrio" From 0,0 To 250,430 Pixel
	Define Font oBold Name "Arial" Size 0,-13 Bold
	@ 000,000 Bitmap oBmp ResName "LOGIN" Of oDlg Size 30,120 NoBorder When .f. Pixel
	@ 003,040 Say Titulo Font oBold Pixel
	@ 014,030 To 016,400 Label '' Of oDlg  Pixel
	@ 020,040 Button "Visualizar" 	Size 40,13 Pixel Of oDlg Action oPrint:Preview()
	@ 020,082 Button "Configurar" 	Size 40,13 Pixel Of oDlg Action oPrint:Setup()
	@ 020,124 Button "Exportar"		Size 40,13 Pixel Of oDlg Action fExpExcel()
	@ 020,166 Button "Importar"    	Size 40,13 Pixel Of oDlg Action fImpExcel()
	@ 040,124 Button "Parโmetros"  	Size 40,13 Pixel Of oDlg Action (oDlg:End(),Processa({|| PrintRel(oDlg) },"Processando..."))
	@ 040,166 Button "Sair"       	Size 40,13 Pixel Of oDlg Action oDlg:End()
	Activate MsDialog oDlg Centered

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpCab    บ Autor ณ Cassandra J. Silva บ Data ณ 05/11/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณ Imprime o Cabe็alho do Relat๓rio.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10 - TopConnect - Especํfico                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpCab(nLin)

	Local cDesc		:= " "
	Local nCol		:= 020
	Local nMais     := 080

	nLin := 050

	&& Logo e Nome da Empresa
	oPrint:StartPage()

	oPrint:SayBitmap(nLin-10,nCol+20,cFLogo,0400,0090)
	cDesc := Alltrim(Upper(SM0->M0_NOMECOM))
	oPrint:Say(nLin,nCol + (nMaxCol/2), cDesc, oFont16b,,,,PAD_CENTER)

	nLin := nLin + nMais

	If MV_PAR10 > 0
		cDesc := "L I S T A G E M   P A R A   I N V E N T ม R I O   -   C O N T A G E M   NO. "+StrZero(MV_PAR10,3)
	Else
		cDesc := "L I S T A G E M   P A R A   I N V E N T ม R I O"
	Endif

	oPrint:Say(nLin, nCol + (nMaxCol/2),cDesc,oFont14b,,8388608,,PAD_CENTER)

	cDesc := Dtoc(dDataBase)
	oPrint:Say(nLin,3000,cDesc,oFont12b)

	nLin := nLin + nMais + 100
	nAux := nCol

	If lImpLote
		nAux := nCol
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && C๓digo
		oPrint:Say(nLin+010,nAux+015, "PRODUTO"  ,oFont12b)
		nAux+=nTamProd
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Descri็ใo (C๓digo HL)
		oPrint:Say(nLin+010,nAux+015, "CำDIGO HL"  ,oFont12b)
		nAux+=nTamCodHL
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && UM
		oPrint:Say(nLin+010,nAux+015, "UM"  ,oFont12b)
		nAux+=nTamUM
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Tipo
		oPrint:Say(nLin+010,nAux+015, "TIPO"  ,oFont12b)
		nAux+=nTamTipo
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Lote
		oPrint:Say(nLin+010,nAux+015, "LOTE"  ,oFont12b)
		nAux+=nTamLote
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Validade
		oPrint:Say(nLin+010,nAux+015, "VALIDADE"  ,oFont12b)
		nAux+=nTamDtVal
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Saldo
		oPrint:Say(nLin+010,nAux+015, "SALDO"  ,oFont12b)
		nAux+=nTamSld
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Almoxarifado
		oPrint:Say(nLin+010,nAux+015, "ALM"  ,oFont12b)
		nAux+=nTamAlm
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Endere็o
		oPrint:Say(nLin+010,nAux+015, "ENDEREวO"  ,oFont12b)
		nAux+=nTamEnd
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Quantidade
		oPrint:Say(nLin+010,nAux+015, "QUANTIDADE"  ,oFont12b)

	Else
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && C๓digo
		oPrint:Say(nLin+010,nAux+015, "PRODUTO"  ,oFont12b)
		nAux+=nTamProd
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Descri็ใo (C๓digo HL)
		oPrint:Say(nLin+010,nAux+015, "CำDIGO HL"  ,oFont12b)
		nAux+=nTamCodHL
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && UM
		oPrint:Say(nLin+010,nAux+015, "UM"  ,oFont12b)
		nAux+=nTamUM
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Tipo
		oPrint:Say(nLin+010,nAux+015, "TIPO"  ,oFont12b)
		nAux+=nTamTipo
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Grupo
		oPrint:Say(nLin+010,nAux+015, "GRUPO"  ,oFont12b)
		nAux+=200
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Almoxarifado
		oPrint:Say(nLin+010,nAux+015, "ALM."  ,oFont12b)
		nAux+=nTamAlm
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Endere็o
		oPrint:Say(nLin+010,nAux+015, "ENDEREวO"  ,oFont12b)
		nAux+=nTamEnd
		oPrint:Box(nLin,nAux,nLin + nMais,nMaxCol)       && Quantidade
		oPrint:Say(nLin+010,nAux+015, "QUANTIDADE"  ,oFont12b)
	Endif

	nLin := nLin + nMais

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fExpExcel บ Autor ณ Cassandra J. Silva บ Data ณ 05/11/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณ Exporta Resultado para Excel.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10 - TopConnect - Especํfico                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fExpExcel()

	Local cDirDocs := MsDocPath()
	Local cPath	   := AllTrim(GetTempPath())
	Local oExcelApp

	CpyS2T( cDirDocs+"\"+cArquivo+".csv" , cPath, .t. )

	If 	!ApOleClient( 'MsExcel' )
		MsgStop( 'MsExcel nao instalado' )
		Return
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".csv" ) && Abre uma planilha
	oExcelApp:SetVisible(.T.)

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fImpExcel บ Autor ณ Cassandra J. Silva บ Data ณ 08/11/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณ Importa dados a partir de planilha selecionada.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10 - TopConnect - Especํfico                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fImpExcel()

	Local cMask    := "Planilhas (*.CSV) |*.CSV|"
	Local cRet 	   := ""
	Local cArquivo := ""

	cRet     := cGetFile(cMask,"Selecione o Arquivo...",0,,.F.,CGETFILE_TYPE)
	cArquivo := AllTrim(cRet)

	Processa( { || LeArquivo(cArquivo), "Leitura do Arquivo"},"Aguarde..." )

Return Nil

Static Function LeArquivo(cArquivo)

	Local aStruct    := {}
	Local _aInvent   := {}
	Local aRelat     := {}
	Local cArqTxt    := ""
	Local cNomeLog   := ""
	Local cArqTRB    := CriaTrab(,.F.)
	Local lImport    := .F.
	Local lLog       := .F.
	Local lProcessa  := .F.
	Local lImpLote   := .F.
	Private _cCod	 := Space(15)
	Private _cLocal	 := Space(02)
	Private _nQuant	 := 0
	Private _cDesc	 := Space(40)
	Private _cLoteCTL:= Space(10)
	Private cDoc	 := cValToChar(StrZero(Day(dDataBase),2)) + cValToChar(StrZero(month(dDataBase),2)) + Right(cValToChar(year(dDataBase)),2) + "01"
	Private lMsErroAuto := .F.

	If !Empty(cArquivo)
		cArqTxt := Alltrim(cArquivo)
	EndIf

	lImport := .F.
	lLog    := .F.
	lImpLote:= .F.
	If File(cArqTxt)
		Aadd(aStruct, {"REGISTRO", "C", 900, 0})

		// cArqTRB := CriaTrab(aStruct, .T.)
		// dbUseArea(.T.,, cArqTRB, "TRB", .T., .F.)
		// Append From &cArqTxt. SDF           			&& Converter TXT p/ DBF (Appendar Registros)

		// TRB->(dbGoTop())
		// ProcRegua(TRB->( RecCount() ))
		// TRB->(dbGoTop())

		// Instancio o objeto
		oTable  := FwTemporaryTable():New( "TRB" )
		// Adiciono os campos na tabela
		oTable:SetFields( aStruct )
		// Adiciono os ํndices da tabela
		// oTable:AddIndex( '01' , { cIndxKEY })
		// Crio a tabela no banco de dados
		oTable:Create()

		Do While TRB->(!Eof())

			IncProc("Processando ...."+Strzero(TRB->(Recno()),6))

			If Empty(TRB->REGISTRO) .or. Upper(Left(TRB->REGISTRO,07)) == "PRODUTO"
				TRB->(dbSkip())
				Loop
			EndIf

			_cCod		:= Space(15)
			_cLocal		:= Space(02)
			_nQuant		:= 0
			_cDesc		:= Space(40)
			_cLoteCTL	:= Space(10)
			lProcessa   := .F.

			AchaCampo(TRB->REGISTRO, @lProcessa, @lImpLote)    && Encontrar os Campos Necessarios do Registro

			SB1->(dbSetOrder(1))

			If lProcessa .and. !Empty(Alltrim(_cCod)) .and. Alltrim(_cLocal) <> "00" .and. !Empty(_cLocal)

				_cCod		:= Substr(Alltrim(_cCod)+Space(Len(SB1->B1_COD)),1,Len(SB1->B1_COD))
				_cLocal		:= Substr(Alltrim(_cLocal)+Space(Len(SB7->B7_LOCAL)),1,Len(SB7->B7_LOCAL))
				_cLoteCTL	:= Substr(Alltrim(_cLoteCTL)+Space(Len(SB7->B7_LOTECTL)),1,Len(SB7->B7_LOTECTL))

				If _cCod <> "Codigo"
					If SB1->(dbSeek( xFilial("SB1") + _cCod ))

						If Alltrim(SB1->B1_RASTRO) == "L" .and. Empty(_cLoteCTL)
							TRB->(dbSkip())
							Loop
						Endif

						SB7->(dbSetOrder(1))	&& B7_FILIAL + DTOS(B7_DATA) + B7_COD + B7_LOCAL + B7_LOCALIZ + B7_NUMSERI + B7_LOTECTL + B7_NUMLOTE + B7_CONTAGE
						If !SB7->(dbSeek( xFilial("SB7") + DTOS(dDataBase) + _cCod  + _cLocal + Space(Len(SB7->B7_LOCALIZ)) + Space(Len(SB7->B7_NUMSERI)) + _cLoteCTL ))
							_aInvent := {}
							aAdd(_aInvent,{"B7_FILIAL"  , xFilial("SB7")	,Nil})
							aAdd(_aInvent,{"B7_COD"     , _cCod    			,Nil})
							aAdd(_aInvent,{"B7_LOCAL"   , _cLocal  			,Nil})
							aAdd(_aInvent,{"B7_DOC"     , cDoc    			,Nil})
							aAdd(_aInvent,{"B7_QUANT"   , _nQuant  			,Nil})
							aAdd(_aInvent,{"B7_DATA"    , dDataBase			,Nil})
							aAdd(_aInvent,{"B7_LOTECTL" , _cLoteCTL 		,Nil})
							aAdd(_aInvent,{"B7_DTVALID" , Ctod("31/12/2049"),Nil})

							If Len(_aInvent) > 0
								lMsErroAuto := .F.
								//							LjMsgRun("Incluindo Inventแrio automaticamente... "+_cCod+" "+_cLocal+" "+_cLoteCTL+" "+Strzero(TRB->(Recno()),6),,{||MSExecAuto( {|x,y,z,w| MATA270( x, y, z, w ) }, _aInvent, 3, .F. )})  //modificado Breda 24/04/2013
								LjMsgRun("Incluindo Inventแrio automaticamente... "+_cCod+" "+_cLocal+" "+_cLoteCTL+" "+Strzero(TRB->(Recno()),6),,{||MSExecAuto( {|x,y,z,w| MATA270( x, y, z, w ) }, _aInvent, .F., 3 )})
								If lMsErroAuto
									DisarmTransaction()
									cNomeLog := "Import_"+DTOS(dDataBase)+"_"+Alltrim(StrTran(Time(),":",""))+".log"
									MostraErro("\LogInvent\",cNomeLog)
									lLog := .T.
									If Ascan(aRelat, { |x| x[2] == _cCod .and. x[3] == _cLocal .and. x[4] == cDoc .and. x[5] == Transform(_nQuant,"@E 999,999,999.99")  }) == 0
										Aadd(aRelat, {	xFilial("SB7"),;							 && 01
										_cCod,;                                      && 02
										_cLocal,;                                    && 03
										cDoc,;                                       && 04
										Transform(_nQuant,"@E 999,999,999.99"),;     && 05
										Dtoc(dDataBase),;                            && 06
										Substr(_cLoteCTL,6,Len(SB7->B7_LOTECTL)),;   && 07
										Ctod("31/12/2049"),;                         && 08
										"\LogInvent\"+cNomeLog+"."})		 		 && 09
									Endif
								Else
									lImport	:= .T.
								Endif
							Endif
						Else
							If Ascan(aRelat, { |x| x[2] == _cCod .and. x[3] == _cLocal .and. x[4] == cDoc .and. x[5] == Transform(_nQuant,"@E 999,999,999.99")  }) == 0
								Aadd(aRelat, {	xFilial("SB7"),;							 && 01
								_cCod,;                                      && 02
								_cLocal,;                                    && 03
								cDoc,;                                       && 04
								Transform(_nQuant,"@E 999,999,999.99"),;     && 05
								Dtoc(dDataBase),;                            && 06
								Substr(_cLoteCTL,6,Len(SB7->B7_LOTECTL)),;   && 07
								Ctod("31/12/2049"),;                         && 08
								"Jแ existe este registro no sistema (SB7)."})&& 09
							Endif
						Endif
					Else
						If Ascan(aRelat, { |x| x[2] == _cCod .and. x[3] == _cLocal .and. x[4] == cDoc .and. x[5] == Transform(_nQuant,"@E 999,999,999.99")  }) == 0
							Aadd(aRelat, {	xFilial("SB7"),;							 && 01
							_cCod,;                                      && 02
							_cLocal,;                                    && 03
							cDoc,;                                       && 04
							Transform(_nQuant,"@E 999,999,999.99"),;     && 05
							Dtoc(dDataBase),;                            && 06
							Substr(_cLoteCTL,6,Len(SB7->B7_LOTECTL)),;   && 07
							Ctod("31/12/2049"),;                         && 08
							"C๓digo do produto nใo encontrado (SB1)."})	 && 09
						Endif
					Endif
				Endif
			Endif

			TRB->(dbSkip())
		Enddo

		DbSelectArea("TRB")                 && Apagar Arquivos Temporarios
		TRB->(DbCloseArea())
		Ferase(cArqTRB + ".DBF")
	Else
		Alert("Arquivo 'CSV' " + cArqTxt + " Nใo Encontrado !!!")
	Endif

	If lImport
		If lLog
			Aviso("Importa็ใo Realizada", "Importa็ใo concluํda com sucesso!!!"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"Aten็ใo: Verifique os logs que foram gerados na pasta '\Protheus11\Protheus_Data\LogInvent'.", {"Ok"}, 3)
		Else
			Aviso("Importa็ใo Realizada", "Importa็ใo concluํda com sucesso!!!", {"Ok"}, 3)
		Endif
	Else
		If lLog
			Aviso("Importa็ใo com Problema", "Nใo foram importados nenhum registro."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"Aten็ใo: Verifique os logs que foram gerados na pasta '\Protheus11\Protheus_Data\LogInvent'.", {"Ok"}, 3)
		Else
			Aviso("Importa็ใo com Problema", "Nใo foram importados nenhum registro.", {"Ok"}, 3)
		Endif
	Endif

	If Len(aRelat) > 0
		fImpRelat(aRelat)
	Endif

Return Nil

Static Function AchaCampo(_cStr, lProcessa, lImpLote)

	Local cString    := Alltrim(_cStr)     // String a Desmembrar -> '"XXXXX","99999", '
	Local cRegistro  := cString            // Linha do Registro
	Local cCampoAux  := ""                 // Campo do Resgistro
	Local nCampoAux  := 0                  // Numero do Campo Registro
	Local nIndicePos := 0                  // Posicao da Primeira Ocorrencia de ",
	Local nPosInicio := 0                  // Posicao Inicial do Campo na String
	Local nPosAnteri := 0                  // Posicao Anterior a ",
	Local nPosPoster := 0                  // Posicao Posterior a ",
	Local x          := 0
	Local _lUltimo   := .F.
	Local lVAzio	 := .F.

	For x := 1 To Len(cString)             // Percorrer Toda a String

		nIndicePos := At(';', cRegistro)  // Pesquisa a Posicao da 1a. Ocorrencia de ",

		If nIndicePos > 0                  // Posicao Encontrada do ;

			nCampoAux++

			If nCampoAux == 1
				nPosInicio := 1
				nPosAnteri := nIndicePos - 1
			Else
				nPosInicio := 1
				nPosAnteri := nIndicePos - 1
			EndIf

			nPosPoster := nIndicePos + 1

			cCampoAux := Alltrim(Substr(cRegistro, nPosInicio, nPosAnteri))
			cRegistro := Substr(cRegistro, nPosPoster)

			If nCampoAux == 1
				SB1->(dbSetOrder(1))
				_cCod		:= Ltrim(cCampoAux)
				_cCod		:= Substr(Alltrim(_cCod)+Space(Len(SB1->B1_COD)),1,Len(SB1->B1_COD))
				If SB1->(dbSeek( xFilial("SB1") + _cCod ))
					If Upper(Alltrim(SB1->B1_TIPO)) == "PA"
						lImpLote := .T.
					Endif
				Endif
			Endif

			&& 01- Produto
			&& 02- C๓digo HL
			&& 03- Unidade
			&& 04- Tipo
			&& 05- Grupo
			&& 06- Armazem
			&& 07- Lote
			&& 08- Validade Lote
			&& 09- Saldo Lote
			&& 10- Endereco
			&& 11- Qdte. Inventariada
			&& 12- Contagem1
			&& 13- Contagem2
			&& 14- Diferen็a
			&& 15- Contagem3

			If nCampoAux == 1
				_cCod		:= Ltrim(cCampoAux)
			ElseIf nCampoAux == 2
				_cDesc		:= Ltrim(cCampoAux)
			ElseIf nCampoAux == 6
				_cLocal		:= StrZero(Val(cCampoAux),02)
			ElseIf nCampoAux == 7
				_cLoteCTL	:= Alltrim(StrTran(cCampoAux,"LT ",""))
			Elseif nCampoAux ==  11
				If !Empty(Alltrim(cCampoAux))
					_nPoint     := IIf(Alltrim(cCampoAux)="", "0", If("."$cCampoAux,StrTran(cCampoAux,".",""),cCampoAux))
					_nQuant		:= If(","$_nPoint,Val(StrTran(_nPoint,",","")),Val(_nPoint))
					lProcessa   := .T.
				Endif
			Endif

		Else
			If nCampoAux == 09 .And. !_lUltimo
				_lUltimo  := .T.
				cCampoAux := Alltrim(cRegistro)
				_cContaC  := cCampoAux
			EndIf
		EndIf
	Next

Return (.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fImpRelat บ Autor ณ Cassandra J. Silva บ Data ณ 09/11/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณ Relat๓rio de Inconsist๊ncia no Processo de Importa็ใo.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10 - TopConnect - Especํfico                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fImpRelat(aRelat)

	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := "Relat๓rio de Inconsist๊ncia na Importa็ใo do Inventแrio"
	Local cPict         := ""
	Local titulo       	:= "Relat๓rio de Inconsist๊ncia na Importa็ใo do Inventแrio"
	Local nLin         	:= 80
	Local Cabec1       	:= "Fil  Produto         Descri็ใo Abreviada                  Alm    Quantidade   Lote        Problema"
	Local Cabec2       	:= ""
	Local imprime      	:= .T.
	Local aOrd 			:= {}
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 132
	Private tamanho     := "M"
	Private nomeprog    := "HLESTR01"
	Private nTipo       := 15
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "HLESTR01"
	Private cString 	:= ""

	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return Nil
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return Nil
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,aRelat) },Titulo)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  09/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,aRelat)

	Local nCont := 0

	SetRegua(Len(aRelat))

	SB1->(dbSetOrder(1))

	aRelat := aSort(aRelat,,, {|x,y| (x[9]+x[2]) < (y[9]+y[2]) })

	For nCont:=1 to Len(aRelat)

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		&&          10        20        30        40        50        60        70        80        90        100       110       120       130
		&& 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
		&& Fil  Produto         Descri็ใo Abreviada                  Alm    Quantidade   Lote        Problema
		&& 12   123456789012345 12345678901234567890123456789012345  12  999,999,999.99  1234567890  1234567890123456789012345678901234

		SB1->(dbSeek( xFilial("SB1") + aRelat[nCont,02] ))

		@ nLin, 001 PSay aRelat[nCont,01]
		@ nLin, 006 PSay aRelat[nCont,02]
		@ nLin, 022 PSay Substr(SB1->B1_DESC,1,35)
		@ nLin, 059 PSay aRelat[nCont,03]
		@ nLin, 063 PSay aRelat[nCont,05]
		@ nLin, 079 PSay Substr(aRelat[nCont,07],1,10)
		@ nLin, 091 PSay aRelat[nCont,09]
		nLin++
	Next

	Set Device to Screen

	If aReturn[5]==1
		dbCommitAll()
		Set Printer To
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValidPerg บ Autor ณ Cassandra J. Silva บ Data ณ 05/11/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณ Monta Grupo de Perguntas do Relat๓rio.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10 - TopConnect - Especํfico                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)

	Local i     := 	0
	Local j     := 	0
	Local aRegs := 	{}
	Local a     := 	.f.

	SX1->(dbSetOrder(1))

	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	Aadd(aRegs,{cPerg,"01", "Armazem  de ?					", "", "", "mv_ch1", "C", 02, 0, 0, "G", "", "mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"02", "Armazem ate ?					", "", "", "mv_ch2", "C", 02, 0, 0, "G", "", "mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"03", "Produto de ?					", "", "", "mv_ch3", "C", 15, 0, 0, "G", "", "mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	Aadd(aRegs,{cPerg,"04", "Produto ate ?					", "", "", "mv_ch4", "C", 15, 0, 0, "G", "", "mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	Aadd(aRegs,{cPerg,"05", "Tipo de ?						", "", "", "mv_ch5", "C", 02, 0, 0, "G", "", "mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","02"})
	Aadd(aRegs,{cPerg,"06", "Tipo ate ?						", "", "", "mv_ch6", "C", 02, 0, 0, "G", "", "mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","02"})
	Aadd(aRegs,{cPerg,"07", "Grupo de ?						", "", "", "mv_ch7", "C", 04, 0, 0, "G", "", "mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
	Aadd(aRegs,{cPerg,"08", "Grupo ate ?					", "", "", "mv_ch8", "C", 04, 0, 0, "G", "", "mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
	Aadd(aRegs,{cPerg,"09", "Lista Prod. Com Saldo Zerado ?	", "", "", "mv_ch9", "N", 01, 0, 0, "C", "", "mv_par09","Sim","Sim","Sim","","","Nใo","Nใo","Nใo","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"10", "Contagem No. :  	            ", "", "", "mv_chA", "N", 03, 0, 0, "G", "", "mv_par10","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		a := SX1->(dbSeek(cPerg+aRegs[i,2]))
		RecLock("SX1",!a)
		For j := 1 to FCount()
			If 	j <= Len(aRegs[i]) .and. !( a .and. j >= 15 )
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Next

Return Nil
