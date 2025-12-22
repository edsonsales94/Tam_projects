#include "Protheus.ch"
#include "rwmake.ch"

User Function AAPCPP05
// Criado em 30/10/2018 by Wladimir Vieira

Local mQuant := 0
mQuant := getmv("MV_XLIMQOP")  // Parâmetro criado para limitar quantodade na OP
IF M->C2_QUANT > mQuant
    M->C2_QUANT := 0
    mRet := 0
    MsgBox("Quantidade nao Permitida", "Máximo permitido: "+transform(mQuant,"@E 999,999"), "Alert")    
Endif        

Return(mRet)