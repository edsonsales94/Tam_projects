#INCLUDE "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INGCTW01   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 23/04/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INGCTW01(cFil,cNumMed, cContra, cAprovador)
	Local cQry
	Local cHTML    := ""
	Local cDescFil := ""
	Local aItens   := {}
	Local x 
	If cFil = "01"
		cDescFil := "Manaus"
	ElseIf cFil = "02"
		cDescFil := "Brasilia"
	ElseIf cFil = "03"
		cDescFil := "Recife"
	Else
		cDescFil := "São Paulo"
	EndIf
	
	cHTML += '<br><br><div align="center"><font face="Arial" size=5>  <strong>Medição de Contratos</strong></font></div>'
	cHTML += '<br><div align="Left">'
	
	cHTML += MontaTab("Medição de Contrato:",CND->CND_NUMMED,"","")
	cHTML += MontaTab("Número do Contrato:" ,CND->CND_CONTRA,"","")
	cHTML += MontaTab("Filial:",cDescFil,"Dt. Venc.",Dtoc(CND->CND_DTVENC))
	cHTML += MontaTab("Fornecedor:",CND->CND_FORNEC,"Nome Forn.:", posicione("SA2",1,xFilial("SA2")+CND->(CND_FORNEC+CND_LJFORN), "A2_NOME" ) )
	cHTML += '<br>'
	cHTML += '</div>'
	
	cHTML += '<p><font face="Arial" size=4 >Itens da Medição</font>'//Itens Pedido
	cHTML += '<DIV id=table align="center">'
	cHTML += ' <br> '
	cHTML += ' <table border="2" align="center" width="100%" id="table2">'
	cHTML += '<tr>'
	cHTML += ' 			<td width="12%" align="center"><b>Classe MCT</b></td>'
	cHTML += ' 			<td width="16%" align="center"><b>Produto</b></td>'
	cHTML += ' 			<td width="12%" align="center"><b>Quantidade</b></td>'
	cHTML += ' 			<td width="12%" align="center"><b>Vl. Unit.</b></td>'
	cHTML += ' 			<td width="12%" align="center"><b>Total</b></td>'
	cHTML += ' 			<td width="12%" align="center"><b>Perc (%)</b></td>'
	cHTML += ' 			<td width="12%" align="center"><b>Conta Ctb</b></td>'
	cHTML += ' 			<td width="12%" align="center"><b>C.Custo</b></td>'
	cHTML += '</tr>'
	
	cQry := "SELECT CNE_PRODUT, CNE_QUANT, CNE_VLUNIT, CNE_VLTOT, CNE_PERC, CNE_XCLVL, CNE_PEDIDO, CNE_CONTA, CNE_CC"
	cQry += " FROM " + RetSQLName("CNE")+" CNE"
	cQry += " INNER JOIN "+RetSQLName("CTT")+" CTT ON CNE_CC = CTT_CUSTO  AND CTT.D_E_L_E_T_ = ' '"
	cQry += " INNER JOIN "+RetSQLName("SB1")+" SB1 ON B1_COD  = CNE_PRODUT AND SB1.D_E_L_E_T_ = ' '"
	cQry += " WHERE CNE.D_E_L_E_T_ = ' '"
	cQry += " AND CNE_FILIAL = '"+cFil+"'"
	cQry += " AND CNE_NUMMED = '"+cNumMed+"'"
	cQry += " AND CNE_CONTRA = '"+cContra+"'"
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQry)),"SC",.F.,.T.)
	
	While !SC->(Eof())
		
		AAdd(aItens,{	SC->CNE_XCLVL,;
							SC->CNE_PRODUT,;
							TRANSFORM(SC->CNE_QUANT , "@E 999,999.99"),;
							TRANSFORM(SC->CNE_VLUNIT, "@E 999,999.99"),;
							TRANSFORM(SC->CNE_VLTOT , "@E 999,999.99"),;
							TRANSFORM(SC->CNE_PERC  , "@E 9,999.99"),;
							SC->CNE_CONTA,;
							SC->CNE_CC})
		
		SC->(DbSkip())
	Enddo
	DbCloseArea()
	
	For x:=1 To Len(aItens)
		cHTML += '<tr>'
		aEval( aItens[x] , {|y| cHTML += '<td align="right">'+y+'</td>' } )
		cHTML += '</tr>'
	Next
	
	cHTML += '</table></p>'
	cHTML += '</DIV>
	
Return cHTML

Static Function MontaTab(cCab1,cDesc1,cCab2,cDesc2)
	Local cHTML := ""
	
	cHTML += ' <table border="0" width="100%" id="table1">'
	cHTML += '<tr>'
	cHTML += ' 			<td width="15%" ><font size="2" ><b>'+cCab1+'</b></font></td>'
	cHTML += ' 			<td width="35%" align="Left"><font size="2" >'+cDesc1+'</font></td>'
	cHTML += ' 			<td width="10%"><font size="2"><b>'+cCab2+'</b></font></td>'
	cHTML += ' 			<td width="30%" align="Left"><font size="2">'+cDesc2+'</font></td>'
	cHTML += '</tr>'
	cHTML += '</table>'
	
Return cHTML
