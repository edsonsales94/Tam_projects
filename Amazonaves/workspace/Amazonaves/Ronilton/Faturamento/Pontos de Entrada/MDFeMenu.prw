#Include "Protheus.ch"

#DEFINE nPercAlt 			2.5
#DEFINE TAMMAXXML 			400000 //- Tamanho maximo do XML em bytes
#DEFINE QTDMAXNF 			9999 //- Tamanho maximo do XML em bytes
#DEFINE ENTER 				CHR(10)+CHR(13)
#DEFINE NAO_TRANSMITIDO 	'2'
#DEFINE AUTORIZADO			'3'
#DEFINE NAO_AUTORIZADO		'4'

static oHChvsNFE			:= nil //Hash para controlar as chaves versus o que esta nos cod. municipo descarregamento
static oHRecnoTRB			:= nil //Hash para controlar as notas presentes na grid

/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Programa  ¦ MDFeMenu   ¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 26/08/2024 ¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para adicionar novos botoes na rotina          ¦¦¦
¦¦+-----------+-----------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MDFeMenu()
	Local aRotina := ParamIXB[1]
	
	oHRecnoTRB 	:= THashMap():New()
	oHChvsNFE 	:= THashMap():New()
	
	Aadd(aRotina,{ "Visalizar (Amazonaves)"  ,"u_AMVisualizar",0,2,0 ,NIL} )
	Aadd(aRotina,{ "Excluir (Amazonaves)"  ,"u_AMExcluir",0,5,0 ,NIL} )

Return aRotina

//----------------------------------------------------------------------
/*/{Protheus.doc} MDFeVisual
Montagem da Dialog de visualização de um MDFe ja criado

@author Natalia Sartori
@since 10/02/2014
@version P11
@Return
/*/
//-----------------------------------------------------------------------
User Function AMVisualizar(cAlias, nReg, nOpc)
	//Antes de chamar a rotina de pintura de tela, define o conteudo das variaveis private
	MsgRun("Por favor aguarde, carregando informações do MDF-e...","Aguarde", {|| LoadVarsByCC0(nOpc) })
	MDFeShowDlg(nOpc)
	ResetVars()
Return

//----------------------------------------------------------------------
/*/{Protheus.doc} MDFeExclui
Montagem da Dialog de exclusão do MDFe

@author Natalia Sartori
@since 10/02/2014
@version P11

@param
@Return
/*/
//-----------------------------------------------------------------------
User Function AMExcluir(cAlias, nReg, nOpc)

	If CC0->CC0_STATUS == NAO_TRANSMITIDO .or. CC0->CC0_STATUS == NAO_AUTORIZADO
		//Antes de chamar a rotina de pintura de tela, define o conteudo das variaveis private
		MsgRun("Por favor aguarde, carregando informações do MDF-e...","Aguarde",{|| LoadVarsByCC0( 5 /*nOpc*/)  })
		//Chama a funcao que faz a pintura de tela, a partir das variaveis vazias
		MDFeShowDlg( 5 /*nOpc*/)
	  	//Antes de chamar a rotina de pintura de tela, define o conteudo das variaveis private
		ResetVars()
	Else
		MsgInfo("Opcao nao disponivel de acordo com o status do documento.")
		
	Endif
Return

