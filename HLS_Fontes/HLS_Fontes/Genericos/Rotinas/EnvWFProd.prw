#include "ap5mail.ch"
#include "Protheus.Ch"
#include "TopConn.Ch"
#include "TBIConn.Ch"
#include "TbiCode.ch"

/*/{Protheus.doc} EnvWFProd

Envia o workflow de produtos de itens pendentes.

@type function
@author Honda Lock
@since 01/10/2017

/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvWFProd บAutor  ณLeandro Nascimento  บData  ณ  30/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica processamento de itens pendentes de envio wf       บฑฑ
ฑฑบ          ณHonda Lock                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function EnvWFProd()

	RPCSetType(3)
	Prepare Environment EMPRESA "01" FILIAL "01" MODULO "02"

	ConOut("Inicio WF de Produtos - Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]")

	FS_EnvWFProd()

	ConOut("T้rmino WF de Produto - Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]")

	Reset Environment

Return(Nil)

Static Function FS_EnvWFProd()

	Private _cTmpHist  := CriaTrab( nil, .f. )
	Private _cTmpItem  := CriaTrab( nil, .f. )
	Private _cTmpNum   := CriaTrab( nil, .f. )
	Private aArea      := GetArea()
	Private cGrupo		:= ""
	Private cAssunto  	:= ""
	Private cCorpoMsg	:= ""
	Private cPula     	:= CHR(13) + CHR(10)
	Private cProd		:= ""
	Private cDesc 		:= ""
	Private cEmissao 	:= ""
	Private cHora		:= ""
	Private lEnvMail 	:= .F.
	Private cQryItem 	:= ""
	Private cQryHist 	:= ""
	Private cQryConta 	:= ""
	Private aAllUser 	:= AllUsers(.T.)
	Private Classificador := ""
	Private cClassificacao := ""
	Private cDestino	:= ""
	Private cNivel 		:= ""
	Private cDataAtu	:= Dtoc(Date())
	Private cCorpoMsgC	:= ""
	Private	cMensagem	:= ""

	fConsSQLConta()

	dbSelectArea("TRC")
	dbGoTop()
	While !TRC->(Eof())


		If TRC->ZB1_NIVEL == "1" //Compras
			cNivel := "1"

			fConsSQLItem(cNivel)
			For i := 1 to Len(aAllUser)
				cNivel 		:= ""
				cCorpoMsg 	:= ""
				cCorpoMsgC	:= ""
				cMensagem	:= ""
				cClassificador := ""
				cDestino	:= ""
				cGrupo 		:= ""
				cAssunto  	:= ""
				For x := 1 to len(aAllUser[i][1][10])
					cGrupo := aAllUser[i][1][10][x]
					If	cGrupo == '000001' //Grupo Compras
						cClassificador := aAllUser[i][1][4]
						cDestino 	   := aAllUser[i][1][14]
						ConOut("WF PRODUTOS - Enviando Nivel 1) Compras - "+Alltrim(cClassificador)+" >> "+Alltrim(cDestino)+" Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]")
						cCorpoMsgC += '<font size="2"> Prezado Sr(a). '+cClassificador+',</font>'+cPula+cPula
						cCorpoMsgC += '<font size="2"> Os Seguintes produtos estใo pendentes da Classifica็ใo de Compras </font>'+cPula
						nConta := 0

						cCorpoMsg += cPula +'<b <font size="2"> *** REGISTROS *** </font></b>'+cPula+cPula
						cCorpoMsg +=  " <table border=1 bgcolor='LightGray'>"
						cCorpoMsg +=  " <tr> "
						cCorpoMsg +=  " <td> <font size='2'>  <b> C๓digo </font> </b> </td>   "
						cCorpoMsg +=  " <td> <font size='2'>  <b> Descri็ใo </font> </b> </td> "
						cCorpoMsg +=  " <td> <font size='2'>  <b> Requisitante </font> </b> </td> "
						cCorpoMsg +=  " <td> <font size='2'>  <b> ID do Processo </font> </b> </td> "
						cCorpoMsg +=  " </tr> "

						dbSelectArea("TRI")
						dbGoTop()
						While !TRI->(Eof())
							cCorpoMsg +=  "<tr> "
							cCorpoMsg +=  " <td> <font size='2'> "+Alltrim(TRI->ZB1_COD)+" </font> </td> "
							cCorpoMsg +=  " <td> <font size='2'> "+Alltrim(TRI->ZB1_DESC)+" </font> </td> "
							cCorpoMsg +=  " <td> <font size='2'> "+UsrFullName(Alltrim(TRI->ZB1_START))+" </font> </td> "
							cCorpoMsg +=  " <td> <font size='2'> "+Alltrim(TRI->ZB1_PROCES)+" </font> </td> "
							cCorpoMsg +=  "</tr> "
							nConta++
							TRI->(DbSkip())
						Enddo
						cCorpoMsg +=  "</table> "
						cCorpoMsg += cPula

						cCorpoMsgC += cPula +'<b <font size="2"> *** INFORMAวีES *** </font></b>'+cPula
						cCorpoMsgC += "Total de Registros Pendentes: "+Alltrim(Str(nConta))+cPula
						cCorpoMsgC += "Data da Consulta: "+cDataAtu+cPula
						cCorpoMsgC += "Horแrio da Consulta: "+Time()
						cCorpoMsgC += cPula

						cMensagem := cCorpoMsgC+cCorpoMsg

						cAssunto  := "WorkFlow de Produtos - Classifica็ใo de Compras"
						MonitMail( cAssunto, cMensagem, cDestino)
					Endif
				Next x
			next i

		ElseIf TRC->ZB1_NIVEL == "2" //Pcp
			cNivel := "2"
			fConsSQLItem(cNivel)

			For i := 1 to Len(aAllUser)
				cNivel 		:= ""
				cCorpoMsg 	:= ""
				cCorpoMsgC	:= ""
				cMensagem	:= ""
				cClassificador := ""
				cDestino	:= ""
				cGrupo 		:= ""
				cAssunto  	:= ""
				For x := 1 to len(aAllUser[i][1][10])
					cGrupo := aAllUser[i][1][10][x]
					If	cGrupo == '000002' //Grupo Pcp
						cClassificador := aAllUser[i][1][4]
						cDestino 	   := aAllUser[i][1][14]
						ConOut("WF PRODUTOS - Enviando Nivel 2) PCP - "+Alltrim(cClassificador)+" >> "+Alltrim(cDestino)+"  Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]")
						cCorpoMsgC += '<font size="2"> Prezado Sr(a). '+cClassificador+',</font>'+cPula+cPula
						cCorpoMsgC += '<font size="2"> Os Seguintes produtos estใo pendentes da Classifica็ใo do PCP </font>'+cPula
						nConta := 0

						cCorpoMsg += cPula +'<b <font size="2"> *** REGISTROS *** </font></b>'+cPula+cPula
						cCorpoMsg +=  " <table border=1 bgcolor='LightGray'>"
						cCorpoMsg +=  " <tr> "
						cCorpoMsg +=  " <td> <font size='2'>  <b> C๓digo </font> </b> </td>   "
						cCorpoMsg +=  " <td> <font size='2'>  <b> Descri็ใo </font> </b> </td> "
						cCorpoMsg +=  " <td> <font size='2'>  <b> Requisitante </font> </b> </td> "
						cCorpoMsg +=  " <td> <font size='2'>  <b> ID do Processo </font> </b> </td> "
						cCorpoMsg +=  " </tr> "

						dbSelectArea("TRI")
						dbGoTop()
						While !TRI->(Eof())
							cCorpoMsg +=  "<tr> "
							cCorpoMsg +=  " <td> <font size='2'> "+Alltrim(TRI->ZB1_COD)+" </font> </td> "
							cCorpoMsg +=  " <td> <font size='2'> "+Alltrim(TRI->ZB1_DESC)+" </font> </td> "
							cCorpoMsg +=  " <td> <font size='2'> "+UsrFullName(Alltrim(TRI->ZB1_START))+" </font> </td> "
							cCorpoMsg +=  " <td> <font size='2'> "+Alltrim(TRI->ZB1_PROCES)+" </font> </td> "
							cCorpoMsg +=  "</tr> "
							nConta++
							//						MarcaZb1(TRI->ZB1_PROCES, TRI->ZB1_NIVEL)
							TRI->(DbSkip())
						Enddo
						cCorpoMsg +=  "</table> "
						cCorpoMsg += cPula

						cCorpoMsgC += cPula +'<b <font size="2"> *** INFORMAวีES *** </font></b>'+cPula
						cCorpoMsgC += "Total de Registros Pendentes: "+Alltrim(Str(nConta))+cPula
						cCorpoMsgC += "Data da Consulta: "+cDataAtu+cPula
						cCorpoMsgC += "Horแrio da Consulta: "+Time()
						cCorpoMsgC += cPula

						cMensagem := cCorpoMsgC+cCorpoMsg

						cAssunto  := "WorkFlow de Produtos - Classifica็ใo PCP"
						MonitMail( cAssunto, cMensagem, cDestino)
					Endif
				Next x
			next i


		ElseIf TRC->ZB1_NIVEL == "3" //Fiscal
			cNivel := "3"
			fConsSQLItem(cNivel)

			For i := 1 to Len(aAllUser)
				cNivel 		:= ""
				cCorpoMsg 	:= ""
				cCorpoMsgC	:= ""
				cMensagem	:= ""
				cClassificador := ""
				cDestino	:= ""
				cGrupo 		:= ""
				cAssunto  	:= ""

				For x := 1 to len(aAllUser[i][1][10])
					cGrupo := aAllUser[i][1][10][x]
					If	cGrupo == '000003' //Grupo Fiscal
						cClassificador := aAllUser[i][1][4]
						cDestino 	   := aAllUser[i][1][14]
						ConOut("WF PRODUTOS - Enviando Nivel 3) Fiscal - "+Alltrim(cClassificador)+" >> "+Alltrim(cDestino)+" Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]")
						cCorpoMsgC += '<font size="2"> Prezado Sr(a). '+cClassificador+',</font>'+cPula+cPula
						cCorpoMsgC += '<font size="2"> Os Seguintes produtos estใo pendentes da Classifica็ใo Fiscal </font>'+cPula
						nConta := 0

						cCorpoMsg += cPula +'<b <font size="2"> *** REGISTROS *** </font></b>'+cPula+cPula
						cCorpoMsg +=  " <table border=1 bgcolor='LightGray'>"
						cCorpoMsg +=  " <tr> "
						cCorpoMsg +=  " <td> <font size='2'>  <b> C๓digo </font> </b> </td>   "
						cCorpoMsg +=  " <td> <font size='2'>  <b> Descri็ใo </font> </b> </td> "
						cCorpoMsg +=  " <td> <font size='2'>  <b> Requisitante </font> </b> </td> "
						cCorpoMsg +=  " <td> <font size='2'>  <b> ID do Processo </font> </b> </td> "
						cCorpoMsg +=  " </tr> "

						dbSelectArea("TRI")
						dbGoTop()
						While !TRI->(Eof())
							cCorpoMsg +=  "<tr> "
							cCorpoMsg +=  " <td> <font size='2'> "+Alltrim(TRI->ZB1_COD)+" </font> </td> "
							cCorpoMsg +=  " <td> <font size='2'> "+Alltrim(TRI->ZB1_DESC)+" </font> </td> "
							cCorpoMsg +=  " <td> <font size='2'> "+UsrFullName(Alltrim(TRI->ZB1_START))+" </font> </td> "
							cCorpoMsg +=  " <td> <font size='2'> "+Alltrim(TRI->ZB1_PROCES)+" </font> </td> "
							cCorpoMsg +=  "</tr> "
							//						MarcaZb1(TRI->ZB1_PROCES, TRI->ZB1_NIVEL)
							nConta++
							TRI->(DbSkip())
						Enddo
						cCorpoMsg +=  "</table> "
						cCorpoMsg += cPula

						cCorpoMsgC += cPula +'<b <font size="2"> *** INFORMAวีES *** </font></b>'+cPula
						cCorpoMsgC += "Total de Registros Pendentes: "+Alltrim(Str(nConta))+cPula
						cCorpoMsgC += "Data da Consulta: "+cDataAtu+cPula
						cCorpoMsgC += "Horแrio da Consulta: "+Time()
						cCorpoMsgC += cPula

						cMensagem := cCorpoMsgC+cCorpoMsg

						cAssunto  := "WorkFlow de Produtos - Classifica็ใo Fiscal"
						MonitMail( cAssunto, cMensagem, cDestino)
					Endif
				Next x
			next i


		ElseIf TRC->ZB1_NIVEL == "4" //Contabilidade
			cNivel := "4"
			fConsSQLItem(cNivel)

			For i := 1 to Len(aAllUser)
				cNivel 		:= ""
				cCorpoMsg 	:= ""
				cCorpoMsgC	:= ""
				cMensagem	:= ""
				cClassificador := ""
				cDestino	:= ""
				cGrupo 		:= ""
				cAssunto  	:= ""

				For x := 1 to len(aAllUser[i][1][10])
					cGrupo := aAllUser[i][1][10][x]
					If	cGrupo == '000004' //Grupo Contabilidade
						cClassificador := aAllUser[i][1][4]
						cDestino 	   := aAllUser[i][1][14]
						ConOut("WF PRODUTOS - Enviando Nivel 6) Contabilidade - "+Alltrim(cClassificador)+" >> "+Alltrim(cDestino)+" Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]")
						cCorpoMsgC += '<font size="2"> Prezado Sr(a). '+cClassificador+',</font>'+cPula+cPula
						cCorpoMsgC += '<font size="2"> Os Seguintes produtos estใo pendentes da Classifica็ใo Contแbil </font>'+cPula
						nConta := 0

						cCorpoMsg += cPula +'<b <font size="2"> *** REGISTROS *** </font></b>'+cPula+cPula
						cCorpoMsg +=  " <table border=1 bgcolor='LightGray'>"
						cCorpoMsg +=  " <tr> "
						cCorpoMsg +=  " <td> <font size='2'>  <b> C๓digo </font> </b> </td>   "
						cCorpoMsg +=  " <td> <font size='2'>  <b> Descri็ใo </font> </b> </td> "
						cCorpoMsg +=  " <td> <font size='2'>  <b> Requisitante </font> </b> </td> "
						cCorpoMsg +=  " <td> <font size='2'>  <b> ID do Processo </font> </b> </td> "
						cCorpoMsg +=  " </tr> "

						dbSelectArea("TRI")
						dbGoTop()
						While !TRI->(Eof())
							cCorpoMsg +=  "<tr> "
							cCorpoMsg +=  " <td> <font size='2'> "+Alltrim(TRI->ZB1_COD)+" </font> </td> "
							cCorpoMsg +=  " <td> <font size='2'> "+Alltrim(TRI->ZB1_DESC)+" </font> </td> "
							cCorpoMsg +=  " <td> <font size='2'> "+UsrFullName(Alltrim(TRI->ZB1_START))+" </font> </td> "
							cCorpoMsg +=  " <td> <font size='2'> "+Alltrim(TRI->ZB1_PROCES)+" </font> </td> "
							cCorpoMsg +=  "</tr> "
							nConta++
							TRI->(DbSkip())
						Enddo
						cCorpoMsg +=  "</table> "
						cCorpoMsg += cPula

						cCorpoMsgC += cPula +'<b <font size="2"> *** INFORMAวีES *** </font></b>'+cPula
						cCorpoMsgC += "Total de Registros Pendentes: "+Alltrim(Str(nConta))+cPula
						cCorpoMsgC += "Data da Consulta: "+cDataAtu+cPula
						cCorpoMsgC += "Horแrio da Consulta: "+Time()
						cCorpoMsgC += cPula

						cMensagem := cCorpoMsgC+cCorpoMsg

						cAssunto  := "WorkFlow de Produtos - Classifica็ใo Contแbil"
						MonitMail( cAssunto, cMensagem, cDestino)
					Endif
				Next x
			next i
		Endif

		MarcaZb1()
		TRC->(DbSkip())
	Enddo
	dbCloseArea("TRC")
Return()


//Funcao para marcar o WF de produto como enviado
Static Function MarcaZb1()

	If Select("ZB1") > 0
		dbSelectArea("ZB1")
		dbCloseArea("ZB1")
	Endif

	dbSelectArea("TRI")
	dbGoTop()
	While !TRI->(Eof())

		DbSelectArea("ZB1")
		DbSetOrder(4)
		DbSeek(xFilial("ZB1")+TRI->ZB1_PROCES+TRI->ZB1_NIVEL,.F.)

		Do While ZB1->ZB1_PROCES = TRI->ZB1_PROCES .And. ZB1->ZB1_NIVEL = TRI->ZB1_NIVEL .And. ZB1->(!Eof())
			RecLock ("ZB1", .F.)
			ZB1->ZB1_SITUWF	:= "E" //Enviado para WF
			MsUnlock ()
			ZB1->(DbSkip())
		EndDo

		TRI->(DbSkip())
	Enddo

	dbCloseArea("TRI")

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfConsSQL  บAutor  ณLeandro Nascimento  บ Data ณ  30/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a String da Consulta                                 บฑฑ
ฑฑบ          ณHonda Lock                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fConsSQLHist(cCodigo)

	cQryHist := "SELECT "
	cQryHist += "	B1_ZZIDWF, B1_COD, B1_DESC, "
	cQryHist += "	CASE ZB1_NIVEL "
	cQryHist += "	WHEN '1' THEN 'Compras' "
	cQryHist += "	WHEN '2' THEN 'Pcp' "
	cQryHist += "	WHEN '3' THEN 'Fiscal' "
	cQryHist += "	WHEN '4' THEN 'Contabilidade' END ZB1_NIVEL, "
	cQryHist += "	CASE ZB1_STATUS "
	cQryHist += "	WHEN '0' THEN ' Nใo Iniciado' "
	cQryHist += "	WHEN '1' THEN 'Aguard. Nํvel Anterior' "
	cQryHist += "	WHEN '2' THEN 'Nํvel Atual' "
	cQryHist += "	WHEN '3' THEN 'Concluํdo' "
	cQryHist += "	WHEN '4' THEN 'Bloqueado' END ZB1_STATUS, "
	cQryHist += "	B1_ZZUSRWF, ZB1_OBS, ZB1_DATA, ZB1_HORA "
	cQryHist += "FROM "
	cQryHist += "	"+RetSqlName('ZB1')+ " ZB1 "
	cQryHist += "	INNER JOIN "+RetSqlName('SB1')+" B1 ON B1_ZZIDWF = ZB1_PROCES AND B1_COD = ZB1_COD AND B1.D_E_L_E_T_ = '' "
	cQryHist += "WHERE "
	cQryHist += "	ZB1_SITUWF <> 'E' "
	cQryHist += "	AND ZB1_COD = '"+Alltrim(cCodigo)+"'	 "
	cQryHist += "	AND ZB1.D_E_L_E_T_ = ''	 "
	cQryHist += "ORDER BY "
	cQryHist += "	ZB1.R_E_C_N_O_ "

	If Select("TRH") > 0
		dbSelectArea("TRH")
		dbCloseArea("TRH")
	Endif

	MPSysOpenQuery( cQryHist, "TRH" ) // dbUseArea( .T., "TOPCONN", TCGenQry(,,cQryHist), "TRH", .F., .F. )

Return()

Static Function fConsSQLItem(cNivel)

	cQryItem := "SELECT "
	cQryItem += "	ZB1_COD, ZB1_DESC, ZB1_PROCES, ZB1_NIVEL, ZB1_START "
	cQryItem += "FROM "
	cQryItem += "	"+RetSqlName('ZB1')+ " ZB1 "
	cQryItem += "WHERE "
	cQryItem += "	ZB1_SITUWF <> 'E' "
	cQryItem += "	AND ZB1_STATUS = '2' "
	cQryItem += "	AND ZB1_NIVEL = '"+cNivel+"' "
	cQryItem += "	AND ZB1.D_E_L_E_T_ = ''	 "
	cQryItem += "ORDER BY "
	cQryItem += "	ZB1.R_E_C_N_O_ "

	If Select("TRI") > 0
		dbSelectArea("TRI")
		dbCloseArea("TRI")
	Endif

	MPSysOpenQuery( cQryItem, "TRI" ) // dbUseArea( .T., "TOPCONN", TCGenQry(,,cQryItem), "TRI", .F., .F. )

Return()

Static Function fConsSQLConta()

	cQryConta := "SELECT DISTINCT(ZB1_NIVEL) FROM "+RetSqlName('ZB1')+" WHERE ZB1_STATUS = '2' AND ZB1_SITUWF <> 'E'  "

	If Select("TRC") > 0
		dbSelectArea("TRC")
		dbCloseArea("TRC")
	Endif

	MPSysOpenQuery( cQryConta, "TRC" ) // dbUseArea( .T., "TOPCONN", TCGenQry(,,cQryConta), "TRC", .F., .F. )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMonitMail บAutor  ณLeandro Nascimento  บ Data ณ  30/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia email para os niveis pendentes                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MonitMail( cAssunto, cMensagem, cDestino )

	Local cMailServer := GETMV("MV_RELSERV")
	Local cMailContX  := GETMV("MV_RELACNT")
	Local cMailSenha  := GETMV("MV_RELAPSW")
	Local cMailDest   := Alltrim(cDestino)
	//Local cMailDest   := "l.nascimento@hondalock-sp.com.br"
	Local lConnect    := .f.
	Local lEnv        := .f.
	Local lFim        := .f.

	CONNECT SMTP SERVER cMailServer ACCOUNT cMailContX PASSWORD cMailSenha RESULT lConnect

	IF GetMv("MV_RELAUTH")
		MailAuth( cMailContX, cMailSenha )
	EndIF

	If (lConnect)  // testa se a conexใo foi feita com sucesso
		SEND MAIL FROM cMailContX TO cMailDest SUBJECT cAssunto BODY cMensagem RESULT lEnv
	Endif

	If ! lEnv
		GET MAIL ERROR cErro
	EndIf

	DISCONNECT SMTP SERVER RESULT lFim


Return(nil)
