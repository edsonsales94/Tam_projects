#Include "Protheus.ch"

// EM OPÇÕES NA SX3 NO CAMPO X3_CBOX CHAMAR A FUNÇÃO #u_OpAquis() INICIANDO COM #
User Function OpAquis()
    Local cOpcoes := ""

    cOpcoes += "01=Compra por Outros Sistemas;"
    cOpcoes += "02=Adjudicação;"
    cOpcoes += "03=Compra Direta Eletrônica;"
    cOpcoes += "04=Dispensa de Licitação;"
    cOpcoes += "05=Pregão Eletrônico;"
    cOpcoes += "06=Pregão Presencial;"
    cOpcoes += "07=Doação;"
    cOpcoes += "08=Desapropriação;"
    cOpcoes += "09=Ata de Registro de Preços;"
    cOpcoes += "10=Compra Direta;"
    cOpcoes += "11=Implantação de Sistema;"
    cOpcoes += "12=Compra;"
    cOpcoes += "13=Licitação;"
    cOpcoes += "14=Carta Convite;"
    cOpcoes += "17=Uso Capião;"
    cOpcoes += "18=Memorial Descritivo;"
    cOpcoes += "19=Terra Devoluta;"
    cOpcoes += "20=Comodato;"
    cOpcoes += "21=Inexigibilidade de Licitação;"
    cOpcoes += "22=Permuta;"
    cOpcoes += "23=Dação de Pagamento;"
    cOpcoes += "25=Compra de Ata Externa;"
    cOpcoes += "26=Cessão/Empréstimo;"
    cOpcoes += "27=Incorporação;"
    cOpcoes += "28=Comparação de Preços;"
    cOpcoes += "29=Reavaliação"

Return cOpcoes
