#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "topconn.ch"
/*/{protheus.doc}TRAN_CTB
Rotina de alteracao do codigo do movimento contabil
@author Honda Lock
/*/
//************************

User Function TRAN_CTB()  // Altera movimento da conta para novo codigo

//************************

Local oDLG1
Local cEMP    := Space( 2 )
Local cCONTA1 := Space( 20 )
Local cCONTA2 := Space( 20 )
Local cANALIT := Space( 20 )

DEFINE MSDIALOG oDlg1 FROM 000,000 TO 170,300 TITLE "Alteração do código no movimento contábil" PIXEL
@ 008,003 SAY "Empresa:"  OF oDlg1 PIXEL SIZE 50,09
@ 008,033 GET cEMP  OF oDlg1 PIXEL SIZE 20,09
@ 023,003 SAY "De conta:"  OF oDlg1 PIXEL SIZE 50,09
@ 023,033 GET cCONTA1  OF oDlg1 PIXEL SIZE 100,09
@ 038,003 SAY "Para conta:"  OF oDlg1 PIXEL SIZE 50,09
@ 038,033 GET cCONTA2  OF oDlg1 PIXEL SIZE 100,09
@ 053,003 SAY "Conta superior:"  OF oDlg1 PIXEL SIZE 50,09
@ 053,043 GET cANALIT OF oDlg1 PIXEL SIZE 100,09

DEFINE SBUTTON FROM 070,063 TYPE 1 ENABLE action MUDACONTA( cEMP, cCONTA1, cCONTA2, .T.,, .T., cANALIT )

ACTIVATE MSDIALOG oDlg1 CENTERED
Return NIL



//************************

Static Function Troca_Conta( cCONTA, cSUPER, cNOVOCOD, lCT1, cCLASSE, lSUPERIOR )

//************************

Local cQUERY1
Local nREG := CT1->( Recno() )
Local nORD := CT1->( IndexOrd() )

lCT1 := If( lCT1 == NIL, .T., lCT1 )

If cNOVOCOD == NIL
   cQuery1 := "SELECT Min( CT1_CONTA ) AS CT1_CONTA "
   cQuery1 += " FROM " + RetSqlName("CT1")
   cQuery1 += " (NOLOCK) WHERE CT1_FILIAL = '" + xFILIAL( "CT1" ) +"' "
   cQuery1 += " AND D_E_L_E_T_ = '' AND CT1_CTASUP = '" + cSUPER + "' "
   
   MPSysOpenQuery( cQuery1, "TEMP" ) // dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery1), 'TEMP', .F., .T. )
   If ! TEMP->( Eof() )
      cNOVOCOD := Soma1( AllTrim( cSUPER ) + Repl( "0", Len( AllTrim( TEMP->CT1_CONTA ) ) - Len( AllTrim( cSUPER ) ) ) )
      CT1->( DbSetOrder( 1 ) )
      Do While CT1->( DbSeek( xFilial("CT1") + Padr( cNOVOCOD, 20 ) ) )
         cNOVOCOD := Soma1( cNOVOCOD )
      EndDo
      CT1->( DbSetOrder( nORD ) )      
      CT1->( DbGoto( nREG ) )
   Else
      cNOVOCOD := Padr( AllTrim( cCONTA ) + "01", 20 )
   EndIf   
   TEMP->( DbCloseArea() )
