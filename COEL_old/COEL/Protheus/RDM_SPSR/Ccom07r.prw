#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 28/12/01

#DEFINE  LINHA_BOX  oPrn:Box( Linha   ,  50 , Linha+7 , 2280)

User Function CCOM07R()        // incluido pelo assistente de conversao do AP5 IDE em 28/12/01

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,NBASEIPI,CSTRING")
SetPrvt("TAMANHO,TITULO,ARETURN,NOMEPROG,NLASTKEY,NBEGIN")
SetPrvt("ALINHA,ADRIVER,CPERG,LEND,AUSUARIOS,ASENHAS")
SetPrvt("NHDLALCA,NTAMALCA,NLIDOS,CREGISTRO,_nVez,_nVezes")
SetPrvt("NREEM,LIMITE,LI,NTOTNOTA,NTOTGER,NTOTIPI")
SetPrvt("NDESCPROD,NTOTAL,_cNumPed,NORDEM,COBS01,COBS02")
SetPrvt("COBS03,COBS04,LLIBERADOR,CVAR,CDESC,NLINREF")
SetPrvt("CDESCRI,NLINHA,MV_PAR06,bBLOCO,bBLOCO1,bBLOCO2")
SetPrvt("NK,NTOTDESC,CMENSAGEM,CALIAS,NREGISTRO,COBS")
SetPrvt("NX,NTOTGERAL,CLIBERADOR,NPOSICAO,CSENHAA,EXPC1")
SetPrvt("EXPC2,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR110  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Pedido de Compras                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ OBS      ³ Programa trans.p/ RDMAKE em 06/01/97 por Fabricio C.David  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

wnrel    := "MATR110"
cDesc1   :="Emissao dos pedidos de compras ou autorizacoes de entrega"
cDesc2   :="cadastradados e que ainda nao foram impressos"
cDesc3   :=" "
nBaseIPI :=""
cString  := "SC7"

tamanho  :="P"
titulo   :="Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
nomeprog :="MATR110"
nLastKey := 0
nBegin   :=0
aLinha   :={ }
aDriver  :=ReadDriver()
cPerg    :="MTR110"
lEnd     := .F.
oPrn    := TMSPrinter():New()

oFont09  := TFont():New( "Times New Roman",,09,,.f.,,,,.f.,.f. )
oFont09b := TFont():New( "Times New Roman",,09,,.t.,,,,.f.,.f. )
oFont09bi:= TFont():New( "Times New Roman",,09,,.t.,,,,.t.,.f. )
oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,.f.,.f. )
oFont10  := TFont():New( "Times New Roman",,10,,.f.,,,,.f.,.f. )
oFont14b := TFont():New( "Times New Roman",,14,,.t.,,,,.f.,.f. )

#COMMAND TRACOS_LATERAIS                   => oPrn:Box( Linha-20,   50, Linha+50, 56 ) ;
                                           ;  oPrn:Box( Linha-20, 2273, Linha+50, 2280)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Do Pedido                             ³
//³ mv_par02               Ate o Pedido                          ³
//³ mv_par03               A partir da data de emissao           ³
//³ mv_par04               Ate a data de emissao                 ³
//³ mv_par05               Somente os Novos                      ³
//³ mv_par06               Campo Descricao do Produto            ³
//³ mv_par07               Unidade de Medida:Primaria ou Secund. ³
//³ mv_par08               Imprime ? Pedido Compra ou Aut. Entreg³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR110",.F.)
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
aDriver  :=ReadDriver()

