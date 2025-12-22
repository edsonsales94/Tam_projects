#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "font.CH"

/*_______________________________________________________________________________
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+-----------+------------+-------+----------------------+------+------------+||
||| Funcao    |SF2460I     | Autor | ORISMAR SILVA        | Data | 10/02/2014 |||
||+-----------+------------+-------+----------------------+------+------------+||
||| Descricao | Ponto Entrada executado apos a gravacao da Venda da NF de     |||
|||           | Saida pelo Faturamento                                        |||
||+-----------+---------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

User Function SF2460I() 
   
   Local cArea        := GetArea()
   Local aRefNfe      := {}
   Local nLinha       := 0
   Local cMensagem    := ""
   Local ix, iw
   Private oDlg       := Nil
   Private cCodLocEmb := CriaVar("CC2_CODMUN")
   Private cDesEmbarq := CriaVar("CC2_MUN")
   Private cPais      := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EST")
   Private cCodTransp := Padr(iIf(Empty(SF2->F2_TRANSP),'',SF2->F2_TRANSP),TamSX3('A4_COD')[01])
   Private cDesTransp := PADR(iIf(Empty(SF2->F2_TRANSP),'',Posicione('SA4',1,xFilial('SA4')+cCodTransp,'A4_NOME')),20)
   Private nVolumes   := iIf( SF2->F2_VOLUME1 == 0,1,SF2->F2_VOLUME1)
   Private cEspecie   := Padr(iIf(Empty(SF2->F2_ESPECI1),'CAIXA',SF2->F2_ESPECI1),TamSX3('F2_ESPECI1')[01])
   Private nPesoL     := 0.0000
   Private nPesoB     := 0.0000
   Private cdNota     := SF2->F2_DOC + '/' + SF2->F2_SERIE
   Private _cdCli     := SF2->F2_CLIENTE
   Private _cdLoj     := SF2->F2_LOJA
   Private _cdNome    := Posicione('SA1',1,xFilial('SA1') + SF2->(F2_CLIENTE + F2_LOJA) , "A1_NOME" )
   Private _cCGC      := Posicione('SA1',1,xFilial('SA1') + SF2->(F2_CLIENTE + F2_LOJA) , "A1_CGC" )
   Private cEstCli    := SF2->F2_EST
   Private cTabela    := ""
   Private cNota      := SF2->F2_DOC
   Private cSerie     := SF2->F2_SERIE

   SD2->(dbSetOrder(3))
   SD2->(dbSeek(SF2->(F2_FILIAL + F2_DOC + F2_SERIE)))
	
   dbSelectArea("SC5")
   SC5->(dbSetOrder(1))
   SC5->(dbSeek(SD2->D2_FILIAL+SD2->D2_PEDIDO))
	
   _cObsCli :=  ALLTRIM(SC5->C5_MENNOTA)
   cTabela  :=  SC5->C5_TABELA
	
   if cPais = "EX" //SOMENTE SERÁ UTILIZADO PARA NOTA DE EXPORTAÇÃO.
      cCodLocEmb := GetNewPar("MV_XLOCEMB",.F.)
      cDesEmbarq := ALLTRIM(Posicione("CC2",3,xFilial("CC2")+cCodLocEmb,"CC2_MUN"))
   endif	
   
   /*/
     O campo C5_XREFNFE deverá conter as chaves da notas na seguinte ordem:
     1 - Nota de saída recusada
     2 - Nota de entrada (reentrada)
     3 - CT-e
   /*/
   if !EMPTY(SC5->C5_XREFNFE)
      nLinha:= MLCount(ALLTRIM(SC5->C5_XREFNFE),44)
      For ix:=1 to nLinha
          cChaveNF := memoline(ALLTRIM(SC5->C5_XREFNFE),44,ix)
          if ix = 1 //Consula a NF-e de saída recusada
             dbSelectArea("SF2")
             SF2->(dbSetOrder(17))
             SF2->(dbSeek(SD2->D2_FILIAL+cChaveNF))
             aAdd(aRefNfe,{SF2->F2_DOC,cChaveNF})
             cArea        := GetArea()
          else //Consulta a NF-e de Entrada e o CT-e
             dbSelectArea("SF1")
             SF1->(dbSetOrder(8))
             SF1->(dbSeek(SD2->D2_FILIAL+cChaveNF))
             aAdd(aRefNfe,{SF1->F1_DOC,cChaveNF})          
          endif
      Next   
      *//Gera a observação para a mensagem.
      if Len(aRefNfe) > 0 
         For iw:=1 to Len(aRefNfe) 
             if iw = 1//Nota fiscal de saída recusada
                cMensagem := 'Nota emitida em refaturamento a nota '+aRefNfe[iw,1]+' chave n. '+aRefNfe[iw,2] 
                cNfeSaida := aRefNfe[iw,1]
             elseif iw = 2 //Nota fiscal de entrada 
                cMensagem += ', devolvida atraves da nota '+aRefNfe[iw,1]+' chave n. '+aRefNfe[iw,2]
             else//Conhecimento de transporte Ct-e
                cMensagem += ', CT-e numero '+aRefNfe[iw,1]+' chave n. '+aRefNfe[iw,2]+', que acobertou a nota '+cNfeSaida+'. '
             endif
         Next         
         _cObsCli += cMensagem
      endif
   endif   
   *
   if SD2->D2_TES = '526'	   
      RefazAL()
   endif
   *
   if SD2->D2_TES $ ('627|635|669|674|676')	   
      AmostraR()
   endif   
   *	             
   if _cdCli = "000194" .and. _cdLoj $ '03|04'  //Desoneracao Tapajos Guajara e Boa Vista
      RefazTap()
   endif
   *
	
   nPesoL   := SC5->C5_PESOL
   nPesoB   := SC5->C5_PBRUTO
   nVolumes := SC5->C5_VOLUME1
	
   //WWW->(dbCloseArea())
	
   @ 000,000 TO 450,400 DIALOG oDlg TITLE "Observação da Nota Fiscal"
   @ 001,010 SAY "Documento : " + cdNota of oDlg Pixel
   @ 011,010 SAY "Cliente : " + _cdCli + '/' + _cdLoj + ' - ' + _cdNome of oDlg Pixel
   
   if cPais = "EX" //somente para nota de exportação.
      @ 040 - 10,010 SAY "Local Embarque" of Odlg Pixel
      @ 050 - 10,010 GET cCodLocEmb SIZE 30,07 F3 'CC2' valid cDesEmbarq := ALLTRIM(Posicione("CC2",3,xFilial("CC2")+cCodLocEmb,"CC2_MUN"))// of oDlg Pixel
      @ 050 - 10,050 GET cDesEmbarq SIZE 135,07 of Odlg Pixel WHEN Empty(cCodLocEmb)
   endif


   @ 065 - 10,010 SAY "Transportadora" of Odlg Pixel
   @ 075 - 10,010 GET cCodTransp SIZE 30,07 F3 'SA4' valid cDesTransp := Posicione('SA4',1,xFilial('SA4')+cCodTransp,'A4_NOME')// of oDlg Pixel
   @ 075 - 10,040 GET cDesTransp SIZE 155,07 of Odlg Pixel

   @ 090 - 10,010 SAY "Volumes" of Odlg Pixel
   @ 100 - 10,010 GET nVolumes SIZE 80,07  Picture '@E 999,999.99' of Odlg Pixel

   @ 090 - 10,115 SAY "Especie" of Odlg Pixel
   @ 100 - 10,115 GET cEspecie SIZE 80,07 of Odlg Pixel

   @ 115 - 10,010 SAY "Peso Liquido" of Odlg Pixel
   @ 125 - 10,010 GET nPesoL SIZE 80,07  Picture '@E 999,999.9999' of Odlg Pixel

   @ 115 - 10,115 SAY "Peso Bruto" of Odlg Pixel
   @ 125 - 10,115 GET nPesoB SIZE 80,07  Picture '@E 999,999.9999' of Odlg Pixel

   @ 140 - 10, 010 SAY "Observação " of Odlg Pixel
   @ 150 - 10, 010 GET _cObsCli SIZE 180,50  PIXEL OF oDlg MEMO

   @ 205,170 BMPBUTTON TYPE 01 ACTION Confirma()

   ACTIVATE DIALOG oDlg CENTER

   
   //RShipper(SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE)//>>> SERA IMPLEMENTADO.
   
   
   
   RestArea(cArea) 
   
   
   
  
