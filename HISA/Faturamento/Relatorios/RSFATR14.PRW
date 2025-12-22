#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exemplo de relatorio usando tReport com duas Section
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
user function RSFATR14()
	Local cPerg := "RSFATR14"
	
	Private oReport, oSection1, oSection2

	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	oReport := ReportDef(cPerg)
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	oReport:PrintDialog()

return
                          	
//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cPerg)

local cTitle  := "Orçamento para Pré-Vendas"
//local cHelp   := "Orçamento para Pré-Vendas"
Local aOrdem  := {"Vendedor"}
local oReport
local oSection1
local oSection2
//local oBreak1
//Local nTotal	:= 0

oReport := TReport():New("RSFATR14", cTitle, cPerg , {|oReport| ReportPrint(oReport)},cTitle)
oReport:oPage:SetPaperSize(9)
oReport:SetPortrait(.T.)
oReport:SetTotalInLine(.F.)


//Primeira seção
oSection1 := TRSection():New(oReport,"Vendedor",{"SA3","TMP"},aOrdem)    
TRCell():New( oSection1, "A3_COD"		, "TMP", RetTitle("A3_COD"		),PesqPict("SA3","A3_COD"		),TamSx3("A3_COD")[1])
TRCell():New( oSection1, "A3_NOME"		, "", RetTitle("A3_NOME"		),PesqPict("SA3","A3_NOME"		),TamSx3("A3_NOME")[1])  
TRCell():New( oSection1, "CJ_EMISSAO"   , "", RetTitle("CJ_EMISSAO"		),PesqPict("SCJ","CJ_EMISSAO"	),TamSx3("CJ_EMISSAO")[1])  
TRCell():New( oSection1, "CJ_FILIAL"    , "", RetTitle("CJ_FILIAL"  	),PesqPict("SCJ","CJ_FILIAL"	),TamSx3("CJ_FILIAL")[1]) 
oSection1:SetTotalInLine(.F.)	
 

//Segunda seção
oSection2:= TRSection():New(oReport,"Clientes",{"SCJ","SCK","SA1","SA3","TMP"})
        
oSection2:SetLeftMargin(5)   
oBreak := TRBreak():New(oSection2,{ || oSection2:Cell("A1_COD"):uPrint },"Sub-Total",.F.) 
  
TRCell():New(oSection2,"A1_COD"		, "", RetTitle("A1_COD"			),PesqPict("SA1","A1_COD"		),TamSx3("A1_COD")[1])  
TRCell():New(oSection2,"A1_LOJA"   	, "", RetTitle("A1_LOJA"		),PesqPict("SA1","A1_LOJA"		),TamSx3("A1_LOJA")[1])  
TRCell():New(oSection2,"A1_NOME"	, "", RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME")[1])  
TRCell():New(oSection2,"A1_EST"		, "", RetTitle("A1_EST"			),PesqPict("SA1","A1_EST"		),TamSx3("A1_EST")[1])  
TRCell():New(oSection2,"CJ_NUM"   	, "", RetTitle("CJ_NUM"    		),PesqPict("SCJ","CJ_NUM"		),TamSx3("CJ_NUM")[1]) 
TRCell():New(oSection2,"CJ_COTCLI" 	, "", RetTitle("CJ_COTCLI"    	),PesqPict("SCJ","CJ_COTCLI"		),TamSx3("CJ_COTCLI")[1]) 
TRCell():New(oSection2,"TOTORC"     , "", "Total Orçamento"			 ,PesqPict("SCK","CK_VALOR"		),TamSx3("CK_VALOR")[1]) 
TRCell():New(oSection2,"TOTDESC"    , "", "Desconto       "		 	 ,PesqPict("SCK","CK_VALOR"		),TamSx3("CK_VALOR")[1]) 
TRCell():New(oSection2,"CK_VALOR"   , "", "Total Fiscal"			 ,PesqPict("SCK","CK_VALOR"		),TamSx3("CK_VALOR")[1]) 
TRCell():New(oSection2,"CK_XPRCFIN" , "", "Total Comercial"          ,PesqPict("SCK","CK_XPRCFIN"	),TamSx3("CK_XPRCFIN")[1]) 
TRCell():New(oSection2, "A3_COD"	, "TMP", RetTitle("A3_COD"		),PesqPict("SA3","A3_COD"		),TamSx3("A3_COD")[1])
TRCell():New(oSection2, "A3_NOME"	, "", RetTitle("A3_NOME"		),PesqPict("SA3","A3_NOME"		),TamSx3("A3_NOME")[1])  
oSection2:SetTotalInLine(.F.)	


TRFunction():New(oSection2:Cell("TOTORC")     ,/* cID */,"SUM",oBreak,"",PesqPict("SCK","CK_VALOR"),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/) 
TRFunction():New(oSection2:Cell("TOTDESC")     ,/* cID */,"SUM",oBreak,"",PesqPict("SCK","CK_VALOR"),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/) 
TRFunction():New(oSection2:Cell("CK_VALOR")     ,/* cID */,"SUM",oBreak,"",PesqPict("SCK","CK_VALOR"),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/) 
TRFunction():New(oSection2:Cell("CK_XPRCFIN")     ,/* cID */,"SUM",oBreak,"",PesqPict("SCK","CK_VALOR"),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/) 

                          	
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport)

