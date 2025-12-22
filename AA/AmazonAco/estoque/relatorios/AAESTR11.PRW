#include "rwmake.ch"
#include "protheus.ch"
#define DMPAPER_A4 9
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ Fun??o    ¶ AAESTR11   ¶ Autor ¶ WILLIAMS MESSA       ¶ Data ¶ 14/11/2019 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ Descri??o ¶ AAESTR11 - Relat?rio de Apontamento por Recurso               ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
???????????????????????????????????????????????????????????????????????????????*/ 
User Function AAESTR11()

    local oReport
	local cPerg := PadR('AAESTR11',10)

	criaSx1(cPerg)
	Pergunte(cPerg, .T.)
 
	oReport := reportDef()
	oReport:printDialog()
Return
 
static function reportDef()
	local oReport
	Local oSection1
	local cTitulo := 'AAESTR11 - Relatório de Apontamento por Recurso'
 
	oReport := TReport():New('AAESTR11', cTitulo, , {|oReport| PrintReport(oReport)},"Relat?rio de Apontamento por Recurso - Especifico Amazon Aço")
	//oReport:SetPortrait()
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()
 
	oSection1 := TRSection():New(oReport,"Filial",{"QRY"})
	oSection1:SetTotalInLine(.F.)
    
    TRCell():New(oSection1,"D3_FILIAL"  , "QRY", RetTitle("D3_FILIAL")  ,PesqPict("SD3","D3_FILIAL")  ,TamSX3("D3_FILIAL")[1])
    TRCell():New(oSection1,"CB0_CODETI" , "QRY", RetTitle("CB0_CODETI") ,PesqPict("CB0","CB0_CODETI") ,TamSX3("CB0_CODETI")[1])
    TRCell():New(oSection1,"D3_EMISSAO" , "QRY", RetTitle("D3_EMISSAO") ,PesqPict("SD3","D3_EMISSAO") ,TamSX3("D3_EMISSAO")[1])
    //TRCell():New(oSection1,"D3_USUARIO" , "QRY", RetTitle("D3_USUARIO") ,PesqPict("SD3","D3_USUARIO") ,TamSX3("D3_USUARIO")[1])
    TRCell():New(oSection1,"D3_NOMEUSER", "QRY", "NOME"	                ,"@!"                         ,40                     )
	TRCell():New(oSection1,"D3_OP"      , "QRY", RetTitle("D3_OP")      ,PesqPict("SD3","D3_OP")      ,TamSX3("D3_OP")[1])
    TRCell():New(oSection1,"C2_RECURSO" , "QRY", RetTitle("C2_RECURSO") ,PesqPict("SC2","C2_RECURSO") ,TamSX3("C2_RECURSO")[1])
    TRCell():New(oSection1,"D3_COD"     , "QRY", RetTitle("D3_COD")      ,PesqPict("SD3","D3_COD")    ,TamSX3("D3_COD")[1])
    TRCell():New(oSection1,"B1_DESC"    , "QRY", RetTitle("B1_DESC")    ,PesqPict("SB1","B1_DESC")    ,TamSX3("B1_DESC")[1])
    TRCell():New(oSection1,"D3_XHORA"   , "QRY", RetTitle("D3_XHORA")   ,PesqPict("SD3","D3_XHORA")   ,TamSX3("D3_XHORA")[1])
    TRCell():New(oSection1,"D3_QUANT"   , "QRY", RetTitle("D3_QUANT")   ,PesqPict("SD3","D3_QUANT")   ,TamSX3("D3_QUANT")[1])
    TRCell():New(oSection1,"D3_UM"      , "QRY", RetTitle("D3_UM")      ,PesqPict("SD3","D3_UM")      ,TamSX3("D3_UM")[1])
    TRCell():New(oSection1,"D3_CF"      , "QRY", RetTitle("D3_CF")      ,PesqPict("SD3","D3_CF")      ,TamSX3("D3_CF")[1])
    TRCell():New(oSection1,"D3_NUMSEQ"  , "QRY", RetTitle("D3_NUMSEQ")  ,PesqPict("SD3","D3_NUMSEQ")  ,TamSX3("D3_NUMSEQ")[1])
    TRCell():New(oSection1,"D3_XINTEGR" , "QRY", RetTitle("D3_XINTEGR") ,"@!"                         , 25)
 

return (oReport)
 
