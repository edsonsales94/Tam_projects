#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
//#INCLUDE "EEC.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

//+-----------------------------------------------------------------------------------//
//|Empresa...: Procoating
//|Funcao....: U_DCI_ENVIO()
//|Autor.....: Luiz Fernando
//|Data......: 26 de Dezembro de 2009, 09:15
//|Uso.......: SIGAEIC
//|Versao....: Protheus - 10.1
//|Descricao.: Função para Geração de Declaração de Coeficiente de Internação de
//|			   Importação (DCI)
//|Observação:
//------------------------------------------------------------------------------------//
//+-----------------------------------------------------------------------------------//
//|Funcao....: DCI_ENVIO()
//|Descricao.: Gera envio de arquivo de acordo com o Layout do DCI
//|Parametros:
//|Retorno...:
//+-----------------------------------------------------------------------------------//

*-----------------------------------------*
User Function DCI_ENVIO()
*-----------------------------------------*

Private cArqEmb, cSql, cMsgem, lAbre, aStru
Private cArqTxt, nHdl, cEOL, cDiret, cCamposCSV, cMsg, cDadosCSV
Private bFileFat :={|| cDir:=ChoseDirDCI(),If(Empty(cDir),cDir:=Space(200),Nil)}
Private cArq     := Space(10)
Private cDir     := Space(250)
Private oDlg     := Nil
Private cPath    := "Selecione diretório"
Private aArea    := GetArea()
Private lRetor   := .T.
Private lSair    := .F.
Private lTudOk   := .T.
Private aCampos  := aReg := {}
Private cCodPrd  := Space(AvSx3("B1_COD",3))
Private ntotreg
Private MVnfIni  := Space(09) // Protheus 8 -- Para Protheus10 = Space(10)
Private MVnfFIN  := Space(09) // Protheus 8 -- Para Protheus10 = Space(10)
Private MVMenInd := " "       // M = Mensal - I = Individual
Private _cBco    := Space(03) // Bco - A6_COD
Private _cAge    := Space(05) // Age - A6_AGENCIA
Private _cConta  := Space(10) // C/C - A6_NUMCON
Private aItems 	 := {"I-Individual","M-Mensal"}
Private oTipoDCI := NIL

ntotreg := 0

If GetMV("MV_EASY") <> "S"
	MsgStop("Função não pode ser utilizada pois não há integração com o modulo de Compras/Estoque","Atenção")
	Return .T.
EndIf

cMsg := "Não há dados para o envio do DCI."+CHR(13)+CHR(10)
cMsg += "Por favor, verifique se todos os campos estão preenchidos corretamente."

//+-----------------------------------------------------------------------------------//
//| Definição da janela e seus conteúdos
//+-----------------------------------------------------------------------------------//
While .T.
	
	DEFINE MSDIALOG oDlg TITLE "Geração de arquivo - DCI" FROM 0,0 TO 205,368 OF oDlg PIXEL
	
	@ 06,06 TO 85,180 LABEL "Dados do arquivo" OF oDlg PIXEL
	
	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlg
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlg
	
	@ 13, 75 SAY   "Nota Fiscal"      SIZE 45,7 PIXEL OF oDlg
	@ 13, 115 MSGET MVnfIni           SIZE 50,8 PIXEL OF oDlg
	//@ 25, 75 SAY   "Nota Final"       SIZE 45,7 PIXEL OF oDlg
	//@ 25, 115 MSGET MVnfFin           SIZE 50,8 PIXEL OF oDlg
  
	@ 25, 75 SAY   "Tipo DCI ->"      SIZE 45,7 PIXEL OF oDlg
   	@ 25, 115 COMBOBOX oTipoDCI VAR MVMenInd ITEMS aItems SIZE 39,08 OF oDlg PIXEL

    ****** Dados Bancários  
    //@ 38,07 TO 42,179 LABEL "  Dados Bancários " OF oDlg PIXEL
	@ 45, 10 SAY   "Bco:"      SIZE 45,7 PIXEL OF oDlg
	@ 45, 25 MSGET _cBco       F3 "SA6" SIZE 20,8 PIXEL OF oDlg
	@ 45, 57 SAY   "Age:"      SIZE 45,7 PIXEL OF oDlg
	@ 45, 70 MSGET _cAge       SIZE 20,8 PIXEL OF oDlg
	@ 45, 102 SAY   "C/C:"     SIZE 45,7 PIXEL OF oDlg
	@ 45, 114 MSGET _cConta    SIZE 35,8 PIXEL OF oDlg
	// _cBco    := Space(03) // Bco - A6_COD
	// _cAge    := Space(05) // Age - A6_AGENCIA
	// _cConta  := Space(10) // C/C - A6_NUMCON

	@ 60, 10 SAY "Diretorio de gravação"  SIZE  65, 7 PIXEL OF oDlg
	@ 70, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlg
	@ 70,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlg ACTION Eval(bFileFat)
	
	DEFINE SBUTTON FROM 90,10 TYPE 1  OF oDlg ACTION (ValiArqDCI("ok")) ENABLE
	DEFINE SBUTTON FROM 90,50 TYPE 2  OF oDlg ACTION (ValiArqDCI("cancel")) ENABLE
	
	ACTIVATE MSDIALOG oDlg CENTER
	
	If lRetor
		Exit
	Else
		Loop
	EndIf
EndDo

If lSair
	Return .T.
EndIf

Processa({|| GeraArqDCI() },'Analisando Dados...')

If lTudOk
	MsgInfo("Arquivo Gerado com Sucesso !","Atenção")
EndIf

Return .T.

//+-----------------------------------------------------------------------------------//
//|Funcao....: ValiArqDCI()
//|Descricao.: Valida informações de gravação
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function ValiArqDCI(cValida)
*-----------------------------------------*

Local lCancela
                            
