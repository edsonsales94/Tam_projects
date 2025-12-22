#INCLUDE "Rwmake.ch"

/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  MSCOMG05  ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 21/12/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Execblock de validação do campo Lote.                         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MSCOMG05()
	
	Local lRet     := .T.
	Local nPLote   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTE1"})
	Local nPDoc    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"})	
	Local nPSerie  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})		
	Local nPCodigo := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})		
	Local nPDTValid:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DTVALID"})		
	Local cVar     := Upper(ReadVar())
	*
	If FunName() == "MATA410"
	   
	   if cVar = "M->C6_LOTECTL" 
	      if M->C5_TIPO = 'D'
	         if FWAlertyesno("Deseja incluir o número de Lote na nota de origem ?")
	            U_ATUDOCORI(M->C6_LOTECTL,aCols[n,nPDoc],aCols[n,nPSerie],M->C5_CLIENTE,M->C5_LOJACLI,aCols[n,nPCodigo],MonthSum(DDatabase,12))
	            aCols[n,nPLote]    := M->C6_LOTECTL   //Sera desativado em breve.
	            aCols[n,nPDTValid] := MonthSum(DDatabase,12)
	         endif
	      endif
	   Endif
	   
	endif
	*
Return lRet


/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  ATUDOCORI ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 21/12/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Execblock de validação do campo Lote.                         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function ATUDOCORI(cLote,cDoc,cSerie,cFornece,cLoja,cProduto,dDatValid)
      
mQuery :=	" UPDATE "+RetSqlName("SD1")+" "                   
mQuery +=	" SET D1_LOTECTL = '"+cLote+"', D1_DTVALID = '"+DTOS(dDatValid)+"'"
mQuery +=	" FROM " + RetSqlName("SD1") + " SD1 "
mQuery +=	" WHERE D_E_L_E_T_='' "
mQuery +=	" AND D1_FILIAL = '"+XFILIAL("SD1")+"'"
mQuery +=	" AND D1_DOC = '"+cDoc+"'"
mQuery +=	" AND D1_SERIE = '"+cSerie+"'"
mQuery +=	" AND D1_FORNECE = '"+cFornece+"'"
mQuery +=	" AND D1_LOJA = '"+cLoja+"'"
mQuery +=	" AND D1_COD = '"+cProduto+"'"
TCSQLExec(mQuery)

Return
