#include "rwmake.ch"

User Function Cfat60I()


SetPrvt("NPOS,_CTES,_NPRCVEN,_NPRUNIT,_NMOEDA,_CMES")
SetPrvt("_NPERC,_NPRCMIN,_nValdesc,_ndesc")

/*/
®--------------------------------------------------------------------------@
| Programa  | CFAT60I  | Autor |Ricardo Correa de Souza| Data |07/11/2000  |
®--------------------------------------------------------------------------@
| Descricao | Determina o desconto 2 no pedido                             |
®--------------------------------------------------------------------------@
| Observacao| Gatilho Disparado no Campo C5_DESC2                          |
®--------------------------------------------------------------------------@
| Uso       | Coel Controles Eletricos Ltda                                |
®--------------------------------------------------------------------------@
|            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL              |
®--------------------------------------------------------------------------@
| Analista   |  Data  |             Motivo da Alteracao                    |
®--------------------------------------------------------------------------@


/*/
_cArea     := Alias()
_nRec      := Recno()
_cInd      := IndexOrd()
_lReturn   := .t.
_user	   := RetCodUsr()
_cNousr    := UsrRetName(_user)
_nPorcent  := 0
_nPrcVen   := 0
_nPrUnit   := 0                                                         


nPos       := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_DESCONT"})
_ndesc	   := aCols[n,nPos]

nPos       := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_VALDESC"})
_nValdesc  := aCols[n,nPos]


DbSelectArea("SZK")
DbSetOrder(1)
//DbSeek(xFilial("SZK")+M->C5_CLATEND,.t.)
DbSeek(xFilial("SZK")+_cNousr,.t.)

If Found()
	
		_nPorcent := ZK_PORCENT
		_nPorcCli := GetAdvFVal("SA1","A1_DESC",xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,1,0)
		
	If M->C5_DESC2 > 0
		 If M->C5_DESC2 > _nPorcent
			msgstop("Desconto maior que o permitido para o usuario")
			//Return(_nPorcent)
			Return(.F.)
		 Endif
	Endif
		        
	if _ndesc >0 .OR. M->C6_DESCONT >0 
		If  round(_ndesc,2) > _nPorcent 
			msgstop("Desconto maior que o permitido para o usuario")
			//Return(_nPorcent)
			M->C6_DESCONT = 0
			M->C6_VALDESC = 0
			Return(.F.)
	    else
		    If  M->C6_DESCONT > _nPorcent
				msgstop("Desconto maior que o permitido para o usuario")
				//Return(_nPorcent)
				M->C6_DESCONT = 0
				M->C6_VALDESC = 0
				Return(.F.)
			Endif
	    Endif
	Endif
			
	
ElseIf M->C5_CLATEND == "Administrador       "
	   Return(.T.)
Else
	   msgstop("O usuario "+_cNousr+", nao esta cadastrado no cadastro de porcentagem por Usuario.")
	   Return(.F.)
EndIf



dbSelectArea(_cArea)
dbSetOrder(_cInd)
dbGoto(_nRec)

Return(_lReturn)


/*#########################################################################################################*/

#include "rwmake.ch"

User Function Cfat60Ib()


SetPrvt("NPOS,_CTES,_NPRCVEN,_NPRUNIT,_NMOEDA,_CMES")
SetPrvt("_NPERC,_NPRCMIN,_nValdesc,_ndesc")

/*/
®--------------------------------------------------------------------------@
| Programa  | CFAT60I  | Autor |Ricardo Correa de Souza| Data |07/11/2000  |
®--------------------------------------------------------------------------@
| Descricao | Determina o desconto 2 no pedido                             |
®--------------------------------------------------------------------------@
| Observacao| Gatilho Disparado no Campo C5_DESC2                          |
®--------------------------------------------------------------------------@
| Uso       | Coel Controles Eletricos Ltda                                |
®--------------------------------------------------------------------------@
|            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL              |
®--------------------------------------------------------------------------@
| Analista   |  Data  |             Motivo da Alteracao                    |
®--------------------------------------------------------------------------@


/*/
_cArea     := Alias()
_nRec      := Recno()
_cInd      := IndexOrd()
_lReturn   := .t.
_user	   := RetCodUsr()
_cNousr    := UsrRetName(_user)
_nPorcent  := 0
_nPrcVen   := 0
_nPrUnit   := 0
_nPrCgua   := 0                                                         
_nQtdVen   := 0

nPos       := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_DESCONT"})
_ndesc	   := aCols[n,nPos]

nPos       := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_VALDESC"})
_nValdesc  := aCols[n,nPos]


//nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_PRCVEN"})
//_nPrUnit := aCols[n,nPos]   
 
nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_PRUNIT"})
_nPrcVen := aCols[n,nPos]

nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_QTDVEN"})
_nQtdVen := aCols[n,nPos]



_nPrUnit :=(_nPrcVen * M->C5_DESC1 / 100)* _nQtdVen 


DbSelectArea("SZK")
DbSetOrder(1)
//DbSeek(xFilial("SZK")+M->C5_CLATEND,.t.)
DbSeek(xFilial("SZK")+_cNousr,.t.)

If Found()
	
		_nPorcent := ZK_PORCENT
		_nPorcCli := GetAdvFVal("SA1","A1_DESC",xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,1,0)
		
		If _nValdesc >0 .or. M->C6_VALDESC > 0
			
			If round(_nValdesc /_nPrUnit *100,2) > _nPorcent
				msgstop("Desconto maior que o permitido para o usuario")
				//Return(_nPorcent)
				M->C6_DESCONT = 0
				M->C6_VALDESC = 0 
				M->C6_PRCVEN  = _nPrcVen * M->C5_DESC1 / 100
				_nValdesc	  = 0
				Return(.F.)    
			elseif round(M->C6_VALDESC /_nPrUnit *100,2) > _nPorcent
					msgstop("Desconto maior que o permitido para o usuario")
					//Return(_nPorcent)
					M->C6_DESCONT = 0
					M->C6_VALDESC = 0 
					M->C6_PRCVEN  = _nPrcVen * M->C5_DESC1 / 100
					_nValdesc	  = 0
					Return(.F.)
				
			Endif
/*			If _nValdesc >0
				M->C6_DESCONT := round(_nValdesc /_nPrUnit *100,2) > _nPorcent
			Else
				M->C6_DESCONT :=round(M->C6_VALDESC /_nPrUnit *100,2) > _nPorcent
			Endif
*/			
			 
		EndIf	
	
ElseIf M->C5_CLATEND == "Administrador       "
	   Return(.T.)
Else
	   msgstop("O usuario "+_cNousr+", nao esta cadastrado no cadastro de porcentagem por Usuario.")
	   Return(.F.)
EndIf



dbSelectArea(_cArea)
dbSetOrder(_cInd)
dbGoto(_nRec)

Return(_lReturn)







