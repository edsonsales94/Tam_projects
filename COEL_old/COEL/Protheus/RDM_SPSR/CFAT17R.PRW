#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Cfat17r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,CPERG,LCONTINUA,NLIN,WNREL")
SetPrvt("CSTRING,NLASTKEY,LABORTPRINT,_DINICIAL,_CVEND,_CDESC")
SetPrvt("_NQTDE,_NBRUT,_NLIQ,NPAG,_ATOTDIA,_ATOTMES")
SetPrvt("_ACLASSIF,_AQTDDIA,_ABRTDIA,_ALIQDIA,_AQTDMES,_ABRTMES")
SetPrvt("_ALIQMES,_AREPDIA,_AREPMES,_LVEND,_NELEM,_I")
SetPrvt("_AOPEN,_ACLOSE,_AESTRU,_CTEMP1,_CTEMP2,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT17R  ³ Autor ³Ricardo Correa de Souza³ Data ³01/12/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo Semanal de Vendas por Representante/Classificacao   ³±±
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

/*/
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Variaveis utilizadas para parametros                         ³
  ³ mv_par01                Da Data Emissao                      ³
  ³ mv_par02                Ate Data Emissao                     ³ 
  ³ mv_par03                TES Venda Produtos                   ³ 
  ³ mv_par04                Complemento do TES                   ³ 
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==> 	#DEFINE PSAY SAY
#ENDIF

nTamanho  := "G" 
nLimite   := 220
cTitulo   := PADC( "Resumo Semanal de Vendas", 74 )
cDesc1    := PADC( "Este programa emitir  o resumo semanal das vendas (pedidos) por classifica-", 74 )
cDesc2    := PADC( "cao de descontos / vendedor.", 74 )
cDesc3    := PADC( "", 74 )
aReturn   := { "Especial", 1, "Diretoria COEL", 1, 1, 1, "", 1 }
nomeprog  := "CFAT17R" 
cPerg     := "FAT17R"
lContinua := .T.
nLin      := 0
wnrel     := "CFAT17R"
cString   := "SC5"
nLastKey  := 0
lAbortPrint := .F.

// **** Carrega as vari veis do dicion rio de perguntas
Pergunte( cPerg, .F. )

// **** Envia controle para a funcao SETPRINT 
wnrel := SetPrint( cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3, .F. )

If nLastKey == 27
   Return
Endif

// **** Verifica Posicao do Formulario na Impressora
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

#IFDEF WINDOWS
       RptStatus({|| IMPCLREL04()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>        RptStatus({|| Execute(IMPCLREL04)})
#ELSE
       IMPCLREL04()
#ENDIF

Return

/*/
  ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
  ³ FUNCAO   ³IMPCLREL04³ Autor ³ Alberto N. Gama Junior³ Data ³ 23/08/99 ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
  ³Descri‡Æo ³ Manipula‡Æo de dados e impressÆo do relat¢rio              ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ OBS      ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÙ                                                            ³
  ³                                                                       ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function IMPCLREL04
Static Function IMPCLREL04()

// **** Sele‡Æo e ordena‡Æo dos arquivos utilizados

_CriaArq()
DbSelectArea("SA1")                  // Clientes
DbSetOrder(1)                       // Codigo + Loja

DbSelectArea("SA3")                 // Vendedores / Representantes
DbSetOrder(1)                       // Codigo

DbSelectArea("SZ2")                 // Classif. Descontos
DbSetOrder(1)                       // Codigo

DbSelectArea("SC6")                 // Itens dos Pedidos
DbSetOrder(1)                       // Numero Pedido + Item + Produto

Processa({||RunProc()},"Filtrando Pedidos de Venda")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Filtrando Pedidos de Venda")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC5")                 // Pedidos de Venda
DbSetOrder(2)                       // Data Emissao + Numero Pedido

_dInicial := "01"+"/"+StrZero(Month(mv_par01),2)+"/"+Right(StrZero(Year(mv_par01),4),2)
_dInicial := CToD( _dInicial )
_dFinal   := mv_par01

If !DbSeek( xFilial("SC5") + DToS(_dInicial) )
   Do While _dInicial <= _dFinal
      _dInicial := _dInicial + 1
      If DbSeek( xFilial("SC5") + DToS(_dInicial) )
         Exit
      EndIf
   EndDo
EndIf

ProcRegua( LastRec() )

