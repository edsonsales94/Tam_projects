#include "rwmake.ch"
#include "font.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AACOMR01   ¦ Autor ¦ Jean Vicente         ¦ Data ¦   /  /2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Impressão do pedido de compra                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function AACOMR01()
Local nLinhaItem
Local nLinVer    := 0
Local cPedido    := SC7->C7_NUM
Local cObs       := ""
Local nTotalz    := 0
Local aArea      := SC7->(GetArea())
Local nMemoWidth := 370
Local nTxtHeigth := 0
Local nMemoLine  := 0
Private cPerg    := PadR("AACOMR01",Len(SX1->X1_GRUPO))
Private oPrn     := TMSPrinter():New( "Relatório Gráfico" )
Private cMemo    := ""
Private ntrans   := ""


SC7->(dbGoTop())
SC7->(dbSetOrder(1))
SC7->(dbSeek(xFilial('SC7')+cPedido))

If SC7->C7_CONAPRO = 'B'
   AVISO('PEDIDO','O PEDIDO DE COMPRAS ENCONTRA-SE BLOQUEADO SENDO IMPOSSIBILATADA A IMPRESSAO DO MESMO',{'OK'})
   Return
EndIf

DEFINE FONT oFont09n NAME "Arial"   SIZE 0,09 Bold OF oPrn
DEFINE FONT oFont09  NAME "Arial"   SIZE 0,09      OF oPrn
DEFINE FONT oFont10n NAME "Arial"   SIZE 0,10 Bold OF oPrn
DEFINE FONT oFont10  NAME "Arial"   SIZE 0,10      OF oPrn
DEFINE FONT oFont102 NAME "Courier New" SIZE 0,09 Bold     OF oPrn
DEFINE FONT oFont11n NAME "Arial"   SIZE 0,11 Bold OF oPrn
DEFINE FONT oFont11  NAME "Arial"   SIZE 0,11      OF oPrn
DEFINE FONT oFont112 NAME "COurier New"   SIZE 0,11 Bold  OF oPrn
DEFINE FONT oFont12n NAME "Arial"   SIZE 0,12 Bold OF oPrn
DEFINE FONT oFont12  NAME "Arial"   SIZE 0,12      OF oPrn
DEFINE FONT oFont13n NAME "Arial"   SIZE 0,12 Bold OF oPrn
DEFINE FONT oFont13  NAME "Arial"   SIZE 0,12      OF oPrn
DEFINE FONT oFont14n NAME "Arial"   SIZE 0,14 Bold OF oPrn
DEFINE FONT oFont14  NAME "Arial"   SIZE 0,14      OF oPrn
DEFINE FONT oFont16n NAME "Arial"   SIZE 0,16 Bold OF oPrn
DEFINE FONT oFont16  NAME "Arial"   SIZE 0,16      OF oPrn
DEFINE FONT oFont20n NAME "Arial"   SIZE 0,20 Bold OF oPrn
DEFINE FONT oFont20  NAME "Arial"   SIZE 0,20      OF oPrn
DEFINE FONT oFont22n NAME "Arial"   SIZE 0,22 Bold OF oPrn
DEFINE FONT oFont22  NAME "Arial"   SIZE 0,22      OF oPrn
DEFINE FONT oFont36  NAME "Arial"   SIZE 0,36 Bold OF oPrn
DEFINE FONT oFont48  NAME "Arial"   SIZE 0,48 Bold OF oPrn

DEFINE FONT oFontX  NAME "Arial" SIZE 0,09 Bold Italic Underline OF oPrn
DEFINE FONT oFontY  NAME "Arial" SIZE 0,09 Bold OF oPrn

oPrn:SetPortrait() // Estilo retrato
oPrn:StartPage()   // Inicia uma nova página

// DADOS DO FORNECEDOR
SA2->(DbSetOrder(1))
SA2->(DbSeek(xFilial("SA2") + ALLTRIM(SC7->C7_FORNECE)))

//DADOS DO TOTAL DOS ITENS
SCR->(DbSetOrder(1))
SCR->(DbSeek(xFilial("SCR") + "PC" + SC7->C7_NUM))

//DESCRICAO DA CONDIÇÃO DE PAGAMENTO
SE4->(DbSetOrder(1))
SE4->(DbSeek(xFilial("SE4") + SC7->C7_COND))
nLinVer := GeraCabec()
nLinBak := nLinVer
nLinhaItem := nLinVer += 62
nTotDesc   := 0
nItem      := 1 

