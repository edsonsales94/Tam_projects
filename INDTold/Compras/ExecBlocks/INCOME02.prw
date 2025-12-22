#INCLUDE "Rwmake.ch"
#Include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCOME02  ºAutor  ³Ener Fredes         º Data ³  13/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que mostra uma tela para a digitação do Objetivo e  º±±
±±º          ³ Justificativa e gravação na tabela SZ6. São passados como  º±±
±±º          ³ parametros:                                                º±±
±±º          ³  * cTipo - Tipo do Documento sendo:                        º±±
±±º          ³                  1 - Pedido de Compra                      º±±
±±º          ³                  2 - Solicitação de Compra                 º±±
±±º          ³                  3 - Viagem                                º±±
±±º          ³                  4 - Documento fiscal ou Titulo            º±±
±±º          ³                  5 - Treinamento                           º±±
±±º          ³                  E - Justifica p/Fornecedor Excluivo Compraº±±
±±º          ³  * cPrefixo - Prefixo de Título ou a Séria do Doucmento    º±±
±±º          ³    de Entrada                                              º±±
±±º          ³  * cNum - Número do pedido ou SC ou Viagem ou Treinamento  º±±
±±º          ³    ou Documento Fiscal ou Título                           º±±
±±º          ³  * cFornece - Fornecedor da Nota Fiscal ou do Título       º±±
±±º          ³  * cLoja - Loja do Fornecedor da Nota Fiscal ou do Título  º±±
±±º          ³  * cItem - Item da Nota Fiscal                             º±±
±±º          ³  * lNovo - .T. para inclusão de Objetivo e Justificativa   º±±
±±º          ³    Nova ou .F. para Alteraçao.                             º±±
±±º          ³  * cChave - Chave de pesquisa para a localização das       º±±
±±º          ³    mensagem na tabela SZ6                                  º±±
±±º          ³  * lMostra - .T. para mostrar a tela de digitação das      º±±
±±º          ³    mensagens ou .F. para não mostrar                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS - PE GQREENTR - DOCUEMNTO DE ENTRADA               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function INCOME02(cTitulo,cTipo,cPrefixo,cNum,cFornece,cLoja,cItem,lMostra,lSalva,cVar,cJustific,lVisuliza,aCCAprv)
	Local cNomeFor, oBtn1, oBtn2, oDlg
	Local cAlias   := ALIAS()
	Local oFontCou := TFont():New("Courier New",9,15,.T.,.F.,5,.T.,5,.F.,.F.)
	Local lCCAprv  := aCCAprv[1]
	Local cAliasCC := aCCAprv[2]
	Local cCampoCC := aCCAprv[3]
	Local cVarCC   := aCCAprv[4]
	Local cCCAprv  := IF( !Empty(aCCAprv[5]) , aCCAprv[5], Space(TamSX3("C1_CCAPRV")[1]))
	Local nOpcA    := If( lMostra , 0, 1)
	
	If !Empty(cFornece)
		cNomeFor := Posicione("SA2",1,xFilial("SA2")+cFornece+cLoja,"A2_NOME")
	EndIf
	
	If !Empty(cVar)
		cJustific := GetGlbValue(cVar)
	EndIf
	
	If !Empty(cVarCC)
		cCCAprv := GetGlbValue(cVarCC)
	EndIf
	
	cCCAprv := Padr(cCCAprv,9)
	
	If lMostra
		@ 116,090 To 616,830 Dialog oDlg Title cTitulo
		
		@ 15,006 SAY "Numero"      PIXEL OF oDlg
		@ 15,036 GET cNum          PIXEL OF oDlg WHEN .F.
		If !Empty(cFornece)
			@ 30,006 SAY "Fornecedor"  PIXEL OF oDlg
			@ 30,036 GET cFornece      PIXEL OF oDlg WHEN .F.
			@ 30,076 GET cLoja         PIXEL OF oDlg WHEN .F.
			@ 30,106 SAY "Nome"        PIXEL OF oDlg
			@ 30,136 GET cNomeFor      PIXEL OF oDlg WHEN .F.
		EndIf
		If lCCAprv
			@ 45,006 SAY "C.Custo Aprovador:"    PIXEL OF oDlg
			@ 45,096 MSGET  cCCAprv F3 "CTTCOM"  PIXEL OF oDlg
		EndIf
		
		@ 060,002 To 204,318 PROMPT "Descrição Detalhada" PIXEL OF oDlg
		@ 069,006 SAY "Justificativa" PIXEL OF oDlg
		@ 079,006 GET oJustific       VAR cJustific SIZE 308,90 PIXEL OF oDlg MEMO WHEN lVisuliza
		oJustific:oFont := oFontCou
		
		oBtn1  := TButton():New( 240,008, '&Confirmar' , oDlg,;
					{||nOpcA := If( lSalva .And. fConfirma(cVar,cJustific,lCCAprv,cVarCC,cCCAprv) , 1, 0),;
						If( nOpcA == 1 , oDlg:End(), ) }, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn2  := TButton():New( 240,053, 'C&ancelar'  , oDlg, {|| oDlg:End() }, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
		
		Activate Dialog oDlg Centered
	Else
		nOpcA := 1
	EndIf
	
	If nOpcA == 1
		fSalva(cTipo,cPrefixo,cNum,cFornece,cLoja,"",cJustific,lCCAprv,cAliasCC,cCampoCC,cCCAprv,cVarCC,lMostra)
	Endif
	
	DbSelectArea(cAlias)
Return .T.

Static function fConfirma(cVar,cJustific,lCCAprv,cVarCC,cCCAprv)
	
	If Empty(cJustific)
		Alert("É obrigatório o preenchimento da Justificativa")
		Return .F.
	EndIf
	
	PutGlbValue(cVar,cJustific)
	
	If lCCAprv
		If Empty(cCCAprv)
			Alert("É obrigatório o preenchimento do Centro de Custo Aprovador")
			Return .F.
		EndIf
		PutGlbValue(cVarCC,cCCAprv)
	EndIf
	
Return .T.

Static function fSalva(cTipo,cPrefixo,cNum,cFornece,cLoja,cItem,cJustific,lCCAprv,cAliasCC,cCampoCC,cCCAprv,cVarCC,lMostra)
	Local nPosCCAprv := 	0
	Local x
	
	If Empty(cJustific)
		Alert("É obrigatório o preenchimento da Justificativa")
		Return .F.
	EndIf
	
	If lCCAprv
		If Empty(cCCAprv)
			Alert("É obrigatório o preenchimento do Centro de Custo Aprovador")
			Return .F.
		EndIf
	EndIf
	
	dbSelectArea("SZ6")
	dbSetOrder(1)
	
	If dbSeek(xFilial("SZ6")+cTipo+Padr(cNum,9)+cPrefixo+cFornece+cLoja)
		RecLock("SZ6",.F.)
	Else
		RecLock("SZ6",.T.)
	Endif
	SZ6->Z6_FILIAL  := xFilial("SZ6")
	SZ6->Z6_TIPO    := cTipo
	SZ6->Z6_NUM     := cNum
	SZ6->Z6_PREFIXO := cPrefixo
	SZ6->Z6_FORNECE := cFornece
	SZ6->Z6_LOJA    := cLoja
	SZ6->Z6_ITEM    := cItem
	SZ6->Z6_JUSTIFI := cJustific
	MsUnLock()
	
	nPosCCAprv := aScan(aHeader,{|x| Trim(x[2]) == Alltrim('C1_CCAPRV')})
	PutGlbValue(cVarCC,cCCAprv)
	if (nPosCCAprv > 0)
		For x := 1 to Len(aCols)
			aCols[x,nPosCCAprv] := cCCAprv
		next
	EndIf
	
Return .T.
