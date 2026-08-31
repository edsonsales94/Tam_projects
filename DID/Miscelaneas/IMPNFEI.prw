#include 'protheus.ch'
#include 'parmtype.ch'
#include "Fileio.ch"

#Define CRLF  CHR(13)+CHR(10)                    `

//_____________________________________________________________________________
/*/{Protheus.doc} IMPPEDMAB
//Rotina de importacao dos dados do Microsiga para integrar com sistema da Fenix;

//@author _____________________
//@revision Luiz Alberto
//@since 07 de Julho de 2014
//@version P11
/*/
//_____________________________________________________________________________
User Function IMPNFEI()
Private nOpc		:= 0
Private cCadastro	:= "Importação de dados."
Private aSay		:= {}
Private aButton		:= {}
Private cPerg		:= PADR("IMPNFEI",10)

aAdd( aSay, "Esta rotina irá importar os dados de NFE Importação" )

ValidPerg()

Pergunte(cPerg,.F.)

aButton  := { 	{ 1,.T.,{|| nOpc := 1, FechaBatch() }} ,;
				{ 2,.T.,{|| FechaBatch() } } }

FormBatch( cCadastro, aSay, aButton )

If !Pergunte(PADR(cPerg,10),.T. )
	Return(Nil)
Endif
	
				
If nOpc == 1
	If Empty( MV_PAR01 )
		MsgStop("Necessário informar o local do arquivo!","Atenção")
		Return(Nil)
	Endif
	
	If Empty( MV_PAR02 )
		MsgStop( "Obrigatório informar o local de estoque!", "Atenção")
		Return( Nil )
	Endif
	
	If MsgYesNo("Deseja prosseguir com esta operação?","Atenção")
		Processa( {|| Imp_NFEI() }, "Processando..." )
	Endif
Endif

Return(Nil)




//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Static Function ValidPerg()
Local aAreaX1	:= GetArea()

PutSx1( cPerg ,"01","Arquivo"			,"","","MV_CH1" ,"C",40,00,01,"G","U_CarAr1"	,""		,"","","MV_PAR01","","","","","","","","","","","","","","","","",{"Informe o caminho do Arquivo de Nota "},{},{})
PutSx1( cPerg ,"02","Armazém"   		,"","","MV_CH2" ,"C",02,00,01,"G",""		    ,"NNR"	,"","","MV_PAR02","","","","","","","","","","","","","","","","",{"Informe o Almoxarifado Padrao"},{},{})
PutSx1( cPerg ,"03","Cond.Pgto"     	,"","","MV_CH3" ,"C",03,00,01,"G",""			,"SE4"	,"","","MV_PAR03","","","","","","","","","","","","","","","","",{"Informe a Cond Pgto Padrao"},{},{})
PutSx1( cPerg ,"04","Transp.Padrão"		,"","","MV_CH4" ,"C",06,00,01,"G",""			,"SA4"	,"","","MV_PAR04","","","","","","","","","","","","","","","","",{"Informe a Transp Padrao"},{},{})
PutSx1( cPerg ,"05","Fornecedor"		,"","","MV_CH5" ,"C",06,00,01,"G",""			,"FOR"	,"","","MV_PAR05","","","","","","","","","","","","","","","","",{"Informe o Fornecedor"},{},{})
PutSx1( cPerg ,"06","Loja"				,"","","MV_CH6" ,"C",02,00,01,"G",""			,""		,"","","MV_PAR06","","","","","","","","","","","","","","","","",{"Informe a Loja"},{},{})
PutSx1( cPerg ,"07","Pedido"			,"","","MV_CH7" ,"C",06,00,01,"G",""			,"SC7"	,"","","MV_PAR07","","","","","","","","","","","","","","","","",{"Informe o Pedido"},{},{}) //Guilherme 14.01.26

RestArea( aAreaX1 )

Return




