#include "rwmake.ch"
#include "report.ch"
#INCLUDE "topconn.ch"
#INCLUDE "SHELL.CH"

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"                                                                       
#INCLUDE "FWPrintSetup.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ txtfatco  ³ Autor ³ FERNANDO AMORIM      ³ Data ³ 29/07/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Distribuicao de txt faturamento  cliente fricon            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RDMAKE  ³                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//-----------------------------------------------------------------------------------------------------------------
//funcao chamada pelo fonte DANFEII
//ADICIONA ITENS DAS NOTAS AO ARRAY DE CERTIFICADOS PARA GERACAO DO ARQUIVO
//PARA A PARTE DE IMPRESSAO
User Function QIMPDtxt(_NFDE,_NFATE,_SERIE) 
LOCAL _NFDE
LOCAL _NFATE
LOCAL _SERIE
local aitentxt := {}
local npos  := 0     
LOCAL CEMAIL := ""

DBSELECTAREA("SD2")
DbSetOrder(3)  //filial+doc+serie+cliente+loja
//If dbSeek( xFilial("SD2")+_NFDE+_SERIE) //AJUSTE POR CAUSA DO NUMERO DE CARACTERES DA NFE
IF dbSeek( xFilial("SD2")+ALLTRIM(_NFDE)+SPACE(9-LEN(ALLTRIM(_NFDE)))+(_SERIE))                      
	WHILE !EOF() .AND. ALLTRIM(D2_DOC) >= ALLTRIM(_NFDE) .AND. ALLTRIM(D2_DOC) <= ALLTRIM(_NFATE)
		if ALLTRIM(D2_SERIE) = ALLTRIM(_SERIE)
		    //VERIFICA SE CLIENTE PRECISA DO TXT
		    if ALLTRIM(D2_CLIENTE) = '007566' // SE MULTIFRICON
                
                AADD(aitentxt ,{posicione("SF2",1,XFILIAL("SF2")+D2_DOC+D2_SERIE,'F2_CHVNFE'),;
                DDATABASE,;
                D2_COD,;
                POSICIONE("SC6",1,XFILIAL("SC6")+D2_PEDIDO+D2_ITEMPV,'C6_NUMOP'),; 
                POSICIONE("SC6",1,XFILIAL("SC6")+D2_PEDIDO+D2_ITEMPV,'C6_ITEMOP'),;
                POSICIONE("SB1",1,XFILIAL("SB1")+D2_COD,'B1_CODBAR'),SPACE(106),;
                })
                
		    	CEMAIL := posicione("SA1",1,XFILIAL("SA1")+D2_CLIENTE+D2_LOJA,'A1_EMAIL')
		    endif    	
		endif
		dbskip()
	enddo
	if !empty(aitentxt)
		gerceimp(aitentxt,CEMAIL)
	endif
else
	msgbox('Nao encontrado itens, para os parametros')
endif
Return
   
//---------------------------------------------------------------------------------------------------------------------------
//GERA O TXT                                                      
static Function gerceimp(_itentxt,_EMAIL)
LOCAL _EMAIL
Local dDataref := DDATABASE
LOCAL _itentxt  
LOCAL _aHeader := {}
Local cDirDocs := "\workflow\ENVTXT"       //MsDocPath() //D:\Totvs12\workflow\ENVIOP\
Local cArquivo := "CDB" + ALLTRIM(STR(DAY(dDataref)))+ ALLTRIM(STR(Month(dDataref)	))+ALLTRIM(STR(YEAR(dDataref))) + "_" + SUBSTR(TIME(),1,2) + SUBSTR(TIME(),4,2) +SUBSTR(TIME(),7,2)     //CriaTrab(,.F.)  
Local nHandle
Local cCrLf    := Chr(13) + Chr(10)
Local _data    := ''

//inicia variavel de controle
//_control := _cert[1][4]+_cert[1][5] //nota+serie

//CRIA ARQUIVO
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".TXT",0)

