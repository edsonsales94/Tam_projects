/*
Padrao DATAMAX
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG02     ºAutor  ³Sandro Valex        º Data ³  19/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao da     º±±
±±º          ³endereco                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img02 // imagem de etiqueta de ENDERECO
Local cCodigo
Local cCodID := paramixb[1]
If cCodID # NIL
	cCodigo := cCodID
ElseIf Empty(SBE->BE_IDETIQ)
	If Usacb0('02')
		cCodigo := CBGrvEti('02',{SBE->BE_LOCALIZ,SBE->BE_LOCAL})
		RecLock("SBE",.F.)
		SBE->BE_IDETIQ := cCodigo
		MsUnlock()
	Else
		cCodigo :=SBE->(BE_LOCAL+BE_LOCALIZ)
	EndIf
Else
	If Usacb0('02')
		cCodigo := SBE->BE_IDETIQ
	Else
		cCodigo :=SBE->(BE_LOCAL+BE_LOCALIZ)
	EndIf
Endif
cCodigo := Alltrim(cCodigo)

MSCBBEGIN( 1, 4)
	
MSCBSay(45,30,cCodigo,"N","3","01","01")
MSCBSayBar(25,33,cCodigo,"N","MB07",12,.F.,.F.,.F.,,3,3,.F.,.F.,"1",.T.)

MSCBSay(5,46,"ENDERECO: " + AllTrim(SBE->BE_LOCALIZ),"N","4","01","01")
MSCBSay(5,52,"DESC. : " + AllTrim(SBE->BE_DESCRIC),"N","3","01","01")

MSCBInfoEti("Endereco","30X100")
MSCBEND()
Return .F.