If MV_PAR08 == 1
	//	If File(cArqAlca) .And. GetMV("MV_ALCADA") == "S"
	If GetMV("MV_ALCADA") == "S"
		aUsuarios := {}
		aSenhas := {}
		nHdlAlca := FOPEN(cArqAlca,2)
		nTamAlca := FSEEK(nHdlAlca,0,2)
		FSEEK(nHdlAlca,0,0)
		nLidos := 0
		While nLidos < nTamAlca
			cRegistro := Space(82)
			FREAD(nHdlAlca,@cRegistro,82)
			AADD(aUsuarios,{ cRegistro } )
			AADD(aSenhas,{ SubStr(cRegistro,2,6) } )
			nLidos := 82
			nLidos:=nLidos+1
		End
		FCLOSE(nHdlAlca)
	EndIf
Endif

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

If MV_PAR08 == 1
	RptStatus({||C110PC()})
Else
	RptStatus({||C110AE()})
EndIf

Return()

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110PC   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/
Static Function C110PC()
_nVez   := 1
_nVezes := MV_PAR09
If _nVezes < 1
	_nVezes := 1
EndIf
SETPRC(0,0)

Do While _nVez <= _nVezes
	
	nReem    :=""
	limite   := 130
	li       := 80
	nTotNota := 0
	nTotGer  := 0
	nTotIpi  := 0
	nDescProd:= 0
	nTotal   := 0
	_cNumPed := Space(6)
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	Set SoftSeek On
	dbSeek(xFilial("SC7")+MV_PAR01)
	Set SoftSeek Off
	SetRegua(RecCount())
	
	Do While C7_FILIAL = xFilial("SC7") .And. C7_NUM >= mv_par01 .And. C7_NUM <= mv_par02 .And. !Eof()
		nTotNota := 0
		nTotal   := 0
		nTotGer  := 0
		nTotIpi  := 0
		nDescProd:= 0
		nOrdem   := 1
		nReem    := 0
		cObs01   := " "
		cObs02   := " "
		cObs03   := " "
		cObs04   := " "
		
		If C7_EMITIDO == "S" .And. mv_par05 == 1
			dbSkip()
			Loop
		Endif
		
		If (SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)
			dbSkip()
			Loop
		Endif
		
		If SC7->C7_TIPO <> 1
			dbSkip()
			Loop
		EndIf
		
		lLiberador := .F.
		If GetMV("MV_ALCADA") == "S"
			If !File(cArqAlca)
				lLiberador := .F.
			Else
				lLiberador := .T.
				If Empty(C7_CODLIB)
					dbSkip()
					Loop
				EndIf
			EndIf
		EndIf
		
		If aReturn[4] == 1                              // Comprimido
			@ 001,000 PSAY &(aDriver[1])
		ElseIf aReturn[4] == 2                          // Normal
			@ 001,000 PSAY &(aDriver[2])
		EndIf
		
		ImpCabec()
		nTotNota :=nTotNota+1
		nTotNota := SC7->C7_FRETE
		nReem    := SC7->C7_QTDREEM + 1
		Do While SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == _cNumPed
			If lEnd
				@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
				Goto Bottom
				Exit
			Endif
			
			IncRegua()
			
			If li > 56
				nOrdem:=nOrdem + 1
				ImpRodape()
				ImpCabec()
			Endif
			
			li:=li+1
			
			@ li,001 PSAY "|"
			@ li,002 PSAY C7_ITEM           Picture PesqPict("SC7","c7_item")
			@ li,005 PSAY "|"
			@ li,006 PSAY C7_PRODUTO        Picture PesqPict("SC7","c7_produto")
			
			ImpProd()
			
			nDescProd:= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			nBaseIPI := SC7->C7_TOTAL - IIF(SC7->C7_IPIBRUT=="L",nDescProd,0)
			nTotIpi:=nTotIpi+Round(nBaseIPI*SC7->C7_IPI/100,2)
			
			If SC7->C7_ITEM < "05"
				cVar:="cObs"+SC7->C7_ITEM
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif
			
			dbSelectArea("SC7")
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			SC7->C7_EMITIDO := "S"
			SC7->C7_QTDREEM := nReem
			MsUnLock()
			_nReg := Recno()
			dbSkip()
		EndDo
		Goto(_nReg)
		
		If li>38
			nOrdem:=nOrdem+1
			ImpRodape()
			ImpCabec()
		EndIf
		
		FinalPed()
		dbSkip()
	EndDo
	_nVez := _nVez + 1
