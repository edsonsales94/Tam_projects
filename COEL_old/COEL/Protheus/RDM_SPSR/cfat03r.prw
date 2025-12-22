#include "rwmake.ch"

User Function Cfat03r()

SetPrvt("TAMANHO,NLIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,_CCLASANT,_CMENSAG1")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XCLIENTE,XLOJA")
SetPrvt("XFRETE,XSEGURO,XDESPACESS,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS")
SetPrvt("XICMS_RET,XVALOR_IPI,XVALOR_MERC,XNUM_DUPLIC,XPREF_DUPLIC,XCOND_PAG")
SetPrvt("XPBRUTO,XPLIQUI,XTIPO,XESPECIE,XVOLUME,XVALOR_ISS")
SetPrvt("XBASE_ISS,XCOD_VEND,XBASES_DIF,XVALOR_DIF,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XTESPROD,XDESC_ZFR")
SetPrvt("XISS,XIMPR_ICM,XIMPR_IPI,XCOD_TRIB,NELEM,XPESO_PRO")
SetPrvt("XPESO_UNIT,XDESCRICAO,XUNID_PRO,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XTIPO_PRO,XLUCRO,XCLFISCAL,XOBS_FISC,XPESO_LIQ")
SetPrvt("I,XPESO_LIQUID,XPESO_BRUTO,XP_LIQ_PED,XPED,XPEDCLI")
SetPrvt("XDESC_PRO,XMENSAGEM,XTIPO_CLI,XCOD_MENS,XTPFRETE,XCONDPAG")
SetPrvt("XDESC_NF,XDESC_PAG,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI,XINSC_CLI,XTRAN_CLI")
SetPrvt("XTEL_CLI,XFAX_CLI,XREG_CLI,XCOB_CLI,XCOB_MUN,XCOB_EST")
SetPrvt("XREC_CLI,XREC_MUN,XREC_EST,XREC_CGC,XREC_INS,XSUFRAMA")
SetPrvt("XCALCSUF,ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP")
SetPrvt("XMUN_TRANSP,XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP")
SetPrvt("XVENC_DUP,XVALOR_DUP,XDUPLICATAS,XNATUREZA,NAA,XFORNECE")
SetPrvt("XNFORI,XPEDIDO,XPESOPROD,NVALTOT,XFAX,NOPC,_cTemp1")
SetPrvt("CCOR,NTAMDET,XB_ICMS_SOL,XV_ICMS_SOL,XLIN_ISS,XZFR_TOTAL")
SetPrvt("NCONTR_ADD,NCONTR_DUP,NCONTR_ISS,XLINHASAD,CTEXTOADD,NNOVALI")
SetPrvt("NCONT,NCONTR,NCONTR1,NTAMANHO,NQTD_ADD,aEstru1")
SetPrvt("XMUN_TRANSP1,XEST_TRANSP1,XVIA_TRANSP1,XCGC_TRANSP1,XTEL_TRANSP1,XNOME_TRANSP,XEND_TRANSP")

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁPrograma  Ё  Nfiscal Ё Autor Ё Alberto N. G. Junior  Ё Data Ё 28/09/99 Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё Nota Fiscal de Entrada/Saida                               Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       Ё Especifico para COEL Controles El┌tricos                   Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

