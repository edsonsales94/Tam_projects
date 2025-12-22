#include "rwmake.ch"
#include "font.ch"

//---------------------------------------------------------------------------
// Função    | MATR110 | Autor | Orismar Silva           | Data | 27/04/15 |
//---------------------------------------------------------------------------
// Descrição | Emissao do Pedido de Compras Local/Outros Estados            |
//---------------------------------------------------------------------------

User Function MATR110(cAlias,nReg,nOpcx)

//	Local aArea 	        := SC7->(GetArea())	
    Private cPedido	        := ""
	Private lPedido         := .F.
	Private cTpFrete		:= ""
	Private cTransp  		:= ""

    If FunName() == "MATA121"//Executado pelo Pedido de Compas
       cPedido	 := SC7->C7_NUM
       lPedido   := .T.
    Else//Executado pelo Relatorios 
       cPedido := mv_par01
  	Endif 	   	 
    

	SC7->(dbGoTop())
	SC7->(dbSetOrder(1))
	if SC7->(dbSeek(xFilial("SC7")+cPedido))

	   // DADOS DO FORNECEDOR
	   SA2->(DbSetOrder(1))
	   SA2->(DbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA))

	   If SA2->A2_EST = "AM"  
	      U_RXMATR110() // Layout do pedido Local
	   Else
	      U_RRMATR110() // Layout do pedido outros Estados
	   EndIf  

	endif

