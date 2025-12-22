#include "rwmake.ch"
                            
/*/
????????????????????????????????????????????????????????????????????????
?Fun??o    ? UFR301   ? Autor ? Helio Arizono         ? Data ? 28.12.99 ?
???????????????????????????????????`????????????????????????????????????J
?Descri??o ? Emissao do Pedido de Compra                                ?
???????????????????????????????????????????????????????????????????????J
? Uso      ?                                                            ?
?????????????????????????????????????????????????????????????????????????
/*/
User Function UFR301()
     SETGLOBAL()       
     LAUTO:= .T.
     cPerg    := "UFR301"
     lContinua := .T.
     lAbortPrint := .F.
     Pergunte(cPerg,.F.)
     @ 065,000 To 363,543 Dialog oTela Title "Impressao do Pedido de Compra"
     @ 020,029 Say "Este programa imprime os Pedidos de Compra conforme os Parametros Especificados"
     @ 035,029 Say " "
     @ 050,029 Say " Configure os Parametros e confirme a Impressao do Pedido de Compra"
     @ 065,029 Say "                                                                      "
     @ 080,029 Say "                "
     @ 116,055 BmpButton Type 5 Action Pergunte(cPerg,.T.)
     @ 116,109 BmpButton Type 1 Action Lista()
     @ 116,163 BmpButton Type 2 Action Close(oTela)
     Activate Dialog oTela Centered    
     
     
Static Function Lista()
     nProg     :=1     
     SetGlobal()
     While !(ProcName(nProg)) == ""
	       If Upper(AllTrim(ProcName(nProg))) $ "A120IMPRI"
		     lAuto := .T.
	       Endif
	       nProg := nProg + 1	
     End            
     DbSelectArea("SB1")
     DbSetOrder(1)
     DbSelectArea("SA2")
     DbSetOrder(1)
     DbSelectArea("SA4")
     DbSetOrder(1)
     DbSelectArea("SA5")
     DbSetOrder(1)
     DbSelectArea("SE4")
     DbSetOrder(1)
     DbSelectArea("SC7")
     DbSetOrder(1)  
     If lAuto
      	dbSelectArea("SC7")
	    mv_par01 := C7_NUM
	    mv_par02 := C7_NUM
	    mv_par03 := C7_EMISSAO
	    mv_par04 := C7_EMISSAO
     EndIf
     bBloco := { |lEnd| Listar() }
     MsAguarde(bBloco,"Aguarde","Listando........................",.T.)
Return

/*
??????????????????????????????????????????????????????????????????????????
?Fun??o    ? Listar     ?Autor  ? Helio Arizono         ? Data ? 23/11/99 ?
?????????????????????????????????????????????????????????????????????????J
?Descri??o ? Emissao do Pedido de Compra                                  ?
???????????????????????????????????????????????????????????????????????????
*/