╝------------------------------------------------------------------------╝
|AlteraГЦo: By Rogerio, ImpressЦo de NF por Manaus, quanto a transporta  |
|29/09/03   dora, foi criado o campo C5_X_TRANS que quando preenchido    |
|           serА identificado que o pedido tem redespacho, e este campo  |
|           serА impresso como o transportador e o campo padrЦo C5_TRANSP|
|           serА impresso na Obs. da NF como Redespacho                  |
|                                                                        |
╝------------------------------------------------------------------------╝
/*/
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para parametros                         Ё
//Ё mv_par01             // Da Nota Fiscal                       Ё
//Ё mv_par02             // Ate a Nota Fiscal                    Ё
//Ё mv_par03             // Da Serie                             Ё
//Ё mv_par04             // Nota Fiscal de Entrada/Saida         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

tamanho:= "G"
nLimite:= 220
titulo := PADC("Nota Fiscal - Nfiscal",74)
cDesc1 := PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2 := ""
cDesc3 := PADC("da Nfiscal",74)
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "nfiscal"
cPerg     := "NFSIGW"
nLastKey  := 0
lContinua := .T.
nLin      := 0
wnrel     := "siganf"
nTamNf    := 72        // Apenas Informativo - Tamanho do Formulario (LINHAS)
cString   := "SF2"
_cClasAnt := {}
_cMensag1 := ""


// *** Verifica as perguntas selecionadas, busca o padrao da Nfiscal
Pergunte( cPerg, .F. )

// *** Envia controle para a funcao SETPRINT
wnrel := SetPrint( cString, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .T. )

If nLastKey == 27
	Return
Endif

// *** Verifica Posicao do Formulario na Impressora
SetDefault( aReturn, cString )

If nLastKey == 27
	Return
Endif

VerImp()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicio do Processamento da Nota Fiscal                       Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

// *** Inicializa regua de impressao
If mv_par04 == 2
	RptStatus({|| RptSaida()})
ElseIf mv_par04 == 1
	RptStatus({|| RptEntra()})
EndIf

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	OurSpool( wnrel )
EndIf

MS_FLUSH()

Return

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    Ё RptSaida Ё Autor Ё Alberto N. G. Junior  Ё Data Ё 28/09/99 Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё Manipula┤фo de Dados para impressфo NF de sa║da COEL       Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       Ё CLNFISC.PRX - Rdmake Nota Fiscal COEL                      Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/

Static Function RptSaida()


*----------------------------------------------------------------------------*
* Cria um vetor com a estrutura do arquivo temporario                        *
*----------------------------------------------------------------------------*
If SM0->M0_CODIGO == "03"
	_cTemp1 := CriaTrab( NIL, .F. )
	
	aEstru1 :={} // Transportadora a ser tratada por Manaus
	AADD(aEstru1,{"NOME"    ,"C",40,0})
	AADD(aEstru1,{"END"     ,"C",40,0})
	AADD(aEstru1,{"MUN"     ,"C",15,0})
	AADD(aEstru1,{"EST"     ,"C",2 ,0})
	AADD(aEstru1,{"VIA"     ,"C",15,0})
	AADD(aEstru1,{"CGC"     ,"C",14,0})
	AADD(aEstru1,{"CEP"     ,"C",8 ,0})
	AADD(aEstru1,{"TEL"     ,"C",15,0})
	
	DbCreate(_cTemp1,aEstru1)
	dbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. )
EndIf

DbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
DbSetOrder(3)

DbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
DbSetOrder(1)
DbSeek( xFilial("SF2") + mv_par01 + mv_par03 )
setregua(99)

Do While !Eof() .AND. xFilial("SF2")==SF2->F2_FILIAL .AND. SF2->F2_DOC <= mv_par02 .AND. lContinua
	
	If lAbortPrint
		@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
		lContinua := .F.
		Exit
	Endif
	
	If SF2->F2_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
		DbSkip()                    // do Parametro Informado !!!
		Loop
	Endif
	
	// *** Cabecalho da Nota Fiscal
	
	xNUM_NF     := SF2->F2_DOC             // Numero
	xSERIE      := SF2->F2_SERIE           // Serie
	xEMISSAO    := SF2->F2_EMISSAO         // Data de Emissao
	xTOT_FAT    := SF2->F2_VALBRUT         // Valor Total da Fatura
	If xTOT_FAT == 0
		xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
	EndIf
	xCLIENTE    := SF2->F2_CLIENTE         // Codigo do Cliente
	xLOJA       := SF2->F2_LOJA            // Loja do Cliente
	xFRETE      := SF2->F2_FRETE           // Frete
	xSEGURO     := SF2->F2_SEGURO          // Seguro
	xDESPACESS  := SF2->F2_DESPESA         // Despesas acessorias
	xBASE_ICMS  := SF2->F2_BASEICM         // Base   do ICMS
	xBASE_IPI   := SF2->F2_BASEIPI         // Base   do IPI
	xVALOR_ICMS := SF2->F2_VALICM          // Valor  do ICMS
	xICMS_RET   := SF2->F2_ICMSRET         // Valor  do ICMS Retido
	xVALOR_IPI  := SF2->F2_VALIPI          // Valor  do IPI
	xVALOR_MERC := SF2->F2_VALMERC         // Valor  da Mercadoria
	xNUM_DUPLIC := SF2->F2_DUPL            // Numero da Duplicata
	If SM0->M0_CODIGO == "03"
		xPREF_DUPLIC:= SF2->F2_SERIE
	Else
		xPREF_DUPLIC:= iif(SM0->M0_CODFIL == "01","SPO","SRE")
	EndIf
	xCOND_PAG   := SF2->F2_COND            // Condicao de Pagamento
	xPBRUTO     := SF2->F2_PBRUTO          // Peso Bruto
	xPLIQUI     := SF2->F2_PLIQUI          // Peso Liquido
	xTIPO       := SF2->F2_TIPO            // Tipo do Cliente
	xESPECIE    := SF2->F2_ESPECI1         // Especie 1 no Pedido
	xVOLUME     := SF2->F2_VOLUME1         // Volume 1 no Pedido
	xVALOR_ISS  := SF2->F2_VALISS          // Valor ISS
	xBASE_ISS   := SF2->F2_BASEISS         // Base P/ ISS
	xCOD_VEND   := { SF2->F2_VEND1 }       // Codigo do Vendedor
	xCOD_TRAN   := SF2->F2_TRANSP          // Transportadora
	
	DbSelectArea("SF4")
	DbSetOrder(1)
	
	xBASES_DIF := {}           // Aliquotas ICMS diferentes
	xVALOR_DIF := {}           // Base do ICMS por aliquota
	
	DbSelectArea("SD2")                    // Itens da N.F.
	DbSeek( xFilial("SD2") + xNUM_NF + xSERIE )
	
	xPED_VEND := {}               // Numero do Pedido de Venda
	xITEM_PED := {}               // Numero do Item do Pedido de Venda
	xNUM_NFDV := {}               // Numero Quando houver Devolucao
	xPREF_DV  := {}               // Serie  quando houver devolucao
	xICMS     := {}               // Porcentagem do ICMS
	xCOD_PRO  := {}               // Codigo  do Produto
	xQTD_PRO  := {}               // Peso/Quantidade do Produto
	xPRE_UNI  := {}               // Preco Unitario de Venda
	xPRE_TAB  := {}               // Preco Unitario de Tabela
	xIPI      := {}               // Porcentagem do IPI
	xVAL_IPI  := {}               // Valor do IPI
	xDESC     := {}               // Desconto por Item
	xVAL_DESC := {}               // Valor do Desconto
	xVAL_MERC := {}               // Valor da Mercadoria
	xTES      := {}               // TES
	xCF       := {}               // Classificacao quanto natureza da Operacao
	xICMSOL   := {}               // Base do ICMS Solidario
	xICM_PROD := {}               // ICMS do Produto
	xTESPROD  := {}               // TES do Produto p/ base icms (ref. ISS gravado no mesmo campo do SD2.)
	xDESC_ZFR := {}               // Valor do Desconto Suframa do Item
	xISS      := .F.              // Flag p/ Impressao ISS
	xIMPR_ICM := {}               // Imprime .T. ou nao .F. Observ. Fiscal p/ Classificacao
	xIMPR_IPI := {}               // Imprime .T. ou nao .F. Observ. Fiscal p/ Classificacao
	xCOD_TRIB := {}            // Codigo de Tributacao
	
	Do While !Eof() .AND. SD2->D2_DOC == xNUM_NF
		
		If SD2->D2_SERIE #mv_par03
			DbSkip()
			Loop
		EndIf
		
		AADD( xPED_VEND , SD2->D2_PEDIDO )
		AADD( xITEM_PED , SD2->D2_ITEMPV )
		AADD( xNUM_NFDV , IIF( Empty(SD2->D2_NFORI), "", SD2->D2_NFORI ) )
		AADD( xPREF_DV  , SD2->D2_SERIORI )
		AADD( xICMS     , SD2->D2_PICM )
		AADD( xCOD_PRO  , SD2->D2_COD )
		AADD( xCOD_TRIB , SD2->D2_CLASFIS )
		AADD( xQTD_PRO  , SD2->D2_QUANT )
		AADD( xPRE_UNI  , SD2->D2_PRCVEN )
		AADD( xPRE_TAB  , SD2->D2_PRUNIT )
		AADD( xIPI      , SD2->D2_IPI )
		AADD( xVAL_IPI  , SD2->D2_VALIPI )
		AADD( xDESC     , SD2->D2_DESC )
		AADD( xVAL_MERC , SD2->D2_TOTAL )
		AADD( xICM_PROD , IIf( Empty(SD2->D2_PICM), 0, SD2->D2_PICM ) )
		AADD( xTESPROD  , SD2->D2_TES )
		AADD( xDESC_ZFR , SD2->D2_DESCZFR )
		
		If Ascan( xTES, SD2->D2_TES ) == 0
			AADD( xTES, SD2->D2_TES )
			AADD( xCF,  SD2->D2_CF  )
		EndIf
		
		DbSelectArea("SF4")
		DbSeek( xFilial("SF4") + SD2->D2_TES )
		
		AADD( xIMPR_ICM, Iif( F4_CREDICM=="S", .T., .F. ) )
		AADD( xIMPR_IPI, Iif( F4_CREDIPI=="S", .T., .F. ) )
		
		If SF4->F4_ISS #"S"
			// ** Se nфo h  ISS no TES, calcula bases para al║qs. do ICMS diferenciadas
			nElem := Ascan( xBASES_DIF, SD2->D2_PICM )
			If nElem == 0
				AADD( xBASES_DIF, SD2->D2_PICM  )
				AADD( xVALOR_DIF, SD2->D2_TOTAL )
			Else
				xVALOR_DIF[nElem] := xVALOR_DIF[nElem] + SD2->D2_TOTAL
			EndIf
		Else
			// ** Se h  ISS no TES, subtrai o valor do item do total das mercadorias
			xVALOR_MERC := xVALOR_MERC - SD2->D2_TOTAL
			xISS := .T.
		EndIf
		
		DbSelectArea("SD2")
		DbSkip()
		
	EndDo
	
	DbSelectArea("SB1")         // * Desc. Generica do Produto
	DbSetOrder(1)
	
	DbSelectArea("SB5")         // * Dados Adicionais do Prod
	DbSetOrder(1)
	
	DbSelectArea("SZ1")         // Classifica┤Дes Fiscais
	DbSetOrder(1)
	
	xPESO_PRO  := {}            // Peso Liquido
	xPESO_UNIT := {}            // Peso Unitario do Produto
	xDESCRICAO := {}            // Descricao do Produto
	xUNID_PRO  := {}            // Unidade do Produto
	xMEN_TRIB  := {}            // Mensagens de Tributacao
	xCOD_FIS   := {}            // Cogigo Fiscal
	xCLAS_FIS  := {}            // Classificacao Fiscal
	xMEN_POS   := {}            // Mensagem da Posicao IPI
	xTIPO_PRO  := {}            // Tipo do Produto
	xLUCRO     := {}            // Margem de Lucro p/ ICMS Solidario
	xCLFISCAL  := {}
	xOBS_FISC  := {}            // C╒digos das Observa┤Дes Fiscais
	xDESC_DCR  := {}
	xPESO_LIQ  := 0
	
	For I := 1 To Len( xCOD_PRO )
		
		DbSelectArea("SB1")
		DbSeek( xFilial("SB1") + xCOD_PRO[I] )
		
		AADD( xDESC_DCR, SB1->B1_X_DCR)
		AADD( xPESO_PRO, SB1->B1_PESO * xQTD_PRO[I] )
		xPESO_LIQ := xPESO_LIQ + xPESO_PRO[I]
		AADD( xPESO_UNIT, SB1->B1_PESO )
		AADD( xUNID_PRO , SB1->B1_UM )
		If SubStr(xCOD_PRO[I],1,2) == "00"
			DbSelectArea("SC6")
			DbSetOrder(2)
			DbSeek(xFilial("SC6")+xCOD_PRO[I]+xPED_VEND[I]+xITEM_PED[I])
			AADD(xDESCRICAO ,Subst( SC6->C6_DESCRI, 1, 30 ) )
		Else
			DbSelectArea("SB5")
			DbSeek( xFilial("SB5") + xCOD_PRO[I] )
			AADD(xDESCRICAO ,Subst( SB5->B5_CEME, 1, 57 ) )
		EndIf
		
		DbSelectArea("SB1")
		AADD( xCOD_FIS , SB1->B1_CLCLASF )
		
		If Ascan( xMEN_TRIB, SB1->B1_ORIGEM ) == 0
			AADD( xMEN_TRIB, SB1->B1_ORIGEM )
		Endif
		
		If !Empty( SB1->B1_POSIPI ) .AND. Ascan( xCLFISCAL, SB1->B1_CLCLASF ) == 0
			AADD( xCLAS_FIS, SB1->B1_POSIPI  )
			AADD( xCLFISCAL, SB1->B1_CLCLASF )
		EndIf
		
		// *** Obsevacoes Fiscais ***
		
		DbSelectArea("SZ1")
		DbSeek( xFilial("SZ1") + SB1->B1_POSIPI )
		If !Empty( SZ1->Z1_CLOBIPI )
			If Ascan( xOBS_FISC, SZ1->Z1_CLOBIPI ) == 0 .AND. xIMPR_IPI[I] == .T.
				AADD( xOBS_FISC, SZ1->Z1_CLOBIPI )
			EndIf
		EndIf
		
		If !Empty( SZ1->Z1_CLOBICM )
			If Ascan( xOBS_FISC, SZ1->Z1_CLOBICM ) == 0 .AND. xIMPR_ICM[I] == .T.
				AADD( xOBS_FISC, SZ1->Z1_CLOBICM )
			EndIf
		EndIf
		
		// *** Fim Obser. Fiscais ***
		
		AADD( xTIPO_PRO, SB1->B1_TIPO )
		AADD( xLUCRO   , SB1->B1_PICMRET )
		
		
	Next
	
	// Calculo do Peso Liquido
	
	xPESO_LIQUID := 0
	
	For I := 1 To Len( xPESO_PRO )
		xPESO_LIQUID := xPESO_LIQUID + xPESO_PRO[I]
	Next
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	
	xPESO_BRUTO := 0
	xP_LIQ_PED  := 0
	xPED        := {}
	xPEDCLI     := {}
	xDESC_PRO   := {}                          // Descricao aux do produto
	xMENSAGEM   := {}
	
	For I := 1 To Len( xPED_VEND )
		DbSeek(xFilial("SC5")+xPED_VEND[I])
		If ASCAN( xPED, xPED_VEND[I] ) == 0
			
			DbSeek( xFilial("SC5") + xPED_VEND[I] )
			AADD( xPED, xPED_VEND[I] )
			
			xPESO_BRUTO := SC5->C5_PBRUTO             // Peso Bruto
			xP_LIQ_PED  := xP_LIQ_PED + SC5->C5_PESOL // Peso Liquido
			xCLIENTE    := SC5->C5_CLIENTE            // Codigo do Cliente
			xTIPO_CLI   := SC5->C5_TIPOCLI            // Tipo de Cliente
			xCOD_MENS   := SC5->C5_MENPAD             // Codigo da Mensagem Padrao
			//xMENSAGEM   := SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
			xTPFRETE    := SC5->C5_TPFRETE            // Tipo de Entrega
			xCONDPAG    := SC5->C5_CONDPAG            // Condicao de Pagamento
			xTRANS_AM   := SC5->C5_X_TRANS            // Transportadora de Manaus
			xDESC_NF    := {SC5->C5_DESC1,;           // Desconto Global 1
			SC5->C5_DESC2,;           // Desconto Global 2
			SC5->C5_DESC3,;           // Desconto Global 3
			SC5->C5_DESC4 }           // Desconto Global 4
			
			If !Empty( SC5->C5_CLPEDCL )
				If ASCAN( xPEDCLI, SC5->C5_CLPEDCL ) == 0
					AADD( xPEDCLI, SC5->C5_CLPEDCL )  // Num. pedido no Cliente
				EndIf
			EndIf
			
			If !Empty( SC5->C5_MENNOTA )
				If ASCAN( xMENSAGEM, SC5->C5_MENNOTA ) == 0
					AADD( xMENSAGEM, SC5->C5_MENNOTA )  // Mensagem para Nota
				EndIf
			EndIf
			
		EndIf
		
		If xP_LIQ_PED > 0
			xPESO_LIQ := xP_LIQ_PED
		Endif
		
	Next
	
	// *** Pesquisa da Condicao de Pagto
	
	DbSelectArea("SE4")                    // Condicao de Pagamento
	DbSetOrder(1)
	
	DbSeek( xFilial("SE4") + xCOND_PAG )
	xDESC_PAG := SE4->E4_DESCRI
	
	DbSelectArea("SC6")                    // * Itens de Pedido de Venda
	DbSetOrder(1)
	
	For I := 1 To Len( xPED_VEND )
		
		DbSeek( xFilial("SC6") + xPED_VEND[I] + xITEM_PED[I] )
		AADD( xDESC_PRO, SC6->C6_DESCRI )
		AADD( xVAL_DESC, SC6->C6_VALDESC)
		
		If !Empty( SC6->C6_PEDCLI )
			If Ascan( xPEDCLI, SC6->C6_PEDCLI ) == 0
				AADD( xPEDCLI  , SC6->C6_PEDCLI )
			EndIf
		EndIf
	Next
	
	If ( xTIPO $"N_C_P_I_S_T_O_" )
		
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek( xFilial("SA1") + xCLIENTE + xLOJA )
		
		xCOD_CLI := SA1->A1_COD             // Codigo do Cliente
		xNOME_CLI:= SA1->A1_NOME            // Nome
		xEND_CLI := SA1->A1_END             // Endereco
		xBAIRRO  := SA1->A1_BAIRRO          // Bairro
		xCEP_CLI := SA1->A1_CEP             // CEP
		xMUN_CLI := SA1->A1_MUN             // Municipio
		xEST_CLI := SA1->A1_EST             // Estado
		xCGC_CLI := SA1->A1_CGC             // CGC
		xINSC_CLI:= SA1->A1_INSCR           // Inscricao estadual
		xTRAN_CLI:= SA1->A1_TRANSP          // Transportadora
		xTEL_CLI := SA1->A1_TEL             // Telefone
		xFAX_CLI := SA1->A1_FAX             // Fax
		xREG_CLI := SA1->A1_REGIAO          // Regiao do Cliente
		
		xCOB_CLI := SA1->A1_ENDCOB          // Endereco de Cobranca
		xCOB_MUN := SA1->A1_MUNC
		XCOB_EST := SA1->A1_ESTC
		
		xREC_CLI := SA1->A1_ENDENT          // Endereco de Entrega
		xREC_MUN := SA1->A1_MUNE
		xREC_EST := SA1->A1_ESTE
		xREC_CGC := SA1->A1_CLCGCEN
		xREC_INS := SA1->A1_CLIEENT
		
		xSUFRAMA := SA1->A1_SUFRAMA            // Codigo Suframa
		xCALCSUF := SA1->A1_CALCSUF            // Calcula Suframa
		
		// *** Alteracao p/ Calculo de Suframa
		
		If !Empty(xSUFRAMA) .AND. xCALCSUF == "S"
			IF ( XTIPO $"D_B_" )
				zFranca := .F.
			Else
				zFranca := .T.
			Endif
		Else
			zfranca:= .F.
		Endif
		
	Else
		
		zFranca := .F.
		DbSelectArea("SA2")                 // * Cadastro de Fornecedores
		DbSetOrder(1)
		DbSeek( xFilial("SA2") + xCLIENTE + xLOJA )
		xCOD_CLI := SA2->A2_COD             // Codigo do Fornecedor
		xNOME_CLI:= SA2->A2_NOME            // Nome Fornecedor
		xEND_CLI := SA2->A2_END             // Endereco
		xBAIRRO  := SA2->A2_BAIRRO          // Bairro
		xCEP_CLI := SA2->A2_CEP             // CEP
		xMUN_CLI := SA2->A2_MUN             // Municipio
		xEST_CLI := SA2->A2_EST             // Estado
		xCGC_CLI := SA2->A2_CGC             // CGC
		xINSC_CLI:= SA2->A2_INSCR           // Inscricao estadual
		xTRAN_CLI:= SA2->A2_TRANSP          // Transportadora
		xTEL_CLI := SA2->A2_TEL             // Telefone
		xFAX_CLI := SA2->A2_FAX             // Fax
		
		xCOB_CLI := ""                      // Endereco de Cobranca
		xCOB_MUN := ""
		XCOB_EST := ""
		
		xREC_CLI := ""                      // Endereco de Entrega
		xREC_MUN := ""
		xREC_EST := ""
		xREC_CGC := ""
		xREC_INS := ""
		
	Endif
	
	DbSelectArea("SA3")                    // * Cadastro de Vendedores
	DbSetOrder(1)
	xVENDEDOR:={}                          // Nome do Vendedor
	
	For I := 1 to Len( xCOD_VEND )
		DbSeek( xFilial() + xCOD_VEND[I] )
		AADD( xVENDEDOR, SA3->A3_NREDUZ )
	Next
	
	If xICMS_RET > 0                       // Apenas se ICMS Retido > 0
		DbSelectArea("SF3")                 // Cadastro de Livros Fiscais
		DbSetOrder(4)
		If DbSeek( xFilial("SF3") + SA1->A1_COD + SA1->A1_LOJA + SF2->F2_DOC + SF2->F2_SERIE )
			xBSICMRET := F3_VALOBSE
		Else
			xBSICMRET := 0
		EndIf
	Else
		xBSICMRET := 0
	EndIf
	
	If SM0->M0_CODIGO == "03"
		DbSelectArea("SA4")
		DbSetOrder(1)
		
		If DbSeek( xFilial("SA4") + SC5->C5_X_TRANSP ) // Tranportadora de Manaus
			
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->NOME := SA4->A4_NOME           // Nome Transportadora
			TRB->END  := SA4->A4_END            // Endereco
			TRB->MUN  := SA4->A4_MUN            // Municipio
			TRB->EST  := SA4->A4_EST            // Estado
			TRB->VIA  := SA4->A4_VIA            // Via de Transporte
			TRB->CGC  := SA4->A4_CGC            // CGC
			TRB->CEP  := SA4->A4_CEP            // CEP
			TRB->TEL  := SA4->A4_TEL            // FONE
			MsUnlock()
			
		EndIf
		
	EndIf
	DbSelectArea("SA4")                    // * Transportadoras
	DbSetOrder(1)
	
	DbSeek( xFilial("SA4") + SF2->F2_TRANSP )
	xNOME_TRANSP := SA4->A4_NOME           // Nome Transportadora
	xEND_TRANSP  := SA4->A4_END            // Endereco
	xMUN_TRANSP  := SA4->A4_MUN            // Municipio
	xEST_TRANSP  := SA4->A4_EST            // Estado
	xVIA_TRANSP  := SA4->A4_VIA            // Via de Transporte
	xCGC_TRANSP  := SA4->A4_CGC            // CGC
	xTEL_TRANSP  := SA4->A4_TEL            // Fone
	xCEP_TRANSP  := SA4->A4_CEP            // Fone
	
	DbSelectArea("SE1")                   // * Contas a Receber
	DbSetOrder(1)
	xPARC_DUP  := {}                       // Parcela
	xVENC_DUP  := {}                       // Vencimento
	xVALOR_DUP := {}                       // Valor
	
	// *** Flag p/ Impressao de Duplicatas
	xDUPLICATAS := Iif(DbSeek(xFilial("SE1") + xPREF_DUPLIC + xNUM_DUPLIC, .T. ), .T., .F. )
	
	Do While !Eof() .AND. SE1->E1_NUM == xNUM_DUPLIC .AND. xDUPLICATAS == .T.
		
		If !( "NF " $SE1->E1_TIPO )
			DbSkip()
			Loop
		Endif
		
		AADD( xVALOR_DUP, SE1->E1_VALOR   )
		AADD( xPARC_DUP , SE1->E1_PARCELA )
		AADD( xVENC_DUP , SE1->E1_VENCTO  )
		DbSkip()
		
	EndDo
	
	DbSelectArea("SF4")                   // * Tipos de Entrada e Saida
	DbSetOrder(1)
	xNATUREZA := {}
	
	For nAA := 1 To Len( xTES )
		DbSeek( xFilial("SF4") + xTES[nAA] )
		AADD( xNATUREZA, SF4->F4_TEXTO )  // Natureza da Operacao
		// Cod. Observ. Fiscais do Tes
		If !Empty( SF4->F4_CLMSG1 )
			If Ascan( xOBS_FISC, SF4->F4_CLMSG1 ) == 0
				AADD( xOBS_FISC, SF4->F4_CLMSG1 )
			EndIf
		EndIf
		If !Empty( SF4->F4_CLMSG2 )
			If Ascan( xOBS_FISC, SF4->F4_CLMSG2 ) == 0
				AADD( xOBS_FISC, SF4->F4_CLMSG2 )
			EndIf
		EndIf
		
		// Fim Cod. Observ. Fiscais do Tes
		
	Next
	
	Imprime()
	
	IncRegua()
	
	nLin := 0
	DbSelectArea("SF2")
	DbSkip()
	
EndDo

DbSelectArea("SD2")
Retindex("SD2")

DbSelectArea("SF2")
Retindex("SF2")

Return

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    Ё RptEntra Ё Autor Ё Alberto N. G. Junior  Ё Data Ё 28/09/99 Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё Manipula┤фo de Dados para impressфo NF de entrada COEL     Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       Ё CLNFISC.PRX - Rdmake Nota Fiscal COEL                      Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/

Static Function RptEntra()
*----------------------------------------------------------------------------*
* Cria um vetor com a estrutura do arquivo temporario                        *
*----------------------------------------------------------------------------*
If SM0->M0_CODIGO == "03"
	_cTemp1 := CriaTrab( NIL, .F. )
	
	aEstru1 :={} // Transportadora a ser tratada por Manaus
	AADD(aEstru1,{"NOME"    ,"C",40,0})
	AADD(aEstru1,{"END"     ,"C",40,0})
	AADD(aEstru1,{"MUN"     ,"C",15,0})
	AADD(aEstru1,{"EST"     ,"C",2 ,0})
	AADD(aEstru1,{"VIA"     ,"C",15,0})
	AADD(aEstru1,{"CGC"     ,"C",14,0})
	AADD(aEstru1,{"CEP"     ,"C",8 ,0})
	AADD(aEstru1,{"TEL"     ,"C",15,0})
	
	DbCreate(_cTemp1,aEstru1)
	dbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. )
EndIf
DbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
DbSetOrder(1)

DbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
DbSetOrder(1)
DbSeek( xFilial() + mv_par01 + mv_par03 )
setregua(99)
Do While !Eof() .AND. SF1->F1_DOC <= mv_par02 .AND. lContinua
	
	If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
		DbSkip()                    // do Parametro Informado
		Loop
	EndIf
	
	If lAbortPrint
		@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
		lContinua := .F.
		Exit
	EndIf
	
	xNUM_NF     := SF1->F1_DOC             // Numero
	xSERIE      := SF1->F1_SERIE           // Serie
	xFORNECE    := SF1->F1_FORNECE         // Cliente/Fornecedor
	xCLIENTE    := xFORNECE
	xEMISSAO    := SF1->F1_EMISSAO         // Data de Emissao
	xTOT_FAT    := SF1->F1_VALBRUT         // Valor Bruto da Compra
	xLOJA       := SF1->F1_LOJA            // Loja do Cliente
	xFRETE      := SF1->F1_FRETE           // Frete
	xSEGURO     := SF1->F1_SEGURO          // Seguro
	xDESPACESS  := SF1->F1_DESPESA         // Seguro
	xBASE_ICMS  := SF1->F1_BASEICM         // Base   do ICMS
	xBASE_IPI   := SF1->F1_BASEIPI         // Base   do IPI
	xBSICMRET   := SF1->F1_BRICMS          // Base do ICMS Retido
	xVALOR_ICMS := SF1->F1_VALICM          // Valor  do ICMS
	xICMS_RET   := SF1->F1_ICMSRET         // Valor  do ICMS Retido
	xVALOR_IPI  := SF1->F1_VALIPI          // Valor  do IPI
	xVALOR_MERC := SF1->F1_BASEICM         // Valor  da Mercadoria
	xNUM_DUPLIC := SF1->F1_DUPL            // Numero da Duplicata
	If SM0->M0_CODIGO == "03"
		xPREF_DUPLIC:= SF1->F1_SERIE
	Else
		xPREF_DUPLIC:= iif(SM0->M0_CODFIL == "01","SPO","SRE")
	EndIf
	xCOND_PAG   := SF1->F1_COND            // Condicao de Pagamento
	xTIPO       := SF1->F1_TIPO            // Tipo do Cliente
	xNFORI      := SF1->F1_NFORI           // NF Original
	xPREF_DV    := SF1->F1_SERIORI         // Serie Original
	xPBRUTO     := 0                       // Peso Bruto
	xPLIQUI     := 0                       // Peso Liquido
	xTRANS_AM   := ""
	
	DbSelectArea("SD1")                    // Itens da N.F. de Compra
	DbSeek( xFilial("SD1") + xNUM_NF + xSERIE + xFORNECE + xLOJA )
	
	DbSelectArea("SF4")
	DbSetOrder(1)
	
	xBASES_DIF := {}           // Aliquotas ICMS diferentes
	xVALOR_DIF := {}           // Base do ICMS por aliquota
	
	xPEDIDO  := {}              // Numero do Pedido de Compra
	xITEM_PED:= {}              // Numero do Item do Pedido de Compra
	xNUM_NFDV:= {}              // Numero quando houver devolucao
	xPREF_DV := {}              // Serie  quando houver devolucao
	xICMS    := {}              // Porcentagem do ICMS
	xCOD_PRO := {}              // Codigo  do Produto
	xQTD_PRO := {}              // Peso/Quantidade do Produto
	xPRE_UNI := {}              // Preco Unitario de Compra
	xIPI     := {}              // Porcentagem do IPI
	xPESOPROD:= {}              // Peso do Produto
	xVAL_IPI := {}              // Valor do IPI
	xDESC    := {}              // Desconto por Item
	xVAL_DESC:= {}              // Valor do Desconto
	xVAL_MERC:= {}              // Valor da Mercadoria
	xTES     := {}              // TES
	xCF      := {}              // Classificacao quanto natureza da Operacao
	xICMSOL  := {}              // Base do ICMS Solidario
	xICM_PROD:= {}              // ICMS do Produto
	xPED     := {}
	xTESPROD := {}              // Tes de cada Item
	xISS     := .F.             // Flag p/ Impressao ISS
	xDESC_ZFR:= {}             // Valor do Desconto Suframa do Item
	xCOD_TRIB := {}             // Codigo de Tributacao
	
	Do While !Eof() .AND. SD1->D1_DOC == xNUM_NF
		
		If SD1->D1_SERIE #mv_par03
			DbSkip()
			Loop
		EndIf
		
		DbSelectArea("SD2")
		DbSetOrder(3)
		If DbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD)
			AADD( xPRE_UNI , SD2->D2_PRCVEN)          // Valor Unitario
			nValTot := SD1->D1_QUANT * SD2->D2_PRCVEN
			AADD( xVAL_MERC, nValtot)                 // Valor Total
			AADD( xPEDIDO  , SD1->D1_PEDIDO )         // Ordem de Compra
			AADD( xITEM_PED, SD1->D1_ITEMPC )         // Item da O.C.
			AADD( xNUM_NFDV, Iif( Empty(SD1->D1_NFORI), "", SD1->D1_NFORI ) )
			AADD( xPREF_DV , SD1->D1_SERIORI)         // Serie Original
			AADD( xICMS    , Iif( Empty(SD1->D1_PICM), 0, SD1->D1_PICM ) )
			AADD( xCOD_PRO , SD1->D1_COD)             // Produto
			AADD( xCOD_TRIB, SD1->D1_CLASFIS )
			AADD( xQTD_PRO , SD1->D1_QUANT)           // Guarda as quant. da NF
			AADD( xIPI     , SD1->D1_IPI)             // % IPI
			AADD( xVAL_IPI , SD1->D1_VALIPI)          // Valor do IPI
			AADD( xPESOPROD, SD1->D1_PESO)            // Peso do Produto
			AADD( xDESC    , SD1->D1_DESC)            // % Desconto
			AADD( xTES     , SD1->D1_TES)             // Tipo de Entrada/Saida
			AADD( xCF      , SD1->D1_CF)              // Codigo Fiscal
			AADD( xICM_PROD, IIf( Empty(SD1->D1_PICM), 0, SD1->D1_PICM ) )
			AADD( xTESPROD , SD1->D1_TES )
			AADD( xDESC_ZFR, 0 )
			
			If Ascan( xTES, SD1->D1_TES ) == 0
				AADD( xTES, SD1->D1_TES)
				AADD( xCF , SD1->D1_CF )
			EndIf
		Else
			AADD( xPEDIDO  , SD1->D1_PEDIDO )         // Ordem de Compra
			AADD( xITEM_PED, SD1->D1_ITEMPC )         // Item da O.C.
			AADD( xNUM_NFDV, Iif( Empty(SD1->D1_NFORI), "", SD1->D1_NFORI ) )
			AADD( xPREF_DV , SD1->D1_SERIORI)         // Serie Original
			AADD( xICMS    , Iif( Empty(SD1->D1_PICM), 0, SD1->D1_PICM ) )
			AADD( xCOD_PRO , SD1->D1_COD)             // Produto
			AADD( xCOD_TRIB, SD1->D1_CLASFIS )
			AADD( xQTD_PRO , SD1->D1_QUANT)           // Guarda as quant. da NF
			AADD( xPRE_UNI , SD1->D1_VUNIT)           // Valor Unitario
			AADD( xIPI     , SD1->D1_IPI)             // % IPI
			AADD( xVAL_IPI , SD1->D1_VALIPI)          // Valor do IPI
			AADD( xPESOPROD, SD1->D1_PESO)            // Peso do Produto
			AADD( xDESC    , SD1->D1_DESC)            // % Desconto
			AADD( xVAL_MERC, SD1->D1_TOTAL)           // Valor Total
			AADD( xTES     , SD1->D1_TES)             // Tipo de Entrada/Saida
			AADD( xCF      , SD1->D1_CF)              // Codigo Fiscal
			AADD( xICM_PROD, IIf( Empty(SD1->D1_PICM), 0, SD1->D1_PICM ) )
			AADD( xTESPROD , SD1->D1_TES )
			AADD( xDESC_ZFR, 0 )
			
			If Ascan( xTES, SD1->D1_TES ) == 0
				AADD( xTES, SD1->D1_TES)
				AADD( xCF , SD1->D1_CF )
			EndIf
		EndIf
		
		DbSelectArea("SF4")
		DbSeek( xFilial("SF4") + SD1->D1_TES )
		
		If SF4->F4_ISS #"S"
			// ** Se nфo h  ISS no TES, calcula bases para al║qs. do ICMS diferenciadas
			nElem := Ascan( xBASES_DIF, SD1->D1_PICM )
			If nElem == 0
				AADD( xBASES_DIF, SD1->D1_PICM  )
				AADD( xVALOR_DIF, SD1->D1_TOTAL )
			Else
				xVALOR_DIF[nElem] := xVALOR_DIF[nElem] + SD1->D1_TOTAL
			EndIf
		Else
			// ** Se h  ISS no TES, subtrai o valor do item do total das mercadorias
			xVALOR_MERC := xVALOR_MERC - SD1->D1_TOTAL
			xISS := .T.
		EndIf
		DbSelectArea("SD1")
		Dbskip()
	End
	
	DbSelectArea("SB1")                     // * Desc. Generica do Produto
	DbSetOrder(1)
	
	DbSelectArea("SB5")                     // * Dados Adicionais do Prod
	DbSetOrder(1)
	
	DbSelectArea("SZ1")                     // * Classif. Fiscais
	DbSetOrder(1)
	
	xUNID_PRO := {}             // Unidade do Produto
	xDESC_PRO := {}             // Descricao do Produto
	xMEN_POS  := {}             // Mensagem da Posicao IPI
	xDESCRICAO:= {}             // Descricao do Produto
	xMEN_TRIB := {}             // Mensagens de Tributacao
	xCOD_FIS  := {}             // Cogigo Fiscal
	xCLAS_FIS := {}             // Classificacao Fiscal
	xTIPO_PRO := {}             // Tipo do Produto
	xLUCRO    := {}             // Margem de Lucro p/ ICMS Solidario
	xCLFISCAL := {}
	xSUFRAMA  := ""
	xCALCSUF  := ""
	xOBS_FISC := {}
	xDESC_DCR  := {}
	
	For I := 1 To Len( xCOD_PRO )
		
		DbSelectArea("SB1")
		DbSeek(xFilial("SB1") + xCOD_PRO[I] )

		AADD( xDESC_DCR, SB1->B1_X_DCR)

		DbSelectArea( "SB5" )
		DbSeek(xFilial()+xCOD_PRO[I])
		AADD( xDESCRICAO, Subst( SB5->B5_CEME, 1, 57 ) )
		
		DbSelectArea("SB1")
		AADD( xCOD_FIS , SB1->B1_CLCLASF )
		AADD( xUNID_PRO, SB1->B1_UM )
		
		If Ascan( xMEN_TRIB, SB1->B1_ORIGEM ) == 0
			AADD( xMEN_TRIB, SB1->B1_ORIGEM )
		EndIf
		
		If !Empty( SB1->B1_POSIPI ) .AND. Ascan( xCLFISCAL, SB1->B1_CLCLASF ) == 0
			AADD( xCLAS_FIS, SB1->B1_POSIPI  )
			AADD( xCLFISCAL, SB1->B1_CLCLASF )
		EndIf
		
		// *** Obsevacoes Fiscais ***
		If mv_par04 == 2
			DbSelectArea("SZ1")
			DbSeek( xFilial("SZ1") + SB1->B1_POSIPI )
			
			If !Empty( SZ1->Z1_CLOBIPI )
				
				If Ascan( xOBS_FISC, SZ1->Z1_CLOBIPI ) == 0 .AND. xIMPR_IPI[I] == .T.
					AADD( xOBS_FISC, SZ1->Z1_CLOBIPI )
				EndIf
			EndIf
			
			If !Empty( SZ1->Z1_CLOBICM )
				If Ascan( xOBS_FISC, SZ1->Z1_CLOBICM ) == 0 .AND. xIMPR_ICM[I] == .T.
					AADD( xOBS_FISC, SZ1->Z1_CLOBICM )
				EndIf
			endif
		EndIf
		
		// *** Fim Obser. Fiscais ***
		
		AADD( xTIPO_PRO, SB1->B1_TIPO )
		AADD( xLUCRO   , SB1->B1_PICMRET )
		
	Next
	
	DbSelectArea("SE4")                    // Condicao de Pagamento
	DbSetOrder(1)
	DbSeek( xFilial("SE4") + xCOND_PAG )
	xDESC_PAG := SE4->E4_DESCRI
	
	If xTIPO == "B" .OR. xTIPO =="D"
		
		DbSelectArea("SA1")                 // * Cadastro de Clientes
		DbSetOrder(1)
		DbSeek( xFilial("SA1") + xCLIENTE + xLOJA )
		
		xCOD_CLI  := SA1->A1_COD             // Codigo do Cliente
		xNOME_CLI := SA1->A1_NOME            // Nome
		xEND_CLI  := SA1->A1_END             // Endereco
		xBAIRRO   := SA1->A1_BAIRRO          // Bairro
		xCEP_CLI  := SA1->A1_CEP             // CEP
		xMUN_CLI  := SA1->A1_MUN             // Municipio
		xEST_CLI  := SA1->A1_EST             // Estado
		xCGC_CLI  := SA1->A1_CGC             // CGC
		xINSC_CLI := SA1->A1_INSCR           // Inscricao estadual
		xTRAN_CLI := SA1->A1_TRANSP          // Transportadora
		xTEL_CLI  := SA1->A1_TEL             // Telefone
		xFAX_CLI  := SA1->A1_FAX             // Fax
		
		xCOB_CLI := ""                       // Endereco de Cobranca
		xCOB_MUN := ""
		XCOB_EST := ""
		xREC_CLI := ""                       // Endereco de Entrega
		xREC_MUN := ""
		xREC_EST := ""
		xREC_CGC := ""
		xREC_INS := ""
		
		xREG_CLI := ""
		xCOD_VEND:= {}
		
	Else
		
		//----> digitar mensagens para nota fiscal de complemento de importacao
		If xTIPO == "C"
			DigitaMens()
		EndIf
		
		DbSelectArea("SA2")                    // Cadastro de Fornecedores
		DbSetOrder(1)
		DbSeek(xFilial("SA2") + xFORNECE + xLOJA )
		
		xCOD_CLI := SA2->A2_COD                // Codigo do Fornecedor
		xNOME_CLI:= SA2->A2_NOME               // Nome
		xEND_CLI := SA2->A2_END                // Endereco
		xBAIRRO  := SA2->A2_BAIRRO             // Bairro
		xCEP_CLI := SA2->A2_CEP                // CEP
		xMUN_CLI := SA2->A2_MUN                // Municipio
		xEST_CLI := SA2->A2_EST                // Estado
		xCGC_CLI := SA2->A2_CGC                // CGC
		xINSC_CLI:= SA2->A2_INSCR              // Inscricao estadual
		xTRAN_CLI:= SA2->A2_TRANSP             // Transportadora
		xTEL_CLI := SA2->A2_TEL                // Telefone
		xFAX     := SA2->A2_FAX                // Fax
		
		xCOB_CLI := ""                         // Endereco de Cobranca
		xCOB_MUN := ""
		XCOB_EST := ""
		xREC_CLI := ""                         // Endereco de Entrega
		xREC_MUN := ""
		xREC_EST := ""
		xREC_CGC := ""
		xREC_INS := ""
		
		xREG_CLI := ""
		xCOD_VEND:= {}
		
	EndIf
	
	DbSelectArea("SE2")                   // * Contas a Receber
	DbSetOrder(1)
	xPARC_DUP  := {}                       // Parcela
	xVENC_DUP  := {}                       // Vencimento
	xVALOR_DUP := {}                       // Valor
	
	// *** Flag p/Impressao de Duplicatas
	xDUPLICATAS := Iif( DbSeek(xFilial("SE2") + xPREF_DUPLIC + xNUM_DUPLIC, .T. ), .T., .F. )
	
	Do While !Eof() .and. SE2->E2_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
		If SE2->E2_FORNECE==xFORNECE .AND. SE2->E2_LOJA==xLOJA
			AADD(xPARC_DUP ,SE2->E2_PARCELA)
			AADD(xVENC_DUP ,SE2->E2_VENCTO)
			AADD(xVALOR_DUP,SE2->E2_VALOR)
			DbSkip()
		EndIf
	EndDo
	
	DbSelectArea("SF4")                   // * Tipos de Entrada e Saida
	DbSetOrder(1)
	
	xNATUREZA := {}
	For nAA := 1 To Len( xTES )
		DbSeek( xFilial("SF4") + xTES[nAA] )
		AADD(xNATUREZA, SF4->F4_TEXTO )  // Natureza da Operacao
		// Cod. Observ. Fiscais do Tes
		If !Empty( SF4->F4_CLMSG1 )
			If Ascan( xOBS_FISC, SF4->F4_CLMSG1 ) == 0
				AADD( xOBS_FISC, SF4->F4_CLMSG1 )
			EndIf
		EndIf
		If !Empty( SF4->F4_CLMSG2 )
			If Ascan( xOBS_FISC, SF4->F4_CLMSG2 ) == 0
				AADD( xOBS_FISC, SF4->F4_CLMSG2 )
			EndIf
		EndIf
		// Fim Cod. Observ. Fiscais do Tes
	Next
	
	xNOME_TRANSP := " "           // Nome Transportadora
	xEND_TRANSP  := " "           // Endereco
	xMUN_TRANSP  := " "           // Municipio
	xEST_TRANSP  := " "           // Estado
	xVIA_TRANSP  := " "           // Via de Transporte
	xCGC_TRANSP  := " "           // CGC
	xTEL_TRANSP  := " "           // Fone
	xTPFRETE     := " "           // Tipo de Frete
	xVOLUME      := 0            // Volume
	xESPECIE     := " "           // Especie
	xPESO_LIQ    := 0            // Peso Liquido
	xPESO_BRUTO  := 0            // Peso Bruto
	xCOD_MENS    := " "           // Codigo da Mensagem
	xMENSAGEM    := {}	      // Mensagem da Nota
	xPESO_LIQUID := " "
	
	Imprime()
	
	IncRegua()
	
	nLin := 0
	DbSelectArea("SF1")
	DbSkip()
	
End

DbSelectArea("SD1")
Retindex("SD1")

DbSelectArea("SF1")
Retindex("SF1")



Return

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё                   FUNCOES ESPECIFICAS                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    Ё VERIMP   Ё Autor Ё   Marcos Simidu       Ё Data Ё 20/12/95 Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё Verifica posicionamento de papel na Impressora             Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       Ё Nfiscal                                                    Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/

Static Function VerImp()

nLin := 0                // Contador de Linhas
If aReturn[5]==2
	
	nOpc := 1
	
	Do While .T.
		
		SetPrc( 0, 0 )
		DbCommitAll()
		
		// @ nLin ,000 PSAY " "
		// @ nLin ,004 PSAY "*"
		// @ nLin ,022 PSAY "."
		
		IF MsgYesNo("Fomulario esta posicionado ? ")
			nOpc := 1
		ElseIF MsgYesNo(" Tenta Novamente ? ")
			nOpc := 2
		Else
			nOpc := 3
		Endif
		
		Do Case
			Case nOpc == 1
				lContinua := .T.
				Exit
			Case nOpc == 2
				Loop
			Case nOpc == 3
				lContinua := .F.
				Return
		EndCase
		
	End
	
EndIf

Return

// *** Fim da Funcao

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    Ё IMPDET   Ё Autor Ё Alberto Nunes Gama Jr Ё Data Ё 28/09/99 Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё Impressao de Linhas de Detalhe da Nota Fiscal              Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       Ё Nfiscal                                                    Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/

Static Function IMPDET()

nTamDet     := 14         // Tamanho da Area de Detalhe
xB_ICMS_SOL := 0          // Base  do ICMS Solidario
xV_ICMS_SOL := 0          // Valor do ICMS Solidario
xLIN_ISS    := {}

For I:= 1 To Len( xCOD_PRO )
	
	If I <= nTamDet
		
		DbSelectArea("SB1")
		DbSeek( xFilial("SB1") + xCOD_PRO[I] )
		
		DbSelectArea("SF4")
		DbSeek( xFilial("SF4") + xTESPROD[I] )
		
		If SF4->F4_ISS == "S"
			If Ascan( xLIN_ISS, SB1->B1_DESC ) == 0
				AADD( xLIN_ISS, SB1->B1_DESC )
			EndIf
		Else
			@ nLin,  05 PSAY xCOD_PRO[I]              Picture"@R 99.999.999"
			If SM0->M0_CODIGO == "03"
				@ nLin,  23 PSAY SUBS(xDESCRICAO[I],1,50)+"-DCR "+xDESC_DCR[I]
			Else
				@ nLin,  23 PSAY xDESCRICAO[I]
			EndIf
			@ nLin,  93 PSAY xCOD_FIS[I]
			@ nLin,  98 PSAY xCOD_TRIB[I]
			@ nLin, 103 PSAY xUNID_PRO[I]
			@ nLin, 108 PSAY xQTD_PRO[I]                                Picture"@E 999,999.99"
			@ nLin, 124 PSAY xPRE_UNI[I]  + xDESC_ZFR[I] / xQTD_PRO[I]  Picture"@E 99,999,999.9999"
			@ nLin, 149 PSAY xVAL_MERC[I] + xDESC_ZFR[I]                Picture"@E 99,999,999.99"
			@ nLin, 170 PSAY Iif( zFranca==.T., 0, xICM_PROD[I] )       Picture"99"
			@ nLin, 177 PSAY xIPI[I]                                    Picture"99"
			@ nLin, 189 PSAY xVAL_IPI[I]                                Picture"@E 9,999,999.99"
			nLin := nLin + 1
		EndIf
		
	EndIf
	
Next

If zFranca == .T.
	
	xZFR_TOTAL := 0
	@ nLin,  23 PSAY "DESCONTO DE " + Str( xICMS[1], 5, 2 ) + "%  REFERENTE AO ICMS"
	
	For i := 1 To Len( xDESC_ZFR )
		xZFR_TOTAL := xZFR_TOTAL + xDESC_ZFR[i]
	Next
	
	@ nLin, 149 PSAY xZFR_TOTAL  Picture"@E 99,999,999.99"
	
EndIf

Return

//зддддддддддддддддддддд©
//Ё Fim da Funcao       Ё
//юддддддддддддддддддддды

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    Ё IMPRIME  Ё Autor Ё Alberto N. G. Junior  Ё Data Ё 28/09/99 Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё Imprime a Nota Fiscal de Entrada e de Saida                Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       Ё Generico RDMAKE                                            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/

Static Function Imprime()

// *** Impressao do Cabecalho da N.F.

DadosAdd()

nContr_Add := 1             // Controle da linha dos dados adicionais
nContr_Dup := 1             // Controle da linha das duplicatas
nLin       := 1
@ nLin, 113 PSAY xNUM_NF + Chr(15)    // Numero da Nota Fiscal nao Comprimido

nLin := 2
ImprAdd()

nLin := 3
ImprAdd()

nLin := 4
ImprAdd()

If mv_par04 == 1
	@ nLin, 168 PSAY "X"
Else
	@ nLin, 154 PSAY "X"
Endif

nLin := 5
ImprAdd()

nLin := 6
ImprAdd()

nLin := 7
ImprAdd()

nLin := 8
ImprAdd()

nLin := 9
ImprAdd()

@ nLin, 77 PSAY xNATUREZA[1]               // Texto Natur. Operacao
@ nLin,119 PSAY xCF[1] Picture"@R 9.999"  // Cod.  Natur. Operacao

nLin := 10
ImprAdd()

If Len( xCF ) > 1
	If mv_par04 == 1
		@ nLin, 77 PSAY ""                         // Texto da 2╕ Natureza
		@ nLin,119 PSAY ""                         // Cod.  da 2╕ Natureza
	Else
		@ nLin, 77 PSAY xNATUREZA[2]               // Texto da 2╕ Natureza
		@ nLin,119 PSAY xCF[2] Picture"@R 9.999"  // Cod.  Natur. Operacao
	EndIf
EndIf

nLin := 11
ImprAdd()

nLin := 12
ImprAdd()

nLin := 13
ImprAdd()

// *** Impressao dos Dados do Cliente

@ nLin, 77 PSAY xNOME_CLI

If !EMPTY(xCGC_CLI)
	@ nLin,156 PSAY xCGC_CLI   Picture"@R 99.999.999/9999-99"
Else
	@ nLin,156 PSAY " "
EndIf

@ nLin, 192 PSAY DToC( xEMISSAO )

nLin := 14
ImprAdd()

nLin := 15
ImprAdd()

@ nLin, 77  PSAY xEND_CLI
@ nLin,139  PSAY xBAIRRO
@ nLin,170  PSAY xCEP_CLI Picture"@R 99999-999"

nLin := 16
ImprAdd()

nLin := 17
ImprAdd()

@ nLin, 77  PSAY xMUN_CLI
@ nLin,127  PSAY xTEL_CLI
@ nLin,149  PSAY xEST_CLI
@ nLin,156  PSAY xINSC_CLI
@ nLin,185  PSAY " "          // Reservado p/Hora da Saida

nLin := 18
ImprAdd()

nLin := 19
ImprAdd()

nLin := 20
ImprAdd()
@ nLin, 03 PSAY " "
@ nLin, 91 PSAY xCOB_CLI      // Endere┤o Cobranca

nLin := 21
ImprAdd()
@ nLin, 03 PSAY " "
ImprDup()

nLin := 22
ImprAdd()
@ nLin, 91 PSAY xCOB_MUN + "   " + xCOB_EST   // Munic║pio Cobran┤a
ImprDup()

nLin := 23
ImprAdd()
@ nLin, 03 PSAY " "
ImprDup()

nLin := 24
ImprAdd()
@ nLin, 03 PSAY " "
ImprDup()

nLin := 25
ImprAdd()
@ nLin, 90  PSAY  0  Picture"@E 999.99"         // xDESC_NF[ 1 ] Desconto da NF
ImprDup()


// *** Dados dos Produtos Vendidos

nLin := 29
ImpDet()                 // Detalhe da NF

// *** Prestacao de Servicos

If xISS == .T.
	
	nContr_ISS := 1
	nLin := 47
	ImprIss()
	
	nLin := 48
	ImprIss()
	
	nLin := 49
	ImprIss()
	
	@ nLin, 185 PSAY xVALOR_ISS   Picture"@E 9,999,999.99"
	
	nLin := 50
	ImprIss()
	
	nLin := 51
	@ nLin, 185 PSAY xBASE_ISS    Picture"@E 9,999,999.99"
EndIf


// *** Calculo dos Impostos

nLin := 54
//if mv_par04 == 2
@ nLin, 07	PSAY xBASE_ICMS  Picture"@E@Z 999,999,999.99"  // Base do ICMS
@ nLin, 37	PSAY xVALOR_ICMS Picture"@E@Z 999,999,999.99"  // Valor do ICMS
@ nLin, 65	PSAY xBSICMRET	 Picture"@E@Z 999,999,999.99"  // Base ICMS Ret.
@ nLin, 90	PSAY xICMS_RET	 Picture"@E@Z 999,999,999.99"  // Valor  ICMS Ret.
@ nLin,120	PSAY xVALOR_MERC Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.
//endif

nLin := 56
//if mv_par04 == 2
@ nLin, 05	PSAY xFRETE	     Picture"@E@Z 999,999,999.99"      // Valor do Frete
@ nLin, 35	PSAY xSEGURO	 Picture"@E@Z 999,999,999.99"  // Valor Seguro
@ nLin, 65	PSAY xDESPACESS  Picture"@E@Z 999,999,999.99"  // Valor Despesas Acessorias
@ nLin, 90	PSAY xVALOR_IPI  Picture"@E@Z 999,999,999.99"  // Valor do IPI
@ nLin,120	PSAY xTOT_FAT	 Picture"@E@Z 999,999,999.99"  // Valor Total NF
If SM0->M0_CODIGO == "03"
	nLin:=nLin+1
	@ nLin,170   PSAY Chr(18) +xNUM_NF+Chr(15)       		                   // Numero da Nota Fiscal
Endif

// *** Impressao Dados da Transportadora

nLin := 59
If SM0->M0_CODIGO == "03"
	
	dbSelectArea("TRB")
	dbGotop()
	
	If !Empty(XTRANS_AM)
		@ nLin, 05   PSAY TRB->NOME
	Else
		@ nLin, 05   PSAY xNOME_TRANSP
	EndIf
Else
	@ nLin, 05   PSAY xNOME_TRANSP
EndIf
If xTPFRETE == "C"                                   // Frete por conta do
	@ nLin, 81  PSAY "2"                              // Emitente (1)
ElseIf Empty( xTPFRETE )                             //     ou
	@ nLin, 81  PSAY " "
Else
	@ nLin, 81  PSAY "1"                              // Destinatario (2)
Endif

@ nLin, 85  PSAY " "                                  // Reserv. p/ Placa Veiculo
@ nLin,103  PSAY " "                                  // Reserv. U.F. Placa

If SM0->M0_CODIGO
	If !Empty(xTRANS_AM)
		If !Empty( TRB->CGC )
			@ nLin, 108  PSAY TRB->CGC Picture"@R 99.999.999/9999-99"
		Else
			@ nLin, 108  PSAY " "
		Endif
	Else
		If !Empty( xCGC_TRANSP )
			@ nLin, 108  PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
		Else
			@ nLin, 108  PSAY " "
		Endif
	EndIf
Else
	If !Empty( xCGC_TRANSP )
		@ nLin, 108  PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
	Else
		@ nLin, 108  PSAY " "
	Endif
EndIf

nLin := 61
If SM0->M0_CODIGO == "03"
	If !Empty(XTRANS_AM)
		@ nLin, 05  PSAY TRB->END
		@ nLin, 73  PSAY TRB->MUN
		@ nLin,103  PSAY TRB->EST
		@ nLin,108  PSAY " "                                   // Reservado p/Insc. Estad.
	Else
		@ nLin, 05  PSAY xEND_TRANSP                          // Endereco Transp.
		@ nLin, 73  PSAY xMUN_TRANSP                          // Municipio
		@ nLin,103  PSAY xEST_TRANSP                         // U.F.
		@ nLin,108  PSAY " "                                  // Reservado p/Insc. Estad.
	EndIf
Else
	@ nLin, 05  PSAY xEND_TRANSP                          // Endereco Transp.
	@ nLin, 73  PSAY xMUN_TRANSP                          // Municipio
	@ nLin,103  PSAY xEST_TRANSP                          // U.F.
	@ nLin,108  PSAY " "                                  // Reservado p/Insc. Estad.
EndIf
nLin := 63
//if mv_par04 == 2
@ nLin, 05  PSAY xVOLUME  Picture"@E@Z 999,999.99"             // Quant. Volumes
//endif
@ nLin, 35  PSAY xESPECIE Picture"@!"                          // Especie
@ nLin, 60  PSAY " "                                           // Res para Marca
@ nLin, 75  PSAY " "                                           // Res para Numero

//if mv_par04 == 2
@ nLin,100  PSAY xPBRUTO	Picture"@E@Z 999,999.99"      // Res para Peso Bruto
@ nLin,118  PSAY xPLIQUI	Picture"@E@Z 999,999.99"      // Res para Peso Liquido
//endif

nLin := 68
@ nLin, 07  PSAY Chr(18) + xNUM_NF		   // Numero da Nota Fiscal
nLin := 72
@ nLin, 000 PSAY " "
SetPrc(0,0)

If SM0->M0_CODIGO == "03"
	dbSelectArea("TRB")
	DbCloseArea()
	Ferase( _cTemp1+OrdBagExt() )
EndIf


Return( .T. )

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    Ё DadosAdd Ё Autor Ё Alberto N. G. Junior  Ё Data Ё 28/09/99 Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё Cria Array dos dados adicionais - nota fiscal COEL         Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       Ё Nfiscal - Especifico p/ COEL                               Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/

Static Function DadosAdd()

xLINHASAD := {}    // Array com as linhas do campo dados adicionais

// *** Adiciona as Classificacoes Fiscais

cTextoAdd := ""
nNovaLi := 0
For nCont := 1 to Len( xCLFISCAL )
	If nNovaLi > 3
		AADD( xLINHASAD, cTextoAdd )
		cTextoAdd := ""
		nNovaLi := 0
	EndIf
	cTextoAdd := cTextoAdd + xCLFISCAL[ nCont ] + "-" + Subst( xCLAS_FIS[nCont], 1, 4 ) + "." + Subst( xCLAS_FIS[nCont], 5, 2 ) + "." + Subst( xCLAS_FIS[nCont], 7, 2 )
	If nCont < Len( xCLFISCAL )
		cTextoAdd := cTextoAdd + "  "
	EndIf
	nNovaLi := nNovaLi + 1
Next
If !Empty( cTextoAdd )
	AADD( xLINHASAD, cTextoAdd )
EndIf


// *** Adiciona dados do local de entrega

AADD( xLINHASAD, "Codigo do Cliente: " + xCLIENTE + " - " + xLOJA )
cTextoAdd := ""
If !Empty( xREC_CLI )
	AADD( xLINHASAD, "Local de Entrega: " + xREC_CLI )
	AADD( xLINHASAD, xREC_MUN + "  " + xREC_EST )
EndIf

If !Empty( xREC_CGC )
	cTextoAdd := cTextoAdd + "CGC: "+Subst(xREC_CGC,1,2)+"."+Subst(xREC_CGC,3,3)+"."+ ;
	Subst(xREC_CGC,6,3)+"/"+ Subst(xREC_CGC,9,4)+"-"+Subst(xREC_CGC,13,2)+"    "
EndIf
If !Empty( xREC_INS )
	cTextoAdd := cTextoAdd + "I.E.: " + xREC_INS
EndIf

If !Empty( cTextoAdd )
	AADD( xLINHASAD, cTextoAdd )
EndIf


// *** Adiciona Mensagem Observacao
/*
If !Empty( xMENSAGEM )
AADD( xLINHASAD, Upper( xMENSAGEM ) )
EndIf
*/
If Len(xMENSAGEM) > 0
	For nAA := 1 To Len( xMENSAGEM )
		AADD( xLINHASAD, xMENSAGEM[nAA] )
	Next
