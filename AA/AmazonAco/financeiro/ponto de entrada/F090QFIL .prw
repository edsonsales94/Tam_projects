#include "Protheus.ch"
#include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ F090QFIL    ¦ Autor ¦ Adson Carlos         ¦ Data ¦ 23/05/2012¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ ponto de entrada permitir complementar o filtro padrão FINA090¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

/*/{Protheus.doc} F090QFIL()
 
    Complemento do Filtro padrão da rotina Baixa Pagar Automática (FINA090)
 
    @param ParamIxb[1] - cFiltro - Filtro padrão da rotina
    @param Paramixb[2] - nTipoBx - Tipo de Baixa (1=Títulos ou 2=Borderôs)
 
    @return cRetFiltro - Novo Filtro
/*/

User Function F090QFIL()
    Local cFiltro    := ParamIXB[1] //Filtro padrão
    Local nTipoBx    := ParamIXB[2] //Tipo de Baixa
    Local cRetFiltro := cFiltro //Novo Filtro
 
    If (nTipoBx == 1) //Títulos
        cRetFiltro += " AND E2_FILORIG = '" + fwCodFil() +"' "
    Else //Borderôs
        cRetFiltro += " AND E2_FILORIG = '" + fwCodFil() +"' "
    EndIf
 
Return cRetFiltro
