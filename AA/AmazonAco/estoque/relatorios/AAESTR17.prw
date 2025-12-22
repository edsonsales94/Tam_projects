
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exemplo de relatorio usando tReport com duas Section
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
user function AAESTR17()
	Local cPerg := PADR("AAESTR17",Len(SX1->X1_GRUPO))
	
	Private oReport, oSection1, oSection

	fValidSX1()
	Pergunte(cPerg,.F.)
	
	oReport := ReportDef(cPerg)
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	oReport:PrintDialog()

return
  Static Function ReportDef(cPerg)

local cTitle  := "Analise Compras X contabilidade"
local cHelp   := "Analise Compras X contabilidade"
Local aOrdem  := {"Compras X contabilidade"}
local oReport
local oSection1
local oSection2
local oBreak1
Local nTotal	:= 0
oReport := TReport():New("AAESTR17", cTitle, cPerg , {|oReport| ReportPrint(oReport)},cTitle)
oReport:oPage:SetPaperSize(9)
oReport:SetPortrait(.T.)
oReport:SetTotalInLine(.F.)


//Segunda seção
oSection2:= TRSection():New(oReport,"Analise Compras X contabilidade",{"TMP"},aOrdem)          
oSection2:AutoSize(.F.)
TRCell():New( oSection2, "FILIAL"       , "", "FILIAL"             	   	 ,"@!"                                                          ,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "DOC"   	    , "", "DOC"			             ,"@!"                                                          ,14,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "SERIE"   	    , "", "SERIE"		             ,"@!"                                                          ,5,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "FORNECE"   	, "", "FORNECE"		             ,"@!"                                                          ,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "NOME_FOR"		, "", "NOME_FOR"				 ,"@!"               	                                        ,30,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "DIGITACAO"	, "", "DIGITACAO"				 ,"@!"	                                                        ,10,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "EMISSAO"		, "", "EMISSAO"					 ,"@!"	                                                        ,10,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "VALOR_CONTAB"	, "", "VALOR_CONTAB"			 ,"@E 999,999,999.99"	                                        ,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "TOTAL"		, "", "TOTAL"					 ,"@E 999,999,999.99"	                                        ,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "CUSTO"		, "", "CUSTO"					 ,"@E 999,999,999.99"	                                        ,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "DIF"		    , "", "DIF"				    	 ,"@E 999,999,999.99"	                                        ,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)



  
oSection2:SetTotalInLine(.F.)	

                          	
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport)

local oSection2 := oReport:Section(1)  
local cOrdem 
Local cQry := "" 
Local nTotREG := 0                                                

if oReport:Section(1):GetOrder() == 1
	cOrdem := "D1_DTDIGIT"
Else
	cOrdem := "D1_DTDIGIT"		 
endif 

