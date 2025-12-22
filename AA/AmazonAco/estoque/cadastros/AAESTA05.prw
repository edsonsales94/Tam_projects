#include 'protheus.ch'
#include "Rwmake.ch"
#INCLUDE "TopConn.ch"

User Function  MATA311()

Local aParam := PARAMIXB
Local xRet := .T.
Local oObj := ''
Local cIdPonto := ''
Local cIdModel := ''
//Local lIsGrid := .F.
//Local nLinha := 0
//Local nQtdLinhas := 0
//Local cMsg := ''

If aParam <> NIL
	oObj := aParam[1]
	cIdPonto := aParam[2]
	cIdModel := aParam[3]
	If cIdPonto == 'BUTTONBAR'
	   //ApMsgInfo('Adicionando Botão na Barra de Botões (BUTTONBAR).' + CRLF + 'ID ' + cIdModel )
	   xRet := { {'Empenho', 'EMPENHO', { || LjkeyF8() }, 'Alimenta com base nas informações do Empenho' } }
    EndIf
Endif
//BUTTONBAR
return xRet


User function AAESTA05()

Private oBrowse
Private cCadastro  := "Transferência de Materiais"

Private aRotina := {}
Private oCliente
Private oTotal
Private cCliente := ""
Private nTotal := 0
Private bCampo := {|nField| FieldName(nField) }
Private aSize := {}
Private aInfo := {}
Private aObj := {}
Private aPObj := {}
Private aPGet := {}
Private bK_F8 := nil

Private oGet

// Retorna a área útil das janelas Protheus
aSize := MsAdvSize()
// Será utilizado três áreas na janela
// 1ª - Enchoice, sendo 80 pontos pixel
// 2ª - MsGetDados, o que sobrar em pontos pixel é para este objeto
// 3ª - Rodapé que é a própria janela, sendo 15 pontos pixel
AADD( aObj, { 100, 080, .T., .F. })
AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 100, 015, .T., .F. })
// Cálculo automático da dimensões dos objetos (altura/largura) em pixel
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPObj := MsObjSize( aInfo, aObj )
// Cálculo automático de dimensões dos objetos MSGET
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )
AADD( aRotina, {"Pesquisar" ,"AxPesqui" ,0,1})
AADD( aRotina, {"Visualizar" ,'U_fwSepMnt',0,2})
AADD( aRotina, {"Incluir" ,'U_fwSepInc',0,3})
AADD( aRotina, {"Alterar" ,'U_fwSepMnt',0,4})
AADD( aRotina, {"Excluir" ,'U_fwSepMnt',0,5})

dbSelectArea("NNS")
dbSetOrder(1)
dbGoTop()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('NNS')
oBrowse:SetDescription('Transferência de Materiais')//'Registro de Transferência de Materiais'
//Legendas
oBrowse:AddLegend( "NNS_STATUS == '1'", "GREEN"		, "Liberado" 		)//"GREEN"//"Liberado"
oBrowse:AddLegend( "NNS_STATUS == '2'", "RED"			, "Transferido" 	)//"Transferido"
oBrowse:AddLegend( "NNS_STATUS == '3'", "BLUE"		, "Em Aprovação" 	)//"Em Aprovação"
oBrowse:AddLegend( "NNS_STATUS == '4'", "YELLOW"		, "Rejeitado" 	)//"Rejeitado"

bK_F8:= SetKey(VK_F8,{|| LjkeyF6( ) })

oBrowse:Activate()

SetKey(VK_F8, nil)

Return

************************************************************************************************************************

User Function fwSepInc( cAlias, nReg, nOpc )
Local oDlg
//Local oGet
Local nX := 0
Local nOpcA := 0
Private aHeader := {}
Private aCOLS := {}
Private aGets := {}
Private aTela := {}

dbSelectArea( cAlias )
dbSetOrder(1)
For nX := 1 To FCount()
	IF  FieldName( nX ) = "NNS_COD"
		M->NNS_COD := GetSXENum("NNS","NNS_COD")
    ELSE 
		M->&( Eval( bCampo, nX ) ) := CriaVar( FieldName( nX ), .T. )
	ENDIF
Next nX

Mod3aHeader()
Mod3aCOLS( nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

EnChoice( cAlias, nReg, nOpc, , , , , aPObj[1])

@ aPObj[3,1],aPGet[1,4] SAY oTotal VAR nTotal PICTURE "@E 9,999,999,999.99" SIZE 70,7 OF oDlg PIXEL

oGet := MSGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4],2,"U_fwMod3LOk()",".T.","+NNT_PROD",.T., , , , , , , , , oDlg)
//oGet := MSGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4],nOpc,"U_Mod3LOk()",".T.","+NNT_PROD",.T., , , , , , , , , oDlg)
//oGetDados := MsGetDados():New(05, 05, 145, 195, 4,                        "U_LINHAOK", "U_TUDOOK", "+A1_COD", .T., {"A1_NOME"}, , .F., 200, "U_FIELDOK", "U_SUPERDEL", , "U_DELOK", oDlg)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIF( Mod3TOk().And.Obrigatorio( aGets, aTela ), ( nOpcA := 1, oDlg:End() ), NIL) },{|| oDlg:End() })

If nOpcA == 1 .And. nOpc == 3
    Mod3Grv( nOpc )
    ConfirmSX8()
Else
	RollBackSX8()
Endif

Return

************************************************************************************************************************

User Function fwSepMnt( cAlias, nReg, nOpc )
Local oDlg
//Local oGet
Local nX := 0
Local nOpcA := 0

Private aHeader := {}
Private aCOLS := {}
Private aGets := {}
Private aTela := {}
Private aREG := {}
Private lRefresh := .T.

if nOpc = 4 //Alteracao
	MsgAlert("Usuario sem permissão para realizar a operação!",cCadastro)
	return
Endif

if nOpc = 5 .And. NNS->NNS_STATUS != '1'//Exclusao
	MsgAlert("Ordem em separação, não pode ser excluida!",cCadastro)
	return
Endif

dbSelectArea( cAlias )
dbSetOrder(1)
For nX := 1 To FCount()
    M->&( Eval( bCampo, nX ) ) := FieldGet( nX )
Next nX

