#Include "Protheus.ch"
#include "topconn.ch"

#define DMPAPER_LETTER 1 		&& Letter 8 1/2 x 11 in
#define DMPAPER_LETTERSMALL 2 	&& Letter Small 8 1/2 x 11 in
#define DMPAPER_TABLOID 3 		&& Tabloid 11 x 17 in
#define DMPAPER_LEDGER 4 		&& Ledger 17 x 11 in
#define DMPAPER_LEGAL 5 		&& Legal 8 1/2 x 14 in
#define DMPAPER_STATEMENT 6 	&& Statement 5 1/2 x 8 1/2 in
#define DMPAPER_EXECUTIVE 7 	&& Executive 7 1/4 x 10 1/2 in
#define DMPAPER_A3 8 			&& A3 297 x 420 mm
#define DMPAPER_A4 9 			&& A4 210 x 297 mm
#define DMPAPER_A4SMALL 10 		&& A4 Small 210 x 297 mm
#define DMPAPER_A5 11 			&& A5 148 x 210 mm
#define DMPAPER_B4 12			&& B4 250 x 354
#define DMPAPER_B5 13			&& B5 182 x 257 mm
#define DMPAPER_FOLIO 14		&& Folio 8 1/2 x 13 in
#define DMPAPER_QUARTO 15		&& Quarto 215 x 275 mm
#define DMPAPER_10X14 16		&& 10x14 in
#define DMPAPER_11X17 17		&& 11x17 in
#define DMPAPER_NOTE 18			&& Note 8 1/2 x 11 in

/*/{Protheus.doc} ETQMTG

Funcao principal para impressao de Etiquetas por Ordem de Producao.

@type function
@author Waldir Baldin
@since 02/07/10

/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ETQOPA4  º Autor ³ Waldir Baldin      º Data ³   02/07/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao principal para impressao de Etiquetas               º±±
±±º          ³ por Ordem de Producao.  									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HONDA LOCK                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alteracao³ EFetuado o tratamento para impressão  para o tamanho do    º±±
±±º          ³ papel A4. - TOTVS IP Unidade Campinas dia 19.07.2010       º±±
±±º          ³    -  Incluido os Defines                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ETQMTG()

	Local nRegs			:= 0
	
	Private cPerg		:= "ETQMTG"
	Private nLastKey	:= 0
/*
 Perguntas
 =========
 MV_PAR01 - Lado Desejado ? 	LEFT - Papel Branco / RIGHT - Papel Verde / NENHUM - Papel Amarelo
 MV_PAR02 - OP de ?
 MV_PAR03 - OP Ate ?
 MV_PAR04 - Data Emissao de ?
 MV_PAR05 - Data Emissao Ate ?
*/
	ValidPerg(cPerg)
	If Pergunte(cPerg, .T.)
		If nLastKey != 27
			if Mv_Par02 > Mv_Par03 .Or. Empty(Mv_Par03) .Or. Mv_Par04 > Mv_Par05 .Or. Empty(Mv_Par05)
			   MsgBox("Existem Parâmetros Informados Incorretamente !!!", "Atenção !!!", "INFO")
			else
				Processa({|| SelRegs(@nRegs)}, "Selecionando Registros...")
				if nRegs > 0
					Processa({|| GeraETQ(nRegs)}, "Imprimindo...")
					TSC2->(dbCloseArea())
				Else
					TSC2->(dbCloseArea())
				endIf
			endIf
		EndIf		  
	EndIf		
Return

