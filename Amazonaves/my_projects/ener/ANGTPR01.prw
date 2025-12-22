/*---------------------------------------------------------------------------*
 | Data       : 11/04/2024                                                   |
 | Rotina     : ANGTPR01                                                     |
 | Responsável: ENER FREDES                                                  |
 | Descrição  : Relatório de Consulta de Reserva                             |
 *---------------------------------------------------------------------------*/

#include "TOTVS.CH"
#Include "TopConn.ch"
#Include "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
User Function ANGTPR01()
    Private cFileName       := "ANGTPR01"
    Private cPathInServer   := '\spool'
    Private lAdjustToLegacy := .T.
    Private lDisableSetup   := .T.
    Private nPagina         := 0
    Private nLinha          := 0
    Private nEspacoLin      := 20
    Private nCol            := 0
    Private nColTit         := 0
    Private nColFim         := 0
    Private oPrinter        := Nil  
    Private cPerg           := "ANGTPR01"
    Private cTitulo         := "Relatório de Voo"
    Private aStatus := {"Disponivel","Reservado","Confirmado","Indisponível","","","","","Cancelado"}
    Private aTpv := {"Passageiro","Carga","Carga e Passageiro","Aeromédico","Treinamento","Translado","Voo de Cheque","Voo Teste","Manutenção","            "}
    If Pergunte(cPerg,.t.)
        fImprime()
    EndIf
Return
Static Function fImprime()

    Private oTFont10   := TFont():New('ARIAL',,-11,.F.)
    Private oTFont10V  := TFont():New('COURIER NEW',,-11,.F.)
    Private oTFont10_N := TFont():New('ARIAL',,-11,.T.)
    Private oTFont12   := TFont():New('ARIAL',,-13,.T.)
    Private oTFont12_N := TFont():New('ARIAL',,-13,.T.)

    oTFont10_N:Bold := .T.
    oTFont12_N:Bold := .T.

    oPrinter := FWMSPrinter():New(cFileName,IMP_PDF , lAdjustToLegacy,cPathInServer, lDisableSetup, , , , , , .F.,)
    oPrinter:SetParm( "-RFS")
    oPrinter:cPathPDF := cPathInServer//diretorio na rede do pdf
    oPrinter:SetLandscape() //paizagem
    oPrinter:SetPaperSize(DMPAPER_A4) //Tamanho da folha

    //quantidade maxima de linha - controle para reinicio de pagina
    nMaximo := 2300

    oPrinter:StartPage()
    fHeader()
    fBody()
    oPrinter:EndPage()

    oPrinter:Setup()
    If oPrinter:nModalResult == PD_OK
        oPrinter:Preview()
    EndIf

Return 
Static Function fHeader()
    //armazena numero da pagina
    nPagina += 1
    nLinha     := 60
    nEspacoLin := 40
    nCol    := 30
    nColTit :=300
    nColFim := 3000

    oPrinter:Box( nLinha, nCol, nLinha+240, nColFim)
    nLinha += 10
    oPrinter:SayBitmap( nLinha, nCol+20, "\system\LGMID.PNG", 400, 220)
    nLinha += nEspacoLin
    oPrinter:SayAlign(55, nColTit, Padc(Alltrim(SM0->M0_NOMECOM),150) , oTFont12_N,1800,50,,0,0)

    oPrinter:SayAlign(155, nColTit, Padc("Relação de Voos",150) , oTFont12_N ,1800,50,,0,0)
    nLinha := 310
    oPrinter:Box(nLinha, nCol, 2300, nColFim)
    oPrinter:Box(nLinha, nCol, nLinha+50, nColFim)
    oPrinter:SayAlign( nLinha+5, nCol + 0050, "Data", oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, nCol + 0250, "Reserva", oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, nCol + 0400, "Cliente", oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, nCol + 1000, "Tp.Viagem", oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, nCol + 1300, "Aeronave", oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, nCol + 1500, "Status", oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, nCol + 1700, "Itinerário", oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, nCol + 2600, PADR("Valor",30), oTFont10_N,500,50,,0,0)

Return