Enddo

EJECT
dbSelectArea("SC7")
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

Set device to Screen
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110AE   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C110AE()
_nVez   := 1
_nVezes := MV_PAR09
If _nVezes == 0
	_nVezes := 1
EndIf
Do While _nVez <= _nVezes
	nReem:=""
	
	limite   := 130
	li       := 80
	nTotNota := 0
	nTotGer  := 0
	nTotIpi  := 0
	nDescProd:= 0
	nTotal   := 0
	_cNumPed := Space(6)
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	Set SoftSeek On
	dbSeek( xFilial() +mv_par01 )
	Set SoftSeek Off
	
	SetRegua(RecCount())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	While C7_FILIAL = xFilial() .And. C7_NUM >= mv_par01 .And. C7_NUM <= mv_par02 .And. !Eof()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria as variaveis para armazenar os valores do pedido        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotNota := 0
		nTotal   := 0
		nTotGer  := 0
		nTotIpi  := 0
		nDescProd:= 0
		nOrdem   := 1
		nReem    := 0
		cObs01   := " "
		cObs02   := " "
		cObs03   := " "
		cObs04   := " "
		
		If C7_EMITIDO == "S" .And. mv_par05 == 1
			dbSkip()
			Loop
		Endif
		
		If (SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)
			dbSkip()
			Loop
		Endif
		
		If SC7->C7_TIPO != 2
			dbSkip()
			Loop
		EndIf
		
		ImpCabec()
		nTotNota:=nTotNota+1
		nTotNota := SC7->C7_FRETE
		nReem    := SC7->C7_QTDREEM + 1
		While C7_FILIAL = xFilial() .And. C7_NUM == _cNumPed
			
			If lEnd
				@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
				Goto Bottom
				Exit
			Endif
			
			IncRegua()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se havera salto de formulario                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If li > 56
				nOrdem:=nOrdem+1
				ImpRodape()
				ImpCabec()
			Endif
			li:=li+1
			@ li,001 PSAY "|"
			@ li,002 PSAY SC7->C7_ITEM      Picture PesqPict("SC7","C7_ITEM")
			@ li,005 PSAY "|"
			@ li,006 PSAY SC7->C7_PRODUTO   Picture PesqPict("SC7","C7_PRODUTO")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Pesquisa Descricao do Produto                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ImpProd()
			nDescProd:= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			nBaseIPI := SC7->C7_TOTAL - IIF(SC7->C7_IPIBRUT=="L",nDescProd,0)
			nTotIpi:=nTotIpi+Round(nBaseIPI*SC7->C7_IPI/100,2)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializacao da Observacao do Pedido.                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SC7->C7_ITEM < "05"
				cVar:="cObs"+SC7->C7_ITEM
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif
			
			dbSelectArea("SC7")
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			Replace  C7_EMITIDO With "S",;
			C7_QTDREEM With nReem
			MsUnLock()
			Skip
		End
		Skip-1
		If li>38
			nOrdem:=nOrdem+1
			ImpRodape()
			ImpCabec()
		End
		
		FinalAE()
		Skip
	End
	_nVez := _nVez + 1
Enddo
EJECT
dbSelectArea("SC7")
DBSetFilter()
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisar e imprimir  dados Cadastrais do Produto.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/
Static Function ImpProd()
cDesc   := ""
nLinRef := 1
nBegin  := 0
cDescri := ""
nLinha  := 0

If Empty(mv_par06)
	MV_PAR06 := "A5_CODPRF"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B1_DESC" .Or. AllTrim(mv_par06) == "A5_CODPRF"
	dbSelectArea("SA5")
	dbSetOrder(1)
	dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO)
	If Found() .And. !Empty(A5_CODPRF)
		cDescri := ALLTRIM(SA5->A5_CODPRF)
	Else
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)
		cDescri := Alltrim(SB1->B1_DESC)
	EndIf
	dbSelectArea("SC7")
