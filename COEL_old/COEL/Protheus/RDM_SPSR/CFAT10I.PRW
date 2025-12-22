#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function CFAT10I()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NLASTKEY,_CALIAS,_NORDER,_CPRCVEN,_AINIC,_NELEM")
SetPrvt("AFILES,_CGRAVAC5,_CAUXPED,_NITEM1,_NITEM2,_NITEM")
SetPrvt("_LPEDIDO,_I,_CADD,_ACLOSE,_AOPEN,_CARQENT")
SetPrvt("_CARQSAI,AESTRU1,AESTRU2,CARQREL,_CTEMP1,_CPEDVEN")
SetPrvt("_CCODCLI,_CLOJACLI,_CTRANSP,_CCODVEND,_CCODPROD,_CCONDPAG")
SetPrvt("_NOCORR,_CPEDIDO,_NPRCMIN,_CNUMPEDX8,TITULO,CABEC1")
SetPrvt("CABEC2,CDESC1,CDESC2,CSTRING,ARETURN,WNREL")
SetPrvt("TAMANHO,LIMITE,CBCONT,M_PAG,LI,_CAUXPED1")
SetPrvt("_CGRAVA,DDTENTREG,CREFER,DREFER,NACRES,NSEM")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT10I  ³ Autor ³Ricardo Correa de Souza³ Data ³03/12/1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Importacao dos Pedidos de Vendas Enviado pelos Vendedores  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Correa³23/02/01³Checar se o pedido ja foi importado e barrar   ³±±
±±³Ricardo Correa³23/05/01³Gerar dbf do relatorio para posterior analise  ³±±
±±³Ricardo Correa³06/06/01³Gravar a semana nos itens dos pedidos          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==> 	#DEFINE PSAY SAY
#ENDIF

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

nLastKey := 0
_cAlias  := Alias()
_nOrder  := IndexOrd()
_cPrcVen := 0
_aInic   := Directory("\SIGA\SIGAADV\PV??????.DBF")
_nElem   := 0
aFiles   := {}
_cGravaC5:= .f.
_cAuxPed := " "
_nItem1  := 1
_nItem2  := 1
_nItem   := 0
_lPedido := .t.

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SA1") // Cadastro de Clientes
DbSetOrder(1)       // Codigo+Loja

DbSelectArea("SA3") // Cadastro de Vendedores
DbSetOrder(1)       // Codigo

DbSelectArea("SA4") // Cadastro de Transportadoras
DbSetOrder(1)       // Codigo

DbSelectArea("SB1") // Cadastro de Produtos
DbSetOrder(1)       // Codigo

DbSelectArea("SE4") // Cadastro de Condicoes de Pagamento
DbSetOrder(1)       // Codigo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Desenho da Tela de Trabalho                                               *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

For _i := 1 To Len( _aInic )
    _cAdd := Upper(AllTrim(_aInic[_i,1])) 
    Aadd( aFiles, _cAdd )
Next

aSort( aFiles , 1 , Len(aFiles) )

@ 80,50 TO 423,575 DIALOG oDlg5 TITLE "Importacao dos Pedidos de Vendas-Siga Advanced"
@ 4,6 TO 160,255
@ 140,185 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> @ 140,185 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 140,220 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "      *** IMPORTACAO PEDIDOS VENDAS REPRESENTANTES COM SIGA ADVANCED ***"
@ 33,14 SAY " "
@ 43,14 SAY "Este programa tem o objetivo de importar e atualizar os arquivos SC5 e SC6"
@ 53,14 SAY "de pedidos de vendas, conforme arquivos dbf's eviado pelos representantes"
@ 85,14 ListBox _nElem Items aFiles Size 86,65 Object oSource
@ 110,105 SAY " <----- Selecione o arquivo a ser importado na lista ao lado" 

ACTIVATE DIALOG oDlg5
Close(oDlg5)
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function OkProc
Static Function OkProc()
Close(oDlg5)
Processa( {|| RunProc() } )// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa( {|| Execute(RunProc) } )

If nLastKey == 27
    Return
