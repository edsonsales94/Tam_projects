#INCLUDE "protheus.ch"

User Function LJ7018()
  Local _lRet := .T.
  Local nVlrDesc := PARAMIXB[02]
  If Posicione("SA1",1,xFilial('SA1') + M->LQ_CLIENTE + M->LQ_LOJA,"A1_GRPTRIB" ) == "005" .And. (PARAMIXB[02] > 0 .Or. PARAMIXB[01] > 0) .And. M->LQ_ENTREGA = 'S'
     Aviso("Atencao"," Nao Pode Efetuar Desconto no Total em Venda para Distribuidor",{"Ok"})
     _lRet := .F.
  EndIf
  
Return _lRet




/*powered by DXRCOVRB*/