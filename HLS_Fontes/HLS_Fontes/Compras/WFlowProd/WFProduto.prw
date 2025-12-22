#Include "Protheus.ch"
#Include "ParmType.ch"
#include "ap5mail.ch"
#include "topconn.ch"

/*/{Protheus.doc} WFProduto

Classe responsável pela manipulação do arquivo ZB1 - Workflow de produtos

@type class
@author Guilherme Ricci - Totvs Jundiaí
@since 06/08/2018
@version Protheus 12

@see Verificar fonte MATA010_PE.PRW - Ponto de entrada
@see Verificar fonte EnvWFProd -> Job responsável pelos envios de e-mail, conforme ZB1.
@see Verificar fonte legado A010TOK -> Descontinuado por conta da nova versão do MATA010 (Cad. Produtos) em MVC.

/*/

Class WFProduto

	Data cID 			As String

	Method New() Constructor

	Method GetID()

	Method SetNewID(cProd)
	Method SetID(cValue)

	Method NewProcess(oModelSB1)
	Method UpdateWF(oModelSB1, cLevel)
	Method EndProcess(oModelSB1)
	Method ManualApproval(oModelSB1)
	Method CheckWFUpdate(oModelSB1)
	Method CheckUnlockRules(oModelSB1)
	Method UnlockProduct(oModelSB1)
	Method EndingEMail(oModelSB1)
	Method SendMail( cAssunto, cMensagem, cDestino )
	Method ConsSQLHist(cIdwf)
	Method IsMaster(cCodUsr)
	Method IsCompras(cCodUsr)
	Method IsFiscal(cCodUsr)
	Method IsPCP(cCodUsr)
	Method IsContab(cCodUsr)

EndClass

Method New() Class WFProduto

	::cID	:= ""

Return

Method GetID() Class WFProduto

Return ::cId

Method SetID(cValue) Class WFProduto

	::cId := cValue

Return

Method SetNewID(cProd) Class WFProduto

	::cID	:= Alltrim(cProd)+"/"+Substr(dtos(date()),5,2)+Substr(dtos(date()),1,4)+"-"+Alltrim(Str(Randomize(10,1000)))

Return

Method NewProcess(oModelSB1) Class WFProduto

	Local cLevel	:= ""
	Local i			:= 0
	Local cCodUsr	:= RetCodUsr()
	Local cNomeUsr	:= UsrFullname(cCodUsr)
	Local aAreaAtu	:= GetArea()

	::SetNewID(FwFldGet("B1_COD"))

	For i := 1 to 4
		/*
		Nivel 1 = Compras
		Nivel 2 = PCP
		Nivel 3 = Fiscal
		Nivel 4 = Contabilidade
		*/

		cLevel := cValtoChar(i)

		//Inicia e finaliza o processo do WF para não enviar para o Grupo do usuário que incluiu o Cadastro
		If cLevel == "1" .And. ::IsCompras()
			cStatus := "4"
			cObs	:= "Processo Iniciado - Data: "+DtoC(dDataBase)+" Hora: "+time()+ " Usuário: "+Alltrim(cNomeUsr)
		ElseIf cLevel == "2" .And. ::IsPCP()
			cStatus := "4"
			cObs	:= "Processo Iniciado - Data: "+DtoC(dDataBase)+" Hora: "+time()+ " Usuário: "+Alltrim(cNomeUsr)
		ElseIf cLevel == "3" .And. ::IsFiscal()
			cStatus := "4"
			cObs	:= "Processo Iniciado - Data: "+DtoC(dDataBase)+" Hora: "+time()+ " Usuário: "+Alltrim(cNomeUsr)
		ElseIf cLevel == "4" .And. ::IsContab()
			cStatus := "4"
			cObs	:= "Processo Iniciado - Data: "+DtoC(dDataBase)+" Hora: "+time()+ " Usuário: "+Alltrim(cNomeUsr)
		Else
			cStatus := Iif (cLevel = "1","2","1")
		Endif

		If cLevel == "2" .And. !::IsPCP()
			If !FwFldGet("B1_TIPO") $ ("MP|PI|PA")
				cStatus := "4"
				cObs 	:= "Processo Bloqueado - Tipo "+Alltrim(FwFldGet("B1_TIPO"))+" não necessita classificação PCP"
			Endif
		Endif

		RecLock ("ZB1", .T.)
		ZB1->ZB1_FILIAL	:= FwxFilial("ZB1")
		ZB1->ZB1_COD 	:= FwFldGet("B1_COD")
		ZB1->ZB1_DESC	:= FwFldGet("B1_DESC")
		ZB1->ZB1_STATUS	:= cStatus
		ZB1->ZB1_START	:= cCodUsr
		ZB1->ZB1_PROCES	:= ::cId
		ZB1->ZB1_NIVEL	:= cLevel
		ZB1->ZB1_DATA	:= dDataBase
		ZB1->ZB1_HORA	:= Time()

		If cStatus == "4"
			ZB1->ZB1_OBS	:= cObs
			ZB1->ZB1_END	:= cCodUsr
			ZB1->ZB1_DTEND	:= dDataBase
			ZB1->ZB1_HREND	:= time()
		Endif
		ZB1->(MsUnlock())
	Next i

	FwFldPut("B1_ZZUSRWF", cCodUsr,,,,.T.)
	FwFldPut("B1_ZZIDWF", ::cID,,,,.T.)
	FwFldPut("B1_MSBLQL", "1",,,,.T.)

	::UpdateWF(@oModelSB1)

	RestArea(aAreaAtu)

