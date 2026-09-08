#include "protheus.ch"
#include "tbiconn.ch"
#Include "TOPCONN.CH"

/*Marcio macedo  Desenvolvimento 
  Bruno pacheco  Testes e validacoes.

15/04/2021*/ 

User Function KOFATP01()
Local oDlg
Local oBtn1, oBtn2, oBtn3, oBtn4
Local oFont     :=TFont():New("Arial",,24,,.T.,,,,.T.,.F.)
Private cNomArq := "", cCmpArq := "", oSayTrN		// Variáveis do arquivo a ser importado

	DEFINE MSDIALOG oDlg TITLE "Importação do preço de vendas - BAJAJ--" FROM C(0),C(0) TO C(200),C(450) PIXEL

	@ C(020),C(010) Say "Arquivo a ser importado:" of oDlg Pixel
	oSayTrN := tSay():New(C(030),C(010),{|| iif(Empty(cNomArq),'não há arquivo vinculado',cNomArq)},oDlg,,oFont,,,,.T.,CLR_BLUE,,200,20)

	oBtn1:=tButton():New(C(050),C(010),'Vincular Docto',oDlg,{|| if(fVincArq(),oBtn2:Enable(),)},50,20,,,,.T.) 
	oBtn2:=tButton():New(C(050),C(060),'Visualiz. Docto',oDlg,{||fVisualArq()},50,20,,,,.T.) 

	oBtn3:=tButton():New(C(050),C(120),'Iniciar Importação',oDlg,{||Valida(oDlg)},50,20,,,,.T.) 
	oBtn4:=tButton():New(C(050),C(170),'Fechar',oDlg,{||oDlg:End()},50,20,,,,.T.) 

	ACTIVATE MSDIALOG oDlg CENTERED 
Return Nil

************************************************************************************************************************************************

Static Function Valida(oDlg)
Local   cDirTmp  := GetTempPath()
Local   cArqLog  := 'importacao_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
Private nImports := 0
Private nUpdates := 0
Private nLin     := 0
Private aTotal   := {}
Private nErro    := 0
Private cCodTab  := ""
Private cItem    := ""
Private cMsgSB1  := ""


	if Empty(cCmpArq)
		MsgAlert('Favor, selecione um arquivo para a importação dos dados','Consistência')
		Return Nil
	endif

   	if ! File(cCmpArq)
		MsgAlert('O arquivo '+cCmpArq+' não foi encontrado!','Consistência')
		Return Nil
	endif

	Processa( { || Importa() }  ,"Aguarde... Lendo informações"   ,"Iniciando processo...")
	//Caso encontre algum erro de strutura do arquivo excel.
	if nErro = 1
		Return Nil
	Endif
	
	Processa( { || GRVPreco() },"Aguarde... Gravando informações","Iniciando processo...")

	MsgInfo("O processo de importação dos dados foi concluído."+CHR(13)+" Foram Inseridos " + Alltrim(Str(nImports))+ " Novos registros." ;
  +CHR(13)+" Foram Atualizados " + Alltrim(Str(nUpdates))+ " registros." ;
  +CHR(13)+"Processo Concluído")
	oDlg:End()

  
    // MemoWrite(cDirTmp + cArqLog, cMsgSB1)
    // ShellExecute('OPEN', cArqLog, '', cDirTmp, 1)
Return

***********************************************************************************************************************************************

Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     

	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf
Return Int(nTam)

******************************************************************************************************************************************************

