#INCLUDE "rwmake.ch"
#DEFINE nColIni   0
#DEFINE nColFim 131
#DEFINE nColDiv 108 //96
#DEFINE nCol01    3
#DEFINE nCol02   32
#DEFINE nCol03   34
#DEFINE nCol04   44
#DEFINE nCol05   55
#DEFINE nCol06   67
#DEFINE nCol07   77
#DEFINE nCol08   87
#DEFINE nCol09   97
#DEFINE nCol10  110
#DEFINE nCol11  120
#DEFINE nCol12  124

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR03  ºAutor  ³Rogerio Oliveira         º Data ³  28/10/17º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Movimentacao de Estoque e Venda               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Queiroz Correa                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATR03()
	Local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2  := "de acordo com os parametros informados pelo usuario."
	Local cDesc3  := "RESUMO DIARIO DE VENDAS"
	Local cPict   := ""
	Local Titulo  := "MOVIMENTACAO DO ESTOQUE E VENDAS"
	Local nLin    := 80
	Local Cabec1  := "|                             |                        |    M O V I M E N T O   E M   E S T O Q U E        |MOVIMENTO DE VENDAS    |"
	Local Cabec2  := "| CODIGO                      | DESCRICAO              | SLD INI | QTD ENT  |QTD SAIDAS|QTD DEVOL|SLD FINAL|QTD DIA |QTD ACUM      |"
	Local imprime := .T.
	Local aOrd    := {}
	Local cPerg   := Padr("RFATR03",10)
	 
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 132
	Private tamanho     := "M"
	Private nomeprog    := "RFATR03"
	Private nTipo       := 15
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt       := Space(10)
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private wnrel       := "RFATR03"
	Private cString     := "SB1"
	
	AjustaSX1(cPerg)
	Pergunte(cPerg,.T.)   
	Titulo := Alltrim(Titulo)+ " DO DIA "+Dtoc(MV_PAR02)
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	Processa({||GeraTab()},"Gerando arquivo Temporario","Aguarde por favor..........")

	If MV_PAR05 == 1		
		RptStatus({|| PadReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Else
		Processa({|| GraReport(Titulo) },Titulo)
	EndIf	
  DbSelectArea("TMP")
  DbCloseArea("TMP")
	
Return


Static Function PadReport(Cabec1,Cabec2,Titulo,nLin)
  Local cGrupo
  Local cQualidade
  Local cDescGrupo 
  Local aTotGrupo  := {0,0,0,0,0,0,0,0}
  Local aTotQualid := {0,0,0,0,0,0,0,0}
  Local nSldIni    := 0
  Local nQtdEnt    := 0
  Local nQtdSai    := 0
  Local nQtdQueb   := 0
  Local nQtdDev    := 0
  Local nSldFim    := 0
  Local nVendDia   := 0
  Local nVendAcum  := 0
  dbSelectArea("TMP")
  SetRegua(RecCount())
  dbGoTop()   
  While !TMP->(EOF())
    If nLin > 70 //55 // Salto de Página. Neste caso o formulario tem 55 linhas...  
        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
    Endif
    aTotGrupo := {0,0,0,0,0,0,0,0}
    cGrupo := TMP->B1_CLCFAM            
    cDescGrupo := TMP->ZE_DESCRIC
    @ nLin,nColIni PSAY "|"+Padc(TMP->ZE_DESCRIC,130)+"|"
    nLin++
    @ nLin,nColIni PSAY "|"+Replicate("-",130)+"|"
    nLin++
    While cGrupo == TMP->B1_CLCFAM .And. !TMP->(EOF())
      aTotQualid := {0,0,0,0,0,0,0,0}
      //cQualidade := TMP->B1_QUALITY
    //  @ nLin,nColIni PSAY "|"+Padc("PRODUTOS TIPO "+IIf(cQualidade == "1","'A'","'B'"),130)+"|"
    //  nLin++
    //  @ nLin,nColIni PSAY "|"+Replicate("-",130)+"|"
    //  nLin++
//      While cGrupo == TMP->B1_GRUPO .And. cQualidade == TMP->B1_QUALITY .And. !TMP->(EOF()) 
      While cGrupo == TMP->B1_CLCFAM .And. !TMP->(EOF())
        IncRegua()
        If lAbortPrint
          @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
          Exit
        Endif
        If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas... 
          Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
          nLin := 9
        Endif
  	    nSldIni    := fSaldoIni(TMP->B1_COD,TMP->ESTINI,MV_PAR01,(MV_PAR02-1))
  	    nQtdEnt    := fEntradas(TMP->B1_COD,MV_PAR02,MV_PAR02,.T.,.F.)
  	    nQtdSai    := fSaidas(TMP->B1_COD,MV_PAR02,MV_PAR02,.F.,.F.)
  	    nQtdQueb   := fSaidas(TMP->B1_COD,MV_PAR02,MV_PAR02,.F.,.T.)
  	    nQtdDev    := fEntradas(TMP->B1_COD,MV_PAR02,MV_PAR02,.F.,.F.)
  	    nSldFim    := nSldIni+(nQtdEnt+nQtdDev)-(nQtdSai+nQtdQueb)
		nVendDia   := fSaidas(TMP->B1_COD,MV_PAR02,MV_PAR02,.T.,.F.) - fEntradas(TMP->B1_COD,MV_PAR02,MV_PAR02,.F.,.T.)
		nVendAcum  := fSaidas(TMP->B1_COD,(MV_PAR01+1),MV_PAR02,.T.,.F.) - fEntradas(TMP->B1_COD,(MV_PAR01+1),MV_PAR02,.F.,.T.)

        @ nLin,nColIni PSAY "|"

        @ nLin,nCol01  PSAY ALLTRIM(TMP->B1_COD)     
        @ nLin,nCol02  PSAY substr(TMP->B1_DESC,1,20)             
        @ nLin,nCol05  PSAY TRANSFORM(nSldIni, "@E 9,999,999")
        @ nLin,nCol06  PSAY TRANSFORM(nQtdEnt, "@E 9,999,999")
        @ nLin,nCol07  PSAY TRANSFORM(nQtdSai, "@E 9,999,999")
//        @ nLin,nCol06  PSAY TRANSFORM(nQtdQueb, "@E 9,999,999")
        @ nLin,nCol08  PSAY TRANSFORM(nQtdDev, "@E 9,999,999")
        @ nLin,nCol09  PSAY TRANSFORM(nSldFim,     "@E 9,999,999")
        @ nLin,nColDiv PSAY "|"
        @ nLin,nCol10  PSAY TRANSFORM(nVendDia,"@E 999,999")
        @ nLin,nCol11  PSAY TRANSFORM(nVendAcum,"@E 9999,999")
    //    @ nLin,nCol11  PSAY TRANSFORM(nVendDia/TMP->B1_CONV,     "@E 999,999")
    //    @ nLin,nCol12  PSAY TRANSFORM(nVendAcum/TMP->B1_CONV,     "@E 999,999") 
        @ nLin,nColFim PSAY "|"

        aTotQualid[1] += nQtdEnt
        aTotQualid[2] += nQtdSai
        aTotQualid[3] += nQtdQueb
        aTotQualid[4] += nQtdDev
        aTotQualid[5] += nVendDia
        aTotQualid[6] += nVendAcum
     //   aTotQualid[7] += nVendDia/TMP->B1_CONV
    //    aTotQualid[8] += nVendAcum/TMP->B1_CONV
        
        aTotGrupo[1] += nQtdEnt
        aTotGrupo[2] += nQtdSai
        aTotGrupo[3] += nQtdQueb
        aTotGrupo[4] += nQtdDev
        aTotGrupo[5] += nVendDia
        aTotGrupo[6] += nVendAcum
     //   aTotGrupo[7] += nVendDia/TMP->B1_CONV
     //   aTotGrupo[8] += nVendAcum/TMP->B1_CONV
        nLin++
        TMP->(DbSkip())
      End

    End
    nLin++
    @ nLin,nColIni PSAY "|"+Replicate("-",130)+"|"
    nLin++
    @ nLin,nColIni PSAY "|"
    @ nLin,nCol01  PSAY "T O T A L ( "+Alltrim(cDescGrupo)+" ) -->"
    @ nLin,nCol06  PSAY TRANSFORM(aTotGrupo[1],"@E 9,999,999")
    @ nLin,nCol07  PSAY TRANSFORM(aTotGrupo[2],"@E 9,999,999")
    @ nLin,nCol08  PSAY TRANSFORM(aTotGrupo[3],"@E 9,999,999")
   // @ nLin,nCol09  PSAY TRANSFORM(aTotGrupo[4],"@E 9,999,999")
    @ nLin,nColDiv PSAY "|"
    @ nLin,nCol10  PSAY TRANSFORM(aTotGrupo[5],"@E 999,999")
    @ nLin,nCol11  PSAY TRANSFORM(aTotGrupo[6],"@E 9999,999")                                              `
//    @ nLin,nCol11  PSAY TRANSFORM(aTotGrupo[7],"@E 999,999")
//    @ nLin,nCol12  PSAY TRANSFORM(aTotGrupo[8],"@E 999,999") 
    @ nLin,nColFim PSAY "|"
    nLin := 80
  End     
  SET DEVICE TO SCREEN
  If aReturn[5]==1
    dbCommitAll()
    SET PRINTER TO
    OurSpool(wnrel)
  Endif
  MS_FLUSH()
Return




Static Function GraReport(Titulo)
	Private nLin := 80
	Private lPag := .F. 
	Private nPag := 0
	Private oPrint
	Private oFont10n	:= TFont():New("Arial"		,9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	Private oFont10vn	:= TFont():New("Courier new",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	Private oFont12vn	:= TFont():New("Courier new",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	Private oFont14n	:= TFont():New("Arial"		,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	Private oFont16n	:= TFont():New("Arial"		,9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	Private oBrush		:= TBrush():New("",4)

	Private nCl01 := 10 			//Codigo
	Private nCl02 := nCl01+ 200  //Descricao
	Private nCl03 := nCl02+ 540  //Saldo Inicial
	Private nCl04 := nCl03+ 250  //Qtd Entrada
	Private nCl05 := nCl04+ 250  //Qtd Saida
	Private nCl06 := nCl05+ 250  //Qtd Quebrada
	Private nCl07 := nCl06+ 250  //Qtd Devolvida
	Private nCl08 := nCl07+ 250  //Saldo Final
	Private nCl09 := nCl08+ 250  //Qtd Dia
	Private nCl10 := nCl09+ 250  //Qtd Acumulada
	Private nCl11 := nCl10+ 250  //M2 Dia
	Private nCl12 := nCl11+ 250  //M2 Acumulada




	oPrint:= TMSPrinter():New(Titulo)
	oPrint:SetLandscape()
//	oPrint:SetPortrait() // ou SetLandscape()

	Processa({|| ImpRGraf(Titulo) },Titulo)

	oPrint:EndPage()     // Finaliza a página              
	oPrint:Preview()     // Visualiza antes de imprimir


Static Function ImpRGraf(Titulo)
	Local cGrupo
	Local cQualidade
	Local cDescGrupo 
	Local aTotGrupo  := {0,0,0,0,0,0,0,0}
	Local aTotQualid := {0,0,0,0,0,0,0,0}
	Local nSldIni    := 0
	Local nQtdEnt    := 0
	Local nQtdSai    := 0
	Local nQtdQueb   := 0
	Local nQtdDev    := 0
	Local nSldFim    := 0
	Local nVendDia   := 0
	Local nVendAcum  := 0

	dbSelectArea("TMP")

//	SetRegua(RecCount())
	dbGoTop()   
	While !TMP->(EOF())
		FCABECALHO(Titulo)
		If nLin > 3100 // Salto de Página. Neste caso o formulario tem 55 linhas...
			lPag := .T. 
			nPag ++
			FCABECALHO()
		Endif
		aTotGrupo := {0,0,0,0,0,0,0,0}
		cGrupo := TMP->B1_CLCFAM            
		cDesc := TMP->ZE_DESCRIC
		oPrint:Say  (nlin,nCl01,Padc(TMP->ZE_DESCRIC,280),oFont16n)
		nLin+=70

		While cGrupo == TMP->B1_CLCFAM .And. !TMP->(EOF())
			aTotQualid := {0,0,0,0,0,0,0,0}
//			cQualidade := TMP->B1_QUALITY
//			oPrint:Say  (nlin,nCl01,"PRODUTOS TIPO "+IIf(cQualidade == "1","'A'","'B'"),oFont14n)
			nLin+=50
			FLINHA(5)
			nLin+= 50

//			While cGrupo == TMP->B1_GRUPO .And. cQualidade == TMP->B1_QUALITY .And. !TMP->(EOF())
			While cGrupo == TMP->B1_CLCFAM .And. !TMP->(EOF())

//				IncRegua()
				If lAbortPrint
					oPrint:Say  (nlin,nCol03,"*** CANCELADO PELO OPERADOR ***",oFont16n)
					Exit
				Endif

				If nLin > 3100 // Salto de Página. Neste caso o formulario tem 55 linhas...
					lPag := .T. 
					nPag ++
					FCABECALHO()
				Endif
			

				nSldIni    := fSaldoIni(TMP->B1_COD,TMP->ESTINI,MV_PAR01,(MV_PAR02-1))
				nQtdEnt    := fEntradas(TMP->B1_COD,MV_PAR02,MV_PAR02,.T.,.F.)
				nQtdSai    := fSaidas(TMP->B1_COD,MV_PAR02,MV_PAR02,.F.,.F.)
				nQtdQueb   := fSaidas(TMP->B1_COD,MV_PAR02,MV_PAR02,.F.,.T.)
				nQtdDev    := fEntradas(TMP->B1_COD,MV_PAR02,MV_PAR02,.F.,.F.)
				nSldFim    := nSldIni+(nQtdEnt+nQtdDev)-(nQtdSai+nQtdQueb)
				nVendDia   := fSaidas(TMP->B1_COD,MV_PAR02,MV_PAR02,.T.,.F.) - fEntradas(TMP->B1_COD,MV_PAR02,MV_PAR02,.F.,.T.)
				nVendAcum  := fSaidas(TMP->B1_COD,(MV_PAR01+1),MV_PAR02,.T.,.F.) - fEntradas(TMP->B1_COD,(MV_PAR01+1),MV_PAR02,.F.,.T.)
				

				
				oPrint:Say  (nlin,nCl01,SUBSTR(TMP->B1_COD,1,07),oFont10vn)     
				oPrint:Say  (nlin,nCl02,substr(TMP->B1_DESC,1,20),oFont10vn)             
				FCOLUNA(nCl03,5)

				oPrint:Say  (nlin,nCl03,TRANSFORM(nSldIni, "@E 9,999,999"),oFont10vn)
				oPrint:Say  (nlin,nCl04,TRANSFORM(nQtdEnt, "@E 9,999,999"),oFont10vn)
				oPrint:Say  (nlin,nCl05,TRANSFORM(nQtdSai, "@E 9,999,999"),oFont10vn)
				oPrint:Say  (nlin,nCl06,TRANSFORM(nQtdQueb, "@E 9,999,999"),oFont10vn)
				oPrint:Say  (nlin,nCl07,TRANSFORM(nQtdDev, "@E 9,999,999"),oFont10vn)
				oPrint:Say  (nlin,nCl08,TRANSFORM(nSldFim,     "@E 9,999,999"),oFont10vn)

				FCOLUNA(nCl09,5)
				oPrint:Say  (nlin,nCl09,TRANSFORM(nVendDia,"@E 999,999"),oFont10vn)
				oPrint:Say  (nlin,nCl10,TRANSFORM(nVendAcum,"@E 9999,999"),oFont10vn)
	//			oPrint:Say  (nlin,nCl11,TRANSFORM(nVendDia/TMP->B1_CONV,"@E 999,999"),oFont10vn)
	//			oPrint:Say  (nlin,nCl12,TRANSFORM(nVendAcum/TMP->B1_CONV,"@E 999,999"),oFont10vn)
				nLin+= 50
				
				aTotQualid[1] += nQtdEnt
				aTotQualid[2] += nQtdSai
				aTotQualid[3] += nQtdQueb
				aTotQualid[4] += nQtdDev
				aTotQualid[5] += nVendDia
				aTotQualid[6] += nVendAcum
 //				aTotQualid[7] += nVendDia/TMP->B1_CONV
 //				aTotQualid[8] += nVendAcum/TMP->B1_CONV
				        
				aTotGrupo[1] += nQtdEnt
				aTotGrupo[2] += nQtdSai
				aTotGrupo[3] += nQtdQueb
				aTotGrupo[4] += nQtdDev
				aTotGrupo[5] += nVendDia
				aTotGrupo[6] += nVendAcum
  //				aTotGrupo[7] += nVendDia/TMP->B1_CONV
 //				aTotGrupo[8] += nVendAcum/TMP->B1_CONV
				nLin++
				TMP->(DbSkip())
			End
			FLINHA(5)
			nLin+=50
//			oPrint:Say  (nlin,nCl01,"PARCIAL PRODUTOS TIPO "+IIf(cQualidade == "1","'A'","'B'"),oFont10n)

			oPrint:Say  (nlin,nCl04-20,TRANSFORM(aTotQualid[1],"@E 9,999,999"),oFont12vn)
			oPrint:Say  (nlin,nCl05-20,TRANSFORM(aTotQualid[2],"@E 9,999,999"),oFont12vn)
			oPrint:Say  (nlin,nCl06-20,TRANSFORM(aTotQualid[3],"@E 9,999,999"),oFont12vn)
			oPrint:Say  (nlin,nCl07-20,TRANSFORM(aTotQualid[4],"@E 9,999,999"),oFont12vn)

			oPrint:Say  (nlin,nCl09-15,TRANSFORM(aTotQualid[5],"@E 999,999"),oFont12vn)
			oPrint:Say  (nlin,nCl10-10,TRANSFORM(aTotQualid[6],"@E 999,999"),oFont12vn)
			oPrint:Say  (nlin,nCl11-15,TRANSFORM(aTotQualid[7],"@E 999,999"),oFont12vn)
			oPrint:Say  (nlin,nCl12-15,TRANSFORM(aTotQualid[8],"@E 999,999"),oFont12vn)
			nLin+=100
		End

		oPrint:Say  (nlin,nCl01,"T O T A L ( "+Alltrim(cDescGrupo)+")",oFont14n)

		oPrint:Say  (nlin,nCl04-20,TRANSFORM(aTotGrupo[1],"@E 9,999,999"),oFont12vn)
		oPrint:Say  (nlin,nCl05-20,TRANSFORM(aTotGrupo[2],"@E 9,999,999"),oFont12vn)
		oPrint:Say  (nlin,nCl06-20,TRANSFORM(aTotGrupo[3],"@E 9,999,999"),oFont12vn)
		oPrint:Say  (nlin,nCl07-20,TRANSFORM(aTotGrupo[4],"@E 9,999,999"),oFont12vn)

		oPrint:Say  (nlin,nCl09-15,TRANSFORM(aTotGrupo[5],"@E 999,999"),oFont12vn)
		oPrint:Say  (nlin,nCl10-10,TRANSFORM(aTotGrupo[6],"@E 999,999"),oFont12vn)
		oPrint:Say  (nlin,nCl11-15,TRANSFORM(aTotGrupo[7],"@E 999,999"),oFont12vn)
		oPrint:Say  (nlin,nCl12-15,TRANSFORM(aTotGrupo[8],"@E 999,999") ,oFont12vn)
		lPag := .T. 
	End     
Return


Static Function FCABECALHO(Titulo)
	If lPag 
		oPrint:EndPage()     // Finaliza a página
	EndIf  
	oPrint:StartPage()   // Inicia uma nova página
	nPag++
	nLin := 20
	FLINHA(5)                           
	nLin+=50 
  //  oPrint:SayBitmap (nLin-10 ,050,getMV("MV_XLOGORE"),450 ,200 )
	oPrint:Say  (nlin,nCl03,Padc(titulo,70),oFont16n)
	oPrint:Say  (nlin,2990,Padl("Pag.: "+StrZero(nPag,3),12),oFont10n)
	nLin+=200
	FLINHA(5)
	nLin+=50
	FCOLUNA(nCl03,5)
	oPrint:Say (nlin-20,nCl03,Padc("MOVIMENTO EM ESTOQUE",80),oFont14n)
	FCOLUNA(nCl09,5)
	oPrint:Say (nlin-20,nCl09,Padc("MOVIMENTO DE VENDA",40),oFont14n)
	nLin+=50

	oPrint:Say (nlin,nCl01,"Código",oFont10n)
	oPrint:Say (nlin,nCl02,"Descrição",oFont10n)
	FCOLUNA(nCl03,5)

	oPrint:Say (nlin,nCl03,"Sld Inic",oFont10vn)
	oPrint:Say (nlin,nCl04,"Qtd Entr",oFont10vn)
	oPrint:Say (nlin,nCl05,"Qtd Saidas",oFont10vn)
	oPrint:Say (nlin,nCl06,"Qtd Quebr",oFont10vn)
	oPrint:Say (nlin,nCl07,"Qtd Devol",oFont10vn)
	oPrint:Say (nlin,nCl08,"Sld Final",oFont10vn)
	FCOLUNA(nCl09,5)
	oPrint:Say (nlin,nCl09,"Qtd Dia",oFont10vn)
	oPrint:Say (nlin,nCl10,"Qtd Acum",oFont10vn)
	oPrint:Say (nlin,nCl11,"M2 Dia",oFont10vn)
	oPrint:Say (nlin,nCl12,"M2 Acum",oFont10vn)
	nLin+=50
	FLINHA(5)

	nLin+=100
Return

Static Function FLINHA(nTam)
	For x := 1 to nTam
		oPrint:Line (nLin,10,nLin,3380);nLin++
	Next	
Return


Static Function FCOLUNA(nCol,nTam)
	For x := 1 to nTam
		oPrint:Line (nLin-50,nCol-20,nLin+50,nCol-20);nCol++
	Next	
Return


Static Function GeraTab()
  Local cQuery := ""
  Local dDataFech := GetMv("MV_ULMES")  
  nQuebra := alltrim(GetMv("MV_XQUEBRA"))   // codigo quebra 501
  nCodven := alltrim(GetMv("MV_XCODVEN"))   // codigo venda 511,611,711
  nDevolu := alltrim(GetMv("MV_XDEVOLU"))   //  codigo de devolucao     
  
  cQuery += " SELECT B1_CLCFAM,ZE_DESCRIC,B1_COD,B1_DESC,SUM(B9_QINI) ESTINI 
  cQuery += " FROM "+RetSQLName("SB1")+" SB1
  cQuery += " INNER JOIN "+RetSQLName("SZE")+" SZE ON B1_CLCFAM = ZE_CODIGO AND SZE.D_E_L_E_T_ <> '*' AND B1_FILIAL = '"+xFilial("SB1")+"'
  cQuery += " INNER JOIN "+RetSQLName("SB9")+" SB9 ON B9_COD = B1_COD AND SB9.D_E_L_E_T_ <> '*' AND B9_DATA = '"+dTos(MV_PAR01)+"' AND B9_FILIAL = '"+xFilial("SB9")+"'
  cQuery += " AND B9_LOCAL >= '"+MV_PAR03+"' AND B9_LOCAL <= '"+MV_PAR04+"' 
  cQuery += " WHERE B1_MSBLQL <> '1' AND B1_TIPO = 'PA' AND B1_CLSTATU = 'A' AND B1_COD >= '"+MV_PAR06+"' AND B1_COD <= '"+MV_PAR07+"' AND SB1.D_E_L_E_T_ <> '*'
  cQuery += " GROUP BY B1_CLCFAM,ZE_DESCRIC,B1_COD,B1_DESC 
  cQuery += " ORDER BY B1_CLCFAM,B1_COD
  dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"TMP",.F.,.T.)
Return

Static Function fSaidas(cProduto,dDtIni,dDtFim,lDuplic,lQuebra)
  Local nQuant := 0
  Local cQuery      

  If !lQuebra
    cQuery := " SELECT SUM(D2_QUANT) SAIDAS
    cQuery += " FROM "+RetSQLName("SD2")+" SD2
    cQuery += " INNER JOIN "+RetSQLName("SF4")+" SF4 ON D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S'
    If lDuplic
      cQuery += " AND F4_DUPLIC = 'S'
    EndIf
    cQuery += " WHERE D2_COD = '"+cProduto+"' AND SD2.D_E_L_E_T_ <> '*' AND D2_EMISSAO >= '"+dTos(dDtIni)+"' AND D2_EMISSAO <= '"+dTos(dDtFim)+"'
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"EST",.F.,.T.)
    nQuant += EST->SAIDAS                  
    DbCloseArea("EST")

    cQuery := " SELECT SUM(D3_QUANT) SAIDAS                  
    cQuery += " FROM "+RetSQLName("SD3")+" SD3
    cQuery += " WHERE D3_COD = '"+cProduto+"' AND SD3.D_E_L_E_T_ <> '*' AND D3_EMISSAO >= '"+dTos(dDtIni)+"' AND D3_EMISSAO <= '"+dTos(dDtFim)+"'
    If lDuplic
      cQuery += " AND D3_TM = '507'
    Else  
      cQuery += " AND D3_TM IN('507')
    EndIf                                         
    cQuery += " AND D3_ESTORNO <> 'S'
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"EST",.F.,.T.)
    nQuant += EST->SAIDAS                  
    DbCloseArea("EST")
  Else
    cQuery := " SELECT SUM(D3_QUANT) SAIDAS                  
    cQuery += " FROM "+RetSQLName("SD3")+" SD3
    cQuery += " WHERE D3_COD = '"+cProduto+"' AND SD3.D_E_L_E_T_ <> '*' AND D3_EMISSAO >= '"+dTos(dDtIni)+"' AND D3_EMISSAO <= '"+dTos(dDtFim)+"'
    cQuery += " AND D3_TM = '507' AND D3_ESTORNO <> 'S'
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"EST",.F.,.T.)
    nQuant += EST->SAIDAS                  
    DbCloseArea("EST")
  EndIf  


Return nQuant

Static Function fEntradas(cProduto,dDtIni,dDtFim,lProducao,lDuplic)
  Local nQuant
  Local cQuery
  cQuery := "" 
  If !lProducao
    cQuery += " SELECT SUM(D1_QUANT) ENTRADAS
    cQuery += " FROM "+RetSQLName("SD1")+" SD1
    cQuery += " INNER JOIN "+RetSQLName("SF4")+" SF4 ON D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S'
//    If lDuplic
//      cQuery += " AND F4_DUPLIC = 'S'
//    EndIf
    cQuery += " WHERE D1_COD = '"+cProduto+"' AND SD1.D_E_L_E_T_ <> '*' AND D1_DTDIGIT >= '"+dTos(dDtIni)+"' AND D1_DTDIGIT <= '"+dTos(dDtFim)+"'  AND D1_TIPO = 'D'
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"EST",.F.,.T.)
  Else
    cQuery += " SELECT SUM(D3_QUANT) ENTRADAS
    cQuery += " FROM "+RetSQLName("SD3")+" SD3
    cQuery += " WHERE D3_COD = '"+cProduto+"' AND SD3.D_E_L_E_T_ <> '*' AND D3_EMISSAO >= '"+dTos(dDtIni)+"' AND D3_EMISSAO <= '"+dTos(dDtFim)+"'
    cQuery += " AND D3_TM = '400' AND D3_ESTORNO <> 'S'
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"EST",.F.,.T.)
  EndIf  
  nQuant := EST->ENTRADAS
  DbCloseArea("EST")
Return nQuant				             

Static Function fSaldoIni(cProduto,nSldIni,dDtIni,dDtFim)
  Local nsaldo := nSldIni
  Local nSldIni    := 0
  Local nQtdEnt    := 0
  Local nQtdSai    := 0
  Local nQtdQueb   := 0
  Local nQtdDev    := 0
 
  nQtdEnt    := fEntradas(cProduto,(dDtIni+1),dDtFim,.T.,.F.)
  nQtdSai    := fSaidas(cProduto,(dDtIni+1),dDtFim,.F.,.F.)
  nQtdQueb   := fSaidas(cProduto,(dDtIni+1),dDtFim,.F.,.T.)
  nQtdDev    := fEntradas(cProduto,(dDtIni+1),dDtFim,.F.,.F.)
  nsaldo     += (nQtdEnt+nQtdDev)-(nQtdSai+nQtdQueb)
Return nSaldo


Static Function AjustaSX1(cPerg)
	PutSX1(cPerg,"01",PADR("Data Fechamento   ?",29),PADR("Data Fechamento   ?",29),PADR("Data Fechamento   ?",29),"mv_ch1","D",08,0,0,"G","","","","","mv_par01")
	PutSX1(cPerg,"02",PADR("Data do Relatorio ?",29),PADR("Data do Relatorio ?",29),PADR("Data do Relatorio ?",29),"mv_ch2","D",08,0,0,"G","","","","","mv_par02")
	PutSX1(cPerg,"03",PADR("Do almoxarife     ?",29),PADR("Do almoxarife     ?",29),PADR("Do almoxarife     ?",29),"mv_ch3","C",02,0,0,"G","","","","","mv_par03")
	PutSX1(cPerg,"04",PADR("Ate almoxarife    ?",29),PADR("Ate almoxarife    ?",29),PADR("Ate almoxarife    ?",29),"mv_ch4","C",02,0,0,"G","","","","","mv_par04")
	PutSx1(cPerg,"05",PADR("Tipo do Impressao ?",29),PADR("Tipo do Impressao ?",29),PADR("Tipo do Impressao ?",29),"mv_ch5","N",01,0,0,"C","","","","","mv_par05","Padrão","Padrão","Padrão","","Grafico","Grafico","Grafico")
	PutSx1(cPerg,"06",PADR("Produto de        ?",29),PADR("Produto de        ?",29),PADR("Produto de        ?",29),"mv_ch6","C",30,0,0,"G","","","","","mv_par06")
	PutSx1(cPerg,"07",PADR("Produto ate       ?",29),PADR("Produto ate       ?",29),PADR("Produto ate       ?",29),"mv_ch7","C",30,0,0,"G","","","","","mv_par07")

Return

