#include "rwmake.ch"

User Function SF2460I()

//*************************************************************************
//³* Guarda Ambiente Original
//*************************************************************************
_cAlias := ALIAS()
_nRecno := RECNO()
_nOrdem := INDEXORD()

if SM0->M0_CODIGO == "03"    // Manaus

	Proc_AM()
	
	IF ( SF2->F2_ESPECIE == "SPED " .AND. SF2->F2_EST == "EX" )
		///
		///Exportacao: evitar digitacao na rotina de Complemento Fiscal (Saida Manual - Fiscal) - Carlos - 13/05/15
		///Conforme D. Elizabete, somente as informacoes gravadas abaixo é necessaria pra nao dá erro na transmissao da NF-e.
		///Por enquanto, somente para MAO. Pendente de verificar com a Filial SP.
		///
		
		////Grava Informacoes de Complemento
		////
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.)	
		DO WHILE !EOF().AND.SD2->D2_FILIAL==xFilial("SD2").AND.SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)==SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
			RecLock("CDL",.T.)
			CDL->CDL_FILIAL   := xFilial("CDL")
			CDL->CDL_DOC      := SF2->F2_DOC
			CDL->CDL_SERIE    := SF2->F2_SERIE
			CDL->CDL_ESPEC    := SF2->F2_ESPECIE
			CDL->CDL_CLIENT   := SF2->F2_CLIENTE
			CDL->CDL_LOJA     := SF2->F2_LOJA
			CDL->CDL_ITEMNF   := SD2->D2_ITEM
			CDL->CDL_PRODNF   := SD2->D2_COD
			CDL->CDL_EMIEXP   := SF2->F2_EMISSAO
			CDL->CDL_INDDOC   := "0"
			CDL->CDL_NATEXP   := "0"
			CDL->CDL_ESPEXP   := "CA"
			CDL->CDL_UFEMB    := IIF(M->cNumEmp=="0301", "AM" , "SP" )
			CDL->CDL_LOCEMB   := IIF(M->cNumEmp=="0301", "MANAUS" , "SAO PAULO" )
			CDL->CDL_LOCDES   := IIF(M->cNumEmp=="0301", "MANAUS" , "SAO PAULO" )
			MsUnlock()                
			
//			dbSelectArea( "ZX1" )
			RecLock("ZX1",.T.)
			ZX1_FILIAL := xFilial()
			ZX1_PEDIDO := SD2->D2_PEDIDO
			ZX1_ITEM   := SD2->D2_ITEMPV
			ZX1_PRODUT := SD2->D2_COD
 //			ZX1_DTNEW  := stod(TMP->C6_ENTREG)
 //			ZX1_DTOLD  := stod(TMP->C6_X_DT2)
			ZX1_HORA   := Time()
			ZX1_DTBASE := dDatabase
			ZX1_USUARI := SUBST(CUSUARIO,7,15)
			ZX1_ORIGEM := "FATURAMENTO"
//			ZX1_EMISSA := stod(TMP->C6_X_EMIS)
			ZX1_CLIENT := SD2->D2_CLIENTE
			ZX1_LOJA   := SD2->D2_LOJA
			ZX1_NOTA   := SD2->D2_DOC
			ZX1_DTFAT  := SD2->D2_EMISSAO
			ZX1_QUANT  := SD2->D2_QUANT
			MsUnLock()
			dbSelectArea("SD2")
			dbSkip()
		ENDDO     
		
	    
	ENDIF
	
elseIf SM0->M0_CODIGO == "01"
	Proc_SP()                
elseIf SM0->M0_CODIGO == "04"
	Proc_10()
endif


//************************************************************************************
//*³ Retorna Ambiente Inicial
//************************************************************************************

dbSelectArea(_cAlias)
dbSetOrder(_nOrdem)
dbGoto(_nRecno)

Static Function Proc_AM()

