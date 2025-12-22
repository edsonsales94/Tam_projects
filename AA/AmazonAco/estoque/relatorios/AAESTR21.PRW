#include "rwmake.ch" 
#INCLUDE "protheus.ch"

/*/{Protheus.doc} User Function AAESTR21
    Kardex Unificado
    @type  Function
    @author Raphael Rage
    @since 13/11/2023
/*/
User Function AAESTR21(param_name)
    Local aPergs := {}
    Local dDataDe  	:= ctod("01/10/2023")
	Local dDataAt  	:= ctod("31/10/2023")
    Local cFilIni   := "  "
    Local cFilFim   := "ZZ"

    aAdd(aPergs, {1, "Data De"   , dDataDe,  "", ".T.", "" , ".T.", 80, .T.})
	aAdd(aPergs, {1, "Data Até"  , dDataAt,  "", ".T.", "" , ".T.", 80, .T.})
    aAdd(aPergs, {1, "Filial De" , cFilIni,  "", ".T.", "" , ".T.", 80, .T.})
	aAdd(aPergs, {1, "Filial Até", cFilFim,  "", ".T.", "" , ".T.", 80, .T.})
    
    If ParamBox(aPergs, "Informe os parâmetros")
        MSGRUN( 'Emitindo relatório...', 'Aguarde', {||PrintRelat(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04)} )
    EndIf  

Return

/*/{Protheus.doc} PrintRelat
    Imprime planilha.
    @type  Static Function
    @author Raphael Rage
    @since 23/03/2023
/*/
Static Function PrintRelat(dDtIni,dDtFim,cFilIni,cFilFim)
    Local cDataIni := ""
    Local cDataFim := ""
    Local cDataSB9 := ""

    Local nI       := Nil
    Local nX       := Nil

    Local cFileName      := "AAESTR21-"+Dtos(MSDate())+"-"+StrTran(Time(),":","")
    Local cPathInServer  := GETTEMPPATH()+cFileName+".xls"
    Local cGuia          := ""
    Local cTabela        := ""

    Private _pvtColunas  := {}
    Private _pvtItens    := {}
    Private _pvtTipos    := {}
    Private _pvtColCons  := {}
    Private _pvtPosPrd   := 0
    Private _pvtPosVen   := 0
    //define os dias
    cDataIni := dtos(dDtIni)
    cDataFim := dtos(dDtFim)

    _pvtTipos := defTipos(cDataIni,cDataFim,cFilIni,cFilFim)

    aAdd(_pvtColunas,{"FILIAL"       ,"C","SB9"})
    aAdd(_pvtColunas,{"MODELO"       ,"C","SB9"})
    aAdd(_pvtColunas,{"SI QTD"       ,"N","SB9"})
    aAdd(_pvtColunas,{"SI VLR"       ,"N","SB9"})
    
    aAdd(_pvtColunas,{"ENTRADA - QTD","N","SD3E"})
    _pvtPosPrd := len(_pvtColunas)

    aAdd(_pvtColunas,{"ENTRADA-VLR"  ,"N","SD3E"})
    
    aAdd(_pvtColunas,{"SAIDA-QTD"    ,"N","SD3S"})
    aAdd(_pvtColunas,{"SAIDA-VLR"    ,"N","SD3S"})

    aEval( _pvtTipos , {|x| aAdd( _pvtColunas , {x , "N", "CNS"} ) } )

    aAdd(_pvtColunas,{"QTD VENDAS"   ,"N" , "SD2"})
    _pvtPosVen := len(_pvtColunas)

    aAdd(_pvtColunas,{"CUSTO UNIT"   ,"N" , "SD2"})
    aAdd(_pvtColunas,{"CPV"          ,"N" , "SD2"})
    aAdd(_pvtColunas,{"VALOR VENDAS" ,"N" , "SD2"})

    aAdd(_pvtColunas,{"DEV QTD"      ,"N" , "DEV"})
    aAdd(_pvtColunas,{"DEV VLR"      ,"N" , "DEV"})
        
    //define filtros query
    SetB9Dt(@cDataSB9,cDataIni)

    SaldoInicial(cDataSB9,cDataIni,cDataFim,cFilIni,cFilFim)

    movSD3(cDataIni,cDataFim,cFilIni,cFilFim,.F.)

    movSD3(cDataIni,cDataFim,cFilIni,cFilFim,.T.)

    movPROD(cDataIni,cDataFim,cFilIni,cFilFim)

    movSD2(cDataIni,cDataFim,cFilIni,cFilFim,.F.)

    movSD1(cDataIni,cDataFim,cFilIni,cFilFim,.T.)

    cGuia     := "MOV-ANALITICO"
    cTabela   := "MOV-ANALITICO - "+" Período: "+dtoc(stod(cDataIni))+" - "+dtoc(stod(cDataFim))

    //Gera arquivo excel
    oFWMsExcel := FWMSExcel():New()
    oFWMsExcel:AddworkSheet(cGuia)

    oFWMsExcel:AddTable(cGuia,cTabela)

    For nI := 1 to len(_pvtColunas)
        If _pvtColunas[nI,2] == "N"
            oFWMsExcel:AddColumn(cGuia,cTabela,_pvtColunas[nI,1],1,2)
        ElseIf _pvtColunas[nI,2] == "D"
            oFWMsExcel:AddColumn(cGuia,cTabela,dtoc(_pvtColunas[nI,1]),1,2)
        Else
            oFWMsExcel:AddColumn(cGuia,cTabela,_pvtColunas[nI,1],1,1)
        EndIf
    Next nI

    For nI := 1 to len(_pvtItens)
        //exibe somente                             itens que tiveram producao ou venda
        If (_pvtItens[nI,_pvtPosPrd] + _pvtItens[nI,_pvtPosVen] ) <> 0
            aItem := {}
            For nX := 1 to len(_pvtColunas)
                aAdd(aItem,_pvtItens[nI,nX])
            Next nI
            oFWMsExcel:AddRow(cGuia,cTabela,aItem)
        EndIf
    next nI

    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cPathInServer)
        
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()            
    oExcel:WorkBooks:Open(cPathInServer)     
    oExcel:SetVisible(.T.)               
    oExcel:Destroy() 

