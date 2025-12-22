#include "rwmake.ch"   

User Function Cfat14r()

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,CPERG,LCONTINUA,NLIN,WNREL")
SetPrvt("CSTRING,NLASTKEY,LABORTPRINT,ATOTAIS,QTOTAIS,QTOTINT")
SetPrvt("VTOTINT,NOMEFAM,TPVENDA,TPVENDAD,TPVENDAF,TPVENDAE")
SetPrvt("TPVENDAI,QTVENDA,QTVENDAD,QTVENDAF,QTVENDAE,QTVENDAI")
SetPrvt("QTDVEND,NTPV,ATOTQ,ATOTG,NPAG,CODFAM")
SetPrvt("_DINICIAL,NITENSOK,NVALLIVRE,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT14R  ³ Autor ³ Adilson M. Takeshima  ³ Data ³ 14/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faturamento por Familia de produtos                        ³±±
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
cTitulo   := PADC( "Faturamento por Familia", 74 )
cDesc1    := PADC( "Este programa emitir  relat¢rio de faturamento por Itens e   ", 74 )
cDesc2    := PADC( "Familia de Produtos                     ", 74 )
cDesc3    := PADC( "", 74 )
aReturn   := { "Especial", 1, "Diretoria COEL", 1, 1, 1, "", 1 }
nomeprog  := "CFAT14R" 
cPerg     := "CLRL01"
lContinua := .T.
nLin      := 0
wnrel     := "FATFAMI"
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
  ³ FUNCAO   ³IMPCLREL02³ Autor ³ Adilson Takeshima     ³ Data ³ 14/07/00 ³
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
// *** TOTAIS VALOR - POR FAMILIA
aTOTAIS  := { 0, 0, 0, 0, 0, 0, 0 }
// *** TOTAIS QUANT - POR FAMILIA
qTOTAIS  := { 0, 0, 0, 0, 0, 0, 0 }
// *** TOTAIS QUANT - POR FAMILIA MERC.INTERNO
qtotint  := { 0, 0, 0, 0, 0, 0, 0 }
// *** TOTAIS VALOR - POR FAMILIA MERC.INTERNO
vtotint  := { 0, 0, 0, 0, 0, 0, 0 }
// *** DESCRICAO DAS 6 PRINCIPAIS FAMILIAS
nomefam  := { "", "", "", "", "", "" }
// *** VALOR DAS VENDAS POR FAMILIA E CFO (FAM1(DENTRO,FORA,EXTERIOR),FAM2(DENTRO,FORA,EXTERIOR),...
tpvenda  := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
// *** TOTAL DA VENDA - DENTRO DO ESTADO
tpvendad := 0
// *** TOTAL DA VENDA - FORA DO ESTADO
tpvendaf := 0
// *** TOTAL DA VENDA - EXTERIOR
tpvendae := 0
// *** TOTAL DA VENDA - MERCADO INTERNO (DENTRO+FORA)
tpvendai := 0
// *** QUANT.DAS VENDAS POR FAMILIA E CFO (FAM1(DENTRO,FORA,EXTERIOR),FAM2(DENTRO,FORA,EXTERIOR),...
qtvenda  := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
// *** QUANT DA VENDA - DENTRO DO ESTADO
qtvendad := 0
// *** QUANT DA VENDA - FORA DO ESTADO
qtvendaf := 0
// *** QUANT DA VENDA - EXTERIOR         
qtvendae := 0
// *** QUANT DA VENDA - MERCADO INTERNO (DENTRO+FORA)
qtvendai := 0
// *** RECEBE CAMPO SD2->D2_QUANT
qtdvend  := 0
// *** RECEBE O PRIMEIRO DIGITO DO CFO (5,6,7)
ntpv     := ""
// *** QUANTIDADE TOTAL VENDIDO
aTOTQ    := 0
// *** VALOR TOTAL VENDIDO
aTOTG    := 0
nLin     := 1
nPag     := 1
// *** RECEBER O CODIGO DAS FAMILIAS PRINCIPAIS
codfam   := 0
// **** Sele‡Æo e ordena‡Æo dos arquivos utilizados
DbSelectArea("SB1")                 // Produtos
DbSetOrder(1)                       // Codigo
DbSelectArea("SA1")                 // Clientes
DbSetOrder(1)                       // Codigo
DbSelectArea("SA3")                 // Vendedores / Representantes
DbSetOrder(1)                       // Codigo
DbSelectArea("SZ2")                 // Classif. Descontos
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
   nItensOK := 0

   DbSelectArea("SD2")
   Do While !Eof() .AND. SD2->D2_DOC == SF2->F2_DOC
      If !SD2->D2_TES $mv_par07
         DbSkip()
         Loop
      EndIf
      DbSelectArea("SB1")
      DbSeek( xFilial("SB1") + SD2->D2_COD )
      CABCLREL02()
      If nItensOK == 0
         @ nLin,  00 PSAY DTOC( SF2->F2_EMISSAO )
         @ nLin,  11 PSAY SF2->F2_DOC
         @ nLin,  19 PSAY SF2->F2_CLIENTE
         @ nLin,  27 PSAY Subst(SA1->A1_NOME,1,21)
      EndIf
      @ nLin,  50 PSAY AllTrim( SB1->B1_COD )  Picture"@R 99.999.999"
      @ nLin,  62 PSAY Subst( Tabela( "03", SB1->B1_GRUPO, .F. ), 1, 13 )
      @ nLin,  80 PSAY SB1->B1_CLCFAM                                   
      @ nLin,  85 PSAY " - "
      @ nLin,  88 PSAY SB1->B1_CLDFAM
      @ nLin, 134 PSAY SD2->D2_TES  
      @ nLin, 137 PSAY " - " + SF4->F4_TEXTO
      @ nLin, 162 PSAY SD2->D2_CF
      nValLivre := SD2->D2_TOTAL + SD2->D2_VALIPI
      qtdvend   := SD2->D2_QUANT
      aTOTQ     := aTOTQ + qtdvend       
      aTOTG     := aTOTG + nValLivre
      @ nLin, 169 PSAY nValLivre               Picture"@E 9,999,999.99"
      @ nLin, 184 PSAY qtdvend                 Picture"@E 9,999,999.99"
      codfam := ALLTRIM(SB1->B1_CLCFAM)
      ntpv := SUBST(SD2->D2_CF,1,1)
         IF  ntpv == "5"
             tpvendad := tpvendad + nValLivre
             tpvendai := tpvendai + nValLivre
             qtvendad := qtvendad + qtdvend
             qtvendai := qtvendai + qtdvend 
         ELSEIF  ntpv == "6"
                 tpvendaf := tpvendaf + nValLivre
                 tpvendai := tpvendai + nValLivre
                 qtvendaf := qtvendaf + qtdvend
                 qtvendai := qtvendai + qtdvend 
         ELSEIF  ntpv == "7"
                 tpvendae := tpvendae + nValLivre
                 qtvendae := qtvendae + qtdvend
         ENDIF

      IF codfam == "1"
         aTotais[1] := aTotais[1] + nValLivre
         qTotais[1] := qTotais[1] + qtdvend
         nomefam[1] := SB1->B1_CLDFAM
         IF  ntpv == "5"
             tpvenda[1] := tpvenda[1] + nValLivre
             qtvenda[1] := qtvenda[1] + qtdvend
             vtotint[1] := vtotint[1] + nValLivre
             qtotint[1] := qtotint[1] + qtdvend
         ELSEIF  ntpv == "6"
                 tpvenda[2] := tpvenda[2] + nValLivre
                 qtvenda[2] := qtvenda[2] + qtdvend   
                 vtotint[1] := vtotint[1] + nValLivre
                 qtotint[1] := qtotint[1] + qtdvend
         ELSE  
                 tpvenda[3] := tpvenda[3] + nValLivre
                 qtvenda[3] := qtvenda[3] + qtdvend  
         ENDIF
      ELSEIF codfam == "2"
         aTotais[2] := aTotais[2] + nValLivre
         qTotais[2] := qTotais[2] + qtdvend
         nomefam[2] := SB1->B1_CLDFAM
         IF  ntpv == "5"
             tpvenda[4] := tpvenda[4] + nValLivre
             qtvenda[4] := qtvenda[4] + qtdvend  
             vtotint[2] := vtotint[2] + nValLivre
             qtotint[2] := qtotint[2] + qtdvend
         ELSEIF  ntpv == "6"
                 tpvenda[5] := tpvenda[5] + nValLivre
                 qtvenda[5] := qtvenda[5] + qtdvend  
                 vtotint[2] := vtotint[2] + nValLivre
                 qtotint[2] := qtotint[2] + qtdvend
         ELSE  
                 tpvenda[6] := tpvenda[6] + nValLivre
                 qtvenda[6] := qtvenda[6] + qtdvend  
         ENDIF
      ELSEIF codfam == "3"
         aTotais[3] := aTotais[3] + nValLivre
         qTotais[3] := qTotais[3] + qtdvend
         nomefam[3] := SB1->B1_CLDFAM
         IF  ntpv == "5"
             tpvenda[7] := tpvenda[7] + nValLivre
             qtvenda[7] := qtvenda[7] + qtdvend  
             vtotint[3] := vtotint[3] + nValLivre
             qtotint[3] := qtotint[3] + qtdvend
         ELSEIF  ntpv == "6"
                 tpvenda[8] := tpvenda[8] + nValLivre
                 qtvenda[8] := qtvenda[8] + qtdvend  
                 vtotint[3] := vtotint[3] + nValLivre
                 qtotint[3] := qtotint[3] + qtdvend
         ELSE  
                 tpvenda[9] := tpvenda[9] + nValLivre
                 qtvenda[9] := qtvenda[9] + qtdvend  
         ENDIF
      ELSEIF codfam == "4"
         aTotais[4] := aTotais[4] + nValLivre
         qTotais[4] := qTotais[4] + qtdvend
         nomefam[4] := SB1->B1_CLDFAM
         IF  ntpv == "5"
             tpvenda[10] := tpvenda[10] + nValLivre
             qtvenda[10] := qtvenda[10] + qtdvend  
             vtotint[4] := vtotint[4] + nValLivre
             qtotint[4] := qtotint[4] + qtdvend
         ELSEIF  ntpv == "6"
                 tpvenda[11] := tpvenda[11] + nValLivre
                 qtvenda[11] := qtvenda[11] + qtdvend  
                 vtotint[4] := vtotint[4] + nValLivre
                 qtotint[4] := qtotint[4] + qtdvend
         ELSE  
                 tpvenda[12] := tpvenda[12] + nValLivre
                 qtvenda[12] := qtvenda[12] + qtdvend  
         ENDIF
      ELSEIF codfam == "5"
         aTotais[5] := aTotais[5] + nValLivre
         qTotais[5] := qTotais[5] + qtdvend
         nomefam[5] := SB1->B1_CLDFAM
         IF  ntpv == "5"
             tpvenda[13] := tpvenda[13] + nValLivre
             qtvenda[13] := qtvenda[13] + qtdvend  
             vtotint[5] := vtotint[5] + nValLivre
             qtotint[5] := qtotint[5] + qtdvend
         ELSEIF  ntpv == "6"
                 tpvenda[14] := tpvenda[14] + nValLivre
                 qtvenda[14] := qtvenda[14] + qtdvend  
                 vtotint[5] := vtotint[5] + nValLivre
                 qtotint[5] := qtotint[5] + qtdvend
         ELSE  
                 tpvenda[15] := tpvenda[15] + nValLivre
                 qtvenda[15] := qtvenda[15] + qtdvend  
         ENDIF
      ELSEIF codfam == "6"
         aTotais[6] := aTotais[6] + nValLivre
         qTotais[6] := qTotais[6] + qtdvend
         nomefam[6] := SB1->B1_CLDFAM
         IF  ntpv == "5"
             tpvenda[16] := tpvenda[16] + nValLivre
             qtvenda[16] := qtvenda[16] + qtdvend  
             vtotint[6] := vtotint[6] + nValLivre
             qtotint[6] := qtotint[6] + qtdvend
         ELSEIF  ntpv == "6"
                 tpvenda[17] := tpvenda[17] + nValLivre
                 qtvenda[17] := qtvenda[17] + qtdvend  
                 vtotint[6] := vtotint[6] + nValLivre
                 qtotint[6] := qtotint[6] + qtdvend
         ELSE  
                 tpvenda[18] := tpvenda[18] + nValLivre
                 qtvenda[18] := qtvenda[18] + qtdvend  
         ENDIF
      ELSE
         aTotais[7] := aTotais[7] + nValLivre
         qTotais[7] := qTotais[7] + qtdvend
         IF  ntpv == "5"
             tpvenda[19] := tpvenda[19] + nValLivre
             qtvenda[19] := qtvenda[19] + qtdvend  
             vtotint[7] := vtotint[7] + nValLivre
             qtotint[7] := qtotint[7] + qtdvend
         ELSEIF  ntpv == "6"
                 tpvenda[20] := tpvenda[20] + nValLivre
                 qtvenda[20] := qtvenda[20] + qtdvend  
                 vtotint[7] := vtotint[7] + nValLivre
                 qtotint[7] := qtotint[7] + qtdvend
         ELSE  
                 tpvenda[21] := tpvenda[21] + nValLivre
                 qtvenda[21] := qtvenda[21] + qtdvend  
         ENDIF
      ENDIF

      nLin       := nLin + 1
      nItensOK   := nItensOK + 1

      DbSelectArea("SD2")
      DbSkip()
   EndDo
// If nItensOK > 0
//    @ nLin, 00 PSAY Replicate("- ", 114 )
//    nLin := nLin + 1
// EndIf

   DbSelectArea("SF2")
   DbSkip()
End
nLin := nLin + 1
@ 58 , 00 PSAY Replicate ( "*", 228)
nLin := 58
CABCLREL02()
@ 17 , 00 PSAY "*************************************** R E S U M O ***************************************"
//              0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18
//              0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
@ 18 , 00 PSAY "                                     -----TOTAL NO PERIODO-----    --VENDAS DENTRO ESTADO--    --VENDAS FORA DO ESTADO-    ---VENDAS MERC.INTERNO--    --VENDAS P/ O EXTERIOR--"
@ 19 , 00 PSAY "                                       QUANTIDADE         VALOR    QUANTIDADE         VALOR    QUANTIDADE         VALOR    QUANTIDADE         VALOR    QUANTIDADE         VALOR"
//              TOTAL DA FAMILIA 1 ->                9.999.999.99  9.999.999.99  9.999.999.99  9.999.999.99  9.999.999.99  9.999.999.99  9.999.999.99  9.999.999.99  9.999.999.99  9.999.999.99
@ 20 , 00 PSAY "TOTAL DA FAMILIA 1 -> "
@ 20 , 22 PSAY nomefam[1]
@ 20 , 38 PSAY qTotais[1]     Picture"@E 9,999,999.99"
@ 20 , 52 PSAY aTotais[1]     Picture"@E 9,999,999.99"
@ 20 , 66 PSAY qtvenda[1]     Picture"@E 9,999,999.99"
@ 20 , 80 PSAY tpvenda[1]     Picture"@E 9,999,999.99"
@ 20 , 94 PSAY qtvenda[2]     Picture"@E 9,999,999.99"
@ 20 ,108 PSAY tpvenda[2]     Picture"@E 9,999,999.99"
@ 20 ,122 PSAY qtotint[1]     Picture"@E 9,999,999.99"
@ 20 ,136 PSAY vtotint[1]     Picture"@E 9,999,999.99"
@ 20, 150 PSAY qtvenda[3]     Picture"@E 9,999,999.99"
@ 20, 164 PSAY tpvenda[3]     Picture"@E 9,999,999.99"

@ 21 , 00 PSAY "TOTAL DA FAMILIA 2 -> "
@ 21 , 22 PSAY nomefam[2]
@ 21 , 38 PSAY qTotais[2]     Picture"@E 9,999,999.99"
@ 21 , 52 PSAY aTotais[2]     Picture"@E 9,999,999.99"
@ 21 , 66 PSAY qtvenda[4]     Picture"@E 9,999,999.99"
@ 21 , 80 PSAY tpvenda[4]     Picture"@E 9,999,999.99"
@ 21 , 94 PSAY qtvenda[5]     Picture"@E 9,999,999.99"
@ 21 ,108 PSAY tpvenda[5]     Picture"@E 9,999,999.99"
@ 21 ,122 PSAY qtotint[2]     Picture"@E 9,999,999.99"
@ 21 ,136 PSAY vtotint[2]     Picture"@E 9,999,999.99"
@ 21, 150 PSAY qtvenda[6]     Picture"@E 9,999,999.99"
@ 21, 164 PSAY tpvenda[6]     Picture"@E 9,999,999.99"

@ 22 , 00 PSAY "TOTAL DA FAMILIA 3 -> "
@ 22 , 22 PSAY nomefam[3]
@ 22 , 38 PSAY qTotais[3]     Picture"@E 9,999,999.99"
@ 22 , 52 PSAY aTotais[3]     Picture"@E 9,999,999.99"
@ 22 , 66 PSAY qtvenda[7]     Picture"@E 9,999,999.99"
@ 22 , 80 PSAY tpvenda[7]     Picture"@E 9,999,999.99"
@ 22 , 94 PSAY qtvenda[8]     Picture"@E 9,999,999.99"
@ 22 ,108 PSAY tpvenda[8]     Picture"@E 9,999,999.99"
@ 22 ,122 PSAY qtotint[3]     Picture"@E 9,999,999.99"
@ 22 ,136 PSAY vtotint[3]     Picture"@E 9,999,999.99"
@ 22, 150 PSAY qtvenda[9]     Picture"@E 9,999,999.99"
@ 22, 164 PSAY tpvenda[9]     Picture"@E 9,999,999.99"

@ 23 , 00 PSAY "TOTAL DA FAMILIA 4 -> "
@ 23 , 22 PSAY nomefam[4]
@ 23 , 38 PSAY qTotais[4]     Picture"@E 9,999,999.99"
@ 23 , 52 PSAY aTotais[4]     Picture"@E 9,999,999.99"
@ 23 , 66 PSAY qtvenda[10]    Picture"@E 9,999,999.99"
@ 23 , 80 PSAY tpvenda[10]    Picture"@E 9,999,999.99"
@ 23 , 94 PSAY qtvenda[11]    Picture"@E 9,999,999.99"
@ 23 ,108 PSAY tpvenda[11]    Picture"@E 9,999,999.99"
@ 23 ,122 PSAY qtotint[4]     Picture"@E 9,999,999.99"
@ 23 ,136 PSAY vtotint[4]     Picture"@E 9,999,999.99"
@ 23, 150 PSAY qtvenda[12]    Picture"@E 9,999,999.99"
@ 23, 164 PSAY tpvenda[12]    Picture"@E 9,999,999.99"

@ 24 , 00 PSAY "TOTAL DA FAMILIA 5 -> "
@ 24 , 22 PSAY nomefam[5]
@ 24 , 38 PSAY qTotais[5]     Picture"@E 9,999,999.99"
@ 24 , 52 PSAY aTotais[5]     Picture"@E 9,999,999.99"
@ 24 , 66 PSAY qtvenda[13]    Picture"@E 9,999,999.99"
@ 24 , 80 PSAY tpvenda[13]    Picture"@E 9,999,999.99"
@ 24 , 94 PSAY qtvenda[14]    Picture"@E 9,999,999.99"
@ 24 ,108 PSAY tpvenda[14]    Picture"@E 9,999,999.99"
@ 24 ,122 PSAY qtotint[5]     Picture"@E 9,999,999.99"
@ 24 ,136 PSAY vtotint[5]     Picture"@E 9,999,999.99"
@ 24, 150 PSAY qtvenda[15]    Picture"@E 9,999,999.99"
@ 24, 164 PSAY tpvenda[15]    Picture"@E 9,999,999.99"

@ 25 , 00 PSAY "TOTAL DA FAMILIA 6 -> "
@ 25 , 22 PSAY nomefam[6]
@ 25 , 38 PSAY qTotais[6]     Picture"@E 9,999,999.99"
@ 25 , 52 PSAY aTotais[6]     Picture"@E 9,999,999.99"
@ 25 , 66 PSAY qtvenda[16]    Picture"@E 9,999,999.99"
@ 25 , 80 PSAY tpvenda[16]    Picture"@E 9,999,999.99"
@ 25 , 94 PSAY qtvenda[17]    Picture"@E 9,999,999.99"
@ 25 ,108 PSAY tpvenda[17]    Picture"@E 9,999,999.99"
@ 25 ,122 PSAY qtotint[6]     Picture"@E 9,999,999.99"
@ 25 ,136 PSAY vtotint[6]     Picture"@E 9,999,999.99"
@ 25, 150 PSAY qtvenda[18]    Picture"@E 9,999,999.99"
@ 25, 164 PSAY tpvenda[18]    Picture"@E 9,999,999.99"

@ 26 , 00 PSAY "TOTAL OUTROS       -> "
@ 26 , 37 PSAY qTotais[7]     Picture"@E 9,999,999.99"
@ 26 , 51 PSAY aTotais[7]     Picture"@E 9,999,999.99"
@ 26 , 65 PSAY qtvenda[19]    Picture"@E 9,999,999.99"
@ 26 , 79 PSAY tpvenda[19]    Picture"@E 9,999,999.99"
@ 26 , 93 PSAY qtvenda[20]    Picture"@E 9,999,999.99"
@ 26 ,107 PSAY tpvenda[20]    Picture"@E 9,999,999.99"
@ 26 ,121 PSAY qtotint[7]     Picture"@E 9,999,999.99"
@ 26 ,135 PSAY vtotint[7]     Picture"@E 9,999,999.99"
@ 26, 149 PSAY qtvenda[21]    Picture"@E 9,999,999.99"
@ 26, 163 PSAY tpvenda[21]    Picture"@E 9,999,999.99"
@ 27,  00 PSAY "                                     ------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------"
@ 28 , 00 PSAY "TOTAL DA GERAL     -> "
@ 28 , 37 PSAY aTOTQ          Picture"@E 9,999,999.99"
@ 28 , 51 PSAY aTOTG          Picture"@E 9,999,999.99"
@ 28 , 65 PSAY qtvendad       Picture"@E 9,999,999.99"
@ 28 , 79 PSAY tpvendad       Picture"@E 9,999,999.99"
@ 28 , 93 PSAY qtvendaf       Picture"@E 9,999,999.99"
@ 28 ,107 PSAY tpvendaf       Picture"@E 9,999,999.99"
@ 28 ,121 PSAY qtvendai       Picture"@E 9,999,999.99"
@ 28 ,135 PSAY tpvendai       Picture"@E 9,999,999.99"
@ 28 ,149 PSAY qtvendae       Picture"@E 9,999,999.99"
@ 28 ,163 PSAY tpvendae       Picture"@E 9,999,999.99"



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
  ³ FUNCAO   ³CABCLREL02³ Autor ³ Adilson Takeshima     ³ Data ³ 14/07/00 ³
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
      @ 02   , 20  PSAY PADC("RELATORIO  FATURAMENTO POR ITEM AGRUPADO POR FAMILIA DE PRODUTOS COEL",188)
      @ 02   ,214  PSAY "Hora: " + Time()
      @ 03   , 00  PSAY "PROGRAMA: CFAT14R"
      @ 04   , 00  PSAY "Notas Fiscais Emitidas  No  Dia  "+DTOC(mv_par01)+"  Ate' o  Dia  "+DTOC(mv_par02) +"  -  Do  Cliente  Cod. "+mv_par03+"  Ate' o  Cliente  Cod. "+mv_par04+"  Do Repres. "+mv_par05+"  Ate' o Repres. "+mv_par06
      @ 04   ,219  PSAY "Pag : " + Str( nPag, 3 )
      @ 05   , 00  PSAY Replicate( "*", 228 )
      @ 06   , 00  PSAY "DATA EMS   N.FISC  ---------- CLIENTE ----------  ---ITEM---  ----- GRUPO ----  -CD.F-  ------------ FAMILIA DE PRODUTOS -----------  TES   ---- DESCR. TES ----  CFO  TOTAL FATURADO     QUANTIDADE"     
      @ 07   , 00  PSAY Replicate( "-", 228 )
      nLin := 9
   ElseIf nLin > 57
      @ 58 , 00 PSAY Replicate ( "*", 228)
      nLin := 1
      nPag := nPag + 1
      Loop
   EndIf
   Exit
EndDo
Return

