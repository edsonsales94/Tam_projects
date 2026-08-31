#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR44   ºAutor  ³Kledson Oliveira    				º Data ³  27/03/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Saldo atual de tecidos                      			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR44()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR44"

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

	oReport := TReport():New(cPerg,"Saldo atual de tecidos",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Saldo atual de tecidos",{"PED"},aOrdem) 

    TRCell():New(oSection,"COD_AMAZ"   	        ,"SB1","COD_AMAZ","@!",12)
    TRCell():New(oSection,"DESCRI_AMAZ"	   ,"SB1","DESCRI_AMAZON","@!",30)
    TRCell():New(oSection,"UM_AMAZ"	        ,"SB1","UM_AMAZ","@!",2)
   TRCell():New(oSection,"SALDO_AMAZ"	        ,"SB2","SALDO_AMAZ","@E 999,999,999,999",)
   TRCell():New(oSection,"SALDO_PELMEX"	        ,"SB2","SALDO_PELMEX","@E 999,999,999,999",)
    TRCell():New(oSection,"COD_PELMEX"   	        ,"SB2","COD_PELMEX","@!",12)
	TRCell():New(oSection,"DESCRI_PELMEX"	   ,"SB1","DESCRI_PELMEX","@!",30)
    TRCell():New(oSection,"UM_PELMEX"	        ,"SB1","UM_PELMEX","@!",2)
    //TRCell():New(oSection,"A1_NOME"		    ,"SA1","NOME","@!",20)
    //TRCell():New(oSection,"D2_TES"		    ,"SD2","TES","@!",20)
   //TRCell():New(oSection,"F4_TEXTO"		    ,"SF4","Descricao TES","@!",20)
    //TRCell():New(oSection,"C6_NUM"		     ,"SC6","C6_NUM","@!",7)
	//TRCell():New(oSection,"C6_ITEM"		  ,"SC6","C6_ITEM","@!",3)
    //TRCell():New(oSection,"C6_PRODUTO"	      ,"SC6","PRODUTO","@!",20) 
	//TRCell():New(oSection,"C6_CLI" 	         ,"SC6","C6_CLI","@!",7)
	//TRCell():New(oSection,"A1_NOME"	    ,"SA1","A1_NOME","@!",20)
	//TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) 

	
    
	
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

SELECT SB12.B1_COD COD_AMAZ,SB12.B1_DESC DESCRI_AMAZ,SB12.B1_UM UM_AMAZ, SB22.B2_QATU SALDO_AMAZ, SB2.B2_QATU SALDO_PELMEX, SB2.B2_COD COD_PELMEX, SB1.B1_DESC DESCRI_PELMEX,SB1.B1_UM UM_PELMEX
    FROM SB2200 SB22 (NOLOCK)
        INNER JOIN SB1200 SB12 (NOLOCK) ON SB22.B2_COD = SB12.B1_COD  
            AND SB12.D_E_L_E_T_ = '' 
            AND SB12.B1_MSBLQL != '1'
            AND SB22.B2_LOCAL = '01' 
            AND SB12.B1_GRUPO IN ('0106','0204')
        INNER JOIN SG1200 SG12 (NOLOCK) ON SB12.B1_COD = SG12.G1_COMP 
            AND SG12.D_E_L_E_T_ = ''
            AND SG12.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
        INNER JOIN SB2100 SB2 (NOLOCK) ON SG12.G1_COD = SB2.B2_COD
            AND SB2.D_E_L_E_T_ = ''
        INNER JOIN SB1100 SB1 (NOLOCK) ON SB2.B2_COD = SB1.B1_COD                             
    WHERE SB2.D_E_L_E_T_ = ''
            AND SB2.B2_FILIAL = '01'
            AND SB2.B2_LOCAL = '01'
            AND SB2.B2_COD LIKE '070%'
            //AND SB1.B1_DESC LIKE 'ART%TEC%'
            AND SB2.B2_QATU > 0
	        AND SB22.B2_QATU > 0





	    EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	//u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	//u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