//----------------------------------------------------------------------
/*/{Protheus.doc} LoadVarsByCC0
Carrega as variais private a partir do registro selecionado na CC0 e
do XML

@author Natalia Sartori
@since 10/02/2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function LoadVarsByCC0(nOpc)
	Local oXML		:= Nil
	Local oInfFsc	:= NIl
	Local oInfCpl	:= Nil
	Local aLacres	:= {}
	Local aMunCar	:= {}
	Local aPerc		:= {}
	Local aMunNfe	:= {}
	local aInfCTe	:= {}
	Local nI		:= 1
	Local nJ		:= 1
	Local cError	:= ""
	Local cWarning	:= ""
	Local cEstCod	:= ""
	Local cMunCod	:= ""
	Local cMunDesc	:= ""
	Local cCIOT 	:= ""
	Local cContrat	:= ""
	local cIndice	:= ""
	local cCgc		:= ""
	local cTpValePed:= ""
	local cNumCompra:= ""
	
	Private lMDFePost	:= CC0->(ColumnPos("CC0_CARPST")) > 0 .And. CC0->(ColumnPos("CC0_VINCUL")) > 0 .And. !UsaColaboracao("5") //MDF-e Carrega Posterior
	Private lMotori	:= CC0->(ColumnPos("CC0_MOTORI")) > 0
	Private lModal	:= CC0->(ColumnPos("CC0_MODAL")) > 0
	
	Private aCNPJ	:= {}
	Private aCiot	:= {}
	private aValPed	:= {}
	private oProdPre:= nil
	private oModalA := nil

	cursorWait()

	cSerMDF		:= CC0->CC0_SERMDF
	cNumMDF		:= CC0->CC0_NUMMDF
	cUFCarr		:= CC0->CC0_UFINI
	cUFDesc		:= CC0->CC0_UFFIM
	cUFCarrAux	:= cUFCarr
	cUFDescAux	:= cUFDesc
	cVTotal		:= CC0->CC0_VTOTAL
	cVeiculo	:= CC0->CC0_VEICUL
	cVeiculoAux	:= cVeiculo
	nQtNFe		:= CC0->CC0_QTDNFE
	nVTotal		:= CC0->CC0_VTOTAL
	nPBruto		:= CC0->CC0_PESOB
	cVVTpCarga	:= ""
	cPPcProd	:= space( getSx3Cache( "B1_COD", "X3_TAMANHO") ) // CriaVar("B1_COD")
	cPPxProd	:= space( getSx3Cache( "B1_DESC", "X3_TAMANHO") ) // CriaVar("B1_DESC")
	cPPCodbar	:= space( getSx3Cache( "B1_CODBAR", "X3_TAMANHO") ) // CriaVar("B1_CODBAR")
	cPPNCM		:= space( getSx3Cache( "B1_POSIPI", "X3_TAMANHO") ) // CriaVar("B1_POSIPI")
	cPPCEPCarr	:= space( getSx3Cache( "A1_CEP", "X3_TAMANHO") ) // CriaVar("A1_CEP")
	cPPCEPDesc	:= space( getSx3Cache( "A1_CEP", "X3_TAMANHO") ) // CriaVar("A1_CEP")
	cMotorista  := ""

	If lMotori
		cMotorista  := CC0->CC0_MOTORI
	EndIf
	If lMDFePost
		cPoster  := IIF(CC0->CC0_CARPST =='1',"1-Sim","2-Não")
	EndIf
	oXML		:= XmlParser(CC0->CC0_XMLMDF,"",@cError,@cWarning)
	nRQtNFe		:= nQtNFe
	nRVTotal	:= nVTotal
	nRPBruto	:= nPBruto
	cNfeFil		:= iif( nOpc <> 3 .and. !empty(alltrim(CC0->CC0_CODRET)) .and. alltrim(CC0->CC0_CODRET) == "1", "1-Sim", "2-Não")
    
	If lModal
		cModal		:= if( empty(alltrim(CC0->CC0_MODAL)) .or. alltrim(CC0->CC0_MODAL) == "1", '1-Rodoviário','2-Aéreo')
	EndIf
   	
	If ValType(oXML) == "O"
		aMunNfe		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFDOC:_INFMUNDESCARGA")
		oProdPre	:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_PRODPRED")
		oInfCpl		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFADIC:_INFCPL")
		oInfFsc		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFADIC:_INFADFISCO")
		aLacres		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_LACRES")
		aCNPJ		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_AUTXML")
		aMunCar		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_IDE:_INFMUNCARREGA")
	    aPerc		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_IDE:_INFPERCURSO")
		aCiot		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_INFCIOT")
		aValPed		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_VALEPED:_DISP")
		aPgtos		:= GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_INFPAG")
		oModalA     := GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFMODAL:_AEREO")

	    //Monta o texto de informacoes complementares
	    If ValType(oInfCpl) == "O"
		    cInfCpl := Padr(oInfCpl:TEXT,5000)
		EndIf

		//Monta o texto de informacoes complementares
	    If ValType(oInfFsc) == "O"
		    cInfFsc := Padr(oInfFsc:TEXT,2000)
		EndIf

		//Produto Predominante carregando dados
		if valType(oProdPre) == "O"
			cVVTpCarga	:= iif(type("oProdPre:_TPCARGA")=="O",oProdPre:_TPCARGA:TEXT,cVVTpCarga)
			if !empty(cVVTpCarga)
				atpItens := tpCargaIt()
				aEval( atpItens, {|x| iif(subStr(x,1,2) == cVVTpCarga, cVVTpCarga := x, nil)  })
			endIf
			cPPxProd	:= padr(iif(type("oProdPre:_XPROD")=="O",oProdPre:_XPROD:TEXT,cPPxProd),tamsx3("B1_DESC")[1])
			cPPCodbar	:= padr(iif(type("oProdPre:_CEAN")=="O",oProdPre:_CEAN:TEXT,cPPCodbar),tamsx3("B1_CODBAR")[1])
			cPPNCM		:= padr(iif(type("oProdPre:_NCM")=="O",oProdPre:_NCM:TEXT,cPPNCM),tamsx3("B1_POSIPI")[1])
			cPPCEPCarr	:= padr(iif(type("oProdPre:_INFLOTACAO:_INFLOCALCARREGA:_CEP")=="O",oProdPre:_INFLOTACAO:_INFLOCALCARREGA:_CEP:TEXT,cPPCEPCarr),tamsx3("A1_CEP")[1])
			cPPCEPDesc	:= padr(iif(type("oProdPre:_INFLOTACAO:_INFLOCALDESCARREGA:_CEP")=="O",oProdPre:_INFLOTACAO:_INFLOCALDESCARREGA:_CEP:TEXT,cPPCEPDesc),tamsx3("A1_CEP")[1])
		endIf
          
		If lModal .and.  valType(oModalA) == "O"
			cNumVoo   	:= iif(type("oModalA:_NVOO")=="O",oModalA:_NVOO:TEXT,cNumVoo)
		  	dDatVoo     := iif(type("oModalA:_DVOO")=="O",sToD(strTran(oModalA:_DVOO:TEXT,"-","")),dDatVoo)
		  	cAerOrig    := iif(type("oModalA:_CAEREMB")=="O",oModalA:_CAEREMB:TEXT,cAerOrig)
		    cAerDest    := iif(type("oModalA:_CAERDES")=="O",oModalA:_CAERDES:TEXT,cAerDest)
		endIf

	   	//Monta o array (aCols) de lacres
	   	aColsLacre := {}
	   	If ValType(aLacres) <> "U"
		   	If ValType(aLacres) == "A"
			   	For nI := 1 to len(aLacres)
			   		aAdd(aColsLacre,{aLacres[nI]:_nLACRE:TEXT,.F.})
			   	Next nI
			ElseIf !Empty(aLacres:_nlacre:TEXT)
				aAdd(aColsLacre,{aLacres:_nLACRE:TEXT,.F.})
			Else
				aColsLacre := GetNewLine(aHeadLacre)
			EndIf
		EndIf

	   	//Monta o array de CNPJs/CPF Autorizados
	   	aColsAuto := {}
	   	If ValType(aCNPJ) <> "U"
		   	If ValType(aCNPJ) == "A"
			   	For nI := 1 to len(aCNPJ)
				   cIndice := allTrim(Str(nI))
			   		If mdfeType("aCNPJ["+cIndice+"]:_CPF") <> "U"
						aAdd(aColsAuto,{aCNPJ[nI]:_CPF:TEXT,.F.})
					EndIf

					If mdfeType("aCNPJ["+cIndice+"]:_CNPJ") <> "U"
						aAdd(aColsAuto,{aCNPJ[nI]:_CNPJ:TEXT,.F.})
					EndIf
			   	Next nI
			ElseIf Type("aCNPJ:_CPF") <> "U" .and. !Empty(aCNPJ:_CPF:TEXT)
				aAdd(aColsAuto,{aCNPJ:_CPF:TEXT,.F.})
			ElseIf Type("aCNPJ:_CNPJ") <> "U" .and. !Empty(aCNPJ:_CNPJ:TEXT)
				aAdd(aColsAuto,{aCNPJ:_CNPJ:TEXT,.F.})
			Else
				aColsAuto := GetNewLine(aHeadAuto)
			EndIf
		EndIf

		//Monta o array de Municipios de Carregamento
		aColsMun := {}
	   	If ValType(aMunCar) <> "U"
	   		If ValType(aMunCar) == "A"
				For nI := 1 to len(aMunCar)
					aAdd(aColsMun,{Iif(Empty(substr(aMunCar[ nI ]:_CMUNCARREGA:TEXT,3,len(aMunCar[ nI ]:_CMUNCARREGA:TEXT))),Space(TamSx3('CC2_CODMUN')[1]),substr(aMunCar[ nI ]:_CMUNCARREGA:TEXT,3,len(aMunCar[ nI ]:_CMUNCARREGA:TEXT))),GetUfSig(substr(aMunCar[ nI ]:_CMUNCARREGA:TEXT,1,2)),aMunCar[ nI ]:_XMUNCARREGA:TEXT,.F.})
				Next nI
			ElseIf !Empty(aMunCar:_CMUNCARREGA:TEXT)
				aAdd(aColsMun,{Iif(Empty(substr(aMunCar:_CMUNCARREGA:TEXT,3,len(aMunCar:_CMUNCARREGA:TEXT))),Space(TamSx3('CC2_CODMUN')[1]),substr(aMunCar:_CMUNCARREGA:TEXT,3,len(aMunCar:_CMUNCARREGA:TEXT))),GetUfSig(substr(aMunCar:_CMUNCARREGA:TEXT,1,2)),aMunCar:_XMUNCARREGA:TEXT,.F.})
			Else
				aColsMun := GetNewLine(aHeadMun)
			EndIf
		EndIf

		//Monta o array de percurso
		aColsPerc := {}
	   	If ValType(aPerc) <> "U"
		   	If ValType(aPerc) == "A"
			   	For nI := 1 to len(aPerc)
			   		aAdd(aColsPerc,{aPerc[nI]:_UFPER:TEXT,.F.})
			   	Next nI
			ElseIf !Empty(aPerc:_UFPER:TEXT)
		   		aAdd(aColsPerc,{aPerc:_UFPER:TEXT,.F.})
		 	Else
		 		aColsPerc := GetNewLine(aHeadPerc)
			EndIf
		EndIf

		//Por fim pega todas as Chaves de NFe e atualiza os municipios dentro do TRB
		If valType(aMunNfe) <> "U"
			If valType(aMunNfe) == "O"
				aMunNfe := {aMunNfe}
			endIf

			If lMDFePost .And. SubStr(cPoster,1,1) == "1"
				for nI := 1 to len(aMunNfe)
					if !empty(aMunNFe[nI]:_CMUNDESCARGA:TEXT)
						cEstCod	:= substr(aMunNFe[nI]:_CMUNDESCARGA:TEXT,1,2)
		    			cMunCod	:= substr(aMunNFe[nI]:_CMUNDESCARGA:TEXT,3,len(aMunNFe[nI]:_CMUNDESCARGA:TEXT))
		    			cMunDesc:= aMunNFe[nI]:_XMUNDESCARGA:TEXT
						exit
					endIf
				next nI

			else
				For nI := 1 to len(aMunNfe)
					//Pego o nome e o codigo do municipio
					cEstCod := substr(aMunNFe[nI]:_CMUNDESCARGA:TEXT,1,2)
					cMunCod := substr(aMunNFe[nI]:_CMUNDESCARGA:TEXT,3,len(aMunNFe[nI]:_CMUNDESCARGA:TEXT))
					cMunDesc := aMunNFe[nI]:_XMUNDESCARGA:TEXT
					aInfCTe := aMunNFe[nI]:_INFCTE
					If valType(aInfCTe) == "O"
						aInfCTe := {aInfCTe}
					endIf
					//Pego  todas as notas deste municipio
					For nJ := 1 to len(aInfCTe)
						oHChvsNFE:Set(allTrim(aInfCTe[nJ]:_CHCTE:TEXT), "#_"+cEstCod+"#_"+cMunCod+"#_"+cMunDesc)
					Next nJ
				Next nI
			endIf
		EndIf

		//Monta o array de percurso
		aColsCiot := {}
	   	If ValType(aCiot) <> "U"
		   	If ValType(aCiot) == "A"
			   	For nI := 1 to len(aCiot)
				   	cIndice := allTrim(Str(nI))
					cCIOT := aCiot[nI]:_CIOT:TEXT
					cContrat := ""
					if mdfeType("aCiot["+cIndice+"]:_CNPJ") <> "U"
						cContrat := aCiot[nI]:_CNPJ:TEXT
					elseIf mdfeType("aCiot["+cIndice+"]:_CPF") <> "U"
						cContrat := aCiot[nI]:_CPF:TEXT
					endif
			   		aAdd(aColsCiot,{cCIOT,FormatCpo("CGC",cContrat),.F.})
			   	Next nI
			Else
				cCIOT := aCiot:_CIOT:TEXT
				cContrat := ""
				if mdfeType("aCiot:_CNPJ") <> "U"
					cContrat := aCiot:_CNPJ:TEXT
				elseif mdfeType("aCiot:_CPF") <> "U"
					cContrat := aCiot:_CPF:TEXT
				endif
				aAdd(aColsCiot,{cCIOT,FormatCpo("CGC",cContrat),.F.})
			EndIf
		EndIf
		If Len(aColsCiot) == 0
			aColsCiot := GetNewLine(aHeadCiot, .T.)
		EndIf

		If ValType(aPgtos) <> "U" .and. type("oDlgPgt") == "O"
			If ValType(aPgtos) <> "A"
				aPgtos := {aPgtos}
			EndIf
			oDlgPgt:setInfPag(aPgtos)
		EndIf

		//Vale-pedagio
		aColsValPed := {}
		If type("aValPed") <> "U"
			aValPed := iif(type("aValPed")=="A",aValPed,{aValPed})

			for nI := 1 to len(aValPed)
				cIndice		:= allTrim(Str(nI))
				cCgc 		:= Padr("",15)
				cNumCompra	:= Padr("",20)
				cTpValePed	:= " "

				if mdfeType("aValPed[" + cIndice + "]:_CPFPg") == "O" .and. !empty(aValPed[nI]:_CPFPg:TEXT)
					cCgc := aValPed[nI]:_CPFPg:TEXT

				elseif mdfeType("aValPed[" + cIndice + "]:_CNPJPg") == "O" .and. !empty(aValPed[nI]:_CNPJPg:TEXT)
					cCgc := aValPed[nI]:_CNPJPg:TEXT
				endIf
				
				if mdfeType("aValPed[" + cIndice + "]:_nCompra") == "O" .and. !empty(aValPed[nI]:_nCompra:TEXT)
					cNumCompra := aValPed[nI]:_nCompra:TEXT
				endIf

				if mdfeType("aValPed[" + cIndice + "]:_tpValePed") == "O" .and. !empty(aValPed[nI]:_tpValePed:TEXT)
					cTpValePed := allTrim(str(val(aValPed[nI]:_tpValePed:TEXT)))
				endIf

				aAdd(aColsValPed, {	aValPed[nI]:_CNPJForn:TEXT		,;
									FormatCpo("CGC",cCgc)			,;
									cNumCompra						,;
									val(aValPed[nI]:_vValePed:TEXT)	,;
									cTpValePed						,;
									 .F.							})
			next
		endIf
		If Len(aColsValPed) == 0
			aColsValPed := GetNewLine(aHeadValPed, .T.)
		EndIf

		//Seguro
		LoadXmlSeg(oXML)

		// Contratantes do serviço de transporte
		LoadInfCtr(oXML)
		
		//Carrega os condutores
		LoadCondutores(oXML,lMotori)

		//Carrega os reboques
		LoadReboque(oXML)

		if SubStr(cPoster,1,1) == "2" //2-Não
			LoadTRB(nOpc)
		endIf
	EndIf

	oXML 	:= fwFreeObj(oXML)
	oInfFsc := fwFreeObj(oInfFsc)
	oInfCpl := fwFreeObj(oInfCpl)
	oXML 	:= fwFreeObj(oXML)

	aLacres := fwFreeArray(aLacres)
	aMunCar := fwFreeArray(aMunCar)
	aPerc 	:= fwFreeArray(aPerc)
	aMunNfe := fwFreeArray(aMunNfe)
	aInfCTe	:= fwFreeArray(aInfCTe)
	
	cursorArrow()
	
Return

//----------------------------------------------------------------------
/*/{Protheus.doc} ResetVars
Inicializa as variaveis com valores nulos

