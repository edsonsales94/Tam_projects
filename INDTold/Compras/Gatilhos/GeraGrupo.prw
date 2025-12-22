/*
 Rotina que gera o codigo do grupo a partir do tipo escolhido.
*/

User Function GeraGrupo()
  local cCod   := space(4)  
  local cAlias := select()
  cCod:= UltimoGrupo()  
  dbselectarea(cAlias)
Return(cCod)  

/////////////////////////////
Static Function UltimoGrupo

  Local cQuery,cMaxGrp

  //- Verificando a ultima sequencia do rateio gravada
  cQuery:= "SELECT ISNULL(MAX(BM_GRUPO),0) CONTA FROM "+RetSQLName("SBM")+" WHERE D_E_L_E_T_<>'*' AND "
  cQuery+= "BM_FILIAL='" + XFILIAL("SBM") + "' AND "     
  cQuery+= "BM_TIPGRU='" + M->BM_TIPGRU + "'"     
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
                                   
  cMaxGrp:= StrTran(Substr(CONTA,1,2)+StrZero(Val(Substr(CONTA,3,2))+1,2)," ","0")
    
  dbCloseArea()  
  
Return cMaxGrp 