EndIf

// *** Adiciona cod. do pedido na COEL
nContr := 1
If Len( xPED ) > 0 .and. SM0->M0_CODFIL # "02"
	cTextoAdd := "Nosso Pedido: "
	For nAA := 1 To Len( xPED )
		If nContr > 6
			AADD( xLINHASAD, cTextoAdd )
			cTextoAdd := ""
			nContr := 1
		EndIf
		
		cTextoAdd := cTextoAdd + xPED[ nAA ]
		If nAA < Len( xPED )
			cTextoAdd := cTextoAdd + ", "
		EndIf
		nContr := nContr + 1
	Next
	If !Empty( cTextoAdd )
		AADD( xLINHASAD, cTextoAdd )
	EndIf
EndIf

// *** Adiciona cod. do pedido no cliente

nContr1 := 1

If mv_par04 == 2 .and. SM0->M0_CODFIL # "02"
	If Len( xPEDCLI ) > 0
		cTextoAdd := "Seu Pedido: "
		For nAA := 1 To Len( xPEDCLI )
			If nContr1 > 5
				AADD( xLINHASAD, cTextoAdd )
				cTextoAdd := ""
				nContr1 := 1
			EndIf
			
			cTextoAdd := cTextoAdd + Trim( xPEDCLI[ nAA ] )
			If nAA < Len( xPEDCLI )
				cTextoAdd := cTextoAdd + ", "
			EndIf
			nContr1 := nContr1 + 1
		Next
		If !Empty( cTextoAdd )
			AADD( xLINHASAD, cTextoAdd )
		EndIf
	EndIf
