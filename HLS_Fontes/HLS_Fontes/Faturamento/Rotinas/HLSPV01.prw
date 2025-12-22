#Include "Protheus.ch"

/*/{Protheus.doc} A410CONS

Rotina responsável pela exclusão em lote do pedido de venda

@author Ectore Cecato - Totvs IP
@since 	02/10/2019

/*/

User Function HLSPV01()
	
	Local aPerg	:= {}
	Local aRet	:= {}
	
	aAdd(aPerg, {1, "Arquivo",		Space(TamSX3("C6_NOMARQ")[1]),  "@!", 	"", "", "", 50, .T.})
	aAdd(aPerg, {1, "Local Exp.",	Space(TamSX3("C6_ZZIDEXP")[1]), "@!", 	"", "", "", 50, .T.})
//	aAdd(aPerg, {1, "Emissão",		CToD(Space(8)),			 		"", 	"", "", "", 50, .T.})
	aAdd(aPerg, {1, "Data Entrega apartir de:",		CToD(Space(8)),			 		"", 	"", "", "", 50, .T.})
	aAdd(aPerg, {1, "Hora EDI",		Space(TamSX3("C6_ZZHRENT")[1]), "@!", 	"", "", "", 50, .T.})
	
	
	If ParamBox(aPerg, "Exclusão PV", @aRet)
		Processa({|| ExcPVLote(MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04)}, "Aguarde", "Excluindo pedidos de venda", .T.)
	EndIf
	
Return Nil

Static Function ExcPVLote(cArq, cLocal, dEntrega,cHora)
	
	Local cQuery 	:= ""
	Local cPedido	:= ""
	Local cError	:= ""
	Local cMsg		:= ""
	Local cAliasQry	:= GetNextAlias()
	
	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .F.
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		SC5.C5_FILIAL, SC5.C5_NUM, SC5.C5_TIPO, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_LOJAENT, SC5.C5_CONDPAG, "+ CRLF
	cQuery += "		SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_QTDVEN, SC6.C6_PRCVEN, SC6.C6_PRUNIT, SC6.C6_VALOR, SC6.C6_TES "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SC5") +" "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SC6") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SC6") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SC6") +" "+ CRLF
	cQuery += "				AND SC6.C6_NUM = SC5.C5_NUM "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SC5") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SC5") +" "+ CRLF
//	cQuery += "		AND SC5.C5_EMISSAO = '"+ DToS(dEmissao) +"' "+ CRLF
	cQuery += "		AND SC6.C6_ENTREG >= '"+ DToS(dEntrega) +"' "+ CRLF		//Luciano Lamberti
	cQuery += "		AND SC6.C6_NOMARQ = '"+ AllTrim(cArq) +"' "+ CRLF
	cQuery += "		AND SC6.C6_ZZIDEXP = '"+ AllTrim(cLocal) +"' "+ CRLF
	cQuery += "		AND SC6.C6_ZZHRENT = '"+ AllTrim(cHora) +"' "	//Luciano Lamberti
	cQuery := ChangeQuery(cQuery)
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	ProcRegua(0)
	
	If !(cAliasQry)->(Eof())
		
		While !(cAliasQry)->(Eof())
			
			cFilPV			:= (cAliasQry)->C5_FILIAL
			cPedido 		:= (cAliasQry)->C5_NUM
			aCabec         	:= {}
			aItens         	:= {}
			lMsErroAuto    	:= .F.
			lAutoErrNoFile 	:= .F.			
			
			aAdd(aCabec, {"C5_NUM",     (cAliasQry)->C5_NUM,      	Nil})
			aAdd(aCabec, {"C5_TIPO",    (cAliasQry)->C5_TIPO,       Nil})
			aAdd(aCabec, {"C5_CLIENTE", (cAliasQry)->C5_CLIENTE,    Nil})
			aAdd(aCabec, {"C5_LOJACLI", (cAliasQry)->C5_LOJACLI,   	Nil})
			aAdd(aCabec, {"C5_LOJAENT", (cAliasQry)->C5_LOJAENT,   	Nil})
			aAdd(aCabec, {"C5_CONDPAG", (cAliasQry)->C5_CONDPAG,	Nil})

			While !(cAliasQry)->(Eof()) .And. (cAliasQry)->C5_FILIAL == cFilPV .And. (cAliasQry)->C5_NUM == cPedido

		      aLinha := {}
		      
		      aAdd(aLinha,{"C6_ITEM",    (cAliasQry)->C6_ITEM, 		Nil})
		      aAdd(aLinha,{"C6_PRODUTO", (cAliasQry)->C6_PRODUTO,   Nil})
		      aAdd(aLinha,{"C6_QTDVEN",  (cAliasQry)->C6_QTDVEN,    Nil})
		      aAdd(aLinha,{"C6_PRCVEN",  (cAliasQry)->C6_PRCVEN,    Nil})
		      aAdd(aLinha,{"C6_PRUNIT",  (cAliasQry)->C6_PRUNIT,    Nil})
		      aAdd(aLinha,{"C6_VALOR",   (cAliasQry)->C6_VALOR,     Nil})
		      aAdd(aLinha,{"C6_TES",     (cAliasQry)->C6_TES,       Nil})
		      
		      aAdd(aItens, aLinha)			
		      
		      (cAliasQry)->(DbSkip())
		      
			EndDo
			
			MSExecAuto({|a, b, c| MATA410(a, b, c)}, aCabec, aItens, 5)
			
			If lMsErroAuto
				cError := cPedido + CRLF
		    EndIf
			
		EndDo
		
		If !Empty(cError)
			cMsg := "Os seguintes pedidos de venda não foram excluídos:" + CRLF + CRLF + cError
		Else
			cMsg := "Pedidos excluídos com sucesso"
		EndIf
		
		Aviso("Atenção", cMsg, {"Ok"})
		
	Else
		Aviso("Atenção", "Nenhum pedido de venda encontrado", {"Ok"})
	EndIf
	
	(cAliasQry)->(DbCloseArea())	
	
Return Nil