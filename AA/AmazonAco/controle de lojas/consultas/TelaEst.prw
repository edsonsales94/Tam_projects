#include "rwmake.ch"
#include "Protheus.CH"

User Function TelaEst(pCod)

Local nOpc      := 2
Local lFlag     := .T.
Local aPedidos  := {}
Local aAreaP := GetArea()
Local SM0Reg := SM0->(Recno())
Local nIndX, nRegX
Local cEmp := Substr(cNumEmp,1,2)
Local cFil := Substr(cNumEmp,3,2)
Local cArmazem := ""
Local cLjnome  := ""
Local nQtdOrc  := 0

Private oNo       := LoadBitmap( GetResources(), "BR_VERMELHO" )
Private oOk       := LoadBitmap( GetResources(), "BR_VERDE" )

Private lProd     := .T.
Private aProdutos := {}
Private aProd_T   := {} // Produtos Totais
Private aProd_P   := {} // Produtos Parcial
Private aProd_T   := {} // Produtos Totais
Private aTot_T    := {0,0,0,0}
Private aTot_P    := {0,0,0,0}
Private aTotEst   := {0,0,0,0}
Private aTotPed   := {0,0}
Private oLby, oDlgy, oMainWdy
Private oTotEst3, oTotEst2, oTotEst1, oTotEst4
Private oTotPed3, oTotPed2, oTotPed1


Define Font oFnt3 Name "Ms Sans Serif" SIZE 5,10 Bold

DbSelectArea("SLJ")
dbSetOrder(3)

DbSelectArea("SB1")
dbSetOrder(1)
dbSeek(XFILIAL("SB1")+Padr(pCod,TamSx3("B1_COD")[01]))
DbSelectArea("SB2")

nIndX := IndexOrd()
nRegX := Recno()
DbSetOrder(1)

