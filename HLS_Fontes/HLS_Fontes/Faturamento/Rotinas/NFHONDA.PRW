#include "rwmake.ch"

/*/{protheus.doc}NFHONDA
Este programa ira emitir a Nota Fiscal de Entrada/Saida.
Usado aqui para complementar os registros do SC9.
@author Fernando Bombardi 
@since 05/11/08
/*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ NFHONDA  ³ Autor ³ Fernando Bombardi     ³ Data ³ 05/11/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nota Fiscal de Entrada e Saida                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Honda Lock                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function NFHONDA()

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,NAT,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI,XNF_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID,XPED")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,xINS_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XB_ICMS_SOL")
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB")
SetPrvt("xNom_CliEnt,xCNPJ_CliEnt,xIns_CliEnt,xEnd_CliEnt,xBairroEnt,xMun_CliEnt,xEst_CliEnt,xCep_CliEnt")
SetPrvt("xEnd_CliCob,xBairroCob,xMun_CliCob,xEst_CliCob,xCep_CliCob")
SetPrvt("xSitTrib,xCfNat,XCOD_OP,xdescon,xpedCliente,xPedImp")
SetPrvt("xCOD_MENSC5,_lCApres,_cDescr,_cPlaca,_cUFPlaca,xValISS,xValissIt,xBaseISS,xTOT_NF,cNUM_NFDV")
SetPrvt("_lImprime,xMensaSF1,xPisSF1,xCofSF1,xdesc_prc,_cdesc_prc,xDespesa,xCOD_MATR,xSLIP_NUM,xF1_NRDI,xF1_TAXARG,xF1_SREF,xF1_NEMBALA,xF1_ROMPROC")

Public xObsIpi:=.F.  // Adicionado RZ em 16.11.07
//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦
//¦ mv_par03             // Da Serie                             ¦
//¦ mv_par04             // Nota Fiscal de Entrada/Saida         ¦
//+--------------------------------------------------------------+

CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="G"
limite:=220
titulo :=PADC("Nota Fiscal - Nfiscal",74)
cDesc1 :=PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida.",74)
cDesc2 :=""
cDesc3 :=PADC("",74)
cNatureza:=""
aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="NFHONDA"
cPerg:="NFHONDA"
nLastKey:= 0
lContinua := .T.
nLin:=0
NAT:=0
RAZ:=0
wnrel    := "NFHONDA"

//+-----------------------------------------------------------+
//¦ Tamanho do Formulario de Nota Fiscal (em Linhas)          ¦
//+-----------------------------------------------------------+

nTamNf:=72     // Apenas Informativo

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+

//AjustaSX1()

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦ Inicio do Processamento da Nota Fiscal                       ¦
//¦                                                              ¦
//+--------------------------------------------------------------+
RptStatus({|| RptDetail()})

Return


//+--------------------------------------------------------------+
Static Function RptDetail()
//+--------------------------------------------------------------+

Local J
Local I

If mv_par04 == 2
	dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial()+mv_par01+mv_par03)
	cPedant := SD2->D2_PEDIDO
	
	dbSelectArea("SA1")                           // * RC 080808
	DbSetOrder(1)                                 // * RC 080808
	dBSeek(xFilial("SA1") + SF2->F2_CLIENTE)      // * RC 080808
Else
	dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
Endif

//+-----------------------------------------------------------+
//¦ Inicializa  regua de impressao                            ¦
//+-----------------------------------------------------------+
SetRegua(Val(mv_par02)-Val(mv_par01))

If mv_par04 == 2
	dbSelectArea("SF2")
	While !eof() .and. xFilial() == SF2->F2_FILIAL .and. SF2->F2_DOC <= mv_par02 .and. lContinua
		
		If SF2->F2_SERIE # mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		
		#IFNDEF WINDOWS
			IF LastKey()==286
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ELSE
			IF lAbortPrint
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ENDIF
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		
		//+--------------------------------------------------------------+
		//¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
		//+--------------------------------------------------------------+
		
		// * Cabecalho da Nota Fiscal
		
		xNUM_NF     :=SF2->F2_DOC             // Numero
		xSERIE      :=SF2->F2_SERIE           // Serie
		xCLIENTE    :=SF2->F2_CLIENTE         // Codigo do Cliente
		xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
		xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
		xTOT_NF     :=SF2->F2_VALBRUT
		xFRETE      :=SF2->F2_FRETE           // Frete
		xSEGURO     :=SF2->F2_SEGURO          // Seguro
		xBASE_ICMS  :=SF2->F2_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF2->F2_BASEIPI         // Base   do IPI
		xVALOR_ICMS :=SF2->F2_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF2->F2_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF2->F2_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
		xPESO_LIQ   :=SF2->F2_PLIQUI          // Peso Liquido
		xPESO_BRU   :=SF2->F2_PBRUTO          // Peso Bruto
		xVOLUME     :=SF2->F2_VOLUME1         // Volume 1 no Pedido
		xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
		xValISS	  :=SF2->F2_VALISS		     // Valor do ISS
		xBaseISS    :=SF2->F2_BASEISS	        // Valor do Serviço
		xDespesa    :=0
		
		If xPESO_LIQ > 0
			_lPeso:=.F.
		Else
			_lPeso:=.T.
		Endif
		
		dbSelectArea("SD2")                   // * Itens de Venda da N.F.
		dbSetOrder(3)
		dbSeek(xFilial()+xNUM_NF+xSERIE)
		
		cPedAtu := SD2->D2_PEDIDO
		cItemAtu := SD2->D2_ITEMPV
		
		xPED_VEND:={}                         // Numero do Pedido de Venda
		xPEDIMP  :={}
		xITEM_PED:={}                         // Numero do Item do Pedido de Venda
		xNUM_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xQTD_PRO :={}                         // Quantidade do Produto
		xPRE_UNI :={}                         // Preco Unitario de Venda
		xPRE_TAB :={}                         // Preco Unitario de Tabela
		xIPI     :={}                         // Porcentagem do IPI
		xVAL_IPI :={}                         // Valor do IPI
		xDESC    :={}                         // Desconto por Item
		xVAL_DESC:={}                         // Valor do Desconto
		xVAL_MERC:={}                         // Valor da Mercadoria
		xTES     :={}                         // TES
		xCF      :={}                         // Classificacao quanto natureza da Operacao
		xCFNAT   :={}                         // CFOP para pesquisa da descrição da natureza
		xICMSOL  :={}                         // Base do ICMS Solidario
		xICM_PROD:={}                         // ICMS do Produto
		xValissIt:={}							     // Valor do ISS do Item
		xDESC_PRO:={}                         // Descricao aux do produto
		
		npElem   :=0
		
		while !eof() .and. xFilial() == SD2->D2_FILIAL .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			If SD2->D2_SERIE #mv_par03         // Se a Serie do Arquivo for Diferente
				DbSkip()                     // do Parametro Informado !!!
				Loop
			Endif
			
			AADD(xPED_VEND ,SD2->D2_PEDIDO)
			
			If !Empty(SD2->D2_PEDIDO)
				npElem := ascan(xPedImp,SD2->D2_PEDIDO)
				If npElem == 0
					AADD(xPedImp,SD2->D2_PEDIDO)
				Endif
			Endif
			
			AADD(xITEM_PED ,SD2->D2_ITEMPV)
			AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
			AADD(xPREF_DV  ,SD2->D2_SERIORI)
			AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			AADD(xCOD_PRO  ,SD2->D2_COD)
			AADD(xQTD_PRO  ,SD2->D2_QUANT)
			AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
			AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
			AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))     // ALTERADO POR RC 11/08/08
			AADD(xVAL_IPI  ,SD2->D2_VALIPI)                            // ALTERADO POR RC 11/08/08
			AADD(xDESC     ,SD2->D2_DESC)
			AADD(xVAL_DESC ,SD2->D2_DESCON)
			//       AADD(xVAL_MERC ,NoRound(SD2->D2_PRCVEN*SD2->D2_QUANT,2))      //SD2->D2_TOTAL)
			AADD(xVAL_MERC ,Round(SD2->D2_PRCVEN*SD2->D2_QUANT,2))      //SD2->D2_TOTAL)
			
			AADD(xTES      ,SD2->D2_TES)
			AADD(xCF       ,SD2->D2_CF)
			AADD(xValissIt ,SD2->D2_VALISS)
			
			npElem := ascan(xCfNat,SD2->D2_CF)
			If npElem == 0
				AADD(xCfNat,SD2->D2_CF)
			Endif
			
			AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xCOD_TRIB:={}                           // Codigo de Tributacao
		xCLAS_FIS:={}                           // Classificacao Fiscal
		xCLFISCAL:={}
		xCLFIS   :={}
		_CLASFIS :=Space(1)
		
		xObsIpi:=.F.
		
		I:=1
		
		For I:=1 to Len(xCOD_PRO)
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial()+xCOD_PRO[I])
			
			AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
			AADD(xCLAS_FIS ,SB1->B1_POSIPI)
			
		Next I
		
		dbSelectArea("SC5")                            // * Pedidos de Venda
		dbSetOrder(1)
		
		xPED        := {}
		xCOD_MENSC5 := {}
		_cPlaca	  :=""
		_cUFPlaca   :=""
		
		
		For I:=1 to Len(xPED_VEND)
			
			dbSeek(xFilial()+xPED_VEND[I])
			If ASCAN(xPED,xPED_VEND[I])==0
				dbSeek(xFilial()+xPED_VEND[I])
				xCLIENTENT  :=SC5->C5_CLIENT             // Codigo do Cliente de Entrega
				xLOJAENT    :=SC5->C5_LOJAENT            // Loja do Cliente de Entrega
				XTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
				If !Empty(SC5->C5_MENNOTA)
					xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
				Endif
				xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
				xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
				xCOD_VEND:= {SC5->C5_VEND1,;             // Codigo do Vendedor 1
				SC5->C5_VEND2,;             // Codigo do Vendedor 2
				SC5->C5_VEND3,;             // Codigo do Vendedor 3
				SC5->C5_VEND4,;             // Codigo do Vendedor 4
				SC5->C5_VEND5}              // Codigo do Vendedor 5
				xDESC_NF := {SC5->C5_DESC1,;             // Desconto Global 1
				SC5->C5_DESC2,;             // Desconto Global 2
				SC5->C5_DESC3,;             // Desconto Global 3
				SC5->C5_DESC4}              // Desconto Global 4
				
				xVOLUME     :=SC5->C5_VOLUME1
				AADD(xPED,xPED_VEND[I])
				If !Empty(SC5->C5_MENPAD)
					If Ascan(xCOD_MENSC5, SC5->C5_MENPAD) == 0
						AADD(xCOD_MENSC5,SC5->C5_MENPAD)
					Endif
				Endif
			Endif
			
		Next I
		
		//+---------------------------------------------+
		//¦ Pesquisa da Condicao de Pagto               ¦
		//+---------------------------------------------+
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCONDPAG)
		
		xDESC_PAG := SE4->E4_DESCRI
		
		_lCApres:=.F.
		
		If Len(Alltrim(SE4->E4_COND)) == 1 .and. Subs(SE4->E4_COND,1,1) == "0" .and. SE4->E4_TIPO <> "9"
			_lCApres:=.T.
			_cDescr :=Subs(SE4->E4_DESCRI,1,8)
		Endif
		
		dbSelectArea("SC6")
		dbSetOrder(1)
		XCOD_OP  :={}							      // Numero da OP
		xUNID_PRO:={}
		xPED_CLI :={}                          // Numero de Pedido do cliente
		npElem   :=0
		xdesc_prc:={}
		xCOD_MATR := {}
		xSLIP_NUM := {}
		
		J:=Len(xPED_VEND)
		
		For I:=1 to J
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek(xFilial("SC6")+xPED_VEND[I]+xITEM_PED[I])
			
			AADD(xUNID_PRO ,SC6->C6_UM)
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial()+xCOD_PRO[I])
			
			//AADD(xDESC_PRO ,SB1->B1_DESCNF)
			AADD(xDESC_PRO, SC6->C6_DESCRI)
			AADD(xCOD_MATR ,SB1->B1_CODMATR)
			AADD(xSLIP_NUM ,posicione("SC6",1,xFilial("SC6")+xPED_VEND[I]+xITEM_PED[I],"C6_SLIPNUM"))
			
			npElem := ascan(xPED_CLI,SC6->C6_PEDCLI)
			
			If npElem == 0
				AADD(xPED_CLI ,SC6->C6_PEDCLI)
			Endif
			
		Next j
		
		If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'
			
			
			dbSelectArea("SA1")                // * Cadastro de Clientes - Endereco de Entrega
			dbSetOrder(1)
			
			If !Empty(xCLIENTENT)
				
				dbSeek(xFilial()+xCLIENTENT+xLOJAENT)
				
				If Found()
					xNom_Client := Alltrim(SA1->A1_NOME)
					xCnpj_Client:= SA1->A1_CGC
					xIns_Client := SA1->A1_INSCR
					xEnd_CliEnt := Alltrim(SA1->A1_END)
					xBairroEnt	:= Alltrim(SA1->A1_BAIRRO)
					xMun_CliEnt	:= Alltrim(SA1->A1_MUN)
					xEst_CliEnt	:= SA1->A1_EST
					xCep_CliEnt	:= SA1->A1_CEP
				Endif
			Endif
			
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			xCOD_CLI 		:=SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI		:=Alltrim(SA1->A1_NOME)   // Nome
			xEND_CLI 		:=SA1->A1_END             // Endereco
			xBAIRRO  		:=SA1->A1_BAIRRO          // Bairro
			xCEP_CLI 		:=SA1->A1_CEP             // CEP
			xEnd_CliCob	:=Alltrim(SA1->A1_ENDCOB) // Endereco de Cobranca
			xBairroCob		:=Alltrim(SA1->A1_BAIRROC)
			xMun_CliCob	:=Alltrim(SA1->A1_MUNC)
			xEst_CliCob	:=SA1->A1_ESTC
			xCep_CliCob	:=SA1->A1_CEPC
			If Empty(xCLIENTENT)
				xEnd_CliEnt := Alltrim(SA1->A1_ENDENT)
				xBairroEnt	:= Alltrim(SA1->A1_BAIRROE)
				xMun_CliEnt	:= Alltrim(SA1->A1_MUNE)
				xEst_CliEnt	:= SA1->A1_ESTE
				xCep_CliEnt	:= SA1->A1_CEPE
			Endif
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			xSUFRAMA :=SA1->A1_SUFRAMA         // Codigo Suframa
			xCALCSUF :=SA1->A1_CALCSUF         // Calcula Suframa
			
			// Alteracao p/ Calculo de Suframa
			
			if !empty(xSUFRAMA) .and. xCALCSUF =="S"
				IF XTIPO == 'D' .OR. XTIPO == 'B'
					zFranca := .F.
				else
					zFranca := .T.
				endif
			Else
				zfranca:= .F.
			endif
			
		Else
			zFranca:=.F.
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
			xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
			xEND_CLI :=SA2->A2_END             // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
			xCEP_CLI :=SA2->A2_CEP             // CEP
			xCOB_CLI :=""                      // Endereco de Cobranca
			xREC_CLI :=""                      // Endereco de Entrega
			xMUN_CLI :=SA2->A2_MUN             // Municipio
			xEST_CLI :=SA2->A2_EST             // Estado
			xCGC_CLI :=SA2->A2_CGC             // CGC
			xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
			xTEL_CLI :=SA2->A2_TEL             // Telefone
			xFAX_CLI :=SA2->A2_FAX             // Fax
		Endif
		
		dbSelectArea("SA3")                   // * Cadastro de Vendedores
		dbSetOrder(1)
		xVENDEDOR:={}                         // Nome do Vendedor
		I:=1
		J:=Len(xCOD_VEND)
		For I:=1 to J
			dbSeek(xFilial()+xCOD_VEND[I])
			Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		Next j
		
		If xICMS_RET >0                          // Apenas se ICMS Retido > 0
			dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
			dbSetOrder(4)
			dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
			If Found()
				xBSICMRET:=F3_VALOBSE
			Else
				xBSICMRET:=0
			Endif
		Else
			xBSICMRET:=0
		Endif
		
		dbSelectArea("SA4")                   // * Transportadoras
		dbSetOrder(1)
		dbSeek(xFilial()+SF2->F2_TRANSP)
		
		xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
		xEND_TRANSP  :=SA4->A4_END            // Endereco
		xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
		xEST_TRANSP  :=SA4->A4_EST            // Estado
		xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
		xCGC_TRANSP  :=SA4->A4_CGC            // CGC
		xTEL_TRANSP  :=SA4->A4_TEL            // Fone
		xINS_TRANSP  :=SA4->A4_INSEST         // Inscricao Estadual
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			If !("NF" $ SE1->E1_TIPO)
				dbSkip()
				Loop
			Endif
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		DbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		DbSetOrder(1)
		
		xSitTrib :={}
		xNatureza:= {}
		xCOD_MENS:= {}
		
		I:=1
		J:=Len(xTES)
		_cTes := ""
		For I:=1 to J
			dbSeek(xFilial()+xTES[I])
			If !Alltrim( xTES[I]) $ Alltrim(_cTes)
				If !Empty(SF4->F4_MENSNFA)
					AADD(xCOD_MENS,SF4->F4_MENSNFA)	    // Mensagem Fiscal
				Endif
				If !Empty(SF4->F4_MENSNFB)
					AADD(xCOD_MENS,SF4->F4_MENSNFB)	    // Mensagem Fiscal
				Endif
				If !Empty(SF4->F4_MENSNFC)
					AADD(xCOD_MENS,SF4->F4_MENSNFC)	    // Mensagem Fiscal
				Endif
			EndIf
			_cTes += xTES[I]+"/"
			AADD(xSitTrib ,SF4->F4_SITTRIB)
		Next j
		
		I:=1
		J:=Len(xCFNAT)
		For I:=1 to J
			AADD( xNatureza,Alltrim(Tabela("13",xCFNAT[I],.F.)))	    // Mensagem Fiscal
		Next j
		
		Imprime()
		
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF2")
		/*
		RecLock("SF2")
		SF2->F2_FIMP:="S"
		MsUnlock()
		*/
		dbSkip()                      // passa para a proxima Nota Fiscal
	EndDo