_aCodKit := {}
dbSelectArea("SD2")
dbSetOrder(3)
_chave:= xFilial() + SF2->F2_DOC + SF2->F2_SERIE
if dbSeek(xFilial() + SF2->F2_DOC + SF2->F2_SERIE )
	While !Eof() .and. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE == _chave
		
		if SD2->D2_TES != "703"
			dbskip()
			loop
		endif

		Do Case                                //Implementado para identificar a origem da movimentação - Almoxarifado by Rogerio		
			Case SD2->D2_LOCAL == "02"
				_cTxt   := "TRANSF.ALMOXARIFADO 02"
			Case SD2->D2_LOCAL == "04"
				_cTxt   := "TRANSF.ALMOXARIFADO 04"
			Case SD2->D2_LOCAL == "05"
				_cTxt   := "TRANSF.ALMOXARIFADO 05"
			Case SD2->D2_LOCAL == "06"
				_cTxt   := "TRANSF.ALMOXARIFADO 06"
		EndCase

		
		_cTm        := "030"   // devolucao
		_cProd      := SD2->D2_COD
		_cLocal     := "03"
		_nQuant     := SD2->D2_QUANT
		_cUM        := SD2->D2_UM
		_dData      := SD2->D2_EMISSAO
		lMsErroAuto := .F.
		aVetor:={ {"D3_FILIAL"  , "01"    , NIL},;
		{"D3_TM"      , _cTm    , NIL},;
		{"D3_COD"     , _cProd  , NIL},;
		{"D3_UM"      , _cUM    , NIL},;
		{"D3_LOCAL"   , _cLocal , NIL},;
		{"D3_EMISSAO" , _dData  , NIL},;
		{"D3_QUANT"   , _nQuant , NIL},;
		{"D3_X_OBS"   , _cTxt   , NIL}}

		MSExecAuto({|x,y| mata240(x,y)},aVetor,3) //Inclusao

		If lMsErroAuto
			Alert("Problemas na gravacao da movimentacao de estoque. Notifique o departamento de informatica.")
		endif
		
		dbSelectArea("SD2")
		dbSkip()
		
	EndDo
EndIf

RETURN

Static Function Proc_SP()

// Numero do PDV que efetuou a venda
If SF2->(FieldPos(F2_PDV)) > 0
	cNumPdv:= CallMp20Fi("|35|14|")
	Reclock("SF2",.F.)
	Replace F2_PDV With cNumPdv
	MsUnLock()
EndIf

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Alteracoes Sofridas - Especifico Coel Controles Eletricos Ltda            *
* Autor: Ricardo Correa de Souza                                            *
* Motivo: Gravar "1" no campo E1_PARCELA                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Areas de Trabalho Utilizadas                                              *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SE1")
_OrdE1:=IndexOrd()
_RecE1:=Recno()
DbSetOrder(1)

DbSelectArea("SD2")
_OrdD2:=IndexOrd()
_RecD2:=Recno()
DbSetOrder(3)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento das Informacoes                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cNaturez:= ""
_cTitulo := SE1->E1_NUM

If xFilial() == "01"
	_cPref := "SPO"
Else
	_cPref := "SRE"
EndIf

DbSelectArea("SD2")
DbSeek(xFilial("SD2")+_cTitulo)
While !Eof() .And. SD2->D2_DOC == _cTitulo
	If Alltrim(SD2->D2_COD) == "10000000"
		_cNaturez:= "1102"
	EndIf
	DbSkip()
EndDo

DbSelectArea("SE1")
DbSeek(xFilial("SE1")+_cPref+_cTitulo)
While !Eof() .And. SE1->E1_PREFIXO == _cPref .And. SE1->E1_NUM == _cTitulo
	If !Empty(_cNaturez)
		RecLock("SE1",.F.)
		SE1->E1_NATUREZ:= _cNaturez
		MsUnLock()
	EndIf
	DbSkip()
EndDo

dbCommit()

DbSelectArea("SD2")
DbSetOrder(_OrdD2)
DbGoTo(_RecD2)

DbSelectArea("SE1")
DbSetOrder(_OrdE1)
DbGoTo(_RecE1)

Return(nil)   

Static Function Proc_10()

Local _aArea:= GetArea() , _aAreaSD2

dbSelectARea("SD2")
_aAreaSD2 := GetArea()
dbSetOrder(3)
dbSeek( xFilial() + SF2->F2_DOC + SF2->F2_SERIE )
While D2_FILIAL + D2_DOC + D2_SERIE == xFilial() + SF2->F2_DOC + SF2->F2_SERIE .and. !eof()

      reclock("SZM",.T.)
      SZM->ZM_FILIAL := xFilial()
      SZM->ZM_TM     := "602"
      SZM->ZM_COD    := SD2->D2_COD
      SZM->ZM_LOCAL  := "01"
      SZM->ZM_DATA   := SD2->D2_EMISSAO
      SZM->ZM_QUANT  := SD2->D2_QUANT
      SZM->ZM_DOCSERI:= SD2->D2_DOC + SD2->D2_SERIE
      SZM->ZM_CLIFORN:= SD2->D2_CLIENTE + SD2->D2_LOJA
      SZM->ZM_NFES   := "S"
      msunlock()

      dbSelectARea("SD2")
      dbSkip()
	
Enddo

RestArea(_aAreaSD2)

RestArea(_aArea)     

Return(Nil)
*---------------------------------------------------------------------------*
* Fim                                                                       *
*---------------------------------------------------------------------------*


