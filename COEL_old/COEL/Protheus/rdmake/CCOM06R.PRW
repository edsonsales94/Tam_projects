#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Ccom06r()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_AESTRUTURA,WNREL,CDESC1,CDESC2,CDESC3,CSTRING")
SetPrvt("LEND,TAMANHO,LIMITE,TITULO,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN,M_PAG")
SetPrvt("CABEC1,CABEC2,CARQTRAB,CARQENT,CARQSAI,AREGS")
SetPrvt("I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CCOM06R  ³ Autor ³Ricardo Correa de Souza³ Data ³05/02/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao do Controle de Atraso das Entregas (CAE)           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 02/09/02 ==>     #DEFINE PSAY SAY
#ENDIF
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SA2")         //----> Cadastro de Fornecedores
DbSetOrder(1)               //----> Codigo + Loja

DbSelectArea("SB1")         //----> Cadastro de Produtos    
DbSetOrder(1)               //----> Codigo       

DbSelectArea("SC7")         //----> Pedido de Compras
DbSetOrder(1)               //----> Pedido + Item 

DbSelectArea("SD1")         //----> Itens de Nota de Entrada
DbSetOrder(6)               //----> Data da Entrada

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Estrutura do Arquivo que Sera Gerado                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_aEstrutura := {}

Aadd(_aEstrutura,{ "PEDIDO"       ,"C",06,0 } )
Aadd(_aEstrutura,{ "ITEMPC"       ,"C",02,0 } )
Aadd(_aEstrutura,{ "CODFOR"       ,"C",06,0 } )
Aadd(_aEstrutura,{ "LOJFOR"       ,"C",02,0 } )
Aadd(_aEstrutura,{ "NOME"         ,"C",15,0 } )
Aadd(_aEstrutura,{ "PRODUTO"      ,"C",15,0 } )
Aadd(_aEstrutura,{ "DESCRIC"      ,"C",28,0 } )
Aadd(_aEstrutura,{ "DTNEGOC"      ,"D",08,0 } )
Aadd(_aEstrutura,{ "DTENTRE"      ,"D",08,0 } )
Aadd(_aEstrutura,{ "ATRASO"       ,"N",03,0 } )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "CCOM06R"
cDesc1    := "Emissao do Controle de Atraso das Entregas     "
cDesc2    := "exigido pela ISO 9000.                         "
cDesc3    := " "
cString   := "SC7"
lEnd      := .F.
tamanho   := "M"
limite    := 132
titulo    := "Controle de Atraso das Entregas - CAE"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CCOM06R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "COM06R"
nLin      := 8
m_pag     := 1
//regua      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//regua               10        20        30        40        50        60        70        80        90       100       110       120         132
Cabec1    := "PEDIDO  IT     CODIGO/LJ     NOME                PRODUTO             DESCRICAO                       DT NEGOC    DT ENTRE     ATRASO"
Cabec2    := ""

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da Data Entrada   ?                                       *
* mv_par02  ----> Ate a Data Entrada?                                       *
* mv_par03  ----> Do Fornecedor     ?                                       *
* mv_par04  ----> Da Loja           ?                                       *
* mv_par05  ----> Ate o Fornecedor  ?                                       *
* mv_par06  ----> Ate a Loja        ?                                       *
* mv_par07  ----> Nome do Arquivo   ?                                       *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Controle de Atraso das Entregas")// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Processa({||Execute(RunProc)},"Controle de Atraso das Entregas")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function RunProc
Static Function RunProc()

cArqTrab := alltrim(MV_PAR07)+".DBF"

DbCreate(cArqTrab,_aEstrutura)

//DbUseArea(.T.,__cRdd,cArqTrab,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )
DbUseArea(.T.,,cArqTrab,"TRB", NIL, .F. )

DbSelectArea("SD1")
ProcRegua(LastRec())
DbGoTop()

While Eof() == .f. 

    IncProc("Selecionando Pedidos em Atraso")

    //----> filtrando somente datas definida nos parametros
    If SD1->D1_DTDIGIT < mv_par01 .Or. SD1->D1_DTDIGIT > mv_par02
        DbSkip()
        Loop
    EndIf

    //----> filtrando somente fornecedores definido nos parametros
    If SD1->D1_FORNECE+SD1->D1_LOJA < mv_par03+mv_par04 .Or. SD1->D1_FORNECE+SD1->D1_LOJA > mv_par05+mv_par06
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC7")
    If !DbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
        DbSelectArea("SD1")
        DbSkip()
        Loop
    Else
        If SD1->D1_DTDIGIT > SC7->C7_DTNEG
            DbSelectArea("SA2")
            DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)

            //----> filtrando somente fornecedores ativos (homologados)
            If mv_par08 == 2
                //----> verificando se o fornecedor esta inativo
                If SA2->A2_CLSTATU #"A"
                    DbSelectArea("SD1")
                    DbSkip()
                    Loop
                EndIf
            EndIf

            DbSelectArea("SB1")
            DbSeek(xFilial("SB1")+SD1->D1_COD)

            DbSelectArea("TRB")
            RecLock("TRB",.t.)
              TRB->PEDIDO   :=  SC7->C7_NUM
              TRB->ITEMPC   :=  SC7->C7_ITEM
              TRB->CODFOR   :=  SD1->D1_FORNECE
              TRB->LOJFOR   :=  SD1->D1_LOJA
              TRB->NOME     :=  SA2->A2_NREDUZ
              TRB->PRODUTO  :=  SD1->D1_COD
              TRB->DESCRIC  :=  SB1->B1_DESC  
              TRB->DTNEGOC  :=  SC7->C7_DTNEG
              TRB->DTENTRE  :=  SD1->D1_DTDIGIT
              TRB->ATRASO   :=  SD1->D1_DTDIGIT - SC7->C7_DTNEG
            MsUnLock()
        EndIf
    EndIf

    DbSelectArea("SD1")
    DbSkip()
