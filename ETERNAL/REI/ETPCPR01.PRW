#Include "TOTVS.ch"
#Include "TopConn.ch"

#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

//Variáveis estáticas
Static nTamFundo  := 15
Static nCorAzul   := RGB(062,179,206)
Static MP_CONPAD As Character


/*---------------------------------------------------------------------*
 | Func:  RVESTR03                                                     |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Consulta Ordem de Produção, permite aplicar filtros como Nº  |
 |		  OP, Data de Entrega, Produto e Tipo de OP, após esse filtro  |
 |        permite a seleção de OPs para geração Relatório Ordem de     |
 |		  Produção modelo gráfico, este relatório possui a função de   |
 |        impressão das ordens de produção com os dados da OP pai e    |
 |        suas filhas, materiais utilizados dados do pedido de venda,  |
 |        quando aberta pelo pedido de venda bem como as operações da  |
 |        Ordem de Produção.                                           |
 |        VERSÃO 02 DO RELATORIO                                       |					
 *---------------------------------------------------------------------*/
User Function ETPCPR01
	Local aArea      	:= GetArea()
	Private cLogoEmp 	:= fLogoEmp()
	Private cOpDe    	:= ""
	Private cOpAt    	:= ""
	Private cEmissDe    := FirstDate(Date())
	Private cEmissAt    := LastDate(Date())
	Private cProdDe	    := ""
	Private cProdAt 	:= ""
	Private cTipo 		:= ""
	Private cImp 		:= ""
	Private cObstot		:= ""
	Private cPerg 		:= "RVESTR03"
	Private cOPAtu		:= ""
//	Private oTable
	cAlias  := "TMPIMP" 
	SetKey(VK_F12, {||GenTable(cAlias),oMark:SetInvert(.F.),oMark:Refresh(),oMark:GoTop(.T.) } )//Programa a tecla F12, para reaplicar o filtro
	
	Processa({|| Browse()},"Gerando a Consulta", "Processando...",.T.)
	
	SetKey(VK_F12,{||})
	
	Pergunte("MTA650",.F.)
	RestArea(aArea)
Return


/*---------------------------------------------------------------------*
 | Func:  Browse                                                       |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função para montagem do Browse                               |
 *---------------------------------------------------------------------*/
Static Function Browse()
	Private oMark
	Private aFields As Array
//	Private bKeyF12    := {||GenTable(cAlias),oMark:SetInvert(.F.),oMark:Refresh(),oMark:GoTop(.T.) } //Programa a tecla F12, para reaplicar o filtro
	aFields := {}

	if	GenTable(cAlias) //Gera tabela temporária

		// CAMPOS DO NAVEGADOR
		AAdd(aFields, {"Data",    "TRB_DATPRF",  "C", 10, 00})
		AAdd(aFields, {"O.F.", "TRB_OP", "C", 10, 00})
		AAdd(aFields, {"Dt.Criação", "TRB_EMISS", "C", 10, 00})
		AAdd(aFields, {"Produto", "TRB_PROD", "C", 5, 00})
		AAdd(aFields, {"Grupo", "TRB_GRUPO", "C", 5, 00})
		AAdd(aFields, {"Descrição", "TRB_DESCRI", "C", 30, 00})
		AAdd(aFields, {"Qte.Orig", "TRB_QUANT", "C", 5, 00})
		AAdd(aFields, {"Qte.Prd", "TRB_QUJE", "C", 5, 00})
		AAdd(aFields, {"Tipo", "TRB_TIPO", "C", 3, 00})
		AAdd(aFields, {"Observação", "TRB_OBS", "C", 30, 00})

		oMark := FwMarkBrowse():New()// Instância um Objeto FWMBrowse, setando a tabela, a descrição e ativando a navegação
		oMark:SetIgnoreARotina(.T.)
		oMark:SetMenuDef("RVESTR03")
		oMark:IsInvert(.T.)
		oMark:SetAlias(cAlias)// Identificando a Tabela
		oMark:SetDescription("Consulta Ordem de Produção") // Definindo o Título do FWMBrowse
		oMark:SetTemporary(.T.)
		oMark:SetFields(aFields)
		oMark:SetFieldMark("TRB_OK") // Adiciona o checkbox
		oMark:AddButton("Confirmar", {|| CheckSelected(@oMark)})//Adiciona o botão confirmar
	//	oMark:SetParam(bKeyF12) // Seta tecla F12

		//Cria a Legenda tipo de ordem de Produção
		oMark:AddLegend("TRB_LEG=='F'","GREEN"     ,"Ordem de Produção Firme")
		oMark:AddLegend("TRB_LEG=='P'","YELLOW"     ,"Ordem de Produção Prevista")
		oMark:AddLegend("TRB_LEG=='I'","ORANGE"     ,"Ordem de Produção Iniciada")
		oMark:AddLegend("TRB_LEG=='O'","GRAY"     ,"Ordem de Produção Ociosa")
		oMark:AddLegend("TRB_LEG=='E'","RED"     ,"Ordem de Produção Encerrada")

		// Ativando o Objeto
		oMark:Activate()
	endif
Return

/*---------------------------------------------------------------------*
 | Func:  GenTable                                                     |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função para montagem da Tabela temporária                    |
 *---------------------------------------------------------------------*/
Static Function GenTable(cAlias As Character)
	Local aFields As Array   // VETOR DE CAMPOS
	Local aData   As Array   // CONTEÚDO DOS CAMPOS
	Local nX      As Numeric // CONTROLADOR DE LAÇO
	Local oTable  As Object  // OBJETO DA TABELA TEMPORÁRIA
	Local lRet := .T.
	// INICIALIZAÇÃO DE VARIÁVEIS
	nX      := 0
	aData   := {}
	aFields := {}


