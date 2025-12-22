#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.ch'  
#include 'font.ch'
#include 'RPTDEF.CH'    
#include 'TBICONN.CH'


user function HLRPCP01()

	If ValidPerg()
		imprRel() //Processa({|| imprRel() }, "Aguarde...", "Imprimindo...",.F.)
	EndIf  

return

Static Function imprRel()

	//Local nQtdEtq			:= 0
	Local nI				:= 0
	Local nG				:= 0

  	Private oDLG 			:= MSDIALOG():Create() //luciano
	Private nLin			:= 0		
	Private nInicio			:= 0060
	Private aColImp			:= {}
	Private oPrinter 		:= FWMSPrinter():New("HLRPCP01")
 	Private nLimiteVer		:= oPrinter:nVertRes()//2350//3370
 	Private nLimiteHoz		:= oPrinter:nHorzRes()-010//2350//3370			 
	Private cAlOP			:= GetNextAlias()
	Private oQrCode
	   
	Private nWidth			:= 290 //200    //alteraÃ§Ã£o Luciano - 28-03-2019
	Private nHeight			:= 210 //200    //alteraÃ§Ã£o Luciano - 28-03-2019
	Private oFont08 		:= TFont():New("Arial", 08, 08,, .F.,,,,, .F., .F.)
	Private oFont08N 		:= TFont():New("Arial", 08, 08,, .T.,,,,, .F., .F.)
	Private oFont09 		:= TFont():New("Arial", 09, 09,, .F.,,,,, .F., .F.)
	Private oFont09N 		:= TFont():New("Arial", 09, 09,, .T.,,,,, .F., .F.)
	Private oFont10 		:= TFont():New("Arial", 10, 10,, .F.,,,,, .F., .F.)
	Private oFont10N 		:= TFont():New("Arial", 10, 10,, .T.,,,,, .F., .F.)
	Private oFont11 		:= TFont():New("Arial", 11, 11,, .F.,,,,, .F., .F.)
	Private oFont11N 		:= TFont():New("Arial", 11, 11,, .T.,,,,, .F., .F.)
	Private oFont12 		:= TFont():New("Arial", 12, 12,, .F.,,,,, .F., .F.)
	Private oFont12N 		:= TFont():New("Arial", 12, 12,, .T.,,,,, .F., .F.)
	Private oFont14N 		:= TFont():New("Arial", 14, 14,, .T.,,,,, .F., .F.)
	Private oFont14 		:= TFont():New("Arial",,14,,.F.,,,,,.F.,.F.)
	Private oFont16 		:= TFont():New("Arial",,16,,.F.,,,,,.F.,.F.)
	Private oFont16N 		:= TFont():New("Arial", 16, 16,, .T.,,,,, .F., .F.)
	Private oFont16NI 		:= TFont():New("Arial", 16, 16,, .T.,,,,, .F., .T.)
	Private oFont18 		:= TFont():New("Arial", 18, 18,, .F.,,,,, .F., .F.)
	Private oFont18N 		:= TFont():New("Arial", 18, 18,, .T.,,,,, .F., .F.)
	Private oFont20N 		:= TFont():New("Arial", 20, 20,, .T.,,,,, .F., .F.)
	Private oFont24N 		:= TFont():New("Arial", 24, 24,, .T.,,,,, .F., .F.)
	
   	DEFINE MSDIALOG oDlg TITLE "Etiquetas ExpediÃ§Ã£o" FROM 0,0 TO 400,800 PIXEL

	If allTrim(oPrinter:cPrinter) != ""
		
		nTamCol := nLimiteHoz/20								//Colunas (etiquetas) -> corresponde a linha 58
		
		For nI := 1 To 20                                      
			aAdd(aColImp, nI * nTamCol)
		Next nI
		
		nTotReg := buscaDados()
		
		ProcRegua(nTotReg)
		
		(cAlOP)->(DbGoTop())
		
		nPosAtu := 1		
		nLin 	:= 005
		
		oPrinter:StartPage()
		
		While (cAlOP)->(!Eof())		
								
			IncProc("Gerando arquivo!")
			
			nQtdOP := Ceiling((cAlOP)->C2_QUANT/(cAlOP)->B1_QE)		
						
			For nG := 1 to nQtdOP
			
				If mod(nPosAtu,2) <> 0 //imprime lado direito
					//oPrinter:Say(nLin,aColImp[1],str(nG)+"/"+str(nQtdOP),oFont14N)
					impDados(005,nLin,nG,nQtdOP)
				Else //imprime lado esquerdo
					impDados(aColImp[11]-20,nLin,nG,nQtdOP)						//LL ACOLIMP valor 20 desloca a etiqueta para Ã  direita da pÃ¡gina
					nLin += 1050 //990    													//ESPAÃ‡AMENTO ENTRE ETIQUETAS (LL)
					//oPrinter:Say(nLin,aColImp[11],str(nG)+"/"+str(nQtdOP),oFont14N)				
					If mod(nPosAtu,6) == 0     										//QUANTIDADE DE ETIQUETAS POR PAGINA - VALOR 0 NAO ALTERA(LL) 
						oPrinter:EndPage()						
						oPrinter:StartPage()
						nLin := 010														//L
					EndIf
				EndIf	
				
				nPosAtu++		
					
			Next			

			(cAlOP)->(DbSkip())
			
		EndDo
			
		oPrinter:EndPage()
		
		(cAlOP)->(DbCloseArea())
		
		oPrinter:Preview()
		
		Ms_Flush()
	
	EndIf

