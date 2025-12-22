
/*/{Protheus.doc} AltDatPri

Altera a data de previsao de inicio a OP.

@type function
@author Rodrigo de A. Sartorio
@since 22/08/97

@return Logico, Validação de campo.
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A650DatPri  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 22/08/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Alterado para nao permitir datas no final de semana          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HONDA LOCK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AltDatPri(cCpoDatPri,dDatPri,cProd,nQuant,lReferencia)

Local lRet := .T.,nEndereco:=0
Local nPrazo

cCpoDatPri:= ReadVar()
If cCpoDatPri=="M->C2_DATPRI"
   dDatpri   := M->C2_DATPRI
Else
   dDatpri   := M->C2_DATPRF
EndIf   
cProd     := M->C2_PRODUTO
nQuant    := M->C2_QUANT

nPrazo := CalcPrazo(cProd,nQuant)
lReferencia := If(lReferencia == NIL, .F., lReferencia)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a rotina esta sendo chamada da Proj.Estoques NOVA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lProj711:=If(Type("lProj711") == "L",lProj711,.F.)

If cCpoDatpri == "M->C2_DATPRI"
	If !Empty(nPrazo)
		// Valida Data
		If  !Empty(M->C2_DATPRF)
		    If !DataValida(M->C2_DATPRF)
		       M->C2_DATPRF:=M->C2_DATPRF-1
		       If !DataValida(M->C2_DATPRF)
		          M->C2_DATPRF:=M->C2_DATPRF-1
		       EndIf
            EndIf
        EndIf    		       
		If	!Empty(M->C2_DATPRF) .And. (M->C2_DATPRF - dDatPri) < nPrazo
			// Nao apresenta o help qdo chamado do MRP
			If !lProj711 .and. !l650Auto
				Help(" ",1,"A650AJUSTD")
			EndIf
			If mv_par01 == 1 // Valida pela data Final
				M->C2_DATPRI:= SomaPrazo(M->C2_DATPRF, - nPrazo)
			Else	// Valida pela data Inicial
				M->C2_DATPRF:= SomaPrazo(dDatPri, nPrazo)
			EndIf
			// Valida Data prevista p/ fim com a DataBase do sistema
			If M->C2_DATPRF < dDataBase
				M->C2_DATPRF:= SomaPrazo(dDataBase, nPrazo)
			EndIf
			If !lReferencia
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,9) == "C2_DATPRI" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := DTOC(M->C2_DATPRI)
				EndIf
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,9) == "C2_DATPRF" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := DTOC(M->C2_DATPRF)
				EndIf
			EndIf
			// Inicializa Data
		ElseIf Empty(M->C2_DATPRF)
			M->C2_DATPRF:= SomaPrazo(dDatPri, nPrazo)
			// Valida Data prevista p/ fim com a DataBase do sistema
			If M->C2_DATPRF < dDataBase
				M->C2_DATPRF:= SomaPrazo(dDataBase, nPrazo)
			EndIf
			If !lReferencia
				nEndereco := Ascan(aGets,{ |x| Subs(x,9,9) == "C2_DATPRF" } )
				If nEndereco > 0
					aTela[Val(Subs(aGets[nEndereco],1,2))][Val(Subs(aGets[nEndereco],3,1))*2] := DTOC(M->C2_DATPRF)
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
RETURN lRet