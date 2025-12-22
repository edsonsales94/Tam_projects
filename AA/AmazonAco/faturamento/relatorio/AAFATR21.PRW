#include 'protheus.ch'
#include 'parmtype.ch'
#include "COLORS.CH"
#include "RPTDEF.CH"
#include "FWPrintSetup.ch"

#define TamLin 10 

User function AAFATR21(cOrc)

    cOrcamento := cOrc
    
    lAdjustToLegacy := .F. 
    lDisableSetup  := .T.
    
    Private oPrinter := FWMSPrinter():New("ORCAMENTO.REL", IMP_PDF, lAdjustToLegacy, , lDisableSetup)
    
    PRIVATE oFont10N   := TFontEx():New(oPrinter,"Times New Roman",08,08,.T.,.T.,.F.)// 1
    PRIVATE oFont07N   := TFontEx():New(oPrinter,"Times New Roman",06,06,.T.,.T.,.F.)// 2
    PRIVATE oFont07    := TFontEx():New(oPrinter,"Times New Roman",06,06,.F.,.T.,.F.)// 3
    PRIVATE oFont08    := TFontEx():New(oPrinter,"Times New Roman",07,07,.F.,.T.,.F.)// 4
    PRIVATE oFont08N   := TFontEx():New(oPrinter,"Times New Roman",06,06,.T.,.T.,.F.)// 5
    PRIVATE oFont09N   := TFontEx():New(oPrinter,"Times New Roman",08,08,.T.,.T.,.F.)// 6
    PRIVATE oFont09    := TFontEx():New(oPrinter,"Times New Roman",08,08,.F.,.T.,.F.)// 7
    PRIVATE oFontX     := TFontEx():New(oPrinter,"Times New Roman",11,11,.T.,.T.,.F.)// 6
    PRIVATE oFontY     := TFontEx():New(oPrinter,"Times New Roman",11,11,.T.,.T.,.F.)// 7
    PRIVATE oFont10    := TFontEx():New(oPrinter,"Times New Roman",09,09,.F.,.T.,.F.)// 8
    PRIVATE oFont1     := TFontEx():New(oPrinter,"Times New Roman",09,09,.F.,.T.,.F.)// 8
    PRIVATE oFont2     := TFontEx():New(oPrinter,"Times New Roman",13,13,.T.,.T.,.F.)// 9
    PRIVATE oFont11    := TFontEx():New(oPrinter,"Times New Roman",10,10,.F.,.T.,.F.)// 9
    PRIVATE oFont12    := TFontEx():New(oPrinter,"Times New Roman",11,11,.F.,.T.,.F.)// 10
    PRIVATE oFont11N   := TFontEx():New(oPrinter,"Times New Roman",10,10,.T.,.T.,.F.)// 11
    PRIVATE oFont18N   := TFontEx():New(oPrinter,"Times New Roman",28,28,.T.,.T.,.F.)// 12 
    PRIVATE OFONT12N   := TFontEx():New(oPrinter,"Times New Roman",11,11,.T.,.T.,.F.)// 12
    PRIVATE OFONT14N   := TFontEx():New(oPrinter,"Times New Roman",13,13,.T.,.T.,.F.)// 12
    PRIVATE OFONT22N   := TFontEx():New(oPrinter,"Times New Roman",26,26,.T.,.T.,.F.)// 12 
    Private oFont20    := TFont():New("Arial"      ,9,25,.T.,.T.,5,.T.,5,.T.,.F.)

    Private PixelX := oPrinter:nLogPixelX()
    Private PixelY := oPrinter:nLogPixelY()
    
    Private nHPage := oprinter:nHorzRes()
    nHPage := 590    
    Private nVPage := oprinter:nVertRes()
    nVPage := 765        
    
    Private cObs1:= Space(60),cObs2:= Space(60)
    Private cOrcamento := Space(06)  
    Private nPesoTotal := 0
    Private _ndTotDesc := 0
    pRIVATE nDescItem  := 0
    Private cPerg := Padr("ORCAMEN",Len(SX1->X1_GRUPO))

    oPrinter:Setup()    
    

  DEFINE FONT oFont3  NAME "Arial" SIZE 0,15 Bold OF oPrinter
   DEFINE FONT oFont4  NAME "Arial" SIZE 0,20 Bold OF oPrinter
   DEFINE FONT oFont6  NAME "Arial" SIZE 0,09 Bold OF oPrinter    

    cOrc := If( cOrc == Nil , SCJ->CJ_NUM, cOrc)
    ldAuto := Empty(cOrc)

    SCJ->(DbSetOrder(1))
    SCJ->(DbSeek(xFilial("SCJ")+cOrc))
   
    cObs1    := IIF(Empty(SCJ->CJ_MENNOTA),"",SCJ->CJ_MENNOTA)
    cdNumOs := "" //IIF(Empty(SCJ->CJ_XNUMOS),"",SCJ->CJ_XNUMOS)

    SB1->(dbSetOrder(1))
    SA1->(dbSetOrder(1))
    SCK->(dbSetOrder(1))
    SCK->(dbSeek(xFilial("SCK")+cOrc))

    Processa({|| RPrint(cOrc),"Processando Dados"})
    oPrinter:EndPage()
    oPrinter:Preview()
    
    //oPrinter:SetResolution(72)
    //o/Printer:SetPortrait()
    //oPrinter:SetPaperSize(DMPAPER_A4) 
    //oPrinter:SetMargin(60,60,60,60) 
    // nEsquerda, nSuperior, nDireita, nInferior 
    //oPrinter:cPathPDF := "c:\directory\" // Caso seja

	