EndIf

// *** Adiciona regiao, codigo do vendedor e nome

cTextoAdd := ""
If !Empty( xREG_CLI )
	cTextoAdd := "Regiao: " + xREG_CLI
EndIf
If Len( xCOD_VEND ) > 0
	If !Empty( xCOD_VEND[1] )
		cTextoAdd := cTextoAdd + "     Vendedor: " + xCOD_VEND[1] + "- " + xVENDEDOR[1]
	EndIf
EndIf
If !Empty( cTextoAdd )
	AADD( xLINHASAD, cTextoAdd )
EndIf

// *** Devolucao

If Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
	AADD( xLINHASAD, "Nota Fiscal Original No.  " + xNUM_NFDV[1] + "  " + xPREF_DV[1] )
Endif

// *** Suframa e mensagem por estado - Rogerio

If !Empty(xSuframa)
	AADD( xLINHASAD, "SUFRAMA : "+xSuframa )
	
	cMens:= ""
	Do Case
		//Case xREC_EST == "AM"
		//	cMens:= "ISENTO DO IPI - ART. 85 DO RIPI/98"
		Case xREC_EST == "RO"
			cMens:= "ISENTO DO IPI - ART. 88 DO RIPI/98"
		Case xREC_EST == "RR"
			cMens:= "ISENTO DO IPI - ART. 91 DO RIPI/98"
		Case xREC_EST == "AP"
			cMens:= "ISENTO DO IPI - ART. 94 DO RIPI/98"
		Case xREC_EST == "AC"
			cMens:= "ISENTO DO IPI - Art. 97 DO RIPI/98"
	EndCase
	
	AADD( xLINHASAD, cMens )
	
