#include "rwmake.ch"

User Function Cfat23i()

SetPrvt("_CPROD,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT23I  ³ Autor ³Ricardo Correa de Souza³ Data ³07/03/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica o Status Produto no Pedido de Venda para Liberacao³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*

_cProd   := SB1->B1_COD

_cRot  := AllTrim(FunName())
                                                                                                        
If _cRot <> "RFATM01"
	
	If SA1->A1_RISCO$"E" .AND. ALLTRIM(SB1->B1_GRUPO)=="ESP"
		MsgBox("Produto Especial nao autorizado para o risco do Cliente","Validacao para Produtos Especiais","Stop")
		_cProd := Space(15)
		
	ElseIf SB1->B1_X_VENDA <> "S" .or. SB1->B1_CLSTATU == "F"
        If subs(cUsuario,7,15) $ "ELIZABETE PEDRA/Maeli Silva   /FERNANDO       /EDILSON        /Administrador  /BRANDAO       /VERA SOARES    "
			_cProd   := SB1->B1_COD
		Else
			MsgBox("Produto Bloqueado para Venda - Fora de Uso","Validacao Produtos Fora de Uso","Alert")
			_cProd := Space(15)
		EndIf
	ElseIf SB1->B1_CLSTATU == "E"
		MsgBox("Produto Sob Consulta, favor verificar com a Fabrica","Validacao Produtos Especiais","Alert")
	EndIf
	
EndIf

Return(_cProd)

*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