Mod3aHeader()
Mod3aCOLS( nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

EnChoice( cAlias, nReg, nOpc, , , , , aPObj[1])

oGet := MSGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4],nOpc,".T.",".T.","+NNT_PROD",.T., , , , , , , , , oDlg)
//oGetDados := MsGetDados():New(05, 05, 145, 195, 4,                        "U_LINHAOK", "U_TUDOOK", "+A1_COD", .T., {"A1_NOME"}, , .F., 200, "U_FIELDOK", "U_SUPERDEL", , "U_DELOK", oDlg)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| IIF( Obrigatorio( aGets, aTela ), ( nOpcA := 1, oDlg:End() ),NIL ) },{|| oDlg:End() })

If nOpcA == 1 .And. ( nOpc == 4 .Or. nOpc == 5 )
    Mod3Grv( nOpc, aREG )
Endif

Return

************************************************************************************************************************

Static Function Mod3aHeader()
Local aArea := GetArea()
Local nUsado := 0

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("NNT")

While !Eof() .and. SX3->X3_ARQUIVO == "NNT"
    If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
        nUsado++        
        Aadd(aHeader,{Trim(X3Titulo()),;
            SX3->X3_CAMPO,;
            SX3->X3_PICTURE,;
            SX3->X3_TAMANHO,;
            SX3->X3_DECIMAL,;
            SX3->X3_VALID,;
            "",;
            SX3->X3_TIPO,;
            "",;
            "" })
    EndIf
    DbSkip()
End

RestArea(aArea)

Return

************************************************************************************************************************

Static Function Mod3aCOLS( nOpc )
Local aArea := GetArea()
Local cChave := ""
Local cAlias := "NNT"
Local nI := 0

If nOpc <> 3
    cChave := NNS->NNS_COD
    dbSelectArea( cAlias )
    dbSetOrder(1)
    dbSeek( xFilial( cAlias ) + cChave )
    While !EOF() .And. NNT->( NNT_FILIAL +NNT_COD) == xFilial(cAlias)+ cChave
        AADD( aREG, NNT->( RecNo() ) )
        AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
        For nI := 1 To Len( aHeader )
            If aHeader[nI,10] == "V"
                aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
            Else
                aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
            Endif
        Next nI
        aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
        dbSkip()
    EndDo
Else

    AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
    For nI := 1 To Len( aHeader )
        aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
    Next nI
//    aCOLS[1, GdFieldPos("NNT_COD")] := M->NNS_COD
    aCOLS[1, Len( aHeader )+1 ] := .F.
Endif

Restarea( aArea )

Return

************************************************************************************************************************

User Function fwMod3LOk()
Local nI := 0
nTotal := 0

For nI := 1 To Len( aCOLS )
    If aCOLS[nI,Len(aHeader)+1]
        Loop
    Endif
    //nTotal+=Round(aCOLS[nI,GdFieldPos("ZA2_QTDVEN")]*aCOLS[nI,GdFieldPos("ZA2_PRCVEN")],2)
Next nI

//oTotal:Refresh()

Return(.T.)

************************************************************************************************************************

Static Function Mod3TOk()
Local nI := 0
Local lRet := .T.
Local cTpProd := IIF(M->NNS_TPSC $'P#R', 'D','I')
Local nPosP := GdFieldPos("NNT_PROD")

//Faz o check do material produtivo e improdutivo
For nI := 1 To Len(aCOLS)
    If aCOLS[nI, Len(aHeader)+1]
        Loop
    Endif
    
	If Posicione("SB1",1,xFilial("SB1")+aCOLS[nI,nPosP] ,"B1_APROPRI" ) <> cTpProd  .And. lRet
   		if cTpProd == 'D'
			//MsgBox("Produto: "+aCOLS[nI,nPosP] +", Não é Produtivo !!!","ALERT")
			MsgAlert("Produto: "+aCOLS[nI,nPosP] +", Não é Produtivo !!!",cCadastro)
		Elseif cTpProd == 'I'
			//MsgBox("Produto: "+aCOLS[nI,nPosP] +", Não é Improdutivo !!!","ALERT")
			MsgAlert("Produto: "+aCOLS[nI,nPosP] +", Não é Improdutivo !!!",cCadastro)
		Else
			//MsgBox("Produto: "+aCOLS[nI,nPosP] +", Sem Tipo Definido !!!","ALERT")
			MsgAlert("Produto: "+aCOLS[nI,nPosP] +", Sem Tipo Definido !!!",cCadastro)
		Endif
		//MsgAlert("Campo PRODUTO preenchimento obrigatorio",cCadastro)
        lRet := .F.
    Endif
    If !lRet
        Exit
    Endif
Next i
Return( lRet )

************************************************************************************************************************

Static Function Mod3Grv( nOpc, aAltera)
Local nX := 0
Local nI := 0
// Se for inclusão
If nOpc == 3
    // Grava os itens
    dbSelectArea("NNT")
    dbSetOrder(1)
    For nX := 1 To Len( aCOLS )
        If !(aCOLS[ nX, len(acols[nx]) ])
            RecLock( "NNT", .T. )
            For nI := 1 To Len( aHeader )
                FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ), aCOLS[nX,nI])
            Next nI
            NNT->NNT_FILIAL := xFilial("NNT")
            NNT->NNT_COD   := M->NNS_COD
            MsUnLock()
        Endif
    Next nX
    // Grava o Cabeçalho
    dbSelectArea( "NNS" )
    RecLock( "NNS", .T. )
	M->NNS_STATUS := '3'
    For nX := 1 To FCount()
        If "FILIAL" $ FieldName( nX )
            FieldPut( nX, xFilial( "NNS" ) )
        Else
            FieldPut( nX, M->&( Eval( bCampo, nX ) ) )
        Endif
    Next nX    
    MsUnLock()
	ProcSep() // Gerar registri na tabela de separação ACD.
Endif

// Se for alteração
If nOpc == 4
    // Grava os itens conforme as alterações
	MsgAlert("Usuario sem permissão para realizar a operação!",cCadastro)
        
Endif

// Se for exclusão
If nOpc == 5
    // Deleta os Itens
    dbSelectArea("NNT")
    dbSetOrder(1)
    dbSeek(xFilial("NNT") + M->NNS_COD)
    While !EOF() .And. NNT->(NNT_FILIAL + NNT_COD) == xFilial("NNT") + M->NNS_COD
        RecLock("NNT")
            dbDelete()
        MsUnLock()
        dbSkip()
    End
    // Deleta o Cabeçalho
    dbSelectArea("NNS")
    RecLock("NNS",.F.)
        dbDelete()
    MsUnLock()