Return Nil

*****************************************
Static FUNCTION RReport(cOrc)
*****************************************

   //AVPRINT oPrn NAME "AUTORIZAÇÃO PARA RETIRADA DE MERCADORIA"
   oPrinter := TMSPrinter():New( "RELATORIO GRAFICO" )

   DEFINE FONT oFont1  NAME "Arial" SIZE 0,10 Bold OF oPrinter
   DEFINE FONT oFont2  NAME "Arial" SIZE 0,11 Bold OF oPrinter
   DEFINE FONT oFont25 NAME "Arial" SIZE 0,14 Bold OF oPrinter
   DEFINE FONT oFont3  NAME "Arial" SIZE 0,15 Bold OF oPrinter
   DEFINE FONT oFont4  NAME "Arial" SIZE 0,20 Bold OF oPrinter
   DEFINE FONT oFont5  NAME "Arial" SIZE 0,22 Bold OF oPrinter
   DEFINE FONT oFont6  NAME "Arial" SIZE 0,09 Bold OF oPrinter
   DEFINE FONT oFontT  NAME "Arial" SIZE 0,16 Bold OF oPrinter

   DEFINE FONT oFontX  NAME "Arial" SIZE 0,09 Bold Italic Underline OF oPrinter
   DEFINE FONT oFontY  NAME "Arial" SIZE 0,09 Bold OF oPrinter

   //oPrinter:SETPORTRAIT()
   //oPrinter:SetPortrait() // Estilo retrato

   //oPrinter:StartPage()
   Processa({|X| lEnd := X, RPrint(cOrc) })
   //oPrinter:EndPage()

   //AVENDPRINT

Return .T.



