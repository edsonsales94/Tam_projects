#include 'TBICONN.ch'  
#include "TOTVS.CH"
#include "RPTDEF.CH"
#include "fwprintsetup.ch"
#Include 'ParmType.ch'

User Function XML(cEmpFil)
	Local aEmpFil 
	Local bWindowInit := { || __Execute( "u_AAFATP11()" , "xxxxxxxxxxxxxxxxxxxx" , "AAFATP11" , "SIGAFAT" , "SIGAFAT", 1 , .T. ) } 
	Local cEmp 
	Local cFil 
	Local cMod 
	Local cModName := "SIGAFAT" 
	DEFAULT cEmpFil := "01;01" 

	aEmpFil := StrTokArr( cEmpFil , ";" ) 
	cEmp := aEmpFil[1] 
	cFil := aEmpFil[2] 

	SetModulo( @cModName , @cMod ) 

	PREPARE ENVIRONMENT EMPRESA( cEmp ) FILIAL ( cFil ) MODULO ( cMod ) USER 'arlindo.neto' PASSWORD '123456'

	//InitPublic() 
	//SetsDefault() 
	SetModulo( @cModName , @cMod ) 

	DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE OemToAnsi( FunName() ) 

	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT ( Eval( bWindowInit ) , oMainWnd:End() ) 
	RESET ENVIRONMENT 
Return( NIL ) 

/*/ Funcao: SetModulo Data: 30/04/2011 Autor: Marinaldo de Jesus Descricao: Setar o Modulo em Execucao Sintaxe: SetModulo( @cModName , @cMod ) /*/ 

Static Function SetModulo( cModName , cMod )
	Local aRetModName := RetModName( .T. ) 
	Local cSvcModulo 
	Local nSvnModulo 
	IF ( Type("nModulo") == "U" ) 
		_SetOwnerPrvt( "nModulo" , 0 ) 
	Else 
		nSvnModulo := nModulo 
	EndIF 
	cModName := Upper( AllTrim( cModName ) ) 
	IF ( nModulo <> aScan( aRetModName , { |x| Upper( AllTrim( x[2] ) ) == cModName } ) ) 
		nModulo := aScan( aRetModName , { |x| Upper( AllTrim( x[2] ) ) == cModName } ) 
		IF ( nModulo == 0 ) 
			cModName := "SIGAFAT" 
			nModulo := aScan( aRetModName , { |x| Upper( AllTrim( x[2] ) ) == cModName } ) 
		EndIF 
	EndIF 
	IF ( Type("cModulo") == "U" ) 
		_SetOwnerPrvt( "cModulo" , "" ) 
	Else 
		cSvcModulo := cModulo 
	EndIF 

	cMod := SubStr( cModName , 5 ) 
	IF ( cModulo <> cMod ) 
		cModulo := cMod 
	EndIF 
Return( { cSvcModulo , nSvnModulo } )





User Function AAFATP11()
	Local lRet        	:= .T.
	Local oDlgxy 		:= Nil
	Private aCoors  	:= FwGetDialogSize()
	
	oDlgxy := TDialog():New(aCoors[1],aCoors[2],aCoors[3],aCoors[4],"Download Xml",,,,nOr(WS_VISIBLE,WS_POPUP),,,,,.T.,,,,,,)
	oTIBrowser := TIBrowser():New(aCoors[1],aCoors[2],aCoors[3],aCoors[4], "https://www.fsist.com.br/xmls-compartilhados", oDlgxy )

	//bAction := EnchoiceBar(oDlgxy,{|| LjMsgRun(OemToAnsi("Aguarde, Concluindo a conferência do KANBAN..."),,{|| _doConfere(),oDlgxy:End()}) },{|| _doCancel(),oDlgxy:End()},,aButtons)
	oDlgxy:Activate(,,,.T.,{|| },,{|| } )
Return
