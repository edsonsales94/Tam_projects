#include 'totvs.ch'

User Function ConfCli1()

Local cAliasTop  := "SE1"
Local cCliente   := M->CJ_CLIENTE
Local cLoja	     := M->CJ_LOJA
Local dData	     := dtos(dDataBase-7)// 7 liberado 7 dias apos o vencimento
Local lInad      :=.F.
Local lPeriodo   :=.F.
Local nRec	     := 0


_Export :=POSICIONE("SA1",1,XFILIAL("SA1")+cCliente,"A1_EST")     // Deixar passar clientes exportacao

If cCliente $ "000411/003048/007566/012968/015973" // 01/12/17 - LUIZA SOLICITOU  METALFRIO/ESMALTEC/FRICOM/IMBERA/SAYOS
	Return(.T.)
EndIf    

If _Export == "EX"
	Return(.T.)
Else
	
	dbSelectArea("SE1")
	cAliasTop := GetNextAlias()
	
	//select * from SE1030 WHERE E1_CLIENTE ='007485' AND E1_LOJA ='01'AND E1_PREFIXO IN ('3','4') AND E1_SALDO >0 AND E1_VENCREA < 20140606
	cQuery := "SELECT * FROM "+RetSqlName("SE1")+ " SE1 "
	cQuery += "WHERE SE1.E1_FILIAL='"+xFilial("SE1")+"'  AND SE1.E1_CLIENTE ='"+cCliente+"' AND SE1.D_E_L_E_T_=' ' AND "
	cQuery += "SE1.E1_SALDO > 0 AND SE1.E1_TIPO NOT IN ('NCC','RA') AND  SE1.E1_VENCREA <" +dData
	cQuery := ChangeQuery(cQuery)
	// AND SE1.E1_LOJA = '"+cLoja+"' VALIDA LOJA RETIRADO aNDRษ 11/06/14
	IF Select("QRYSE1") > 0
		QRYSE1->( DbCloseArea())
	ENDIF
	
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"QRYSE1", .F., .T.)
	COUNT TO nRec
	
	IF nRec > 0
		lInad    :=.F.
		nAviso := Aviso("Aten็ใo", "Cliente inadiplente pedido bloqueado"+CRLF+;
		"Para prosseguir, ้ necessario a libera็ใo do aprovador.",{"Continuar","Cancelar"},3)
		If nAviso <> 1
			Return(lInad)
		Else
			lInad := TelaLibera()
			
		Endif
	Else
		lInad    :=.T.
	Endif
	
	Return (lInad)
	
EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ TelaLibera      บAutorณ Andre Rodrigues            บ Data ณ 29/09/2009 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Tela para confirmacao de senha de usuario. Usado para aprovacao de     บฑฑ
ฑฑบ         ณ Pedido de Vendas.                                                      บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam    ณ ExpC1 = Nome do Usuario ( parametro passado por referencia )           บฑฑ
ฑฑบ         ณ         para carregar o Nome do usuario.                               บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe  ณ TelaLibera( ExpC1 )                                                    บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Exclusivo Magnum                                                       บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelaLibera( _cxUsrAut )
Local _lRet		:= .F.
//Local _aUsers	:= {}
Local _aUsers 	:= RetUsers()
Local _aCboUsr	:= {}
Local _cCboUsr	:= ""
Local _cSenha	:= Space(15)
Local _oFont 	:= TFont():New("Arial",08,16,,.T.,,,,.T.)
Local _oDlg, i

If Len( _aUsers ) == 0
	Alert( "Nenhum usuแrio foi autorizado a efetuar a libera็ใo!!!" )
	Return( _lRet )
Endif

For i := 1 to Len( _aUsers )
	aadd( _aCboUsr, _aUsers[ i ]  )
Next
aSort( _aCboUsr,,, { |x, y| Upper(Substring( x,  8, Len(x)-8 )) < Upper(Substring( y,  8, Len(y)-8 )) })

Define MsDialog _oDlg Title "Libera็ใo do Cliente" From 000, 000 to 220, 240 of oMainWnd Pixel

@ 015, 015 Say _oSayUsr PROMPT "Usuแrio: " Of _oDlg Pixel COLOR CLR_BLACK Size 050,16 FONT _oFont Pixel
@ 027, 015 MSCOMBOBOX _oCboUsr VAR _cCboUsr ITEMS _aCboUsr SIZE 085,40 OF _oDlg Pixel

