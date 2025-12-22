#include "protheus.ch"
#include "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  MT416FIM  ¦ Autor ¦ORISMAR SILVA         ¦ Data ¦ 02/07/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada para preenchimento dos campos do cabeçalho   ¦¦¦
¦¦¦           ¦ do pedido de vendas, pelo orçamento de venda.                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User function MT416FIM()

Local   cNUM      := M->C5_NUM
Local   nPesoLiq  := M->C5_PESOL
Local   nPesoBrt  := M->C5_PBRUTO
Local   nVolume   := M->C5_VOLUME1
Local   cEmp      := SM0->M0_CODFIL //Código da Filial
//Local   nPDel     := Len(aHeader) + 1
Local nItem       := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_ITEM"     })
Local nProd       := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_PRODUTO"  })
Local nDesc       := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_DESCRI"   })
Local nUnid       := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_UM"       })
Local nTes        := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_TES"      })
Local nCFOP       := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_CF"       })
Local nQuant      := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_QTDVEN"   })
Local nPrcUnit    := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_PRUNIT"   })
Local nPreco      := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_PRCVEN"   })
Local nPValor     := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_VALOR"    })
Local nLocal      := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_LOCAL"    })
Local nClasF      := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_CLASFIS"  })
Local nDtEnt      := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_ENTREG"   })
Local nNumOrc     := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_NUMORC"   })
Local nEntrega    := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_SUGENTR"  })
Local nPedCli     := Ascan(aHeader,{|x| Trim(x[2]) ==  "C6_PEDCLI"   })
Local ix

Private nQtdLote  := 0
Private nValor    := 0
Private cLoteCtl  := CriaVar("B8_LOTECTL")
Private dDTFabric := CriaVar("B8_DFABRIC")
Private dDTValid  := CriaVar("B8_DTVALID")
Private lPedido   := .T.
Private nNovoItem := 0


