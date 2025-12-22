
#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTF510   ºAutor  ³ Rogerio Batista      ºData³ 17/07/2008º  ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ APRESENTA A CONTA DO LANCTO 610 para Manaus                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COEL                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                
///////////////////////////////////////////
// Lançamento padrao 610-01 - Vendas     //
///////////////////////////////////////////

USER FUNCTION CTB61001()
LOCAL _nRetorno
LOCAL _aArea

_aArea    := GetArea(_aArea)
_nRetorno := 0

_cCodCli := SA1->A1_TIPO

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD2->D2_COD)

_SubGrupo := SB1->B1_CLCGRP

IF alltrim(_SubGrupo) $ "13" //Interruptor
	If _cCodCli $ "X"
		_nRetorno :=  '3111020001' //'311020001'
	Else
		_nRetorno :=  '3111030001'//'311030001'
	EndIf
ELSEIF alltrim(_SubGrupo) $ "41"//Controlador
	If _cCodCli $ "X"
		_nRetorno :=  '3111020002'
	Else
		_nRetorno :=  '3111030002'
	EndIf
ELSEIF alltrim(_SubGrupo) $ "81"//Contador
	If _cCodCli $ "X"
		_nRetorno :=  '3111020003'
	Else
		_nRetorno :=  '3111030003'
	EndIf 
ELSEIF alltrim(_SubGrupo) $ "82"//Contador de tempo
	If _cCodCli $ "X"
		_nRetorno :=  '3111020006'
	Else
		_nRetorno :=  '3111010007'
	EndIf
ELSEIF alltrim(_SubGrupo) $ "71"//Indicador
	If _cCodCli $ "X"
		_nRetorno :=  '3111020004'
	Else
		_nRetorno :=  '3111010001'
	EndIf
ELSEIF alltrim(_SubGrupo) $ "RELE/64"//Rele
	If _cCodCli $ "X"
		_nRetorno :=  'EXPORTACAO'
	Else
		_nRetorno :=  '3111010002'
	EndIf
ELSE
	_nRetorno := ''
ENDIF

RestArea(_aArea)

RETURN(_nRetorno)


///////////////////////////////////////
// Lançamento padrao 610-02 - ICMS   //
///////////////////////////////////////

USER FUNCTION CTB61002()
LOCAL _nRetorno
LOCAL _aArea

_aArea    := GetArea(_aArea)
_nRetorno := 0

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD2->D2_COD)

_SubGrupo := SB1->B1_CLCGRP

IF alltrim(_SubGrupo) $ "13" //Interruptor
	_nRetorno :=  '3112020001'//'322080001'
ELSEIF alltrim(_SubGrupo) $ "41"//Controlador
	_nRetorno :=  '3112020002'//'322080002'
ELSEIF alltrim(_SubGrupo) $ "81"//Contador
	_nRetorno :=  '3112020003'//'322080003'
ELSEIF alltrim(_SubGrupo) $ "82"//Contador de tempo
	_nRetorno :=  '3112010006'//'322080003'
ELSEIF alltrim(_SubGrupo) $ "71"//Indicador
	_nRetorno :=  '3112010001'//'322070001' 
ELSEIF alltrim(_SubGrupo) $ "RELE/64"//Rele
	_nRetorno :=  '3112010002'//'322070002' 
ELSE
	_nRetorno :=  ''
ENDIF

RestArea(_aArea)

RETURN(_nRetorno)


////////////////////////////////////
// Lançamento padrao 610-03- Pis  //
////////////////////////////////////

USER FUNCTION CTB61003()
LOCAL _nRetorno
LOCAL _aArea

_aArea    := GetArea(_aArea)
_nRetorno := 0

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD2->D2_COD)

_SubGrupo := SB1->B1_CLCGRP

IF alltrim(_SubGrupo) $ "13" //Interruptor
	_nRetorno :=  '3112060001'//'322110001'
ELSEIF alltrim(_SubGrupo) $ "41"//Controlador
	_nRetorno :=  '3112060002'//'322110002'
ELSEIF alltrim(_SubGrupo) $ "81"//Contador
	_nRetorno :=  '3112060003'//'322110003'
ELSEIF alltrim(_SubGrupo) $ "82"//Contador de tempo
	_nRetorno :=  '3112050006'//'322110003'
ELSEIF alltrim(_SubGrupo) $ "71"//Indicador
	_nRetorno :=  '3112050001'//'322100001' 
ELSEIF alltrim(_SubGrupo) $ "RELE/64"//Rele
	_nRetorno :=  '3112050002'//'322100002' 
ELSE
	_nRetorno :=  ''
ENDIF

RestArea(_aArea)

RETURN(_nRetorno)
                                    

////////////////////////////////////////
// Lançamento padrao 610-04 - Cofins  //
////////////////////////////////////////

USER FUNCTION CTB61004()
LOCAL _nRetorno
LOCAL _aArea

_aArea    := GetArea(_aArea)
_nRetorno := 0

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD2->D2_COD)

_SubGrupo := SB1->B1_CLCGRP

IF alltrim(_SubGrupo) $ "13" //Interruptor
	_nRetorno :=  '3112040001'//'322130001'
ELSEIF alltrim(_SubGrupo) $ "41"//Controlador
	_nRetorno :=  '3112040002'//'322130002'
ELSEIF alltrim(_SubGrupo) $ "81"//Contador
	_nRetorno :=  '3112040003'//'322130003'
ELSEIF alltrim(_SubGrupo) $ "82"//Contador de tempo
	_nRetorno :=  '3112030006'//'322130003'
ELSEIF alltrim(_SubGrupo) $ "71"//Indicador
	_nRetorno :=  '3112030001'//'322120001' 