Return

/*/{Protheus.doc} SetB9Dt
    Define a data inicial da consulta.
    @type  Static Function
    @author Raphael Rage
	@since 23/03/2023
/*/
Static Function SetB9Dt(cB9Data,cDtIni)
    Local cAlias := GetNextAlias()

    //busca o ultimo fechamento anterior ao período informado
    //nao valida filial pois todas sao fechadas com a mesma data
    BeginSql Alias cAlias
        SELECT MAX(B9_DATA) B9_DATA FROM %TABLE:SB9% SB9 
        WHERE 
            SB9.%NOTDEL% 
            AND B9_DATA < %Exp:cDtIni% 
    EndSql

    If !(cAlias)->(EOF())
        cB9Data := (cAlias)->B9_DATA
    EndIf

    (cAlias)->(DbCloseArea())
Return

Static Function SaldoInicial(cDataSB9,cDataIni,cDataFim,cFilIni,cFilFim)
    Local cQry1    := ""
    Local cQry2    := ""
    Local cLocProc := GetMv("MV_LOCPROC",.F.,"03")
    Local cAlias   := GetNextAlias()

    cQry1 += " SELECT "
    cQry1 += " 'SB9' AS ORIGEM "
    cQry1 += " ,B9_FILIAL "
    cQry1 += " ,B1_TIPO "
    cQry1 += " ,B9_LOCAL "
    cQry1 += " ,CASE WHEN B9_LOCAL = @LOCPROC THEN 'PROCESSO' ELSE 'EM ESTOQUE' END AS OPERACAO "
    cQry1 += " ,'' AS B9_TES "
    cQry1 += " ,'' AS B9_CF "
    cQry1 += " ,'' AS B9_ITEM "
    cQry1 += " ,B9_COD "
    cQry1 += " ,B9_DATA AS B9_DOC "
    cQry1 += " ,'' AS B9_SERIE "
    cQry1 += " ,B9_QINI "
    cQry1 += " ,B9_VINI1 "
    cQry1 += " ,SB9.R_E_C_N_O_ "
    cQry1 += " FROM "+RetSqlName("SB9")+" SB9 "
    cQry1 += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
    cQry1 += " ON B9_COD = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND LEFT(B1_FILIAL,LEN(B1_FILIAL)) = LEFT(B9_FILIAL,LEN(B1_FILIAL)) "
    cQry1 += " INNER JOIN "+RetSqlName("NNR")+" NNR "
    cQry1 += " ON NNR.NNR_CODIGO = B9_LOCAL AND NNR.D_E_L_E_T_ = ' ' AND LEFT(NNR_FILIAL,LEN(NNR_FILIAL)) = LEFT(B9_FILIAL,LEN(NNR_FILIAL)) "
    cQry1 += " WHERE SB9.D_E_L_E_T_ = ' ' "
    cQry1 += " AND SB9.B9_DATA = @DTINI AND B1_TIPO IN ('PI','PA') AND B1_MSBLQL <> '1'"

    if Abs( DateDiffDay( stod(cDataSB9),stod(cDataIni) ) ) > 1
        QryMovimentos(@cQry1,cDataIni,cDataFim)
    endif

    cQry1 := Replace(cQry1,"@LOCPROC","'" + cLocProc+ "'")
    cQry1 := Replace(cQry1,"@FILINI" ,"'" + cFilIni + "'")
    cQry1 := Replace(cQry1,"@FILFIM" ,"'" + cFilFim + "'")
    cQry1 := Replace(cQry1,"@DTINI"  ,"'" + cDataSB9 + "'")

    cQry2 := " SELECT B9_COD,SUM(B9_VINI1) AS VLINI,SUM(B9_QINI) AS QTINI, B9_FILIAL FROM ("
    cQry2 += cQry1
    cQry2 += ") AS RESULT GROUP BY B9_COD,B9_FILIAL"

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry2), cAlias, .F., .T.)
    While !(cAlias)->(eof())
        CriaVazio()

        nPos := len(_pvtItens)
        
        _pvtItens[nPos,1] := (cAlias)->B9_FILIAL
        _pvtItens[nPos,2] := (cAlias)->B9_COD
        _pvtItens[nPos,3] := (cAlias)->QTINI
        _pvtItens[nPos,4] := (cAlias)->VLINI  
        
        (cAlias)->(dbSkip())
    enddo

