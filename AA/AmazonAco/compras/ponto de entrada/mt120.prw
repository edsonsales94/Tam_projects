#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOTVS.CH"    

/*-------------------------------------------------------------------------------

Rotina MT120BRW()

KODIGOS Software Engineering
Rotina desenvolvida para Amazon Aço
Responsável: Miguel Salomão
Data: 17/09/2021
 
Rotina para troca de fornecedores a oartir do cadastro de
Entrega por Terceiros (CXP)
 
--------------------------------------------------------------------------------*/

 

User Function MT120BRW()

//Define Array contendo as Rotinas a executar do programa    
// ----------- Elementos contidos por dimensao ------------    
// 1. Nome a aparecer no cabecalho                            
// 2. Nome da Rotina associada                                
// 3. Usado pela rotina                                        
// 4. Tipo de Transa‡„o a ser efetuada                        
//    1 - Pesquisa e Posiciona em um Banco de Dados            
//    2 - Simplesmente Mostra os Campos                        
//    3 - Inclui registros no Bancos de Dados                  
//    4 - Altera o registro corrente                          
//    5 - Remove o registro corrente do Banco de Dados        
//    6 - Altera determinados campos sem incluir novos Regs    


AAdd( aRotina, { 'Troca Fornecedor(Entrega por Terceiros)', "U_KChgFor()", 0, 4 } )
 
Return



/*-----------------------------------------------------
Função que monta browse com fornecedores alternativos
Busca amarração de entrega por terceiros
 -----------------------------------------------------*/

Function  U_KCHGFOR()

Private lMarker     := .T.
Private aItTemp := {}
private oMarkBrw := nil 

//teste()
//Popula o browse e valida pedido

If !BUSDATA(SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_NUM,SC7->C7_FILIAL)
    Return
Endif

 
DEFINE MsDIALOG o3Dlg TITLE 'Troca Fornecedor - Entrega por Terceiros' From 0, 4 To 400, 1000 Pixel

    oPnMaster := tPanel():New(27,0,,o3Dlg,,,,,,0,0)
    oPnMaster:Align := CONTROL_ALIGN_ALLCLIENT
    oMarkBrw := fwBrowse():New()
    oMarkBrw:setOwner( oPnMaster )

    oMarkBrw:setDataArray()
    oMarkBrw:setArray( aItTemp )
    oMarkBrw:disableConfig()
    oMarkBrw:disableReport()
	
    oMarkBrw:SetLocate() // Habilita a Localização de registros

    //Create Mark Column
    oMarkBrw:AddMarkColumns({|| IIf(aItTemp[oMarkBrw:nAt,01], "LBOK", "LBNO")},{|| SelOnes()} ) //Code-Block Header Click

    //oMarkBrw:FWMarkBrowse():SetMark(cMark, cAlias ,  cField )

    oMarkBrw:addColumn({"Codigo Pai"        , {||aItTemp[oMarkBrw:nAt,02]}, "C", "@!" , 1,  10, ,.T., , .F.,, "aItTemp[oMarkBrw:nAt,02]",, .F., .T., , "ETDESPES1" })
    oMarkBrw:addColumn({"Loja"              , {||aItTemp[oMarkBrw:nAt,03]}, "C", "@!" , 1,   5, ,.T., , .F.,, "aItTemp[oMarkBrw:nAt,03]",, .F., .T., , "ETDESPES2" })
    oMarkBrw:addColumn({"Codigo Alternativo", {||aItTemp[oMarkBrw:nAt,04]}, "C", "@!" , 1,  10, ,.T., , .F.,, "aItTemp[oMarkBrw:nAt,04]",, .F., .T., , "ETDESPES3" })
    oMarkBrw:addColumn({"Loja"              , {||aItTemp[oMarkBrw:nAt,05]}, "C", "@!" , 1,   5, ,.T., , .F.,, "aItTemp[oMarkBrw:nAt,05]",, .F., .T., , "ETDESPES4" })
    oMarkBrw:addColumn({"Razão Social"      , {||aItTemp[oMarkBrw:nAt,06]}, "C", "@!" , 1,  10, ,.T., , .F.,, "aItTemp[oMarkBrw:nAt,06]",, .F., .T., , "ETDESPES5" })
    oMarkBrw:addColumn({"CNPJ"              , {||aItTemp[oMarkBrw:nAt,07]}, "C", "@!" , 1,  10, ,.T., , .F.,, "aItTemp[oMarkBrw:nAt,07]",, .F., .T., , "ETDESPES6" })
    oMarkBrw:addColumn({"Inscrição Est."    , {||aItTemp[oMarkBrw:nAt,08]}, "C", "@!" , 1,  15, ,.T., , .F.,, "aItTemp[oMarkBrw:nAt,08]",, .F., .T., , "ETDESPES7" })
    oMarkBrw:addColumn({"Estado"            , {||aItTemp[oMarkBrw:nAt,09]}, "C", "@!" , 1,  10, ,.T., , .F.,, "aItTemp[oMarkBrw:nAt,09]",, .F., .T., , "ETDESPES8" })
    oMarkBrw:addColumn({"Município"         , {||aItTemp[oMarkBrw:nAt,10]}, "C", "@!" , 1,  15, ,.T., , .F.,, "aItTemp[oMarkBrw:nAt,10]",, .F., .T., , "ETDESPES9" })

    oMarkBrw:Activate(.T.) 
	
	
	oBut3 := tButton():New(180,168,"Ok"        ,o3Dlg,{||RunProc(),Close(o3Dlg) }        ,23,11,,,,.T.) 
	oBut4 := tButton():New(180,197,"Sair"      ,o3Dlg,{||Close(o3Dlg)}     ,23,11,,,,.T.)

	