Static Function RPrint(cOrc)
*****************************************
   Local xCor, cReserv
   Local nPrcVenda := 0
   Local nY := 0 
   Private nPage:=1,nLine,nLinVert := 10,nColIni:=10,nColFim:=2300
   Private cObs:= Space(60)   
   PRIVATE nTotIcRet := 0 
   Private nwQuant   := 0
   Private lSegunda  := MsgYesNo("Deseja imprimir o orçamento na segunda unidade de medida?")  // wermeson em 08/11 - Chamado 40376

   nCol1:=nColIni       //Produto
   nCol2:=nCol1+1100    //Desconto
   nCol3:=nCol1+230     //Preço unitário
   nCol4:=nCol3+120     //Quantidade
   nCol5:=nCol4+180     //Total
   nLinFim:=500

   nTotal    := 0
   nDescItem := 0

   RCabec()
   nPesoTotal := 0
   _ndTotdesc := 0
   nTotIcRet  := 0

  // alert("teste")

   While !SCK->(EOF()) .and. SCK->CK_NUM = SCJ->CJ_NUM
   
      ProcRegua(SCK->(LastRec()))
      ver_pag()

      SB1->(dbSeek(xFilial("SB1")+SCK->CK_PRODUTO))
      nPrcVenda := If ( SCK->CK_PRUNIT > 0, SCK->CK_PRUNIT, SCK->CK_PRCVEN)
      /* if Empty(SCK->CK_DESCONT) .And. SCK->CK_PRCTAB <> SCK->CK_VRUNIT
         if Empty(SCJ->CJ_DESCONT)
            nPrcVenda := SCK->CK_VRUNIT
         Elseif (SCK->CK_PRCTAB <> (SCK->CK_VRUNIT+(SCK->CK_DESCPRO/SCK->CK_QUANT)))
            nPrcVenda := SCK->CK_VRUNIT+(SCK->CK_DESCPRO/SCK->CK_QUANT)
         Endif
      Endif */
                                              
      nValor := Round( SCK->CK_QTDVEN * SCK->CK_PRCVEN ,2)

      // wermeson em 08/11 - Chamado 40376
      If lsegunda .AND. SB1->B1_CONV <> 0
            If SB1->B1_TIPCONV == "M"
						nwQuant := SCK->CK_QTDVEN * SB1->B1_CONV
					Else
						nwQuant := SCK->CK_QTDVEN / SB1->B1_CONV
				EndIf 
         Else 
            nwQuant := SCK->CK_QTDVEN
      EndIf 

      nPrcVenda := Round( nValor / nwQuant , 2 ) 

      
      /*
      oPrinter:Say(nLine ,nCol1       , PadR("Item"      ,60)    ,oFont2,,,,3)
      oPrinter:Say(nLine ,nCol1 + 100 , PadR("Codigo"    ,60)    ,oFont2,,,,3)
   	  oPrinter:Say(nLine ,nCol1 + 300 , PadR("Qtde."     ,30)    ,oFont2,,,,3)
   	  oPrinter:Say(nLine ,nCol1 + 427 , PadR("UM"        ,60)    ,oFont2,,,,3)
   	  oPrinter:Say(nLine ,nCol1 + 480 , PadL("Descricao" ,12)    ,oFont2,,,,3)
   	  oPrinter:Say(nLine ,nCol3 + 245 , PadR("Peso"      ,15)    ,oFont2,,,,3)
   	  oPrinter:Say(nLine ,nCol4 + 100 , PadL("Preco"     ,10)    ,oFont2,,,,3)
   	  oPrinter:Say(nLine ,nCol5 + 80  , PadL("Total R$"  ,15)    ,oFont2,,,,3)
      */
       //If !EMPTY(SCK->CK_RESERVA)
      //   xCor := CLR_HBLUE
         cReserv := oFontX:ofont
     // Else
         xCor := Nil
        cReserv := oFontY:ofont
      //EndIf

      oPrinter:Say(nLine,nCol1 + 10 ,PadR(Left(SCK->CK_ITEM,10),10) ,cReserv,,xCor,,3)

      // Efetua quebra da descrição em N linhas
      cDescri := Alltrim(SB1->B1_ESPECIF)
      nL      := 0
      nLin    := MlCount(cDescri,60)
      For nY:=1 To nLin
         oPrinter:Say(nLine+nL,nCol1 + 140,MemoLine(cDescri,60,nY),cReserv,,xCor,,3)
         nL+=10
      Next
      
      oPrinter:Say(nLine,nCol1+30       ,Padl( SB1->B1_COD   ,13)    ,cReserv,,xCor,,1)
      oPrinter:Say(nLine,nCol1+60       ,Transform( nwQuant ,"@E 999,999,999.99")   ,cReserv,,xCor,,1)
      oPrinter:Say(nLine,nCol1+100      ,PadL( If(lSegunda, SB1->B1_SEGUM, SB1->B1_UM)          ,12)    ,cReserv,,xCor,,1) // validacao 2 um
      oPrinter:Say(nLine,nCol1+430      ,PadL(Transform(SB1->B1_PESO * SCK->CK_QTDVEN, "@E 99,999,999,999.99"),19)  ,cReserv,,xCor,,1)
