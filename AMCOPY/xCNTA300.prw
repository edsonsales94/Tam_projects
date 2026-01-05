//Bibliotecas
#Include "Protheus.ch"
#INCLUDE 'FWMVCDEF.CH'
#Include "TOTVS.ch"
#Include "TopConn.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "RPTDEF.CH"

#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE

//Posições do Array
// Static nPosCodigo := 1 //Coluna A no Excel
// Static nPosLojFor := 2 //Coluna B no Excel
// Static nPosRazSoc := 3 //Coluna C no Excel
// Static nPosObserv := 4 //Coluna D no Excel
// InfoTec@2025
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ CNTA300    ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/09/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada dos Contratos                                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CNTA300()
	Local oModel, cIdPonto, nCNA, nCNB
	Local aParam  := PARAMIXB
	Local cTpoImp := GetMV("MV_XTPOPRC",.F.,"01,02,31")    // Tipos a terem o preço controlado
	Local nVlrMin := Max(0,GetMV("MV_XPRCMIN",.F.,0.3))    // Preço mínimo para os tipos acima	Local aParam  := PARAMIXB
	Local xRet    := .T.
	
	If aParam <> Nil
		oModel   := aParam[1]
		cIdPonto := aParam[2]  
		cIDModel := aParam[3]
		
		If cIdPonto == "BUTTONBAR"
			xRet := {}
			AAdd( xRet , { "Importar Itens","Importar Itens",{|| u_zImpCSV() }})
			//AAdd( xRet , { "Vis. Anexos"  ,"BITMAP",{|| u_AMVisDocAprv(2) }})
			Return xRet
		ElseIf cIdPonto == "MODELPRE"
			/*If oModelPAD:GetOperation() == 3
				oModelPAD:GetModel('NNSMASTER'):LoadValue('NNS_CLASS',"1")
			Endif*/
		ElseIf cIdPonto == "MODELCOMMITNTTS"   // Após gravação das tabelas
			//If ExistBlock("MT097APR")
			//	ExecBlock("MT097APR",.F.,.F.,{})
			//Endif
		ElseIf cIdPonto == "FORMPOS"   // Validação da tela
			If cIDModel == "NNTDETAIL"
				/*oModelNNT := aParam[1]
				If Empty(oModelNNT:aLinesChanged)   // Caso não tenham linhas alterados então está sendo usada a EFETIVAÇÃO
					For nX := 1 To oModelNNT:Length()
						oModelNNT:GoLine( nX )
						If !oModelNNT:IsDeleted()
							oModelNNT:GetValue( 'NNT_FILDES' )
							
							// Se o TES do item for um TES de transferência e não for um usuário autorizado a efetivar
							If TESIntel(oModelNNT,"UC") == oModelNNT:GetValue( 'NNT_TS' ) .And. !(__cUserID $ cUsrTrf)
								Alert("Usuário não tem permissão para efetivar a solicitação !")
								xRet := .F.
								Exit
							Endif
						Endif
					Next nX
				Endif*/
			Endif
		ElseIf cIdPonto == "MODELPOS"   // Validação da tela
			If FunName() == "CNTA300"   // Valida somente pela rotina do Contrato
				oCNA := oModelPAD:GetModel("CNADETAIL")
				For nCNA := 1 To oCNA:Length()
					oCNA:GoLine( nCNA )
					If !oCNA:IsDeleted()
						oCNB := oModelPAD:GetModel("CNBDETAIL")
						For nCNB := 1 To oCNB:Length()
							oCNB:GoLine( nCNB )
							If !oCNB:IsDeleted()
								If Trim(oCNB:GetValue( 'CNB_XTIMPR' )) $ cTpoImp .And. oCNB:GetValue( 'CNB_VLUNIT' ) < nVlrMin
									FWAlertError("Valor informado está abaixo do valor permitido !")
									If xRet := FWAlertYesNo("Deseja informar uma senha superior para liberar ?")
										xRet := VldSenha()
									Endif
									Return xRet
								Endif
							Endif
						Next
					Endif
				Next
			Endif
		ElseIf cIdPonto == "FORMLINEPOS"   // Validação do item
			//oModelNNT := aParam[1]
			//xRet := xA311LinOk(oModelNNT)
		Endif
	Endif
	