Return

Static Function movSD1(cDataIni,cDataFim,cFilIni,cFilFim,lDevolucao)
    Local cQry1    := ""
    Local cQry2    := ""
    Local cLocProc := GetMv("MV_LOCPROC",.F.,"03")
    Local cAlias   := GetNextAlias()
    Local nPosSD1  := Ascan(_pvtColunas,{|x| x[3] == iif(lDevolucao,'DEV','SD1')})

    cQry1 += " SELECT "
    cQry1 += " 'SD1' AS ORIGEM "
    cQry1 += " ,D1_FILIAL "
    cQry1 += " ,B1_TIPO "
    cQry1 += " ,D1_LOCAL "
    cQry1 += " ,CASE WHEN D1_LOCAL = @LOCPROC THEN 'PROCESSO' ELSE 'EM ESTOQUE' END AS OPERACAO "
    cQry1 += " ,'' AS D1_TES "
    cQry1 += " ,'' AS D1_CF "
    cQry1 += " ,'' AS D1_ITEM "
    cQry1 += " ,D1_COD "
    cQry1 += " ,D1_DTDIGIT AS D1_DOC "
    cQry1 += " ,'' AS D1_SERIE "
    cQry1 += " ,D1_QUANT "
    cQry1 += " ,D1_CUSTO "
    cQry1 += " ,SD1.R_E_C_N_O_ "
    cQry1 += " FROM "+RetSqlName("SD1")+" SD1 "
    cQry1 += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
    cQry1 += " ON D1_COD = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND LEFT(B1_FILIAL,LEN(B1_FILIAL)) = LEFT(D1_FILIAL,LEN(B1_FILIAL)) "
    cQry1 += " INNER JOIN "+RetSqlName("NNR")+" NNR "
    cQry1 += " ON NNR.NNR_CODIGO = D1_LOCAL AND NNR.D_E_L_E_T_ = ' ' AND LEFT(NNR_FILIAL,LEN(NNR_FILIAL)) = LEFT(D1_FILIAL,LEN(NNR_FILIAL)) "
    cQry1 += " INNER JOIN "+RetSqlName("SF4")+" SF4  ON SF4.F4_CODIGO = SD1.D1_TES AND SF4.D_E_L_E_T_ = '' AND LEFT(F4_FILIAL,LEN(F4_FILIAL)) = LEFT(D1_FILIAL,LEN(F4_FILIAL)) "
    cQry1 += " WHERE SD1.D_E_L_E_T_ = ' ' AND F4_ESTOQUE = 'S' "
    cQry1 += " AND SD1.D1_DTDIGIT between @DTINI and @DTFIM AND B1_TIPO IN ('PI','PA') AND B1_MSBLQL <> '1'"
    cQry1 += " AND SD1.D1_FILIAL BETWEEN @FILINI AND @FILFIM"

    If lDevolucao
        cQry1 += " AND D1_NFORI <> '' "
    Else
        cQry1 += " AND D1_NFORI = '' "
    EndIf

    cQry1 := Replace(cQry1,"@LOCPROC","'" + cLocProc+ "'")
    cQry1 := Replace(cQry1,"@FILINI" ,"'" + cFilIni + "'")
    cQry1 := Replace(cQry1,"@FILFIM" ,"'" + cFilFim + "'")
    cQry1 := Replace(cQry1,"@DTINI"  ,"'" + cDataIni + "'")
    cQry1 := Replace(cQry1,"@DTFIM"  ,"'" + cDataFim + "'")

    cQry2 := " SELECT D1_COD,SUM(D1_CUSTO) AS D1_CUSTO,SUM(D1_QUANT) AS D1_QUANT,D1_FILIAL FROM ("
    cQry2 += cQry1
    cQry2 += ") AS RESULT GROUP BY D1_COD,D1_FILIAL"

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry2), cAlias, .F., .T.)
    While !(cAlias)->(eof())
        nPos := Ascan(_pvtItens,{|x| x[1]+x[2] == (cAlias)->D1_FILIAL+(cAlias)->D1_COD })
        if nPos == 0
            CriaVazio()
            nPos := len(_pvtItens)
            _pvtItens[nPos,1] := (cAlias)->D1_FILIAL
            _pvtItens[nPos,2] := (cAlias)->D1_COD
        endif
        
        _pvtItens[nPos,nPosSD1]   := (cAlias)->D1_QUANT
        _pvtItens[nPos,nPosSD1+1] := (cAlias)->D1_CUSTO
        
        (cAlias)->(dbSkip())
    enddo

Return

