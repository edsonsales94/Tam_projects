#include "rwmake.ch"
#include "Protheus.ch"
//
//  .-----------------------------------------------------------------------------------------------------------------------.
// |     Programa     |     AAENTR01     |     Autor     |     Wagner da Gama Correa     |     Data     |     22/01/2011     |
// |-------------------------------------------------------------------------------------------------------------------------|
// |     Descricao    |     Impressao do Romaneio de Saida                                                                   |
//  '-----------------------------------------------------------------------------------------------------------------------'
//
User Function AAENTR01(lAuto)

Default lAuto := .F.

Private titulo     := "Romaneio de Entrega"
Private Cabec1     := ""
Private Cabec2     := ""
Private cDesc3     := ""
Private aReturn    := { "Zebrado", 1,"Administracao", 2, 2, 1, "", 1}
Private Tamanho    := "M"
Private NomeProg   := "AAENTR01"
Private aOrd       := {}
Private nLastKey   := 0
Private limite     := 132
Private cString    := "SZE"
Private cPerg      := Padr("AAENTR01",Len(SX1->X1_GRUPO))
Private _nLin      := 80
Private m_pag      := 1
Private nTipo      := 18
Private p_negrit_l := "E"
Private p_reset    := "@"
Private p_negrit_d := "F"

ValidPerg()
Pergunte(cPerg,.F.)

If lAuto
	mv_par01 := SZE->ZE_ROMAN
	mv_par02 := SZE->ZE_ROMAN
	mv_par03 := 1
EndIf
//  .-----------------------------------------
// |     Variaveis utilizadas para parametros
// |     mv_par01    Do romaneio
// |     mv_par02    Ate o Romaneio
// |     mv_par03    Quantidade de Impressoes
//  '-----------------------------------------
wnrel := SetPrint(cString,"AAENTR01",IIF(lAuto,,cPerg),@Titulo,Cabec1,Cabec2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

RptStatus({|| ENTR01Rep()}, "Romaneio de Entrega")
Return
//  .--------------------------------------------------------------------
// |     Repete a impressão de acordo com o número informado no parâmetro
//  '--------------------------------------------------------------------
Static Function ENTR01Rep

SetRegua( mv_par03 )

For _nVezes := 1 To mv_par03
	ENTR01Imp()
Next

//  .-----------------------------.
// |     Impressao do Romaneio     |
//  '-----------------------------'
Static Function ENTR01Imp

//dbSelectArea("SZE")
//dbSetOrder(1)
//dbSeek( xFilial() + mv_par01,.T.)  
 Local cQry := ''
 Local cTable := GetNextALias()

 cQry = " SELECT ZE_ROMAN, ZE_DOC, ZE_SERIE,ZE_MOTOR, ZE_NOMOTOR, ZE_PLACA, ZE_ORCAMEN, ZE_BAIRRO, SUM(ZE_VALOR * ZE_QTDORIG)'TOTAL' FROM "+retsqlname("SZE")
 cQry += " WHERE ZE_ROMAN BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "      
 cQry += " GROUP BY ZE_ROMAN, ZE_DOC, ZE_SERIE,ZE_MOTOR, ZE_NOMOTOR, ZE_PLACA, ZE_ORCAMEN, ZE_BAIRRO "
 cQry += " ORDER BY ZE_ROMAN, ZE_BAIRRO, ZE_DOC, ZE_SERIE "

 dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),cTable,.T.,.T.)

While !Eof() .and. ZE_FILIAL+(cTable)->ZE_ROMAN <= xFilial()+mv_par02
	                                            
	
	_cRoman := (cTable)->ZE_ROMAN
	
	nTotRec   := 0
    _nLin     := 56
	lRodape   := .F.
	nTotItens := 0
    	
	While !Eof() .and. (cTable)->ZE_FILIAL+(cTable)->ZE_ROMAN == xFilial("SZE")+_cRoman
		
		If lEnd
			@ PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		If EMPTY((cTable)->ZE_ROMAN)
		    dbSkip()
		    Loop
		Endif 
		
		IncRegua()
		
		
		If _nLin > 55
			Cabecalho()
		Endif
		
		SL1->(DbSeek(xFilial("SL1")+(cTable)->ZE_ORCAMEN))
		
		If SL1->L1_RECLOC == "S"    // Verifica se a Venda é para Receber no Local
			nTotRec += (cTable)->ZE_VALOR
		EndIf
		
		cStatus := ""
		Do Case
			Case (cTable)->ZE_STATUS == "E"
				cStatus := "Entregue"
			Case (cTable)->ZE_STATUS == "N"
				cStatus := "End. não E"
			Case (cTable)->ZE_STATUS == "F"
				cStatus := "Loc.Fechad"
			Case (cTable)->ZE_STATUS == "V"
				cStatus := "Nova Entre"
			Case (cTable)->ZE_STATUS == "C"
				cStatus := "Vem Buscar"
			Case (cTable)->ZE_STATUS == "D"
				cStatus := "Devolução"
		EndCase
		
		@ _nLin, 000      PSAY (cTable)->ZE_ORCAMEN+Iif(SL1->L1_RECLOC == "S","*"," ")
		@ _nLin, 009      PSAY (cTable)->ZE_DOC+"/"+(cTable)->ZE_SERIE
		@ _nLin, 024      PSAY (cTable)->ZE_BAIRRO
		
		If (cTable)->ZE_STATUS == "R"
			@ _nLin, 040  PSAY "_______________________________"
			@ _nLin, 071  PSAY " ____/____/_____"
			@ _nLin, 089  PSAY " _____:_____"
			_nLin+=2
		Endif  
		
