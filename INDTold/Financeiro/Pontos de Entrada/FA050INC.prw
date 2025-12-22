#include "Protheus.ch"                                                             
#include "Winapi.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA050INC ºAutor  ³ Ronilton O. Barros º Data ³  12/10/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para gravacao da justificativa no contas  º±±
±±º          ³ a pagar, sendo possivel tambem fazer alteracao ou exclusao º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function FA050INC(cOpc)
   Local cAlias   := Alias()
   Local nOpcA    := 0
   Local oDlg     := Nil
   Local oMainWnd := Nil
   Local oFontCou := TFont():New("Courier New",9,15,.T.,.F.,5,.T.,5,.F.,.F.)   
   Local cQuery   := ""
   Local nTamDoc  := TamSX3("E2_NUM")[1]
   Local lRet     := .T.
   
   // Sai da rotina caso a pilha de chamada tenha essas duas rotinas. Isso foi necessário para evitar erro na gravação padrão
   // É necessário retornar .T. nessa situação
   If !IsInCallStack("GPEM670") .And. Upper(Trim(ProcName(2))) $ "AXINCLUIAUTO,ENCHAUTO"
      Return lRet
   Endif
   
   Private cJustific := ""
   Private cChave    := ""   
   Private cChaveAP  := ""
   
   If !Empty(M->E2_NROREQ) .AND. Empty(M->E2_VIAGEM)
      cQuery += " SELECT (E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA) CHAVE FROM "+RetSQLName("SE2")   
      cQuery += " WHERE E2_TIPO = 'PR' AND E2_NROREQ = '"+M->E2_NROREQ+"'
      cQuery += " AND E2_FORNECE = '"+M->E2_FORNECE+"' AND E2_LOJA = '"+M->E2_LOJA+"'
      cQuery += " ORDER BY E2_NUM DESC
      dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQuery)),"PRV",.F.,.T.)                  
      PRV->(DbGotop())
      If !PRV->(Eof())
         cChaveAP := xFilial("SE2")+"4"+Alltrim(PRV->CHAVE)
      EndIf  
      DbselectArea("PRV")
      DbCloseArea("PRV")  
      DbselectArea("SE2")
   EndIf

   cOpc := If( cOpc == Nil , "I", cOpc)  // Caso seja nulo, deixa padrao a inclusao "I"
 
   // cOpc = V -> Visualizacao
   // cOpc = I -> Inclusao
   // cOpc = A -> Alteracao
   // cOpc = E -> Exclusao
  
   If cOpc == "A" .AND. alltrim(SE2->E2_ORIGEM) $ "MATA100" //- Doc. do compras
      return lRet //- Grava e sai
   EndIf
   
   //- Verificando se a classe MCT permite a inclusao por este modulo
   If cOpc $ "IA" .and. !InsertMCT(Trim(M->E2_CLVL))
      return !lRet //- Nao grava e sai
   Endif   
   
   // Se for inclusao ou alteracao, verifica preenchimento do campo viagem
   If cOpc $ "IA" .And. Trim(M->E2_CLVL) == "006" .And. Empty(M->E2_VIAGEM)
      Alert("O campo viagem é obrigatorio para essa classe MCT !")
      return !lRet //- Nao grava e sai
   Endif

   // Se for inclusao ou alteracao, verifica preenchimento do campo treinamento
   If cOpc $ "IA" .And. Trim(M->E2_CLVL) == "007" .And. Empty(M->E2_TREINAM)
      alert("O campo treinamento é obrigatorio para essa classe MCT !")
      return !lRet //- Nao grava e sai
   Endif
   
   // Se for inclusao ou alteracao, verifica preenchimento do campo item contabil
   If cOpc $ "IA" .And. Trim(M->E2_CLVL) $ "001,006,007" .And. Empty(M->E2_ITEMCTA) .And. M->E2_RATEIO $ "2N" .And. M->E2_MULTNAT $ "2N" .And. ALLTrim(FunName()) == "FINA050"
      Alert("Se não for rateado é obrigatorio informar o colaborador para essa classe MCT !")
      return !lRet //- Nao grava e sai
   Endif
   
   If !(cOpc $ "VE") // Pode ser A=alteracao ou I=inclusao
      cJustific:= CriaVar("Z6_JUSTIFI",.T.)
      If (M->E2_TIPO $ "TX ,INS,ISS") .and. (cOpc == "A")
         cChave:= BuscaSE2(SE2->E2_PREFIXO,SE2->E2_NUM) //- Localiza o titulo gerador do imposto ou taxa
         If !Empty(cChave)
            return lRet //- Grava SE2 e sai
         Endif
      Endif   
      lRet:= .f.
      
      //- Justificativa do pedido no caso P.A
      If Alltrim(M->E2_TIPO) == "PA" .and. !Empty(M->E2_PEDIDO)
         dbSelectArea("SZ6")
         dbSetOrder(1)
         If dbSeek(XFILIAL("SZ6")+"1"+PADR(M->E2_PEDIDO,nTamDoc))  //- Treinamento
            cJustific := SZ6->Z6_JUSTIFI
            lret:= .t.
         Endif        
      Endif

      //- Justificativa do treinamento
      If !lret .and. !Empty(M->E2_TREINAM)
         dbSelectArea("SZ6")
         dbSetOrder(1)
         If dbSeek(XFILIAL("SZ6")+"5"+PADR(M->E2_TREINAM,nTamDoc))  //- Treinamento
            cJustific := SZ6->Z6_JUSTIFI
            lret:= .t.
         Endif        
      Endif   

      // Incluso pelo Ener em 06/02/08
      //- Justificativa da Requisicao de Pagamento
      If !Empty(M->E2_NROPRV)
         dbSelectArea("SZ6")
         dbSetOrder(1)
         If dbSeek(XFILIAL("SZ6")+"4"+PADR(M->E2_NROPRV,nTamDoc))  //- Titulo Provisorio
            cJustific := SZ6->Z6_JUSTIFI
         Endif        
      Endif   

      //- Justificativa da viagem
      If !lret .and. !Empty(M->E2_VIAGEM)
         dbSelectArea("SZ6")
         dbSetOrder(1)
         If dbSeek(XFILIAL("SZ6")+"3"+PADR(M->E2_VIAGEM,nTamDoc))  //- Viagem
            cJustific := SZ6->Z6_JUSTIFI
            lret:= .t.
         Endif
      Endif   

      //- Justificativa de AP Eletronica    
      If !lret .and. !Empty(cChaveAP)
         dbSelectArea("SZ6")
         dbSetOrder(1)
         If dbSeek(cChaveAP)  //- Viagem
            cJustific := SZ6->Z6_JUSTIFI
            lret:= .t.
         Endif
      Endif   

      //- Justificativa do documento de entrada
      If !lret
         dbSelectArea("SZ6")
         dbSetOrder(1)
         If dbSeek(xFilial("SZ6")+"4"+M->E2_NUM+M->E2_PREFIXO+M->E2_FORNECE+M->E2_LOJA)
            If (Z6_FILIAL+Z6_TIPO+Z6_NUM+Z6_PREFIXO+Z6_FORNECE+Z6_LOJA) == xFilial("SZ6")+"4"+M->E2_NUM+M->E2_PREFIXO+M->E2_FORNECE+M->E2_LOJA
               cJustific := SZ6->Z6_JUSTIFI
            Endif   
         Endif
      Endif
   Endif   
   
   Do while nOpcA == 0
      nOpcA := If( cOpc $ "VE" , 1, 0)
      If cOpc <> "E"  // Se nao for Exclusao, mostra a tela
         DEFINE MSDIALOG oDlg TITLE cCadastro+" - Descrição Detalhada" From 9,0 TO 40,81 OF oMainWnd
         oDlg:lEscClose := .F.

         @ 15,006 SAY "Prefixo"      PIXEL OF oDlg
         @ 15,036 GET M->E2_PREFIXO  PIXEL OF oDlg WHEN .F.
         @ 15,106 SAY "Numero"       PIXEL OF oDlg
         @ 15,136 GET M->E2_NUM      PIXEL OF oDlg WHEN .F.
         @ 30,006 SAY "Fornecedor"   PIXEL OF oDlg
         @ 30,036 GET M->E2_FORNECE  PIXEL OF oDlg WHEN .F.
         @ 30,076 GET M->E2_LOJA     PIXEL OF oDlg WHEN .F.
         @ 30,106 SAY "Nome"         PIXEL OF oDlg
         @ 30,136 GET M->E2_NOMFOR   PIXEL OF oDlg WHEN .F.

         @ 060,002 To 204,318 PROMPT "Descrição Detalhada" PIXEL OF oDlg
         @ 069,006 SAY "Justificativa" PIXEL OF oDlg
         @ 079,006 GET oJustific       VAR cJustific SIZE 308,90 PIXEL OF oDlg MEMO WHEN !(cOpc $ "VE")
         oJustific:oFont := oFontCou

         ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,;
                                            {|| nOpcA := If( IN030VldOk(cOpc) ,1,0), If( nOpcA==1 ,oDlg:End(),)},;
                                            {|| nOpcA := 0, If( IN030VldOk(cOpc) , oDlg:End(), 0)})
      Endif
      If nOpca == 1 .And. cOpc <> "V" //- Exclusao
         Begin Transaction
            Gravacao(cOpc)
         End Transaction
      Endif
   Enddo
   dbSelectArea(cAlias)
   
   // incluido por wermeson Gadelha no Dia    
   If (nOpcA == 1) .And. !Empty(M->E2_NROREQ) .And. (M->E2_MULTNAT == "1") .And. M->E2_TIPOREQ == "3"
      cQry := " SELECT * FROM " + RetSqlName("SE2") 
      cQry += " AS SE2 "
      cQry += " WHERE E2_NROREQ  = '" +M->E2_NROREQ + "'"
      cQry += "   AND E2_PREFIXO IN ('AP','APC')"
      cQry += "   AND E2_TIPO    = 'PR'"
      cQry += "   AND D_E_L_E_T_ <> '*'"
      cQry += " ORDER BY E2_NUM  DESC"

      dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "WWW", .T., .F. )

      If WWW->(EOF())
         WWW->(dbCloseArea())
         dbSelectArea(cAlias)
         Return (nOpcA == 1)
      EndIf

      cQuery := " Update " + RetSqlName("SEV")
      cQuery += " Set EV_PREFIXO = '"+M->E2_PREFIXO+"', "
      cQuery += "     EV_NUM     = '"+M->E2_NUM    +"', "
      cQuery += "     EV_PARCELA = '"+M->E2_PARCELA+"', "
      cQuery += "     EV_CLIFOR  = '"+M->E2_FORNECE+"', "
      cQuery += "     EV_LOJA    = '"+M->E2_LOJA   +"', "
      cQuery += "     EV_TIPO    = '"+M->E2_TIPO   +"'  "

      cQuery += " Where D_E_L_E_T_ <> '*' "
      cQuery += "   And EV_FILIAL   = '"+WWW->E2_FILIAL +"' "
      cQuery += "   And EV_PREFIXO  = '"+WWW->E2_PREFIXO+"' "
      cQuery += "   And EV_NUM      = '"+WWW->E2_NUM    +"' "
      cQuery += "   And EV_PARCELA  = '"+WWW->E2_PARCELA+"' "
      cQuery += "   And EV_TIPO     = '"+WWW->E2_TIPO   +"' "
      cQuery += "   And EV_CLIFOR   = '"+WWW->E2_FORNECE+"' "
      cQuery += "   And EV_LOJA     = '"+WWW->E2_LOJA   +"' "
      
      tcSqlExec(cQuery)

      cQuery := " Update " + RetSqlName("SEZ")
      cQuery += " Set EZ_PREFIXO = '"+M->E2_PREFIXO+"', "
      cQuery += "     EZ_NUM     = '"+M->E2_NUM    +"', "
      cQuery += "     EZ_PARCELA = '"+M->E2_PARCELA+"', "
      cQuery += "     EZ_CLIFOR  = '"+M->E2_FORNECE+"', "
      cQuery += "     EZ_LOJA    = '"+M->E2_LOJA   +"', "
      cQuery += "     EZ_TIPO    = '"+M->E2_TIPO   +"'  "

      cQuery += " Where D_E_L_E_T_ <> '*' "
      cQuery += "   And EZ_FILIAL   = '"+WWW->E2_FILIAL +"' "
      cQuery += "   And EZ_PREFIXO  = '"+WWW->E2_PREFIXO+"' "
      cQuery += "   And EZ_NUM      = '"+WWW->E2_NUM    +"' "
      cQuery += "   And EZ_PARCELA  = '"+WWW->E2_PARCELA+"' "
      cQuery += "   And EZ_TIPO     = '"+WWW->E2_TIPO   +"' "
      cQuery += "   And EZ_CLIFOR   = '"+WWW->E2_FORNECE+"' "
      cQuery += "   And EZ_LOJA     = '"+WWW->E2_LOJA   +"' "
      
      tcSqlExec(cQuery)
      Alert("Os Rateios foram substituídos com Sucesso, Favor cancelar a tela de Rateio!")

      WWW->(dbCloseArea())
      dbSelectArea(cAlias)
   EndIf 
