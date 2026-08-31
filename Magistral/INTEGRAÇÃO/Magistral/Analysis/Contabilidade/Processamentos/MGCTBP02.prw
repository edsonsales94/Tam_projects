#Include "Protheus.ch"
#Include "Tbiconn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MGCTBP02   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 24/06/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Retira caracteres especiais do histórico contábil             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MGCTBP02()
	Local aSays    := {}             
	Local aButtons := {}
	Local cPerg    := "MGCTBP02"
	Local nOpcA    := 0
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	AADD(aSays, "Esta rotina fará a retirada de caracateres especiais do histórico" )
	AADD(aSays, "dos lançamentos contábeis conforme o período informado." )
	
	cCadastro := "Retirada de caracteres especiais"
	
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
	Local nConta  := 0
	Local aArea   := GetArea()
	Local cTmp    := GetNextAlias()
	Local aCarac  := {}
	Local cCarac  := ''
	Local cFiltro := "%'%["
	
	AAdd( aCarac , { '°', 'o'})
	AAdd( aCarac , { 'º', 'o'})
	AAdd( aCarac , { 'ª', 'a'})
	AAdd( aCarac , { '"', '' })
	AAdd( aCarac , { '|', '' })
	aEval( aCarac , {|x| cCarac += x[1] } )
	
	cFiltro +=  cCarac + "]%'%"
	
	BeginSQL Alias cTmp
		SELECT CT2.R_E_C_N_O_ AS CT2_RECNO
		FROM %Table:CT2% CT2
		WHERE CT2.%NotDel%
		AND CT2.CT2_FILIAL >= %Exp:mv_par01%
		AND CT2.CT2_FILIAL <= %Exp:mv_par02%
		AND CT2.CT2_DATA >= %Exp:DtoS(mv_par03)%
		AND CT2.CT2_DATA <= %Exp:DtoS(mv_par04)%
		AND CT2.CT2_HIST LIKE %Exp:cFiltro%
		ORDER BY CT2.CT2_DATA, CT2.R_E_C_N_O_
	EndSQL
	
	If (cTmp)->(Bof()) .And. (cTmp)->(Eof())
		FWAlertWarning("Não existem registros caracateres especiais !")
	Else
		ProcRegua( (cTmp)->(RecCount()) )
		While !(cTmp)->(Eof())
			
			IncProc()
			
			nConta++
			
			CT2->(dbGoTo((cTmp)->CT2_RECNO))    // Posiciona no registro
			
			cCT2_HIST := CT2->CT2_HIST
			
			For nC:=1 To Len(aCarac)
				cCT2_HIST := StrTran(cCT2_HIST,aCarac[nC,1],aCarac[nC,2])
			Next
			
			RecLock("CT2",.F.)
			CT2->CT2_HIST := cCT2_HIST
			MsUnLock()
			
			(cTmp)->(dbSkip())
		Enddo
		
		If nConta > 0
			FWAlertSuccess(LTrim(cValToChar(nConta))+" registro(s) atualizado(s) com sucesso !")
		Endif
	Endif
	(cTmp)->(dbCloseArea())
	RestArea(aArea)
 
Return

Static Function ValidPerg(cPerg)
	Local nTam := TamSX3("CT2_FILIAL")[1]
	
	u_MGPutSx1(cPerg,"01",PADR("Filial De          " ,29)+"?","","","mv_ch1","C",nTam,0,0,"G","","   ","","","mv_par01")
	u_MGPutSx1(cPerg,"02",PADR("Filial Ate         " ,29)+"?","","","mv_ch2","C",nTam,0,0,"G","","   ","","","mv_par02")
	u_MGPutSx1(cPerg,"03",PADR("Data De            " ,29)+"?","","","mv_ch3","D",   8,0,0,"G","","   ","","","mv_par03")
	u_MGPutSx1(cPerg,"04",PADR("Data Ate           " ,29)+"?","","","mv_ch4","D",   8,0,0,"G","","   ","","","mv_par04")
	
Return
