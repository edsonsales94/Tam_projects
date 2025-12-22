#INCLUDE "totvs.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"


User Function AAPCPC05()
Return
User Function MTA610MNU()
   aAdd(aRotina,{"Sequencia de Recurso","VIEWDEF.AAPCPC05"  , 0 , 4, 0, .F.})

Return NIl

User Function AAPCPC5V
   nOK := (FWExecView ("Visualizacao", "AAPCPC05",  MODEL_OPERATION_VIEW,,{||.T.},,,,,,,))
Return Nil

Static Function ModelDef()
    Local oStruM  := FWFormStruct( 1, 'SH1' )
    Local oStruD1 := FWFormStruct( 1, 'SC2' ,{|x| Alltrim(x)$"C2_NUM,C2_ITEM,C2_SEQUEN,C2_PRODUTO,C2_XSEQUEN,C2_XVEZ,C2_STATUS"})
	Local oModel  := Nil
    //Local bLinePre := {|oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue| linePreGrid(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue)}
    //Local bLinePost := {|oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue| LinePos(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue)}
    //Local bLoad := {|oGridModel, lCopy| loadGrid(oGridModel, lCopy)}

    oStruD1:AddField("Descricao","Descricao Produto","C2_XPRODUTO","C",50,0,{|| .t.}, NiL ,Nil, Nil, FwBuildFeature(STRUCT_FEATURE_INIPAD,"Posicione('SB1',1,xFilial('SB1')+SC2->C2_PRODUTO,'B1_DESC')"),nil,nil,.T.)
    oStruD1:SetProperty( '*' , MODEL_FIELD_WHEN, {||.F.} )
    //oStruD1:SetProperty( 'C2_XSEQUEN' , MODEL_FIELD_WHEN, {||.T.} )
    //oStr := oStruD1:GetStruct()
    
    //oStruD1:SetProperty( 'C2_XSEQUEN' , MODEL_FIELD_VALID, {|x,y,z,a1,a2,a3| AjustePos(x,y,z,a1,a2,a3) } )
    

	oModel := MPFormModel():New('MAAPCPC05',,{ |oModel| PCP05POS( oModel ) } )
	
	oModel:AddFields( 'MASTER', /*cOwner*/, oStruM)
   oModel:AddGrid("MGRIDSC2","MASTER",oStruD1,,,,) 
	oModel:GetModel( 'MASTER' ):SetDescription( 'Recurso' )

    oSTr := oModel:GetModel("MGRIDSC2"):GetStruct()
    //oSTr:AddTrigger("C2_XSEQUEN","C2_XVEZ",{|a,b,c,d,e,f|pregat(a,b,c,d,e,f) },{|a,b,c,d,e,f|execgat(a,b,c,d,e,f) })

    oModel:SetRelation('MGRIDSC2', { { 'C2_FILIAL', 'H1_FILIAL' }, { 'C2_RECURSO', 'H1_CODIGO'},{"Case When C2_DATRF = ' ' Then 'S' else 'N'  End","'S'" } }, "C2_XSEQUEN+C2_NUM+C2_ITEM+C2_SEQUEN" )
    
    //oModel:SetRelation('MGRIDSC2', { { 'C2_FILIAL', 'H1_FILIAL' }, { 'C2_RECURSO', 'H1_CODIGO'} }, "C2_NUM+C2_ITEM+C2_SEQUEN+C2_XSEQUEN" )
    
    oModel:SetPrimaryKey( {} )
	 oModel:getModel('MGRIDSC2'):SetOptional(.T.)
    oModel:SetActivate({|oModel| PCPC05FILPRD(oModel)})
Return oModel

Static Function PCP05POS(oModel)
   Local oGrid := oModel:GetModel('MGRIDSC2')
   local nI   
   //Local lRet := CleanAtiva(oModel:GetValue('MASTER','H1_CODIGO'))
   
Return .T.

Static Function CleanAtiva(xdRecurso)
    Local lxRet := .T.
   // Local xSql := " Update C2 Set C2_STATUS = 'S'
   // xSql += " From " + RetSqlName('SC2') + " C2 "
   // xSql += " Where C2.D_E_L_E_T_ = '' 
   // xSql += " And C2_FILIAL = '" + xFilial("SC2") + "'" 
   // xSql += " And C2_RECURSO = '" + xdRecurso + "' "
   // nRet := TCSqlExec(xSql)
  //  if(nRet < 0)
 //      FwAlertError('Error',TCSQLError())
  //     lxRet := .F.
  //  EndIf
Return lxREt

