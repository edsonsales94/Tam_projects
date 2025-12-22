#include "rwmake.ch" 

User Function rfatr2R() 

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("APEDCLI,CSTRING,CFILTER,CPEDIDO,CHEADER,NPED")
SetPrvt("CMOEDA,CCAMPO,CCOMIS,I,NIPI,NVIPI")
SetPrvt("NBASEIPI,NVALBASE,LIPIBRUTO,NPERRET,CESTADO,TNORTE")
SetPrvt("CESTCLI,CINSCRCLI,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR730  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR730(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ OBS      ³ Prog.Transf. em RDMAKE por Fabricio C.David em 07/06/97    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel            := ""
tamanho          := "M"
nTipo            := 15
titulo           := "Emissao da Confirmacao do Pedido"
cDesc1           := "Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
cDesc2           := "intervalo informado na op‡„o Parƒmetros."
cDesc3           := " "
nRegistro        := 0
cKey             := ""
nIndex           := ""
cIndex           := ""//  && Variaveis para a criacao de Indices Temp.
cCondicao        := ""
lEnd             := .T.
cPerg            := "MTR730R"
aReturn          := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 0 }
nomeprog         := "RFATR02R"
nLastKey         := 0
nBegin           := 0
aLinha           := { }
li               := 80
limite           := 132
lRodape          := .F.
cPictQtd         := ""
nTotQtd          := nTotVal:=0
aPedCli          := {}
wnrel            := "RFATR02R"
cString          := "SC6"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR730R",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Do Pedido                             ³
//³ mv_par02              Ate o Pedido                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,'',.T.)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
Endif

RptStatus({||C730Imp()})
Return
Static Function C730IMP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//tamanho        :="P"
titulo         :="EMISSAO DA CONFIRMACAO DO PEDIDO REPRESENTANTE"
cDesc1         :="Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
cDesc2         :="intervalo informado na op‡„o Parƒmetros."
cDesc3         :=" "
nRegistro      := 0
cKey           :=""
nIndex         :=""
cIndex         :=""//  && Variaveis para a criacao de Indices Temp.
cCondicao      :=""

nTipo := IIF( aReturn[4]==1,15,18)

dbSelectArea("SC5")
dbSetorder(1)

SetRegua(RecCount())            // Total de Elementos da regua

dbSeek( xFilial("SC5") + mv_par01, .T. )

While SC5->C5_FILIAL + SC5->C5_NUM <= xFilial("SC5") + mv_par02 .AND. ! Eof()
	
	nTotQtd:=0
	nTotVal:=0        
	
       if !SC5->C5_CODUSR == __CUSERID
          dbskip()
          loop
       endif
  

	cPedido := SC5->C5_NUM
	
//	_cObsPed1 := SC5->C5_X_OPED1		// Observacao Pedido 1
//	_cObsPed2 := SC5->C5_X_OPED2		// Observacao Pedido 2
//	_cObsPed3 := SC5->C5_X_OPED3		// Observacao Pedido 3		
	
	dbSelectArea("SA4")
	dbSeek( xFilial() + SC5->C5_TRANSP )
	
	dbSelectArea("SA3")
	dbSeek( xFilial() + SC5->C5_VEND1 ) 
	
	dbSelectArea("SE4")
	dbSeek( xFilial() + SC5->C5_CONDPAG )
	
	dbSelectArea("SC6")
	dbSeek( xFilial("SC6") + cPedido )
	
	cPictQtd := PESQPICTQT("C6_QTDVEN",10)
	
	nRegistro:= RECNO()
	
	IF LastKey() == 286
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta tabela de pedidos do cliente p/ o cabe‡alho            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aPedCli:= {}
	
	While SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6") + cPedido .AND. ! Eof() 
	
		IF !Empty(SC6->C6_PEDCLI) .and. Ascan(aPedCli,SC6->C6_PEDCLI) == 0
			AAdd(aPedCli,SC6->C6_PEDCLI)
		ENDIF
		
		dbSkip()
		
	Enddo
	
	aSort(aPedCli)
	
	dbGoTo( nRegistro )
	
    While !Eof() .And. C6_NUM == SC5->C5_NUM   // por pedido
    
    	IF LastKey()==27
			@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif
		
	    If li > 48
	        If lRodape
		         ImpRodape()
		         lRodape := .F.
	        Endif
	        li := 0
	        ImpCabec()
	    Endif

		ImpItem()
		
		dbSkip()
		
		li:=li+1
		
	Enddo
	
	IF lRodape
		ImpRodape()
		lRodape:=.F.
	Endif

