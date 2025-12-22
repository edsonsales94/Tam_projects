#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Cfat16i()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,XARQSAIDA,XDADOS,MV_PAR01,XNOMECLI,XCLASCLI")
SetPrvt("AFECHA,AABRE,XARQUIVO,CREFER,DREFER,NACRES")
SetPrvt("NSEM,AESTRUT,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT16I  ³ Autor ³ Alberto N. G. Junior  ³ Data ³ 12/08/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria um arquivo de pedidos a ser enviado para a f brica.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ - SÆo considerados pedidos cujo campo C5_CLOS = "S" e campo³±±
±±³          ³   C5_CLENVSR = VAZIO.                                      ³±±
±±³          ³ - No campo C5_CLENVSR ‚ gravado a data que o pedido foi in-³±±
±±³          ³   cluso em arquivo para fabrica‡Æo.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Vendas                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01       // Data Emissao Pedido de                     ³
//³ mv_par02       // Data Emissao Pedido ate'                   ³ 
//³ mv_par03       // Arquivo de Saida                           ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPerg := "CLFABR"

Do While .T.

   If Pergunte(cPerg,.T.) == .F.
      Return
   EndIf

   xArqSaida:= AllTrim( mv_par03 ) + ".dbf"

   If File( "\SIGA\SIGAADV\EXP\VENDAS\"+xArqSaida )
      MsgBox( "O arquivo de sa¡da informado j  existe. Digite outro nome.", "Aten‡Æo" )
      Loop                                                                             
   EndIf

   Exit

EndDo

If Alert( "Os items transmitidos nÆo serÆo retransmitidos futuramente. Continuar ?", { " SIM ", " NAO " } ) == 1
   processa({||_PEDSR()},'Gerando arquivo de pedidos para fabrica‡Æo...')// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>    processa({||Execute(_PEDSR)},'Gerando arquivo de pedidos para fabrica‡Æo...')
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡Æo   ³ _PEDSR   ³ Autor ³ Alberto N. G. Junior  ³ Data ³ 12/08/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria‡Æo do arquivo                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CLPEDSR.PRX                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function _PEDSR
Static Function _PEDSR()

xDados   := .F.

DbSelectArea("SB1")
DbSetOrder(1)

DbSelectArea("SC6")
DbSetOrder(6)

DbSelectArea("SC5")
DbSetOrder(2)

If !DbSeek( xFilial("SC5") + DToS(mv_par01) )
   Do While mv_par01 <= mv_par02
      mv_par01 := mv_par01 + 1
      If ( DbSeek( xFilial("SC5") + DToS(mv_par01) ) )
         Exit
      EndIf
   EndDo
EndIf

DbSelectArea("SC5")
ProcRegua( (mv_par02-mv_par01+1)*35 )

Do While !Eof() .AND. SC5->C5_EMISSAO >= mv_par01
   
   IncProc(xArqSaida)

   xNomeCli := Posicione( "SA1", 1, xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_NOME" )
   xClasCli := Posicione( "SA1", 1, xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_CLCLASI" )

   DbSelectArea("SC6")
   DbSeek( xFilial("SC6")+SC5->C5_NUM )

   Do While !Eof() .AND. SC6->C6_NUM == SC5->C5_NUM

      If SC6->C6_CLGOP #"S"
          DbSkip()
          Loop
      EndIf

      If xDados == .F.
         _CriaArq()
      EndIf

      DbSelectArea("PSR")
      Do While .T.
         If RecLock( "PSR", .T. )
            Exit
         EndIf
         MsgBox( "Registro bloqueado por outra esta‡Æo !", "Nova Tentativa", "ALERT" )
      EndDo

      _NumSemana()

      Replace N_PV    With Val(SC6->C6_NUM)
      Replace CODIGO  With Subst(SC6->C6_PRODUTO,1,2)+"."+Subst(SC6->C6_PRODUTO,4,2)+"."+Subst(SC6->C6_PRODUTO,7,2)
      Replace QT_EPV  With SC6->C6_QTDVEN
      Replace DT_EPV  With SC6->C6_ENTREG
      Replace CLIENTE With Val(SC6->C6_CLI)
      Replace SEMANA  With nSem
      Replace RAZAO   With xNomeCli
      Replace CLASSE  With xClasCli

      MsUnlock()
      xDados := .T.

      DbSelectArea("SC6")
      DbSkip()

   EndDo
   /*
   DbSelectArea("SC5")
   Do While .T.
      If RecLock( "SC5", .F. )
         Exit
      EndIf
      MsgBox( "Registro bloqueado por outra esta‡Æo !", "Nova Tentativa", "ALERT" )
   EndDo

   Replace C5_CLENVSR With Date()
   MsUnlock()
   */
   DbSelectArea("SC5")
   DbSkip()

EndDo

aFecha := { "PSR" } ; aAbre := {}
CloseOpen( aFecha, aAbre )

DbSelectArea("SC5")
RetIndex("SC5")

If xDados == .T.
   MsgBox( " Opera‡Æo Conclu¡da.  Nome do arquivo Criado: "+xArqSaida , "Conclu¡do", "ALERT" )
   xArqSaida := "\SIGA\SIGAADV\EXP\VENDAS\"+xArqSaida
   xArquivo := xArquivo + ".DBF"
   FRename( xArquivo, xArqSaida )
   copy file (xArqSaida) to ("\SIGA\SIGAADV\EXP\VENDAS\PEDISR.DBF")
Else
   MsgBox( "O arquivo  "+xArqSaida+"  nÆo foi gerado.  NÆo h  itens a fabricar." , "Conclu¡do", "ALERT" )
EndIf

Return
*****************************************************************************
*****************************************************************************
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function _NumSemana
Static Function _NumSemana()

cRefer := "01/01/" + AllTrim( Str( Year( SC6->C6_ENTREG ), 4 ) )
dRefer := CToD( cRefer )
nAcres := Dow( dRefer ) - 1
nSem   := ( SC6->C6_ENTREG - dRefer ) + nAcres
nSem   := nSem / 7
nSem   := Iif( Subst( Str( nSem, 12, 2 ), 11, 2 )=="00", Int(nSem), Int(nSem)+1 )
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return( nSem )
Return( nSem )        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
*****************************************************************************
*****************************************************************************
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function _CriaArq
Static Function _CriaArq()

aEstrut  := { {"N_PV","N",6,0}, {"CODIGO","C",14,0}, {"QT_EPV","N",9,2},   ;
              {"DT_EPV","D",8,0}, {"SEMANA","N",3,0}, {"CLIENTE","N",5,0}, ;
              {"RAZAO","C",40,0}, {"CLASSE","C",2,0} }
xArquivo := CriaTrab( aEstrut, .T. )
DbUseArea( .T., , xArquivo, "PSR", .T., .F. )
*****************************************************************************
*****************************************************************************

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