Return

Method UpdateWF(oModelSB1, cLevel) Class WFProduto

	Local aAreaAtu     := GetArea()
	Local aAreaZB1     := ZB1->(GetArea())
	Local cCodUsr      := RetCodUsr()
	Local cFullNameUsr := Alltrim(UsrFullname(cCodUsr))
	Local cNextLevel   := ""
	Local cLevelSB1    := ""

	Default cLevel     := ""

	cNextLevel         := Iif(!Empty(cLevel),Soma1(cLevel), "1")

	DbSelectArea("ZB1")
	DbSetOrder(4)
	DbSeek(xFilial("ZB1")+ ::cId ,.F.)

	While Alltrim( ::cID ) = Alltrim(ZB1->ZB1_PROCES) .And. ZB1->(!Eof())
		IF  ZB1->ZB1_STATUS == "2" .And. ZB1->ZB1_NIVEL == cLevel
			RecLock ("ZB1", .F.)
			ZB1->ZB1_STATUS	:= "3" //Concluido
			ZB1->ZB1_END	:= cCodUsr
			ZB1->ZB1_DTEND	:= dDataBase
			ZB1->ZB1_HREND	:= time()
			ZB1->ZB1_OBS	:= "Processo Concluido - Data: "+DtoC(dDataBase)+" Hora: "+time()+ " Usuário: " + cFullNameUsr
			ZB1->(MsUnlock())
		Endif
		//Torna Proximo Nivel Como Atual
		IF  !ZB1->ZB1_STATUS $ ("3|2") .And. ZB1->ZB1_NIVEL = cNextLevel
			If ZB1->ZB1_STATUS == "4" //Nivel Bloqueado pula para proximo
				cNextLevel := Soma1(cNextLevel)
			Else
				RecLock ("ZB1", .F.)
				ZB1->ZB1_STATUS	:= "2" //Nivel Atual
				ZB1->(MsUnlock())

				Iif(ZB1->ZB1_NIVEL == "1", cLevelSB1 := "2",cLevelSB1 )
				Iif(ZB1->ZB1_NIVEL == "2", cLevelSB1 := "3",cLevelSB1 )
				Iif(ZB1->ZB1_NIVEL == "3", cLevelSB1 := "4",cLevelSB1 )
				Iif(ZB1->ZB1_NIVEL == "4", cLevelSB1 := "5",cLevelSB1 )

			Endif
		Endif
		ZB1->(DbSkip())
	EndDo

	FwFldPut("B1_ZZNIVWF", Iif(Empty(cLevelSB1),"2",cLevelSB1),,,,.T.)

	RestArea(aAreaZB1)
	RestArea(aAreaAtu)

Return

