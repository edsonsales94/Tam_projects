#Include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ELOBJP01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 29/11/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Integração da Viagem com o sistema AUTOTRAC                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function ELOBJP01(nOperacao)
	
	Default nOperacao := 1
	/*
	nOperacao = 1 INCLUIR VIAGEM
	nOperacao = 2 ALTERAR VIAGEM
	nOperacao = 3 ENCERRAR VIAGEM
	nOperacao = 4 EXCLUIR VIAGEM

	*/

If IsBlind()
	RunProc(nOperacao)
ElseIf FWAlertYesNo("Confirma a integração com o AutoTrac ?")
	FWMsgRun(Nil, {|oSay| RunProc(nOperacao) }, "Aguarde...",  "Integrando viagem com o Autotrac" )
Endif
Return

Static Function RunProc(nOperacao)
	Local oJSon, cErro
	Local cURL     := u_URLEDLOPES()
	Local cPostPar := ""
	Local aHeadOut := {}
	Local cCertCRT := ""   //"\certificado\Infostore_certificado.crt"   // <--- CERTIFICADO CRT (caso haja)
	Local cCertKEY := ""   //"\certificado\INFOSTORE.key"   // <--- CERTIFICADO KEY (caso haja)
	Local nTimeOut := 120
	Local cHeadRet := ""
	Local cSenha1  := ""
	Local cPostRet := ""
	Local lJSon    := .F.

	Local cCodIntVg  := ''
	// Local cCodIntVg  := GetSXENum('DTQ', 'DTQ_XINTVG')
	Local cCodContaViVg  := GetMV("MV_XCODCTA",.F.,"10190")   // ID da Ed Lopes
	Local cClient_ID := GetMV("MV_XIDEDLO",.F.,"1659973881423")   // ID da Ed Lopes
	Local cCidOri  := ""
	Local jBody
	Local cCidDes  := ""
	Local cPrvDSai := "0000-00-00"
	Local cPrvHSai := "00:00:00"
	Local cPrvDChg := "0000-00-00"
	Local cPrvHChg := "00:00:00"
	Local cDataSai := "0000-00-00"
	Local cHoraSai := "00:00:00"
	Local cDataChg := "0000-00-00"
	Local cHoraChg := "00:00:00"

	Local aOperacao := { "viagensIncluir", "viagensAlterar", "viagensAlterarStatus", "viagensExcluir"}

	// SIGINIFICA QUE JÁ HOUVE INTEGRAÇÃO E S´O VAI ATUALIZAR AS OPERAÇÕES
	if nOperacao < 3  .AND. !Empty(DTQ->DTQ_XCODVG)
		nOperacao := 2
	endif

	If nOperacao < 1 .Or. nOperacao > 4
		Conout("Operacao nao valida")

	Else
		If lJSon
			AAdd( aHeadOut, 'Content-Type: application/json;' )
			AAdd( aHeadOut, '-d' )
		Else
			AAdd( aHeadOut, 'Content-Type: multipart/form-data;' )
		Endif
		If nOperacao < 3   // Inclusão ou Alteração
			// Posiciona no Movimento de Viagem
			DUD->(dbSetOrder(2))    // DUD_FILIAL+DUD_FILORI+DUD_VIAGEM+DUD_SEQUEN+DUD_FILDOC+DUD_DOC+DUD_SERIE
			DUD->(dbSeek(XFILIAL("DUD")+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM))
			// Posiciona nos Documentos de Transporte
			DT6->(dbSetOrder(1))    // DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
			DT6->(dbSeek(XFILIAL("DT6")+DUD->DUD_FILDOC+DUD->DUD_DOC+DUD->DUD_SERIE))
			// Posiciona no Cadastro do Cliente
			SA1->(dbSetOrder(1))    // A1_FILIAL+A1_COD+A1_LOJA
			SA1->(dbSeek(XFILIAL("SA1")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV))

			// Posiciona no Cadastro de Rotas
			DA8->(dbSetOrder(1))    // DA8_FILIAL+DA8_COD
			DA8->(dbSeek(XFILIAL("DA8")+DTQ->DTQ_ROTA))
			// Posiciona no Cadastro da Cidade Origem
			DUY->(dbSetOrder(1))    // DUY_FILIAL+DUY_GRPVEN
			If DUY->(dbSeek(XFILIAL("DUY")+DA8->DA8_CDRORI))
				cCidOri := DUY->DUY_DESCRI
			Endif
			// Posiciona no Cadastro da Cidade Destino
			DUY->(dbSetOrder(1))    // DUY_FILIAL+DUY_GRPVEN
			If DUY->(dbSeek(XFILIAL("DUY")+DA8->DA8_CDRCAL))
				cCidDes := DUY->DUY_DESCRI
			Endif

			// Posiciona no Veículos da Viagem
			DTR->(dbSetOrder(1))    // DTR_FILIAL+DTR_FILORI+DTR_VIAGEM+DTR_ITEM
			DTR->(dbSeek(XFILIAL("DTR")+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM))
			// Posiciona no Cadastro de Veículos
			DA3->(dbSetOrder(1))    // DA3_FILIAL+DA3_COD
			DA3->(dbSeek(XFILIAL("DA3")+DTR->DTR_CODVEI))

			// Posiciona no Motoristas da Viagem
			DUP->(dbSetOrder(1))    // DUP_FILIAL+DUP_FILORI+DUP_VIAGEM+DUP_ITEDTR+DUP_CODMOT
			DUP->(dbSeek(XFILIAL("DUP")+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM))
			// Posiciona no Cadastro de Motoristas
			DA4->(dbSetOrder(1))    // DA4_FILIAL+DA4_COD
			DA4->(dbSeek(XFILIAL("DA4")+DUP->DUP_CODMOT))

			// Posiciona na Operação de Transporte - 049 -> Saída da viagem
			DTW->(dbSetOrder(1))    // DTW_FILIAL+DTW_FILORI+DTW_VIAGEM+DTW_SEQUEN
			if DTW->(dbSeek(XFILIAL("DTW")+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM,.T.))
				While !DTW->(Eof()) .And. DTW->DTW_FILIAL+DTW->DTW_FILORI+DTW->DTW_VIAGEM == XFILIAL("DTW")+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM
					If DTW->DTW_ATIVID == "049"        // 049 -> Saída da viagem
						cPrvDSai := IIF(EMPTY(DTW->DTW_DATPRE),cPrvDSai,FormataData(DTW->DTW_DATPRE))
						cPrvHSai := IIF(EMPTY(DTW->DTW_HORPRE),cPrvHSai,SUBSTR(DTW->DTW_HORPRE,1,2)+":"+SUBSTR(DTW->DTW_HORPRE,3,2)+":00" )
						cDataSai := IIF(EMPTY(DTW->DTW_DATINI),cDataSai,FormataData(DTW->DTW_DATINI))
						cHoraSai := IIF(EMPTY(DTW->DTW_HORINI),cHoraSai,SUBSTR(DTW->DTW_HORINI,1,2)+":"+SUBSTR(DTW->DTW_HORINI,3,2)+":00" )
					ElseIf DTW->DTW_ATIVID == "050"    // 050 -> Encerramento da viagem
						cPrvDChg := IIF(EMPTY(DTW->DTW_DATPRE),cPrvDChg,FormataData(DTW->DTW_DATPRE))
						cPrvHChg := IIF(EMPTY(DTW->DTW_HORPRE),cPrvHChg,SUBSTR(DTW->DTW_HORPRE,1,2)+":"+SUBSTR(DTW->DTW_HORPRE,3,2)+":00" )
						cDataChg := IIF(EMPTY(DTW->DTW_DATREA),cDataChg,FormataData(DTW->DTW_DATREA))
						cHoraChg := IIF(EMPTY(DTW->DTW_HORREA),cHoraChg,SUBSTR(DTW->DTW_HORREA,1,2)+":"+SUBSTR(DTW->DTW_HORREA,3,2)+":00" )
					Endif
					DTW->(dbSkip())
				Enddo
			Endif
		Endif

		aCampos := {}
		If nOperacao == 1  // Incluir
			If !Empty(DTQ->DTQ_XINTVG)
				AAdd( aCampos , { "codIntVg", DTQ->DTQ_XINTVG})
			Else
				// ASSUME O PROXIMO
				cCodIntVg := GetSXENum('DTQ', 'DTQ_XINTVG')
				RecLock("DTQ",.F.)
				DTQ->DTQ_XINTVG := cCodIntVg
				DTQ->DTQ_XCODVG := ''
				MsUnLock()
				ConfirmSX8()
				AAdd( aCampos , { "codIntVg", DTQ->DTQ_XINTVG})
			Endif
		Else
			
			AAdd( aCampos , { "codVg", Alltrim(DTQ->DTQ_XCODVG)})
			If nOperacao == 3
				IF DTQ->DTQ_STATUS $ '3|5' // Encerramento da viagem
					AAdd( aCampos , { "stsVg", "finalizada"})
				elseiF DTQ->DTQ_STATUS == '1' // estorna o Encerramento da viagem
					AAdd( aCampos , { "stsVg", "agendada"})
				Endif

			Endif
		Endif

		If nOperacao < 3
			// VALIDA ROTA
			cRota := DA8->DA8_XROTA
			if !Empty(cRota)
				If fValida('ROTA',cRota)
					AAdd( aCampos , { "codRtVg", AllTrim(cRota)})
				Else
					// se não encontrar rota, usuario decide se prossegui ou não.
					if !FWAlertYesNo('A Rota '+cRota+' não foi enconrada no sistema norteTrack, Integrar viagem sem a Rota ?' ,'Atencao !!!')
						Return
					Endif
				Endif
			else
				// se não encontrar rota, usuario decide se prossegui ou não.
				if !FWAlertYesNo('A Rota não foi informada na viagem, Integrar viagem sem a Rota ?' ,'Atencao !!!')
					Return
				Endif
			Endif

			// VALICADA COMANDANTE
			cComand :=  DA4->DA4_XOPERA
			if !Empty(cComand)
				If fValida('COMANDANTE', cComand)
					AAdd( aCampos , { "codComandanteVg", cComand})
				Else
					FWAlertError('O comandante '+cComand+' informado na viagem, não está cadastrado no sistema NorteTrack', 'Atencao !!!')
					Return
				Endif
			else
				FWAlertError('Obrigatorio informar um comandante na viagem', 'Atencao !!!')
				Return
			Endif

			cVeic :=DA3->DA3_XVEIC
			if !Empty(cVeic)
				If fValida('VEICULO', cVeic)
					AAdd( aCampos , { "codViVg", cVeic})
				Else
					FWAlertError('O veiculo '+cVeic+' informado na viagem, não está cadastrado no sistema NorteTrack', 'Atencao !!!')
					Return
				Endif
			Else
				FWAlertError('Obrigatorio informar um veiculo na viagem', 'Atencao !!!')
				Return
			Endif

			AAdd( aCampos , { "codContaViVg", cCodContaViVg})
			AAdd( aCampos , { "NameViVg",  DA3->DA3_DESC})
			AAdd( aCampos , { "AddressViVg",  DA3->DA3_XADRVG})
			AAdd( aCampos , { "CodeViVg",  DA3->DA3_XCODVG})
			AAdd( aCampos , { "origemVg", cCidOri})
			AAdd( aCampos , { "destinoVg", cCidDes})
			AAdd( aCampos , { "dataPrevSaidaVg", cPrvDSai}) //12
			AAdd( aCampos , { "horaPrevSaidaVg", cPrvHSai}) //13
			AAdd( aCampos , { "dataSaidaVg", cDataSai})  //16
			AAdd( aCampos , { "horaSaidaVg", cHoraSai}) //17
			AAdd( aCampos , { "dataPrevChegadaVg", cPrvDChg}) //14
			AAdd( aCampos , { "horaPrevChegadaVg", cPrvHChg}) //15
			AAdd( aCampos , { "dataChegadaVg", cDataChg}) //18
			AAdd( aCampos , { "horaChegadaVg", cHoraChg}) //19
			AAdd( aCampos , { "abastecimentoVg",Alltrim(Transform(DTQ->DTQ_XABAST,  "@E 999,999")) })

			if  DTQ->DTQ_STATUS $ '3|5'   // Encerramento da viagem
				AAdd( aCampos , { "stsVg", "finalizada"})
			endif

		Endif
		//cBoundary := ----WebKitFormBoundaryFbmu0bODj7UvfQEV
		If lJSon
			cPostPar := '{' + cPostPar + '}'
		Else
			aEval( aCampos , {|x| cPostPar += CRLF + 'Content-Disposition: form-data; name="' + AllTrim(x[1]) + '"' + CRLF + CRLF +AllTrim(x[2]) + CRLF+ CRLF } )
		Endif

		if nOperacao == 3
			cPostPar:=''
			cParams:= ".php?codClienteEp="+cClient_ID

			nPos := AScan( aCampos , {|x| x[1] == "codVg" } )
			cParams += '&'+aCampos[nPos,1]+'='+aCampos[nPos,2]

			nPos := AScan( aCampos , {|x| x[1] == "stsVg" } )
			cParams += '&'+aCampos[nPos,1]+'='+aCampos[nPos,2]
			cPostRet := HTTPSPost( cURL + aOperacao[nOperacao] +cParams ,cCertCRT, cCertKEY, cSenha1, "", cPostPar, nTimeOut, aHeadOut, @cHeadRet )
		else
			cPostRet := HTTPSPost( cURL + aOperacao[nOperacao] + ".php?codClienteEp="+cClient_ID,cCertCRT, cCertKEY, cSenha1, "", cPostPar, nTimeOut, aHeadOut, @cHeadRet )
		endif
		*
		If !( cPostRet == Nil .Or. Empty( cPostRet ) )
			// Cria o objeto JSON e popula ele a partir da string
			oJSon := JSonObject():New()
			cErro := oJSon:fromJson(cPostRet)

			If ( cErro == Nil .Or. Empty(cErro) )
				If nOperacao < 3
					If nOperacao == 1 .and. oJSon['stsEp'] <> Nil .And. Upper(oJSon['stsEp']) == 'OK' .And. ;
							oJSon['infoEp'] <> Nil .And. oJSon['infoEp']['codVg'] <> Nil .And. oJSon['infoEp']['codIntVg'] <> Nil
						RecLock("DTQ",.F.)
						DTQ->DTQ_XCODVG := oJSon['infoEp']['codVg']
						DTQ->DTQ_XINTVG := oJSon['infoEp']['codIntVg']
						MsUnLock()
						FWAlertSuccess("Integração realizada com sucesso !"+ "Viagem: " +DTQ->DTQ_XCODVG,"Integrado.")
					elseif nOperacao == 2 .and. oJSon['stsEp'] <> Nil .And. Upper(oJSon['stsEp']) == 'OK' .And. ;
							oJSon['infoEp'] <> Nil .And. oJSon['infoEp']['codVg'] <> Nil
						FWAlertSuccess("Integração realizada com sucesso !"+ "Viagem: " +DTQ->DTQ_XCODVG,"Integrado.")
					ElseIf IsBlind()
						if !Empty(DecodeUTF8(oJSon["loopErrosEp"][1], "cp1252"))
							u_fconout( "[ED LOPES]: "+DecodeUTF8(oJSon["loopErrosEp"][1], "cp1252"))
						endif
					Else
						If 'codIntVg' $ oJSon["loopErrosEp"][1]
							cCodIntVg := GetSXENum('DTQ', 'DTQ_XINTVG')
							FWAlertWarning("[ED LOPES]: "+DecodeUTF8(oJSon["loopErrosEp"][1], "cp1252") +'.<br></br>A viagem vai assumir o Proximo sequencial, '+cCodIntVg, 'Tente Integrar novamente!')
							// ASSUME O PROXIMO
							RecLock("DTQ",.F.)
							DTQ->DTQ_XINTVG := cCodIntVg
							DTQ->DTQ_XCODVG := ''
							ConfirmSX8()
							MsUnLock()
						Else
							FWAlertWarning("[ED LOPES]: "+DecodeUTF8(oJSon["loopErrosEp"][1], "cp1252"))
						Endif
					Endif
				elseif nOperacao == 4 // EXCLUSÃO
					FWAlertSuccess("Integração realizada com sucesso, a viagem foi exlcuida!"+ "Exclusão integrado.")
				EndIf
			ElseIf IsBlind()
				u_fconout( "[ED LOPES]: Ocorreu erro na integracao da viagem ! " + cErro)
			Else
				FWAlertError("Ocorreu erro na integração da viagem !","JSON PARSE ERROR: " + cErro)
			Endif
		ElseIf IsBlind()
			u_fconout( "[ED LOPES]: Fail HTTPSPost: " + cPostRet )
		Else
			FWAlertError("Ocorreu erro na integração da viagem: <br /><br /><strong>" + AllTrim(cErro) + "</strong>","JSON PARSE ERROR: " + cPostRet)
		Endif
	Endif

