#include "Protheus.ch"
#Include "tbiconn.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "ap5mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºFun??o    ? MOINVENT   º Autor ? Mauro Yokota º Data ?  02/02/18   º??
??ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ???
±±³Descricao ³ Importacao de dados de arquivo .CSV para:           	      ³±±
??º          ? Atualizar o preco de venda de itens                        º??
??ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºUso       ? Especifico                                                 º??
??ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ???
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User FUNCTION HLSIMPPV
Private cTitulo		:= "Importar Planilha de Atualizacao Precos"
Private lEnd	:=.f.
Private nPosAtu := 0
Private nEof	:= 0
Private cDoc	:= Space(09)
Private cEmail	:= Space(40)
Private aErro	:= {}
Private	nLastKey:= 0

@ 000,000 TO 200,500 DIALOG oDlg1 TITLE "Atualizacao de Precos de Venda" 
@ 010,005 Say OemtoAnsi("Esta rotina tem o objetivo de importar arquivos contendo as ")
@ 020,005 Say OemtoAnsi("informacoes referente aos precos dos itens")
@ 040,005 Say "Documento : "
@ 042,045 get cDoc 
@ 050,005 Say "E-Mail : "
@ 052,045 get cEmail 
@ 060,150 BMPBUTTON TYPE 01 ACTION Processa({|lEnd| ImpTxt()},"Processando..","Posicao: "+strzero(nPosAtu,10)+"/"+strzero(nEof,10),.t.)
@ 075,150 BMPBUTTON TYPE 02 ACTION Close(oDlg1)

ACTIVATE DIALOG oDlg1 CENTERED

Return


