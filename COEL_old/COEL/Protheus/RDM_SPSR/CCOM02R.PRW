#include "rwmake.ch"       

User Function Ccom02r() 

SetPrvt("CBTXT,WNREL,CDESC1,CDESC2,CDESC3,AORD")
SetPrvt("TITULO,CPERG,CSTRING,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("ALINHA,LIMITE,CABEC1,CABEC2,TAMANHO,IMPRIME")
SetPrvt("NQUEBRA,CCABQUEBRA,CQUEBRANT,CCONDBUS,NQUANT_A_REC,CBCONT")
SetPrvt("LI,M_PAG,LEND,NT_QTD_PED,NT_VL_IPI,NT_VL_TOTAL")
SetPrvt("NT_QTD_ENTR,NT_SD_RECEB,NT_DESC,_NPERC,NPEDIDA,NVALIPI")
SetPrvt("NTOTAL,NIMPORT,NTOTIMP,NQUANT,NSALDO,NFLAG")
SetPrvt("NITEMIPI,NSALIPI,NFRETE,NDESC,_DMES,NTOTMES")
SetPrvt("NORDEM,CTEXQUEBRA,AESTRU1,_CTEMP1,_DFLUX1,_DFLUX")
SetPrvt("_NPARC,_NDIA1,_NDIA2,_NDIA3,_NDIA4,_NDIA5")
SetPrvt("NSALDO1,NT_REAL,NDESTOT,_CCHAVE,_CINDTRB,_NCONVERTE")
SetPrvt("_NPRECO,DFLUXO1,_CPEDIDO,_CUSO,CTOTAL,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CCOM02R  ³ Autor ³Ricardo Correa de Souza³ Data ³02.03.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao da Relacao de Pedidos de Compras em Aberto para     ³±±
±±³          ³ a Verificacao de Desembolso de Caixa (FLUXO)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Coel Controles Eletricos Ltda                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

*----------------------------------------------------------------------------*
* Definicao de Variaveis                                                     *
*----------------------------------------------------------------------------*

CbTxt   :=""
wnrel   :=""
cDesc1  :="Emissao da Relacao de  Pedidos de Compras."
cDesc2  :="Sera solicitado em qual Ordem, qual o Intervalo para"
cDesc3  :="a emissao dos pedidos de compras."
aOrd    := {"Por Data Desembolso"}
titulo  :="Relacao de Pedidos de Compras"
cPerg   := "CLPDCX"
cString := "SC7"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }        
nomeprog:= "CCOM02R"
nLastKey:= 0
aLinha  :={ }
Limite  :=220
cabec1  :=""
cabec2  :=""
Tamanho :="G"

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Variaveis utilizadas para Impressao do Cabecalho e Rodape                  *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

Imprime := .T.

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Verifica as perguntas selecionadas                                         *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

Pergunte(cPerg,.F.)

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
*   Variaveis utilizadas para parametros                                     *
*   mv_par01       // do produto                                             *
*   mv_par02       // ate o produto                                          *
*   mv_par03       // data de entrega inicial                                *
*   mv_par04       // data de entrega final                                  *
*   mv_par05       // pedido inicial                                         *
*   mv_par06       // pedido final                                           *
*   mv_par07       // data de desembolso de                                  *
*   mv_par08       // data de desembolso ate                                 *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Envia controle para a funcao SETPRINT                                      *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

wnrel := "CCOM02R"
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.f.,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|| RelImp()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>     RptStatus({|| Execute(RelImp)})
DbCloseArea("TRB")

return(.T.)

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  RELIMP  ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³ 02.03.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ CHAMADA DO RELATORIO                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CCOM02R                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
Static Function RelImp()
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

cbtxt       := SPACE(10)
nQuebra     := 0
cCabQuebra  :=""
cQuebrant   :=""
cCOndBus    :=""
nQuant_a_Rec:= 0
CbCont      := 00
li          := 80
m_pag       := 01
lEnd        :=.f.

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Variaveis totalizadoras do relatorio                                       *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

nT_qtd_ped := 0		// qtde pedida
nT_vl_ipi  := 0		// valor do ipi
nT_vl_total:= 0         // valor total do pedido
nT_qtd_entr:= 0		// qtde entregue
nT_sd_receb:= 0		// saldo a receber
nT_desc    := 0		// total de desconto
_nPerc     := 0

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Variaveis utilizadas para totalizar os valores p/item                      *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

nPedida    := 0     // qtde pedida
nValIpi    := 0     // valor do ipi
nTotal     := 0     // valor total do pedido
nImport    := 0     // valor total de importacao
nTotImp    := 0     // flag que indica a somatoria dos pedidos importados apenas uma vez
nQuant     := 0     // qtde entregue
nSaldo     := 0     // saldo a receber
nFlag      := 0     // flag que indica se imprime totais por item ou nao
nITemIpi   := 0
nSalIpi    := 0
nFrete     := 0     // valor do frete
nDesc      := 0     // valor do desconto
_dMes      := MV_PAR07
nTotMes    := 0

*----------------------------------------------------------------------------*
* Monta os cabecalhos com os parametros                                      *
*----------------------------------------------------------------------------*

cabec1     := "RELACAO DOS PEDIDOS DE COMPRAS EM ABERTO P/DESEMBOLSO"
nOrdem     := aReturn[8]
cTexQuebra := "DESEMBOLSO: "
titulo     := titulo+" - POR DESEMBOLSO"
titulo     := titulo+", Todos"

cabec1     := "DATA       IT CODIGO    DESCRICAO DO PRODUTO           GRP  CODIGO  LJ RAZAO SOCIAL                    DATA DE  DATA DE          SALDO A  UM             VALOR  % ALIQ     VALOR TOTAL       VALOR A   CONDICAO   MOEDA"
cabec2     := "  PEDIDO      PRODUTO                                       FORNEC                                     EMISSAO  ENTREGA          RECEBER                 EM R$     IPI         (C/IPI)   DESEMBOLSAR   DE PAGTO        "           
//             0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15         16       17        18        19        20        21       21
//             0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

*----------------------------------------------------------------------------*
* Cria um vetor com a estrutura do arquivo temporario                        *
*----------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"TIPO"    ,"N",1 ,0})
AADD(aEstru1,{"ITEM"    ,"C",2 ,0})
AADD(aEstru1,{"PRODUTO" ,"C",15,0})
AADD(aEstru1,{"DESCRI"  ,"C",30,0})
AADD(aEstru1,{"UM"      ,"C",2 ,0})
AADD(aEstru1,{"QUANT"   ,"N",12,2})
AADD(aEstru1,{"MOEDA"   ,"N",1 ,0})
AADD(aEstru1,{"PRECO"   ,"N",14,4})
AADD(aEstru1,{"TOTAL"   ,"N",12,2})
AADD(aEstru1,{"PRECO2"  ,"N",14,2})
AADD(aEstru1,{"TOTAL2"  ,"N",14,2})
AADD(aEstru1,{"IPI   "  ,"N",5 ,2})
AADD(aEstru1,{"DATPRF"  ,"D",8 ,0})
AADD(aEstru1,{"FORNECE" ,"C",6 ,0})
AADD(aEstru1,{"LOJA  "  ,"C",2 ,0})
AADD(aEstru1,{"COND  "  ,"C",3 ,0})
AADD(aEstru1,{"EMISSAO" ,"D",8 ,0})
AADD(aEstru1,{"NUM   "  ,"C",6 ,0})
AADD(aEstru1,{"QUJE  "  ,"N",12,2})
AADD(aEstru1,{"DTFLUXO" ,"D",8 ,0})
AADD(aEstru1,{"VLDESC " ,"N",14,4})
AADD(aEstru1,{"DESC1  " ,"N",5 ,2})
AADD(aEstru1,{"DESC2  " ,"N",5 ,2})
AADD(aEstru1,{"DESC3  " ,"N",5 ,2})
AADD(aEstru1,{"IPIBRUT" ,"C",1 ,0})
AADD(aEstru1,{"FRETE  " ,"N",14,2})
AADD(aEstru1,{"NPARC"   ,"C",1 ,0})
AADD(aEstru1,{"TPCOND"  ,"C",1 ,0})
AADD(aEstru1,{"PERCTP8" ,"N",5 ,2})
AADD(aEstru1,{"VLDESEMB","N",14,2})
AADD(aEstru1,{"USADO   ","C",10,0})

