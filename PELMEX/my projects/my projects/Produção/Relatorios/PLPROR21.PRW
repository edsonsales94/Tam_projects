#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR21    ºAutor  ³Wylliam Silva     				º Data ³  30/06/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Verifica Duplicidade PED   	    	                     			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR21()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR21"

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

	oReport := TReport():New(cPerg,"Verifica Duplicidade PED",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Verifica Duplicidade PED",{"PED"},aOrdem)  
	
    TRCell():New(oSection,"PED_NUM"	     ,"PED","Pedido","@!",6) 
    TRCell():New(oSection,"PED_NOTA"	     ,"PED","Nota","@!",9)             
	TRCell():New(oSection,"PED_ITEM"           ,"PED","Item","@!",3)
	TRCell():New(oSection,"PED_PRODUTO"       ,"PED","Produto","@!",15)
	TRCell():New(oSection,"PED_DESCRI"         ,"PED","Descricao","@!",35)
	TRCell():New(oSection,"PED_QUANT"         ,"PED","QTDE","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_DUPLICADA"       ,"PED","QTD_Duplicada","@E 999,999,999.999",)
	TRCell():New(oSection,"PED_CLIENTE"           ,"PED","Cod.Cliente","@!",10)
    TRCell():New(oSection,"PED_NOME"           ,"PED","Nome Clinte","@!",30)
    TRCell():New(oSection,"PED_MUN"           ,"PED","Municipio","@!",25)
    TRCell():New(oSection,"PED_SETOR"           ,"PED","Setor","@!",9)

	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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
		
        SELECT PED_NUM,PED_NOTA,PED_ITEM,PED_PRODUTO,PED_DESCRI,CAST(PED_QUANT AS FLOAT)PED_QUANT,COUNT(*)QTD_DUPLICADA,PED_CLIENTE,PED_NOME,PED_MUN,PED_SETOR
        FROM PED (NOLOCK)
        LEFT JOIN SC6100 SC6 (NOLOCK) ON C6_FILIAL = PED_FILIAL AND C6_NUM = PED_NUM AND C6_ITEM = PED_ITEM AND C6_PRODUTO = PED_PRODUTO AND PED_STATUS != 'C'
        WHERE CONVERT(VARCHAR,CAST(PED_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
        AND PED_STATUS != 'C'
        GROUP BY PED_NUM,PED_NOTA,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT,PED_CLIENTE,PED_NOME,PED_MUN,PED_SETOR
        HAVING COUNT(*) > 1
        ORDER BY PED_NUM,PED_ITEM

    EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissao.:"     ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao.:"    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")


Return
