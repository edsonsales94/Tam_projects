#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#include "ap5mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณW04FORM3  บ Autor ณ Diego Rafael       บ Data ณ  03/03/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina que mostra a pแgina do Follow Up do pedido digitado บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ INDT                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function W04FORM3(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)

  Local cHTML 	   := ""           
  Local cIdioma    
  Local aIdioma    
  Local aItens     := {}   
  Local aAnexos := {}
  Local cFil
  Local cPedido
  Local cT1 := " Item "
  Local cT2 := " Data " 
  Local cT3 := " Descri็ใo "
  Local cPed := ""

  Local lTrocar    :=.F.
  Local cServerHttp := ""
  Local lAchado  
  Local cGrupo                   

  Prepare Environment Empresa "01" Filial "01" Tables "SC7,SA2,SE4,SZD,SCR,SAL"
  
  cServerHttp := Getmv("MV_SERHTTP")                                      

  qout(__aProcParms[1,2])
  qout(__aProcParms[2,2])
  qout(__aProcParms[3,2])
//  qout("Grupo :"+__aProcParms[4,2])
   
  if __aProcParms[1,2] == "01" .Or. __aProcParms[1,2] == "02" .Or. __aProcParms[1,2] == "03"
    cFil  := __aProcParms[1,2]
    Else 
    cFil    := IIf(!Empty(__aProcParms[1,2]),StrZero(Val(__aProcParms[1,2]),2),"")
  EndIf 
                                                                                    
  cPedido := IIf(Alltrim(__aProcParms[2,2])=="",Space(2),Alltrim(__aProcParms[2,2]))
  qout(Alltrim(__aProcParms[3,2]))
  cIdioma := IIf(Alltrim(__aProcParms[3,2])=="1","P",Space(2))
  qout("Idioma de visu :")  
  qout(cIdioma)
  aIdioma := U_W04IDIOM(cIdioma)                          
  cGrupo := __aProcParms[3,2]
  if Len(AllTrim(cFil)) < 2 .and. !Empty(cFil)
    cFil:= StrZero(val(cFil)+1,2)
  EndIf
  
  If Len(AllTrim(cPedido))<6 .And. Len(AllTrim(cPedido))<>0
     cPed := StrZero(Val(AllTrim(cPedido)),6)
     else 
        cPed := cPedido
  EndiF
  
  qout("cPed"+cPed)
  
    If cFil = "01"
      cDescFil := "Manaus"
    ElseIf cFil = "02"
      cDescFil := "Brasilia"
    ElseIf cFil = "03"
      cDescFil := "Recife"
    Else  
      cDescFil := "Sใo Paulo"
    EndIf
    
    SC7->(DbSelectArea("SC7"))
    SC7->(DbSetOrder(1))
    qout("Filial : "+cFil)  
    qout("Pedido : "+cPedido)
    qout("tamanho de pedido : " + STR(Len(AllTrim(cPedido))))  
   
    If Len(AllTrim(cPedido))<>0
      If SC7->(DbSeek(Alltrim(cFil)+Alltrim(cPed)))
        cCodFor  := SC7->C7_FORNECE           
        cContato := SC7->C7_CONTATO 
        Set Date Format "dd/mm/yyyy"                       //1BRD00187
        cdEmissao := dToS(SC7->C7_EMISSAO)
        lAchado := .T.
        else 
           lAchado := .F.
      EndIf           
      
    EndiF    
    
    SA2->(DbSelectArea("SA2"))
    SA2->(DbSetOrder(1))
    
    If Len(AllTrim(cPedido))<>0
      If SA2->(DbSeek(cFil+cCodFor+SC7->C7_LOJA))
        cNomeFor := SA2->A2_NOME                   
      EndIf
    EndIf              
    
    SE4->(DbSelectArea("SE4"))
    SE4->(DbSetOrder(1))
    
    If Len(AllTrim(cPedido))<>0
      If(SE4->(DbSeek("  "+SC7->C7_COND)))
        cCondPag := SE4->E4_DESCRI
      EndIf         
    EndIf

    lTrocar:=.F.
        
  
    cHTML += '<title>'+aIdioma[1]+'</title>'
    cHTML += '</head>
    cHTML += '<body> 
    cHTML += u_W04PStyle(.F.)
    cHTML += '<meta http-equiv="Content-Language" content="en-us">
    cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">

  cHTML += '<form method="POST" action=""> 
  
