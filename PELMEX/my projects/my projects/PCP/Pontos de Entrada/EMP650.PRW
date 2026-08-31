#Include "rwmake.ch"
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  
/*____________________________________________________________________________
¦ Função    ¦ Emp650     ¦ Autor ¦ Romualdo Neto          ¦ Data ¦ 21/07/2017 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Ponto de entrada para nao empenhar produtos com controle de     ¦
¦           ¦ fantasma internos da Pelmex e Amazon                            ¦
¦           ¦                                                                 ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User function EMP650()
	Local nDel
	Local x 
	//nDel := If( Len(aCols) > 0 , Len(aCols[1]), 1)
	//ALERT(nDel)
	For x:=1 To Len(aCols)    
		if cFilAnt == "01"
			If Posicione("SB1",1,XFILIAL("SB1")+aCols[x,1],"B1_XFANTAS") == "S"
				//aCols[x,nDel]:= .T.
				lDelete := .T.
			//ALERT(Posicione("SB1",1,XFILIAL("SB1")+aCols[x,1],"B1_XFANTAS"))
			Endif
		Endif
	Next

Return


//If !(aCols[x,Len(aCols)]) .And. Posicione("SB1",1,XFILIAL("SB1")+aCols[x,1],"B1_XFANTAS") == "S" (TROCADO NA LINHA 18)
//If Posicione("SB1",1,XFILIAL("SB1")+aCols[x,1],"B1_XFANTAS") == "S"(SUBSTITUIDO EM 07/03/22)
//elseIf !(aCols[x,nDel]) (RETIRADO NA LINHA 20)
//aCols[x,nDel] := .T. (RETIRADO NA LINHA 21)
