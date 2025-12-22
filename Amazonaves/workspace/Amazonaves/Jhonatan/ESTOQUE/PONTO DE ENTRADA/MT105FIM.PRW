#INCLUDE 'PROTHEUS.CH'

User Function MT105FIM()

Local cNumero:= SCP->CP_NUM
Local lMarkB     := .F.   // Indica se a rotina deve avaliar a selecao da Markbrowse ou deve avaliar todos os registros
Local lDtNec     := .F.   // Indica se a rotina deve ser avaliada por data de necessidade ou por data de emissao
Local bFiltro    := Nil   // Expressao de filtro a ser avaliada para cada registro do SCP.
Local lConsSPed  := .F.   // Indica se considera ou nao Prev.Entrada (SC) (OPC) DEFAULT = .F.
Local lGeraSC1   := .F.   // Indica se a rotina devera gerar ou nao Solicitacao de Compras no SC1
Local lAmzSA     := .T.   // Considera Armazem da SA
Local cSldAmzIni := "  "  // Saldo do Armazem a considerar a necessidade
Local cSldAmzFim := "ZZ"  // Saldo ate o Armazem a considerar a necessidade
Local lLtEco     := Nil   // Considerar o Lote Economico na geracacao da SC
Local lConsEmp   := Nil   // Considerar o saldo ja empenhado qdo baixa de OP
Local nAglutSC   := Nil   // Indica se aglutina ou nao as SC's  (OPC) DEFAULT = 1
Local lAuto      := Nil
Local lEstSeg    := Nil
Local aRecSCP    := Nil
Local lRateio    := Nil

	
	Private cMarca    := GetMark()
	Private __cFiltro := " AND CP_NUM = '"+cNumero+"'"
	
	SCP->(dbSetOrder(1))
	SCP->(dbSeek(SCP->(XFILIAL("SCP")+cNumero),.T.))    // Reposiciona no 1o item
	
	u_fConout("["+Dtoc(dDataBase)+" "+Time()+"] >>> Gerando a Pre-requisicao" )
	
	A106PreReq( lMarkB, lDtNec, bFiltro, lConsSPed, lGeraSC1, lAmzSA, cSldAmzIni, cSldAmzFim, lLtEco, lConsEmp, nAglutSC, lAuto, lEstSeg, aRecSCP ,lRateio)

Return
