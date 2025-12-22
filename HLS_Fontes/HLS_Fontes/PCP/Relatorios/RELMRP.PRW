#include "totvs.ch"
#include "topconn.ch"

//-----------------------------------------------------------
/*/{Protheus.doc} RelMRP
Relatório Sintético dos dados gerados pelo cálculo do MRP.

@author  Guilherme Ricci - TOTVS IP
@since   05/10/18
/*/
//-----------------------------------------------------------

User Function RelMRP

	Local cQuery := ""
	Local oReport
		
	Private aPeriodos := {}
	
	If !Pergunte('RELMRP',.T.)
		Return
	EndIf	
	
	aPeriodos := aClone(MontaDatas())
	
	Pergunte("RELMRP", .F.) // Redefine as variaveis MV_PAR
	
	//Interface de impressão
	oReport := ReportDef()
	oReport:PrintDialog()

Return
//------------------------------------------------------------
//  Definições do relatório
//------------------------------------------------------------
Static Function ReportDef()

	Local oReport, oSection1
	Local nX	:= 0
	
	oReport := TReport():New('RELMRP', "Relatório MRP Hondalock",'RELMRP',{|oReport| ReportPrint(oReport)},"Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario.")
	
	oReport:SetLandscape()
	
	oSection1 := TRSection():New(oReport,"Produtos",,,,,,,/*.T.*/,/*.T.*/,,,,,3,,,2)
	
	TRCell():New(oSection1,'Produto'		,,/*Titulo*/, PesqPict("SB1","B1_COD"), TamSX3("B1_COD")[1],/*lPixel*/,/*{|| code-block de impressao }*/,/*Alinhamento*/)
	
	For nX := 1 To Len(aPeriodos)
		TRCell():New(oSection1,'PER'+StrZero(nX,3),, DtoC(aPeriodos[nX]),/*Picture*/     ,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,/*Alinhamento*/)
	Next nX
	
Return(oReport)

//-----------------------------------------------------------
// Impressão do relatório
//-----------------------------------------------------------
Static Function ReportPrint(oReport)

	Local oSection1 	:= oReport:Section(1)
	Local cAliasProd	:= ""
	Local cCampo		:= ""
	Local aDados		:= {}
	Local nX			:= 0
	
	If MV_PAR09 == 1
		cCampo := "CZK_QTNECE"
	Elseif MV_PAR09 == 2
		cCampo := "CZK_QTSAID"
	Elseif MV_PAR09 == 3
		cCampo := "CZK_QTSEST"
	Elseif MV_PAR09 == 4
		cCampo := "CZK_QTENTR"
	Endif
	
	QryProd(@cAliasProd)
	
	If (cAliasProd)->(!Eof())
	
		oSection1:Init()
		
		While (cAliasProd)->(!Eof())
		
			aDados := {}
			aDados := RetCZK((cAliasProd)->CZJ_PROD, cCampo)
			
			oSection1:Cell("Produto"):SetValue(Alltrim((cAliasProd)->CZJ_PROD))
			For nX := 1 To Len(aDados)
				oSection1:Cell("PER" + aDados[nX,1]):SetValue( aDados[nX,2] )
			Next nX
			
			oSection1:PrintLine()
			
			(cAliasProd)->(dbSkip())
			
		EndDo
		
		oSection1:Finish()
	
	Endif

	(cAliasProd)->(dbCloseArea())

Return

Static Function MontaDatas()

Local i
Local dInicio
Local aRet := {}
Local nPosAno
Local nTamAno
Local cForAno
Local lConsSabDom := Nil

Pergunte("MTA712",.F.)
lConsSabDom := mv_par12 == 1

If __SetCentury()
	nPosAno := 1
	nTamAno := 4
	cForAno := "ddmmyyyy"
Else
	nPosAno := 3
	nTamAno := 2
	cForAno := "ddmmyy"
EndIf

dbSelectArea("CZI")
dbSetOrder(1)
DbSeek(xFilial("CZI"))

While !Eof() .And. xFilial("CZI") == CZI->CZI_FILIAL
	// Recupera parametrizacao gravada no ultimo processamento
	// A T E N C A O
	// Quando utilizado o processamento por periodos variaveis o sistema monta o array com
	// os periodos de maneira desordenada, por causa do indice do arquivo SH5
	// O array aRet é corrigido logo abaixo
	If CZI_ALIAS == "PAR"
		nTipo       := CZI_NRRGAL
		dInicio     := CZI_DTOG
		nPeriodos   := CZI_QUANT
		If nTipo == 7
			AADD(aRet,DTOS(CTOD(Alltrim(CZI_OPC))))
		EndIf
		//NUMERO DO MRP                                                ³
		c711NumMRP := CZI_NRMRP
	EndIf
	dbSkip()
End

//Somente para nTipo==7 (Periodos Diversos) re-ordena aRet
//pois como o H5_OPC esta gravado a data como caracter ex:(09/10/05)
//o arquivo esta indexado incorretamente (diferente de 20051009)
If !Empty(aRet)
	ASort(aRet)
	For i:=1 To Len(aRet)
		aRet[i] := STOD(aRet[i])
	Next i
EndIf

If (nTipo == 2)                         // Semanal
	While Dow(dInicio)!=2
		dInicio--
	EndDo