EndIf


// *** Bases ICMS diferenciadas

cTextoAdd := ""
If Len( xBASES_DIF ) > 1
	AADD( xLINHASAD, "Bases para as aliquotas do ICMS:" )
	nNovaLi := 0
	For nAA := 1 To Len( xBASES_DIF )
		If nNovaLi > 1
			AADD( xLINHASAD, cTextoAdd )
			nNovaLi := 0
			cTextoAdd := ""
		EndIf
		cTextoAdd := cTextoAdd+Str(xBASES_DIF[nAA],2)+"% -> "
		cTextoAdd := cTextoAdd+"R$"+Str(xVALOR_DIF[nAA],14,2)
		nNovaLi := nNovaLi + 1
		If nAA < Len( xBASES_DIF )
			cTextoAdd := cTextoAdd + "           "
		EndIf
	Next
EndIf
If !Empty( cTextoAdd )
	AADD( xLINHASAD, cTextoAdd )
EndIf


// *** Observacoes Fiscais
// *** O Texto da observa┤фo possui 130 posi┤Дes: imprimir 65 por linha

If Len( xOBS_FISC ) > 0
	
	DbSelectArea("SZ3")
	DbSetOrder(1)
	For I := 1 To Len( xOBS_FISC )
		cTextoAdd := ""
		DbSeek( xFilial("SZ3") + xOBS_FISC[I] )
		If SZ3->Z3_CLAPL == "D" .AND. xEST_CLI == "SP"
			cTexToAdd := SZ3->Z3_CLDESC
		ElseIf SZ3->Z3_CLAPL == "F" .AND. xEST_CLI #"SP"
			cTexToAdd := SZ3->Z3_CLDESC
		ElseIf SZ3->Z3_CLAPL == "A"
			cTexToAdd := SZ3->Z3_CLDESC
		EndIf
		
		If !Empty( cTextoAdd )
			AADD( xLINHASAD, Subst(cTextoAdd,1,65) )
			cTextoAdd := Subst( cTextoAdd, 66, 64 )
			If !Empty( cTextoAdd )
				AADD( xLINHASAD, cTextoAdd )
			EndIf
		EndIf
		
	Next
	
