#include "rwmake.ch"

//////////////////////////////////////////////////
User Function CFRMLTE()
//////////////////////////////////////////////////
Local cxLote
Local cxFuncao := FUNNAME()
Local cxData := LEFT(DTOS(ddatabase),6)
Local cAlias := Alias()

IF ( cxFuncao $ "MATA250/MATA240" )
	cxData := LEFT(DTOS(M->D3_EMISSAO),6)
ELSEIF ( cxFuncao == "MATA241" )
	cxData := LEFT(DTOS(M->DA241DATA),6)
ELSEIF ( cxFuncao == "MATA260" )
	cxData := LEFT(DTOS(M->DEMIS260),6)
ELSEIF ( cxFuncao == "MATA261" )
	cxData := LEFT(DTOS(M->DA261DATA),6) 
ELSEIF ( cxFuncao == "MATA270" )
	cxData := LEFT(DTOS(M->B7_DATA),6)
ENDIF	
cxLote := cxData+"0001"

dbSelectArea("SB8")
nIndSb8 := INDEXORD()
nRecSb8 := RECNO()
dbSetOrder(5)
dbSeek(xFilial("SB8")+SB1->B1_COD+"zzzzzz",.T.)
dbSkip(-1)
DO WHILE !BOF().AND.B8_FILIAL==xFilial("SB8").AND.B8_PRODUTO==SB1->B1_COD
   IF ( LEFT(B8_LOTECTL,4) <> "AUTO" )
		IF ( LEFT(DTOS(B8_DATA),6) == cxData )
			cxLote := STRZERO(VAL(B8_LOTECTL)+1,10)
		ENDIF	
      EXIT
   ENDIF
   dbSkip(-1)
ENDDO

dbSelectArea("SB8")
dbSetOrder(nIndSb8)
dbGoTo(nRecSb8)
dbSelectArea(cAlias)
Return(cxLote)