Endif

Return

********************************************************************************************************************************
********************************************************************************************************************************
********************************************************************************************************************************


/*
   Objetivo.....: 
   Ponto de Entrada para Consulta Customizada de Produtos PA na Tela de Venda Solicitacao.
*/

Static Function LjKeyF8()

   Local xOP := Space(11)
   Local oSD4Tmp :=  FWTemporaryTable():New( )
   //Local xSD4 := ""
   Local aFSD4 := {}
   Local lMark := .T.
   Local xdMarca := GetMark()
   Local _xdI 
   Local xdQuant := 0
   //Local xRSD4 
   Private xProduto := ""
   Private xDescricao := ""
   Private oBrwSD4
   
   aAdd(aFSD4, {"D4_OK","C",2,0} )
   aAdd(aFSD4, {"D4_FILIAL","C",2,0} )
   aAdd(aFSD4, {"D4_OP","C",11,0} )
   aAdd(aFSD4, {"D4_DATA","D",8,0} )
   aAdd(aFSD4, {"D4_COD","C",20,0} )
   aAdd(aFSD4, {"D4_LOCAL","C",2,0} )
   aAdd(aFSD4, {"D4_QTBACK","N",12,2} )
   aAdd(aFSD4, {"D4_QTDEORI","N",12,2} )
   aAdd(aFSD4, {"D4_QUANT","N",12,2} )
   aAdd(aFSD4, {"D4_TRT","C",12,0} )
   aAdd(aFSD4, {"D4_LOTECTL","C",25,0} )

   oSD4Tmp:SetFields(aFSD4)
   oSD4Tmp:AddIndex("indice1",{"D4_OP","D4_COD","D4_LOCAL","D4_DATA"})
   oSD4Tmp:AddIndex("indice2",{"D4_COD","D4_LOCAL","D4_OP","D4_DATA"})

   oSD4Tmp:Create()

   Private xSD4 := oSD4Tmp:GetAlias()
   Private xRSD4 := oSD4Tmp:GetRealName()

   oModal  := FWDialogModal():New()       
   oModal:SetEscClose(.T.)
   oModal:setTitle("Nova OP")
   oModal:setSubTitle( OemToAnsi("Inclusão de uma Nova OP na Sequencia"))
     
   //Seta a largura e altura da janela em pixel
   oModal:setSize(450, 700)
 
   oModal:createDialog()
   oModal:addCloseButton(nil, "Fechar")
   oModal:addButtons( {{"","Confirmar",{|| _ProcSel(xSD4,xdMarca), oModal:oOwner:End() },"Selecionar OP",1,.T.,.T.}} )
   oContainer := TPanel():New( ,,, oModal:getPanelMain() )
   //oContainer:SetCss("TPanel{background-color : red;}")
   oContainer:Align := CONTROL_ALIGN_ALLCLIENT

   oFWLayer := FWLayer():New()
   oFWLayer:Init( oContainer, .F., .T. )
   oFWLayer:AddLine( 'LINE01', 30, .F. )  
   oFWLayer:AddLine( 'LINE02', 70, .F. )
   oFWLayer:AddCollumn( 'ALL', 100, .T., 'LINE01' )
   oFWLayer:AddCollumn( 'ALL', 100, .T., 'LINE02' )
   oPanelUp := oFWLayer:GetColPanel( 'ALL', 'LINE01' ) 
   oPanel02 := oFWLayer:GetColPanel( 'ALL', 'LINE02' )

   //df := aClone(aRotina)
   Private aRotina := {}
   //oTGet1 := TGet():New( 01,01,{||cTGet1},oContainer,096,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )
   oGet1 := TGet():New( 005, 005, { | u | If( PCount() == 0, xOP, xOP := u ) },oPanelUp, 080, 015, "!@",{|| _ValidOP(xOP,xRSD4) }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"xOP",,,,.T. ,,,"Ordem de Produção",1 )
   oGet1:cF3 := "SC2"
   oGet1 := TGet():New( 005, 090, { | u | If( PCount() == 0, xProduto, xProduto := u ) },oPanelUp, 060, 015, "!@",{|| .T./*ExistCpo()*/ }, 0, 16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"xProduto",,,,.T. ,,,"Produto",1 )
   oGet1 := TGet():New( 005, 160, { | u | If( PCount() == 0, xDescricao, xDescricaoOP := u ) },oPanelUp, 160, 015, "!@",{|| .T./*ExistCpo()*/ }, 0, 16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"xDescricao",,,,.T. ,,,"Descricao",1 )
   oGet1 := TGet():New( 030, 005, { | u | SC2->C2_QUANT },oPanelUp, 080, 015, "@e 999,999.99",{|| .T./*ExistCpo()*/ }, 0, 16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"xProduto",,,,.T. ,,,"Quantidade",1 )
   oGet1 := TGet():New( 030, 090, { | u | SC2->C2_QUJE  },oPanelUp, 080, 015, "@e 999,999.99",{|| .T./*ExistCpo()*/ }, 0, 16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"xProduto",,,,.T. ,,,"Produzida",1 )
   oGet1 := TGet():New( 030, 160, { | u | SC2->C2_QUANT - SC2->C2_QUJE },oPanelUp, 080, 015, "@e 999,999.99",{|| .T./*ExistCpo()*/ }, 0, 16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"xProduto",,,,.T. ,,,"Saldo",1 )
   oGet1 := TGet():New( 030, 240, { | u |if(PCount() == 0 ,xdQuant,xdQuant := u) },oPanelUp, 080, 015, "@e 999,999.99",{|| _ValidQuant(xdQUant)/*ExistCpo()*/ }, 0, 16777215,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F. ,,"xProduto",,,,.T. ,,,"Saldo",1 )

   oBrwSD4:= FWMBrowse():New() 
   oBrwSD4:SetOwner( oPanel02 ) 
   oBrwSD4:SetDescription( 'Empenho' ) 
   oBrwSD4:SetMenuDef( '' )
    //Referencia vazia para que nao exiba nenhum botao
   oBrwSD4:DisableDetails() 
   oBrwSD4:SetAlias( xSD4  ) 
   oColumn := oBrwSD4:AddMarkColumns({||If( (xSD4)->D4_OK==xdMarca,'LBOK','LBNO')},{|oBrowse|  _Mark(xSD4,xdMarca)  },{|oBrowse| _MarkAll(xSD4,xdMarca , lMark) , lMark = !lMark })
   //oBrwSD4:SetColumns({oColumn})
   //SX3->(dbSetOrder(2))
   For _xdI := 01 To Len(aFSD4)
        //If SX3->(dbSeek(aE1Col[_xdI]))
		If aFSD4[_xdI][01] == 'D4_QTBACK'
		   oColumn := FWBrwColumn():New()
            oColumn:SetData(&('{|| ' +xSD4 + '->'+aFSD4[_xdI][01] + ' }' ) )
            oColumn:SetTitle( "Qt. Solicitar" )
            oColumn:SetSize( 12 )
            oBrwSD4:SetColumns({oColumn})
        ElseIf aFSD4[_xdI][01] != 'D4_OK'
            oColumn := FWBrwColumn():New()
            oColumn:SetData(&('{|| ' +xSD4 + '->'+aFSD4[_xdI][01] + ' }' ) )
            oColumn:SetTitle( FWX3Titulo(aFSD4[_xdI][01]) )
            oColumn:SetSize( TamSx3(aFSD4[_xdI][01])[01] )
            oBrwSD4:SetColumns({oColumn})
        EndIf
        //EndIf
    Next
    oBrwSD4:SetProfileID('2')
    oBrwSD4:DisableDetails()
    oBrwSD4:DisableReport()
    oBrwSD4:SetDoubleClick({|xx,yy| _Mark(xSD4,xdMarca)})
    //oBrwSD4:AddFilter( "Titulos com Saldo" , 'E1_SALDO  > 0 ' , .T., )
    //oBrwSD4:AddFilter( "Bancários" , "E1_SITUACA $ '1,3,4,2,7' " , .T., )
    //oBrwSD4:AddFilter( "Em Carteira" , "E1_SITUACA == '0' " , .T., )
    //oBrwSD4:cleanprofile()
    oBrwSD4:Activate()
   /*
   oBrowse := FWMBrowse():New()
   oBrowse:SetAlias("SC2")
   //oBrowse:SetDataTable(.T.)
   oBrowse:SetFilterDefault("C2_RECURSO = ' ' .And. C2_DATRF=' ' ")     
   oBrowse:Activate(oContainer)
   */
   //TSay():New(1,1,{|| "Teste "},oContainer,,,,,,.T.,,,30,20,,,,,,.T.)         
   oModal:Activate()