ElseIf (nTipo == 3) .or. (nTipo=4)      // Quinzenal ou Mensal
		dInicio:= CtoD("01/"+Substr(DtoS(dInicio),5,2)+Substr(DtoC(dInicio),6),cForAno)
ElseIf (nTipo == 5)                     // Trimestral
	If Month(dInicio) < 4
		dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7),cForAno)
	ElseIf (Month(dInicio) >= 4) .and. (Month(dInicio) < 7)
		dInicio := CtoD("01/04/"+Substr(DtoC(dInicio),7),cForAno)
	ElseIf (Month(dInicio) >= 7) .and. (Month(dInicio) < 10)
		dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7),cForAno)
	ElseIf (Month(dInicio) >=10)
		dInicio := CtoD("01/10/"+Substr(DtoC(dInicio),7),cForAno)
	EndIf
ElseIf (nTipo == 6)                     // Semestral
	If Month(dInicio) <= 6
		dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7),cForAno)
	Else
		dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7),cForAno)
	EndIf
EndIf

If nTipo != 7
	For i := 1 to nPeriodos
		AADD(aRet,dInicio)
		If nTipo == 1
			dInicio ++
			While !lConsSabDom .And. ( DOW(dInicio) == 1 .or. DOW(dInicio) == 7 )
				dInicio++
			EndDo
		ElseIf nTipo == 2
			dInicio+=7
		ElseIf nTipo == 3
			dInicio := StoD(If(Substr(DtoS(dInicio),7,2)<"15",Substr(DtoS(dInicio),1,6)+"15",;
	 		If(Month(dInicio)+1<=12,Str(Year(dInicio),4)+StrZero(Month(dInicio)+1,2)+"01",;
			Str(Year(dInicio)+1,4)+"0101")),cForAno)			
		ElseIf nTipo == 4
			dInicio := CtoD("01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+;
			"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		ElseIf nTipo == 5
			dInicio := CtoD("01/"+If(Month(dInicio)+3<=12,StrZero(Month(dInicio)+3,2)+;
			"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		ElseIf nTipo == 6
			dInicio := CtoD("01/"+If(Month(dInicio)+6<=12,StrZero(Month(dInicio)+6,2)+;
			"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		EndIf
	Next i
EndIf

Return aRet

Static Function QryProd(cNewAlias)
	
	Local cQuery	:= ""
	Local cProdDe	:= MV_PAR01
	Local cProdAte	:= MV_PAR02
	Local cFornDe	:= MV_PAR03
	Local cFornAte	:= MV_PAR04
	Local cTipoDe	:= MV_PAR05
	Local cTipoAte	:= MV_PAR06
	Local cGrupoDe	:= MV_PAR07
	Local cGrupoAte	:= MV_PAR08
	
	cNewAlias := "QRYPROD"
	
	cQuery := "SELECT CZJ_PROD"
	cQuery += " FROM "+ RetSqlName("CZJ")+ " CZJ"
	cQuery += " INNER JOIN "+ RetSqlName("SB1")+ " SB1 ON B1_FILIAL = '"+ FwXFilial("SB1")+"' AND SB1.D_E_L_E_T_=' ' AND B1_COD = CZJ_PROD"
	cQuery += " WHERE B1_COD >= '"+cProdDe+"'"
	cQuery += " AND B1_COD <= '"+cProdAte+"'"
	cQuery += " AND B1_PROC >= '"+cFornDe+"'"
	cQuery += " AND B1_PROC <= '"+cFornAte+"'"
	cQuery += " AND B1_TIPO >= '"+cTipoDe+"'"
	cQuery += " AND B1_TIPO <= '"+cTipoAte+"'"
	cQuery += " AND B1_GRUPO >= '"+cGrupoDe+"'"
	cQuery += " AND B1_GRUPO <= '"+cGrupoAte+"'"
	cQuery += " ORDER BY 1"
	
	If Select("QRYPROD") > 0
		QRYPROD->(dbCloseArea())
	Endif
	
	tcQuery cQuery New Alias &(cNewAlias)

Return cNewAlias

Static Function RetCZK(cProd, cCampo)

Local aRet := {}
Local cQuery := ""

If Select("WORK") > 0
	WORK->(dbCloseArea())
Endif

cQuery := "SELECT CZK_PERMRP, " + cCampo
cQuery += " FROM "+ RetSqlName("CZK")+" (NOLOCK) CZK"
cQuery += " INNER JOIN "+ RetSqlName("CZJ")+" (NOLOCK) CZJ ON CZK_RGCZJ = CZJ.R_E_C_N_O_"
cQuery += " WHERE CZK_FILIAL = '"+ FwXfilial("CZK")+"' "
cQuery += " AND CZJ_PROD = '"+ cProd +"'"
cQuery += " ORDER BY 1"

tcQuery cQuery New Alias "WORK"

TCSetField("WORK", cCampo, 'N', TamSX3(cCampo)[1], TamSX3(cCampo)[2])

While WORK->(!eof())
	aAdd(aRet, {WORK->CZK_PERMRP, cValToChar(WORK->&(cCampo))})
	WORK->(dbSkip())
EndDo

WORK->(DbCloseArea())

Return aRet

