#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH"
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ AAGPE02    ¶ Autor ¶ WILLIAMS MESSA       ¶ Data ¶ 26/06/2019 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Relatório  de  Ultima Altearações de Salário                  ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 

User Function AAGPE02()

local oReport   
local cPerg   := 'AAGPE02'
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

		BeginSql alias "AAGPE02"
		      
		      SELECT RA_FILIAL,
		      		 RA_MAT,
		      		 RA_NOME,
		      		 RA_CODFUNC,
		      		 RA_SITFOLH,
					 RA_ADMISSA,
					 RA_CIC,
					 RA_NASC,   
		      		 RJ_DESC,
		      		 R3_DATA,
		      		 R3_VALOR
		      		 FROM %table:SRA% SRA
		      		 LEFT OUTER JOIN %table:SRJ% SRJ  ON RJ_FUNCAO = RA_CODFUNC AND SRJ.%notDel%
		      		 LEFT OUTER JOIN %table:SR3% SR3  ON R3_FILIAL = RA_FILIAL  AND R3_MAT = RA_MAT AND SR3.%notDel%
		      		 WHERE SRA.%notDel% 
		      		 AND R3_PD='000'
		      		 AND R3_FILIAL=%xFilial:SR3% 
		      		 AND R3_DATA BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		      		 AND RA_SALARIO = R3_VALOR
		      		 AND R3_DATA= (SELECT MAX(R3_DATA) FROM %table:SR3% SR3 
		      		 			   WHERE R3_FILIAL = RA_FILIAL AND R3_MAT = RA_MAT AND SR3.%notDel% )
		      		 ORDER BY RA_FILIAL,RA_MAT		  
		EndSql

		
cAlias:="AAGPE02"
oSecao1:EndQuery()
oReport:SetMeter((cAlias)->(RecCount()))
oSecao1:Print()

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatório  Ultima Alteração Salário - Por Período"
local cHelp   := "Relatório  Ultima Alteração Salário - Por Período - Especifico Amazon Aço"
local oReport
local oSection1

oReport := TReport():New('AAGPE02',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetLandScape()
	  				  
//Primeira seção
oSection1 := TRSection():New(oReport,"Relatório  da Ultima Alteração Salário - Por Período",{"AAGPE02"})

TRCell():New(oSection1,"RA_FILIAL"  , "AAGPE02", RetTitle("RA_FILIAL") ,PesqPict("SRA","RA_FILIAL")  ,TamSX3("RA_FILIAL")[1])
TRCell():New(oSection1,"RA_MAT"     , "AAGPE02", RetTitle("RA_MAT")    ,PesqPict("SRA","RA_MAT")     ,TamSX3("RA_MAT")[1])
TRCell():New(oSection1,"RA_NOME"    , "AAGPE02", RetTitle("RA_NOME")   ,PesqPict("SRA","RA_NOME")    ,TamSX3("RA_NOME")[1])
TRCell():New(oSection1,"RA_CODFUNC" , "AAGPE02", RetTitle("RA_CODFUNC"),PesqPict("SRA","RA_CODFUNC") ,TamSX3("RA_CODFUNC")[1])
TRCell():New(oSection1,"RA_SITFOLH" , "AAGPE02", RetTitle("RA_SITFOLH"),PesqPict("SRA","RA_SITFOLH") ,TamSX3("RA_SITFOLH")[1])
TRCell():New(oSection1,"RA_ADMISSA" , "AAGPE02", RetTitle("RA_ADMISSA"),PesqPict("SRA","RA_ADMISSA") ,TamSX3("RA_ADMISSA")[1])
TRCell():New(oSection1,"RA_CIC"     , "AAGPE02", RetTitle("RA_CIC")    ,PesqPict("SRA","RA_CIC")     ,TamSX3("RA_CIC")[1])
TRCell():New(oSection1,"RA_NASC"    , "AAGPE02", RetTitle("RA_NASC")   ,PesqPict("SR3","RA_NASC")    ,TamSX3("RA_NASC")[1])
TRCell():New(oSection1,"R3_DATA"    , "AAGPE02", RetTitle("R3_DATA")   ,PesqPict("SR3","R3_DATA")    ,TamSX3("R3_DATA")[1])
TRCell():New(oSection1,"R3_VALOR"   , "AAGPE02", RetTitle("R3_VALOR")  ,PesqPict("SR3","R3_VALOR")   ,TamSX3("R3_VALOR")[1])

	
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
Static function criaSX1(cPerg)

U_PIPutSx1(cPerg, '01', 'Da Data?'          , '', '', 'mv_ch1', 'D', 8, 0, 0, 'G', '',      '',  '', '', 'mv_par01')
U_PIPutSx1(cPerg, '02', 'Até Data?'         , '', '', 'mv_ch2', 'D', 8, 0, 0, 'G', '',      '',  '', '', 'mv_par02')

Return 