If !Empty(pCod)
	
	SLJ->(dbSeek(xFilial("SLJ")+cEmp /*+cFil*/))
	
	While !SLJ->(EOF()) .And. cEmp == SLJ->LJ_RPCEMP
		
		If SX6->(dbSeek(Space(02)+"MV_LOCVER"))
			
			SB2->(DbSeek(SLJ->LJ_RPCFIL+pCod))
			
			IF(cEmp == '01')
				cLjnome  := SLJ->LJ_NOME
			ENDIF
			
			While !SB2->(EOF()) .And. SB2->B2_COD == pCod .And. SB2->B2_FILIAL == SLJ->LJ_RPCFIL 
				
				cArmazem := SB2->B2_LOCAL+" - "+SLJ->LJ_NOME
				
				If SB2->B2_LOCAL $ ALLTRIM(SX6->X6_CONTEUD)
					// Armazens parcial do parametro MV_LOCVER
					// Verifica se a quantidade e reserva é diferente de Zero.
					
					nQtdOrc := u_SaldoOrc(pCod)   		// Funcao que soma a quantidade de produtos com Orcamentos em abertos e NAO vencidos-(TELAPESQ.PRW)
					
					//            FILIAL            ARMAZEM     SALDO ATUAL     RESERVA+EMPENHO          QTD EM ORCAMENTO           SALDO DISPONIVEL
					aadd(aProd_P,{.T.,SLJ->LJ_RPCFIL,cArmazem,SB2->B2_QATU,SB2->B2_RESERVA+SB2->B2_QEMP,     nQtdOrc     ,(SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP))})
					aTot_P[1] += SB2->B2_QATU
					aTot_P[2] += SB2->B2_RESERVA+SB2->B2_QEMP
					aTot_P[3] += (SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP))
					aTot_P[4] += nQtdOrc
					
					If (aProd_P[Len(aProd_P)][7] == 0)
						aProd_P[Len(aProd_P)][1] := .F.
					EndIf
					
				EndIf
				
				If (SB2->B2_QATU <> 0 .Or. (SB2->B2_RESERVA+SB2->B2_QEMP <> 0))
					// Todos os Armazens
					aadd(aProd_T,{.T.,SLJ->LJ_RPCFIL,cArmazem,SB2->B2_QATU,(SB2->B2_RESERVA+SB2->B2_QEMP), nQtdOrc, (SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP))})
					aTot_T[1] += SB2->B2_QATU
					aTot_T[2] += SB2->B2_RESERVA+SB2->B2_QEMP
					aTot_T[3] += (SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP))
					aTot_T[4] += nQtdOrc
					if (aProd_T[Len(aProd_T)][7] == 0)
						aProd_T[Len(aProd_T)][1] := .F.
					Endif
				Endif
				SB2->(dbSkip())
			Enddo
		Else
			MsgAlert("Favor definir os Locais disponiveis para venda atraves do parametro MV_LOCVER","ATENCAO")
		Endif
		SLJ->(dbSkip())
	Enddo
	
	if Empty(aProd_P) // Sem Saldo em Estoque Parcial
		cArmazem := "01 - " + ALLTRIM(cLjnome)
		aadd(aProd_P,{.F.,SM0->M0_FILIAL,cArmazem,0,0,0,0})
	Endif
	if Empty(aTot_P) // Sem Saldo em Estoque Total
		cArmazem := "01 - " + ALLTRIM(cLjnome)
		aadd(aTot_P,{.F.,SLJ->LJ_RPCFIL,cArmazem,0,0,0,0})
	Endif
	aProdutos := aClone(aProd_P) //  armazens Totais ou Parcial
	aTotEst   := aClone(aTot_P)  //  armazens Totais ou Parcial
	aPedidos  := F_Pedidos(pCod)
	
	SLJ->(dbGoTo(SM0Reg))
	
	DEFINE MSDIALOG oDlgy TITLE "Saldo das Lojas " From 8,0 To 45,117 OF oMainWdy
	
	@ 15,14   SAY "Data : "+ dToc(dDataBase) Of oDlgy Pixel Font oFnt3
	@ 15,080  SAY ALLTRIM(SM0->M0_NOMECOM) + " - SALDO NAS LOJAS"    Of oDlgy Pixel Font oFnt3
	@ 25 ,020 SAY "PRODUTO  : " Of oDlgy Pixel Font oFnt3
	@ 25 ,060 SAY Alltrim(pCod)+" - "+AllTrim(SB1->B1_DESC)Of oDlgy Pixel
	
	@ 185,030 SAY "SALDO : "Of oDlgy Pixel Font oFnt3
	// 52+
	@ 185,245 SAY oTotEst3 VAR aTotEst[3] Of oDlgy Pixel Picture "@E 999,999,999.99"
	@ 185,297 SAY oTotEst2 VAR aTotEst[2] Of oDlgy Pixel Picture "@E 999,999,999.99"
	@ 185,348 SAY oTotEst4 VAR aTotEst[4] Of oDlgy Pixel Picture "@E 999,999,999.99"
	@ 185,398 SAY oTotEst1 VAR aTotEst[1] Of oDlgy Pixel Picture "@E 999,999,999.99"
	
	
	@ 035,005 LISTBOX oLby VAR cVar FIELDS HEADER;
	" ",;
	"Filial",;
	"Armazem",;
	"Saldo Disponivel",;
	"Bloqueado",;
	"Qtd Orc" ,;
	"Saldo Atual",;
	SIZE 450,145 OF oDlgy PIXEL
	
	//-------------------- alterado para buscar o Pedido de compra -------------------------------//
	//"Pedidos de Compra em Aberto para o Produto"
	@ 200,005 SAY "PEDIDOS DE COMPRA EM ABERTO PARA O PRODUTO" Of oDlgy Pixel  Font oFnt3
	@ 265,030 SAY "SALDO : "Of oDlgy Pixel Font oFnt3
	@ 265,090 SAY oTotPed1 VAR aTotPed[1] Of oDlgy Pixel Picture "@E 999,999,999.99"
	@ 265,147 SAY oTotPed2 VAR aTotPed[2] Of oDlgy Pixel Picture "@E 999,999,999.99"
	
	@ 210,005 LISTBOX oLbz VAR cVarz FIELDS HEADER;
	" ",;
	"Filial",;
	"No. Pedido",;
	"Qtd. Pedido",;
	"Qtd. Entregue",;
	"Dt. Emissao",;
	SIZE 450,50 OF oDlgy PIXEL ;
	ON dblClick( VPCompra(oLbz:nAt,@aPedidos,@oLbz),oLbz:Refresh(.F.))
	
	F_Armazem()
	
	if !Empty(aPedidos)
		oLbz:SetArray( aPedidos )
		oLbz:bLine := {|| {Iif(aPedidos[oLbz:nAt,1],oOk,oNo),;
		aPedidos[oLbz:nAt,2],;
		aPedidos[oLbz:nAt,3],;
		Transform(aPedidos[oLbz:nAt,4],"@E 999,999.99"),;
		Transform(aPedidos[oLbz:nAt,5],"@E 999,999.99"),;
		aPedidos[oLbz:nAt,6]}}
	Endif
	// -------------------------------------------------------------------------------------------//
	//F_Armazem()
	ACTIVATE MSDIALOG oDlgy ON INIT;
	EnchoiceBar(oDlgy,{|| (nOpc:=1,oDlgy:End()) },{||(nOpc:=2,oDlgy:End())},,;
    /*{{"PEDIDO2",{||F_Armazem()},"Armazens","Armazens"}} */   ) CENTERED
	
	
	dbSetOrder(nIndX)
	dbGoTo(nRegX)
	