Static Function fBody()
    Local cQry := ""
    Local nTotal := 0
    Local nLin
    Local nCont := 1
    Local cItinerario
    Local cTpVoo
    Local cSelPar07,cPar07
    Local cSelPar08,cPar08
    Local cSelPar09,cPar09
 
    Private aDadosRat

    cPar07 := Alltrim(MV_PAR07)
    cPar08 := Alltrim(MV_PAR08)
    cPar09 := Alltrim(MV_PAR09)

    cSelPar07 := ""
    While !Empty(Alltrim(cPar07))
       cSelPar07 += "'"+Left(cPar07,1)+"',"
       cPar07 := Right(cPar07,len(cPar07)-1)
    End

    cSelPar08 := ""
    While !Empty(Alltrim(cPar08))
       cSelPar08 += "'"+Left(cPar08,1)+"',"
       cPar08 := Right(cPar08,len(cPar08)-1)
    End

    cSelPar09 := ""
    While !Empty(Alltrim(cPar09))
       cSelPar09 += "'"+Left(cPar09,1)+"',"
       cPar09 := Right(cPar09,len(cPar09)-1)
    End
        //Seleciona dados do documento de entrada
    cQry := " SELECT * FROM "+ RetSQLName('SZ1') + " SZ1 "                                  
    cQry += " WHERE "                                                   + CRLF
    cQry += "     Z1_FILIAL = '" + FWxFilial('SZ1') + "' AND SZ1.D_E_L_E_T_ = ''"              + CRLF
    cQry += "     AND Z1_DATA >= '"+Dtos(MV_PAR01)+"' AND Z1_DATA <= '"+Dtos(MV_PAR02)+"'"   + CRLF
    cQry += "     AND Z1_CODCLI  >= '"+MV_PAR03+"' AND Z1_CODCLI <= '"+MV_PAR05+"'"   + CRLF
    cQry += "     AND Z1_LOJCLI  >= '"+MV_PAR04+"' AND Z1_LOJCLI <= '"+MV_PAR06+"'"   + CRLF
    cQry += "     AND Z1_TPRES = 'P' AND Z1_RESERVA <> ''"                                                   + CRLF

    If !Empty(Alltrim(MV_PAR07))
        cSelPar07 := Left(cSelPar07,Len(cSelPar07)-1)
        cQry += " AND Z1_STATUS IN ("+cSelPar07+")" 
    EndIf
    If !Empty(Alltrim(MV_PAR08))
        cSelPar08 := Left(cSelPar08,Len(cSelPar08)-1)
        cQry += " AND Z1_STFATU IN ("+cSelPar08+")" 
    EndIf
    If !Empty(Alltrim(MV_PAR09))
        cSelPar09 := Left(cSelPar09,Len(cSelPar09)-1)
        cQry += " AND Z1_TPVIAJ IN ("+cSelPar09+")" 
    EndIf

    cQry += " ORDER BY Z1_DATA,Z1_HORA,Z1_RESERVA "                                                   + CRLF
    TCQuery cQry New Alias "QRYRES"
    TCSetField("QRYRES","Z1_DATA","D") 
 
    nLin     := 400

    While !QRYRES->(Eof())
        cItinerario := fMontaInt(QRYRES->Z1_RESERVA)
        cTpVoo := aTpv[IIf(Val(QRYRES->Z1_TPVIAJ) == 0,10,Val(QRYRES->Z1_TPVIAJ))]
        oPrinter:SayAlign( nLin, nCol + 0050,  Dtoc(QRYRES->Z1_DATA), oTFont10,1800,50,,0,0)
        oPrinter:SayAlign( nLin, nCol + 0250,  QRYRES->Z1_RESERVA,    oTFont10,1800,50,,0,0)
        oPrinter:SayAlign( nLin, nCol + 0400,  Left(QRYRES->Z1_NOMCLI,30),     oTFont10,1800,50,,0,0)
        oPrinter:SayAlign( nLin, nCol + 1000, cTpVoo,                oTFont10,1800,50,,0,0)
        oPrinter:SayAlign( nLin, nCol + 1300,  QRYRES->Z1_CODVEI,    oTFont10,1800,50,,0,0)
        oPrinter:SayAlign( nLin, nCol + 1500,  aStatus[Val(QRYRES->Z1_STATUS)],                oTFont10,1800,50,,0,0)
        oPrinter:SayAlign( nLin, nCol + 1700,  Alltrim(left(cItinerario,63)),           oTFont10,1800,50,,0,0)
        oPrinter:SayAlign( nLin, nCol + 2500,  Transform(QRYRES->Z1_VALOR,"@E 999,999,999.99"), oTFont10V,1800,50,,0,0)
        nTotal += QRYRES->Z1_VALOR
        nLin+=50
        If Len(cItinerario) > 63
            While At("- ",cItinerario) > 0
                cItinerario := SubStr(cItinerario ,64,Len(cItinerario))
                oPrinter:SayAlign( nLin, nCol + 1700, Alltrim(left(cItinerario,63)),           oTFont10,1800,50,,0,0)
                nLin+=50
                nCont++
                If nCont > 37
                    oPrinter:EndPage()
                    oPrinter:StartPage()
                    fHeader()
                    nLin := 400
                    nCont := 1
                EndIf
            End
        EndIf
        QRYRES->(DbSkip())
        If MV_PAR10 == 1
            nLin:= fMostraInt(QRYRES->Z1_RESERVA,nLin)
        EndIf
        nCont++
        If nCont > 37
            oPrinter:EndPage()
            oPrinter:StartPage()
            fHeader()
            nLin := 400
            nCont := 1
        EndIf
    End
        nLin+=50
        oPrinter:SayAlign( nLin, 1400, "Valor Total",           oTFont10,1800,50,,0,0)
        oPrinter:SayAlign( nLin, 2400,Transform(nTotal ,"@E 999,999,999.99"), oTFont10V,1800,50,,0,0)

     QRYRES->(DbCloseArea())
Return

