#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH" 
#INCLUDE "REPORT.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ RFINR006  ºAutor  ³ Alexandre Manini   º Data ³  23/02/2016º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Vendas por Maquineta                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                               			  ¹±±
±±ºUso       ³                    	                                      º±±
±±ºUso       ³                                        					  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER FUNCTION RFINR011() 

	Local oReport 		:= nil
	Local cPerg			:="RFINR011"
	
  	AjustaSX1(cPerg)	
	Pergunte(cPerg,.F.)	          
	
	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport  := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak   := Nil
	Local oBreak2  := Nil
	Local oFunction:= Nil

	oReport := TReport():New(cNome,"Vendas por Maquineta",cNome,{|oReport| ReportPrint(oReport)},"Vendas por Maquineta")
    oReport:SetLandscape(.T.)
   //oReport:SetPortrait()    
	oReport:SetTotalInLine(.T.)
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 07
	oReport:lBold := .F.
	
	oSection1:= TRSection():New(oReport, "Maquineta" , {"TRBSC2","SA1","ZAE"}, , .F., .T.)
   
    TRCell():New(oSection1,"ZAE_FILIAL"     ,"TRBSC2","Filial"               ,"@!",06,,,"right",,)	
   	TRCell():New(oSection1,"ZAE_CLIENT"    	,"TRBSC2","Cliente"	             ,"@!",14,,,"right",,)
	TRCell():New(oSection1,"A1_NOME"    	,"TRBSC2","Nome"    	         ,"@!",60,,,"right",,)
	TRCell():New(oSection1,"A1_NREDUZ"     	,"TRBSC2","Fantasia"	         ,"@!",30,,,"right",,)   
 	TRCell():New(oSection1,"A1_END"         ,"TRBSC2","Endereco"	         ,"@!",30,,,"right",,) 
	TRCell():New(oSection1,"A1_BAIRRO"      ,"TRBSC2","Bairro"	             ,"@!",14,,,"right",,) 
	TRCell():New(oSection1,"A1_CEP"      	,"TRBSC2","CEP"	                 ,"@!",08,,,"right",,)
	TRCell():New(oSection1,"A1_EST"     	,"TRBSC2","UF"	                 ,"@!",02,,,"right",,)
	TRCell():New(oSection1,"A1_MUN"     	,"TRBSC2","Municipio"	         ,"@!",30,,,"right",,)
	TRCell():New(oSection1,"VAL_VEND"      	,"TRBSC2","Vendedor"             ,"@!",45,,,"right",,)
	TRCell():New(oSection1,"VAL_GEREN"     	,"TRBSC2","Gerente"              ,"@!",45,,,"right",,)
	TRCell():New(oSection1,"A1_DDD"      	,"TRBSC2","DDD"	                 ,"@!",03,,,"right",,)
	TRCell():New(oSection1,"A1_TEL"      	,"TRBSC2","Telefone"             ,"@!",10,,,"right",,) 
	TRCell():New(oSection1,"A1_CONTATO"    	,"TRBSC2","Contato"	             ,"@!",20,,,"right",,)
	TRCell():New(oSection1,"A1_EMAIL"     	,"TRBSC2","E-mail"	             ,"@!",60,,,"right",,)
		
   	
	oSection2:= TRSection():New(oReport, "Titulos", {"TRBSC2","SE1"},NIL , .F., .T.)
	oSection2:SetTotalInLine(.F.)  
	
	
	
	TRCell():New(oSection2,"VAL_PREFIXO"  ,"TRBSC2","Prf.Comp"          ,"@!",03,,,"right",,) 
    TRCell():New(oSection2,"VAL_NUMERO"   ,"TRBSC2","Titulo.Comp"      	,"@!",14,,,"right",,)                     
	TRCell():New(oSection2,"VAL_PARCELA"  ,"TRBSC2","Pc.Comp"       	,"@!",03,,,"right",,)	                                                                          
	TRCell():New(oSection2,"VAL_TIPO"     ,"TRBSC2","Tp.Comp"        	,"@!",03,,,"right",,)  
	TRCell():New(oSection2,"E5_DATA"      ,"TRBSC2","Data da Baixa"     ,"@!",08,,,"right",,) 
	TRCell():New(oSection2,"VAL_VALOR"    ,"TRBSC2","Vlr Original"      ,"@E 99,999,999.99",10,,,"right",,) 
  	TRCell():New(oSection2,"VAL_SALDO"    ,"TRBSC2","Vlr Saldo"         ,"@E 99,999,999.99",10,,,"right",,)    
	TRCell():New(oSection2,"E5_VALOR"     ,"TRBSC2","Vlr Baixa"         ,"@E 99,999,999.99",10,,,"right",,)   
	TRCell():New(oSection2,"E5_HISTOR"    ,"TRBSC2","Histórico Baixa"   ,"@!",15,,,"right",,)
	TRCell():New(oSection2,"COLUNA"       ,"TRBSC2","|"          		,"@!",01,,,"right",,)  
    TRCell():New(oSection2,"E1_XMAQUIN"   ,"TRBSC2","Maquineta"    		,"@!",09,,,"right",,)
    TRCell():New(oSection2,"E1_PREFIXO"   ,"TRBSC2","Prefixo"    		,"@!",03,,,"right",,)
	TRCell():New(oSection2,"E1_NUM"       ,"TRBSC2","Titulo"	    	,"@!",09,,,"right",,)
	TRCell():New(oSection2,"E1_PARCELA"   ,"TRBSC2","Paracela"       	,"@!",03,,,"right",,) 
	TRCell():New(oSection2,"E1_NRDOC"     ,"TRBSC2","Nº Documento"    	,"@!",10,,,"right",,)  	                                                                                           
	TRCell():New(oSection2,"E1_TIPO"      ,"TRBSC2","Tipo"	         	,"@!",03,,,"right",,)  
	TRCell():New(oSection2,"E1_VALOR"     ,"TRBSC2","Valor Base"	    ,"@E 99,999,999.99",10,,,"right",,)   
	TRCell():New(oSection2,"E1_SALDO"     ,"TRBSC2","Saldo"             ,"@E 99,999,999.99",10,,,"right",,)
    TRCell():New(oSection2,"E1_EMISSAO"   ,"TRBSC2","Dt.Emissao"     	,"@!",08,,,"right",,)  
   
	

	oBreak  := TRBreak():New(oSection1,oSection1:Cell("ZAE_CLIENT"), "Total",.F.) 
  //  TRFunction():New(oSection2:Cell("E1_VALOR"),"Valor Total","",oBreak,,"@E 99,999,999.99",,.F.,.T.)
    TRFunction():New(oSection2:Cell("E5_VALOR"),"Valor Total","SUM",oBreak,,"@E 99,999,999.99",,.F.,.T.)
   //	TRFunction():New(oSection2:Cell("E1_SALDO"),"Saldo Total","SUM",oBreak,,"@E 99,999,999.99",,.F.,.T.)
    //oBreak:SetpageBreak()
	oReport:SetTotalInLine(.T.)
	oSection1:SetPageBreak() //Se salta pagina na primeira seção
	oSection1:SetTotalText(" ")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local cTpItem   := 0
	Local lPrim 	:= .T. 
	Local nTotPrev  := 0	    

	Private cCodEmp := SM0->M0_CODIGO

    cName := "Courier new"
    nWidth := 10
    nHeight := 10
    lBold := .F.
    lUnderline := .F.
    lItalic := .F.
    oTFont := TFont():New(cName,nWidth,nHeight,,lBold,,,,,lUnderline,lItalic)
	
	
			 cQuery := " SELECT ZAE_FILIAL, ZAE_CLIENT,ZAE_MAQUIN, RTRIM(A1_VEND) + ' - '+ A3_NOME AS VAL_VEND, RTRIM(A3_GEREN) AS VAL_GEREN, A1_NOME, A1_NREDUZ, A1_END,  A1_BAIRRO, A1_CEP, A1_EST, A1_MUN, A1_DDD, A1_TEL, A1_CONTATO, A1_EMAIL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_EMISSAO, SE1.E1_VALOR, SE1.E1_SALDO, SE1.E1_NRDOC, SE1.E1_XMAQUIN, SUBSTRING(E5_DOCUMEN,1,3) AS VAL_PREFIXO, SUBSTRING(E5_DOCUMEN,4,9) AS VAL_NUMERO, SUBSTRING(E5_DOCUMEN,13,2) AS VAL_PARCELA, SUBSTRING(E5_DOCUMEN,16,2) AS VAL_TIPO, E5_HISTOR, E5_DATA, E5_VALOR, SE1X.E1_VALOR AS VAL_VALOR, SE1X.E1_SALDO AS VAL_SALDO  "
			 cQuery += " FROM " + RETSQLNAME("SA1") + " SA1 "
			 cQuery += " INNER JOIN " + RETSQLNAME("ZAE") + " ZAE ON ZAE.D_E_L_E_T_='' AND A1_COD=ZAE_CLIENT AND ZAE_FILIAL BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' "  
		     cQuery += " INNER JOIN " + RETSQLNAME("SA3") + " SA3 ON SA3.D_E_L_E_T_='' AND A3_COD=A1_VEND "     
		     cQuery += " INNER JOIN " + RETSQLNAME("SE1") + " SE1 ON SE1.D_E_L_E_T_='' AND SE1.E1_XMAQUIN=ZAE_MAQUIN AND SE1.E1_CLIENTE=ZAE_CLIENT AND ZAE_FILIAL=SE1.E1_FILIAL AND SE1.E1_PREFIXO IN ('CIE','RED') AND SE1.E1_TIPO='NCC' AND SE1.E1_VALOR>0 AND SE1.E1_EMISSAO BETWEEN '" + dTos(mv_par09) + "' AND '" + dTos(mv_par10) + "' "                  
		     cQuery += " INNER JOIN " + RETSQLNAME("SE5") + " SE5 ON SE5.D_E_L_E_T_='' AND SE5.E5_FILIAL=E1_FILIAL AND SE5.E5_PREFIXO=E1_PREFIXO AND SE5.E5_NUMERO=E1_NUM AND SE5.E5_PARCELA=E1_PARCELA "      
		     cQuery += " INNER JOIN " + RETSQLNAME("SE1") + " SE1X ON SE1X.D_E_L_E_T_='' AND SE1X.E1_FILIAL=E5_FILIAL AND SE1X.E1_PREFIXO=SUBSTRING(E5_DOCUMEN,1,3)AND SE1X.E1_NUM= SUBSTRING(E5_DOCUMEN,4,9) AND SE1X.E1_PARCELA= SUBSTRING(E5_DOCUMEN,13,2) 
		     cQuery += " WHERE  SA1.D_E_L_E_T_='' "  
	       //cQuery += " AND E1_PREFIXO IN ('CIE','RED') "      
		    // cQuery += " AND SE5.E5_HISTOR NOT LIKE ('%CANC%')  
	       //cQuery += " AND E1_VALOR>'0' "  	 
			 cQuery += " AND ZAE_FILIAL BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' " 
			 cQuery += " AND ZAE_CLIENT BETWEEN '"+ mv_par03 +"' AND '"+ mv_par04 +"' "	 
			 cQuery += " AND A1_VEND BETWEEN '"+ mv_par05 +"' AND '"+ mv_par06 +"' "
			 cQuery += " AND A3_GEREN BETWEEN '"+ mv_par07 +"' AND '"+ mv_par08 +"' "  
		   //cQuery += " AND E1_EMISSAO BETWEEN '" + dTos(mv_par09) + "' AND '" + dTos(mv_par10) + "' "	
			 cQuery += " AND ZAE_OPER IN ('" + strtran (mv_par11, "/", "','") + "')" 
	 		 cQuery += " AND A1_EST NOT IN ('" + strtran (mv_par12, "/", "','") + "')" 			 	 
			 cQuery += " GROUP BY ZAE_FILIAL, ZAE_CLIENT, ZAE_MAQUIN, A1_VEND, A3_NOME, A3_GEREN, A1_VEND, A1_NOME, A1_NREDUZ, A1_END,  A1_BAIRRO, A1_EST, A1_CEP, A1_MUN, A1_DDD, A1_TEL, A1_CONTATO, A1_EMAIL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_EMISSAO, SE1.E1_VALOR, SE1.E1_SALDO, SE1.E1_NRDOC, SE1.E1_XMAQUIN, SUBSTRING(E5_DOCUMEN,1,3), SUBSTRING(E5_DOCUMEN,4,9), SUBSTRING(E5_DOCUMEN,13,2), SUBSTRING(E5_DOCUMEN,16,2), E5_HISTOR, E5_DATA, E5_VALOR, SE1X.E1_VALOR, SE1X.E1_SALDO  "
			 cQuery += " ORDER BY ZAE_FILIAL, ZAE_CLIENT, A3_GEREN, A1_VEND , E5_DATA, SUBSTRING(E5_DOCUMEN,1,3), SUBSTRING(E5_DOCUMEN,4,9), SUBSTRING(E5_DOCUMEN,13,2), SUBSTRING(E5_DOCUMEN,16,2)"       
			 		 

   			MemoWrite("C:\excel\RFINR011.sql", cQuery)
						
	IF Select("TRBSC2") <> 0
		DbSelectArea("TRBSC2")
		DbCloseArea()
	ENDIF
	
	TCQUERY cQuery NEW ALIAS "TRBSC2"	
	
	dbSelectArea("TRBSC2")
	TRBSC2->(dbGoTop())
	
	oReport:SetMeter(TRBSC2->(LastRec()))	

	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf

		oReport:IncMeter()

		IncProc("Imprimindo Cabeçalho do Cliente")

		oSection1:Init()
		oSection1:SetLinesBefore(1)

		oSection1:Cell("ZAE_FILIAL"):SetValue( TRBSC2->ZAE_FILIAL)
		oSection1:Cell("ZAE_FILIAL"):lVisible := .T. 
	  	oSection1:Cell("A1_NOME"):SetValue( TRBSC2->A1_NOME)
		oSection1:Cell("A1_NOME"):lVisible := .T.
		oSection1:Cell("A1_NREDUZ"):SetValue( TRBSC2->A1_NREDUZ)
		oSection1:Cell("A1_NREDUZ"):lVisible := .T.    
		oSection1:Cell("VAL_VEND"):SetValue( TRBSC2->VAL_VEND)
		oSection1:Cell("VAL_VEND"):lVisible := .T.
		oSection1:Cell("VAL_GEREN"):SetValue(TRBSC2->VAL_GEREN + ' - ' + Posicione("SA3",1,xFilial("SA3") + TRBSC2->VAL_GEREN,"A3_NOME"))
		oSection1:Cell("VAL_GEREN"):lVisible := .T.     
	   	oSection1:Cell("A1_END"):SetValue( TRBSC2->A1_END)
		oSection1:Cell("A1_END"):lVisible := .T.  
		oSection1:Cell("A1_BAIRRO"):SetValue( TRBSC2->A1_BAIRRO)
		oSection1:Cell("A1_BAIRRO"):lVisible := .T.
		oSection1:Cell("A1_CEP"):SetValue( TRBSC2->A1_CEP)
		oSection1:Cell("A1_CEP"):lVisible := .T. 
		oSection1:Cell("A1_EST"):SetValue( TRBSC2->A1_EST)
		oSection1:Cell("A1_EST"):lVisible := .T.
		oSection1:Cell("A1_MUN"):SetValue( TRBSC2->A1_MUN)
		oSection1:Cell("A1_MUN"):lVisible := .T. 
		oSection1:Cell("A1_DDD"):SetValue( TRBSC2->A1_DDD)
		oSection1:Cell("A1_DDD"):lVisible := .T.     
		oSection1:Cell("A1_TEL"):SetValue( TRBSC2->A1_TEL)
		oSection1:Cell("A1_TEL"):lVisible := .T. 
    	oSection1:Cell("A1_CONTATO"):SetValue( TRBSC2->A1_CONTATO)
		oSection1:Cell("A1_CONTATO"):lVisible := .T. 
		oSection1:Cell("A1_EMAIL"):SetValue( TRBSC2->A1_EMAIL)
		oSection1:Cell("A1_EMAIL"):lVisible := .T. 
		oSection1:lPrintHeader := .T.      
		oSection2:lPrintHeader := .T.  
		oSection1:Printline()
        

		oSection2:init()
		oSection2:SetLinesBefore(1)		
		nTotPrev 	:= 0
		oReport:IncMeter()	
		cGrupo := TRBSC2->ZAE_CLIENT
		While TRBSC2->( !Eof() .and. (TRBSC2->ZAE_CLIENT) == cGrupo)
		
			
				IncProc("Imprimindo Relatório ")
	
				nTotPrev += TRBSC2->E1_SALDO   
	            oSection2:Cell("E1_EMISSAO"):SetValue(DtoC(SToD(TRBSC2->E1_EMISSAO)))		   
	            oSection2:Cell("VAL_PREFIXO"):SetValue(TRBSC2->VAL_PREFIXO)
				oSection2:Cell("VAL_NUMERO"):SetValue(IIF(TRBSC2->VAL_NUMERO <>'',TRBSC2->VAL_NUMERO,"CREDITO DEVOLVIDO")) 
     			oSection2:Cell("VAL_PARCELA"):SetValue(TRBSC2->VAL_PARCELA) 
     			oSection2:Cell("VAL_TIPO"):SetValue(TRBSC2->VAL_TIPO)  
     			oSection2:Cell("VAL_VALOR"):SetValue(TRBSC2->VAL_VALOR)
     		   	oSection2:Cell("VAL_SALDO"):SetValue(TRBSC2->VAL_SALDO)
     			oSection2:Cell("E5_VALOR"):SetValue(TRBSC2->E5_VALOR) 
				oSection2:Cell("E5_DATA"):SetValue(DtoC(SToD(TRBSC2->E5_DATA)))      			
     			oSection2:Cell("E5_HISTOR"):SetValue(TRBSC2->E5_HISTOR)   
     			oSection2:Cell("COLUNA"):SetValue("|")	
     			oSection2:Cell("E1_XMAQUIN"):SetValue(TRBSC2->E1_XMAQUIN)	
				oSection2:Cell("E1_PREFIXO"):SetValue(TRBSC2->E1_PREFIXO)
				oSection2:Cell("E1_NUM"):SetValue(TRBSC2->E1_NUM) 
     		   //	oSection2:Cell("E1_PARCELA"):SetValue(TRBSC2->E1_PARCELA)
     			oSection2:Cell("E1_NRDOC"):SetValue(TRBSC2->E1_NRDOC) 
			    oSection2:Cell("E1_TIPO"):SetValue(TRBSC2->E1_TIPO)  
				oSection2:Cell("E1_VALOR"):SetValue(TRBSC2->E1_VALOR)  
				oSection2:Cell("E1_SALDO"):SetValue(TRBSC2->E1_SALDO) 

			   
	         
	            oSection2:Printline()
	
	 			TRBSC2->(dbSkip())	 			
	 						               
			
	 		EndDo				
	Enddo	              
	
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		oSection1:Finish()
	//Enddo