EndIf

If AllTrim(mv_par06) == "B5_CEME"
	dbSelectArea("SA5")
	dbSetOrder(1)
	dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO)
	If Found() .And. !Empty(A5_CODPRF)
		cDescri := ALLTRIM(SA5->A5_CODPRF)
	Else
		dbSelectArea("SB5")
		dbSetOrder(1)
		dbSeek(xFilial("SB5")+SC7->C7_PRODUTO)
		If Found()
			cDescri := Alltrim(B5_CEME)
		EndIf
	EndIf
	dbSelectArea("SC7")
EndIf

If AllTrim(mv_par06) == "C7_DESCRI"
	dbSelectArea("SA5")
	dbSetOrder(1)
	dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO)
	If Found() .And. !Empty(A5_CODPRF)
		cDescri := ALLTRIM(SA5->A5_CODPRF)
	Else
		dbSelectArea("SC7")
		cDescri := Alltrim(SC7->C7_DESCRI)
	EndIf
EndIf
dbSelectArea("SC7")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime da descricao selecionada                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLinha:= MLCount(cDescri,30)

@ li,021 PSAY "|"
@ li,022 PSAY MemoLine(cDescri,30,1)

ImpCampos()

For nBegin := 2 To nLinha
	li:=li+1
	@ li,001 PSAY "|"
	@ li,005 PSAY "|"
	@ li,021 PSAY "|"
	@ li,022 PSAY Memoline(cDescri,30,nBegin)
	@ li,053 PSAY "|"
	@ li,056 PSAY "|"
	@ li,070 PSAY "|"
	@ li,085 PSAY "|"
	If mv_par08 == 1
		@ li,089 PSAY "|"
		@ li,106 PSAY "|"
		@ li,115 PSAY "|"
		@ li,125 PSAY "|"
		@ li,132 PSAY "|"
	Else
		@ li,102 PSAY "|"
		@ li,111 PSAY "|"
		@ li,132 PSAY "|"
	EndIf
Next nBegin

