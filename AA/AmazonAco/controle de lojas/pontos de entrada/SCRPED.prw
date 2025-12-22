#INCLUDE "RWMAKE.CH"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ SCRPED     ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/03/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Impressão do cupom não-fiscal                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function SCRPED()
   Local nPICMS
   Local sTexto                      
   Local nCheques
   Local nCartao
   Local nConveni
   Local nVales
   Local nFinanc
   Local nOutros
   Local cQuant      := ""
   Local cVrUnit     := ""
   Local cDesconto   := ""
   Local cVlrItem    := ""
   Local nVlrIcmsRet := 0			// Valor do icms retido (Substituicao tributaria)
   Local nVlrAcresc  := 0			// Valor do Acréscimo Financeiro
   Local nValMerc    := 0
   Local nValBrut    := 0
   Local nValDesc    := 0
   Local nValICMS    := 0
   Local nValAcrs    := 0
   Local nValVen     := 0
   Local nVlrReti    := 0
   
   // Regrava os totais do orçamento após finalização da venda
   SL2->(dbSetOrder(1))
   SL2->(dbSeek(SL1->(L1_FILIAL+L1_NUM),.T.))
   While !SL2->(Eof()) .And. SL1->(L1_FILIAL+L1_NUM) == SL2->(L2_FILIAL+L2_NUM)
      
      SF4->(dbSetOrder(1))
      SF4->(dbSeek(xFilial('SF4')+SL2->L2_TES))
      
      // NORMAL, SAÍDA,TIPO CLIENTE, ICMS
      //nPICMS := AliqIcms("N","S",SA1->A1_TIPO,"I")

      // Soma ao item o valor do acréscimo no orçamento
      //RecLock("SL2",.F.)
      //SL2->L2_VLRITEM := SL2->(L2_PRCTAB * L2_QUANT) - SL2->L2_VALDESC + SL2->L2_VALACRS
      //SL2->L2_VRUNIT  := SL2->L2_VLRITEM / SL2->L2_QUANT
      //SL2->L2_BASEICM := SL2->L2_VLRITEM
      //SL2->L2_VALICM  := Round(SL2->L2_BASEICM * nPICMS / 100,2)
      //MsUnLock()

      nValMerc += SL2->(L2_PRCTAB * L2_QUANT)
      nValDesc += SL2->L2_VALDESC
      nValBrut += SL2->L2_VLRITEM
      nValICMS += SL2->L2_VALICM
      //nValAcrs += SL2->L2_VALACRS

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Faz o tratamento do valor do ICMS ret.                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If SL2->(FieldPos("L2_ICMSRET")) > 0 
         nVlrReti += iIf( SF4->F4_INCSOL  == "S" , SL2->L2_ICMSRET , 0)
      Endif

      SL2->(dbSkip())
   Enddo

   // Recalcula os totais no SL1
   If nVlrReti > 0
      RecLock("SL1",.F.)
      //SL1->L1_VALMERC := nValMerc - nValDesc
      SL1->L1_VALBRUT += nVlrReti //nValBrut
      SL1->L1_VLRLIQ  += nVlrReti //nValBrut
      SL1->L1_VLRTOT  += nVlrReti //nValBrut
      //SL1->L1_VALICM  := nValICMS
      MsUnLock()
   Endif

   sTexto:= 'Codigo         Descricao'+Chr(13)+Chr(10)
   sTexto:= sTexto+ 'Qtd             VlrUnit                 VlrTot'+Chr(13)+Chr(10)
   sTexto:= sTexto+'-----------------------------------------------'+Chr(13)+Chr(10)

   nDinheir	:= SL1->L1_DINHEIR
   nCheques	:= SL1->L1_CHEQUES
   nCartao 	:= SL1->L1_CARTAO
   nConveni	:= SL1->L1_CONVENI
   nVales  	:= SL1->L1_VALES  	
   nFinanc	:= SL1->L1_FINANC
   nOutros	:= SL1->L1_OUTROS    

   SA1->(dbSetOrder(1))
   SA1->(dbSeek(XFILIAL("SA1")+SL1->(L1_CLIENTE+L1_LOJA)))

   SL2->(dbSetOrder(1))
   SL2->(dbSeek(SL1->(L1_FILIAL+L1_NUM),.T.))
   While !SL2->(Eof()) .And. SL2->(L2_FILIAL+L2_NUM) == SL1->(L1_FILIAL+L1_NUM)
	  SF4->(dbSetOrder(1))
      SF4->(dbSeek(xFilial('SF4')+SL2->L2_TES))
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Faz o tratamento do valor do ICMS ret.                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If SL2->(FieldPos("L2_ICMSRET")) > 0 
         nVlrIcmsRet := iIF(SF4->F4_INCSOL == 'S',SL2->L2_ICMSRET,0)
      Else
         nVlrIcmsRet := 0
      Endif

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Faz o tratamento do valor do acréscimo                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If SL2->(FieldPos("L2_VALACRS")) > 0 
         nVlrAcresc := SL2->L2_VALACRS
      Else
         nVlrAcresc := 0
      Endif

      nValVen   := SL2->(( (L2_QUANT * L2_PRCTAB) /*- L2_VALDESC + nVlrAcresc*/ + L2_VALIPI + nVlrIcmsRet) / L2_QUANT)
      cQuant    := Str(SL2->L2_QUANT,8,3)
      cVrUnit   := Str(nValVen,15,2)
      cDesconto := Str(SL2->L2_VALDESC,TamSx3("L2_VALDESC")[1],TamSx3("L2_VALDESC")[2])
      cVlrItem  := Str(nValVen * SL2->L2_QUANT,15,2)
      sTexto    += SL2->L2_PRODUTO + SL2->L2_DESCRI +Chr(13)+Chr(10)
      sTexto    += cQuant +'  '+ cVrUnit +'      '+ cVlrItem + Chr(13) + Chr(10)

      If SL2->L2_VALDESC > 0 
         sTexto += 'Desconto no Item:              '+Str(SL2->L2_VALDESC,15,2)+Chr(13)+Chr(10)
      EndIf

      SL2->(DbSkip())
   Enddo

   If SL1->L1_DESCONTO > 0 
      sTexto += 'Desconto no Total:             '+Str(SL1->L1_DESCONTO,15,2)+Chr(13)+Chr(10)
   EndIf                                                                              
   If SL1->L1_JUROS > 0 
      sTexto += 'Acrescimo no Total:            '+Transform(SL1->L1_JUROS,"@R 99.99%")+Chr(13)+Chr(10)
   EndIf
   If nValAcrs > 0 
      sTexto += 'acréscimo                      '+Str(nValAcrs,15,2)+Chr(13)+Chr(10)
   EndIf
   sTexto += '-----------------------------------------------'+Chr(13)+Chr(10)
   sTexto +=    'TOTAL                          '+Str(SL1->L1_VLRLIQ,15,2)+Chr(13)+Chr(10)

   If nDinheir > 0 
      sTexto += 'DINHEIRO                       '+Str(nDinheir,15,2)+Chr(13)+Chr(10)
   EndIf
   If nCheques > 0 
      sTexto += 'CHEQUE                         '+Str(nCheques,15,2)+Chr(13)+Chr(10)
   EndIf
   If nCartao > 0 
      sTexto += 'CARTAO                         '+Str(nCartao,15,2)+Chr(13)+Chr(10)
   EndIf
   If nConveni > 0 
      sTexto += 'CONVENIO                       '+Str(nConveni,15,2)+Chr(13)+Chr(10)
   EndIf
   If nVales > 0 
      sTexto += 'VALES                          '+Str(nVales,15,2)+Chr(13)+Chr(10)
   EndIf
   If nFinanc > 0 
      sTexto += 'FINANCIADO                     '+Str(nFinanc,15,2)+Chr(13)+Chr(10)
   EndIf
   sTexto += '-----------------------------------------------'+Chr(13)+Chr(10)

Return sTexto