/*  cHtml += '<SCRIPT>
  cHTML += 'function fLinck(cId)
  cHTML += '{  
  cHTML += '  var oFrm = document.forms[0];                          
  cHTML += '  var cFilial   = " ";
  cHTML += '  var cPedido   = oFrm.Pedido.value; 
  cHTML += '  window.open("http://'+cServerHttp+'u_w04form4.apl?&Filial="+cFilial+"&Pedido="+cPedido+"&cIdioma="+cId, "JanelaExtra" , "left = 100, height = 500 , width = 1000, status = yes,scrollbars=yes");
  cHTML += '}*/    
  cHTML += '<DIV id=typein>     
  cHTML += '<a href="http://intranet.indt.org"><img src="http://intranet.indt.org/indt.gif" alt="INdT" width="132" height="76" border="0" /></a>  
  cHTML += '<p><div align="center"><font face="Arial" size=6 color=#0000FF>  <strong>'+aIdioma[1]+'</strong></font></div>'//Requisicao de pagamento

   
	  //Inicio Pedido  
  ExecQry(cFil,cPed)
  If  SC7->C7_RESIDUO = 'S'
    cHTML += ' <h4><div align="center"><font color="#0000FF" face="Verdana"><strong>Status: Residuo</strong></font></div></h4>
  EndIf
	 iF TABTMP->(EOF())    
	    cHtml += ' <p align = "center"> <font face=Tahoma Size=20pt><b>'+aIdioma[24]+'</b></font>
	 Else
	  cHtml += ' <br>
	  cHTML += '	<p align="left"><font face="Tahoma">'+aIdioma[2]+'  <b>'+cDescFil+'</b></font>'//<input type="text" name="Filial" size="50"  value="'+cDescFil+'">
	  
	  cHTML += '	<p align="left"><font face="Tahoma">'+aIdioma[3]+'  <b>'+AllTrim(cPed)+'</b></font>
	                                                                                                                                              
      
      //Inicio Data de eentrega prevista
   	  cHTML += '	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
  	  cHTML += '	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
   	  Set Date Format "dd/mm/yyyy"
   	  qout(dToS(TABTMP->ZD_DATENTF))                     
   	  qout("Posicione 1")
      cHTML += '	<font face="Tahoma">'+aIdioma[9]+' <b>'+AllTrim(toStr(posicione("SC7",1, cFil+cPed,"C7_DATPRF")))+'</b> </font>
      
     qout("Teste 1")  
	  cHTML += '	<p align="left"><font face="Tahoma">'+aIdioma[10]+'  <b>'+AllTrim(TABTMP->ZD_CONHEC)+'</b></font>
	  qout("Teste 1")
   	  qout("Posicione 2")	  
 	  cHTML += '	<p align="left"><font face="Tahoma">'+aIdioma[27]+'  <b>'+AllTrim(Posicione("SY1",1,xFilial("SY1")+TABTMP->ZD_COMP,"Y1_NOME"))+'</b></font>
  	  cHTML += '	<p align="left"><font face="Tahoma">'+aIdioma[25]+'  <b>'+AllTrim(toStr(TABTMP->ZD_DATAEF))+'</b></font>
   	  cHTML += '	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'  
   	  qout("Teste 2")
 	  cHTML += '	<font face="Tahoma">'+aIdioma[11]+'  <b>'+AllTrim(toStr(TABTMP->ZD_DATEMB))+'</b></font>
 	  

      cHTML += '	<p align="left"><font face="Tahoma">'+aIdioma[12]+' <b>'+AllTrim(toStr(TABTMP->ZD_DATCHE))+'</b> </font>     
      
 	  cHTML += '	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
      cHTML += '	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      cHTML += '	<font face="Tahoma">'+aIdioma[13]+'  <b>'+AllTrim(toStr(TABTMP->ZD_DATREC))+'</b></font>
 	  
 	  cHTML += '	<p align="left"><font face="Tahoma">'+aIdioma[26]+' <b>'+AllTrim(toStr(TABTMP->ZD_DATAEC))+'</b> </font>  	  
 	  cHTML += '	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
      cHTML += '	<font face="Tahoma">'+AllTrim(aIdioma[14])+' <b>'+AllTrim(TABTMP->ZD_TEMDIA)+'</b> </font>
 	  
      cHTML += '	<p align="left"><font face="Tahoma">'+aIdioma[15]+'  <b>'+AllTrim(TABTMP->ZD_INVOICE)+'</b></font>
      cHTML += '	<p align="left"><font face="Tahoma">'+aIdioma[16]+'  <b>'+AllTrim(TABTMP->ZD_DI)+'</b></font>     
      
      cHTML += '	<p align="left"><font face="Tahoma">'+aIdioma[17]+'  <b>'+AllTrim(TABTMP->ZD_STATUS)+'</b></font>
  	  cHTML += '	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  	  cHTML += '    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
      cHTML += '	<font face="Tahoma">'+aIdioma[18]+' <b>'+AllTrim(TABTMP->ZD_STAENT)+'</b> </font> 
      cHTML += '	<p align="left"><font face="Tahoma">'+aIdioma[33]+' <b>'+AllTrim(toStr(TABTMP->ZD_DATENV))+'</b> </font> 
