#Include "PROTHEUS.CH"     
#Include "rwmake.ch"
user function AAFATE09()

nComis := 0
nComiscli:= POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"SA1->A1_COMIS")
nComisven:= POSICIONE("SA3",1,XFILIAL("SA3")+M->C5_VEND1,"SA3->A3_COMIS")  

if nComiscli>0
   nComis := nComiscli
else
   nComis := nComisven
endif

return nComis