MVMenInd := Substr(MVMenInd,1,1)

If cValida = "ok"
	If Empty(Alltrim(cArq))
		MsgInfo("O nome do arquivo deve ser informado","Atenção")
		lRetor := .F.
	ElseIf Empty(Alltrim(cDir))
		MsgInfo("O diretório deve ser informado","Atenção")
		lRetor := .F.
	ElseIf Len(Alltrim(cDir)) <= 3
		MsgInfo("Não se pode gravar o arquivo no diretório raiz, por favor, escolha um subdiretório.","Atenção")
		lRetor := .F.
	ElseIf Empty(Alltrim(MvNfIni))
		MsgInfo("A nota fiscal Inicial deve ser informada.","Atenção")
		lRetor := .F.
//	ElseIf Empty(Alltrim(MvNfFin))
//		MsgInfo("A nota fiscal Final deve ser informada.","Atenção")
//		lRetor := .F.
//	ElseIf Val(Alltrim(MvNfFin)) < Val(Alltrim(MvNfIni))
//		MsgInfo("Nota Fiscal Final deve ser maior ou igual a Nota Fiscal Inicial.","Atenção")
//		lRetor := .F.
	ElseIf !SF2->(DbSeek(xFilial("SF2")+MvNfIni))
		MsgInfo("Nota Fiscal Inicial Não Existe ! Selecione Nota Valida.","Atenção")
		lRetor := .F.
 //	ElseIf !SF2->(DbSeek(xFilial("SF2")+MvNfFin))
 //		MsgInfo("Nota Fiscal Final Não Existe ! Selecione Nota Valida.","Atenção")
 //		lRetor := .F.
	ElseIf !Alltrim(MvMenInd) $ "M/I"
		MsgInfo("Informar (M)ensal ou (I)ndividual.","Atenção")
		lRetor := .F.
	ElseIf Empty(_cBco) .or. Empty(_cAge) .or. Empty(_cConta)
		MsgInfo("Algum campo dos Dados Bancários está em Branco!.","Atenção")
		lRetor := .F.
	Else
		oDlg:End()
		lRetor := .T.
	EndIf
Else
	lCancela := MsgYesNo("Deseja cancelar a geração do arquivo - DCI ?","Atenção")
	If lCancela
		oDlg:End()
		lRetor := .T.
		lSair  := .T.
	Else
		lRetor := .F.
	EndIf
EndIf

Return(lRetor)

//+-----------------------------------------------------------------------------------//
//|Funcao....: ChoseDirDCI()
//|Descricao.: Localiza diretório de gravação
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function ChoseDirDCI()
*-----------------------------------------*
Local cTitle:= "Geração de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)

//+-----------------------------------------------------------------------------------//
//|Funcao....: GeraArq()
//|Descricao.: Gera Arquivo para envio
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function GeraArqDCI()
*-----------------------------------------*

cArqTxt := Alltrim(cDir)+Alltrim(cArq)+".txt"
nHdl    := fCreate(cArqTxt)

cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	DelTemp()
	Return
Endif

If MvMenInd == "M"
	Processa({|| RunContDCIm() },"Processando...") /// DCI Mensal
Else
	Processa({|| RunContDCIi() },"Processando...") /// DCI Individual
Endif

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: RunContDCIi() -- Individual
//|Descricao.: Chama função para gerar arquivo
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function RunContDCIi()
*-----------------------------------------*

Local nTamLin, cLin, cCpo
Local nFlag  := 0
Local cDados := ""
Local cGeral := ""


SF2->(DbSeek(xFilial("SF2")+MvNfIni))

