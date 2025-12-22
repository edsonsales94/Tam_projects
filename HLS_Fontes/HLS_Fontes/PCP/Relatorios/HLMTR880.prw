#Include "Protheus.ch"
#Include "RwMake.ch"

#Define PAD_LEFT	0
#Define PAD_RIGHT	1
#Define PAD_CENTER	2

/*/{Protheus.doc} HLMTR880

Relatório de necessidade.

@type function
@author Honda Lock
@since 01/10/2017

/*/

***********************************************************************************************************************************************************************************************
// Funcao Principal e que faz as chamadas das outras funcoes.
// Para rodar este relatorio, se faz necessario rodar primeiro a rotina de MRP (Protheus\Planej.Contr.Producao\Atualizacaoes\Processamento\MRP).
***********************************************************************************************************************************************************************************************
User Function HLMTR880()
	Local cAlias1		:= "SHA"
	Local cAlias2		:= "SH5"
	Local cPerg			:= "MTA712"

	Private nLastKey	:= 0
	Private nLin   		:= 9000
	Private aColImp		:= {}
	
	AbreArq(@cAlias1)
	
	If Select(cAlias1) > 0
		AbreArq(@cAlias2)
	
		If Select(cAlias2) > 0
			Pergunte(cPerg, .F.)
			Processa( {|| CursorWait(), RunProc(cAlias1, cAlias2), CursorArrow()}, "Aguarde...", "Executando rotina.", .T. ) 
	
			(cAlias2)->(DbCloseArea())	
		EndIf
		
		(cAlias1)->(DbCloseArea())
	EndIf
Return

***********************************************************************************************************************************************************************************************
// Funcao responsavel por processar as informcoes e depois proceder com a impressao dos dados.
***********************************************************************************************************************************************************************************************
Static Function RunProc(cAlias1, cAlias2)
	Local oPrint	   	:= TMSPrinter():New(FunDesc())
	Local cTexto		:= ""
	Local cProduto		:= ""
	Local nPag			:= 0
	Local nI			:= 0
	Local nAndam		:= 0
	Local nPerdas		:= 0
	Local nSaiPrev		:= 0
	Local nNeces		:= 0
	Local nTotReg		:= 0
	Local aDetRel		:= {}			// Produto, Andamento, Perdas, Saidas Previstas, Necessidades

	Private nLimiteHoz	:= 0
	Private nLimiteVer	:= 0
	Private aColImp		:= {}
	Private oFont08 	:= TFont():New("Arial", 08, 08,, .F.,,,,, .F., .F.)
	Private oFont08N 	:= TFont():New("Arial", 08, 08,, .T.,,,,, .F., .F.)
	Private oFont10 	:= TFont():New("Arial", 10, 10,, .F.,,,,, .F., .F.)
	Private oFont10N 	:= TFont():New("Arial", 10, 10,, .T.,,,,, .F., .F.)
	Private oFont14N 	:= TFont():New("Arial", 14, 14,, .T.,,,,, .F., .F.)
	Private oFont14NI 	:= TFont():New("Arial", 14, 14,, .T.,,,,, .F., .T.)
	Private oBrush		:= TBrush():New(, 4)

	oPrint:SetPortrait()
	oPrint:Setup()

	nLimiteHoz	:= Mm2Pix(oPrint, oPrint:nHorzSize()) - 0070
	nLimiteVer	:= Mm2Pix(oPrint, oPrint:nVertSize()) - 0030

	aAdd(aColImp, 30)
	nVlr := (nLimiteHoz - 30) / 7			// Divide pelo numero de Colunas Reais mais as Imaginarias
	For nI := 1 To 6						// Divide pelo numero de Colunas Reais.
		If StrZero(nI, 2) $ "01"
			aAdd(aColImp, aColImp[Len(aColImp)] + (nVlr * 2))
		Else
			aAdd(aColImp, aColImp[Len(aColImp)] + nVlr)
		EndIf
	Next nI

	ProcRegua((cAlias1)->(RecCount()))
	cProduto := (cAlias1)->HA_PRODUTO
	Do While (cAlias1)->(!Eof())
		IncProc("Carregando Informações...")
		
		// Trocou o produto, entao deve gravar os dados calculados
		If cProduto != (cAlias1)->HA_PRODUTO
           	nNeces		:= IIf(nSaiPrev - nAndam > 0, nSaiPrev - nAndam, 0)
			If nNeces > 0
				aAdd(aDetRel, {cProduto, nAndam, nPerdas, nSaiPrev, nNeces})
			EndIf
			cProduto	:= (cAlias1)->HA_PRODUTO
		EndIf

		If (cAlias1)->HA_TIPO == "1"
			nAndam		:= (cAlias1)->HA_PER001
			nPerdas		:= CalcPerdas(cAlias1, cAlias2)
			nSaiPrev	:= 0
		ElseIf (cAlias1)->HA_TIPO $ "34"
			nSaiPrev	+= (cAlias1)->HA_PER001
		EndIf

		(cAlias1)->(DbSkip())
    EndDo

	// Agora faz a impressao do relatorio.
	nTotReg	:= Len(aDetRel)
	ProcRegua(nTotReg)
	For nI := 1 To nTotReg
		IncProc("Imprimindo os dados apurados...")

		If nLin >= nLimiteVer - 100
			oPrint:EndPage()				// Encerra a pagina atual.
			ImpCab(oPrint, @nPag)			// Chama o cabecalho.
		EndIf

		oPrint:Say(nLin, aColImp[01] + 0010, aDetRel[nI, 01]														, oFont10)
		oPrint:Say(nLin, aColImp[03] - 0010, Transform(aDetRel[nI, 02],	"@E 9,999,999,999")							, oFont10,,,, PAD_RIGHT)
		oPrint:Say(nLin, aColImp[04] - 0010, Transform(aDetRel[nI, 03],	"@E 9,999,999,999")							, oFont10,,,, PAD_RIGHT)
		oPrint:Say(nLin, aColImp[05] - 0010, Transform(aDetRel[nI, 04],	"@E 9,999,999,999")							, oFont10,,,, PAD_RIGHT)
		oPrint:Say(nLin, aColImp[06] - 0010, Transform(aDetRel[nI, 05],	"@E 9,999,999,999")							, oFont10,,,, PAD_RIGHT)
	    nLin += 50
		oPrint:Line(nLin, aColImp[01], nLin, nLimiteHoz)
	    nLin += 10
	Next nI

	cTitulo := "Relatorio "      
	Define MsDialog oDlg Title "Plano de Entrega dos Componentes na Linha" From 0, 0 To 250, 420 Pixel
	Define Font oBold Name "Arial" Size 0, -13 Bold
	@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDlg Size 30, 120 NoBorder When .f. Pixel
	@ 003, 040 Say cTitulo Font oBold Pixel
	@ 014, 030 To 016, 400 Label '' Of oDlg  Pixel
	@ 020, 040 Button "Configurar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Setup()
	@ 020, 082 Button "Imprimir"   	Size 40, 13 Pixel Of oDlg Action oPrint:Print()
	@ 020, 124 Button "Visualizar" 	Size 40, 13 Pixel Of oDlg Action (oPrint:Preview(), oDlg:End())
	@ 020, 166 Button "Sair"       	Size 40, 13 Pixel Of oDlg Action oDlg:End()
	Activate MsDialog oDlg Centered

	Ms_Flush()
