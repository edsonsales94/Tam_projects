/*
Solicitacao do Sr. Rafael Bocchi em 16/05/13

Evita que o usuario exclua um PV pela opcao "Altera".

*/

#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

User Function M410LDEL()     ///Ponto Entrada

Local  nCtd,lDelItm
Local  lResp  := .T.
Static cmPVen := SPACE(6)
Static nmDels := 0
Static nmx    := 0

c_Alias := ALIAS()

IF ( cmPVen <> M->C5_NUM )
	cmPVen := M->C5_NUM
	nmDels := 0
ENDIF
	
nmx++

IF ( nmx == 1 )
	nCtd    := LEN(aCols)
	lDelItm := aCols[n,LEN(aHeader)+1]
	IF ( !lDelItm )
		nmDels++
	ELSE
		nmDels--
	ENDIF	
	IF ( nCtd==nmDels )
		nmDels--
		MsgInfo("Exclusão do Item do Pedido não permitido.")
		lResp := .F.
	ENDIF	
ELSE
	nmx := 0
ENDIF

dbSelectArea(c_Alias)

Return(lResp)