PswOrder(1) // Ordem de codigo
PswSeek(SC7->C7_USER)
aUser := PswRet(1) //Retorna Matriz com detalhes, acessos do Usuario
cComprador := aUser[1][2]//EMBARALHA(SC7->C7_USERLGI,1)

nTotalIpi := 0
ndItem := 1
_ndFrete := SC7->C7_VALFRE
lNewPageRod := .F.

While ALLTRIM(SC7->C7_NUM) = cPedido
	oPrn:Say(nLinhaItem, 60,ALLTRIM(STR(nItem)),OFONT12,,,,3)
	oPrn:Say(nLinhaItem, 160,ALLTRIM(SC7->C7_PRODUTO),OFONT10,,,,3)
	oPrn:Say(nLinhaItem, 460,ALLTRIM(SC7->C7_UM),OFONT10,,,,3)
	oPrn:Say(nLinhaItem, 460,Transform(SC7->C7_QUANT,PesqPict("SC7","C7_QUANT",18,2)),OFONT102,,,,3)
	oPrn:Say(nLinhaItem,1500,Transform(SC7->C7_VALIPI  ,PesqPict("SC7","C7_VALIPI",18,2) ),OFONT102,,,,3)
	oPrn:Say(nLinhaItem,1850,Transform(SC7->C7_PRECO, "@E 9,999,999.99"),OFONT102,,,,3)
	oPrn:Say(nLinhaItem,2080,Transform(SC7->C7_TOTAL, "@E 999,999,999.99"),OFONT102,,,,3)
	//   _____________________________________________________________
	//  |     Querbrar em linha a descrição específica do produto
	//   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
//	cMemo := GetMemo(Posicione("SB1",1,xFilial("SB1") + SC7->C7_PRODUTO ,"B1_ESPECIF" ), nMemoWidth, oPrn, OFONT10)
	cMemo := GetMemo(AllTrim(SC7->C7_DESCRI), nMemoWidth, oPrn, OFONT10)
	nTxtHeigth := oPrn:GetTextHeigth(cMemo, OFONT10)
	nMemoLine  := MLCount(cMemo)
	SayMemo(cMemo, nLinhaItem, 880, oPrn, OFONT10, nTxtHeigth)
	nLinhaItem := GeraLine(nLinhaItem ,2, nTxtHeigth * nMemoLine)
	
	nItem += 1
	ndItem += 1
	cObs += ALLTRIM(SC7->C7_OBS)
	nTotalz  += SC7->C7_TOTAL - SC7->C7_VLDESC
	nTotalIpi += SC7->C7_VALIPI
	nTotDesc += SC7->C7_VLDESC
	
	SC7->(DbSkip())

	If ALLTRIM(SC7->C7_NUM) = cPedido
		//quebra de pagina do rodape
		If nLinhaItem + nTxtHeigth * nMemoLine >= nLinBak + 1380
			lNewPageRod := .T.
		EndIf
	
		//quebra de pagina dos itens do pedido
		If nLinhaItem + nTxtHeigth * nMemoLine >= nLinBak + 2160
		
		   oPrn:Box (nLinBak,50, nLinBak + 2160,2430)//1200
		   oPrn:EndPage()
		   oPrn:StartPage()
		   ndItem := 1
		   nLinVer := GeraCabec()
		   nLinhaItem := nLinVer += 62
		   lNewPageRod := .F.	
		EndIf

	EndIf
	
EndDo

nLinha := 1080
nQtdItem := 1
oPrn:Box (nLinBak,50,2485 ,2430)//1200 

If lNewPageRod
oPrn:EndPage()
oPrn:StartPage()
nLinVer := GeraCabec()
oPrn:Box (nLinBak,50,nLinBak + 62 ,2430)//1200
EndIf
oPrn:Box(2485,50,2600,2430)
oPrn:Box(2600,50,3150,2430)
//oPrn:Say(2850,055,SUBSTRING(cObs,10,85),oFont12,,,,3)//
oPrn:Say(2550 - 60,0800,"Desconto:",OFONT11N,,,,3)
oPrn:Say(2550 - 60,1000,Transform(nTotDesc, "@E 999,999,999.99"),OFONT11,,,,3)
oPrn:Say(2550 - 60,1400,"Totais->",OFONT11N,,,,3)
oPrn:Say(2550 - 60,1500,Transform(nTotalIpi, "@E 999,999,999.99"),OFONT112,,,,3) 
oPrn:Say(2550 - 60,2080,Transform(nTotalz, "@E 999,999,999.99"),OFONT112,,,,3) 

