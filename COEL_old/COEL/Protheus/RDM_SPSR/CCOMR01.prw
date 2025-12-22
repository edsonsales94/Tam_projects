/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CCOMR01  ³ Por: Adalberto Moreno Batista ³ Data ³ 27/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao de relatorio grafico de pedido de compras        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico PDV Brasil                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch"

User Function CCOMR01()
Local _aRegs		:= {}
Local _cPerg		:= PadR("COMR01",Len(SX1->X1_GRUPO))
Local _aCabSX1		:= {"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_GSC","X1_VAR01","X1_DEF01","X1_DEF02"}

//parametros para o processamento
aAdd(_aRegs,{_cPerg,"01","Do Pedido?       ","mv_ch1","C",06,0,"G","mv_par01","",""})
aAdd(_aRegs,{_cPerg,"02","Ate Pedido?      ","mv_ch2","C",06,0,"G","mv_par02","",""})
aAdd(_aRegs,{_cPerg,"03","Da Emissão?      ","mv_ch3","D",08,0,"G","mv_par03","",""})
aAdd(_aRegs,{_cPerg,"04","Ate Emissão?     ","mv_ch4","D",08,0,"G","mv_par04","",""})
//aAdd(_aRegs,{_cPerg,"05","Somente os novos?","mv_ch5","N",01,0,"G","mv_par05","Sim","Todos"})
//aAdd(_aRegs,{_cPerg,"06","Descricao Produto","mv_ch6","N",01,0,"G","mv_par05","Produto","Pedido","Compl.Prod."})

//U_PDVSX1(_aRegs,_aCabSX1)

if Pergunte(_cPerg,.T.)
	U_IMPCOMR01(.T.)
endif
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao³ IMPCOMR01    ³ Por: Adalberto Moreno Batista ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPCOMR01(lPedCom)
Local cPedIni, cPedFim, dEmiIni, dEmiFim
Local cLogo		:= "\SYSTEM\LGRL0101.BMP"
Local nK, nQ
Local nPag := 1
Local _nLin := 0
// Cria os objetos de fontes que serao utilizadas na impressao do relatorio
Local cLogo		:= "\SYSTEM\LGRL0101.BMP"
Private oFont7 := TFont():New("Arial",9,7 ,.T.,.F.,5,.T.,5,.T.,.F.)	// titulos de campos e itens do pedido
Private oFont8 := TFont():New("Arial",9,7.5,.T.,.F.,5,.T.,5,.T.,.F.)	// fornecedor         
Private oFont9 := TFont():New("Arial",9,8.5,.T.,.F.,5,.T.,5,.T.,.F.)	// cabecalho e rodapes
Private oFont9n:= TFont():New("Arial",9,8.5,.T.,.T.,5,.T.,5,.T.,.F.)	// cabecalho e rodapes Bold
Private oFont10:= TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)	// pedido de compra
Private oFont16:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)	// mumero do pedido de compras

if lPedCom = NIL
	cPedIni := cPedFim := SC7->C7_NUM
	dEmiIni	:= dEmiFim := SC7->C7_EMISSAO
else
	cPedIni := mv_par01
	cPedFim := mv_par02
	dEmiIni	:= mv_par03
	dEmiFim	:= mv_par04
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seta as ordens de pesquisa das tabelas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SA2->(dbSetOrder(1))
SA5->(dbSetOrder(1))
SAJ->(dbSetOrder(1))
SAH->(dbSetOrder(1))
SB1->(dbSetOrder(1))
SB5->(dbSetOrder(1))
SC7->(dbSetOrder(1))
SCR->(dbSetOrder(1))
SE4->(dbSetOrder(1))
dbSelectArea("SC7")

