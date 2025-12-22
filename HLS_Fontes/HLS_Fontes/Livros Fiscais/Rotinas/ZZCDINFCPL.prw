#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} ZZCDINFCP

Rotina responsável por importar registros na tabela CD5.

@type function
@author Guilherme Haddad Gouveia
@since 20/04/2011

/*/

User Function ZZCDINFCP () 

/**
* Função		: ZZCDINFCP
* Autor			: Guilherme Haddad Gouveia
* Data			: 20/04/2011
* Descrição		: Rotina responsável por importar registros na tabela CD5.
*
* Parametros	:


* Retorno		: .T.
*
* Observações   :
*
*/       
                                          
Local   aAlias    := GetArea()
Local   aArea	  := Lj7GetArea({"SF1","CD5"})

Local   dDatIni
Local   dDatFim
Local	cPerg		:=	"ZZCADINFCP"     

Private nRegs

ValidPerg(cPerg)

If Pergunte(cPerg, .t.)
	dDatIni	:=	mv_par01
	dDatFim	:=	mv_par02
Else
	lProcessar	:=	.f.
EndIf

nRegs:=QrySF1(dDatIni, dDatFim)

If nRegs >= 0
	InsCD5()
EndIf

TSF1->(DbCloseArea())

Lj7RestArea(aArea)
RestArea(aAlias)

Return

//***************************************************************************************
&& -- ROTINA: Responsável por fazer a query na tabela SF1
//***************************************************************************************
Static Function InsCD5()
Local nInc := 0

While TSF1->(!EOF())
	DbSelectArea("CD5")
	CD5->(DbSetOrder(1))
	If CD5->(DbSeek(xFilial("CD5")+TSF1->F1_DOC+TSF1->F1_SERIE))
		Alert("CD5 para a nota "+AllTrim(TSF1->F1_DOC)+" já existe.")
	Else
		If RecLock("CD5", .T.)
			nInc:= nInc+1
			CD5->CD5_FILIAL := xFilial("CD5")
			CD5->CD5_DOC    := TSF1->F1_DOC
			CD5->CD5_SERIE  := TSF1->F1_SERIE
			If Empty(TSF1->F1_ZZDI)
				CD5->CD5_DOCIMP := TSF1->F1_NRDI
			Else
				CD5->CD5_DOCIMP := TSF1->F1_ZZDI
			EndIf
			CD5->CD5_TPIMP  := "0"
			CD5->CD5_BSPIS  := TSF1->F1_BASIMP6
			CD5->CD5_ALPIS  := 1.65
			CD5->CD5_VLPIS  := TSF1->F1_VALIMP6
			CD5->CD5_BSCOF  := TSF1->F1_BASIMP5
			CD5->CD5_ALCOF  := 7.6
			CD5->CD5_VLCOF  := TSF1->F1_VALIMP5
			CD5->CD5_FORNEC := TSF1->F1_FORNECE
			CD5->CD5_LOJA   := TSF1->F1_LOJA
			CD5->(MsUnlock())
		EndIf
	EndIf
	TSF1->(DbSkip())
EndDo

MsgInfo("Incluídos "+ STR(nInc)+ " registros no CD5.")

Return

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                                                         
//***************************************************************************************
&& -- ROTINA: Responsável por fazer a query na tabela SF1
//***************************************************************************************

Static Function QrySF1(dDatIni, dDatFim)
Local cQuery := ""

cQuery	:=	"Select "
cQuery	+=			"SF1.* "
cQuery	+=	"From "+RetSQLName("SF1")+ " SF1 "
cQuery	+=	"Where "
cQuery	+=			"SF1.F1_FILIAL   = '"	+xFilial("SF1")+"' And "
cQuery	+=			"SF1.F1_EMISSAO Between '" + dToS(dDatIni) + "' And '" + dToS(dDatFim) + "' And  "
cQuery	+=			"SF1.F1_EST = 'EX' And "
cQuery	+=			"SF1.D_E_L_E_T_  = ' ' "

TcQuery cQuery New Alias "TSF1"

Count to nRegs
TSF1->(DbGoTop())

If nRegs == 0
	Alert ("Não existe nota para o período informado")
EndIf

Return nRegs
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


//***************************************************************************************
&& -- ROTINA: Responsável por fazer as perguntas para o usuário.
//***************************************************************************************
Static Function ValidPerg(cPerg)
Local lRetorno := .T.
                                                                                                                                                                                                          
PutSx1(cPerg, "03" , "Data de Emissão de ?"  	, "Data de Emissão de ?" , "Data de Emissão de ?"     ,"mv_ch3" ,"D",08,0,0,"G",/*"Valid Param"*/,""    ,"030","","MV_PAR03","","","","","","","","","","","","","")
PutSx1(cPerg, "04" , "Data de Emissão até ?" 	, "Data de Emissão até ?", "Data de Emissão até ?"    ,"mv_ch4" ,"D",08,0,0,"G",/*"Valid Param"*/,""    ,"030","","MV_PAR04","","","","","","","","","","","","","")
    
Return(lRetorno)

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&