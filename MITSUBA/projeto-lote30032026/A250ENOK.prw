#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} User Function A250ENOK
    Localização: Executado na função A250EndOk( ) que e responsável por validar se pode 
    realizar o encerramento de uma determinada ordem de produção.
    Em que ponto: O ponto é disparado apos a confirmação do encerramento e antes da gravação. 
    Deve ser utilizado para validar se o encerramento pode ser efetuado ou não.
    @type  Function
    @author edson.pedro@totvs.com.br
    @since 23/08/2023
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=235599380
    /*/
User Function A250ENOK()
	Local lRet := .T.// Validações do usuário

	MSGRUN( 'Encerramento da Solicitacao ao armazem...', 'Aguarde', {|| lRet := fEncerrSA()} )

Return lRet


/*/{Protheus.doc} fEncerrSA
	Realiza transferencia dos produtos empenhados das ops firmadas
	@type  Static Function
	@author edson.pedro@totvs.com.br
	@since 23/08/2023
/*/
Static Function fEncerrSA()
	Local cAliasNew := GetNextAlias()
	Local cAliasSCP := GetNextAlias()
	Local  aAuto   := {}
	Local  aCab    := {}
	Local  aLinha  := {}
	Private lMsErroAuto := .F.

	BeginSql Alias cAliasNew
		SELECT D4_FILIAL
			,D4_OP
			,D4_COD
			,D4_LOCAL
			,D4_LOTECTL
			,D4_DTVALID
			,D4_NUMLOTE
			,SUM(D4_QUANT) AS D4_QUANT 
			,B1_DESC
			,B1_UM
			,B1_LOCPAD
		FROM %table:SC2% SC2
		INNER JOIN %table:SD4% SD4 ON D4_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND C2_FILIAL = D4_FILIAL AND SD4.D_E_L_E_T_ = ''
		INNER JOIN %table:SB1% SB1 ON B1_COD = D4_COD AND LEFT(B1_FILIAL,LEN(B1_FILIAL)) = LEFT(D4_FILIAL,LEN(B1_FILIAL))
		WHERE SC2.D_E_L_E_T_ = '' AND SC2.R_E_C_N_O_= %Exp:SC2->(RECNO())%
		GROUP BY  D4_FILIAL,D4_COD,D4_LOCAL,D4_LOTECTL,D4_DTVALID,D4_NUMLOTE,B1_DESC,B1_UM,B1_LOCPAD,D4_OP
	EndSql

	If !(cAliasNew)->(Eof())

		// consultar a solicitação gerada.
		BeginSql ALIAS cAliasSCP
			SELECT CP_STATSA,CP_QUJE,CP_NUM,CP_SOLICIT,CP_EMISSAO,CP_PRODUTO,CP_UM,CP_QUANT
			 FROM %table:SCP%
			WHERE D_E_L_E_T_='' AND CP_X_OP = %Exp:(cAliasNew)->D4_OP%
		EndSql

		(cAliasSCP)->(dbgotop())

		// verificaer se algum item ja foi baixado, integral ou parcialmente.
		while !(cAliasSCP)->(Eof())
			if (cAliasSCP)->CP_STATUS ==''
				FWAlertWarning('A solicitacao ao armazem Nro: '+(cAliasSCP)->CP_NUM +', ainda não foi encerrada, contate o responsavel pelo estoque, para encerrar a S.A.','Atencao !!!' )
				Return .F.
			endif
		EndDo
		(cAliasSCP)->(DBCloseArea())
	endif
Return .T.

