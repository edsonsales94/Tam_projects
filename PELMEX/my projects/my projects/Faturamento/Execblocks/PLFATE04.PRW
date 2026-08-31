#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFATE04   ºAutor  ³STAN LEE LOPES	    				º Data ³  18/10/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Verifica Devolução do Produto no Dia			        	   			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function VERIDEV()
	/*Local cQuery    := ""     
	Local cAliasSD1 := ""
	Local nQtdLib   := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDLIB"})
	Local CodProduto := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})


	cQuery := " SELECT D1_FILIAL,D1_COD,SUM(D1_QUANT)D1_QUANT,B2_QATU,D1_LOCAL FROM "+RETSQLNAME("SD1")+" SD1 "
	cQuery += " INNER JOIN SB2100 SB2 ON SD1.D1_FILIAL = SB2.B2_FILIAL AND SD1.D1_COD = SB2.B2_COD AND SD1.D1_LOCAL = SB2.B2_LOCAL AND SB2.D_E_L_E_T_ = '' "
	cQuery += " WHERE SD1.D_E_L_E_T_ = '' "             
	cQuery += " AND D1_FILIAL = '01' "
	cQuery += " AND D1_TIPO = 'D' "  
	cQuery += "	AND B2_QATU > 0 "
	cQuery += " AND D1_EMISSAO = '"+DToS(DDATABASE)+"' "
	cQuery += "	AND D1_COD = '"+aCols[n,CodProduto]+"' "  
	cQuery += " GROUP BY D1_FILIAL,D1_COD,B2_QATU,D1_LOCAL " 

	If Select("cAliasSD1") <> 0
		DbSelectArea("cAliasSD1")
		DbCloseArea()
	EndIf

	//cria o novo alias
	TCQUERY cQuery NEW ALIAS "cAliasSD1"	

	//Atribui o número total de registro a nRecCount
	Count To nRecCount

	IF nRecCount <> 0 .AND. cFilAnt == "01"
		MsgInfo("O Produto "+aCols[n,CodProduto]+", possui uma Devolução. Verificar o Kardex.","ALERTA DE DEVOLUÇÃO")  
	endif                      

return aCols[n,nQtdLib]*/