local oSection1 := oReport:Section(1)
local oSection2 := oReport:Section(2)  
Local cQry := ""
Local nTotal := 0    
Local nTotal1 := 0
Local nTotFil  := 0
Local nTotFil1  := 0
Local nCkValor := 0 
Local nCKPrcFin := 0 
Local nCkTotG     := 0
Local nCkTotD    := 0
 
cQry+=" SELECT SCJ.CJ_FILIAL,SCJ.CJ_EMISSAO,SA3.A3_COD,SCJ.CJ_NUM,SCJ.CJ_COTCLI,SCJ.CJ_CLIENTE,SCJ.CJ_LOJA,SUM(SCK.CK_VALOR) AS CK_VALOR, SUM(SCK.CK_VALOR)-ROUND(SUM(SCK.CK_VALOR)*CJ_PDESCAB/100,2) AS TOTAL,ROUND(SUM(SCK.CK_VALOR)*CJ_PDESCAB/100,2) AS DESCONTO,SUM(SCK.CK_XPRCFIN) AS CK_XPRCFIN FROM "+RetSQLName("SCK")+" SCK "
cQry+=" INNER JOIN "+RetSQLName("SCJ")+" SCJ ON  "
cQry+=" SCJ.D_E_L_E_T_='' "
cQry+=" AND SCJ.CJ_FILIAL=SCK.CK_FILIAL "
cQry+=" AND SCJ.CJ_NUM=SCK.CK_NUM "
cQry+=" INNER JOIN "+RetSQLName("SA3")+" SA3 ON  "
cQry+=" SA3.D_E_L_E_T_='' "
cQry+=" AND SA3.A3_COD=SCJ.CJ_XVEND "
cQry+=" WHERE  "
cQry+=" SCJ.D_E_L_E_T_='' "                   
cQry+=" AND SCJ.CJ_XVEND>='"+mv_par01+"' "
cQry+=" AND SCJ.CJ_XVEND<='"+mv_par02+"' "
cQry+=" AND SCJ.CJ_EMISSAO>='"+DtoS(mv_par03)+"' "
cQry+=" AND SCJ.CJ_EMISSAO<='"+DtoS(mv_par04)+"' "
cQry+=" AND SCJ.CJ_CLIENTE>='"+mv_par05+"' "
cQry+=" AND SCJ.CJ_CLIENTE<='"+mv_par06+"' "                         
cQry+=" GROUP BY SCJ.CJ_FILIAL,SCJ.CJ_CLIENTE,SCJ.CJ_LOJA,SCJ.CJ_EMISSAO,SCJ.CJ_NUM,SCJ.CJ_COTCLI,SA3.A3_COD,SCJ.CJ_PDESCAB  "
cQry+=" ORDER BY SCJ.CJ_FILIAL,SCJ.CJ_EMISSAO,SCJ.CJ_NUM,SCJ.CJ_CLIENTE,SCJ.CJ_LOJA " 

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "THG", .T., .F. )