Return //LjKeyF6()
Static Function _ProcSel(xTbl,xMarca)
   Local oModel := FWModelActive()
   Local oView := FwViewActive()
   Local lRefresh := .F.
   Local oGrid := if(oModel!=Nil,oModel:GetModel("NNTDETAIL"),Nil)

   (xTbl)->(dbGoTop())
   While !(xTbl)->(Eof())
      if(oGrid != Nil .And. (xTbl)->D4_OK == xMarca)
	    
		 oGrid:GoLine(oGrid:Length())
	     if !Empty(oGrid:GetValue("NNT_PROD"))
		     oGrid:AddLine()
		 EndiF
		 
		 oGrid:SetValue("NNT_FILORI",(xTbl)->D4_FILIAL)
		 oGrid:SetValue("NNT_PROD",Alltrim((xTbl)->D4_COD))
		 oGrid:SetValue("NNT_LOCAL",(xTbl)->D4_LOCAL)

		 oGrid:SetValue("NNT_PRODD",Alltrim((xTbl)->D4_COD))
		 oGrid:SetValue("NNT_FILDES",(xTbl)->D4_FILIAL)
		 oGrid:SetValue("NNT_LOCLD",(xTbl)->D4_LOCAL)
		 oGrid:SetValue("NNT_LOTECT",Alltrim((xTbl)->D4_LOTECTL))
		 oGrid:SetValue("NNT_QUANT",(xTbl)->D4_QTBACK)
		 lRefresh := .T.
	  EndIF
      (xTbl)->(dbSkip())
   EndDo
   If(lRefresh .And. oView != Nil)
      oView:Refresh()
   EndIf
Return

Static Function _ValidQuant(xQUant)

   Local lRet := .F.
   Local xArea := (xSD4)->(GetArea())

   lRet := xQuant > 0

   if lRet
      While !(xSD4)->(Eof())
	     (xSD4)->(RecLock(xSD4,.F.))
		    (xSD4)->D4_QTBACK := xQuant * (xSD4)->D4_QTDEORI / SC2->C2_QUANT
		 (xSD4)->(MsUnlock())
	     (xSD4)->(dbSkip())
	  EndDo
	  (xSD4)->(RestArea(xArea))
	  oBrwSD4:Refresh()
   EndIf
Return lRet

Static Function _ValidOP(xOP,xTabela)
   Local lRet  := .F.
   Local nRet

   SC2->(dbSetOrder(1))
   lRet := SC2->(dbSeek(xFilial('SC2') + xOP))
   TcSqlExec("Delete From " + xTabela)
   cc := (xSD4)->(RecCount())
   if(lRet)
     xProduto := SC2->C2_PRODUTO
	 xDescricao := Posicione('SB1',1,xFilial('SB1') + SC2->C2_PRODUTO,'B1_DESC')
	 xQry := ""
	 xQry += " Insert Into " + xTabela + "(D4_OK,D4_OP,D4_DATA,D4_COD,D4_LOCAL,D4_QTDEORI,D4_QUANT,D4_TRT,D4_LOTECTL,D4_QTBACK,D4_FILIAL)"
	 xQry += " Select '  ' D4_OK,D4_OP,D4_DATA,D4_COD,D4_LOCAL,D4_QTDEORI,D4_QUANT,D4_TRT,D4_LOTECTL,0 D4_QTBACK,D4_FILIAL
	 xQry += "  From " + RetSqlName("SD4") + " D4 "
	 xQry += "  Where D4_FILIAL = '" + xFilial("SD4") + "'"
	 xQry += "    And D4_OP = '" + xOP + "'"
	 xQry += "    And D4.D_E_L_E_T_ = '' "
	 nRet := TcSqlExec(xQry)
	//oBrwSD4:GoTop()
	 oBrwSD4:Refresh()
	 oBrwSD4:GoTop()
   EndIf
   ncc := (xSD4)->(RecCount())
