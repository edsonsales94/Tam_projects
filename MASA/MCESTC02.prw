// Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TBiCONN.CH"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MCESTC02   ¦ Autor ¦ Matheus Vinícius     ¦ Data ¦ 31/08/2020 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Rotina para monitorar as op´s em aberto                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function MCESTC02()
    Local aTamanho   := MsAdvSize() //retorna o tamanho disponivel para uma tela 
    Local nJanLarg   := aTamanho[5] //5 -> Coluna final dialog (janela)
    Local nJanAltu   := aTamanho[6] //6 -> Linha final dialog (janela)

    Private cSay1    := "Última atualização realizada as "+time()+"h."
    
    Private oAzul     := LoadBitmap(GetResources(),'br_azul'    )
    Private oPreto    := LoadBitmap(GetResources(),'br_preto'   )
    Private oVermelho := LoadBitmap(GetResources(),'br_vermelho')
    Private oVerde    := LoadBitmap(GetResources(),'br_verde'   )
    Private oAmarelo  := LoadBitmap(GetResources(),'br_amarelo' )
    Private oLaranja  := LoadBitmap(GetResources(),'br_laranja' )
    Private oBranco   := LoadBitmap(GetResources(),'br_branco'  )

    Private aBrowse1 := {}
    Private aBrowse2 := {}

    nAltIni := aTamanho[1]
    nAltFim := nJanAltu/2

    DEFINE DIALOG oDlg TITLE "Monitor de Ordens de Produção" FROM 000,050 TO nJanAltu,nJanLarg PIXEL

        oSay1:= TSay():New(2.5,010,{||cSay1},oDlg,,/*oFont*/,,,,.T.,/*CLR_RED*/,/*CLR_WHITE*/,200,20)

        oTButton1 := TButton():New( 003, nJanLarg/2-070, "Sair"    ,oDlg,{||oDlg:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
        oTButton1 := TButton():New( 003, nJanLarg/2-150, "Planilha",oDlg,{||Planilha()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
        
        oSay2:= TSay():New(2.5,150,{||'OP não conforme.'} ,oDlg,,,,,,.T.,,200,130)
        oSay3:= TSay():New(2.5,205,{||'OP não concluída.'},oDlg,,,,,,.T.,,200,130)
        oSay4:= TSay():New(2.5,260,{||'OP não iniciada.'} ,oDlg,,,,,,.T.,,200,130)

        oTBtnBmp1 := TBtnBmp2():New( 1.2,280,25,25,'br_vermelho',,,,{||},oDlg,,,.T. )
        oTBtnBmp2 := TBtnBmp2():New( 1.2,385,25,25,'br_amarelo' ,,,,{||},oDlg,,,.T. )
        oTBtnBmp5 := TBtnBmp2():New( 1.2,495,25,25,'br_verde'   ,,,,{||},oDlg,,,.T. )

        nLargura := nJanLarg/2-25

        oGroup1:= TGroup():New(nAltFim*0.05,1,nAltFim*0.98,nLargura,'Ordens de Produção pendentes',oDlg,,,.T.)
            
            oBrowse1 := TCBrowse():New( nAltFim*0.08,6,nLargura-10,nAltFim*0.88,,,, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)
                    
            oBrowse1:AddColumn(TCColumn():New(""             ,{|| aBrowse1[oBrowse1:nAt,01]},         ,,,"LEFT", nLargura*0.01,.T.,.F.,,,,.F.,) )
            oBrowse1:AddColumn(TCColumn():New("Emissão"      ,{|| aBrowse1[oBrowse1:nAt,02]},"@!"     ,,,"LEFT", nLargura*0.06,.F.,.F.,,{|| .F. },,.F.,) )
            oBrowse1:AddColumn(TCColumn():New("OP"           ,{|| aBrowse1[oBrowse1:nAt,03]},"@!"     ,,,"LEFT", nLargura*0.06,.F.,.F.,,{|| .F. },,.F.,) )
            oBrowse1:AddColumn(TCColumn():New("Produto"      ,{|| aBrowse1[oBrowse1:nAt,04]},"@!"     ,,,"LEFT", nLargura*0.08,.F.,.F.,,{|| .F. },,.F.,) )
            oBrowse1:AddColumn(TCColumn():New("Descrição"    ,{|| aBrowse1[oBrowse1:nAt,05]},"@!"     ,,,"LEFT", nLargura*0.20,.F.,.F.,,{|| .F. },,.F.,) )
            oBrowse1:AddColumn(TCColumn():New("Qtd. OP"      ,{|| aBrowse1[oBrowse1:nAt,06]},"@E 999,999,999,999.99",,,"LEFT"  , nLargura*0.08,.F.,.F.,,         ,,.F.,) )
            oBrowse1:AddColumn(TCColumn():New("Qtd. Apontada",{|| aBrowse1[oBrowse1:nAt,07]},"@E 999,999,999,999.99",,,"LEFT"  , nLargura*0.08,.F.,.F.,,         ,,.F.,) )
            oBrowse1:AddColumn(TCColumn():New("Saldo Dispon.",{|| aBrowse1[oBrowse1:nAt,08]},"@E 999,999,999,999.99",,,"LEFT"  , nLargura*0.08,.F.,.F.,,         ,,.F.,) )
            oBrowse1:AddColumn(TCColumn():New("Máquina."     ,{|| aBrowse1[oBrowse1:nAt,09]},"@!"     ,,,"LEFT", nLargura*0.06,.F.,.F.,,,,.F.,) )
            oBrowse1:AddColumn(TCColumn():New("Fábrica."     ,{|| aBrowse1[oBrowse1:nAt,10]},"@!"     ,,,"LEFT", nLargura*0.06,.F.,.F.,,,,.F.,) )

            //Indica que não usurá as cores padrões
            oBrowse1:lUseDefaultColors := .F. 

            //desativa ação de duplo click
            oBrowse1:bLDblClick := {||Ordena()}     

            BuscaOP()

            oBrowse1:SetBlkBackColor({ || SetBackClr(aBrowse1[oBrowse1:nAt,01])})
            oBrowse1:SetBlkColor({ || SetFontClr(aBrowse1[oBrowse1:nAt,01])})

            oTimer := TTimer():New( SUPERGETMV("MV_XESP001", .T., 30) * 1000, {|| Atualiza() }, oDlg )
            oTimer:Activate()

    ACTIVATE DIALOG oDlg CENTERED
Return

Static Function Atualiza()
    
    //busca op em aberto
    BuscaOP()
    
    //atualiza horario da ultima consulta
    cSay1 := "Última atualização realizada as "+time()+"h."
    oSay1:SetText( cSay1 )
    oSay1:CtrlRefresh()
    
    //atualiza browse
    oBrowse1:Refresh()

    //seta o foco para o botao
    oTButton1:SetFocus()
Return

Static Function BuscaOP()

    aBrowse1 := {}
   
    BeginSql Alias "QRY"
        SELECT
            C2_PRODUTO
            ,B1_DESC
            ,C2_NUM+C2_ITEM+C2_SEQUEN AS 'OP'
            ,C2_QUANT
            ,C2_QUJE
            ,C2_QUANT-C2_QUJE AS 'SALDO'
            ,C2_XMAQ
            ,C2_EMISSAO
	        ,C2_DATPRI
            ,ISNULL(H1_XFABRIC,'') AS FABRICA
        FROM %table:SC2% SC2
        LEFT JOIN %table:SB1% SB1
            ON SB1.%notDel%
            AND B1_COD = C2_PRODUTO 
        LEFT JOIN %table:SH1% SH1
            ON SH1.%notDel%
	        AND H1_CODIGO = C2_XMAQ
        WHERE
            SC2.%notDel%
            AND C2_DATRF = ''
        ORDER BY
            FABRICA,C2_XMAQ,C2_NUM
    EndSql

    While !QRY->(EOF())
        
        aAdd(aBrowse1,{;
            Nil,;
            dtoc(stod(QRY->C2_DATPRI)),;
            QRY->OP,;
            QRY->C2_PRODUTO,;
            QRY->B1_DESC,;
            QRY->C2_QUANT,;
            QRY->C2_QUJE,;
            QRY->C2_QUANT-QRY->C2_QUJE,;
            QRY->C2_XMAQ,;
            QRY->FABRICA,;
        })
        
        If aBrowse1[len(aBrowse1),8] > 0 .and. aBrowse1[len(aBrowse1),7] > 0
            aBrowse1[len(aBrowse1),1] := oAmarelo
        ElseIf aBrowse1[len(aBrowse1),7] == 0
            aBrowse1[len(aBrowse1),1] := oBranco
        Else
            aBrowse1[len(aBrowse1),1] := oVermelho
        EndIf
       
        QRY->(DbSkip())
    Enddo

    QRY->(DbCloseArea())

    If len(aBrowse1) == 0
        aAdd(aBrowse1,{Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil})
    EndIf

    //atribui o array ao brose
    oBrowse1:SetArray(aBrowse1)

    //atualiza descrição do grupo com a quantidade de op´s em aberto
    oGroup1:cTitle := ""
    oGroup1:cCaption := oGroup1:cTitle := oGroup1:cTitle+" | "+cValtoChar(len(aBrowse1))+" op´s pendentes."

Return

Static Function SetFontClr(oColor)

    Local uColor := CLR_WHITE    

    If oColor == oBranco
        uColor := CLR_WHITE          
    ElseIf oColor == oAmarelo 
        uColor := CLR_BLACK
    Else
        uColor := CLR_WHITE 
    EndIf

Return uColor

Static Function SetBackClr(oColor)
    Local uColor  := Nil
    
    If oColor == oBranco
        uColor := CLR_CYAN          
    ElseIf oColor == oAmarelo 
        uColor := CLR_YELLOW
    Else
        uColor := CLR_RED
    EndIf

Return uColor

Static Function Ordena()
    aSort(aBrowse1, , , { | x,y | x[oBrowse1:nColPos] < y[oBrowse1:nColPos] } )
    //atribui o array ao brose
    oBrowse1:SetArray(aBrowse1)
    //atualiza browse
    oBrowse1:Refresh()
Return

Static Function Planilha()
    Local cFileName       := "MCESTC02-"+Dtos(MSDate())+"-"+StrTran(Time(),":","")
    Local cPathInServer   := GetTempPath()+cFileName+".xml"

    cGuia   := "OP-ABERTO"
    cTabela := "OP-ABERTO"

    oFWMsExcel := FWMSExcel():New()
    oFWMsExcel:AddworkSheet(cGuia)
    oFWMsExcel:AddTable(cGuia,cTabela)
    oFWMsExcel:AddColumn(cGuia,cTabela,"Emissão"      ,1,1) //1 = Modo Texto
    oFWMsExcel:AddColumn(cGuia,cTabela,"OP"           ,1,1) //1 = Modo Texto
    oFWMsExcel:AddColumn(cGuia,cTabela,"Produto"      ,1,1) //1 = Modo Texto
    oFWMsExcel:AddColumn(cGuia,cTabela,"Descrição"    ,1,1) //1 = Modo Texto
    oFWMsExcel:AddColumn(cGuia,cTabela,"Qtd. OP"      ,1,2) //1 = Modo Numérico
    oFWMsExcel:AddColumn(cGuia,cTabela,"Qtd. Apontada",1,2) //1 = Modo Numérico
    oFWMsExcel:AddColumn(cGuia,cTabela,"Saldo Dispon.",1,2) //1 = Modo Numérico
    oFWMsExcel:AddColumn(cGuia,cTabela,"Máquina"      ,1,1) //1 = Modo Texto
    oFWMsExcel:AddColumn(cGuia,cTabela,"Fábrica"      ,1,1) //1 = Modo Texto

    nFrom := 0
    While nFrom < len(aBrowse1)
        nFrom ++

        oFWMsExcel:AddRow(cGuia,cTabela,{;
            aBrowse1[nFrom,02],;
            aBrowse1[nFrom,03],;
            aBrowse1[nFrom,04],;
            aBrowse1[nFrom,05],;
            aBrowse1[nFrom,06],;
            aBrowse1[nFrom,07],;
            aBrowse1[nFrom,08],;
            aBrowse1[nFrom,09],;
            aBrowse1[nFrom,10]}) 
    Enddo

    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cPathInServer)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()            
    oExcel:WorkBooks:Open(cPathInServer)     
    oExcel:SetVisible(.T.)               
    oExcel:Destroy() 

Return
