#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH" 
#INCLUDE "MSOLE.CH"
#INCLUDE "GPEWORD.CH" 

User Function GPESUFRAMA()

    Local oWord, oDoc
    Local cArquivoModelo := "C:\TOTVS\protheus_data\RH\SUFRAMA.docx"
	Local cArqSaida     := AllTrim( mv_par02 )
    Local cCodCliente := MsgInput("Informe o código do cliente:")
    Local cNome := ""
    Local cEndereco := ""
    Local cCNPJ := ""

    // Busca dados da tabela SA1
    DbSelectArea("SA1")
    SA1->(DbSetOrder(1)) // index por código
    If SA1->(DbSeek(xFilial("SA1") + cCodCliente))
        cNome     := AllTrim(SA1->A1_NOME)
        cEndereco := AllTrim(SA1->A1_END)
        cCNPJ     := AllTrim(SA1->A1_CGC)
    Else
        MsgStop("Cliente não encontrado!")
        Return
    EndIf

    // Inicia o Word via OLE
    oWord := CreateObject("Word.Application")

    If oWord == Nil
        MsgStop("Não foi possível iniciar o Microsoft Word.")
        Return
    EndIf

    oWord:Visible := .F.
    oDoc := oWord:Documents:Open(cArquivoModelo)

    // Substituições no Word
    ReplaceWordText(oWord, "{{NOME}}", cNome)
    ReplaceWordText(oWord, "{{ENDERECO}}", cEndereco)
    ReplaceWordText(oWord, "{{CNPJ}}", cCNPJ)

    // Salvar novo arquivo
    oDoc:SaveAs(cArquivoNovo)
    oDoc:Close(.F.)
    oWord:Quit()


Return


// Função auxiliar para substituição de texto no Word
Static Function ReplaceWordText(oWord, cProcurar, cSubstituir)
    Local oFind := oWord:Selection:Find

    oFind:ClearFormatting()
    oFind:Text := cProcurar
    oFind:Replacement:ClearFormatting()
    oFind:Replacement:Text := cSubstituir
    oFind:Execute(,,,,,,,,,,2) // wdReplaceAll = 2

Return
