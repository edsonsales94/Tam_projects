#include "protheus.ch"
#DEFINE MASCARA_DATA  "@R 9999-99-99"   
#DEFINE MASCARA_TEXTO "@!"    
#DEFINE MASCARA_NUM   "@E 99999999999.99"   
/*_______________________________________________________________________________________
¦Programa   ¦  PLFATP01             ¦ Autor ¦ Ulisses Junior       ¦ Data ¦ 27/09/2010 ¦
+-----------+-----------------------+-------+----------------------+------+------------+
¦ Descriçäo ¦ Constroi o XML para integração com o Software da Suframa WS Sinal.       ¦
+-----------+--------------------------------------------------------------------------+
¦ Parametro ¦ Descricao                                                                ¦
+-----------+---+----------------------------------------------------------------------+
¦ nReg          ¦ Chave de Posicionamento no arquivo de Cliente (Numero do Registro)   ¦
¦ xTipoXML      ¦ Escrita para cadastro (1-Escrita / 2-Consulta) - 1 valor Default     ¦
¦ xTipoConsulta ¦ Caso seja Consulta (1-Cartao / 2-CPF) - 1 valor Default              ¦
¦               ¦                                                                      ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PlFatP01(nReg,xTipoXML,xTipoConsulta)
	Local aArea    := GetArea()
	Local cPerg		:= "FATP01"
	Local cXML     := ""
	Local cCgcT		:= ""
	Local cFileSend:= "", lResp
	Local cChar    := chr(13)+ chr(10)

	ValidPerg(cPerg)
	If Pergunte(cPerg, .T.)

		GeraArq()

		If !Wrk->(Eof())
			Set Century On

			SA1->(dbSetOrder(1))
			SA4->(dbSetOrder(1))
			SF2->(dbSetOrder(1))
			SX5->(dbSetOrder(1))

			SA1->(dbSeek(xFilial("SA1")+Wrk->F2_CLIENTE+Wrk->F2_LOJA))
			SX5->(dbSeek(xFilial("SX5")+"Z3"+"01"))

			cNumLote := Alltrim(SX5->X5_DESCRI)

			If Right(cNumLote,4) == StrZero(month(ddatabase),2)+Right(Str(Year(ddatabase)),2)
				cNumAux := Soma1(Left(cNumLote,5),5)
				cNumLote := cNumAux+StrZero(month(ddatabase),2)+Right(Str(Year(ddatabase)),2)
			Else
				cNumLote := "00001"+StrZero(month(ddatabase),2)+Right(Str(Year(ddatabase)),2)
			EndIf

			If SA4->(dbSeek(xFilial("SA1")+Wrk->F2_TRANSP))
				//cCgcT		:= If(!Empty(SA4->A4_CGC),u_PlFatP1a(SA4->A4_CGC,PicPes("J")),"")
				cCgcT		:= SA4->A4_CGC
			EndIf

			nTNotas := 0
			While !Wrk->(Eof())
				nTNotas++
				Wrk->(dbSkip())
			End

			Wrk->(dbGoTop())

			cXML     := '<?xml version="1.0" encoding="UTF-8" ?>' + cChar
			cXML     += '<lote nro="'+cNumLote+'" versao_sw="'+mv_par01+'" dtEmissao="'+dtoc(ddatabase)+'" >' + cChar
			//cXML     += '<cnpjDestinatario>'+Left(u_PlFatP1a(SA1->A1_CGC,PicPes(SA1->A1_PESSOA)),18)+'</cnpjDestinatario>'  + cChar
			cXML     += '<cnpjDestinatario>'+Alltrim(SA1->A1_CGC)+'</cnpjDestinatario>'  + cChar
			cXML     += '<cnpjTransp>'+Left(cCgcT,18)+'</cnpjTransp>' + cChar
			cXML     += '<inscSufDestinatario>'+Alltrim(SA1->A1_SUFRAMA)+'</inscSufDestinatario>' + cChar
			cXML     += '<ufDestino>'+SA1->A1_EST+'</ufDestino>' + cChar
			cXML     += '<ufOrigem>'+SM0->M0_ESTENT+'</ufOrigem>' + cChar
			cXML     += '<qtdeNF>'+StrZero(nTNotas,2)+'</qtdeNF>' + cChar
			cXML     += '<notasFiscais>' + cChar

			ProcRegua(nTNotas)

			While !Wrk->(Eof())

				IncProc()

				cXML     += '<notaFiscal chaveAcesso="'+Wrk->F2_CHVNFE+'" txZero="false" />' + cChar

				If SF2->(dbSeek(xFilial("SF2")+Wrk->F2_DOC+Wrk->F2_SERIE))
					RecLock("SF2",.F.)
					SF2->F2_XSINAL := 'S'
					SF2->(MsUnLock())
				EndIf

				Wrk->(dbSkip())
			End

			cXML     += '</notasFiscais>' + cChar
			cXML     += '</lote>' + cChar

			cFileSend := Alltrim(mv_par02)
			cFileSend += If(Right(cFileSend,1) == "\","","\")+"Lote"+cNumLote+".Sin"
			lResp:= u_PlFatP1b(cFileSend,cXML)

			RecLock("SX5",.F.)
			SX5->X5_DESCRI := cNumLote
			SX5->X5_DESCSPA:= cNumLote
			SX5->X5_DESCENG:= cNumLote
			SX5->(MsUnLock())

			Set Century Off

		Else
			Alert("Nao ha informacoes a gerar com dados utilizados!!")	
		EndIf

		If lResp
			Alert("Arquivo do lote "+cNumLote+" gerado com sucesso!!" )
		EndIf

		Wrk->(dbCloseArea())
	EndIf

	RestArea(aArea)

Return

/*_______________________________________________________________________________________
¦ Programa  ¦  PlFatP1a             ¦ Autor ¦ Ulisses Junior       ¦ Data ¦ 27/09/2010 ¦
+-----------+-----------------------+-------+----------------------+------+------------+
¦ Descriçäo ¦ Transformacao dos dados em modelos validos para o XML.                   ¦
+-----------+--------------------------------------------------------------------------+
¦ Parametro ¦ Descricao                                                                ¦
+-----------+--------------------------------------------------------------------------+
¦ xDado     ¦ Contem a informacao a ser transformada para o XML                        ¦
¦ cMask     ¦ Formato para resultado da transformacao da informacao                    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PlFatP1a(xDado,cMask,cCharOld,cCharNew)
	Local xRet := ""

	If ValType(xDado) == "C"
		If !Empty(xDado)
			cMask := If(cMask == nil , MASCARA_TEXTO, cMask)
			xDado := StrTran(StrTran(Alltrim(xDado),"\", " "),"/"," ")
			xRet  := EnCodeUtf8(NoAcento(If(cCharOld == Nil,Transform(xDado, cMask),StrTran(xDado,cCharOld,cCharNew))))
		EndIf
	ElseIf ValType(xDado) == "D"
		If !Empty(xDado)
			xRet := Transform(DTOS(xDado), MASCARA_DATA)
		EndIf
	ElseIf ValType(xDado) == "N"
		If xDado == 0
			xRet := "0"
		Else
			cMask:= If(cMask == Nil,MASCARA_NUM,cMask)
			xRet := Transform(xDado, cMask)
		EndIf
	EndIf

Return Alltrim(xRet)

/*________________________________________________________________________________________
¦ Programa  ¦  PlFatP1b             ¦ Autor ¦ Ulisses Junior       ¦ Data ¦ 27/09/2010 ¦  
+-----------+-----------------------+-------+----------------------+------+------------+  
¦ Descriçäo ¦ Gravacao do XML para publicação na pasta definida pela marka             ¦  
+-----------+--------------------------------------------------------------------------+  
¦ Parametro ¦ Descricao                                                                ¦  
+-----------+---+----------------------------------------------------------------------+  
¦ cFileName     ¦ Nome do arquivo para gravaçao                                        ¦  
¦ cXML          ¦ String contendo o XML  a ser gravado                                 ¦  
¦ lMens         ¦ Exibição da mensagem                                                 ¦  
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PlFatP1b(cFileName,cXML,lMens)
	Local nHdl  := NIL  // Handle para abertura do arquivo
	Local cXML  := If(cXML == nil,"",cXML)

	lMens := If( lMens == Nil , .T., lMens)

	If !Empty(cXML)   // Se não for vazio
		If !File(cFileName)
			nHdl:=FCREATE(cFileName,0)
			If FERROR() != 0
				If lMens
					ALERT("Erro na criação do arquivo XML: "+LTrim(Str(FERROR())))
				Endif
				Return
			Endif
		Else
			FClose(nHdl)  // Fecha o arquivo
			nHdl:=FERASE(cFileName)
			nHdl:=FCREATE(cFileName,0)
			If FERROR() != 0
				If lMens
					ALERT("Erro na criação do arquivo XML: "+LTrim(Str(FERROR())))
				Endif
				Return
			Endif
		Endif
		FWrite(nHdl,cXML)
		FClose(nHdl) // Fecha o arquivo
	Endif

Return lMens

/*_______________________________________________________________________________________
¦Programa   ¦  GeraArq              ¦ Autor ¦ Ulisses Junior       ¦ Data ¦ 27/09/2010 ¦
+-----------+-----------------------+-------+----------------------+------+------------+
¦ Descriçäo ¦ Arquivo temporário com dados para XML.                                   ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function GeraArq()
	Local cWhere := ""

	cWhere := "%"
	If mv_par05 == 1
		cWhere += " F2_XSINAL <> 'S' AND " 
	EndIf

	If mv_par06 == 2
		cWhere += " F2_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"' AND "
	EndIf
	cWhere +="%"

	BeginSql Alias "Wrk"
		SELECT * FROM %Table:SF2% SF2
		WHERE SF2.%NotDel% AND 
		F2_FILIAL = %xFilial:SF2% AND
		%Exp:cWhere%
		F2_CLIENTE = %Exp:mv_par03% AND
		F2_LOJA = %Exp:mv_par04% AND
		F2_CHVNFE <> %Exp:Space(TamSx3("F2_CHVNFE")[1])%
		ORDER BY F2_CLIENTE, F2_LOJA
	EndSql

Return

/*_______________________________________________________________________________________
¦Programa   ¦  ValidPerg            ¦ Autor ¦ Ulisses Junior       ¦ Data ¦ 27/09/2010 ¦
+-----------+-----------------------+-------+----------------------+------+------------+
¦ Descriçäo ¦ Criação do grupo de perguntas da rotina.                                 ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function  ValidPerg(cPerg)
	PutSX1(cPerg,"01",PADR("Versão do Sinal"			,22)+"?","","","mv_ch1","C",03,0,0,"G","","","","","mv_par01")
	PutSX1(cPerg,"02",PADR("Salvar em		"			,22)+"?","","","mv_ch2","C",040,0,0,"G","","","","","mv_par02")
	PutSX1(cPerg,"03",PADR("Cliente			"			,22)+"?","","","mv_ch3","C",06,0,0,"G","","SA1","","","mv_par03")
	PutSX1(cPerg,"04",PADR("Loja				"			,22)+"?","","","mv_ch4","C",02,0,0,"G","","","","","mv_par04")
	PutSX1(cPerg,"05",PADR("Gera				"			,22)+"?","","","mv_ch5","N",01,0,0,"C","","","","","mv_par05","Nao transmitidas",,,,"Todas")
	PutSX1(cPerg,"06",PADR("Cons. periodo abaixo"	,22)+"?","","","mv_ch6","N",01,0,0,"C","","","","","mv_par06","Nao",,,,"Sim")
	PutSX1(cPerg,"07",PADR("Da Emissao		"			,22)+"?","","","mv_ch7","D",08,0,0,"G","","","","","mv_par07")
	PutSX1(cPerg,"08",PADR("Ate a Emissao	"			,22)+"?","","","mv_ch8","D",08,0,0,"G","","","","","mv_par08")
Return
