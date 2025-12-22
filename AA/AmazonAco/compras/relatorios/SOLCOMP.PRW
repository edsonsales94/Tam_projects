#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/12/00

User Function Solcomp()        // incluido pelo assistente de conversao do AP5 IDE em 27/12/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,ARETURN,NLASTKEY")
SetPrvt("CSTRING,CPERG,LI,M_PAG,WNREL,NVES")
SetPrvt("LEND,CNOMSO,MEMISSAO,CGRUPO,MENDENT,MCIDENT")
SetPrvt("MESTENT,MCEPENT,MENDCOB,MCIDCOB,MESTCOB,MCEPCOB")
SetPrvt("CSOLICI,VOBS,NCL,NLI,NPOS,CMENS")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SOLCOM   ³ Autor ³ Emilia Reno           ³ Data ³ 16.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Solicitacao de Compra                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ OBS      ³ Programa Especifico da ARR                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private titulo   := "Solicitacao  de  Compra - B R A S F E R R O"
Private Cabec1   := "Item  Referencia       Descricao                                    UM      Quant."
Private Cabec2   := ""
Private cDesc3   := ""
//Private aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
Private aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "", 1}
Private Tamanho  := "P"
Private NomeProg := "SOLCOMP"  
Private aOrd := {}
Private nLastKey := 0            
Private limite   := 80
Private cString  := "SC7"
Private cPerg    := Padr("SOLCOMP   ",Len(SX1->X1_GRUPO))
Private li       := 80
Private m_pag    := 1
Private nTipo    := 18
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg508()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Da Solicitacao                                   ³
//³ mv_par02    Ate a Solicitacao                                ³
//³ mv_par03    Da Data                                          ³
//³ mv_par04    Ate a Data                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,"SOLCOMP   ",cPerg,@Titulo,Cabec1,Cabec2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Set Filter To
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Set Filter To
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| R140Imp()}, "Solicitacao de Compras")// Substituido pelo assistente de conversao do AP5 IDE em 27/12/00 ==>    RptStatus({|| Execute(R140Imp)}, "Solicitacao de Compras")
Return
Static Function R140Imp()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C140IMP  ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SOLCOM                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

For nVes:=1 To mv_par05

	dbSelectArea("SC1")
	SetRegua(RecCount())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pesquisa as Solicitacoes de Compra a serem impressas         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSetOrder(1)
	DBSeek (xFilial("SC1")+mv_par01,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia a Impressao                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	While !EOF() .And. C1_FILIAL==xFilial("SC1") .And. C1_NUM<=mv_par02
		If lEnd
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif
		IncRegua()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra a data de emissao e os itens a serem impressos        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If C1_EMISSAO < mv_par03 .Or. C1_EMISSAO > mv_par04
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+SC1->C1_FORNECE)
		dbSelectArea("SI3")
		dbSetOrder(1)
		dbSeek(xFilial("SI3")+SC1->C1_CC)
		dbSelectArea("SB1")
		dbSetOrder(1)
		cNomSo   := Left(SC1->C1_SOLICIT,10)
		mEmissao := SC1->C1_EMISSAO
		cGrupo   := SB1->B1_GRUPO
		mEndent  := SM0->M0_ENDENT
		mCident  := SM0->M0_CIDENT
		mEstent  := SM0->M0_ESTENT
		mCepent  := SM0->M0_CEPENT
		mEndcob  := SM0->M0_ENDCOB
		mCidcob  := SM0->M0_CIDCOB
		mEstcob  := SM0->M0_ESTCOB
		mCepcob  := SM0->M0_CEPCOB
		cSolici  := SC1->C1_NUM

		vObs     := {}
		li       := 56
		
		dbSelectarea("SC1")
		Do While !EOF() .and. cSolici == C1_NUM .and. xFilial("SC1") == C1_FILIAL

			If li > 55
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		    	  Li := 8        
		    	  @ li,001 Psay "Solicitação : "+cSolici+"/"+Str(Year(SC1->C1_EMISSAO),4);li:=li+2
			Endif

			SB1->(dbSeek(xFilial()+SC1->C1_PRODUTO))
			
			nTamDesc := 44
			cDescri := SB1->B1_DESC
			nLinha:= MLCount(Alltrim(cDescri),nTamDesc)
			
			@ li,001 PSAY Right(C1_ITEM,3)
			@ li,PCol()+1 PSAY Left(SB1->B1_REFEREN,15)
			@ li,PCol()+2 PSAY MemoLine(cDescri,nTamDesc,1)

			For nBegin := 2 To nLinha
			    li++
				@ li,022 PSAY Memoline(cDescri,nTamDesc,nBegin)
			Next

			@ li,pCol()+1 PSAY C1_UM
			@ li,pCol()+1 PSAY Transform(C1_QUANT,"@E 9,999,999.99")
