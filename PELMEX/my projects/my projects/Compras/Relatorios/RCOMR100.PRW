#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ RCOMR100  ºAutor  ³ Alexandre Manini   º Data ³  22/09/2021º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Devolução 				                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                               			  ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

USER FUNCTION RCOMR100() 
	Local oReport 		:= nil
	Local cPerg			:= Padr("RCOMR100",10)

  	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport   := Nil
	Local oSection1 := Nil
	Local oSection2:= Nil 
 	Local oBreak    := Nil
	Local oFunction := Nil



	oReport := TReport():New(cNome,"Relatorio de Devoluções - RCOMR100",cNome,{|oReport| ReportPrint(oReport)},"Relatorio de Devoluções - RCOMR100")
	oReport:SetLandscape(.F.)
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 07
	oReport:lBold := .F.

	oSection1:= TRSection():New(oReport, "Dados" , {"TRBSC2","STJ","SB1","ST9","ST6","ST4","STD","STL","TAF","CTT","ST1","SBM","SA1"}, , .F., .T.)
	TRCell():New(oSection1,"FILIAL"		     				 ,"TRBSC2","FILIAL			"  				,"@!",06)
	TRCell():New(oSection1,"COD_EMITENTE"  	     			 ,"TRBSC2","COD_EMITENTE"	    	    	,"@!",18)
	TRCell():New(oSection1,"NOME_EMITENTE"  	     		 ,"TRBSC2","NOME_EMITENTE"	     		   	,"@!",05)
	TRCell():New(oSection1,"ESTADO"  	     				 ,"TRBSC2","ESTADO"	    			    	,"@!",30)
	TRCell():New(oSection1,"CIDADE"  	     				 ,"TRBSC2","CIDADE"	     				   	,"@!",45)
	TRCell():New(oSection1,"NUM_NOTA"  	     				 ,"TRBSC2","NOTA"	       				 	,"@!",14)
	TRCell():New(oSection1,"SERIE_NOTA"  	     			 ,"TRBSC2","SERIE"	    	   		 		,"@!",04)
	TRCell():New(oSection1,"CHAVE_NOTA"  	     			 ,"TRBSC2","CHAVE_NOTA"	       				,"@!",40)
	TRCell():New(oSection1,"DATA_EMISSAO"  		    		 ,"TRBSC2","DATA_EMISSAO"       			,"@!",14)
	TRCell():New(oSection1,"VALOR_NOTA" 		 	 		 ,"TRBSC2","VALOR_NOTA"	        			,"@E 99,999,999.99",12,,,"right",,)	
	TRCell():New(oSection1,"STATUS_DEVOLUCAO"  				 ,"TRBSC2","STATUS"    			 			,"@!",12)
	TRCell():New(oSection1,"DT_ENTRADA"  				 	 ,"TRBSC2","DT_ENTRADA"        				,"@!",16)	
	TRCell():New(oSection1,"XML"  				 	 		 ,"TRBSC2","NFE REF"        				,"@!",15)	
	TRCell():New(oSection1,"CARGA" 				 	 		 ,"TRBSC2","CARGA"	        				,"@!",10)	
	TRCell():New(oSection1,"TIPO_NF"						 ,"TRBSC2","TIPO_NF"						,"@!",15)	
	TRCell():New(oSection1,"STATUS_NF"						 ,"TRBSC2","STATUS_NF"						,"@!",15)				
	oBreak  := TRBreak():New(oSection1,oSection1:Cell("FILIAL"), "FILIAL",.F.)
	TRFunction():New(oSection1:Cell("VALOR_NOTA"),"Total ","SUM",oBreak,,"@E 99,999,999.99",,.F.,.T.)


	oReport:SetTotalInLine(.F.)
	oSection1:SetPageBreak(.F.) //Se salta pagina na primeira seção

Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	
 	Local cQuery    := ""
	Local cTpItem   := 0
	Local lPrim 	:= .T.
	Local docDev    :=""
	Local serDev    :=""
 	Private cCodEmp := SM0->M0_CODIGO

    cName := "Courier new"
    nWidth := 10
    nHeight := 10
    lBold := .F.
    lUnderline := .F.
    lItalic := .F.
    oTFont := TFont():New(cName,nWidth,nHeight,,lBold,,,,,lUnderline,lItalic)