*************************************************************************************************************************************************************************
// SelRegs - Waldir baldin - 02/07/2010 -  Funcao responsavel por selecionar os registros que se enquadram no filtro.
*************************************************************************************************************************************************************************
Static Function SelRegs(nRegs)
	/*
    && Bloco original do programa alterado para efetuar o tratamento para impressáo de todas os lados.
    && Dia 27/07/2010
    
	Local cLado := IIf(MV_PAR01 == 1, "L", IIf(MV_PAR01 == 2, "R", "N"))
	
	BeginSql alias "TSC2"
		column C2_EMISSAO	as Date
		column C2_DATPRF	as Date
		column C2_QUANT		as Numeric(12, 02)
		column B1_QE		as Numeric(09, 00)
	
		%noparser%
		
		SELECT
		    C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD, C2_EMISSAO, C2_PRODUTO, C2_QUANT, C2_NUM, C2_DATPRF,
		    B1_QE, B1_CODMATR, B1_DESCHL, B1_LADO
		FROM
			%table:SC2% SC2
		    INNER JOIN %table:SB1% SB1 ON 
		        B1_FILIAL = %xfilial:SB1% AND B1_COD = C2_PRODUTO AND B1_LADO = %exp:cLado% AND SB1.%notDel%
		WHERE
		    C2_FILIAL = %xfilial:SC2%															AND
		    C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD BETWEEN %exp:MV_PAR02% AND %exp:MV_PAR03% AND
		    C2_DATPRF BETWEEN %exp:MV_PAR04% AND %exp:MV_PAR05%									AND
		    C2_SEQUEN = '001' AND SC2.D_E_L_E_T_ = ' '
		ORDER BY
			C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD
	EndSql 

	 memoWrit("\HLETQOP001.sql", GetLastQuery()[2])
    */
    
    _cQuery := 	"	SELECT "
    _cQuery += 	"		    SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_EMISSAO, SC2.C2_PRODUTO, SC2.C2_QUANT, SC2.C2_DATPRF, "
    _cQuery += 	"		    SB1.B1_QE, SB1.B1_COD, SB1.B1_CODMATR, SB1.B1_DESCHL, SB1.B1_LADO,SC2.C2_IMPETQ  "
    _cQuery += 	" 	FROM "
    _cQuery += 	"   " + RetSqlName("SC2") + " SC2 "
    _cQuery += 	"      INNER JOIN "+RetSQlName("SB1") + " SB1 ON "
    _cQuery += 	"         SB1.B1_FILIAL = '"+ xfilial("SB1") + "' AND "
    _cQuery += 	"         SB1.B1_COD = SC2.C2_PRODUTO AND "
	If MV_PAR01 == 1
	    _cQuery += 	"         SB1.B1_LADO = 'L' AND "
	ElseIF MV_PAR01 == 2
   	    _cQuery += 	"         SB1.B1_LADO = 'R' AND "
	ElseIF MV_PAR01 == 3
   	    _cQuery += 	"         SB1.B1_LADO = 'N' AND "
   	Else
   	    _cQuery += 	"         SB1.B1_LADO IN ('L','R','N') AND "
   	Endif    	
    _cQuery += 	"         SB1.D_E_L_E_T_ = ' ' "
    _cQuery += 	"   WHERE
    _cQuery += 	"      C2_FILIAL = '"+xfilial("SC2") + "' AND "
    _cQuery += 	"      C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "'  AND "
    _cQuery += 	"      C2_DATPRF BETWEEN '"+ DTOS(MV_PAR04)+"' AND '" + DTOS(MV_PAR05) +"' AND "
  //  _cQuery += 	"      C2_SEQUEN = '001' AND SC2.D_E_L_E_T_ = ' ' AND B1_TIPO = 'PI' AND B1_LOCPAD = '04' " // Alterado por Luciano Lamberti - 13-03-2019 (alteração dos PI´s por PP - bloco K)
    _cQuery += 	"      C2_SEQUEN = '001' AND SC2.D_E_L_E_T_ = ' ' AND B1_TIPO = 'PP' AND B1_LOCPAD = '04' "
    _cQuery += 	"   ORDER BY "
    _cQuery += 	"      C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD "

	TcQuery _cQuery Alias "TSC2" New

    TCSetFIELD("TSC2","C2_EMISSAO","D")  
    TCSetFIELD("TSC2","C2_DATPRF","D")  
    
	count to nRegs
	TSC2->(dbGoTop())