Return


Static Function Confirma()
    Close(oDlg)
    dbSelectArea("SF2")
    SF2->(dbSetOrder(1))
    SF2->(dbSeek(XFILIAL("SF2")+cNota+cSerie))

	SF2->(RecLock('SF2',.F.))
	
	If SF2->(FieldPos("F2_TRANSP")) >0
		SF2->F2_TRANSP := cCodTransp
	Endif
	If SF2->(FieldPos("F2_VOLUME1")) >0
		SF2->F2_VOLUME1:= nVolumes
	EndIf
	If SF2->(FieldPos("F2_ESPECI1")) > 0
		SF2->F2_ESPECI1:= cEspecie
	EndIf
	If SF2->(FieldPos("F2_PLIQUI")) > 0
		SF2->F2_PLIQUI := round(nPesoL, 3)
	EndIf
	If SF2->(FieldPos("F2_PBRUTO")) >0
		SF2->F2_PBRUTO := nPesoB
	EndIf    
	If SF2->(FieldPos("F2_XOBSN")) >0
		SF2->F2_XOBSN := _cObsCli
	EndIf
	
	SF2->(MsUnlock())
	
	if cPais = "EX"
       PutMv ("MV_XLOCEMB", cCodLocEmb)
   endif

Return


Static Function CalcPeso(_cFilial,_cDoc,_cSerie)
   Local _cQry := ''

	_cQry += " SELECT SUM(D2_QUANT*B.B1_PESO) PLTOTAL, SUM(D2_QUANT*B.B1_PESBRU) PBTOTAL  "
	_cQry += " FROM " + RetSqlName('SD2') + " A "
	_cQry += " LEFT OUTER JOIN " + RetSqlName('SB1') + " B ON A.D2_COD = B.B1_COD "
	_cQry += " WHERE A.D_E_L_E_T_ = '' "
	_cQry += " AND B.D_E_L_E_T_ = '' "
	_cQry += " AND A.D2_FILIAL  = '"+_cFilial+"' "
	_cQry += " AND A.D2_DOC     = '"+_cDoc+"' "
	_cQry += " AND A.D2_SERIE   = '"+_cSerie+"' "

   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(_cQry)), "WWW", .T., .F. )