Else
	dbSelectArea("SF1")
	
	While !eof() .and. xFilial() == SF1->F1_FILIAL .and. SF1->F1_DOC <= mv_par02 .and. lContinua
		
		If SF1->F1_SERIE # mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		
		/*
		If SF1->F1_FORMUL # "S"        // Tem que ser formulario proprio.
		DbSkip()
		Loop
		Endif
		*/
		
		#IFNDEF WINDOWS
			IF LastKey()==286
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ELSE
			IF lAbortPrint
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ENDIF
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		
		//+--------------------------------------------------------------+
		//¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
		//+--------------------------------------------------------------+
		
		// * Cabecalho da Nota Fiscal
		
		xNUM_NF     :=SF1->F1_DOC             // Numero
		xSERIE      :=SF1->F1_SERIE           // Serie
		xEMISSAO    :=SF1->F1_EMISSAO         // Data de Emissao
		xTOT_FAT    :=0//SF1->F1_VALFAT       // Valor Total da Fatura
		xTOT_NF     :=SF1->F1_VALBRUT
		if xTOT_FAT == 0
			xTOT_FAT := SF1->F1_VALMERC+SF1->F1_VALIPI+SF1->F1_SEGURO+SF1->F1_FRETE
		endif
		xFRETE      :=SF1->F1_FRETE           // Frete
		xSEGURO     :=SF1->F1_SEGURO          // Seguro
		xBASE_ICMS  :=SF1->F1_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF1->F1_BASEIPI         // Base   do IPI
		xVALOR_ICMS :=SF1->F1_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF1->F1_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF1->F1_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF1->F1_VALMERC-SF1->F1_DESCONT         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF1->F1_DUPL            // Numero da Duplicata
		xCOND_PAG   :=""                      // Condicao de Pagamento
		xPESO_LIQ   :=0				           // Peso Liquido
		xPESO_BRU   :=0          				  // Peso Bruto
		xVOLUME     :=0				           // Volume 1 no Pedido
		xTIPO       :=SF1->F1_TIPO            // Tipo do Cliente
		xESPECIE    :=""         				  // Especie 1 no Pedido
		xValISS	  :=0								  // Valor do ISS
		xBaseISS    :=0	        					  // Valor do Serviço
		xCLIENTE    :=SF1->F1_FORNECE          // Codigo do Cliente
		xLOJA       :=SF1->F1_LOJA            // Loja do Cliente
		xCONDPAG    :=SF1->F1_COND            // Condicao de Pagamento
		xDespesa	  := SF1->F1_DESPESA         // Despesa
		xBSICMRET   := 0
		xVALPIS     := SF1->F1_PISIMP
		xVALCOF     := SF1->F1_COFIMP
		
		xF1_NRDI    := SF1->F1_NRDI
		xF1_TAXARG  := SF1->F1_TAXARG
		xF1_SREF    := SF1->F1_SREF
		xF1_NEMBALA := SF1->F1_NEMBALA
		xF1_ROMPROC := SF1->F1_ROMPROC
		
		dbSelectArea("SD1")                   // * Itens de Venda da N.F.
		dbSetOrder(1)
		dbSeek(xFilial()+xNUM_NF+xSERIE+xCLIENTE+xLOJA)
		
		xNUM_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xQTD_PRO :={}                         // Quantidade do Produto
		xPRE_UNI :={}                         // Preco Unitario de Venda
		xPRE_TAB :={}                         // Preco Unitario de Tabela
		xIPI     :={}                         // Porcentagem do IPI
		xVAL_IPI :={}                         // Valor do IPI
		xDESC    :={}                         // Desconto por Item
		xVAL_DESC:={}                         // Valor do Desconto
		xVAL_MERC:={}                         // Valor da Mercadoria
		xTES     :={}                         // TES
		xCF      :={}                         // Classificacao quanto natureza da Operacao
		xCFNAT   :={}                         // CFOP para pesquisa da descrição da natureza
		xICM_PROD:={}                         // ICMS do Produto
		xValissIt:={}							// Valor do ISS do Item
		xDESC_PRO:={}                         // Descricao aux do produto
		XCOD_OP  :={}							// Numero da OP
		npElem   :=0
		xPESO_LIQ :=0
		xPESO_BRU :=0
		xdesc_prc:={}
		xPedImp	:={}
		
		while !eof() .and. xFilial() == SD1->D1_FILIAL .and. SD1->D1_DOC==xNUM_NF .and. SD1->D1_SERIE==xSERIE ;
			.and. SD1->D1_FORNECE == xCLIENTE .and. SD1->D1_LOJA == xLOJA
			
			If SD1->D1_SERIE #mv_par03         // Se a Serie do Arquivo for Diferente
				DbSkip()                   // do Parametro Informado !!!
				Loop
			Endif
			
			AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
			AADD(xPREF_DV  ,SD1->D1_SERIORI)
			AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(xCOD_PRO  ,SD1->D1_COD)
			AADD(xDESC_PRO ,SD1->D1_DESCRI)
			AADD(xQTD_PRO  ,SD1->D1_QUANT)
			AADD(xPRE_UNI  ,SD1->D1_VUNIT)
			AADD(xPRE_TAB  ,SD1->D1_VUNIT)
			AADD(xIPI      ,IIF(Empty(SD1->D1_IPI),0,SD1->D1_IPI))
			AADD(xVAL_IPI  ,SD1->D1_VALIPI)
			AADD(xDESC     ,SD1->D1_DESC)
			AADD(xVAL_DESC ,SD1->D1_VALDESC)
			//         AADD(xVAL_MERC ,NoRound(SD1->D1_VUNIT*SD1->D1_QUANT,2)-(SD1->D1_VALDESC))  //SD2->D2_TOTAL)
			AADD(xVAL_MERC ,Round(SD1->D1_VUNIT*SD1->D1_QUANT,2)-(SD1->D1_VALDESC))  //SD2->D2_TOTAL)
			AADD(xTES      ,SD1->D1_TES)
			AADD(xCF       ,SD1->D1_CF)
			AADD(XCOD_OP   ,0)
			AADD(xValissIt ,0)
			
			npElem := ascan(xCfNat,SD1->D1_CF)
			If npElem == 0
				AADD(xCfNat,SD1->D1_CF)
			Endif
			
			AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			
			xPESO_BRU := xPESO_BRU + SD1->D1_PESO
			
			
			dbskip()
		End
		
		dbSelectArea("SB1")                   // * Desc. Generica do Produto
		dbSetOrder(1)
		xCOD_TRIB:={}                         // Codigo de Tributacao
		xCLAS_FIS:={}                         // Classificacao Fiscal
		xCLFISCAL:={}
		xCLFIS   :={}
		xUNID_PRO:={}
		
		_CLASFIS :=Space(1)
		
		I:=1
		xCOD_MATR := {}
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial()+xCOD_PRO[I])
			AADD(xCOD_MATR ,SB1->B1_CODMATR)
			If Empty(AllTrim(xDESC_PRO[I]))
				AADD(xDESC_PRO ,SB1->B1_DESC)
			EndIf
			AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xCLAS_FIS ,SB1->B1_POSIPI)
			
		Next I
		
		If !Empty(MV_PAR06)
			dbSelectArea("SA4")                   // * Transportadoras
			dbSetOrder(1)
			dbSeek(xFilial()+MV_PAR06)
			
			xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
			xEND_TRANSP  :=SA4->A4_END            // Endereco
			xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
			xEST_TRANSP  :=SA4->A4_EST            // Estado
			xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
			xCGC_TRANSP  :=SA4->A4_CGC            // CGC
			xTEL_TRANSP  :=SA4->A4_TEL            // Fone
			xINS_TRANSP  :=SA4->A4_INSEST         // Inscricao Estadual
		EndIf
		
		//+---------------------------------------------+
		//¦ Pesquisa da Condicao de Pagto               ¦
		//+---------------------------------------------+
		
		dbSelectArea("SE4")                    				// Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCONDPAG)
		
		xDESC_PAG := SE4->E4_DESCRI
		
		_lCApres:=.F.
		
		If Len(Alltrim(SE4->E4_COND)) == 1 .and. Subs(SE4->E4_COND,1,1) == "0" .and. SE4->E4_TIPO <> "9"
			_lCApres:=.T.
			_cDescr :=Subs(SE4->E4_DESCRI,1,8)
		Endif
		
		xPED_CLI :={}                          				// Numero de Pedido do cliente
		xCod_MenSC5:={}
		
		xClientEnt:=""
		
		If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'
			
			zFranca:=.F.
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
			xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
			xEND_CLI :=SA2->A2_END             // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
			xCEP_CLI :=SA2->A2_CEP             // CEP
			xCOB_CLI :=""                      // Endereco de Cobranca
			xREC_CLI :=""                      // Endereco de Entrega
			xMUN_CLI :=SA2->A2_MUN             // Municipio
			xEST_CLI :=SA2->A2_EST             // Estado
			xCGC_CLI :=SA2->A2_CGC             // CGC
			xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
			xTEL_CLI :=SA2->A2_TEL             // Telefone
			xFAX_CLI :=SA2->A2_FAX             // Fax
			
		Else
			
			dbSelectArea("SA1")                // * Cadastro de Clientes - Endereco de Entrega
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			xCOD_CLI 		:=SA1->A1_COD           		// Codigo do Cliente
			xNOME_CLI		:=Alltrim(SA1->A1_NOME)         // Nome
			xEND_CLI 		:=Alltrim(SA1->A1_END)          // Endereco
			xBAIRRO  		:=Alltrim(SA1->A1_BAIRRO)       // Bairro
			xCEP_CLI 		:=SA2->A2_CEP            		// CEP
			xMUN_CLI :=SA1->A1_MUN             			// Municipio
			xEST_CLI :=SA1->A1_EST             			// Estado
			xCGC_CLI :=SA1->A1_CGC           				// CGC
			xINSC_CLI:=SA1->A1_INSCR          				// Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP         				// Transportadora
			xTEL_CLI :=SA1->A1_TEL          			    // Telefone
			xFAX_CLI :=SA1->A1_FAX            				// Fax
			xSUFRAMA :=SA1->A1_SUFRAMA            			// Codigo Suframa
			xCALCSUF :=SA1->A1_CALCSUF           			// Calcula Suframa
			
			// Alteracao p/ Calculo de Suframa
			
			if !empty(xSUFRAMA) .and. xCALCSUF =="S"
				IF XTIPO == 'D' .OR. XTIPO == 'B'
					zFranca := .F.
				else
					zFranca := .T.
				endif
			Else
				zfranca:= .F.
			endif
			
		Endif
		
		If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'
			
			dbSelectArea("SE1")                   // * Contas a Receber
			dbSetOrder(1)
			
			xPARC_DUP  :={}                       // Parcela
			xVENC_DUP  :={}                       // Vencimento
			xVALOR_DUP :={}                       // Valor
			xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
			
			while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
				If !("NCC" $ SE1->E1_TIPO)
					dbSkip()
					Loop
				Endif
				
				If SE1->E1_CLIENTE+SE1->E1_LOJA <> xCLIENTE+xLOJA
					dbSkip()
					Loop
				Endif
				
				AADD(xPARC_DUP ,SE1->E1_PARCELA)
				AADD(xVENC_DUP ,SE1->E1_VENCTO)
				AADD(xVALOR_DUP,SE1->E1_VALOR)
				dbSkip()
			EndDo
		Else
			dbSelectArea("SE2")                   // * Contas a Receber
			dbSetOrder(1)
			
			xPARC_DUP  :={}                       // Parcela
			xVENC_DUP  :={}                       // Vencimento
			xVALOR_DUP :={}                       // Valor
			xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
			
			while !eof() .and. SE2->E2_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
				If SE2->E2_FORNECE+SE2->E2_LOJA <> xCLIENTE+xLOJA
					dbSkip()
					Loop
				Endif
				
				
				AADD(xPARC_DUP ,SE2->E2_PARCELA)
				AADD(xVENC_DUP ,SE2->E2_VENCTO)
				AADD(xVALOR_DUP,SE2->E2_VALOR)
				dbSkip()
			EndDo
			
		Endif
		
		DbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		DbSetOrder(1)
		
		xSitTrib :={}
		xNatureza:= {}
		xCOD_MENS:= {}
		
		I:=1
		J:=Len(xTES)
		For I:=1 to J
			AADD(xSitTrib ,SF4->F4_SITTRIB)
		Next j
		
		dbSeek(xFilial()+xTES[1])
		If !Empty(SF4->F4_MENSNFA)
			AADD(xCOD_MENS,SF4->F4_MENSNFA)	    // Mensagem Fiscal
		Endif
		If !Empty(SF4->F4_MENSNFB)
			AADD(xCOD_MENS,SF4->F4_MENSNFB)	    // Mensagem Fiscal
		Endif
		If !Empty(SF4->F4_MENSNFA)
			AADD(xCOD_MENS,SF4->F4_MENSNFC)	    // Mensagem Fiscal
		Endif
		
		I:=1
		J:=Len(xCFNAT)
		For I:=1 to J
			AADD( xNatureza,Alltrim(Tabela("13",xCFNAT[I],.F.)))	    // Mensagem Fiscal
		Next j
		
		Imprime()
		
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF1")
		
		dbSkip()                      // passa para a proxima Nota Fiscal
		
	EndDo
	
