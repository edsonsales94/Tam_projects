#Include "Rwmake.ch"

Static __lSubChamada := .F.

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MT010INC   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 30/07/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada após inclusão do cadastro do produto --      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MT010INC()
	Local aDePara, nPos, nF, nC, aCopia
	Local cFilAux  := cFilAnt
	Local aFiliais := FWLoadSM0()
	Local nRecno   := SB1->(Recno())
	Local aReplica := {}
	Local aPergs   := {}
	Local aReturn  := {}
	
	If !IsBlind() .And. !__lSubChamada
		__lSubChamada := .T.
		
		// Replica de forma automática
		aDePara := {}
		AAdd( aDePara , { "  ", "SV", "SV"})
		AAdd( aDePara , { "  ", "MC", "MC"})
		AAdd( aDePara , { "01", "MP", "ME"})
		AAdd( aDePara , { "01", "OI", "ME"})
		AAdd( aDePara , { "01", "PA", "ME"})
		
		nPos := AScan( aDePara , {|x| x[2] == M->B1_TIPO } )
		If nPos > 0 .And. (Empty(aDePara[nPos,1]) .Or. aDePara[nPos,1] == cFilAnt)
			AAdd( aPergs ,{9,"Selecione as filiais para as quais deseja replicar o cadastro:",200, 40,.T.})
			
			SB1->(dbSetOrder(1))
			
			For nF:=1 To Len(aFiliais)
				cFilAnt := aFiliais[nF,2]
				If aFiliais[nF,1] == cEmpAnt .And. cFilAnt <> cFilAux .And. !SB1->(dbSeek(XFILIAL("SB1")+M->B1_COD))
					AAdd( aReplica , { cFilAnt, ""} )   // Adiciona as filiais a serem replicadas
					AAdd( aPergs ,{2,"Filial "+Trim(cFilAnt)+":",'1',{"1=Sim","2=Não"},50,"",.T.})
				Endif
			Next
			
			cFilAnt := cFilAux
			SB1->(dbGoTo(nRecno))   // Restaura a posição
			
			If Empty(aReplica) .Or. !ParamBox(aPergs, "Replicar Cadastro de Produtos",aReturn)
				Return
			Endif
			
			// Copia os campos do produto
			aCopia := {}
			For nF:=1 To SB1->(FCount())
				AAdd( aCopia , { Trim(SB1->(FieldName(nF))), SB1->(FieldGet(nF))} )
			Next
			AAdd( aCopia , { "B1_COD"    , M->B1_COD                })
			AAdd( aCopia , { "B1_DESC"   , M->B1_DESC               })
			AAdd( aCopia , { "B1_GRTRIB" , CriaVar("B1_GRTRIB" ,.F.)})
			AAdd( aCopia , { "B1_POSIPI" , CriaVar("B1_POSIPI" ,.F.)})
			AAdd( aCopia , { "B1_XNATURE", CriaVar("B1_XNATURE",.F.)})
			AAdd( aCopia , { "B1_MSBLQL" , "1"})
			
			For nF:=1 To Len(aReplica)
				If aReturn[nF+1] = '1'
					cFilAnt := aReplica[nF,1]
					
					RecLock("SB1",.T.)
					For nC:=1 To Len(aCopia)
						FieldPut( FieldPos(aCopia[nC,1]) , aCopia[nC,2] )
					Next
					SB1->B1_FILIAL := XFILIAL("SB1")
					SB1->B1_TIPO   := aDePara[nPos,3]
					MsUnLock()
				Endif
			Next
			
			SB1->(dbGoTo(nRecno))   // Restaura a posição
			cFilAnt := cFilAux
		Endif
	Endif
	
Return

User Function MT010ALT()
	u_MT010INC()
Return

/*User Function MTA010NC()
	Local nC
	Local aFields := {}
	LOcal aRet    := {}
	
	If !IsBlind() .And. IsInCallStack("U_MT010INC")
		AAdd( aFields , { "B1_COD"    , __cB1_COD                })
		AAdd( aFields , { "B1_DESC"   , __cB1_DESC               })
		AAdd( aFields , { "B1_TIPO"   , __cB1_TIPO               })
		AAdd( aFields , { "B1_GRTRIB" , CriaVar("B1_GRTRIB" ,.F.)})
		AAdd( aFields , { "B1_POSIPI" , CriaVar("B1_POSIPI" ,.F.)})
		AAdd( aFields , { "B1_XNATURE", CriaVar("B1_XNATURE",.F.)})
		AAdd( aFields , { "B1_MSBLQL" , "1"})
		
		For nC:=1 To Len(aFields)
			AAdd( aRet , aFields[nC,1] )
			M->&( aFields[nC,1] ) := aFields[nC,2]
		Next
	Endif
	
	//If IsInCallStack("U_MT010INC")
	//	M->B1_DESC := PADR("RONILTON",Len(M->B1_DESC))
	//Endif

Return aRet*/