Do While !Eof() .AND. SC5->C5_EMISSAO <= MV_PAR02

   IncProc("Processando o Pedido: "+SC5->C5_NUM+" do dia: "+Dtoc(SC5->C5_EMISSAO))

    //----> filtrando somente pedidos de vendas
    If SC5->C5_TIPO #"N"
        DbSkip()
        Loop
    EndIf

   DbSelectArea("SA1")
   DbSeek( xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI )

   DbSelectArea("SA3")
   DbSeek( xFilial("SA3")+SA1->A1_VEND )

   DbSelectArea("SC6")
   DbSeek( xFilial("SC6")+SC5->C5_NUM )

   Do While !Eof() .AND. SC6->C6_NUM == SC5->C5_NUM

      If !SC6->C6_TES $Alltrim(mv_par03+mv_par04)
         DbSkip()
         Loop
      EndIf

      DbSelectArea(_cTemp1)
      RecLock( _cTemp1, .T. )

      FIELD->DATAEMI  := SC5->C5_EMISSAO
      FIELD->EST      := SA1->A1_EST
      FIELD->VEND     := SC5->C5_VEND1
      FIELD->CLDESC   := Subst( SA1->A1_CLCLASI, 1, 1 )
      FIELD->QTDE     := SC6->C6_QTDVEN
      FIELD->BRUTO    := Iif( SC6->C6_PRUNIT==0, SC6->C6_VALOR, SC6->C6_PRUNIT * SC6->C6_QTDVEN )
      FIELD->LIQUIDO  := SC6->C6_VALOR

      MsUnlock()

      DbSelectArea("SC6")
      DbSkip()

   EndDo

   DbSelectArea("SC5")
   DbSkip()

EndDo

// ***
// *** SELECAO DO ACUMULO MENSAL DAS VENDAS
// ***

DbSelectArea( _cTemp1 )
IndRegua( _cTemp1, _cTemp1, "VEND+CLDESC", , "", "Acumulo Mensal de Vendas..." )
SetRegua( LastRec() )
DbGoTop()

Do While !Eof() .AND. !lAbortPrint

   _cVEND := VEND
   _cDESC := CLDESC
   _nQTDE := 0
   _nBRUT := 0
   _nLIQ  := 0

   Do While !Eof() .AND. FIELD->VEND==_cVEND .AND. FIELD->CLDESC==_cDESC

      IncRegua()

      _nQTDE := _nQTDE + FIELD->QTDE
      _nBRUT := _nBRUT + FIELD->BRUTO
      _nLIQ  := _nLIQ  + FIELD->LIQUIDO

      DbSkip()

   EndDo

   DbSelectArea( _cTemp2 )
   RecLock( _cTemp2, .T. )

   FIELD->VEND     := _cVEND
   FIELD->CLDESC   := _cDESC
   FIELD->QTDE     := _nQTDE
   FIELD->BRUTO    := _nBRUT
   FIELD->LIQUIDO  := _nLIQ
   MsUnlock()

   DbSelectArea( _cTemp1 )
      
EndDo

// ***
// *** FIM - SELECAO DO ACUMULO MENSAL DAS VENDAS
// ***

// ***
// *** SELECAO DAS VENDAS SEMANAL
// ***

DbSelectArea( _cTemp2 )
IndRegua( _cTemp2, _cTemp2, "VEND+CLDESC", , "", "Acumulo Diario de Vendas..." )

DbSelectArea( _cTemp1 )
SetRegua( LastRec() )
DbGoTop()

Do While !Eof() .AND. !lAbortPrint

   _cVEND := FIELD->VEND
   _cDESC := FIELD->CLDESC
   _nQTDE := 0
   _nBRUT := 0
   _nLIQ  := 0

   Do While !Eof() .AND. FIELD->VEND==_cVEND .AND. FIELD->CLDESC==_cDESC

      IncRegua()

      If DATAEMI < mv_par01 .or. DATAEMI > mv_par02
         DbSkip()
         Loop
      EndIf

      _nQTDE := _nQTDE + FIELD->QTDE
      _nBRUT := _nBRUT + FIELD->BRUTO
      _nLIQ  := _nLIQ  + FIELD->LIQUIDO

      DbSkip()

   EndDo

   DbSelectArea( _cTemp2 )

   If DbSeek( _cVEND + _cDESC )

      RecLock( _cTemp2, .F. )

      FIELD->QTDE_D    := _nQTDE
      FIELD->BRUTO_D   := _nBRUT
      FIELD->LIQUIDO_D := _nLIQ

      MsUnlock()

   EndIf

   DbSelectArea( _cTemp1 )
      
EndDo

// ***
// *** FIM - SELECAO DAS VENDAS SEMANAL
// ***

