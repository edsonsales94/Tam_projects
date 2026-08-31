#include 'protheus.ch'
#include 'parmtype.ch'
#include 'RestFul.ch'
#include 'Totvs.ch'

user function EREST_02()

Return

Class GERAOP

Data cOP	     As String
Data cItem	     As String
Data cProduto 	 As String
Data cLocal 	 As String
Data cQtdPedido  As String
Data cDtProd     As String
Data cCarga      As String
Data cObservacao As String
Data cOPcao      As String

Method New(cOP,cItem,cProduto,cLocal,cQtdPedido,cDtProd,cCarga,cObservacao,cOpcao) Constructor 

EndClass

Method New(xOP,xItem,xProduto,xLocal,xQtdPedido,xDtProd,xCarga,xObservacao,xOpcao) Class GERAOP

::cOP         := xOP
::cItem       := xItem
::cProduto    := xProduto
::cLocal      := xLocal
::cQtdPedido  := xQtdPedido
::cDtProd     := xDtProd
::cCarga      := xCarga
::cObservacao := xObservacao
::cOpcao      := xOpcao

Return(Self)

WSRESTFUL GERAOP DESCRIPTION "Serviço REST para geração de OPs"

WSDATA cOP         As String
WSDATA cItem       As String
WSDATA cProduto    As String
WSDATA cLocal      As String
WSDATA cQtdPedido  As String
WSDATA cDtProd     As String
WSDATA cCarga      As String
WSDATA cObservacao As String
WSDATA cOpcao      As String

WSMETHOD GET DESCRIPTION "Retorna a OP informada na URL" WSSYNTAX "/GERAOP?cOp={valop}&cItem={valitem}&cProduto={valproduto}&cLocal={valLocal}&cQtdPedido={valqtdpedido}&cDtProd={valdtprod}&cCarga={valcarga}&cObservacao={valobsevacao}&cOpcao={valopcao}"

END WSRESTFUL

WSMETHOD GET WSRECEIVE cOP,cItem,cProduto,cLocal,cQtdPedido,cDtProd,cCarga,cObservacao,cOpcao WSSERVICE GERAOP
	Local cOP         := Self:cOP
	Local cItem       := Self:cItem
	Local cProduto    := Self:cProduto
	Local cLocal      := Self:cLocal
	Local cQtdPedido  := Self:cQtdPedido
	Local cDtProd     := Self:cDtProd
	Local cCarga      := Self:cCarga
	Local cObservacao := Self:cObservacao
	Local cOpcao      := Self:cOpcao
    
	Local aArea      := GetArea()
	Local oObjOP     := Nil
	Local cStatus    := ""
	Local cJson      := ""
	Local lRet       := ''

	::SetContentType("application/json")

	qout("Iniciando Processo para Criar OPs...")
	
	lRet := PLGERAOP(cOP,cItem,cProduto,cLocal,cQtdPedido,cDtProd,cCarga,cObservacao,cOpcao)
    cOp := lRet
	//DbSelectArea("SC2")
	//cCodProd := Posicione("SC2", 1, xFilial("SC2") + cOP,"C2_PRODUTO")

	If Empty(cProduto)
		Return .T.
	EndIf   

	DbSelectArea("SB1")
	SB1->( DbSetOrder(1) )
	If SB1->( DbSeek( xFilial("SB1") + cProduto ) )
		
			

		cStatus  := "OP CRIADA"

		
		oObjOP := GERAOP():New(SB1->B1_DESC, cStatus)
	EndIf

	Conout("********************************************************")
	Conout("OP: "+cOP+" - "+cProduto+" - "+SB1->B1_DESC)
	
	if lret = 'T'
	Conout("Status: "+cStatus)
	endif
	Conout("********************************************************")

	cJson := FWJsonSerialize(oObjOP)

	::SetResponse(cJson)

	RestArea(aArea)
Return(.T.)
/*_______________________________________________________________________________
¦ Função    ¦ PLGERAOP    ¦ Autor ¦ STAN LEE          ¦ Data ¦ 08/04/2022       ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Gera Ops Execauto			                                        ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PLGERAOP(cOP,cItem,cProduto,cLocal,cQtdPedido,cDtProd,cCarga,cObservacao,cOpcao)
Local aMATA650  := {} //Array com os campos


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 3 - Inclusao ³
//³ 4 - Alteracao ³
//³ 5 - Exclusao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local nOpc        := Val(cOpcao)
Local nQtdPedido  := Val(cQtdPedido)
Local xOp         := cOP
Local xItem       := cItem
Local xProduto    := cProduto
Local xLocal      := cLocal
Local xCarga      := cCarga
Local xObservacao := cObservacao
Local dDataBase   := CTOD(cDtProd)//CTOD("20/04/2022")
Local cJuncao     := ""

Private lMsErroAuto := .F.

//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
if nOpc == 3
	//cOP := GetSxEnum("SC2","C2_NUM")
	//cOP := GETSX8NUM('SC2','C2_NUM')
EndIf

ConOut("Numero Op : "+cOP +" qtd: "+Transform(nQtdPedido,"@E 9,999,999,999,999,999,999"))
Conout("Dt.Produçao: "+DTOC(dDataBase))

aMATA650 := {	{'C2_FILIAL' ,"01" ,NIL},;
				{'C2_ITEM' ,"01" ,NIL},; 
				{'C2_SEQUEN' ,"001" ,NIL},;
				{'C2_PRODUTO' ,xProduto,NIL},;
				{'C2_LOCAL' ,xLocal ,NIL},;
				{'C2_QUANT' ,nQtdPedido ,NIL},;
				{'C2_EMISSAO' ,dDataBase, ,NIL},;
				{'C2_DATPRI' ,dDataBase, ,NIL},;
				{'C2_DATPRF' ,(dDataBase+3), ,NIL},;
				{'C2_XCARGA' ,xCarga ,NIL},;
				{'C2_OBS' ,xObservacao ,NIL},;
				{'AUTEXPLODE' ,"S" ,NIL}}
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se alteracao ou exclusao, deve-se posicionar no registro ³
//³ da SC2 antes de executar a rotina automatica ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc == 4 .Or. nOpc == 5
	SC2->(DbSetOrder(1))//FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
	SC2->(DbSeek(xFilial("SC2")+cOP+cItem+"001"))
EndIf
ConOut("Inicio : "+Time()) 

msExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)

If (!lMsErroAuto) // OPERAÇÃO FOI EXECUTADA COM SUCESSO
    ConOut(PadC("ExecAuto Mata650 realizado com sucesso!", 80))
    //ConfirmSx8()
Else // OPERAÇÃO EXECUTADA COM ERRO
    If (!IsBlind()) // COM INTERFACE GRÁFICA
        MostraErro()
    Else // EM ESTADO DE JOB
        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO

        ConOut(PadC("ExecAuto Mata650 com erro.", 80))
        ConOut("Error: "+ cError)
    EndIf
    //RollBackSX8()
EndIf

ConOut("Fim : "+Time())
 
//RESET ENVIRONMENT
 
Return cOP                     
