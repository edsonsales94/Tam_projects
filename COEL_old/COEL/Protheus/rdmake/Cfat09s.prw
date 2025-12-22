#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Cfat09s()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,CPERG,LCONTINUA,NLIN,WNREL")
SetPrvt("CSTRING,NLASTKEY,LABORTPRINT,_LDACAO,_NPAGO,XDADOS")
SetPrvt("NVRCOM,_LNFISC,_CSERIE,_NPRECOSAI,XCALC,NDESC")
SetPrvt("NCOMIS,XLIQUIDO,XCOMISSAO,ATOTGER,NPAG,ATOTVEND")
SetPrvt("XVEND,NPARCELAS,TMP_COMI1,AFECHA,AABRE,AESTRU1")
SetPrvt("AESTRU2,_CTEMP1,_CTEMP2,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT09S  ³ Autor ³ Alberto N. Gama Junior³ Data ³ 08/09/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de comissäes dos vendedores por recebimento      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para COEL Controles Eletricos Ltda              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBS       ³ Busca notas fiscais no SAI quando nao encontra no SF2, isto³±±
±±³          ³ devido a migracao dos titulos a receber.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ALTERA€åES³ 22/01/2001 - NAO CALCULA COMISSAO PARA CLIENTES COM O CAMPO³±±
±±³          ³              SA1->A1_CLCDSAI =99999                        ³±±
±±³          ³ 23/04/2001 - CONSIDERA SOMENTE TITULOS BAIXADOS NORMALMENTE³±±
±±³          ³              (NÇO CONSIDERA BAIXAS POR DEVOLUCAO)          ³±±
±±³          ³ 05/11/2001 - A PARTIR DO FAT. DE OUTUBRO/01 PARA REPRES.   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Variaveis utilizadas para parametros                         ³
  ³ mv_par01                Data Recebto de                      ³
  ³ mv_par02                Data Recebto at‚                     ³ 
  ³ mv_par03                Cod. Representante de                ³ 
  ³ mv_par04                Cod. Representante at‚               ³ 
  ³ mv_par05                TES Venda Produtos                   ³ 
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 02/09/02 ==> 	#DEFINE PSAY SAY
#ENDIF

nTamanho  := "P" 
nLimite   := 132
cTitulo   := PADC( "Comissäes s/ Recebimento", 80 )
cDesc1    := PADC( "Este programa emitir  relat¢rio de comissäes a pagar aos vendedores.", 74 )
cDesc2    := PADC( "Considera os t¡tulos recebidos no per¡odo.                          ", 74 )
cDesc3    := ""
aReturn   := { "Especial", 1, "Gerencia COEL", 1, 1, 1, "", 1 }
nomeprog  := "CFAT09S" 
cPerg     := "CLRL06"
lContinua := .T.
nLin      := 0
wnrel     := "Comis02"
cString   := "SE1"
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
       RptStatus({|| IMPCLREL06()})// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==>        RptStatus({|| Execute(IMPCLREL06)})
       Return
#ELSE 
       IMPCLREL06()
#ENDIF

/*/
  ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
  ³ FUNCAO   ³IMPCLREL06³ Autor ³ Alberto N. Gama Junior³ Data ³ 08/09/99 ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
  ³Descri‡Æo ³ Manipula‡Æo de dados e impressÆo do relat¢rio              ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ OBS      ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÙ                                                            ³
  ³                                                                       ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function IMPCLREL06
Static Function IMPCLREL06()

// **** Abre arquivos temporarios e os arquivos do SAI: FATB001, FATB002, ENGB001
_CriaTemp()

// **** Sele‡Æo e ordena‡Æo dos arquivos utilizados

DbSelectArea("SB1")                 // Produtos
DbSetOrder(1)                       // Codigo

DbSelectArea("SZ4")                 // Tabela de Comissäes dos Vendedores
DbSetOrder(1)                       // Codigo + Desconto Maximo

DbSelectArea("SA1")                 // Clientes
DbSetOrder(1)                       // Codigo + Loja

DbSelectArea("SA3")                 // Vendedores / Representantes
DbSetOrder(1)                       // Codigo

DbSelectArea("SF4")                 // TES
DbSetOrder(1)                       // Codigo

DbSelectArea("SD2")                 // Itens das NFs
DbSetOrder(3)                       // Nota + Serie + Cliente + Loja + Prod

DbSelectArea("SF2")                 // Cabe‡alho de Notas Fiscais Sa¡da
DbSetOrder(1)                       // Nota + Serie

DbSelectArea("SE5")                 // Contas a Receber
DbSetOrder(7)                       // Prefixo + Numero Titulo + Parcela + tipo

DbSelectArea("SE1")                 // Contas a Receber
DbSetOrder(1)                       // Prefixo + Numero Titulo + Parcela + tipo

SetRegua( LastRec() )
DbGoTop()

Do While !Eof() .AND. !lAbortPrint

   IncRegua()

   If SE1->E1_BAIXA < mv_par01 .OR. SE1->E1_BAIXA > mv_par02
      DbSkip()
      Loop
   EndIf

   If SE1->E1_SALDO > 0 .OR. !AllTrim(SE1->E1_TIPO) $"NF.DP."
      DbSkip()
      Loop
   EndIf

   DbSelectArea("SA1")
   DbSeek( xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA )

   If SA1->A1_VEND < mv_par03 .OR. SA1->A1_VEND > mv_par04
      DbSelectArea("SE1")
      DbSkip()
      Loop
   EndIf

   _lDacao := .F.
   _nPAGO  := 0

   DbSelectArea("SE5")
   DbSeek( xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO )

   Do While !Eof() .AND. E5_PREFIXO==SE1->E1_PREFIXO .AND. E5_NUMERO==SE1->E1_NUM .AND. E5_PARCELA==SE1->E1_PARCELA .AND. E5_TIPO==SE1->E1_TIPO .AND. !_lDacao

      If SE5->E5_MOTBX == "CMP" .AND. SE5->E5_TIPODOC $ "_CP_BA"
         // Registro Ignorado
      ElseIf "DAC" $SE5->E5_MOTBX
         _lDacao := .T.
      ElseIf SE5->E5_TIPODOC == "ES"
         _nPAGO := _nPAGO - SE5->E5_VALOR
      ElseIf !SE5->E5_TIPODOC $"_VL_BA_"
         // Registro Ignorado
      ElseIf SE5->E5_TIPO == "RA"
         _nPAGO := _nPAGO + SE5->E5_VALOR
      ElseIf SE5->E5_MOTBX $".NOR.CMP."
         _nPAGO := _nPAGO + SE5->E5_VALOR
      EndIf
      DbSkip()
   EndDo

   If _lDacao == .T.
      DbSelectArea("SE1")
      DbSkip()
      Loop
   EndIf

   xDADOS := .F.

   nVrCom := 0

   DbSelectArea("SA3")
   DbSeek( xFilial("SA3") + SA1->A1_VEND )

   DbSelectArea("SF2")
   _lNFISC := DbSeek( xFilial("SF2") + SE1->E1_NUM + Iif( Alltrim(SE1->E1_TIPO)$"NF",SE1->E1_SERIE, "" ))

   If _lNFISC == .F.

      // *** Busca as Notas Fiscais no Sai

      _cSERIE :=  "SAI"

      DbSelectArea("_FAT1")                    // Ordenar este por StrZero,6 
      If !DbSeek( SE1->E1_NUM )
         If MsgBox( "NF "+SE1->E1_NUM+" nao encontrada no FAT1.", "Continuar ?", "YESNO" ) == .F.
            Return
         EndIf
         DbSelectArea("SE1")
         DbSkip()
         Loop
      EndIf

      DbSelectArea("_FAT2")                   // Ordenar este por StrZero,6 
      If !DbSeek( SE1->E1_NUM )
         If MsgBox( "NF "+SE1->E1_NUM+" nao encontrada no FAT2.", "Continuar ?", "YESNO" ) == .F.
            Return
         EndIf
         DbSelectArea("SE1")
         DbSkip()
         Loop
      EndIf

      Do While !Eof() .AND. _FAT2->NF == _FAT1->NF

         If !_FAT2->COD_NAT $"02.03.12.13.14.25.26.27.33.34.35.36.66.70.73.99.77.B7"
            DbSkip()
            Loop
         EndIf

         DbSelectArea("_PROD")
         _nPrecoSai := Iif( DbSeek(_FAT2->CODIGO), _PROD->PR_VENDA, 0 )

         xCalc  := Round( ( _FAT2->PR_UNIT * 100 ) / _nPrecoSai, 2 )
         nDESC  := Iif( xCalc <= 0, 0, 100 - xCalc )
         nComis := 0

         DbSelectArea("SZ4")
         DbSeek( xFilial("SZ4") + SA3->A3_CLTBCOM )

         Do While !Eof() .AND. SZ4->Z4_CLCOD == SA3->A3_CLTBCOM
            If Z4_CLMAX >= nDESC
               nComis := SZ4->Z4_CLCOM
               Exit
            EndIf
            DbSkip()
         EndDo

         DbSelectArea("_NOTAS")
         DbAppend()

         Replace TMP_EMIS With _FAT1->DATA_EMS
         Replace TMP_NF   With SE1->E1_NUM
         Replace TMP_PARC With SE1->E1_PARCELA
         Replace TMP_SERI With _cSERIE
         Replace TMP_PROD With _FAT2->CODIGO
         Replace TMP_VRTB With _nPrecoSai
         Replace TMP_UNIT With _FAT2->PR_UNIT
         Replace TMP_QTDE With _FAT2->QTDE
//**     Replace TMP_QDEV With _FAT2->QDEV
         Replace TMP_DESC With nDesc
         Replace TMP_COM  With nComis

//**     xLIQUIDO := Round( ( FIELD->TMP_QTDE - FIELD->TMP_QDEV ) * FIELD->TMP_UNIT , 2 )
         xLIQUIDO := Round( FIELD->TMP_QTDE  * FIELD->TMP_UNIT , 2 )
         xCOMISSAO:= Round( ( xLIQUIDO * FIELD->TMP_COM ) / 100, 2 )
         nVrCom   := nVrCom + xCOMISSAO
         xDADOS   := .T.

         DbSelectArea("_FAT2")
         DbSkip()

      EndDo

   Else
         
      _cSERIE := SF2->F2_SERIE

      DbSelectArea("SD2")
      If !DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE )
         DbSelectArea("SE1")
         DbSkip()
         Loop
      EndIf

      Do While !Eof() .AND. SD2->D2_DOC==SF2->F2_DOC
 
         If SD2->D2_SERIE #SF2->F2_SERIE
            DbSkip()
            Loop
         EndIf

         If !SD2->D2_TES $mv_par05
            DbSkip()
            Loop
         EndIf

         DbSelectArea("SB1")
         DbSeek( xFilial("SB1") + SD2->D2_COD )

         xCalc  := Round( ( SD2->D2_PRCVEN * 100 ) / SD2->D2_PRUNIT, 2 )
         nDESC  := Iif( xCalc <= 0, 0, 100 - xCalc )
         nComis := 0

         DbSelectArea("SZ4")
         DbSeek( xFilial("SZ4") + SA3->A3_CLTBCOM )
       
         Do While !Eof() .AND. SZ4->Z4_CLCOD == SA3->A3_CLTBCOM
            If Z4_CLMAX >= nDESC
               nComis := SZ4->Z4_CLCOM
               Exit
            EndIf
            DbSkip()
         EndDo

         DbSelectArea("_NOTAS")
         DbAppend()

         Replace TMP_EMIS With SF2->F2_EMISSAO
         Replace TMP_NF   With SF2->F2_DOC
         Replace TMP_PARC With SE1->E1_PARCELA
         Replace TMP_SERI With _cSERIE
         Replace TMP_PROD With SD2->D2_COD
         Replace TMP_VRTB With SD2->D2_PRUNIT
         Replace TMP_UNIT With SD2->D2_PRCVEN
         Replace TMP_QTDE With SD2->D2_QUANT
         Replace TMP_QDEV With SD2->D2_QTDEDEV
         Replace TMP_DESC With nDesc
         Replace TMP_COM  With nComis

         xLIQUIDO := Round( ( TMP_QTDE - TMP_QDEV ) * TMP_UNIT , 2 )
         xCOMISSAO:= Round( ( xLIQUIDO * _NOTAS->TMP_COM ) / 100, 2 )
         nVrCom   := nVrCom + xCOMISSAO
         xDADOS   := .T.

         DbSelectArea("SD2")
         DbSkip()

      EndDo

   EndIf

   If xDADOS == .T.

      DbSelectArea("_RECEB")
      DbAppend()

      Replace TMP_DTPG With SE1->E1_BAIXA            // Data Pagto
      Replace TMP_PREF With SE1->E1_PREFIXO          // Prefixo
      Replace TMP_DUPL With SE1->E1_NUM              // Numero Titulo
      Replace TMP_PARC With SE1->E1_PARCELA          // Parcela
      Replace TMP_TIPO With SE1->E1_TIPO             // Tipo do T¡tulo
      ** Repl TMP_TPAR With                          // Total parcelas
      Replace TMP_VAL  With SE1->E1_VALOR            // Valor t¡tulo
      Replace TMP_PAGO With _nPAGO                   // Valor Pago
      Replace TMP_VRNF With Iif( _cSERIE=="SAI", _FAT1->TOTAL_NF, SF2->F2_VALBRUT )  // Valor NF
      Replace TMP_CLI  With SA1->A1_COD              // Cliente
      Replace TMP_LOJA With SA1->A1_LOJA             // Loja Cliente
      Replace TMP_COMI With nVrCom                   // Valor ComissÆo p/ o t¡t.
      Replace TMP_VEND With SA3->A3_COD              // Vendedor
      Replace TMP_NOTA With SE1->E1_NUM              // Nota fiscal do titulo
      Replace TMP_SERI With _cSERIE                  // Serie da Nota fiscal

   EndIf

   DbSelectArea("SE1")
   DbSkip()

EndDo

DbSelectArea("_NOTAS")
DbCommit()

DbSelectArea("_RECEB")
DbCommit()

RetIndex("SE1")                     // Restaura os ¡ndices padrÆo do SE1

// **** Prepara os arquivos de trabalho para impressÆo

DbSelectArea("_NOTAS")
IndRegua( "_NOTAS", "_NOTAS", "TMP_NF+TMP_SERI+TMP_PROD", , ,"Indexando NFs selecionadas..." )

DbSelectArea("_RECEB")
IndRegua( "_RECEB", "_RECEB", "TMP_VEND+DTOS(TMP_DTPG)+TMP_DUPL+TMP_PARC+TMP_TIPO", , ,"Indexando T¡tulos selecionados..." )

SetRegua( LastRec() )
DbGoTop()

@ 00,00 PSAY AvalImp( nLimite )

aTOTGER := { 0, 0, 0 }      // Vr. T¡tulo, Vr. Pago, ComissÆo
nLin := 1
nPag := 1

Do While !Eof() .AND. !lAbortPrint

   aTOTVEND := { 0, 0, 0 }
   xVEND    := _RECEB->TMP_VEND
   nLin     := 1
   nPag     := Iif( nPag==1, nPag, nPag + 1 )

   DbSelectArea("SA3")
   DbSeek( xFilial("SA3") + _RECEB->TMP_VEND )

   DbSelectArea("_RECEB")

   Do While !Eof() .AND. _RECEB->TMP_VEND == xVEND

      IncRegua()

      // *** Atualiza‡Æo do n§ de parcelas e do valor correto da comissÆo
      // *** ComissÆo = ComissÆo sobre a NF dividido pelo N§ de parcelas do titulo

      nParcelas := 0

      DbSelectArea("SE1")
      DbSeek( xFilial("SE1") + _RECEB->TMP_PREF + _RECEB->TMP_DUPL )

      Do While !Eof() .AND. SE1->E1_NUM==_RECEB->TMP_DUPL .AND. SE1->E1_PREFIXO==_RECEB->TMP_PREF
         If SE1->E1_TIPO == _RECEB->TMP_TIPO
            nParcelas := nParcelas + 1
         EndIf
         DbSkip()
      EndDo

      nParcelas := Iif( Str(nParcelas,1) >= _RECEB->TMP_PARC, nParcelas, Val(_RECEB->TMP_PARC) )

      DbSelectArea("_RECEB")
      Replace TMP_TPAR With Str(nParcelas,1)
      Replace TMP_COMI With Round( TMP_COMI / nParcelas, 2 )

      // ***
      // ***

      DbSelectArea("_NOTAS")
      If !DbSeek( _RECEB->TMP_NOTA+_RECEB->TMP_SERI )
         MsgBox( "Nao Encontrei " + _RECEB->TMP_NOTA+_RECEB->TMP_SERI )
         DbSelectArea("_RECEB")
         DbSkip()
         Loop
      EndIf

      DbSelectArea("SA1")
      DbSeek( xFilial("SA1") + _RECEB->TMP_CLI + _RECEB->TMP_LOJA )

      CABCLREL06()
      If nLin == 8
         @ nLin , 00  PSAY "Vendedor: " + SA3->A3_COD + " - " + SA3->A3_NOME
         nLin := nLin + 2
      EndIf

      DbSelectArea("_RECEB")

      @ nLin,  00 PSAY TMP_DTPG
      @ nLin,  11 PSAY TMP_PREF + " " + TMP_DUPL + " " + TMP_PARC + "/" + TMP_TPAR
      @ nLin,  27 PSAY TMP_VAL                   Picture"9,999,999.99"
      // @ nLin,  41 PSAY TMP_PAGO                  Picture"9,999,999.99"
      @ nLin,  55 PSAY TMP_VRNF                  Picture"9,999,999.99"
      @ nLin,  69 PSAY TMP_CLI + " " + TMP_LOJA
      @ nLin,  80 PSAY Subst( SA1->A1_NOME, 1, 35 )

      TMP_COMI1 := TMP_COMI

      If SA1->A1_CLCDSAI =="99999"
         TMP_COMI1 := 0
      ENDIF
      @ nLin, 118 PSAY TMP_COMI1                  Picture"9,999,999.99"

      aTOTGER[1] := aTOTGER[1] + TMP_VAL
      aTOTGER[2] := aTOTGER[2] + TMP_PAGO
      aTOTGER[3] := aTOTGER[3] + TMP_COMI1

      aTOTVEND[1] := aTOTVEND[1] + TMP_VAL
      aTOTVEND[2] := aTOTVEND[2] + TMP_PAGO
      aTOTVEND[3] := aTOTVEND[3] + TMP_COMI1

      nLin := nLin + 2             
//    @ nLin,  00 PSAY "0         1         2    2    3    3    4    4    5    5    6    6    7    7    8    8    9        10       890       VR. COMISSAO"
//    @ nLin,  00 PSAY "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890       VR. COMISSAO"
//    @ nLin,  00 PSAY "NOTA FISCAL:  EMISSAO   NOTA  SERIE  ITEM         PRECO LISTA      VR. NOTA          QTDE    % DESC     % COMIS       VR. COMISSAO"
      @ nLin,  00 PSAY "EMISSAO   NOTA  SERIE  ITEM         PRECO LISTA      VR. NOTA          QTDE      QT.DEVOL    % DESC     % COMIS       VR. COMISSAO"
      nLin := nLin + 1

      DbSelectArea("_NOTAS")
      xDADOS := .F.

      Do While !Eof() .AND. _NOTAS->TMP_NF == _RECEB->TMP_NOTA .AND. _NOTAS->TMP_SERI == _RECEB->TMP_SERI

         If _NOTAS->TMP_PARC #_RECEB->TMP_PARC
            DbSkip()
            Loop
         EndIf

         CABCLREL06()
         If nLin == 8
            @ nLin , 00  PSAY "Vendedor: " + SA3->A3_COD + " - " + SA3->A3_NOME
            nLin := nLin + 2
         EndIf

         xLIQUIDO := ( ( TMP_QTDE - TMP_QDEV ) * TMP_UNIT )
         xCOMISSAO:= Round( ( xLIQUIDO * TMP_COM ) / 100, 2 )

         If xDADOS == .F.
            @ nLin,  00 PSAY TMP_EMIS
            @ nLin,  10 PSAY TMP_NF
            @ nLin,  18 PSAY TMP_SERI
         EndIf

         @ nLIn,  23 PSAY Trim( TMP_PROD )  Picture"@R 99.999.999"
         @ nLin,  35 PSAY TMP_VRTB          Picture"@E 9,999,999.99"
         @ nLin,  49 PSAY TMP_UNIT          Picture"@E 9,999,999.99"
         @ nLin,  63 PSAY TMP_QTDE          Picture"@E 9,999,999.99"
         @ nLin,  77 PSAY TMP_QDEV          Picture"@E 9,999,999.99"
         @ nLin,  91 PSAY TMP_DESC          Picture"@E 9,999.99"
         @ nLin, 105 PSAY TMP_COM           Picture"@E 999.99"
         @ nLin, 118 PSAY xCOMISSAO         Picture"@E 9,999,999.99"

         xDADOS := .T.
         nLin   := nLin + 1

         DbSkip()    

      EndDo

      @ nLin,  00 PSAY Replic("- ",66)
      nLin := nLin + 1
      DbSelectArea("_RECEB")
      DbSkip()

   EndDo

   nLin := nLin + 1
   @ nLin,  00 PSAY "Total Tits.Receb. do Vendedor ->"
   @ nLin,  35 PSAY aTOTVEND[1]                 Picture"@E 9,999,999.99"
   @ nLin,  85 PSAY "Total da Comissao do Vendedor ->"
   @ nLin, 118 PSAY aTOTVEND[3]                 Picture"@E 9,999,999.99"

EndDo

nLin := 1
CABCLREL06()
nLin := 10
@ nLin,  00 PSAY "***** TOTALIZACAO DO RELATORIO ******"
nLin := nLin + 2  
@ nLin,  00 PSAY "Total de Titulos Recebidos    Total Geral das Comissoes a Pagar"
nLin := nLin + 1
@ nLin,  00 PSAY "--------------------------    ---------------------------------"
nLin := nLin + 2
@ nLin,  12 PSAY aTOTGER[1]                 Picture"@E 9,999,999.99"
@ nLin,  50 PSAY aTOTGER[3]                 Picture"@E 9,999,999.99"
nLin := nLin + 1
@ nLin,  00 PSAY "--------------------------    ---------------------------------"

@ 60, 00 PSAY Replic( "*", 132 )
@ 61, 00 PSAY "COEL Controles Eletricos Ltda"
@ 61, 30 PSAY PADC( "FIM", 70 )
@ 61,104 PSAY "Departamento de Informatica"
@ 62, 00 PSAY Replic( "*", 132 )

@00,00 PSAY ""
SetPrc( 0, 0 )

DbSelectArea("SE1")
RetIndex("SE1")

aFecha := { "_RECEB", "_NOTAS", "_FAT1", "_FAT2", "_PROD" } ; aAbre := {}        // Eliminacao do arquivo de trabalho
CloseOpen( aFecha, aAbre )

// FERASE( _cTemp1 + ".dbf" )
FERASE( _cTemp1 + ".mem" )
FERASE( _cTemp1 + ".idx" )

// FERASE( _cTemp2 + ".dbf" )
FERASE( _cTemp2 + ".mem" )
FERASE( _cTemp2 + ".idx" )

FERASE( "_FAT1.IDX" )
FERASE( "_FAT2.IDX" )
FERASE( "_PROD.IDX" )

If aReturn[5] == 1
   Set Printer TO
   ourspool(wnrel)
Endif

MS_FLUSH()
Return

// Fim do Programa

/*/
  ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
  ³ FUNCAO   ³CABCLREL06³ Autor ³ Alberto N. Gama Junior³ Data ³ 30/08/99 ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
  ³Descri‡Æo ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ OBS      ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÙ                                                            ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function CABCLREL06
Static Function CABCLREL06()

While .T.
   If nLin == 1
      @ nLin , 00  PSAY Replicate( "*", 132 )
      @ 02   , 00  PSAY "Emissao: "+DtoC(Date())
      @ 02   , 23  PSAY PADC("COMISSOES A PAGAR POR VENDEDOR - CALCULO PELO RECEBIMENTO - PADRAO", 90)
      @ 02   ,118  PSAY "Hora: " + Time()
      @ 03   , 00  PSAY "Programa: CFAT09R"
      @ 04   , 00  PSAY "T¡tulos Recebidos do dia  "+DTOC(mv_par01)+"  ate'o Dia "+DTOC(mv_par02) +" - Do Repres. "+mv_par03+"  ate'o Repres. "+mv_par04
      @ 04   ,123  PSAY "Pag : " + Str( nPag, 3 )
      @ 05   , 00  PSAY Replicate( "*", 132 )
      @ 06   , 00  PSAY "DATA PGTO  PREF.  TIT PARC    VALOR TIT.                   VALOR NF  CLIENTE    NOME                                      COMISSAO"
      @ 07   , 00  PSAY Replicate( "-", 132 )
      nLin := 8
   ElseIf nLin > 59
      nLin := 1
      nPag := nPag + 1
      Loop
   EndIf
   Exit
EndDo

Return
*****************************************************************************
*****************************************************************************
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function _CriaTemp
Static Function _CriaTemp()

// **** Cria‡Æo de arquivos de trabalho para manipula‡Æo de dados

aEstru1 := { {"TMP_EMIS","D",8,0} , {"TMP_NF","C",6,0}   , {"TMP_SERI","C",3,0}, {"TMP_PROD","C",15,0},;
             {"TMP_VRTB","N",12,2}, {"TMP_UNIT","N",12,2}, {"TMP_QTDE","N",12,2}, {"TMP_QDEV","N",12,2},;
             {"TMP_DESC","N",7,2} , {"TMP_COM","N",6,2}, {"TMP_PARC","C",1,0 } }

aEstru2 := { {"TMP_DTPG","D",8,0} , {"TMP_PREF","C",3,0} , {"TMP_DUPL","C",6,0} ,;
             {"TMP_PARC","C",1,0} , {"TMP_TPAR","C",1,0} , {"TMP_TIPO","C",3,0} ,{"TMP_VAL","N",12,2} ,;
             {"TMP_PAGO","N",12,2}, {"TMP_VRNF","N",12,2}, {"TMP_CLI","C",6,0}  ,;
             {"TMP_LOJA","C",2,0} , {"TMP_COMI","N",12,2}, {"TMP_VEND","C",6,0} ,;
             {"TMP_NOTA","C",6,0} , {"TMP_SERI","C",3,0} }

_cTemp1 := CriaTrab( aEstru1, .T. )      // Dados das Notas Fiscais
_cTemp2 := CriaTrab( aEstru2, .T. )      // Dados dos T¡tulos pagos
DbUseArea( .T., , _cTemp1, "_NOTAS", .F., .F. )
DbUseArea( .T., , _cTemp2, "_RECEB", .F., .F. )

// ***
// *** Abre os arquivos do SAI
// ***

DbUseArea( .T., , "FATB001", "_FAT1", .T., .T. )
IndRegua( "_FAT1", "_FAT1", "STRZERO(NF,6)", , ,"Indexando Notas Fiscais do SAI..." )

DbUseArea( .T., , "FATB002", "_FAT2", .F., .F. )
IndRegua( "_FAT2", "_FAT2", "STRZERO(NF,6)", , ,"Indexando Itens NF do Sai..." )

DbUseArea( .T., , "ENGB001", "_PROD", .F., .F. )
IndRegua( "_PROD", "_PROD", "CODIGO", , ,"Indexando Produtos do Sai..." )

Return
*****************************************************************************
*****************************************************************************
