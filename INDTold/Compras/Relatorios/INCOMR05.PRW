#INCLUDE "RWMAKE.CH"

/*/
#############################################################################
ฑฑบPrograma  ณINCOMR05  บ Autor ณ Raphael Rage       บ Data ณ  25/04/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Impressao do PC de / ate                                   บฑฑ
#############################################################################
ฑฑบUso       ณ COMPRAS - Relat๓rio                                        บฑฑ
##########################################################################/*/

User Function INCOMR05
	Local oLeTxt
	Local cPerg   := PADR("INCOMR05",Len(SX1->X1_GRUPO))
	Local cFilAux := cFilAnt
	Local aSM0    := SM0->({IndexOrd(),Recno()})
	
		
	
	Private nPag  := 1000
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.T.)
	
	@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Pedido de Compra")
	@ 02,10 TO 080,190
	@ 10,018 Say " Este programa ira imprimir o Pedido Selecionado              "
	@ 18,018 Say "                                                              "
	@ 26,018 Say "                                                              "
	@ 70,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
	@ 70,128 BMPBUTTON TYPE 01 ACTION (Processa({|lEnd|COM01PROC()}),Close(oLeTxt))
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
	
	Activate Dialog oLeTxt Centered
	
	cFilAnt := cFilAux
	MtValidFil(cEmpAnt+cFilAnt)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณCOM01IMP  บ Autor ณ Imprime o Pedido   บ Data ณ  04/10/2002 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณImprime o Pedido de Compra     .                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAP6                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function COM01PROC()
	Local cdata, cComprador, nTamStr, cMoeda, cSimbMoed, nTam, nMoeda, cQuery,cCCusto,cCodCC
    // RAGE - 08/02/2023 - CRIAวรO E VALIDADAO DO TIPO FRETE - PEDIDO DO HOMERO 
	Local cTpFrete := ''


	IF MV_PAR05 == 01
		cTpFrete = "CIF"
	
		ELSEIF MV_PAR05 == 02
		cTpFrete = "FOB"
	
		ELSEIF MV_PAR05 == 03
		cTpFrete = "EXWORKS"

	ENDIF



	
	Private oPrint
	Private pPag := .T.
	Private nLin := 0
	Private nTotPed,nTotDesc,nTotFrete,nTotDesp
	Private mObs := ""
	Private aAprovadores := {"","",""}
		
	cFilAnt := mv_par01    // Seta a filial conforme parโmetro
	
	If !MtValidFil(cEmpAnt+cFilAnt)
		Return
	Endif

	
	
	cQuery := "SELECT C7_FILIAL, C7_NUM,  C7_ITEM, C7_DESCRI, C7_MSG, C7_TIPO, C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL, C7_VLDESC, C7_CC, C7_VALIPI,"
	cQuery += " C7_DATPRF, C7_FORNECE, C7_ITEMSC, C7_SEGUM, C7_QTSEGUM, C7_MOEDA, C7_ITEMCTA, A2_COD,A2_NOME, A2_CGC, A2_DDD, A2_TEL, A2_FAX, A2_END, A2_EMAIL,C7_FRETE,"
	cQuery += " A2_CONTATO, A2_CEP, A2_BAIRRO, A2_MUN, A2_EST, C7_NUMSC, C7_ITEMSC,  C7_COND, C7_EMISSAO, C7_OBS, C7_VALFRE, C7_DESPESA, E4_DESCRI, C7_USER, Y1_NOME, Y1_TEL, Y1_EMAIL"
	cQuery += " FROM " + RetSQLName("SC7") + " SC7"
	cQuery += " INNER JOIN " + RetSQLName("SE4") + " SE4 ON SE4.D_E_L_E_T_ = ' ' AND E4_CODIGO = C7_COND"
	cQuery += " INNER JOIN " + RetSQLName("SY1") + " SY1 ON SY1.D_E_L_E_T_ = ' ' AND Y1_USER = C7_USER" //VINCULO DE COMPRADOR - RAGE
	cQuery += " INNER JOIN " + RetSQLName("SA2") + " SA2 ON SA2.D_E_L_E_T_ = ' ' AND A2_FILIAL = C7_FILIAL AND A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA"
	cQuery += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND B1_COD = C7_PRODUTO"
	cQuery += " WHERE SC7.D_E_L_E_T_ = ' '"
	cQuery += " AND C7_FILIAL = '"+MV_PAR01+"'"
	cQuery += " AND C7_NUM BETWEEN '"+MV_PAR02+"'AND  '"+MV_PAR03+"' "
	cQuery += " AND C7_RESIDUO = ' '"

	
	If MV_PAR06 == 2
		cQuery += " AND C7_QUANT <> C7_QUJE"
	ElseIf MV_PAR06 == 3
		cQuery += " AND C7_QUJE > 0"
	EndIf
	
	cQuery += " ORDER BY C7_NUM, C7_ITEM"
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )
	DbGotop()
	
	If Bof() .And. Eof()
		dbCloseArea()
		MsgAlert("Nใo foram encontrados dados para os parโmetros informados !")
		Return
	Endif
	
	cCCusto := Posicione("CTT",1,xFilial("CTT")+TMP->C7_CC,"CTT_DESC01")  // Anizio Cunha 27/12/2022
	cCodCC:= Alltrim(TMP->C7_CC)
	If !Eof()
		
		
		cQuery := " SELECT CR_APROV,CR_USER,AK_NOME,CR_USERLIB"
		cQuery += " FROM " + RetSQLName("SCR") + " SCR"
		cQuery += " INNER JOIN " + RetSQLName("SAK") + " SAK ON SAK.D_E_L_E_T_ = '' AND CR_USER = AK_USER AND CR_APROV = AK_COD"
		cQuery += " WHERE SCR.D_E_L_E_T_<>'*' AND CR_FILIAL = '"+TMP->C7_FILIAL+"' AND CR_NUM = '"+TMP->C7_NUM+"'"
		cQuery += " ORDER BY SCR.R_E_C_N_O_"
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "APROV", .T., .F. )
		Cont := 1
		While !APROV->(Eof())
			aAprovadores[Cont] := IIf(!Empty(APROV->CR_USERLIB),APROV->AK_NOME,"Nใo Liberado")
			APROV->(DbSkip())
			Cont++
			If Cont > 3
				Exit
			EndIf
		Enddo
		DbCloseArea()
		DbselectArea("TMP")
	EndIf
	
	nMoeda := TMP->C7_MOEDA
	cMoeda := Alltrim(GetMv("MV_MOEDA"+LTrim(Str(nMoeda,2))))
	cSimbMoed := Alltrim(GetMv("MV_SIMB"+LTrim(Str(nMoeda,2))))
	cdata  := SubStr(TMP->C7_EMISSAO,7,2)+"/"+SubStr(TMP->C7_EMISSAO,5,2)+"/"+SubStr(TMP->C7_EMISSAO,1,4)
	
	// RAGE - 07/05/2023  - ALTERAวีES A PEDIDO FERNANDA ROCHA
	cTit01 := IIf (nMoeda == 1,"Pedido Nบ:  ","Order Nบ:  ")+TMP->C7_NUM +"     "+IIf (nMoeda == 1,"Emissใo:  ","Date:  ")+cData+"    "+IIf(nMoeda == 1,"Moeda:  ","Currency:  ") +cMoeda
	cTit02 := IIf (nMoeda == 1,"Fornecedor:  ","Supplier:  ") +TMP->A2_COD+ " - " +Alltrim(TMP->A2_NOME)+" -  CNPJ: "+TMP->A2_CGC
	cTit03 := IIf (nMoeda == 1,"Endere็o:  ","Address:  ")+Alltrim(TMP->A2_END)+" - "+TMP->A2_BAIRRO+" - "+TMP->A2_MUN+", "+TMP->A2_EST+" - CEP: "+TMP->A2_CEP
	cTit04 := IIf (nMoeda == 1,"Contato fornecedor:  ","Supplier Contact:  ")+TMP->A2_CONTATO+"  -  Tel.: ("+TMP->A2_DDD+") "+TMP->A2_TEL+"  - EMAIL.: "+TMP->A2_EMAIL
	cTit08 := IIf (nMoeda == 1,"Condi็๕es pgto.:  ","Payment Term:  ")+TMP->E4_DESCRI
	cTit09 := IIf (nMoeda == 1,"Comprador(a): ","Buyer: ")+TMP->Y1_NOME+"   Telefone.: "+TMP->Y1_TEL+"   EMAIL.: "+TMP->Y1_EMAIL // RAGE 07/11/23 - MOSTRAR COMPRADOR
	
	
	
	oPrint:= TMSPrinter():New( IIf(nMoeda == 1,"Pedido de compra","Purchase Order") )
	oPrint:SetPortrait() // ou SetLandscape()
	oFont7   := TFont():New("Arial",9,7 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont7n  := TFont():New("Arial",9,7 ,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont8   := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8n  := TFont():New("Arial",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont9   := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9n  := TFont():New("Arial",9,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10  := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10n := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12  := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont12n := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14  := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oBrush   := TBrush():New("",4)
	
	COM01CAB(nMoeda,.T.)
	
	DbselectArea("TMP")
	DbGotop()
	
	While !TMP->(Eof())
		nTotPed := 0
		nTotDesc := 0
		nTotFrete := 0
		nTotDesp := 0
		COM01CORPO(nMoeda,cSimbMoed)
		nLin+= 50
		If nLin > 3000
			COM01CAB(nMoeda,.F.)
		EndIf
		
		oPrint:Box  (nLin,050,nLin+080,2330)
		oPrint:Say  (nlin+25,0210,IIf(nMoeda == 1,"Frete: ","Freight: ") +cTpFrete,oFont10n )
		oPrint:Say  (nlin+25,1010,IIf(nMoeda == 1,"Valor Frete: ","Freight Value: ")+Transform(nTotFrete,"@E 999,999,999.99"),oFont10n )
		oPrint:Say  (nlin+25,1810,IIf(nMoeda == 1,"(-)Desconto("+cSimbMoed+"): ","Discount("+cSimbMoed+"): ")+Transform(nTotDesc,"@E 999,999,999.99"),oFont10n )
		nLin+= 90
		If nLin > 3000
			COM01CAB(nMoeda,.F.)
		EndIf
		oPrint:Box  (nLin,050,nLin+080,2330)
		oPrint:Say  (nlin+25,1610,IIf(nMoeda == 1,"Total do Pedido("+cSimbMoed+"): ","Total Amount("+cSimbMoed+"): ")+Transform(nTotPed,"@E 999,999,999.99"),oFont12n )
		nLin+= 120
		If nLin > 3000
			COM01CAB(nMoeda,.F.)
		EndIf
		nTam := 1
		oPrint:Say  (nlin,070,IIf(nMoeda == 1,"Observa็๕es","Observations"),oFont10n )
		nLin+= 60
		If nLin > 3000
			COM01CAB(nMoeda,.F.)
		EndIf
		While !Empty(SubStr(mObs,nTam,107))
			nTamStr := TString(SubStr(mObs,ntam,Len(mObs)),107)
			oPrint:Say  (nlin,070,SubStr(mObs,nTam,107 - nTamStr),oFont10 )
			nLin+= 50
			nTam +=107 - nTamStr
			If nLin > 3000
				COM01CAB(nMoeda,.F.)
			EndIf
		End
		nLin+= 50
		If nLin > 3000
			COM01CAB(nMoeda,.F.)
		EndIf
		
		nLin+= 100
		If nLin > 3000
			COM01CAB(nMoeda,.F.)
		EndIf
		
		//RAGE - 05/04/2023 - VALIDACAO DO CAMPO OBSERVACOES 

		If nMoeda == 1
			oPrint:Say  (nlin,070,"1. A Nota Fiscal deve mencionar o Nบ do Pedido de Compra",oFont10n )
			nLin+= 50
			oPrint:Say  (nlin,070,"2. A Quantidade e o pre็o unitแrio deve estar de acordo com Pedido de Compra",oFont10n )
			nLin+= 50
			oPrint:Say  (nlin,070,"3. Caso Pagamento seja via Transferencia Bancaria , por favor informar na Nota Fiscal",oFont10n )
			nLin+= 50
			oPrint:Say  (nlin,070,"4. Local de Entrega do Material ou Prest. de Servi็o: "+Alltrim(SM0->M0_ENDENT)+" CEP "+SM0->M0_CEPENT+" "+Alltrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT ,oFont10n )
			nLin+= 50
			oPrint:Say  (nlin,070,"   - PT REF" + " - "+ SM0->M0_COMPENT,oFont10n )
			nLin+= 50
			oPrint:Say  (nlin,070,"5. Tipo(s) de Incentivo (s) para a regiใo de domicํlio da empresa: * ICMS (Conv๊nio 65/88), IPI (Decreto nบ 7.212/2010) e PIS/COFINS ",oFont10n )
			nLin+= 50
			oPrint:Say  (nlin,070,"   (Lei nบ 10996/01-Zona Franca e Lei nบ 11945/09-ALC's)",oFont10n )
			nLin+= 50

		Else
			oPrint:Say  (nlin,070,"Note: Please state our purchase Order Number on your Invoice",oFont10n )
		EndIf
		nLin+= 50
		If nLin > 3000
			COM01CAB(nMoeda,.F.)
		EndIf
		
		x := 1
		COM01ROD(nMoeda,cCCusto,cCodCC)
	End
	oPrint:EndPage()     // Finaliza a pแgina
	oPrint:Preview()     // Visualiza antes de imprimir
	DbselectArea("TMP")
	dbCloseArea("TMP")
	
Return nil

Static Function COM01CORPO(nMoeda,cSimbMoed)
	Local cdata, cDesc, xLinhas, cDetalhe, cDetTemp
	Local nFrete  := TMP->C7_FRETE
	//Local cLinha  := Chr(13)+Chr(10)
	Local cPedido := TMP->C7_NUM
	
	//oPrint:Line (nLin,050,nLin,2330);nLin++
	//oPrint:Line (nLin,050,nLin,2330);nLin++
	COM01GRAD(nLin)
	oPrint:Say  (nlin+25,070,"Item",oFont9n )
	oPrint:Say  (nlin+25,160,IIf(nMoeda == 1,"Quant.","Qty"),oFont9n )
	oPrint:Say  (nlin+25,295,"UM",oFont9n )
	oPrint:Say  (nlin+25,390,IIf(nMoeda == 1,"Descri็ใo","Description"),oFont9n )
	oPrint:Say  (nlin+25,1440,"Vlr Unit. ("+cSimbMoed+")",oFont9n )
	oPrint:Say  (nlin+25,1690,"Total ("+cSimbMoed+")",oFont9n )
	oPrint:Say  (nlin+25,1905,"Num.SC",oFont9n )
	oPrint:Say  (nlin+25,2090,"Prev.Ent.",oFont9n )
	pPag := .T.
	nlin+=60
	While !Eof() .And. cPedido = TMP->C7_NUM
		xLinhas := 0
		If !Empty(TMP->C7_OBS)
			mObs := mObs + TMP->C7_ITEM+" - "+Alltrim(TMP->C7_OBS)+ ". "
		EndIf
		If nLin > 3000
			COM01CAB(nMoeda,.F.)
		EndIf
		SC7->(DbSetOrder(1))
		cDesc := AllTrim(TMP->C7_DESCRI)
		cDetalhe := AllTrim(Posicione("SC7",1,xFilial("SC7")+TMP->(C7_NUM+C7_ITEM),"C7_DETALH"))
		If Empty(cDetalhe)
			cDetalhe := AllTrim(Posicione("SC1",1,xFilial("SC1")+TMP->(C7_NUMSC+C7_ITEMSC),"C1_DETALH"))
		EndIf
		cDetalhe := AllTrim(cDetalhe)
		
		If MV_PAR04 == 1
			cDetalhe := ""
		ElseIf MV_PAR04 == 2
			cDesc := ""
		EndIf
		cDetTemp := cDetalhe
		If !Empty(cDetTemp)
			xLinhas := 60
			While !Empty(cDetTemp)
				xLinhas += 60
				cDetTemp := Alltrim(SubStr(cDetTemp,51,Len(cDetTemp)))
			End
		EndIf
		
		If  xLinhas > 0
			COM01GRADDESC(nLin,xLinhas)
		Else
			COM01GRAD(nLin)
		EndIf
		
		cData := SubStr(TMP->C7_DATPRF,7,2)+"/"+SubStr(TMP->C7_DATPRF,5,2)+"/"+SubStr(TMP->C7_DATPRF,1,4)
		
		oPrint:Say  (nlin+25,070,TMP->C7_ITEM,oFont10 )
		oPrint:Say  (nlin+25,100,Transform(TMP->C7_QUANT,"@E 999,999,999.99"),oFont9 )
		oPrint:Say  (nlin+25,300,TMP->C7_UM,oFont10 )
		oPrint:Say  (nlin+12,400,SubStr(cDesc,1,60),oFont7 )
		oPrint:Say  (nlin+37,400,SubStr(cDesc,61,110),oFont7 )
		oPrint:Say  (nlin+25,1480,Transform(TMP->C7_PRECO,"@E 999,999,999.99"),oFont9 )
		oPrint:Say  (nlin+25,1685,Transform((TMP->C7_TOTAL),"@E 999,999,999.99"),oFont9 )
		oPrint:Say  (nlin+25,1910,TMP->C7_NUMSC,oFont9 )
		oPrint:Say  (nlin+25,2125,cData,oFont9 )
		nTotPed += (TMP->C7_TOTAL-TMP->C7_VLDESC)+TMP->C7_VALIPI+TMP->C7_VALFRE+TMP->C7_DESPESA
		nTotDesc += TMP->C7_VLDESC
		nTotFrete += TMP->C7_VALFRE
		nTotDesp += TMP->C7_DESPESA
		nLin+=60
		If !Empty(cDetalhe)
			While !Empty(cDetalhe)
				oPrint:Say  (nlin+25+IIf(Empty(cDesc),-60,0),400,SubStr(cDetalhe,1,50),oFont9 )
				cDetalhe := Alltrim(SubStr(cDetalhe,51,Len(cDetalhe)))
				nLin+=60
			End
		EndIf
		TMP->(DbSkip())
	Enddo
	
	If nTotFrete == 0
		nTotFrete := nFrete
	Endif
	
Return

Static Function COM01CAB(nMoeda,lImpCab)
	
	nFol := 1
	nLin := 050
	
	If pPag
		oPrint:EndPage()     // Finaliza a pแgina
	EndIf
	
	oPrint:StartPage()   // Inicia uma nova pแgina
	
	oPrint:Say  (nlin-50,2150,"Pag.: "+StrZero(nPag,3),oFont10)
	oPrint:SayBitmap (100 ,050,"\SYSTEM\lgrl01.bmp",450 ,200 )
	oPrint:Say  (nlin,550,IIf(nMoeda == 1,Padc("PEDIDO DE COMPRA",50),Padc("PURCHASE ORDER",50)),oFont16n);nLin+=100
	oPrint:Say  (nlin,600,SM0->M0_NOMECOM,oFont12n);nLin+=70
	oPrint:Say  (nlin,600,Alltrim(SM0->M0_ENDCOB) + Alltrim(SM0->M0_BAIRCOB),oFont10);nLin+=50 // RAGE - 06/01/2023
	oPrint:Say  (nlin,600,"CEP "+SM0->M0_CEPCOB+".  "+Alltrim(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB,oFont10);nLin+=50
	oPrint:Say  (nlin,600,"Telefone:("+StrZero(Val(SubStr(SM0->M0_TEL,1,4)),2)+") "+SubStr(SM0->M0_TEL,5,Len(SM0->M0_TEL))+"  - Fax: ("+StrZero(Val(SubStr(SM0->M0_TEL,1,4)),2)+") "+SubStr(SM0->M0_TEL,5,Len(SM0->M0_TEL)),oFont10);nLin+=50
	oPrint:Say  (nlin,600,"CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999.9999-99")+" - Insc. Estadual: ISENTO",oFont10);nLin+=75
	oPrint:Say  (nlin,050,cTit01,oFont14n);nLin+=100
	If lImpCab
		oPrint:Say  (nlin,050,cTit02,oFont10n );nLin+=60
		oPrint:Say  (nlin,050,cTit03,oFont10n );nLin+=60
		oPrint:Say  (nlin,050,cTit04,oFont10n);nLin+=60
		oPrint:Say  (nlin,050,cTit08,oFont10n );nLin+=60
		oPrint:Say  (nlin,050,cTit09,oFont10n );nLin+=80
	EndIf
	oPrint:Line (nLin,050,nLin,2330);nLin++
	pPag := .T.
	nPag++
	
Return

Static Function COM01GRAD(nLin)
	oPrint:Line (nLin,0050,nLin,2330);nLin++
	oPrint:Box  (nLin,0050,nLin+060,0160)
	oPrint:Box  (nLin,0160,nLin+060,0280)
	oPrint:Box  (nLin,0280,nLin+060,0380)
	oPrint:Box  (nLin,0380,nLin+060,1430)
	oPrint:Box  (nLin,1430,nLin+060,1680)
	oPrint:Box  (nLin,1680,nLin+060,1880)
	oPrint:Box  (nLin,1880,nLin+060,2080)
	oPrint:Box  (nLin,2080,nLin+060,2330)
Return

Static Function COM01GRADDESC(nLin,nTam)
	oPrint:Line (nLin,0050,nLin,2330);nLin++
	oPrint:Box  (nLin,0050,nLin+nTam,0160)
	oPrint:Box  (nLin,0160,nLin+nTam,0280)
	oPrint:Box  (nLin,0280,nLin+nTam,0380)
	oPrint:Box  (nLin,0380,nLin+nTam,1430)
	oPrint:Box  (nLin,1430,nLin+nTam,1680)
	oPrint:Box  (nLin,1680,nLin+nTam,1880)
	oPrint:Box  (nLin,1880,nLin+nTam,2080)
	oPrint:Box  (nLin,2080,nLin+nTam,2330)
Return

Static Function COM01ROD(nMoeda,cCCusto,cCodCC)
	oPrint:Line (3030,050,3030,2330)
	oPrint:Line (3031,050,3031,2330)
	oPrint:Line (3032,050,3032,2330)
	oPrint:Box  (3033,050,3180,800)
	oPrint:Say  (3040,055,IIf(nMoeda == 1,"Aprovador 1","Aprover 1"),oFont9n )
	oPrint:Say  (3100,065,Left(aAprovadores[1],20),oFont9n )
	oPrint:Say  (3135,065,"C. Custo: "+Alltrim(cCodCC)+"  - "+Alltrim(cCCusto),oFont9 )
	oPrint:Box  (3033,801,3180,1600)
	oPrint:Say  (3040,807,IIf(nMoeda == 1,"Aprovador 2","Aprover 2"),oFont9n )
	oPrint:Say  (3100,817,Left(aAprovadores[2],20),oFont9n )
	oPrint:Box  (3033,1601,3180,2330)
	oPrint:Say  (3040,1607,IIf(nMoeda == 1,"Aprovador 3","Aprover 3"),oFont9n )
	oPrint:Say  (3100,1617,Left(aAprovadores[3],20),oFont9n )
Return

Static Function VerDesCont(cContrato)
	Local cDContrato := ""
	
	PA9->(DbSetOrder(1))
	PA9->(DbSeek(xFilial("PA9")+"X"+cContrato+"0001",.T.))
	While !PA9->(Eof()) .And. PA9->(PA9_TIPO+PA9_DOC+PA9_ITEM) == "X"+cContrato+"0001"
		cDContrato += PA9->PA9_DESCRI
		PA9->(DbSkip())
	Enddo
	
Return cDContrato

Static Function TString(cString,nQ)
	Local cTemp, nPos
	Local nTamStr := 0
	
	If SubStr(cString,nQ,1) <> " " .And. SubStr(cString,nQ+1,1) <> " "
		cTemp := SubStr(cString,1,nQ)
		nPos := 1
		While nPos > 0
			nPos := at(" ",cTemp)
			if nPos > 0
				cTemp := SubStr(cTemp,nPos+1,Len(cTemp))
			EndIf
		End
		nTamStr := Len(cTemp)
	EndIf
	
Return nTamStr

Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01","Filial                   ?","Filial                   ?","Filial                   ?","mv_ch1","C",02 ,0 ,0 ,"G","","","","","mv_par01","","","","","","","","","","","","","","","")
	u_INPutSX1(cPerg,"02","Pedido de                ?","Pedido de                ?","Pedido                   ?","mv_ch2","C",06 ,0 ,0 ,"G","","","","","mv_par02","","","","","","","","","","","","","","","")
	u_INPutSX1(cPerg,"03","Pedido ate               ?","Pedido ate               ?","Pedido                   ?","mv_ch3","C",06 ,0 ,0 ,"G","","","","","mv_par03","","","","","","","","","","","","","","","")
	u_INPutSx1(cPerg,"04","Descri็ใo                ?","Descri็ใo                ?","Descri็ใo                ?","mv_ch4","N",01 ,0 ,0 ,"C","","","","","mv_par04","Simplificada","Simplificada","Simplificada","","Detalhada","Detalhada","Detalhada","Ambas","Ambas","Ambas")
	u_INPutSx1(cPerg,"05","Frete                    ?","Frete                    ?","Frete                    ?","mv_ch5","N",01 ,0 ,0 ,"C","","","","","mv_par05","CIF","CIF","CIF","","FOB","FOB","FOB","EXWORKS","EXWORKS","EXWORKS")
	u_INPutSx1(cPerg,"06","Lista Quais              ?","Lista Quais              ?","Lista Quais              ?","mv_ch6","N",01 ,0 ,0 ,"C","","","","","mv_par06","Todos","Todos","Todos","","Abertos","Abertos","Abertos","Atendidos","Atendidos","Atendidos")
Return

