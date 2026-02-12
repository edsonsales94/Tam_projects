//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"

//Posições do Array
Static nPosCodigo := 1 //Coluna A no Excel
Static nPosLojFor := 2 //Coluna B no Excel
Static nPosRazSoc := 3 //Coluna C no Excel
Static nPosObserv := 4 //Coluna D no Excel

/*/{Protheus.doc} zImpCSV
Função para importar informações do fornecedor via csv
@author 
@since 
@version 1.0
@type function
/*/

User Function fAtuSZ7()

	Local aArea := GETAREA()
	Local cAlias := GETNEXTALIAS()

	RpcSetEnv('01','01')

	BeginSQL alias cAlias
        select D3_XETIQUE,D3_COD,A7_CODCLI,B1_DESC,C2_NUM,C2_QUANT,C2_LOCAL,C2_XMOLDE,A1_NOMETIQ,
        D3_COD+' '+D3_XETIQUE+RIGHT(REPLICATE('0', 6) + CAST(C2_QUANT AS VARCHAR), 5) ++RIGHT(REPLICATE('0', 6) + CAST(C2_NUM AS VARCHAR), 8) QR from SD3010  D3
        INNER JOIN SB1010 B1 ON D3_COD=B1_COD
        INNER JOIN SC2010 C2 ON C2_NUM+'01001'=D3_OP
        INNER JOIN SA1010 A1 ON A1_COD=C2_XCODCLI
        INNER JOIN SA7010 A7 ON A1_COD=A7_CLIENTE AND D3_COD=A7_PRODUTO
        WHERE D3.D_E_L_E_T_='' AND  D3_XETIQUE <> '' and D3_EMISSAO BETWEEN '20260101' AND '20260120'
	EndSQL

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	DbSelectArea('SZ7')
	dbSetOrder(1)
	Count to nTotal

	while !(cAlias)->(eof())

		IF !MSSEEK(XFILIAL('SZ7')+(cAlias)->D3_XETIQUE)
			RECLOCK('SZ7', .T.)
			SZ7->Z7_ETIQMAE := (cAlias)->D3_XETIQUE
			SZ7->Z7_PAMASA 	:= (cAlias)->D3_COD
			SZ7->Z7_CODCLI 	:= (cAlias)->A7_CODCLI
			SZ7->Z7_DESCRI 	:= (cAlias)->B1_DESC
			SZ7->Z7_OP 		:= (cAlias)->C2_NUM
			SZ7->Z7_QUANT 	:= (cAlias)->C2_QUANT
			SZ7->Z7_LOCAL 	:= (cAlias)->C2_LOCAL
			SZ7->Z7_MOLDE 	:= (cAlias)->C2_XMOLDE
			SZ7->Z7_QRCODE1	:= (cAlias)->QR
			SZ7->Z7_CLIENTE := (cAlias)->A1_NOMETIQ
			SZ7->(MsUnlock())

		endiF
		(cAlias)->(DBSKIP())
	endDO
	ALERT('FIM')
	RestArea(aArea)
Return