Return

Static Function impDados(nPosVert,nLinAtu,nG,nQtdOP,cQtd)

	Local cSequencia 	:= allTrim(str(nG))+"/"+allTrim(str(nQtdOP))
//	Local nRest			:=	0
	Local nQtdResto		:= (cAlOP)->C2_QUANT - (Int((cAlOP)->C2_QUANT / (cAlOP)->B1_QE) * (cAlOP)->B1_QE)
	//Local cCodBar 	:= (cAlOP)->B1_CODMATR+(cAlOP)->C2_PRODUTO+dToc(stod((cAlOP)->C2_DATPRF))+(cAlOP)->C2_NUM + "(" + allTrim(cValtoChar((cAlOP)->C2_QUANT))+ ")" +cSequencia  
	Local cCodBar 		:= ""
	//Local cCodBar 		:= (cAlOP)->B1_CODMATR+(cAlOP)->C2_PRODUTO+dToc(stod((cAlOP)->C2_DATPRF))+(cAlOP)->C2_NUM + "(" + allTrim(cValtoChar(nQtdResto))+ "]" +cSequencia  // add Luciano 24-07
	
	
	//box
	nLinAtu += 100												//DISTANCIA ENTRE ETIQUETAS EM ALTURA
   	
   	oPrinter:Box(nLinAtu,nPosVert,nLinAtu+800,nPosVert+1080)    
   
	//linhas verticais
   // oPrinter:line(nLinAtu,nPosVert+400,nLinAtu+480,nPosVert+400)   
   // oPrinter:line(nLinAtu+240,nPosVert+800,nLinAtu+480,nPosVert+800)
   // oPrinter:line(nLinAtu+320,nPosVert+800,nLinAtu+320,nPosVert+400)
   // oPrinter:line(nLinAtu+400,nPosVert+800,nLinAtu+400,nPosVert+400)
   // oPrinter:line(nLinAtu+480,nPosVert+800,nLinAtu+480,nPosVert+400)
   // oPrinter:line(nLinAtu+560,nPosVert+800,nLinAtu+560,nPosVert+800)
   // oPrinter:line(nLinAtu+640,nPosVert+800,nLinAtu+640,nPosVert+800)
	
	//linhas horizontais
	//oPrinter:line(nLinAtu+080,nPosVert,nLinAtu+080,nPosVert+1100) //DESCRICAO
	//oPrinter:line(nLinAtu+160,nPosVert,nLinAtu+160,nPosVert+1180) //CODIGO HLS
	//oPrinter:line(nLinAtu+240,nPosVert,nLinAtu+240,nPosVert+1180) //CÃ“DIGO CLIENTE
	//oPrinter:line(nLinAtu+320,nPosVert,nLinAtu+320,nPosVert+1180) //DATA DA PRODUCAO
	//oPrinter:line(nLinAtu+400,nPosVert,nLinAtu+400,nPosVert+400) //QTD
	//oPrinter:line(nLinAtu+480,nPosVert,nLinAtu+480,nPosVert+400) //SEQ
	//oPrinter:line(nLinAtu+560,nPosVert,nLinAtu+560,nPosVert+800) //LOTE 
	//oPrinter:line(nLinAtu+640,nPosVert,nLinAtu+640,nPosVert+800) //RESP
	
	nLinAtu += 050
	oPrinter:say(nLinAtu+005,nPosVert+015,"DESCRIÇÃO",oFont14)   
	oPrinter:say(nLinAtu+005,nPosVert+415,(cAlOP)->B1_DESCHL,oFont16N)
	nLinAtu += 080
	oPrinter:say(nLinAtu+005,nPosVert+015,"CÓDIGO",oFont14) 
	oPrinter:say(nLinAtu+005,nPosVert+415,(cAlOP)->C2_PRODUTO,oFont16N)
	nLinAtu += 080
	oPrinter:say(nLinAtu+005,nPosVert+015,"CÓDIGO CLIENTE",oFont14)
	oPrinter:say(nLinAtu+005,nPosVert+415,(cAlOP)->B1_CODMATR,oFont18N)	
	nLinAtu += 080
	oPrinter:say(nLinAtu+005,nPosVert+015,"DATA DA ENTREGA",oFont14)
	oPrinter:say(nLinAtu+005,nPosVert+415,dToc(stod((cAlOP)->C2_DATPRF)),oFont20N)
	//nLinAtu += 080
	oPrinter:say(nLinAtu+005,nPosVert+715,"NºOP",oFont14)
	oPrinter:say(nLinAtu+005,nPosVert+830,(cAlOP)->C2_NUM,oFont16N)
	nLinAtu += 080
	oPrinter:say(nLinAtu+005,nPosVert+015,"QTD.",oFont14)
	//oPrinter:say(nLinAtu+005,nPosVert+115,allTrim(cValtoChar((cAlOP)->C2_QUANT)),oFont16N)
	
	If nG == nQtdOP .And. nQtdResto > 0
	
	cCodBar := (cAlOP)->B1_CODMATR+(cAlOP)->C2_PRODUTO+dToc(stod((cAlOP)->C2_DATPRF))+(cAlOP)->C2_NUM + "\" + allTrim(cValtoChar(nQtdResto))+ "]" +cSequencia 

		oPrinter:say(nLinAtu+005,nPosVert+115,allTrim(cValtoChar(nQtdResto)),oFont24N) //add Luciano 24-07-2019		
	
	Else
		
		cCodBar := (cAlOP)->B1_CODMATR+(cAlOP)->C2_PRODUTO+dToc(stod((cAlOP)->C2_DATPRF))+(cAlOP)->C2_NUM + "\" + allTrim(cValtoChar((cAlOP)->B1_QE))+ "]" +cSequencia 
		
		oPrinter:say(nLinAtu+005,nPosVert+115,allTrim(cValtoChar((cAlOP)->B1_QE)),oFont24N) //add Luciano 24-07-2019
	
	EndIf
	
	//oPrinter:say(nLinAtu+005,nPosVert+115,cQtdop,oFont16N)  
	nLinAtu += 080
	oPrinter:say(nLinAtu+005,nPosVert+015,"SEQ.",oFont14)
	oPrinter:say(nLinAtu+005,nPosVert+115,cSequencia,oFont16N)
	nLinAtu += 080
	oPrinter:say(nLinAtu+005,nPosVert+015,"LOTE",oFont14)
	nLinAtu += 080
	oPrinter:say(nLinAtu+005,nPosVert+015,"RESP.",oFont14)
	nLinAtu += 080
	oPrinter:say(nLinAtu+005,nPosVert+015,"LADO:  ",oFont14)
	oPrinter:say(nLinAtu+005,nPosVert+120,(cAlOP)->B1_LADO,oFont16N)
	nLinAtu += 080	
	//oPrinter:say(nLinAtu+005,nPosVert+015,"EVENTO:  ",oFont14)			// ADD LUCIANO LAMBERTI - 30-07-2021
	oPrinter:say(nLinAtu+005,nPosVert+015,(cAlOP)->C2_OBS,oFont16N)		// ADD LUCIANO LAMBERTI - 30-07-2021
	
	//nLinAtu += 010
	
	oPrinter:QRCode(nLinAtu-040, nPosVert+500, cCodBar, 110) //add Luciano em 18/11/2019 tamanho do QR CODE (110) // alterado a posição verticado do QR CODE para nLinAtu -40 (orinibal +10) em 28/10/2021
  	

