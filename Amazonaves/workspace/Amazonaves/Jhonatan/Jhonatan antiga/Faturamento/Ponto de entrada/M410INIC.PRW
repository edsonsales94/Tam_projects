User Function M410INIC()

Local _aArea := GetArea()

DbSelectArea ("SC5") 
  
If !EMPTY(SCJ->CJ_XNUMOS) 
M->C5_XNUMOS := CJ_XNUMOS // Numero OS - Campo que será gravado na SC5
EndIf

RestArea(_aArea)

Return()


