#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Topconn.ch"
#Include "ap5mail.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#Include "aarray.ch"
#Include "json.ch"
#Include "shash.ch"

//Integração - Importação Materiais.

User Function GERA_PED()  //1=Usuario, 2=senha, 3=Código Grupo Empresa, 4=Código Filial, 5=Código Usuário, 6=Id da tarefa.
Local aTipo	 		:={'N','B','D'}
Local cFile 		:= Space(10)
Local oPedido 		:= nil
Local oDadosPed 	:= nil
Local nOpc     		:= 3 // inclusao
Local aItens        := {}
Local aCabSC5     	:= {}
Local aPedIte 		:= {}

Local cQuery  := ""  //Variavel para a query
Local cObjIni := "Taf" //Constante TAF para ser usada no inicio do nome do Ponto de Entrada
Local cObjPE  := "Imp" //Objeto principal CBH - Cabeçalho e item de pedido
Local nItem   := 0     //Incrementa o campo número do item

//Definição das variáveis com os nomes dos pontos de entrada
Local cPEIn1 := cObjIni+cObjPE+"In1"
Local cPEFim := cObjIni+cObjPE+"Fim"
// Cabeçalho
Local cPEIn2 := cObjIni+cObjPE+"In2"
Local cPEFil := cObjIni+cObjPE+"Fil"
Local cPEIte := cObjIni+cObjPE+"Ite"
// Item
Local cPEIn2B := cObjIni+cObjPE+"In2B"
Local cPEFilB := cObjIni+cObjPE+"FilB"
Local cPEIteB := cObjIni+cObjPE+"IteB"

Local PedidoID
Local sStatus
Local sC5_NUM
Local sC5_EMISSAO
Local sC5_CLIENTE
Local sC5_CONDPAG
Local sC5_TABELA
Local sC5_VEND1
Local sC5_TPFRETE
Local sC5_SUNMSNF
Local sC5_MENNOTA := ""
Local sC5_FRTEST  
Local XX := 0
Local _I := 0
Local _J := 0
Local aTam := {}

Local cFilOrig := ""

//Default aParam := {"01","01"} // caso nao receba nenhum parametro, usa como padrão empresa 01, filial 01
/*
If !Empty(aParam[1])  //Se for uma execução por Job. Tem q fazer o prepare environment
	//_cUsuario := aParam[1] //usuario
	//_cSenha   := aParam[2] //Senha
	_cEmpresa := aParam[3] //Empresa
	_cFilial  := aParam[4] //Filial

	RPCSetType(3) //não consome licença.
	PREPARE ENVIRONMENT EMPRESA _cEmpresa FILIAL _cFilial //USER _cUsuario PASSWORD _cSenha MODULO "FAT"
Endif
*/
//Private _cMarca   := GetMark()
Private aFields   := {}
Private cArq
Private aFields2  := {}
Private cArq2

PRIVATE lMsErroAuto := .F.// variável que define que o help deve ser gravado no arquivo de log e que as informações estão vindo à partir da rotina automática.
Private lMsHelpAuto	:= .T.    // força a gravação das informações de erro em array para manipulação da gravação ao invés de gravar direto no arquivo temporário
Private lAutoErrNoFile  := .T.
Private lIniciaProcesso := .T.

//TRATAR QUESTÃO DA FILIAL
CFILIAL := oRetorno:Filial:Codigo

CCLIENTE := SUBSTR(ORETORNO:CLIENTE:CODIGOPRINCIPAL,1,6)
CLOJA    := SUBSTR(ORETORNO:CLIENTE:CODIGOPRINCIPAL,7,4)
CTIPO    := POSICIONE("SA1",1,XFILIAL("SA1")+CCLIENTE+CLOJA,"A1_TIPO")
CCOND    := ORETORNO:PLANOPAGAMENTO:CODIGO
CTABELA  := Right(ORETORNO:CLIENTE:PRACA:REGIAO:CODIGO,3)
CTPFRETE := IIF(TYPE("ORETORNO:FRETE")=="C",ORETORNO:FRETE,"F")
NFRETE   := ORETORNO:VALORFRETE
CTRANSP  := IIF(TYPE("ORETORNO:CLIENTE:CODFORNECFRETE")=="C",ORETORNO:CLIENTE:CODFORNECFRETE,"000001")
IF TYPE("ORETORNO:DATAFECHAMENTOPEDIDO") != "U"
	CDATA    := ORETORNO:DATAFECHAMENTOPEDIDO
	DEMISSAO := STOD(SUBSTR(STRTRAN(ORETORNO:DATAFECHAMENTOPEDIDO,"-",""),1,8))
