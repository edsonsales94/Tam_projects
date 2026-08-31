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
USER FUNCTION RFINR006() 

	Local oReport 		:= nil
	Local cPerg			:="RFINR006"
	
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
   //oReport:SetLandscape(.T.)
   	oReport:SetPortrait()    
	oReport:SetTotalInLine(.T.)
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 07
	oReport:lBold := .F.
	
	oSection1:= TRSection():New(oReport, "Maquineta" , {"TRBSC2","SA1","ZAE"}, , .F., .T.)
    
    TRCell():New(oSection1,"ZAE_FILIAL"     ,"TRBSC2","Filial"               ,"@!",06,,,"right",,)	
    TRCell():New(oSection1,"ZAE_MAQUIN"     ,"TRBSC2","Maquineta"            ,"@!",14,,,"right",,)
	TRCell():New(oSection1,"ZAE_ESTAB"      ,"TRBSC2","Nº Estabel"	         ,"@!",14,,,"right",,)
	TRCell():New(oSection1,"ZAE_OPER"    	,"TRBSC2","Operadora"            ,"@!",10,,,"right",,)	
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
	If 	mv_par13 == 1	
   	//ANALITICO
	oSection2:= TRSection():New(oReport, "Titulos", {"TRBSC2","SE1","ZAE"},NIL , .F., .T.)
	oSection2:SetTotalInLine(.F.)    
	TRCell():New(oSection2,"ZAE_MAQUIN"   ,"TRBSC2","Maquineta"    		,"@!",14,,,"right",,)	
    TRCell():New(oSection2,"E1_PREFIXO"   ,"TRBSC2","Prefixo"    		,"@!",03,,,"right",,)
	TRCell():New(oSection2,"E1_NUM"       ,"TRBSC2","Titulo"	    	,"@!",09,,,"right",,)
	TRCell():New(oSection2,"E1_PARCELA"   ,"TRBSC2","Paracela"       	,"@!",03,,,"right",,) 
	TRCell():New(oSection2,"E1_NRDOC"     ,"TRBSC2","Nº Documento"    	,"@!",10,,,"right",,)  	                                                                                           
	TRCell():New(oSection2,"E1_TIPO"      ,"TRBSC2","Tipo"	         	,"@!",03,,,"right",,)  
	TRCell():New(oSection2,"E1_VALOR"     ,"TRBSC2","Valor Base"	    ,"@E 99,999,999.99",10,,,"right",,)   
	TRCell():New(oSection2,"E1_SALDO"     ,"TRBSC2","Saldo"             ,"@E 99,999,999.99",10,,,"right",,)
    TRCell():New(oSection2,"E1_EMISSAO"   ,"TRBSC2","Dt.Emissao."   	,"@!",10,,,"right",,)  
    else                                       
	//SINTETICO
	oSection2:= TRSection():New(oReport, "Titulos", {"TRBSC2","SE1","ZAE"},NIL , .F., .T.)
	oSection2:SetTotalInLine(.F.)    
	TRCell():New(oSection2,"ZAE_MAQUIN"   ,"TRBSC2","Maquineta"    		,"@!",14,,,"right",,)
    TRCell():New(oSection2,"VAL_PER"      ,"TRBSC2","Mês/Ano."      	,"@!",07,,,"right",,)  		
    TRCell():New(oSection2,"VAL_QTD"      ,"TRBSC2","Quantidade"    	,"@!",10,,,"right",,)
  	TRCell():New(oSection2,"VAL_VALOR"     ,"TRBSC2","Total Valor"	    ,"@E 99,999,999.99",10,,,"right",,)                              
	TRCell():New(oSection2,"VAL_SALDO"     ,"TRBSC2","Total Saldo"	    ,"@E 99,999,999.99",10,,,"right",,)  
    endif
    
	If 	mv_par13 == 1	
	oBreak  := TRBreak():New(oSection1,oSection1:Cell("ZAE_MAQUIN"), "Total",.F.)
	TRFunction():New(oSection2:Cell("E1_VALOR"),"Valor Total","SUM",oBreak,,"@E 99,999,999.99",,.F.,.T.)
	TRFunction():New(oSection2:Cell("E1_SALDO"),"Saldo Total","SUM",oBreak,,"@E 99,999,999.99",,.F.,.T.) 
	
	else
	oBreak  := TRBreak():New(oSection1,oSection1:Cell("ZAE_MAQUIN"), "Total",.F.)
	TRFunction():New(oSection2:Cell("VAL_VALOR"),"Valor Total","SUM",oBreak,,"@E 99,999,999.99",,.F.,.T.)
	TRFunction():New(oSection2:Cell("VAL_SALDO"),"Saldo Total","SUM",oBreak,,"@E 99,999,999.99",,.F.,.T.) 
    ENDIF
    
    //oBreak:SetpageBreak()
	oReport:SetTotalInLine(.T.)
   //	oSection1:SetPageBreak(.F.) //Se salta pagina na primeira seção
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
    
  
	        If 	mv_par13 == 1
	         //ANALITICO
			 cQuery := " SELECT ZAE_FILIAL, ZAE_CLIENT,ZAE_OPER,ZAE_ESTAB,ZAE_MAQUIN, RTRIM(A1_VEND) + ' - '+ A3_NOME AS VAL_VEND, RTRIM(A3_GEREN) AS VAL_GEREN, A1_NOME, A1_NREDUZ, A1_END,  A1_BAIRRO, A1_CEP, A1_EST, A1_MUN, A1_DDD, A1_TEL, A1_CONTATO, A1_EMAIL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_SALDO, E1_NRDOC, E1_XMAQUIN  "
			 cQuery += " FROM " + RETSQLNAME("SA1") + " SA1 "
			 cQuery += " INNER JOIN " + RETSQLNAME("ZAE") + " ZAE ON ZAE.D_E_L_E_T_='' AND A1_COD=ZAE_CLIENT AND ZAE_FILIAL BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' "  
		     cQuery += " INNER JOIN " + RETSQLNAME("SA3") + " SA3 ON SA3.D_E_L_E_T_='' AND A3_COD=A1_VEND "     
		     cQuery += " LEFT JOIN " + RETSQLNAME("SE1") + " SE1 ON SE1.D_E_L_E_T_='' AND E1_XMAQUIN=ZAE_MAQUIN AND E1_CLIENTE=ZAE_CLIENT AND ZAE_FILIAL=E1_FILIAL AND E1_PREFIXO IN ('CIE','RED') AND E1_TIPO='NCC' AND E1_EMISSAO BETWEEN '" + dTos(mv_par09) + "' AND '" + dTos(mv_par10) + "' " 
			 cQuery += " WHERE  SA1.D_E_L_E_T_='' "  
	     	 cQuery += " AND ZAE_FILIAL BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' " 
			 cQuery += " AND ZAE_CLIENT BETWEEN '"+ mv_par03 +"' AND '"+ mv_par04 +"' "	 
			 cQuery += " AND A1_VEND BETWEEN '"+ mv_par05 +"' AND '"+ mv_par06 +"' "
			 cQuery += " AND A3_GEREN BETWEEN '"+ mv_par07 +"' AND '"+ mv_par08 +"' "  
			 cQuery += " AND ZAE_OPER IN ('" + strtran (mv_par11, "/", "','") + "')" 
	 		 cQuery += " AND A1_EST NOT IN ('" + strtran (mv_par12, "/", "','") + "')" 			 	 
			 cQuery += " GROUP BY ZAE_FILIAL, ZAE_CLIENT, ZAE_OPER, ZAE_ESTAB, ZAE_MAQUIN, A1_VEND, A3_NOME, A3_GEREN, A1_VEND, A1_NOME, A1_NREDUZ, A1_END,  A1_BAIRRO, A1_EST, A1_CEP, A1_MUN, A1_DDD, A1_TEL, A1_CONTATO, A1_EMAIL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_SALDO, E1_NRDOC, E1_XMAQUIN  "
			 cQuery += " ORDER BY ZAE_FILIAL, ZAE_OPER, ZAE_CLIENT, A3_GEREN, A1_VEND, E1_EMISSAO "       
			else  
			 //SINTETICO
             cQuery := " SELECT ZAE_FILIAL, ZAE_CLIENT,ZAE_OPER,ZAE_ESTAB,ZAE_MAQUIN, RTRIM(A1_VEND) + ' - '+ A3_NOME AS VAL_VEND, RTRIM(A3_GEREN) AS VAL_GEREN, A1_NOME, A1_NREDUZ, A1_END,  A1_BAIRRO, A1_CEP, A1_EST, A1_MUN, A1_DDD, A1_TEL, A1_CONTATO, A1_EMAIL, SUBSTRING(E1_EMISSAO,5,2)+'/'+SUBSTRING(E1_EMISSAO,1,4) AS VAL_PER, COUNT(E1_PREFIXO) AS VAL_QTD, SUM(E1_VALOR) AS VAL_VALOR,  SUM(E1_SALDO) AS VAL_SALDO "
             cQuery += " FROM " + RETSQLNAME("SA1") + " SA1 "
             cQuery += " INNER JOIN " + RETSQLNAME("ZAE") + " ZAE ON ZAE.D_E_L_E_T_='' AND A1_COD=ZAE_CLIENT AND ZAE_FILIAL BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' "  
		     cQuery += " INNER JOIN " + RETSQLNAME("SA3") + " SA3 ON SA3.D_E_L_E_T_='' AND A3_COD=A1_VEND "     
		     cQuery += " LEFT JOIN " + RETSQLNAME("SE1") + " SE1 ON SE1.D_E_L_E_T_='' AND E1_XMAQUIN=ZAE_MAQUIN AND E1_CLIENTE=ZAE_CLIENT AND ZAE_FILIAL=E1_FILIAL AND E1_PREFIXO IN ('CIE','RED') AND E1_TIPO='NCC' AND E1_EMISSAO BETWEEN '" + dTos(mv_par09) + "' AND '" + dTos(mv_par10) + "' " 
			 cQuery += " WHERE  SA1.D_E_L_E_T_='' "  
	     	 cQuery += " AND ZAE_FILIAL BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' " 
			 cQuery += " AND ZAE_CLIENT BETWEEN '"+ mv_par03 +"' AND '"+ mv_par04 +"' "	 
			 cQuery += " AND A1_VEND BETWEEN '"+ mv_par05 +"' AND '"+ mv_par06 +"' "
			 cQuery += " AND A3_GEREN BETWEEN '"+ mv_par07 +"' AND '"+ mv_par08 +"' "  
			 cQuery += " AND ZAE_OPER IN ('" + strtran (mv_par11, "/", "','") + "')" 
	 		 cQuery += " AND A1_EST NOT IN ('" + strtran (mv_par12, "/", "','") + "')" 	
             cQuery += " GROUP BY ZAE_FILIAL, ZAE_CLIENT,ZAE_OPER,ZAE_ESTAB,ZAE_MAQUIN,A1_VEND,A3_NOME,A3_GEREN, A1_NOME, A1_NREDUZ, A1_END,  A1_BAIRRO, A1_CEP, A1_EST, A1_MUN, A1_DDD, A1_TEL, A1_CONTATO, A1_EMAIL, SUBSTRING(E1_EMISSAO,5,2)+'/'+SUBSTRING(E1_EMISSAO,1,4)   " 
             cQuery += " ORDER BY ZAE_FILIAL, ZAE_OPER, ZAE_CLIENT, A3_GEREN, A1_VEND, SUBSTRING(E1_EMISSAO,5,2)+'/'+SUBSTRING(E1_EMISSAO,1,4) "		 
            endif
   			MemoWrite("C:\excel\RFINR006.sql", cQuery)
			
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
		oSection1:Cell("ZAE_MAQUIN"):SetValue( TRBSC2->ZAE_MAQUIN)
		oSection1:Cell("ZAE_MAQUIN"):lVisible := .T.  
		oSection1:Cell("ZAE_ESTAB"):SetValue( TRBSC2->ZAE_ESTAB)
		oSection1:Cell("ZAE_ESTAB"):lVisible := .T.    
	    oSection1:Cell("ZAE_OPER"):SetValue(IIF(TRBSC2->ZAE_OPER=='C',"CIELO","REDECARD")) 
		oSection1:Cell("ZAE_OPER"):lVisible := .T. 
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
		cGrupo := TRBSC2->ZAE_MAQUIN
		While TRBSC2->( !Eof() .and. (TRBSC2->ZAE_MAQUIN) == cGrupo)
		
				IncProc("Imprimindo Relatório ")
	            If 	mv_par13 == 1
	            //Analitico
				nTotPrev += TRBSC2->E1_SALDO   
				oSection2:Cell("ZAE_MAQUIN"):SetValue(TRBSC2->ZAE_MAQUIN)
				oSection2:Cell("E1_PREFIXO"):SetValue(TRBSC2->E1_PREFIXO)
				oSection2:Cell("E1_NUM"):SetValue(TRBSC2->E1_NUM) 
     			oSection2:Cell("E1_PARCELA"):SetValue(TRBSC2->E1_PARCELA)
     			oSection2:Cell("E1_NRDOC"):SetValue(TRBSC2->E1_NRDOC) 
			    oSection2:Cell("E1_TIPO"):SetValue(TRBSC2->E1_TIPO)  
				oSection2:Cell("E1_VALOR"):SetValue(TRBSC2->E1_VALOR)  
				oSection2:Cell("E1_SALDO"):SetValue(TRBSC2->E1_SALDO) 
				oSection2:Cell("E1_EMISSAO"):SetValue(DtoC(SToD(TRBSC2->E1_EMISSAO)))		   
	            else
	            //Sintetico      
	         	nTotPrev += TRBSC2->VAL_SALDO   
				oSection2:Cell("ZAE_MAQUIN"):SetValue(TRBSC2->ZAE_MAQUIN)
				oSection2:Cell("VAL_PER"):SetValue(TRBSC2->VAL_PER)
				oSection2:Cell("VAL_QTD"):SetValue(TRBSC2->VAL_QTD) 
     			oSection2:Cell("VAL_VALOR"):SetValue(TRBSC2->VAL_VALOR)
     			oSection2:Cell("VAL_SALDO"):SetValue(TRBSC2->VAL_SALDO) 
			    endif     
	            oSection2:Printline()
	        	TRBSC2->(dbSkip())	 			
	 			
	 		EndDo				
	//Enddo	              
	
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		oSection1:Finish()
	Enddo
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
	putSx1(cPerg, "12", "Exceto Estado      ?"	, "", "", "mv_chC", "C",30,00,00, "G", "",   "", "", "", "mv_par12")
	putSx1(cPerg, "13", "Analitico/Sintetico?"	, "", "", "mv_chD", "N",01,00,02, "C", "",   "", "", "", "mv_par13", "Analitico", "", "",  "", "Sintetico", "")

 return