#INCLUDE 'PROTHEUS.CH'
#include "rwmake.ch"
#include "TbiConn.ch"

/*/{Protheus.doc} User Function MA651PRC
    Funï¿½ï¿½o A651Firma - Funï¿½ï¿½o responsï¿½vel por transformar OPs Previstas em Firmes.
    EM QUE PONTO: No inï¿½cio, antes da gravaï¿½ï¿½o.
    OBJETIVO: Permitir que o processamento continue ou nï¿½o.
    @type  Function
    @author edson.pedro@totvs.com.br
    @since 23/08/2023
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=322149288
    /*/
User Function MA651PRC()
	Local cMarca   := PARAMIXB[1] // Marca utilizada pela MarkBrowse
	Local lSelTudo := PARAMIXB[2] // Indica se marcou tudo (.T.) ou nao (.F.)
	Local lRet := .T.// Validaï¿½ï¿½es do usuï¿½rio

	MSGRUN( 'Gerando a Solicitacao ao Armazem...', 'Aguarde', {|| lRet := fSolicit(cMarca,lSelTudo)} )

Return lRet


/*/{Protheus.doc} fSolicit
	Gerar solicitacao ao armazem dos produtos empenhados das ops firmadas
	@type  Static Function
	@author edson.pedro@totvs.com.br
	@since 23/08/2023
/*/
Static Function fSolicit(cMarca,lSelTudo)

	Local cAliasNew := GetNextAlias()

	Local lRet := .F.
	Local lEnc := .F.
	Local cNumero := ''
	Local cCodUsr    := RetCodUsr()
	Local cNomUsr    := Alltrim( UsrRetName(cCodUsr)  )
	Local  aAuto   := {}
	Local  aProdSA := {}
	Local  aCab    := {}
	Local  aLinha  := {}
	// Local  aIteDel := {}
	Local cOpAtual := ''
	Private lMsErroAuto := .F.

	BeginSql Alias cAliasNew
            SELECT C2_OK,D4_FILIAL
				,D4_OP
                ,D4_COD
                ,D4_LOCAL
                ,D4_LOTECTL
                ,D4_DTVALID
                ,D4_NUMLOTE
                ,SUM(D4_QUANT) AS D4_QUANT 
                ,B1_DESC
				,B1_X_EMPAD
                ,B1_UM
                ,B1_LOCPAD
                ,B1_TIPO
				,C2_DATPRF
                ,REPLACE(REPLACE(CONVERT(VARCHAR(MAX),COALESCE((SELECT C2_NUM+C2_ITEM+C2_SEQUEN  FROM %table:SC2% A WHERE A.D_E_L_E_T_ = '' AND A.C2_TPOP = 'P' AND A.C2_FILIAL= %Exp:xFilial("SC2")% AND A.C2_OK = %Exp:cMarca%  FOR XML PATH('_'), TYPE),'')),'<_>',''),'</_>','') AS 'OPS'
            FROM %table:SC2% SC2
            INNER JOIN %table:SD4% SD4 ON D4_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND C2_FILIAL = D4_FILIAL AND SD4.D_E_L_E_T_ = ''
            INNER JOIN %table:SB1% SB1 ON B1_COD = D4_COD AND LEFT(B1_FILIAL,LEN(B1_FILIAL)) = LEFT(D4_FILIAL,LEN(B1_FILIAL))
            WHERE SC2.D_E_L_E_T_ = '' AND SC2.C2_TPOP = 'P' AND SC2.C2_FILIAL= %Exp:xFilial("SC2")% AND SC2.C2_OK = %Exp:cMarca%
            GROUP BY  D4_FILIAL,D4_COD,D4_LOCAL,D4_LOTECTL,D4_DTVALID,D4_NUMLOTE,B1_DESC,B1_X_EMPAD,B1_UM,B1_LOCPAD,D4_OP,C2_DATPRF,C2_OK,B1_TIPO
			ORDER BY D4_OP
	EndSql

	dbSelectArea( 'SB1' )
	SB1->( dbSetOrder( 1 ) )

	dbSelectArea( 'SCP' )
	SCP->( dbSetOrder( 1 ) )

	While !(cAliasNew)->(Eof())
		// // consultar a solicitação gerada.
		// BeginSql ALIAS cAliasSCP
		// 	SELECT count(*) ntt
		// 	 FROM %table:SCP%
		// 	WHERE D_E_L_E_T_='' AND CP_X_OP = %Exp:(cAliasNew)->D4_OP%
		// EndSql

		// (cAliasSCP)->(dbgotop())
		// if ntt > 0 // se existe SC gerada, para não duplicado.
		// 	(cAliasNew)->(dbSkip()) // pula para o proximo.
		// 	loop
		// endif

		if cOpAtual != (cAliasNew)->D4_OP

			cOpAtual := (cAliasNew)->D4_OP
			lRet := FazExec(aCab,aAuto,cNumero) // faz o exec-auto antes de mudar de OP

			cNumero := GetSx8Num( 'SCP', 'CP_NUM' )
			cItem := '00'
			aAuto := {}
			aCab:= {	{"CP_NUM"		,cNumero		,NIL},;
				{"CP_SOLICIT"	,cNomUsr		,NIL},;
				{"CP_EMISSAO"	,dDataBase      	,NIL}}
		endif

		// se existir embalagem padrao, pegar a quantidade da Emb.Padrao do SB1
		if  (cAliasNew)->B1_X_EMPAD > 0
			//Posiciona na tabela de saldos
			If SB2->(MsSeek(FWxFilial("SB2") + (cAliasNew)->D4_COD + '10'))
				//Busca o saldo atual
				nSldSB2 := SaldoSB2(.F.,.T.,dDataBase,.F.)
				nSldSA  := SLDSA_AB((cAliasNew)->D4_COD) // SALDO SA: QUANTIDADE SOLICITADA EM ABERTO.

				// saldo no Local 10 + saldo Nas SA's abertas
				nSaldo := nSldSB2+nSldSA

			EndIf
			// quantidade Embalagem padrão
			nEmbPad := (cAliasNew)->B1_X_EMPAD

			// caso o saldo disponivel esteja negativado.
			IF nSaldo <= 0
				xQuantid :=  (cAliasNew)->D4_QUANT  // quantidade do empenho.
				IF xQuantid > nEmbPad
					xEmb := nEmbPad
					while xEmb < xQuantid
						xEmb += xEmb
					EndDo
					xQuantid := xEmb
				else
					xQuantid := nEmbPad
				EndIf
			else
				// verifivca se o item já teve SA gerada durante o processamento.
				nPos := AScan( aProdSA , {|x| Trim(x[1]) == Alltrim((cAliasNew)->D4_COD) } )

				// se encontrar.
				if nPos > 0
					// pega o saldo do item atual menos o item gerado anteriomente guqrda em xQtd.
					nSaldo := nSaldo - aProdSA[nPos,2]
					aProdSA[nPos,2] := aProdSA[nPos,2] + (cAliasNew)->D4_QUANT // agrega o valor atual
				else
					// incluir o item e quantidade.
					aAdd(aProdSA,{(cAliasNew)->D4_COD , (cAliasNew)->D4_QUANT})
				endif

				IF nSaldo <= 0 // saldo negativo.
					xQuantid :=  (cAliasNew)->D4_QUANT  // quantidade do empenho.
					IF xQuantid > nEmbPad
						xEmb := nEmbPad
						while xEmb < xQuantid
							xEmb += xEmb
						EndDo
						xQuantid := xEmb
					else
						xQuantid := nEmbPad
					EndIf
				else
					xQuantid := 0
					xEmb := nEmbPad
					if nSaldo < (cAliasNew)->D4_QUANT // se o saldo for maior não existe nececidade de SA.
						if xEmb < (cAliasNew)->D4_QUANT  //  se a embalagem for menor que a quantidade do empenho.
							while xQuantid < (cAliasNew)->D4_QUANT  // encrementar a quantidade.
								xQuantid += xEmb
							EndDo
						else
							xQuantid := nEmbPad  // se não, quantidade recebe embalagem.
						EndIf
					else
						if xEmb < (cAliasNew)->D4_QUANT  //  se a embalagem for menor que a quantidade do empenho.
							while xQuantid < (cAliasNew)->D4_QUANT  // encrementar a quantidade.
								xQuantid += xEmb
							EndDo
						else
							xQuantid := nEmbPad  // se não, quantidade recebe embalagem.
						EndIf
						// para item que sera encerrado.
						lEnc := .T.
						// (cAliasNew)->(dbSkip())
						// loop
					EndIf
				EndIf
			EndIf
		else
			xQuantid :=  (cAliasNew)->D4_QUANT
		endif

		IF (cAliasNew)->B1_TIPO <> 'PI'

			// GRAVA SOLICITAÃ‡ÃƒO
			cItem := soma1(cItem)
			aLinha := {}
			aadd(aLinha,{"CP_ITEM"		,cItem	, Nil})
			aadd(aLinha,{"CP_PRODUTO"	, (cAliasNew)->D4_COD		, Nil})
			aadd(aLinha,{"CP_UM"		, (cAliasNew)->B1_UM		, Nil})
			aadd(aLinha,{"CP_QUANT"		, xQuantid  				, Nil})

			aadd(aLinha,{"CP_DATPRF"	, dDataBase 				, Nil})
			if lEnc
				// item que vai ser incluido mais já encerrado.
				aadd(aLinha,{"CP_STATUS", 'E'						, Nil})
			Else
				aadd(aLinha,{"CP_STATUS", ''						, Nil})
			endif
			// aadd(aLinha,{"CP_CC"		, cCC					, Nil})
			aadd(aLinha,{"CP_LOCAL"		, '01'      			, Nil})
			aadd(aLinha,{"CP_X_OP"		, (cAliasNew)->D4_OP  	, Nil})
			// aadd(aLinha,{"CP_OBS"		, ItemObs			, Nil})

			aAdd(aAuto,aLinha)
			lEnc := .F.
			lRet := .T.
		EndIf
		(cAliasNew)->(dbSkip())
	EndDo

	lRet := FazExec(aCab,aAuto,cNumero) // faz o exec-auto da ultima SA

	a651Proces('SC2','',4,cMarca) // FIMAR ops
	lRet := .F.

