#include "rwmake.ch"

User Function Impnficm()

/*/
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁPrograma  Ё  Nfiscal Ё Autor Ё Rogerio B.Oliveira    Ё Data Ё 16/07/07 Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o Ё Nota Fiscal de Entrada ICMS (Coelmatic)                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       Ё Especifico para COEL Controles ElИtricos                   Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*/                                            

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
SetPrvt("XMUN_TRANSP1,XEST_TRANSP1,XVIA_TRANSP1,XCGC_TRANSP1,XTEL_TRANSP1,XNOME_TRANSP,XEND_TRANSP,XREGTRIB,XMENTRIB")

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para parametros                         Ё
//Ё mv_par01             // Da Nota Fiscal                       Ё
//Ё mv_par02             // Ate a Nota Fiscal                    Ё
//Ё mv_par03             // Da Serie                             Ё
//Ё mv_par04             // Resolucao                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

tamanho   := "G"
nLimite   := 220
titulo    := PADC("Nota Fiscal - Nfiscal",74)
cDesc1    := PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2    := ""
cDesc3    := PADC("da Nfiscal",74)
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "Impnficm"
cPerg     := "IMPNF"
nLastKey  := 0
lContinua := .T.
nLin      := 0
wnrel     := "Impnficm"
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
	RptStatus({|| RptEntra()})

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	OurSpool( wnrel )
EndIf

MS_FLUSH()

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
	//	xVALOR_MERC := SF1->F1_BASEICM         // Valor  da Mercadoria
	xVALOR_MERC := SF1->F1_VALMERC         // Valor  da Mercadoria
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
			@ nLin,  05 PSAY xCOD_PRO[I]   Picture "@R XX.XXX.XXX"
			If SM0->M0_CODIGO == "03"
				@ nLin,  23 PSAY SUBS(xDESCRICAO[I],1,50)+"-DCR "+xDESC_DCR[I]
			Else
				@ nLin,  23 PSAY xDESCRICAO[I]
			EndIf
			@ nLin,  93 PSAY xCOD_FIS[I]
			@ nLin,  98 PSAY xCOD_TRIB[I]
			@ nLin, 103 PSAY xUNID_PRO[I]
			@ nLin, 108 PSAY xQTD_PRO[I]                                  Picture"@E 999,999.99"
			@ nLin, 124 PSAY xPRE_UNI[I]  + xDESC_ZFR[I] / xQTD_PRO[I]    Picture"@E 99,999,999.9999"
			@ nLin, 149 PSAY xVAL_MERC[I] + xDESC_ZFR[I]                  Picture"@E 99,999,999.99"
			@ nLin, 170 PSAY Iif( zFranca==.T., 0, xICM_PROD[I] )         Picture"99"
			@ nLin, 177 PSAY xIPI[I]                                      Picture"@E 99.9"
			@ nLin, 189 PSAY xVAL_IPI[I]                                  Picture"@E 9,999,999.99"
			nLin := nLin + 1
		EndIf
		
			nLin := nLin + 2	
          
			@ nLin,  05 PSAY "** AQUISICAO DE SERVICO DE TRANSPORTE DE SAIDA CONFORME RELACAO DE CONHECIMENTO EM ANEXO"
			nLin := nLin + 2
			@ nLin,  05 PSAY "** ICMS A RECOLHER NO VALOR DE R$ "
			@ nLin,  40 PSAY xVALOR_ICMS*0.80 Picture"@E 999,999.99"
			@ nLin,  50 PSAY " EQUIVALENTE A 80% DO ICMS, CFE. RESOLUCAO No. 002/2001"
			nLin := nLin + 1
	EndIf
	
Next


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

If mv_par04 <> 1
	DadosAdd()
EndIf

nContr_Add := 1             // Controle da linha dos dados adicionais
nContr_Dup := 1             // Controle da linha das duplicatas
nLin       := 1

@ nLin, 0 PSAY Chr(15)
@ nLin, 192 PSAY xNUM_NF //+ Chr(15)    // Numero da Nota Fiscal nao Comprimido

nLin := 2
ImprAdd()

nLin := 3
ImprAdd()

nLin := 4
ImprAdd()

@ nLin, 168 PSAY "X"

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
		@ nLin, 77 PSAY ""                         // Texto da 2╕ Natureza
		@ nLin,119 PSAY ""                         // Cod.  da 2╕ Natureza
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

nLin := 54

@ nLin, 07	PSAY xBASE_ICMS  Picture"@E@Z 999,999,999.99"  // Base do ICMS
@ nLin, 37	PSAY xVALOR_ICMS Picture"@E@Z 999,999,999.99"  // Valor do ICMS
@ nLin, 65	PSAY xBSICMRET	 Picture"@E@Z 999,999,999.99"  // Base ICMS Ret.
@ nLin, 90	PSAY xICMS_RET	 Picture"@E@Z 999,999,999.99"  // Valor  ICMS Ret.
@ nLin,120	PSAY xVALOR_MERC Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.

nLin := 56
@ nLin, 05	PSAY xFRETE	     Picture"@E@Z 999,999,999.99"  // Valor do Frete
@ nLin, 35	PSAY xSEGURO	 Picture"@E@Z 999,999,999.99"  // Valor Seguro
@ nLin, 65	PSAY xDESPACESS  Picture"@E@Z 999,999,999.99"  // Valor Despesas Acessorias
@ nLin, 90	PSAY xVALOR_IPI  Picture"@E@Z 999,999,999.99"  // Valor do IPI
If !xTESPROD[1] $ "994"                                    // modificado por Andre em 20/09/2005
@ nLin,120	PSAY xTOT_FAT	 Picture"@E@Z 999,999,999.99"  // Valor Total NF    Aqui esta
Endif
If SM0->M0_CODIGO == "03"
	nLin:=nLin+1
	@ nLin,170   PSAY Chr(18) +xNUM_NF+Chr(15)       		                   // Numero da Nota Fiscal
Endif

nLin := 59

If xTPFRETE == "C"                                   // Frete por conta do
	@ nLin, 81  PSAY "2"                              // Emitente (1)
ElseIf Empty( xTPFRETE )                             //     ou
	@ nLin, 81  PSAY " "
Else
	@ nLin, 81  PSAY "1"                              // Destinatario (2)
Endif

@ nLin, 85  PSAY " "                                  // Reserv. p/ Placa Veiculo
@ nLin,103  PSAY " "                                  // Reserv. U.F. Placa

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
@ nLin, 07  PSAY Chr(18) + xNUM_NF+Chr(15)		   // Numero da Nota Fiscal
nLin := 72
@ nLin, 000 PSAY " "
SetPrc(0,0)

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
If mv_par04 <> 1 
	If nContr_Add <= nQTD_ADD .AND. nContr_Add < 25
		@ nLin,  03 PSAY xLINHASAD[ nContr_Add ]
		nContr_Add := nContr_Add + 1
	EndIf
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

If xDUPLICATAS == .T.
	
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