Static Function fVincArq()
	cCmpArq := cGetFile('Arquivos CSV|*.CSV' , 'Selecione o Arquivo a ser importado, formato CSV',1,'C:\',.F.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE)

    if Empty(cCmpArq)
    	Return .F.
    endif

	cNomArq := fNomArq(cCmpArq, "\")	// Retorna o nome do arquivo

	oSayTrN:SetText(cNomArq)
	oSayTrN:Refresh()
Return .T.

***********************************************************************************************************************************************

Static Function fNomArq(cPar, cToken)
Local nPos  := 0
Local cFile := ""

	if (nPos := RAT(cToken, StrTran(cPar,"/","\"))) != 0
		cFile := SubStr(cPar, nPos+1)
	endif
Return cFile

***********************************************************************************************************************************************

Static Function fVisualArq()

	if !Empty(cCmpArq) .and. File(cCmpArq)	// Exibe arquivo não salvo
		ShellExecute("open",cCmpArq,"","",1)
		Return .T.
	endif
Return Nil

***********************************************************************************************************************************************

Static Function Importa()
Local cLinha  := ""
Local nMax    := 0
Local lCabec  := .T.
Local aErros  :={}

  if File(cCmpArq)

    if FT_FUSE(cCmpArq) == -1
    	MsgAlert('Não foi possível abrir o arquivo '+cCmpArq,'Erro')
    	Return Nil
    endif

     nMax := FT_FLASTREC()
     ProcRegua(nMax)
     FT_FGOTOP()

     nMax := Alltrim(Str(nMax))

    While !FT_FEOF()
        cLinha := FT_FREADLN()

        IncProc(Str(nImports) + "/" + nMax)

        aTmp  := STRTOKARR2(cLinha,";")
        
        // if len(aTmp) <> 13
        //     nErro := 1
        //     //                                                                                 1      2        3         4         5        6           7          8          9       10     11       12          13                           
        //     MsgAlert('Planilha com Strutura Incorreta! '+CHR(13)+'Erro Linha : '+Str(nImports+1)+CHR(13)+'Strutura Padrao:'+CHR(13)+' ITEM | TAB | NOME_TAB | CODIGO | CLIENTE | PRODUTO | CODCLIENT | DESCRICAO | PRI_UN | PRECO | PGTO | VIGENCIA | DTINICIO' ,'Erro')
        //     Return Nil
        // endif
        
        if ! lCabec
          //Verifica se Produto existe na tabela SB1 
          if Empty(Alltrim(aTmp[2]))
              cMsgProc  :="Erro :"+" produto não informado. linha : "+cValToChar(nLin)+" | "+cLinha
              cDocProc  :="-Arq.:"+cCmpArq
              aadd(aErros,{"KOFATP01"/*Rotina*/,cDocProc/*Doc*/,cMsgProc/*Mensagem*/,FwTimeStamp(3)/*Data Hora*/})
          elseif !SB1->(DbSeek(xFilial("SB1")+PadR(Alltrim(aTmp[2]),TamSx3("B1_COD")[1]))) 
              cMsgProc  :="Erro : Produto não encontrado "+Alltrim(aTmp[2])+". linha : "+cValToChar(nLin)+" | "+cLinha 
              cDocProc  :="-Arq.:"+cCmpArq
              aadd(aErros,{"KOFATP01"/*Rotina*/,cDocProc/*Doc*/,cMsgProc/*Mensagem*/,FwTimeStamp(3)/*Data Hora*/})
          else  
            aadd(aTotal, {	Alltrim(aTmp[2]),;                 // 1- Produto
                  aTmp[1],;                                  // 2 - TAB DE PRECO
                  val( StrTran(StrTran(aTmp[4],".",""),",",".") ),; // 3 -Preco de Venda
                  CTOD(Alltrim(aTmp[3])),;   // 4- VIGENCIA  
                  aTmp[5]})                  // 5 - UF                                  
          Endif 
        Endif
        lCabec := .F.  
        nImports++

        FT_FSKIP()
        nLin++
    enddo
    FT_FUSE()

    if Len(aErros)>0
        BoxMsgErro(aErros,"BAJAJ")
    endif

	else
		cMsg := 'O arquivo ['+cCmpArq+'] não foi encontrado, verifique!'
		MsgAlert(cMsg,'Arquivo não encontrado')
	endif
Return Nil

***********************************************************************************************************************************************

Static Function GRVPreco()
Local nI
Local nMax := Len(aTotal)

 
 
nImports := 0
	
	ProcRegua(nMax)
  
  //InsertDA0() // grava DA0 e DA1
  
  //Atualiza preco de venda 

cQuery := " SELECT top 1 *  "
cQuery += " FROM "+RetSqlName("DA0")+" A, "+RetSqlName("DA1")+" B "
cQuery += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' "
cQuery += " AND DA0_FILIAL = DA1_FILIAL "
cQuery += " AND DA0_CODTAB = DA1_CODTAB "
cQuery += " AND DA0_CODTAB = '"+aTotal[1][2]+"' "
cQuery += " ORDER BY DA1_ITEM desc "
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias DA0TMP New 
dbSelectArea("DA0TMP")
DA0TMP->(Dbgotop())
cItem:= DA0TMP->DA1_ITEM
DA0TMP->(dbClosearea())

DbSelectArea("DA1")
DA1->(dbSetOrder(7))

for nI := 1 to Len(aTotal)
    cCodTab  := aTotal[nI][2]
    cProduto := PADR(aTotal[nI][1], 20) 
    cEstado  := PADR(aTotal[nI][5], 2)   

    IncProc(Str(nI) + "/" + Alltrim(Str(nMax)))
    cItem := SOMA1(cItem)

    if DbSeek(xFilial("DA1") + cCodTab + cProduto + cEstado)
        Reclock("DA1", .F.)
            DA1_PRCVEN := aTotal[nI][3]
            DA1_DATVIG := aTotal[nI][4]
            DA1_TIPPRE := "1"
            DA1_ESTADO := aTotal[nI][5]
        DA1->(MsUnlock())
        nUpdates++
    Else
       Reclock("DA1",.T.)
          DA1_PRCVEN := aTotal[nI][3]
          DA1_DATVIG := aTotal[nI][4]
          DA1_FILIAL := xfilial("DA1")
          DA1_ITEM   := SOMA1(cItem)
          DA1_CODTAB := cCodTab          
          DA1_CODPRO := cProduto
          DA1_ESTADO := cEstado
          DA1_ATIVO  := "1"
          DA1_TPOPER := "4"
          DA1_QTDLOT := 999999.99
          DA1_INDLOT := "000000000999999.99"
          DA1_MOEDA  := 1
          DA1_TIPPRE := "1"
				DA1->(MsUnlock())
        nImports ++
    Endif
  Next 

DA1->(dbClosearea())

Return nil

************************************************************************************************************************************

Static Function InsertDA0() 
Local lDA0 := .T.
Private nSaldo,nMedio,aSaldo
    

cQuery := " SELECT *  "
cQuery += " FROM "+RetSqlName("DA0")+" A, "+RetSqlName("DA1")+" B "
cQuery += " WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' "
cQuery += " AND DA0_FILIAL = DA1_FILIAL "
cQuery += " AND DA0_CODTAB = DA1_CODTAB "
cQuery += " AND DA0_CODTAB = '"+aTotal[1][1]+"' "
cQuery += " ORDER BY DA1_ITEM "

cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias DA0TMP New 

dbSelectArea("DA0TMP")

DA0TMP->(Dbgotop())
Do While !DA0TMP->(Eof())

  If lDA0 // primeiro regitros 
    cCodTab :=  GetSxeNum('DA0','DA0_CODTAB')
    ConfirmSx8()

    RecLock("DA0", .T.)		
      DA0_CODTAB := cCodTab
      DA0_DESCRI := DA0TMP->DA0_DESCRI
      DA0_DATDE  := aTotal[1][5]
      DA0_HORADE := DA0TMP->DA0_HORADE
      DA0_DATATE := stod(DA0TMP->DA0_DATATE)
      DA0_HORATE := DA0TMP->DA0_HORATE
      DA0_CONDPG := DA0TMP->DA0_CONDPG
      DA0_TPHORA := DA0TMP->DA0_TPHORA
      DA0_ATIVO  := DA0TMP->DA0_ATIVO
      DA0_FILIAL := DA0TMP->DA0_FILIAL
    MsUnlock()
    lDA0 := .F.
  Endif

  RecLock("DA1", .T.)		    
    DA1_FILIAL := DA0TMP->DA1_FILIAL
    DA1_ITEM   := DA0TMP->DA1_ITEM
    DA1_CODTAB := cCodTab
    DA1_CODPRO := DA0TMP->DA1_CODPRO
    DA1_PRCVEN := DA0TMP->DA1_PRCVEN
    DA1_VLRDES := DA0TMP->DA1_VLRDES
    DA1_PERDES := DA0TMP->DA1_PERDES
    DA1_ATIVO  := DA0TMP->DA1_ATIVO
    DA1_FRETE  := DA0TMP->DA1_FRETE
    DA1_ESTADO := DA0TMP->DA1_ESTADO
    DA1_TPOPER := DA0TMP->DA1_TPOPER
    DA1_QTDLOT := DA0TMP->DA1_QTDLOT
    DA1_INDLOT := DA0TMP->DA1_INDLOT
    DA1_MOEDA  := DA0TMP->DA1_MOEDA
    DA1_DATVIG := stod(DA0TMP->DA1_DATVIG)
    DA1_GRUPO  := DA0TMP->DA1_GRUPO
    DA1_REFGRD := DA0TMP->DA1_REFGRD
    DA1_PRCMAX := DA0TMP->DA1_PRCMAX
    DA1_CODCLI := DA0TMP->DA1_CODCLI
    DA1_LOJACL := DA0TMP->DA1_LOJACL
    DA1_ITEMGR := DA0TMP->DA1_ITEMGR
    DA1_DTUMOV := stod(DA0TMP->DA1_DTUMOV)
    DA1_HRUMOV := DA0TMP->DA1_HRUMOV
    DA1_ECDTEX := DA0TMP->DA1_ECDTEX
    DA1_ECSEQ  := DA0TMP->DA1_ECSEQ
    DA1_HREXPO := DA0TMP->DA1_HREXPO
    DA1_TIPPRE := DA0TMP->DA1_TIPPRE
  MsUnlock()
  
  cItem := DA0TMP->DA1_ITEM 
  DA0TMP->(dbSkip())
Enddo
DA0TMP->(dbClosearea())

Return NIl


/* Tela Final de Processamento em caso de erro
   Lista os erros ocorridos no final do processo
*/

Static Function BoxMsgErro( xMsg, cTitulo, cLabel, aButtons, bValid, lQuebraLinha )
    Local ix 
    local oDlg
    local oMemo
    local oFont             := TFont():New("Courier New",09,15)
    local cMsg              := ""

    Local nJanAltu   := 350
    Local nJanLarg   := 250

    default xMsg            := ""
    default cTitulo         := ""
    default cLabel          := ""
    default aButtons        := {}
    default bValid          := {|| .T. }
    default lQuebraLinha    := .F.

    cMsg += " Geração Realizada Por    : "+Alltrim(UsrFullName(RetCodUsr()))+CRLF
    cMsg += "__________________________________________________________________ " + CRLF

    If ValType(xMsg) = "C"
        cMsg := xMsg
    ElseIf ValType(xMsg) = "A"
        for ix:=1 to len(xMsg)
            cMsg += " Geração Realizada Em     : "+xMsg[ix][4]+CRLF
            cMsg += " Rotina                   : "+xMsg[ix][1]+CRLF
            cMsg += " Documento                : "+xMsg[ix][2]+CRLF
            cMsg += " Mensagem                 : "+xMsg[ix][3]+CRLF
            cMsg += "__________________________________________________________________ " + CRLF
        Next
    EndIf

    oDlg:= FWDialogModal():New()
    oDlg:SetEscClose(.F.)
    oDlg:setTitle(cTitulo)
    oDlg:setSubTitle(cLabel )

    //Seta a largura e altura da janela em pixel
    oDlg:setSize(nJanLarg,nJanAltu)

    oDlg:createDialog()
    oDlg:addCloseButton(nil, "Fechar")
    oDlg:AddButton( 'Salvar', {||openNotePa( .f., cMsg, "log.txt" )}, 'Salvar', , .T., .F., .T., )

    oPanel := TPanel():New( ,,, oDlg:getPanelMain() )
    oPanel:Align:= CONTROL_ALIGN_ALLCLIENT

    @ 05,05 To 190,330 Label cLabel Pixel Of oPanel
    @ 10,10 Get oMemo Var cMsg MEMO HSCROLL FONT oFont Size 315,175 READONLY Of oPanel  Pixel

    oMemo:lWordWrap := lQuebraLinha
    oMemo:EnableVScroll(.t.)
    oMemo:EnableHScroll(.t.)

    oDlg:Activate()


return

// /*gera log txt no temp e abre no notepad*/
// Static Function openNotePa(lApaga,cMsg,cFile)

//     Local lRet:=.t., cDir:=GetWinDir()+"\Temp\",hFile

//     Default lApaga := .f. // Se .t. apaga arquivo temporário.
//     Default cFile  := "log.txt"

//     Begin Sequence

//         If !lApaga
//             hFile := fCreate(cDir+cFile)

//             fWrite(hFile,cMsg,Len(cMsg))

//             fClose(hFile)

//             WinExec("NotePad "+cDir+cFile)
//         Else
//             If File(cDir+cFile)
//                 fErase(cDir+cFile)
//             EndIf
//         EndIf

//     End Sequence

// Return lRet
