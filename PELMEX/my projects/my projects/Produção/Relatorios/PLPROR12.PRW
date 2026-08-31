#include "rwmake.ch"
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH" 


User Function Custopa2()
LOCAL mCMOD := 0  // 16/10/07
LOCAL mTMOD := 0  // 16/10/07


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CUSTOPA.PRG: EMISSAO DO CUSTO GERENCIAL DA PRODUCAO          ³
//³ DATA       : 10.12.96                                        ³
//³ AUTOR      : MICROSIGA/EMILIA                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo := "Emissao do Custo Gerencial da Producao"
cAbec1 := ""
cAbec2 := ""
cDesc1 := OemToAnsi("Este programa ir imprimir o Custo Gerencial da Producao")
cDesc2 := OemToAnsi("com os parametros solicitados pelo usuario.")
cDesc3 := OemToAnsi("")
cString  := "SB1"
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0
cPerg    :="EST001"
li       := 55
m_pag    := 1

GeraX1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Do Produto                            ³
//³ mv_par02            // Ate o Produto                         ³
//³ mv_par19            // Marcador                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Wnrel:=SetPrint(cString,"PELREC  ",cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,{})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("EST001",.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|| Corpo1() })
Return

Static Function Corpo1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Var.p/calcular acrescimos e descontos no valor do titulo     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local nTotCMarc := 0
Local nTotMarc  := 0
Local x:=0
Local nMarcador:= MV_PAR19
Local aItens   := {}
Local k := 0

aDriver := ReadDriver()
cCarac  := aDriver[aReturn[4]+2]
vPar    := {}

For x:=1 To 10
	cVar := "mv_par"+StrZero(x+8,2)
	If ! Empty( &cVar )
		AAdd(vPar,cVar)
	Endif
Next

lPega    := Empty(vPar)
nVezes   := If( lPega , 1, Len(vPar))
cSubGru  := If( lPega , "B1_SUBGRUP", "B1_COD")
nOrdem   := If( lPega , 8,  1)