Return

***********************************************************************************************************************************************************************************************
&& Funcao responsavel pela impressao do cabeçalho
***********************************************************************************************************************************************************************************************
Static Function ImpCab(oPrint, nPag)
	Local cTexto := ""

	If nPag != 1
		oPrint:EndPage()
	EndIf
	
	oPrint:StartPage()
	nPag ++
	nLin := 050
	cTexto	:= "PLANO DE ENTREGA DOS COMPONENTES NA LINHA"
	oPrint:Say(nLin, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2, cTexto							, oFont14N,,,, PAD_CENTER)

	nLin += 070
	cTexto	:= AllTrim(SM0->M0_NOME)
	oPrint:Say(nLin, 0030, cTexto															, oFont14NI)
	cTexto := "Relatório: " + FunName()
	oPrint:Say(nLin, nLimiteHoz, cTexto					 									, oFont10N,,,, PAD_RIGHT)

	nLin += 070
	If MV_PAR08 == MV_PAR09
		cTexto	:= "Armazém: " + MV_PAR08
	Else
		cTexto	:= "Armazém de: " + MV_PAR08 + " até " + MV_PAR09
	EndIf
	oPrint:Say(nLin, aColImp[01], cTexto  			 										, oFont10N)
	cTexto	:= "Página: " + StrZero(nPag, 4)
	oPrint:Say(nLin, nLimiteHoz, cTexto					 									, oFont10N,,,, PAD_RIGHT)

	nLin += 070
	cTexto	:= StrZero(Day(dDataBase), 2) + "/" + StrZero(Month(dDataBase), 2) + "/" + cValToChar(Year(dDataBase))
	oPrint:Say(nLin, aColImp[04] + (aColImp[07] - aColImp[04]) / 2, cTexto					, oFont14N,,,, PAD_CENTER)
	nLin += 050
    // Desenha o quadro
	oPrint:Box(nLin, aColImp[04], nLin + (0060 * 3), aColImp[07])
	oPrint:Line(nLin + 60, aColImp[04], nLin + 60, aColImp[07])
	oPrint:Line(nLin, aColImp[04] + (aColImp[07] - aColImp[04]) / 2, nLin + (0060 * 3), aColImp[04] + (aColImp[07] - aColImp[04]) / 2)

	nLin += 020 + (0060 * 3)

    // Desenha o quadro
	oPrint:Box(nLin, aColImp[01], nLin + 0060, nLimiteHoz)

	// Desenha as linhas verticais de dentro do quadro
	oPrint:Line(nLin, aColImp[02], nLin + 0060, aColImp[02])
	oPrint:Line(nLin, aColImp[03], nLin + 0060, aColImp[03])
	oPrint:Line(nLin, aColImp[04], nLin + 0060, aColImp[04])
	oPrint:Line(nLin, aColImp[05], nLin + 0060, aColImp[05])
	oPrint:Line(nLin, aColImp[06], nLin + 0060, aColImp[06])

	nLin += 20                    
	oPrint:Say(nLin, aColImp[01] + 0010, "CÓDIGO DO PRODUTO"	  							, oFont10N)
	oPrint:Say(nLin, aColImp[03] - 0010, "ANDAMENTO"										, oFont10N,,,, PAD_RIGHT)
	oPrint:Say(nLin, aColImp[04] - 0010, "PERDAS"											, oFont10N,,,, PAD_RIGHT)
	oPrint:Say(nLin, aColImp[05] - 0010, "SAÍDA PREVISTA"									, oFont10N,,,, PAD_RIGHT)
	oPrint:Say(nLin, aColImp[06] - 0010, "NECESSIDADE"										, oFont10N,,,, PAD_RIGHT)
	oPrint:Say(nLin, aColImp[07] - 0010, "MOVIMENTO REAL"									, oFont10N,,,, PAD_RIGHT)

	nLin += 50
