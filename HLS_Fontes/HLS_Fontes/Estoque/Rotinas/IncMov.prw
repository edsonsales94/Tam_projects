//#Include "FiveWin.ch"
#Include "PROTHEUS.ch"

/*/{protheus.doc}IncMov
Correcao Manual de divergencias nos arquivos SD3, SD5 e SDB
@author HONDA LOCK
@since 
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCMOV    ºAutor  ³Microsiga           º Data ³  12/26/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Correcao Manual de divergencias nos arquivos SD3, SD5 e SDB º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Matheus Nog.³11-02-06³      ³Migracao 6.09 Codebase para 8.11 TOP      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IncMov()

Local oDlg
Local oBtn
Local cProd      := ''
Local cAlmox     := ''
Local nQuant     := 0
Local cLoteCtl   := ''
Local cLocaliz   := ''
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
	DEFINE MSDIALOG oDlg FROM 0, 0 TO 220, 295 TITLE "Inclui Movtos no SD3/SD5/SDB" PIXEL
	@ 20, 10 SAY   'Produto'                 	 OF oDlg PIXEL
	@ 20, 50 MSGET cProd F3 'SB1' PICTURE "@!" OF oDlg PIXEL
	@ 30, 10 SAY   'Almoxarifado'          	 OF oDlg PIXEL
	@ 30, 50 MSGET cAlmox 			PICTURE "@!" OF oDlg PIXEL VALID SeekProd(@cProd, @cAlmox, @oDlg)
	@ 40, 10 SAY   'Quantidade'              	 OF oDlg PIXEL
	@ 40, 50 MSGET nQuant         PICTURE PesqPictQt('D3_QUANT',15) OF oDlg PIXEL
	@ 50, 10 SAY   'Lote      '              	 OF oDlg PIXEL
	@ 50, 50 MSGET cLoteCtl			PICTURE "@!" OF oDlg PIXEL
	@ 60, 10 SAY   'Endereco  '              	 OF oDlg PIXEL
	@ 60, 50 MSGET cLocaliz			PICTURE "@!" OF oDlg PIXEL
	
	@ 80,10  BUTTON oBtn Prompt "SD3"   SIZE 20, 13 OF oDlg PIXEL Action (ProcSD3(cProd, cAlmox, nQuant, cLoteCtl, oDlg),oDlg:End())
	@ 80,35  BUTTON oBtn Prompt "SD5"   SIZE 20, 13 OF oDlg PIXEL Action (ProcSD5(cProd, cAlmox, nQuant, cLoteCtl, oDlg),oDlg:End())
	@ 80,60  BUTTON oBtn Prompt "SDB"   SIZE 20, 13 OF oDlg PIXEL Action (ProcSDB(cProd, cAlmox, nQuant, cLoteCtl, cLocaliz, oDlg),oDlg:End())
	@ 80,85  BUTTON oBtn Prompt "Sair"  SIZE 20, 13 OF oDlg PIXEL Action (lSai:=.F.,oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTERED
EndDo

Aviso('Atencao', 'Para que as movimentacoes digitadas sejam consideradas nos arquivos de Saldos deve-se executar a rotina de Saldo Atual (MATA300).', {'Ok'})

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCMOV    ºAutor  ³Microsiga           º Data ³  12/26/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SeekProd(cProd, cAlmox, oDlg)

Local lRet       := .T.

dbSelectArea('SB1')
dbSetOrder(1)
If !dbSeek(xFilial()+cProd+cAlmox)
	Aviso('IncMov', 'Produto nao encontrado no SB1!', {'Ok'})
	lRet := .F.
EndIf
oDlg:Refresh()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCMOV    ºAutor  ³Microsiga           º Data ³  12/26/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcSD3(cProd, cAlmox, nQuant, cLoteCtl, oDlg)

Local lRet       := .T.

RecLock('SD3',.T.)
	SD3->D3_FILIAL  := xFilial('SD3')
	SD3->D3_COD     := cProd
	SD3->D3_QUANT   := Abs(QtdComp(nQuant))
	SD3->D3_CF      := If(QtdComp(nQuant)<QtdComp(0),'RE0','DE0')
	SD3->D3_CHAVE   := If(QtdComp(nQuant)<QtdComp(0),'E0','E9')
	SD3->D3_LOCAL   := cAlmox
	SD3->D3_DOC     := 'ACERTO'
	SD3->D3_EMISSAO := dDataBase
	SD3->D3_UM      := SB1->B1_UM
	SD3->D3_GRUPO   := SB1->B1_GRUPO
	SD3->D3_NUMSEQ  := ProxNum()
	SD3->D3_QTSEGUM := ConvUm(cProd,Abs(QtdComp(nQuant)),0,2)
	SD3->D3_SEGUM   := SB1->B1_SEGUM
	SD3->D3_TM      := If(QtdComp(nQuant)<QtdComp(0),'999','499')
	SD3->D3_TIPO    := SB1->B1_TIPO
	SD3->D3_CONTA   := SB1->B1_CONTA
	SD3->D3_USUARIO := SubStr(cUsuario,7,15)
	SD3->D3_NUMLOTE := ''
	SD3->D3_LOTECTL := cLoteCtl
	SD3->D3_LOCALIZ := ''
	SD3->D3_IDENT   := ''
	SD3->D3_DTVALID := CtoD('  /  /  ')
MsUnLock()

/*
dbSelectArea('SB2')
dbSetOrder(1)
If !MsSeek(xFilial('SB2')+cProd+cAlmox, .F.)
	CriaSB2(cProd, cAlmox)
EndIf
RecLock('SB2', .F.)
	SB2->B2_QATU := If(QtdComp(nQuant)<QtdComp(0),(B2_QATU-Abs(nQuant)),(B2_QATU+Abs(nQuant)))
MsUnlock()

If B2_QATU < 0
	MsgAlert("B2 Negativo !!!","IncMov")
Else
*/
	MsgAlert("Movimento no SD3 com SUCESSO !!!","IncMov")
