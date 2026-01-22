#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
+-------------------------------------------------------------------------------------+
| Programa  | RMULT001    | Desenvolvedor  | Claudio França  | Data  |   01/01/2025   |
+-----------+------------+----------------+-------------------+-------+---------------+
| Descricao | Relatório de Pedido de Compras    									  |
+-----------+-------------------------------------------------------------------------+
| Modulos   | Compras    	                                                          |
+-----------+-------------------------------------------------------------------------+
| Processos | Pedido de Compras                                                       |
+-----------+-------------------------------------------------------------------------+
|                  Modificacoes desde a construcao inicial                            |
+----------+-------------+------------------------------------------------------------+
| DATA     | PROGRAMADOR | MOTIVO                                                     |
+----------+-------------+------------------------------------------------------------+
|01/01/2025|Claudio      |Incluído IPI,Seguro,Despesa e Frete no Valor Total do Pedido|
|          |             |Aleterado nº de Página para formato "1/3".."2/3".."3/3"     |
+----------+-------------+------------------------------------------------------------+
|01/01/2025|Claudio      |Pedido de compra agora sempre mostra os dados no cabeçalho do|
|          |             |Aleterado nº de Página para formato "1/3".."2/3".."3/3"     |
+----------+-------------+------------------------------------------------------------+
*/

User Function RMULT001()

	Set Century On

	***************************************
	** VARIAVEIS UTILIZADAS NO RELATORIO **
	***************************************
	Local nX := 0
	Private lAdjustToLegacy := .T.
	Private lDisableSetup   := .T.
	//Private cDirSpool	  	:= GetMv("MV_RELT")
	Private cDirSpool	  	:= "\spool\"
	//Private cDirSpool := GetSrvProfString("ROOTPATH","") + "\spool\"
	//Private cPerg			:= "RMULT001"

	*******************************************
	** OBJETOS PARA TAMANHO E TIPO DE FONTES **
	*******************************************
	Private oFont02	 := TFont():New("Arial",02,02,,.F.,,,,.T.,.F.)
	Private oFont06	 := TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
	Private oFont06n := TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
	Private oFont08C := TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
	Private oFont08CN := TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)
	Private oFont07	 := TFont():New("Courier New",07,07,,.F.,,,,.T.,.F.)
	Private oFont07n := TFont():New("Courier New",07,07,,.T.,,,,.T.,.F.)
	Private oFont07A  := TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
	Private oFont08	 := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
	Private oFont08n := TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
	Private oFont09	 := TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	Private oFont09n := TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)
	Private oFont10	 := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
	Private oFont10n := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
	Private oFont11	 := TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
	Private oFont11n := TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)
	Private oFont12	 := TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
	Private oFont12n := TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
	Private oFont13	 := TFont():New("Arial",13,13,,.F.,,,,.T.,.F.)
	Private oFont13n := TFont():New("Arial",13,13,,.T.,,,,.T.,.F.)
	Private oFont14	 := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
	Private oFont14n := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
	Private oFont16n := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
	Private oFont18n := TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)
	Private oFont22n := TFont():New("Arial",22,22,,.T.,,,,.T.,.F.)
	Private oFont34n := TFont():New("Arial",34,34,,.T.,,,,.T.,.F.)

	Private oBrush1 := TBrush():New( , CLR_GRAY)
	Private oBrush2 := TBrush():New( , CLR_WHITE)

	*********************************************
	** VARIÁVEIS INICIALIZADAS COMO CONTADORES **
	*********************************************
	Private nLin	  := 100
	Private nMaxLin   := 2340
	Private nPagina   := 1 // Controla mostrador de paginas
	Private nTLinhas  := 2985
	Private nCol	  := 50

	****************************************
	** VARIÁVEIS DO CONTEÚDO DO RELATÓRIO **
	****************************************
	Private cTitulo := "PEDIDO DE COMPRA"
	Private oRel
	Private cPedido := ""
	Private cFilPed := ""

	****************************************
	** VARIÁVEIS DO CONTEÚDO DO EMAIL **
	****************************************
	Private cEmailF // E-mail do fornecedor
	Private cNumPed // Número da cotação
	Private cCamAnexo //Caminho do arquivo em anexo
	private cFilEnv
	Private cNomeF
	Private _cNome := ""
	Private _cCGC  := ""
	Private cEmp  := "01"
	Private cFil  := ""
	Private aFil  := {'0101','0102','0103','0201','0301'}

	************************************
	** MONTA A RÉGUA DE PROCESSAMENTO **
	************************************
	// if !IsBlind()
	// 	procImpr()
	// Else
	// 	RPCSetEnv(cEmpAnt, cFilAnt,,,'COM')
	// 	procImpr()
	// EndIf
	if .F.//!IsBlind()
		procImpr()
	else
		for nX := 1 to Len(aFil)
			RPCSetType(3)
			cFil := aFil[nX]
			RPCSetEnv(cEmp,cFil,,,'COM')
			procImpr()
			RpcClearEnv()
		next nX
	endif
Return

Static function procImpr()

	If ExistDir(cDirSpool) .Or. MakeDir(cDirSpool) <> 0
		fBuscaDoc()
		DbSelectArea("TMP")
		TMP->(DbGoTop())
		If TMP->(!Eof())
			While 	TMP->( ! Eof() )
				cPedido := AllTrim(TMP->C7_NUM)
				cFilPed := AllTrim(TMP->C7_FILIAL)
				cFilEnv := AllTrim(TMP->C7_FILENT)
				cNomeF  := AllTrim(TMP->A2_NREDUZ)
				If !IsBlind()
					Processa({|| fImpRel(),'Gerando...'},'Processando Relatório...')
				else
					fImpRel()
				endif
				TMP->(DbSkip())
				nPagina := 1 //Quando avançar para o próximo pedido volta o contator de pagina para 1
			EndDo
		Else
			Msginfo("Não foi encontrado documentos com os dados informados")
		EndIf
	Else
		MsgAlert("O diretório " + Alltrim(cDirSpool) + " não foi encontrado, contacte o departamento de TI!")
	EndIf
return

Static Function fImpRel()
	**************************************
	** FUNÇÃO DE IMPRESSÃO DO RELATÓRIO **
	**************************************
	Local aAreaOrc := GetArea()
	Local MVPAR14 := 2

	If !IsBlind()
		ProcRegua(8)
		IncProc("Preparando a impressão...")
		//cDirSpool := 'c:\ped_compras\'
		//cDirSpool := 'c:\temp\'

//Verifica se existe o diretório, caso não existe irá tentar criar, caso negativo irá informar o usuário do problema

		If !ExistDir(cDirSpool)
			If MakeDir(cDirSpool) <> 0
				MsgAlert("O diretório " + Alltrim(::cDiretorio) + " não foi encontrado, contacte o departamento de TI!")
				Return Self
			EndIf
		EndIf
	Endif

	FErase( ALLTRIM(cDirSpool+"pc_"+cPedido+"_"+cFilPed+".pdf" ))

	oRel := FWMSPrinter():New("pc_"+cPedido+"_"+cFilPed,IMP_PDF,lAdjustToLegacy,cDirSpool,lDisableSetup) //TMSPrinter():New( "Boleto Laser" )//

	oRel:SetLandscape()
	oRel:SetPaperSize(9)
	oRel:cPathPDF := cDirSpool
	oRel:lInJob   := .T.
	oRel:lViewPDF := .F. // Exibe PDV apos criacao

	If !IsBlind()
		IncProc("Imprimindo: Selecionando os dados")
	endif
