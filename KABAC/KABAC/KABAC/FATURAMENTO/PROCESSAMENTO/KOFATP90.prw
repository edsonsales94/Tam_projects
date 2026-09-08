#INCLUDE "Protheus.ch"
#INCLUDE "ParmType.ch"
#Include "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"

User Function KOFATP90(xDoc, xSerie)
    //Default xDoc := "000002535"
    //Default xSerie := "21 "
    Default xDoc := ""
    Default xSerie := ""

    If Empty(xDoc) .Or. Empty(xSerie)
       FwAlertError("Nenhuma nota fiscal enviada","Atencao")
       Return 
    EndIf

    Processa({|lEnd| u_KOFAT90B(xDoc, xSerie) },"Transferência entre Filiais","Gerando NF de Entrada...",.F.)
Return

User Function KOFAT90B(xDoc, xSerie)
    Local xKey := ""
    Local xFilAtual := FwCodFil()
    Local xdFilial  := FwCodFil()
    Local xEmpresa  := FwCodEmp()
    Local xFilDestino := ""
    Local aCabec := {}
    Local lPreNota := .T.
    Local xCGC  := ""
    Local xInsc := ""

    // Verifica se existe ponto para manipulacao de itens
 	Local lExecItens:=ExistBlock("M310ITENS")
 	Local aBackItens:={}
	Local lExecCabec:=ExistBlock("M310CABEC")
	Local aBackCabec:={}

    
    Default xDoc := "  "
    Default xSerie := "   "

    Private lMsErroAuto := .F.
    Private aFiliais := {}
    Private _cdCnpj  := ""

    aFiliais := {}
    ConOut("Filial COrrente =>" + fwCOdFil())
    ConOut(FwCodFil() + "/" + xdFilial + "/" + cFilAnt)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega filiais da empresa corrente                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    xSM0 := SM0->(GetArea())
	dbSelectArea("SM0")
	SM0->(dbSeek(xEmpresa))
	While !Eof() .And. SM0->M0_CODIGO == cEmpAnt
		// Adiciona filial
		//If Type("aParam310") == "U" .Or. SM0->M0_CODFIL >= aParam310[03] .And. SM0->M0_CODFIL <= aParam310[04]
		Aadd( aFiliais , { SM0->M0_CODFIL, SM0->M0_CODIGO, SM0->M0_CGC, SM0->M0_INSC, SM0->M0_FILIAL})
		//EndIf
		SM0->(dbSkip())
	Enddo
    SM0->(RestArea(xSM0))

    SF2->(dbSetOrder(1))
    If !SF2->(dbSeek(xFilial("SF2") + xDoc + xSerie ))
        FwAlertError("Nota fiscal enviada não encontrada na base")
        Return Nil
    EndIf

    SD2->(dbSetOrder(3))
    If !SD2->( dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
        FwAlertError("Nota fiscal enviada não possui itens na base")
       Return Nil
    Else
       
    EndIf
    // Posiciona na Filial Destino
    if !(SF2->F2_TIPO$"B#D")
       SA1->(DbSetOrder(1))
       SA1->(dbSeek(xFilial('SA1') + SF2->F2_CLIENTE + SF2->F2_LOJA ))
       
       xCGC := SA1->A1_CGC
       xInsc:= SA1->A1_INSCR
    Else
       SA2->(DbSetOrder(1))
       SA2->(dbSeek(xFilial('SA2') + SF2->F2_CLIENTE + SF2->F2_LOJA ))
       
       xCGC := SA2->A2_CGC
       xInsc:= SA2->A2_INSCR
    EndIf
    
    
    _cdCnpj  := SM0->M0_CGC
    _cdIE := Alltrim(SM0->M0_INSC)

    xPos := aScan(aFiliais, {|v| v[3] == xCGC .And. Alltrim(v[4]) == Alltrim(xInsc) })
    if xPos > 0
        xFilDestino := aFiliais[xPos][01]

        //Transferencia
        //Posiciona no Fornecedor para Entrada
        SA2->(dbSetOrder(3))
        lFound := SA2->(dbSeek(xFilial("SA2") + Padr(_cdCnpj, TAMSX3("A2_CGC")[01] )))
        if lFound
            while SA2->A2_FILIAL + SA2->A2_CGC == xFilial("SA2")+PADR(_cdCnpj, TAMSX3("A2_CGC")[01] )
                If Alltrim(SA2->A2_INSCR) == _cdIE .And. SA2->A2_MSBLQL != '1'
                    lFound := .T.
                    Exit
                EndIf
                SA2->(dbSkip())
            EndDo
        EndIf

        If !lFound
            Aviso('Atencao','O Fornecedor : ' + _cdNome + Chr(13) + Chr(10) + ;
            ' de CNPJ: '+ transform(_cdCnpj,"@R 99.999.999/9999-99") + Chr(13) + Chr(10) + ;
            " Nao Encontrado na Base, Necessario Cadastra-lo! ",{'OK'} , 3)
            Return .F.
        EndIf 
    Else
      Return Nil
      // Nao Existe no SM0 não e transferencia 
    EndIf

    //xPosD := aScan(aFiliais, {|v| v[3]==SA2->A2_CGC .And. Alltrim(v[4])==Alltrim(SA2->A2_INSCR) })
    
    SF2->(dbSetOrder(1))
    //If SF2->(dbSeek(xFilial("SF2") + xDoc + xSerie + xCliente + xLoja ))
    lUpdate := .T.
    if lUpdate
       SF2->(RecLock('SF2',.F.))
         SF2->F2_FILDEST := xFilDestino
         SF2->F2_FORDES  := SA2->A2_COD
         SF2->F2_LOJADES := SA2->A2_LOJA
         SF2->F2_FORMDES := "N"
       SF2->(MsUnlock())
    EndIf
    //EndIf

    //u_AAVldCliFor("SA1", SD2->D2_FILIAL,.F.)
    ConOUt("[KOFATP90] Montando SD1 COM BASE NO SD2")
    //SD2->(dbSetOrder(21))
    SD2->(dbOrderNickName("TRANSF"))
    //ConOUt("[KOFATP90] ")
    If SD2->( dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
        xKey := SD2->D2_FILIAL+SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA
        // Cabecalho da nota fiscal de entrada
        nItem   :=0
        aCabec   := {}
        aadd(aCabec,{"F1_TIPO"   ,"N"})
        aadd(aCabec,{"F1_FORMUL" ,"N"})
        aadd(aCabec,{"F1_DOC"    ,SD2->D2_DOC})
        aadd(aCabec,{"F1_SERIE"  ,SD2->D2_SERIE})
        aadd(aCabec,{"F1_EMISSAO",dDataBase})
        aadd(aCabec,{"F1_FORNECE",SA2->A2_COD})
        aadd(aCabec,{"F1_LOJA"   ,SA2->A2_LOJA})
        
        aadd(aCabec,{"F1_ORIG"   ,xFilAtual})
        aadd(aCabec,{"F1_CLIORI" ,SA1->A1_COD})
        aadd(aCabec,{"F1_LOJAORI",SA1->A1_LOJA})
        //
        aadd(aCabec,{"F1_ESPECIE","SPED"}) //aadd(aCabec,{"F1_ESPECIE","NFE"}) Alterado Por Hely para grava a ESPECIE correta (SPED)
        aadd(aCabec,{"F1_COND"   , "001" })
        //???????????????????????????????????????
        //? Ponto de entrada para ALTERAR os dados do cabecalho do Documento Entrada ?
        //???????????????????????????????????????
        If lExecCabec
            aBackCabec:=ACLONE(aCabec)
            aCabec:=ExecBlock("M310CABEC",.F.,.F.,{If(lPreNota,"MATA140","MATA103"),aCabec})
            If ValType(aCabec) # "A"
                aCabec:=ACLONE(aBackCabec)
            EndIf
        EndIf
        // Itens da nota fiscal de entrada
        aItens   := {}
        //u_AAFVNX01(cLogName,"Posicionando nos Itens de Saida")
        While !SD2->(Eof()) .And. xKey == SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA
            // Incrementa regua de processamento
            IncProc()
            SF4->(dbSetOrder(1))
            SC6->(dbSetOrder(1))
            SC6->( dbSeek(xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEM + SD2->D2_COD) )
            lSF4 := SF4->(dbSeek(xFilial('SF4') + SD2->D2_TES))
            ConOut("[KOFATP90-00] PROCESSANDO ITEM "+ SD2->D2_ITEM)
            ConOut("[KOFATP90-01] PROCESSANDO ITEM DE VENDA => "+ xKey)
            if !lSF4 
               ConOut("[KOFATP90-02] TES "+SD2->D2_TES+" NAO ENCONTRADA ")
            EndIf
            cGrade:="N"
            aLinha := {}
            cProdRef:=SD2->D2_COD
            lReferencia:=MatGrdPrrf(@cProdRef,.T.)
            If lReferencia
                nAchou:=AScan(aColsAux,{|x|x[1]==cProdRef.and. x[2]=="01"})
                If nAchou >0
                    nItem:=AcolsAux[nAchou,3]
                    nItgrd ++
                Else
                    nItem++
                    nItgrd:=1
                    aadd(aColsAux,{cProdRef,"01",nItem,nItGrd})
                Endif
                cGrade:="S"
            Else
                nItem++
            Endif
            aadd(aLinha,{"D1_ITEM" ,Strzero(nItem,4),Nil})
            aadd(aLinha,{"D1_COD"  ,SD2->D2_COD,Nil})
            aadd(aLinha,{"D1_QUANT",SD2->D2_QUANT,Nil})
            aadd(aLinha,{"D1_VUNIT",SD2->D2_PRCVEN,Nil})
            aadd(aLinha,{"D1_TOTAL",SD2->D2_TOTAL,Nil})
            //-- Pesquisa armazem destino
            aadd(aLinha,{"D1_LOCAL"	,"01"	     ,Nil})
            
            aadd(aLinha,{"D1_GRADE",cGrade,Nil})
            aadd(aLinha,{"D1_ITEMGRD",If(cGrade=="S",Strzero(nItGrd,2)," "),Nil})
            // Checa geracao de documento
            If !lPreNota
                aadd(aLinha,{"D1_TES",aParam310[15],Nil})
            EndIf
            
            // Checa se utiliza rastreabilidade
            cFilBkp := cFilAnt
            cFilant := xFilDestino
            If Rastro(SD2->D2_COD,"L")
                if  !Empty(SD2->D2_LOTECTL) .OR. !Empty(SD2->D2_DTVALID)
                    aadd(aLinha,{"D1_LOTECTL",SD2->D2_LOTECTL,Nil})
                    aadd(aLinha,{"D1_DTVALID",SD2->D2_DTVALID,Nil})
                Else
                    aadd(aLinha,{"D1_LOTECTL",SC6->C6_LOTECTL,Nil})
                    aadd(aLinha,{"D1_DTVALID",SC6->C6_DTVALID,Nil})
                EndIf
            EndIf
            If Rastro(SD2->D2_COD,"S")

                aadd(aLinha,{"D1_NUMLOTE",SD2->D2_NUMLOTE,Nil})
                aadd(aLinha,{"D1_DTVALID",SD2->D2_DTVALID,Nil})
            EndIf
            cFilAnt := cFilBkp
            // Se For TES de Transferencia de Filiais Adiciona Item para gerar pre-Nota
            ConOut("[KOFATP90-04] VALIDANDO F4_TRANFIL => '" + SF4->F4_TRANFIL + "'" )
            If SF4->F4_TRANFIL == '1'
               ConOut("[KOFATP90-05] ADICIONANDO ITEM AO VETOR DE ENTRADA" )
               aAdd(aItens,aLinha)
               ConOut("[KOFATP90-06] Total de Linhas = " + Alltrim(Str(Len(aItens))) )
            EndIf

            dbSelectArea("SD2")
            SD2->(dbSkip())
        End
        // Caso tenha itens e cabecalho definidos
        ConOut("[KOFATP90-07] Verificando se há Itens Haptos = " + Alltrim(Str(Len(aItens))) )
        If Len(aItens) > 0 .And. Len(aCabec) > 0
            // Atualiza para a filial destino
            cFilant := xFilDestino
            // Reinicializa ambiente para o fiscal
            If MaFisFound()
                MaFisEnd()
            EndIf
            //?????????????????????????????????
            //? Ponto de entrada para ALTERAR os dados do pedido de vendas   ?
            //?????????????????????????????????
            If lExecItens
                aBackItens:=aClone(aItens)
                aItens:=ExecBlock("M310ITENS",.F.,.F.,{If(aParam310[14] == 1,"MATA140","MATA103"),aItens})
                If ValType(aItens) # "A"
                    aItens:=aClone(aBackItens)
                EndIf
            EndIf
            // Atribui o m?dulo 4 (Estoque) para n? ocorrer erro nas rotinas abaixo
            nAux := nModulo
            nModulo := 4

            //MATA140(aCabec,aItens,3)
            
            // Checa geracao de documento
            If !lPreNota
                //u_AAFVNX01(cLogName,"Incluindo NF de Entrada")
                // Inclui nota de entrada
                //ConOut("Gerando Pre Nota")
                ConOut("[KOFATP90-08] Gerando Nota de Entrada, via Rotina Automatica"  )
                MATA103(aCabec,aItens,3)
            Else
                //u_AAFVNX01(cLogName,"Incluindo Pre Nota de Entrada")
                // Inclui pre-nota
                ConOut("[KOFATP90-08] Gerando Pre Nota de Entrada, via Rotina Automatica")
                MATA140(aCabec,aItens,3)
            EndIf
            
            // Volta o m?dulo 4 (Estoque) ap?s a grava?? da nota de entrada
            nModulo := nAux
            // Checa erro de rotina automatica
            If lMsErroAuto
                lMostraErro	:=.T.
                //ConOut("Fuck!")
                ConOut("[KOFATP90-09] Erro ao Gera NF")
            EndIf
                // Atualiza para a filial origem
                //ConOut("Retornando para Filial de Origem")
                ConOut("[KOFATP90-10] Retornando para Filial de Origem")
                //ConOut("Retornando para Filial de Origem")
                ConOut(FwCodFil() + "/" + xdFilial + "/" + cFilAnt)
                cFilant := xdFilial
                ConOut("Retorna")
                ConOut(FwCodFil() + "/" + xdFilial + "/" + cFilAnt)
            EndIf
        else
            ConOut("[KOFATP90-07] Sem Itens Haptos para geração de NF de Entrada " )
        EndIf
    SM0->(RestArea(xSM0))
    ConOut(FwCodFil() + "/" + xdFilial + "/" + cFilAnt)
Return Nil



/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAVldCliFor¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 25/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida o cliente e fornecedor da transferência                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

/*
User Function AAVldCliFor(cAlias,cCodFil)

	Local nPos
	Local aAreaSM0 := SM0->(GetArea())
	Local lRet     := .F.

	Default _lArm13 := .F.

	If Type("aFiliais") == "U"  // Caso não tenha carregado as filiais
		aFiliais := {}
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega filiais da empresa corrente                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SM0")
		dbSeek(cEmpAnt)
		While !Eof() .And. SM0->M0_CODIGO == cEmpAnt
			// Adiciona filial
			//If Type("aParam310") == "U" .Or. SM0->M0_CODFIL >= aParam310[03] .And. SM0->M0_CODFIL <= aParam310[04]
			Aadd( aFiliais , { SM0->M0_CODFIL, SM0->M0_CODIGO, SM0->M0_CGC, SM0->M0_INSC, SM0->M0_FILIAL})
			//EndIf
			SM0->(dbSkip())
		Enddo
		RestArea(aAreaSM0)
	Endif

	nPos := AScan( aFiliais , {|x| x[1] == cCodFil } )

	(cAlias)->(dbSetOrder(3))

	cwFil := xFilial(cAlias)
	cwCgc := Padr( aFiliais[nPos,3],TAMSX3("A1_CGC")[01]  )
	cwIns := Padr( aFiliais[nPos,4],TAMSX3("A1_INSCR")[01] )

	cwCp1 := cAlias+"->"+SubStr(cAlias,2,2) + "_INSCR"
	cwCp2 := cAlias+"->"+SubStr(cAlias,2,2) + "_FILIAL"
	cwCp3 := cAlias+"->"+SubStr(cAlias,2,2) + "_CGC"
	cwCp4 := cAlias+"->"+SubStr(cAlias,2,2) + "_COD"
	cwCp5 := cAlias+"->"+SubStr(cAlias,2,2) + "_LOJA"

	//If lRet := (nPos > 0 .And. (cAlias)->(dbSeek(xFilial(cAlias)+Substr(aFiliais[nPos,3],1,Len(SA1->A1_CGC)))) )
	If lRet := ( nPos > 0 .And. (cAlias)->(  dbSeek( cwFil + cwCgc )  ) )
		// adicionado por wermeson
		lwRet := .F.
		While !(cAlias)->(Eof()) .And. (cwFil + cwCgc == &cwCp2+ &cwCp3) .And. !lwRet
			If cwIns == &cwCp1 .And. Alltrim(SuperGetMv("MV_XCLIDEP",.F.,"")) != (cAlias)->&cwCp4
				lwRet := .T.
			Else
				(cAlias)->(dbSkip())
			EndIf
		EndDo

		If !lwRet
			If cAlias == "SA1"
				// Nao existem dados da filial destino cadastrados como cliente na filial origem. A transferencia nao sera realizada
				Help(" ",1,"A310DATFL1")
			Else
				// Nao existem dados da filial origem cadastrados como fornecedor na filial destino. A transferencia nao sera realizada
				Help(" ",1,"A310DATFL2")
			Endif
		else
			lRet := lwRet
		EndIf

	Else
		If cAlias == "SA1"
			// Nao existem dados da filial destino cadastrados como cliente na filial origem. A transferencia nao sera realizada
			Help(" ",1,"A310DATFL1")
		Else
			// Nao existem dados da filial origem cadastrados como fornecedor na filial destino. A transferencia nao sera realizada
			Help(" ",1,"A310DATFL2")
		Endif
	Endif

Return lRet
*/