Return lRet
Static Function _MarkAll(xTbl,xMark, lMark)

   (xTbl)->(dbGoTop())
   while !(xTbl)->(Eof())
      (xTbl)->(RecLock(xTbl,.F.)) 
        (xTbl)->D4_OK := If(lMark,"",xMark)
      (xTbl)->(MsUnlock())

      (xTbl)->(dbSkip())
   EndDo
Return 
Static Function _Mark(xTbl,xMark)

    (xTbl)->(RecLock(xSD4,.F.)) 
        (xTbl)->D4_OK := If((xTbl)->D4_OK == xMark,"",xMark)
    (xTbl)->(MsUnlock())

Return Nil

Static Function LjkeyF6
	Local cAlias := Alias()
	Local nOrd   := dbSetOrder()
	Local nReg   := Recno()
	Local lRet   := .f.
	
//    Local oFont3
    Local bOk
    Local bCancel
    Local cFile
	
	Local n_Codigo  := Space(15)
	Local c_Selecao := ""
	
    Local aStru
    
    Local aCampos:= { {"WK_COD"    ,, "Codigo"},;
		{"WK_DESC"   ,, "Descrição"},;
		{"WK_SALDO"   ,, "Saldo"},;
		{"WK_QE"   ,, "Qtd Embalagem"},;
		{"WK_QTD"   ,, "Qtd"} }		
	
 	Private cRotinax := Upper(ProcName(3))+"#"+Upper(ProcName(4))
	Private c_DescrPA   := Space(60)
	
    bK_F8 := nil
	
	If Select("wItem") > 0
		MsgBox("Ja existe uma sessao aberta em memoria!!!","ALERT")
		return lRet
	Endif

    aStru:= { {"WK_COD", "C", 15, 0 },;
	{"WK_DESC"   , "C",  30, 0 },; 
	{"WK_SALDO"  , "N",  14, 2 },;
	{"WK_QE" , "N",  14, 2 },;
    {"WK_QTD"    , "N",  14, 2 }}
	
	cFile:= CriaTrab(aStru,.t.)
	dbUseArea(.t.,,cFile,"wItem",.F.,.F.)
	
	
	Begin sequence
	
	Define Font oFnt3 Name "Ms Sans Serif" Bold
	
	Define msdialog oDlgMain Title "Consulta de Produtos" From 96,5 to 580,650 Pixel
	
	@035, 5 to 180,270 Of oDlgMain Pixel
	@180, 200 Say "CTR4+O -> Salvar e sair" Size 100,8 Of oDlgMain Pixel Font oFnt3

	@040, 15 Say "Codigo    :"  Size 35,8 Of oDlgMain  Pixel Font oFnt3
	@040, 50 msGet n_Codigo Picture "@!" Size 50,8  Pixel of oDlgMain F3 "SB1" VALID VallidCod(n_Codigo)
	
	@055, 15 Say "Descrição :"  Size 35,8 Of oDlgMain Pixel Font oFnt3
	@055, 50 Get c_DescrPA Picture "@!" Size 140,8 Pixel of oDlgMain WHEN .F. 
	
	@070,15 Button oButton PROMPT "Localizar" Of oDlgMain Pixel Action Localizar(@n_Codigo,@c_Selecao)
	

    oMarkX:= MsSelect():New("wItem",,,aCampos,.F.,,{90,1,(oDlgMain:nHeight-30)/2,(oDlgMain:nClientWidth-4)/2})
	
  	//@095, 15 Get c_Selecao Size 250,80 Of oDlgMain Pixel Font oFnt3 when .F. Memo
	
	bOk := {||Grava_Item(@c_Selecao),lRet:= .t.,oDlgMain:End()}
	bCancel := {||oDlgMain:End()}                                                
	
	Activate Msdialog oDlgMain On Init EnchoiceBar(oDlgMain,bOk,bCancel) Centered

	End Sequence
	
	dbSelectArea("wItem")
	dbCloseArea()
	Ferase(cFile+GetDBExtension())
	
	dbSelectArea(cAlias)
	dbSetOrder(nOrd)
	dbGoTo(nReg)
return lRet

**************************************************************************************************************

Static function VallidCod(n_Codigo)
Local lRet := .t.

c_DescrPA=Posicione("SB1",1,xFilial("SB1")+n_Codigo ,"B1_DESC" ) 

return lRet

**************************************************************************************************************

