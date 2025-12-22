#include "protheus.ch"
#include "tbiconn.ch"
#INCLUDE 'FWMVCDEF.CH'


User Function AAFATC4D()
    MsApp():New('SIGAEST') 
    oApp:CreateEnv()
    PtSetTheme("SUNSET")
    //u_AAFINR01("1","000046348",,.T.) 
    //u_AAFINR01()
    //Define o programa de inicialização 
    oApp:cStartProg    := 'MATA311'
    //oApp:cStartProg    := 'U_IPFATP4D'
 
    //Seta Atributos 
    __lInternet := .T.
    /*
    oApp:bMainInit:= {|| MsgRun("Configurando ambiente...","Aguarde...",{|| RpcSetEnv("01","01") }),;
        u_LjKeyF8(),;
        Final("TERMINO NORMAL")}
        */
     //u_AAFATE14("500","000000016"),;
    //Seta Atributos 
    //__lInternet := .T.
    //lMsFinalAuto := .F.
    //oApp:lMessageBar:= .T. 
    //oApp:cModDesc:= 'SIGATST'
     
    //Inicia a Janela 
    oApp:Activate()
Return 

User Function AAFATC4C()
      SC5->(dbSetOrder(1))
      SC5->(dbSeek('01001710'))
      lOk := ( FWExecView('Inclusão por FWExecView','AAFATC04', MODEL_OPERATION_UPDATE,,{ || .T. } ) == 0 )
      ConOut(lOK)
Return 
Static Function Modeldef()

   Local oStruSc5 := FWFormStruct( 1, 'SC5' )
   Local oStruSC6 := FWFormStruct( 1, 'SC6' ,{|xCpo| GetCpo(xCPO)})
   Local oStruSZ5 := FWFormStruct( 1, 'SZ5' )
	Local oModel   := Nil

   oStruSZ5:SetProperty('Z5_PEDIDO' , MODEL_FIELD_WHEN,{|| .F. })
   oStruSZ5:SetProperty('Z5_PEDIDO' , MODEL_FIELD_INIT,{|| oModel:GetValue( 'SC5MASTER', 'C5_NUM' ) })

   oStruSZ5:SetProperty('Z5_ITEM' , MODEL_FIELD_WHEN,{|| .F. })
   oStruSZ5:SetProperty('Z5_ITEM' , MODEL_FIELD_INIT,{|| oModel:GetValue( 'SC6GRID', 'C6_ITEM' ) })

   oStruSZ5:SetProperty('Z5_PRODUTO' , MODEL_FIELD_WHEN,{|| .F. })
   oStruSZ5:SetProperty('Z5_PRODUTO' , MODEL_FIELD_INIT,{|| oModel:GetValue( 'SC6GRID', 'C6_PRODUTO' ) })

   //oStruSZ5:SetProperty('Z5_OP' , MVC_VIEW_LOOKUP, "SC2")

	oModel := MPFormModel():New('MAAFATC04' )
	
   oModel:AddFields( 'SC5MASTER', /*cOwner*/, oStruSC5)
   oModel:AddGrid( 'SC6GRID', 'SC5MASTER', oStruSC6)
	oModel:AddGrid( 'SZ5GRID', 'SC6GRID', oStruSZ5)

   //oStruSZ5:

   oModel:GetModel('SC6GRID'):SetOnlyView(.t.)
   oModel:GetModel('SC5MASTER'):SetOnlyView(.t.)
   oModel:GetModel('SZ5GRID'):SetOptional(.t.)
   //oModel:GetModel('SZ5GRID'):SetOnlyView(.F.)

   //oModel:SetRelation()
   oModel:SetRelation( 'SC6GRID', { { 'C6_FILIAL', 'xFilial( "SC6" )' }, {'C6_NUM', 'C5_NUM' } }, SC6->( IndexKey( 1 ) ) )
   oModel:SetRelation( 'SZ5GRID', { { 'Z5_FILIAL', 'xFilial( "SZ5" )' }, {'Z5_PEDIDO', 'SC5->C5_NUM' },{'Z5_ITEM', 'C6_ITEM' },{'Z5_PRODUTO', 'C6_PRODUTO' } }, SZ5->( IndexKey( 1 ) ) )

	//oModel:GetModel( 'SZ5MASTER' ):SetDescription( 'Dados' )

  // oModel:SetActivate( { |oModel| AFilPrd( oModel ) })
Return oModel