EndDo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> RptStatus({|| Execute(Imprime)},titulo)


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function Imprime
Static Function Imprime()

DbSelectArea("TRB")
DbGoTop()
SetRegua(Lastrec())

@ 00,00 Psay AvalImp(limite)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

Do While !Eof()

    IncRegua()

    @ nLin, 000         Psay TRB->PEDIDO
    @ nLin, Pcol()+02   Psay TRB->ITEMPC
    @ nLin, Pcol()+05   PSAY TRB->CODFOR
    @ nLin, Pcol()      PSAY "/"
    @ nLin, Pcol()      PSAY TRB->LOJFOR
    @ nLin, Pcol()+05   PSAY TRB->NOME   
    @ nLin, Pcol()+05   PSAY TRB->PRODUTO
    @ nLin, Pcol()+05   PSAY TRB->DESCRIC
    @ nLin, Pcol()+04   PSAY Dtoc(TRB->DTNEGOC)
    @ nLin, Pcol()+04   PSAY Dtoc(TRB->DTENTRE)
    @ nLin, Pcol()+01   PSAY TRB->ATRASO 

    nLin := nLin + 1

    If nLin > 59
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
        nLin := 8
    Endif

    DbSkip()
EndDo

Roda(cbCont,"Pedidos",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

DbSelectArea("TRB")
DbCloseArea("TRB")

cArqEnt := cArqTrab
cArqSai :="\EXP\"+cArqTrab

Copy File (cArqEnt) to (cArqSai)

Ferase(cArqEnt)

Ms_Flush()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)

    aRegs := {}

    aadd(aRegs,{cPerg,'01','Da Entrega      ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate a Entrega   ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Do Fornecedor   ? ','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','','SA2'})
    aadd(aRegs,{cPerg,'04','Da Loja         ? ','mv_ch4','C',02, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Ate o Fornecedor? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','SA2'})
    aadd(aRegs,{cPerg,'06','Ate a Loja      ? ','mv_ch6','C',02, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Nome do Arquivo ? ','mv_ch7','C',08, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'08','Status Forneced ? ','mv_ch8','N',01, 0, 0,'C', '', 'mv_par08','','','','','','','','','','','','','','',''})

    For i:=1 to Len(aRegs)
	Dbseek(cPerg+StrZero(i,2))
	If found() == .f.
	    RecLock("SX1",.t.)
	    For j:=1 to Fcount()
		FieldPut(j,aRegs[i,j])
	    Next
	    MsUnLock()
	EndIf
    Next
EndIf

Return   

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna para sua Chamada (CCOM06R)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
