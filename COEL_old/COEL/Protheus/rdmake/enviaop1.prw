#include "rwmake.ch"
#include "protheus.ch"
#include "TOTVS.CH"
#include "topconn.ch"
#Include "AP5Mail.ch"
#Include "tbiconn.ch"
#include "fileio.ch"
#include "report.ch"
#INCLUDE "SHELL.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  | ENVIAOP   Autor:  FERNANDO AMORIM     Data 05/05/2019       º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao: WorkFlow de envio de csv formatado -relatorio de O.P.        º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       Coel                                  º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Enviop1()

//PREPARE ENVIRONMENT EMPRESA "09" FILIAL "01" 

Local dDataref      := DDATABASE  
Local cDirDocs      := "\workflow\ENVIOP"       //MsDocPath() //D:\Totvs12\workflow\ENVIOP\
Local cArquivo      := StrZero(Year(DDATABASE),4)+StrZero(Month(DDATABASE),2)+StrZero(Day(DDATABASE),2)//ALLTRIM(STR(DAY(dDataref)))+ ALLTRIM(STR(Month(dDataref)	))+ALLTRIM(STR(YEAR(dDataref)))     //CriaTrab(,.F.) 
Local nHandle
Local cCrLf         := Chr(13) + Chr(10)
Local nX
Local cSql          := ""
Local oServer
Local oMessage
Local nNumMsg       := 0
Local nTam          := 0
Local nI            := 0
Local _ni           := 0

_cAlias             := "QRY"
_aHeader            := {}

//-------------------------------------------------------------------++----------------------------------------------------------------------
// Prepara o Ambiente para a Execucao do WorkFlow                 
//-----------------------------------------------------------------------------------------------------------------------------------------

//If FindFunction('WFPREPENV')
	//	WFPrepEnv( "01", "01")
//Else
	//Prepare Environment Empresa "03" Filial '01'          
//	PREPARE ENVIRONMENT EMPRESA "09" FILIAL "01" //FUNNAME "ENVIAOP" TABLES "SC2"
//Endif
 

//---------------------------------------------------------------------------------------------------------------------------------------          
// GERO QUERY 
//- QUERY COEL
/* -FLAG -C2_X_EXP ,C,1
SELECT D4_OP AS OP, c2_pedido AS ORDINE, c2_item AS IT,c2_produto AS PRODUTO,B1_DESC AS DESCRICAO, 
c2_quant AS QUANT_OP, d4_cod AS COMPONENT,d4_qtdeori AS QUANT_NEC from sc2030 , SB1030 , SD4030
WHERE LEFT(d4_op,8) = c2_num+c2_item AND B1_COD = c2_produto AND c2_num = '092937' 
AND  B1_FILIAL = '01'
*/
//------------------------------------------------------------------------------------------------
cSql := " SELECT "
cSql += " SD4090.D4_OP AS OP,"                        
cSql += " ISNULL(SD4090.D4_FILIAL, '') AS FILIAL,"   
cSql += " SC2090.C2_PEDIDO AS ORDINE , "
cSql += " SC2090.C2_ITEM AS IT, "
cSql += " SC2090.C2_PRODUTO AS PRODUTO , "
cSql += " SB1090.B1_DESC AS DESCRICAO ,  "
cSql += " SD4090.D4_COD AS COMPONENT,    "
cSql += " SD4090.D4_QTDEORI AS QUANT_NEC   "                               

cSql += " FROM SC2090,SB1090,SD4090 "
cSql += " WHERE LEFT(d4_op,8) = c2_num+c2_item "
cSql += " AND B1_COD = c2_produto "
cSql += " AND C2_X_EXP <> 'S' "       
cSql += " AND C2_FILIAL = '01'     
//cSql += " AND C2_PEDIDO <> ''"    
cSql += " AND C2_EMISSAO = '"+ALLTRIM(DTOS(dDataref))+"' "        
cSql += " AND B1_FILIAL = '01' "
cSql += " ORDER BY SD4090.D4_OP "


TcQuery cSql New Alias "QRY"

QRY->(dbGoTop())

//WHILE QRY->(!EOF())
	//adiciona no array
	aadd(_aHeader, {"OP"        ,"OP"       ,"@!",14,0,"","","C","QRY","R"})
	//aadd(_aHeader, {"FILIAL"    ,"FILIAL"   ,"@!",02,0,"","","C","QRY","R"})
	aadd(_aHeader, {"ORDINE"    ,"ORDINE"   ,"@!",06,0,"","","C","QRY","R"})
	aadd(_aHeader, {"IT"        ,"IT"       ,"@!",02,0,"","","C","QRY","R"})
	aadd(_aHeader, {"PRODUTO"   ,"PRODUTO"  ,"@!",15,0,"","","C","QRY","R"})
	aadd(_aHeader, {"DESCRICAO" ,"DESCRICAO","@!",30,0,"","","C","QRY","R"})
	aadd(_aHeader, {"QUANT_NEC" ,"QUANT_NEC","@E 99999999",11,0,"","","N","QRY","R"})
	aadd(_aHeader, {"COMPONENT" ,"COMPONENT","@!",15,0,"","","C","QRY","R"})
	//aadd(_aHeader, {"EMISSAO"       ,"QRY->EMISSAO" ,"@!",08,0,"","","D","QRY","R"})
	//QRY->(dbskip())	
