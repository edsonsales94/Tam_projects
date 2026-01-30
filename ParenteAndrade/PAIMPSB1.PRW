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

Static nPosCODIGO   := 1
Static nPosGRUPO    := 2
Static nPosDESC     := 3
Static nPosTIPO     := 4
Static nPosUM       := 5
Static nPosLOCPAD   := 6
Static nPosPOSIPI   := 7
Static nPosORIGEM   := 8
Static nPosCODISS   := 9
Static nPosIRRF     := 10
Static nPosINSS     := 11
Static nPosREDINSS  := 12
Static nPosPIS      := 13
Static nPosCOFINS   := 14
Static nPosCSLL     := 15
Static nPosTRIBMUN  := 16
Static nPosAPROPRI  := 17
Static nPosRASTRO   := 18
Static nPosLOCALIZ  := 19
Static nPosCC       := 20

/*/{Protheus.doc} PAIMPSB1
Função para importar informações do fornecedor via csv
@author Edson
@since 29/01/2026
@version 1.0
@type function
/*/
User function PAIMPSB1()
	Local aArea         := GetArea()
	// local lamb := RpcSetEnv('01','01')
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
	@ 85,175 Button OemToAnsi("Gravar")          Size 55,20 Action Processa({ || F_SaveSb1(),'Processando arquivos...'})
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
		If Empty(cArq)
			Aviso("Cancelada a Seleção!","Você cancelou a seleção do arquivo.",{"Ok"})
		Endif
	ENDIF
	IF ( !EMPTY(cArq) )
		cCaminho := cArq
		oPed:Refresh()
	ENDIF

Return(.T.)


/*-------------------------------------------------------------------------------*
 | Func:  F_SaveSb1                                                               |
 | Desc:  Função que importa os dados                                            |
 *-------------------------------------------------------------------------------*/
  
