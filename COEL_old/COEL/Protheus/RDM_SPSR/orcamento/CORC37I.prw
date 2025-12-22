#include "rwmake.ch"        

User Function Corc37i()     


SetPrvt("NPOS,_CTES,_NPRCVEN,_NPRUNIT,_NMOEDA,_CMES")
SetPrvt("_NPERC,_NPRCMIN,")

/*/
®--------------------------------------------------------------------------@
| Programa  | CFAT37I  | Autor |Andre Rodrigues        | Data |29/07/2015  |
®--------------------------------------------------------------------------@
| Descricao | Calculo do Preco Minimo Moeda Nacional no Pedido de Venda    |
®--------------------------------------------------------------------------@
| Observacao| Gatilho Disparado no Campo CK_PRCVEN                         |
®--------------------------------------------------------------------------@
| Uso       | Coel Controles Eletricos Ltda                                |
®--------------------------------------------------------------------------@
|            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL              |
®--------------------------------------------------------------------------@
| Analista   |  Data  |             Motivo da Alteracao                    |
®--------------------------------------------------------------------------@
| Ricardo Correa³12/09/01³ Tratamento do Campo CK_MOEDA                    |
®--------------------------------------------------------------------------@
| Alteração, efetuada By Rogério, os usuários Durval e Daniel_SP podem     |
| alterar o valor unitário sem bloqueio mínimo                             | 
®--------------------------------------------------------------------------@

/*/


//nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "CK_TES"   })
//_cTes    := aCols[n,nPos]
_cTes    := TMP1->CK_TES

//nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "CK_PRCVEN"})
//_nPrcVen := aCols[n,nPos]
_nPrcVen := TMP1->CK_PRCVEN

//nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "CK_PRUNIT"})
//_nPrUnit := aCols[n,nPos]
_nPrUnit :=TMP1->CK_PRUNIT

//nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "CK_MOEDA" })
//_nMoeda  := aCols[n,nPos]
_nMoeda  := TMP1->CK_MOEDA

_nPrcMin1 := 0
_nPrcMin2 := 0

If Subs(cUsuario,7,15) $ "GUILHERME      /RAFAEL         /ADMINISTRADOR  /EDSON          "
	Return(_nPrcVen)
Else
	//If  M->C5_TIPO == "N"
		If _nMoeda == 1
			If _cTes $ SuperGetMv("MV_X_CFOP")// "501/502/503/504/505/508/509/701/706/575/717"
				_cMes := Subs(Dtos(dDataBase),5,2)
		  		
   //				_nPerc := Val(Tabela("Z1",_cMes,.f.))
				
//				_nPrcMin := _nPrUnit * ((100 - _nPerc)/100)
			     
			    If !Empty(M->CJ_DESC1)
    	            _nPrcMin1 := _nPrUnit * ((100 - M->CJ_DESC1)/100)
    			    If !Empty(M->CJ_DESC2)
    	            _nPrcMin2 := _nPrcMin1 * ((100 - M->CJ_DESC2)/100) 
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
	//Endif
	
	Return(_nPrcVen)
	
EndIf