Return xRet

Static Function VldSenha(cGerSelec,cLegTela)
	Local oPsw, oBut1, oBut2
	Local cTitLib := If( cLegTela == Nil , "Liberação de Preço", cLegTela)
	Local cCodGer := Space(Len(__cUserID))
	Local lRet    := .F.
	Local oFont1  := TFont():New("Courier New",,-14,.T.,.T.)
	Local cPswFol := Space(15)
	
	DEFINE MSDIALOG oPsw TITLE cTitLib From 12,8 To 28,40 OF oMainWnd
	
	@ 30,005 SAY "Gerente.:" PIXEL OF oPsw
	@ 30,035 MSGET cCodGer VALID Gerente(cCodGer) SIZE 40,10 PIXEL OF oPsw FONT oFont1  F3 "ZA3"
	
	@ 50,005 SAY "Senha.:" PIXEL OF oPsw
	@ 50,035 GET cPswFol PASSWORD SIZE 30,10 PIXEL OF oPsw FONT oFont1
	
	@ 70,010 BUTTON oBut1 PROMPT "&Ok"      SIZE 30,12 OF oPsw PIXEL Action If( lRet := ChkSenha(cCodGer,cPswFol) , oPsw:End(), )
	@ 70,050 BUTTON oBut2 PROMPT "&Cancela" SIZE 30,12 OF oPsw PIXEL Action (oPsw:End(),lRet := .F.)
	
	ACTIVATE MSDIALOG oPsw CENTERED
	
	If lRet   // Se validou o gerentre
		cGerSelec := cCodGer
	Endif
	
Return lRet

Static Function Gerente(cCodGer)
	Local cIDSuper := GetMV("MV_XIDSUPER",.F.,"000000,000142")     // ID's dos usuários que liberam o contrato
	LocaL lRet     := .T.
	
	If !( cCodGer $ cIDSuper )
		lRet := .F.
		FWAlertError("Usuário informado não é um Superior !")
	Endif

Return lRet

Static Function ChkSenha(cVend,cPass)
	LocaL lRet := .F.
	
	PswOrder(1)
	PswSeek(cVend)
	If lRet := PswName(AllTrim(cPass))
	Else
		FWAlertError("Senha Inválida !")
	Endif

Return lRet
  
/*/{Protheus.doc} zImpCSV
Função para importar informações do fornecedor via csv
@author Atilio
@since 07/06/2021
@version 1.0
@type function
/*/
User function zImpCSV()

	Local aArea         := GetArea()
	Private cCliente    := Space(6)
	Private cLoja      := Space(2)
	Private cCond      := Space(3)
	Private cTipo       := "Pedido (*.CSV)        | *.CSV | "
	// Private cTipo       := cTipo + "Todos os Arquivos (*.csv)   | *.csv     "
	Private mvpar01     := Space(30)
	Private cxPath      := ""
	Private cCaminho    := Space(100)
	Private oPed

	@ 275,235 To 496,880 Dialog oPed Title OemToAnsi("Gerar os Itens da planilhas de contatos")
	@ 5,2  To 41,292 Title OemToAnsi("ARQUIVO:")
	@ 85,2 To 110,311
	@ 20,10   MSGET cCaminho Size 204,10   PIXEL of oPed WHEN .F.

	@ 18,224 Button OemToAnsi("Carregar arquivo CSV") Size 60,16 Action FARQUI01()
	@ 85,175 Button OemToAnsi("Gerar Itens")          Size 55,20 Action AMCPGRAV()
	@ 85,250 Button OemToAnsi("Fechar")               Size 55,20 Action Close(oPed)

	Activate Dialog oPed  CENTERED

	RestArea(aArea)
	*
