#include "rwmake.ch"     
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function cfis01i()  


SetPrvt("CCADASTRO,AROTINA,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFIS01I  ³ Autor ³Ricardo Correa de Souza³ Data ³03.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Rotina que monta AxCadastro do Cadastro de Manutencao CIAP  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Coel Controles Eletricos Ltda                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

cCadastro := "Saldo ICMS CIAP"
aRotina   := {{"Pesquisar","AXPesqui",0,1},{"Visualizar","AXVisual",0,2}, ;
              {"Consultar",'ExecBlock("CFIS02I",.F.,.F.)',0,3}}

MBrowse( 06, 01, 22, 55, "SF9", , , , , 3 )

Return( .T. )  