_cTemp1 := CriaTrab( aEstru1, .T. )  
dbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. )

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Areas de trabalho a serem utilizadas para busca de dados                   *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

DbSelectArea("SE4")     // Condicao de Pagamento
DbSetOrder(1)           // Codigo

DbSelectArea("SC7")     // Pedidos de Compras
DbSetOrder(1)           // Numero + Item Pedido

DbSelectArea("SZ7")     // Desembolso de Pedidos de Importacao
DbSetOrder(2)           // Data Desembolso + Numero do Pedido

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Inicio do processamento das informacoes a serem trabalhadas                *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

DbSelectArea("SC7")
SetRegua(RecCount())
DbGoTop()
Do While !Eof()

	IncRegua()
	If lEnd
        @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Consiste este item. POR PEDIDO                               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If C7_NUM < mv_par05 .Or. C7_NUM > mv_par06
        DbSkip()
        Loop
    Endif
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Consiste este item. POR PRODUTO                              ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If C7_PRODUTO < mv_par01 .Or. C7_PRODUTO > mv_par02
        DbSkip()
        Loop
    Endif
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Consiste este item. POR DATA ENTREGA                         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If C7_DATPRF < mv_par03 .Or. C7_DATPRF > mv_par04
        DbSkip()
        Loop
    Endif
    DbSelectArea("SE4")
    DbSeek(xFilial()+SC7->C7_COND)
    If SE4->E4_CLNDUPL == "1" .OR. SE4->E4_CLNDUPL == "2" .OR. SE4->E4_CLNDUPL == "3";
        .OR. SE4->E4_CLNDUPL == "4" .OR. SE4->E4_CLNDUPL == "5" 
        Do Case
            Case Subs(SC7->C7_NUM,1,1) == "I"
                //DbSelectArea("SZ7")
                //DbSetOrder(1)
                //DbSeek(xFilial("SZ7")+SC7->C7_NUM)

                For _dFlux1:= MV_PAR07 to MV_PAR08
                    DbSelectArea("SZ7")
                    DbSetOrder(2)
                    If DbSeek(xFilial("SZ7")+Dtos(_dFlux1)+SC7->C7_NUM)
                        _dFlux:= SZ7->Z7_DATA
                        If !Empty(SZ7->Z7_DTPAGTO)
                        Else    
                            GravaTemp()
                        EndIf
                    EndIf
                Next
            Case SE4->E4_CLNDUPL == "1"
                If SE4->E4_TIPO == "8"
                    _nParc:= SE4->E4_CLNDUPL
                    _nDia1:= VAL(SUBSTR(SE4->E4_COND, 2,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia1
                Else
                    _nParc:= SE4->E4_CLNDUPL
                    _nDia1:= VAL(SUBSTR(SE4->E4_COND, 1,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia1
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf
            Case SE4->E4_CLNDUPL == "2"
                If SE4->E4_TIPO == "8"
                    _nParc:= SE4->E4_CLNDUPL
                    _nDia1:= VAL(SUBSTR(SE4->E4_COND, 2,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia1
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,10,2)) / 100
                Else
                    _nParc:= SE4->E4_CLNDUPL
                    _nDia1:= VAL(SUBSTR(SE4->E4_COND, 1,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia1
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf

                If SE4->E4_TIPO == "8"
                    _nDia2:= VAL(SUBSTR(SE4->E4_COND, 5,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia2
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,13,2)) / 100
                Else
                    _nDia2:= VAL(SUBSTR(SE4->E4_COND, 4,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia2
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf
            Case SE4->E4_CLNDUPL == "3"
                If SE4->E4_TIPO == "8"
                    _nParc:= SE4->E4_CLNDUPL
                    _nDia1:= VAL(SUBSTR(SE4->E4_COND, 2,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia1
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,10,2)) / 100
                Else
                    _nParc:= SE4->E4_CLNDUPL
                    _nDia1:= VAL(SUBSTR(SE4->E4_COND, 1,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia1
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf

                If SE4->E4_TIPO == "8"
                    _nDia2:= VAL(SUBSTR(SE4->E4_COND, 5,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia2
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,16,2)) / 100
                Else
                    _nDia2:= VAL(SUBSTR(SE4->E4_COND, 4,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia2
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf

                If SE4->E4_TIPO == "8"
                    _nDia3:= VAL(SUBSTR(SE4->E4_COND, 8,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia3
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,19,2)) / 100
                Else
                    _nDia3:= VAL(SUBSTR(SE4->E4_COND, 7,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia3
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf
            Case SE4->E4_CLNDUPL == "4"
                If SE4->E4_TIPO == "8"
                    _nParc:= SE4->E4_CLNDUPL
                    _nDia1:= VAL(SUBSTR(SE4->E4_COND, 2,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia1
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,16,2)) / 100
                Else
                    _nParc:= SE4->E4_CLNDUPL
                    _nDia1:= VAL(SUBSTR(SE4->E4_COND, 1,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia1
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf

                If SE4->E4_TIPO == "8"
                    _nDia2:= VAL(SUBSTR(SE4->E4_COND, 5,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia2
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,19,2)) / 100
                Else
                    _nDia2:= VAL(SUBSTR(SE4->E4_COND, 4,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia2
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf

                If SE4->E4_TIPO == "8"
                    _nDia3:= VAL(SUBSTR(SE4->E4_COND, 8,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia3
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,22,2)) / 100
                Else
                    _nDia3:= VAL(SUBSTR(SE4->E4_COND, 7,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia3
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf

                If SE4->E4_TIPO == "8"
                    _nDia4:= VAL(SUBSTR(SE4->E4_COND,11,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia4
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,25,2)) / 100
                Else
                    _nDia4:= VAL(SUBSTR(SE4->E4_COND,10,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia4
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf
            Case SE4->E4_CLNDUPL == "5"
                If SE4->E4_TIPO == "8"
                    _nParc:= SE4->E4_CLNDUPL
                    _nDia1:= VAL(SUBSTR(SE4->E4_COND, 2,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia1
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,19,2)) / 100
                Else
                    _nParc:= SE4->E4_CLNDUPL
                    _nDia1:= VAL(SUBSTR(SE4->E4_COND, 1,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia1
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf

                If SE4->E4_TIPO == "8"
                    _nDia2:= VAL(SUBSTR(SE4->E4_COND, 5,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia2
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,22,2)) / 100
                Else
                    _nDia2:= VAL(SUBSTR(SE4->E4_COND, 4,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia2
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf

                If SE4->E4_TIPO == "8"
                    _nDia3:= VAL(SUBSTR(SE4->E4_COND, 8,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia3
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,25,2)) / 100
                Else
                    _nDia3:= VAL(SUBSTR(SE4->E4_COND, 7,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia3
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf

                If SE4->E4_TIPO == "8"
                    _nDia4:= VAL(SUBSTR(SE4->E4_COND,11,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia4
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,28,2)) / 100
                Else
                    _nDia4:= VAL(SUBSTR(SE4->E4_COND,10,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia4
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf

                If SE4->E4_TIPO == "8"
                    _nDia5:= VAL(SUBSTR(SE4->E4_COND,14,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia5
                    _nPerc:= VAL(SUBSTR(SE4->E4_COND,31,2)) / 100
                Else
                    _nDia5:= VAL(SUBSTR(SE4->E4_COND,13,2))
                    _dFlux:= SC7->C7_DATPRF + _nDia5
                EndIf

                If _dFlux < mv_par07 .Or. _dFlux > mv_par08
                Else
                    GravaTemp()
                EndIf
            Case SE4->E4_CLNDUPL > 5
                MsgBox(Alltrim(SubStr(cUsuario,7,15))+", a cond.pagto. usada no pedido "+SC7->C7_NUM+" esta desdobrando mais do que 5 parcelas. Por favor avise o Administrador do Sistema para acertar o relatorio em questao" ,"COND.PAGTO. INADEQUADA","ALERT")
            EndCase
    EndIf
    dbSelectArea("SC7")
    dbSkip()
EndDo

ImpOrd1()

dbSelectArea("TRB")
Set Filter To
dbSetOrder(1)

Set device to Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPORD1  ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³ 02.03.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO RELATORIO NA 1¦ ORDEM                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CCOM02R                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpOrd1()

li      := 0
nQuebra := 0
nTotal  := 0
nSaldo  := 0
nSaldo1 := 0
nFrete  := 0
nT_Real := 0
nDesTot := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre Arquivo Temporario com os dados a serem impressos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cChave := "TRB->DTFLUXO"       // Por data de desembolso
_cIndTRB:= CriaTrab(Nil,.f.)     

DbSelectArea("TRB")
IndRegua("TRB",_cIndTRB,_cChave,,,"Selecionando Registros...")
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

While !Eof()

    //----> filtrando apenas pedidos que possuem saldo
    If TRB->QUANT <= 0
        //----> quando for importacao mostra pedidos mesmo encerrados
        If ! Subs(TRB->NUM,1,1) $ "I"
            DbSkip()
            Loop
        EndIf
    EndIf

    If li > 60
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
        li:=li-1
    Endif
    If nQuebra == 0
        @ li,000 PSAY TRB->DTFLUXO
        li:=li+1
        nQuebra := 1
    EndIf

    @ li,002 PSAY TRB->NUM
    @ li,011 PSAY TRB->ITEM
    @ li,014 PSAY TRB->PRODUTO
    @ li,030 PSAY Subs(TRB->DESCRI,1,25)
//    @ li,025 PSAY Subs(TRB->DESCRI,1,29)

    dbSelectArea("SB1")
    dbSeek(xFilial()+TRB->PRODUTO)
    If Found()
        @ li,056 PSAY B1_GRUPO
    Endif
    
    dbSelectArea("SA2")
    If dbSeek(xFilial()+TRB->FORNECE+TRB->LOJA)
        @ li,061 PSAY A2_COD
        @ li,069 PSAY A2_LOJA
        @ li,072 PSAY Subs(A2_NOME,1,29)
    Endif
    
    @ li,103 PSAY TRB->EMISSAO
    @ li,112 PSAY TRB->DATPRF
    @ li,123 PSAY TRB->QUANT Picture "@e 999,999,999.99"
    @ li,139 PSAY TRB->UM
    If TRB->MOEDA <> 1
        DbSelectArea("SM2")
        DbSetOrder(1)
        DbSeek(dDataBase)
        _nConverte := Iif(TRB->MOEDA == 2, SM2->M2_MOEDA2, Iif(TRB->MOEDA == 4, SM2->M2_MOEDA4,Iif(TRB->MOEDA == 5, SM2->M2_MOEDA5,Iif(TRB->MOEDA == 6, SM2->M2_MOEDA6,Iif(TRB->MOEDA == 7, SM2->M2_MOEDA7,Iif(TRB->MOEDA == 8, SM2->M2_MOEDA8, SM2->M2_MOEDA9))))))
        _nPreco    := (TRB->PRECO2 * _nConverte)
    Else
        _nConverte := 0
        _nPreco    := TRB->PRECO
    EndIf

    @ li,143 PSAY _nPreco    Picture "@e 999,999,999.9999"
    @ li,162 PSAY TRB->IPI   Picture tm(TRB->IPI,5,2)
    @ li,169 PSAY (TRB->QUANT * ( _nPreco * ((TRB->IPI / 100) + 1))) Picture "@e 999,999,999.99"
    DbSelectArea("SE4")
    DbSeek(xFilial()+TRB->COND)
    If TRB->NPARC == "0"
        //nSaldo  := nSaldo  + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100) + 1)))
        //nSaldo1 := nSaldo1 + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100) + 1)))
        //nT_Real := nT_Real + nSaldo1 - nDesTot
        If nTotImp == 0
            nImport := nImport + TRB->VLDESEMB
            nSaldo  := nSaldo  + TRB->VLDESEMB
            nSaldo1 := nSaldo1 + TRB->VLDESEMB
            nT_Real := nT_Real + nSaldo1 - nDesTot
            nTotImp := 1
        EndIf
    ElseIf TRB->NPARC == "1"
        @ li,183 PSAY (TRB->QUANT * (_nPreco * ((TRB->IPI / 100) + 1))) Picture "@e 999,999,999.99"
        nSaldo  := nSaldo  + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100) + 1)))
        nSaldo1 := nSaldo1 + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100) + 1)))
        nT_Real := nT_Real + nSaldo1 - nDesTot
    ElseIf TRB->NPARC == "2"
        If TRB->TPCOND == "8"
            @ li,183 PSAY (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)* TRB->PERCTP8)) Picture "@e 999,999,999.99"
            nSaldo  := nSaldo  + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)* TRB->PERCTP8))
            nSaldo1 := nSaldo1 + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)* TRB->PERCTP8))
            nT_Real := nT_Real + nSaldo1 - nDesTot
        Else
            @ li,183 PSAY (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)/2)) Picture "@e 999,999,999.99"
            nSaldo  := nSaldo  + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)/2))
            nSaldo1 := nSaldo1 + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)/2))
            nT_Real := nT_Real + nSaldo1 - nDesTot
        EndIf
    ElseIf TRB->NPARC == "3"
        If TRB->TPCOND == "8"
            @ li,183 PSAY (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)* TRB->PERCTP8)) Picture "@e 999,999,999.99"
            nSaldo  := nSaldo  + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)* TRB->PERCTP8))
            nSaldo1 := nSaldo1 + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)* TRB->PERCTP8))
            nT_Real := nT_Real + nSaldo1 - nDesTot
        Else
            @ li,183 PSAY (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)/3)) Picture "@e 999,999,999.99"
            nSaldo  := nSaldo  + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)/3))
            nSaldo1 := nSaldo1 + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)/3))
            nT_Real := nT_Real + nSaldo1 - nDesTot
        EndIf
    ElseIf TRB->NPARC == "4"
        If TRB->TPCOND == "8"
            @ li,183 PSAY (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)* TRB->PERCTP8)) Picture "@e 999,999,999.99"
            nSaldo  := nSaldo  + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)* TRB->PERCTP8))
            nSaldo1 := nSaldo1 + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)* TRB->PERCTP8))
            nT_Real := nT_Real + nSaldo1 - nDesTot
        Else
            @ li,183 PSAY (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)/4)) Picture "@e 999,999,999.99"
            nSaldo  := nSaldo  + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)/4))
            nSaldo1 := nSaldo1 + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)/4))
            nT_Real := nT_Real + nSaldo1 - nDesTot
        EndIf
    Else
        If TRB->TPCOND == "8"
            @ li,183 PSAY (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)* TRB->PERCTP8)) Picture "@e 999,999,999.99"
            nSaldo  := nSaldo  + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)* TRB->PERCTP8))
            nSaldo1 := nSaldo1 + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)* TRB->PERCTP8))
            nT_Real := nT_Real + nSaldo1 - nDesTot
        Else
            @ li,183 PSAY (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)/5)) Picture "@e 999,999,999.99"
            nSaldo  := nSaldo  + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)/5))
            nSaldo1 := nSaldo1 + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)/5))
            nT_Real := nT_Real + nSaldo1 - nDesTot
        EndIf
    EndIf

    If TRB->NPARC <> "0"
        @ li,200 PSAY SUBS(SE4->E4_DESCRI,1,9)
    EndIf

    @ li, 210 PSAY TRB->MOEDA

    nFrete   := nFrete + TRB->FRETE
    nDesTot  := nT_real
    nTotal   := nTotal + (TRB->QUANT * (_nPreco * ((TRB->IPI / 100)+1)))

    DbSelectArea("TRB")

    dFluxo1:= TRB->DTFLUXO
    _cPedido := TRB->NUM
    _cUso    := TRB->USADO
    _dMes    := TRB->DTFLUXO
    DbSkip()

    If TRB->NUM <> _cPedido
        If Subs(_cPedido,1,1) == "I"
            @ li,185 PSAY nImport  Picture tm(nImport,12,2)
            @ li,200 PSAY _cUso
            nImport := 0
            nTotImp := 0
        EndIf
    EndIf
    If TRB->DTFLUXO <> dFluxo1
        ImpItem()
        li:=li+1
        nQuebra:=0
        nTotal  := 0
        nTotMes := nTotMes + nSaldo
        nSaldo  := 0
        nFrete  := 0
    EndIf

    If Subs(DTos(TRB->DTFLUXO),5,2) <> Subs(Dtos(_dMes),5,2)
        @ li,000 PSAY "Total do Mes "+ Subs(Dtos(_dMes),5,2) + "/" + Subs(Dtos(_dMes),3,2)
        @ li,184 PSAY nTotMes Picture tm(nTotMes,12,2)
        li:=li+1
        @ li,000 PSAY Replicate("-",limite)
        nTotMes := 0
    EndIf

    li:=li+1
