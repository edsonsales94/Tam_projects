#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*_______________________________________________________________________________
¦ Função    ¦ ESTM01     ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 06/12/2007 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Leitura das Etiquetas de Códigos de Barras com Apontamento de OP  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function EstM01()

	While EstM01a()
	End

Return Nil
/*_______________________________________________________________________________
¦ Função    ¦ ESTM01a    ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 06/12/2007 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Processamento														¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EstM01a()

	Local nIndCmp, x							// Índice de For-Next
	Local aC := {}								// Array com descricao dos campos do Cabecalho do Modelo 2
	Local aR := {}								// Array com o rodapé da Modelo 2
	Local aCGD := { 44, 5, 118, 315}			// Coordenadas da Modelo 2
	Local cLinhaOk := ".T."						// Validação por linha da Modelo 2
	Local cTudoOk := ".T."						// Validação total da Modelo 2
	Local nOpcx := 3							// Opção de edição da Modelo 2 - Inclusão

	Local aCampos   := { "ZP_OP", "ZP_CELULA", "ZP_LEITOR"}
	Local nUsado    := 0
	Local aValid    := {}
	Local lRetMod2  := .F.

	Private cEmpresa	:= SM0->M0_NOMECOM
	Private cColetor	:= "LEITOR"
	Private dData		:= dDataBase
	Private cTitulo	:= "Recebimento de Producao"
	Private aCols		:= {}
	Private aHeader	:= {}

	AAdd( aValid , "ExistCpo('SC2',M->ZP_OP)")
	AAdd( aValid , " " )
	AAdd( aValid , "ExistCpo('SC2', aCols[n,1] + SubStr(M->ZP_LEITOR,1,17), 11) .And. u_LinLeitor(.F.)" )

	SX3->(dbSetOrder(2))

	For nIndCmp := 1 To Len(aCampos)

		If SX3->(dbSeek(aCampos[nIndCmp]))

			nUsado++

			AADD(aHeader,{ TRIM(SX3->x3_titulo), SX3->x3_campo, SX3->x3_picture, SX3->x3_tamanho, SX3->x3_decimal,;
			aValid[nIndCmp], SX3->x3_usado, SX3->x3_tipo, SX3->x3_arquivo, SX3->x3_context } )

		End If

	Next nIndCmp

	// Montando aCols
	aCols  := {}
	aadd(aCols,Array(nUsado+1))
	nUsado := 0
	Inclui := .F.

	For x:=1 To Len(aCampos)

		nUsado++

		IF nOpcx == 3
			IF		aHeader[x][8] == "C";	aCOLS[1][nUsado] := SPACE(aHeader[x][4])
			Elseif	aHeader[x][8] == "N";	aCOLS[1][nUsado] := 0
			Elseif	aHeader[x][8] == "D";	aCOLS[1][nUsado] := Ctod("  /  /  ")
			Elseif	aHeader[x][8] == "M";	aCOLS[1][nUsado] := ""
				Else;							aCOLS[1][nUsado] := .F.
			Endif
		Endif

	Next

	aCOLS[1][nUsado+1] := .F.

	// Array com descricao dos campos do Cabecalho do Modelo 2
	// aC[n,1] = Nome da Variavel Ex.:"cColetor"
	// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aC[n,3] = Titulo do Campo
	// aC[n,4] = Picture
	// aC[n,5] = Validacao
	// aC[n,6] = F3
	// aC[n,7] = Se campo e' editavel .t. se nao .f.

	AADD(aC,{ "cColetor", {27, 10}, "Para", "@!",,,.F.})
	AADD(aC,{ "cEmpresa", {15, 10},     "", "@!",,,.F.})
	AADD(aC,{ "dData"   , {27,200}, "Data", "@D",,,.F.})

	// 															Desabilita delecao
	If !Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,,.F.,)
		Return .f.
	End If

	SB1->(dbSetOrder(1))
	SZP->(dbSetOrder(6))

	For x := 1 To Len(aCOLS)

		If !SB1->(dbSeek(XFILIAL()+SubStr(aCOLS[x][3],1,15)) .Or. Empty(aCOLS[x][3]))
			Loop
		End If

		If SZP->(dbSeek(XFILIAL()+SB1->B1_COD+SubStr(aCOLS[x][3],18,6)))
			Loop
		End If

		Reclock("SZP",.T.)
		SZP->ZP_FILIAL	:= SZP->(XFILIAL())
		SZP->ZP_CELULA	:= aCOLS[x][2]
		SZP->ZP_COD		:= SB1->B1_COD
		SZP->ZP_COR		:= SubStr(aCOLS[x][3],16,2)
		SZP->ZP_OP		:= aCOLS[x][1]
		SZP->ZP_DATA	:= dData
		SZP->ZP_GRAVA	:= "S"
		SZP->(MsUnLock())

		EstM01b()						// Gravação do Apontamento da OP

	Next x

Return .t.
/*_______________________________________________________________________________
¦ Função    ¦ ESTM01b    ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 06/12/2007 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Gravação do Apontamento da OP										¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EstM01b()

	Local aRotAuto := {}
	Local nOpc := 3 // inclusao
	Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto := .f. //necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros

	Begin Transaction

		SC2->(dbSetOrder(1))
		SC2->(dbSeek(xFilial()+SZP->ZP_OP))

		aMata250 :={{"D3_TM",		"001" ,				NIL},;
		{"D3_COD",		SB1->B1_Cod,		NIL},;
		{"D3_UM",		SB1->B1_UM ,		NIL},;
		{"D3_QUANT",	1,					NIL},;
		{"D3_OP",		SZP->ZP_OP,			NIL},;
		{'AUTEXPLODE' ,	'S' ,				NIL},;
		{"D3_LOCAL",	SB1->B1_LocPad,		NIL},;
		{"D3_DOC",		Left(SZP->ZP_OP,9),	NIL},;
		{"D3_EMISSAO",	dDataBase ,			NIL},;
		{"D3_PARCTOT",	"T" ,				NIL}}

		MSExecAuto({|x,y| mata250(x,y)},aMata250,nOpc)

		If lMsErroAuto
			DisarmTransaction()
			break
		End If

	End Transaction

	If lMsErroAuto
		/*
		Se estiver em uma aplicao normal e ocorrer alguma incosistencia nos parametros passados,mostrar na tela o log informando qual coluna teve a incosistencia.
		*/
		Mostraerro()
		Return .f.
	End If

Return .t.
