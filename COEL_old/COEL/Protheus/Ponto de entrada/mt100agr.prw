#include 'totvs.ch'

User Function MT100AGR

Local cNfent     := SF1->F1_DOC+SF1->F1_SERIE
Local cTesbn     := GETMV("MV_X_TESBN")
Local aVetProd   :={}
Local _aAreaSd1  := GetArea()
Local lLiber     := .F.
//Public aVetDeOP := {}
dbSelectArea("SD1")
dbSetOrder(1)
If dbSeek( xFilial("SD1")+cNfent )
	while SD1->D1_DOC+SD1->D1_SERIE == cNfent 
		If !Empty(SD1->D1_OP) .and. SD1->D1_TES $ cTesbn
			 
			aVetProd:={{"D3_OP"     , SD1->D1_OP  , NiL},;      
          			   {"D3_TM"     , "400"	      , NIL}} //004
			 
			lMsErroAuto := .f.
			MSExecAuto({|x,y| mata250(x,y)},aVetProd,3) //BAIXA Opção escolhida: 3) Inclusão5) Estorno7) Encerramento
			If lMsErroAuto 
		   		MostraErro() 
			Else
				Alert("OP Numero " + SD1->D1_OP + "Apontada com Sucesso")
			 	lLiber    := .T.
			Endif
		Endif
		SD1->(DBSKIP())
	End
Endif
RestArea(_aAreaSd1)
aVetProd   :={}
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