Return()

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCampos³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir dados Complementares do Produto no Pedido.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCampos(Void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/
Static Function ImpCampos()

bBloco :={|ny| iif(ny==1,"SC7->C7_UM",iif(!Empty(SC7->C7_SEGUM),"SC7->C7_SEGUM","SC7->C7_UM"))}
bBloco1:={|ny| iif(ny==1,"SC7->C7_QUANT",iif(!Empty(SC7->C7_QTSEGUM),"SC7->C7_QTSEGUM","SC7->C7_QUANT"))}
bBloco2:={|ny| iif(ny==1,"SC7->C7_PRECO",iif(!Empty(SC7->C7_QTSEGUM),"SC7->C7_TOTAL/SC7->C7_QTSEGUM","SC7->C7_PRECO"))}

@ li,053 PSAY "|"
@ li,054 PSAY &(Eval(bBloco,mv_par07))     Picture PesqPict("SC7","C7_UM")
@ li,056 PSAY "|"
dbSelectArea("SC7")
@ li,057 PSAY &(Eval(bBloco1,mv_par07))    Picture PesqPictQt("C7_QUANT",13)
@ li,070 PSAY "|"
@ li,071 PSAY &(Eval(bBloco2,mv_par07))    Picture PesqPict("SC7","C7_PRECO",14)
@ li,085 PSAY "|"

If mv_par08 == 1
	@ li,086 PSAY SC7->C7_IPI                                Picture "99"
	@ li,088 PSAY "%"
	@ li,089 PSAY "|"
	@ li,090 PSAY SC7->C7_TOTAL                              Picture PesqPict("SC7","C7_TOTAL",16)
	@ li,106 PSAY "|"
	@ li,107 PSAY SC7->C7_DATPRF                             Picture PesqPict("SC7","C7_DATPRF")
	@ li,115 PSAY "|"
	@ li,116 PSAY SC7->C7_CC                                 Picture PesqPict("SC7","C7_CC")
	@ li,125 PSAY "|"
	@ li,126 PSAY SC7->C7_NUMSC
	@ li,132 PSAY "|"
Else
	@ li,086 PSAY SC7->C7_TOTAL                              Picture PesqPict("SC7","C7_TOTAL",16)
	@ li,102 PSAY "|"
	@ li,103 PSAY SC7->C7_DATPRF                             Picture PesqPict("SC7","C7_DATPRF")
	@ li,111 PSAY "|"
	@ li,132 PSAY "|"
EndIf

nTotNota:=nTotNota+SC7->C7_TOTAL

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalPed ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares do Pedido de Compra        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalPed()

nk := 1
nTotDesc:= SC7->C7_VLDESC
cMensagem:= Formula(C7_Msg)

if !Empty(cMensagem)
	li:=li+1
	@ li,001 PSAY "|"
	@ li,002 PSAY Padc(cMensagem,129)
	@ li,132 PSAY "|"
Endif
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=li+1
While li<39
	@ li,001 PSAY "|"
	@ li,005 PSAY "|"
	@ li,021 PSAY "|"
	@ li,021 + nk PSAY "*"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,053 PSAY "|"
	@ li,056 PSAY "|"
	@ li,070 PSAY "|"
	@ li,085 PSAY "|"
	@ li,089 PSAY "|"
	@ li,106 PSAY "|"
	@ li,115 PSAY "|"
	@ li,125 PSAY "|"
	@ li,132 PSAY "|"
	li:=li+1
End
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,015 PSAY "D E S C O N T O S -->"
@ li,037 PSAY C7_DESC1 Picture "999.99"
@ li,046 PSAY C7_DESC2 Picture "999.99"
@ li,055 PSAY C7_DESC3 Picture "999.99"
If nTotDesc == 0.00
	nTotDesc:= CalcDesc(nTotNota,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
EndIf
@ li,068 PSAY nTotDesc Picture tm(nTotDesc,14)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   && forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Entrega  : " + SM0->M0_ENDENT
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDENT
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTENT
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPENT)
@ li,132 PSAY "|"
Go nRegistro
dbSelectArea( cAlias )

li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Cobranca : " + SM0->M0_ENDCOB
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDCOB
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTCOB
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPCOB)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

dbSelectArea("SE4")
dbSeek(xFilial()+SC7->C7_COND)
dbSelectArea("SC7")
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY "Condicao de Pagto "+SubStr(SE4->E4_COND,1,15)
@ li,038 PSAY "|Data de Emissao|"
@ li,056 PSAY "Total das Mercadorias : "
@ li,094 PSAY nTotNota Picture tm(nTotNota,14)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
@ li,038 PSAY "|"
@ li,043 PSAY SC7->C7_EMISSAO
@ li,054 PSAY "|"
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "|"
@ li,055 PSAY Replicate("-",77)
@ li,132 PSAY "|"
li:=li+1
dbSelectArea("SM4")
Seek xFilial()+SC7->C7_REAJUST
dbSelectArea("SC7")
@ li,001 PSAY "|"
@ li,003 PSAY "Reajuste :"
@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","c7_reajust")
@ li,018 PSAY SM4->M4_DESCR
@ li,054 PSAY "| IPI   :"
@ li,094 PSAY nTotIpi         Picture tm(nTotIpi,14)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "| Frete :"
@ li,094 PSAY SC7->C7_FRETE   Picture tm(SC7->C7_FRETE,14)
@ li,132 PSAY "|"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializar campos de Observacoes.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs := cObs01
		cObs01 := Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

