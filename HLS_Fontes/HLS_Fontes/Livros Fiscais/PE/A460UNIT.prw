#INCLUDE "protheus.ch"

/*/{Protheus.doc} A460UNIT

O ponto de entrada permite a grava็ใo do arquivo de trabalho utilizado na impressใo do relat๓rio.

@type function
@author Winston D. de Castro
@since 23/08/10

@history 23/08/10, Zera os campos TOTAL, VALOR_UNIT e QUANTIDADE.
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA460UNIT  บAutor  ณWinston D. de Castroบ Data ณ  23/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณO ponto de entrada permite a grava็ใo do arquivo de trabalhoบฑฑ 
ฑฑบ          ณutilizado na impressใo do relat๓rio.O usuแrio pode regravar บฑฑ
ฑฑบ          ณos valores de acordo com suas necessidades. Os principais   บฑฑ
ฑฑบ          ณcampos do arquivo de trabalho que devem ser utilizados sใo: บฑฑ
ฑฑบ          ณTOTAL, VALOR_UNIT e QUANTIDADE.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Relatorio MATR460 (Relatorio do Inventario, Regi Modelo P7)บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A460UNIT()

	local cCod      := allTrim(ParamIXB[1]) && Codigo do Produto
	local cLocOrig  := ParamIXB[2] && Armazem do Saldo / Movimento
	local dDataFech := ParamIXB[3] && Data de Fechamento
	local cArqTemp  := ParamIXB[4] && Nome do Arquivo de Trabalho utilizado no Relatorio
	local nTotal    := 0
	local nVlrUnit  := 0
	local nQuant    := 0
	
	&& ajustes realizados pelo cliente para os campos TOTAL, VALOR_UNIT e QUANTIDADE, que serใo utilizado na composi็ใo do relatorio.
	if cCod $ "Q2180099500090/TMOOH CAIXA MAC/MMANUT178/MISC-001/MISC-002/TMODM COBERTURA/TMOOHCAIXA BASE/OU-001/Z0GAR72180TM0/CX590X392X230MA"
		TOTAL      := 0
		VALOR_UNIT := 0
		QUANTIDADE := 0
	endif

return