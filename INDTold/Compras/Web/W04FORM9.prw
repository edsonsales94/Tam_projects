#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณW04FORM9  บ Autor ณ ENER FREDES        บ Data ณ  17/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de consulta de Centro de Custo                      บฑฑ
ฑฑบ          ณ 								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ INDT                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function W04FORM9(__aCookies,__aPostParms,__nProcID,__aProcParms,__cHTTPPage)
  Local cHTML
  Local cServerHttp
  Private aIdioma := {}                   
  Prepare Environment Empresa "01" Filial "01" Tables "CTT"
  cServerHttp :=  Getmv("MV_SERHTTP")
  cCampo    := Alltrim(__aProcParms[1,2]) 
  cPesquisa := UPPER(Alltrim(__aProcParms[2,2]))  
  cFil      := Alltrim(__aProcParms[3,2])
  cIdioma   := Alltrim(__aProcParms[4,2])
  
  
  aIdioma := U_F01INDIO(cIdioma)
  cTxt    := ""
  fMontaXml(cFil,cCampo,cPesquisa)  

  cHTML := '<html>                                            
  cHTML += '<head>
  cHTML += '	<title>Consulta</title>
  cHTML += '</head>
  cHTML += u_W02PStyle(.F.)

  cHTML += '<SCRIPT>                                     
  cHTML += 'function fPesquisa()
  cHTML += '{                                  
  cHTML += '  var oFrm       = document.forms[0];
  cHTML += '  var cCampo     = "CTT_DESC01";
  cHTML += '  var cPesquisa  = oFrm.PESQUISA.value;
  cHTML += '    if (oFrm.CAMPO.selectedIndex == 0)
  cHTML += '      cCampo   = "CTT_CUSTO";
  cHTML += '    if (oFrm.CAMPO.selectedIndex == 1)
  cHTML += '      cCampo   = "CTT_DESC01";
//  cHTML += '  oFrm.action = "http://'+cServerHttp+'u_w04form9.apl?&Campo="+cCampo+"&Pesquisa="+cPesquisa+"&P1=999&P2='+cTipo+'&P3='+cIdioma+'";
  cHTML += '  oFrm.action = "http://'+cServerHttp+'u_w04form9.apl?&Campo="+cCampo+"&Pesquisa="+cPesquisa+"&P1='+cFil+'&P2='+cIdioma+'";
  cHTML += '  oFrm.submit();
  cHTML += '}                            

  cHTML += 'function fSelecionar()
  cHTML += '{   
  cHTML += '  var oFrm       = document.forms[0];
  cHTML += '  var cCusto     = mygrid.cells(mygrid.row.idd,0).getValue();
  cHTML += '  var cDescri    = mygrid.cells(mygrid.row.idd,1).getValue();  
  cHTML += '  window.open("http://'+cServerHttp+'u_w04form1.apl?P1='+cFil+'&P2="+cCusto+"-"+cDescri+"&P3='+cIdioma+'&P4&P5&P6&P7&P8&P9=4", "JanelaPrincipal" , "width = 1000,height = 1000 , top = 0,left = 0 ,Menubar = yes Location = yes,Directories = yes,status = yes,scrollbars=yes"); 
  cHTML += '  window.close(); 
  cHTML += '}                            
  cHTML += '</SCRIPT>

  cHTML += '<form method="POST" action="">

  cHTML += '<body>
  cHTML += '    <p align="center"><font face="Tahoma"><b>Consulta de Centro de Custo</b></font></p>'//Consulta de Fornecedor
  cHTML += '	<p align="left"><font face="Tahoma"><b> </b>'
  cHTML += '	<select size="1" name="CAMPO"> 
  cHTML += '	<option>C๓digo</option>
  cHTML += '	<option selected >Descri็ใo</option>
  cHTML += '	</select>
  cHTML += '	<input type="text" name="PESQUISA" size="50" value="" ><font face="Tahoma" >

  cHTML += '	<button name="BPESQ" onclick = "fPesquisa()">Pesquisar</button>
  cHTML += '	<button name="BSELE" onclick = "fSelecionar()">Selecionar</button>
  cHTML += '	</p>

  cHTML += '	<link rel="STYLESHEET" type="text/css" href="../css/dhtmlXGrid.css">
  cHTML += '	<script  src="../js/dhtmlXCommon.js"></script>
  cHTML += '	<script  src="../js/dhtmlXGrid.js"></script>
  cHTML += '	<script  src="../js/dhtmlXGridCell.js"></script>	

  cHTML += '	<table width="700">
  cHTML += '		<tr>
  cHTML += '			<td>
  cHTML += '				<div id="gridbox" width="100%" height="300px" style="background-color:white;"></div>
  cHTML += '			</td>
  cHTML += '		</tr>
  cHTML += '		<tr>
  cHTML += '			<td>&nbsp;</td>
  cHTML += '		</tr>
  cHTML += '	</table>
  cHTML += '<hr>
  cHTML += '<script>
  cHTML += "    mygrid = new dhtmlXGridObject('gridbox');
  cHTML += '	mygrid.loadXML("gridCons.xml");
  cHTML += '</script>
  cHTML += '</body>
  cHTML += '</form>
  cHTML += '</html>