Return

*************************************************************************************************************************************************************************
// GeraETQ - Waldir baldin - 02/07/2010 -  Funcao responsavel por controlar o laco principal dos registros selecionados.
*************************************************************************************************************************************************************************
Static Function GeraETQ(nRegs)
	Local cQuant	:= ""
	Local nInteiro	:= 0
	Local nResto	:= 0
	Local nI		:= 0
	Local nJ		:= 0
	Local nL		:= 0
	Local nC		:= 0
	
	Private oPrint

	ProcRegua(nRegs)	
	
	oPrint:= TAVPrinter():New( "ETIQUETAS ORDEM DE PRODUÇÃO" )
	oPrint:SetPortrait()      // fixa impressao em Retrato
	oPrint:Setup()
	oPrint:setPaperSize( DMPAPER_A4 ) && Incluido esta linha para efetuar o tratamento do tamanho do formulario que se imprime as etiquetas. Dia 27/08/2010
	
	do while TSC2->(!eof())
		IncProc("Imprimindo OP: " + allTrim(C2_NUM) + allTrim(C2_ITEM) + allTrim(C2_SEQUEN) + allTrim(C2_ITEMGRD))
          
//---    
  cQry := " UPDATE "+RetSqlName("SC2")
  cQry += " SET C2_IMPETQ = '1'"
  cQry += " WHERE D_E_L_E_T_ ='' AND C2_NUM = '"+TSC2->C2_NUM+"'"
  cQry += " AND C2_ITEM = '"+TSC2->C2_ITEM+"' AND C2_SEQUEN = '"+TSC2->C2_SEQUEN+"' "
  TCSQLEXEC(cQry)   
//--- 
		cQuant		:= PadL(AllTrim(Str(Round(TSC2->C2_QUANT / TSC2->B1_QE, 02))), 13, '0')
		If SubStr(cQuant, 11, 01) != "." .And. SubStr(cQuant, 12, 01) != "."
			cQuant	:= PadL(AllTrim(Str(Round(TSC2->C2_QUANT / TSC2->B1_QE, 02))), 10, '0') + ".00"
		ElseIf SubStr(cQuant, 12, 01) == "."
			cQuant	:= PadL(AllTrim(Str(Round(TSC2->C2_QUANT / TSC2->B1_QE, 02))), 12, '0') + "0"
		EndIf
		nInteiro	:= Val(SubStr(cQuant, 01, 10))
		nResto		:= TSC2->C2_QUANT - (nInteiro * TSC2->B1_QE)
		If nResto > 0
			_nInt	:= nInteiro + 1
		Else
			_nInt	:= nInteiro
		EndIf
		
		&& If nInteiro = 0 
		&&    nInteiro := _nInt
		&& Endif
		   
		nL			:= 1
		nC			:= 1
		
		oPrint:StartPage()
		
		For nI := 1 to nInteiro
			For nJ := 1 to 2
				ImpEtq(TSC2->B1_QE, nI, "", nL, nC)
				If nL == 1 .And. nC == 1
					nL := 1
					nC := 2
				ElseIf nL == 1 .And. nC == 2
					nL := 2
					nC := 1
				ElseIf nL == 2 .And. nC == 1
					nL := 2
					nC := 2
				ElseIf nL == 2 .And. nC == 2
					nL := 3
					nC := 1
				ElseIf nL == 3 .And. nC == 1
					nL := 3
					nC := 2
				Else
					nL := 1
					nC := 1
				   	if nI < nInteiro
						oPrint:EndPage()
						oPrint:StartPage()
					endIf   //vfv
				endIf
			next nJ
		next nI
	  	If nResto > 0 //vfv
		    
		    && Incluido o tratamento para fechar a pagina para que na impressáo o sistema náo encavale etiquetas.
		    && Implementacao feita pelo Analista Alexandre J. Conselvan - Totvs IP Unidade Campinas - Fabrica de Software 
		   If nL = 1 .and. nC = 1 .and. nI <> 1
			  	oPrint:EndPage()
			  	oPrint:StartPage()
	   		Endif 	 //VFV
			  
		    
		   	ImpEtq(nResto, nI, "", nL, nC) 

				If nL == 1 .And. nC == 1 
					nL := 1
					nC := 2
				ElseIf nL == 1 .And. nC == 2
					nL := 2
					nC := 1
				ElseIf nL == 2 .And. nC == 1
					nL := 2
					nC := 2
				ElseIf nL == 2 .And. nC == 2
					nL := 3
					nC := 1
				ElseIf nL == 3 .And. nC == 1
					nL := 3
					nC := 2
				Else
					nL := 1
					nC := 1
				   	if nI < nInteiro
						oPrint:EndPage()
						oPrint:StartPage()
				  	endIf
				  	endIf  

		
		   	ImpEtq(nResto, nI, "", nL, nC)
			&& Final do tratamento para que o sistema imprima certa a ultima etiqueta duplicada conforme padrao da Honda Lock, 
			&& Bem como a impressáo da etiquetas náo sobre postas.
			 
		endIf 

