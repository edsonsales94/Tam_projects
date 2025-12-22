#include "rwmake.ch"

User Function RFATR01()

SetPrvt("Tamanho,Limite,cDesc1,cDesc2,cDesc3,Titulo")
SetPrvt("aReturn,NomeProg,cPerg,nLastKey,_nLi")
SetPrvt("wnRel,Cabec1,Cabec2,cCancel,m_Pag,cBCont,cBTxt,cString")
SetPrvt("_cFiltro, aRegs, I, J, _lInicio")
SetPrvt("_dDtDigit,_cDoc,_cSerie,_cFilial,_cTesFin,_cTipoPro,_cGrupoPro")
SetPrvt("_nVN101M, _nVN102M, _nVN103M, _nVN104M")
SetPrvt("_nVN101F, _nVN102F, _nVN103F, _nVN104F")
SetPrvt("_nTN101M, _nTN102M, _nTN103M, _nTN104M")
SetPrvt("_nTN101F, _nTN102F, _nTN103F, _nTN104F")
SetPrvt("_nTotDiaM, _nTotDiaF, _nTotDiaG")
SetPrvt("_nTotDM  , _nTotDF  , _nTotDG   , _nTot101, _nTot102, _nTot103, _nTot104")

/*/
_____________________________________________________________________________
|           |                                                                 |
| Cliente   | Coel                                                     |
|___________|_________________________________________________________________|
|           |         |       |                           |      |            |
| Programa  | RFATR01 | Autor | Rogerio Batista           | Data |            |
|___________|_________|_______|___________________________|______|____________|
|           |                                                                 |
| Descricao | Relatorio das Faturamento excluido                              |
|___________|_________________________________________________________________|
/*/

Tamanho    := "M"
limite     := 132
cDesc1     := PADC("Este programa ira emitir um resumo das Saidas excluidas    ",74)
cDesc2     := ""
cDesc3     := ""
aReturn    := {"Zebrado",1,"Administracao",2,2,1,"",1} // Formulario,N.vias,Destinatario,Formato,Midia,Porta,Filtro,Ordem
nomeprog   := "RFATR01"
wnrel      := "RFATR01"
cPerg      := "FATR01"
nLastKey   := 0
_nLi       := 0

//  ____________________________________________________________________________
// |                                                                            |
// |                         Variaveis do Cabecalho                             |
// |____________________________________________________________________________|
//
//                     1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec1    :="Emissao      Pedido       Cod.Cliente                                            Vlr.Total "
cabec2    := ""
//
_cTraco   :="----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
m_pag     := 1     //Variavel que acumula numero da pagina
//  ____________________________________________________________________________
// |                                                                            |
// |                          Variaveis do Rodape                               |
// |____________________________________________________________________________|
//
cbCont := 0
cbTxt  := ""
//  ____________________________________________________________________________
// |                                                                            |
// |            Verifica as Perguntas Selecionadas no SX1                       |
// |____________________________________________________________________________|
//
//ValidPerg()
Pergunte(cPerg,.F.)               // Pergunta no SX1
cString:="SC5"
//  ____________________________________________________________________________
// |                                                                            |
// |                Envia controle para a funcao SETPRINT                       |
// |____________________________________________________________________________|

Titulo := "Pedidos de Vendas"
wnrel  := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

cString:="TSC5"
Processa ({|| Calculo() })

Roda(CbCont,CbTxt,Tamanho)

dbcommitAll()
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Ourspool(wnrel)
Endif

MS_FLUSH()

dbSelectArea("TSC5")
dbCloseArea()

Return

Static Function Calculo()

dbSelectArea("SC5")

_cQuery := ""
_cQuery := _cQuery + " SELECT * FROM "
_cQuery := _cQuery + RetSQLName("SC5")
_cQuery := _cQuery + " WHERE "
_cQuery := _cQuery + " C5_EMISSAO  BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' AND "
_cQuery := _cQuery + " D_E_L_E_T_  = '*' "
_cQuery := _cQuery + " ORDER BY C5_EMISSAO "

_cQuery := ChangeQuery(_cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"TSC5", .F., .T.)

IncProc("Imprimindo aguarde...")

ProcRegua(LastRec())

_cFiltro  :=""
_cFiltro  := IIf(Empty(aReturn[7]),"",aReturn[7])

_nLi      := 80
_cNaturez := Space(10)
_dDtDigit := Ctod("  /  /  ")
_lInicio  := .T.


Do While !Eof()
	IncProc("Aguarde Processando.... Data "+TSC5->C5_EMISSAO)
	
	// Utilizando o filtro do usuario
	If !Empty(_cFiltro)
		If &_cFiltro
			// Se atender prossegue
		Else
			TSC5->(DbSkip())
			Loop
		EndIf
	EndIf
	cUserLgA := Embaralha(TSC5->C5_USERLGA ,1)

