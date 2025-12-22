#Include "rwmake.ch"

User Function LJ7032()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto de entrada para vaAlidar o acesso a tela de atendimento da Venda Assistida. Quando o retorno for falso, não permite que o usuário passe adiante
do browse.
OBJETIVO 1: Chamada para verificar os Orçamentos com o Status RECEBER NO LOCAL, somente os usuários que estão definidos no parâmetro MV_USRRECL poderão Finalizar o Orçamento.
OBJETIVO 2: Controle de Senha para Visualização e Finalização do Orçamento
OBJETIVO 3: Restaurar os valores originais na alteração do Orçamento, caso a venda seja para PRODUTOR RURAL
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/
cNome    := GETMV("MV_USRRECL")
nLastKe2 := 0
lRet     := .T.
cCodSup  := Space(06)

If (ParamIxb[1] == 2 .Or. ParamIxb[1] == 4) .And. SubStr(SLF->LF_ACESSO,3,1) == "N"   // Somente Vendedores
	
	SA3->(DbSetOrder(7))  // Cod. Usuário
	If SA3->(DbSeek(xFilial("SA3")+__cUserID))
		cCodSup 	:= SA3->A3_CODUSR
	EndIf
	SA3->(DbSetOrder(1))  // Cod. Vendedor
	
	If ! __cUserID $ cCodSup //Código de Vendedores superiores, verifica se usuário do sistema é um vendedor SUPERIOR e desconsidera a senha
	
							//Solicita Senha se a opção for Visualizar(2) ou Finaliza Venda(4) e o USUÁRIO não é CAIXA		
		Do While nLastKe2 == 0
			lRet := u_SenhaSup("LJ7032",Space(06)) //Valida senha de usuario para acessar o orcamento - OS VENDEDORES VISUALIZAM SOMENTE OS SEUS ORCAMENTOS - LJ7018.PRW
		EndDo
	
	Else
		lRet := u_ValidaSenha(.F.,SA3->A3_COD,SA3->A3_SENHA,"LJ7032")
	EndIf
	
	If lRet .And. ParamIxb[1] == 4  // Caso seja a opção FINALIZA VENDA restaura os valores devido o desconto de PRODUTOR RURAL
		u_RestVlr()					// Restaura o valor original quando a opção for FINALIZAR VENDA e o cliente for PRODUTOR RURAL
	EndIf
	
Else                                                
    
    SA1->(DbSeek(xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA))
	If SA1->A1_TIPO == "L"	.And. SubStr(SLF->LF_ACESSO,3,1) == "S"	// PRODUTOR RURAL e se o USUARIO EH CAIXA
		u_RestVlr()									// Restaura o valor original quando a opção for FINALIZAR VENDA e o cliente for PRODUTOR RURAL - FUNCOES GENERICAS.PRW
		u_AtDescItm()   							// Calcula o Percentual de Desconto quando o cliente for Produtor Rural - FUNCOES GENERICAS.PRW
    EndIf

	// Se o USUÁRIO é CAIXA verifica se é um orçamento para Receber no Local
	If SL1->L1_RECLOC == "S" 					// Caso o orçamento posicionado seja com Receber no Local
		
		If SubStr(SLF->LF_ACESSO,3,1) == "S" 	// Somente se o usuário é CAIXA
			
			If ! Alltrim(cUserName) $ cNome   	// Verifica se o usuário possui autorização
				
				lRet := .F.
				MsgAlert("Venda para Receber no Local, somente CAIXA autorizado !!!","ATENÇÃO")
				
			Endif
			
		EndIf
		
	EndIf
	
EndIf

Return(lRet)