/*
	IF (Empty(MV_PAR06))
		Alert("A pergunta (Loja Ate:) do Fornecedor não foi preenchida. O Relatório não será impresso corretamente")
	EndIf

	IF (Empty(MV_PAR08))
		Alert("A pergunta (Filial Ate:) não foi preenchida. O Relatório não será impresso corretamente")
	EndIf
*/
	fImpCabec()

	fImpItem()

	//oRel:Setup()   //Exibe tela de configuração da impressão
	//oRel:Preview()
	oRel:Print()

	FreeObj(oRel)
	//Copia para anexar no e-mail
	//IF MV_PAR14 == 2
	IF MVPAR14 == 2
		lPreview := .T.
		cCamiUsu := cDirSpool
		cPdf	:= "pc_"+cPedido+"_"+cFilPed
		//cCamiSer := "\pc\"
		cCamiSer := cDirSpool
		cCamAnexo := AllTrim(cCamiSer + cPdf + ".pdf" )
		//CpyT2S( AllTrim(cCamiUsu + cPdf + ".pdf" ), cCamiSer )
		U_ENVPEDE()
	ENDIF

	RestArea(aAreaOrc)

Return

Static Function fImpCabec()
/*****************************************
** Cabeçalho do Relatório
**
****************************/
Local xLogoAcol	:= GetSrvProfString('Startpath','') + 'lgrl010101.bmp'
//Local cFilEnt   := Iif(!Empty(MV_PAR09),Alltrim(MV_PAR09),Alltrim(cFilPed))
Local aArea := GetArea()
Local oFontDad    := oFont10

If !IsBlind()
IncProc("Imprimindo: Cabeçalho")
endif

oRel:EndPage()   // Finaliza Página
oRel:StartPage()   // Inicia uma nova página

nLin := 100

oRel:Box(nLin,nCol,nLin+200,nCol+500)
oRel:SayBitmap( nLin+10,nCol+10,xLogoAcol,450,180)

oRel:FillRect ( {nLin,nCol+510,nLin+200,nTLinhas}, oBrush1, "-2" )
oRel:Say(nLin+125,nCol+788,"PEDIDO DE COMPRA - Nº "+AllTrim(TMP->C7_NUM) ,oFont34n,,CLR_WHITE)
cNumPed := AllTrim(TMP->C7_NUM)
nLin += 210

oRel:Box(nLin,nCol,nLin+045,nCol+1900)
oRel:Say(nLin+40,nCol+10,"Emissão: " ,oFont14n,,CLR_GRAY)
//oRel:Say(nLin+40,nCol+165, AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_CIDENT"))+', '+Day2Str(dDataBase)+' de '+ MesExtenso(dDataBase)+ ' de ' +Year2Str(dDataBase),oFont14n)
oRel:Say(nLin+40,nCol+165, AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_CIDENT"))+', '+Day2Str(SC7->C7_EMISSAO)+' de '+ MesExtenso(SC7->C7_EMISSAO)+ ' de ' +Year2Str(SC7->C7_EMISSAO),oFont14n)
oRel:Box(nLin,nCol+1910,nLin+045,nTLinhas)
oRel:Say(nLin+40,nCol+1930,"Página:" ,oFont14n,,CLR_GRAY)
oRel:Say(nLin+40,nCol+2060, /*Alltrim(STR(nPagina))*/Alltrim(STR(oRel:nPageCount)),oFont14n)
nPagina++

nLin += 050

oRel:FillRect ( {nLin,nCol,nLin+80,nTLinhas}, oBrush1, "-2" )
oRel:Say(nLin+60,nCol+1150,"DADOS FORNECEDOR" ,oFont22n,,CLR_WHITE)

nLin += 90

DbSelectArea('SA2')
SA2->(DbSetOrder(1))
If	! SA2->(DbSeek(xFilial('SA2')+TMP->(C7_FORNECE+C7_LOJA)))
    If !IsBlind()
	Help('',1,'REGNOIS')
	Endif
	Return .f.
EndIf
//(1ºP, 1ºP)|(2ºP    ,2ºP      )
oRel:Box(nLin,nCol,nLin+090,nCol+1500)
oRel:Say(nLin+40,nCol+10,"Nome/Razão Social:" ,oFont10n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+10, UPPER(AllTrim(SA2->A2_NOME)),oFontDad)
cNomeF := AllTrim(SA2->A2_NOME)

cMask := Iif(AllTrim(SA2->A2_TIPO) == "F","@R 999.999.999-99","@R 99.999.999/9999-99")

oRel:Box(nLin,nCol+1500,nLin+090,nTLinhas+2)
oRel:Say(nLin+40,nCol+1510,"CPF/CNPJ:" ,oFont10n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+1510, AllTrim(Transform(SA2->A2_CGC,cMask)),oFontDad)

oRel:Box(nLin,nCol+2000,nLin+090,nTLinhas+2)
oRel:Say(nLin+40,nCol+2010,"Contato:" ,oFont10n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+2010, AllTrim(TMP->C7_CONTATO),oFontDad)

oRel:Box(nLin,nCol+2485,nLin+090,nTLinhas+2)
oRel:Say(nLin+40,nCol+2495,"Telefone:" ,oFont10n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+2495, "("+AllTrim(SA2->A2_DDD)+")"+AllTrim(SA2->A2_TEL),oFontDad)

oRel:Box(nLin+90,nCol,nLin+180,nTLinhas+2)
oRel:Say(nLin+130,nCol+10,"Endereço:" ,oFont10n,,CLR_GRAY)
oRel:Say(nLin+170,nCol+10, AllTrim(SA2->A2_END)+" - "+AllTrim(SA2->A2_BAIRRO)+" - CEP: "+AllTrim(Transform(SA2->A2_CEP,"@R 99.999-999"))+" - "+AllTrim(SA2->A2_MUN)+" - "+AllTrim(SA2->A2_EST),oFontDad)

oRel:Box(nLin+90,nCol+1500,nLin+180,nTLinhas+2)
oRel:Say(nLin+130,nCol+1510,"Email:" ,oFont10n,,CLR_GRAY)
oRel:Say(nLin+170,nCol+1510, UPPER(AllTrim(SA2->A2_EMAIL)),oFontDad)
cEmailF := AllTrim(SA2->A2_EMAIL)
// cEmailF := "edson.sales94@outlook.com"
//cEmailF := "claudio.sampaio@grupoednave.com.br;junior@grupoednave.com.br;vanessa.alecrim@grupoednave.com.br;ivaneide.almeida@grupoednave.com.br;fatima.leonel@grupoednave.com.br;larissa.alecrim@grupoednave.com.br;ednave@grupoednave.com.br"

nLin := nLin - 95

oRel:FillRect ( {nLin+280,nCol,nLin+360,nTLinhas}, oBrush1, "-2" )
oRel:Say(nLin+340,nCol+1150,"DADOS FATURAMENTO" ,oFont22n,,CLR_WHITE)

nLin := nLin+280+90

oRel:Box(nLin,nCol,nLin+090,nTLinhas+2)
oRel:Say(nLin+40,nCol+10,"Nome/Razão Social:" ,oFont10n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+10, AllTrim(Upper(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_NOMECOM"))),oFontDad,,CLR_BLACK)

oRel:Box(nLin,nCol+1050,nLin+090,nTLinhas+2)
oRel:Say(nLin+40,nCol+1060,"CNPJ:" ,oFont10n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+1060, TransForm(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_CGC"),'@R 99.999.999/9999-99'),oFontDad,,CLR_BLACK)

oRel:Box(nLin,nCol+1500,nLin+090,nTLinhas+2)
oRel:Say(nLin+40,nCol+1510,"I.E:" ,oFont10n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+1510, Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_INSC"),oFontDad,,CLR_BLACK)

oRel:Box(nLin,nCol+1900,nLin+090,nTLinhas+2)
oRel:Say(nLin+40,nCol+1910,"Comprador (E-mail):" ,oFont10n,,CLR_GRAY)
oRel:Say(nLin+80,nCol+1910, SubStr(Capital(Alltrim(UsrFullName(TMP->C7_USER))),1,16)+" ("+Alltrim(UsrRetMail(TMP->C7_USER))+")",oFontDad,,CLR_BLACK)

oRel:Box(nLin+90,nCol,nLin+180,nTLinhas+2)
oRel:Say(nLin+130,nCol+10,"Endereço:" ,oFont10n,,CLR_GRAY)
oRel:Say(nLin+170,nCol+10, Upper(AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_ENDENT")))+" - "+ Upper(AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_COMPENT")))+" "+Upper(AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_BAIRENT")))+ ' CEP: ' + AllTrim(TransForm(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_CEPENT"),'@R 99.999-999'))+" - "+Upper(AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_CIDENT")))+' / '+AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_ESTENT"))+ '   TEL: ' + AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_TEL")),oFontDad,,CLR_BLACK)

oRel:Box(nLin+90,nCol+1500,nLin+180,nTLinhas+2)
oRel:Say(nLin+130,nCol+1510,"Endereço de Entrega:" ,oFont10n,,CLR_GRAY)
oRel:Say(nLin+170,nCol+1510, Upper(AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_ENDENT")))+" - "+ Upper(AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_COMPENT")))+" "+Upper(AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_BAIRENT")))+ ' CEP: ' + AllTrim(TransForm(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_CEPENT"),'@R 99.999-999'))+" - "+Upper(AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_CIDENT")))+' / '+AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_ESTENT"))+ '   TEL: ' + AllTrim(Posicione("SM0",1,cEmpAnt+Alltrim(cFilEnv),"M0_TEL")),oFontDad,,CLR_BLACK)

