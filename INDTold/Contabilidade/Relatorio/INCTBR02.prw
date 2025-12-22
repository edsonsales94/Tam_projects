#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCTBR02  ºAutor  ³Ener Fredes         º Data ³  03/30/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de auditoria da Contabilidade                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function INCTBR02()
Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2     := "de acordo com os parametros informados pelo usuario."
Local cDesc3     := "Conferencia de Importacao do SIATA"
Local titulo     := "Auditoria de Lançamento Contábil"
Local nLin       := 80
Local Cabec1     := "                                                                                                                                  -------- Inclusao -------- -------- Alteracao -------"
Local Cabec2     := "Data       Lote      Doc    Lin Debito               Credito                       Valor Historico                                Usuario         Data       Usuario         Data      "
Local aOrd       := {}
Local cPerg      := Padr("INCTBR02",Len(SX1->X1_GRUPO))

Private limite   := 220
Private tamanho  := "G"
Private nomeprog := "INCTBR02"
Private nTipo    := 15
Private aReturn  := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey := 0
Private m_pag    := 01
Private wnrel    := "INCTBR02"
Private cString  := "CT2"

ValidPerg(cPerg)
pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo:= If(aReturn[4]==1,15,18)

Processa({|| ExecProc(Cabec1,Cabec2,Titulo,nLin) }, "Filtrando dados")
Return

Static function ExecProc(Cabec1,Cabec2,Titulo,nLin)
	Local cInd, cKey, cQry, nRegis
	
	cQry := "SELECT *, R_E_C_N_O_ AS CT2_RECNO FROM "+RetSqlName("CT2")
	cQry += " WHERE D_E_L_E_T_ <> '*'"
	cQry += " AND CT2_DATA BETWEEN '"+dtos(mv_par01)+"' AND  '"+dtos(mv_par02)+"'"
	cQry += " AND CT2_MANUAL = '1'
	cQry += " ORDER BY CT2_DATA"
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TINCTB", .T., .F. )
	TcSetField("TINCTB","CT2_DATA","D")
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,nRegis) },Titulo)
	
Return

Static function RunReport(Cabec1,Cabec2,Titulo,nLin,nRegis)
	Local cUserInc, dDateInc, cUserAlt, dDateAlt, cFiltro
	Local nRegis := 0
	
	dbSelectArea("TINCTB")
	dbgotop()
	
	//- Ativando a rotina de filtro
	If !Empty(aReturn[7])
		cFiltro:= Alltrim(aReturn[7])
		dbGoTop()
		SetRegua(RecCount())
		While !Eof()
			nRegis++
			IncRegua()
			If &(cFiltro)
			Else
				nRegis--
				Reclock("TINCTB",.f.)
				dbDelete()
				dbUnLock()
			Endif
			dbskip()
		Enddo
	Endif
	dbGoTop()
	
	SetRegua(nRegis)
	
	dbGoTop()
	
	While !TINCTB->(Eof())
		
		IncRegua()
		
		If Empty(TINCTB->CT2_USERGI)
			TINCTB->(DbSkip())
			Loop
		EndIf
		
		CT2->(dbGoTo(TINCTB->CT2_RECNO))
		
		cUserInc := PADR(FWLeUserLg("CT2_USERGI",1),15)
		dDateInc := FWLeUserLg("CT2_USERGI",2)
		cUserAlt := PADR(FWLeUserLg("CT2_USERGA",1),15)
		dDateAlt := FWLeUserLg("CT2_USERGA",2)
		
		If nLin > 60
			nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		Endif
		@ nLin,00       PSAY PADR(Dtoc(TINCTB->CT2_DATA),10)
		@ nLin,Pcol()+1 PSAY TINCTB->CT2_LOTE+TINCTB->CT2_SBLOTE
		@ nLin,Pcol()+1 PSAY TINCTB->CT2_DOC
		@ nLin,Pcol()+1 PSAY TINCTB->CT2_LINHA
		@ nLin,Pcol()+1 PSAY TINCTB->CT2_DEBITO
		@ nLin,Pcol()+1 PSAY TINCTB->CT2_CREDIT
		@ nLin,Pcol()+1 PSAY Transform(TINCTB->CT2_VALOR,"@E 999,999,999.99")
		@ nLin,Pcol()+1 PSAY TINCTB->CT2_HIST
		@ nLin,Pcol()+1 PSAY cUserInc
		@ nLin,Pcol()+1 PSAY dDateInc
		@ nLin,Pcol()+1 PSAY cUserAlt
		@ nLin,Pcol()+1 PSAY dDateAlt
		nLin++
		
		TINCTB->(DbSkip())
	Enddo
	dbCloseArea()
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return

Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01","Da Data                  ?","Da Data                  ?","Da Data                  ?","mv_ch1","D",08 ,0 ,0 ,"G","","","","","mv_par01","","","","","","","","","","","","","","","")
	u_INPutSX1(cPerg,"02","Ate a Data               ?","Ate a Data               ?","Ate a Data               ?","mv_ch2","D",08 ,0 ,0 ,"G","","","","","mv_par02","","","","","","","","","","","","","","","")
Return