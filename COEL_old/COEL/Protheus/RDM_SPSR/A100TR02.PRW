#include "rwmake.ch"

User Function A100TR02()


SetPrvt("_AAREA,_CROT,_CCOD,_AAREAE5,_CRET,")



/* ®------------------------------------------------------------------------®
| Funcao     | A100TR02 | Autor | Rogerio Batista       | Data |            |
®---------------------------------------------------------------------------®
|  Descricao | Grava o Banco de destino em campo espec. no E5_X_DEST        |
|            | na transferencia entre bancos                                |
®---------------------------------------------------------------------------®
|   Uso      |                                                              |
®---------------------------------------------------------------------------® */

_aArea := GetArea()

_cBcoDest := SE5->E5_BANCO
_cNumDoc  := SE5->E5_DOCUMEN
_cHistor  := SE5->E5_BENEF+SE5->E5_HISTOR

dbSelectArea("SE5")
dbSetOrder(11)
dbSeek(xFilial("SE5")+_cNumDoc)

If Found()
	If E5_BENEF+E5_HISTOR == _cHistor
		RecLock("SE5",.F.)
		SE5->E5_X_DEST := _cBcoDest
		MsUnlock()	
	EndIf
EndIf

RestArea(_aArea)
Return()