Return cHTML            

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMontaXml บ Autor ณ ENER FREDES        บ Data ณ  17/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina que grava um formulแrio temporariamente durante a   บฑฑ
ฑฑบ          ณ nas tabelas de detalhes da requisi็ใo durante a inclusใo   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ INDT                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fMontaXml(cFil,cCampo,cPesquisa)
  Local cQuery
  Local lReturn := .T.
  Local cNroCol := 1      
  
  Private cArqTxt := "../Protheus_data/Web/gridCons.xml"
  Private nHdl    := fCreate(cArqTxt)
  Private cEOL    := "CHR(13)+CHR(10)"

  If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
  Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
  Endif

  If nHdl == -1
    qout("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.")
    Return
  Endif
  
  fGrvArq('<rows>')
  fGrvArq('    <head>')
  fGrvArq('        <column width="200" type="ro" align="right" color="#AFEEEE" sort="str">Codigo</column>')
  fGrvArq('        <column width="480" type="ro" align="left" color="#AFEEEE" sort="str">Descricao</column>')
  fGrvArq('        <settings>')
  fGrvArq('            <colwidth>px</colwidth>')
  fGrvArq('        </settings>')
  fGrvArq('    </head>')

///  cQuery := " SELECT * FROM SA2010"
  cQuery := " SELECT * FROM "+RetSQLName("CTT")   
  cQuery += " WHERE  D_E_L_E_T_ <> '*' 
  cQuery += " AND CTT_CLASSE = '2' AND CTT_BLOQ = '2'
///  cQuery += " WHERE  A2_FILIAL = '"+cFil+"' AND A2_EST <> 'EX' AND D_E_L_E_T_ <> '*'

  If Empty(cCampo)
    cQuery += " AND  CTT_CUSTO = ''"
  Else
    cQuery += " AND "+Alltrim(cCampo)+ " LIKE '%"+Alltrim(cPesquisa)+"%'"
  EndIf  
  QOUT(cQuery)
  dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"CONS",.F.,.T.)
  DbGotop()
  While !CONS->(Eof())  
    cDescri := fValidTxt(CONS->CTT_DESC01)
    fGrvArq('<row id="'+Alltrim(Str(cNroCol))+'">')
    fGrvArq('<cell>'+Alltrim(CONS->CTT_CUSTO)+'</cell>')
    fGrvArq('<cell>'+Alltrim(cDescri)+'</cell>')
    fGrvArq('</row>')
    DbSkip()                               
    cNroCol++
  End
  fGrvArq('</rows>')
  fClose(nHdl)  
  DbselectArea("CONS")
  DbCloseArea("CONS")
Return 
              
Static Function fGrvArq(cCpo)
  Local nTamLin := 2
  Local cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao
  cLin := Stuff(cLin,01,02,cCpo)
  fWrite(nHdl,cLin,Len(cLin))
Return                              


Static Function fValidTxt(cTxt)   
  Local cTxtAlt := cTxt
  cTxtAlt := StrTran(cTxtAlt,"บ"," ")   
  cTxtAlt := StrTran(cTxtAlt,"ฐ"," ")   
  cTxtAlt := StrTran(cTxtAlt,"ช"," ")
  cTxtAlt := StrTran(cTxtAlt,"&","e")
  cTxtAlt := StrTran(cTxtAlt,"ไ","A") 
  cTxtAlt := StrTran(cTxtAlt,"ฤ","A") 
  cTxtAlt := StrTran(cTxtAlt,"๖","O")    
  cTxtAlt := StrTran(cTxtAlt,"ึ","O")    
  cTxtAlt := StrTran(cTxtAlt,"-"," ")  
  cTxtAlt := StrTran(cTxtAlt,"–"," ")  
Return cTxtAlt

