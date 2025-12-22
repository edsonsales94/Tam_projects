#INCLUDE "rwmake.ch"
#Include "Protheus.ch"
#include "AP5MAIL.ch"
#include "tbiconn.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.ch"



/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATR03   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 01/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatório de Ordem de Carregamento                         	¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Alterações:
22/01/2019 - Wladimir - Retiradas as linhas e acrescentado Localização/Lote
*/
User Function AAFATR03()
nQtdLin := AAGETQTD()
//nQtdLin := 1

Processa({|lEnd|MontaRel()})

Return Nil

*----------------------------------------------------------------------------------------------*
Static Function MontaRel()
*----------------------------------------------------------------------------------------------*
Local    oPrint  := Nil
Local cCondPagto := Posicione("SC5", 1, xFilial("SC5") + PA1->PA1_PEDIDO, "C5_CONDPAG")
Local cNomeCli   := Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE, "A1_NOME")
Local cDescriPgo := Posicione("SE4", 1, xFilial("SE4") + cCondPagto, "E4_DESCRI")
Local cNomeFil   := Posicione("SM0", 1, cEmpAnt + SC5->C5_FILIAL, "M0_NOME")
Private nTotal 	 := 0

//00000653 errado
//02000307 certo
Private  nTotReg := 0


//AAFATW02(SC9->C9_PEDIDO, cDescriPgo, SC9->C9_CLIENTE, cNomeCli, SC9->C9_FILIAL, cNomeFil)


fTabTemp()
If TEMP1->(EOF())
	MsgStop("Não há dados a serem  exibidos!")
	TEMP1->(dbCloseArea("TEMP1"))
	Return Nil
EndIf