//	dbSelectArea("SC5")  //nao usado 
//	reclock("SC5",.F.)  //incluso fernando projetos representantes
//	   replace SC5->C5_X_IMP with "S"
//	Msunlock()
    dbSelectArea("SC5")
	dbSkip()
	
	IncRegua()
	
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SC5")
//DBSetFilter()

Ferase(cIndex+OrdBagExt())

dbSelectArea("SC6")
//DBSetFilter()
dbSetOrder(1)
dbGotop()

EJECT

SetPrc(0,0)

Set device to screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpCabec(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 01/03/01 ==> Function ImpCabec
Static Function ImpCabec()

lRodape     := .T.
cHeader     :=""
nPed        :=""
cMoeda      :=""
cCampo      :=""
cComis      :=""
cHeader     := "It Codigo          Desc. do Material    TES UM    Quant.  Valor Unit. IPI ICM     Vl.Tot.C/IPI Entrega         Lote"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registro no cliente do pedido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF !(SC5->C5_TIPO$"DB")
	dbSelectArea("SA1")
	dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
Else
	dbSelectArea("SA2")
	dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
Endif

//@ 01,000 PSAY Chr(15)                     // Comprimido.

//SetPrc(0,0)

@ 00,000 PSAY AvalImp(132)

@ 01,000 PSAY Replicate("-",limite)
@ 02,000 PSAY SM0->M0_NOME
IF !(SC5->C5_TIPO$"DB")
	@ 02,041 PSAY "| "+SA1->A1_COD+"/"+SA1->A1_LOJA+" "+SA1->A1_NOME
    @ 02,100 PSAY "| CONFIRMACAO DO PEDIDO " 
    @ 03,000 PSAY SM0->M0_ENDCOB
	@ 03,041 PSAY "| "+IF( !Empty(SA1->A1_ENDENT) .And. SA1->A1_ENDENT #SA1->A1_END,;
		SA1->A1_ENDENT, SA1->A1_END )
	@ 03,100 PSAY "|"
	@ 04,000 PSAY "TEL: "+SM0->M0_TEL
	@ 04,041 PSAY "| "+SA1->A1_CEP
	@ 04,053 PSAY SA1->A1_MUN
	@ 04,077 PSAY SA1->A1_EST
	@ 04,100 PSAY "| EMISSAO: "
	@ 04,111 PSAY SC5->C5_EMISSAO
	@ 05,000 PSAY "CGC: "
	@ 05,005 PSAY SM0->M0_CGC    Picture "@R 99.999.999/9999-99"
	@ 05,025 PSAY Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 PSAY "|"
	@ 05,043 PSAY SA1->A1_CGC    Picture "@R 99.999.999/9999-99"
	@ 05,062 PSAY "IE: "+SA1->A1_INSCR
	@ 05,100 PSAY "| PEDIDO N. "+SC5->C5_NUM
Else
	@ 02,041 PSAY "| "+SA2->A2_COD+"/"+SA2->A2_LOJA+" "+SA2->A2_NOME
	@ 02,100 PSAY "| CONFIRMACAO DO PEDIDO "
	@ 03,000 PSAY SM0->M0_ENDCOB
	@ 03,041 PSAY "| "+ SA2->A2_END
	@ 03,100 PSAY "|"
	@ 04,000 PSAY "TEL: "+SM0->M0_TEL
	@ 04,041 PSAY "| "+SA2->A2_CEP
	@ 04,053 PSAY SA2->A2_MUN
	@ 04,077 PSAY SA2->A2_EST
	@ 04,100 PSAY "| EMISSAO: "
	@ 04,111 PSAY SC5->C5_EMISSAO
	@ 05,000 PSAY "CGC: "
	@ 05,005 PSAY SM0->M0_CGC    Picture "@R 99.999.999/9999-99"
	@ 05,025 PSAY Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 PSAY "|"
	@ 05,043 PSAY SA2->A2_CGC    Picture "@R 99.999.999/9999-99"
	@ 05,062 PSAY "IE: "+SA2->A2_INSCR
	@ 05,100 PSAY "| PEDIDO N. "+SC5->C5_NUM
Endif
li:= 6
For nPed := 1 To Len(aPedCli)
	@ li,041 PSAY "|"
	@ li,100 PSAY "| S/PEDIDO  "+aPedCli[nPed]
	li:=Li+1
Next

@ li,000 PSAY Replicate("-",limite)
li:=li+1
@ li,000 PSAY "TRANSP...: "+SC5->C5_TRANSP+" - "+SA4->A4_NOME+" MUN: "+SA4->A4_MUN+" Bairro: "+SA4->A4_BAIRRO
li:=li+1

For i := 1 to 5
	
	cCampo := "SC5->C5_VEND" + Str(i,1,0)
	cComis := "SC5->C5_COMIS" + Str(i,1,0)
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek(cCampo)
	If !Eof()
		Loop
	Endif
	
	If !Empty(&cCampo)
		dbSelectArea("SA3")
		dbSeek(xFilial()+&cCampo)
		If i == 1
			@ li,000 PSAY "VENDEDOR.: "
		EndIf
		@ li,013 PSAY &cCampo + " - "+SA3->A3_NOME
		If i == 1
			@ li,065 PSAY "COMISSAO: "
		EndIf
		@ li,075 PSAY &cComis Picture "99.99"
		li:=li+1
	Endif
Next

li:=li+1

@ li,000 PSAY "COND.PGTO: "+SC5->C5_CONDPAG+" - "+SE4->E4_DESCRI

if se4->e4_tipo == "9"
    li:=li+1
    if dtoc(sc5->c5_data1) <> " "
       @li,000 PSAY "VENC1.:"+dtoc(sc5->c5_data1)
       @li,020 PSAY "VLR.:"+str(sc5->c5_parc1,12,2)
       if dtoc(sc5->c5_data2)  <> " "
	 @li,040 PSAY "VENC2.:" +dtoc(sc5->c5_data2)
	 @li,060 PSAY "VLR.:" +str(sc5->c5_parc2,12,2)
	 if dtoc(sc5->c5_data3) <> " "
	   li:=li+1
	   @li,000 PSAY "VENC3.:" +dtoc(sc5->c5_data3)
	   @li,020 PSAY "VLR.:" +str(sc5->c5_parc3,12,2)
	   if dtoc(sc5->c5_data4)  <> " "
	      @li,040 PSAY "VENC4.:" +dtoc(sc5->c5_data4)
	      @li,060 PSAY "VLR.:" +str(sc5->c5_parc4,12,2)
	   endif
	 endif
       endif
    endif
    li:=li+1

endif  
If SC5->C5_TPFRETE == "C"
   _cFrete:="CIF"
ElseIF SC5->C5_TPFRETE == "F"
   _cFrete:="FOB"
Else
   _cFrete:="   "
EndIf
   
li:=li+1
@ li,065 PSAY "FRETE...: "
@ li,075 PSAY _cFrete//  Picture "@EZ 999,999,999.99"
@ li,090 PSAY "SEGURO: "
@ li,098 PSAY SC5->C5_SEGURO Picture "@EZ 999,999,999.99"
li:=li+1
@ li,000 PSAY "TABELA...: "+SC5->C5_TABELA
@ li,065 PSAY "VOLUMES.: "
@ li,075 PSAY SC5->C5_VOLUME1    Picture "@EZ 999,999"
@ li,090 PSAY "ESPECIE: "+SC5->C5_ESPECI1
li:=li+1
cMoeda:=Strzero(SC5->C5_MOEDA,1,0)
@ li,000 PSAY "REAJUSTE.: "+SC5->C5_REAJUST+"   Moeda : " +IIF(cMoeda < "2","1",cMoeda)
@ li,065 PSAY "BANCO: " + SC5->C5_BANCO
@ li,090 PSAY "ACRES.FIN.: "+Str(SC5->C5_ACRSFIN,6,2)
li:=li+1
@ li,000 PSAY Replicate("-",limite)
li:=li+1
@ li,000 PSAY cHeader
li:=li+1
@ li,000 PSAY Replicate("-",limite)
li:=li+1
// Substituido pelo assistente de conversao do AP5 IDE em 01/03/01 ==> __Return( .T. )
Return( .T. )        // incluido pelo assistente de conversao do AP5 IDE em 01/03/01

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpItem  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpItem(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 01/03/01 ==> Function ImpItem
Static Function ImpItem()

nIPI     :=0
nVipi    :=0
nBaseIPI :=100
nValBase := 0
lIpiBruto:=IIF(GETMV("MV_IPIBRUT")=="S",.T.,.F.)

dbSelectArea("SB1")
dbSeek(xFilial()+SC6->C6_PRODUTO)

dbSelectArea("SF4")
dbSeek(xFilial()+SC6->C6_TES)

IF SF4->F4_IPI == "S"
	nBaseIPI        := IIF(SF4->F4_BASEIPI > 0,SF4->F4_BASEIPI,100)
	nIPI            := SB1->B1_IPI
	nValBase        := If(lIPIBruto .And. SC6->C6_PRUNIT > 0,SC6->C6_PRUNIT,SC6->C6_PRCVEN)*SC6->C6_QTDVEN
	nVipi           := nValBase * (nIPI/100)*(nBaseIPI/100)
Endif

@li,000 PSAY Substr(SC6->C6_ITEM,1,2)
@li,003 PSAY Substr(SC6->C6_PRODUTO,1,5)
@li,009 PSAY SUBS(IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI),1,30)
@li,040 PSAY SC6->C6_TES
@li,044 PSAY Substr(SC6->C6_UM,1,2)
@li,047 PSAY SC6->C6_QTDVEN     Picture "@E 999999.99"     // PesqPict("SC6","C6_QTDVEN",12)
@li,057 PSAY SC6->C6_PRCVEN     Picture "@E 9,999,999.99"  // PesqPict("SC6","C6_PRCVEN",12)
@li,071 PSAY nIPI                               Picture "99"

a730VerIcm()

@li,075 PSAY nPerRet Picture "99"
@li,080 PSAY NoRound(SC6->C6_VALOR+nVIPI) Picture PesqPict("SC6","C6_VALOR",14)
@li,095 PSAY SC6->C6_ENTREG 
@li,112 PSAY SC6->C6_LOTECTL
//@li,112 PSAY SC6->C6_QTDEMP + SC6->C6_QTDLIB + SC6->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)
//@li,122 PSAY SC6->C6_QTDVEN - SC6->C6_QTDEMP + SC6->C6_QTDLIB - SC6->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)

nTotQtd := nTotQtd+SC6->C6_QTDVEN
nTotVal := nTotVal+NoRound(SC6->C6_VALOR+nVipi)

dbSelectArea("SC6")

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 01/03/01

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpRoadpe(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 01/03/01 ==> Function ImpRodape
Static Function ImpRodape()

li:=li+1
@ li,000 PSAY Replicate("-",limite)
li:=li+1
@ li,000 PSAY " T O T A I S "
@ li,047 PSAY nTotQtd    Picture cPictQtd
@ li,077 PSAY nTotVal    Picture PesqPict("SC6","C6_VALOR",17)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao das Observacoes do Pedido                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
If !Empty(_cObsPed1) .OR. !Empty(_cObsPed2) .OR. !Empty(_cObsPed3)
	li := li + 10
	@ li,000 PSAY "Observacao do Pedido"
	li := li + 1
	@ li,000 PSAY Replicate("-",limite)
	li := li + 1
	If !Empty(_cObsPed1)
		li := li + 1
		@ li,000 PSAY _cObsPed1
	Endif
	If !Empty(_cObsPed2)
		li := li + 1
		@ li,000 PSAY _cObsPed2
	Endif		
	If !Empty(_cObsPed3)
		li := li + 1
		@ li,000 PSAY _cObsPed3
	Endif
	li := li + 2
	@ li,000 PSAY Replicate("-",limite)
Endif		
*/
@ 51,005 PSAY "PESO BRUTO ------->"
@ 52,005 PSAY "PESO LIQUIDO ----->"
@ 53,005 PSAY "VOLUMES ---------->"
@ 54,005 PSAY "SEPARADO POR ----->"
@ 55,005 PSAY "ETQ.COLADA POR --->"
@ 56,005 PSAY "D A T A ------- -->"

@ 58,000 PSAY "DESCONTOS: "
@ 58,011 PSAY SC5->C5_DESC1 Picture "99.99"
@ 58,019 PSAY SC5->C5_DESC2 picture "99.99"
@ 58,027 PSAY SC5->C5_DESC3 picture "99.99"
@ 58,035 PSAY SC5->C5_DESC4 picture "99.99"

//@ 60,000 PSAY "OBSERVACAO PARA NOTA FISCAL: "+AllTrim(SC5->C5_MENS)
//@ 60,000 PSAY "MENSAGEM PARA NOTA FISCAL: "+AllTrim(SC5->C5_MENNOTA)
@ 61,000 PSAY "MENSAGEM PARA NOTA FISCAL: "+AllTrim(SC5->C5_MENNOTA)
//@ 60,000 PSAY "MENSAGEM PARA NOTA FISCAL: "+AllTrim(SC5->C5_MENNOTA)
@ 62,000 PSAY ""
//@ 61,000 PSAY ""
@ 64,000 PSAY chr(18)        // Descompressao de Impressao.
//@ 64,000 PSAY chr(18)        // Descompressao de Impressao.

li := 65

// Substituido pelo assistente de conversao do AP5 IDE em 01/03/01 ==> __Return( NIL )
Return( NIL )        // incluido pelo assistente de conversao do AP5 IDE em 01/03/01

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A730verIcm³ Autor ³ Claudinei M. Benzi    ³ Data ³ 11.02.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para verificar qual e o ICM do Estado               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 01/03/01 ==> Function A730VerIcm
Static Function A730VerIcm()

nPerRet:=0                // Percentual de retorno
cEstado:=GetMV("mv_estado")
tNorte:=GetMV("MV_NORTE")
cEstCli:=IIF(SC5->C5_TIPO$"DB",SA2->A2_EST,SA1->A1_EST)
cInscrCli:=IIF(SC5->C5_TIPO$"DB",SA2->A2_INSCR,SA1->A1_INSCR)

If SF4->F4_ICM == "S"
	IF !(SC5->C5_TIPO $ "D")
		If SC5->C5_TIPOCLI == "F" .and. Empty(cInscrCli)
			nPerRet := iif(SB1->B1_PICM>0,SB1->B1_PICM,GetMV("MV_ICMPAD"))
		Elseif SB1->B1_PICM > 0 .And. cEstCli == cEstado
			nPerRet := SB1->B1_PICM
		Elseif cEstCli == cEstado
			nPerRet := GetMV("MV_ICMPAD")
		Elseif cEstCli $ tNorte .And. At(cEstado,tNorte) == 0
			nPerRet := 7
		Elseif SC5->C5_TIPOCLI == "X"
			nPerRet := 13
		Else
			nPerRet := 12
		Endif
	Else
		If cEstCLI == GetMV("MV_ESTADO")
			nPerRet := GetMV("MV_ICMPAD")
		Elseif !(cEstCli $ GetMV("MV_NORTE")) .And. ;
				GetMv("mv_estado") $ GetMV("MV_NORTE")
			nPerRet := 7
		Else
			nPerRet := 12
		Endif
		If SB1->B1_PICM != 0 .And. (cEstCli==GetMv("MV_ESTADO"))
			nPerRet := SB1->B1_PICM
		Endif
	Endif
Endif

// Substituido pelo assistente de conversao do AP5 IDE em 01/03/01 ==> __Return(nPerRet)
Return(nPerRet)        // incluido pelo assistente de conversao do AP5 IDE em 01/03/01