Static Function movSD3(cDataIni,cDataFim,cFilIni,cFilFim,lSaida)
    Local cQry1    := ""
    Local cQry2    := ""
    Local cLocProc := GetMv("MV_LOCPROC",.F.,"03")
    Local cAlias   := GetNextAlias()
    Local nPosSD3  := Ascan( _pvtColunas , {|x| x[3] == iif(lsaida,'SD3S','SD3E') })

    cQry1 += " SELECT "
    cQry1 += " 'SD3' AS ORIGEM "
    cQry1 += " ,D3_FILIAL "
    cQry1 += " ,B1_TIPO "
    cQry1 += " ,D3_LOCAL "
    cQry1 += " ,CASE WHEN D3_LOCAL = @LOCPROC THEN 'PROCESSO' ELSE 'EM ESTOQUE' END AS OPERACAO "
    cQry1 += " ,'' AS D3_TES "
    cQry1 += " ,'' AS D3_CF "
    cQry1 += " ,'' AS D3_ITEM "
    cQry1 += " ,D3_COD "
    cQry1 += " ,D3_EMISSAO AS D3_DOC "
    cQry1 += " ,'' AS D3_SERIE "
    cQry1 += " ,D3_QUANT "
    cQry1 += " ,D3_CUSTO1 "
    cQry1 += " ,SD3.R_E_C_N_O_ "
    cQry1 += " FROM "+RetSqlName("SD3")+" SD3 "
    cQry1 += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
    cQry1 += " ON D3_COD = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND LEFT(B1_FILIAL,LEN(B1_FILIAL)) = LEFT(D3_FILIAL,LEN(B1_FILIAL)) "
    cQry1 += " INNER JOIN "+RetSqlName("NNR")+" NNR "
    cQry1 += " ON NNR.NNR_CODIGO = D3_LOCAL AND NNR.D_E_L_E_T_ = ' ' AND LEFT(NNR_FILIAL,LEN(NNR_FILIAL)) = LEFT(D3_FILIAL,LEN(NNR_FILIAL)) "
    cQry1 += " WHERE SD3.D_E_L_E_T_ = ' ' AND D3_ESTORNO = '' "
    cQry1 += " AND SD3.D3_EMISSAO BETWEEN @DTINI AND @DTFIM AND B1_TIPO IN ('PI','PA') AND B1_MSBLQL <> '1'"
    cQry1 += " AND SD3.D3_FILIAL BETWEEN @FILINI AND @FILFIM"

    If lSaida
        cQry1 += " AND D3_TM > '500' AND D3_CF NOT IN ('RE4','RE3') "
    Else
        cQry1 += " AND D3_TM <= '500' AND D3_CF NOT IN ('DE4','DE3') "
    EndIf

    cQry1 := Replace(cQry1,"@LOCPROC","'" + cLocProc + "'")
    cQry1 := Replace(cQry1,"@FILINI" ,"'" + cFilIni  + "'")
    cQry1 := Replace(cQry1,"@FILFIM" ,"'" + cFilFim  + "'")
    cQry1 := Replace(cQry1,"@DTINI"  ,"'" + cDataIni + "'")
    cQry1 := Replace(cQry1,"@DTFIM"  ,"'" + cDataFim + "'")

    cQry2 := " SELECT D3_COD,SUM(D3_CUSTO1) AS D3_CUSTO,SUM(D3_QUANT) AS D3_QUANT,D3_FILIAL FROM ("
    cQry2 += cQry1
    cQry2 += ") AS RESULT GROUP BY D3_COD,D3_FILIAL"

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry2), cAlias, .F., .T.)
    While !(cAlias)->(eof())
        nPos := Ascan(_pvtItens,{|x| x[1]+x[2] == (cAlias)->D3_FILIAL+(cAlias)->D3_COD })
        if nPos == 0
            CriaVazio()
            nPos := len(_pvtItens)
            _pvtItens[nPos,1] := (cAlias)->D3_FILIAL
            _pvtItens[nPos,2] := (cAlias)->D3_COD
        endif

        _pvtItens[nPos,nPosSD3]   := (cAlias)->D3_QUANT
        _pvtItens[nPos,nPosSD3+1] := (cAlias)->D3_CUSTO

        (cAlias)->(dbSkip())
    enddo

Return

