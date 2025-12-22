#INCLUDE "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INCTBE02   ¦ Autor ¦ jean vicente         ¦ Data ¦ 03/02/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ ExecBlock para ajuste do rateio do lançamento padrão          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INCTBE02(cPrefixo, cTitulo, cParcela, cTipo, cFornecedor, cLoja, nPercentual)
	Local nIndex := SE2->(IndexOrd())
	Local nRecno := SE2->(Recno())
	Local nRet   := 0
	
	SE2->(dbSetOrder(1))
	If SE2->(dbseek(xFilial("SE2")+cPrefixo+cTitulo+cParcela+cTipo+cFornecedor+cLoja))
		nRet := nPercentual * (SE2->E2_ISS + SE2->E2_IRRF + SE2->E2_INSS + SE2->E2_CSLL + SE2->E2_PIS + SE2->E2_COFINS)
	Endif
	SE2->(dbSetOrder(nIndex))
	SE2->(dbGoTo(nRecno))
	
Return nRet
