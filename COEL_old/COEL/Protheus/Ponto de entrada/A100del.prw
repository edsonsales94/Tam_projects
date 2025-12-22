#include 'totvs.ch'

User Function A100DEL

Local cNfent     := SF1->F1_DOC+SF1->F1_SERIE
Local cTesbn     := GETMV("MV_X_TESBN")
Local aVetProd   :={}
Local _aAreaSd1  := GetArea()
Local lLiber     := .F.
Public aVetDeOP := {}
dbSelectArea("SD1")
dbSetOrder(1)
If dbSeek( xFilial("SD1")+cNfent )
	while SD1->D1_DOC+SD1->D1_SERIE == cNfent 
		If !Empty(SD1->D1_OP) .and. SD1->D1_TES $ cTesbn
			 Dbselectarea("SD3")
    		 dbOrderNickName("D3OPTMBAIX") 
			 If dbseek(xFilial("SD3")+SD1->D1_OP+"400")
				lMsErroAuto := .f. 
			//	aVetProd:= GetSX3Field("SD3")
				aVetProd= Array(4)
				aVetProd[1] := {"D3_NUMSEQ"	,SD3->D3_NUMSEQ		,Nil}
				aVetProd[2] := {"D3_CHAVE"	,SD3->D3_CHAVE		,Nil}
				aVetProd[3] := {"D3_COD"	,SD3->D3_COD		,Nil}
				aVetProd[4] := {"INDEX"		,4					,Nil}
	
				MSExecAuto({|x,y| mata250(x,y)},aVetProd,5) //BAIXA Opção escolhida: 3) Inclusão5) Estorno7) Encerramento
				If lMsErroAuto 
		   	   		MostraErro() 
				Else
			   		Aadd(aVetDeOP,SD1->D1_OP)
			   		Alert("OP Numero " + SD1->D1_OP + "Estornada com Sucesso")
			   		lLiber    := .T.
				Endif
			 Endif
		Endif
		SD1->(DBSKIP())
	End
	lLiber    := .T.
Endif
RestArea(_aAreaSd1)
Return(lLiber)

/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

Static Function GetSX3Field(cAlias)

Local aAreaSX3 := SX3->(GetArea())

Local aField  := {}

SX3->(DbSetOrder(1))

If SX3->(DbSeek(cAlias))

	While SX3->( !Eof() ) .AND. Alltrim(SX3->X3_ARQUIVO) == Alltrim(cAlias)
  
		If SX3->X3_CONTEXT <> "V" .and. !Empty((cAlias)->&(SX3->X3_CAMPO))
	   		aAdd(aField,{SX3->X3_CAMPO,(cAlias)->&(SX3->X3_CAMPO),Nil})
		Endif 
	  
	  	SX3->(DbSkip()) 
	EndDo
 
	If Len(aField) > 0
  	aAdd(aField,{"AUTDELETA","N",Nil})   
	Endif
Endif
RestArea(aAreaSx3)
Return(aField)