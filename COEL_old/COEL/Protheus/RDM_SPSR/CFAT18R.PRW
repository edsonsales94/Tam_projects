#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Cfat18r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NTOTQTD,_NTOTVAL,_NTOTFAT,_NTOTSAL,_NBASEIPI")
SetPrvt("_NVALIPI,_NALIQPRO,_NVALPED,_NVALDIA,_CNOMECLI,_CMUNICLI")
SetPrvt("_CESTACLI,_CTIPOCLI,_CNOMEVEND,_CDESCPRO,CTITADD,CABEC1")
SetPrvt("CABEC2,_CAUXPED,_DEMISSAO,AREGS,I,J")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT18R  ³ Autor ³Ricardo Correa de Souza³ Data ³06/12/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Pedidos de Vendas por Vendedor X Cliente        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Adilson      ³12/12/00³ Inclusao do parametro para selecionar TES     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==>     #DEFINE PSAY SAY
#ENDIF
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SA1")         //----> Cadastro de Clientes
DbSetOrder(1)               //----> Codigo + Loja

DbSelectArea("SA3")         //----> Cadastro de Vendedores
DbSetOrder(1)               //----> Codigo

DbSelectArea("SB1")         //----> Cadastro de Produtos
DbSetOrder(1)               //----> Codigo

DbSelectArea("SC5")         //----> Cabecalho de Pedidos de Vendas
DbSetOrder(2)               //----> Data de Emissao + Pedido

DbSelectArea("SC6")         //----> Itens de Pedidos de Vendas
DbSetOrder(1)               //----> Pedido + Item

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"PROD"    ,"C",15,0})
AADD(aEstru1,{"DESCR"   ,"C",30,0})
AADD(aEstru1,{"PEDIDO"  ,"C",06,0})
AADD(aEstru1,{"ITEMPV"  ,"C",02,0})
AADD(aEstru1,{"EMISSAO" ,"D",08,0})
AADD(aEstru1,{"QUANT"   ,"N",09,2})
AADD(aEstru1,{"QTDFAT"  ,"N",09,2})
AADD(aEstru1,{"UNIT"    ,"N",12,2})
AADD(aEstru1,{"TOTAL"   ,"N",12,2})
AADD(aEstru1,{"IPI   "  ,"N",12,2})
AADD(aEstru1,{"TES"     ,"C",03,0})
AADD(aEstru1,{"CFO"     ,"C",04,0})
AADD(aEstru1,{"VEND  "  ,"C",06,0})
AADD(aEstru1,{"NOMEV "  ,"C",15,0})
AADD(aEstru1,{"CLIENTE" ,"C",06,0})
AADD(aEstru1,{"LOJA"    ,"C",02,0})
AADD(aEstru1,{"NOMEC"   ,"C",15,0})
AADD(aEstru1,{"MUNIC"   ,"C",15,0})
AADD(aEstru1,{"UF"      ,"C",02,0})

_cTemp1 := CriaTrab( aEstru1, .T. )  
//dbUseArea(.T.,__cRdd,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )
dbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "CFAT18R"
cDesc1    := "Emissao dos pedidos de vendas por vendedor X cliente"
cDesc2    := "de um determinado periodo definido pelo usuario"
cDesc3    := " "
cString   := "SC5"
lEnd      := .F.
tamanho   := "G"
limite    := 220
titulo    := "Relacao de Pedidos de Vendas por Vendedor X Cliente"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFAT18R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT18R"
nLin      := 8
m_pag     := 1
_nTotQtd  := 0
_nTotVal  := 0
_nTotFat  := 0
_nTotSal  := 0
_nBaseIpi := 0
_nValIpi  := 0
_nAliqPro := 0
_nValPed  := 0
_nValDia  := 0

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da Data        ?                                          *
* mv_par02  ----> Ate a Data     ?                                          *
* mv_par03  ----> Do Vendedor    ?                                          *
* mv_par04  ----> Ate o Vendedor ?                                          *
* mv_par05  ----> Do Pedido      ?                                          *
* mv_par06  ----> Ate o Pedido   ?                                          *
* mv_par07  ----> Do Cliente     ?                                          *
* mv_par08  ----> Da Loja        ?                                          *
* mv_par09  ----> Ate o Cliente  ?                                          *
* mv_par10  ----> Ate Loja       ?                                          *
* mv_par11  ----> Do Produto     ?                                          *
* mv_par12  ----> Ate o Produto  ?                                          *
* mv_par13  ----> Valores c/Ipi  ? (Sim/Nao)                                *
* mv_par14  ----> Tipo do Cliente? (Distrib/Revend/Produtor/Consum/Todos)   *
* mv_par15  ----> Tipo do TES    ?                                          *
*                                                                           *
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

