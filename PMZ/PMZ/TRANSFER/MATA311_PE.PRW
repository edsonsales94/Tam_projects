//Bibliotecas
#Include "Protheus.ch"

/*---------------------------------------------------------------------------------------------------------------------------*
 | P.E.:  MATA311                                                                                                            |
 | Desc:  Ponto de entrada MVC no cadastro de Bancos                                                                         |
 | Obs.:  Ao criar um P.E. em MVC com o mesmo nome do ModelDef, deixe o nome do prw com outro nome, por exemplo,             |
 | Obs.:  Esse ponto de entrada tem objetivo alterar a TES de entrada e saida na MATA311 Solicit. Transf.                    |
 | Autor: Edson Sales - 24/02/2026                                                                                           |
 | Ref.:  http://tdn.totvs.com/display/public/mp/Pontos+de+Entrada+para+fontes+Advpl+desenvolvidos+utilizando+o+conceito+MVC |
 *---------------------------------------------------------------------------------------------------------------------------*/
 
 
User Function MATA311()
Local aParam     := PARAMIXB
Local xRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
// Local cTesEnt   := ''
// Local cTesSai   := ''
Local lIsGrid    := .F.

// Local _ni        := 0
Local nLinha     := 0
Local nQtdLinhas := 0
// Local aCols      := {}
// Local cMsg       := ''


If aParam <> NIL
      
    // oObj       := aParam[1]
    // cIdPonto   := aParam[2]
    // cIdModel   := aParam[3]
    // lIsGrid    := ( Len( aParam ) > 5 )

    // // If lIsGrid
    //     // nQtdLinhas := oObj:GetQtdLine()
    //     // nLinha     := oObj:nLine
    // // EndIf

    // If cIdPonto == "FORMPRE"
    //     if len(aParam) > 5
    //         cTipo  := aParam[5]
    //         cCampo := aParam[6]
            
    //         // Após alterar o campo = SETVALUE, quando clicar, antes de alterar = CANSETVALUE
    //         If cTipo == "SETVALUE"
    //             DbSelectArea('SFM')
    //             SFM->(DbSetOrder(2))

    //             if AllTrim(cCampo) == "NNT_PRODD"  // FORNECEDOR
    //                 cProd:= IIF( Empty(oObj:GetValue(cCampo)) , M->NNT_PROD , oObj:GetValue(cCampo) )                    
    //                 cFilOrg := IIF( Empty(oObj:GetValue('NNT_FILORI')) , M->NNT_FILORI , oObj:GetValue('NNT_FILORI') )                    
    //                 cFilDes := IIF( Empty(oObj:GetValue('NNT_FILDES')) , M->NNT_FILDES , oObj:GetValue('NNT_FILDES') )

    //                 // Somente quando a filial destino for alterada
    //                 if cFilOrg == cFilDes
    //                     Return
    //                 endif

    //                 cForn := fBuscCF('SA2' ,cFilOrg)                    
    //                 cClie := fBuscCF('SA1', cFilDes)

    //                 //cGrpTrib := POSICIONE('SA2',1,xFilial('SA2')+cForn, 'A2_GRPTRIB')
    //                 // cGrTribPro := POSICIONE('SB1',1,xFilial('SB1')+cProd, 'B1_GRTRIB')
    //                 //FM_FILIAL+FM_TIPO+FM_CLIENTE+FM_LOJACLI+FM_FORNECE+FM_LOJAFOR
    //                 if SFM->(MsSeek(xFilial('SFM')+'F '+cClie+cForn))
    //                     nQtdLinhas := oObj:GetQtdLine()
    //                     nLinha     := oObj:nLine
    //                     oObj:GoLine(nLinha)
    //                     oObj:loadValue("NNT_TE", SFM->FM_TE)
    //                     oObj:loadValue("NNT_TS", SFM->FM_TS)
    //                 EndIf

    //             // elseif AllTrim(cCampo) == "NNT_PRODD"
    //                 // cProd:= IIF( Empty(oObj:GetValue(cCampo)) , M->NNT_PROD , oObj:GetValue(cCampo) )
    //                 // cTesEnt := MaTesInt(1,"F",'22763502','0002',"F",cProd)
    //                 // nQtdLinhas := oObj:GetQtdLine()
    //                 // nLinha     := oObj:nLine
    //                 // oObj:GoLine(nLinha)
    //                 // oObj:loadValue("NNT_TE", cTesSai)
    //             EndIf
    //         EndIf
    //     endif
    // endif
    // ElseIf   cIdPonto == 'MODELPOS'
        //         cMsg := 'Chamada na validação total do modelo (MODELPOS).' + CRLF
        //         cMsg += 'ID ' + cIdModel + CRLF
            
        //         If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
        //             Help( ,, 'Help',, 'O MODELPOS retornou .F.', 1, 0 )
        //         EndIf
            
        // ElseIf cIdPonto == 'FORMPOS'
        //         cMsg := 'Chamada na validação total do formulário (FORMPOS).' + CRLF
        //         cMsg += 'ID ' + cIdModel + CRLF
            
        //         If      cClasse == 'FWFORMGRID'
        //             cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) +'     linha(s).' + CRLF
        //         cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) ) + CRLF
        //         ElseIf cClasse == 'FWFORMFIELD'
        //             cMsg += 'É um FORMFIELD' + CRLF
        //         EndIf
            
        //         If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
        //             Help( ,, 'Help',, 'O FORMPOS retornou .F.', 1, 0 )
        //         EndIf
            
        // ElseIf cIdPonto == 'FORMLINEPRE'
        //     If aParam[5] == 'DELETE'
        //         cMsg := 'Chamada na pre validação da linha do formulário (FORMLINEPRE).' + CRLF
        //         cMsg += 'Onde esta se tentando deletar uma linha' + CRLF
        //         cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) +' linha(s).' + CRLF
        //         cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) ) + CRLF
        //         cMsg += 'ID ' + cIdModel + CRLF
                
        //         If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
        //                 Help( ,, 'Help',, 'O FORMLINEPRE retornou .F.', 1, 0 )
        //         EndIf
        //     EndIf
            
        // ElseIf cIdPonto == 'FORMLINEPOS'
        //     cMsg := 'Chamada na validação da linha do formulário (FORMLINEPOS).' + CRLF
        //     cMsg += 'ID ' + cIdModel + CRLF
        //     cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) +' linha(s).' + CRLF
        //     cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) ) + CRLF
            
        //     If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
        //         Help( ,, 'Help',, 'O FORMLINEPOS retornou .F.', 1, 0 )
        //     EndIf
            
        // ElseIf cIdPonto == 'MODELCOMMITTTS'
        //     ApMsgInfo('Chamada apos a gravação total do modelo e dentro da transação (MODELCOMMITTTS).' + CRLF + 'ID ' + cIdModel )
            
        // ElseIf cIdPonto == 'MODELCOMMITNTTS'
        //     ApMsgInfo('Chamada apos a gravação total do modelo e fora da transação (MODELCOMMITNTTS).' + CRLF + 'ID ' + cIdModel)
            
        // ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
            
        // ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
        //     ApMsgInfo('Chamada apos a gravação da tabela do formulário (FORMCOMMITTTSPOS).' + CRLF + 'ID ' + cIdModel)
            
        // ElseIf cIdPonto == 'MODELCANCEL'
        //     cMsg := 'Chamada no Botão Cancelar (MODELCANCEL).' + CRLF + 'Deseja Realmente Sair ?'
            
        //         If !( xRet := ApMsgYesNo( cMsg ) )
        //             Help( ,, 'Help',, 'O MODELCANCEL retornou .F.', 1, 0 )
        //         EndIf
            
        // ElseIf cIdPonto == 'BUTTONBAR'
        //     ApMsgInfo('Adicionando Botao na Barra de Botoes (BUTTONBAR).' + CRLF + 'ID ' + cIdModel )
        //     xRet := { {'Salvar', 'SALVAR', { || Alert( 'Salvou' ) }, 'Este botao Salva' } }   
        // EndIf

