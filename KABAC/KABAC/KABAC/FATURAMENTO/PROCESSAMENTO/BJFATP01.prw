#include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ BJFATP01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/07/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de geração de arquivo TXT do RENAVAM                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function BJFATP01()
	Local cPerg     := "BJFATP01"
	Local cCadastro := OemtoAnsi("Exportação de Motocicletas")
	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	AADD(aSays,OemToAnsi("Esta rotina irá gerar arquivos TXT com os dados referente as motocicletas") )
	AADD(aSays,OemToAnsi("baixadas no contas a pagar, para envio e cadastro no RENAVAM.            ") )
	AADD(aSays,OemToAnsi("                                                                         ") )
	
	AADD(aButtons, { 5,.T.,{| | Pergunte(cPerg,.T.)     }})
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
	AADD(aButtons, { 2,.T.,{|o| FechaBatch()            }})
	
	FormBatch( cCadastro, aSays, aButtons )
	
	If nOpca == 1
		Processa({|| FATP06a() },"Gerando TXTs...")
	Endif

Return nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATP06a    ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/07/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processa a geração do arquivo TXT                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FATP06a()
	Local nHdl, cLinha, nX
	Local nTam     := TamSX3("CD9_ITEM")[1]
	Local cNumLote := GetMv("MV_XLOTREN",.F.,"	")
	Local nNumReg  := 0
	Local cPath    := "\RENAVAM\"  //u_PathServer() + 
	Local cLocal   := GetTempPath()
	Local cAmb     := If( mv_par01 == 1 , "PR", "HO")
	Local cFile    := "K3244.K29822" + cAmb + ".M" + "HDB." + "L" + cNumLote + ".LE"
	Local cFilSF2  := SF2->(XFILIAL("SF2"))
	Local aVIN     := { "932", "952", "5HD", "5M2"}
	Local aRegs    := {}
	Local cTexto   := ""
	
	If !ExistDir(cPath)
		MakeDir(cPath)
	Endif
	
	If File(cPath+cFile)
		FClose(nHdl)                  // Fecha o arquivo
		FERASE(cPath+cFile)
	Endif
	
	nHdl := FCREATE(cPath+cFile,0)
	If FERROR() != 0
		MsgBox("Erro na Abertura do arquivo TXT: "+LTrim(Str(FERROR())),"Erro !!","STOP")
		Return
	Endif
	
	CD9->(dbSetOrder(1))   // CD9_FILIAL+CD9_TPMOV+CD9_SERIE+CD9_DOC+CD9_CLIFOR+CD9_LOJA+CD9_ITEM+CD9_COD
	SB1->(dbSetOrder(1))
	SZ1->(dbSetOrder(1))
	SC5->(dbSetOrder(1))
		
	SD2->(dbSetOrder(3))
	SF4->(dbSetOrder(1))
	
	SF2->(dbSeek(cFilSF2+mv_par02+mv_par04,.T.))
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
	
	//+---------------------------------------------------------------------------+
	//¦                       Registro de Identificação                           ¦
	//+---------------------------------------------------------------------------+
	cLinha := "ITP"                                   // Identificação do registro
	cLinha += Space(03)                               // Numero da transação de comunicação
	cLinha += "02"                                    // Numero da versão do Lay-out
	cLinha += cNumLote                                // Numero do lote
	cLinha += Dtos(dDataBase)+StrTran(Time(),":","")  // Identificação da geração do movimento
	cLinha += Trim(SM0->M0_CGC)                       // CGC da Montadora
	cLinha += "33683111000107"                        // Identificação do receptor de comunicação
	cLinha += PADR(aVIN[mv_par05],6)                  // Codigo da montadora no DENATRAN
	cLinha += Space(08)                               // Codigo interno do receptor
	cLinha += "PC18" /*SA1->A1_XDNAT*/                // Codigo interno do cliente
	cLinha += Space(80)                               // Brancos
	
	nNumReg++
	FWrite(nHdl,cLinha+CRLF)
	cTexto += cLinha+CRLF
	
	ProcRegua(SF2->(RecCount()))
	While !SF2->(Eof()) .And. SF2->F2_FILIAL == cFilSF2 .And. SF2->F2_DOC <= mv_par03
		
		IncProc()
		
		If SF2->F2_SERIE <> mv_par04  // Filtr séries diferentes
			SF2->(dbSkip())
			Loop
		Endif
		
		// Pesquisa no item da nota fiscal
		SD2->(dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
		While !SD2->(Eof()) .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
			
			If SF4->(dbSeek(XFILIAL("SF4")+SD2->D2_TES)) .And. SF4->F4_ESTOQUE == "S"
				If CD9->(dbSeek(XFILIAL("CD9")+"S"+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+PADR(SD2->D2_ITEM,nTam)+SD2->D2_COD))
					MontaSeguimento(nHdl,@nNumReg,@cTexto)
					AAdd( aRegs , { SD2->D2_DOC, SD2->D2_SERIE, SD2->D2_COD, CD9->CD9_CHASSI, LTrim(cValToChar(mv_par05))})
				EndiF
			Endif
			
			SD2->(dbSkip())
		Enddo
		
		// Ignora títulos sem VIN ou VIN for diferente do parâmetro
		/*If Empty(SD2->D2_NOVIN) .Or. PADR(SD2->D2_NOVIN,3) <> aVIN[mv_par05]
			SF2->(dbSkip())
			Loop
		Endif*/
		
		SF2->(dbSkip())
	Enddo
	
	If Empty(aRegs)
		Return
	Endif
	
	//+---------------------------------------------------------------------------+
	//¦                        Registro de Encerramento                           ¦
	//+---------------------------------------------------------------------------+
	nNumReg++
	cLinha := "FTP"                                      // Identificação do registro
	cLinha += cNumLote                                   // Número do Lote
	cLinha += StrZero(nNumReg,9)                         // Quantidade de registros
	cLinha += Space(136)                                 // Espaço (FILLER)
	
	FWrite(nHdl,cLinha+CRLF)
	cTexto += cLinha+CRLF
	FClose(nHdl)  // Fecha o arquivo
	
	If File(cLocal+cFile)
		FErase(cLocal+cFile)
	Endif
	
	CpyS2T(cPath+cFile, cLocal)
	
	If File(cLocal+cFile)
	Endif
	
	PutMV("MV_XLOTREN",StrZero(Val(cNumLote)+1,5))  // Atualiza o parâmetro com o próximo número
	
	If FWAlertYesNo("Deseja gravar o arquivo gerado ?")
		SZ5->(dbSetOrder(1))    // Z5_FILIAL+Z5_DOC+Z5_SERIE+Z5_VIN+Z5_OPERAC+Z5_AMBIENT+DTOS(Z5_DATAGER)+Z5_HORAGER
		For nX:=1 To Len(aRegs)
			RecLock("SZ5",.T.)
			SZ5->Z5_FILIAL  := XFILIAL("SZ5")
			SZ5->Z5_DOC     := aRegs[nX,1]
			SZ5->Z5_SERIE   := aRegs[nX,2]
			SZ5->Z5_VIN     := aRegs[nX,3]
			SZ5->Z5_OPERAC  := aRegs[nX,4]
			SZ5->Z5_AMBIENT := cAmb
			SZ5->Z5_DATAGER := Date()
			SZ5->Z5_HORAGER := Time()
			SZ5->Z5_USUARIO := __cUserID
			SZ5->Z5_HASH    := MD5FILE(cPath+"\"+cFile , 2, 0 )   // Calcula o identificador do arquivo
			SZ5->Z5_ARQUIVO := cFile
			SZ5->Z5_TEXTO   := cTexto
			MsUnLock()
		Next
	Endif

Return

Static Function MontaSeguimento(nHdl,nNumReg,cTexto)
	Local cLinha
	
	SB1->(dbSeek(XFILIAL("SB1")+SD2->D2_COD)) // Posiciona no cadastro de produtos
	
	//+---------------------------------------------------------------------------+
	//¦               Registro de Dados do Veículo - Segmento 1                   ¦
	//+---------------------------------------------------------------------------+
	cLinha := "VF1"                                   // Identificação do registro
	cLinha += CD9->CD9_CHASSI                         // Identificação do veículo (VIN) Confirmar (Z1_VIN 18) 
	cLinha += "N"                                     // Codigo de situação do VIN: (N)ormal, (R)emarcado
	cLinha += LTrim(cValToChar(mv_par05))             // Codigo de atualização: (1)Inclusão, (2)Alteração, (3)Exclusão
	cLinha += "1"                                     // Tipo de montagem: (1)Completa, (2)Incompleta
	cLinha += PADR(SB1->B1_XCCOR,2)                   // Codigo da cor predominante (Tabela DENATRAN)
	cLinha += SB1->B1_XTPVEIC  // Motocicleta         // Codigo do tipo do veículo (Tabela DENATRAN)
	cLinha += SB1->B1_XESPVEI  // Passageiro          // Codigo da espécie do veículo (Tabela DENATRAN)
	cLinha += SB1->B1_XCMOD                           // Codigo da marca/modelo (Tabela DENATRAN)
	cLinha += CD9->CD9_NMOTOR                         // Número do motor do veículo (Verificar Z1_EIN(10)?? )
	cLinha += SB1->B1_XTPCOMB  // Gasolina            // Codigo do tipo de combustível (Tabela DENATRAN)
	cLinha += SF2->F2_EST                             // Codigo do estado destino
	cLinha += If(SA1->A1_PESSOA=="F","1","2")         // Codigo do tipo de cadastro faturado: (1)CPF, (2)CGC
	cLinha += SA1->A1_CGC                             // Numero de cadastro do faturado
	cLinha += "0"+CD9->CD9_RESTR                      // Codigo restrição sobre o veículo (Tabela DENATRAN)
	cLinha += StrZero(Month(SZ1->Z1_DTINCLU),2)       // Mês de fabricação do veículo
	cLinha += Str(Year(SZ1->Z1_DTINCLU),4)            // Ano de fabricação do veículo
	cLinha += Str(SB1->B1_XANOMOD,4)                  // Ano/Modelo do veículo
	cLinha += PADR(SB1->B1_XPOT,3)                    // Quantidade de potência Confirmar(B1_POTENC 10)
	cLinha += "C"     /*SB1->B1_XUNPOT*/              // Unidade de potência (Verificar no SB1)
	cLinha += PADL(Trim(SB1->B1_XCILIN),4,"0")        // Número de cilindradas do veículo (B1_CILINDR)
	cLinha += Space(10)                               // Número da DI Confirmar(Z1_NUMDI 18)
	cLinha += Space(08)                               // Data de desembaraço da DI
	cLinha += Space(07)                               // Codigo da unidade local da SRF Confirmar (Z1_NUMSRF 8)
	cLinha += "N"                                     // Dispensa de CAT
	cLinha += Space(20)                               // SIMRAV ID
	cLinha += "00000" /*SB1->B1_XLCVM*/               // LCVM
	cLinha += Space(07)                               // Espaço (FILLER)
	
	nNumReg++
	FWrite(nHdl,cLinha+CRLF)
	cTexto += cLinha+CRLF
	
	//+---------------------------------------------------------------------------+
	//¦               Registro de Dados do Veículo - Segmento 2                   ¦
	//+---------------------------------------------------------------------------+
	cLinha := "VF2"                                   // Identificação do registro
	cLinha += StrZero(100*Val(CD9->CD9_TRACAO)/1000,5)// Capacidade máxima de tração
	cLinha += Space(21)                               // Número da carroceria / cabine
	cLinha += Space(03)                               // Codigo do tipo de carroceria
	cLinha += Space(21)                               // Número da caixa de cambio
	cLinha += Space(21)                               // Número do eixo traseiro/diferencial
	cLinha += Space(21)                               // Número do terceiro eixo
	cLinha += "00000"                                 // Capacidade maxima de carga(Verificar B1_CMKG)
	cLinha += StrZero(Int(SB1->B1_PESBRU/10),5)       // Peso bruto total(Verificar B1_PESOB)
	cLinha += "00"                                    // Número de eixos
	cLinha += StrZero(SB1->B1_XLOTAMX,3)              // Capacidade máxima de lotação
	cLinha += Space(43)                               // Espaço (FILLER)
	
	nNumReg++
	FWrite(nHdl,cLinha+CRLF)
	cTexto += cLinha+CRLF
		
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ DtoCS      ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/07/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Converte tipo data para o formato DDMMAAAA                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function DtoCS(dData)
	Local cRet := If( Empty(dData) , "00000000", Dtos(dData))
Return SubStr(cRet,7,2)+SubStr(cRet,5,2)+SubStr(cRet,1,4)

Static Function TiraCarac(cString)
	Local cRet := StrTran(StrTran(cString,"/",""),"-","")
Return If( Empty(cRet) , Repli("0",10), cRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/07/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Monta o grupo de perguntas da rotina                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)
	u_BJPutSX1(cPerg,"01",PADR("Ambiente            ",29)+"?","","","mv_ch1","N",01,0,0,"C","","","","","mv_par01",;
				"Producao","","","","Homologacao","","","    ")
	u_BJPutSX1(cPerg,"02",PADR("Do Titulo           ",29)+"?","","","mv_ch2","C",09,0,0,"G","","","","","mv_par02")
	u_BJPutSX1(cPerg,"03",PADR("Ate o Titulo        ",29)+"?","","","mv_ch3","C",09,0,0,"G","","","","","mv_par03")
	u_BJPutSX1(cPerg,"04",PADR("Prefixo             ",29)+"?","","","mv_ch4","C",03,0,0,"G","","","","","mv_par04")
	u_BJPutSX1(cPerg,"05",PADR("Operacao            ",29)+"?","","","mv_ch5","N",01,0,0,"C","","","","","mv_par05",;
	             "Inclusao","","","","Alteracao","","","Exclusao")
	//u_BJPutSX1(cPerg,"05",PADR("Produtos WMI        ",29)+"?","","","mv_ch5","N",01,0,0,"C","","","","","mv_par05",;
	//             "CKD Harley","","","","CKD Buell","","","CBU Harley","","","CBU Buell")
Return
