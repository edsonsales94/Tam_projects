#Include "Protheus.ch"
#Include "Tbiconn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MGFATP02   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/03/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Gravação do Complemento do Produto                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MGFATP02()
	Local aSays    := {}             
	Local aButtons := {}
	Local cPerg    := "MGFATP02"
	Local nOpcA    := 0
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	AADD(aSays, "Esta rotina fará a gravação do complemento dos produtos conforme" )
	AADD(aSays, "os parâmetros informados pelo usuário." )
	
	cCadastro := "Gravação do Complemento de Produtos"
	
	aAdd( aButtons, { 5, .T., {|x| Pergunte(cPerg,.T.)    }} )
	aAdd( aButtons, { 1, .T., {|x| nOpcA := 1, oDlg:End() }} )
	aAdd( aButtons, { 2, .T., {|x| nOpcA := 2, oDlg:End() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
	
	If nOpcA == 1
		Processa( {|| GravaDados() } , "Complemento de Produtos")
	Endif

Return

Static Function GravaDados()
	Local nC
	Local aArea := GetArea()
	Local cTmp  := GetNextAlias()
	Local aSB5  := SB5->(dbStruct())
	
	BeginSQL Alias cTmp
		SELECT SB1.R_E_C_N_O_ AS B1_RECNO
		FROM %Table:SB1% SB1
		LEFT OUTER JOIN %Table:SB5% SB5 ON SB5.%NotDel%
		AND SB5.B5_FILIAL = %Exp:XFILIAL("SB5")%
		AND SB5.B5_COD = SB1.B1_COD
		WHERE SB1.%NotDel%
		AND SB1.B1_FILIAL = %Exp:XFILIAL("SB1")%
		AND SB1.B1_COD >= %Exp:mv_par01%
		AND SB1.B1_COD <= %Exp:mv_par02%
		AND SB1.B1_TIPO >= %Exp:mv_par03%
		AND SB1.B1_TIPO <= %Exp:mv_par04%
		AND SB5.B5_FILIAL IS NULL
		ORDER BY SB1.B1_FILIAL, SB1.B1_COD
	EndSQL
	
	If (cTmp)->(Bof()) .And. (cTmp)->(Eof())
		FWAlertWarning("Não existem produtos a serem complentados !")
	Else
		INCLUI := .T.
		
		ProcRegua( (cTmp)->(RecCount()) )
		While !(cTmp)->(Eof())
			
			IncProc()
			
			SB1->(dbGoTo((cTmp)->B1_RECNO))    // Posiciona no registro
			
			Begin Transaction
			
			RecLock("SB5",.T.)
			
			For nC:=1 To Len(aSB5)
				FieldPut( nC , CriaVar(FieldName(nC),.T.) )
			Next
			SB5->B5_FILIAL  := XFILIAL("SB5")
			SB5->B5_COD     := SB1->B1_COD
			SB5->B5_CEME    := SB1->B1_DESC
			SB5->B5_CODTRAM := "N015"
			MsUnLock()
			
			End Transaction
			
			(cTmp)->(dbSkip())
		Enddo
		
		FWAlertSuccess("Complemento de Produtos gravado com sucesso !")
	Endif
	(cTmp)->(dbCloseArea())
	RestArea(aArea)
 
Return

Static Function ValidPerg(cPerg)
	Local nTamB := TamSX3("B1_COD")[1]
	
	u_MGPutSx1(cPerg,"01",PADR("Produto              " ,29)+"?","","","mv_ch1","C",nTamB,0,0,"G","","SB1","","","mv_par01")
	u_MGPutSx1(cPerg,"02",PADR("Produto ate          " ,29)+"?","","","mv_ch2","C",nTamB,0,0,"G","","SB1","","","mv_par02")
	u_MGPutSx1(cPerg,"03",PADR("Tipo de              " ,29)+"?","","","mv_ch3","C",    2,0,0,"G","","02 ","","","mv_par03")
	u_MGPutSx1(cPerg,"04",PADR("Tipo ate             " ,29)+"?","","","mv_ch4","C",    2,0,0,"G","","02 ","","","mv_par04")
	
Return