cQry+=" SELECT ISNULL(D1_FILIAL , CT2_FILORI ) AS FILIAL,  " 
cQry+="       ISNULL(D1_DOC    , DOC     ) AS DOC, "       
cQry+="       ISNULL(D1_SERIE  , SERIE   ) AS SERIE, "
cQry+="	   ISNULL(D1_FORNECE, FORNECE ) AS FORNECE, " 
cQry+="    ISNULL(A2_NOME, '') AS NOME_FOR, " 
cQry+="	   CONVERT( VARCHAR, CONVERT( DATE, ISNULL(D1_DTDIGIT, CT2_DATA)) ,103) AS DIGITACAO, " 
cQry+="	   CONVERT( VARCHAR, CONVERT( DATE, ISNULL(D1_EMISSAO, ''      )) ,103) AS EMISSAO, " 
cQry+="	   ISNULL(CT2_VALOR  , 0 ) AS VALOR_CONTAB, "
cQry+="	   ISNULL(D1_TOTAL   , 0 ) AS TOTAL, " 	  
cQry+="	   ISNULL(CUSTO      , 0 ) AS CUSTO, "
cQry+="	   ROUND( ISNULL(CT2_VALOR  , 0 ) - ISNULL(CUSTO      , 0 ) , 2) AS DIF "
//cQry+="	   --ISNULL(CT2_DEBITO , '') AS CONTA_D, " 
//cQry+="	   --ISNULL(CT2_DEBITO , '') AS CONTA_D, " 
//cQry+="	  -- ISNULL(CT2_HIST   , '') AS HIST " 	    
cQry+="  FROM ( SELECT DOC, SERIE, FORNECE, LOJA, CT2_DATA, CT2_FILORI, SUM(CT2_VALOR) AS CT2_VALOR " 
cQry+="           FROM ( SELECT SUBSTRING(CT2_KEY,  3, 9) AS DOC, SUBSTRING(CT2_KEY, 12, 3) AS SERIE, SUBSTRING(CT2_KEY, 15, 6) AS FORNECE, SUBSTRING(CT2_KEY, 21, 2) AS LOJA, " 
cQry+="                         CT2_DATA, CT2_FILORI, SUM(CT2_VALOR) AS CT2_VALOR " 	   
cQry+="				    FROM CT2010 CT2 (NOLOCK) "
cQry+="				    LEFT JOIN CT1010 CT1C (NOLOCK) ON CT1C.D_E_L_E_T_ = '' AND CT1C.CT1_CONTA = CT2_CREDIT " 
cQry+="				    LEFT JOIN CT1010 CT1D (NOLOCK) ON CT1D.D_E_L_E_T_ = '' AND CT1D.CT1_CONTA = CT2_DEBITO "
cQry+="				   WHERE CT2.D_E_L_E_T_ = '' 
cQry+="               AND CT2_DATA >='"+DtoS(mv_par01)+"' "
cQry+="               AND CT2_DATA <='"+DtoS(mv_par02)+"' " 
cQry+="               AND CT2_TPSALD = '1' "
cQry+="					 AND left(CT2_DEBITO, 3) = '115' AND CT2_LOTE = '008810' "
cQry+="				   GROUP BY SUBSTRING(CT2_KEY,  3, 9), SUBSTRING(CT2_KEY, 12, 3), SUBSTRING(CT2_KEY, 15, 6), SUBSTRING(CT2_KEY, 21, 2), CT2_DATA, CT2_FILORI "
cQry+="				  Union all "
cQry+="				 SELECT SUBSTRING(CT2_KEY,  3, 9) AS DOC, SUBSTRING(CT2_KEY, 12, 3) AS SERIE, SUBSTRING(CT2_KEY, 15, 6) AS FORNECE, SUBSTRING(CT2_KEY, 21, 2) AS LOJA, " 
cQry+="						CT2_DATA, CT2_FILORI, SUM(CT2_VALOR) * -1 AS CT2_VALOR " 	   
cQry+="				   FROM CT2010 CT2 (NOLOCK) "
cQry+="				   LEFT JOIN CT1010 CT1C (NOLOCK) ON CT1C.D_E_L_E_T_ = '' AND CT1C.CT1_CONTA = CT2_CREDIT " 
cQry+="				   LEFT JOIN CT1010 CT1D (NOLOCK) ON CT1D.D_E_L_E_T_ = '' AND CT1D.CT1_CONTA = CT2_DEBITO "	
cQry+="				  WHERE CT2.D_E_L_E_T_ = ''
cQry+="               AND CT2_DATA >='"+DtoS(mv_par01)+"' "
cQry+="               AND CT2_DATA <='"+DtoS(mv_par02)+"' " 
cQry+="               AND CT2_TPSALD = '1' "
cQry+="					AND left(CT2_CREDIT, 3) = '115' AND CT2_LOTE = '008810' "
cQry+="				  GROUP BY SUBSTRING(CT2_KEY,  3, 9), SUBSTRING(CT2_KEY, 12, 3), SUBSTRING(CT2_KEY, 15, 6), SUBSTRING(CT2_KEY, 21, 2), CT2_DATA, CT2_FILORI "
cQry+="	            ) AS CTB "	    
cQry+="            GROUP BY  DOC, SERIE, FORNECE, LOJA, CT2_DATA, CT2_FILORI " 
cQry+="		) AS CT2 "  
cQry+="  FULL JOIN ( Select D1_FILIAL , D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, A2_NOME, D1_TIPO, D1_DTDIGIT, D1_EMISSAO,  SUM(D1_TOTAL) AS D1_TOTAL, SUM(D1_VALFRE)  AS FRETE , " 
cQry+="		             SUM(D1_SEGURO)  AS SEGURO,  SUM(D1_DESPESA) AS DESPESA, SUM(D1_IPI) AS IPI, SUM(D1_VALDESC) AS DESCONTO, SUM(D1_CUSTO) AS CUSTO, " 
cQry+="					 SUM(D1_VALISS) AS ISS, SUM(D1_VALINS) AS INSS, SUM(D1_VALPIS) AS PIS, SUM(D1_VALCOF) AS COF, SUM(D1_VALIRR) AS IRRF, SUM(D1_VALCSL) AS CSLL "
cQry+="			    From SD1010 AS SD1 (NOLOCK) "
cQry+="			   INNER JOIN SF4010 AS SF4 (NOLOCK) ON SF4.D_E_L_E_T_ = ' ' AND F4_CODIGO  = D1_TES AND F4_ESTOQUE = 'S' AND F4_PODER3 = 'N' "
cQry+="			   INNER JOIN SA2010 AS SA2 (NOLOCK) ON SA2.D_E_L_E_T_ = ' ' AND A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA "
cQry+="			   INNER JOIN SB1010 SB1 (NOLOCK) ON SB1.D_E_L_E_T_ = ' ' AND B1_COD     = D1_COD AND B1_TIPO NOT IN ('ZC', 'MC') "   
cQry+="			   WHere SD1.D_E_L_E_T_ = ' ' AND D1_CF NOT IN ('1905', '1906') "
cQry+="			     And D1_DTDIGIT >='"+DtoS(mv_par01)+"' "
cQry+="			     And D1_DTDIGIT <='"+DtoS(mv_par02)+"' " 
cQry+="			     and D1_TIPO in ('C', 'N') "
//cQry+="			 --    AND A2_COD NOT IN ('000116','100644', '000117') "
cQry+="			   GROUP BY D1_FILIAL , D1_DOC, D1_SERIE, D1_FORNECE, D1_TIPO, A2_NOME, D1_LOJA, D1_DTDIGIT, D1_EMISSAO "
cQry+="			 ) AS SD1 ON D1_FILIAL = CT2_FILORI AND DOC = D1_DOC AND SERIE = D1_SERIE AND FORNECE = D1_FORNECE AND LOJA = D1_LOJA "
cQry+=" WHERE ROUND( ISNULL(CT2_VALOR  , 0 ), 2) <> ROUND(ISNULL(CUSTO      , 0 ) , 2) "	
cQry+=" ORDER BY D1_DTDIGIT "