Return



/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  RefazNota ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 03/11/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Regrava o SF2, SD2, SF3, SFT e SE1                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function RefazNota()
	
	Local nTotal, nValNota, nICMSRET, nBrICMS,nValCont, nBaseRet
	Local vAlias   := { Alias() } 
    Local mQuery   := " "
    Local nXICmst  := 0
    Local nIsenipi := 0
    Local nValanti := 0
	
	vAlias := u_SalvaArea(vAlias)   // Salva as configurações das tabelas
	
	
	dbSelectArea("SD2")
	dbSetOrder(3) //Filial + Doc + Serie
	If dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE,.T.) //.and. SD2->D2_TES = '526' //Busca Itens da Nota
		
		nValNota := 0 ; nICMSRET := 0 ; nTotal := 0 ; nBrICMS := 0; nRet := 0
		
		While !EOF() .AND. SD2->D2_DOC+SD2->D2_SERIE == SF2->F2_DOC+SF2->F2_SERIE .AND. SD2->D2_FILIAL == xFilial("SD2")
			
   		dbSelectArea("DA1")
	      DA1->(dbSetOrder(1))
	      if DA1->(dbSeek(XFILIAL("DA1")+cTabela+SD2->D2_COD))
	         nXIcmst := DA1->DA1_XICMST
	      else
	         nXIcmst := 0
	      endif

   		  nTotal := nXICmst * SD2->D2_QUANT - ((nXICmst * SD2->D2_QUANT) /10)
		  nRet   := ROUND(((nTotal*SD2->D2_ALIQSOL)/100)-SD2->D2_VALICM,2)
		  RecLock("SD2",.F.)				//Regrava os Itens da Nota com preco de Custo
		  SD2->D2_BRICMS  := nTotal
		  SD2->D2_ICMSRET := nRet
		  SD2->D2_VALBRUT := SD2->D2_TOTAL + nRet
		  MsUnlock()
			
		  nBrICMS  := nBrICMS + nTotal                //SD2->D2_BRICMS
		  nICMSRET := nICMSRET + nRET                 //SD2->D2_ICMSRET
		  nValNota := nValNota + SD2->D2_TOTAL + nRet //Totais para a Nota			
		  *
		  dbSelectArea("CD2")
	      dbSetOrder(1)
	      If dbSeek(xFilial("CD2")+'S'+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+'  '+SD2->D2_COD+'SOL')
	   	     RecLock("CD2",.F.)
		     CD2->CD2_BC     := nTotal
		     CD2->CD2_VLTRIB := nRet
		     MsUnlock()
	      endif
	      *
	      dbSelectArea("SFT")
	      dbSetOrder(1)
	      If dbSeek(xFilial("SFT")+'S'+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+'  '+SD2->D2_COD,.T.)		
		     RecLock("SFT",.F.)				//Regrava os Itens da Nota com preco de Custo
      		 nCalc01         := (nTotal * SFT->FT_ALIQSOL)-SFT->FT_VALICM
      		 SFT->FT_BASERET := nTotal //nTotal //SD2->D2_TOTAL
      		 SFT->FT_ICMSRET := nRet   //ROUND((nCalc01/100),1)
      		 //SFT->FT_OUTRRET := nRet   //ROUND((nCalc01/100),1) CORRIGIR ERRO NO SPED
      		 SFT->FT_VALANTI := nRet   //ROUND((nCalc01/100),1)
      		 SFT->FT_VALCONT := SD2->D2_TOTAL + nRet   //SD2->D2_TOTAL+ROUND((nCalc01/100),1)   
             /*
             SFT->FT_BASEICM := SD2->D2_BASEICM
             SFT->FT_VALICM  := SD2->D2_VALICM              
             SFT->FT_ISENIPI := SD2->D2_BASEICM             
             SFT->FT_BASEPIS := SD2->D2_BASEICM
             SFT->FT_VALPIS  := ROUND(((SD2->D2_BASEICM*SFT->FT_ALIQPIS)/100),1)
             SFT->FT_BASECOF := SD2->D2_BASEICM             
             SFT->FT_VALCOF  := ROUND(((SD2->D2_BASEICM*SFT->FT_ALIQCOF)/100),1)
             SFT->FT_ISENICM := 0
             SFT->FT_OUTRICM := 0
             */
        	 MsUnlock()              			
      		 nValcont += SD2->D2_TOTAL + nRet  //SFT->FT_VALCONT
      		 nBaseRet += nTotal //SFT->FT_BASERET
      		 nIsenipi += SD2->D2_BASEICM //SFT->FT_ISENIPI
      		 nValanti += nRet   
          Endif
          * 
	      SD2->(dbSkip())
		EndDo
        *
        mQuery :=	" UPDATE "+RetSqlName("SF2")+" "                   
        mQuery +=	" SET F2_VALFAT = "+Transform(nValNota, "@R 99999.99")
        mQuery +=	" ,F2_VALBRUT = "+Transform(nValNota, "@R 99999.99")
        mQuery +=	" ,F2_BRICMS= "+Transform(nBrICMS, "@R 99999.99")
        mQuery +=	" ,F2_ICMSRET = "+Transform(nICMSRET, "@R 99999.99")
        mQuery +=	" FROM " + RetSqlName("SF2") + " SF2 "
        mQuery +=	" WHERE D_E_L_E_T_='' "
        mQuery +=	" AND F2_DOC = '"+SF2->F2_DOC+"'"
        mQuery +=	" AND F2_SERIE = '"+SF2->F2_SERIE+"'"
        TCSQLExec(mQuery)
        *
        mQuery :=	" UPDATE "+RetSqlName("SE1")+" "                   
        mQuery +=	" SET E1_VALOR = "+Transform(nValNota, "@R 99999.99")
        mQuery +=	" , E1_SALDO = "+Transform(nValNota, "@R 99999.99")
        mQuery +=	" , E1_VLCRUZ= "+Transform(nValNota, "@R 99999.99")
        mQuery +=	" FROM " + RetSqlName("SE1") + " SE1 "
        mQuery +=	" WHERE D_E_L_E_T_='' "
        mQuery +=	" AND E1_PREFIXO = '"+SF2->F2_SERIE+"'"
        mQuery +=	" AND E1_NUM = '"+SF2->F2_DOC+"'"
        TCSQLExec(mQuery)
        *  
        dbSelectArea("SF3")
	    dbSetOrder(6)
	    If dbSeek(xFilial("SF3")+SF2->F2_DOC+SF2->F2_SERIE)
	   	   RecLock("SF3",.F.)
		   SF3->F3_VALANTI  := nValanti //ROUND(((nBaseRet*SF3->F3_ALIQICM)/100),1)
		   SF3->F3_VALCONT  := nValcont
		   SF3->F3_BASERET  := nBaseRet
		   SF3->F3_ICMSRET  := nValanti //ROUND(((nBaseRet*SF3->F3_ALIQICM)/100),1)
            //SF3->F3_BASEICM  := SF2->F2_BASEICM 
            //SF3->F3_VALICM   := SF2->F2_VALICM
            //SF3->F3_ISENIPI  := nIsenipi
            //SF3->F3_ISENICM  := 0
            //SF3->F3_OUTRICM  := 0
		   MsUnlock()
	    endif	   		
	EndIf
	
	u_SalvaArea(vAlias,.F.)   // Restaura as configurações das tabelas
