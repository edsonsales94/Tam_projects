#include "rwmake.ch"

User Function CORC60I()
			
SetPrvt("NPOS,_CTES,_NPRCVEN,_NPRUNIT,_NMOEDA,_CMES")
SetPrvt("_NPERC,_NPRCMIN,")

/*/
®--------------------------------------------------------------------------@
| Programa  | CORC60I  | Autor |Andre Rodrigues        | Data |07/11/2000  |
®--------------------------------------------------------------------------@
| Descricao | Determina o desconto 2 no pedido                             |
®--------------------------------------------------------------------------@
| Observacao| Gatilho Disparado no Campo CJ_DESC2                          |
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
_nPorcent := 0
_nPrUnit  := 0


	DbSelectArea("SZK")
	DbSetOrder(1)
	DbSeek(xFilial("SZK")+_cNousr,.t.)
	//DbSeek(xFilial("SZK")+Alltrim(_user),.t.)
	If Found()
		
		_nPorcent := ZK_PORCENT
		_nPorcCli := GetAdvFVal("SA1","A1_DESC",xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA,1,0)
		
		If M->CJ_DESC2 > 0
			If M->CJ_DESC2 > _nPorcent
				msgstop("Desconto maior que o permitido para o usuario")
				//Return(_nPorcent)
				Return(.F.)
	        Endif
	    Endif
	        
		if TMP1->CK_DESCONT >0
			If  round(TMP1->CK_DESCONT,2) > _nPorcent
				msgstop("Desconto maior que o permitido para o usuario")
				//Return(_nPorcent)
				TMP1->CK_DESCONT = 0
				TMP1->CK_VALDESC = 0
				Return(.F.)
		    Endif
		 Endif
		

	ElseIf M->CJ_CLATEND == "Administrador       "
	   Return(.T.)
	Else
		msgstop("O usuario "+_cNousr+", nao esta cadastrado no cadastro de porcentagem por Usuario.")
	   Return(_nPorcent)
	EndIf


dbSelectArea(_cArea)
dbSetOrder(_cInd)
dbGoto(_nRec)

Return(_lReturn)

/*#############################################################################################################################*/


#include "rwmake.ch"

User Function CORC60Ib()
			
SetPrvt("NPOS,_CTES,_NPRCVEN,_NPRUNIT,_NMOEDA,_CMES")
SetPrvt("_NPERC,_NPRCMIN,")

/*/
®--------------------------------------------------------------------------@
| Programa  | CORC60I  | Autor |Andre Rodrigues        | Data |07/11/2000  |
®--------------------------------------------------------------------------@
| Descricao | Determina o desconto 2 no pedido                             |
®--------------------------------------------------------------------------@
| Observacao| Gatilho Disparado no Campo CJ_DESC2                          |
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
_nPorcent := 0
_nPrUnit  := 0


	DbSelectArea("SZK")
	DbSetOrder(1)
	DbSeek(xFilial("SZK")+_cNousr,.t.)
	//DbSeek(xFilial("SZK")+Alltrim(_user),.t.)
	If Found()
		
		_nPorcent := ZK_PORCENT
		_nPorcCli := GetAdvFVal("SA1","A1_DESC",xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA,1,0)
		     
		If TMP1->CK_VALDESC >0
			If round(TMP1->CK_VALDESC /TMP1->CK_PRUNIT *100,2) > _nPorcent
				msgstop("Desconto maior que o permitido para o usuario")
				//Return(_nPorcent)
				TMP1->CK_DESCONT = 0
				TMP1->CK_VALDESC = 0
				Return(.F.)    
			Endif 
		EndIf
	ElseIf M->CJ_CLATEND == "Administrador       "
	   Return(.T.)
	Else
		msgstop("O usuario "+_cNousr+", nao esta cadastrado no cadastro de porcentagem por Usuario.")
	   Return(_nPorcent)
	EndIf


dbSelectArea(_cArea)
dbSetOrder(_cInd)
dbGoto(_nRec)

Return(_lReturn)