Method EndProcess(oModelSB1) Class WFProduto

	Local aAreaAtu     := GetArea()
	Local aAreaZB1     := ZB1->(GetArea())
	Local cCodUsr      := RetCodUsr()
	Local cFullNameUsr := Alltrim(UsrFullname(cCodUsr))

	DbSelectArea("ZB1")
	DbSetOrder(4)
	DbSeek(xFilial("ZB1")+ ::cId ,.F.)

	While Alltrim( ::cID ) = Alltrim(ZB1->ZB1_PROCES) .And. ZB1->(!Eof())
		IF  !ZB1->ZB1_STATUS $ ("3|4|") //Concluido ou Bloqueado
			RecLock ("ZB1", .F.)
			ZB1->ZB1_STATUS	:= "4" //Encerrado
			ZB1->ZB1_END	:= cCodUsr
			ZB1->ZB1_DTEND	:= dDataBase
			ZB1->ZB1_HREND	:= time()
			ZB1->ZB1_OBS	:= "Processo Encerrado - Data: "+DtoC(dDataBase)+" Hora: "+time()+ " Usuário: " + cFullNameUsr
			MsUnlock ()
		Endif
		ZB1->(DbSkip())
	EndDo

	RestArea(aAreaZB1)
	RestArea(aAreaAtu)

Return

Method ManualApproval(oModelSB1) Class WFProduto

	Local aAreaAtu     := GetArea()
	Local aAreaZB1     := ZB1->(GetArea())
	Local cCodUsr      := RetCodUsr()
	Local cFullNameUsr := Alltrim(UsrFullname(cCodUsr))

	DbSelectArea("ZB1")
	DbSetOrder(2)
	DbSeek(xFilial("ZB1")+FwFldGet("B1_COD")+ SB1->B1_ZZIDWF ,.F.)

	Do While ZB1->ZB1_COD == FwFldGet("B1_COD") .And. ZB1->(!Eof()) .And. SB1->B1_ZZIDWF = ZB1->ZB1_PROCES
		IF  !ZB1->ZB1_STATUS $ ("3|4|")
			RecLock ("ZB1", .F.)
			ZB1->ZB1_STATUS	:= "4" //Encerrado
			ZB1->ZB1_OBS	:= "Processo Liberado Manualmente - Data: "+DtoC(dDataBase)+" Hora: "+time()+ " Usuário: " + cFullNameUsr
			MsUnlock ()
		Endif
		ZB1->(DbSkip())
	EndDo

	FwFldPut("B1_MSBLQL", "2",,,,.T.)
	FwFldPut("B1_ZZNIVWF", "7",,,,.T.) // Liberação Manual

	RestArea(aAreaZB1)
	RestArea(aAreaAtu)

Return

Method CheckWFUpdate(oModelSB1) Class WFProduto

	Local cLevelZB1 := ""
	Local aAreaAtu	:= GetArea()
	Local aAreaZB1	:= ZB1->(GetArea())

	If FwFldGet("B1_ZZNIVWF") == "2" .And. ::IsCompras()
		cLevelZB1 := "1"
	ElseIf FwFldGet("B1_ZZNIVWF") == "3" .And. ::IsPCP()
		cLevelZB1 := "2"
	ElseIf FwFldGet("B1_ZZNIVWF") == "4" .And. ::IsFiscal()
		cLevelZB1 := "3"
	ElseIf FwFldGet("B1_ZZNIVWF") == "5" .And. ::IsContab()
		cLevelZB1 := "4"
	Endif

	RestArea(aAreaZB1)
	RestArea(aAreaAtu)

Return cLevelZB1

Method CheckUnlockRules(oModelSB1) Class WFProduto

	Local lRet		:= .F.

	If SB1->B1_MSBLQL == "1"	 // Se o produto estiver bloqueado

		// Se for da contabilidade (final do processo) ou Admin
		If (FwFldGet("B1_ZZNIVWF") == "5" .And. ::IsContab()) .or. ::IsMaster()				//
			If Aviso('WorkFlow', 'Deseja realizar o desbloqueio deste produto?', {'Sim', 'Nao'}) == 1

				lRet := .T.

			Endif
		Endif
	Endif