Static Function ViewDef()
	Local oStruSc5 := FWFormStruct( 2, 'SC5' )
   Local oStruSC6 := FWFormStruct( 2, 'SC6' ,{|xCpo| GetCpo(xCPO) })
   Local oStruSZ5 := FWFormStruct( 2, 'SZ5'  )

	Local oModel   := FWLoadModel( 'AAFATC04' )
	
	oView :=  FWFormView():New()
	oView:SetModel( oModel )
	
	oView:AddField( 'VIEW_SC5', oStruSC5, 'SC5MASTER' )
   oView:AddGrid( 'VIEW_SC6', oStruSC6, 'SC6GRID' )
   oView:AddGrid( 'VIEW_SZ5', oStruSZ5, 'SZ5GRID' )

	oView:CreateHorizontalBox( 'TELA' , 40 )	
   oView:CreateHorizontalBox( 'DOWN' , 60 )
   //oView:CreateHorizontalBox( 'TELA' , 60 )
   oView:CreateVerticalBox( 'RIGHT', 40, 'DOWN' )
   oView:CreateVerticalBox( 'LEFT', 60, 'DOWN' )

	oView:SetOwnerView( 'VIEW_SC5', 'TELA' )
   oView:SetOwnerView( 'VIEW_SC6', 'RIGHT' )
   oView:SetOwnerView( 'VIEW_SZ5', 'LEFT' )
Return oView

Static Function AFilPrd(oModel)
   Local oView 	:= FWViewActive()
   Local oField 	:= oModel:GetModel("SZ5GRID")

   if oModel:GetOperation() == MODEL_OPERATION_INSERT .Or. oModel:GetOperation() == MODEL_OPERATION_UPDATE //.And. FWIsInCallStack("AAFATC4A")
      //oField:GetModelStruct()7
      //oField:LoadValue("Z5_PEDIDO",SC5->C5_NUM)
      //oField:GetStruct()
      //oField:GetStruct():
      //oField:LoadValue("Z5_PRODUTO",xProduto)
   EndIf


Return Nil


Static Function GetCpo(xCpo)
  if Alltrim(xCpo)$"C6_NUM"
     //alert('fuck')
  EndIF
  lOk := Alltrim(xCpo)$"C6_ITEM,C6_NUM,C6_PRODUTO,C6_DESCRI,C6_UM,C6_QTDVEN,C6_PRCVEN,C6_VALOR"
Return lOK

User Function AAFATC04(_cAlias,_nOpc,_nRecno)

Local aCabec     := {'Produto','Descrição','UM','Qtd. Vendida','Prc. Venda','Total'}  //'Nome Cli.','Vendedor','Total Bruto','Desconto','Total Liq','Forma Pag','Num. Entrega','Quem Recebeu','Data Rec.','Hora Rec.','Qtd Entregas'}

If Type("cAcesso") = "U"
      Prepare Environment Empresa '99' Filial '01' Tables 'SZE,SD2,SF2,SL1,SC5,SA3' Modulo 'FAT'
      
      SC5->(dbSetOrder(1))
      SC5->(dbSeek('01001710'))
      
EndIf
     
Private _nPedido := SC5->C5_NUM
Private _aBrowse   := {}

aBLine := { ;
   { {|| (_cAlias)->C6_PRODUTO},"@!"},;
   { {|| (_cAlias)->C6_DESCRI} ,"@!"},;
   { {|| (_cAlias)->C6_UM}     ,"@!"},;
   { {|| (_cAlias)->C6_QTDVEN} ,"@ 999,999.99"},; 
   { {|| (_cAlias)->C6_PRCVEN} ,"@ 999,999.99"},;
   { {|| (_cAlias)->C6_VALOR}  ,"@ 999,999.99"}}


_cAlias := getProd(SC5->C5_NUM,SC5->C5_FILIAL)

DEFINE MSDIALOG oWindow TITLE "Consulta Produtos" FROM 000, 000  TO 510, 1000 COLORS 0, 16777215 PIXEL
   
   @ 010, 005 SAY "Pedido:" SIZE 040, 009 OF oWindow COLORS 0, 16777215 PIXEL
   @ 010, 040 MSGET SC5->C5_NUM  SIZE 040, 010 OF oWindow COLORS 0, 16777215 PIXEL When .F.
   
   @ 025, 005 SAY "Cliente:" SIZE 040, 009 OF oWindow COLORS 0, 16777215 PIXEL
   @ 025, 040 MSGET SC5->C5_CLIENTE    SIZE 040, 010 OF oWindow COLORS 0, 16777215 PIXEL When .F.
   @ 025, 085 MSGET SC5->C5_LOJACLI    SIZE 020, 010 OF oWindow COLORS 0, 16777215 PIXEL When .F.
   
   
   _cCliFrom := ""
   _cCliTo   := ""