TCSETFIELD("THG","CJ_EMISSAO","D",8,0)

oReport:SetMeter(RecCount())
nTotal2 := 0
While !THG->(Eof())
	If oReport:Cancel()
		Exit
	EndIf		
	oReport:IncMeter()              

   	cFilSCJ	 := THG->CJ_FILIAL
   	nTotFG   := 0       
   	nTotFD   := 0       
	nTotFil  := 0       
	nTotFil1 := 0
	
	While !THG->(Eof())	.And. cFilSCJ == THG->CJ_FILIAL	
    
	    cVendedor:= THG->A3_COD
	   	dEmissao := THG->CJ_EMISSAO
		
		oSection1:Init()
		oSection1:SetHeaderSection(.T.)
	
		oSection1:Cell("A3_COD"):SetValue(THG->A3_COD)
		oSection1:Cell("A3_NOME"):SetValue(Posicione("SA3",1,xFilial("SA3")+THG->A3_COD,"A3_NOME"))
		oSection1:Cell("CJ_EMISSAO"):SetValue(THG->CJ_EMISSAO)
		oSection1:Cell("CJ_FILIAL"):SetValue(THG->CJ_FILIAL)	
		oSection1:Printline()
		oSection2:Init()
		nTotG   := 0 
		nTotD   := 0
		nTotal  := 0 
		nTotal1 := 0
		While !THG->(Eof()) .And. cVendedor == THG->A3_COD .And. dEmissao==THG->CJ_EMISSAO 
			oSection2:Cell("A1_COD"):SetValue(Alltrim(THG->CJ_CLIENTE))
			oSection2:Cell("A1_NOME"):SetValue(Alltrim(Posicione("SA1",1,xFilial("SA1")+THG->CJ_CLIENTE+THG->CJ_LOJA,"A1_NOME")))
			oSection2:Cell("A1_LOJA"):SetValue(Alltrim(THG->CJ_LOJA))
			oSection2:Cell("A1_EST"):SetValue(Alltrim(SA1->A1_EST))
			oSection2:Cell("CJ_NUM"):SetValue(Alltrim(THG->CJ_NUM))
			oSection2:Cell("CJ_COTCLI"):SetValue(Alltrim(THG->CJ_COTCLI))
			//oSection2:Cell("CK_VALOR"):SetValue(THG->CK_VALOR)
			oSection2:Cell("TOTORC"):SetValue(THG->CK_VALOR)
			oSection2:Cell("TOTDESC"):SetValue(THG->DESCONTO)
			oSection2:Cell("CK_VALOR"):SetValue(THG->TOTAL)
			//oSection2:Cell("CK_XPRCFIN"):SetValue(THG->CK_XPRCFIN)
			oSection2:Cell("CK_XPRCFIN"):SetValue(THG->TOTAL)
		  	//nTotal += THG->CK_VALOR
		    oSection2:Cell("A3_COD"):SetValue(THG->A3_COD)
		    oSection2:Cell("A3_NOME"):SetValue(Posicione("SA3",1,xFilial("SA3")+THG->A3_COD,"A3_NOME"))		  	
		  	ntotG   += THG->CK_VALOR
		  	nTotD   += THG->DESCONTO
		  	nTotal  += THG->TOTAL
		  	//nTotal1 += THG->CK_VALOR //THG->CK_XPRCFIN
			oSection2:Printline()     
			THG->(DBSKIP())
		EndDo        
		oSection2:SetTotalText("Total Vendedor:")                                                                
		oSection2:Finish()
        nTotFG  += nTotG
        nTotFD  += nTotD
		nTotFil += nTotal       
		nTotFil1+= nTotal
		oSection1:Finish()
	EndDo


	oReport:SkipLine()   
	oReport:Thinline()   

	nLin := oReport:Row()
	oReport:PrintText( "Total Filial:"+cFilSCJ, nLin ) //"TOTAL DO DIA: "
    oReport:PrintText( TRANSFORM(nTotFG,PesqPict("SCK","CK_VALOR"		)),nLin, oSection2:Cell("CK_VALOR"):ColPos() ) //"NR.CHAMADOS:"
    oReport:PrintText( TRANSFORM(nTotFD,PesqPict("SCK","CK_VALOR"		)),nLin, oSection2:Cell("CK_VALOR"):ColPos() ) //"NR.CHAMADOS:"   
	oReport:PrintText( TRANSFORM(nTotFil,PesqPict("SCK","CK_VALOR"		)),nLin, oSection2:Cell("CK_VALOR"):ColPos() ) //"NR.CHAMADOS:"
	oReport:PrintText( TRANSFORM(nTotFil1,PesqPict("SCK","CK_VALOR"		)),nLin, oSection2:Cell("CK_XPRCFIN"):ColPos() ) //"NR.CHAMADOS:"
	oReport:SkipLine()
	nCkTotG  += nTotFG       
	nCkTotD  += nTotFD       
	nCkValor += nTotFil       
	nCKPrcFin += nTotFil