Static Function ViewDef()
    Local oModel :=  FWLoadModel( 'AAPCPC05' )
    Local oView
    Local oStruM  := FWFormStruct( 2, 'SH1' )
    Local oStruD1 := FWFormStruct( 2, 'SC2' ,{|x| Alltrim(x)$"C2_NUM,C2_ITEM,C2_SEQUEN,C2_PRODUTO,C2_XSEQUEN,C2_XVEZ,C2_STATUS"})    


    oStruD1:AddField("C2_XPRODUTO","06","Descricao","Descricao Produto",{""},"c","@!",Nil,'',.F.,Nil,Nil,Nil,Nil,Nil,.T.,Nil)
    
    oView :=  FWFormView():New()
	 oView:SetModel( oModel )

	oView:CreateHorizontalBox( 'TELA' , 40 )
    oView:CreateHorizontalBox( 'DOWN' , 60 )

   // Quebra em 2 "box" vertical para receber algum elemento da view
   oView:CreateVerticalBox( 'EMBAIXOESQ', 80, 'DOWN' )
   oView:CreateVerticalBox( 'EMBAIXODIR', 20, 'DOWN' )

    oView:AddOtherObject("OTHER_PANEL", {|oPanel| PCPC05BUT(oPanel)})
    //oView:AddOtherObject("OP_PANEL"   , {|oPanel| PCPC05BRW(oPanel)})

	oView:AddField( 'VIEW_SH1', oStruM, 'MASTER' )
    oView:AddGRID( 'VIEW_SC2', oStruD1, 'MGRIDSC2' )
	//oView:AddGrid('FORMSA7' , oStruSA7,'MdGridSA7')
	
	oView:SetOwnerView( 'VIEW_SH1', 'TELA' )
    oView:SetOwnerView( 'VIEW_SC2', 'EMBAIXOESQ' )
    //oView:SetOwnerView( 'OP_PANEL', 'EMBAIXODIR' )
    oView:SetOwnerView( 'OTHER_PANEL', 'EMBAIXODIR' )
    
Return oView

Static Function LinePos(P01,P02,P03,P04,P05,P06,P07,P08,P09,P10)
lOCAL LrET := .T.
return lRet

static function pregat(a,b,c,d,e,f)
   Local lRet := .T.
return lRet

static function execgat(a,b,c,d,e,f)
   Local lRet := ""
   AjustePos()
return lRet

Static Function AjustePos(lUp)
    Local oModel := FWModelActive()
    //Local oView := FWViewActive()
    Local oGrid  := oModel:GetModel("MGRIDSC2")
    Local noo    := oGrid:GetValue("C2_XSEQUEN")
    Local nI     := 01
    Local nAct   := oGrid:GetLine()
    Local nPosTO := nAct
   
    if !lUp
       nI := nAct + 1
       //if nI > oGrid:Length()
       //EndIf
    EndIf

    While nI < oGrid:Length()
       oGrid:GoLine(nI)
       if oGrid:GetValue("C2_XSEQUEN") >= noo
          nPosTo := nI
          Exit
       EndIf
       nI++
    EndDo

    if nPosTo < nAct
       While nAct > nPosTO
          oGrid:GoLine(nAct)
          //oGrid:LoadValue("C2_STATUS",'U')
          LineUp(oGrid)//PCP05Up()
          nAct--
       EndDo
       For nI := nPosTo + 1 To oGrid:Length()
           noo++
           oGrid:GoLine(nI)
           oGrid:LoadValue("C2_XSEQUEN",noo)
           //oGrid:LoadValue("C2_STATUS",'U')
       Next
    Else
        //nI := 1
        if nAct == 01
          noo := 01
        else
          oGrid:GoLine(nAct-1)
          noo := oGrid:GetValue("C2_XSEQUEN")+1
        EndIf
        nI := nAct
        While nI < nPosTO
          oGrid:GoLine(nI)
          //oGrid:LoadValue("C2_STATUS",'U')
          LineDown(oGrid)//PCP05Up()
          nI++
       EndDo       
       For nI := nAct To oGrid:Length()
           oGrid:GoLine(nI)
           oGrid:LoadValue("C2_XSEQUEN",noo)
           //oGrid:LoadValue("C2_STATUS",'U')
           noo++
       Next
    EndIf
    If nPosTO == 1 .Or. nAct == 1
       oGrid:GoLine(1)    
       //oGrid:LoadValue("C2_STATUS",'N')
    EndIf
    //oVIew:Refresh("VIEW_SC2")
    //oGrid:GetLine()
Return 
Static Function PCPC05FILPRD(oModel)
//Local oView		:= FWViewActive()
Local oGrid	:= oModel:GetModel("MGRIDSC2")
Local nI

For nI := 01 To oGrid:Length()
    oGrid:GoLine(nI)
    //oGrid:LoadValue("C2_STATUS","U")
    //if Empty(oGrid:GetValue("C2_XSEQUEN"))
    oGrid:LoadValue("C2_XSEQUEN",nI)       
    //EndIf