While !Eof() .and. SF2->F2_DOC == MvNfIni //<= MvNfFin
	
	cDocF2 := SF2->F2_DOC
	cSerie := SF2->F2_SERIE
	
	// REGISTRO TIPO "00" - Dados do Header da Individual do DCI                    //| INI | FIM | TAMANHO |  CAMPO
	
   	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL
	cDados  := ""
	
	cDados := "00"                                                                 	//| 001 | 002 |    02   |  CD-TIPO-REGISTRO
	cDados += "DCI/ZFM"                                                         	//| 003 | 009 |    07   |  ID-ARQUIVO
	cDados += "2" // 2 - Estrutura Própria                                         	//| 010 | 010 |    01   |  CD-ORIGEM-DCI
	cDados += "02.00"                                                           	//| 011 | 015 |    05   |  Número da Versão do Sistema.
	cDados += "1"                                                              		//| 016 | 016 |    01   |  1 - Individual
	cDados += "000000"                                                            	//| 017 | 022 |    06   |  Preencher com 6 zeros
	//cDados += "00000062005316"  //SM0->M0_INSC   							        //| 023 | 036 |    14   |  Número da Inscrição Estadual
    cDados += SM0->M0_INSC  					  							        //| 023 | 036 |    14   |  Número da Inscrição Estadual
	cDados += cSerie + SPACE(02)                                                    //| 037 | 041 |    05   |  Número de Série da Nota Fiscal de Saída
	cDados += StrZero(Val(cDocF2),6,0)                   	    	                //| 042 | 047 |    06   |  Número da Nota Fiscal de Saída
	//cDados += "08645240000155"	//SM0->M0_CGC			                    	//| 048 | 061 |    14   |  CNPJ do estabelecimento internador, incluindo dígitos verificadores.
    cDados += SM0->M0_CGC									                    	//| 048 | 061 |    14   |  CNPJ do estabelecimento internador, incluindo dígitos verificadores.	
	
	cLin := Stuff(cLin,01,02,cDados)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho TIPO 00. Continua?","Atencao!")
			lTudOk := .F.
		Endif
	Endif
	
   nTotReg += 1
	
	// REGISTRO TIPO "01" - Registro: 01 - "Dados da DCI Individual"            	 //| INI | FIM | TAMANHO |  CAMPO
	
	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL
	cDados  := ""
	
	cDados := "01"                                                                 	  //| 001 | 002 |    02   |  CD-TIPO-REGISTRO
	cDados += "1"                                                              		  //| 003 | 003 |    01   |  1 - Individual
	cDados += "2"                                         							  //| 004 | 004 |    01   |  2 - Estrutura Própria
	cDados += "000000"                                                            	  //| 005 | 010 |    06   |  Preencher com 6 zeros
	//cDados += "08645240000155" //SM0->M0_CGC				                    	  //| 011 | 024 |    14   |  CNPJ do estabelecimento internador, incluindo dígitos verificadores.
	//cDados += "00000062005316" //SM0->M0_INSC  		   		                      //| 025 | 038 |    14   |  Número da Inscrição Estadual
	cDados += SM0->M0_CGC									                    	  //| 011 | 024 |    14   |  CNPJ do estabelecimento internador, incluindo dígitos verificadores.
	cDados += SM0->M0_INSC 					 		    		                      //| 025 | 038 |    14   |  Número da Inscrição Estadual
	cDados += cSerie + SPACE(02)                                                      //| 039 | 043 |    05   |  Número de Série da Nota Fiscal de Saída
	cDados += StrZero(Val(cDocF2),6,0)                   	    	                  //| 044 | 049 |    06   |  Número da Nota Fiscal de Saída
	cDados += DtoS(SF2->F2_EMISSAO)                        	    	                  //| 050 | 057 |    08   |  Data de Emissão da Nota Fiscal
	cDados += DtoS(SF2->F2_EMISSAO)                        	    	                  //| 058 | 065 |    08   |  Data de Emissão da Nota Fiscal
	_cCfo := Posicione("SD2",3,xFilial("SD2")+cDocF2+cSerie,"D2_CF")
	cDados += Substr(_cCfo,1,4)                        	    	                	  //| 066 | 069 |    04   |  Código CFOP da Nota Fiscal
	cDados += "1"			                        	    	                	  //| 070 | 070 |    01   |  1 - CNPJ    2 - CPF-Destinatario
	cDados += Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC") //| 071 | 084 |    15   |  Identificação do Destinatário. Se CD-TIPO-DESTINAT = 1,  preencher o CNPJ completo, incluindo os dígitos verificadores. Se CD-TIPO-DESTINAT = 2,  preencher o CPF alinhado à esquerda e completar com brancos.
	cDados += Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EST") //| 085 | 086 |    02   |  Unidade da Federação para qual se destina a mercadoria.
	cDados += "N" 																	  //| 087 | 087 |    01   |  'S' - Internação para Área de Livre Comércio na Amazônia Ocidental 'N' -Não internação para Área de Livre Comércio na Amazônia Ocidental..
	cDados += _cBco 																  //| 088 | 090 |    03   |  Número do banco
	cDados += StrZero(Val(_cAge),04,0)												  //| 091 | 094 |    04   |  Número da agência, sem dígito verificador. Preencher com zeros à esquerda até o tamanho máximo do campo.
	cDados += StrZero(Val(_cConta),19,0) 											  //| 095 | 113 |    19   |  Número da conta corrente alinhado à direita. Preencher com zeros à esquerda até o tamanho máximo do campo.
	
	cLin := Stuff(cLin,01,02,cDados)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho TIPO 01. Continua?","Atencao!")
			lTudOk := .F.
		Endif
	Endif
	
	nTotReg += 1
	
	// Registro: 02 - "Dados Mandado Judicial"
   	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL
	cDados  := ""
	
	cDados := "02NN000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000"                                                                 	//| 001 | 002 |    02   |  CD-TIPO-REGISTRO
	
	cLin := Stuff(cLin,01,02,cDados)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho TIPO 02. Continua?","Atencao!")
			lTudOk := .F.
		Endif
	Endif
	
	// Registro: 03 - "Dados Retificação"
   	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL
	cDados  := ""
	
	cDados := "03000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"                                                                 	//| 001 | 002 |    02   |  CD-TIPO-REGISTRO
	
	cLin := Stuff(cLin,01,02,cDados)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho TIPO 03. Continua?","Atencao!")
			lTudOk := .F.
		Endif
	Endif

	// Registro: 11 - "Dados do produto-local da DCI Individual - PE"
	// Registro: 12 - "Nota Fiscal de Aquisição / Produto-local da DCI Individual - PE"
	// Registro: 13 - "DI / Produto-local da DCI Individual - PE"
	// Registro: 14 - "DSI / Produto-local da DCI Individual - PE"
	
	cMsgem := "Arquivo gerado com sucesso!"+CHR(13)+CHR(10)
	cMsgem += "O arquivo "+Alltrim(cArq)+".txt"+" se encontra no diretório "+Alltrim(cDir)
	
	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL
	
	ProcRegua(0)
	
	DbSelectArea("SD2")
	DbSetorder(3)
	DbSeek(xFilial("SD2")+cDocF2+cSerie)
	
	IncProc("Gerando arquivo de Envio")
	
	While SD2->D2_DOC == cDocF2
		
		_cNrDcre := Substr(Alltrim(StrTran(Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_X_DCRII"),"/","")),1,10)
       _cTipo_PI := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_X_TIPPI")
		        
		If !Empty(_cNrDcre) 
		
			// REGISTRO TIPO "21" - Registro: 21 - "Produto-local da DCI Individual / PI Com PPB"
			
			nTamLin := 2
			cLin    := Space(nTamLin)+cEOL
			cDados  := ""
			
			cDados := "21"																	//| 001 | 002 |    02   | CD-TIPO-REGISTRO
			cDados += StrZero(Val(SD2->D2_ITEM),3,0)                                      	//| 003 | 005 |    03   | Número do Item da Nota Fiscal de Saída
			_cEst := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EST")
			cDados += IIf(_cEst $ "AC/AM/RO/RR","1","2")     								//| 006 | 006 |    01   | Se unidade da federação(CD_UF_DESTINO) da NFS = 'AC', 'AM', 'RO' ou 'RR', preencher 1. Caso contrário, preencher 2.
			cDados += Replicate("0",10-Len(Alltrim(_cNrDcre)))+Alltrim(_cNrDcre)			//| 007 | 016 |    10   | Se o produto  tiver um DCR Eletrônico, informar o número do DCR-E. Caso contrário,  preencher 10 zeros.
			cDados += SD2->D2_COD                                                          	//| 017 | 031 |    15   | Informar o código do controle interno do produto.
			cDados += "000000000"                                                          	//| 032 | 040 |    09   | Se o produto não tiver um DCR Eletrônico, informar o número do DCR antigo. Caso contrário,  preencher 9 zeros.
			_cDescProd := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_X_COMP")
			cDados += Substr(Alltrim(_cDescProd)+Space(45-Len(Alltrim(_cDescProd))),1,45)  	//| 041 | 085 |    45   | Informar a descrição do produto.
			cDados += "00000000000000000000"                                               	//| 086 | 105 |    20   | Se preenchido o DCR antigo,  informar o valor unitário do II do produto, em dólar. Caso contrário, preencher 20 zeros, pois o sistema buscará essa informação no sistema DCR-E.
			cDados += "00000"                                               				//| 106 | 110 |    05   | Se preenchido o DCR antigo,  informar o valor do percentual do coeficiente de redução do II do produto. Caso contrário, preencher 5 zeros, pois o sistema buscará essa informação no sistema DCR-E.
                   _nQtdUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_QUANT,SD2->D2_QTSEGUM)
			cDados += StrTran(StrZero(_nQtdUni,15,5),".","")    	        				//| 111 | 124 |    14   | Informar a quantidade total do produto internado na unidade do DCR-E ou, caso informado um DCR, informar a quantidade total na unidade de medida comercializada na internação (NM-UNID-MED-PROD).
			cDados += "00000000000000"  //FILLER                               				//| 125 | 138 |    14   | Preencher 14 zeros.
			cDados += Space(20)                                                				//| 139 | 158 |    20   | Unidade de medida comercializada na internação do produto, para o caso de DCR. No caso de DCR-E, preencher com brancos.
			cDados += StrTran(StrZero(0.00,21,7),".","")                       				//| 159 | 178 |    20   | Informar o valor do PIS/PASEP a ser recolhido
			cDados += StrTran(StrZero(0.00,21,7),".","")                       				//| 179 | 198 |    20   | Informar o valor do COFINS a ser recolhido
			
			cLin := Stuff(cLin,01,02,cDados)
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo em ITENS REGISTRO TIPO 21. Continua?","Atencao!")
				  	lTudOk := .F.
				Endif
			Endif
			nTotReg += 1
			
		ElseIf _cTipo_PI == "1" .OR. Empty(_cTipo_PI)
		
			// REGISTRO TIPO "31" - Registro: 31 - "Produto-local da DCI Individual - PI Sem PPB"
			
			nTamLin := 2
			cLin    := Space(nTamLin)+cEOL
			cDados  := ""
			
			cDados := "31"																	//| 001 | 002 |    02   | CD-TIPO-REGISTRO
			cDados += StrZero(Val(SD2->D2_ITEM),3,0)                                      	//| 003 | 005 |    03   | Número do Item da Nota Fiscal de Saída
			cDados += SD2->D2_COD                                                          	//| 006 | 020 |    15   | Informar o código do controle interno do produto.
			_cDescProd := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_X_COMP")
			cDados += Substr(Alltrim(_cDescProd)+Space(45-Len(Alltrim(_cDescProd))),1,45)   //| 021 | 065 |    45   | Informar a descrição do produto.
			_cUM := Space(20)
                   _cUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_UM,SD2->D2_SEGUM)
			Do Case
				Case _cUni == "PC"
					_cUM := "PEÇA                "
				Case _cUni == "KG"
					_cUM := "KILO GRAMA          "
				Case _cUni == "M2"
					_cUM := "METRO QUADRADO      "
			EndCase
			cDados += _cUM                                                                 	//| 066 | 085 |    20   | Unidade de medida comercializada na internação do produto
			_cNCM      := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_POSIPI")
			cDados += Alltrim(_cNCM)                                              			//| 086 | 093 |    08   | Código NCM do produto
                   _nQtdUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_QUANT,SD2->D2_QTSEGUM)
			cDados += StrTran(StrZero(_nQtdUni,15,5),".","")	            				//| 094 | 107 |    14   | Quantidade do Produto internado, na mesma unidade de comercialização utilizada na Nota Fiscal de Saída de sua internação (NM-UNID-MED-NFS).
			cDados += StrTran(StrZero(SD2->D2_PRCVEN,21,7),".","")            				//| 108 | 127 |    20   | Informar o valor unitário do produto internado, na unidade comercial do produto utilizada na Nota Fiscal de Saída de sua internação.
			_cEst := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EST")
			cDados += IIf(_cEst $ "AC/AM/RO/RR","1","0")     								//| 128 | 128 |    01   | Se unidade da federação da NFS = 'AC', 'AM', 'RO' ou 'RR', preencher 1. Caso  contrário, preencher 0.
			cDados += "00000000000000"  //FILLER                               				//| 129 | 142 |    14   | Preencher 14 zeros.
			_cEst := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EST")
			cDados += IIf(_cEst $ "AC/AM/RO/RR","1","0")     								//| 143 | 143 |    01   | Se unidade da federação da NFS diferente de 'AC', 'AM', 'RO' ou 'RR', preencher 2. Caso contrário, preencher 0.
			cDados += "00000000000000"  //FILLER                               				//| 144 | 157 |    14   | Preencher 14 zeros.
			_cEst := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EST")
			cDados += IIf(_cEst $ "AC/AM/RO/RR","3","0")     								//| 158 | 158 |    01   | Se unidade da federação da NFS = 'AC', 'AM', 'RO' ou 'RR' e IN_SAIDA_ALC_AO = "S", preencher 3.Caso contrário, preencher 0.
			cDados += "00000000000000"  //FILLER                               				//| 159 | 172 |    14   | Preencher 14 zeros.
			_cEst := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EST")
			cDados += IIf(_cEst $ "AC/AM/RO/RR","4","0")     								//| 173 | 173 |    01   | Se unidade da federação da NFS diferente de 'AC', 'AM', 'RO' e 'RR', e IN_SAIDA_ALC_AO = "N", preencher 4 Caso contrário, preencher 0.
			cDados += "00000000000000"  //FILLER                               				//| 174 | 187 |    14   | Preencher 14 zeros.
			
			cLin := Stuff(cLin,01,02,cDados)
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo em ITENS REGISTRO TIPO 31. Continua?","Atencao!")
				  lTudOk := .F.
				Endif
			Endif
			nTotReg += 1

		ElseIf _cTipo_PI == "2"
		
			// REGISTRO TIPO "41" - Registro: 41 - "Item da DCI Individual - 100% Nacional"

			nTamLin := 2
			cLin    := Space(nTamLin)+cEOL
			cDados  := ""
			
			cDados := "41"																	//| 001 | 002 |    02   | CD-TIPO-REGISTRO
			cDados += StrZero(Val(SD2->D2_ITEM),3,0)                                      	//| 003 | 005 |    03   | Número do Item da Nota Fiscal de Saída
			_cNCM      := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_POSIPI")
			cDados += Alltrim(_cNCM)                                              			//| 006 | 013 |    08   | Código NCM do produto
			cDados += SD2->D2_COD                                                          	//| 014 | 028 |    15   | Informar o código do controle interno do produto.
			_cDescProd := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_X_COMP")
			cDados += Substr(Alltrim(_cDescProd)+Space(45-Len(Alltrim(_cDescProd))),1,45)   //| 029 | 073 |    45   | Informar a descrição do produto.
			_cUM := Space(20)
                   _cUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_UM,SD2->D2_SEGUM)
			Do Case
				Case _cUni == "PC"
					_cUM := "PEÇA                "
				Case _cUni == "KG"
					_cUM := "KILO GRAMA          "
				Case _cUni == "M2"
					_cUM := "METRO QUADRADO      "
			EndCase
			cDados += _cUM                                                                 	//| 074 | 093 |    20   | Unidade de medida comercializada na internação do produto
                   _nQtdUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_QUANT,SD2->D2_QTSEGUM)
			cDados += StrTran(StrZero(_nQtdUni,15,5),".","")	            				//| 094 | 107 |    14   | Quantidade do Produto internado, na mesma unidade de comercialização utilizada na Nota Fiscal de Saída de sua internação (NM-UNID-MED-NFS).
                   _nQtdUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_QUANT,SD2->D2_QTSEGUM)
			cDados += StrTran(StrZero(_nQtdUni,15,5),".","")	            				//| 108 | 121 |    14   | Quantidade do produto internado, na unidade estatística da NCM do produto. 
			cDados += StrTran(StrZero(SD2->D2_PRCVEN,21,7),".","")            				//| 122 | 141 |    20   | Informar o valor unitário do produto internado, na unidade comercial do produto utilizada na Nota Fiscal de Saída de sua internação.
			cDados += "000000000000000"  //FILLER                              				//| 142 | 156 |    15   | Preencher 15 zeros.
			cDados += "00000000000000"   //FILLER                              				//| 157 | 170 |    14   | Preencher 14 zeros.
			cDados += "00000000000000"   //FILLER                              				//| 171 | 184 |    14   | Preencher 14 zeros.
			
			cLin := Stuff(cLin,01,02,cDados)
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo em ITENS REGISTRO TIPO 31. Continua?","Atencao!")
				  lTudOk := .F.
				Endif
			Endif
			nTotReg += 1

		Endif

		// Registro: 32 - "Matriz Produto x Insumo do Item da DCI Individual - PI Sem PPB"
		// Registro: 33 - "Insumo do produto-local da DCI Individual - PI Sem PPB"
		// Registro: 34 - "Nota Fiscal de Aquisição / Insumo do produto-local da DCI Individual - PI s/PPB"
		// Registro: 35 - "DI / Insumo do produto-local da DCI Individual - PI s/PPB"
		// Registro: 36 - "DSI / Insumo do produto-local da DCI Individual - PI s/PPB"
		
		SD2->(DbSkip())
		
	Enddo

	SF2->(DbSkip())
	