// ***
// *** IMPRESSAO DO RELATORIO
// ***

nLin := nPag := 1

_aTOTDIA := { 0, 0, 0 }    // *** Total Geral do DIA e do MES
_aTOTMES := { 0, 0, 0 }    // *** { QTDE, BRUTO, LIQUIDO }

_aCLASSIF := {}            // *** Array com as classificacoes
_aQTDDIA := {}             // *** Total do DIA das classificacoes
_aBRTDIA := {}             // *** QTDE, BRUTO, LIQUIDO
_aLIQDIA := {}

_aQTDMES := {}             // *** Total do MES das classificacoes
_aBRTMES := {}             // *** QTDE, BRUTO, LIQUIDO
_aLIQMES := {}

_aRepDia  := { 0, 0, 0}      //----> Armazena totais do dia por vendedor
_aRepMes  := { 0, 0, 0}      //----> Armazena totais do mes por vendedor

DbSelectArea( _cTemp2 )
SetRegua( LastRec() )
DbGoTop()

@ 000, 000 PSAY AvalImp(nLimite)

Do While !Eof()

   _cVEND  := FIELD->VEND
   _lVEND  := .F.

   DbSelectArea("SA3")
   DbSeek( xFilial("SA3") + _cVEND )

   DbSelectArea( _cTemp2 )

   Do While !Eof() .AND. FIELD->VEND == _cVEND

      IncRegua()
      _CABREL04()
      @ nLin, 01 PSAY Iif( _lVEND==.F., VEND, SPACE(6))
      @ nLin, 08 PSAY Iif( _lVEND==.F., Subst( SA3->A3_NOME,1,17), SPACE(17))

      nLin := Iif( _lVEND==.F., nLin+1, nLin )

      @ nLin, 28 PSAY Iif( Empty(CLDESC), "S/C", CLDESC )

      @ nLin, 36 PSAY QTDE_D                     Picture"@E 99,999.99"
      @ nLin, 46 PSAY BRUTO_D / QTDE_D           Picture"@E 9,999,999.99"
      @ nLin, 61 PSAY BRUTO_D                    Picture"@E 9,999,999.99"
      @ nLin, 76 PSAY LIQUIDO_D                  Picture"@E 9,999,999.99"
      @ nLin, 90 PSAY Iif( QTDE_D==0,0,100-((LIQUIDO_D/BRUTO_D)*100) )    Picture"@E 9,999.99"
 
      @ nLin, 104 PSAY QTDE                      Picture"@E 99,999.99"
      @ nLin, 114 PSAY BRUTO / QTDE              Picture"@E 9,999,999.99"
      @ nLin, 129 PSAY BRUTO                     Picture"@E 9,999,999.99"
      @ nLin, 143 PSAY LIQUIDO                   Picture"@E 9,999,999.99"
      @ nLin, 157 PSAY Iif( QTDE==0,0,100-((LIQUIDO/BRUTO)*100) )       Picture"@E 9,999.99"

      // ***
      // *** Soma do Total Geral
      // *** 

      _aTOTMES[1] := _aTOTMES[1] + QTDE
      _aTOTMES[2] := _aTOTMES[2] + BRUTO
      _aTOTMES[3] := _aTOTMES[3] + LIQUIDO

      _aTOTDIA[1] := _aTOTDIA[1] + QTDE_D
      _aTOTDIA[2] := _aTOTDIA[2] + BRUTO_D
      _aTOTDIA[3] := _aTOTDIA[3] + LIQUIDO_D

      // ***
      // *** FIM - Soma do Total Geral
      // *** 

        //----> soma total do representante mes
        _aRepMes[1] := _aRepMes[1] + QTDE
        _aRepMes[2] := _aRepMes[2] + BRUTO
        _aRepMes[3] := _aRepMes[3] + LIQUIDO

        //----> soma total do representante dia
        _aRepDia[1] := _aRepDia[1] + QTDE_D
        _aRepDia[2] := _aRepDia[2] + BRUTO_D
        _aRepDia[3] := _aRepDia[3] + LIQUIDO_D

      // ***
      // *** Soma do Total das classificacoes
      // *** 

      _nElem := Ascan( _aCLASSIF, CLDESC )

      If _nElem == 0

         Aadd( _aCLASSIF, CLDESC )

         Aadd( _aQTDMES, QTDE    )
         Aadd( _aBRTMES, BRUTO   )
         Aadd( _aLIQMES, LIQUIDO )

         Aadd( _aQTDDIA, QTDE_D    )
         Aadd( _aBRTDIA, BRUTO_D   )
         Aadd( _aLIQDIA, LIQUIDO_D )

      Else

         _aQTDMES[_nElem] := _aQTDMES[_nElem] + QTDE
         _aBRTMES[_nElem] := _aBRTMES[_nElem] + BRUTO
         _aLIQMES[_nElem] := _aLIQMES[_nElem] + LIQUIDO

         _aQTDDIA[_nElem] := _aQTDDIA[_nElem] + QTDE_D
         _aBRTDIA[_nElem] := _aBRTDIA[_nElem] + BRUTO_D
         _aLIQDIA[_nElem] := _aLIQDIA[_nElem] + LIQUIDO_D

      EndIf

      // ***
      // *** FIM - Soma do Total das classificacoes
      // *** 

      _lVEND  := .T.
      nLin := nLin + 1

      DbSkip()

   EndDo
   @ nLin, 01 PSAY "                    SOMA --->"
   @ nLin, 36 PSAY _aRepDia[1] Picture"@E 99,999.99"
   @ nLin, 61 PSAY _aRepDia[2] Picture"@E 9,999,999.99"
   @ nLin, 76 PSAY _aRepDia[3] Picture"@E 9,999,999.99"

   @ nLin,104 PSAY _aRepMes[1] Picture"@E 99,999.99"
   @ nLin,129 PSAY _aRepMes[2] Picture"@E 9,999,999.99"
   @ nLin,143 PSAY _aRepMes[3] Picture"@E 9,999,999.99"

   nLin := nLin + 1
   @ nLin, 01 PSAY Replic("-",166)
   nLin := nLin + 1

   _aRepMes[1] := 0
   _aRepMes[2] := 0
   _aRepMes[3] := 0

   _aRepDia[1] := 0
   _aRepDia[2] := 0
   _aRepDia[3] := 0
