#include "totvs.ch"

/*/{Protheus.doc} MA103OPC
ADICIONA OPCAO AO MENU PARA IMPRESSAO DE ETIQUETA
@type function
@version 1.0 
@author Gildeir Pereira - gildeir.pereira@totvs.com.br
@since 29/01/2025
/*/
User Function MA103OPC()

    Local aRet := {}

    aAdd(aRet,{"@Etiqueta de Entrada", "U_GETIQ006", 0, 5})

Return aRet

