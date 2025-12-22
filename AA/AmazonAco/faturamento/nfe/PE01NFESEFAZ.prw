#Include 'protheus.ch'

//#define 
//Inicio da Posiùùo das Informaùùes  extras passadas pelo NFESEFAZ ao PE01NFESEFAZ
//Criado para Fefinir o Inicio e nùo fixo no Programa, pois a NFESEFAZ pode mudar a definiùùo da Rotina, 
//Entùo serù necessùrio adicionar os vetores extras de Impostos
//Necessùrio para efetuar a aglutinaùùo dos itens antes de enviar para a Sefaz.

User Function PE01NFESEFAZ()
	Local _adParam := PARAMIXB

	//ndInicio := 14 - Compatibilizado Dia 31/07 por Diego
	ndInicio := 21

	Private _ndCst     := ndInicio + 00
	Private _ndICMS    := ndInicio + 01
	Private _ndICMT    := ndInicio + 02
	Private _ndIPI     := ndInicio + 03
	Private _ndPIS     := ndInicio + 04
	Private _ndPISST   := ndInicio + 05
	Private _ndCOFINS  := ndInicio + 06
	Private _ndCOFSST  := ndInicio + 07
	Private _ndISSQN   := ndInicio + 08
	Private _ndEXP     := ndInicio + 09
	Private _ndPISALQZ := ndInicio + 10
	Private _ndCOFALQZ := ndInicio + 11
	Private _ndCSOSN   := ndInicio + 12
	Private _ndICMSZFM := ndInicio + 13
	Private _ndFCI     := ndInicio + 14
	Private _ndISS     := ndInicio + 15


	Private cMVNFEMSF4	:= AllTrim(GetNewPar("MV_NFEMSF4",""))
	Private _adProd		:= aClone(_adParam[1])
	Private _cdMensCli	:= _adParam[2]
	Private _cdMensFis	:= _adParam[3]
	Private _adDest 	:= aClone(_adParam[04] )
	Private _adNota 	:= aClone(_adParam[05] )
	Private _adInfoItem	:= aClone(_adParam[06] )
	Private _adDupl		:= aClone(_adParam[07] )
	Private _adTransp	:= aClone(_adParam[08] )
	Private _adEntrega	:= aClone(_adParam[09] )
	Private _adRetirada	:= aClone(_adParam[10] )
	Private _adVeiculo	:= aClone(_adParam[11] )
	Private _adReboque 	:= aClone(_adParam[12] )
	Private _adNfVincRur := aClone(_adParam[13] )

	Private _adEspVol   := aClone(_adParam[14] )
	Private _adNfVinc   := aClone(_adParam[15] )

	Private _adDetPag   := aClone(_adParam[16] )
	Private _adObsCont  := aClone(_adParam[17] )
	Private _aProcRef   := aClone(_adParam[18] )

	Private _adCST      := {}//aClone(_adParam[_ndCST]      )	
	Private _adICMS	    := {}//aClone(_adParam[_ndICMS]     )
	Private _adICMT     := {}//aClone(_adParam[_ndICMT]   )
	Private _adIPI	    := {}//aClone(_adParam[_ndIPI]      )
	Private _adPIS	    := {}//aClone(_adParam[_ndPIS]      )	
	Private _adPISST    := {}//aClone(_adParam[_ndPISST]    )
	Private _adCOFINS   := {}//aClone(_adParam[_ndCOFINS]   )
	Private _adCOFSST   := {}//aClone(_adParam[_ndCOFSST] )
	Private _adISSQN    := {}//aClone(_adParam[_ndISSQN]    )
	Private _adEXP      := {}
	Private _adPISALQZ  := {}
	Private _adCOFALQZ  := {}
	Private _adCSOSN    := {}
	Private _adICMSZFM  := {}
	Private _adFCI      := {}
	Private _adISS      := {}
	
	If Len(_adParam) < _ndISSQN .Or. .T.// sempre entrar neste Case pois a Aglutinaùùo foi desativada
		//Alert('AGLUTINAùùO NùO SERù EFETUADA')
		_ldAglutina := .F.
	Else
		_ldAglutina := .F.
		_adCST      := aClone(_adParam[_ndCST]       )	
		_adICMS	    := aClone(_adParam[_ndICMS]      )
		_adICMT     := aClone(_adParam[_ndICMT]      )
		_adIPI	    := aClone(_adParam[_ndIPI]       )
		_adPIS	    := aClone(_adParam[_ndPIS]       )	
		_adPISST    := aClone(_adParam[_ndPISST]     )
		_adCOFINS   := aClone(_adParam[_ndCOFINS]    )
		_adCOFSST   := aClone(_adParam[_ndCOFSST]    )
		_adISSQN    := aClone(_adParam[_ndISSQN]     )
		_adISS      := aClone(_adParam[_ndISS]       ) 	     
		

		If Len(_adParam) >= _ndEXP
			_adEXP      := aClone(_adParam[_ndEXP]    )
		EndIf

		If Len(_adParam) >= _ndPISALQZ
			_adPISALQZ  := aClone(_adParam[_ndPISALQZ])
		EndIf

		If Len(_adParam) >= _ndCOFALQZ
			_adCOFALQZ  := aClone(_adParam[_ndCOFALQZ])
		EndIf

		If Len(_adParam) >= _ndCSOSN
			_adCSOSN    := aClone(_adParam[_ndCSOSN]  )
		EndIf

		If Len(_adParam) >= _ndICMSZFM
			_adICMSZFM  := aClone(_adParam[_ndICMSZFM]    )
		EndIf

		If Len(_adParam) >= _ndFCI
			_adFCI      := aClone(_adParam[_ndFCI]       )
		EndIf

	EndIf

	If _ldAglutina
		_xdReturn := _getAglutinado(_adProd,_adInfoItem,_adCST,_adICMS,_adICMT,_adIPI,_adPIS,_adPISST,_adCOFINS,_adCOFSST,_adISSQN,_adNfVincRur,_adEXP,_adPISALQZ,_adCOFALQZ,_adCSOSN,_adICMSZFM,_adFCI,_adISS)
                     
		_adProd      := aClone(_xdReturn[01])
		_adInfoItem  := aClone(_xdReturn[02])
		_adCST       := aClone(_xdReturn[03])
		_adICMS      := aClone(_xdReturn[04])
		_adICMT      := aClone(_xdReturn[05])
		_adIPI       := aClone(_xdReturn[06])
		_adPIS       := aClone(_xdReturn[07])
		_adPISST     := aClone(_xdReturn[08])
		_adCOFINS    := aClone(_xdReturn[09])
		_adCOFSST    := aClone(_xdReturn[10])
		_adISSQN     := aClone(_xdReturn[11])
		//_adNfVincRur := aClone(_xdReturn[13] )
		_adEXP       := aClone(_xdReturn[13])
		_adPISALQZ   := aClone(_xdReturn[14])
		_adCOFALQZ   := aClone(_xdReturn[15])
		_adCSOSN     := aClone(_xdReturn[16])		
		_adICMSZFM   := aClone(_xdReturn[17])
		_adFCI       := aClone(_xdReturn[18])
		_adISS       := aClone(_xdReturn[19])
	EndIf


	/*Diego Inicio*/
	If _adNota[04] == '1'  // Processa Notas de Saida
		_ProcSaida()

		SZE->(dbSetOrder(4))
		_lSZE := SZE->(dbSeek(xFilial('SZE') + SF2->F2_DOC + SF2->F2_SERIE ))

		SA4->(dbSetOrder(1))
		_lSA4 := SA4->(dbSeek(xFilial('SA4') + SF2->F2_TRANSP )) .And. !Empty(SF2->F2_TRANSP)

		SZF->(dbSetOrder(1))
		_lSZF := _lSZE .And. SZF->(dbSeek(xFilial('SZF') + SZE->ZE_MOTOR )) .And. SZF->(FieldPos('ZF_ESTPLA')) > 0

		If SA4->(FieldPos('A4_XRNTC')) > 0 .And. _lSA4
			If !Empty(SA4->A4_XRNTC)
				If Len(_adVeiculo) > 0
					_adVeiculo[03] := SA4->A4_XRNTC
					_xPlaca := _adVeiculo[01]
					If "-"$_xPlaca
						_xPlaca := StrTran(_xPlaca,"-","") 
					EndIf
					_adVeiculo[01] :=  _xPlaca 
				Else
					_xPlaca := IiF(_lSZE,SZE->ZE_PLACA,"")
					If  "-"$_xPlaca
						_xPlaca := StrTran(_xPlaca,"-","") 
					EndIf

					aAdd(_adVeiculo, _xPlaca )
					aAdd(_adVeiculo, iIf(_lSZF,SZF->ZF_ESTPLA," ") )
					aAdd(_adVeiculo, SA4->A4_XRNTC )
				EndIf
			EndIf
		EndIf

	Else  // Notas de Entrada
		_ProcEntrada()
	EndIf

	If ExistBlock("AAFAT03A")
		_cdMensCli := u_AAFAT03A( _cdMensCli )
	Endif

	/*Diego Final*/

	_adParam := {_adProd,_cdMensCli,_cdMensFis,_adDest,_adNota,_adInfoItem,_adDupl,_adTransp,_adEntrega,_adRetirada,_adVeiculo,_adReboque,_adNfVincRur }
	// Em Cima deve esta todos os Padrùes
	// Adiùùo das variavùis Extras // Cada Mudanùa no NFESEFAZ, checar esta situaùùo	
	aAdd(_adParam,_adEspVol)
	aAdd(_adParam,_adNfVinc)
	aAdd(_adParam,_adDetPag)
	aAdd(_adParam,_adObsCont)
	aAdd(_adParam,_aProcRef)
	If _ldAglutina
		aAdd(_adParam, _adCST   )
		aAdd(_adParam, _adICMS  )
		aAdd(_adParam, _adICMT)
		aAdd(_adParam, _adIPI   )
		aAdd(_adParam, _adPIS   )
		aAdd(_adParam, _adPISST )
		aAdd(_adParam, _adCOFINS)
		aAdd(_adParam, _adCOFSST)
		aAdd(_adParam, _adISSQN )
		aAdd(_adParam, _adEXP)
		aAdd(_adParam, _adPISALQZ )		
		aAdd(_adParam, _adCOFALQZ)
		aAdd(_adParam, _adCSOSN )
		aAdd(_adParam, _adICMSZFM)
		aAdd(_adParam, _adFCI    )
		aAdd(_adParam, _adISS    )
		
		//		aAdd(_adParam,
	EndIf
	//