nLin := nLin + 200

RestArea(aArea) // Garante a volta do posionamento a filial setada antes do incio desta funcao.
Return Nil

Static Function fImpItem()
/*************************************************
Itens do relatório
**************************************************/
Local nPosItem 	  := nCol+10
Local nPosCodP 	  := nCol+130-25-15
Local nPosDesc 	  := nCol+390-80-25-15-15+4
Local nPosDex 	  := nCol+1175-80-25-15-15-50+4
Local nPosUn 	  := nCol+1380-80-25-15-15-100-50+4//1450
Local nPosQuant   := nCol+1480-80-25-25-15-10-15-10-100-50+23//1550
Local nPosVrUni   := nCol+1700-80-25-25-30-15-10-15-10-100-25-50+4//1740
Local nPosVrTot   := nCol+1910-80-25-25-30-30-15-10-15-10-100-25-50+4//1920
Local nPosPIpi 	  := nCol+2080-80-25-25-30-30-30-15-10-15-100-25-50+4//2090
Local nPosVrIpi   := nCol+2170-80-25-25-30-30-30-15-10-10-15-10-100-25-50+4//2190
Local nPosPIcms   := nCol+2270-80-25-25-30-30-30-15-10-10-15-10-100-25-50+4+50//2190
Local nPosVrIcms  := nCol+2380-80-25-25-30-30-30-15-10-10-15-10-100-25-50+4+50//2190
Local nPosObs 	  := nCol+2610-80-25-25-30-30-30-15-10-10-20-15-15-100-25-50+4
// Local nPosNf 	  := nCol+3145-80-25-25-30-30-30-15-10-10-20-15-15-100-25-50+4
// Local nPosLote 	  := nCol+3220-25-25-30-30-30-15-10-10-20-15-15-100-25-50+4
Local oFontCab    := oFont12n
Local oFontCab2   := oFont14n
Local oFontDad    := oFont10
Local nTamanho	  := 35  // Quantidade de carateres por linha na coluna de Descrição
Local nObs   	  := 55 // Quantidade de carateres por linha na coluna de Descrição, Observações
Local nCont       := 0
Local nQtdLin     := 1
Local nTotMerc    := 0
Local nTotIpi     := 0
Local nTotIcms    := 0
Local nTotIcRet	  := 0
Local nTotDesc    := 0
Local nTotDespFre := 0
Local cTipFrete   := ""
Local cCondPg     := ""
Local cTransp     := ""
Local cDtEntre    := ""
//Local cDtTransp   := ""
Local cSELECT  	  := ""
Local cFROM		  := ""
Local cWHERE 	  := ""
Local cORDER	  := ""
Local cQuery
Local lImpCabIt   := .T.
Local cNomeUserSc1:= ""
Local c_C7Moeda   := 1
Local cDescri     := ""


// IMPRIME OS ITENS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta query
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSELECT :=	'SC7.C7_FILIAL, SC7.C7_NUM, SC7.C7_EMISSAO, SC7.C7_FORNECE, SC7.C7_LOJA, '+;
'SC7.C7_ITEM, SC7.C7_PRODUTO,SC7.C7_UM, SC7.C7_DESCRI, SC7.C7_QUANT, SC7.C7_NUMSC, SC7.C7_ITEMSC,'+;
'SC7.C7_PRECO, SC7.C7_IPI,C7_VALIPI,SC7.C7_PICM,SC7.C7_VALICM, SC7.C7_TOTAL,SC7.C7_OBS, SC7.C7_VLDESC, SC7.C7_DESPESA, '+;
'SC7.C7_SEGURO, SC7.C7_VALFRE, SC7.C7_TPFRETE, SC7.C7_ICMSRET, SC7.C7_COND, SC7.C7_APROV, SC7.C7_DATPRF , SC7.C7_MOEDA, '+;
'SC7.C7_SEGUM,SC7.C7_QTSEGUM, SC7.C7_TRANSP, SC7.C7_XCCDESC '

cFROM   :=	RetSqlName('SC7') + ' SC7 '

//cFROM   +=	" LEFT OUTER JOIN " + RetSqlName('SA5') + " SA5 "
//cFROM   +=	" ON SC7.C7_FORNECE = SA5.A5_FORNECE AND SA5.A5_PRODUTO = SC7.C7_PRODUTO "

//cFROM   +=	" LEFT OUTER JOIN " + RetSqlName('SB5') + " SB5 "
//cFROM   +=	" ON SB5.B5_COD = SC7.C7_PRODUTO "

//cFROM   +=	" LEFT JOIN " + RetSqlName('SCR') + " SCR "
//cFROM   +=	" ON SC7.C7_NUM = SCR.CR_NUM AND SC7.C7_FILIAL = SCR.CR_FILIAL "

cWHERE += "SC7.C7_FILIAL = '"+cFilPed+"' "
cWHERE += "AND SC7.C7_NUM = '"+cPedido+"' "
cWHERE += "AND SC7.D_E_L_E_T_ <> '*' "
//cWHERE += "AND SA5.D_E_L_E_T_ <> '*' "
//cWHERE += "AND SB5.D_E_L_E_T_ <> '*' "
// cWHERE += "AND SCR.CR_DATALIB = '"+DTOC(DDATABASE)+"' "

cORDER  :=	'SC7.C7_FILIAL, SC7.C7_ITEM '

cQuery  :=	'SELECT '   + cSELECT + ;
'FROM '     + cFROM   + ;
'WHERE '    + cWHERE  + ;
'ORDER BY ' + cORDER

fCloseArea("TRA")

cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRA", .T., .T.)

DbSelectArea('TRA')
TRA->(DbGoTop())
 