Next

oGrid:GoLine(1)
//oGrid:LoadValue("C2_STATUS","N")

Return Nil


Static Function PCPC05BRW(oPnale)
   Local oBrowse
   Local oModel := FWModelActive()
   Local xdRecurso := oModel:GetValue("MASTER","H1_CODIGO")
   oBrowse := FWMBrowse():New()
   oBrowse:SetAlias("SC2")
   //oBrowse:SetDataTable(.T.)
   oBrowse:SetFilterDefault("C2_FILIAL = '" + SH1->H1_FILIAL + "' .And. C2_RECURSO='" + xdRecurso + "' .And. C2_RECURSO = ' ' .And. Empty(C2_DATRF) ")     
   oBrowse:Activate(oPnale)
   //TSay():New(1,1,{|| "Teste "},oContainer,,,,,,.T.,,,30,20,,,,,,.T.)         
   //oModal:Activate()
Return 

Static Function PCPC05BUT(oPanel)
   Local lOk := .F.
   Local nGet2
   // Ancoramos os objetos no oPanel passado
   @ 10, 10 Button 'Add OP' Size 46, 13 Message 'Add OP' Pixel Action PCPC05Add( 'ZA4DETAIL', 'Existem na Grid de Musicas' ) of oPanel
   @ 30, 10 Button 'Remove OP' Size 46, 13 Message 'Remover OP' Pixel Action PCPC05Del('Removido') of oPanel
   @ 50, 10 Button 'Subir'  Size 46, 13 Message 'Aumentar Prioridade da OP' Pixel Action PCP05Up() of oPanel   
   @ 70, 10 Button 'Descer' Size 46, 13 Message 'Descer Prioridade da OP' Pixel Action PCP05Down() of oPanel
   @ 90, 10 Button 'Mover Para'  Size 46, 13 Message 'Aumentar Prioridade da OP' Pixel Action PCP05UpTo() of oPanel   
   //@ 110, 10 Button 'Descre Para'  Size 46, 13 Message 'Aumentar Prioridade da OP' Pixel Action PCP05Up() of oPanel


Return 
Static function PCP05Down()
   Local oModel := FWModelActive()
   Local oView := FWViewActive()
   Local oGrid := oModel:GetModel("MGRIDSC2")
   //Local oGrid:FWSaveRows()
   Local aSaveLines := FWSaveRows()
   Local nOO := oGrid:GetValue("C2_XSEQUEN")
   Local nLinst := oGrid:GetLine()
   Local nTam := oGrid:Length()
   if oGrid:GetLine() < nTam

      if nLinst  == 1
         //oGrid:LoadValue("C2_STATUS","U")
      EndIf

      oGrid:LoadValue("C2_XSEQUEN",noo+1)
      oGrid:GoLine(oGrid:GetLine()+1)
      if nLinst  == 1
         //oGrid:LoadValue("C2_STATUS","N")
      EndIf
      oGrid:LoadValue("C2_XSEQUEN",noo)
      oGrid:LineShift(oGrid:GetLine(),oGrid:GetLine()-1)
      oGrid:GoLine(1)
      //FwRestRows(aSaveLines)
      oView:Refresh("VIEW_SC2")
      nld := nLinst + 1
      gt := oGrid:GoLine(nld)
   EndIf
      
   //FwRestRows(aSaveLines)
Return 

Static Function LineUp(oGrid)
   oGrid:LineShift(oGrid:GetLine(),oGrid:GetLine()-1)
Return

Static Function LineDown(oGrid)
   oGrid:LineShift(oGrid:GetLine(),oGrid:GetLine()+1)
Return

Static Function PCP05UpTo()
   Local aPergs   := {}
   Local aRet := {}
   Local nQuant   := 1
   Local oModel := FWModelActive()
   Local oView := FWViewActive()
   Local oGrid := oModel:GetModel("MGRIDSC2")
   Local llUp := Nil
   //Local aSaveLines := FWSaveRows()
   //Local nValor   := 0
 
   aAdd(aPergs, {1, "Mover Para Posição",  nQuant,  "@E 9,999",     "Positivo()", "", ".T.", 80,  .F.})
   //aAdd(aPergs, {1, "Valor", nValor,  "@E 99,999.99", "Positivo()", "", ".T.", 80,  .F.})
 
   //If ParamBox(aPergs, "Informe os parâmetros")
   If ParamBox(aPergs,"Informe os parâmetros",@aRet,,,,,,,,.f.)
      if aRet[01] >=0
         llUp := oGrid:GetValue("C2_XSEQUEN") > aRet[01]
         if(aRet[01]==01)
            oGrid:LoadValue('C2_STATUS','N')
         EndIf
         oGrid:LoadValue("C2_XSEQUEN",aRet[01])
         AjustePos(llUp)
      EndIf
   EndIf
   //FwRestRows(aSaveLines)
   //oView:Refresh("VIEW_SC2")
