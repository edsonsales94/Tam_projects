#INCLUDE "AvPrint.ch"
#INCLUDE "Font.ch"
#Include "Protheus.ch"
#include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATR05   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 15/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Orçamento Gráfico do faturamento                           	¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFATR05(cOrc)
// U_AAFATR05("000002")
//OBJETIVO 1:Impressão do Orçamento Gráfico

Private cObs1:= Space(60),cObs2:= Space(60)
Private cOrcamento := Space(06)  
Private nPesoTotal := 0
Private _ndTotDesc := 0
           
cOrcamento := cOrc

cOrc := If( cOrc == Nil , SCJ->CJ_NUM, cOrc)
Processa({|| RReport(cOrc),"Processando Dados"})

Return

*****************************************
Static FUNCTION RReport(cOrc)
*****************************************
   AVPRINT oPrn NAME "AUTORIZAÇÃO PARA RETIRADA DE MERCADORIA"

   DEFINE FONT oFont1  NAME "Arial" SIZE 0,10 Bold OF oPrn
   DEFINE FONT oFont2  NAME "Arial" SIZE 0,11 Bold OF oPrn
   DEFINE FONT oFont25 NAME "Arial" SIZE 0,14 Bold OF oPrn
   DEFINE FONT oFont3  NAME "Arial" SIZE 0,15 Bold OF oPrn
   DEFINE FONT oFont4  NAME "Arial" SIZE 0,20 Bold OF oPrn
   DEFINE FONT oFont5  NAME "Arial" SIZE 0,22 Bold OF oPrn
   DEFINE FONT oFont6  NAME "Arial" SIZE 0,09 Bold OF oPrn
   DEFINE FONT oFontT  NAME "Arial" SIZE 0,16 Bold OF oPrn

   DEFINE FONT oFontX  NAME "Arial" SIZE 0,09 Bold Italic Underline OF oPrn
   DEFINE FONT oFontY  NAME "Arial" SIZE 0,09 Bold OF oPrn

   oPrn:SETPORTRAIT()

   AVPAGE
   Processa({|X| lEnd := X, RPrint(cOrc) })
   AVENDPAGE

   AVENDPRINT
                                                              
   oPrn:SETPORTRAIT()
   oFont1:End()
   oFont2:End()
   oFont3:End()
   oFont4:End()
   oFont5:End()
   oFontT:End()

Return .T.