Static Function fMontaInt(cReserva)
    Local cMontaInt := ""
    Local aArea  := GetArea()
    Local cQry   := ""

    cQry := " SELECT ZB_DAERORI,ZB_DTCHEGA,ZB_AEROORI,ZB_AERODES"  + CRLF
    cQry += " FROM " + RetSQLName('SZB') + " SZB "              + CRLF
    cQry += " WHERE SZB.D_E_L_E_T_  = '' "                      + CRLF
    cQry += "     AND ZB_FILIAL = '" + FWxFilial('SZB') + "' "  + CRLF
    cQry += "     AND ZB_RESERVA = '" + cReserva + "' "         + CRLF
    cQry += " ORDER BY ZB_NTRECHO"                   + CRLF
    TCQuery cQry New Alias "QRYTMP"

    QRYTMP->(DbGoTop())
    If !QRYTMP->(EoF())
        cMontaInt := Alltrim(Posicione("GI1",1,xFilial("GI1")+QRYTMP->ZB_AEROORI,"GI1_CODINT"))+" - "
        While !QRYTMP->(EoF())
            cMontaInt += Alltrim(Posicione("GI1",1,xFilial("GI1")+QRYTMP->ZB_AERODES,"GI1_CODINT"))
            QRYTMP->(DbSkip())
            If !QRYTMP->(EoF())
                cMontaInt += " - "
            EndIf
        End
        QRYTMP->(DbCloseArea())
        RestArea(aArea)   
    EndIf
Return cMontaInt

Static Function fMostraInt(cReserva,nLin)
    Local aArea  := GetArea()
    Local cQry   := ""
    cQry := " SELECT ZB_DAERORI,ZB_DTCHEGA,ZB_AEROORI,ZB_AERODES,ZB_HRSAIDA,ZB_HRCHEGA,ZB_DAERORI,ZB_DAERDES,ZB_TMPVOO,ZB_KM"  + CRLF
    cQry += " FROM " + RetSQLName('SZB') + " SZB "              + CRLF
    cQry += " WHERE SZB.D_E_L_E_T_  = '' "                      + CRLF
    cQry += "     AND ZB_FILIAL = '" + FWxFilial('SZB') + "' "  + CRLF
    cQry += "     AND ZB_RESERVA = '" + cReserva + "' "         + CRLF
    cQry += " ORDER BY ZB_NTRECHO"                   + CRLF
    TCQuery cQry New Alias "QRYSZB"
    TCSetField("QRYSZB","ZB_DAERORI","D") 
    TCSetField("QRYSZB","ZB_DTCHEGA","D") 
    QRYSZB->(DbGoTop())
    If !QRYSZB->(EoF())
        While !QRYSZB->(EoF())
            oPrinter:SayAlign( nLin, 0100, Dtoc(QRYSZB->ZB_DAERORI),oTFont10,1800,50,,0,0)
            oPrinter:SayAlign( nLin, 0300, QRYSZB->ZB_HRSAIDA,      oTFont10,1800,50,,0,0)
            oPrinter:SayAlign( nLin, 0400, QRYSZB->ZB_DAERORI,      oTFont10,1800,50,,0,0)
            oPrinter:SayAlign( nLin, 1000, QRYSZB->ZB_DAERDES,      oTFont10,1800,50,,0,0)
            oPrinter:SayAlign( nLin, 1600, QRYSZB->ZB_TMPVOO,       oTFont10,1800,50,,0,0)
            oPrinter:SayAlign( nLin, 2000,Transform(QRYSZB->ZB_KM,"@E 999,999.99"), oTFont10V,1800,50,,0,0)
            QRYSZB->(DbSkip())
            nLin+= 50
        EndDo
    EndIf
    QRYSZB->(DbCloseArea())
    RestArea(aArea)
Return nLin

Static Function fCargaRat(cReserva)
    Local aArea  := GetArea()
    Local cQry   := ""
    cQry := " SELECT *"                                                 + CRLF
    cQry += " FROM "                                                    + CRLF
    cQry += "     " + RetSQLName('SZ3') + " SZ3 "                       + CRLF
    cQry += " WHERE "                                                   + CRLF
    cQry += "     Z3_FILIAL = '" + FWxFilial('SZ3') + "' "              + CRLF
    cQry += "     AND SZ3.D_E_L_E_T_ = ' ' "                            + CRLF
    cQry += "     AND Z3_RESERVA = '"+cReserva+"' "                     + CRLF
    cQry += " ORDER BY R_E_C_N_O_"                                                + CRLF
    TCQuery cQry New Alias "QRY_SZ3"

    aDadosRat := {}
    
    QRY_SZ3->(DbGoTop())
    If !QRY_SZ3->(EoF())
        While !QRY_SZ3->(EoF())
            aAdd(aDadosRat, { ;
                QRY_SZ3->Z3_CODCLI,;
                QRY_SZ3->Z3_LOJCLI,;
                QRY_SZ3->Z3_NOMCLI,;
                QRY_SZ3->Z3_RATEIO,;
                QRY_SZ3->Z3_VALOR,;
                .F.;
            })
            QRY_SZ3->(DbSkip())
        EndDo
    EndIf
    QRY_SZ3->(DbCloseArea())
    RestArea(aArea)
Return