ELSEIF alltrim(_SubGrupo) $ "RELE/64"//Rele
	_nRetorno :=  '3112030002'//'322120002' 
ELSE
	_nRetorno :=  ''
ENDIF

RestArea(_aArea)

RETURN(_nRetorno)



////////////////////////////////////////////////////////
// Lançamento padrao 640-01 - DEVOLUCAO DE VENDAS     //
////////////////////////////////////////////////////////

USER FUNCTION CTB65001()
LOCAL _nRetorno
LOCAL _aArea

_aArea    := GetArea(_aArea)
_nRetorno := 0

_cCodCli := SA1->A1_TIPO

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD1->D1_COD)

_SubGrupo := SB1->B1_CLCGRP

IF alltrim(_SubGrupo) $ "13" //Interruptor
	If _cCodCli $ "X"
		_nRetorno :=  '3111020001' //'311020001'
	Else
		_nRetorno :=  '3111030001'//'311030001'
	EndIf
ELSEIF alltrim(_SubGrupo) $ "41"//Controlador
	If _cCodCli $ "X"
		_nRetorno :=  '3111020002'
	Else
		_nRetorno :=  '3111030002'
	EndIf
ELSEIF alltrim(_SubGrupo) $ "81  /82  "//Contador
	If _cCodCli $ "X"
		_nRetorno :=  '3111020003'
	Else
		_nRetorno :=  '3111030003'
	EndIf
ELSEIF alltrim(_SubGrupo) $ "71"//Indicador
	If _cCodCli $ "X"
		_nRetorno :=  '3111020004'
	Else
		_nRetorno :=  '3111010001'
	EndIf
ELSEIF alltrim(_SubGrupo) $ "RELE/64"//Rele
	If _cCodCli $ "X"
		_nRetorno :=  'EXPORTACAO'
	Else
		_nRetorno :=  '3111010002'
	EndIf
ELSE
	_nRetorno := ''
ENDIF

RestArea(_aArea)

RETURN(_nRetorno)

///////////////////////////////////////////////////////////
// Lançamento padrao 650-02 - DEVOLUCAO DE VENDAS - ICMS //
///////////////////////////////////////////////////////////

USER FUNCTION CTB65002()
LOCAL _nRetorno
LOCAL _aArea

_aArea    := GetArea(_aArea)
_nRetorno := 0

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD1->D1_COD)

_SubGrupo := SB1->B1_CLCGRP

IF alltrim(_SubGrupo) $ "13" //Interruptor
	_nRetorno :=  '3112020001'//'322080001'
ELSEIF alltrim(_SubGrupo) $ "41"//Controlador
	_nRetorno :=  '3112020002'//'322080002'
ELSEIF alltrim(_SubGrupo) $ "81/82"//Contador
	_nRetorno :=  '3112020003'//'322080003'
ELSEIF alltrim(_SubGrupo) $ "71"//Indicador
	_nRetorno :=  '3112010001'//'322070001' 
ELSEIF alltrim(_SubGrupo) $ "RELE/64"//Rele
	_nRetorno :=  '3112010002'//'322070002' 
ELSE
	_nRetorno :=  ''
ENDIF

RestArea(_aArea)

RETURN(_nRetorno)                                       


//////////////////////////////////////////////////////////
// Lançamento padrao 650-03- DEVOLUCAO DE VENDAS - PIS  //
//////////////////////////////////////////////////////////

USER FUNCTION CTB65003()
LOCAL _nRetorno
LOCAL _aArea

_aArea    := GetArea(_aArea)
_nRetorno := 0

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD1->D1_COD)

_SubGrupo := SB1->B1_CLCGRP

IF alltrim(_SubGrupo) $ "13" //Interruptor
	_nRetorno :=  '3112060001'//'322110001'
ELSEIF alltrim(_SubGrupo) $ "41"//Controlador
	_nRetorno :=  '3112060002'//'322110002'
ELSEIF alltrim(_SubGrupo) $ "81/82"//Contador
	_nRetorno :=  '3112060003'//'322110003'
ELSEIF alltrim(_SubGrupo) $ "71"//Indicador
	_nRetorno :=  '3112050001'//'322100001' 
ELSEIF alltrim(_SubGrupo) $ "RELE/64"//Rele
	_nRetorno :=  '3112050002'//'322100002' 
ELSE
	_nRetorno :=  ''
ENDIF

RestArea(_aArea)

RETURN(_nRetorno) 

//////////////////////////////////////////////////////////////
// Lançamento padrao 650-04 - DEVOLUCAO DE VENDAS - COFINS  //
//////////////////////////////////////////////////////////////

USER FUNCTION CTB65004()
LOCAL _nRetorno
LOCAL _aArea

_aArea    := GetArea(_aArea)
_nRetorno := 0

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD1->D1_COD)

_SubGrupo := SB1->B1_CLCGRP

IF alltrim(_SubGrupo) $ "13" //Interruptor
	_nRetorno :=  '3112040001'//'322130001'
ELSEIF alltrim(_SubGrupo) $ "41"//Controlador
	_nRetorno :=  '3112040002'//'322130002'
ELSEIF alltrim(_SubGrupo) $ "81/82"//Contador
	_nRetorno :=  '3112040003'//'322130003'
ELSEIF alltrim(_SubGrupo) $ "71"//Indicador
	_nRetorno :=  '3112030001'//'322120001' 
ELSEIF alltrim(_SubGrupo) $ "RELE/64"//Rele
	_nRetorno :=  '3112030002'//'322120002' 
ELSE
	_nRetorno :=  ''
ENDIF

RestArea(_aArea)

RETURN(_nRetorno)