Endif

RestArea(aAreaP)


Return

****************************************************************************************************************

Static Function F_Armazem()

aProdutos := iif( lProd , aClone(aProd_P),aClone(aProd_T) )// Seta o vetor com os produtos parciais
aTotEst   := iif( lProd , aClone(aTot_P),aClone(aTot_T) )

//len(aprodutos[01])
//aeval(aprodutos[01] ,{|x| alert(x)})

lProd     :=  !lProd
oLby:SetArray( aProdutos )
oLby:bLine := {|| {Iif(aProdutos[oLby:nAt,1],oOk,oNo),;
aProdutos[oLby:nAt,2],;
aProdutos[oLby:nAt,3],;
Transform(aProdutos[oLby:nAt,4],"@E 999,999.99"),;
Transform(aProdutos[oLby:nAt,5],"@E 999,999.99"),;
Transform(aProdutos[oLby:nAt,6],"@E 999,999.99"),;
Transform(aProdutos[oLby:nAt,7],"@E 999,999.99")}}

oTotEst1:Refresh()
oTotEst2:Refresh()
oTotEst3:Refresh()
oDlgy:Refresh()


Return

****************************************************************************************************************

Static Function F_Pedidos(pCod)
Local cQry := ""
Local aArea := GetArea()
Local aVetTmp := {}

cQry := "SELECT * "
cQry += "FROM "+RetSqlName("SC7")+" "
cQry += "WHERE D_E_L_E_T_ <> '*' "
cQry += "  AND C7_QUJE < C7_QUANT "
cQry += "  AND C7_RESIDUO = '' "
cQry += "  AND C7_PRODUTO = '"+pCod+"' "
cQry += "ORDER BY C7_DATPRF "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
dbSelectArea("TRAB")

if !TRAB->(EOF())
	While !TRAB->(EOF())
		//aadd(aVetTmp,{.F.,TRAB->C7_FILIAL,TRAB->C7_NUM,TRAB->C7_QUANT,TRAB->C7_QUJE,STOD(TRAB->C7_DATPRF),TRAB->C7_OBS})
		aadd(aVetTmp,{.T.,TRAB->C7_FILIAL,TRAB->C7_NUM,TRAB->C7_QUANT,TRAB->C7_QUJE,STOD(TRAB->C7_EMISSAO)})
		aTotPed[1] += TRAB->C7_QUANT
		aTotPed[2] += TRAB->C7_QUJE
		TRAB->(dbSkip())
	Enddo