Return _adParam

Static Function _ProcSaida()
 Local nI := 0

	SF2->(dbSetOrder(1))
	SF2->(dbSeek(xFilial('SF2') +  _adNota[02] + _adNota[01]))
	//alert( Len(_adNota) )
	//aAdd(_adNota,SF2->F2_)
	aadd(_adNota, if(Empty(SF2->F2_EMINFE),SF2->F2_EMISSAO, SF2->F2_EMINFE) ) // wermeson para a data de saida
	//alert( Len(_adNota) )

	SF3->(dbSetOrder(4))
	if SF3->(dbSeek(xFilial('SF3')+SF2->(F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE))) .And. SF2->F2_TIPO = 'D'

		If !Alltrim(SF3->F3_OBSERV) $ _cdMensCli .And. !Empty(SF3->F3_OBSERV)
			If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(K), 1) <> " "
				_cdMensCli += " "
			EndIf
			_cdMensCli	+=	Alltrim(SF3->F3_OBSERV)
		EndIf
	EndIf

	SL1->(dbSetOrder(2))
	If SL1->(dbseek(xFilial('SL1')+SF2->(F2_SERIE+F2_DOC+F2_PDV)))
		cdxObs := Alltrim(SL1->L1_OBSERV + ' ' + SL1->L1_OBSERV2)
		While '  ' $ cdxObs
			cdxObs := StrTran(cdxObs,'  ',' ')
		EndDo
		If !Alltrim(cdxObs) $ _cdMensCli .And. !Empty(cdxObs)
			If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
				_cdMensCli += " "
			EndIf
			_cdMensCli	+=	Alltrim(cdxObs)
		EndIf
	EndIf


	//Preenche com os Numeros dos Pedidos de Venda
	cdxVenda := ""
	_cdGrupo := ""
	_cdMensProd := ""
	For nI := 01 To Len(_adInfoItem)
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial('SB1') + _adProd[nI][02] ))

		If !Alltrim(_adInfoItem[nI][01])$cdxVenda .And. !Empty(_adInfoItem[nI][01])
			if Len(Alltrim(cdxVenda)) = 0
				cdxVenda := 'Venda(s) Nro.: ' + Alltrim(_adInfoItem[nI][01])
			else
				cdxVenda += '/' + Alltrim(_adInfoItem[nI][01])
			EndIf
		EndIf

		SC5->(dbSetORder(1))
		SC5->(dbSeek(xFilial('SC5') + _adInfoItem[nI][01] ))

		If Empty(SC5->C5_ORCRES)

			If !Empty(SC5->C5_ENDENT) .And. !AllTrim(SC5->C5_ENDENT) $ _cdMensCli
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli += AllTrim(SC5->C5_ENDENT)
			EndIf

			If !Empty(SC5->C5_BAIRROE) .And. !AllTrim(SC5->C5_BAIRROE) $ _cdMensCli
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli += AllTrim(SC5->C5_BAIRROE)
			EndIf

			If !Empty(SC5->C5_MUNE) .And. !AllTrim(SC5->C5_MUNE) $ _cdMensCli
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli += AllTrim(SC5->C5_MUNE)
			EndIf

			If !Empty(SC5->C5_ESTE) .And. !AllTrim(SC5->C5_ESTE) $ _cdMensCli
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli += AllTrim(SC5->C5_ESTE)
			EndIf

			If !Empty(SC5->C5_OBSENT1) .And. !AllTrim(SC5->C5_OBSENT1) $ _cdMensCli
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli += AllTrim(SC5->C5_OBSENT1)
			EndIf

			If !Empty(SC5->C5_OBSENT2) .And. !AllTrim(SC5->C5_OBSENT2) $ _cdMensCli
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli += AllTrim(SC5->C5_OBSENT2)
			EndIf

		EndIf

		SL1->(dBSetOrder(1))
		SL1->(dbSeek(SC5->C5_FILIAL + SC5->C5_ORCRES ))
		If !Empty(SL1->L1_OBSENT1) .And. !AllTrim(SL1->L1_OBSENT1) $ _cdMensCli
			If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
				_cdMensCli += " "
			EndIf
			_cdMensCli += AllTrim(SL1->L1_OBSENT1)
		EndIf

		If !Empty(SL1->L1_OBSENT2) .And. !AllTrim(SL1->L1_OBSENT2) $ _cdMensCli
			If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
				_cdMensCli += " "
			EndIf
			_cdMensCli += AllTrim(SL1->L1_OBSENT2)
		EndIf
		If !Empty(SL1->L1_OBSENT3) .And. !AllTrim(SL1->L1_OBSENT3) $ _cdMensCli
			If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
				_cdMensCli += " "
			EndIf
			_cdMensCli += AllTrim(SL1->L1_OBSENT3)
		EndIf

		If !Empty(SL1->L1_OBSENT4) .And. !AllTrim(SL1->L1_OBSENT4) $ _cdMensCli
			If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
				_cdMensCli += " "
			EndIf
			_cdMensCli += AllTrim(SL1->L1_OBSENT4)
		EndIf

		SF4->(dbSetORder(1))
		If SF4->(dbSeek(xFilial('SF4') + _adInfoItem[nI][03] ))

			If !Empty(SF4->F4_XFORMUL) .And.;
			((cMVNFEMSF4=="C" .And. !AllTrim(Formula(SF4->F4_XFORMUL))$_cdMensCli) .Or.;
			(cMVNFEMSF4=="F" .And. !AllTrim(Formula(SF4->F4_XFORMUL))$_cdMensFis))
				If cMVNFEMSF4=="C"
					If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
						_cdMensCli += " "
					EndIf
					_cdMensCli	+=	SF4->(Formula(F4_XFORMUL))
				ElseIf cMVNFEMSF4=="F"
					If Len(_cdMensFis) > 0 .And. SubStr(_cdMensFis, Len(_cdMensFis), 1) <> " "
						_cdMensFis += " "
					EndIf
					_cdMensFis	+=	SF4->(Formula(F4_XFORMUL))
				EndIf
			EndIf


			If !Empty(SF4->F4_OBS1) .And. !Alltrim(SF4->F4_OBS1) $ _cdMensCli
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli	+=	SF4->F4_OBS1
			EndIf

			If !Empty(SF4->F4_OBS2) .And. !Alltrim(SF4->F4_OBS2) $ _cdMensCli
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli	+=	SF4->F4_OBS2
			EndIf

			If !Empty(SF4->F4_OBS3) .And. !Alltrim(SF4->F4_OBS3) $ _cdMensCli
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli	+=	SF4->F4_OBS3
			EndIf
		EndIf

		//cDescProd := IIF(Empty(SB1->B1_ESPECIF),SB1->B1_DESC,SB1->B1_ESPECIF)//IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI)				
		_cdGrpAd  := ""
		_nQtdSeg  := 0
		If _cdGrupo != SB1->B1_XGRPINC .And. !Empty(SB1->B1_XGRPINC) .OR. SB1->B1_XGRPINC = '9999'
			_cdGrupo := SB1->B1_XGRPINC
			//_cdGrpAd := SB1->B1_XGRPINC //+ ''

			SZ2->(dbSetORder(1))
			If SZ2->(dbSeek(xFilial('SZ2') + _cdGrupo )) .And. !Empty(_cdGrupo)
				_cdGrpAd := SB1->B1_XGRPINC + "#***" + Alltrim(SZ2->Z2_DESC) + " #***"
			Else
				_cdGrpAd := " #*** #***" 
			EndIf
		EndIf
		//Alteraùùo para tratar Tela e Triliùa que sùo vendidas por Peùas - Williams Messa 10/09/19
		//SC6->(dbSelectArea("SC6"))
		SC6->(dbSetOrder(1))
		SC6->(dbSeek(xFilial('SC6')+_adProd[nI][38]+_adProd[nI][39]))
		
		If EMPTY(SB1->B1_PARCEI)
			_adProd[nI][04] := IIF(Empty(SB1->B1_ESPECIF),SB1->B1_DESC,SB1->B1_ESPECIF)
			_adProd[nI][25] := AllTrim(_cdGrpAd) +iIf( EMpty(SB1->B1_XDCRE),' #***','DCRE - ' + SB1->B1_XDCRE + " #*** ") 
		Else
			_adProd[nI][04] := AllTrim(IIF(Empty(SB1->B1_ESPECIF),SB1->B1_DESC,SB1->B1_ESPECIF))  
			//_adProd[nI][25] := AllTrim(_cdGrpAd) + iIf(EMpty(SB1->B1_XDCRE),' #***','DCRE-' + ALLTRIM(SB1->B1_XDCRE +" PC: " + cValToChar(int(_adProd[nI][12]/SB1->B1_CONV)))) + " #*** " 
			_adProd[nI][25] := AllTrim(_cdGrpAd) + iIf(EMpty(SB1->B1_XDCRE),' #***','DCRE-' + ALLTRIM(SB1->B1_XDCRE +" PC: " + cValToChar(int(SC6->C6_QTDENT2)))) + " #*** "  //+ aProd[nI][25]
		EndIf 
	Next
	
	aMatCupom := NfSefCupom(_adNota[01], _adNota[02])
	cMenVend := ""
	cMenCupom:= ""
	cMenPedido:= ""
	cFormPag  := ""

	If Len(aMatCupom) > 0
		cMenPedido	:= If(!Empty(aMatCupom[01])," Orcamento: "+Alltrim(aMatCupom[01]),"")// Numero do Cupom
		cMenCupom	:= If(!Empty(aMatCupom[03])," Usuario: "+Alltrim(aMatCupom[03]),"")// Usuùrio Caixa
		cMenVend	:= If(!Empty(aMatCupom[04])," Vendedor: "+Alltrim(aMatCupom[04]),"")// Vendedor
		cCompl		:= ""
		SL4->(dbSetOrder(1))
		SL4->(dbSeek(xFilial('SL4')+aMatCupom[01]))
		cFormPag := ''
		While !SL4->(EOF()) .And. Alltrim(SL4->L4_FILIAL + SL4->L4_NUM) = Alltrim(xFilial('SL4')+aMatCupom[01])
			If ! Alltrim(cFormPag)$Alltrim(SL4->L4_FORMA)
				cFormPag += iIf(Empty(cFormPag),'',' / ') + SL4->L4_FORMA
			EndIf
			SL4->(dbSkip())
		EndDo

		// Se for reserva e nùo for cupom fiscal e se nùo for o q gerou reserva e se finalizou com nota
		// Ulysses
		If aMatCupom[05] == "S" .and. Empty(aMatCupom[15]) .and. !Empty(aMatCupom[16])
			If !Empty(aMatCupom[06]+aMatCupom[07]+aMatCupom[08]+aMatCupom[09]+aMatCupom[10]+aMatCupom[11]+aMatCupom[12]+aMatCupom[13])

				cCompl := " MERCADORIA PARA ENTREGA: "
				cCompl += Alltrim(If(!Empty(aMatCupom[06]),Alltrim(aMatCupom[06])+", ","")) //End Entrega
				cCompl += Alltrim(If(!Empty(aMatCupom[07]),Alltrim(aMatCupom[07])+", ","")) //Bairro Entrega
				cCompl += Alltrim(If(!Empty(aMatCupom[08]),Alltrim(aMatCupom[08])+"-",""))  //Municipio Entrega
				cCompl += Alltrim(If(!Empty(aMatCupom[09]),Alltrim(aMatCupom[09])+", ","")) //Estado Entrega
				cCompl += Alltrim(If(!Empty(aMatCupom[10]),Alltrim(aMatCupom[10])+", ","")) //Ponto Referencia
				//cCompl += Alltrim(If(!Empty(aMatCupom[11]),Alltrim(aMatCupom[11])+", ","")) //Obs. Entrega 1
				//cCompl += Alltrim(If(!Empty(aMatCupom[12]),Alltrim(aMatCupom[12])+", ","")) //Obs. Entrega 2
				//cCompl += Alltrim(If(!Empty(aMatCupom[12]),Alltrim(aMatCupom[12])+", ","")) //Observaùùes de vendedores
				cCompl += Alltrim(If(!Empty(aMatCupom[13]),"Tel contato: " + Alltrim(aMatCupom[13]),"")) //Tel. entrega
			EndIf

		EndIf

		cTextoLegal := ""
		If !Empty(SF2->F2_NFCUPOM)
			cTextoLegal := " REF. CUPOM "+Alltrim(SF2->F2_DOC)+" - "+Alltrim(SF2->F2_SERIE)+" EMISSAO: "+dtoc(SF2->F2_EMISSAO)
			cTextoLegal += " Decreto 4.373-N de 02/12/98"
		EndIf

		_cdMensCli += If(!ALltrim(cMenPedido) $ _cdMensCli, cMenPedido , "")
		_cdMensCli += If(!cMenCupom  $ _cdMensCli, cMenCupom  , "")
		_cdMensCli += If(!cMenVend   $ _cdMensCli, cMenVend   , "")
		_cdMensCli += If(!cCompl	 $ _cdMensCli, cCompl     , "")
		_cdMensCli += If(!cTextoLegal$ _cdMensCli, cTextoLegal, "")

		If !Empty(cFormPag)
			cdxMensCli := 'Forma(s) de Pagamento : ' + cFormPag + " "
			If !ALltrim(cdxMensCli)$_cdMensCli .And. !Empty(cdxMensCli)
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli += AllTrim(cdxMensCli)
			EndIf
		Endif
	EndIF

	If !ALltrim(cdxVenda)$_cdMensCli .And. !Empty(cdxVenda)
		If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
			_cdMensCli += " "
		EndIf
		_cdMensCli += AllTrim(cdxVenda) + ' - ' /*+ Alltrim(Posicione('SA3',1,xFilial('SA3')+SF2->F2_VEND1,'A3_NOME')) + ' - '*/ + AllTrim(Posicione('SE4',1,xFilial('SE4')+SF2->F2_COND,'E4_DESCRI'))
	else
		_cdMensCli += AllTrim(cdxVenda) + ' - ' /*+ Alltrim(Posicione('SA3',1,xFilial('SA3')+SF2->F2_VEND1,'A3_NOME')) + ' - '*/ + AllTrim(Posicione('SE4',1,xFilial('SE4')+SF2->F2_COND,'E4_DESCRI'))
	EndIf
	//_cdMensCli += Chr(13) + Chr(10) +  _cdMensProd
	//_cdMensCli += "xbxI Confira Sua Mercadoria"
	//_cdMensCli += "xbx Reclamacoes Somente no Ato do Recebimento"
	//_cdMensCli += "xbx Central de Atendimento"
	//_cdMensCli += "xbx (92) 2129-9898 xbxE"