Return

/*/
	+-------------------------------------------------------------------------------+
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
	¦¦¦ Programa  ¦ FARQUI01    ¦ Autor ¦Edson Sales        	  ¦ Data ¦ 24/11/2025 ¦¦¦
	¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
	¦¦¦           ¦ Rotina para exibir a pasta d arquivo CSV.                     ¦¦¦
	¦¦¦           ¦                                                               ¦¦¦
	¦¦+-----------+---------------------------------------------------------------+¦¦
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	+-------------------------------------------------------------------------------+
/*/

Static Function FARQUI01()

	cArq := ( cxPath + RTRIM(mvpar01) + ".csv" )
	lArq := .T.

	IF ( !FILE(cArq) )
		lArq := .F.
		cArq := cGetFile( cTipo,"Selecione arquivo...",1  , cxPath , .T. , CGETFILE_TYPE )
		If Empty(cArq).AND.Empty(mvpar01)
			Aviso("Cancelada a Seleção!","Você cancelou a seleção do arquivo.",{"Ok"})
		Endif
	ENDIF
	IF ( !EMPTY(cArq) )
		cCaminho := cArq
		oPed:Refresh()
	ENDIF

Return(.T.)

  
/*-------------------------------------------------------------------------------*
 | Func:  AMCPGRAV                                                               |
 | Desc:  Função que importa os dados                                            |
 *-------------------------------------------------------------------------------*/
Static function AMCPGRAV()
	******************************
	Private aItem       := {}
	Private aItens      := {}
	Private lMsErroAuto := .F.
	Private aLogP	    := {}
	Private aDados      := {}   //Armazena os dados do aquivo .CSV
	*
	if Empty(cCaminho)
		Alert("Necessário informar o arquivo! ")
		Return .F.
	endif
	*
	if CN9->CN9_SITUAC =='02' .or. inclui
		ProcOK()
	else
		Alert('O contrato precisa está em situação de elaboração, para permitir a importação dos itens')
		Return
	endif

	Close(oPed)
Return

Static Function ProcOK()
    Local aArea      := GetArea()
    Local cArqLog    := "zImpCSV_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    Private cDirLog    := GetTempPath() + "x_importacao\"
    Private cLog       := ""
      
    //Se a pasta de log não existir, cria ela
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf
  
    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(cCaminho)
      
    //Se o arquivo pode ser aberto
    If (oArquivo:Open())
  
        //Se não for fim do arquivo
        If ! (oArquivo:EoF())
  
            //Definindo o tamanho da régua
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)
            ProcRegua(nTotLinhas)
              
            //Método GoTop não funciona (dependendo da versão da LIB), deve fechar e abrir novamente o arquivo
            oArquivo:Close()
            oArquivo := FWFileReader():New(cCaminho)
            oArquivo:Open()
  
            //Enquanto tiver linhas
            While (oArquivo:HasLine())
  
                //Incrementa na tela a mensagem
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                  
                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
			
				iF ";;" $ cLinAtu
					cLinAtu := StrTran(cLinAtu,';;',';N/A;')
					aLinha  := StrTokArr(cLinAtu, ";")
				Else
					aLinha  := StrTokArr(cLinAtu, ";")
				ENDIF

                dbSelectArea('SB1')
				DBSETORDER(1)
                //Se PRODUTO TIVR CADASTRADO ADICIONA NO ARRAY ADADOS
				cProduto := aLinha[1]
                If SB1->(msseek(xfilial('SB1')+cProduto))
					aadd(aDados,aLinha)
                Else				
					If aLinha[1] != "N/A"
                    	cLog += "- Linha " + cValToChar(nLinhaAtu) + ", linha nao processada - "+aLinha[1]+';' + CRLF
                	EndIf
                EndIf
                  
            EndDo

			if len(aDados) > 0
				fPreencha(aDados)
			endif

            //Se tiver log, mostra ele
            If ! Empty(cLog)
                cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            EndIf
  
        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf
  
        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf
  
    RestArea(aArea)
