#include "protheus.ch"
//
// |     Programa     |     MT103LEG     |     Autor     |     Wagner da Gama Correa      |     Data     |     31/01/2011     |
//

User Function MT103LEG

_aLegNova := ParamIXB[1]
aAdd( _aLegNova, {"BR_BRANCO", "Documento NFS"})

Return( _aLegNova )