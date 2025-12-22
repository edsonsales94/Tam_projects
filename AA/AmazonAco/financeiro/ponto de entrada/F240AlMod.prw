#include "rwmake.ch"       

User Function F240AlMod()       

Local _cModelo := Paramixb[1]

_nTotGPS   := 0     
_nTotEnt     := 0 
_nTotAcres := 0       
_nTotAbat   := 0      
aTitCNAB    := {}
                    
   
//--- Quando bordero para envio de tributos com codigo de barras. Forçar o modelo 28 para gerar o segmento O.
If _cModelo == "91" 
   _cModelo := "28"
EndIf

Return  (_cModelo)     
 