While 	TRA->(!Eof())
	If lImpCabIt

		cTransp := TRA->C7_TRANSP

		If !Empty(TRA->C7_TPFRETE)
			cTipFrete := IIF(ALLTRIM(TRA->C7_TPFRETE) == "C", 'CIF','FOB')
		EndIf
		IIF (!Empty(TRA->C7_COND),cCondPg := ALLTRIM(TRA->C7_COND), "NAO INFORMADA")
		cDtEntre := DTOC(STOD(TRA->C7_DATPRF   ))
		//cDtTransp := DTOC(STOD(TRA->C7_XDTTRAN ))
		
		oRel:FillRect ( {nLin,nCol,nLin+60,nPosCodP-9}, oBrush1, "-2" )
		oRel:Say(nLin+40,nPosItem,"ITEM" ,oFontCab,,CLR_WHITE)
		
		oRel:FillRect ( {nLin,nPosCodP-2,nLin+60,nPosDesc-7}, oBrush1, "-2" )
		oRel:Say(nLin+40,nPosCodP,"CODIGO" ,oFontCab2,,CLR_WHITE)
		
		oRel:FillRect ( {nLin,nPosDesc-2,nLin+60,nPosDex-9}, oBrush1, "-2" )
		oRel:Say(nLin+40,nPosDesc,"DESCRIÇÃO" ,oFontCab,,CLR_WHITE)
		
		oRel:FillRect ( {nLin,nPosDex-2,nLin+60,nPosUn-7}, oBrush1, "-2" )
		//oRel:Say(nLin+40,nPosDex,"E.M." ,oFontCab,,CLR_WHITE)
		oRel:Say(nLin+40,nPosDex,"" ,oFontCab,,CLR_WHITE)
		

		oRel:FillRect ( {nLin,nPosUn-2,nLin+60,nPosQuant-11}, oBrush1, "-2" )	
		oRel:Say(nLin+40,nPosUn,"UN" ,oFontCab,,CLR_WHITE)
	
		oRel:FillRect ( {nLin,nPosQuant-2,nLin+60,nPosVrUni-9}, oBrush1, "-2" )	
		oRel:Say(nLin+40,nPosQuant,"QUANT." ,oFontCab,,CLR_WHITE)	
																			
		oRel:FillRect ( {nLin,nPosVrUni-2,nLin+60,nPosVrTot-9}, oBrush1, "-2" )	
		oRel:Say(nLin+40,nPosVrUni+10,"VLR.UNIT" ,oFontCab,,CLR_WHITE)       
		
		oRel:FillRect ( {nLin,nPosVrTot-2,nLin+60,nPosPIpi-11}, oBrush1, "-2" )
		oRel:Say(nLin+40,nPosVrTot+5,"VL.TOTAL" ,oFontCab,,CLR_WHITE)
		
		oRel:FillRect ( {nLin,nPosPIpi-2,nLin+60,nPosVrIpi-9}, oBrush1, "-2" )
		oRel:Say(nLin+40,nPosPIpi,"%IPI" ,oFontCab,,CLR_WHITE)	
		
		oRel:FillRect ( {nLin,nPosVrIpi-2,nLin+60,nPosPIcms-9}, oBrush1, "-2" )
		oRel:Say(nLin+40,nPosVrIpi,"VL.IPI" ,oFontCab,,CLR_WHITE)

		oRel:FillRect ( {nLin,nPosPIcms-2,nLin+60,nPosVrIcms-11}, oBrush1, "-2" )
		oRel:Say(nLin+40,nPosPIcms,"%ICMS" ,oFontCab,,CLR_WHITE)

		oRel:FillRect ( {nLin,nPosVrIcms-2,nLin+60,nPosObs-9}, oBrush1, "-2" )
		oRel:Say(nLin+40,nPosVrIcms,"VL.ICMS" ,oFontCab,,CLR_WHITE)

		oRel:FillRect ( {nLin,nPosObs-2,nLin+60,nTLinhas+2}, oBrush1, "-2" )
		oRel:Say(nLin+40,nPosObs,"Nome C. Custo + Obs:" ,oFontCab,,CLR_WHITE)

		//oRel:FillRect ( {nLin,nPosNf-2,nLin+60,nPosLote-9}, oBrush1, "-2" )
		//oRel:Say(nLin+40,nPosNf,"Obs" ,oFontCab,,CLR_WHITE)
		

		//oRel:FillRect ( {nLin,nPosLote-2,nLin+60,nTLinhas+2}, oBrush1, "-2" )	
		//oRel:Say(nLin+40,nPosLote,"Lote" ,oFontCab,,CLR_WHITE)
		
		lImpCabIt := .F.
	EndIf

