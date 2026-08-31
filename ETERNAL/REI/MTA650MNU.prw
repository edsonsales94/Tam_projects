#include 'protheus.ch'
#include 'rwmake.ch'

/*/{Protheus.doc} MTA650MNU()
  Ponto de entrada para adicionar botões ao menu da rotina de Ordem de Produção.
  @type User Function
  @author TOTVS NORTE
  @since 01/08/2024
  @version 1.0
  @links https://tdn.totvs.com/display/public/PROT/MTA650MNU 
/*/

User Function MTA650MNU()
  Local aArea := GetArea()   
  AADD(aRotina,{'Imprimir OP','U_ETPCPR01' ,0 ,3, 0, nil})
  RestArea(aArea)
Return()