Static function Localizar(n_Codigo,c_Selecao)
	Local cAlias := Alias()
	Local nOrd   := dbSetOrder()
	Local aStru
    Local aCampos
    Local cFile
    Local lRet:= .t.
	Local oDlgNrFab,cMarca:= "X",n_Reg:=0,c_Titulo
	
	If !Empty(n_Codigo) // .Or. !Empty(c_Descr)
		aStru:= { {"WK_MARCA"  , "C",    1,0},;
		{"WK_COD"    , "C",   15,0},;
		{"WK_DESC"   , "C",   60,0},;
		{"WK_SALDO"  , "N",   14,2},;
		{"WK_QE" , "N",   14,2},;
		{"WK_QTD"    , "N",   14,2}}
		
		aCampos:= { {"WK_MARCA"  ,, " "},;
		{"WK_COD"    ,, "Codigo"},;
		{"WK_DESC"   ,, "Descrição"},;
		{"WK_SALDO"  ,, "Saldo"},;		
		{"WK_QE" ,, "Qtd Embalagem"},;		
		{"WK_QTD"    ,, "Qtd"}}
		
		cFile:= CriaTrab(aStru,.T.)
		dbUseArea(.t.,,cFile,"wNrFab",.F.,.F.)
		
		dbSelectArea("SB2")
		dbSetorder(1)

        //Se for PA busca estrutura de produto.
        if Posicione("SB1",1,xFilial("SB1")+n_Codigo ,"B1_TIPO" ) == 'PA'
            
            cQry := " WITH FILHOS  AS ( " 
            cQry += "    SELECT SG.G1_COD AS COD_PROD,  "
            cQry += "            B1P.B1_GRUPO AS GRUPO_PAI, B1P.B1_TIPO AS TIPO, SB.B1_COD AS B1_COD,  "
            cQry += "            SB.B1_DESC AS B1_DESC, SG.G1_COMP AS G1_COMP, SB.B1_GRUPO AS GRUPO_COMP, SB.B1_TIPO AS TIPO_COMP, SG.G1_QUANT AS QUANTIDADE,  "
            cQry += "            2 AS NIVEL  "
            cQry += "    FROM "+RetSqlName("SG1")+" (NOLOCK)SG INNER JOIN "+RetSqlName("SB1")+" (NOLOCK)SB  ON SB.B1_COD=SG.G1_COMP  "
            cQry += "                            INNER JOIN "+RetSqlName("SB1")+" (NOLOCK)B1P ON B1P.B1_COD=SG.G1_COD  "
            cQry += "    WHERE  SG.D_E_L_E_T_=' ' AND SB.D_E_L_E_T_=' ' AND B1P.D_E_L_E_T_=' '   "
            cQry += "    AND SG.G1_FIM > '"+DTOS(DDATABASE)+"' "
            cQry += "    GROUP BY SG.G1_COD, B1P.B1_DESC, B1P.B1_GRUPO, B1P.B1_TIPO, SB.B1_COD, SB.B1_DESC, SG.G1_COMP, SB.B1_GRUPO, SB.B1_TIPO, SG.G1_QUANT  "
            cQry += "    UNION ALL  "
            cQry += "        SELECT T2.COD_PROD,   "
            cQry += "            B1P.B1_GRUPO AS GRUPO_PAI, B1P.B1_TIPO  AS TIPO, X.G1_COD  AS B1_COD, SB.B1_DESC AS B1_DESC,  "
            cQry += "            X.G1_COMP, SB.B1_GRUPO AS GRUPO_COMP, SB.B1_TIPO  AS TIPO_COMP, X.G1_QUANT AS QUANTIDADE,  "
            cQry += "            NIVEL + 1  "
            cQry += "        FROM "+RetSqlName("SG1")+" (NOLOCK)X INNER JOIN [FILHOS] T2 ON T2.G1_COMP=X.G1_COD   "
            cQry += "                            INNER JOIN "+RetSqlName("SB1")+" (NOLOCK)SB ON SB.B1_COD=X.G1_COMP " 
            cQry += "                            INNER JOIN "+RetSqlName("SB1")+" (NOLOCK)B1P ON B1P.B1_COD=X.G1_COD  "
            cQry += "        WHERE X.D_E_L_E_T_=' ' AND B1P.D_E_L_E_T_=' '   "
            cQry += "        AND X.G1_FIM > '"+DTOS(DDATABASE)+"' "
            cQry += " )  "
            cQry += " SELECT FILHOS.*,S.B1_UM AS UM_COMP, B1_QE "
            cQry += " FROM FILHOS INNER JOIN "+RetSqlName("SB1")+" (NOLOCK)S ON FILHOS.G1_COMP=S.B1_COD   "
            cQry += " WHERE S.D_E_L_E_T_ = ''   "
            cQry += " AND S.B1_UM <> ' '   "
            cQry += " AND TIPO_COMP NOT IN ('B0')  "
            cQry += " AND COD_PROD LIKE '"+n_Codigo+"'   "
            cQry += " AND NIVEL = 2 "
            cQry += " ORDER BY COD_PROD, TIPO , B1_COD, G1_COMP,  NIVEL  "
            
            
            
          /*  	(cFile)->(DbAppend())
	(cFile)->WK_COD    := Substr(SB1T->B1_COD,1,15)
	(cFile)->WK_DESC   := SB1T->B1_DESC
	(cFile)->WK_QE     := SB1T->B1_QE
	(cFile)->WK_SALDO  := nSaldo
*/
        Else
            cQry := "SELECT * "
            cQry += "FROM "+RetSqlName("SB1")+" SB1 "
            cQry += "WHERE SB1.D_E_L_E_T_ <> '*' "           
            cQry += "  AND B1_FILIAL = '"+xFilial("SB1")+"' "
            cQry += "  AND B1_MSBLQL <> '1' "
            cQry += "  AND B1_COD = '"+n_Codigo+"' "
            cQry += "ORDER BY B1_COD, B1_DESC "
        Endif
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"SB1T",.T.,.T.)

		dbSelectArea("SB1T")		
		While !SB1T->(EOF())
		  Grv_Dados("wNrFab")
		  n_Reg++
		  SB1T->(DbSkip())
		Enddo
		SB1T->(dbCloseArea())
		
		wNrFab->(DbGotop())
		
		c_Titulo:= "Consulta de Produtos - Registros: "
		
		Define Msdialog oDlgNrFab Title c_Titulo From 96,1 to 450,1120 Pixel
		oMark:= MsSelect():New("wNrFab","WK_MARCA",,aCampos,.F.,@cMarca,{40,1,(oDlgNrFab:nHeight-50)/2,(oDlgNrFab:nClientWidth-4)/2})
		oMark:bAval:= {|| Chk_Selecao("wNrFab",oMark,cMarca)}      
		bCancel := {|| oDlgNrFab:End()}
		bOk := {||CarregaItem("wNrFab",@c_Selecao),oDlgNrFab:End()}                    
		Activate Msdialog oDlgNrFab On Init EnchoiceBar(oDlgNrFab,bOk,bCancel) Centered
		
		dbSelectArea("wNrFab")
		dbCloseArea()
		Ferase(cFile + GetDbExtension())

	Endif
	dbSelectArea(cAlias)
	dbSetOrder(nOrd)

	c_DescrPA   := Space(60)
	n_Codigo  := Space(15)
    
    wItem->(dbGoTop())

return lRet

*************************************************************************************************************

Static function Grv_Dados(cFile)
Local aArea := GetArea()
Local nSaldo:= 0
 
 nSaldo = SaldoSBF(Substr(SB1T->B1_COD,1,15))

	(cFile)->(DbAppend())
	(cFile)->WK_COD    := Substr(SB1T->B1_COD,1,15)
	(cFile)->WK_DESC   := SB1T->B1_DESC
	(cFile)->WK_QE     := SB1T->B1_QE
	(cFile)->WK_SALDO  := nSaldo
	//(cFile)->WK_SALDO  := SB2->(B2_QATU-B2_RESERVA)

RestArea(aArea)

return

**************************************************************************************************************

Static Function SaldoSBF(cProduto)
Local nSaldo := 0
Local cLOCRMA := StrTran( alltrim(getmv("MV_LOCRMA")), ",", "','" ) // Locacoes bloqueadas para solicitacao ao armazem

