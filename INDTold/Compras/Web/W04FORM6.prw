#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF04FORM6  บ Autor ณ ENER FREDES        บ Data ณ  18/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Follow Up da Requisi็ao de Viagem                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ INDT                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function W04FORM6(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)
  Local cServerHttp      
  Local cHTML := ""
  Private aCampos 
  Private aIdioma := {}                        
  Prepare Environment Empresa "01" Filial "01" Tables "SA2,SB1"
  cServerHttp :=  Getmv("MV_SERHTTP")
  cFil       := StrZero(Val(__aProcParms[1,2]),2)
  cReq       := StrZero(Val(__aProcParms[2,2]),10)
  cTipo      := Alltrim(__aProcParms[3,2])               
  cIdioma    := Upper(Alltrim(__aProcParms[4,2]))     

  aIdioma := U_F01INDIO(cIdioma)
  DbSelectArea("PA1") 
  DbSEtOrder(1)
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
  cHTML += '<SCRIPT>
/*
  cHTML += '</head>
  cHTML += '<form>
  cHTML += '<body>  
  If PA1->PA1_STATUS = 'L'
    cHTML += ' <h4><div align="center"><font color="#0000FF" face="Verdana"><strong>Status: Liberado</strong></font></div></h4>
  ElseIf  PA1->PA1_STATUS = 'C'
    cHTML += ' <h4><div align="center"><font color="#0000FF" face="Verdana"><strong>Status: Cancelada</strong></font></div></h4>
  Else
    cHTML += ' <h4><div align="center"><font color="#0000FF" face="Verdana"><strong>Status: Em Andamento</strong></font></div></h4>
  EndIf
*/  
  cHTML += U_F01FORM601(PA1->PA1_NUM,PA1->PA1_NVIAJ,PA1->PA1_VIAJ,PA1->PA1_REQUIS,PA1->PA1_NREQ,PA1->PA1_FILIAL,cDescFil,;
                        Dtoc(PA1->PA1_EMISSA),Dtoc(PA1->PA1_NECESS),PA1->PA1_DESCRI,PA1->PA1_AGVIAJ,Dtoc(PA1->PA1_DT_IDA),;
                        Dtoc(PA1->PA1_DT_RET),PA1->PA1_VISPAS,Alltrim(PA1->PA1_MOEDA),PA1->PA1_VLAD,PA1->PA1_TXMOED,;
                        PA1->PA1_AGENDA,PA1->PA1_DETALH,PA1->PA1_JUSTIF,"V",PA1->PA1_IDIOMA,PA1->PA1_TIPOVG,"","","",PA1->PA1_URGENC)
  cHTML += U_W02HisAP(PA1->PA1_FILIAL,PA1->PA1_NUM,PA1->PA1_TIPO,PA1->PA1_GRPAP,PA1->PA1_USERAP,.T.)
  cHTML += '</body>
  cHTML += '</form>
  cHTML += '</html>  
Return cHTML            
