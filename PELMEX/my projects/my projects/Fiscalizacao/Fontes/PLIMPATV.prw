#include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ AMCPD03    ¦ Autor ¦ Marlucia Serpa       ¦ Data ¦ 01/04/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para mudança de dados contábeis do ativo fixo          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLIMPATV()
	Local cPerg     := "AMCPD02a"
	Local cCadastro := OemtoAnsi("Importação dos Besn do Ativo Imobilizado")
	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0

	//ValidPerg(cPerg)
	//Pergunte(cPerg,.F.)

	AADD(aSays,OemToAnsi("Esta rotina irá alterar o código e o centro de custo do ativo fixo.    ") )
	AADD(aSays,OemToAnsi("                                                                       ") )
	AADD(aSays,OemToAnsi("                                                                       ") )

	//AADD(aButtons, { 5,.T.,{| | Pergunte(cPerg,.T.)     }})
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
	AADD(aButtons, { 2,.T.,{|o| FechaBatch()            }})

	FormBatch( cCadastro, aSays, aButtons )

	If nOpca == 1
		Processa({|| OkProc() },"Alterando dados contábeis...")
	Endif

Return nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ OkProc     ¦ Autor ¦ Marlucia Serpa       ¦ Data ¦ 01/04/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de dados contábeis do Ativo Fixo                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function OkProc()
	Local cArq := "\PATRIMO\PT001B.DBF"
	Local dDtAq
	Local cDia,cMes,cAno
	Local cCodBem 
	Local nCont := 0
	Use &cArq Alias IMPATV Exclusive New

	ProcRegua(IMPATV->(RecCount())) // Numero de registros a processar

	While !IMPATV->(Eof())      
		IncProc()
		nCont++
		cDia := SubStr(IMPATV->BDATAQU,5,2)
		cMes := SubStr(IMPATV->BDATAQU,3,2)
		cAno := SubStr(IMPATV->BDATAQU,1,2)
		cCodBem := "NFE"+Strzero(nCont,7)
		If SubStr(cAno,1,1) == "A"
			cAno := "200"+SubStr(cAno,2,1)
		EndIf     
		dDtAq := Ctod(cDia+"/"+cMes+"/"+cAno)

		DbSelectArea("SN1")
		RecLock("SN1",.T.)
		SN1->N1_FILIAL := xFilial("SN1")
		SN1->N1_CBASE := cCodBem
		SN1->N1_ITEM := "0001"
		SN1->N1_AQUISIC := dDtAq
		SN1->N1_DESCRIC := IMPATV->BDESBEM
		SN1->N1_QUANTD := IMPATV->BQTDLOT
		SN1->N1_PENHORA := "0"
		/*
		SN1->N1_FORNEC
		SN1->N1_LOJA
		*/
		SN1->N1_NSERIE := "UNI"
		SN1->N1_NFISCAL := IMPATV->BNFCBEM
		SN1->N1_PATRIM := 'N'                
		SN1->N1_CODCIAP := "000000"
		SN1->N1_CALCPIS := "1"
		SN1->N1_CONSAB := "1"
		MsUnlock("SN1")     


		DbSelectArea("SN3")
		RecLock("SN3",.T.)
		SN3->N3_FILIAL := xFilial("SN3")
		SN3->N3_CBASE := cCodBem   
		SN3->N3_ITEM := "0001"
		SN3->N3_TIPO := "01"
		SN3->N3_BAIXA := "0"
		SN3->N3_DINDEPR := dDtAq
		SN3->N3_VORIG1 := IMPATV->BVALAQU
		SN3->N3_AQUISIC := dDtAq
		SN3->N3_NOVO := "S"
		SN3->N3_SEQ := "001"
		MsUnlock("SN3")     

		DbSelectArea("SN4")
		RecLock("SN4",.T.)
		SN4->N4_FILIAL := xFilial("SN4")
		SN4->N4_CBASE := cCodBem   
		SN4->N4_ITEM := "0001"
		SN4->N4_TIPO := "01" 
		SN4->N4_OCORR := "05"
		SN4->N4_TIPOCNT := "1"
		SN4->N4_DATA := dDtAq
		SN4->N4_QUANTD := IMPATV->BQTDLOT
		SN4->N4_VLROC1 := IMPATV->BVALAQU
		SN4->N4_SEQ := "001"
		SN4->N4_IDMOV := "0000000001"
		SN4->N4_FILORIG = "UN"
		SN4->N4_SEQ := "001"
		MsUnlock("SN4")     

		IMPATV->(DbSkip())                
	End
	Alert("Finalizado com sucesso!")
	IMPATV->(DbCloseArea())