Endif
//+--------------------------------------------------------------+
//¦                                                              ¦
//¦                      FIM DA IMPRESSAO                        ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦ Fechamento do Programa da Nota Fiscal                        ¦
//+--------------------------------------------------------------+

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")
Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
//+--------------------------------------------------------------+
//¦ Fim do Programa                                              ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
Static Function IMPDET()
//+--------------------------------------------------------------+

Local I:=1
Local J:=1
Local W:=1

nTamDet    :=25         // Tamanho da Area de Detalhe
xDescon    :=0
xB_ICMS_SOL:=0          // Base  do ICMS Solidario
xV_ICMS_SOL:=0          // Valor do ICMS Solidario

For I:=1 to nTamDet
	If I<= Len(xCOD_PRO)
	    SB1->(DbSetOrder(1))
		SB1->(dbSeek(xFilial()+xCOD_PRO[I]))
		AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
		If MV_PAR04 == 2
		   //
		   If !Empty(SB1->B1_DESC) .And. !Empty(xCOD_MATR[I])
			  _cDescIt := Alltrim(xCOD_MATR[I]) + " - " + Alltrim(SB1->B1_DESC) + IIf(!Empty(xSLIP_NUM[I]), " - ", "") + Alltrim(xSLIP_NUM[I])
		   Else
		      _cDescIt := Alltrim(xCOD_PRO[I]) + " - " + Alltrim(xDESC_PRO[I]) + IIf(!Empty(xSLIP_NUM[I]), " - ", "") + Alltrim(xSLIP_NUM[I])
		   Endif
		   //
  		   If Empty(xDESC_PRO[I])
		      _cDescIt := xCOD_PRO[I]+" - "+SB1->B1_DESCNF
		   Endif
		Else
			//_cDescIt := Alltrim(xCOD_MATR[I])+" - "+Alltrim(xDESC_PRO[I])
			_cDescIt := Alltrim(xDESC_PRO[I])
		    If Alltrim(xCOD_MATR[I]) == Space(0)
			   _cDescIt := xCOD_PRO[I]+" - "+IIF(Alltrim(xDESC_PRO[I])==Space(0),Alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+xCOD_PRO[I],"B1_DESCNF")),Alltrim(xDESC_PRO[I]))
		    Endif
		Endif

		@ _nLin, 003  PSAY Substr(_cDescIt,1,70)
		@ _nLin, 090  PSAY xCLAS_FIS[I]
		@ _nLin, 114  PSAY xQTD_PRO[I]   Picture "@E 99999"
		@ _nLin, 123  PSAY xPRE_UNI[I]   Picture "@E 99,999,999.99999999"
		@ _nLin, 148  PSAY xVAL_MERC[I]  Picture "@E 9,999,999,999.99"
		@ _nLin, 174  PSAY xICM_PROD[I]  Picture "99"
		@ _nLin, 179  PSAY xIPI[I]       Picture "99"
		@ _nLin, 190  PSAY xVAL_IPI[I]   Picture "@E 9,999,999.99"
		_nLin++
	Endif