Return
//---------------------------------------------------------------------------
// Função    | RXMATR110| Autor | Orismar Silva           | Data | 08/04/15 |
//---------------------------------------------------------------------------
// Descrição | Emissao do Pedido de Compras Local                           |
//---------------------------------------------------------------------------
User Function RXMATR110(cAlias,nReg,nOpcx)

	Local cNomCom, cTelCom               // variavel para buscar o nome e telefone do comprador
	Local cObs		   := ""
	Local nTotalz	   := 0
	Local nTotal	   := 0
	Local _ndFrete     := 0
	Local aArea 	   := SC7->(GetArea())	
	Local aObs         := {}
	Local x
	LOCAL nI := 1
    Local cDescri      := ""
    Private nPag       := 1 
	Private oPrn       := TMSPrinter():New( "Pedido de Compra" )
	Private nLinhaItem := 0
	Private nLinVer    := 0	
    private lItem      := .T.
    Private cSolicitante := ""

    // DADOS DO FORNECEDOR
	SC1->(DbSetOrder(1))
	SC1->(DbSeek(xFilial("SC1") + SC7->C7_NUMSC))
	cSolicitante := UPPER(SC1->C1_SOLICIT)
   
	SC7->(dbGoTop())
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(xFilial("SC7")+cPedido))

	DEFINE FONT oFont08  NAME "Arial"   SIZE 0,08      OF oPrn
	DEFINE FONT oFont08n NAME "Arial"   SIZE 0,08 Bold OF oPrn
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
	DEFINE FONT oFontX   NAME "Arial"   SIZE 0,09 Bold Italic Underline OF oPrn
	DEFINE FONT oFontY   NAME "Arial"   SIZE 0,09 Bold OF oPrn

	oPrn:SetPortrait() // Estilo retrato
	oPrn:StartPage()   // Inicia uma nova página
    *
	// DADOS DO FORNECEDOR
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA))

	//DADOS DO TOTAL DOS ITENS
	SCR->(DbSetOrder(1))
	SCR->(DbSeek(xFilial("SCR") + "PC" + SC7->C7_NUM))

	//DESCRICAO DA CONDIÇÃO DE PAGAMENTO
	SE4->(DbSetOrder(1))
	SE4->(DbSeek(xFilial("SE4") + SC7->C7_COND))
	dDtEmis     := SC7->C7_EMISSAO
	dDtEntrega  := SC7->C7_DATPRF 
	cContato    := SC7->C7_CONTATO
	dDtFatur    := SC7->C7_XDTFAT	
    *
	nLinVer	:= GeraCabecL()
	*
	nLinBak	     := nLinVer
	nLinhaItem	 := nLinVer += 65
	nTotDesc	 := 0
	nItem		 := 1
	ndItem 		 := 1	
	lLiber       := .F.  
    cAprov        := ""
    dbSelectArea("SC7")
	If !Empty(SC7->C7_APROV)
	   cTipoSC7:= IIF((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"PC","AE")
	   If SC7->C7_CONAPRO != "B"
	      lLiber := .T.
	   EndIf
	   dbSelectArea("SCR")
	   dbSetOrder(1)
	   dbSeek(xFilial("SCR")+cTipoSC7+SC7->C7_NUM)
	   While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM) == xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO == cTipoSC7
	 		 cAprov += AllTrim(NomeCompleto(SCR->CR_USER))+" ["
			 Do Case
				Case SCR->CR_STATUS=="03" //Liberado
			 		 cAprov += "Ok"
				Case SCR->CR_STATUS=="04" //Bloqueado
					 cAprov += "BLQ"
				Case SCR->CR_STATUS=="05" //Nivel Liberado
					 cAprov += "##"
				OtherWise                 //Aguar.Lib
					 cAprov += "??"
				EndCase
				cAprov += "] - "
				dbSelectArea("SCR")
				dbSkip()
			 Enddo
	EndIf
    *
	While ALLTRIM(SC7->C7_NUM) = cPedido .and. SC7->C7_FILIAL = xFilial("SC7")
		*
		oPrn:Line(nLinhaItem,50 ,nLinhaItem + 65,50)
		oPrn:Line(nLinhaItem,150 ,nLinhaItem + 65,150)
		oPrn:Line(nLinhaItem,450 ,nLinhaItem + 65,450)		
        oPrn:Line(nLinhaItem,1330 ,nLinhaItem + 65,1330)
	    oPrn:Line(nLinhaItem,1450 ,nLinhaItem + 65,1450)
	    oPrn:Line(nLinhaItem,1600 ,nLinhaItem + 65,1600)
	    oPrn:Line(nLinhaItem,1860,nLinhaItem + 65,1860)
	    oPrn:Line(nLinhaItem,2120,nLinhaItem + 65,2120)
	    oPrn:Line(nLinhaItem,2350,nLinhaItem + 65,2350)
        *
        if empty(ALLTRIM(SC7->C7_OBS))
           cDescri := ALLTRIM(SC7->C7_DESCRI)
        else         
           cDescri := ALLTRIM(SC7->C7_DESCRI)+"-"+ALLTRIM(SC7->C7_OBS)
        endif
        *       
		oPrn:Say(nLinhaItem,  60,ALLTRIM(STR(nItem)),OFONT11,,,,3)
		oPrn:Say(nLinhaItem, 160,ALLTRIM(SC7->C7_PRODUTO),OFONT11,,,,3)
		//oPrn:Say(nLinhaItem, 460,SUBSTR(SC7->C7_DESCRI,1,42),OFONT10,,,,3)		
		oPrn:Say(nLinhaItem, 460,SUBSTR(cDescri,1,37),OFONT10,,,,3)
		oPrn:Say(nLinhaItem,1340,ALLTRIM(SC7->C7_UM),OFONT11,,,,3)
		oPrn:Say(nLinhaItem,1460,ALLTRIM(SC7->C7_CC),OFONT11,,,,3)		
		oPrn:Say(nLinhaItem,1610,Transform(SC7->C7_QUANT,TM(SC7->C7_QUANT,TamSX3("C7_QUANT")[1],TamSX3("C7_QUANT")[2])),OFONT09,,,,3)		
		oPrn:Say(nLinhaItem,1870,Transform(SC7->C7_PRECO,TM(SC7->C7_PRECO,TamSX3("C7_PRECO")[1],TamSX3("C7_PRECO")[2])),OFONT10,,,,3)
		oPrn:Say(nLinhaItem,2130,Transform(SC7->C7_TOTAL,TM(SC7->C7_TOTAL,TamSX3("C7_TOTAL")[1],TamSX3("C7_TOTAL")[2])),OFONT10,,,,3)		
		
		if LEN(cDescri)> 34
		   For x:=38 to LEN(cDescri) step 37//60
		       nLinhaItem	+= 63
  		       oPrn:Line(nLinhaItem,50  ,nLinhaItem + 65,50)
		       oPrn:Line(nLinhaItem,150 ,nLinhaItem + 65,150)
		       oPrn:Line(nLinhaItem,450 ,nLinhaItem + 65,450)		
               oPrn:Line(nLinhaItem,1330,nLinhaItem + 65,1330)
	           oPrn:Line(nLinhaItem,1450,nLinhaItem + 65,1450)
	           oPrn:Line(nLinhaItem,1600,nLinhaItem + 65,1600)
	           oPrn:Line(nLinhaItem,1860,nLinhaItem + 65,1860)
	           oPrn:Line(nLinhaItem,2120,nLinhaItem + 65,2120)
	           oPrn:Line(nLinhaItem,2350,nLinhaItem + 65,2350)
		       oPrn:Say(nLinhaItem, 460,SUBSTR(cDescri,x,37),OFONT10,,,,3)
		   Next 
		endif
		*
		nLinhaItem	+= 63
		oPrn:Line(nLinhaItem,50,nLinhaItem,2350)
		nItem 		+= 1
		ndItem 		+= 1
		//cObs 		+= ALLTRIM(SC7->C7_OBS)
		nPos := AScan(aObs , {|x| x[1] == ALLTRIM(SC7->C7_OBS) })
        If nPos == 0
          // aadd(aObs,{ALLTRIM(SC7->C7_OBS)})
        Endif           	
                     
        _ndFrete	+= SC7->C7_VALFRE
		nTotal 	    += SC7->C7_TOTAL
		nTotalz 	+= SC7->C7_TOTAL - SC7->C7_VLDESC +SC7->C7_VALFRE
		nTotDesc	+= SC7->C7_VLDESC
		cNomCom 	:= Posicione("SY1",3,xFilial("SY1")+SC7->C7_USER,"Y1_NOME")
		cTelCom	    := Posicione("SY1",3,xFilial("SY1")+SC7->C7_USER,"Y1_TEL")
		cMailCom	:= Posicione("SY1",3,xFilial("SY1")+SC7->C7_USER,"Y1_EMAIL")
	
		SC7->(DbSkip())
	
		if ndItem >= 23
			lNewPageRod := .T.
		EndIf
		
		if ndItem >= 36 .OR. nLinhaItem > 3270
    		oPrn:Say(nLinhaItem,2079,"Continuação >>",OFONT12,,,,3)
    		nLinhaItem	+= 63
    		iif(!lLiber,oPrn:Say(nLinhaItem,990,"** Pedido de Compra não aprovado. **",oFont12,,,,3),"")
			oPrn:Box (nLinBak,50, nLinBak + ndItem * 60,2350)
			oPrn:EndPage()
			oPrn:StartPage()
			ndItem := 1
			nPag++
			nLinVer := GeraCabec()
			nLinhaItem := nLinVer += 62
			lNewPageRod := .T.
		EndIf
		
	EndDo
    *
    lItem := .F.
    xVerPagL()
	nLinha   := nLinhaItem
	nQtdItem := 1
	*
	oPrn:Line(nLinhaItemItem,1390,nLinhaItem+80,1390)
	oPrn:Line(nLinhaItem,2120,nLinhaItem+80,2120)
	oPrn:Line(nLinhaItem,2350,nLinhaItem+80,2350)
	oPrn:Say(nLinhaItem+10,1400,'Sub-Total  R$',oFont12)
	oPrn:Say(nLinhaItem+10,2130,Transform(nTotal, "@E 999,999,999.99"),oFont10)
	nLinhaItem += 80
	oPrn:Line(nLinhaItem,1390,nLinhaItem,2350)
    *
	xVerPagL()
	*
	oPrn:Line(nLinhaItemItem,1390,nLinhaItem+80,1390)
	oPrn:Line(nLinhaItem,2120,nLinhaItem+80,2120)
	oPrn:Line(nLinhaItem,2350,nLinhaItem+80,2350)
	oPrn:Say(nLinhaItem+10,1400,'Frete  R$',oFont12)
	oPrn:Say(nLinhaItem+10,2130,Transform(_ndFrete, "@E 999,999,999.99"),oFont10)
	nLinhaItem += 80
	oPrn:Line(nLinhaItem,1390,nLinhaItem,2350)
    *
	xVerPagL()
	
    *
	oPrn:Line(nLinhaItem,1390,nLinhaItem+80,1390)
	oPrn:Line(nLinhaItem,2120,nLinhaItem+80,2120)
	oPrn:Line(nLinhaItem,2350,nLinhaItem+80,2350)
	oPrn:Say(nLinhaItem+10,1400,'Desconto   R$',oFont12)
	oPrn:Say(nLinhaItem+10,2130,Transform(nTotDesc, "@E 999,999,999.99"),oFont10)
	nLinhaItem += 80
	oPrn:Line(nLinhaItem,1390,nLinhaItem,2350)
    *
	xVerPagL()
	*
	oPrn:Line(nLinhaItem,1390,nLinhaItem+80,1390)
	oPrn:Line(nLinhaItem,2120,nLinhaItem+80,2120)
	oPrn:Line(nLinhaItem,2350,nLinhaItem+80,2350)
	oPrn:Say(nLinhaItem+10,1400,'Total      R$',oFont12)
	oPrn:Say(nLinhaItem+10,2130,Transform(nTotalz, "@E 999,999,999.99"),oFont10)
	nLinhaItem += 80
	oPrn:Line(nLinhaItem,1390,nLinhaItem,2350)
    *
	       
	*
  	nLinhaItem += 80
	
	xVerPag() 
    oPrn:Box(nLinhaItem,100,nLinhaItem+300,2350)   
    oPrn:Line(nLinhaItem,550,nLinhaItem+300,550)
    oPrn:Line(nLinhaItem,1000,nLinhaItem+300,1000)
    oPrn:Line(nLinhaItem,1450,nLinhaItem+300,1450)
    oPrn:Line(nLinhaItem,1900,nLinhaItem+300,1900)   
   
    nLinhaItem += 10
	
	//xVerPag()
	oPrn:Say(nLinhaItem,220  ,'Resp. Compras'   ,oFont12)
	oPrn:Say(nLinhaItem,650  ,'Resp. Depto.'    ,oFont12)	
	oPrn:Say(nLinhaItem,1100 ,'Ger. Contábil'   ,oFont12)
	oPrn:Say(nLinhaItem,1550 ,'Ger. Adm.'       ,oFont12)
	oPrn:Say(nLinhaItem,2000 ,'Diretor' ,oFont12)
	nLinhaItem += 50
	
	xVerPag()	
	oPrn:Line(nLinhaItem,100,nLinhaItem,2350)
	nLinhaItem += 10
	xVerPag()	
    *
	nLinhaItem +=170
	xVerPag()	
	oPrn:Say(nLinhaItem,250 ,DTOC(dDtEmis) ,oFont12)
    oPrn:Say(nLinhaItem,700 ,DTOC(dDtEmis) ,oFont12)
	oPrn:Say(nLinhaItem,1150,DTOC(dDtEmis) ,oFont12)
	oPrn:Say(nLinhaItem,1600,DTOC(dDtEmis) ,oFont12)	
	oPrn:Say(nLinhaItem,2050,DTOC(dDtEmis) ,oFont12)		
	nLinhaItem +=100
	xVerPag()	    
    *
	oPrn:Box(nLinhaItem,50,nLinhaItem+450,2350)	
	nLinhaItem +=50
	xVerPagL()	
	oPrn:Say(nLinhaItem,055,"Observações:",oFont12,,,,3)
	cObs += 'O número do pedido deverá estar obrigatoriamente gravado na nota fiscal e no .xml no campo XPED'
	_nLinhaItem := MlCount(cObs, 140)
	_nLiAtu := nLinhaItem
	
	NCOL := 275
	nCalc := 1
	For nI:=1 to _nLinhaItem
		 oPrn:Say(_nLiAtu, NCOL, Substr(cObs,nI,140),oFont12,,,,3)
		 nCalc += 140
		 _nLiAtu += 50
		 NCOL := 055
	Next
	*
	/*
	For p:=1 To Len(aObs)
       cObs += LTRIM(Str(p))+"."+LOWER(aObs[p,1])
       if p < Len(aObs)
          cObs +=", "
       endif
    Next
	nI := 1
	For i:=1 to Len(cObs)
		 oPrn:Say(_nLiAtu, 055, Substr(cObs,nI,118),oFont12,,,,3)
		 nI += 118
		 _nLiAtu += 50
	Next
	*/
	*
   nLinhaItem += 350
	xVerPagL()   
   oPrn:Box(nLinhaItem,50,nLinhaItem+300,2350)
	oPrn:Say(nLinhaItem += 50,055,"Nota Fiscal em nome de:",oFont10,,,,3)
	oPrn:Say(nLinhaItem,1070,"Nova Inscrição Estadual sob lei 2826 = "+Transform(SM0->M0_INSC,"@R 99.999.999-9"),oFont10N,,,,3)
	oPrn:Say(nLinhaItem += 50,055,Alltrim(SM0->M0_NOMECOM),oFont10N,,,,3)
	oPrn:Say(nLinhaItem += 50,055,Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_CIDENT)+" - "+Alltrim(SM0->M0_ESTENT)+" Tel: ("+SUBSTR(SM0->M0_TEL,1,2)+") "+SUBSTR(SM0->M0_TEL,4,LEN(LTRIM(SM0->M0_TEL))),oFont10N,,,,3)
	oPrn:Say(nLinhaItem += 50,055,"CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ " I.E.: "+Transform(SM0->M0_INSC,"@R 99.999.999-9")+ " SUFRAMA: "+Transform(SM0->M0_INS_SUF,"@R 999999-999"),oFont10N,,,,3)	
	//oPrn:Say(nLinhaItem += 50,055,"CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ " I.E.: "+ALLTRIM(SM0->M0_INSC)+ " SUFRAMA: "+Transform(SM0->M0_INS_SUF,"@R 999999-999"),oFont10N,,,,3)
    *
    nLinhaItem += 30
	oPrn:Say(nLinhaItem += 100,055 ,"Solicitante:",oFont08N,,,,3)	
	oPrn:Say(nLinhaItem       ,250 ,cSolicitante  ,oFont08N,,,,3)	
	oPrn:Say(nLinhaItem       ,1800,"Mod. ADM 019",oFont08N,,,,3)	
	oPrn:Say(nLinhaItem += 50 ,1800,"Rev. 07",oFont08N,,,,3)	
   
	oPrn:EndPage()     // Finaliza a página
	oPrn:Preview()     // Visualiza antes de imprimir
    SC7->(RestArea(aArea))	

Return

//---------------------------------------------------------------------------
//    imprimir cabecalho
//---------------------------------------------------------------------------
Static Function GeraCabecL()

	Local nLinVer := 0
	//Quadro Cabeçalho
	oPrn:Box(200,50,730,2350)// Caixa Pricipal do cabeçalho
	
	//             L     C                 L    C
	oPrn:SayBitmap(210, 120, "lgrlped.bmp",300, 200)//	oPrn:SayBitmap(210, 160, "galo.bmp",430, 440)
    *
    oPrn:Say(210,700,Alltrim(SM0->M0_NOMECOM),OFONT11N,,,,3)     
	oPrn:Say(280,800,"PEDIDO DE COMPRAS",OFONT16N,,,,3)
    *
    oPrn:Line(nLinVer += 200,1800,600,1800)//COLUNA ANTES DO PEDIDO E DATA
    oPrn:Line(nLinVer,1990,440,1990)
  	oPrn:Line(nLinVer, 520,440, 520)       //COLUNA DEPOIS LOGO
    oPrn:Line(440, 330,730, 330)           //COLUNA DEPOIS DO CAMPO FORNECEDOR
    oPrn:Line(440, 1500,730, 1500)         //COLUNA ANTES DO CAMPO PAGAMENTO
    oPrn:Line(440, 1800,730, 1800)         //COLUNA DEPOIS DO CAMPO PAGAMENTO   
    oPrn:Line(580, 860,730, 860)           //COLUNA ANTES DO CAMPO ESTADO
    oPrn:Line(580, 1060,730, 1060)         //COLUNA DEPOIS DO CAMPO ESTADO
    oPrn:Line(580, 1160,650, 1160)         //COLUNA DEPOIS DA DESCRIÇÃO ESTADO
    *
	oPrn:Say(nLinVer  += 20,1810,"PEDIDO",OFONT13N,,,,3)
	oPrn:Say(nLinVer       ,2000,cPedido,OFONT16,,,,3)
	oPrn:Line(nLinVer += 80,1800,nLinVer,2350)
	oPrn:Say(nLinVer  += 50,1810,"DATA",OFONT13N,,,,3)
	oPrn:Say(nLinVer       ,2000,cValToChar(dDtEmis),OFONT16,,,,3)
	oPrn:Line(nLinVer += 90,50,nLinVer,2350)//LINHA 440	
    *
	oPrn:Say(nLinVer += 20,70,"Fornecedor",OFONT11N,,,,3)
	oPrn:Say(nLinVer,340,ALLTRIM(SA2->A2_COD)+" - "+ALLTRIM(SA2->A2_NOME),OFONT11,,,,3) 
	oPrn:Say(nLinVer,1510,"Faturamento",OFONT11N,,,,3)
	oPrn:Say(nLinVer,1810,cValToChar(dDtFatur),OFONT11,,,,3)
	oPrn:Line(nLinVer += 50,50,nLinVer,2350)
	oPrn:Say(nLinVer += 20,70,"Endereço",OFONT11N,,,,3)
	oPrn:Say(nLinVer,340,ALLTRIM(SA2->A2_END),OFONT11,,,,3)
	oPrn:Say(nLinVer,1510,"Pagamento",OFONT11N,,,,3)
	oPrn:Say(nLinVer,1810,ALLTRIM(SE4->E4_DESCRI),OFONT11,,,,3)
	oPrn:Line(nLinVer += 50,50,nLinVer,2350)	
	oPrn:Say(nLinVer += 20,70,"Cidade",OFONT11N,,,,3)
	oPrn:Say(nLinVer,340,ALLTRIM(SA2->A2_MUN),OFONT11,,,,3)
    oPrn:Say(nLinVer ,900,"Estado",OFONT11N,,,,3)
	oPrn:Say(nLinVer,1070,ALLTRIM(SA2->A2_EST),OFONT11,,,,3)
	*
	oPrn:Say(nLinVer,1510,"Contato",OFONT11N,,,,3)
	oPrn:Say(nLinVer,1810,ALLTRIM(cContato),OFONT11,,,,3)
	oPrn:Line(nLinVer += 50,50,nLinVer,2350)
	oPrn:Say(nLinVer += 20,70,"Telefone",OFONT11N,,,,3)
	oPrn:Say(nLinVer,460,ALLTRIM(SA2->A2_TEL),OFONT11,,,,3)
	oPrn:Say(nLinVer,900,"Fax",OFONT11N,,,,3)
	oPrn:Say(nLinVer,1100,ALLTRIM(SA2->A2_FAX),OFONT11,,,,3)
	oPrn:Say(nLinVer,1510,"Prazo entrega",OFONT11N,,,,3)
	oPrn:Say(nLinVer,1810,cValToChar(dDtEntrega),OFONT11,,,,3)
    *
    if lItem
       nLinVer +=50
       oPrn:Line(nLinVer += 50,50,nLinVer,2350)//LINHA APÓS CABEÇALHO DO FORNECEDOR
 
	   *//Quadro de Itens
	   oPrn:Say(nLinVer,60  ,"Item"     ,OFONT11N,,,,3)
	   oPrn:Say(nLinVer,200 ,"Código"   ,OFONT11N,,,,3)
	   oPrn:Say(nLinVer,610 ,"Descrição",OFONT11N,,,,3)
	   oPrn:Say(nLinVer,1340,"Unid."    ,OFONT11N,,,,3)
	   oPrn:Say(nLinVer,1460,"CC"       ,OFONT11N,,,,3)	
	   oPrn:Say(nLinVer,1640,"Qtde."    ,OFONT11N,,,,3)
	   oPrn:Say(nLinVer,1900,"R$ Unit"  ,OFONT11N,,,,3)
	   oPrn:Say(nLinVer,2180,"Pr. Total",OFONT11N,,,,3)
	   *
	   oPrn:Line(nLinVer,50  ,nLinVer + 65,50)
	   oPrn:Line(nLinVer,150 ,nLinVer + 65,150)
	   oPrn:Line(nLinVer,450 ,nLinVer + 65,450)	
       oPrn:Line(nLinVer,1330 ,nLinVer + 65,1330)
	   oPrn:Line(nLinVer,1450 ,nLinVer + 65,1450)
	   oPrn:Line(nLinVer,1600 ,nLinVer + 65,1600)
	   oPrn:Line(nLinVer,1860,nLinVer + 65,1860)
	   oPrn:Line(nLinVer,2120,nLinVer + 65,2120)
	   oPrn:Line(nLinVer,2350,nLinVer + 65,2350)
	   oPrn:Line(nLinVer+50,50,nLinVer+50,2350)
    Endif

Return nLinVer
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ XVERPAG()  ¦ Autor ¦ ORISMAR SILVA        ¦ Data ¦ 21/04/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦Verifica se deve ou nao saltar pagina...                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function xVerPagL()
	//Inicia a montagem da impressao.	
	If	( nLinhaItem >= 2800 ) //2990
     	oPrn:Say(nLinhaItemItem,2079,"Continuação >>",OFONT12,,,,3)
        nLinhaItem += 63
        oPrn:Box (nLinBak,50, nLinBak + ndItem * 63,2350)
   	    oPrn:EndPage()
   	    oPrn:StartPage()
   	    ndItem := 1
   	    nPag++
   	    nLinVer := GeraCabecL()
   	    nLinhaItem := nLinVer += 92
   	    lNewPageRod := .T.                              
	EndIf	
Return  

//---------------------------------------------------------------------------
// Função    | RSMATR110| Autor | Orismar Silva           | Data | 27/04/15 |
//---------------------------------------------------------------------------
// Descrição | Emissão do Pedido de Compras Outros Estados                  |
//---------------------------------------------------------------------------
User Function RRMATR110(cAlias,nReg,nOpcx)

	Local cNomCom, cTelCom               // variavel para buscar o nome e telefone do comprador
//	Local cObs		      := ""
	Local nTotalz	      := 0
	Local nTotal	      := 0
	Local nTotalIpi      := 0
	Local nTotIcms     := 0
	Local nTotIcms4    := 0	
	Local nTotIcms7    := 0
	Local naICMS         := 0		
	Local naICMS4        := 0
	Local naICMS7        := 0
	Local naIPI          := 0
	Local nTotalPis	     := 0
	Local nTotalCofins   := 0	
	Local nPercPis       := 0
	Local nPercCofins    := 0
	Local nTotODesc      := 0
	Local nTotalDIcms    := 0
	Local nTotalDPis	 := 0
	Local nTotalDCofins  := 0	
	Local nTotalDImp     := 0 
	Local aArea 	     := SC7->(GetArea())	
	Local _ndFrete       := 0
	Local aObs           := {}
	Local lICMS4         := .F.
//	Local lICMS7         := .F.
	Local x
    Private nPag         := 1 
	Private oPrn         := TMSPrinter():New( "Pedido de Compra" )
	Private nLinhaItem   := 0
	Private nLinVer      := 0	
    private lItem        := .T.
    //Private cTransp      := "" 
    Private cSolicitante := ""

	SC7->(dbGoTop())
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(xFilial("SC7")+cPedido))

	DEFINE FONT oFont08  NAME "Arial"   SIZE 0,08      OF oPrn
	DEFINE FONT oFont08n NAME "Arial"   SIZE 0,08 Bold OF oPrn
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
	DEFINE FONT oFontX   NAME "Arial"   SIZE 0,09 Bold Italic Underline OF oPrn
	DEFINE FONT oFontY   NAME "Arial"   SIZE 0,09 Bold OF oPrn

	oPrn:SetPortrait() // Estilo retrato
	oPrn:StartPage()   // Inicia uma nova página

	//DADOS DO TOTAL DOS ITENS
	SC1->(DbSetOrder(1))
	SC1->(DbSeek(xFilial("SC1") + SC7->C7_NUMSC))
	cSolicitante := UPPER(SC1->C1_SOLICIT)


	// DADOS DO FORNECEDOR
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA))

	//DADOS DO TOTAL DOS ITENS
	SCR->(DbSetOrder(1))
	SCR->(DbSeek(xFilial("SCR") + "PC" + SC7->C7_NUM))

	//DESCRICAO DA CONDIÇÃO DE PAGAMENTO
	SE4->(DbSetOrder(1))
	SE4->(DbSeek(xFilial("SE4") + SC7->C7_COND))
	dDtEmis     := SC7->C7_EMISSAO 
	dDtEntrega  := SC7->C7_DATPRF 
	cContato    := SC7->C7_CONTATO       
	dDtFatur    := SC7->C7_XDTFAT
	cTransp     := RTRIM(POSICIONE("SA4",1,xFilial("SA4")+SC7->C7_XTRANSP,"A4_NOME"))
	cTpFrete    := IIF(SC7->C7_TPFRETE='C',"CIF",IIF(SC7->C7_TPFRETE='F',"FOB",IIF(SC7->C7_TPFRETE='T',"por Conta Terceiros",IIF(SC7->C7_TPFRETE='R',"por Conta Remetente",IIF(SC7->C7_TPFRETE='D',"por Conta Destinatàrio",IIF(SC7->C7_TPFRETE='S',"Sem frete",""))))))
	nTotalPis	:= SC7->C7_VALIMP6
	nTotalCofins:= SC7->C7_VALIMP5
	nPercPis	:= ROUND(SC7->C7_VALIMP6/SC7->C7_BASIMP6*100,2)
	nPercCofins := ROUND(SC7->C7_VALIMP5/SC7->C7_BASIMP5*100,2)
    *
	nLinVer	:= GeraCabec()
	*
	nLinBak	   := nLinVer
	nLinhaItem := nLinVer += 65
	nTotDesc   := 0
	nItem	   := 1
	ndItem 	   := 1
	lLiber     := .F.  
    cAprov     := ""
    dbSelectArea("SC7")
	If !Empty(SC7->C7_APROV)
	   cTipoSC7:= IIF((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"PC","AE")
	   If SC7->C7_CONAPRO != "B"
	      lLiber := .T.
	   EndIf
	   dbSelectArea("SCR")
	   dbSetOrder(1)
	   dbSeek(xFilial("SCR")+cTipoSC7+SC7->C7_NUM)
	   While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM) == xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO == cTipoSC7
	 		 cAprov += AllTrim(NomeCompleto(SCR->CR_USER))+" ["
			 Do Case
				Case SCR->CR_STATUS=="03" //Liberado
			 		 cAprov += "Ok"
				Case SCR->CR_STATUS=="04" //Bloqueado
					 cAprov += "BLQ"
				Case SCR->CR_STATUS=="05" //Nivel Liberado
					 cAprov += "##"
				OtherWise                 //Aguar.Lib
					 cAprov += "??"
				EndCase
				cAprov += "] - "
				dbSelectArea("SCR")
				dbSkip()
			 Enddo
	EndIf
    *
	While ALLTRIM(SC7->C7_NUM) = cPedido .and. SC7->C7_FILIAL = xFilial("SC7")
        *
		oPrn:Line(nLinhaItem,50  ,nLinhaItem + 65,50)
		oPrn:Line(nLinhaItem,150 ,nLinhaItem + 65,150)
		oPrn:Line(nLinhaItem,450 ,nLinhaItem + 65,450)		
        oPrn:Line(nLinhaItem,1330,nLinhaItem + 65,1330)
	    oPrn:Line(nLinhaItem,1450,nLinhaItem + 65,1450)
	    oPrn:Line(nLinhaItem,1600,nLinhaItem + 65,1600)
	    oPrn:Line(nLinhaItem,1860,nLinhaItem + 65,1860)
	    oPrn:Line(nLinhaItem,2120,nLinhaItem + 65,2120)
	    oPrn:Line(nLinhaItem,2350,nLinhaItem + 65,2350)
        *	
        if empty(ALLTRIM(SC7->C7_OBS))
           cDescri := ALLTRIM(SC7->C7_DESCRI)
        else         
           cDescri := ALLTRIM(SC7->C7_DESCRI)+"-"+ALLTRIM(SC7->C7_OBS)
        endif
        *        
		oPrn:Say(nLinhaItem,  60,ALLTRIM(STR(nItem)),OFONT11,,,,3)
		oPrn:Say(nLinhaItem, 160,ALLTRIM(SC7->C7_PRODUTO),OFONT11,,,,3)
		//oPrn:Say(nLinhaItem, 460,SUBSTR(SC7->C7_DESCRI,1,42),OFONT10,,,,3)		
		oPrn:Say(nLinhaItem, 460,SUBSTR(cDescri,1,37),OFONT10,,,,3)
		oPrn:Say(nLinhaItem,1340,ALLTRIM(SC7->C7_UM),OFONT11,,,,3)
		oPrn:Say(nLinhaItem,1460,ALLTRIM(SC7->C7_CC),OFONT11,,,,3)		
		oPrn:Say(nLinhaItem,1610,Transform(SC7->C7_QUANT,TM(SC7->C7_QUANT,TamSX3("C7_QUANT")[1],TamSX3("C7_QUANT")[2])),OFONT09,,,,3)		
		oPrn:Say(nLinhaItem,1870,Transform(SC7->C7_PRECO,TM(SC7->C7_PRECO,TamSX3("C7_PRECO")[1],TamSX3("C7_PRECO")[2])),OFONT10,,,,3)
		oPrn:Say(nLinhaItem,2130,Transform(SC7->C7_TOTAL,TM(SC7->C7_TOTAL,TamSX3("C7_TOTAL")[1],TamSX3("C7_TOTAL")[2])),OFONT10,,,,3)				
		*
		if LEN(cDescri)> 34
		   For x:=38 to LEN(cDescri) step 37//60
		       nLinhaItem	+= 63
  		       oPrn:Line(nLinhaItem,50  ,nLinhaItem + 65,50)
		       oPrn:Line(nLinhaItem,150 ,nLinhaItem + 65,150)
		       oPrn:Line(nLinhaItem,450 ,nLinhaItem + 65,450)		
               oPrn:Line(nLinhaItem,1330,nLinhaItem + 65,1330)
	           oPrn:Line(nLinhaItem,1450,nLinhaItem + 65,1450)
	           oPrn:Line(nLinhaItem,1600,nLinhaItem + 65,1600)
	           oPrn:Line(nLinhaItem,1860,nLinhaItem + 65,1860)
	           oPrn:Line(nLinhaItem,2120,nLinhaItem + 65,2120)
	           oPrn:Line(nLinhaItem,2350,nLinhaItem + 65,2350)
		       oPrn:Say(nLinhaItem, 460,SUBSTR(cDescri,x,37),OFONT10,,,,3)
		   Next 
		endif			
		*
		nLinhaItem	+= 63
		oPrn:Line(nLinhaItem,50,nLinhaItem,2350)
		nItem 		+= 1
		ndItem 		+= 1
		nPos := AScan(aObs , {|x| x[1] == ALLTRIM(SC7->C7_OBS) })
        
        If nPos == 0
           aadd(aObs,{ALLTRIM(SC7->C7_OBS)})
        Endif  

		_ndFrete	+= SC7->C7_VALFRE
		nTotal 	    += SC7->C7_TOTAL
		nTotalz 	+= SC7->C7_TOTAL - SC7->C7_VLDESC + SC7->C7_VALFRE
		nTotDesc	+= SC7->C7_VLDESC  
		if SC7->C7_PICM = 4
		   naICMS4      := SC7->C7_PICM
		   nTotIcms4  += SC7->C7_VALICM
		endif
		if SC7->C7_PICM = 7		
		   naICMS7      := SC7->C7_PICM 
		   nTotIcms7  += SC7->C7_VALICM
		endif
		if SC7->C7_PICM <> 7	.and. SC7->C7_PICM <> 4	
		   naICMS      := SC7->C7_PICM 
		   nTotIcms  += SC7->C7_VALICM
		endif	
		
		
		naIPI       := SC7->C7_IPI
		cNomCom 	:= Posicione("SY1",3,xFilial("SY1")+SC7->C7_USER,"Y1_NOME")
		cTelCom	    := Posicione("SY1",3,xFilial("SY1")+SC7->C7_USER,"Y1_TEL")
		cMailCom	:= Posicione("SY1",3,xFilial("SY1")+SC7->C7_USER,"Y1_EMAIL")
	
		SC7->(DbSkip())
	
		if ndItem >= 23
		   lNewPageRod := .T.
		EndIf
		
		if ndItem >= 36  .OR. nLinhaItem > 3270
    	   oPrn:Say(nLinhaItem,2079,"Continuação >>",OFONT12,,,,3)
    	   nLinhaItem	+= 63
    	   iif(!lLiber,oPrn:Say(nLinhaItem,990,"** Pedido de Compra não aprovado. **",oFont12,,,,3),"")
		   oPrn:Box (nLinBak,50, nLinBak + ndItem * 60,2350)
		   oPrn:EndPage()
		   oPrn:StartPage()
		   ndItem := 1
		   nPag++
		   nLinVer := GeraCabec()
		   nLinhaItem := nLinVer += 62
		   lNewPageRod := .T.
		EndIf
		
	EndDo
    *
    lItem := .F.
    xVerPag()
	nLinha   := nLinhaItem
	nQtdItem := 1
	*
	oPrn:Line(nLinhaItemItem,50,nLinhaItem+60,50)
	oPrn:Line(nLinhaItem,2350,nLinhaItem+60,2350)
	oPrn:Say(nLinhaItem+10,730,'Valor Total dos Produtos:    ',oFont10N)
	oPrn:Say(nLinhaItem+10,2130,Transform(nTotal, "@E 999,999,999.99"),oFont10)
	nLinhaItem += 60
	oPrn:Line(nLinhaItem,50,nLinhaItem,2350)
    *
	xVerPag()
    *
  	oPrn:Line(nLinhaItemItem,50,nLinhaItem+60,50)
	oPrn:Line(nLinhaItem,2350,nLinhaItem+60,2350)
	oPrn:Say(nLinhaItem+10,70,'Suspensão do I.P.I. para mercadorias de origem nacional e imp. nacionalizadas.',oFont10)
	oPrn:Line(nLinhaItem,1590,nLinhaItem+60,1590)
	oPrn:Say(nLinhaItem+10,1600,"I.P.I.",oFont10)
	oPrn:Line(nLinhaItem,1860,nLinhaItem+60,1860) 
	oPrn:Say(nLinhaItem+10,1870,Transform(naIPI,TM(naIPI,TamSX3("C7_IPI")[1],TamSX3("C7_IPI")[2]))+"%",oFont10N)      
	oPrn:Line(nLinhaItem,2120,nLinhaItem+60,2120)
	oPrn:Line(nLinhaItem,2350,nLinhaItem+60,2350)
	oPrn:Say(nLinhaItem+10,2130,Transform(nTotalIpi, "@E 999,999,999.99"),oFont10)
	nLinhaItem += 60
	oPrn:Line(nLinhaItem,50,nLinhaItem,2350)
    *
	xVerPag()
    *
  	oPrn:Line(nLinhaItemItem,50,nLinhaItem+150,50)// 1 primeira coluna
	oPrn:Line(nLinhaItem,1590,nLinhaItem+150,1590)// Coluna antes do ICMS
	oPrn:Line(nLinhaItem,1860,nLinhaItem+150,1860)// Coluna após do ICMS
	oPrn:Line(nLinhaItem,2120,nLinhaItem+150,2120)// Coluna após 0%
	oPrn:Line(nLinhaItem,2350,nLinhaItem+150,2350)// Coluna final
	*
	oPrn:Say(nLinhaItem+10,70,"Somente para produtos insdutrializados de origem nacional para comercialização, consumo",oFont10)
	oPrn:Say(nLinhaItem+90,70,"ou industrialização na ZFM - o Imobilizado não possui desconto.",oFont10)
	oPrn:Say(nLinhaItem+90,1450,"SP=7%",oFont10N)
	oPrn:Say(nLinhaItem+30,1600,"ICMS",oFont10N)
	if naICMS4 > 0 
	   oPrn:Say(nLinhaItem+30,1870,Transform(naICMS4,TM(naICMS4,TamSX3("C7_PICM")[1],TamSX3("C7_PICM")[2]))+"%",oFont10N)	
	   oPrn:Say(nLinhaItem+30,2130,Transform(nTotIcms4, "@E 999,999,999.99"),oFont10)
	   lICMS4 := .T.
	endif
	if naICMS7 > 0                                                      
	   oPrn:Line(nLinhaItem+90,1860,nLinhaItem+90,2350)// Coluna após do ICMS
	   oPrn:Say(iif(lICMS4,nLinhaItem+90,nLinhaItem+30),1870,Transform(naICMS7,TM(naICMS7,TamSX3("C7_PICM")[1],TamSX3("C7_PICM")[2]))+"%",oFont10N)	
	   oPrn:Say(iif(lICMS4,nLinhaItem+90,nLinhaItem+30),2130,Transform(nTotIcms7, "@E 999,999,999.99"),oFont10)
	endif
	if naICMS > 0
	   oPrn:Say(nLinhaItem+30,1870,Transform(naICMS,TM(naICMS,TamSX3("C7_PICM")[1],TamSX3("C7_PICM")[2]))+"%",oFont10N)	
	   oPrn:Say(nLinhaItem+30,2130,Transform(nTotIcms, "@E 999,999,999.99"),oFont10)
    endif
	
	nLinhaItem += 150
	oPrn:Line(nLinhaItem,50,nLinhaItem,2350)
    *
	xVerPag()
    *
  	oPrn:Line(nLinhaItemItem,50,nLinhaItem+180,50)// 1 primeira coluna   
	oPrn:Line(nLinhaItem,960,nLinhaItem+180,960)// Coluna antes do Lucro Real
	oPrn:Line(nLinhaItem,1280,nLinhaItem+180,1280)// Coluna antes do Lucro Presumido
	oPrn:Line(nLinhaItem,1590,nLinhaItem+180,1590)// Coluna antes do PIS
	oPrn:Line(nLinhaItem+50,1860,nLinhaItem+180,1860)// Coluna após do PIS
	oPrn:Line(nLinhaItem+50,2120,nLinhaItem+180,2120)// Coluna após 0,65%
	oPrn:Line(nLinhaItem,2350,nLinhaItem+180,2350)// Coluna final
	oPrn:Line(nLinhaItem+50,960,nLinhaItem+50,2350)// Linha abaixo do Lucro Real
	oPrn:Line(nLinhaItem+110,960,nLinhaItem+110,2350)// Linha abaixo do PIS= 1,65%
	*	
	oPrn:Say(nLinhaItem+10,70,"Lei 10996/04 isenta PIS/COFINS para Z.F. Manaus",oFont10)
	oPrn:Say(nLinhaItem+60,70,"Portaria 162/05 da SUFRAMA determina descontos",oFont10)
	oPrn:Say(nLinhaItem+120,70,"na Nota Fiscal, repassando os incentivos.",oFont10)
	oPrn:Say(nLinhaItem+10,990,"Lucro Real",oFont10N)
	oPrn:Say(nLinhaItem+10,1290,"Lucro Presumido",oFont10N)
	oPrn:Say(nLinhaItem+60,990,"PIS= 1,65%",oFont10)
    oPrn:Say(nLinhaItem+60,1290,"PIS= 0,65%",oFont10)
	oPrn:Say(nLinhaItem+60,1600,"PIS",oFont10N)
	oPrn:Say(nLinhaItem+60,1870,"",oFont10N)
	if nPercPis > 0
	    oPrn:Say(nLinhaItem+60,1870,Transform(nPercPis,TM(nPercPis,TamSX3("C7_PICM")[1],TamSX3("C7_PICM")[2]))+"%",oFont10N)	
	endif
	oPrn:Say(nLinhaItem+60,2130,Transform(nTotalPis, "@E 999,999,999.99"),oFont10)
    oPrn:Say(nLinhaItem+120,990,"COFINS= 7,6%",oFont10)
    oPrn:Say(nLinhaItem+120,1290,"COFINS= 3%",oFont10)
	oPrn:Say(nLinhaItem+120,1600,"COFINS",oFont10N)
	oPrn:Say(nLinhaItem+120,1870,"",oFont10N)     
	if nPercCofins > 0
	   oPrn:Say(nLinhaItem+120,1870,Transform(nPercCofins,TM(nPercCofins,TamSX3("C7_PICM")[1],TamSX3("C7_PICM")[2]))+"%",oFont10N)	
	endif
	oPrn:Say(nLinhaItem+120,2130,Transform(nTotalCofins, "@E 999,999,999.99"),oFont10)
	nLinhaItem += 180
	oPrn:Line(nLinhaItem,50,nLinhaItem,2350)
    *
	xVerPag()
    *
	oPrn:Line(nLinhaItem,960,nLinhaItem+60,960)
	oPrn:Line(nLinhaItem,2120,nLinhaItem+60,2120)
	oPrn:Line(nLinhaItem,2350,nLinhaItem+60,2350)
	oPrn:Say(nLinhaItem+10,990,"Frete     ",oFont10)
	oPrn:Say(nLinhaItem+10,2130,Transform(_ndFrete, "@E 999,999,999.99"),oFont10)
	nLinhaItem += 60
	oPrn:Line(nLinhaItem,960,nLinhaItem,2350)
    *
	xVerPag()
    *
	oPrn:Line(nLinhaItem,960,nLinhaItem+60,960)
	oPrn:Line(nLinhaItem,2120,nLinhaItem+60,2120)
	oPrn:Line(nLinhaItem,2350,nLinhaItem+60,2350)
	oPrn:Say(nLinhaItem+10,990,"Total de Desconto     ",oFont10)
	oPrn:Say(nLinhaItem+10,2130,Transform(nTotDesc, "@E 999,999,999.99"),oFont10)
	nLinhaItem += 60
	oPrn:Line(nLinhaItem,960,nLinhaItem,2350)
    *
	xVerPag()
	*
	oPrn:Line(nLinhaItem,960,nLinhaItem+60,960)
	oPrn:Line(nLinhaItem,2120,nLinhaItem+60,2120)
	oPrn:Line(nLinhaItem,2350,nLinhaItem+60,2350)
	oPrn:Say(nLinhaItem+10,990,"Outros Desconto     ",oFont10)
	oPrn:Say(nLinhaItem+10,2130,Transform(nTotODesc, "@E 999,999,999.99"),oFont10)
	nLinhaItem += 60
	oPrn:Line(nLinhaItem,960,nLinhaItem,2350)
    *
	xVerPag()
	*  
	oPrn:Line(nLinhaItem,960,nLinhaItem+60,960)
	oPrn:Line(nLinhaItem,2120,nLinhaItem+60,2120)
	oPrn:Line(nLinhaItem,2350,nLinhaItem+60,2350)
	oPrn:Say(nLinhaItem+10,160,"Importante!",oFont10N)
	oPrn:Say(nLinhaItem+10,990,"Valor Total do Pedido (total da Nota Fiscal)        ",oFont10N)
	oPrn:Say(nLinhaItem+10,2130,Transform(nTotalz, "@E 999,999,999.99"),oFont10)
	nLinhaItem += 60
	oPrn:Line(nLinhaItem,960,nLinhaItem,2350)
	*
	xVerPag()                 	
	*
	oPrn:Say(nLinhaItem,60,"- Descrever no corpo da Nota Fiscal:",oFont10)
	nLinhaItem += 50
	*
	xVerPag()
	*
	nTotalDImp +=nTotalDIcms+nTotalDPis+nTotalDCofins
	oPrn:Line(nLinhaItem,50,nLinhaItem,1280)
	oPrn:Line(nLinhaItem,50,nLinhaItem+250,50)
	oPrn:Line(nLinhaItem,960,nLinhaItem+250,960)
	oPrn:Line(nLinhaItem,1280,nLinhaItem+250,1280)
	oPrn:Say(nLinhaItem+10 ,60,"Desconto de ICMS 7% (se não for imobilizado).....",oFont10)
	oPrn:Say(nLinhaItem+60 ,60,"Desconto de PIS 1,65% ou 0,65%...................",oFont10)
	oPrn:Say(nLinhaItem+120,60,"Desconto de COFINS 7,6% ou 3,0%..................",oFont10)
	oPrn:Say(nLinhaItem+10,970,Transform(nTotalDIcms, "@E 999,999,999.99"),oFont10)
	oPrn:Say(nLinhaItem+60,970,Transform(nTotalDPis, "@E 999,999,999.99"),oFont10)
	oPrn:Say(nLinhaItem+120,970,Transform(nTotalDCofins, "@E 999,999,999.99"),oFont10)    
	oPrn:Line(nLinhaItem+170,50,nLinhaItem+170,1280)
	oPrn:Say(nLinhaItem+180,60,"Total de Descontos...............................",oFont10)
	oPrn:Say(nLinhaItem+180,970,Transform(nTotalDImp, "@E 999,999,999.99"),oFont10)    
	nLinhaItem += 250
	oPrn:Line(nLinhaItem,50,nLinhaItem,1280)
	*
  	nLinhaItem += 80
  	xVerPag()
  	nLinhaItem += 80
    oPrn:Box(nLinhaItem,100,nLinhaItem+300,2350)   
    oPrn:Line(nLinhaItem,550,nLinhaItem+300,550)
    oPrn:Line(nLinhaItem,1000,nLinhaItem+300,1000)
    oPrn:Line(nLinhaItem,1450,nLinhaItem+300,1450)
    oPrn:Line(nLinhaItem,1900,nLinhaItem+300,1900)   
    //xVerPag()
    nLinhaItem += 10
	oPrn:Say(nLinhaItem,220  ,'Resp. Compras'    ,oFont12)
	oPrn:Say(nLinhaItem,650  ,'Resp. Depto.'   ,oFont12)	
	oPrn:Say(nLinhaItem,1100 ,'Ger. Contábil'   ,oFont12)
	oPrn:Say(nLinhaItem,1550 ,'Ger. Adm.'       ,oFont12)
	oPrn:Say(nLinhaItem,2000 ,'Diretor' ,oFont12)
	nLinhaItem += 50
	xVerPag()	
	oPrn:Line(nLinhaItem,100,nLinhaItem,2350)
	nLinhaItem += 10
	xVerPag()	
    *
	nLinhaItem +=170
	xVerPag()	
	oPrn:Say(nLinhaItem,250 ,DTOC(dDtEmis) ,oFont12)
    oPrn:Say(nLinhaItem,700 ,DTOC(dDtEmis) ,oFont12)
	oPrn:Say(nLinhaItem,1150,DTOC(dDtEmis) ,oFont12)
	oPrn:Say(nLinhaItem,1600,DTOC(dDtEmis) ,oFont12)	
	oPrn:Say(nLinhaItem,2050,DTOC(dDtEmis) ,oFont12)		
	nLinhaItem +=100
	xVerPag()	    
    *
	oPrn:Box(nLinhaItem,50,nLinhaItem+550,2350)	
	nLinhaItem +=10
	xVerPag()	
	oPrn:Say(nLinhaItem,055,"****Outros pontos Importantes:",oFont08N,,,,3)
	oPrn:Say(nLinhaItem+=30,055,"* NÃO ENVIAR NOTAS FISCAIS VIA CORREIO",oFont08N,,,,3)
	oPrn:Say(nLinhaItem+=30,055,"* Enviar cópia da Nota Fiscal para: fiscal.hisamitsu@salonpas.ind.br",oFont08N,,,,3)
	oPrn:Say(nLinhaItem+=30,055,"* Emitir o PIN (PROTOCOLO INGRESSO DE MERCADORIA NACIONAL) e anexar junto a Nota Fiscal.",oFont08N,,,,3)
	oPrn:Say(nLinhaItem+=30,055,"* Constar o número do pedido na Nota Fiscal.",oFont08N,,,,3)
	oPrn:Say(nLinhaItem+=30,055,"****Descrever também no corpo da nota fiscal:",oFont08N,,,,3)
	oPrn:Say(nLinhaItem+=30,055,"* Inscrição SUFRAMA 200156-730",oFont08N,,,,3)
	oPrn:Say(nLinhaItem+=30,055,"* SUSPENSÃO IPI-MERCADORIA DESTINADA A ZONA FRANCA DE MANAUS.",oFont08N,,,,3)
	oPrn:Say(nLinhaItem+=30,055,"* ISENTO DE ICMS CONF. ART.84 RICMS/SP DEC. 45490/00 (SP)",oFont08N,,,,3)
	oPrn:Say(nLinhaItem+=30,055,"* DESC. ICMS CONF. ART.84, INCISO IV, ANEXO DO RICMS/00",oFont08N,,,,3)	
	oPrn:Say(nLinhaItem+=30,055,"* DESC.PIS/COFINS CONF.LEI 10996/2004 E PORTARIA SUFRAMA 162/2005.",oFont08N,,,,3)	
	*
    nLinhaItem += 30
	xVerPag()
	if nLinhaItem = 902 //1052
      oPrn:Box(nLinhaItem,50,nLinhaItem+300,2350)
    endif                      
   
	oPrn:Say(nLinhaItem += 10,055,"Nota Fiscal em nome de:",oFont08,,,,3)
	oPrn:Say(nLinhaItem += 30,055,Alltrim(SM0->M0_NOMECOM),oFont08N,,,,3)
	//oPrn:Say(nLinhaItem += 30,055,Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_CIDENT)+" - "+Alltrim(SM0->M0_ESTENT)+" Tel: (92) 3613-3072",oFont08N,,,,3)
	oPrn:Say(nLinhaItem += 30,055,Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_CIDENT)+" - "+Alltrim(SM0->M0_ESTENT)+" Tel: ("+SUBSTR(SM0->M0_TEL,1,2)+") "+SUBSTR(SM0->M0_TEL,4,LEN(LTRIM(SM0->M0_TEL))),oFont08N,,,,3)
	//oPrn:Say(nLinhaItem += 30,055,"CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ " I.E.: "+Transform(SM0->M0_INSC,"@R 99.999.999-9")+ " SUFRAMA: "+Transform(SM0->M0_INS_SUF,"@R 999999-999"),oFont09N,,,,3)	
	oPrn:Say(nLinhaItem += 30,055,"CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+ " I.E.: "+LTRIM(SM0->M0_INSC)+ " SUFRAMA: "+Transform(SM0->M0_INS_SUF,"@R 999999-999"),oFont09N,,,,3)
    nLinhaItem += 30
	oPrn:Say(nLinhaItem += 100,055 ,"Solicitante:",oFont08N,,,,3)	
	oPrn:Say(nLinhaItem       ,250 ,cSolicitante  ,oFont08N,,,,3)	
	oPrn:Say(nLinhaItem       ,1800,"Mod. ADM 020",oFont08N,,,,3)	
	oPrn:Say(nLinhaItem += 50 ,1800,"Rev. 07",oFont08N,,,,3)	
	oPrn:EndPage()     // Finaliza a página
	oPrn:Preview()     // Visualiza antes de imprimir
	SC7->(RestArea(aArea))

Return

//---------------------------------------------------------------------------
//    imprimir cabecalho
//---------------------------------------------------------------------------
Static Function GeraCabec()

	Local nLinVer := 0

	//Quadro Cabeçalho
	oPrn:Box(200,50,730,2350)// Caixa Pricipal do cabeçalho
	
	//             L     C                 L    C
	oPrn:SayBitmap(210, 120, "lgrlped.bmp",300, 200)//	oPrn:SayBitmap(210, 160, "galo.bmp",430, 440)
    *
    oPrn:Say(210,700,Alltrim(SM0->M0_NOMECOM),OFONT11N,,,,3)     
	oPrn:Say(280,800,"PEDIDO DE COMPRAS",OFONT16N,,,,3)
    *
    oPrn:Line(nLinVer += 200,1800,600,1800)//COLUNA ANTES DO PEDIDO E DATA
    oPrn:Line(nLinVer,1990,440,1990)
  	oPrn:Line(nLinVer, 520,440, 520)       //COLUNA DEPOIS LOGO
    oPrn:Line(440, 340,730, 340)           //COLUNA DEPOIS DO CAMPO FORNECEDOR
    oPrn:Line(440, 1500,730, 1500)         //COLUNA ANTES DO CAMPO PAGAMENTO
    oPrn:Line(440, 1800,730, 1800)         //COLUNA DEPOIS DO CAMPO PAGAMENTO   
    oPrn:Line(580, 860,730, 860)           //COLUNA ANTES DO CAMPO ESTADO
    oPrn:Line(580, 1060,730, 1060)         //COLUNA DEPOIS DO CAMPO ESTADO
    oPrn:Line(580, 1160,650, 1160)         //COLUNA DEPOIS DA DESCRIÇÃO ESTADO
    oPrn:Line(580, 2060,650, 2060)         //COLUNA DEPOIS DO CAMPO FATURAMENTO
    *
	oPrn:Say(nLinVer  += 20,1810,"PEDIDO",OFONT13N,,,,3)
	oPrn:Say(nLinVer       ,2000,cPedido,OFONT16,,,,3)
	oPrn:Line(nLinVer += 80,1800,nLinVer,2350)
	oPrn:Say(nLinVer  += 50,1810,"DATA",OFONT13N,,,,3)
	oPrn:Say(nLinVer       ,2000,cValToChar(dDtEmis),OFONT16,,,,3)
	oPrn:Line(nLinVer += 90,50,nLinVer,2350)//LINHA 440	
    *
	oPrn:Say(nLinVer += 20,70,"Fornecedor",OFONT11N,,,,3)
	oPrn:Say(nLinVer,350,ALLTRIM(SA2->A2_COD)+" - "+ALLTRIM(SA2->A2_LOJA)+" - "+ALLTRIM(SA2->A2_NOME),OFONT10,,,,3)
	oPrn:Say(nLinVer,1510,"E-mail",OFONT11N,,,,3)
	oPrn:Say(nLinVer,1810,ALLTRIM(SA2->A2_EMAIL),OFONT10,,,,3)
	oPrn:Line(nLinVer += 50,50,nLinVer,2350)//LINHA 510	
	oPrn:Say(nLinVer += 20,70,"Endereço",OFONT11N,,,,3)
	oPrn:Say(nLinVer,350,ALLTRIM(SA2->A2_END),OFONT11,,,,3)
	oPrn:Say(nLinVer,1510,"Contato",OFONT11N,,,,3)
	oPrn:Say(nLinVer,1810,ALLTRIM(cContato),OFONT11,,,,3)
	oPrn:Line(nLinVer += 50,50,nLinVer,2350)//LINHA 580		
	oPrn:Say(nLinVer += 20,70,"Cidade",OFONT11N,,,,3)
	oPrn:Say(nLinVer,350,ALLTRIM(SA2->A2_MUN),OFONT11,,,,3)
    oPrn:Say(nLinVer ,900,"Estado",OFONT11N,,,,3)
	oPrn:Say(nLinVer,1070,ALLTRIM(SA2->A2_EST),OFONT11,,,,3)	
	oPrn:Say(nLinVer,1170,"Pagamento",OFONT11N,,,,3)           
	oPrn:Say(nLinVer,1510,ALLTRIM(SE4->E4_DESCRI),OFONT11,,,,3)
	oPrn:Say(nLinVer,1810,"Faturamento",OFONT11N,,,,3) 
    oPrn:Say(nLinVer,2070,cValToChar(dDtFatur),OFONT11,,,,3)
	oPrn:Line(nLinVer += 50,50,nLinVer,2350)//LINHA 650	
	oPrn:Say(nLinVer += 20,70,"Telefone",OFONT11N,,,,3)
	oPrn:Say(nLinVer,360,ALLTRIM(SA2->A2_TEL),OFONT11,,,,3)
	oPrn:Say(nLinVer,890,"Tp. Frete",OFONT11N,,,,3)
	oPrn:Say(nLinVer,1100,cTpFrete,OFONT11,,,,3)
	oPrn:Say(nLinVer,1510,"Prazo entrega",OFONT11N,,,,3)
	oPrn:Say(nLinVer,1810,cValToChar(dDtEntrega),OFONT11,,,,3)
	nLinVer := 730
	oPrn:Box(nLinVer,50,nLinVer+130,2350)// Caixa Pricipal do cabeçalho 
	oPrn:Say(nLinVer+=10,50,PADC("TRANSPORTADORAS HOMOLOGADAS",150),OFONT11N,,,,3)
	oPrn:Line(nLinVer += 50,50,nLinVer,2350)    
	//oPrn:Say(nLinVer+=10,00,PADC("EXATA CARGO: (11) 2085-5771 /(92) 4009-0000",150),OFONT10,,,,3)
	oPrn:Say(nLinVer+=10,00,PADC(cTransp,150),OFONT10,,,,3)
    *
    if lItem
       oPrn:Line(nLinVer += 60,50,nLinVer,2350)//LINHA APÓS CABEÇALHO DO FORNECEDOR
	   *//Quadro de Itens
	   oPrn:Say(nLinVer,60  ,"Item"     ,OFONT11N,,,,3)
	   oPrn:Say(nLinVer,200 ,"Código"   ,OFONT11N,,,,3)
	   oPrn:Say(nLinVer,610 ,"Descrição",OFONT11N,,,,3)
	   oPrn:Say(nLinVer,1340,"Unid."    ,OFONT11N,,,,3)
	   oPrn:Say(nLinVer,1460,"CC"       ,OFONT11N,,,,3)	
	   oPrn:Say(nLinVer,1640,"Qtde."    ,OFONT11N,,,,3)
	   oPrn:Say(nLinVer,1900,"   Unit"  ,OFONT11N,,,,3)
	   oPrn:Say(nLinVer,2180,"Pr. Total",OFONT11N,,,,3)
	   *
	   oPrn:Line(nLinVer,50  ,nLinVer + 65,50)
	   oPrn:Line(nLinVer,150 ,nLinVer + 65,150)
	   oPrn:Line(nLinVer,450 ,nLinVer + 65,450)	
       oPrn:Line(nLinVer,1330 ,nLinVer + 65,1330)
	   oPrn:Line(nLinVer,1450 ,nLinVer + 65,1450)
	   oPrn:Line(nLinVer,1600 ,nLinVer + 65,1600)
	   oPrn:Line(nLinVer,1860,nLinVer + 65,1860)
	   oPrn:Line(nLinVer,2120,nLinVer + 65,2120)
	   oPrn:Line(nLinVer,2350,nLinVer + 65,2350)
	   oPrn:Line(nLinVer+50,50,nLinVer+50,2350)
	   *
    Endif

Return nLinVer
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ XVERPAG()  ¦ Autor ¦ ORISMAR SILVA        ¦ Data ¦ 21/04/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦Verifica se deve ou nao saltar pagina...                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function xVerPag()

	//Inicia a montagem da impressao.	
	If	( nLinhaItem >= 2600) //2600
     	oPrn:Say(nLinhaItemItem,2079,"Continuação >>",OFONT12,,,,3)
        nLinhaItem += 63
        oPrn:Box (nLinBak,50, nLinBak + ndItem * 63,2350)
   	    oPrn:EndPage()
   	    oPrn:StartPage()
		ndItem := 1
   	    nPag++
   	    nLinVer := GeraCabec()
   	    nLinhaItem := nLinVer += 92
   	    lNewPageRod := .T.                              
	EndIf	
Return                                  

Static Function NomeCompleto(cUser)
	Local cQry, aArea, cTmp
	Local cRet := ""
	
	If MsFile("SYS_USR")    // Se existe a tabela de usuários
		aArea := GertArea()
		cTmp  := GetNextAlias()
		cQry  := "SELECT USR_NOME FROM SYS_USR WHERE USR_ID = '" +cUser+ "'"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTmp,.T.,.T.)
		cRet := (cTmp)->USR_NOME
		dbCloseArea()
		RestArea(aArea)
	Else
		cRet := UsrFullName(cUser)
	Endif

Return cRet