Return


// adicionar linha na grid
// https://forum.totvs.io/t/duvida-sobre-o-addline-em-mvc-com-grid/20894

static function fPreencha(_aDados)
// local lContinua := .T.
local oModelPAD:= fwModelActive()
Local oModelGRID := oModelPAD:GetModel('CNBDETAIL')
// local oStruct := oModelGRID:GetStruct()
// local aCampos := oStruct:GetFields()
// local ni := 0
// local nC := 0
local nZ := 0
local cItem := ""
local lNew := .F.
local nLinAtu := oModelGrid:length()
// local aProdutos := {}
// local aLinhaAtual := fwSaveRows()

if !altera .and. !inclui
    MsgStop("A funcionalidade somente pode ser utilizada na inclusão ou alteração!","A T E N Ç Ã O !")
    return
endif

// for ni := 1 to len(aCampos)
//     aadd(aProdutos, {aCampos[ni][3], oModelGrid:getValue(aCampos[ni][3])})
// next

cItem := ""
// NLIN := 4
FOR NZ := 1 TO LEN(_aDados)

	if nLinAtu == 1  .AND. empty(cItem)//. se a linha do item não for a 1º. (na tela MVC a primeira linha da grid já existe por default)
		cItem := '001' 
		lNew := .T.
	Else
        cItem := IIF(Empty(cItem),soma1(STRZERO(nLinAtu,3)),soma1(cItem))
	endif
	
	if NZ < Len(_aDados) .and. lNew 
		oModelGRID:goLine(oModelGrid:length())
		oModelGrid:addLine()
		nLinAtu := oModelGrid:length()-1
	Elseif NZ < Len(_aDados) .and. !lNew
		oModelGRID:goLine(oModelGrid:length())
		// Adicionar duas linhas no inicio para controle
		if NZ == 1 
			oModelGrid:addLine() 
			oModelGrid:addLine()
		else
			oModelGrid:addLine()
		endif
		nLinAtu := oModelGrid:length()-1
	Else
		nLinAtu := oModelGrid:length()
	endif

	oModelGRID:goLine(nLinAtu)

	oModelGrid:loadValue("CNB_FILIAL",XFILIAL('CNB'))
	oModelGrid:loadValue("CNB_FILORI",XFILIAL('CNB'))
	oModelGrid:loadValue("CNB_ITEM",cItem)
	oModelGrid:loadValue("CNB_XITPAI",fItemPai(oModelGrid,_aDados[NZ,1])) // busca o item pai em caso de Franquia
	oModelGrid:loadValue("CNB_PRODUT",_aDados[NZ,1])
	oModelGrid:loadValue("CNB_DESCRI",POSICIONE('SB1',1,XFILIAL('SB1')+_aDados[NZ,1],'B1_DESC'))
	oModelGrid:loadValue("CNB_UM",POSICIONE('SB1',1,XFILIAL('SB1')+_aDados[NZ,1],'B1_UM'))
	oModelGrid:loadValue("CNB_XSERIA", IIF(Fserie(_aDados[NZ,1],_aDados[NZ,2]),_aDados[NZ,2],'')) // fserie verifica se a serie existe para esse produto, se não exitir coloca vazio.
	oModelGrid:loadValue("CNB_XTIMPR",IIF(LEN(_aDados[NZ,3])>1,_aDados[NZ,3],STRZERO(VAL(_aDados[NZ,3]),2)))
	oModelGrid:loadValue("CNB_XTPDES",ALLTRIM(POSICIONE('SX5',1,XFILIAL('SX5')+'Z9'+STRZERO(VAL(_aDados[NZ,3]),2),'X5_DESCRI')))
	oModelGrid:loadValue("CNB_QUANT",VAL(_aDados[NZ,4]))
	oModelGrid:loadValue("CNB_VLUNIT",VAL(STRTRAN(_aDados[NZ,5],',','.')))
	oModelGrid:loadValue("CNB_VLTOT",VAL(_aDados[NZ,4]) * VAL(STRTRAN(_aDados[NZ,5],',','.')))
	oModelGrid:loadValue("CNB_TS",_aDados[NZ,6])
	oModelGrid:loadValue("CNB_SLDMED",VAL(_aDados[NZ,4]))
	oModelGrid:loadValue("CNB_SLDREC",VAL(_aDados[NZ,4]))
	oModelGrid:loadValue("CNB_QTDORI",VAL(_aDados[NZ,4]))
	oModelGrid:loadValue("CNB_PRCORI",VAL(STRTRAN(_aDados[NZ,5],',','.')))
	// oModelGrid:loadValue("CNB_VLTOT",VAL(_aDados[NZ,4]) * VAL(STRTRAN(_aDados[NZ,5],',','.')))        

