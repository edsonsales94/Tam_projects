#Include "Protheus.ch"
#Include "TOPCONN.CH"

// ---------------------------------------------------------
/*/
Função SF2460I
Ponto de entrada na Geração do Documento de Saida.
- Grava Informações do Chassi / Motor

/*/
// ---------------------------------------------------------
User Function SF2460I()
	Local aArea     := GetArea()
	Local aAreaD2   := SD2->(GetArea())
	Local cQuery    := ""
	Local nPesoL    := 0
    Local iNfmoto   := "" 
	Local nTam		:= TamSX3("C6_INFAD")[1] 
	Local nPesoB    := 0
	Local nxVol     := 0
	Local cxSuppLog := SuperGetMV("MV_XSUPPLOG", .F., "00030501")
	Local cXespecie := ''
	Local nAnoFabr  := ''
	Local cVerPed   := ''
	
	If SF2->F2_CLIENTE+SF2->F2_LOJA == cxSuppLog
		fxEntrePosto()
	EndIf
	
	cQuery += " Select SC6.C6_NUM, SC6.C6_ITEM, SC6.C6_PRODUTO, SB1.B1_XTEMCM,SC5.C5_PBRUTO,SC5.C5_PESOL,SC5.C5_ESPECI1,SC5.C5_VOLUME1, SB1.B1_XTPCOMB, SB1.B1_XCMT3,SB1.B1_XDESCCO,"
	cQuery += "       SB1.B1_XCCOR, SB1.B1_XPOT, SB1.B1_PESO, SB1.B1_PESBRU, SB1.B1_TIPO, SC6.C6_XNUMSER,SB1.B1_XANOFAB, "
	cQuery += "       SB1.B1_XANOMOD, SB1.B1_XTPVEIC, SB1.B1_XESPVEI, SB1.B1_XNSERIE, SB1.B1_XCRTVL, "
	cQuery += "       SB1.B1_XLOTAMX, SB1.B1_XCILIN ,  SB1.B1_XTPPINT, SB1.B1_XCORDNT, SB1.B1_XDIST,SB1.B1_XCMOD, "
	cQuery += "       SF2.F2_DOC, SF2.F2_SERIE ,  SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_PLIQUI,SF2.F2_PBRUTO,SB1.B1_XRENAVA, SC6.C6_XVIN, SC6.C6_XMOTOR,    "
	cQuery += "       SD2.D2_ITEM, SD2.D2_QUANT, SF2.F2_ESPECIE, SC5.C5_NUM, SC5.C5_STATUS,SC5.C5_XRODAGE,SC6.C6_XDFABR,SC5.C5_XVERSAO"
	cQuery += "       from " + RetSqlName("SD2") + " SD2
	
	cQuery += "	   INNER JOIN  " + RetSqlName("SF2") + " SF2 ON SF2.D_E_L_E_T_ = '' AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_FILIAL =  D2_FILIAL AND F2_DOC =  D2_DOC AND F2_SERIE = D2_SERIE "
	cQuery += "	   INNER JOIN  " + RetSqlName("SC6") + "  SC6 ON SC6.D_E_L_E_T_ = '' AND C6_CLI = D2_CLIENTE AND C6_LOJA = D2_LOJA AND C6_FILIAL = D2_FILIAL AND C6_NOTA = D2_DOC AND C6_SERIE = D2_SERIE "
	cQuery += "	   INNER JOIN  " + RetSqlName("SC5") + " SC5 ON SC5.D_E_L_E_T_='' AND C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM "
	cQuery += "	   LEFT OUTER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ''AND  D2_COD = B1_COD AND  B1_FILIAL = D2_FILIAL "
	
	cQuery += "     where SD2.D_E_L_E_T_ = '' "
	cQuery += "     and D2_SERIE   = '" + SF2->F2_SERIE + "'"
	cQuery += "     and D2_FILIAL  = '" + FWxFilial("SD2") + "'"
	cQuery += "     and D2_DOC     = '" + SF2->F2_DOC + "'"
	



	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QSC6",.F.,.F.)

	While !QSC6->(Eof())
		
		//LIMPA STATUS DO PEDOUT NO FIM DO CICLO
		IF SC5->(dbSeek(XFILIAL("SC5")+QSC6->C5_NUM )) .AND. ALLTRIM(QSC6->C5_STATUS) = "T"
			reclock("SC5",.F.)
			SC5->C5_STATUS  := ""
			MSUNLOCK()
		endif 


		SZ1->(dbSetOrder(1))
		SZ1->(dbSeek(XFILIAL("SZ1")+QSC6->C6_XVIN))
				
		// -- Verificar se requer Chassi e Numero Motor
	    If QSC6->B1_XTEMCM == "S" 
			nPesoL 		 +=  QSC6->B1_PESO
			nPesoB	 	 +=  QSC6->B1_PESBRU
			cXespecie	 = "VOLUME"
			nAnoFabr     := Year(SZ1->Z1_DTINCLU)

		ENDIF
		
		If QSC6->B1_XCRTVL == 'S'
			nxVol += 1
		EndIf
		
		If QSC6->B1_XTEMCM == "S" //.AND. QSC6->B1_TIPO = 'PA'
				DbSelectArea("CD9")
				DbSetOrder(1) //
				If !dbSeek(xFilial()+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+QSC6->D2_ITEM+QSC6->C6_PRODUTO)
				// --- Gravar Complemento da NF para Livro Fiscal
				// ----------------------------------------------
						Reclock("CD9",.T.)
						CD9->CD9_FILIAL	:= FWxFilial("CD9")
						CD9->CD9_TPMOV	:= "S"
						CD9->CD9_DOC	  := QSC6->F2_DOC
						CD9->CD9_SERIE  := QSC6->F2_SERIE
						CD9->CD9_ESPEC  := QSC6->F2_ESPECIE
						CD9->CD9_CLIFOR	:= QSC6->F2_CLIENTE
						CD9->CD9_LOJA	  := QSC6->F2_LOJA
						CD9->CD9_ITEM   := QSC6->D2_ITEM
						CD9->CD9_COD    := QSC6->C6_PRODUTO
						CD9->CD9_TPOPER := "0"
						CD9->CD9_CHASSI := QSC6->C6_XVIN
						CD9->CD9_CODCOR := QSC6->B1_XCCOR
						CD9->CD9_DSCCOR := QSC6->B1_XDESCCO	
						CD9->CD9_POTENC := QSC6->B1_XPOT
						CD9->CD9_CILIND := QSC6->B1_XCILIN 
						CD9->CD9_PESOLI := QSC6->B1_PESO
						CD9->CD9_PESOBR := QSC6->B1_PESBRU

						IF SB1->B1_TIPO == 'ME'
						CD9->CD9_SERIAL := SUBSTR(QSC6->C6_XVIN,4,6) + SUBSTR(QSC6->C6_XVIN,12,17) 
						ELSE
						CD9->CD9_SERIAL := QSC6->C6_XNUMSER
						ENDIF
						
						CD9->CD9_TPCOMB := QSC6->B1_XTPCOMB
						CD9->CD9_NMOTOR := QSC6->C6_XMOTOR
						CD9->CD9_CM3POT := QSC6->B1_XCMT3  
						CD9->CD9_DISTEI := QSC6->B1_XDIST


					IF QSC6->C5_XRODAGE ='1'
				    	CD9->CD9_ANOFAB := VAL(LEFT(QSC6->C6_XDFABR,4))
						CD9->CD9_ANOMOD := VAL(LEFT(QSC6->C6_XDFABR,4))
					ELSE
						CD9->CD9_ANOFAB  := nAnoFabr 
					ENDIF
				
						
						IF SUBSTR(QSC6->C6_XVIN,10,1) == "P"
						CD9->CD9_ANOMOD := VAL("2023")
						endif
						IF SUBSTR(QSC6->C6_XVIN,10,1) == "R"
						CD9->CD9_ANOMOD := VAL("2024")
						endif
						IF SUBSTR(QSC6->C6_XVIN,10,1) == "S"
						CD9->CD9_ANOMOD := VAL("2025")
						endif
						if SUBSTR(QSC6->C6_XVIN,10,1) == "T"
						CD9->CD9_ANOMOD := VAL("2026")
						endif
						if SUBSTR(QSC6->C6_XVIN,10,1) == "V"
						CD9->CD9_ANOMOD := VAL("2027")
						endif
						IF SUBSTR(QSC6->C6_XVIN,10,1) == "W"
						CD9->CD9_ANOMOD := VAL("2028")
						endif
						if SUBSTR(QSC6->C6_XVIN,10,1) == "X"
						CD9->CD9_ANOMOD := VAL("2029")
						ENDIF

						CD9->CD9_TPPINT := QSC6->B1_XTPPINT
						CD9->CD9_TPVEIC := QSC6->B1_XTPVEIC
						CD9->CD9_ESPVEI := QSC6->B1_XESPVEI
						CD9->CD9_CONVIN := "N"
						CD9->CD9_CONVEI := "1"
						CD9->CD9_CODMOD := QSC6->B1_XCMOD
						CD9->CD9_RENAVA := QSC6->B1_XRENAVA  
						CD9->CD9_CORDE  := QSC6->B1_XCORDNT
						CD9->CD9_LOTAC  := QSC6->B1_XLOTAMX
						CD9->CD9_RESTR  := "0"
						CD9->CD9_TRACAO := "100"
						CD9->CD9_SDOC   := QSC6->F2_SERIE
						
						CD9->(MsUnlock())
				Endif			

		EndIf

		//GRAVAÇÃO DA VERSÃO_PEDOUT 
		IF SF2->F2_FILIAL =="03"                                           
			//cVerPed := Alltrim(str(val(SC5->C5_NUM))) + (SC5->C5_XVERSAO)
			cVerPed := iif(Empty(SC5->C5_XORDSEP),Alltrim(str(val(SC5->C5_NUM))) + (SC5->C5_XVERSAO),SC5->C5_XORDSEP)
		ENDIF

		QSC6->(dbSkip())

	EndDo




    If nPesoL > 0 .and. nPesoB > 0
		Reclock("SF2",.F.)
		 SF2->F2_PLIQUI := nPesoL
		 SF2->F2_PBRUTO := nPesoB
		SF2->(MsUnlock())
	EndIf

	If SF2->F2_FILIAL =="03"
		Reclock("SF2",.F.)
		SF2->F2_ORDSEP   := cVerPed
		SF2->F2_XCONFSE  := cVerPed
		SF2->(MsUnlock())
	EndIf
	
	If nxVol == 1
		Reclock("SF2",.F.)
		 SF2->F2_VOLUME1 := nxVol
		 SF2->F2_ESPECI1 := cXespecie
		SF2->(MsUnlock())
	EndIf 

	QSC6->(dbCloseArea())
	RestArea(aArea)
	RestArea(aAreaD2)
