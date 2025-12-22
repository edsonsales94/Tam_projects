#INCLUDE "rwmake.ch"
#Include "Protheus.ch"
#include "AP5MAIL.ch"
#include "tbiconn.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.ch"


*----------------------------------------------------------------------------------------------*
User Function VerPA(cProduto,lSB0,cLocal)
*----------------------------------------------------------------------------------------------*
// Verifica se o Produto escolhido é um Produto Acabado (KIT)

Local 	n_ColVrunit  := AScan( aHeader , {|x| Trim(x[2]) == "LR_VRUNIT" })
Local   lPA := .F.
Local cdFuncao := FunName()

SG1->(dbSetOrder(1))

If Alltrim(cdFuncao) $ 'LOJA701#FATA701'
	nPreco := &("SB0->B0_PRV"+M->LQ_PRCTAB)
else
	nPreco := &("SB0->B0_PRV1")
EndIf

If SG1->(dbSeek(xFilial("SG1")+cProduto))
	
	nRecSB0  := SB0->(RecNo())
	
	nPreco 	:= u_ExpEstr(cProduto,"VerPA",1,0)// Com explosão da estrutura - (GERAKIT.PRW)
	
	SB1->(DbSeek(xFilial("SB1")+cProduto))
	nPreco 	:= nPreco + (nPreco * (SB1->B1_ACRPROD/100)) // % de Acréscimo de Produção
	
	SB0->(DbGoto(nRecSB0))
	
	If Alltrim(SB1->B1_TIPO) == "PA"
		
		If lSB0   // Atualiza o Preço do Produto Acabado de acordo com a MPs definidas na Estrutura de Produtos (SG1)
			RecLock("SB0")
		Else
			RecLock("SB0",.T.)
			SB0->B0_FILIAL  := xFilial("SB0")
			SB0->B0_COD 	:= cProduto
		EndIf
		
		If Alltrim(cdFuncao) $ 'LOJA701#FATA701'
			If M->LQ_PRCTAB == "1"
				SB0->B0_PRV1 := nPreco
			Else
				SB0->B0_PRV2 := nPreco
			EndIf
		EndIf
		MsUnLock()
		
		If !SB9->(DbSeek(xFilial("SB9")+cProduto+cLocal)) // Inicializa os Saldos Iniciais
			RecLock("SB9",.T.)
			SB9->B9_FILIAL  := xFilial("SB9")
			SB9->B9_COD 	:= cProduto
			SB9->B9_LOCAL   := cLocal
			MsUnLock()
		Endif
		
	EndIf
	
	lPA := .T.
EndIf

Return(lPA)

*----------------------------------------------------------------------------------------------*
User Function SaldoOrc(cProduto)
*----------------------------------------------------------------------------------------------*
// Função que soma a quantidade de produtos com Orcamentos em abertos e NAO vencidos

Local cArea := ""

cArea := GetArea()

cQry2 := "SELECT ISNULL(SUM(L2_QUANT),0) SALDO "
cQry2 += " FROM "+RetSQLName("SL2")+" SL2,"+RetSQLName("SL1")+" SL1 "
cQry2 += " WHERE L2_PRODUTO = '"+cProduto+"' "
cQry2 += " AND L2_FILIAL = '"+xFilial("SL2")+"' "
cQry2 += " AND L1_FILIAL = '"+xFilial("SL1")+"' "
cQry2 += " AND L2_NUM = L1_NUM "
cQry2 += " AND L1_DTLIM >= '"+DTOS(dDataBase)+"' "
cQry2 += " AND SL1.D_E_L_E_T_ <> '*' AND SL2.D_E_L_E_T_ <> '*' "

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry2)), "TRB", .T., .F. )
nSaldo := SALDO

dbCloseArea()


RestArea(cArea)


Return(nSaldo)

//--------------------------------------------------------------------------------------------------------------------------------------------------
User Function RecAcols(nLinha)
//--------------------------------------------------------------------------------------------------------------------------------------------------
// Recalcula o Acols da Venda Assistida, após a escolha dos itens pela Tela de Pesquisa (CTRL+I)

Local nPosQuant		:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_QUANT"})][2]			// Posicao da Quantidade
Local nPosUnit		:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_VRUNIT"})][2]			// Posicao do Valor Unitário
Local nPosVlItem	:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_VLRITEM"})][2]		// Posicao do Valor Total

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+M->LQ_CLIENTE+M->LQ_LOJA))

If Acols[nLinha][nPosQuant] > 0 .And. Alltrim(SA1->A1_TIPO) == "L" // Se quantidade for maior que zero e for Produtor Rural, chama a função padrão do sistema
	
	If Alltrim(SB1->B1_TIPO)  <> "PA"
		Lj7VlItem( 3 )  				// Chama a LJ7VlItem para acerto dos totais na tela - desconto do item
	Else
		Lj7VlItem( 1 )  				// Chama a LJ7VlItem para acerto dos totais na tela - desconto na quantidade
	EndIf
	
EndIf

Return()


//--------------------------------------------------------------------------------------------------------------------------------------------------
User Function ExpEstr(cProduto,cRotina,nQtdLib,li)
//--------------------------------------------------------------------------------------------------------------------------------------------------
// Explode a Estrutura de Produtos para verificar se é Produto Acabado (KIT)
Local nReg, nSaldo 	:= 0
Local nValItens 	:= 0
Local cdFuncao := FunName()

lResp := .T.

SB0->(dbSetOrder(1))
SB1->(dbSetOrder(1))
SB2->(dbSetOrder(1))
SG1->(dbSetOrder(1))

nRegSB0 := SB0->(Recno())
nRegSB1 := SB1->(Recno())
nRegSB2 := SB2->(Recno())


While !SG1->(Eof()) .and. SG1->G1_COD = cProduto
	
	nRegSG1 := SG1->(Recno())
	
	SG1->(dbSetOrder(2))
	SG1->(dbSeek(xFilial("SG1")+SG1->G1_COMP))
	
	If !SG1->(Found())
		u_ExpEstr(SG1->G1_COD,cRotina,nQtdLib,li)
	EndIf
	
	SG1->(dbSetOrder(1))
	SG1->(dbGoto(nRegSG1))
	
	SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
	SB2->(dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD))
	SB0->(dbSeek(xFilial("SB0")+SG1->G1_COMP))
	If Alltrim(cdFuncao) $ 'LOJA701#FATA701'
		nPreco := &("SB0->B0_PRV"+M->LQ_PRCTAB)
	else
		If Empty(M->C5_TABELA)
			nPreco := &("SB0->B0_PRV1")
		else
			nPreco := Posicione("DA1",1,xFilial('DA1')+M->C5_TABELA+cProduto,"DA1_PRCVEN")
		EndIf
	EndIF
	nSaldo 		:= (nQtdLib*SG1->G1_QUANT)
	
	If cRotina $ "GERAKIT"
		GeraSaiMP()
	ElseIf cRotina == "VerPA"
		nValItens 	+= Round(nSaldo*nPreco,2)
	ElseIf cRotina == "ORCAMENTO"
		@ li,10  PSay SubStr(SB1->B1_COD,1,8)
		@ li,19  Psay SubStr(SB1->B1_DESC,1,50)
		@ li,70  PSay Transform(nSaldo,"@E 99,999.99")
		li++
		nValItens:=li
	EndIf
	
	SG1->(dbSkip())
	
