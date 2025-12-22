#INCLUDE "rwmake.ch" 
#Include "TBICONN.CH"

User Function UPDSZ6SZ7()  

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES "CNE,CN9,SC7,SZ6,SZ7" //"SZ6,SZ7"

	Alert("Aperte para começar !")

   /*SZ7->(dbGoTop())
	While !SZ7->(Eof())
	   SZ6->(dbSetOrder(1))
	   If !Empty(SZ7->Z7_JUSTIFI)
		   If SZ6->(dbSeek(SZ7->(Z7_FILIAL+"3"+Z7_CODIGO)))	      
		         RecLock("SZ6",.F.)
		      ELSE 
		         RecLock("SZ6",.T.)
		   Endif
		    SZ6->Z6_FILIAL := xFIlial('SZ6')
		    SZ6->Z6_NUM    := SZ7->Z7_CODIGO
		    SZ6->Z6_TIPO   := '3'
		    SZ6->Z6_JUSTIFI := SZ7->Z7_JUSTIFI
		    MsUnLock()
		   
	   Endif
	   SZ7->(dbSkip())
	Enddo*/

	/*SZ7->(dbGoTop())
	While !SZ7->(Eof())
	   SZ6->(dbSetOrder(1))
	   If SZ6->(dbSeek(SZ7->(Z7_FILIAL+"3"+Z7_CODIGO)))
	      If !Empty(SZ6->Z6_JUSTIFI) .And. Empty(SZ7->Z7_JUSTIFI)
	         RecLock("SZ7",.F.)
	         SZ7->Z7_JUSTIFI := SZ6->Z6_JUSTIFI
	         MsUnLock()
	      Endif
	   Endif
	   SZ7->(dbSkip())
	Enddo*/
   
   CNE->(dbGoTop())
   While !CNE->(Eof())
      CN9->(dbSetOrder(1))
      If CN9->(dbSeek(CNE->(CNE_FILIAL+CNE_CONTRA+CNE_REVISA)))
         SC7->(dbSetOrder(1))
         If SC7->(dbSeek(CNE->(CNE_FILIAL+CNE_PEDIDO)))
            SZ6->(dbSetOrder(1))
            If !SZ6->(dbSeek(SC7->(C7_FILIAL+"1"+PADR(C7_NUM,9))))
               RecLock("SZ6",.T.)
               SZ6->Z6_FILIAL  := SC7->C7_FILIAL
               SZ6->Z6_TIPO    := "1"
               SZ6->Z6_NUM     := SC7->C7_NUM
               SZ6->Z6_JUSTIFI := CN9->CN9_XJUSTF
               MsUnLock()
            Endif
	      Endif
      Endif
      CNE->(dbSkip())
   Enddo

	Alert("Acabou !!!")

	RESET ENVIRONMENT

Return