Return lRet

Method UnlockProduct(oModelSB1) Class WFProduto

	Local cLevelZB1	:= ""

	If ::IsMaster() //Verifica se será Liberacao Manual
		If Aviso('WorkFlow', 'Este produto não passou por todas as etapas necessárias. Deseja liberar manualmente?', {'Sim', 'Nao'}) == 1
			::ManualApproval(@oModelSB1)
		Else
			Return
		Endif
	Else

		cLevelZB1	:= ::CheckWFUpdate(oModelSB1)

		If !Empty(cLevelZB1)
			::UpdateWF(@oModelSB1, cLevelZB1)
		Endif

		FwFldPut("B1_MSBLQL", "2",,,,.T.)
		FwFldPut("B1_ZZNIVWF", "6",,,,.T.) // Concluído normalmente

	Endif

	::EndingEMail(oModelSB1)

Return

Method EndingEMail(oModelSB1) Class WFProduto

	Local cMensagem := ""
	Local cAssunto 	:= "Workflow de Produtos [CONCLUÍDO] - "+Alltrim(FwFldGet("B1_COD"))+" - "+Alltrim(FwFldGet("B1_DESC"))
	Local cDestino 	:= UsrRetMail(Alltrim(FwFldGet("B1_ZZUSRWF")))

	cMensagem := " <font size='2'>  Prezado Sr(a). "+Alltrim(UsrFullName(Alltrim(FwFldGet("B1_ZZUSRWF"))))+",  </font> "+CRLF+CRLF
	cMensagem += " <font size='2'> O fluxo do processo Workflow do produto foi concluído, </font> "+CRLF
	cMensagem += " <font size='2'>  verifique abaixo o histórico das liberações: </font> " +CRLF+CRLF
	cMensagem += " <b> <font size='2'> Códgo: </b>"+Alltrim(FwFldGet("B1_COD"))+"</font> "+CRLF
	cMensagem += " <b> <font size='2'> Descrição: </b>"+Alltrim(FwFldGet("B1_DESC"))+"</font> "+CRLF+CRLF
	cMensagem += " <table border=1 bgcolor='LightGray'>"
	cMensagem += " <tr> "
	cMensagem += " <td> <font size='2'>  <b> Nível </font> </b> </td>   "
	cMensagem += " <td> <font size='2'>  <b> Comentário </font> </b> </td> "
	cMensagem += " </tr> "

	::ConsSQLHist(::cId)

	dbSelectArea("TRH")
	dbGoTop()
	While !TRH->(Eof())
		cMensagem +=  "<tr> "
		cMensagem +=  " <td> <font size='2'> "+Alltrim(TRH->ZB1_NIVEL)+" </font> </td> "
		cMensagem +=  " <td> <font size='2'> "+Alltrim(TRH->ZB1_OBS)+" </font> </td> "
		cMensagem +=  "</tr> "
		TRH->(DbSkip())
	Enddo

	cMensagem +=  "</table> "
	cMensagem += CRLF

	::SendMail( cAssunto, cMensagem, cDestino )

	TRH->(dbCloseArea())

Return()

Method SendMail( cAssunto, cMensagem, cDestino ) Class WFProduto

	Local cMailServer := GETMV("MV_RELSERV")
	Local cMailContX  := GETMV("MV_RELACNT")
	Local cMailSenha  := GETMV("MV_RELAPSW")
	Local cMailDest   := Alltrim(cDestino)
	Local lConnect    := .f.
	Local lEnv        := .f.
	Local lFim        := .f.

	CONNECT SMTP SERVER cMailServer ACCOUNT cMailContX PASSWORD cMailSenha RESULT lConnect

	IF GetMv("MV_RELAUTH")
		MailAuth( cMailContX, cMailSenha )
	EndIF

	If (lConnect)  // testa se a conexão foi feita com sucesso
		SEND MAIL FROM cMailContX TO cMailDest SUBJECT cAssunto BODY cMensagem RESULT lEnv
	Endif

	If ! lEnv
		GET MAIL ERROR cErro
	EndIf

	DISCONNECT SMTP SERVER RESULT lFim

