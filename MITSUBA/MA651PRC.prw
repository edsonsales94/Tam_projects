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
	Local cNumero := GetSx8Num( 'SCP', 'CP_NUM' )
	Local cCodUsr    := RetCodUsr()
	Local cNomUsr    := Alltrim( UsrRetName(cCodUsr)  )
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
	Local  aAuto   := {}
	Local  aCab    := {}
	Local  aLinha  := {}
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
	EndSql

	dbSelectArea( 'SB1' )
	SB1->( dbSetOrder( 1 ) )

	dbSelectArea( 'SCP' )
	SCP->( dbSetOrder( 1 ) )

	cItem := '00'

	aCab:= {	{"CP_NUM"		,cNumero		,NIL},;
		{"CP_SOLICIT"	,cNomUsr		,NIL},;
		{"CP_EMISSAO"	,dDataBase      	,NIL}}

	While !(cAliasNew)->(Eof())

		// se existir embalagem padrao, pegar a quantidade da Emb.Padrao do SB1
		if  (cAliasNew)->B1_X_EMPAD > 0
			//Posiciona na tabela de saldos
			If SB2->(MsSeek(FWxFilial("SB2") + (cAliasNew)->D4_COD + '10'))
				//Busca o saldo atual
				nSaldo := SaldoSB2(.F.,.T.,dDataBase,.F.)
				// a Diferença
				nDif := (cAliasNew)->D4_QUANT - nSaldo
				// nDif := iif((cAliasNew)->D4_QUANT > nSaldo,(cAliasNew)->D4_QUANT - nSaldo,nSaldo-(cAliasNew)->D4_QUANT)
			EndIf
			// quantidade Embalagem padrão
			nEmbPad := (cAliasNew)->B1_X_EMPAD

			// Encremeta a quantidade até suprir a necessidade da diferença
			nQtd := nEmbPad

			while nEmbPad < nDif
				nEmbPad += nQtd
			EndDo

			nQuant := nEmbPad

			// diferença <= 0 é por que o saldo SB2 atende a necessidade, não precisa incluir o item na S.A
			if (nDif <= 0)
				(cAliasNew)->(dbSkip())
				loop
			endif

		else
			nQuant :=  (cAliasNew)->D4_QUANT
		endif

		IF (cAliasNew)->B1_TIPO <> 'PI'
			// GRAVA SOLICITAÃ‡ÃƒO
			cItem := soma1(cItem)
			aLinha := {}
			aadd(aLinha,{"CP_ITEM"		,cItem	, Nil})
			aadd(aLinha,{"CP_PRODUTO"	, (cAliasNew)->D4_COD		, Nil})
			aadd(aLinha,{"CP_UM"		, (cAliasNew)->B1_UM		, Nil})
			aadd(aLinha,{"CP_QUANT"		, nQuant					, Nil})


			aadd(aLinha,{"CP_DATPRF"	, dDataBase 			, Nil})
			// aadd(aLinha,{"CP_CC"		, cCC					, Nil})
			aadd(aLinha,{"CP_LOCAL"		, '01'      			, Nil})
			aadd(aLinha,{"CP_X_OP"		, (cAliasNew)->D4_OP  	, Nil})
			// aadd(aLinha,{"CP_OBS"		, ItemObs			, Nil})

			aAdd(aAuto,aLinha)

			lRet := .T.
		EndIf
		(cAliasNew)->(dbSkip())
	EndDo

	if !Empty(aAuto)
		nOpcAuto :=3
		MSExecAuto({|x,y,z,a| mata105(x,y,z,a)},aCab,aAuto,nOpcAuto) //aRateio //// 3 - Inclusao, 4 - AlteraÃ§Ã£o, 5 - ExclusÃ£o

		if !lMsErroAuto

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
			lRet := FWAlertYesNo('Nao foi gerado uma solicitacao ao Armazem, deseja firmar a OP sem a S.A ?', 'Atencao...')
		endif
	Else
		lRet := .T.
	endif

Return lRet
