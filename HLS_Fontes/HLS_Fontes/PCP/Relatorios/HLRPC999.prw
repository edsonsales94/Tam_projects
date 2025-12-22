#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.ch'  
#include 'font.ch'
#include 'RPTDEF.CH'    
#include 'TBICONN.CH'

/*/{Protheus.doc} HLRPC999

Etiquetas de Produtos Acabados para Expedição - Com filtro Sequencia

@type function
@author Luciano Lamberti
@since 02/02/21

/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  HLRPC999 º Autor ³Luciano Lamberti      º Data ³   02/02/21  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiquetas de Produtos Acabados para Expedição              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HONDA LOCK                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function HLRPC999()	// Este programa imprime as etiquetas zebra QRCODE Com filtro Sequencia e quantidade inserida pelo usuário (etiqueta avulsa)

	If ValidPerg()
		imprRel() //Processa({|| imprRel() }, "Aguarde...", "Imprimindo...",.F.)
	EndIf  

return

Static Function imprRel()

	Local aQtdEmb := MV_PAR08

	Local cPorta := "LPT1" // Mapeamento feito atravÃ©s de NET USE
	Local cModelo := "ZT230"
  			 
	Private cAlOP			:= GetNextAlias()
	
   	DEFINE MSDIALOG oDlg TITLE "Etiquetas Expedicao" FROM 0,0 TO 400,800 PIXEL
	
		nTotReg := buscaDados()
		
		ProcRegua(nTotReg)
		
		(cAlOP)->(DbGoTop())
		
		
		While (cAlOP)->(!Eof())		
								
			IncProc("Gerando arquivo!")
			
			nQtdOP := Ceiling((cAlOP)->C2_QUANT/(cAlOP)->B1_QE)		
						
			//For nG := 1 to nQtdOP							retirado o FOR para impressão de 1 etiqueta
				aQtdEmb		:= MV_PAR08
				cSequencia 	:= MV_PAR09
				//cSequencia 	:= allTrim(str(nG))+"/"+allTrim(str(nQtdOP))
				nQtdResto   := (cAlOP)->C2_QUANT - (Int((cAlOP)->C2_QUANT / (cAlOP)->B1_QE) * (cAlOP)->B1_QE)
				//alert("1")

				//verificar porta lpt1
				MSCBPRINTER("ZT230,","LPT1",,,.F.,,,,,,)   
				MsCbChkStatus(.F.) 
				MSCBBEGIN(1,6)   
				//verificar se precisa redmimensionar o papel com as coordenadas abaixo
				//MSCBWRITE("CT~~CD,~CC^~CT~^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ^XA^MMT^PW799^LL0559^LS0")
				MSCBWRITE("^FT39,110^A0N,34,33^FH\^FDDESCRI\80\C7O^FS")
				MSCBWRITE("^FT39,158^A0N,34,33^FH\^FDCODIGO MAS-S^FS")
				MSCBWRITE("^FT39,211^A0N,34,33^FH\^FDCODIGO CLIENTE^FS")
				MSCBWRITE("^FT39,268^A0N,34,33^FH\^FDDATA ENTREGA^FS")
				MSCBWRITE("^FT39,321^A0N,34,33^FH\^FDQTD^FS")
				MSCBWRITE("^FT39,382^A0N,34,33^FH\^FDSEQ^FS")
				MSCBWRITE("^FT39,437^A0N,34,33^FH\^FDLOTE^FS")
				MSCBWRITE("^FT39,492^A0N,34,33^FH\^FDRESP^FS")
				MSCBWRITE("^FT39,542^A0N,34,33^FH\^FDLADO: "+(cAlOP)->B1_LADO+"^FS")
				MSCBWRITE("^FT304,105^A0N,34,33^FH\^FD"+(cAlOP)->B1_DESCHL+"^FS")
				MSCBWRITE("^FT304,158^A0N,34,33^FH\^FD"+(cAlOP)->C2_PRODUTO+"^FS")
				MSCBWRITE("^FT304,211^A0N,34,33^FH\^FD"+(cAlOP)->B1_CODMATR+"^FS")

				cCodBar := (cAlOP)->B1_CODMATR+(cAlOP)->C2_PRODUTO+dToc(stod((cAlOP)->C2_DATPRF))+(cAlOP)->C2_NUM + "#"+ allTrim(cValtoChar(MV_PAR09))+ "]" +cValtoChar(MV_PAR08)

				MSCBWRITE("^FT450,590^BQN,2,10")
				MSCBWRITE("^FH\^FDLA,"+cCodBar+"^FS")
				MSCBWRITE("^FT304,268^A0N,34,33^FH\^FD"+dToc(stod((cAlOP)->C2_DATPRF))+"^FS")
				MSCBWRITE("^FT506,268^A0N,34,33^FH\^FDNR OP: "+(cAlOP)->C2_NUM+"^FS")
				//MSCBWRITE("^FT138,328^A0N,51,50^FH\^FD"+allTrim(cValtoChar((cAlOP)->B1_QE))+"^FS") // alterado por Luciano Lamberti - 16-12-20
				MSCBWRITE("^FT138,328^A0N,51,50^FH\^FD"+cValtoChar(MV_PAR09)+"^FS") 
				MSCBWRITE("^FT138,382^A0N,34,33^FH\^FD"+cValtoChar(MV_PAR08)+"^FS")
				MSCBWRITE("^FO27,72^GB747,512,3^FS")

				MSCBWRITE("^PQ1,0,1,Y^XZ")
				   
				MSCBEND()
				MSCBCLOSEPRINTER()    
				Sleep(150)
	
			//Next			

			(cAlOP)->(DbSkip())
			
		EndDo
			
		(cAlOP)->(DbCloseArea())
		


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
	Local aSeq				:= MV_PAR09
	Local aQtdEmb			:= SubStr(MV_PAR08,1,1)		// inserido o campo para quebra de embalagem - 17/12/2020

	cQuery := 	"	SELECT " + CRLF
    cQuery += 	"		    SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_EMISSAO, SC2.C2_PRODUTO, SC2.C2_QUANT, SC2.C2_DATPRF, " + CRLF
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
    cQuery += 	"   	ORDER BY " + CRLF
    cQuery += 	"       C2_NUM, C2_ITEM, C2_SEQUEN, C2_ITEMGRD " + CRLF	
	memoWrite("\SQL\HLRPC999.SQL",cQuery)
	TcQuery cQuery NEW Alias &cAlOP

	(cAlOP)->(dbGotop())
	Count to nTotReg

Return nTotReg

Static Function ValidPerg()
	Local aRet		:= {}
	Local aParamBox	:= {}
	Local aLado		:= {"RIGHT", "LEFT", "NONE", "TODOS"}
	Local lRet 		:= .F.
	Local aSeq		:= MV_PAR09
	Local aQtdEmb	:= MV_PAR08
		
	aAdd(aParamBox,{1,"OP de"	  							,space(TamSX3("C2_NUM")[1])					,"","","SC2","", 40,.F.})	// MV_PAR01
	aAdd(aParamBox,{1,"OP atÃƒÂ©"	   							,space(TamSX3("C2_NUM")[1])					,"","","SC2","", 40,.F.})	// MV_PAR02	
	aAdd(aParamBox,{1,"Entrega de"	  						,stod("")				,"@D","","","", 60,.F.})	// MV_PAR03
	aAdd(aParamBox,{1,"Entrega atÃƒÂ©"	   						,stod("")				,"@D","","","", 60,.F.})	// MV_PAR04
	aAdd(aParambox,{2,"Lado ?"								,4, aLado, 60, ".T.", .T.})   
	aAdd(aParamBox,{1,"Armazem de"	  						,space(TamSX3("C2_LOCAL")[1])					,"","","SC2","", 80,.F.})	// MV_PAR06
	aAdd(aParamBox,{1,"Armazem atÃƒÂ©"	   						,space(TamSX3("C2_LOCAL")[1])					,"","","SC2","", 80,.F.})	// MV_PAR07	     
	aAdd(aParamBox,{1,"Sequencia "	   						,space(5),aSeq,"","","",50,.F.})					// MV_PAR09	     
	aAdd(aParamBox,{1,"Qtd Embalagem "	   					,space(2),aQtdEmb,"","","",50,.F.})						// MV_PAR08	 

	If ParamBox(aParamBox,"HLRPCP01",@aRet,,,,,,,"HLRPCP01",.T.,.T.)
		lRet := .t.
	EndIf

Return lRet
