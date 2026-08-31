#include 'protheus.ch'
#include 'parmtype.ch'
#include 'RestFul.ch'
#include 'Totvs.ch'

user function EREST_05()

Return

Class GERTEF
//cNum,cPrefixo,cParcela,cTipo,cBanco,cAgencia,cConta,cJuros,cValLiq
Data cNum	     As String
Data cPrefixo    As String
Data cParcela    As String
Data cTipo 	     As String
Data cBanco      As String
Data cAgencia    As String
Data cConta      As String
Data cJuros      As String
Data cValLiq     As String
Data cDtBaixa    As String

Method New(cNum,cPrefixo,cParcela,cTipo,cBanco,cAgencia,cConta,cJuros,cValLiq,cDtBaixa) Constructor 

EndClass
//cNum,cPrefixo,cParcela,cTipo,cBanco,cAgencia,cConta,cJuros,cValLiq
Method New(xNum,xPrefixo,xParcela,xTipo,xBanco,xAgencia,xConta,xJuros,xValLiq,xDtBaixa) Class GERTEF

::cNum        := xNum
::cPrefixo    := xPrefixo
::cParcela    := xParcela
::cTipo       := xTipo
::cBanco      := xBanco
::cAgencia    := xAgencia
::cConta      := xConta
::cJuros      := xJuros
::cValLiq     := xValLiq
::cDtBaixa    := xDtBaixa

Return(Self)

WSRESTFUL GERTEF DESCRIPTION "Serviço REST para Baixa de cartao Pelmex"
//cNum,cPrefixo,cParcela,cTipo,cBanco,cAgencia,cConta,cJuros,cValLiq
WSDATA cNum        As String
WSDATA cPrefixo    As String
WSDATA cParcela    As String
WSDATA cTipo       As String
WSDATA cBanco      As String
WSDATA cAgencia    As String
WSDATA cConta      As String
WSDATA cJuros      As String
WSDATA cValLiq     As String
WSDATA cDtBaixa    As String


WSMETHOD GET DESCRIPTION "Retorna a Titulo informada na URL" WSSYNTAX "/GERTEF?cNum={valnum}&cPrefixo={valprefixo}&cParcela={valparcela}&cTipo={valtipo}&cBanco={valbanco}&cAgencia={valagencia}&cConta={valconta}&cJuros={valjuros}&cValLiq={valvalliq}&cDtBaixa={valdtbaixa}"

END WSRESTFUL

WSMETHOD GET WSRECEIVE cNum,cPrefixo,cParcela,cTipo,cBanco,cAgencia,cConta,cJuros,cValLiq,cDtBaixa WSSERVICE GERTEF
	Local cNum        := Self:cNum
	Local cPrefixo    := Self:cPrefixo
	Local cParcela    := Self:cParcela
	Local cTipo       := Self:cTipo
	Local cBanco      := Self:cBanco
	Local cAgencia    := Self:cAgencia
	Local cConta      := Self:cConta
	Local cJuros      := Self:cJuros
	Local cValLiq     := Self:cValLiq
	Local cDtBaixa    := Self:cDtBaixa
	

	Local aArea      := GetArea()
	Local oObjTEF    := Nil
	Local cStatus    := ""
	Local cJson      := ""
	Local lRet       := ''

	::SetContentType("application/json")

	qout("Iniciando Processo para Baixa de Cartao...")
	
	lRet := PLFINTEF(cNum,cPrefixo,cParcela,cTipo,cBanco,cAgencia,cConta,cJuros,cValLiq,cDtBaixa)
    cNum := lRet
	
	If Empty(cNum)
		Return .T.
	EndIf   

	cStatus  := "TITULO BAIXADO"
    oObjTEF := GERTEF():New(cNum, cStatus)
	
	Conout("********************************************************")
	Conout("Titulo: "+cNum+" - "+cPrefixo+" - "+cParcela)
	
	if lret = 'T'
	Conout("Status: "+cStatus)
	endif
	Conout("********************************************************")

	cJson := FWJsonSerialize(oObjTEF)

	::SetResponse(cJson)

	RestArea(aArea)