li:=li+1
@ li,001 PSAY "| Observacoes"
@ li,054 PSAY "| Grupo :"
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs01
@ li,054 PSAY "|"+Replicate("-",77)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs02
@ li,054 PSAY "| Total Geral : "
If nTotDesc == 0.00
	nTotDesc:= CalcDesc(nTotNota,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
EndIf
nTotGeral:=nTotNota+nTotIpi-nTotDesc
@ li,094 PSAY nTotGeral      Picture tm(nTotGeral,14)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs03
@ li,054 PSAY "|"+Replicate("-",77)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs04
@ li,054 PSAY "|"
@ li,061 PSAY "|           Liberacao do Pedido"
@ li,102 PSAY "| Obs. do Frete: "
@ li,119 PSAY IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"+Replicate("-",59)
@ li,061 PSAY "|"
@ li,102 PSAY "|"
@ li,132 PSAY "|"

li:=li+1
cLiberador := ""
nPosicao := 0
If lLiberador
	If SubStr(SC7->C7_CODLIB,1,6) == EnCript(cMestra,0)
		cLiberador := "Administrador"
	Else
		cSenhaA  := SubStr(SC7->C7_CODLIB,1,6)
		For nx := 1 To Len(aSenhas)
			If aSenhas[nx][1] == cSenhaA
				nPosicao := nx
				Exit
			EndIf
		Next
		If nPosicao > 0
			cLiberador := EnCript(SubStr(aUsuarios[nPosicao][1],8,30),1)
		EndIf
	EndIf
EndIf

@ li,001 PSAY "|"
@ li,007 PSAY "Comprador"
@ li,021 PSAY "|"
@ li,028 PSAY "Gerencia"
@ li,041 PSAY "|"
@ li,046 PSAY "Diretoria"
@ li,061 PSAY "|     ------------------------------"
@ li,102 PSAY "|"
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,021 PSAY "|"
@ li,041 PSAY "|"
@ li,061 PSAY "|     "
@ li,102 PSAY "|"
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
/*
oPrn    := TMSPrinter():New()
cBitMap := "\IMAGEM\COEL.bmp"
oSend(oPrn, "SayBitmap", 080, 010, cBitMap , 100, 50 )
oPrn:Preview()
//oPrn:Setup() // para configurar impressora
//oPrn:Print()
*/
Return()
/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalAE  ³ Autor ³ Cristina Ogura        ³ Data ³ 05.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares da Autorizacao de Entrega  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalAE(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/
Static Function FinalAE()

nk := 1
nTotDesc:= SC7->C7_VLDESC
cMensagem:= Formula(C7_MSG)
if !empty(cMensagem)
	li:=li+1
	@ li,001 PSAY "|"
	@ li,002 PSAY Padc(cMensagem,129)
	@ li,132 PSAY "|"
Endif
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=li+1
While li<39
	@ li,001 PSAY "|"
	@ li,005 PSAY "|"
	@ li,021 PSAY "|"
	@ li,021 + nk PSAY "*"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,053 PSAY "|"
	@ li,056 PSAY "|"
	@ li,070 PSAY "|"
	@ li,085 PSAY "|"
	@ li,102 PSAY "|"
	@ li,111 PSAY "|"
	@ li,132 PSAY "|"
	li:=li+1
End
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   && forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Entrega  : " + SM0->M0_ENDENT
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDENT
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTENT
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPENT)
@ li,132 PSAY "|"
Go nRegistro
dbSelectArea( cAlias )

li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Cobranca : " + SM0->M0_ENDCOB
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDCOB
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTCOB
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPCOB)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

