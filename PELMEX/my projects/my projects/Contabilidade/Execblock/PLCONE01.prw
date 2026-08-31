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

User Function PLCONE01()     
	Local cCC:= "3000"         

	Do Case
	Case SE1->E1_MSFIL = "01"
		cCC := "8000"
	Case SE1->E1_MSFIL = "02"
		cCC := "8000"
	Case SE1->E1_MSFIL = "03"
		cCC := "10400"
	Case SE1->E1_MSFIL = "04"
		cCC := "8200"
	Case SE1->E1_MSFIL = "05"
		cCC := "8300"
	Case SE1->E1_MSFIL = "06"
		cCC := "8400"
	Case SE1->E1_MSFIL = "07"
		cCC := ""
	Case SE1->E1_MSFIL = "08"
		cCC := "10402"
	Case SE1->E1_MSFIL = "09"
		cCC := "8800"
	Case SE1->E1_MSFIL = "10"
		cCC := ""
	Case SE1->E1_MSFIL = "11"
		cCC := "8600"
	case SE1->E1_MSFIL = "12"
		cCC := "9300"
	Case SE1->E1_MSFIL = "13"
		cCC := "9500"
	Case SE1->E1_MSFIL = "14"
		cCC := "9900"
	Case SE1->E1_MSFIL = "15"
		cCC := "9800"
	Case SE1->E1_MSFIL = "16"
		cCC := "10000"
	Case SE1->E1_MSFIL = "17"
		cCC := "10100"
	Case SE1->E1_MSFIL = "18"
		cCC := "10603"
	Case SE1->E1_MSFIL = "19"
		cCC := "10300"
	Case SE1->E1_MSFIL = "20"
		cCC := "10500"
	Case SE1->E1_MSFIL = "21"
		cCC := "10600"
	Case SE1->E1_MSFIL = "22"
		cCC := "10700"
	Case SE1->E1_MSFIL = "23"
		cCC := "10800"
	Case SE1->E1_MSFIL = "24"
		cCC := "10900"
	Case SE1->E1_MSFIL = "25"
		cCC := "10601"
	Case SE1->E1_MSFIL = "26"
		cCC := "11000"
	Case SE1->E1_MSFIL = "27"
		cCC := "10404"
	Case SE1->E1_MSFIL = "28"
		cCC := ""
	Case SE1->E1_MSFIL = "29"
		cCC := ""
	Case SE1->E1_MSFIL = "30"
		cCC := ""
	EndCase

return cCC
