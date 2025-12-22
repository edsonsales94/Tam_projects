#Include "FINR350.CH"
#Include "PROTHEUS.CH"

#Define I_CORRECAO_MONETARIA     1
#Define I_DESCONTO               2
#Define I_JUROS                  3
#Define I_MULTA                  4
#Define I_VALOR_RECEBIDO         5
#Define I_VALOR_PAGO             6
#Define I_RECEB_ANT              7
#Define I_PAGAM_ANT              8
#Define I_MOTBX                  9
#Define I_RECPAG_REAIS          10

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR350  ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Fornecedores                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR350(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico INDT                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IFinR350
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 :=OemToAnsi(STR0001)  //"Este programa ir  emitir a posi‡„o dos fornecedores"
Local cDesc2 :=OemToAnsi(STR0002)  //"referente a data base do sistema."
Local cDesc3 :=""
Local cString:="SE2"
Local nMoeda

Private aLinha :={}
Private aReturn:={OemToAnsi(STR0003),1,OemToAnsi(STR0004),1,2,1,"",1}  //"Zebrado"###"Administracao"
Private cPerg  :="FIN350"
Private cabec1,cabec2,nLastKey:=0,titulo,wnrel,tamanho:="G"
Private nomeprog :="FINR350B"
Private aOrd :={OemToAnsi(STR0012),OemToAnsi(STR0013),"Por Centro de Custo" }  //"Por Codigo"###"Por Nome"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo:= OemToAnsi(STR0005)  //"Posicao dos Fornecedores "

cabec1:= "Prf Numero       PC Tip Valor Original Emissao   Vencto   Baixa                          P  A  G  A  M  E  N  T  O  S                                                                                     "
cabec2:= "                                                                              Centro de Custo                         Contrato                                   Valor Pago   Pagto.Antecip      Saldo Atual  Motivo"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN350",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³ mv_par01            // Do Fornecedor                     ³
//³ mv_par02            // Ate o Fornecedor                  ³
//³ mv_par03            // Da Loja                           ³
//³ mv_par04            // Ate a Loja                        ³
//³ mv_par05            // Da Emissao                        ³
//³ mv_par06            // Ate a Emissao                     ³
//³ mv_par07            // Do Vencimento                     ³
//³ mv_par08            // Ate o Vencimento                  ³
//³ mv_par09            // Imprime os t¡tulos provis¢rios    ³
//³ mv_par10            // Qual a moeda                      ³
//³ mv_par11            // Reajusta pela DataBase ou Vencto  ³
//³ mv_par12            // Considera Faturados               ³
//³ mv_par13            // Imprime Outras Moedas             ³
//³ mv_par14            // Considera Data Base               ³
//³ mv_par15            // Imprime Nome?(Raz.Social/N.Reduz.)³
//³ mv_par16            // Imprime PA? Sim ou Não            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="FINR350"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nMoeda := mv_par10
Titulo += " - " + GetMv("MV_MOEDA"+Str(nMoeda,1))

RptStatus({|lEnd| Fa350Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA350Imp ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Fornecedores                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA350Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA350Imp(lEnd,wnRel,cString)

Local CbTxt,cbCont,aImp:= {}
Local nOrdem,nTotAbat:=0
Local nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0,nTit6:=0,nTit7:=0,nTit8:=0,nTit9:=0
Local nSub1:=0,nSub2:=0,nSub3:=0,nSub4:=0,nSub5:=0,nSub6:=0,nSub7:=0,nSub8:=0,nSub9:=0
Local nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTot5:=0,nTot6:=0,nTot7:=0,nTot8:=0,nTot9:=0
Local lContinua:=.T.,cForAnt:=Space(6),nSaldo:=0,nValor:=0
Local aValor:= {0,0,0,0,0,0}

Local nMoeda:=0
Local dDataMoeda
Local cCond1,cCond2,cChave,cIndex
#IFDEF TOP
	Local cOrder
	Local aStru := SE2->(dbStruct()), ni
#ENDIF	
Local cFilterUser := aReturn[7]
Local ndecs:=Msdecimais(mv_par10)
Local cAliasSA2 := "SA2"
Local lImpPAPag	:= IiF(cPaisLoc <> "BRA" .And. MV_PAR16=2, .T. ,.F.)  //Imprime PA Gerada pela Ordem de Pago.
Local i
Private aDados := {}
dDataMoeda:=dDataBase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt :=Space(10)
cbcont:=00
li    :=80
m_pag :=01
nOrdem := aReturn[8]

nMoeda := mv_par10

SomaAbat("","","","P")

dbSelectArea("SE2")
If nOrdem == 1
	dbSetOrder(6)
	cChave := IndexKey()
	dbSeek (cFilial+mv_par01+mv_par03,.t.)
	cCond1 :='E2_FORNECE+E2_LOJA <= mv_par02+mv_par04 .and. E2_FILIAL == xFilial("SE2")'
	cCond2 := "E2_FORNECE+E2_LOJA"
	#IFDEF TOP
		cOrder := SqlOrder(cChave)
	#ENDIF
ElseIf nOrdem == 2
	cChave:= "E2_FILIAL+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
	#IFDEF TOP
		If TCSrvType() == "AS/400"
			cIndex	:= CriaTrab(nil,.f.)
			dbSelectArea("SE2")
			IndRegua("SE2",cIndex,cChave,,FR350FIL(),OemToAnsi(STR0014))  //"Selecionando Registros..."
			nIndex	:= RetIndex("SE2")
			dbSetOrder(nIndex+1)
		Else
			cOrder := SqlOrder(cChave)
		EndIf
	#ELSE
		cIndex	:= CriaTrab(nil,.f.)
		dbSelectArea("SE2")
		IndRegua("SE2",cIndex,cChave,,FR350FIL(),OemToAnsi(STR0014))  //"Selecionando Registros..."
		nIndex	:= RetIndex("SE2")
		dbSetIndex(cIndex+OrdBagExt())
		dbSetOrder(nIndex+1)
	#ENDIF
	cCond1 := ".T."
	cCond2 := "E2_NOMFOR"
	SE2->( dbGoTop() )
Else
	cChave:= "E2_FILIAL+E2_CC+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
	#IFDEF TOP
		If TCSrvType() == "AS/400"
			cIndex	:= CriaTrab(nil,.f.)
			dbSelectArea("SE2")
			IndRegua("SE2",cIndex,cChave,,FR350FIL(),OemToAnsi(STR0014))  //"Selecionando Registros..."
			nIndex	:= RetIndex("SE2")
			dbSetOrder(nIndex+1)
		Else
			cOrder := SqlOrder(cChave)
		EndIf
	#ELSE
		cIndex	:= CriaTrab(nil,.f.)
		dbSelectArea("SE2")
		IndRegua("SE2",cIndex,cChave,,FR350FIL(),OemToAnsi(STR0014))  //"Selecionando Registros..."
		nIndex	:= RetIndex("SE2")
		dbSetIndex(cIndex+OrdBagExt())
		dbSetOrder(nIndex+1)
	#ENDIF
	cCond1 := ".T."
	cCond2 := "E2_CC"
	SE2->( dbGoTop() )
EndIf
SetRegua(RecCount())

#IFDEF TOP
	If TcSrvType() != "AS/400"
		dbSelectArea("SE2")
		aStru := dbStruct()
		
		cQuery := "SELECT SE2.*,SA2.A2_COD,SA2.A2_NOME,SA2.A2_NREDUZ "
		cQuery += " FROM " + RetSqlName("SE2") +" SE2, "+ RetSqlName("SA2") +" SA2 "
		cQuery += " WHERE SE2.E2_FILIAL = '" + xFilial("SE2") + "'"
		cQuery += " AND SA2.A2_FILIAL = '" + xFilial("SA2") + "'"
		cQuery += " AND SE2.E2_FORNECE = SA2.A2_COD "
		cQuery += " AND SE2.E2_LOJA = SA2.A2_LOJA "
		cQuery += " AND SE2.E2_FORNECE between '" + mv_par01        + "' AND '" + mv_par02       + "'"
		cQuery += " AND SE2.E2_LOJA    between '" + mv_par03        + "' AND '" + mv_par04       + "'"
		cQuery += " AND SE2.E2_EMISSAO   between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
		cQuery += " AND SE2.E2_VENCREA between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
///		cQuery += " AND SE2.E2_CC between '" + mv_par22  + "' AND '" + mv_par23 + "'"
		cQuery += " AND SE2.E2_TIPO NOT IN " + FormatIn(MVABATIM,"|")
		cQuery += " AND SE2.E2_EMISSAO   <=  '"     + DTOS(dDataBase) + "'"
		If mv_par09 == 2
			cQuery += " AND SE2.E2_TIPO <> '"+MVPROVIS+"'"
		EndIf
		If mv_par12 == 2
			cQuery += " AND SE2.E2_FATURA IN('"+Space(Len(E2_FATURA))+"','NOTFAT')"
		Endif
		cQuery += " AND SE2.D_E_L_E_T_ <> '*' "
		cQuery += " AND SA2.D_E_L_E_T_ <> '*' "
		cQuery += " ORDER BY " + cOrder

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'NEWSE2', .T., .T.)

		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C' .and. FieldPos(aStru[ni,1]) > 0
				TCSetField('NEWSE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
		cAliasSA2 := "NEWSE2"
	EndIf
#ENDIF








	While !Eof() .And. lContinua .And. &cCond1
		dbSelectArea("NEWSE2")
		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0008)  //"CANCELADO PELO OPERADOR"
			Exit
		EndIF
		If !Empty(cFilterUser).and.!(&cFilterUser)
			dbSelectArea("NEWSE2")
			dbSkip()
			Loop
		Endif

		nCont:=1
		nTit1:=nTit2:=nTit3:=nTit4:=nTit5:=nTit6:=nTit7:=nTit8:=nTit9:=0
		cForAnt:= &cCond2
		While &cCond2 == cForAnt .And. lContinua .And. &cCond1 .And. !Eof()
			If (ALLTRIM(E2_TIPO)$MV_CPNEG+","+MVPAGANT .or. SUBSTR(E2_TIPO,3,1)=="-").and. "FINA085" $ Upper( AllTrim( E2_ORIGEM));
				.and. cPaisLoc <>"BRA" .And. lImpPAPag // Nao imprime o PA qdo ele for gerado pela Ordem de Pago
				dbSelectArea("NEWSE2")
				dbSkip()
				Loop
			Else
				If !Empty(cFilterUser).and.!(&cFilterUser)
					dbSelectArea("NEWSE2")
					dbSkip()
					Loop
				Endif
				If !Fr350Skip()
					dbSelectArea("NEWSE2")
					dbSkip()
					Loop
				EndIf



				#IFDEF TOP
					If TcSrvType() == "AS/400"	
						dbSelectArea(cAliasSA2)
						dbSeek(xFilial("SA2")+NEWSE2->E2_FORNECE+NEWSE2->E2_LOJA)
					Endif
				#ELSE
					dbSelectArea(cAliasSA2)
					dbSeek(xFilial("SA2")+NEWSE2->E2_FORNECE+NEWSE2->E2_LOJA)
				#ENDIF

				If li > 58
					Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				Endif
				dbSelectArea("NEWSE2")
				If mv_par11 == 1
				   dDataMoeda:=	dDataBase
				Else
				   dDataMoeda:=	NEWSE2->E2_VENCREA
				Endif
				aValor:= Baixas( NEWSE2->E2_NATUREZA,NEWSE2->E2_PREFIXO,NEWSE2->E2_NUM,NEWSE2->E2_PARCELA,NEWSE2->E2_TIPO,nMoeda,"P",NEWSE2->E2_FORNECE,dDataBase,NEWSE2->E2_LOJA)
				If mv_par14 == 1
					nSaldo := SaldoTit(NEWSE2->E2_PREFIXO,NEWSE2->E2_NUM,NEWSE2->E2_PARCELA,NEWSE2->E2_TIPO,NEWSE2->E2_NATUREZA,"P",NEWSE2->E2_FORNECE,nMoeda,dDataMoeda,,NEWSE2->E2_LOJA,,If(cPaisLoc=="BRA",NEWSE2->E2_TXMOEDA,0))
				Else
					nSaldo := xMoeda((NEWSE2->E2_SALDO+NEWSE2->E2_SDACRES-NEWSE2->E2_SDDECRE),NEWSE2->E2_MOEDA,mv_par10,,,If(cPaisLoc=="BRA",NEWSE2->E2_TXMOEDA,0))
				Endif
				nTotAbat:= SomaAbat(NEWSE2->E2_PREFIXO,NEWSE2->E2_NUM,NEWSE2->E2_PARCELA,"P",mv_par10,,NEWSE2->E2_FORNECE,NEWSE2->E2_LOJA)
				aValor[I_JUROS] += NEWSE2->E2_SDACRES
				aValor[I_DESCONTO] += NEWSE2->E2_SDDECRE
				If ! (NEWSE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. !( MV_PAR14 == 2 .And. nSaldo == 0 ) 
					nSaldo -= nTotAbat
				EndIf
				If !Empty(NEWSE2->E2_DTFATUR) .and. NEWSE2->E2_DTFATUR <= dDataBase
					aValor[I_MOTBX] := STR0015  //"Faturado"
					aValor[I_VALOR_PAGO] -= nTotAbat
				Endif

				aImp:= VerImposto()   
	            nValor:= xMoeda(NEWSE2->E2_VALOR,NEWSE2->E2_MOEDA,nMoeda,NEWSE2->E2_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",NEWSE2->E2_TXMOEDA,0))



                nPerc := 0 
                lRatCC := .T.
				If NEWSE2->E2_MULTNAT == "1"
					cChaveSEV := NEWSE2->E2_FILIAL+NEWSE2->E2_PREFIXO+NEWSE2->E2_NUM+NEWSE2->E2_PARCELA+NEWSE2->E2_TIPO+NEWSE2->E2_FORNECE+NEWSE2->E2_LOJA
					SEV->(DbSetOrder(1))
					SEV->(DbSeek(cChaveSEV))
					While cChaveSEV == SEV->EV_FILIAL+SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA
						If SEV->EV_RATEICC == "1"
							cChaveSEZ := SEV->EV_FILIAL+SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA+SEV->EV_NATUREZ
							SEZ->(DbSetOrder(1))
							SEZ->(DbSeek(cChaveSEZ)) 
							cCusto := ""
							While cChaveSEZ == SEZ->EZ_FILIAL+SEZ->EZ_PREFIXO+SEZ->EZ_NUM+SEZ->EZ_PARCELA+SEZ->EZ_TIPO+SEZ->EZ_CLIFOR+SEZ->EZ_LOJA+SEZ->EZ_NATUREZ
							    If cCusto <> SEZ->EZ_CCUSTO
									If !Empty(cCusto)
										If cCusto >= mv_par22 .And.cCusto <= mv_par23
									   		AAdd(aDados,{NEWSE2->E2_PREFIXO+"-"+NEWSE2->E2_NUM,NEWSE2->E2_PARCELA,NEWSE2->E2_TIPO,nValor,NEWSE2->E2_EMISSAO,;
												NEWSE2->E2_VENCREA,NEWSE2->E2_BAIXA,cCusto,NEWSE2->E2_NUMCONT,aValor,nSaldo,NEWSE2->E2_VALOR,;
												NEWSE2->E2_MOEDA,NEWSE2->E2_TXMOEDA,nTotAbat,aImp,NEWSE2->E2_FORNECE,NEWSE2->E2_LOJA,;
												(cAliasSA2)->A2_NOME,(cAliasSA2)->A2_NREDUZ,nPercTmp*(SEV->EV_PERC)})                            
										EndIf		
									EndIf 
									cCusto := SEZ->EZ_CCUSTO
									nPercTmp := 0
							    EndIf
								nPercTmp +=	SEZ->EZ_PERC
								SEZ->(DbSkip())
							End
							If cCusto >= mv_par22 .And.cCusto <= mv_par23
						   		AAdd(aDados,{NEWSE2->E2_PREFIXO+"-"+NEWSE2->E2_NUM,NEWSE2->E2_PARCELA,NEWSE2->E2_TIPO,nValor,NEWSE2->E2_EMISSAO,;
									NEWSE2->E2_VENCREA,NEWSE2->E2_BAIXA,cCusto,NEWSE2->E2_NUMCONT,aValor,nSaldo,NEWSE2->E2_VALOR,;
									NEWSE2->E2_MOEDA,NEWSE2->E2_TXMOEDA,nTotAbat,aImp,NEWSE2->E2_FORNECE,NEWSE2->E2_LOJA,;
									(cAliasSA2)->A2_NOME,(cAliasSA2)->A2_NREDUZ,nPercTmp*SEV->EV_PERC})                            
							EndIf		
						Else
							nPerc+= SEV->EV_PERC
						EndIf
						SEV->(DbSkip())
					End
				Else 
					If NEWSE2->E2_CC < mv_par22 .Or. NEWSE2->E2_CC > mv_par23
						dbSelectArea("NEWSE2")
						dbSkip()
						Loop
					EndIf
					nPerc+= 1

				EndIf

			
                If nPerc > 0
					AAdd(aDados,{NEWSE2->E2_PREFIXO+"-"+NEWSE2->E2_NUM,NEWSE2->E2_PARCELA,NEWSE2->E2_TIPO,nValor,NEWSE2->E2_EMISSAO,;
								 NEWSE2->E2_VENCREA,NEWSE2->E2_BAIXA,NEWSE2->E2_CC,NEWSE2->E2_NUMCONT,aValor,nSaldo,NEWSE2->E2_VALOR,;
								 NEWSE2->E2_MOEDA,NEWSE2->E2_TXMOEDA,nTotAbat,aImp,NEWSE2->E2_FORNECE,NEWSE2->E2_LOJA,;
								 (cAliasSA2)->A2_NOME,(cAliasSA2)->A2_NREDUZ,nPerc})
				EndIf				 


				dbSelectArea("NEWSE2")
				dbSkip()
			Endif
		Enddo
	EndDo

	
	cForAnt := ""
    cTitulo := ""
	For nR := 1 to Len(aDados)
		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0008)  //"CANCELADO PELO OPERADOR"
			Exit
		EndIF
		If lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0008)  //"CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		IncRegua()
		If li > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		Endif

		If cForAnt <> aDados[nR,17]+aDados[nR,18]
			If !Empty(cForAnt)
				If ( ABS(nTit1)+ABS(nTit2)+ABS(nTit3)+ABS(nTit4)+ABS(nTit5)+ABS(nTit6)+ABS(nTit7)+ABS(nTit8)+ABS(nTit9) > 0 )
					ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9)
					li++
				Endif
			EndIf
			nCont:=1
			nTit1:=nTit2:=nTit3:=nTit4:=nTit5:=nTit6:=nTit7:=nTit8:=nTit9:=0
			cForAnt:= aDados[nR,17]+aDados[nR,18]

			@li,0 PSAY OemToAnsi(STR0009)+aDados[nR,17]+" "+IIF(mv_par15 == 1,aDados[nR,19],aDados[nR,20])  //"FORNECEDOR : "
			li+=2

		EndIf    
		

		If cTitulo <> aDados[nR,1]
			If !Empty(cTitulo)
				If ( ABS(nDoc1)+ABS(nDoc2)+ABS(nDoc3)+ABS(nDoc4)+ABS(nDoc5)+ABS(nDoc6)+ABS(nDoc7)+ABS(nDoc8)+ABS(nDoc9) > 0 )
					ImpSubDoc(nDoc1,nDoc2,nDoc3,nDoc4,nDoc5,nDoc6,nDoc7,nDoc8,nDoc9,cTitulo)
					li++
				Endif
			EndIf
			nCont:=1
  		    nDoc1:=nDoc2:=nDoc3:=nDoc4:=nDoc5:=nDoc6:=nDoc7:=nDoc8:=nDoc9:=0
			cTitulo := aDados[nR,1]
		EndIf    

                    //   1                                     2                  3               4      5                  6                  7                8             9                  10     11     12               13               14                 15       16   17                 18              19                   20                     21
//			AAdd(aDados,{NEWSE2->E2_PREFIXO+"-"+NEWSE2->E2_NUM,NEWSE2->E2_PARCELA,NEWSE2->E2_TIPO,nValor,NEWSE2->E2_EMISSAO,NEWSE2->E2_VENCREA,NEWSE2->E2_BAIXA,NEWSE2->E2_CC,NEWSE2->E2_NUMCONT,aValor,nSaldo,NEWSE2->E2_VALOR,NEWSE2->E2_MOEDA,NEWSE2->E2_TXMOEDA,nTotAbat,aImp,NEWSE2->E2_FORNECE,NEWSE2->E2_LOJA,(cAliasSA2)->A2_NOME,(cAliasSA2)->A2_NREDUZ,nPerc})

		@li,00 PSAY aDados[nR,1] //NEWSE2->E2_PREFIXO+"-"+NEWSE2->E2_NUM
		@li,17 PSAY aDados[nR,2] //NEWSE2->E2_PARCELA
		@li,20 PSAY aDados[nR,3] //NEWSE2->E2_TIPO
		@li,24 PSAY SayValor(aDados[nR,4]*aDados[nR,21],15,alltrim(aDados[nR,3])$"PA ,"+MV_CPNEG,nDecs)
		@li,41 PSAY aDados[nR,5] //NEWSE2->E2_EMISSAO
		@li,53 PSAY aDados[nR,6] //NEWSE2->E2_VENCREA
		If dDataBase >= aDados[nR,7]
			@li,65 PSAY IIF(!Empty(aDados[nR,7]),aDados[nR,7]," ")
		Endif            
		@li, 78 PSAY aDados[nR,8]+" - "+Posicione("CTT",1,xFilial("CTT")+aDados[nR,8],"CTT_DESC01")
		@li,131 PSAY aDados[nR,9] //NEWSE2->E2_NUMCONT
		@li,156 PSAY aDados[nR,10,I_VALOR_PAGO]*aDados[nR,21]         Picture PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
		@li,172 PSAY aDados[nR,10,I_PAGAM_ANT]*aDados[nR,21]          Picture PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
		@li,188 PSAY SayValor(aDados[nR,11]*aDados[nR,21],16,alltrim(aDados[nR,3])$"PA ,"+MV_CPNEG,nDecs)		
		@li,206 PSAY aDados[nR,10,I_MOTBX]
	    li++
		If ! ( aDados[nR,3] $ MVPAGANT+"/"+MV_CPNEG )
			nTit1+= xMoeda(aDados[nR,12],aDados[nR,13],nMoeda,aDados[nR,5],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,14],0))*aDados[nR,21]
			nTit9+= aDados[nR,11]*aDados[nR,21]
			nTit7+= aDados[nR,10,I_VALOR_PAGO]*aDados[nR,21]

			nTot1+= xMoeda(aDados[nR,12],aDados[nR,13],nMoeda,aDados[nR,5],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,14],0))*aDados[nR,21]
			nTot9+= aDados[nR,11]*aDados[nR,21]
			nTot7+= aDados[nR,10,I_VALOR_PAGO]*aDados[nR,21]

			nDoc1+= xMoeda(aDados[nR,12],aDados[nR,13],nMoeda,aDados[nR,5],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,14],0))*aDados[nR,21]
			nDoc9+= aDados[nR,11]*aDados[nR,21]
			nDoc7+= aDados[nR,10,I_VALOR_PAGO]*aDados[nR,21]
		Else
			nTit1-= xMoeda(aDados[nR,12],aDados[nR,13],nMoeda,aDados[nR,5],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,14],0))*aDados[nR,21]
			nTit9-= aDados[nR,11]*aDados[nR,21]
			nTit7-= aDados[nR,10,I_VALOR_PAGO]*aDados[nR,21]

			nTot1-= xMoeda(aDados[nR,12],aDados[nR,13],nMoeda,aDados[nR,5],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,14],0))*aDados[nR,21]
			nTot9-= aDados[nR,11]*aDados[nR,21]
			nTot7-= aDados[nR,10,I_VALOR_PAGO]*aDados[nR,21]

			nDoc1-= xMoeda(aDados[nR,12],aDados[nR,13],nMoeda,aDados[nR,5],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,14],0))*aDados[nR,21]
			nDoc9-= aDados[nR,11]*aDados[nR,21]
			nDoc7-= aDados[nR,10,I_VALOR_PAGO]*aDados[nR,21]
		Endif
		nTit2+=aDados[nR,10,I_DESCONTO]*aDados[nR,21]
		nTit3+=aDados[nR,15]*aDados[nR,21]
		nTit4+=aDados[nR,10,I_JUROS]*aDados[nR,21]
		nTit5+=aDados[nR,10,I_MULTA]*aDados[nR,21]
		nTit6+=aDados[nR,10,I_CORRECAO_MONETARIA]*aDados[nR,21]
		nTit8+=aDados[nR,10,I_PAGAM_ANT]*aDados[nR,21]

		nTot2+=aDados[nR,10,I_DESCONTO]*aDados[nR,21]
		nTot3+=aDados[nR,15]*aDados[nR,21]
		nTot4+=aDados[nR,10,I_JUROS]*aDados[nR,21]
		nTot5+=aDados[nR,10,I_MULTA]*aDados[nR,21]
		nTot6+=aDados[nR,10,I_CORRECAO_MONETARIA]*aDados[nR,21]
		nTot8+=aDados[nR,10,I_PAGAM_ANT]*aDados[nR,21]

		nDoc2+=aDados[nR,10,I_DESCONTO]*aDados[nR,21]
		nDoc3+=aDados[nR,15]*aDados[nR,21]
		nDoc4+=aDados[nR,10,I_JUROS]*aDados[nR,21]
		nDoc5+=aDados[nR,10,I_MULTA]*aDados[nR,21]
		nDoc6+=aDados[nR,10,I_CORRECAO_MONETARIA]*aDados[nR,21]
		nDoc8+=aDados[nR,10,I_PAGAM_ANT]*aDados[nR,21]
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao de impostos e taxas (IR, PIS, COFINS, CSLL, INSS, ISS)  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aImp) > 0	        
			nSub1:= aDados[nR,4]*aDados[nR,21]
			nSub2:= aDados[nR,10,I_DESCONTO]*aDados[nR,21]
			nSub3:= aDados[nR,15]*aDados[nR,21]
			nSub4:= aDados[nR,10,I_JUROS]*aDados[nR,21]
			nSub5:= aDados[nR,10,I_MULTA]*aDados[nR,21]
			nSub6:= aDados[nR,10,I_CORRECAO_MONETARIA]*aDados[nR,21]
			nSub7:= aDados[nR,10,I_VALOR_PAGO]*aDados[nR,21]
			nSub8:= aDados[nR,10,I_PAGAM_ANT]*aDados[nR,21]         
			nSub9:= aDados[nR,11]*aDados[nR,21]
		Else
			@li, 0 PSAY REPLICATE("-",220)
			li++
			nSub1:= nSub2:= nSub3:= nSub4:= nSub5:= nSub6:= nSub7:= nSub8:= nSub9:= 0.00
		Endif   
		For i:= 1 to Len(aDados[nR,16])	        
			If mv_par11 == 1
				dDataMoeda:= dDataBase
			Else
				dDataMoeda:= aDados[nR,16,i,7]
			Endif            
			aValor:= Baixas(aDados[nR,16,i,5],aDados[nR,16,i,1],aDados[nR,16,i,2],aDados[nR,16,i,3],aDados[nR,16,i,4],nMoeda,"P",aDados[nR,16,i,9],dDataBase,aDados[nR,16,i,10])
			If mv_par14 == 1
				nSaldo:= SaldoTit(aDados[nR,16,i,1],aDados[nR,16,i,2],aDados[nR,16,i,3],aDados[nR,16,i,4],aDados[nR,16,i,5],"P",aDados[nR,16,i,9],nMoeda,dDataMoeda,,aDados[nR,16,i,10],,If(cPaisLoc=="BRA",aDados[nR,16,i,11],0))
			Else
				nSaldo:= xMoeda((aDados[nR,16,i,13]+aDados[nR,16,i,14]-aDados[nR,16,i,15]),aDados[nR,16,i,12],mv_par10,,,If(cPaisLoc=="BRA",aDados[nR,16,i,11],0))
			Endif
			nTotAbat:= SomaAbat(aDados[nR,16,i,1],aDados[nR,16,i,2],aDados[nR,16,i,3],"P",mv_par10,,aDados[nR,16,i,9],aDados[nR,16,i,10])

			aValor[I_JUROS] += aDados[nR,16,i,14]
			aValor[I_DESCONTO] += aDados[nR,16,i,15]

			If !(aDados[nR,16,i,4] $ MVPAGANT+"/"+MV_CPNEG) .And. !( MV_PAR14 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
				nSaldo -= nTotAbat
			EndIf

			If !Empty(aDados[nR,16,i,16]) .and. aDados[nR,16,i,16] <= dDataBase
				aValor[I_MOTBX] := STR0015  //"Faturado"
				aValor[I_VALOR_PAGO] -= nTotAbat
			Endif
			nValor:= xMoeda(aDados[nR,16,i,17],aDados[nR,16,i,12],nMoeda,aDados[nR,16,i,6],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,16,i,11],0))
			   
			If li > 58
				Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
			Endif
			
			@li,00 PSAY aDados[nR,16,i,3]+"-"+Padr(aDados[nR,16,i,21],17)
			@li,20 PSAY aDados[nR,16,i,22]		   
			@li,24 PSAY SayValor(nValor*aDados[nR,21],15, Alltrim(aDados[nR,16,i,4])$"PA ,"+MV_CPNEG,nDecs)
			@li,41 PSAY aDados[nR,16,i,18]
			@li,53 PSAY aDados[nR,16,i,19]
			If dDataBase >= aDados[nR,16,i,20]
				@li,65 PSAY IIF(!Empty(aDados[nR,16,i,20]),aDados[nR,16,i,20]," ")
			Endif
			@li,156 PSAY aValor[I_VALOR_PAGO]*aDados[nR,21]         Picture PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
			@li,172 PSAY aValor[I_PAGAM_ANT]*aDados[nR,21]          Picture PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
			@li,188 PSAY SayValor(nSaldo*aDados[nR,21],16,alltrim(aDados[nR,16,i,4])$"PA ,"+MV_CPNEG,nDecs)		
			@li,206 PSAY aValor[I_MOTBX]
			li++

			If !( aDados[nR,16,i,4] $ MVPAGANT+"/"+MV_CPNEG )
				nTit1+= xMoeda(aDados[nR,16,i,17],aDados[nR,16,i,12],nMoeda,aDados[nR,16,i,6],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,16,i,11],0))*aDados[nR,21]
				nTit9+=nSaldo*aDados[nR,21]
				nTit7+=aValor[I_VALOR_PAGO]*aDados[nR,21]

				nTot1+= xMoeda(aDados[nR,16,i,17],aDados[nR,16,i,12],nMoeda,aDados[nR,16,i,6],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,16,i,11],0))*aDados[nR,21]
				nTot9+=nSaldo*aDados[nR,21]
				nTot7+=aValor[I_VALOR_PAGO]*aDados[nR,21]

				nDoc1+= xMoeda(aDados[nR,16,i,17],aDados[nR,16,i,12],nMoeda,aDados[nR,16,i,6],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,16,i,11],0))*aDados[nR,21]
				nDoc9+=nSaldo*aDados[nR,21]
				nDoc7+=aValor[I_VALOR_PAGO]*aDados[nR,21]
			Else
				nTit1-= xMoeda(aDados[nR,16,i,17],aDados[nR,16,i,12],nMoeda,aDados[nR,16,i,6],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,16,i,11],0))*aDados[nR,21]
				nTit9-=nSaldo*aDados[nR,21]
				nTit7-=aValor[I_VALOR_PAGO]*aDados[nR,21]

				nTot1-= xMoeda(aDados[nR,16,i,17],aDados[nR,16,i,12],nMoeda,aDados[nR,16,i,6],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,16,i,11],0))*aDados[nR,21]
				nTot9-=nSaldo*aDados[nR,21]
				nTot7-=aValor[I_VALOR_PAGO]*aDados[nR,21]

				nDoc1-= xMoeda(aDados[nR,16,i,17],aDados[nR,16,i,12],nMoeda,aDados[nR,16,i,6],ndecs+1,If(cPaisLoc=="BRA",aDados[nR,16,i,11],0))*aDados[nR,21]
				nDoc9-=nSaldo*aDados[nR,21]
				nDoc7-=aValor[I_VALOR_PAGO]*aDados[nR,21]
			Endif
			nTit2+= aValor[I_DESCONTO]*aDados[nR,21]
			nTit3+= nTotAbat*aDados[nR,21]
			nTit4+= aValor[I_JUROS]*aDados[nR,21]
			nTit5+= aValor[I_MULTA]*aDados[nR,21]
			nTit6+= aValor[I_CORRECAO_MONETARIA]*aDados[nR,21]
			nTit8+= aValor[I_PAGAM_ANT]*aDados[nR,21]

			nTot2+= aValor[I_DESCONTO]*aDados[nR,21]
			nTot3+= nTotAbat*aDados[nR,21]
			nTot4+= aValor[I_JUROS]*aDados[nR,21]
			nTot5+= aValor[I_MULTA]*aDados[nR,21]
			nTot6+= aValor[I_CORRECAO_MONETARIA]*aDados[nR,21]
			nTot8+= aValor[I_PAGAM_ANT]*aDados[nR,21]

			nDoc2+= aValor[I_DESCONTO]*aDados[nR,21]
			nDoc3+= nTotAbat*aDados[nR,21]
			nDoc4+= aValor[I_JUROS]*aDados[nR,21]
			nDoc5+= aValor[I_MULTA]*aDados[nR,21]
			nDoc6+= aValor[I_CORRECAO_MONETARIA]*aDados[nR,21]
			nDoc8+= aValor[I_PAGAM_ANT]*aDados[nR,21]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acumulando os valores do documento (IR, PIS, COFINS, CSLL, INSS, ISS)  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nSub1+= nValor*aDados[nR,21]
			nSub2+= aValor[I_DESCONTO]*aDados[nR,21]
			nSub3+= nTotAbat*aDados[nR,21]          
			nSub4+= aValor[I_JUROS]*aDados[nR,21]   
			nSub5+= aValor[I_MULTA]*aDados[nR,21]   
			nSub6+= aValor[I_CORRECAO_MONETARIA]*aDados[nR,21]
			nSub7+= aValor[I_VALOR_PAGO]*aDados[nR,21]        
			nSub8+= aValor[I_PAGAM_ANT]*aDados[nR,21]         
			nSub9+= nSaldo*aDados[nR,21]
		Next
		If ( ABS(nSub1)+ABS(nSub2)+ABS(nSub3)+ABS(nSub4)+ABS(nSub5)+ABS(nSub6)+ABS(nSub7)+ABS(nSub8)+ABS(nSub9) > 0 )
			ImpTotTit(nSub1,nSub2,nSub3,nSub4,nSub5,nSub6,nSub7,nSub8,nSub9)
			li++
		Endif
	Next

	If ( ABS(nDoc1)+ABS(nDoc2)+ABS(nDoc3)+ABS(nDoc4)+ABS(nDoc5)+ABS(nDoc6)+ABS(nDoc7)+ABS(nDoc8)+ABS(nDoc9) > 0 )
		ImpSubDoc(nDoc1,nDoc2,nDoc3,nDoc4,nDoc5,nDoc6,nDoc7,nDoc8,nDoc9,cTitulo)
		li++
	Endif

	If ( ABS(nTit1)+ABS(nTit2)+ABS(nTit3)+ABS(nTit4)+ABS(nTit5)+ABS(nTit6)+ABS(nTit7)+ABS(nTit8)+ABS(nTit9) > 0 )
		ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9)
		li++
	Endif