Return Nil

Static Function _ProcEntrada()
 Local nI := 0 

	SF1->(dbSetOrder(1))
	SF1->(dbSeek(xFilial('SF1') + _adNota[02] + _adNota[01]))

	aadd(_adNota,SF1->F1_EMISSAO)

	SF3->(dbSetOrder(4))
	if SF3->(dbSeek(xFilial('SF3')+SF1->(F1_FORNECE+F1_LOJA+F1_DOC+F1_SERIE))) .And. SF1->F1_TIPO = 'D'

		If !Alltrim(SF3->F3_OBSERV) $ _cdMensCli .And. !Empty(SF3->F3_OBSERV)
			If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
				_cdMensCli += " "
			EndIf
			_cdMensCli	+=	Alltrim(SF3->F3_OBSERV)
		EndIf

	EndIf

	For nI := 01 To Len(_adInfoItem)

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial('SB1') + _adProd[nI][02] ))

		SF4->(dbSetORder(1))
		If SF4->(dbSeek(xFilial('SF4') + _adInfoItem[nI][04] ))
			If !Empty(SF4->F4_XFORMUL) .And.;
			((cMVNFEMSF4=="C" .And. !AllTrim(Formula(SF4->F4_XFORMUL))$_cdMensCli) .Or.;
			(cMVNFEMSF4=="F" .And. !AllTrim(Formula(SF4->F4_XFORMUL))$_cdMensFis))
				If cMVNFEMSF4=="C"
					If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
						_cdMensCli += " "
					EndIf
					_cdMensCli	+=	SF4->(Formula(F4_XFORMUL))
				ElseIf cMVNFEMSF4=="F"
					If Len(_cdMensFis) > 0 .And. SubStr(_cdMensFis, Len(_cdMensFis), 1) <> " "
						_cdMensFis += " "
					EndIf
					_cdMensFis	+=	SF4->(Formula(F4_XFORMUL))
				EndIf
			EndIf

			cdxObs1 := StrTran(SF4->F4_OBS1,"_XDI"  ,SF1->F1_XNUMDI)
			cdxObs1 := StrTran(cdxObs1,"_XDATA",DTOC(SF1->F1_XDTREG) )
			If !Empty(cdxObs1) .And. !Alltrim(cdxObs1) $ _cdMensCli
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli	+=	cdxObs1
			EndIf
			cdxObs1 := StrTran(SF4->F4_OBS2,"_XDI"  ,SF1->F1_XNUMDI)
			cdxObs1 := StrTran(cdxObs1,"_XDATA",DTOC(SF1->F1_XDTREG) )
			If !Empty(cdxObs1) .And. !Alltrim(cdxObs1) $ _cdMensCli
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli	+=	cdxObs1
			EndIf
			cdxObs1 := StrTran(SF4->F4_OBS3,"_XDI"  ,SF1->F1_XNUMDI)
			cdxObs1 := StrTran(cdxObs1,"_XDATA",DTOC(SF1->F1_XDTREG) )
			If !Empty(cdxObs1) .And. !Alltrim(cdxObs1) $ _cdMensCli
				If Len(_cdMensCli) > 0 .And. SubStr(_cdMensCli, Len(_cdMensCli), 1) <> " "
					_cdMensCli += " "
				EndIf
				_cdMensCli	+=	cdxObs1
			EndIf
		EndIf

		_adProd[nI][25] := iIf( EMpty(SB1->B1_XDCRE),'',' DCRE - ' + SB1->B1_XDCRE )
	Next