//EndIf
oDlg:Refresh()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCMOV    ºAutor  ³Microsiga           º Data ³  12/26/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcSD5(cProd, cAlmox, nQuant, cLoteCtl, oDlg)

Local lRet       := .T.
Local aGravaSD5  := {}
Local nY         := 1
Local cSeekSB8   := ''
Local cNumLote   := ''
Local nResta     := 0

//-- Encontra o Sub-Lote correto
dbSelectArea('SB8')
dbSetOrder(3) //-- B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
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
	If(!Empty(aGravaSD5[ny,05]),aGravaSD5[ny,05],NextLote(aGravaSD5[ny,02],"S")),;
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

/*
nResta := Abs(nQuant)
dbSelectArea('SB8')
dbSetOrder(3) //-- B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
If MsSeek((cSeekSB8:=xFilial('SB8')+cProd+cAlmox+cLoteCtl)+cNumLote, .F.)
	Do While !Eof() .And. cSeekSB8 == B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL .And. nResta>0
		If QtdComp(nQuant) < QtdComp(0)
			If B8_SALDO > 0
				nResta := (nResta-If(B8_SALDO>=Abs(nQuant),Abs(nQuant),B8_SALDO))
				RecLock('SB8', .F.)
					SB8->B8_SALDO := (B8_SALDO-If(B8_SALDO>=Abs(nQuant),Abs(nQuant),B8_SALDO))
				MsUnlock()
			EndIf
		Else
			nResta := (nResta-nQuant)
			RecLock('SB8', .F.)
				SB8->B8_SALDO := (B8_SALDO+nQuant)
			MsUnlock()
		EndIf
		dbSkip()
	EndDo
Else
	If QtdComp(nQuant) < QtdComp(0)
		MsgAlert("Registro no SB8 nao encontrado !!!","IncMov")
	Else
		MsgAlert("Sera criado um Registro no SB8...","IncMov")
		CriaLote('SD5',cProd,cAlmox,cLoteCtl,SD5->D5_NUMLOTE,'','','',If(QtdComp(nQuant)<QtdComp(0),'999','499'),'MI','',SD5->D5_NUMSEQ,SD5->D5_DOC,SD5->D5_SERIE,'',Abs(nQuant),ConvUm(cProd,Abs(QtdComp(nQuant)),0,2),dDataBase,CtoD('  /  /  '),.F.)
	EndIf
EndIf

If nResta < 0
	MsgAlert("B8 Negativo !!!","IncMov")
Else
*/
	MsgAlert("Movimento no SD5 com SUCESSO !!!","IncMov")
//EndIf

oDlg:Refresh()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCMOV    ºAutor  ³Microsiga           º Data ³  12/26/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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