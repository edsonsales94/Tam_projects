#INCLUDE "AvPrint.ch"
#INCLUDE "Font.ch"
#Include "Protheus.ch"
#INCLUDE "APWEBEX.CH"
#INCLUDE "RWMAKE.CH"
#include "Colors.ch"  
 
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AMFATR01   ¦ Autor ¦ Jhonatan Lobato      ¦ Data ¦ 08/05/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Script de Proposta - Amazonaves, a patir da data citada acima,¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦  (cont.)  ¦ com base na estrutura criada anteriormente pelo analista      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦  (cont.)  ¦ Ulisses Junior, foi dado continuidade ao desenvolvimento da   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦  (cont.)  ¦ rotina do script da proposta (orcamento).                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function AMFATR01(cOrc)
Local lOk := .F.

Default cOrc := ""

Private cTmp
Private cOrcamento := If(Empty(cOrc), SCJ->CJ_NUM, cOrc) 

Processa({|| lOk := AmFatR01a(),"Buscando Dados"}) // Montagem da consulta
If lOk
	Processa({|| AmFatR01b(),"Preparando Fontes"})
Else
	FWAlertError("Não foram localizados dados a serem impressos !")
Endif
(cTmp)->(dbCloseArea())

Return

/*___________________________________________________________________________________
¦ Função    ¦ AMFATR01a  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 15/04/2008     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Montagem da consulta para coleta de dados		                        ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function AmFatR01a()
Local cQry := ""

cQry := " SELECT CJ_NUM, CJ_FILIAL, CK_PRODUTO, B1_DESC, B1_PICM, CK_QTDVEN, CK_PRCVEN, CK_VALOR, B1_FABRIC, B1_UM, B1_TIPO,min(B8_DTVALID) as B8_DTVALID, B1_XPARTNU,CJ_XOBS, " //
cQry += " CJ_EMISSAO, CJ_VALIDA, A1_COD, A1_NOME, A1_END, CJ_XNUMOS,Z4_XSTATUS,Z4_XCODBE, "
cQry += " A1_CEP, A1_PESSOA, A1_CGC, A1_INSCR, A1_TEL,A1_CONTATO , A1_MUN, A1_EST, E4_DESCRI, A1_BAIRRO, CK_VALDESC, CJ_DESCONT,CK_DESCONT " //CJ_XPRAZO,
cQry += " FROM "+RetSqlName("SCJ")+" SCJ "
cQry += " LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.D_E_L_E_T_ = ' ' AND CJ_CLIENTE = A1_COD AND CJ_LOJA = A1_LOJA " //AND LEFT(CJ_FILIAL,2) = A1_FILIAL
cQry += " LEFT JOIN "+RetSqlName("SE4")+" SE4 ON SE4.D_E_L_E_T_ = ' ' AND CJ_CONDPAG = E4_CODIGO " //AND CJ_FILIAL = E4_FILIAL
cQry += " LEFT JOIN "+RetSqlName("SCK")+" SCK ON SCK.D_E_L_E_T_ = ' ' AND CK_FILIAL = CJ_FILIAL AND CK_NUM = CJ_NUM"
cQry += " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_ = ' ' AND CK_PRODUTO = B1_COD" //AND LEFT(CK_FILIAL,2)=B1_FILIAL 
cQry += " LEFT JOIN "+RetSqlName("SB8")+" SB8 ON SB8.D_E_L_E_T_ = ' ' AND CK_FILIAL = B8_FILIAL AND CK_PRODUTO = B8_PRODUTO AND B8_LOCAL = CK_LOCAL AND B8_SALDO>0"
cQry += " LEFT JOIN "+RetSqlName("SZ4")+" SZ4 ON SZ4.D_E_L_E_T_ = ' ' AND CJ_XNUMOS = Z4_NUMOS AND LEFT(CJ_FILIAL,2)=Z4_FILIAL" 
cQry += " WHERE SCJ.D_E_L_E_T_ = ' '"
cQry += " AND SCJ.CJ_FILIAL = '" +SCJ->(XFILIAL("SCJ"))+ "'"
cQry += " AND SCJ.CJ_NUM = '"+cOrcamento+"'"
cQry += " GROUP BY CJ_NUM,CK_ITEM, CJ_FILIAL, CK_PRODUTO, B1_DESC, B1_PICM, CK_QTDVEN, CK_PRCVEN, CK_VALOR, B1_FABRIC, B1_UM,B1_TIPO,B1_XPARTNU,CJ_XOBS, "
cQry += " CJ_EMISSAO, CJ_VALIDA, A1_COD, A1_NOME, A1_END, CJ_XNUMOS,Z4_XSTATUS,Z4_XCODBE, "
cQry += " A1_CEP, A1_PESSOA, A1_CGC, A1_INSCR, A1_TEL,A1_CONTATO , A1_MUN, A1_EST, E4_DESCRI, A1_BAIRRO, CK_VALDESC, CJ_DESCONT,CK_DESCONT " //CJ_XPRAZO
cQry += " ORDER BY CK_ITEM "

cTmp := GetNextAlias()
dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),cTmp,.T.,.T.)

Return !Empty(cOrcamento) .And. !((cTmp)->(Bof()) .And. (cTmp)->(Eof()))

/*___________________________________________________________________________________
¦ Função    ¦ MTFATR01b  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 15/04/2008     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Atribuição dos objetos de fontes				                        ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static FUNCTION AmFatR01b()
Local nTPG
Private lPrint := .F.

AvPrint oPrn Name "PROPOSTA DE PRECOS - AMAZONAVES"

Define Font oFont1n Name "Times New Roman" Size 0,11 Bold Of oPrn
Define Font oFont2n Name "Times New Roman" Size 0,12 Bold Of oPrn
Define Font oFont3n Name "Times New Roman" Size 0,14 Bold Of oPrn
Define Font oFont4n Name "Times New Roman" Size 0,13 Bold Of oPrn
Define Font oFont5n Name "Courier New"     Size 0,12 Bold Of oPrn

Define Font oFont1  Name "Times New Roman" Size 0,11 Of oPrn
Define Font oFont2  Name "Times New Roman" Size 0,12 Of oPrn
Define Font oFont3  Name "Times New Roman" Size 0,14 Of oPrn
Define Font oFont4  Name "Times New Roman" Size 0,13 Of oPrn
Define Font oFont5  Name "Courier New"     Size 0,12 Of oPrn

Define Font oFontX  Name "Courier New"     Size 0,15 Bold Italic  Of oPrn

oPrn:setlandscape()

AvPage
	AmFatR01c(@nTPG)
	lPrint := .T.
	Processa({|X| lEnd := X, AmFatR01c(nTPG) })
AvEndPage

AvEndPrint
oPrn:setlandscape()

oFont1n:End()
oFont2n:End()
oFont3n:End()
oFont4n:End()
oFont5n:End()

oFont1:End()
oFont2:End()
oFont3:End()
oFont4:End()
oFont5:End()

Return .T.
      
/*___________________________________________________________________________________
¦ Função    ¦ AMFATR01c  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 15/04/2008     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão dos itens da proposta				                        ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function AmFatR01c(nPaginas)
Local xCor, cReserv, nItem := 1, nPrcUnit, LCHAVE :=.T.

Private nPagAtu:=0,nLine,nLinVert := 150,nColIni:=160,nColFim:=3500
Private cDatVal, cImposto, cEmbala, cCondPag, cFabric, cAeronave //cPrazoEn, cConv, cPacien, cMedico, cAnvisa, 
Private cObs1, cObs2, cVend, cNomeVen, cMailVen, cFil, cCondGar //, cDtProc, cLocalpr
Private nDifPixel := 40
Private nPages    := 1

nCol1:=nColIni
nCol2:=nCol1+100	//Item
nCol3:=nCol2+500	//Partnumber produto
nCol4:=nCol3+800	//Desc Produto
nCol5:=nCol4+100	//Tipo
nCol6:=nCol5+100	//Unidade
nCol7:=nCol6+225	//Quantidade
nCol8:=nCol7+250	//Preco unitario
nCol9:=nCol8+225	//%Desconto
nCol10:=nCol9+250	//Valor desconto
nLinFim:=2400 		//Total

nTotal   := 0
nTotDesc := 0
nTotPeca := 0
nTotServ := 0


(cTmp)->(dbGoTop())
AmFatR01d(nPaginas)//Cabeçalho

If lPrint
	oPrn:Say(nLine ,nCol1 ,"Orçamento"		     ,oFont2,,,,3)
	nLine += 070
	
	oPrn:Box (nLine, nCol1 - 5,nLine + 60, nCol2 - 5)
	oPrn:Box (nLine, nCol2 - 5,nLine + 60, nCol3 - 5)
	oPrn:Box (nLine, nCol3 - 5,nLine + 60, nCol4 - 5)
	oPrn:Box (nLine, nCol4 - 5,nLine + 60, nCol5 - 5)
	oPrn:Box (nLine, nCol5 - 5,nLine + 60, nCol6 - 5)
	oPrn:Box (nLine, nCol6 - 5,nLine + 60, nCol7 - 5)
	oPrn:Box (nLine, nCol7 - 5,nLine + 60, nCol8 - 5)
	oPrn:Box (nLine, nCol8 - 5,nLine + 60, nCol9 - 5)
	oPrn:Box (nLine, nCol9 - 5,nLine + 60, nCol10 - 5)
	oPrn:Box (nLine, nCol10- 5,nLine + 60, 3150)
	
	oPrn:Say(nLine ,nCol1 ,PadR("Item"         ,05)  ,oFont2n,,,,3)
	oPrn:Say(nLine ,nCol2 ,PadR("Partnumber"   ,10)  ,oFont2n,,,,3)
	oPrn:Say(nLine ,nCol3 ,PadR("Descrição"    ,10)  ,oFont2n,,,,3)
	oPrn:Say(nLine ,nCol4 ,PadR("Tipo"   	   ,04)  ,oFont2n,,,,3)
	oPrn:Say(nLine ,nCol5 ,PadR("Un. "         ,02)  ,oFont2n,,,,3)
	oPrn:Say(nLine ,nCol6 ,PadR("Qtde"         ,10)  ,oFont2n,,,,3)
	oPrn:Say(nLine ,nCol7 ,PadR("Preco Unit."  ,12)  ,oFont2n,,,,3)
	oPrn:Say(nLine ,nCol8 ,PadR("(%)Desc."     ,10)  ,oFont2n,,,,3)
	oPrn:Say(nLine ,nCol9 ,PadR("Val.Desc."    ,10)  ,oFont2n,,,,3)
	oPrn:Say(nLine ,nCol10,PadR("Total"        ,15)  ,oFont2n,,,,3)
Else
	nLine += 070
Endif

nLine += 060

While !(cTmp)->(Eof())
	
	ProcRegua((cTmp)->(LastRec()))
	
	ver_pag(,nPaginas)
	
	nPrcUnit := Round((cTmp)->CK_PRCVEN+((cTmp)->CK_VALDESC/(cTmp)->CK_QTDVEN),5)
	nValor	 := Round((cTmp)->CK_VALOR+(cTmp)->CK_VALDESC,2)
	nValDesc := Round((cTmp)->CK_VALDESC,2)
	nAliqDesc:= Round((cTmp)->CK_DESCONT,2)

	
	If !EMPTY(SL2->L2_RESERVA)
		xCor := CLR_HBLUE
		cReserv := oFontX
	Else
		xCor := Nil
		cReserv := oFont2
	EndIf
	
	If lPrint
		oPrn:Say(nLine,nCol1,PadR(Alltrim(StrZero(nItem,2)),04)                                            ,cReserv,,xCor,,3)
		oPrn:Say(nLine,nCol2,PadR(Alltrim((cTmp)->B1_XPARTNU),30)                                         ,cReserv,,xCor,,3)
		oPrn:Say(nLine,nCol3,PadR(Alltrim(SUBSTR((cTmp)->B1_DESC,1,24)),30)                               ,cReserv,,xCor,,3)
		//oPrn:Say(nLine,nCol4,PadR(Alltrim((cTmp)->B1_FABRIC),20)                                          ,cReserv,,xCor,,3)
		oPrn:Say(nLine,nCol4,PadR(Alltrim((cTmp)->B1_TIPO),02) 	                                        ,cReserv,,xCor,,3)
		//oPrn:Say(nLine,nCol6,PadR(Alltrim(dtoc(stod((cTmp)->B8_DTVALID))),11)                             ,cReserv,,xCor,,3)
		oPrn:Say(nLine,nCol5,PadR(Alltrim((cTmp)->B1_UM),02)                                               ,cReserv,,xCor,,3)
		oPrn:Say(nLine,nCol6,PadR(Alltrim(Transform((cTmp)->CK_QTDVEN,"@E 999,999.99")),10)               ,cReserv,,xCor,,3)
		oPrn:Say(nLine,nCol7,PadR(Alltrim(Transform(nPrcunit         ,"@E 9,999,999.99")),12)             ,cReserv,,xCor,,3)
		oPrn:Say(nLine,nCol8,PadR(Alltrim(Transform(nAliqDesc         ,"@E 9,999,999.99")),12)             ,cReserv,,xCor,,3)
		oPrn:Say(nLine,nCol9,PadR(Alltrim(Transform(nValDesc         ,"@E 9,999,999.99")),12)             ,cReserv,,xCor,,3)
		oPrn:Say(nLine,nCol10,PadR(Alltrim(Transform(nValor          ,"@E 999,999,999.99")),15)           ,cReserv,,xCor,,3)
		
		nLine+=60
		oPrn:Say(nLine,nCol3,PadR(Alltrim(SUBSTR((cTmp)->B1_DESC,25,48)),30)                              ,cReserv,,xCor,,3)
		
		nLine+=60
		oPrn:Line(nLine,nColIni,nLine,3150)
	Else
		nLine+=60
		nLine+=60
	Endif
	
	nTotal   += nValor
	nTotDesc += (cTmp)->CK_VALDESC

	If (cTmp)->B1_TIPO<>"SV"
		nTotPeca   += nValor
	EndIf

	If 	(cTmp)->B1_TIPO=="SV"
		nTotServ   += nValor
	EndIf	

	
	IF LCHAVE
		nTotDesc += (cTmp)->CJ_DESCONT
		LCHAVE   := .F.
	ENDIF
	
	nLine+=60
	nItem++
	
	(cTmp)->(dbSkip())
Enddo

If lPrint
	oPrn:Say(nLine, nCol1,"TOTAL DA PROPOSTA: (" +Extenso(nTotal-nTotDesc) +")"	,oFont2n,,xCor,,3)
Endif

AmFatR01e(nPaginas)
nPaginas := nPagAtu

Return
      
/*___________________________________________________________________________________
¦ Função    ¦ AMFATR01d  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 15/04/2008     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão do cabeçalho da proposta			                        ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function AmFatR01d(nPaginas) //Cabeçalho
Local cData
Local nCAux     := nColFim / 2
Local cEndereco := AllTrim((cTmp)->A1_END) +" "+ AllTRim((cTmp)->A1_BAIRRO)+" - "+ AllTRim((cTmp)->A1_MUN)+" - "+ AllTRim((cTmp)->A1_EST)
Local cCGCCPF1  := subs(transform((cTmp)->A1_CGC,PicPes(RetPessoa((cTmp)->A1_CGC))),1,at("%",transform((cTmp)->A1_CGC,PicPes(RetPessoa((cTmp)->A1_CGC))))-1)
Local cCGCPro   := cCGCCPF1 + space(18-len(cCGCCPF1))
Local cStatusOs := ""

IF 		(cTmp)->Z4_XSTATUS =="1"
	cStatusOs := "Em Aberto"
ElseIf 	(cTmp)->Z4_XSTATUS =="2"
	cStatusOs := "Fechada"
EndIf	

nPagAtu++
nLine := 150
cData := "Manaus, "+Alltrim(Str(day(ddatabase)))+" de "+mesextenso(ddatabase)+" de "+Alltrim(Str(year(ddatabase)))

If lPrint
	oPrn:SayBitmap (nLine - 35 ,nCol1,"\system\"+"lgrlorc"+cfilant+".BMP",500 ,300)
Endif

// IMPRESSAO DAS INFORMACOES DA AMAZONAVES
cEnd := aLLTRIM(SM0->M0_ENDENT) +" - "+AllTrim(SM0->M0_BAIRENT)
cCpf := Subs(SM0->M0_CGC,1,2)   +"."+Subs(SM0->M0_CGC,3,3)+"."+Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+Subs(SM0->M0_CGC,13,2)
cIE  := Subs(SM0->M0_INSC,1,2)  +"."+Subs(SM0->M0_INSC,3,3)+"."+Subs(SM0->M0_INSC,6,3)+"-"+Subs(SM0->M0_INSC,9,1)
cCep := Subs(SM0->M0_CEPENT,1,5)+"-"+Subs(SM0->M0_CEPENT,6,3)

If lPrint
	oPrn:Say(nLine,nCAux,AllTrim(SM0->M0_FULNAME)                   											 ,oFont2,,,,2)
Endif
ver_pag(50,nPaginas)
If lPrint
	oPrn:Say(nLine,nCAux,cEnd +" Fone:"+ SM0->M0_TEL + " Fax:" +Alltrim(SM0->M0_FAX)							 ,oFont2,,,,2)
Endif
ver_pag(50,nPaginas)
If lPrint
	oPrn:Say(nLine,nCAux,"CNPJ Nº "+cCpf +" - Insc. Est.:"+ cIE + " - SUFRAMA:" +Alltrim(SM0->M0_INS_SUF)    ,oFont2,,,,2)
Endif
ver_pag(50,nPaginas)
If lPrint
	oPrn:Say(nLine,nCAux,"CEP: "+cCep +" - "+AllTrim(SM0->M0_CIDCOB)+" - "+AllTrim(SM0->M0_ESTCOB)	 			 ,oFont2,,,,2)
Endif
ver_pag(50,nPaginas)

//If lPrint
//	oPrn:Say(nLinFim,3150, Transform(nPages,"@E 99")			,oFont2,,,,3)
//Endif
ver_pag(,nPaginas)
If lPrint
	oPrn:Say(nLine-150,nCol10 ,"Impresso por : "+cUserName	  	 ,oFont1n,,,,3)
Endif
nLine += nDifPixel
If lPrint
	oPrn:Say(nLine-150,nCol10 ,"Impresso as : " +Time()		  	 ,oFont1n,,,,3)
Endif
nLine += nDifPixel
If lPrint
	oPrn:Say(nLine-150,nCol10 ,cData						  	     ,oFont1n,,,,3)
Endif
nLine += nDifPixel
If lPrint
	oPrn:Say(nLine-150,nCol10 ,"Pagina: " + LTrim(Str(nPagAtu,10))+"/"+LTrim(Str(nPaginas,10))  ,oFont1n,,,,3)
Endif
nLine += (120 - nDifPixel)

ver_pag(nDifPixel,nPaginas)
ver_pag(nDifPixel,nPaginas)

If lPrint
	oPrn:Say(nLine ,nCol1     ,"Cliente: "		+(cTmp)->A1_NOME ,oFont4n,,,,3)
	nLine += 070
	oPrn:Say(nLine ,nCol1     ,"Endereço: "     +cEndereco    	 ,oFont4n,,,,3)
	nLine += 070
	oPrn:Say(nLine ,nCol1     ,"CNPJ / CPF: "   +cCGCPro         ,oFont4n,,,,3)
	oPrn:Say(nLine ,nCol3+300 ,"CEP: "     		+Subs((cTmp)->A1_CEP,1,5)+"-"+Subs((cTmp)->A1_CEP,6,3) ,oFont4n,,,,3)
	nLine += 070
	oPrn:Say(nLine ,nCol1     ,"Fax Nr: "		+(cTmp)->A1_TEL     ,oFont4n,,,,3)
	oPrn:Say(nLine ,nCol3+300 ,"Contato: "     	+(cTmp)->A1_CONTATO ,oFont4n,,,,3)
	nLine += 070
Else
	nLine += 070
	nLine += 070
	nLine += 070
	nLine += 070
Endif

ver_pag(nDifPixel,nPaginas)
ver_pag(nDifPixel,nPaginas)

If lPrint
	oPrn:Say(nLine ,nCAux ,"Proposta Nr: "	+cOrcamento + "  O.S: "+ Trim((cTmp)->CJ_XNUMOS)+ " - "+cStatusOs ,oFont4n,,,,2)
Endif
nLine += 070

cDatVal  := (cTmp)->CJ_VALIDA
//cAnvisa  := (cTmp)->B1_XANVISA
cFabric  := (cTmp)->B1_FABRIC
cCondPag := (cTmp)->E4_DESCRI
cAeronave := (cTmp)->Z4_XCODBE
//cPrazoEn := (cTmp)->CJ_XPRAZO
//cConv    := (cTmp)->CJ_XCONV
//cPacien  := (cTmp)->CJ_XPACIEN
//cDtProc  := (cTmp)->CJ_XDTPROC
//cMedico  := (cTmp)->CJ_XMEDICO
cFil     := (cTmp)->CJ_FILIAL
//cLocalpr := (cTmp)->CJ_XLOCAL
cObs1    := SUBSTR((cTmp)->CJ_XOBS,1,100)
cObs2    := SUBSTR((cTmp)->CJ_XOBS,101,100) 


Return

/*___________________________________________________________________________________
¦ Função    ¦ AMFATR01e  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 15/04/2008     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão do rodapé da proposta				                        ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function AmFatR01e(nPaginas)
	Local nAux2 := nCol3 + 200
	
	If (nLinFim - nLine) < 450
		If lPrint
			AvNewPage
		Endif
		nPagAtu++
		nLine := 150
		If lPrint
			oPrn:Say(nLine,nCol10 ,"Pagina: " + LTrim(Str(nPagAtu,10))+"/"+LTrim(Str(nPaginas,10))  ,oFont1n,,,,3)
		Endif
	EndIf
	
	nLine += 110
	nTotDesc += (cTmp)->CJ_DESCONT
	
	If lPrint
		oPrn:Say(nLine,nCol9+200,Upper("Total das Peças:   "    )+Transform(nTotPeca               ,"@E 999,999,999.99") ,oFont1n,,,,1)
	Endif
	ver_pag(nDifPixel,nPaginas)
	If lPrint
		oPrn:Say(nLine,nCol9+200,Upper("Total dos Serviços:   "    )+Transform(nTotServ               ,"@E 999,999,999.99") ,oFont1n,,,,1)
	Endif
	ver_pag(nDifPixel,nPaginas)
	If lPrint
		oPrn:Say(nLine,nCol9+200,Upper("Total dos Itens:   "    )+Transform(nTotal               ,"@E 999,999,999.99") ,oFont1n,,,,1)
	Endif
	ver_pag(nDifPixel,nPaginas)
	If lPrint
		oPrn:Say(nLine,nCol9+200,Upper("Desconto Geral(R$):   " )+Transform(nTotDesc             ,"@E 999,999,999.99") ,oFont1n,,,,1)
	Endif
	ver_pag(nDifPixel,nPaginas)
	If lPrint
		oPrn:Say(nLine,nCol9+200,Upper("Total Líquido:   "      )+Transform( (nTotal - nTotDesc) ,"@E 999,999,999.99") ,oFont1n,,,,1)
	Endif
	ver_pag(nDifPixel,nPaginas)
	If lPrint
		oPrn:Say(nLine,nAux2     ,Upper("Condições da Proposta  "),oFont1n,,,,1)
	Endif
	ver_pag(80,nPaginas)
	
	If lPrint
		oPrn:Say(nLine,nAux2     ,Upper("Validade da Proposta: "),oFont1n,,,,1)
		oPrn:Say(nLine,nAux2+10  ,SubStr(cDatVal,7,2)+"/"+SubStr(cDatVal,5,2)+"/"+SubStr(cDatVal,1,4)	,oFont2,,,,3)
	Endif
	ver_pag(nDifPixel,nPaginas)
	
	If lPrint
		oPrn:Say(nLine,nAux2     ,Upper("Cond. de Pagamento : ") ,oFont1n,,,,1)
		oPrn:Say(nLine,nAux2+10  ,cCondPag                       ,oFont2 ,,,,3)
	Endif
	ver_pag(nDifPixel,nPaginas)

	If lPrint
		oPrn:Say(nLine,nAux2     ,Upper("Aeronave : ") 			,oFont1n,,,,1)
		oPrn:Say(nLine,nAux2+10  ,cAeronave                     ,oFont2 ,,,,3)
	Endif
	ver_pag(nDifPixel,nPaginas)

	If lPrint
		oPrn:Say(nLine,nAux2     ,Upper("Obs : ") 				,oFont1n,,,,1)
		oPrn:Say(nLine,nAux2+10  ,cObs1                      	,oFont2 ,,,,3)
	Endif
	ver_pag(nDifPixel,nPaginas)
	If lPrint
		oPrn:Say(nLine,nAux2     ,Upper("  ")	 				,oFont1n,,,,1)
		oPrn:Say(nLine,nAux2+10  ,cObs2                      	,oFont2 ,,,,3)
	Endif
	ver_pag(nDifPixel,nPaginas)
	
	/*If lPrint
		oPrn:Say(nLine,nAux2     ,Upper("Prazo de Entrega : ")   ,oFont1n,,,,1)
		oPrn:Say(nLine,nAux2+10  , SubStr(cPrazoEn,7,2)+"/"+SubStr(cPrazoEn,5,2)+"/"+SubStr(cPrazoEn,1,4),oFont2 ,,,,3)
	Endif
	ver_pag(80,nPaginas)
	
	If !empty(cConv)
		If lPrint
			oPrn:Say(nLine,nAux2   ,Upper("Convenio : ") ,oFont1n,,,,1)
			oPrn:Say(nLine,nAux2+10, Posicione("SA1",1,XFILIAL("SA1")+cConv,"A1_NOME")                   ,oFont1 ,,,,3)
		Endif
		ver_pag(nDifPixel,nPaginas)
	EndIf
	
	If !empty(cPacien)
		If lPrint
			oPrn:Say(nLine,nAux2   ,Upper("Paciente : "),oFont1n,,,,1)
			oPrn:Say(nLine,nAux2+10, Posicione("SA1",1,XFILIAL("SA1")+cPacien,"A1_NOME")                 ,oFont2 ,,,,3)
		Endif
		ver_pag(nDifPixel,nPaginas)
	EndIf
	
	If !empty(cMedico)
		If lPrint
			oPrn:Say(nLine,nAux2, Upper("Medico : ")   ,oFont1n,,,,1)
			oPrn:Say(nLine,nAux2+10, Posicione("SA3",1,XFILIAL("SA3")+cMedico,"A3_NREDUZ")               ,oFont2 ,,,,3)
		Endif
		ver_pag(nDifPixel,nPaginas)
	EndIf
	
	If !empty(cDtProc)
		If lPrint
			oPrn:Say(nLine,nAux2, Upper("Data Procedimento : ") ,oFont1n,,,,1)
			oPrn:Say(nLine,nAux2+10, SubStr(cDtProc,7,2)+"/"+SubStr(cDtProc,5,2)+"/"+SubStr(cDtProc,1,4),oFont2 ,,,,3)
		Endif
		ver_pag(nDifPixel,nPaginas)
	EndIf
	
	If !empty(cLocalpr)
		If lPrint
			oPrn:Say(nLine,nAux2,Upper("Local Procedimento : ")  ,oFont1n,,,,1)
			oPrn:Say(nLine,nAux2+10, Posicione("SA1",1,XFILIAL("SA1")+cLocalpr,"A1_NOME")               ,oFont2 ,,,,3)
		Endif
		ver_pag(nDifPixel,nPaginas)
	EndIf
	
	ver_pag(nDifPixel,nPaginas)
	ver_pag(nDifPixel,nPaginas) */

Return

*****************************
Static Function ver_pag(nSalto,nPaginas)
*****************************
	Default nSalto := 0
	
	nLine += nSalto
	
	If nLine >= nLinFim
		If lPrint
		//	oPrn:Say(nLinFim,3150, Transform(nPages,"@E 99")			,oFont2,,,,3)
			AvNewPage
		Endif
		nPages ++
		nPagAtu++
		nLine := 150
		If lPrint
			oPrn:Say(nLine,nCol7 ,"Pagina: " + LTrim(Str(nPagAtu,10))+"/"+LTrim(Str(nPaginas,10))  ,oFont1n,,,,3)
		Endif
		nLine += 100
	EndIf
	
Return