if cEmp = '02' .and. SCJ->CJ_STATUS = 'B'
	*
	//Gravar os itens do Pedido de Venda
	aCols2 := {}
	For ix:=1 To Len(aCols)
		nPos  := Ascan( aCols2, { |x| x[2] == aCols[ix,2] } )
		if nPos == 0     //       1  ,       2   ,      3    ,       4   ,      5     ,      6     ,      7   ,        8   ,        9   ,      10   ,      11    ,       12    ,       13   ,        14  ,       15   ,       16
			AAdd( aCols2, {aCols[ix,nItem],aCols[ix,nProd],aCols[ix,nDesc],aCols[ix,nUnid],aCols[ix,nTes],aCols[ix,nCFOP],aCols[ix,nQuant],aCols[ix,nPrcUnit],aCols[ix,nPreco],aCols[ix,nPValor],aCols[ix,nLocal], aCols[ix,nClasF],aCols[ix,nDtEnt],aCols[ix,nNumOrc],aCols[ix,nEntrega],aCols[ix,nPedCli]}  )
		else
			aCols2[nPos,7] += aCols[ix,nQuant]
		endif
	Next
	
	For ix:=1 To Len(aCols2)
		//if !aCols2[ix,nPDel]   // Se estiver deletado
		nQtdLote  := 0
		nValor    := 0
		cLoteCtl  := CriaVar("B8_LOTECTL")
		dDTFabric := CriaVar("B8_DFABRIC")
		dDTValid  := CriaVar("B8_DTVALID")
		cItem     := aCols2[ix,1]
		nNovoItem := 0
		*
		U_CONSLOTE(aCols2[ix,2],aCols2[ix,11],aCols2[ix,7],aCols2[ix,9],cItem,Len(aCols2))
		*
		if lPedido
			dbSelectArea("SC6")
			RecLock("SC6",.T.)
			SC6->C6_FILIAL  := '04'
			SC6->C6_NUM     := cNUM
			SC6->C6_ITEM    := aCols2[ix,1]
			SC6->C6_CLI     := M->C5_CLIENTE
			SC6->C6_LOJA    := M->C5_LOJACLI
			SC6->C6_PRODUTO := aCols2[ix,2]
			SC6->C6_DESCRI  := aCols2[ix,3]
			SC6->C6_UM      := aCols2[ix,4]
			SC6->C6_TES     := aCols2[ix,5]
			SC6->C6_CF      := aCols2[ix,6]
			SC6->C6_QTDVEN  := aCols2[ix,7]
			SC6->C6_PRCVEN  := aCols2[ix,8]
			SC6->C6_PRUNIT  := aCols2[ix,9]
			SC6->C6_VALOR   := aCols2[ix,10]
			SC6->C6_LOCAL   := aCols2[ix,11]
			SC6->C6_TPOP    := "F"
			SC6->C6_CLASFIS := aCols2[ix,12]
			SC6->C6_ENTREG  := aCols2[ix,13]
			SC6->C6_PEDCLI  := aCols2[ix,16]
			SC6->C6_NUMORC  := aCols2[ix,14]
			SC6->C6_SUGENTR := aCols2[ix,15]
			*
			SC6->C6_QTDLOTE := nQtdLote
			SC6->C6_LOTE1   := cLoteCtl
			SC6->C6_FABRIC  := dDTFabric
			SC6->C6_LTVALID := dDTValid
			SC6->C6_LOTECTL := cLoteCtl
			SC6->C6_DTVALID := dDTValid
			MsUnlock()
		endif
		//endif
	Next
	*
	if lPedido
		//Gravar o cabeçalho do Pedido de Venda
		RecLock("SC5",.T.)
		SC5->C5_FILIAL   := '04'
		SC5->C5_NUM      := cNUM
		SC5->C5_TIPO     := "N"
		SC5->C5_CLIENTE  := M->C5_CLIENTE
		SC5->C5_LOJACLI  := M->C5_LOJACLI
		SC5->C5_LOJAENT  := M->C5_LOJAENT
		SC5->C5_CLIENT   := M->C5_CLIENT
		SC5->C5_PEDCLI   := M->C5_PEDCLI
		SC5->C5_TIPOCLI  := M->C5_TIPOCLI
		SC5->C5_TRANSP   := M->C5_TRANSP
		SC5->C5_CONDPAG  := M->C5_CONDPAG
		SC5->C5_TABELA   := M->C5_TABELA
		SC5->C5_VEND1    := M->C5_VEND1
		SC5->C5_EMISSAO  := M->C5_EMISSAO
		SC5->C5_TPFRETE  := M->C5_TPFRETE
		SC5->C5_MOEDA    := M->C5_MOEDA
		SC5->C5_PESOL    := nPesoLiq
		SC5->C5_PBRUTO   := nPesoBrt
		SC5->C5_VOLUME1  := nVolume
		SC5->C5_ESPECI1  := M->C5_ESPECI1
		SC5->C5_MENNOTA  := M->C5_MENNOTA
		SC5->C5_LIBEROK  := M->C5_LIBEROK
		SC5->C5_TIPLIB   := M->C5_TIPLIB
		SC5->C5_TXMOEDA  := M->C5_TXMOEDA
		SC5->C5_ESPECI1  := M->C5_ESPECI1
		SC5->C5_PDESCAB  := M->C5_PDESCAB
		SC5->C5_TPCARGA  := M->C5_TPCARGA
		SC5->C5_GERAWMS  := M->C5_GERAWMS
		SC5->C5_SOLOPC   := M->C5_SOLOPC
		SC5->C5_MSBLQL   := M->C5_MSBLQL
		SC5->C5_SLENVT   := M->C5_SLENVT
		SC5->C5_RET20G   := M->C5_RET20G
		Sc5->C5_INDPRES  := "9"
		MsUnlock()
	endif
	
	ConfirmSx8()
	MSGALERT("Pedido de venda de número: "+cNUM+" gerado para a filial 04 IMPORTAÇÃO com Sucesso!")
endif

Return




