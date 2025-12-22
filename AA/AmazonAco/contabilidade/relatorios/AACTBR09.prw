#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "FWCOMMAND.CH"
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ AACTBR009  ¶ Autor ¶ Williams Messa       ¶ Data ¶ 26/02/2021 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Relatório de Ativo Fixo                                       ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 
user function AACTBR09()

local oReport
local cPerg  := 'AACTBR009'
local cAlias := getNextAlias()

criaSx1(cPerg)
Pergunte(cPerg, .F.)//PARAMETRO DE PERGUNTAS

oReport := reportDef(cAlias, cPerg)
oReport:printDialog()
return
        
//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+

Static Function ReportPrint(oReport,cAlias)
              
Local oSecao1 := oReport:Section(1)
Local cWhere  := "" 
oSecao1:BeginQuery()

If MV_PAR13  == 1 //Ativos
	cWhere  := "% N1_BAIXA =''  %
ElseIf MV_PAR13  == 2 //Baixados e Não transferidos
	cWhere  := "% N1_BAIXA !='' AND N1_STATUS !='4' %
Else //Baixados e Transferidos
	cWhere  := "% N1_BAIXA !='' AND N1_STATUS ='4' %
EndIf

BeginSQL Alias "QRYRROSERV"
  
SELECT N1_FILIAL, 
 		N1_CBASE, 
 		N1_DESCRIC, 
 		N1_PLACA ,
 		N1_CHAPA, 
 		N1_NFISCAL, 
 		N1_NSERIE, 
 		N1_FORNEC , 
 		N1_LOJA  ,
 		Case WHEN N1_FORNEC !='' THEN
 			Isnull((SELECT A2_NOME FROM  %table:SA2% A2 WHERE A2_COD = N1_FORNEC AND A2_LOJA= N1_LOJA AND A2.%notDel%),'  ') 
 		ELSE
 			'' 
 		End 
 		AS A2_NOME,
 		N1_AQUISIC, 
 		N3_DINDEPR, 
 		N3_TXDEPR1, 
		N3_VORIG1, 
		N1_GRUPO, 
		N3_HISTOR ,
		N3_VRDACM1,
		(N3_VORIG1-N3_VRDACM1)AS N3_RESIDO,
		N3_VRDMES1, 
		N3_CCUSTO,
		N3_CCONTAB, 
		N3_CDEPREC, 
		N3_CCDEPR,
		N1_STATUS,
		N1_BAIXA,
		N1_PATRIM,
		N1_PENHORA
FROM %table:SN3% N3
	INNER JOIN %table:SN1% N1 ON N1.%notDel%
		AND N3_FILIAL =  N1_FILIAL
		AND N3_CBASE  =  N1_CBASE
		AND N3_ITEM   =  N1_ITEM
		WHERE N3.%notDel%
			AND N3_CBASE <> 'NFE0000001' 
			//AND (N1_FORNEC='' OR N1_NFISCAL='')
			AND N1_FILIAL  >= %Exp:mv_par01% 
			AND N1_FILIAL  <= %Exp:mv_par02%
			AND N1_CBASE   >= %Exp:mv_par03%
			AND N1_CBASE   <= %Exp:mv_par04%
			AND N1_AQUISIC BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
			AND N1_NFISCAL >= %Exp:mv_par07% 
			AND N1_NFISCAL <= %Exp:mv_par08%
			AND N3_CCUSTO  >= %Exp:mv_par09% 
			AND N3_CCUSTO  <= %Exp:mv_par10%
			AND N1_GRUPO   >= %Exp:mv_par11% 
			AND N1_GRUPO   <= %Exp:mv_par12% 
			AND %Exp:cWhere%
ORDER BY  N1_GRUPO,N1_CBASE
 
EndSQL

cAlias:="QRYRROSERV"
oSecao1:EndQuery()
oReport:SetMeter((cAlias)->(RecCount()))
oSecao1:Print() 

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatório de Ativo Imobilizado"
local cHelp   := "Permite gerar relatório de Ativo Imobilizado"
local oReport
local oSection1
Local oBreak //QUEBRA