End

SB0->(dbGoto(nRegSB0))
SB1->(dbGoto(nRegSB1))
SB2->(dbGoto(nRegSB2))

Return(nValItens)


//--------------------------------------------------------------------------------------------------------------------------------------------------
User Function TelaQuant(nTam,cProduto)
//--------------------------------------------------------------------------------------------------------------------------------------------------
// Função para calcular na tela com quantidade de metros por peças
Local bOk       := {|| nOpc:=1 , CalcMetros()}
Local bCancel   := {|| nOpc:=0 , oDlg1:End()}
Local oMetros   := Nil
Local oQuant    := Nil
Local oNome     := Nil
Private nMetros := 0
Private nQuant  := 0
Private nLinha  := nTam

SB1->(dbSeek(xFilial("SB1")+cProduto))
cNome := SB1->B1_DESC

DEFINE MSDIALOG oDlg1 TITLE "Calculo de Metros" From 20,60 To 33,97 //OF oMainWnd

@ 020, 005 MSGET oNome Var cNome PICTURE "@!" SIZE 120,7 PIXEL OF oDlg1 			When .F.

@ 040, 005 SAY "Metros  :" SIZE 70,7 PIXEL OF oDlg1

@ 040, 050 MSGET oMetros Var nMetros  PICTURE "@E 999,999.99" SIZE 60,7 PIXEL OF oDlg1

@ 060, 005 SAY "Peças   :" SIZE 70,7 PIXEL OF oDlg1

@ 060, 050 MSGET oQuant  Var nQuant   PICTURE "@E 999,999.99" SIZE 60,7 PIXEL OF oDlg1

ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,bOk,bCancel)

Return()


//--------------------------------------------------------------------------------------------------------------------------------------------------
Static Function CalcMetros()
//--------------------------------------------------------------------------------------------------------------------------------------------------
Local nTotMetros 	:= 0
Local nPosQuant		:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_QUANT"})][2]			// Posicao da Quantidade
Local nPosMetros	:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_METROS"})][2]			// Posicao de Metros
Local nPosQtBarras 	:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_QTBARRA"})][2]		// Posicao da Quantidade de Barras

oDlg1:End()

nTotMetros 					:= nMetros * nQuant
Acols[nLinha][nPosQuant]   	:= nTotMetros
Acols[nLinha][nPosMetros]   := nMetros
Acols[nLinha][nPosQtBarras] := nQuant

Return()

//---------------------------------------------------------------------------------------------------------------------------------------------------
User Function RecRodape(nTotal)
//---------------------------------------------------------------------------------------------------------------------------------------------------

// Funções Padrões do Sistema para Recalcular o Rodape da Tela da Venda Assistida

Lj7T_Subtotal	( 2, nTotal )
If Lj7T_DescV(2)>0
	Lj7T_DescV(2, 0)
	Lj7T_DescP(2, 0)
EndIf
Lj7T_Total( 2, Lj7T_Subtotal(2) - Lj7T_DescV(2) )

If aTotais[4][2] <= 0
	Lj7T_DescV(2, 0)
	Lj7T_DescP(2, 0)
	Lj7T_Total	( 2, Lj7T_Subtotal(2) - Lj7T_DescV(2) )
Endif
Lj7T_TotPar (2,nTotal)

aEval( aPgtos , {|x| aTotais[4,2]+=x[2],aTotais[5,2]+=x[2] })

aTotais[1,3]:Refresh()
aTotais[4,3]:Refresh()
aTotais[5,3]:Refresh()

Lj7ZeraPgtos( NIL, NIL, .F. )
aDesconto := { 0, 0, 0 }

aPgtos[Len(aPgtos),1] := dDataBase
aPgtos[Len(aPgtos),2] := nTotal
aPgtos[Len(aPgtos),3] := "R$"

oPgtos:SetArray( aPgtos )
oPgtos:Refresh()

If lVisuSint
	aPgtosSint := Lj7MontPgt(aPgtos)
	oPgtosSint:SetArray( aPgtosSint )
	oPgtosSint:Refresh()
EndIf

Return()

//---------------------------------------------------------------------------------------------------------------------------------------------------
User Function VDesc(I,nPosProd)
//---------------------------------------------------------------------------------------------------------------------------------------------------
// Verifica o % de Desconto existente na EXCECAO FISCAL (SF7)

DbSelectArea("SF7")  // Grupo de Tributação
DbSetOrder(1)

DbSelectArea("SB1")
DbSetOrder(1)

nDesc := 0

If SB1->(DbSeek(xFilial("SB1")+aCols[I][nPosProd]))
	
	If Alltrim(SB1->B1_GRTRIB) == "001" 				// Grupo de Tributação para Produtores Rurais (Cadastro de Exceção Fiscal)
		
		If SF7->(DbSeek(xFilial("SF7")+SB1->B1_GRTRIB)) // Grupo de Tributação
			
			nDesc := SF7->F7_ALIQINT  					// Desconto referente ao ICMS
			
		EndIf
		
	EndIf
	
EndIf

Return(nDesc)

//---------------------------------------------------------------------------------------------------------------------------------------------------
User Function BaixaSE1()
//---------------------------------------------------------------------------------------------------------------------------------------------------
// Baixa o Contas a Receber

RecLock("SE1")
SE1->E1_STATUS  := "B"
SE1->E1_BASCOM1 := SE1->E1_VLCRUZ
SE1->E1_BAIXA	:= dDataBase
SE1->E1_VALLIQ  := SE1->E1_VALOR
SE1->E1_SALDO	:= 0
SE1->E1_MOVIMEN := dDataBase
SE1->E1_PORTADO := IIf( Alltrim(SE1->E1_TIPO) $ "DV#CR#CD#CH","Z01",xNumCaixa())
SE1->E1_AGEDEP  := "."
SE1->E1_CONTA	:= "."

MsUnLock()

AtuSE5() // Atualizar as Movimentações Bancárias e Saldos Bancários

Return

//---------------------------------------------------------------------------------------------------------------------------------------------------
Static Function AtuSE5()
//---------------------------------------------------------------------------------------------------------------------------------------------------
// Baixa a Movimentação Bancária
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o Movimento bancario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                     ¶
Reclock("SE5" , .T. )
SE5->E5_FILIAL  := xFilial()
SE5->E5_FILORIG := SE1->( xFilial( "SE1" ))
SE5->E5_TIPODOC := "LJ"
SE5->E5_VALOR	:= SE1->E1_VALOR
SE5->E5_BANCO	:= IIf(Alltrim(SE1->E1_TIPO) $ "DV#CR#CD#CH","Z01",xNumCaixa())
SE5->E5_AGENCIA := "."
SE5->E5_CONTA	:= "."
SE5->E5_DATA	:= dDataBase
SE5->E5_DTDIGIT := dDataBase
SE5->E5_DTDISPO := dDataBase
SE5->E5_PREFIXO := SE1->E1_PREFIXO
SE5->E5_NUMERO  := SE1->E1_NUM
SE5->E5_PARCELA := SE1->E1_PARCELA
SE5->E5_TIPO	:= SE1->E1_TIPO
SE5->E5_SEQ 	:= "01"
SE5->E5_NATUREZ := SE1->E1_NATUREZ
SE5->E5_CLIFOR  := SE1->E1_CLIENTE
SE5->E5_CLIENTE := SE1->E1_CLIENTE
SE5->E5_LOJA	:= SE1->E1_LOJA
SE5->E5_RECPAG  := "R"
SE5->E5_HISTOR  := " BAIXA REF VENDA "
SE5->E5_MOTBX	:= "NOR"
MsUnlock()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza saldo do BANCO Caixa ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,;
SE5->E5_DTDISPO,SE5->E5_VALOR,"+")

