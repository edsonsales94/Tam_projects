#include "rwmake.ch"        

User Function F240Sum()        

SetPrvt("_valor,_abat,_juros")


_Abat  := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
_Abat  += SE2->E2_DECRESC 
_Juros := (SE2->E2_XMULTA + SE2->E2_XJUROS)
_Valor := SE2->E2_SALDO - _Abat + _Juros

//-- Variavel publica declarada no ponto de entrada f240arq() e zerada no ponto de entrada f240almod()
_nTotEnt    += SE2->E2_XOUTENT               
_nTotAbat  += SE2->E2_DECRESC
_nTotAcres += _Juros
_nTotGps   += (SE2->E2_SALDO - SE2->E2_XOUTENT)
    

Return(_Valor)       
