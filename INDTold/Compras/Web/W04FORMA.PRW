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

User Function W04FORMA(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)
  Local cHTML := ""
  Local cFil,cNumSC
  Local aIdioma := {}                        
  Private nHdl       
  Private cLinha     := ""
  Private cIdioma                       
  Private cServerHttp      
  Prepare Environment Empresa "01" Filial "01" Tables "SA2,SB1"
  cServerHttp :=  Getmv("MV_SERHTTP")
  cIdioma   :=  Upper(Alltrim(__aProcParms[2,2]))
  If at("-",__aProcParms[1,2]) == 0
    cCusto    := Alltrim(__aProcParms[1,2])
  Else  
    cCusto    := IIf(Empty(__aProcParms[1,2]),"",Alltrim(SubStr(__aProcParms[1,2],1,at("-",__aProcParms[1,2])-1)))  
  EndIf
  cIdioma   :=  Upper(Alltrim(__aProcParms[2,2]))
  dDataini  :=  Ctod(Upper(Alltrim(__aProcParms[3,2])))
  dDatafim  :=  Ctod(Upper(Alltrim(__aProcParms[4,2])))
  nHdl:= fCreate("\web\FOL"+cCusto+".xls")
  aIdioma := U_F01INDIO(cIdioma)
  cHTML := '<html>
  cHTML += '<head>
  cHTML += '<meta http-equiv="Content-Language" content="en-us">
  cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
  cHTML += '</head>
  cHTML += '<body>  
  cHTML += u_styleCSS(.T.)
  cHTML += '<a href="http://intranet.indt.org"><img src="http://intranet.indt.org/indt.gif" alt="INdT" width="132" height="76" border="0" /></a>  
//  cHTML += '<p><div align="center"><font face="Arial" size=5 color=#0000FF>  <strong>Em desenvolvimento..... </strong></font></div>'//Centro de Custo não informado
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


  cHTML += fVerSC(cCusto,dDataini,dDatafim)

  cLinha := Chr(9)+chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
  cLinha := "Requisições de Compra"+Chr(9)+chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cHTML += fVerRC(cCusto,dDataini,dDatafim)
//  cHTML += fVerPC(cCusto)
//  cHTML += fVerNFE(cCusto)
//  cHTML += fVerTit(cCusto)
  cHTML += '</body>  
  cHTML += '</html>

Return cHTML            

Static Function fVerSC(cCusto,dDataini,dDatafim)
  Local cPedido 
  Local cQuery         
  Local cHTML := ""

  cLinha := "Filial"+Chr(9)
  cLinha += "Número SC"+Chr(9)
  cLinha += "Dt.Emissão"+Chr(9)
  cLinha += "Solicitante"+Chr(9)
  cLinha += "Comprador"+Chr(9)
  cLinha += "Número RC"+Chr(9)
  cLinha += chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cHTML += '<p><div align="center"><font face="Arial" size=3 color=#0000FF>  <strong>Relação de Solicitação de Compras</strong></font></div>'//Relação de Requisição de Compras

  cQuery := " SELECT C1_FILIAL,C1_NUM,C1_EMISSAO,C1_SOLICIT,C1_NROREQ,C1_NUMREQ,Y1_NOME
  cQuery += " FROM "+RetSQLName("SC1")+ " SC1"
  cQuery += " INNER JOIN "+RetSQLName("SY1")+ " SY1 ON C1_CODCOMP = Y1_COD AND SY1.D_E_L_E_T_ <> '*'"
  cQuery += " WHERE SC1.D_E_L_E_T_ <> '*' AND C1_CC = '"+cCusto+"' "
  cQuery += " AND C1_EMISSAO >= '"+dTos(dDataini)+"' AND C1_EMISSAO <= '"+dTos(dDatafim)+"'
  cQuery += " GROUP BY C1_FILIAL,C1_NUM,C1_EMISSAO,C1_SOLICIT,C1_NROREQ,C1_NUMREQ,Y1_NOME
  cQuery += " ORDER BY C1_FILIAL,C1_EMISSAO

  dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"TEMP",.F.,.T.)
  TcSetField("TEMP","C1_EMISSAO","D")


  cHTML += '<DIV id=table>
  cHTML += ' <table border="0" width="80%" id="table2">
  cHTML += '<tr><th>Filial</th><th>Número SC</th><th>Dt.Emissão</th><th>Solicitante</th><th>Comprador</th><th>Número RC</th></tr>'
                                             
  While !TEMP->(Eof())
    cHTML += '<tr>'
    cHTML += '<td>'+TEMP->C1_FILIAL+'</td>'

    cHtml += '<td><a href="http://'+cServerHttp+'u_w04fr8_1.apl?&FILIAL='+TEMP->C1_FILIAL+'&Req='+TEMP->C1_NROREQ+'&cIdioma='+cIdioma+'"><font color="#0000FF" style="cursor: pointer">'+TEMP->C1_NUM+'</font></a></td>'
    cHTML += '<td>'+Dtoc(TEMP->C1_EMISSAO)+'</td>'
    cHTML += '<td>'+TEMP->C1_SOLICIT+'</td>'
    cHTML += '<td>'+TEMP->Y1_NOME+'</td>'
    cHtml += '<td><a href="http://'+cServerHttp+'u_w04form5.apl?FILIAL='+TEMP->C1_FILIAL+'&Req='+TEMP->C1_NUMREQ+'&Tipo=2&cIdioma='+cIdioma+'"><font color="#0000FF" style="cursor: pointer">'+TEMP->C1_NUMREQ+'</font></a></td>'    
    cHTML += '</tr>'

    cLinha := TEMP->C1_FILIAL+Chr(9)
    cLinha += TEMP->C1_NUM+Chr(9)
    cLinha += Dtoc(TEMP->C1_EMISSAO)+Chr(9)
    cLinha += TEMP->C1_SOLICIT+Chr(9)
    cLinha += TEMP->Y1_NOME+Chr(9)
    cLinha += TEMP->C1_NUMREQ+Chr(9)
    cLinha += chr(13)+chr(10)
    fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

    TEMP->(DbSkip())
  End
  cHTML += '</table>'
  cHTML += '</DIV>
  DbSelectArea("TEMP")
  DbCloseArea("TEMP")

