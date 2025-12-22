#Include "Protheus.ch"
#Include "MSMGADD.CH"
/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  AAESTC07  ¦ Autor ¦ Williams Messa       ¦ Data ¦ 26/11/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Posiciona a informaç?o no Campo Virtual BM_XSALDO             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAESTC07(cGrp)
    
    Local cQry
    Local oLstSBM := nil
    Local nList := 0 
    Local nTotGrp:=0
    Private _MRet := .F.
    Private oDlgSBM := nil
    Private aDadosSBM := {}
            
    //Query de marca x produto x referencia
    cQry := " SELECT BM_GRUPO,BM_DESC,BM_STATUS,BM_TIPGRU,SUM(B2_QATU) AS B2_QATU    "
    cQry += " FROM  "+RetSQLName("SBM") + " AS SBM WITH (NOLOCK) "
    cQry += " INNER JOIN "+RetSQLName("SB1") + " SB1 WITH (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SB1.D_E_L_E_T_='' "
    cQry += " INNER JOIN "+RetSQLName("SB2") + " SB2 WITH (NOLOCK) ON B1_COD = B2_COD AND B2_FILIAL ='" + xFilial("SB2") + "' AND SB2.D_E_L_E_T_='' "
    cQry += " WHERE SBM.D_E_L_E_T_='' AND B2_QATU > 0 "
    cQry += " GROUP BY BM_GRUPO,BM_DESC,BM_STATUS,BM_TIPGRU "
    cQry += " ORDER BY B2_QATU DESC "
   
    cAlias:= CriaTrab(Nil,.F.)
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry),cAlias, .F., .T.)
    (cAlias)->(DbGoTop())
    If (cAlias)->(Eof())
           Aviso( "N?o existe dados a consultar", "N?o existe dados a consultar", {"Ok"} )
           Return .F.
    Endif
            
       Do While (cAlias)->(!Eof())
           aAdd( aDadosSBM, { (cAlias)->BM_GRUPO,;
                              (cAlias)->BM_DESC,; 
                              (cAlias)->BM_STATUS,;
                              (cAlias)->BM_TIPGRU,;
                              Transform((cAlias)->B2_QATU,"@E 999,999,999.99")} )
           nTotGrp += (cAlias)->B2_QATU
           (cAlias)->(DbSkip())
       Enddo
            
           DbCloseArea(cAlias)
           iif(nList = 0,nList := 1,nList)
           //--Montagem da Tela  
           Define MsDialog oDlgSBM Title "Grupo de Produtos" From 0,0 To 560, 1160 Of oMainWnd Pixel
           @ 5,8 LISTBOX oLstSBM  VAR lVarMat  Fields HEADER "Cod. Grupo",; 
                                                             "Descricao Grupo",;
                                                             "Status Grupo",;
                                                             "Tipo Grupo",;
                                                              "Saldo do Grupo" SIZE 560,240;
                                                             On DblClick (AAEST07A(oLstSBM:nAt, @aDadosSBM,@_MRet)) OF oDlgSBM PIXEL
           oLstSBM:SetArray(aDadosSBM)
           oLstSBM:nAt := nList
           oLstSBM:bLine := { || {aDadosSBM[oLstSBM:nAt,1],;
                                  aDadosSBM[oLstSBM:nAt,2],;
                                  aDadosSBM[oLstSBM:nAt,3],;
                                  aDadosSBM[oLstSBM:nAt,4],;
                                  aDadosSBM[oLstSBM:nAt,5]}}
           
          
           @ 250,020 SAY "Quantidade Total dos Grupos: "  + Transform(nTotGrp,"@E 999,999,999.99")  OF oDlgSBM PIXEL COLOR CLR_RED
           DEFINE SBUTTON FROM 250,500 TYPE 1 ACTION AAEST07A(oLstSBM:nAt, @aDadosSBM, @_MRet) ENABLE OF oDlgSBM
           DEFINE SBUTTON FROM 250,530 TYPE 2 ACTION oDlgSBM:End() ENABLE OF oDlgSBM
            
           Activate MSDialog oDlgSBM Centered
   

Return(_MRet)
/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  AAEST07A  ¦ Autor ¦ Williams Messa       ¦ Data ¦ 26/11/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Tela de detalhamento do Saldo por Produto, chamada no MTA035MNU¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function AAEST07A(_nPos, aDadosSBM, _bRet)
      
 Local cQuery
 Local oLstSB1 := nil
 Local nList := 0 
 Local nTotPrd:=0
 Private oDlgZZY := nil
 Private _bRet := .F.
 Private aDadosZZY := {}

cCodigo := aDadosSBM[_nPos,1]
//aCols[n,nPosMarca] := cCodigo

 //Query de marca x produto x referencia
 cQuery := " SELECT B1_COD,B1_DESC,SUM(B2_QATU) AS B2_QATU  "
 cQuery += " FROM  "+RetSQLName("SB2") + " AS SB2 WITH (NOLOCK) "
 cQuery += " INNER JOIN "+RetSQLName("SB1") + " AS SB1 WITH (NOLOCK) ON B1_COD = B2_COD AND SB1.D_E_L_E_T_='' "
 cQuery += " WHERE B2_FILIAL = '" + xFilial("SB2") + "' AND B1_GRUPO = '" + Alltrim(cCodigo) + "'"
 cQuery += " AND SB2.D_E_L_E_T_= ' ' AND B2_QATU > 0 "
 cQuery += " GROUP BY B1_COD,B1_DESC "
 cQuery += " ORDER BY B2_QATU DESC "

 cAlias1:= CriaTrab(Nil,.F.)
 DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)
 (cAlias1)->(DbGoTop())
 If (cAlias1)->(Eof())
        Aviso( "N?o existe dados a consultar", "N?o existe dados a consultar", {"Ok"} )
        Return .F.
 Endif
         
    Do While (cAlias1)->(!Eof())
        aAdd( aDadosZZY, { (cAlias1)->B1_COD, (cAlias1)->B1_DESC, Transform((cAlias1)->B2_QATU,"@E 999,999,999.99")} )
        nTotPrd += (cAlias1)->B2_QATU
        (cAlias1)->(DbSkip())
    Enddo
         
        DbCloseArea(cAlias1)
        //nList := aScan(aDadosZZY, {|x| alltrim(x[3]) == alltrim(cCodigo)})
        iif(nList = 0,nList := 1,nList)
         
        //--Montagem da Tela
        Define MsDialog oDlgZZY Title "Detalhes do Produtos e Saldos" From 0,0 To 390, 800 Of oMainWnd Pixel
        @ 5,5 LISTBOX oLstZZY  VAR lVarMat  Fields HEADER "Cod. Produto", "Descricao Produto", "Saldo do Produto" SIZE 390,140  OF oDlgZZY PIXEL
        oLstZZY:SetArray(aDadosZZY)
        oLstZZY:nAt := nList
        oLstZZY:bLine := { || {aDadosZZY[oLstZZY:nAt,1], aDadosZZY[oLstZZY:nAt,2], aDadosZZY[oLstZZY:nAt,3]}}
        
        @ 150,020 SAY "Quantidade Total do Grupo: "  + Transform(nTotPrd,"@E 999,999,999.99")  OF oDlgZZY PIXEL COLOR CLR_BLUE
        DEFINE SBUTTON FROM 150,350 TYPE 2 ACTION oDlgZZY:End() ENABLE OF oDlgZZY
         
        Activate MSDialog oDlgZZY Centered
         
Return(_bRet)
