#include "Protheus.ch"

User Function fMenus()
Local aaMenu    := {}
Local aaRotinas := {}
Local aaSubRoti := {}
Local aaVector  := {}
Local aaVectorb := {}
Local naX       := 0
Local naY       := 0
Local naZ       := 0
Local naA       := 0
Local naB       := 0
Local caMenu    := ""
Local caPath    := ""
Local caFunct   := ""
Local caVersao  := "V12"
Local aFiles    := {}
Local aSizes    := {}
Local n_xyz     := 0

nFilesJPG := aDir( "\system\*.XNU" , aFiles, aSizes )

DbSelectArea("SZT")
DbSetOrder(1)

For n_xyz := 1 to nFilesJPG
 caMenu    := aFiles[n_xyz]
 aaMenu    := XNULoad("\system\"+aFiles[n_xyz])
 
 For naX := 1 to Len(aaMenu)
  aaRotinas := aClone(aaMenu[naX][3])//fun
  For naY := 1 to Len(aaRotinas)
   _cxVal := &("aaRotinas["+ALLTRIM(STR(naY))+"][3]")
   If ValType(_cxVal)=="C"
    caPath   := aaMenu[naX][1][1]
    caFunct  := aaRotinas[naY][3]
    caRotina := aaRotinas[naY][1][1]
    If !SZT->(dbSeek(xFilial("SZT")+caVersao+PADR(caFunct,20)+PADR(caMenu,50)))
     RecLock("SZT",.T.)
     SZT->ZT_VERSAO   := caVersao
     SZT->ZT_CAMINHO  := caPath
     SZT->ZT_ROTINA   := caRotina
     SZT->ZT_FUNCTIO  := caFunct
     SZT->ZT_MENU     := caMenu
     MsUnlock()
    EndIf
   Else
    aaSubRoti := aClone(aaRotinas[naY][3])
    For naZ := 1 to Len(aaSubRoti)
     _cxVal := &("aaSubRoti["+ALLTRIM(STR(naZ))+"][3]")
     If ValType(_cxVal)=="C"
      caPath   := aaMenu[naX][1][1]+"->"+aaRotinas[naY][1][1]
      caFunct  := aaSubRoti[naZ][3]
      caRotina := aaSubRoti[naZ][1][1]
      If !SZT->(dbSeek(xFilial("SZT")+caVersao+PADR(caFunct,20)+PADR(caMenu,50)))
       RecLock("SZT",.T.)
       SZT->ZT_VERSAO   := caVersao
       SZT->ZT_CAMINHO  := caPath
       SZT->ZT_ROTINA   := caRotina
       SZT->ZT_FUNCTIO  := caFunct
       SZT->ZT_MENU     := caMenu
       MsUnlock()
      EndIf
      
     Else
      
      aaVector := aClone(aaSubRoti[naZ][3])  //fun
      For naA := 1 to Len(aaVector)
       _cxVal := &("aaVector["+ALLTRIM(STR(naA))+"][3]")
       If ValType(_cxVal)=="C"
        caPath   := aaMenu[naX][1][1]+"->"+aaRotinas[naY][1][1]+"->"+aaSubRoti[naZ][1][1]
        caFunct  := aaVector[naA][3]
        caRotina := aaVector[naA][1][1]
        If !dbSeek(xFilial("SZT")+caVersao+PADR(caFunct,20)+caMenu)
         RecLock("SZT",.T.)
         SZT->ZT_VERSAO   := caVersao
         SZT->ZT_CAMINHO  := caPath
         SZT->ZT_ROTINA   := caRotina
         SZT->ZT_FUNCTIO  := caFunct
         SZT->ZT_MENU     := caMenu
         MsUnlock()
        EndIf
       Else
        aaVectorb := aClone(aaVector[naA][3])  //fun
        For naB := 1 to Len(aaVectorB)
         
         caPath   := aaMenu[naX][1][1]+"->"+aaRotinas[naY][1][1]+"->"+aaSubRoti[naZ][1][1]+"->"+aaVector[naA][1][1]
         caFunct  := aaVectorB[naB][3]
         caRotina := aaVectorB[naB][1][1]
         If !dbSeek(xFilial("SZT")+caVersao+PADR(caFunct,20)+caMenu)
          RecLock("SZT",.T.)
          SZT->ZT_VERSAO   := caVersao
          SZT->ZT_CAMINHO  := caPath
          SZT->ZT_ROTINA   := caRotina
          SZT->ZT_FUNCTIO  := caFunct
          SZT->ZT_MENU     := caMenu
          MsUnlock()
         EndIf 
         
        Next naB
       EndIf
      Next naA
     EndIf
    Next naZ
   endif
  Next naY
 Next naX
 
Next n_xyz

Return