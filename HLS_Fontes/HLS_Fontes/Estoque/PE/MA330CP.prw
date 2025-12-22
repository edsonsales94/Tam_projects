#include "RWMAKE.CH"

User Function MA330CP ()

LOCAL aRegraCP:={}

AADD(aRegraCP,"SB1->B1_TIPO == 'MP'")

AADD(aRegraCP,"SB1->B1_TIPO == 'MC'")

Return aRegraCP