For x:=1 To nVezes
	cVar     := "mv_par"+StrZero(x,2)
	cProdI   := If( lPega , mv_par01, &(vPar[x]))
	cProdF   := If( lPega , mv_par02, &(vPar[x]))
	
	dbSelectArea("SB1")
	dbSetOrder(nOrdem)
	dbSeek(xFilial("SB1")+cProdI,.T.)
	SetRegua(RecCount())
	While ! Eof() .And. &cSubGru <= cProdF .And. xFilial("SB1") == B1_FILIAL
		
		IncRegua()
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		lAchou := dbSeek(xFilial("SG1")+SB1->B1_COD)
		dbSelectArea("SB1")
		If ! lAchou
			dbSkip()
			Loop
		Endif
		
		mCod    := B1_COD
		mDesc   := B1_DESC
		cRecB1  := Recno()
		dbSelectArea("SG1")
		nTotGer := 0
		nRecno  := Recno()
		mCustot := 0
		
		/*
		While ! Eof() .And. G1_COD == mCod .And. xFilial("SG1") == G1_FILIAL
		dbSelectarea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+sg1->g1_comp)
		dbSelectArea("SG1")
		If SB1->B1_TIPO == "MO"
		dbSkip()
		Loop
		Endif
		mCustot := mCustot + (G1_QUANT * SB1->B1_CM1)
		dbskip()
		Enddo
		
		dbGoTo(nRecno)
		While ! Eof() .And. G1_COD == mCod .And. xFilial("SG1") == G1_FILIAL
		dbSelectarea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		dbSelectArea("SG1")
		If SB1->B1_TIPO == "MO"
		mTMOD := G1_QUANT
		mCMOD := SB1->B1_CM1
		dbSkip()
		Loop
		Endif
		nTotal := SB1->B1_CM1 * G1_QUANT
		
		If li >= 55
		IMPRTIT()
		Endif
		@ li,001 PSAY "| "+Left(G1_COMP,8)
		@ li,012 PSAY Left(SB1->B1_DESC,25)
		@ li,048 PSAY SB1->B1_UM
		@ li,054 PSAY G1_QUANT     Picture '99999.9999'
		@ li,066 PSAY SB1->B1_CM1  Picture "@E 9,999.9999"
		@ li,083 PSAY nTotal       Picture "@E 9,999.9999"
		@ li,102 PSAY (nTotal / mCustot) * 100 Picture "@E 999.99"
		@ li,110 PSAY "|"
		li:=li+1
		nTotger := ntotger + ntotal
		
		dbSkip()
		Enddo

		                           		
		*/
		
		aItens   := {}
		cOpcional:= MV_PAR20 + MV_PAR21 // "01 000001"            
		lMDO := .T. // MAO DE OBRA
		U_CalcCust( mCod, NIL, NIL, lMDO,cOpcional,@aItens  )
		
		/*
		aItens
		01-codigo
		02-descricao
		03-um
		04-cm1
		05-TIPO
		06-quant
		*/
		
		FOR k := 1 TO len(aItens)
		    IF aItens[K,5]<>"MO"
			   mCustot += (aItens[K,6] * aItens[K,4])
			ENDIF
		NEXT
		
		
		FOR k := 1 TO len(aItens)
			If aItens[K,5] == "MO"
				mTMOD := aItens[K,6]
				mCMOD := aItens[K,4]
			Else
				nTotal := aItens[K,4] * aItens[K,6]
				
				If li >= 55
					IMPRTIT()
				Endif
				@ li,001 PSAY "| "+Left(aItens[K,1],8)
				@ li,012 PSAY Left(aItens[K,2],25)
				@ li,048 PSAY aItens[K,3]
				@ li,054 PSAY aItens[K,6]     Picture '99999.9999'
				@ li,066 PSAY aItens[K,4]  Picture "@E 9,999.9999"
				@ li,083 PSAY nTotal       Picture "@E 9,999.9999"
				@ li,102 PSAY (nTotal / mCustot) * 100 Picture "@E 999.99"
				@ li,110 PSAY "|"
				li:=li+1
				nTotger := ntotger + ntotal
			
			Endif
			
		NEXT
		
		
		If nTotger <> 0
			@ li,001 PSAY "|"+Repli(" ",108)+"|"
			li:=li+1
			@ li,001 PSAY "| Total Materia-Prima............................: "
			@ li,083 PSAY nTotger Picture '@e 9,999.9999'
			@ li,110 PSAY "|"
			
			li:=li+1
			@ li,001 PSAY "| Marcador.......................................: "
			nTotCMarc := nTotger * nMarcador
			If nMarcador>0
				nTotMarc := nTotCMarc - nTotger
			EndIf
			@ li,083 PSAY nTotMarc Picture '@e 9,999.9999'
			@ li,110 PSAY "|"
			li:=li+1
			@ li,001 PSAY "| Total com Marcador.............................: "
			@ li,083 PSAY nTotCMarc Picture '@e 9,999.9999'
			@ li,110 PSAY "|"
			
			li:=li+1
			mCusMOD := mTMOD * mCMOD
			@ li,001 PSAY "|"+Repli(" ",108)+"|"
			li:=li+1
			@ li,001 PSAY "| Mao-de-Obra.........: "
			@ li,025 PSAY mTMOD    Picture "@E 9,99999"
			@ li,040 PSAY mCMOD    Picture "@E 9,999.9999"
			@ li,083 PSAY mCusMOD  Picture "@E 9,999.9999"
			@ li,110 PSAY "|"
			li:=li+1
			@ li,001 PSAY "|"+Repli(" ",108)+"|"
			li:=li+1
			mTotCIF := (mCusMOD * mv_par03) / 100
			@ li,001 PSAY "| Manutencao........:"
			@ li,025 PSAY mv_par03 Picture '@e 999.99'
			@ li,083 PSAY mTotCIF Picture '@e 9,999.9999'
			@ li,110 PSAY "|"
			li:=li+1
			@ li,001 PSAY "|"+Repli(" ",108)+"|"
			li:=li+1
			@ li,001 PSAY "| Custo de Producao..............................: "
			@ li,083 PSAY nTotger+nTotMarc+mCusMOD+mTotCIf Picture  '@e 9,999.9999'
			@ li,110 PSAY "|"
			li:=li+1
			@ li,001 PSAY "|"+Repli(" ",108)+"|"
			li:=li+1
			@ li,001 PSAY "| Preco Divisor 1 ..: "
			@ li,025 PSAY mv_par04 Picture '@e 999.999'
			@ li,083 PSAY (nTotger+mCusMOD+mTotCIf)/mv_par04  Picture '@e 9,999.9999'
			@ li,110 PSAY "|"
			li:=li+1
			@ li,001 PSAY "|"+Repli(" ",108)+"|"
			li:=li+1
			If mv_par05 <> 0
				@ li,01 PSAY "| Preco Divisor 2 ..: "
				@ li,25 PSAY mv_par05 Picture '@e 999.999'
				@ li,83 PSAY (nTotger+mCusMOD+mTotCIf)/mv_par05 Picture  '@e 9,999.9999'
				@ LI,110 PSAY "|"
				li:=li+1
			Endif
			If mv_par06 <> 0
				@ li,001 PSAY "|"+Repli(" ",108)+"|"
				li:=li+1
				@ li,01 PSAY "| Preco Divisor 3 ..: "
				@ li,25 PSAY mv_par06 Picture '@e 999.999'
				@ li,83 PSAY (nTotger+mCusMOD+mTotCIf)/mv_par06 Picture  '@e 9,999.9999'
				@ LI,110 PSAY "|"
				li:=li+1
			Endif
			If mv_par07 <> 0
				nValor := ((nTotger + mCusMOD + mTotCIf) / mv_par07) / mv_par08
				@ li,001 PSAY "|"+Repli(" ",108)+"|"
				li:=li+1
				@ li,01 PSAY "| Preco Divisor 4 ..: "
				@ li,25 PSAY mv_par07 Picture '@e 999.999'
				@ li,37 PSAY "Tx. Dolar: "+Transform(mv_par08,"@E 99.9999")
				@ li,83 PSAY nValor   Picture  '@e 9,999.9999'
				@ LI,110 PSAY "|"
				li:=li+1
			Endif
			@ li,01 PSAY "|"+repli("-",108)+"|"
			li:=li+1
			li:=56
		Endif
		dbSelectArea("SB1")
		dbGoto(cRecB1)
		dbSetOrder(nOrdem)
		dbSkip()
	Enddo
