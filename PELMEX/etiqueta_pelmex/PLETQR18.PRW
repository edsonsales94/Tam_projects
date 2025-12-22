#Include "rwmake.ch"
#include "fileio.ch"

/*___________________________________________________________________________________
¦ Função    ¦ PLETQR01   ¦ Autor ¦ Stan Lee Lopes           ¦ Data ¦ 22/01/2019     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Impressão da Etiqueta produto no armazem Pelmex (producao)            ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLETQR18(cNumOP,cSeq)
	Local oDlg
	Local cPerg := "PLETQR18"

	If cNumOP == Nil
		ValidPerg(cPerg)
		Pergunte(cPerg,.F.)

		@ 96,042 TO 323,505 DIALOG oDlg TITLE "Geração de Etiquetas"
		@ 08,010 TO 84,222

		@ 23,014 SAY "Esta rotina irá imprimir as informações das "
		@ 33,014 SAY "etiquetas da Pelmex."

		@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg)
		@ 91,168 BMPBUTTON TYPE 1 ACTION (EtqPel01a(cSeq),oDlg:End())
		@ 91,196 BMPBUTTON TYPE 2 ACTION oDlg:End()

		ACTIVATE DIALOG oDlg CENTERED
	Else    
		//mv_par01 := PADR(AllTrim(cNumOP),Len(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))
		//mv_par02 := 1
		//mv_par03 := PADR(AllTrim(cNumOP),Len(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)))

		EtqPel01a(cSeq)
	Endif

Return Nil

/*_______________________________________________________________________________
¦ Função    ¦ ETQHPEL1a  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 08/04/2008 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Distribuição das tarefas                          
¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EtqPel01a(cSeq)
	Local LRET := .F.
	MsgRun("Preparando Ambiente..." ,"Aguarde...",{|| LRET := EtqPel01b()     })

	if LRET
		RptStatus({|| EtqPel01c(cSeq)}, "Aguarde...", "Imprimindo Etiquetas....")
	endif
	
Return Nil

/*________________________________________________________________________________
¦ Função    ¦ EtqPel01b  ¦ Autor   | Stan Lee Lopes          ¦ Data ¦ 22/01/2019 ¦
+-----------+------------+---------+-------------------------+------+------------+
¦ Descriçäo ¦ Montagem da query para leitura das OP's abertas                    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EtqPel01b()
	Local cQry
	
	cQry := " SELECT CB0.*,CONVERT(VARCHAR,GETDATE(),103) DATAPROD "
	cQry += " FROM " + RetSQLName("CB0") + " CB0 "
	cQry += " WHERE CB0_OP BETWEEN '" + mv_par01+ "' AND '" + mv_par02+ "' "
	cQry += " AND D_E_L_E_T_ = ''"
	cQry += " ORDER BY CB0_OP"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)), "ETQ", .T., .T.)

	Etq->(dbGotop())

	IF Empty(Etq->CB0_CODETI)
		FwAlertWarning('Não foi encontrada nenhuma etiquetas geradas para a OP informada, verifique se a OP está correta e tente novamente.','Atenção !')
		Return .F.
	endif
	
Return .T.

/*________________________________________________________________________________
¦ Função    ¦ EtqPel01c  ¦ Revisão | Stan Lee Lopes          ¦ Data ¦ 22/01/2019 ¦
+-----------+------------+---------+-------------------------+------+------------+
¦ Descriçäo ¦ Impressão das Etiquetas.                                           ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function EtqPel01c(cSeq)
	Local cCodEmp  := FWCodEmp()			
	Local lOk      := .T.
	
	Etq->(dbGotop())

	While !Etq->(Eof()) .And. lOk

		MsCbPrinter("RZ400","LPT3",,,.F.,,,,)
		MsCbChkStatus(.F.)
		MsCbBegin( 1, 6)

		if cCodEmp = '10'
			DbSelectArea('SB1')
			dbSetOrder(1)
			SB1->(DBSEEK(XFILIAL('SB1')+Etq->CB0_CODPRO))

			MSCBWRITE("CT~~CD,~CC^~CT~")
			MSCBWRITE("CT~~CD,~CC^~CT~ ")
			MSCBWRITE("^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2~SD10^JUS^LRN^CI0^XZ ")
			MSCBWRITE("^XA ")
			MSCBWRITE("^MMF ")
			MSCBWRITE("^PW799 ")
			MSCBWRITE("^LL0320 ")
			MSCBWRITE("^LS0 ")
			MSCBWRITE("^FT32,171^A0N,28,28^FH\^FD"+Etq->CB0_CODETI+"^FS ")
			MSCBWRITE("^FT31,129^A0N,28,28^FH\^FD"+SB1->B1_DESC+"^FS ")
			MSCBWRITE("^FT31,90^A0N,28,28^FH\^FD"+Etq->CB0_CODPRO+"^FS ")
			MSCBWRITE("^PQ1,0,1,Y^XZ ")

			MsCbEnd()
			MsCbClosePrinter()
		EndIf


		Etq->(dbSkip())
	Enddo
	Etq->(dbCloseArea())

Return .T.


/*_______________________________________________________________________________
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 23/11/2006 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Criação das Perguntas SX1                                         ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)
	u_InPutSX1(cPerg,"01","Op De?		 ","", "", "mv_ch1","C",14,0,0,"G","","CB0OP","","","mv_par01")
	u_InPutSX1(cPerg,"02","Op Até?	 	 ","", "", "mv_ch2","C",14,0,0,"G","","CB0OP","","","mv_par02")
	// u_InPutSX1(cPerg,"03","Quantidade impressa?	 	 ","", "", "mv_ch3","N",4,0,0,"G","","","","","mv_par03")
	// u_InPutSX1(cPerg,"04","Quantidade na caixa?	 	 ","", "", "mv_ch4","C",14,6,0,"G","","","","","mv_par04")
Return Nil