Return lRet

/*/{Protheus.doc} SLDSA_AB()
	Verificar a quantidade já solicitada, para calcula se
	haverar ou não necessidade de solicitar mais para o item.
	@author Edson Sales
	@since 05/03/2026
/*/
Static Function SLDSA_AB(_cCod)
	Local cAlias := GetNextAlias()

	// BeginSql alias cAlias
	// 	SELECT isnull(SUM(SALDO),0) SLD FROM (
	// 		SELECT (CP_QUANT-CP_QUJE-B2_QEMP) SALDO,B2_QATU,B2_QEMP FROM %TABLE:SCP% CP
	// 			INNER JOIN %TABLE:SB2% B2 ON B2.D_E_L_E_T_='' AND CP_PRODUTO=B2_COD AND B2_LOCAL='10'
	// 			WHERE CP.D_E_L_E_T_='' AND CP_STATUS='' AND CP_PRODUTO =%exp:_cCod%
	// 	) AS T
	// EndSql
	BeginSql alias cAlias
		SELECT SUM(CP_QUANT) CP_QUANT FROM %TABLE:SCP% CP
		WHERE CP.D_E_L_E_T_='' AND CP_STATUS='' AND CP_PRODUTO = %exp:_cCod%
	EndSql

	nQTD := (cAlias)->CP_QUANT
	(cAlias)->(DbCloseArea())