Return(.T.)
/*_______________________________________________________________________________
¦ Função    ¦ PLFINTEF    ¦ Autor ¦ STAN LEE          ¦ Data ¦ 07/06/2022       ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Baixa cartao SITFF			                                        ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

Static Function PLFINTEF(cNum,cPrefixo,cParcela,cTipo,cBanco,cAgencia,cConta,cJuros,cValLiq,cDtBaixa)
Local aBaixa    := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 3 - Inclusao ³
//³ 4 - Alteracao ³
//³ 5 - Exclusao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cNum,cPrefixo,cParcela,cTipo,cBanco,cAgencia,cConta,cJuros,cValLiq
Local nOpc        := 3 //VAL(cOpcao)
Local xNum        := cNum
Local xPrefixo    := cPrefixo
Local xParcela    := cParcela
Local xTipo       := cTipo
Local xBanco      := cBanco
Local xAgencia    := cAgencia
Local xConta      := cConta
Local nJuros      := VAL(cJuros)
Local nValLiq     := VAL(cValLiq)
//Local xCliente    := ""
//Local xLoja       := ""
Local cError      := ""

Private dDataBase   := CTOD(cDtBaixa) 
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.


	DbSelectArea("SE1")
	DbSetOrder(1)//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If DbSeek(xFilial("SE1") +xPrefixo+xNum+xParcela+xTipo)
		ConOut(dDataBase)
		ConOut("Posicionado no registro para edicao.")
		ConOut(SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
		nJuros  := Round(nJuros,2)
		nValLiq := Round(nValLiq,2)
		If nJuros >= 0
			aBaixa := {{"E1_PREFIXO"  ,xPrefixo                ,Nil    },;
						{"E1_NUM"      ,xNum            ,Nil    },;
						{"E1_PARCELA"  ,xParcela                    ,Nil    },;
						{"E1_TIPO"     ,xTipo                 ,Nil    },;
						{"AUTMOTBX"    ,"NOR"                  ,Nil    },;
						{"AUTBANCO"    ,xBanco                  ,Nil    },;
						{"AUTAGENCIA"  ,xAgencia                ,Nil    },;
						{"AUTCONTA"    ,xConta           ,Nil    },;
						{"AUTDTBAIXA"  ,dDataBase              ,Nil    },;
						{"AUTDTCREDITO",dDataBase              ,Nil    },;
						{"AUTHIST"     ,"BAIXA AUTOMATICA SITEF"          ,Nil    },;
						{"AUTDESCONT"  ,nJuros                      ,Nil,.T.},;
						{"AUTVALREC"   ,nValLiq          ,Nil    }}
		Else
			aBaixa := {{"E1_PREFIXO"  ,xPrefixo                ,Nil    },;
						{"E1_NUM"      ,xNum            ,Nil    },;
						{"E1_PARCELA"  ,xParcela                    ,Nil    },;
						{"E1_TIPO"     ,xTipo                 ,Nil    },;
						{"AUTMOTBX"    ,"NOR"                  ,Nil    },;
						{"AUTBANCO"    ,xBanco                  ,Nil    },;
						{"AUTAGENCIA"  ,xAgencia                ,Nil    },;
						{"AUTCONTA"    ,xConta           ,Nil    },;
						{"AUTDTBAIXA"  ,dDataBase              ,Nil    },;
						{"AUTDTCREDITO",dDataBase              ,Nil    },;
						{"AUTHIST"     ,"BAIXA AUTOMATICA SITEF"          ,Nil    },;
						{"AUTJUROS"    ,nJuros                    ,Nil,.T.},;
						{"AUTVALREC"   ,nValLiq          ,Nil    }}
		EndIf
		//Begin Transaction
			msExecAuto({|x,y| Fina070(x,y)},aBaixa,nOpc)
				If lMsErroAuto // OPERAÇÃO FOI EXECUTADA COM SUCESSO
					cError := MostraErro("\SYSTEM", "errorSITEF.log") // ARMAZENA A MENSAGEM DE ERRO
					ConOut("ExecAuto FINA070 com erro.")
					ConOut(cError)
					//DisarmTransaction()	
				Else // OPERAÇÃO EXECUTADA COM ERRO
					If (!IsBlind()) // COM INTERFACE GRÁFICA
						//MostraErro()
					Else // EM ESTADO DE JOB
						ConOut(PadC("ExecAuto FINA070 realizado com sucesso!", 80))
					EndIf
					//RollBackSX8()
				EndIf
			//End Transaction
	Else
		ConOut(xNum+" Titulo nao encontrado.")
	EndIf
	ConOut("Fim : "+Time())
Return cNum                 