EndDo

// ***
// *** Imprime os Totais das classificacoes
// ***

For _i := 1 To Len( _aCLASSIF )

    _CABREL04()

    @ nLin, 01 PSAY "TOTAL DE VENDAS  " + _aCLASSIF[_i] + "  --->"

    @ nLin, 36 PSAY _aQTDDIA[_i]                       Picture"@E 99,999.99"
    @ nLin, 46 PSAY _aBRTDIA[_i]/_aQTDDIA[_i]          Picture"@E 9,999,999.99"
    @ nLin, 61 PSAY _aBRTDIA[_i]                       Picture"@E 9,999,999.99"
    @ nLin, 76 PSAY _aLIQDIA[_i]                       Picture"@E 9,999,999.99"
    @ nLin, 90 PSAY Iif( _aQTDDIA[_i]==0, 0, 100-((_aLIQDIA[_i]/_aBRTDIA[_i])*100) )   Picture"@E 9,999.99"

    @ nLin, 104 PSAY _aQTDMES[_i]                       Picture"@E 99,999.99"
    @ nLin, 114 PSAY _aBRTMES[_i]/_aQTDMES[_i]          Picture"@E 9,999,999.99"
    @ nLin, 129 PSAY _aBRTMES[_i]                       Picture"@E 9,999,999.99"
    @ nLin, 143 PSAY _aLIQMES[_i]                       Picture"@E 9,999,999.99"
    @ nLin, 157 PSAY Iif( _aQTDMES[_i]==0, 0, 100-((_aLIQMES[_i]/_aBRTMES[_i])*100) )   Picture"@E 9,999.99"

    nLin := nLin + 1

Next

// ***
// *** FIM - Imprime os Totais das classificacoes
// ***

// ***
// *** Imprime o Total Geral
// ***

nLin := nLin + 1

_CABREL04()

@ nLin, 01 PSAY "RESULTADO GERAL     --->"
@ nLin, 36 PSAY _aTOTDIA[1]                      Picture"@E 99,999.99"
@ nLin, 46 PSAY _aTOTDIA[2]/_aTOTDIA[1]          Picture"@E 9,999,999.99"
@ nLin, 61 PSAY _aTOTDIA[2]                      Picture"@E 9,999,999.99"
@ nLin, 76 PSAY _aTOTDIA[3]                      Picture"@E 9,999,999.99"
@ nLin, 90 PSAY Iif( _aTOTDIA[1]==0, 0, 100-((_aTOTDIA[3]/_aTOTDIA[2])*100) )   Picture"@E 9,999.99"

