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


nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_TES"   })
_cTes    := aCols[n,nPos]

nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_PRCVEN"})
_nPrcVen := aCols[n,nPos]

nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_PRUNIT"})
_nPrUnit := aCols[n,nPos]

nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_MOEDA" })
_nMoeda  := aCols[n,nPos]

_nPrcMin1 := 0
_nPrcMin2 := 0

If Subs(cUsuario,7,15) $ "GUILHERME      /RAFAEL         /ADMINISTRADOR  /EDSON          "
	Return(_nPrcVen)
Else
	If  M->C5_TIPO == "N"
		If _nMoeda == 1
			If _cTes $ SuperGetMv("MV_X_CFOP")// "501/502/503/504/505/508/509/701/706/575/717"
				_cMes := Subs(Dtos(dDataBase),5,2)
		  		
   //				_nPerc := Val(Tabela("Z1",_cMes,.f.))
				
//				_nPrcMin := _nPrUnit * ((100 - _nPerc)/100)
			     
			    If !Empty(M->C5_DESC1)
    	            _nPrcMin1 := _nPrUnit * ((100 - M->C5_DESC1)/100)
    			    If !Empty(M->C5_DESC2)
    	            _nPrcMin2 := _nPrcMin1 * ((100 - M->C5_DESC2)/100) 
    	            Else
    	            _nPrcMin2 :=_nPrcMin1
                    EndIf
    	            
                EndIf
   	
				If _nPrcVen < _nPrcMin2 .And. cNivel < 8
					MsgBox("Atencao Sr. "+Subs(cUsuario,7,13)+", o preco digitado esta abaixo do preco calculado com o desconto maximo. O sistema assumira o preco minimo para este item.","Preco Minimo Calculado - R$"+Str(Round(_nPrcMin2,2)),"Alert")
					_nPrcVen := _nPrcMin2
				EndIf
			EndIf
		EndIf
	Endif
	
	Return(_nPrcVen)
	
EndIf