//                     nCol3 + 245
      //oPrinter:Say(nLine,nCol3 + 180      ,PadL(Transform(SB1->B1_PESO * SCK->CK_QTDVEN ,"@E 999,999.999"),11)   ,cReserv,,xCor,,1)
      oPrinter:Say(nLine,nCol1 + 490      ,PadL(Transform(nPrcVenda ,"@E 9,999.999"),10)   ,cReserv,,xCor,,1)
      oPrinter:Say(nLine,nCol1 + 520      ,PadL(Transform(nValor    ,"@E 99,999,999.99"),15)  ,cReserv,,xCor,,1)
      
      nPesoTotal += SB1->B1_PESO * SCK->CK_QTDVEN
      nTotal     += nValor
      nDescItem  += SCK->CK_VALDESC
      _ndTotDesc += SCK->CK_VALDESC
      nTotIcRet  += 0
      nLine+=nL

      SCK->(dbSkip())
   Enddo

   RRoda()

Return


Static Function CriaSx1(cPerg)
*----------------------------------------------------------------------------------------------*
Local aTam := {}
aAdd(aTam,{TamSx3("L1_NUM")[01],TamSx3("L1_NUM")[02]})

PutSX1(cPerg,"01","Orcamento ?" ,"","","mv_ch1","C",aTam[01][01],aTam[01][02],0,"G","","SL1","","","mv_par01")
Return