//   	If cUserLga $ "JAIME"
		If _nLi > 62
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho) //Impressao do cabecalho
			_nLi := Prow()+1
		EndIf          
     	_cCliente := GetAdvFVal("SA1","A1_NREDUZ",xFilial("SA1")+TSC5->C5_CLIENTE+TSC5->C5_LOJACLI,1)
     	
		@_nLi,000 PSAY U_stod(TSC5->C5_EMISSAO,"D")
		@_nLi,013 PSAY TSC5->C5_NUM      
		@_nLi,023 PSAY TSC5->C5_CLIENTE  
		@_nLi,033 PSAY _cCliente 
		@_nLi,073 PSAY subs(cUserlga,1,15) 
//		@_nLi,064 PSAY TSC5->C5_VALIENTE             Picture "@E 9999,999,999.99"
		_nLi++

//		_dDtDigit := TSC5->C5_EMISSAO
//	EndIf
	
//	_nTotDiaG := _nTotDiaG + TSE2->E2_VALOR
//	EndIf
	dbSelectArea("TSC5")
	dbSkip()
EndDo

If _nLi > 62
	Cabec(titulo,cabec1,cabec2,nomeprog,tamanho) //Impressao do cabecalho
	_nLi := Prow()+1
EndIf
_nLi++
/*
@_nLi,000 PSAY "Acumulado"
@_nLi,013 PSAY _nTN101M             Picture "@E 9999,999,999.99"
@_nLi,030 PSAY _nTN102M             Picture "@E 9999,999,999.99"
@_nLi,047 PSAY _nTN103M             Picture "@E 9999,999,999.99"
@_nLi,064 PSAY _nTN104M             Picture "@E 9999,999,999.99"
@_nLi,081 PSAY _nTotDM              Picture "@E 99,999,999,999.99"
@_nLi,102 PSAY _nTN101F             Picture "@E 9999,999,999.99"
@_nLi,119 PSAY _nTN102F             Picture "@E 9999,999,999.99"
@_nLi,136 PSAY _nTN103F             Picture "@E 9999,999,999.99"
@_nLi,153 PSAY _nTN104F             Picture "@E 9999,999,999.99"
@_nLi,170 PSAY _nTotDF              Picture "@E 99,999,999,999.99"
@_nLi,198 PSAY _nTotDG              Picture "@E 999,999,999,999,999.99"
_nLi++
_nLi++

If _nLi > 58
	Cabec(titulo,cabec1,cabec2,nomeprog,tamanho) //Impressao do cabecalho
	_nLi := Prow()+1
EndIf
@_nLi,000 PSAY _cTraco
_nLi++
@_nLi,000 PSAY cabec3
_nLi++
@_nLi,000 PSAY cabec4
_nLi++
@_nLi,000 PSAY _cTraco
@_nLi,000 PSAY "101 ---> "
@_nLi,009 PSAY _nTN101M+_nTN101F    Picture "@E 9999,999,999,999.99"
_nLi++
@_nLi,000 PSAY "102 ---> "
@_nLi,009 PSAY _nTN102M+_nTN102F    Picture "@E 9999,999,999,999.99"
_nLi++
@_nLi,000 PSAY "103 ---> "
@_nLi,009 PSAY _nTN103M+_nTN103F    Picture "@E 9999,999,999,999.99"
_nLi++
@_nLi,000 PSAY "104 ---> "
@_nLi,009 PSAY _nTN104M+_nTN104F    Picture "@E 9999,999,999,999.99"
_nLi++

@_nLi,000 PSAY "Geral "
@_nLi,009 PSAY _nTN101M+_nTN101F+_nTN102M+_nTN102F+_nTN103M+_nTN103F+_nTN104M+_nTN104F  Picture "@E 9999,999,999,999.99"
*/
Return

/*/
____________________________________________________________________________
|            |           |       |                       |      |            |
| Funcao     | ValidPerg | Autor | Luiz Carlos Vieira    | Data | 03/07/1997 |
|____________|___________|_______|_______________________|______|____________|
|            |                                                               |
| Descricao  | Verifica as perguntas incluindo-as caso nao existam           |
|____________|_______________________________________________________________|
|            |                                                               |
| Uso        | Diversos programas especificos                                |
|____________|_______________________________________________________________|
/*/

Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
aRegs := {}
//Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Da Data de Emissao      (NF) ?","Da Data de Emissao      (NF) ?","Da Data de Emissao      (NF) ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate a Data de Emissao   (NF) ?","Ate a Data de Emissao   (NF) ?","Ate a Data de Emissao   (NF) ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do Fornecedor                ?","Do Fornecedor                ?","Do Fornecedor                ?","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",""})
AADD(aRegs,{cPerg,"04","Ate o Fornecedor             ?","Ate o Fornecedor             ?","Ate o Fornecedor             ?","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","",""})
//AADD(aRegs,{cPerg,"05","Da Natureza                  ?","Da Natureza                  ?","Da Natureza                  ?","mv_ch5","C",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SED","","",""})
//AADD(aRegs,{cPerg,"06","Ate a Natureza               ?","Ate a Natureza               ?","Ate a Natureza               ?","mv_ch6","C",10,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SED","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return(.T.)