Return


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  RefazAL   ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 03/11/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Regrava o SF2, SD2, SF3, SFT e SE1                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function RefazAL()
	Local nTotal, nValNota, nICMSRET, nBrICMS,nValCont, nBaseRet
	Local vAlias := { Alias() } 
   Local mQuery := " "
	
	vAlias := u_SalvaArea(vAlias)   // Salva as configurações das tabelas
	
	dbSelectArea("SD2")
	dbSetOrder(3) //Filial + Doc + Serie
	//If dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE,.T.) .and. SD2->D2_TES = '526' //Busca Itens da Nota
		
		nValNota := 0 ; nICMSRET := 0 ; nTotal := 0 ; nBrICMS := 0; nRet := 0
		
		While !EOF() .AND. SD2->D2_DOC+SD2->D2_SERIE == SF2->F2_DOC+SF2->F2_SERIE .AND. SD2->D2_FILIAL == xFilial("SD2")
			
   		nTotal := SD2->D2_TOTAL
			nRet   := ROUND(((nTotal*6)/100),1)
			RecLock("SD2",.F.)				//Regrava os Itens da Nota com preco de Custo
			SD2->D2_BRICMS  := nTotal
			SD2->D2_ALIQSOL := 6
			SD2->D2_ICMSRET := nRet
			SD2->D2_VALBRUT := nTotal+nRET
			MsUnlock()
			
			nBrICMS  := nBrICMS + nTotal //SD2->D2_BRICMS
			nICMSRET := nICMSRET + nRET //SD2->D2_ICMSRET
			nValNota := nValNota + nTotal+nRet //Totais para a Nota
			
			*
		   dbSelectArea("CD2")
	      dbSetOrder(1)
	      If dbSeek(xFilial("CD2")+'S'+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+'  '+SD2->D2_COD+'SOL')
	   	   RecLock("CD2",.F.)
		      CD2->CD2_BC     := nTotal
		      CD2->CD2_ALIQ   := 6
		      CD2->CD2_VLTRIB := nRet
		      MsUnlock()
	      endif
			SD2->(dbSkip())
		EndDo
      *
      mQuery :=	" UPDATE "+RetSqlName("SF2")+" "                   
      mQuery +=	" SET F2_VALFAT = "+Transform(nValNota, "@R 99999.99")
      mQuery +=	" ,F2_VALBRUT = "+Transform(nValNota, "@R 99999.99")
      mQuery +=	" ,F2_BRICMS= "+Transform(nBrICMS, "@R 99999.99")
      mQuery +=	" ,F2_ICMSRET = "+Transform(nICMSRET, "@R 99999.99")
      mQuery +=	" FROM " + RetSqlName("SF2") + " SF2 "
      mQuery +=	" WHERE D_E_L_E_T_='' "
      mQuery +=	" AND F2_DOC = '"+SF2->F2_DOC+"'"
      mQuery +=	" AND F2_SERIE = '"+SF2->F2_SERIE+"'"
      TCSQLExec(mQuery)
      *
      mQuery :=	" UPDATE "+RetSqlName("SE1")+" "                   
      mQuery +=	" SET E1_VALOR = "+Transform(nValNota, "@R 99999.99")
      mQuery +=	" , E1_SALDO = "+Transform(nValNota, "@R 99999.99")
      mQuery +=	" , E1_VLCRUZ= "+Transform(nValNota, "@R 99999.99")
      mQuery +=	" FROM " + RetSqlName("SE1") + " SE1 "
      mQuery +=	" WHERE D_E_L_E_T_='' "
      mQuery +=	" AND E1_PREFIXO = '"+SF2->F2_SERIE+"'"
      mQuery +=	" AND E1_NUM = '"+SF2->F2_DOC+"'"
      TCSQLExec(mQuery)
      *
      
	   dbSelectArea("SFT")
	   dbSetOrder(1)
	   If dbSeek(xFilial("SFT")+'S'+SF2->F2_SERIE+SF2->F2_DOC,.T.)		
		   nValCont := 0 ; nBaseRet := 0; nFtIsenipi := 0
		   While !EOF() .AND. SF2->F2_DOC+SF2->F2_SERIE == SFT->FT_NFISCAL+SFT->FT_SERIE .AND. SF2->F2_FILIAL == xFilial("SFT")			
			      RecLock("SFT",.F.)				//Regrava os Itens da Nota com preco de Custo
			      nFtIsenipi := SFT->FT_ISENIPI - SFT->FT_DESCONT
			      SFT->FT_ISENIPI := nFtIsenipi
      			SFT->FT_BASERET := nFtIsenipi //SFT->FT_ISENIPI
      			SFT->FT_ICMSRET := ROUND(((nFtIsenipi*6)/100),1) //SFT->FT_ISENIPI
      			SFT->FT_VALANTI := ROUND(((nFtIsenipi*6)/100),1)//SFT->FT_ISENIPI
      			SFT->FT_ALIQSOL := 6
      			SFT->FT_VALCONT := nFtIsenipi+ROUND(((nFtIsenipi*6)/100),1)   
      			MsUnlock()              			
      			nValcont := nValcont +SFT->FT_VALCONT
      			nBaseRet := nBaseRet +SFT->FT_BASERET      			
		      	SFT->(dbSkip())
		   EndDo
      Endif



      dbSelectArea("SF3")
	   dbSetOrder(6)
	   If dbSeek(xFilial("SF3")+SF2->F2_DOC+SF2->F2_SERIE)
	   	   RecLock("SF3",.F.)
		      SF3->F3_VALANTI  := ROUND(((nBaseRet*6)/100),1)
		      SF3->F3_VALCONT  := nValcont
		      SF3->F3_BASERET  := nBaseRet
		      SF3->F3_ICMSRET  := ROUND(((nBaseRet*6)/100),1)
		      MsUnlock()
	   endif

	   
	   		
	//EndIf
	
	u_SalvaArea(vAlias,.F.)   // Restaura as configurações das tabelas
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  RefazES   ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 16/08/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Regrava o SF2, SD2, SF3, SFT e SE1 especifico Prod. 61222     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function RefazES()
	Local nTotal, nValNota, nICMSRET, nBrICMS,nValCont, nBaseRet
	Local vAlias := { Alias() } 
   Local mQuery := " "
   Local nBasRet  := 0
   Local nIsenipi := 0
   Local nValanti := 0
	
	vAlias := u_SalvaArea(vAlias)   // Salva as configurações das tabelas
	
	dbSelectArea("SD2")
	dbSetOrder(3) //Filial + Doc + Serie
		
		nValNota := 0 ; nICMSRET := 0 ; nTotal := 0 ; nBrICMS := 0; nRet := 0
		
		While !EOF() .AND. SD2->D2_DOC+SD2->D2_SERIE == SF2->F2_DOC+SF2->F2_SERIE .AND. SD2->D2_FILIAL == xFilial("SD2")
			
   		nTotal          := SD2->D2_TOTAL
   		cItem           := SD2->D2_ITEM
   		cCodProd        := SD2->D2_COD
   		nBaseICM        := SD2->D2_BASEICM
			RecLock("SD2",.F.)				//Regrava os Itens da Nota com preco de Custo
			nBCStTot        := ROUND(nTotal*153.89/100,2)
			nVlrRed         := ROUND((nBCStTot*10)/100,2)
			nBaseRet        := ROUND(nBCStTot-nVlrRed,2)
			SD2->D2_BRICMS  := nBaseRet
			nRet            := ROUND(((ROUND(nBCStTot-nVlrRed,2)*17)/100)-SD2->D2_VALICM,2)
			SD2->D2_ICMSRET := nRet	 
			SD2->D2_VALBRUT := nTotal+nRET
			MsUnlock()
			
			nBrICMS  := nBrICMS + nBaseRet     //SD2->D2_BRICMS
			nICMSRET := nICMSRET + nRET        //SD2->D2_ICMSRET
			nValNota := nValNota + nTotal+nRet //Totais para a Nota			
			*
		   dbSelectArea("CD2")
	      dbSetOrder(1)
	      If dbSeek(xFilial("CD2")+'S'+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+'  '+SD2->D2_COD+'SOL')
	   	   RecLock("CD2",.F.)
		      CD2->CD2_BC     := nBaseRet
		      CD2->CD2_VLTRIB := nRet
		      MsUnlock()
	      endif
			SD2->(dbSkip())
		EndDo
      *
      mQuery :=	" UPDATE "+RetSqlName("SF2")+" "                   
      mQuery +=	" SET F2_VALFAT = "+Transform(nValNota, "@R 99999.99")
      mQuery +=	" ,F2_VALBRUT = "+Transform(nValNota, "@R 99999.99")
      mQuery +=	" ,F2_BRICMS= "+Transform(nBrICMS, "@R 99999.99")
      mQuery +=	" ,F2_ICMSRET = "+Transform(nICMSRET, "@R 99999.99")
      mQuery +=	" FROM " + RetSqlName("SF2") + " SF2 "
      mQuery +=	" WHERE D_E_L_E_T_='' "
      mQuery +=	" AND F2_DOC = '"+SF2->F2_DOC+"'"
      mQuery +=	" AND F2_SERIE = '"+SF2->F2_SERIE+"'"
      TCSQLExec(mQuery)
      
      mQuery :=	" UPDATE "+RetSqlName("SF2")+" "                   
      mQuery +=	" SET F2_VALFAT = "+Transform(nValNota, "@R 99999.99")
      mQuery +=	" ,F2_VALBRUT = "+Transform(nValNota, "@R 99999.99")
      mQuery +=	" ,F2_BRICMS= "+Transform(nBrICMS, "@R 99999.99")
      mQuery +=	" ,F2_ICMSRET = "+Transform(nICMSRET, "@R 99999.99")
      mQuery +=	" FROM " + RetSqlName("SF2") + " SF2 "
      mQuery +=	" WHERE D_E_L_E_T_='' "
      mQuery +=	" AND F2_DOC = '"+SF2->F2_DOC+"'"
      mQuery +=	" AND F2_SERIE = '"+SF2->F2_SERIE+"'"

      *
      mQuery :=	" UPDATE "+RetSqlName("SE1")+" "                   
      mQuery +=	" SET E1_VALOR = "+Transform(nValNota, "@R 99999.99")
      mQuery +=	" , E1_SALDO = "+Transform(nValNota, "@R 99999.99")
      mQuery +=	" , E1_VLCRUZ= "+Transform(nValNota, "@R 99999.99")
      mQuery +=	" FROM " + RetSqlName("SE1") + " SE1 "
      mQuery +=	" WHERE D_E_L_E_T_='' "
      mQuery +=	" AND E1_PREFIXO = '"+SF2->F2_SERIE+"'"
      mQuery +=	" AND E1_NUM = '"+SF2->F2_DOC+"'"
      TCSQLExec(mQuery)
      *
      dbSelectArea("SFT")
	   dbSetOrder(1)
	   If dbSeek(xFilial("SFT")+'S'+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+cItem+'  '+cCodProd,.T.)		
	      RecLock("SFT",.F.)				//Regrava os Itens da Nota com preco de Custo
      	SFT->FT_BASERET := nBaseRet
      	SFT->FT_ICMSRET := nRet
      	SFT->FT_VALANTI := nRet
      	SFT->FT_VALCONT := nTotal+nRET
        	MsUnlock()              			
      	nValcont += nTotal+nRET
      	nBasRet  += nBaseRet
      	nIsenipi += nBaseICM
      	nValanti += nRet   
      Endif
      *
      dbSelectArea("SF3")
	   dbSetOrder(6)
	   If dbSeek(xFilial("SF3")+SF2->F2_DOC+SF2->F2_SERIE)
	   	   RecLock("SF3",.F.)
 		      SF3->F3_VALANTI  := nValanti
		      SF3->F3_VALCONT  := nValcont
		      SF3->F3_BASERET  := nBasRet
		      SF3->F3_ICMSRET  := nValanti
		      MsUnlock()
	   endif
	
	u_SalvaArea(vAlias,.F.)   // Restaura as configurações das tabelas

