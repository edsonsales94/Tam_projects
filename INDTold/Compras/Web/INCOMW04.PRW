#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³W04FORMA º Autor ³ ENER FREDES        º Data ³  17/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Follow Up de Centro de CustoCompra                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ INDT                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INCOMW04(cFil,cCC,dIni,dFim)
  Local cHTML := ""
  Local cFil,cNumSC
  Local aIdioma := {}                        
  Private nHdl       
  Private cLinha     := ""
  Private cIdioma                       
  Private cServerHttp      

  cServerHttp :=  Getmv("MV_SERHTTP")
  cCusto    := cCC
  dDataini  :=  Ctod(dIni)
  dDatafim  :=  Ctod(dFim)
  nHdl:= fCreate("\web\FOL"+cCusto+".xls")
  aIdioma := u_INCOMWID("P")
  CTT->(DbSetOrder(1))
  If (CTT->(DbSeek(xFilial("CTT")+cCusto))) .And. !Empty(cCusto)
    cHTML += '<p><div align="center"><font face="Arial" size=4 color=#0000FF>  <strong>'+cCusto+" - "+CTT->CTT_DESC01+'</strong></font></div>'//Centro de Custo Consultado
    cLinha := cCusto+" - "+CTT->CTT_DESC01+Chr(9)+chr(13)+chr(10)
    fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
  Else
    cHTML += '<p><div align="center"><font face="Arial" size=4 color=#0000FF>  <strong>Centro de Custo Inválido !</strong></font></div>'//Centro de Custo não informado
    cLinha := "Centro de Custo Inválido !"+Chr(9)+chr(13)+chr(10)
    fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
    Return cHTML            
  EndIf  
  cHTML += '<p>
  cHTML += '<p>
  cHTML += '<a href="http://'+cServerHttp+'/FOL'+cCusto+'.xls" title="ARQUIVO">Gera Excel</a>' 
  cLinha := Chr(9)+chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
  cLinha := "Solicitações de Compra"+Chr(9)+chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cHTML += fVerSC(cFil,cCusto,dDataini,dDatafim)

  cLinha := Chr(9)+chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cLinha := "Pedidos de Compra"+Chr(9)+chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cHTML += fVerPC(cFil,cCusto,dDataini,dDatafim)
Return cHTML            

Static Function fVerSC(cFil,cCusto,dDataini,dDatafim)
  Local cPedido 
  Local cQuery         
  Local cHTML := ""

  cLinha := "Filial"+Chr(9)
  cLinha += "Número SC"+Chr(9)
  cLinha += "Dt.Emissão"+Chr(9)
  cLinha += "Solicitante"+Chr(9)
  cLinha += "Comprador"+Chr(9)
  cLinha += chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cHTML += '<p><div align="center"><font face="Arial" size=3 color=#0000FF>  <strong>Relação de Solicitação de Compras</strong></font></div>'//Relação de Requisição de Compras

  cQuery := " SELECT C1_FILIAL,C1_NUM,C1_EMISSAO,C1_SOLICIT,Y1_NOME
  cQuery += " FROM "+RetSQLName("SC1")+ " SC1"
  cQuery += " INNER JOIN "+RetSQLName("SY1")+ " SY1 ON C1_CODCOMP = Y1_COD AND SY1.D_E_L_E_T_ <> '*'"
  cQuery += " WHERE SC1.D_E_L_E_T_ <> '*' AND C1_CC = '"+cCusto+"' AND C1_FILIAL = '"+cFil+"'"
  cQuery += " AND C1_EMISSAO >= '"+dTos(dDataini)+"' AND C1_EMISSAO <= '"+dTos(dDatafim)+"'
  cQuery += " GROUP BY C1_FILIAL,C1_NUM,C1_EMISSAO,C1_SOLICIT,Y1_NOME
  cQuery += " ORDER BY C1_FILIAL,C1_EMISSAO

  dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"TEMP",.F.,.T.)
  TcSetField("TEMP","C1_EMISSAO","D")

  cHTML += '<DIV id=table>
  cHTML += ' <table border="0" width="80%" id="table2">
  cHTML += '<tr><th>Filial</th><th>Número SC</th><th>Dt.Emissão</th><th>Solicitante</th><th>Comprador</th></tr>'
                                             
  While !TEMP->(Eof())
    cHTML += '<tr>'
    cHTML += '<td>'+TEMP->C1_FILIAL+'</td>'

    cHtml += '<td><a href="http://'+cServerHttp+'u_INCOMW_4.apl?&FILIAL='+TEMP->C1_FILIAL+'&Req='+TEMP->C1_NUM+'&Tipo=1"><font color="#0000FF" style="cursor: pointer">'+TEMP->C1_NUM+'</font></a></td>'
    cHTML += '<td>'+Dtoc(TEMP->C1_EMISSAO)+'</td>'
    cHTML += '<td>'+TEMP->C1_SOLICIT+'</td>'
    cHTML += '<td>'+TEMP->Y1_NOME+'</td>'
    cHTML += '</tr>'

    cLinha := TEMP->C1_FILIAL+Chr(9)
    cLinha += TEMP->C1_NUM+Chr(9)
    cLinha += Dtoc(TEMP->C1_EMISSAO)+Chr(9)
    cLinha += TEMP->C1_SOLICIT+Chr(9)
    cLinha += TEMP->Y1_NOME+Chr(9)
    cLinha += chr(13)+chr(10)
    fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

    TEMP->(DbSkip())
  End
  cHTML += '</table>'
  cHTML += '</DIV>
  DbSelectArea("TEMP")
  DbCloseArea("TEMP")