cArq:=Alltrim("Carregamento"+Alltrim(PA1->PA1_NUM))
oPrint := FWMSPrinter():New(cArq,, .T., , .T., , , , , , .F., )
//oPrint:= FWMSPrinter():New( "Ordem de Carregamemto",,.T. )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()
oPrint:SetDevice(IMP_PDF)
oPrint:SetResolution(72)
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:SetMargin(0,0,0,0)
oPrint:cPathPDF := If(ExistDir("C:\TEMP\"),"C:\TEMP\",GetTempPath(.T.) )//"C:\TEMP\"//cPath
oPrint:lServer := .F.
oPrint:SetViewPDF(.T.)

Impress(oPrint)

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
Return nil


Static Function Impress(oPrint)
Private oFont7   := TFont():New("Arial"      ,9, 7,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont8   := TFont():New("Arial"      ,9, 8,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont8n  := TFont():New("Arial"      ,9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont9   := TFont():New("Arial"      ,9, 9,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)

Private oFont12c := TFont():New("Courier New",9,11,.T.,.F.,5,.T.,5,.T.,.F.)

Private oFont11  := TFont():New("Arial"      ,9,11,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont10  := TFont():New("Arial"      ,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont14  := TFont():New("Arial"      ,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont12  := TFont():New("Arial"      ,9,12,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont18  := TFont():New("Arial"      ,9,18,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont20  := TFont():New("Arial"      ,9,20,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont23  := TFont():New("Arial"      ,9,23,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont16n := TFont():New("Arial"      ,9,16,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont15  := TFont():New("Arial"      ,9,15,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont15n := TFont():New("Arial"      ,9,15,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont14n := TFont():New("Arial"      ,9,14,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont13n := TFont():New("Arial"      ,9,13,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont11n := TFont():New("Arial"      ,9,11,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont24  := TFont():New("Arial"      ,9,24,.T.,.T.,5,.T.,5,.T.,.F.)
Private nwFim    := 2300
Private nwIni    := 100
Private nCol_1   := 250
Private nDif1    := 050
Private nDif2    := 010
Private lwFim    := .F.
Private nTotPage := 0 //(1100 + (nDif1*(mv_par05+1)) + (25*mv_par05)) / 3400

If (nDif1*(nQtdLin+1)) + (25*nQtdLin)   > 2800
	MsgBox("Limite de Linhas Excedido!")
	Return Nil
EndIf

ProcRegua(nTotReg)


/*******************/
/* Itens (Produtos)*/
/*******************/

_cPedBlock := ""
nLin_Itens := 600//560// + nDif1
_ndNec := nTotReg*nDif1*(nQtdLin+1) + nDif2 * nTotReg
//nTotPage := Int( ( (Int( _ndNec / (3000 - 600) ) + 1) * 600 + _ndNec + 1250 ) / 3000) + 1
nTotPage   := Int((( 1250 + nTotReg*nDif1*(nQtdLin+1) + nDif2 * nTotReg  ) / 3000) + 1 )

_nPage  := 01
_xOPage := 00

//nEspaco := 100
nEspaco := 600
For _xd01 := 01 To nTotReg  
   
   if nEspaco + nDif1*(nQtdLin + 1) + nDif2 > 3000      
      nEspaco := 600
      _nPage++
   Else
      nEspaco += nDif1*(nQtdLin + 1) + nDif2 
   EndIf
Next

if nEspaco + 650 > 3000
   _nPage++
EndIf

nPag       := 1
/******************/
/* Cabeçalho      */
/******************/
SC5->(dbSetOrder(1))
SC5->(dbSeek( TEMP1->PA1_FILIAL + TEMP1->PA1_PEDIDO ))

fwCabec(oPrint, nPag)

While !TEMP1->(EOF())
    SC5->(dbSetOrder(1))
    SC5->(dbSeek( TEMP1->PA1_FILIAL + TEMP1->PA1_PEDIDO ))
    
	IncProc("Pedido: " + TEMP1->PA1_PEDIDO)
	
	fwItens(oPrint, nLin_Itens)
	nLin_Itens += (nDif1*(nQtdLin+1)) + 25
	
	/**********************/
	/* Impressão do Rodapé*/
	/**********************/
	If nLin_Itens > 3000
	    //oPrint:SayAlign(3300,001,DTOC(Date()) +'-' + Time() ,)
	    oPrint:Say(3000,100,PA1->PA1_USER,oFont8n,nWfim,,,1)
	    oPrint:SayAlign(3000,000,DTOC(Date()) +'-'+Time(),oFont8n,nWfim,,,1)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()
		nLin_Itens := 600//600 + nDif1// 600 + nDif1
		nPag++
		fwCabec(oPrint, nPag)
	EndIf
	
	
	TEMP1->(dbSkip())
EndDo

nLin_Itens += 25
If nLin_Itens + 650 > 3000
	oPrint:Say(3000,100,PA1->PA1_USER,oFont8n,nWfim,,,1)
	oPrint:SayAlign(3000,000,DTOC(Date()) +'-'+Time(),oFont8n,nWfim,,,1)
	oPrint:EndPage()     // Finaliza a página
	oPrint:StartPage()
	nLin_Itens := 600//560 //+ nDif1 //600 + nDif1
	nPag++
	fwCabec(oPrint, nPag)		
EndIf 

fwRodape(oPrint, nLin_Itens,SC5->C5_NUM )
oPrint:Say(3000,100,PA1->PA1_USER,oFont8n,nWfim,,,1)
oPrint:SayAlign(3000,000,DTOC(Date()) +'-'+Time(),oFont8n,nWfim,,,1)
oPrint:EndPage()     // Finaliza a página

TEMP1->(dbCloseArea())

Return Nil

*----------------------------------------------------------------------------------------------*
Static Function fwCabec(oPrint, nPag)
*----------------------------------------------------------------------------------------------*
Local cLogo  := GetSrvProfString("StartPath","") + "LGMID1.PNG" //Logo da Amazon Aço
Local nTam1  := 400
Local aText1 := {"Código", "Revisão", "Data", "Pag."}
Local aText2 := {"SGQ-FOR-LOG-06", "00", "02/03/2017", AllTrim(Str(nPag))+"/"+AllTrim(Str(nTotPage)) }
Local nRow1  := 100

oPrint:Box(nRow1, nwIni      , nRow1+0380 , nWfim)  //Imprime o Box Superior
oPrint:Box(nRow1, nwIni      , nRow1+0200 , nWfim)  //Imprime o Box Superior
If File(cLogo)
	oPrint:SayBitmap(110, 110 , cLogo, 470, 160)
Endif

For nw := 1 to 4
	oPrint:Box(nRow1+(nDif1* (nw-1))   , nWfim -nTam1 , nRow1+(nDif1*nw) , nWfim + 5)	
	oPrint:Say(nRow1+(nDif1* (nw-1))+25, nWfim -nTam1 + 10, aText1[nW], oFont8 )
	oPrint:Say(nRow1+(nDif1* (nw-1))+25, nWfim - 227      , aText2[nW], oFont8n)
	
Next nw

oPrint:Say  (nRow1+0120,700 ,"ORDEM DE CARREGAMENTO - "+AllTrim(PA1->PA1_NUM),oFont20,,,,2 )

SA1->(dbSetOrder(1))
SA1->(dbSeek( xFilial("SA1") + SC5->C5_CLIENTE+SC5->C5_LOJACLI ))
SA3->(dbSetOrder(1))
SA3->(dbSeek( XFILIAL("SA3")+SC5->C5_VEND1 ))
SE4->(dbSetOrder(1))
SE4->(dbSeek( XFILIAL("SE4")+SC5->C5_CONDPAG ))

oPrint:Say (nRow1+0250,0120,"COD CLIENTE: "+ SA1->A1_COD + SPACE(1) + SA1->A1_LOJA ,oFont12 )
oPrint:Say  (nRow1+0250,1000,"VENDEDOR: " + ALLTRIM(SA3->A3_NREDUZ), oFont12 )

oPrint:Say  (nRow1+0300,0120,ALLTRIM(SA1->A1_NOME),oFont12 )
oPrint:Say  (nRow1+0300,1000,"PEDIDO: "+ SC5->C5_NUM,oFont12 )
//oPrint:Code128(nRow1 + 300,1900,Alltrim(PA1->PA1_NUM), 25 )
//MSBAR3("CODE128",2.9,14.6,Alltrim(PA1->PA1_NUM),oPrint,.F.,Nil,Nil,0.035,0.7,.F.,Nil,"A",.F.,100,100)
oPrint:FWMSBAR("CODE128",7.5/*nRow*/,40/*nCol*/,AllTrim(PA1->PA1_NUM),oPrint,,,, 0.049,1.0,,,,.F.,,,)
oPrint:Say  (nRow1+0350,0120,SA1->A1_MUN + SPACE(2) + SA1->A1_EST,oFont12 )
oPrint:Say  (nRow1+0350,1000,ALLTRIM(SE4->E4_DESCRI),oFont12 )

oPrint:Box(nRow1+380, nwIni      , nRow1+440 , nWfim)  //Imprime o Box Superior
oPrint:Say  (nRow1+0420,120,"Ordem",oFont11N )
oPrint:Say  (nRow1+0420,250,"Pedido",oFont11N )
oPrint:Say  (nRow1+0420,420,"Material",oFont11N )
oPrint:Say  (nRow1+0420,570,"Descrição",oFont11N )
oPrint:Say  (nRow1+0420,1500,"Lote",oFont11N )
oPrint:Say  (nRow1+0420,1750,"Localiza",oFont11N )
//oPrint:Say  (nRow1+0420,1720,"Qtd",oFont11N )
oPrint:Say  (nRow1+0420,2050,"Total",oFont11N )

Return 580

*----------------------------------------------------------------------------------------------*
Static Function fwItens(oPrint, nwRow )
*----------------------------------------------------------------------------------------------*

While !TEMP1->(EOF())

	If nwRow + nDif1*(nQtdLin + 1) + nDif2 > 3000
		oPrint:Say(3000,100,PA1->PA1_USER,oFont8n,nWfim,,,1)
		oPrint:SayAlign(3000,000,DTOC(Date()) +'-'+Time(),oFont8n,nWfim,,,1)
	    oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()
		nwRow := 600//560 + nDif1//600 + nDif1
		nPag++
		fwCabec(oPrint, nPag)
	EndIf
	
	
	oPrint:Say  (nwRow + 00,120 ,TEMP1->PA1_NUM,oFont11N )
	oPrint:Say  (nwRow + 00,270 ,TEMP1->PA1_PEDIDO,oFont11N )
	oPrint:Say  (nwRow + 00,420 ,TEMP1->PA2_COD,oFont11N )
	oPrint:Say  (nwRow + 00,570 ,Alltrim(TEMP1->B1_ESPECIF),oFont11N )
	oPrint:Say  (nwRow + 00,1550 ,TEMP1->CB9_LOTECT,oFont11N )
	oPrint:Say  (nwRow + 00,1750 ,TEMP1->CB9_LCALIZ,oFont11N )
//	oPrint:Say  (nwRow + 00,800,,oFont11N )
//	oPrint:Say  (nwRow + 00,1720,Alltrim(Transform(TEMP1->PA2_QUANT,PesqPict("PA2","PA2_QUANT"))),oFont11N )
	oPrint:Say  (nwRow + 00,2050,Alltrim(Transform(TEMP1->cTOTAL,"@E 999,999,999.99")),oFont11N )
//	oPrint:Say  (nwRow + 00,nWfim-170,"Total",oFont11N )
	
	nwRow += nDif2
	For nw := 0 to nQtdLin - 1
		oPrint:Box(nwRow+(nDif1*nw)   , nwIni, nwRow+(nDif1* (nw+1) ) , nWfim )
	Next nw
	
	For nw := 1 to 8
		oPrint:Line (nwRow + nDif1*0, nwIni + (nCol_1 * nw), nwRow+(nDif1*(nQtdLin )), nwIni + (nCol_1 * nw) )
	Next nw
	
	//nwRow += 30     //
	nwRow += nDif1*(nQtdLin + 1)//+ 100
	nTotal += TEMP1->cTOTAL
	TEMP1->(dbSkip())
Enddo

nLin_Itens := nwRow 

/*
For nw := 1 to nQtdLin
	oPrint:Box(nwRow+(nDif1*nw)   , nwIni+nCol_1 , nwRow+(nDif1* (nw+1) ) , nWfim - nCol_1)
Next nw

For nw := 2 to 7
	oPrint:Line (nwRow + nDif1, nwIni + (nCol_1 * nw), nwRow+(nDif1*(nQtdLin+1)), nwIni + (nCol_1 * nw) )
Next nw
*/

Return Nil

*----------------------------------------------------------------------------------------------*
Static Function fwRodape(oPrint, nwRow )
*----------------------------------------------------------------------------------------------*

//oPrint:Box(nwRow, nwIni , nwRow + nDif1 , )

oPrint:Box(nwRow, nwIni      , nwRow+360 , nwIni + 1000)  //Imprime o Box Superior
oPrint:Box(nwRow, nwIni + 1000, nwRow+360 , nwFim       )  //Imprime o Box Superior
//oPrint:Box(nwRow, nwFim - 750, nwRow+270 , nwFim - 500 )  //Imprime o Box Superior

oPrint:Say(nwRow + 045, nwIni + 010 ,"TRANSP.",oFont14)
oPrint:Line(nwRow + 045, nwIni + 140 ,nwRow + 045,nwIni + 1000)

oPrint:Say (nwRow + 090, nwIni + 010 ,"PLACA  ",oFont14)
oPrint:Line(nwRow + 090, nwIni + 140 ,nwRow + 090,nwIni + 1000)

oPrint:Say  (nwRow + 135, nwIni + 010 ,"DATA  ",oFont14)
oPrint:Line(nwRow + 135, nwIni + 140 ,nwRow + 135,nwIni + 1000)

oPrint:Say  (nwRow + 180, nwIni + 010 ,"CONF I ",oFont14)
oPrint:Line(nwRow + 180, nwIni + 140 ,nwRow + 180,nwIni + 1000)

oPrint:Say  (nwRow + 225, nwIni + 010 ,"CONF II",oFont14)
oPrint:Line(nwRow + 225, nwIni + 140 ,nwRow + 225,nwIni + 1000)

oPrint:Say  (nwRow + 270, nwIni + 010 ,"LIDER  ",oFont14)
oPrint:Line(nwRow + 270, nwIni + 140 ,nwRow + 270,nwIni + 1000)

oPrint:Say  (nwRow + 315, nwIni + 010 ,"HORA INICIAL: _____:______",oFont14)
oPrint:Say  (nwRow + 350, nwIni + 010 ,"HORA FINAL:   _____:______",oFont14)

//oPrint:Line(nwRow + 315, nwIni + 140 ,nwRow + 315,nwIni + 1000)
//oPrint:Line(nwRow + 270, nwIni + 140 ,nwRow + 270,nwIni + 1000)


//oPrint:Say  (nwRow + 70, nwFim - 740,"PESO TOTAL:",oFont10  )  // [1]Numero do Banco

oPrint:Say (nwRow + 045, nwIni + 1010 ,"TOTAL ORDEM:",oFont14)
//oPrint:Say (nwRow + 045, nWfim-230 ,Transform(nTotal,PesqPict("PA2","PA2_QUANT")),oFont14)
oPrint:Say (nwRow + 045, nWfim-230 ,Transform(nTotal,"@E 999,999,999.99"),oFont14)

oPrint:Say (nwRow + 090, nwIni + 1010 ,"TOTAL EMBARCADO  ",oFont14)
oPrint:Line(nwRow + 090, nwIni + 1270,nwRow + 090,nwFim )

oPrint:Say (nwRow + 135, nwIni + 1010 ,"QTD. AMARRADOS",oFont14)
oPrint:Line(nwRow + 135, nwIni + 1270,nwRow + 135,nwFim )

oPrint:Say (nwRow + 180, nwIni + 1010 ,"DESTINO",oFont14)
oPrint:Line(nwRow + 180, nwIni + 1270,nwRow + 180,nwFim )

oPrint:Say (nwRow + 225, nwIni + 1010 ,"PESO BALANÇA",oFont14)
oPrint:Line(nwRow + 225, nwIni + 1270,nwRow + 225,nwFim )

oPrint:Say (nwRow + 265, nwIni + 1010 ,"QTD. ENTREGAS",oFont14)
oPrint:Say (nwRow + 265, nwIni + 1600 ,"QTD. PALLET"  ,oFont14)
oPrint:Line(nwRow + 265, nwIni + 1270 ,nwRow + 265,nwIni + 1575)
oPrint:Line(nwRow + 265, nwIni + 1750 ,nwRow + 265,nwFim)

oPrint:Say (nwRow + 315, nwIni + 1010 ,"QTD RIPAS",oFont14)
oPrint:Say (nwRow + 315, nwIni + 1600 ,"QTD FITAS",oFont14)
oPrint:Line(nwRow + 315, nwIni + 1270 ,nwRow + 315,nwIni + 1575)
oPrint:Line(nwRow + 315, nwIni + 1750 ,nwRow + 315,nwFim)

//oPrint:Line(nwRow + 270, nwIni + 1270,nwRow + 270,nwFim )

/*
oPrint:Say  (nwRow + 135, nwIni + 010 ,"DATA  ",oFont12)
oPrint:Line(nwRow + 135, nwIni + 140 ,nwRow + 135,nwIni + 1000)
//oPrint:Box(nwRow + 090, nwIni + 140,nwRow + 135,nwIni + 1000)
oPrint:Say  (nwRow + 180, nwIni + 010 ,"CONF I ",oFont12)
oPrint:Line(nwRow + 180, nwIni + 140 ,nwRow + 180,nwIni + 1000)
//oPrint:Box(nwRow + 135, nwIni + 140,nwRow + 180,nwIni + 1000)
oPrint:Say  (nwRow + 225, nwIni + 010 ,"CONF II",oFont12)
oPrint:Line(nwRow + 225, nwIni + 140 ,nwRow + 225,nwIni + 1000)
//oPrint:Box(nwRow + 180, nwIni + 140,nwRow + 225,nwIni + 1000)
oPrint:Say  (nwRow + 265, nwIni + 010 ,"LIDER  ",oFont12)
oPrint:Line(nwRow + 270, nwIni + 140 ,nwRow + 270,nwIni + 1000)
*/

nwRow += 150
//  oPrint:Say  (nwRow + 225, 100,"INFORM. ADICIONAIS:",oFont14 )  // [1]Numero do Banco

/*  oPrint:Line (nwRow + 275, 600,nwRow + 275,2300)
oPrint:Line (nwRow + 350, 100,nwRow + 350,2300)
oPrint:Line (nwRow + 425, 100,nwRow + 425,2300)
oPrint:Line (nwRow + 500, 100,nwRow + 500,2300) */

//oPrint:Say  (nwRow + 225,1350,"CONFERÊNCIA FINAL:______________________",oFont12c )  // [1]Numero do Banco

oPrint:Say  (nwRow + 300, 100,"INFORM. ADICIONAIS:",oFont14 )  // [1]Numero do Banco
oPrint:Line (nwRow + 300, 550,nwRow + 300,2300)
oPrint:Line (nwRow + 350, 100,nwRow + 350,2300)
oPrint:Line (nwRow + 400, 100,nwRow + 400,2300)
//oPrint:Line (nwRow + 500, 100,nwRow + 500,2300)
oPrint:Say  (nwRow + 470, 100,"OBS. PEDIDO:",oFont12 )
oPrint:Say  (nwRow + 520, 100,Alltrim(SC5->C5_OBSENT1)+Alltrim(SC5->C5_OBSENT2),oFont12 )
oPrint:Say  (nwRow + 570, 100,"OBS. EXPEDIÇÃO:",oFont12 )
oPrint:Say  (nwRow + 620, 100,Alltrim(PA1->PA1_OBS),oFont12 )


//oPrint:Say  (nwRow + 675,100,"ORDEM DE SEPARAÇÃO:",oFont14 )
//oPrint:Code128C(nwRow + 1000,100,Alltrim(Posicione("CB7",2,xFilial("CB7")+cPedido,"CB7_ORDSEP")), 70 )

Return Nil


*----------------------------------------------------------------------------------------------*
Static Function fTabTemp()
*----------------------------------------------------------------------------------------------*
Local cQuery := ""
/*
cQuery+=" SELECT * FROM "+RetSQLName("PA1")+" (NOLOCK) PA1 "
cQuery+=" INNER JOIN "+RetSQLName("PA2")+" (NOLOCK) PA2 "
cQuery+=" ON PA2.D_E_L_E_T_='' "
cQuery+=" AND PA2.PA2_FILIAL=PA1.PA1_FILIAL "
cQuery+=" AND PA2.PA2_NUM=PA1.PA1_NUM "
cQuery+=" INNER JOIN "+RetSQLName("SC6")+" (NOLOCK) SC6 "
cQuery+=" ON SC6.D_E_L_E_T_='' "
cQuery+=" AND SC6.C6_FILIAL=PA1.PA1_FILIAL "
cQuery+=" AND SC6.C6_NUM=PA1.PA1_PEDIDO "
cQuery+=" AND SC6.C6_PRODUTO=PA2.PA2_COD "
cQuery+=" AND SC6.C6_ITEM=PA2.PA2_ITEMPD "
cQuery+=" INNER JOIN "+RetSQLName("SB1")+" (NOLOCK) SB1 "
cQuery+=" ON SB1.D_E_L_E_T_='' "
cQuery+=" AND SB1.B1_COD=SC6.C6_PRODUTO "
CqUERY+=" LEFT JOIN CB9010 (NOLOCK) CB9  ON CB9.D_E_L_E_T_=''  AND CB9.CB9_CODSEP = PA1.PA1_NUM"
cQuery+=" WHERE PA1.D_E_L_E_T_='' "
cQuery+=" AND PA1.PA1_NUM='"+PA1->PA1_NUM+"' "
cQuery+=" ORDER BY PA2_ITEM "
*/

cQuery+=" SELECT PA1_FILIAL,PA1_NUM,PA1_PEDIDO, PA2_COD, B1_ESPECIF, PA2_XLOTE CB9_LOTECT, PA2_XLOCAL CB9_LCALIZ,SUM(PA2_QUANT) cTOTAL "
cQuery+=" FROM "+RetSQLName("PA1")+" (NOLOCK) PA1  " 
cQuery+=" INNER JOIN "+RetSQLName("PA2")+" (NOLOCK) PA2  ON PA2.D_E_L_E_T_=''  AND PA2.PA2_FILIAL=PA1.PA1_FILIAL "   
cQuery+=" AND PA2.PA2_NUM=PA1.PA1_NUM "   
cQuery+=" INNER JOIN "+RetSQLName("SB1")+" (NOLOCK) SB1  ON SB1.D_E_L_E_T_=''  AND SB1.B1_COD=PA2_COD
//cQuery+=" INNER JOIN "+RetSQLName("CB9")+" (NOLOCK) CB9  ON CB9.D_E_L_E_T_=''  AND CB9.CB9_ORDSEP = PA1.PA1_NUM AND CB9.CB9_PROD = PA2.PA2_COD  "
cQuery+=" WHERE PA1.D_E_L_E_T_=''  AND PA1.PA1_NUM='"+PA1->PA1_NUM+"' "
cQuery+=" GROUP BY PA1_FILIAL,PA1_NUM,PA1_PEDIDO, PA2_COD, B1_ESPECIF,PA2_XLOTE,PA2_XLOCAL
cQuery+=" ORDER BY PA2_COD,PA2_XLOTE,PA2_XLOCAL

//PA2_XDTVAL

/*
SELECT PA1_FILIAL,PA1_NUM,PA1_PEDIDO, PA2_COD, B1_ESPECIF,CB9_LOTECT,CB9_LCALIZ,SUM(CB9_QTESEP) cTOTAL 
FROM PA1010 (NOLOCK) PA1  
INNER JOIN PA2010 (NOLOCK) PA2  ON PA2.D_E_L_E_T_=''  AND PA2.PA2_FILIAL=PA1.PA1_FILIAL  AND PA2.PA2_NUM=PA1.PA1_NUM  
INNER JOIN SB1010 (NOLOCK) SB1  ON SB1.D_E_L_E_T_=''  AND SB1.B1_COD=PA2_COD
INNER JOIN CB9010 (NOLOCK) CB9  ON CB9.D_E_L_E_T_=''  AND CB9.CB9_ORDSEP = PA1.PA1_NUM AND CB9.CB9_PROD = PA2.PA2_COD
WHERE PA1.D_E_L_E_T_=''  AND PA1.PA1_NUM='010598'  
GROUP BY PA1_FILIAL,PA1_NUM,PA1_PEDIDO, PA2_COD, B1_ESPECIF,CB9_LOTECT,CB9_LCALIZ
ORDER BY PA2_COD,CB9_LOTECT,CB9_LCALIZ
*/

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TEMP1", .T., .F. )
MemoWrite("AAFATR03B.sql",cQuery)

Return Nil

Static Function AAGETQTD()

Local nQuant  := -1

Define Font oFnt3 Name "Ms Sans Serif" Bold

while nQuant < 0
	nQuant := 1
	DEFINE MSDIALOG oDialog TITLE "Parametro" FROM 190,110 TO 300,370 PIXEL
	@ 005,004 SAY "Num. Linhas? :" SIZE 220,10 OF oDialog PIXEL Font oFnt3
	@ 005,050 GET nQuant         SIZE 50,10  PICTURE "@E 999,999.99" Pixel of oDialog
	
	@ 035,042 BMPBUTTON TYPE 1 ACTION( nRet := IIF(nQuant >= 0,oDialog:End(), NIL) )
	
	ACTIVATE DIALOG oDialog CENTERED
Enddo

Return nQuant

/*__________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+----------------------+-------------+---------------+¦
¦¦¦ Programa  ¦ AAFATW02 | Autor Nelio Castro Jorio| Data 22/03/13  ¦
¦¦+-----------+----------------------+-------------+---------------+¦
¦¦¦ Descrição:| Envia email com a Ordem de Carregamento             ¦
¦¦+------------+----------------------+-------------+---------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
/*User Function AAFATW02(cPedido, cCondPgto, cCodCli, cwNomeCli, cFilial_, cNomeFil)
Local cHtml       := ""
Local cAccount    := ""
Local cServer     := ""
Local cPass       := ""
Local cAssunto    := "Ordem de Carregamento - " + cwNomeCli
Local nSaldo      := 0
Local cCliLj      := ""
Local nSalPto     := 0
Local nYPTOTAL    := 0
Local aArea       := GetArea()
Local cEmail      := Alltrim(GetMv('MV_XMAIORD',.F.,"francisco@amazonaco.com.br")) // .: criar parametro para Envio dos emails
Private cHoraLimit := AllTrim(GetMv('MV_XHRLIMT',.F.,"16:30:00")) // .: criar parametro para Hora limite para atendimento da Ordem de Producao
Private cHoraEnvio := Time()
Private lHoraLimit  := cHoraEnvio > cHoraLimit

cHtml += Xcabec(cPedido, cCondPgto, cCodCli, cwNomeCli, cFilial_, cNomeFil)

cAccount   := GetMv('MV_RELACNT')// Conta de Envio de Relatorios por e-mail do acr//
cServer    := GetMv('MV_RELSERV')// IP do Servidor de e-mails //'smtp.microsiga.com.br'//
cPass      := GetMv('MV_RELPSW') // Senha da Conta de e-mail


LjMsgRun('* Conectando com o servidor SMTP: ' + cServer)
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult

If lResult
ljMsgRun('Enviando email para o Financeiro'+Chr(13)+StrTran(cEmail,',',Chr(13)),'Aguarde...')	//ljMsgRun('Enviando email para o Financeiro'+Chr(13)+StrTran(cEmail,',',Chr(13)),'Aguarde...')
SEND MAIL FROM cAccount  TO cEmail SUBJECT cAssunto BODY cHtml

//avisar horario limite de atendimento
If lHoraLimit
Alert("A Ordem se Carregamento será atendida no próximo dia útil. A hora limite para atendimento é " + cHoraLimit + ".")
EndIf

DISCONNECT SMTP SERVER
ELSE
GET MAIL ERROR CERROR
EndIf

RestArea(aArea)

Return .T.
*/
/*__________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+----------------------+-------------+---------------+¦
¦¦¦ Programa  ¦ AAFATW02 | Autor Nelio Castro Jorio| Data 22/03/13  ¦
¦¦+-----------+----------------------+-------------+---------------+¦
¦¦¦ Descrição:| Envia email com a Ordem de Carregamento             ¦
¦¦+------------+----------------------+-------------+---------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
/*Static Function AAFATW02(cPedido, cCondPgto, cCodCli, cwNomeCli, cFilial_, cNomeFil)
Local cHtml       := ""
Local cAccount    := ""
Local cServer     := ""
Local cPass       := ""
Local cAssunto    := "Ordem de Carregamento - " + cwNomeCli
Local nSaldo      := 0
Local cCliLj      := ""
Local nSalPto     := 0
Local nYPTOTAL    := 0
Local aArea       := GetArea()
Local cEmail      := Alltrim(GetMv('MV_XMAIORD',.F.,"francisco@amazonaco.com.br")) // .: criar parametro para Envio dos emails
Private cHoraLimit := AllTrim(GetMv('MV_XHRLIMT',.F.,"16:30:00")) // .: criar parametro para Hora limite para atendimento da Ordem de Producao
Private cHoraEnvio := Time()
Private lHoraLimit  := cHoraEnvio > cHoraLimit

cHtml += Xcabec(cPedido, cCondPgto, cCodCli, cwNomeCli, cFilial_, cNomeFil)

cAccount   := GetMv('MV_RELACNT')// Conta de Envio de Relatorios por e-mail do acr//
cServer    := GetMv('MV_RELSERV')// IP do Servidor de e-mails //'smtp.microsiga.com.br'//
cPass      := GetMv('MV_RELPSW') // Senha da Conta de e-mail


LjMsgRun('* Conectando com o servidor SMTP: ' + cServer)
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult

If lResult
ljMsgRun('Enviando email para o Financeiro'+Chr(13)+StrTran(cEmail,',',Chr(13)),'Aguarde...')	//ljMsgRun('Enviando email para o Financeiro'+Chr(13)+StrTran(cEmail,',',Chr(13)),'Aguarde...')
SEND MAIL FROM cAccount  TO cEmail SUBJECT cAssunto BODY cHtml

//avisar horario limite de atendimento
If lHoraLimit
Alert("A Ordem se Carregamento será atendida no próximo dia útil. A hora limite para atendimento é " + cHoraLimit + ".")
EndIf

DISCONNECT SMTP SERVER
ELSE
GET MAIL ERROR CERROR
EndIf

RestArea(aArea)

Return .T.
*/


Static Function Xcabec(cPedido, cCondPgto, cCodCli, cwNomeCli, cFilial_, cNomeFil)

Local cHtml       := ""
Local cLimitad    := CHR(13) + CHR(10)

cHtml :=  '<table style="width:680px; font-family:Verdana, Arial, Helvetica, sans-serif; color:#343434; font-size:13px; text-align:justify;"  width="100%" border="0" cellspacing="6" cellpadding="6">'
cHtml +=  '  <tr >'
cHtml +=  '    	<td width="407"  valign="middle">'
cHtml +=  '   Senhores(as), <u> </u></td>'
cHtml +=  '</td>'
cHtml +=  '</tr>'
cHtml +=  '<tr>'
cHtml +=  '<td colspan="2" height="30">&nbsp;'
cHtml +=  '</td>'
cHtml +=  '</tr>'
cHtml +=  '<tr>'
cHtml +=  '<td colspan="2">'
cHtml +=  '<p> Foi gerada a Ordem de Carregamento: <br />'
cHtml +=  '<p> Pedido: ('+cPedido+'). <br />'
cHtml +=  '<p> Cód-Cliente: '+cCodCli+'-'+cwNomeCli+' <br />'
cHtml +=  '<p> Condição de Pagamento: '+cCondPgto+' <br />'
cHtml +=  '<p> Filial de Origem: '+cFilial_+'-'+cNomeFil+' <br />'

If lHoraLimit
	cHtml +=  '<br /><p> <strong> Atender no próximo dia útil.</strong> <br />'
	cHtml +=  '<br /><p> <strong> Enviado as '+cHoraEnvio+'.</strong> <br />'
EndIf
cHtml +=  '</td>'
cHtml +=  '</tr>'
cHtml +=  '<br/>'

cHtml +=  '<table cellpadding="2" style="font-family:Verdana, Arial, Helvetica, sans-serif; color:#343434; font-size:12px; text-align:justify;" width="100%">'

Return cHtml





/*----------------------------------------------------------------------------------||
||       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||      AAAA       LL         LL         EE         CC        KK    KK   SS         ||
||     AA  AA      LL         LL         EE        CC         KK  KK     SS         ||
||    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   ||
||   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  ||
||  AA        AA   LL         LL         EE         CC        KK    KK          SS  ||
|| AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||----------------------------------------------------------------------------------*/