/*
	IF MV_PAR15 == 2

		cDescri := ALLTRIM(TRA->B5_ENGDESC) + "  Deadline: " //+ ALLTRIM(TRA->C7_XPIMPOR)

		If MLCount(ALLTRIM(cDescri),nTamanho) > nQtdLin
			nQtdLin := MLCount(ALLTRIM(cDescri),nTamanho)
		EndIf
		
	ELSE
*/		
	cDescri := ALLTRIM(TRA->C7_DESCRI)

	If MLCount(ALLTRIM(cDescri),nTamanho) > nQtdLin
		nQtdLin := MLCount(ALLTRIM(cDescri),nTamanho)
	EndIf

	//ENDIF


	//If MLCount(ALLTRIM(POSICIONE("SA5",1,XFILIAL("SA5")+TRA->C7_FORNECE+C7_LOJA+C7_PRODUTO,"A5_CODPRF+A5_DESCPRF")),nTamanho) > nQtdLin
	//	nQtdLin := MLCount(ALLTRIM(POSICIONE("SA5",1,XFILIAL("SA5")+TRA->C7_FORNECE+C7_LOJA+C7_PRODUTO,"A5_CODPRF+A5_DESCPRF")),nTamanho)
	//EndIf

	//FUNÇÃO QUE RETORNA NOME DO USUÁRIO - C7_NUMSC
	IF !EMPTY(C7_NUMSC)
		cCodUserSc1 	:= POSICIONE("SC1",1,XFILIAL("SC1")+TRA->C7_NUMSC+C7_ITEMSC,"C1_USER")
		cNomeUserSc1	:= UsrFullName (  cCodUserSc1 )
		cNomeUserSc1	:= " - SOLICITANTE: "+UPPER(Alltrim(cNomeUserSc1) )
	ELSE
		cNomeUserSc1 	:= ""
	ENDIF


	/*	
	If MLCount(ALLTRIM(TRA->C7_OBS) + cNomeUserSc1 ,nObs) > nQtdLin
		nQtdLin := MLCount(ALLTRIM(TRA->C7_OBS) + cNomeUserSc1,nObs)
	EndIf
	*/


	If MLCount(ALLTRIM(TRA->C7_XCCDESC) ,nObs) > nQtdLin
		nQtdLin := MLCount(ALLTRIM(TRA->C7_XCCDESC) ,nObs)
	EndIf

	For nCont := 1 To nQtdLin

		If nCont = 1
			oRel:Line(nLin+60,nCol,nLin+110,nCol)

			oRel:Say(nLin+100,nPosItem,TRA->C7_ITEM ,oFontDad)
			oRel:Line(nLin+60,nPosCodP-5,nLin+110,nPosCodP-5)

			oRel:Say(nLin+100,nPosCodP,TRA->C7_PRODUTO ,oFontDad)
			oRel:Line(nLin+60,nPosDesc-5,nLin+110,nPosDesc-5)

			oRel:Say( nLin+100, nPosDesc,  MemoLine(ALLTRIM(cDescri),nTamanho,nCont) , oFont14n,,CLR_BLACK)
			oRel:Line(nLin+60,nPosDex-5,nLin+110,nPosDex-5)

			//oRel:Say( nLin+100, nPosDex,  MemoLine(ALLTRIM(TRA->B5_XEM),nTamanho,nCont),oFontDad)
			//oRel:Line(nLin+60,nPosUn-5,nLin+110,nPosUn-5)

			//oRel:Say(nLin+100,nPosUn,SubStr(IIF(TRA->A5_UMNFE=='1' ,TRA->C7_UM,TRA->C7_SEGUM),1,25) ,oFontDad)
			//oRel:Line(nLin+60,nPosQuant-5,nLin+110,nPosQuant-5)

			oRel:Say(nLin+100,nPosUn,TRA->C7_UM,oFontDad)
			oRel:Line(nLin+60,nPosQuant-5,nLin+110,nPosQuant-5)

			//oRel:SayAlign(nLin+74,nPosQuant+40-50-25,Transform(IIF(TRA->A5_UMNFE=='1' ,TRA->C7_QUANT,TRA->C7_QTSEGUM),'@E 999,999.99'),oFontDad,140,0, , 1,0)
			//oRel:Line(nLin+60,nPosVrUni-5,nLin+110,nPosVrUni-5)

			oRel:SayAlign(nLin+74,nPosQuant+40-50-25,Transform(TRA->C7_QUANT,'@E 999,999.99'),oFontDad,140,0, , 1,0)
			oRel:Line(nLin+60,nPosVrUni-5,nLin+110,nPosVrUni-5)

			//oRel:SayAlign(nLin+74,nPosVrUni+40-50,TransForm(IIF(TRA->A5_UMNFE=='1' ,TRA->C7_PRECO,TRA->C7_TOTAL/TRA->C7_QTSEGUM),'@E 999,999.99'),oFontDad,140,0, , 1,0)
			//oRel:Line(nLin+60,nPosVrTot-5,nLin+110,nPosVrTot-5)

			oRel:SayAlign(nLin+74,nPosVrUni+40-50,TransForm(TRA->C7_PRECO,'@E 999,999.99'),oFontDad,140,0, , 1,0)
			oRel:Line(nLin+60,nPosVrTot-5,nLin+110,nPosVrTot-5)

			oRel:SayAlign(nLin+74,nPosVrTot+40-50,TransForm(TRA->C7_TOTAL,'@E 999,999.99'),oFontDad,140,0, , 1,0)
			oRel:Line(nLin+60,nPosPIpi-5,nLin+110,nPosPIpi-5)

			oRel:SayAlign(nLin+74,nPosPIpi-40,TransForm(TRA->C7_IPI,'@E 99.99'),oFontDad,100,0, , 1,0)
			oRel:Line(nLin+60,nPosVrIpi-5,nLin+110,nPosVrIpi-5)

			oRel:SayAlign(nLin+74,nPosVrIpi-20,TransForm(TRA->C7_VALIPI,'@E 9,999.99'),oFontDad,100,0, , 1,0)
			oRel:Line(nLin+60,nPosPIcms-5,nLin+110,nPosPIcms-5)

			oRel:SayAlign(nLin+74,nPosPIcms-40,TransForm(TRA->C7_PICM,'@E 99.99'),oFontDad,100,0, , 1,0)
			oRel:Line(nLin+60,nPosVrIcms-5,nLin+110,nPosVrIcms-5)

			oRel:SayAlign(nLin+74,nPosVrIcms-20,TransForm(TRA->C7_VALICM,'@E 9,999.99'),oFontDad,100,0, , 1,0)
			oRel:Line(nLin+60,nPosObs-5,nLin+110,nPosObs-5)

			//oRel:Say( nLin+100, nPosObs,  MemoLine(ALLTRIM(TRA->C7_OBS) + cNomeUserSc1 ,nTamanho,nCont) , oFontDad)
			//oRel:Line(nLin+60,nPosNf-5,nLin+110,nPosNf-5)
			oRel:Say( nLin+100, nPosObs, MemoLine(ALLTRIM(TRA->C7_XCCDESC) +","+TRA->C7_OBS,nObs,nCont), oFontDad)
			//oRel:Line(nLin+60,nPosNf-5,nLin+110,nPosNf-5)

			//oRel:Say( nLin+100, nPosNf,"" ,oFontDad)
			//oRel:Line(nLin+60,nPosLote-5,nLin+110,nPosLote-5)

			//oRel:Say( nLin+100, nPosNf,MemoLine(ALLTRIM(TRA->C7_OBS)) ,oFontDad)
			//oRel:Line(nLin+60,nPosLote-5,nLin+110,nPosLote-5)

			//oRel:Say( nLin+100, nPosLote,"" ,oFontDad)
			oRel:Line(nLin+60,nTLinhas,nLin+110,nTLinhas)// Ultima linha Vertical (Coluna) do item

		Else
			oRel:Say( nLin+100, nPosDesc,  MemoLine(ALLTRIM(cDescri),nTamanho,nCont) , oFont14n,,CLR_BLACK)
			//oRel:Say( nLin+100, nPosObs,  MemoLine(ALLTRIM(TRA->C7_OBS) + cNomeUserSc1 ,nTamanho,nCont) , oFontDad)
			oRel:Say( nLin+100, nPosObs, MemoLine(ALLTRIM(TRA->C7_XCCDESC)+","+TRA->C7_OBS,nObs,nCont) , oFontDad)
			oRel:Line(nLin+60,nCol,nLin+110,nCol)
			oRel:Line(nLin+60,nPosCodP-5,nLin+110,nPosCodP-5)
			oRel:Line(nLin+60,nPosDesc-5,nLin+110,nPosDesc-5)
			oRel:Line(nLin+60,nPosDex-5,nLin+110,nPosDex-5)
			oRel:Line(nLin+60,nPosUn-5,nLin+110,nPosUn-5)
			oRel:Line(nLin+60,nPosQuant-5,nLin+110,nPosQuant-5)
			oRel:Line(nLin+60,nPosVrUni-5,nLin+110,nPosVrUni-5)
			oRel:Line(nLin+60,nPosVrTot-5,nLin+110,nPosVrTot-5)
			oRel:Line(nLin+60,nPosPIpi-5,nLin+110,nPosPIpi-5)
			oRel:Line(nLin+60,nPosVrIpi-5,nLin+110,nPosVrIpi-5)
			oRel:Line(nLin+60,nPosPIcms-5,nLin+110,nPosPIcms-5)
			oRel:Line(nLin+60,nPosVrIcms-5,nLin+110,nPosVrIcms-5)
			oRel:Line(nLin+60,nPosObs-5,nLin+110,nPosObs-5)
			//oRel:Line(nLin+60,nPosNf-5,nLin+110,nPosNf-5)
			//oRel:Line(nLin+60,nPosLote-5,nLin+110,nPosLote-5)
			oRel:Line(nLin+60,nTLinhas,nLin+110,nTLinhas)// Ultima linha Vertical (Coluna) do item


		EndIf
		nLin += 50
		If nLin > nMaxLin
			oRel:Line(nLin+60,nCol,nLin+60,nTLinhas) //Linha horizontal inferior do item
			fImpCabec()
			lImpCabIt := .T.
		EndIf

		c_C7Moeda :=  TRA->C7_Moeda

	Next nCont

	oRel:Line(nLin+60,nCol,nLin+60,nTLinhas) //Linha horizontal inferior do item

	nTotMerc 	+= TRA->C7_TOTAL
	nTotIpi  	+= TRA->C7_VALIPI

	IF POSICIONE("SB1",1,xFilial("SB1")+TRA->C7_PRODUTO,"B1_TIPO")  == "SV"
		nTotIcms 	+= 0
	ELSE
		nTotIcms 	+= TRA->C7_VALICM
	ENDIF

	nTotIcRet	+= TRA->C7_ICMSRET
	nTotDesc 	+= TRA->C7_VLDESC
	nTotDespFre += TRA->(C7_SEGURO+C7_DESPESA+C7_VALFRE)  //incluido 28/07/2016


	nQtdLin := 1
	If nLin > nMaxLin
		fImpCabec()
		lImpCabIt := .T.
	EndIf
	TRA->(DbSkip())

