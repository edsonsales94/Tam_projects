#include "rwmake.ch"
#include "Protheus.ch"

User Function Imp_Roma(lAuto)

Default lAuto := .F.
//SetConfigurePrinter(.T.)
//Lj010InitPrint("O")

Private titulo   := "Romaneio de Entrega "
Private Cabec1   := "Orçamento  Documento    Nome                                 Data       Hora"
Private Cabec2   := ""
Private cDesc3   := ""
Private aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "", 1}
Private Tamanho  := "P"
Private NomeProg := "IMP_ROMA"
Private aOrd := {}
Private nLastKey := 0
Private limite   := 80
Private cString  := "SZE"
Private cPerg    := Padr("IMP_ROMA  ",Len(SX1->X1_GRUPO))
Private li       := 80
Private m_pag    := 1
Private nTipo    := 18
Private p_negrit_l := "E"
Private p_reset    := "@"
Private p_negrit_d := "F"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()
pergunte(cPerg,.F.)

if lAuto
  mv_par01 := SZE->ZE_ROMAN
  mv_par02 := SZE->ZE_ROMAN
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Da Solicitacao                                   ³
//³ mv_par02    Ate a Solicitacao                                ³
//³ mv_par03    Da Data                                          ³
//³ mv_par04    Ate a Data                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if !lauto
   wnrel := SetPrint(cString,"IMP_ROMA  ",cPerg,@Titulo,Cabec1,Cabec2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
else
   wnrel := SetPrint(cString,"IMP_ROMA  ",     ,@Titulo,Cabec1,Cabec2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
EndIf

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

RptStatus({|| R140Imp()}, "Romaneio de Entrega")// Substituido pelo assistente de conversao do AP5 IDE em 27/12/00 ==>    RptStatus({|| Execute(R140Imp)}, "Solicitacao de Compras")
Return

Static Function R140Imp()
mv_par03 := iIf(mv_par03 == 0,1,mv_par03)
For nVes:=1 To mv_par03
	
	dbSelectArea("SL1")
	dbSetOrder(1)
	
	dbSelectArea("SZE")
	SetRegua(RecCount())
	
	dbSetOrder(1)  // Filial+Romaneio+Orçamento

	SZE->(DbSeek(xFilial("SZE")+mv_par01,.T.))
	
	While !EOF() .And. SZE->ZE_FILIAL==xFilial("SZE") .And. SZE->ZE_ROMAN <= MV_PAR02
		
		If lEnd
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		IncRegua()
		
		cRomaneio:= SZE->ZE_ROMAN
		nTotRec  := 0
		li       := 56
		lRodape  := .F.
		nTotItens:= 0
		
		Do While !EOF() .and. cRomaneio == SZE->ZE_ROMAN .and. xFilial("SZE") == SZE->ZE_FILIAL
			
			If ! Empty(SZE->ZE_ROMAN)
				
				If MV_PAR04 == 1    // Romaneio
					lImprime := SZE->ZE_STATUS $ 'R#P'
				Else
					lImprime := .T.
				EndIf
				
				If lImprime
					
					If li > 55
						Cabecalho()
					Endif
					
					SL1->(DbSeek(xFilial("SL1")+SZE->ZE_ORCAMEN))
					
					If SL1->L1_RECLOC == "S"    // Verifica se a Venda é para Receber no Local
						nTotRec += SZE->ZE_VALOR
					EndIf
					
					cStatus := ""
					Do Case
						Case SZE->ZE_STATUS == "E"
							cStatus := "Entregue"
						Case SZE->ZE_STATUS == "N"
							cStatus := "End. não E"
						Case SZE->ZE_STATUS == "F"
							cStatus := "Loc.Fechad"
						Case SZE->ZE_STATUS == "V"
							cStatus := "Nova Entre"
						Case SZE->ZE_STATUS == "B"
							cStatus := "Vem Buscar"
						Case SZE->ZE_STATUS == "D"
							cStatus := "Devolução"
						Case SZE->ZE_STATUS == "S"
							cStatus := "Estorno" 
						Case SZE->ZE_STATUS == "P"
							cStatus := "PRE- ROMANEIO"	
					EndCase
					
					@ li,001 PSAY SZE->ZE_ORCAMEN+Iif(SL1->L1_RECLOC == "S","*"," ")
					@ li,PCol()+1 PSAY SZE->ZE_DOC+"/"+SZE->ZE_SERIE
					@ li,PCol()+1 PSAY SZE->ZE_BAIRRO

					If SZE->ZE_STATUS == "R"
						@ li,PCol()+1 PSAY IIf(MV_PAR04 == 1,"___________________________________________",SZE->ZE_NOMREC)
						@ li,PCol()+2 PSAY IIf(MV_PAR04 == 1,"____/____/_____",SZE->ZE_DTREC)
						@ li,PCol()+2 PSAY IIf(MV_PAR04 == 1,"_____:_____",SZE->ZE_HORREC)
						@ li,PCol()+2 PSAY SZE->ZE_NOMCLI
					Elseif SZE->ZE_STATUS == "P"
					    @ li,pCol()+2 PSay "P R E - R O M A N E I O - P R E - R O M A N E I O - P R E - R O M A N E I O "                                                                                          
				    Endif
	
					If MV_PAR04 == 2   // Todos
						@ li,PCol()+1 PSAY cStatus
					Endif
					
					nTotItens++
					li:=li+1
					
					lRodape := .T.
					
				EndIf
				
			EndIf
			
			SZE->(dbSkip())
			
		EndDo
		
		If lRodape
			
			li++
			@ li, 001 PSAY "* VALOR DE RECEBER NO LOCAL "+Transform(nTotRec,"@E 999,999,999,999.99");li+=2
			
			@ li, 001 PSAY " ITENS DO ROMANEIO          "+Str(nTotItens)
			
			li+=3
			
			If li > 55
				Cabecalho()
			Endif
			
			If MV_PAR04 == 2 // Todos
				@ li,01 PSay PADC("T O D O S  - T O D O S  - T O D O S  - T O D O S  - T O D O S  ",120) 
			EndIf
			
			li+=2
			
			@ li, 001 PSAY "ASS. MOTORISTA     : ______________________________   ____/____/_____  _____:____ ";li+=3
			@ li, 001 PSAY "ASS. ADMINISTRAÇÃO : ______________________________   ____/____/_____  _____:____ ";li+=2
			
			@ li, 001 PSAY "LEGENDA DO RETORNO :";li++
			@ li, 001 PSAY "V = noVa entrega; N = endereco Nao encontrado; F = local Fechado; D = Devolucao "


		EndIf
		
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

Static Function ValidPerg()
_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg :="IMP_ROMA  "
aRegs :={}
aAdd(aRegs,{cPerg,"01","Do Romaneio          ?", "" , "", "mv_ch1","C" ,06, 0 , 0 ,"G", "" , "MV_PAR01", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate o Romaneio       ?", "" , "", "mv_ch2","C" ,06, 0 , 0 ,"G", "" , "MV_PAR02", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Qtd Impressao        ?", "" , "", "mv_ch3","N" ,05, 0 , 0 ,"G", "" , "MV_PAR03", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Status               ?", "" , "", "mv_ch4","N" ,01, 0 , 0 ,"C", "" , "MV_PAR04", "Romaneio", "", "", "","","Todos      ","","","","","","","","","","","","","","","","",""," ","",""})
//aAdd(aRegs,{cPerg,"05","Do Motorista         ?", "" , "", "mv_ch5","C" ,06, 0 , 0 ,"G", "" , "MV_PAR05", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"06","Ate o Motorista      ?", "" , "", "mv_ch6","C" ,06, 0 , 0 ,"G", "" , "MV_PAR06", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})

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


Static Function Cabecalho()

li:=01
@ li,000 PSay Chr(15)+" "

@ li,001 PSay PADC(SM0->M0_NOMECOM,120); li := li + 1
@ li,001 PSay PADC("ROMANEIO DE ENTREGA"+"       Data Impressao :" +DTOC(dDatabase)+" - "+Time(),120); li := li + 1
@ li,001 PSay Replicate("-",120)

li+=2
If SZE->ZE_STATUS == "P"
//	@ li,01 PSay Chr(18)+Chr(14)+ p_negrit_l + "PRÉ-Romaneio: 		"+SZE->ZE_ROMAN + p_negrit_d+p_reset+Chr(15)+Chr(15)
	@ li,01 PSay "P R E  -  R o m a n e i  o : 		"+SZE->ZE_ROMAN 
Else
//	@ li,01 PSay Chr(18)+Chr(14)+ p_negrit_l + "ROMANEIO: 		"+SZE->ZE_ROMAN + p_negrit_d+p_reset+Chr(15)+Chr(15)
	@ li,01 PSay "R O M A N E I O : 		"+SZE->ZE_ROMAN 
EndIf 
li++

@ li,001 PSay "Motorista: "+SZE->ZE_MOTOR+"-"+SZE->ZE_NOMOTOR
@ li,060 PSay "Placa  : "+SZE->ZE_PLACA
li := li + 2
@ li,01 PSay Replicate("-",120); li := li + 1
@ li,01 PSay "Orcamento  Documento    Bairro               Nome                                      Data           Hora         Cliente"
//            1         2         3         4         5         6         7         8         9        10        11        12
//            123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
li := li + 1
@ li,01 Psay Replicate("-",120)
li := li + 2

Return