Return

Static Function buscaDados()
	Local cQuery			:= ""	
	Local cOPDe				:= MV_PAR01
	Local cOPAte			:= MV_PAR02
	Local cDataDe			:= MV_PAR03
	Local cDataAte			:= MV_PAR04
	Local aLado				:= SubStr(MV_PAR05,1,1)//If(ValType(MV_PAR05) == "C", Val(MV_PAR05), MV_PAR05) //era nLado
	Local nTotReg			:= 0
	Local aLocde			:= MV_PAR06
	Local aLocate			:= MV_PAR07

	cQuery := 	"	SELECT " + CRLF
    cQuery += 	"		    SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_EMISSAO, SC2.C2_PRODUTO, SC2.C2_QUANT, SC2.C2_DATPRF, SC2.C2_OBS, " + CRLF
    cQuery += 	"		    SB1.B1_QE, SB1.B1_CODMATR, SB1.B1_DESCHL, SB1.B1_LADO, SB1.B1_COD, SC2.C2_IMPETQ " + CRLF
    cQuery += 	" 	FROM " + CRLF
    cQuery += 	"   " + RetSqlTab("SC2") + " " + CRLF
    cQuery += 	"   INNER JOIN "+RetSqlTab("SB1") + " ON 1 = 1 " + CRLF
	cQuery += 	"		AND "+RetSqlDel("SB1")+" " + CRLF
    cQuery += 	"       AND "+RetSqlFil("SB1")+" " + CRLF
    cQuery += 	"       AND SB1.B1_COD = SC2.C2_PRODUTO AND " + CRLF 
    
   	If aLado == "L"
		
   		cQuery += 	"         SB1.B1_LADO = 'L' AND " + CRLF
	
   	ElseIF aLado == "R"
		
   		cQuery += 	"         SB1.B1_LADO = 'R' AND " + CRLF
	
   	ElseIF aLado == "N"
		
   		cQuery += 	"         SB1.B1_LADO = 'N' AND " + CRLF
	
   	Else
		
   		cQuery += 	"         SB1.B1_LADO IN ('L','R','N') AND " + CRLF

   	Endif
    	    
    cQuery += 	"       SB1.D_E_L_E_T_ = ' ' "	
    cQuery += 	"   WHERE 1 = 1 " + CRLF
    cQuery +=   " 		AND "+RetSqlDel("SC2")+" " + CRLF
	cQuery +=   " 		AND "+RetSqlFil("SC2")+" " + CRLF
    cQuery += 	"       AND C2_NUM BETWEEN '" + cOPDe + "' AND '" + cOPAte + "' " + CRLF
    cQuery += 	"      	AND C2_DATPRF BETWEEN '"+ DTOS(cDataDe)+"' AND '" + DTOS(cDataAte) +"' " + CRLF
    cQuery += 	"      	AND C2_LOCAL BETWEEN '"+ (aLocde)+"' AND '" + (aLocate) +"' " + CRLF
    cQuery += 	"       AND C2_SEQUEN = '001' " + CRLF
    cQuery +=	"		AND SB1.B1_LADO = '" + aLado + "'  " + CRLF
	cQuery += 	"       AND SC2.D_E_L_E_T_ = ' ' " + CRLF
    cQuery += 	"   ORDER BY " + CRLF
    cQuery += 	"      C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD " + CRLF	
	memoWrite("\SQL\HLRPCP01.SQL",cQuery)
	TcQuery cQuery NEW Alias &cAlOP

	(cAlOP)->(dbGotop())
	Count to nTotReg