oReport := TReport():New('RATF0001',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetLandScape()

//Primeira seção
oSection1 := TRSection():New(oReport,cTitle,{"QRYRROSERV"}) 

//TRCell():New(oSection1,"D2_FILIAL", "QRYRROSERV", RetTitle("D2_FILIAL") 	,PesqPict("SD2","D2_FILIAL")  ,TamSX3("D2_FILIAL")[1])
TRCell():New(oSection1,"N1_FILIAL", "QRYRROSERV", RetTitle("N1_FILIAL")	,PesqPict("SN1","N1_FILIAL") ,TamSX3("N1_FILIAL")[1])
TRCell():New(oSection1,"N1_CBASE",  "QRYRROSERV", RetTitle("N1_CBASE")	,PesqPict("SN1","N1_CBASE")  ,TamSX3("N1_CBASE")[1]) 
TRCell():New(oSection1,"N1_DESCRIC","QRYRROSERV", RetTitle("N1_DESCRIC"),PesqPict("SN1","N1_DESCRIC"),TamSX3("N1_DESCRIC")[1]) 
TRCell():New(oSection1,"N1_PLACA",  "QRYRROSERV", RetTitle("N1_PLACA")	,PesqPict("SN1","N1_PLACA")  ,TamSX3("N1_PLACA")[1])
TRCell():New(oSection1,"N1_CHAPA",  "QRYRROSERV", RetTitle("N1_CHAPA")	,PesqPict("SN1","N1_CHAPA")  ,TamSX3("N1_CHAPA")[1])
TRCell():New(oSection1,"N1_NFISCAL","QRYRROSERV", RetTitle("N1_NFISCAL"),PesqPict("SN1","N1_NFISCAL"),TamSX3("N1_NFISCAL")[1])
TRCell():New(oSection1,"N1_NSERIE",	"QRYRROSERV", RetTitle("N1_NSERIE")	,PesqPict("SN1","N1_NSERIE") ,TamSX3("N1_NSERIE")[1])
TRCell():New(oSection1,"N1_FORNEC",	"QRYRROSERV", RetTitle("N1_FORNEC")	,PesqPict("SN1","N1_FORNEC") ,TamSX3("N1_FORNEC")[1])
TRCell():New(oSection1,"N1_LOJA",	"QRYRROSERV", RetTitle("N1_LOJA")	,PesqPict("SN1","N1_LOJA")   ,TamSX3("N1_LOJA")[1])
TRCell():New(oSection1,"A2_NOME",	"QRYRROSERV", RetTitle("A2_NOME")	,PesqPict("SA2","A2_NOME")   ,TamSX3("A2_NOME")[1])
TRCell():New(oSection1,"N1_AQUISIC","QRYRROSERV", RetTitle("N1_AQUISIC"),PesqPict("SN1","N1_AQUISIC"),TamSX3("N1_AQUISIC")[1])
TRCell():New(oSection1,"N3_DINDEPR","QRYRROSERV", RetTitle("N3_DINDEPR"),PesqPict("SN3","N3_DINDEPR"),TamSX3("N3_DINDEPR")[1])
TRCell():New(oSection1,"N3_TXDEPR1","QRYRROSERV", RetTitle("N3_TXDEPR1"),PesqPict("SN3","N3_TXDEPR1"),TamSX3("N3_TXDEPR1")[1])
TRCell():New(oSection1,"N3_VORIG1", "QRYRROSERV", RetTitle("N3_VORIG1")	,PesqPict("SN3","N3_VORIG1") ,TamSX3("N3_VORIG1")[1])
TRCell():New(oSection1,"N1_GRUPO",	"QRYRROSERV", RetTitle("N1_GRUPO")	,PesqPict("SN1","N1_GRUPO")  ,8)
TRCell():New(oSection1,"N3_HISTOR",	"QRYRROSERV", RetTitle("N3_HISTOR")	,PesqPict("SN3","N3_HISTOR") ,20)
TRCell():New(oSection1,"N3_VRDACM1","QRYRROSERV", RetTitle("N3_VRDACM1"),PesqPict("SN3","N3_VRDACM1"),TamSX3("N3_VRDACM1")[1])
TRCell():New(oSection1,"N3_RESIDO",	"QRYRROSERV", "Residuo"				,PesqPict("SN3","N3_VRDACM1"),TamSX3("N3_VRDACM1")[1])
TRCell():New(oSection1,"N3_VRDMES1","QRYRROSERV", RetTitle("N3_VRDMES1"),PesqPict("SN3","N3_VRDMES1"),TamSX3("N3_VRDMES1")[1])
TRCell():New(oSection1,"N3_CCUSTO",	"QRYRROSERV", RetTitle("N3_CCUSTO")	,PesqPict("SN3","N3_CCUSTO") ,TamSX3("N3_CCUSTO")[1])
TRCell():New(oSection1,"N3_CCONTAB","QRYRROSERV", RetTitle("N3_CCONTAB"),PesqPict("SN3","N3_CCONTAB"),10)
TRCell():New(oSection1,"N3_CDEPREC","QRYRROSERV", RetTitle("N3_CDEPREC"),PesqPict("SN3","N3_CDEPREC"),10)
TRCell():New(oSection1,"N3_CCDEPR",	"QRYRROSERV", RetTitle("N3_CCDEPR")	,PesqPict("SN3","N3_CCDEPR") ,10)

//INSERINDO 
oBreak  := TRBreak():New(oSection1,oSection1:Cell("N1_GRUPO") ,"T O T A L   GRUPO  ----> ",.F.)
//oBreak := TRBreak():New(oSection1,oSection1:Cell("N1_FILIAL"),"T O T A L   GERAL / FILIAL   ---->",.F.)

//Total Filial
//TRFunction():New(oSection1:Cell("N3_VORIG1"),"","SUM",oBreak ,,PesqPict("SN3","N3_VORIG1"),,.F.,.F.)//VALOR ORIGINAL
//TRFunction():New(oSection1:Cell("N3_VRDACM1"),"","SUM",oBreak,,PesqPict("SN3","N3_VRDACM1"),,.F.,.F.)//VALOR ACUMULADO
//TRFunction():New(oSection1:Cell("N3_RESIDO"),"","SUM",oBreak ,,PesqPict("SN3","N3_VRDACM1"),,.F.,.F.)//RESIDUAL
//TRFunction():New(oSection1:Cell("N3_VRDMES1"),"","SUM",oBreak ,,PesqPict("SN3","N3_VRDMES1"),,.F.,.F.)//RESIDUAL
//Total por Grupo
TRFunction():New(oSection1:Cell("N3_VORIG1") ,"","SUM",oBreak ,,PesqPict("SN3","N3_VORIG1") ,,.F.,.F.)//VALOR ORIGINAL
TRFunction():New(oSection1:Cell("N3_VRDACM1"),"","SUM",oBreak ,,PesqPict("SN3","N3_VRDACM1"),,.F.,.F.)//VALOR ACUMULADO
TRFunction():New(oSection1:Cell("N3_RESIDO") ,"","SUM",oBreak ,,PesqPict("SN3","N3_VRDACM1"),,.F.,.F.)//RESIDUAL
TRFunction():New(oSection1:Cell("N3_VRDMES1") ,"","SUM",oBreak ,,PesqPict("SN3","N3_VRDMES1"),,.F.,.F.)//RESIDUAL


Return(oReport)
//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

U_PIPutSx1(cPerg, '01', 'Da Filial?'          , '', '', 'mv_ch1', 'C', 4, 0, 0, 'G', '', 'SM0', '', '', 'mv_par01')
U_PIPutSx1(cPerg, '02', 'Até Filial?'         , '', '', 'mv_ch2', 'C', 4, 0, 0, 'G', '', 'SM0', '', '', 'mv_par02')
U_PIPutSx1(cPerg, '03', 'Cod. Bem?'        	  , '', '', 'mv_ch3', 'C', 4, 0, 0, 'G', '', 'SN1', '', '', 'mv_par03')
U_PIPutSx1(cPerg, '04', 'Até Cod. Bem?'       , '', '', 'mv_ch4', 'C', 4, 0, 0, 'G', '', 'SN1', '', '', 'mv_par04')
U_PIPutSx1(cPerg, '05', 'Data Aquisição?'     , '', '', 'mv_ch5', 'D', 6, 0, 0, 'G', '',    '', '', '', 'mv_par05')
U_PIPutSx1(cPerg, '06', 'Até Data Aquisição?' , '', '', 'mv_ch6', 'D', 6, 0, 0, 'G', '',    '', '', '', 'mv_par06')
U_PIPutSx1(cPerg, '07', 'Nota Fiscal?'        , '', '', 'mv_ch7', 'C', 9, 0, 0, 'G', '',    '', '', '', 'mv_par07')
U_PIPutSx1(cPerg, '08', 'Até Nota Fiscal?'    , '', '', 'mv_ch8', 'C', 9, 0, 0, 'G', '',    '', '', '', 'mv_par08')
U_PIPutSx1(cPerg, '09', 'CC Despesa?'         , '', '', 'mv_ch9', 'C', 4, 0, 0, 'G', '', 'CTT', '', '', 'mv_par09')
U_PIPutSx1(cPerg, '10', 'Até CC Despesa?'     , '', '', 'mv_ch10', 'C',4, 0, 0, 'G', '', 'CTT', '', '', 'mv_par10')
U_PIPutSx1(cPerg, '11', 'Grupo de?'        	  , '', '', 'mv_ch11', 'C',4, 0, 0, 'G', '', 'SNG', '', '', 'mv_par11')
U_PIPutSx1(cPerg, '12', 'Até Grupo?'          , '', '', 'mv_ch12', 'C',4, 0, 0, 'G', '', 'SNG', '', '', 'mv_par12')
U_PIPutSx1(cPerg, '13',PADR("Ver Baixados?",29), '', '', 'mv_ch13', 'N',1, 0, 0, 'C', '', ''	, '', '','mv_par13','Não Baixados','Não Baixados','Não Baixados','','Baixados','Baixados','Baixados','','Bx Transferidos','Bx Transferidos','Bx Transferidos')

return  