*****************************************
Static Function RPrint(cOrc)
*****************************************
   Local xCor, cReserv, nPerc
   Local nPrcVenda := 0
   Private nPage:=1,nLine,nLinVert := 150,nColIni:=160,nColFim:=2300
   Private cObs:= Space(60)   
   PRIVATE nTotIcRet := 0

   nCol1:=nColIni       //Produto
   nCol2:=nCol1+1100    //Desconto
   nCol3:=nCol2+230     //Preço unitário
   nCol4:=nCol3+250     //Quantidade
   nCol5:=nCol4+180     //Total
   nLinFim:=2800

   nTotal    := 0
   nDescItem := 0

   SCJ->(DbSetOrder(1))
   SCJ->(DbSeek(xFilial("SCJ")+cOrc))

   
   cObs    := IIF(Empty(SCJ->CJ_MENNOTA),"",SCJ->CJ_MENNOTA)
   cdNumOs := "" //IIF(Empty(SCJ->CJ_XNUMOS),"",SCJ->CJ_XNUMOS)

   SB1->(dbSetOrder(1))
   SA1->(dbSetOrder(1))
   SCK->(dbSetOrder(1))
   SCK->(dbSeek(xFilial("SCK")+cOrc))

   RCabec()                                                                   
   nPesoTotal := 0                                                            
   _ndTotdesc := 0
   nTotIcRet  := 0

   While !SCK->(EOF()) .and. SCK->CK_NUM = SCJ->CJ_NUM

      ProcRegua(SCK->(LastRec()))

      ver_pag1()

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
      
      //If !EMPTY(SCK->CK_RESERVA)
      //   xCor := CLR_HBLUE
         cReserv := oFontX
     // Else
         xCor := Nil
        cReserv := oFontY
      //EndIf
 
       oPrn:Say(nLine,nCol1 + 20 ,PadR(Left(SCK->CK_ITEM,10),10) ,cReserv,,xCor,,3)

      // Efetua quebra da descrição em N linhas
      //ALMENTADO O TAMANHA DA LINHA DA DESCRICAO POR ANDERSON E ARLINDO
      cDescri := Alltrim(SB1->B1_ESPECIF)
      nL      := 0
      nLin    := MlCount(cDescri,60)
      For nY:=1 To nLin
         oPrn:Say(nLine+nL,nCol1 + 530,MemoLine(cDescri,60,nY),cReserv,,xCor,,3)
         nL+=60
      Next

      /*If Empty(SB1->B1_SEGUM)
         _cUm := SB1->B1_UM
         _nQtd := SL2->L2_QUANT
      ELSE
         _cUm := SB1->B1_SEGUM
         _nQtd := SL2->

         nPrcVenda := nValor / _nQtd
      EndIf */ 
         
 	  oPrn:Say(nLine,nCol1+285       ,Padl( SB1->B1_COD    ,13)    ,cReserv,,xCor,,1)
	  oPrn:Say(nLine,nCol1+445       , Transform(SCK->CK_QTDVEN ,"@E 999,999,999,999.99")   ,cReserv,,xCor,,1)
      oPrn:Say(nLine,nCol1+500       ,PadL( SB1->B1_UM     ,12)    ,cReserv,,xCor,,1)

      oPrn:Say(nLine,nCol5 - 88      ,PadL(Transform(SB1->B1_PESO * SCK->CK_QTDVEN, "@E 999,999,999,999.99"),19)   ,cReserv,,xCor,,1)
      oPrn:Say(nLine,nCol5+70        ,PadL(Transform(nPrcVenda ,"@E 9,999.999"),10)   ,cReserv,,xCor,,1)
      oPrn:Say(nLine,nCol5+90+230    ,PadL(Transform(nValor   ,"@E 99,999,999.99"),15)  ,cReserv,,xCor,,1)

      /*If !Empty(SL1->L1_DOC) .Or. !Empty(SL1->L1_DOCPED)
         nPerc := Round(SL2->(L2_VALICM / L2_BASEICM) * 100,2)
         oPrn:Say(nLine,nCol5+200+125   ,PadL(Transform(nPerc,"@E 99"),8) ,cReserv,,xCor,,1)
      EndIf */

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

