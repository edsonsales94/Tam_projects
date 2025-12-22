#include 'totvs.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ SAVEMV     º Autor ³ Andre Rodrigues                           º Data ³ Set/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Grava o parametro novo na tabela padrao SX6.                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//aPARAM   := {NEWPARAM,'C','DESCR','DESC1','DESC2',_cConteudo}
//If !ExisteSX6(aParam[1])
//	U_SaveMv(aPARAM,'')
//EndIf
User Function SAVEMV(aPar,cInd)

If !SX6->(dbSeek(SM0->M0_CODFIL+aPar[1]+cInd)) .AND. !SX6->(dbSeek('  '+aPar[1]+cInd))
	RECLOCK('SX6',.T.)
	SX6->X6_FIL			:= xFilial('SX6')
	SX6->X6_VAR			:= aPar[1]
	SX6->X6_TIPO		:= aPar[2]
	SX6->X6_DESCRIC		:= aPar[3]
	SX6->X6_DSCSPA		:= aPar[3]
	SX6->X6_DSCENG		:= aPar[3]
	SX6->X6_DESC1		:= aPar[4]
	SX6->X6_DSCSPA1		:= aPar[4]
	SX6->X6_DSCENG1		:= aPar[4]
	SX6->X6_DESC2		:= aPar[5]+cInd
	SX6->X6_DSCSPA2		:= aPar[5]+cInd
	SX6->X6_DSCENG2		:= aPar[5]+cInd
	SX6->X6_CONTEUD		:= aPar[6]
	SX6->X6_CONTSPA		:= aPar[6]
	SX6->X6_CONTENG		:= aPar[6]
	SX6->X6_PROPRI		:= 'S'
	SX6->X6_PYME		:= 'S'
	SX6->X6_VALID		:= ''
	SX6->X6_INIT		:= ''
	SX6->X6_DEFPOR		:= ''
	SX6->X6_DEFSPA		:= ''
	SX6->X6_DEFENG		:= ''
	SX6->(MSUNLOCK())
EndIf

Return