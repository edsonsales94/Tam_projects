
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include "TBICONN.ch"
#include "fwcommand.ch"

#define NDADOS 1
#define NCODUS 1
#define NNOMUS 2
#define NNOMCP 4
#define NDEPAR 12
#define NCARGO 13
#define NEMAIL 14
#define NUSUBL 17
#define NRAMAL 20
//====================================================================================================================\\
/*/{Protheus.doc} 
====================================================================================================================
@description
LOCALIZAÇÃO :

EM QUE PONTO :

Parâmetros:
Nome		Tipo	 Obrigatório Descrição

==================================================================================================================
Customizações:
Cliente: IP
==================================================================================================================
@author		ARLINDO NETO
@version	1.0
@since		11/07/2018
@return		Nil, Nil, Nil
@obs
Áreas utilizadas:
/*/
//====================================================================================================================\\
User Function mwc_usuarios()

return

WSRESTFUL oirausu DESCRIPTION "Serviço de Consulta Usuarios"

WSMETHOD GET DESCRIPTION "Retornar usuarios" WSSYNTAX "/oirausu/{cxUser}  || /oirausu/{cxUser} "
WSMETHOD PUT DESCRIPTION "acessos usuarios" WSSYNTAX "/oirausu/  || /oirausu/"

End WsRestful

WsMethod put  WSSERVICE oirausu
Local oUsuarios := JsonObject():New()
Local aFilsSM0 
Local cBody := ""
Local nX        := 0
Local cBody     := ""
Local oRequest := JsonObject():New()  
Local cxTbl    := ""

//RpcSetType(3)
//ldOk := RpcSetEnv('01','01')
::SetContentType("application/json")
cxTbl    := getmv("MV_XWMC")
//CONOUT(ldOk)

 cBody := ::GetContent()
  u_SaveRequest(cBody)
  oRequest:FromJson(cBody)


    oReturn := _Put(oRequest)
    if Left(oReturn["statusmessage"],4) == "[ER]" 
       SetRestFault(006,oReturn["statusmessage"])
       lPost := .F.
    else
        cReturn := FWJsonSerialize(oReturn, .F., .F., .T.)
        ::SetContentType("application/json")
        u_SaveResponse(cReturn)
        ::SetResponse(cReturn)
    EndIf


Return .T.


Static Function _Put(_oRequest)
    Local oReturn := JsonObject():New()
    Local cxTela  := ""
    local _nxI    := 0
    Local cxUsr     := _oRequest["codigo"]

    cQuery := "DELETE FROM "        + RetSqlName("SZN") 					+ " "
	cQuery += "WHERE ZN_USER = '" + cxUsr  					+ "'  "
	
    TcSqlExec(cQuery) 
   
    For _nxI := 1 To Len(_oRequest["acessos"])
         oRequest  := _oRequest["acessos"][_nxI]
         cxTela    := oRequest["tela"]

         Reclock('SZN',.T.)
         SZN->ZN_FILIAL := XFILIAL("SZN")
         SZN->ZN_USER   := cxUsr
         SZN->ZN_ACESSO := cxTela
         SZN->ZN_NOME   := UsrRetName(cxUsr)
         MsUnlock()

     NEXT 

     oReturn["statusmessage"] :=  "[OK] " 
     oReturn["user"] := cxUsr
 
Return oReturn


WsMethod Get  WSSERVICE oirausu
Local oUsuarios := JsonObject():New()
Local aFilsSM0 
Local nX        := 0
Local cxPar     := ""
Local aAllUsers := FWSFAllUsers()

If Len(::aURLParms) > 0
    cxPar := ::aURLParms[01]
EndIf        
	
RpcSetType(3)
ldOk := RpcSetEnv('05','01')
::SetContentType("application/json")

cxTbl  := "SZN"//ALLTRIM(getmv("MV_XWMCLOG"))
cxpREF := cxTbl

IF LEFT(cxTbl,1) = 'S'
    cxpREF := RIGHT(cxTbl,2)
ENDIF

//CONOUT(ldOk)

oUsuarios['users'] :={}

