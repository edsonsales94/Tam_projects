#include "protheus.ch"

//Rotina principal

/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Programa  ¦ PLFATC01   ¦ Autor ¦ Adson Carlos           ¦ Data ¦ 07/10/2013 ¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Descriçäo ¦ Cadastro de Usuario por Franqueados       					    ¦¦¦
¦¦+-----------+-----------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function PLFATC01()
	Local   cCondic   := "Z5_CLIENTE = '      '"
	Private nIni      := 0
	Private cCadastro := "Cadastro de Franqueados "
	Private aRotina   := {}
	Private aAreaz    := GetArea()
	Private aAlter    := {"Z5_CLIENTE"}

	AADD( aRotina, {"Pesquisar"  ,"AxPesqui" ,0,1})
	AADD( aRotina, {"Visualizar" ,'U_PLFC01in',0,2})
	AADD( aRotina, {"Incluir"    ,'U_PLFC01IN',0,3})
	AADD( aRotina, {"Alterar"    ,'U_PLFC01IN',0,4})
	AADD( aRotina, {"Excluir"    ,'U_PLFC01IN',0,5})

	dbSelectArea("SZ5")
	dbSetOrder(1)
	dbSetFilter( {|| &CCONDIC} , cCondic)
	dbGoTop()

	MBrowse(,,,,"SZ5")
	RestArea(aAreaz)
Return


//Rotina de inclusão

//-------------------------------------------------------------------
//-                   Rotina de criação do aCol                     -
//-			Desenvolvida por: Adson Carlos		Data: 07/10	        -
//-------------------------------------------------------------------

User Function PLFC01IN( cAlias, nReg, nOpc )
	Local oDlg, oPanelT
	Local cLinOk    := "AllwaysTrue", cFieldOk := 'AllwaysTrue', cSuperDel:= 'AllwaysTrue', cDelOk := 'AllwaysTrue'
	Local  cCondic  := "Z5_CLIENTE <> '      '"  
	Local  cCondi2  := "Z5_CLIENTE = '      '"  
	Local nParam    := nOpc
	Local aArea     := GetArea()              
	Local nOpcNewGd	:= iif ( nopc <> 2 ,( GD_INSERT + GD_UPDATE + GD_DELETE	),0)

	Private oGet    := Nil
	Private cCodigo := iIF (NOPC = 3 ,Space(Len(__cUserID)) , SZ5->Z5_IDUSER)
	Private cNome   := IIF (NOPC = 3 ,Space(Len(UsrRetName(__cUserID))), SZ5->Z5_DESCUSR)
	Private cSeqPEd := IIF (NOPC = 3 ,Space(1) , SZ5->Z5_SEQPED)

	Private aHead := {}
	Private aCOL  := {}

	dbSetFilter( {|| &cCondic} , cCondic )
	DbGoTop()

	MontaCol()
	nIni := Len(aCol)

	DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 28,80 PIXEL OF oMainWnd

	@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 10,241 OF oDlg CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_BOTTOM

	@ 4, 006 SAY "Código:"  SIZE 70,7 PIXEL OF oPanelT
	@ 4, 072 SAY "Nome:"    SIZE 70,7 PIXEL OF oPanelT
	@ 4, 196 SAY "Seq Ped:" SIZE 70,7 PIXEL OF oPanelT

	@ 3, 026 MSGET cCodigo SIZE 030,7 PIXEL OF oPanelT F3 "US2" when nOpc=3 //vALID fPermite(@ccodigo)
	@ 3, 090 MSGET cNome SIZE 78,7 PIXEL OF oPanelT  When .F.
	@ 3, 222 MSGET cSeqPEd PICTURE "@!" SIZE 40,7 PIXEL OF oPanelT when nOpc=3

	oGet := MsNewGetDados():New( 20, 20, 180 , 300, nOpcNewGd , cLinOk,"","",aAlter,,999,cFieldOk, cSuperDel,cDelOk, oPanelT, @aHead, @aCol)

	ACTIVATE MSDIALOG oDlg CENTER ON INIT ;
	EnchoiceBar(oDlg,{|| PATECWrt(nIni, aClone(oGet:aCols), aClone(oGet:aHeader), nOpc), dbSetFilter( {|| &cCondi2} , cCondi2 ),oDlg:End()}, {|| dbSetFilter( {|| &cCondi2} , cCondi2 ),oDlg:End()}) 

	RestArea(aArea)