Return (nOpcA == 1)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ Gravacao   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/12/2004 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Grava os dados da justificativa                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦ cOpc     -> Tipo da função (inclui,altera,exclui)             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Gravacao(cOpc)

   SZ6->(dbSetOrder(1))
   If SZ6->(dbSeek(xFilial("SZ6")+"4"+M->E2_NUM+M->E2_PREFIXO+M->E2_FORNECE+M->E2_LOJA))
      RecLock("SZ6",.F.)
      If cOpc <> "E"
         SZ6->Z6_JUSTIFI := cJustific
      Else
         dbDelete()
      Endif
      MsUnLock() 
   ElseIf !Empty(M->E2_NROPRV)
      If SZ6->(dbSeek(xFilial("SZ6")+"4"+PADR(M->E2_NROPRV,Len(M->E2_NUM))))
         RecLock("SZ6",.F.)
         If cOpc <> "E"
            SZ6->Z6_NUM     := M->E2_NUM
            SZ6->Z6_PREFIXO := M->E2_PREFIXO
            SZ6->Z6_FORNECE := M->E2_FORNECE
            SZ6->Z6_LOJA    := M->E2_LOJA
            SZ6->Z6_JUSTIFI := cJustific
         Else
            dbDelete()
         Endif
      Else  
         If cOpc <> "E"
            RecLock("SZ6",.T.)
            SZ6->Z6_FILIAL  := XFILIAL("SZ6")
            SZ6->Z6_TIPO    := "4"
            SZ6->Z6_NUM     := M->E2_NUM
            SZ6->Z6_PREFIXO := M->E2_PREFIXO
            SZ6->Z6_FORNECE := M->E2_FORNECE
            SZ6->Z6_LOJA    := M->E2_LOJA
            SZ6->Z6_JUSTIFI := cJustific
         EndIf  
      EndIf
      MsUnLock() 
   ElseIf cOpc <> "E"
      //- Inclusao
      RecLock("SZ6",.T.)
      SZ6->Z6_FILIAL  := XFILIAL("SZ6")
      SZ6->Z6_TIPO    := "4"
      SZ6->Z6_NUM     := M->E2_NUM
      SZ6->Z6_PREFIXO := M->E2_PREFIXO
      SZ6->Z6_FORNECE := M->E2_FORNECE
      SZ6->Z6_LOJA    := M->E2_LOJA
      SZ6->Z6_JUSTIFI := cJustific
      MsUnLock()
   Endif
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Verificando a existencia de docum. gerador de taxas e impostos¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦ cPrefixo,cNumero -> Prefixo, Documento                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static function BuscaSE2(cPrefixo,cNumero)
   Local cFilSE2  := SE2->(xFilial("SE2"))
   Local c_Alias  := Alias()
   Local n_RegSE2 := SE2->(Recno())
   Local n_IndSE2 := SE2->(IndexOrd())
 
   //- Localizando a despesa geradora dos impostos
   SE2->(dbSetOrder(1))
   SE2->(dbSeek(cFilSE2+cPrefixo+cNumero,.T.))
   While !SE2->(Eof()) .And. cFilSE2+cPrefixo+cNumero == SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM)
      If !(E2_TIPO $ "TX ,INS,ISS")
         cChave:= SE2->(E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA) 
      Endif   
      SE2->(dbSkip())
   Enddo
   SE2->(DbSetOrder(n_IndSE2))
   SE2->(Dbgoto(n_RegSE2))   
   DbSelectArea(c_Alias)

