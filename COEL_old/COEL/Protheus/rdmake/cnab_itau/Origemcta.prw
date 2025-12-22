#Include "RwMake.Ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ OrigemCta³ Autor ³ LARSSON               ³ Data ³ 08/08/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ExecBlock disparado do 341EXX.PAG para retornar agencia,   ³±±
±±³          ³ conta e digito de ORIGEM(PAGADORA).                        ³±±                  @
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄRÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNAB SISPAG                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function Origemcta()
Local cLinha := ""
Local cAge   := LimpaC(SEE->EE_AGENCIA)  //Posição 053 a 057  
Local cCCta  := LimpaC(SEE->EE_CONTA)    //Posição 059 a 070 + 072 a 072

If SEE->EE_DVCTA <> " "   //Preenchido
      cLinha := "0" + StrZero(Val(cAge),4) + " 0000000" + Left(cCCta,5) + " " + SEE->EE_DVCTA  //EE_CONTA="79712" + EE_DVCTA="2"      	
  Else
	  cLinha := "0" + StrZero(Val(cAge),4) + " 0000000" + Left(cCCta,5) + " " + Right(cCCta,1) //EE_CONTA="52548-0" OU "525480"
EndIf

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