Return nTotReg

Static Function ValidPerg()
	Local aRet		:= {}
	Local aParamBox	:= {}
	Local aLado		:= {"RIGHT", "LEFT", "NONE", "TODOS"}
	Local lRet 		:= .F.
		
	aAdd(aParamBox,{1,"OP de"	  							,space(TamSX3("C2_NUM")[1])					,"","","SC2","", 40,.F.})	// MV_PAR01
	aAdd(aParamBox,{1,"OP até"	   							,space(TamSX3("C2_NUM")[1])					,"","","SC2","", 40,.F.})	// MV_PAR02	
	aAdd(aParamBox,{1,"Entrega de"	  						,stod("")				,"@D","","","", 60,.F.})	// MV_PAR03
	aAdd(aParamBox,{1,"Entrega até"	   						,stod("")				,"@D","","","", 60,.F.})	// MV_PAR04
	aAdd(aParambox,{2,"Lado ?"								,4, aLado, 60, ".T.", .T.})   
	aAdd(aParamBox,{1,"Armazem de"	  						,space(TamSX3("C2_LOCAL")[1])					,"","","SC2","", 80,.F.})	// MV_PAR06
	aAdd(aParamBox,{1,"Armazem até"	   						,space(TamSX3("C2_LOCAL")[1])					,"","","SC2","", 80,.F.})	// MV_PAR07	     

	If ParamBox(aParamBox,"HLRPCP01",@aRet,,,,,,,"HLRPCP01",.T.,.T.)
		lRet := .t.
	EndIf

Return lRet
