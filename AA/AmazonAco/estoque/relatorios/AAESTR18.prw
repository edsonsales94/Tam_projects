
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exemplo de relatorio usando tReport com duas Section
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
user function AAESTR18()
	Local cPerg := PADR("AAESTR18",Len(SX1->X1_GRUPO))
	
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

local cTitle  := "Saldos CC X Contas"
local cHelp   := "Saldos CC X Contas"
Local aOrdem  := {"Saldos CC X Contas"}
local oReport
local oSection1
local oSection2
local oBreak1
Local nTotal	:= 0
oReport := TReport():New("AAESTR18", cTitle, cPerg , {|oReport| ReportPrint(oReport)},cTitle)
oReport:oPage:SetPaperSize(9)
oReport:SetPortrait(.T.)
oReport:SetTotalInLine(.F.)


//Segunda seção
oSection2:= TRSection():New(oReport,"Saldos CC X Contas",{"TMP"},aOrdem)          
oSection2:AutoSize(.F.)
TRCell():New( oSection2, "Conta"            , "", "Conta"              	   	 ,"@!"                	                                       ,12,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "CT1_DESC01"   	, "", RetTitle("CT1_DESC01"		),PesqPict("CT1","CT1_DESC01"	),TamSx3("CT1_DESC01"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "CC"               , "", "CC"              	     ,"@!"                	                                       ,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "CTT_DESC01"   	, "", RetTitle("CTT_DESC01"		),PesqPict("CTT","CTT_DESC01"	),TamSx3("CTT_DESC01"		)[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.F.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
TRCell():New( oSection2, "Saldo"         	, "", "Saldo"		             ,"@E 9,999,999,999.99"        ,17,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.F.)  
  


  
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
	cOrdem := "CT1_DESC01"
Else
	cOrdem := "CT1_DESC01"		 
endif 

cQry+=" Select ISNULL(Conta, '') Conta, CT1_DESC01, ISNULL(CC, '') CC, CTT_DESC01, IsNull(Saldo, 0) Saldo "
cQry+=" From " 
cQry+=" (	Select IsNull(CT2_DEBITO, CT2_CREDIT) Conta, IsNull(CT2_CCD, CT2_CCC) CC, IsNull(Deb, 0) - IsNull(Cre, 0) As Saldo "
cQry+="	From " 
cQry+="	(	Select CT2_DEBITO, CT2_CCD, Cast(SUM(CT2_VALOR) As Decimal(12,2)) Deb "
cQry+="		From CT2010 as CT2 (NOLOCK) "
cQry+="		Where D_E_L_E_T_ = '' AND CT2_DC IN ('1', '3') AND CT2_TPSALD = '1' "
cQry+="		And CT2_DATA >='"+DtoS(mv_par01)+"' "
cQry+="		And CT2_DATA <='"+DtoS(mv_par02)+"' " 
cQry+="		Group by CT2_DEBITO, CT2_CCD "
cQry+="	) Deb "
cQry+="	Full Join "
cQry+="	(	Select CT2_CREDIT, CT2_CCC, Cast(SUM(CT2_VALOR) As Decimal(12,2)) Cre "
cQry+="		From CT2010 AS CT2 (NOLOCK) "
cQry+="		Where D_E_L_E_T_ = '' AND CT2_DC IN ('2', '3') AND CT2_TPSALD = '1' "
cQry+="		And CT2_DATA >='"+DtoS(mv_par01)+"' "
cQry+="		And CT2_DATA <='"+DtoS(mv_par02)+"' "
cQry+="		Group by CT2_CREDIT, CT2_CCC "
cQry+="	) Cre "
cQry+="	On CT2_DEBITO = CT2_CREDIT "
cQry+="	And CT2_CCD = CT2_CCC "
cQry+=" ) CC "
cQry+=" Left Join "
cQry+=" (Select CT1_CONTA, CT1_DESC01 "
cQry+="	From CT1010 "
cQry+="	Where D_E_L_E_T_ = '' "
cQry+=" ) CT1 "
cQry+=" On ISNULL(Conta, '') = CT1_CONTA "
cQry+=" Left Join "
cQry+=" (Select CTT_CUSTO, CTT_DESC01 "
cQry+="	From CTT010 "
cQry+="	Where D_E_L_E_T_ = '' "
cQry+=" ) CTT "
cQry+=" On ISNULL(CC, '') = CTT_CUSTO "
//cQry+=" --Where CTT_CUSTO Like '211  ' "
cQry+=" Order by CC, CT1_DESC01, Conta, CTT_DESC01, Saldo "

//Compute Sum(QtdHr), Sum(Saldo)
MemoWrit("AAESTR18.sql",cQry)
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "TMP", .T., .F. )

TCSETFIELD("TMP","CT1_DESC01","D",8,0)

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
	oSection2:Cell("Conta"):SetValue(TMP->Conta)
	oSection2:Cell("CT1_DESC01"):SetValue(TMP->CT1_DESC01)
	oSection2:Cell("CC"):SetValue(TMP->CC)
	oSection2:Cell("CTT_DESC01"):SetValue(TMP->CTT_DESC01)
	oSection2:Cell("Saldo"):SetValue(TMP->Saldo)
	
	                                      
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
    
	AjustaSx1("AAESTR18",aPergs)
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