cQuery:= " SELECT "
cQuery+= "	 C00_FILIAL FILIAL "
cQuery+= "	 ,C00_CNPJEM COD_EMITENTE "
cQuery+= "	 ,C00_NOEMIT NOME_EMITENTE "
cQuery+= "   ,A1_EST ESTADO "
cQuery+= "   ,A1_MUN CIDADE "
cQuery+= "	 ,C00_NUMNFE NUM_NOTA "
cQuery+= "	 ,C00_SERNFE SERIE_NOTA "
cQuery+= "	 ,C00_CHVNFE CHAVE_NOTA "
cQuery+= "	 ,C00_DTEMI  DATA_EMISSAO "
cQuery+= "	 ,C00_VLDOC VALOR_NOTA "
cQuery+= "	 ,IIF(ISNULL(F1_DOC,'')='','PENDENTE','DEVOLUÇÃO OK') STATUS_DEVOLUCAO "
cQuery+= "	 ,ISNULL(F1_DTDIGIT,'') DT_ENTRADA "
cQuery+= "	 ,RTRIM(ISNULL(CAST(CAST(C00_XXML AS VARBINARY(8000)) AS VARCHAR(8000)),'')) AS XML"
cQuery+= "   ,IIF (RTRIM(ISNULL(CAST(CAST(C00_XXML AS VARBINARY(8000)) AS VARCHAR(8000)),'')) LIKE '%<tpNF>1%','SAÍDA','ENTRADA') TIPO_NF"
cQuery+= "   , IIF (RTRIM(ISNULL(CAST(CAST(C00_XXML AS VARBINARY(8000)) AS VARCHAR(8000)),'')) LIKE '%<cStat>100%','AUTORIZADO','CANCELADO') STATUS_NF"
cQuery+= "	 FROM "+RETSQLNAME("C00")+" C00 (NOLOCK)"
cQuery+= "	 LEFT JOIN "+RETSQLNAME("SF1")+" SF1 (NOLOCK) ON SF1.D_E_L_E_T_='' AND RTRIM(F1_CHVNFE) = RTRIM(C00_CHVNFE) AND F1_FILIAL = C00_FILIAL "
cQuery+= "	 LEFT JOIN "+RETSQLNAME("SA1")+" SA1 ON SA1.D_E_L_E_T_='' AND A1_COD = C00_CNPJEM"
cQuery+= "	 WHERE "
cQuery+= "	 C00.D_E_L_E_T_='' "
cQuery+= "	 AND C00_XGEROU='X' "
cQuery+= "	 AND C00_FILIAL   BETWEEN '" + mv_par01 + "' AND '" + mv_par02+ "'"
cQuery+= "	 AND C00_DTEMI	  BETWEEN '" + dTos(mv_par03) + "' AND '" + dTos(mv_par04) + "' "
cQuery+= "	 AND C00_CNPJEM   BETWEEN '" + mv_par05 + "' AND '" + mv_par06+ "'"
If	mv_par07 == 1  // PENDENTE
cQuery += "  AND IIF(ISNULL(F1_DOC,'')='','PENDENTE','DEVOLUÇÃO OK') ='PENDENTE' "
Endif
If mv_par07 == 2  // DEVOLUÇÃO OK   
cQuery += " AND IIF(ISNULL(F1_DOC,'')<>'','DEVOLUÇÃO OK','PENDENTE') ='DEVOLUÇÃO OK' "
Endif
If	mv_par07 == 3  // AMBOS
Endif 




	IF Select("TRBSC2") <> 0
		DbSelectArea("TRBSC2")
		DbCloseArea()
	ENDIF

	MemoWrite("C:\excel\RCOMR100.sql", cQuery)

	TCQUERY cQuery NEW ALIAS "TRBSC2"

	dbSelectArea("TRBSC2")
	TRBSC2->(dbGoTop())

	oReport:SetMeter(TRBSC2->(LastRec()))

		oSection1:Init()
		oSection1:SetLinesBefore(1)
		oSection1:lPrintHeader := .T.
	While !TRBSC2->(Eof())

		docDev :=SUBSTR(TRBSC2->XML,at("refNFe",TRBSC2->XML)+32,9)
		serDev :=SUBSTR(TRBSC2->XML,at("refNFe",TRBSC2->XML)+29,3)

		If oReport:Cancel()
			Exit
		EndIf

		oReport:IncMeter()

		IncProc("Gerando dados")
		oSection1:lPrintHeader := .T.
		oSection1:Cell("FILIAL")					:SetValue(TRBSC2->FILIAL)
		oSection1:Cell("COD_EMITENTE")				:SetValue(TRBSC2->COD_EMITENTE)
		oSection1:Cell("NOME_EMITENTE")				:SetValue(TRBSC2->NOME_EMITENTE)
		oSection1:Cell("ESTADO")					:SetValue(TRBSC2->ESTADO)
		oSection1:Cell("CIDADE")					:SetValue(TRBSC2->CIDADE)
		oSection1:Cell("NUM_NOTA")					:SetValue(TRBSC2->NUM_NOTA)
		oSection1:Cell("SERIE_NOTA")				:SetValue(TRBSC2->SERIE_NOTA)		
		oSection1:Cell("CHAVE_NOTA")				:SetValue(TRBSC2->CHAVE_NOTA)	
		oSection1:Cell("DATA_EMISSAO")				:SetValue(DtoC(SToD(TRBSC2->DATA_EMISSAO)))
		oSection1:Cell("VALOR_NOTA")				:SetValue(TRBSC2->VALOR_NOTA)                                   
		oSection1:Cell("STATUS_DEVOLUCAO")			:SetValue(TRBSC2->STATUS_DEVOLUCAO)
		oSection1:Cell("DT_ENTRADA")				:SetValue(DtoC(SToD(TRBSC2->DT_ENTRADA)))
		oSection1:Cell("XML")						:SetValue(serDev+'/'+docDev)
		oSection1:Cell("CARGA")						:SetValue(Posicione("DAI",3,TRBSC2->FILIAL+docDev+serDev+TRBSC2->COD_EMITENTE,"DAI_COD"))
		oSection1:Cell("TIPO_NF")					:SetValue(TRBSC2->TIPO_NF)
		oSection1:Cell("STATUS_NF")					:SetValue(TRBSC2->STATUS_NF)		
		oSection1:lPrintHeader := .F.
	    oSection1:Printline()

	    oReport:IncMeter()		
		
//		cDTORIGI:= TRBSC2->TJ_DTORIGI
	   
//		While TRBSC2->( !Eof() .and. (TRBSC2->TJ_DTORIGI) == cDTORIGI )
			
//		IncProc("Totais")  
		
//		oSection2:Init()
//		oSection2:SetLinesBefore(1)	
//		oSection2:Cell("TEMPO_EST_TOTAL")		:SetValue(TRBSC2->TEMPO_EST_TOTAL)

 //       oSection2:lPrintHeader := .T. 
 //       oSection2:SetLinesBefore(1)	
//		oSection2:Printline()


	    TRBSC2->(dbSkip())
	Enddo
// enddo
 		oReport:ThinLine()

		oSection1:Finish()

Return

static function ajustaSx1(cPerg)
	putSx1(cPerg, "01", "De data Inicio  ?"	, "", "", "mv_ch1", "D",08,00,00, "G", "",   "", "", "", "mv_par01")
	putSx1(cPerg, "02", "Até data Inicio ?"	, "", "", "mv_ch2", "D",08,00,00, "G", "",   "", "", "", "mv_par02")  
	