Static Function Listar()

       nTotFre  :=0.00 
       nTotDesp :=0.00       
                 
       oFont36:= TFont():New( "Courier New"          ,,36,,.t.,,,,,.f. )
       oFont26:= TFont():New( "Courier New"          ,,26,,.t.,,,,,.f. )
       oFont24:= TFont():New( "Courier New"          ,,24,,.t.,,,,,.f. )
       oFont22:= TFont():New( "Courier New"          ,,22,,.t.,,,,,.f. )
       oFont20:= TFont():New( "Courier New"          ,,20,,.t.,,,,,.f. )
       oFont18:= TFont():New( "Courier New"          ,,18,,.t.,,,,,.f. )
       oFont16:= TFont():New( "Courier New"          ,,16,,.t.,,,,,.f. )
       oFont14:= TFont():New( "Courier New"          ,,14,,.t.,,,,,.f. )
       oFont12:= TFont():New( "Courier New"          ,,12,,.t.,,,,,.f. )
       oFont10:= TFont():New( "Courier New"          ,,10,,.t.,,,,,.f. )
       oFont08:= TFont():New( "Courier New"          ,,08,,.t.,,,,,.f. )
       oFont06:= TFont():New( "Courier New"          ,,06,,.t.,,,,,.f. )
       oPrn := TMSPrinter():New()
       oPrn:SetLandScape() 
       oPrn:Setup()   
       cBitMasc:= "\PRGBMP\UFR301.jpg" 
       DbselectArea("SC7")
       //SetRegua(RecCount())
       //Set SoftSeek on
       DbSeek(xFilial("SC7") + MV_PAR01,.T.)
       Do while !eof() .and. SC7->C7_NUM <= MV_PAR02
          IF lAbortPrint
             if msgbox ("Deseja realmente cancelar o processo?", "Aviso", "YESNO")
                lContinua := .F.
                loop
                else
                  lAbortPrint := .F.
             endif
          endif
          If (SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)
             dbSkip()
             Loop
          Endif
          nNum := SC7->C7_NUM
          cFIl := SC7->C7_FILIAL
          cTipo:= SC7->C7_TIPO
          cNum := SC7->C7_NUM
          cFornece:=SC7->C7_FORNECE
          cLoja   :=SC7->C7_LOJA
          dEmissao:=SC7->C7_EMISSAO
          nVez := 0
          nTotIPI  := 0.00
          nTotMer  := 0.00           
          nValDesc := 0.00      
          nTotDesc := 0.00
          nTotSeg  :=0.00
          

          nTotDesp :=0.00
          nDescProd:=0  
          nItImp   := 0
          nFrete   := 0
          cCondPg := SC7->C7_COND
          nDesc1  := SC7->C7_DESC1
          nDesc2  := SC7->C7_DESC2
          nDesc3  := SC7->C7_DESC3
          cMsg    := SC7->C7_MSG
          aObs    :={}
          nQtdIt  := 0
          aItem   :={}             
          cObs1   :=""
          cObs2   :=""
         // cNatureza:=SC7->C7_NATUREZ + "-" + Posicione("SED",1,xFilial("SED") + SC7->C7_NATUREZ,"ED_DESCRIC")
          cNatureza:=""
          Do While !EOF() .AND. cFil == SC7->C7_FILIAL .and. NnUM == SC7->C7_NUM
            
             nTotDesp:=nTotDesp+SC7->C7_DESPESA
             nTotSeg:=nTotSeg+SC7->C7_SEGURO
             cTpFrete:=IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
             if !empty(SC7->C7_OBS)
                aadd(aObs,SC7->C7_OBS)
             Endif              
             DbSelectArea("SA5")
             If DbSeek(xFilial("SA5") + SC7->C7_FORNECE + SC7->C7_LOJA + SC7->C7_PRODUTO)
                cCodFor:=SA5->A5_CODPRF
                ELSE
                  cCodFor:=""
             Endif                     
             DbSelectArea("SB1")
             DbSetOrder(1)
             do case
                case MV_PAR06 == 1
                     cDesc := SC7->C7_DESCRI
                case MV_PAR06 == 2
                     DbSelectArea ("SB5")
                     if DbSeek(xFilial("SB5") + SC7->C7_PRODUTO)
                        cDesc:= SB5->B5_CEME
                        else
                          cDesc:=""
                     Endif
                case MV_PAR06 == 3
                     cDesc := SC7->C7_DESCRI  //5->B5_CEME
             Endcase
             aadd(aItem, { SC7->C7_ITEM                 ,;
                           SC7->C7_PRODUTO              ,;
                           cCodFor                      ,;
                           cDesc                        ,;
                           SC7->C7_UM                   ,;
                           SC7->C7_QUANT                ,;
                           SC7->C7_PRECO                ,;
                           SC7->C7_IPI                  ,;
                           SC7->C7_TOTAL                ,;
                           SC7->C7_DATPRF               ,;
                           SC7->C7_NUMSC                ,;
                           SC7->C7_ITEMSC               ,;
                           SC7->C7_QTSEGUM              ,; 
                           SC7->C7_SEGUM                ,;
                           SC7->C7_TOTAL / SC7->C7_QTSEGUM,;
                           SC7->C7_TES})
             DbSelectArea("SC7") 
                 
           	 If nDesc1 != 0 .or. nDesc2 != 0 .or. nDesc3 != 0
  	            nDescProd+= CalcDesc(nTotMer,nDesc1,nDesc2,nDesc3)
  	            else
                  nDescProd:= SC7->C7_VLDESC
             Endif     
             nBaseIPI := SC7->C7_TOTAL - IIF(SC7->C7_IPIBRUT=="L",nDescProd,0)
             nTotIpi:=nTotIpi+Round(nBaseIPI*SC7->C7_IPI/100,2)
             nTotMer:=nTotMer + SC7->C7_TOTAL
             nValDesc:=nValDesc + nDescProd
             nFrete  :=nFrete   + SC7->C7_VALFRE
             Reclock("SC7",.F.)
                SC7->C7_EMITIDO:="S"
              MsUnlock()
              DbSkip ()
          Enddo    
          Imprime()    
          DbselectArea("SC7")
       Enddo
       oPrn:Preview()
       MS_FLUSH()