Endif
dbCloseArea("TRAB")
RestArea(aArea)

Return aVetTmp

****************************************************************************************************************
// Tela de Visualizacao do Pedido de compra selecionado.

Static Function VPCompra(nPs,aVt,oLbz) // FILIAL+NUM Visualizar Pedido de Compra.
Local oDlgw, oMainWdw, oLbw
Local nOpc := 2
Local lFlag    := .T.
Local aPRes    := {}
Local aAreaAnt := GetArea()
Local aCamposP := {}
Local cTexto   := ""
Local oTexto

If Empty(aVt)
	Return
Endif
TabTmp(aVt[nPs][2]+aVt[nPs][3])
While !TMP->(EOF())
	lFlag := iif( (TMP->C7_QUJE < TMP->C7_QUANT .And. EMPTY(TMP->C7_RESIDUO)),.T.,.F.)
	aadd(aPRes,{lFlag,TMP->C7_PRODUTO, TMP->C7_DESCRI, TMP->C7_QUANT, TMP->C7_QUJE, STOD(TMP->C7_EMISSAO)})
	//    cTexto += FormatTxt(ALLTRIM(TMP->C7_MENS))+" "
	TMP->(dbSkip())
Enddo
TMP->(dbCloseArea())
If len(aPRes) >= 1                                                        //25, 80
	DEFINE MSDIALOG oDlgw TITLE "Visualização Pedido de Compra" From 8,0 To 40,93 OF oMainWdw
	
	@017, 10 Say "PEDIDO:"  Of oDlgw Pixel Font oFnt3
	@015, 50 Get aVt[nPs][3] when .F. Of oDlgw Pixel
	@017, 90 Say "EMISSAO:" Of oDlgw Pixel Font oFnt3
	@015, 120 Get aVt[nPs][6] when .F.  Of oDlgw Pixel
	@200, 10 Say "OBSERVACAO:" Of oDlgw Pixel Font oFnt3
	@210, 10 GET oTexto var cTexto  OF oDlgw MEMO SIZE 340,25 PIXEL
	oTexto:lReadOnly := .T.
	@030,005 LISTBOX oLbw VAR cVar FIELDS HEADER;
	" ",;
	"Produto",;
	"Descricao",;
	"Qtd. Pedido",;
	"Qtd. Entregue",;
	"Dt. Emissao",;
	SIZE 360,160 OF oDlgw PIXEL
	//   Largura ,Altura
	oLbw:SetArray( aPRes )
	oLbw:bLine := {|| {Iif(aPRes[oLbw:nAt,1],oO`k,oNo),;
	aPRes[oLbw:nAt,2],;
	aPRes[oLbw:nAt,3],;
	aPRes[oLbw:nAt,4],;
	Transform(aPRes[oLbw:nAt,5],"@E 999,999.99"),;
	aPRes[oLbw:nAt,6]}}
	
	ACTIVATE MSDIALOG oDlgw ON INIT;
	EnchoiceBar(oDlgw,{|| (nOpc:=1,oDlgw:End()) },{||(nOpc:=2,oDlgw:End())}) CENTERED
Endif
RestArea(aAreaAnt)
Return

*******************************************************************************************************************

Static Function TabTmp(cNumPed)

Local cQry := ""
Local _SC7 := RetSqlName("SC7")

cQry := " SELECT C7_NUM, C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_QUJE, C7_EMISSAO, C7_OBS, C7_RESIDUO "
cQry += " FROM "+_SC7+" "
cQry += " WHERE D_E_L_E_T_ <> '*' "
cQry += "   AND C7_FILIAL+C7_NUM = '"+cNumPed+"' "
cQry += " ORDER BY C7_ITEM "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
dbSelectArea("TMP")

Return

*******************************************************************************************************************

Static Function FormatTxt(TmpTxt)
cTxt := StrTran(TmpTxt,"&",Chr(10)+Chr(13))
Return cTxt