Static Function movPROD(cDataIni,cDataFim,cFilIni,cFilFim)
    Local cQry1    := ""
    Local cQry2    := ""
    Local cLocProc := GetMv("MV_LOCPROC",.F.,"03")
    Local cAlias   := GetNextAlias()
    Local nI       := Nil
    Local nPosCNS  := Ascan(_pvtColunas,{|x| x[3] == 'CNS'})

    cQry1 += " SELECT "
    cQry1 += " 'SD3' AS ORIGEM "
    cQry1 += " ,D3_FILIAL "
    cQry1 += " ,CASE WHEN B1_TIPO = 'MO' THEN D3_COD ELSE B1_TIPO END AS B1_TIPO  "
    cQry1 += " ,D3_LOCAL "
    cQry1 += " ,CASE WHEN D3_LOCAL = @LOCPROC THEN 'PROCESSO' ELSE 'EM ESTOQUE' END AS OPERACAO "
    cQry1 += " ,'' AS D3_TES "
    cQry1 += " ,'' AS D3_CF "
    cQry1 += " ,'' AS D3_ITEM "
    cQry1 += " ,D3_COD "
    cQry1 += " ,D3_EMISSAO AS D3_DOC "
    cQry1 += " ,'' AS D3_SERIE "
    cQry1 += " ,D3_QUANT "
    cQry1 += " ,D3_CUSTO1 "
    cQry1 += " ,SD3.R_E_C_N_O_ "
    cQry1 += " ,SC2.C2_PRODUTO "
    cQry1 += " FROM "+RetSqlName("SD3")+" SD3 "
    cQry1 += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
    cQry1 += " ON D3_COD = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND LEFT(B1_FILIAL,LEN(B1_FILIAL)) = LEFT(D3_FILIAL,LEN(B1_FILIAL)) "
    cQry1 += " INNER JOIN "+RetSqlName("SC2")+" SC2 "
    cQry1 += " ON C2_NUM+C2_ITEM+C2_SEQUEN = D3_OP AND SC2.D_E_L_E_T_ = ' ' AND LEFT(C2_FILIAL,LEN(C2_FILIAL)) = LEFT(D3_FILIAL,LEN(C2_FILIAL)) "
    cQry1 += " INNER JOIN "+RetSqlName("NNR")+" NNR "
    cQry1 += " ON NNR.NNR_CODIGO = D3_LOCAL AND NNR.D_E_L_E_T_ = ' ' AND LEFT(NNR_FILIAL,LEN(NNR_FILIAL)) = LEFT(D3_FILIAL,LEN(NNR_FILIAL)) "
    cQry1 += " WHERE SD3.D_E_L_E_T_ = ' ' AND D3_ESTORNO = '' "
    cQry1 += " AND SD3.D3_EMISSAO BETWEEN @DTINI AND @DTFIM  AND B1_MSBLQL <> '1'"
    cQry1 += " AND D3_TM > '500' AND D3_OP <> '' "
    cQry1 += " AND SD3.D3_FILIAL BETWEEN @FILINI AND @FILFIM"

    cQry1 := Replace(cQry1,"@LOCPROC","'" + cLocProc + "'")
    cQry1 := Replace(cQry1,"@FILINI" ,"'" + cFilIni  + "'")
    cQry1 := Replace(cQry1,"@FILFIM" ,"'" + cFilFim  + "'")
    cQry1 := Replace(cQry1,"@DTINI"  ,"'" + cDataIni + "'")
    cQry1 := Replace(cQry1,"@DTFIM"  ,"'" + cDataFim + "'")

    cQry2 := " SELECT C2_PRODUTO,D3_FILIAL"
    aEval( _pvtTipos , {|x| cQry2 += ", SUM(["+x+"]) AS " + x })
    cQry2 += " FROM ("
    cQry2 += cQry1
    cQry2 += "	) P"
    cQry2 += "	PIVOT"
    cQry2 += "	("
    cQry2 += "		SUM(P.D3_CUSTO1)"
    cQry2 += "		FOR P.B1_TIPO IN ( "
    aEval( _pvtTipos , {|x| cQry2 += "["+x+"], " })
    cQry2 := SubStr(cQry2,1,Len(cQry2)-2)
    cQry2 += " ) ) AS X GROUP BY C2_PRODUTO,D3_FILIAL"

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry2), cAlias, .F., .T.)

    _pvtColCons := DbStruct()
    While !(cAlias)->(eof())
        nPos := Ascan(_pvtItens,{|x| x[1]+x[2] == (cAlias)->D3_FILIAL+(cAlias)->C2_PRODUTO })
        if nPos == 0
            CriaVazio()
            nPos := len(_pvtItens)
            _pvtItens[nPos,1] := (cAlias)->D3_FILIAL
            _pvtItens[nPos,2] := (cAlias)->C2_PRODUTO
        endif

        nPosCol := 0
        //COMECA NA POSICAO 3 para ignorar as colunas D3_FILIAL,C2_PRODUTO
        For nI := 3 to len(_pvtColCons)
            _pvtItens[nPos,nPosCNS+nPosCol] := (cAlias)->&(_pvtColCons[nI,1]) 
            nPosCol++
        Next nI

        (cAlias)->(dbSkip())
    enddo

Return