//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
User Function CarAr1()
if Empty( MV_PAR01 )
	MV_PAR01 := Padr(cFile:= cGetFile( "Arquivos de NF (*.txt) |*.txt","Informe o arquivo", 0, "C:\Temp\", .F., GETF_LOCALHARD + GETF_LOCALFLOPPY + GETF_NETWORKDRIVE),128)
Endif
Return(Nil)

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Static Function Imp_NFEI()
Local cLinha
Local aCab,aItens
Local cNomArq
Local nFor
Local cCodPro
Local dEmissao
Local cTesPro
Local lCodigo
Local nPed
Local aArNotaI := {}
Local aErro	:= {}	
Local cFornex := SuperGetMV("MV_XFORNEX", .F., "") // //Guilherme 14.01.26 - parâmetro contendo o código do(s) fornecedor(es), indicando se o frete compõe ou não o valor da mercadoria.

Private lMsErroAuto,l410Auto
Private cMemoObs

lCodigo	:= .T.//MV_PAR05 == 1
cNNR    := MV_PAR02
cSE4	:= MV_PAR03
cSA4	:= MV_PAR04
cFornece:= MV_PAR05
cLoja	:= MV_PAR06
cPedido := MV_PAR07 ////Guilherme 14.01.26
cNomArq  := AllTrim(MV_PAR01)



FT_FUSE(cNomArq)
FT_FGOTOP()
While !FT_FEOF()
	cLinha := FT_FREADLN()
	AADD(aArNotaI,cLinha)
	FT_FSKIP()
End
FT_FUSE()

aErro	:= {}
aCab    	:= {}
aItens		:= {}

ProcRegua(Len(aArNotaI))	
For nPed := 1 To Len(aArNotaI)	
	IncProc("Aguarde Processando Notas")

	// Definindo o Array MsExecAuto
	cLinha := aArNotaI[nPed]
		
	If Left(cLinha,1) == '1'		// Cabeçalho do Arquivo
		cItem			:=	'0000'		
		cCodigoEmp		:=	AllTrim(SubStr(cLinha,2,2))						// Codigo da Empresa
		cCodigoFil		:=	AllTrim(SubStr(cLinha,4,2))						// Codigo da Filial
		dEmissao		:=	dDataBase                        	            // Data da Emissao
		dEntrada		:=	dDataBase	                                    // Data da Digitação
		dRegDI			:=	StoD(AllTrim(SubStr(cLinha,80,8)))				// Data Registro DI
		cNumDI			:=	AllTrim(SubStr(cLinha,92,10))					// Numero da DI
		dDataDes		:=	StoD(AllTrim(SubStr(cLinha,327,8)))				// Data Desembaraco
		cLocaDes		:=	AllTrim(SubStr(cLinha,335,25))					// Local Desembaraco
		cInvoice        :=  AllTrim(SubStr(cLinha,388,10))                  // Nº da Invoice
		
	    // Localizando Pedido - Guilherme 14.01.26
        //C7_FILIAL, C7_FORNECE, C7_LOJA, C7_NUM		
		If Empty(cPedido)
			If !MsgYesNo("O campo Pedido está vazio. Deseja continuar mesmo assim?", "Atenção")
				Return .F. 
			Endif
		Else
			If !SC7->(dbSetOrder(3), dbSeek(xFilial("SC7")+cFornece+cLoja+cPedido))
				AADD(aErro, "-> Invoice [" + cInvoice + "] Pedido [" + cPedido + "] informado não pertence ao fornecedor indicado!")
			EndIf
		EndIf
		
		// Localizando Fornecedor

		If !SA2->(dbSetOrder(1), dbSeek(xFilial("SA2")+cFornece+cLoja))
			AADD(aErro,"-> Invoice [" + cInvoice + "] Fornecedor Não Localizado [CNPJ: " + cCNPJEmit + "]")
		Endif
		
		If Empty(SA2->A2_NATUREZ)
			AADD(aErro,"-> Invoice [" + cInvoice + "] Fornecedor Não Possui Natureza Cadastrada !")
		Endif
			
		// Localizando Cond Pagto

		If !SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+cSE4))
			AADD(aErro,"-> Invoice [" + cInvoice + "] Cond Pagto Não Localizada [" + cSE4 + "]")
		Endif

		If Len(aErro) > 0 
			Exit
		EndIf

		// Localizando DI

		aArea	:=	GetArea()
		
		_cQuery := " SELECT * "
		_cQuery += " FROM " + RetSqlName("SF1")+ " AS SF1 "
		_cQuery += " WHERE SF1.F1_FILIAL = '" + xFilial("SF1") + "' "
		_cQuery += "   AND SF1.F1_XDI = '" + cNumDI + "' "
		_cQuery += "   AND SF1.D_E_L_E_T_ = ' ' "
		_cQuery := ChangeQuery(_cQuery)
		DbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),'TRADI',.F.,.T.)

		If	TRADI->( ! Eof() )

			cF1Doc := TRADI->F1_DOC
			
			TRADI->(dbCloseArea())
			RestArea(aArea)
			
			AADD(aErro,"-> Nfe Já Importada [" + cF1Doc + "]  [DI: " + cNumDI + "]")
			Exit
		
		Endif              
		
		TRADI->(dbCloseArea()) 
		RestArea(aArea)
  
		// Inicia Montagem do Vetor do Cabeçalho da Nota Fiscal de Entrada

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dados do Cabecalho da Nota Fiscal de Entrada (Devolucao).    ³
		//  Selecione o Numero da Nota Fiscal para Formulario Proprio
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//Private cNumero:= Space(09)
		//Private cSerie := Space(03)  
		//cNumero  := NxtSX5Nota( cSerie, .T. ,cNumero)
		
		Private cNumero:= ""
		Private cSerie := ""
		
		lOk := Sx5NumNota(@cSerie,SuperGetMV("MV_TPNRNFS"))
		If !lOk
			RestArea(aArea)
			AADD(aErro,"-> Invoice [" + cInvoice + "] Erro Obtendo Numero NFE Interno")
			Exit
		Endif
  		
		cNFiscal 	:= cNumero
		cF1_SERIE	:= cSerie
		
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a Nota Fiscal / Serie ja existe no Arquivo.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While .T.
			dbSelectArea("SF1")
			dbSetOrder(1)
			If !dbSeek(xFilial() + cNFiscal + cF1_SERIE)
				Exit
			EndIf
	
			cNFiscal := Soma1(cNFiscal, TAMSX3("F1_DOC")[1])
		EndDo                       
		
		cF1_Doc := cNFiscal
		
		AAdd(aCab,{"F1_TIPO"	   	, 	'N'						       	,Nil,Nil})	
		AAdd(aCab,{"F1_FORMUL"	   	, 	'S'							    ,Nil,Nil})
		AAdd(aCab,{"F1_DOC"    		,	cNFiscal						,Nil,Nil})
		AAdd(aCab,{"F1_SERIE"  		,	cF1_Serie						,Nil,Nil})
		AAdd(aCab,{"F1_FORNECE"	   	,	SA2->A2_COD					    ,Nil,Nil})
		AAdd(aCab,{"F1_LOJA"	   	, 	SA2->A2_LOJA			       	,Nil,Nil})
		AAdd(aCab,{"F1_COND"	   	, 	cSE4			       			,Nil,Nil})
		AAdd(aCab,{"F1_EMISSAO"	   	, 	dEmissao					    ,Nil,Nil})
		AAdd(aCab,{"F1_EST"	   		, 	SA2->A2_EST				       	,Nil,Nil})
		AAdd(aCab,{"F1_DTDIGIT"	   	, 	dEntrada					    ,Nil,Nil})
		AAdd(aCab,{"F1_ESPECIE"	   	, 	'SPED'   					    ,Nil,Nil})
		AAdd(aCab,{"F1_MOEDA"	   	, 	1			       				,Nil,Nil})
		AAdd(aCab,{"F1_XDI"	 	  	, 	cNumDI		       				,Nil,Nil})
		AAdd(aCab,{"F1_XDTDI" 	  	, 	dRegDI		       				,Nil,Nil})
		AAdd(aCab,{"F1_XDTDES" 	  	, 	dDataDes	       				,Nil,Nil})
		AAdd(aCab,{"F1_XUFDES" 	  	, 	'SP'		       				,Nil,Nil})
		AAdd(aCab,{"F1_XLCDES" 	  	, 	cLocaDes	       				,Nil,Nil})  
		AAdd(aCab,{"F1_ESPECI1"	  	, 	'BAU METAL'	       				,Nil,Nil})
		AAdd(aCab,{"F1_TRANSP"	  	, 	cSA4		       				,Nil,Nil})
		                                                           
		
		
	ElseIf Left(cLinha,1) == '2' .And. Len(aCab) > 0 // Itens do Arquivo

		// Codigo do Produto
		cCodPro		:=	AllTrim(SubStr(cLinha,2,20))		

		// Validando Produto
		If !SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cCodPro)) .Or. Empty(cCodPro)
			AADD(aErro,"-> Nfe Importação [" + cNFiscal + "] Produto Não Localizado [" + cCodPro + "]")
			Loop
		Endif
        cTesPro := SB1->B1_TE
		
		// Posiciona no TES do produto		
		//cTesPro      := Posicione('SB1',1,xFilial('SB1')+cCodPro,'B1_TE')
        //cPrdPC       := Posicione('SB1',1,xFilial('SB1')+cCodPro,'B1_COD')
		// Validando TES
		
		/*If !SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+SB1->B1_TE))
			AADD(aErro,"-> Produto [" + SB1->B1_COD + "] sem TES de entrada cadastrada! " )
			Exit
		Endif*/

		If Empty(Alltrim(cTesPro))
			AADD(aErro,"-> Produto [" + cCodPro + "] sem TES de entrada cadastrada! " )
			Exit
		Endif
        
		// Posiciona no item do pedido de compra - Guilherme 14.01.26
		//Alert(xFilial('SC7')+cPrdPC+cFornece+cLoja+cPedido)
		//cItemPC      := Posicione('SC7',6,xFilial('SC7')+cPrdPC+cFornece+cLoja+cPedido,'C7_ITEM')
		  
		// Validando item do pedido
		If !SC7->(dbSetOrder(6), dbSeek(xFilial("SC7") + SB1->B1_COD + SA2->A2_COD + SA2->A2_LOJA + cPedido))
			AADD(aErro, "-> Produto [" + cCodPro + "] não localizado no pedido [" + cPedido + "]!")
			Exit
		EndIf


		// Ordem crescente por posição no cLinha		
		nQtdPro     := Val(AllTrim(SubStr(cLinha,22,11)))                                    // Quantidade Produto
		nValTot     := Val(AllTrim(SubStr(cLinha,49,14)))                                    // Valor Total 
		nValII      := Val(AllTrim(SubStr(cLinha,63,14)))                                    // Valor do II
		nSiscomex   := Val(AllTrim(SubStr(cLinha,77,14))) 
		nValAfrMM   := Val(AllTrim(SubStr(cLinha,91,14)))                                    // Valor AFRMM
		nBaseIPI    := Val(AllTrim(SubStr(cLinha,119,14))) 
		nBaseICM    := Val(AllTrim(SubStr(cLinha,133,14)))
		nAlqIcm     := Val(AllTrim(SubStr(cLinha,133,5)))                                    // Alíquota do ICMS 
		nAlqIpi     := Val(AllTrim(SubStr(cLinha,138,5)))                                    // Alíquota do IPI
		nValIcm     := Val(AllTrim(SubStr(cLinha,143,5)))
		nValIpi     := Val(AllTrim(SubStr(cLinha,157,5)))
		cAdicao     := StrZero(Val(AllTrim(SubStr(cLinha,209,04))), TAMSX3("D1_X_ADICA")[1]) // Adição
		cSqAdic     := StrZero(Val(AllTrim(SubStr(cLinha,213,04))), TAMSX3("D1_X_ITADC")[1]) // Sequência da Adição
		nCifTot     := Val(AllTrim(SubStr(cLinha,231,14)))
		nValfre     := Val(AllTrim(SubStr(cLinha,245,14)))                                   // Valor do frete
		nValSeg     := Val(AllTrim(SubStr(cLinha,259,14)))                                   // Valor Seguro                           
		
		cItem := Soma1(cItem,4)

		aTemp	:= {}  
		AAdd(aTemp, {"D1_COD"     , SB1->B1_COD                  , NIL})
		AAdd(aTemp, {"D1_FORNECE" , SA2->A2_COD                  , NIL})
		AAdd(aTemp, {"D1_LOJA"    , SA2->A2_LOJA                 , NIL})

		If !Empty(cPedido)
			AAdd(aTemp, {"D1_PEDIDO", SC7->C7_NUM                 , NIL}) // Guilherme 14.01.26
			AAdd(aTemp, {"D1_ITEMPC", SC7->C7_ITEM                , NIL}) // Guilherme 14.01.26
		EndIf

		AAdd(aTemp, {"D1_DOC"     , cNFiscal                     , NIL})
		AAdd(aTemp, {"D1_SERIE"   , cF1_Serie                    , NIL})
		AAdd(aTemp, {"D1_ITEM"    , cItem                        , NIL})
		AAdd(aTemp, {"D1_UM"      , SB1->B1_UM                   , NIL})
		AAdd(aTemp, {"D1_QUANT"   , nQtdPro                      , NIL})

		// Guilherme 14.01.26 - Início
		If AllTrim(cFornece) $ cFornex
			AAdd(aTemp, {"D1_VUNIT" , Round(nCifTot / nQtdPro, 8) , NIL})
			AAdd(aTemp, {"D1_TOTAL" , nCifTot                     , NIL})
			AAdd(aTemp, {"D1_VALFRE", nValfre                     , NIL})
			AAdd(aTemp, {"D1_SEGURO", 0                            , NIL})
		Else
			AAdd(aTemp, {"D1_VUNIT" , Round(nCifTot / nQtdPro, 8) , NIL})
			AAdd(aTemp, {"D1_TOTAL" , nCifTot                     , NIL})
			AAdd(aTemp, {"D1_VALFRE", 0                            , NIL})
			AAdd(aTemp, {"D1_SEGURO", 0                            , NIL})
		EndIf
		// Guilherme 14.01.26 - Fim

		AAdd(aTemp, {"D1_TES"     , SB1->B1_TE                   , NIL})
		AAdd(aTemp, {"D1_LOCAL"   , cNNR                         , NIL})
		AAdd(aTemp, {"D1_EMISSAO" , dEmissao                     , NIL})
		AAdd(aTemp, {"D1_DTDIGIT" , dEntrada                     , NIL})
		AAdd(aTemp, {"D1_BASEICM" , nBaseICM                     , NIL})
		AAdd(aTemp, {"D1_PICM"    , nAlqIcm                      , NIL})
		AAdd(aTemp, {"D1_VALICM"  , nValIcm                      , NIL})
		AAdd(aTemp, {"D1_BASEIPI" , nBaseIPI                     , NIL})
		AAdd(aTemp, {"D1_IPI"     , nAlqIpi                      , NIL})
		AAdd(aTemp, {"D1_VALIPI"  , nValIpi                      , NIL})
		AAdd(aTemp, {"D1_II"      , nValII                       , NIL})
		AAdd(aTemp, {"D1_AFRMIMP" , nValAfrMM                    , NIL})
		AAdd(aTemp, {"D1_DESPESA" , nValAfrMM + nSiscomex        , NIL})
		AAdd(aTemp, {"D1_FORMUL"  , "S"                          , NIL})
		AAdd(aTemp, {"D1_RATEIO"  , "2"                          , NIL})
		AAdd(aTemp, {"D1_X_ADICA" , cAdicao                      , NIL})
		AAdd(aTemp, {"D1_X_ITADC" , cSqAdic                      , NIL})

		AAdd(aItens, aTemp)


	Endif		
Next

If Len(aErro) > 0
	cAviso := ""
	For nFor := 1 to Len(aErro)
		cAviso += aErro[nFor] + CRLF
	Next nFor
	Aviso("Atenção",cAviso,{"Ok"},3,"OCORREU ERRO NA OPERAÇÃO :")
Else
             
	// Se Preencheu os Dois Vetores Então Irá Incluir a Nota fiscal de Entrada
	
	If !Empty(Len(aCab)) .And. !Empty(Len(aItens))
		Begin Transaction
		
		aArea := GetArea()
		
		lMSErroAuto := .f.

		MSExecAuto({|x,y,z|MATA140(x,y,z)},aCab,aItens,3)  // gera pré-nota 		
		
		If lMSErroAuto
			MostraErro()
		Else
			while __lsx8
				
				confirmsx8()
			
			enddo
				
		EndIf		

		RestArea(aArea)
	    End Transaction

		If !lMsErroAuto	// Sucesso na Inclusao da Nota
			MsgInfo("Nota(s) Fiscal(is) Importada(s) Com Sucesso !")
		Else                                                
			MsgStop("Atencao Erro na Importacao da Nota - Verifique !!!")
		Endif	    
	Endif
Endif   

CursorArrow()

Return(Nil)
