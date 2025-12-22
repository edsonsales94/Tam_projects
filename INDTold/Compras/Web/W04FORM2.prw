#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#include "ap5mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณW04FORM2  บ Autor ณ Diego Rafael       บ Data ณ  10/03/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina que mostra a pแgina principal                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ INDT                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function W04FORM2(cFil,cPedido,cContato,cDemissao,cNomeFor,cCodFor,cIdioma,cCondPag,cTipo)

  Local cHTML 	   := ""             
  Local aIdioma    := U_W04IDIOM(cIdioma)                          
  Local aItens     := {}   
  Local aAnexos := {}
  
  Local cDescMoeda :=""
  Local cDescFil   :=""
  Local lTrocar    :=.F.
  Local cServerHttp := ""
  Local cPed := ""
  Local lAchado 
  pUBLIC CgRUPO
  
  Prepare Environment Empresa "01" Filial "01" Tables "SC7,SA2,SE4,SZD"
  
  cServerHttp := Getmv("MV_SERHTTP")

   
  if Len(AllTrim(cFil)) < 2 .and. !Empty(cFil)
    cFil:= StrZero(val(cFil)+1,2)
  EndIf
  

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
    
  If Len(AllTrim(cPedido))<6 .And. Len(AllTrim(cPedido))<>0
     cPed := StrZero(Val(AllTrim(cPedido)),6)
     else 
        cPed := cPedido
  EndiF
    If Len(AllTrim(cPedido))<>0
      If SC7->(DbSeek(Alltrim(cFil)+Alltrim(cPed)))
        cCodFor  := SC7->C7_FORNECE           
        cContato := SC7->C7_CONTATO 
        Set Date Format "dd/mm/yyyy"      
        cdEmissao := dToS(SC7->C7_EMISSAO)
        cGrupo := SC7->C7_APROV
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
        
  
    cHTML += '<title>'+aIdioma[1]+'</title>'//Follow Up
    cHTML += '</head>
    cHTML += '<body>
    cHTML += '<form method="POST" action="">
  
  cHtml += '</Script>
  cHTML += '<DIV id=typein>     
  cHTML += '<a href="http://intranet.indt.org"><img src="http://intranet.indt.org/indt.gif" alt="INdT" width="132" height="76" border="0" /></a>  
  cHTML += '<p><div align="center"><font face="Arial" size=6 color=#0000FF>  <strong>'+aIdioma[1]+'</strong></font></div>'//Requisicao de pagamento
  if SubStr(cdEmissao,3,1) <> "/"
    cdEmissao := SubStr(cdEmissao,7,2)+"/"+SubStr(cdEmissao,5,2)+"/"+SubStr(cdEmissao,1,4)
  EndIf

      //inicio filial
	  cHTML += '	<p align="left"><font face="Tahoma">*'+aIdioma[2]+'<b> </b>'//Filial 
	  cHTML += '	<select size="1" name="FILIAL" > 
	  cHTML += '	<option'+IIf(Empty(cFil) .Or. cFil = "01",' selected','')+'>Manaus</option>
	  cHTML += '	<option'+IIf(cFil = "02",' selected','')+'>Brasilia</option>
	  cHTML += '	<option'+IIf(cFil = "03",' selected','')+'>Recife</option>
	  cHTML += '	<option'+IIf(cFil = "04",' selected','')+'>Sใo Paulo</option>
	  cHTML += '	</select>	  

      //Tipo d
	  cHTML += '	<p align="left"><font face="Tahoma">*'+aIdioma[36]+'<b> </b>'//Tipo 
	  cHTML += '	<select size="1" name="TIPO" > 
	  cHTML += '	<option'+IIf(cTipo = "0",' selected','')+'>Pedido de Compra</option>
	  cHTML += '	<option'+IIf(cTipo = "1",' selected','')+'>Requisi็ao Web de Compra</option>
	  cHTML += '	<option'+IIf(cTipo = "2",' selected','')+'>Requisi็ao Web de Viagem</option>
	  cHTML += '	<option'+IIf(cTipo = "3",' selected','')+'>Solicita็ใo Web de Compra</option>
	  cHTML += '	<option'+IIf(cTipo = "4",' selected','')+'>Centro de Custo</option>
	  cHTML += '	</select>	  
      cHTML += '	<a onclick="fConsultaCC()"><font color="#0000FF" style="cursor: pointer"> Consulta Centro de Custo</font></a></p>

      //Fim filial	 
      If(!Empty(cPedido))
        cHTML += '	<p align="left">'+aIdioma[39] + '</p> '  
        ///Data inicial       
        cHTML += '	<p align="left">*'+aIdioma[40] + '	<input type="text" name="DATAINI" size="12" onkeypress="fFormatData(1)"  maxlength="10">&nbsp;
        ///Data Final
        cHTML += '	*'+aIdioma[41]+' </font> ' + '	<input type="text" name="DATAFIM" size="12" onkeypress="fFormatData(2)"  maxlength="10"></p>
      EndIf

	  //Inicio Pedido
	  cHTML += '	<p align="left"><font face="Tahoma">*'+aIdioma[3]+' </font><input type="text" name="Pedido" size="30" onchange ="fVerPed" value="'+cPedido+'">
      //Fim Pedido                                                                                                                                              onchange="fVerPed()"
      cHtml += '    <input type = "button" name = "pesk" value="'+aIdioma[37]+'" onclick="fVerPed()">
      //Inicio Data de emissao
   	  cHTML += '	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
      cHTML += '	<font face="Tahoma">'+aIdioma[5]+' </font><input type="text" name="Emissao" size="30"value="'+cDemissao+'" disabled=true>
      //fim Data de emissao

     //Inicio Data de Fornecedor
  	  cHTML += '<p align="left"><font face="Tahoma">'+aIdioma[6]+' </font><input type="text" name="Fornecedor" size="50" value="'+cNomeFor+'" disabled=true>  
  	  cHTML += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
  	  cHtml += '<font face="Tahoma">'+aIdioma[7]+' </font><input type="text" name="cCodFor" size="30" value="'+cCodFor+'" disabled=true></p>'//Requisitante 
     //fim Data de fornecedor 
  	  
     //inicio da condi็ใo de pagamento
  	  cHTML += '<p align="left"><font face="Tahoma">'+aIdioma[8]+' </font><input type="text" name="CondPag" size="50" value="'+cCondPag+'" disabled=true>
     //fim da condi็ใo de pagamento
   
     cHTML += '	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
     
     //inicio da condi็ใo de pagamento
  	  cHTML += '<p align="left"><font face="Tahoma">'+aIdioma[4]+' </font><input type="text" name="Contato" size="50" value="'+cContato+'" disabled=true><br>  
  	  cHtml += '(*)'+ aIdioma[38]
     //fim da condi็ใo de pagamento
     If (AllTrim(cPedido)<>"")
        If(lAchado)
          if(AllTrim(cIdioma)=="P")
           cHTML += ' <p align=Left> <a onclick="fLink(1)"><font color="#0000FF" style="cursor: pointer">'+aIdioma[22]+' '+cPed+'</font></a>
           Else
               cHTML += ' <p align=Left> <a onclick="fLink(2)"><font color="#0000FF" style="cursor: pointer">'+aIdioma[22]+' '+cPed+'</font></a>
          EndIF
          Else
            cHTML += ' <p align=Left><font color="#0000FF">'+aIdioma[23]+'</font>
        EndIf
     EndIf 
    
	  cHTML += '    </DIV>   
	  cHtml += '</Script>
Return cHtml                                      

Static Function MontaTab(cCab1,cDesc1,cCab2,cDesc2)
  Local cHTML := ""
  cHTML += ' <table border="0" width="80%" id="table2">
  cHTML += '<tr>'
  cHTML += ' 			<td width="20%" >'+cCab1+'</td>
  cHTML += ' 			<td width="40%" align="Left"><font size="2" ><b>'+cDesc1+'</b></font></td>
  cHTML += ' 			<td width="15%">'+cCab2+'</td>
  cHTML += ' 			<td width="25%" align="Left"><font size="2"><b>'+cDesc2+'</b></font></td>
  cHTML += '</tr>'
Return cHTML
