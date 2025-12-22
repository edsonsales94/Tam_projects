#INCLUDE "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ OM010PRC   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 27/09/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada de definição do preço conforme a tabela      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function OM010PRC()
	Local cTabPreco := ParamIXB[1]
	Local cProduto  := ParamIXB[2]
	Local nQtde     := ParamIXB[3]
	Local cCliente  := ParamIXB[4]
	Local cLoja     := ParamIXB[5]
	Local nMoeda    := ParamIXB[6]
	Local dDataVld  := ParamIXB[7]
	Local nTipo     := ParamIXB[8]
Return TabelaAmazon(cTabPreco,cProduto,nQtde,cCliente,cLoja,nMoeda,dDataVld,nTipo,lExec,lAtuEstado,lProspect, lFornec, lUsaRef )

Static Function TabelaAmazon(cTabPreco,cProduto,nQtde,cCliente,cLoja,nMoeda,dDataVld,nTipo,lExec,lAtuEstado,lProspect, lFornec, lUsaRef )
Static cMvEstado
Static cMvNorte
Static __OMS010VerLib := Nil

Local aArea     := GetArea()
Local aAreaSB1  := SB1->(GetArea())
Local aStruDA1  := {}

Local cTpOper   := ""
Local cQuery    := ""
Local cAliasDA1 := "DA1"

Local nPrcVen   := 0
Local nResult   := 0
Local nMoedaTab := 1
Local nScan     := 0
Local nY        := 0
Local nTamProd  := Len(SB1->B1_COD)
Local nFator    := 0

Local lUltResult:= .T.
Local lQuery    := .F.
Local nProcessa := 0
Local lGrade    := MaGrade()
Local lGradeReal:= .F.
Local lPrcDA1   := .F.
Local cProdRef  := cProduto
Local lSeekDa1  := .F.
Local lLjcnvB0	:= SuperGetMv("MV_LJCNVB0",,.F.)		// Retorna preço da SB0 na ausência do preço do Produto na DA0 e DA1
Local lPOS 		:= Iif(FindFunction("STFIsPOS"), STFIsPOS(), .F.) //E Totvs Pdv?
Local lOM010EST	:= Iif(cPaisLoc != "TRI" .AND. ExistBlock("OM010ESTE",.F.,.F.),.T.,.F.) // PE no qual, através de um retorno lógico, o cliente seleciona se o estado do cliente será o informado no A1_EST ou A1_ESTE. 
Local lSA1EstE	:= .F.
Local lQtdCliVaz:= (nQtde == 0 .And. Empty(cCliente)) 
Local cFilDA1	:= xFilial("DA1")

DEFAULT cMvEstado := GetMv("MV_ESTADO")
DEFAULT cMvNorte  := GetMv("MV_NORTE")
DEFAULT nMoeda    := 1
DEFAULT aUltResult:= {}
DEFAULT dDataVld  := dDataBase
DEFAULT nTipo     := 1
DEFAULT lExec     := .T.
DEFAULT lAtuEstado:= .F.
DEFAULT lProspect := .F.
DEFAULT lFornec	  := .F.
DEFAULT lUsaRef	  := .T.

//Validação para a utilização da classe FWExecStatement
If __OMS010VerLib == Nil
	__OMS010VerLib := FWLibVersion() >= "20211116"
EndIf

If cEmpAnt <> __cEmpDA1
	__cEmpDA1 := cEmpAnt
	oQryDA1Tb1 := Nil
	oQryDA1Tb2 := Nil
	oQryDA1Tb3 := Nil
	oQryDA1Tb4 := Nil
	oQryDA1Gd1 := Nil
	oQryDA1Gd2 := Nil
EndIf

If lAtuEstado
	cMvEstado	:= GetMv("MV_ESTADO")
	cMvNorte	:= GetMv("MV_NORTE")
Endif

If lOM010EST
	lSA1EstE := Execblock("OM010ESTE",.F.,.F.)
	If Valtype(lSA1EstE) != 'L'
		lSA1EstE := .F.
	EndIf
EndIf

If lGrade .And.	MatGrdPrrf(@cProdRef,lUsaRef)
	nTamProd	:= Len(cProdRef)
	lGradeReal	:= .T.
	cProdRef	:= Padr(cProdRef,Len(DA1->DA1_REFGRD))