Processa({||RunProc()},"Filtrando Dados ...")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Filtrando Dados ...")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC5")
ProcRegua(RecCount())
DbSeek(xFilial("SC5")+Dtos(mv_par01),.t.)

Do While !Eof() .And. SC5->C5_FILIAL==xFilial("SC5") .And. SC5->C5_EMISSAO <= mv_par02
    IncProc("Selecionando Dados do Pedido: "+SC5->C5_NUM)

    //----> filtrando somente pedidos de vendas
    If SC5->C5_TIPO #"N"
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de pedidos definido nos parametros
    If SC5->C5_NUM < mv_par05 .Or. SC5->C5_NUM > mv_par06
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de vendedores definido nos parametros
    If SC5->C5_VEND1 < mv_par03 .Or. SC5->C5_VEND1 > mv_par04
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de clientes definido nos parametros
    If SC5->C5_CLIENTE + SC5->C5_LOJACLI < mv_par07 + mv_par08 .Or. SC5->C5_CLIENTE +SC5->C5_LOJACLI > mv_par09 + mv_par10
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC6")
    DbSeek(xFilial("SC6")+SC5->C5_NUM)
    Do While !EOF().AND.SC6->C6_FILIAL==xFilial("SC6").AND.SC6->C6_NUM == SC5->C5_NUM

        //----> filtrando intervalo de produtos definido nos parametros
        If SC6->C6_PRODUTO < mv_par11 .Or. SC6->C6_PRODUTO > mv_par12
            DbSkip()
            Loop
        EndIf

        //----> filtrando intervalo de TES definido nos parametros
        If !SC6->C6_TES $mv_par15
           DbSkip()
           Loop
        EndIf

        DbSelectArea("SA1")
        DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
        _cNomeCli := SA1->A1_NOME
        _cMuniCli := SA1->A1_MUN
        _cEstaCli := SA1->A1_EST
        _cTipoCli := SA1->A1_CLASCLI

        //----> filtrando intervalo de classificacao do cliente definido nos parametros
        If mv_par14 == 1
        ElseIf mv_par14 == 2 .And. _cTipoCli #"D"
            DbSelectArea("SC6")
            DbSkip()
            Loop
        ElseIf mv_par14 == 3 .And. _cTipoCli #"R"
            DbSelectArea("SC6")
            DbSkip()
            Loop
        ElseIf mv_par14 == 4 .And. _cTipoCli #"P"
            DbSelectArea("SC6")
            DbSkip()
            Loop
        ElseIf mv_par14 == 5 .And. _cTipoCli #"C"
            DbSelectArea("SC6")
            DbSkip()
            Loop
        EndIf

        DbSelectArea("SA3")
        DbSeek(xFilial("SA3")+SC5->C5_VEND1)
        _cNomeVend := SA3->A3_NOME

        DbSelectArea("SB1")
        DbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
        _cDescPro := SB1->B1_DESC
        _nAliqPro := SB1->B1_IPI

        DbSelectArea("TRB")
        RecLock("TRB",.t.)
          TRB->PROD     :=      SC6->C6_PRODUTO
          TRB->DESCR    :=      _cDescPro
          TRB->PEDIDO   :=      SC6->C6_NUM
          TRB->ITEMPV   :=      SC6->C6_ITEM
          TRB->EMISSAO  :=      SC5->C5_EMISSAO
          TRB->QUANT    :=      SC6->C6_QTDVEN
          TRB->QTDFAT   :=      SC6->C6_QTDENT
          TRB->UNIT     :=      SC6->C6_PRCVEN
          TRB->IPI      :=      _nAliqPro

          //----> verificando se considera o ipi ou nao
          If mv_par13 == 1
              _nBaseIpi := SC6->C6_PRCVEN * SC6->C6_QTDVEN
              _nValipi  := _nBaseIpi * (_nAliqPro/100) * 1
              TRB->TOTAL    :=      SC6->C6_VALOR + _nValIpi
          Else
              TRB->TOTAL    :=      SC6->C6_VALOR
          EndIf

          TRB->TES      :=      SC6->C6_TES
          TRB->CFO      :=      SC6->C6_CF
          TRB->VEND     :=      SC5->C5_VEND1
          TRB->NOMEV    :=      _cNomeVend
          TRB->CLIENTE  :=      SC5->C5_CLIENTE
          TRB->LOJA     :=      SC5->C5_LOJACLI
          TRB->NOMEC    :=      _cNomeCli
          TRB->MUNIC    :=      _cMuniCli
          TRB->UF       :=      _cEstaCli
        MsUnLock()

        DbSelectArea("SC6")
        DbSkip()
    EndDo

    DbSelectArea("SC5")
    DbSkip()