Return Nil

Static Function PCP05Up()

   Local oModel := FWModelActive()
   Local oView := FWViewActive()
   Local oGrid := oModel:GetModel("MGRIDSC2")
   //Local oGrid:FWSaveRows()
   Local aSaveLines := FWSaveRows()
   Local nOO := oGrid:GetValue("C2_XSEQUEN")
   Local nLinst := oGrid:GetLine()

   if nLinst  > 1

      if nLinst == 2
         //oGrid:LoadValue("C2_STATUS","N")
      EndIf
      oGrid:LoadValue("C2_XSEQUEN",noo-1)
      oGrid:GoLine(oGrid:GetLine()-1)
      hj = oGrid:GetLine()
      if nLinst  == 2
         //oGrid:LoadValue("C2_STATUS","U")
      EndIf
      oGrid:LoadValue("C2_XSEQUEN",noo)
      oGrid:LineShift(oGrid:GetLine(),oGrid:GetLine()+1)
   EndIf
   //hj = oGrid:GetLine()
   //oView:Refresh()
   oGrid:GoLine(1)   
   //FwRestRows(aSaveLines)
   oView:Refresh("VIEW_SC2")
   nld := iIf(nLinst<=1,1,nLinst-1)
   gt := oGrid:GoLine(nld)

Return Nil

Static Function PCPC05Add()
   Local oModel := FWModelActive()
   Local oGrid := oModel:GetModel( 'MGRIDSC2' )
   Local nI := 0
   Local aSaveLines := FWSaveRows()
   Local oContainer := Nil
   Local oBrowse
   Private xdRet
   if ConPad1(,,,"SC2","xdRet",,.T.,,,,,,"C2_RECURSO = ' ' .And. Dtos(C2_DATRF) =' ' ",,)
       Alert(xdRet)
       SC2->(Reclock('SC2',.F.))
          SC2->C2_RECURSO := SH1->H1_CODIGO
       SC2->(MsUnlock())
       oGrid:AddLine()
       oGrid:SetValue("C2_NUM",SC2->C2_NUM)
       oGrid:SetValue("C2_ITEM",SC2->C2_ITEM)
       oGrid:SetValue("C2_SEQUEN",SC2->C2_SEQUEN)
       oGrid:SetValue("C2_PRODUTO",SC2->C2_PRODUTO)
       oGrid:SetValue("C2_XSEQUEN",999)
   EndIf
    
/*
   oModal  := FWDialogModal():New()       
   oModal:SetEscClose(.T.)
   oModal:setTitle("Nova OP")
   oModal:setSubTitle( OemToAnsi("Inclusão de uma Nova OP na Sequencia"))
     
   //Seta a largura e altura da janela em pixel
   oModal:setSize(500, 600)
 
   oModal:createDialog()
   oModal:addCloseButton(nil, "Fechar")
   oModel:addButtons( {{"","Selecionar",{|| Alert("Selected") },"Selecionar OP",1,.T.,.T.}} )
   oContainer := TPanel():New( ,,, oModal:getPanelMain() )
   //oContainer:SetCss("TPanel{background-color : red;}")
   oContainer:Align := CONTROL_ALIGN_ALLCLIENT
   df := aClone(aRotina)
   aRotina := {}
   oBrowse := FWMBrowse():New()
   oBrowse:SetAlias("SC2")
   //oBrowse:SetDataTable(.T.)
   oBrowse:SetFilterDefault("C2_RECURSO = ' ' .And. C2_DATRF=' ' ")     
   oBrowse:Activate(oContainer)
   //TSay():New(1,1,{|| "Teste "},oContainer,,,,,,.T.,,,30,20,,,,,,.T.)         
   oModal:Activate()
   aRotina := aClone(df)
   */
Return 
Static Function PCPC05Del()
    Local oModel := FWModelActive()
    Local oGrid := oModel:GetModel( 'MGRIDSC2' )
    Local xSeek := oGrid:GetValue("C2_NUM") + oGrid:GetValue("C2_ITEM") + oGrid:GetValue("C2_SEQUEN")

    SC2->(dbSetOrder(1))
    If SC2->(dbSeek(xFilial('SC2') + xSeek))
       SC2->(REcLock('SC2',.F.))
         SC2->C2_RECURSO := ''
         SC2->C2_XSEQUEN := 0
       SC2->(MsUnlock())
    EndIf
    //oGrid:DeleteLine()
Return 
