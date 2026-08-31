#INCLUDE "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GERADCRE   ¦ Autor ¦ Jean Vicente         ¦ Data ¦ 24/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function GERADCRE()
	Private aEstrut := {}
	Private nEStru  := 0
	Private aExport := {}
	Private aDados2 := {}
	Private aDados4 := {}
	Private oGeraTxt
	Private cPerg   := PADR("GERADCRE6",Len(SX1->X1_GRUPO))

	CriaSx1(cPerg)
	Pergunte(cPerg,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela de processamento.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	@ 200,1 TO 380,390 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Arquivo Texto")
	@ 02,10 TO 080,190
	@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
	@ 18,018 Say " tros definidos  pelo usuario,  para no sistema do DCR-E       "
	@ 26,018 Say "                                                               "

	@ 60,098 BMPBUTTON TYPE 01 ACTION U_MONTATXT()
	@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
	@ 60,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

	Activate Dialog oGeraTxt Centered

Return

User Function MONTATXT()
	Local I, X, J
	Local cDados    := ""
	Local nContNac  := 0
	Local nContImp  := 0
	local nDI :=0
	local nDOLAR := 0

	Local aOriNac := {0,2,3,4,5,8} //chave da tabela de origem do produto, apenas nacionais. 
	Local cEncOrinac := "" //para verificar se a origem do produto eh nacional

	IF EMPTY(MV_PAR01) .OR. EMPTY(MV_PAR02) .OR. EMPTY(MV_PAR03) .OR. EMPTY(MV_PAR09) .OR. EMPTY(MV_PAR10)
		APMSGSTOP("Existem parametros em branco!")
		Return
	Endif

	SB1->(dbSetOrder(1))
	SB1->(DBSEEK(XFILIAL("SB1")+MV_PAR01))

	//	-> Estrutura DCRE - Válido a partir do dia 28/01/2012
	// Registro Tipo 0 - Informações Gerais de um DCR-E                 //| INI | FIM | TAMANHO |  CAMPO
	cDados := "0"                                                           //| 001 | 001 |    01   |  ID_REGISTRO
	cDados += PADR(SM0->M0_CGC,14)                                        //| 002 | 015 |    14   |  CNPJ_ESTABELECIMENTO
	cDados += PADR(MV_PAR10,11)                             						//| 016 | 026 |    11   |  CPF_REPRESENTANTE_LEGAL
	cDados += PADR(MV_PAR04,80)                                           	//| 027 | 106 |    80   |  PPB (Identificação do Processo Produtivo Básico do Produto e Resolução SUFRAMA.)
	cDados += PADR(SB1->B1_DESC,80)                                         //| 107 | 186 |    80   |  DENOMINACAO_PRODUTO
	cDados += PADR(SB1->B1_POSIPI,08)                                       //| 187 | 194 |    08   |  NCM
	cDados += PADR(SB1->B1_UM,80)    	        										//| 195 | 274 |    80   |  UNIDADE
	cDados += StrZero((SB1->B1_PESBRU*100000),14)	        						//| 275 | 288 |    14   |  PESO_BRUTO
	cDados += StrZero((MV_PAR05*100),15)                             			//| 289 | 303 |    15   |  SALARIOS_ORDENADOS
	cDados += StrZero((MV_PAR06*100),15)  	                						//| 304 | 318 |    15   |  ENCARGOS_SOCIAIS_TRABALHISTAS
	cDados += PADR(IIF(MV_PAR07=1,"N",IIF(MV_PAR05=2,"R","S")),01)			   //| 319 | 319 |    01   |  TIPO_DCR-E
	cDados += PADL(IIF(MV_PAR07=1,"          ",SB1->B1_DCR),10,"0")			//| 320 | 329 |    10   |  NR_DCR-E_ANTERIOR
	cDados += PADR("                 ",17)	                    					//| 330 | 346 |    17   |  NR_PROCESSO
	cDados += PADR("    ",04)					                    					//| 347 | 350 |    04   |  NR_VERSAO_PGD
	cDados += PADR("2",01)						                    					//| 351 | 351 |    01   |  IN_ORIGEM_DCR-E
	cDados += Iif(mv_par08 = 1, "F", "V")                					//| 352 | 352 |    01   |  TIPO_COEFICIENTE_DCR

	// Registro Tipo 1 - Informações Gerais de um DCR-E                     //| INI | FIM | TAMANHO |  CAMPO
	cDados1 := "1"                                                          //| 001 | 001 |    01   |  ID_REGISTRO
	cDados1 += PADR("0001",04)                                              //| 002 | 005 |    04   |  NUM_MODELO
	cDados1 += PADR(SB1->B1_DESC,80)	                     						//| 006 | 085 |    80   |  DESCRICAO
	cDados1 += Strzero((MV_PAR09*100),15)                                  	//| 086 | 100 |    15   |  PREÇO_VENDA
	cDados1 += PADR(SB1->B1_COD,15)                                         //| 101 | 115 |    15   |  COD_INTERNO

	aAdd(aExport,cDados)
	aAdd(aExport,cDados1)

	SG1->(dbSetOrder(1))
	SG1->(dbSeek(xFilial("SG1")+MV_PAR01))

	aEstrut := Estrut(MV_PAR01,1,.F.,.F.)

	cTIPO := "N"
	DbSelectArea("SD1")
	cIndex  := CriaTrab(nil,.F.)
	cKey    := "D1_FILIAL+D1_COD+DTOS(D1_EMISSAO)"
	cFilter := DbFilter()
	cFilter := 'D1_FILIAL=="'+xFilial('SD1')+'".And. SD1->D1_TIPO == "'+CTIPO+'"'

	IndRegua("SD1",cIndex,cKey,,cFilter,"Selecionando Registros...")
	DbGoTop()

	ProcRegua(LEN(aEstrut))
	FOR I := 1 TO LEN(aEstrut)

		SD1->(DbSetorder (26)) // FILIAL+CODIGO+EMISSAO
		SD1->(DbSeek(xFilial()+aEstrut[i,3],.T.))

		WHILE !SD1->(EOF()) .AND. (SD1->D1_COD == aEstrut[i,3]) //.AND. SD1->D1_TIPO == "N"
			SD1->(DbSkip())
		END

		SD1->(DBSKIP(-1))


		IF (SD1->D1_COD == aEstrut[i,3])

			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA ))

			SB1->(DbSetOrder(1))
			SB1->(DbSeek(Xfilial()+aEstrut[i,3]))

			SG1->(DBSETORDER(1))
			SG1->(DbSeek(xFilial("SG1")+aEstrut[i,2]+aEstrut[i,3]))

			//For nX:=1 to Len(aOriNac)
			//	If SB1->B1_ORIGEM == aOriNac[nX]
			//		lEncOrinac := .T.	
			//	EndIf
			//Next nX*//			
			cEncOrinac := (AScan(aOriNac, SB1->B1_ORIGEM))

			If (SB1->B1_ORIGEM == "0" .or. SB1->B1_ORIGEM == "2" .or. SB1->B1_ORIGEM == "3" .or. SB1->B1_ORIGEM == "4" .or. SB1->B1_ORIGEM == "5" .or. SB1->B1_ORIGEM == "8") //alterado em 30/06/2014 - Bruno Garcia
				IF aEstrut[i,4] <> 0
					nContNac += 1
					// Registro Tipo 2 - Informações Sobre Componentes Nacionais              				//| INI | FIM | TAMANHO |  CAMPO
					cnDados2	:= "2"                                                        			  	//| 001 | 001 |    01   |  ID_REGISTRO
					cnDados2 += StrZERO(nContNac,04)                                       					//| 002 | 005 |    04   |  NUM_COMPONENTE_NACIONAL
					cnDados2 += PADL(ALLTRIM(SD1->D1_DOC),10,"0")             								//| 006 | 015 |    10   |  NUM_NOTA_FISCAL
					cnDados2 += PADL(IIF(EMPTY(SD1->D1_SERIE),"00000",SD1->D1_SERIE),05," ")		  		//| 016 | 020 |    05   |  NUM_SERIE_NF
					cnDados2 += PADL(SA2->A2_CGC,14,"0")                                      				//| 021 | 034 |    14   |  CNPJ_FORNECEDOR
					cnDados2 += PADR(IIF(EMPTY(SA2->A2_INSCR ),"               ",SA2->A2_INSCR ),15," ")    //| 035 | 049 |    15   |  INSCRIÇÃO_ESTADUAL
					cnDados2 += PADR(DTOS(SD1->D1_EMISSAO),8)               								//| 050 | 057 |    08   |  DATA_EMISSAO_NF
					cnDados2 += PADR(SB1->B1_DESC,80)                                 			   			//| 058 | 137 |    80   |  ESPECIFICACAO
					cnDados2 += PADR(SB1->B1_UM,80)                                                 		//| 138 | 217 |    80   |  UNIDADE_COMERCIAL
					cnDados2 += PADL(SB1->B1_POSIPI,08,"0")                                       			//| 218 | 225 |    08   |  NCM
					cnDados2 += StrZERO((aEstrut[i,4]*10000000),15)                                			//| 226 | 240 |    15   |  QUANTIDADE
					cnDados2 += StrZERO(((SD1->D1_VUNIT/MV_PAR12)*1000000),15)                   			//| 241 | 255 |    15   |  CUSTO_UNITARIO
					aAdd(aDados2,{cnDados2})
				ENDIF
			ELSE
				IF aEstrut[i,4] <> 0		
					nDI   :=  POSICIONE( 'SF1',1,xFilial('SD1')+SD1->D1_DOC+SD1->D1_SERIE,'F1_XNUMDI')
					nDOLAR:=  POSICIONE( 'SF1',1,xFilial('SD1')+SD1->D1_DOC+SD1->D1_SERIE,'F1_XTXCAMBI')
					nContImp += 1
					// Registro Tipo 4 - Informações Sobre Componentes Importados             				//| INI | FIM | TAMANHO |  CAMPO
					ciDados4 := "4"                                                          				//| 001 | 001 |    01   |  ID_REGISTRO
					ciDados4 += StrZERO(nContImp,04)														//| 002 | 005 |    04   |  NUM_COMPONENTE_IMPORTADO
					ciDados4 += "S"      							               							//| 006 | 006 |    01   |  IN_IMP_DIRETA
					ciDados4 += "S"																			//| 007 | 007 |    01   |  IN_COM_SUSPENSA
					ciDados4 += alltrim(Substr(nDI,1,2)+Substr(nDI,4,7)+substr(nDI,12))     				//| 008 | 017 |    10   |  No DI
					ciDados4 += "001"                                                             			//| 018 | 020 |    03   |  NUM_ADICAO
					ciDados4 += substring(alltrim(SD1->D1_ITEM),3,4)                                       	//| 021 | 022 |    02   |  NUM_ITEM
					ciDados4 += "0000000000"                                            					//| 023 | 032 |    10   |  NUM_NOTA_FISCAL
					ciDados4 += "     "																		//| 033 | 037 |    05   |  NUM_SERIE_NF
					ciDados4 += "              "															//| 038 | 051 |    14   |  CNPJ_FORNECEDOR
					ciDados4 += "               "															//| 052 | 066 |    15   |  INSCRIÇÃO_ESTADUAL
					ciDados4 += "00000000"                                                       			//| 067 | 074 |    08   |  DATA_EMISSAO_NF
					ciDados4 += PADR(SB1->B1_DESC,80)														//| 075 | 154 |    80   |  ESPECIFICACAO
					ciDados4 += SPACE(80)  																	//| 155 | 234 |    80   |  UNIDADE_COMERCIAL
					ciDados4 += "00000000"																	//| 235 | 242 |    08   |  NCM
					ciDados4 += StrZERO((aEstrut[i,4]*10000000),15)                       					//| 243 | 257 |    15   |  QUANTIDADE
					//ciDados4 += StrZERO((SG1->G1_QUANT*10000000),15)                         	//| 243 | 257 |    15   |  QUANTIDADE
					ciDados4 += "S"                                                               			//| 258 | 258 |    01   |  IN_REDUÇÃO_II
					ciDados4 += StrZERO(((SD1->D1_VUNIT/nDOLAR)*1000000),15)								//| 259 | 273 |    15   |  CUSTO_UNITÁRIO

					aAdd(aDados4,{ciDados4})
				ENDIF
			ENDIF

		ENDIF

	NEXT

	FOR X := 1 TO LEN (aDados2)
		aAdd(aExport,aDados2[X][1])
	NEXT

	FOR J := 1 TO LEN (aDados4)
		aAdd(aExport,aDados4[J][1])
	NEXT

	// Registro Tipo 9 - Totalizador do Arquivo         				//| INI | FIM | TAMANHO |  CAMPO
	cDados9 := "9"                                      				//| 001 | 001 |    01   |  ID_REGISTRO
	cDados9 += StrZERO(LEN(aExport)+01,08)                  			//| 002 | 009 |    08   |  QTD_REGISTROS

	aAdd(aExport,cDados9)

	MsgRun("Exportando Dados, Aguarde...",,{|| U_EXPORTA()})
	APMSGINFO("O Arquivo foi gerado com sucesso!")
	Close(oGeraTxt)

	IF MV_PAR11 == 1
		U_IMPREL()
	ENDIF

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CRIASX1    ¦ Autor ¦ Jean Vicente         ¦ Data ¦ 24/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaSx1()
	u_InPutSX1(cPerg, "01", "Produto Acabado ?		:", "", "", "mv_ch1", "C", TamSx3("B1_COD")[1], 00, 0, "G", "", "SB1", "", "", "mv_par01")
	u_InPutSX1(cPerg, "02", "Diretorio ?      		:", "", "", "mv_ch2", "C", 40, 00, 0, "G", "", ""      , "", "", "mv_par02")
	u_InPutSX1(cPerg, "03", "Nome Arquivo ?   		:", "", "", "mv_ch3", "C", 20, 00, 0, "G", "", ""      , "", "", "mv_par03")
	u_InPutSX1(cPerg, "04", "Identif. da Suframa ?:", "", "", "mv_ch4", "C", 80, 00, 0, "G", "", ""   	 , "", "", "mv_par04")
	u_InPutSX1(cPerg, "05", "Salario Ordenado ?	:", "", "", "mv_ch5", "N", 15, 02, 0, "G", "", ""   	 , "", "", "mv_par05")
	u_InPutSX1(cPerg, "06", "Enc. Social Trab. ?  :", "", "", "mv_ch6", "N", 15, 02, 0, "G", "", ""   	 , "", "", "mv_par06")
	u_InPutSX1(cPerg, "07", "Tipo DCR ?       		:", "", "", "mv_ch7", "N", 01, 00, 0, "C", "", ""   	 , "", "", "mv_par07","NOVO","","","","RETIFICADOR","","","","SUBSTITUIDO")
	u_InPutSX1(cPerg, "08", "TP Coefic. Reducao ? :", "", "", "mv_ch8", "N", 01, 00, 0, "C", "", ""   	 , "", "", "mv_par08","FIXO","","","","VARIAVEL")
	u_InPutSX1(cPerg, "09", "Valor do Produto ?   :", "", "", "mv_ch9", "N", 20, 04, 0, "G", "", ""   	 , "", "", "mv_par09")
	u_InPutSX1(cPerg, "10", "CPF Representante ?  :", "", "", "mv_chA", "C", 15, 00, 0, "G", "", ""   	 , "", "", "mv_par10")
	u_InPutSX1(cPerg, "11", "Imp. Relat. DCR-E ?  :", "", "", "mv_chB", "N", 01, 00, 0, "C", "", ""   	 , "", "", "mv_par11","SIM","","","","NÃO")
	u_InPutSX1(cPerg, "12", "Taxa do Dolar ?      :", "", "", "mv_chC", "N", 15, 04, 0, "G", "", ""   	 , "", "", "mv_par12")