dbSelectArea("SE4")
dbSeek(xFilial()+SC7->C7_COND)
dbSelectArea("SC7")
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY "Condicao de Pagto "+SubStr(SE4->E4_COND,1,15)
@ li,038 PSAY "|Data de Emissao|"
@ li,056 PSAY "Total das Mercadorias : "
@ li,094 PSAY nTotNota Picture tm(nTotNota,14)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
@ li,038 PSAY "|"
@ li,043 PSAY SC7->C7_EMISSAO
@ li,054 PSAY "|"
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "|"
@ li,055 PSAY Replicate("-",77)
@ li,132 PSAY "|"
li:=li+1
dbSelectArea("SM4")
Seek xFilial()+SC7->C7_REAJUST
dbSelectArea("SC7")
@ li,001 PSAY "|"
@ li,003 PSAY "Reajuste :"
@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","c7_reajust")
@ li,018 PSAY SM4->M4_DESCR
@ li,054 PSAY "| Total Geral : "
If nTotDesc == 0.00
	nTotDesc:= CalcDesc(nTotNota,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
EndIf
nTotGeral:=nTotNota+nTotIpi-nTotDesc

@ li,094 PSAY nTotGeral      Picture tm(nTotGeral,14)
@ li,132 PSAY "|"

li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializar campos de Observacoes.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs      := cObs01
		cObs01:= Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

li:=li+1
@ li,001 PSAY "| Observacoes"
@ li,054 PSAY "| Comprador    "
@ li,070 PSAY "| Gerencia     "
@ li,085 PSAY "| Diretoria    "
@ li,132 PSAY "|"

li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs01
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"

li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs02
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"

li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs03
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"

li:=li+1
@ li,001 PSAY "|"
@ li,003 PSAY cObs04
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero da Autorizacao de Entrega."
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

Return

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o rodape do formulario e salta para a proxima folha³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRodape(Void)                                                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/
Static Function ImpRodape()

li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,070 PSAY "Continua ..."
@ li,132 PSAY "|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=0
Return

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/
Static Function ImpCabec()

Local cBitMap 	:= '\IMAGEM\COEL.BMP'
Local aArea		:= GetArea()

oPrn:Say(240,101, SM0->M0_NOMECOM, oFont14b, 100)
oPrn:Say(330,101, SM0->M0_ENDENT , ofont10 , 100)
oPrn:Say(330,750, " - "+SM0->M0_CIDENT , ofont10 , 100)
oPrn:Say(330,1000," - " + SM0->M0_ESTENT , ofont10 , 100)
oPrn:Say(370,101, "BAIRRO : "+SM0->M0_BAIRENT, ofont10 , 100)
oPrn:Say(370,750,"TEL: "+SM0->M0_TEL        , ofont10 , 100)
oPrn:Say(370,1200,"FAX: "+SM0->M0_FAX        , ofont10 , 100)
oPrn:Say(410,101,"CGC: "+ transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), ofont10 , 100)
oPrn:Say(410,750,"IE "+ transform(SM0->M0_INSC,"@R 999.999.999.999"), ofont10 , 100)
oPrn:SayBitmap(100,1701,cBitMap,600,300 )
//oPrn:Line(415,001,415,2900)

RestArea(aArea)

If mv_par08 == 1
	oPrn:Line(450,001,450,2900)
	oPrn:Say(460,900, " P E D I D O  D E  C O M P R A S" , ofont14b , 100)
	oPrn:Line(510,001,510,2900)
Else
	oPrn:Line(450,001,450,2900)
 	oPrn:Say(460,900, " A U T.   D E   E N T R E G A" , ofont14b , 100)
	oPrn:Line(510,001,510,2900)
EndIf
//@ 02,079 PSAY IIf(nOrdem>1," - continuacao"," ")
//@ 02,096 PSAY "|"


oPrn:Say(460,1600, SC7->C7_NUM         , ofont10 , 100)
oPrn:Say(460,1700, "/"+Str(nOrdem,1)   , ofont10 , 100)
oPrn:Say(460,1880, IIF(_nVezes > 1, Str(_nVez,2)+"a. VIA","VIA UNICA") , ofont10 , 100)

