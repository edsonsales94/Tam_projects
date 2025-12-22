/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CINVG005 º Autor ³ Carlos Nina        º Data ³  18/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Transfere Inventario de SZP para SB7                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "protheus.ch"        
#include "rwmake.ch"        
#include "TOTVS.CH"
#include "TOPCONN.CH"

User Function CINVG005()

dbSelectArea("SZP")
dbSetOrder(1)
dbGoBottom()
ZPDATA  := SZP->ZP_DATA
ZPDOC   := SPACE(9)
ZPLOCAL := SPACE(2)
ZPTIPO  := SPACE(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 151,134 To 575,790 Dialog oDlg Title OemToAnsi("Transfere Inventario para processamento")
@ 013,002 Say OemToAnsi("Data do Inventário")     Size 45,8
@ 025,002 Say OemToAnsi("Documento")              Size 45,8
@ 038,002 Say OemToAnsi("Local")                  Size 30,8
@ 051,002 Say OemToAnsi("Tipo (1/2/3)")           Size 45,8
@ 013,049 Get ZPDATA                              Size 50,10
@ 025,049 Get ZPDOC      Picture "@!"             Size 45,10
@ 038,049 Get ZPLOCAL    Picture "@!"             Size 20,10
@ 051,049 Get ZPTIPO     Picture "@!"             Size 20,10 Valid ZPTIPO $ "123"
@ 005,265 Button "_Confirma"                      Size 40,15 Action f_closeOk()
@ 025,265 Button "Cance_la"                       Size 40,15 Action Close(oDlg)

Activate Dialog oDlg

Return

*************************
Static Function f_closeOk()
*************************
Local cQry
Local nResult
Local lResp := MsgBox("Confirma a Transferência?","Selecione a Opção","YESNO")

IF ( lResp )
   dbSelectArea("SB2")
   dbSetOrder(1)
   *
   dbSelectArea("SBF")
   dbSetOrder(1)
   *
	cQry := "SELECT * FROM "+RetSqlName("SZP")+" ZP,"+RetSqlName("SB1")+" B1 "
	cQry += "WHERE ZP.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' ' "
	cQry += "AND ZP_FILIAL  = '"+xFilial("SZP")+"' "
	cQry += "AND ZP_DATA    = '"+DTOS(ZPDATA)+"' "
	cQry += "AND ZP_LOCAL   = '"+ZPLOCAL+"' "
	cQry += "AND ZP_CANCEL  = ' ' "
	cQry += "AND ZP_STATUS  = '"+ZPTIPO+"' "
	cQry += "AND B1_FILIAL  = '"+xFilial("SB1")+"' "
	cQry += "AND B1_COD     = ZP_COD "
	cQry += "ORDER BY ZP_COD,ZP_LOCALIZ "

	cQry := ChangeQuery(cQry)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TMP', .T., .T.)
		
   dbSelectArea("TMP")
	dbGoTop()
   DO WHILE !EOF()
		nResult := 0
		ZPCOD   := TMP->ZP_COD
		DO WHILE TMP->(!EOF()).AND.TMP->ZP_COD==ZPCOD
			IF ( !EMPTY(TMP->ZP_CONTAG) )
				nResult += TMP->ZP_RESULT
				IF ( TMP->ZP_RESULT > 0 )
					SBF->(dbSeek(xFilial("SBF")+ZPLOCAL+TMP->ZP_LOCALIZ+TMP->ZP_COD))
					IF ( SBF->(EOF()) )
						RecLock("SBF",.T.)
						SBF->BF_FILIAL  := xFilial("SBF")
						SBF->BF_LOCAL   := TMP->ZP_LOCAL
						SBF->BF_LOCALIZ := TMP->ZP_LOCALIZ
						SBF->BF_PRODUTO := TMP->ZP_COD
						SBF->BF_QUANT   := TMP->ZP_RESULT
						SBF->BF_DATAVEN := ZPDATA
						MsUnlock()												
					ENDIF
					dbSelectArea("TMP")
				ENDIF
			ENDIF
			dbSkip()
		ENDDO
		
		SB2->(dbSeek(xFilial("SB2")+ZPCOD+ZPLOCAL))
	
		IF ( SB2->(!EOF()) .AND. SB2->B2_QFIM <> nResult )
			RecLock("SB7",.T.)
			SB7->B7_FILIAL  := xFilial("SB7")
			SB7->B7_DATA    := ZPDATA
			SB7->B7_DTVALID := ZPDATA
			SB7->B7_COD     := ZPCOD
			SB7->B7_QUANT   := nResult
			SB7->B7_LOCAL   := ZPLOCAL
			SB7->B7_TIPO    := TMP->B1_TIPO
			SB7->B7_DOC     := ZPDOC
			MsUnlock()
		ENDIF
		
		dbSelectArea("TMP")     
		
   ENDDO
	
	TMP->(dbCloseArea())
	
	MsgInfo("Transferencia efetuada com sucesso.","Atenção")
	
   Close(oDlg)
	
ENDIF

Return