oPrint:EndPage() 
	  			
		TSC2->(dbSkip())
   	endDo
	  	 
	oPrint:Preview()  // Visualiza antes de imprimir 
	
Return()

*************************************************************************************************************************************************************************
// ImpEtq - Waldir baldin - 02/07/2010 -  Funcao responsavel por imprimir os dados levantados.
*************************************************************************************************************************************************************************
Static Function ImpEtq(nQtdEtq, nSeq, cLote, nL, nC)
	Local cTexto	:= ""
	Local cTexto1	:= ""
	Local nLi		:= 0
	Local nCo		:= 0
	Local nLiMsBar	:= 0
	Local nCoMsBar	:= 0

	Local oFont09	:= TFont():New("Arial", 09, 09, .T., .F., 05,,, .T., .F.,,,,,, oPrint)	
	Local oFont11	:= TFont():New("Arial", 09, 11, .T., .F., 05,,, .T., .F.,,,,,, oPrint)
	Local oFont13	:= TFont():New("Arial", 09, 13, .T., .F., 05,,, .T., .F.,,,,,, oPrint)
	Local oFont17N	:= TFont():New("Arial", 09, 17, .T., .T., 05,,, .T., .F.,,,,,, oPrint)
	Local oFont18N	:= TFont():New("Arial", 09, 18, .T., .T., 05,,, .T., .F.,,,,,, oPrint)
	Local oFont24N	:= TFont():New("Arial", 09, 24, .T., .T., 05,,, .T., .F.,,,,,, oPrint)
	Local oFont36N	:= TFont():New("Arial", 09, 36, .T., .T., 05,,, .T., .F.,,,,,, oPrint)
	Local oBrush	:= TBrush():New("", 04)

	If nL == 1 .And. nC == 1
		nLi			:= 0
		nCo			:= 0
		nLiMsBar	:= 0
		nCoMsBar	:= 0
	ElseIf nL == 1 .And. nC == 2
		nLi			:= 0
		nCo			:= 1150
		nLiMsBar	:= 0
		nCoMsBar	:= 9.7
	ElseIf nL == 2 .And. nC == 1
		nLi			:= 1169 && 1065 && Incrementado 104 pontos a mais para que este efetue o pulo correto na nova pagina A4 - Dia 27/08/2010
		nCo			:= 0
		nLiMsBar	:= 9.9 && 9  && Incrementado .9 pontos a mais para que este efetue o pulo correto na nova pagina A4 ( Codigo de Barras ) - Dia 27/08/2010
		nCoMsBar	:= 0
	ElseIf nL == 2 .And. nC == 2
		nLi			:= 1169 && 1065 && Incrementado 104 pontos a mais para que este efetue o pulo correto na nova pagina A4 - Dia 27/08/2010
		nCo			:= 1150
		nLiMsBar	:= 9.9 && 9  && Incrementado .9 pontos a mais para que este efetue o pulo correto na nova pagina A4 ( Codigo de Barras ) - Dia 27/08/2010
		nCoMsBar	:= 9.7
	ElseIf nL == 3 .And. nC == 1
		nLi			:= 2338 && 2130 && Incrementado 208 pontos a mais para que este efetue o pulo correto na nova pagina A4 - Dia 27/08/2010
		nCo			:= 0
		nLiMsBar	:= 19.8 && 18   && Incrementado 1.8 pontos a mais para que este efetue o pulo correto na nova pagina A4 ( Codigo de Barras ) - Dia 27/08/2010
		nCoMsBar	:= 0
	ElseIf nL == 3 .And. nC == 2
		nLi			:= 2338 && 2130 && Incrementado 208 pontos a mais para que este efetue o pulo correto na nova pagina A4 - Dia 27/08/2010
		nCo			:= 1150
		nLiMsBar	:= 19.8 && 18   && Incrementado 1.8 pontos a mais para que este efetue o pulo correto na nova pagina A4 ( Codigo de Barras ) - Dia 27/08/2010
		nCoMsBar	:= 9.7
	EndIf
	
	//deslocamento - margens
	nLi += 20
	nCo += 50
	
	oPrint:Box(nLi + 18, nCo + 18, nLi + 1033, nCo + 1113)
	oPrint:Box(nLi + 23, nCo + 23, nLi + 1028, nCo + 1108)
	
	nLi += 20
	nCo += 25
	
	cTexto := AllTrim(SubStr(TSC2->B1_COD, 01, 30))   //VFV MATR
   	MSBAR("CODE128", nLiMsBar + 0.85, nCoMsBar + 1.9, cTexto, oPrint, .F., NIL, NIL, 0.027, 1.10, NIL, NIL, "A", .F.)  //VFV
   //	MSBAR("CODE128", nLiMsBar, nCoMsBar + 1.9 , cTexto, oPrint, .F., NIL, NIL, 0.027, 1.10, NIL, NIL, "A", .F.)
	nLi += 150

	// Primeiro quadro - CODIGO CLIENTE
	oPrint:Line(nLi, nCo, nLi, nCo + 1090)						// Linha Horizontal
	oPrint:Say(nLi, nCo + (1090 / 2), "CÓDIGO HLS",											oFont11,,, 1, 2)
	nLi += 50
	oPrint:Line(nLi, nCo, nLi, nCo + 1090)						// Linha Horizontal
	nLi += 30
	oPrint:Say(nLi, nCo + (1090 / 2), cTexto,													oFont17N,,, 1, 2)
	nLi += 90
	
	// Segundo quadro - NUMERO DO LOTE
	oPrint:Line(nLi, nCo, nLi, nCo + 1090)						// Linha Horizontal
	oPrint:Say(nLi, nCo + (250 / 2), "LOTE",													oFont11,,, 1, 2)
	oPrint:Line(nLi, nCo + 250,nLi + 170, nCo+250)				// Linha Vertical
	oPrint:Line(nLi, nCo + 255,nLi + 170, nCo+255)				// Linha Vertical
	oPrint:Say(nLi, nCo + 250 + ((1090 - 250) / 2), Space(03) + "NRO. O.P.",					oFont11,,, 1, 2)
	nLi += 50
	oPrint:Line(nLi,nCo + 750, nLi + 120, nCo + 750)			// Linha Vertical
	oPrint:Line(nLi,nCo + 755, nLi + 120, nCo + 755)			// Linha Vertical
	cTexto1 := TSC2->C2_NUM+C2_ITEM+C2_SEQUEN // ALTERAR                   
	cTexto := TSC2->C2_NUM
 	MSBAR("CODE128", nLiMsBar + 4, nCoMsBar + 4, cTexto, oPrint, .F., NIL, NIL, 0.020, 0.8, NIL, NIL, "A", .F.) //Luciano Lamberti - alterado o cód de barras 
	oPrint:Line(nLi, nCo, nLi, nCo + 1090)						// Linha Horizontal
	nLi += 50
	oPrint:Say(nLi, nCo + 800, Space(04) + cTexto,												oFont13)
	nLi += 70
	
	// Terceiro quadro - NOME DA PECA
	oPrint:Line(nLi, nCo, nLi, nCo + 1090)						// Linha Horizontal
	oPrint:Say(nLi, nCo, Space(45) + "NOME DA PEÇA",											oFont11)
	nLi += 50
	oPrint:Line(nLi, nCo, nLi, nCo + 1090)						// Linha Horizontal
	nLi += 50
   //	oPrint:Say(nLi, nCo, Space(10) + Substr(TSC2->B1_DESCHL, 01, 40),							oFont13)
   oPrint:Say(nLi, nCo, Space(10) + Substr(TSC2->B1_DESCHL, 01, 40),			oFont13 )//vfv
   //	oPrint:Say(nLi, nCo, TSC2->B1_COD + Substr(TSC2->B1_DESCHL, 01, 40),							oFont13) //VFV
	nLi += 70
	
	// Quarto quadro - DATA DA PRODUCAO + LOTE
	oPrint:Line(nLi, nCo, nLi, nCo + 1090)						// Linha Horizontal
	oPrint:Say(nLi, nCo + (1090 / 2),"DATA DA PRODUÇÃO",										oFont11,,, 1, 2)
	nLi += 50
	oPrint:Line(nLi, nCo, nLi, nCo + 1090)						// Linha Horizontal
	oPrint:Line(nLi, nCo + 500, nLi + 290, nCo + 500)			// Linha Vertical
	oPrint:Line(nLi, nCo + 505, nLi + 290, nCo + 505)			// Linha Vertical
	nLi += 50
	cTexto := DtoC(TSC2->C2_DATPRF)
	oPrint:Say(nLi,nCo + (500 / 2), cTexto,														oFont17N,,, 1, 2)
   	MSBAR("CODE128", nLiMsBar + 6.85, nCoMsBar + 6.2, cTexto, oPrint, .F., NIL, NIL, 0.027, 0.8, NIL, NIL, "A", .F.) //VFV
 //  	MSBAR("CODE128", nLiMsBar + 5.97 , nCoMsBar + 5.2, cTexto, oPrint, .F., NIL, NIL, 0.027, 0.8, NIL, NIL, "A", .F.)
	nLi += 70

	// Ultimo quadro - Quantidades
	oPrint:Line(nLi, nCo, nLi, nCo + 1090)						// Linha Horizontal
   	oPrint:Line(nLi, nCo + 790, nLi + 170, nCo + 790)			// Linha Vertical
	oPrint:Line(nLi, nCo + 795, nLi + 170, nCo + 795)			// Linha Vertical
	oPrint:Say(nLi, nCo + (500 / 2), "QUANTIDADE",												oFont09,,, 1, 2)
	oPrint:Say(nLi, nCo + 550, "SEQUENCIA",														oFont09)
	oPrint:Say(nLi, nCo + 800, "RESPONSAVEL",													oFont09)
	nLi += 50
	oPrint:Line(nLi, nCo + 250, nLi + 120, nCo + 250)			// Linha Vertical
	oPrint:Line(nLi, nCo + 255, nLi + 120, nCo + 255)			// Linha Vertical
	oPrint:Line(nLi, nCo, nLi, nCo + 1090)						// Linha Horizontal
	nLi += 50
	cTexto := cValToChar(nQtdEtq)
	MSBAR("CODE128", nLiMsBar + 8.3, nCoMsBar + 1.3, cTexto, oPrint, .F., NIL, NIL, 0.027, 0.8, NIL, NIL, "A", .F.) //VFV