*****************************************
Static Function RCabec()
*****************************************
   Local nLarg := 120
   Local nAlt  := 57    
   Local cLogo      := "LGMID1.bmp" //FisxLogo("1")

   SA1->(dbSeek(xFilial("SA1")+SCJ->(CJ_CLIENTE+CJ_LOJA)))

   nLine := 15
   //2300
   //alert(nHPage)
   //for _kx := 01 TO nHPage step 30
  //     oPrinter:Say(nLine    ,_kx  , Alltrim(Str(_kx))        ,oFont5,,,,3)       
   //Next      
   oPrinter:SetPortrait() // ou SetLandscape()
   oPrinter:StartPage()
   oPrinter:Box(nLine,nColIni,nLine+70,nHPage)
   oPrinter:Line(nLine,nHPage * 23/100,nLine+070,nHPage * 23/100)  // Linha vertical 1
   oPrinter:Line(nLine,nHPage * 73/100,nLine+070,nHPage * 73/100)  // Linha vertical 2
   ///oPrinter:Line(nLine+060,nColIni,nLine+070,nColFim)     // Linha horizontal 1
   oPrinter:Line(nLine+130,nColIni,nLine+130,nHPage)     // Linha horizontal 2

   oPrinter:SayBitmap(nLine+02,nColIni+02,cLogo,nLarg,nAlt)
   //oPrinter:SetFont(oFont22N:oFont,.T.)
   nLine += TamLin
  
    oPrinter:Say(nLine +10   ,nHPage * 78/100   ,"Orçamento"            ,oFont20,,,,2 )
 

   /*If SL1->L1_FILIAL == "00"
      oPrinter:Say(nLine , 520 ,SM0->M0_NOMECOM,oFont3,,,,3)
   Endif*/ 
   //oPrinter:SetFont(oFont2:oFont)
   oPrinter:Say(nLine,nHPage * 24/100,AllTrim(SM0->M0_ENDCOB)+Space(03)+AllTrim(SM0->M0_BAIRCOB),oFont2:oFont,,,,3)
   nLine += TamLin
   
   //oPrinter:SetFont(oFont22N:oFont,.T.)
   oPrinter:Say(nLine + 23  , nHPage * 78/100   ,SCK->CK_FILIAL + " - " + SCK->CK_NUM ,oFont22N:oFont)
   
   //oPrinter:SetFont(oFont2:oFont)     
   oPrinter:Say(nLine , nHPage * 24/100,"Manaus - AM "+Space(10)+" CEP: "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont2:oFont,,,,3)
      
   nLine += TamLin
   //oPrinter:SetFont(oFont22N:oFont,.T.)
   oPrinter:Say(nLine + 30 , nHPage * 84/100,Dtoc(dDataBase),oFont3)
   //oPrinter:SetFont(oFont2:oFont)   
   oPrinter:Say(nLine,nHPage * 24/100,"Fone.: "+SM0->M0_TEL ,oFont2:oFont,,,,3)  
   
   nLine += TamLin
   //oPrinter:SetFont(oFont2:oFont)
   oPrinter:Say(nLine, nHPage * 24/100,"E-Mail: AMAZONACO@AMAZONACO.COM.BR",oFont2:oFont,,,,3)
    nLine += TamLin
     _cdCGC  := If(SM0->M0_CODIGO == '01' .And. SM0->M0_CODFIL$'03,04' , '05477207000175' , SM0->M0_CGC )
   _cdInsc := If(SM0->M0_CODIGO == '01' .And. SM0->M0_CODFIL$'03,04' , '063000016' , SM0->M0_INSC )
   oPrinter:Say(nLine, nHPage * 24/100,"CNPJ: " + Transform(_cdCGC,"@R 99.999.999/9999-99"),oFont2:oFont,,,,3)
   nLine += TamLin
   oPrinter:Say(nLine, nHPage * 24/100,"I.E: " + _cdInsc,oFont2:oFont,,,,3)
      
   //oPrinter:Say(nLine ,0520,"NÃO É DOCUMENTO FISCAL - EXIJA SEU CUPOM FISCAL",oFont2,,,,3)

   nLine += TamLin * 2 
   oPrinter:Say(nLine,nColIni+4 ,"Cliente : "+SA1->A1_COD+" - "+SA1->A1_NOME     ,oFont2:oFont,,,,3)
   nLine += TamLin
   oPrinter:Say(nLine,nColIni+4 ,"Endereço:  "+SA1->A1_END     ,oFont2:oFont,,,,3)
   nLine += TamLin
   oPrinter:Say(nLine,nColIni+4 ,"Bairro  :   "+PADR(SA1->A1_BAIRRO,20)+" CEP: "+Transform(SA1->A1_CEP,"@R 99999-999") + Space(05) + ' - ' +  SA1->A1_MUN + "/" + SA1->A1_EST, oFont2:oFont,,,,3)
  
   If SA1->A1_PESSOA == "J"
      cMask := "@R 99.999.999/9999-99"
   Else
      cMask := "@R 999.999.999-99"
   EndIf

   If len(ALLTRIM(StrTran(SA1->A1_TEL,"-",""))) = 9
      cMask2 := "@R 99999-9999"
   ElseIf len(ALLTRIM(StrTran(SA1->A1_TEL,"-",""))) = 8
      cMask2 := "@R 9999-9999"
   ELSE
      cMask2 := "@R 999-9999"   
   EndIf

   nLine += TamLin
   oPrinter:Say(nLine,nColIni+4,"Cgc/cpf :  "+Transform(SA1->A1_CGC,cMask)+"        "+;
                             "Telefone:  "+Transform(ALLTRIM(StrTran(SA1->A1_TEL,"-","")),cMask2)+"        "+;
                             "I.E.: "+ SA1->A1_INSCR ,oFont2:ofont,,,,3)

   nLine += TamLin + 5

   //correções posicionamentos

   oPrinter:Say(nLine ,nCol1 	   , PadR("Item"      ,60)    ,oFont2:ofont,,,,3)
   oPrinter:Say(nLine ,nCol1 + 030 , PadR("Codigo"    ,60)    ,oFont2:ofont,,,,3)
   oPrinter:Say(nLine ,nCol1 + 80 , PadR("Qtde."     ,30)    ,oFont2:ofont,,,,3)
   oPrinter:Say(nLine ,nCol1 + 120 , PadR("UM"        ,60)    ,oFont2:ofont,,,,3)
   oPrinter:Say(nLine ,nCol1 + 135 , PadL("Descricao" ,12)    ,oFont2:ofont,,,,3)
   oPrinter:Say(nLine ,nCol1 + 460 , PadR("Peso"      ,15)    ,oFont2:ofont,,,,3)
   oPrinter:Say(nLine ,nCol1 + 480 , PadL("Preco"     ,10)    ,oFont2:ofont,,,,3)
   oPrinter:Say(nLine ,nCol1 + 520 , PadL("Total R$"  ,15)    ,oFont2:ofont,,,,3)



   nLine += 020
