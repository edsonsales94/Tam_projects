#include "rwmake.ch"      

User Function CFAT10R() 

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,CPERG,WNREL,CSTRING,NLASTKEY")
SetPrvt("LABORTPRINT,_DINICIAL,_AVALOR,_ATOTGER,NLIN,NPAG")
SetPrvt("_ATOTVEND,_ATOTDSC,_CDESC,_CCLOSE,_COPEN,_AESTRU")
SetPrvt("_CTEMP,")

/*/
  ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
  ³ PROGRAMA ³CLREL08   ³ Autor ³ Alberto N. Gama Junior³ Data ³ 25/11/99 ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
  ³Descri‡Æo ³ Relatorio de Faturamento Liquido por Vendedor / Class. Desc³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ OBS      ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÙ                                                            ³
  ³                                                                       ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  mv_par01 = data inicial
  mv_par02 = data final
  mv_par03 = do vendedor
  mv_par04 = ate' o vendedor
/*/

nTamanho  := "P" 
nLimite   := 132
cTitulo   := PADC( "Faturamento Por Vendedor / Classifica‡Æo Desc", 74 )
cDesc1    := "Este programa emitir  relat¢rio de faturamento dos vendedores"
cDesc2    := "na ordem: Vendedor / Classifica‡Æo Desc / Data Emissao"
cDesc3    := ""
aReturn   := { "Espec¡fico", 1, "Contabil / Faturamento", 1, 1, 1, "", 1 }
nomeprog  := "CLREL08" 
cPerg     := "CLRL08"
wnrel     := "CLRL08"
cString   := "SD2"
nLastKey  := 0
lAbortPrint := .F.

Pergunte( cPerg, .F. )

wnrel := SetPrint( cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3, .F. )

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

#IFDEF WINDOWS
       RptStatus({|| _FATDESC()})// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==>        RptStatus({|| Execute(_FATDESC)})
       Return
#ELSE
       _FATDESC()
#ENDIF

Return