*****************************************
Static Function RCabec()
*****************************************
   Local nLarg := 400
   Local nAlt  := 350
   Local cLogo      := "LGMID1.bmp" //FisxLogo("1")

   SA1->(dbSeek(xFilial("SA1")+SCJ->(CJ_CLIENTE+CJ_LOJA)))

   nLine := 150

   oPrn:Box(nLine,nColIni,nLine+610,nColFim)
   oPrn:Line(nLine,0500,nLine+290,0500)  // Linha vertical 1
   oPrn:Line(nLine,1695,nLine+290,1695)  // Linha vertical 2
   oPrn:Line(nLine+290,nColIni,nLine+290,nColFim)     // Linha horizontal 1
   oPrn:Line(nLine+520,nColIni,nLine+520,nColFim)     // Linha horizontal 2

   oPrn:SayBitmap(nLine+50,nColIni+10,cLogo,nLarg,nAlt)
   nLine += 30

  // If Empty(SL1->L1_EMISNF) .And. Empty(SL1->L1_PEDRES)   // Pedido de reserva
      oPrn:Say(nLine    ,1810    ,"Orçamento"            ,oFont5,,,,3)
  /* ElseIf !Empty(SL1->L1_DOCPED) .Or. !Empty(SL1->L1_PEDRES)
      oPrn:Say(nLine    ,1800    ,"V N - RESERVA"        ,oFont5,,,,3)
   Else
      oPrn:Say(nLine    ,1950    ,"V N"                  ,oFont5,,,,3)
   EndIf */

   /*If SL1->L1_FILIAL == "00"
      oPrn:Say(nLine , 520 ,SM0->M0_NOMECOM,oFont3,,,,3)
   Endif*/ 

   nLine += 90   

   oPrn:Say(nLine-90 ,0520,AllTrim(SM0->M0_ENDCOB)+Space(03)+AllTrim(SM0->M0_BAIRCOB),oFont2,,,,3)
   nLine += 10
   oPrn:Say(nLine  ,1810    ,SCK->CK_FILIAL + " - " + SCK->CK_NUM ,oFont5,,,,3)

   nLine += 60 
   oPrn:Say(nLine-115 ,520,"Manaus - AM "+Space(10)+" CEP: "+Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont2,,,,3)

   nLine += 40
   oPrn:Say(nLine ,1950,Dtoc(dDataBase),oFont25,,,,3)

   nLine += 10  
   oPrn:Say(nLine-123 ,520,"Fone.: "+SM0->M0_TEL ,oFont2,,,,3)  
    
   oPrn:Say(nLine-80,520,"E-Mail: AMAZONACO@AMAZONACO.COM.BR",oFont2,,,,3)

   //oPrn:Say(nLine ,0520,"NÃO É DOCUMENTO FISCAL - EXIJA SEU CUPOM FISCAL",oFont2,,,,3)

   nLine += 80

   oPrn:Say(nLine,nColIni+20 ,"Cliente : "+SA1->A1_COD+" - "+SA1->A1_NOME     ,oFont2,,,,3)
   nLine += 50
   oPrn:Say(nLine,nColIni+20 ,"Endereço:  "+SA1->A1_END     ,oFont2,,,,3)
   nLine += 50
   oPrn:Say(nLine,nColIni+20 ,"Bairro  :   "+PADR(SA1->A1_BAIRRO,20)+" CEP: "+Transform(SA1->A1_CEP,"@R 99999-999") + Space(05) + ' - ' +  SA1->A1_MUN + "/" + SA1->A1_EST, oFont2,,,,3)
   oPrn:Say(nLine    ,1810    ,"I.E.:"+Alltrim(SA1->A1_INSCR)            ,oFont2,,,,3)

   If SA1->A1_PESSOA == "J"
      cMask := "@R 99.999.999/9999-99"
   Else
      cMask := "@R 999.999.999-99"
   EndIf

   nLine += 50
   oPrn:Say(nLine,nColIni+20,"Cgc/cpf :  "+Transform(SA1->A1_CGC,cMask)+"        "+;
                             "Telefone:  "+Transform(Alltrim(SA1->A1_TEL),"@R 9999-9999"),oFont1,,,,3)

   nLine += 90         
      
   oPrn:Say(nLine ,nCol1 + 005 , PadR("Item"      ,60)    ,oFont2,,,,3)
   oPrn:Say(nLine ,nCol1 + 100 , PadR("Codigo"    ,60)    ,oFont2,,,,3)
   oPrn:Say(nLine ,nCol1 + 300 , PadR("Qtde."     ,30)    ,oFont2,,,,3)
   oPrn:Say(nLine ,nCol1 + 427 , PadR("UM"        ,60)    ,oFont2,,,,3)
   oPrn:Say(nLine ,nCol1 + 480 , PadL("Descricao" ,12)    ,oFont2,,,,3)
   oPrn:Say(nLine ,nCol3 + 245 , PadR("Peso"      ,15)    ,oFont2,,,,3)
   oPrn:Say(nLine ,nCol4 + 100 , PadL("Preco"     ,10)    ,oFont2,,,,3)
   oPrn:Say(nLine ,nCol5 + 80  , PadL("Total R$"  ,15)    ,oFont2,,,,3)

	/*If !Empty(SL1->L1_DOC+SL1->L1_DOCPED)
      oPrn:Say(nLine ,nCol5+300  , PadR("ICMS"  ,10)    ,oFont2,,,,3)
   EndIf */

   nLine += 080