If Empty(cxPar)

    //Percorre todos as condicoes e faz a montagem do array de fornecedores
    For nX := 1 To Len(aAllUsers)
                //PswSeek(aAllUsers[nX][2])
                Aadd(oUsuarios['users'],JsonObject():New())
                oUsuarios['users'][nX]['codigo']	    := aAllUsers[nX][2]//Alltrim(aAllUsers[nX][NDADOS][NCODUS])
                oUsuarios['users'][nX]['login']         := aAllUsers[nX][3]//Alltrim(aAllUsers[nX][NDADOS][NNOMUS])
                oUsuarios['users'][nX]['nome']          := aAllUsers[nX][4]//Alltrim(aAllUsers[nX][NDADOS][NNOMCP])
                oUsuarios['users'][nX]['departamento']  := aAllUsers[nX][6]//Alltrim(aAllUsers[nX][NDADOS][NDEPAR])
                oUsuarios['users'][nX]['cargo']         := aAllUsers[nX][7]//Alltrim(aAllUsers[nX][NDADOS][NCARGO])
                oUsuarios['users'][nX]['email']         := aAllUsers[nX][5]//Alltrim(aAllUsers[nX][NDADOS][NEMAIL])
                oUsuarios['users'][nX]['administrador'] := FwIsAdmin(aAllUsers[nX][2])
                oUsuarios['users'][nX]['acessos']       := {}

                xdTbl := MpSysOpenQUery("SELECT * FROM "+RetSQLName(cxTbl)+" WHERE D_E_L_E_T_='' AND "+cxpREF+"_USER = '"+Alltrim(aAllUsers[nX][2])+"' ")
                DBSELECTAREA(xdTbl)
                
                //Percorre todos as condicoes e faz a montagem do array de fornecedores
                While !(xdTbl)->(Eof())
                        //QOUT((xdTbl)->ZN_ACESSO)
                        aAdd(oUsuarios['users'][nX]['acessos']   ,JsonObject():New())
                        Atail(oUsuarios['users'][nX]['acessos'] )['tela'    ]  := &(xdTbl+"->"+cxpREF+"_ACESSO")
        
                    (xdTbl)->(dbSkip())
                EndDo
                DBCLOSEAREA(xdTbl)


    Next 

else

    PswOrder(1)
    nX:= 0
	If PswSeek( cxPar, .T. )
        
          nPos	:= AsCan(aAllUsers,{|x| x[2] == cxPar})

          IF nPos > 0
                nX++

                 Aadd(oUsuarios['users'],JsonObject():New())
                oUsuarios['users'][nX]['codigo']	    := aAllUsers[nPos][2]//Alltrim(aAllUsers[nX][NDADOS][NCODUS])
                oUsuarios['users'][nX]['login']         := aAllUsers[nPos][3]//Alltrim(aAllUsers[nX][NDADOS][NNOMUS])
                oUsuarios['users'][nX]['nome']          := aAllUsers[nPos][4]//Alltrim(aAllUsers[nX][NDADOS][NNOMCP])
                oUsuarios['users'][nX]['departamento']  := aAllUsers[nPos][6]//Alltrim(aAllUsers[nX][NDADOS][NDEPAR])
                oUsuarios['users'][nX]['cargo']         := aAllUsers[nPos][7]//Alltrim(aAllUsers[nX][NDADOS][NCARGO])
                oUsuarios['users'][nX]['email']         := aAllUsers[nPos][5]//Alltrim(aAllUsers[nX][NDADOS][NEMAIL])
                oUsuarios['users'][nX]['administrador'] := FwIsAdmin(aAllUsers[nPos][2])
                oUsuarios['users'][nX]['acessos']       := {}


                xdTbl := MpSysOpenQUery("SELECT * FROM "+RetSQLName(cxTbl)+" WHERE D_E_L_E_T_='' AND "+cxpREF+"_USER = '"+Alltrim(aAllUsers[nPos][2])+"' ")
                
                DBSELECTAREA(xdTbl)
                //Percorre todos as condicoes e faz a montagem do array de fornecedores
                While !(xdTbl)->(Eof())
                        QOUT((xdTbl)->ZN_ACESSO)
                        aAdd(oUsuarios['users'][nX]['acessos']   ,JsonObject():New())
                        Atail(oUsuarios['users'][nX]['acessos'] )['tela'    ]  := &(xdTbl+"->"+cxpREF+"_ACESSO")
        
                    (xdTbl)->(dbSkip())
                EndDo
                DBCLOSEAREA(xdTbl)


           
          ENDIF

       endif 

Endif

cReturn := FWJsonSerialize(oUsuarios, .F., .F., .T.)
	////CONOUT( cReturn)
::SetResponse(EncodeUtf8(cReturn))

MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)


//RestArea(aAreaSM0)

Return .T.