Return

Static Function teste

	Local cQry, x
	Local vAtivo := {}
	Local vDespe := {}
	Local vDepre := {}
	Local vCusto := {}

	ContasCusto(@vAtivo,@vDespe,@vDepre,@vCusto)

	ProcRegua(Len(vAtivo))
	For x:=1 To Len(vAtivo)
		IncProc("Atualizando ativo...")
		cQry := "UPDATE "+RetSQLName("SN3")+" SET N3_CCONTAB = '"+StrTran(vAtivo[x,2],".","")+"'"
		cQry += " WHERE D_E_L_E_T_ = ' ' AND N3_FILIAL = '06' AND N3_CCONTAB = '"+StrTran(vAtivo[x,1],".","")+"'"
		TCSQLExec(cQry)

		cQry := "UPDATE "+RetSQLName("SN4")+" SET N4_CONTA = '"+StrTran(vAtivo[x,2],".","")+"'"
		cQry += " WHERE D_E_L_E_T_ = ' ' AND N4_FILIAL = '06' AND N4_CONTA = '"+StrTran(vAtivo[x,1],".","")+"'"
		TCSQLExec(cQry)

		cQry := "UPDATE "+RetSQLName("SN5")+" SET N5_CONTA = '"+StrTran(vAtivo[x,2],".","")+"'"
		cQry += " WHERE D_E_L_E_T_ = ' ' AND N5_FILIAL = '06' AND N5_CONTA = '"+StrTran(vAtivo[x,1],".","")+"'"
		TCSQLExec(cQry)
	Next

	ProcRegua(Len(vDespe))
	For x:=1 To Len(vDespe)
		IncProc("Atualizando despesas...")
		cQry := "UPDATE "+RetSQLName("SN3")+" SET N3_CDEPREC = '"+StrTran(vDespe[x,2],".","")+"'"
		cQry += " WHERE D_E_L_E_T_ = ' ' AND N3_FILIAL = '06' AND N3_CDEPREC = '"+StrTran(vDespe[x,1],".","")+"'"
		TCSQLExec(cQry)

		cQry := "UPDATE "+RetSQLName("SN4")+" SET N4_CONTA = '"+StrTran(vDespe[x,2],".","")+"'"
		cQry += " WHERE D_E_L_E_T_ = ' ' AND N4_FILIAL = '06' AND N4_CONTA = '"+StrTran(vDespe[x,1],".","")+"'"
		TCSQLExec(cQry)

		cQry := "UPDATE "+RetSQLName("SN5")+" SET N5_CONTA = '"+StrTran(vDespe[x,2],".","")+"'"
		cQry += " WHERE D_E_L_E_T_ = ' ' AND N5_FILIAL = '06' AND N5_CONTA = '"+StrTran(vDespe[x,1],".","")+"'"
		TCSQLExec(cQry)
	Next

	ProcRegua(Len(vDepre))
	For x:=1 To Len(vDepre)
		IncProc("Atualizando depreciacao...")
		cQry := "UPDATE "+RetSQLName("SN3")+" SET N3_CCDEPRE = '"+StrTran(vDepre[x,2],".","")+"'"
		cQry += " WHERE D_E_L_E_T_ = ' ' AND N3_FILIAL = '06' AND N3_CCDEPRE = '"+StrTran(vDepre[x,1],".","")+"'"
		TCSQLExec(cQry)

		cQry := "UPDATE "+RetSQLName("SN4")+" SET N4_CONTA = '"+StrTran(vDepre[x,2],".","")+"'"
		cQry += " WHERE D_E_L_E_T_ = ' ' AND N4_FILIAL = '06' AND N4_CONTA = '"+StrTran(vDepre[x,1],".","")+"'"
		TCSQLExec(cQry)

		cQry := "UPDATE "+RetSQLName("SN5")+" SET N5_CONTA = '"+StrTran(vDepre[x,2],".","")+"'"
		cQry += " WHERE D_E_L_E_T_ = ' ' AND N5_FILIAL = '06' AND N5_CONTA = '"+StrTran(vDepre[x,1],".","")+"'"
		TCSQLExec(cQry)
	Next

	ProcRegua(Len(vCusto))
	For x:=1 To Len(vCusto)
		IncProc("Atualizando centros de custo...")
		cQry := "UPDATE "+RetSQLName("SN3")+" SET N3_CUSTBEM = '"+StrTran(vCusto[x,2],".","")+"'"
		cQry += " WHERE D_E_L_E_T_ = ' ' AND N3_FILIAL = '06' AND N3_CUSTBEM = '"+StrTran(vCusto[x,1],".","")+"'"
		TCSQLExec(cQry)

		cQry := "UPDATE "+RetSQLName("SN3")+" SET N3_CCUSTO = '"+StrTran(vCusto[x,2],".","")+"'"
		cQry += " WHERE D_E_L_E_T_ = ' ' AND N3_FILIAL = '06' AND N3_CCUSTO = '"+StrTran(vCusto[x,1],".","")+"'"
		TCSQLExec(cQry)
	Next