Endif

If IsInCallStack("MATA410")
	dDataVld := M->C5_EMISSAO
	lFornec	 := ( GetMemVar( 'C5_TIPO' ) $ 'B|D' )
EndIf

//If ExistBlock("OM010PRC") .And. lExec
//	nResult := ExecBlock("OM010PRC",.F.,.F.,{cTabPreco,cProduto,nQtde,cCliente,cLoja,nMoeda,dDataVld,nTipo})
//Else

	nScan := aScan(aUltResult,{|x| x[1] == cTabPreco .And.;
									x[2] == cProduto .And.;
									x[3] == nQtde .And.;
									x[4] == cCliente .And.;
									x[5] == cLoja .And.;
									x[6] == nMoeda .And.;
									x[7] == cFilAnt .And.;
									x[10] == lProspect})

	If nScan == 0

		If !(Empty(cCliente) .And. nQtde == 0 )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se for prospect, pega a informação do mesmo.            ³
			//³Funcionalidade implantada para utilização do televendas,³
			//³já que ele suporta orçamento para prospect.             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lProspect
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Acho o tipo de operacao para busca do preco de venda³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SUS")
				dbSetOrder(1)
				If MsSeek(xFilial("SUS")+cCliente+cLoja)
					Do Case
						Case SUS->US_EST == cMvEstado
							cTpOper := "1"
						Case SUS->US_EST != cMvEstado
							If (SUS->US_EST $ cMvNorte) .And. !(cMvEstado $ cMvNorte)
								cTpOper := "3"
							Else
								cTpOper := "2"
							EndIf
					EndCase
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Acho o tipo de operacao para busca do preco de venda³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFornec
					dbSelectArea("SA2")
					dbSetOrder(1)
					If MsSeek(xFilial("SA2")+cCliente+cLoja)
						Do Case
							Case SA2->A2_EST == cMvEstado
								cTpOper := "1"
							Case SA2->A2_EST != cMvEstado
								If (SA2->A2_EST $ cMvNorte) .And. !(cMvEstado $ cMvNorte)
									cTpOper := "3"
								Else
									cTpOper := "2"
								EndIf
						EndCase
					EndIf
				Else
					dbSelectArea("SA1")
					dbSetOrder(1)
					If MsSeek(xFilial("SA1")+cCliente+cLoja)
						Do Case
							Case SA1->A1_EST == cMvEstado
								cTpOper := "1"
							Case SA1->A1_EST != cMvEstado
								If (SA1->A1_EST $ cMvNorte) .And. !(cMvEstado $ cMvNorte)
									cTpOper := "3"
								Else
									cTpOper := "2"
								EndIf
						EndCase
					EndIf
				EndIf
			EndIf
		Endif

		dbSelectarea("DA1")
		dbSetOrder(1)
		
		#IFDEF TOP
			If TcSrvType() <> "AS/400"
				cAliasDA1 := GetNextAlias()
				aStruDA1  := DA1->(dbStruct())
				cQuery    := ""
				lQuery	  := .T.

				If lGradeReal
					cQuery += "SELECT * FROM ( "
				EndIf

				cQuery += "SELECT " 
				cQuery += " * "
				cQuery += "FROM "+RetSqlName("DA1")+ " DA1 "
				cQuery += "WHERE "
				cQuery += "( DA1.DA1_DATVIG <= ? OR DA1.DA1_DATVIG = '"+Dtos(Ctod("//"))+ "' ) "
				
				If !lQtdCliVaz
					cQuery += "AND ( DA1.DA1_TPOPER = ? OR DA1.DA1_TPOPER = '4' ) "
				Endif
				
				cQuery += "AND DA1.DA1_FILIAL = ? AND "
				cQuery +=     "DA1.DA1_CODTAB = ? AND "
				cQuery +=     "DA1.DA1_CODPRO = ? AND "
				cQuery +=     "DA1.DA1_QTDLOT >= ? AND "
				cQuery +=     "DA1.DA1_ATIVO = '1' AND  "
				cQuery +=     "DA1.D_E_L_E_T_ = ' ' "
				
				If lGradeReal
					cQuery += " UNION "
					cQuery += "SELECT * "
					cQuery += "FROM "+RetSqlName("DA1")+ " DA1 "
					cQuery += "WHERE "
					cQuery += "DA1.DA1_FILIAL = ? AND "
					cQuery += "DA1.DA1_CODTAB = ? AND "
					cQuery += "DA1.DA1_REFGRD = ? AND "
					cQuery += "DA1.DA1_QTDLOT >= ? AND "
					cQuery += "DA1.DA1_ATIVO = '1' AND  "
					cQuery += "( DA1.DA1_DATVIG <= ? OR DA1.DA1_DATVIG = '"+Dtos(Ctod("//"))+ "' ) AND "

					If !lQtdCliVaz
						cQuery += "( DA1.DA1_TPOPER = ? OR DA1.DA1_TPOPER = '4' ) AND "
					Endif

					cQuery += "DA1.D_E_L_E_T_ = ' ' "
					cQuery += "AND NOT EXISTS ( "
					cQuery += "SELECT DA1B.DA1_CODPRO  "
					cQuery += "FROM "+RetSqlName("DA1")+ " DA1B "
					cQuery += "WHERE "
					cQuery += "DA1B.DA1_FILIAL = ? AND "
					cQuery += "DA1B.DA1_CODTAB = ? AND "
					cQuery += "DA1B.DA1_CODPRO = ? AND "
					cQuery += "DA1B.DA1_QTDLOT >= ? AND "
					cQuery += "DA1B.DA1_ATIVO = '1' AND  "
					cQuery += "( DA1B.DA1_DATVIG <= ? OR DA1B.DA1_DATVIG = '"+Dtos(Ctod("//"))+ "' ) AND "

					If !lQtdCliVaz
						cQuery += "( DA1B.DA1_TPOPER = ? OR DA1B.DA1_TPOPER = '4' ) AND "
					Endif
					cQuery += "DA1B.D_E_L_E_T_ = ' ' ) "

					cQuery += " UNION "
					cQuery += "SELECT * "
					cQuery += "FROM "+RetSqlName("DA1")+ " DA1 "
					cQuery += "WHERE "
					cQuery += "DA1.DA1_FILIAL = ? AND "
					cQuery += "DA1.DA1_CODTAB = ? AND "
					cQuery += "DA1.DA1_CODPRO LIKE ? AND "
					cQuery += "DA1.DA1_QTDLOT >= ? AND "
					cQuery += "DA1.DA1_ATIVO = '1' AND  "
					cQuery += "( DA1.DA1_DATVIG <= ? OR DA1.DA1_DATVIG = '"+Dtos(Ctod("//"))+ "' ) AND "

					If !lQtdCliVaz
						cQuery += "( DA1.DA1_TPOPER = ? OR DA1.DA1_TPOPER = '4' ) AND "
					Endif

					cQuery += "DA1.D_E_L_E_T_ = ' ' "
					cQuery += "AND NOT EXISTS ( "
					cQuery += "SELECT DA1C.DA1_CODPRO  "
					cQuery += "FROM "+RetSqlName("DA1")+ " DA1C "
					cQuery += "WHERE "
					cQuery += "DA1C.DA1_FILIAL = ? AND "
					cQuery += "DA1C.DA1_CODTAB = ? AND "
					cQuery += "DA1C.DA1_REFGRD = ? AND "
					cQuery += "DA1C.DA1_QTDLOT >= ? AND "
					cQuery += "DA1C.DA1_ATIVO = '1' AND  "
					cQuery += "( DA1C.DA1_DATVIG <= ? OR DA1C.DA1_DATVIG = '"+Dtos(Ctod("//"))+ "' ) AND "

					If !lQtdCliVaz
						cQuery += "( DA1C.DA1_TPOPER = ? OR DA1C.DA1_TPOPER = '4' ) AND "
					Endif
					cQuery += "DA1C.D_E_L_E_T_ = ' ' ) ) QRYDAI "

				Endif

				If lQtdCliVaz
					cQuery += "ORDER BY DA1_DATVIG ,"+SqlOrder(DA1->(IndexKey()))
				Else
					cQuery += "ORDER BY DA1_QTDLOT ,DA1_DATVIG ,"+SqlOrder(DA1->(IndexKey()))
				EndIf

				If !lGradeReal		
					If oQryDA1Tb1 == Nil .And. lQtdCliVaz
						cQuery := ChangeQuery(cQuery)
						oQryDA1Tb1 := IIf(__OMS010VerLib,FwExecStatement():New(cQuery),FWPreparedStatement():New(cQuery))
					EndIf
					
					If oQryDA1Tb2 == Nil .And. !lQtdCliVaz
						cQuery := ChangeQuery(cQuery)
						oQryDA1Tb2 := IIf(__OMS010VerLib,FwExecStatement():New(cQuery),FWPreparedStatement():New(cQuery))
					EndIf		

					If lQtdCliVaz
						oQryDA1Tb1:SetString(1,	DtoS(dDataVld))
						oQryDA1Tb1:SetString(2,	cFilDA1)
						oQryDA1Tb1:SetString(3,	cTabPreco)
						oQryDA1Tb1:SetString(4,	cProduto)
						oQryDA1Tb1:SetNumeric(5, Str(nQtde,18,8))

						If __OMS010VerLib
							oQryDA1Tb1:OpenAlias(cAliasDA1)
						Else
							cQuery := oQryDA1Tb1:GetFixQuery()
						EndIf
					Else
						oQryDA1Tb2:SetString(1, DtoS(dDataVld))
						oQryDA1Tb2:SetString(2, cTpOper)
						oQryDA1Tb2:SetString(3, cFilDA1)
						oQryDA1Tb2:SetString(4, cTabPreco)
						oQryDA1Tb2:SetString(5, cProduto)
						oQryDA1Tb2:SetNumeric(6, Str(nQtde,18,8))

						If __OMS010VerLib
							oQryDA1Tb2:OpenAlias(cAliasDA1)
						Else
							cQuery := oQryDA1Tb2:GetFixQuery()
						EndIf
					EndIf
				Else
					If oQryDA1Gd1 == Nil .And. lQtdCliVaz
						cQuery := ChangeQuery(cQuery)
						oQryDA1Gd1 := IIf(__OMS010VerLib,FwExecStatement():New(cQuery),FWPreparedStatement():New(cQuery))
					EndIf
					
					If oQryDA1Gd2 == Nil .And. !lQtdCliVaz
						cQuery := ChangeQuery(cQuery)
						oQryDA1Gd2 := IIf(__OMS010VerLib,FwExecStatement():New(cQuery),FWPreparedStatement():New(cQuery))
					EndIf

					If lQtdCliVaz
						oQryDA1Gd1:SetString(1, DtoS(dDataVld))
						oQryDA1Gd1:SetString(2, cFilDA1)
						oQryDA1Gd1:SetString(3, cTabPreco)
						oQryDA1Gd1:SetString(4, cProduto)
						oQryDA1Gd1:SetNumeric(5, Str(nQtde,18,8))
						oQryDA1Gd1:SetString(6, cFilDA1)
						oQryDA1Gd1:SetString(7, cTabPreco)
						oQryDA1Gd1:SetString(8, cProdRef)
						oQryDA1Gd1:SetNumeric(9, Str(nQtde,18,8))
						oQryDA1Gd1:SetString(10, DtoS(dDataVld))
						oQryDA1Gd1:SetString(11, cFilDA1)
						oQryDA1Gd1:SetString(12, cTabPreco)
						oQryDA1Gd1:SetString(13, cProduto+"%")
						oQryDA1Gd1:SetNumeric(14, Str(nQtde,18,8))
						oQryDA1Gd1:SetString(15, DtoS(dDataVld))
						oQryDA1Gd1:SetString(16, cFilDA1)
						oQryDA1Gd1:SetString(17, cTabPreco)
						oQryDA1Gd1:SetString(18, cProduto+"%")
						oQryDA1Gd1:SetNumeric(19, Str(nQtde,18,8))
						oQryDA1Gd1:SetString(20, DtoS(dDataVld))
						oQryDA1Gd1:SetString(21, cFilDA1)
						oQryDA1Gd1:SetString(22, cTabPreco)
						oQryDA1Gd1:SetString(23, cProdRef)
						oQryDA1Gd1:SetNumeric(24, Str(nQtde,18,8))
						oQryDA1Gd1:SetString(25, DtoS(dDataVld))

						If __OMS010VerLib
							oQryDA1Gd1:OpenAlias(cAliasDA1)
						Else
							cQuery := oQryDA1Gd1:GetFixQuery()
						EndIf
					Else
						oQryDA1Gd2:SetString(1,	DtoS(dDataVld))
						oQryDA1Gd2:SetString(2,	cTpOper)
						oQryDA1Gd2:SetString(3,	cFilDA1)
						oQryDA1Gd2:SetString(4,	cTabPreco)
						oQryDA1Gd2:SetString(5,	cProduto)
						oQryDA1Gd2:SetNumeric(6, Str(nQtde,18,8))
						oQryDA1Gd2:SetString(7,	cFilDA1)
						oQryDA1Gd2:SetString(8,	cTabPreco)
						oQryDA1Gd2:SetString(9,	cProdRef)
						oQryDA1Gd2:SetNumeric(10, Str(nQtde,18,8))
						oQryDA1Gd2:SetString(11, DtoS(dDataVld))
						oQryDA1Gd2:SetString(12, cTpOper)
						oQryDA1Gd2:SetString(13, cFilDA1)
						oQryDA1Gd2:SetString(14, cTabPreco)
						oQryDA1Gd2:SetString(15, cProduto+"%")
						oQryDA1Gd2:SetNumeric(16, Str(nQtde,18,8))
						oQryDA1Gd2:SetString(17, DtoS(dDataVld))
						oQryDA1Gd2:SetString(18, cTpOper)
						oQryDA1Gd2:SetString(19, cFilDA1)
						oQryDA1Gd2:SetString(20, cTabPreco)
						oQryDA1Gd2:SetString(21, cProduto+"%")
						oQryDA1Gd2:SetNumeric(22, Str(nQtde,18,8))
						oQryDA1Gd2:SetString(23, DtoS(dDataVld))
						oQryDA1Gd2:SetString(24, cTpOper)
						oQryDA1Gd2:SetString(25, cFilDA1)
						oQryDA1Gd2:SetString(26, cTabPreco)
						oQryDA1Gd2:SetString(27, cProdRef)
						oQryDA1Gd2:SetNumeric(28, Str(nQtde,18,8))
						oQryDA1Gd2:SetString(29, DtoS(dDataVld))
						oQryDA1Gd2:SetString(30, cTpOper)

						If __OMS010VerLib
							oQryDA1Gd2:OpenAlias(cAliasDA1)
						Else
							cQuery := oQryDA1Gd2:GetFixQuery()
						EndIf
					EndIf
				EndIf

				If !__OMS010VerLib
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDA1,.T.,.T.)
				EndIF

				If (cAliasDA1)->(!Eof())
					nProcessa := 1
				Else
					SB1->(dbSetOrder(1))
					If SB1->(MsSeek(xFilial("SB1")+cProduto))
						cGrupo := SB1->B1_GRUPO
						If !Empty(cGrupo)
							(cAliasDA1)->(dbCloseArea())
							cAliasDA1 := GetNextAlias()

							cQuery := "SELECT * "
							cQuery += "FROM "+RetSqlName("DA1")+ " DA1 "
							cQuery += "WHERE "
							cQuery += "DA1_FILIAL = ? AND "
							cQuery += "DA1_CODTAB = ? AND "
							If cPaisLoc == "BRA"
								cQuery += "DA1_GRUPO = ? AND "
							EndIf
							cQuery += "DA1_QTDLOT >= ? AND "
							cQuery += "DA1_ATIVO = '1' AND  "
							cQuery += "( DA1_DATVIG <= ? OR DA1_DATVIG = '"+Dtos(Ctod("//"))+ "' ) AND "
							If !lQtdCliVaz
								cQuery += "( DA1_TPOPER = ? OR DA1_TPOPER = '4' ) AND "
							Endif
							cQuery += "DA1.D_E_L_E_T_ = ' ' "
							cQuery += "ORDER BY "+SqlOrder(DA1->(IndexKey()))

							If oQryDA1Tb3 == Nil .And. lQtdCliVaz
								cQuery := ChangeQuery(cQuery)
								oQryDA1Tb3 := IIf(__OMS010VerLib,FwExecStatement():New(cQuery),FWPreparedStatement():New(cQuery))
							EndIf

							If oQryDA1Tb4 == Nil .And. !lQtdCliVaz
								cQuery := ChangeQuery(cQuery)
								oQryDA1Tb4 := IIf(__OMS010VerLib,FwExecStatement():New(cQuery),FWPreparedStatement():New(cQuery))
							EndIf

							If lQtdCliVaz
								If cPaisLoc == "BRA"
									oQryDA1Tb3:SetString(1, cFilDA1)
									oQryDA1Tb3:SetString(2, cTabPreco)
									oQryDA1Tb3:SetString(3, cGrupo)
									oQryDA1Tb3:SetNumeric(4, Str(nQtde,18,8))
									oQryDA1Tb3:SetString(5, DtoS(dDataVld))
								Else
									oQryDA1Tb3:SetString(1, cFilDA1)
									oQryDA1Tb3:SetString(2, cTabPreco)
									oQryDA1Tb3:SetNumeric(3, Str(nQtde,18,8))
									oQryDA1Tb3:SetString(4, DtoS(dDataVld))
								EndIf
								If __OMS010VerLib
									oQryDA1Tb3:OpenAlias(cAliasDA1)
								Else
									cQuery := oQryDA1Tb3:GetFixQuery()
								EndIf
							ELse
								If cPaisLoc == "BRA"
									oQryDA1Tb4:SetString(1, cFilDA1)
									oQryDA1Tb4:SetString(2, cTabPreco)
									oQryDA1Tb4:SetString(3, cGrupo)
									oQryDA1Tb4:SetNumeric(4, Str(nQtde,18,8))
									oQryDA1Tb4:SetString(5, DtoS(dDataVld))
									oQryDA1Tb4:SetString(6, cTpOper)
								Else
									oQryDA1Tb4:SetString(1, cFilDA1)
									oQryDA1Tb4:SetString(2, cTabPreco)
									oQryDA1Tb4:SetNumeric(3, Str(nQtde,18,8))
									oQryDA1Tb4:SetString(4, DtoS(dDataVld))
									oQryDA1Tb4:SetString(5, cTpOper)
								EndIf
								If __OMS010VerLib
									oQryDA1Tb4:OpenAlias(cAliasDA1)
								Else
									cQuery := oQryDA1Tb4:GetFixQuery()
								EndIf
							EndIf

							If !__OMS010VerLib
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDA1,.T.,.T.)
							EndIf

							If (cAliasDA1)->(!Eof())
								nProcessa := 2
							EndIf
						EndIf
					EndIf
				Endif
				For nY := 1 To Len(aStruDA1)
					If aStruDA1[nY,2]<>"C"
						TcSetField(cAliasDA1,aStruDA1[nY,1],aStruDA1[nY,2],aStruDA1[nY,3],aStruDA1[nY,4])
					EndIf
				Next nY
			Else
		#ENDIF
				lSeekDA1:= aPesqDA1(cTabPreco,cProduto)
				If lSeekDA1
					nProcessa := 1
				Else
					SB1->(dbSetOrder(1))
					If SB1->(MsSeek(xFilial("SB1")+cProduto))
						cGrupo := SB1->B1_GRUPO
						If !Empty(cGrupo)
							dbSelectarea("DA1")
							dbSetOrder(4)
							If MsSeek(cFilDA1+ cTabPreco + cGrupo)
								nProcessa := 2
							EndIf
						EndIF
					Endif
				EndIf
		
		#IFDEF TOP
			EndIf
		#ENDIF

		If nProcessa > 0
			If nQtde == 0 .And. Empty(cCliente)
				dbSelectArea(cAliasDA1)
				While (cAliasDA1)->(!Eof())
					nPrcVen   := (cAliasDA1)->DA1_PRCVEN
					nMoedaTab := (cAliasDA1)->DA1_MOEDA
					nFator    := (cAliasDA1)->DA1_PERDES

					lPrcDA1   := .T.
					dbSelectArea(cAliasDA1)
					dbSkip()
				Enddo
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Busco o preco e analiso a qtde de acordo com a faixa³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(cAliasDA1)
				While (cAliasDA1)->(!Eof()) .And. (cAliasDA1)->DA1_FILIAL == cFilDA1 .And.;
									(cAliasDA1)->DA1_CODTAB == cTabPreco .And.;
									If(nProcessa==1,Left((cAliasDA1)->DA1_CODPRO,nTamProd)== cProduto .Or. (cAliasDA1)->DA1_CODPRO==cProduto .Or. (cAliasDA1)->DA1_REFGRD == cProdRef,(cAliasDA1)->DA1_GRUPO==cGrupo)

					If nQtde <= (cAliasDA1)->DA1_QTDLOT .And. (cAliasDA1)->DA1_ATIVO == "1"

						If Empty((cAliasDA1)->DA1_ESTADO) .And. ((cAliasDA1)->DA1_TPOPER == cTpOper .Or. (cAliasDA1)->DA1_TPOPER == "4")

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica a vigencia do item                                   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

							nQtdLote := (cAliasDA1)->DA1_QTDLOT

							While (cAliasDA1)->(!Eof()) .And. (cAliasDA1)->DA1_FILIAL == cFilDA1 .And.;
																(cAliasDA1)->DA1_CODTAB == cTabPreco .And.;
																If(nProcessa==1,Left((cAliasDA1)->DA1_CODPRO,nTamProd)== cProduto .Or. (cAliasDA1)->DA1_CODPRO==cProduto .Or. (cAliasDA1)->DA1_REFGRD == cProdRef ,(cAliasDA1)->DA1_GRUPO==cGrupo) .And.;
																(cAliasDA1)->DA1_QTDLOT == nQtdLote .And.;
																(cAliasDA1)->DA1_DATVIG <= dDataVld
								If nQtde <= (cAliasDA1)->DA1_QTDLOT .And. (cAliasDA1)->DA1_ATIVO == "1" .And.;
									((!Empty((cAliasDA1)->DA1_ESTADO) .And. ( If( lProspect, SUS->US_EST, If( lSA1EstE, SA1->A1_ESTE, If( lFornec, SA2->A2_EST, SA1->A1_EST ) ) ) == (cAliasDA1)->DA1_ESTADO )).Or.(Empty((cAliasDA1)->DA1_ESTADO) .And. ((cAliasDA1)->DA1_TPOPER == cTpOper .Or. (cAliasDA1)->DA1_TPOPER == "4")))
									nPrcVen   := (cAliasDA1)->DA1_PRCVEN
									nMoedaTab := (cAliasDA1)->DA1_MOEDA
									nFator    := (cAliasDA1)->DA1_PERDES

									lPrcDA1   := .T.
								EndIf

								dbSelectArea(cAliasDA1)
								dbSkip()
							Enddo
							If lPrcDA1
								Exit
							Endif

						ElseIf !Empty((cAliasDA1)->DA1_ESTADO) .And. ( If( lProspect, SUS->US_EST, If( lSA1EstE, SA1->A1_ESTE, If( lFornec, SA2->A2_EST, SA1->A1_EST ) ) ) == (cAliasDA1)->DA1_ESTADO )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica a vigencia do item                                   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

							nQtdLote := (cAliasDA1)->DA1_QTDLOT

							While (cAliasDA1)->(!Eof()) .And. (cAliasDA1)->DA1_FILIAL == cFilDA1 .And.;
																	(cAliasDA1)->DA1_CODTAB == cTabPreco .And.;
																	If(nProcessa==1,Left((cAliasDA1)->DA1_CODPRO,nTamProd)== cProduto .Or. (cAliasDA1)->DA1_CODPRO==cProduto .Or. (cAliasDA1)->DA1_REFGRD == cProdRef,(cAliasDA1)->DA1_GRUPO==cGrupo) .And.;
																	(cAliasDA1)->DA1_QTDLOT == nQtdLote .And.;
																	(cAliasDA1)->DA1_DATVIG <= dDataVld
								If nQtde <= (cAliasDA1)->DA1_QTDLOT .And. (cAliasDA1)->DA1_ATIVO == "1" .And.;
									((!Empty((cAliasDA1)->DA1_ESTADO) .And. ( If( lProspect, SUS->US_EST, If( lSA1EstE, SA1->A1_ESTE, If( lFornec, SA2->A2_EST, SA1->A1_EST ) ) ) == (cAliasDA1)->DA1_ESTADO )).Or.(Empty((cAliasDA1)->DA1_ESTADO) .And. ((cAliasDA1)->DA1_TPOPER == cTpOper .Or. (cAliasDA1)->DA1_TPOPER == "4")))


									nPrcVen   := (cAliasDA1)->DA1_PRCVEN
									nMoedaTab := (cAliasDA1)->DA1_MOEDA
									nFator    := (cAliasDA1)->DA1_PERDES

									lPrcDA1   := .T.

								Endif

								dbSelectArea(cAliasDA1)
								dbSkip()
							Enddo
							If lPrcDA1
								Exit
							Endif

						EndIf
					EndIf
					dbSelectArea(cAliasDA1)
					dbSkip()
				Enddo

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Somente atualiza com o SB1 caso nao tenha achado nenhuma tabela    ³
				//³caso contrario retornara o preco zerado                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				If nTipo == 1
					If nPrcVen == 0 .And. !lPrcDA1
						If lLjcnvB0 .AND. nModulo == 12
							DbSelectArea("SB0")
							DbSetOrder(1)
							If DbSeek(xFilial("SB0")+cProduto)
								nPrcVen := SB0->B0_PRV1
							EndIf
						// No FrontLoja, é obrigatório ler o SBI
						ElseIf nModulo == 23 .And. !lPos
							DbSelectArea("SBI")
							SBI->(DbSetOrder(1))
							If SBI->(DbSeek(xFilial("SBI")+cProduto))
								nPrcVen := SBI->BI_PRV
							EndIf
						Else
							DbSelectArea("SB1")
							SB1->(DbSetOrder(1))
							If SB1->(MsSeek(xFilial("SB1")+cProduto))
								nPrcVen := SB1->B1_PRV1
							EndIf
						EndIf
						lUltResult := .F.
					Endif
				Endif

			EndIf
		Else
			If nTipo == 1
				If nPrcVen == 0 .And. !lPrcDA1
					If lLjcnvB0 .AND. nModulo == 12
						DbSelectArea("SB0")
						DbSetOrder(1)
						If DbSeek(xFilial("SB0")+cProduto)
							nPrcVen := SB0->B0_PRV1
						EndIf
					// No FrontLoja, é obrigatório ler o SBI
					ElseIf nModulo == 23 .AND. !lPOS
						DbSelectArea("SBI")
						DbSetOrder(1)
						If DbSeek(xFilial("SBI")+cProduto)
							nPrcVen := SBI->BI_PRV
						EndIf
					Else
						DbSelectArea("SB1")
						DbSetOrder(1)
						If MsSeek(xFilial("SB1")+cProduto)
							nPrcVen := SB1->B1_PRV1
						EndIf
					EndIf
				EndIf
			Endif
			lUltResult := .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o tipo for para trazer preco converte para a moeda    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		nFator := Iif( nFator == 0, 1, nFator )

		If nTipo == 1
			nResult := A410Arred(xMoeda(nPrcVen,nMoedaTab,nMoeda,,8),"D2_PRCVEN")
		Else
			nResult	:= nFator
		Endif


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Guarda os ultimos resultados                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lUltResult
			aadd(aUltResult,{cTabPreco,cProduto,nQtde,cCliente,cLoja,nMoeda,cFilAnt,nResult,nFator,lProspect})
			If Len(aUltResult) > MAXSAVERESULT
				aUltResult := aDel(aUltResult,1)
				aUltResult := aSize(aUltResult,MAXSAVERESULT)
			EndIf
		EndIf
	Else

		If nTipo == 1
			nResult := aUltResult[nScan,8]
		Else
			nResult := aUltResult[nScan,9]
		Endif
	EndIf
//Endif

If lQuery
	dbSelectArea(cAliasDA1)
	dbCloseArea()
	dbSelectArea("DA1")
Endif

RestArea(aAreaSB1)
RestArea(aArea)
Return(nResult)
