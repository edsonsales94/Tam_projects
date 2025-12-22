/*---------------------------------------------------------------------------*
 | Data       : 22/04/2024                                                   |
 | Rotina     : ANGTPR02                                                     |
 | Responsável: ENER FREDES                                                  |
 | Descrição  : Rentabilidade do Voo                                         |
 *---------------------------------------------------------------------------*/

#include "TOTVS.CH"
#Include "TopConn.ch"
#Include "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"


User Function ANGTPR03()
    Private cFileName       := "ANGTPR03"
    Private cPathInServer   := '\spool'
    Private lAdjustToLegacy := .T.
    Private lDisableSetup   := .T.
  
    Private nPagina         := 0
    Private nLinha          := 0
    Private nEspacoLin      := 20
    Private oPrinter        := Nil  
    Private cPerg           := "ANGTPR03"
    Private cTitulo         := "Rentabilidade do Voo"
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
    Private aDados := {}

    oTFont10_N:Bold := .T.
    oTFont12_N:Bold := .T.

    oPrinter := FWMSPrinter():New(cFileName,IMP_PDF , lAdjustToLegacy,cPathInServer, lDisableSetup, , , , , , .F.,)
    oPrinter:SetParm( "-RFS")
    oPrinter:cPathPDF := cPathInServer//diretorio na rede do pdf
    oPrinter:SetLandscape() //Paisagem
    oPrinter:SetPaperSize(DMPAPER_A4) //Tamanho da folha

    //quantidade maxima de linha - controle para reinicio de pagina
    nMaximo := 2300
    fCarga()

    oPrinter:StartPage()
    fHeader()
    nLinha+=60
    fBody(nLinha)
    oPrinter:EndPage()

    oPrinter:Setup()
    If oPrinter:nModalResult == PD_OK
        oPrinter:Preview()
    EndIf
   
Return 


Static Function fHeader()
    //armazena numero da pagina
    nPagina    += 1
    nLinha     := 60
    nEspacoLin := 40

    oPrinter:Box( nLinha, 15, 320, 3000, "-3")
    nLinha += 20
    oPrinter:SayBitmap( nLinha, 025, "\system\LGMID.PNG", 360, 200)
    nLinha += nEspacoLin
    oPrinter:SayAlign(nLinha, 300, Padc(Alltrim(SM0->M0_NOMECOM),150) , oTFont12_N,1800,50,,0,0)

    oPrinter:SayAlign(nLinha+75, 300, Padc("Rentabilidade de Voo",150) , oTFont12_N ,1800,50,,0,0)
    nLinha := 310
    oPrinter:Box(nLinha, 15, 2200, 3000, "-3")
    oPrinter:Box(nLinha, 15, nLinha+50, 3000, "-3")
    oPrinter:SayAlign( nLinha+5, 0050, "Data",        oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, 0205, "Voo",         oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, 0310, "Tipo",        oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, 0600, "Cliente",     oTFont10_N,500,50,,0,0) // 450
    oPrinter:SayAlign( nLinha+5, 1100, "Itinerário",  oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, 1500+110, "Faturado",    oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, 1700+100, "Comissão",    oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, 1900+070, "Combustível", oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, 2100+110, "KM/Hora",     oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, 2300+120, "Diárias",     oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, 2500+120, "Outros",      oTFont10_N,500,50,,0,0)
    oPrinter:SayAlign( nLinha+5, 2700+120, "Liquido",     oTFont10_N,500,50,,0,0)


Return

