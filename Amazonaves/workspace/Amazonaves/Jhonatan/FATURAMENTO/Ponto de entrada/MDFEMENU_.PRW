#Include "TOTVS.ch"

User Function MDFEMENU()

Local aRotina := {}

aRotina := {{ Pesquisar, "PesqBrw" ,0,1,0,.F.},;
{ Visualizar, "MDFeVisual" ,0,2,0,.F.},;
{ "Vincular Nota Fiscal",U_VSPFATO9() ,0,2,0,.F.},;
{ Incluir, "MDFeInclui" ,0,3,0,.F.},;
{ Alterar, "MDFeAltera" ,0,4,0,.F.},;
{ Excluir , "MDFeExclui" ,0,5,0,.F.},;
{ Parâmetros, "MDFeParam" ,0,3,0,.F.},;
{ "Gerenciar MDFe", "MDFeManage" ,0,6,0,.F.},;
{ "Damdfe", "MDFeDamDfe" ,0,2,0,.F.},;
{ Legenda, "MDFeLegend" ,0,3,0,.F.}}

Return aRotina