//     for nC := 1 to  len(aProdutos)
// //		oModelGrid:loadValue(aProdutos[nC][1],XFILIAL('CNB'))    SO FALTA O CAMPO DO ITEM PAI PARA TIPO DE FRANQUIA
//         do case
//         case alltrim(aProdutos[nC][1]) == "CNB_FILIAL"
// 			oModelGrid:loadValue(aProdutos[nC][1],XFILIAL('CNB'))
//         case alltrim(aProdutos[nC][1]) == "CNB_FILORI"
// 			oModelGrid:loadValue(aProdutos[nC][1],XFILIAL('CNB'))
//         case alltrim(aProdutos[nC][1]) == "CNB_XITPAI"
// 			oModelGrid:loadValue(aProdutos[nC][1],fItemPai(oModelGrid,_aDados[NZ,1])) // busca o item pai em caso de Franquia
//         case alltrim(aProdutos[nC][1]) == "CNB_ITEM"
//             oModelGrid:loadValue(aProdutos[nC][1],cItem)
//         case alltrim(aProdutos[nC][1]) == "CNB_PRODUT"
//             oModelGrid:loadValue(aProdutos[nC][1],_aDados[NZ,1])
//         case alltrim(aProdutos[nC][1]) == "CNB_DESCRI"
//             oModelGrid:loadValue(aProdutos[nC][1],POSICIONE('SB1',1,XFILIAL('SB1')+_aDados[NZ,1],'B1_DESC'))
//         case alltrim(aProdutos[nC][1]) == "CNB_UM"
//             oModelGrid:loadValue(aProdutos[nC][1],POSICIONE('SB1',1,XFILIAL('SB1')+_aDados[NZ,1],'B1_UM'))
//         case alltrim(aProdutos[nC][1]) == "CNB_XSERIA"
//             oModelGrid:loadValue(aProdutos[nC][1], IIF(Fserie(_aDados[NZ,1],_aDados[NZ,2]),_aDados[NZ,2],'')) // fserie verifica se a serie existe para esse produto, se não exitir coloca vazio.
//         case alltrim(aProdutos[nC][1]) == "CNB_XTIMPR"
//             oModelGrid:loadValue(aProdutos[nC][1],STRZERO(VAL(_aDados[NZ,3]),2))
//         case alltrim(aProdutos[nC][1]) == "CNB_XTPDES"
//             oModelGrid:loadValue(aProdutos[nC][1],ALLTRIM(POSICIONE('SX5',1,XFILIAL('SX5')+'Z9'+STRZERO(VAL(_aDados[NZ,3]),2),'X5_DESCRI')))
//         case alltrim(aProdutos[nC][1]) == "CNB_QUANT"
//             oModelGrid:loadValue(aProdutos[nC][1],VAL(_aDados[NZ,4]))
//         case alltrim(aProdutos[nC][1]) == "CNB_VLUNIT"
//             oModelGrid:loadValue(aProdutos[nC][1],VAL(STRTRAN(_aDados[NZ,5],',','.')))
//         case alltrim(aProdutos[nC][1]) == "CNB_VLTOT"
//             oModelGrid:loadValue(aProdutos[nC][1],VAL(_aDados[NZ,4]) * VAL(STRTRAN(_aDados[NZ,5],',','.')))
//         case alltrim(aProdutos[nC][1]) == "CNB_TS"
//             oModelGrid:loadValue(aProdutos[nC][1],_aDados[NZ,6])
//         case alltrim(aProdutos[nC][1]) == "CNB_SLDMED"
//             oModelGrid:loadValue(aProdutos[nC][1],VAL(_aDados[NZ,4]))
//         case alltrim(aProdutos[nC][1]) == "CNB_SLDREC"
//             oModelGrid:loadValue(aProdutos[nC][1],VAL(_aDados[NZ,4]))
//         case alltrim(aProdutos[nC][1]) == "CNB_QTDORI"
//             oModelGrid:loadValue(aProdutos[nC][1],VAL(_aDados[NZ,4]))
//         case alltrim(aProdutos[nC][1]) == "CNB_PRCORI"
//             oModelGrid:loadValue(aProdutos[nC][1],VAL(STRTRAN(_aDados[NZ,5],',','.')))
//         case alltrim(aProdutos[nC][1]) == "CNB_VLTOT"
//             oModelGrid:loadValue(aProdutos[nC][1],VAL(_aDados[NZ,4]) * VAL(STRTRAN(_aDados[NZ,5],',','.')))        
//         endcase
//     next
    