Return

/*
????????????????????????????????????????????????????????????????????????
?Fun??o    ? Imprime  ? Autor ?   Helio Arizono       ? Data ? 01/12/99 ?
???????????????????????????????????????????????????????????????????????J
?Descri??o ? Impressao do Pedido de Compra                              ?
?????????????????????????????????????????????????????????????????????????
*/
Static Function Imprime()
       lCont := .F.
       DbSelectArea("SA2")
       if DbSeek(xFilial("SA2") + cFornece + cLoja)
          cNomeFor := SA2->A2_NOME
          Else
            cNomeFor := "Fornecedor nao esta cadastrado"
       Endif                 
       //Reposiciona a Empresa no SM)
       DbSelectarea("SM0")
       dbSetOrder(1)
       MsSeek(cEmpAnt)
       nVias:=1
       For a:=1 to nVias                               
           oPrn:StartPage()
           ImpCab()
           ImpDet()      
           ImpRoda()      
           oPrn:EndPage()
       Next a    
Return
   
/*/
????????????????????????????????????????????????????????????????????????
?Fun??o    ? ImpCab   ? Autor ?   Helio Arizono       ? Data ? 01/12/99 ?
???????????????????????????????????????????????????????????????????????J
?Descri??o ? Impressao das Cabecalho do Pedido de Compra                ?
?????????????????????????????????????????????????????????????????????????
/*/
Static Function ImpCab()    
       oPrn:SetPaperSize(Val(GetProfString(GetPrinterSession(),"PAPERSIZE","1",.T.)))
       cBitMasc:= "\PRGBMP\UFR301.jpg" 
       oPrn:SayBitmap(0020,0020,cBitMasc,3170,2350)
       IF cTipo = 1
          cTit := "Pedido de Compra "
          else
            cTit := "Autorizacao de Entrega "
       Endif     
       //Titulo
       oPrn:Say(0050,0200, cTit                                                                                                         ,oFont22,100)
       oPrn:Say(0070,2200, dtoc(dEmissao)                                                                                               ,oFont18,100)
       oPrn:Say(0070,2800, cNum                                                                                                         ,oFont18,100)
       //Dados da Empresa
       oPrn:Say(0170,0060, Alltrim(SM0->M0_NOMECOM)                                                                                     ,oFont12,100)
       oPrn:Say(0210,0060, Alltrim(SM0->M0_ENDENT)                                                                                      ,oFont12,100)
       oPrn:Say(0250,0060, "CEP  : " + transform(SM0->M0_CEPENT,"@R 99999-999") + " - " + AllTrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT  ,oFont12,100)
       oPrn:Say(0290,0060, "TEL  : " + alltrim(SM0->M0_TEL)                                                                             ,oFont12,100)
       oPrn:Say(0330,0060, "FAX  : " + alltrim(SM0->M0_FAX)                                                                             ,oFont12,100)        
       oPrn:Say(0370,0060, "CGC  : " + transform (SM0->M0_CGC, "@R 99.999.999/9999-99")                                                 ,oFont12,100)
       oPrn:Say(0410,0060, "IE   : " + SM0->M0_INSC                                                                                     ,oFont12,100)
       oPrn:Say(0450,0060, "eMail: " + MV_PAR09                                                                                         ,oFont12,100)
       //Dados do Fornecedor 
       oPrn:Say(0170,1620, alltrim(cNomeFor) + " (" + cFornece        + "/"+ cLoja        + ")"                                         ,oFont12,100)
       oPrn:Say(0210,1620, SA2->A2_END                                                                                                  ,oFont12,100)
       oPrn:Say(0250,1620, "CEP  : " + transform(SA2->A2_CEP,"@R 99999-999") + " - " + AllTrim(SA2->A2_MUN)+" - "+SA2->A2_EST           ,oFont12,100)
       oPrn:Say(0290,1620, SA2->A2_BAIRRO + " TEL : " +  "(" + alltrim(SA2->A2_DDD) + ")" + alltrim(SA2->A2_TEL)                        ,oFont12,100)
       oPrn:Say(0330,1620, "CGC  : " + transform (SA2->A2_CGC, "@R 99.999.999/9999-99")                                                 ,oFont12,100)
       oPrn:Say(0370,1620, "IE   : " + ALLTRIM(SA2->A2_INSCR)                                                                           ,oFont12,100)
       oPrn:Say(0410,1620, "Cont : " + alltrim(SC7->C7_CONTATO) + " FAX : " +   "(" + alltrim(SA2->A2_DDD) + ")" +alltrim(SA2->A2_FAX)  ,oFont12,100)