Return

static function ajustaSx1(cPerg)       
    putSx1(cPerg, "01", "De Filial          ?"  , "", "", "mv_ch1", "C",06,00,00, "G", "","SM0", "", "", "mv_par01")
	putSx1(cPerg, "02", "Até Filial         ?"  , "", "", "mv_ch2", "C",06,00,00, "G", "","SM0", "", "", "mv_par02") 
    putSx1(cPerg, "03", "De Cliente         ?"  , "", "", "mv_ch3", "C",14,00,00, "G", "","SA1", "", "", "mv_par03")
	putSx1(cPerg, "04", "Até Cliente        ?"  , "", "", "mv_ch4", "C",14,00,00, "G", "","SA1", "", "", "mv_par04")           
  	putSx1(cPerg, "05", "De Vendedor        ?"  , "", "", "mv_ch5", "C",06,00,00, "G", "","SA3", "", "", "mv_par05")   
	putSx1(cPerg, "06", "Até Vendedor       ?"  , "", "", "mv_ch6", "C",06,00,00, "G", "","SA3", "", "", "mv_par06")  
	putSx1(cPerg, "07", "De Gerente         ?"  , "", "", "mv_ch7", "C",06,00,00, "G", "","SA3", "", "", "mv_par07") 	
	putSx1(cPerg, "08", "Até Gerente        ?"  , "", "", "mv_ch8", "C",06,00,00, "G", "","SA3", "", "", "mv_par08") 	
	putSx1(cPerg, "09", "De Emissão         ?"	, "", "", "mv_ch9", "D",08,00,00, "G", "",   "", "", "", "mv_par09")
	putSx1(cPerg, "10", "Até Emissão        ?"	, "", "", "mv_chA", "D",08,00,00, "G", "",   "", "", "", "mv_par10")  
    putSx1(cPerg, "11", "Operadora          ?"	, "", "", "mv_chB", "C",03,00,00, "G", "",   "", "", "", "mv_par11")
	putSx1(cPerg, "12", "Estado             ?"	, "", "", "mv_chC", "C",30,00,00, "G", "",   "", "", "", "mv_par12")

 return