Next
@ li,000 PSAY ""

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return

Static FUNCTION ImprTit()
LI:=01
@ 00,000 PSAY &cCarac
@ LI,001 PSAY '+' + REPLI("-",108) +'+'
LI:=LI+1
@ li,001 PSAY "| "+SM0->M0_NOMECOM
@ li,045 PSAY "C U S T O   D E   P R O D U C A O"
@ li,092 PSAY 'Emissao:'+ dtoc(ddatabase)
@ LI,110 PSAY "|"
LI:=LI+1
@ li,001 PSAY "|"+Space(108)+"|"
li:=li+1
@ li,001 PSAY "|"
@ li,002 PSAY "Produto: " + mCod +  " - " + mDesc
@ li,110 PSAY "|"
li:=li+1
@ li,001 PSAY "|"+REPLI("-",108)+"|"
LI:=LI+1
@ LI,001 PSAY "| Codigo   | Descricao                        | Un | Quantidade |    Preco Unit. | Preco Total   | Percentual|"
//   xxxxxxxxxxxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxx   xx    99999999    999,999,999.99   999,999,999.99     99.99
//  12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
li:=li+1
@ li,001 PSAY "|"+repli("-",108)+"|"
li:=li+1
RETURN



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraX1   ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica as perguntas incluindo-as caso nao existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Uso Generico.                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
  0          1          2          3          4          5          6          7          8          9
