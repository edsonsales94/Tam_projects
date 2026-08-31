/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fxImpPed Autor ³ Sérgio Siqueira º Data ³ 10/01/2013       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Leitura e Importacao dos pedidos de venda da base do Landixº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Integração Landix                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

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

User Function GERA_CLI()  //1=Usuario, 2=senha, 3=Código Grupo Empresa, 4=Código Filial, 5=Código Usuário, 6=Id da tarefa.
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

//Private _cMarca   := GetMark()
Private aFields   := {}
Private cArq
Private aFields2  := {}
Private cArq2

PRIVATE lMsErroAuto := .F.// variável que define que o help deve ser gravado no arquivo de log e que as informações estão vindo à partir da rotina automática.
Private lMsHelpAuto	:= .T.    // força a gravação das informações de erro em array para manipulação da gravação ao invés de gravar direto no arquivo temporário
Private lAutoErrNoFile  := .T.
Private lIniciaProcesso := .T.

CPESSOA  := IIF(ORETORNO:PESSOAFISICA,"F","J")
CNPJ     := STRTRAN(STRTRAN(STRTRAN(ORETORNO:CNPJ,".",""),"/",""),"-","")
CCOND    := ORETORNO:PLANOPAGAMENTO:CODIGO 
CEMAIL   := ORETORNO:EMAILNFE    
CEND     := UPPER(ORETORNO:ENDERECO:LOGRADOURO)
CBAIRRO  := UPPER(ORETORNO:ENDERECO:BAIRRO)
CCEP     := ORETORNO:ENDERECO:CEP
CCIDADE  := SUBSTR(ORETORNO:PRACA:CODIGOCIDADE,3,5)
CCOMPLE  := ORETORNO:ENDERECO:COMPLEMENTO
CUF      := ORETORNO:ENDERECO:UF  
CNOME    := UPPER(ORETORNO:NOME)
CTABELA  := ORETORNO:PRACA:CODIGO//TEM QUE VERIFICAR ISSO, PQ NA LUZTOL NÃO TEM UMA REGRA PRA SABER EXATAMENTE QUAL A TABELA DE PREÇO DO CLIENTE
CATIVID  := ORETORNO:RAMOATIVIDADE:CODIGO         
CDDD     := SUBSTR(ORETORNO:TELEFONE,1,2)
CTEL     := SUBSTR(ORETORNO:TELEFONE,3,10)
CVEND    := ORETORNO:CODIGORCA                  
CINSCRI  := ORETORNO:INSCRICAOESTADUAL  
CTIPOCLI := IIF(CPESSOA=="F","F","R")
CCODNUV  := CVALTOCHAR(ORETORNO:CODIGOCLIENTENUVEM)
// -- TESTA SE O PEDIDO Já EXISTE NA BASE DE DADOS
//SC5->(DBORDERNICKNAME("XXPEDMA"))
//IF SC5->(DBSEEK(XFILIAL("SC5")+PADL(ALLTRIM(CPEDIDO),10)+PADL(ALLTRIM(CVEND),6)))
//	MSGINFO("Pedido já importado!")
//	RETURN
//ENDIF
//TEM QUER CRIAR CAMPO PARA GRAVAR O NÚMERO DESSE CLIENTE NO PROTHEUS OU OLHAR SÓ NO CNPJ
ACABSA1:= {}
AADD(ACABSA1,{"A1_LOJA"    ,"01" 	  	,NIL})
AADD(ACABSA1,{"A1_PESSOA"  ,CPESSOA   	,NIL})
AADD(ACABSA1,{"A1_CGC"     ,CNPJ     	,NIL})
AADD(ACABSA1,{"A1_COND"    ,CCOND		,NIL})
AADD(ACABSA1,{"A1_TABELA"  ,CTABELA 	,NIL})
AADD(ACABSA1,{"A1_END"     ,CEND	    ,NIL})
AADD(ACABSA1,{"A1_BAIRRO"  ,CBAIRRO	    ,NIL})  
AADD(ACABSA1,{"A1_CEP" 	   ,CCEP 	    ,NIL})
AADD(ACABSA1,{"A1_EMAIL"   ,CEMAIL	    ,NIL})
AADD(ACABSA1,{"A1_COMPLEM" ,CCOMPLE   	,NIL})
AADD(ACABSA1,{"A1_EST"     ,CUF      	,NIL})
AADD(ACABSA1,{"A1_NOME"    ,CNOME    	,NIL})
AADD(ACABSA1,{"A1_NREDUZ"  ,CNOME    	,NIL})
AADD(ACABSA1,{"A1_TIPO"    ,CTIPOCLI  	,NIL})
AADD(ACABSA1,{"A1_COD_MUN" ,CCIDADE    	,NIL})
AADD(ACABSA1,{"A1_SATIV1"  ,CATIVID   	,NIL})
AADD(ACABSA1,{"A1_VEND"    ,CVEND  		,NIL})
AADD(ACABSA1,{"A1_DDD"     ,CDDD     	,NIL})
AADD(ACABSA1,{"A1_TEL"     ,CTEL		,NIL})
AADD(ACABSA1,{"A1_INSCR"   ,CINSCRI		,NIL})     
AADD(ACABSA1,{"A1_INSCR"   ,CINSCRI		,NIL})
//AADD(ACABSA1,{"A1_XCODMAX" ,CCODNUV		,NIL})
	
