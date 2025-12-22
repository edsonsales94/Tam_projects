#include "Protheus.CH"
#include "font.CH"
#include "Topconn.ch"
#include "RwMake.ch"
#include "tbiconn.ch"
#INCLUDE "acdv166.ch" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

User Function V166VLD()
Local aArea 	:= GetArea()
	Local aEtiq		:= PARAMIXB//[1]
	Local aEtiqueta := CBRetEti(aEtiq[1],"01")
	Local nQuant 	:= aEtiqueta[2]
	Local nSaldoCB8 := PARAMIXB[3]
	Local nRecCB8	:= CB8->(Recno())
	Local aAreaCB8	
	Local nSldSep	:= FSaldSep(CB8->CB8_ORDSEP,CB8->CB8_PROD) //Verifica a quantidade separada para o item
	Local lRet 		:= .T.
	Local nJalido   := 0
	//Local nEmbPad   := Posicione("SB1",1,xFilial("SB1")+CB8->CB8_PROD,"B1_XMPEMB")/2
	Local nToleran	:= nOldToleran := GetMv("MV_XPERLIB")
	Local aArrSC6	:= {}
	Local nDiferen  := 0 
	Local lFinanceiro := .F.
	Local cLote  	:= aEtiqueta[16]
	Local cLocaliza := aEtiqueta[9]
			


	CONOUT('[[[ ESTOU AQUI ]]]')
	//Verifica se a etiqueta foi enderecado
	If Empty(Alltrim(aEtiqueta[9]))
		VTALERT("Material ainda nao enderecado","Aviso" ,.T.,4000,3) //"Quantidade excede o saldo disponivel"###"Aviso"
		lRet := .F.
	Else
		nSaldBF:= SaldoSBF(aEtiqueta[10],cLocaliza,CB8->CB8_PROD,aEtiqueta[23],cLote,aEtiqueta[17],.F.)       
		Conout("Etiqueta lida: "+aEtiq[1]+" Quantidade:"+Alltrim(str(nQuant))+" Saldo Endereco: "+Alltrim(str(nSaldBF))+"Ordem:"+CB8->CB8_ORDSEP)
		If nQuant>nSaldBF
			VTALERT("Quantidade no endereco excede o saldo disponivel","Aviso" ,.T.,4000,3) //"Quantidade excede o saldo disponivel"###"Aviso"
			CONOUT("Quantidade no endereco excede o saldo disponivel")
			lRet := .F.
		Else
			nSaldoLote := SaldoLote(CB8->CB8_PROD,aEtiqueta[10],aEtiqueta[16],aEtiqueta[17],,,,dDataBase,,)
			If nQuant > nSaldoLote
				VTALERT("Quantidade no lote excede o saldo disponivel","Aviso" ,.T.,4000,3) //"Quantidade excede o saldo disponivel"###"Aviso"
				CONOUT("Quantidade no lote excede o saldo disponivel")
				lRet := .F.
			ElseIf ! CBExistLot(CB8->CB8_PROD,aEtiqueta[10],aEtiqueta[9],aEtiqueta[16],aEtiqueta[17])
				CONOUT("Lote nao existe!")
				VTALERT("Lote nao existe!","Aviso" ,.T.,4000,3) //"Quantidade excede o saldo disponivel"###"Aviso"
				lRet := .F.
			Else
				nJaLido := FSaldSep(CB8->CB8_ORDSEP,CB8->CB8_PROD,aEtiqueta[10],aEtiqueta[9],aEtiqueta[16]) //Verifica a quantidade separada para o item
				If (nJalido+nQuant)>nSaldBF
					VTALERT("Quantidade excede o saldo disponivel","Aviso" ,.T.,4000,3) //"Quantidade excede o saldo disponivel"###"Aviso"
					CONOUT("Quantidade excede o saldo disponivel")
					lRet := .F.
				Else
					SC6->(DbSetOrder(1))
					SC6->(DbSeek(xFilial("SC6")+CB8->CB8_PEDIDO+CB8->CB8_XITPED+CB8->CB8_PROD))
					SC5->(DbSetOrder(1))
					SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM))

					//Saldo Restante Item na separacao
					nSldR := Abs(CB8->CB8_SALDOS - nQuant)

					//Calculo tolerancia financeira Item
					nToleran := (SC6->C6_VALOR)/nToleran

					//lContinua := .F.

					//Verifica a tolerância financeira para este item

					//Verifica se a quantidade lida ultrapassa o saldo de separacao
					If (nQuant > CB8->CB8_SALDOS)
						RecLock("CB8",.F.)
						CB8->CB8_ULQTD := "S"
						MsUnlock()
						//Verifica se a quantidade lida excede a tolerancia permitida
						If (nQuant>CB8->CB8_SALDOS+(CB8->CB8_QTDORI*nOldToleran)/100) //(SC6->C6_QTDLIB>=SC6->C6_QTDVEN+((SC6->C6_QTDVEN*nToleran)/100)) .Or.                                 
							//a tolerancia do financeiro não e excedida, logo libera financeiro/estoque
							//aEmp := CarregaEnd(CB8->CB8_ORDSEP,CB8->CB8_PROD)
							If (SC6->C6_PRCVEN*nSldR)<=nToleran
								lFinanceiro := .F.
								//	MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN,.F.,.F.,.F.,.F.,.F.,.F.,NIL,,aEmp,.T.)
							Else
								lFinanceiro := .T.
								//Libera apenas estoque e bloqueia financeiro
								//	MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN+nSldR,.T.,.F.,.F.,.F.,.F.,.F.,NIL,,aEmp,.T.)								
							EndIf
						EndIf
						RecLock("CB8",.F.)
						CB8->CB8_XULTRA := Iif(lFinanceiro,"S","N")
						MsUnlock()

						//Verifica se a quantidade da etiqueta lida esta dentro da tolerância da quantidade liberada.
						//Modificado por pedido do Francisco com ordem do Sr. Valdenir
						//If (nQuant < CB8->CB8_SALDOS + (CB8->CB8_QTDORI*nToleran)/100)
						lCOntinua := .T.
					Else
						RecLock("CB8",.F.)
						CB8->CB8_ULQTD := "N"		
						CB8->CB8_XULTRA := "N"
						MsUnlock()
						lContinua := .F.
					EndIf

					If lContinua
						BEGIN TRANSACTION                  
							nDiferen :=(nQuant-CB8->CB8_SALDOS)
							//aAreaCB8 := CB8->(GetArea())
							RecLock("CB8",.F.)
							CB8->CB8_QTDORI:=CB8->CB8_QTDORI+nSldR
							CB8->CB8_SALDOS:=nSldR+CB8->CB8_SALDOS
							MsUnlock()	               
							//RestArea(aAreaCB8)

							PA2->(DbSetOrder(5))
							PA2->(DbSeek(xFilial("PA2")+CB8->CB8_ORDSEP+CB8->CB8_ITEM+CB8->CB8_PROD))
							RecLock("PA2",.F.)
							PA2->PA2_QUANT := PA2->PA2_QUANT+nSldR
							MsUnlock()

							nSaldoCB8:=CB8->CB8_SALDOS//+nDiferen
							CB8->(DbGoto(nRecCB8))
							SC6->(DbSetOrder(1))
							If SC6->(DbSeek(xFilial("SC6")+CB8->CB8_PEDIDO+CB8->CB8_XITPED+CB8->CB8_PROD))
								conout("achou")

								If (nSldSep+nQuant)>SC6->C6_QTDVEN
									RecLock("SC6",.F.)
									SC6->C6_QTDLIB	:= (SC6->C6_QTDVEN)+nSldR      
									SC6->C6_QTDEMP	:= (SC6->C6_QTDVEN)+nSldR
									SC6->C6_QTDVEN	:= (SC6->C6_QTDVEN)+nSldR
									SC6->C6_VALOR   := (SC6->C6_QTDVEN)*SC6->C6_PRCVEN
									MsUnlock()
								EndIf
							EndIf
						END TRANSACTION
					EndIf
				EndIf
			EndIf
		EndIF
	EndIf
