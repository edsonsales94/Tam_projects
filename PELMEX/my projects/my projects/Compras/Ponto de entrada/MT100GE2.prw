#include 'protheus.ch'
#include 'parmtype.ch'

User Function MT100GE2()
Local aTitAtual := PARAMIXB[1]
Local nOpc := PARAMIXB[2]
Local aHeadSE2:= PARAMIXB[3]
Local aParcelas := ParamIXB[5]
Local nX := ParamIXB[4]
Local cCCusto := "6000"

for i := 1 to Len(aTitAtual)
    
    MSGInfo(aTitAtual[i,1]+chr(13)+;
            aTitAtual[i,2]+chr(13))
next i
//.....Exemplo de customização
If nOpc == 1 //.. inclusao
     SE2->E2_CCUSTO := cCCusto
Endif

Return(Nil)