Return



User Function VSuperior()
// Pesquisa o SUPERIOR e retorna o código do vendedor


Local cCodVend  := Space(06)

DbSelectArea("SA3")
nIndSA3 := IndexOrd()
nRecSA3 := SA3->(RecNo())

SA3->(DbSetOrder(7))  // Cod. Usuário


If SA3->(DbSeek(xFilial("SA3")+__cUserID))
	
	If Alltrim(SA3->A3_TIPO) == "S"   // Superior
		cCodVend 	:= SA3->A3_COD
	Endif
	
EndIf

SA3->(DbSetOrder(nIndSA3))
SA3->(DbGoto(nRecSA3))

Return(cCodVend)


//-------------------------------------------------------------------------------------------------------------------------------------------
User Function AtDescItm()
//-------------------------------------------------------------------------------------------------------------------------------------------
// Calcula o Percentual de Desconto quando o cliente for Produtor Rural

SF7->(DbSetOrder(1))

If SF7->(DbSeek(xFilial("SF7")+"001")) 					// Pesquisa o Grupo de Tributação (Exceção Fiscal)
	
	nDesc := SF7->F7_ALIQINT  							// Desconto referente ao ICMS
	
EndIf

nDescTotal := Round(SL1->L1_VLRTOT * (nDesc/100),2)  	// Valor do desconto de PRODUTOR já abatido o VALOR DO RODAPÉ na Venda Assistida

Begin Transaction

RecLock("SL1")
SL1->L1_DESCVEN := SL1->L1_DESCONT  										// Armazena o valor do desconto dado pelo Vendedor/Gerente
SL1->L1_PDESVEN := SL1->L1_DESCNF											// Armazena o percentual desconto dado pelo Vendedor/Gerente
SL1->L1_VLRVEND := SL1->L1_VLRTOT											// Armazena o valor do total da venda (-) o desconto do rodapé
SL1->L1_DESCRUR := nDescTotal												// Desconto do PRODUTOR RURAL

SL1->L1_DESCONT += nDescTotal												// Atualiza mais o valor do NOVO desconto com o valor do vendedor
SL1->L1_DESCNF  := Round((SL1->L1_DESCONT / SL1->L1_VALMERC)*100,2)    		// Calcula o novo percentual de desconto
SL1->L1_VLRTOT  := Round(SL1->L1_VALMERC - SL1->L1_DESCONT,2)				// Atualiza o valor liquido como o novo valor de desconto
SL1->L1_VLRLIQ  := Round(SL1->L1_VALMERC - SL1->L1_DESCONT,2)               // Atualiza o valor liquido como o novo valor de desconto
SL1->L1_VALBRUT := Round(SL1->L1_VALMERC - SL1->L1_DESCONT,2)				// Atualiza o valor liquido como o novo valor de desconto
SL1->L1_ENTRADA := Round(SL1->L1_VALMERC - SL1->L1_DESCONT,2)				// Atualiza o valor liquido como o novo valor de desconto

// Atualiza o valor de cada forma de pagamento com o desconto do PRODUTOR RURAL, pois o desconto do vendedor já foi salvo
Do Case
	Case SL1->L1_DINHEIRO > 0
		SL1->L1_DINHEIRO  := Round(SL1->L1_DINHEIRO - (SL1->L1_DINHEIRO * (nDesc/100)),2)
	Case SL1->L1_CHEQUES  > 0
		SL1->L1_CHEQUES   := Round(SL1->L1_CHEQUES  - (SL1->L1_CHEQUES  * (nDesc/100)),2)
	Case SL1->L1_CARTAO   > 0
		SL1->L1_CARTAO    := Round(SL1->L1_CARTAO   - (SL1->L1_CARTAO   * (nDesc/100)),2)
	Case SL1->L1_CONVENI  > 0
		SL1->L1_CONVENI   := Round(SL1->L1_CONVENI  - (SL1->L1_CONVENI  * (nDesc/100)),2)
	Case SL1->L1_VALES    > 0
		SL1->L1_VALES     := Round(SL1->L1_VALES    - (SL1->L1_VALES    * (nDesc/100)),2)
	Case SL1->L1_FINANC   > 0
		SL1->L1_FINANC    := Round(SL1->L1_FINANC   - (SL1->L1_FINANC   * (nDesc/100)),2)
	Case SL1->L1_OUTROS   > 0
		SL1->L1_OUTROS    := Round(SL1->L1_OUTROS   - (SL1->L1_OUTROS   * (nDesc/100)),2)
EndCase

MsUnLock()


SL4->(DbSeek(xFilial("SL4")+SL1->L1_NUM))
Do While ! SL4->(Eof()) .And. SL4->(L4_FILIAL+L4_NUM) == SL1->(L1_FILIAL+L1_NUM)
	
	RecLock("SL4")
	SL4->L4_VALPAR := SL4->L4_VALOR   												// Armazena o valor da parcela antes de recalcular, caso precise restaurar
	SL4->L4_VALOR  := Round(SL4->L4_VALOR - (SL4->L4_VALOR * (nDesc/100)),2)      	// Recalcula o valor da parcela com o desconto do PRODUTOR RURAL
	MsUnLock()
	
	SL4->(DbSkip())
	
EndDo

End Transaction

MsgAlert("Valor do Desconto - PRODUTOR RURAL : R$ "+Transform(nDescTotal,"@E 999,999,999.99"),"ATENÇÃO")

Return()

//-------------------------------------------------------------------------------------------------------------------------------------------
User Function RestVlr()
//-------------------------------------------------------------------------------------------------------------------------------------------
// Restaura o valor original quando a opção for FINALIZAR VENDA e o cliente for PRODUTOR RURAL

If SL1->L1_DESCRUR > 0   								// Se o valor de venda já foi atualizado
	
	Begin Transaction
	
	RecLock("SL1")
	SL1->L1_DESCONT := SL1->L1_DESCVEN					// Valor original de Desconto, fornecido pelo o vendedor / Gerente
	SL1->L1_DESCNF  := SL1->L1_PDESVEN					// Valor original do Percentual de Desconto, fornecido pelo o vendedor / Gerente
	SL1->L1_VLRTOT  := SL1->L1_VLRVEND					// Valor original da Venda
	SL1->L1_VLRLIQ  := SL1->L1_VLRVEND					// Valor original da Venda
	SL1->L1_VALBRUT := SL1->L1_VLRVEND					// Valor original da Venda
	MsUnLock()
	
	// Restaura o valor original das parcelas
	SL4->(DbSeek(xFilial("SL4")+SL1->L1_NUM))
	Do While ! SL4->(Eof()) .And. SL4->(L4_FILIAL+L4_NUM) == SL1->(L1_FILIAL+L1_NUM)
		
		RecLock("SL4")
		SL4->L4_VALOR  := SL4->L4_VALPAR				// Valor Original de cada parcela da Venda
		MsUnLock()
		
		SL4->(DbSkip())
		
	EndDo
	
	End Transaction
	