//   @ 040, 005 SAY "Cliente De/Ate:"   SIZE 040, 009 OF oWindow COLORS 0, 16777215 PIXEL
//   @ 040, 040 MSGET _cCliFrom  SIZE 040, 010 OF oWindow COLORS 0, 16777215 PIXEL F3 "SA1" Valid iIf(Len(Alltrim(_cCliTo)) != 6, _cCliTo := Replicate('z', TamSX3('A1_COD')[01] ),.T.)
   
//   @ 040, 90 MSGET _cCliTo    SIZE 040, 010 OF oWindow COLORS 0, 16777215 PIXEL F3 "SA1"
   
//   TButton():New(025,400,'&Consultar',oWindow,{|| MsgRun('Filtrando Dados, Aguarde...',,{|| _cAls := AAFATC21(_cAls) , IiF( Type("_oBrw")="O",_oBrw:Refresh(),) } )  } ,40,12,,,,.T.) 
   TButton():New(025,460,'&Fechar'   ,oWindow,{|| oWindow:End() } ,40,12,,,,.T.) 

   
   _oBrw := TcBrowse():New ( 060,007,490,140 , , /*aCabec*/,/*[ aColSizes]*/, oWindow, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  _cAlias, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
  
   For _nK := 1 To Len(aBline)
      _oBrw:AddColumn(TCColumn():New(aCabec[_nK], aBline[_nK][01], aBLine[_nK][02] ,,, iIf( (aBLine[_nK][02]) != "@!","RIGTH", "LEFT")  ,,.F.,.F.,,,,.F.,) )
   Next
   _oBrw:aColumns[01]:BACKCOLOR := 1987733
//   _cFil,_cPed,_cProd
   _oBrw:BLDBLCLICK := {|| MsgRun('Filtrando Dados, Aguarde...',,{|| AAFATC4A( (_cAlias)->C6_FILIAL,(_cAlias)->C6_NUM,(_cAlias)->C6_PRODUTO ) } )  }
   //_oBrw:nScrollType := 1 // Define a barra de rolagem padrão. Observe nos exemplo 1 e 2, os tipos de barra de rolagem.
   _oBrw:nScrollType := 1 // Define a barra de rolagem VCR
   
    oFont := TFont():New('Courier new',,-12,.T.)
    oFont := TFont():New('Arial',,-12,.T.)

/*    
    TSay():New(205,005,{|| "TOTAL R$ :" },oWindow,, ,,,,.T.,CLR_BLACK,CLR_WHITE,90,20)
    Private oSay1:= TSay():New(205,060,{|| 0 },oWindow,"@E 999,999,999.99",oFont,,,,.T.,CLR_RED,CLR_WHITE,80,20)
    
    TSay():New(220,005,{|| "TOTAL PESO KG :" },oWindow,, ,,,,.T.,CLR_BLACK,CLR_WHITE,90,20)
    Private oSay2:= TSay():New(220,060,{|| 0 },oWindow,"@E 999,999,999.99",oFont,,,,.T.,CLR_RED,CLR_WHITE,80,20)
 */   
   // AAFATC21(_cAls)
   
   ACTIVATE MSDIALOG oWindow CENTERED



Return Nil

Static function AAFATC4A(_cFil,_cPed,_cProd)


SX3->(dbSetOrder(1))
SX3->(dbSeek('SZ5'))

aCabec := {}
ABLine := {}

Private xPedido := _cPed
Private xProduto := _cProd

    
aCabec := {"Data","Hora","Usuario","Op","Obs","Status","Dt. Entrega"}


_cdAlias := AAGETHIST(_cFil,_cPed,_cProd)

aBLine := { ;
   { {|| (_cdAlias)->Z5_DATA}   ," "},;
   { {|| (_cdAlias)->Z5_HORA}   ,"@R 99:99"},;
   { {|| (_cdAlias)->Z5_USER}   ,"@!"},;
   { {|| (_cdAlias)->Z5_OP}     ,"@!"},;
   { {|| getObs( (_cdAlias)->Z5_RECNO ) }    ,"@!"},; 
   { {|| (_cdAlias)->Z5_STATUS} ,"@!"},;   
   { {|| (_cdAlias)->Z5_ENTREGA} ,""}}

DEFINE MSDIALOG oWindow1 TITLE "Historico" FROM 000, 000  TO 510, 1000 COLORS 0, 16777215 PIXEL
   

   @ 010, 005 SAY "Pedido:" SIZE 040, 009 OF oWindow1 COLORS 0, 16777215 PIXEL
   @ 010, 040 MSGET _cPed  SIZE 040, 010 OF oWindow1 COLORS 0, 16777215 PIXEL When .F.
   
   @ 025, 005 SAY "Produto" SIZE 040, 009 OF oWindow1 COLORS 0, 16777215 PIXEL
   @ 025, 040 MSGET _cProd    SIZE 040, 010 OF oWindow1 COLORS 0, 16777215 PIXEL When .F.
//   @ 025, 085 MSGET SC5->C5_LOJACLI    SIZE 080, 010 OF oWindow COLORS 0, 16777215 PIXEL When .F.

   TButton():New(025,460,'&Fechar'   ,oWindow1,{|| oWindow1:End() } ,40,12,,,,.T.) 
   
   _oBrw := TcBrowse():New ( 060,007,490,140 , , /*aCabec*/,/*[ aColSizes]*/, oWindow1, /*[ cField]*/,  , , /*[ bChange]*/, /*[ bLDblClick]*/, /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/,  _cdAlias, /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
  
   For _nK := 1 To Len(aBline)
      _oBrw:AddColumn(TCColumn():New(aCabec[_nK], aBline[_nK][01], aBLine[_nK][02] ,,, iIf( (aBLine[_nK][02]) != "@!","RIGTH", "LEFT")  ,,.F.,.F.,,,,.F.,) )
   Next
   //_oBrw:aColumns[01]:BACKCOLOR := 1987733
   //_oBrw:BLDBLCLICK := {|| MsgRun('Filtrando Dados, Aguarde...',,{|| AAFATC23( IiF( Empty( (_cAls)->D2_PEDIDO) ,(_cAls)->L1_FILIAL,(_cAls)->F2_FILIAL) ,    IiF( Empty( (_cAls)->D2_PEDIDO) ,(_cAls)->L1_NUM,(_cAls)->D2_PEDIDO) , (_cAls)->F2_DOC, (_cAls)->F2_SERIE, Empty((_cAls)->D2_PEDIDO) ) } )  }
   //_oBrw:nScrollType := 1 // Define a barra de rolagem padrão. Observe nos exemplo 1 e 2, os tipos de barra de rolagem.
   _oBrw:nScrollType := 1 // Define a barra de rolagem VCR
   
    oFont := TFont():New('Courier new',,-12,.T.)
    oFont := TFont():New('Arial',,-12,.T.)

   
   ACTIVATE MSDIALOG oWindow1 CENTERED



Return


Static Function AAGETHIST(_cFil,_cPed,_cProd)

Local _cQry := ""
Local _cAlias := getNextAlias()

_cQry +="  Select Z5_DATA,Z5_USER,Z5_OP,Z5_OBS,R_E_C_N_O_  Z5_RECNO,Z5_STATUS,Z5_ENTREGA,Z5_HORA from "  + retSqlName("SZ5")
_cQry +=" Where D_E_L_E_T_ = ''
_cQry +=" And Z5_PEDIDO = '" + _cPed + "'
_cQry +=" And Z5_FILIAL = '" + _cFil + "'
_cQry +=" And Z5_PRODUTO = '" + _cProd + "'

dbUseArea(.T.,"TopConn",tcGenQry(,,ChangeQuery(_cQry)),_cAlias,.T.,.T.)
tcsetField(_cAlias,"Z5_DATA","D",8,0)
tcsetField(_cAlias,"Z5_ENTREGA","D",8,0)

_cdAls := CriaTrab(NIL,.F.)
copy to &_cdAls

(_cAlias)->(dbCloseArea(_cAlias))
dbUseArea(.T.,,_cdAls,_cdAls,.F.,.F.)

Return _cdAls

static function getProd(_cPed,_cFil)
Local _cQry := ""
Local _cAlias := getNextAlias()

_cQry +="  Select * from "  + retSqlName("SC6")
_cQry +=" Where D_E_L_E_T_ = ''
_cQry +=" And C6_NUM = '" + _cPed + "'
_cQry +=" And C6_FILIAL = '" + _cFil + "'

dbUseArea(.T.,"TopConn",tcGenQry(,,ChangeQuery(_cQry)),_cAlias,.T.,.T.)

_cdAls := CriaTrab(NIL,.F.)
copy to &_cdAls

(_cAlias)->(dbCloseArea(_cAlias))
dbUseArea(.T.,,_cdAls,_cdAls,.F.,.F.)

Return _cdAls
Static Function getObs(_nRecno)
   SZ5->(dbGoTo(_nRecno))
   _cdObs := SZ5->Z5_OBS
Return _cdObs



/*powered by DXRCOVRB*/
