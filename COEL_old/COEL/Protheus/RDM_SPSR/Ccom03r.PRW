#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
 #IFNDEF WINDOWS 
	#DEFINE PSAY SAY
#ENDIF

User Function Ccom03r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,TITULO,CDESC1,CDESC2,CDESC3,CSTRING")
SetPrvt("DDATA,CCOND,AMATRRETURN,CPERG,ARETURN,NOMEPROG")
SetPrvt("ALINHA,NLASTKEY,LEND,LI,M_PAG,CABEC1")
SetPrvt("CABEC2,CABEC3,LIMITE,TAMANHO,CBCONT,NTIPO")
SetPrvt("DDATASAV,LRET,DDATABASE,_NDOLAR1,_NDOLAR2,_NPRCPED")
SetPrvt("_NPRCNOT,NFLAG,")

 #IFNDEF WINDOWS 
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CCOM03R  ³ Autor ³RICARDO CORREA DE SOUZA³ Data ³ 15/02/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EMISSAO DA RELACAO DE DIVERGENCIAS DE PEDIDOS DE COMPRAS   ³±±
±±³          ³ E NOTAS FISCAIS DE ENTRADA.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CLPEDNF()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO COEL CONTROLES ELETRICOS LTDA                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Function CLPEDNF()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel  :=""
titulo := "Relacao de Divergencias de Pedidos de Compras"
cDesc1 := "Emissao da Relacao de Itens para Compras"
cDesc2 := "com divergencias"
cDesc3 := ""
cString:= "SD1"
dData  := ctod(space(8))
cCond := ""
aMatrReturn:= {0,"0",.T.,Nil}
cPerg:= "MTR130"
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog:="CCOM03R"
aLinha  := { } 
nLastKey := 0
lEnd:=.F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li       := 80
m_pag    := 1
wnrel    := "CCOM03R"  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01           // a partir da data de recebimento        ³
//³ mv_par02           // ate a data de recebimento              ³
//³ mv_par03           // lista notas sem pedidos ?  (sim/nao)   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	DbSetFilter() //Set Filter To
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>    __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   DbSetFilter()//set filter to
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>    __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
Endif