/*
_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  CONSLOTE  ¦ Autor ¦ORISMAR SILVA         ¦ Data ¦ 12/09/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para consultar o lote do produto                       ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
User function CONSLOTE(cProduto,cArmazem,nQuant,nPrcUnit,cItem,nTamanho)

Local lLote     := Posicione("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_XQUEBRA") //Permite usar vários lotes .T. (Sim) ou .F. (Não)
Local TpCli     := Posicione("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_PESSOA") //Tipo de Cliente F = Fisico e J = Juridico
Local lLoteProd := .F.
Local dDatDia   := DDATABASE
//Local cEmp      := SM0->M0_CODFIL //Código da Filial
*
M->C5_VEND1   := SCJ->CJ_XVEND
M->C5_PEDCLI  := ALLTRIM(StrTran(StrTran(StrTran(SCJ->CJ_COTCLI,"/",""),"-",""),".",""))
M->C5_PDESCAB := SCJ->CJ_PDESCAB
M->C5_MENNOTA := ALLTRIM(POSICIONE("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_XOBS"))
*
cMsgHtml := '<h3>Não existe lote para o produto '+cProduto+' na filial 04<h3>'
*
_cQry := " SELECT B8_FILIAL,B8_PRODUTO,B8_LOCAL,B8_DTVALID,B8_SALDO-B8_EMPENHO SALDO,B8_LOTECTL,B8_DFABRIC,R_E_C_N_O_,B8_DOC
_cQry += " FROM " + RetSqlName("SB8")
_cQry += " WHERE D_E_L_E_T_ = '' "
_cQry += " AND B8_FILIAL = '04'
_cQry += " AND B8_PRODUTO = '"+cProduto+"'"
_cQry += " AND B8_SALDO > 0
_cQry += " AND (B8_SALDO-B8_EMPENHO) > 0 "
_cQry += " AND B8_DTVALID > '"+DTOS(dDatDia)+"'"
_cQry += " AND B8_LOCAL = '"+cArmazem+"'"
_cQry += " ORDER BY B8_DTVALID,B8_LOTECTL
*
dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TMP",.T.,.F.)

TcSetField('TMP','B8_DTVALID','D')
TcSetField('TMP','B8_DFABRIC','D')
*
if !USED()
	MsgBox(_cQry+'. Query errada','Erro!!!','STOP')
endif

count to nReg

dbSelectArea("TMP")
dbGoTop()

if lLote .or. TpCli = "F"
	aPedido := AClone(nTamanho)
endif
*
nPosicao     := nTamanho  //Quantidade de linhas no aCols2.
nQuantidade  := 0
nPreco       := 0
*
if !TMP->(Eof())
	
	While !TMP->(Eof())
		
		if TpCli = "J" //Cliente tipo juridico
			//if lLote //Permite usar vários lotes .T. (Sim) ou .F. (Não)  aPedido[nPosicao][6]ADEL( _aCols2)
			//Permite vários lotes por produto, campo no cliente A1_XQUEBRA = .T.
			if ntamanho > nPosicao
				nPosicao := nTamanho
			endif
			*
			nPesoB      := 0
			nPesoL      := 0
			nTPesoB     := 0
			nTPesoL     := 0
			nVolume     := 0
			*
			if TMP->SALDO < nQuant//Saldo do Lote menor que a Quantidade solicitada para o produto no orçamento.
				*
				nCaixa       := 0
				nQtdLote    := 0
				nSldProduto := 0
				*
				//Pesquisar o quantidade caixa padrão, peso bruto e peso liquido
				nCaixa := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XCAIXA")   // Qtd Caixa Padrão
				nPesoB := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XPSBTCX")  // Peso Bruto Caixa Padrão
				nPesoL := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XPSLICX")  // Peso Liquido Caixa Padrão
				nMesVd := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XMSVALD")  // Meses de validade do produto
				*
				if nCaixa <= TMP->SALDO //Será verificado o lote minimo (Qtd Cx Padrão) de acordo com o produto
					
					nSldProduto := TMP->SALDO
					
					while nSldProduto >= nCaixa
						nSldProduto -= nCaixa
						nQtdLote    += nCaixa
						nTPesoB     += nPesoB
						nTPesoL     += nPesoL
						nVolume     += 1
					end
					
					nQuantidade      := nQuant-nQtdLote
					nPreco           := nPrcUnit
					
					if val(cITem) <> nPosicao
						cItem := STRZERO(nTamanho,2)
					endif
					
					nValor    := A410Arred((nQtdLote*nPrcUnit),"C6_VALOR")
					cLoteCtl  := TMP->B8_LOTECTL
					nMes      := SUBS(DTOC(TMP->B8_DFABRIC),4,2)
					nAno      := SUBS(DTOC(TMP->B8_DFABRIC),7)
					dDTFabric := TMP->B8_DFABRIC //LASTDAY(CTOD("01/"+nMes+"/"+nAno))
					dDTValid  := TMP->B8_DTVALID //LASTDAY(MonthSum( CTOD("01/"+nMes+"/"+nAno) , nMesVd )) //TMP->B8_DTVALID
					RunTrigger(2,nPosicao,nil,,'C6_PRCVEN')
					nPosicao  += 1
					nNovoItem++
					lLoteProd := .T.
				else //TMP-SALDO > nCaixa (Cx Padrão)
				endif
				
			else //Saldo do Lote maior que a quantidade solicitada.
				
				if nTamanho > nPosicao
					nPosicao := nTamanho
				endif
				
				//---verificando o peso bruto, peso liquido e quantidade cx padrão--------------//
				nCaixa := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XCAIXA")   // Qtd Caixa Padrão
				nPesoB := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XPSBTCX")  // Peso Bruto Caixa Padrão
				nPesoL := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XPSLICX")  // Peso Liquido Caixa Padrão
				nMesVd := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XMSVALD")  // Meses de validade do produto
				
				
				cLoteCtl  := TMP->B8_LOTECTL
				nMes      := SUBS(DTOC(TMP->B8_DFABRIC),4,2)
				nAno      := SUBS(DTOC(TMP->B8_DFABRIC),7)
				dDTFabric := TMP->B8_DFABRIC//LASTDAY(CTOD("01/"+nMes+"/"+nAno))
				dDTValid  := TMP->B8_DTVALID //LASTDAY(MonthSum( CTOD("01/"+nMes+"/"+nAno) , nMesVd )) //TMP->B8_DTVALID
				lLoteProd := .T.
				
				*
				nSldProduto := nQuant
				*
				while nSldProduto >= nCaixa
					nSldProduto -= nCaixa
					nTPesoB     += nPesoB
					nTPesoL     += nPesoL
					nVolume     += 1
				end
				
				if nSldProduto > 0
					
					//---verificando o peso bruto, peso liquido e quantidade display--------------//
					nCaixa  := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XDISPLA")  // Qtd Display
					nPesoB  := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XPSBTDP")  // Peso Bruto Display
					nPesoL  := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XPSLIDP")  // Peso Liquido Display
					nVolume += 1
					*
					while nSldProduto >= nCaixa
						nSldProduto -= nCaixa
						nTPesoB     += nPesoB
						nTPesoL     += nPesoL
					end
				endif
				if TMP->SALDO >= nQuant//Sai do laço quantidade já atendida.
					exit
				endif
				
			endif
			
		else //Cliente Pessoa Fisica
			
			nPesoB      := 0
			nPesoL      := 0
			nTPesoB     := 0
			nTPesoL     := 0
			nVolume     := 0
			
			if TMP->SALDO >= nQuant
				
				//---verificando o peso bruto, peso liquido e quantidade cx padrão--------------//
				nCaixa := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XCAIXA")   // Qtd Caixa Padrão
				nPesoB := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XPSBTCX")  // Peso Bruto Caixa Padrão
				nPesoL := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XPSLICX")  // Peso Liquido Caixa Padrão
				nMesVd := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XMSVALD")  // Meses de validade do produto
				
				
				cLoteCtl  := TMP->B8_LOTECTL
				nMes      := SUBS(DTOC(TMP->B8_DFABRIC),4,2)
				nAno      := SUBS(DTOC(TMP->B8_DFABRIC),7)
				dDTFabric := TMP->B8_DFABRIC //LASTDAY(CTOD("01/"+nMes+"/"+nAno))
				dDTValid  := TMP->B8_DTVALID //LASTDAY(MonthSum( CTOD("01/"+nMes+"/"+nAno) , nMesVd )) //TMP->B8_DTVALID
				lLoteProd := .T.
				
				*
				
				nSldProduto := nQuant
				*
				while nSldProduto >= nCaixa
					nSldProduto -= nCaixa
					nTPesoB     += nPesoB
					nTPesoL     += nPesoL
					nVolume     += 1
				end
				
				if nSldProduto > 0
					
					//---verificando o peso bruto, peso liquido e quantidade display--------------//
					nCaixa  := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XDISPLA")  // Qtd Display
					nPesoB  := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XPSBTDP")  // Peso Bruto Display
					nPesoL  := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XPSLIDP")  // Peso Liquido Display
					nVolume += 1
					nTPesoB := (nSldProduto*nPesoB)/nCaixa
					nTPesoL := (nSldProduto*nPesoL)/nCaixa
				endif
				exit
				
			else
				
				if nTamanho > nPosicao
					nPosicao := nTamanho
				endif
				*
				nPesoB      := 0
				nPesoL      := 0
				nTPesoB     := 0
				nTPesoL     := 0
				nVolume     := 0
				*
				if TMP->SALDO <= nQuant//Saldo do Lote menor que a Quantidade solicitada para o produto no orçamento.
					*
					nCaixa       := 0
					nQtdLote    := 0
					nSldProduto := 0
					*
					//Pesquisar o quantidade caixa padrão, peso bruto e peso liquido
					nCaixa := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XCAIXA")   // Qtd Caixa Padrão
					nPesoB := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XPSBTCX")  // Peso Bruto Caixa Padrão
					nPesoL := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XPSLICX")  // Peso Liquido Caixa Padrão
					nMesVd := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_XMSVALD")  // Meses de validade do produto
					*
					
					if nCaixa >= TMP->SALDO //Será verificado o lote minimo (Qtd Cx Padrão) de acordo com o produto
						
						nSldProduto := TMP->SALDO
						
						while nSldProduto >= TMP->SALDO //nCaixa
							nSldProduto -= TMP->SALDO //nCaixa
							nQtdLote    += TMP->SALDO //nCaixa
							nTPesoB     += nPesoB
							nTPesoL     += nPesoL
							nVolume     += 1
						end
						
						nQuantidade      := nQuant-nQtdLote
						nPreco           := nPrcUnit
						
						//If Type("nAux") !="U"
						//	if val(cItem) <> nAux
						//		cItem := STRZERO(nTamanho,2)
						//	endif
						//Else
							cItem := STRZERO(nTamanho,2)
						//EndIf
						*
						nValor    := A410Arred((nQtdLote*nPrcUnit),"C6_VALOR")
						cLoteCtl  := TMP->B8_LOTECTL
						nMes      := SUBS(DTOC(TMP->B8_DFABRIC),4,2)
						nAno      := SUBS(DTOC(TMP->B8_DFABRIC),7)
						dDTFabric := TMP->B8_DFABRIC //LASTDAY(CTOD("01/"+nMes+"/"+nAno))
						dDTValid  := TMP->B8_DTVALID //LASTDAY(MonthSum( CTOD("01/"+nMes+"/"+nAno) , nMesVd )) //TMP->B8_DTVALID
						RunTrigger(2,nPosicao,nil,,'C6_PRCVEN')
						nPosicao     += 1
						lLoteProd := .T.
						*
						if nPosicao > 1
							//RETIRADA A CUSTOMIZAÇÃO
						endif
					endif
				endif
			endif
		endif
		TMP->(DBSKIP())
	end
	if !lLoteProd
		Alert(cMsgHtml)
		//lPedido := .F.
	endif
else
	Alert(cMsgHtml)
	//lPedido := .F.
endif
dbSelectArea("TMP")
dbCloseArea()
*
Return Nil