Return


Method ConsSQLHist(cIdwf) Class WFProduto

	Local cQryHist := ""

	cQryHist := "SELECT 	"
	cQryHist += "	ZB1_PROCES, ZB1_OBS, 	"
	cQryHist += "	CASE ZB1_NIVEL 	"
	cQryHist += "		WHEN '1' THEN 'Compras' 	"
	cQryHist += "		WHEN '2' THEN 'Pcp' 	"
	cQryHist += "		WHEN '3' THEN 'Fiscal'   "
	cQryHist += "		WHEN '4' THEN 'Contabilidade' END ZB1_NIVEL"
	cQryHist += " FROM 	"
	cQryHist += "	"+RetSqlName('ZB1')+ " ZB1 "
	cQryHist += "WHERE 	 "
	cQryHist += "	ZB1_PROCES = '"+Alltrim(cIdwf)+"'	 "
	cQryHist += "	AND ZB1.D_E_L_E_T_ = ''	 "
	cQryHist += "ORDER BY 	"
	cQryHist += "	ZB1.R_E_C_N_O_"

	If Select("TRH") > 0
		dbSelectArea("TRH")
		TRH->(dbCloseArea())
	Endif

	MPSysOpenQuery( cQryHist, "TRH" ) // dbUseArea( .T., "TOPCONN", TCGenQry(,,cQryHist), "TRH", .F., .F. )

Return()

Method IsMaster(cCodUsr) Class WFProduto

	Local lRet		:= .F.
	Local aGrupos 	:= {}
	Local nX		:= 0

	Default cCodUsr	:= RetCodUsr()

	aGrupos := UsrRetGrp(cCodUsr)

	// Verifica Grupos que o usuario Pertence
	If cCodUsr == "000000" // Admin
		lRet	:= .T.
	Else
		For nX := 1 to Len(aGrupos)
			If aGrupos[nX] == "000000"  .Or. aGrupos[nX] == "000007" //Grupo Adminsitradores ou Usuários master do cadastro
				lRet := .T.
			Endif
		Next nX
	Endif

Return lRet

Method IsCompras(cCodUsr) Class WFProduto

	Local lRet		:= .F.
	Local cCodUsr 	:= ""
	Local aGrupos 	:= {}
	Local nX		:= 0

	Default cCodUsr	:= RetCodUsr()

	aGrupos := UsrRetGrp(cCodUsr)

	// Verifica Grupos que o usuario Pertence
	For nX := 1 to Len(aGrupos)
		If aGrupos[nX] == "000001" 	//Grupo Compras
			lRet := .T.
		Endif
	Next nX

Return lRet

Method IsPCP(cCodUsr) Class WFProduto

	Local lRet		:= .F.
	Local aGrupos 	:= {}
	Local nX		:= 0

	Default cCodUsr	:= RetCodUsr()

	aGrupos := UsrRetGrp(cCodUsr)

	// Verifica Grupos que o usuario Pertence
	For nX := 1 to Len(aGrupos)
		If aGrupos[nX] == "000002" 	//Grupo PCP
			lRet := .T.
		Endif
	Next nX

Return lRet

Method IsFiscal(cCodUsr) Class WFProduto

	Local lRet		:= .F.
	Local aGrupos 	:= {}
	Local nX		:= 0

	Default cCodUsr	:= RetCodUsr()

	aGrupos := UsrRetGrp(cCodUsr)

	// Verifica Grupos que o usuario Pertence
	For nX := 1 to Len(aGrupos)
		If aGrupos[nX] == "000003" 	//Grupo Fiscal
			lRet := .T.
		Endif
	Next nX

Return lRet

Method IsContab(cCodUsr) Class WFProduto

	Local lRet		:= .F.
	Local aGrupos 	:= {}
	Local nX		:= 0

	Default cCodUsr	:= RetCodUsr()

	aGrupos := UsrRetGrp(cCodUsr)

	// Verifica Grupos que o usuario Pertence
	For nX := 1 to Len(aGrupos)
		If aGrupos[nX] == "000004" 	//Grupo Cotabilidade
			lRet := .T.
		Endif
	Next nX

Return lRet