Static Function F_SaveSb1()
    Local aArea      := GetArea()
    // Local cArqLog    := "PAIMPSB1_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local cCodigo
    Local cGrupo
    Local cDescri
    Local cTipo
    Local cUniMed
    Local cLocPad
    Local cPosIpi
    Local cOrigem
    Local cCODISS
    Local cIRRF
    Local cINSS
    Local nREDINSS
    Local cPIS
    Local cCOFINS
    Local cCSLL
    Local cTRIBMUN
    Local cApropri
    Local cRastro
    Local cLocaliz
    Local cCCusto
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local nOper       := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    Private cDirLog    := GetTempPath() + "x_importacao\"
    Private cLog       := ""
    Private nReg       := 0
    
    cArqOri := cCaminho
    //Se a pasta de log não existir, cria ela
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf
  
    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(cArqOri)
      
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
            oArquivo := FWFileReader():New(cArqOri)
            oArquivo:Open()
  
            //Enquanto tiver linhas
            While (oArquivo:HasLine())
  
                //Incrementa na tela a mensagem
                nLinhaAtu++
                nTotLinhas-=2
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                  
                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(cLinAtu, ";")
                
                if Len(aLinha) > 0    
                    //Se não for o cabeçalho (encontrar o texto "B1_" ou a observação na linha atual )
                    If !"B1_" $ cLinAtu .and. Len(aLinha[nPosCODIGO]) < 100 

                        nOper := iif(alltrim(aLinha[nPosCODIGO])=='N/A',3,4) // se for N/A é inclusão.

                        if len(aLinha) < 20
                            FwAlertWarning('Exitem colunas em branco nessa planilha, na linha '+ alltrim(cValToChar(nLinhaAtu-2)) +' a linha sera ignorada, por favor preencher com N/A.', 'Atenção !')
                        else
                            cCodigo := iif(alltrim(aLinha[nPosCODIGO])  ==  'N/A' , x_IncCod(aLinha[nPosGRUPO]),alltrim(aLinha[nPosCODIGO]))
                            cGrupo  := iif(alltrim(aLinha[nPosGRUPO])   ==  'N/A' , ''  ,alltrim(aLinha[nPosGRUPO]))
                            cDescri := iif(alltrim(aLinha[nPosDESC])    ==  'N/A' , ''  ,alltrim(aLinha[nPosDESC]))
                            cTipo   := iif(alltrim(aLinha[nPosTIPO])    ==  'N/A' , ''  ,alltrim(aLinha[nPosTIPO]))
                            cUniMed := iif(alltrim(aLinha[nPosUM])      ==  'N/A' , ''  ,alltrim(aLinha[nPosUM]))
                            cLocPad := iif(alltrim(aLinha[nPosLOCPAD])  ==  'N/A' , ''  ,strzero(val(aLinha[nPosLOCPAD]),2))
                            cPosIpi := iif(alltrim(aLinha[nPosPOSIPI])  ==  'N/A' , ''  ,alltrim(aLinha[nPosPOSIPI]))
                            cOrigem := iif(alltrim(aLinha[nPosORIGEM])  ==  'N/A' , ''  ,alltrim(aLinha[nPosORIGEM]))
                            cCODISS := iif(alltrim(aLinha[nPosCODISS])  ==  'N/A' , ''  ,alltrim(aLinha[nPosCODISS]))
                            cIRRF   := iif(alltrim(aLinha[nPosIRRF])    ==  'N/A' , ''  ,alltrim(aLinha[nPosIRRF]))
                            cINSS   := iif(alltrim(aLinha[nPosINSS])    ==  'N/A' , ''  ,alltrim(aLinha[nPosINSS]))
                            nREDINSS:= iif(alltrim(aLinha[nPosREDINSS]) ==  'N/A' , 0   ,val(aLinha[nPosREDINSS]))
                            cPIS    := iif(alltrim(aLinha[nPosPIS])     ==  'N/A' , ''  ,alltrim(aLinha[nPosPIS]))
                            cCOFINS := iif(alltrim(aLinha[nPosCOFINS])  ==  'N/A' , ''  ,alltrim(aLinha[nPosCOFINS]))
                            cCSLL   := iif(alltrim(aLinha[nPosCSLL])    ==  'N/A' , ''  ,alltrim(aLinha[nPosCSLL]))
                            cTRIBMUN:= iif(alltrim(aLinha[nPosTRIBMUN]) ==  'N/A' , ''  ,alltrim(aLinha[nPosTRIBMUN]))
                            cApropri:= iif(alltrim(aLinha[nPosAPROPRI]) ==  'N/A' , ''  ,alltrim(aLinha[nPosAPROPRI]))
                            cRastro := iif(alltrim(aLinha[nPosRASTRO])  ==  'N/A' , ''  ,alltrim(aLinha[nPosRASTRO]))
                            cLocaliz:= iif(alltrim(aLinha[nPosLOCALIZ]) ==  'N/A' , ''  ,alltrim(aLinha[nPosLOCALIZ]))
                            cCCusto := iif(alltrim(aLinha[nPosCC])      ==  'N/A' , ''  ,alltrim(aLinha[nPosCC]))
                            cPosIpi := iif(cPosIpi=='0','00000000',cPosIpi)
                            cPIS    := iif(cPIS=='S','1','2')
                            cCOFINS    := iif(cCOFINS=='S','1','2')
                            cCSLL    := iif(cIRRF=='S','1','2')

                            fGravProd(cCodigo,cGrupo,cDescri,cTipo,cUniMed,cLocPad,cPosIpi,cOrigem,cCODISS,ciRRF,cINSS,nREDINSS,cPIS,cCOFINS,cCSLL,cTRIBMUN,cApropri,cRastro,cLocaliz,cCCusto,nOper)
                        endif
                        
                    Else
                        // cLog += "- Lin" + cValToChar(nLinhaAtu) + ", linha não processada - cabeçalho;" + CRLF
                    EndIf
                    
                endif
            EndDo
  
            //Se tiver log, mostra ele
            // If ! Empty(cLog)
            //     cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
            //     MemoWrite(cDirLog + cArqLog, cLog)
            //     ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            // EndIf
  
        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf
  
        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf
    
    if nReg == 0
        FWAlertError('Nenhum produto foi importado...','Importacao Finalizada!!!')
    else
        FWAlertSuccess('Total de produtos importados '+ cValToChar(nReg),'Importacao Finalizada!!!')
    endif
    
    RestArea(aArea)
