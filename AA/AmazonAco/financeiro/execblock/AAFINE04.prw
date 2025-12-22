#include 'totvs.ch'
User Function AAFINE04()
  Local aParamBox := {}
  Local aRet
  Local xdTipos := GetMv("MV_XTPADC",.F.,"")

  If SE1->E1_SALDO <= 0
     FwAlertError("","Titulo Totalmente Baixado, Operação inválida")
     Return
  EndIf

  If !Empty(xdTipos) .And. xdTipos$SE1->E1_TIPO
     FwAlertError("","Tipo não habilitado para alteração de acrescimo, descrescimo")
     Return
  EndIf
  
  aAdd(aParamBox,{1,"Acrescimo", SE1->E1_SDACRES,"@E 999,999.99","Positivo()","","",50,.F.}) // Tipo caractere
  aAdd(aParamBox,{1,"Decrescimo", SE1->E1_SDDECRE,"@E 999,999.99","Positivo()","","",50,.F.}) // Tipo caractere

  If ParamBox(aParamBox,"Acres/Decres - " + SE1->E1_TIPO + "|" + SE1->E1_NUM,@aRet)
     SE1->(RecLock('SE1',.F.))
       SE1->E1_SDACRES := aRet[01]
       SE1->E1_SDDECRE := aRet[02]
     SE1->(MsUnlock())
     FwAlertInfo("Alteração Efetuada com sucesso")
  EndIf

Return Nil
