#include "Protheus.ch"
#include "RWMAKE.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Mta455p บAutor ณRonaldo Gomes - Totvs บ Data ณ  23/10/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada para Bloquear a Liberacao Manual do       บฑฑ
ฑฑบ          ณ Credito/ Estoque.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verifica se o Estoque podera ficar negativo e bloqueia a   บฑฑ
ฑฑบ			 ณ liberacao manual                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Mta455p()
	//Declara as Variaveis utilizadas na Rotina                                  ณ

	Local lRetorno := .F. 
	Local cSalEst  := 0
	Local cSalLib  := GetMv("MV_XSALLIB")
	Local cEstNeg  := GetMv("MV_ESTNEG")

	//Verificacao do Estoque

	cSalEst := CalcEst(C9_PRODUTO,C9_LOCAL,(DDATABASE+1))             

	If cEstNeg == "N"  .AND. cSalEst[1] <  1 .AND. cSalLib == "S"

		Aviso( "Aten็ใo !" , "Libera็ใo Manual de Estoque nใo Permitida ! O sistema estแ configurado para que nใo se permita a libera็ใo de estoque sem que haja saldo no sistema !" , {"Ok"} , 1 , "Liberacao nใo Permitida ! " )

	Else

		lRetorno := .T.

	Endif   

Return (lRetorno)     