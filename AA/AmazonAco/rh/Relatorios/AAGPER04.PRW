#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH"
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ AAGPER04   ¶ Autor ¶ ANDERSON GADELHA     ¶ Data ¶ 12/08/2019 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Relatório de Dependente.                                      ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 

User Function AAGPER04()

local oReport   
local cPerg   := 'AAGPER04'
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

oSecao1:BeginQuery()

		BeginSql alias "AAGPER04"
		
					
		SELECT 
			  RB_FILIAL,
			  RB_MAT,
			  RA_NOME,
			  RB_NOME,
			  RB_CIC,
			  RB_DTBAIXA,
			  RB_SEXO,
			  RA_CC,
			  CTT_DESC01,
			  RB_TIPSF,
			  RB_TIPIR,
			  RB_DTNASC,

	CASE	WHEN RB_GRAUPAR = 'C' THEN 'Conjuge'  
			WHEN RB_GRAUPAR = 'F' AND RB_SEXO = 'M' THEN 'Filho' 
			WHEN RB_GRAUPAR = 'F' AND RB_SEXO = 'F' THEN 'Filha' 
			WHEN RB_GRAUPAR = 'E' AND RB_SEXO = 'M' THEN 'Enteado' 
			WHEN RB_GRAUPAR = 'E' AND RB_SEXO = 'F' THEN 'Enteada' 
			WHEN RB_GRAUPAR = 'P' AND RB_SEXO = 'M' THEN 'Pai' 
			WHEN RB_GRAUPAR = 'P' AND RB_SEXO = 'F' THEN 'Mae' 
			WHEN  RB_GRAUPAR = 'O' THEN 'Outros' 
			END RB_GRAUPAR , 
	CASE	WHEN RB_TIPIR = '1' THEN 'S/LIM IDADE'  
			WHEN RB_TIPIR = '2' THEN 'ATE 21 ANOS' 
			WHEN RB_TIPIR = '3' THEN 'ATE 24 ANOS' 
			WHEN RB_TIPIR = '4' THEN 'NAO E DEP' 
			END RB_TIPIR
            	  

	FROM %table:SRB% SRB 
		INNER JOIN %table:SRA% SRA ON SRA.D_E_L_E_T_ = '' AND SRA.RA_MAT = SRB.RB_MAT AND SRA.RA_FILIAL = SRB.RB_FILIAL
		INNER JOIN %table:CTT% CTT ON SRA.D_E_L_E_T_ = '' AND SRA.RA_CC = CTT.CTT_CUSTO 
	WHERE SRA.D_E_L_E_T_ = '' 
	AND RA_DEMISSA = ''
	ORDER BY RB_MAT
  
					
							      		  
		EndSql

		
cAlias:="AAGPER04"
oSecao1:EndQuery()
oReport:SetMeter((cAlias)->(RecCount()))
oSecao1:Print()

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatório de Dependente."
local cHelp   := "Relatório de Dependente. - Especifico Amazon Aço"
local oReport
local oSection1

oReport := TReport():New('AAGPER04',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetLandScape()
	  				  
//Primeira seção
oSection1 := TRSection():New(oReport,"Relatório de Dependente.",{"AAGPER04"})

TRCell():New(oSection1,"RB_FILIAL"      , "AAGPER04", RetTitle("RB_FILIAL")      ,PesqPict("SRB","RB_FILIAL")       ,TamSX3("RB_FILIAL")  [1])
TRCell():New(oSection1,"RB_MAT"         , "AAGPER04", RetTitle("RB_MAT")         ,PesqPict("SRB","RB_MAT")          ,TamSX3("RB_MAT")  [1])
TRCell():New(oSection1,"RA_NOME"        , "AAGPER04", RetTitle("RA_NOME")        ,PesqPict("SRA","RA_NOME")         ,TamSX3("RA_NOME")  [1])
TRCell():New(oSection1,"RB_NOME"        , "AAGPER04", RetTitle("RB_NOME")        ,PesqPict("SRB","RB_NOME")         ,TamSX3("RB_NOME")[1])
TRCell():New(oSection1,"RB_CIC"         , "AAGPER04", RetTitle("RB_CIC")         ,PesqPict("SRB","RB_CIC")          ,TamSX3("RB_CIC")  [1])
TRCell():New(oSection1,"RB_DTBAIXA"     , "AAGPER04", RetTitle("RB_DTBAIXA")     ,PesqPict("SRB","RB_DTBAIXA")      ,TamSX3("RB_DTBAIXA")[1])
TRCell():New(oSection1,"RB_SEXO"        , "AAGPER04", RetTitle("RB_SEXO")        ,PesqPict("SRB","RB_SEXO")         ,TamSX3("RB_SEXO")[1])
TRCell():New(oSection1,"RA_CC"          , "AAGPER04", RetTitle("RA_CC")          ,PesqPict("SRA","RA_CC")           ,TamSX3("RA_CC")  [1])
TRCell():New(oSection1,"CTT_DESC01"     , "AAGPER04", RetTitle("CTT_DESC01")     ,PesqPict("CTT","CTT_DESC01")      ,TamSX3("CTT_DESC01")  [1])
TRCell():New(oSection1,"RB_TIPSF"       , "AAGPER04", RetTitle("RB_TIPSF")       ,PesqPict("SRB","RB_TIPSF")        ,TamSX3("RB_TIPSF")   [1])
TRCell():New(oSection1,"RB_DTNASC"      , "AAGPER04", RetTitle("RB_DTNASC")      ,PesqPict("SRB","RB_DTNASC")       ,TamSX3("RB_DTNASC")[1])
TRCell():New(oSection1,"RB_GRAUPAR"     , "AAGPER04", RetTitle("RB_GRAUPAR")     ,PesqPict("SRB","RB_GRAUPAR")      ,TamSX3("RB_GRAUPAR")[1])
TRCell():New(oSection1,"RB_TIPIR"       , "AAGPER04", RetTitle("RB_TIPIR")       ,PesqPict("SRB","RB_TIPIR")        ,TamSX3("RB_TIPIR")   [1])


					   
	
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+

Static function criaSX1(cPerg)

	//U_PIPutSx1(cPerg, '01', 'Da Data?'          , '', '', 'mv_ch1', 'D', 6, 0, 0, 'G', '',      '',  '', '', 'mv_par01')
	//U_PIPutSx1(cPerg, '02', 'Até Data?'         , '', '', 'mv_ch2', 'D', 6, 0, 0, 'G', '',      '',  '', '', 'mv_par02')
	//U_PIPutSx1(cPerg, '03', 'Da Filial?'        , '', '', 'mv_ch2', 'F', 2, 0, 0, 'G', '',      '',  '', '', 'mv_par03')
	//U_PIPutSx1(cPerg, '04', 'Até Filial?'       , '', '', 'mv_ch2', 'F', 2, 0, 0, 'G', '',      '',  '', '', 'mv_par04')
	
Return