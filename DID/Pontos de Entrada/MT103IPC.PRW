#INCLUDE "protheus.ch"
#INCLUDE "totvs.ch"

/*/{Protheus.doc} MT103IPC
ATUALIZA CAMPO NO DOCUMENTO DE ENTRADA DE ACORDO COM A INFORMAÇÃO DO PEDIDO
@type function
@version 1.0  
@author Gildeir Pereira - gildeir.pereira@totvs.com.br
@since 05/02/2025
/*/
User Function MT103IPC()
    Local _nItem := PARAMIXB[1]
    Local _nPosOF := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_XOF"})
    
    If _nPosOF > 0 .And. _nItem > 0
        aCols[_nItem,_nPosOF] := SC7->C7_XOF
    Endif
Return
