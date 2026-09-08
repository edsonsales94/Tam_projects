#INCLUDE "Protheus.ch"     
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CodFor     ºAutor  ³Totvs              º Data ³  26/12/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preenche codigo do Fornecedor                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TBC-DF                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CodFor()
	Local aArea 	:= GetArea()
	Local cCodFor 	:= ""
	
	if Type('cCgc') == 'U'
		cCgc := M->A2_CGC
	EndIf
	
	IF inclui
		IF cCgc== "00000000000000" .OR. cCgc == "00000000000"   // Eh estrangeiro.
			cCodFor := "EX" + SeqSA2() 
			M->A2_TIPO := "X"                             
			M->A2_EST  := "EX"
		else
			cCodFor := iif(LEN(ALLTRIM(cCgc)) == 14,SubStr(cCgc,1,TamSX3("A2_COD")[1]),SubStr(cCgc,1,TamSX3("A2_COD")[1]))
		endif

		If Empty(cCodFor)
			MsgStop('Devido a falha na busca pelo codigo do Fornecedor o mesmo nao podera ser criado!','Erro Codigo Fornecedor.')
		EndIf
	EndIF

	RestArea(aArea)

Return cCodFor

/*
Retorna a sequencia, quando estrangeiro
*/                              
Static Function SeqSA2() 

	Local cRet := ""
	Local _cQry := ""
	Local _nNum := 0                       
	Local nTamAux := TamSX3("A2_COD")[1]-2

	_cQry := " SELECT MAX(SUBSTRING(A2_COD,3,"+Alltrim(Str(nTamAux))+")) CODIGO "
	_cQry += " FROM "+RetSqlName("SA2")+" SA2 "
	_cQry += " WHERE D_E_L_E_T_ <> '*'"
	_cQry += "  AND A2_TIPO = 'X'" //exportaçao
	_cQry += "  AND SUBSTRING(A2_COD,1,2) = 'EX' "

	_cQry := ChangeQuery(_cQry) //comando para evitar erros de incompatibilidade de bancos

	if Select("QUERY") > 0
		QUERY->(dbCloseArea())
	endif

	TCQUERY _cQry NEW ALIAS "QUERY"

	dbSelectArea("QUERY") 
	QUERY->(dbGoTop())

	_nNum := val(QUERY->CODIGO) + 1                                         

	QUERY->(dbCloseArea())

	cRet := StrZero(_nNum,nTamAux)

Return cRet