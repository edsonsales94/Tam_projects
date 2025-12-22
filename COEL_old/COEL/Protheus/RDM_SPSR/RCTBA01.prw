#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RCTBA01  ³ Autor ³ Ricardo Correa de Souza ³ Data ³ 23/09/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Limpa Lancamentos Contabeis e Flags de Contabilizacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Scenika Diagnosticos Ltda                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCTBA01()

@ 200,1 TO 430,500 DIALOG oDlg1 TITLE "LIMPEZA DOS REGISTROS CONTABILIZADOS VIA LANCAMENTO PADRAO"
@ 5,08 TO 90,240

@ 035,040 Say OemtoAnsi("Esta rotina tem o objetivo de limpar os registros contabilizados para que sejam")
@ 055,040 Say OemtoAnsi("reprocessados atraves da contabilizacao off-line conforme parametro selecionado")

@ 98,130 BMPBUTTON TYPE 05 ACTION Pergunte("CTBA01",.T.)
@ 98,170 BMPBUTTON TYPE 01 ACTION LimFin1()
@ 98,210 BMPBUTTON TYPE 02 ACTION Close(oDlg1)

Pergunte("CTBA01",.F.)

ACTIVATE DIALOG oDlg1 CENTERED

Return(nil)

Static Function Limfin1()

Processa({|lend| LimpFin2()},"Alterando")

MsgInfo("Limpeza efetuada com sucesso!!!","Aviso ")

Close(oDlg1)

Return

Static Function LimpFin2()
Private _Query := ""

If     Mv_Par03 == 1
	LimpaTudo()
ElseIf Mv_Par03 == 2
	LimpaFin()
ElseIf Mv_Par03 == 3
	LimpaFat()
ElseIf Mv_Par03 == 4
	LimpaCom()
Endif

Return

Static Function LimpaTudo()

#IFDEF TOP
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag do Contas a Receber³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	_Query:="UPDATE  "+RetSQLName("SE1")+" SET E1_LA= ''"
	_Query+="WHERE E1_EMISSAO >='"+DTOS(MV_PAR01)+"' AND E1_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="E1_FILIAL >='"+MV_PAR04+"' AND E1_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="E1_ORIGEM LIKE '%FINA%' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag do Contas a Pagar ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SE2")+" SET E2_LA= '' "
	_Query+="WHERE E2_EMISSAO >='"+DTOS(MV_PAR01)+"' AND E2_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="E2_FILIAL >='"+MV_PAR04+"' AND E2_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="E2_ORIGEM LIKE '%FINA%' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag da Mov. Bancaria ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SE5")+" SET E5_LA = ''  "
	_Query+="WHERE E5_DATA >='"+DTOS(MV_PAR01)+"' AND E5_DATA <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="E5_FILIAL >='"+MV_PAR04+"' AND E5_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="E5_MOTBX<>'DAC'  AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag do Cad. de Cheques ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SEF")+" SET EF_LA = '' "
	_Query+="WHERE EF_DATA >='"+DTOS(MV_PAR01)+"' AND EF_DATA <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="EF_FILIAL >='"+MV_PAR04+"' AND EF_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Entrada - Cabecalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SF1")+" SET F1_CPROVA = '', F1_DTLANC = ''  "
	_Query+="WHERE F1_DTDIGIT >='"+DTOS(MV_PAR01)+"' AND F1_DTDIGIT <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="F1_FILIAL >='"+MV_PAR04+"' AND F1_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	/*
	// ESPECIFICO
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Entrada - Itens ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SD1")+" SET D1_CONTA = '  ' "
	_Query+="WHERE D1_DTDIGIT >='"+DTOS(MV_PAR01)+"' AND D1_DTDIGIT <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Saida - Cabecalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SF2")+" SET F2_DTLANC = ''"
	_Query+="WHERE F2_EMISSAO>='"+DTOS(MV_PAR01)+"' AND F2_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="F2_FILIAL >='"+MV_PAR04+"' AND F2_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	// Alterado por Paulo Henrique - Microsiga - em 08/11/2001
	// Incluida a Limpeza para Notas Fiscais de Saida
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Saida - Itens ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SD2")+" SET D2_CONTA = '  '"
	_Query+="WHERE D2_EMISSAO>='"+DTOS(MV_PAR01)+"' AND D2_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	*/
	