IF li > 55 .and. li != 80
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
EndIF

IF li != 80
	ImpTotG(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9)
	roda(cbcont,cbtxt,tamanho)
EndIF

Set Device To Screen

#IFNDEF TOP
	//dbSelectArea("SE2")
	//dbClearFil()
	//RetIndex( "SE2" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		dbSelectArea("NEWSE2")
		dbCloseArea()
		ChkFile("SE2")
		dbSelectArea("SE2")
		dbSetOrder(1)
	else
		dbSelectArea("SE2")
		dbClearFil()
		RetIndex( "SE2" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpSubTot ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprimir linha de SubTotal do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ImpSubTot()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9)
li++
@li,000 PSAY OemToAnsi(STR0010)  //"Totais : "
@li,024 PSAY nTit1  Picture PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
/*
@li,076 PSAY nTit2  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,092 PSAY nTit3  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,108 PSAY nTit4  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,124 PSAY nTit5  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,140 PSAY nTit6  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
*/
@li,156 PSAY nTit7  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,172 PSAY nTit8  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,188 PSAY nTit9  PicTure PesqPict("NEWSE2","E2_VALOR",16,MV_PAR10)
li++
@li,  0 PSAY REPLICATE("-",220)
li++
Return(.T.)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpSubTot ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprimir linha de SubTotal do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ImpSubTot()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpSubDoc(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9,cTitulo)
@li,000 PSAY cTitulo
@li,024 PSAY nTit1  Picture PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,156 PSAY nTit7  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,172 PSAY nTit8  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,188 PSAY nTit9  PicTure PesqPict("NEWSE2","E2_VALOR",16,MV_PAR10)
li++
@li,  0 PSAY REPLICATE("-",220)
li++
Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpTotG  ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir linha de Total do Relatorio                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpTotG()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpTotg(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9)
li++
@li,000 PSAY OemToAnsi(STR0011)  //"TOTAL GERAL ---->"

