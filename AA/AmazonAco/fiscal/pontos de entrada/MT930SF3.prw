#include "Protheus.ch"

User Function MT930SF3()
      SF2->(dbSetOrder(1))
   if SF2->(dbseek(xFilial('SF2') + SF3->(F3_NFISCAL + F3_SERIE)))
      If SF3->(FieldPos("F3_XPERRES")) > 0
          SF3->(RecLock('SF3',.F.))
             SF3->F3_XPERRES := SF2->F2_XPERRES
          SF3->(MsUnlock())
       EndIf
   Endif
Return Nil