Return cChave

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ IN030VldOk ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/12/2004 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida o campo memo da Justificativa                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function IN030VldOk(cOpc)
   Local lRet := .T.

   If cOpc <> "V"
      If !( lRet := !Empty(cJustific) )
         Aviso("INVÁLIDO","Favor preencher a justificativa !",{"OK"},1)
      Endif
   Endif

Return(lRet)    

//////////////////////////////
Static function InsertMCT(cMCT)
   Local lret    := .t.
   Local nPosMCT := 0
   Local aMsgErro:= {}             

   //-                                            FIN     
   AADD(aMsgErro,{"001", "Recursos Humanos"     , .T. })  
   AADD(aMsgErro,{"002", "Equipamentos"         , .F. })
   AADD(aMsgErro,{"003", "Obras Civis"          , .F. })  
   AADD(aMsgErro,{"004", "Livros e Periodicos"  , .F. })
   AADD(aMsgErro,{"005", "Material de Consumo"  , .F. })   
   AADD(aMsgErro,{"006", "Viagens"              , .T. })   
   AADD(aMsgErro,{"007", "Treinamentos"         , .T. })   
   AADD(aMsgErro,{"008", "Servicos de Terceiros", cModulo=="GPE" })   
   AADD(aMsgErro,{"009", "Taxas Administrativas", .T. })     

   nPosMCT:= Ascan( aMsgErro, {|y| Trim(M->E2_CLVL) == Alltrim(y[1])})

   If nPosMCT > 0 .and. !aMsgErro[nPosMCT][3] .and. Trim(M->E2_TIPO) != "PA" .And. If( Type("INCLUI")<>"U",Inclui,.T.)
      Alert("Não é possivel a inclusão de despesa com " + aMsgErro[nPosMCT][2] + " por este módulo do sistema !!!" )           
      lret:= .f.
   Endif   

Return lret
