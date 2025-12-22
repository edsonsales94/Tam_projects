#include "ap5mail.ch"
#include "Protheus.Ch"
#include "TopConn.Ch"
#include "TBIConn.Ch"
/*/{protheus.doc}CHECKEDI
Rotina de verificacao do processamento do EDI
@author Leandro do NascimentoบData
@since 19/08/2013
/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCHECKEDI  บAutor  ณLeandro do NascimentoบData ณ  19/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica processamento do EDI 	                          บฑฑ
ฑฑบ          ณHonda Lock                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿   
*/
User Function CHECKEDI()   

 RPCSetType(3)
 Prepare Environment EMPRESA "01" FILIAL "01" MODULO "05"
 
 ConOut("Inicio Job Check EDI - Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]")

 FS_CHECKEDI()

 ConOut("Final Job Check EDI - Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]") 

 Reset Environment
 
 Return(Nil)   

Static Function FS_CHECKEDI()

Local cTmp            := CriaTrab( nil, .f. )
Local aArea		      := GetArea()

Local cAssunto  := "Check EDI em " + Dtoc(Date()) + " เs " + SubStr( Time(),1,5 ) 
Local cCorpoMsg	:= "    
Local cPula     := CHR(13) + CHR(10)
Local cDtUltEdi	:= GetMv( "HL_DTULIDE" ) // Data da Ultima execu็ใo do Job IDE
Local cHrUltEdi	:= GetMv( "HL_HRULIDE" ) // Hora da Ultima execu็ใo do Job IDE
Local cCliAtu 	:= "a"
Local cCliAnt 	:= "b"     
Local cDoc		:= ""
Local cSerie 	:= ""
Local cEmissao 	:= ""
Local cHora		:= ""
Local cSaida	:= ""   
Local lEnvMail 	:= .F.
Private cQry	:= ""

cQry := fConsSQL(cDtUltEdi,cHrUltEdi )
cQry := ChangeQuery( cQry )

TCQUERY cQry NEW ALIAS &(cTmp)

	cCorpoMsg := "Prezado Usuแrio,"+cPula+cPula
	cCorpoMsg += "Segue registros que nใo foram processados pelo EDI at้ o momento,"
	cCorpoMsg +=cPula+ "้ altamente recomendแvel, verificar eventuais inconsist๊ncias no processo."
	cCorpoMsg +=cPula+cPula+'<b <font size="2">Filial: </font></b>' +SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+SM0->M0_NOMECOM
	cCorpoMsg +=cPula+'<b <font size="2">Data/Hora da ๚ltima execu็ใo do EDI: </font></b>'+ Alltrim(Dtoc(cDtUltEdi))+" as "+Alltrim(cHrUltEdi)
	
	If alltrim(cDtUltEdi) <= dtos(date()) .And. IncTime(cHrUltEdi,0,35) > SubStr(Time(),1,5)
		cCorpoMsg +=cPula+'<b <font size="2">RECOMENDAวรO: </font></b>'+" Verificar o JOB de execu็ใo do Servi็o "
	Else
		cCorpoMsg +=cPula+'<b <font size="2">RECOMENDAวรO: </font></b>'+" Verificar inconsistencias na Rotina "	
	Endif


dbSelectArea(cTmp)
dbGoTop()	
	While ! Eof()
    
    	cCliAtu := (cTmp)->F2_CLIENTE+(cTmp)->F2_LOJA 
 	
		IF cCliAtu <> cCliAnt
			cCorpoMsg +=cPula+cPula+"<b> <span style='color:red'> <font size='2'> Cliente: "+(cTmp)->F2_CLIENTE+"/"+(cTmp)->F2_LOJA+" - "+(cTmp)->A1_NOME+"</font></b> </span>"
	 		cCorpoMsg += CriaTab(.T., "Nro. Documento", "Serie", "DT Emissใo", "Hora", "DT Entrega")			
			
		Endif
       
       	cDoc	 := Alltrim((cTmp)->F2_DOC) 
       	cSerie 	 := Alltrim((cTmp)->F2_SERIE)
       	cEmissao := Substr((cTmp)->F2_EMISSAO,7,2) +"/"+ Substr((cTmp)->F2_EMISSAO,5,2)+"/"+Substr((cTmp)->F2_EMISSAO,1,4)
       	cHora	 := Alltrim((cTmp)->F2_HORA)                      
       	cSaida	 := Substr((cTmp)->F2_ZZDTSAI,7,2)+"/"+Substr((cTmp)->F2_ZZDTSAI,5,2)+"/"+Substr((cTmp)->F2_ZZDTSAI,1,4)

 		cCorpoMsg += CriaTab(.F.,cDoc ,cSerie ,cEmissao ,cHora ,cSaida)			
    	cCliAnt := (cTmp)->F2_CLIENTE+(cTmp)->F2_LOJA

	(cTmp)->(DbSkip())

		lEnvMail := .T.
	
	Enddo      
	cCorpoMsg += cPula+cPula+" Sistema de Notifica็ใo de Eventos - Microsiga/Protheus "