Return

//-------------------------------------------------------------------
//-                   Rotina de criação do aCol                     -
//-			Desenvolvida por: Adson Carlos		Data: 07/10	        -
//-------------------------------------------------------------------
Static Function MontaCol()
	Local nCols:=0, nUsado, nX, nPos

	CriaHead()
	nUsado := Len(aHead)
	dbSelectArea("SZ5")
	dbSetOrder(1)
	dbSeek(xFilial("SZ5") + cCodigo)
	While ((!Eof()) .And. (SZ5->Z5_FILIAL = xFilial("SZ5")) .And. (SZ5->Z5_IDUSER = cCodigo) )
		aAdd(aCol,Array(nUsado+1))
		nCols++
		For nX := 1 To nUsado
			If (aHead[nX][10] != "V")
				aCol[nCols][nX] := FieldGet(FieldPos(aHead[nX][2]))
			Else
				aCol[nCols][nX] := CriaVar(aHead[nX][2],.T.)
			Endif
		Next nX
		aCol[nCols][nUsado+1] := .F.
		dbSkip()
	Enddo
Return .T.
//-------------------------------------------------------------------
//-		  	   Rotina de criação do aHead                           -
//-			Desenvolvida por: Adson Carlos		Data: 07/10	        -
//-------------------------------------------------------------------
Static Function CriaHead()
	Local nUsado  := 0
	Local cCampos := "Z5_CLIENTE, Z5_NOME"

	aHead := {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZ5")
	While ((!Eof()) .And. (SX3->X3_ARQUIVO == "SZ5"))
		If ((X3USO(SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .And. (Trim(X3_CAMPO) $ cCampos))
			aAdd(aHead, {Trim(X3Titulo()), ;
			SX3->X3_CAMPO   ,;
			SX3->X3_PICTURE ,;
			SX3->X3_TAMANHO ,;
			SX3->X3_DECIMAL ,;
			SX3->X3_VALID   ,;
			SX3->X3_USADO   ,;
			SX3->X3_TIPO    ,;
			SX3->X3_F3      ,;
			SX3->X3_CONTEXT ,;
			SX3->X3_CBOX    ,;
			SX3->X3_RELACAO ,;
			SX3->X3_WHEN    ,;
			SX3->X3_VISUAL  ,;
			SX3->X3_VLDUSER ,;
			SX3->X3_PICTVAR })
			nUsado++
		Endif
		dbSkip()
	EndDo
Return Nil


//Efetivação da inclusão

//-------------------------------------------------------------------
//-                  Rotina de gravação do aCol	                    -
//-			Desenvolvida por: Adson Carlos		Data: 07/10	        -
//-------------------------------------------------------------------
Static Function PATECWrt(nIni, aCols2, aHeader2, nOption)
	Local nI
	Local   cCondic   := "Z5_CLIENTE <> '      '"
	Local   aArea     := GetArea()

	Begin Sequence

		IF nOption <> 2

			iF nOption = 5   

				cCondic   := " .T. "  
				dbSelectArea("SZ5")
				dbSetFilter( {|| &CCONDIC} , cCondic)
				dbSetOrder(1)
				DbGoTop()
				dbSeek(xFilial("SZ5") + cCodigo) 
				While ((!Eof()) .And. (SZ5->Z5_FILIAL = xFilial("SZ5")) .And. (SZ5->Z5_IDUSER = cCodigo) )
					If (RecLock("SZ5", .F.))
						dbDelete()		
						SZ5->(MsUnlock())
					Endif
					SZ5->(dbSkip())  
				endDo

			Else

				dbSelectArea("SZ5")
				dbSetFilter( {|| &CCONDIC} , cCondic)
				dbSetOrder(1)
				DbGoTop()
				dbSeek(xFilial("SZ5") + cCodigo)

				//Alteração e Exclusão
				For nI := 1 to nIni
					If (aCols2[nI][Len(aHeader2)+1] == .T.) //Caso tenha sido excluído
						If (RecLock("SZ5", .F.))
							SZ5->(dbDelete())
							SZ5->(MsUnlock())
						endif
					Elseif (!SZ5->(EOF()) .And. (SZ5->Z5_FILIAL = xFilial("SZ5"))) //Caso tenha ocorrido alguma alteração
						If (RecLock("SZ5", .F.))
							SZ5->Z5_CLIENTE := aCols2[nI][01]
							SZ5->Z5_NOME    := aCols2[nI][02]
							SZ5->(MsUnlock())
						Endif
					EndIf
					SZ5->(dbSkip())
				Next nI

				//Inclusão
				iF nOption = 3
					RecLock("SZ5", .T.)
					SZ5->Z5_FILIAL  := xFilial("SZ5")
					SZ5->Z5_IDUSER  := cCodigo
					SZ5->Z5_DESCUSR := UsrRetName(cCodigo)
					SZ5->Z5_SEQPED  := cSeqPEd
					SZ5->Z5_CLIENTE := Space(6)
					SZ5->Z5_NOME    := Space(10)
					SZ5->(MsUnlock())
				ENDIF

				If (nIni != len(aCols2)) //Se houve inclusão
					For nI := nIni+1 to Len(aCols2)
						If ((aCols2[nI][Len(aHeader2)+1] == .F.))
							if !(dbSeek(xFilial("SZ5") + cCodigo + aCols2[nI][01]))
								If (RecLock("SZ5", .T.))
									SZ5->Z5_FILIAL  := xFilial("SZ5")
									SZ5->Z5_IDUSER  := cCodigo
									SZ5->Z5_DESCUSR := UsrRetName(cCodigo)
									SZ5->Z5_SEQPED  := cSeqPEd
									SZ5->Z5_CLIENTE := aCols2[nI][01]
									SZ5->Z5_NOME    := aCols2[nI][02]
									SZ5->(MsUnlock())
								EndIf
							EndIf
						Endif
						SZ5->(dbSkip())
					Next nI
				Endif

			EndIf

		ENDIF

	End Sequence

	RestArea(aArea)
Return .T.


//Função auxiliar: Validação do código do centro de custo na mudança de linha

//+--------------------------------------------------------------------+
//| Rotina | Mod2LOk | Autor | Robson Luiz (rleg)   | Data |01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar a linha de dados.                     |
//+--------------------------------------------------------------------+
//| Uso    | Para treinamento e capacitação.                           |
//+--------------------------------------------------------------------+
User Function Mod2LOk()
	Local lRet := .T.
	/*
	If !aCOLS[n, Len(aHeader)+1]
	If Empty(aCOLS[n,GdFieldPos("SZG_CCUSTO")])
	MsgAlert(cMensagem,cCadastro)
	lRet := .F.
	Endif
	Endif
	*/
Return( lRet )

//Função auxiliar: Validação do código do centro de custo para todas as linhas

//+--------------------------------------------------------------------+
//| Rotina | Mod2TOk | Autor | Robson Luiz (rleg)   | Data |01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar toda as linhas de dados.              |
//+--------------------------------------------------------------------+
//| Uso    | Para treinamento e capacitação.                           |
//+--------------------------------------------------------------------+

User Function Mod2TOk()
	Local lRet := .T.
	Local nI := 0
	Local cMensagem := "Não será permitido linhas sem o centro de custo."

	/*
	For nI := 1 To Len( aCOLS )
	If aCOLS[nI, Len(aHeader)+1]
	Loop
	Endif
	If !aCOLS[nI, Len(aHeader)+1]
	If Empty(aCOLS[n,GdFieldPos("SZG_CCUSTO")])
	MsgAlert(cMensagem,cCadastro)
	lRet := .F.
	Exit
	Endif
	Endif
	Next nI
	*/
Return( lRet )



Static Function FPermite(cParam)
	Local lRetorno := DbSeek(xFilial("SZ5")+cParam)     
	If lRetorno
		ApMsgInfo("Favor informar outro usuario!")
		lRetorno := .F.
	EndIf
Return lRetorno      

uSER Function FPLC01LN()
	Local lRetorno := DbSeek(xFilial("SZ5")+cCodigo+aCol[oGet:nAT][1])     
	If lRetorno
		ApMsgInfo("Favor informar outro Cliente!")
		lRetorno := .F.
	EndIf
Return lRetorno