Return

*****************************************
Static Function RRoda()
*****************************************
   Local vAux, x, nPos
   Local nLarg:=250, nAlt:=200
   Local cTel_Email :=""
   Local cFormaCond := ""
   Local cEmail     := ""

   if nLine > 2100
      cData := diaextenso(ddatabase)+","+alltrim(str(day(ddatabase)))+"/"+mesextenso(ddatabase)+"/"+alltrim(str(year(ddatabase)))+"   "+time()
      oPrn:Say(3000,nCol1,"Data de Impressao: "+cData,oFont2,,,,3)

      oPrn:Say(3100,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2,,,,3)

      nPage += 1

      AVNEWPAGE
      nLine := 150
   Endif

   vParc := {}
   vMens := {}                                    
   
  /* If !Empty(SL1->L1_DOC) .Or. !Empty(SL1->L1_DOCPED)
      For x:= 1 to 3
         If !Empty(SubStr(SL1->L1_OBSERV,((x-1)*80)+1,80))
            AAdd( vMens ,  SubStr(SL1->L1_OBSERV,((x-1)*80)+1,80) )
         EndIf
      Next

      SL4->(dbSetOrder(1))
      SL4->(dbSeek(xFilial("SL4")+SL1->L1_NUM,.T.))
      While !SL4->(Eof()) .And. xFilial("SL4")+SL1->L1_NUM == SL4->(L4_FILIAL+L4_NUM)
         AAdd( vParc , { SL4->L4_FORMA, SL4->L4_VALOR, SL4->L4_ADMINIS, SL4->L4_NUMCART, 0, 0} )
         SL4->(dbSkip())
      Enddo

      // Caso tenha sido utilizado crédito na venda
      If SL1->L1_CREDITO > 0
         AAdd( vParc , { "CREDITO R$ ", SL1->L1_CREDITO} )
      Endif

      If Len(vParc) > 10
         vAux  := aClone(vParc)
         vParc := {}

         For x:=1 To Len(vAux)
            nPos := AScan( vParc , {|y| y[1]+y[3]+y[4] == vAux[x,1]+vAux[x,3]+vAux[x,4] })
            If nPos == 0
               AAdd( vParc , { vAux[x,1], 0, vAux[x,3], vAux[x,4], 0, 0} )
               nPos := Len(vParc)
            Endif
            vParc[nPos,5] += vAux[x,2]
            vParc[nPos,6]++
            vParc[nPos,2] := vParc[nPos,5] / vParc[nPos,6]
         Next
      Endif
   Endif    */

   nLine := nLine + 150 - If( Empty(vParc) .And. Empty(vMens) , 0, ((Len(vParc) + Len(vMens)) * 50) + 100)       //Alt

   cTel_Email := iif(Empty(SA3->A3_TEL),"",SPACE(10)+"Tel.: "+Transform(Alltrim(SA3->A3_TEL),"@R 9999-9999"))
   cEmail     := iif(Empty(SA3->A3_EMAIL),"",SPACE(10)+"e-mail: "+SA3->A3_EMAIL)
   
   oPrn:Box(nLine,nLinVert,nLine+450,nColFim)
   nLine += 40

   oPrn:Say(nLine,nCol1+10,"Preços sujeitos a alteração sem aviso prévio",oFont1,,,,3)

