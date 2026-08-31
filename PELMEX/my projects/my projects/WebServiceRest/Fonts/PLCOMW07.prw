#include 'protheus.ch'
#include 'parmtype.ch'
#include 'RestFul.ch'
#include 'Totvs.ch'

user function EREST_04()

Return

Class GERPED

Data cNum	     As String
Data cNumAma     As String
Data cItem	     As String
Data cProduto 	 As String
Data cQtdPedido  As String
Data cValor      As String

Method New(cNum,cNumAma,cItem,cProduto,cQtdPedido,cValor) Constructor 

EndClass

Method New(xNum,xNumAma,xItem,xProduto,xQtdPedido,xValor) Class GERPED

::cNum        := xNum
::cNumAma     := xNumAma
::cItem       := xItem
::cProduto    := xProduto
::cQtdPedido  := xQtdPedido
::cValor      := xValor

Return(Self)

WSRESTFUL GERPED DESCRIPTION "Serviço REST para geração de Pedido de Compras Pelmex"

WSDATA cNum        As String
WSDATA cNumAma     As String
WSDATA cItem       As String
WSDATA cProduto    As String
WSDATA cQtdPedido  As String
WSDATA cValor      As String

WSMETHOD GET DESCRIPTION "Retorna a Pedido informada na URL" WSSYNTAX "/GERPED?cNum={valnum}&cNumAma={valnumama}&cItem={valitem}&cProduto={valproduto}&cQtdPedido={valqtdpedido}&cValor={valValor}"

END WSRESTFUL

WSMETHOD GET WSRECEIVE cNum,cNumAma,cItem,cProduto,cQtdPedido,cValor WSSERVICE GERPED
	Local cNum        := Self:cNum
	Local cNumAma     := Self:cNumAma
	Local cItem       := Self:cItem
	Local cProduto    := Self:cProduto
	Local cQtdPedido  := Self:cQtdPedido
	Local cValor      := Self:cValor
	
	Local aArea      := GetArea()
	Local oObjPED     := Nil
	Local cStatus    := ""
	Local cJson      := ""
	Local lRet       := ''

	::SetContentType("application/json")

	qout("Iniciando Processo para Criar Pedido...")
	
	lRet := PLGERPED(cNum,cNumAma,cItem,cProduto,cQtdPedido,cValor)
    cNum := lRet
	//DbSelectArea("SC2")
	//cCodProd := Posicione("SC2", 1, xFilial("SC2") + cOP,"C2_PRODUTO")

	If Empty(cProduto)
		Return .T.
	EndIf   

	DbSelectArea("SB1")
	SB1->( DbSetOrder(1) )
	If SB1->( DbSeek( xFilial("SB1") + cProduto ) )
		
			

		cStatus  := "PEDIDO CRIADO"

		
		oObjPED := GERPED():New(SB1->B1_DESC, cStatus)
	EndIf

	Conout("********************************************************")
	Conout("Pedido: "+cNum+" - "+cProduto+" - "+SB1->B1_DESC)
	
	if lret = 'T'
	Conout("Status: "+cStatus)
	endif
	Conout("********************************************************")

	cJson := FWJsonSerialize(oObjPED)

	::SetResponse(cJson)

	RestArea(aArea)
Return(.T.)
/*_______________________________________________________________________________
¦ Função    ¦ PLGERPED    ¦ Autor ¦ STAN LEE          ¦ Data ¦ 25/05/2022       ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Gera Ops Execauto			                                        ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PLGERPED(cNum,cNumAma,cItem,cProduto,cQtdPedido,cValor)
Local aCab   := {} //Array com os campos
Local aItem  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 3 - Inclusao ³
//³ 4 - Alteracao ³
//³ 5 - Exclusao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local nOpc := 3
Local xNum        := cNum
Local xNumAma     := cNumAma
Local xItem       := cItem
Local xProduto    := cProduto
Local nQtdPedido  := Val(cQtdPedido)
Local nValor      := Val(cValor)

Private lMsErroAuto := .F.

DbSelectArea("SB1")
SB1->( DbSetOrder(1) )
If SB1->( DbSeek( xFilial("SB1") + cProduto ) )	
		ConOut("Numero Pedido : "+xNum) 
		
		aCab:={{"C7_NUM",xNum,NIL},; // Numero do Pedido
				{"C7_FORNECE","001343",NIL},; // Fornecedor
				{"C7_LOJA","02",NIL},; // Loja do Fornecedor
				{"C7_CONTATO","PCP",NIL},; // Contato
				{"C7_EMISSAO",DATE(),NIL},; // EMISSAO
				{"C7_COND","007",NIL},; // Condicao de Pagamento
				{"C7_MOEDA","1",NIL},;
				{"C7_TXMOEDA",0,NIL},;
				{"C7_FILENT","01",NIL}}
				
		aItem:={{"C7_ITEM",xItem,NIL},;
				{"C7_PRODUTO",xProduto,NIL},;
				{"C7_LOCAL","01",NIL},;
				{"C7_CONTA",SB1->B1_CONTA,NIL},;
				{"C7_CC",SB1->B1_CC,NIL},;
				{"C7_DESCRI",SB1->B1_DESC,NIL},;
				{"C7_QUANT",nQtdPedido,NIL},;
				{"C7_QTDSOL",,NIL},;
				{"C7_PRECO",nValor,NIL},;
				{"C7_TOTAL",nValor*nQtdPedido,NIL},;
				{"C7_XPEDAMA",cNumAma,NIL}}
						
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se alteracao ou exclusao, deve-se posicionar no registro ³
		//³ da SC2 antes de executar a rotina automatica ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpc == 4 .Or. nOpc == 5
			SC2->(DbSetOrder(1))//FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
			SC2->(DbSeek(xFilial("SC7")+cNum))
		EndIf
		ConOut("Inicio : "+Time()) 
		
		MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},2,aCab,{aItem},nOpc,.F.)
		//MSExecAuto({|k,v,w,x,y,z| MATA120(k,v,w,x,y,z)},1,aCab,aItem,nOpc,,)
		If (!lMsErroAuto) // OPERAÇÃO FOI EXECUTADA COM SUCESSO
		    ConOut(PadC("ExecAuto MATA120 realizado com sucesso!", 80))
		    //ConfirmSx8()
		Else // OPERAÇÃO EXECUTADA COM ERRO
		    If (!IsBlind()) // COM INTERFACE GRÁFICA
		        MostraErro()
		    Else // EM ESTADO DE JOB
		        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
		
		        ConOut(PadC("ExecAuto MATA120 com erro.", 80))
		        ConOut("Error: "+ cError)
		    EndIf
		    //RollBackSX8()
		EndIf
		
		ConOut("Fim : "+Time())
		 
		//RESET ENVIRONMENT
EndIf		 
Return cNum                    