EndIf

Return()

//-------------------------------------------------------------------------------------------------------------------------------------------
User Function NFE(cProduto)
//-------------------------------------------------------------------------------------------------------------------------------------------
// Lista as Notas de Entrada de determinado Produto
cQry := "SELECT * "
cQry += "FROM "+RetSqlName("SD1")+" A "
cQry += "WHERE D1_COD = '"+cProduto+"' AND "
cQry += "D1_TIPO = 'N' AND "
cQry += "D1_TES <> '' AND "
cQry += "D1_CF NOT IN ('1152','2152','3152') AND "		// Codigo Fiscal de Transferência entre Lojas
cQry += "D_E_L_E_T_ <> '*' "

cQry += "ORDER BY R_E_C_N_O_ DESC "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'NFE', .F., .T.)

DbSelectArea("NFE")

DbSelectArea("SZB")
DbSetOrder(1)

nConta 		:= 1
aNFE        := {}
nCustAquis  := 0

Do While !NFE->(Eof()) .And. nConta <= 5
	
	If SZB->(DbSeek(xFilial("SZB")+NFE->D1_DOC+NFE->D1_SERIE+NFE->D1_FORNECE+NFE->D1_LOJA+NFE->D1_COD))
		nCustAquis := SZB->ZB_AQUISIC      // Custo Unitário da Formação de preço
	EndIf
	
	nCusto1 :=NFE->D1_CUSTO/NFE->D1_QUANT
	//	                         1                             2              3            4         5              6                7
	AADD(aNFE,{NFE->D1_DOC+"-"+NFE->D1_SERIE, STOD(NFE->D1_DTDIGIT), NFE->D1_QUANT, nCusto1, NFE->D1_CUSTO, nCustAquis, nCustAquis * NFE->D1_QUANT })
	
	nConta++
	NFE->(DbSkip())
	
EndDo
NFE->(DbCloseArea())

Return(aNFE)


//-------------------------------------------------------------------------------------------------------------------------------------------
User Function Consumo(cProduto, nMes, nAno)
//-------------------------------------------------------------------------------------------------------------------------------------------
// Função que analisa o consumo dos produtos de acrodo com os parâmetros enviados

Do Case
	Case nMes == 1
		dDtIni := CTOD("01/01/"+Str(nAno))
		dDtFim := CTOD("31/01/"+Str(nAno))
	Case nMes == 2
		dDtIni := CTOD("01/02/"+Str(nAno))
		dDtFim := CTOD("28/02/"+Str(nAno))
	Case nMes == 3
		dDtIni := CTOD("01/03/"+Str(nAno))
		
		dDtFim := CTOD("31/03/"+Str(nAno))
	Case nMes == 4
		dDtIni := CTOD("01/04/"+Str(nAno))
		dDtFim := CTOD("30/04/"+Str(nAno))
	Case nMes == 5
		dDtIni := CTOD("01/05/"+Str(nAno))
		dDtFim := CTOD("31/05/"+Str(nAno))
	Case nMes == 6
		dDtIni := CTOD("01/06/"+Str(nAno))
		dDtFim := CTOD("30/06/"+Str(nAno))
	Case nMes == 7
		dDtIni := CTOD("01/07/"+Str(nAno))
		dDtFim := CTOD("31/07/"+Str(nAno))
	Case nMes == 8
		dDtIni := CTOD("01/08/"+Str(nAno))
		dDtFim := CTOD("31/08/"+Str(nAno))
	Case nMes == 9
		dDtIni := CTOD("01/09/"+Str(nAno))
		dDtFim := CTOD("30/09/"+Str(nAno))
	Case nMes == 10
		dDtIni := CTOD("01/10/"+Str(nAno))
		dDtFim := CTOD("31/10/"+Str(nAno))
	Case nMes == 11
		dDtIni := CTOD("01/11/"+Str(nAno))
		dDtFim := CTOD("30/11/"+Str(nAno))
	Case nMes == 12
		dDtIni := CTOD("01/12/"+Str(nAno))
		dDtFim := CTOD("31/12/"+Str(nAno))
EndCase

If Val(DTOS(dDtIni)) - Val(DTOS(CTOD("06/01/09"))) < 0     // Devido a implantacao do sistema, considera o mes de Jan/09 o CONSUMO MEDIO
	nConsumo := &("SB3->B3_Q"+StrZero(nMes, 2))
Else
	cQry := "SELECT SUM(D3_QUANT) AS QUANT "
	cQry += "FROM "+RetSqlName("SD3")+" A "
	cQry += "WHERE  "                        //D3_FILIAL = '"+xFilial("SD3")+"' AND "  - NÃO HÁ FILIAL DEVIDO MOSTRAR O CONSUMO DE TODAS AS LOJAS
	cQry += "D3_COD = '"+cProduto+"' AND "
	cQry += "D3_EMISSAO >= '"+DTOS(dDtIni)+"' AND D3_EMISSAO <= '"+DTOS(dDtFim)+"' AND "
	cQry += "D3_ESTORNO <> 'S' AND "
	cQry += "D3_TM > '500' AND  D3_TM <> '555' AND "
	cQry += "D_E_L_E_T_ <> '*'"
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'SOMA', .F., .T.)
	
	DbSelectArea("SOMA")
	nSD3 := QUANT
	
	DbCloseArea()
	
	cQry := "SELECT SUM(D2_QUANT) AS QUANT "
	cQry += "FROM "+RetSqlName("SD2")+" A "
	cQry += "WHERE " 					//D2_FILIAL = '"+xFilial("SD2")+"' AND " - NÃO HÁ FILIAL DEVIDO MOSTRAR O CONSUMO DE TODAS AS LOJAS
	cQry += "D2_COD = '"+cProduto+"' AND "
	cQry += "D2_EMISSAO >= '"+DTOS(dDtIni)+"' AND D2_EMISSAO <= '"+DTOS(dDtFim)+"' AND "
	cQry += "D2_TIPO = 'N' AND D2_CF NOT IN ('5929','6929','7929','5152','6152','7152') AND "  // Codigo Fiscal de Nota Fiscal para Cupom e Transferência entre Lojas
	cQry += "D_E_L_E_T_ <> '*'"
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'SOMA', .F., .T.)
	
	DbSelectArea("SOMA")
	nSD2 := QUANT
	DbCloseArea()
	
	cQry := "SELECT SUM(D1_QUANT) AS QUANT "
	cQry += "FROM "+RetSqlName("SD1")+" A "
	cQry += "WHERE " 					//D1_FILIAL = '"+xFilial("SD1")+"' AND " - NÃO HÁ FILIAL DEVIDO MOSTRAR O CONSUMO DE TODAS AS LOJAS
	cQry += "D1_COD = '"+cProduto+"' AND "
	cQry += "D1_EMISSAO >= '"+DTOS(dDtIni)+"' AND D1_EMISSAO <= '"+DTOS(dDtFim)+"' AND "
	cQry += "D1_TIPO = 'D' AND "
	cQry += "D1_CF NOT IN ('1152','2152','3152') AND "		// Codigo Fiscal de Transferência entre Lojas
	cQry += "D_E_L_E_T_ <> '*'"
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'SOMA', .F., .T.)
	
	DbSelectArea("SOMA")
	nSD1 := QUANT
	DbCloseArea()
	
	nConsumo := (nSD2+nSD3)-nSD1
	nConsumo *= Iif(nConsumo < 0,-1,1)
	