If nHandle > 0

	//ADICIONA VALOR AO CABECALHO(CNPJ E BRANCOS)
	//aadd(_aHeader, {SM0->M0_CGC  ,"ORDINE"   ,"@!",06,0,"","","C","QRY","R"})
	//aadd(_aHeader, {SPACE(76)    ,"ORDINE"   ,"@!",06,0,"","","C","QRY","R"})
	aadd(_aHeader, {SM0->M0_CGC})     //CNPJ
	aadd(_aHeader, {SPACE(76)})       //ESPACOS
	aadd(_aHeader, {cCrLf})           //FINAL DE LINHA

	//inicia o cabecalho 
	aEval(_aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(_aHeader), "", "") ) } )
	
	//loop do array dos itens
	for _ni := 1 to len(_itentxt)
	            
	    _uValor := ""
	            
	    //if _itentxt[_ni,6] == "D" // Trata campos data
	    //    _uValor := dtoc(&(_cAlias + "->" + _itentxt[_ni,2]))
	    //elseif _itentxt[_ni,6] == "N" // Trata campos numericos
	    //    _uValor := alltrim(transform(&(_cAlias + "->" + _itentxt[_ni,2]),_itentxt[_ni,3]))
	    //elseif _itentxt[_ni,6] == "C" // Trata campos caracter
	    //    _uValor := &(_cAlias + "->" + _itentxt[_ni,2])
	   // endif         
	    
	    _cDigCodbar := EanDigito('7895113'+Substr(_itentxt[_ni,6] ,1,5) )                
	    
        _uValor := _uValor + _itentxt[_ni,1]                                                                //CHAVE NFE
        IF len(alltrim(dtoc(_itentxt[_ni,2]))) < 10
        	_data := substr(ALLTRIM((dtoc(_itentxt[_ni,2]))),1,2) + substr(ALLTRIM((dtoc(_itentxt[_ni,2]))),4,2) + '20' + substr(ALLTRIM((dtoc(_itentxt[_ni,2]))),7,2)
        ELSE
        	_data := substr(ALLTRIM((dtoc(_itentxt[_ni,2]))),1,2) + substr(ALLTRIM((dtoc(_itentxt[_ni,2]))),4,2) + substr(ALLTRIM((dtoc(_itentxt[_ni,2]))),7,4)
        ENDIF
        _uValor := _uValor + _data                                                                           //DATA
        _uValor := _uValor + alltrim(_itentxt[_ni,3]) + space(16 - len(alltrim(_itentxt[_ni,3])))            //CODIGO PRODUTO     
        _uValor := _uValor + alltrim(_itentxt[_ni,4]) + space(06 - len(alltrim(_itentxt[_ni,4])))            //LOTE=OP         
        _uValor := _uValor + alltrim(_itentxt[_ni,5]) + space(04 - len(alltrim(_itentxt[_ni,5])))            //LOTE= Item da OP
