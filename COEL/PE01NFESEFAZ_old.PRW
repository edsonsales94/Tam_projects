#Include 'Protheus.ch'
User Function PE01NFESEFAZ()
	Local aProd     := PARAMIXB[1]
	Local cMensCli  := PARAMIXB[2]
	Local cMensFis  := PARAMIXB[3]
	Local aDest     := PARAMIXB[4]
	Local aNota     := PARAMIXB[5]
	Local aInfoItem := PARAMIXB[6]
	Local aDupl     := PARAMIXB[7]
	Local aTransp   := PARAMIXB[8]
	Local aEntrega  := PARAMIXB[9]
	Local aRetirada := PARAMIXB[10]
	Local aVeiculo  := PARAMIXB[11]
	Local aReboque  := PARAMIXB[12]
	Local aNfVincRur:= PARAMIXB[13]
	Local aEspVol   := PARAMIXB[14]
	Local aNfVinc   := PARAMIXB[15]
	Local AdetPag   := PARAMIXB[16]
	Local aObsCont	:= PARAMIXB[17]
	Local aProcRef	:= PARAMIXB[18]
	Local aMed   	:= PARAMIXB[19]
	Local aLote   	:= PARAMIXB[20]
	Local aPedCom   := PARAMIXB[21]
	Local nValDifer := PARAMIXB[22]
	Local aRetorno 		:= {}
	Local cMensCpl 		:= ''
	Local _cPedido 		:= ''
	Local XREGTRIB 		:= ''
	Local xMENTRIB 		:= ''
	Local CMENSCLFIS 	:=''
	Local _cPedidc 		:=''
	Local x_PdCli 		:=''
	Local cMensVEND 	:=''
	Local _cVEND 		:=''
	Local _Ccvend 		:=''
	Local cMensreg 		:=''
	Local c_PediCli 	:=''
	Local lPedProd 		:=''
	Local lPedComp 		:=''
	Local _DESCAUX 		:=''
	Local cMenscodcli 	:=''
	Local cMensECLI 	:=''
	Local cMenslocent 	:=''
	Local cMensRed 		:=''
	Local cMensPed 		:=''
	Local cMensPEDc 	:=''
	Local cMensNFO 		:=''
	Local Nx 			:= 0
	Local I 			:= 0
	Local nAA 			:= 0

	Local xOBS_FISC    := {}  //*COEL:
	Local cTextoAdd    := ""  //*COEL:
	Local xLINHASAD    := ""  //*COEL:
	Local  xEST_CLI    := ""  //*COEL:
	Local xBASES_DIF   := {}  //*COEL:           // Aliquotas ICMS diferentes
	Local xVALOR_DIF   := {}  //*COEL:           // Base do ICMS por aliquota
	Local xSUFRAMA     := ""  //*COEL:
	Local xREC_EST     := ""  //*COEL:
	Local cmens        := ""  //*COEL:
	Local cTextobase   := ""  //*COEL:

	Local cMVCODBRP1   := SuperGetMV("MV_CODBRP1", ," ")  //*COEL:
	Private _lImport   := .F. //*COEL:

	dbSelectArea("SA1")
	dbsetorder(1)
	dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
	_cNreduz := SA1->A1_NREDUZ
	xEST_CLI := SA1->A1_EST
	xSUFRAMA := SA1->A1_SUFRAMA
	xREC_EST := SA1->A1_ESTE
	xREGTRIB := SA1->A1_REGTRIB

	// *** Obsevacoes Fiscais coel tabela z1 f4 e z3 ***

	DbSelectArea("SF4")
	DbSeek( xFilial("SF4") + SD2->D2_TES )

	DbSelectArea("SZ1")
	DbSeek( xFilial("SZ1") + SB1->B1_POSIPI )

	If aNota[4] == '1' // NOTA DE SAIDA

		If !Empty( SZ1->Z1_CLOBIPI )
			if SF4->F4_CREDIPI=="S"
				If Ascan( xOBS_FISC, SZ1->Z1_CLOBIPI ) == 0
					AADD( xOBS_FISC, SZ1->Z1_CLOBIPI )
				EndIf
			endif
		EndIf

		If !Empty( SZ1->Z1_CLOBICM )
			if SF4->F4_CREDICM=="S"
				If Ascan( xOBS_FISC, SZ1->Z1_CLOBICM ) == 0
					AADD( xOBS_FISC, SZ1->Z1_CLOBICM )
				EndIf
			EndIf
		Endif

		// Cod. Observ. Fiscais do Tes
		If !Empty( SF4->F4_CLMSG1 )
			If Ascan( xOBS_FISC, SF4->F4_CLMSG1 ) == 0
				AADD( xOBS_FISC, SF4->F4_CLMSG1 )
			EndIf
		EndIf
		If !Empty( SF4->F4_CLMSG2 )
			If Ascan( xOBS_FISC, SF4->F4_CLMSG2 ) == 0
				AADD( xOBS_FISC, SF4->F4_CLMSG2 )
			EndIf
		EndIf
		// Fim Cod. Observ. Fiscais do Tes

		If Len( xOBS_FISC ) > 0

			DbSelectArea("SZ3")
			DbSetOrder(1)
			For I := 1 To Len( xOBS_FISC )
				cTextoAdd := ""
				DbSeek( xFilial("SZ3") + xOBS_FISC[I] )
				If SZ3->Z3_CLAPL == "D" .AND. xEST_CLI == "SP"
					cTexToAdd := SZ3->Z3_CLDESC
				ElseIf SZ3->Z3_CLAPL == "F" .AND. xEST_CLI #"SP"
					cTexToAdd := SZ3->Z3_CLDESC
				ElseIf SZ3->Z3_CLAPL == "A"
					cTexToAdd := SZ3->Z3_CLDESC
				EndIf

				If !Empty( cTextoAdd ) .and. !(Alltrim(cTextoAdd) $ aParam[3])
					if ! empty(xLINHASAD)
						if (!AllTrim(cTextoAdd) $ xLINHASAD)
							xLINHASAD +=  " -" + AllTrim(cTextoAdd)
						endif
					else
						xLINHASAD := " " + AllTrim(cTextoAdd)
					endif
				EndIf

			Next
		EndIf

		//aliquota diferenciada de icms
		If SF4->F4_ISS # "S"
			// ** Se nÆo h  ISS no TES, calcula bases para al¡qs. do ICMS diferenciadas
			nElem := Ascan( xBASES_DIF, SD2->D2_PICM )
			If nElem == 0
				AADD( xBASES_DIF, SD2->D2_PICM  )
				AADD( xVALOR_DIF, SD2->D2_TOTAL )
			Else
				xVALOR_DIF[nElem] := xVALOR_DIF[nElem] + SD2->D2_TOTAL
			EndIf
		EndIf

		cTextobase := ""
		If Len( xBASES_DIF ) > 1
			cMsg := " -Bases para as aliquotas do ICMS:"
			xLINHASAD += iif(cMsg $ aParam,'',cMsg)
			nNovaLi := 0
			For nAA := 1 To Len( xBASES_DIF )
				If nNovaLi > 1
					xLINHASAD += cTextobase
					nNovaLi := 0
					cTextobase := ""
				EndIf
				cTextobase := cTextobase+Str(xBASES_DIF[nAA],2)+"% -> "
				cTextobase := cTextobase+"R$"+Str(xVALOR_DIF[nAA],14,2)
				nNovaLi := nNovaLi + 1
				If nAA < Len( xBASES_DIF )
					cTextobase := cTextobase + "           "
				EndIf
			Next
		EndIf
		If !Empty( cTextobase ) .and. !(Alltrim(cTextobase) $ aParam[3])
			xLINHASAD += cTextobase
		EndIf
		//fim aliquota diferenciada de icms

		// *** Suframa e mensagem por estado

		If !SD2->D2_TES $ "704/708"
			If !Empty(xSuframa)
				cMsg := " -SUFRAMA : "+xSuframa
				if !(cMsg $ aParam[3])
					xLINHASAD +=  " -SUFRAMA : "+xSuframa
				endif

				cMens:= ""
				Do Case
				Case xREC_EST == "AM"
					cMens:= "ISENTO DO IPI - ART. 85 DO RIPI/98"
				Case xREC_EST == "RO"
					cMens:= "ISENTO DO IPI - ART. 88 DO RIPI/98"
				Case xREC_EST == "RR"
					cMens:= "ISENTO DO IPI - ART. 91 DO RIPI/98"
				Case xREC_EST == "AP"
					cMens:= "ISENTO DO IPI - ART. 94 DO RIPI/98"
				Case xREC_EST == "AC"
					cMens:= "ISENTO DO IPI - Art. 97 DO RIPI/98"
				EndCase


				if ! empty(xLINHASAD)
					if (!AllTrim(cMens) $ aParam[3])
						xLINHASAD +=  " -" + AllTrim(cMens)
					endif
				else
					if (!AllTrim(cMens) $ aParam[3])
						xLINHASAD := " " + AllTrim(cMens)
					endif
				endif
			EndIf
		Endif

		// *** FIM Suframa e mensagem por estado

		// *** Fim Obser. Fiscais ***

		dbSelectArea("SA1")
		dbsetorder(1)
		dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		IF ( SF2->F2_TIPO == "B" )      ///Carlos Nina - 21/10/11
			dbSelectArea("SA2")
			dbsetorder(1)
			dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		ENDIF
		//if !empty(SA1->A1_COD)
		if ! empty(cMenscodcli)  //mensagem codigo cliente
			///if (!AllTrim(SA1->A1_COD) $ cMenscodcli)
			if (!AllTrim(SF2->F2_CLIENTE) $ cMenscodcli)       ///Carlos Nina - 21/10/11
				///cMenscodcli +=  "/"  + AllTrim(SA1->A1_COD)+"-"+AllTrim(SA1->A1_LOJA)
				cMenscodcli +=  "/"  + AllTrim(SF2->F2_CLIENTE)+"-"+AllTrim(SF2->F2_LOJA)       ///Carlos Nina - 21/10/11
			endif
		else
			//cMenscodcli := "Codigo do Cliente: " + AllTrim(SA1->A1_COD)+"-"+AllTrim(SA1->A1_LOJA)
			IF ( SF2->F2_TIPO == "B" )    ///Carlos Nina - 21/10/11
				cMenscodcli := "Codigo do Fornecedor: " + AllTrim(SF2->F2_CLIENTE)+"-"+AllTrim(SF2->F2_LOJA)    ///Carlos Nina - 21/10/11
			ELSE
				cMenscodcli := "Codigo do Cliente: " + AllTrim(SF2->F2_CLIENTE)+"-"+AllTrim(SF2->F2_LOJA)    ///Carlos Nina - 21/10/11
			ENDIF
		endif

		/// especifico coel-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		///COEL: As 8 linhas abaixo foi substituido cfe. e-mail de 16/05/12 p/Veronica
		///      IIF(SubStr(aProd[nx,2],1,2) == "00",Subst( SC6->C6_DESCRI, 1, 30 ),Subst( SB5->B5_CEME, 1, 57 )) + " " +_DESCAUX ,;					                           //Coel: 21/10/11 - em subst. linha acima
		///

		For NX:=1 TO LEN(aProd)
			//POSICIONA B5
			dbSelectArea("SB5")
			DBSETORDER(1) //filial + CODIGO
			SB5->(dbSeek(xFilial("SB5")+aProd[nx,2]))

			dbSelectArea("SB1")
			dbSetOrder(1)
			SB1->(MsSeek(xFilial("SB1")+aProd[nx,2]))

			dbSelectArea("SC6")
			SC6->(dbSetOrder(2))
			SC6->(MsSeek(xFilial("SD2")+aProd[nx,2]+aProd[nx,38]+aProd[nx,39]))

			dbSelectArea("SC5")
			DBSETORDER(1) //filial + numero
			dbSeek(xFilial("SC5")+SC6->C6_NUM)
			_cVend := SC5->C5_VEND1
			_cPedidc := alltrim(SC5->C5_CLPEDCL)

			aprod[nx,3] := IIf(Val(aprod[nx,3])==0,"",ALLTRIM(cMVCODBRP1) + substr(alltrim(aprod[nx,3]),1,5) + ALLTRIM(EANDIGITO(cMVCODBRP1 +  substr(alltrim(aprod[nx,3]),1,5) )))    //(1):Coel: Alterado por Andre por motivo de duplicacao de codigo de barra pois o parametro mv_codbrp1 estava com um digito a mais errado e o substr foi aumentado para pegar 5 posicoes IIf(Val(SB1->B1_CODBAR)==0,"",StrZero(Val(SB1->B1_CODBAR),Len(Alltrim(SB1->B1_CODBAR)),0)),;

			//-----------------------------------------------------------------//

			//Coel Pedido e item do cliente
			if EMPTY(aPedCom[1])
				aPedCom := {}
			endif

			If SC6->(FieldPos("C6_PEDCLI")) > 0 .AND. !Empty(SC6->C6_PEDCLI)
				aadd(aPedCom,{SC6->C6_PEDCLI,SC6->C6_CITPCLI})
			Else
				aadd(aPedCom,{'',''})
			EndIf

			//-----------------------------------------------------------------//

			_cPedido := aProd[nx,38]
			if ! empty(cMensPED)  //PEDIDO COEL
				if (!AllTrim(_cPedido) $ cMensPED)
					cMensPED +=  "/" + AllTrim(_cPedido)
				endif
			else
				cMensPED := "Nosso Pedido: " + AllTrim(_cPedido)
			endif

			if ! empty(_cPedidc)  //PEDIDO CLIENTE
				if ! empty(cMensPEDc)  //PEDIDO CLIENTE
					if (!AllTrim(_cpedidc) $ cMensPEDc)
						cMensPEDc +=  "/" + AllTrim(_cPedidc)
					endif
				else
					cMensPEDc := "Seu Pedido: " + AllTrim(_cPedidc)
				endif
			endif

			if ! empty(SC6->C6_PEDCLI)
				x_PdCli := STRTRAN(SC6->C6_PEDCLI,"#","")
				if ! empty(cMensPEDc)  //PEDIDO CLIENTE
					if (!AllTrim(x_PdCli) $ cMensPEDc)
						cMensPEDc +=  "/" + AllTrim(x_PdCli)
					endif
				else
					cMensPEDc := "Seu Pedido: " + AllTrim(x_PdCli)
				endif
			endif

			DbSelectArea("SA3")                    // * Cadastro de Vendedores
			DbSetOrder(1)
			DbSeek( xFilial("SA3") + _CVEND)
			_Ccvend := SA3->A3_NREDUZ

			If SM0->M0_CODIGO <> "03" .OR. SM0->M0_CODIGO+SM0->M0_CODFIL=="0302"     ///.and. SM0->M0_CODFIL == "01"   (Carlos: 05/10/12)
				if ! empty(cMensVEND)  //VENDEDOR
					if (!AllTrim(_cVEND) $ cMensVEND)
						if ! empty(_Ccvend)
							cMensVEND +=  "/" + AllTrim(_cVEND) + '-' + _Ccvend
						else
							cMensVEND +=  "/" + AllTrim(_cVEND)
						endif
					endif
				else
					if ! empty(_Ccvend)
						cMensVEND := "Vendedor: " + AllTrim(_cVEND) + '-' + _Ccvend
					else
						cMensVEND := "Vendedor: " + AllTrim(_cVEND)
					endif
				endif

				if ! empty(SA1->A1_REGIAO)
					if ! empty(cMensreg)  //região
						if (!AllTrim(SA1->A1_REGIAO) $ cMensreg)
							cMensreg +=  "/" + AllTrim(SA1->A1_REGIAO)
						endif
					else
						cMensreg := "Região: " + AllTrim(SA1->A1_REGIAO)
					endif
				endif
			EndIf

			if ! empty(SD2->D2_NFORI)
				if ! empty(cMensNFO)  //NF ORIGINAL
					if (!AllTrim(SD2->D2_NFORI) $ cMensNFO)
						cMensNFO +=  "/" + AllTrim(SD2->D2_NFORI)
					endif
				else
					cMensNFO := "NF Original: " + AllTrim(SD2->D2_NFORI)
				endif
			endif

			//POSICIONA B5
			dbSelectArea("SB5")
			DBSETORDER(1) //filial + CODIGO
			dbSeek(xFilial("SB5")+SB1->B1_COD)

			c_PediCli := IIF(LEFT(SC6->C6_PEDCLI,1)=="#",SPACE(11),SC6->C6_PEDCLI)    ///Carlos - 17/05/12
			lPedProd  := ( !EMPTY(SC6->C6_X_PROD).AND.!EMPTY(c_PediCli) )             ///Carlos - 17/05/12
			lPedComp  := ( !EMPTY(SC6->C6_PEDCLI).AND.!EMPTY(SC6->C6_CITPCLI) ) .or. ( !EMPTY(SC6->C6_PEDCLI).AND.!EMPTY(SC6->C6_DELJIT) )

			_DESCAUX  := ""
			If ALLTRIM(SM0->M0_CODIGO) == "03" .and. ALLTRIM(SM0->M0_CODFIL) == "01"
				_DESCAUX := IIF(EMPTY(SB1->B1_X_DCR),"","-DCR " + RTRIM(SB1->B1_X_DCR))
			Else
				If !empty(SC6->C6_X_PROD).AND.EMPTY(c_PediCli)
					_DESCAUX := "-"+SC6->C6_X_PROD+IIF(EMPTY(SC6->C6_PEDCLI),"","/"+SC6->C6_PEDCLI)
				Endif
			EndIf

			IF ( SM0->M0_CODIGO == "03" .AND. SubStr(aProd[nx,2],1,2) <> "00" )        ///Carlos: 31/08/12
				aProd[NX,4] := IIF(!EMPTY(SB1->B1_X_CODB),alltrim(SB1->B1_X_DCR)+" "+ALLTRIM(SC6->C6_DESCRI),alltrim(SB1->B1_X_DCR)+" "+Subst( SB5->B5_CEME, 1, 57 )) + " " +_DESCAUX             ///Rogerio: 29/08/12
			ELSE
				aProd[NX,4]  := IIF(SubStr(aProd[nx,2],1,2) == "00",ALLTRIM(SC6->C6_DESCRI)+ " -DCR " + alltrim(SB1->B1_X_DCR),Subst( SB5->B5_CEME, 1, 57 )) + " " +_DESCAUX + " -DCR " + alltrim(SB1->B1_X_DCR)
			ENDIF

			cEan := IIF(!Empty(aProd[NX,46]),iif( "0000000000000" $ aProd[NX,46],"",aProd[NX,46]), ALLTRIM(aProd[NX,03]))   //Coel
			//Se a segunda unidade de medida estiver "B5_2CODBAR" estiver preenchido leva ele  para nfe.
			//senão verifica se a unidade comercial e diferente da tributaria para considerar o mesmo valor da cEan se for igual.
			cEantrib	:= IIF(!Empty(aProd[NX,45]),aProd[NX,45], iif( aProd[NX,08] <> aProd[NX,11],"",cEan))

			APROD[NX,3 ] := cEan
			APROD[NX,46] := cEantrib
		NEXT nX

		If nValDifer > 0
			if cMVEstado == 'PE' .And. aDest[9] == 'EX'
				cMensCpl += "Diferimento do ICMS - Base legal: Lei nº 15.730/2016, art. 12, § 1º, I.Valor do ICMS Diferido R$: " + ConvType(nValDifer,15,2) + "."
			else
				cMensCpl += "Diferimento do ICMS que exceder 12% - Base Legal Livro III, Art 1º-K do RICMS/RS alterado conforme Decreto 55797 de 17/03/2021. Valor do ICMS Diferido R$ " + ConvType(nValDifer,15,2) + "."
			endif
		EndIf

		//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /* Refatoração: custumizações que estavam direto no fonte do NFESEFAZ para o PE01NFESEFAZ.*/
		dbSelectArea("SA1")
		dbsetorder(1)
		dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		IF ( SF2->F2_TIPO == "B" )      ///Carlos Nina - 21/10/11
			dbSelectArea("SA2")
			dbsetorder(1)
			dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		ENDIF

		if !empty(cMenscodcli)  //mensagem codigo cliente
			if (!AllTrim(SF2->F2_CLIENTE) $ cMenscodcli)       ///Carlos Nina - 21/10/11
				///cMenscodcli +=  "/"  + AllTrim(SA1->A1_COD)+"-"+AllTrim(SA1->A1_LOJA)
				cMenscodcli +=  "/"  + AllTrim(SF2->F2_CLIENTE)+"-"+AllTrim(SF2->F2_LOJA)       ///Carlos Nina - 21/10/11
			endif
		else
			IF ( SF2->F2_TIPO == "B" )    ///Carlos Nina - 21/10/11
				cMenscodcli := "Codigo do Fornecedor: " + AllTrim(SF2->F2_CLIENTE)+"-"+AllTrim(SF2->F2_LOJA)    ///Carlos Nina - 21/10/11
			ELSE
				cMenscodcli := "Codigo do Cliente: " + AllTrim(SF2->F2_CLIENTE)+"-"+AllTrim(SF2->F2_LOJA)    ///Carlos Nina - 21/10/11
			ENDIF
		endif

		//	MENSAGEM ESPECIFICA CLIENTE COEL
		If  !EMPTY(SA1->A1_MENCLI) // mensagem específica para este cliente
			if ! empty(cMensECLI)
				if (! ALLTRIM(SA1->A1_MENCLI) $ cMensECLI)
					cMensECLI +=  "/" + ALLTRIM(SA1->A1_MENCLI)
				endif
			else
				cMensECLI := ALLTRIM(SA1->A1_MENCLI)
			endif
		endif
		// Adicionado por Andre Rodrigues a pedido do Brandao em 260117
		IF SF2->F2_TIPO $ "N" .and. SF2->F2_TIPOCLI <> "X".and. SM0->M0_CODIGO == "03" .and. SM0->M0_CODFIL == "01" .and. lImpMpec
			cMensECLI +="Mercadoria não sujeita ao ICMS-ST por não fazer parte do segmento de Autopeças"
			lImpMpec    := .F.
		Endif

		if Empty(cMenslocent)                           //endereço de entrega      -->Carlos Nina - 21/10/11
			//				IF ( SF2->F2_TIPO <> "B" )      ///Carlos Nina - 21/10/11
			IF !SF2->F2_TIPO $ "DB"   //Rogerio 23/09/14 - Estava indo o endereco errado no caso de devolucao
				cMenslocent := "Local de entrega: " + AllTrim(SA1->A1_ENDENT) +  " " + AllTrim(SA1->A1_MUNE) + " " + AllTrim(SA1->A1_ESTE)// ;
				ELSE
				cMenslocent := "Local de entrega: " + AllTrim(SA2->A2_END) +  " " + AllTrim(SA2->A2_MUN) + "/" + AllTrim(SA2->A2_EST)// ;
				ENDIF
		endif

		//-----------mensagens do redespacho  coel-----------------------------//
		If ALLTRIM(SM0->M0_CODIGO) == "03" .and. ALLTRIM(SM0->M0_CODFIL) == "01"
			If !Empty(SF2->F2_TRANSP)   //se empresa 03 não vazio de SC5->C5_X_TRANSP e não vazio SF2->F2_TRANSP
				dbSelectArea("SA4")
				dbSetOrder(1)
				MsSeek(xFilial("SA4")+SF2->F2_TRANSP)   //POSICIONA TRANSPORTADORA ORIGINAL REDESPACHO

				If SC5->C5_X_FRETE == "C"
					if Empty(cMensRed)
						cMensRed += " -Redespacho , " + ALLTRIM(SA4->A4_NOME)+" "
						cMensRed += ALLTRIM(SA4->A4_END) + " - " + ALLTRIM(SA4->A4_MUN)+" - "+(SA4->A4_EST)+" BAIRRO "+ALLTRIM(SA4->A4_CLBAIRR)
						cMensRed += " Cep :"+SA4->A4_CEP//+" - Tel :"+(SA4->A4_TEL)
						cMensRed += "Via de transporte: " + alltrim(SA4->A4_VIA)
						cMensRed += ", frete de redespacho sera pago pela Coel *"
					endif
				else
					If empty(cMensRed)
						cMensRed += " -Redespacho , " + ALLTRIM(SA4->A4_NOME)+" "
						cMensRed += ALLTRIM(SA4->A4_END)+" - "+ALLTRIM(SA4->A4_MUN)+" - "+(SA4->A4_EST)+" BAIRRO "+ALLTRIM(SA4->A4_CLBAIRR)
						cMensRed += " Cep :"+SA4->A4_CEP//+" - Tel :"+(SA4->A4_TEL)
						cMensRed += "Via de transporte: " + alltrim(SA4->A4_VIA)
						cMensRed += ", frete de redespacho sera cobrado do destinatario -"
					endif
				endif
			EndIf
		EndIf

		//COEL: Unificação de mensagens coel
		if !empty(cMensECLI) //se mensagens especificas cliente não vazio
			if !empty(cMenscli)
				cMenscli += " -" + cMensECLI
			else
				cMenscli := cMensECLI
			endif
		endif


		if !empty(cMensclfis) //se acumulador de classificação fiscal não vazio
			if !empty(cMensFis)
				cMensFis += " -" + cMensclfis
			else
				cMensFis := cMensclfis
			endif
		endif

		if !empty(cMenscodcli) //CODIGO CLIENTE
			if !empty(cMenscli)
				cMenscli += " -" + cMenscodcli
			else
				cMenscli := cMenscodcli
			endif
		endif

		if !empty(cMensRed) //CODIGO CLIENTE
			if !empty(cMenscli)
				cMenscli += " -" + cMensRed
			else
				cMenscli := cMensRed
			endif
		endif

		if !empty(cMenslocent) //local de entrega
			if !empty(cMenscli)
				cMenscli += " -" + cMenslocent
			else
				cMenscli := cMenslocent
			endif
		endif

		if !empty(cMensPed) //PEDIDO  COEL
			if !empty(cMenscli)
				cMenscli += " -" + cMensPed
			else
				cMenscli := cMensPed
			endif
		endif

		if !empty(cMensPEDc) //PEDIDO CLIENTE
			if !empty(cMenscli)
				cMenscli += " -" + cMensPEDc
			else
				cMenscli := cMensPEDc
			endif
		endif

		if !empty(cMensvend) //VENDEDOR
			if !empty(cMenscli)
				cMenscli += " -" + cMensvend
			else
				cMenscli := cMensvend
			endif
		endif

		if !empty(cMensreg) //REGIAO
			if !empty(cMenscli)
				cMenscli += " -" + cMensreg
			else
				cMenscli := cMensreg
			endif
		endif

		if !empty(cMensNFO) //NF ORIGINAL
			if !empty(cMensFis)
				cMensFis += " -" + cMensNFO
			else
				cMensFis := cMensNFO
			endif
		endif

		If !Empty(SC5->C5_MENPAD) .And. !AllTrim(FORMULA(SC5->C5_MENPAD)) $ cMensCli //mensagem pedido formula
			cMensCli += AllTrim(FORMULA(SC5->C5_MENPAD))
		EndIf

		If !AllTrim(SC5->C5_MENNOTA) $ cMensCli  //mensagem para nota
			cMensCli += AllTrim(SC5->C5_MENNOTA)
		EndIf

		If ALLTRIM(SM0->M0_CODIGO) == "03" .and. ALLTRIM(SM0->M0_CODFIL) == "01"
			cMensFis += "Empresa Habilitada para o Procedimento Simplificado"
			cMensFis += " de Internacao nos termos do ART.13 da INSRF"
			cMensFis += " 242/02- ADE/ALFPTOMNS N: 24 DE 28/06/2004 DOU DE 29/06/04"
			cMensFis += " Isento de IPI"
			cMensFis += " Produzido na ZFM"
			cMensFis += " DEC. 7.212/10 ART. 81 INC. II"//" DEC. 4.544/02 ART. 69 INC. II"

			If xREGTRIB =="1"
				xMENTRIB = "OS"
			ElseIf xREGTRIB =="2"
				xMENTRIB ="LP"
			ElseIf xREGTRIB =="3"
				xMENTRIB ="LRC"
			ElseIf xREGTRIB =="4"
				xMENTRIB ="LRNC"
			ElseIf xREGTRIB =="5"
				xMENTRIB ="ZFM"
			Else
				xMENTRIB =""
			Endif

			If !Empty(xREGTRIB)
				cMensFis += " Reg.Trib.:"+xMENTRIB
			EndIf

		EndIf

		if !empty(xLINHASAD) //mensagem fiscal f4 z1 e z3
			if !empty(cMensFis)
				cMensFis += " -" + xLINHASAD
			else
				cMensFis := xLINHASAD
			endif
		endif
	endif

	aadd(aRetorno,aProd)
	aadd(aRetorno,cMensCli)
	aadd(aRetorno,cMensFis)
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,AdetPag)
	aadd(aRetorno,aObsCont)
	aadd(aRetorno,aProcRef)
	aadd(aRetorno,aMed)
	aadd(aRetorno,aLote)
	aadd(aRetorno,aPedCom)
	aadd(aRetorno,nValDifer)

RETURN aRetorno


//47727 DE  29/12/2023
