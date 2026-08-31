#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR99   ºAutor  ³Wylliam Silva     		    		º Data ³  14/04/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   APONTAMENTO DE MATERIAL DE OPS FUTURAS                      			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR100()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR100"

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

	oReport := TReport():New(cPerg,"APONTAMENTO DE MATERIAL DE OPS FUTURAS",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"APONTAMENTO DE MATERIAL DE OPS FUTURAS",{"SG1"},aOrdem) 

 
    TRCell():New(oSection,"COMPONENTE"   	    ,"SG1","COMPONENTE","@!",15)
	TRCell():New(oSection,"DESCRICAO"		    ,"SB1","DESCRICAO","@!",50)
	TRCell():New(oSection,"UM"		            ,"SB1","UM","@!",3)
    TRCell():New(oSection,"NECESSIDADE"		    ,"SG1","NECESSIDADE","@E 999,999,999.99",)
	//TRCell():New(oSection,"PENDENTE"		    ,"SGQ","PENDENTE","@@E 999,999,999.999",)
    //TRCell():New(oSection,"QTD_NC"	     ,"SGQ","QTD_NC","@@E 999,999,999.999",)    
	//TRCell():New(oSection,"QUANTIDADE"  	    ,"PED","QUANTIDADE","@@E 999,999,999.999",)
	//TRCell():New(oSection,"G1_XDENSID"			    ,"SG1","G1_XDENSID","@!",4)
	//TRCell():New(oSection,"G1_XDIMENS"        ,"SG1","G1_XDENSID","@!",30)
	//TRCell():New(oSection,"QTD_SOLICITADA" 	,"SG1","QTDE SOLICITAdA","@E 999,999,999.999",)
	//TRCell():New(oSection,"QTD_EMPENHADA"	,"SG1","QtDE EMPENHADA","@E 999,999,999.999",)
	//TRCell():New(oSection,"CARGA"  			,"SC2","CARGA","@!",12)
	//TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) 
	
    
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("TOTAL"),"TOTAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)

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

    SELECT G1_COMP COMPONENTE,B1_DESC DESCRICAO,B1_UM UM,SUM(NECESSIDADE)NECESSIDADE
    FROM(
        SELECT CODIGO,DESCRICAO,SUM(Z1_QUANT)QUANTIDADE,G1_COMP,B1_DESC,B1_UM,G1_QUANT,SUM(Z1_QUANT)*G1_QUANT NECESSIDADE
        FROM(
            SELECT C2_EMISSAO,Z1_DTAPONT,C2_PRODUTO CODIGO,B1_DESC DESCRICAO,Z1_OP+Z1_CHASSIS Z1_CPRODUC,
                CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END Z1_QUANT
            FROM SZ1100 SZ1 (NOLOCK)
            INNER JOIN SC2100 SC2 (NOLOCK) ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ = ''
            INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
            WHERE SZ1.D_E_L_E_T_ = ''
            AND C2_EMISSAO > Z1_DTAPONT
            AND Z1_DTAPONT >= %Exp:MV_PAR01% 
            )TB
        INNER JOIN SG1100 SG1 (NOLOCK) ON CODIGO = G1_COD AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = '' AND G1_COMP NOT LIKE 'MOD%'
        INNER JOIN SB1100 SB1 (NOLOCK) ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = ''
        GROUP BY CODIGO,DESCRICAO,G1_COMP,B1_DESC,B1_UM,G1_QUANT
        )TB1
    GROUP BY G1_COMP,B1_DESC,B1_UM
    ORDER BY B1_DESC

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("DT Inicio:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	/*u_InPutSX1(cPerg,"02",PADR("DT Fim:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")*/
	
	
	
Return
