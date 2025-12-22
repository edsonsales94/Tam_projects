#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

User Function COELSFT()
//*************************************************************************
//³* Guarda Ambiente Original
//*************************************************************************
	Local aPergs   := {}
	LOCAL _cFilial := ''
	Local cDocDe  := Space(TamSX3("F2_DOC")[01])
	Local cDocAte  := Space(TamSX3("F2_DOC")[01])
	Local cSerDe  := Space(TamSX3("F2_SERIE")[01])
	Local cSerAte  := Space(TamSX3("F2_SERIE")[01])
	Local dDataDe  := FirstDate(Date())
	Local dDataAt  := LastDate(Date())
	Private aNotas   := {}

	_cFilial := '01'
	cDocAte := 'ZZZZZZZZZ'
	cSerAte := 'ZZZ'

	_nRecno := RECNO()
	_nOrdem := INDEXORD()

	aAdd(aPergs, {1, "Filial",    _cFilial,	"", ".T.", "SFT" , ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Data De",   dDataDe,	"", ".T.", "   " , ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Data Até",  dDataAt,  "", ".T.", "   " , ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Nota De",   cDocDe,	"", ".T.", "SF2" , ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Nota Até",  cDocAte,  "", ".T.", "SF2" , ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Serie De",  cSerDe,	"", ".T.", "SF2" , ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Serie Até", cSerAte,	"", ".T.", "SF2" , ".T.", 80,  .T.})

	If ParamBox(aPergs, "Informe os parâmetros")
		Processa({|| fProce01()}, "Processando...")
	endif

Return

/*/
/*/
Static Function fProce01()
	Local cQry := ''
	Local cStrSql := ""
	Local _cAlias := GETNEXTALIAS()
	// beginSql Alias _cAlias
	cQry += "  select FT_NFISCAL NF, FT_SERIE SERIE,FT_PRODUTO,FT_TOTAL,FT_VALCONT "
	cQry += "	 FROM "+RetSQLName("SFT") + " SFT (NOLOCK)"
	cQry += "  WHERE SFT.D_E_L_E_T_ = '' AND FT_FILIAL='"+MV_PAR01 +"'"
	cQry += "  AND FT_ENTRADA BETWEEN '"+DTOS(MV_PAR02) +"' AND '" +DTOS(MV_PAR03) +"'"
	cQry += "  AND FT_NFISCAL BETWEEN '"+MV_PAR04 +"' AND '" +MV_PAR05 +"'"
	cQry += "  AND FT_SERIE BETWEEN '"+MV_PAR06 +"' AND '" +MV_PAR07 +"'"
	cQry += "  AND FT_TIPOMOV = 'S' AND FT_TOTAL != FT_VALCONT "
	// ENDSQL
	//Executando consulta e setando o total da regua
	PlsQuery(cQry, _cAlias)
	Count to nTotal
	DbSelectArea(_cAlias)
	(_cAlias)->(DBGOTOP())
	 
	// se clicar em não entra na condição e retorna.
	if !FWAlertYesNo('As alterações das notas serão efetuadas na empresa '+CEMPANT+ ', Filial '+MV_PAR01 +'. Deseja Continuar ?', 'Atenção !!!')
		Return
	endif

	while !(_cAlias)->(EOF())
		cStrSql := "UPDATE "+ RETSQLNAME("SFT")
		cStrSql += " SET FT_TOTAL = FT_VALCONT , FT_DESCONT = 0  "
		cStrSql += " WHERE FT_NFISCAL+FT_SERIE = '" + (_cAlias)->(NF) + (_cAlias)->(SERIE) +"' AND FT_TIPOMOV = 'S'  AND D_E_L_E_T_ = ''  "
		cStrSql += " AND FT_PRODUTO ='"+(_cAlias)->(FT_PRODUTO) +"'"

		nErro := TCSQLEXEC(cStrSql)
		if nErro == 0
			aAdd(aNotas,{(_cAlias)->(NF),(_cAlias)->(SERIE),(_cAlias)->(FT_TOTAL),(_cAlias)->(FT_VALCONT)})
		else
			Alert('não foi possivel alterar a nota '+(_cAlias)->(NF))
		endif
		(_cAlias)->(DbSkip())
	Enddo

	if len(aNotas) >0
		fLogSft()
	endif

Return
Static Function fLogSft()
	Local aArea        := GetArea()
	Local oExcel
	Local cArquivo    := GetTempPath()+'LOGSFT.xml'
	Local oFWMsExcel
	Local NX := 0

	//Criando o objeto que irá gerar o conteúdo do Excel
	oFWMsExcel := FWMSExcel():New()

	//Aba 01 - Notas que foram alteradas - FT_TOTAL
	oFWMsExcel:AddworkSheet("Log Alteracao")
	//Criando a Tabela
	oFWMsExcel:AddTable("Log Alteracao","Notas que foram alteradas - Empresa: " +CEMPANT +' / Filial '+MV_PAR01 )
	oFWMsExcel:AddColumn("Log Alteracao","Notas que foram alteradas - Empresa: " +CEMPANT +' / Filial '+MV_PAR01 ,"Nota",1)
	oFWMsExcel:AddColumn("Log Alteracao","Notas que foram alteradas - Empresa: " +CEMPANT +' / Filial '+MV_PAR01 ,"Serie",1)
	oFWMsExcel:AddColumn("Log Alteracao","Notas que foram alteradas - Empresa: " +CEMPANT +' / Filial '+MV_PAR01 ,"Total antes",1)
	oFWMsExcel:AddColumn("Log Alteracao","Notas que foram alteradas - Empresa: " +CEMPANT +' / Filial '+MV_PAR01 ,"Total Atual",1)
	//Criando as Linhas... Enquanto não for fim da query

	for NX := 1 to len(aNotas)

		oFWMsExcel:AddRow("Log Alteracao","Notas que foram alteradas - Empresa: " +CEMPANT +' / Filial '+MV_PAR01 ,{;
			aNotas[nx,1],;
			aNotas[nx,2],;
			aNotas[nx,3],;
			aNotas[nx,4];
			})
	next

	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
	oExcel:SetVisible(.T.)                 //Visualiza a planilha
	oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
	RestArea(aArea)
Return
