#include 'Protheus.ch'
#include 'RwMake.ch'

/*
DATA      : 32/07/2010
Descricao : para validar o rateio a Pedido do Adelson
*/
User Function F050RAT()
Local nI 
   lRet := .T.
   alert('chamou')
   
   For nI := 2 To Len(aCols)
     If aCols[nI][03] != aCols[01][03]
       lRet := .F.
     EndIf
   Next
  If !lRet 
      Aviso('Atencao','Existem itens Divergentes Na Coluna Rateio Centro de Custo, Marque todos como SIM, ou todos como NAO',{'Ok'},2) 
  EndIf
Return lRet



/*powered by DXRCOVRB*/
