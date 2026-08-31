
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR38  บAutor  ณJuevan Silva     				บ Data ณ 03/01/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Agendamentos Assistencia Detalhado                    			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR38()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR38"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return


Static Function ReportDef(cAlias,cPerg)
	Local oReport
	Local oSection
	Local oBreak
	Local aOrdem      := {"FILIAL"}

	oReport := TReport():New(cPerg,"Agendamentos Assistencia Detalhado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Agendamentos Assistencia Detalhado",{"SD2"},aOrdem) 

TRCell():New(oSection,"EMPRESA"   	        ,"MDA","EMPRESA","@!",3)
TRCell():New(oSection,"FILIAL"		    ,"MDA","FILIAL","@!",3)
TRCell():New(oSection,"CLIENTE" 	         ,"MDA","CLIENTE","@!",7)
TRCell():New(oSection,"NOME"		    ,"MDA","NOME","@!",20)
TRCell():New(oSection,"PRODUTO"	      ,"MDA","PRODUTO","@!",15)
TRCell():New(oSection,"DESCRI"		    ,"MDA","DESCRI","@!",30)
TRCell():New(oSection,"OP"	             ,"MDA","OP","@E 999,999,999,999",)
TRCell():New(oSection,"MDA_PROCED"		    ,"MDA","PROCED","@!",3)
TRCell():New(oSection,"MOTORISTA"  			,"MDA","MOTORISTA","@!",15)
TRCell():New(oSection,"MOTIVO"		    ,"MDA","MOTIVO","@!",30)
TRCell():New(oSection,"COD"		    ,"MDA","COD","@!",6)
TRCell():New(oSection,"MDA_MOTINT"		    ,"MDA","MOTINT","@!",20)
TRCell():New(oSection,"TRATATIVA"		    ,"MDA","TRATATIVA","@!",20)
TRCell():New(oSection,"MDA_OBSINT"		     ,"MDA","OBSINT","@!",7)
TRCell():New(oSection,"MDA_CONTMICRO"		  ,"MDA","CONTMICRO","@!",3)
TRCell():New(oSection,"AGENDA"	    ,"MDA","AGENDA","@!",10)
TRCell():New(oSection,"MDA_OBS"     	,"MDA","OBS","@!",15)
TRCell():New(oSection,"MDA_DETSOL"     	,"MDA","DETSOL","@!",15)
TRCell():New(oSection,"USUARIO"     	,"MDA","USUARIO","@!",15)
TRCell():New(oSection,"MDA_USERALT"     	,"MDA","USERALT","@!",15)
TRCell():New(oSection,"INCLUSAO"     	,"MDA","INCLUSAO","@!",10)
TRCell():New(oSection,"ALTERACAO"     	,"MDA","ALTERACAO","@!",10)


	
    
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999.999",,.F.,.T.)

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

SELECT MDA_EMPRESA EMPRESA, MDA_FILIAL FILIAL, MDA_CLIENTE CLIENTE, MDA_NOME NOME, MDA_PRODUTO PRODUTO, MDA_DESCRI DESCRI, MDA_CPRODUC OP, MDA_PROCED, MDA_CODMOT MOTORISTA,
MDA_MOTIVO MOTIVO, MDA_CODMTINT COD, MDA_MOTINT, MDA_TRATA TRATATIVA, MDA_OBSINT, MDA_CONTMICRO, MDA_DTAGENDA AGENDA, MDA_STATUS STATUS, MDA_OBS, MDA_DETSOL, MDA_USERINC USUARIO,
MDA_USERALT, MDA_DATINC INCLUSAO, MDA_DATALT ALTERACAO
FROM MDA
WHERE CONVERT(VARCHAR,CAST(MDA_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
ORDER BY CONVERT(VARCHAR,CAST(MDA_DATINC AS DATE),112)



		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