Static Function defTipos(cDataIni,cDataFim,cFilIni,cFilFim)
    Local _pvtTipos := {}
    Local cQry := ""
	
    cQry := "SELECT DISTINCT CASE WHEN B1_TIPO <> 'MO' THEN SB1.B1_TIPO ELSE B1_COD END AS B1_COD"
	
    cQry += ",CASE	"
	cQry += "	WHEN B1_TIPO = 'EM' THEN 1 "
	cQry += " WHEN B1_TIPO = 'MI' THEN 2 "
	cQry += "	WHEN B1_TIPO  = 'MP' THEN 3 "
	cQry += "	WHEN B1_TIPO = 'MO' THEN 4 "
	cQry += "	WHEN B1_TIPO  = 'PI' THEN 5 "
	cQry += "	ELSE 6 "
	cQry += "	END AS PRIORIDADE "
    
    cQry += " FROM "+RetSQLName("SD3")+" SD3"
    cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
    cQry += " ON D3_COD = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND LEFT(B1_FILIAL,LEN(B1_FILIAL)) = LEFT(D3_FILIAL,LEN(B1_FILIAL)) "
	cQry += " WHERE SD3.D_E_L_E_T_ = ' '"
	cQry += " AND SD3.D3_TM > '500'"
	cQry += " AND SD3.D3_EMISSAO BETWEEN @DTINI AND @DTFIM AND B1_MSBLQL <> '1'"
	cQry += " AND SD3.D3_FILIAL BETWEEN @FILINI AND @FILFIM"
	cQry += " AND SD3.D3_CF <> 'RE9' AND D3_OP <> ''"
	cQry += " ORDER BY 2,1"

    cQry := Replace(cQry,"@FILINI" ,"'" + cFilIni  + "'")
    cQry := Replace(cQry,"@FILFIM" ,"'" + cFilFim  + "'")
    cQry := Replace(cQry,"@DTINI"  ,"'" + cDataIni + "'")
    cQry := Replace(cQry,"@DTFIM"  ,"'" + cDataFim + "'")

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"QRY",.T.,.T.)
	
    CTT->(DbSetOrder(1))
    While !QRY->(Eof())
		If QRY->B1_COD == "MO"
            IF CTT->(dbSeek(xFilial("CTT")+Rtrim(Replace(QRY->B1_COD,"MOD",""))))
                Add( _pvtTipos , Alltrim(QRY->CTT_DESC01) )
            Else
                Add( _pvtTipos , alltrim(QRY->B1_COD) )
            EndIf
		Else
            AAdd( _pvtTipos , alltrim(QRY->B1_COD) )
		Endif
		QRY->(dbSkip())
	Enddo
	QRY->(dbCloseArea())

Return _pvtTipos

Static Function movSD2(cDataIni,cDataFim,cFilIni,cFilFim,lDevolucao)
    Local cQry1    := ""
    Local cQry2    := ""
    Local cLocProc := GetMv("MV_LOCPROC",.F.,"03")
    Local cAlias   := GetNextAlias()
    Local nPosSD2  := Ascan(_pvtColunas,{|x| x[3] == 'SD2'})

    cQry1 += " SELECT "
    cQry1 += " 'SD2' AS ORIGEM "
    cQry1 += " ,D2_FILIAL "
    cQry1 += " ,B1_TIPO "
    cQry1 += " ,D2_LOCAL "
    cQry1 += " ,CASE WHEN D2_LOCAL = @LOCPROC THEN 'PROCESSO' ELSE 'EM ESTOQUE' END AS OPERACAO "
    cQry1 += " ,'' AS D2_TES "
    cQry1 += " ,'' AS D2_CF "
    cQry1 += " ,'' AS D2_ITEM "
    cQry1 += " ,D2_COD "
    cQry1 += " ,D2_EMISSAO AS D2_DOC "
    cQry1 += " ,'' AS D2_SERIE "
    cQry1 += " ,D2_QUANT "
    cQry1 += " ,D2_CUSTO1 "
    cQry1 += " ,D2_TOTAL "
    cQry1 += " ,SD2.R_E_C_N_O_ "
    cQry1 += " FROM "+RetSqlName("SD2")+" SD2 "
    cQry1 += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
    cQry1 += " ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND LEFT(B1_FILIAL,LEN(B1_FILIAL)) = LEFT(D2_FILIAL,LEN(B1_FILIAL)) "
    cQry1 += " INNER JOIN "+RetSqlName("NNR")+" NNR "
    cQry1 += " ON NNR.NNR_CODIGO = D2_LOCAL AND NNR.D_E_L_E_T_ = ' ' AND LEFT(NNR_FILIAL,LEN(NNR_FILIAL)) = LEFT(D2_FILIAL,LEN(NNR_FILIAL)) "
    cQry1 += " INNER JOIN "+RetSqlName("SF4")+" SF4  ON SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ = '' AND LEFT(F4_FILIAL,LEN(F4_FILIAL)) = LEFT(D2_FILIAL,LEN(F4_FILIAL)) "
    cQry1 += " WHERE SD2.D_E_L_E_T_ = ' ' AND F4_ESTOQUE = 'S' "
    cQry1 += " AND SD2.D2_EMISSAO BETWEEN @DTINI AND @DTFIM AND B1_TIPO IN ('PI','PA') AND B1_MSBLQL <> '1'"
    cQry1 += " AND SD2.D2_FILIAL BETWEEN @FILINI AND @FILFIM"

    If lDevolucao
        cQry1 += " AND D2_NFORI <> '' "
    Else
        cQry1 += " AND D2_NFORI = '' "
    EndIf

    cQry1 := Replace(cQry1,"@LOCPROC","'" + cLocProc+ "'")
    cQry1 := Replace(cQry1,"@FILINI" ,"'" + cFilIni + "'")
    cQry1 := Replace(cQry1,"@FILFIM" ,"'" + cFilFim + "'")
    cQry1 := Replace(cQry1,"@DTINI"  ,"'" + cDataIni + "'")
    cQry1 := Replace(cQry1,"@DTFIM"  ,"'" + cDataFim + "'")

    cQry2 := " SELECT D2_COD,SUM(D2_CUSTO1) AS D2_CUSTO1,SUM(D2_QUANT) AS D2_QUANT,SUM(D2_TOTAL) AS D2_TOTAL,D2_FILIAL FROM ("
    cQry2 += cQry1
    cQry2 += ") AS RESULT GROUP BY D2_COD,D2_FILIAL"

    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry2), cAlias, .F., .T.)
    While !(cAlias)->(eof())
        nPos := Ascan(_pvtItens,{|x| x[1]+X[2] == (cAlias)->D2_FILIAL+(cAlias)->D2_COD })
        if nPos == 0
            CriaVazio()
            nPos := len(_pvtItens)
            _pvtItens[nPos,1] := (cAlias)->D2_FILIAL
            _pvtItens[nPos,2] := (cAlias)->D2_COD
        endif

        _pvtItens[nPos,nPosSD2]   := (cAlias)->D2_QUANT 
        _pvtItens[nPos,nPosSD2+1] := (cAlias)->D2_CUSTO1/(cAlias)->D2_QUANT 
        _pvtItens[nPos,nPosSD2+2] := (cAlias)->D2_CUSTO1
        _pvtItens[nPos,nPosSD2+3] := (cAlias)->D2_TOTAL

        (cAlias)->(dbSkip())
    enddo

