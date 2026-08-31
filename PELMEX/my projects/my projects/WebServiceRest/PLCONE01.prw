#include 'protheus.ch'
#include 'parmtype.ch'
#include 'RestFul.ch'
#include 'Totvs.ch'

User Function PLCONE01()
Local cCC := ""
    if SE1->E1_FILORIG = "01"
        cCC := "3000"
    elseif SE1->E1_FILORIG = "04"
        cCC := "8200"
    elseif SE1->E1_FILORIG = "06"
        cCC := "8400"
    elseif SE1->E1_FILORIG = "07"
        cCC := "12000"
    elseif SE1->E1_FILORIG = "12"
        cCC := "9300"
    elseif SE1->E1_FILORIG = "13"
        cCC := "9500"
    elseif SE1->E1_FILORIG = "15"
        cCC := "9800"
    elseif SE1->E1_FILORIG = "16"
        cCC := "10000"
    elseif SE1->E1_FILORIG = "17"
        cCC := "10100"
    elseif SE1->E1_FILORIG = "21"
        cCC := "10600"
    elseif SE1->E1_FILORIG = "24"
        cCC := "10900"
    elseif SE1->E1_FILORIG = "25"
        cCC := "10604"
    endif
    
return cCC
