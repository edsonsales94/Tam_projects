#include "rwmake.ch"        

User Function Cfat05r() 

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,CPERG,LCONTINUA,NLIN,WNREL")
SetPrvt("CSTRING,NLASTKEY,LABORTPRINT,ATOTAIS,NPAG,_DINICIAL")
SetPrvt("NITENSOK1,NVALPROD,NDESCCLI,NACRESFIN,NVALCLI,NVALLIVRE")
SetPrvt("NDESCMAIS,NVALMAIS,CCODSUB,CDESSUB,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CLREL02  ³ Autor ³ Alberto N. Gama Junior³ Data ³ 24/08/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio descontos concedidos no faturamento              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para COEL Controles Eletricos Ltda              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBS       ³ Uso da Diretoria                                           ³±±
±±³          ³ O Grupo de perguntas "CLRL01" ‚ compartilhado com os       ³±±
±±³          ³ rdmakes CLREL01.PRX e CLREL03.PRX                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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

nTamanho  := "G" 
nLimite   := 220
cTitulo   := PADC( "Faturamento / Descontos", 74 )
cDesc1    := PADC( "Este programa emitir  relat¢rio de faturamento com o desconto", 74 )
cDesc2    := PADC( "a mais concedido pela COEL em cada item.", 74 )
cDesc3    := PADC( "", 74 )
aReturn   := { "Especial", 1, "Diretoria COEL", 1, 1, 1, "", 1 }
nomeprog  := "CLREL02" 
cPerg     := "CLRL01"
lContinua := .T.
nLin      := 0
wnrel     := "CFAT05R"
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
       RptStatus({|| IMPCLREL02()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>        RptStatus({|| Execute(IMPCLREL02)})
#ELSE
       IMPCLREL02()
#ENDIF

Return

/*/
  ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
  ³ FUNCAO   ³IMPCLREL02³ Autor ³ Alberto N. Gama Junior³ Data ³ 24/08/99 ³
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

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function IMPCLREL02
Static Function IMPCLREL02()

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

DbSelectArea("SE4")                 // Condi‡äes de Pagto
DbSetOrder(1)                       // Codigo

DbSelectArea("SZG")                 // Cadastro de Subgrupos
DbSetOrder(1)                       // Codigo

DbSelectArea("SF4")                 // TES
DbSetOrder(1)                       // Numero Pedido + Item + Produto

DbSelectArea("SD2")                 // Itens das NFs
DbSetOrder(3)                       // Nota + Serie + Cliente + Loja + Prod

DbSelectArea("DA1")                 // Tabela de precos
DbSetOrder(2)                       // Produto

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

SetRegua( (mv_par02-_dInicial+1)*35 )
@ 00, 00 PSAY AvalImp( nLimite )

Do While !Eof() .AND. SF2->F2_EMISSAO <= mv_par02 .AND. !lAbortPrint

   IncRegua()

   If SF2->F2_CLIENTE < mv_par03 .OR. SF2->F2_CLIENTE > mv_par04
      DbSkip()
      Loop
   EndIf

   If SF2->F2_VEND1 < mv_par05 .OR. SF2->F2_VEND1 > mv_par06
      DbSkip()
      Loop
   EndIf

   DbSelectArea("SD2")
   If !( DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE ) )
      DbSelectArea("SF2")
      DbSkip()
      Loop
   EndIf

   DbSelectArea("SA1")
   DbSeek( xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA )

   DbSelectArea("SA3")
   DbSeek( xFilial("SA3") + SA1->A1_VEND )

   DbSelectArea("SZ2")
   DbSeek( xFilial("SZ2") + SA1->A1_CLCLASI )

   DbSelectArea("SE4")
   DbSeek( xFilial("SE4") + SF2->F2_COND )

   nItensOK1 := 0

   Do While !Eof() .AND. SD2->D2_DOC == SF2->F2_DOC

      If !SD2->D2_TES $mv_par07
         DbSkip()
         Loop
      EndIf

      DbSelectArea("SB1")
      DbSeek( xFilial("SB1") + SD2->D2_COD )

      DbSelectArea("SB5")
      DbSeek( xFilial("SB5") + SB1->B1_COD )  
      
      DbSelectArea("DA1")
      DbSeek( xFilial("DA1") + SB1->B1_COD ) 

      //nValProd  := SD2->D2_PRUNIT             // Valor de Tabela do Produto
      nValProd  := DA1->DA1_PRCVEN             // Valor de Tabela do Produto
      nDescCli  := SZ2->Z2_CLPDES             // % desconto do Cliente
      nAcresFin := SE4->E4_ACRSFIN            // % Fator acresc. financeiro

      // **** Valor item c/ o desc. do Cliente
      nValCli   := Iif( nDescCli==0, nValProd, nValProd-Round(((nValProd*nDescCli)/100),2))

      // **** Valor unit. s/ acresc. financ.
      nValLivre := SD2->D2_PRCVEN - Round( ( SD2->D2_PRCVEN * nAcresFin ) / 100, 2 )

      // **** % desconto a mais concedido
      nDescMais := Iif( nValLivre >= nValCli, 0, Round(100-((nValLivre*100)/nValCli),2))

      // **** Valor desconto a mais x Qtde
      nValMais  := Iif( nDescMais <= 0, 0, Round( (( nDescMais * nValCli ) / 100 ) * SD2->D2_QUANT, 2 ))

      CABCLREL02()

      //If nItensOK1 == 0
         @ nLin,  00 PSAY DTOC( SF2->F2_EMISSAO )
         @ nLin,  11 PSAY SF2->F2_DOC
         @ nLin,  19 PSAY SF2->F2_CLIENTE
         @ nLin,  27 PSAY Subst(SA1->A1_NOME,1,21)
      //EndIf
      @ nLin,  50 PSAY AllTrim( SB1->B1_COD )  Picture"@R 99.999.999"
      cCODSUB := SB1->B1_GRUPO
      cDesSub := Posicione("SZG",1,xFilial("SZG")+cCODSUB,"ZG_DESC")
      @ nLin,  62 PSAY Subst(cDesSub,1,13)
      @ nLin,  76 PSAY nValProd                Picture"@E 9,999,999.99"
      @ nLin,  96 PSAY nDescCli                Picture"@E 999.99"
      @ nLin, 103 PSAY nValCli                 Picture"@E 9,999,999.99"
      @ nLin, 117 PSAY nValLivre               Picture"@E 9,999,999.99"
      @ nLin, 131 PSAY SD2->D2_QUANT           Picture"@E 9,999,999.99"
      @ nLin, 145 PSAY nDescMais               Picture"@E 9,999,999.99"
      @ nLin, 160 PSAY nValMais                Picture"@E 9,999,999.99"
      @ nLin, 176 PSAY Iif( nItensOK1 == 0, SUBS(SE4->E4_DESCRI,1,15),SPACE(15))
      @ nLin, 193 PSAY Iif( SB5->B5_PRV7 < nValLivre, "", "Excedeu Prc Min" )

      aTOTAIS[1] := aTOTAIS[1] + ( nValLivre * SD2->D2_QUANT )
      aTOTAIS[2] := aTOTAIS[2] + nValMais
      nLin       := nLin + 1
      nItensOK1  := nItensOK1 + 1

      DbSelectArea("SD2")
      DbSkip()

   EndDo

   If nItensOK1 > 0
      @ nLin, 00 PSAY Replicate("- ", 114 )
      nLin := nLin + 1
   EndIf

   DbSelectArea("SF2")
   DbSkip()

End

nLin := nLin + 1
CABCLREL02()

@ nLin ,  99  PSAY "Total Faturado :"
@ nLin , 117  PSAY aTOTAIS[1]         Picture"@E 9,999,999.99"  

@ nLin , 142  PSAY "Total Descontos :"
@ nLin , 160  PSAY aTOTAIS[2]         Picture"@E 9,999,999.99"
 
nLin := 60
@ nLin , 00 PSAY Replicate( "*", 228 )
@ 61   , 00 PSAY "COEL  Controles  Eletricos  Ltda"+Space(80)+ " FIM "+Space(82)+" Deparatamento de Informatica"
@ 62   , 00 PSAY Replicate( '*', 228 )
@ 00   , 00 PSAY ""
SetPrc(0,0)

DbSelectArea("SF2")
RetIndex("SF2")

If aReturn[5] == 1
   Set Printer TO
   ourspool(wnrel)
Endif

MS_FLUSH()
Return

// Fim do Programa


/*/
  ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
  ³ FUNCAO   ³CABCLREL02³ Autor ³ Alberto N. Gama Junior³ Data ³ 23/08/99 ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
  ³Descri‡Æo ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ OBS      ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÙ                                                            ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function CABCLREL02
Static Function CABCLREL02()

While .T.
   If nLin == 1
      @ nLin , 00  PSAY Replicate( "*", 228 )
      @ 02   , 00  PSAY "Emissao: "+DtoC(Date())
      @ 02   , 20  PSAY PADC("RELATORIO  DE  DESCONTOS  CONCEDIDOS  -  FATURAMENTO DE PRODUTOS COEL",188)
      @ 02   ,214  PSAY "Hora: " + Time()
      @ 03   , 00  PSAY "PROGRAMA: CFAT05R"
      @ 04   , 00  PSAY "Notas Fiscais Emitidas  No  Dia  "+DTOC(mv_par01)+"  Ate' o  Dia  "+DTOC(mv_par02) +"  -  Do  Cliente  Cod. "+mv_par03+"  Ate' o  Cliente  Cod. "+mv_par04+"  Do Repres. "+mv_par05+"  Ate' o Repres. "+mv_par06
      @ 04   ,219  PSAY "Pag : " + Str( nPag, 3 )
      @ 05   , 00  PSAY Replicate( "*", 228 )
      @ 06   , 00  PSAY "DATA EMS   N.FISC  CLIENTE                        ITEM        SUB-GRUPO         VR.LISTA     % DSC.CLI   VR. C/ DSC     VR. FATUR          QTDE    % DSC.MAIS   VR.DSC.TOTAL    PRAZO PAGTO      OBS"
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
//teste