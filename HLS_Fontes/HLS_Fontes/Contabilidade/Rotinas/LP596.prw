#Include "rwmake.ch"

User Function LP596(_cPar1,_cPar2)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP596     ºAutor  ³Donizete            º Data ³  10/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este LP retorna dados para o LP 596 (compensação contas a  º±±
±±º          ³ a receber. Trata o posicionamento dos títulos.             º±±
±±º          ³ Adaptado do rdmake originalmente elaborado por Martelli.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Chamada no LP 596.                                         º±±
±±º          ³ Protheus 7.10                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


// Definição das variáveis.
Public _aArea   	:= GetArea()
Public _aAreaSE1	:= SE1->(GetArea())
Public _aAreaSA1	:= SA1->(GetArea())
Public _aAreaSED	:= SED->(GetArea())
Public _cRet		:= Space(20)
Public _cCod		:= Space(6)
Public _cLoja		:= Space(2)
Public _cConta		:= Space(20)
Public _cNat		:= Space(10)
Public _cChavePA	:= Space(23)
Public _cChaveNF	:= Space(23)
Public _cChave		:= Space(23)
Public _cCliRA		:= Space(15)
Public _cCliNF		:= Space(15)
_cPar1 := Upper(Alltrim(_cPar1)) // Tipo de Dado a ser retornado.
_cPar2 := Upper(Alltrim(_cPar2)) // Tipo de Dado a ser retornado.

If Alltrim(SE5->E5_TIPO) $ "RA/NCC" // Usuário compensou posicionando na NF.
	_cChaveNF := SUBSTR(SE5->E5_DOCUMEN,1,13)
	_cChaveRA := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
Else // Usuário compensou posicionando no RA/NCC
	_cChaveNF := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
	_cChaveRA := SUBSTR(SE5->E5_DOCUMEN,1,13)
EndIf

dbSelectArea("SE1")
dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

// Obtem nome do cliente da NF.
dbSeek(xFilial("SE1")+_cChaveNF,.T.)
If Found()
	_cCliNF	  := Alltrim(SE1->E1_NOMCLI)
EndIf

// Obtem nome do cliente do RA.
dbSeek(xFilial("SE1")+_cChaveRA,.T.)
If Found()
	_cCliRA	  := Alltrim(SE1->E1_NOMCLI)
EndIf

// Verifica tipo de dado solicitado pelo usuário.
If _cPar2 == "NF"
	_cChave := _cChaveNF
Else
	_cChave := _cChaveRA
EndIf

// Posiciona no título conforme tipo escolhido pelo usuário.
dbSeek(xFilial("SE1")+_cChave,.T.)

_cCod	:= SE1->E1_CLIENTE
_cLoja	:= SE1->E1_LOJA
_cNat   := SE1->E1_NATUREZ

// Retorna dados conforme solicitado.
If _cPar1 == "SA1" // Retorna conta do cliente.
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+_ccod+_cloja)
	
	If Found()
		_cRet := SA1->A1_CONTA
	EndIf
	
ElseIf _cPar1 == "SED" // Retorna dados da natureza financeira, pode ser a conta por exemplo.
	dbSelectArea("SED")
	dbSetOrder(1)
	dbSeek(xFilial("SED")+_cNat)
	If Found()
		_cRet := SED->ED_CONTA
	EndIf

ElseIf _cPar1 == "HIS" // Retorna histórico para o LP.
	_cRet := "COMP.CP."+_cChaveNF + "-" + _cCliNF + " C/ " + _cChaveRA + "-" + _cCliRA

EndIf

// Restaura áreas de trabalho.
RestArea(_aAreaSE1)
RestArea(_aAreaSA1)
RestArea(_aAreaSED)
RestArea(_aArea)

// Retorna dado para o LP.
Return(_cRet)
