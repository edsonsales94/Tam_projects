/*
Solicitacao do Sr. Rafael Bocchi em 16/05/13
*/

#include "rwmake.ch"     

User Function M410STTS()    //Ponto Entrada, apos gravacao do pedido de venda

Local c_Alias := ALIAS()
Local nPos    := Ascan(aHeader,{|x| upper(alltrim(x[2]))="C6_CF"})
Local lFatur  := aCols[1,nPos] $ '5101 ,5102 ,5122 ,6101 ,6102 ,6122 ,7101 ,7102 ,7107 '
Local c_Bloq  := IIF(M->Altera .OR. ( M->C5_TIPO $ "NC" .AND. lFatur ) , "1" , " " )

IF ( M->C5_BLQ == "1" )
	IF ( M->Inclui .OR. M->Altera )
		
		RecLock("SC5",.F.)
		SC5->C5_BLQ := c_Bloq
		MsUnlock()
		
	ENDIF
	
ENDIF

dbSelectArea(c_Alias)

Return