Return
Static Function fGravProd(_cCodigo,_cGrupo,_cDescri,_cTipo,_cUniMed,_cLocPad,_cPosIpi,_cOrigem,_nCODISS,_niRRF,_nINSS,_nREDINSS,_nPIS,_nCOFINS,_nCSLL,_nTRIBMUN,_cApropri,_cRastro,_cLocaliz,_cCCusto,_nOper)
    //Pegando o modelo de dados, setando os campos
    Local lgrv := .T.    
    oModel := FWLoadModel("MATA010")

    if _nOper == 4
        DbSelectArea('SB1')
        SB1->(DbSetOrder(1)) // Filial + Código + Loja
        //Se conseguir posicionar no Pproduto
        If !U_tValCod(xFilial('SB1'),_cGrupo,_cCodigo)
            FwAlertWarning('Falha ao Tentar de alterar o código do produto: '+_cCodigo +', O mesmo não foi encontrado no cadastro', 'ErroCodigo.')
            lgrv := .F.   
        EndIf
    endif

    if lgrv
        aFields := {}
        aAdd(aFields, {"B1_COD"     , _cCodigo  , Nil})
        aAdd(aFields, {"B1_DESC"    , _cDescri  , Nil})
        aAdd(aFields, {"B1_GRUPO"   , _cGrupo   , Nil})
        aAdd(aFields, {"B1_TIPO"    , _cTipo    , Nil})
        aAdd(aFields, {"B1_UM"      , _cUniMed  , Nil})
        aAdd(aFields, {"B1_LOCPAD"  , _cLocPad  , Nil})
        aAdd(aFields, {"B1_POSIPI"  , _cPosIpi  , Nil})
        aAdd(aFields, {"B1_ORIGEM"  , _cOrigem  , Nil})
        aAdd(aFields, {"B1_CODISS"  , _nCODISS  , Nil})
        aAdd(aFields, {"B1_IRRF"    , _niRRF    , Nil})
        aAdd(aFields, {"B1_INSS"    , _nINSS    , Nil})
        aAdd(aFields, {"B1_REDINSS" , _nREDINSS , Nil})
        aAdd(aFields, {"B1_PIS"     , _nPIS     , Nil})
        aAdd(aFields, {"B1_COFINS"  , _nCOFINS  , Nil})
        aAdd(aFields, {"B1_CSLL"    , _nCSLL    , Nil})
        aAdd(aFields, {"B1_TRIBMUN" , _nTRIBMUN , Nil})
        aAdd(aFields, {"B1_APROPRI" , _cApropri , Nil})
        aAdd(aFields, {"B1_RASTRO"  , _cRastro  , Nil})
        aAdd(aFields, {"B1_LOCALIZ" , _cLocaliz , Nil})
        aAdd(aFields, {"B1_CC"      , _cCCusto  , Nil})
    
        //Se conseguir executar a operação automática
        If FWMVCRotAuto(oModel, "SB1", _nOper, {{"SB1MASTER", aFields}} ,,.T.)
            lOk := .T. 
            nReg++
        Else
            lOk := .F.
        EndIf
        
        //Se não deu certo a inclusão, mostra a mensagem de erro
        If ! lOk
            //Busca o Erro do Modelo de Dados
            aErro := oModel:GetErrorMessage()
            
            //Monta o Texto que será mostrado na tela
            cMessage := "Id do formulário de origem:"  + ' [' + cValToChar(aErro[01]) + '], '
            cMessage += "Id do campo de origem: "      + ' [' + cValToChar(aErro[02]) + '], '
            cMessage += "Id do formulário de erro: "   + ' [' + cValToChar(aErro[03]) + '], '
            cMessage += "Id do campo de erro: "        + ' [' + cValToChar(aErro[04]) + '], '
            cMessage += "Id do erro: "                 + ' [' + cValToChar(aErro[05]) + '], '
            cMessage += "Mensagem do erro: "           + ' [' + cValToChar(aErro[06]) + '], '
            cMessage += "Mensagem da solução: "        + ' [' + cValToChar(aErro[07]) + '], '
            cMessage += "Valor atribuído: "            + ' [' + cValToChar(aErro[08]) + '], '
            cMessage += "Valor anterior: "             + ' [' + cValToChar(aErro[09]) + ']'
            
            //Mostra mensagem de erro
            lRet := .F.
            ConOut("Erro: " + cMessage)
            
        Else
            lRet := .T.
            ConOut("Produto excluido")
        EndIf
    EndIf
    
    //Desativa o modelo de dados
    oModel:DeActivate()

Return 

/*/{Protheus.doc} x_IncCod()/*/
Static Function x_IncCod(xGrp)
    Local cRet   	:= "" 
    Local aArea  	:= GetArea()
    Local cQry   	:= ""

    if select('TMP') > 0
        ('TMP')->(dbCloseArea())
    endif

    cQry += "SELECT MAX(B1_COD) ultCod "//cQry += "SELECT RIGHT(TRIM(B1_COD),10) AS NEWCOD "
    cQry += " FROM "+RetSQLName("SB1")+" AS A (NOLOCK) "
    cQry += " WHERE D_E_L_E_T_ = ' ' "
    cQry += " AND A.B1_GRUPO='"+alltrim(xGrp)+"' "    
    cQry += " AND A.B1_COD LIKE '"+alltrim(xGrp)+"%' "    

    cQry := ChangeQuery(cQry)
    
    TCQuery cQry New Alias "TMP"
    ('TMP')->(DbGotop())
    
    if !EMPTY(alltrim(('TMP')->ultCod))
        CRET := Soma1(alltrim(('TMP')->ultCod))
    Else
        cRet := xGrp+SUBSTR('0000000001',LEN(xGrp)+1) // NOVO CODIGO
    endif

    RestArea(aArea)

    ('TMP')->(dbCloseArea())
Return cRet
