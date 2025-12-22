#INCLUDE "TopConn.ch"
#INCLUDE "Protheus.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ HLBINVR08  ¦ Autor ¦ WILLIAMS MESSA       ¦ Data ¦ 18/06/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatório de divergência entre as contagens e saldos          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function HLBINVR8()


	LOCAL cArq := "INVR08", cInd
	Local cStartPath := GetSrvProfString("Startpath","")
	Local cPerg := "INVR08"
	Local cQuery := ""
	Local cPath:= "C:\Spool\"

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		Return Nil
	End If

	If Lastkey() == 27
		Return Nil
	End If

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))

	dbSelectArea("SB2")
	SB2->(dbSetOrder(1))

	cQuery := "SELECT NROETIQUETA,CENTRO_CUSTO,CODIGO,DESENHO,DESCRICAO,ARMAZEM,ENDERECO,DATAINV,DOC,ISNULL(SALDO,0)AS SALDO, "
	cQuery += " CONTAGEM01 = ISNULL(SUM(CASE WHEN CONTAGEM = '1'   THEN QUANT END),-1), "
	cQuery += " CONTAGEM02 = ISNULL(SUM(CASE WHEN CONTAGEM = '2'   THEN QUANT END),-1), "
	cQuery += " CONTAGEM03 = ISNULL(SUM(CASE WHEN CONTAGEM = '3'   THEN QUANT END),-1) FROM VW_CONTAGENS "
	cQuery += " WHERE NROETIQUETA !='' AND DELETADO ='' AND ARMAZEM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += " AND CENTRO_CUSTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND DATAINV = '"+Dtos(Mv_Par05)+"' "
	cQuery += " GROUP BY NROETIQUETA,CENTRO_CUSTO,CODIGO,DESENHO,DESCRICAO,ARMAZEM,ENDERECO,DATAINV,DOC,SALDO  "
	cQuery += " ORDER BY NROETIQUETA,CENTRO_CUSTO,CODIGO "

	MPSysOpenQuery( cQuery, "TRG" ) // dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TRG", .T., .F. )
	DbSelectArea("TRG")

	_aStru:={}//SD2SQL->(DbStruct())
	//Esturura de um arquivo físico temporário, base para planilha em excel.
	aadd( _aStru , {"NROETIQ"        , "C" , 06 , 00 } )
	aadd( _aStru , {"CENTROC"        , "C" , 09 , 00 } )
	aadd( _aStru , {"CODIGO"         , "C" , 15 , 00 } )
	aadd( _aStru , {"DESENHO"        , "C" , 15 , 00 } )
	aadd( _aStru , {"DESCING"        , "C" , 50 , 00 } ) // ADD ESTE CAMPO
	aadd( _aStru , {"DESCRICAO"      , "C" , 60 , 00 } )
	aadd( _aStru , {"ARMAZEM"        , "C" , 02 , 00 } )
	aadd( _aStru , {"ENDERECO"       , "C" , 15 , 00 } )
	aadd( _aStru , {"DATAINV"        , "D" , 08 , 00 } )
	aadd( _aStru , {"DOC"            , "C" , 06 , 00 } )
	aadd( _aStru , {"SALDO"          , "N" , 12 , 02 } )
	aadd( _aStru , {"CONTAGEM01"     , "N" , 12 , 02 } )
	aadd( _aStru , {"CONTAGEM02"     , "N" , 12 , 02 } )
	aadd( _aStru , {"CONTAGEM03"     , "N" , 12 , 02 } )
	aadd( _aStru , {"VLRCM1SB2"      , "N" , 18 , 06 } )  //ADD ESTE CAMPO

	//verifico se arquivo já existe deletando caso ele exista!
	fErase(cArq+".DBF")
	fErase(cArq+".IDX")

	// //Crio arquivo fisicamente
	// dbCreate(cArq,_aStru)
	// dbUseArea(.T.,,cArq,"TMP",.T.,.F.)

	// Instancio o objeto
	oTable  := FwTemporaryTable():New( "TMP" )
	// Adiciono os campos na tabela
	oTable:SetFields( _aStru )
	// Adiciono os índices da tabela
	// oTable:AddIndex( '01' , { "NR_DI+CD_PART_NU+INVOICE" })
	// Crio a tabela no banco de dados
	oTable:Create()

	//cInd:= CriaTrab(Nil,.F.)
	//IndRegua("TMP",cInd,"",,,"Selecionando registros...")

	dbSelectArea("TRG")
	dbGoTop()

	Do While TRG->(!Eof())

		dbSelectArea("SB1")
		SB1->(dbSeek(xFilial()+TRG->CODIGO))

		dbSelectArea("SB2")
		SB2->(dbSeek(xFilial()+TRG->CODIGO+TRG->ARMAZEM))

		dbSelectArea("TMP")

		Reclock("TMP",.T.)
		TMP->NROETIQ     := TRG->NROETIQUETA
		TMP->CENTROc     := TRG->CENTRO_CUSTO
		TMP->CODIGO      := TRG->CODIGO
		TMP->DESCING     := SB1->B1_DESCING     //SB1
		TMP->DESCRICAO   := TRG->DESCRICAO
		TMP->ARMAZEM     := TRG->ARMAZEM
		TMP->ENDERECO    := TRG->ENDERECO
		TMP->DATAINV     := STOD(TRG->DATAINV)
		TMP->DOC         := TRG->DOC
		TMP->SALDO       := TRG->SALDO
		TMP->CONTAGEM01  := TRG->CONTAGEM01
		TMP->CONTAGEM02  := TRG->CONTAGEM02
		TMP->CONTAGEM03  := TRG->CONTAGEM03
		TMP->VLRCM1SB2   := SB2->B2_CM1         //SB2

		MsUnlock()
		TRG->(DbSkip())
	Enddo
	//Checa para verificar se o excel esta instalado na maquina local.
	If !ApOleClient("MsExcel")
		MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
		TRG->(dbCloseArea())
		Return
	EndIf
	//Fecha o arquivo temporário,dbf que foi criado.
	DbSelectArea("TMP")
	TMP->(DbCloseArea())
	//Ferase(cInd)
	//Copia o arquivo dbf para a maquina local renomeando para abir no excell
	//MsgRun("Copiando arquivo...",,{||__CopyFile(cStartPath + cArq +".DBF",cPath+cArq+".xls")})
	MsgRun("Copiando arquivo...",,{||__CopyFile("\SYSTEM\ESTOQUE\INVR08.xls","C:\Spool\INVR08.xls")})
	//Chama o Excell, criando uma nova instancia do objeto!
	oExcelApp:= MsExcel():New()
	oExcelApp:WorkBooks:Open("C:\Spool\INVR08.xls")
	oExcelApp:SetVisible(.T.)
	//Fecha o arquivo
	TRG->(dbCloseArea())

Return Nil
/*_______________________________________________________________________________
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Williams Messa           ¦ Data ¦ 16/03/2009 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Criação das perguntas da rotina.                                  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)
	PutSX1(cPerg,"01","Do Armazem           ","","","mv_ch1","C",02,0,0,"G","",""   ,"","","mv_par01")
	PutSX1(cPerg,"02","Ate Armazem          ","","","mv_ch2","C",02,0,0,"G","",""   ,"","","mv_par02")
	PutSX1(cPerg,"03","Do Centro de Custo   ","","","mv_ch3","C",09,0,0,"G","","CTT","","","mv_par03")
	PutSX1(cPerg,"04","Ate o Centro de Custo","","","mv_ch4","C",09,0,0,"G","","CTT","","","mv_par04")
	PutSX1(cPerg,"05","Data do Inventário?  ","","","mv_ch5","D",08,0,0,"G","",""   ,"","","mv_par05")
Return Nil
