#include "rwmake.ch"

User Function RFATG02()

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

nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_PRODUTO"})
cProduto := aCols[n,nPos]

nPos     := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "C6_TES"})
cTes     := aCols[n,nPos]

_cTipoCli := M->C5_TIPOCLI

//If SM0->M0_CODFIL =="01"
//	Return(cTes)
//Else
	If _cTipoCli == "S"
		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+cProduto)
			If !EMPTY(SB1->B1_GRTRIB) .and. SB1->B1_GRTRIB<>"300   "
				If !(cTes $ "575/577/581/593/717/757/784/993")
					dbSelectArea("SF4")
					dbSetOrder(1)
					dbSeek(xFilial("SF4")+cTes)
					If SF4->F4_PODER3 $ "D/R"
						_cRet := cTes
					Else
						MsgBox("Atencao, o produto "+Alltrim(cProduto)+" esta enquadrado na Substituicao Tributaria, precisa utilizar o TES 575/577/581/593/717/757/993","Stop")
						_cRet := ""
					EndIf
				Else
					_cRet := cTes
				EndIf
			Else
				If cTes $ "575/577/581/717/993"
					MsgBox("Atencao, o produto "+Alltrim(cProduto)+" nao esta enquadrado na Substituicao Tributaria, nao pode utilizar o TES 575/577/581/593/717/757/993","Stop")
					_cRet := ""
				Else
					_cRet := cTes
				EndIf
			EndIf
			
		Else
			_cRet := cTes
		EndIf
	Else
		If cTes $ "575/577/581/717/993"
			MsgBox("Atencao, o cliente nao esta enquadrado na Substituicao Tributaria, nao pode utilizar o TES 575/577/581/717/993","Stop")
			_cRet := ""
		Else
			_cRet := cTes
		EndIf
	EndIf
	
//EndIf


Return(_cRet)

