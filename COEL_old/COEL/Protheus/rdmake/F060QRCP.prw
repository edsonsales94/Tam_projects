USER FUNCTION F060QRCP()
Local aStru := {}
Local cQuery := ""
Local nj := 0
Local cQryOri := PARAMIXB[1]
// query padrão do sistema

cQuery := subst(cQryOri,1,at("WHERE",cQryOri)-1)
cQuery := StrTran( cQuery, "R_E_C_N_O_ ", "SE1.R_E_C_N_O_ " ) 
cQuery += " INNER JOIN "+	RetSqlName('SA1') + " SA1 ON SE1.E1_CLIENTE = SA1.A1_COD AND SE1.E1_LOJA = SA1.A1_LOJA "
cQuery += subst(cQryOri,at("WHERE",cQryOri)-1, at("ORDER",cQryOri)-1 - at("WHERE",cQryOri))
cQuery := StrTran( cQuery, "D_E_L_E_T_ ", "SE1.D_E_L_E_T_ " ) 
cQuery += " AND SA1.D_E_L_E_T_ <> '*' AND SA1.A1_X_PGCAR <>" + "'S' "
cQuery += subst(cQryOri,at("ORDER",cQryOri))

Return cQuery