EndDo

oReport:SkipLine()   
oReport:Thinline()   

nLin := oReport:Row()
oReport:PrintText( "Total Geral:", nLin ) //"TOTAL DO DIA: "                                                                       
oReport:PrintText( TRANSFORM(nCkTotG,PesqPict("SCK","CK_VALOR"		)),nLin, oSection2:Cell("CK_VALOR"):ColPos() ) //"NR.CHAMADOS:"
oReport:PrintText( TRANSFORM(nCkTotD,PesqPict("SCK","CK_VALOR"		)),nLin, oSection2:Cell("CK_VALOR"):ColPos() ) //"NR.CHAMADOS:"
oReport:PrintText( TRANSFORM(nCkValor,PesqPict("SCK","CK_VALOR"		)),nLin, oSection2:Cell("CK_VALOR"):ColPos() ) //"NR.CHAMADOS:"
oReport:PrintText( TRANSFORM(nCKPrcFin,PesqPict("SCK","CK_VALOR"		)),nLin, oSection2:Cell("CK_XPRCFIN"):ColPos() ) //"NR.CHAMADOS:"
oReport:SkipLine()

THG->(dbCloseArea())

Return                            

Static Function ValidPerg(cPerg)
	u_HMPutSX1(cPerg,"01",PADR("Vendedor  De ",29)+"?"		,"","","mv_ch1","C"	, 6,0,0,"G","","SA3","","","mv_par01")
	u_HMPutSX1(cPerg,"02",PADR("Vendedor Ate ",29)+"?"		,"","","mv_ch2","C"	, 6,0,0,"G","","SA3","","","mv_par02")          
	u_HMPutSx1(cPerg,"03",PADR("Emissão de   ",29)+"?"		,"","","mv_ch3","D" , 8,0,0,"G","","","","","mv_par03")
	u_HMPutSx1(cPerg,"04",PADR("Emissão até  ",29)+"?"		,"","","mv_ch4","D" , 8,0,0,"G","","","","","mv_par04")
	u_HMPutSX1(cPerg,"05",PADR("Cliente De   ",29)+"?"		,"","","mv_ch5","C"	, 6,0,0,"G","","SA1","","","mv_par05")	
	u_HMPutSX1(cPerg,"06",PADR("Cliente Até  ",29)+"?"		,"","","mv_ch6","C"	, 6,0,0,"G","","SA1","","","mv_par06")		
Return
