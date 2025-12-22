#include "rwmake.ch"       
/*/{protheus.doc}ESTEMP
Relatorio Analise estoque x empenho - por Op
@author Honda Lock
@since 07/02/2002
/*/
User Function ESTEMP()        


SetPrvt("CRODATXT,TITULO,CDESC1,CDESC2,CDESC3,AORD")
SetPrvt("NOMEPROG,CPERG,CSTRING,M_PAG,TAMANHO,_AARRAY")
SetPrvt("NLASTKEY,_NTIPO,_NCNTIMP,_NSALDOPR,_NEMPPR,_NSCPR")
SetPrvt("_NPCPR,_NOPPR,_NPVPR,_NSALDSUB,_NEMPSUB,_NSCSUB")
SetPrvt("_NPCSUB,_NOPSUB,_NPVSUB,_NSALDOTOT,_NEMPTOT,_NSCTOT")
SetPrvt("_NPCTOT,_NOPTOT,_NPVTOT,_NSALDO,_DUSAI,_CCONTRL")
SetPrvt("_CQUEBRA,LI,LPASSOU1,LPASSOU2,LCONTINUA,ARETURN")
SetPrvt("CSAVSCR1,WNREL,CABEC1,CABEC2,A,")


cRodaTxt   := "PRODUTO(S)"
titulo     := "RELACAO ANALISE ESTOQUES x EMPENHO - Por OP"
cDesc1     := "Este relatorio demonstra a situacao de cada item em relacao ao"
cDesc2     := "seu saldo, seu empenho, suas entradas previstas. Tem como pon-"
cDesc3     := "to de partida a OP passando a seguir ao empenho da mesma.     "
aOrd       := {" Por Codigo         "," Por Tipo           "," Por Descricao     "," Por Grupo        "}
nomeprog   := "ESTEMP"
cPerg      := "ESTEMP"
cString    := "SB1"
m_pag      := 1
Tamanho    := "G"
_aArray    := {}
nLastKey   := 0;_nTipo  := 0;_nCntImp:= 0;_nSaldoPr := 0;_nEmpPr   := 0
_nSCPr     := 0;_nPCPr  := 0;_nOPpr  := 0;_nPVpr    := 0;_nSaldSub := 0
_nEmpSub   := 0;_nSCSub := 0;_nPCSub := 0;_nOPSub   := 0;_nPVsub   := 0
_nSaldoTot := 0;_nEmpTot:= 0;_nSCTot := 0;_nPCtot   := 0;_nOPtot   := 0
_nPVtot    := 0;_nSaldo := 0;_dUsai  := 0;_cContrl  := " "         //Variavel p/ controlar se produto ja impresso
_cQuebra   := " "
li         := 80
lPAssou1   := .F.
lPassou2   := .F.
lContinua  := .T.

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Variaveis tipo Private padrao de todos os relatorios         ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aReturn:= { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Verifica as perguntas selecionadas                           ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Variaveis utilizadas para parametros                         ?
//?mv_par01     // Da Op                                        ?
//?mv_par02     // Ate a OP                                     ?
//?mv_par03     // Do Produto                                   ?
//?mv_par04     // Ate o Produto                                ?
//?mv_par05     // Considera OP Encerrada - Sim / Nao           ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
pergunte(cPerg,.F.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Envia controle para a funcao SETPRINT                        ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

If LastKey() == 27 .or. nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .OR. nLastKey == 27
	Return
Endif

RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 15/07/02 ==>         RptStatus({|| Execute(RptDetail)})
Return
// Substituido pelo assistente de conversao do AP5 IDE em 15/07/02 ==>         Function RptDetail
Static Function RptDetail()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Inicializa os codigos de caracter Comprimido/Normal da impressora ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//_nTipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))
Cabec1   := ""
Cabec2   := ""

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Monta os Cabecalhos                                          ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cabec1 := "CODIGO          DESCRICAO                      TP GRUP UM    SALDO ATUAL   EMPENHO PARA           SC's           PC's           OP's           PV's     PONTO DE         LOTE   PRAZO       CONSUMO      ULTIMA "
cabec2 := "                                                                         REQ/PV/RESERVA      COLOCADAS      COLOCADOS      COLOCADAS      COLOCADOS       PEDIDO    ECONOMICO ENTREGA        MEDIO        SAIDA "
*****      123456789012345 123456789012345678901234567890 12 1234 12 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 9,999,999.99 9,999,999.99 99999 D    99,999,999.99 11/11/11  A
*****      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18            20        21
*****      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

DbSelectArea("SC2")

Set Softseek On
DbSetOrder(1)
DbSeek (("SC2")+ mv_par01)
Set SoftSeek Off      

//*---<Regua - Parte I>---*
SetRegua(RecCount())

While !Eof() .And. C2_NUM+C2_ITEM+C2_SEQUEN <= mv_par02
	
	//*---<Regua - Parte II>---*
	IncRegua()
	//*--<Filtro por Produto>--*
	
	If C2_PRODUTO <= mv_par03 .or. C2_PRODUTO >= mv_par04
		dbskip()
		loop
	Endif
	
	//*--<Nao imprime OP encerrada>--*
	If mv_par05 == 2 .and. C2_QUJE >= C2_QUANT
		dbskip()
		loop
	Endif
	
	DbSelectArea("SB1")
	DbSetOrder(1)
  	DbSeek(xfilial("SB1")+SC2->C2_PRODUTO)		//Corre豫o - Luciano Lamberti (13-09-2017)
	DbSelectArea("SC2")
	AADD(_aArray, {C2_NUM+C2_ITEM+C2_SEQUEN,C2_PRODUTO,_cContrl,SB1->B1_DESC} )
	dbskip()
EndDo

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Indexa   Array                                               ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aSort( _aArray,,, { |x, y| (x[1]+x[2]) < (y[1]+y[2])} )

For A:=1 to len(_aArray)
	DbSelectArea("SD4")
	DbSetOrder(2)
	DbSeek(xfilial("SD4")+_aArray[A,1])		//Corre豫o - Luciano Lamberti (13-09-2017)
	
	//*---<Regua - Parte I>---*
	SetRegua(RecCount())
	
	While ("SD4")+_aArray[A,1] == D4_OP
		//*---<Regua - Parte II>---*
		IncRegua()
		
		If subs(D4_COD,1,3) == "MOD" //.or. subs(D4_COD,1,1) == "5"
			dbskip()
			loop
		Endif
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xfilial("SB1")+SD4->D4_COD)		//Corre豫o - Luciano Lamberti (13-09-2017)
		While B1_COD == SD4->D4_COD
			
			
			If lAbortPrint
				@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
				Exit
			Endif
			
			Store 0 To _nSaldoPr,_nEmpPr,_nSCPr,_nPCPr,_nOPpr,_nPVpr
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Soma os saldos iniciais e os empenhos do SB2                 ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			DbSelectArea("SB2")
		  	DbSeek(xfilial("SB2")+SB1->B1_COD)		//Corre豫o - Luciano Lamberti (13-09-2017)
			_dUsai := B2_USAI
			While !Eof() .And. B2_COD == SB1->B1_COD
				If lAbortPrint
					@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
					Exit
				Endif
				
			  /*	IF B2_LOCAL # "98"
					dbSkip()
					Loop
				EndiF */  
				
				_nSaldoPr := _nSaldoPr + B2_QATU
				_nEmpPr   := _nEmpPr + (B2_QEMP+B2_RESERVA)
				If _dUsai < B2_USAI
					_dUsai := B2_USAI
				EndIf
				dbSkip()
			EndDo
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Verifica se o relatorio foi interrompido pelo usuario        ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			If !lContinua
				Exit
			EndIf
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Posiciona-se no arquivo de Demandas para pegar dados         ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			DbSelectArea("SB3")
		 	DbSeek(xfilial("SB3")+SB1->B1_COD)		//Corre豫o - Luciano Lamberti (13-09-2017)
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Aglutina as Solicitacos de Compra sem pedido colocado        ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			DbSelectArea("SC1")
			DbSetOrder(2)
		  	DbSeek(xfilial("SC1")+SB1->B1_COD)		//Corre豫o - Luciano Lamberti (13-09-2017)
			While !Eof() .And. C1_PRODUTO == SB1->B1_COD
				
				If lAbortPrint
					@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
					Exit
				Endif
				
				If C1_QUJE < C1_QUANT .And. Empty(C1_COTACAO)
					_nSCPr := _nSCPr + (C1_QUANT - C1_QUJE)
				EndIf
				dbSkip()
			EndDo
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Verifica se o relatorio foi interrompido pelo usuario        ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			If !lContinua
				Exit
			EndIf
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Aglutina as Ordens de Producao em aberto                     ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			DbSelectArea("SC2")
			DbSetOrder(2)
	    	DbSeek(xfilial("SC2")+SB1->B1_COD)		//Corre豫o - Luciano Lamberti (13-09-2017)
			
			While !Eof() .And. C2_PRODUTO == SB1->B1_COD
				
				If lAbortPrint
					@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
					Exit
				Endif
				
				If Empty(C2_DATRF) .And. (C2_QUANT-C2_QUJE-C2_PERDA) > 0
					_nOPpr := _nOPpr + (C2_QUANT-C2_QUJE-C2_PERDA)
				EndIf
				dbSkip()
			EndDo
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Verifica se o relatorio foi interrompido pelo usuario        ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			If !lContinua
				Exit
			EndIf
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Aglutina os Pedidos de Vendas ainda nao entregues            ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			DbSelectArea("SC6")
			DbSetOrder(2)
		 	DbSeek(xfilial("SC6")+SB1->B1_COD)		//Corre豫o - Luciano Lamberti (13-09-2017)
			While !Eof() .And. C6_PRODUTO == SB1->B1_COD
				
				If lAbortPrint
					@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
					Exit
				Endif
				
				If ( C6_QTDVEN - ( C6_QTDEMP + C6_QTDENT ) ) > 0
					_nPVpr := _nPVpr + ( C6_QTDVEN - ( C6_QTDEMP + C6_QTDENT ) )
				EndIf
				dbSkip()
			EndDo
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Verifica se o relatorio foi interrompido pelo usuario        ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			If !lContinua
				Exit
			EndIf
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Aglutina os Pedidos de Compra ainda nao entregues            ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			DbSelectArea("SC7")
			DbSetOrder(2)
		  	DbSeek(xfilial("SC7")+SB1->B1_COD)		//Corre豫o - Luciano Lamberti (13-09-2017)
			While !Eof() .And. C7_PRODUTO == SB1->B1_COD
				
				If lAbortPrint
					@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
					Exit
				Endif
				
				If (C7_QUANT-C7_QUJE) > 0 .And. Empty(C7_RESIDUO)
					_nPCPr := _nPCPr + (C7_QUANT-C7_QUJE)
				EndIf
				dbSkip()
			EndDo
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Verifica se o relatorio foi interrompido pelo usuario        ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			If !lContinua
				Exit
			EndIf
			lPassou1 := .T.
			lPassou2 := .T.
			If li > 58
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,15)
 			    li := li + 1
			EndIf
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//?Adiciona 1 ao contador de registros impressos         ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			_nCntImp := _nCntImp + 1
			
			If _cQuebra #_aArray[A][1]
				If ! empty(_cQuebra)
					@ li,000 PSAY "TOTAIS : "
					@ li,058 PSAY _nSaldSub  Picture PesqPictQt("B2_QATU",14)
					@ li,073 PSAY _nEmpSub   Picture PesqPictQt("B2_QEMP",14)
					@ li,088 PSAY _nSCSub    Picture PesqPictQt("C1_QUANT",14)
					@ li,103 PSAY _nPCSub    Picture PesqPictQt("C7_QUANT",14)
					@ li,118 PSAY _nOPSub    Picture PesqPictQt("C2_QUANT",14)
					@ li,133 PSAY _nPVSub    Picture PesqPictQt("C6_QTDVEN",14)
					li := li + 1
					@ li,000 PSAY replicate("-",218)
					li := li + 1
				Endif
				@ li,000 PSAY "PRODUTO PAI: " + _aArray[A][2] + " - "+_aArray[A][4]
				@ li,118 PSAY "OP : " + _aArray[A][1]
				li := li + 1
				_cQuebra  := _aArray[A][1]
				_nSaldSub := 0
				_nEmpSub  := 0
				_nSCSub   := 0
				_nPCSub   := 0
				_nOPSub   := 0
				_nPVSub   := 0
			Endif
			
			dbSelectArea("SB1")
			
			@ li,000 PSAY B1_COD
			@ li,016 PSAY Substr(B1_DESC,1,30)
			@ li,047 PSAY B1_TIPO
			@ li,050 PSAY B1_GRUPO
			@ li,055 PSAY B1_UM
			@ li,058 PSAY _nSaldoPr Picture PesqPictQt("B2_QATU",14)
			@ li,073 PSAY _nEmpPr   Picture PesqPictQt("B2_QEMP",14)
			@ li,088 PSAY _nSCPr    Picture PesqPictQt("C1_QUANT",14)
			@ li,103 PSAY _nPCPr    Picture PesqPictQt("C7_QUANT",14)
			@ li,118 PSAY _nOPpr    Picture PesqPictQt("C2_QUANT",14)
			@ li,133 PSAY _nPVpr    Picture PesqPictQt("C6_QTDVEN",14)
			@ li,148 PSAY B1_EMIN   Picture PesqPictQt("B1_EMIN",12)
			@ li,161 PSAY B1_LE     Picture PesqPictQt("B1_LE",12)
			@ li,174 PSAY CalcPrazo(B1_COD,B1_LE) Picture "99999"
			@ li,180 PSAY B1_TIPE
			@ li,181 PSAY SB3->B3_MEDIA Picture PesqPictQt("B3_MEDIA",13)
			@ li,199 PSAY _dUsai
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Total Quebra                                                 ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			_nSaldSub  := _nSaldSub + _nSaldoPr
			_nEmpSub   := _nEmpSub + _nEmpPr
			_nSCSub    := _nSCSub + _nSCPr
			_nPCSub    := _nPCSub + _nPCPr
			_nOPSub    := _nOPSub + _nOPpr
			_nPVsub    := _nPVsub + _nPVpr
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Soma Total Geral                                             ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			_nSaldoTot := _nSaldoTot + _nSaldoPr
			_nEmpTot   := _nEmpTot + _nEmpPr
			_nSCTot    := _nSCTot + _nSCPr
			_nPCtot    := _nPCtot + _nPCPr
			_nOPtot    := _nOPtot + _nOPPr
			_nPVtot    := _nPVtot + _nPVPr
			DbSkip()
			li := li + 1
		EndDo
		dbSelectArea("SD4")
		dbskip()
	Enddo