EndDo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

#IFDEF WINDOWS
    RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>     RptStatus({|| Execute(Imprime)},titulo)
#ELSE
    Imprime()
#ENDIF


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Imprime
Static Function Imprime()


cTitAdd := Iif(mv_par13 == 1," - TOTAIS COM IPI"," - TOTAIS SEM IPI")                                                                                                                                         
cabec1  := "Cod Prod    Descricao                          Pedido/Item  Emissao   Qtd Vendida  Qtd Faturada  Qtd Saldo   Preco Unit        Total  Tes  Cfo    CodVen Nome            CodCli/Lj Nome                 Municipio         Uf"
cabec2  := ""
titulo  := titulo + cTitAdd 

DbSelectArea("TRB")
DbGoTop()
SetRegua(Lastrec())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

Do While !Eof()

    IncRegua()

    @ nLin, 000 Psay TRB->PROD                   Picture "@R 99.999.999"
    @ nLin, 012 Psay TRB->DESCR
    @ nLin, 047 Psay TRB->PEDIDO
    @ nLin, 054 Psay TRB->ITEMPV
    @ nLin, 060 Psay Dtoc(TRB->EMISSAO)
    @ nLin, 071 Psay TRB->QUANT                  Picture "@E 999,999.99"
    @ nLin, 085 Psay TRB->QTDFAT                 Picture "@E 999,999.99"
    @ nLin, 096 Psay (TRB->QUANT - TRB->QTDFAT)  Picture "@E 999,999.99"
    @ nLin, 105 Psay TRB->UNIT                   Picture "@E 999,999,999.99"
    @ nLin, 118 Psay TRB->TOTAL                  Picture "@E 999,999,999.99"
    @ nLin, 134 Psay TRB->TES   
    @ nLin, 139 Psay TRB->CFO   
    @ nLin, 146 Psay TRB->VEND  
    @ nLin, 153 Psay TRB->NOMEV 
    @ nLin, 169 Psay TRB->CLIENTE
    @ nLin, 176 Psay TRB->LOJA   
    @ nLin, 179 Psay TRB->NOMEC  
    @ nLin, 200 Psay TRB->MUNIC  
    @ nLin, 218 Psay TRB->UF     

    nLin := nLin + 1

    //----> totaliza o relatorio
    _nTotQtd := _nTotQtd + TRB->QUANT
    _nTotVal := _nTotVal + TRB->TOTAL
    _nTotFat := _nTotFat + TRB->QTDFAT
    _nTotSal := _nTotSal + (TRB->QUANT - TRB->QTDFAT)

    _cAuxPed := TRB->PEDIDO
    _nValPed := _nValPed + TRB->TOTAL
    _nValDia := _nValDia + TRB->TOTAL
    _dEmissao:= TRB->EMISSAO

    DbSkip()

    //----> totaliza total do pedido
    If TRB->PEDIDO #_cAuxPed
        nLin := nLin + 1
        @ nLin, 000 Psay "Total do Pedido "+_cAuxPed+" ---->"
        @ nLin, 118 Psay _nValPed Picture "@E 999,999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        _nValPed := 0
        nLin := nLin + 1
    EndIf

    //----> totaliza total do dia   
    If TRB->EMISSAO #_dEmissao
        nLin := nLin + 1
        @ nLin, 000 Psay "Total do Dia "+Dtoc(_dEmissao)+" ---->"
        @ nLin, 118 Psay _nValDia Picture "@E 999,999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        _nValDia := 0
        nLin := nLin + 1
    EndIf

    If nLin > 59
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
        nLin := 8
    Endif

