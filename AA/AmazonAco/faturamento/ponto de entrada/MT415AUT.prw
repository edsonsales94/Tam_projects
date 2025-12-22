#Include "Totvs.ch"

User FUnction MT415AUT()
  Local lRet := .T.
  If !Empty(SCJ->CJ_XBLQORC)
     Aviso('Atencao','Não é Possivel a Efetivação do Orcamento pois o Mesmo esta Bloqueado',{'Ok'},2) 
     lRet := .F.
  EndIf
Return lRet