EndIf

Return(nConsumo)

//-------------------------------------------------------------------------------------------------------------------------------------------
User Function Mes(nMes)
//-------------------------------------------------------------------------------------------------------------------------------------------
// Retorna o Nome do Mês
Do Case
	
	Case nMes = 1
		cMes := "JANEIRO  "
	Case nMes = 2
		cMes := "FEVEREIRO"
	Case nMes = 3
		cMes := "MARCO    "
	Case nMes = 4
		cMes := "ABRIL    "
	Case nMes = 5
		cMes := "MAIO     "
	Case nMes = 6
		cMes := "JUNHO    "
	Case nMes = 7
		cMes := "JULHO    "
	Case nMes = 8
		cMes := "AGOSTO   "
	Case nMes = 9
		cMes := "SETEMBRO "
	Case nMes = 10
		cMes := "OUTUBRO  "
	Case nMes = 11
		cMes := "NOVEMBRO "
	Case nMes = 12
		cMes := "DEZEMBRO "
EndCase

Return(cMes)


/*------------------------------------------------------------------------------------------*/
User Function SenhaSup(cNome,cCodUsr)
/*------------------------------------------------------------------------------------------*/

If cNome <> "LJ7018"     // Qualquer PE diferente de LJ7018
	Private cPassWord := Space(06)
	Private cUsuario  := IIf(Empty(cCodUsr),Space(06),cCodUsr)
	Private cPE       := cNome
	Private lRetAut   := .T.
EndIf

Public  nLastKe2    := 0


// Função de Senhas do SUPERIOR

Define Font oFnt3 Name "Ms Sans Serif" Bold

Define Msdialog oSenhas Title "AUTORIZACAO" From 190,110 to 300,370 Pixel
@ 005,004 Say "Usuario   :" Size 220,10 Of oSenhas Pixel Font oFnt3
@ 005,050 Get cUsuario    F3 "SA3" Picture "@!" //Pixel of oSenhas

@ 015,004 Say "Senha   :" Size 220,10 Of oSenhas Pixel Font oFnt3
@ 015,050 Get cPassWord   Picture "@!"  Valid .T.  PASSWORD  Object oSenha

@ 035,042 BmpButton Type 1 Action u_ValidaSenha(.T.,cUsuario,cPassword,cPE)

If !Empty(cUsuario)
	oSenha:SetFocus()
EndIf
Activate Dialog oSenhas Centered

u_ValidaSenha(.F.,cUsuario,cPassword,cPE)// por diego

Return(lRetAut)

/*------------------------------------------------------------------------------------------*/
User Function ValidaSenha(lClose,cUsuario,cPassWord,cPE)
/*------------------------------------------------------------------------------------------*/
// Valida SENHA informada na Tela de Senha

If lClose
	Close(oSenhas)
EndIf

If SA3->(DbSeek(XFilial("SA3")+cUsuario))  	// Pesquisa o novo usuário
	
	nPerDescSup := SA3->A3_PERDESC  		// Percentual de Desconto do CAIXA SUPERIOR
	
	If cPassWord == SA3->A3_SENHA           // Verifica se a senha é Valida
		
		If cPE $ "LJ7032#LJ700A1"   		// Chamado somente nos PEs LJ7001 e LJ7032
			
			If cUsuario <> SL1->L1_VEND		// Compara se eh o mesmo vendedor do orcamento
				
				If SA3->A3_TIPO <> "S" 		// Verifica se o USUARIO possui permissao de SUPERIOR
					MsgAlert("Usuário não é responsável pelo Orçamento ou não é SUPERIOR !!!!","ATENÇÃO")
					lRetAut := .F.
				Else
					lRetAut := .T.
				EndIf
			Else
				lRetAut := .T.
			EndIf
			
		Else
			
			If SA3->A3_TIPO == "S"   				// Verifica se o USUARIO possui permissao de SUPERIOR
				
				If nDescPer > nPerDescSup           // Verifica se o Percentual de Desconto é maior que o permitido pelo CAIXA SUPERIOR
					MsgAlert("Desconto maior que o permitido a este Superior !!!!","ATENÇÃO")
					lRetAut := .F.
				Else
					
					If cPE == "LJ7018"  								// Executa somente se o PE for LJ7018
						CalcLucro(nDescPer,0,.F.) 						// Calcula o Lucro - Descontos (% Desconto, Taxa da Administradora Financeira, Não recalcular os valores com Desconto)
						nPLucroDinh := nPLucro
						nPLucroDinh := Codifica(Round(nPLucroDinh,2)) 	// Codifica o valor do Percentual do Lucro para demonstrar na Tela
						MostraTela() 									// Mostra a Tela com o % Lucro - Desconto e % Lucro sobre as Administradoras Financeiras
						cCaixa := SA3->A3_COD
						lRetAut := .T.
					Endif
					
				EndIf
				
			Else
				MsgAlert("Usuario nao é SUPERIOR !!!","ATENÇÃO")
				lRetAut := .F.
			EndIf
			
		Endif
		
	Else
		
		MsgAlert("Senha Incorreta !!!","ATENÇÃO")
		lRetAut := .F.
		
	EndIf
Else
	MsgAlert("Código de Superior Inexistente !!!","ATENÇÃO")
	lRetAut := .F.
EndIf

If ! cPE $ "LJ7032#VSALPROD"
	SA3->(DbGoto(nRecSA3))
Endif
nLastKe2 := 1

Return(lRetAut)


User Function AASetDesc(nLinha)

Local aPos := {}
Local lRet := .T.
aAdd(aPos,AScan(aHeader ,{|x| AllTrim(x[2]) == "LR_VRUNIT" }) )
aAdd(aPos,Ascan(aHeader ,{|x| Alltrim(x[2]) == "LR_QUANT"  }) )
aAdd(aPos,Ascan(aHeader ,{|x| Alltrim(x[2]) == "LR_VLRITEM"}) )
aAdd(aPos,AScan(aHeader ,{|x| AllTrim(x[2]) == "LR_DESC"   }) )
aAdd(aPos,AScan(aHeader ,{|x| AllTrim(x[2]) == "LR_VALDESC"}) )

/*
If M->LR_VlRITEM = 0

M->LR_VRUNIT := 0.01
// Valor Unitario
M->LR_DESC := Round(M->LR_QUANT * M->LR_VRUNIT * 100 / M->LR_VLRITEM,2)
// percentual Desconto
M->LR_VALDESC := round( (M->LR_QUANT * M->LR_VRUNIT) * M->LR_DESC / 100,2)
//Valor Desconto
M->LR_VLRITEM := M->LR_QUANT * M->LR_VRUNIT
// Valor Total

EndIf
*/
Return lRet


User Function AAVALPRD(cdNumOs)
Local nPosItem  := 0
Local lShowTela := .F.

nPosItem := aScan(aHeader,{|x| Alltrim(x[2]) = "LR_PRODUTO"} )