/*/
  ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
  ³ FUNCAO   ³_FATDESC  ³ Autor ³ Alberto N. Gama Junior³ Data ³ 25/11/99 ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
  ³Descri‡Æo ³ Manipula‡Æo de dados e impressÆo do relat¢rio              ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ OBS      ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÙ                                                            ³
  ³                                                                       ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

*****************************************************************************
*****************************************************************************
// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==> Function _FATDESC
Static Function _FATDESC()

_ARQTRAB()

DbSelectArea("SA1")
DbSetorder(1)

DbSelectArea("SA3")
DbSetorder(1)

DbSelectArea("SD2")
DbSetOrder(3)

DbSelectArea("SF4")
DbSetOrder(1)

DbSelectArea("SF2")
//DbSetOrder(6)
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

SetRegua( (mv_par02-_dInicial+1)*30 )

Do While !Eof() .AND. SF2->F2_EMISSAO <= mv_par02 .AND. !lAbortPrint

   IncRegua()

   DbSelectArea("SA1")
   DbSeek( xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA )

   If SA1->A1_VEND < mv_par03 .OR. SA1->A1_VEND > mv_par04 .OR. SF2->F2_TIPO=="I"
      DbSelectArea("SF2")
      DbSkip()
      Loop
   EndIf

   DbSelectArea("SA3")
   DbSeek( xFilial("SA3") + SA1->A1_VEND )

   DbSelectArea("SD2")
   DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE )

   _aVALOR    := { 0, 0, 0, 0 }       // *** Bruto, Liquido, Ipi, Icms
   _aVALOR[1] := SF2->F2_VALBRUT

   Do While !Eof() .AND. SD2->D2_DOC==SF2->F2_DOC .AND. SD2->D2_SERIE==SF2->F2_SERIE

      DbSelectArea("SF4")
      DbSeek( xFilial("SF4") + SD2->D2_TES )

      If SF4->F4_ISS $"S"
         DbSelectArea("SD2")
         DbSkip()
         Loop
      EndIf

      _aVALOR[2] := _aVALOR[2] + SD2->D2_TOTAL
      _aVALOR[3] := _aVALOR[3] + SD2->D2_VALIPI
      _aVALOR[4] := _aVALOR[4] + SD2->D2_VALICM

      DbSelectArea("SD2")
      DbSkip()

   EndDo

   If _aVALOR[2] > 0
      DbSelectArea("_TRAB")
      RecLock( "_TRAB", .T. )
      _TRAB->T_NF    := SF2->F2_DOC
      _TRAB->T_EMS   := SF2->F2_EMISSAO
      _TRAB->T_BRUTO := _aVALOR[1]
      _TRAB->T_LIQ   := _aVALOR[2]
      _TRAB->T_IPI   := _aVALOR[3]
      _TRAB->T_ICM   := _aVALOR[4]
      _TRAB->T_CLI   := SF2->F2_CLIENTE
      _TRAB->T_LOJA  := SF2->F2_LOJA
      _TRAB->T_VEND  := SA3->A3_COD
      _TRAB->T_DSC   := SA1->A1_CLCLASI
      MsUnlock()
   EndIf

   DbSelectArea("SF2")
   DbSkip()

EndDo

DbSelectArea("_TRAB")
DbCommit()

IndRegua( "_TRAB", _cTemp, "T_VEND+Subst(T_DSC,1,1)+T_NF", , , "Organizando Informa‡äes..." )
DbGoTop()
SetRegua( LastRec() )

_aTOTGER := { 0, 0, 0, 0 }  // *** Bruto, Liquido, Ipi, Icms
nLin := 1
nPag := 1

Do While !Eof() .AND. !lAbortPrint

   _aTOTVEND := { 0, 0, 0, 0 }  // *** Bruto, Liquido, Ipi, Icms
   nLin := 1

   DbSelectArea("SA3")
   DbSeek( xFilial("SA3") + _TRAB->T_VEND )

   DbSelectArea("_TRAB")

   Do While !Eof() .AND. _TRAB->T_VEND==SA3->A3_COD .AND. !lAbortPrint

      _aTOTDSC := { 0, 0, 0, 0 }  // *** Bruto, Liquido, Ipi, Icms
      _cDESC   := Subst( _TRAB->T_DSC, 1, 1 )

      Do While !Eof() .AND. _TRAB->T_VEND==SA3->A3_COD .AND. Subst(_TRAB->T_DSC,1,1)==_cDESC .AND. !lAbortPrint

         IncRegua()

         _CABCLRL08()

         If nLin == 9
            @ nLin, 01 PSAY "Vendedor: " + SA3->A3_COD + " - " + SA3->A3_NOME
            nLin := nLin + 2
         EndIf
                  
         DbSelectArea("SA1")
         DbSeek( xFilial("SA1") + _TRAB->T_CLI + _TRAB->T_LOJA )

         @ nLin,  01 PSAY _TRAB->T_NF
         @ nLin,  10 PSAY _TRAB->T_EMS
         @ nLin,  20 PSAY _TRAB->T_CLI
         @ nLin,  27 PSAY _TRAB->T_LOJA
         @ nLin,  31 PSAY SA1->A1_NOME
         @ nLin,  73 PSAY SA1->A1_REGIAO
         @ nLin,  78 PSAY _TRAB->T_DSC
         @ nLin,  87 PSAY _TRAB->T_BRUTO    Picture"@E 999,999,999.99"
         @ nLin, 108 PSAY _TRAB->T_LIQ      Picture"@E 999,999,999.99"

         _aTOTGER[1] := _aTOTGER[1] + _TRAB->T_BRUTO
         _aTOTGER[2] := _aTOTGER[2] + _TRAB->T_LIQ
         _aTOTGER[3] := _aTOTGER[3] + _TRAB->T_IPI
         _aTOTGER[4] := _aTOTGER[4] + _TRAB->T_ICM

         _aTOTVEND[1] := _aTOTVEND[1] + _TRAB->T_BRUTO
         _aTOTVEND[2] := _aTOTVEND[2] + _TRAB->T_LIQ
         _aTOTVEND[3] := _aTOTVEND[3] + _TRAB->T_IPI
         _aTOTVEND[4] := _aTOTVEND[4] + _TRAB->T_ICM

         _aTOTDSC[1] := _aTOTDSC[1] + _TRAB->T_BRUTO
         _aTOTDSC[2] := _aTOTDSC[2] + _TRAB->T_LIQ
         _aTOTDSC[3] := _aTOTDSC[3] + _TRAB->T_IPI
         _aTOTDSC[4] := _aTOTDSC[4] + _TRAB->T_ICM

         nLin := nLin + 1

         DbSelectArea("_TRAB")
         DbSkip()

      EndDo

      nLin := nLin + 1

      @ nLin,  01 PSAY "TOTAL DA CLASSIFICACAO"
      @ nLin,  25 PSAY "* " + _cDESC +" *"
      @ nLin,  32 PSAY "---------->"
      @ nLin,  87 PSAY _aTOTDSC[1]               Picture"@E 999,999,999.99"
      @ nLin, 108 PSAY Val( Left( Str( _aTOTDSC[2], 14, 4 ), 12 ) )  Picture"@E 999,999,999.99"

      nLin := nLin + 2

   EndDo

   @ nLin,  01 PSAY "TOTAL DO VENDEDOR"
   @ nLin,  32 PSAY "---------->"
   @ nLin,  87 PSAY _aTOTVEND[1]              Picture"@E 999,999,999.99"
   @ nLin, 108 PSAY Val( Left( Str( _aTOTVEND[2], 14, 4), 12 ) )  Picture"@E 999,999,999.99"

EndDo

nLin := 1
_CABCLRL08()
nLin := nLin + 1

@ nLin,  01 PSAY "TOTAL GERAL"
@ nLin,  32 PSAY "---------->"
@ nLin,  87 PSAY _aTOTGER[1]              Picture"@E 999,999,999.99"
@ nLin, 108 PSAY Val( Left( Str( _aTOTGER[2], 14, 4 ), 12 ) )  Picture"@E 999,999,999.99"

nLin := 60
@ nLin , 00 PSAY Replicate( "*", 132 )
@ 61   , 01 PSAY "COEL  Controles  Eletricos  Ltda"+Space(33)+ "FIM"+Space(34)+"Deparatamento de Informatica"
@ 62   , 00 PSAY Replicate( "*", 132 )
@ 00   , 00 PSAY ""
SetPrc(0,0)

RetIndex("SD2")
RetIndex("SF2")
RetIndex("SA1")
RetIndex("SA3")
RetIndex("SF4")

_cClose := { "_TRAB" }
_cOpen  := {}
CloseOpen( _cClose, _cOpen )

FErase( _cTemp + ".dbf" )
FErase( _cTemp + ".mem" )
FErase( _cTemp + ".idx" )

If aReturn[5] == 1
   Set Printer To
   OurSpool( wnrel )
EndIf

MS_FLUSH()

// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==> __Return( Nil )
Return( Nil )        // incluido pelo assistente de conversao do AP6 IDE em 11/09/02
*****************************************************************************
*****************************************************************************
// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==> Function _ARQTRAB
Static Function _ARQTRAB()

_aEstru := { {"T_NF","C",6,0}, {"T_EMS","D",8,0}, {"T_BRUTO","N",14,4},    ;
             {"T_LIQ","N",14,4}, {"T_IPI","N",14,4}, {"T_ICM","N",14,4},   ;
             {"T_CLI","C",6,0}, {"T_LOJA","C",2,0}, {"T_VEND","C",6,0},    ;
             {"T_DSC","C",2,0} }

_cTemp := CriaTrab( _aEstru, .T. )

DbUseArea( .T., , _cTemp, "_TRAB", .T., .F. )   // abre em modo exclusivo

// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==> __Return( Nil )
Return( Nil )        // incluido pelo assistente de conversao do AP6 IDE em 11/09/02
*****************************************************************************
*****************************************************************************
// Substituido pelo assistente de conversao do AP6 IDE em 11/09/02 ==> Function _CABCLRL08
Static Function _CABCLRL08()

While .T.
   If nLin == 1
      @ nLin , 00  PSAY Replicate( "*", 132 )
      @ 02   , 01  PSAY "Emissao: "+DtoC(Date())
      @ 02   , 35  PSAY "RELATORIO DE FATURAMENTO POR VENDEDOR / CLASSIFICACAO DESCONTOS"
      @ 02   ,117  PSAY "Hora: " + Time()
      @ 03   , 01  PSAY "CFAT10R" 
      @ 04   , 01  PSAY "Do Dia  "+DTOC(mv_par01)+"  Ate'o Dia  "+DTOC(mv_par02) + " - "
      @ 04   , 43  PSAY "Do Vendedor  "+mv_par03+"  Ate'o Vendedor  "+mv_par04
      @ 04   ,122  PSAY "Pag : " + Str( nPag, 3 )
      @ 05   , 00  PSAY Replicate( "*", 132 )

      // ****                     10        20        30        40        50        60        70        80        90        100       110       120       130
      // ****           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

      @ 07   , 01  PSAY "NF       EMISSAO   CLIENTE                                              REG  DSC           VR. BRUTO           VR LIQUIDO"
      @ 08   , 00  PSAY Replicate( "-", 132 )
      nLin := 9
   ElseIf nLin > 59
      nLin := 1
      nPag := nPag + 1
      Loop
   EndIf
   Exit
EndDo

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 11/09/02