@ 040, 015 Say _oLblSenha PROMPT "Senha:" Of _oDlg Pixel COLOR CLR_BLACK  FONT _oFont Size  060,008
@ 052, 015 MsGet _oGetSenha Var _cSenha Size 030,008 of _oDlg PASSWORD Pixel
@ 080, 015 Button "Confirmar"  Size 30,12 Action ( _lRet := ValidaSenha( Left( _cCboUsr, 6 ), _cSenha ), _cxUsrAut := Left( _cCboUsr, 6 ), If( _lRet, _oDlg:End(), Nil ) ) of _oDlg Pixel
@ 080, 060 Button "Cancelar"   Size 30,12 Action ( _oDlg:End() ) of _oDlg Pixel

Activate MsDialog _oDlg Centered

Return( _lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ ValidaSenha     บAutorณ Andre Rodrigues            บ Data ณ 29/09/2009 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Chama funcao para validacao de senha ( microsiga ) e caso a senha      บฑฑ
ฑฑบ         ณ estiver incorreto, emite aviso.                                        บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam    ณ ExpC1 = Codigo do Usuario (ID) no Microsiga                            บฑฑ
ฑฑบ         ณ ExpC2 = Senha a ser validada                                           บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe  ณ ValidaSenha( ExpC1, ExpC2 )                                            บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Exclusivo Magnum                                                       บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidaSenha( _cCodUsu, _cSenha )
Local _lRet 	:= .T.
Local _cUsrAut	:= GetNewPar( "MV_X_USRAU", "000000" ) /* String com os Usuarios que poderao autorizar */

If !( Alltrim( _cCodUsu ) $ Alltrim( _cUsrAut ) )
	_lRet := .F.
	Alert( "Usuแrio nใo autorizado!" )
Endif

If !ChecaSenha( _cCodUsu,_cSenha )
	Alert( "Senha Invalida!!!" )
	_lRet := .F.
Endif

Return( _lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ ChecaSenha      บAutorณ Andre Rodrigues            บ Data ณ 29/09/2009 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Retorna .T. se a senha eh valida no cadastro de usuarios do Microsiga. บฑฑ
ฑฑบ         ณ                                                                        บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam    ณ ExpC1 = Codigo do Usuario (ID) no Microsiga                            บฑฑ
ฑฑบ         ณ ExpC2 = Senha a ser validada                                           บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe  ณ ChecaSenha( ExpC1, ExpC2 )                                             บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Exclusivo Magnum                                                       บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ChecaSenha( _cCodUsu,_cSenha )
Local _aArea	:= GetArea()
Local _lRet 	:= .F.

PswOrder(1)
If PswSeek( _cCodUsu, .T. )
	_lRet := PswName( _cSenha )
EndIf

RestArea( _aArea )

Return ( _lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ RetUsers        บAutorณ Andre Rodrigues            บ Data ณ 30/09/2009 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Retorna o ID+Nome de Usuario que estao no parametro 'MV_X_USRAU'       บฑฑ
ฑฑบ         ณ OBS: Para preencher o parametro 'MV_X_USRAU' informar os ID's          บฑฑ
ฑฑบ         ณ separados por ',' ou '/' ou ';'.                                       บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Exclusivo Magnum                                                       บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetUsers()
Local _cUsers	:= GetNewPar( "MV_X_USRAU", "000000" )
Local _aUsers 	:= {}
Local _aRet		:= {}
Local _cQuebra	:= ","
Local _nx
If "," $ _cUsers
	_cQuebra := ","
Elseif "/" $ _cUsers
	_cQuebra := "/"
Elseif ";" $ _cUsers
	_cQuebra := ";"
Endif

_aUsers := StrToKarr( Alltrim(_cUsers),_cQuebra)

If Len( _aUsers ) > 0
	For _nx := 1 to Len( _aUsers )
		aadd( _aRet, _aUsers[ _nx ] + "-" + UsrRetNome( _aUsers[ _nx ] ) )
	Next
Endif

Return( _aRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ UsrRetMail      บAutorณ Andre Rodrigues            บ Data ณ 30/09/2009 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Dado um ID de usuario microsiga, a funcao retorna o nome do mesmo      บฑฑ
ฑฑบ         ณ                                                                        บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Exclusivo Magnum                                                       บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function UsrRetNome(cCodUser)
Local cAlias := Alias()
Local cSavOrd := IndexOrd()
Local cNome

PswOrder(1)
If	!Empty(cCodUser) .And. PswSeek(cCodUser)
	cNome := PswRet(1)[1][4]
Else
	cNome := SPACE(15)
EndIf

dbSelectArea(cAlias)
dbSetOrder(cSavOrd)

Return(cNome)
