#Include "RwMake.Ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SISP001  ³ Autor ³ André Campos          ³ Data ³ 08/08/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ExecBlock disparado do 341REM.PAG para retornar agencia,   ³±±
±±³          ³ conta e digito.(UTILIZADOS SÓ PARA OS CLIENTES DA CONTROLE)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNAB SISPAG                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function SISP_FIN()
Local cLinha := ""
Local cAge   := ""
Local cCCta  := ""

if !empty(SE2->E2_FORAGE)
	cAge   := LimpaC(SE2->E2_FORAGE)
	cCCta  := LimpaC(SE2->E2_FORCTA) + LimpaC(SE2->E2_FAGEDV)
	If SE2->E2_BCOPAG == "341" //SE2->E2_BANCO == "341"
		//--> Conforme NOTA 11, formatacao propria para tranferencia entre agencias do ITAU
		cLinha := "0" + StrZero(Val(cAge),4) + " 0000000" + Left(cCCta,5) + " " + Right(cCCta,1)
	Else
		cLinha := StrZero(Val(cAge),5) + " " + StrZero(Val(Left(cCCta,Len(cCCta)-1)),12) + " " + Right(cCCta,1)
	EndIf
Else
	IF !empty(SA2->A2_AGENCIA)
		cAge   := LimpaC(SA2->A2_AGENCIA)
		cCCta  := LimpaC(SA2->A2_NUMCON)//+ LimpaC(SA2->A2_DIGCON)
		If SA2->A2_BANCO == "341"
			//--> Conforme NOTA 11, formatacao propria para tranferencia entre agencias do ITAU
			cLinha := "0" + StrZero(Val(cAge),4) + " 0000000" + Left(cCCta,5) + " " + Right(cCCta,1)
		Else
			cLinha := StrZero(Val(cAge),5) + " " + StrZero(Val(Left(cCCta,Len(cCCta)-1)),12) + " " + Right(cCCta,1)
		EndIf
	ELSE
		Alert("FALTA BANCO,CONTA,AGENCIA NO CADASTRO DE CONTAS A PAGAR OU FORNECEDOR, VERIFIQUE")
	ENDIF
Endif

Return( cLinha )

//------------------------------------
Static Function LimpaC(cCampo)
Local cLimpCpo := ""
Local nX
For nX := 1 To Len(cCampo)
	If SubStr(cCampo,nX,1) $ "0123456789"
		cLimpCpo += SubStr(cCampo,nX,1)
	EndIf
Next nX
Return(cLimpCpo)