Else
    _aClose  := { "TRB","PDV" }
    _aOpen   := {} 
    CloseOpen( _aClose, _aOpen )

    fErase(_cTemp1+".DBF")

    If _nElem >0
         _cArqEnt := aFiles[_nElem]
	 _cArqSai :="\IMP\"+ aFiles[_nElem]

         copy file (_cArqEnt) to (_cArqSai)
         ferase(_cArqEnt)
    EndIf
EndIf

Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

#IFDEF WINDOWS
    IncProc(OemToAnsi("Processando Arquivo "))
#ELSE
    IncProc()
#ENDIF

aEstru1 := {{"NUMPED" ,"C",6 ,0} , {"SITEMPV" ,"C",2 ,0} , {"SIGAPED","C",6 ,0} , {"NITEMPV","C",2 ,0} , {"CODCLI"  ,"C",6 ,0} , {"LOJACLI","C",2 ,0} , {"NOMERED","C",10,0} , {"CODOCORR","N",1 ,0} , {"CODPROD","C",15,0} , {"QTDEVEN","N",9 ,2} , {"PRCVEN"  ,"N",14,4}}
aEstru2 := {{"NUMPED" ,"C",6 ,0} , {"SITEMPV" ,"C",2 ,0} , {"SIGAPED","C",6 ,0} , {"NITEMPV","C",2 ,0} , {"CODCLI"  ,"C",6 ,0} , {"LOJACLI","C",2 ,0} , {"NOMERED","C",10,0} , {"CODOCORR","N",1 ,0} , {"CODPROD","C",15,0} , {"QTDEVEN","N",9 ,2} , {"PRCVEN"  ,"N",14,4}}

cArqRel := "\IMP\"+"RL"+Subs(aFiles[_nElem],3)

DbCreate(cArqRel,aEstru2)

_cTemp1 := CriaTrab( aEstru1, .T. )  // Arquivo onde sera' gravado as inconsistencias

DbUseArea( .T., , _cTemp1  , "TRB", .F., .F. )
DbUseArea( .T., , cArqRel  , "REL", .F., .F. )

If _nElem == 0
    MsgBox(Alltrim(SubStr(cUsuario,7,15))+", voce nao selecionou o arquivo a ser importado. Por favor selecione o arquivo na lista","ARQUIVO NAO SELECIONADO","Stop")
    DbSelectArea(_cAlias)
    DbSetOrder(_nOrder)
    Return
Else
    DbUseArea( .T., , aFiles[_nElem], "PDV", .F., .F. )
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

//----> selecionando arquivo de pedidos dos vendedores
DbSelectArea("PDV")
DbGoTop()           