Endif
If TcSqlExec( "UPDATE " + RetSqlName( "CT2" ) + " SET CT2_CREDIT = '" + cNOVOCOD + "' " + ;
           " WHERE CT2_FILIAL = '" + xFILIAL( "CT2" ) + "' " + ;
           " AND D_E_L_E_T_ = ' ' AND CT2_CREDIT = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif

If TcSqlExec( "UPDATE " + RetSqlName( "CT2" ) + " SET CT2_DEBITO = '" + cNOVOCOD + "' " + ;
           " WHERE CT2_FILIAL = '" + xFILIAL( "CT2" ) + "' " + ;
           " AND D_E_L_E_T_ = ' ' AND CT2_DEBITO = '" + cCONTA + "' " ) <> 0
// UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
//Conout( "Alteracao da tabela CT2. Em " + dtoc(date()) + " as " + time() )
           
If TcSqlExec( "UPDATE " + RetSqlName( "CT3" ) + " SET CT3_CONTA = '" + cNOVOCOD + "' " + ;
           " WHERE CT3_FILIAL = '" + xFILIAL( "CT3" ) + "' " + ;
           " AND D_E_L_E_T_ = ' ' AND CT3_CONTA = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
//Conout( "Alteracao da tabela CT3. Em " + dtoc(date()) + " as " + time() )
           
If TcSqlExec( "UPDATE " + RetSqlName( "CT7" ) + " SET CT7_CONTA = '" + cNOVOCOD + "' " + ;
           " WHERE CT7_FILIAL = '" + xFILIAL( "CT7" ) + "' " + ;
           " AND D_E_L_E_T_ = ' ' AND CT7_CONTA = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
//Conout( "Alteracao da tabela CT7. Em " + dtoc(date()) + " as " + time() )
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTK" ) + " SET CTK_CREDIT = '" + cNOVOCOD + "' " + ;
           " WHERE CTK_FILIAL = '" + xFILIAL( "CTK" ) + "' " + ;
           " AND D_E_L_E_T_ = ' ' AND CTK_CREDIT = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTK" ) + " SET CTK_DEBITO = '" + cNOVOCOD + "' " + ;
           " WHERE CTK_FILIAL = '" + xFILIAL( "CTK" ) + "' " + ;
           " AND D_E_L_E_T_ = ' ' AND CTK_DEBITO = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
//Conout( "Alteracao da tabela CTK. Em " + dtoc(date()) + " as " + time() )
           
If TcSqlExec( "UPDATE " + RetSqlName( "CV3" ) + " SET CV3_CREDIT = '" + cNOVOCOD + "' " + ;
           " WHERE CV3_FILIAL = '" + xFILIAL( "CV3" ) + "' " + ;
           " AND D_E_L_E_T_ = ' ' AND CV3_CREDIT = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CV3" ) + " SET CV3_DEBITO = '" + cNOVOCOD + "' " + ;
           " WHERE CV3_FILIAL = '" + xFILIAL( "CV3" ) + "' " + ;
           " AND D_E_L_E_T_ = ' ' AND CV3_DEBITO = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
//Conout( "Alteracao da tabela CV3. Em " + dtoc(date()) + " as " + time() )
           
If TcSqlExec( "UPDATE " + RetSqlName( "SA1" ) + " SET A1_CONTA = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND A1_CONTA = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
//Conout( "Alteracao da tabela SA1. Em " + dtoc(date()) + " as " + time() )
           
If TcSqlExec( "UPDATE " + RetSqlName( "SA2" ) + " SET A2_CONTA = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND A2_CONTA = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
//Conout( "Alteracao da tabela SA2. Em " + dtoc(date()) + " as " + time() )

If lCT1
   If cCLASSE <> NIL .and. ! Empty( cCLASSE )
      If TcSqlExec( "UPDATE " + RetSqlName( "CT1" ) + " SET CT1_DESC04 = CT1_CONTA,CT1_DESC05 = 'ALTERADO',CT1_CONTA = '" + cNOVOCOD + ;
                 "',CT1_DC = '" + CtbDigCont( cNOVOCOD ) + "',CT1_CTASUP = '" + cSUPER + "',CT1_CLASSE = '" + cCLASSE + "' " + ;
                 " WHERE CT1_FILIAL = '" + xFILIAL( "CT1" ) + "' " + ;
                 " AND D_E_L_E_T_ = ' ' AND CT1_CONTA = '" + cCONTA + "' " ) <> 0
//         UserException( "Erro " + Chr( 10 ) + TCSqlError() )
      endif
   Else
      If TcSqlExec( "UPDATE " + RetSqlName( "CT1" ) + " SET CT1_DESC04 = CT1_CONTA,CT1_DESC05 = 'ALTERADO',CT1_CONTA = '" + cNOVOCOD + ;
                 "',CT1_DC = '" + CtbDigCont( cNOVOCOD ) + "',CT1_CTASUP = '" + cSUPER + "' " + ;
                 " WHERE CT1_FILIAL = '" + xFILIAL( "CT1" ) + "' " + ;
                 " AND D_E_L_E_T_ = ' ' AND CT1_CONTA = '" + cCONTA + "' " ) <> 0
//         UserException( "Erro " + Chr( 10 ) + TCSqlError() )
      endif
   EndIf
Else
   If cCLASSE <> NIL .and. ! Empty( cCLASSE )
      If TcSqlExec( "UPDATE " + RetSqlName( "CT1" ) + " SET CT1_CLASSE = '" + cCLASSE + "' " + ;
                 " WHERE CT1_FILIAL = '" + xFILIAL( "CT1" ) + "' " + ;
                 " AND D_E_L_E_T_ = ' ' AND CT1_CONTA = '" + cNOVOCOD + "' " ) <> 0
//         UserException( "Erro " + Chr( 10 ) + TCSqlError() )
      endif
   EndIf
EndIf   
//Conout( "Alteracao da tabela CT1. Em " + dtoc(date()) + " as " + time() )
           
If TcSqlExec( "UPDATE " + RetSqlName( "SB1" ) + " SET B1_CONTA = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND B1_CONTA = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
//Conout( "Alteracao da tabela SB1. Em " + dtoc(date()) + " as " + time() )
           
If TcSqlExec( "UPDATE " + RetSqlName( "SA6" ) + " SET A6_CONTA = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND A6_CONTA = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
//Conout( "Alteracao da tabela SA6. Em " + dtoc(date()) + " as " + time() )
           
If TcSqlExec( "UPDATE " + RetSqlName( "SF5" ) + " SET F5_CONTA = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND F5_CONTA = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
//Conout( "Alteracao da tabela SF5. Em " + dtoc(date()) + " as " + time() )

If TcSqlExec( "UPDATE " + RetSqlName( "SED" ) + " SET ED_CONTA = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND ED_CONTA = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_CCDIFE = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_CCDIFE = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_CONTAL = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_CONTAL = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_CONTA = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_CONTA = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_CUSINC = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_CUSINC = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_CCORCA = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_CCORCA = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_CUSDIF = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_CUSDIF = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_CUSVEN = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_CUSVEN = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_CINCOR = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_CINCOR = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_CTVEND = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_CTVEND = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_CTCORR = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_CTCORR = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_CTPUBL = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_CTPUBL = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_ADIANT = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_ADIANT = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_FINAN = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_FINAN = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
           
If TcSqlExec( "UPDATE " + RetSqlName( "CTT" ) + " SET CTT_GARAN = '" + cNOVOCOD + "' " + ;
           " WHERE D_E_L_E_T_ = ' ' AND CTT_GARAN = '" + cCONTA + "' " ) <> 0
//   UserException( "Erro " + Chr( 10 ) + TCSqlError() )
endif
Conout( "TRAN_CTB - " + Alltrim( Upper( cUserName ) ) + " - Da Conta " + AllTrim( cCONTA ) + " para a conta " + AllTrim( cNOVOCOD ) + ". Em " + dtoc(date()) + " as " + time() )

Return cNOVOCOD



//************************

Static Function MUDACONTA( cEMP, cCONTA1, cCONTA2, lCT1, cCLASSE, lMENS, cANALIT )

//************************

Local cSUPER

lCT1  := If( lCT1 == NIL, .T., lCT1 )
lMENS := If( lMENS == NIL, .T., lMENS )
RpcClearEnv()
RpcSetType(3)
RpcSetEnv( cEMP,"01",,,'COM',GetEnvServer())
SetModulo( "SIGACOM", "COM" )
SetHideInd(.T.)
Sleep( 1000 )	// aguarda 1 segundos para que as jobs IPC subam.
__cLogSiga := "NNNNNNN"
OpenProfile()
DbSelectArea("SM2")
CT1->( DbSetOrder( 1 ) )
If lCT1
   If ! CT1->( dbSeek( xFilial( "CT1" ) + cCONTA1 ) )
      MsgBox("Conta origem nao existe (" + AllTrim( cCONTA1 ) + ")","info","stop")
   ElseIf CT1->( dbSeek( xFilial( "CT1" ) + cCONTA2 ) )
      MsgBox("Conta destino ja existe (" + AllTrim( cCONTA2 ) + ")","info","stop")
   Else
      If cANALIT <> NIL .and. ! Empty( cANALIT )
         If CT1->( dbSeek( xFilial( "CT1" ) + cANALIT ) )
            If CT1->CT1_CLASSE <> "1"
               MsgBox( "Conta superior informada não é analítica (" + AllTrim( cANALIT ) + ")", "info", "stop" )
               Return NIL
            EndIf
            cSUPER := cANALIT
         Else
            MsgBox( "Conta analítica superior nao existe (" + AllTrim( cANALIT ) + ")", "info", "stop" )
            Return NIL
         EndIf   
      Else
         If Len( AllTrim( cCONTA2 ) ) == 3
            cSUPER := Padr( Left( cCONTA2, 2 ), 20 )
         ElseIf Len( AllTrim( cCONTA2 ) ) == 5
            cSUPER := Padr( Left( cCONTA2, 3 ), 20 )
         ElseIf Len( AllTrim( cCONTA2 ) ) == 7
            cSUPER := Padr( Left( cCONTA2, 5 ), 20 )            
         ElseIf Len( AllTrim( cCONTA2 ) ) == 9 .or. Len( AllTrim( cCONTA2 ) ) == 10
            cSUPER := Padr( Left( cCONTA2, 7 ), 20 )            
         ElseIf Len( AllTrim( cCONTA2 ) ) == 11 .or. Len( AllTrim( cCONTA2 ) ) == 12 .or. Len( AllTrim( cCONTA2 ) ) == 13
            cSUPER := Padr( Left( cCONTA2, 9 ), 20 )
            If ! CT1->( dbSeek( xFilial( "CT1" ) + cSUPER ) )
               cSUPER := Padr( Left( cCONTA2, 7 ), 20 )
            EndIf
         EndIf
      EndIf   
      Troca_Conta( cCONTA1, cSUPER, cCONTA2, lCT1, cCLASSE, ( cANALIT <> NIL .and. ! Empty( cANALIT ) ) )
      If( lMENS, MsgBox("Conta alterada com sucesso!","info", "info"), NIL )
   EndIf
Else
   If ! CT1->( dbSeek( xFilial( "CT1" ) + cCONTA2 ) )
      MsgBox("Conta destino nao existe (" + AllTrim( cCONTA2 ) + ")","info","stop")
   Else
      If Len( AllTrim( cCONTA2 ) ) == 3
         cSUPER := Padr( Left( cCONTA2, 2 ), 20 )
      ElseIf Len( AllTrim( cCONTA2 ) ) == 5
         cSUPER := Padr( Left( cCONTA2, 3 ), 20 )
      ElseIf Len( AllTrim( cCONTA2 ) ) == 7
         cSUPER := Padr( Left( cCONTA2, 5 ), 20 )            
      ElseIf Len( AllTrim( cCONTA2 ) ) == 9 .or. Len( AllTrim( cCONTA2 ) ) == 10
         cSUPER := Padr( Left( cCONTA2, 7 ), 20 )            
      ElseIf Len( AllTrim( cCONTA2 ) ) == 11 .or. Len( AllTrim( cCONTA2 ) ) == 12 .or. Len( AllTrim( cCONTA2 ) ) == 13
         cSUPER := Padr( Left( cCONTA2, 9 ), 20 )
         If ! CT1->( dbSeek( xFilial( "CT1" ) + cSUPER ) )
            cSUPER := Padr( Left( cCONTA2, 7 ), 20 )
         EndIf
      EndIf
      Troca_Conta( cCONTA1, cSUPER, cCONTA2, lCT1, cCLASSE )
      If( lMENS, MsgBox("Conta alterada com sucesso!","info", "info"), NIL )
   EndIf
EndIf
Return NIL
