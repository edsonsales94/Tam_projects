//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"


/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ HISPEDXLS  ¦ Autor ¦Orismar Silva         ¦ Data ¦ 16/05/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦           ¦ Rotina para chamar a classe zExcelXML para lasse para         ¦¦¦
¦¦¦           ¦ manipular e gerar o arquivos XML do Excel.                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/


/*/{Protheus.doc} zTstPro
Função que testa a classe zExcelXML para a tabela de produtos
@author Atilio
@since 31/07/2015
@version 1.0
	@example
	u_zTstPro()
/*/   

User Function HISPEDXLS(_aProduto)
	Local aMes         := {}
	Local aDia         := {}
	Local aQuant       := {}
	Local aLote        := {}
	Local aEstado      := {}
	Local cDestino     := "GUARULHOS"

	IncProc()
	SA1->(dbSetOrder(1))
	SA1->(MsSeek(xFilial("SA1")+ _aProduto[1,5]+_aProduto[1,6],.T.))
	cNomeCli         := ALLTRIM(SA1->A1_NOME)
	cEndereCli       := ALLTRIM(SA1->A1_END)+" BAIRRO: "+ALLTRIM(SA1->A1_BAIRRO)
	cCepCli          := "CEP: "+TransForm(SA1->A1_CEP,"@r 99999-999")+" "+ALLTRIM(SA1->A1_MUN)+" - "+ALLTRIM(SA1->A1_EST)+" BRASIL"
	cCNPJCli         := IIF(SA1->A1_PESSOA="J","CNPJ: ","CPF: ")+Transform(SA1->A1_CGC,IIF(SA1->A1_PESSOA="J","@r 99.999.999/9999-99","@r 999.999.999-99"))
	cCliente         := _aProduto[1,5]
	cTpCliente       := SA1->A1_PESSOA
	cMunicipio       := ALLTRIM(SA1->A1_MUN)
	cEstado          := ALLTRIM(SA1->A1_MUN)
	*

	cPedido          := _aProduto[1,4]
	cNota            := u_zTiraZeros(_aProduto[1,3])
	ccData           := SUBSTR(DTOS(_aProduto[1,7]),7,2)+"."+SUBSTR(DTOS(_aProduto[1,7]),5,2)+"."+SUBSTR(DTOS(_aProduto[1,7]),1,4)
	cAno             := SUBSTR(DTOS(_aProduto[1,7]),1,4)


	//Destinos
	aadd(aEstado ,{"SP","GUARULHOS"})
	aadd(aEstado ,{"ES","GUARULHOS"})
	aadd(aEstado ,{"MG","GUARULHOS"})
	aadd(aEstado ,{"RS","GUARULHOS"})
	aadd(aEstado ,{"PR","GUARULHOS"})
	aadd(aEstado ,{"SC","GUARULHOS"})
	aadd(aEstado ,{"RJ","GUARULHOS"})
	aadd(aEstado ,{"GO","GOIANIA"})
	aadd(aEstado ,{"RR","BOA VISTA"})
	aadd(aEstado ,{"MS","CAMPO GRANDE"})
	aadd(aEstado ,{"MT","CUIABA"})
	aadd(aEstado ,{"CE","FORTALEZA"})
	aadd(aEstado ,{"PB","JOÃO PESSOA"})
	aadd(aEstado ,{"AP","MACAPÁ"})
	aadd(aEstado ,{"AL","MACEIÓ"})
	aadd(aEstado ,{"RN","NATAL"})
	aadd(aEstado ,{"TO","PALMAS"})
	aadd(aEstado ,{"RO","PORTO VELHO"})
	aadd(aEstado ,{"PE","RECIFE"})
	aadd(aEstado ,{"AC","RIO BRANCO"})
	aadd(aEstado ,{"DF","BRASILIA"})
	aadd(aEstado ,{"PI","TERESINA"})
	aadd(aEstado ,{"MA","SÃO LUIZ"})
	aadd(aEstado ,{"BA","SALVADOR"})
	aadd(aEstado ,{"PA","BELEM"})
	*
	nPos 	:= Ascan(aEstado,{ |x| x[1] = cEstado })
	if nPos > 0
		DO CASE
		CASE cMunicipio = "CATALAO"
			cDestino := "GUARULHOS"
		CASE cMunicipio = "VAL PARAISO"
			cDestino := "BRASILIA"
		CASE cMunicipio = "TIMON" .OR. cMunicipio = "CAXIAS"
			cDestino := "TERESINA"
		CASE cMunicipio = "FORTALEZA DOS NOGUEIRAS" .OR. cMunicipio = "CAROLINA" .OR. cMunicipio = "SAO RAIMUNDO DOS MANGABEIRAS" .OR. cMunicipio = "ESTREITO" .OR. cMunicipio = "BALSAS" .OR. cMunicipio = "ACAILANDIA" .OR. cMunicipio = "IMPERATRIZ"
			cDestino := "IMPERATRIZ"
		CASE cMunicipio = "ILHEUS" .OR. cMunicipio = "EUNAPOLIS" .OR. cMunicipio = "VITORIA DA CONQUISTA" .OR.  cMunicipio = "ITABUNA" .OR.  cMunicipio = "TEIXEIRA FREITAS" .OR.  cMunicipio = "ITARANTIM"
			cDestino := "ILHEUS"
		CASE cMunicipio = "ITAITUBA" .OR. cMunicipio = "SANTAREM"
			cDestino := "SANTAREM"
		CASE cMunicipio = "PARAUPEBAS" .OR. cMunicipio = "REDENCAO"  .OR. cMunicipio = "SAO FELIZ DO XINGU" .OR. cMunicipio = "XINGUARA" .OR. cMunicipio = "TUCUMA" .OR. cMunicipio = "SANTANA DO ARAGUAIA" .OR. cMunicipio = "ELDORADO DOS CARAJAS"  .OR. cMunicipio = "BREU BRANCO"  .OR. cMunicipio = "CURIONOPOLIS"  .OR. cMunicipio = "RUROPOLIS"  .OR. cMunicipio = "RIO MARIA"  .OR. cMunicipio = "MARABA"
			cDestino := "MARABA"
		OTHERWISE
			cDestino := aEstado[nPos,2]
		ENDCASE
	endif


	//Meses do Ano
	aadd(aMes ,{1,"Jan"})
	aadd(aMes ,{2,"Feb"})
	aadd(aMes ,{3,"Mar"})
	aadd(aMes ,{4,"Apr"})
	aadd(aMes ,{5,"May"})
	aadd(aMes ,{6,"Jun"})
	aadd(aMes ,{7,"Jul"})
	aadd(aMes ,{8,"Aug"})
	aadd(aMes ,{9,"Sep"})
	aadd(aMes ,{10,"Oct"})
	aadd(aMes ,{11,"Nov"})
	aadd(aMes ,{12,"Dec"})
	*

	//Dias do Mês
	aadd(aDia ,{1,"1st"})
	aadd(aDia ,{2,"2nd"})
	aadd(aDia ,{3,"3rd"})
	aadd(aDia ,{4,"4th"})
	aadd(aDia ,{5,"5th"})
	aadd(aDia ,{6,"6th"})
	aadd(aDia ,{7,"7th"})
	aadd(aDia ,{8,"8th"})
	aadd(aDia ,{9,"9th"})
	aadd(aDia ,{10,"10th"})
	aadd(aDia ,{11,"11th"})
	aadd(aDia ,{12,"12th"})
	aadd(aDia ,{13,"13th"})
	aadd(aDia ,{14,"14th"})
	aadd(aDia ,{15,"15th"})
	aadd(aDia ,{16,"16th"})
	aadd(aDia ,{17,"17th"})
	aadd(aDia ,{18,"18th"})
	aadd(aDia ,{19,"19th"})
	aadd(aDia ,{20,"20th"})
	aadd(aDia ,{21,"21st"})
	aadd(aDia ,{22,"22nd"})
	aadd(aDia ,{23,"23rd"})
	aadd(aDia ,{24,"24th"})
	aadd(aDia ,{25,"25th"})
	aadd(aDia ,{26,"26th"})
	aadd(aDia ,{27,"27th"})
	aadd(aDia ,{28,"28th"})
	aadd(aDia ,{29,"29th"})
	aadd(aDia ,{30,"30th"})
	aadd(aDia ,{31,"31st"})

	nPos 	:= Ascan(aMes,{ |x| x[1] = MONTH(_aProduto[1,7]) })
	if nPos > 0
		cMes := aMes[nPos,2]
	endif
	nPos 	:= Ascan(aDia,{ |x| x[1] = DAY(_aProduto[1,7]) })
	if nPos > 0
		cDia := aDia[nPos,2]
	endif

	//CAIXA PADRÃO E DISPLAY POR LOTE
	aadd(aLote ,{"41100",960,40})
	aadd(aLote ,{"41200",960,20})
	aadd(aLote ,{"42100",288,12})
	aadd(aLote ,{"42200",288,12})
	aadd(aLote ,{"45100",100,10})
	aadd(aLote ,{"61101",240,20})
	aadd(aLote ,{"61221",60,60})
	aadd(aLote ,{"61222",60,60})

	//QUANTIDADE X PESO
	//ICE COLD SPRAY
		aadd(aQuant ,{"61222",60,"7,521 kg G"}) // aadd(aQuant ,{"61222",60,"7,521 kg G"})
		//AIR SALONPAS ////AIR SALONPAS			   aadd(aQuant ,{"61222",60,"7,521 kg G"})
		aadd(aQuant ,{"45100",10,"1,00 kg G"}) //  aadd(aQuant ,{"45100",10,"2,00 kg G"})
		aadd(aQuant ,{"45100",20,"2,00 kg G"}) //  aadd(aQuant ,{"45100",20,"3,00 kg G"})
		aadd(aQuant ,{"45100",30,"3,00 kg G"}) //  aadd(aQuant ,{"45100",30,"4,00 kg G"})
		aadd(aQuant ,{"45100",40,"4,00 kg G"}) //  aadd(aQuant ,{"45100",40,"5,00 kg G"})
		aadd(aQuant ,{"45100",50,"5,00 kg G"}) //  aadd(aQuant ,{"45100",50,"6,00 kg G"})
		aadd(aQuant ,{"45100",60,"6,00 kg G"}) //  aadd(aQuant ,{"45100",60,"7,00 kg G"})
		aadd(aQuant ,{"45100",70,"7,00 kg G"}) //  aadd(aQuant ,{"45100",70,"8,00 kg G"})
		aadd(aQuant ,{"45100",80,"8,00 kg G"}) //  aadd(aQuant ,{"45100",80,"9,00 kg G"})
		aadd(aQuant ,{"45100",90,"9,00 kg G"}) //  aadd(aQuant ,{"45100",90,"10,00 kg G"})
		aadd(aQuant ,{"45100",100,"9,800 kg G"})// aadd(aQuant ,{"45100",100,"9,800 kg G"})

	//VARIÁVEL
	nTotqtd := 0
	nTotqtdS:= 0
	cPeso   := ""
	_cPeso  := ""
	*
	//CONSULTA PRODUTO E QUANTIDADE
	nPos 	:= Ascan(aQuant,{ |x| x[1] = _aProduto[1,1] .and. x[2] = _aProduto[1,2] })
	if nPos > 0
		cPeso := aQuant[nPos,3]
		nTotqtd++
	else // SENÃO ENCONTRAR IRÁ PROCURAR QUANTIDADE PADRÃO DO PRODUTO
		nQtdProd := _aProduto[1,2]
		nPos1 	:= Ascan(aLote,{ |x| x[1] = _aProduto[1,1] })
		if nPos1 > 0
			nLote := iif(cTpCliente = "J",aLote[nPos1,2],aLote[nPos1,3])//VERIFICAR O CLIENTE PARA CONSIDERAR A QUANTIDADE DA CX PADRÃO (J) OU DISPLAY (F)
		endif
		//VERIFICA O PESO UNITÁRIO DO PRODUTO - ICE COLD SPRAY ou AIR SALONPAS
		nPos2 	:= Ascan(aQuant,{ |x| x[1] = _aProduto[1,1] .and. x[2] = nLote})
		if nPos2 > 0
			cPeso := aQuant[nPos2,3]
		endif
		*
		while nQtdProd >= nLote
			nQtdProd:= nQtdProd-nLote
			nTotqtd++
		end
		//SE EXISTIR SOBRA
		if nQtdProd > 0
			nPos3 	:= Ascan(aQuant,{ |x| x[1] = _aProduto[1,1] .and. x[2] = nQtdProd })
			if nPos3 > 0
				_cPeso := aQuant[nPos3,3]
				nTotqtdS++
			endif
		endif

	endif


	if !EMPTY(cPeso)
		cID              := "UN 1950"
		cProper          := "Aerosols, flammable"
		cClass           := "2.1"
		nQtd             := cValToChar(nTotqtd)
		cType            := iif(nTotqtd=1,"Fibreboard box x ","Fibreboard boxes x ")+cPeso
		cPacking         := "Y203"
	endif

	if !EMPTY(_cPeso)
		cID1             := "UN 1950"
		cProper1         := "Aerosols, flammable"
		cClass1          := "2.1"
		cQtd1            := cValToChar(nTotqtdS)
		cType1           := iif(nTotqtdS=1,"Fibreboard box x ","Fibreboard boxes x ")+_cPeso
		cPacking1        := "Y203"
	else
		cID1             := ""
		cProper1         := ""
		cClass1          := ""
		cQtd1            := ""
		cType1           := ""
		cPacking1        := ""
	endif
	*
	SZ3->(dbSetOrder(1))

	cFone            := "24 - hour  number: + 55 "+ALLTRIM(SZ3->Z3_DDD)+" "+Transform(ALLTRIM(SZ3->Z3_FRESP),"@R 9999-9999")
	cResponsavel     := ALLTRIM(SZ3->Z3_RESP)
	cNomeautorizado  := ALLTRIM(SZ3->Z3_NAUTOR)
	cCargo           := ALLTRIM(SZ3->Z3_CARGO)
	*
	cData          := "MANAUS, "+cMes+" "+cDia+","+cAno
	*
	// se não existir o diretorio do modelo no disco C: local.
	if !FILE("c:\modelo")
		nRetM := MakeDir( "c:\modelo" ) // cria o diretorio
		if nRetM != 0 
			ALERT( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
			Return
		endif
	endif
	
	// se não existir o diretorio do shipper no disco C: local.
	if !FILE("C:\SHIPPER")
		nRetS := MakeDir( "C:\SHIPPER" ) // cria o diretorio
		if nRetS != 0
			ALERT( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
			Return
		endif
	endif

	if !FILE("c:\modelo\shipper.xml") // se não existir o arquivo modelo no local, faz a copia do que está no server.
		LOk := CpyS2T( "\SYSTEM\SHIPPER\shipper.xml", "c:\modelo", .F. )
		if !LOk // SE NÃO COPIAR O MODELO QUE ESTÁ NO SERVIDOR RETORNA.
			ALERT( "Não foi possível obter o modelo, para gerar o Shipper." )
			Return
		endif
	endif

	oExcelXML := zExcelXML():New(.F.)								                          //Instância o Objeto
	//oExcelXML:SetOrigem(cStartPath+"modelo\shipper.xml")					                          //Indica o caminho do arquivo Origem (que será aberto e clonado)
	oExcelXML:SetOrigem("c:\modelo\shipper.xml")					                          //Indica o caminho do arquivo Origem (que será aberto e clonado)
	oExcelXML:SetDestino(GetTempPath()+"shipper"+cCliente+"_"+cNota+".xml")				                          //Indica o caminho do arquivo Destino (que será gerado)
	//oExcelXML:SetDestino("C:\SHIPPER\shipper"+cCliente+".xml")				                          //Indica o caminho do arquivo Destino (que será gerado)
	oExcelXML:CopyTo("C:\SHIPPER\SHIPPER"+cCliente+"_"+cNota+".xml")		                              //Adiciona caminho de cópia que será gerado ao montar o arquivo
	*
	oExcelXML:AddExpression("#nome_cliente"  , cNomeCli)			                              //Adiciona expressão do nome do Cliente
	oExcelXML:AddExpression("#endereco"      , cEndereCli)               //Adiciona expressão do endereço do Cliente
	oExcelXML:AddExpression("#cnpj"          , cCNPJCli)			                      //Adiciona expressão do CNPJ/CPF do Cliente
	oExcelXML:AddExpression("#cep"           , cCepCli)			                      //Adiciona expressão do CNPJ/CPF do Cliente
	*
	oExcelXML:AddExpression("#pedido"        , "Shipper´s Reference Number - "+cPedido)	      //Adiciona expressão do pedido de venda
	oExcelXML:AddExpression("#NOTA"          , "NF: "+cNota)                                    //Adiciona expressão da Nota Fiscal
	*
	oExcelXML:AddExpression("#ID"            , cID)
	oExcelXML:AddExpression("#proper"        , cproper)
	oExcelXML:AddExpression("#class"         , cClass)
	oExcelXML:AddExpression("#qtd"           , nqtd)
	oExcelXML:AddExpression("#type"          , cType)
	oExcelXML:AddExpression("#packing"       , cPacking)
	*
	oExcelXML:AddExpression("#_ID"           , cID1)
	oExcelXML:AddExpression("#_proper"       , cproper1)
	oExcelXML:AddExpression("#_class"        , cClass1)
	oExcelXML:AddExpression("#_qtd"          , cqtd1)
	oExcelXML:AddExpression("#_type"         , cType1)
	oExcelXML:AddExpression("#_packing"      , cPacking1)
	*
	oExcelXML:AddExpression("#fone"          , cfone)
	oExcelXML:AddExpression("#responsavel"   , cresponsavel)
	*
	oExcelXML:AddExpression("#nomeautorizado", cNomeautorizado)
	oExcelXML:AddExpression("#cargo"         , cCargo)
	oExcelXML:AddExpression("#dataExtenso"   , cData)

	oExcelXML:AddExpression("#data"          , ccData)
	oExcelXML:AddExpression("#destination"   , cDestino)
	*

	oExcelXML:MountFile()
	//oExcelXML:ViewSO()											                          //Abre o .xml conforme configuração do Sistema Operacional,ou seja, se tiver Linux + LibreOffice ele irá abrir
	oExcelXML:View()												                          //Utilizar apenas se não for utilizado o método ViewSO pois dessa forma é forçado a abrir pelo Excel
	oExcelXML:Destroy(.F.)											                          //Destrói os atributos do objeto
	oExcelXML:ShowMessage("")
	//Testa demonstração de mensagem em branco

Return




/*/{Protheus.doc} zTiraZeros
Função que tira zeros a esquerda de uma variável caracter
@author Atilio
@since 19/07/2017
@version undefined
@param cTexto, characters, Texto que terá zeros a esquerda retirados
@type function
@example Exemplos abaixo:
    u_zTiraZeros("00000090") //Retorna "90"
    u_zTiraZeros("00000909") //Retorna "909"
    u_zTiraZeros("0000909A") //Retorna "909A"
    u_zTiraZeros("000909AB") //Retorna "909AB"
/*/

User Function zTiraZeros(cTexto)
	Local aArea     := GetArea()
	Local cRetorno  := ""
	Local lContinua := .T.
	Default cTexto  := ""

	//Pegando o texto atual
	cRetorno := Alltrim(cTexto)

	//Enquanto existir zeros a esquerda
	While lContinua
		//Se a priemira posição for diferente de 0 ou não existir mais texto de retorno, encerra o laço
		If SubStr(cRetorno, 1, 1) <> "0" .Or. Len(cRetorno) ==0
			lContinua := .f.
		EndIf

		//Se for continuar o processo, pega da próxima posição até o fim
		If lContinua
			cRetorno := Substr(cRetorno, 2, Len(cRetorno))
		EndIf
	EndDo

	RestArea(aArea)
Return cRetorno