While Eof() == .f.

    _cPedVen    := ALLTRIM(PDV->NUMPED)
    _cCodCli    := ALLTRIM(PDV->CODCLI)
    _cLojaCli   := ALLTRIM(PDV->LOJACLI)
    _cTransp    := PDV->TRANSP
    _cCodVend   := PDV->CODVEND
    _cCodProd   := PDV->CODPROD
    _cCondPag   := PDV->CONDPAG

    //----> verifica se o pedido do cliente ja foi cadastrado anteriormente
    DbSelectArea("SC6")
    DbSetOrder(7)
    If DbSeek(xFilial("SC6")+_cPedVen)
        While PDV->NUMPED == _cPedVen .And. _lPedido
            _nOcorr  := 7

            GravaTrb()    //----> dados das inconsistencias
            DbSelectArea("PDV")
            DbSkip()
        EndDo
        If _lPedido
            Loop
        EndIf
    Else
        _lPedido := .f.
    EndIf

    //----> consiste se o cliente existe
    DbSelectArea("SA1")
    If !DbSeek(xFilial()+_cCodCLi+_cLojaCli)
        _nOcorr := 1
        _cPedido:=" "
        _nItem2 := 0

        GravaTrb()    //----> dados das inconsistencias   
    Else
        //----> consiste se a transportadora existe
        DbSelectArea("SA4")
        If !DbSeek(xFilial()+_cTransp)
            _nOcorr := 2
            _cPedido:=" "
            _nItem2 := 0

            GravaTrb()    //----> dados das inconsistencias
        Else
            //----> consiste se o vendedor existe
            DbSelectArea("SA3")
            If !DbSeek(xFilial()+_cCodVend)
                _nOcorr := 3
                _cPedido:=" "
                _nItem2 := 0

                GravaTrb()    //----> dados das inconsistencias
            Else
               //----> consiste se a condicao de pagamento existe
                DbSelectArea("SE4")
                If !DbSeek(xFilial()+_cCondPag)
                    _nOcorr := 6
                    _cPedido:=" "
                    _nItem2 := 0

                    GravaTrb()    //----> dados das inconsistencias
                Else
                    //----> consiste se o produto existe
                    DbSelectArea("SB1")
                    If !DbSeek(xFilial()+_cCodProd)
                        _nOcorr := 4
                        _cPedido:=" "
                        _nItem2 := 0

                        GravaTrb()    //----> dados das inconsistencias
                    Else
                        _nPrcMin:= posicione("SB5",1,xFilial("SB5")+SB1->B1_COD,"B5_PRV7")

                        //----> consiste se esta abaixo do preco minimo
                        If PDV->PRCVEN < _nPrcMin
                            _nOcorr := 5
                            _cPedido:=" "
                            _nItem2 := 0

                            GravaTrb()    //----> dados das inconsistencias
                        Else
                            If _cAuxPed <> _cPedVen
                               _nItem2:=0

                               _cNumPedX8:= GetSX8Num("SC5")
                               ConfirmSX8()
                               _cPedido:=_cNumPedX8

                               GravaSc5()    //----> cabecalho do pedido

                               _nItem2:=_nItem2 + 1
                                _nOcorr := 0

                                GravaSc6()    //----> itens do pedido
                                GravaTrb()    //----> dados das inconsistencias
                             Elseif _nOcorr > 0 
                               _nItem2:=0
                               _cNumPedX8:= GetSX8Num("SC5")
                               ConfirmSX8()
                               _cPedido:=_cNumPedX8

                                GravaSc5()    //----> cabecalho do pedido

                                _nItem2:=_nItem2 + 1
                                _nOcorr := 0

                                GravaSc6()    //----> itens do pedido
                                GravaTrb()    //----> dados das inconsistencias 
                             Else
                                _nItem2:=_nItem2 + 1
                                _nOcorr := 0

                                GravaSc6()    //----> itens do pedido
                                GravaTrb()    //----> dados das inconsistencias 
                             Endif
                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf
    _cAuxPed := PDV->NUMPED
    DbSelectArea("PDV")
    DbSkip()
      
    If _cAuxPed <> PDV->NUMPED
        _lPedido := .t.
    EndIf
EndDo

Processa( {|| Imp() } )// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa( {|| Execute(Imp) } )

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Imp
Static Function Imp()


titulo := "        Relacao Pedidos/Inconsistencias                "
cabec1 := "PedCli It PedSiga It CodCli Lj Cliente   Produto        Qtde  PrcVen  Ocorrencia"
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                  10        20        30        40        50        60        70        80
cabec2 := ""
cDesc1 := "Este Relatorio tem o objetivo de Listar os Pedidos com "
cDesc2 := "problemas na Importacao de Dados                       "
cString:= "TRB"
aReturn:= { "Especial", 1, "Comercial", 1, 1, 1,"", 1 }
wnrel  := "CLIMPPV"
Tamanho:= "P"
Limite := 80  
CbCont := 0
m_pag  := 1
wnrel := SetPrint( cString,wnrel,"",Titulo,cDesc1,cDesc2,"    ",.F.,,.T.,Tamanho,,.F.)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|| IMP2()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> RptStatus({|| Execute(IMP2)})
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Imp2
Static Function Imp2()

DbSelectArea("TRB")
DbGoTop()

