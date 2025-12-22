#INCLUDE "PROTHEUS.CH"
#include "colors.ch"

User Function MA242BUT
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Função de Inclusao de Butões na Tela de Desmontagem
OBJETIVO 1: Incluir o Botao de Bobina Slitada - SZ1       
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

Local _aMyBtn := {}

aAdd(_aMyBtn, {"BPMSRECI", { || U_AAESTT02() },"Bobina Slittada","Bobina Slittada"})
                  
Return( _aMyBtn )