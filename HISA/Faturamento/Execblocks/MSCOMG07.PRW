#include 'protheus.ch'

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MSCOMG07   ¦ Autor ¦  Matheus Freitas     ¦ Data ¦ 23/04/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Replicar as informações referente a TES -                      ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MSCOMG07()
	Local cVar := StrTran(ReadVar(),"M->","")
	
	If !IsInCallStack("u_HMDispara") .and. n < Len(aCols) .And. FWAlertYesNo("Deseja replicar essa informação para os itens abaixo ?")
		FWMsgRun(Nil, {|oSay| PreencheItens(cVar) }, "Replicar Conteúdo", "Replicando conteúdo para os demais itens...")
	Endif

Return .T.

Static Function PreencheItens(cVar)
	Local nX
	Local nPos := AScan( aHeader , {|x| Trim(x[2]) == cVar } )
	Local xVlr := M->&( cVar )
	
	For nX:=n+1 To Len(aCols)
		aCols[nX,nPos] := xVlr
        
		u_HMDispara(cVar,xVlr,nX,.T.) // Dispara gatilho
	Next

Return