If lEnvMail
	MonitMail( cAssunto, cCorpoMsg)
Else
 ConOut("Sem Notificacoes - Job Check EDI - Data [" + DToC(dDataBase) + "] Hora [" + Time() + "]") 
Endif

dbCloseArea()
Return( nil )
            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfConsSQL  บAutor  ณAlessandro Freire   บ Data ณ  24/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a String da Consulta                                 บฑฑ
ฑฑบ          ณHonda Lock                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿   

*/
Static Function fConsSQL(cDtUltEdi,cHrUltEdi )

cQry := "SELECT "
cQry += "		F2_FILIAL, F2_CLIENTE, F2_LOJA, A1_NOME, F2_DOC, F2_SERIE, F2_EMISSAO, F2_HORA, F2_ZZDTSAI "
cQry += " FROM "
cQry += "	" +RetSqlName('SF2')+" F2 "
cQry += "	INNER JOIN "+RetSqlName('SA1')+" A1 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND A1_ZZEDI = 'S' AND A1.D_E_L_E_T_ = '' "
//cQry += "	INNER JOIN "+RetSqlName('SA1')+" A1 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND A1.D_E_L_E_T_ = '' " //linha add para teste
cQry += " WHERE "
cQry += "	F2_ZZEDI = ' ' "  

If alltrim(cDtUltEdi) <= dtos(date()) .And. IncTime(cHrUltEdi,0,35) > SubStr(Time(),1,5)
	cQry += " 	AND F2_ZZDTSAI <= '"+alltrim(cDtUltEdi)+"' "
	cQry += "	AND F2_HORA <= '"+alltrim(cHrUltEdi)+"' "
Else
	cQry += " 	AND F2_ZZDTSAI >= '"+alltrim(cDtUltEdi)+"' "
	cQry += "	AND F2_HORA >= '"+alltrim(cHrUltEdi)+"' "
Endif

cQry += "	AND F2.D_E_L_E_T_ = '' "
cQry += "ORDER BY "
cQry += "	F2_CLIENTE, F2_LOJA, F2_EMISSAO, F2_DOC, F2_SERIE "
	
Return(cQry)

****************************************************************************************    

static Function CriaTab(lCabec, cColuna1, cColuna2, cColuna3, cColuna4, cColuna5)
cTab := ""

cTab := "<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0 "
cTab += "style='border-collapse:collapse;border:none;mso-border-alt:solid black .5pt; "
cTab += "mso-border-themecolor:text1;mso-yfti-tbllook:1184;mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>"

If lCabec