//_nLin,001 PSAY "Orc/Ped  Documento      Bairro          Nome                           Data     Hora";   _nLin++
//                123456   1234567890-123 123456789012345 123456789012345678901234567890 99/99/99 99:99
//                0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111
//                0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333
//                0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

		
		
		nTotItens++
		_nLin++
		
		lRodape := .T.
		
		dbSelectArea("SZE")
		dbSkip()
	End
	
	If lRodape
		
		_nLin++
		@ _nLin, 001 PSAY "* VALOR DE RECEBER NO LOCAL "+Transform(nTotRec,"@E 999,999,999,999.99"); _nLin += 2
		
		@ _nLin, 001 PSAY " ITENS DO ROMANEIO          "+Str(nTotItens)
		
		_nLin += 3
		
		If _nLin > 55
			Cabecalho()
		Endif
		
		_nLin += 2
		
		@ _nLin, 001 PSAY "ASS. MOTORISTA     : ______________________________   ____/____/_____  _____:____ "; _nLin += 3
		@ _nLin, 001 PSAY "ASS. ADMINISTRAÇÃO : ______________________________   ____/____/_____  _____:____ "; _nLin += 3
		
		@ _nLin, 001 PSAY "LEGENDA DO RETORNO :";_nLin++
		@ _nLin, 001 PSAY "V = nova entrega; N = endereco nao encontrado; F = local Fechado; D = Devolucao "
		
		
	EndIf
	
Enddo


If aReturn[5] == 1
	dbCommitAll()
	Set Printer TO
	Commit
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return
//  .------------------------------------------------.
// |     Inclui grupo de perguntas no arquivo SX1     |
//  '------------------------------------------------'
Static Function ValidPerg()
_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)

cPerg :="IMP_ROMA  "
aRegs :={}
aAdd(aRegs,{cPerg,"01","Do Romaneio          ?", "" , "", "mv_ch1","C" ,06, 0 , 0 ,"G", "" , "MV_PAR01", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate o Romaneio       ?", "" , "", "mv_ch2","C" ,06, 0 , 0 ,"G", "" , "MV_PAR02", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Qtd Impressao        ?", "" , "", "mv_ch3","N" ,05, 0 , 0 ,"G", "" , "MV_PAR03", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})

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
//  .------------------------------------------.
// |     Impressao do Cabecalho do Romaneio     |
//  '------------------------------------------'
Static Function Cabecalho()

_nLin := 01
@ _nLin,000 PSAY Chr(15)+" "

@ _nLin,001 PSAY PADC(SM0->M0_NOMECOM,120); _nLin++
@ _nLin,001 PSAY PADC("ROMANEIO DE ENTREGA"+"       Data Impressao :" +DTOC(dDatabase)+" - "+Time(),120); _nLin++
@ _nLin,001 PSAY Replicate("-",120); _nLin += 2

@ _nLin,01 PSAY "R O M A N E I O : 		"+(cTable)->ZE_ROMAN;   _nLin++

@ _nLin,001 PSAY "Motorista: " + (cTable)->ZE_MOTOR + "-" + (cTable)->ZE_NOMOTOR
@ _nLin,060 PSAY "Placa  : " + substr((cTable)->ZE_PLACA,1,3)+"-"+substr((cTable)->ZE_PLACA,4,4);   _nLin++
@ _nLin,001 PSAY Replicate("-",120);   _nLin++
@ _nLin,001 PSAY "Orc/Ped  Documento      Bairro          Nome                                 Data            Hora";   _nLin++
//                123456   1234567890-123 123456789012345 123456789012345678901234567890     99/99/99          99:99
//                0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111
//                0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333
//                0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
@ _nLin++,01 PSAY Replicate("-",120);   _nLin += 2

Return