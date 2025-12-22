#Include "rwmake.ch"
#include "Protheus.CH"
#include "font.CH"
#include "Topconn.ch"

//  .-------------------------------------------------------------------------------------------------------------------.
// |     OBJETIVO 1: Montagem da Tela de Entrega de Produtos na Venda Assistida, gravando as informações necessárias     |
//  '-------------------------------------------------------------------------------------------------------------------'

User Function TelaEnt( _cTipo )

Private cdFuncao := FunName()

lRecLocal  := .F.
lEntrega   := .F.
cCliPad    := GETMV("MV_CLIPAD")

Default _cTipo = ''
//  .----------------------------------------------------------------------------------------------------------------------------------------.
// |   A variavel _cTipo, recebida como parametro indica se o gatilho que chama a tela de vendas foi disparado a partir do campo C5_YENTREG   |
// |   ou do campo L1_ENTREG, caso nao tenha sido passado nenhum parametro, é assumido que é um orçamento do Controle de Loja                 |                              |
//  '----------------------------------------------------------------------------------------------------------------------------------------'

_cCodCli := Space(6)

If !Alltrim(cdFuncao) $ 'LOJA701#FATA701' 
  If Alltrim(cdFuncao) $ '#MATA410' 
	   _cCodCli := M->C5_CLIENTE      
	 Else
	   _cCodCli := M->CJ_CLIENTE      
  EndIf  	
Else
	_cCodCli := M->LQ_CLIENTE
EndIf

//If Alltrim(cdFuncao) $ 'LOJA701#FATA701'
	
	If _cCodCli = Alltrim(cCliPad)
		MsgAlert("Não é possível realizar entrega para CLIENTE PADRÃO !",OemToAnsi("Atenção"))
		Return("N")
	EndIf
		
//Endif

If !Alltrim(cdFuncao) $ 'LOJA701#FATA701'
  If Alltrim(cdFuncao) $ '#MATA410' 
		 _cRecebedor := M->C5_RECENT
		 _cFone      := M->C5_FONEENT
		 _cEndereco  := M->C5_ENDENT
		 _cReferen   := M->C5_REFEREN
		 _cBairro    := M->C5_BAIRROE
		 _cMun		 := M->C5_MUNE
		 _cEst		 := M->C5_ESTE
		 _cObs1      := M->C5_OBSENT1
		 _cObs2      := M->C5_OBSENT2
		 _cObs3      := ""
    	 _cObs4      := ""
		 lEntrega    := IIf(M->C5_ENTREGA == "S",.T.,.F.)
	 Else 
		 _cRecebedor := M->CJ_RECENT
		 _cFone      := M->CJ_FONEENT
		 _cEndereco  := M->CJ_ENDENT
		 _cReferen   := M->CJ_REFEREN
		 _cBairro    := M->CJ_BAIRROE
		 _cMun		 := M->CJ_MUNE
		 _cEst		 := M->CJ_ESTE
		 _cObs1      := M->CJ_OBSENT1
		 _cObs2      := M->CJ_OBSENT2
		 _cObs3      := ""
    	 _cObs4      := ""
		 lEntrega    := IIf(M->CJ_ENTREGA == "S",.T.,.F.)	 
  EndIf 	 
	
Else
	_cRecebedor := M->LQ_RECENT
	_cFone      := M->LQ_FONEENT
	_cEndereco  := M->LQ_ENDENT
	_cReferen   := M->LQ_REFEREN
	_cBairro    := M->LQ_BAIRROE
	_cMun		:= M->LQ_MUNE
	_cEst		:= M->LQ_ESTE
	_cObs1      := M->LQ_OBSENT1
	_cObs2      := M->LQ_OBSENT2
	_cObs3      := M->LQ_OBSENT3
	_cObs4      := M->LQ_OBSENT4
	//		lRecLocal   := IIf(M->LQ_RECLOC  == "S",.T.,.F.)
	lEntrega    := IIf(M->LQ_ENTREGA == "S",.T.,.F.)
EndIf

