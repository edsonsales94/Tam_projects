#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.ch"
#Include "Totvs.ch"

User Function EREST_01()

Return

Class APONTAMENTO

Data CPRODUC	As String
Data cStatus 	As String
Data cUsuario 	As String 

Method New(cOP,cStatus,cUsuario) Constructor 
EndClass

Method New(xOP,xStatusOP,xUsuario) Class APONTAMENTO
::CPRODUC := xOP
::cStatus := xStatusOP
::cUsuario := xUsuario
Return(Self)

WSRESTFUL APONTAMENTO DESCRIPTION "Serviço REST para apontamento de OPs"

WSDATA CPRODUC As String
WSDATA cUsuario As String

WSMETHOD GET DESCRIPTION "Retorna a OP informada na URL" WSSYNTAX "/APONTAMENTO || /CPRODUC/{}"

END WSRESTFUL

WSMETHOD GET WSRECEIVE CPRODUC WSSERVICE APONTAMENTO
	Local cETQ     := Self:CPRODUC
	Local cOP      := SubStr(Self:CPRODUC,1,6)
	Local cUser    := Self:cUsuario
	Local cCodProd := ""
	Local aArea    := GetArea()
	Local oObjProd := Nil
	Local cStatus  := ""
	Local cJson    := ""
	Local lRet := ''

	::SetContentType("application/json")

	qout("Iniciando Processo de apontamento de OP...")
	lRet := VALIDAOP1(cETQ,cUser)

	DbSelectArea("SC2")
	cCodProd := Posicione("SC2", 1, xFilial("SC2") + cOP,"C2_PRODUTO")

	If Empty(cCodProd)
		Return .T.
	EndIf   

	DbSelectArea("SB1")
	SB1->( DbSetOrder(1) )
	If SB1->( DbSeek( xFilial("SB1") + cCodProd ) )
		
			

		cStatus  := "OK"

		
		oObjProd := APONTAMENTO():New(SB1->B1_DESC, cStatus)
	EndIf

	Conout("********************************************************")
	Conout("CodProd: "+cETQ+" - "+cCodProd+" - "+SB1->B1_DESC)
	
	if lret = 'T'
	Conout("Status: "+cStatus)
	endif
	Conout("********************************************************")

	cJson := FWJsonSerialize(oObjProd)

	::SetResponse(cJson)

	RestArea(aArea)
Return(.T.)                     