Return Nil



Static Function NfSefCupom(cSerNota, cNotaPesq)
	Local aMat := {}

	BeginSql Alias "Wrk"
	SELECT isNull(ORIG.L1_NUM,DEST.L1_NUM) L1_NUM, DEST.L1_SERIE, SA3.A3_NOME, SA3.A3_NREDUZ, SA6.A6_NOME, SA6.A6_NREDUZ,
	ISNULL(ORIG.L1_OBSERV , DEST.L1_OBSERV ) AS L1_OBSERV,
	ISNULL(ORIG.L1_ENTREGA, DEST.L1_ENTREGA) AS L1_ENTREGA,
	ISNULL(ORIG.L1_ENDENT , DEST.L1_ENDENT ) AS L1_ENDENT,
	ISNULL(ORIG.L1_BAIRROE, DEST.L1_BAIRROE) AS L1_BAIRROE,
	ISNULL(ORIG.L1_REFEREN, DEST.L1_REFEREN) AS L1_REFEREN,
	ISNULL(ORIG.L1_MUNE   , DEST.L1_MUNE   ) AS L1_MUNE,
	ISNULL(ORIG.L1_ESTE   , DEST.L1_ESTE   ) AS L1_ESTE,
	ISNULL(ORIG.L1_OBSENT1, DEST.L1_OBSENT1) AS L1_OBSENT1,
	ISNULL(ORIG.L1_OBSENT2, DEST.L1_OBSENT2) AS L1_OBSENT2,
	ISNULL(ORIG.L1_OBSENT3, DEST.L1_OBSENT3) AS L1_OBSENT3,
	ISNULL(ORIG.L1_OBSENT4, DEST.L1_OBSENT4) AS L1_OBSENT4,
	ISNULL(ORIG.L1_FONEENT, DEST.L1_FONEENT) AS L1_FONEENT,
	DEST.L1_NUMCFIS, DEST.L1_DOCPED, DEST.L1_DOC
	FROM %Table:SL1% DEST
	LEFT OUTER JOIN %Table:SL1% ORIG
	ON (ORIG.L1_NUM = DEST.L1_ORCRES AND ORIG.L1_FILIAL = DEST.L1_FILRES AND ORIG.%NotDel%)
	LEFT OUTER JOIN %Table:SA3% SA3
	ON (SA3.A3_COD = DEST.L1_VEND AND SA3.%NotDel%)
	LEFT OUTER JOIN %Table:SA6% SA6
	ON (SA6.A6_COD = DEST.L1_OPERADO AND SA6.%NotDel%)
	WHERE DEST.%NotDel%
	AND DEST.L1_DOC =  %Exp:cNotaPesq%
	AND DEST.L1_SERIE =  %Exp:cSerNota%
	EndSql

	If !Wrk->(Eof())
		aMat := {Wrk->L1_NUM, Wrk->L1_SERIE, Wrk->A6_NREDUZ, Wrk->A3_NREDUZ, Wrk->L1_ENTREGA, Wrk->L1_ENDENT,;
		Wrk->L1_BAIRROE, Wrk->L1_MUNE, Wrk->L1_ESTE, Wrk->L1_REFEREN, Wrk->L1_OBSENT1, Wrk->L1_OBSENT2,;
		Wrk->L1_FONEENT, Wrk->L1_NUMCFIS, Wrk->L1_DOCPED, Wrk->L1_DOC, Wrk->L1_OBSERV,Wrk->L1_OBSENT3,Wrk->L1_OBSENT4}
	EndIf

	Wrk->(dbCloseArea())

