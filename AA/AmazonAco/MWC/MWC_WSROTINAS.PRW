#include 'totvs.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include "TBICONN.ch"

User Function GetJson(aCorrelation,_xTbl)
   Local nX
   Local oReturn := JsonObject():New()
   Local xArea := GetArea()
   
   DbSelectArea(_xTbl)
   For nX := 01 To Len(aCorrelation)
       cret := &(aCorrelation[nX][02])
       oReturn[aCorrelation[nX][01]] := iif( Valtype(cRet)=="C", Alltrim(cRet), cRet )
   Next
   RestArea(xArea)
Return oReturn

User Function SaveResponse(cJson)
Return Save("SaveResponse","Response",cJson)

User Function SaveRequest(cJson)
Return Save("SaveRequest","Request",cJson)

Static Function Save(xKey,cFileName,cJson)
    if GetSrvProfString("PrintJson", "N") == "S"
	   ConOut(cJson)
	Endif
    if GetSrvProfString(xKey, "N") == "S"
	   SaveJson(cFileName,cJson)
    EndIf
Return

Static Function SaveJson(xPath,cJson)
   cPath := "\Json"
   if !ExistDir(cPath)
      MakeDir( cPath)
   EndIf

   cPath+= Iif(Empty(xPath),"","\") + Alltrim(xPath)
   if !ExistDir(cPath)
      nret := MakeDir( cPath)
   EndIf

   cPath += "\"+DtoS(Date())
   if !ExistDir(cPath)
      nret := MakeDir( cPath)
   EndIf
   cPath += "\" + StrTran(Time(),":","-")+".json"
Return SaveData(cPath,cJson)

Static Function SaveData(cFileName,cData)
return MemoWrite(cFileName,cData)



User Function FJsonRetorno(aErros,lSucesso)
	Local oJsonRet := JsonObject():New()
   local nx
	Default lSucesso := .F.

	oJsonRet["sucesso"] := Iif(lSucesso,"true","false")

	oJsonRet["erros"] :={}
	coNOUT(str(Len(aErros)))
	Aadd(oJsonRet["erros"],JsonObject():New())
	For nX:=1 To Len(aErros)
		oJsonRet["erros"][nX]['codigoErro'] 	:= aErros[nX][1]
		oJsonRet["erros"][nX]['descricaoErro'] 	:= aErros[nX][2]
	Next 
Return oJsonRet


/************************************************************************************** 
* KK      KK    OOOOOO    DDDDDD      IIIIIIIIII    GGGGGGG      OOOOOO     SSSSSSS   *
* KK    KK    OO      OO  DD    DD        II      GG           OO      OO  SS         *
* KK  KK      OO      OO  DD      DD      II      GG           OO      OO  SS         *
* KKKK        OO      OO  DD      DD      II      GG     GGGG  OO      OO   SSSSSSS   *
* KK  KK      OO      OO  DD      DD      II      GG      GG   OO      OO         SS  *
* KK    KK    OO      OO  DD    DD        II      GG      GG   OO      OO         SS  *
* KK      KK    OOOOOO    DDDDDD      IIIIIIIIII    GGGGGG       OOOOOO    SSSSSSS    * 
***************************************************************************************
*         I want to change the world, but nobody gives me the source code!            * 
**************************************************************************************/