Static Function PrintReport(oReport)

	Local cAlias    := getNextAlias()
	Local oSection1 := oReport:Section(1)
	oSection1:Init()
	oSection1:SetHeaderSection(.T.)
 
	BeginSql alias cAlias
		%noParser%
		SELECT D3_FILIAL  ,	       
			   CB0_CODETI ,
			   D3_EMISSAO ,
			   D3_USUARIO ,
			   D3_USUARIO AS D3_NOMEUSER,
	 	       D3_OP      ,
		       C2_RECURSO ,
		       D3_COD     ,	   
		       B1_DESC    ,	   
		       D3_XHORA   , 
		       D3_QUANT   , 	   
		       CASE D3_XINTEGR WHEN 'M'THEN 'MANUAL'
			        ELSE  'AUTOMATICO' 
		       END  AS D3_XINTEGR,
		       D3_UM      ,	   
		       D3_CF      , 
		       D3_NUMSEQ     	   
 	    FROM %table:SD3% SD3
	 		INNER JOIN %table:SC2% (NOLOCK)SC2 ON SC2.D_E_L_E_T_=' ' AND D3_FILIAL = C2_FILIAL AND C2_NUM+C2_ITEM+C2_SEQUEN = D3_OP			
	 		INNER JOIN %table:SB1% (NOLOCK)SB1 ON SB1.D_E_L_E_T_=''  AND B1_COD = D3_COD
	 		INNER JOIN %table:CB0% (NOLOCK)CB0 ON CB0.D_E_L_E_T_=''  AND CB0_NUMSEQ = D3_NUMSEQ
 		WHERE D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%  
 		AND D3_CF ='PR0'
 		AND D3_LOCAL BETWEEN '' AND 'ZZ'
 		AND LEFT(D3_COD, 3) != 'MOD'
 		AND C2_RECURSO =  %Exp:MV_PAR03%
		AND D3_ESTORNO =' '
 		ORDER BY D3_EMISSAO,D3_XHORA
	EndSql

	dbSelectArea(cAlias)
	dbGoTop()           
	oReport:SetMeter((cAlias)->(RecCount()))

	While (cAlias)->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
 
		oReport:IncMeter()
 
		oSection1:Cell("D3_FILIAL"):SetValue((cAlias)->D3_FILIAL)
		oSection1:Cell("D3_FILIAL"):SetAlign("CENTER")
 
		oSection1:Cell("CB0_CODETI"):SetValue((cAlias)->CB0_CODETI)
		oSection1:Cell("CB0_CODETI"):SetAlign("LEFT")
 
		oSection1:Cell("D3_EMISSAO"):SetValue(Substr((cAlias)->D3_EMISSAO,7,2) +"/"+Substr((cAlias)->D3_EMISSAO,5,2)+"/"+Substr((cAlias)->D3_EMISSAO,1,4))  
		oSection1:Cell("D3_EMISSAO"):SetAlign("LEFT")
 
		//oSection1:Cell("D3_USUARIO"):SetValue((cAlias)->D3_USUARIO)
		//oSection1:Cell("D3_USUARIO"):SetAlign("LEFT")
 
		oSection1:Cell("D3_NOMEUSER"):SetValue(Alltrim((cAlias)->D3_USUARIO)+ "-"+ UsrFullName(Alltrim((cAlias)->D3_NOMEUSER)))
		oSection1:Cell("D3_NOMEUSER"):SetAlign("LEFT")
		
		oSection1:Cell("D3_OP"):SetValue(Alltrim((cAlias)->D3_OP))
		oSection1:Cell("D3_OP"):SetAlign("LEFT")
 
		oSection1:Cell("C2_RECURSO"):SetValue(Alltrim((cAlias)->C2_RECURSO))
		oSection1:Cell("C2_RECURSO"):SetAlign("LEFT")
 
		oSection1:Cell("D3_COD"):SetValue(Alltrim((cAlias)->D3_COD))
		oSection1:Cell("D3_COD"):SetAlign("LEFT")
 
		oSection1:Cell("B1_DESC"):SetValue(Alltrim((cAlias)->B1_DESC))
		oSection1:Cell("B1_DESC"):SetAlign("LEFT")
 
		oSection1:Cell("D3_XHORA"):SetValue(Alltrim((cAlias)->D3_XHORA))
		oSection1:Cell("D3_XHORA"):SetAlign("LEFT")
 
		oSection1:Cell("D3_QUANT"):SetValue((cAlias)->D3_QUANT)   
		oSection1:Cell("D3_QUANT"):SetAlign("LEFT")
 
		oSection1:Cell("D3_UM"):SetValue(Alltrim((cAlias)->D3_UM))
		oSection1:Cell("D3_UM"):SetAlign("LEFT")

		oSection1:Cell("D3_CF"):SetValue(((cAlias)->D3_CF))
		oSection1:Cell("D3_CF"):SetAlign("LEFT")

		oSection1:Cell("D3_NUMSEQ"):SetValue((cAlias)->D3_NUMSEQ)
		oSection1:Cell("D3_NUMSEQ"):SetAlign("LEFT")

		oSection1:Cell("D3_XINTEGR"):SetValue(Alltrim((cAlias)->D3_XINTEGR))
		oSection1:Cell("D3_XINTEGR"):SetAlign("LEFT")
 
		oSection1:PrintLine()
 
		dbSelectArea(cAlias)
		(cAlias)->(dbSkip())
	EndDo

	oSection1:Finish()
Return

Static function criaSX1(cPerg)

	U_PIPutSx1(cPerg, '01', 'Da Data?'            , '', '', 'mv_ch1', 'D', 8, 0, 0, 'G', '',      '',     '', '', 'mv_par01')
	U_PIPutSx1(cPerg, '02', 'Até Data?'           , '', '', 'mv_ch2', 'D', 8, 0, 0, 'G', '',      '',     '', '', 'mv_par02')
	U_PIPutSx1(cPerg, '03', 'Recurso ?'           , '', '', 'mv_ch3', 'C', 6, 0, 0, 'G', '',      'SH1',  '', '', 'mv_par03')
	//U_PIPutSx1(cPerg, '04',PADR("Tipo Consulta?",29),'','', 'mv_ch4', 'N', 1, 0, 0, 'C', '',      ''   ,  '', '', 'mv_par04','Todos Movimentos','Todos Movimentos','Todos Movimentos','','Somente Manual','Somente Manual','Somente Manual','','Somente Automatico','Somente Automatico','Somente Automatico')
	
Return