Next

If lPassou1
	li := li + 1
	@ li,000 PSAY "TOTAIS : "
	@ li,058 PSAY _nSaldSub  Picture PesqPictQt("B2_QATU",14)
	@ li,073 PSAY _nEmpSub   Picture PesqPictQt("B2_QEMP",14)
	@ li,088 PSAY _nSCSub    Picture PesqPictQt("C1_QUANT",14)
	@ li,103 PSAY _nPCSub    Picture PesqPictQt("C7_QUANT",14)
	@ li,118 PSAY _nOPSub    Picture PesqPictQt("C2_QUANT",14)
	@ li,133 PSAY _nPVSub    Picture PesqPictQt("C6_QTDVEN",14)
	li := li + 1
	@ li,000 PSAY replicate("-",218)
	li := li + 1
	@ li,024 PSAY "T O T A L   G E R A L :"
	@ li,058 PSAY _nSaldoTot Picture PesqPictQt("B2_QATU",14)
	@ li,073 PSAY _nEmpTot   Picture PesqPictQt("B2_QEMP",14)
	@ li,088 PSAY _nSCTot    Picture PesqPictQt("C1_QUANT",14)
	@ li,103 PSAY _nPCtot    Picture PesqPictQt("C7_QUANT",14)
	@ li,118 PSAY _nOPtot    Picture PesqPictQt("C2_QUANT",14)
	@ li,133 PSAY _nPVtot    Picture PesqPictQt("C6_QTDVEN",14)
EndIf

If li != 80
	Roda(_nCntImp,cRodaTxt,Tamanho)
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Devolve a condicao original do arquivo principal             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
RetIndex("SC2")
RetIndex("SD4")
RetIndex("SB1")
RetIndex("SB2")
RetIndex("SB3")
RetIndex("SC1")
RetIndex("SC6")
RetIndex("SC7")

dbSelectArea(cString)
Set Filter To
Set Order To 1

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
