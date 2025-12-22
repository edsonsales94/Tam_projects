#Include "Rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ HLBINV04   ¦ Autor ¦ WILLIAMS MESSA       ¦ Data ¦ 17/06/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ ExecBlock para validar a contagem do produto.                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function HLBINV04()

Local cData := GetMv("MV_DATAINV")                                                              
Local lRet  := .F.


dbSelectArea("SZ3")
dbSetOrder(2)

If !SZ3->(dbSeek(xFilial()+AllTrim(cData)+M->B7_NROETIQ))
		MsgBox("Nro da Etiqueta errada!","Atencao","ALERT")
		lRet  := .F.
Else 
		//Checagem da segunda contagem  
		If M->B7_CONTAGE == "1  "
			If Alltrim(SZ3->Z3_COUNT01)=="" 
				lRet  := .T.
			ElseIf !Empty(SZ3->Z3_COUNT01)
				MsgBox("Item conferido na primeira contagem!","Atencao","ALERT") 
				lRet  := .F.						
			EndIf
		EndIf
		//Checagem da segunda contagem
		If M->B7_CONTAGE == "2  " 
		   If Alltrim(SZ3->Z3_COUNT01)==""
				MsgBox("Não existe primeira contagem para este item, favor verificar!","Atencao","ALERT")
				lRet  := .F.
		   Else
		   	If !Empty(SZ3->Z3_COUNT02)
		   		MsgBox("Item conferido na segunda contagem!","Atencao","ALERT") 
					lRet  := .F.						
		   	Else 
		   		lRet  := .T.
		   	EndIf
			EndIf
		EndIf
		//Checagem da terceira contagem
		If M->B7_CONTAGE == "3  " 
		   If Alltrim(SZ3->Z3_COUNT02)=="" .Or. Alltrim(SZ3->Z3_COUNT01)==""
				MsgBox("Não existe contagem anteriores para este item, favor verificar!","Atencao","ALERT")
				lRet  := .F.
		   Else
		   	If !Empty(SZ3->Z3_COUNT03)
		   		MsgBox("Item conferido na terceira contagem!","Atencao","ALERT") 
					lRet  := .F.						
		   	Else 
		   		lRet  := .T.
		   	EndIf
			EndIf
		EndIf 		
EndIf
Return(lRet)