cQuery := " SELECT BF_FILIAL, BF_PRODUTO, BF_LOCAL, SUM(BF_QUANT - BF_EMPENHO) SALDO "
	cQuery += " FROM " + RetSQLName("SBF") + " SBF "
	cQuery += " WHERE D_E_L_E_T_ <> '*' "
	cQuery += " AND BF_FILIAL = '" + xFilial("SBF") + "' " 
	cQuery += " AND BF_LOCAL = 'N1' "
	cQuery += " AND BF_QUANT > 0 "
	cQuery += " AND BF_EMPENHO <> BF_QUANT "
	cQuery += " AND BF_LOCALIZ <> 'REC' "
	cQuery += " AND BF_PRODUTO = '"+cProduto+"' "
	if M->NNS_TPSC == 'R'
		cQuery += " AND BF_LOCALIZ IN ('"+cLOCRMA+"') "
	Else
		cQuery += " AND BF_LOCALIZ NOT IN ('"+cLOCRMA+"') "
	Endif
	cQuery += " GROUP BY BF_FILIAL, BF_PRODUTO, BF_LOCAL " 
		
	TCQUERY cQuery NEW ALIAS "TMP" 
		
	nSaldo := TMP->SALDO

	TMP->(dbCloseArea())	

return nSaldo

**************************************************************************************************************

Static function Chk_Selecao(cFile,oMark,cMarca)
	Local c_Descr  := (cFile)->WK_DESC
	Local c_Saldo  := (cFile)->WK_SALDO
	Local c_Qe     :=(cFile)->WK_QE
    Local c_cod    := (cFile)->WK_COD
	Local c_Quant  := 0 //(cFile)->WK_PED

	@ 96,5 to 320,680 Dialog oQuant Title "Quantidade"
	@ 10,5 to 90,350
	
	@015, 15 Say "Codigo"
	@015, 50 Get c_Cod  when .f.
	
	@030, 15 Say "Produto"
	@030, 50 Get c_Descr  when .f.
	
	@045, 15 Say "Saldo"
	@045, 50 Get c_Saldo PICTURE "@E 9,999,999.99" Size 60,8 when .f.

    @060, 15 Say "Qtd.Embalagem"
	@060, 50 Get c_Qe PICTURE "@E 9,999,999.99" Size 60,8 when .f.
    
	@075, 15 Say "Quantidade"
	@075, 50 Get c_Quant PICTURE "@E 9,999,999.99" Size 60,8 when .T.

	@090,80 Button "Confirmar" Size 40,15 Action MntQuant(cFile,c_Quant)
	
	Activate Dialog oQuant Centered

return nil

**************************************************************************************************************

Static function MntQuant(cFile,c_Quant)
Local lRet := .T.

        If !(cFile)->(Eof()).or. (cFile)->(Bof())
			If (cFile)->WK_MARCA = "X"
                (cFile)->WK_MARCA:= " "
                (cFile)->WK_QTD:= 0
				Close(oQuant)
            Else
				if ( c_Quant <> 0 .And. c_Quant <= (cFile)->WK_SALDO )
					(cFile)->WK_MARCA:= "X"
					(cFile)->WK_QTD:= c_Quant
					Close(oQuant)
				Else
					lRet := .F.
				Endif
            Endif
        Endif


return lRet

**************************************************************************************************************

Static function CarregaItem(cFile,c_Selecao)
	Local cAlias := Alias()
	Local nOrd   := dbSetOrder()
	
	//- Cadastro de produtos
	dbSelectArea("SB1")
	DbSetorder(1)
	
	(cFile)->(DbGotop())
	
	Do while !(cFile)->(Eof())
		If Empty((cFile)->WK_MARCA)
			(cFile)->(Dbskip())
			Loop
		Endif
		wItem->(DbAppend())
		wItem->WK_COD    := (cFile)->WK_COD
		wItem->WK_DESC   := (cFile)->WK_DESC
        wItem->WK_SALDO  := (cFile)->WK_SALDO
        wItem->WK_QE := (cFile)->WK_QE
        wItem->WK_QTD    := (cFile)->WK_QTD

		//- Produtos
		SB1->(Dbseek(xFilial("SB1") + wItem->WK_COD))
		
		c_Selecao:= c_Selecao + ;
		PADR(SB1->B1_COD,15) + "  " + ;
		PADR(SB1->B1_DESC,30) + "  "

		(cFile)->(Dbskip())
	Enddo
	dbSelectArea(cAlias)
	dbSetOrder(nOrd)
return

**************************************************************************************************************

Static function Grava_Item(c_Selecao)
	Local cAlias    := Alias()
	Local nOrd      := dbSetOrder()
	Local nUsado
	Local lMaisDeUm := .F.
	Local nPosProd  := 0
	Local nPCod     :=  GdFieldPos("NNT_PROD")
	Local nI        := 0

	wItem->(Dbgotop())
	
	If wItem->(Eof())
		dbSelectArea(cAlias)
		dbSetOrder(nOrd)
		Return
	Endif
	
	//- Produtos
	dbSelectArea("SB1")
	dbSetOrder(1)
	lMaisDeUm:= !Empty(aCols[1,3])
	nUsado:= Len(aCols[1])-1   

	wItem->(Dbgotop())
	Do while !wItem->(Eof())
		
		If SB1->(Dbseek(xFilial("SB1")+wItem->WK_COD))
	
			//Verifica se ja existe no aCols o produto
			nPosProd := Ascan(aCols,{|x| Upper(Alltrim(x[nPCod]))==Alltrim(wItem->WK_COD)})
			If nPosProd > 0
				if aCols[nPosProd][nUsado+1]
					aCOLS[nPosProd, GdFieldPos("NNT_QUANT")] := wItem->WK_QTD	
					aCols[nPosProd][nUsado+1] := .F.
				Else
					aCOLS[nPosProd, GdFieldPos("NNT_QUANT")] += wItem->WK_QTD
				Endif
				nTam := Len(aCols)
			else
				If lMaisDeUm
					AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
				Endif
				
				nTam := Len(aCols)

				For nI := 1 To Len( aHeader )
					aCOLS[nTam, nI] := CriaVar( aHeader[nI, 2], .T. )
				Next nI
				aCOLS[nTam,Len(aHeader)+1] := .F.
				
				aCols[nTam,nUsado+1] := .F.

				lMaisDeUm := .T.
		
				aCOLS[nTam, GdFieldPos("NNT_PROD")]  := wItem->WK_COD
				aCOLS[nTam, GdFieldPos("NNT_UM")]    := SB1->B1_UM
				aCOLS[nTam, GdFieldPos("NNT_QUANT")] := wItem->WK_QTD
				aCOLS[nTam, GdFieldPos("NNT_DESC")]  := SB1->B1_DESC
				aCOLS[nTam, GdFieldPos("NNT_PRODD")]  := wItem->WK_COD
				aCOLS[nTam, GdFieldPos("NNT_UMD")]    := SB1->B1_UM
	//			NNT_LOCALI
	//			NNT_LOTECT
	//			NNT_DTVALI
			Endif
		Endif
  		n := nTam   
		
        oBrowse:lDisablePaint := .F.
		oBrowse:Refresh(.T.)
		//oGet(): ForceRefresh ( )
		
		wItem->(Dbskip())
	Enddo

	c_Selecao:= ""
	dbSelectArea(cAlias)
	dbSetOrder(nOrd)