/*      if cIdioma = "P"             
         cHTML += ' <p align=Left> <a onclick ="fLinck(1)"><font color="#0000FF" style="cursor: pointer">'+aIdioma[28]+'</font></a>
         else  
            cHTML += ' <p align=Left> <a onclick ="fLinck(2)"><font color="#0000FF" style="cursor: pointer">'+aIdioma[28]+'</font></a>
      EndIf
*/      
      cHtml += '<p><br>
      cHTML += ' <table border="2" width="80%" id="table3">       
      cHTML += MontaTab("<b>&nbsp"+aIdioma[19]+"</b>","<b>&nbsp"+aIdioma[20]+"</b>","<b>&nbsp"+aIdioma[21]+"</b>")
      While !TabTmp->(EOF())
//        Set Date Format "dd/mm/yyyy"                                    
   	  qout("Posicione 3")      
   	  cDesc1 := Posicione("SZD",1,cFil+cPed+TabTmp->ZD_Item,"ZD_DESC")
        cHtml += MontaTab(TabTmp->ZD_ITEM,toStr(TABTMP->ZD_DATA),Iif(Len(AllTrim(cDesc1))=0,"<font color=#e8eae8>n</font>",cDesc1))
        TAbTmp->(DbSkip())
      End
   EndIf
	  cHTML += '    </table>  
	  


//     ExQry(cFil,cPedido)
/*    iF TABTMP->(EOF())    
	    cHtml += ' <p align = "center"> <font face=Tahoma Size=20pt><b>'+aIdioma[24]+'</b></font>
	 Else*/
//	  cHtml += ' <br>                                         
     cHtml += '<p><br>
     cHTML += '<p><div align="center"><font face="Arial" size=4 color=#0000FF>  <strong>'+aIdioma[28]+'</strong></font></div>
     cHtml += '<p><br>
     cHTML += ' <table border="2" width="80%" id="table3"> 
     cHtml += MontTab("<b>"+aIdioma[29]+"</b>","<b>"+aIdioma[30]+"</b>","<b>"+aIdioma[31]+"</b>","<b>"+aIdioma[32]+"</b>","<b>"+aIdioma[35]+"</b>","<b>"+aIdioma[34]+"</b>")    
     
     SCR->(DbSetOrder(1))
     SCR->(DbSeek(cFil+"PC"+cPed))
     
     While SCR->(CR_FILIAL+CR_TIPO+CR_NUM)=cFil+"PC"+cPed
     PswOrder(1)                             
   	  qout("Posicione 4")
   	  qout(SCR->CR_USER)
   	  cText1 := UserName(SCR->CR_USER)
   	  qout(cText1) 
   	  qout("Aprovador :" +SCR->CR_APROV)
   	  cText2 := POSICIONE("SAK",1,"  "+SCR->CR_APROV,"AK_NOME")
   	  qout("Aprovador : "+cText2)         

     cHtml += MontTab(SCR->CR_NIVEL,Iif(Len(AllTrim(cText1))=0,"<font color=#e8eae8>n</font>",cText1),nome(SCR->CR_STATUS),cText2,ToStr(SCR->CR_DATALIB),Iif(Len(AllTrim(SCR->CR_OBS))=0,"<font color=#e8eae8>n</font>",SCR->CR_OBS))   
     SCR->(DbSkip())
    End

 /*cHtml += ' </Body>	  
 cHtml += ' </html>	  */
    
Return cHtml                                      