oPrn:Say(2550,0800,"Frete :",OFONT11N,,,,3)
oPrn:Say(2550,1000,Transform(_ndFrete, "@E 999,999,999.99"),OFONT11,,,,3)
oPrn:Say(2550,1400,"Total Pedido(Total + Frete) : ",OFONT11N,,,,3)
//oPrn:Say(2550,1500,Transform(nTotalIpi, "@E 999,999,999.99"),OFONT112,,,,3) 
oPrn:Say(2550,2080,Transform(nTotalz + _ndFrete, "@E 999,999,999.99"),OFONT112,,,,3) 

//oPrn:Say(2600,055,"FATURAR CONFORME O PEDIDO DE COMPRA",oFont12,,,,3)
oPrn:Say(2600,055,"INFORMAR NUMERO DESSE PEDIDO NA NF",oFont12,,,,3)
//oPrn:Say(2650,055,"SÓ ACEITAMOS A MERCADORIA SE NA NOTA FISCAL CONSTAR O NÚMERO DO NOSSO PEDIDO DE COMPRA",oFont12,,,,3)
oPrn:Say(2650,055,"E-MAIL P/ENVIO DE NOTA E XML COMPRAS@AMAZONACO.COM.BR",oFont12,,,,3)
oPrn:Say(2700,055,"ENDEREÇO DE COBRANÇA PARA  AV. PURAQUEQUARA, NUMERO 5328 CEP 69009-000 ",oFont12,,,,3)
oPrn:Say(2750,055,"Comprador: " ,OFONT11N,,,,3)
oPrn:Say(2750,280,ALLTRIM(cComprador),oFont12,,,,3)
oPrn:Say(2850,055,cObs,oFont12,,,,3)
//oPrn:Say(2900 - 60,055,SUBSTRING(cObs,85,10),oFont12,,,,3)
oPrn:EndPage()     // Finaliza a página
oPrn:Preview()     // Visualiza antes de imprimir
SC7->(RestArea(aArea))
Return


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ VALIDPERG  ¦ Autor ¦ Jean Vicente         ¦ Data ¦   /  /2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)

PutSX1(cPerg,"01",PADR("Pedido     ?",16),"","","mv_ch1","C",06,0,0,"G","","SC7","","","mv_par01")

Return

Static Function GeraCabec()

Local nLinVer := 0

//Quadro Cabeçalho
oPrn:Box(200,50,1000,2430)// Caixa Pricipal do cabeçalho
oPrn:Say(60,1000,"PEDIDO DE COMPRAS",OFONT16N,,,,3)           
//oPrn:Say(130,800,"AMAZON ACO INDUSTRIA E COMERCIO LTDA",OFONT14N,,,,3)
//             L     C                 L    C
oPrn:SayBitmap(210, 160, "lgMID1.bmp",430, 440)


//   __________________________________________________________________
//  |     Nelio Castro Jorio - 23/07/2012
//  |     Alteração do Cabeçalho para obter dados da filial em uso
//   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
//   _______________________________________________________________________
//  |     MV_XFILXX - Armazena o nome da filial para o pedido de compra
//  |     MV_XFIL00 - AMAZON ACO - INDUSTRIA
//  |     MV_XFIL01 - AMAZON ACO - INDUSTRIA                             
//  |     MV_XFIL02 - AMAZON ACO - COMERCIO
//  |     MV_XFIL03 - AMAZON ACO - FILIAL
//  |     MV_XFIL04 - AMAZON ACO - FILIAL
//   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
//	M0_FILIAL = 00	M0_NOME = MATRIZ	M0_NOMECOM = AMAZON...	M0_ENDENT = AV, NUM	M0_CIDENT = MANAUS
//	M0_ESTENT = AM	M0_CEPENT = 69...	M0_CGC = 05477...	M0_INSC = 062000...	M0_TEL = 9221299898
//	M0_FAX = 92...	M0_BAIRENT = DISTRITO...	M0_COMPENT = LOTE 2.19...	M0_INS_SUF = 2012...	M0_INSCM = 10545...