return

****************************************************************************************

******************************************************************************************************************************************************************************************************

Static Function ProcSep()
Local cQuery   := ""
Local aReg     := {}
Local nQtdPed  := 0
Local nQtd     := 0
Local lErro    := .F.
Local cProduto := ""
Local nx       := 0
Local cLOCRMA := StrTran( alltrim(getmv("MV_LOCRMA")), ",", "','" ) // Locacoes bloqueadas para solicitacao ao armazem

for nx:=1 to len(aCols)
	If aCOLS[ nX, len(acols[nx]) ]
		Loop
	Endif
	cProduto  := aCOLS[nx, GdFieldPos("NNT_PROD")]
	nQtdPed   := aCOLS[nx, GdFieldPos("NNT_QUANT")]

	cQuery := " SELECT BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOCALIZ, BF_LOTECTL, BF_QUANT, BF_EMPENHO, (BF_QUANT - BF_EMPENHO) SALDO, R_E_C_N_O_ BF_RECNO "
	cQuery += " FROM " + RetSQLName("SBF") + " SBF "
	cQuery += " WHERE D_E_L_E_T_ <> '*' "
	cQuery += " AND BF_FILIAL = '" + xFilial("SBF") + "' " 
	cQuery += " AND BF_LOCAL = 'N1' "
	cQuery += " AND BF_QUANT > 0 "
	cQuery += " AND BF_EMPENHO <> BF_QUANT "
	cQuery += " AND BF_LOCALIZ <> 'REC' "
	if M->NNS_TPSC == 'R'
		cQuery += " AND BF_LOCALIZ IN ('"+cLOCRMA+"') "
	Else
		cQuery += " AND BF_LOCALIZ NOT IN ('"+cLOCRMA+"') "
	Endif
	cQuery += " AND BF_PRODUTO = '"+cProduto+"' "
	cQuery += " ORDER BY BF_LOTECTL, SUBSTRING(BF_LOCALIZ,2,LEN(BF_LOCALIZ)), BF_LOCALIZ " 
		
	TCQUERY cQuery NEW ALIAS "TMP" 
		
	While TMP->(!Eof()) .And. nQtdPed > 0
		IncProc()		
		if ( nQtdPed >= TMP->SALDO )
			nQtd := TMP->SALDO
			nQtdPed -= nQtd
		Else
			nQtd := nQtdPed
			nQtdPed = 0
		Endif
		AAdd(aReg,{TMP->BF_PRODUTO, nQTd, TMP->BF_LOCALIZ, TMP->BF_LOTECTL, BF_RECNO})
		TMP->(dbSkip())
	EndDo	      
	if nQtdPed > 0 // Nao tem saldo suficiente para o pedido 
		lErro := .T.
	Endif
	TMP->(dbCloseArea())	
Next

if lErro
	MsgAlert("Nao existe saldo suficiente para atender a Solicitação!")        	
	Return(.T.)
Endif                                 

//Grava registro de separacao 
GERPRESEP(aReg)

Return(Nil)

****************************************************************************************************************************************

//Criado registro na tabela de controle de Separação para controlar transferencia via coletor
Static Function GERPRESEP(aReg)
//[produto, quantidade, localizacao, lote, RECNO]
Local nQtdReg := 0
Local cCB7Cod := ""
Local nx

cCB7Cod := GetSX8Num("CB7","CB7_ORDSEP")
ConfirmSX8()
    
   for nx:=1 to len(aReg)
     RecLock("CB8",.T.)
	    CB8_FILIAL := xFilial("CB8") 
	    CB8_ORDSEP := cCB7Cod
	    CB8_ITEM   := '01'
	    CB8_PROD   := aReg[nx][1]//NNT->NNT_PROD
	    CB8_LOCAL  := 'N1'
	    CB8_QTDORI := aReg[nx][2]//NNT->NNT_QUANT
	    CB8_SALDOS := aReg[nx][2]//NNT->NNT_QUANT
	    CB8_SALDOE := 0
	    CB8_LCALIZ := aReg[nx][3]//NNT->NNT_LOCALI
	    CB8_SEQUEN := '01'
	    CB8_LOTECT := aReg[nx][4]//NNT->NNT_LOTECT
	    CB8_SALDOD := 0
	    CB8_QTECAN := 0
	    CB8_CFLOTE := '1'
	    CB8_TIPSEP := '1'
	    CB8_SLDPRE := aReg[nx][2]//NNT->NNT_QUANT
     MsUnLock()
                                       
	//Empenha produto para nao utilizacao 
	SBF->(DbGoto(aReg[nx][5]))
	GravaBFEmp("+",aReg[nx][2],"F",.T.,0)
	
    nQtdReg++       
   Next      
   
    RecLock("CB7",.T.)
	    CB7_FILIAL := xFilial("CB7")
	    CB7_ORDSEP := cCB7Cod       
	    CB7_DTEMIS := ddatabase
	    CB7_LOCAL  := 'N1'
	    CB7_HREMIS := SUBSTR(TIME(),1,5)
	    CB7_STATUS := '0'
	    CB7_PRIORI := '1'
	    CB7_ORIGEM := '1'
	    CB7_TIPEXP := '00*10*'
	    CB7_NUMITE :=  nQtdReg //NUMERO DE ITENS
		CB7_NUMSOL := M->NNS_COD
   MsUnLock()       

return

****************************************************************************************************************************************
