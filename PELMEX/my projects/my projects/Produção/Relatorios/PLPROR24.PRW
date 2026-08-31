#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR22    ºAutor  ³Wylliam Silva     				º Data ³  12/07/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Verificacao De Dimensoes Faixa E Pillow                    			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR24()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR24"

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

	oReport := TReport():New(cPerg,"Verificacao De Dimensoes Faixa E Pillow",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Verificacao De Dimensoes Faixa E Pillow",{"SC2"},aOrdem)  

    TRCell():New(oSection,"C2_PRODUTO"	      ,"SC2","Produto_Acabado","@!",15) 
    TRCell():New(oSection,"C2_EMISSAO"	      ,"SC2","Emissao","@!",8)             
	TRCell():New(oSection,"D4_COD"            ,"SD4","Produto_","@!",15)
	TRCell():New(oSection,"B1_DESC"           ,"SB1","Descricao_","@!",35)
	TRCell():New(oSection,"B1_UM"             ,"SB1","UM","@!",3)
	TRCell():New(oSection,"D4_TRT"            ,"SD4","Seq.Estrutura","@!",3)
	TRCell():New(oSection,"C2_QUANT"          ,"SC2","Quantidade","@E 999,999,999.999999",)
    TRCell():New(oSection,"D4_QTDEORI"        ,"SD4","Quant_Ori","@E 999,999,999.999999")
    TRCell():New(oSection,"G1_XDIMENS"        ,"SG1","Dimensao","@!",11)
    TRCell():New(oSection,"G1_XMAQBOR"        ,"SG1","Maq_Bordadeira","@!",3)
    TRCell():New(oSection,"G1_XNBORD"         ,"SG1","Num_Bordado","@!",3)
    TRCell():New(oSection,"B1_XLARGUR"        ,"SG1","Largura","@!",6)
    TRCell():New(oSection,"G1_XDENSID"        ,"SG1","Densidade","@!",5)
    TRCell():New(oSection,"G1_XTECINV"        ,"SG1","TECINV","@!",6)
    TRCell():New(oSection,"G1_XESPESS"        ,"SG1","XESPESS","@!",6)
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

    SELECT C2_PRODUTO,C2_EMISSAO,D4_COD,B1_DESC,B1_UM,D4_TRT,C2_QUANT,G1_QUANT,D4_QTDEORI,G1_XDIMENS,G1_XMAQBOR,G1_XNBORD,B1_XLARGUR,G1_XDENSID,G1_XTECINV,G1_XESPESS 
                            FROM SC2100 SC2 (NOLOCK) 
                            INNER JOIN SG1100 SG1 (NOLOCK) ON G1_COD = C2_PRODUTO AND G1_COMP NOT LIKE 'MOD%' AND SG1.D_E_L_E_T_ = '' 
                            LEFT JOIN SD4100 SD4 (NOLOCK) ON C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP AND G1_COMP = D4_COD AND G1_TRT = D4_TRT AND SD4.D_E_L_E_T_ = '' 
                            INNER JOIN SB1100 SB1 (NOLOCK) ON D4_COD = B1_COD AND SB1.D_E_L_E_T_ = '' 
                            WHERE SC2.D_E_L_E_T_ = '' 
                            AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) 
                            AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
                            AND SUBSTRING(D4_TRT,1,2) IN ('PI','FX')
                            AND (B1_DESC LIKE 'ART%TEC%' 
                            OR B1_DESC LIKE 'ART%ANT%') 
              AND LEN(RTRIM(G1_XDIMENS)) != 11



    EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Data Inc:"     ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data Fim:"    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")


Return