Return



//envia saldo para entreposto
Static Function fxEntrePosto()
Local nX     := 0
Local axArea := FWGetArea()
Local aAuto  := {}
Local aItem  := {}
Local cxAPA  := SuperGetMV("MV_XARMPA", .F., "10")
Local cxTran := SuperGetMV("MV_XARMTR", .F., "20")
Local cxEndP := SuperGetMV("MV_XLOCPA", .F., " ")
Local cxEndS := SuperGetMV("MV_XLOCTR", .F., " ")
Local cxDocs := GetSxeNum("SD3","D3_DOC")

Private lMsErroAuto := .f.
ConfirmSx8()

//Cabecalho a Incluir
aadd(aAuto,{cxDocs,dDataBase}) //Cabecalho

//Itens a Incluir 
aItem := {}

SD2->(dbSetOrder(3))
SD2->(dbSeek(SF2->(F2_FILIAL + F2_DOC + F2_SERIE)))
	
While SD2->(!EOF()) .And. SF2->F2_FILIAL == SD2->D2_FILIAL .AND. SF2->F2_DOC == SD2->D2_DOC .AND. SF2->F2_SERIE == SD2->D2_SERIE
	aLinha := {}
	nX += 1
	//Origem 
	SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
	aadd(aLinha,{"ITEM"      ,'00'+cvaltochar(nX),Nil})
	aadd(aLinha,{"D3_COD"    , SB1->B1_COD     , Nil}) //Cod Produto origem 
	aadd(aLinha,{"D3_DESCRI" , SB1->B1_DESC    , Nil}) //descr produto origem 
	aadd(aLinha,{"D3_UM"     , SB1->B1_UM      , Nil}) //unidade medida origem 
	aadd(aLinha,{"D3_LOCAL"  , SD2->D2_LOCAL   , Nil}) //armazem origem 

	aadd(aLinha,{"D3_LOCALIZ", cxEndP          , Nil}) //Informar endereço origem

	aadd(aLinha,{"D3_LOCALIZ", cxEndP          , Nil}) //Informar endereÃ§o origem


	aadd(aLinha,{"D3_COD"    , SB1->B1_COD     , Nil}) //cod produto destino 
	aadd(aLinha,{"D3_DESCRI" , SB1->B1_DESC    , Nil}) //descr produto destino 
	aadd(aLinha,{"D3_UM"     , SB1->B1_UM      , Nil}) //unidade medida destino 
	aadd(aLinha,{"D3_LOCAL"  , cxTran          , Nil}) //armazem destino 

	aadd(aLinha,{"D3_LOCALIZ", cxEndS          , Nil}) //Informar endereço destino

	aadd(aLinha,{"D3_LOCALIZ", cxEndS          , Nil}) //Informar endereÃ§o destino


	aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
	aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
	aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
	aadd(aLinha,{"D3_DTVALID", '', Nil}) //data validade 
	aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
	aadd(aLinha,{"D3_QUANT"  , SD2->D2_QUANT  , Nil}) //Quantidade
	aadd(aLinha,{"D3_QTSEGUM", SD2->D2_QTSEGUM, Nil}) //Seg unidade medida
	aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno 
	aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ

	aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
	aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino 
	aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
	aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade

	aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
	aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino 

	aAdd(aAuto,aLinha)

	SD2->(dbSkip())
		
EndDo

MSExecAuto({|x,y| mata261(x,y)},aAuto,3)

if lMsErroAuto 
	MostraErro()
else
	reclock('SF2',.F.)
	SF2->F2_XOBS    := cxDocs + "-" + SD3->D3_DOC
	SF2->F2_XSTATUS := 'N'

	MSUNLOCK()	
	qout(cxDocs)
EndIf

Return !lMsErroAuto