If nPosItem = 0
	nPosItem := aScan(aHeader,{|x| Alltrim(x[2]) = "C6_PRODUTO"})
EndIf

aEval(aCols,{|x| lShowTela := iIf(!lShowTela, Posicione("SBM",1,xFilial("SBM")+ Posicione("SB1",1,xFilial('SB1') + x[nPosItem],"B1_GRUPO"),"BM_XEXIGOS") = 'S',lShowTela) })

if lShowTela
	cdNumOs := u_AAGETOS(cdNumOs)
else
	cdNumOs := ''
EndIf

Return cdNumOs



User Function AAGETOS(cdNumOs)


cdNumOs := cdNumOs + Space(40 - Len(cdNumOs) )
lClose  := .F.
Define Font oFnt3 Name "Ms Sans Serif" Bold

while Empty(cdNumOs) .Or. !lClose
	lClose := .T.
	Define Msdialog oDialog Title "Quantidade" From 190,110 to 300,370 Pixel //STYLE nOR(WS_VISIBLE,WS_POPUP)
	@ 005,004 Say "Numero OS :" Size 220,10 Of oDialog Pixel Font oFnt3
	@ 005,050 Get cdNumOs        Size 50,10  Picture "@!" Pixel of oDialog
	
	@ 035,042 BmpButton Type 1 Action ( nRet := iIf(!Empty(cdNumOs),oDialog:End(),nil) )
	
	Activate Dialog oDialog Centered
	
Enddo

Return cdNumOs

User Function Calcpeso(aVet,nLinp,nVal,nd_Peso,aCampo,cChave,cTable)

Local cdFuncao  := FunName()
Local n_ColProduto := 0
Local n_ColQuant   := 0
Local n_ColUm      := 0

Default aVet    := {}
Default nLinp   := 0
Default nVal    := 0
Default nd_peso := 0
Default aCampo  := {"SD2->D2_COD"	, "SD2->D2_QUANT", "SD2->D2_DOC", "SD2->D2_UM"}
Default cChave  := "SF2->F2_DOC"
Default cTable  := "SD2"


iF Len(aVet) != 0
	If Alltrim(cdFuncao) $ 'LOJA701#FATA701'
		n_ColProduto := AScan( aHeader , {|x| Trim(x[2]) == "LR_PRODUTO" })
		n_ColQuant   := AScan( aHeader , {|x| Trim(x[2]) == "LR_QUANT" })
		n_ColUm      := AScan( aHeader , {|x| Trim(x[2]) == "LR_UM" })
	Else
		n_ColProduto := AScan( aHeader , {|x| Trim(x[2]) == "C6_PRODUTO" })
		n_ColQuant   := AScan( aHeader , {|x| Trim(x[2]) == "C6_QTDVEN" })
		n_ColUm      := AScan( aHeader , {|x| Trim(x[2]) == "C6_UM" })
	EndIf
EndIf
If n_ColProduto != 0  .And. Len(aVet) != 0
	if nLinp > 0
		nd_Peso -= iIf( aCols[nLinp][n_ColUm]="KG",aCols[nLinp][n_ColQUant],  iIf(ConvUm(x[n_ColProduto],x[n_ColQUant] ,0,2)=0, Posicione("SB1",1,xFilial('SB1')+x[n_ColProduto],"B1_PESO") * x[n_ColQUant],ConvUm(x[n_ColProduto],x[n_ColQUant] ,0,2) )  )
		nd_peso += nValor
	else
		nd_peso := 0
		aeval(aVet,{|x| nd_Peso += iIf( x[n_ColUm]="KG",x[n_ColQUant], iIf(ConvUm(x[n_ColProduto],x[n_ColQUant] ,0,2)=0, Posicione("SB1",1,xFilial('SB1')+x[n_ColProduto],"B1_PESO") * x[n_ColQUant],ConvUm(x[n_ColProduto],x[n_ColQUant] ,0,2)))   } )
	EndIf
else
	nd_peso := 0
	While !(cTable)->(EOF()) .And. &(aCampo[03]) == &(cCHave)
		nd_peso += iIF( &(aCampo[04])=="KG",&(aCampo[02]), iIF(convum(&(aCampo[01]),&(aCampo[02]), 0,2)=0 .Or. &(aCampo[04]) == Posicione("SB1",1,xFilial('SB1')+&(aCampo[01]),"B1_SEGUM"),  Posicione("SB1",1,xFilial('SB1')+&(aCampo[01]),"B1_PESO") * &(aCampo[02]), convum(&(aCampo[01]),&(aCampo[02]), 0,2) )  )
		(cTable)->(dbSKip())
	EndDo
	
EndIf

Return nd_peso

User Function AtuSZG(nTipo)
iF M->LQ_ENTREGA = 'N'
	Return .T.
EndIf
For nK := 1 To Len(aCols)
	u_GetSZG(nK,nTipo)
Next
Return .T.


// *************************************************************************************************************************

