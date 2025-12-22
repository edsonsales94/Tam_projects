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

User Function W04FORM4(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)

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

  Local lTrocar    :=.F.
  Local cServerHttp := ""
  Local lAchado  
  Local aSit := { "Nivel Bloqueado","Aguardando Libera็ใo","Pedido Aprovado","Pedido Bloqueado","Nivel Liberado"}
  
  Prepare Environment Empresa "01" Filial "01" Tables "SC7,SA2,SE4,SZD"
  
  cServerHttp := Getmv("MV_SERHTTP")                                      

  qout(__aProcParms[1,2])
  qout(__aProcParms[2,2])
  qout(__aProcParms[3,2])
   
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
  
  

    lTrocar:=.F.
        
  
    cHTML += '<title>'+aIdioma[1]+'</title>'//Requisicao de Pagamentos
    cHTML += '</head>
    cHTML += '<body> 
    cHTML += u_W04PStyle(.F.)
    cHTML += '<meta http-equiv="Content-Language" content="en-us">
    cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    cHTML += '<form method="POST" action="">
  

  cHTML += '<DIV id=typein>     
  cHTML += '<a href="http://intranet.indt.org"><img src="http://intranet.indt.org/indt.gif" alt="INdT" width="132" height="76" border="0" /></a>  
  cHTML += '<p><div align="center"><font face="Arial" size=6 color=#0000FF>  <strong>'+aIdioma[1]+'</strong></font></div>'//Requisicao de pagamento

	  //Inicio Pedido  
  ExecQry(cFil,cPedido)
/*    iF TABTMP->(EOF())    
	    cHtml += ' <p align = "center"> <font face=Tahoma Size=20pt><b>'+aIdioma[24]+'</b></font>
	 Else*/
//	  cHtml += ' <br>
     cHtml += ' <p align = "center"> <font face=Tahoma Size=20pt><b>'+aIdioma[28]+'</b></font>
     cHtml += '<p><br>
     cHTML += ' <table border="2" width="80%" id="table3"> 
     cHtml += MontaTab(aIdioma[29],aIdioma[30],aIdioma[31],aIdioma[32],aIdioma[33],aIdioma[34])
     While !TabTmp->(EOF())
     PswOrder(2)
     cHtml += MontaTab(TabTmp->CR_NIVEL,PswSeek(Alltrim(TabTmp->CR_USER)),aSit[TabTmp->CR_STATUS],Qry("  ",TabTmp->CR_APROV),TabTmp->CR_OBS)   
     TabTmp->(DbSkip())
    End  
      //Inicio Data de eentrega prevista
   	  
   	  
      
      
     qout("Teste 1")  	  
     qout("Teste 1")
	  
     /* cHtml += ' <p align = "center"> <font face=Tahoma Size=20pt><b>'+aIdioma[27]+'</b></font> 	  cHtml
      cHtml += '<p><br>
      cHTML += ' <table border="2" width="80%" id="table3">       
      cHTML += MontaTab("<b>&nbsp"+aIdioma[19]+"</b>","<b>&nbsp"+aIdioma[20]+"</b>","<b>&nbsp"+aIdioma[21]+"</b>")
      While !TabTmp->(EOF())
//        Set Date Format "dd/mm/yyyy"
        cHtml += MontaTab(TabTmp->ZD_ITEM,toStr(TABTMP->ZD_DATA),Posicione("SZD",1,cFil+cPedido+TabTmp->ZD_Item,"ZD_DESC"))
        TAbTmp->(DbSkip())
      End */
//   EndIf
	  cHTML += '    </DIV>    
cHtml += '</Script>  
cHTML += '</body>
    
Return cHtml                                      

Static Function MontaTab(cText1,cText2,cText3,cText4,cText5,cText6)
  Local cHTML := ""
  cHTML += '<tr>'
  cHTML += ' 			<td width="05%" >'+cText1+'</td>
  cHTML += ' 			<td width="15%" >'+cText2+'</td>
  cHTML += ' 			<td width="20%" >'+cText3+'</td>
  cHTML += ' 			<td width="30%" >'+cText4+'</td>
  cHTML += ' 			<td width="20%" >'+cText5+'</td>
  cHTML += ' 			<td width="30%" >'+cText6+'</td>
  cHTML += '</tr>'
Return cHTML       



Static Function ExecQry(cFil,cPedido)
 Local cQry        
            
 cQry := " Select * From "+RetSqlName("SCR") + " As SCR "
 cQry += " Where D_E_L_E_T_ <> '*' "
 cQry += " And SCR.CR_PEDIDO = " + cPedido
 cQry += " And SCR.CR_FILIAL = " + cFil
 cQry += " Order By CR_DATLIB"
 
 
           
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TabTmp", .T., .F. )
 TcSetField("TabTmp","CR_DATLIB","D")

Return .T.                           

Static Function Qry(cFil,cAprovador)
      
 cQry := " Select * From "+RetSqlName("SAL") + " As SAL "
 cQry += " Where D_E_L_E_T_ <> '*' "
 cQry += " And SAL.AL_APROV = " + cAprovador
 cQry += " And SAL.AL_FILIAL = " + cFil 
           
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "Tmp", .T., .F. )

return Tmp->AL_NOME

Static Function ToStr(cDat)
    Local cData := dToS(cDat)
    qout(SubStr(cData,7,2)+"/"+SubStr(cData,5,2)+"/"+SubStr(cData,1,4))
Return SubStr(cData,7,2)+"/"+SubStr(cData,5,2)+"/"+SubStr(cData,1,4)