0            X1_GRUPO   X1_ORDEM   X1_PERGUNT X1_PERSPA  X1_PERENG  X1_VARIAVL X1_TIPO    X1_TAMANHO X1_DECIMAL
1 X1_PRESEL  X1_GSC     X1_VALID   X1_VAR01   X1_DEF01   X1_DEFSPA1 X1_DEFENG1 X1_CNT01   X1_VAR02   X1_DEF02
2 X1_DEFSPA2 X1_DEFENG2 X1_CNT02   X1_VAR03   X1_DEF03   X1_DEFSPA3 X1_DEFENG3 X1_CNT03   X1_VAR04   X1_DEF04
3 X1_DEFSPA4 X1_DEFENG4 X1_CNT04   X1_VAR05   X1_DEF05   X1_DEFSPA5 X1_DEFENG5 X1_CNT05   X1_F3      X1_PYME
3 X1_GRPSXG  X1_HELP    X1_PICTURE X1_IDFIL
/*/

Static Function GeraX1()
Local aArea    := GetArea()
Local aRegs    := {}
Local i	     := 0
Local j        := 0
Local aHelpPor := {}
Local aHelpSpa := {}
Local aHelpEng := {}

    cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

AADD( aRegs, { cPerg, "01", "Do SubGrupo        ?","Do SubGrupo        ?","Do SubGrupo        ?","MV_CH1","C",04,00,00,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "02", "Ate o Subgrupo     ?","Ate o Subgrupo     ?","Ate o Subgrupo     ?","MV_CH2","C",04,00,00,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "03", "Manutencao         ?","Manutencao         ?","Manutencao         ?","MV_CH3","N",06,03,00,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "04", "Divisor 1          ?","Divisor 1          ?","Divisor 1          ?","MV_CH4","N",06,03,00,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "05", "Divisor 2          ?","Divisor 2          ?","Divisor 2          ?","MV_CH5","N",06,03,00,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "06", "Divisor 3          ?","Divisor 3          ?","Divisor 3          ?","MV_CH6","N",06,03,00,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "07", "Divisor 4          ?","Divisor 4          ?","Divisor 4          ?","MV_CH7","N",06,03,00,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "08", "Taxa do Dolar      ?","Taxa do Dolar      ?","Taxa do Dolar      ?","MV_CH8","N",06,04,00,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "09", "Produto 1          ?","Produto 1          ?","Produto 1          ?","MV_CH9","C",15,00,00,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "10", "Produto 2          ?","Produto 2          ?","Produto 2          ?","MV_CHA","C",15,00,00,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "11", "Produto 3          ?","Produto 3          ?","Produto 3          ?","MV_CHB","C",15,00,00,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "12", "Produto 4          ?","Produto 4          ?","Produto 4          ?","MV_CHC","C",15,00,00,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "13", "Produto 5          ?","Produto 5          ?","Produto 5          ?","MV_CHD","C",15,00,00,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "14", "Produto 6          ?","Produto 6          ?","Produto 6          ?","MV_CHE","C",15,00,00,"G","","MV_PAR14","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "15", "Produto 7          ?","Produto 7          ?","Produto 7          ?","MV_CHF","C",15,00,00,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "16", "Produto 8          ?","Produto 8          ?","Produto 8          ?","MV_CHG","C",15,00,00,"G","","MV_PAR16","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "17", "Produto 9          ?","Produto 9          ?","Produto 9          ?","MV_CHH","C",15,00,00,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "18", "Produto 10         ?","Produto 10         ?","Produto 10         ?","MV_CHI","C",15,00,00,"G","","MV_PAR18","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "19", "Marcador           ?","Marcador           ?","Marcador           ?","MV_CHJ","N",06,02,00,"G","","MV_PAR19","","","","","","","","","","","","","","","","","","","","","","","","","",   "", "","","","" } )
AADD( aRegs, { cPerg, "20", "Grupo de opcionais ?","Grupo de opcionais ?","Grupo de opcionais ?","MV_CHK","C",03,00,00,"G","","MV_PAR20","","","","","","","","","","","","","","","","","","","","","","","","","SGA","S","","","","" } )
AADD( aRegs, { cPerg, "21", "Item de opcionais  ?","Item de opcionais  ?","Item de opcionais  ?","MV_CHL","C",04,00,00,"G","","MV_PAR21","","","","","","","","","","","","","","","","","","","","","","","","","SGA","S","","","","" } )

dbSelectArea("SX1")
dbSetOrder(1)
For i:=1 to Len(aRegs)
    IF !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j := 1 to FCount()
            If j <= Len(aRegs[i])
               FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()

        aHelpPor := {} ; aHelpSpa := {} ; 	aHelpEng := {}

        IF i==1
			AADD(aHelpPor,"Filial que montou Inicial a ser           ")
			AADD(aHelpPor,"considerada na filtragem                  ")
        ELSEIF i==2
			AADD(aHelpPor,"Filial que montou Final a ser             ")
			AADD(aHelpPor,"considerada na filtragem                  ")
        ELSEIF i==3
			AADD(aHelpPor,"Data de Efetivação Inicial a ser          ")
			AADD(aHelpPor,"considerada na filtragem                  ")
        ELSEIF i==4
			AADD(aHelpPor,"Data de Efetivação Final a ser            ")
			AADD(aHelpPor,"considerada na filtragem                  ")
        ELSEIF i==20
			AADD(aHelpPor,"Grupo de opcionais que compõe o produto   ")
			AADD(aHelpPor,"                                          ")		
        ELSEIF i==21
			AADD(aHelpPor,"Itens de opcionais que compõe o produto   ")
			AADD(aHelpPor,"                                          ")		
        ENDIF
        PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
    ENDIF

Next

RestArea(aArea)
Return Nil
