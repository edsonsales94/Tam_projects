/*
Rotina que gera o codigo do produto a partir do grupo informado, a função abaixo
verifica se a descricao do grupo ja foi informada e acrescenta 1 no final do sequencial.
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCOMG01  ºAutor  ³Microsiga           º Data ³  08/25/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Rotina que gera o codigo do produto a partir do grupo     º±±
±±º          ³ Informado                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function INCOMG01()
local cCod := space(15)  
local cDesc

    dbSelectArea("SBM")
	dbsetOrder(1)
	dbSeek(xFilial("SBM")+M->B1_GRUPO)  //Posiciona na Tabela de Grupo de Produtos 
	                                    //para o obter a Descricao
	cDesc := STRTRAN(SUBSTR(SBM->BM_GRUPO,1,9)," ","")    //Obtem a Descricao do Grupo
	cControl := M->B1_COD
	    
    dbSelectArea("SB1")
    dbSetOrder(1)
	
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
	 
Return(cCod)  
