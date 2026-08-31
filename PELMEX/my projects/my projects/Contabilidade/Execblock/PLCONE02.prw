#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PLCONE01  ºAutor³ Marcel Robinson Grosselli Data ³23/05/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona o Centro de Custo nos lançamentos Padroes        º±±
±±º          ³ 520-004, 521-004, 527-004                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PLCONE02()     
	Local cCONTA:= 0         


	Do Case
		Case SD2->D2_FILIAL = "01"
		cCONTA := "31101010101"
		Case SD2->D2_FILIAL = "02"
		cCONTA := "31101010301"
		Case SD2->D2_FILIAL = "03"
		cCONTA := "31101010321"
		Case SD2->D2_FILIAL = "04"
		cCONTA := "31101010303"
		Case SD2->D2_FILIAL = "05"
		cCONTA := "31101010304"
		Case SD2->D2_FILIAL = "06"
		cCONTA := "31101010305"
		Case SD2->D2_FILIAL = "07"
		cCONTA := "31101010331"
		Case SD2->D2_FILIAL = "08"
		cCONTA := "31101010314"
		Case SD2->D2_FILIAL = "09"
		cCONTA := "31101010307"
		Case SD2->D2_FILIAL = "10"
		cCONTA := "31101010322"
		Case SD2->D2_FILIAL = "11"
		cCONTA := "31101010308"
		case SD2->D2_FILIAL = "12"
		cCONTA := "31101010311"
		Case SD2->D2_FILIAL = "13"
		cCONTA := "31101010313"
		Case SD2->D2_FILIAL = "14"
		cCONTA := "31101010315"
		Case SD2->D2_FILIAL = "15"
		cCONTA := "31101010316"
		Case SD2->D2_FILIAL = "16"
		cCONTA := "31101010317"
		Case SD2->D2_FILIAL = "17"
		cCONTA := "31101010318"
		Case SD2->D2_FILIAL = "18"
		cCONTA := "31101010319"
		Case SD2->D2_FILIAL = "19"
		cCONTA := "31101010320"
		Case SD2->D2_FILIAL = "20"
		cCONTA := "31101010323"
		Case SD2->D2_FILIAL = "21"
		cCONTA := "31101010324"
		Case SD2->D2_FILIAL = "22"
		cCONTA := "31101010325"
		Case SD2->D2_FILIAL = "23"
		cCONTA := "31101010326"
		Case SD2->D2_FILIAL = "24"
		cCONTA := "31101010327"
		Case SD2->D2_FILIAL = "25"
		cCONTA := "31101010328"
		Case SD2->D2_FILIAL = "26"
		cCONTA := "31101010321"
		Case SD2->D2_FILIAL = "27"
		cCONTA := "31101010329"
		Case SD2->D2_FILIAL = "28"
		cCONTA := ""
		Case SD2->D2_FILIAL = "29"
		cCONTA := ""
		Case SD2->D2_FILIAL = "30"
		cCONTA := ""
		Case SD2->D2_FILIAL = "31"
		cCONTA := ""
		Case SD2->D2_FILIAL = "20"
		cCONTA := "31101010323"
		
	EndCase


return cCONTA