Enddo
@ li,000 PSAY "Total Geral "
@ li,184 PSAY nT_Real Picture tm(nT_vl_Total,12,2)
roda(CbCont,"PEDIDOS","G")

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPITEM  ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³ 02.03.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DOS TOTAIS P/ ITEM DE ACORDO COM A ORDEM         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CCOM02R                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImpItem
Static Function ImpItem()

cTotal:="Total do dia: "
li:=li+1
@ li,000 PSAY cTotal+" "+DtoC(dFluxo1)
@ li,170 PSAY nTotal   Picture tm(nTotal,12,2)
@ li,184 PSAY nSaldo   Picture tm(nSaldo,12,2)
If li > 60
    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
    li:=li-1
Endif
li:=li+1
@ li,000 PSAY Replicate("-",limite)
If li > 60
    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
    li:=li-1
Endif

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GRAVATEMP³ Autor ³RICARDO CORREA DE SOUZA³ Data ³ 02.03.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ GRAVA ARQUIVO TEMPORARIO COM AS DATAS DE DESEMBOLSO FLUXO  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CCOM02R                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function GravaTemp
Static Function GravaTemp()

DbSelectArea("TRB")
RecLock("TRB",.T.)
    TRB->TIPO       := SC7->C7_TIPO
    TRB->ITEM       := SC7->C7_ITEM
    TRB->PRODUTO    := SC7->C7_PRODUTO
    TRB->DESCRI     := SC7->C7_DESCRI
    TRB->UM         := SC7->C7_UM
    TRB->QUANT      := SC7->C7_QUANT -SC7->C7_QUJE
    TRB->MOEDA      := SC7->C7_MOEDA
    TRB->PRECO      := SC7->C7_PRECO
    TRB->TOTAL      := ((SC7->C7_QUANT - SC7->C7_QUJE) * SC7->C7_PRECO) 
    TRB->PRECO2     := SC7->C7_PRECO2
    TRB->TOTAL2     := ((SC7->C7_QUANT - SC7->C7_QUJE) * SC7->C7_PRECO2)
    TRB->IPI        := SC7->C7_IPI
    TRB->DATPRF     := SC7->C7_DATPRF
    TRB->FORNECE    := SC7->C7_FORNECE
    TRB->LOJA       := SC7->C7_LOJA
    TRB->COND       := SC7->C7_COND
    TRB->EMISSAO    := SC7->C7_EMISSAO
    TRB->NUM        := SC7->C7_NUM
    TRB->QUJE       := SC7->C7_QUJE
    TRB->VLDESC     := SC7->C7_VLDESC
    TRB->DESC1      := SC7->C7_DESC1
    TRB->DESC2      := SC7->C7_DESC1
    TRB->DESC3      := SC7->C7_DESC3 
    TRB->IPIBRUT    := SC7->C7_IPIBRUT
    TRB->FRETE      := SC7->C7_FRETE
    TRB->DTFLUXO    := Iif(Subs(SC7->C7_NUM,1,1)=="I",Posicione("SZ7",2,xFilial("SZ7")+Dtos(_dFlux)+SC7->C7_NUM,"Z7_DATA"),_dFlux)
    TRB->PERCTP8    := _nPerc
    TRB->NPARC      := Iif(Subs(SC7->C7_NUM,1,1)=="I","0",SE4->E4_CLNDUPL)
    TRB->TPCOND     := SE4->E4_TIPO
    TRB->VLDESEMB   := Iif(Subs(SC7->C7_NUM,1,1)=="I",Posicione("SZ7",2,xFilial("SZ7")+Dtos(_dFlux)+SC7->C7_NUM,"Z7_VALOR"),0)
    TRB->USADO      := Iif(Subs(SC7->C7_NUM,1,1)=="I",Posicione("SZ7",2,xFilial("SZ7")+Dtos(_dFlux)+SC7->C7_NUM,"Z7_USADO"),"")
MsUnLock()

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

