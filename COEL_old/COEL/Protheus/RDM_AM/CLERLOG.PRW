//Função embaralha.

//Serve para ajustar as informações criptografadas dos campos do sistema Protheus.

/////////////////////////////////////////////////////
User Function CLerLog(c_alias)
/////////////////////////////////////////////////////
Local cUsuarioI,nPos
Local cStatus   := Space(10)
Local cUsuarioA := Space(15)
Local dDataI    := CTOD("")
Local dDataA    := CTOD("")
Local cTipo     := "0"
Local aCampos   := {}
Local aAux      := {}
Local aStruct   := {}
Private cAlias  := c_alias

aStruct := (cAlias)->(DbStruct())
nPos := Ascan(aStruct,{ |x| ( "USERLGI" $ x[1] .Or. "USERGI" $ x[1] ) })

If nPos != 0
   cTipo := "1"
Endif

nPos := Ascan(aStruct,{ |x| ( "USERLGA" $ x[1] .Or. "USERGA" $ x[1] ) })

If nPos != 0
   cTipo := IIF(cTipo == "1","3","2")
EnDif

If cTipo == "0"
   Help("",1,"NOLOG")
   Return
Endif

LeLog(@cStatus,@cUsuarioI,@cUsuarioA,@dDataI,@dDataA,cTipo)

Return( {cStatus , cUsuarioI , cUsuarioA , dDataI , dDataA } )

//////////////////////////////////////////////////////////////////////////////////////////////
Static Function LeLog (cStatus,cUsuarioI,cUsuarioA,dDataI,dDataA,cTipo)
//////////////////////////////////////////////////////////////////////////////////////////////

Local cUserLg := "",cCampo

cStatus := IIF(Deleted(),"Deletado","Ativo")

If cTipo $ "13"
	cCampo    := If ( Subs(cAlias, 1, 1) == "S" , Subs(cAlias,2) + "_USERLGI", cAlias+ "_USERGI" )
	cUserLG   := Embaralha(&cCampo,1)
	cUsuarioI := If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
	dDataI    := IIF(!Empty(cUserLg),CTOD("01/01/96","DDMMYY") + Load2in4(Substr(cUserLg,16)),"")
Else
	cUsuarioI := "INC-Log Nao Ativo"
Endif
If cTipo $ "23"
	cCampo    := If ( Subs(cAlias, 1, 1) == "S" ,	Subs(cAlias,2) + "_USERLGA", cAlias+ "_USERGA" )
	cUserLG   := Embaralha(&cCampo,1)
	cUsuarioA := If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
	dDataA    := IIF(!Empty(cUserLg),CTOD("01/01/96","DDMMYY") + Load2In4(Substr(cUserLg,16)),"")
Else
	cUsuarioA := "CHG-Log Nao Ativo"
Endif
Return