oPC := TMSPrinter():New()
oPC:SetPortrait()
oPC:Setup()
oPC := ReturnPrtObj()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimentacao das variaveis de impressao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SC7->(dbSeek(xFilial("SC7")+cPedIni,.T.))
do while SC7->(!eof() .and. C7_NUM <= cPedFim)
	
	SA2->(dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
	cLin1For 	:= SA2->A2_NOME
	cLin2For	:= SA2->A2_END+space(10)+AllTrim(SA2->A2_BAIRRO)
	cLin3For	:= SA2->A2_MUN+space(40)+"CEP: "+Transform(SA2->A2_CEP,"@R 99999-999")
	cLin4For	:= "CNPJ: "+Transform(AllTrim(SA2->A2_CGC),"@R 99.999.999/9999-99")+space(30)+"IE: "+AllTrim(SA2->A2_INSCR)
	cLin5For	:= "A/C "+AllTrim(SC7->C7_CONTATO)+space(40)+"TEL: "+AllTrim(SA2->A2_TEL)+space(40)+"FAX: "+AllTrim(SA2->A2_FAX)

	nReemissao	:= SC7->C7_QTDREEM + 1
	cPedCom		:= SC7->C7_NUM
	aItSC7		:= {}
	cDescontos	:= 	TransForm(SC7->C7_DESC1,"999.99" ) + " %    " + ;
					TransForm(SC7->C7_DESC2,"999.99" ) + " %    " + ;
					TransForm(SC7->C7_DESC3,"999.99" ) + " %"
	nValDesc 	:= 0
	cReajuste	:= ""
	cCondPag	:= ""
	if SE4->(dbSeek(xFilial("SE4")+SC7->C7_COND))
		cCondPag	:= AllTrim(SC7->C7_COND)+" - "+AllTrim(SE4->E4_DESCRI)
	endif
	if SM4->(dbSeek(xFilial("SM4")+SC7->C7_REAJUST))
		cReajuste	:= SM4->M4_DESCR
	endif
	cFrete		:= iif(SC7->C7_TPFRETE="F","FOB",iif(SC7->C7_TPFRETE="C","CIF",""))
//	cObsRodap 	:= Formula(C7_MSG)
	cObsRodap	:= "NOTA: Só aceitaremos a mercadoria se na sua Nota Fiscal constar o número do nosso Pedido de Compras. "

	MaFisEnd()
	MaFisIniPC(SC7->C7_NUM,,,"")


	nTotIpi	  	:= MaFisRet(,'NF_VALIPI')
	nTotIcms  	:= MaFisRet(,'NF_VALICM')
	nTotDesp  	:= MaFisRet(,'NF_DESPESA')
	nTotFrete 	:= MaFisRet(,'NF_FRETE')
	nTotSeguro	:= MaFisRet(,'NF_SEGURO')
	nTotalNF  	:= MaFisRet(,'NF_TOTAL')
	nPag		:= 1

	do while SC7->(!eof() .and. C7_NUM = cPedCom)
		if SC7->C7_EMISSAO < dEmiIni .or. SC7->C7_EMISSAO > dEmiFim .or. SC7->C7_TIPO != 1
			SC7->(dbSkip())
			Loop
		endif

		SB1->(dbSeek(xFilial("SB1")+SC7->C7_PRODUTO))	//SB1->B1_DESC
		SB5->(dbSeek(xFilial("SB5")+SC7->C7_PRODUTO))	//SB5->B5_CEME
		
		cDescr := AllTrim(SC7->C7_DESCRI)+ " " + AllTrim(SC7->C7_OBS)
		
		//Codigo de produto do fornecedor
		if SA5->(dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO)) .and. !empty(SA5->A5_CODPRF)
			cDescr += " ("+AllTrim(A5_CODPRF)+")"
		endif

		//Codigo de unidade de medida
		if SAH->(dbSeek(xFilial("SAH")+SC7->C7_UM)) .and. !empty(SAH->AH_UMRES)
			cUM := AllTrim(SAH->AH_UMRES)
		else
			cUM := AllTrim(SC7->C7_UM)
		endif

		//Calculo de descontos
		If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
			nValDesc	+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
		Else
			nValDesc	+= SC7->C7_VLDESC
		Endif

		aAdd(aItSC7,{SC7->C7_ITEM, SC7->C7_PRODUTO, cDescr, cUM, SC7->C7_QUANT, SC7->C7_PRECO, SC7->C7_TOTAL, SC7->C7_IPI, SC7->C7_DATPRF, SC7->(recno())})

		SC7->(dbSkip())

	enddo

    _nRegistro := SC7->(Recno())	
	MaFisEnd()
	for nK := 1 to Len(aItSC7)
		SC7->(dbGoto(aItSC7[nK,10]))
		SC7->(RecLock("SC7",.F.))		  //Atualizacao do flag de Impressao
		SC7->C7_QTDREEM	:= nReemissao
		SC7->C7_EMITIDO	:= "S"
		SC7->(MsUnLock())
	next
	SC7->(dbGoto(_nRegistro))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o objeto de impressao                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if len(aItSC7) > 0
	
		_nLin := Imp_Cabec(_nLin,oPC,cLogo,nPag)
	
		oPC:Box(_nLin+000, 0070, _nLin+270,2330)
		oPC:Say(_nLin+020, 0100, "Dados do Fornecedor",oFont7,100)
		oPC:Say(_nLin+060, 0100, cLin1For, oFont10, 100)
		oPC:Say(_nLin+100, 0100, cLin2For, oFont10, 100)
		oPC:Say(_nLin+140, 0100, cLin3For, oFont10, 100)
		oPC:Say(_nLin+180, 0100, cLin4For, oFont10, 100)
		oPC:Say(_nLin+220, 0100, cLin5For, oFont10, 100)
		
		_nLin := 590
	
		_nLin := Imp_CabItem(_nLin,oPC)
		
		//imprimindo os itens
		for nK:=1 to Len(aItSC7)
		
			if _nLin > 2200 .and. nPag = 1
				nPag++
				_nLin := imp_rodape(_nLin,oPC,.t.)
				_nLin := Imp_Cabec(_nLin,oPC,cLogo,nPag)
				_nLin := Imp_CabItem(_nLin,oPC)
			elseif _nLin > 3200 .and. nPag>1
				nPag++
				oPC:EndPage()
				_nLin := Imp_Cabec(_nLin,oPC,cLogo,nPag)
				_nLin := Imp_CabItem(_nLin,oPC)
			endif
	
			cDescr := aItSC7[nK,3]
			oPC:Say(_nLin, 0080, Transform(aItSC7[nK,1],PesqPict("SC7","C7_ITEM")),oFont8,100)
			oPC:Say(_nLin, 0170, Transform(aItSC7[nK,2],PesqPict("SC7","C7_PRODUTO")),oFont8,100)
			oPC:Say(_nLin, 0480, MemoLine(cDescr,60,1),oFont8,100)
			oPC:Say(_nLin, 1330, aItSC7[nK,4],oFont8,100)
			oPC:Say(_nLin, 1430, Transform(aItSC7[nK,5],PesqPict("SC7","C7_QUANT")),oFont8,100)
			oPC:Say(_nLin, 1630, Transform(aItSC7[nK,6],PesqPict("SC7","C7_PRECO")),oFont8,100)
			oPC:Say(_nLin, 1890, Transform(aItSC7[nK,7],PesqPict("SC7","C7_TOTAL")),oFont8,100)
			oPC:Say(_nLin, 2120, Transform(aItSC7[nK,8],PesqPict("SC7","C7_IPI")),oFont8,100)
			oPC:Say(_nLin, 2220, dtoc(aItSC7[nK,9]),oFont8,100)
	
			for nQ := 2 to MlCount(cDescr,60)
				_nLin += 25
				oPC:Say(_nLin, 0480, MemoLine(cDescr,60,nQ),oFont8,100)
			next
			oPC:Line(_nLin+30,0070,_nLin+30,2330)
			
			_nLin+=45
		next
	
		if _nLin <= 2200 .and. nPag = 1
			_nLin := imp_rodape(_nLin,oPC,.f.)
		endif
		
		oPC:EndPage()     // Finaliza a página
	else
		alert("nao ha dados para emitir")
	endif
