#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH"
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ AAGPER05   ¶ Autor ¶ ANDERSON GADELHA     ¶ Data ¶ 13/08/2019 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Relatório de Histórico de Função.                             ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 

User Function AAGPER05()

local oReport   
local cPerg   := 'AAGPER05'
local cAlias  := getNextAlias()


criaSx1(cPerg)
Pergunte(cPerg, .F.)

oReport := reportDef(cAlias, cPerg)
oReport:printDialog()

return
       
//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias) 

Local oSecao1   := oReport:Section(1)
Local cCondicao := ""


If mv_par05 == 1
   cCondicao := "% RA_DEMISSA BETWEEN "  + dtos(MV_PAR03) + "AND " + dtos(MV_PAR04) + "AND %"     //"RA_DEMISSA BETWEEN " + mv_par03 + "AND" + mv_par04 + "AND " 
Else  
   cCondicao := "% RA_ADMISSA BETWEEN "  + dtos(MV_PAR03) + "AND " + dtos(MV_PAR04) + "AND %"    //"% RA_ADMISSA	 BETWEEN " + %Exp:mv_par03% + "AND" + %Exp:mv_par04% +  "AND %"
EndIf  



oSecao1:BeginQuery()

		BeginSql alias "AAGPER05"
						
		SELECT 
		      RA_FILIAL, 
	          RA_MAT, 
	          RA_NOME, 
	          RA_CODFUNC, 
	          R7_FUNCAO, 
	          RJ_DESC,
			  R7_DATA,
			  R7_TIPO,
	          RA_ADMISSA, 
	          RA_NASC, 
	          RA_RG, 
	          RA_CC, 
			  CTT_DESC01,
			  X5_DESCRI
    FROM %table:SRA% SRA
         LEFT OUTER JOIN %table:SR7% SR7 ON R7_MAT=RA_MAT AND R7_FILIAL=RA_FILIAL AND SR7.D_E_L_E_T_ = ''
         INNER JOIN      %table:CTT% CTT ON CTT_CUSTO=RA_CC AND CTT.D_E_L_E_T_ = ''
		 INNER JOIN      %table:SRJ% SRJ ON RJ_FUNCAO=R7_FUNCAO AND SRJ.D_E_L_E_T_ = ''
		 INNER JOIN      %table:SX5% SX5 ON X5_TABELA ='41' AND X5_CHAVE = R7_TIPO AND SX5.D_E_L_E_T_=''
	WHERE %Exp:cCondicao%
	SRA.D_E_L_E_T_='' 
	AND RA_FILIAL BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	//AND R7_DATA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	//AND X5_CHAVE IN ('004','005','007','010')
	GROUP BY RA_FILIAL, RA_MAT,RA_NOME,RA_CODFUNC,R7_FUNCAO,RJ_DESC,R7_DATA,R7_TIPO,RA_ADMISSA,RA_NASC,RA_RG,RA_CC,CTT_DESC01,X5_DESCRI
	ORDER BY RA_MAT  

	

		EndSql

		
cAlias:="AAGPER05"
oSecao1:EndQuery()
oReport:SetMeter((cAlias)->(RecCount()))
oSecao1:Print()

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)


local cTitle  := "Relatório de Histórico de Função.  ."
local cHelp   := "Relatório de Histórico de Função.  . - Especifico Amazon Aço"
local oReport
local oSection1