Activate MsDialog o3Dlg

return .t.

 

 

Static Function SelectOne(nItem)

If aItTemp[nItem,1]
    aItTemp[nItem,1] := .F.
Else
    aItTemp[nItem,1] := .T.
Endif

oMarkBrw:Refresh()

Return


Static Function RunProc()
Local cQry := ""
Local _ni := 1
For _ni := 1 to len(aItTemp)
    
    If aItTemp[_ni][1]
    
        cQry := " UPDATE "+RetSQLName("SC7")+" SET C7_FORNECE = '"+aItTemp[_ni][4]+"', C7_LOJA = '"+aItTemp[_ni][5]+"' "
        cQry += " WHERE  C7_NUM  = '"+SC7->C7_NUM+"' "
        cQry += " AND C7_FILIAL   = '"+SC7->C7_FILIAL+"' "

        TCSqlExec(cQry) 

    Endif
Next

Return

 

 

Static Function SelectAll(oBrowse, nCol, aArquivo)

//Local _ni := 1
//For _ni := 1 to len(aArquivo)
//    aArquivo[_ni,1] := lMarker
//Next
//oBrowse:Refresh()
//lMarker:=!lMarker

Return .T.


 

//Alimenta a tabela temporaria

Static Function BUSDATA(cForne,cLoja,cPed,cFili)

    Local cQuery    as Character
    Local aLinha:= {}
    Local lRet:= .F.
    cQuery      := ""
    aItTemp := {}

    //Valida se é importação

    If posicione("SA2",1,xFilial("SA2")+cForne+cLoja,"A2_EST") == "EX"
        MsgStop("Operação inválida para este pedido! Operação não permitida para importações.")
        Return .f.
    Endif

  
    //Valida Status
    cQuery:= " SELECT COUNT(*) VALIDS FROM SC7010(NOLOCK) WHERE C7_NUM = '"+cPed+"' AND C7_FILIAL = '"+cFili+"' "
    cQuery+= " AND C7_ENCER ='' AND C7_QUJE = 0 AND C7_QTDACLA = 0 AND C7_CONAPRO != 'B' AND C7_TIPO = 1 AND C7_RESIDUO = '' "

    If Select('TMP') > 0
        TMP->(DbCloseArea())
    Endif

    dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) ,'TMP', .T., .F. )

    TMP->(DbGoTop())

    If TMP->VALIDS == 0

        MsgStop("Operação inválida para este pedido! O status deste pedido não permite alteração.")
        TMP->(DbCloseArea())
        Return.f.

    Endif

    TMP->(DbCloseArea())

    cQuery:= " SELECT CPX_CODIGO,CPX_LOJA,CPX_ITEM,A2_CGC,A2_INSCR,CPX_CODFOR,CPX_LOJFOR,A2_NOME, A2_EST,A2_MUN FROM CPX010(NOLOCK) CPX "
    cQuery+= " INNER JOIN SA2010(NOLOCK) A2 ON A2.D_E_L_E_T_ = '' AND A2_COD = CPX_CODFOR AND A2_LOJA = CPX_LOJFOR "
    cQuery+= " WHERE CPX.D_E_L_E_T_ = '' AND CPX_CODIGO = '"+cForne+"' AND CPX_LOJA = '"+cLoja+"'  "
    cQuery+= " ORDER BY CPX_CODIGO,CPX_LOJA,CPX_ITEM "

    xTbl := MpSysOpenQuery(cQuery)
    dbselectarea(xTbl)
    aItTemp := {}

    //xTbl)->(DbGoTop())

    If !(xTbl)->(EoF())
	
        lRet:= .t.
		
        While (xTbl)->(!EOF())

            aLinha := {}

            aadd(aLinha, .f.)
            aadd(aLinha, (xTbl)->CPX_CODIGO)
            aadd(aLinha, (xTbl)->CPX_LOJA)
            //aadd(aLinha, TMP->CPX_ITEM)
            aadd(aLinha, (xTbl)->CPX_CODFOR)
            aadd(aLinha, (xTbl)->CPX_LOJFOR)
            aadd(aLinha, (xTbl)->A2_NOME)
            aadd(aLinha, (xTbl)->A2_CGC)
            aadd(aLinha, (xTbl)->A2_INSCR)
            aadd(aLinha, (xTbl)->A2_EST)
            aadd(aLinha, (xTbl)->A2_MUN)

            aadd(aItTemp,aclone(aLinha))

    
            (xTbl)->(dbSkip())

        EndDo

    Else

        MsgStop("Operação inválida para este pedido! Verifique o cadastro Entrega por Terceiros.")
        //TMP->(DbCloseArea())
        Return.f.
		
    Endif

    //TMP->(dbCloseArea())