Return

Static Function FormataData(dData)
Return Transform(DtoS(dData),"@R 9999-99-99")   // StrTran(PADR(DtoC(dData),6),"/","-") + Str(Year(dData),4)

Static Function fValida(cEndPoint, cParam)
	Local oJSon, cErro, lOk, cPostRet
	Local cPostPar := ''
	Local aHeadOut := {'Content-Type: application/json',"-d"}
	Local cCertCRT := ""   //"\certificado\EDLOPES_certificado.crt"   // <--- CERTIFICADO CRT (caso haja)
	Local cCertKEY := ""   //"\certificado\EDLOPES.key"   // <--- CERTIFICADO KEY (caso haja)
	Local nTimeOut := 120
	Local cHeadRet := ""
	Local cSenha1  := ""
	// Local cCodigo  := ""
	Local cURL     := u_URLEDLOPES()  // <--- URL DA ED LOPES
	Local lRetVal := .F.

	if cEndPoint == 'ROTA'
		cURL +="rotasListar.php?codClienteEp="+ GetMV("MV_XIDEDLO",.F.,"1659973881423")
	elseif cEndPoint == 'COMANDANTE'
		cURL +="comandantesListar.php?codClienteEp="+ GetMV("MV_XIDEDLO",.F.,"1659973881423")
	elseif cEndPoint == 'VEICULO'
		cURL +="veiculosListar.php?codClienteEp="+ GetMV("MV_XIDEDLO",.F.,"1659973881423")
	endif

	// cURL += "viagensListar.php?codClienteEp=" + GetMV("MV_XIDEDLO",.F.,"1659973881423")   // ID da Ed Lopes

	cPostRet := HTTPSPost( cURL,cCertCRT, cCertKEY, cSenha1, "", cPostPar, nTimeOut, aHeadOut, @cHeadRet )

	If lOk := !( cPostRet == Nil .Or. Empty( cPostRet ) )
		// Cria o objeto JSON e popula ele a partir da string
		oJSon := JSonObject():New()
		cErro := oJSon:fromJson(cPostRet)

		If lOk := ( cErro == Nil .Or. Empty(cErro) )
			if cEndPoint == 'ROTA'
				If oJSon['loopRt'] <> Nil .And. Len(oJSon['loopRt']) > 0 //.And. oJSon['loopRt'][1]['codRt'] <> Nil
					nRet := aScan(oJSon['loopRt'],{|x| x['codRt'] == cParam })
					// se não encontrar retorna zero, se retonar outro numero encontro a rota.
					lRetVal := iif(nRet == 0,.F.,.T.)
				Endif
			Elseif cEndPoint == 'COMANDANTE'
				If oJSon['loopCa'] <> Nil .And. Len(oJSon['loopCa']) > 0 //.And. oJSon['loopCa'][1]['codRt'] <> Nil
					nRet := aScan(oJSon['loopCa'],{|x| x['codCa'] == cParam })
					// se não encontrar retorna zero, se retonar outro numero encontro a rota.
					lRetVal := iif(nRet == 0,.F.,.T.)
				Endif
			Elseif cEndPoint == 'VEICULO'
				If oJSon['loopVi'] <> Nil .And. Len(oJSon['loopVi']) > 0 //.And. oJSon['loopVi'][1]['codRt'] <> Nil
					nRet := aScan(oJSon['loopVi'],{|x| x['codVi'] == cParam })
					// se não encontrar retorna zero, se retonar outro numero encontro a rota.
					lRetVal := iif(nRet == 0,.F.,.T.)
				Endif
			Endif
		ElseIf IsBlind()
			u_fconout( "[ED LOPES]: " + cErro)
		Else
			FWAlertError(cErro,"JSON PARSE ERROR")
		Endif
	Endif

Return lRetVal

User Function URLEDLOPES()
	Local cURLH := GetMV("MV_XURLHOM",.F.,"https://api.nortetrac.com.br/apiNavega/")   // URL Homologação
	Local cURLP := GetMV("MV_XURLPRD",.F.,"https://api.nortetrac.com.br/apiNavega/")   // URL Produção
	Local cBase := GetMV("MV_XMODINT",.F.,"1")    // Modo de integração com o SPCF: 1 = Produção, 2 = Homologação
Return If( cBase == "2" , cURLH, cURLP)