EndDo

//----> totaliza total geral do relatorio
nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1
@ nLin, 000 Psay "Total Geral ---->"
@ nLin, 071 Psay _nTotQtd   Picture "@E 999,999.99"
@ nLin, 085 Psay _nTotFat   Picture "@E 999,999.99"
@ nLin, 096 Psay _nTotSal   Picture "@E 999,999.99"
@ nLin, 118 Psay _nTotVal   Picture "@E 999,999,999.99"

Roda(cbCont,"Pedidos",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

DbCloseArea("TRB")
Ferase(_cTemp1+".dbf")
Ferase(_cTemp1+".idx")
Ferase(_cTemp1+".mem")

MS_FLUSH()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)

    aRegs := {}

    aadd(aRegs,{cPerg,'01','Da Emissao     ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate Emissao    ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Do Vendedor    ? ','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'04','Ate o Vendedor ? ','mv_ch4','C',06, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'05','Do Pedido      ? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','SC5'})
    aadd(aRegs,{cPerg,'06','Ate o Pedido   ? ','mv_ch6','C',06, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','','SC5'})
    aadd(aRegs,{cPerg,'07','Do Cliente     ? ','mv_ch7','C',06, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'08','Da Loja        ? ','mv_ch8','C',02, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Ate o Cliente  ? ','mv_ch9','C',06, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'10','Ate a Loja     ? ','mv_cha','C',02, 0, 0,'G', '', 'mv_par10','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'11','Do Produto     ? ','mv_chb','C',15, 0, 0,'G', '', 'mv_par11','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'12','Ate o Produto  ? ','mv_chc','C',15, 0, 0,'G', '', 'mv_par12','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'13','Considera Ipi  ? ','mv_chd','N',01, 0, 2,'C', '', 'mv_par13','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'14','Tipo do Cliente? ','mv_che','N',01, 0, 5,'C', '', 'mv_par14','','','','','','','','','','','','','','',''})

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

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna para sua Chamada (CFAT18R)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

/*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Lay Out do Relatorio                                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Cod Prod   Descricao                          Pedido/Item  Emissao    Qtd Vendida  Qtd Faturada  Qtd Saldo   Preco Unit     Total   Tes  Cfo  CodVen Nome            CodCli Loja   Nome                Municipio         Uf
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
99999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 99    99/99/99   999,999.99   999,999.99    999,999.99  999,999,999.99 999.99  999  999  999999 XXXXXXXXXXXXXXX 999999 99     XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
TOTAL GERAL                                                           999,999.99   999,999.99    999,999.99         999,999,999.99  

*/

