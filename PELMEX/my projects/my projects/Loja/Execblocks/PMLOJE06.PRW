#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFATE07    ºAutor  ³Wilson Junior	    				ºData³19/05/2021   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se existe produtos no deposito da loja							 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function vericdloja(_cproduto,item,quant)
	local lret := .T.
	local _ctes := ""
	local nLinha := ""
	nLinha := VAL(item)

	cCod := aCols[nLinha,ASCAN(aHeader,{|x| ALLTRIM(x[2]) == "LR_PRODUTO" })]
	_nPreco := U_PMLOJE06(_cproduto,nlinha,quant)


Return _nPreco

User Function PMLOJE06(_cproduto,nlinha,quant)

	//Local aArea       := GetArea()
	Local cQuery      := ""
	Local nRecCount   := 0
	Local nSaldo := 0
	//Faço a consulta para pegar as informações

cQuery := " SELECT ISNULL(DEPOSITO,0) B2_QATU FROM ( "	
	cQuery += " SELECT B2_FILIAL,B1_COD,B1_DESC, "	
	cQuery += "        ISNULL([01],0)LOJA_IMPORTADO, "	
	cQuery += " 	     ISNULL([15],0) DEPOSITO, "	
	cQuery += " 	     ISNULL([20],0)LOJA, "	
	cQuery += " 	     ISNULL(C6_QUANT,0)C6_QUANT, "	
	cQuery += " 	     ISNULL([15],0)-ISNULL(C6_QUANT,0)QTD_CD "	
	cQuery += " FROM( "	
	cQuery += "       SELECT B2_FILIAL,B1_COD,B1_DESC,B2_LOCAL,B2_QATU "	
	cQuery += "       FROM "+RetSQLName("SB2")+" SB2 "	
	cQuery += "       INNER JOIN "+RetSQLName("SB1")+" SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "	
	cQuery += "       WHERE SB2.D_E_L_E_T_ = '' "	
	cQuery += "       AND B2_FILIAL = '01' "
	cQuery += "  AND B1_COD = '"+_cproduto+"' "	
	cQuery += "       AND B2_QATU > 0 "	
	cQuery += " )TB "	
	cQuery += " PIVOT( "	
	cQuery += " 	SUM(B2_QATU) FOR [B2_LOCAL] IN ([01],[15],[20]) "	
	cQuery += " )PV "	
	cQuery += " LEFT JOIN(SELECT C6_FILIAL,C6_PRODUTO,C6_DESCRI,C6_LOCAL,SUM(ISNULL(C6_QTDVEN,0))-SUM(ISNULL(C6_QTDENT,0)) C6_QUANT "	
	cQuery += "           FROM "+RetSQLName("SC6")+" SC6 "	
	cQuery += "           WHERE SC6.D_E_L_E_T_ = '' "	
	cQuery += "           AND C6_FILIAL = '01' "	
	cQuery += "           AND C6_LOCAL = '15' "	
	cQuery += "  		  AND C6_PRODUTO = '"+_cproduto+"'  "
	cQuery += "           AND C6_QTDVEN > C6_QTDENT "	
	cQuery += "           GROUP BY C6_FILIAL,C6_PRODUTO,C6_DESCRI,C6_LOCAL)SC6 ON B2_FILIAL = SC6.C6_FILIAL AND B1_COD = SC6.C6_PRODUTO "	
	cQuery += " WHERE B1_COD = '"+_cproduto+"' "		
	cQuery += " AND B2_FILIAL = '01' "	
	cQuery += " )TB "	




	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	If Select("TRBSE1") <> 0
		DbSelectArea("TRBSE1")
		TRBSE1->(DbCloseArea())
	EndIf

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBSE1"

	dbSelectArea("TRBSE1")
	TRBSE1->(dbGoTop())

	nSaldo = TRBSE1->B2_QATU

	If (nSaldo-quant < 0)
		MSGINFO("Não existe saldo deste produto no Deposito "+CHR(13)+CHR(10)+"Por favor colocar Orc. p/ CD = Não "+CHR(13)+CHR(10)+" consulte o aplicativo para o saldo atual ")
		nSaldo = 0
	else
		nSaldo = quant
	EndIf

Return (nSaldo)