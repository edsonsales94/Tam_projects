#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF04FORM7  บ Autor ณ ENER FREDES        บ Data ณ  18/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Follow Up da Requisi็ao de Pagamento                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ INDT                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function W04FORM7(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)   
  Local cServerHttp      
  Local cHTML := ""
  Private aCampos 
  Private aIdioma := {}                        
  Prepare Environment Empresa "01" Filial "01" Tables "SA2,SB1"
  Return 'Inoperante'
  cServerHttp :=  Getmv("MV_SERHTTP")
  cFil       := StrZero(Val(__aProcParms[1,2]),2)
  cReq       := StrZero(Val(__aProcParms[2,2]),10)
  cTipo      := Alltrim(__aProcParms[3,2])               
  cIdioma    := Upper(Alltrim(__aProcParms[4,2]))     

  aIdioma := U_W03IDIOM(cIdioma)
  DbSelectArea("PA1") 
  DbSEtOrder(1)
  qout("gadelha")
  qout(cFil+cReq+cTipo)
  If !DbSeek(cFil+cReq+cTipo)
    cHTML += '<html>
    cHTML += '<head>
    cHTML += '<meta http-equiv="Content-Language" content="en-us">
    cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    cHTML += u_styleCSS(.T.)
    cHTML += ' <title>'+aIdioma[1]+aIdioma[53]+'</title> ' //Requisi็ใo de Compras Aprovado com sucesso!
    cHTML += '</head>
    cHTML += '<form>
    cHTML += '<body>  
    cHTML += ' <h4><div align="center"><font color="#0000FF" face="Verdana"><strong>Requisi็ใo Nใo Encontrada</strong></font></div></h4>
    cHTML += '</body>
    cHTML += '</form>
    cHTML += '</html>  
    Return cHTML
  EndIf   
  If PA1->PA1_FILIAL = "01"
    cDescFil := "Manaus"
  ElseIf PA1->PA1_FILIAL = "02"
    cDescFil := "Brasilia"
  ElseIf PA1->PA1_FILIAL = "03"
    cDescFil := "Recife"
  Else  
    cDescFil := "Sใo Paulo"
  EndIf
  cHTML += '<html>
  cHTML += '<head>
  cHTML += '<meta http-equiv="Content-Language" content="en-us">
  cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
  cHTML += u_styleCSS(.T.)
  cHTML += ' <title>'+aIdioma[1]+aIdioma[53]+'</title> ' //Requisi็ใo de Compras Aprovado com sucesso!

   cHTML += U_W03FORM2(PA1->PA1_NUM,PA1->PA1_REQUIS,PA1->PA1_NREQ,PA1->PA1_VIAJ,PA1->PA1_NVIAJ,PA1->PA1_FILIAL,;
    					cDescFil,dToc(PA1->PA1_EMISSA),Alltrim(PA1->PA1_MOEDA),"",0,PA1->PA1_AGENDA,PA1->PA1_DETALH,;
    					PA1->PA1_JUSTIF,PA1->PA1_TIPO,PA1->PA1_IDIOMA,PA1->PA1_BANCO,PA1->PA1_AGENCI,PA1->PA1_CONTA,;
    					dTos(PA1->PA1_NECESS))

  
  cHTML += U_W02HisAP(PA1->PA1_FILIAL,PA1->PA1_NUM,PA1->PA1_TIPO,PA1->PA1_GRPAP,PA1->PA1_USERAP,.T.)
  cHTML += '</body>
  cHTML += '</form>
  cHTML += '</html>  
Return cHTML            