Return

***********************************************************************************************************************************************************************************************
// Funcao responsavel por transformar Milimetros em Polegadas a serem utilizadas na classe TMSPrinter.
// Devido a um problema da classe, nao estamos mais usando o metodo nLogPixelX() e sim sempre considerando o valor de 300 ppp.
***********************************************************************************************************************************************************************************************
Static Function Mm2Pix(oPrint, nMm)
//	Local nValor := (nMm * oPrint:nLogPixelX()) / 25.4
	Local nValor := (nMm * 300) / 25.4
Return nValor

***********************************************************************************************************************************************************************************************
// Funcao responsavel por posicionar o arquivo SH5 e depois no SBC para calcular as perdas por OP.
***********************************************************************************************************************************************************************************************
Static Function CalcPerdas(cAlias1, cAlias2)
    Local nRet	:= 0
    
	// Primeiro posiciona no arquivo SH5 e fica nele enquanto o produto e o mesmo.
	If (cAlias2)->(DbSeek((cAlias1)->HA_PRODUTO))
		DbSelectArea("SBC")
		SBC->(DbSetOrder(1))
		Do While (cAlias2)->(!Eof())
			If (cAlias2)->H5_PRODUTO != (cAlias1)->HA_PRODUTO
				Exit
		    ElseIf (cAlias2)->H5_REVISAO != (cAlias1)->HA_REVISAO .Or. (cAlias2)->H5_TIPO != "2"
				(cAlias2)->(DbSkip())
				Loop
		    EndIf
		    
		    If SBC->(DbSeek(xFilial("SBC") + (cAlias2)->H5_DOC))
		        Do While SBC->(!Eof()) .And. SBC->BC_FILIAL == xFilial("SBC") .And. SBC->BC_OP == (cAlias2)->H5_DOC
		    		nRet += SBC->BC_QUANT
		    		
		    		SBC->(DbSkip())
		    	EndDo
			EndIf
			
			(cAlias2)->(DbSkip())
		EndDo
	EndIf
Return(nRet)

***********************************************************************************************************************************************************************************************
// Funcao responsavel por abrir os arquivos do tipo cTreeque ficam na pasta \Data.
***********************************************************************************************************************************************************************************************
Static Function AbreArq(cAlias)
	DbUseArea(.T., "CTREECDX", "\DATA\" + cAlias + cEmpAnt + "0.DTC", cAlias, .T., .F.)
	DbSelectArea(cAlias)
	(cAlias)->(DbSetOrder(1))
	(cAlias)->(DbGoTop())
Return
