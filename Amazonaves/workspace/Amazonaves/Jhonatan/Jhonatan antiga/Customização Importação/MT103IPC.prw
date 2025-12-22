//CARREGA CAMPOS CUSTOMIZADOS DA TABELA SC7 AO IMPORTAR UM PEDIDO DE COMPRA
User Function MT103IPC
    _nLinha := PARAMIXB[1]
    _cDescr := SC7->C7_DESCRI
    _cPartnu:= SC7->C7_XPARTNU

    aCols[_nLinha][GdFieldPos("D1_XDESC")]   :=_cDescr
    aCols[_nLinha][GdFieldPos("D1_XPARTNU")] :=_cPartnu

Return(.t.)
