#INCLUDE "RWMAKE.CH"

User Function A690DATPR()

Local cNum      := PARAMIXB[1]	// Numero da Ordem de Produção           
Local cItem     := PARAMIXB[2]	// Item da Ordem de Produção          
Local cSequen   := PARAMIXB[3]	// Sequencia           
Local dDATPRI   := PARAMIXB[4]  // Data Previsao Inicio da OP
Local dDATPRF   := PARAMIXB[5]  // Data Previsao Final  da OP
Local lAlocFim  := PARAMIXB[6]  // Parametro alocacao pelo fim
Local aRet		:= {}       //-- Customizações do usuário                   
 
    Aadd(aRet, {dDATPRI, dDATPRF})
 
 Return aRet