While !Eof()
  li:= 3
  @ 00,  00 PSAY AvalImp(Limite)
  cabec(titulo,cabec1,cabec2,wnrel,Tamanho,15)
  _cAuxPed1:=""
  While !Eof() .And. li < 55
        @ li , 00 PSAY TRB->NUMPED
        @ li , 07 PSAY TRB->SITEMPV
        @ li , 10 PSAY TRB->SIGAPED
        @ li , 18 PSAY TRB->NITEMPV
        @ li , 21 PSAY TRB->CODCLI
        @ li , 28 PSAY TRB->LOJACLI
        @ li , 31 PSAY TRB->NOMERED                      
        @ li , 41 PSAY TRB->CODPROD Picture "@R 99.999.999"
        @ li , 51 PSAY TRB->QTDEVEN Picture "@E 999,999.99"
        @ li , 53 PSAY TRB->PRCVEN  Picture "@E 99,999,999,999.99"
        If TRB->CODOCORR == 1
            @ li , 71 PSAY "01"
        ElseIf TRB->CODOCORR == 2
            @ li , 71 PSAY "02"
        ElseIf TRB->CODOCORR == 3
            @ li , 71 PSAY "03"
        ElseIf TRB->CODOCORR == 4
            @ li , 71 PSAY "04"
        ElseIf TRB->CODOCORR == 5
            @ li , 71 PSAY "05"
        ElseIf TRB->CODOCORR == 6
            @ li , 71 PSAY "06"
        ElseIf TRB->CODOCORR == 7
            @ li , 71 PSAY "07"
        Else
            @ li , 71 PSAY "00"
        EndIf
            _cAuxPed1:=TRB->NUMPED
            DbSkip()
            li:= li + 01
            If _cAuxPed1 <> TRB->NUMPED
                @ li, 00 PSAY Replicate("-",Limite)
                li:= li + 01
            EndIf
  EndDo
EndDo

If Li > 55
  cabec(titulo,cabec1,cabec2,wnrel,Tamanho,15)
  li:= 3
EndIf

li := li + 1
@ li, 000 PSAY "L E G E N D A"
li := li + 1
@ li, 000 PSAY "00 - Pedido Importado com Sucesso"
li := li + 1
@ li, 000 PSAY "01 - Cliente nao Cadastrado"
li := li + 1
@ li, 000 PSAY "02 - Tranportadora nao Cadastrada"
li := li + 1
@ li, 000 PSAY "03 - Vendedor nao Cadastrado"
li := li + 1
@ li, 000 PSAY "04 - Produto nao Cadastrado"
li := li + 1
@ li, 000 PSAY "05 - Preco de Venda Abaixo do Preco Minimo"
li := li + 1
@ li, 000 PSAY "06 - Condicao de Pagamento nao Cadastrada"
li := li + 1
@ li, 000 PSAY "07 - Pedido Ja Existe no Siga"
li := li + 1

Roda(cbCont,"Pedidos","P")

If aReturn[5] == 1
   Set Printer TO
   OurSpool(Wnrel)
Endif

MS_FLUSH()

DbSelectArea("TRB")
DbGoTop()
ProcRegua(LastRec())

While Eof() == .f.

    IncProc("Copiando Dados Relatorio x Arquivo")

    DbSelectArea("REL")
    RecLock("REL",.t.)
      REL->NUMPED   := TRB->NUMPED   
      REL->SIGAPED  := TRB->SIGAPED  
      REL->NITEMPV  := TRB->NITEMPV  
      REL->CODCLI   := TRB->CODCLI   
      REL->LOJACLI  := TRB->LOJACLI  
      REL->NOMERED  := TRB->NOMERED  
      REL->SITEMPV  := TRB->SITEMPV  
      REL->CODOCORR := TRB->CODOCORR 
      REL->CODPROD  := TRB->CODPROD  
      REL->QTDEVEN  := TRB->QTDEVEN  
      REL->PRCVEN   := TRB->PRCVEN   
    MsUnLock()

    DbSelectArea("TRB")
    DbSkip()
EndDo

DbSelectArea(_cAlias)
DbSetOrder(_nOrder)

Return
****************************************************************************

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function GRAVATRB
Static Function GRAVATRB()