Return cHtml

Static Function fVerRC(cCusto,dDataini,dDatafim)
  Local cPedido 
  Local cQuery 
  local nTot1 := 0
  local nTot2 := 0
  local nTot3 := 0
  local nTot4 := 0
  local nTot5 := 0
  local nTot6 := 0
  Local cHTML := ""     
  Local cStatus := ""
  Local cEntrada := ""

  cLinha := "Filial"+Chr(9)
  cLinha += "Número RC"+Chr(9)
  cLinha += "Dt.Emissão"+Chr(9)
  cLinha += "Status"+Chr(9)
  cLinha += "Solicitantel"+Chr(9)
  cLinha += "Moeda"+Chr(9)
  cLinha += "Valor"+Chr(9)
  cLinha += "Número SC"+Chr(9)
  cLinha += "Número PO"+Chr(9)
  cLinha += "Entrada no INDT"+Chr(9)
  cLinha += chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cHTML += '<p><div align="center"><font face="Arial" size=3 color=#0000FF>  <strong>Relação de Requisição de Compras</strong></font></div>'//Relação de Requisição de Compras

  cQuery := " SELECT PA1_FILIAL,PA1_NUM,PA1_EMISSA,PA1_STATUS,PA1_NREQ,PA1_MOEDA,PA1_NUMSC,ISNULL(C7_NUM,'') PEDIDO,SUM(PA4_TOTAL) VALOR
  cQuery += " FROM "+RetSQLName("PA1")+ " PA1"
  cQuery += " INNER JOIN "+RetSQLName("PA4")+ " PA4 ON PA1_FILIAL = PA4_FILIAL AND PA1_NUM = PA4_NUM AND PA1_TIPO = PA4_TIPO AND PA4.D_E_L_E_T_ <> '*'"
  cQuery += " LEFT OUTER JOIN "+RetSQLName("SC7")+ " SC7 ON PA1_FILIAL = C7_FILIAL AND PA1_NUM = C7_NROREQ AND C7_ITEM = '0001' AND SC7.D_E_L_E_T_ <> '*'"
  cQuery += " WHERE PA1.D_E_L_E_T_ <> '*' AND PA4_CCUSTO = '"+cCusto+"' AND PA1_TIPO = '2'"
  cQuery += " AND PA1_EMISSA >= '"+dTos(dDataini)+"' AND PA1_EMISSA <= '"+dTos(dDatafim)+"'
  cQuery += " GROUP BY PA1_FILIAL,PA1_NUM,PA1_EMISSA,PA1_STATUS,PA1_NREQ,PA1_MOEDA,PA1_NUMSC,ISNULL(C7_NUM,'')
  cQuery += " ORDER BY PA1_FILIAL,PA1_EMISSA
  dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"TEMP",.F.,.T.)
  TcSetField("TEMP","PA1_EMISSA","D")
