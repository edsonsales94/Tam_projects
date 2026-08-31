#include "rwmake.ch"

User Function PLESTR06()
	Local oTela
	Local cPerg := PADR("PLESTR06",Len(SX1->X1_GRUPO))

	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)

	@ 200,1 TO 380,380 DIALOG  oTela TITLE OemToAnsi("Impressão etiqueta Probel")
	@ 02,10 TO 080,190

	@ 10,018 Say "Este programa tem como objetivo a impressão das etiquetas "
	@ 18,018 Say "conforme os parâmetros especificados pelo usuário."

	@ 70,128 BMPBUTTON TYPE 01 ACTION (Imprime(),Close( oTela))
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close( oTela)
	@ 70,100 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

	Activate Dialog  oTela Centered

Return

Static Function Imprime()
	Local cQry, cDesc, nPos
	Local cTable   := CriaTrab(Nil,.F.)
	Local cPicture := PesqPict("SA2", "A2_CGC")

	cQry := "SELECT A1_LOJA, A1_COD, B1_COD, B1_DESC, A7_PRECO12"
	cQry += " FROM "+RetSqlName("SB1")+" SB1"
	cQry += " INNER JOIN "+RetSqlName("SA7")+" SA7 ON SA7.D_E_L_E_T_ = ' ' AND A7_PRODUTO = B1_COD"
	cQry += " AND A7_CLIENTE = '" +mv_par03+"'"
	cQry += " AND A7_LOJA = '" +mv_par04+"'"
	cQry += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.D_E_L_E_T_ = ' ' AND A1_COD = A7_CLIENTE AND A1_LOJA = A7_LOJA"
	cQry += " WHERE SB1.D_E_L_E_T_ = ' '"
	cQry += " AND B1_COD BETWEEN '" +mv_par01+"' AND '" +mv_par02+ "'"
	cQry += " ORDER BY B1_COD"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),cTable,.T.,.T.)

	If (cTable)->(Eof() .And. Bof())
		Alert("Sem dados para a impressão !")
	Else
		MsCbPrinter("Z4M","LPT1",,,.F.,,,,)
		MsCbChkStatus(.F.)

		While !(cTable)->(EOF())

			cDesc := ALLTRIM((cTable)->B1_DESC)
			nPos  := Rat(" ",Substr(cDesc,1,40))

			For nX:=1 To mv_par06

				cSeq := GetMv("MV_XSEQPRO")
				PutMV("MV_XSEQPRO",Soma1(cSeq))

				MsCbBegin( 1, 6)
				MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4^MD25^JUS^LRN^CI0^XZ^XA^MMT^LL0709^PW709^LS0")

				If !Empty(mv_par08)
					MSCBWRITE("^FT175,608^A0N,36,36^FH\^FDFILIAL: "+mv_par08+"^FS")
					MSCBWRITE("^FT190,608^A0N,36,36^FH\^FD"+PADL("VALOR: R$ "+Alltrim(Transform((cTable)->A7_PRECO12,"@E 9,999,999,999,999.99")),36)+"^FS")
				Else
					MSCBWRITE("^FT35,608^A0N,36,36^FH\^FD"+PADL("VALOR: R$ "+Alltrim(Transform((cTable)->A7_PRECO12,"@E 9,999,999,999,999.99")),36)+"^FS")
				Endif

				MSCBWRITE("^FT50,269^A0N,33,33^FH\^FD"+PADL(ALLTRIM(Substr(cDesc,1,nPos)),40)+"^FS")
				MSCBWRITE("^FT35,307^A0N,33,33^FH\^FD"+PADL(ALLTRIM(Substr(cDesc,nPos,Len(cDesc))),40)+"^FS")
				MSCBWRITE("^BY2,4,180^FT260,535^BCN,,Y,N")   //"296"
				MSCBWRITE("^FD"+Trim((cTable)->B1_COD)+cSeq+"^FS")

				If mv_par07 == 1
					MSCBWRITE("^FT430,668^A0N,31,21^FH\^FDCNPJ: "+Transform(mv_par05,cPicture)+"^FS")
					MSCBWRITE("^FO79,646^GB340,0,30^FS")
				EndIf

				MSCBWRITE("^PQ"+"1"+",0,1,Y^XZ")  // ALLTRIM(str(MV_PAR06))
				MsCbEnd()
			Next

			(cTable)->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo

		MsCbClosePrinter()
	EndIf

	(cTable)->(dbCloseArea())

Return .T.

Static Function ValidPerg(cPerg)
	u_InPutSX1(cPerg,"01",PADR("Do Produto ",20)+"?","","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Ate Produto",20)+"?","","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Cliente    ",20)+"?","","","mv_ch3","C",06,0,0,"G","","SA1","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Loja       ",20)+"?","","","mv_ch4","C",02,0,0,"G","","   ","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("CNPJ       ",20)+"?","","","mv_ch5","C",14,0,0,"G","","   ","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Copias     ",20)+"?","","","mv_ch6","N",03,0,0,"G","","   ","","","mv_Par06")
	u_InPutSx1(cPerg,"07",PADR("Tarja      ",20)+"?","","","mv_ch7","N",01,0,0,"C","","   ","","","mv_par07","Sim","","","","Nao")
	u_InPutSX1(cPerg,"08",PADR("Filial     ",20)+"?","","","mv_ch8","C", 2,0,0,"G","","   ","","","mv_par08")
Return