//	if filtra()
	ValidPerg()
	If pergunte(cPerg,.t.)
		cOpDe 	:= MV_PAR01
		cOpAt 	:= MV_PAR02
		cEmissDe:= MV_PAR03
		cEmissAt:= MV_PAR04
		cProdDe	:= MV_PAR05
		cProdAt := MV_PAR06
		cTipo	:= MV_PAR07
		cImp	:= MV_PAR08

		If Select ("TMPIMP")>0
			TMPIMP->(DbCloseArea())
		End If

		oTable	:= FwTemporaryTable():New(cAlias)

		// DEFINE A ESTRUTURA DE CAMPOS
		AAdd(aFields, {"TRB_LEG",   "C", 01, 00})
		AAdd(aFields, {"TRB_OK",   "C", 02, 00})
		AAdd(aFields, {"TRB_DATPRF",  "D", 08, 00})
		AAdd(aFields, {"TRB_OP", "C", 11, 00})
		AAdd(aFields, {"TRB_EMISS",  "D", 08, 00})
		AAdd(aFields, {"TRB_PROD",  "C", 15, 00})
		AAdd(aFields, {"TRB_GRUPO",  "C", 04, 00})
		AAdd(aFields, {"TRB_DESCRI",  "C", 60, 00})
		AAdd(aFields, {"TRB_QUANT",  "N", 12, 02})
		AAdd(aFields, {"TRB_QUJE",  "N", 12, 02})
		AAdd(aFields, {"TRB_TIPO",  "C", 02, 00})
		AAdd(aFields, {"TRB_OBS",  "C", 30, 00})

		oTable:SetFields(aFields)// INSERE OS CAMPOS NA TABELA TEMPORÁRIA
		oTable:AddIndex("01", {"TRB_OP"}) // ÍNDICE DA TABELA TEMPORÁRIA
		oTable:Create()// CRIA A TABELA
		DbSelectArea(cAlias)// SELECIONA A ÁREA PARA NÃO PRECISAR APONTAR

		cSql := "SELECT C2_DATPRF,C2_NUM, C2_ITEM, C2_SEQUEN, C2_EMISSAO, "
		cSql += "C2_PRODUTO, B1_GRUPO, B1_DESC, B1_UM, C2_QUANT, C2_QUJE, B1_TIPO, C2_OBS, "
		cSql += "CASE "
		cSql += " WHEN C2_DATRF <>' ' THEN 'E' "
		cSql += " WHEN C2_TPOP = 'P' THEN 'P' "
		cSql += " WHEN C2_TPOP = 'F' AND (SELECT D3_OP FROM " +  retsqlname("SD3") + " SD3 WHERE D3_FILIAL = C2_FILIAL AND D3_OP = (C2_NUM||C2_ITEM||C2_SEQUEN) AND SD3.D_E_L_E_T_=' ' GROUP BY D3_OP) <>' ' THEN 'I' "
		cSql += " WHEN C2_TPOP = 'F' AND TO_DATE(C2_DATPRI,'yyyymmdd') - SYSDATE > C2_DIASOCI THEN 'O' "
		cSql += " ELSE 'F' "
		cSql += " END TIPO "
		cSql += " FROM" +  retsqlname("SC2") + " SC2"
		cSql += " INNER JOIN " + retsqlname("SB1") + " SB1 ON (B1_FILIAL = '" + FwxFilial("SB1") + "' AND B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_ = ' ')"
		cSql += "WHERE SC2.D_E_L_E_T_ = ' '"
		cSql += "AND C2_FILIAL = '" + xFilial("SC2") + "'"
		cSql += " AND C2_NUM >= '"+TRIM(cOpDe)+"' "
		cSql += " AND C2_NUM <= '"+TRIM(cOpAt)+"' "
		cSql += " AND C2_DATPRF >= '"+DTOS(cEmissDe)+"' "
		cSql += " AND C2_DATPRF <= '"+DTOS(cEmissAt)+"' "
		cSql += " AND C2_PRODUTO >= '"+cProdDe+"' "
		cSql += " AND C2_PRODUTO <= '"+cProdAt+"' "
		//cSql += " AND C2_X_IMP <= '"+str(cImp)+"' "
		if cImp <> 1
			cSql += " AND (CASE "
			cSql += "	WHEN C2_X_IMP = '1' THEN '1' "
			cSql += "	ELSE '2' "
			cSql += " END)='"+BUSCAIMP(cImp)+"'"
		End if
		if cTipo <> 1
			cSql += " AND (CASE "
			cSql += "	WHEN C2_DATRF <>' ' THEN 'E' "
			cSql += "	WHEN C2_TPOP = 'P' THEN 'P' "
			cSql += "	WHEN C2_TPOP = 'F' AND (SELECT D3_OP FROM" +  retsqlname("SD3") + " SD3 WHERE  D3_FILIAL = C2_FILIAL AND D3_OP = (C2_NUM+C2_ITEM+C2_SEQUEN) AND SD3.D_E_L_E_T_=' ' GROUP BY D3_OP)  <>' ' THEN 'I' "
			cSql += "	WHEN C2_TPOP = 'F' AND TO_DATE(C2_DATPRI,'yyyymmdd') - SYSDATE > C2_DIASOCI THEN 'O' "
			cSql += "	ELSE 'F' "
			cSql += " END)='"+BUSCATIPO(cTipo)+"'"
		end if
		cSql := ChangeQuery(cSql)
		//MemoWrite("D:\TEMP\IMPOP.TXT",cSql)

		If Select ("QSB1")>0
			QSB1->(dbCloseArea())
		End If
		TcQuery cSql new Alias "QSB1"

		While !QSB1 -> (EOF())
			RecLock(cAlias, .T.)
			TRB_LEG		:= QSB1->TIPO
			TRB_DATPRF	:= STOD(QSB1->C2_DATPRF)
			TRB_OP		:= QSB1->(C2_NUM+C2_ITEM+C2_SEQUEN)
			TRB_EMISS	:= STOD(QSB1->C2_EMISSAO)
			TRB_PROD	:= QSB1->C2_PRODUTO
			TRB_GRUPO	:= QSB1->B1_GRUPO
			TRB_DESCRI	:= QSB1->B1_DESC
			TRB_QUANT	:= QSB1->C2_QUANT
			TRB_QUJE	:= QSB1->C2_QUJE
			TRB_TIPO	:= QSB1->B1_TIPO
			TRB_OBS		:= QSB1->C2_OBS
			MsUnlock()
			QSB1->(dbSkip())
		End
		DbGoTop()// POSICIONA NO INÍCIO DO ARQUIVO
	else
		lRet := .F.
	endif

Return lRet

/*---------------------------------------------------------------------*
 | Func:  filtra                                                       |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função para geração do Filtro da Consulta                    |
 *---------------------------------------------------------------------*/