enddo
oPC:Preview()     // Visualiza antes de imprimir	
return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao³ Imp_Cabec    ³                               ³      ³          ³±±
±±ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Imp_Cabec(_nLin,oPC,cLogo,nPag)
oPC:StartPage()

_nLin := 0

oPC:SayBitmap(050,050,cLogo,220,240)
oPC:Say(_nLin+080, 0300,Upper("PDV Brasil Combustiveis e Lubrificantes Ltda"),oFont9n,100)
oPC:Say(_nLin+120, 0300,AllTrim(SM0->M0_ENDCOB),oFont9,100)			//+" - "+SM0->M0_BAIRROC,oFont9,100)
oPC:Say(_nLin+160, 0300,"CEP: "+Transform(SM0->M0_CEPCOB,"@R 99999-999")+" - "+AllTrim(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB,oFont9,100)
oPC:Say(_nLin+200, 0300,"TEL: "+Transform(AllTrim(SM0->M0_TEL),"@R (99)9999-9999")+"    FAX: "+Transform(AllTrim(SM0->M0_FAX),"@R (99)9999-9999"),oFont9,100)
oPC:Say(_nLin+240, 0300,"CNPJ: "+Transform(AllTrim(SM0->M0_CGC),"@R 99.999.999/9999-99")+"         IE: "+AllTrim(SM0->M0_INSC),oFont9,100)

oPC:Say(_nLin+080, 1600,"Data de emissão",oFont7,100)
oPC:Say(_nLin+130, 1600,dtoc(dDataBase),oFont9n,100)
oPC:Say(_nLin+190, 1600,AllTrim(Str(nReemissao))+"a. Emissão",oFont9,100)

oPC:Say(_nLin+080, 1900,"PEDIDO DE COMPRAS",oFont10,100)
oPC:Say(_nLin+130, 1950,cPedCom,oFont16,100)
oPC:Say(_nLin+240, 2200,"Página: "+AllTrim(Str(nPag)),oFont7,100)

_nLin := 300
Return(_nLin)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao³ Imp_CabItem  ³                               ³      ³          ³±±
±±ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Imp_CabItem(_nLin,oPC)

oPC:Box(_nLin, 0070, _nLin+050,0160)
oPC:Box(_nLin, 0160, _nLin+050,0450)
oPC:Box(_nLin, 0450, _nLin+050,1320)
oPC:Box(_nLin, 1320, _nLin+050,1410)
oPC:Box(_nLin, 1410, _nLin+050,1610)
oPC:Box(_nLin, 1610, _nLin+050,1860)
oPC:Box(_nLin, 1860, _nLin+050,2110)
oPC:Box(_nLin, 2110, _nLin+050,2200)
oPC:Box(_nLin, 2200, _nLin+050,2330)

oPC:Say(_nLin+010, 0080, "Item",oFont8,100)
oPC:Say(_nLin+010, 0170, "Produto",oFont8,100)
oPC:Say(_nLin+010, 0460, "Descrição",oFont8,100)
oPC:Say(_nLin+010, 1330, "U.M.",oFont8,100)
oPC:Say(_nLin+010, 1440, "Quantidade",oFont8,100)
oPC:Say(_nLin+010, 1680, "Vlr.Unitário",oFont8,100)
oPC:Say(_nLin+010, 1970, "Vlr.Total",oFont8,100)
oPC:Say(_nLin+010, 2140, "IPI",oFont8,100)
oPC:Say(_nLin+010, 2220, "Entrega",oFont8,100)
 
_nLin += 60

Return(_nLin)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao³ Imp_Rodape   ³                               ³      ³          ³±±
±±ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Imp_Rodape(_nLin,oPC,lContinua)
Local nX, nLiObs

if lContinua
	oPC:Say(_nLin+10, 1140, "...CONTINUA...",oFont8,100)
	_nLin += 40
endif

oPC:Box(_nLin, 0070, _nLin+200,2330)	//local de entrega
oPC:Line(_nLin+100,0070,_nLin+100,2330)
oPC:Say(_nLin+010, 0080, "Local de entrega",oFont8,100)
oPC:Say(_nLin+110, 0080, "Local de cobrança",oFont8,100)
oPC:Say(_nLin+035, 0080, Alltrim(SM0->M0_ENDENT)+"  "+Alltrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT+" - CEP "+Transform(Alltrim(SM0->M0_CEPENT),PesqPict("SA2","A2_CEP")),oFont10,100)
oPC:Say(_nLin+135, 0080, Alltrim(SM0->M0_ENDCOB)+"  "+Alltrim(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB+" - CEP "+Transform(Alltrim(SM0->M0_CEPCOB),PesqPict("SA2","A2_CEP")),oFont10,100)

_nLin+=200
oPC:Box(_nLin, 0070, _nLin+200,0800)	//condicao de pagamento
oPC:Box(_nLin, 0800, _nLin+200,1100)	//frete
oPC:Box(_nLin+200, 0070, _nLin+400,0800)	//descontos
oPC:Box(_nLin+200, 0800, _nLin+400,1100)	//reajuste
oPC:Say(_nLin+010, 0080, "Condição de Pagamento",oFont8,100)
oPC:Say(_nLin+050, 0080, cCondPag,oFont10,100)
oPC:Say(_nLin+010, 0810, "Frete",oFont8,100)
oPC:Say(_nLin+050, 0850, cFrete,oFont10,100)
oPC:Say(_nLin+210, 0080, "Descontos",oFont8,100)
oPC:Say(_nLin+245, 0080, cDescontos,oFont10,100)
oPC:Say(_nLin+290, 0250, Transform(nValDesc,"@E 999,999,999.99"),oFont10,100)
oPC:Say(_nLin+210, 0810, "Reajuste",oFont8,100)
oPC:Say(_nLin+230, 0810, cReajuste,oFont10,100)

oPC:Box(_nLin, 1100, _nLin+400,1517)	//despesas acessorias
oPC:Box(_nLin, 1517, _nLin+400,1934)	//impostos
oPC:Box(_nLin, 1934, _nLin+400,2330)	//totais
oPC:Say(_nLin+010, 1110, "Despesas Acessórias",oFont8,100)
oPC:Say(_nLin+100, 1110, "Valor Frete:",oFont8,100)
oPC:Say(_nLin+130, 1230, Transform(nTotFrete,"@E 999,999,999.99"),oFont10,100)
oPC:Say(_nLin+200, 1110, "Despesas:",oFont8,100)
oPC:Say(_nLin+230, 1230, Transform(nTotDesp,"@E 999,999,999.99"),oFont10,100)
oPC:Say(_nLin+300, 1110, "Seguro:",oFont8,100)
oPC:Say(_nLin+330, 1230, Transform(nTotSeguro,"@E 999,999,999.99"),oFont10,100)

oPC:Say(_nLin+010, 1527, "Impostos",oFont8,100)
oPC:Say(_nLin+100, 1527, "Valor IPI:",oFont8,100)
oPC:Say(_nLin+130, 1647, Transform(nTotIPI,"@E 999,999,999.99"),oFont10,100)

oPC:Say(_nLin+200, 1527, "Valor ICMS:",oFont8,100)
oPC:Say(_nLin+230, 1647, Transform(nTotICMS,"@E 999,999,999.99"),oFont10,100)

oPC:Say(_nLin+010, 1944, "TOTAL GERAL",oFont8,100)
//oPC:Say(_nLin+100, 1944, "Mercadoria:",oFont8,100)
//oPC:Say(_nLin+200, 1944, "Com Impostos:",oFont8,100)
//oPC:Say(_nLin+300, 1944, "GERAL:",oFont8,100)
oPC:Say(_nLin+040, 2064, Transform(nTotalNF,"@E 999,999,999.99"),oFont10,100)

_nLin+=400
oPC:Box(_nLin, 0070, _nLin+450,2330)	//observacoes
oPC:Say(_nLin+010, 0080, "Observações",oFont8,100)

nLiObs := _nLin+030
for nX := 1 to MlCount(cObsRodap,120)
	oPC:Say(nLiObs, 0080, MemoLine(cObsRodap,120,nX), oFont10,100)
	nLiObs +=30
next

oPC:Line(_nLin+200,0070,_nLin+200,2330)		//Autorizacoes
oPC:Say(_nLin+210, 0080, "Autorizações",oFont8,100)
_nLin+=450

oPC:EndPage()
Return(_nLin)