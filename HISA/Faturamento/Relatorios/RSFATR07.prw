#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦RSFATR07    ¦ Autor ¦ ORISMAR SILVA        ¦ Data ¦ 07/03/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatorio de Rastreamento do Numero de Lote Valorizado.       ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
-¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function RSFATR07()
	Local cPerg := "RSFATR07"
	
	Private oReport, oSection1
	//Private nTotQtd   := 0
	//Private nTotCust  := 0
	//Private ntotCusto := 0
	//Private _nPag     := 01
	
	oReport := ReportDef(cPerg)
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	oReport:PrintDialog()

Return

//=================================================================================
// relatorio de producao - formato personalizavel
//=================================================================================
Static Function ReportDef(cPerg)
	Local cTitulo := 'Rastreamento de Lotes'
	
	CriaSx1(cPerg)
	Pergunte(cPerg,.F.)
	
	oReport := TReport():New("RSFATR07", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório de Rastreamento dos Lotes")
	
	oReport:SetLandScape()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()
	
	oSection1 := TRSection():New(oReport,"Rastreamento de Lotes.",{""})
	oSection1:SetTotalInLine(.F.)                                    
	
	TRCell():New(oSection1, "C_LOTE"      , "", "LOTE"              ,"@!",10,,,,,"LEFT")
	TRCell():New(oSection1, "C_CLIENTE"   , "", "CLIENTE"           ,"@!",50,,,,,"LEFT")
	TRCell():New(oSection1, "C_CGC"       , "", "CNPJ"              ,    ,30,,,,,"LEFT")
	TRCell():New(oSection1, "C_EST"	      , "", "UF"                ,"@!",05,,,,,"LEFT")
	TRCell():New(oSection1, "C_MUN"	      , "", "MUNICIPIO"         ,"@!",40,,,,,"LEFT")
	TRCell():New(oSection1, "C_FILIAL"    , "", "FIL"               ,"@!",05,,,,,"LEFT")
	TRCell():New(oSection1, "C_DOC"	      , "", "NOTA"              ,    ,15,,,,,"LEFT")
	TRCell():new(oSection1, "C_SERIE"     , "", "SERIE"             ,    ,10,,,,,"LEFT")
	TRCell():new(oSection1, "C_DTEMIS"    , "", "EMISSÃO"           ,    ,15,,,,,"CENTER")
	TRCell():New(oSection1, "C_COD"	      , "", "PRODUTO"           ,    ,15,,,,,"LEFT")
	TRCell():new(oSection1, "C_DESC"      , "", "DESCRIÇÃO"         ,    ,60,,,,,"LEFT")
	TRCell():new(oSection1, "C_QTD"       , "", "QUANTIDADE"        ,"@EZ 999,999.999"   ,15,,,,,"RIGHT")
	TRCell():new(oSection1, "C_VLR"       , "", "VALOR"             ,"@EZ 999,999,999.99",15,,,,,"RIGHT")
	TRCell():new(oSection1, "C_ICMS"      , "", "ICMS"              ,"@EZ 999,999.99"    ,15,,,,,"RIGHT")
	TRCell():new(oSection1, "C_DATFAB"    , "", "FABRICAÇÃO"        ,    ,15,,,,,"CENTER")
	TRCell():new(oSection1, "C_DATVAL"    , "", "VALIDADE"          ,    ,15,,,,,"CENTER")
	
Return oReport

//=================================================================================
// definicao para impressao do relatorio personalizado
//=================================================================================
Static Function PrintReport(oReport)
	Local nTotNF    := 0
	Local nTotgNF   := 0
	Local nTotQtd   := 0
	Local nTotVlr   := 0
	Local nTotIcms  := 0
	Local nTotgQtd  := 0
	Local nTotgVlr  := 0
	Local nTotgIcms := 0
	Local cCFOPs    := ""
	
	mv_par09 := AjustaCFOP("01",mv_par09,@cCFOPs)
	mv_par10 := AjustaCFOP("02",mv_par10,@cCFOPs)
	mv_par11 := AjustaCFOP("04",mv_par11,@cCFOPs)
	
	oSection1 := oReport:Section(1)
	
	oSection1:Init()
	oSection1:SetHeaderSection(.T.)
	
	cQuery := " SELECT DISTINCT SD2.D2_FILIAL, SC6.C6_LOTE1, SD2.D2_CLIENTE, SD2.D2_LOJA, SA1.A1_NOME, SA1.A1_EST, SA1.A1_MUN, SA1.A1_CGC, SD2.D2_DOC, SD2.D2_SERIE,"
	cQuery += " SD2.D2_COD, SD2.D2_EMISSAO, SD2.D2_QUANT, SD2.D2_TOTAL, SD2.D2_VALBRUT, SD2.D2_VALICM, SC6.C6_FABRIC, SC6.C6_LTVALID"
	cQuery += " FROM "+RetSQLName("SD2")+" SD2"
	cQuery += " INNER JOIN "+RetSQLName("SC6")+" SC6 ON SC6.D_E_L_E_T_ = ' '"
	cQuery += " AND SC6.C6_FILIAL = SD2.D2_FILIAL"
	cQuery += " AND SC6.C6_NUM = SD2.D2_PEDIDO"
	cQuery += " AND SC6.C6_ITEM = SD2.D2_ITEMPV" 
	cQuery += " AND SC6.C6_CLI = SD2.D2_CLIENTE"
	cQuery += " AND SC6.C6_LOJA = SD2.D2_LOJA"
	cQuery += " AND SC6.C6_LOTE1 = SD2.D2_LOTECTL"
	cQuery += " AND SC6.C6_LOTE1 <> ' '" 
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" SA1 ON SA1.D_E_L_E_T_ = ' '"
	cQuery += " AND SA1.A1_FILIAL = '"+SA1->(XFILIAL("SA1"))+"'"
	cQuery += " AND SA1.A1_COD = SD2.D2_CLIENTE"
	cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA"
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '"
	cQuery += " AND SD2.D2_FILIAL BETWEEN '"+mv_par14+"' AND '"+mv_par15+"'"
	cQuery += " AND SD2.D2_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cQuery += " AND SD2.D2_DOC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cQuery += " AND SD2.D2_COD BETWEEN '"+mv_par12+"' AND '"+mv_par13+"'"
	cQuery += " AND SD2.D2_EMISSAO BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"'"
	cQuery += " AND SD2.D2_FILIAL+SD2.D2_CF IN "+ FormatIn(  cCFOPs, ",")
	cQuery += " ORDER BY SC6.C6_LOTE1, SD2.D2_COD, SD2.D2_EMISSAO, SD2.D2_CLIENTE, SD2.D2_LOJA"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TBP",.T.,.F.)
	
	If	!USED()
		MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
	EndIf
	
	TCSetField("TBP","D2_EMISSAO","D",8,0)
	TCSetField("TBP","C6_FABRIC" ,"D",8,0)
	TCSetField("TBP","C6_LTVALID","D",8,0)
	
	TBP->(DbGoTop())
	oReport:SetMeter(TBP->(RecCount()))
	
	While !TBP->( Eof() )
		
		cLote    := TBP->C6_LOTE1
		cProduto := TBP->D2_COD
		
		If oReport:Cancel()
			Exit
		EndIf
		
		oReport:IncMeter()
		
		/*oSection1:Cell("C_CLIENTE" ):SetValue("LOTE : "+RTRIM(TBP->C6_LOTE1))
		oSection1:Cell("C_CGC"):SetValue("")
		oSection1:Cell("C_EST"):SetValue("")
		oSection1:Cell("C_MUN"):SetValue("")
		oSection1:Cell("C_DOC"):SetValue("")
		oSection1:Cell("C_SERIE"):SetValue("")
		oSection1:Cell("C_DTEMIS"):SetValue("")
		oSection1:Cell("C_COD"):SetValue("")
		oSection1:Cell("C_DESC"):SetValue("")
		oSection1:Cell("C_QTD"):SetValue("")
		oSection1:Cell("C_VLR"):SetValue("")
		oSection1:Cell("C_ICMS"):SetValue("")
		oSection1:Cell("C_DATFAB"):SetValue("")
		oSection1:Cell("C_DATVAL"):SetValue("")
		oReport:SkipLine()
		oSection1:PrintLine()*/
		
		While !TBP->( Eof() ) .and. cLote = TBP->C6_LOTE1 .and. cProduto = TBP->D2_COD
			
			If oReport:Cancel()
				Exit
			EndIf
			
			oReport:IncMeter()
			
			oSection1:Cell("C_LOTE"):SetValue(TBP->C6_LOTE1)
			oSection1:Cell("C_CLIENTE"):SetValue(TBP->D2_CLIENTE+"-"+TBP->D2_LOJA+" "+ALLTRIM(TBP->A1_NOME))
			oSection1:Cell("C_CGC"):SetValue(TRANSFORM(TBP->A1_CGC,"@R 99.999.999/9999-99"))
			oSection1:Cell("C_EST"):SetValue(TBP->A1_EST)
			oSection1:Cell("C_MUN"):SetValue(TBP->A1_MUN)
			oSection1:Cell("C_FILIAL"):SetValue(TBP->D2_FILIAL)
			oSection1:Cell("C_DOC"):SetValue(TBP->D2_DOC)
			oSection1:Cell("C_SERIE"):SetValue(TBP->D2_SERIE)
			oSection1:Cell("C_DTEMIS"):SetValue(DtoC(TBP->D2_EMISSAO))
			oSection1:Cell("C_COD"):SetValue(TBP->D2_COD)
			oSection1:Cell("C_DESC"):SetValue(Posicione("SB1",1,XFILIAL("SB1")+TBP->D2_COD,"B1_DESC"))
			oSection1:Cell("C_QTD"):SetValue(TBP->D2_QUANT)
			oSection1:Cell("C_VLR"):SetValue(TBP->D2_VALBRUT)
			oSection1:Cell("C_ICMS"):SetValue(TBP->D2_VALICM)
			oSection1:Cell("C_DATFAB"):SetValue(DtoC(TBP->C6_FABRIC))
			oSection1:Cell("C_DATVAL"):SetValue(DtoC(TBP->C6_LTVALID))
			oReport:SkipLine()
			oSection1:PrintLine()
			nTotNF++
			nTotgNF++
			nTotQtd   += TBP->D2_QUANT
			nTotVlr   += TBP->D2_VALBRUT
			nTotIcms  += TBP->D2_VALICM
			nTotgQtd  += TBP->D2_QUANT
			nTotgVlr  += TBP->D2_VALBRUT
			nTotgIcms += TBP->D2_VALICM
			
			TBP->(dbSkip())
		enddo
		oReport:IncMeter()
		oSection1:Cell("C_LOTE"):SetValue("")
		oSection1:Cell("C_CLIENTE"):SetValue("TOTAL DE NOTAS")
		oSection1:Cell("C_CGC"):SetValue("")
		oSection1:Cell("C_EST"):SetValue("")
		oSection1:Cell("C_MUN"):SetValue("")
		oSection1:Cell("C_FILIAL"):SetValue("")
		oSection1:Cell("C_DOC"):SetValue(nTotNF)
		oSection1:Cell("C_SERIE"):SetValue("")
		oSection1:Cell("C_DTEMIS"):SetValue("")
		oSection1:Cell("C_COD"):SetValue("")          
		oSection1:Cell("C_DESC"):SetValue("TOTAL QUANTIDADE")
		oSection1:Cell("C_QTD"):SetValue(nTotQtd)
		oSection1:Cell("C_VLR"):SetValue(nTotVlr)
		oSection1:Cell("C_ICMS"):SetValue(nTotIcms)
		oSection1:Cell("C_DATFAB"):SetValue("")
		oSection1:Cell("C_DATVAL"):SetValue("")
		
		oReport:SkipLine()
		oSection1:PrintLine()
		nTotBruto := 0
		nTotCubag := 0
		nTotQtd   := 0
		nTotVlr   := 0
		nTotIcms  := 0
		nTotNF    := 0
		oReport:IncMeter()
		oSection1:Cell("C_LOTE"):SetValue("")
		oSection1:Cell("C_CLIENTE"):SetValue("")
		oSection1:Cell("C_CGC"):SetValue("")
		oSection1:Cell("C_EST"):SetValue("")
		oSection1:Cell("C_MUN"):SetValue("")
		oSection1:Cell("C_FILIAL"):SetValue("")
		oSection1:Cell("C_DOC"):SetValue("")
		oSection1:Cell("C_SERIE"):SetValue("")
		oSection1:Cell("C_DTEMIS"):SetValue("")
		oSection1:Cell("C_COD"):SetValue("")
		oSection1:Cell("C_DESC"):SetValue("")
		oSection1:Cell("C_QTD"):SetValue(0)
		oSection1:Cell("C_VLR"):SetValue(0)
		oSection1:Cell("C_ICMS"):SetValue(0)
		oSection1:Cell("C_DATFAB"):SetValue("")
		oSection1:Cell("C_DATVAL"):SetValue("")
		oReport:SkipLine()
		oSection1:PrintLine()
	Enddo
	oReport:IncMeter()
	oSection1:Cell("C_LOTE"):SetValue("")
	oSection1:Cell("C_CLIENTE"):SetValue("TOTAL GERAL :")
	oSection1:Cell("C_CGC"):SetValue("")
	oSection1:Cell("C_EST"):SetValue("")
	oSection1:Cell("C_MUN"):SetValue("")
	oSection1:Cell("C_FILIAL"):SetValue("")
	oSection1:Cell("C_DOC"):SetValue(nTotgNF)
	oSection1:Cell("C_SERIE"):SetValue("")
	oSection1:Cell("C_DTEMIS"):SetValue("")
	oSection1:Cell("C_COD"):SetValue("")
	oSection1:Cell("C_DESC"):SetValue("")
	oSection1:Cell("C_QTD"):SetValue(nTotgQtd)
	oSection1:Cell("C_VLR"):SetValue(nTotgVlr)
	oSection1:Cell("C_ICMS"):SetValue(nTotgIcms)
	oSection1:Cell("C_DATFAB"):SetValue("")
	oSection1:Cell("C_DATVAL"):SetValue("")
	oReport:SkipLine()
	oSection1:PrintLine()
	
	dbCloseArea()
	oSection1:Finish()

Return

Static Function AjustaCFOP(cFilAtu,cParam,cAcumula)
	Local nX
	Local cFilAux := cFilAnt
	Local cCFOP   := ""
	Local aCFOP   := Separa( AllTrim(cParam) , "," , .F. )
	
	cFilAnt := cFilAtu
	
	For nX:=1 To Len(aCFOP)
		cCFOP += If(nX>1,",","") + SD2->(XFILIAL("SD2")) + aCFOP[nX]
	Next

	cFilAnt := cFilAux
	
	If !Empty(cCFOP)
		cAcumula += If(Empty(cAcumula),"",",") + cCFOP
	Endif

Return cCFOP

//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1(cPerg)
	Local nTam := TamSX3("D2_FILIAL")[1]

	u_HMPutSX1(cPerg, "01", PADR("Do Lote ",29)+"?"              ,"","", "mv_ch1" , "C", 21 , 0, 0, "G", "",   "", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Lote ",29)+"?"             ,"","", "mv_ch2" , "C", 21 , 0, 0, "G", "",   "", "", "", "mv_par02")
	u_HMPutSX1(cPerg, "03", PADR("Da NF ",29)+"?"                ,"","", "mv_ch3" , "C", 9  , 0, 0, "G", "",   "", "", "", "mv_par03")
	u_HMPutSX1(cPerg, "04", PADR("Ate NF ",29)+"?"               ,"","", "mv_ch4" , "C", 9  , 0, 0, "G", "",   "", "", "", "mv_par04")
	u_HMPutSX1(cPerg, "05", PADR("Do Cliente ",29)+"?"           ,"","", "mv_ch5" , "C", 6  , 0, 0, "G", "","SA1", "", "", "mv_par05")
	u_HMPutSX1(cPerg, "06", PADR("Ate Cliente ",29)+"?"          ,"","", "mv_ch6" , "C", 6  , 0, 0, "G", "","SA1", "", "", "mv_par06")
	u_HMPutSX1(cPerg, "07", PADR("Da Data ",29)+"?"              ,"","", "mv_ch7" , "D", 8  , 0, 0, "G", "",   "", "", "", "mv_par07")
	u_HMPutSX1(cPerg, "08", PADR("Ate Data ",29)+"?"             ,"","", "mv_ch8" , "D", 8  , 0, 0, "G", "",   "", "", "", "mv_par08")
	u_HMPutSX1(cPerg, "09", PADR("Cfop Fil 01",29)+"?"           ,"","", "mv_ch9" , "C", 20 , 0, 0, "G", "",   "", "", "", "mv_par09")
	u_HMPutSX1(cPerg, "10", PADR("Cfop Fil 02",29)+"?"           ,"","", "mv_chA" , "C", 20 , 0, 0, "G", "",   "", "", "", "mv_par10")
	u_HMPutSX1(cPerg, "11", PADR("Cfop Fil 04",29)+"?"           ,"","", "mv_chB" , "C", 20 , 0, 0, "G", "",   "", "", "", "mv_par11")
    u_HMPutSX1(cPerg, "12", PADR("Do Produto ",29)+"?"           ,"","", "mv_chC" , "C", 9  , 0, 0, "G", "","SB1", "", "", "mv_par12")
	u_HMPutSX1(cPerg, "13", PADR("Ate Produto ",29)+"?"          ,"","", "mv_chD" , "C", 9  , 0, 0, "G", "","SB1", "", "", "mv_par13")
    u_HMPutSX1(cPerg, "14", PADR("Da Filial ",29)+"?"            ,"","", "mv_chE" , "C",nTam, 0, 0, "G", "","   ", "", "", "mv_par14")
	u_HMPutSX1(cPerg, "15", PADR("Ate a Filial ",29)+"?"         ,"","", "mv_chF" , "C",nTam, 0, 0, "G", "","   ", "", "", "mv_par15")

Return Nil