Return



/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ SalvaArea  ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 03/11/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Efetua salvamento e restauracao dos alias pre-definidos       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function SalvaArea(aAlias,lSalva)
   Local x, aAux := {}
   Local aRet

   If If( lSalva == Nil , .T., lSalva)
      For x:=1 To Len(aAlias)
         AAdd( aAux , { aAlias[x] , 0, 0} )
         aAux[x,2] := (aAux[x,1])->( IndexOrd() )
         aAux[x,3] := (aAux[x,1])->( Recno()    )  
      Next
      aRet := aClone(aAux)
   Else
      For x:=1 To Len(aAlias)
         dbSelectArea(aAlias[x,1])
         dbSetOrder(aAlias[x,2])
         dbGoTo(aAlias[x,3])
      Next
      aRet := aClone(aAlias)
   Endif
Return(aRet)                


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  RefazTap  ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 18/05/2017 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Regrava o SF2, SD2, SF3, SFT e SE1                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function RefazTap()
   Local nTotal, nValNota, nPrcven,nDesczf
   Local vAlias := { Alias() } 
   Local mQuery := " "
   Local nValCont  := 0 
   Local nDesconto := 0 
   
   vAlias := u_SalvaArea(vAlias)   // Salva as configurações das tabelas
	
   dbSelectArea("SD2")
   dbSetOrder(3) //Filial + Doc + Serie
		
   nValNota := 0 ; nTotal := 0 ; nPrcven := 0; nDesczf := 0; nTotDesczf :=0
	
   While !EOF() .AND. SD2->D2_DOC+SD2->D2_SERIE == SF2->F2_DOC+SF2->F2_SERIE .AND. SD2->D2_FILIAL == xFilial("SD2")
			
   		nTotal          := ROUND((SD2->D2_QUANT*SD2->D2_PRUNIT)-SD2->D2_DESCON,2) 
   		nPrcven         := ROUND(nTotal/SD2->D2_QUANT,6)     
   		nDesczf         := ROUND((nTotal*SD2->D2_PICM)/100,2)
   		cItem           := SD2->D2_ITEM
   		cCodProd        := SD2->D2_COD
   		*
		RecLock("SD2",.F.)				//Regrava os Itens da Nota com preco de Custo
		SD2->D2_VALBRUT := nTotal 
		SD2->D2_PRCVEN  := nPrcven 
		SD2->D2_TOTAL   := nTotal
		SD2->D2_DESCICM := nDesczf
		SD2->D2_DESCZFR := nDesczf
		SD2->D2_VALBRUT := nTotal
		MsUnlock()
			
		nValNota += nTotal //Totais para a Nota			
		*
		dbSelectArea("CD2")
	    dbSetOrder(1)
	    If dbSeek(xFilial("CD2")+'S'+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+'  '+SD2->D2_COD+'ZFM')
	   	   RecLock("CD2",.F.)
		   CD2->CD2_DESCZF := nDesczf
		   MsUnlock()
	    endif
	    *
	    dbSelectArea("SFT")
	    dbSetOrder(1)
	    If dbSeek(xFilial("SFT")+'S'+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+cItem+'  '+cCodProd,.T.)		
	       RecLock("SFT",.F.)
      	   SFT->FT_DESCICM := SD2->D2_DESCICM
      	   SFT->FT_TOTAL   := SFT->FT_ISENIPI
           SFT->FT_VALCONT := SFT->FT_BSICMOR
           SFT->FT_PRCUNIT := nPrcven
           SFT->FT_DESCZFR := nDesczf
           MsUnlock()              			
      	   nDesconto  += SFT->FT_DESCONT   
      	   nValcont   += SFT->FT_BSICMOR
      	   nTotDesczf += SFT->FT_DESCZFR
        Endif
        *
		SD2->(dbSkip())
   EndDo
   *
   mQuery :=	" UPDATE "+RetSqlName("SF2")+" "                   
   mQuery +=	" SET F2_VALFAT = "+Transform(nValNota, "@R 99999.99")
   mQuery +=	" ,F2_VALBRUT = "+Transform(nValNota, "@R 99999.99")
   mQuery +=	" ,F2_VALMERC= "+Transform(nValNota, "@R 99999.99")
   mQuery +=	" FROM " + RetSqlName("SF2") + " SF2 "
   mQuery +=	" WHERE D_E_L_E_T_='' "
   mQuery +=	" AND F2_DOC = '"+SF2->F2_DOC+"'"
   mQuery +=	" AND F2_SERIE = '"+SF2->F2_SERIE+"'"
   TCSQLExec(mQuery)
   *
   mQuery :=	" UPDATE "+RetSqlName("SE1")+" "                   
   mQuery +=	" SET E1_VALOR = "+Transform(nValNota, "@R 99999.99")
   mQuery +=	" , E1_SALDO = "+Transform(nValNota, "@R 99999.99")
   mQuery +=	" , E1_VLCRUZ= "+Transform(nValNota, "@R 99999.99")
   mQuery +=	" FROM " + RetSqlName("SE1") + " SE1 "
   mQuery +=	" WHERE D_E_L_E_T_='' "
   mQuery +=	" AND E1_PREFIXO = '"+SF2->F2_SERIE+"'"
   mQuery +=	" AND E1_NUM = '"+SF2->F2_DOC+"'"
   TCSQLExec(mQuery)
   *
   *
   dbSelectArea("SF3")
   dbSetOrder(6)
   If dbSeek(xFilial("SF3")+SF2->F2_DOC+SF2->F2_SERIE)
  	  RecLock("SF3",.F.)
      SF3->F3_VALCONT  := nValcont
	  SF3->F3_VALOBSE  := nDesconto
      SF3->F3_DESCZFR  := nTotDesczf
	  MsUnlock()
   endif
   *
   u_SalvaArea(vAlias,.F.)   // Restaura as configurações das tabelas