Static Function MontaTab(cText1,cText2,cText3)
  Local cHTML := ""
  cHTML += '<tr>'
  cHTML += ' 			<td width="15%" >'+cText1+'</td>
  cHTML += ' 			<td width="20%" >'+cText2+'</td>
  cHTML += ' 			<td width="75%" >'+cText3+'</td>
  cHTML += '</tr>'
Return cHTML       



Static Function ExecQry(cFil,cPedido)
 Local cQry        
            
 cQry := " Select * From "+RetSqlName("SZD") + " As SZD "
 cQry += " Where D_E_L_E_T_ <> '*' "
 cQry += " And SZD.ZD_PEDIDO = " + cPedido
 cQry += " And SZD.ZD_FILIAL = " + cFil
 cQry += " Order By ZD_ITEM"
           
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TabTmp", .T., .F. )
 TcSetField("TabTmp","ZD_DATA","D")
 TcSetField("TabTmp","ZD_DATREC","D")
 TcSetField("TabTmp","ZD_DATEMB","D")
 TcSetField("TabTmp","ZD_DATENTF","D")
 TcSetField("TabTmp","ZD_DATCHE","D")
 TcSetField("TabTmp","ZD_DATAEF","D")
 TcSetField("TabTmp","ZD_DATAEC","D") 
 TcSetField("TabTmp","ZD_DATENV","D")
Return .T. 

Static Function ToStr(cDat)
    Local cData := dToS(cDat)
    qout(SubStr(cData,7,2)+"/"+SubStr(cData,5,2)+"/"+SubStr(cData,1,4))
Return SubStr(cData,7,2)+"/"+SubStr(cData,5,2)+"/"+SubStr(cData,1,4)               

Static Function MontTab(cText1,cText2,cText3,cText4,cText5,cText6)
  Local cHTML := ""
  cHTML += '<tr>'
  qout("text1")
  cHTML += ' 			<td width="08%" >'+cText1+'</td>
    qout("text2")
  cHTML += ' 			<td width="15%" >'+cText2+'</td>
    qout("text3")
  cHTML += ' 			<td width="20%" >'+cText3+'</td>
    qout("text4")
  cHTML += ' 			<td width="30%" >'+cText4+'</td>
    qout("text5")
  cHTML += ' 			<td width="20%" >'+cText5+'</td>
    qout("text6 : ")
    qout(cText6)
  cHTML += ' 			<td width="30%" >'+cText6+'</td>
  cHTML += '</tr>'
Return cHTML       



Static Function ExQry(cFil,cPedido)
 Local cQry        
            
 cQry := " Select * From "+RetSqlName("SCR") + " SCR "
 cQry += " Where D_E_L_E_T_ <> '*' "
 cQry += " And SCR.CR_NUM = '" + cPedido+"'"
 cQry += " And SCR.CR_FILIAL = '" + cFil+"'"
 cQry += " Order By CR_DATLIB"
 
 
           
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TbTmp", .T., .F. )
 TcSetField("TabTmp","CR_DATLIB","D")

Return .T.                           

Static Function Qry(cFil,cAprovador)
      
 cQry := " Select * From "+RetSqlName("SAL") + " As SAL "
 cQry += " Where D_E_L_E_T_ <> '*' "
 cQry += " And SAL.AL_APROV = '" + cAprovador+"'"
 cQry += " And SAL.AL_FILIAL = '" + cFil +"'"
           
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "Tap", .T., .F. )

return Tap->AL_NOME

static function nome(cPa)                                                                                
if cPa = "01" .Or. cPa="1"
   return "Nivel Bloqueado"
endif
if cPa = "02" .Or. cPa="2"
   return  "Aguardando Libera็ใo"
endif
if cPa = "03" .Or. cPa="3"
   return "Pedido Aprovado"
endif
if cPa = "04" .Or. cPa="4"
   return "Pedido Bloqueado"
endif
if cPa = "05" .Or. cPa="5"
  return "Nivel Liberado"
endif

return cNom  

Static Function UserName(cCodUsr)
   Local aUser, cUserAnt := " "

   PswOrder(1)               // (1) Codigo , (2) Nome
   If PswSeek(Alltrim(cCodUsr)) // Pesquisa usuแrio
   aUser := PswRet(1)        // Retorna Matriz com detalhes, acessos do Usuแrio
   cUserAnt := aUser[1][2]   // Retorna codigo do usuแrio [1] ou o Nome [2]
   endif
                                                                                                                                                                                  
Return(cUserAnt)