#ELSE
	
	dbSelectArea("SE1")
	dbSetOrder(6)
	// Alterado por Cláudio retirado o IF e o Endif
	dbSeek(xFilial()+DTOS(MV_PAR01),.T.)
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof() .And. SE1->E1_EMISSAO >= MV_PAR01 .And. SE1->E1_EMISSAO <= MV_PAR02
		IncProc("Alterando Contas a Receber....")
		If SE1->E1_ORIGEM $ "FINA"
			dbSelectArea("SE1")
			RecLock("SE1",.F.)
			SE1->E1_LA := " "
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag do Contas a Pagar ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder(5)
	// Alterado por Cláudio retirado o IF e o Endif
	dbSeek(xFilial()+DTOS(MV_PAR01),.T.)
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof() .And. SE2->E2_EMISSAO >= MV_PAR01 .And. SE2->E2_EMISSAO <= MV_PAR02
		IncProc("Alterando Contas a Pagar....")
		If SE2->E2_ORIGEM $ "FINA"
			RecLock("SE2",.F.)
			SE2->E2_LA := " "
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag da Mov. Bancaria ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE5")
	dbSetOrder(1)
	// Alterado por Cláudio retirado o IF e o Endif
	dbSeek(xFilial()+DTOS(MV_PAR01),.T.)
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof() .And. SE5->E5_DATA >= MV_PAR01 .And. SE5->E5_DATA <= MV_PAR02
		
		IncProc("Alterando Movimento Bancario....")
		IF E5_MOTBX <> "DAC"
			RecLock("SE5",.F.)
			SE5->E5_LA    := " "
			MsUnlock()
			dbSkip()
		Endif
		
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag do Cad. de Cheques ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SEF")
	dbSetOrder(1)
	DbGotop()
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof()
		IncProc("Alterando Cadastro de Cheque....")
		If SEF->EF_DATA >= MV_PAR01 .And. SEF->EF_DATA <= MV_PAR02
			dbSelectArea("SEF")
			RecLock("SEF",.F.)
			SEF->EF_LA := " "
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Entrada - Cabecalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF1")
	DbOrderNickName("SF1_DATA")
	
	//dbSetOrder(6)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cláudio retirado o IF e o Endif
	// Alterado por Cláudio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SF1->F1_DTDIGIT >= Mv_Par01 .And. SF1->F1_DTDIGIT <= Mv_Par02 .And. !Eof()
		IncProc("Alterando Cabecalho de Nf. De Entrada....")
		RecLock("SF1",.F.)
		SF1->F1_CPROVA := " "
		SF1->F1_DTLANC := Ctod(Space(08))
		MsUnlock()
		dbSkip()
	Enddo
	
	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Entrada - Itens ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD1")
	// Alterado por Cláudio de indice 6 para 11 em 27/11/01
	dbSetOrder(6)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cláudio retirado o IF e o Endif
	// Alterado por Cláudio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SD1->D1_DTDIGIT >= Mv_Par01 .And. SD1->D1_DTDIGIT <= Mv_Par02 .And. !Eof()
	IncProc("Alterando Itens de Nota Fiscal de Entrada....")
	RecLock("SD1",.F.)
	SD1->D1_CONTA := " "
	MsUnlock()
	dbSkip()
	Enddo
	*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Saida - Cabecalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	dbSetOrder(7)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cláudio retirado o IF e o Endif
	// Alterado por Cláudio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SF2->F2_EMISSAO >= Mv_Par01 .And. SF2->F2_EMISSAO <= Mv_Par02 .And. !Eof()
		IncProc("Alterando Cabecalho de Nf. De Saida....")
		RecLock("SF2",.F.)
		SF2->F2_DTLANC := Ctod(Space(08))
		MsUnlock()
		dbSkip()
	Enddo
	
	/*
	// Alterado por Paulo Henrique - Microsiga - em 08/11/2001
	// Incluida a Limpeza para Notas Fiscais de Saida
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Saida - Itens ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SD2")
	dbSetOrder(5)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cláudio retirado o IF e o Endif
	// Alterado por Cláudio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SD2->D2_EMISSAO >= Mv_Par01 .And. SD2->D2_EMISSAO <= Mv_Par02 .And. !Eof()
	IncProc("Alterando Itens de Nota Fiscal de Saida....")
	RecLock("SD2",.F.)
	SD2->D2_CONTA := ""
	MsUnlock()
	dbSkip()
	Enddo
	*/
	
#ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa Lancamentos Contábeis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LimpaCont()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LimpaFin ³ Autor ³ Almeida               ³ Data ³ 03/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Limpa Contabilizacao do Financeiro                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function LimpaFin()


#IFDEF TOP
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag do Contas a Receber³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	_Query:="UPDATE  "+RetSQLName("SE1")+" SET E1_LA= ''"
	_Query+="WHERE E1_EMISSAO >='"+DTOS(MV_PAR01)+"' AND E1_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="E1_FILIAL >='"+MV_PAR04+"' AND E1_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="E1_ORIGEM LIKE '%FINA%' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag do Contas a Pagar ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SE2")+" SET E2_LA= '' "
	_Query+="WHERE E2_EMISSAO >='"+DTOS(MV_PAR01)+"' AND E2_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="E2_FILIAL >='"+MV_PAR04+"' AND E2_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="E2_ORIGEM LIKE '%FINA%' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag da Mov. Bancaria ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SE5")+" SET E5_LA=''  "
	_Query+="WHERE E5_DATA >='"+DTOS(MV_PAR01)+"' AND E5_DATA <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="E5_FILIAL >='"+MV_PAR04+"' AND E5_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="E5_MOTBX<>'DAC'  AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag do Cad. de Cheques ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SEF")+" SET EF_LA='' "
	_Query+="WHERE EF_DATA >='"+DTOS(MV_PAR01)+"' AND EF_DATA <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="EF_FILIAL >='"+MV_PAR04+"' AND EF_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
#ELSE
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag do Contas a Receber ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(6)
	// Alterado por Cláudio retirado o IF e o Endif
	dbSeek(xFilial()+DTOS(MV_PAR01),.T.)
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof() .And. SE1->E1_EMISSAO >= MV_PAR01 .And. SE1->E1_EMISSAO <= MV_PAR02
		IncProc("Alterando Contas a Receber....")
		If SE1->E1_ORIGEM $ "FINA"
			dbSelectArea("SE1")
			RecLock("SE1",.F.)
			SE1->E1_LA := " "
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag do Contas a Pagar ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder(5)
	// Alterado por Cláudio retirado o IF e o Endif
	dbSeek(xFilial()+DTOS(MV_PAR01),.T.)
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof() .And. SE2->E2_EMISSAO >= MV_PAR01 .And. SE2->E2_EMISSAO <= MV_PAR02
		IncProc("Alterando Contas a Pagar....")
		If SE2->E2_ORIGEM $ "FINA"
			RecLock("SE2",.F.)
			SE2->E2_LA := " "
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag do Cad. de Cheques ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SEF")
	dbSetOrder(1)
	dbGotop()
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof()
		IncProc("Alterando Cadastro de Cheque....")
		If SEF->EF_DATA >= MV_PAR01 .And. SEF->EF_DATA <= MV_PAR02
			dbSelectArea("SEF")
			RecLock("SEF",.F.)
			SEF->EF_LA := ""
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag da Mov. Bancaria ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE5")
	dbSetOrder(1)
	// Alterado por Cláudio retirado o IF e o Endif
	dbSeek(xFilial()+DTOS(MV_PAR01),.T.)
	nrec := LastRec()
	ProcRegua(nrec)
	While !Eof() .And. SE5->E5_DATA >= MV_PAR01 .And. SE5->E5_DATA <= MV_PAR02
		IncProc("Alterando Movimento Bancario ....")
		IF E5_MOTBX <> "DAC"
			RecLock("SE5",.F.)
			SE5->E5_LA    := " "
			MsUnlock()
		Endif
		dbSkip()
	EndDo
	
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa Lancamentos Contábeis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LimpaCont()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LimpaFat ³ Autor ³ Almeida               ³ Data ³ 08/11/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Limpa Contabilização do Faturamento                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function LimpaFat()