/*
static function Filtra()
	Local lRet := .T.
	aPergs := {;
		{1,"Ordem de Prod De",CRIAVAR("C2_NUM", .F.)+CRIAVAR("C2_ITEM", .F.)+CRIAVAR("C2_SEQUEN", .F.),"@!",'.T.',"SC2",'.T.',80,.F.},;
		{1,"Ordem de Prod Ate",CRIAVAR("C2_NUM", .F.)+CRIAVAR("C2_ITEM", .F.)+CRIAVAR("C2_SEQUEN", .F.),"@!",'.T.',"SC2",'.T.',80,.F.},;
		{1,"Data de Entrega De",cEmissDe,"@!",'.T.',"SC2",'.T.',80,.F.},;
		{1,"Data de Entrega Ate",cEmissAt,"@!",'.T.',"SC2",'.T.',80,.F.},;
		{1,"Produto De",CRIAVAR("C2_PRODUTO", .F.),"@!",'.T.',"SC2",'.T.',80,.F.},;
		{1,"Produto Ate",CRIAVAR("C2_PRODUTO", .F.),"@!",'.T.',"SC2",'.T.',80,.F.},;
		{2,"Tipo OF","T",{"T=Todos", "E=Encerradas", "F=Firme", "I=Iniciada", "O=Ociosa", "P=Prevista" },60,"",.F.},;
		{2,"OF Impresso?","T",{"T=Todos", "1=Sim", "2=Não" },60,"",.F.};
		}
	if Parambox(aPergs, "Parametros para filtro")
		cOpDe 	:= MV_PAR01
		cOpAt 	:= MV_PAR02
		cEmissDe:= MV_PAR03
		cEmissAt:= MV_PAR04
		cProdDe	:= MV_PAR05
		cProdAt := MV_PAR06
		cTipo	:= MV_PAR07
		cImp	:= MV_PAR08
	else
		lRet := .F.
	endif
return lRet
*/
Static Function BUSCATIPO(nTipProd)
Local cTipo := ""
	Do Case
		Case nTipProd == 2
			cTipo := "E"
		Case nTipProd == 3
			cTipo := "F"
		Case nTipProd == 4
			cTipo := "I"
		Case nTipProd == 5
			cTipo := "P"
	EndCase
Return cTipo

Static Function BUSCAIMP(nImp)
Local cJaimp := ""
	Do Case
		Case nImp == 2
			cJaimp := "1"
		Case nImp == 3
			cJaimp := "2"
	EndCase
Return cJaimp