@author Natalia Sartori
@since 10/02/2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function ResetVars()
	aHeadMun	:= GetHeaderMun()
	aHeadPerc	:= GetHeaderPerc()
	aHeadAuto	:= GetHeaderAuto()
	aHeadLacre	:= GetHeaderLacre()
	aHeadCiot	:= GetHeaderCiot()
	cNumMDF		:= Space(TamSx3('CC0_NUMMDF')[1])			//Variavel que contem o numero do MDFE
	cSerMDF		:= Space(TamSx3('CC0_SERMDF')[1])			//Variavel que contem a Serie do MDFE
	cUFCarr		:= Space(TamSx3('CC0_UFINI')[1])			//Variavel que contem a UF de Carregamento
	cUFDesc		:= Space(TamSx3('CC0_UFFIM')[1])			//Variavel que contem a UF de Descarregamento
	cUFCarrAux	:= Space(TamSx3('CC0_UFINI')[1])			//Variavel Auxiliar (para controle alteracoes) que contem a UF de Carregamento
	cUFDescAux	:= Space(TamSx3('CC0_UFFIM')[1])			//Variavel Auxiliar (para controle alteracoes) que contem a UF de Descarregamento
	cVTotal		:= Space(TamSx3('CC0_VTOTAL')[1])			//Variavel que contem o valor total da carga/mercadoria
	cVeiculo	:= Space(TamSx3('DA3_COD')[1])				//Variavel que contem o valor total da carga/mercadoria
	cVeiculoAux	:= Space(TamSx3('DA3_COD')[1])
	cCarga		:= Space(TamSx3('DAK_COD')[1])				//Variavel que contem o código da carga
	cMotorista  := iif(CC0->(ColumnPos("CC0_MOTORI")) > 0,Space(TamSx3('CC0_MOTORI')[1]),nil)			//Variavel que contem o código do motorista
	nQtNFe		:= 0										//Variavel que contem a Quantidade total de NFe
	nVTotal		:= 0										//Variavel que contem a Valor total de notas
	nPBruto		:= 0										//Variavel que contem a Peso total do MDF-e
	cInfCpl		:= ""
	cInfFsc		:= ""
	aColsMun	:= GetNewLine(aHeadMun)
	aColsPerc	:= GetNewLine(aHeadPerc)
	aColsAuto	:= GetNewLine(aHeadAuto)
	aColsLacre	:= GetNewLine(aHeadLacre)
	aColsCiot	:= GetNewLine(aHeadCiot,.T.)
	aColsValPed	:= GetNewLine(aHeadValPed,.T.)
	cVVTpCarga	:= ""
	cPPcProd	:= space( getSx3Cache( "B1_COD", "X3_TAMANHO") ) // CriaVar("B1_COD")
	cPPxProd	:= space( getSx3Cache( "B1_DESC", "X3_TAMANHO") ) // CriaVar("B1_DESC")
	cPPCodbar	:= space( getSx3Cache( "B1_CODBAR", "X3_TAMANHO") ) // CriaVar("B1_CODBAR")
	cPPNCM		:= space( getSx3Cache( "B1_POSIPI", "X3_TAMANHO") ) // CriaVar("B1_POSIPI")
	cPPCEPCarr	:= space( getSx3Cache( "A1_CEP", "X3_TAMANHO") ) // CriaVar("A1_CEP")
	cPPCEPDesc	:= space( getSx3Cache( "A1_CEP", "X3_TAMANHO") ) // CriaVar("A1_CEP")
	
	cNumVoo     := space(9)
	dDatVoo     := sToD("")
	cAerOrig    := space(4)
	cAerDest    := space(4)
	
	ClearInfPag()
	ClearInfSeg()
	ClearInfCtr()
	ClearCondutor()
	ClearReboque()

	oHRecnoTRB:Clean() //limpa recnos de nf-e incluidos na TRB
	oHChvsNFE:Clean() //limpa chaves com municipios
	oTempTable:zap() //limpa registros da tabela TRB
	aHTRBVinc := {}

	dFltDtDe	:= ctod("")
	dFltDtAte	:= dFltDtDe
	cFltDocDe	:= space(getSx3Cache("F2_DOC","X3_TAMANHO"))
	cFltDocAte	:= cFltDocDe
	cFltSeries	:= space(16)

	aMun := {}
	
Return

Static Function GetMDeInfo(oXMLStru,cNode)
	Local xRet := oXMLStru
    Local aBusca := StrTokArr(cNode,":")
    Local nI := 1

    For nI := 1 to len(aBusca)
		xRet := XmlChildEx(xRet,aBusca[nI])

		If ValType(xRet) == "U"
		     exit
		EndIf
	Next nI

Return xRet

/*/{Protheus.doc} mdfeType
Função para evitar problema com SONARQUBE

@author		Felipe Sales Martinez
@since		17.06.2021
@version	1.00
@param		cNode, string, nó a ser avaliado
@return		boolean, .T. -> nó existente / .F. -> nó não existente
/*/
static function mdfeType(cNode)
return type(cNode)

