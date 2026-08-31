#include "Totvs.ch"
#Include "PRTOPDEF.ch"

User Function MT103FIM()
    Local nPosValCC, nPosValDoc,nPosValSerie,nPosValFornecedor,nPosValLoja, nX, nRow
    Local cCentroCusto, cNota,cSerie,cFornecedor,cLoja
    Local aCols := {} // Deve ser preenchido com os dados do grid
    Local aHeader := {} // Deve conter os metadados do grid
    cNota       := CNFISCAL
    cSerie      := CSERIE
    cFonrecedor := CA100FOR
    cLoja       := CLOJA
    cCentroCusto := M->D1_CC
    MsgAlert(cNota)
    MsgAlert(cCentroCusto)

    DbSelectArea("SE2")
    dbSetOrder(6)
    if (DbSeek("  "+cFornecedor+cLoja+cSerie+cNota))
    //For nX := 1 To 1 //Len(aCols)
        // Localiza as posições dos campos D1_CC e D1_DOC no cabeçalho
        /*nPosValCC         := AScan(aHeader, {|x| AllTrim(x[2]) == 'D1_CC'})
        nPosValDoc        := AScan(aHeader, {|x| AllTrim(x[2]) == 'D1_DOC'})
        nPosValSerie      := AScan(aHeader, {|x| AllTrim(x[2]) == 'D1_SERIE'})
        nPosValFornecedor := AScan(aHeader, {|x| AllTrim(x[2]) == 'D1_FORNECE'})
        nPosValLoja       := AScan(aHeader, {|x| AllTrim(x[2]) == 'D1_LOJA'})
        MsgAlert("Grid")
        If nPosValCC > 0 //.And. nPosValDoc > 0
            nRow         := nX // Atualiza a linha
            cCentroCusto := aCols[nRow, nPosValCC]
            cNota        := aCols[nRow, nPosValDoc]
            cSerie       := aCols[nRow, nPosValSerie]
            cFornecedor  := aCols[nRow, nPosValFornecedor]
            cLoja        := aCols[nRow, nPosValLoja]
            MsgAlert("Nota: " + cNota, "Atenção")
            // Atualiza o título correspondente na tabela SE2
            
            //If !Empty(cNota) .And. SE2->(DbSeek("  "+cFornecedor+cLoja+cSerie+cNota, .T.))
                //If !Empty(cCentroCusto)*/
                    SE2->E2_CCUSTO := cCentroCusto
                    MsUpdate()
                    //MsgInfo("Centro de Custo atualizado com sucesso para a nota: " + cNota + " | D1_CC: " + cCentroCusto, "Confirmação")
                //Else
                    MsgAlert("Centro de custo vazio para a nota: " + cNota, "Atenção")
                //EndIf
            //Else
                //MsgAlert("Título correspondente à nota de entrada (" + cNota + ") não encontrado na tabela SE2.", "Erro")
            //EndIf

            // Chama o gatilho para validação ou gravação
            //A103Trigger('D1_CC')
            //If ExistTrigger('D1_CC')
                //RunTrigger(2, nRow, nil, , 'D1_CC')
                //MaColsToFIs(aHeader, aCols, nRow, "MT100") // Grava o gatilho
            //EndIf
        Else
            MsgAlert("Campo D1_CC ou D1_DOC não encontrado na estrutura de cabeçalho.", "Erro")
        EndIf
    //Next nX

Return nil