#IFDEF TOP
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Saida - Cabecalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SF2")+" SET F2_DTLANC ='' "
	_Query+="WHERE F2_EMISSAO >='"+DTOS(MV_PAR01)+"' AND F2_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="F2_FILIAL >='"+MV_PAR04+"' AND F2_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Saida - Itens ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SD2")+" SET D2_CONTA='' "
	_Query+="WHERE D2_EMISSAO >='"+DTOS(MV_PAR01)+"' AND D2_EMISSAO <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="D2_FILIAL >='"+MV_PAR04+"' AND D2_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
#ELSE
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Saida - Cabecalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	dbSetOrder(6)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cláudio retirado o IF e o Endif
	// Alterado por Cláudio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SF2->F2_EMISSAO >= Mv_Par01 .And. SF2->F2_EMISSAO <= Mv_Par02 .And. !Eof()
		IncProc("Alterando Cabecalho de Nf. De Saida....")
		RecLock("SF2",.F.)
		SF2->F2_DTLANC := Ctod(Space(08))
		MsUnlock()
		dbSkip()
	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Saida - Itens ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SD2")
	dbSetOrder(5)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cláudio retirado o IF e o Endif
	// Alterado por Cláudio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SD2->D2_EMISSAO >= Mv_Par01 .And. SD2->D2_EMISSAO <= Mv_Par02 .And. !Eof()
		IncProc("Alterando Itens de Nota Fiscal de Saida....")
		RecLock("SD2",.F.)
		SD2->D2_CONTA := ""
		MsUnlock()
		dbSkip()
	Enddo
	
#endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa Lancamentos Contábeis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LimpaCont()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LimpaCom ³ Autor ³ Almeida               ³ Data ³ 03/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Limpa Contablização do Compras                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function LimpaCom()

#IFDEF TOP
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Entrada - Cabecalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SF1")+" SET F1_CPROVA ='',F1_DTLANC='' "
	_Query+="WHERE F1_DTDIGIT >='"+DTOS(MV_PAR01)+"' AND F1_DTDIGIT <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="F1_FILIAL >='"+MV_PAR04+"' AND F1_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Entrada - Itens ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_Query:="UPDATE  "+RetSQLName("SD1")+" SET D1_CONTA ='' "
	_Query+="WHERE D1_DTDIGIT >='"+DTOS(MV_PAR01)+"' AND D1_DTDIGIT <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="D1_FILIAL >='"+MV_PAR04+"' AND D1_FILIAL <= '"+MV_PAR05+"' AND "
	_Query+="D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
#ELSE
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Entrada - Cabecalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF1")
	DbOrderNickName("SF1_DATA")
	//dbSetOrder(6)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cláudio retirado o IF e o Endif
	// Alterado por Cláudio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SF1->F1_DTDIGIT >= Mv_Par01 .And. SF1->F1_DTDIGIT <= Mv_Par02 .And. !Eof()
		IncProc("Alterando Cabecalho de Nf. De Entrada....")
		RecLock("SF1",.F.)
		SF1->F1_CPROVA := " "
		SF1->F1_DTLANC := Ctod(Space(08))
		MsUnlock()
		dbSkip()
	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpa Flag das NFS. de Entrada - Itens ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SD1")
	//Alterado por Cláudio de indice 6 para 11 em 27/11/01
	dbSetOrder(6)
	dbGoTop()
	nRec := LastRec()
	ProcRegua(nRec)
	// Alterado por Cláudio retirado o IF e o Endif
	// Alterado por Cláudio incluso no comando SEEK o campo ".T." em 27/11/01
	dbSeek(xFilial()+DTOS(Mv_Par01),.T.)
	While SD1->D1_DTDIGIT >= Mv_Par01 .And. SD1->D1_DTDIGIT <= Mv_Par02 .And. !Eof()
		IncProc("Alterando Itens de Nota Fiscal de Entrada....")
		RecLock("SD1",.F.)
		SD1->D1_CONTA := " "
		MsUnlock()
		dbSkip()
	Enddo
	
#endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa Lancamentos Contábeis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LimpaCont()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LimpaCont³ Autor ³ Alexandro da Silva    ³ Data ³ 03/08/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Limpa Lançamentos Contábeis do Financeiro, Faturamento e   ³±±
±±³          ³ Compras ou em todos os módulos citados                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function LimpaCont()
Local _areasmo := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa Flag da Mov. Contabil ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	
	
	_query:="DELETE FROM "+RetSQLName("CT2")
	_query+=" WHERE CT2_DATA >='"+DTOS(MV_PAR01)+"' AND CT2_DATA <='"+DTOS(MV_PAR02)+"' AND "
	_Query+="CT2_FILIAL >='"+MV_PAR04+"' AND CT2_FILIAL <= '"+MV_PAR05+"' AND "
	if     mv_par03 == 1
		_query+="CT2_LOTE IN('008810','008811','008820','008821','008850','008851') AND "
	elseif mv_par03 == 2
		_query+="CT2_LOTE IN('008850','008851') AND "
	elseif mv_par03 == 3
		_query+="CT2_LOTE IN('008820','008821') AND "
	elseif mv_par03 == 4
		_query+="CT2_LOTE IN('008810','008811') AND "
	endif
	
	/*
	if mv_par03 <> 2  // financeiro
		_query+="CT2_FILIAL ='"+xfilial("CT2")+"' AND "
	endif
	*/
	_query+=" D_E_L_E_T_<>'*'"
	TCSQLEXEC(_Query)
	
	
#ELSE
	
	
	if mv_par03 <> 2  // financeiro
		
		dbselectarea("si2")
		dbsetorder(3)
		dbgotop()
		nrec := lastrec()
		procregua(nrec)
		// alterado por cláudio retirado o if e o endif
		dbseek(xfilial()+dtos(mv_par01),.t.)
		while si2->i2_data >= mv_par01 .and. si2->i2_data <= mv_par02 .and. !eof()
			incproc("deletando registros na mov. contabil....")
			if     mv_par03 == 1
				_clotecon := "8810/8820/8850"
			elseif mv_par03 == 2
				_clotecon := "8850"
			elseif mv_par03 == 3
				_clotecon := "8820"
			elseif mv_par03 == 4
				_clotecon := "8810"
			endif
			
			if si2->i2_lote $ _clotecon
				dbselectarea("si2")
				reclock("si2",.f.)
				dbdelete()
				msunlock()
			endif
			dbskip()
		enddo
		
	else
		
		dbselectarea("sm0")
		_areasmo:=getarea()
		
		dbgotop()
		
		while !eof()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³retorna a filial corrente.                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cfilant:= cfilial:= SM0->M0_CODFIL
			
			dbselectarea("si2")
			dbsetorder(3)
			dbgotop()
			nrec := lastrec()
			procregua(nrec)
			// alterado por cláudio retirado o if e o endif
			dbseek(xfilial()+dtos(mv_par01),.t.)
			while si2->i2_data >= mv_par01 .and. si2->i2_data <= mv_par02 .and. !eof()
				incproc("deletando registros na mov. contabil....")
				if     mv_par03 == 1
					_clotecon := "8810/8820/8850"
				elseif mv_par03 == 2
					_clotecon := "8850"
				elseif mv_par03 == 3
					_clotecon := "8820"
				elseif mv_par03 == 4
					_clotecon := "8810"
				endif
				
				if si2->i2_lote $ _clotecon
					dbselectarea("si2")
					reclock("si2",.f.)
					dbdelete()
					msunlock()
				endif
				dbskip()
			enddo
			
			dbselectarea("sm0")
			sm0->(DBSKIP())
			
		enddo
		
		dbselectarea("sm0")
		RestArea(_areasmo)
		cfilant:= cfilial:= SM0->M0_CODFIL
		
	endif
	
#endif

Return