_cRecebedor := IiF(Empty( _cRecebedor) ,Space(30)        ,_cRecebedor)
_cFone      := IiF(Empty( _cFone)      ,SA1->A1_FONEENT  ,_cFone)
_cEndereco  := IiF(Empty( _cEndereco)  ,SA1->A1_ENDENT   ,_cEndereco)
_cBairro    := IiF(Empty( _cBairro)    ,SA1->A1_BAIRROE  ,_cBairro)
_cReferen   := IiF(Empty( _cReferen)   ,SA1->A1_REFEREN  ,_cReferen)
_cObs1      := IiF(Empty( _cObs1)      ,Space(80)        ,_cObs1)
_cObs2      := IiF(Empty( _cObs2)      ,Space(80)        ,_cObs2)
_cObs3      := IiF(Empty( _cObs3)      ,Space(80)        ,_cObs3)
_cObs4      := IiF(Empty( _cObs4)      ,Space(80)        ,_cObs4)

_cMun		:= IiF(Empty( _cMun)       ,IIf(Empty(SA1->A1_MUNE),"MANAUS",SA1->A1_MUNE),_cMun)
_cEst		:= IiF(Empty( _cEst)       ,IIf(Empty(SA1->A1_ESTE),"AM",SA1->A1_ESTE)    ,_cEst)

_SitVenda   := IIf(!Empty(SA1->A1_SITUACA),SA1->A1_SITUACA,"V")

DEFINE Font oFnt3 Name "Ms Sans Serif" Bold

DEFINE MSDIALOG oDlgMain TITLE "Tela de Entrega" FROM 96,5 TO 510,650 PIXEL

//@005,80 CHECKBOX oEntrega VAR lEntrega PROMPT "Entrega?" OF oDlgMain SIZE 55,08 PIXEL WHEN .F.

@ 015, 015 SAY "Recebedor:     " SIZE 220,10 OF oDlgMain PIXEL Font oFnt3
@ 015, 050 GET _cRecebedor PICTURE "@!" SIZE 129,8 PIXEL OF oDlgMain

@ 035, 015 SAY "Fone :         " SIZE 220,10 OF oDlgMain PIXEL Font oFnt3
@ 035, 050 GET _cFone PICTURE "@!" SIZE 129,8 PIXEL OF oDlgMain WHEN ( !Empty(_cRecebedor) )

@ 055, 015 Say "Endereco:      "  Size 220,10 Of oDlgMain Pixel Font oFnt3
@ 055, 050 Get _cEndereco Picture "@!" Size 129,8 Pixel of oDlgMain when (!Empty(_cFone))

@ 075, 015 Say "Bairro:        "  Size 220,10 Of oDlgMain Pixel Font oFnt3
@ 075, 050 Get _cBairro Picture "@!" Size 129,8 Pixel of oDlgMain Valid when (!Empty(_cEndereco))

@ 095, 015 Say "P. Refer.: " Size 220,10 Of oDlgMain Pixel Font oFnt3
@ 095, 050 Get _cReferen   Picture "@!" Size 129,8 Pixel of oDlgMain when (!Empty(_cBairro))

@ 115, 015 Say "Municipio: " Size 220,10 Of oDlgMain Pixel Font oFnt3
@ 115, 050 Get _cMun  Picture "@!" Size 129,8 Pixel of oDlgMain Valid when (!Empty(_cReferen))

@ 135, 015 Say "Estado   : " Size 220,10 Of oDlgMain Pixel Font oFnt3
@ 135, 050 Get _cEst  Picture "@!" Size 129,8 Pixel of oDlgMain when (!Empty(_cMun))

@ 155, 015 Say "Obs   : " Size 220,50 Of oDlgMain Pixel Font oFnt3
@ 155, 050 Get _cObs1  Picture "@!" Size 250,8 Pixel of oDlgMain when (!Empty(_cEst))
@ 165, 050 Get _cObs2  Picture "@!" Size 250,8 Pixel of oDlgMain when (!Empty(_cObs1))
@ 175, 050 Get _cObs3  Picture "@!" Size 250,8 Pixel of oDlgMain when (!Empty(_cObs2))
@ 185, 050 Get _cObs4  Picture "@!" Size 250,8 Pixel of oDlgMain when (!Empty(_cObs3))

@ 195, 280 BMPBUTTON TYPE 1 ACTION Grava(_cTipo)

bCancel := {||oDlgMain:End()}

Activate Msdialog oDlgMain Centered


cRet :=IIf(lEntrega,"S","N")