oReport := TReport():New('AAGPER05',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetLandScape()
	  				  
//Primeira seção
oSection1 := TRSection():New(oReport,"Relatório de Dependente.",{"AAGPER04"})

TRCell():New(oSection1,"RA_FILIAL"      , "AAGPER05", RetTitle("RA_FILIAL")      ,PesqPict("SRA","RA_FILIAL")       ,TamSX3("RA_FILIAL")  [1])
TRCell():New(oSection1,"RA_MAT"         , "AAGPER05", RetTitle("RA_MAT")         ,PesqPict("SRA","RA_MAT")          ,TamSX3("RA_MAT")  [1])
TRCell():New(oSection1,"RA_NOME"        , "AAGPER05", RetTitle("RA_NOME")        ,PesqPict("SRA","RA_NOME")         ,TamSX3("RA_NOME")  [1])
TRCell():New(oSection1,"RA_CODFUNC"     , "AAGPER05", RetTitle("RA_CODFUNC")     ,PesqPict("SRA","RA_CODFUNC")      ,TamSX3("RA_CODFUNC")[1])
TRCell():New(oSection1,"R7_FUNCAO"      , "AAGPER05", RetTitle("R7_FUNCAO")      ,PesqPict("SR7","R7_FUNCAO")       ,TamSX3("R7_FUNCAO")  [1])
TRCell():New(oSection1,"RJ_DESC"        , "AAGPER05", RetTitle("RJ_DESC")        ,PesqPict("SRJ","RJ_DESC")         ,TamSX3("RJ_DESC")[1])
TRCell():New(oSection1,"R7_DATA"        , "AAGPER05", RetTitle("R7_DATA")        ,PesqPict("SR7","R7_DATA")         ,TamSX3("R7_DATA")[1])
TRCell():New(oSection1,"R7_TIPO"        , "AAGPER05", RetTitle("R7_TIPO")        ,PesqPict("SR7","R7_TIPO")         ,TamSX3("R7_TIPO")[1])
TRCell():New(oSection1,"RA_ADMISSA"     , "AAGPER05", RetTitle("RA_ADMISSA")     ,PesqPict("SRA","RA_ADMISSA")      ,TamSX3("RA_ADMISSA")  [1])
TRCell():New(oSection1,"RA_NASC"        , "AAGPER05", RetTitle("RA_NASC")        ,PesqPict("SRA","RA_NASC")         ,TamSX3("RA_NASC")  [1])
TRCell():New(oSection1,"RA_RG"          , "AAGPER05", RetTitle("RA_RG")          ,PesqPict("SRA","RA_RG")           ,TamSX3("RA_RG")   [1])
TRCell():New(oSection1,"RA_CC"          , "AAGPER05", RetTitle("RA_CC")          ,PesqPict("SRA","RA_CC")           ,TamSX3("RA_CC")[1])
TRCell():New(oSection1,"CTT_DESC01"     , "AAGPER05", RetTitle("CTT_DESC01")     ,PesqPict("CTT","CTT_DESC01")      ,TamSX3("CTT_DESC01")[1])
TRCell():New(oSection1,"X5_DESCRI"      , "AAGPER05", RetTitle("X5_DESCRI")      ,PesqPict("SX5","X5_DESCRI")       ,TamSX3("X5_DESCRI")[1])


  
oBreak := TRBreak():New(oSection1,oSection1:Cell("RA_MAT")," --- ",.F.)
//oBreak2 := TRBreak():New(oSection1,oSection1:Cell("Z5_FILIAL") ,"T O T A L GERAL ----> ",.F.) 
					   
	
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+

Static function criaSX1(cPerg)

	
	  U_PIPutSx1(cPerg, '01', 'Da Filial?'        , '', '', 'mv_ch1', 'F', 2, 0, 0, 'G', '',      '',  '', '', 'mv_par01')
	  U_PIPutSx1(cPerg, '02', 'Até Filial?'       , '', '', 'mv_ch2', 'F', 2, 0, 0, 'G', '',      '',  '', '', 'mv_par02')
	  U_PIPutSx1(cPerg, '03', 'Da Data?'          , '', '', 'mv_ch3', 'D', 8, 0, 0, 'G', '',      '',  '', '', 'mv_par03')
	  U_PIPutSx1(cPerg, '04', 'Até Data?'         , '', '', 'mv_ch4', 'D', 8, 0, 0, 'G', '',      '',  '', '', 'mv_par04')
      U_PIPutSx1(cPerg, '05',PADR("Listar?",29),'', '', 'mv_ch5', 'N', 1, 0, 0, 'C', '', ''	, '', '', 'mv_par05','Demitidos','Demitidos','Demitidos','','Ativos','Ativos','Ativos')
	
Return