Next

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPMENP  ¦ Autor ¦ Jefferson Bellezo   ¦ Data ¦ 12/01/2006 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Mensagem Padrao da Nota Fiscal                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+


Static Function IMPMENP()
_cMensagem:=""

If Len(xCOD_MENS) > 0
	
	For I := 1 TO Len(xCOD_MENS)
		_cMensagem += Alltrim(FORMULA(xCOD_MENS[I]))+ " / "
	Next I
	_lPri := .T.
	For I:= 1 to MlCount(_cMensagem,58)
		If _lPri
			@ _nLin, 03   PSAY memoline(_cMensagem,58,I)
			@ _nLin, 159 PSAY "X"
			_lPri  := .F.
		Else
			@ _nLin, 03   PSAY memoline(_cMensagem,58,I)
		Endif
		If _nLin = 8
			ImpNat()
		else
			_nLin := _nLin + 1
		Endif
	Next
Else
	@ _nLin, 159 PSAY "X"
Endif


_cMensagem:=""
_bFuck := .F.

Return


Static Function IMPMENS()
_cMensagem:=""
_nLin := _nLin + 1

If Len(xCOD_MENS) > 0
	For I := 1 TO Len(xCOD_MENS)
		_cMensagem += Alltrim(FORMULA(xCOD_MENS[I]))+ " / "
	Next I
	_lPri := .T.
	For I:= 1 to MlCount(_cMensagem,58)
		If _lPri
			@ _nLin, 03   PSAY memoline(_cMensagem,58,I)
			@ _nlin, 173 PSAY "X"
			_lPri  := .F.
		Else
			@ _nLin, 03   PSAY memoline(_cMensagem,58,I)
		Endif
		_nLin := _nLin + 1
	Next