//  RETURN cQuery
  cHTML += '<DIV id=table>
  cHTML += ' <table border="0" width="90%" id="table2">
  cHTML += '<tr><th>Filial</th><th>Número RC</th><th>Dt.Emissão</th><th>Status</th><th>Solicitante</th><th>Moeda</th><th>Valor</th><th>Número SC</th><th>Número PO</th><th>Entrada no INDT</th></tr>'
  SC1->(DbsetOrder(1))                                           
  While !TEMP->(Eof())
    cEntrada := ''
    If TEMP->PA1_STATUS = 'L'
      cStatus := 'Liberado'
      nTot1+= TEMP->VALOR
    ElseIf  TEMP->PA1_STATUS = 'C'
      cStatus := 'Cancelada'
      nTot2+= TEMP->VALOR
    ElseIf  TEMP->PA1_STATUS = 'R'
      cStatus := 'Residuo'
      nTot3+= TEMP->VALOR
    ElseIf  TEMP->PA1_STATUS = 'E'
      cStatus := 'Encerrado'
      nTot4+= TEMP->VALOR
    ElseIf  TEMP->PA1_STATUS = ' '
      cStatus := 'Aberto'
      nTot5+= TEMP->VALOR
    Else
      cStatus := 'Em Aprovação'
      nTot6+= TEMP->VALOR
    EndIf
    If !Empty(TEMP->PEDIDO)
      cQuery := " SELECT D1_DTDIGIT
      cQuery += " FROM "+RetSQLName("SD1")+ " SD1"
      cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' AND D1_PEDIDO = '"+TEMP->PEDIDO+"' AND D1_FILIAL = '"+TEMP->PA1_FILIAL+"'"
      cQuery += " GROUP BY D1_DTDIGIT
      cQuery += " ORDER BY D1_DTDIGIT
      dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"ENT",.F.,.T.)
      TcSetField("ENT","D1_DTDIGIT","D")
      While !ENT->(Eof())
        If Empty(cEntrada)
          cEntrada += dToc(ENT->D1_DTDIGIT)
        Else  
          cEntrada += " , "+dToc(ENT->D1_DTDIGIT)
        EndIf  
        ENT->(DbSkip())
      End
      DbSelectArea("ENT")
      DbCloseArea("ENT")

    EndIf
    cHTML += '<tr>'
    cHTML += '<td>'+TEMP->PA1_FILIAL+'</td>'
    cHtml += '<td><a href="http://'+cServerHttp+'u_w04form5.apl?FILIAL='+TEMP->PA1_FILIAL+'&Req='+TEMP->PA1_NUM+'&Tipo=2&cIdioma='+cIdioma+'"><font color="#0000FF" style="cursor: pointer">'+TEMP->PA1_NUM+'</font></a></td>'    
    cHTML += '<td>'+Dtoc(TEMP->PA1_EMISSA)+'</td>'
    cHTML += '<td>'+cStatus+'</td>'
    cHTML += '<td>'+TEMP->PA1_NREQ+'</td>'
    cHTML += '<td>'+TEMP->PA1_MOEDA+'</td>'
    cHTML += '<td align="right">'+Transform(TEMP->VALOR,"@E 999,999,999.99")+'</td>'
    If !Empty(TEMP->PA1_NUMSC)
      SC1->(DbSeek(TEMP->PA1_FILIAL+TEMP->PA1_NUMSC))
      cHtml += '<td><a href="http://'+cServerHttp+'u_w04fr8_1.apl?&FILIAL='+TEMP->PA1_FILIAL+'&Req='+SC1->C1_NROREQ+'&cIdioma='+cIdioma+'"><font color="#0000FF" style="cursor: pointer">'+TEMP->PA1_NUMSC+'</font></a></td>'
    Else
      cHtml += '<td></td>'
    EndIf  
    cHTML += '<td>'+TEMP->PEDIDO+'</td>'
    cHTML += '<td>'+cEntrada+'</td>'
    cHTML += '</tr>'

    cLinha := TEMP->PA1_FILIAL+Chr(9)
    cLinha += TEMP->PA1_NUM+Chr(9)
    cLinha += Dtoc(TEMP->PA1_EMISSA)+Chr(9)
    cLinha += cStatus+Chr(9)
    cLinha += TEMP->PA1_NREQ+Chr(9)
    cLinha += TEMP->PA1_MOEDA+Chr(9)
    cLinha += Transform(TEMP->VALOR,"@E 999,999,999.99")+Chr(9)
    cLinha += TEMP->PA1_NUMSC+Chr(9)
    cLinha += TEMP->PEDIDO+Chr(9)
    cLinha += cEntrada+Chr(9)
    cLinha += chr(13)+chr(10)
    fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
    TEMP->(DbSkip())
  End
  cLinha := Chr(9)+chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cHTML += '</table>'
  cHTML += '<p>Resumo das RC </p>'
  cHTML += ' <table border="0" width="50%" id="table2">
  cHTML += '<tr><th>Liberados</th><th>'   +Transform(nTot1,"@E 999,999,999.99")+'</th></tr>'
  cHTML += '<tr><th>Canceladas</th><th>'  +Transform(nTot2,"@E 999,999,999.99")+'</th></tr>'
  cHTML += '<tr><th>Residuos</th><th>'    +Transform(nTot3,"@E 999,999,999.99")+'</th></tr>'
  cHTML += '<tr><th>Encerrados</th><th>'  +Transform(nTot4,"@E 999,999,999.99")+'</th></tr>'
  cHTML += '<tr><th>Abertos</th><th>'     +Transform(nTot5,"@E 999,999,999.99")+'</th></tr>'
  cHTML += '<tr><th>Em Aprovação</th><th>'+Transform(nTot6,"@E 999,999,999.99")+'</th></tr>'
  cHTML += '</table>'

  cHTML += '</DIV>


  cLinha := "Resumo"+Chr(9)+chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cLinha := Chr(9)+chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)


  cLinha := "Liberados"+Chr(9)
  cLinha += Transform(nTot1,"@E 999,999,999.99")+Chr(9)
  cLinha += chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cLinha := "Canceladas"+Chr(9)
  cLinha += Transform(nTot2,"@E 999,999,999.99")+Chr(9)
  cLinha += chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cLinha := "Residuos"+Chr(9)
  cLinha += Transform(nTot3,"@E 999,999,999.99")+Chr(9)
  cLinha += chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cLinha := "Encerrados"+Chr(9)
  cLinha += Transform(nTot4,"@E 999,999,999.99")+Chr(9)
  cLinha += chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cLinha := "Abertos"+Chr(9)
  cLinha += Transform(nTot5,"@E 999,999,999.99")+Chr(9)
  cLinha += chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)

  cLinha := "Em Aprovação"+Chr(9)
  cLinha += Transform(nTot6,"@E 999,999,999.99")+Chr(9)
  cLinha += chr(13)+chr(10)
  fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)


  DbSelectArea("TEMP")
  DbCloseArea("TEMP")

