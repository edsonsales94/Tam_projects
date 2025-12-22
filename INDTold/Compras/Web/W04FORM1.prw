
#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#include "ap5mail.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ W04FORM1   ¦ Autor ¦ Diego Rafael         ¦ Data ¦ 12/03/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina do Frame principal, onde são chamadas chamados todos   ¦¦¦
¦¦¦  (Cont.)  ¦ os demais frame e visualiza os dados do pedido           	  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function W04FORM1(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)
  
  Local cHTML,cIdioma, cVenc, cPedido,cCondPag,cContato,cDemissao,NomeFor,cCodFor
  Local cServerHttp
  Local aIdioma := U_W04IDIOM(cIdioma)
  Local cAgencia,cContCor,cDescri,cDetalhe,cJustif,cTipo       
  Local cPed := ""

  Prepare Environment Empresa "01" Filial "01" Tables "SC7,SA2,SE4,SZD"
  
  cServerHttp := Getmv("MV_SERHTTP")

  cFil    := IIf(!Empty(__aProcParms[1,2]),StrZero(Val(__aProcParms[1,2]),2),"01")
  cPedido := IIf(Alltrim(__aProcParms[2,2])=="",Space(2),Alltrim(__aProcParms[2,2]))

  cIdioma := IIf(Alltrim(__aProcParms[3,2])=="",Space(2),Alltrim(__aProcParms[3,2]))
  cCodFor := IIf(Alltrim(__aProcParms[4,2])=="",Space(2),Alltrim(__aProcParms[4,2]))    
  cNomeFor:= IIf(Alltrim(__aProcParms[5,2])=="",Space(2),Alltrim(__aProcParms[5,2]))   
  cData   := SubStr(Dtos(Date()),7,2)+"/"+SubStr(Dtos(Date()),5,2)+"/"+SubStr(Dtos(Date()),1,4) 
  cDemissao   := IIf (!Empty(__aProcParms[6,2]),__aProcParms[6,2],"") 
  cContato    := IIf(Alltrim(__aProcParms[7,2])=="",Space(2),Alltrim(__aProcParms[7,2]))
  cCondPag    := IIf(Alltrim(__aProcParms[8,2])=="",Space(2),Alltrim(__aProcParms[8,2]))
  cTipo     := Alltrim(__aProcParms[9,2])
  If Len(AllTrim(cPedido))<6 .And. Len(AllTrim(cPedido))<>0
     cPed := StrZero(Val(AllTrim(cPedido)),6)
     else 
        cPed := cPedido
  EndiF
  
  
  qout("cPed "+cPed)
  QOUT("Show")
  QOUT(cDemissao)
  cHTML := '<html>
  cHTML += '<head>
  cHTML += u_W04PStyle(.F.)
  cHTML += '<meta http-equiv="Content-Language" content="en-us">
  cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
  cHTML += '<SCRIPT> 
         

  qout("Tamanho de html")
  qout(Len(cHtml))
  cHTML += 'function fLink(cId)
  cHTML += '{  
  cHTML += '  var oFrm = document.forms[0];                          
  cHTML += '  var cFilial   = oFrm.FILIAL.selectedIndex+1;
  cHTML += '  var cPedido   = oFrm.Pedido.value; 
  cHTML += '  window.open("http://'+cServerHttp+'u_w04form3.apl?&Filial="+cFilial+"&Pedido="+cPedido+"&cIdioma="+cId, "JanelaExtra" , "left = 100, top = 000, height = 900 , width = 1000, status = yes,scrollbars=yes,resizable=yes");
  cHTML += '}  
  
  cHTML += 'function fConsultaCC(cId)
  cHTML += '{  
  cHTML += '  var oFrm = document.forms[0];                          
  cHTML += '  var cFilial   = oFrm.FILIAL.selectedIndex+1;
  cHTML += '  var cPedido   = oFrm.Pedido.value; 
  cHTML += '  window.open("http://'+cServerHttp+'u_w04form9.apl?&Pesq&Campo&P1="+cFilial+"&P2='+cIdioma+'", "JanelaExtra" , "left = 100, height = 400 , width = 700, status = yes"); 
  cHTML += '}  



  cHTML += 'function fLinck(cId,cGrupo)
  cHTML += '{  
  cHTML += '  var oFrm = document.forms[0];                          
  cHTML += '  var cFilial   = " ";
  cHTML += '  var cPedido   = oFrm.Pedido.value; 
  cHTML += '  window.open("http://'+cServerHttp+'u_w04form4.apl?&Filial="+cFilial+"&Pedido="+cPedido+"&cIdioma="+cId, "JanelaExtra" , "left = 100, height = 500 , width = 500, status = yes,scrollbars=yes,resizable=yes");
  cHTML += '}

  cHTML += 'function fVerPed()
  cHTML += '{     
  cHTML += '  var oFrm = document.forms[0];                          
  cHTML += '  var cFilial   = oFrm.FILIAL.selectedIndex+1;
  cHTML += '  var cPedido   = oFrm.Pedido.value;        
  cHTML += '  var nTipo     = oFrm.TIPO.selectedIndex;  
        
  cHTML += '  if (nTipo == 0)
  cHTML += '    oFrm.action = "http://'+cServerHttp+'u_w04form1.apl?FILIAL="+cFilial+"&Pedido="+cPedido+"&cIdioma='+cIdioma+'&NomeFor=&CodFor=&Demissao=&Contato=&CondPag"+"&Tipo='+cTipo+'";'  

  cHTML += '  if (nTipo == 1)
  cHTML += '    oFrm.action = "http://'+cServerHttp+'u_w04form5.apl?FILIAL="+cFilial+"&Req="+cPedido+"&Tipo=2&cIdioma='+cIdioma+'";'  

  cHTML += '  if (nTipo == 2)
  cHTML += '    oFrm.action = "http://'+cServerHttp+'u_w04form6.apl?FILIAL="+cFilial+"&Req="+cPedido+"&Tipo=1&cIdioma='+cIdioma+'";'  
  

  cHTML += '  if (nTipo == 3)
  cHTML += '    oFrm.action = "http://'+cServerHttp+'u_w04form8.apl?FILIAL="+cFilial+"&Req="+cPedido+"&cIdioma='+cIdioma+'&Req2";'  

  cHTML += '  if (nTipo == 4)
  cHTML += '    oFrm.action = "http://'+cServerHttp+'u_w04formA.apl?Req="+cPedido+"&cIdioma='+cIdioma+'&dataIni="+oFrm.DATAINI.value+"&dataFim="+oFrm.DATAFIM.value;'  

  cHTML += '  oFrm.submit();

  cHTML += '}       

  cHTML += 'function fFormatData(NroDat)
  cHTML += '{
  cHTML += '  var oFrm = document.forms[0];
  cHTML += '  if (NroDat == 1)
  cHTML += '    if((oFrm.DATAINI.value.length == 2) || (oFrm.DATAINI.value.length == 5))
  cHTML += '      oFrm.DATAINI.value  = oFrm.DATAINI.value+"/";
  cHTML += '  if (NroDat == 2)
  cHTML += '    if((oFrm.DATAFIM.value.length == 2) || (oFrm.DATAFIM.value.length == 5))
  cHTML += '      oFrm.DATAFIM.value  = oFrm.DATAFIM.value+"/"
  cHTML += '}            
  
  cHTML += '</SCRIPT>     
  //chamando o formulário principal 
  cHTML += U_W04FORM2(cFil,cPedido,cContato,cDemissao,cNomeFor,cCodFor,cIdioma,cCondPag,cTipo) 
  cHTML += '</body>

  cHTML += '</html>                                       
Return cHTML
