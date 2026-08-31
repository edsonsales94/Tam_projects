#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFATE06    ºAutor  ³Wilson Guedss      				º Data ³  28/04/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica o custo do produto				 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function verificates(item,PRC,_cCli)
	local lret := .T.
	local _ctes := ""
	local nLinha := ""
	Local cCod := ""
	Local _nPreco :=PRC
	nLinha := VAL(item)

	_ctes :=aCols[nLinha,ASCAN(aHeader,{|x| ALLTRIM(x[2]) == "C6_TES" })]
	if (_ctes == '723' .or.  _ctes == '848' .or. _ctes == '871' .or. _ctes == '877' .or. _ctes == '574' .or. _ctes == '557' .or. _ctes == '929') .AND. _cCli != '000028'

		cCod := aCols[nLinha,ASCAN(aHeader,{|x| ALLTRIM(x[2]) == "C6_PRODUTO" })]
		_nPreco := U_PLFATE06(_ctes,cCod,nlinha)
	else	
		_nPreco := aCols[nLinha,ASCAN(aHeader,{|x| ALLTRIM(x[2]) == "C6_PRCVEN" })]
	endif
	

	/*
	For nLinha := 1 to Len(aCols)
	_ctes :=aCols[nLinha,ASCAN(aHeader,{|x| ALLTRIM(x[2]) == "C6_TES" })]
	if _ctes == '723' .or.  _ctes == '848' .or. _ctes == '871' .or. _ctes == '877'

	cCod := aCols[nLinha,ASCAN(aHeader,{|x| ALLTRIM(x[2]) == "C6_PRODUTO" })]
	_nPreco := U_PLFATE06(_ctes,cCod,nlinha)

	endif
	Next nLinha*/
Return (_nPreco)

User Function PLFATE06(TES,cCod,alinha)

	//Local aArea       := GetArea()
	Local cQuery      := ""
	Local nRecCount   := 0
	Local _cfilial    := ALLTRIM(POSICIONE( "SA1",1 , "  "+M->C5_CLIENTE, 'A1_FILTRF' ))
	Local _cpessoa   := ALLTRIM(POSICIONE( "SA1",1 , "  "+M->C5_CLIENTE, 'A1_PESSOA' ))

	Local nCusto	  := 0//Posicione("DA1",1,xFilial("DA1")+M->C5_TABELA+cCod,"DA1_PRCVEN")
	Local _cUF        := Posicione("SM0",1,"10"+cFilAnt,"M0_ESTCOB")
	
	If _cfilial <> "" //Faço a consulta para pegar as informações
		
		cQuery := "	SELECT TOP 1 B9_COD,B9_LOCAL,ISNULL(B9_CM1,0)B9_CM1,B9_DATA "
		cQuery += "	FROM "+RetSQLName("SB9")+" SB9  "
		cQuery += "	WHERE SB9.D_E_L_E_T_ = ''
		cQuery += "	AND B9_FILIAL = '"+_cfilial+"' "
		cQuery += "	AND B9_LOCAL = '20'
		cQuery += "	AND B9_COD = '"+cCod+"' "
		cQuery += "	GROUP BY B9_COD,B9_LOCAL,B9_CM1,B9_DATA
		cQuery += "	ORDER BY B9_DATA DESC	    			

		//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
		If Select("TRBSE1") <> 0
			DbSelectArea("TRBSE1")
			TRBSE1->(DbCloseArea())
		EndIf

		//crio o novo alias
		TCQUERY cQuery NEW ALIAS "TRBSE1"

		dbSelectArea("TRBSE1")
		TRBSE1->(dbGoTop())

		nCusto = TRBSE1->B9_CM1
		
	EndIf
Return (nCusto)

