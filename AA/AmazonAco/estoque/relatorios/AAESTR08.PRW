#INCLUDE "PROTHEUS.CH"

#Define STR_PULA    Chr(13)+Chr(10)


User Function AAESTR08()
 //Local aRet := {}
 Local aParamBox := {} 
 Local aTps := {"1-Somente OP","2-Todos Movimentos"}
 Local dDataDe  := FirstDate(Date())
 Local dDataAt  := LastDate(Date())
 Local cLocal1  := Space(TamSX3('D3_LOCAL')[01])
 Local cLocal2  := Space(TamSX3('D3_LOCAL')[01])
 Local cCFde    := Space(TamSX3('D3_CF')[01])
 Local cCFat    := Space(TamSX3('D3_CF')[01]) 
 Local cCCde    := Space(TamSX3('D3_CC')[01])
 Local cCCat    := Space(TamSX3('D3_CC')[01])
 Local cFilde   := Space(TamSX3('D3_FILIAL')[01])
 Local cFilat   := Space(TamSX3('D3_FILIAL')[01])
  
  aAdd(aParamBox,{1,"Data de    :",dDataDe ,""  ,".T.",""   ,".T.",80,.T.})
  aAdd(aParamBox,{1,"Data Ate   :",dDataAt ,""  ,".T.",""   ,".T.",80,.T.})  
  aAdd(aParamBox,{1,"Local de   :",cLocal1 ,""  ,".T.","NRR",".T.",80,.F.})
  aAdd(aParamBox,{1,"Local Ate  :",cLocal2 ,""  ,".T.","NRR",".T.",80,.T.})  
  
  aAdd(aParamBox,{2,"Tipo       :",1,aTps,80,,.T.}) // Tipo caractere   

  aAdd(aParamBox,{1,"CF de      :",cCFde   ,""  ,".T.",""   ,".T.",80,.F.})
  aAdd(aParamBox,{1,"CF Ate     :",cCFat   ,""  ,".T.",""   ,".T.",80,.T.})  
  aAdd(aParamBox,{1,"CC de      :",cCCde   ,""  ,".T.","CTT",".T.",80,.F.})
  aAdd(aParamBox,{1,"CC Ate     :",cCCat   ,""  ,".T.","CTT",".T.",80,.T.})  
  aAdd(aParamBox,{1,"Filial de  :",cFilde  ,""  ,".T.","",".T.",80,.F.})
  aAdd(aParamBox,{1,"Filial Ate :",cFilat  ,""  ,".T.","",".T.",80,.T.})  

	If ParamBox(aParamBox,"Relatorio de Movimentos SD3") 
		Processa({|| fImps() },"Imprimindo")
	EndIf
Return .T.


Static Function fImps()

Local cPerg    := 'AAESTR08'
Local oExcel   := Nil
Local cxTabs   := 'PROD'
Local cQuery   := ''
LOCAL cArquivo := cPerg+".XLS"
//Pergunte(cPerg, .T.)

//Pegando os dados

cQuery := "SELECT D3_FILIAL  , D3_TM      , D3_COD     , B1_DESC    , D3_XHORA   , CASE WHEN D3_XHORA BETWEEN '07:31:00' AND '22:59:59' THEN 'COMERCIAL' WHEN D3_XHORA = '' THEN ''  ELSE 'TERCEIRO TURNO'END As TURNO, "  + STR_PULA
cQuery += "	D3_QUANT   , D3_UM      , D3_CF      , D3_LOCAL   , D3_EMISSAO , D3_LOCALIZ , D3_DOC     , D3_OP      , D3_TIPO    , D3_ESTORNO , D3_GRUPO   , D3_NUMSEQ  ,"  + STR_PULA
cQuery += " D3_USUARIO , D3_LOTECTL , C2_RECURSO , B2_CM1     , ISNULL(D3_CUSTO1,0) AS B9_CM1,  ISNULL(D3_EMISSAO,'') AS B9_DATA, D3_CONTA, D3_CC, D3_XINTEGR"  + STR_PULA
cQuery += " FROM " + RetSqlName("SD3") + " SD3 (NOLOCK) "  + STR_PULA

If MV_PAR05  == "1-Somente OP"
    cQuery += " LEFT OUTER  JOIN " + RetSQLName("SC2") + " (NOLOCK) SC2  ON SC2.D_E_L_E_T_=' ' AND D3_FILIAL = C2_FILIAL AND C2_NUM = LEFT(D3_OP, 6) AND C2_ITEM = SUBSTRING(D3_OP, 7,2) AND C2_SEQUEN = SUBSTRING(D3_OP, 9,3) "   + STR_PULA
Else
    cQuery += " INNER JOIN " + RetSQLName("SC2") + "  (NOLOCK) SC2   ON SC2.D_E_L_E_T_=' ' AND D3_FILIAL = C2_FILIAL AND C2_NUM = LEFT(D3_OP, 6) AND C2_ITEM = SUBSTRING(D3_OP, 7,2) AND C2_SEQUEN = SUBSTRING(D3_OP, 9,3) "  + STR_PULA
EndIf 

