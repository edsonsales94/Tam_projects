#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} User Function MTA650E
    LOCALIZAÇÃO: Function A650Deleta() - Responsável pela Deleção de O.Ps
    EM QUE PONTO : É chamado antes de excluir a Op.
    @type  Function
    @author edson.pedro@totvs.com.br
    @since 23/08/2023
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6089302
    /*/
User Function MTA650E()
	Local lRet := .T.// Validações do usuário

	MSGRUN( 'Efetuando delecao da Solicitacao ao armazem gerada pela OP...', 'Aguarde', {|| lRet := fDelSA()} )

Return lRet


/*/{Protheus.doc} fDelSA
	Realiza transferencia dos produtos empenhados das ops firmadas
	@type  Static Function
	@author edson.pedro@totvs.com.br
	@since 23/08/2023
/*/
Static Function fDelSA()
	Local cAliasNew := GetNextAlias()
	Local cAliasSCP := GetNextAlias()
	Local  aAuto   := {}
	Local  aCab    := {}
	Local  aLinha  := {}
	Local nZ := 0
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

		aCab:= {	{"CP_NUM"		,(cAliasSCP)->CP_NUM		,NIL},;
			{"CP_SOLICIT"	,(cAliasSCP)->CP_SOLICIT		,NIL},;
			{"CP_EMISSAO"	,STOD((cAliasSCP)->CP_EMISSAO)      	,NIL}}
		cItem :='00'
		// verificaer se algum item ja foi baixado, integral ou parcialmente.
		while !(cAliasSCP)->(Eof())
			if (cAliasSCP)->CP_QUJE > 0 .or.  (cAliasSCP)->CP_STATSA =='B' 
				FWAlertWarning('Existe itens solicitados ja baixados para o processo, para continuar sera necessario efetuar o estorno ou encerramento da solicitacao ao armazem Nro: '+(cAliasSCP)->CP_NUM,'Atencao !!!' )
				Return .F.
			endif

			// GRAVA SOLICITAÇÃO
			cItem := soma1(cItem)
			aLinha := {}

			aadd(aLinha,{"CP_ITEM"		,cItem	, Nil})
			aadd(aLinha,{"CP_PRODUTO"	, (cAliasSCP)->CP_PRODUTO	, Nil})
			aadd(aLinha,{"CP_UM"		, (cAliasSCP)->CP_UM		, Nil})
			aadd(aLinha,{"CP_QUANT"		, (cAliasSCP)->CP_QUANT		, Nil})
			aadd(aLinha,{"AUTDELETA" 	,'S' 						, Nil})

			aAdd(aAuto,aLinha)
			(cAliasSCP)->(dbSkip())
		EndDo


		if !Empty(aAuto)
			/* EXCLUIR PRE-REQUISIÇÃO*/
			ExPreReq(cAliasSCP)
			
			nOpcAuto :=5
			MSExecAuto({|x,y,z,a| mata105(x,y,z,a)},aCab,aAuto,nOpcAuto) //aRateio //// 3 - Inclusao, 4 - Alteração, 5 - Exclusão
			
			IF lMsErroAuto
				MostraErro()
				Return .F.
			else
				dbSelectArea('SB2')
				dbSetOrder(1)
				for nZ := 1 to LEN(aAuto)
					SB2->(MsSeek(xFilial('SB2')+aAuto[nZ,2,2]))
					SB2->(RECLOCK('SB2' ,.F.))
					SB2->B2_QEMPSA := (SB2->B2_QEMPSA - aAuto[nZ,4,2])
					SB2->(MsUnLock())
				next nZ
			endif
		endif

		SCQ->(DBCloseArea())

	EndIf

Return .T.


/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 06/10/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function ExPreReq(cAlias)
	local nErro := 0
	Local cQryUpd :=  ''
	Local lExc := .F.

	(cAlias)->(dbgotop())
	Begin Transaction
		cQryUpd := " UPDATE " + RetSqlName("SCP") + " "
		cQryUpd += "     SET CP_PREREQU = ''  "
		cQryUpd += " WHERE "
		cQryUpd += "    CP_FILIAL = '" + FWxFilial('SCP') + "' "
		cQryUpd += "    AND CP_NUM = '" + (cAlias)->CP_NUM + "' "
		cQryUpd += "     AND D_E_L_E_T_ = ' ' "

		//Tenta executar o update
		nErro := TcSqlExec(cQryUpd)

		//Se houve erro, mostra a mensagem e cancela a transação
		If nErro != 0
			MsgStop("Erro ao tentar deletar S.A: "+TcSqlError(), "Atenção")
			DisarmTransaction()
		else
			lExc := .T.
		endif
	End Transaction

		/* EXCLUIR PRE-REQUISIÇÃO*/
	dbSelectArea('SCQ')
	dbSetOrder(1)

	SCQ->(MsSeek(xFilial('SCQ')+(cAlias)->CP_NUM))

	while !SCQ->(EOF()) .AND. xFilial('SCQ')+(cAlias)->CP_NUM == SCQ->(CQ_FILIAL+CQ_NUM)
		RECLOCK('SCQ' , .F.)
		DBDELETE()
		SCQ->(MsUnLock())
		SCQ->(dbSkip())
	end

Return lExc
