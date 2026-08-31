#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTE04    บAutor  ณWilson Junior	    				บDataณ11/03/2021   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica o custo do MP para rateio no mata								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function CustoMPRat(_cpro,cmat,_loc)

	local lret := .T.
	local _ctes := ""
	local nLinha := ""
	local nCusto := 0
	local
	IF funname ()=  'MATA242' 
			nCusto := U_PLESTE04(_cpro,cmat)      
	endif
Return nCusto

User Function PLESTE04(_cpro,_cMat)

	//Local aArea       := GetArea()
	Local cQuery      := ""
	Local nRecCount   := 0
	Local nSaldo := 0

	cQuery := " SELECT CASE WHEN B1_UPRC = '0' THEN ROUND((SG1.G1_QUANT*SB2.B2_CM1*100)/(SB21.B2_CM1),2,0) ELSE  ROUND((SG1.G1_QUANT*B1_UPRC*100)/(SB21.B2_CM1),2,0) END CUSTO "

	cQuery += "	FROM SG1100 SG1 "

	cQuery += "	INNER JOIN SB1100 SB1 ON B1_COD = G1_COMP AND SB1.D_E_L_E_T_  = '' AND SB1.B1_MSBLQL != '1' "
	cQuery += "	INNER JOIN SB2100 SB2 ON SB2.B2_COD = G1_COMP AND SB2.D_E_L_E_T_  = '' AND B2_LOCAL = '10' "
	cQuery += "INNER JOIN SB2100 SB21 ON SB21.B2_COD = G1_COD AND SB21.B2_LOCAL = '20' AND SB21.B2_FILIAL = '01' "
	cQuery += "WHERE G1_COD = '"+_cpro+"' "
	cQuery += "AND G1_COMP = '"+_cMat+"' "
	cQuery += "AND G1_COMP NOT LIKE 'MOD%' "
	cQuery += "AND SG1.D_E_L_E_T_ = '' "

	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	If Select("TRBSE1") <> 0
		DbSelectArea("TRBSE1")
		TRBSE1->(DbCloseArea())
	EndIf

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBSE1"

	dbSelectArea("TRBSE1")
	TRBSE1->(dbGoTop())

	nCusto = TRBSE1->CUSTO

Return (nCusto)

