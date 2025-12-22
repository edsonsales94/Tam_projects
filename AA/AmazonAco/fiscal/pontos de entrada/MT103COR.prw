#include "protheus.ch"
//
// |     Programa     |     MT103LEG     |     Autor     |     Wagner da Gama Correa      |     Data     |     31/01/2011     |
//

User Function MT103COR

_aFilNova := ParamIXB[1]
aAdd( _aFilNova, {'AllTrim(F1_ESPECIE) == "NFS" .and. !Empty(F1_STATUS)' , 'BR_BRANCO' } )

Return( _aFilNova )