Return nQTD

Static Function FazExec(_aCab,_aAuto,cNumero)
	Local lRet := .T.
	Local nZ := 0
	Local  PARAMIXB1
	Local  PARAMIXB2
	Local  PARAMIXB3
	Local  PARAMIXB4
	Local  PARAMIXB5
	Local  PARAMIXB6
	Local  PARAMIXB7
	Local  PARAMIXB8
	Local  PARAMIXB9
	Local  PARAMIXB10
	Local  PARAMIXB11
	Local  PARAMIXB12
	Local  PARAMIXB13
	Private l185Auto := .T.

	if !Empty(_aAuto)
		nOpcAuto :=3
		MSExecAuto({|x,y,z,a| mata105(x,y,z,a)},_aCab,_aAuto,nOpcAuto) //aRateio //// 3 - Inclusao, 4 - AlteraÃ§Ã£o, 5 - ExclusÃ£o

		if !lMsErroAuto
			/* trecho para encerra itens que o saldo no 10 ja atende */
			for nZ := 1 to LEN(_aAuto)
				if _aAuto[nZ,6,2] == 'E' // indica que o item pode ser encerrado- saldo que tem no 10 ja atende.
					dbSelectArea('SCP')
					SCP->(dbSetOrder(1))
					if SCP->(MsSeek(xFilial('SCP')+_aCab[1][2]+_aAuto[nZ,1,2]+DTOS(dDataBase)))
						A185Encer('SCP',SCP->(RECNO()),6)
					endif
				endif
			next nZ

			Pergunte("MTA106",.F.)
			cFiltraSCP := "CP_NUM <> ' "+cNumero+ "'"

			PARAMIXB1 := .F.
			PARAMIXB2 := MV_PAR01==1
			PARAMIXB3 := If(Empty(cFiltraSCP), {|| .T.}, {|| &cFiltraSCP})
			PARAMIXB4 := MV_PAR02==1
			PARAMIXB5 := MV_PAR03==1
			PARAMIXB6 := MV_PAR04==1
			PARAMIXB7 := MV_PAR05
			PARAMIXB8 := MV_PAR06
			PARAMIXB9 := MV_PAR07==1
			PARAMIXB10 := MV_PAR08==1
			PARAMIXB11 := MV_PAR09
			PARAMIXB12 := .T.
			PARAMIXB13 := .F.

			A106PreReq(PARAMIXB1,PARAMIXB2,PARAMIXB3,PARAMIXB4,PARAMIXB5,PARAMIXB6,PARAMIXB7,PARAMIXB8,PARAMIXB9,PARAMIXB10,PARAMIXB11,PARAMIXB12,PARAMIXB13)

			ConfirmSx8()
			FWAlertSuccess('Foi gerado uma solicitacao ao Armazem, Nro: '+ cNumero, 'S.A gerada.')
		Else
			MostraErro()
			FWAlertInfo('Nao foi gerado uma solicitacao ao Armazem, deseja firmar a OP sem a S.A ?', 'Atencao...')
		endif
	Else
		lRet := .T.
	endif

Return lRet