//oPrn:Setup() // para configurar impressora
//oPrn:Print()
//oPrn:SayBitmap(05,010,cBitMap,400,200)

dbSelectArea("SA2")
dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)

oPrn:Say(530,101,SA2->A2_NOME+"  -  "+SA2->A2_COD, ofont10 , 100)
oPrn:Say(580,101,SA2->A2_END                , ofont10 , 100)
oPrn:Say(580,750,"- "+Trim(SA2->A2_BAIRRO)  , ofont10 , 100)
oPrn:Say(580,1300,"- "+Trim(SA2->A2_MUN)    , ofont10 , 100)
oPrn:Say(580,1600,SA2->A2_EST               , ofont10 , 100)
oPrn:Say(580,1700,"CEP:"+SA2->A2_CEP        , ofont10 , 100)
oPrn:Say(630,101,"CGC: "+ transform(SA2->A2_CGC,"@R 99.999.999/9999-99"), ofont10 , 100)
oPrn:Say(630,750," I.E.: "+SA2->A2_INSCR , ofont10 , 100)
oPrn:Say(680,101,"CONTATO: "+SC7->C7_CONTATO       , ofont10 , 100)
oPrn:Say(680,750,"FONE: "+transform(SA2->A2_TEL,"@R 99-9999.9999"), ofont10 , 100)
oPrn:Say(680,1600,"FAX: "+transform(SA2->A2_FAX,"@R 99-9999.9999"), ofont10 , 100)
oPrn:Line(760,001,760,2900)

     
 If mv_par08 == 1
    oPrn:Say(810,001,"|Itm |Codigo |Descricao do Material|UM|  Quant.|Valor Unitario|IPI|  Valor Total   |Entrega |  C.C.   | S.C. |"     , ofont10 , 100)
    oPrn:Line(860,001,860,2900)
 
/*
	@ 09,001 PSAY "|"
	@ 09,002 PSAY "Itm|"
	@ 09,009 PSAY "Codigo      "
	@ 09,021 PSAY "|Descricao do Material"
	@ 09,053 PSAY "|UM|  Quant."
	@ 09,070 PSAY "|Valor Unitario|IPI|  Valor Total   |Entrega |  C.C.   | S.C. |"
	@ 10,001 PSAY "|"
	@ 10,002 PSAY Replicate("-",limite)
	@ 10,132 PSAY "|"
*/
	dbSelectArea("SC7")
	_cNumPed := SC7->C7_NUM
	li:=10
Else
    oPrn:Say(810,001,"|Itm |Codigo |Descricao do Material|UM|  Quant.|Valor Unitario|  Valor Total   |Entrega | Numero da OP  "     , ofont10 , 100)
    oPrn:Line(860,001,860,2900)

/*
	@ 09,001 PSAY "|"
	@ 09,002 PSAY "Itm|"
	@ 09,009 PSAY "Codigo      "
	@ 09,021 PSAY "|Descricao do Material"
	@ 09,053 PSAY "|UM|  Quant."
	@ 09,070 PSAY "|Valor Unitario|  Valor Total   |Entrega | Numero da OP  "
	@ 09,132 PSAY "|"
	@ 10,001 PSAY "|"
	@ 10,002 PSAY Replicate("-",limite)
	@ 10,132 PSAY "|"
*/
	dbSelectArea("SC7")
	_cNumPed := SC7->C7_NUM
	li:=10
EndIf
oPrn:Preview()
Return

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R110Center³ Autor ³ Jose Lucas            ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Centralizar o Nome do Liberador do Pedido.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC1 := R110CenteR(ExpC2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Nome do Liberador                                 ³±±
±±³Parametros³ ExpC2 := Nome do Liberador Centralizado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/
//*******************************************************************
//Esta fun‡ao nao esta sendo utilizada neste programa
//*******************************************************************

Static Function R110Center()
Return( Space((30-Len(AllTrim(cLiberador)))/2)+AllTrim(cLiberador) )