//----------------------------------------------------------------------
/*/{Protheus.doc} GetHeaderMun
Retorna um array com as colunas a serem exibidas na GetDados de Municipio
Carregamento

@author Natalia Sartori
@since 24.02.2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function GetHeaderMun()
	Local aArea	     := GetArea()
	Local aRet       := {}
	Local aCampos    := {"CC2_CODMUN","CC2_EST","CC2_MUN"}
	Local nI		 := 1

	//Posiciona no SX3
	SX3->(dbSetOrder(2))
	For nI := 1 to len(aCampos)
		If !Empty(FWSX3Util():GetFieldType( aCampos[nI]) )
			aAdd( aRet,{  TRIM(FwX3Titulo(aCampos[nI])),;
				aCampos[nI]							  ,;
				GetSx3Cache(aCampos[nI], "X3_PICTURE"),;
				GetSx3Cache(aCampos[nI], "X3_TAMANHO"),;
				GetSx3Cache(aCampos[nI], "X3_DECIMAL"),;
				iif(  aCampos[nI] == "CC2_CODMUN", "MunTrigger()", ".T."),;
				GetSx3Cache(aCampos[nI], "X3_USADO" ) ,;
				GetSx3Cache(aCampos[nI], "X3_TIPO"  ) ,;
				iif(  aCampos[nI] == "CC2_CODMUN", "CC2", GetSx3Cache(aCampos[nI], "X3_F3")),;
				GetSx3Cache(aCampos[nI], "X3_CONTEXT"),;
				GetSx3Cache(aCampos[nI], "X3_CBOX"   ),;
				GetSx3Cache(aCampos[nI], "X3_RELACAO"),;
				iif(  aCampos[nI] == "CC2_CODMUN", "MunTrigger()", ".T."),;
				GetSx3Cache(aCampos[nI], "X3_VISUAL" ),;
				GetSx3Cache(aCampos[nI], "X3_VLDUSER"),;
				GetSx3Cache(aCampos[nI], "X3_PICTVAR")})
		EndIf
	Next nI

	RestArea(aArea)
Return aRet

//----------------------------------------------------------------------
/*/{Protheus.doc} GetHeaderPerc
Retorna um array com as colunas a serem exibidas na GetDados de Percurso

@author Natalia Sartori
@since 24.02.2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function GetHeaderPerc()
	Local aArea	     := GetArea()
	Local aRet       := {}
	Local aCampos	 :=  {"CC2_EST"}
	Local nI		 := 1

	For nI := 1 to len(aCampos)
		If !Empty(FWSX3Util():GetFieldType( aCampos[nI]) )
			aAdd( aRet,{  TRIM(FwX3Titulo(aCampos[nI])),;
				aCampos[nI]							  ,;
				GetSx3Cache(aCampos[nI], "X3_PICTURE"),;
				GetSx3Cache(aCampos[nI], "X3_TAMANHO"),;
				GetSx3Cache(aCampos[nI], "X3_DECIMAL"),;
				iif(  aCampos[nI] == "CC2_EST", "ValidUfMDF(M->CC2_EST)", GetSx3Cache(aCampos[nI], "X3_VALID")),;
				GetSx3Cache(aCampos[nI], "X3_USADO" ) ,;
				GetSx3Cache(aCampos[nI], "X3_TIPO"  ) ,;
				iif(  aCampos[nI] == "CC2_EST", "12", GetSx3Cache(aCampos[nI], "X3_F3")),;
				GetSx3Cache(aCampos[nI], "X3_CONTEXT"),;
				GetSx3Cache(aCampos[nI], "X3_CBOX"   ),;
				GetSx3Cache(aCampos[nI], "X3_RELACAO"),;
				".T.",;
				GetSx3Cache(aCampos[nI], "X3_VISUAL" ),;
				GetSx3Cache(aCampos[nI], "X3_VLDUSER"),;
				GetSx3Cache(aCampos[nI], "X3_PICTVAR")})
		EndIf
	Next nI

	RestArea(aArea)
Return aRet

//----------------------------------------------------------------------
/*/{Protheus.doc} GetHeaderAuto
Retorna um array com as colunas a serem exibidas na GetDados de Autorizados

@author Natalia Sartori
@since 24.02.2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
static function GetHeaderAuto()
	local aArea	     := GetArea()
	local aRet       := {}

	aadd(aRet,{	"CNPJ/CPF",;				//X3Titulo()
				"MDFeCGC",;					//X3_CAMPO
				"@R 99.999.999/9999-99",;	//X3_PICTURE
				14,;						//X3_TAMANHO
				0,;							//X3_DECIMAL
				"",;						//X3_VALID
				"",;						//X3_USADO
				"C",;						//X3_TIPO
				"",; 						//X3_F3
				"R",;						//X3_CONTEXT
				"",;						//X3_CBOX
				"",;						//X3_RELACAO
				"",;						//X3_WHEN
				"",;						//X3_VISUAL
				"",;						//X3_VLDUSER
				"PictAuto()"})				//X3_PICTVAR
RestArea(aArea)
return aRet

//----------------------------------------------------------------------
/*/{Protheus.doc} GetHeaderLacre
Retorna um array com as colunas a serem exibidas na GetDados de Percurso

@author Natalia Sartori
@since 24.02.2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function GetHeaderLacre()
	Local aArea	     := GetArea()
	Local aRet       := {}
	Local aCampos    := {"DVB_LACRE"}
	Local nI		 := 1

	For nI := 1 to len(aCampos)
		If !Empty(FWSX3Util():GetFieldType( aCampos[nI]) )
			aAdd( aRet,{ TRIM(FwX3Titulo(aCampos[nI])),;
				aCampos[nI]							  ,;
				GetSx3Cache(aCampos[nI], "X3_PICTURE"),;
				GetSx3Cache(aCampos[nI], "X3_TAMANHO"),;
				GetSx3Cache(aCampos[nI], "X3_DECIMAL"),;
				".T.",;
				GetSx3Cache(aCampos[nI], "X3_USADO"  ),;
				GetSx3Cache(aCampos[nI], "X3_TIPO"   ),;
				GetSx3Cache(aCampos[nI], "X3_F3"     ),;
				GetSx3Cache(aCampos[nI], "X3_CONTEXT"),;
				GetSx3Cache(aCampos[nI], "X3_CBOX"   ),;
				GetSx3Cache(aCampos[nI], "X3_RELACAO"),;
				".T.",;
				GetSx3Cache(aCampos[nI], "X3_VISUAL" ),;
				GetSx3Cache(aCampos[nI], "X3_VLDUSER"),;
				GetSx3Cache(aCampos[nI], "X3_PICTVAR")})
		EndIf	
	Next nI

	RestArea(aArea)
Return aRet

//----------------------------------------------------------------------
/*/{Protheus.doc} GetHeaderCIOT
Retorna um array com as colunas a serem exibidas na GetDados de CIOT

@author Felipe Sales Martinez
@since 12.03.2020
@version P12
@Return	aRet -> Array com estrutura de campos do gride de CIOT
/*/
//-----------------------------------------------------------------------
Static Function GetHeaderCIOT()
	local aRet := {}
	aadd(aRet,{	"Numero CIOT","MdfeCiot","@R 999999999999",12,0,"VldCiot()","","C","","R","","","","","",""})
	aadd(aRet,{	"CNPJ/CPF do Contratante/Subcontratante","MdfeContr","",18,0,"VldCgc(@MdfeContr)","","C","","R","","","","","",""})
Return aRet

//----------------------------------------------------------------------
/*/{Protheus.doc} GetNewLine
Realiza o carregamento da 1 linha da aLinhas em branco na aCols

@author Natalia Sartori
@since 24.02.2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function GetNewLine(aHeader, lSemDic)
	Local aRet   := {}
	Local aArea  := getArea()
	Local nI	 := 0

	Default lSemDic := .F.

	//Cria um linha do aLinhas em branco
	aAdd(aRet, Array( Len(aHeader)+1 ) )

	For nI := 1 To Len(aHeader)
		if allTrim(upper(aHeader[nI][2])) $ "MDFECGC"
			aRet[Len(aRet),nI] := space(aHeader[nI][4])
		//elseIf lSemDic
		else
			If aHeader[nI][8] == "N" //Numericos
				aRet[Len(aRet),nI] := 0
			ElseIf aHeader[nI][8] == "D"
				aRet[Len(aRet),nI] := cTod("  /  /    ")
			Else //Caracter
				aRet[Len(aRet),nI] := space(aHeader[nI][4])
			EndIf
		//else
		//	aRet[Len(aRet),nI] := criaVar(alltrim(aHeader[nI,2]))
		endIf
	Next nI

	//Atribui .F. para a coluna que determina se alinha do aLinhas esta deletada
	aRet[Len(aRet)][Len(aHeader)+1] := .F.

	RestArea(aArea)
Return aRet

/*/{Protheus.doc} LoadXmlSeg
Carrega as informações dos dados do seguro

