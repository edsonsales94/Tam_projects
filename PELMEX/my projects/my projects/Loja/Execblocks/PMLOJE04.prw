#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMLOJE04    ºAutor  ³Stan Lee Lopes     				º Data ³  23/11/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Muda a TES na Venda Assistida              								 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User function ValTES
	/*Local _cPessoa := ""
	Local _cUF     := ""
	Local _cIE     := ""
	Local _cTipo   := ""  


	_cPessoa := POSICIONE("SA1", 1, xFilial("SA1") + M->LQ_CLIENTE+M->LQ_LOJA, "A1_PESSOA")
	_cTipo   := POSICIONE("SA1", 1, xFilial("SA1") + M->LQ_CLIENTE+M->LQ_LOJA, "A1_TIPO")
	_cUF     := POSICIONE("SA1", 1, xFilial("SA1") + M->LQ_CLIENTE+M->LQ_LOJA, "A1_EST")
	_cIE     := ALLTRIM(POSICIONE("SA1", 1, xFilial("SA1") + M->LQ_CLIENTE+M->LQ_LOJA, "A1_INSCR"))

	if _cPessoa == "F" .AND. _cUF == "PA" .AND. M->LQ_CLIENTE+M->LQ_LOJA == "00306701"
	aColsDet[n,aScan(aHeaderDet,{|x|alltrim(x[02])=="LR_TES"})] := "865"
	aColsDet[n,aScan(aHeaderDet,{|x|alltrim(x[02])=="LR_CF"})]  := "6102"
	elseif M->LQ_XRES == "1" .AND. _cUF == "PA" .AND. (_cIE == "ISENTO" .OR. _cIE == "")
	aColsDet[n,aScan(aHeaderDet,{|x|alltrim(x[02])=="LR_TES"})] := "551"
	aColsDet[n,aScan(aHeaderDet,{|x|alltrim(x[02])=="LR_CF"})]  := "6107"
	elseif (_cTipo == "F" .OR. _cTipo == "R") .AND. _cUF == "PA" .AND. (_cIE <> "ISENTO" .OR. _cIE <> "") .AND. _cPessoa == "J"
	aColsDet[n,aScan(aHeaderDet,{|x|alltrim(x[02])=="LR_TES"})] := "888"
	aColsDet[n,aScan(aHeaderDet,{|x|alltrim(x[02])=="LR_CF"})]  := "6101"
	endif

	if _cPessoa == "F" .AND. _cUF == "AM" .AND. M->LQ_CLIENTE+M->LQ_LOJA == "00104101"
	aColsDet[n,aScan(aHeaderDet,{|x|alltrim(x[02])=="LR_TES"})] := "827"
	aColsDet[n,aScan(aHeaderDet,{|x|alltrim(x[02])=="LR_CF"})]  := "5102"
	elseif M->LQ_XRES == "1" .AND. _cUF == "AM" .AND. (_cIE == "ISENTO" .OR. _cIE == "") .AND. _cPessoa == "F"
	aColsDet[n,aScan(aHeaderDet,{|x|alltrim(x[02])=="LR_TES"})] := "563"
	aColsDet[n,aScan(aHeaderDet,{|x|alltrim(x[02])=="LR_CF"})]  := "5101"
	elseif (_cTipo == "F" .OR. _cTipo == "R") .AND. _cUF == "AM" .AND. (_cIE <> "ISENTO" .OR. _cIE <> "") .AND. _cPessoa == "J" 
	aColsDet[n,aScan(aHeaderDet,{|x|alltrim(x[02])=="LR_TES"})] := "550"
	aColsDet[n,aScan(aHeaderDet,{|x|alltrim(x[02])=="LR_CF"})]  := "5101"
	endif

	*/
Return