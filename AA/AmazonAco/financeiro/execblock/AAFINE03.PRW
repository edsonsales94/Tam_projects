#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"

/*__________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+----------------------+-------------+---------------+¦
¦¦¦Programa   ¦AAFINE03 | Autor ¦ ADRIANO LIMA | Data | 28/05/12    ¦
¦¦+-----------+----------------------+-------------+---------------+¦
¦¦¦Descrição: |Compensação de Titulos em Boleto no caso de Devolucao¦
¦¦+-----------+-----------------------+-------------+---------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User function AAFINE03()
Local aArea  := GetArea()

If SF1->F1_TIPO == "D"
	
	//Posiciona no Item da Nota Fiscal de Devolução
	dbSelectArea("SD1")
	SD1->(dbSetOrder(1))
	If SD1->(dbSeek(SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE  + SF1->F1_FORNECE + SF1->F1_LOJA ))
		
		fCompTit(SF1->F1_SERIE, SF1->F1_DOC, SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_VALBRUT, SD1->D1_NFORI, SD1->D1_SERIORI)
		
	EndIf
	
EndIf

RestArea(aArea)

Return


//Realiza a compensacao do Titulo
Static Function fCompTit(cPrf,cNum,cCli,cLoj,nValor, cDocOri, cSerOri)

Local lRetOK := .T.
Local aArea  := GetArea()
Local aRecSE1 := {}       
Local cNotaDev  := ""
Local cWNomeCli := ""
Local cwValor   := 0
Local cNotaOri := ""
Private nRecnoNDF
Private nRecnoE1

//Posiciona no Titulo de Credito (NCC)
dbSelectArea("SE1")
SE1->(dbSetOrder(2))
If SE1->(dbSeek(XFILIAL("SE1")+cCli+cLoj+PADR(cPrf,3)+PADR(cNum,9)))
	
	//Atribui recno do Titulo de Credito (NCC)
	nRecnoRA := SE1->(RECNO())
	
	cNotaDev := SE1->E1_NUM+"/"+SE1->E1_SERIE
	cWNomeCli := SE1->E1_NOMCLI 
	cwValor   := SE1->E1_VALOR
	
	//Posiciona na Nota Fiscal de Origem da nota Fiscal de Devolução
	SF2->(DbSetOrder(1))
	If SF2->(DbSeek(xFilial("SF2")+cDocOri+cSerOri+cCli+cLoj))
		
		//Posiciona no Item da Nota Fiscal de Origem da nota Fiscal de Devolução
		dbSelectArea("SD2")
		SD2->(dbSetOrder(3))
		If SD2->(dbSeek(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE  + SF2->F2_CLIENTE + SF2->F2_LOJA ))
			
			//Posiciona no Titulo a ser compensado.
			dbSelectArea("SE1")
			SE1->(dbSetOrder(2))
			If SE1->(dbSeek(XFILIAL("SE1")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_SERIE+SD2->D2_DOC))
				
				cNotaOri := SE1->E1_NUM+" / "+SE1->E1_SERIE
				
				//Compensa caso o titulo for boleto e não foi baixado.
				If ALLTRIM(SE1->E1_TIPO) $ "BOL#BO" .AND. Empty(SE1->E1_BAIXA)
					
					If Empty(SE1->E1_NUMBCO)
						
						aRecRA  := { nRecnoRA }
						
						//Adiciona as parcela do Boleto da Nota Fiscal a ser compensada.
						While  SE1->E1_CLIENTE == SD2->D2_CLIENTE .AND. SE1->E1_LOJA == SD2->D2_LOJA;
							.AND. SE1->E1_PREFIXO == SD2->D2_SERIE .AND. SE1->E1_NUM  == SD2->D2_DOC;
							.AND. ALLTRIM(SE1->E1_TIPO) $ "BOL#BO" .AND. Empty(SE1->E1_BAIXA)
							
							//Atribui recno do Titulo a ser compensado.
							nRecnoE1 := SE1->(RECNO())
							
							PERGUNTE("AFI340",.F.)
							lContabiliza  := MV_PAR11 == 1
							lAglutina     := MV_PAR08 == 1
							lDigita       := MV_PAR09 == 1
							
							SE1->(dbSetOrder(1))
							
							aAdd( aRecSE1, {nRecnoE1})
							
							SE1->(dbSkip())
						EndDo
						
						SE1->(dbCloseArea())
						SF1->(dbCloseArea())
						SD1->(dbCloseArea())
						SF2->(dbCloseArea())
						SD2->(dbCloseArea())
						
						/* Código da operação a ser efetuada (numérico),[1] Baixa simples do financeiro,[2] Liquidação de títulos,
						[3] Compensação de títulos de mesma carteira (RA/NCC)Exp2: Array com os recnos dos títulos a serem baixados,
						Exp3: Array com os dados da baixa simples do financeiro[1] Motivo da Baixa,[2] Valor Recebido,[3] Banco,
						[4] Agência,[5] Conta,[6] Data de Crédito,[7] Data da Baixa. */
						
						For x:=1 To Len(aRecSE1)
							If !MaIntBxCR(3,aRecSE1[x],,aRecRA,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,,dDatabase )
								Help("XAFCMPAD",1,"HELP","XAFCMPAD","Não foi possível a compensação"+CRLF+" do titulo do Credito",1,0)
								lRet := .F.
							EndIf
						Next
						
					Else                            
					                                                       
						Alert("Este Titulo foi enviado ao Banco. Será enviado um email ao setor Financeiro!")
						U_AAFINW01(cNotaDev, cNotaOri, cwNomeCli, cwValor )
						
					EndIf
				EndIf
				
			EndIf
		EndIf
	EndIf
	
EndIf

RestArea(aArea)

Return lRetOK