@return		nil
/*/
static function LoadXmlSeg(oXML)
	local oInfSeg	 := nil
	local cRespSeg	 := ""
	local cCNPJ		 := ""
	local cCPF		 := ""
	local cSeg		 := ""
	local cCNPJSeg	 := ""
	local cApolice	 := ""
	local aAverb	 := {}
	local nSeg		 := 0
	local nAverb	 := 0
	local cAverb	 := ""
	local aXmlAverb  := {}

	private aXmlSeg	  := {}

	ClearInfSeg()
	// Estrutura do array aInfSeg, é um subconjunto de:
	// <seg> 0 - n -> Informações de Seguro da Carga
	//		<infResp> 1 - 1 -> Informações do responsável pelo seguro da carga 
	//			1 <respSeg>	-> 1 - 1 -> Responsável pelo seguro - Preencher com:  1 - Emitente do MDF-e; 2 - Responsável pela contratação do serviço de transporte (contratante) 
	// 									Dados obrigatórios apenas no modal Rodoviário, depois da lei 11.442/07. Para os demais modais esta informação é opcional. 
	//			2 <CNPJ> 	-> 1 - 1 -> Número do CNPJ do responsável pelo seguro 
	//									Obrigatório apenas se responsável pelo seguro for (2) responsável pela contratação do transporte - pessoa jurídica 
	//			3 <CPF>		-> 1 - 1 -> Número do CPF do responsável pelo seguro 
	//									Obrigatório apenas se responsável pelo seguro for (2) responsável pela contratação do transporte - pessoa física 
	//		<infSeg> 0 - 1 -> Informações da seguradora
	//			4 <xSeg>	-> 1 - 1 -> Nome da Seguradora
	//			5 <CNPJ>	-> 1 - 1 -> Número do CNPJ da seguradora
	// 									Obrigatório apenas se responsável pelo seguro for (2) responsável pela contratação do transporte - pessoa jurídica 
	//		6 <nApol>	-> 0 - 1 -> Número da Apólice
	// 								Obrigatório pela lei 11.442/07 (RCTRC) 
	//		7 <nAver>	-> 0 - n -> Número da Averbação
	// 								Informar as averbações do seguro
	//		8 -> posição de controle para validar se foi excluido a linha

	oInfSeg := GetMDeInfo(oXML,"_MDFE:_INFMDFE:_SEG")
	if !valtype(oInfSeg) == "U"

		aXmlSeg := oInfSeg
		if !valtype(oInfSeg) == "A"
			aXmlSeg := {oInfSeg}
		endif

		for nSeg := 1 to len(aXmlSeg)

			FwFreeObj(aAverb)
			aAverb := {}

			cRespSeg := if(mdfeType("aXmlSeg[" + alltrim(str(nSeg)) + "]:_INFRESP:_RESPSEG") == "O" .and. !empty(aXmlSeg[nSeg]:_INFRESP:_RESPSEG:TEXT), aXmlSeg[nSeg]:_INFRESP:_RESPSEG:TEXT, "")
			cCNPJ := if(mdfeType("aXmlSeg[" + alltrim(str(nSeg)) + "]:_INFRESP:_CNPJ") == "O" .and. !empty(aXmlSeg[nSeg]:_INFRESP:_CNPJ:TEXT), aXmlSeg[nSeg]:_INFRESP:_CNPJ:TEXT, "")
			cCPF := if(mdfeType("aXmlSeg[" + alltrim(str(nSeg)) + "]:_INFRESP:_CPF") == "O" .and. !empty(aXmlSeg[nSeg]:_INFRESP:_CPF:TEXT), aXmlSeg[nSeg]:_INFRESP:_CPF:TEXT, "")
			cSeg := if(mdfeType("aXmlSeg[" + alltrim(str(nSeg)) + "]:_INFSEG:_XSEG") == "O" .and. !empty(aXmlSeg[nSeg]:_INFSEG:_XSEG:TEXT), aXmlSeg[nSeg]:_INFSEG:_XSEG:TEXT, "")
			cCNPJSeg := if(mdfeType("aXmlSeg[" + alltrim(str(nSeg)) + "]:_INFSEG:_CNPJ") == "O" .and. !empty(aXmlSeg[nSeg]:_INFSEG:_CNPJ:TEXT), aXmlSeg[nSeg]:_INFSEG:_CNPJ:TEXT, "")
			cApolice := if(mdfeType("aXmlSeg[" + alltrim(str(nSeg)) + "]:_NAPOL") == "O" .and. !empty(aXmlSeg[nSeg]:_NAPOL:TEXT), aXmlSeg[nSeg]:_NAPOL:TEXT, "")

			aXmlAverb := {}
			if !mdfeType("aXmlSeg[" + alltrim(str(nSeg)) + "]:_NAVER") == "U"
				aXmlAverb := aXmlSeg[nSeg]:_NAVER
				if !mdfeType("aXmlSeg[" + alltrim(str(nSeg)) + "]:_NAVER") == "A"
					aXmlAverb := {aXmlSeg[nSeg]:_NAVER}
				endif
				for nAverb := 1 to len(aXmlAverb)
					cAverb := PadR( aXmlAverb[nAverb]:TEXT, 40)
					if !empty(cAverb )
						aAdd( aAverb, {cAverb, .F.} )
					endif
				next

			endif

			aAdd( aInfSeg, { PadR(cRespSeg, 1) , PadR( cCNPJ, 14), PadR( cCPF, 11), PadR( cSeg, 30), PadR( cCNPJSeg, 14), PadR( cApolice, 20), aClone(aAverb), .F. } )

		next

	else
		aAdd( aInfSeg, { PadR(cRespSeg, 1) , PadR( cCNPJ, 14), PadR( cCPF, 11), PadR( cSeg, 30), PadR( cCNPJSeg, 14), PadR( cApolice, 20), {{space(40), .F.}}, .F. } )

	endif

return

/*/{Protheus.doc} LoadInfCtr
Carrega as informações dos dados dos contratantes de serviço de transporte

