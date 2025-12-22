#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} QSMBGA01
//TODO Fonte para gatilhos em tela de 'documentos' - QXML - Especifico Minebea
@author QsdoBrasil
@type User function 
@since jul/2024
U_QSMBGA01("X7_CNDOMIN") <- passar o campo de destino
/*/
User Function QSMBGA01(cCmpDest)
   Local aArea     := GetArea()

   Local xRet

   Default cCmpDest    := ""

   If !Empty(cCmpDest)
      If Upper(cCmpDest) == Upper("ZZ3_CODPRO")
         xRet := SC7->C7_PRODUTO
      elseIf Upper(cCmpDest) == Upper("ZZ3_IPDICO")
         xRet := SC7->C7_ITEM
      elseIf Upper(cCmpDest) == Upper("ZZ3_IPDIUM")
         xRet := SC7->C7_UM
      elseIf Upper(cCmpDest) == Upper("ZZ3_IPDQTD")
         If  Alltrim(FWFldGet("ZZ2_TPDOC")) == '2' //-- CTE
            xRet := FwFldGet("ZZ3_QUANT")
         ElseIf Alltrim(SC7->C7_UM) = Alltrim(FWFldGet("ZZ3_UM")) //-- NFE 1ª U.M
            xRet := FwFldGet("ZZ3_QUANT")
         ElseIf Alltrim(SC7->C7_SEGUM) = Alltrim(FWFldGet("ZZ3_UM"))
            xRet := ConvUM(SC7->C7_PRODUTO, 0,FwFldGet("ZZ3_QUANT"), 1) 
         Else
            xRet := SC7->C7_QUANT
         EndIf
      elseIf Upper(cCmpDest) == Upper("ZZ3_IPDVUN")
         If Alltrim(FWFldGet("ZZ2_TPDOC")) == '2' //-- CTE
            xRet := FwFldGet("ZZ3_VUNIT")
         ElseIf Alltrim(SC7->C7_UM) = Alltrim(FWFldGet("ZZ3_UM")) //-- NFE 1ª U.M
            xRet := FwFldGet("ZZ3_VUNIT")
         ElseIf Alltrim(SC7->C7_SEGUM) = Alltrim(FWFldGet("ZZ3_UM"))
           xRet := FWFldGet("ZZ3_TOTAL") / ConvUM(SC7->C7_PRODUTO, 0,FwFldGet("ZZ3_QUANT"), 1)
         else
            xRet := 0 //-- Aborto o preenchimento devido a alguma falha de conversão em cadastro
         EndIf
      elseIf Upper(cCmpDest) == Upper("ZZ3_IPDTOT")
         xRet := FwFldGet("ZZ3_IPDQTD") * FwFldGet("ZZ3_IPDVUN")
      EndIf
   EndIf

   RestArea(aArea)

Return xRet
