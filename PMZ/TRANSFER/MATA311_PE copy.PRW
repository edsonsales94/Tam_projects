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
    Local oObj       := Nil
    Local cIdPonto   := ''
    Local cIdModel   := ''
    Local nOper      := 0
    // Local cCampo     := ''
    // Local cTipo      := ''
 
    //Se tiver parâmetros
    If aParam <> NIL
        ConOut("> "+aParam[2])
         
        //Pega informações dos parâmetros
        oObj     := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]

        //Valida a abertura da tela
        If  cIdPonto == 'MODELPOS'

            dbSelectArea('ZZ2')
            ZZ2->(DbSetOrder(1))

            if ZZ2->(msseek(xFilial('ZZ2')+oGrid:GetValue("NNT_FILORI")+oGrid:GetValue("NNT_FILORI")))
                nOper := oObj:nOperation
                oGrid := oObj:GetModel("NNTDETAIL")

                If oGrid:Length() > 0 .and. nOper = 3
                    oGrid:GoLine(1)
                    oGrid:SetValue("NNT_TS", "502")
                    oGrid:SetValue("NNT_TE", "002")
                EndIf
            EndIf
        EndIf
    EndIf
Return xRet