cTab +=" <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes'> "
cTab +="   <td width=115 valign=top style='width:86.4pt;border:solid black 1.0pt; "
cTab +="   mso-border-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: "
cTab +="   text1;padding:0cm 5.4pt 0cm 5.4pt'> "
cTab +="   <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt; "
cTab +="   text-align:center;line-height:normal'><b><span style='font-size:10.0pt; "
cTab +="   mso-bidi-font-weight:bold' >"+cColuna1+"<o:p></o:p></b></span></p> "
cTab +="   </td> "
cTab +="   <td width=115 valign=top style='width:86.45pt;border:solid black 1.0pt; "
cTab +="   mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; "
cTab +="   mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: "
cTab +="   text1;padding:0cm 5.4pt 0cm 5.4pt'> "
cTab +="   <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: "
cTab +="   normal'><b><span style='font-size:10.0pt;mso-bidi-font-weight:bold'>"+cColuna2+"<o:p></o:p></b></span></p> "
cTab +="   </td> "
cTab +="   <td width=117 valign=top style='width:88.05pt;border:solid black 1.0pt; "
cTab +="   mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; "
cTab +="   mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: "
cTab +="   text1;padding:0cm 5.4pt 0cm 5.4pt'> "
cTab +="   <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: "
cTab +="   normal'><b><span style='font-size:10.0pt;mso-bidi-font-weight:bold'>"+cColuna3+"<o:p></o:p></b></span></p> "
cTab +="   </td> "
cTab +="   <td width=115 valign=top style='width:86.45pt;border:solid black 1.0pt; "
cTab +="   mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; "
cTab +="   mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: "
cTab +="   text1;padding:0cm 5.4pt 0cm 5.4pt'> "
cTab +="   <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: "
cTab +="   normal'><b><span style='font-size:10.0pt;mso-bidi-font-weight:bold'>"+cColuna4+"<o:p></o:p><b></span></p> "
cTab +="   </td> "
cTab +="   <td width=115 valign=top style='width:86.45pt;border:solid black 1.0pt; "
cTab +="   mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; "
cTab +="   mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: "
cTab +="   text1;padding:0cm 5.4pt 0cm 5.4pt'> "
cTab +="   <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: "
cTab +="   normal'><b><span style='font-size:10.0pt;mso-bidi-font-weight:bold'>"+cColuna5+"<o:p></o:p></b></span></p> "
cTab +="   </td> "
cTab +="  </tr> "

Else      
cTab +=" <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes'> "
cTab +="   <td width=115 valign=top style='width:86.4pt;border:solid black 1.0pt; "
cTab +="   mso-border-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: "
cTab +="   text1;padding:0cm 5.4pt 0cm 5.4pt'> "
cTab +="   <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt; "
cTab +="   text-align:center;line-height:normal'><span style='font-size:10.0pt; "
cTab +="   mso-bidi-font-weight:bold'>"+cColuna1+"<o:p></o:p></span></p> "
cTab +="   </td> "
cTab +="   <td width=115 valign=top style='width:86.45pt;border:solid black 1.0pt; "
cTab +="   mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; "
cTab +="   mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: "
cTab +="   text1;padding:0cm 5.4pt 0cm 5.4pt'> "
cTab +="   <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: "
cTab +="   normal'><span style='font-size:10.0pt;mso-bidi-font-weight:bold'>"+cColuna2+"<o:p></o:p></span></p> "
cTab +="   </td> "
cTab +="   <td width=117 valign=top style='width:88.05pt;border:solid black 1.0pt; "
cTab +="   mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; "
cTab +="   mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: "
cTab +="   text1;padding:0cm 5.4pt 0cm 5.4pt'> "
cTab +="   <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: "
cTab +="   normal'><span style='font-size:10.0pt;mso-bidi-font-weight:bold'>"+cColuna3+"<o:p></o:p></span></p> "
cTab +="   </td> "
cTab +="   <td width=115 valign=top style='width:86.45pt;border:solid black 1.0pt; "
cTab +="   mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; "
cTab +="   mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: "
cTab +="   text1;padding:0cm 5.4pt 0cm 5.4pt'> "
cTab +="   <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: "
cTab +="   normal'><span style='font-size:10.0pt;mso-bidi-font-weight:bold'>"+cColuna4+"<o:p></o:p></span></p> "
cTab +="   </td> "
cTab +="   <td width=115 valign=top style='width:86.45pt;border:solid black 1.0pt; "
cTab +="   mso-border-themecolor:text1;border-left:none;mso-border-left-alt:solid black .5pt; "
cTab +="   mso-border-left-themecolor:text1;mso-border-alt:solid black .5pt;mso-border-themecolor: "
cTab +="   text1;padding:0cm 5.4pt 0cm 5.4pt'> "
cTab +="   <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height: "
cTab +="   normal'><span style='font-size:10.0pt;mso-bidi-font-weight:bold'>"+cColuna5+"<o:p></o:p></span></p> "
cTab +="   </td> "
cTab +="  </tr> "

Endif

cTab +="</table> "
return (cTab)


static Function MonitMail( cAssunto, cMensagem )

Local cMailServer := GETMV("MV_RELSERV") 
Local cMailContX  := GETMV("MV_RELACNT")
Local cMailSenha  := GETMV("MV_RELAPSW") 
Local cMailDest   := GETMV("MV_HLEDIM" )
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