Return
           
/*/
????????????????????????????????????????????????????????????????????????
?Fun??o    ? ImpDet   ? Autor ?   Helio Arizono       ? Data ? 01/12/99 ?
???????????????????????????????????????????????????????????????????????J
?Descri??o ? Impressao das Linhas de Detalhe do Pedido de Compra        ?
?????????????????????????????????????????????????????????????????????????
*/
Static Function ImpDet()                                 
       /*
             aadd(aItem, { SC7->C7_ITEM                 ,;//01
                           SC7->C7_PRODUTO              ,;//02
                           cCodFor                      ,;//03
                           cDescPro                     ,;//04
                           SC7->C7_UM                   ,;//05
                           SC7->C7_QUANT                ,;//06 
                           SC7->C7_PRECO                ,;//07
                           SC7->C7_IPI                  ,;//08
                           SC7->C7_TOTAL                ,;//09
                           SC7->C7_DATPRF               ,;//10
                           SC7->C7_NUMSC                ,;//11
                           SC7->C7_ITEMSC               ,;//12
                           SC7->C7_QTSEGUM              ,;//13
                           SC7->C7_SEGUM                ,;//14
                           SC7->C7_TOTAL / SC7->C7_QTSEGUM})//15
        */                   
       nLin:=600                    
       nQtdItem:=0
       For a:=1 to Len(aItem)
           oPrn:Say(nLin,0030, aItem[a][1]                                                                                       ,oFont10,100)
           oPrn:Say(nLin,0140, aItem[a][2]                                                                                       ,oFont10,100)                                                                                                                                   
           oPrn:Say(nLin,0410, aItem[a][3]     	                                                                                ,oFont10,100)
           oPrn:Say(nLin,0470, aItem[a][4]                                                                                       ,oFont10,100)
           oPrn:Say(nLin,1940, aItem[a][16]                                                                                      ,oFont08,100)
           IF MV_PAR07 == 1                                                                                                                  
              oPrn:Say(nLin,2010, aItem[a][5]                                                                                    ,oFont10,100)
              oPrn:Say(nLin,2060, Transform(aItem[a][6],"@R 999,999,999.99")                                                     ,oFont10,100)
              oPrn:Say(nLin,2270, Transform(aItem[a][7],"@R 999,999,999.99")                                                     ,oFont10,100)
              oPrn:Say(nLin,2650, Transform(aItem[a][8],"@R 99")                                                                 ,oFont10,100)
              oPrn:Say(nLin,2670, Transform(aItem[a][9],"@R 99999,999.99")                                                       ,oFont10,100)
              ELSE                                      
                oPrn:Say(nLin,2010, aItem[a][14]                                                                                 ,oFont10,100)
                oPrn:Say(nLin,2060, Transform(aItem[a][13],"@R 999,999,999.99")                                                  ,oFont10,100)
                oPrn:Say(nLin,2270, Transform(aItem[a][15],"@R 999,999,999.99")                                                  ,oFont10,100)
                oPrn:Say(nLin,2650, Transform(aItem[a][8],"@R 99")                                                               ,oFont10,100)
                oPrn:Say(nLin,2670, Transform(aItem[a][9],"@R 99999,999.99")                                                     ,oFont10,100)
           Endif              
           oPrn:Say(nLin,3000, dtoc(aItem[a][10])                                                                                ,oFont10,100)
           //oPrn:Say(nLin,3010, aItem[a][11]+"/"+aItem[a][12]                                                                     ,oFont10,100)  
               
           nLin:=nLin + 40
           nQtdItem:=nQtdItem + 1
           if nQtdItem > 25
              nLin    :=600
              nQtdItem:=1 
              ImpCont()
              oPrn:EndPage()
              oPrn:StartPage()
              ImpCab()
           Endif
       Next a        
