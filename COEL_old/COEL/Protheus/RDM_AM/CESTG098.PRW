/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CESTG098 ³ Autor ³ Carlos Nina           ³ Data ³ 27/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera Saldo Final de Nov/2002 de Matls. Nac/Imp.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Contabilidade - P.I. s/MOD                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 11/10/01
#include "topconn.ch"

User Function CESTG098()        // incluido pelo assistente de conversao do AP5 IDE em 11/10/01

Local   lExec    := .F.
Private dDatProc := ddatabase

@ 313,303 To 485,720 Dialog oDlg Title OemToAnsi("Fechamento de Estoque")
@ 024,011 To 075,193 Title OemToAnsi("Parametro")
@ 034,016 Say OemToAnsi("Data de Fechamento") Size 57,11
@ 006,011 Say OemToAnsi("Gera Estrutura de fechamento de estoque p/posterior impressao do relatorio.") Size 185,11
@ 034,076 Get dDatProc Picture "@k" Size 57,10
@ 033,147 BmpButton Type 1 Action ( lExec := .T. , Close(oDlg) )
@ 052,147 BmpButton Type 2 Action ( lExec := .F. , Close(oDlg) )

Activate Dialog oDlg

IF ( lExec )
   Processa( {|lEnd| ProcEst() } )
ENDIF

Return

*************************
Static Function ProcEst()
*************************
Local mv_Local := IIF(M->cNumEmp=="0301" , "02" , "01" ) 
Local cDatImp  := IIF(M->cNumEmp=="0301" , "201101" , "201306" )
Local cDatPro  := LEFT(dtos(dDatProc),6)
Local dDatIni  := ( dDatProc - day(dDatProc) )
Local cDatAnt  := LEFT(DTOS(dDatIni),6)
Local dDatFin  := LastDay(dDatProc)
Local dDatUlt  := dDatFin
Local cDatNxt  := STR(VAL(cDatPro) + 1 , 6)     
Local nCtd     := 0

dDatIni := ( dDatIni + 1  )

////
////Verifica se já tem processamento após a data de processamento atual
////
dbSelectArea("SZT")
dbSetOrder(3)
dbSeek(xFilial("SZT")+cDatNxt,.T.)
IF ( !EOF().AND.ZT_FILIAL==xFilial("SZT").AND.ZT_DATA==cDatNxt )
	MsgStop("Processamento não permitido para este período. Já existe processamento posterior a este período.","Período atual")
	Return
ENDIF

SET(1,"OFF")
dbSelectArea("SZT")
dbSetOrder(2)
dbSeek(xFilial("SZT")+cDatPro,.T.)
ProcRegua(LastRec())
DO WHILE !EOF().AND.ZT_FILIAL==xFilial("SZT").AND.ZT_DATA==cDatPro
   IncProc()
   IF ( ZT_TPR == "EN".AND.ZT_TIPO $ "12345" )
      ////
      ////Zera para reprocessamento
      ////
      RecLock("SZT",.F.)
      SZT->ZT_SDOI  := 0.00
      SZT->ZT_SDON  := 0.00
      MsUnlock()
		nCtd++
   ENDIF
   dbSkip()
ENDDO

aImpNac := { {0,0},{0,0},{0,0},{0,0},{0,0} }