EndDo

nLin += 50

If nLin > 2110 // limite para impressão do painel de totais
	fImpCabec()
EndIf

oRel:FillRect ( {nLin+10,nPosVrUni-5,nLin+55,nPosObs-5}, oBrush1, "-2" )
oRel:Line(nLin+10,nPosObs-5,nLin+10,nTLinhas) //Linha horizontal superior do item
/*
/IF MV_PAR15 == 2

	oRel:SayAlign(nLin+20,nPosVrUni+10,"VLR. DESCONTO (€):",oFontDad,460,0,CLR_WHITE, 1,0)
	oRel:SayAlign(nLin+20, nPosObs, TransForm(nTotDesc,'@E 9,999,999.99'),oFontCab,180,0, , 1,0)

ELSE
*/

oRel:SayAlign(nLin+20,nPosVrUni+10,"VLR. DESCONTO (R$):",oFontDad,460,0,CLR_WHITE, 1,0)
oRel:SayAlign(nLin+20, nPosObs, TransForm(nTotDesc,'@E 9,999,999.99'),oFontCab,180,0, , 1,0)

//ENDIF

oRel:Line(nLin+60-50,nTLinhas,nLin+55,nTLinhas)// Ultima linha Vertical (Coluna) do item
oRel:Line(nLin+55,nPosObs-5,nLin+55,nTLinhas) //Linha horizontal inferior do item

nLin += 50

oRel:FillRect ( {nLin+10,nPosVrUni-5,nLin+55,nPosObs-5}, oBrush1, "-2" )
oRel:Line(nLin+10,nPosObs-5,nLin+10,nTLinhas) //Linha horizontal superior do item
oRel:Say(nLin+20,nCol,"Tipo de Frete: "+cTipFrete+Space(15)+"Data de Entrega: "+ cDtEntre ,oFontCab,,CLR_BLACK)

_nSpacec:= len( "Tipo de Frete: "+cTipFrete+Space(15)+"Data de Entrega: "+ cDtEntre )

oRel:SayAlign(nLin+20,nPosVrUni+10,"VLR.TOTAL IPI (R$):" ,oFontDad,460,0,CLR_WHITE, 1,0)
oRel:SayAlign(nLin+20, nPosObs, TransForm(nTotIpi,'@E 9,999,999.99'),oFontCab,180,0, , 1,0)
oRel:Line(nLin+60-50,nTLinhas,nLin+110-50,nTLinhas)// Ultima linha Vertical (Coluna) do item
oRel:Line(nLin+55,nPosObs-5,nLin+55,nTLinhas) //Linha horizontal inferior do item

nLin += 50

IF !EMPTY(cTransp)
	achasa4(cTransp)
ENDIF


oRel:FillRect ( {nLin+10,nPosVrUni-5,nLin+55,nPosObs-5}, oBrush1, "-2" )
oRel:Line(nLin+10,nPosObs-5,nLin+10,nTLinhas) //Linha horizontal superior do item
//oRel:Say(nLin+20,nCol,"Transportadora: "+IIF(Empty(cTransp),"Não Possui",ALLTRIM(_cNome)+" - CNPJ: "+TransForm(_cCGC,'@R 99.999.999/9999-99')),oFontCab,,CLR_BLACK)
oRel:Say(nLin+20,nCol,"Transportadora: "+IIF(Empty(cTransp),"Não Possui",ALLTRIM(_cNome)),oFontCab,,CLR_BLACK)
oRel:SayAlign(nLin+20,nPosVrUni+10,"VLR.TOTAL ICMS (R$):" ,oFontDad,460,0,CLR_WHITE, 1,0)
oRel:SayAlign(nLin+20, nPosObs, TransForm(nTotIcms,'@E 9,999,999.99'),oFontCab,180,0, , 1,0)
oRel:Line(nLin+60-50,nTLinhas,nLin+55,nTLinhas)// Ultima linha Vertical (Coluna) do item
oRel:Line(nLin+55,nPosObs-5,nLin+55,nTLinhas) //Linha horizontal inferior do item


nLin += 50
oRel:FillRect ( {nLin+10,nPosVrUni-5,nLin+55,nPosObs-5}, oBrush1, "-2" )
oRel:Line(nLin+10,nPosObs-5,nLin+10,nTLinhas) //Linha horizontal superior do item
oRel:SayAlign(nLin+20,nPosVrUni+10,"VLR.TOTAL ICMS RET(R$):" ,oFontDad,460,0,CLR_WHITE, 1,0)
oRel:SayAlign(nLin+20, nPosObs, TransForm(nTotIcRet,'@E 9,999,999.99'),oFontCab,180,0, , 1,0)
oRel:Line(nLin+10,nTLinhas,nLin+110-50,nTLinhas)// Ultima linha Vertical (Coluna) do item
oRel:Line(nLin+55,nPosObs-5,nLin+55,nTLinhas) //Linha horizontal inferior do item

nLin += 50

oRel:FillRect ( {nLin+10,nPosVrUni-5,nLin+55,nPosObs-5}, oBrush1, "-2" )
oRel:Line(nLin+10,nPosObs-5,nLin+10,nTLinhas) //Linha horizontal superior do item
oRel:Say(nLin+10,nCol,"Cond.Pagto: "+IIF(cCondPg =="NAO",cCondPg,ALLTRIM(POSICIONE("SE4",1,XFILIAL("SE4")+ALLTRIM(cCondPg),"E4_DESCRI"))) ,oFontCab,,CLR_BLACK)


//If c_C7MOEDA == 4
//	c_C7MOEDA := "EURO"
//ElseIf c_C7MOEDA == 2
//	c_C7MOEDA := "DOLAR"
if c_C7MOEDA == 1
	c_C7MOEDA := "REAL"
EndIf


oRel:Say(nLin+50,nCol,"Moeda: "+ c_C7MOEDA ,oFontCab,,CLR_BLACK)


oRel:SayAlign(nLin+22,nPosVrUni+10,"VLR.TOTAL DESP/SEGURO/FRETE (R$):" ,oFontDad,460,0,CLR_WHITE, 1,0)
oRel:SayAlign(nLin+22, nPosObs, TransForm(nTotDespFre,'@E 9,999,999.99'),oFontCab,180,0, , 1,0) //TOT. PEDIDO = (MERCADORIAS+IPI+SEGURO+DESPESA+FRETE) - DESCONTO
oRel:Line(nLin+10,nTLinhas,nLin+110-50,nTLinhas)// Ultima linha Vertical (Coluna) do item
oRel:Line(nLin+55,nPosObs-5,nLin+55,nTLinhas) //Linha horizontal inferior do item

nLin += 50

oRel:FillRect ( {nLin+10,nPosVrUni-5,nLin+55,nPosObs-5}, oBrush1, "-2" )
oRel:Line(nLin+10,nPosObs-5,nLin+10,nTLinhas) //Linha horizontal superior do item
oRel:Say(nLin+60,nCol,/*Aprovado por: - Em:*/BuscaAprov(),oFontCab,,CLR_BLACK)