Return


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  AmostraR  ¦ Autor ¦ Orismar Silva        ¦ Data ¦ 28/03/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Regrava o SF2, SD2, SF3, SFT e CD2                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function AmostraR()
	Local nTotal, nValNota, nICMSRET, nBrICMS,nValCont, nBaseRet
	Local vAlias := { Alias() } 
    Local mQuery := " "
	
	vAlias := u_SalvaArea(vAlias)   // Salva as configurações das tabelas
	
	dbSelectArea("SD2")
	dbSetOrder(3) //Filial + Doc + Serie
		
	nValNota := 0 ; nICMSRET := 0 ; nTotal := 0 ; nBrICMS := 0
		
	While !EOF() .AND. SD2->D2_DOC+SD2->D2_SERIE == SF2->F2_DOC+SF2->F2_SERIE .AND. SD2->D2_FILIAL == xFilial("SD2")
			
   		  nTotal := SD2->D2_TOTAL
		  RecLock("SD2",.F.)
		  SD2->D2_BRICMS  := 0
		  SD2->D2_ICMSRET := 0
		  SD2->D2_VALBRUT := nTotal
		  MsUnlock()
			
		  nValNota += nTotal //Totais para a Nota
	      *
		  dbSelectArea("CD2")
	      dbSetOrder(1)
	      If dbSeek(xFilial("CD2")+'S'+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM+'  '+SD2->D2_COD+'SOL')
	   	     RecLock("CD2",.F.)
		     dbDelete()
		     MsUnlock()
	      endif
		  SD2->(dbSkip())
	EndDo
    *
    mQuery :=	" UPDATE "+RetSqlName("SF2")+" "                   
    mQuery +=	" SET F2_VALBRUT = "+Transform(nValNota, "@R 99999.99")
    mQuery +=	" ,F2_BRICMS= "+Transform(nBrICMS, "@R 99999.99")
    mQuery +=	" ,F2_ICMSRET = "+Transform(nICMSRET, "@R 99999.99")
    mQuery +=	" FROM " + RetSqlName("SF2") + " SF2 "
    mQuery +=	" WHERE D_E_L_E_T_='' "
    mQuery +=	" AND F2_DOC = '"+SF2->F2_DOC+"'"
    mQuery +=	" AND F2_SERIE = '"+SF2->F2_SERIE+"'"
    TCSQLExec(mQuery)
    *
    dbSelectArea("SFT")
	dbSetOrder(1)
	If dbSeek(xFilial("SFT")+'S'+SF2->F2_SERIE+SF2->F2_DOC,.T.)		
	   nValCont := 0 ; nBaseRet := 0; nFtIsenipi := 0
	   While !EOF() .AND. SF2->F2_DOC+SF2->F2_SERIE == SFT->FT_NFISCAL+SFT->FT_SERIE .AND. SF2->F2_FILIAL == xFilial("SFT")			
		     RecLock("SFT",.F.)				//Regrava os Itens da Nota com preco de Custo
      		 SFT->FT_BASERET := 0
      		 SFT->FT_ICMSRET := 0
      		 SFT->FT_VALCONT := SFT->FT_BASEICM
      		 MsUnlock()              			
		     SFT->(dbSkip())
	   EndDo
    Endif
    *
    dbSelectArea("SF3")
	dbSetOrder(6)
	If dbSeek(xFilial("SF3")+SF2->F2_DOC+SF2->F2_SERIE)
	   RecLock("SF3",.F.)
	   SF3->F3_VALCONT  := SF3->F3_BASEICM
	   SF3->F3_BASERET  := 0
	   SF3->F3_ICMSRET  := 0
	   MsUnlock()
	endif
    *
	u_SalvaArea(vAlias,.F.)   // Restaura as configurações das tabelas
	
Return



