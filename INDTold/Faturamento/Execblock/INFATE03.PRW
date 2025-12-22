/*
Rotina que gera o codigo do produto a partir do grupo informado, a função abaixo
verifica se a descricao do grupo ja foi informada e acrescenta 1 no final do sequencial.
*/
User Function INFATE03()
local cCod   := space(15)  
Local aArea  := GetArea()
local cTable := GetNextAlias()

cQry := " select isNull( MAX(B1_COD),'" + Alltrim(M->B1_GRUPO) + "' + '0000000') B1_COD FRom " + RetSqlName('SB1')
cQry += " WHere D_E_L_E_T_ = ''
cQry += " And B1_GRUPO = '" + M->B1_GRUPO + "'
	//para o obter a Descricao

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),cTable,.T.,.T.)
cCod := Soma1(Alltrim( (cTable)->B1_COD ) )
(cTable)->(dbCloseArea(cTable))

RestArea(aArea)
/*
IF dbseek(xFilial("SB1")+cDesc,.T.)  //Checa se existe codigos referentes ao Grupo em questao
  	  	nTam := Len(cDesc) 
	   
	    while SUBSTR(SB1->B1_COD,1,nTam) == cDesc  //Pesquisa no SB1 o ultimo codigo do Grupo em questao
	          dbSkip()
	    Enddo      
	   
	    dbSkip(-1) //Volta um registro para obter a parte numerica do Codigo
	   
	    nValor := Val(SubStr(SB1->B1_COD, nTam+1,6)) + 1 //VAL(RIGHT(SB1->B1_COD,6)) + 1 //Acumula mais um para o novo codigo
	    cCod := cDesc + StrZero(nValor,6) //Forma o novo codigo para o Produto
	   
	ELSE 
        cCod := cDesc + "000001"
	ENDIF
 */	 
Return(cCod)