//enddo

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// GERAÇÃO DO CSV
//-------------------------------------------------------------------------------------------------------------------------------------------
//_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)
    
//if !empty(_cFiltro)
//          (_cAlias)->(dbsetfilter({|| &(_cFiltro)} , _cFiltro))
//endif
     
nHandle := MsfCreate(cDirDocs+"\"+"OP"+cArquivo+".CSV",0)
     
If nHandle > 0
          
    // Grava o cabecalho do arquivo
    aEval(_aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(_aHeader), ";", "") ) } )
    fWrite(nHandle, cCrLf ) // Pula linha
          
    //(_cAlias)->(dbgotop())
	QRY->(dbGoTop())

  WHILE QRY->(!EOF())
     //while (_cAlias)->(!eof())
               
         for _ni := 1 to len(_aHeader)
                    
             _uValor := ""
                    
             if _aHeader[_ni,8] == "D" // Trata campos data
                 _uValor := dtoc(&(_cAlias + "->" + _aHeader[_ni,2]))
             elseif _aHeader[_ni,8] == "N" // Trata campos numericos
                 _uValor := alltrim(transform(&(_cAlias + "->" + _aHeader[_ni,2]),_aHeader[_ni,3]))
             elseif _aHeader[_ni,8] == "C" // Trata campos caracter
                 _uValor := &(_cAlias + "->" + _aHeader[_ni,2])
             endif
                    
             if _ni <= len(_aHeader)
                 fWrite(nHandle, _uValor + ";" )
             endif
                    
         next _ni
               
         fWrite(nHandle, cCrLf )
               
         //(_cAlias)->(dbskip())
         QRY->(dbskip())      
     enddo
          
     fClose(nHandle)
     //copia o arquivo temporario para o diretorio de armazenamento
     //if !CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
     	//Conout( "Falha ao copiar arquivo temporario para pasta de destino final" )
     //endif     

     //If ! ApOleClient( 'MsExcel' )
     //     MsgAlert( 'MsExcel nao instalado')
     //     Return
     //EndIf
          
     //oExcelApp := MsExcel():New()
     //oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
     //oExcelApp:SetVisible(.T.)
Else
     Conout( "Falha na criação do arquivo" )
Endif
     
(_cAlias)->(dbclearfil())
     
//TEnvMail("fernando@oliminet.com.br","ENVIO DE OP","OP ANEXA",cDirDocs,cArquivo)
//U_QENVPCERT(cDirDocs+"\"+cArquivo+".TXT",_EMAIL)