Return

*****************************************
Static Function RRoda()
*****************************************
   Local cTel_Email :=""
   Local cEmail     := ""

   if nLine > 700
      cData := diaextenso(ddatabase)+","+alltrim(str(day(ddatabase)))+"/"+mesextenso(ddatabase)+"/"+alltrim(str(year(ddatabase)))+"   "+time()
      oPrinter:Say(3000,nCol1,"Data de Impressao: "+cData,oFont2:ofont,,,,3)

      oPrinter:Say(3100,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2:ofont,,,,3)

      nPage += 1
      
      oPrinter:EndPage()
      oPrinter:StartPage()
      nLine := 150
   Endif

   vParc := {}
   vMens := {} 

   If len(ALLTRIM(StrTran(SA3->A3_TEL,"-",""))) = 9
      cMask2 := "@R 99999-9999"
   ElseIf len(ALLTRIM(StrTran(SA3->A3_TEL,"-",""))) = 8
      cMask2 := "@R 9999-9999"
   ELSE
      cMask2 := "@R 999-9999"   
   EndIf
   
   nLine := nLine + 15 - If( Empty(vParc) .And. Empty(vMens) , 0, ((Len(vParc) + Len(vMens)) * 50) + 100)       //Alt

   cTel_Email := iif(Empty(SA3->A3_TEL),"",SPACE(10)+"Tel. Vend: "+Transform(Alltrim(SA3->A3_TEL),cMask2))
   cEmail     := iif(Empty(SA3->A3_EMAIL),"",SA3->A3_EMAIL)
   
   oPrinter:Box(nLine,nColIni,nLine+40,nHPage)
   
   nLine += 20

   oPrinter:Say(nLine-5,nCol1+15,"Preços sujeitos a alteração sem aviso prévio",oFont2:ofont,,,,3)
   oPrinter:Say(nLine-5,nCol1+330,"Peso Total: " ,oFont3,,,,3)
   oPrinter:Say(nLine-5,460,Alltrim(Transform(nPesoTotal,"@E 9,999,999.999") ),oFont3,,,,3)

   //oPrinter:Say(nLine+5 ,nCol1+330,"TOTAL: "+"R$"+Transform(nTotal ,"@E 999,999,999.99"),oFont2:ofont,,,,3)   
   
   nLine += 10
   //oPrinter:Line(nLine,nCol1-9,nLine,nColFim)
    
   oPrinter:Box(nLine,nColIni,nLine+50,nHPage)
    
    oPrinter:Say(nLine+30,nCol1 ,PadC("Obrigado e volte sempre !",80),oFont4,,,,3)

    oPrinter:Say(nLine+20,nCol1+330,"Desconto: ",oFont3,,,,3)
    oPrinter:Say(nLine+20,460,"R$"+PadC(Transform(   nDescItem    , "@E 999,999,999.99"),25),oFont3,,,,3)
    nLine += 20
    oPrinter:Say(nLine+20,nCol1+330,"Total Liq: ",oFont3,,,,3)
    oPrinter:Say(nLine+20,460,"R$"+PadC(Transform(nTotal-nDescItem, "@E 999,999,999.99"),25),oFont3,,,,3)

   nLine += 40

   SA3->(dbSetOrder(1))
   SA3->(dbSeek(xfilial("SA3")+SCJ->CJ_VEND1))
   
   cTel_Email := iif(Empty(SA3->A3_TEL),"",SPACE(10)+"Tel.: "+Transform(Alltrim(SA3->A3_TEL),cMask2))
   cEmail     := iif(Empty(SA3->A3_EMAIL),"",SA3->A3_EMAIL)
   

   cData := alltrim(str(day(SCJ->CJ_EMISSAO)))+"/"+substr(mesextenso(SCJ->CJ_EMISSAO),1,3)+"/"+alltrim(str(year(SCJ->CJ_EMISSAO)))

   oPrinter:Say(nLine,nCol1+300,"Data: "+cData+"- Hora: "+Time(),oFont2:ofont,,,,3)
   oPrinter:Say(nLine,nCol1,"Vendedor: "+SA3->A3_NREDUZ+cTel_Email,oFont2:ofont,,,,3)