User Function GetSZG(nLinha,nTipo)

 Local lRet := .T.
 Default nTipo := 1
 
	aPos := {}
	If nTipo == 1
			aAdd(aPos, aScan(aHeader,{|x| x[02] == "LR_PRODUTO" }))
			aAdd(aPos, aScan(aHeader,{|x| x[02] == "LR_TES" }))
			aAdd(aPos, aScan(aHeader,{|x| x[02] == "LR_ENTBRAS"}))
		else
			aAdd(aPos, aScan(aHeader,{|x| x[02] == "L2_PRODUTO" }))
			aAdd(aPos, aScan(aHeader,{|x| x[02] == "L2_TES" }))
			aAdd(aPos, aScan(aHeader,{|x| x[02] == "L2_ENTBRAS"}))
	EndIf
	
	If M->LQ_ENTREGA = 'N' .Or. FWCodEMp() <> "01"
		Return .T.
	EndIf

	SB1->(dbSetORder(1))
	lExiste := .F.
	
	If SB1->(dbSeek(xFilial('SB1')+aCols[nLinha][aPos[01]]))
		SA1->(dbSetOrder(1))

		If SA1->(dbSeek(xFilial('SA1') + M->LQ_CLIENTE + M->LQ_LOJA))
		// Verificando se o Cliente e do Estado do Amazonas para verificar a regra do ESTTRIB
			If SA1->A1_EST = 'AM'
					// Posiciona no indice 1 ta Tabela SZG
					SZG->(dbSetOrder(1))
					
					// Posiciona na primeira regra para o Produto caso exista alguma senao posicionara na regra do grupo
					If SZG->(dbSeek(xfilial('SZG') + PADR(SB1->B1_COD,Len(SZG->ZG_GRUPO))  ))
						lExiste := .F.
						// Procurando regra para o Produto Valida caso exista alguma
						While xfilial('SZG') + PADR(SB1->B1_COD,Len(SZG->ZG_GRUPO)) == SZG->(ZG_FILIAL + ZG_GRUPO) .And. !lExiste
							// verifica se o Cliente esta na regra do TIPTRIP e ESTTRIB = 'D' referente a cliente de dentro do Estado
							lExiste := SA1->A1_XTRBSAI $ SZG->ZG_TIPTRIP .And. SZG->ZG_ESTTRIB = 'D'
							// caso nao esteja na regra vai para a proxima regra do produto
							IF !lExiste
								SZG->(dbSkip())
							EndIf
						EndDo
					// Caso nao encontre a regra por produto, pesquisa pelo grupo do produto
				ElseIf SZG->(dbSeek(xfilial('SZG') + PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO))  ))
					lExiste := .F.
					// Procurando regra para o Produto Valida caso exista alguma
					While xfilial('SZG') + PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO)) == SZG->(ZG_FILIAL + ZG_GRUPO) .And. !lExiste
						// verifica se o Cliente esta na regra do TIPTRIP e ESTTRIB = 'D' referente a cliente de dentro do Estado
						lExiste := SA1->A1_XTRBSAI $ SZG->ZG_TIPTRIP .And. SZG->ZG_ESTTRIB = 'D'
						// caso nao esteja na regra vai para a proxima regra do produto
						IF !lExiste
							SZG->(dbSkip())
						EndIf
					EndDo
			EndIf
			// Trata Caso o Cliente seja da Area de Livre Comercio
		elseiF SA1->A1_XLIVCOM
			
			SZG->(dbSetOrder(1))
			// Posiciona na primeira regra para o Produto caso exista alguma senao posicionara na regra do grupo
			If SZG->(dbSeek(xfilial('SZG') + PADR(SB1->B1_COD,Len(SZG->ZG_GRUPO) )))//Tratamento para o Codigo
				lExiste := .F.
				// Procurando regra para o Produto Valida caso exista alguma
				While xfilial('SZG') + PADR(SB1->B1_COD,Len(SZG->ZG_GRUPO)) == SZG->(ZG_FILIAL + ZG_GRUPO) .And. !lExiste
					// verifica se o Cliente esta na regra do TIPTRIP e ESTTRIB = 'L' referente a regra de clientes da area de Livre Comercio
					lExiste := SA1->A1_XTRBSAI $ SZG->ZG_TIPTRIP .And. SZG->ZG_ESTTRIB = 'L'
					IF !lExiste
						SZG->(dbSkip())
					EndIf
				EndDo
				// Posiciona na primeira regra para o Produto caso exista alguma senao posicionara na regra do grupo
			ElseIf SZG->(dbSeek(xfilial('SZG') + PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO))  ))
				lExiste := .F.
				// Procurando regra para o Produto Valida caso exista alguma
				While xfilial('SZG') + PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO)) == SZG->(ZG_FILIAL + ZG_GRUPO) .And. !lExiste
					// verifica se o Cliente esta na regra do TIPTRIP e ESTTRIB = 'L' referente a regra de clientes da area de Livre Comercio
					lExiste := SA1->A1_XTRBSAI $ SZG->ZG_TIPTRIP .And. SZG->ZG_ESTTRIB = 'L'
					IF !lExiste
						SZG->(dbSkip())
					EndIf
				EndDo
			EndIf
			// referente a Clientes do exterior que nao estao na area de Livre COmercio
		else		   
			SZG->(dbSetOrder(1))
			// Posiciona na primeira regra para o Produto caso exista alguma senao posicionara na regra do grupo
			SZG->(dbGoTop())

			If SZG->(dbSeek(xfilial('SZG') + PADR(SB1->B1_COD,Len(SZG->ZG_GRUPO)) ))
				lExiste := .F.
				// Procurando regra para o Produto Valida caso exista alguma
				While xfilial('SZG') + PADR(SB1->B1_COD,Len(SZG->ZG_GRUPO)) == SZG->(ZG_FILIAL + ZG_GRUPO) .And. !lExiste
					// verifica se o Cliente esta na regra do TIPTRIP e ESTTRIB = 'F' referente a regra de clientes Fora da area de Livre Comercio
					lExiste := SA1->A1_XTRBSAI $ SZG->ZG_TIPTRIP .And. SZG->ZG_ESTTRIB = 'F'					
					IF !lExiste
						SZG->(dbSkip())
					EndIf
				EndDo
				// Posiciona na primeira regra para o Produto caso exista alguma senao posicionara na regra do grupo
			Else
			 SZG->(dbGoTop())

			 If SZG->(dbSeek(xfilial('SZG') +  PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO))  ))

				lExiste := .F.
				// Procurando regra para o Produto Valida caso exista alguma
				While xfilial('SZG') + PADR(SB1->B1_GRUPO,Len(SZG->ZG_GRUPO)) == SZG->(ZG_FILIAL + ZG_GRUPO) .And. !lExiste
					// verifica se o Cliente esta na regra do TIPTRIP e ESTTRIB = 'F' referente a regra de clientes Fora da area de Livre Comercio
					lExiste := SA1->A1_XTRBSAI $ SZG->ZG_TIPTRIP .And. SZG->ZG_ESTTRIB == 'F'
					IF !lExiste
						SZG->(dbSkip())
					EndIf
				EndDo
			 EndIf	
			EndIf
		EndIf
		
	EndIf
	
	
	If lExiste
		aCols[nLinha][aPos[03]] := SZG->ZG_FILSAID
	else
		Aviso('Atencao','Produto '+SB1->B1_COD+' ou Cliente nao Encontrado na Regra de Faturamento',{'Ok'},1)
	EndIf
	
	
EndIf

If ExistTrigger("LR_ENTBRAS") //.And. n_ColQuant == AScan( aHeader , {|x| Trim(x[2]) == "LR_ENTBRAS" })
	RunTrigger(1,,,"LR_ENTBRAS")
EndIf

Return lRet

User Function VldFilTrib(cGrup,cTiptrib,cEstado)

Local cTable  := GetNextAlias()
Local cVar    := Readvar()
Local lRet    := .T.

default cGrup     := ""
default cTipTrib  := ""
default cestado   := ""
If Alltrim(cVar) == "M->ZG_FILSAID"
	lRet := .F.
	BeginSql Alias cTable
		Select * from %Table:SZG% ZG
		Where ZG_GRUPO = %Exp:cGrup%
		And ZG_TIPTRIP = %Exp:cTipTrib%
		And ZG_ESTTRIB = %Exp:cEstado%
		And R_E_C_N_O_ != %Exp:SZG->(RecNo())%
		And ZG.%NotDel%
	EndSql
	lRet := (cTable)->(Eof()) .Or. (cTable)->ZG_FILSAID == &cVar
	If !lRet
		Aviso('ERRO!',"Filial Invalida pois ja foi Inserida as mesmas Informacoes com Filial Diferente",{'OK'},1)
	EndIf
//Compilar
EndIf

Return lRet


User Function AADELFIN(_cFilial,_cPrefixo,_cTitulo,_cVend)

Local _aArea := SE1->(GetArea())

Default _cFilial := SE1->(xFilial('SE1'))
Default _cPrefixo:= ""
Default _cTitulo := ""
Default _cVend   := ""