Enddo

fClose(nHdl)

Return

**** Fim envio 

//+-----------------------------------------------------------------------------------//
//|Funcao....: RunContDCIm() -- Mensal
//|Descricao.: Chama função para gerar arquivo
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function RunContDCIm()
*-----------------------------------------*

Local nTamLin, cLin, cCpo
Local nFlag  := 0
Local cDados := ""
Local cGeral := ""


SF2->(DbSeek(xFilial("SF2")+MvNfIni))

While !Eof() .and. SF2->F2_DOC == MvNfFin //<= MvNfFin
	
	cDocF2 := SF2->F2_DOC
	cSerie := SF2->F2_SERIE
	
	// REGISTRO TIPO "00" - Dados do Header da Individual do DCI                   	//| INI | FIM | TAMANHO |  CAMPO
	
   	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL
	cDados  := ""
	
	cDados := "00"                                                                 	//| 001 | 002 |    02   |  CD-TIPO-REGISTRO
	cDados += "DCI/ZFM"                                                         	//| 003 | 009 |    07   |  ID-ARQUIVO
	cDados += "2" // 2 - Estrutura Própria                                         	//| 010 | 010 |    01   |  CD-ORIGEM-DCI
	cDados += "02.00"                                                           	//| 011 | 015 |    05   |  Número da Versão do Sistema.
	cDados += "2"                                                              		//| 016 | 016 |    01   |  1 - Mensal
	cDados += Substr(DtoS(SF2->F2_EMISSAO),1,6)                                    	//| 017 | 022 |    06   |  Ano e mês de referência
	cDados += "00000000000000"                             		                    //| 023 | 036 |    14   |  Preencher com 14 zeros
	cDados += Space(05)                                                             //| 037 | 041 |    05   |  Preencher com brancos
	cDados += "000000"                                   	    	                //| 042 | 047 |    06   |  Preencher com 6 zeros
	//cDados += "08645240000155" //SM0->M0_CGC				                    	//| 048 | 061 |    14   |  CNPJ do estabelecimento internador, incluindo dígitos verificadores.
	cDados += SM0->M0_CGC									                    	//| 048 | 061 |    14   |  CNPJ do estabelecimento internador, incluindo dígitos verificadores.
	
	cLin := Stuff(cLin,01,02,cDados)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho TIPO 00. Continua?","Atencao!")
			lTudOk := .F.
		Endif
	Endif
	
   nTotReg += 1
	
	// REGISTRO TIPO "01" - Registro: 01 - "Dados da DCI Individual"            	 //| INI | FIM | TAMANHO |  CAMPO
	
	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL
	cDados  := ""
	
	cDados := "01"                                                                 	  //| 001 | 002 |    02   |  CD-TIPO-REGISTRO
	cDados += "2"                                                              		  //| 003 | 003 |    01   |  1 - Mensal
	cDados += "2"                                         							  //| 004 | 004 |    01   |  2 - Estrutura Própria
	cDados += Substr(DtoS(SF2->F2_EMISSAO),1,6)                                 	  //| 005 | 010 |    06   |  Ano e mês de referência
	//cDados += "08645240000155" //SM0->M0_CGC				                    	  //| 011 | 024 |    14   |  CNPJ do estabelecimento internador, incluindo dígitos verificadores.
    cDados += SM0->M0_CGC									                    	  //| 011 | 024 |    14   |  CNPJ do estabelecimento internador, incluindo dígitos verificadores.
	cDados += "00000000000000"                            		                      //| 025 | 038 |    14   |  Preencher com 14 zeros
	cDados += Space(05)                                                               //| 039 | 043 |    05   |  Preencher com brancos
	cDados += "000000"                                   	    	                  //| 044 | 049 |    06   |  Preencher com 6 zeros
	cDados += "00000000"                                   	    	                  //| 050 | 057 |    08   |  Preencher com 8 zeros
	cDados += "00000000"		                        	    	                  //| 058 | 065 |    08   |  Preencher com 8 zeros
	cDados += "0000"                                   	    	                	  //| 066 | 069 |    04   |  Preencher com 4 zeros
	cDados += "0"			                        	    	                	  //| 070 | 070 |    01   |  Preencher com  zero
	cDados += Space(14)                                                               //| 071 | 084 |    14   |  Preencher com brancos
	cDados += Space(02)                                                               //| 085 | 086 |    02   |  Preencher com brancos
	cDados += " " 																	  //| 087 | 087 |    01   |  Preencher com brancos
	cDados += _cBco 																  //| 088 | 090 |    03   |  Número do banco
	cDados += StrZero(Val(_cAge),04,0)												  //| 091 | 094 |    04   |  Número da agência, sem dígito verificador. Preencher com zeros à esquerda até o tamanho máximo do campo.
	cDados += StrZero(Val(_cConta),19,0) 											  //| 095 | 113 |    19   |  Número da conta corrente alinhado à direita. Preencher com zeros à esquerda até o tamanho máximo do campo.
		
	cLin := Stuff(cLin,01,02,cDados)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho TIPO 01. Continua?","Atencao!")
			lTudOk := .F.
		Endif
	Endif
	
	nTotReg += 1
	
	// Registro: 02 - "Dados Mandado Judicial"
   	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL
	cDados  := ""
	
	cDados := "02NN000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000"                                                                 	//| 001 | 002 |    02   |  CD-TIPO-REGISTRO
	
	cLin := Stuff(cLin,01,02,cDados)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho TIPO 02. Continua?","Atencao!")
			lTudOk := .F.
		Endif
	Endif
	
	// Registro: 03 - "Dados Retificação"
   	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL
	cDados  := ""
	
	cDados := "03000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"                                                                 	//| 001 | 002 |    02   |  CD-TIPO-REGISTRO
	
	cLin := Stuff(cLin,01,02,cDados)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo no Cabeçalho TIPO 03. Continua?","Atencao!")
			lTudOk := .F.
		Endif
	Endif

	// Registro: 11 - "Dados do produto-local da DCI Individual - PE"
	// Registro: 12 - "Nota Fiscal de Aquisição / Produto-local da DCI Individual - PE"
	// Registro: 13 - "DI / Produto-local da DCI Individual - PE"
	// Registro: 14 - "DSI / Produto-local da DCI Individual - PE"
	
	cMsgem := "Arquivo gerado com sucesso!"+CHR(13)+CHR(10)
	cMsgem += "O arquivo "+Alltrim(cArq)+".txt"+" se encontra no diretório "+Alltrim(cDir)
	
	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL
	
	ProcRegua(0)
	
	DbSelectArea("SD2")
	DbSetorder(3)
	DbSeek(xFilial("SD2")+cDocF2+cSerie)
	
	IncProc("Gerando arquivo de Envio")
	
	While SD2->D2_DOC == cDocF2
		
		_cNrDcre := Substr(Alltrim(StrTran(Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_X_DCRII"),"/","")),1,10)
				
		If !Empty(_cNrDcre) 
		
			// REGISTRO TIPO "21" - Registro: 21 - "Produto-local da DCI Individual / PI Com PPB"
			
			nTamLin := 2
			cLin    := Space(nTamLin)+cEOL
			cDados  := ""
			
			cDados := "21"																	//| 001 | 002 |    02   | CD-TIPO-REGISTRO
			cDados += "000"                                                               	//| 003 | 005 |    03   | Preencher com 3 zeros
			_cEst := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EST")
			cDados += IIf(_cEst $ "AC/AM/RO/RR","1","2")     								//| 006 | 006 |    01   | Se unidade da federação(CD_UF_DESTINO) da NFS = 'AC', 'AM', 'RO' ou 'RR', preencher 1. Caso contrário, preencher 2.
			cDados += Replicate("0",10-Len(Alltrim(_cNrDcre)))+Alltrim(_cNrDcre)			//| 007 | 016 |    10   | Se o produto  tiver um DCR Eletrônico, informar o número do DCR-E. Caso contrário,  preencher 10 zeros.
			cDados += SD2->D2_COD                                                          	//| 017 | 031 |    15   | Informar o código do controle interno do produto.
			cDados += "000000000"                                                          	//| 032 | 040 |    09   | Se o produto não tiver um DCR Eletrônico, informar o número do DCR antigo. Caso contrário,  preencher 9 zeros.
			_cDescProd := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_X_COMP")
			cDados += Substr(Alltrim(_cDescProd)+Space(45-Len(Alltrim(_cDescProd))),1,45)  	//| 041 | 085 |    45   | Informar a descrição do produto.
			cDados += "00000000000000000000"                                               	//| 086 | 105 |    20   | Se preenchido o DCR antigo,  informar o valor unitário do II do produto, em dólar. Caso contrário, preencher 20 zeros, pois o sistema buscará essa informação no sistema DCR-E.
			cDados += "00000"                                               				//| 106 | 110 |    05   | Se preenchido o DCR antigo,  informar o valor do percentual do coeficiente de redução do II do produto. Caso contrário, preencher 5 zeros, pois o sistema buscará essa informação no sistema DCR-E.
			cDados += "00000000000000"  //FILLER                               				//| 111 | 124 |    14   | Preencher 14 zeros.
                   _nQtdUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_QUANT,SD2->D2_QTSEGUM)
			cDados += StrTran(StrZero(_nQtdUni,15,5),".","") 		           				//| 125 | 138 |    14   | Informar a quantidade total do produto internado na unidade do DCR-E ou, caso informado um DCR, informar a quantidade total na unidade de medida comercializada na internação (NM-UNID-MED-PROD).
			cDados += Space(20)                                                				//| 139 | 158 |    20   | Unidade de medida comercializada na internação do produto, para o caso de DCR. No caso de DCR-E, preencher com brancos.
			cDados += StrTran(StrZero(0.00,21,7),".","")                       				//| 159 | 178 |    20   | Informar o valor do PIS/PASEP a ser recolhido
			cDados += StrTran(StrZero(0.00,21,7),".","")                       				//| 179 | 198 |    20   | Informar o valor do COFINS a ser recolhido
			
			cLin := Stuff(cLin,01,02,cDados)
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo em ITENS REGISTRO TIPO 21. Continua?","Atencao!")
				  	lTudOk := .F.
				Endif
			Endif
			nTotReg += 1
			
		ElseIf _cTipo_PI == "1" .OR. Empty(_cTipo_PI)
		
			// REGISTRO TIPO "31" - Registro: 31 - "Produto-local da DCI Individual - PI Sem PPB"
			
			nTamLin := 2
			cLin    := Space(nTamLin)+cEOL
			cDados  := ""
			
			cDados := "31"																	//| 001 | 002 |    02   | CD-TIPO-REGISTRO
			cDados += "000"                                                               	//| 003 | 005 |    03   | Preencher com 3 zeros
			cDados += SD2->D2_COD                                                          	//| 006 | 020 |    15   | Informar o código do controle interno do produto.
			_cDescProd := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_X_COMP")
			cDados += Substr(Alltrim(_cDescProd)+Space(45-Len(Alltrim(_cDescProd))),1,45)	//| 021 | 065 |    45   | Informar a descrição do produto.
			_cUM := Space(20)
            _cUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_UM,SD2->D2_SEGUM)
			Do Case
				Case _cUni == "PC"
					_cUM := "PEÇA                "
				Case _cUni == "KG"
					_cUM := "KILO GRAMA          "
				Case _cUni == "M2"
					_cUM := "METRO QUADRADO      "
			EndCase
			cDados += _cUM                                                                 	//| 066 | 085 |    20   | Unidade de medida comercializada na internação do produto
			_cNCM      := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_POSIPI")
			cDados += Alltrim(_cNCM)                                              			//| 086 | 093 |    08   | Código NCM do produto
			cDados += Replicate("0",14)                                      				//| 094 | 107 |    14   | Preencher com 14 zeros 
			cDados += Replicate("0",20) 							           				//| 108 | 127 |    20   | Preencher com 20 zeros 
			cDados += "1"								     								//| 128 | 128 |    01   | 1
                   _nQtdUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_QUANT,SD2->D2_QTSEGUM)
			cDados += StrTran(StrZero(_nQtdUni,15,5),".","")    	          				//| 129 | 142 |    14   | Se CD-LOCAL-DESTINO = 1, informar a quantidade internada do produto para esse destino, na unidade de medida do produto. Caso contrário, preencher 14 zeros.
			cDados += "2"								     								//| 143 | 143 |    01   | 2
                   _nQtdUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_QUANT,SD2->D2_QTSEGUM)
			cDados += StrTran(StrZero(_nQtdUni,15,5),".","") 	             				//| 144 | 157 |    14   | Se CD-LOCAL-DESTINO = 2, informar a quantidade internada do produto para esse destino, na unidade de medida do produto. Caso contrário, preencher 14 zeros.
			cDados += "3"                                    								//| 158 | 158 |    01   | 3
                   _nQtdUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_QUANT,SD2->D2_QTSEGUM)
			cDados += StrTran(StrZero(_nQtdUni,15,5),".","")      	        				//| 159 | 172 |    14   | Se CD-LOCAL-DESTINO = 3, informar a quantidade internada do produto para esse destino, na unidade de medida do produto. Caso contrário, preencher 14 zeros.
			cDados += "4"                                    								//| 173 | 173 |    01   | "4"
                   _nQtdUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_QUANT,SD2->D2_QTSEGUM)
			cDados += StrTran(StrZero(_nQtdUni,15,5),".","")	              				//| 174 | 187 |    14   | Se CD-LOCAL-DESTINO = 4, informar a quantidade internada do produto para esse destino, na unidade de medida do produto. Caso contrário, preencher 14 zeros.
			
			cLin := Stuff(cLin,01,02,cDados)
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo em ITENS REGISTRO TIPO 31. Continua?","Atencao!")
				  lTudOk := .F.
				Endif
			Endif
			nTotReg += 1

		ElseIf _cTipo_PI == "2"
		
			// REGISTRO TIPO "41" - Registro: 41 - "Item da DCI Individual - 100% Nacional"

			nTamLin := 2
			cLin    := Space(nTamLin)+cEOL
			cDados  := ""
			
			cDados := "41"																	//| 001 | 002 |    02   | CD-TIPO-REGISTRO
			cDados += "000"					          		                            	//| 003 | 005 |    03   | Preencher com 3 zeros
			_cNCM      := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_POSIPI")
			cDados += Alltrim(_cNCM)                                              			//| 006 | 013 |    08   | Código NCM do produto
			cDados += SD2->D2_COD                                                          	//| 014 | 028 |    15   | Informar o código do controle interno do produto.
			_cDescProd := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_X_COMP")
			cDados += Substr(Alltrim(_cDescProd)+Space(45-Len(Alltrim(_cDescProd))),1,45)   //| 029 | 073 |    45   | Informar a descrição do produto.
			_cUM := Space(20)
                   _cUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_UM,SD2->D2_SEGUM)
			Do Case
				Case _cUni == "PC"
					_cUM := "PEÇA                "
				Case _cUni == "KG"
					_cUM := "KILO GRAMA          "
				Case _cUni == "M2"
					_cUM := "METRO QUADRADO      "
			EndCase
			cDados += _cUM                                                                 	//| 074 | 093 |    20   | Unidade de medida comercializada na internação do produto
			cDados += "00000000000000"   //FILLER  				            				//| 094 | 107 |    14   | Preencher com 14 zeros
			cDados += "00000000000000"   //FILLER				            				//| 108 | 121 |    14   | Preencher com 14 zeros
			cDados += Replicate("0",20)							            				//| 122 | 141 |    20   | Preencher com 20 zeros
			cDados += StrTran(StrZero(SD2->D2_TOTAL ,16,5),".","")            				//| 142 | 156 |    15   | Valor total do produto internado.
                   _nQtdUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_QUANT,SD2->D2_QTSEGUM)
			cDados += StrTran(StrZero(_nQtdUni,15,5),".","")	            				//| 157 | 170 |    14   | Quantidade do Produto internado, na mesma unidade de comercialização utilizada na Nota Fiscal de Saída de sua internação (NM-UNID-MED-NFS).
                   _nQtdUni := IIF(SD2->D2_QTSEGUM == 0,SD2->D2_QUANT,SD2->D2_QTSEGUM)
			cDados += StrTran(StrZero(_nQtdUni,15,5),".","")	            				//| 171 | 184 |    14   | Quantidade total do produto, na unidade estatística da NCM do produto.

			cLin := Stuff(cLin,01,02,cDados)
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo em ITENS REGISTRO TIPO 31. Continua?","Atencao!")
				  lTudOk := .F.
				Endif
			Endif
			nTotReg += 1

		Endif

		// Registro: 32 - "Matriz Produto x Insumo do Item da DCI Individual - PI Sem PPB"
		// Registro: 33 - "Insumo do produto-local da DCI Individual - PI Sem PPB"
		// Registro: 34 - "Nota Fiscal de Aquisição / Insumo do produto-local da DCI Individual - PI s/PPB"
		// Registro: 35 - "DI / Insumo do produto-local da DCI Individual - PI s/PPB"
		// Registro: 36 - "DSI / Insumo do produto-local da DCI Individual - PI s/PPB"
		
		SD2->(DbSkip())
		
	Enddo

	SF2->(DbSkip())
	
Enddo

fClose(nHdl)

Return

**** Fim envio


//+-----------------------------------------------------------------------------------//
//|Funcao....: ColZeroDCI()
//|Descricao.: Localiza diretório de gravação
//|Observação:
//+-----------------------------------------------------------------------------------//
*----------------------------------------------*
Static Function ColZeroDCI(nValr,nTama,nDeci,cPic)
*----------------------------------------------*

Local nVal := 0
Local nVirg

nVal := Round(nValr,nDeci)
nVal := Transform(nVal,cPic)
nVal := StrZero(0,nTama-Len(Alltrim(nVal)))+Alltrim(nVal)

nVirg := AT(",",nVal)
nVal  := SubStr(nVal,1,(nVirg-1))+"."+SubStr(nVal,(nVirg+1),Len(nVal))

Return(nVal)

//+-----------------------------------------------------------------------------------//
//| Fim do Programa DCI_ENVIO.PRW
//+-----------------------------------------------------------------------------------//