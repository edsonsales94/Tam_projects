#include "rwmake.ch"

User Function RFATM04()

SetPrvt("_CNUMPEDSP,_CNUMPED,_CITEMSP,_CPERG,_NFLAG,ASC5")
SetPrvt("_CTEMPSC5,ASC6,_CTEMPSC6,AREGS,I,J")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATM04 ³ Autor ³Rogerio Batista        ³ Data ³25/07/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Replica Pedido Venda Coel 10 para Sao Roque	          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

*----------------------------------------------------------------------------*
* Definicao de Variaveis                                                     *
*----------------------------------------------------------------------------*

_cNumPedSP:= ""         //----> Armazena numero pedido Sao Paulo
_cNumPed  := ""         //----> Armazena numero pedido extraido GETSX8NUM()
_cItemSP  := ""         //----> Armazena item do pedido Sao Paulo
_cPerg	  := "FATM04"   //----> Armazena grupo de perguntas no SX1
_nFlag    := 0          //----> Flag de Controle Gravacao Cabecalho

If SM0->M0_CODIGO != "04"
	MsgBox("Atencao Sr(a) "+Subs(cUsuario,7,15)+" esta rotina somente podera ser executada na Vicente Pinzon. Por favor, acesse o sistema na empresa correta.","Acesso nao Permitido","Stop")
	Return
EndIf

//----> Arquivo Temporario para SC5
aSC5 := {} //----> Matriz vazia para armazenar estrutura do arquivo

Aadd(aSC5,{"C5_FILIAL   ","C",2 ,0})
Aadd(aSC5,{"C5_NUM      ","C",6 ,0})
Aadd(aSC5,{"C5_TIPO     ","C",1 ,0})
Aadd(aSC5,{"C5_CLIENTE  ","C",6 ,0})
Aadd(aSC5,{"C5_LOJAENT  ","C",2 ,0})
Aadd(aSC5,{"C5_LOJACLI  ","C",2 ,0})
Aadd(aSC5,{"C5_CLPEDCL  ","C",10,0})
Aadd(aSC5,{"C5_CLNOMCL  ","C",10,0})
Aadd(aSC5,{"C5_CLPARC   ","C",1 ,0})
Aadd(aSC5,{"C5_CLANTE   ","C",1 ,0})
Aadd(aSC5,{"C5_CLATEND  ","C",20,0})
Aadd(aSC5,{"C5_TRANSP   ","C",6 ,0})
Aadd(aSC5,{"C5_X_TRANS  ","C",6 ,0})
Aadd(aSC5,{"C5_TIPOCLI  ","C",1 ,0})
Aadd(aSC5,{"C5_CONDPAG  ","C",3 ,0})
Aadd(aSC5,{"C5_TABELA   ","C",1 ,0})
Aadd(aSC5,{"C5_VEND1    ","C",6 ,0})
Aadd(aSC5,{"C5_DESC1    ","N",5 ,0})
Aadd(aSC5,{"C5_EMISSAO  ","D",8 ,0})
Aadd(aSC5,{"C5_TPFRETE  ","C",1 ,0})
Aadd(aSC5,{"C5_MOEDA    ","N",1 ,0})
Aadd(aSC5,{"C5_TIPLIB   ","C",1 ,0})
Aadd(aSC5,{"C5_CLMSPED  ","C",50,0})
Aadd(aSC5,{"C5_CLCLISP  ","C",06,0})
Aadd(aSC5,{"C5_CLLOJSP  ","C",02,0})
Aadd(aSC5,{"C5_CLTRASP  ","C",06,0})
Aadd(aSC5,{"C5_MENNOTA  ","C",60,0})

_cTempSC5 := CriaTrab( aSC5, .T. )
//DbUseArea(.T.,__cRdd,_cTempSC5,"TB5",IF(.T. .OR. .F., !.F., NIL), .F. )
DbUseArea(.T.,,_cTempSC5,"TB5", NIL, .F. )

//----> Arquivo Temporario para SC6
aSC6 := {} //----> Matriz vazia para armazenar estrutura do arquivo