SE1->(dbSetOrder(1))
iF SE1->(dbSeek(_cFilial + _cPrefixo + _cTitulo)) 

	lMsErroAuto := .F.
	
	While SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM) == _cFilial + _cPrefixo + _cTitulo .And. !SE1->(EOF()) .And. !lMsErroAuto
	
	SE1->(RecLock("SE1",.F.))
	   SE1->E1_ORIGEM := ''
	SE1->(MsUnlock())
	
	aVetor := {{"E1_FILORIG", _cFilial       , Nil},;
	           {"E1_PREFIXO", SE1->E1_PREFIXO, Nil},;                        
	           {"E1_NUM"    , SE1->E1_NUM    , Nil},;
	           {"E1_PARCELA", SE1->E1_PARCELA, Nil},;
	           {"E1_TIPO"   , SE1->E1_TIPO   , Nil},;                          
	           {"E1_PORTADO", SE1->E1_PORTADO, Nil},;                          
	           {"E1_AGEDEP" , SE1->E1_AGEDEP , Nil},;                              
	           {"E1_CLIENTE", SE1->E1_CLIENTE, Nil},;
	           {"E1_LOJA"   , SE1->E1_LOJA   , Nil},;
	           {"E1_EMISSAO", SE1->E1_EMISSAO, Nil},;
	           {"E1_VENCTO" , SE1->E1_VENCTO , Nil},;
	           {"E1_VALOR"  , SE1->E1_VALOR  , Nil},;
	           {"E1_CONTA"  , SE1->E1_CONTA  , Nil}}
	           
	                         
	 MSExecAuto({|x,y| Fina040(x,y)},aVetor,5) //Inclusao   
	               
	 If lMsErroAuto
	     mostraerro()
	 Endif
	 SE1->(dbSkip())
	EndDo
	
EndIf
SE1->(RestArea(_aArea))

If Len(Alltrim(_cVend )) != 0
	SE3->(dBSetOrder(2))
//	ø( SE3->(dBSeek(xFilial('SE3') + PADR(_cVend,TAMSX3('E3_VEND')[01]) + Padr(_cPrefixo,,TAMSX3('E3_PREFIXO')[01])) + Padr(_cTitulo,TAMSX3('E3_NUM')[01])))) )
	SE3->(dBSeek(xFilial('SE3') + _cVend + _cPrefixo + _cTitulo))
	_cChave := xFilial('SE3') + _cVend + _cPrefixo + _cTitulo
	
	While _cChave == SE3->(E3_FILIAL + E3_VEND + E3_PREFIXO + E3_NUM )
	  SE3->(RecLock('SE3' , .F.)) 
	    SE3->(dbDelete())
	  SE3->(MsUnlock())
	  SE3->(dbSkip())
	EndDo
EndIf


Return Nil

User Function FWorkCanc(cNota,cCliente, nValor,cSerie,cOrc,cLoja,cFormPg)
Local cHtml       := ""
Local cAccount    := ""
Local cServer     := ""
Local cPass       := ""
Local cAssunto    := "CANCELAMENTO - " +cNota+"/"+cSerie
Local nSaldo      := 0 
Local cCliLj      := ""
Local nSalPto     := 0
Local nYPTOTAL    := 0
Local cEmail      := Alltrim(GetMv('MV_XEMCAN'))
Local aArea  		:= GetArea()
local lResult := .F.
Default cOrc :=""

cHtml +=FNotCanc(cNota,cCliente, nValor,cSerie,cOrc,cLoja,cFormPg)

cAccount := GetMv('MV_RELACNT')// Conta de Envio de Relatorios por e-mail do acr//
cServer  := GetMv('MV_RELSERV')// IP do Servidor de e-mails //'smtp.microsiga.com.br'//
cPass    := GetMv('MV_RELPSW') // Senha da Conta de e-mail

LjMsgRun('* Conectando com o servidor SMTP: ' + cServer)
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult

If lResult
	Conout("Autenticado SMTP ok")
	If GetMv("MV_RELAUTH") //lRelauth
		lResult:= Mailauth(cAccount,cPass)
	Else
		lResult:= .T.
	Endif
EndIf
If lResult
Conout("Autenticou E-mail")
	ljMsgRun('Enviando email para o Faturamento','Aguarde...')	//ljMsgRun('Enviando email para o Financeiro'+Chr(13)+StrTran(cEmail,',',Chr(13)),'Aguarde...')
	SEND MAIL FROM cAccount  TO cEmail SUBJECT cAssunto BODY cHtml
	GET MAIL ERROR CERROR
	conout(cemail)
	CONOUT(cError)
	DISCONNECT SMTP SERVER
ELSE
	GET MAIL ERROR CERROR
	Conout(cError)
	
EndIf  

RestArea(aArea) 
Return

Static Function FNotCanc(cNota,cCliente, nValor,cSerie,cOrc,cLoja,cFormPg)

Local cHtml       := ""


cHtml :=  '<table style="width:680px; font-family:Verdana, Arial, Helvetica, sans-serif; color:#343434; font-size:13px; text-align:justify;"  width="100%" border="0" cellspacing="6" cellpadding="6">'
cHtml +=  '  <tr >'
cHtml +=  '    	<td width="407"  valign="middle">'
cHtml +=  '   Senhores(as), <u> </u></td>'
cHtml +=  '</td>'
cHtml +=  '</tr>'
cHtml +=  '<tr>'
cHtml +=  '<td colspan="2" height="30">&nbsp;'
cHtml +=  '</td>'
cHtml +=  '</tr>'
cHtml +=  '<tr>'
cHtml +=  '<td colspan="2">'
cHtml +=  '<p> Cancelamento Nota/Cupom Fiscal em '+Alltrim(SM0->M0_FILIAL)+'  <br />'      
cHtml +=  '<p> Nota Fiscal ('+cNota+'). <br />'                                                                    
cHtml +=  '<p> Serie ('+Alltrim(cSerie)+'). <br />'   
If !Empty(cOrc)
	cHtml += '<p> Orçamento ('+cOrc+').'                                                                 
EndIf
cHtml +=  '<p> Cliente: '+cCliente+'-'+Alltrim(POSICIONE("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NOME"))+' <br />'      
cHtml +=  '<p> Valor: '+Transform(nValor, "@E 9,999,999,999.99" )+' <br />'
cHtml +=  '<p> Forma de Pagamento: '+Alltrim(cFormPg)+' <br />'        
cHtml +=  '</td>'
cHtml +=  '</tr>'

cHtml +=  '<br/>'

cHtml +=  '<table cellpadding="2" style="font-family:Verdana, Arial, Helvetica, sans-serif; color:#343434; font-size:12px; text-align:justify;" width="100%">'

Return cHtml

/*Captura nome do Fornecedor*/
User Function GetNameF(cNum)
Local cNome:=""
Local cCodFor:=""
cCodFor := Posicione("SC7",1,XFILIAL("SC7")+Alltrim(cNum),"C7_FORNECE")
cNome   := Posicione("SA2",1,xFilial("SA2")+Alltrim(cCodFor)+"01","A2_NOME")
Return(cNome)


User Function Calcpes2()

Local cdFuncao  := FunName()
Local nd_peso   := 0
Local aArea     := GetArea()

dbSelectArea("TMP1")
dbGotop()
While ( !Eof()  )
	If ( !TMP1->CK_FLAG .And. !Empty(TMP1->CK_PRODUTO) )
		//nd_peso += TMP1->CK_VALOR
		nd_peso += iIF( TMP1->CK_UM =="KG", TMP1->CK_QTDVEN,  Posicione("SB1",1,xFilial('SB1')+TMP1->CK_PRODUTO,"B1_PESO") * TMP1->CK_QTDVEN )  
	EndIf
	dbSelectArea("TMP1")
	dbSkip()
EndDo

RestArea(aArea)

Return nd_peso