Endif


_cMensagem:=""
_bFuck := .F.

Return


Static Function IMPNAT()

L:=1
J:=Len(xCFNAT)

For L:=1 to J
	@ _nLin, 065 PSAY Subs(xNATUREZA[L],1,46)               // Texto da Natureza de Operacao
	If mv_par04 == 1
		@ _nLin, 117 PSAY Subs(xCFNAT[L],1,4) Picture PESQPICT("SD1","D1_CF") // Codigo da Natureza de Operacao
	Else
		@ _nLin, 117 PSAY Subs(xCFNAT[L],1,4) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
	EndIf
	_nLin:=_nLin + 1
Next J

Nat := 1

Return

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ MENSOBS  ¦ Autor ¦   Carlos       ¦ Data ¦ 23/02/2005 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Mensagem no Campo Observacao                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+


Static Function MENSOBS()

nTamObs:=65

nCol:=07

If xObsIpi == .T. // Adicionado por RZ em 16.11.07
	xMensagem:=Alltrim(xMensagem)+" "+"Aliquota Reduzida a 12% conforme res. SF 04/98"
Endif

If !Empty(xMensagem)
	@ _nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,1,nTamObs))
	_nlin:=_nlin+1
Endif
xMensagem:=""
Return

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ DUPLIC   ¦ Autor ¦   Carlos       ¦ Data ¦ 23/02/2005 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao do Parcelamento das Duplicacatas                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function DUPLIC
Static Function DUPLIC()

