#include "rwmake.ch"
/*/{protheus.doc}HLFAT001
Funcao que retorna conta contabil
@author Honda Lock
/*/


User Function HLFAT001()

xCONTA := ""

IF ALLTRIM(SD2->D2_CF) $ "5101|6101" .And. ALLTRIM(SA1->A1_NATUREZ) $ "102009"
	xConta := "3401020003"
//	xConta := "4611110001"  //alterado vfv 22/07/15
EndIf

IF ALLTRIM(SD2->D2_CF) $ "5101|6101" .And. ALLTRIM(SA1->A1_NATUREZ) != "102009"
	xConta := "3101010011"
Endif

IF ALLTRIM(SD2->D2_CF) $ "5102|6102" .And. ALLTRIM(SA1->A1_NATUREZ) $ "102009"
	xConta := "3401020003"
//	xConta := "4611110001"  //alterado vfv 22/07/15
Endif

IF ALLTRIM(SD2->D2_CF) $ "5102|6102" .And. ALLTRIM(SA1->A1_NATUREZ) != "102009"
	xConta := "3101010002"
//	xConta := "3111110011" //alterado vfv 09/04/15
Endif

IF ALLTRIM(SD2->D2_CF) $ "5124|6124" .And. ALLTRIM(SA1->A1_NATUREZ) $ "102009"
	xConta := "3401020003"
//	xConta := "4611110001"  //alterado vfv 22/07/15
Endif

IF ALLTRIM(SD2->D2_CF) $ "5124|6124" .And. ALLTRIM(SA1->A1_NATUREZ) != "102009"
	xConta := "3101010031"
Endif

IF ALLTRIM(SD2->D2_CF) $ "5949|6949" .And. ALLTRIM(SA1->A1_NATUREZ) != "102009"
	xConta := "3401020003"
//	xConta := "4611110001"  //alterado vfv 22/07/15
Endif

Return(xCONTA)