EndIf

// *** Adiciona a Mensagem Padrao

If !Empty( xCOD_MENS )
	cTextoAdd := Formula( xCOD_MENS )
	nTamanho  := Len( cTextoAdd )
	If !Empty( cTextoAdd )
		For nAA := 0 To Int( nTamanho / 70 ) + 1
			If nAA == 0
				AADD( xLINHASAD, Subst( cTextoAdd, 1, 70 ) )
			Else
				If !Empty( Subst( cTextoAdd, (nAA*70)+1, 70 ) )
					AADD( xLINHASAD, Subst( cTextoAdd, (nAA*70)+1, 70 ) )
				EndIf
			EndIf
		Next
	EndIf
EndIf

// *** Adiciona dados da nota fiscal complementar de importacao

If !Empty(_cMensag1)
	AADD( xLINHASAD, _cMensag1 )
EndIf

//Mensagem de FИrias no final de ano
//AADD( xLINHASAD, "FиRIAS")

If SM0->M0_CODIGO <> "03"
	AADD( xLINHASAD, "Conforme Decreto 4.441 de 2002 (em vigor a partir de 01/11/02)")
EndIf

If SM0->M0_CODIGO == "03"
	If !Empty(xTRANS_AM)
		If !Empty(xCOD_TRAN)
			AADD( xLINHASAD, "Redespacho, "+xNOME_TRANSP)
			AADD( xLINHASAD, xEND_TRANSP+" - "+xMUN_TRANSP+" - "+xEST_TRANSP)
			AADD( xLINHASAD, "Cep :"+xCEP_TRANSP+" - Tel :"+xTEL_TRANSP)
		EndIf
	EndIf