@li,024 PSAY nTot1  Picture PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
/*
@li,076 PSAY nTot2  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,092 PSAY nTot3  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,108 PSAY nTot4  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,124 PSAY nTot5  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,140 PSAY nTot6  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
*/
@li,156 PSAY nTot7  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,172 PSAY nTot8  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,188 PSAY nTot9  PicTure PesqPict("NEWSE2","E2_VALOR",16,MV_PAR10)
li++
Return(.t.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FR350FIL  ³ Autor ³ Andreia          	    ³ Data ³ 12.01.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FR350FIL()
Local cString

cString := 'E2_FILIAL="'+xFilial()+'".And.'
cString += 'dtos(E2_EMISSAO  )>="'+dtos(mv_par05)+'".and.dtos(E2_EMISSAO  )<="'+dtos(mv_par06)+'".And.'
cString += 'dtos(E2_VENCREA)>="'+dtos(mv_par07)+'".and.dtos(E2_VENCREA)<="'+dtos(mv_par08)+'".And.'
cString += 'E2_FORNECE>="'+mv_par01+'".and.E2_FORNECE<="'+mv_par02+'".And.'
cString += 'E2_LOJA>="'+mv_par03+'".and.E2_LOJA<="'+mv_par04+'"'
///cString += 'E2_CC>="'+mv_par22+'".and.E2_CC<="'+mv_par23+'"'

Return cString

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr350Skip ³ Autor ³ Pilar S. Albaladejo   |Data  ³ 13.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR350.PRX												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr350Skip()

Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ_ÄÄÄÄÄ¿
//³ Verifica se esta dentro dos parametros                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF  NEWSE2->E2_FORNECE < mv_par01 .OR. NEWSE2->E2_FORNECE > mv_par02 .OR. ;
    NEWSE2->E2_LOJA    < mv_par03 .OR. NEWSE2->E2_LOJA    > mv_par04 .OR. ;
    NEWSE2->E2_EMISSAO < mv_par05 .OR. NEWSE2->E2_EMISSAO > mv_par06 .OR. ;
    NEWSE2->E2_VENCREA < mv_par07 .OR. NEWSE2->E2_VENCREA > mv_par08 .OR. ;
    NEWSE2->E2_TIPO $ MVABATIM
///    NEWSE2->E2_CC < mv_par22 .OR. NEWSE2->E2_CC > mv_par23 .OR. ;
    lRet :=  .F.
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifica se o t¡tulo ‚ provis¢rio                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf (NEWSE2->E2_TIPO $ MVPROVIS .and. mv_par09==2)
	lRet := .F.

ElseIF NEWSE2->E2_EMISSAO   > dDataBase
	lRet := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo foi aglutinado em uma fatura            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf !Empty(NEWSE2->E2_FATURA) .and. Substr(NEWSE2->E2_FATURA,1,6)!="NOTFAT" .and. !Empty( NEWSE2->E2_DTFATUR ) .and. DtoS( NEWSE2->E2_DTFATUR ) <= DtoS( mv_par06 )
	lRet := IIF(mv_par12 == 1, .T., .F.)	// Considera Faturados = mv_par12

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se deve imprimir outras moedas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Elseif mv_par13 == 2 // nao imprime
	If NEWSE2->E2_MOEDA != mv_par10 //verifica moeda do campo=moeda parametro
		lret := .F.
	Endif
Endif
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SayValor  ³ Autor ³ J£lio Wittwer    	  ³ Data ³ 24.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna String de valor entre () caso Valor < 0 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR350.PRX												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SayValor(nNum,nTam,lInvert,nDecs)
Local cPicture,cRetorno
nDecs := IIF(nDecs == NIL, 2, nDecs)

cPicture := tm(nNum,nTam,nDecs)
cRetorno := Transform(nNum,cPicture)
IF nNum<0 .or. lInvert
	cRetorno := "("+substr(cRetorno,2)+")"
Endif
Return cRetorno 

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦VerImposto ¦                                ¦ Data ¦ 29/04/05  ¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Verifica os impostos correspondentes a um determinado titulo  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static function VerImposto
   Local vRet   := {}
   Local cForPd := SubStr(GetMv("MV_UNIAO"),1,6)   //Fornecedor dos titulos de impostos
   Local cInss  := SubStr(GetMv("MV_FORINSS"),1,6) //Fornecedor dos titulos de impostos de INSS
   Local cIss   := SubStr(GetMv("MV_MUNIC"),1,6)   //Fornecedor dos titulos de impostos de ISS
   
   Local cBuscaIR,cBuscaPIS,cBuscaCOF,cBuscaCSL,cBuscaINS,cBuscaISS
   
   cBuscaIR  := NEWSE2->E2_PREFIXO + NEWSE2->E2_NUM + NEWSE2->E2_PARCIR+"TX "  + cForPd + Space(Len(NEWSE2->E2_FORNECE)-Len(cForpd))
   cBuscaPIS := NEWSE2->E2_PREFIXO + NEWSE2->E2_NUM + NEWSE2->E2_PARCPIS+"TX " + cForPd + Space(Len(NEWSE2->E2_FORNECE)-Len(cForpd)) 
   cBuscaCOF := NEWSE2->E2_PREFIXO + NEWSE2->E2_NUM + NEWSE2->E2_PARCCOF+"TX " + cForPd + Space(Len(NEWSE2->E2_FORNECE)-Len(cForpd))
   cBuscaCSL := NEWSE2->E2_PREFIXO + NEWSE2->E2_NUM + NEWSE2->E2_PARCSLL+"TX " + cForPd + Space(Len(NEWSE2->E2_FORNECE)-Len(cForpd))
   cBuscaINS := NEWSE2->E2_PREFIXO + NEWSE2->E2_NUM + NEWSE2->E2_PARCINS+"INS" + cInss  + Space(Len(NEWSE2->E2_FORNECE)-Len(cForpd))
   cBuscaISS := NEWSE2->E2_PREFIXO + NEWSE2->E2_NUM + NEWSE2->E2_PARCISS+"ISS" + cIss   + Space(Len(NEWSE2->E2_FORNECE)-Len(cForpd))
   
   //- Contas a pagar
   dbSelectArea("SE2")
   dbSetOrder(1)

   //- Pesquisa o titulo referente ao IR
   If dbSeek(XFILIAL("SE2")+cBuscaIR) 
//                          1              2             3               4              5               6                  7               8               9               10             11             12             13               14            15                   16              17            18                19               20            21        22    23
	  AAdd( vRet, { SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_NATUREZ, SE2->E2_EMISSAO, SE2->E2_VENCREA, SE2->E2_BAIXA, SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_TXMOEDA, SE2->E2_MOEDA, SE2->E2_SALDO, SE2->E2_SDACRES, SE2->E2_SDDECRE, SE2->E2_DTFATUR, SE2->E2_VALOR, SE2->E2_EMISSAO, SE2->E2_VENCREA, SE2->E2_BAIXA, SE2->E2_NOMFOR, "IRR",SE2->E2_CC } )
   Endif	 
   //- Pesquisa o titulo referente ao Pis
   If dbSeek(XFILIAL("SE2")+cBuscaPIS)
	  AAdd( vRet, { SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_NATUREZ, SE2->E2_EMISSAO, SE2->E2_VENCREA, SE2->E2_BAIXA, SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_TXMOEDA, SE2->E2_MOEDA, SE2->E2_SALDO, SE2->E2_SDACRES, SE2->E2_SDDECRE, SE2->E2_DTFATUR, SE2->E2_VALOR, SE2->E2_EMISSAO, SE2->E2_VENCREA, SE2->E2_BAIXA, SE2->E2_NOMFOR, "PIS",SE2->E2_CC } )
   Endif
		
   //- Pesquisa o titulo referente ao Cofins
   If dbSeek(XFILIAL("SE2")+cBuscaCOF)
	  AAdd( vRet, { SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_NATUREZ, SE2->E2_EMISSAO, SE2->E2_VENCREA, SE2->E2_BAIXA, SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_TXMOEDA, SE2->E2_MOEDA, SE2->E2_SALDO, SE2->E2_SDACRES, SE2->E2_SDDECRE, SE2->E2_DTFATUR, SE2->E2_VALOR, SE2->E2_EMISSAO, SE2->E2_VENCREA, SE2->E2_BAIXA, SE2->E2_NOMFOR, "COF",SE2->E2_CC } )
   Endif
		
   //- Pesquisa o titulo referente ao CSLL
   If dbSeek(XFILIAL("SE2")+cBuscaCSL) 
	  AAdd( vRet, { SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_NATUREZ, SE2->E2_EMISSAO, SE2->E2_VENCREA, SE2->E2_BAIXA, SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_TXMOEDA, SE2->E2_MOEDA, SE2->E2_SALDO, SE2->E2_SDACRES, SE2->E2_SDDECRE, SE2->E2_DTFATUR, SE2->E2_VALOR, SE2->E2_EMISSAO, SE2->E2_VENCREA, SE2->E2_BAIXA, SE2->E2_NOMFOR, "CSL",SE2->E2_CC } )
   Endif
	
   //- Pesquisa o titulo referente ao INSS
   If dbSeek(XFILIAL("SE2")+cBuscaINS)
	  AAdd( vRet, { SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_NATUREZ, SE2->E2_EMISSAO, SE2->E2_VENCREA, SE2->E2_BAIXA, SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_TXMOEDA, SE2->E2_MOEDA, SE2->E2_SALDO, SE2->E2_SDACRES, SE2->E2_SDDECRE, SE2->E2_DTFATUR, SE2->E2_VALOR, SE2->E2_EMISSAO, SE2->E2_VENCREA, SE2->E2_BAIXA, SE2->E2_NOMFOR, "INS",SE2->E2_CC } )
   Endif
    
   //- Pesquisa o titulo referente ao ISS
   If dbSeek(XFILIAL("SE2")+cBuscaISS)
	  AAdd( vRet, { SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_NATUREZ, SE2->E2_EMISSAO, SE2->E2_VENCREA, SE2->E2_BAIXA, SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_TXMOEDA, SE2->E2_MOEDA, SE2->E2_SALDO, SE2->E2_SDACRES, SE2->E2_SDDECRE, SE2->E2_DTFATUR, SE2->E2_VALOR, SE2->E2_EMISSAO, SE2->E2_VENCREA, SE2->E2_BAIXA, SE2->E2_NOMFOR, "ISS",SE2->E2_CC } )
   Endif
   
   dbSelectArea("NEWSE2")

Return(vRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ImpTotTit  ¦                                ¦ Data ¦ 29/04/05  ¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Imprime o valor total do titulo incluindo impostos            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ImpTotTit(nSub1,nSub2,nSub3,nSub4,nSub5,nSub6,nSub7,nSub8,nSub9)
li++
@li,000 PSAY OemToAnsi(STR0016)  //"Total Documento:"
@li,024 PSAY nSub1  Picture PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,156 PSAY nSub7  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,172 PSAY nSub8  PicTure PesqPict("NEWSE2","E2_VALOR",15,MV_PAR10)
@li,188 PSAY nSub9  PicTure PesqPict("NEWSE2","E2_VALOR",16,MV_PAR10)
li++
Return(.T.)