ELSE
	CDATA    := ""
	DEMISSAO := DDATABASE
ENDIF
CMENSAG  := ORETORNO:OBSERVACAO
CVEND    := ORETORNO:CODUSUARIO
CPEDIDO  := CVALTOCHAR(ORETORNO:NUMPEDIDO)
CFORMA   := ORETORNO:CLIENTE:COBRANCA:CODIGO

//Verificar se o pedido ja existe no sistema caso positivo nao continuar
cQry := "SELECT COUNT(*) QTDE FROM SC5010 WHERE C5_FILIAL = '"+oRetorno:Filial:Codigo+"' AND C5_XXPEDMA = '"+CPEDIDO+"' AND C5_VEND1 = '"+CVEND+"' AND D_E_L_E_T_ = ' '"

If Select("xQRY") > 0
	xQry->(DBCLOSEAREA())
EndIf

TCQuery cQry New Alias "xQRY"

If xQRY->QTDE > 0 
	NSTATUS := 4   
	NTIPOCRITICA := 0  
	CTIPO := "Sucesso"   
	CPED := SC5->C5_NUM 
	CDESC := 'Pedido Importado com Sucesso - Existente'
		
	ENVIA_RESP(CDESC)
	RETURN
EndIf


ACABSC5:= {}

AADD(ACABSC5,{"C5_FILIAL"  ,CFILIAL   	,NIL})
AADD(ACABSC5,{"C5_TIPO"    ,"N"        	,NIL})
AADD(ACABSC5,{"C5_CLIENTE" ,CCLIENTE	,NIL})
AADD(ACABSC5,{"C5_LOJACLI" ,CLOJA   	,NIL})
AADD(ACABSC5,{"C5_CONDPAG" ,CCOND		,NIL})
AADD(ACABSC5,{"C5_TABELA"  ,CTABELA 	,NIL})
AADD(ACABSC5,{"C5_TPFRETE" ,CTPFRETE	,NIL})
AADD(ACABSC5,{"C5_TRANSP"  ,CTRANSP 	,NIL})
AADD(ACABSC5,{"C5_EMISSAO" ,DEMISSAO	,NIL})
AADD(ACABSC5,{"C5_MENNOTA" ,CMENSAG		,NIL})
AADD(ACABSC5,{"C5_CLIENT"  ,CCLIENTE	,NIL})
AADD(ACABSC5,{"C5_LOJAENT" ,CLOJA   	,NIL})
AADD(ACABSC5,{"C5_VEND1"   ,CVEND  		,NIL})
AADD(ACABSC5,{"C5_XXPEDMA" ,CPEDIDO   	,NIL})//CRIAR CAMPO - OK
AADD(ACABSC5,{"C5_XFORPAG" ,CFORMA		,NIL})//VERIFICAR PQ ESTAMOS USANDO O 999
AADD(ACABSC5,{"C5_NATUREZ" , '1001005'  ,NIL})

//AADD(ACABSC5,{"C5_ESPECI1" ,CESPECIE,NIL})	                    	           

CITEM := "00" //Inicia a sequencia do item com 00 para ser incrementada em 1 no inicio do while

AITENS := {}
	
FOR XX := 1 TO LEN(ORETORNO:PRODUTOS)		 
		
	CPRODUTO := ORETORNO:PRODUTOS[XX]:CODIGO 
	NQUANT   := ORETORNO:PRODUTOS[XX]:QUANTIDADE 
	NPRCVEN  := ORETORNO:PRODUTOS[XX]:PRECOBASE 
								
	CITEM := SOMA1(CITEM,2)
	AITEM := {}
	
	AADD(AITEM, {"C6_FILIAL" , CFILIAL   	, NIL})
	AADD(AITEM, {"C6_ITEM"   , CITEM		, NIL})		
	AADD(AITEM, {"C6_PRODUTO", CPRODUTO 	, NIL})
	AADD(AITEM, {"C6_QTDVEN" , NQUANT		, NIL})
	AADD(AITEM, {"C6_PRCVEN" , NPRCVEN		, NIL})
	AADD(AITEM, {"C6_VALOR"  , NQUANT*NPRCVEN, NIL})
	AADD(AITEM, {"C6_TES"    , "826"		, NIL})

	AADD(AITENS, AITEM)
