#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH"
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ AAGPE03    ¶ Autor ¶ WILLIAMS MESSA       ¶ Data ¶ 01/07/2019 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Relatório  Funcionários por turno de Trabalho                 ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 

User Function AAGPE03()

local oReport   
local cPerg   := 'AAGPE03'
local cAlias  := getNextAlias()


//criaSx1(cPerg)
//Pergunte(cPerg, .F.)

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

		BeginSql alias "AAGPE03"
		
			  SELECT PF_FILIAL  ,
			  		 PF_MAT     ,
			  		 RA_NOME    ,
			  		 RA_SITFOLH ,
			  		 PF_TURNOPA ,
			  		 R6_DESC  
			  FROM %table:SPF% SPF 
			  INNER JOIN %table:SRA% SRA ON RA_MAT = PF_MAT AND SRA.%notDel%
			  INNER JOIN %table:SR6% SR6 ON R6_TURNO = PF_TURNOPA AND SR6.%notDel% 
			  WHERE SPF.%notDel% 
			    AND SPF.PF_FILIAL = %xFilial:SPF% 
			    AND RA_SITFOLH NOT IN('D')
			    AND PF_DATA = (SELECT MAX(PF_DATA) AS PF_DATA FROM %table:SPF% SPF WHERE RA_FILIAL=PF_FILIAL AND PF_MAT= RA_MAT AND SPF.%notDel% )
		      ORDER BY PF_FILIAL,PF_TURNOPA
		      		  
		EndSql

		
cAlias:="AAGPE03"
oSecao1:EndQuery()
oReport:SetMeter((cAlias)->(RecCount()))
oSecao1:Print()

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatório  Funcionários por Turno de Trabalho"
local cHelp   := "Relatório  Funcionários por turno de Trabalho - Especifico Amazon Aço"
local oReport
local oSection1

oReport := TReport():New('AAGPE03',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetLandScape()
	  				  
//Primeira seção
oSection1 := TRSection():New(oReport,"Relatório  Funcionários por turno de Trabalho",{"AAGPE03"})

TRCell():New(oSection1,"PF_FILIAL"  , "AAGPE03", RetTitle("PF_FILIAL") ,PesqPict("SPF","PF_FILIAL")  ,TamSX3("PF_FILIAL")[1])
TRCell():New(oSection1,"PF_MAT"     , "AAGPE03", RetTitle("PF_MAT")    ,PesqPict("SPF","PF_MAT")     ,TamSX3("PF_MAT")[1])
TRCell():New(oSection1,"RA_NOME"    , "AAGPE03", RetTitle("RA_NOME")   ,PesqPict("SRA","RA_NOME")    ,TamSX3("RA_NOME")[1])
TRCell():New(oSection1,"RA_SITFOLH" , "AAGPE03", RetTitle("RA_SITFOLH"),PesqPict("SRA","RA_SITFOLH") ,TamSX3("RA_SITFOLH")[1])
TRCell():New(oSection1,"PF_TURNOPA" , "AAGPE03", RetTitle("PF_TURNOPA"),PesqPict("SPF","PF_TURNOPA") ,TamSX3("RA_ADMISSA")[1])
TRCell():New(oSection1,"R6_DESC"    , "AAGPE03", RetTitle("R6_DESC")   ,PesqPict("SR6","R6_DESC")    ,TamSX3("R6_DESC")[1])

	
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
/*
Static function criaSX1(cPerg)

	U_PIPutSx1(cPerg, '01', 'Da Data?'          , '', '', 'mv_ch1', 'D', 6, 0, 0, 'G', '',      '',  '', '', 'mv_par01')
	U_PIPutSx1(cPerg, '02', 'Até Data?'         , '', '', 'mv_ch2', 'D', 6, 0, 0, 'G', '',      '',  '', '', 'mv_par02')

	Aadd(aPergs,{ "De Centro de Custo    ?", "", "","mv_ch5", "C", 9, 0, 0, "G", "","mv_par05", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","CTT"})
	Aadd(aPergs,{ "Ate Centro de Custo   ?", "", "","mv_ch6", "C", 9, 0, 0, "G", "","mv_par06", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","CTT"})
	Aadd(aPergs,{ "De Matricula          ?", "", "","mv_ch7", "C", 6, 0, 0, "G", "","mv_par07", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","SRA"})
	Aadd(aPergs,{ "Ate Matricula         ?", "", "","mv_ch8", "C", 6, 0, 0, "G", "","mv_par08", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","SRA"})
	
Return
*/ 