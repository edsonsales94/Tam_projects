
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exemplo de relatorio usando tReport com duas Section
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
user function AAFATR17()
	Local cPerg := PADR("AAFATR17",Len(SX1->X1_GRUPO))
	
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

local cTitle  := "Relação Notas Fiscais Canceladas"
local cHelp   := "Relação Notas Fiscais Canceladas"
Local aOrdem  := {"Nota Fiscal","Data do Cancelamento"}
local oReport
local oSection1
local oSection2
local oBreak1
Local nTotal	:= 0
oReport := TReport():New("AAFATR17", cTitle, cPerg , {|oReport| ReportPrint(oReport)},cTitle)
oReport:oPage:SetPaperSize(9)
oReport:SetPortrait(.T.)
oReport:SetTotalInLine(.F.)


//Segunda seção
oSection2:= TRSection():New(oReport,"Itens Nota Fiscal",{"TMP"},aOrdem)          
oSection2:AutoSize(.F.)
TRCell():New( oSection2, "F3_NFISCAL"   , "", RetTitle("F3_NFISCAL"		),PesqPict("SF3","F3_NFISCAL"	),15,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "F3_DTCANC"	, "", RetTitle("F3_DTCANC"		),PesqPict("SF3","F3_DTCANC"	),13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "A1_COD"   	, "", RetTitle("A1_COD"			),PesqPict("SA1","A1_COD"		),8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "A1_NOME"   	, "", RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "F3_OBSERV"   	, "", RetTitle("F3_OBSERV"		),PesqPict("SF3","F3_OBSERV"	),20,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "FT_ITEM"		, "", "Item"					 ,PesqPict("SFT","FT_ITEM"		),2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "FT_PRODUTO"	, "", "Produto"					 ,PesqPict("SFT","FT_PRODUTO"	),8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "B1_DESC"		, "", RetTitle("B1_DESC"		),PesqPict("SB1","B1_DESC"		),TamSx3("B1_DESC"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "FT_QUANT"		, "", RetTitle("FT_QUANT"		),PesqPict("SFT","FT_QUANT"		),TamSx3("FT_QUANT"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "FT_VALCONT"	, "", RetTitle("FT_VALCONT"		),PesqPict("SFT","FT_VALCONT"	),TamSx3("FT_VALCONT"	)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "E1_TIPO"		, "", RetTitle("E1_TIPO"		),PesqPict("SE1","E1_TIPO"		),TamSx3("E1_TIPO"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "E1_VEND1"		, "", RetTitle("E1_VEND1"		),PesqPict("SE1","E1_VEND1"		),TamSx3("E1_VEND1"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "A3_NOME"		, "", RetTitle("A3_NOME"		),PesqPict("SA3","A3_NOME"		),TamSx3("A3_NOME"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)
TRCell():New( oSection2, "E4_DESCRI"	, "", RetTitle("E4_DESCRI"	    ),PesqPict("SE4","E4_DESCRI"	),TamSx3("E4_DESCRI"	)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)

  
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
	cOrdem := "F3_NFISCAL"
Else
	cOrdem := "F3_DTCANC"		 
endif 

cQry+=" SELECT SF3.F3_NFISCAL, SF3.F3_SERIE, SA1.A1_COD,SA1.A1_NOME,SA1.A1_LOJA,SF3.F3_DTCANC,F3_OBSERV,FT_QUANT,FT_VALCONT,FT_ITEM,FT_PRODUTO,E1_TIPO,E1_VEND1,A3_NOME, E4_DESCRI FROM "+RetSQLName("SF3")+" SF3 "
cQry+=" INNER JOIN SA1010 SA1 "
cQry+=" ON SA1.D_E_L_E_T_='' "
cQry+=" AND SA1.A1_COD=SF3.F3_CLIEFOR "
cQry+=" AND SA1.A1_LOJA=SF3.F3_LOJA "
cQry+=" INNER JOIN "+RetSQLName("SFT")+" SFT "
cQry+=" ON SFT.D_E_L_E_T_='' "
cQry+=" AND SFT.FT_FILIAL=SF3.F3_FILIAL "
cQry+=" AND SFT.FT_NFISCAL=SF3.F3_NFISCAL "
cQry+=" AND SFT.FT_SERIE=SF3.F3_SERIE "
cQry+=" AND SFT.FT_CLIEFOR=SF3.F3_CLIEFOR "
cQry+=" AND SFT.FT_LOJA=SF3.F3_LOJA "
cQry+=" AND SFT.FT_ENTRADA=SF3.F3_ENTRADA "
cQry+=" LEFT OUTER JOIN "+RetSQLName("SE1")+" SE1 "
cQry+=" ON SE1.D_E_L_E_T_ = '*' "
cQry+=" AND E1_NUM = FT_NFISCAL "
cQry+=" AND E1_PREFIXO = FT_SERIE "
cQry+=" LEFT JOIN SA3010 SA3 "
cQry+=" ON SA3.D_E_L_E_T_ = '' "  
cQry+=" AND A3_COD = E1_VEND1 "
cQry+=" LEFT OUTER JOIN "+RetSQLName("SF2")+" SF2  "
cQry+=" ON SF2.D_E_L_E_T_ ='*' "
cQry+=" AND F2_DOC = F3_NFISCAL "
cQry+=" AND F2_SERIE = F3_SERIE "
cQry+=" LEFT OUTER JOIN "+RetSQLName("SE4")+" SE4 "
cQry+=" ON  SE4.D_E_L_E_T_= '' "
cQry+=" AND E4_CODIGO = F2_COND "
cQry+=" WHERE SF3.D_E_L_E_T_='' "
cQry+=" AND F3_ENTRADA>='"+DtoS(mv_par01)+"' "
cQry+=" AND F3_ENTRADA<='"+DtoS(mv_par02)+"' "
cQry+=" AND F3_DTCANC<>'' "
cQry+=" ORDER BY "+cOrdem+" "

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "TMP", .T., .F. )

TCSETFIELD("TMP","F3_DTCANC","D",8,0)

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
	oSection2:Cell("F3_NFISCAL"):SetValue(Alltrim(TMP->F3_NFISCAL)+"/"+Alltrim(TMP->F3_SERIE))
	oSection2:Cell("F3_DTCANC"):SetValue(TMP->F3_DTCANC)
	oSection2:Cell("A1_COD"):SetValue(Alltrim(TMP->A1_COD))
	oSection2:Cell("A1_NOME"):SetValue(Alltrim(TMP->A1_COD)+"-"+Alltrim(TMP->A1_NOME))
	oSection2:Cell("F3_OBSERV"):SetValue(Alltrim(TMP->F3_OBSERV))
	oSection2:Cell("FT_ITEM"):SetValue(Alltrim(TMP->FT_ITEM))
	oSection2:Cell("FT_PRODUTO"):SetValue(Alltrim(TMP->FT_PRODUTO))
	oSection2:Cell("B1_DESC"):SetValue(Alltrim(Posicione("SB1",1,xFilial("SB1")+TMP->FT_PRODUTO,"B1_DESC")))
	oSection2:Cell("FT_QUANT"):SetValue(TMP->FT_QUANT)
	oSection2:Cell("FT_VALCONT"):SetValue(TMP->FT_VALCONT)
	oSection2:Cell("E1_TIPO"):SetValue(TMP->E1_TIPO)
	oSection2:Cell("E1_VEND1"):SetValue(TMP->E1_VEND1)
	oSection2:Cell("A3_NOME"):SetValue(TMP->A3_NOME)
	oSection2:Cell("E4_DESCRI"):SetValue(TMP->E4_DESCRI)
	                                      
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
    
	AjustaSx1("AAFATR17",aPergs)
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
