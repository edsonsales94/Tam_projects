#include "Rwmake.ch"
/*
#############################################################################
±±ºPrograma  INCOMP01  ºAutor  ³ Ronilton O. Barros º Data ³ 14/08/2009  º±±
#############################################################################
±±ºDesc.     ³ Rotina de importação da fatura do cartão de crédito        º±±
#############################################################################
±±ºUso       ³ COMPRAS - MOVIMENTOS                                       º±±
#############################################################################
*/

User Function INCOMP01()
	Local cArquivo, cNovo
	Local lOk       := .T.
	Local cSeq      := "0001"
	Local cExtPad   := ".CSV"  // Extensão padrão
	Local vCabec    := {}
	Local vItens    := {}
	Local cCadastro := OemtoAnsi("Importação de Despesas de Cartão de Crédito")
	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	Local cPerg     := PADR("INCOMP01",Len(SX1->X1_GRUPO))
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	AADD(aSays,OemToAnsi("Esta rotina irá efetuar a importação das despesas do cartão de crédito a partir" ) )
	AADD(aSays,OemToAnsi("de dados exportados através de uma planilha em Excel. A rotina irá gerar um do-" ) )
	AADD(aSays,OemToAnsi("cumento de entrada onde cada item irá se referir a uma despesa da planilha. Para") )
	AADD(aSays,OemToAnsi("isso o arquivo gerado deverá ser informado no parâmetro.                        ") )
	
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) }})
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
	AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
	
	If nOpca == 1
		Processa({|| lOk:=Importar(@vCabec,@vItens,@cArquivo,cExtPad) },"Importação de Despesas")
		If lOk
			SZ7->(dbSetOrder(1))
			Private lMsErroAuto := .F.
			Private lMsHelpAuto := .T.
			// Inclui a nota fiscal das despesas do cartão
			MsgRun("Gerando Nota de Despesa","Importação de Despesas",{|| MsExecAuto({|a,b,c| MATA103(a,b,c) } , vCabec, vItens, 3) })
			If lMsErroAuto
				Alert("Ocorreu um erro no recebimento da nota fiscal !")
				MostraErro()
				Return .F.
			Else
				// Calcula o número da próxima nota fiscal
				SX5->(dbSetOrder(1))
				If SX5->(dbSeek(xFilial("SX5")+"01"+vCabec[4,2]))
					RecLock("SX5",.F.)
					SX5->X5_DESCRI  := Soma1(AllTrim(vCabec[3,2]))
					SX5->X5_DESCSPA := SX5->X5_DESCRI
					SX5->X5_DESCENG := SX5->X5_DESCRI
					MsUnLock()
				Endif
				MsgInfo("A nota fiscal "+vCabec[3,2]+" / "+vCabec[4,2]+" foi incluída com sucesso !")
			EndIf
			Pergunte(cPerg,.F.)   // Habilita novamente as perguntas da rotina
			mv_par02 := StrTran(AllTrim(mv_par02),"\","")  // Retira barra e espaços
			// Calcula o próximo sequencial do arquivo lido
			While File(cNovo := "\CARTAO\LIDOS\"+StrTran(mv_par02,cExtPad,"_"+cSeq+cExtPad))
				cSeq := Soma1(cSeq)
			Enddo
			FRename(cArquivo,cNovo)   // Move para a pasta LIDOS
			If MsgYesNo("Deseja visualizar a nota fiscal ?")
				Private aRotina := {{"Pesquisar" , "AxPesqui", 0, 1},{"Visualizar", "AxVisual", 0, 2}}
				SF1->(dbSetOrder(1))
				If SF1->(dbSeek(XFILIAL("SF1")+vCabec[3,2]+vCabec[4,2]+vCabec[7,2]+vCabec[8,2]))
					A103NFiscal("SF1",SF1->(RecNo()),1)
				Endif
			Endif
		Endif
	EndIf
Return

Static Function Importar(vCabec,vItens,cArquivo,cExtPad)
	Local aDadosCfo, cTipoCC, cContaCtb, cLinha
	Local cSer    := "CTA"   // Série padrão das notas de cartão
	Local cNumDoc := ""
	Local cItem   := StrZero(0,Len(SD1->D1_ITEM))
	Local nTotal  := 0
	Local cArqTmp := ""
	Local lOk     := Validacao(@cArquivo,cExtPad,cSer,@cNumDoc,@cArqTmp)  // Valida os dados para a nota
	
	If !lOk
		Return lOk
	Endif
	
	CTT->(dbSetOrder(1))
	CTD->(dbSetOrder(1))
	CTH->(dbSetOrder(1))
	
	// Calcula o CFOP da nota de entrada
	aDadosCfo := {}
	AAdd( aDadosCfo , { "OPERNF"  , "E"           })
	AAdd( aDadosCfo , { "TPCLIFOR", SA2->A2_TIPO  })
	AAdd( aDadosCfo , { "UFDEST"  , SA2->A2_EST   })
	AAdd( aDadosCfo , { "INSCR"   , SA2->A2_INSCR })
	
	// Preenche vetor do cabeçalho para ser gravado na nota fiscal
	AAdd( vCabec , { "F1_TIPO"   , "N"            , NIL})
	AAdd( vCabec , { "F1_FORMUL" , "N"            , NIL})
	AAdd( vCabec , { "F1_DOC"    , cNumDoc        , NIL})
	AAdd( vCabec , { "F1_SERIE"  , cSer           , NIL})
	AAdd( vCabec , { "F1_EMISSAO", dDataBase      , NIL})
	AAdd( vCabec , { "F1_DESPESA", 0              , NIL})
	AAdd( vCabec , { "F1_FORNECE", SA2->A2_COD    , NIL})
	AAdd( vCabec , { "F1_LOJA"   , SA2->A2_LOJA   , NIL})
	AAdd( vCabec , { "F1_ESPECIE", "NFE"          , NIL})
	AAdd( vCabec , { "F1_COND"   , SE4->E4_CODIGO , NIL})
	AAdd( vCabec , { "F1_DESCONT", 0              , NIL})
	AAdd( vCabec , { "F1_SEGURO" , 0              , NIL})
	AAdd( vCabec , { "F1_FRETE"  , 0              , NIL})
	AAdd( vCabec , { "F1_DTDIGIT", dDataBase      , NIL})

	If SF4->F4_DUPLIC == "S"  // Se gera duplicata
		AAdd( vCabec , { "E2_NATUREZ", SED->ED_CODIGO , NIL})
	Endif
	
	// Inicia leitura das despesas
	CARD->(dbGoTop())
	ProcRegua(CARD->(RecCount()))
	
	While !CARD->(Eof())
		
		IncProc("Validando..")
		
		cLinha := "Linha "+LTrim(Str(CARD->(Recno()),10))+" => "
		
		If !CTT->(dbSeek(XFILIAL("CTT")+CARD->CCUSTO))   // Valida o centro de custo
			Alert(cLinha+"Centro de custo "+If( Empty(CARD->CCUSTO) , "VAZIO !", Trim(CARD->CCUSTO)+" não existe !"))
			lOk := .F.
			Exit
		Endif
		cTipoCC := CTT->CTT_IDCC          
		If cTipoCC == "A"
			cContaCtb := SB1->B1_COTADM
		Else
			cContaCtb := SB1->B1_CONTA
		EndIf                               
		      
		CT1->(dbSetOrder(1))
		If CT1->(dbSeek(XFILIAL("CT1")+cContaCtb))
			If CT1->CT1_CLASSE <> "2"
				Alert(cLinha+"Favor informar uma conta contábil analítica !")
				lOk := .F.
				Exit
			Endif
			If CT1->CT1_BLOQ ==  "1"
				Alert(cLinha+"Conta Contábil "+cContaCtb+" informada está Bloqueada !")
				lOk := .F.
				Exit
			Endif
		Else
			Alert(cLinha+"Conta Contábil informada não existe !")
			lOk := .F.
			Exit
		Endif
		
		SZ7->(dbSetOrder(1))
		If !SZ7->(dbSeek(XFILIAL("SZ7")+CARD->REQUIS))   // Valida a requisição e posiciona na viagem
			Alert(cLinha+"Resquisição "+Trim(CARD->REQUIS)+" não possui viagem relacionada !")
			lOk := .F.
			Exit
		EndIf
		
		If CARD->VALOR <= 0   // Valida o valor da despesa
			Alert(cLinha+"O valor do item "+Trim(Str(CARD->(Recno()),10))+" é inválido !")
			lOk := .F.
			Exit
		Endif
		
		CTD->(dbSeek(XFILIAL("CTD")+SZ7->Z7_VIAJANT))  // Posiciona no item contábil
		CTH->(dbSeek(XFILIAL("CTH")+"006"))            // Posiciona na classe MCT
		
		// Preenche vetor de itens para ser gravado na nota fiscal
		vLinha := {}
		AAdd( vLinha , { "D1_ITEM"   , cItem:=Soma1(cItem) , NIL})
		AAdd( vLinha , { "D1_COD"    , SB1->B1_COD         , NIL})
		AAdd( vLinha , { "D1_DESCRI" , CARD->DESCRI        , NIL})
		AAdd( vLinha , { "D1_QUANT"  , 1                   , NIL})
		AAdd( vLinha , { "D1_VUNIT"  , CARD->VALOR         , NIL})
		AAdd( vLinha , { "D1_TOTAL"  , CARD->VALOR         , NIL})
		AAdd( vLinha , { "D1_TES"    , SF4->F4_CODIGO      , NIL})
		AAdd( vLinha , { "D1_CF"     , MaFisCfo(,SF4->F4_CF,aDadosCfo), NIL})
		AAdd( vLinha , { "D1_DTDIGIT", dDataBase           , NIL})
		AAdd( vLinha , { "D1_LOCAL"  , SB1->B1_LOCPAD      , NIL})
		AAdd( vLinha , { "D1_CONTA"  , CT1->CT1_CONTA      , NIL})
		AAdd( vLinha , { "D1_DESCCTB", CT1->CT1_DESC01     , NIL})
		AAdd( vLinha , { "D1_ITEMCTA", CTD->CTD_ITEM       , NIL})
		AAdd( vLinha , { "D1_CLVL"   , CTH->CTH_CLVL       , NIL})
		AAdd( vLinha , { "D1_DESCCLV", CTH->CTH_DESC01     , NIL})
		AAdd( vLinha , { "D1_CC"     , CTT->CTT_CUSTO      , NIL})
		AAdd( vLinha , { "D1_DESCCC" , CTT->CTT_DESC01     , NIL})
		AAdd( vLinha , { "D1_VIAGEM" , SZ7->Z7_CODIGO      , NIL})
		AAdd( vLinha , { "D1_SEGURO" , 0                   , NIL})
		AAdd( vLinha , { "D1_VALFRE" , 0                   , NIL})
		AAdd( vLinha , { "D1_DESPESA", 0                   , NIL})
		AAdd( vLinha , { "AUTDELETA" , "N"                 , NIL})
		
		AAdd( vItens , vLinha )
		
		nTotal += CARD->VALOR   // Soma os itens
		
		CARD->(dbSkip())
	Enddo
	CARD->(dbCloseArea())
	FErase(cArqTmp+GetDBExtension())
	
	// Preenche campos totalizadores da nota
	AAdd( vCabec , { "F1_VALMERC", nTotal , NIL})
	AAdd( vCabec , { "F1_VALBRUT", nTotal , NIL})
	
Return lOk

Static Function Validacao(cFile,cExtPad,cSer,cNumDoc,cArqTmp)
	Local cFile
	Local vArqBase := {}
	
	// Atribui os campos padrões da tabela de importação
	AAdd( vArqBase , { "CCUSTO", "C", TamSX3("CTT_CUSTO")[1], 0})
	AAdd( vArqBase , { "REQUIS", "C", TamSX3("Z7_CODIGO")[1], 0})
	AAdd( vArqBase , { "DESCRI", "C", 40, 0})
	AAdd( vArqBase , { "VALOR" , "N", 14, 2})
	
	SA2->(dbSetOrder(1))
	If !SA2->(dbSeek(XFILIAL("SA2")+mv_par03+mv_par04))
		Alert("Fornecedor informado não existe !")
		Return .F.
	Endif
	
	SE4->(dbSetOrder(1))
	If !SE4->(dbSeek(XFILIAL("SE4")+mv_par05))
		Alert("Condição de pagamento informada não existe !")
		Return .F.
	Endif
	
	SB1->(dbSetOrder(1))
	If !SB1->(dbSeek(XFILIAL("SB1")+mv_par06))
		Alert("Produto informado não existe !")
		Return .F.
	Endif
	
	SF4->(dbSetOrder(1))
	If SF4->(dbSeek(XFILIAL("SF4")+mv_par07))
		If SF4->F4_CODIGO > "500"
			Alert("Favor informar um TES de entrada !")
			Return .F.
		Endif
	Else
		Alert("TES informado não existe !")
		Return .F.
	Endif
	
	CT1->(dbSetOrder(1))
	If CT1->(dbSeek(XFILIAL("CT1")+mv_par08))
		If CT1->CT1_CLASSE <> "2"
			Alert("Favor informar uma conta contábil analítica !")
			Return .F.
		Endif
	Else
		Alert("Conta Contábil informada não existe !")
		Return .F.
	Endif
	
	If SF4->F4_DUPLIC == "S"  // Se gera duplicata
		SED->(dbSetOrder(1))
		If !SED->(dbSeek(XFILIAL("SED")+Trim(mv_par08)))
			Alert("Natureza para a Conta Contábil informada não existe !")
			Return .F.
		Endif
	Endif
	
	// Retira barras duplas
	mv_par01 := Upper(AllTrim(mv_par01))+"\"
	While "\\" $ mv_par01
		mv_par01 := StrTran(mv_par01,"\\","\")
	Enddo
	
	// Acerta o nome do arquivo
	mv_par02 := Upper(AllTrim(mv_par02)) + If( "." $ mv_par02 , "", cExtPad)   // Atribui extensão caso não tenha sido informado
	
	If !(cExtPad $ mv_par02)
		Alert("Extensão inválida para o arquivo, favor informar "+cExtPad+" !")
		Return .F.
	Endif
	
	cFile := StrTran(mv_par01+mv_par02,"\\","\")  // Retira barras em excesso
	If !File(cFile)
		Alert("Caminho ou arquivo informados não existem !")
		Return .F.
	Endif
	
	If !MontaArquivo(cFile,vArqBase,@cArqTmp)
		Return .F.
	Endif
	
	If CARD->(RecCount()) == 0
		CARD->(dbCloseArea())
		FErase(cArqTmp+GetDBExtension())
		Alert("O arquivo informado está vazio !")
		Return .F.
	Endif
	
	If !ProxNota(cSer,@cNumDoc)  // Busca o número da nota
		CARD->(dbCloseArea())
		FErase(cArqTmp+GetDBExtension())
		Return .F.
	Endif
	
Return .T.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Rotina    ¦ ProxNota   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/06/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Gera número da próxima nota                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ProxNota(cSer,cNota)
	Local cRet, lSF2, lSai
	Local nIndSF1 := SF1->(IndexOrd())
	Local nIndSF2 := SF2->(IndexOrd())
	Local nRegSF1 := SF1->(Recno())
	Local nRegSF2 := SF2->(Recno())
	Local nTamDoc := TamSX3("F1_DOC")[1]
	Local nTamSer := TamSX3("F1_SERIE")[1]
	Local lRet    := .T.
	
	Private cSerie  := Space(nTamSer)
	Private cNumero := Space(nTamDoc)

	While lRet := SX5NumNota()
		
		If cSerie <> cSer
			Aviso("INVÁLIDO","Série da nota não pode ser diferente de "+cSer+" !",{"OK"},1)
		Else
			SF1->(dbSetOrder(1))
			SF2->(dbSetOrder(1))
			
			If SF2->(dbSeek(XFILIAL("SF2")+cNumero+cSerie))
				Aviso("INVÁLIDO","Número de nota fiscal já cadastrado na saída !",{"OK"},1)
			Else
				lSai := .T.
				SF1->(dbSeek(XFILIAL("SF1")+cNumero+cSerie))
				While !SF1->(Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE) == XFILIAL("SF1")+cNumero+cSerie
					If SF1->F1_FORMUL == "S"  // Verifica se é formulário próprio
						Aviso("INVÁLIDO","Número de nota fiscal já cadastrado na entrada !",{"OK"},1)
						lSai := .F.
						Exit
					Endif
					SF1->(dbSkip())
				Enddo
				If lSai
					Exit
				Endif
			Endif
		Endif
	Enddo

	If lRet
		If Empty(cNota := PADR(cNumero,nTamDoc))
			Aviso("INVÁLIDO","Número de nota fiscal inválida !",{"OK"},1)
			lRet := .F.
		Endif
	Endif
	
	SF1->(dbSetOrder(nIndSF1))
	SF1->(dbGoTo(nRegSF1))
	SF2->(dbSetOrder(nIndSF2))
	SF2->(dbGoTo(nRegSF2))
Return(lRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Rotina    ¦MontaArquivo¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 04/01/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Importa o arquivo base da nota                                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaArquivo(cFile,vArqBase,cArqTmp)
	Local nTotReg, aLinha, cLinha, nLinha, cTrecho, x, nX, nPos
	Local nY     := 0
	Local nHdl   := FT_FUSE(cFile)
	Local cDelim := ","
	
	Private aPosicao := {}
	
	FT_FGOTOP()
	
	nTotReg := FT_FLASTREC()
	cLinha  := FT_FREADLN()
	
	If !(cDelim $ cLinha)
		cDelim := ";"
	Endif
	
	ProcRegua(nTotReg)
	
	// Faz leitura do cabeçalho dos itens
	While !Empty(cLinha)
		nY++
		
		cTrecho := Upper(AllTrim(If(At(cDelim,cLinha)>0,Substr(cLinha,1,At(cDelim,cLinha)-1),cLinha)))
		cLinha  := If(At(cDelim,cLinha)>0,Substr(cLinha,At(cDelim,cLinha)+1),"")
		
		aEval( vArqBase , {|x| If( x[1] == cTrecho , AAdd(aPosicao,{ nY, cTrecho}) ,) })
	EndDo
	
	// Analisa se todos os campos necessários estão informados na planilha
	For x:=1 To Len(vArqBase)
		If AScan( aPosicao , {|y| y[2] == vArqBase[x,1] } ) == 0  // Se o campo não existir
			MsgInfo("O campo "+vArqBase[x,1]+" não existe na tabela de origem !","Atenção!!")
			Return .F.
		Endif
	Next
	
	cArqTmp := CriaTrab(vArqBase,.T.)  // Cria o arquivo temporário
	Use &cArqTmp Alias CARD New Exclusive
	
	cLinha := FT_FREADLN()
	FT_FSKIP()
	cLinha := FT_FREADLN()
	nLinha := 0
	While !FT_FEOF()
		nY      := 0
		aLinha  := {}
		cLinha  := FT_FREADLN()

		RecLock("CARD",.T.)  // Cria um novo registro
		
		nLinha++
		While !Empty(cLinha)
			nY++
			
			cTrecho := Upper(AllTrim(If(At(cDelim,cLinha)>0,Substr(cLinha,1,At(cDelim,cLinha)-1),cLinha)))
			cLinha  := If(At(cDelim,cLinha)>0,Substr(cLinha,At(cDelim,cLinha)+1),"")
			
			For nX:=1 To Len(aPosicao)
				If aPosicao[nX,1] == nY   // Se achar o campo
					nPos := FieldPos(aPosicao[nX,2])
					
					If ValType(FieldGet(nPos)) == "N"
						cTrecho := Val(cTrecho)
					ElseIf ValType(FieldGet(nPos)) == "D"
						If "/" $ cTrecho
							cTrecho := Dtoc(cTrecho)
						Else
							cTrecho := Stod(cTrecho)
						Endif
					ElseIf aPosicao[nX,2] == "REQUIS"
						cTrecho := StrZero(Val(cTrecho),TamSX3("Z7_CODIGO")[1])
					Endif
					
					FieldPut( nPos , cTrecho )
					
					Exit  // Após encontrar e gravar o campo, sai
				Endif
			Next
		EndDo
		
		MsUnLock()
		
		IncProc()
		FT_FSKIP()
	Enddo
	FT_FUSE()
	
Return .T.

Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01",PADR("Caminho           ",29)+"?","","","mv_ch1","C",30,0,0,"G","","   ","","","mv_par01")
	u_INPutSX1(cPerg,"02",PADR("Arquivo           ",29)+"?","","","mv_ch2","C",20,0,0,"G","","   ","","","mv_par02")
	u_INPutSX1(cPerg,"03",PADR("Fornecedor        ",29)+"?","","","mv_ch3","C",06,0,0,"G","","SA2","","","mv_par03")
	u_INPutSX1(cPerg,"04",PADR("Loja              ",29)+"?","","","mv_ch4","C",02,0,0,"G","","   ","","","mv_par04")
	u_INPutSX1(cPerg,"05",PADR("Condição Pagamento",29)+"?","","","mv_ch5","C",03,0,0,"G","","SE4","","","mv_par05")
	u_INPutSX1(cPerg,"06",PADR("Produto           ",29)+"?","","","mv_ch6","C",15,0,0,"G","","SB1","","","mv_par06")
	u_INPutSX1(cPerg,"07",PADR("TES               ",29)+"?","","","mv_ch7","C",03,0,0,"G","","SF4","","","mv_par07")
	u_INPutSX1(cPerg,"08",PADR("Conta Contabil    ",29)+"?","","","mv_ch8","C",20,0,0,"G","","CT1","","","mv_par08")
Return