EndIf

Return xRet


/*/{Protheus.doc} fBuscCF() 
Essa função busca pela filial origem ou destino o cliente/fornecerdor
igual a M0_CODFIL, será buscado na seu respectivo cadastro SA1/SA2, chaveando 
com o CNPJ.
/*/
Static Function fBuscCF(_cAlias,_Fil)
    Local cAliasTmp := GetNextAlias()
    // Local cWhere := iif(_cAlias == 'SA1',"A1_FILTRF ='"+_FilTranf+"'","A2_FILTRF='"+_FilTranf+"'")

    // retornar o codigo cliente SA1 (filial destino na tranferencia)
    if _cAlias == 'SA1'
        BeginSql alias cAliasTmp
            select s.A1_COD,s.A1_LOJA from SIGA.SYS_COMPANY sc
            JOIN SIGA.%Table:SA1% s ON sc.M0_CGC=s.A1_CGC 
            WHERE sc.M0_CODFIL = %Exp:_Fil%
        endSQL

        cRet := (cAliasTmp)->A1_COD + (cAliasTmp)->A1_LOJA
    else
        // retornar o codigo Fornecedor SA2 (filial destino na tranferencia)
        BeginSql alias cAliasTmp
            select s.A2_COD,s.A2_LOJA from SIGA.SYS_COMPANY sc
            JOIN SIGA.%Table:SA2% s ON sc.M0_CGC=s.A2_CGC 
            WHERE sc.M0_CODFIL = %Exp:_Fil%
        endSQL

        cRet := (cAliasTmp)->A2_COD + (cAliasTmp)->A2_LOJA
    endif

Return cRet