Return cHtml


Static Function fVerPC(cFil,cCusto,dDataini,dDatafim)
	Local cPedido 
	Local cQuery         
	Local cHTML := ""
	Local cStatus := ""
	
	cLinha := "Filial"+Chr(9)
	cLinha += "Pedido"+Chr(9)
	cLinha += "Emissão"+Chr(9)
	cLinha += "Solicitação"+Chr(9)
	cLinha += "Comprador"+Chr(9)
	cLinha += "Entr.Compas"+Chr(9)
	cLinha += "Status"+Chr(9)
	cLinha += chr(13)+chr(10)
	fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	cHTML += '<p><div align="center"><font face="Arial" size=3 color=#0000FF>  <strong>Relação de Pedidos de Compra</strong></font></div>'
	
	
	cQuery := " SELECT C7_FILIAL,C7_NUM,C7_EMISSAO,C7_NUMSC,C7_CC,ISNULL(ZD_DATAEC,'') ZD_DATAEC,ISNULL(Y1_NOME,'')Y1_NOME,C7_RESIDUO,SUM(C7_QUANT) C7_QUANT ,SUM(C7_QUJE) C7_QUJE
	cQuery += " FROM "+RetSQLName("SC7")+ " SC7
	cQuery += " LEFT OUTER JOIN	( 
	cQuery += " 					SELECT ZD_FILIAL,ZD_PEDIDO,ZD_COMP,Y1_NOME,ZD_DATAEC 
	cQuery += " 					FROM "+RetSQLName("SZD")+ " SZD 
	cQuery += " 					LEFT OUTER JOIN "+RetSQLName("SY1")+ " SY1 ON ZD_COMP = Y1_COD AND SY1.D_E_L_E_T_ = ''
	cQuery += " 					WHERE SZD.D_E_L_E_T_ = ''
	cQuery += " 					GROUP BY ZD_FILIAL,ZD_PEDIDO,ZD_COMP,Y1_NOME,ZD_DATAEC 
	cQuery += " 				) SZD ON C7_FILIAL = ZD_FILIAL AND C7_NUM = ZD_PEDIDO
	cQuery += " WHERE SC7.D_E_L_E_T_ = ''
	cQuery += " AND C7_FILIAL = '"+cFil+"' "
	cQuery += " AND C7_CC = '"+cCusto+"' "
	cQuery += " AND C7_EMISSAO BETWEEN '"+dTos(dDataini)+"' AND '"+dTos(dDatafim)+"'
	cQuery += " AND C7_CONTRA = ''
	cQuery += " GROUP BY C7_FILIAL,C7_NUM,C7_EMISSAO,C7_NUMSC,C7_CC,ZD_DATAEC,Y1_NOME,C7_RESIDUO
	cQuery += " ORDER BY C7_FILIAL,C7_NUM
	
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"TEMP",.F.,.T.)
	TcSetField("TEMP","C7_EMISSAO","D")   
	TcSetField("TEMP","ZD_DATAEC","D")   
	
	cHTML += '<DIV id=table>
	cHTML += ' <table border="0" width="80%" id="table2">
	cHTML += '<tr><th>Filial</th><th>Pedido</th><th>Emissão</th><th>Solicitação</th><th>Comprador</th><th>Ent.Compra</th><th>Status</th></tr>'
	
	While !TEMP->(Eof())      
		If TEMP->C7_QUANT == TEMP->C7_QUJE
			cStatus := "Pedido Encerrado"
		Else                 
			If TEMP->C7_RESIDUO == 'S'
				cStatus := "Pedido Cancelado"
			Else
				cStatus := "Pedido em Andamento"
			EndIf
		EndIf
		cHTML += '<tr>'
		cHTML += '<td>'+TEMP->C7_FILIAL+'</td>'
		
		cHtml += '<td><a href="http://'+cServerHttp+'u_INCOMW_4.apl?&FILIAL='+TEMP->C7_FILIAL+'&Req='+TEMP->C7_NUM+'&Tipo=2"><font color="#0000FF" style="cursor: pointer">'+TEMP->C7_NUM+'</font></a></td>'
		cHTML += '<td>'+Dtoc(TEMP->C7_EMISSAO)+'</td>'
		cHtml += '<td><a href="http://'+cServerHttp+'u_INCOMW_4.apl?&FILIAL='+TEMP->C7_FILIAL+'&Req='+TEMP->C7_NUMSC+'&Tipo=1"><font color="#0000FF" style="cursor: pointer">'+TEMP->C7_NUMSC+'</font></a></td>'
		cHTML += '<td>'+TEMP->Y1_NOME+'</td>'
		cHTML += '<td>'+Dtoc(TEMP->ZD_DATAEC)+'</td>'
		cHTML += '<td>'+cStatus+'</td>'
		cHTML += '</tr>'
		
		cLinha := TEMP->C7_FILIAL+Chr(9)
		cLinha += TEMP->C7_NUM+Chr(9)
		cLinha += Dtoc(TEMP->C7_EMISSAO)+Chr(9)
		cLinha += TEMP->C7_NUMSC+Chr(9)
		cLinha += TEMP->Y1_NOME+Chr(9)
		cLinha += Dtoc(TEMP->ZD_DATAEC)+Chr(9)
		cLinha += cStatus+Chr(9)
		cLinha += chr(13)+chr(10)
		fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
		
		TEMP->(DbSkip())
	End
	cHTML += '</table>'
	cHTML += '</DIV>
	DbSelectArea("TEMP")
	DbCloseArea("TEMP")
Return cHTML


User Function INCOMW_4(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)
	Local cServerHttp      
	Local cHTML := ""
	Local cFil,cNumSC
	Local aIdioma := {}                        
	Private cIdioma                       
	Prepare Environment Empresa "01" Filial "01" Tables "SA2,SB1"
	cServerHttp :=  Getmv("MV_SERHTTP")
	cFil      := Alltrim(__aProcParms[1,2])
	cNum      := Alltrim(__aProcParms[2,2])
	cTipo     := Alltrim(__aProcParms[3,2])
	aIdioma := u_INCOMWID("P")
	cHTML := '<html>
	cHTML += '<head>
	cHTML += '<meta http-equiv="Content-Language" content="en-us">
	cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
	cHTML += '</head>
	cHTML += '<body>  
	cHTML += u_INCOMWST(.F.)
	
	If cTipo == "1"
		cHTML += U_INCOMW02(cFil,cNum) //UsrRetMail("000055")//
	ElseIf cTipo == "2"
		cHTML += U_INCOMW03(cFil,cNum)
	ElseIf cTipo == "3"
		cHTML += U_INVIAW01(cFil,cNum)
	EndIf
	
	cHTML += '</body>  
	cHTML += '</html>
Return cHTML            