#IFDEF WINDOWS
    RptStatus({|| ImpDet()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>     RptStatus({|| Execute(ImpDet)})
#ELSE
    ImpDet() 
#ENDIF
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return() 
Return()         // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpDet   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 10.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CLPEDNF()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImpDet
Static Function ImpDet()
cabec1:=""
cabec2:=""
cabec3:=""
limite := 132
tamanho:= " "
cbCont := 0

nTipo := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "DIVERGENCIAS ENTRE NF DE COMPRAS E PEDIDOS"
cabec1 := " NOTA   EMISSAO CODIGO LJ  FORNECEDOR                    PRODUTO         UM    QUANTIDADE      VALOR UNITARIO  DT.ENTREGA COND."
cabec2 := "PEDIDO                                                                                             R$/US$                      "

Impr130(titulo,cabec1,cabec2,nomeprog,nTipo,tamanho,lEnd)// ******************

IF li <> 80 
	li:=li+1 
	@ li,000 PSAY Replicate("-",limite) 
	roda(CbCont,"DIVERGENCIAS"," ") 
EndIF 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD1")
//dbSetFilter() 
Set Filter To
dbSetOrder(1)

dbSelectArea("SF1")
dbSetOrder(1)

dbSelectArea("SC7")
dbSetOrder(1)

dbSelectArea("SA2")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)

Set device to Screen

If aReturn[5] == 1 
   Set Printer To
   dbCommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return() 
Return()         // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPR130  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatorio                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ IMPDET()                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Impr130
Static Function Impr130()
dDataSav:=""
lRet:=""

dbSelectArea("SD1")
dbGoTop()
dbSetOrder(1)
Set SoftSeek On
dbSeek(xFilial())
Set SoftSeek Off

SetRegua(RecCount())

While !eof() .and. D1_FILIAL == xFilial() 

	#IFNDEF WINDOWS
		If LastKey() == 286    //ALT_A
			lEnd := .t.
		EndIf
	#ENDIF

	If lEnd
		@ PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"		
		Exit
	Endif

	IncRegua()
	
	If D1_DTDIGIT < mv_par01 .Or. D1_DTDIGIT > mv_par02
		dbSkip()
		Loop
	Endif

	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial()+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
	If Found()
		dData := SF1->F1_DTDIGIT
	Endif

    dbselectArea("SE4")
    dbSetOrder(1)
    dbSeek(xfilial()+SF1->F1_COND)

    dbSelectArea("SC7")
	dbSetOrder(4)
	dbSeek(xFilial()+SD1->D1_COD+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
	cCond := ""
	If Found()
		dDataSav  := dDataBase
		dDataBase := SD1->D1_DTDIGIT
		cCond		 := SC7->C7_COND

        If SD1->D1_ITEMPC <> SC7->C7_ITEM
			While !Eof() .And. SC7->C7_PRODUTO == SD1->D1_COD .And.;
					SC7->C7_FORNECE == SD1->D1_FORNECE .And.;
					SC7->C7_LOJA == SD1->D1_LOJA .And.;
					SC7->C7_NUM == SD1->D1_PEDIDO .And.;
					SC7->C7_ITEM <> SD1->D1_ITEMPC 
				dbSelectArea("SC7")
				dbSkip()
				Loop
			End					
		Endif

		lRet := .F.
        If SD1->D1_QUANT == SC7->C7_QUANT .AND.;
		   SD1->D1_VUNIT == IIf(Empty(SC7->C7_REAJUSTE),SC7->C7_PRECO,Formula(SC7->C7_REAJUSTE)) .AND.;
			SD1->D1_DTDIGIT == SC7->C7_DATPRF .AND.;
			SF1->F1_COND == SC7->C7_COND
			If SD1->D1_LOJA == SC7->C7_LOJA	
				lRet := .T.
			EndIf
			If lRet 	
				dbSelectArea("SD1")
  				dbSkip()
				Loop
			EndIf	
        EndIf    
        If SD1->D1_QUANT < SC7->C7_QUANT
            dbSelectArea("SD1")
            dbSkip()
            Loop
        EndIf 
        If SC7->C7_MOEDA == 2
             dbSelectarea("SM2")
             dbSetOrder(1)
             dbSeek(SC7->C7_EMISSAO)
            _nDolar1:=SM2->M2_MOEDA2
             dbSeek(SD1->D1_EMISSAO)
            _nDolar2:=SM2->M2_MOEDA2
            _nPrcPed:=Round(SC7->C7_PRECO/_nDolar1,4)
            _nPrcNot:=Round(SD1->D1_VUNIT/_nDolar2,4)
        Else
            _nPrcPed:=IIf(Empty(SC7->C7_REAJUSTE),SC7->C7_PRECO,Formula(SC7->C7_REAJUSTE))
            _nPrcNot:=SD1->D1_VUNIT
        EndIf
        If _nPrcPed == _nPrcNot
            dbSelectArea("SD1")
            dbSkip()
            Loop
        Endif
        dbSelectArea("SE4")
        dbSeek(xFilial()+SC7->C7_COND)

		dDataBase := dDataSav
		dbSelectArea("SA2")
		dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
      nFlag:=1
		ImprLinha(1,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond)//*************
	Else
		dbSelectArea("SA2")
		dbSeek(xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA)
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
      nFlag:=2
		ImprLinha(2,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData)//****************
	Endif
	dbSelectArea("SD1")
	dbSkip()
End

aMatrReturn[3]:=.T.
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> //__Return .t.
Return//__Return .t.        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³IMPRLINHA ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da Linha de Detalhe                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR130                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImprLinha//(nFlag,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond) //static
Static Function ImprLinha//(nFlag,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond) //static()

dDataSav:=""

If nFlag == 1

	@ li,000 PSAY SD1->D1_DOC
	@ li,007 PSAY SD1->D1_EMISSAO
	@ li,016 PSAY SD1->D1_FORNECE
	@ li,023 PSAY SD1->D1_LOJA
	@ li,026 PSAY IIF(EMPTY(SA2->A2_NREDUZ),SUBS(SA2->A2_NOME,1,30),SA2->A2_NREDUZ)
	@ li,057 PSAY SD1->D1_COD

	dbSelectArea("SB1")
	dbSeek(xFilial()+SD1->D1_COD)

	@ li,073 PSAY SB1->B1_UM
	@ li,077 PSAY SD1->D1_QUANT   Picture PesqPictQt("D1_QUANT",12)
    @ li,092 PSAY Iif(SC7->C7_MOEDA==2,"US$","R$")
    @ li,095 PSAY _nPrcNot   Picture PesqPict("SD1","D1_VUNIT",14)
    @ li,113 PSAY IIF(!empty(dData), dData , "")
    @ li,124 PSAY SE4->E4_DESCRI

	li:=li+1
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	dDataSav  := dDataBase
	dDataBase := SD1->D1_DTDIGIT
 	@ li,000 PSAY SC7->C7_NUM
	@ li,007 PSAY SC7->C7_EMISSAO
	@ li,016 PSAY SC7->C7_FORNECE
	@ li,023 PSAY SC7->C7_LOJA
	@ li,026 PSAY IIF(EMPTY(SA2->A2_NREDUZ),SUBS(SA2->A2_NOME,1,30),SA2->A2_NREDUZ)
	@ li,057 PSAY SC7->C7_PRODUTO
	@ li,073 PSAY SB1->B1_UM
	@ li,077 PSAY SC7->C7_QUANT     Picture PesqPictQt("C7_QUANT",12)
    @ li,092 PSAY Iif(SC7->C7_MOEDA==2,"US$","R$")
    @ li,095 PSAY _nPrcPed  Picture PesqPict("SC7","C7_PRECO",14)
    @ li,113 PSAY SC7->C7_DATPRF
    @ li,124 PSAY SE4->E4_DESCRI // cCond               Picture PesqPict("SC7","C7_COND",3)
	dDataBase := dDataSav
	Li:=Li+2
ElseIf MV_PAR03 == 1
	@ li,000 PSAY SD1->D1_DOC
	@ li,007 PSAY SD1->D1_DTDIGIT
	@ li,016 PSAY SD1->D1_FORNECE
	@ li,023 PSAY SD1->D1_LOJA
	@ li,026 PSAY IIF(EMPTY(SA2->A2_NREDUZ),SUBS(SA2->A2_NOME,1,30),SA2->A2_NREDUZ)
	@ li,057 PSAY SD1->D1_COD

	dbSelectArea("SB1")
	dbSeek(xFilial()+SD1->D1_COD)

	@ li,073 PSAY SB1->B1_UM
	@ li,077 PSAY SD1->D1_QUANT     Picture PesqPictQt("D1_QUANT",12)
    @ li,092 PSAY Iif(SC7->C7_MOEDA==2,"US$","R$")
    @ li,095 PSAY SD1->D1_VUNIT     Picture PesqPict("SD1","D1_VUNIT",14)
    @ li,113 PSAY IIF(!empty(dData), dData , "")
    @ li,124 PSAY SE4->E4_DESCRI // cCond               Picture PesqPict("SD1","D1_COND",3)


	Li:=li+1
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	@ li,000 PSAY "Nao ha' pedido de compra colocado"
	Li:=Li+2
Endif

aMatrReturn[3]:=.T.
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> //__Return .T.
Return//__Return .T.        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