/*_______________________________________________________________________________
¦ Função    ¦ PLESTP2c    ¦ Autor ¦ STAN LEE          ¦ Data ¦ 17/07/2019       ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Valida leitura do RFID			                                ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function VALIDAOP1(nOP,Usuario)
	Local cProduto, nSaldo, nPos
	Local lRsp   := .F.   
	Local cOP    := SubStr(nOP,1,11)
	Local cSeqB1 := PADR(AllTrim(SubStr(nOP,12,Len(nOP))),6)
	Local lret := ''


	SC2->(dbSetOrder(6))
	SB1->(dbSetOrder(1))
	SZ1->(dbSetOrder(1))
	SZ4->(dbSetOrder(1))
	
	If !SC2->(dbSeek(xFilial("SC2")+cOp))
		//Aviso("Atenção","Ordem de produção inexistente !", {"Ok"})
		qout("Atenção, Ordem de produção inexistente! "+cOP )
	ElseIf !SZ4->(dbSeek(XFILIAL("SZ4")+cOP+cSeqB1))// .Or. !SZ4->(dbSeek(XFILIAL("SZ4")+cOP+" "+cSeqB1))
		//Aviso("Atenção","Etiqueta não impressa !", {"Ok"})
		qout("Atenção, Etiqueta "+cOP+cSeqB1+" não Impressa!")
	ElseIf !Empty(SC2->C2_DATRF) 
		if !SZ1->(dbSeek(xFilial("SZ1")+cOP+cSeqB1)) .AND. Usuario <> "ANDROID"
			Reclock("SZ1",.T.)
			SZ1->Z1_FILIAL	 := xFilial("SZ1")
			SZ1->Z1_OP		 := cOP
			SZ1->Z1_CHASSIS  := cSeqB1
			SZ1->Z1_DTAPONT  := Date()
			SZ1->Z1_HRAPONT  := Time()
			SZ1->Z1_HOST     := ALLTRIM(GetComputerName())
			SZ1->Z1_USER     := Usuario
			SZ1->(MsUnlock())
		EndIf
		//Aviso("Atenção","Ordem de produção encerrada !", {"Ok"})
		qout("Atenção, Ordem de produção encerrada! "+cOP+cSeqB1 )
		lret := 'T'
	ElseIf SZ1->(dbSeek(xFilial("SZ1")+cOP+cSeqB1)) .AND. Usuario <> "ENTRALOTE"
		//Aviso("Atenção","Apontamento já realizado em "+dtoc(SZ1->Z1_DTAPONT)+" !!!", {"Ok"})
		qout("Atenção, Apontamento já realizado na entrada em "+dtoc(SZ1->Z1_DTAPONT)+" !!!")
		lret := 'T'
	Else
		SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		nSaldo := SC2->C2_QUANT-SC2->C2_QUJE

		If (SZ1->Z1_OP+SZ1->Z1_CHASSIS == cOP+cSeqB1) .AND. Usuario = "ENTRALOTE"
			qout("Processando Lote OP "+nOP+" ...")
			lret := VALIDAOP2(nOP)
		
		ElseIf !(SZ1->Z1_OP+SZ1->Z1_CHASSIS == cOP+cSeqB1) .AND. Usuario <> "ENTRALOTE"
			If lRsp := (nSaldo > 0)
				//Processa({||VALIDAOP2(), "Processando..."})
	// registro da linha 219			
			
			if !SZ1->(dbSeek(xFilial("SZ1")+cOP+cSeqB1)) .AND. Usuario <> "ANDROID"
				Reclock("SZ1",.T.)
				SZ1->Z1_FILIAL	 := xFilial("SZ1")
				SZ1->Z1_OP		 := cOP
				SZ1->Z1_CHASSIS  := cSeqB1
				SZ1->Z1_DTAPONT  := Date()
				SZ1->Z1_HRAPONT  := Time()
				SZ1->Z1_HOST     := ALLTRIM(GetComputerName())
				SZ1->Z1_USER     := Usuario
				
				SZ1->(MsUnlock())
			EndIf
				
				qout("Processando OP "+nOP+" ...")
				lret := VALIDAOP2(nOP) 
			Else
				//Aviso("Atenção","Saldo da OP já atendido!", {"Ok"})

			EndIf
		Else
			//Aviso("Atenção","Esta etiqueta já foi lida !", {"Ok"})
			qout("Atenção, Esta etiqueta já foi lida !")
			lret := 'T'
		EndIf
	EndIf

Return lret

/*_______________________________________________________________________________
¦ Função    ¦ VALIDAOP2   ¦ Autor ¦ STAN LEE          ¦ Data ¦ 17/07/2019       ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Gravação do apontamento da OP                                     ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function VALIDAOP2(nOP)
	Local nX, cParc, nSaldo
	Local cOP     := SubStr(nOP,1,11)
	Local cSeqB1  := PADR(AllTrim(SubStr(nOP,12,Len(nOP))),6)
	Local cError  := {}
	Local lret    := 'T'
	Local cJuncao := ""
	Local nQtd    := 0
	Local cItem   := ""

	 
	Private lMsHelpAuto := .T. // se .t. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto := .F. //necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros


	Begin Transaction

		SB1->(dbSetOrder(1))

		SC2->(dbSetOrder(6))
		SC2->(dbSeek(xFilial("SC2")+cOP))
		SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))

		qout("MSExecauto MATA250...")
		cParc := If(SC2->C2_QUJE < (SC2->C2_QUANT-1),"P","T")
        
        cJuncao := SB1->B1_XJUNCAO
        If cJuncao == "S"
        	ConOut("Juncao Sim")
			nQtd := "0,5"
			ConOut(nQtd)
			//ConOut(Val(nQtd))
        else
        	nQtd := 1
        EndIf
        
		aMata250 :={{"D3_FILIAL" , xFilial("SD3"), NIL},;
					{"D3_TM"     , "001"         , NIL},;
					{"D3_COD"    , SB1->B1_COD   , NIL},;
					{"D3_UM"     , SB1->B1_UM    , NIL},;
					{"D3_QUANT"  , nQtd          , NIL},;
					{"D3_OP"     , cOP           , NIL},;
					{'AUTEXPLODE', 'S'           , NIL},;
					{"D3_LOCAL"  , SC2->C2_LOCAL , NIL},;
					{"D3_DOC"    , GetSxeNum("SD3","D3_DOC"), NIL},;
					{"D3_EMISSAO", dDataBase     , NIL},;
					{"D3_CC"     , SC2->C2_CC    , NIL},;
					{"D3_XSEQUEN", cSeqB1        , NIL},;
					{"D3_PARCTOT", cParc         , NIL}}
		MSExecAuto({|x,y| mata250(x,y)},aMata250,3)
		
		nSaldo := SC2->C2_QUANT-SC2->C2_QUJE

		If lMsErroAuto
			DisarmTransaction()                     
			qout("Falha ao processar MATA250.")
			//qout(mostraerro())
			cError := MostraErro("C:\TOTVS\Protheus\bin\WebServiceRest\", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	        ConOut("Error: "+ cError)
	        lret := 'F'	
			break               
		EndIf 
/*		qout("Gravando SZ1...")
		Reclock("SZ1",.T.)
		SZ1->Z1_FILIAL	 := xFilial("SZ1")
		SZ1->Z1_OP		 := cOP
		SZ1->Z1_CHASSIS  := cSeqB1
		SZ1->Z1_DTAPONT  := ddatabase
		SZ1->Z1_HRAPONT  := Time()
		SZ1->Z1_HOST     := "RFID"
		SZ1->Z1_USER     := "GET"
		SZ1->(MsUnlock())
foi para a linha 133
*/
		If (nSaldo) == 0
			qout("Atualizando C2_DATRF...")
			Reclock("SC2",.F.)
			SC2->C2_DATRF := ddatabase
			SC2->(MsUnlock())
		EndIf                	
	End Transaction

	If lMsErroAuto
		/*
		Se estiver em uma aplicao normal e ocorrer alguma incosistencia nos parametros passados,mostrar na tela o log informando qual coluna teve a incosistencia.
		*/
		Mostraerro()
		qout("Erro ao Processar o Registro.")
		Return
	EndIf
	qout("Execucao Realizado com Sucesso!")
Return lret