Return aMat



Static Function _getAglutinado(_adProd,_adInfoItem,_adCST,_adICMS,_adICMT,_adIPI,_adPIS,_adPISST,_adCOFINS,_adCOFSST,_adISSQN,_adNfVincRur,_adEXP,_adPISALQZ,_adCOFALQZ,_adCSOSN,_adICMSZFM,_adFCI,_adISS)

	Local _adNProd     := {}//aClone(_adProd[01])
	Local _adNInfoItem := {}//aClone(_adInfoItem[01])
	Local _adNCST      := {}
	Local _adNICMS     := {}//aClone(_adICMS[01])
	Local _adNICMT     := {}//aClone(_adICMT[01])
	Local _adNIPI      := {}//aClone(_adIPI[01])
	Local _adNPIS      := {}//aClone(_adPIS[01])
	Local _adNPISST    := {}//aClone(_adPISST[01])
	Local _adNCOFINS   := {}//aClone(_adCOFINS[01])
	Local _ADNCOFST    := {}//aClone(_adCOFSST[01])
	Local _adNISSQN    := {}//aClone(_adISSQN[01]) 
	Local _adNNfVincRur:= {}	
	Local _adNEXP      := {}
	Local _adNPISALQZ  := {}
	Local _adNCOFALQZ  := {}
	Local _adNCSOSN    := {}
	Local _adNICMSZFM  := {}
	Local _adNFCI      := {}
	Local _adNISS      := {}
	Local _xdB         := 0
	Local _xdK         := 0 
	Local _xdI         := 0 

	//Local(_adNProd,aClone(_adProd[01]))
	//_adNInfoItem
	For _xdK := 01 To Len(_adProd)

		_xdPos := aScan(_adNProd, {|x| x[02] == _adProd[_xdK][02] .And. x[27] == _adProd[_xdK][27] } )
		If _xdPos > 0
			If !(_adCST[_xdPos][01] == _adCST[_xdK][01] .And. _adCST[_xdPos][02] == _adCST[_xdK][02])
				_xdPos := 0
			EndIf
		EndIf

		If _xdPos == 0
			aAdd(_adNProd     , aClone(_adProd[_xdK]) )
			aAdd(_adNInfoItem , aClone(_adInfoItem[_xdK]) )
			aAdd(_adNCST      , aClone(_adCST[_xdK]) )
			aAdd(_adNICMS     , aClone(_adICMS[_xdK]) )
			aAdd(_adNICMT     , aClone(_adICMT[_xdK]) )
			aAdd(_adNIPI      , aClone(_adIPI[_xdK]) )
			aAdd(_adNPIS      , aClone(_adPIS[_xdK]) )
			aAdd(_adNPISST    , aClone(_adPISST[_xdK]) )
			aAdd(_adNCOFINS   , aClone(_adCOFINS[_xdK]) )
			aAdd(_adNCOFST    , aClone(_adCOFSST[_xdK]) )
			aAdd(_adNISSQN    , aClone(_adISSQN[_xdK]) )

			aAdd(_adNEXP      , aClone(_adEXP[_xdK]) )
			aAdd(_adNPISALQZ  , aClone(_adPISALQZ[_xdK]) )
			aAdd(_adNCOFALQZ  , aClone(_adCOFALQZ[_xdK]) )
			aAdd(_adNCSOSN    , aClone(_adCSOSN[_xdK]) )
			aAdd(_adNICMSZFM  , aClone(_adICMSZFM[_xdK]) )
			
			If Len(_adNfVincRur) >= _xdK
				aAdd(_adNNfVincRur, aClone(_adNfVincRur[_xdK]) )
			Else
				aAdd(_adNNfVincRur, {})
			EndIf
			
			If Len(_adFCI) >= _xdK
				aAdd(_adNFCI  , aClone(_adFCI[_xdK]) )
			Else
				aAdd(_adNFCI, {} )
			EndIf

			If Len(_adISS) >= _xdK
			    aAdd(_adNISS, aClone(_adISS[_xdK]) )
			Else
				aAdd(_adNISS , {} )
			EndIf

		Else
			// Produtos
			// Incrementa Todos os Numericos exceto o Item posicao 01
			For _xdB := 02 To Len(_adNProd[_xdPos])
				If Valtype(_adNProd[_xdPos][_xdB]) == "N" .And. !StrZero(_xdB,2)$"01,16"  //.And. Len(_adICMS[_xdK]) > 0
					_adNProd[_xdPos][_xdB] += _adProd[_xdK][_xdB]
				EndIf
			Next

			For _xdB := 01 To Len(_adNICMS[_xdPos])
				If Valtype(_adNICMS[_xdPos][_xdB]) == "N" .And. StrZero(_xdB,2)$"05,07,09,12" .And. Len(_adICMS[_xdK]) > 0
					_adNICMS[_xdPos][_xdB] += _adICMS[_xdK][_xdB]
				EndIf
			Next

			For _xdB := 01 To Len(_adNICMT[_xdPos])
				If Valtype(_adNICMT[_xdPos][_xdB]) == "N" .And. StrZero(_xdB,2)$"05,07,09" .And. Len(_adICMT[_xdK]) > 0 
					_adNICMT[_xdPos][_xdB] += _adICMT[_xdK][_xdB]
				EndIf
			Next

			For _xdB := 01 To Len(_adNIPI[_xdPos])
				If Valtype(_adNIPI[_xdPos][_xdB]) == "N" .And. StrZero(_xdB,2)$"06,07,10" .And. Len(_adIPI[_xdK]) > 0
					_adNIPI[_xdPos][_xdB] += _adIPI[_xdK][_xdB]
				EndIf
			Next

			For _xdB := 01 To Len(_adNPIS[_xdPos])
				If Valtype(_adNPIS[_xdPos][_xdB]) == "N" .And. StrZero(_xdB,2)$"02,04,05" .And. Len(_adPIS[_xdK]) > 0 
					_adNPIS[_xdPos][_xdB] += _adPIS[_xdK][_xdB]
				EndIf
			Next

			For _xdB := 01 To Len(_adNPISST[_xdPos])
				If Valtype(_adNPISST[_xdPos][_xdB]) == "N" .And. StrZero(_xdB,2)$"02,04,05" .And. Len(_adPISST) > 0
					_adNPISST[_xdPos][_xdB] += _adPISST[_xdK][_xdB]
				EndIf
			Next

			For _xdB := 01 To Len(_adNCOFINS[_xdPos])
				If Valtype(_adNCOFINS[_xdPos][_xdB]) == "N" .And. StrZero(_xdB,2)$"02,04,05" .And. Len(_adCOFINS[_xdK]) > 0
					_adNCOFINS[_xdPos][_xdB] += _adCOFINS[_xdK][_xdB]
				EndIf
			Next

			For _xdB := 01 To Len(_ADNCOFST[_xdPos])
				If Valtype(_ADNCOFST[_xdPos][_xdB]) == "N" .And. StrZero(_xdB,2)$"02,04,05" .And. Len(_adCOFSST[_xdK]) > 0
					_ADNCOFST[_xdPos][_xdB] += _adCOFSST[_xdK][_xdB]			      
				EndIf
			Next

			//If _xdPos >= Len(_adNISSQN)
			For _xdB := 01 To Len(_adNISSQN[_xdPos])
				If Valtype(_adNISSQN[_xdPos][_xdB]) == "N" .And. StrZero(_xdB,2)$"01,03,07,09" .And. Len(_adISSQN[_xdK]) > 0
					_adNISSQN[_xdPos][_xdB] += _adISSQN[_xdK][_xdB]
				EndIf
			Next

			For _xdB := 01 To Len(_adNICMSZFM[_xdPos])
				If Valtype(_adNICMSZFM[_xdPos][_xdB]) == "N" .And. StrZero(_xdB,2)$"01" .And. Len(_adICMSZFM[_xdK]) > 0
					_adNICMSZFM[_xdPos][_xdB] += _adICMSZFM[_xdK][_xdB]
				EndIf
			Next

	/*		For _xdB := 01 To Len(_adISS[_xdPos])
				If Valtype(_adISS[_xdPos][_xdB]) == "N" .And. Len(_adISS[_xdK]) > 0
					_adISS[_xdPos][_xdB] += _adISS[_xdK][_xdB]
				EndIf
			Next
*/
			//EndIf
		EndIf			

	Next

	_xdReturn := {}
	For _xdI := 01 To Len(_adNProd)
		_adNProd[_xdI][1]  := _xdI //Refaz a contagem dos itens, para os Itens no XML. Williams Messa 03/09/2019	   
		_adNProd[_xdI][16] := _adNProd[_xdI][10]/_adNProd[_xdI][12]
	Next
	

	aAdd(_xdReturn,_adNProd)
	aAdd(_xdReturn,_adNInfoItem)
	aAdd(_xdReturn,_adCST)
	aAdd(_xdReturn,_adNICMS)
	aAdd(_xdReturn,_adNICMT)
	aAdd(_xdReturn,_adNIPI)
	aAdd(_xdReturn,_adNPIS)
	aAdd(_xdReturn,_adNPISST)
	aAdd(_xdReturn,_adNCOFINS)
	aAdd(_xdReturn,_ADNCOFST)
	aAdd(_xdReturn,_adNISSQN)
	/*
	aAdd(_adNEXP      , aClone(_adEXP[_xdK]) )
	aAdd(_adNPISALQZ  , aClone(_adPISALQZ[_xdK]) )
	aAdd(_adNCOFALQZ  , aClone(_adCOFALQZ[_xdK]) )
	aAdd(_adNCSOSN    , aClone(_adCSOSN[_xdK]) )
	aAdd(_adNICMSZFM  , aClone(_adICMSZFM[_xdK]) )
	*/
	aAdd(_xdReturn,_adNNfVincRur) 
	aAdd(_xdReturn,_adNEXP) 
	aAdd(_xdReturn,_adNPISALQZ)
	aAdd(_xdReturn,_adNCOFALQZ)
	aAdd(_xdReturn,_adNCSOSN)	
	aAdd(_xdReturn,_adNICMSZFM)
	aAdd(_xdReturn,_adNFCI)  
	aAdd(_xdReturn,_adNISS)  
	

Return _xdReturn
