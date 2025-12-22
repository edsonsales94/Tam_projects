#Include "PROTHEUS.CH"

/*/{Protheus.doc} ENVCLICKPDF
    Gera um único PDF com N OS (grupo), reutilizando o layout do ITFATR04.
    Mantém NovaPagina() e ListaOs(...) originais.
*/
User Function ENVCLICKPDF(aRegs, cFileBase, cOutDir, lPreview)
    Local cFileName  := AllTrim(cFileBase)
    Local cPathInServer := IIf(Empty(cOutDir), '\\relato\\', cOutDir)
    Local cFil := ""
    Local cCod := ""
    Local n := 0

    If PCount() < 4 ; lPreview := .F. ; EndIf
    If Upper(Right(cFileName,4)) == ".PDF"
        cFileName := Left(cFileName, Len(cFileName) - 4)
    EndIf

    // === PRIVATES exatamente como no ITFATR04 ===
    Private nPagina         := 0
    Private nPagTot         := 0
    Private nHeight         := 75
    Private nWidght         := 90
    Private nLinha          := 0
    Private nColuna         := 0
    Private nColIni         := 010
    Private nColFin         := 580
    Private nEspacoLin      := 12
    Private oPrinter        := Nil
    Private aTexto          := {}

    // Fonts (mesmas do ITFATR04)
    Private oTFont08   := TFont():New('ARIAL',,-08,.F.)
    Private oTFont10   := TFont():New('ARIAL',,-10,.F.)
    Private oTFont10_N := TFont():New('ARIAL',,-10,.T.)
    Private oTFont16   := TFont():New('ARIAL',,-16,.T.)
    Private oTFont14   := TFont():New('ARIAL',,-14,.T.)
    Private oTFont16_N := TFont():New('ARIAL',,-16,.T.)
    Private oTFont12   := TFont():New('ARIAL',,-12,.T.)
    Private oTFont12_N := TFont():New('ARIAL',,-12,.T.)

    oTFont10_N:Bold := .T.
    oTFont12_N:Bold := .T.
    oTFont16_N:Bold := .T.

    // === PRINTER exatamente como no ITFATR04 ===
    oPrinter := FWMSPrinter():New(cFileName,IMP_PDF,.F.,cPathInServer,.T.,,,,.F.,.F.,,.F.)
    oPrinter:SetParm( "-RFS")
    oPrinter:cPathPDF := cPathInServer
    oPrinter:SetPortrait()

    nHeight := oPrinter:NPAGEHEIGHT
    nWidght := oPrinter:NPAGEWIDTH
    nHeight := nHeight-(nHeight*0.25)
    nWidght := nWidght-(nWidght*0.025)
    //quantidade maxima de linha - controle para reinicio de pagina
    nMaximo := 2300

    // === Itera as OS do grupo ===
    For n := 1 To IIf(ValType(aRegs)=="A", Len(aRegs), 0)
        cFil := AllTrim(aRegs[n]["Z1_FILIAL"])
        cCod := AllTrim(aRegs[n]["Z1_CODIGO"])

        SZ1->(DbSelectArea("SZ1"))
        SZ1->(DbSetOrder(1))  // AJUSTE se o TAG 1 não for FILIAL+Z1_CODIGO
        If SZ1->(DbSeek(cFil + cCod))
            SA1->(DbSelectArea("SA1"))
            SA1->(DbSetOrder(1))
            SA1->(DbSeek(xFilial("SA1") + SZ1->Z1_CLIENTE + SZ1->Z1_LOJA))

            SA9->(DbSelectArea("SA9"))
            SA9->(DbSetOrder(1))
            SA9->(DbSeek(xFilial("SA9") + SZ1->Z1_TECNICO))

            aTexto := zMemoToA(SZ1->Z1_APTEXTO)
            nPagTot := CEILING( Len(aTexto) / 20 )

            NovaPagina()
            ListaOs( SZ1->Z1_CODIGO, ;
                     SZ1->Z1_TECNICO, ;
                     Rtrim(SA9->A9_NOME), ;
                     SZ1->Z1_CLIENTE, ;
                     Rtrim(SA1->A1_NOME), ;
                     SZ1->Z1_APHRFIM, ;
                     SZ1->Z1_APHRALM, ;
                     SZ1->Z1_APHRINI, ;
                     SZ1->Z1_DATA, ;
                     SZ1->Z1_PROJETO, ;
                     SZ1->Z1_APTRANS )

            oPrinter:EndPage()
        EndIf
    Next

    If lPreview
        oPrinter:Preview()  // manter comportamento do ITFATR04; no REST, passe .F.
    Else
        oPrinter:Print()
    EndIf