IF ( cDatPro <> cDatImp .OR. M->cNumEmp=="0301" )
	
	cQry  := "SELECT ZT_TIPO,SUM(ZT_CMPI) ZT_CMPI,SUM(ZT_CMPN) ZT_CMPN,SUM(ZT_VINI) ZT_VINI,SUM(ZT_VINII) ZT_VINII,SUM(ZT_VININ) ZT_VININ"
	cQry  += " FROM "+RetSqlName("SZT")
	cQry  += " WHERE D_E_L_E_T_ = ' '"
	cQry  += " AND ZT_FILIAL = '"+xFilial("SZT")+"'"
	cQry  += " AND ZT_TIPO IN ('1','2','3','4','5')"
	cQry  += " AND ZT_TPR = 'EN'"
	cQry  += " AND ZT_DATA = '"+cDatPro+"'"
	cQry  += " GROUP BY ZT_TIPO"
	cQry  += " ORDER BY ZT_TIPO "

	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB3', .T., .T.)

	dbSelectArea("TB3")
	dbGoTop()
	ProcRegua(nCtd)
	DO WHILE !EOF()
		IncProc()
		IF ( cDatPro == cDatImp )
			nCmpI := 0
			nCmpN := 0
			IF ( ABS(TB3->ZT_CMPI + TB3->ZT_CMPN) = 0 )
				nCmpI := TB3->ZT_VINI 
			ELSE
				nCmpI := IIF(TB3->ZT_CMPI > 0 , ROUND(TB3->ZT_VINI * 0.7 , 4 ) , nCmpI )
				nCmpN := IIF(TB3->ZT_CMPN > 0 , ROUND(TB3->ZT_VINI * 0.3 , 4 ) , nCmpN )
			ENDIF
			nTCmpI := ( TB3->ZT_CMPI + nCmpI )
			nTCmpN := ( TB3->ZT_CMPN + nCmpN )
		ELSE
			nTCmpI := ( TB3->ZT_CMPI + TB3->ZT_VINII )
			nTCmpN := ( TB3->ZT_CMPN + TB3->ZT_VININ )
		ENDIF
		nx            := VAL(TB3->ZT_TIPO)
		nTotal        := ( nTCmpI + nTCmpN )
		aImpNac[nx,1] := ROUND( nTCmpI / nTotal , 4 )
		aImpNac[nx,2] := ROUND( nTCmpN / nTotal , 4 )	
		dbSkip()
	ENDDO
ELSE
	////
	////Extrai saldo final do mes, somente da materia-prima 
	////
	cQry  := "SELECT ZT_TIPO,SUM(ZT_VATU) ZT_VATU"
	cQry  += " FROM "+RetSqlName("SZT")
	cQry  += " WHERE D_E_L_E_T_ = ' '"
	cQry  += " AND ZT_FILIAL = '"+xFilial("SZT")+"'"
	cQry  += " AND ZT_TIPO IN ('1','2','3','4','5')"
	cQry  += " AND ZT_TPR = 'EN'"
	cQry  += " AND ZT_DATA = '"+cDatPro+"'"
	cQry  += " GROUP BY ZT_TIPO"
	cQry  += " ORDER BY ZT_TIPO "

	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB3', .T., .T.)
	
	nTSdoMP  := 0
	nTSdoImp := 0
	dbSelectArea("TB3")
	dbGoTop()
	DO WHILE !EOF()
		IF ( TB3->ZT_TIPO = '1' )
			nTSdoMP := TB3->ZT_VATU
		ELSE
			nx            := VAL(TB3->ZT_TIPO)
			aImpNac[nx,2] := 1
		ENDIF
		dbSkip()
	ENDDO
	
	TB3->(dbCloseArea())
	
	Inkey(2)

	///
	///Extrai somente os codigos que tiveram movimento de importacao até o mes de processamento.
	///
	cQry := "SELECT D1_COD,SUM(D1_CUSTO) D1_CUSTO FROM "+RetSqlName("SD1")+" D1,"+RetSqlName("SB1")+" B1"
	cQry += " WHERE D1.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' '"
	cQry += " AND D1_FILIAL = '"+xFilial("SD1")+"' AND D1_LOCAL = '"+mv_Local+"' AND D1_DTDIGIT <= '"+DTOS(dDatFin)+"' AND D1_CF IN ('3101','3102','3107')"
	cQry += " AND B1_FILIAL = D1_FILIAL AND B1_COD = D1_COD AND B1_TIPO = 'MP' AND B1_CLCFAM NOT IN ('ACES','EMB','EMBA')"
	cQry += " GROUP BY D1_COD " 

	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB3', .T., .T.)

	dbSelectArea("SZT")
	dbSetOrder(3)
	*
	dbSelectArea("TB3")
	dbGoTop()
	DO WHILE !EOF()
		SZT->(dbSeek(xFilial("SZT")+TB3->D1_COD+cDatPro+"1"))
		nTSdoImp += SZT->ZT_VATU
		dbSkip()
	ENDDO
	nTSdoNac     := ( nTSdoMP - nTSdoImp )
	aImpNac[1,1] := ROUND( nTSdoImp / nTSdoMP , 4 )
	aImpNac[1,2] := ROUND( nTSdoNac / nTSdoMP , 4 )		
	