Return

Static Function ContasCusto(vAtivo,vDespe,vDepre,vCusto)
	AAdd( vAtivo , { "1.32.10.101", "1.32.10.002"} )
	AAdd( vAtivo , { "1.32.10.102", "1.32.10.003"} )
	AAdd( vAtivo , { "1.32.10.103", "1.32.10.006"} )
	AAdd( vAtivo , { "1.32.10.104", "1.32.10.008"} )
	AAdd( vAtivo , { "1.32.10.105", "1.32.10.009"} )
	AAdd( vAtivo , { "1.32.10.106", "1.32.10.011"} )
	AAdd( vAtivo , { "1.32.10.107", "1.32.10.012"} )
	AAdd( vAtivo , { "1.32.10.108", "1.32.10.013"} )
	AAdd( vAtivo , { "1.32.10.112", "1.32.10.017"} )
	AAdd( vAtivo , { "1.32.10.115", "1.32.10.103"} )
	AAdd( vAtivo , { "1.32.10.116", "1.32.10.106"} )
	AAdd( vAtivo , { "1.32.10.117", "1.32.10.108"} )
	AAdd( vAtivo , { "1.32.10.118", "1.32.10.109"} )
	AAdd( vAtivo , { "1.32.10.119", "1.32.10.111"} )
	AAdd( vAtivo , { "1.32.10.125", "1.32.10.117"} )
	AAdd( vAtivo , { "1.32.10.127", "1.32.10.203"} )
	AAdd( vAtivo , { "1.32.10.128", "1.32.10.206"} )
	AAdd( vAtivo , { "1.32.10.130", "1.32.10.217"} )
	AAdd( vAtivo , { "1.32.10.131", "1.32.10.302"} )
	AAdd( vAtivo , { "1.32.10.132", "1.32.10.303"} )
	AAdd( vAtivo , { "1.32.10.133", "1.32.10.001"} )
	AAdd( vAtivo , { "1.32.10.134", "1.32.10.003"} )
	AAdd( vAtivo , { "1.32.10.135", "1.32.10.018"} )
	AAdd( vAtivo , { "1.32.10.136", "1.32.10.007"} )
	AAdd( vAtivo , { "1.32.10.138", "1.32.10.010"} )
	AAdd( vAtivo , { "1.32.10.139", "1.32.10.008"} )
	AAdd( vAtivo , { "1.32.10.140", "1.32.10.301"} )
	AAdd( vAtivo , { "1.32.10.141", "1.32.10.303"} )
	AAdd( vAtivo , { "1.32.10.142", "1.32.10.318"} )
	AAdd( vAtivo , { "1.32.10.144", "1.32.10.119"} )
	AAdd( vAtivo , { "1.32.10.145", "1.32.10.120"} )
	AAdd( vAtivo , { "1.32.10.146", "1.32.10.121"} )
	AAdd( vAtivo , { "1.32.10.147", "1.32.10.122"} )
	AAdd( vAtivo , { "1.32.10.148", "1.32.10.123"} )
	AAdd( vAtivo , { "1.32.10.149", "1.32.10.124"} )
	AAdd( vAtivo , { "1.32.20.250", "1.32.20.011"} )
	AAdd( vAtivo , { "1.32.20.251", "1.32.20.111"} )
	AAdd( vAtivo , { "1.32.20.256", "1.32.20.008"} )
	AAdd( vAtivo , { "1.32.20.257", "1.32.20.308"} )
	AAdd( vAtivo , { "1.32.20.258", "1.32.20.010"} )
	AAdd( vAtivo , { "1.32.20.259", "1.32.20.310"} )
	AAdd( vAtivo , { "1.32.20.270", "1.32.20.009"} )
	AAdd( vAtivo , { "1.32.20.271", "1.32.20.109"} )
	AAdd( vAtivo , { "1.32.20.274", "1.32.20.112"} )
	AAdd( vAtivo , { "1.32.35.353", "1.32.50.401"} )

	AAdd( vDespe , { "42121203", "42521005"} )
	AAdd( vDespe , { "42161601", "42521005"} )
	AAdd( vDespe , { "42161602", "42521007"} )
	AAdd( vDespe , { "51161601", "52521005"} )
	AAdd( vDespe , { "51161601", "52521005"} )
	AAdd( vDespe , { "52161601", "62521005"} )
	AAdd( vDespe , { "63110105", "74010005"} )

	AAdd( vDepre , { "1.33.10.102", "1.33.10.003"} )
	AAdd( vDepre , { "1.33.10.103", "1.33.10.006"} )
	AAdd( vDepre , { "1.33.10.104", "1.33.10.008"} )
	AAdd( vDepre , { "1.33.10.105", "1.33.10.009"} )
	AAdd( vDepre , { "1.33.10.107", "1.33.10.012"} )
	AAdd( vDepre , { "1.33.10.108", "1.33.10.013"} )
	AAdd( vDepre , { "1.33.10.112", "1.33.10.017"} )
	AAdd( vDepre , { "1.33.10.115", "1.33.10.103"} )
	AAdd( vDepre , { "1.33.10.116", "1.33.10.106"} )
	AAdd( vDepre , { "1.33.10.117", "1.33.10.108"} )
	AAdd( vDepre , { "1.33.10.118", "1.33.10.109"} )
	AAdd( vDepre , { "1.33.10.125", "1.33.10.117"} )
	AAdd( vDepre , { "1.33.10.127", "1.33.10.203"} )
	AAdd( vDepre , { "1.33.10.128", "1.33.10.206"} )
	AAdd( vDepre , { "1.33.10.130", "1.33.10.217"} )
	AAdd( vDepre , { "1.33.10.132", "1.33.10.303"} )
	AAdd( vDepre , { "1.33.10.134", "1.33.10.303"} )
	AAdd( vDepre , { "1.33.10.135", "1.33.10.018"} )
	AAdd( vDepre , { "1.33.10.136", "1.33.10.007"} )
	AAdd( vDepre , { "1.33.10.138", "1.33.10.010"} )
	AAdd( vDepre , { "1.33.10.139", "1.33.10.008"} )
	AAdd( vDepre , { "1.33.10.141", "1.33.10.303"} ) 
	AAdd( vDepre , { "1.33.10.142", "1.33.10.318"} )
	AAdd( vDepre , { "1.33.10.144", "1.33.10.119"} )
	AAdd( vDepre , { "1.33.10.145", "1.33.10.120"} )
	AAdd( vDepre , { "1.33.10.147", "1.33.10.122"} )
	AAdd( vDepre , { "1.33.10.148", "1.33.10.123"} )
	AAdd( vDepre , { "1.33.10.149", "1.33.10.124"} )
	AAdd( vDepre , { "1.33.20.250", "1.33.20.011"} )
	AAdd( vDepre , { "1.33.20.251", "1.33.20.111"} )
	AAdd( vDepre , { "1.33.20.258", "1.33.20.010"} )
	AAdd( vDepre , { "1.33.20.259", "1.33.20.310"} )
	AAdd( vDepre , { "1.33.20.274", "1.33.20.112"} )

	AAdd( vCusto , { "51", "0105"} )
	AAdd( vCusto , { "52", "0905"} )
	AAdd( vCusto , { "53", "1205"} )
	AAdd( vCusto , { "54", "2305"} )
	AAdd( vCusto , { "56", "0205"} )
	AAdd( vCusto , { "61", "0107"} )
	AAdd( vCusto , { "65", "0107"} )
	AAdd( vCusto , { "81", "0508"} )

Return