BEGIN TRANSACTION

	MSEXECAUTO({|X,Y,Z|MATA030(X,Y,Z)},ACABSA1,NOPC) //ACIONA EXEC AUTO PARA INSERIR O NOVO REGISTRO.
		
	LRET := .F.
		
	IF LMSERROAUTO
		NSTATUS := 5	
		CCL     := ""    
		CERRO   := '"Cliente não foi cadastrado"'
		CSUCESS := '"RetornoImportacao": 3'
		//AUTOGRLOG("ERRO AO EXECUTAR IMPORTAçãO DOS PEDIDOS LANDIX")
		//AAUTOERRO := {}
		//AAUTOERRO := GETAUTOGRLOG()
		
		MOSTRAERRO()
	
		DISARMTRANSACTION()	
	ELSE
    	NSTATUS := 4    
    	CCL     := SA1->A1_COD+SA1->A1_LOJA  
    	CERRO   := '"Importado com Sucesso"'
	 	CSUCESS := '"RetornoImportacao": 2'
	ENDIF
		aaJson := Array(#)
        oObj   := NIL
		ADADOS  := {}
		ADADOSA := {}
        CRET2 := AOBJETO[YY]:OBJETO_JSON
		CRET2 := STRTRAN(CRET2,'"Codigo": ""','"Codigo": "'+CCL+'"')
		CRET2 := STRTRAN(CRET2,'"CriticaImportacao": ""','"CriticaImportacao": '+CERRO)
		CRET2 := STRTRAN(CRET2,'"RetornoImportacao": 1',CSUCESS)
		
		AADD(ADADOSA, {"Id_cliente", AOBJETO[YY]:ID_CLIENTE})								
		AADD(ADADOSA, {"Objeto_Json", CRET2})
		AADD(ADADOSA, {"Data", AOBJETO[YY]:DATA})
		AADD(ADADOSA, {"Status", NSTATUS})

		AADD(ADADOS, ADADOSA)

		U_BENVIA(ADADOS   ,"PUT"    , "RetornoClientes", "StatusClientes")        

	
END TRANSACTION
	          
RETURN

/*
Função para envio de email
*/
STATIC FUNCTION ENVMAIL(_cSubject, _cDest, _cBody, _cAtach)

  u_fxEnvMail(_cSubject, _cDest, _cBody, _cAtach)

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

//Le o array passado como parametro e coloca a posição de cada campo
For a:= 1 to len(aCampos)
	aadd(aWithPos,{aCampos[a,1],aCampos[a,2], aCampos[a,3], fxPos(aCampos[a,1])})
Next            

//Ordena o array de acordo com a posição dos campos
ASORT(aWithPos, , , { | x,y | x[4] < y[4] } )
              
//Monta o novo array somente com os campos originais, mas agora ordenado
For a:=1 to Len(aWithPos)
	aadd(aOrdenado,{aWithPos[a,1],aWithPos[a,2], aWithPos[a,3]})	
Next

Return aOrdenado