//        _uValor := _uValor + '7895113' + alltrim(_itentxt[_ni,6]) + space(15 - len(alltrim('7895113' + alltrim(_itentxt[_ni,6])))) //CODIGO DE BARRAS  
        _uValor := _uValor + '7895113' + Substr(_itentxt[_ni,6] ,1,5)+_cDigCodbar + space(15 - len(alltrim('7895113' + Substr(_itentxt[_ni,6] ,1,5)+_cDigCodbar))) //CODIGO DE BARRAS 
        _uValor := _uValor + space(5)                                                                        //ESPACO  
        _uValor := _uValor + cCrLf                                                                           //FINAL DE LINHA

        //AllTrim("7895113" + ALLTRIM(SB1->B1_CODBAR))


        //GRAVA LINHA	            
	    if _ni <= len(_itentxt)
	        fWrite(nHandle, _uValor + "" )
	    endif
	            
	next _ni
	       
	//GRAVA O ARQUIVO
	fWrite(nHandle, cCrLf )
	
	//encerra 
	fClose(nHandle)
	
	//ENVIO O EMAIL
	U_QENVPCERT(cDirDocs+"\"+cArquivo+".TXT",_EMAIL)

Else
     Conout( "Falha na criação do arquivo" )
     ALERT("Falha na criação do arquivo TXT de envio codigo de barras, verifique" )
Endif


return

//envio de mail ----------------------------------------------------------------------------------------------------------
USER Function QENVPCERT(_ARQUIVO,EMAIL)  //ENVIA O ARQUIVO GERADO NO DISCO POR EMAIL
local _ARQUIVO
LOCAL EMAIL
local atacha           
cServer 		:= GetMV("MV_RELSERV")
cFrom 			:= GetMV("MV_RELFROM")
cTo 			:= 'NFERECEBIMENTO@FRICON.COM.BR;rogerio@oliminet.com.br;sabrina.lima@mercofricon.com.br' //CEMAIL //'rogerio@oliminet.com.br'
cCC				:= ''
cBCC			:= ''                                   //
cUser 			:= GetMV("MV_RELACNT")
ccSenha 		:= GetMV("MV_RELPSW")
lOk 			:= .T.
cTitulo			:= ".: Envio de arquivos anexos Coel :."
cHtml           := " "
afileat         := {}

IF File(_ARQUIVO)  //TRATA arquivo no disco

    //INSERE ANEXO
	atacha := _ARQUIVO
	
	//monta html-------------------------------------------------------------
	cHtml := ''
	cHtml += " <html>
	cHtml += "<head>
	cHtml += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' />
	cHtml += "<title>Envio de Certificados de produtos</title>
	cHtml += "<style type='text/css'>
	cHtml += "<!--
	cHtml += ".style1 {
	cHtml += "	font-family: Verdana, Arial, Helvetica, sans-serif;
	cHtml += "	font-weight: bold;
	cHtml += "	font-size: 12px;
	cHtml += "	color: #000000;
	cHtml += "}
	cHtml += "-->
	cHtml += "</style>
	cHtml += "</head>
	cHtml += "<body>
	cHtml += "<table width='920' border='1' align='center' cellpadding='0' cellspacing='0' bordercolor='#F0F0F0'>
	cHtml += "  <tr>
	cHtml += "    <td width='920'><form action=''>
	cHtml += "      <table width='420' height='100%' border='0' align='center' cellpadding='0' cellspacing='0'>
	cHtml += "  </tr>
	cHtml += "        <tr>
	cHtml += "          <td height='0' bgcolor='#FFFFFF'><div align='left'></div></td>
	cHtml += "        </tr>
	cHtml += "        <tr>
	cHtml += "          <td height='0' bgcolor='#FFFFFF'><span class='style1'>COEL. </span></td>
	cHtml += "        </tr>
	cHtml += "        <tr>          
	cHtml += "          <td height='0' bgcolor='#FFFFFF'><span class='style1'>-------------------------------------------------------- </span></td>
	cHtml += "        </tr> 
	cHtml += "        <tr>
	cHtml += "          <td height='0' bgcolor='#FFFFFF'><span class='style1'>Envio de arquivo texto </span></td>
	cHtml += "        </tr>
	cHtml += "</table>
	cHtml += "</body>
	cHtml += "</html>
	//------------------------------------------------------------------------

    //MSGBOX('VOU ENVIAR O EMAIL PARA ' + CTO)
    
    CONNECT SMTP SERVER cServer ACCOUNT cUser PASSWORD ccSenha result lok
    mostraerro(lOk)
    mostraerro(mailauth(cUser,ccSenha))
    //If !Empty(afileat)
        SEND MAIL FROM cFrom TO cTo CC cCC BCC cBCC SUBJECT cTitulo  BODY cHtml Attachment atacha RESULT lOk
    //else
        //SEND MAIL FROM cFrom TO cTo CC cCC BCC cBCC SUBJECT cTitulo  BODY cHtml RESULT lOk
    //endif
    mostraerro(lOk)
    DISCONNECT SMTP SERVER result lok
    mostraerro(lOk)
ELSE    
    msgbox("e-mail de txt com cod de barras nao enviado, verifique.")
endif
	
return

//----------------------------------------------------------------------------
Static Function mostraerro(lOk)
If !lOk
	GET MAIL ERROR cError
	qout(cError + if(lOk,"-OK","-Erro"))
EndIf
//----------------------------------------------------------------------------

