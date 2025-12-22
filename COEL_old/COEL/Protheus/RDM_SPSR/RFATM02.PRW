#include "rwmake.ch"

User Function RFATM02()


SetPrvt("CCOR,LAS400,AROTINA,_CCONSULTA,_CRESTC03,CCADASTRO")

/*/
-----------------------------------------------------------------------------
® Programa  ® RFATM02  ® Autor ® Rogerio Batista        ® Data ® 07.06.04   ®
-----------------------------------------------------------------------------
® Descri‡…o ® Programa que permite visualizar Cadastro de Clientes e alterar®
®           ® alguns dados.                                                 ®
-----------------------------------------------------------------------------
® Uso       ® SigaFat -                                                     ®
-----------------------------------------------------------------------------
/*/

aRotina   := { { "Pesquisar"        ,"AxPesqui"   ,0,1},;
{ "Alteracao" ,'EXECBLOCK("RFATM03")',0,3} }


cCadastro := "Atualizacao (Cadastro de Clientes)"


MBrowse(06,1,22,75,"SA1")


Return

