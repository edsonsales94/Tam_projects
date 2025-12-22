#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Cfat04r()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,CPERG,LCONTINUA,NLIN,WNREL")
SetPrvt("CSTRING,NLASTKEY,LABORTPRINT,ATOTAIS,NPAG,_DINICIAL")
SetPrvt("XEMBUTIDO,_NITENSOK,NVALPROD,NDESCCLI,NACRESFIN,NVALCLI")
SetPrvt("NVALLIVRE,NDESCMAIS,NVALMAIS,CCODSUB,CDESSUB,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CLREL01  ³ Autor ³ Alberto N. Gama Junior³ Data ³ 23/08/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio descontos concedidos nos pedidos de venda        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para COEL Controles Eletricos Ltda              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBS       ³ Uso da Diretoria                                           ³±±
±±³          ³ O grupo de perguntas "CLRL01" ‚ compartilhado com os       ³±±
±±³          ³ rdmakes CLREL02.PRX e CLREL03.PRX                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Variaveis utilizadas para parametros                         ³
  ³ mv_par01                Data EmissÆo de                      ³
  ³ mv_par02                Data EmissÆo at‚                     ³ 
  ³ mv_par03                Cod. Cliente de                      ³ 
  ³ mv_par04                Cod. Cliente at‚                     ³ 
  ³ mv_par05                Cod. Representante de                ³ 
  ³ mv_par06                Cod. Representante at‚               ³ 
  ³ mv_par07                TES Venda Produtos                   ³ 
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==> 	#DEFINE PSAY SAY
#ENDIF

nTamanho  := "G" 
nLimite   := 220
cTitulo   := PADC( "Pedidos / Descontos", 74 )
cDesc1    := PADC( "Este programa emitir  relat¢rio de pedidos de venda com o desconto", 74 )
cDesc2    := PADC( "a mais concedido pela COEL em cada item.", 74 )
cDesc3    := PADC( "", 74 )
aReturn   := { "Especial", 1, "Diretoria COEL", 1, 1, 1, "", 1 }
nomeprog  := "CLREL01" 
cPerg     := "CLRL01"
lContinua := .T.
nLin      := 0
wnrel     := "CFAT04R"
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
       RptStatus({|| IMPCLREL01()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>        RptStatus({|| Execute(IMPCLREL01)})
#ELSE
       IMPCLREL01()
#ENDIF

Return

/*/
  ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
  ³ FUNCAO   ³IMPCLREL01³ Autor ³ Alberto N. Gama Junior³ Data ³ 23/08/99 ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
  ³Descri‡Æo ³ Manipula‡Æo de dados e impressÆo do relat¢rio              ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ OBS      ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÙ                                                            ³
  ³                                                                       ³
  ³                                                                       ³
  ³                                                                       ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function IMPCLREL01
Static Function IMPCLREL01()

aTOTAIS  := { 0, 0 }
nLin     := 1
nPag     := 1

// **** Sele‡Æo e ordena‡Æo dos arquivos utilizados

DbSelectArea("SB1")                 // Produtos
DbSetOrder(1)                       // Codigo

DbSelectArea("SB5")                 // Dados Adicionais produtos
DbSetOrder(1)                       // Codigo

DbSelectArea("SA1")                 // Clientes
DbSetOrder(1)                       // Codigo

DbSelectArea("SA3")                 // Vendedores / Representantes
DbSetOrder(1)                       // Codigo

DbSelectArea("SZ2")                 // Classif. Descontos
DbSetOrder(1)                       // Codigo

DbSelectArea("SZG")                 // Cadastro de Subgrupos
DbSetOrder(1)                       // Codigo

DbSelectArea("SE4")                 // Condi‡äes de Pagto
DbSetOrder(1)                       // Codigo

DbSelectArea("SF4")                 // TES
DbSetOrder(1)                       // Numero Pedido + Item + Produto

DbSelectArea("SCJ")                 // Or‡amentos
DbSetOrder(1)                       // Codigo + Cod. Cliente + Loja

DbSelectArea("SC6")                 // Itens dos Pedidos
DbSetOrder(1)                       // Numero Pedido + Item + Produto

DbSelectArea("SC5")                 // Pedidos de Venda
DbSetOrder(2)                       // Data Emissao + Numero Pedido

_dInicial := mv_par01

If !( DbSeek( xFilial("SC5") + DToS(_dInicial) ) )
   Do While _dInicial <= mv_par02
      _dInicial := _dInicial + 1
      If DbSeek( xFilial("SC5") + DToS(_dInicial) )
         Exit
      EndIf
   EndDo
EndIf

SetRegua( (mv_par02-_dInicial+1)*35 )
@ 00, 00 PSAY AvalImp( nLimite )

Do While !Eof() .AND. SC5->C5_EMISSAO <= mv_par02 .AND. !lAbortPrint

   IncRegua()

   If SC5->C5_EMISSAO < mv_par01 .OR. SC5->C5_EMISSAO > mv_par02
      DbSkip()
      Loop
   EndIf

   If SC5->C5_CLIENTE < mv_par03 .OR. SC5->C5_CLIENTE > mv_par04
      DbSkip()
      Loop
   EndIf

   If SC5->C5_VEND1 < mv_par05 .OR. SC5->C5_VEND1 > mv_par06
      DbSkip()
      Loop
   EndIf

   DbSelectArea("SC6")
   If !DbSeek( xFilial("SC6") + SC5->C5_NUM )
      DbSelectArea("SC5")
      DbSkip()
      Loop
   EndIf

   DbSelectArea("SA1")
   DbSeek( xFilial("SA1")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI )

   DbSelectArea("SA3")
   DbSeek( xFilial("SA3") + SA1->A1_VEND )

   DbSelectArea("SZ2")
   DbSeek( xFilial("SZ2") + SA1->A1_CLCLASI )

   DbSelectArea("SE4")
   DbSeek( xFilial("SE4") + SC5->C5_CONDPAG )

   DbSelectArea("SCJ")
   xEMBUTIDO := Iif( !DbSeek(xFilial("SCJ")+SC6->C6_NUMORC), .F., Iif( CJ_CLTXFI=="S", .T., .F. ) )

   _nItensOK := 0
   DbSelectArea("SC6")

   Do While !Eof() .AND. SC6->C6_NUM == SC5->C5_NUM
      
      If !SC6->C6_TES $mv_par07
         DbSkip()
         Loop
      EndIf

      DbSelectArea("SB1")
      DbSeek( xFilial("SB1") + SC6->C6_PRODUTO )

      DbSelectArea("SB5")
      DbSeek( xFilial("SB5") + SB1->B1_COD )

      nValProd  := SC6->C6_PRUNIT           // Valor de Tabela do Produto
      nDescCli  := SZ2->Z2_CLPDES           // % desconto do Cliente
      nAcresFin := SE4->E4_ACRSFIN          // % Fator acresc. financeiro

      // **** Valor item c/ o desc. do Cliente
      nValCli   := Iif( nDescCli==0, nValProd, nValProd-Round(((nValProd*nDescCli)/100),2))

      // **** Valor unit. s/ acrescimo financeiro, caso embutido
      If xEMBUTIDO == .T.
         nValLivre := SC6->C6_PRCVEN - Round( ( SC6->C6_PRCVEN * nAcresFin ) / 100, 2 )
      Else
         nValLivre := SC6->C6_PRCVEN
      EndIf

      // **** % desconto a mais concedido
      nDescMais := Iif( nValLivre >= nValCli, 0, Round(100-((nValLivre*100)/nValCli),2))

      // **** Valor desconto a mais x Qtde
      nValMais  := Iif( nDescMais <= 0, 0, Round( (( nDescMais * nValCli ) / 100 ) * SC6->C6_QTDVEN, 2 ))

      CABCLREL01()

      If _nItensOK == 0
         @ nLin,  00 PSAY DTOC( SC5->C5_EMISSAO )
         @ nLin,  11 PSAY SC5->C5_NUM
         @ nLin,  19 PSAY SC5->C5_CLIENTE
         @ nLin,  27 PSAY Subst(SA1->A1_NOME,1,19)
      EndIf
      @ nLin,  50 PSAY AllTrim( SB1->B1_COD )  Picture"@R 99.999.999"
      cCODSUB := SB1->B1_GRUPO
      cDesSub := Posicione("SZG",1,xFilial("SZG")+cCODSUB,"ZG_DESC")
      @ nLin,  62 PSAY Subst(cDesSub,1,13)
      @ nLin,  76 PSAY nValProd                Picture"@E 9,999,999.99"
      @ nLin,  96 PSAY nDescCli                Picture"@E 999.99"
      @ nLin, 103 PSAY nValCli                 Picture"@E 9,999,999.99"
      @ nLin, 117 PSAY nValLivre               Picture"@E 9,999,999.99"
      @ nLin, 131 PSAY SC6->C6_QTDVEN          Picture"@E 9,999,999.99"
      @ nLin, 145 PSAY nDescMais               Picture"@E 9,999,999.99"
      @ nLin, 160 PSAY nValMais                Picture"@E 9,999,999.99"
      If _nItensOK == 0
         @ nLin, 176 PSAY SUBS(SE4->E4_DESCRI,1,15)
      EndIf
      @ nLin, 193 PSAY Iif( SC6->C6_PRUNIT >= nValLivre,"", "Excedeu Prc Min" )

      aTOTAIS[1] := aTOTAIS[1] + ( nValLivre * SC6->C6_QTDVEN )
      aTOTAIS[2] := aTOTAIS[2] + nValMais
      nLin       := nLin + 1
      _nItensOK   := _nItensOK + 1

      DbSelectArea("SC6")
      DbSkip()

   EndDo

   If _nItensOK > 0
      @ nLin, 00 PSAY Replicate("- ", 114 )
      nLin := nLin + 1
   EndIf

   DbSelectArea("SC5")
   DbSkip()

End

nLin := nLin + 1
CABCLREL01()

@ nLin , 100  PSAY "Total Pedidos :"
@ nLin , 117  PSAY aTOTAIS[1]         Picture"@E 9,999,999.99"  

@ nLin , 142  PSAY "Total Descontos :"
@ nLin , 160  PSAY aTOTAIS[2]         Picture"@E 9,999,999.99"
 
nLin := 60
@ nLin , 00 PSAY Replicate( "*", 228 )
@ 61   , 00 PSAY "COEL  Controles  Eletricos  Ltda"+Space(80)+ " FIM "+Space(82)+" Deparatamento de Informatica"
@ 62   , 00 PSAY Replicate( '*', 228 )
@ 00   , 00 PSAY ""
SetPrc(0,0)

DbSelectArea("SC5")
RetIndex("SC5")

If aReturn[5] == 1
   Set Printer TO
   ourspool(wnrel)
Endif

MS_FLUSH()
Return

// Fim do Programa


/*/
  ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
  ³ FUNCAO   ³          ³ Autor ³ Alberto N. Gama Junior³ Data ³ 23/08/99 ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
  ³Descri‡Æo ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ OBS      ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÙ                                                            ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function CABCLREL01
Static Function CABCLREL01()

While .T.
   If nLin == 1
      @ nLin , 00  PSAY Replicate( "*", 228 )
      @ 02   , 00  PSAY "Emissao: "+DtoC(Date())
      @ 02   , 20  PSAY PADC( "RELATORIO  DE  DESCONTOS  CONCEDIDOS  -  PEDIDOS  DE  VENDA", 188 )
      @ 02   ,214  PSAY "Hora: " + Time()
      @ 03   , 00  PSAY "PROGRAMA: CFAT04R"
      @ 04   , 00  PSAY "Pedidos  Emitidos  No  Dia  "+DTOC(mv_par01)+"  Ate' o  Dia  "+DTOC(mv_par02) +"  -  Do  Cliente  Cod. "+mv_par03+"  Ate' o  Cliente  Cod. "+mv_par04+"  Do Repres. "+mv_par05+"  Ate' o Repres. "+mv_par06
      @ 04   ,219  PSAY "Pag : " + Str( nPag, 3 )
      @ 05   , 00  PSAY Replicate( "*", 228 )
      @ 06   , 00  PSAY "DATA EMS   PEDIDO  CLIENTE                        ITEM        SUB-GRUPO         VR.LISTA     % DSC.CLI   VR. C/ DSC     VR.PEDIDO          QTDE    % DSC.MAIS   VR.DSC.TOTAL    PRAZO PAGTO      OBS"
      @ 07   , 00  PSAY Replicate( "-", 228 )
      nLin := 9
   ElseIf nLin > 58
      nLin := 1
      nPag := nPag + 1
      Loop
   EndIf
   Exit
EndDo

Return
