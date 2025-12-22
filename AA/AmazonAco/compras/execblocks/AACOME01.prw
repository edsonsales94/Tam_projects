
User Function AACOME01()
   Local cdNomeCliFor := IIF(M->DB1_TIPO="1",Posicione("SA1",1,xFilial("SA1")+M->DB1_CLIFOR+M->DB1_LOJA,"A1_NOME"), Posicione("SA2",1,xFilial("SA2")+M->DB1_CLIFOR+M->DB1_LOJA,"A2_NOME"))
Return cdNomeCLiFor
