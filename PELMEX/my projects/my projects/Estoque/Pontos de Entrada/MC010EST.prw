#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
/*_____________________________________________________________________________
¦ Função    ¦ MC010Est   ¦ Autor ¦ Ulysses Ribeiro        ¦ Data ¦ 19/06/2008 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ PE - Selecionar quem vai participar da Formação de Preço			¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MC010EST

	Local cAreaAtu := GetArea()
	Local cCodProd := ParamIxb[2]
	Local cCodComp := ParamIxb[3]
	Local lRetUdf  := .t.

	cQuery := "Select Top 1 D3_COD"
	cQuery += " From " + RetSQLName("SD3") + " As D3"
	cQuery += " Where D_E_L_E_T_ = ''"
	cQuery += "	And D3_FILIAL = '" + SD3->(xFilial()) + "'"
	cQuery += " And D3_ESTORNO = ''"
	cQuery += " And Exists ("
	cQuery += " 				Select G1_COMP"
	cQuery += " 				From " + RetSQLName("SG1") + " As G1OPC"
	cQuery += " 				Where D_E_L_E_T_ = ''"
	cQuery += "					And G1_FILIAL = '" + SG1->(xFilial()) + "'"
	cQuery += " 				And Exists ("
	cQuery += " 								Select G1_COD, G1_GROPC"
	cQuery += " 								From " + RetSQLName("SG1") + " As G1"
	cQuery += " 								Where G1.D_E_L_E_T_ = ''"
	cQuery += "									And G1.G1_FILIAL = '" + SG1->(xFilial()) + "'"
	cQuery += " 								And G1.G1_COD = '" + cCodProd + "'"
	cQuery += " 								And G1.G1_COMP = '" + cCodComp + "'"
	cQuery += " 								And G1.G1_GROPC <> ''"

	cQuery += " 								And G1.G1_COD = G1OPC.G1_COD"
	cQuery += " 								And G1.G1_GROPC = G1OPC.G1_GROPC"
	cQuery += " 								)"

	cQuery += " 				And G1_COMP = D3_COD"
	cQuery += " 				)"

	cQuery += " Order by R_E_C_N_O_ Desc"

	TCQUERY cQuery NEW ALIAS "TST"

	If TST->(Eof())
		TST->(dbCloseArea())
		RestArea(cAreaAtu)
		Return .t.
	End If

	If TST->D3_COD == cCodComp
		TST->(dbCloseArea())
		RestArea(cAreaAtu)
		Return .t.
	End If

	TST->(dbCloseArea())

	RestArea(cAreaAtu)

return .f.