Next NZ
oModelGrid:GoLine(1)
// fwRestRows(aLinhaAtual)
Return Nil



/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fItemPai   ¦ Autor ¦ Edson Sales          ¦ Data ¦ 21/08/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Execblock de validação dos campos da planilha do contrato     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fItemPai(oModelDet,_cProd)
	Local cItemPai := ''
	// Local nLine := oModelDet:GetLine()
	
	If M->CN9_ESPCTR <> "2"   // Se não for venda
		Return cItemPai
	Endif
	
	If M->CN9_TPCTO <> "003"  // Se não for contrato de franquia
		Return cItemPai
	Endif

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(XFILIAL("SB1")+_cProd))
	
	If SB1->B1_TIPO == "TF"   // Se for TIPO FRANQUIA
		cItemPai := oModelDet:GetValue("CNB_ITEM")
	Else
		cItemPai := LinhaFranquia(oModelDet,"CNB_ITEM",{|| SB1->B1_TIPO == "TF" },"CNB_XITPAI")
	Endif
 
Return cItemPai

Static Function PesqFranquia(oModel,_cItemPai)
	Local nL
	Local nLine := oModel:GetLine()
	Local lRet  := .F.
	
	For nL := 1 To oModel:Length()
		oModel:GoLine(nL)
		
		If oModel:GetValue("CNB_ITEM") == _cItemPai
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFILIAL("SB1")+oModel:GetValue("CNB_PRODUT")))
			lRet := (SB1->B1_TIPO == "TF")
			Exit
		Endif
	Next
	oModel:GoLine(nLine)    // Restaura a linha atual
	
Return lRet

Static Function LinhaFranquia(oModel,cCampo,bValid,cCmpPag)
	Local nL
	Local nLine := oModel:GetLine()
	Local xRet  := Nil
	
	For nL := nLine To 1 Step -1
		oModel:GoLine(nL)
		
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(XFILIAL("SB1")+oModel:GetValue("CNB_PRODUT")))
		
		If xRet == Nil .And. Eval(bValid)
			xRet := oModel:GetValue(cCampo)
			Exit
		Endif
	Next
	oModel:GoLine(nLine)    // Restaura a linha atual
	
	If xRet == Nil
		xRet := CriaVar(cCmpPag)
	Endif
	
Return xRet

