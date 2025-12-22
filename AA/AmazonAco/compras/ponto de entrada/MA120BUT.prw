#INCLUDE "PROTHEUS.CH"
#include "colors.ch"

User Function MA120BUT
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Função de Inclusao de Butões na Tela de Pedido de Compras
OBJETIVO 1: Incluir o Botao de CONSUMO MEDIO - SB3        
OBJETIVO 2: Incluir o Botao de CONSULTA DE ESTOQUE - SB2
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/


Local _aMyBtn := {}
Local oGetDados 

//aButtons[x][1] = String com o nome do bitmap padrao incluido na dll padrao do SIGA.
//aButtons[x][2] = Bloco de codigo com a função a executar (pode ser um execblock, fun?ao SIGA,etc.).
//aButtons[x][3] = Texto a ser exibido na legenda do Botão.
//aButtons[x][4] = Texto a ser exibido abaixo do bitmap.

Aadd(_aMyBtn, {"S4WB005N", { ||MATA210() }  , OemToAnsi( 'Consumos Médios' ) } )
Aadd(_aMyBtn, { "BUDGET" , { ||MT103B2() }  , OemToAnsi( 'Consulta o Saldo do Produto' ) } )
//aadd(_aMyBtn, {'BUDGETY' , { ||U_AACOMP02()}, OemToAnsi('Consulta Itens') })
                                       
Return( _aMyBtn )


Static Function MT103B2   // Consulta de Estoque
Local _cCodigo := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_PRODUTO"})

If _cCodigo > 0
	MaViewSB2( Acols[n][_cCodigo] )
Else
	MsgAlert("Informe um Produto !!!","ATENÇÃO")
EndIf	

Return NIL

Eval( bREFRESH )
SX3->(RestArea(aAreaSX3))
RestArea(aArea)

Return NIL