Aadd(aSC6,{"C6_FILIAL   ","C",2 ,0})
Aadd(aSC6,{"C6_ITEM     ","C",2 ,0})
Aadd(aSC6,{"C6_PRODUTO  ","C",15,0})
Aadd(aSC6,{"C6_UM       ","C",2 ,0})
Aadd(aSC6,{"C6_QTDVEN   ","N",9 ,2})
Aadd(aSC6,{"C6_PRCVEN   ","N",14,4})
Aadd(aSC6,{"C6_VALOR    ","N",12,2})
Aadd(aSC6,{"C6_TES      ","C",3 ,0})
Aadd(aSC6,{"C6_CF       ","C",4 ,0})
Aadd(aSC6,{"C6_LOCAL    ","C",2 ,0})
Aadd(aSC6,{"C6_CLI      ","C",6 ,0})
Aadd(aSC6,{"C6_ENTREG   ","D",8 ,0})
Aadd(aSC6,{"C6_SEMANA   ","N",2 ,0})
Aadd(aSC6,{"C6_LOJA     ","C",2 ,0})
Aadd(aSC6,{"C6_NUM      ","C",6 ,0})
Aadd(aSC6,{"C6_PEDCLI   ","C",9 ,0})
Aadd(aSC6,{"C6_DESCRI   ","C",30,0})
Aadd(aSC6,{"C6_PRUNIT   ","N",14,4})
Aadd(aSC6,{"C6_CLASFIS  ","C",3 ,0})
Aadd(aSC6,{"C6_CLPEDSP  ","C",6 ,0})
Aadd(aSC6,{"C6_CLITPSP  ","C",2 ,0})
Aadd(aSC6,{"C6_CLCLISP  ","C",6 ,0})
Aadd(aSC6,{"C6_CLLOJSP  ","C",2 ,0})
Aadd(aSC6,{"C6_CLGOP    ","C",1 ,0})
Aadd(aSC6,{"C6_MOEDA    ","N",1 ,0})

_cTempSC6 := CriaTrab( aSC6, .T. )
//DbUseArea(.T.,__cRdd,_cTempSC6,"TB6",IF(.T. .OR. .F., !.F., NIL), .F. )
DbUseArea(.T.,,_cTempSC6,"TB6", NIL, .F. )

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Arquivos utilizados no processamento                                       *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

Processa({||RunProc()},"Selecionando Registros Pedidos Vendas")
Return()

Static Function RunProc()

//ValidPerg()

Pergunte(_cPerg,.t.)

DbSelectArea("SC5")
DbSetOrder(2)
DbSeek(xFilial("SC5")+Dtos(MV_PAR01),.t.)

ProcRegua(LastRec())