/*   If !Empty(SCJ->CJ_DOC) .Or. !Empty(SCJ->CJ_DOCPED)
      oPrn:Say(nLine + 20,nCol3 - 520,"TOTAL ICMS: R$ "+ALLTRIM(Transform(SCJ->CJ_VALICM,"@E 999,999.99")),oFont1,,,,3)
   Endif
  */ 
   oPrn:Say(nLine-20,nCol3 - 520,"PESO TOTAL: " + Alltrim(Transform(nPesoTotal,"@E 999,999,999,999.99")),oFont1,,,,3)
   oPrn:Say(nLine-20,nCol3+20,"TOTAL: ",oFontT,,,,3)
   oPrn:Say(nLine-20,nCol4+15+10,"R$"+Transform(nTotal,"@E 999,999,999.99"),oFontT,,,,3)
   nLine += 80

   oPrn:Line(nLine,nCol1-9,nLine,nColFim)
   nLine += 20

   //Tratamento do desconto
   If SCJ->CJ_DESCONT > 0 .or. _ndTotDesc > 0
      _xdesc := iif(SCJ->CJ_DESCONT > 0,SCJ->CJ_DESCONT,_ndTotDesc)
      oPrn:Say(nLine+30,nCol1-250,PadC("Obrigado e volte sempre !",80),oFont3,,,,3)
      oPrn:Say(nLine+18,nCol3-100,PadC("Desconto: ",25),oFont3,,,,3)
      oPrn:Say(nLine+18,nCol3+180+50,PadC("R$"+(Transform(_xdesc,"@E 999,999,999.99")),25),oFont3,,,,3)
      nLine += 60
      //
      oPrn:Say(nLine+050,nCol3-100,PadC("Total Liq: ",25),oFont3,,,,3)
      oPrn:Say(nLine+050,nCol3+180+40,PadC("R$"+(Transform(nTotal-_xdesc,"@E 999,999,999.99")),25),oFont3,,,,3)
  Else
      oPrn:Say(nLine+30,nCol1-500,PadC("Obrigado e volte sempre !",130),oFont3,,,,3)
      nLine += 60
   EndIf

/*   nLine += 110
   oPrn:Line(nLine,nLinVert,nLine,nColFim)
   nLine += 30
   oPrn:Say(nLine,nCol1-60,Padc("NÃO É DOCUMENTO FISCAL - EXIJA SEU CUPOM FISCAL",90),oFont3,,,,3) */    
   
  	nLine += 120

   SA3->(dbSetOrder(1))
   SA3->(dbSeek(xfilial("SA3")+SCJ->CJ_VEND1))

   cData := alltrim(str(day(SCJ->CJ_EMISSAO)))+"/"+substr(mesextenso(SCJ->CJ_EMISSAO),1,3)+"/"+alltrim(str(year(SCJ->CJ_EMISSAO)))

   oPrn:Say(nLine,nCol2,"Data: "+cData+"- Hora: "+Time(),oFont2,,,,3)