//oPrn:Say(210,750,Space(6) + GetMv("MV_XFIL"+SM0->M0_CODFIL,.F.,AllTrim(SM0->M0_NOMECOM)),OFONT11N,,,,3)
oPrn:Say(210,750,AllTrim(SM0->M0_NOMECOM),OFONT11N,,,,3)
oPrn:Say(250,805,AllTrim(SM0->M0_ENDENT) + " - " + AllTrim(SM0->M0_BAIRENT) + " - " + "CEP " + Transform(SM0->M0_CEPENT,'@R 99999-999'),OFONT10,,,,3)
oPrn:Say(290,805,"CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") + " INSC. EST.: " + Transform(PadL(AllTrim(SM0->M0_INSC),10,' '),'@R !!!.999.999-9'),OFONT10,,,,3)
oPrn:Say(330,805,"Inscricao Suframa n. " + Transform(PadL(AllTrim(SM0->M0_INS_SUF),10,' '),"@R !!!.999.999-9") + "  Fone/Fax: " + Transform(AllTrim(SM0->M0_TEL),'@R (99) 9999-9999') + Transform(PadL(Right(StrTran(SM0->M0_FAX,' ',''),8),8,' '),'@R /!!!!-9999'),OFONT10,,,,3)
oPrn:Say(370,805,"Inscricao Municipal: n. " + Transform(PadL(AllTrim(SM0->M0_INSCM),8,' '),"@R !!!.999-99") + Space(33) + AllTriM(SM0->M0_CIDENT) + " - " + AllTrim(SM0->M0_ESTENT),OFONT10,,,,3)         

oPrn:Line(nLinVer += 200,2000,650,2000)//200
oPrn:Line(nLinVer,2430,650,2430)//200 LINHA 1
oPrn:Line(nLinVer, 720,650, 720)//200 LINHA 2
oPrn:Say(nLinVer += 20,2150,"PEDIDO",OFONT13N,,,,3)//220
oPrn:Say(nLinVer += 80,2150,SC7->C7_NUM,OFONT16,,,,3)//300
oPrn:Line(nLinVer += 80,2000,nLinVer,2430)//380
oPrn:Say(nLinVer += 50,2150,"DATA",OFONT13N,,,,3)//430
oPrn:Say(nLinVer += 80,2100,cValToChar(SC7->C7_EMISSAO),OFONT16,,,,3)//510
oPrn:Line(nLinVer += 140,50,nLinVer,2430)//650

oPrn:Say(nLinVer += 20,70,"COD/FORNECEDOR: ",OFONT11N,,,,3)//670
oPrn:Say(nLinVer,550,ALLTRIM(SA2->A2_COD)+" - "+ALLTRIM(SA2->A2_NOME)+" CNPJ: "+ALLTRIM(Transform(SA2->A2_CGC,PesqPict("SA2","A2_CGC"))),OFONT11,,,,3)//670
oPrn:Line(nLinVer += 50,50,nLinVer,2430)//900
oPrn:Say(nLinVer += 20,70,"ENDERECO:",OFONT11N,,,,3)//920
oPrn:Say(nLinVer,320,ALLTRIM(SA2->A2_END),OFONT11,,,,3)//920
oPrn:Line(nLinVer += 50,50,nLinVer,2430)//970
oPrn:Say(nLinVer += 20,70,"PAGAMENTO:",OFONT11N,,,,3)//990
oPrn:Say(nLinVer,340,ALLTRIM(SE4->E4_DESCRI),OFONT11,,,,3)//990
oPrn:Say(nLinVer,1400,"CONTATO:",OFONT11N,,,,3)//990
oPrn:Say(nLinVer,1600,ALLTRIM(SC7->C7_CONTATO),OFONT11,,,,3)//990
oPrn:Line(nLinVer += 50,50,nLinVer,2430)//1040
oPrn:Say(nLinVer += 20,70,"TELEFONE:",OFONT11N,,,,3)//1060
oPrn:Say(nLinVer,300,ALLTRIM(SA2->A2_TEL),OFONT11,,,,3)//1060
oPrn:Say(nLinVer,1600,"FRETE CIF   (   )              FRETE FOB   (   )",OFONT11N,,,,3)//1060
oPrn:Line(nLinVer += 50,50,nLinVer,2430)//1110
ntrans := SC7->C7_X_TRANS
oPrn:Say(nLinVer += 20,70,"TRANSPORTADOR: "+IIF(!EMPTY(ntrans),POSICIONE("SA4",1,XFILIAL("SA4")+ALLTRIM(ntrans),"A4_NOME"),""),OFONT11N,,,,3)//1130
oPrn:Say(nLinVer,1400,"PRAZO ENTREGA:",OFONT11N,,,,3)//1130
oPrn:Say(nLinVer,1800,cValToChar(SC7->C7_DATPRF),OFONT11,,,,3)//990