U_QENVPOP1((cDirDocs+"\"+"OP"+cArquivo+".CSV"),'rogerio@oliminet.com.br')

//RESET ENVIRONMENT

RETURN()



//envio de mail ----------------------------------------------------------------------------------------------------------
USER Function QENVPOP1(_ARQUIVO,EMAIL)  //ENVIA O ARQUIVO GERADO NO DISCO POR EMAIL
local _ARQUIVO
LOCAL EMAIL
local atacha           
cServer 		:= GetMV("MV_RELSERV")
cFrom 			:= GetMV("MV_RELFROM")
cTo 			:= 'rogerio@oliminet.com.br;fernando.araujo@coel.com.br //;brandao@coel.com.br' 
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
	cHtml += "          <td height='0' bgcolor='#FFFFFF'><span class='style1'>Envio de arquivo texto (csv) </span></td>
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
    msgbox("e-mail nao enviado, verifique.")
endif
	
return

//----------------------------------------------------------------------------
Static Function mostraerro(lOk)
If !lOk
	GET MAIL ERROR cError
	qout(cError + if(lOk,"-OK","-Erro"))
EndIf
//----------------------------------------------------------------------------

/*/
/----------------------------------------------------------------------------------------------------------------------------------------------------
//envio de email--
//----------------------------------------------------------------------------------------------------------------------------------------------------
//Cria a conexão com o server STMP ( Envio de e-mail )

//Variaveis de Envio de E-mail                           ?
//Private cSerMail  := GetMv ( "MV_RELSERV" )               // Servidor de E-mail                    -- smtp.gmail.com:587
//Private lAutent   := GetMv ( "MV_RELAUTH" )               // Servidor Precisa de Autenticacao ?    -- .T.
//Private cConMail  := GetMv ( "MV_RELACNT" )               // Conta de Envio de E-mail         ?    -- relatorios@coel.com.br                                                                         
//Private cPswMail  := GetMv ( "MV_RELPSW"  )               // Senha da Conta de Envio de E-mail?    -- 102030ab
//Private cFroMail  := GetMv ( "MV_RELFROM" )               // Utilizado no Campo From do E-mail?    -- relatorios@coel.com.br
//Private cFroMail  := GetMv ( "MV_RELSSL" )                // conexao segura SSL?                   -- .T.
//Private cFroMail  := GetMv ( "MV_RELTLS" )                // conexao segura TLS?                   -- .T.

STATIC Function TEnvMail(cPara,cAssunto,cMensagem,cPath,cArquivo)
	Local cMsg := ""
	Local xRet
	Local oServer, oMessage
	Local lMailAuth	:= SuperGetMv("MV_RELAUTH",,.F.)
	Local nPorta := 587 //informa a porta que o servidor SMTP irá se comunicar, podendo ser 25 ou 587
 
	//A porta 25, por ser utilizada há mais tempo, possui uma vulnerabilidade maior a 
	//ataques e interceptação de mensagens, além de não exigir autenticação para envio 
	//das mensagens, ao contrário da 587 que oferece esta segurança a mais.
			
	Private cMailConta	:= "fernandoamorim.fa@gmail.com"  //NIL 
	Private cMailServer	:= "smtp.gmail.com"               //NIL
	Private cMailSenha	:= ""                     //NIL
 
	cMailConta :=If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada para envio do email
	cMailServer:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Servidor SMTP
	cMailSenha :=If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)             //Senha da conta de e-mail utilizada para envio
   	oMessage:= TMailMessage():New()
	oMessage:Clear()
   
	oMessage:cDate	:= cValToChar( Date() )
	oMessage:cFrom 	:= cMailConta
	oMessage:cTo 	:= cPara
	oMessage:cSubject:= cAssunto
	oMessage:cBody 	:= cMensagem
	
	xRet := oMessage:AttachFile( cPath+"\"+cArquivo+".CSV" )
	if xRet != 0
		cMsg := "O arquivo " + cPath+"\"+cArquivo+".CSV" + " não foi anexado!"
		alert( cMsg )
		return
	endif
   
	oServer := tMailManager():New()
	oServer:SetUseTLS( .T. ) //Indica se será utilizará a comunicação segura através de SSL/TLS (.T.) ou não (.F.)
   
	xRet := oServer:Init( "", cMailServer, cMailConta, cMailSenha, 0, nPorta ) //inicilizar o servidor
	if xRet != 0
		alert("O servidor SMTP não foi inicializado: " + oServer:GetErrorString( xRet ) )
		return
	endif
   
	xRet := oServer:SetSMTPTimeout( 60 ) //Indica o tempo de espera em segundos.
	if xRet != 0
		alert("Não foi possível definir " + cProtocol + " tempo limite para " + cValToChar( nTimeout ))
	endif
   
	xRet := oServer:SMTPConnect()
	if xRet != 0
		alert("Não foi possível conectar ao servidor SMTP: " + oServer:GetErrorString( xRet ))
		return
	endif
   
	if lMailAuth
		//O método SMTPAuth ao tentar realizar a autenticação do 
		//usuário no servidor de e-mail, verifica a configuração 
		//da chave AuthSmtp, na seção [Mail], no arquivo de 
		//configuração (INI) do TOTVS Application Server, para determinar o valor.
		xRet := oServer:SmtpAuth( cMailConta, cMailSenha )
		if xRet != 0
			cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
			alert( cMsg )
			oServer:SMTPDisconnect()
			return
		endif
   	Endif
	xRet := oMessage:Send( oServer )
	if xRet != 0
		alert("Não foi possível enviar mensagem: " + oServer:GetErrorString( xRet ))
	endif
   
	xRet := oServer:SMTPDisconnect()
	if xRet != 0
		alert("Não foi possível desconectar o servidor SMTP: " + oServer:GetErrorString( xRet ))
	endif
return

//----------------------------------------------------------------------------------------------------------------------
       

Static Function SchedDef(aEmp)

Local aParam := {}

aParam := {	"P"			,;	//Tipo R para relatorio P para processo
				"U_ENVIAOP()"	,;	//Nome do grupo de perguntas (SX1)
				Nil			,;	//cAlias (para Relatorio)
				Nil			,;	//aArray (para Relatorio)
				Nil			}	//Titulo (para Relatorio)

Return aParam
//------------------------------------------------------------------------------------------------------------------------------------------------------------

/*/
