#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH"
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ AAESTR09   ¶ Autor ¶ ANDERSON GADELHA     ¶ Data ¶ 09/07/2019 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Relatório de Movimentação de Produção.                        ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 

User Function AAESTR09()

local oReport   
local cPerg   := 'AAESTR09'
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

		BeginSql alias "AAESTR09"
		
					
					Select Sum(CBG_QTDE) Over (Partition by CBG_LOTE) ACUM,			
					       CBG_DATA   , 
					       CBG_HORA   , 
					       CBG_USUARI ,
					       CB1_NOME   ,
					       CBG_CODPRO ,
					       CBG_CODETI , 
					       CBG_QTDE   ,  
					       CBG_LOTE   ,
					       CBG_ARM    ,
					       CBG_END    ,
					       CBG_ARMDES ,
					       CBG_ENDDES

                     From %table:CBG% CBG
                     INNER JOIN %table:CB1% CB1
                                             ON CB1.D_E_L_E_T_=''
                                             AND CBG_USUARI = CB1_CODUSR
                     WHERE CBG_FILIAL=%xFilial:CBG%
                     AND CBG.D_E_L_E_T_=''
                     AND CBG_DATA BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
                     AND CBG_ARMDES='03'
                     ORDER BY CBG_DATA, CBG_HORA, CB1_NOME, CBG_CODETI, CBG_QTDE  
					
							      		  
		EndSql

		
cAlias:="AAESTR09"
oSecao1:EndQuery()
oReport:SetMeter((cAlias)->(RecCount()))
oSecao1:Print()

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatório de Movimentação de Produção"
local cHelp   := "Relatório de Movimentação de Produção - Especifico Amazon Aço"
local oReport
local oSection1

oReport := TReport():New('AAESTR09',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetLandScape()
	  				  
//Primeira seção
oSection1 := TRSection():New(oReport,"Relatório de Movimentação de Produção",{"AAESTR09"})

TRCell():New(oSection1,"ACUM"          , "AAESTR09",  "ACUM"                   ,PesqPict("CBG","CBG_LOTE")      ,TamSX3("CBG_LOTE")  [1])
TRCell():New(oSection1,"CBG_DATA"      , "AAESTR09", RetTitle("CBG_DATA")      ,PesqPict("CBG","CBG_DATA")      ,TamSX3("CBG_DATA")  [1])
TRCell():New(oSection1,"CBG_HORA"      , "AAESTR09", RetTitle("CBG_HORA")      ,PesqPict("CBG","CBG_HORA")      ,TamSX3("CBG_HORA")  [1])
TRCell():New(oSection1,"CBG_USUARI"    , "AAESTR09", RetTitle("CBG_USUARI")    ,PesqPict("CBG","CBG_USUARI")    ,TamSX3("CBG_USUARI")[1])
TRCell():New(oSection1,"CB1_NOME"      , "AAESTR09", RetTitle("CB1_NOME")      ,PesqPict("CBG","CB1_NOME")      ,TamSX3("CB1_NOME")  [1])
TRCell():New(oSection1,"CBG_CODPRO"    , "AAESTR09", RetTitle("CBG_CODPRO")    ,PesqPict("CBG","CBG_CODPRO")    ,TamSX3("CBG_CODPRO")[1])
TRCell():New(oSection1,"CBG_CODETI"    , "AAESTR09", RetTitle("CBG_CODETI")    ,PesqPict("CBG","CBG_CODETI")    ,TamSX3("CBG_CODETI")[1])
TRCell():New(oSection1,"CBG_QTDE"      , "AAESTR09", RetTitle("CBG_QTDE")      ,PesqPict("CBG","CBG_QTDE")      ,TamSX3("CBG_QTDE")  [1])
TRCell():New(oSection1,"CBG_LOTE"      , "AAESTR09", RetTitle("CBG_LOTE")      ,PesqPict("CBG","CBG_LOTE")      ,TamSX3("CBG_LOTE")  [1])
TRCell():New(oSection1,"CBG_ARM"       , "AAESTR09", RetTitle("CBG_ARM")       ,PesqPict("CBG","CBG_ARM")       ,TamSX3("CBG_ARM")   [1])
TRCell():New(oSection1,"CBG_END"       , "AAESTR09", RetTitle("CBG_END")       ,PesqPict("CBG","CBG_END")       ,TamSX3("CBG_END")   [1])
TRCell():New(oSection1,"CBG_ARMDES"    , "AAESTR09", RetTitle("CBG_ARMDES")    ,PesqPict("CBG","CBG_ARMDES")    ,TamSX3("CBG_ARMDES")[1])
TRCell():New(oSection1,"CBG_ENDDES"    , "AAESTR09", RetTitle("CBG_ENDDES")    ,PesqPict("CBG","CBG_ENDDES")    ,TamSX3("CBG_ENDDES")[1])
					   
	
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+

Static function criaSX1(cPerg)

	U_PIPutSx1(cPerg, '01', 'Da Data?'          , '', '', 'mv_ch1', 'D', 8, 0, 0, 'G', '',      '',  '', '', 'mv_par01')
	U_PIPutSx1(cPerg, '02', 'Até Data?'         , '', '', 'mv_ch2', 'D', 8, 0, 0, 'G', '',      '',  '', '', 'mv_par02')
	
Return