Static Function ValidPerg()

	Local _sAlias := Alias()
	Local aRegs   := {}
	Local i,j   


	dbSelectArea("SX1")
	dbSetOrder(1)

	cPerg := PADR(cPerg,10)
	aAdd(aRegs,{cPerg,"01","De Ord. Producao","","","mv_ch1","C",TamSX3("C2_NUM")[1]+TamSX3("C2_ITEM")[1]+TamSX3("C2_SEQUEN")[1],0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","C2IOP","","","",""})
	aAdd(aRegs,{cPerg,"02","Ate Ord. Producao","","","mv_ch2","C",TamSX3("C2_NUM")[1]+TamSX3("C2_ITEM")[1]+TamSX3("C2_SEQUEN")[1],0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","C2IOP","","","",""})
	aAdd(aRegs,{cPerg,"03","De Dt. Entrega	","","","mv_ch3","D",8,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Ate Dt. Entrega	","","","mv_ch4","D",8,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","De Produto		","","","mv_ch5","C",TamSX3("C2_PRODUTO")[1],0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
	aAdd(aRegs,{cPerg,"06","Ate Produto		","","","mv_ch6","C",TamSX3("C2_PRODUTO")[1],0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
	aAdd(aRegs,{cPerg,"07","Tipo OP			","","","mv_ch7","N",01,00,00,"C","","mv_par07","Todos","","","","","Encerradas","","","","","Firme","","","","","Iniciada","","","","","Prevista"})
	aAdd(aRegs,{cPerg,"08","OP Impressa		","","","mv_ch8","N",01,00,00,"C","","mv_par08","Todos","","","","","Sim","","","","","Não","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)


Return()


/*---------------------------------------------------------------------*
 | Func:  CheckSelected                                                |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Prepara o retorno da seleção para geração do Relatório       |
 *---------------------------------------------------------------------*/

Static Function CheckSelected(oMark As Object)
    Local cSelected As Character // RETORNO DA CONSULTA

    // INICIALIZAÇÃO DE VARIÁVEIS
    cSelected := Space(0)

    // PERCORRE A TABELA CORRENTE E CONCATENA CAMPOS MARCADOS
    DbGoTop()
    DbEval({|| IIf(oMark:IsMark(oMark:Mark()), cSelected += ",'" + AllTrim(TRB_OP) +"'", cSelected += Space(0))})

    // REMOVE O PRIMEIRO CARACTERE E ATRIBUI A VARIÁVEL DE RETORNO
    MP_CONPAD := IIf(Len(cSelected) > 0, SubStr(cSelected, 2), cSelected)
    If empty (cSelected)
    	Alert('Por favor, selecione ao menos uma Ordem de Produção para Impressão')
    Else
	    fMontaRel()
	    Desmarcar()
    end if
    
Return 

Static Function Desmarcar()
     dbSelectArea( cAlias )
     dbGotop()

     Do While !EoF()
          If RecLock( cAlias, .F. )
               TRB_OK:= " "
               msUnLock()
          EndIf
          dbSelectArea( cAlias )
          dbSkip()
     EndDo
     oMark:SetInvert(.F.)
     oMark:Refresh()
     oMark:GoTop(.T.)
Return
//--------------------------------------------------------
// SOBRESCRIÇÃO DAS OPERAÇÕES DA ROTINA PADRÃO
//--------------------------------------------------------
//Static Function MenuDef()
//    Local aRotina As Array // OPERAÇÕES DA ROTINA

    // INICIALIZAÇÃO DE VARIÁVEIS
//    aRotina := {}
//Return (aRotina)

/*---------------------------------------------------------------------*
 | Func:  fMontaRel                                                    |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função principal que monta o relatório                       |
 *---------------------------------------------------------------------*/
Static Function fMontaRel()
	Local cNomeRel	:= "OP_"+FunName()+"_"+RetCodUsr()
	Private cHoraEx	:= Time()
	Private nPagAtu	:= 1
	Private aOBS := {}


	//Linhas e colunas
	Private nLinAtu	:= 0
	Private nLinFin	:= 800
	Private nLin	:= 0
	Private nColIni	:= 010
	Private nColFin	:= 550
	Private nColMeio:= (nColFin-nColIni)/2
	Private nCol01	:= 010
	Private nCol02	:= 030
	Private nCol03	:= 050
	Private nCol04	:= 070
	Private nCol05	:= 090
	Private nCol06	:= 110
	Private nCol07	:= 130
	Private nCol08	:= 150
	Private nCol09	:= 170
	Private nCol10	:= 190
	Private nCol11	:= 210
	Private nCol12	:= 230
	Private nCol13	:= 250
	Private nCol14	:= 270
	Private nCol15	:= 290
	Private nCol16	:= 310
	Private nCol17	:= 330
	Private nCol18	:= 350
	Private nCol19	:= 370
	Private nCol20	:= 390
	Private nCol21	:= 410
	Private nCol22	:= 430
	Private nCol23	:= 450
	Private nCol24	:= 470
	Private nCol25	:= 490
	Private nCol26	:= 510
	Private nCol27	:= 530
	Private nCol28	:= 550

	Private oPrintPvt

	//Declarando as fontes
	Private cNomeFont := "Arial"
	Private oFontDet  := TFont():New(cNomeFont, 9, -7,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontDetN  := TFont():New(cNomeFont, 9, -7,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFontRON  := TFont():New(cNomeFont, 9, -30,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFontRod  := TFont():New(cNomeFont, 9, -6,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontTit1N := TFont():New(cNomeFont, 9, -11, .T., .T., 5, .T., 5, .T., .F.)
	Private oFontTitN := TFont():New(cNomeFont, 9, -12, .T., .T., 5, .T., 5, .T., .F.)
	Private oFontTit  := TFont():New(cNomeFont, 9, -12, .T., .F., 5, .T., 5, .T., .F.)
	Private oFontCab1  := TFont():New(cNomeFont, 9, -16, .T., .F., 5, .T., 5, .T., .F.)
	Private oFontCab1N := TFont():New(cNomeFont, 9, -16, .T., .T., 5, .T., 5, .T., .F.)
	Private oFontCab  := TFont():New(cNomeFont, 9, -10,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontCabN := TFont():New(cNomeFont, 9, -10,  .T., .T., 5, .T., 5, .T., .F.)
	
	oPrintPvt := FWMSPrinter():New(cNomeRel, IMP_PDF, .F., /*cStartPath*/, .T., , @oPrintPvt, , , , , .T.)

	//Setando os atributos necessários
	oPrintPvt:cPathPDF := GetTempPath()
	oPrintPvt:SetResolution(72)
	oPrintPvt:SetPortrait()
	oPrintPvt:SetPaperSize(DMPAPER_A4)
	oPrintPvt:SetMargin(60, 60, 60, 60)
	
	//Selecionando a ordem de produção

	cQuery := " SELECT C2_UM, C2_NUM, C2_ITEM, C2_SEQUEN, C2_PEDIDO, C2_ITEMPV, A1_NOME, C2_EMISSAO, C2_DATPRF, "
	cQuery += " C2_PRODUTO, B1_DESC, B1_UM, C2_QUANT, C2_ROTEIRO "
	//cQuery += " ISNULL(CAST(CAST(C2_X_OBS2 AS VARBINARY(4096)) AS VARCHAR(4096)),' ') AS C2_X_OBS2 "
	cQuery += " FROM " + retsqlname("SC2") + " SC2"
	cQuery += " INNER JOIN " + retsqlname("SB1") + " SB1 ON (B1_FILIAL = '" + FwxFilial("SB1") + "' AND B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_ = ' ')"
	cQuery += " LEFT JOIN "  + retsqlname("SC5") + " SC5 ON (C5_FILIAL = '" + FwxFilial("SC5") + "' AND C5_NUM = C2_PEDIDO AND SC5.D_E_L_E_T_ = ' ')"	
	cQuery += " LEFT JOIN "  + retsqlname("SA1") + " SA1 ON (A1_FILIAL = '" + FWxFilial("SA1") + "' AND A1_COD = C5_CLIENT AND A1_LOJA = C5_LOJAENT AND SA1.D_E_L_E_T_ = ' ')"		
	cQuery += " WHERE C2_FILIAL = '" + xFilial("SC2") + "'"
	cQuery += " AND C2_NUM >= '"+TRIM(cOpDe)+"' "
	cQuery += " AND C2_NUM <= '"+TRIM(cOpAt)+"' "
	//cQuery += " AND C2_NUM+C2_ITEM+C2_SEQUEN IN ("+MP_CONPAD+") "
	cQuery += " AND SC2.D_E_L_E_T_= ' ' "
	cQuery += " ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN"

	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery New Alias "QSC2"
	TCSetField("QSC2", "C2_NUM", "C")
	TCSetField("QSC2", "C2_EMISSAO", "D")
	TCSetField("QSC2", "C2_DATPRF", "D")
	
	ProcRegua(QSC2->(RecCount()))
	_nReg := 1  //*** variavel auxiliar controlar a posição do array a ser incluido os dados do produto de compra
	
	//Iniciando Página

	oPrintPvt:StartPage()

	//Enquanto houver pedidos
	While ! QSC2->(EoF())

		If nPagAtu >1
			oPrintPvt:StartPage()
		End If

		//Imprime o cabeçalho fImpCab()
		fImpCab()
		fImpObs()

		SC2->(dbSetOrder(1))
	    SC2->(dbSeek(xFilial("SC2") + QSC2->C2_NUM + QSC2->C2_ITEM + '001'))
	    
	    SB1->(dbSetOrder(1))
	    SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))

		IF QSC2->C2_SEQUEN <>'001'
			fImpOpPai()
		EndIf

		//Imprime o cabeçalho dos Componentes da Ordem de Produção fImpProd()
		fImpProd()

		cQuery := " SELECT *"
		cQuery += " FROM " + retsqlname("SD4") + " SD4"
		cQuery += " INNER JOIN " + retsqlname("SB1") + " SB1 ON (B1_FILIAL = '" + FWxFilial("SB1") + "' AND B1_COD = D4_COD AND SB1.D_E_L_E_T_ = ' ')"
		cQuery += " WHERE D4_FILIAL = '" + xFilial("SD4") + "'"
		cQuery += " AND SUBSTR(D4_OP,1,6) = '" + QSC2->C2_NUM + "'"
		cQuery += " AND SD4.D_E_L_E_T_<> '*' "
		
		MemoWrite("D:\TEMP\IMPOP1.TXT",cQuery)

		TCQuery cQuery ALIAS "QSD4" NEW		
		
		Do While !QSD4->(eof())
		//Imprime o detalhe dos Componentes da Ordem de Produção fImpPDet()
			if nLin >= nLinFin
    			fImpRod()
				fNewPage()	
			endif
			fImpPDet()
			QSD4->(dbSkip())
		endDo
		QSD4->(dbCloseArea())				

		cQuery := " SELECT DISTINCT G2_PRODUTO, G2_DESCRI, HB_NOME, H1_DESCRI, G2_OPERAC, B1_DESC "
		cQuery += " FROM " + retsqlname("SG2") + " SG2"
		cQuery += " INNER JOIN " + retsqlname("SB1") + " SB1 ON (B1_FILIAL = '" + FWxFilial("SB1") + "' AND B1_COD = G2_PRODUTO AND SB1.D_E_L_E_T_ = ' ')"
		cQuery += " LEFT JOIN " + retsqlname("SH1") + " SH1 ON (H1_FILIAL = '" + FWxFilial("SH1") + "' AND H1_CODIGO = G2_RECURSO AND SH1.D_E_L_E_T_ = ' ')"
		cQuery += " LEFT JOIN " + retsqlname("SHB") + " SHB ON (HB_FILIAL = '" + FWxFilial("SHB") + "' AND HB_COD = G2_CTRAB AND SHB.D_E_L_E_T_ = ' ')"				
		cQuery += " WHERE G2_FILIAL = '" + FWxFilial("SG2") + "'" 
		cQuery += " AND G2_PRODUTO = '" + QSC2->C2_PRODUTO + "'"
		cQuery += " AND G2_CODIGO = '" + QSC2->C2_ROTEIRO + "'"
		cQuery += " AND SG2.D_E_L_E_T_= ' ' "
		cQuery += " ORDER BY SG2.G2_OPERAC DESC"

		MemoWrite("D:\TEMP\IMPOP2.TXT",cQuery)

		TCQuery cQuery ALIAS "QSG2" NEW

		If	QSG2->(eof())
			nLin += 5
			oPrintPvt:Line(nLin, nCol01, nLin, nCol28)
			nLin += 5
			oPrintPvt:Box(nLin, nCol01,nLin+15, nCol28)
			oPrintPvt:SayAlign(nLin+2, nCol01,  "NÃO EXISTEM OPERAÇÕES CADASTRADAS PARA ESSE PRODUTO", oFontCabN, 540, 05, nCorAzul, PAD_CENTER,  )	
			nLin += 20
			oPrintPvt:Line(nLin, nCol01, nLin, nCol28)
		endif	
		Do While !QSG2->(eof())
			
			if nLin+120 >= nLinFin
    			fImpRod()
				fNewPage()	
			endif
			
			fImpRot()
			QSG2->(dbSkip())
		endDo
		QSG2->(dbCloseArea())


		//Se houver linhas na página ainda, imprime o rodapé fImpRod()
		fImpRod()

	    oPrintPvt:EndPage()
		//Impresso()
		QSC2->(DbSkip())
	EndDo
	QSC2->(DbCloseArea())
	oPrintPvt:Preview()
Return

/*---------------------------------------------------------------------*
 | Func:  fImpCab                                                      |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função que imprime o cabeçalho                               |
 *---------------------------------------------------------------------*/

Static Function fImpCab()
	Local nLinCabOrig := 030
		
	//Box Logo		
    //oPrintPvt:Box(nLinCabOrig, nCol01,nLinCab+100, nCol05)
	oPrintPvt:SayBitmap(nLinCabOrig+3,nCol01+3, cLogoEmp, 040, 040)
    
	oPrintPvt:SayAlign(nLinCabOrig+10, nCol01, "ORDEM DE PRODUÇÃO", oFontCab1N, 550, , , PAD_CENTER,  )
	oPrintPvt:SayAlign(nLinCabOrig, nCol22, " Nº: "+Alltrim (QSC2->(C2_NUM + C2_ITEM + C2_SEQUEN)), oFontCab1N, 140, , , PAD_CENTER,  )
	
	//- ajuste para a diferenca de numero de casas
	If len(QSC2->(C2_NUM + C2_ITEM + C2_SEQUEN)) == 11
		cCode:=QSC2->(C2_NUM + C2_ITEM + C2_SEQUEN + "   ")
	Else
		cCode:=QSC2->(C2_NUM + C2_ITEM + C2_SEQUEN)
	EndIf
	oPrintPvt:FWMSBAR("CODE128" /*cTypeBar*/,4/*nRow*/ ,31/*nCol*/ ,cCode  /*cCode*/,oPrintPvt/*oPrint*/,/*lCheck*/,/*Color*/,/*lHorz*/, 0.025/*nWidth*/,0.5/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)

	//-- Linha 01
	nLinCabOrig +=50
	oPrintPvt:Box(nLinCabOrig, nCol01,nLinCabOrig+17, nCol04+3)
	oPrintPvt:SayAlign(nLinCabOrig, nCol01+3,  "Cliente:", oFontTit, 120, 05, , PAD_LEFT,  )
	oPrintPvt:Box(nLinCabOrig, nCol04+3,nLinCabOrig+17, nCol20)
	oPrintPvt:SayAlign(nLinCabOrig, nCol04+6, Alltrim (QSC2->(A1_NOME +" - "+ C2_ITEMPV)), oFontTitN, 180, 05, , PAD_LEFT,  )
	oPrintPvt:Box(nLinCabOrig, nCol20,nLinCabOrig+17, nCol24)
	oPrintPvt:SayAlign(nLinCabOrig, nCol20+3,  "P. Venda Nº:", oFontTit, 120, 05, , PAD_LEFT,  )
	oPrintPvt:Box(nLinCabOrig, nCol24,nLinCabOrig+17, nCol28)
	oPrintPvt:SayAlign(nLinCabOrig, nCol24+3, Alltrim (QSC2->(C2_PEDIDO +" - "+ C2_ITEMPV)), oFontTitN, 060, 05, , PAD_LEFT,  )
	
	//-- Linha 02
	nLinCabOrig +=17
	//oPrintPvt:Box(nLinCabOrig, nCol01,nLinCabOrig+20, nCol04)
	oPrintPvt:SayAlign(nLinCabOrig+2, nCol01+3, Alltrim(QSC2->(C2_PRODUTO)), oFontTitN, 160, , , PAD_LEFT,  )
	oPrintPvt:Box(nLinCabOrig, nCol04+3,nLinCabOrig+20, nCol24)
	oPrintPvt:SayAlign(nLinCabOrig+2, nCol04+6, Substr(QSC2->(B1_DESC),1,80), oFontTitN, 400, , , PAD_LEFT,  )
	oPrintPvt:Box(nLinCabOrig, nCol24,nLinCabOrig+20, nCol28)
	oPrintPvt:SayAlign(nLinCabOrig, nCol24+3,  "Emissão:", oFontDet, 80, 05, , PAD_LEFT,  )
	oPrintPvt:SayAlign(nLinCabOrig+7, nCol24+3, DTOC(QSC2->(C2_EMISSAO)), oFontTitN, 80, 05, , PAD_CENTER,  )

	//-- Linha 03
	nLinCabOrig +=20
	
	oPrintPvt:Box(nLinCabOrig, nCol01,nLinCabOrig+20, nCol03,"-4")
	oPrintPvt:SayAlign(nLinCabOrig+2, nCol01+3,  "Qtde:", oFontTitN, 80, 05, , PAD_LEFT,  )

	oPrintPvt:Box(nLinCabOrig, nCol03,nLinCabOrig+20, nCol10)
	oPrintPvt:SayAlign(nLinCabOrig, nCol03+3,  "Programada:", oFontDet, 80, 05, , PAD_LEFT,  )
	
	oPrintPvt:Say(nLinCabOrig+16, nCol05+3, alltrim(TRANSFORM(QSC2->(C2_QUANT), PesqPict("SC2","C2_QUANT"))), oFontTitN, 120, 05, , PAD_CENTER,  )
	//oPrintPvt:Say(nLinCabOrig+16, nCol10+3, QSC2->B1_UM, oFontTitN, 120, 05, , PAD_LEFT,  )

	oPrintPvt:Box(nLinCabOrig, nCol10,nLinCabOrig+20, nCol17)
	oPrintPvt:SayAlign(nLinCabOrig, nCol10+3,  "Aprovada:", oFontDet, 80, 05, , PAD_LEFT,  )

	oPrintPvt:Box(nLinCabOrig, nCol17,nLinCabOrig+20, nCol24)
	oPrintPvt:SayAlign(nLinCabOrig, nCol17+3,  "Rejeitada:", oFontDet, 80, 05, , PAD_LEFT,  )

	
	oPrintPvt:Box(nLinCabOrig, nCol24,nLinCabOrig+20, nCol28)
	oPrintPvt:SayAlign(nLinCabOrig, nCol24+3,  "Program:", oFontDet, 80, 05, , PAD_LEFT,  )
	oPrintPvt:SayAlign(nLinCabOrig+7, nCol24+3, DTOC(QSC2->(C2_DATPRF)), oFontTitN, 80, 05, , PAD_CENTER,  )

	nLin := nLinCabOrig +=7
Return


/*---------------------------------------------------------------------*
 | Func:  fImpOpPai                                                    |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função que imprime o detalhe dos Produtos da OP              |
 *---------------------------------------------------------------------*/

Static Function fImpOpPai()

	oPrintPvt:Line(nLin, nCol01, nLin, nCol28)
	nLin += 5
	oPrintPvt:Box(nLin, nCol01,nLin+15, nCol28)
	oPrintPvt:SayAlign(nLin+2, nCol01,  "PRODUTO QUE A OP PERTENCE", oFontCabN, 540, 05, nCorAzul, PAD_CENTER,  )	
	nLin += 15

	oPrintPvt:Box(nLin, nCol01,nLin+15, nCol25)
	oPrintPvt:SayAlign(nLin+3, nCol01+3, Alltrim(SC2->(C2_PRODUTO)) + " - "+ Alltrim(SB1->(B1_DESC)), oFontDet, 480, 05,,PAD_LEFT)

	oPrintPvt:Box(nLin, nCol25,nLin+15, nCol28)
    oPrintPvt:Say(nLin+10,nCol25+3,alltrim(TRANSFORM(SC2->C2_QUANT, PesqPict("SC2","C2_QUANT"))) , oFontDet)	    
   
Return


/*---------------------------------------------------------------------*
 | Func:  fImpObs                                                      |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função que imprime a observação do processo da versão DPR    |
 *---------------------------------------------------------------------*/

Static Function fImpObs()
Local cobsor := ""
Local nPosOBS
Local nI, nXa

	nLin += 15

	//Vou fazer uma logica para zerar a matriz quando trocar de OP
	If QSC2->C2_NUM <> cOPAtu
		aOBS := {}
	EndIf	
	aOBS := {}
	//nPosOBS := aScan(aOBS,{|x| x[1]== Alltrim(QSC2->C2_X_OBS2)}) 
	//If nPosOBS == 0
	//	aAdd(aOBS,{Alltrim(QSC2->C2_X_OBS2)})
	//EndIf           

	For nI:=1 to Len(aOBS)
		cobsor += aOBS[nI][1] + CHR(13) + CHR(10)
	Next nPos
	cOPAtu := QSC2->C2_NUM
	//If !Empty(Alltrim(QSC2->C2_X_OBS2))
	//	cobsor := Rtrim(QSC2->C2_X_OBS2) 
	//	cObsTot += Rtrim(QSC2->C2_X_OBS2)
	//Else
	//	cobsor := cObsTot
	//EndIf
	nLinC := mlcount(cobsor,250,,.T.)

	//Título dados do Orçamento
	nLin += 5
	oPrintPvt:Line(nLin,   nCol01, nLin,   nCol28)
	nLin += 5
	oPrintPvt:Box(nLin, nCol01, nLin+15, nCol28)
	oPrintPvt:SayAlign(nLin+2, nCol01, "OBSERVAÇÕES", oFontCabN, 540, 05, , PAD_CENTER, )

	//Linha Separatório	
	nLin += 20
	oPrintPvt:Line(nLin,   nCol01, nLin,   nCol28)
	
	//nLin
	nQuebr := nLin
	For nXa := 1 To nLinC
		oPrintPvt:SayAlign(nQuebr,ncol01, MemoLine(cobsor,250,nXa,,.T.), oFontCabN, 540, 05, , PAD_LEFT,  )
		nQuebr += 10
	Next nXa	

	//nLin += 20
	nLin += 10 * nLinC
return

/*---------------------------------------------------------------------*
 | Func:  fImpProd                                                     |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função que imprime cabeçalho produtos OP                     |
 *---------------------------------------------------------------------*/

Static Function fImpProd()
	nLin += 15
	oPrintPvt:Line(nLin, nCol01, nLin, nCol28)
	nLin += 5
	oPrintPvt:Box(nLin, nCol01,nLin+15, nCol28)
	oPrintPvt:SayAlign(nLin+2, nCol01,  "ESTRUTURA DO ITEM", oFontCabN, 540, 05, , PAD_CENTER,  )	
	oPrintPvt:Box(nLin, nCol25,nLin+15, nCol28)
	
	nLin += 15
	oPrintPvt:Box(nLin, nCol01,nLin+15, nCol02)
	oPrintPvt:SayAlign(nLin+2, nCol01,  "TP", oFontCabN, 20, 05, , PAD_CENTER,  )

	oPrintPvt:Box(nLin, nCol02,nLin+15, nCol05)
	oPrintPvt:SayAlign(nLin+2, nCol02,  "CÓDIGO", oFontCabN, 60, 05, , PAD_CENTER,  )

	oPrintPvt:Box(nLin, nCol05,nLin+15, nCol24)
	oPrintPvt:SayAlign(nLin+2, nCol05,  "DESCRIÇÃO", oFontCabN, 380, 05, , PAD_CENTER,  )

	oPrintPvt:Box(nLin, nCol24,nLin+15, nCol25)
	oPrintPvt:SayAlign(nLin+2, nCol24,  "UN.", oFontCabN, 20, 05, , PAD_CENTER,  )

	oPrintPvt:Box(nLin, nCol25,nLin+15, nCol28)
	oPrintPvt:SayAlign(nLin+2, nCol25,  "QTD.", oFontCabN, 60, 05, , PAD_CENTER,  )

	nLin += 15
	
Return


/*---------------------------------------------------------------------*
 | Func:  fImpPDet                                                     |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função que imprime o detalhe dos Produtos da OP              |
 *---------------------------------------------------------------------*/

Static Function fImpPDet()

	oPrintPvt:Line(nLin, nCol01, nLin+15, nCol01)
	oPrintPvt:Say(nLin+10,nCol01+3, QSD4->B1_TIPO, oFontDet)

	oPrintPvt:Line(nLin, nCol02, nLin+15, nCol02)
	oPrintPvt:Line(nLin, nCol05, nLin+15, nCol05)
	oPrintPvt:Say(nLin+10, nCol02+3, QSD4->D4_COD, oFontDet)

	oPrintPvt:Line(nLin, nCol24, nLin+15, nCol24)
	oPrintPvt:Say(nLin+10,nCol05+3,Alltrim(QSD4->B1_DESC)+If(!Empty(QSD4->D4_LOTECTL)," - Lote:"+ QSD4->D4_LOTECTL,""), oFontDet)

	oPrintPvt:Line(nLin, nCol25, nLin+15, nCol25)
	oPrintPvt:Say(nLin+10,nCol24+3,QSD4->B1_UM, oFontDet)

	oPrintPvt:Line(nLin, nCol28, nLin+15, nCol28)	
    oPrintPvt:Say(nLin+10,nCol25+3,alltrim(TRANSFORM(QSD4->D4_QTDEORI, "@E 999,999,999.99")) , oFontDet)	    
    
    nLin += 15

Return

/*---------------------------------------------------------------------*
 | Func:  fImpRot                                                      |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função que imprime o Roteiro de Operação                     |
 *---------------------------------------------------------------------*/

Static Function fImpRot()

	oPrintPvt:Line(nLin, nCol01, nLin, nCol28)
	nLin +=10
	
	oPrintPvt:Line(nLin, nCol01, nLin, nCol28)
	nLin +=5
	oPrintPvt:Box(nLin, nCol01,nLin+15, nCol07)
	oPrintPvt:SayAlign(nLin+2, nCol01+3, "OP Nº: "+Alltrim (QSC2->(C2_NUM + C2_ITEM + C2_SEQUEN)), oFontTitN, 120, 05, , PAD_CENTER,  )

	oPrintPvt:Box(nLin, nCol07,nLin+15, nCol28)
	oPrintPvt:SayAlign(nLin+2, nCol07+3, "Produto: " + Alltrim(QSG2->G2_PRODUTO) + " - " + Substr(QSC2->(B1_DESC),1,80), oFontTitN, 400, 05, , PAD_LEFT)
	
	nLin +=15
	oPrintPvt:Box(nLin, nCol01,nLin+15, nCol10)
	oPrintPvt:SayAlign(nLin+3, nCol01+3, "PROCESSO:", oFontDet, 180, 05, , PAD_LEFT,  )
	oPrintPvt:SayAlign(nLin+2,nCol01+45, QSG2->G2_DESCRI, oFontTit1N, 180, 05, , PAD_LEFT, )
	
	oPrintPvt:Box(nLin, nCol10,nLin+15, nCol19)
	oPrintPvt:SayAlign(nLin+3, nCol10+3, "C.TRABALHO:", oFontDet, 100, 05, , PAD_LEFT,  )
	oPrintPvt:SayAlign(nLin+2,nCol10+50, IF(EMPTY(QSG2->HB_NOME),' ',QSG2->HB_NOME), oFontTit1N, 140, 05, , PAD_LEFT, )
	
	oPrintPvt:Box(nLin, nCol19,nLin+15, nCol28)
	oPrintPvt:SayAlign(nLin+3, nCol19+3, "RECURSO:", oFontDet, 100, 05, , PAD_LEFT,  )
	oPrintPvt:SayAlign(nLin+2,nCol19+45, IF(EMPTY(QSG2->H1_DESCRI),' ',QSG2->H1_DESCRI), oFontTit1N, 100, 05, , PAD_LEFT, )
	
	nLin +=15
	
	oPrintPvt:Box(nLin, nCol01,nLin+30, nCol03)
	oPrintPvt:SayAlign(nLin,nCol01, QSG2->G2_OPERAC, oFontRON, 40, 05, , PAD_CENTER, )
	
	oPrintPvt:Box(nLin, nCol03,nLin+30, nCol07)
	oPrintPvt:SayAlign(nLin+1, nCol03,  "Início(data/hora)", oFontDetN, 80, 05, , PAD_CENTER,  )
	
	oPrintPvt:Box(nLin, nCol07,nLin+30, nCol11)
	oPrintPvt:SayAlign(nLin+1, nCol07,  "Término (data/hora)", oFontDetN, 80, 05, , PAD_CENTER,  )
	
	oPrintPvt:Box(nLin, nCol11,nLin+30, nCol15)
	oPrintPvt:SayAlign(nLin+1, nCol11,  "Qt.Aprovada(C)", oFontDetN, 80, 05, , PAD_CENTER,  )
	
	oPrintPvt:Box(nLin, nCol15,nLin+30, nCol19)
	oPrintPvt:SayAlign(nLin+1, nCol15,  "Qt. Rejeitada(NC)", oFontDetN, 80, 05, , PAD_CENTER,  )

	oPrintPvt:Box(nLin, nCol19,nLin+30, nCol28)

	nLin +=30
	oPrintPvt:Box(nLin, nCol01,nLin+30, nCol28)

	// ajuste para a diferenca de numero de casas
	If len(QSC2->(C2_NUM + C2_ITEM + C2_SEQUEN)) == 11 
		cCode:=QSC2->(C2_NUM + C2_ITEM + C2_SEQUEN + "   ")+Alltrim(QSG2->G2_OPERAC)
	Else
		cCode:=QSC2->(C2_NUM + C2_ITEM + C2_SEQUEN)+Alltrim(QSG2->G2_OPERAC)
	EndIf
	ln:= 0.085 * nLin
	//oPrintPvt:FWMSBAR("CODE128" /*cTypeBar*/,ln/*nRow*/ ,35/*nCol*/ ,cCode  /*cCode*/,oPrintPvt/*oPrint*/,/*lCheck*/,/*Color*/,/*lHorz*/, 0.025/*nWidth*/,0.5/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)
	oPrintPvt:FWMSBAR("CODE128" /*cTypeBar*/,ln/*nRow*/ ,18/*nCol*/ ,cCode  /*cCode*/,oPrintPvt/*oPrint*/,/*lCheck*/,/*Color*/,/*lHorz*/, 0.025/*nWidth*/,0.5/*nHeigth*/,/*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)

	nLin +=30

Return


/*---------------------------------------------------------------------*
 | Func:  fImpRod                                                      |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função que imprime o rodapé                                  |
 *---------------------------------------------------------------------*/

Static Function fImpRod()
	Local nLinRod:= nLinFin + 10
	Local cTexto := ' '

	//Linha Separatória
	oPrintPvt:Line(nLinRod,   nColIni, nLinRod,   nColFin)
	nLinRod += 3
	
	//Dados da Esquerda
	cTexto := "Ordem de Produção N°: "+Alltrim(QSC2->(C2_NUM + C2_ITEM + C2_SEQUEN))+"    |    "+dToC(dDataBase)+"     "+cHoraEx+"     "+FunName()+"     "+cUserName
	oPrintPvt:SayAlign(nLinRod, nColIni, cTexto, oFontRod, 250, 05, , PAD_LEFT, )
	
	//Direita
	cTexto := "Página "+cValToChar(nPagAtu)
	oPrintPvt:SayAlign(nLinRod, nColFin-40, cTexto, oFontRod, 040, 05, , PAD_RIGHT, )
	
	//Finalizando a página e somando mais um
	oPrintPvt:EndPage()
	nPagAtu++

Return


/*---------------------------------------------------------------------*
 | Func:  fNewPage()                                                   |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função inicia uma nova pagina                                |
 *---------------------------------------------------------------------*/
Static Function fNewPage()
	nLin := 20
	oPrintPvt:StartPage()
Return
/*---------------------------------------------------------------------*
 | Func:  fLogoEmp                                                     |
 | Autor: Fabio Luiz Machado                                           |
 | Data:  20/04/2020                                                   |
 | Desc:  Função que retorna o logo da empresa (igual a DANFE)         |
 *---------------------------------------------------------------------*/

Static Function fLogoEmp()
	Local cGrpCompany	:= AllTrim(FWGrpCompany())
	Local cCodEmpGrp	:= AllTrim(FWCodEmp())
	Local cUnitGrp	:= AllTrim(FWUnitBusiness())
	Local cFilGrp		:= AllTrim(FWFilial())
	Local cLogo		:= ""
	Local cCamFim		:= GetTempPath()
	Local cStart		:= GetSrvProfString("Startpath","")

	//Se tiver filiais por grupo de empresas
	If !Empty(cUnitGrp)
		cDescLogo	:= cGrpCompany + cCodEmpGrp + cUnitGrp + cFilGrp
		
	//Senão, será apenas, empresa + filial
	Else
		cDescLogo	:= cEmpAnt + cFilAnt
	EndIf
	
	//Pega a imagem
	cLogo := GetSrvProfString("Startpath\","") + "lgrl01.bmp" //cStart + "DANFE" + cDescLogo + ".BMP"

	//Se o arquivo não existir, pega apenas o da empresa, desconsiderando a filial
	If !File(cLogo)
		cLogo	:= cStart + "DANFE" + cEmpAnt + ".BMP"
	EndIf
	
	//Copia para a temporária do s.o.
	CpyS2T(cLogo, cCamFim)
	cLogo := cCamFim + StrTran(cLogo, cStart, ' ')
	
	//Se o arquivo não existir na temporária, espera meio segundo para terminar a cópia
	If !File(cLogo)
		Sleep(500)
	EndIf
Return cLogo

Static Function Impresso()
	cSqlUPT := " UPDATE " +  retsqlname("SC2")
	cSqlUPT += " SET C2_X_IMP = '1'"
	cSqlUPT += " WHERE C2_NUM+C2_ITEM+C2_SEQUEN IN ("+MP_CONPAD+")"
	TCSQLEXEC (cSqlUPT)

Return()