Local BB

nCol := 85
nAjuste := 0
_nDupl:=1
_nLin:=_NLin+1

For BB:= 1 to Len(xVALOR_DUP)
	If xDUPLICATAS==.T. .and. BB<=Len(xVALOR_DUP)
		@ _nLin, nCol + nAjuste      PSAY xNUM_DUPLIC + " " + xPARC_DUP[BB]
		@ _nLin, nCol + 22 + nAjuste PSAY xVENC_DUP[BB]
		@ _nLin, nCol + 42 + nAjuste PSAY xVALOR_DUP[BB] Picture("@E 9,999,999.99")
		nAjuste := 70
	Endif
	If _nDupl==2
		_nLin := _nLin + 1
		nCol := 85
		nAjuste := 0
		_nDupl:=1
	Else
		_nDupl:=_nDupl + 1
	Endif
Next

Return

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ LI       ¦ Autor ¦   Carlos       ¦ Data ¦ 23/02/2005 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Pula 1 linha                                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico RDMAKE                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+


//+--------------------------------------------------------------+
Static Function Imprime()
//+--------------------------------------------------------------+
//¦                                                              ¦
//¦              IMPRESSAO DA N.F. DA Nfiscal                    ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

//+-------------------------------------+
//¦ Impressao do Cabecalho da N.F.      ¦
//+-------------------------------------+


