#include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INFINP08   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/04/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de geração dos dados da contabilidade para o MCT       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INFINP08(cTab,cQry,cOrig,lNewFile)
	Local aDbf, cArq, nRegis, ni
	Local cAlias := Alias()
	Local aStru  := SZ3->(dbStruct())
	Local nX
	
	lNewFile := If( lNewFile == nil , .T., lNewFile ) // Define se ira gerar novo arquivo temporario
	cOrig    := If( cOrig    == nil , " ", cOrig)     // Define origem de busca
	
	If lNewFile
		aDbf := u_CpoPadSE5()
		cArq := CriaTrab(aDbf,.t.)
		Use &cArq Alias &(cTab) New Exclusive
	Endif
	
	cQry += " AND SZ3.Z3_ATIVO <> 'N'"
	
	//- Conta o numero de registros filtrados pela query
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "SOM", .T., .F. )
	nRegis:= SOMA
	dbCloseArea()
	
	//- Troca a expressao COUNT(*) por * na clausula SELECT
	cQry := StrTran(cQry,"COUNT(*) SOMA","SZ3.*")
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TBS", .T., .F. )
	
	For ni:=1 To Len(aStru)
		If aStru[ni,2] != "C"
			TCSetField("TBS", aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next
	
	ProcRegua(nRegis)
	While !Eof()
		
		IncProc()
		
		RecLock(cTab,.T.)
		For nX:=1 To (cTab)->(FCount())
			If (nPos := (cTab)->(FieldPos(StrTran(TBS->(FieldName(nX)),"Z3_","E5_")))) > 0   // Se o campo existir na tabela de manutenção
				FieldPut( nPos , TBS->(FieldGet(nX)) )
			Endif
		Next
		dbSelectArea("TBS")
		
		dbSkip()
	Enddo
	dbCloseArea()
	dbSelectArea(cAlias)
	
Return cArq
