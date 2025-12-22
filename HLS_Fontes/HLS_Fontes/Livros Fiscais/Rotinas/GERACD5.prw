#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} GERACD5

Gera a CD5 com os dados da SF1 e SD1.

@type function
@author Honda Lock
@since 01/10/2017

/*/

User Function GERACD5()
                                         
Local aAlias    := GetArea()
Local aAreaSF1	:= SF1->(GetArea())
Local aAreaCD5	:= CD5->(GetArea())

Local dDatIni
Local dDatFim
Local cPerg		:=	"GERACD5"

Private nRegs

ValidPerg(cPerg)

If Pergunte(cPerg, .t.)
	dDatIni	:=	mv_par01
	dDatFim	:=	mv_par02
Else
	lProcessar	:=	.f.
EndIf

nRegs:=QrySF1(dDatIni, dDatFim)

If nRegs >= 0
	InsCD5()
EndIf

TSF1->(DbCloseArea())

RestArea(aAreaSF1)
RestArea(aAreaCD5)
RestArea(aAlias)
Return

Static Function InsCD5()
Local nInc 		:= 0
Local nBasePis 	:= 0
Local nAlqPis	:= GetMv("MV_TXPIS")
Local nValPis 	:= 0
Local nBaseCof 	:= 0
Local nAlqCof	:= GetMv("MV_TXCOFIN")
Local nValCof 	:= 0 


While TSF1->(!EOF())
	DbSelectArea("CD5")
	CD5->(DbSetOrder(1))
	If CD5->(DbSeek(xFilial("CD5")+TSF1->D1_DOC+TSF1->D1_SERIE+TSF1->D1_ITEM))
		Alert("CD5 para a nota " + AllTrim(TSF1->D1_DOC)+ " - " + AllTrim(TSF1->D1_SERIE) + " já existe.")
	Else
		If RecLock("CD5", .T.)
		   nInc:= nInc+1
			
		   CD5->CD5_FILIAL := xFilial("CD5")
		   CD5->CD5_DOC    := TSF1->D1_DOC
           CD5->CD5_SERIE  := TSF1->D1_SERIE
           CD5->CD5_ITEM   := TSF1->D1_ITEM
           CD5->CD5_ESPEC  := "SPED"
           CD5->CD5_FORNEC := TSF1->D1_FORNECE
           CD5->CD5_LOJA   := TSF1->D1_LOJA
           CD5->CD5_ITEM   := TSF1->D1_ITEM
           CD5->CD5_TPIMP  := "0"                                            
           CD5->CD5_DOCIMP := TSF1->D1_DOC
           CD5->CD5_BSPIS  := TSF1->D1_BASIMP6
           CD5->CD5_ALPIS  := TSF1->D1_ALQIMP6
           CD5->CD5_VLPIS  := TSF1->D1_VALIMP6
           CD5->CD5_BSCOF  := TSF1->D1_BASIMP5
           CD5->CD5_ALCOF  := TSF1->D1_ALQIMP5
           CD5->CD5_VLCOF  := TSF1->D1_VALIMP5
           CD5->CD5_NDI    := TSF1->F1_ZZDI
           CD5->CD5_DTDI   := SToD(TSF1->F1_ZZDTDI)
           CD5->CD5_LOCDES := "SANTOS"
           CD5->CD5_UFDES  := "SP"
           CD5->CD5_DTDES  := SToD(TSF1->F1_ZZDTDI)
           CD5->CD5_CODEXP := TSF1->D1_FORNECE
           CD5->CD5_NADIC  := TSF1->D1_ZZADIC
           CD5->CD5_SQADIC := TSF1->D1_ZZSEQAD  
           CD5->CD5_VTRANS := "1"
           CD5->CD5_INTERM := "1"
           CD5->CD5_CNPJAE := "08735007000244"
           CD5->CD5_UFTERC := "SP" 
           CD5->CD5_LOJFAB := TSF1->D1_LOJA   
           CD5->CD5_CODFAB := TSF1->D1_FORNECE
           CD5->CD5_DTDES   := SToD(TSF1->F1_ZZDTDI)   
           CD5->CD5_LOCAL := "0"
		  
   		   
           
           CD5->(MsUnlock())			
		EndIf
	EndIf
	TSF1->(DbSkip())
EndDo

MsgInfo("Incluídos "+ STR(nInc)+ " registros no CD5.")

Return

Static Function QrySF1(dDatIni, dDatFim)
Local cQuery := ""

cQuery	:=	"Select "
cQuery  +=  "SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_ITEM ,SD1.D1_BASIMP6, SD1.D1_ALQIMP6, SD1.D1_VALIMP6, "
cQuery  +=  "SD1.D1_BASIMP5, SD1.D1_ALQIMP5, SD1.D1_VALIMP5,  SD1.D1_FORNECE, "
cQuery  +=  "SD1.D1_ZZADIC, SD1.D1_ZZSEQAD, SD1.D1_ITEM, SF1.F1_ZZDI, SF1.F1_ZZDTDI "
cQuery	+=	"From " + RetSQLName("SF1") + " SF1 "
cQuery  +=  "JOIN " + RetSqlName("SD1") + " SD1 ON SD1.D_E_L_E_T_ <> '*' AND SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND " 
cQuery  +=  "SD1.D1_SERIE = SF1.F1_SERIE AND SD1.D1_DOC = SF1.F1_DOC "
cQuery	+=	"WHERE "
cQuery	+=	"SF1.F1_FILIAL = '"	+xFilial("SF1")+"' AND "
//cQuery	+=	"SF1.F1_EMISSAO Between '" + dToS(dDatIni) + "' And '" + dToS(dDatFim) + "' And  "
cQuery	+=	"SF1.F1_DOC Between '" + MV_PAR01 + "' And '" + MV_PAR02 + "' And  "
cQuery	+=	"SD1.D1_CF >= '3101'  And "
cQuery	+=	"SF1.D_E_L_E_T_  = ' '"

TcQuery ChangeQuery(cQuery) New Alias "TSF1"

Count to nRegs
TSF1->(DbGoTop())

If nRegs == 0
	Alert ("Não existe nota para o período informado")
EndIf

Return nRegs

//***************************************************************************************
&& -- ROTINA: Cria pergunta automaticamente caso nao exista
//***************************************************************************************
Static Function ValidPerg(cPerg)

Local sAlias 	:= Alias()
Local aRegs 	:= {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
/*aAdd(aRegs,{cPerg,"01","Data de:","Data de:","Data de:" ,"MV_CH1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Até:","Data Até:","Data Até:","MV_CH2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
*/
aAdd(aRegs,{cPerg,"01","Data de:","Data de:","Data de:" ,"MV_CH1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Até:","Data Até:","Data Até:","MV_CH2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
For i := 1 to Len(aRegs)
	If !dbSeek (cPerg + aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(sAlias)
Return()