Static Function Fserie(cProd,cNumSerie)
	Local lRet    := .T.

	if Select("TMP")>0
		TMP->(dbCloseArea())
	endif

	// Valida se existe o número de série para o produto
	cQry := "SELECT ISNULL(COUNT(*),0) AS QTDE"
	cQry += " FROM " + RetSQLName("SDB") + " SDB"
	cQry += " WHERE SDB.D_E_L_E_T_ = ' '"
	cQry += " AND SDB.DB_ESTORNO = ' '"
	cQry += " AND SDB.DB_PRODUTO = '"+cProd+"'"
	cQry += " AND SDB.DB_NUMSERI = '"+cNumSerie+"'"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
	
	If TMP->QTDE == 0  // Se não encontrou
		return .F.
	Endif
	dbCloseArea()

Return lRet


Static Function JaExiste(oModel,cNumSerie)
	Local nL
	Local aArea   := GetArea()
	Local nLine   := oModel:GetLine()  // Linha atual
	Local cTpImpr := oModel:GetValue("CNB_XTIMPR")
	Local lRet    := .T.
	
	// Valida se existe o número de série para o produto
	cQry := "SELECT ISNULL(COUNT(*),0) AS QTDE"
	cQry += " FROM " + RetSQLName("SDB") + " SDB"
	cQry += " WHERE SDB.D_E_L_E_T_ = ' '"
	cQry += " AND SDB.DB_ESTORNO = ' '"
	cQry += " AND SDB.DB_PRODUTO = '"+oModel:GetValue("CNB_PRODUT")+"'"
	cQry += " AND SDB.DB_NUMSERI = '"+cNumSerie+"'"
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
	
	If TMP->QTDE == 0  // Se não encontrou
		lRet := ExistCpo("SX5","@@")
	Endif
	dbCloseArea()
	
	If lRet
		// Percorre os itens da planilha
		For nL := 1 To oModel:Length()
			If nL <> nLine   // Não analisa a linha atual
				oModel:GoLine(nL)
				
				If oModel:GetValue("CNB_XSERIA") == cNumSerie .And.;
					(!(Posicione("SB1",1,XFILIAL("SB1")+oModel:GetValue("CNB_PRODUT"),"B1_GRUPO") $ "0014,0009,0012,0017,0006") .Or.;    // Se o grupo for MULTICOLOR
					oModel:GetValue("CNB_XTIMPR") == cTpImpr)
					lRet := .F.
					Alert("Não é possível informar esse conteúdo. O mesmo já foi informado !")
					Exit
				Endif
			Endif
		Next
		oModel:GoLine(nLine)    // Restaura a linha atual
	Endif
	
	If lRet
		cQry := "SELECT ISNULL(COUNT(*),0) AS QTDE"
		cQry += " FROM " + RetSQLName("CNB") + " CNB"
		cQry += " INNER JOIN " + RetSQLName("CN9") + " CN9 ON CN9.D_E_L_E_T_ = ' '"
		cQry += " AND CN9.CN9_FILIAL = CNB.CNB_FILIAL"
		cQry += " AND CN9.CN9_NUMERO = CNB.CNB_NUMERO"
		cQry += " AND CN9.CN9_REVISA = CNB.CNB_REVISA"
		cQry += " AND CN9.CN9_SITUAC = '05'"
		cQry += " WHERE CNB.D_E_L_E_T_ = ' '"
		cQry += " AND CNB.CNB_PRODUT = '"+oModel:GetValue("CNB_PRODUT")+"'"
		cQry += " AND CNB.CNB_XSERIA = '"+cNumSerie+"'"
		cQry += " AND CNB.CNB_CONTRA <> '"+M->CN9_NUMERO+"'"
		
		// Se o grupo for MULTICOLOR
		If Posicione("SB1",1,XFILIAL("SB1")+oModel:GetValue("CNB_PRODUT"),"B1_GRUPO") == "0014"
			cQry += " AND CNB.CNB_XTIMPR = '"+cTpImpr+"'"
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
		
		If TMP->QTDE > 0
			lRet := .F.
			Alert("Não é possível informar esse conteúdo. O mesmo já foi informado !")
		Endif
		dbCloseArea()
	Endif
	RestArea(aArea)
	
Return lRet