/*
IF MV_PAR15 == 2

	oRel:SayAlign(nLin+22,nPosVrUni+10,"VLR.TOTAL PEDIDO (€):" ,oFontDad,460,0,CLR_WHITE, 1,0)
	oRel:SayAlign(nLin+22, nPosObs, TransForm(nTotMerc+nTotIcRet+nTotIpi+nTotDespFre-nTotDesc,'@E 9,999,999.99'),oFontCab,180,0, , 1,0) //TOT. PEDIDO = (MERCADORIAS+IPI+SEGURO+DESPESA+FRETE) - DESCONTO

ELSE
*/
oRel:SayAlign(nLin+22,nPosVrUni+10,"VLR.TOTAL PEDIDO (R$):" ,oFontDad,460,0,CLR_WHITE, 1,0)
oRel:SayAlign(nLin+22, nPosObs, TransForm(nTotMerc+nTotIcRet+nTotIpi+nTotDespFre-nTotDesc,'@E 9,999,999.99'),oFontCab,180,0, , 1,0) //TOT. PEDIDO = (MERCADORIAS+IPI+SEGURO+DESPESA+FRETE) - DESCONTO

//ENDIF

oRel:Line(nLin+10,nTLinhas,nLin+110-50,nTLinhas)// Ultima linha Vertical (Coluna) do item
oRel:Line(nLin+55,nPosObs-5,nLin+55,nTLinhas) //Linha horizontal inferior do item

nLin += 100

cTxt1 := "Observações:"

cTxt2 := ""
cTxt3 := "NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras.;"
//cTxt4 := 
//cTxt5 := 

If nLin > 2075 //  limite para impressão do painel de observações
	fImpCabec()
EndIf

oRel:Box(nLin,nCol,nLin+250,nTLinhas)
oRel:Say(nLin+40 ,nCol+10,cTxt1,oFont14n,,CLR_GRAY)
oRel:Say(nLin+90 ,nCol+10,cTxt2,oFont14n,,CLR_RED)
oRel:Say(nLin+140,nCol+10,cTxt3,oFont14n,,CLR_BLACK)
//oRel:Say(nLin+190,nCol+10,cTxt4,oFont14n,,CLR_BLACK)
//oRel:Say(nLin+240,nCol+10,cTxt5,oFont14n,,CLR_BLACK)

Return

Static Function fImpRodape()
/*****************************************8
** Rodapé do Relatório
**
****************************/
If !IsBlind()
IncProc("Imprimindo: Rodapé")

oRel:Line(nLin+60,nPosVrTot-5,nLin+110,nPosVrTot-5)

If nLin > nMaxLin
	fImpCabec()
EndIf
endif

nLin := 100

oRel:Box(nLin,nCol,nLin+200,nCol+500)
oRel:SayBitmap( nLin+10,nCol+10,xLogoAcol,450,180)

oRel:FillRect ( {nLin,nCol+510,nLin+200,nTLinhas}, oBrush1, "-2" )
oRel:Say(nLin+125,nCol+1310,"ORDEM DE COMPRA" ,oFont34n,,CLR_WHITE)

nLin += 210

Return

Static Function fBuscaDoc()

/*************************************************
** Busca os documentos de acordo com parâmetros informados
**
**************/
Local cQuery := ""
// RPCSetType(3)


cQuery := " SELECT C7_FILIAL,C7_NUM,C7_FORNECE,C7_LOJA,C7_CONTATO,C7_USER,C7_FILENT,A2_NREDUZ  "
cQuery += " FROM "+RetSqlName("SC7")+ " C7 " "
cQuery += " INNER JOIN "+ RETSQLNAME("SA2") + " A2 ON A2.D_E_L_E_T_ ='' AND C7_FORNECE = A2_COD  AND A2_LOJA=C7_LOJA "
cQuery += " INNER JOIN "+ RETSQLNAME("SCR") + " CR ON CR.D_E_L_E_T_ ='' AND CR_FILIAL=C7_FILIAL AND C7_NUM=CR_NUM  "
cQuery += " AND CR_DATALIB = '"+DTOS(DDATABASE)+"'"
cQuery += " WHERE C7.D_E_L_E_T_ ='' AND  C7_FILIAL = '"+cFil+"' "
cQuery += " GROUP BY C7_FILIAL,C7_NUM,C7_FORNECE,C7_LOJA,C7_CONTATO,C7_USER,C7_FILENT,A2_NREDUZ   "
cQuery += " ORDER BY  C7_FILIAL,C7_NUM "

// cQuery := "SELECT C7_FILIAL,C7_NUM,C7_FORNECE,C7_LOJA,C7_CONTATO,C7_USER,C7_FILENT,A2_NREDUZ FROM "+RetSqlName("SC7")+" "
// cQuery += " INNER JOIN "+ RETSQLNAME("SA2") + " A2_FILIAL ='" +xfilial('SA2')+"' ON C7_FORNECE||C7_LOJA = A2_COD||A2_LOJA "
// cQuery += " INNER JOIN "+ RETSQLNAME("SCR") + " CR_FILIAL ='" +xfilial('SCR')+"' ON C7_NUM = CR_NUM AND C7_FILIAL=CR_FILIAL  " 
// // cQuery += "WHERE C7_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
// cQuery += "WHERE C7_FILIAL = '"+xfilial('SC7')+"' "
// //cQuery += "AND C7_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
// //cQuery += "AND C7_FORNECE||C7_LOJA BETWEEN '"+MV_PAR03+MV_PAR04+"' AND '"+MV_PAR05+MV_PAR06+"' "
// //cQuery += "AND C7_EMISSAO >= '" + DTOS(mv_par12) + "' and C7_EMISSAO <= '" + DTOS(mv_par13) + "' "
// // cQuery += "AND CR_DATALIB = '"+DTOS(DDATABASE)+"'"
// cQuery += "AND CR_DATALIB =  '20250102' "
// cQuery += "AND "+RetSqlName("SC7")+".D_E_L_E_T_ <> '*' AND "+RetSqlName("SA2")+".D_E_L_E_T_ <> '*' GROUP BY C7_FILIAL,C7_NUM,C7_FORNECE,C7_LOJA,C7_CONTATO,C7_USER,C7_FILENT,A2_NREDUZ ORDER BY  C7_FILIAL,C7_NUM"

fCloseArea("TMP")

cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMP", .T., .T.)
Count to nTotal
//Reset Environment
Return

Static Function BuscaAprov()
Local cNomAprov := ""
//Local dDtLib    := ""
Local cRetorno  := ""

dbSelectarea("SCR") // Posicione a liberação
dbSetorder(2)//CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL OU 2= CR_FILIAL+CR_TIPO+CR_NUM+CR_USER
If DBSeek(cFilPed+"PC"+cPedido)
	While !EOF() .and. Alltrim(SCR->CR_NUM) == cPedido
		
		If SCR->CR_STATUS == "03" // Liberado Pelo Usuario
			cNomAprov := Capital(Alltrim(UsrFullName(SCR->CR_USER)))
			cDtLib    := DTOC(SCR->CR_DATALIB)
		EndIf
		
		DBSkip()
	EndDo
EndIf

If Empty(cNomAprov)
	cRetorno := "Aprovador: Não Houve"
Else
	cRetorno := "Aprovado por: "+cNomAprov+" - Em: "+cDtLib
	
EndIf

