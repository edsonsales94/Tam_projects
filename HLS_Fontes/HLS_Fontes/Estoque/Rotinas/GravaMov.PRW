#INCLUDE "protheus.CH"

/*/{protheus.doc}GravaMov
Programa utilizado para correcao de divergencia entre saldos das tabelas SB2, Sb8 e/ou SBF.     
@author Joao Gustavo Orsi
@since 21/10/10
/*/

/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矷NCMOV    篈utor  矹oao Gustavo Orsi   ?Data ? 21/10/10   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ? Programa utilizado para corre玢o de diverg阯cia entre     罕?
北?         ? saldos das tabelas SB2, Sb8 e/ou SBF.                     罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?mp811 mp10.13                                              罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?/

//# include "FiveWin.ch"

User Function GravaMov()

Local oDlg
Local oBtn
Local cProd      := ''
Local cAlmox     := ''
Local nQuant     := 0
Local cLoteCtl   := ''
Local cLocaliz   := ''
Local cOp		 := ''
Local dEmissao   := Date()
Local lSai       := .T.

Aviso('Aviso',;
' Este programa deve ser utilizado para efetuar a correcao manual de divergencias nos arquivos SD3, SD5 e SDB, incluindo movimentacoes somente no arquivo necessario.'+chr(13)+chr(10)+;
'Obs.: As movimentacoes serao geradas com Data igual a Data Base'+chr(13)+chr(10)+;
'         Quantidades Positivas geram Devolucoes;'+chr(13)+chr(10)+;
'         Quantidades Negativas geram Requisicoes;'+chr(13)+chr(10)+;
'         Todas as movimentacoes possuem documento = "ACERTO".', {'Ok'})
If Aviso('Atencao', 'Deseja incluir movimentacoes manualmente?', {'Sim', 'Nao'}) == 2
	Return Nil
EndIf

