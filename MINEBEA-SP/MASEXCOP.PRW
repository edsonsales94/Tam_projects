#Include "Protheus.Ch"
#include "rwmake.ch"
#include 'TBICONN.ch'

#Define ENTER  Chr(10) + Chr (13) // SALTO DE LINHA (CARRIAGE RETURN + LINE FEED)
/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MASEXCOP   ¦ Autor ¦  Edson Sales         ¦ Data ¦ 09/05/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦           ¦ Rotina para encerrar O.P. em aberta.                          ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/   

User Function MASEXCOP()

	Private cOP1    := SPACE(15)
	Private cOP2    := SPACE(15)
	Private oDlgX,oTButton
	Private cPerg := PADR("MASEXCOP",10)
	Private aParamBox := {}

	fParamBox()

// Prepare Environment Empresa "01" Filial "01" MODULO "EST"

	DEFINE MSDIALOG oDlgX TITLE "Finalizar ordens de Produção" FROM 00,00 TO 367,483 PIXEL
	@ 05,05 TO 155,235 TITLE " Parametros "

// Cria Fonte para visualização
	oFont := TFont():New('Courier new',,-14,.T.)

	@ 15 ,015 SAY "Antes de confirmar confira se os parâmetros estão corretos"
// Usando o método New
	oSay1:= TSay():New(030,015,{||"Este programa tem por objetivo encerrar/deletar de forma automática as Ordens de Produção que estiverem abertas e tiverem suas emissões e números, dentro do período e sequência, respectivamente, especificados."},oDlgX,,oFont,,,,.T.,CLR_BLACK,CLR_BLACK,200,50)
	oSay3:= TSay():New(090,015,{||"***********************************************************"} ,oDlgX,,oFont,,,,.T.,CLR_BLACK,CLR_BLACK,200,20)
	oSay4:= TSay():New(095,015,{||'Atenção: Certifique que os parâmetro estão corretos antes de confirmar pois está ação não pode ser revertida.'},oDlgX,,oFont,,,,.T.,CLR_BLACK,CLR_BLACK,200,40)

	oFont:NHEIGHT := -14
	oTButton1 := TButton():New( 160, 067, "Parametros",oDlgX,{|| fParamBox()},  54,16,,oFont,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton2 := TButton():New( 160, 128, "Confirmar" ,oDlgX,{|| RunProc( )},  		48,16,,oFont,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton3 := TButton():New( 160, 183, "Fechar"    ,oDlgX,{|| Close(oDlgX)}, 	48,16,,oFont,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton2:SetCSS(getCSS('TBUTTON_02'))
	ACTIVATE DIALOG oDlgX CENTER
Return

/*/
	+-------------------------------------------------------------------------------+
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
	¦¦¦ Programa  ¦ MIENCOPS     ¦ Autor ¦  Edson Sales       ¦ Data ¦ 09/05/2024 ¦¦¦
	¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
	¦¦¦           ¦ Rotina para encerrar O.P. em aberta.                          ¦¦¦
	¦¦¦           ¦                                                               ¦¦¦
	¦¦+-----------+---------------------------------------------------------------+¦¦
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	+-------------------------------------------------------------------------------+
/*/    

Static Function RunProc()
	Local lDel :=  IIF(EMPTY(MV_PAR07),.F.,MV_PAR07)
	Local lEnc :=  IIF(EMPTY(MV_PAR08),.F.,MV_PAR08)
	Local cText := ''
	Private aEncerrados := {}
	Private aDeletados  := {}
	Private aNaoEncer:= {}
	Private aNaoDel 	:= {}
	Private cDtini  := ''
	Private cDtfim  := ''
	Private cOP1   	:= ALLTRIM(MV_PAR03)
	Private cOP2   	:= ALLTRIM(MV_PAR04)
	Private cLoc1   	:= ALLTRIM(MV_PAR05)
	Private cLoc2   	:= ALLTRIM(MV_PAR06)

	cDtini   := IIF(!EMPTY(DTOS(MV_PAR01)),DTOS(MV_PAR01),'')
	cDtfim   := IIF(!EMPTY(DTOS(MV_PAR02)),DTOS(MV_PAR02),'')

	// // SE O CODIGO DO USUARIO CORRENTE NÃO ESTIVER NO PARAMETRO.
	// If !(__cUserID $ GetMv("MV_USUPRC"))
	// 	MsgStop("Usuário sem permissão para utilizar essa rotina!, parametro ( MV_USUPRC )")
	// 	Return
	// Endif

	if Type('MV_PAR01') <> "D"
		RETURN
	EndIF

	IF EMPTY(DTOS(MV_PAR01)) .OR. EMPTY(DTOS(MV_PAR02))
		FWAlertWarning('Os parâmetros de datas são obrigatórios', 'Warning')
		Return
	Endif

	IF EMPTY(MV_PAR04) .OR. EMPTY(MV_PAR06)
		IF EMPTY(MV_PAR04) .and. EMPTY(MV_PAR06)
			if !FWAlertYesNo('Os parametros Ops e Armazens não foram informados, serão considerados todas as OPS e armazem dentro do periodo de '+cDtini +" à " + cDtfim, 'Continuar ???')
				Return
			Endif
		elseIF EMPTY(MV_PAR04)
			if !FWAlertYesNo('Os parametros Ops não foi informado, serão considerados todas as OPS  dentro do periodo de '+cDtini +" à " + cDtfim, 'Continuar ???')
				Return
			Endif
		else
			if !FWAlertYesNo('Os parametros Armazens não foi informado, serão considerados todas os armazem dentro do periodo de '+cDtini +" à " + cDtfim, 'Continuar ???')
				Return
			Endif
		Endif
	Endif

	if empty(MV_PAR07) .OR. empty(MV_PAR08) 
		FWAlertWarning('Paramtros não informados, verifique os parametros...', 'Warning')
		Return
	endif

	IF lEnc .and. lDel
		cText += 'Tem certeza que deseja deletar as OPs em aberto e encerrar as OPs iniciadas no periodo' +ENTER
	elseif lEnc .and. !lDel
		cText += 'Tem certeza que deseja encerrar as OPs iniciadas no periodo' +ENTER
	elseif !lEnc .and. lDel
		cText += 'Tem certeza que deseja deletar as OPs em aberto no periodo' +ENTER
	EndIF

	cText += 'de: ' +dtoc(MV_PAR01) + ' ate: '+ dtoc(MV_PAR02)	 +ENTER
	if !Empty(mv_par04)
		cText += 'Ops de: ' +iif(empty(mv_par03),space(6),mv_par03) +' ate: ' +mv_par04
	EndIf
	if !Empty(mv_par06)
		cText += 'Armazens de: ' +iif(empty(mv_par05),space(6),mv_par05) +' ate: ' +mv_par06
	EndIf

	IF MsgYesNo(cText,'Atenção')
		if lEnc
			Processa( {|| MASENCOP() },'Aguarde... Encerrando Ops em processo...',OemToAnsi("Encerrando Ops em processo..."),.F.)
		EndIf
		if lDel
			// Processa( {|| MASDELOP() },'Aguarde... Deletando Ops em aberto' )
			Processa({|lEnd| MA740Process(@lEnd)},"Cancelamento das OPs Intermediarias",OemToAnsi("Cancelando as etiquetas..."),.F.)
		EndIf
	EndIf

	// EXCEL COM OS DADOS PROCESSADOS
	If !EMPTY(aEncerrados) .OR. !EMPTY(aDeletados) .OR. !EMPTY(aNaoEncer) .OR. !EMPTY(aNaoDel)
		zTstExc3(aEncerrados,aDeletados,aNaoEncer,aNaoDel)
	Endif
	Close(oDlgX)

Return

/*/
	+-------------------------------------------------------------------------------+
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
	¦¦¦ Programa  ¦ MASENCOP    ¦ Autor ¦Edson Sales          ¦ Data ¦ 09/05/2024 ¦¦¦
	¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
	¦¦¦           ¦ Rotina para Executa o Processamento de encerramento           ¦¦¦
	¦¦¦           ¦                                                               ¦¦¦
	¦¦+-----------+---------------------------------------------------------------+¦¦
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	+-------------------------------------------------------------------------------+
/*/   

Static Function MASENCOP()

	Local dDaTEnc  := ""
	Local nSaldoOP := 0
	Local nOpc     := 7
	Local cOps     := ''
	Private lMsErroAuto  := .F.

	//UPDATE PARA CORRIGIR DATA DAS REQUISIÇÕES DAS OP'S E NÃO GERAR ERROR LOG DE ENCERRAMENTO - MIGUEL 12/01/2026
	cUpd:=""
	cUpd+="UPDATE SD3010 SET D3_EMISSAO = PRI_DT FROM ("+CRLF
	cUpd+="SELECT D3_NUMSEQ SEQ, MIN(D3_EMISSAO) PRI_DT, MAX(D3_EMISSAO) ULT_DT FROM SD3010 "+CRLF
	cUpd+="INNER JOIN (SELECT C2_NUM,C2_ITEM,C2_SEQUEN FROM SC2010 WHERE D_E_L_E_T_ = '' AND C2_DATRF = '') C2 ON C2_NUM+C2_ITEM+C2_SEQUEN = D3_OP "+CRLF
	cUpd+="WHERE D_E_L_E_T_= ' '"+CRLF
	cUpd+="AND D3_OP BETWEEN '"+cOP1+"' AND '"+cOP2+"' "+CRLF
	cUpd+="AND D3_OP <> '' "+CRLF
	cUpd+="AND D3_ESTORNO != 'S'"+CRLF
	cUpd+="GROUP BY D3_NUMSEQ"+CRLF
	cUpd+="HAVING MAX(D3_EMISSAO) > MIN(D3_EMISSAO)"+CRLF
	cUpd+=")SEQS"+CRLF
	cUpd+="WHERE D3_NUMSEQ = SEQ"+CRLF
	cUpd+="AND D3_EMISSAO != PRI_DT"+CRLF
	nOk:= TcSQLExec(cUpd)

	DbSelectArea('SD3')
	// QUERY
	BeginSQL Alias "TRB"

	SELECT  C2.C2_NUM,C2.C2_ITEM,C2.C2_SEQUEN,C2.C2_QUJE,C2.C2_QUANT,C2.C2_PRODUTO,
			C2.C2_LOCAL,C2.C2_EMISSAO,C2.C2_DATRF,C2.C2_TPOP,MAX(SD3.D3_NUMSEQ) D3_NUMSEQ 
			FROM SD3010 SD3 (NOLOCK)
			INNER join (SELECT C2_NUM,C2_ITEM,C2_SEQUEN,C2_QUJE,C2_QUANT,C2_PRODUTO,C2_LOCAL,C2_EMISSAO,C2_DATRF,C2_TPOP
					FROM SC2010 SC2 (NOLOCK)
						INNER JOIN  SB1010 SB1 (NOLOCK) ON B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_ = '' 
						WHERE SC2.D_E_L_E_T_='' AND C2_DATRF = '' 
							AND C2_QUJE <> 0 AND C2_QUJE < C2_QUANT
							AND C2_DATPRF BETWEEN  %Exp:cDtini% AND  %Exp:cDtfim%
							AND C2_NUM BETWEEN  %Exp:cOP1% AND  %Exp:cOP2%
							AND C2_LOCAL BETWEEN %Exp:cLoc1% AND  %Exp:cLoc2%
							) C2  ON D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN /*D3_DOC=C2.C2_NUM*/ 
			WHERE SD3.D_E_L_E_T_=''
			AND D3_TM ='001'
			GROUP BY C2.C2_NUM,C2.C2_ITEM,C2.C2_SEQUEN,C2.C2_QUJE,C2.C2_QUANT,C2.C2_PRODUTO,C2.C2_LOCAL,C2.C2_EMISSAO,C2.C2_DATRF,C2.C2_TPOP
			ORDER BY C2.C2_NUM

	EndSQL

	Count to nCont

	If nCont == 0
		FWAlertWarning("Não foi encontrado nenhuma OP para ser encerrada....", 'Atencao')
		TRB->(dbCloseArea())
		Return
	EndIf

	ProcRegua(nCont)

	dbSelectArea('TRB')
	TRB->(DBGOTOP())
	DbSelectArea("SD3")

	Do While !TRB->(Eof()) //.and. SC2->C2_FILIAL == XFILIAL("SC2") .AND. SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) <= mv_par04
		if !Empty(TRB->C2_DATRF) .OR. TRB->C2_QUJE = 0 .OR. TRB->C2_TPOP <> 'F' .OR. TRB->C2_EMISSAO < cDtini .OR. TRB->C2_EMISSAO > cDtfim
			TRB->(dbSkip())
			Incproc()
			Loop
		endif
		cCod	  	:= TRB->C2_PRODUTO
		cOps		:= TRB->(C2_NUM+C2_ITEM+C2_SEQUEN)
		dDatEnc  	:= STOD(TRB->C2_EMISSAO)
		nSaldoOP 	:= TRB->C2_QUANT - TRB->C2_QUJE
		nPesOP   	:= TRB->C2_PRODUTO+TRB->C2_LOCAL

		DbSelectArea("SD3")
		SD3->(DbSetOrder(4))
		If SD3->(DbSeek(XFILIAL('SD3')+TRB->D3_NUMSEQ+'R0'+TRB->C2_PRODUTO))
			//Estou montando meu array aVetor com os campos do índice enviado na última posição, no caso 1.
			aVetor := {;
				{"D3_FILIAL",xFilial("SD3")  ,NIL},;
				{"D3_OP"    ,cOps             ,NIL},;
				{"D3_COD"   ,cCod          	 ,NIL},;
				{"D3_LOCAL" ,TRB->C2_LOCAL  ,NIL},;
				{"INDEX"    ,1               ,NIL}}

			MSExecAuto({|x, y| mata250(x, y)},aVetor, nOpc )

			If lMsErroAuto
				//Mostraerro()
				// ctexto  += 'Op: ' + cOp +ENTER
				aAdd(aNaoEncer,{TRB->C2_NUM,TRB->C2_PRODUTO,TRB->C2_LOCAL,TRB->C2_TPOP,TRB->C2_EMISSAO,TRB->C2_QUANT})
			Else
				aAdd(aEncerrados,{TRB->C2_NUM,TRB->C2_PRODUTO,TRB->C2_LOCAL,TRB->C2_TPOP,TRB->C2_EMISSAO,TRB->C2_QUANT})
				// ctexto2 += 'Op: ' + cOp +ENTER
			Endif
		EndIf
		//MARCA OP COMO ENCERRADA
		dbSelectArea("SC2")
		dbSetOrder(1)
		dbSeek(xFilial("SC2")+cOps,.T.)
		Reclock("SC2",.F.)
		// SC2->C2_DATRF := dDatEnc
		SC2->C2_YUSEXDE :='Data: ' + FWTimeStamp(2) +' - Usuario: '+ UsrRetName(__cUserID)
		MSUnlock()
		TRB->(dbSkip())
		IncProc()
	Enddo
	TRB->(dbCloseArea())
Return

Static Function MA740Process(lEnd)
	// LOCAL nRegOrig   := 0	// Criada p/ garantir posicionamento correto do SC2
	LOCAL lErrDel := .F.

	dbSelectArea("SC2")
	aCpos := dbStruct()

	BeginSQL Alias 'TRB'
	 	SELECT SC2.R_E_C_N_O_ RECS ,* FROM  SC2010 SC2 (NOLOCK)
			INNER JOIN  SB1010 SB1 (NOLOCK) ON B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_ = '' 
		WHERE SC2.D_E_L_E_T_='' AND C2_DATRF = ''	AND C2_QUJE = 0				
			AND C2_DATPRF BETWEEN  %Exp:cDtini% AND  %Exp:cDtfim%
			AND C2_NUM BETWEEN  %Exp:cOP1% AND  %Exp:cOP2%
			AND C2_CC BETWEEN %Exp:cLoc1% AND  %Exp:cLoc2%
	EndSQL

	dbSelectArea('TRB')
	TRB->(DBGOTOP())

	If nCont == 0
		FWAlertWarning("Não foi encontrado nenhuma OP para ser deletada....", 'Atencao')
		Return
	EndIf

	While TRB->(!Eof())
		SC2->(dbGoto(TRB->RECS))
		A650Deleta("SC2",RecNo(),5,aCpos,"MATA740",@lErrDel)

		if lErrDel // caso não seja deletado
			AADD(aNaoDel, {TRB->C2_NUM,TRB->C2_PRODUTO,TRB->C2_LOCAL,TRB->C2_TPOP,TRB->C2_EMISSAO,TRB->C2_QUANT})
		else  // deletados
			AADD(aDeletados, {TRB->C2_NUM,TRB->C2_PRODUTO,TRB->C2_LOCAL,TRB->C2_TPOP,TRB->C2_EMISSAO,TRB->C2_QUANT})
			TcSQLExec("UPDATE SC2010 SET SC2->C2_YUSEXDE := 'Data: "+ DTOC(date()) +" - Usuario: "+ UsrRetName(__cUserID) +"' WHERE C2_NUM= '"+TRB->C2_NUM +"'")
		endif

		TRB->(dbSkip())
	ENDDO
	TRB->(dbCloseArea())
Return

Static Function zTstExc3(_aEncerrados,_aDeletados,_aNaoEncer,_aNaoDel)
	Local aArea        := GetArea()
	Local oFWMsExcel
	Local oExcel
	Local cArquivo    := GetTempPath()+'log_OP.xls'
	Local nA,nB,nC,nD

	//Criando o objeto que irá gerar o conteúdo do Excel
	oFWMsExcel := FWMSExcel():New()

	// //Alterando atributos
	// oFWMsExcel:SetFontSize(12)                 //Tamanho Geral da Fonte
	// oFWMsExcel:SetFont("Arial")                //Fonte utilizada
	// oFWMsExcel:SetBgGeneralColor("#000000")    //Cor de Fundo Geral
	// oFWMsExcel:SetTitleBold(.T.)               //Título Negrito
	// oFWMsExcel:SetTitleFrColor("#94eaff")      //Cor da Fonte do título - Azul Claro
	// oFWMsExcel:SetLineFrColor("#d4d4d4")       //Cor da Fonte da primeira linha - Cinza Claro
	// oFWMsExcel:Set2LineFrColor("#ffffff")      //Cor da Fonte da segunda linha - Branco

	if !Empty(_aEncerrados)
		//******************************
		oFWMsExcel:AddworkSheet("Encerrado") //Não utilizar número junto com sinal de menos. Ex.: 1-
		//Criando a Tabela
		oFWMsExcel:AddTable("Encerrado","Lista de Ordem de produção encerradas")
		//Criando Colunas
		oFWMsExcel:AddColumn("Encerrado","Lista de Ordem de produção encerradas","Ord. Prod"	,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("Encerrado","Lista de Ordem de produção encerradas","Produto"		,1) //2 = Valor sem R$
		oFWMsExcel:AddColumn("Encerrado","Lista de Ordem de produção encerradas","Local"		,1) //3 = Valor com R$
		oFWMsExcel:AddColumn("Encerrado","Lista de Ordem de produção encerradas","Tipo"			,1)
		oFWMsExcel:AddColumn("Encerrado","Lista de Ordem de produção encerradas","Emissao"		,1)
		oFWMsExcel:AddColumn("Encerrado","Lista de Ordem de produção encerradas","Quantidade"	,1)
		//Criando as Linhas
		for nA := 1 to LEN(_aEncerrados)
			oFWMsExcel:AddRow("Encerrado","Lista de Ordem de produção encerradas",_aEncerrados[nA])
		next nA
	endif

	if !Empty(_aNaoEncer)
		//******************************
		oFWMsExcel:AddworkSheet("Nao Encerradas") //Não utilizar número junto com sinal de menos. Ex.: 1-
		//Criando a Tabela
		oFWMsExcel:AddTable("Nao Encerradas","Lista de Ordem de produção não encerradas")
		//Criando Colunas
		oFWMsExcel:AddColumn("Nao Encerradas","Lista de Ordem de produção não encerradas","Ord. Prod"	,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("Nao Encerradas","Lista de Ordem de produção não encerradas","Produto"		,1) //2 = Valor sem R$
		oFWMsExcel:AddColumn("Nao Encerradas","Lista de Ordem de produção não encerradas","Local"		,1) //3 = Valor com R$
		oFWMsExcel:AddColumn("Nao Encerradas","Lista de Ordem de produção não encerradas","Tipo"		,1)
		oFWMsExcel:AddColumn("Nao Encerradas","Lista de Ordem de produção não encerradas","Emissao"		,1)
		oFWMsExcel:AddColumn("Nao Encerradas","Lista de Ordem de produção não encerradas","Quantidade"	,1)

		//Criando as Linhas
		for nB := 1 to LEN(_aNaoEncer)
			oFWMsExcel:AddRow("Nao Encerradas","Lista de Ordem de produção não encerradas",_aNaoEncer[nB])
		next nB
	endif

	if 	!Empty(_aDeletados)
		//******************************
		oFWMsExcel:AddworkSheet("Deletados")
		//Criando a Tabela
		oFWMsExcel:AddTable("Deletados","Lista de ordens de produção deletadas")
		oFWMsExcel:AddColumn("Deletados","Lista de ordens de produção deletadas","Ord. Prod"	,1)
		oFWMsExcel:AddColumn("Deletados","Lista de ordens de produção deletadas","Produto"		,1)
		oFWMsExcel:AddColumn("Deletados","Lista de ordens de produção deletadas","Local"		,1)
		oFWMsExcel:AddColumn("Deletados","Lista de ordens de produção deletadas","Tipo"			,1)
		oFWMsExcel:AddColumn("Deletados","Lista de ordens de produção deletadas","Emissao"		,1)
		oFWMsExcel:AddColumn("Deletados","Lista de ordens de produção deletadas","Quantidade"	,1)

		for nC := 1 to LEN(_aDeletados)
			oFWMsExcel:AddRow("Deletados","Lista de ordens de produção deletadas",_aDeletados[nC])
		next nC
	endif
	if 	!Empty(_aNaoDel)
		//******************************
		oFWMsExcel:AddworkSheet("Deletados")
		//Criando a Tabela
		oFWMsExcel:AddTable("Deletados","Lista de ordens de produção deletadas")
		oFWMsExcel:AddColumn("Deletados","Lista de ordens de produção deletadas","Ord. Prod"	,1)
		oFWMsExcel:AddColumn("Deletados","Lista de ordens de produção deletadas","Produto"		,1)
		oFWMsExcel:AddColumn("Deletados","Lista de ordens de produção deletadas","Local"		,1)
		oFWMsExcel:AddColumn("Deletados","Lista de ordens de produção deletadas","Tipo"			,1)
		oFWMsExcel:AddColumn("Deletados","Lista de ordens de produção deletadas","Emissao"		,1)
		oFWMsExcel:AddColumn("Deletados","Lista de ordens de produção deletadas","Quantidade"	,1)

		for nD := 1 to LEN(_aNaoDel)
			oFWMsExcel:AddRow("Deletados","Lista de ordens de produção deletadas",_aNaoDel[nD])
		next nD
	endif

	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
	oExcel:SetVisible(.T.)                 //Visualiza a planilha
	oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

	// QRYPRO->(DbCloseArea())
	RestArea(aArea)
Return

Static Function fParamBox()

	Local aRet    := {}
	Local dDataDe := FirstDate(Date())
	Local dDataAt := LastDate(Date())

	aParamBox:={}

	aAdd(aParamBox,{1,"Data De",  dDataDe		,  "", ".T.", "", ".T.", 80,  .T.})
	aAdd(aParamBox,{1,"Data Até", dDataAt		,  "", ".T.", "", ".T.", 80,  .T.})
	aAdd(aParamBox,{1,"Ordem Producao de:"  	, SPACE(TAMSX3('C2_NUM')[1]),"","","SC2","",0,.F.})
	aAdd(aParamBox,{1,"Ordem Producao ate:" 	, SPACE(TAMSX3('C2_NUM')[1]),"","","SC2","",0,.T.})
	aAdd(aParamBox,{1,"Armazem de:"    	, SPACE(TAMSX3('CTT_CUSTO')[1]),"","","CTT","",0,.F.})
	aAdd(aParamBox,{1,"Armazem ate:"   	, SPACE(TAMSX3('CTT_CUSTO')[1]),"","","CTT","",0, .T.})
	aAdd(aParamBox,{5,"Deletar Ops em aberto ?" ,.F.,90,"",.F.})
	aAdd(aParamBox,{5,"Encerra Ops iniciadas ?" ,.F.,90,"",.F.})
	// aAdd(aParamBox, {2, "Tipo Produto:",3, {"1=PA","2=PI","3=Ambos"},     122, ".T.", .F.})
	// aAdd(aParamBox, {2, "Tipo OP:",3, {"1=F","2=P","3=Ambos"},     122, ".T.", .F.})
	lRet := ParamBox(aParamBox,"Parametros",@aRet) //ALTERAÇÃO ADSON 18/12/2023

Return lRet

/*/ {Protheus.doc} getCSS /*/
Static Function getCSS( cClass )
	Local cCSS      := '' as character
	Default cClass    := ''
// #0395B6
	If cClass == 'TBUTTON_02'
		cCSS   += "QPushButton { background-color: #0FB1D5 }"
		cCSS   += "QPushButton { border-radius: 4px } "
		cCSS   += "QPushButton:hover { background-color: #0B9BBB   } "
	Endif
Return( cCSS )