Return lRet

 
 

 

 

Static Function SelOnes()

aItTemp[oMarkBrw:nAt,1] := !aItTemp[oMarkBrw:nAt,1]
oMarkBrw:Refresh()

Return .T.

 
 

Static Function SelAlls(oBrowse, nCol, aArquivo)

Local _ni := 1
For _ni := 1 to len(aArquivo)
    aArquivo[_ni,1] := lMarker
Next

oBrowse:Refresh()
lMarker:=!lMarker

Return .T.

 

 

 

//Alimenta a tabela temporaria

Static Function BUSDATAs()

Local cQuery    as Character
Local cQryT3    as Character

cQuery      := ""
cQryT3      := GetNextAlias()

aDespes := {}


cQuery+="SELECT * FROM " + RetSqlName("SA1")
cQuery+=" WHERE D_E_L_E_T_=''"

cQuery:=ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cQryT3, .T., .F. )

(cQryT3)->(DbGoTop())

While (cQryT3)->(!EOF()) 

    aadd(aDespes,{.f.,alltrim((cQryT3)->A1_COD+(cQryT3)->A1_LOJA),alltrim((cQryT3)->A1_NOME),alltrim((cQryT3)->A1_END),alltrim((cQryT3)->A1_MUN)    })

    (cQryT3)->(dbSkip())

EndDo

(cQryT3)->(dbCloseArea())

DbSelectArea('SA1')

 

Return .t.