NEXT XX
	

	MSEXECAUTO({|X,Y,Z|MATA410(X,Y,Z)},ACABSC5,AITENS,NOPC) //ACIONA EXEC AUTO PARA INSERIR O NOVO REGISTRO.
	
	LRET := .F.
		
	IF LMSERROAUTO
		NSTATUS := 5	 
		NTIPOCRITICA := 2	
		CTIPO := "Erro" 
		CPED  := ""                   
		CDESC := 'Pedido NAO importado'

		If (!IsBlind()) 
        	cDesc += CRLF+MostraErro()
			//MostraErro()
		else
			cDesc += CRLF+MostraErro(Upper(GetSrvProfString("STARTPATH",""))+"Maxima\", "Gera_Ped_Exec_Ped_"+DtoS(date())+Time()+".log") // ARMAZENA A MENSAGEM DE ERRO
			//MostraErro(Upper(GetSrvProfString("STARTPATH",""))+"Maxima\", "Gera_Ped_Exec_Ped_"+DtoS(date())+Time()+".log")
		EndIf

		ENVIA_RESP(CDESC)

		DISARMTRANSACTION()	
	ELSE
		NSTATUS := 4   
		NTIPOCRITICA := 0  
		CTIPO := "Sucesso"   
		CPED := SC5->C5_NUM 
		CDESC := 'Pedido Importado com Sucesso'
		
		ENVIA_RESP(CDESC)
	
END TRANSACTION

RETURN

/*
Função para envio de email
*/
STATIC FUNCTION l(_cSubject, _cDest, _cBody, _cAtach)

//  u_fxEnvMail(_cSubject, _cDest, _cBody, _cAtach)

Return
        
/*
Função que retorna a posição do campo na SX3
*/
STATIC FUNCTION fxPos(cCampo)
Local nPos  := 0
	nPos := POSICIONE("SX3", 2, cCampo, "X3_ORDEM")
Return nPos
                        
/*
Função que ordena o array de campos para ser passado para Cabeçalho e Detalhe
do ExecAuto
*/ 
STATIC FUNCTION fxOrdenaSX3(aCampos)
Local aWithPos := {}
Local aOrdenado := {}
Local nX := {}

//Le o array passado como parametro e coloca a posição de cada campo
For nX:= 1 to len(aCampos)
	aadd(aWithPos,{aCampos[nX,1],aCampos[nX,2], aCampos[nX,3], fxPos(aCampos[nX,1])})
Next            

//Ordena o array de acordo com a posição dos campos
ASORT(aWithPos, , , { | x,y | x[4] < y[4] } )
              
//Monta o novo array somente com os campos originais, mas agora ordenado
For nX:=1 to Len(aWithPos)
	aadd(aOrdenado,{aWithPos[nX,1],aWithPos[nX,2], aWithPos[nX,3]})	
Next

Return aOrdenado


STATIC FUNCTION ENVIA_RESP(CDESC)
	Local _J := 0
	Local _I := 0

	aaJson := Array(#)
    oObj   := NIL
	ADADOS  := {}
	ADADOSA := {}

	NNUMERO := VAL(DTOS(DATE())+STRTRAN(TIME(),":",""))//yyyyMMddHHmmss

	CDESC := fNaoAceitos(CDESC)

	AADD(ADADOSA, {"codigo", 0})								
	AADD(ADADOSA, {"ordem", 0})
	AADD(ADADOSA, {"descricao",CDESC})

	AADD(ADADOS, ADADOSA)

	aaJson[#'JSON'] := Array(Len(aDados))

	For _I := 1 To Len(aDados)
		aaJson[#'JSON'][_I] := Array(#)
		For _J := 1 To Len(ADADOS[_I])
			cField := ADADOS[_I,_J,1]
			cDado := aDados[_I,_J,2]
			If ValType(cDado) == "C"
				cDado := AllTRim(cDado)
			EndIf
			aaJson[#'JSON'][_I][#cField] := cDado
		Next _J
	Next _I

	cJson := ToJson(aaJson)
	FWJsonDeserialize(cJson,@oObj)
	cJson := FWJsonSerialize(oObj:JSON,.F.,.T.)        

    CJSONITEM := cJson

	aaJson := Array(#)
    oObj   := NIL
	ADADOS  := {}
	ADADOSA := {}

	YY := 1

	AADD(ADADOSA, {"numPedido", AOBJETO[YY]:NUMPED})								
	AADD(ADADOSA, {"codigoPedidoNuvem", ORETORNO:codigoPedidoNuvem})
	AADD(ADADOSA, {"numPedidoERP", CPED})
	AADD(ADADOSA, {"numCritica", NNUMERO})
	AADD(ADADOSA, {"codigoUsuario", VAL(ORETORNO:CODIGOUSUARIOMAXIMA)})
	AADD(ADADOSA, {"data", FWTimeStamp( 5 , DDATABASE ,  TIME() )})//TRATAR A GERAÇÃO DESSA DATA
	AADD(ADADOSA, {"tipo", CTIPO})
	AADD(ADADOSA, {"itens", ""})//TRATAR OS ITENS
	AADD(ADADOSA, {"posicaoPedidoERP", "Pendente"})
	AADD(ADADOSA, {"codigoTipoVenda", 1})
	AADD(ADADOSA, {"statusDaAssinatura", 0})		
	AADD(ADADOSA, {"excluirPedido", .F.})
	AADD(ADADOSA, {"salvarCritica", .T.})
	AADD(ADADOSA, {"enviarEmailPedidoAutomaticoParaSupervisor", .F.})
	AADD(ADADOSA, {"salvarJustificativaNaoVendaPrePedido", .F.})
	AADD(ADADOSA, {"atualizacaoPosPedido", .T.})
	AADD(ADADOSA, {"cancelado", .F.})
	AADD(ADADOSA, {"houveExcessao", .F.})
	AADD(ADADOSA, {"packageValida", .F.})														

	AADD(ADADOS, ADADOSA)

	aaJson[#'JSON'] := Array(Len(aDados))

	For _I := 1 To Len(aDados)
		aaJson[#'JSON'][_I] := Array(#)
		For _J := 1 To Len(ADADOS[_I])
			cField := ADADOS[_I,_J,1]
			cDado := aDados[_I,_J,2]
			If ValType(cDado) == "C"
				cDado := AllTRim(cDado)
			EndIf
			aaJson[#'JSON'][_I][#cField] := cDado
		Next _J
	Next _I

	cJson := ToJson(aaJson)
	FWJsonDeserialize(cJson,@oObj)
	cJson := FWJsonSerialize(oObj:JSON,.F.,.T.)        
	
    CJSONCRIT := SUBSTR(cJson,2,LEN(cJson)-2)
	CJSONCRIT := STRTRAN(CJSONCRIT,'"ITENS":""', '"ITENS":'+CJSONITEM) 

	aaJson := Array(#)
    oObj   := NIL
	ADADOS  := {}
	ADADOSA := {}

	AADD(ADADOSA, {"id_Pedido", AOBJETO[YY]:ID_PEDIDO})								
	AADD(ADADOSA, {"objeto_Json", })
	AADD(ADADOSA, {"status", NSTATUS})
	AADD(ADADOSA, {"data", AOBJETO[YY]:DATA})
	AADD(ADADOSA, {"critica", CJSONCRIT})
	AADD(ADADOSA, {"tipoPedido", AOBJETO[YY]:tipoPedido})
	AADD(ADADOSA, {"codUsur", AOBJETO[YY]:CODUSUR})
	AADD(ADADOSA, {"codUsuario", AOBJETO[YY]:CODUSUARIO})
	AADD(ADADOSA, {"numPed", AOBJETO[YY]:NUMPED})
	AADD(ADADOSA, {"numPedErp", CPED})
	AADD(ADADOSA, {"numCritica", NNUMERO})		
	AADD(ADADOSA, {"tipoCritica", NTIPOCRITICA})

	AADD(ADADOS, ADADOSA)								

	U_BENVIA(ADADOS   ,"PUT"    , "RetornoStatus", "StatusPedidos")      	

RETURN


Static Function fNaoAceitos(cString)
	Local cChar  := ""
	Local nX     := 0 
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
	Local cTio   := "ãõÃÕ"
	Local cCecid := "çÇ"
	Local cMaior := "&lt;"
	Local cMenor := "&gt;"
	Local cSimb	 := '%/:-'


	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf		
			nY:= At(cChar,cTio)
			If nY > 0          
				cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
			EndIf		
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
			if nY:= At(cChar,cSimb)
				cString := StrTran(cString,cChar,'_')
			EndIf
		Endif
	Next

	/*
	If cMaior$ cString 
		cString := strTran( cString, cMaior, "" ) 
	EndIf
	If cMenor$ cString 
		cString := strTran( cString, cMenor, "" )
	EndIf

	cString := StrTran( cString, CRLF, " " )
	*/

Return cString
