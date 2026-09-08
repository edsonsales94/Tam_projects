#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CodCli     ºAutor  ³Totvs              º Data ³  26/12/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preenche codigo do Cliente	                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TBC-DF                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CodCli()
	Local lRet		:= .T.
	Local aArea 	:= GetArea()
	Local cCodCli	:= ""
	Local cCodLj	:= ""
	
	if Type('cCgc') == 'U'
		cCgc := M->A1_CGC
	EndIf
	
	IF inclui
		IF cCgc == "00000000000000" .OR. cCgc == "00000000000"   // Eh estrangeiro.
			cCodCli := "EX" + SeqSA1() 
			M->A1_TIPO := "X"                             
			M->A1_EST  := "EX"
		else
			cCodCli := iif(LEN(ALLTRIM(cCgc)) == 14,SubStr(cCgc,1,TamSX3("A1_COD")[1]  ),SubStr(cCgc,1,TamSX3("A1_COD")[1] ))
		endif

		If Empty(cCodCli)
			MsgStop('Devido a falha na busca pelo codigo do cliente o mesmo nao podera ser criado!','Erro Codigo Cliente.')
		EndIf
	EndIf
	RestArea(aArea)

Return cCodCli


/*
Retorna a sequencia, quando estrangeiro
*/                              
Static Function SeqSA1() 

	Local cRet := ""
	Local _cQry := ""
	Local _nNum := 0                       
	Local nTamAux := TamSX3("A1_COD")[1]-2

	_cQry := " SELECT MAX(SUBSTRING(A1_COD,3,"+Alltrim(Str(nTamAux))+")) CODIGO "
	_cQry += " FROM "+RetSqlName("SA1")+" SA1 "
	_cQry += " WHERE D_E_L_E_T_ <> '*'"
	_cQry += "  AND A1_TIPO = 'X'" //exportaçao
	_cQry += "  AND SUBSTRING(A1_COD,1,2) = 'EX' "

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