//Quadro de Itens
nLinVer += 70
oPrn:Say(nLinVer,60,"Item",OFONT11N,,,,3)
oPrn:Say(nLinVer,210,"Codigo",OFONT11N,,,,3)
oPrn:Say(nLinVer,460,"Unid.",OFONT11N,,,,3)
oPrn:Say(nLinVer,610,"Qtde.",OFONT11N,,,,3)
oPrn:Say(nLinVer,1100,"Descricao",OFONT11N,,,,3)
oPrn:Say(nLinVer,1780,"IPI",OFONT11N,,,,3)
oPrn:Say(nLinVer,1900,"Pr. Unit",OFONT11N,,,,3)
oPrn:Say(nLinVer,2200,"Pr. Total",OFONT11N,,,,3)

Return nLinVer

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GeraLine   ¦ Autor ¦ Nelio Castro Jorio   ¦ Data ¦ 06/08/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Imprime as linhas internas do item de pedido: linha topo e as ¦¦¦
¦¦¦           ¦   colunas separadoras de acordo com o parametro nColHeigth    ¦¦¦
¦¦¦           ¦   que define a altura da coluna.                              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function GeraLine(nLinI, nLim, nColHeigth)
	Local nQtdItem := 1
	Local nLinha   := nLinI
	Local nPadding := 3

	While nQtdItem < nLim
	
		//top
		oPrn:Line(nLinha,50,nLinha,2430)	
	
	    //cols
		nLinha += nColHeigth
		oPrn:Line(nLinI,150 ,nLinha,150)
		oPrn:Line(nLinI,450 ,nLinha,450)
		oPrn:Line(nLinI,570 ,nLinha,570)
		oPrn:Line(nLinI,830 ,nLinha,830)
		oPrn:Line(nLinI,1740,nLinha,1740)
		oPrn:Line(nLinI,1860,nLinha,1860)
		oPrn:Line(nLinI,2120,nLinha,2120)
		
		//next item
		nQtdItem++
	End

	//bottom
	nLinha += nPadding
	oPrn:Line(nLinha,50,nLinha,2430)	

Return nLinha

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ SayMemo    ¦ Autor ¦ Nelio Castro Jorio   ¦ Data ¦ 02/08/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Imprime as linhas de um campo memo definido previamente com a ¦¦¦
¦¦¦           ¦   função GetMemo() no relatório gráfico de acordo com o       ¦¦¦
¦¦¦           ¦   incremento de linha                                         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function SayMemo(cMemo, nLin, nCol, oTMSPrinter, oFont, nLinInc)

	For nX := 1 to MLCount(cMemo)
		oTMSPrinter:Say(nlin, nCol, MemoLine(cMemo,,nX), oFont,,,,3)
		nLin := nLin + nLinInc
	Next nX

Return nLin

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GetMemo    ¦ Autor ¦ Nelio Castro Jorio   ¦ Data ¦ 02/08/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Transforma um Texto para Memo refazendo as quebras de linha   ¦¦¦
¦¦¦           ¦   com os caracteres #13 e #10 de acordo com a largura do campo¦¦¦
¦¦¦           ¦   informada separando as palavras com o caracter de espaço    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function GetMemo(cTexto, nWidth, oTMSPrinter, oFont)
	Local cMemo      := ""
	Local cLinha     := ""
	Local cPalavra   := ""

	//Remove Caracteres
	StrTran(cTexto, Chr(13), ' ')
	StrTran(cTexto, Chr(10), ' ')
	StrTran(cTexto, '  ', ' ')
	cTexto := AllTrim(cTexto)
	cTexto += ' '
                                     
	//prepara linhas 
	While At(' ', cTexto) > 0
		//Palavra
		cPalavra := SubStr(cTexto, 1, At(' ', cTexto))
		
		//Linha
		If oTMSPrinter:GetTextWidth((cLinha + cPalavra), OFONT10)/2 <= nWidth
			cLinha += cPalavra
		Else
			//Memo
			cMemo += cLinha + Chr(13) + Chr(10)
			//Nova Linha
			cLinha := cPalavra
		EndIf   
		                                            
		cTexto := SubStr(cTexto, (At(' ', cTexto) + 1), Len(cTexto))
		If Len(cTexto) = 0
			cMemo += cLinha
		EndIf
	EndDo

Return cMemo