#include "rwmake.ch"

User Function RORCG02()

SetPrvt("NPOS,CPRODUTO,NPRV1,NPRV2,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATG02  ³ Autor ³Rogerio Batista        ³ Data ³03/07/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gatilho para Validacao do Produto no Pedido de Venda       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Gatilho Disparado no Campo C6_TES/C6_TES                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

//nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_PRODUTO"})                           
//cProduto := aCols[n,nPos]
cProduto := TMP1->CK_PRODUTO

//nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_TES"})
//cTes     := aCols[n,nPos]
cTes       := TMP1->CK_TES
_cTipoCli  := Posicione("SA1",1,xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA,"A1_TIPO") 

If SM0->M0_CODFIL =="01"
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+cProduto)
		If EMPTY(SB1->B1_X_DCR) .AND. SA1->A1_TIPO <> "X"
	    	MsgBox("Atencao, o produto "+Alltrim(cProduto)+" nao possui DCR cadastrado","Stop")
		    TMP1->CK_PRODUTO := ""
		   _cRet := ""
		Endif
	Endif                                             
	
	Return(cTes)
Else
	If _cTipoCli == "S"
		DbSelectArea("SB1")
		DbSetOrder(1)                                    
		If DbSeek(xFilial("SB1")+cProduto)                           
			If !EMPTY(SB1->B1_GRTRIB) .AND. SB1->B1_GRTRIB<>"300   "
				If !(cTes $ "575/993/577/597")
					 IF (Subs(SB1->B1_POSIPI,1,4)$"9032") .and. !(SA1->A1_EST $("GO/SC/DF/MA/PE/RJ/RS")).or.(Subs(SB1->B1_POSIPI,1,4)$"8533" .and. !(SA1->A1_EST $("DF")) .or. (Alltrim(SB1->B1_POSIPI)=="90330000").and. !(SA1->A1_EST $("DF"))).or. (Alltrim(SB1->B1_POSIPI)=="85365090").and. !(SA1->A1_EST $("SP"))
							dbSelectArea("SF4")
							dbSetOrder(1)
							dbSeek(xFilial("SF4")+cTes)
							If SF4->F4_PODER3 $ "D/R"
								_cRet := cTes
							Else
							   IF (Subs(SB1->B1_POSIPI,1,4)$"9032") .and. (SA1->A1_EST $("SP/PR/RJ/RS")) .OR. (Subs(SB1->B1_POSIPI,1,4)$"8533") .and. (SA1->A1_EST $("SP/PE/GO/PR/MG/RJ/RS/MA")).OR. (Alltrim(SB1->B1_POSIPI)=="90330000") .and. (SA1->A1_EST $("SP/PE/GO/PR/RJ/RS/MA")) .or. (Alltrim(SB1->B1_POSIPI)=="85365090").and. !(SA1->A1_EST $("SP"))
							       _cRet := cTes
							   Else
								  MsgBox("Atencao, o produto "+Alltrim(cProduto)+" esta enquadrado na Substituicao Tributaria, precisa utilizar o TES 575/577/597/993","Stop")
							      TMP1->CK_TES := ""
								  _cRet := ""
							   Endif
							EndIf
					 Else
						 IF (Subs(SB1->B1_POSIPI,1,4)$"9032") .and. (SA1->A1_EST $("SP/PR/RJ/RS/SC/PE/GO")) .OR. (Subs(SB1->B1_POSIPI,1,4)$"8533") .and. (SA1->A1_EST $("SP/PE/GO/PR")).OR. (Alltrim(SB1->B1_POSIPI)=="90330000") .and. (SA1->A1_EST $("SP/PE/GO/PR/RJ/RS/MA"))
					 		_cRet := cTes
					 	 Else
					 		MsgBox("Atencao, o produto "+Alltrim(cProduto)+" esta enquadrado na Substituicao Tributaria, precisa utilizar o TES 575/577/597/993","Stop")
							TMP1->CK_TES := ""
							_cRet := ""
						 Endif
					 Endif
					 //_cRet := cTes
				Else
					If !(cTes $ "575/577/597/993") .and. !(SA1->A1_EST $("GO/SC/DF/MA/PE")).or. !(cTes $ "575/577/597/993") .and.!(SA1->A1_EST $("DF")) .or.  !(cTes $ "575/577/597/993") .and.!(SA1->A1_EST $("SC/DF"))
						MsgBox("Atencao, o produto "+Alltrim(cProduto)+" esta enquadrado na Substituicao Tributaria, precisa utilizar o TES 575/577/597/993","Stop")
						TMP1->CK_TES := ""
						_cRet := ""
					Else
					   IF (Subs(SB1->B1_POSIPI,1,4)$"9032") .and. (SA1->A1_EST $("SP/PR/SC/PE/GO/RJ/RS")) .OR. (Subs(SB1->B1_POSIPI,1,4)$"8533") .and. (SA1->A1_EST $("SP/PE/GO/PR")).OR. (Subs(SB1->B1_POSIPI,1,4)$"90330000") .and. (SA1->A1_EST $("SP/PE/GO/PR/RJ/RS/MA"))
					//	MsgBox("Atencao, o produto "+Alltrim(cProduto)+" esta enquadrado na Substituicao Tributaria, precisa utilizar o TES 575/577/597/993","Stop")
						MsgBox("Atencao, o produto "+Alltrim(cProduto)+" esta enquadrado na Substituicao Tributaria, p[orem se enquadra em uma excessáo de estado precisa utilizar o TES 501","Stop")
							TMP1->CK_TES := ""
							_cRet := ""
					   Else
							_cRet := cTes
					   Endif
					EndIf
				Endif
			Else
				If cTes $ "575/577/597/993"
					MsgBox("Atencao, o produto "+Alltrim(cProduto)+" nao esta enquadrado na Substituicao Tributaria, nao pode utilizar o TES 575/577/597/993","Stop")
					_cRet := ""
				   	TMP1->CK_TES := ""
				Else
					_cRet := cTes
				EndIf
			EndIf
							
	    Else
			_cRet := cTes
		EndIf
	
	Else
		If cTes $ "575/577/597/993" 
			MsgBox("Atencao, o cliente nao esta enquadrado na Substituicao Tributaria, nao pode utilizar o TES 575/577/597/993","Stop")
			_cRet := ""
		Else
			_cRet := cTes
		EndIf
	
	Endif	

EndIf


Return(_cRet)