//Compute Sum(QtdHr), Sum(Saldo)
MemoWrit("AAESTR17.sql",cQry)
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "TMP", .T., .F. )

TCSETFIELD("TMP","D1_DTDIGIT","D",8,0)

dbSelectArea("TMP")
TMP->(dbGoTop())
TMP->(dbEval({|| nTotREG++}))
TMP->(dbGoTop())
	
oReport:SetMeter(nTotREG)
	
While !TMP->(Eof())
	If oReport:Cancel()
		Exit
	EndIf		
	oReport:IncMeter()              

	oSection2:Init()	
	oSection2:Cell("FILIAL"):SetValue(TMP->FILIAL)
	oSection2:Cell("DOC"):SetValue(TMP->DOC)
	oSection2:Cell("SERIE"):SetValue(TMP->SERIE)
	oSection2:Cell("FORNECE"):SetValue(TMP->FORNECE)
	oSection2:Cell("NOME_FOR"):SetValue(TMP->NOME_FOR)
	oSection2:Cell("DIGITACAO"):SetValue(TMP->DIGITACAO)
	oSection2:Cell("EMISSAO"):SetValue(TMP->EMISSAO)
	oSection2:Cell("VALOR_CONTAB"):SetValue(TMP->VALOR_CONTAB)
	oSection2:Cell("TOTAL"):SetValue(TMP->TOTAL)
	oSection2:Cell("CUSTO"):SetValue(TMP->CUSTO)
	oSection2:Cell("DIF"):SetValue(TMP->DIF)
	
	                                      
	oSection2:Printline()   
	TMP->(DbSkip())  	                   
EndDo    
oSection2:Finish()
TMP->(dbCloseArea())

Return            

//Funcão Valida SX1
//*************************
Static Function fValidSX1()

	aPergs := {}

	Aadd(aPergs,{ "Data De               ?", "", "","mv_ch1", "D", 8, 0, 0, "G", "naovazio","mv_par01", ""			,"", "", "","" ,"", "","","","", "", "","","", "", "","","", "", "","",""})
	Aadd(aPergs,{ "Data Ate              ?", "", "","mv_ch2", "D", 8, 0, 0, "G", "naovazio","mv_par02", ""			,"", "", "","" ,"", "","","","", "", "","","", "", "","","", "", "","",""})
    
	AjustaSx1("AAESTR17",aPergs)
Return

Static Function AjustaSX1(cPerg, aPergs)
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local cKey		:= ""
Local nj		:= 1
Local aArea		:= GetArea()
Local lUpdHlp	:= .T.

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP", "X1_PICTURE"}

dbSelectArea( "SX1" )
dbSetOrder(1)

cPerg := PadR( cPerg , Len(X1_GRUPO) , " " )

For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek( cPerg + Right( Alltrim( aPergs[nX][11] ) , 2) )

		If ( ValType( aPergs[nX][Len( aPergs[nx] )]) = "B" .And. Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif

	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]		
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(ALLTRIM( aPergs[nX][11] ), 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0 .And. ValType(aPergs[nX][nJ]) != "A"
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
	Endif
	cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

	If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
		aHelpSpa := aPergs[nx][Len(aPergs[nx])]
	Else
		aHelpSpa := {}
	Endif
	
	If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
		aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
	Else
		aHelpEng := {}
	Endif

	If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
		aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
	Else
		aHelpPor := {}
	Endif

	// Caso exista um help com o mesmo nome, atualiza o registro.
	lUpdHlp := ( !Empty(aHelpSpa) .and. !Empty(aHelpEng) .and. !Empty(aHelpPor) )
	//PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa,lUpdHlp)
	
Next
RestArea(aArea)

Return()
