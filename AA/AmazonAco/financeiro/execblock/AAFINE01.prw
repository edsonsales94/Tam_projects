#include "Protheus.ch"                                 	
#include "TBICONN.ch"

User Function AAFINE01()

Local cFilter := ""
Local cMarca  := ""

Prepare Environment Empresa "01" Filial "01" Tables "SE1"

Private oOK     := LoadBitmap(GetResources(),'LBOK')
Private oNO     := LoadBitmap(GetResources(),'LBNO')
Private cCadastro := ""
Private aRotina   := { {"Pesquisar"  ,"AxPesqui"   ,0,1} ,;
                       {"Legenda"    ,"AxPesqui"   ,0,1} }

__cUserId := "000000"
TakeData()

DEFINE DIALOG oDialog TITLE "Exemplo BrGetDDB" FROM 180,180 TO 550,700 PIXEL
	
    DbSelectArea('SE1')
    oBrowse := TCBrowse():New( 001 , 050, 260, 156,, aCabec,aDimCab, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

ACTIVATE DIALOG oDialog CENTERED 


Return Nil

Static Function Inverte(cMarca)
   SE1->(RecLock("SE1",.F.))
   If SE1->E1_OK == cMarca
      SE1->E1_OK := ""
   else
      SE1->E1_OK := cMarca
   EndIf
   SE1->(msUnlock())
   oBrowse:Refresh()
   
Return Nil


Static FUnction TakeCabec()

Local cAlias  := "SE1"
Local cCAcols := "E1_OK" //"L2_ITEM|L2_DESCRI|L2_VRUNIT"
Local lRet    := .T.  	
Local aCabec  := {}  	      

nUsado  := 0

dBSelectArea('SE1')
SX3->(dbSetOrder(1))
SX3->(dbSeek(cAlias) )
	
While ( !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAlias )
    If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. !(AllTrim(SX3->X3_CAMPO) $ cCAcols)  )
	      aAdd(aCabec,{ Trim(X3Titulo()), ;  //1  Titulo do Campo
	                     SX3->X3_CAMPO   , ;  //2  Nome do Campo
	                     SX3->X3_PICTURE , ;  //3  Picture Campo 
	                     SX3->X3_TAMANHO , ;  //4  Tamanho do Campo
	                     SX3->X3_DECIMAL , ;  //5  Casas decimais 
	                     SX3->X3_VALID   , ;  //6  Validacao do campo
	                     SX3->X3_USADO   , ;  //7  Usado ou naum
	                     SX3->X3_TIPO    , ;  //8  Tipo do campo
	                     SX3->X3_ARQUIVO , ;  //9  Arquivo 
	                     SX3->X3_CONTEXT } )  //10 Visualizar ou alterar
	                     
	      aAdd(aCabec, Trim(X3Titulo()) )
	      aAdd(aPicture , SX3->X3_PICTURE)
	      aAdd(aValid   , SX3->X3_VALID )
    Endif
    SX3->(dbSkip())
EndDo
/*
If(lOk)
EndIf
*/
return lRet 

Return 