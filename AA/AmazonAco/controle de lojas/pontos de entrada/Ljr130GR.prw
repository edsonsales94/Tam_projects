#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPE        ³LJR130GR  ºAutor  ³Reinaldo Magalhaes º Data ³ 29/09/05     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para gravar dados do cliente para vendas  º±±
±±º          ³ em convenio, no momento da emissao da NF para cupom fiscal º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGALOJA                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Ljr130GR
  Local cAlias:= Alias()
  Private cCliente, cLoja, cNome, cEndereco, cFone, lSair 
  //Private cObs := space(100)
  //- Orcamento
  dbSelectArea("SL1")
  lSair:= .F.
  
  TelaEsc()
  cNome:= SA1->A1_NOME
  //- Regravando o codigo do cliente em caso de convenio
  If Val(SA1->A1_COD) > 0 
     //- Atualizando cabecalho da Nota fiscal
	 Reclock("SF2",.F.)
	   Replace SF2->F2_CLIENTE with SA1->A1_COD
   	   Replace SF2->F2_LOJA    with SA1->A1_LOJA
   	   //Replace SF2->F2_X_MENNF with cObs
	 MsUnlock()                               
		
     //- Itens da nota fiscal
     dbSelectArea("SD2")
     dbSetOrder(3)
     //dbSetOrder(10)
     SD2->(dbSeek(XFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
	 
	 While !SD2->(Eof()) .and. SD2->(D2_FILIAL+D2_DOC+D2_SERIE) == xFilial("SD2")+SF2->(F2_DOC+F2_SERIE)
 	    Reclock("SD2",.F.)
	      Replace SD2->D2_CLIENTE with SA1->A1_COD
   	      Replace SD2->D2_LOJA    with SA1->A1_LOJA
	    MsUnlock()                               
	    SD2->(DbSkip())
	 Enddo   

     //- Contas a receber (a partir do Cupom fiscal)
     DbSelectArea("SE1")
     dbSetOrder(1) //Filial+Prefixo+Numero+Parcela+Tipo         
     DbSeek(xFilial()+SL1->(L1_SERIE+L1_DOC))
     While !Eof() .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == xFilial()+SL1->(L1_SERIE+L1_DOC)
   	    Reclock("SE1",.F.)
        Replace SE1->E1_CLIENTE with SA1->A1_COD
        Replace SE1->E1_LOJA    with SA1->A1_LOJA
        Replace SE1->E1_NOMCLI  with SA1->A1_NREDUZ   
   	    MsUnlock()                               
        dbSkip()
      Enddo   
  EndIf
  dbSelectArea(cAlias)
Return

/////////////////////////
Static Function TelaEsc()                          
  While !(lSair)
     @ 00,000  TO 200,450 DIALOG oDlg TITLE "Cliente de Clientes"
     @ 010,010 SAY "Codigo......: "      
     @ 010,050 GET cCliente OBJECT oCodigo F3 "SA1" VALID (vercli()) SIZE 50,20
     @ 010,110 SAY "Loja.: "                  
     @ 010,125 GET cLoja  WHEN .F. OBJECT oLoja SIZE 010,020
     @ 023,010 SAY "Nome Cliente: "
     @ 023,050 GET cNome     WHEN .F. OBJECT oNome SIZE 150,020
     @ 036,010 SAY "Endereco....: "
     @ 036,050 GET cEndereco WHEN .F. OBJECT oEndereco SIZE 150,020
     @ 049,010 SAY "Fone........: "
     @ 049,050 GET cFone WHEN .F. OBJECT oFone SIZE 035,020
     
     //@ 062,010 SAY "Obs. Nota ..: "
     //@ 062,050 GET cObs  WHEN .T. OBJECT oObs  SIZE 150,020
     
     @ 085,180 BMPBUTTON TYPE 1 ACTION SairOk()
     ACTIVATE DIALOG oDlg CENTERED
     Dlgrefresh(oDlg)                                                      
  Enddo  
Return

////////////////////////
Static Function Vercli()                           
  If !(ExistCpo("SA1")) .Or. cCliente == "000001"  
     Return .F.
  Endif                 
  /***Preenche com os dados do Cliente Informado***/
  cCliente  :=  SA1->A1_COD
  cLoja     :=  SA1->A1_LOJA 
  cNome     :=  SA1->A1_NOME 
  cEndereco :=  SA1->A1_END
  cFone     :=  SA1->A1_TEL	
  /*******Atualiza os objetos na tela**************/
  oCodigo:Refresh()
  oLoja:Refresh()
  oNome:Refresh()
  oEndereco:Refresh()
  oFone:Refresh()  
  lSair:= .T.
Return .T.     

////////////////////////
Static Function SairOk()
  If lSair
     Close(oDlg)
  Else 
     MsgBox ("Informe o Cliente","Informacao","INFO")
  Endif
Return                  