Return Nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ EXPORTA    ¦ Autor ¦ Jean Vicente         ¦ Data ¦ 24/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function EXPORTA()•
	Local i, j
	Local cLinha     := ""
	Local cArqTxt    := AllTrim(Mv_Par02)+AllTrim(Mv_Par03)+".txt"
	Local nHdl       := fCreate(cArqTxt)

	If !File(cArqTXT)
		MsgStop("O Arquivo " + cArqTXT + " não pode ser Criado!")
		Return nil
	EndIf

	For i:=1 to Len(aExport)
		cLinha := ""

		If ValType(aExport[i])<>"A"
			cLinha += aExport[i]
		Else
			For j := 1 to Len(aExport[i])
				cLinha += aExport[i][j]+Chr(9)
			Next
		Endif

		cLinha += chr(13)+chr(10)

		If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
		EndIf
	Next

	fClose(nHdl)

Return Nil


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ IMPREL     ¦ Autor ¦ Jean Vicente         ¦ Data ¦ 03/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
USER FUNCTION IMPREL()
	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com dados informados no DCR-E."
	Local cDesc3        := "Demonstrativo DCR-E"
	Local titulo        := "Demonstrativo DCR-E"
	Local nLin          := 180
	Local Cabec1        := ""
	Local Cabec2        := ""
	Local aOrd 		     := {}
	Private limite      := 180
	Private tamanho     := "G"
	Private nomeprog    := "DCRER01"
	Private nTipo       := 10
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private wnrel       := "DCRER01"
	Private cPerg2      := PADR("IMP000",Len(SX1->X1_GRUPO))
	Private cString     := "SG1"

	wnrel := SetPrint(cString,NomeProg,cPerg2,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)
	Titulo := AllTrim(Titulo)
	//         000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111                                                                    200
	//         000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233        4         5         6         7         8         9         0         1         2
	//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//        "    DATA    | SÉRIE  | FORNECEDOR |                    NOME                    |       PRODUTO      |                            DESCRIÇÃO                         |  QUANTIDADE |       VALOR     |" 		 		 Cabec1 := " "
	Cabec2 := " "

	RptStatus({|| U_MONTAREL(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MONTAREL   ¦ Autor ¦Jean Vicente          ¦ Data ¦ 09/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦                                                           	   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MONTAREL(Cabec1,Cabec2,Titulo,nLin)
	Local _nLin      := 60
	Local I

	dbGoTop()
	SetRegua(RecCount())

	For I := 1 to len(aDados2)

		If _nLin > 57
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			_nLin := 6
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(Xfilial()+ALLTRIM(mv_par01)))

			@ _nLin, 01 PSAY "COMPONENTES NACIONAIS DO PRODUTO " + ALLTRIM(mv_par01) + " - " + SB1->B1_DESC
			_nLin += 2
			@ _nLin,  01 PSAY "    NOTA FISCAL    |  SERIE  |                               ESPECIFICAÇÃO                          |  QUANTIDADE  |  CUSTO UNIT  |"
			_nLin +=2

		Endif

		cEspecificacao := subsTR(aDados2[I,1],58,80)
		nQtd:= val(subsTR(aDados2[I,1],226,15))/10000000
		nCusUnit := val(subsTR(aDados2[I,1],241,15))/1000000

		@ _nLin,005 PSAY SUBSTR(aDados2[I,1],6,10) // NOTA FISCAL
		@ _nLin,022 PSAY subsTR(aDados2[I,1],16,05) //SÉRIE
		@ _nLin,033 PSAY ALLTRIM(cEspecificacao) //ESPECIFICACAO
		@ _nLin,98 PSAY Transform(nQtd, "@E 9,999,999.999999")// QUANTIDADE
		@ _nLin,116 PSAY Transform(nCusUnit,"@E 999,999,999.999")// CUSTO UNITÁRIO   56.556086/1.67    *1000000
		_nLin++

	NEXT

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()
Return
