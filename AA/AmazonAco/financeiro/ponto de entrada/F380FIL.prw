#include "totvs.ch"

User Function AAFINC4D()
    MsApp():New('SIGAEST') 
    oApp:CreateEnv()
    
    oApp:cStartProg    := 'u_FCONT01'
 
    //Seta Atributos 
    __lInternet := .T.
    /*
    oApp:bMainInit:= {|| MsgRun("Configurando ambiente...","Aguarde...",{|| RpcSetEnv("01","01") }),;
        u_LjKeyF8(),;
        Final("TERMINO NORMAL")}
    */
    //__lInternet := .T.
    //lMsFinalAuto := .F.
    //oApp:lMessageBar:= .T. 
    //oApp:cModDesc:= 'SIGATST'
     
    //Inicia a Janela 
    oApp:Activate()
Return

User Function FCONT01()
   //u_FCONCAT(1755619)
   u_AAFINP05(1755619,.t.)
Return NIl
/*
User Function FCONCAT(xdRecno)
   Local lAutomato := .T.
   Private xdE5Recno := xdRecno

   SE5->(DbGoTo(xdRecno))

   Private cdBco380 := SE5->E5_BANCO
   Private cdAge380 := SE5->E5_AGENCIA
   Private cdCta380 := SE5->E5_CONTA
   Private xdIniDt380 := SE5->E5_DATA
   Private xdFimDt380 := SE5->E5_DATA

   FinA380( 2, lAutomato )
Return Nil

User Function F380VLD()
   //Local aCampos := ParamIXB[01]
   if FwIsInCallStack("u_FCONCAT")
        cBco380 		:= cdBco380
		cAge380 		:= cdAge380
		cCta380 		:= cdCta380
		dIniDt380 		:= xdIniDt380
		dFimDt380 		:= xdFimDt380
   EndIf
Return .T.

User Function F380FIL()

   Local xFilter := ""
   //Local aArea := GetArea()
   //Local E5Area := SE5->(GetArea())

   Conout("[F380FIL] - Iniciando")
   if Type("xdE5Recno") == "N" .And. FwIsInCallStack("u_FCONCAT")
      xFilter := "R_E_C_N_O_ = "+ cValToChar(xdE5Recno)
      //SE5->(dbGoTop(xdE5Recno))

   EndIf
   Conout("[F380FIL] - Donne => [" + xFilter + "]")
   
Return xFilter

User Function F380MTR()
Return Nil

User Function F380GRV()
Return Nil
*/