@ 00, 000 PSAY Chr(15)  // Compressao de Impressao

If mv_par04 == 1
	If !Empty(xF1_NRDI) .or. !Empty(xVALPIS) .or. !Empty(xVALCOF) .or. !Empty(xF1_TAXARG) .or. !Empty(xF1_SREF)
		@ 03, 003 PSAY "DI: "
		@ 03, 017 PSAY xF1_NRDI
		@ 03, 173 PSAY "X"
		@ 04, 003 PSAY "PIS: "
		@ 04, 017 PSAY Transform(xVALPIS,"@E 99,999,999.99")
		@ 05, 003 PSAY "COFINS: "
		@ 05, 017 PSAY Transform(xVALCOF,"@E 99,999,999.99")
		@ 06, 003 PSAY "Taxa Reg. DI: "
		@ 06, 017 PSAY Transform(xF1_TAXARG,"@E 99,999,999.99999")
		@ 07, 003 PSAY "S/ Ref.: "
		@ 07, 017 PSAY xF1_SREF
	EndIf
Endif

_nLin := 3

If MV_PAR04 == 2
	ImpMenp() 				// Imprime Mensagem Padrao da Nota Fiscal
Endif

If Empty(xF1_NRDI) .or. Empty(xVALPIS) .or. Empty(xVALCOF) .or. Empty(xF1_TAXARG) .or. Empty(xF1_SREF) .or. Empty(xF1_NEMBALA) .or. Empty(xF1_ROMPROC)
	If MV_PAR04 == 1
		ImpMenS() 				// Imprime Mensagem Padrao da Nota Fiscal
	Endif
Endif

If _nLin = 8
	ImpNat()
else
	_nLin := _nLin + 1
Endif

If mv_par04 == 2
	MensObs()         // Imprime Mensagem de Observacao
	xMensagem:=""
Endif

If _nLin = 8
	ImpNat()
else
	_nLin := _nLin + 1
Endif

If Nat <> 1
	I:=1
	J:=Len(xCFNAT)
	_nLin:=8
	
	If MV_PAR04 == 1
		If !Empty(xF1_NEMBALA)
			@ _nLin, 003 PSAY "Nº Embarque: "
			@ _nLin, 017 PSAY xF1_NEMBALA
		Endif
	Endif
	
	For I:=1 to J
		@ _nLin, 065 PSAY Subs(xNATUREZA[I],1,46)           					       // Texto da Natureza de Operacao
		If mv_par04 == 1
			@ _nLin, 117 PSAY Subs(xCFNAT[I],1,4) Picture PESQPICT("SD1","D1_CF") // Codigo da Natureza de Operacao
		Else
			@ _nLin, 117 PSAY Subs(xCFNAT[I],1,4) Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
		EndIf
		_nLin:=_nLin + 1
		If MV_PAR04 == 1
			If !Empty(xF1_ROMPROC)
				@ _nLin, 003 PSAY "Rom. Processo: "
				@ _nLin, 017 PSAY xF1_ROMPROC
			EndIf
		Endif
	Next j
	
endif
NAT := 1
If MV_PAR04 == 1
If !Empty(xF1_NRDI) .or. !Empty(xVALPIS) .or. !Empty(xVALCOF) .or. !Empty(xF1_TAXARG) .or. !Empty(xF1_SREF) .or. !Empty(xF1_NEMBALA) .or. !Empty(xF1_ROMPROC)
		ImpMenS() 				// Imprime Mensagem Padrao da Nota Fiscal
	Endif
Endif
_nLin:=11

NAT := 0

//+-------------------------------------+
//¦ Impressao dos Dados do Cliente      ¦
//+-------------------------------------+

If RAZ <> 1
	@ _nLin, 065 PSAY xNOME_CLI           //Nome do Cliente
	If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
		@ _nLin, 157 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
	Else
		@ _nLin, 157 PSAY " "              // Caso seja vazio
	Endif
	
	@ _nLin, 191 PSAY xEMISSAO              // Data da Emissao do Documento
Endif
_nLin := _nLin + 2
/*
If XNF_IPI = 1
@ _nLin, 07 PSAY "VALOR DO IPI NA OPERACAO:"
@ _nLin, 33 PSAY SF2->F2_VALIPI   Picture "@E 999,999.99"  // Valor do IPI
else
xNF_IPI := 0
endif
*/
@ _nLin, 065 PSAY substr(xEND_CLI,1,80)                  // Endereco
@ _nLin, 139 PSAY substr(xBAIRRO,1,27)                   // Bairro
@ _nLin, 172 PSAY xCEP_CLI Picture"@R 99999-999"         // CEP
@ _nLin, 191 PSAY IIF(MV_PAR04<>1,DTOC(MV_PAR05),"")  // Data Saida/Entrada

_nLin := _nLin + 2