//	oPrinter:Say(nLine,nCol1,"Vendedor: "+SA3->A3_NREDUZ,oFont2,,,,3)
   nLine += 15
   oPrinter:Say(nLine,nCol1,"Validade Proposta: "+DTOC(SCJ->CJ_VALIDA),oFont2:ofont,,,,3)
   oPrinter:Say(nLine,nCol1+300,"E-mail: "+cEmail,oFont2:ofont,,,,3)
   nLine += 15
   //Observações    
   oPrinter:Say(nLine,nCol1, Fn_VerPG(SCJ->CJ_CONDPAG) ,oFont2:ofont,,,,3); nLine += 10
   
   //oPrinter:Say(nLine,nCol1,cObs,oFont2:ofont,,,,3)
   
   If !Empty(cObs1)
     
      oPrinter:Say(nLine,nCol1,"Observação: " + cObs1,oFont2:ofont,,,,3)
   endif
   //alert(nline)
   cData := diaextenso(ddatabase)+","+alltrim(str(day(ddatabase)))+"/"+mesextenso(ddatabase)+"/"+alltrim(str(year(ddatabase)))+"   "+time()
   oPrinter:Say(750,nCol1,"Data de Impressao: "+cData,oFont2:ofont,,,,3)

   oPrinter:Say(750,nCol1+300,PadL("Pág. "+strzero(nPage,3),15),oFont2:ofont,,,,3)

Return

*****************************
Static Function ver_pag()
*****************************
   If nLine >= nLinFim
      cData := diaextenso(ddatabase)+","+alltrim(str(day(ddatabase)))+"/"+mesextenso(ddatabase)+"/"+alltrim(str(year(ddatabase)))+"   "+time()
      oPrinter:Say(3000,nCol1,"Data de Impressao: "+cData,oFont2:ofont,,,,3)

      oPrinter:Say(3100,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2:ofont,,,,3)

      nPage += 1
      oPrinter:StartPage()
      RCabec()
   EndIf
Return

****************************
Static Function Fn_VerPg(cCondPg,cFormPg)
****************************
   SE4->(DbSetOrder(1))
   SE4->(DbSeek(XFilial("SE4")+cCondPg,.T.))

  // cDescPag := Posicione("SX5",1,XFILIAL("SX5")+"24"+cFormPg,"X5_DESCRI")
   cRet     := "Forma de Pagamento: " + cCondPg+ " - " +Alltrim(SE4->E4_DESCRI) //+ " - " + cDescPag

Return(cRet)
