#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/11/02

User Function RFAT45I()        // incluido pelo assistente de conversao do AP6 IDE em 02/11/02

SetPrvt("C_SVSCEST,LPERG,_CPRODUTO,_CLOCAL,_DDATA,_NVALORUN")
SetPrvt("_NQTD,_CKEY_TOT,_CIND_TOT,")

/*/
@---------------------------------------------------------------------------@
| Programa  | RFAT45I  | Autor|Rogerio Batista         | Data |05.12.2002   |
@---------------------------------------------------------------------------@
| Descricao | Programa para transferir o preco da tabela 01 "DA1" para o    |
|           | cadastro dos produtos "SB1"                                   |
@---------------------------------------------------------------------------@
| Uso       | Especifico                                                    |
@---------------------------------------------------------------------------@
/*/

If !MsgBox("Esta  rotina  ira transportar o preco de venda da tabela 01"+Chr(13);
	+"para o cadastro dos produtos ","Transporte de precos","YesNo")
	Return
EndIf

PROCESSA({|| _ProcArq()},"Processa Arquivos...")
Return()

Static Function _ProcArq()

dbSelectArea("DA1")
dbSetOrder(1)
dbGotop()

_cProduto := ""
_nPreco   := 0

ProcRegua(Reccount())

While !Eof() .and. DA1_CODTAB $ "003"
	
	IncProc()

	_cProduto := DA1->DA1_CODPRO
	_nPreco   := DA1->DA1_PRCVEN
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xfilial("SB1")+_cProduto)
	
	If Found()
		
		RecLock("SB1",.F.)
		SB1->B1_PRV1 := _nPreco
		MsUnlock()
		
	EndIf
	
	dbSelectArea("DA1")
	dbSkip()
	
EndDo

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Retorno index e apaga index temporario                       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("SB1")
RetIndex("SB1")

Return