@return		nil
/*/
static function LoadInfCtr(oXML)
	local oInfCtr	 	:= nil
	local cNome		 	:= ""
	local cCNPJ		 	:= ""
	local cCPF		 	:= ""
	local cIdEst	 	:= ""
	local nInfCtr	 	:= 0
	local cReg		 	:= ""
	local cNumCtr		:= ""
	local nVlCtrGlobal	:= 0

	private aXmlCtr	  := {}

	ClearInfCtr()

	oInfCtr := GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFMODAL:_RODO:_INFANTT:_INFCONTRATANTE")
	if !valtype(oInfCtr) == "U"

		aXmlCtr := oInfCtr
		if !valtype(oInfCtr) == "A"
			aXmlCtr := {oInfCtr}
		endif

		for nInfCtr := 1 to len(aXmlCtr)
			cCPF 			:= ""
			cCNPJ 			:= ""
			cReg 			:= ""
			cNome 			:= if(mdfeType("aXmlCtr[" + alltrim(str(nInfCtr)) + "]:_XNOME") == "O" .and. !empty(aXmlCtr[nInfCtr]:_XNOME:TEXT), aXmlCtr[nInfCtr]:_XNOME:TEXT, "") 
			cCNPJ 			:= if(mdfeType("aXmlCtr[" + alltrim(str(nInfCtr)) + "]:_CNPJ") == "O" .and. !empty(aXmlCtr[nInfCtr]:_CNPJ:TEXT), aXmlCtr[nInfCtr]:_CNPJ:TEXT, "")
			cNumCtr 		:= if(mdfeType("aXmlCtr[" + alltrim(str(nInfCtr)) + "]:_INFCONTRATO:_NROCONTRATO") == "O" .and. !empty(aXmlCtr[nInfCtr]:_INFCONTRATO:_NROCONTRATO:TEXT), aXmlCtr[nInfCtr]:_INFCONTRATO:_NROCONTRATO:TEXT, "")
			nVlCtrGlobal	:= if(mdfeType("aXmlCtr[" + alltrim(str(nInfCtr)) + "]:_INFCONTRATO:_VCONTRATOGLOBAL") == "O" .and. !empty(aXmlCtr[nInfCtr]:_INFCONTRATO:_VCONTRATOGLOBAL:TEXT), Val(aXmlCtr[nInfCtr]:_INFCONTRATO:_VCONTRATOGLOBAL:TEXT), 0)
			if empty(cCNPJ)
				cCPF := if(mdfeType("aXmlCtr[" + alltrim(str(nInfCtr)) + "]:_CPF") == "O" .and. !empty(aXmlCtr[nInfCtr]:_CPF:TEXT), aXmlCtr[nInfCtr]:_CPF:TEXT, "")
				cReg := cCPF
			else
				cReg := cCNPJ
			endif
			cReg := PadR( cReg, GetSx3Cache("A1_CGC","X3_TAMANHO"))
			cIdEst := if(mdfeType("aXmlCtr[" + alltrim(str(nInfCtr)) + "]:_IDESTRANGEIRO") == "O" .and. !empty(aXmlCtr[nInfCtr]:_IDESTRANGEIRO:TEXT), aXmlCtr[nInfCtr]:_IDESTRANGEIRO:TEXT, "")

			aAdd( aInfContTr, { PadR(cNome, 60) , cReg, PadR( cIdEst, 20) , padr(cNumCtr,20) , nVlCtrGlobal} )

		next

	else
		aAdd( aInfContTr, { PadR(cNome, 60) , cReg, PadR( cIdEst, 20) , padr(cNumCtr,20) , nVlCtrGlobal} )

	endif

return

/*/{Protheus.doc} loadCondutores
Carrega as informações do condutor
@param	nil
@date	08/11/2021
@return	nil
/*/
static function loadCondutores(oXML,lMotori)
	local oCondutores	:= nil
	local cNome		 	:= ""
	local cCPF		 	:= ""
	local nI			:= 0
	local nIni			:= if( lMotori .and. empty(cMotorista), 1, 2 )

	private aXMLCond	:= {}

	ClearCondutor()

	oCondutores := GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR")

	if !valtype(oCondutores) == "U"

		aXMLCond := iif(valtype(oCondutores) == "A", oCondutores, {oCondutores})
		for nI := nIni to len(aXMLCond) //Ignora o primeiro pois o motorista principal fica no cabeçalho da rotina
			cNome	:= allTrim(if(mdfeType("aXMLCond[" + alltrim(str(nI)) + "]:_XNOME") == "O" .and. !empty(aXMLCond[nI]:_XNOME:TEXT), aXMLCond[nI]:_XNOME:TEXT, ""))
			cCPF	:= allTrim(if(mdfeType("aXMLCond[" + alltrim(str(nI)) + "]:_CPF") == "O" .and. !empty(aXMLCond[nI]:_CPF:TEXT), aXMLCond[nI]:_CPF:TEXT, ""))
			aAdd( aCondutores, { PadR( cCPF, 11), PadR(cNome, 60) } )
		next

	else
		aAdd( aCondutores, { PadR( cCPF, 11), PadR(cNome, 60) } )
	endif
	fwFreeObj(aXMLCond)
	aXMLCond := {}
	fwFreeObj(oCondutores)
	oCondutores := nil
return nil

/*/{Protheus.doc} loadReboque
Carrega as informações do reboque
@param	nil
@date	08/11/2021
@return	nil
/*/
static function loadReboque(oXML)
	local oReboque	:= nil
	local nI		:= 0
	local cInt		:= ""
	local cPlaca	:= ""
	local cUF		:= ""
	local cRenavam 	:= ""
	local cTpProp	:= ""

	private aXMLCond	:= {}

	ClearReboque()

	oReboque := GetMDeInfo(oXML,"_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE")

	if !valtype(oReboque) == "U"

		aXMLCond := iif(valtype(oReboque) == "A", oReboque, {oReboque})

		for nI := 1 to len(aXMLCond)
			cInt := allTrim(if(mdfeType("aXMLCond[" + alltrim(str(nI)) + "]:_CINT") == "O" .and. !empty(aXMLCond[nI]:_CINT:TEXT), aXMLCond[nI]:_CINT:TEXT, ""))
			cPlaca := allTrim(if(mdfeType("aXMLCond[" + alltrim(str(nI)) + "]:_PLACA") == "O" .and. !empty(aXMLCond[nI]:_PLACA:TEXT), aXMLCond[nI]:_PLACA:TEXT, ""))
			cUF := allTrim(if(mdfeType("aXMLCond[" + alltrim(str(nI)) + "]:_UF") == "O" .and. !empty(aXMLCond[nI]:_UF:TEXT), aXMLCond[nI]:_UF:TEXT, ""))
			cRenavam := allTrim(if(mdfeType("aXMLCond[" + alltrim(str(nI)) + "]:_RENAVAM") == "O" .and. !empty(aXMLCond[nI]:_RENAVAM:TEXT), aXMLCond[nI]:_RENAVAM:TEXT, ""))
			cTpProp := allTrim(if(mdfeType("aXMLCond[" + alltrim(str(nI)) + "]:_PROP:_TPPROP") == "O" .and. !empty(aXMLCond[nI]:_PROP:_TPPROP:TEXT), aXMLCond[nI]:_PROP:_TPPROP:TEXT, ""))
			if !empty(cTpProp)
				if cTpProp == "0" //TAC Agregado
					cTpProp := "3" 
				elseif cTpProp == '1' //TAC Independente
					cTpProp	:= "2" 
				else//Outros
					cTpProp	:= "1" 
				endif
			endif

			aAdd( aRebMDFe, { PadR( cInt, GetSx3Cache("DA3_COD","X3_TAMANHO")), PadR(cPlaca, GetSx3Cache("DA3_PLACA","X3_TAMANHO")), PadR(cUF, GetSx3Cache("DA3_ESTPLA","X3_TAMANHO")), PadR(cRenavam, GetSx3Cache("DA3_RENAVA","X3_TAMANHO")), PadR(cTpProp, GetSx3Cache("DA3_FROVEI","X3_TAMANHO")) } )
		next

	else
		aAdd( aRebMDFe, { PadR( cInt, GetSx3Cache("DA3_COD","X3_TAMANHO")), PadR(cPlaca, GetSx3Cache("DA3_PLACA","X3_TAMANHO")), PadR(cUF, GetSx3Cache("DA3_ESTPLA","X3_TAMANHO")), PadR(cRenavam, GetSx3Cache("DA3_RENAVA","X3_TAMANHO")), PadR(cTpProp, GetSx3Cache("DA3_FROVEI","X3_TAMANHO")) } )
	endif

	fwFreeObj(aXMLCond)
	aXMLCond := {}
	fwFreeObj(oReboque)
	oReboque := nil

return nil

//----------------------------------------------------------------------
/*/{Protheus.doc} LoadTRB
Carrega os dados do SF2/SA1 no arquivo de apoio TRB

@author Natalia Sartori
@since 10/02/2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function LoadTRB(nOpc)
	MsgRun("Buscando documentos do Veículo","Aguarde",{|| ;
								CleanTRB(nOpc),; //Antes de gravar, esvazio a TRB
								addTRB(nOpc) }) //Adiciona documentos na TRB

Return

/*/{Protheus.doc} addTRB
Adiciona documentos de origem de query na TRB

@author Natalia Sartori / Felipe Sales Martinez
@since 10/02/2014
@version P11
@Return	Nil
/*/
static function addTRB(nOpc)
Local cTpNF		:= ""
Local cAlias	:= ""

If !Empty(cVeiculo) .or. !Empty(cCarga)
	
	cAlias := getQueryDocs(nOpc)

	SA1->(dbSetOrder(1))
	SA2->(dbSetOrder(1))
	TRB->(dbSetOrder(1))
	nQtNFe := 0
	nVTotal := 0
	nPBruto := 0
	cVeiculoAux := cVeiculo
	While (cAlias)->(!Eof())
		if qryToTRB(cAlias, nOpc, !empty((cAlias)->SERMDF))
			If !Empty((cAlias)->CARGA) .And. Empty(cVeiculo) .And. nOpc == 3 .And. Alltrim(cTpNF) == "S"
				cVeiculo := (cAlias)->VEICUL1
			EndIf
			nQtNFe++
			nVTotal += (cAlias)->VALBRUT
			nPBruto += (cAlias)->PBRUTO
		endIf
		if nQtNFe+1 > QTDMAXNF
			msgInfo("Foram selecionadas as primeiras " + allTrim(str(QTDMAXNF)) + " NF-e(s)." + ENTER + ENTER +;
					"Caso necessário, refirne o filtro para seleção da(s) NF-e(s) desejada(s).", "Atenção")
			exit
		endIf
		(cAlias)->(dbSkip())
	EndDo
	
	TRB->(dbGoTop())

EndIf

return

//----------------------------------------------------------------------
/*/{Protheus.doc} CleanTRB
Esvazia a tabela TRB, para uma nova recarga

@author Natalia Sartori
@since 10/02/2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function CleanTRB(nOpc)

	oTempTable:Zap() //limpa registros da tabela TRB
	oHRecnoTRB:Clean()

	//Reinicia variaveis de controle
	If nOpc == 3
		cCodMun := Space(TamSx3("CC2_CODMUN")[1])
		cNomMun := Space(TamSx3("CC2_MUN")[1])
		nQtNFe	:= 0
		nVTotal	:= 0
		nPBruto	:= 0
	EndIf

	//Atualiza os objetos graficos da tela
	RefreshMainObjects()
Return

//----------------------------------------------------------------------
/*/{Protheus.doc} RefreshMainObjects
Atualiza os principais componentes graficos da tela principal (Main)

@author Natalia Sartori
@since 24.02.2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function RefreshMainObjects()

	If ValType(oMsSel) == "O"
		oMsSel:oBrowse:Refresh()
		oGetQtNFe:Refresh()
		oGetPBruto:Refresh()
		oGetVTot:Refresh()
		oGetNfeFil:Refresh()
		oCombo:Refresh()
		If lMDFePost
			oCombo2:Refresh()
		EndIf
		If lModal
			oCombo3:Refresh()
		EndIf

	EndIf

Return

