	
#Include "Protheus.ch"

User Function MDFeOK()
Local lRet           := .T.                    //Retorno logico (.T./.F.)
Local _nOpc       := PARAMIXB[1]  //Operação 3 - Incluir / 4 - Alterar / 5 - Excluir
Local _cUFCarr   := PARAMIXB[2]  //UF Carregamento 
Local _cUFDesc  := PARAMIXB[3]  //UF Descarregamento
Local _cVeiculo  := PARAMIXB[4]  //Cod. Veiculo informado
Local _cVincPos := PARAMIXB[5]  //Vincula NF posterior? "1-Sim / 2-Não"

If _cUFCarr <> "SP"
     MsgInfo("Operação permitida apenas para UF de carregamento para estado de São Paulo.")
     lRet := .F.
EndIf

Return lRet