Static Function fCarga()
    Local cQry := ""
    Local cItinerario
    Local cTpVoo
    Local nX
 
    Local aTpv := {"Passageiro","Carga","Carga e Passageiro","Aeromédico","Treinamento","Translado","Voo de Cheque","Voo Teste","Manutenção","            "}
    //Seleciona dados da Reserva do Voo
        cQry := " SELECT Z1_DATA,Z1_RESERVA,Z1_AERORIG,Z1_AERODES,Z1_TPVIAJ,ZA_NUMVOO,A1_NREDUZ,Z1_VALOR,Z1_VLCOMIS FROM "+ RetSQLName('SZA') + " SZA "                                  
        cQry += " INNER JOIN "+ RetSQLName('SZ1') + " SZ1 ON ZA_RESERVA = Z1_RESERVA AND ZA_NUMVOO = Z1_NUMVIAG AND SZ1.D_E_L_E_T_ = ''"                                  
        cQry += " INNER JOIN "+ RetSQLName('SA1') + " SA1 ON ZA_CODCLI = A1_COD AND ZA_LOJCLI = A1_LOJA AND SA1.D_E_L_E_T_ = ''"                                  
        cQry += " WHERE "                                                   + CRLF
        cQry += "     Z1_FILIAL = '" + FWxFilial('SZ1') + "' "              + CRLF
        cQry += "     AND ZA_NUMVOO  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"   + CRLF
        cQry += "     AND Z1_DATA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"'"   + CRLF
        cQry += "     AND Z1_CODCLI  BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"   + CRLF
        cQry += "     AND Z1_TPRES = 'P' AND SZA.D_E_L_E_T_ = ''"                                                   + CRLF
        cQry += " ORDER BY Z1_DATA,ZA_NUMVOO "                                                   + CRLF
        TCQuery cQry New Alias "QRY"
        TCSetField("QRY","Z1_DATA","D") 
    
    aDados := {}
    While !QRY->(Eof())
        cItinerario := fMontaInt(QRY->Z1_RESERVA,QRY->Z1_AERORIG,QRY->Z1_AERODES)
        cTpVoo := aTpv[Val(QRY->Z1_TPVIAJ)]
        AADD(aDados,{QRY->Z1_DATA,;
                     QRY->ZA_NUMVOO,;
                     cTpVoo,;
                     SubStr(QRY->A1_NREDUZ,1,19),;
                     cItinerario,;
                     QRY->Z1_VALOR,;
                     QRY->Z1_VLCOMIS,;
                     0,;
                     0,;
                     0,;
                     0,;
                     0,;
                     })
        QRY->(DbSkip())
    End
    QRY->(DbCloseArea())
    For nX := 1 To len(adados)
        aDados[nX][8]  := fDespesa(aDados[nX][2],"1")
        aDados[nX][9]  := fDespesa(aDados[nX][2],"2")
        aDados[nX][10] := fDespesa(aDados[nX][2],"3")
        aDados[nX][11] := fDespesa(aDados[nX][2],"4")
        aDados[nX][12] := aDados[nX][6] - (aDados[nX][7]+aDados[nX][8]+aDados[nX][9]+aDados[nX][10]+aDados[nX][11])
    Next
Return
Static Function fDespesa(cNumVoo,cTipo)
    Local nDespesa := 0
    Local cQry

    cQry := " SELECT ZE_NUMVOO,ZE_TIPO,SUM(ZE_TOTAL) AS ZE_TOTAL FROM "+ RetSQLName('SZE') + " SZE "                                  
    cQry += " WHERE ZE_FILIAL = '" + FWxFilial('SZE') + "' AND SZE.D_E_L_E_T_ = ''"                                                   + CRLF
    cQry += "     AND ZE_NUMVOO = '" + cNumVoo + "'"              + CRLF
    cQry += "     AND ZE_TIPO = '"+cTipo+"'"   + CRLF
    cQry += " GROUP BY ZE_NUMVOO,ZE_TIPO "                                                   + CRLF
    TCQuery cQry New Alias "QRY"

    If !QRY->(Eof())
        nDespesa := QRY->ZE_TOTAL
    EndIf
    QRY->(DbCloseArea())
Return nDespesa

Static Function fBody(nLin)

    Local nCont := 1
    Local nX
    Local nVlFat := 0
    Local nVlDesp := 0
    Local nVlLiq := 0

    For nX := 1 to Len(aDados)

        _cItinerario := aDados[nX,5]

        oPrinter:SayAlign( nLin, 0050, DToc(aDados[nX,1]), oTFont10,500,50,,0,0)
        oPrinter:SayAlign( nLin, 0205, aDados[nX,2], oTFont10,500,50,,0,0)
        oPrinter:SayAlign( nLin, 0310, aDados[nX,3], oTFont10,500,50,,0,0)
        oPrinter:SayAlign( nLin, 0600, aDados[nX,4], oTFont10,500,50,,0,0)
        oPrinter:SayAlign( nLin, 1100, left(_cItinerario,40), oTFont10,1500,50,,0,0)
        oPrinter:SayAlign( nLin, 1500, Transform(aDados[nX,6],"@E 999,999,999.99"), oTFont10V,500,50,,0,0)
        oPrinter:SayAlign( nLin, 1700, Transform(aDados[nX,7],"@E 999,999,999.99"), oTFont10V,500,50,,0,0)
        oPrinter:SayAlign( nLin, 1900, Transform(aDados[nX,8],"@E 999,999,999.99"), oTFont10V,500,50,,0,0)
        oPrinter:SayAlign( nLin, 2100, Transform(aDados[nX,9],"@E 999,999,999.99"), oTFont10V,500,50,,0,0)
        oPrinter:SayAlign( nLin, 2300, Transform(aDados[nX,10],"@E 999,999,999.99"), oTFont10V,500,50,,0,0)
        oPrinter:SayAlign( nLin, 2500, Transform(aDados[nX,11],"@E 999,999,999.99"), oTFont10V,500,50,,0,0)
        oPrinter:SayAlign( nLin, 2700, Transform(aDados[nX,12],"@E 999,999,999.99"), oTFont10V,500,50,,0,0)

        If Len(_cItinerario) > 40
            nLin+=50
            While At("- ",_cItinerario) > 0
                _cItinerario := SubStr(_cItinerario ,100,Len(_cItinerario))
                oPrinter:SayAlign( nLin, 1100, Alltrim(left(_cItinerario,40)),   oTFont10,500,50,,0,0)
                nCont++
                If nCont > 30
                    oPrinter:EndPage()
                    oPrinter:StartPage()
                    fHeader()
                    nLin := 400
                    nCont := 1
                EndIf
            End
        EndIf

        nVlFat  += aDados[nX,6]
        nVlDesp += aDados[nX,7]+aDados[nX,8]+aDados[nX,9]+aDados[nX,10]+aDados[nX,11]
        nVlLiq  += aDados[nX,12]
        nLin+=50
