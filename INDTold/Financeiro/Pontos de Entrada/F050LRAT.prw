#include 'RwMake.ch'
User Function F050LRAT()
   lRet := .T.
   alert('chamou')
   
   //For nI := 2 To Len(aCols)
     If aCols[n][03] != aCols[01][03]
       lRet := .F.
     EndIf
   //Next
  If !lRet 
      Aviso('Atencao','Existem itens Divergentes Na Coluna Rateio Centro de Custo, Marque todos como SIM, ou todos como NAO',{'Ok'},2) 
  EndIf
Return lRet

