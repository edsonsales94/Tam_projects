#Include 'Protheus.ch'
/*
Descricao : POnto de Entrada Desenvolvido para Modificar o Tipo Para AE para a rotina padrao poder processar o registro normalmente e em seguida
            Retornar para RV
            O ponto se encontra no inicio das funções A097LIBERA, A097SUPERI e A097TRANSF , 
            não passa parametros e não envia retorno, usado conforme necessidades do usuario para diversos fins.
            
*/
User Function MT097LIB()
  Local cVar  := Alltrim(SCR->CR_NUM)+'RV'

Return Nil

Static Function LIBAPROV(cNumero)
  SC7->(dbSetOrder(1))
  If !sc7->(dbSeek(xFilial("SC7")+cNumero))
      SC7->(RecLock('SC7',.T.))
       SC7->C7_FILIAL := xFilial("SC7")
       SC7->C7_NUM    := cNumero
       SC7->C7_OBS    := 'REQDRO'
      SC7->(MsUnlock()) 
  EndIf
Return 
