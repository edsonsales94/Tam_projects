#include "rwmake.ch"        

User Function Cfat37i()     


SetPrvt("NPOS,_CTES,_NPRCVEN,_NPRUNIT,_NMOEDA,_CMES")
SetPrvt("_NPERC,_NPRCMIN,")

/*/
®--------------------------------------------------------------------------@
| Programa  | CFAT37I  | Autor |Ricardo Correa de Souza| Data |07/11/2000  |
®--------------------------------------------------------------------------@
| Descricao | Calculo do Preco Minimo Moeda Nacional no Pedido de Venda    |
®--------------------------------------------------------------------------@
| Observacao| Gatilho Disparado no Campo C6_PRCVEN                         |
®--------------------------------------------------------------------------@
| Uso       | Coel Controles Eletricos Ltda                                |
®--------------------------------------------------------------------------@
|            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL              |
®--------------------------------------------------------------------------@
| Analista   |  Data  |             Motivo da Alteracao                    |
®--------------------------------------------------------------------------@
| Ricardo Correa³12/09/01³ Tratamento do Campo C6_MOEDA                    |
®--------------------------------------------------------------------------@
| Alteração, efetuada By Rogério, os usuários Durval e Daniel_SP podem     |
| alterar o valor unitário sem bloqueio mínimo                             | 
®--------------------------------------------------------------------------@

/*/
_cArea     := Alias()
_nRec      := Recno()
_cInd      := IndexOrd()
_lReturn   := .t.

	_nPorcent := 0
	
	If SM0->M0_CODIGO == "01"
		DbSelectArea("SZK")
		DbSetOrder(1)
		DbSeek(xFilial("SZK")+M->C5_CLATEND,.t.)
		
		If Found()
			
			_nPorcent := ZK_PORCENT
			_nPorcCli := GetAdvFVal("SA1","A1_DESC",xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,1,0)
			
			If (_nPorcent+_nPorcCli) < M->C5_DESC1
				msgstop("Desconto maior que o permitido para o usuario")
				_lReturn := .f.
			EndIf
		ElseIf M->C5_CLATEND == "Administrador       "
			_lReturn := .t.
		Else
			msgstop("O usuario "+M->C5_CLATEND+", nao esta cadastrado no cadastro de porcentagem por Usuario.")
			_lReturn := .f.
		EndIf
		
	EndIf
	
EndIf
