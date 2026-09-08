#Include "Protheus.ch"

//====================================================================================================================\\
/*/{Protheus.doc}ImpXML2.prw
  ====================================================================================================================
	@description
	Descrição:
    Esta rotina executa as 2 funcoes do importador de XML da NFe em sequencia para ser rodada manualmente pelo usuario
    caso haja necessidade

    Intrução para utilizar:
    1) coloque os XMLs das NFe na pasta compartilhada \\importadorxml\inn
    2) execute esta rotina

	@author		Claudio França
	@version	1.0
	@since		07/03/2025
/*/
//===================================================================================================================\\

User Function IMPXML2()
    Local lContinuar := .F.
    Local aArea as array
    Private oNewProess as object
    aArea := GetArea()

    // Cria a janela de aviso
    If MsgYesNo("Esta rotina irá importar todos os XMLs das NFe gravadas na pasta INN. Deseja continuar a execução do programa?", "Aviso de Execução")
        lContinuar := .T.
    EndIf

    // Se usuário optar por continuar, executa os dois fontes em sequência
    If lContinuar
        
        // Configura a barra de progresso corretamente
        Processa({|| COLAUTOREAD()}, "Executando Fonte COLAUTOREAD ...", , , , )
        Processa({|| Sleep(5000)}, "Aguardando 5 segundos ...", , , , )
        Processa({|| SCHEDIMPTRA()}, "Executando Fonte SCHEDIMPTRA ...", , , , )
        Processa({|| Sleep(5000)}, "Aguardando 5 segundos ...", , , , )
        Processa({|| SCHEDCOMCOL()}, "Executando Fonte SCHEDCOMCOL ...", , , , )
        Processa({|| Sleep(5000)}, "Aguardando 5 segundos ...", , , , )
        Processa({|| SCHEDUPDTRA()}, "Executando Fonte SCHEDUPDTRA ...", , , , )
        RestArea(aArea)
        Conout("*********incproctst finalizada pelo scheduller***********")
        // Exibe mensagem de sucesso após a execução dos dois fontes
        MsgInfo("Rotina executada com sucesso!", "Conclusão")
    Else
        Return  // Sai da função sem executar os fontes
    EndIf
Return