/*/{Protheus.doc} ClearCondutor
Limpa a private aCondutores

@return		nil
/*/
static function ClearCondutor(xData)
	fwFreeObj(aCondutores)
	aCondutores := {}
return

//----------------------------------------------------------------------
/*/{Protheus.doc} ClearInfPag
Responsavel por limpar as variaveis do painel de pagamentos do MDF-e

@author Felipe Sales Martinez
@since 16.03.2020
@version P12
@Return	lRet
/*/
//-----------------------------------------------------------------------
static function ClearInfPag()

if type("oDlgPgt") == "O"
	fwfreeobj(oDlgPgt)
	oDlgPgt := nil
endif

oDlgPgt	:= MDFeInfPag():new()

return

/*/{Protheus.doc} ClearInfSeg
Limpa a private aInfSeg

@return		nil
/*/
static function ClearInfSeg()

	FwFreeObj(aInfSeg)
	aInfSeg := {}

return

/*/{Protheus.doc} ClearInfCtr
Limpa a private aInfContTr

@return		nil
/*/
static function ClearInfCtr()

	FwFreeObj(aInfContTr)
	aInfContTr := {}

return

/*/{Protheus.doc} ClearReboque
Limpa a private aRebMDFe

@return		nil
/*/
static function ClearReboque()
	fwFreeObj(aRebMDFe)
	aRebMDFe := {}
return

//----------------------------------------------------------------------
/*/{Protheus.doc} GetUfSig

Montagem do wizard de transmissão do MDFe

@author Natalia Sartori
@since 24.02.2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function GetUfSig(cCod,lForceUF)
	Local aUF			:= {}
	Local nPos			:= 0
	Local cSigla		:= ""
	DEFAULT lForceUF	:= .F.

	//Preenchimento do Array de UF
	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})

	nPos := aScan(aUF,{|x| x[1] == cCod})
	If nPos == 0
		nPos := aScan(aUF,{|x| x[2] == cCod})
		If nPos <> 0
			cSigla := aUF[nPos][1]
		EndIf
	Else
		cSigla := aUF[nPos][IIF(!lForceUF,2,1)]
	EndIf

Return cSigla

/*/{Protheus.doc} getQueryDocs

@author		Felipe Sales Martinez
@since		08.12.2022
@return		.T., boleano, true
/*/
static function getQueryDocs(nOpc)
local cAlias		:= ""
local cQuery		:= ""
local lNFEspecifica	:= .F. //Notas especificas?
local cDtDe			:= dtos(dFltDtDe)
local cDtAte		:= dtos(dFltDtAte)
local cDocDe		:= allTrim(cFltDocDe)
local cDocAte		:= allTrim(cFltDocAte)
local cSeries		:= evFormtSer(cFltSeries)

lNFEspecifica := !empty(cDocDe) .or. !empty(cDocAte) .or. !empty(cSeries)

if cEntSai == "1".or. cEntSai == "3" //1-Saida e 3-Entrada e Saida
	cQuery += "SELECT SF2.F2_FILIAL FILIAL,SF2.F2_SERIE SERIE, SF2.F2_DOC DOC, SF2.F2_EMISSAO EMISSAO, SF2.F2_CHVNFE CHVNFE, SF2.F2_ESPECIE ESPECIE, SF2.F2_CARGA CARGA, "
	cQuery += " SF2.F2_VALBRUT VALBRUT, SF2.F2_PBRUTO PBRUTO, SF2.F2_CLIENTE CLIFOR, SF2.F2_LOJA LOJA, SF2.F2_TIPO TIPO, "
	cQuery += " SF2.F2_SERMDF SERMDF, SF2.F2_NUMMDF NUMMDF, SF2.F2_VEICUL1 VEICUL1, SF2.F2_VEICUL2 VEICUL2, SF2.F2_VEICUL3 VEICUL3,'S' AS TP_NF, R_E_C_N_O_ RECNF FROM "
	cQuery += RetSqlName('SF2') + " SF2 "
	cQuery += "WHERE SF2.F2_ESPECIE = 'SPED' AND SF2.F2_CHVNFE <> ' ' AND SF2.F2_FIMP <> 'D' AND SF2.D_E_L_E_T_ = ' ' "
	If SubStr(cNfeFil,1,1) == "2"
		cQuery += "AND SF2.F2_FILIAL = '" + xFilial('SF2') + "' "
	endIf
	if !Empty(cDtDe)
		cQuery += "AND SF2.F2_EMISSAO >= '" +cDtDe+"' "
	endIf
	if !Empty(cDtAte)
		cQuery += "AND SF2.F2_EMISSAO <= '" +cDtAte+"' "
	endIf
	cQuery += "AND (SF2.F2_VEICUL1 = '" + cVeiculo + "' "
	cQuery += 		"OR SF2.F2_VEICUL2 = '" + cVeiculo + "' "
	cQuery += 		"OR SF2.F2_VEICUL3 = '" + cVeiculo + "') "

	if lNFEspecifica
		if !empty(cDocDe)
			cQuery += "AND SF2.F2_DOC >= '" +cDocDe+"' "
		endIf
		if !empty(cDocAte)
			cQuery += "AND SF2.F2_DOC <= '" +cDocAte+"' "
		endIf
		if !empty(cSeries)
			cQuery += "AND SF2.F2_SERIE IN (" +cSeries+") "
		endIf

	else
		//Traz notas nao selecionadas:
		if nOpc <> 3 .and. lFilDMDF2 .and. !Empty(cFilMDF)
			cQuery += "AND  F2_"+cFilMDF + " = '" + xFilial("CC0") + "' "
		endIf
		cQuery += "AND SF2.F2_SERMDF = '" + iif(nOpc == 3," ",CC0->CC0_SERMDF) + "' "
		cQuery += "AND SF2.F2_NUMMDF = '" + iif(nOpc == 3," ",CC0->CC0_NUMMDF) + "' "
	endIf

endIf

if cEntSai == "3" //3-Entrada e Saida
	cQuery += " UNION ALL "
endIf

If cEntSai == "2" .or. cEntSai == "3" //2-Entrada e 3-Entrada e Saida
	cQuery += "SELECT SF1.F1_FILIAL FILIAL,SF1.F1_SERIE SERIE, SF1.F1_DOC DOC, SF1.F1_EMISSAO EMISSAO, SF1.F1_CHVNFE CHVNFE, SF1.F1_ESPECIE ESPECIE,'F1_CARGA' AS CARGA,"
	cQuery += " SF1.F1_VALBRUT VALBRUT, SF1.F1_PBRUTO PBRUTO, SF1.F1_FORNECE CLIFOR, SF1.F1_LOJA LOJA, SF1.F1_TIPO TIPO, "
	cQuery += " SF1.F1_SERMDF SERMDF, SF1.F1_NUMMDF NUMMDF, SF1.F1_VEICUL1 VEICUL1, SF1.F1_VEICUL2 VEICUL2, SF1.F1_VEICUL3 VEICUL3,'E' AS TP_NF, R_E_C_N_O_ RECNF FROM "
	cQuery += RetSqlName('SF1') + " SF1 "
	cQuery += "WHERE SF1.F1_ESPECIE = 'SPED' AND SF1.D_E_L_E_T_ = ' ' AND SF1.F1_CHVNFE <> ' ' "
	If SubStr(cNfeFil,1,1) == "2"
		cQuery += "AND SF1.F1_FILIAL = '" + xFilial('SF1') + "' "
	endIf

	if nOpc == 3 
		if !Empty(cDtDe) 
			cQuery += "AND SF1.F1_EMISSAO >= '" +cDtDe+"' "
		endIf
		if !Empty(cDtAte)
			cQuery += "AND SF1.F1_EMISSAO <= '" +cDtAte+"' "
		endIf
	endIf
	cQuery += "AND (SF1.F1_VEICUL1 = '" + cVeiculo + "' "
	cQuery += 		"OR SF1.F1_VEICUL2 = '" + cVeiculo + "' "
	cQuery += 		"OR SF1.F1_VEICUL3 = '" + cVeiculo + "') "

	if lNFEspecifica
		if !empty(cDocDe)
			cQuery += "AND SF1.F1_DOC >= '" +cDocDe+"' "
		endIf
		if !empty(cDocAte)
			cQuery += "AND SF1.F1_DOC <= '" +cDocAte+"' "
		endIf
		if !empty(cSeries)
			cQuery += "AND SF1.F1_SERIE IN (" +cSeries+") "
		endIf

	else
		//Trazer as nao selecionadas
		if nOpc <> 3 .and. lFilDMDF1 .and. !Empty(cFilMDF)
			cQuery += "AND  F1_"+cFilMDF + " = '" + xFilial("CC0") + "' "
		endIf
		cQuery += "AND SF1.F1_SERMDF = '" + iif(nOpc == 3," ",CC0->CC0_SERMDF) + "' "
		cQuery += "AND SF1.F1_NUMMDF = '" + iif(nOpc == 3," ",CC0->CC0_NUMMDF) + "' "
	endIf
endIf

If cEntSai == "2" //2-Entrada
	If ExistBlock("MDSQLSF1")
		cQuery := ExecBlock("MDSQLSF1", .F., .F.,{cQuery})
	EndIf
ElseIf ExistBlock("MDSQLSF2") //1-Saida e 3-Entrada e Saida
	cQuery := ExecBlock("MDSQLSF2", .F., .F.,{cQuery})
EndIf

oQryFltDoc	:= FwExecStatement():New(ChangeQuery(cQuery))
cAlias		:= oQryFltDoc:OpenAlias()

return cAlias

//-----------------------------------------------------------------------
/*/{Protheus.doc} EvFormtSer
Função responsavel separar as series informadas nos parametros de busca 
da Nf-e