//			@ li,pCol()+2 PSAY Dtoc(C1_DATPRF)
			li:=li+1
			
			If(C1_ITEM $ "0001,0002,0003,0004" .And. !Empty(C1_OBS) , AAdd( vObs , Alltrim(C1_OBS+C1_OBS2)), )
			
			dbSkip()
	
		Enddo
		nCl := 26
		nLi := 0
		nPos := 1
		Do While li <= 40
			cMens  := If( li <= (51 - Len(vObs))  .Or. nPos <> 1 , Space(11), "Observacao:")
			
			If li <= (51 - Len(vObs))
				@ li,nCl  PSAY "*"
				nCl:=nCl+1
			Else
				@ li,027 PSAY vObs[nPos]
				nPos := nPos + 1
			Endif
			li:=li+1
		Enddo
		
		li:=li+2
		@ li,001 PSAY "|---------------------------------------------------------------------|" ; li:=li+1
		@ li,001 PSAY "|IMPORTANTE                                                           |" ; li++
		@ li,001 PSAY "|                                                                     |" ; li++
		@ li,001 PSAY "|1. Prazo de validade desta solicitação : 15 dias da data de emissão, |" ; li++
		@ li,001 PSAY "|salvo se o Solicitante der aviso contrário, por escrito ao Comprador.|" ; li++
		@ li,001 PSAY "----------------------------------------------------------------------|" ; li:=li+1
		@ li,001 PSAY "|   EMITENTE      |     COTACAO       |           CHEFE               |" ; li:=li+1
		@ li,001 PSAY "|                 |                   |                               |" ; li:=li+1
		@ li,001 PSAY "|-----------------|-------------------|-------------------------------|" ; li:=li+1
		@ li,001 PSAY "| "+cNomSo+"      |                   |                               |" ; li:=li+1
		@ li,001 PSAY "|                 |                   |                               |" ; li:=li+1
		@ li,001 PSAY "|---------------------------------------------------------------------|"
		
	Enddo
	
Next

If aReturn[5] == 1
	dbCommitAll()
	Set Printer TO
	Commit
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/12/00 ==>  FUNCTION Impcab

Static Function ValidPerg508()
_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg :="SOLCOMP   "
aRegs :={}
aAdd(aRegs,{cPerg,"01","Da Solicitacao          ?", "" , "", "mv_ch1","C" ,06, 0 , 0 ,"G", "" , "MV_PAR01", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Solicitacao       ?", "" , "", "mv_ch2","C" ,06, 0 , 0 ,"G", "" , "MV_PAR02", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Da Data                 ?", "" , "", "mv_ch3","D" ,08, 0 , 0 ,"G", "" , "MV_PAR03", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Data              ?", "" , "", "mv_ch4","D" ,08, 0 , 0 ,"G", "" , "MV_PAR04", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Qtd Impressao           ?", "" , "", "mv_ch5","N" ,05, 0 , 0 ,"G", "" , "MV_PAR05", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return

