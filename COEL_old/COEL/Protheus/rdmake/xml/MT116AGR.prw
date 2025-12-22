#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหออออออัอออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  MT116AGR      บAutor ณFabiano Pereiraบ Data ณ 20/02/2014  บฑฑ
ฑฑฬออออออออออุออออออออออออออออสออออออฯอออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo da Nota de Conhecimento de Frete responsแvel pela    บฑฑ
ฑฑบ          ณinclusใo de notas de conhecimento de frete.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณAp๓s a grava็ใo da NF de conhecimento de frete fora da      บฑฑ
ฑฑบ          ณtransa็ใo.                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*********************************************************************
User Function MT116AGR()
*********************************************************************
Local 	aAlias		:= GetArea() 

If 	ExistBlock('PE_CTeImpXml')
	lRet := ExecBlock('PE_CTeImpXml',.F.,.F.,{'MT116AGR'})
EndIf


RestArea(aAlias)
Return()