Return
/*/
????????????????????????????????????????????????????????????????????????
?Fun??o    ? ImpRoda  ? Autor ?   Helio Arizono       ? Data ? 01/12/99 ?
???????????????????????????????????????????????????????????????????????J
?Descri??o ? Impressao do Rodape do Pedido de Compra                    ?
?????????????????????????????????????????????????????????????????????????
/*/
Static Function ImpRoda()
     dbSelectArea("SM0")
     dbSetOrder(1)   && forca o indice na ordem certa
     nRegistro := Recno()
     //dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
     oPrn:Say(1745,2260, Transform(	nTotMer,"@R 99999,999.99")                                                   ,oFont12,100)
     oPrn:Say(1745,2860, Transform(	nTotIPI,"@R 99999,999.99")                                                   ,oFont12,100)
     oPrn:Say(1830,2260, Transform(	nTotMer + nTotIPI,"@R 99999,999.99")                                         ,oFont12,100)
     oPrn:Say(1830,2860, Transform(	nFrete ,"@R 99999,999.99")                                                 ,oFont12,100)
     oPrn:Say(1910,2260, Transform(	nTotDesp,"@R 99999,999.99")                                                  ,oFont12,100)
     oPrn:Say(1910,2860, Transform(	nTotSeg ,"@R 99999,999.99")                                                ,oFont12,100)
     oPrn:Say(2000,2660, Transform(	(nTotMer + nTotIpi + nFrete)- nValDesc ,"@R 99999,999.99")                    ,oFont16,100)
     oPrn:Say(1745,0100, Transform(	nDesc1 ,"@R 99999,999.99")                                                   ,oFont12,100)
     oPrn:Say(1745,0300, Transform(	nDesc2 ,"@R 99999,999.99")                                                   ,oFont12,100)
     oPrn:Say(1745,0500, Transform(	nDesc3 ,"@R 99999,999.99")                                                   ,oFont12,100)
     oPrn:Say(1745,0800, Transform(	nValDesc,"@R 99999,999.99")                                                  ,oFont12,100)
     DbSelectArea("SE4")
     DbSetOrder(1)
     If DbSeek(xFilial("SE4") + cCondPg)
        cDesPG:=SE4->E4_DESCRI
        else
          cDesPg:=""
     Endif
     oPrn:Say(1830,0100, cDesPG                                                                                  ,oFont12,100)
     cEnt:=Alltrim(SM0->M0_ENDENT) +" "+ AllTrim(SM0->M0_CIDENT)  + " "+ AllTrim(SM0->M0_ESTENT) + " CEP : " + TRANSFORM(SM0->M0_CEPENT,"@R 99999-999")
     cCob:=Alltrim(SM0->M0_ENDCOB)+ " " +Alltrim(SM0->M0_COMPCOB) + " "+ AllTrim(SM0->M0_CIDCOB) +" "+ AllTrim(SM0->M0_ESTCOB) + " CEP : " + TRANSFORM(SM0->M0_CEPCOB,"@R 99999-999") 
     oPrn:Say(1920,0100, cEnt                                                                                    ,oFont10,100)
     oPrn:Say(2000,0100, cCob                                                                                    ,oFont10,100)

     OPrn:Say(2100,2300,      cTpFrete             ,oFont12,100)
     OPrn:Say(2100,2650, cNatureza                                                                               ,oFont10,100)
     For na:=1 to len(aObs)
         OPrn:Say(2070+na*30,0260, aObs[na]                                                                       ,oFont08,100)
     Next na
Return

/*/
????????????????????????????????????????????????????????????????????????
?Fun??o    ? ImpCont  ? Autor ?   Helio Arizono       ? Data ? 01/12/99 ?
???????????????????????????????????????????????????????????????????????J
?Descri??o ? Impressao Continua na proxima pagina                       ?
?????????????????????????????????????????????????????????????????????????
/*/
Static Function ImpCont()
     OPrn:Say(2070,0100, "Continua na Proxima Pagina"                                                            ,oFont16,100)
Return