Return cRetorno
/*
Static Function CreateSX1(cPerg)
/**************************************************
** Montagem da pergunta
**
*****************/
/*
Local aHelp

aHelp := {"Informe o Pedido Inicial"}
PutSx1(cPerg,"01","Ped. De:"   ,"","","mv_ch1","C",6,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelp)
aHelp := {"Informe o Documento Final"}
PutSx1(cPerg,"02","Ped. Ate:"   ,"","","mv_ch2","C",6,0,0,"G","Eval({|| MV_PAR02 >= MV_PAR01})","","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelp)

aHelp := {"Informe o Fornecedor Inicial"}
PutSx1(cPerg,"03","Fornecedor De:"   ,"","","mv_ch3","C",6,0,0,"G","","SA2","","","MV_PAR03","","","","","","","","","","","","","","","","",aHelp)
aHelp := {"Informe a Loja Inicial"}
PutSx1(cPerg,"04","Loja De:"   ,"","","mv_ch4","C",2,0,0,"G","","","","","MV_PAR04","","","","","","","","","","","","","","","","",aHelp)

aHelp := {"Informe o Fornecedor Final"}
PutSx1(cPerg,"05","Fornecedor Ate:"   ,"","","mv_ch5","C",6,0,0,"G","","SA2","","","MV_PAR05","","","","","","","","","","","","","","","","",aHelp)
aHelp := {"Informe a Loja Final"}
PutSx1(cPerg,"06","Loja Até:"   ,"","","mv_ch6","C",2,0,0,"G","","","","","MV_PAR06","","","","","","","","","","","","","","","","",aHelp)

Return(Nil)
*/
Static Function fCloseArea(pParTabe)
/***********************************************
* Funcao para verificar se existe tabela e exclui-la
*
****/
If (Select(pParTabe)!= 0)
	dbSelectArea(pParTabe)
	dbCloseArea()
	If File(pParTabe+GetDBExtension())
		FErase(pParTabe+GetDBExtension())
	EndIf
EndIf
Return


User Function ENVPEDE() // Envia Cotação por E-mail

// Local   CFILPED			:= cEmpAnt+Alltrim(cfilant)
Local	cAssunto		:= "Pedido de compra nº: "+cNumPed + ' - Filial: ' + cFilAnt
Local	cAccount		:= RTrim(SuperGetMV("MV_RELACNT"))
//Local	cDe	 			:= RTrim(UsrRetMail(__cUserID))
Local	cDe	 			:= "totvs.sistema@grupoednave.com.br"
Local	cMail			:= cEmailF
Local	cPara	 		:= Alltrim(cMail)
// Local	cPara	 		:= Alltrim(cMail)+";"+Alltrim(cDe)
// Local	cPassword  		:= Rtrim(SuperGetMv("MV_RELAPSW"))
Local	cServer 		:= Rtrim(SuperGetMv("MV_RELSERV"))
//Local	cMensagem 		:= 'Claudio'+Day2Str(dDataBase)+' de '+ MesExtenso(dDataBase)+ ' de ' +Year2Str(dDataBase) + "<br/> <br/> Vimos por meio deste formalizar a compra dos materiais, conforme condição de pagamento, quantidade, preço e prazos de entrega descritos no documento que consta em anexo. Segue o Pedido de Compra Nº" + cNumPed + ". <br/> <br/> Agradecemos antecipadamente pela presteza e aguardamos sua entrega. <br/>Qualquer dúvida, responder este e-mail para "+RTrim(UsrRetMail(__cUserID))+" <br/> <br/> "+RTrim(usrfullname(__cUserID))+"<br/> <br/>"+ AllTrim(Upper(Posicione("SM0",1,cEmpAnt+Alltrim(cfilant),"M0_FILIAL"))) +'<br/> <br/> <td> <img style="display:block;" src="" height="105" alt=""></td>
Local	cMensagem 		:= ''+Day2Str(dDataBase)+' de '+ MesExtenso(dDataBase)+ ' de ' +Year2Str(dDataBase) + "<br/> <br/> Vimos por meio deste formalizar a compra dos materiais, conforme condição de pagamento, quantidade, preço e prazos de entrega descritos no documento que consta em anexo. Segue o Pedido de Compra Nº" + cNumPed + ". <br/> <br/> <br/> <br/> <br/> <br/> <br/>"+ AllTrim(Upper(Posicione("SM0",1,cEmpAnt+Alltrim(cfilant),"M0_FILIAL"))) +'<br/> <br/> <td> <img style="display:block;" src="" height="105" alt=""></td>
Local 	CFROM1			:= cDe
Local 	cEmailTo 		:= ""	 					// E-mail de destino
Local 	cEmailBcc		:= "" 						// E-mail de copia
Local 	lResult 		:= .F.	 					// Se a conexao com o SMPT esta ok
Local 	cError 			:= ""	 					// String de erro
Local 	lRelauth 		:= SuperGetMv("MV_RELAUTH")	// Parametro que indica se existe autenticacao no e-mail
Local 	lRet	 		:= .F.	 					// Se tem autorizacao para o envio de e-mail
Local 	cConta 			:= cAccount 				//GetMV("MV_RELACNT") 		//ALLTRIM(cAccount)	 // Conta de acesso
Local 	cSenhaTK 		:= GetMV("MV_RELPSW") 		//ALLTRIM(cPassword)	 // Senha de acesso
// Local 	cNumSolic		:= cNumPed
Local 	cAnexos			:= cCamAnexo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
//³que somente ela recebeu aquele email, tornando o email mais personalizado. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cEmail 	 := cMail
cEmailTo := cPara
If At(";",cEmail) > 0 // existe um segundo e-mail.
	cEmailBcc:= SubStr(cEmail,At(";",cEmail)+1,Len(cEmail))
Endif

CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenhaTK RESULT lResult

// Se a conexao com o SMPT esta ok
If lResult
	
	// Se existe autenticacao para envio valida pela funcao MAILAUTH
	If lRelauth
		lRet := Mailauth(cConta,cSenhaTK)
	Else
		lRet := .T.
	Endif
	
	
	If lRet
		SEND MAIL FROM cFrom1 TO cEmailTo SUBJECT cAssunto BODY cMensagem ATTACHMENT cAnexos RESULT lResult
		
		If !lResult
			//Erro no envio do email
			GET MAIL ERROR cError
			Help(" ",1,'Erro no Envio do Email do fornecedor '+ALLTRIM(cNomeF),,cError+ " " + cEmailTo,4,5)	//Atenção
		//Else
			
		//	MSGINFO('Para: ' + cEmailTo,'E-Mail do Pedido de compras para '+ALLTRIM(cNomeF)+' enviado com sucesso!' )
			
		Endif
	Else
		GET MAIL ERROR cError
		Help(" ",1,'Autenticação',,cError,4,5) //"Autenticacao"
		MsgStop('Erro de Autenticação','Verifique a conta e a senha para envio') //"Erro de autenticação","Verifique a conta e a senha para envio"
	Endif
	
	DISCONNECT SMTP SERVER
	
	//	For nI:=1 To Len(aAttach)
	//	 FErase(aAttach[nI])
	//	Next
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,'Erro no Envio do Email',,cError,4,5) //Atencao
Endif

Return(lResult)


Static Function achasa4(cCodSA4)

	// ALLTRIM(SUBSTR(POSICIONE("SA4",1,XFILIAL("SA4")+cTransp,"A4_NREDUZ"),1,40))+" - CNPJ: "+TransForm(POSICIONE("SA4",1,XFILIAL("SA4")+cTransp,"A4_CGC"),'@R 99.999.999/9999-99'))
	Local _aArea	:= FWGetArea()

	xSQL  		:= GetNextAlias()
	xcQuery     := " SELECT A4_NREDUZ,A4_CGC FROM "+RetSqlName("SA4")+" WHERE D_E_L_E_T_ <> '*' AND A4_COD = '"+cCodSA4+"' "
	xcQuery     := ChangeQuery(xcQuery)
	dbUseArea(.T.,"TOPCONN",tCGenQry(,,xcQuery),xSQL,.T.,.T.)

	While (xSQL)->(!Eof())

		_cNome 	:= A4_NREDUZ
		_cCGC 	:= A4_CGC

		( xSQL )->(DbSkip())

	ENDDO

	(xSQL)->(DbCloseArea())
	FWRestArea(_aArea)

Return