ENDIF
TB3->(dbCloseArea())
Inkey(2)
*
cQry  := "SELECT * FROM "+RetSqlName("SZT")
cQry  += " WHERE D_E_L_E_T_ = ' '"
cQry  += " AND ZT_FILIAL = '"+xFilial("SZT")+"'"
cQry  += " AND ZT_TIPO IN ('1','2','3','4','5')"
cQry  += " AND ZT_TPR = 'EN'"
cQry  += " AND ZT_DATA = '"+cDatPro+"'"
cQry  += " AND ZT_VATU > 0"
cQry  += " ORDER BY ZT_TIPO,ZT_COD "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB3', .T., .T.)

dbSelectArea("SB1")
dbSetOrder(1)
*
dbSelectArea("TB3")
dbGoTop()
ProcRegua(nCtd)
DO WHILE !EOF()
   IF ( LastKey() == 286 )
      lContinua := .F.
      EXIT
   ENDIF
   IncProc()
   SB1->(dbSeek(xFilial("SB1")+TB3->ZT_COD))
   B1CC     := TB3->ZT_CC
   B1GRUPO  := TB3->ZT_GRUPO
   B1COD    := TB3->ZT_COD
   IJ       := TB3->ZT_TIPO
   B1AQS    := IIF(SB1->B1_ORIGEM="1" , "I" , "N" )   

   nSdoI := 0
   nSdoN := 0
	nx    := VAL(TB3->ZT_TIPO)
	nSdoI := ROUND(TB3->ZT_VATU * aImpNac[nx,1] , 4 )
	nSdoN := ROUND(TB3->ZT_VATU * aImpNac[nx,2] , 4 )
	
	/*
   IF ( ( TB3->ZT_CMPI + TB3->ZT_CMPN ) > 0 )
		IF ( TB3->ZT_CMPI > 0 .AND. TB3->ZT_CMPN > 0 )
			nSdoI := ROUND(TB3->ZT_VATU * aImpNac[nx,1] , 4 )
			nSdoN := ROUND(TB3->ZT_VATU * aImpNac[nx,2] , 4 )
		ELSE
			nSdoI := IIF(TB3->ZT_CMPI > 0 , TB3->ZT_VATU , nSdoI )
			nSdoN := IIF(TB3->ZT_CMPN > 0 , TB3->ZT_VATU , nSdoN )
		ENDIF
   ELSEIF ( TB3->ZT_VINII > 0 .OR. TB3->ZT_VININ > 0 )
		IF ( TB3->ZT_VINII > 0 .AND. TB3->ZT_VININ > 0 )
			nSdoI := ROUND(TB3->ZT_VATU * aImpNac[nx,1] , 4 )
			nSdoN := ROUND(TB3->ZT_VATU * aImpNac[nx,2] , 4 )
		ELSE
			nSdoI := IIF(TB3->ZT_VINII > 0 , TB3->ZT_VATU , nSdoI )
			nSdoN := IIF(TB3->ZT_VININ > 0 , TB3->ZT_VATU , nSdoN )
		ENDIF
	ELSE
      nSdoI := IIF(B1AQS=="I", TB3->ZT_VATU , nSdoI )
      nSdoN := IIF(B1AQS=="N", TB3->ZT_VATU , nSdoN )	
   ENDIF
	*/
	
   dbSelectArea("SZT")
   dbSetOrder(1)
   dbSeek(xFilial("SZT")+B1COD+B1GRUPO+IJ+cDatPro)
	IF ( !EOF() )
      RecLock("SZT",.F.)
		SZT->ZT_AQS  := B1AQS
		SZT->ZT_SDOI := nSdoI
		SZT->ZT_SDON := nSdoN
		MsUnlock()
		
   ENDIF
   dbSelectArea("TB3")
   dbSkip()
ENDDO

TB3->(dbCloseArea())

Return