While Eof() == .f. .And. SC5->C5_FILIAL == xFilial("SC5") .And. Dtos(SC5->C5_EMISSAO) <= Dtos(MV_PAR02)
	
	IncProc("Processando Pedido "+SC5->C5_NUM)
	
	If !Empty(SC5->C5_CLPVTOK)
		DbSkip()
		Loop
	EndIf
	
	//----> filtrando somente os pedidos de venda
	If SC5->C5_TIPO #"N"
		DbSkip()
		Loop
	EndIf

		//----> guardando dados pedido Sao Paulo
		
		_cNumPedSP := SC5->C5_NUM
		
		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(xFilial("SC6")+_cNumPedSP)
		
		While SC6->C6_NUM == _cNumPedSP
			
			If SC6->C6_CLGOP #"S"
				DbSkip()
				Loop
			EndIf
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			dbseek(xFilial() + SC6->C6_PRODUTO)
			
			DbSelectArea("SC6")
			
			If SB1->B1_X_FABRI == "M"
				DbSkip()
				Loop
			EndIf
			
			If _nFlag == 0
				//----> gravando dados pedido transferencia Sao Roque para Sao Paulo
				DbSelectArea("TB5")
				RecLock("TB5",.T.)
				_cNumPed := GetSX8Num("P10") //----> buscando a numeracao do pedido
				ConfirmSX8()                 //----> a ser gravado
				
				TB5->C5_FILIAL      := "02"
				TB5->C5_NUM         := _cNumPed
				TB5->C5_TIPO        := "N"
				TB5->C5_CLIENTE     := "000649"
				TB5->C5_LOJAENT     := "01"
				TB5->C5_LOJACLI     := "01"
				TB5->C5_CLNOMCL     := Posicione("SA1",1,xFilial("SA1")+"000649"+"01","A1_NREDUZ")
				TB5->C5_CLPEDCL     := _cNumPedSP
				TB5->C5_CLPARC      := SC5->C5_CLPARC
				TB5->C5_CLANTE      := SC5->C5_CLANTE
				TB5->C5_CLATEND     := SC5->C5_CLATEND //"TRANSF.P/SP"
				TB5->C5_TRANSP      := "100002"
				TB5->C5_TIPOCLI     := "R"
				TB5->C5_CONDPAG     := "999"
				TB5->C5_TABELA      := "1"
				TB5->C5_VEND1       := "90001"
				TB5->C5_DESC1       := 75
				TB5->C5_EMISSAO     := dDataBase
				TB5->C5_TPFRETE     := "C"
				TB5->C5_MOEDA       := 1
				TB5->C5_TIPLIB      := "1"
				TB5->C5_CLMSPED     := SC5->C5_CLMSPED
				TB5->C5_CLCLISP     := SC5->C5_CLIENTE
				TB5->C5_CLLOJSP     := SC5->C5_LOJACLI
				TB5->C5_CLTRASP     := SC5->C5_TRANSP
				MsUnLock()
				
				_nFlag := 1
				
			EndIf
			
			//----> gravando itens pedidos transferencia Sao Roque para Sao Paulo
			DbSelectArea("TB6")
			RecLock("TB6",.t.)
		
			TB6->C6_FILIAL      := "02"
		    TB6->C6_ITEM        := SC6->C6_ITEM
			TB6->C6_PRODUTO     := SC6->C6_PRODUTO
			TB6->C6_UM          := SC6->C6_UM
			TB6->C6_QTDVEN      := SC6->C6_QTDVEN
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
			
			//----> validacao de produtos sem desconto de 30% - alterado por Ricardo Correa em 01/12/01
			
			If Substr(SB1->B1_COD,1,2) >= "30"
				TB6->C6_PRCVEN := SB1->B1_UPRC
				TB6->C6_VALOR  := (SC6->C6_QTDVEN * SB1->B1_UPRC) //----> valor materia-prima
				TB6->C6_TES    := "512"
				TB6->C6_CF     := "5152"
			Else
				TB6->C6_PRCVEN      := (SC6->C6_PRUNIT * 0.25 ) //----> valor transferencia
				TB6->C6_VALOR       := (SC6->C6_QTDVEN * ( SC6->C6_PRUNIT * 0.25 ))
				TB6->C6_TES         := "511"
				TB6->C6_CF          := "5151"
			Endif
			
			TB6->C6_LOCAL       := SC6->C6_LOCAL
			TB6->C6_CLI         := "000649"
			TB6->C6_LOJA        := "01"
			TB6->C6_ENTREG      := SC6->C6_ENTREG
			TB6->C6_SEMANA      := SC6->C6_SEMANA
			TB6->C6_NUM         := _cNumPed
			TB6->C6_PRUNIT      := SC6->C6_PRUNIT
			TB6->C6_DESCRI      := SC6->C6_DESCRI
			TB6->C6_CLASFIS     := SC6->C6_CLASFIS
			TB6->C6_CLPEDSP     := _cNumPedSP
			TB6->C6_CLITPSP     := SC6->C6_ITEM
			TB6->C6_MOEDA       := 1
			TB6->C6_CLCLISP     := SC5->C5_CLIENTE
			TB6->C6_CLLOJSP     := SC5->C5_LOJACLI
			TB6->C6_PEDCLI      := _cNumPedSP+"/"+SC6->C6_ITEM
			TB6->C6_CLGOP       := SC6->C6_CLGOP
			MsUnLock()
			
			DbSelectArea("SC6")
			DbSkip()
		EndDo
	
	If _nFlag == 1
		DbSelectArea("SC5")
		RecLock("SC5",.f.)
		SC5->C5_CLPVTOK := _cNumPed
		MsUnLock()
	EndIf
	
	_nFlag := 0
	
	DbSelectArea("SC5")
	DbSkip()
EndDo
// abre pedido venda empresa 01
DBUSEAREA(.T.,"TOPCONN","SC5010","SC5010",.T.)
DBUSEAREA(.T.,"TOPCONN","SC6010","SC6010",.T.)
DBUSEAREA(.T.,"TOPCONN","SB2010","SB2010",.T.)
TcCanOpen("SB2010","SB20101")
ORDLISTADD("SB20101")

