User Function Atpedcond()
Local Acondpap := ""
M->C5_TABELA := SE4->E4_TABELA
Acondpap := IIF(MaVldTabPrc(M->C5_TABELA,M->C5_CONDPAG,,M->C5_EMISSAO) .And. A410ReCalc()  ,SE4->E4_TABELA,SE4->E4_TABELA)   

return (Acondpap)