@ _nLin, 065 PSAY xMUN_CLI                               // Municipio
@ _nLin, 122 PSAY substr(xTEL_CLI,1,30)                  // Telefone/FAX
@ _nLin, 152 PSAY xEST_CLI                               // U.F.
@ _nLin, 159 PSAY xINSC_CLI                              // Insc. Estadual
//@ _nLin, 206 PSAY " "                                    // Reservado p/Hora da Saida

/*
If mv_par04 == 2 .and. xDUPLICATAS

//+-------------------------------------+
//¦ Impressao da Fatura/Duplicata       ¦
//+-------------------------------------+

_nLin:=17
BB:=1
nCol := 02                                            //  duplicatas
DUPLIC()

Endif
*/

//+-------------------------------------+
//¦ Dados dos Produtos Vendidos         ¦
//+-------------------------------------+

If mv_par04 == 1
	_nLin += 3
	ImpDet() // Detalhe da NF
Else
	_nLin += 3
	ImpDet() // Detalhe da NF
Endif

//+-------------------------------------+
//¦ Calculo dos Impostos                ¦
//+-------------------------------------+

// Alterado Por Ronaldo Santos
If mv_par04 == 1
	_nLin := 36
Else
	_nLin := 36
Endif

@ _nLin, 013  PSAY xBASE_ICMS  Picture "@E 999,999,999.99"  // Base do ICMS  (47)  //10
@ _nLin, 039  PSAY xVALOR_ICMS Picture "@E 999,999,999.99"  // Valor do ICMS       //38
@ _nLin, 068  PSAY xBSICMRET   Picture "@E 999,999,999.99"  // Base ICMS Ret.      //67
@ _nLin, 093  PSAY xICMS_RET   Picture "@E 999,999,999.99"  // Valor  ICMS Ret.    //96
If xTIPO # "I"  //Imprime Total se não for Complemento de ICMS
	@ _nLin, 125  PSAY xVALOR_MERC+xDescon Picture "@E 999,999,999.99"  // Valor Tot. Prod. sem servico //128
EndIf

_nLin := _nLin + 2

@ _nLin, 013  PSAY xFRETE          	Picture "@E 999,999,999.99"  // Valor do Frete       (49)
@ _nLin, 039  PSAY xSEGURO         	Picture "@E 999,999,999.99"  // Valor Seguro
If mv_par04 == 1//Entrada de Importação
	xDespesa:=0
EndIf
@ _nLin, 068  PSAY xDespesa       	Picture "@E 999,999,999.99"  //Valor da Despesa
@ _nLin, 093  PSAY xVALOR_IPI      	Picture "@E 999,999,999.99"  // Valor do IPI
If xTIPO # "I"  												 //Imprime Total se não for Complemento de ICMS
	@ _nLin, 125  PSAY xTOT_NF     	Picture "@E 999,999,999.99"  // Valor Total NF
EndIf

_nLin := _nLin + 3


//+------------------------------------+
//¦ Impressao Dados da Transportadora  ¦
//+------------------------------------+

@ _nLin, 010  PSAY xNOME_TRANSP                              // Nome da Transport.   (52) //6

If xTPFRETE=='C' .or. Mv_par04==1                            // Frete por conta do
	@ _nLin, 87 PSAY "1"                                     // Emitente (1)                 //88
Else                                                         //     ou
	@ _nLin, 87 PSAY "2"                                     // Destinatario (2)
Endif

/*
If !Empty(_cPlaca)
@ _nLin, 107 PSAY _cPlaca                                // Placa do Veiculo        //92
@ _nLin, 117 PSAY _cUFPlaca                              // Estado da Placa         //112             // U.F.
Endif
*/

If !EMPTY(xCGC_TRANSP)                                       // Se C.G.C. Transportador nao for Vazio
	@ _nLin, 111 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"  //123
Endif

_nLin := _nLin + 2

@ _nLin, 010 PSAY xEND_TRANSP                          // Endereco Transp.  (54)       //6
@ _nLin, 080 PSAY xMUN_TRANSP                          // Municipio                    //74
@ _nLin, 103 PSAY xEST_TRANSP                          // U.F.                         //112
@ _nLin, 111 PSAY xINS_TRANSP                          // U.F.                         //112
//@ _nLin, 125 PSAY " "                                  // Reservado p/Insc. Estad.     //125

_nLin := _nLin + 2

@ _nLin, 005 PSAY xVOLUME  Picture "@E@Z 999,999"                // Quant. Volumes (56)      //8
@ _nLin, 031 PSAY xESPECIE Picture "@!"                          // Especie                  //26
@ _nLin, 055 PSAY " "                                            // Res para Marca           //52
@ _nLin, 079 PSAY " "                                            // Res para Numero          //75
@ _nLin, 120 PSAY xPESO_BRU       Picture "@E@Z 999,999.999"     // Res para Peso Bruto      //109
@ _nLin, 144 PSAY xPESO_LIQ       Picture "@E@Z 999,999.999"     // Res para Peso Liquido    //137

If mv_par04 == 2
	_nLin := _nLin + 5
	@ _nLin, 065 PSAY xNOME_CLI                 //Nome do Cliente
	@ _nLin, 191 PSAY xNUM_NF                   // Numero da Nota Fiscal
Endif

_nLin++
@ _nLin, 000 PSAY ""

//@ 72, 000 PSAY ""
//@ 76, 000 PSAY chr(18)                   // Descompressao de Impressao

SetPrc(0,0)                              // (Zera o Formulario)

Return .t.


//*************************
Static Function AjustaSX1()
//*************************

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

aAdd(aRegs,{cPerg,"01","Da Nota             ?","Da Nota             ?","Da Nota             ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"02","Ate a Nota          ?","Ate a Nota          ?","Ate a Nota          ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"03","Da Serie            ?","Da Serie            ?","Da Serie            ?","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"04","Tipo de Nota Fiscal ?","Tipo de Nota Fiscal ?","Tipo de Nota Fiscal ?","mv_ch4","N",01,0,0,"C","","mv_par04","Entrada","","","","","Saida","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"06","Transportadora      ?","Da Nota             ?","Da Nota             ?","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})

For i:=1 to Len(aRegs)
	//	If RecLock('SX1',Iif(!SX1->(DbSeek(cPerg+aRegs[i,2])),.t.,.f.))
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
		//	Else
		//		Help('',1,'REGNOIS')
	Endif
Next
dbSelectArea(_sAlias)

Return