Return cHTML

Static Function fVerPC(cCusto)
  Local cPedido 
  Local cQuery         
  Local cHTML := ""
  cHTML += '<p><div align="center"><font face="Arial" size=3 color=#0000FF>  <strong>Relação de Pedido de Compras</strong></font></div>'//Relação de Requisição de Compras
Return cHTML

Static Function fVerNFE(cCusto)
  Local cPedido 
  Local cQuery         
  Local cHTML := ""
  cHTML += '<p><div align="center"><font face="Arial" size=3 color=#0000FF>  <strong>Relação de Notas Fiscais</strong></font></div>'//Relação de Requisição de Compras
Return cHTML


Static Function fVerTit(cCusto)
  Local cPedido 
  Local cQuery         
  Local cHTML := ""
  cHTML += '<p><div align="center"><font face="Arial" size=3 color=#0000FF>  <strong>Relação de Titulos para Pagamento</strong></font></div>'//Relação de Requisição de Compras
Return cHTML



User Function W04FR8_1(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)
  Local cServerHttp      
  Local cHTML := ""
  Local cFil,cNumSC
  Local aIdioma := {}                        
  Private cIdioma                       
  Prepare Environment Empresa "01" Filial "01" Tables "SA2,SB1"
  cServerHttp :=  Getmv("MV_SERHTTP")
  cFil      := Alltrim(__aProcParms[1,2])
  cNum      := Alltrim(__aProcParms[2,2])
  cIdioma   :=  Upper(Alltrim(__aProcParms[3,2]))
  cHTML := '<html>
  cHTML += '<head>
  cHTML += '<meta http-equiv="Content-Language" content="en-us">
  cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
  cHTML += '</head>
  cHTML += '<body>  
  cHTML += u_styleCSS(.T.)
  cHTML += U_W05FORM2(cFil,cNum,'4',cIdioma,"","","","","","","V")
  cHTML += '</body>  
  cHTML += '</html>
Return cHTML            