@author		Felipe Sales Martinez
@since		19.08.2019
@version	1.00
@param		cSerieEvento = Serie(s) do evento para filtro das notas fiscais
@return		cRet: 
/*/
//-----------------------------------------------------------------------
Static Function EvFormtSer(cSerieEvento)
Local cRet		:= ""
Local aEvSer	:= {}
Local nI		:= 1

cSerieEvento := AllTrim(cSerieEvento)

If !Empty(cSerieEvento)
	If Isnumeric(cSerieEvento) .Or. Len(AllTrim(cSerieEvento)) == TamSx3("F2_SERIE")[1]
		cRet := "'" + AllTrim(cSerieEvento) + "'"
	Else
		cRet 	:= StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(cSerieEvento,",",";"),"/",";"),"\",";"),"*",";"),"-",";"),"-",";"),",",";")
		aEvSer	:= StrToArray(cRet,";")
		cRet 	:= ""
		For nI := 1 To Len(aEvSer)
			cRet += "'" + aEvSer[nI] + "'"
			If nI <> Len(aEvSer)
				cRet += ","
			EndIf
		Next nI
	EndIf
EndIf
Return cRet

/*/{Protheus.doc} qryToTRB

@author		Felipe Sales Martinez
@since		08.12.2022
@return		.T., boleano, true
/*/
static function qryToTRB(cAlias, nOpc, lVinculada)
local lRet			:= .F.
local lCliFor		:= .F.
local cNomeCliFor 	:= ""
local cFilReg	 	:= ""

If Alltrim((cAlias)->TP_NF) == "E" //Entradas

	cFilReg := retFilClFo((cAlias)->FILIAL, .F., (cAlias)->TIPO)
	If (cAlias)->TIPO $ "B|D"
		If SA1->(msSeek(cFilReg + (cAlias)->CLIFOR + (cAlias)->LOJA))
			cNomeCliFor	:= SA1->A1_NOME
			lCliFor		:= .T.
		EndIf
	Else
		If SA2->(msSeek(cFilReg + (cAlias)->CLIFOR + (cAlias)->LOJA))
			cNomeCliFor	:= SA2->A2_NOME
			lCliFor		:= .T.
		EndIf
	EndIf

Else //Saidas
	cFilReg := retFilClFo((cAlias)->FILIAL, .T., (cAlias)->TIPO)
	If (cAlias)->TIPO $ "B|D"
		If SA2->(msSeek(cFilReg + (cAlias)->CLIFOR + (cAlias)->LOJA))
			cNomeCliFor	:= SA2->A2_NOME
			lCliFor 	:= .T.
		EndIf
	Else
		If SA1->(msSeek(cFilReg + (cAlias)->CLIFOR + (cAlias)->LOJA))
			cNomeCliFor	:= SA1->A1_NOME
			lCliFor 	:= .T.
		EndIf
	EndIf
Endif

If lCliFor .and. (nOpc <> 2  .Or. (nOpc == 2 .And. lVinculada))
	If !Empty((cAlias)->DOC) .And. !Empty((cAlias)->SERIE)
		lRet := recTRB(	.T.				 ,(cAlias)->SERIE	,(cAlias)->DOC		,(cAlias)->EMISSAO	,(cAlias)->CHVNFE	,;
			  			(cAlias)->CLIFOR ,(cAlias)->LOJA	,cNomeCliFor		,NIL				,nil				,;
			  			nil				 ,(cAlias)->VALBRUT	,(cAlias)->PBRUTO	,lVinculada			,(cAlias)->VEICUL1	,;
			  			(cAlias)->VEICUL2 ,(cAlias)->VEICUL3,(cAlias)->CARGA	,(cAlias)->FILIAL	,(cAlias)->TP_NF	,;
			  			(cAlias)->RECNF, (cAlias)->TIPO	)
	End
EndIf

return lRet

//-----------------------------------------------------------------------
/*/{Protheus.doc} retFilClFo
Retorna a filial do cliente ou fornecedor

@author		Felipe Sales Martinez
@since 		04/03/2021
@version 	1.00
@param		cFilDoc, String, Filial da Nota Fiscal Entrada/Saida
			isCustomer, String, Se é cliente ou não (fornecedor)
@return		cFil, String, Filial do cliente/fornecedor
/*/
//-----------------------------------------------------------------------
Static function retFilClFo(cFilDoc, lsCustomer, cTipo)
local cFilret		:= ""
local cTabCliFo		:= ""

Default cFilDoc		:= ""
DeFault lsCustomer	:= .T.
DeFault cTipo		:= "" 

cTabCliFo := IIF((lsCustomer .And. cTipo $ "B,D") .Or. (!lsCustomer .And. !cTipo $ "B,D"), "SA2","SA1") 

cFilret := FwxFilial(cTabCliFo,cFilDoc)

return cFilret

//----------------------------------------------------------------------
/*/{Protheus.doc} RecTRB
Grava ou altera um registro na TRB a partir dos parametros recebidos

@author Natalia Sartori
@since 10/02/2014
@version P11
@Return	Nil
/*/
//-----------------------------------------------------------------------
Static Function RecTRB(lInclui	,cSerie		,cDoc		,cEmissao	,cChaveNFe	,;
					   cCodCli	,cLoja		,cNomCli	,cCodMun	,cNomMun	,;
					   cEstMun	,nValBru	,nPeso		,lVinculada	,cVeic1		,;
					   cVeic2	,cVeic3		,cCarga		,cTotFilial	,cTpNF		,;
					   nRecNfe, cTipo)
	Local lRet		:= .T.
	local cInfo		:= ""
	local aDados	:= {}

	Default cCodMun 	:= ""
	Default cNomMun 	:= ""
	Default lVinculada	:= .F.
	Default cCarga 		:= ""
	Default cTotFilial 	:= ""
	Default cTpNF	 	:= ""
	Default nRecNfe		:= 0
	Default cTipo		:= ""

	If !lInclui
		TRB->(dbSetOrder(1))
		If !TRB->(dbSeek(cSerie+cDoc))
			lRet := .F.
		EndIf
	EndIf

	If lRet
		RecLock('TRB',lInclui)
		TRB->TRB_MARCA 	:= iif(lVinculada,cMark,"")
		TRB->TRB_FILIAL := cTotFilial
		TRB->TRB_SERIE 	:= cSerie
		TRB->TRB_DOC 	:= cDoc
		TRB->TRB_EMISS 	:= STOD(cEmissao)
		TRB->TRB_CHVNFE := cChaveNFe
		
		if oHChvsNFE:Get(Alltrim(TRB->TRB_CHVNFE), @cInfo) .and. cInfo <> nil
			if len(aDados := StrTokArr2(cInfo,"#_")) >= 3
				TRB->TRB_EST	:= GetUfSig(aDados[1])
				TRB->TRB_CODMUN := aDados[2]
				TRB->TRB_NOMMUN := aDados[3]
			endIf
		else
			TRB->TRB_CODMUN := cCodMun
			TRB->TRB_NOMMUN := cNomMun
			TRB->TRB_EST	:= cEstMun
		endif
		TRB->TRB_CODCLI := cCodCli
		TRB->TRB_LOJCLI := cLoja
		TRB->TRB_NOMCLI := cNomCli
		TRB->TRB_VALTOT := nValBru
		TRB->TRB_PESBRU := nPeso
		TRB->TRB_VEICU1 := cVeic1
		TRB->TRB_VEICU2 := cVeic2
		TRB->TRB_VEICU3 := cVeic3
		TRB->TRB_TPNF	:= cTpNF
		TRB->TRB_RECNF	:= nRecNfe
		TRB->TRB_TIPO	:= cTipo
		If lMDFePost
			TRB->TRB_POSTE := iif( SubStr(cPoster,1,1) == "1","1","2") //#"1-Sim"
		EndIf
		if lVinculada
			//aAdd(aHTRBVinc,{TRB->TRB_RECNF, TRB->TRB_TPNF})
		endIf
		TRB->(msUnlock())
		oHRecnoTRB:Set(TRB->TRB_RECNF," ")

	EndIf

Return lRet