Return("S")
//
//  .---------------------------------------------------------------------------------------------------------.
// |     Grava os dados da tela de entrega no orcamento / pedido de vendas que está sendo feito no momento     |
//  '---------------------------------------------------------------------------------------------------------'
//
Static Function Grava(_cTipo)

lRet := .T.

Do Case
	Case Empty(_cRecebedor)
		lRet := .F.
		MsgAlert("Favor informar o Recebedor !!!",OemToAnsi("Atenção"))
	Case Empty(_cFone)
		lRet := .F.
		MsgAlert("Favor informar o Fone !!!",OemToAnsi("Atenção"))
	Case Empty(_cEndereco)
		lRet := .F.
		MsgAlert("Favor informar o Endereço !!!",OemToAnsi("Atenção"))
	Case Empty(_cBairro)
		lRet := .F.
		MsgAlert("Favor informar o Bairro !!!",OemToAnsi("Atenção"))
	Case Empty(_cReferen)
		lRet := .F.
		MsgAlert("Favor informar o Ponto de Referencia !!!",OemToAnsi("Atenção"))
	Case Empty(_cMun)
		lRet := .F.
		MsgAlert("Favor informar o Municipio !!!",OemToAnsi("Atenção"))
	Case Empty(_cEst)
		lRet := .F.
		MsgAlert("Favor informar o Estado !!!",OemToAnsi("Atenção"))
EndCase

If lRet
	
	oDlgMain:End()
	If !Alltrim(cdFuncao) $ 'LOJA701#FATA701'
	  If Alltrim(cdFuncao) $ '#MATA410' 	
			M->C5_RECENT := _cRecebedor
			M->C5_FONEENT:= _cFone
			M->C5_ENDENT := _cEndereco
			M->C5_REFEREN:= _cReferen
			M->C5_BAIRROE:= _cBairro
			M->C5_MUNE   := _cMun
			M->C5_ESTE   := _cEst
			M->C5_OBSENT1:= _cObs1
			M->C5_OBSENT2:= _cObs2
			M->C5_ENTREGA:= "S"
	 	 Else                            
			M->CJ_RECENT := _cRecebedor
			M->CJ_FONEENT:= _cFone
			M->CJ_ENDENT := _cEndereco
			M->CJ_REFEREN:= _cReferen
			M->CJ_BAIRROE:= _cBairro
			M->CJ_MUNE   := _cMun
			M->CJ_ESTE   := _cEst
			M->CJ_OBSENT1:= _cObs1
			M->CJ_OBSENT2:= _cObs2
			M->CJ_ENTREGA:= "S"	 	 
	  EndIf 	
	Else
		M->LQ_RECENT := _cRecebedor
		M->LQ_FONEENT:= _cFone
		M->LQ_ENDENT := _cEndereco
		M->LQ_REFEREN:= _cReferen
		M->LQ_BAIRROE:= _cBairro
		M->LQ_MUNE	 := _cMun
		M->LQ_ESTE   := _cEst
		M->LQ_OBSENT1:= _cObs1
		M->LQ_OBSENT2:= _cObs2
		M->LQ_OBSENT3:= _cObs3
		M->LQ_OBSENT4:= _cObs4
		M->LQ_ENTREGA:= "S"
	EndIf
	IF MsgNoYes(" Atualiza dados do cliente ? ")
		GravaCli()
	EndIf
	
Endif

Return()
//
//  .----------------------------------------------------------------.
// |     Grava os dados da tela de entrega no cadastro de clientes     |
//  '-----------------------------------------------------------------'
//
Static Function Gravacli()

Begin Transaction

RecLock("SA1")
SA1->A1_FONEENT := _cFone
SA1->A1_ENDENT  := _cEndereco
SA1->A1_BAIRROE := _cBairro
SA1->A1_REFEREN := _cReferen
SA1->A1_MUNE    := _cMun
SA1->A1_ESTE    := _cEst
SA1->A1_SITUACA := _SitVenda
MsUnLock()

End Transaction   

_cFone      := ''
_cEndereco  := ''
_cBairro    := ''
_cReferen   := ''
_cMun       := ''
_cEst    	:= ''
_SitVenda	:= ''
_cRecebedor := ''
_cObs1     	:= ''
_cObs2		:= ''

Return