Do While lSai
	cProd    := CriaVar('D3_COD')
	cAlmox   := CriaVar('D3_LOCAL')
	nQuant   := CriaVar('D3_QUANT')
	cLoteCtl := CriaVar('D3_LOTECTL')
	cLocaliz := CriaVar('D3_LOCALIZ')
	cOp		 := CriaVar('D3_OP')
	dEmissao := CriaVar('D3_EMISSAO')
	
	DEFINE MSDIALOG oDlg FROM 0, 0 TO 350, 280 TITLE "Inclui Movtos no SD3/SD5/SDB" PIXEL
	
	@ 10, 10 SAY   "Para fazer uma REQUISICAO basta utilizar" OF oDlg PIXEL
	@ 25, 10 SAY   "o sinal '-'(menos) no campo QUANTIDADE." OF oDlg PIXEL
	@ 40, 10 SAY   'Produto' OF oDlg PIXEL
	@ 40, 50 MSGET cProd F3 'SB1' PICTURE "@!" OF oDlg PIXEL
	@ 55, 10 SAY   'Almoxarifado' OF oDlg PIXEL
	@ 55, 50 MSGET cAlmox PICTURE "@!" OF oDlg PIXEL VALID SeekProd(@cProd, @cAlmox, @oDlg)
	@ 70, 10 SAY   'Quantidade' OF oDlg PIXEL
	@ 70, 50 MSGET nQuant PICTURE PesqPictQt('D3_QUANT',15) OF oDlg PIXEL
	@ 85, 10 SAY   'Lote      ' OF oDlg PIXEL
	@ 85, 50 MSGET cLoteCtl	PICTURE "@!" OF oDlg PIXEL
	@ 100, 10 SAY   'Endereco  ' OF oDlg PIXEL
	@ 100, 50 MSGET cLocaliz F3 'SBE' PICTURE "@!" OF oDlg PIXEL
	@ 115, 10 SAY   'OP  ' OF oDlg PIXEL
	@ 115, 50 MSGET cOp F3 'SC2' PICTURE "@!" OF oDlg PIXEL
	@ 130, 10 SAY   'Emissao  ' OF oDlg PIXEL
	@ 130, 50 MSGET dEmissao PICTURE "  /  /  " OF oDlg PIXEL
	
	@ 150,10  BUTTON oBtn Prompt "SD3"   SIZE 20, 13 OF oDlg PIXEL Action (ProcSD3(cProd, cAlmox, nQuant, cLoteCtl, cOp, dEmissao, oDlg),oDlg:End())
	@ 150,35  BUTTON oBtn Prompt "SD5"   SIZE 20, 13 OF oDlg PIXEL Action (ProcSD5(cProd, cAlmox, nQuant, cLoteCtl, oDlg),oDlg:End())
	@ 150,60  BUTTON oBtn Prompt "SDB"   SIZE 20, 13 OF oDlg PIXEL Action (ProcSDB(cProd, cAlmox, nQuant, cLoteCtl, cLocaliz, oDlg),oDlg:End())
	@ 150,85  BUTTON oBtn Prompt "Sair"  SIZE 20, 13 OF oDlg PIXEL Action (lSai:=.F.,oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTERED
EndDo

Aviso('Atencao', 'Para que as movimentacoes digitadas sejam consideradas nos arquivos de Saldos deve-se executar a rotina de Saldo Atual (MATA300).', {'Ok'})

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篋esc.     ? Chama acerto do SALDO ATUAL e depois o REFAZ ACUMULADOS.  罕?
北?         ? Por fim executa o relat髍io DIFSALDO.	                  罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/

If Aviso('ACERTA SALDO','Sera NECESSARIO executar as Rotinas de "Acerto de Saldos" e "Refaz Acumulados" . Deseja executa-las agora?',{'Sim','Nao'})==1
	MATA300()
	MATA215()
	U_DIFSALDO()
EndIf

Return Nil

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篋esc.     ?Verifica se o produto existe no SB1.						  罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/

Static Function SeekProd(cProd, cAlmox, oDlg)

Local lRet       := .T.

dbSelectArea('SB1')
dbSetOrder(1)
If !dbSeek(xFilial()+cProd+cAlmox)
	Aviso('Saldo', 'Produto nao encontrado no SB1!', {'Ok'})
	lRet := .F.
EndIf
oDlg:Refresh()

Return(lRet)

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篋esc.     ?Grava movimenta玢o interna para acertar o SB2.			  罕?
北?         ?Para produtos que n鉶 controlam lote e/ou endere鏾.        罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/

Static Function ProcSD3(cProd, cAlmox, nQuant, cLoteCtl, cOp, dEmissao, oDlg)

Local lRet       := .T.
Local nSdAtu

SB2->(DbSetOrder(1))
SB2->(DbSeek(xFilial("SB1")+cProd+cAlmox))

nSdAtu := SB2->B2_QATU
If nQuant<0 .And. nSdAtu < Abs(nQuant)
	Alert("NAO HA SALDO! SALDO ATUAL: " + cValToChar(nSdAtu) + " E A NECESSIDADE :" + cValToChar(Abs(nQuant)) + "!")
	Return
EndIf

RecLock('SD3',.T.)
Replace D3_FILIAL  With xFilial('SD3')
Replace D3_COD     With cProd
Replace D3_QUANT   With Abs(QtdComp(nQuant))
Replace D3_CF      With If(QtdComp(nQuant)<QtdComp(0),'RE0','DE0')
Replace D3_CHAVE   With If(QtdComp(nQuant)<QtdComp(0),'E0','E9')
Replace D3_LOCAL   With cAlmox
Replace D3_DOC     With 'ACERTO'
Replace D3_EMISSAO With dEmissao
Replace D3_OP 	   With cOp
Replace D3_UM      With SB1->B1_UM
Replace D3_GRUPO   With SB1->B1_GRUPO
Replace D3_CUSTO1  With SB2->B2_CM1*Abs(nQuant)
Replace D3_NUMSEQ  With ProxNum()
Replace D3_QTSEGUM With ConvUm(cProd,Abs(QtdComp(nQuant)),0,2)
Replace D3_SEGUM   With SB1->B1_SEGUM
Replace D3_TM      With If(QtdComp(nQuant)<QtdComp(0),'999','499')
Replace D3_TIPO    With SB1->B1_TIPO
Replace D3_CONTA   With SB1->B1_CONTA
Replace D3_USUARIO With SubStr(cUsuario,7,15)
Replace D3_NUMLOTE With ''
Replace D3_LOTECTL With cLoteCtl
Replace D3_LOCALIZ With ''
Replace D3_IDENT   With ''
Replace D3_DTVALID With CtoD('  /  /  ')
MsUnLock()

MsgAlert("Movimento no SD3 com SUCESSO !!!","saldo")

oDlg:Refresh()

Return(lRet)

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北篋esc.     ? Grava movimenta玢o interna para acertar o SB8.            罕?
北?         ? Para produtos que controlam lote/sub-lote.	              罕?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/

Static Function ProcSD5(cProd, cAlmox, nQuant, cLoteCtl, oDlg)

Local lRet       := .T.
Local aGravaSD5  := {}
Local nY         := 1
Local cSeekSB8   := ''
Local cNumLote   := ''
Local nResta     := 0

dbSelectArea('SB8')
dbSetOrder(3)
If MsSeek(cSeekSB8:=xFilial('SB8')+cProd+cAlmox+cLoteCtl, .F.)
	Do While !Eof() .And. cSeekSB8 == B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL
		If QtdComp(nQuant) < QtdComp(0)
			If QtdComp(B8_SALDO) >= QtdComp(Abs(nQuant))
				cNumLote := B8_NUMLOTE
				If QtdComp(B8_SALDO) == QtdComp(Abs(nQuant))
					Exit
				EndIf
			EndIf
		Else
			cNumLote := B8_NUMLOTE
			Exit
		EndIf
		dbSkip()
	EndDo
EndIf

aAdd(aGravaSD5, {'SDB',;
cProd,;
cAlmox,;
cLoteCtl,;
cNumLote,;
ProxNum(),;
'ACERTO',;
'UNI',;
'',;
If(QtdComp(nQuant)<QtdComp(0),'999','499'),;
	'',;
	'',;
	'',;
	Abs(QtdComp(nQuant)),;
	ConvUm(cProd,Abs(QtdComp(nQuant)),0,2),;
	dDataBase,;
	dDataBase+SB1->B1_PRVALID})
	
	GravaSD5(aGravaSD5[nY,01],;
	aGravaSD5[nY,02],;
	aGravaSD5[nY,03],;
	aGravaSD5[nY,04],;
	CriaVar('D5_NUMLOTE', If(SuperGetMV('MV_LOTEUNI', .F., .F.), .F., Nil)),;
	aGravaSD5[nY,06],;
	aGravaSD5[nY,07],;
	aGravaSD5[nY,08],;
	aGravaSD5[nY,09],;
	aGravaSD5[nY,10],;
	aGravaSD5[nY,11],;
	aGravaSD5[nY,12],;
	aGravaSD5[nY,13],;
	aGravaSD5[nY,14],;
	aGravaSD5[nY,15],;
	aGravaSD5[nY,16],;
	aGravaSD5[nY,17])
	MsgAlert("Movimento no SD5 com SUCESSO !!!","IncMov")
	
	oDlg:Refresh()
	
	Return(lRet)
	
	/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
	北篋esc.     ? Grava movimenta玢o interna para acertar o SBF.            罕?
	北?         ? Para produtos que controlam endere鏾.                     罕?
	北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
	哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/
	
	Static Function ProcSDB(cProd, cAlmox, nQuant, cLoteCtl, cLocaliz, oDlg)
	
	Local lRet       := .T.
	Local aCriaSDB   := {}
	Local nX         := 1
	
	aAdd(aCriaSDB,{cProd,;
	cAlmox,;
	Abs(QtdComp(nQuant)),;
	cLocaliz,;
	'',;
	'ACERTO',;
	'UNI',;
	'',;
	'',;
	'',;
	'SDB',;
	dDataBase,;
	cLoteCtl,;
	'',;
	ProxNum(),;
	If(QtdComp(nQuant)<QtdComp(0),'999','499'),;
		'M',;
		StrZero(1,Len(SDB->DB_ITEM)),;
		.F.,;
		0,;
		0})
		
		CriaSDB( aCriaSDB[nX,01],;
		aCriaSDB[nX,02],;
		aCriaSDB[nX,03],;
		aCriaSDB[nX,04],;
		aCriaSDB[nX,05],;
		aCriaSDB[nX,06],;
		aCriaSDB[nX,07],;
		aCriaSDB[nX,08],;
		aCriaSDB[nX,09],;
		aCriaSDB[nX,10],;
		aCriaSDB[nX,11],;
		aCriaSDB[nX,12],;
		aCriaSDB[nX,13],;
		aCriaSDB[nX,14],;
		aCriaSDB[nX,15],;
		aCriaSDB[nX,16],;
		aCriaSDB[nX,17],;
		aCriaSDB[nX,18],;
		aCriaSDB[nX,19],;
		aCriaSDB[nX,20],;
		aCriaSDB[nX,21])
		
		MsgAlert("Movimento no SDB com SUCESSO !!!","IncMov")
		oDlg:Refresh()
		
		Return(lRet)
