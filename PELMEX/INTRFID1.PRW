#Include "TOTVS.ch"
/*/{Protheus.doc} INTRFID1
(long_description)
@type user function
@author user Edson Sales
@since 27/01/2026
/*/
User Function INTRFID1()
	Local aOpAberta := {}
	Local aArea         := FWGetArea()
	Local aHeader       := {}
	Local oRestClient   := FWRest():New("https://192.168.1.2:8000/rest/chip/producao/")
	Local cAuth := 'YWRtaW46c2VuaGExMjM='
	Local nX
	aOpAberta := buscaOp()

	//Adiciona os headers que serão enviados via WS
	aAdd(aHeader,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
	aAdd(aHeader,'Content-Type: application/json; charset=utf-8')
	aAdd(aHeader, "Authorization: Basic " + cAuth)

	//Define a url conforme o CEP e aciona o método GET
	for nX := 1 to LEN(aOpAberta)
		oRestClient:setPath(aOpAberta[nX])
		If oRestClient:Get(aHeader)

			//Exibe o resultado que veio do WS
			ShowLog(oRestClient:cResult)

			//Senão, pega os erros, e exibe em um Alert
		Else
			cLastError := oRestClient:GetLastError()
			cErrorDetail := oRestClient:GetResult()
			Alert(cErrorDetail)
		Endif
	next nX

	FWRestArea(aArea)
Return


/*/{Protheus.doc} buscaOP
    (long_description)
    @type  Static Function
    @author user
    @since 27/01/2026
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function buscaOP()

	Local cAlias := GetNextAlias()
	Local aEtiq := {}

	BeginSQL alias cAlias

	select C2_YSLDIMP,* from SC2100 C2
	INNER JOIN CB0100 CB0 ON CB0.D_E_L_E_T_='' AND CB0_OP = C2_NUM+C2_ITEM+C2_SEQUEN
	where C2.D_E_L_E_T_='' AND C2_QUANT > C2_QUJE

	endSQL

	(cAlias)->(DbGoTop())

	while !(cAlias)->(Eof())

		if !(ZZJ->(msseek(xfilial('ZZJ')+(cAlias)->CB0_CODETI))) // SE NÃO ENCONTRAR
			aadd(aEtiq,(cAlias)->CB0_CODETI)
		endif

		(cAlias)->(dbskip())
	endDo
Return aEtiq