/*
        If Len(cItinerario) > 45
            While At("- ",cItinerario) > 0
                cItinerario := SubStr(cItinerario ,49,Len(cItinerario))
                oPrinter:SayAlign( nLin, 1400, left(cItinerario,45),           oTFont10,1800,50,,0,0)
                nLin+=50
            End
        EndIf
*/
        nCont++
        If nCont > 30
            oPrinter:EndPage()
            oPrinter:StartPage()
            fHeader()
            nLin := 400
            nCont := 1
        EndIf
    Next
    nLin+=50
    oPrinter:SayAlign( nLin, 0400, "Toatl Faturado",           oTFont10,1800,50,,0,0)
    oPrinter:SayAlign( nLin, 1000,Transform(nVlFat ,"@E 999,999,999.99"), oTFont10V,1800,50,,0,0)
    nLin+=50
    oPrinter:SayAlign( nLin, 0400, "Total Despesas ",           oTFont10,1800,50,,0,0)
    oPrinter:SayAlign( nLin, 1000,Transform(nVlDesp ,"@E 999,999,999.99"), oTFont10V,1800,50,,0,0)
    nLin+=50
    oPrinter:SayAlign( nLin, 0400, "Total Liquido",           oTFont10,1800,50,,0,0)
    oPrinter:SayAlign( nLin, 1000,Transform(nVlLiq ,"@E 999,999,999.99"), oTFont10V,1800,50,,0,0)
Return

Static Function fMontaInt(cReserva,cOrig,cDest)
    Local cMontaInt := ""
    Local aArea  := GetArea()
    Local cQry   := ""

    cQry := " SELECT Z2_RESERVA,Z2_HORA,Z2_AEROORI,Z2_AERODES"  + CRLF
    cQry += " FROM " + RetSQLName('SZ2') + " SZ2 "              + CRLF
    cQry += " WHERE SZ2.D_E_L_E_T_  = '' "                      + CRLF
    cQry += "     AND Z2_FILIAL = '" + FWxFilial('SZ2') + "' "  + CRLF
    cQry += "     AND Z2_RESERVA = '" + cReserva + "' "         + CRLF
    cQry += " ORDER BY Z2_HORA"                                 + CRLF
    TCQuery cQry New Alias "QRYINT"

    QRYINT->(DbGoTop())
    If !QRYINT->(EoF())
        cMontaInt := Alltrim(Posicione("GI1",1,xFilial("GI1")+QRYINT->Z2_AEROORI,"GI1_CODINT"))+" - "
        While !QRYINT->(EoF())
            cMontaInt += Alltrim(Posicione("GI1",1,xFilial("GI1")+QRYINT->Z2_AERODES,"GI1_CODINT"))
            QRYINT->(DbSkip())
            If !QRYINT->(EoF())
                cMontaInt += " - "
            EndIf
        End
        QRYINT->(DbCloseArea())
        RestArea(aArea)   
     else
        QRYINT->(DbCloseArea())
        RestArea(aArea)   
        cMontaInt:= Alltrim(Posicione("GI1",1,xFilial("GI1")+cOrig,"GI1_CODINT"))
        cMontaInt+= " - "+Alltrim(Posicione("GI1",1,xFilial("GI1")+cDest,"GI1_CODINT"))
    EndIf
Return cMontaInt

