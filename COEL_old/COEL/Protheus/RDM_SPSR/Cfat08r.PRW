#include "rwmake.ch"     

User Function Cfat08r()

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,CPERG,LCONTINUA,NLIN,WNREL")
SetPrvt("CSTRING,NLASTKEY,LABORTPRINT,XOLDAREA,XOLDPOS,XOLDORD")
SetPrvt("AESTRUT,XARQUIVO,_DINICIAL,XCALC,NDESC,NCOMIS")
SetPrvt("ATOTGER,NPAG,ATOTVEND,XVEND,XNFISC,ATOTNF")
SetPrvt("NDADOS,XLIQUIDO,XCOMISSAO,AFECHA,AABRE,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT08R  ³ Autor ³ Alberto N. Gama Junior³ Data ³ 27/08/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de comissäes dos vendedores                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para COEL Controles Eletricos Ltda              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBS       ³ O Relat¢rio possui 2 modelos a definir no mv_par06:        ³±±
±±³          ³ 1 - Normal: o c lculo ‚ feito de acordo com a tabela       ³±±
±±³          ³ 2 - Caso o Cliente Seja REVENDA, o c lculo ser  50% da     ³±±
±±³          ³     tabela                                                 ³±±
±±³          ³     Caso o Cliente Seja o pr¢prio Vendedor, o c lculo da   ³±±
±±³          ³     comissÆo ser  0 ( zero )                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Variaveis utilizadas para parametros                         ³
  ³ mv_par01                Data EmissÆo de                      ³
  ³ mv_par02                Data EmissÆo at‚                     ³ 
  ³ mv_par03                Cod. Representante de                ³ 
  ³ mv_par04                Cod. Representante at‚               ³ 
  ³ mv_par05                Modelo: 1 - Padrao / 2 - Novo        ³ 
  ³ mv_par06                TES Venda Produtos                   ³ 
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

nTamanho  := "P" 
nLimite   := 132
cTitulo   := PADC( "Comissäes s/ Faturamento", 74 )
cDesc1    := PADC( "Este programa emitir  relat¢rio de comissäes a pagar aos represen-", 74 )
cDesc2    := PADC( "tantes. Considera notas fiscais do per¡odo.", 74 )
cDesc3    := PADC( "", 74 )
aReturn   := { "Especial", 1, "Gerencia COEL", 1, 1, 1, "", 1 }
nomeprog  := "CLREL05" 
cPerg     := "CLRL05"
lContinua := .T.
nLin      := 0
wnrel     := "Comis01"
cString   := "SF2"
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
       RptStatus({|| IMPCLREL05()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>        RptStatus({|| Execute(IMPCLREL05)})
#ELSE
       IMPCLREL05()
#ENDIF

Return

/*/
  ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
  ³ FUNCAO   ³IMPCLREL05³ Autor ³ Alberto N. Gama Junior³ Data ³ 23/08/99 ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
  ³Descri‡Æo ³ Manipula‡Æo de dados e impressÆo do relat¢rio              ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ OBS      ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÙ                                                            ³
  ³                                                                       ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function IMPCLREL05
Static Function IMPCLREL05()

xOLDAREA := Alias()
xOLDPOS  := Recno()
xOLDORD  := IndexOrd()

// **** Cria‡Æo de um arquivo de trabalho para manipula‡Æo de dados

aEstrut := { {"TMP_EMIS","D",8,0},  {"TMP_NF","C",6,0},    {"TMP_CLI","C",6,0},;
             {"TMP_LOJA","C",2,0},  {"TMP_NOME","C",20,0}, {"TMP_PROD","C",15,0},;
             {"TMP_VRTB","N",12,2}, {"TMP_UNIT","N",12,2}, {"TMP_QTDE","N",12,2},;
             {"TMP_DESC","N",7,2},  {"TMP_COM","N",6,2},   {"TMP_VEND","C",6,0},;
             {"TMP_VRBR","N",12,2} } 
xArquivo := CriaTrab( aEstrut, .T. )

// **** Sele‡Æo e ordena‡Æo dos arquivos utilizados

DbUseArea( .T., , xArquivo, "COM", .T., .F. )

DbSelectArea("SB1")                 // Produtos
DbSetOrder(1)                       // Codigo

DbSelectArea("SZ4")                 // Tabela de Comissäes dos Vendedores
DbSetOrder(1)                       // Codigo + Desconto Maximo

DbSelectArea("SA1")                 // Clientes
DbSetOrder(1)                       // Codigo

DbSelectArea("SA3")                 // Vendedores / Representantes
DbSetOrder(1)                       // Codigo

DbSelectArea("SF4")                 // TES
DbSetOrder(1)                       // Numero Pedido + Item + Produto

DbSelectArea("SD2")                 // Itens das NFs
DbSetOrder(3)                       // Nota + Serie + Cliente + Loja + Prod

DbSelectArea("SF2")                 // Cabe‡alho de Notas Fiscais Sa¡da
//DbSetOrder(6)                       // Emissao + Nota + Serie
dbOrderNickName("SF26")

_dInicial := mv_par01

If !DbSeek( xFilial("SF2") + DToS(_dInicial) )
   Do While _dInicial <= mv_par02
      _dInicial := _dInicial + 1
      If DbSeek( xFilial("SF2") + DToS(_dInicial) )
         Exit
      EndIf
   EndDo
EndIf

SetRegua( (mv_par02-_dInicial+1)*25 )

Do While !Eof() .AND. SF2->F2_EMISSAO <= mv_par02 .AND. !lAbortPrint

   IncRegua()

   DbSelectArea("SA1")
   DbSeek( xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA )

   If SA1->A1_VEND < mv_par03 .OR. SA1->A1_VEND > mv_par04
      DbSelectArea("SF2")
      DbSkip()
      Loop
   EndIf

   DbSelectArea("SA3")
   DbSeek( xFilial("SA3") + SA1->A1_VEND )

   DbSelectArea("SD2")
   If !DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE )
      DbSelectArea("SF2")
      DbSkip()
      Loop
   EndIf

   Do While !Eof() .AND. SD2->D2_DOC == SF2->F2_DOC
      
      If !SD2->D2_TES $mv_par06
         DbSkip()
         Loop
      EndIf

      DbSelectArea("SB1")
      DbSeek( xFilial("SB1") + SD2->D2_COD )

      DbSelectArea("SB5")
      DbSeek( xFilial("SB5") + SB1->B1_COD )

      xCalc  := Round( ( SD2->D2_PRCVEN * 100 ) / SD2->D2_PRUNIT, 2 )
      nDESC  := Iif( xCalc <= 0, 0, 100 - xCalc )
      nCOMIS := 0

      DbSelectArea("SZ4")
      If DbSeek( xFilial("SZ4") + SA3->A3_CLTBCOM )
         Do While !Eof() .AND. SZ4->Z4_CLCOD == SA3->A3_CLTBCOM
            If Z4_CLMAX >= nDESC
               nCOMIS := SZ4->Z4_CLCOM
               Exit
            EndIf
            DbSkip()
         EndDo
      EndIf
            
      If mv_par05 == 2
         If SA1->A1_CLCDSAI =="99999"
            nCOMIS := 0    
//         ElseIf Subst( SA1->A1_CLCLASI, 1, 1 ) == "R"
//            nCOMIS := Round( nCOMIS / 2, 2 )
         EndIf
      EndIf

      DbSelectArea("COM")
      DbAppend()

      Replace TMP_EMIS With SF2->F2_EMISSAO               // Emissao NF
      Replace TMP_NF   With SF2->F2_DOC                   // Numero NF
      Replace TMP_CLI  With SA1->A1_COD                   // Cod. Cliente
      Replace TMP_LOJA With SA1->A1_LOJA                  // Loja
      Replace TMP_NOME With Subst( SA1->A1_NOME, 1, 20 )  // Nome Cliente
      Replace TMP_PROD With SD2->D2_COD                   // Produto
      Replace TMP_VRTB With SD2->D2_PRUNIT                // Preco Tabela
      Replace TMP_UNIT With SD2->D2_PRCVEN                // Preco Vendido
      Replace TMP_QTDE With SD2->D2_QUANT                 // Qtde
      Replace TMP_VEND With SA3->A3_COD                   // Vendedor
      Replace TMP_DESC With nDESC                         // Desconto no Produto
      Replace TMP_COM  With nCOMIS                        // Comissao %
      Replace TMP_VRBR With SF2->F2_VALBRUT               // Valor Bruto NF

      DbSelectArea("SD2")
      DbSkip()

   EndDo

   DbSelectArea("SF2")
   DbSkip()

EndDo

// **** Prepara o arquivo de trabalho para impressÆo

DbSelectArea("COM")
DbCommit()

IndRegua( "COM", xArquivo, "TMP_VEND+TMP_NF", , ,"Preparando Para Imprimir..." )
SetRegua( LastRec() )
DbGoTop()

aTOTGER  := { 0, 0, 0 }            // Bruto, Liquido, ComissÆo
nLin     := 1
nPag     := 1

Do While !Eof() .AND. !lAbortPrint

   aTOTVEND := { 0, 0, 0 }
   xVEND    := COM->TMP_VEND
   nLin     := 1
   nPag     := Iif( nPag==1, nPag, nPag + 1 )

   DbSelectArea("SA3")
   DbSeek( xFilial("SA3") + COM->TMP_VEND )

   DbSelectArea("COM")

   Do While !Eof() .AND. COM->TMP_VEND == xVEND

      IncRegua()

      xNFISC := COM->TMP_NF
      aTOTNF := { 0, 0, 0 }                        // Bruto, Liquido, ComissÆo
      nDADOS := 0

      aTOTGER[1]  := aTOTGER[1]  + COM->TMP_VRBR   // Total GERAL BRUTO
      aTOTVEND[1] := aTOTVEND[1] + COM->TMP_VRBR   // Total Vendedor BRUTO
      aTOTNF[1]   := COM->TMP_VRBR                 // Total da NF BRUTO

      Do While !Eof() .AND. COM->TMP_NF == xNFISC

         CABCLREL05()
         // **** Imprime codigo e nome do vendedor no cabe‡alho
         If nLin == 8
            @ 08   , 00  PSAY "Vendedor: " + SA3->A3_COD + " - " + SA3->A3_NOME
            nLin := 10
         EndIf

         xLIQUIDO := COM->TMP_UNIT * COM->TMP_QTDE
         xCOMISSAO:= Round( ( xLIQUIDO * COM->TMP_COM ) / 100, 2 )

         If nDADOS == 0
            @ nLin,  00 PSAY COM->TMP_EMIS
            @ nLin,  10 PSAY COM->TMP_NF
            @ nLin,  18 PSAY COM->TMP_CLI
            @ nLin,  25 PSAY COM->TMP_LOJA
            @ nLin,  28 PSAY SUBST( COM->TMP_NOME, 1, 15 )
         EndIf

         @ nLin,  45 PSAY Subst( COM->TMP_PROD, 1, 10 )  Picture"@R 99.999.999"
         @ nLin,  57 PSAY COM->TMP_VRTB                  Picture"@E 9,999,999.99"
         @ nLin,  70 PSAY COM->TMP_UNIT                  Picture"@E 9,999,999.99"
         @ nLin,  83 PSAY COM->TMP_QTDE                  Picture"@E 999,999"
         @ nLin,  91 PSAY xLIQUIDO                       Picture"@E 9,999,999.99"
         @ nLin, 106 PSAY COM->TMP_DESC                  Picture"@E 99.99"
         @ nLin, 114 PSAY COM->TMP_COM                   Picture"@E 99.99"
         @ nLin, 119 PSAY xCOMISSAO                      Picture"@E 9,999,999.99"

         aTOTVEND[2] := aTOTVEND[2] + xLIQUIDO
         aTOTVEND[3] := aTOTVEND[3] + xCOMISSAO

         aTOTNF[2]   := aTOTNF[2] + xLIQUIDO
         aTOTNF[3]   := aTOTNF[3] + xCOMISSAO

         aTOTGER[2]  := aTOTGER[2] + xLIQUIDO            // TOTAL GERAL
         aTOTGER[3]  := aTOTGER[3] + xCOMISSAO

         nDados := nDados + 1
         nLin   := nLin + 1

         DbSkip()

      EndDo

      @ nLin,  00 PSAY "Total da Nota Fiscal   -----> R$"
      @ nLin,  32 PSAY aTOTNF[1]             Picture"@E 9,999,999.99"
      @ nLin,  91 PSAY aTOTNF[2]             Picture"@E 9,999,999.99"
      @ nLin, 119 PSAY aTOTNF[3]             Picture"@E 9,999,999.99"
      nLin := nLin + 1
      @ nLin,  00 PSAY Replic( "- ", 66 )
      nLin := nLin + 1

   EndDo

   nLin := nLin + 1
   @ nLin,  00 PSAY "Total do Vendedor      -----> R$"
   @ nLin,  32 PSAY aTOTVEND[1]              Picture"@E 9,999,999.99"
   @ nLin,  91 PSAY aTOTVEND[2]              Picture"@E 9,999,999.99"
   @ nLin, 119 PSAY aTOTVEND[3]              Picture"@E 9,999,999.99"

EndDo

nLin := 59
CABCLREL05()
nLin := 10

@ nLin,  00 PSAY "TOTAL GERAL            -----> R$"
@ nLin,  32 PSAY aTOTGER[1]                  Picture"@E 9,999,999.99"
@ nLin,  91 PSAY aTOTGER[2]                  Picture"@E 9,999,999.99"
@ nLin, 119 PSAY aTOTGER[3]                  Picture"@E 9,999,999.99"

@ 60, 00 PSAY Replic( "*", 131 )
@ 61, 00 PSAY "COEL Controles Eletricos Ltda"
@ 61, 30 PSAY PADC( "FIM", 70 )
@ 61,104 PSAY "Departamento de Informatica"
@ 62, 00 PSAY Replic( "*", 131 )

@00,00 PSAY ""
SetPrc( 0, 0 )

DbSelectArea(xOLDAREA)
DbSetOrder(xOLDORD)
DbGoTo(xOLDPOS)

aFecha := { "COM" } ; aAbre := {}        // Eliminacao do arquivo de trabalho
CloseOpen( aFecha, aAbre )
FERASE( xArquivo+".dbf" )
FERASE( xArquivo+".idx" )
FERASE( xArquivo+".mem" )

If aReturn[5] == 1
   Set Printer TO
   ourspool(wnrel)
Endif

MS_FLUSH()
Return

// Fim do Programa


/*/
  ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
  ³ FUNCAO   ³CABCLREL05³ Autor ³ Alberto N. Gama Junior³ Data ³ 30/08/99 ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
  ³Descri‡Æo ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ OBS      ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÙ                                                            ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function CABCLREL05
Static Function CABCLREL05()

While .T.
   If nLin == 1
      @ nLin , 00  PSAY Replicate( "*", 131 )
      @ 02   , 00  PSAY "Emissao: "+DtoC(Date())
      @ 02   , 22  PSAY PADC("COMISSOES A PAGAR POR VENDEDOR - CALCULO PELO FATURAMENTO - "+Iif( mv_par05==1, "PADRAO", "MODELO 2"), 90)
      @ 02   ,117  PSAY "Hora: " + Time()
      @ 04   , 00  PSAY "Notas Fiscais emitidas no dia  "+DTOC(mv_par01)+"  ate'o Dia "+DTOC(mv_par02) +" - Do Repres. "+mv_par03+"  ate'o Repres. "+mv_par04
      @ 04   ,122  PSAY "Pag : " + Str( nPag, 3 )
      @ 05   , 00  PSAY Replicate( "*", 131 )
      @ 06   , 00  PSAY "EMISSAO   NF      CLIENTE / LOJA / NOME      PRODUTO         VR.LISTA   VR.VENDIDO    QTDE      LIQUIDO   %DESC  %COMIS    VR.COMIS"
      @ 07   , 00  PSAY Replicate( "-", 131 )
      nLin := 8
   ElseIf nLin > 58
      nLin := 1
      nPag := nPag + 1
      Loop
   EndIf
   Exit
EndDo

Return