EndIf

nQTD_ADD := Len( xLINHASAD )      // Qtde de Linhas de dados adicionais da NF

Return

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    Ё ImprAdd  Ё Autor Ё Alberto N. G. Junior  Ё Data Ё 28/09/99 Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё Imprime e Controla as linhas de dados adicionais - COEL    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       Ё Nfiscal                                                    Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/

Static Function ImprAdd()

If nContr_Add <= nQTD_ADD .AND. nContr_Add < 25
	@ nLin,  03 PSAY xLINHASAD[ nContr_Add ]
	nContr_Add := nContr_Add + 1
EndIf

Return

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    Ё ImprDup  Ё Autor Ё Alberto N. G. Junior  Ё Data Ё 28/09/99 Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё Imprime e Controla as linhas de duplicatas - COEL          Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       Ё Nfiscal                                                    Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/

Static Function ImprDup()

If mv_par04 == 2 .AND. xDUPLICATAS == .T.
	
	If nContr_Dup <= Len( xPARC_DUP ) .AND. nContr_Dup < 6
		@ nLin, 160 PSAY xPARC_DUP[ nContr_Dup ]
		@ nLin, 171 PSAY xVALOR_DUP[ nContr_Dup ] Picture("@E 9,999,999.99")
		@ nLin, 191 PSAY xVENC_DUP[ nContr_Dup ]
		nContr_Dup := nContr_Dup + 1
	EndIf
	
EndIf

Return

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    Ё ImprIss  Ё Autor Ё Alberto N. G. Junior  Ё Data Ё 28/09/99 Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё Imprime e Controla linhas c/ descricao do serv. prestado   Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       Ё Nfiscal                                                    Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/

Static Function ImprIss()

If nContr_ISS <= Len( xLIN_ISS )
	
	@ nLin, 04 PSAY xLIN_ISS[ nContr_ISS ]
	nContr_ISS := nContr_ISS + 1
	
EndIf

Return

Static Function DigitaMens()

_cMensag1:= Space(50)

@ 80,50 TO 523,675 DIALOG oDlg5 TITLE "Observacoes Nota Fiscal Complemento Importacao"
@ 4,6 TO 215,305
@ 190,260 BMPBUTTON TYPE 1 ACTION Close(oDlg5)
@ 020,015 SAY "Numero da Importacao: "
@ 040,015 GET _cMensag1

ACTIVATE DIALOG oDlg5
//Close(oDlg5)
Return