cQuery += " INNER JOIN " + RetSQLName("SB1") + "      (NOLOCK) SB1 ON SB1.D_E_L_E_T_='' AND B1_COD = D3_COD"  + STR_PULA
cQuery += " INNER JOIN " + RetSQLName("SB2") + "      (NOLOCK) SB2 ON SB2.D_E_L_E_T_='' AND B2_FILIAL = D3_FILIAL AND B2_COD = D3_COD AND B2_LOCAL = D3_LOCAL"  + STR_PULA
cQuery += " WHERE  D3_FILIAL BETWEEN   '" + MV_PAR10 + "' AND '" + MV_PAR11 + "'"  + STR_PULA
cQuery += " AND LEFT(D3_COD, 3) <> 'MOD' "  + STR_PULA             
cQuery += " AND D3_LOCAL BETWEEN    '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"  + STR_PULA
cQuery += " AND D3_EMISSAO BETWEEN  '" + dtos(MV_PAR01) + "' AND '" + dtos(MV_PAR02) + "'"  + STR_PULA
cQuery += " AND D3_CF BETWEEN  '" + (MV_PAR06) + "' AND '" + (MV_PAR07) + "'"  + STR_PULA
cQuery += " AND SD3.D_E_L_E_T_ = '' "  + STR_PULA 

xdTb2  := MpSysOpenQUery(cQuery)
DbSelectArea(xdTb2)

oExcel := FwMsExcelXlsx():New()

oExcel:AddworkSheet(cxTabs)
oExcel:AddTable(cxTabs,"Movimentos")
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_FILIAL")  ,1 , 1)   //1
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_TM")      ,1 , 1)   //2
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_COD")     ,1 , 1)   //3
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("B1_DESC")    ,1 , 1)   //4
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_XHORA")   ,1 , 1)   //5
oExcel:AddColumn(cxTabs,"Movimentos", "TURNO"                ,1 , 1)   //6
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_QUANT")   ,2 , 2)   //7
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_UM")      ,1 , 1)   //8
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_CF")      ,1 , 1)   //9
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_LOCAL")   ,1 , 1)   //10
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_LOCALIZ") ,1 , 1)   //11
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_EMISSAO") ,2 , 4)   //12
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_DOC")     ,1 , 1)   //13
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_OP")      ,1 , 1)   //14
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_TIPO")    ,1 , 1)   //15
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_ESTORNO") ,1 , 1)   //16
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_GRUPO")   ,1 , 1)   //17
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_NUMSEQ")  ,1 , 1)   //18
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_USUARIO") ,1 , 1)   //19
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_LOTECTL") ,1 , 1)   //20
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("C2_RECURSO") ,1 , 1)   //21
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("B2_CM1")     ,1 , 1)   //22
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("B9_CM1")     ,1 , 1)   //23
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("B9_DATA")    ,2 , 4)   //24
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_CC")      ,1 , 1)   //25
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_CONTA")   ,1 , 1)   //26
oExcel:AddColumn(cxTabs,"Movimentos", RetTitle("D3_XINTEGR") ,1 , 1)   //26



While !(xdTb2)->(EoF())
		oExcel:AddRow(cxTabs,"Movimentos",{;
			 (xdTb2)->D3_FILIAL,;	
			 (xdTb2)->D3_TM,;	
			 (xdTb2)->D3_COD,;	
			 (xdTb2)->B1_DESC,;	
			 (xdTb2)->D3_XHORA,;
			 (xdTb2)->TURNO,;
			 (xdTb2)->D3_QUANT,;
			 (xdTb2)->D3_UM,;	
			 (xdTb2)->D3_CF,;	
			 (xdTb2)->D3_LOCAL,;	
			 (xdTb2)->D3_LOCALIZ,;	
			 (xdTb2)->D3_EMISSAO,;
			 (xdTb2)->D3_DOC,;	
			 (xdTb2)->D3_OP,;
             (xdTb2)->D3_TIPO,;
             (xdTb2)->D3_ESTORNO,;
             (xdTb2)->D3_GRUPO,;
             (xdTb2)->D3_NUMSEQ,;
             (xdTb2)->D3_USUARIO,;
			 (xdTb2)->D3_LOTECTL,;
		     (xdTb2)->C2_RECURSO,;
			 (xdTb2)->B2_CM1,;
			 (xdTb2)->B9_CM1,;
			 DTOC(STOD((xdTb2)->B9_DATA)),;
			 (xdTb2)->D3_CC,;
			 (xdTb2)->D3_CONTA,;
			 (xdTb2)->D3_XINTEGR})
	 
		//Pulando Registro
		(xdTb2)->(DbSkip())
EndDo

oExcel:Activate()

oExcel:GetXMLFile(cArquivo)

oExcel:DeActivate()

iF ! EXISTDIR("C:\TEMP\")

	nRet := MakeDir( "C:\TEMP\" )
	 
ENDIF

CpyS2T("\SYSTEM\"+cArquivo, "C:\TEMP\")
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open("C:\TEMP\"+cArquivo) // Abre a planilha
oExcelApp:SetVisible(.T.)


Return
