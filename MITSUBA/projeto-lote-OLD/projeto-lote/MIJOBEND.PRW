#Include "RwMake.CH"
#Include "PRTOPDEF.CH"
#include "tbiconn.ch"

User Function TMATA265()
	local lamb := RpcSetEnv("01", '01', "admin", "MITECH1", "EST", GetEnvServer())
	Local aCabSDA       := {}
	Local aItSDB        := {}
	Local _aItensSDB    := {}
	Local cSDA        := GetNextAlias()
	Local cSDB        := GetNextAlias()
	LOCAL cEnder := 'PADRAO'
	LOCAL cItem := '0000'
	Private lMsErroAuto := .F.

	cLocal := "01"
	nSaldo := 0

	if !lamb
		Return
	endif

	if SELECT(cSDA) >0
		(cSDA)->(dbclosearea())
	endif

	BEGINSQL ALIAS cSDA
    SELECT DA_DOC,DA_NUMSEQ REC,DA_PRODUTO,DA_SALDO,DA_CLIFOR,DA_LOCAL
    FROM %table:SDA% SDA
    WHERE SDA.%NOTDEL%
      AND DA_LOCAL != %exp:cLocal%
      AND DA_SALDO > %exp:nSaldo%
	  ORDER BY DA_LOCAL
	ENDSQL

	DbSelectArea(cSDA)
	(cSDA)->(DbGoTop())

	if SELECT(cSDB) >0
		(cSDB)->(dbclosearea())
	endif

	BEGINSQL ALIAS cSDB
		SELECT COUNT(DB_DOC) Qtd_EST  FROM %table:SDB% SDB
		WHERE D_E_L_E_T_=''
		AND  DB_PRODUTO =%EXP:(cSDA)->DA_PRODUTO%
		AND DB_DOC = %EXP:(cSDA)->DA_DOC%
		AND DB_LOCAL = %EXP:(cSDA)->DA_LOCAL%
		AND DB_ESTORNO = 'S'
	ENDSQL

	DbSelectArea(cSDB)
	(cSDA)->(DbGoTop())

	while !(cSDA)->(EoF()) .AND. (cSDB)->Qtd_EST == 0
		_aItensSDB	:= {}
		aCabSDA 	:= {}
		aItSDB 		:= {}
		cEnder := 'PADRAO'

		cItem := soma1(cItem)
		// if Empty((cSDB)->ITEM)
		// 	cItem := '0001'
		// Else
		// 	cItem := soma1((cSDB)->ITEM)
		// endif

		//  Verificar se o fornecedor é PRONTO CARGO usa endereço padrão se não usa endereço PRONTOCARGO
		if (cSDA)->DA_LOCAL =='20'
			if !Empty((cSDA)->DA_CLIFOR) .and. (cSDA)->DA_CLIFOR <> '11663'
				cEnder := 'PRONTOCARGO'
			endif
		endif

		//Cabecalho com a informação do item e NumSeq que sera endereçado.
		aCabSDA := {{"DA_PRODUTO" ,(cSDA)->DA_PRODUTO,Nil},;
			{"DA_NUMSEQ"  ,cValToChar((cSDA)->REC),Nil}}

		//Dados do item que será endereçado
		aItSDB := {{"DB_ITEM",cItem               ,Nil},;
			{"DB_ESTORNO"    ," "                 ,Nil},;
			{"DB_LOCALIZ"    ,cEnder              ,Nil},;
			{"DB_DATA"       ,dDataBase           ,Nil},;
			{"DB_QUANT"      ,(cSDA)->DA_SALDO    ,Nil}}

		aadd(_aItensSDB,aitSDB)

		//Executa o endere?amento do item
		MSExecAuto( { |x,y,z| MATA265( x, y, z ) }, aCabSDA, _aItensSDB, 3 )
		If lMsErroAuto
			// MostraErro()
			Conout('Erro no endereçamento automatico, MIJOBEND.PRW')
		Else
			MsgAlert("Processamento Ok!",'')
		Endif
		(cSDA)->(DBSKIP())
	endDo

	if SELECT(cSDA) >0
		(cSDA)->(dbclosearea())
	endif
	if SELECT(cSDB) >0
		(cSDB)->(dbclosearea())
	endif

Return