@ nLin, 104 PSAY _aTOTMES[1]                     Picture"@E 99,999.99"
@ nLin, 114 PSAY _aTOTMES[2]/_aTOTMES[1]         Picture"@E 9,999,999.99"
@ nLin, 129 PSAY _aTOTMES[2]                     Picture"@E 9,999,999.99"
@ nLin, 143 PSAY _aTOTMES[3]                     Picture"@E 9,999,999.99"
@ nLin, 157 PSAY Iif( _aTOTMES[1]==0, 0, 100-((_aTOTMES[3]/_aTOTMES[2])*100) )  Picture"@E 9,999.99"

// ***
// *** FIM - Imprime o Total Geral
// ***

nLin := 61
@ nLin , 00 PSAY Replicate( "*", 166 )
@ 62   , 01 PSAY "COEL  Controles  Eletricos  Ltda" + Space(49) + " FIM " + Space(50) + "Deparatamento de Informatica"
@ 63   , 00 PSAY Replicate( '*', 166 )
@ 00   , 00 PSAY ""
SetPrc(0,0)

// ***
// *** Fecha os arquivos temporarios e apaga do disco
// ***

DbSelectArea("SC5")

_aOpen := {}
_aClose:= { _cTemp1, _cTemp2 }
CloseOpen( _aClose, _aOpen )

FErase( _cTemp1 + ".dbf" )
FErase( _cTemp1 + ".idx" )
FErase( _cTemp1 + ".mem" )

FErase( _cTemp2 + ".dbf" )
FErase( _cTemp2 + ".idx" )
FErase( _cTemp2 + ".mem" )

// ***
// *** FIM - Fecha os arquivos temporarios e apaga do disco
// ***

DbSelectArea("SC5")
RetIndex("SC5")

If aReturn[5] == 1
   Set Printer To 
   OurSpool( wnrel )
EndIf

MS_FLUSH()

Return
*****************************************************************************
*****************************************************************************
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function _CriaArq
Static Function _CriaArq()

// ****
// **** Cria arquivos temporarios para trabalho
// ****

_aEstru := {{"DATAEMI","D",8,0},{"EST","C",2,0},{"VEND","C",6,0},;
            {"CLDESC","C",1,0},{"QTDE","N",15,2},{"BRUTO","N",15,2},{"LIQUIDO","N",15,2}}
_cTemp1 := CriaTrab( _aEstru, .T. )
DbUseArea( .T., , _cTemp1, _cTemp1, .T., .F. )   // abre em modo exclusivo

_aEstru := {{"DATAEMI","D",8,0},{"ESTADO","C",2,0},{"VEND","C",6,0},{"CLDESC","C",1,0},;
            {"QTDE","N",15,2},{"BRUTO","N",15,2},{"LIQUIDO","N",15,2},;
            {"QTDE_D","N",15,2},{"BRUTO_D","N",15,2},{"LIQUIDO_D","N",15,2}}
_cTemp2 := CriaTrab( _aEstru, .T. )
DbUseArea( .T., , _cTemp2, _cTemp2, .T., .F. )   // abre em modo exclusivo

Return
*****************************************************************************
*****************************************************************************
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function _CABREL04
Static Function _CABREL04()

Do While .T.
   If nLin == 1
      @ nLin, 00  PSAY Replic("*",166)
      @ 02  , 01  PSAY "* CFAT17R * Data: " + DToC( Date() )
      @ 02  ,156  PSAY "Pag.: " + Str( nPag, 3 )
      @ 03  , 13  PSAY "Hora: "+Time()
      @ 03  , 63  PSAY "RESUMO SEMANAL DAS VENDAS DE " + DtoC( mv_par01 ) + " ATE " + DtoC( mv_par02 )
      @ 04  , 00  PSAY Replic("*",166)
      // ***          30    40        50        60        70        80        90        100       110       120       130       140       150       160
      // ***          4567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
      @ 05  , 36  PSAY "--------------------- VENDAS DA SEMANA -------------------------     ---------------------- ACUMULO MENSAL ------------------------"
      @ 06  , 41  PSAY      "Qtde        Preco          Valor          Valor    % Desc           Qtde        Preco          Valor         Valor    % Desc"
      @ 07  , 01  PSAY      "VENDEDOR / NOME"
      @ 07  , 41  PSAY      "Apar        Medio          Bruto        Liquido     Medio           Apar        Medio          Bruto       Liquido     Medio"
      @ 08  , 00  PSAY Replic("-",166)
      nLin := 10
   ElseIf nLin > 59
      nPag := nPag + 1
      nLin := 1
      Loop
   EndIf
   Exit
End

Return
*****************************************************************************
*****************************************************************************