DbSelectArea("TRB")
RecLock("TRB",.T.)
TRB->NUMPED   := _cPedVen
TRB->SIGAPED  := Iif(_nOcorr == 7, Posicione("SC6",7,xFilial("SC6")+PDV->NUMPED,"C6_NUM"),_cPedido)
TRB->NITEMPV  := Iif(_nOcorr == 7, Posicione("SC6",7,xFilial("SC6")+PDV->NUMPED,"C6_ITEM"),Iif(StrZero(_nItem2,2)=="00"," ",StrZero(_nItem2,2)))
TRB->CODCLI   := _cCodCli
TRB->LOJACLI  := _cLojaCli
TRB->NOMERED  := Posicione("SA1",1,xFilial("SA1")+_cCodCli+_cLojaCli,"A1_NREDUZ")
TRB->SITEMPV  := PDV->ITEMPV
TRB->CODOCORR := _nOcorr
TRB->CODPROD  := PDV->CODPROD  
TRB->QTDEVEN  := PDV->QTDEVEN
TRB->PRCVEN   := PDV->PRCVEN
MsUnLock()
_cGrava:=.F.
Return
***************************************************************************

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function GRAVASC5
Static Function GRAVASC5()

DbSelectArea("SC5")
RecLock("SC5",.T.)
SC5->C5_FILIAL  := xFilial("SC5")
SC5->C5_NUM     := _cNumPedX8
SC5->C5_TIPO    := "N"
SC5->C5_CLIENTE := PDV->CODCLI
SC5->C5_LOJACLI := PDV->LOJACLI
SC5->C5_TIPOCLI := SA1->A1_TIPO
SC5->C5_CONDPAG := PDV->CONDPAG
SC5->C5_TABELA  := PDV->TABPREC
SC5->C5_VEND1   := PDV->CODVEND
SC5->C5_EMISSAO := dDataBase
SC5->C5_CLMSPED := PDV->MENSPED
SC5->C5_TIPLIB  := "2"
SC5->C5_LOJAENT := PDV->LOJACLI
SC5->C5_CLNOMCL := PDV->NOMERED
SC5->C5_CLPEDCL := PDV->PEDCLI
SC5->C5_CLPARC  := PDV->ENTRPARC
SC5->C5_CLANTE  := PDV->ENTRANTE
SC5->C5_CLATEND := PDV->ATENDENT
SC5->C5_TRANSP  := PDV->TRANSP
MsUnlock()
_cGravaC5:=.T.
Return
***************************************************************************

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function GRAVASC6
Static Function GRAVASC6()

DbSelectArea("SC6")
RecLock("SC6",.T.)
SC6->C6_FILIAL  := xFilial("SC6")
SC6->C6_ITEM    := StrZero(_nItem2,2)
SC6->C6_PRODUTO := PDV->CODPROD
SC6->C6_QTDVEN  := PDV->QTDEVEN
SC6->C6_PRCVEN  := PDV->PRCVEN
SC6->C6_TES     := "501"
SC6->C6_MOEDA   := 1
SC6->C6_PRUNIT  := SB1->B1_PRV1
SC6->C6_DESCRI  := SB1->B1_DESC
SC6->C6_NUM     := SC5->C5_NUM
SC6->C6_UM      := SB1->B1_UM
SC6->C6_VALOR   := PDV->PRCVEN * PDV->QTDEVEN
SC6->C6_SEGUM   := SB1->B1_SEGUM
SC6->C6_LOCAL   := SB1->B1_LOCPAD
SC6->C6_CLI     := PDV->CODCLI
SC6->C6_ENTREG  := PDV->DTENTREG
SC6->C6_LOJA    := PDV->LOJACLI
SC6->C6_PEDCLI  := SC5->C5_CLPEDCL
SC6->C6_CLGOP   := Posicione("SB1",1,xFilial("SB1")+PDV->CODPROD,"B1_CLGOP")

GeraSem()   //----> calcula o numero da semana

SC6->C6_SEMANA  :=  nSem
If SA1->A1_EST == "SP"
     SC6->C6_CF  := "511"
Else
     SC6->C6_CF  := "611"
EndIf    
MsUnLock()
Return

****************************************************************************

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function GeraSem
Static Function GeraSem()

dDtEntreg := SC6->C6_ENTREG

cRefer := "01/01/" + AllTrim( Str( Year( dDtEntreg ), 4 ) )
dRefer := CToD( cRefer )
nAcres := Dow( dRefer ) - 1
nSem   := ( dDtEntreg - dRefer ) + nAcres
nSem   := nSem / 7
nSem   := Iif( Subst( Str( nSem, 12, 2 ), 11, 2 )=="00", Int(nSem), Int(nSem)+1 )

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

****************************************************************************
