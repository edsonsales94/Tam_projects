//#include "protheus.ch"
#include "rwmake.ch"
#include "ap5mail.ch"

/*/{Protheus.doc} CADZ99

Tela de cadastro de tarefas

@type function
@author Honda Lock
@since 01/10/2017

/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADZ99    บAutor  ณDonizete            บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Este programa tem a fun็ใo de montar um browser para       บฑฑ
ฑฑบ          ณ edi็ใo do cadastro de tarefas bem como colorir os registrosบฑฑ
ฑฑบ          ณ de acordo com sua priorida.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Menu                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADZ99()

Public _aCores 		:= {}
Public aRotina		:= {}
Public cCadastro	:= ""
Public _lYesNo		:= .F.
Public _cEmpresa1	:= ""
Public _cEmpresa2	:= ""
Public _cPri		:= ""
Public _cSt			:= ""
Public _cCopia		:= GETMV("MV_Z99CC")     // Criar parametro
Public _nOpc 		:= 0

_aCores	:= 	{	{ 'Z99_PRIOR     == "1"  .And. !Z99_STATUS $ "CXP" .And. (Empty(Z99_DTPRV).Or.Z99_DTPRV>=ddatabase)   '	, 'BR_VERMELHO'      	},; 	// Prioridade Alta
				{ 'Z99_PRIOR     == "2"  .And. !Z99_STATUS $ "CXP" .And. (Empty(Z99_DTPRV).Or.Z99_DTPRV>=ddatabase)'	, 'BR_AMARELO'       	},; 	// Prioriade Normal
				{ 'Z99_PRIOR     == "3"  .And. !Z99_STATUS $ "CXP"   '													, 'BR_AZUL'          	},; 	// Prioriade Baixa
				{ 'Z99_STATUS    == "X"                              '													, 'BR_CINZA'         	},; 	// Atividade Cancelada
				{ 'Z99_STATUS    == "P"                              '													, 'BR_BRANCO'        	},; 	// Atividade Adiada
				{ 'Z99_STATUS    == "C"                              '													, 'BR_VERDE'        	},; 	// Atividade Adiada
				{ '!Empty(Z99_DTPRV).And.Z99_DTPRV<ddatabase         '													, 'BR_PRETO'    		}}   	// Atividade Atrasada

aRotina	:=   	{	{"Pesquisar"	,"AXPESQUI" 			,0,1},;
					{"Visualizar"  	,"AXVISUAL       "    	,0,2},;
					{"Incluir"     	,"U_Z99INCLUI    "    	,0,3},;
					{"Alterar"     	,"U_Z99ALTERA    "    	,0,4},;
					{"Envia E-Mail"	,"U_Z99EMAIL     "  	,0,7},;
					{"Relat๓rio"   	,"U_Z99IMPRIMEREQ"		,0,8},;
					{"Legenda"     	,"U_Z99LEGENDA   "   	,0,9} }

//					{"Excluir"     	,"U_Z99DELETA    "    	,0,5},;
//					{"View"        	,"U_Z99VIEW      "      ,0,6},;



cCadastro := "Controle de Tarefas - 1.11"

//Verifica se a base ้ top.
If Alltrim(__crdd) = "TOPCONN"
	mBrowse(6, 1, 22, 75, "Z99",,,,,, _aCores)
Else
	
	_lYesNo := MsgBox("Filtrar tarefas concluํdas/canceladas? (Tem efeito no browse e relat๓rios)","Pergunta","YESNO")
	
	If _lYesNo	== .F.
		mBrowse(6, 1, 22, 75, "Z99",,,,,, _aCores)
	Else
		cIndex := CriaTrab(nil,.f.)
		dbSelectArea("Z99")
		dbSetOrder(1)
		dbGoTop()
		cKey := IndexKey()
		cCondicao := "Z99_STATUS <> 'X' .And. Z99_STATUS <> 'C'"
		
		IndRegua("Z99",cIndex,cKey,,cCondicao)
		
		mBrowse(6,1,22,75,"Z99",,,,,,_aCores)
		
		Z99->(dbCloseArea())
		Ferase(cIndex+OrdBagExt())
	EndIf
EndIf

Return(.T.)

User Function Z99Inclui()
_nOpc := AxInclui("Z99",, 3)
If _nOpc = 1
	EnviarEmail()
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltera    บAutor  ณDonizete            บ Data ณ  11/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Permite altera็ใo somente registros nใo concluํdos/        บฑฑ
ฑฑบ          ณ cancelados.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CADZ99                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Z99Altera()

If Z99->Z99_STATUS == "X" .Or. (Z99->Z99_STATUS == "C" .And. !Empty(Z99->Z99_DTFINS))
	MsgInfo("Tarefa concluํda ou cancelada nใo pode ser alterada.","Aten็ใo")
ElseIf Z99->Z99_USRID1 == Alltrim(RetCodUsr()) .Or. Z99->Z99_USRID2 == Alltrim(RetCodUsr())
	_nOpc := AxAltera("Z99",RecNo(),4,,)
	If _nOpc = 1
		EnviarEmail()
	EndIf
Else
	MsgInfo("Somente os usuแrios amarrados a esta Tarefa podem fazer atualiza็๕es.","Aten็ใo")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDeleta    บAutor  ณDonizete            บ Data ณ  11/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Permite excluir somente registros nใo iniciados            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CADZ99                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Z99Deleta()

If Z99->Z99_STATUS <> "N"
	MsgInfo("Somente registros com status 'N=Nใo Iniciado' podem ser excluํdos.","Atencao")
	//Elseif Upper(SubStr(cUsuario,7,15)) <> Z99->Z99_PROPRI .And. ;
	//	Alltrim(Upper(SubStr(cUsuario,7,15))) <> "ADMINISTRADOR"
ElseIf Z99->Z99_USRID1 <> Alltrim(RetCodUsr())
	MsgInfo("Somente usuแrio que incluiu o registro poderแ apagแ-lo!","Atencao")
Else
	AxDeleta("Z99",RecNo(),5,,)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegenda   บAutor  ณDonizete            บ Data ณ  11/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra a legenda dos registros.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CADZ99                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Z99Legenda()

Local cCadastro := "Controle de Tarefas"
Local aCores2	:= {}

aCores2 := {{ 'BR_VERMELHO'	, "Prioridade Alta"         },;
{ 'BR_AMARELO'  , "Prioridade Normal"       },;
{ 'BR_AZUL'     , "Prioridade Baixa"        },;
{ 'BR_VERDE'    , "Tarefa Concluํda"        },;
{ 'BR_BRANCO'   , "Tarefa Adiada"           },;
{ 'BR_CINZA'    , "Tarefa Cancelada"        },;
{ 'BR_PRETO'    , "Tarefa Atrasada"        }}

BrwLegenda(cCadastro,"Legenda do Browse",aCores2)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณView      บAutor  ณDonizete            บ Data ณ  11/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra os dados da tarefa em uma janela de diแlogo.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CADZ99                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Z99View()

// Declara็ใo de Variแveis.
Local _nTam		:= 100
Local _nLinha	:= MLCount(Z99->Z99_DESCM,_nTam)
Local _nLinTela := 60
Local _nInc		:= 0

//Carrega dados.
DefDados()

// Inํcio da janela.
@ 065, 001 TO 560, 700 DIALOG oMyDlg TITLE "View da Tarefa (para resolu็ใo 800 x 600)"
@ 005, 003 To 200, 350
@ 010, 010 Say "[ DADOS ] "
@ 020, 010 Say "Tarefa: " + Z99->Z99_NUM + " - Area: " + Z99->Z99_AREA + " - Fase: " + Z99->Z99_FASE + ;
" - Rotina: " + Z99->Z99_ROTINA + ;
"    - Prioridade: " + _cPri + "    - Criado em: " + Transform(Z99->Z99_DTINCL,"@D")
@ 030, 010 Say "Solicitante: " + Alltrim(Z99->Z99_SOLIC)+"/"+Iif(Z99->Z99_EMPR=="M","Microsiga","Cliente") + ;
"    - Responsavel: " + Alltrim(Z99->Z99_RESP) +"/"+Iif(Z99->Z99_EMPRES=="M","Microsiga","Cliente")
@ 040, 010 Say "Para data: " + Transform(Z99->Z99_DTPRV,"@D") + "    - Data inํcio: " + ;
Transform(Z99->Z99_DTINI,"D") + ;
"    - Data conclusใo: " + Transform(Z99->Z99_DTCONC,"@D")
@ 050, 010 Say "Status: " + _cSt + "    - % Concluํdo: " + Transform(Z99->Z99_PERC,"999") + ;
"    - Chamado: " + If(Empty(Z99->Z99_CHAM),"(Nใo Tem)",Z99->Z99_CHAM)

@ 060, 010 Say "[ ATIVIDADE (somente 3 primeiras linhas) ]"
For _nInc := 1 to 3
	_nLinTela := _nLinTela + 10
	@ _nLinTela, 010 Say MemoLine(Z99->Z99_DESCM,_nTam,_nInc)
Next

_nLinTela := _nLinTela + 10
@ _nLinTela, 010 Say "[ ANOTAวีES (8 ๚ltimas linhas) ]"

_nLinha := MLCount(Z99->Z99_NOTAM,_nTam)
For _nInc := Iif(_nLinha>8,_nLinha-7,1) To _nLinha
	_nLinTela := _nLinTela + 10
	@ _nLinTela, 010 Say MemoLine(Z99->Z99_NOTAM,_nTam,_nInc)
Next

@ 203,230 Button "Editar" SIZE 50,15 Action (U_Z99Altera(), Close(oMyDlg))
@ 203,285 Button "Fechar" SIZE 50,15 Action Close(oMyDlg)
Activate Dialog oMyDlg Centered
// Fim do Formulแrio.
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImprimeReqบAutor  ณDonizete            บ Data ณ  11/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime a Requisicao de tarefas.                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CADZ99                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Z99IMPRIMEREQ()

//Acerta perguntas.
VldPerg("ZZCZ99")

// Carrega parโmetros de impressใo.
If Pergunte("ZZCZ99",.T.) == .F.
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "Requisi็ใo de Tarefas"
Private cPict          := ""
Private titulo       	 := "Requisicao de Tarefas - " + SM0->M0_NOME
Private nLin           := 80

Private Cabec1       := ""
Private Cabec2       := ""
Private imprime      := .T.
Private aOrd             := {"Num.Ativid." , ;
"Responsavel+Empresa+Prioridade+Num.Ativid.", ;
"Solicitante+Empresa+Prioridade+Num.Ativid.", ;
"Area/Categ.+Prioridade+Num.Ativid.+Responsavel+Empr.Resp.", ;
"Prioridade+Num.Ativid.+Area/Categ."}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := Iif(MV_PAR07==1,220,80)
Private tamanho          := Iif(MV_PAR07==1,"G","P")
Private nomeprog         := "CADZ99" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CADZ99" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "Z99"

dbSelectArea("Z99")
dbSetOrder(1)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"ZZCZ99",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)

//Redefine parโmetros de impressใo
Private Cabec1           := Iif(MV_PAR07==1,"Tarefa|Dt.Incl.|Priori|F|Categ|Solicitante      |Responsavel      |Tarefa                                                                                         |Para Dt.|Status       |Dt.Inic.|Dt.Conc.|Chamado","")
Private limite           := Iif(MV_PAR07==1,220,80)
Private tamanho          := Iif(MV_PAR07==1,"G","P")

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  11/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local _nTam		:= 70
lOCAL _nInc		:= 0
Local _nLinha	:= 0

dbSelectArea(cString)

Pergunte("ZZCZ99",.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tratamento das ordens. A ordem selecionada pelo usuario esta contidaณ
//ณ na posicao 8 do array aReturn. E um numero que indica a opcao sele- ณ
//ณ cionada na mesma ordem em que foi definida no array aOrd. Portanto, ณ
//ณ basta selecionar a ordem do indice ideal para a ordem selecionada   ณ
//ณ pelo usuario, ou criar um indice temporario para uma que nao exista.ณ
//ณ Por exemplo:                                                        ณ
//ณ                                                                     ณ
//ณ nOrdem := aReturn[8]                                                ณ
//ณ If nOrdem < 5                                                       ณ
//ณ     dbSetOrder(nOrdem)                                              ณ
//ณ Else                                                                ณ
//ณ     cInd := CriaTrab(NIL,.F.)                                       ณ
//ณ     IndRegua(cString,cInd,"??_FILIAL+??_ESPEC",,,"Selec.Registros") ณ
//ณ Endif                                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nOrdem := aReturn[8]

dbSetOrder(1)
dbSetOrder(nOrdem)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbGoTop()
While !EOF() .And. xFilial() == Z99->Z99_FILIAL
	
	If (Z99->Z99_NUM < Alltrim(MV_PAR01)) .Or. (Z99->Z99_NUM > Alltrim(MV_PAR02))
		dbSkip()
		Loop
	EndIf
	
	if ((Z99->Z99_USRID1==Alltrim(MV_PAR03) .Or. Z99->Z99_USRID2==Alltrim(MV_PAR04))) .Or. ;
		(Empty(MV_PAR03) .and. Empty(MV_PAR04))
 		// Imprime os dados...
	Else
		dbSkip()
		Loop
	EndIf
	
	if MV_PAR05 == 1
		if Z99->Z99_STATUS == "X" .Or. Z99->Z99_STATUS == "C" 
			dbSkip()
			loop
		EndIf
	EndIf

	if MV_PAR08 == 1
		if Z99->Z99_STATUS == "P"
			dbSkip()
			loop
		EndIf
	EndIf
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicializa็ใo de Variแveis.                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DefDados()
	
	_nTam		:= 70
	_nInc		:= 0
	_nLinha		:= MLCount(Z99->Z99_DESCM,_nTam)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := Iif(MV_PAR07==2,3,7)
	Endif
	
	If MV_PAR07==2
		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:
		
		nLin := nLin + 2
		@nLin,00 PSAY "Empresa/Filial      : " + SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)
		
		//nLin := nLin + 2
		//@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 2
		@nLin,00 PSAY "Tarefa n.           : "+ Z99->Z99_NUM
		@nLin,29 PSAY "- Dt.Cria็ใo: "+ Transform(Z99->Z99_DTINCL,"@D")
		@nLin,55 PSAY "- Prioridade: [" + _cPri + "]"
		
		nLin := nLin + 2
		@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 1
		@nLin,00 PSAY "Area                : "+ Z99->Z99_AREA
		@nLin,28 PSAY " - Rotina: " + Z99->Z99_ROTINA
		@nLin,50 PSAY "- Fase: " + Z99->Z99_FASE
		
		//nLin := nLin + 2
		//@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 2
		@nLin,00 PSAY "Solicitante         : " + Z99->Z99_SOLIC + " / " + _cEmpresa1
		
		nLin := nLin + 1
		@nLin,00 PSAY "Respons.pela tarefa : " + Z99->Z99_RESP + " / " + _cEmpresa2
		
		//nLin := nLin + 2
		//@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 2
		@nLin,00 PSAY "Descricao da Tarefa : "
		
		nLin := nLin + 1
		For _nInc := 1 To _nLinha
			nLin := nLin + 1
			@ nLin, 00 PSay MemoLine(Z99->Z99_DESCM,_nTam,_nInc)
		Next
		
		nLin := nLin + 2
		@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 2
		@nLin,00 PSAY "Para Data   : " + Transform(Z99->Z99_DTPRV,"@D")
		@nLin,25 PSAY "- Status       : " + _cSt
		
		nLin := nLin + 1
		@nLin,00 PSAY "Iniciada em : " +  Transform(Z99->Z99_DTINI,"@D")
		@nLin,25 PSAY "- Encerrada em : " + Transform(Z99->Z99_DTCONC,"@D")
		
		//nLin := nLin + 2
		//@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 2
		@nLin,00 PSAY "Chamado : " + Z99->Z99_CHAM
		@nLin,25 PSAY "- % Concluido  : " + Transform(Z99->Z99_PERC,"999")
		
		//nLin := nLin + 2
		//@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 3
		@nLin,00 PSAY "Solic.:___________________ __/__/__"
		@nLin,35 PSAY "Resp. :___________________ __/__/__"
		
		nLin := nLin + 3
		@nLin,00 PSAY Replicate("=",80)
		
		nLin := nLin + 1
		@nLin,15 PSAY "IMPORTANTE: para o bom andamento dos trabalhos/cronograma"
		nLin := nLin + 1
		@nLin,15 PSAY "a tarefa devera ser concluida ate a data solicitada."
		
		nLin := nLin + 1
		@nLin,00 PSAY Replicate("=",80)
		
		nLin := nLin + 3
		
		If MV_PAR06 == 1
			@nLin,00 PSAY "Situacao da Tarefa: "
			
			_nLinha		:= MLCount(Z99->Z99_NOTAM,_nTam)
			nLin := nLin + 1
			For _nInc := 1 To _nLinha
				nLin := nLin + 1
				@ nLin, 00 PSay MemoLine(Z99->Z99_NOTAM,_nTam,_nInc)
			Next
		EndIf
		nLin := 60
		
	Else
		
		nLin := nLin + 1
		@nLin,00 PSAY Z99->Z99_NUM + "|" + Transform(Z99->Z99_DTINCL,"@D") + "|" + _cPri + ;
		"|" + Z99->Z99_FASE+"|"+Z99->Z99_AREA + "|" + Z99->Z99_SOLIC + "/" + Z99->Z99_EMPR + ;
		"|" + Z99->Z99_RESP + "/" + Z99->Z99_EMPRES + "|" + MemoLine(Z99->Z99_DESCM,95,1) + ;
		"|" + Transform(Z99->Z99_DTPRV,"@D") + "|" + _cSt + "|" + Transform(Z99->Z99_DTINI,"@D") + ;
		"|" + Transform(Z99->Z99_DTCONC,"@D") + "|" + Z99->Z99_CHAM
	EndIf
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldPerg   บAutor  ณDonizete            บ Data ณ  12/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem dos parโmetros para execu็ใo da rotina.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Template                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//Static Function VldPerg(cPerg)
//_sAlias := Alias()
//dbSelectArea("SX1")
//dbSetOrder(1)
//aRegs:={}

//aAdd(aRegs,{cPerg,"01" ,"Tarefa de?             ","Tarefa de?             ","Tarefa de?             ","mv_ch1","C",06,0,0,"G","","mv_par01",""   ,""   ,"",""   ,""    ,""       ,""     ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,"","","","   "})
//aAdd(aRegs,{cPerg,"02" ,"Tarefa ate?            ","Tarefa ate?            ","Tarefa ate?            ","mv_ch2","C",06,0,0,"G","","mv_par02",""   ,""   ,"",""   ,""    ,""       ,""     ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,"","","","   "})
//aAdd(aRegs,{cPerg,"03" ,"Solic.(Bco=Todos)?     ","Solic.(Bco=Todos)?     ","Solic.(Bco=Todos)?     ","mv_ch3","C",06,0,0,"G","","mv_par03",""   ,""   ,"",""   ,""    ,""       ,""     ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,"","","","USR"})
//aAdd(aRegs,{cPerg,"04" ,"Resp.Solic.(Bco=Todos)?","Resp.Solic.(Bco=Todos)?","Resp.Solic.(Bco=Todos)?","mv_ch4","C",06,0,0,"G","","mv_par04",""   ,""   ,"",""   ,""    ,""       ,""     ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,"","","","USR"})
//aAdd(aRegs,{cPerg,"05" ,"Filtrar Canc./Conc.?   ","Filtrar Canc./Concl.?   ","Filtrar Canc./Concl.?   ","mv_ch5","C",01,0,0,"C","","mv_par05","Sim","Sim","Sim",""    ,""       ,"Nao"  ,"Nao"   ,"Nao",""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,"","","","","   "})
//aAdd(aRegs,{cPerg,"06" ,"Imprimir Situa็ใo?   ","Imprimir Situa็ใo?   ","Imprimir Situa็ใo?  ","mv_ch6","C",01,0,0,"C","","mv_par06","Sim","Sim","Sim",""    ,""       ,"Nao"  ,"Nao"   ,"Nao",""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,"","","","","   "})
//aAdd(aRegs,{cPerg,"07" ,"Somente Listagem?   ","Somente Listagem?   ","Somente Listagem?  ","mv_ch7","C",01,0,0,"C","","mv_par07","Sim","Sim","Sim",""    ,""       ,"Nao"  ,"Nao"   ,"Nao",""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,"","","","","   "})
//aAdd(aRegs,{cPerg,"08" ,"Filtrar Adiada?   ","Filtrar Adiada?   ","Filtrar Adiada?  ","mv_ch8","C",01,0,0,"C","","mv_par08","Sim","Sim","Sim",""    ,""       ,"Nao"  ,"Nao"   ,"Nao",""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,"","","","","   "})

//For i:=1 to Len(aRegs)
  //	If !dbSeek(cPerg+aRegs[i,2])
	//	RecLock("SX1",.T.)
	  //	For j:=1 to FCount()
		//	If j <= Len(aRegs[i])
		  //		FieldPut(j,aRegs[i,j])
			//Endif
		//Next
		//MsUnlock()
   //	Endif
//Next
dbSelectArea(_sAlias)
Return

Static Function EnviarEmail()
_lYesNo := MsgBox("Deseja enviar e-mail?","Pergunta","YESNO")
If _lYesNo
	U_Z99EMail()
EndIf
Return

User Function Z99EMail(_cAssunto,_cEmailDest,_cMensagem)

local lConect 			:= .F.
local lFim 				:= .F.
local _cMailConta		:= ""
local cMailContD		:= ""
local cMailCntD			:= ""
local cMailContX	 	:= GETMV("MV_RELACNT")					//GETMV("MV_EMCONTA")
local cMailServer		:= GETMV("MV_RELSERV")
local cMailSenha		:= GETMV("MV_RELAPSW")          		//GETMV("MV_EMSENHA")
local cRet				:= chr(13) + chr(10)
local nLin				:= 0
Local _nLinha			:= MLCount(Z99->Z99_DESCM,50)
Local cMailInt1			:= ""
Local cMailInt2			:= ""
Local cMailInt3			:= ""  
Local _cSup				:= ""

If Z99->Z99_USRID1 == Alltrim(RetCodUsr()) .Or. Z99->Z99_USRID2 == Alltrim(RetCodUsr())
	//Ok
Else
	MsgInfo("Somente os usuแrios amarrados a esta Tarefa podem enviar e-mail.","Aten็ใo")
	Return
EndIf

// Solicita confirma็ใo.
_nOpc := Aviso("Envio de e-mail","Para quem enviar?",{"Responsavel","Solicitante","Resp./Solic","Cancela"})

If _nOpc == 4
	Return
EndIf

//Inicializa Valores
DefDados()

// Busca email dos usuarios
psworder(1)  // Indice por Codigo

//If pswseek(alltrim(__cUserId),.t.)
If pswseek(alltrim(Z99->Z99_USRID1),.t.)
	_dAdUser  	:= pswret(1)
	_cMailConta  := Alltrim(_dAdUser[1,14])  // conta do emitente do email
	If Empty(_cMailConta)
		_cMailConta := GETMV("MV_RELACNT")
		if Empty(_cMailConta)
			MsgInfo("O remetente nใo possui endere็o de e-mail.")
			Return
		EndIf
	EndIf
endif

If pswseek(alltrim(Z99->Z99_USRID2),.t.)
	_dAdUser  	:= pswret(1)
	cMailContD  := Alltrim(_dAdUser[1,14])  // conta do destinatario do e-mail
	_cSup        := Alltrim(_dAdUser[1,11])  // conta do destinatario do e-mail superior
	If Empty(cMailContD)
		MsgInfo("O destinatแrio nใo possui endere็o de e-mail.")
		Return
	EndIf
endif

If pswseek(alltrim(_cSup),.t.)
	_dAdUser  	:= pswret(1)
	_cSup := Alltrim(_dAdUser[1,14])  // conta do destinatario do e-mail
	If Empty(_cSup)
		MsgInfo("Destinatแrio Superior nใo possui endere็o de e-mail.")
		Return
	EndIf
endif

// Interessados
If !Empty(Z99->Z99_INT1)
	If pswseek(alltrim(Z99->Z99_INT1),.t.)
		_dAdUser  	:= pswret(1)
		cMailInt1  := Alltrim(_dAdUser[1,14])  // conta do destinatario do e-mail
		If Empty(cMailInt1)
			MsgInfo("O destinatแrio Interessado1 nใo possui endere็o de e-mail.")
			Return
		EndIf
	endif
EndIf

If !Empty(Z99->Z99_INT2)
	If pswseek(alltrim(Z99->Z99_INT2),.t.)
		_dAdUser  	:= pswret(1)
		cMailInt2  := Alltrim(_dAdUser[1,14])  // conta do destinatario do e-mail
		If Empty(cMailInt2)
			MsgInfo("O destinatแrio Interessado2 nใo possui endere็o de e-mail.")
			Return
		EndIf
	endif
EndIf

If !Empty(Z99->Z99_INT3)
	If pswseek(alltrim(Z99->Z99_INT3),.t.)
		_dAdUser  	:= pswret(1)
		cMailInt3  := Alltrim(_dAdUser[1,14])  // conta do destinatario do e-mail
		If Empty(cMailInt3)
			MsgInfo("O destinatแrio Interessado3 nใo possui endere็o de e-mail.")
			Return
		EndIf
	endif
EndIf

_cAssunto   := Alltrim(SM0->M0_NOME)+" - Req.de Tarefa " + Z99->Z99_NUM + " - Prioridade: " + _cPri
If _nOpc == 1
	_cEmailDest := cMailContD
ElseIf _nOpc == 2
	_cEmailDest := _cMailConta
ElseIf _nOpc == 3
	_cEmailDest := cMailContD + ";" + _cMailConta
EndIf

If !Empty(_cCopia)
	_cEmailDest := 	_cEmailDest + ";" + _cCopia
EndIf

_cEmailDest := _cEmailDest +Iif(!Empty(cMailInt1),";"+cMailInt1,"")
_cEmailDest := _cEmailDest +Iif(!Empty(cMailInt2),";"+cMailInt2,"")
_cEmailDest := _cEmailDest +Iif(!Empty(cMailInt3),";"+cMailInt3,"")
_cEmailDest := _cEmailDest +Iif(Z99->Z99_ENVSUP=="S".And.!Empty(_cSup),";"+_cSup,"")

_cMensagem	:= Replicate("*",65) + cRet
_cMensagem  := _cMensagem + "Mensagem enviada pelo Controle de Tarefas - Versใo 1.11" + cRet
_cMensagem	:= _cMensagem + Replicate("*",65) + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Empresa/Filial: " + SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL) + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Tarefa n.: "+ Z99->Z99_NUM + " - Dt.Cria็ใo: " + Transform(Z99->Z99_DTINCL,"@D") + ;
"- Prioridade: [" + _cPri + "]" + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Area: "+ Z99->Z99_AREA + " - Fase: "+Z99->Z99_FASE + " - Rotina: " + Z99->Z99_ROTINA + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Solicitante        : " + Z99->Z99_SOLIC + " / " + _cEmpresa1 + cRet
_cMensagem	:= _cMensagem + "Respons.pela tarefa: " + Z99->Z99_RESP + " / " + _cEmpresa2 + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + Replicate("-",65) + cRet
_cMensagem	:= _cMensagem + "Descricao da Tarefa: " + cRet
For _nInc := 1 To _nLinha
	_cMensagem	:= _cMensagem + MemoLine(Z99->Z99_DESCM,50,_nInc) + cRet
Next
_cMensagem	:= _cMensagem + Replicate("-",65) + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Para Data: " + Transform(Z99->Z99_DTPRV,"@D") + ;
" - Status: " + _cSt + cRet
_cMensagem	:= _cMensagem + "Iniciada em: " +  Transform(Z99->Z99_DTINI,"@D") + ;
"- Encerrada em: " + Transform(Z99->Z99_DTCONC,"@D") + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Chamado: " + Z99->Z99_CHAM + ;
"- % Concluido: " + Transform(Z99->Z99_PERC,"999") + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Situa็ใo da tarefa: " + cRet
_nLinha		:= MLCount(Z99->Z99_NOTAM,50)
For _nInc := 1 To _nLinha
	_cMensagem	:= _cMensagem + MemoLine(Z99->Z99_NOTAM,50,_nInc) + cRet
Next
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + Replicate("*",65) + cRet
_cMensagem	:= _cMensagem + "IMPORTANTE: para o bom andamento dos trabalhos/cronograma" + cRet
_cMensagem	:= _cMensagem + "a tarefa devera ser concluida ate a data solicitada." + cRet
_cMensagem	:= _cMensagem + Replicate("*",65) + cRet

CONNECT SMTP SERVER cMailServer ACCOUNT cMailContX PASSWORD cMailSenha RESULT lConect
If ! (lConect)  // testa se a conexใo foi feita com sucesso
	MsgInfo("Erro na conexใo.")
Else
	SEND MAIL FROM _cMailConta TO _cEmailDest SUBJECT _cAssunto BODY _cMensagem RESULT lEnv
	
	If ! (lEnv)  // testa se a mensagem foi enviada com sucesso
		MsgInfo("Erro no envio automแtico de e-mail.")
		Get Mail Error cErrorMsg
		Help("",1,"AVG0001056",,"Error : " + cErrorMsg,2,0)
	Else
		If _nOpc = 1 .Or. _nOpc = 3
			If RecLock("Z99",.f.)
				Z99->Z99_DTEM := ddatabase
				msUnlock()
			EndIf
		EndIf
		Msginfo("E-mail enviado com sucesso para "+_cEmailDest)
	Endif
Endif

DISCONNECT SMTP SERVER RESULT lFim

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDefDados  บAutor  ณDonizete            บ Data ณ  18/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna variแveis inicializadas.                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CADZ99                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DefDados

//Define a empresa.
If Z99->Z99_EMPR == "M"
	_cEmpresa1 := "Microsiga"
Else
	_cEmpresa1 := "Cliente  "
EndIf

If Z99->Z99_EMPRES == "M"
	_cEmpresa2 := "Microsiga"
Else
	_cEmpresa2 := "Cliente  "
EndIf

// Retorna texto da prioridade.
Do Case
	Case Z99->Z99_PRIOR == "1"
		_cPri := "ALTA  "
	Case Z99->Z99_PRIOR == "2"
		_cPri := "Normal"
	Case Z99->Z99_PRIOR == "3"
		_cPri := "Baixa "
EndCase

// Retorna o Status.
Do Case
	Case Z99->Z99_STATUS == "N"
		_cSt := "Nao Iniciado "
	Case Z99->Z99_STATUS == "E"
		_cSt := "Em Andamento "
	Case Z99->Z99_STATUS == "C"
		_cSt := "Concluido    "
	Case Z99->Z99_STATUS == "A"
		_cSt := "Aguardando..."
	Case Z99->Z99_STATUS == "P"
		_cSt := "Adiada       "
	Case Z99->Z99_STATUS == "X"
		_cSt := "Cancelada    "
EndCase

Return
