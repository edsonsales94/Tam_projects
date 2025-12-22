
#include "protheus.ch"

/*


*/



User Function AAFATE16()

local axarea := getarea()
PRIVATE lSugere:=.F.
PRIVATE lTransf:=.f.
PRIVATE lLiber :=.f.


iF SC9->(DbSeek(FWxFilial('SC9')+SC5->C5_NUM   ))

    While  (!SC9->(Eof())) .AND. SC9->(C9_FILIAL+C9_PEDIDO ) == FWxFilial('SC9')+SC5->C5_NUM 

        A460Estorna( .T., .T., 0 ) 
        SC9->(DbSkip())

    EndDo

ENDIF


A440Libera("SC5",SC5->(RECNO()),4)
SC9->(DbSeek(FWxFilial('SC9')+SC5->C5_NUM   ))

While  (!SC9->(Eof())) .AND. SC9->(C9_FILIAL+C9_PEDIDO ) == FWxFilial('SC9')+SC5->C5_NUM 

    SC9->(RecLock("SC9",.F.))
    SC9->C9_BLCRED := ""
    SC9->(MsUnlock())
    SC9->(dbSkip())

EndDo

restarea(axarea)
   

Return



Static Function DefineCabec()

    Local aSC6      := {"C6_ITEM","C6_PRODUTO","C6_DESCRI","C6_LOCAL","C6_TES","C6_QTDVEN", "C6_QTDLIB"}
    Local nUsado
    local nx 

    aHeader     := {}
    aCpoEnchoice:= {}
    nUsado:=0

    DbSelectArea("SX3")
    SX3->(DbSetOrder(1))
    dbseek(cAlias1)

    while SX3->(!eof()) .AND. X3_ARQUIVO == cAlias1
        IF X3USO(X3_USADO) .AND. CNIVEL >= X3_NIVEL
            AADD(ACPOENCHOICE,X3_CAMPO)
        endif
        dbskip()
    enddo

    DbSelectArea("SX3")
    SX3->(DbSetOrder(2))
    aHeader:={}

    For nX := 1 to Len(aSC6)
        If SX3->(DbSeek(aSC6[nX]))
            If X3USO(X3_USADO).And.cNivel>=X3_NIVEL
                nUsado:=nUsado+1
                Aadd(aHeader, {TRIM(X3_TITULO), X3_CAMPO , X3_PICTURE, X3_TAMANHO, X3_DECIMAL,X3_VALID, X3_USADO  , X3_TIPO   , X3_ARQUIVO, X3_CONTEXT})
            Endif
        Endif

    Next nX



Return



//Insere o conteudo no aCols do grid

Static function DefineaCols(nOpc)

    Local nQtdcpo   := 0
    Local i         := 0
    Local nCols     := 0
    nQtdcpo         := len(aHeader)
    aCols           := {}

    dbselectarea(cAlias2)
    dbsetorder(1)
    dbseek(xfilial()+SC5->C5_NUM)

    while .not. eof() .and. SC6->C6_FILIAL == xfilial() .and. SC6->C6_NUM==SC5->C5_NUM

        aAdd(aCols,array(nQtdcpo+1))
        nCols++

        for i:= 1 to nQtdcpo

            if aHeader[i,10] <> "V"
                aCols[nCols,i] := Fieldget(Fieldpos(aHeader[i,2]))
            else
                aCols[nCols,i] := Criavar(aHeader[i,2],.T.)
            endif

        next i

        aCols[nCols,nQtdcpo+1] := .F.
        dbselectarea(cAlias2)
        dbskip()

    enddo

Return



//Gravar o conteudo dos campos

Static Function Gravar()

    Local bcampo := { |nfield| field(nfield) }
    Local i:= 0
    Local y:= 0
    Local nitem := 0
    Local nItem     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ITEM"})
    Local nProduto  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_PRODUTO"})
    Local nPosCpo
    Local nCpo
    Local nI
    local aSaldos
    local nQuant 

    Local cCamposSC5    := "C5_CLIENTE|C5_CONDPAG|C5_TPFRETE|C5_MENNOTA|"
    Local cCamposSC6    := "C6_QTDLIB"

    Begin Transaction

        dbSelectArea("SC6")
        SC6->(dbSetOrder(1))

        For nI := 1 To Len(aCols)

            If !(aCols[nI, Len(aHeader)+1])

                If SC6->(dbSeek( xFilial("SC6")+M->C5_NUM+aCols[nI,nItem]+aCols[nI,nProduto] ))

                    RecLock("SC6",.F.)

                    For nCpo := 1 to fCount()
                        If (FieldName(nCpo)$cCamposSC6)

                            nPosCpo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(FieldName(nCpo))})

                            If nPosCpo > 0

                                FieldPut(nCpo,aCols[nI,nPosCpo])

                            EndIf

                        Endif

                    Next nCpo

                    SC6->(MsUnLock())
                    
                    SC9->(DbSeek(FWxFilial('SC9')+SC6->C6_NUM + SC6->C6_ITEM  ))

                    While  (!SC9->(Eof())) .AND. SC9->(C9_FILIAL+C9_PEDIDO + C9_ITEM) == FWxFilial('SC9')+SC6->(C6_NUM + C6_ITEM)

                        a460Estorna()
                        SC9->(DbSkip())

                    EndDo

                    MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDLIB,.F.,.F.,.T.,.T.,.T.)

                    aSaldos:=CalcEst(SC6->C6_PRODUTO,SC6->C6_LOCAL, dDataBase)
                    nQuant:=aSaldos[1]

                    If nQuant >= SC6->C6_QTDLIB
                         SC9->(DbSeek(FWxFilial('SC9')+SC6->C6_NUM + SC6->C6_ITEM  ))

                         While  (!SC9->(Eof())) .AND. SC9->(C9_FILIAL+C9_PEDIDO + C9_ITEM) == FWxFilial('SC9')+SC6->(C6_NUM + C6_ITEM)
                         
                                SC9->(RecLock("SC9",.F.))
                                SC9->C9_BLEST  := ""
                                SC9->(MsUnlock())
                                SC9->(dbSkip())

                        EndDo      
                          
                    EndIF

                    If !EMpty(SC5->C5_ORCRES)
                         SC9->(DbSeek(FWxFilial('SC9')+SC6->C6_NUM + SC6->C6_ITEM  ))

                         While  (!SC9->(Eof())) .AND. SC9->(C9_FILIAL+C9_PEDIDO + C9_ITEM) == FWxFilial('SC9')+SC6->(C6_NUM + C6_ITEM)

                            
                                SC9->(RecLock("SC9",.F.))
                                SC9->C9_BLCRED := ""
                                SC9->(MsUnlock())
                                SC9->(dbSkip())


                        EndDo
                       
                    EndIf


                Endif

            Endif

        Next nI



    End Transaction



Return



