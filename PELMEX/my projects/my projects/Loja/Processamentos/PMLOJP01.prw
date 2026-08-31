#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ PMLOJP01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 21/07/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Rotina para criação automática de caixas na tabela SLF        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function PMLOJP01()
	Local aSay    := {}
	Local aButton := {}
	Local nOpc    := 0
	Local cTitulo := "Criação de caixas"
	Local cDesc1  := "Essa rotina irá criar os caixas em todas as filiais do sistema."
	Local cDesc2  := ""

	If cNumEmp <> "1001"
		Alert("Filial inválida para execução. Favor entrar na Empresa/Filial: "+Transform(cNumEmp,"@R 99/99")+".")
		Return
	Endif

	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )

	aAdd( aButton, { 1, .T., {|x| nOpc := 1, oDlg:End() }} )
	aAdd( aButton, { 2, .T., {|x| nOpc := 2, oDlg:End() }} )

	FormBatch( cTitulo, aSay, aButton )

	If nOpc == 1
		MsgRun("   Criando caixas   ","Aguarde...", {|| RunProc() })
	Endif

Return

Static Function RunProc()
	Local cQry, vCampos, cBusca, x, y, z
	Local cFilSLJ  := SLJ->(XFILIAL("SLJ"))
	Local cFiliais := ""
	Local vFilial  := {}

	SLJ->(dbSetOrder(1))
	SLJ->(dbSeek(cFilSLJ,.T.))
	While !SLJ->(Eof()) .And. cFilSLJ == SLJ->LJ_FILIAL
		cFiliais += If( Empty(cFiliais) , "", ",") + SLJ->LJ_RPCFIL
		AAdd( vFilial , SLJ->LJ_RPCFIL )
		SLJ->(dbSkip())
	Enddo

	SLF->(dbSetOrder(1))

	cQry := "SELECT LF_COD"
	aEval( vFilial , {|x| cQry += ", ["+x+"] AS FIL"+x })  // Adiciona os campos para a filial
	cQry += "   FROM ("
	cQry += "          SELECT SLF.LF_FILIAL, SLF.LF_COD, X5_CHAVE"
	cQry += "             FROM "+RetSQLName("SX5")+" SX5"
	cQry += "          LEFT OUTER JOIN "+RetSQLName("SLF")+" SLF ON SLF.D_E_L_E_T_ = ' ' AND SLF.LF_FILIAL=SX5.X5_FILIAL AND SX5.X5_CHAVE = SLF.LF_COD"
	cQry += "               AND SLF.LF_FILIAL IN "+FormatIn(cFiliais,",")
	cQry += "          WHERE SX5.D_E_L_E_T_ = ' ' AND SX5.X5_TABELA = '23'"
	cQry += "        ) A"
	cQry += " PIVOT(COUNT(X5_CHAVE) FOR LF_FILIAL IN (["+StrTran(cFiliais,",","],[")+"])) PVT"
	cQry += " WHERE (["+StrTran(cFiliais,",","]+[")+"] < "+LTrim(Str(Len(vFilial),10))+") AND LF_COD IS NOT NULL"
	cQry += " ORDER BY LF_COD"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "YYY", .T., .F. )
	dbGoTop()
	While !Eof()

		// Pesquisa o registro do caixa para cópia
		vCampos := {}
		For x:=1 To Len(vFilial)
			If SLF->(dbSeek(vFilial[x]+YYY->LF_COD))
				For y:=1 To SLF->(FCount())
					AAdd( vCampos , SLF->(FieldGet(y)) )       
				Next
				Exit
			Endif
		Next

		// Se encontrou o registro
		If !Empty(vCampos)
			For x:=1 To Len(vFilial)

				If &("FIL"+vFilial[x]) > 0  // Se já existe o registro, ignora
					Loop
				else

					vCampos[SLF->(FieldPos("LF_FILIAL"))] := vFilial[x]

					Begin Transaction
						// Cria o registro novo do caixa
						RecLock("SLF",.T.)
						For y:=1 To FCount()
							FieldPut( y , vCampos[y] )
						Next
						MsUnLock()
					End Transaction
					dbSelectArea("YYY")
				Endif
			Next
		Endif

		dbSkip()
	Enddo
	dbCloseArea()

	cBusca  := SX5->(XFILIAL("SX5"))+"23"
	vCampos := {}

	// Salva todos os caixas da empresa/filial base
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(cBusca,.T.))
	While !SX5->(Eof()) .And. cBusca == SX5->(X5_FILIAL+X5_TABELA)
		AAdd( vCampos , {} )
		nTam := Len(vCampos)
		For x:=1 To SX5->(FCount())
			AAdd( vCampos[nTam] , SX5->(FieldGet(x)) )
		Next
		SX5->(dbSkip())
	Enddo

	// Grava os registro dos caixas nas demais filiais
	For x:=1 To Len(vFilial)   // Para cada filial
		For y:=1 To Len(vCampos) // Para cada caixa
			vCampos[y,SX5->(FieldPos("X5_FILIAL"))] := vFilial[x]
			cBusca := vCampos[y,SX5->(FieldPos("X5_FILIAL"))] +;
			vCampos[y,SX5->(FieldPos("X5_TABELA"))] +;
			vCampos[y,SX5->(FieldPos("X5_CHAVE" ))]

			SX5->(dbSetOrder(1))
			If !SX5->(dbSeek(cBusca))  // Grava somente se não existir
				RecLock("SX5",.T.)
				For z:=1 To FCount()
					FieldPut( z , vCampos[y,z] )
				Next
				MsUnLock()
			Endif
		Next
	Next

	MsgInfo("Concluido com Sucesso!","Concluido")
Return