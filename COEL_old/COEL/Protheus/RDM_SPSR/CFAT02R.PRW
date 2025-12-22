#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Cfat02r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("APEDCLI,CSTRING,CFILTER,CPEDIDO,_COBSERV,CHEADER")
SetPrvt("NPED,CMOEDA,CCAMPO,CCOMIS,I,NIPI")
SetPrvt("NVIPI,NBASEIPI,NVALBASE,LIPIBRUTO,NPERRET,CESTADO")
SetPrvt("TNORTE,CESTCLI,CINSCRCLI,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==>     #DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFAT02R  ³ Autor ³ RICARDO CORREA SOUZA  ³ Data ³ 14.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EMISSAO DA PRE-NOTA                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR730()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO COEL CONTROLES ELETRICOS LTDA                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ OBS      ³ ESTA ROTINA SUBSTITUI O MATR730 PADRAO SIGA                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel            :=""
tamanho          :="P"
titulo           :="Emissao da Confirmacao do Pedido"
cDesc1           :="Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
cDesc2           :="intervalo informado na op‡„o Parƒmetros."
cDesc3           :=" "
nRegistro        := 0
cKey             :=""
nIndex           :=""
cIndex           :=""//  && Variaveis para a criacao de Indices Temp.
cCondicao        :=""
lEnd             := .T.
cPerg            :="MTR730"
aReturn          := { "Zebrado", 1,"Administracao", 1, 2, 2, "",1 }
nomeprog         :="MATR730"
nLastKey         := 0
nBegin           :=0
aLinha           :={ }
li               :=80
limite           :=132
lRodape          :=.F.
cPictQtd         :=""
nTotQtd          :=nTotVal:=0
aPedCli          := {}
wnrel            := "MATR730"
cString          := "SC6"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR730",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01              Do Pedido                             ³
//³ mv_par02              Ate o Pedido                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
Endif

#IFDEF WINDOWS
    RptStatus({||C730Imp()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>     RptStatus({||Execute(C730Imp)})
    Return
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>     Function C730IMP
Static Function C730IMP()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho        :="P"
titulo         :="EMISSAO DA CONFIRMACAO DO PEDIDO"
cDesc1         :="Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
cDesc2         :="intervalo informado na op‡„o Parƒmetros."
cDesc3         :=" "
nRegistro      := 0
cKey           :=""
nIndex         :=""
cIndex         :=""//  && Variaveis para a criacao de Indices Temp.
cCondicao      :=""

pergunte("MTR730",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndex  := CriaTrab(nil,.f.)
dbSelectArea("SC5")
cKey    := IndexKey()
cFilter := dbFilter()
cFilter := cFilter := If( Empty( cFilter ),""," .And. " )

#IFDEF AS400
    cFilter := cFilter:= 'C5_FILIAL == "'+xFilial("SC5")+'" .And. C5_NUM >= "'+mv_par01+'"'
#ELSE
    cFilter := cFilter:= "C5_FILIAL==xFilial('SC5') .And. C5_NUM >= mv_par01"
#ENDIF

IndRegua("SC5",cIndex,cKey,,cFilter,"Selecionando Registros...")

//nIndex := RetIndex("SC5")
//DbSelectArea("SC5")
#IFNDEF AS400
//    DbSetIndex(cIndex+ordbagext())
#ENDIF
//DbSetOrder(nIndex+1)
DbGoTop()

SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. C5_NUM <= mv_par02
	
	nTotQtd:=0
	nTotVal:=0

	cPedido := C5_NUM
    //_cObserv:= c5_teste
	dbSelectArea("SA4")
	dbSeek(xFilial()+SC5->C5_TRANSP)
	dbSelectArea("SA3")
	dbSeek(xFilial()+SC5->C5_VEND1)
	dbSelectArea("SE4")
	dbSeek(xFilial()+SC5->C5_CONDPAG)
	
	dbSelectArea("SC6")
	dbSeek(xFilial()+cPedido)
	cPictQtd := PESQPICTQT("C6_QTDVEN",10)
	nRegistro:= RECNO()
	#IFNDEF WINDOWS
	If LastKey() == 286    //ALT_A
		lEnd := .t.
		exit
	End
	#ENDIF
	
	IF LastKey() == 286
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta tabela de pedidos do cliente p/ o cabe‡alho            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aPedCli:= {}
	While !Eof() .And. C6_NUM == SC5->C5_NUM
		IF !Empty(SC6->C6_PEDCLI) .and. Ascan(aPedCli,SC6->C6_PEDCLI) == 0
			AAdd(aPedCli,SC6->C6_PEDCLI)
		ENDIF
		dbSkip()
	Enddo
	aSort(aPedCli)
	
	dbGoTo( nRegistro )
	While !Eof() .And. C6_NUM == SC5->C5_NUM
		#IFNDEF WINDOWS
		If LastKey() == 286    //ALT_A
			lEnd := .t.
		End
		#ENDIF
		
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

	dbSelectArea("SC5")
	dbSkip()
	
	IncRegua()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SC5")
set filter to
//DBSetFilter()

Ferase(cIndex+OrdBagExt())

dbSelectArea("SC6")
set filter to
//DBSetFilter()
dbSetOrder(1)
dbGotop()
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
±±³Fun‡…o    ³ IMPCABEC ³ Autor ³ RICARDO CORREA SOUZA  ³ Data ³ 14.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EMISSAO DA PRE-NOTA                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ IMPCABEC()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CLMAT730                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImpCabec
Static Function ImpCabec()

lRodape     := .T.
cHeader     :=""
nPed        :=""
cMoeda      :=""
cCampo      :=""
cComis      :=""
cHeader     := "It Codigo          Desc. do Material    TES UM    Quant.  Valor Unit. IPI ICM ISS Vl.Tot.C/IPI Entrega  Desc Loc. Qtd.Fat.     Saldo"

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
@ 00,000 PSAY AvalImp(limite)
@ 01,000 PSAY Replicate("-",limite)
@ 02,000 PSAY SM0->M0_NOME
IF !(SC5->C5_TIPO$"DB")
	@ 02,041 PSAY "| "+SA1->A1_COD+"/"+SA1->A1_LOJA+" "+SA1->A1_NOME
    @ 02,100 PSAY "| CONFIRMACAO DO PEDIDO " 
	@ 03,000 PSAY SM0->M0_ENDCOB
    @ 03,041 PSAY "| "+SA1->A1_END 
    @ 03,100 PSAY "| EMISSAO: "
    @ 03,111 PSAY SC5->C5_EMISSAO
    @ 04,000 PSAY "TEL: "+SM0->M0_TEL
	@ 04,041 PSAY "| "+SA1->A1_CEP
	@ 04,053 PSAY SA1->A1_MUN
	@ 04,077 PSAY SA1->A1_EST
    @ 04,100 PSAY "| PEDIDO N. "+SC5->C5_NUM
	@ 05,000 PSAY "CGC: "
	@ 05,005 PSAY SM0->M0_CGC    Picture "@R 99.999.999/9999-99"
	@ 05,025 PSAY Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 PSAY "|"
	@ 05,043 PSAY SA1->A1_CGC    Picture "@R 99.999.999/9999-99"
	@ 05,062 PSAY "IE: "+SA1->A1_INSCR
    @ 05,100 PSAY "| S/PEDIDO  "+SC5->C5_CLPEDCL            
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
/*For nPed := 1 To Len(aPedCli)
    @ li,041 PSAY "|"
    @ li,100 PSAY "| S/PEDIDO  "+aPedCli[nPed]
	li:=Li+1
Next
*/
@ li,000 PSAY Replicate("-",limite)
li:=li+1
@ li,000 PSAY "TRANSP...: "+SC5->C5_TRANSP+" - "+SA4->A4_NOME
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
If SC5->C5_CLPARC =="S"
    @ li,065 PSAY "ENTREGA PARCIAL: "+SC5->C5_CLPARC+"-(Sim)"
Else
    @ li,065 PSAY "ENTREGA PARCIAL: "+SC5->C5_CLPARC+"-(Nao)"
EndIf
If SC5->C5_CLANTE== "S"
    @ li,090 PSAY "ENTREGA ANTECIP.: "+SC5->C5_CLANTE+"-(Sim)"
    li:=li+1
Else
    @ li,090 PSAY "ENTREGA ANTECIP.: "+SC5->C5_CLANTE+"-(Nao)"
    li:=li+1
EndIf
@ li,000 PSAY "ATENDENTE: "+SC5->C5_CLATEND
If SC5->C5_TIPO == "N"
    @ li,065 PSAY "TIPO DO PEDIDO: "+SC5->C5_TIPO+"-(Normal)"
    li:=li+1
ElseIf SC5->C5_TIPO == "D"
    @ li,065 PSAY "TIPO DO PEDIDO: "+SC5->C5_TIPO+"-(Devolucao Compra)"
    li:=li+1
ElseIf SC5->C5_TIPO == "B"
    @ li,065 PSAY "TIPO DO PEDIDO: "+SC5->C5_TIPO+"-(Beneficiamento a Fornecedores)"
    li:=li+1
Else
    @ li,065 PSAY "TIPO DO PEDIDO: "+SC5->C5_TIPO+"-(Complementares - ICMS/IPI/PRECOS)"
    li:=li+1
EndIf
@ li,000 PSAY "COND.PGTO: "+SC5->C5_CONDPAG+" - "+SE4->E4_DESCRI
@ li,065 PSAY "FRETE...: "
@ li,075 PSAY SC5->C5_FRETE  Picture "@EZ 999,999,999.99"
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
@ li,065 PSAY "ACRES.FIN.: "+Str(SC5->C5_ACRSFIN,6,2)
li:=li+1
@ li,000 PSAY "BANCO: " + SC5->C5_BANCO +"-"+SA6->A6_NOME 
li:=li+1
@ li,000 PSAY Replicate("-",limite)
li:=li+1
@ li,000 PSAY cHeader
li:=li+1
@ li,000 PSAY Replicate("-",limite)
li:=li+1
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return( .T. )
Return( .T. )        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPITEM  ³ Autor ³ RICARDO CORREA SOUZA  ³ Data ³ 14.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EMISSAO DA PRE-NOTA                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ IMPITEM()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CLMAT730                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImpItem
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
	nIPI 		:= SB1->B1_IPI
	nValBase	:= If(lIPIBruto .And. SC6->C6_PRUNIT > 0,SC6->C6_PRUNIT,SC6->C6_PRCVEN)*SC6->C6_QTDVEN
	nVipi		:= nValBase * (nIPI/100)*(nBaseIPI/100)
Endif

@li,000 PSAY SC6->C6_ITEM
@li,003 PSAY SC6->C6_PRODUTO
@li,019 PSAY SUBS(IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI),1,20)
@li,040 PSAY SC6->C6_TES
@li,044 PSAY SC6->C6_UM
@li,047 PSAY SC6->C6_QTDVEN     Picture cPictQtd
@li,057 PSAY SC6->C6_PRCVEN  Picture PesqPict("SC6","C6_PRCVEN",12)
@li,071 PSAY nIPI                               Picture "99"

a730VerIcm()
@li,074 PSAY nPerRet Picture "99"
@li,077 PSAY SB1->B1_ALIQISS    Picture "99"
@li,080 PSAY NoRound(SC6->C6_VALOR+nVIPI) Picture PesqPict("SC6","C6_VALOR",14)
@li,095 PSAY SC6->C6_ENTREG
@li,104 PSAY SC6->C6_DESCONT    Picture "99.9"
@li,109 PSAY SC6->C6_LOCAL
@li,112 PSAY SC6->C6_QTDEMP + SC6->C6_QTDLIB + SC6->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)
@li,122 PSAY SC6->C6_QTDVEN - SC6->C6_QTDEMP + SC6->C6_QTDLIB - SC6->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)

nTotQtd := nTotQtd+ SC6->C6_QTDVEN
nTotVal := nTotVal+ NoRound(SC6->C6_VALOR+nVipi)

dbSelectArea("SC6")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPRODAPE³ Autor ³ RICARDO CORREA SOUZA  ³ Data ³ 14.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EMISSAO DA PRE-NOTA                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ IMPRODAPE()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CLMAT730                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImpRodape
Static Function ImpRodape()
li:=li+1
@ li,000 PSAY Replicate("-",limite)
li:=li+1
@ li,000 PSAY " T O T A I S "
@ li,047 PSAY nTotQtd    Picture cPictQtd
@ li,077 PSAY nTotVal    Picture PesqPict("SC6","C6_VALOR",17) 

@ 48,005 PSAY "PESO BRUTO ------>"
@ 49,005 PSAY "PESO LIQUIDO ---->"
@ 50,005 PSAY "VOLUMES --------->"
@ 51,005 PSAY "SEPARADO POR ---->"
@ 52,005 PSAY "CONFERIDO POR --->"
@ 53,005 PSAY "D A T A --------->"

@ 55,000 PSAY "DESCONTOS: "
@ 55,011 PSAY SC5->C5_DESC1 Picture "99.99"
@ 55,019 PSAY SC5->C5_DESC2 picture "99.99"
@ 55,027 PSAY SC5->C5_DESC3 picture "99.99"
@ 55,035 PSAY SC5->C5_DESC4 picture "99.99"

@ 57,000 PSAY "MENSAGEM PARA NOTA FISCAL: "+AllTrim(SC5->C5_MENNOTA)
@ 58,000 PSAY "MENSAGEM DO PEDIDO: "+AllTrim(SC5->C5_CLMSPED)

li := 80

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return( NIL )
Return( NIL )        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A730VERICM³ Autor ³ RICARDO CORREA SOUZA  ³ Data ³ 14.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ROTINA PARA VERIFICAR QUAL E O ICM DO ESTADO               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function A730VerIcm
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
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return(nPerRet)
Return(nPerRet)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