Return cPathInServer + cFileName + ".pdf"

Static Function FileName(cNomeCliente)
    Local cRet := rtrim(cNomeCliente)

    cRet := replace(cRet,' ',"_")
    cRet := replace(cRet,'','o')
    cRet := replace(cRet,'','a')
    cRet := replace(cRet,'}','')
    cRet := replace(cRet,'{','')
    cRet := replace(cRet,'"','')
    cRet := replace(cRet,'-','')
    cRet := replace(cRet,'/','')
    cRet := replace(cRet,'.','')
    cRet := replace(cRet,'\','')
    cRet := FwNoAccent(replace(cRet,chr(13)+chr(10),''))

Return "ITFATR04-"+Dtos(MSDate())+'-'+StrTran(Time(),":","") +'-'+cRet

/*-----------------------------------------------*
| Funcao: NovaPagina                             |
| Descr.: Gera uma nova pagina pdf               |
*------------------------------------------------*/

Static Function NovaPagina()
        
    oPrinter:StartPage()

    //armazena numero da pagina
    nPagina += 1
    
    //dados empresa
    nLinha     := 010

    //cria linha horizontal
    oPrinter:Line(nLinha , nColIni , nLinha, (nColFin - nColIni))
    
    nLinha += nEspacoLin
    oPrinter:SayBitmap( 015, 010, "\system\logo.jpg", 260, 60)

    nLinha += nEspacoLin
    oPrinter:SayAlign(nLinha, (nColFin - nColIni)/2, RTRIM(SM0->M0_NOMECOM) , oTFont10_N,  (((nColFin - nColIni)/2) - nColIni),    /*015*/, , 2,  )

    nLinha += nEspacoLin
    oPrinter:SayAlign( nLinha, (nColFin - nColIni)/2 , "CNPJ: " + Transform(SM0->M0_CGC, "@R 99.999.999/9999-99") , oTFont08 , (((nColFin - nColIni)/2) - nColIni),    /*015*/, , 2,  )

    nLinha += nEspacoLin
    oPrinter:SayAlign( nLinha, (nColFin - nColIni)/2 , AllTrim(SM0->M0_ENDENT)+" - "+AllTrim(SM0->M0_BAIRENT)+", "+AllTrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT, oTFont08 , (((nColFin - nColIni)/2) - nColIni),    /*015*/, , 2,  )
        
    nLinha += nEspacoLin
    oPrinter:SayAlign( nLinha, (nColFin - nColIni)/2     , "CEP: "+Transform(SM0->M0_CEPENT,"@R 99999-999")+" - "+"Fone/Fax: "+SM0->M0_TEL, oTFont08,  (((nColFin - nColIni)/2) - nColIni),    /*015*/, , 2,  )
    
    //cria linha horizontal
    nLinha += nEspacoLin*1.5
    oPrinter:Line(nLinha , nColIni , nLinha, (nColFin - nColIni))

    //rodape
    oPrinter:Line(768 , nColIni , 768, (nColFin - nColIni))    
    oPrinter:SayAlign( 776, nColuna+0000, 'TOTVS - A gente acredita no Brasil que faz!',oTFont12,  (nColFin - nColIni),    /*015*/, , 2,  )
    oPrinter:SayAlign( 792, nColIni, "Pgina "+CValToChar(nPagina)+"/"+CValToChar(nPagTot), oTFont10,  (nColFin - nColIni),    /*015*/, , 2,  )  
    oPrinter:SayAlign( 808, nColIni, 'Impresso em '+dtoc(date())+' - '+time(),oTFont10,  (nColFin - nColIni),    /*015*/, , 2,  )

Return

/*-----------------------------------------------*
| Funcao: ListaOs                                 |
| Descr.: Imprime as oss do periodo              |
*------------------------------------------------*/

Static Function ListaOs(cOsEletr,cTecnico,cNomeTec,cCodCli,cNomeCli,cHrSaida,cIntervalo,cHrEntrada,dDataOs,cProjeto,cTranslado)
    Local nI := Nil

    nLinha  += nEspacoLin*1.5
    oPrinter:Say( nLinha, nColIni, "Ordem de Servio : "+RTRIM(cOsEletr)              ,oTFont10_N)
    nLinha  += nEspacoLin*1.5
    oPrinter:Say( nLinha, nColIni, "Executado por: "+RTRIM(cTecnico)+" - "+cNomeTec ,oTFont10_N)
    nLinha  += nEspacoLin*1.5
    oPrinter:Say( nLinha, nColIni, "Cliente:"+RTRIM(cCodCli)+" - "+cNomeCli    ,oTFont10_N)

    //cria linha horizontal
    nLinha += nEspacoLin
    oPrinter:Line(nLinha , nColIni , nLinha, (nColFin - nColIni))

    //total de horas os
    nHrTot  := VAL(Substr(cHrSaida,1,2)) + (VAL(Substr(cHrSaida,4,2)) / 60) 
    nHrTot  := nHrTot - (VAL(Substr(cIntervalo,1,2)) + (VAL(Substr(cIntervalo,4,2)) / 60))
    nHrTot  := nHrTot - (VAL(Substr(cHrEntrada,1,2)) + (VAL(Substr(cHrEntrada,4,2)) / 60)) 
 
    cHrTot  := StrZero(int(nHrTot),2) + ":" +StrZero((nHrTot - int(nHrTot))*60,2)

    cTexto := "Data: "+dtoc(dDataOs)+" Projeto: "+Rtrim(cProjeto)+" - "+Posicione("AF8",1,xFilial("AF8")+cProjeto,"AF8_DESCRI")
    nLinha  += nEspacoLin*1.5
    oPrinter:Say( nLinha, nColIni, cTexto                      ,oTFont10_N)

    cTexto := "Horrio: "+cHrEntrada+' - '+cHrSaida+space(5)
    cTexto += "Intervalo: "+cIntervalo+"h"+space(5)
    cTexto += "Total: "+cHrTot+"h"+space(5) 
    cTexto += "Translado: "+cTranslado+"h"+space(5)
    
    nLinha += nEspacoLin*1.5
    oPrinter:Say( nLinha, nColIni, cTexto                      ,oTFont10_N)

    //cria linha horizontal
    nLinha += nEspacoLin*1.5
    oPrinter:Line(nLinha , nColIni , nLinha, (nColFin - nColIni))

    nLinha += nEspacoLin
    oPrinter:SayAlign( nLinha, nColIni     , "Tarefas executadas conforme solicitao do cliente:",oTFont10_N,  (nColFin - nColIni),    /*015*/, , 2,  )
    
    for nI := 1 to len(aTexto)
        if mod(nI,20) == 0
            NovaPagina()
            nLinha += nEspacoLin
        oPrinter:SayAlign( nLinha, nColIni     , "Tarefas executadas conforme solicitao do cliente (continuacao):",oTFont10_N,  (nColFin - nColIni),    /*015*/, , 2,  )
        endif
        nLinha += nEspacoLin*2
        oPrinter:SayAlign( nLinha, nColIni     , aTexto[nI],oTFont10,  (nColFin - nColIni),    /*015*/, , 0,  )
    next

    cTexto := "No h restries e/ou observaes sobre os dados contidos nesta Ordem de Servio. Alertamos que caso o cliente " + CRLF
    nLinha += nEspacoLin*4
    oPrinter:SayAlign( nLinha, nColIni     , cTexto,oTFont10_N,  (nColFin - nColIni), , , 2,  )

    cTexto := "no se pronuncie, concordando ou no com o exposto, no prazo de 48 horas da data de emisso desta, via e-mail, "
    nLinha += nEspacoLin*2
    oPrinter:SayAlign( nLinha, nColIni     , cTexto,oTFont10_N,  (nColFin - nColIni), , , 2,  )

    cTexto := "perder o direito de reclamao. "
    nLinha += nEspacoLin*2
    oPrinter:SayAlign( nLinha, nColIni     , cTexto,oTFont10_N,  (nColFin - nColIni), , , 2,  )

Return

/*/{Protheus.doc} zMemoToA
    Funo Memo To Array, que quebra um texto em um array conforme nmero de colunas
    @author Atilio
    @since 15/08/2014
    @type  Function
    @version 1.0
    @param cTexto, caracter, Texto que ser quebrado (campo MEMO)
    @param nMaxCol, numrico, Coluna mxima permitida de caracteres por linha
    @param cQuebra, caracter, Quebra adicional, forando a quebra de linha alm do enter (por exemplo '<br>')
    @param lTiraBra, Lgico, Define se em toda linha ser retirado os espaos em branco (Alltrim)
    @example
    cCampoMemo := SB1->B1_X_TST
    nCol        := 200
    aDados      := u_zMemoToA(cCampoMemo, nCol)
    @obs Difere da MemoLine(), pois j retorna um Array pronto para impresso
/*/

Static Function zMemoToA(cTexto, nMaxCol, cQuebra, lTiraBra)
    Local aArea     := GetArea()
    Local aTexto    := {}
    Local aAux      := {}
    Local nAtu      := 0
    Default cTexto  := ''
    Default nMaxCol := 124
    Default cQuebra := ';'
    Default lTiraBra:= .T.

    //Quebrando o Array, conforme -Enter-
    aAux:= StrTokArr(cTexto,Chr(10))
     
    //Correndo o Array e retirando o tabulamento
    For nAtu:=1 TO Len(aAux)
        aAux[nAtu]:=StrTran(aAux[nAtu],Chr(10),'')
    Next
     
    //Correndo as linhas quebradas
    For nAtu:=1 To Len(aAux)
     
        //Se o tamanho de Texto, for maior que o nmero de colunas
        If (Len(aAux[nAtu]) > nMaxCol)
         
            //Enquanto o Tamanho for Maior
            While (Len(aAux[nAtu]) > nMaxCol)
                //Pegando a quebra conforme texto por parmetro
                nUltPos:=RAt(cQuebra,SubStr(aAux[nAtu],1,nMaxCol))
                 
                //Caso no tenha, a ltima posio ser o ltimo espao em branco encontrado
                If nUltPos == 0
                    nUltPos:=Rat(' ',SubStr(aAux[nAtu],1,nMaxCol))
                EndIf
                 
                //Se no encontrar espao em branco, a ltima posio ser a coluna mxima
                If(nUltPos==0)
                    nUltPos:=nMaxCol
                EndIf
                 
                //Adicionando Parte da Sring (de 1 at a lima posio vlida)
                aAdd(aTexto,SubStr(aAux[nAtu],1,nUltPos))
                 
                //Quebrando o resto da String
                aAux[nAtu] := SubStr(aAux[nAtu], nUltPos+1, Len(aAux[nAtu]))
            EndDo
             
            //Adicionando o que sobrou
            aAdd(aTexto,aAux[nAtu])
        Else
            //Se for menor que o Mximo de colunas, adiciona o texto
            aAdd(aTexto,aAux[nAtu])
        EndIf
    Next
     
    //Se for para tirar os brancos
    If lTiraBra
        //Percorrendo as linhas do texto e aplica o AllTrim
        For nAtu:=1 To Len(aTexto)
            aTexto[nAtu] := Alltrim(aTexto[nAtu])
        Next
    EndIf
     
    RestArea(aArea)
Return aTexto