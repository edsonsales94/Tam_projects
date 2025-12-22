#Include "rwmake.ch"

/*/
---------------------------------------------------------------------------------------------------------------------------------------------------
Execblock acionado na LR_ENTBRAS - TRANSFERÊNCIA ENTRE LOJAS NA VENDA ASSISTIDA
OBJETIVO 1: Não permitir que seja escolhido mais de uma Filial no Orçamento
----------------------------------------------------------------------------------------------------------------------------------------------------
/*/

User Function VFilEnt()

nEntBRAS    := AScan( aHeader , {|x| Trim(x[2]) == "LR_ENTBRAS" })
nQuant	 	:= Ascan(aHeader  , {|x| Trim(x[2]) == "LR_QUANT"	})

If n > 1
	
	If aCols[N][nEntBras] <> aCols[n-1][nEntBras]
		Aviso("Atenção","Somente é permitido uma Loja por Orçamento !!!",{"OK"},2)
		aCols[N][nEntBras] := aCols[n-1][nEntBras]
		aCols[N][nQuant]   := 0
	Endif
	
EndIf

Return(aCols[N][nEntBras])