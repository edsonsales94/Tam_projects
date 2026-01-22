#Include "rwmake.ch"
#INCLUDE "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ EDTMSE03   ¦ Autor ¦ Jhonatan S. Lobato   ¦ Data ¦ 19/12/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inf. valor abastecimento e inf. decrescimo no contas a receb. ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function EDTMSE03()

Local aPergs   := {}
Local nQuant   := 0
Local nValor   := 0
Local cFatura  := ""

PRIVATE lMsErroAuto := .F.
 
aAdd(aPergs, {1, "Qtde Abastecimento",  nQuant,  "@E 999,999",     "Positivo()", "", ".T.", 80,  .F.})
aAdd(aPergs, {1, "Valor Abastecimento", nValor,  "@E 999,999.99",  "Positivo()", "", ".T.", 80,  .F.})
aAdd(aPergs, {1, "Faturas",             cFatura, "", 			   ".T.", 		 "", ".T.", 80,  .F.})

 
If ParamBox(aPergs, "Informe os parametros")
    nQuant := MV_PAR01
    nValor := MV_PAR02
	nFatura:= MV_PAR03

    // Atualiza o campo DTQ_XABAST
    If RLock() // Tenta bloquear o registro atual
        DTQ->DTQ_XABAST := nQuant // Altera o valor do campo
        DTQ->DTQ_XVABAS := nValor // Altera o valor do campo
		DTQ->DTQ_XFATAB := cFatura // Altera o valor do campo
        DbCommit()                  // Confirma a gravacao no banco de dados
        DbUnlock()                  // Desbloqueia o registro

		u_ELOBJP01(2) // alterar a viajem.
		
        Conout("Atualizado o valor do abastecimento.")
    Else
        Alert("Nao foi possí­vel atualizar o valor do abastecimento.")
    EndIf

            DT6->(dbSetorder(20))
			If DT6->(dbSeek(xFilial("DT6")+DTQ->(DTQ_FILORI+DTQ_VIAGEM)))
				DbselectArea("SE1")
				SE1->(DbSetOrder(1))
				If SE1->(dbSeek(xFilial("SE1")+DT6->(DT6_SERIE+DT6_DOC)))
				 
					
			    	lMsErroAuto := .F.
					aRotAuto := {}

					AAdd( aRotAuto, { "E1_NUM"    , SE1->E1_NUM, NIL } )
					AAdd( aRotAuto, { "E1_PREFIXO", SE1->E1_PREFIXO, NIL } )
					AAdd( aRotAuto, { "E1_TIPO"   , SE1->E1_TIPO , NIL } )
					AAdd( aRotAuto, { "E1_DECRESC", nValor , NIL } )

					MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto,  4 )
					
					If lMsErroAuto
						MostraErro()
					else 
						Conout("Desconto combustivel aplicado com sucesso no contas a receber")
					endif
				EndIf	

			Endif
			SE1->(dbCloseArea())



Else
    Alert("Operacao cancelada pelo usuario.")    


EndIf

Return
