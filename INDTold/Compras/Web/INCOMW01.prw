#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#include "ap5mail.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INWEBF04   ¦ Autor ¦ Diego Rafael         ¦ Data ¦ 10/03/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Programa de inicialização do frame principal				  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INCOMW01(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)
	Local cHTML,cIdioma    
	Local cServerHttp  
	Local aIdioma 
	Local lFrame
	  
	Local cFil,cNum,cTipo

	Prepare Environment Empresa "01" Filial "01" // Tables "SC7,SA2,SE4,SZD" 
	cServerHttp := Getmv("MV_SERHTTP")         
	cIdioma := IIF(Alltrim(__aProcParms[1,2])==NIL,"P",Upper(Alltrim(__aProcParms[1,2])))
	lFrame  := &(__aProcParms[2,2])
	aIdioma := U_INCOMWID(cIdioma)  
	If lFrame   
		cHTML := '<html>
		cHTML += '<head>
		cHTML += '<meta http-equiv="Content-Language" content="en-us">
		cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
		cHTML += '<title>Follow-up Compras</title>
		cHTML += '</head>  
		
		cHTML += '<FRAMESET ROWS="100%" FRAMEBORDER="0" FRAMESPACING="2">
		cHTML += '  <FRAME SRC="http://'+cServerHttp+'u_incomw01.apl?&cIdioma='+cIdioma+'&lFrame =.f.&filial=&tipo=&num" NAME="JanelaPrincipal" NORESIZE SCROLLING="YES">
		
		
	Else
		
		cFil  := IIf(!Empty(__aProcParms[3,2]),StrZero(Val(__aProcParms[3,2]),2),"01")
		cTipo := IIf(Alltrim(__aProcParms[4,2])=="",Space(2),Alltrim(__aProcParms[4,2]))
		cNum  := IIf(Alltrim(__aProcParms[5,2])=="",Space(2),Alltrim(__aProcParms[5,2])) 
		If Len(__aProcParms) > 5
			cDini  := IIf(Alltrim(__aProcParms[6,2])=="",Space(2),Alltrim(__aProcParms[6,2]))
			cDfim  := IIf(Alltrim(__aProcParms[7,2])=="",Space(2),Alltrim(__aProcParms[7,2]))
		Else
			cDini  := ""//IIf(Alltrim(__aProcParms[6,2])=="",Space(2),Alltrim(__aProcParms[6,2]))
			cDfim  := ""//IIf(Alltrim(__aProcParms[7,2])=="",Space(2),Alltrim(__aProcParms[7,2]))
		EndIf

		
		  
		cHTML := '<html>
		cHTML += '<head>
		cHTML += u_INCOMWST(.F.)
		cHTML += '<meta http-equiv="Content-Language" content="en-us">
		cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
		cHTML += '<SCRIPT> 
		         
		
		
		cHTML += 'function fValTipo()
		cHTML += '{     
		cHTML += '  var oFrm = document.forms[0];                          
		cHTML += '  var cFilial   = oFrm.FILIAL.selectedIndex+1;
		cHTML += '  var cNum   = oFrm.Pedido.value;        
		cHTML += '  var nTipo     = oFrm.TIPO.selectedIndex;  
		        
		cHTML += '    oFrm.action = "http://'+cServerHttp+'u_incomw01.apl?&cIdioma='+cIdioma+'&lFrame =.f.&filial="+cFilial+"&tipo="+nTipo+"&num=";'  
		
		cHTML += '  oFrm.submit();
		
		cHTML += '}       

		cHTML += 'function fVerPed()
		cHTML += '{     
		cHTML += '  var oFrm = document.forms[0];                          
		cHTML += '  var cFilial   = oFrm.FILIAL.selectedIndex+1;
		cHTML += '  var cNum   = oFrm.Pedido.value;        
		cHTML += '  var nTipo     = oFrm.TIPO.selectedIndex;  
		        
		
		If cTipo == "3"
			cHTML += '  var dini   = oFrm.dini.value;        
			cHTML += '  var dfim   = oFrm.dfim.value;        
			cHTML += '    oFrm.action = "http://'+cServerHttp+'u_incomw01.apl?&cIdioma='+cIdioma+'&lFrame =.f.&filial="+cFilial+"&tipo="+nTipo+"&num="+cNum+"&dini="+dini+"&dfim="+dfim;'  
		Else			
			cHTML += '    oFrm.action = "http://'+cServerHttp+'u_incomw01.apl?&cIdioma='+cIdioma+'&lFrame =.f.&filial="+cFilial+"&tipo="+nTipo+"&num="+cNum;'  
		EndIf			
		
		cHTML += '  oFrm.submit();
		
		cHTML += '}       
		             
		cHTML += 'function fFormatData(NroDat)
		cHTML += '{
		cHTML += '  var oFrm = document.forms[0];
		cHTML += '  if (NroDat == 1)
		cHTML += '    if((oFrm.dini.value.length == 2) || (oFrm.dini.value.length == 5))
		cHTML += '      oFrm.dini.value  = oFrm.dini.value+"/";
		cHTML += '  if (NroDat == 2)
		cHTML += '    if((oFrm.dfim.value.length == 2) || (oFrm.dfim.value.length == 5))
		cHTML += '      oFrm.dfim.value  = oFrm.dfim.value+"/"
		cHTML += '}            
				  

		cHTML += 'function fConsultaCC(cId)
		cHTML += '{  
		cHTML += '  var oFrm = document.forms[0];                          
		cHTML += '  var cFilial   = oFrm.FILIAL.selectedIndex+1;
		cHTML += '  var cPedido   = oFrm.Pedido.value; 
		cHTML += '  window.open("http://'+cServerHttp+'u_INCOMCUS.apl?&Pesq&Campo&P1="+cFilial+"&P2='+cIdioma+'", "JanelaExtra" , "left = 100, height = 400 , width = 700, status = yes"); 
		cHTML += '}  
		
		cHTML += '</SCRIPT>     
		cHTML += '<BODY>     
		cHTML += '<form method="POST" action="">

		cHTML += '<p><a href="http://intranet.indt.org"><img src="http://intranet.indt.org/indt.gif" alt="INdT" width="132" height="76" border="0" /></a></p>  
		cHTML += '<p><div align="center"><font face="Arial" size=6 color=#0000FF>  <strong>Follow Up</strong></font></div></p>'//Requisicao de Compra
		cHTML += '	<hr>		

		cHTML += '<p><div><font face="Arial" size=4 color=#0000FF>  <strong>Parâmetros</strong></font></div></p>'//Requisicao de Compra
		cHTML += '	<p align="left"><font face="Tahoma">*'+aIdioma[2]+'<b> </b>'//Filial 
		cHTML += '	<select size="1" name="FILIAL" > 
		cHTML += '	<option'+IIf(Empty(cFil) .Or. cFil = "01",' selected','')+'>Manaus</option>
		cHTML += '	<option'+IIf(cFil = "02",' selected','')+'>Brasilia</option>
		cHTML += '	<option'+IIf(cFil = "03",' selected','')+'>Recife</option>
		cHTML += '	<option'+IIf(cFil = "04",' selected','')+'>São Paulo</option>
		cHTML += '	</select>	  
		
		cHTML += '	<p align="left" ><font face="Tahoma">*'+aIdioma[36]+'<b> </b>'//Tipo 
		cHTML += '	<select size="1" name="TIPO" onchange="fValTipo()"> 
		cHTML += '	<option'+IIf(cTipo = "0",' selected','')+'>Solicitação de Compra</option>
		cHTML += '	<option'+IIf(cTipo = "1",' selected','')+'>Pedido de Compra</option>
		cHTML += '	<option'+IIf(cTipo = "2",' selected','')+'>Requisicao de Viagem</option>
		cHTML += '	<option'+IIf(cTipo = "3",' selected','')+'>Centro de Custo</option>
		cHTML += '	</select>	  
		//Inicio Pedido
		cHTML += '	<p align="left"><font face="Tahoma">Numero </font><input type="text" name="Pedido" size="30" onchange ="fVerPed" value="'+cNum+'">
		//Fim Pedido                                                                                                                            
		If cTipo == "3"
			cHTML += '	<a onclick="fConsultaCC()"><font color="#0000FF" style="cursor: pointer"> Consulta Centro de Custo</font></a></p>
			cHTML += '	<p align="left">'+aIdioma[39] + '</p> '  
			///Data inicial       
			cHTML += '	<p align="left">*'+aIdioma[40] + '	<input type="text" name="dini" size="12" onkeypress="fFormatData(1)"  maxlength="10" value="'+cDini+'">&nbsp;
			///Data Final
			cHTML += '	*'+aIdioma[41]+' </font> ' + '	<input type="text" name="dfim" size="12" onkeypress="fFormatData(2)"  maxlength="10" value="'+cDfim+'"></p>
		EndIf			
		cHtml += '    <input type = "button" name = "pesk" value="'+aIdioma[37]+'" onclick="fVerPed()">
		cHTML += '    </DIV>   
		cHTML += '	<hr>		 
		If !Empty(cNum)
			If cTipo == "0"
				cHTML += U_INCOMW02(cFil,cNum) //UsrRetMail("000055")//
			ElseIf cTipo == "1"
				cHTML += U_INCOMW03(cFil,cNum)
			ElseIf cTipo == "2"
				cHTML += U_INVIAW01(cFil,cNum)
			ElseIf cTipo == "3"
				cHTML += U_INCOMW04(cFil,cNum,cDini,cDfim)//U_INVIAW04(cFil,cNum,cDini,cDfim)
			Else
				cHTML += ''
			EndIf
		EndIf
		cHTML += '</form>
		cHTML += '</body>
		
		cHTML += '</html>                                       
//		return "teste 5"
	
	EndIf
Return cHTML   