/*/
????????????????????????????????????????????????????????????????????????
?Fun??o    ? SetGlobal? Autor ?   Helio Arizono       ? Data ? 01/12/99 ?
???????????????????????????????????????????????????????????????????????J
?Descri??o ? Configuracao Global do Ambiente de Trabalho                ?
?????????????????????????????????????????????????????????????????????????
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 16/01/01 ==> Function SetGlobal
Static Function SetGlobal()
       _cPerg     := "UFR301"
       if Upper(Alltrim(cVersao)) == "P10" .and. len(_cPerg) == 6  ; _cPerg:= _cPerg + Space(4);   Endif 
       _aRegs     := {}
       dbSelectArea("SX1")
       dbSetOrder(1)
       //-> Criando Array com Perguntas
       AADD(_aRegs,{_cPerg,"01","Pedido          de ?","","","mv_ch1","C",06,0,0,"G",""   ,"mv_par01",""          ,"","","","",""           ,"","","","",""       ,"","","","",""       ,"","","","",""     ,"","","",""   ,"","","","",""})
       AADD(_aRegs,{_cPerg,"02","Pedido Ate     ate ?","","","mv_ch2","C",06,0,0,"G",""   ,"mv_par02",""          ,"","","","",""           ,"","","","",""       ,"","","","",""       ,"","","","",""     ,"","","",""   ,"","","","",""})
       AADD(_aRegs,{_cPerg,"03","Data P.C.       de ?","","","mv_ch3","D",08,0,0,"G",""   ,"mv_par03",""          ,"","","","",""           ,"","","","",""       ,"","","","",""       ,"","","","",""     ,"","","",""   ,"","","","",""})
       AADD(_aRegs,{_cPerg,"04","Data P.C.      ate ?","","","mv_ch4","D",08,0,0,"G",""   ,"mv_par04",""          ,"","","","",""           ,"","","","",""       ,"","","","",""       ,"","","","",""     ,"","","",""   ,"","","","",""})
       AADD(_aRegs,{_cPerg,"05","Somente Novos      ?","","","mv_ch5","N",01,0,0,"C",""   ,"mv_par05","Sim"       ,"","","","","Nao"        ,"","","","",""       ,"","","","",""       ,"","","","",""     ,"","","",""   ,"","","","",""})
       AADD(_aRegs,{_cPerg,"06","Descricao Produto  ?","","","mv_ch6","N",01,0,0,"C",""   ,"mv_par06","Cad.Prod." ,"","","","","Desc.Ext."  ,"","","","","P.C."   ,"","","","",""       ,"","","","",""     ,"","","",""   ,"","","","",""})
       AADD(_aRegs,{_cPerg,"07","Unidade Medida     ?","","","mv_ch7","N",01,0,0,"C",""   ,"mv_par07","Primaria"  ,"","","","","Secundaria" ,"","","","",""       ,"","","","",""       ,"","","","",""     ,"","","",""   ,"","","","",""})
       AADD(_aRegs,{_cPerg,"08","Numero Vias        ?","","","mv_ch8","N",02,0,0,"G",""   ,"mv_par08",""          ,"","","","",""           ,"","","","",""       ,"","","","",""       ,"","","","",""     ,"","","",""   ,"","","","",""})
       AADD(_aRegs,{_cPerg,"09","eMail              ?","","","mv_ch9","C",40,0,0,"G",""   ,"mv_par09",""          ,"","","","",""           ,"","","","",""       ,"","","","",""       ,"","","","",""     ,"","","",""   ,"","","","",""})
       AADD(_aRegs,{_cPerg,"10","Considera SC's     ?","","","mv_cha","N",01,0,0,"C",""   ,"mv_par10","Firmes"    ,"","","","","Prevista"   ,"","","","","Ambos"  ,"","","","",""       ,"","","","",""     ,"","","",""   ,"","","","",""})
    //   AADD(_aRegs,{_cPerg,"11","Tipo de Impressao  ?","","","mv_cha","N",01,0,0,"C",""   ,"mv_par11","Normal"    ,"","","","","Conferencia","","","","","Ambos"  ,"","","","",""       ,"","","","",""     ,"","","",""   ,"","","","",""})
       For i:= 1 to Len(_aRegs)
          If !dbSeek(_cPerg+_aRegs[i,2])
             RecLock("SX1",.T.)
             For j := 1 to FCount()
                FieldPut(j,_aRegs[i,j])
             Next
             MsUnlock()
          Endif
       Next
Return
