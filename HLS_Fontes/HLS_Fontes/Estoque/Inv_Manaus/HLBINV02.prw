#Include "Rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ HLBINV02   ¦ Autor ¦ WILLIAMS MESSA       ¦ Data ¦ 02/06/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ ExecBlock para validar a digitação da Etiqueta.               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function HLBINV02()

Local cData := GetMv("MV_DATAINV")                                                              
Local lRet  := .F.


dbSelectArea("SZ3")
dbSetOrder(2)

If !SZ3->(dbSeek(xFilial()+AllTrim(cData)+M->B7_NROETIQ))
		MsgBox("Etiqueta Inexistente, tente novamente!","Atencao","ALERT")
		lRet  := .F.
Else  
		M->B7_COD     := SZ3->Z3_PRODUTO
		M->B7_LOCAL   := SZ3->Z3_LOCAL
		M->B7_TIPO    := SZ3->Z3_TIPO
		M->B7_DOC     := SZ3->Z3_DOCINV
		M->B7_DATA    := SZ3->Z3_DATA
		//M->B7_LOCALIZ := SZ3->Z3_ENDEREC //INCLUSÃO POR ADRIANO JORGE EM 14/06/10
		//M->B7_DESC    := Posicione("SB1",1,XFILIAL("SB1")+SZ3->Z3_PRODUTO,"B1_DESCING")+"-"+Posicione("SB1",1,XFILIAL("SB1")+SZ3->Z3_PRODUTO,"B1_UM")
	   lRet  := .T.   		
EndIf

Return(lRet)
 