Return {lRet,nSaldoCB8}

Static Function FSaldSep(cOrdSep,cProduto,cLocal,cEndereco,cLote)
	Local cQry			:= ""
	Local cQryAlias		:= getNextAlias()            
	Local nRet			:= 0
	Default cLocal 		:= ""
	Default cEndereco	:= ""
	Default cLote 		:= ""

	If Select(cQryAlias)>0
		(cQryAlias)	->(DbCloseArea(cQryAlias))
	EndIf

	cQry+=" SELECT CB9_FILIAL,CB9_PROD,SUM(CB9_QTESEP) AS QTDSEP FROM "+RetSQLName("CB9")+" CB9 "
	cQry+=" INNER JOIN "+RetSQLName("CB7")+" CB7 ON "
	cQry+=" CB7.D_E_L_E_T_='' "
	cQry+=" AND CB7.CB7_ORDSEP=CB9.CB9_ORDSEP "
	cQry+=" AND CB7.CB7_STATUS<>'9' "
	cQry+=" WHERE CB9.D_E_L_E_T_='' "
	cQry+=" AND CB9_FILIAL='"+xFilial("CB9")+"'" 
	cQry+=" AND CB9_PROD='"+cProduto+"'"
	If !Empty(cLocal) 
		cQry+=" AND CB9_LOCAL='"+cLocal+"'"
		cQry+=" AND CB9_LCALIZ='"+cEndereco+"'"
		cQry+=" AND CB9_LOTECT='"+cLote+"'"
	EndIf
	cQry+=" GROUP BY CB9_FILIAL,CB9_PROD "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cQryAlias,.T.,.T.)

	nRet :=(cQryAlias)->QTDSEP

	(cQryAlias)->(DbCloseArea(cQryAlias))

Return nRet


Static Function CarregaEnd(cOrdSep,cProduto)
	Local cQry			:= ""
	Local cQryAlias		:= getNextAlias()            
	Local aEmp			:= {}

	If Select(cQryAlias)>0
		(cQryAlias)	->(DbCloseArea(cQryAlias))
	EndIf

	cQry+=" SELECT CB8_LOTECT,CB8_NUMLOT,CB8_LCALIZ,CB8_NUMSER,CB8_LOCAL FROM "+RetSQLName("CB8")+" "
	cQry+=" WHERE D_E_L_E_T_='' "
	cQry+=" AND CB8_FILIAL='"+xFilial("CB8")+"'" 
	cQry+=" AND CB8_ORDSEP='"+cOrdSep+"'"
	cQry+=" AND CB8_PROD='"+cProduto+"'"
	cQry+=" GROUP BY CB8_LOTECT,CB8_NUMLOT,CB8_LCALIZ,CB8_NUMSER,CB8_LOCAL "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cQryAlias,.T.,.T.)

	While !(cQryAlias)->(Eof())
		(cQryAlias)->(aadd(aEmp,{CB8_LOTECT,CB8_NUMLOT,CB8_LCALIZ,CB8_NUMSER,nTotal,ConvUM(CB8_PROD,nQuant,0,2),,,,,CB8_LOCAL,0}))
		(cQryAlias)->(DbSkip())
	EndDo
	(cQryAlias)->(DbCloseArea(cQryAlias))

Return aEmp