DbSelectArea("TB5")
DbGoTop()
While !Eof()
	
	DbSelectArea("SC5010")
	RecLock("SC5010",.t.)
	SC5010->C5_FILIAL      := TB5->C5_FILIAL
	SC5010->C5_NUM         := TB5->C5_NUM
	SC5010->C5_TIPO        := TB5->C5_TIPO
	SC5010->C5_CLIENTE     := TB5->C5_CLIENTE
	SC5010->C5_LOJAENT     := TB5->C5_LOJAENT
	SC5010->C5_LOJACLI     := TB5->C5_LOJACLI
	SC5010->C5_CLNOMCLI    := TB5->C5_CLNOMCLI
	SC5010->C5_CLPEDCL     := TB5->C5_CLPEDCL
	SC5010->C5_CLPARC      := TB5->C5_CLPARC
	SC5010->C5_CLANTE      := TB5->C5_CLANTE
	SC5010->C5_CLATEND     := TB5->C5_CLATEND
	SC5010->C5_TRANSP      := TB5->C5_TRANSP
	SC5010->C5_TIPOCLI     := TB5->C5_TIPOCLI
	SC5010->C5_CONDPAG     := TB5->C5_CONDPAG
	SC5010->C5_TABELA      := TB5->C5_TABELA
	SC5010->C5_VEND1       := TB5->C5_VEND1
	SC5010->C5_DESC1       := TB5->C5_DESC1
	SC5010->C5_EMISSAO     := TB5->C5_EMISSAO
	SC5010->C5_TPFRETE     := TB5->C5_TPFRETE
	SC5010->C5_MOEDA       := TB5->C5_MOEDA
	SC5010->C5_TIPLIB      := TB5->C5_TIPLIB
	SC5010->C5_CLMSPED     := TB5->C5_CLMSPED
	SC5010->C5_CLCLISP     := TB5->C5_CLCLISP
	SC5010->C5_CLLOJSP     := TB5->C5_CLLOJSP
	SC5010->C5_CLTRASP     := TB5->C5_CLTRASP
	MsUnLock()
	
	DbSelectArea("TB5")
	DbSkip()
End

DbCloseArea("TB5")

DbSelectArea("TB6")
DbGoTop()
While !Eof()
	DbSelectArea("SC6010")
	RecLock("SC6010",.t.)
	SC6010->C6_FILIAL      := TB6->C6_FILIAL
	SC6010->C6_ITEM        := TB6->C6_ITEM
	SC6010->C6_PRODUTO     := TB6->C6_PRODUTO
	SC6010->C6_UM          := TB6->C6_UM
	SC6010->C6_QTDVEN      := TB6->C6_QTDVEN
	SC6010->C6_PRCVEN      := TB6->C6_PRCVEN
	SC6010->C6_VALOR       := TB6->C6_VALOR
	SC6010->C6_TES         := TB6->C6_TES
	SC6010->C6_CF          := TB6->C6_CF
	SC6010->C6_LOCAL       := TB6->C6_LOCAL
	SC6010->C6_CLI         := TB6->C6_CLI
	SC6010->C6_LOJA        := TB6->C6_LOJA
	SC6010->C6_ENTREG      := TB6->C6_ENTREG
	SC6010->C6_SEMANA      := TB6->C6_SEMANA
	SC6010->C6_NUM         := TB6->C6_NUM
	SC6010->C6_PRUNIT      := TB6->C6_PRUNIT
	SC6010->C6_DESCRI      := TB6->C6_DESCRI
	SC6010->C6_CLASFIS     := TB6->C6_CLASFIS
	SC6010->C6_CLPEDSP     := TB6->C6_CLPEDSP
	SC6010->C6_CLITPSP     := TB6->C6_CLITPSP
	SC6010->C6_CLCLISP     := TB6->C6_CLCLISP
	SC6010->C6_CLLOJSP     := TB6->C6_CLLOJSP
	SC6010->C6_PEDCLI      := TB6->C6_PEDCLI
	SC6010->C6_CLGOP       := TB6->C6_CLGOP
	SC6010->C6_MOEDA       := TB6->C6_MOEDA
	MsUnLock()
	
	DbSelectArea("SB2010")
	DbSeek("02"+TB6->C6_PRODUTO+TB6->C6_LOCAL)
	If Found()
		RecLock("SB2010",.f.)
		SB2010->B2_QPEDVEN := SB2010->B2_QPEDVEN + TB6->C6_QTDVEN
		MsUnlock()
	EndIf
	
	DbSelectArea("TB6")
	DbSkip()
End

DbCloseArea("TB6")


dbSelectArea("SC5010")
DbCloseArea()

dbSelectArea("SC6010")
DbCloseArea()

dbSelectArea("SB2010")
DbCloseArea()


Ferase(_cTempSC5+".dbf")
Ferase(_cTempSC5+".idx")
Ferase(_cTempSC5+".mem")
Ferase(_cTempSC6+".dbf")
Ferase(_cTempSC6+".idx")
Ferase(_cTempSC6+".mem")
                              
Execblock("RFATM05",.F.,.F.)

Return




*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Fim do Programa                                                            *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)

aRegs :={}
Aadd(aRegs,{_cPerg,"01","Da Data                 ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{_cPerg,"02","Ate a Data              ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !DbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	EndIf
Next
Return

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Fim da Funcao ValidPerg                                                    *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*