//   oPrn:Say(nLine,nCol1,"Vendedor: "+SA3->A3_NREDUZ+cTel_Email,oFont2,,,,3)
	oPrn:Say(nLine,nCol1,"Vendedor: "+SA3->A3_NREDUZ,oFont2,,,,3)
   nLine += 70
   oPrn:Say(nLine,nCol1,"Validade Proposta: "+DTOC(SCJ->CJ_VALIDA)+Space(30)+cEmail,oFont2,,,,3)
   nLine += 70
     
   /*iF(SL1->L1_ENTREGA == 'S')
   oPrn:Say(nLine,nCol1   ,"Recebedor  : "+AllTrim(SL1->L1_RECENT), oFont2,,,,3)  
   oPrn:Say(nLine,nCol2   ,"Endereco Entrega : "+Alltrim(Left(SL1->L1_ENDENT,50)),oFont2,,,,3) ; nLine += 70
   oPrn:Say(nLine,nCol1   ,"Cidade Entrega: "+Alltrim(SL1->L1_MUNE) + " - " + Alltrim(SL1->L1_ESTE),oFont2,,,,3)
   oPrn:Say(nLine,nCol2   ,"Fone Entrega: "+Transform(SL1->L1_FONEENT,'@R 9999-9999'),oFont2,,,,3) ; nLine += 70
   oPrn:Say(nLine,nCol1   ,"Observacao Ent.: "+ SL1->L1_OBSENT1,oFont2,,,,3) ; nLine += 70
   ENDIF      */
   
   /*If !Empty(SL1->L1_DOC) .Or. !Empty(SL1->L1_DOCPED)
      cCupom := "Orcamento: "+SL1->L1_NUM  //"Cupom Nao-Fiscal: "+SL1->L1_DOCPED

      If !Empty(SL1->L1_DOC)
         cDocSer := SL1->(L1_SERIE+L1_DOC)
      Else
         cDocSer := SL1->(L1_SERPED+L1_DOCPED)
      Endif

      oPrn:Say(nLine,nCol1,cCupom,oFont2,,,,3)
      nLine += 50
      For x:=1 To Len(vMens)
         oPrn:Say(nLine,nCol1,vMens[x],oFont2,,,,3)
         nLine += 50
      Next
      nLine += 50

      If !Empty(vParc)  // Se encontrou parcelas
         SE1->(DbSetOrder(1))
         SE1->(DbSeek(xFilial("SE1")+cDocSer))

         If Alltrim(SE1->E1_NATUREZ) == "CARTAO"
            SAE->(DbSetOrder(1))
            SAE->(DbSeek(xFilial("SE1")+SE1->E1_CLIENTE))
            cFormaCond := SAE->AE_DESC
         Else
            cFormaCond := AllTrim(SE1->E1_NATUREZ)
         EndIf

         oPrn:Say(nLine,nCol1,"Condições de Pagamento "+cFormaCond,oFont2,,,,3)
         nLine += 50
         For x:=1 To Len(vParc)
            oPrn:Say(nLine,nCol1,vParc[x,1],oFont2,,,,3)
            oPrn:Say(nLine,nCol1+220,If( vParc[x,6] > 0, LTrim(Str(vParc[x,6],3))+"x de ", " ") +;
                                     Transform(vParc[x,2],"@e 999,999,999.99"),oFont2,,,,3)
            nLine += 70
         Next       
      Endif
   EndIF   */
   
   //Observações    
   oPrn:Say(nLine,nCol1, Fn_VerPG(SCJ->CJ_CONDPAG),oFont2,,,,3); nLine += 70
   
   oPrn:Say(nLine,nCol1,cObs,oFont2,,,,3)
   
   nLine += IiF(!Empty(cObs),70,0)
   
   //oPrn:Say(nLine,nCol1,"Ordem de Servico: " + cdNumOs,oFont2,,,,3)
   
   cData := diaextenso(ddatabase)+","+alltrim(str(day(ddatabase)))+"/"+mesextenso(ddatabase)+"/"+alltrim(str(year(ddatabase)))+"   "+time()
   oPrn:Say(3100,nCol1,"Data de Impressao: "+cData,oFont2,,,,3)                                                        
  
   oPrn:Say(3100,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2,,,,3)

Return

*****************************
Static Function ver_pag1()
*****************************
   If nLine >= nLinFim
   //   cData := diaextenso(ddatabase)+","+alltrim(str(day(ddatabase)))+"/"+mesextenso(ddatabase)+"/"+alltrim(str(year(ddatabase)))+"   "+time()
    //  oPrn:Say(3000,nCol1,"Data de Impressao: "+cData,oFont2,,,,3)

      oPrn:Say(3100,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2,,,,3)

      nPage += 1
      AvNewPage
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


/*----------------------------------------------------------------------------------||
||       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||      AAAA       LL         LL         EE         CC        KK    KK   SS         ||
||     AA  AA      LL         LL         EE        CC         KK  KK     SS         ||
||    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   ||
||   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  ||
||  AA        AA   LL         LL         EE         CC        KK    KK          SS  ||
|| AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   ||
||----------------------------------------------------------------------------------*/