//	MSBAR("CODE128", nLiMsBar + 7.4, nCoMsBar + 0.5, cTexto, oPrint, .F., NIL, NIL, 0.020, 0.9, NIL, NIL, "A", .F.)   
	oPrint:Say(nLi - 40, nCo + 150, Space(07) + cTexto,											oFont24N)
	oPrint:Say(nLi - 20, nCo + 540, Space(03) + cValToCHar(nSeq) + "/" + cValToCHar(_nInt),		oFont18N)
	nLi += 70
	
	/*
	//Final da Impressão da Etiqueta
	If nL == 3 .And. nC == 2
		oPrint:EndPage()
		oPrint:StartPage()
	EndIf
	*/
Return(.T.)

*************************************************************************************************************************************************************************
// ValidPerg - Waldir baldin - 02/07/2010 -  Funcao para criar as perguntas no arquivo SX1
*************************************************************************************************************************************************************************
Static Function ValidPerg()
	Local aAreaATU	:= GetArea()
	Local aAreaSX1	:= SX1->(GetArea())
	Local aRegs		:= {}
	Local nI		:= 0
	Local nJ        := 0
	
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	cPerg := PadR(cPerg, Len(X1_GRUPO))
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Lado (Cor do Papel) ?",	"Lado (Cor do Papel) ?",	"Lado (Cor do Papel) ?",	"mv_ch1", "N", 01, 0, 0, "C", "", "MV_PAR01", "LEFT(Branco)",	"", "", "", "", "RIGHT(Verde)",	"", "", "", "", "NENHUM(Amarelo)",	"", "", "", "", "TODOS(Rosa)", "", "", "", "", "", "", "", "", ""		})
	aAdd(aRegs, {cPerg, "02", "OP de ?",				"OP de ?",					"OP de ?",					"mv_ch2", "C", 13, 0, 0, "G", "", "MV_PAR02", "",				"", "", "", "", "",				"", "", "", "", "",					"", "", "", "", "", "", "", "", "", "", "", "", "", "SC2"	})
	aAdd(aRegs, {cPerg, "03", "OP Ate ?",				"OP Ate ?",					"OP Ate	?",					"mv_ch3", "C", 13, 0, 0, "G", "", "MV_PAR03", "",				"", "", "", "", "",				"", "", "", "", "",					"", "", "", "", "", "", "", "", "", "", "", "", "", "SC2"	})
	Aadd(aRegs, {cPerg, "04", "Data Emissao de ?",		"Data Emissao de ?",		"Data Emissao de ?",		"mv_ch4", "D", 08, 0, 0, "G", "", "Mv_Par04", "",				"", "", "", "", "",				"", "", "", "", "",					"", "", "", "", "", "", "", "", "", "", "", "", "", ""		})
	Aadd(aRegs, {cPerg, "05", "Data Emissao Ate ?",		"Data Emissao Ate ?",		"Data Emissao Ate ?",		"mv_ch5", "D", 08, 0, 0, "G", "", "Mv_Par05", "",				"", "", "", "", "",				"", "", "", "", "",					"", "", "", "", "", "", "", "", "", "", "", "", "", ""		})
	
	For nI := 1 to Len(aRegs)
		If !SX1->(dbSeek(cPerg + aRegs[nI, 2]))
			RecLock("SX1", .T.)
			For nJ := 1 To FCount()
				If nJ <= Len(aRegs[nI])
					FieldPut(nJ, aRegs[nI, nJ])
				EndIf
			Next nJ
			SX1->(MsUnlock())
		EndIf
	Next nI
	
	RestArea(aAreaSX1)
	RestArea(aAreaATU)
Return