/*
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Importacao de dados de arquivo .CSV           	       	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/
Static Function ImpTxt()

Private _cFile := ""
Private _cType := ""
Private _nTot  := 0
Close(oDlg1)

_cType := "*.* | *.*"
_cFile := cGetFile(_cType, OemToAnsi("Selecione o arquivo Texto dos Produtos em Excel (*.*)"))

If Empty(_cFile)
	Return
EndIf

nHdl := fopen(_cFile,0)
_nTot:= fSeek(nHdl,0,2)
fClose(nHdl)

If _nTot > 0
	Processa({||Importa(),,"Importando os Registros. Aguarde..."})
EndIf

Return


Static Function Importa()

Local _cBuffer		:= ""
Local aLinha 		:= {}
Local _cTexto		:= ""
Local nLinha		:= 1
Private aArraYA 	:= {}

Begin Transaction
FT_FUSE(_cFile)
FT_FGOTOP()
_cBuffer := FT_FREADLN()
ProcRegua(_nTot)
Do While !FT_FEOF()
	
	aLinha 		:= {}
	
	// Executa leitura da linha em _cBuffer e identifica os campos pelo delimitador ";"
	If Len(_cBuffer) >0
		_cTexto	:= ""
		For nX 	:= 1 to Len(_cBuffer)
			If Substr(_cBuffer,nX,1) == ";"
				aAdd(aLinha, _cTexto )
				_cTexto := ""
			Else
				_cTexto += Substr(_cBuffer,nX,1)
			Endif
		Next nX
		If !Empty(_cTexto)
			aAdd(aLinha, _cTexto )
		Else
			aAdd(aLinha, " " )
		Endif
	Endif
	lGrava := .F.
	If Len(aLinha) > 0 
       	aAdd(aArraya,{PADR(aLinha[01],15), aLinha[02] })
	Endif
	FT_FSKIP()
	_cBuffer := FT_FREADLN()
Enddo
FT_FUSE()
End Transaction

nErro	:= 0
aLista	:= {}

For I = 1 to Len(aArraya)
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+aArraya[I,01])		
	   	RecLock("SB1",.F.)		
		SB1->B1_PRV1	:= Val(aArraya[I,02])
		MsUnLock()	
	Else
		nErro ++	
		aAdd(aLista,{aArraya[I,01]})		
	Endif	          
Next I


/*If Len(aLista) > 0
	nHora    	:= val(subs(Time(),1,2))
	cSaudacao	:= iif(nHora>=12 .and. nHora<18,'Boa Tarde',iif(nHora>=18 .and. nHora<=24,'Boa Noite','Bom dia'))
	cAssunto 	:= "Relação dos Produtos não Encontrado (SB1) !!"
	cMens    	:= ''
	nTotal   	:= 0
	cServer  	:= Alltrim(GETMV("MV_RELSERV"))
	cAccount 	:= Alltrim(GETMV("MV_RELACNT"))
	cPasswrd 	:= Alltrim(GETMV("MV_RELPSW"))
	lEnv      	:= .F.
	lFim      	:= .F.
	cMens := '<HTML>'
	cMens += '   <HEAD>'
	cMens += '      <TITLE> '+cAssunto+' </TITLE>'
	cMens += '	   <LINK rel=stylesheet type=text/css href=scripts/dwstyle.css>'
	cMens += '   </HEAD>'
	cMens += '   <BODY LINK="#0000ff" VLINK="#800080">'
	cMens += '     <TABLE BORDER CELLSPACING=2 CELLPADDING=4 WIDTH=800>'
	cMens += '       <TR><TD VALIGN="TOP">'
	cMens += '       <B><FONT FACE="Courier New" SIZE=4 COLOR="#000080" ><P ALIGN="CENTER"> '+cAssunto+' </P>'
	cMens += '       <P ALIGN="CENTER"></B></FONT></T0D>'
	cMens += '       </TR>'
	cMens += '     </TABLE>'
	cMens += '     <TABLE BORDER CELLSPACING=1 CELLPADDING=4 WIDTH=800>'
	cMens += '       <TR><TD WIDTH="15%" VALIGN="TOP">'
	cMens += '       <FONT FACE="Courier New" SIZE=1><B><P>Codigo</FONT></TD></B>'
	cMens += '       <TD WIDTH="50%" VALIGN="TOP">'
	cMens += '       <FONT FACE="Courier New" SIZE=1><B><P>Preço</FONT></TD></B>'
	cMens += '       <TD WIDTH="15%" VALIGN="TOP">'
	cMens += '       <FONT FACE="Courier New" SIZE=1><B><P>Quantidade</FONT></TD></B>'
	cMens += '       <TD WIDTH="10%" VALIGN="TOP">'
	cMens += '       <FONT FACE="Courier New" SIZE=1><B><P>Tipo</FONT></TD></B>'
	cMens += '       <TD WIDTH="10%" VALIGN="TOP">'
	cMens += '       <FONT FACE="Courier New" SIZE=1><B><P>Local</FONT></TD></B>'
	cMens += '       </TR>'
	For I = 1 to Len(aLista)
		cMens += '       <TR><TD WIDTH="15%" VALIGN="TOP">'
		cMens += '       <FONT FACE="Courier New" SIZE=1><P>'+aLista[I,1]+'</FONT></TD>'
		cMens += '       <TD WIDTH="50%" VALIGN="TOP">'
		cMens += '       <FONT FACE="Courier New" SIZE=1><P>'+Transform(Val(aLista[I,2]),"@E 999,999,999.9999")+'</FONT></TD>'		
		cMens += '       </TR>'
	Next I
	cMens += '     </TABLE>'
	cMens += '<br>'
	cMens += '     <P>&nbsp;</P>'
	cMens += '     <P> Nao responda esta mensagem, ela foi enviada automaticamento pelo Sistema.</P>'
	
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPasswrd RESULT lOk

	MAILAUTH(cAccount,cPasswrd)  //para autenticar envio do email     

	If lOk
		SEND MAIL FROM cAccount TO cEmail SUBJECT cAssunto BODY cMens  RESULT lEnv
		DISCONNECT SMTP SERVER RESULT lFim
	Else
		Alert("Não foi possível o envio do Email !!")
		lFim := .F.
	Endif

	IF !lEnv
		Alert("Não foi possível o envio do Email Erro (2) !!")
		lFim := .F.
	Endif
	
Endif*/
Return