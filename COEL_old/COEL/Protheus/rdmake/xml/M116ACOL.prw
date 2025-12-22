#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#DEFINE  ENTER CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M116ACOL       ºAutor ³Fabiano Pereiraº Data ³ 22/04/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Permite manipulação de entrada em Conhecimento de Frete.    º±±
±±º          ³                                                            º±±
±±º          ³Possibilita identificar o documento que está sendo 		  º±±
±±º          ³processado, para adicionar campos customizados              º±±
±±º          ³pré-existentes no ambiente com seus conteúdos preenchidos   º±±
±±º          ³no aCols do conhecimento de frete.                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*********************************************************************
User Function M116ACOL()
*********************************************************************
Local 	aAlias	:= GetArea() 

//DbSelectArea('ZXC') 
//dDEmissao := ZXC->ZXC_DTNFE
                                
                               
nLinha	:=	ParamIxb[02]
nPPIcms := 	Ascan(aHeader,{|x| Alltrim(x[2]) == "D1_PICM" })
If nPPIcms > 0
	If ZXC->(FieldPos("ZXC_PICMS")) > 0				//	AJUSTE 26/03/2015
		aCols[nLinha][nPPIcms] := ZXC->ZXC_PICMS
	EndIf	
EndIf

If Empty(aNFEDanfe[13])
	aNFEDanfe[13]   :=	ZXC->ZXC_CHAVE
EndIf
	
RestArea(aAlias)
Return()