Return

Static Function QryMovimentos(cQry,cDataIni,cDataFim)

    cQry += " SELECT "
    cQry += " 'SD1' AS ORIGEM "
    cQry += " ,D1_FILIAL AS 'FILIAL' "
    cQry += " ,B1_TIPO "
    cQry += " ,D1_LOCAL "
    cQry += " ,CASE WHEN D1_LOCAL = @LOCPROC THEN 'PROCESSO' ELSE 'NPROCESSO' END AS OPERACAO "
    cQry += " ,D1_TES "
    cQry += " ,D1_CF "
    cQry += " ,D1_ITEM "
    cQry += " ,D1_COD "
    cQry += " ,D1_DOC "
    cQry += " ,D1_SERIE "
    cQry += " ,D1_QUANT "
    cQry += " ,D1_CUSTO "
    cQry += " ,SD1.R_E_C_N_O_ "
    cQry += " ,D1_COD AS 'PRODUTOPAI' "
    cQry += " ,'SD1' AS 'TPMOV1' "
    cQry += " FROM "+RetSqlName("SD1")+" SD1 "
    cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
    cQry += " ON SD1.D1_FILIAL = SB1.B1_FILIAL AND SD1.D1_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' "
    cQry += " INNER JOIN "+RetSqlName("SF4")+" SF4 "
    cQry += " ON SD1.D1_FILIAL = SF4.F4_FILIAL AND SF4.F4_CODIGO = SD1.D1_TES AND SF4.D_E_L_E_T_ = ' ' "
    cQry += " WHERE "
    cQry += " SD1.D_E_L_E_T_ = ' ' "
    cQry += " AND SD1.D1_DTDIGIT BETWEEN @DTINI AND @DTFIM "
    cQry += " AND SF4.F4_ESTOQUE = 'S' "
    cQry += " AND SD1.D1_FILIAL BETWEEN @FILINI AND @FILFIM "
    cQry += " UNION ALL "
    cQry += " SELECT "
    cQry += " 'SD3' AS ORIGEM "
    cQry += " ,D3_FILIAL "
    cQry += " ,B1_TIPO "
    cQry += " ,D3_LOCAL "
    cQry += " ,CASE WHEN D3_LOCAL = @LOCPROC THEN 'PROCESSO' ELSE 'NPROCESSO' END AS OPERACAO "
    cQry += " ,'' AS D3_TES "
    cQry += " ,D3_CF "
    cQry += " ,'' AS D3_ITEM "
    cQry += " ,D3_COD "
    cQry += " ,D3_OP "
    cQry += " ,'' AS D3_SERIE "
    cQry += " ,CASE WHEN LEFT(D3_CF,2) = 'RE' THEN D3_QUANT * -1  ELSE D3_QUANT  END AS D3_QUANT "
    cQry += " ,CASE WHEN LEFT(D3_CF,2) = 'RE' THEN D3_CUSTO1 * -1 ELSE D3_CUSTO1 END AS D3_CUSTO1 "
    cQry += " ,SD3.R_E_C_N_O_ "
    cQry += " ,CASE  "
    cQry += " WHEN SD3.D3_OP <> '' THEN CONVERT(VARCHAR,(SELECT TOP 1 D3_COD FROM "+RetSqlName("SD3")+" A WHERE A.D_E_L_E_T_ = ' ' AND A.D3_ESTORNO = ' ' AND A.D3_OP = SD3.D3_OP AND A.D3_CF = 'PR0' AND A.D3_FILIAL = SD3.D3_FILIAL AND A.D3_EMISSAO = SD3.D3_EMISSAO)) "
    cQry += " ELSE D3_COD  "
    cQry += " END AS 'PRODUTO PAI' "
    cQry += " ,CASE  "
    cQry += " WHEN D3_OP <> '' AND B1_TIPO <> 'MO' THEN B1_TIPO "
    cQry += " WHEN D3_OP <> '' THEN B1_COD  "
    cQry += " ELSE ''  "
    cQry += " END AS 'TPMOV1' "
    cQry += " FROM "+RetSqlName("SD3")+" SD3 "
    cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
    cQry += " ON SD3.D3_FILIAL = SB1.B1_FILIAL AND SD3.D3_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' "
    cQry += " INNER JOIN "+RetSqlName("NNR")+" NNR "
    cQry += " ON D3_FILIAL = NNR.NNR_FILIAL AND NNR.NNR_CODIGO = D3_LOCAL AND NNR.D_E_L_E_T_ = '' "
    cQry += " WHERE "
    cQry += " SD3.D_E_L_E_T_ = ' ' "
    cQry += " AND D3_EMISSAO BETWEEN @DTINI AND @DTFIM "
    cQry += " AND SD3.D3_ESTORNO = ' ' "
    cQry += " AND SD3.D3_FILIAL BETWEEN @FILINI AND @FILFIM "
    cQry += " UNION ALL "
    cQry += " SELECT "
    cQry += " 'SD2' AS ORIGEM "
    cQry += " ,D2_FILIAL "
    cQry += " ,B1_TIPO "
    cQry += " ,D2_LOCAL "
    cQry += " ,CASE WHEN D2_LOCAL = @LOCPROC THEN 'PROCESSO' ELSE 'NPROCESSO' END AS OPERACAO "
    cQry += " ,D2_TES "
    cQry += " ,D2_CF "
    cQry += " ,D2_ITEM "
    cQry += " ,D2_COD "
    cQry += " ,D2_DOC "
    cQry += " ,D2_SERIE "
    cQry += " ,D2_QUANT *-1 AS D2_QUANT "
    cQry += " ,D2_CUSTO1*-1 AS D2_CUSTO1 "
    cQry += " ,SD2.R_E_C_N_O_ "
    cQry += " ,D2_COD AS 'PRODUTOPAI' "
    cQry += " ,'SD2' AS 'TPMOV1' "
    cQry += " FROM "+RetSqlName("SD2")+" SD2 "
    cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
    cQry += " ON SD2.D2_FILIAL = SB1.B1_FILIAL AND SD2.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' "
    cQry += " INNER JOIN "+RetSqlName("SF4")+" SF4 "
    cQry += " ON SD2.D2_FILIAL = SF4.F4_FILIAL AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ = ' ' "
    cQry += " WHERE "
    cQry += " SD2.D_E_L_E_T_ = ' ' "
    cQry += " AND SD2.D2_EMISSAO BETWEEN @DTINI AND @DTFIM "
    cQry += " AND SF4.F4_ESTOQUE = 'S' "
    cQry += " AND SD2.D2_FILIAL BETWEEN @FILINI AND @FILFIM "
    cQry += " UNION ALL "
    cQry += " SELECT "
    cQry += " 'SD3' AS ORIGEM "
    cQry += " ,D3_FILIAL "
    cQry += " ,B1_TIPO "
    cQry += " ,@LOCPROC AS D3_LOCAL "
    cQry += " ,'PROCESSO' AS OPERACAO "
    cQry += " ,'' AS D3_TES "
    cQry += " ,D3_CF "
    cQry += " ,'' AS D3_ITEM "
    cQry += " ,D3_COD "
    cQry += " ,D3_DOC "
    cQry += " ,'' AS D3_SERIE "
    cQry += " ,CASE WHEN LEFT(D3_CF,2) = 'RE' THEN D3_QUANT * -1  ELSE D3_QUANT  END AS D3_QUANT "
    cQry += " ,CASE WHEN LEFT(D3_CF,2) = 'DE' THEN D3_CUSTO1 * -1 ELSE D3_CUSTO1 END AS D3_CUSTO1 "
    cQry += " ,SD3.R_E_C_N_O_ "
    cQry += " ,D3_COD AS 'PRODUTOPAI' "
    cQry += " ,CASE  "
    cQry += " WHEN D3_OP <> '' AND B1_TIPO <> 'MO' THEN B1_TIPO "
    cQry += " WHEN D3_OP <> '' THEN B1_COD  "
    cQry += " ELSE ''  "
    cQry += " END AS 'TPMOV1' "
    cQry += " FROM "+RetSqlName("SD3")+" SD3 "
    cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
    cQry += " ON SD3.D3_FILIAL = SB1.B1_FILIAL AND SD3.D3_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' "
    cQry += " INNER JOIN "+RetSqlName("NNR")+" NNR "
    cQry += " ON D3_FILIAL = NNR.NNR_FILIAL AND NNR.NNR_CODIGO = D3_LOCAL AND NNR.D_E_L_E_T_ = '' "
    cQry += " WHERE "
    cQry += " SD3.D_E_L_E_T_ = ' ' "
    cQry += " AND SD3.D3_FILIAL BETWEEN @FILINI AND @FILFIM "
    cQry += " AND D3_EMISSAO BETWEEN @DTINI AND @DTFIM "
    cQry += " AND SD3.D3_ESTORNO = ' ' "
    cQry += " AND D3_CF IN ('RE3','DE3') "

Return

Static Function CriaVazio()
    Local nI   := Nil

    aAdd(_pvtItens,{})
    For nI := 1 to len(_pvtColunas)
        If _pvtColunas[nI,2] == "N"
            aAdd(_pvtItens[len(_pvtItens)],0)
        ElseIf _pvtColunas[nI,2] == "C"
            aAdd(_pvtItens[len(_pvtItens)],"")
        EndIf
    Next nI
Return
