#include 'Protheus.ch'
#include 'Rwmake.ch'
#include 'Topconn.ch'

/*/{Protheus.doc} SLDSD4

Impressão de saldos para empenhos faltantes

@type function
@author Junior Bordin
@since 09/09/10

/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SLDSD4    ºAutor  ³Junior Bordin       º Data ³  09/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ impressão de saldos para empenhos faltantes                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10 - Modulo de PCP                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³ Colocado no programa o cabeçalho padrão do sistema protheusº±±
±±º          ³ Colocado a regua de processamento no relatorio para que    º±±
±±º          ³ o operador possa saber o que e onde esta processando .     º±±
±±º          ³ Alterações feita pelo Analista da Totvs IP Campinas        º±±
±±º          ³ Alexandre J. Conselvan dia 10/09/2010                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SLDSD4()

Private aReturn		:= { "Especial", 1," ", 1, 2, 1, " ",1 }
Private wnrel       := "SLDSD4"
Private nLin        := 80
Private aOrd        := {}
Private cString 	:= ""
Private nLastKey    := 0
Private nomeprog    := "SLDSD4"
Private tamanho     := "M"
Private nTipo       := 18
Private m_Pag       := 01

&& Chamada da função para a abertura da tela de parametros
u_Param()

&& Salva a Integridade dos dados de Saida
wnrel    := "SLDSD4"

&& Variaveis utilizadas para Impressao do Cabecalho e Rodape
wnrel := SetPrint(cString,nomeprog,"",@"Emissao Saldos de empenhos faltantes","","","SLDSD4",.F.,aOrd,.F.,tamanho,,.F.)

If nLastKey == 27
	Return
Endif

&& Saldo Por OP em Aberto
cQuery	:=	"SELECT "
cQuery	+=		"D4_COD, B1_DESC, B1_TIPO, D4_LOCAL, SUM( D4_QUANT ) AS QtdSolicitada, SB2.B2_QATU as SB2B2QATU "
cQuery	+=	"FROM "
cQuery	+=		RETSQLNAME("SD4") + " SD4 "
cQuery	+=		"LEFT JOIN " + RETSQLNAME("SC2") + " SC2 ON SC2.C2_FILIAL = '01' AND SC2.C2_NUM = Substring(D4_OP,1,6) and SC2.C2_ITEM = substring(D4_OP,7,2) and SC2.C2_SEQUEN = substring(D4_OP,9,3) and SC2.D_E_L_E_T_ = ' ' "
cQuery	+=		"LEFT JOIN " + RETSQLNAME("SB2") + " SB2 ON SB2.B2_FILIAL = '01' AND SB2.B2_COD = SD4.D4_COD AND SB2.B2_LOCAL = SD4.D4_LOCAL and SB2.D_E_L_E_T_ = ' ' "
cQuery	+=		"LEFT JOIN " + RETSQLNAME("SB1") + " SB1 ON SB1.B1_FILIAL = '01' AND SB1.B1_COD = SD4.D4_COD and SB1.D_E_L_E_T_ = ' ' "
cQuery	+=	"WHERE "
cQuery	+=		"SD4.D4_FILIAL = '01' AND SD4.D4_QUANT > 0 AND RTRIM(SC2.C2_DATRF) = '' AND SD4.D_E_L_E_T_ = ' ' and SC2.C2_DATPRF <= '" + Dtos(mv_par01) + "' and SB1.B1_TIPO <> 'MO' "
cQuery	+=	"GROUP BY "
cQuery	+=		"SB1.B1_TIPO, SD4.D4_COD, SD4.D4_LOCAL, SB2.B2_QATU, SB1.B1_DESC "
cQuery	+=	"ORDER BY "
cQuery	+=		"SB1.B1_TIPO, SD4.D4_COD "

TCQUERY cQuery ALIAS "QrySD4" NEW

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

&& Chamada da função que gera o realtorio com a regua de rolagem
RptStatus({|| SLDRSD4()},"Imprimindo relatorio....")

QrySD4->(DBCloseArea())

Set Device To Screen

SetPgEject(.F.)
If ( aReturn[5] == 1 )
	Set Printer TO
	DbcommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()


Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SLDRSD4   ºAutor  ³Alexandre Conselvan º Data ³  09/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Sub-Função para que o sistema exiga a regua de processamen-º±±
±±º          ³ to e a impressão dos valores do relatorio                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SLDRSD4()

dbSelectArea("QrySD4")
Count to nTmp
dbSelectArea("QrySD4")
dbGotop()

&& Carrega a variavel com a quantidade de registros a processar
SetRegua(nTmp)

While QrySD4->( !Eof() )
	
	&& Processa a Regua de Relatorio
	IncRegua()
	
	If nLin > 70
		&& Retirado o cabeçalho personalizado e colocado o cabeçalho padrão do protheus.
		cTitulo := "Relatório de Estoques Faltantes"
		cCabec1 := "Código              Descrição                        Tipo  Local        Qtd Solicitada         Qtd Disponivel       Qtd Disp O.Armz "
		cCabec2 := ""
		nTipo   := If(aReturn[4]==1,15,18)
		Cabec(cTitulo,cCabec1,cCabec2,nomeprog,tamanho,nTipo)
		nLin := 9
	EndIf

	if mv_par02 == "Todos"
	
	@ nlin , 000 Psay QrySD4->D4_COD
	@ nLin , 020 Psay substr( QrySD4->B1_DESC,1,30 )
	@ nLin , 055 Psay QrySD4->B1_TIPO
	@ nLin , 060 Psay QrySD4->D4_LOCAL
	@ nLin , 070 Psay transform( QrySD4->QtdSolicitada , "@E 9,999,999.99")
	@ nLin , 090 Psay transform( QrySD4->SB2B2QATU     , "@E 9,999,999.99")
	
	&& Saldo Por OP em Aberto
	cQuery	:=	"SELECT "
	cQuery	+=		"B2_COD, SUM( B2_QATU ) B2QATU "
	cQuery	+=	"FROM "
	cQuery	+=		RETSQLNAME("SB2") + " "
	cQuery	+=	"WHERE "
	cQuery  +=  	"B2_COD = '" + QrySD4->D4_COD + "' And B2_LOCAL <> '" + QrySD4->D4_LOCAL + "' "
	cQuery	+=	"GROUP BY "
	cQuery  +=  	"B2_COD "
	
	TCQUERY cQuery ALIAS "QrySB2" NEW
	
	@ nLin , 110 Psay transform( QrySB2->B2QATU  , "@E 9,999,999.99")
	
	QrySB2->(DBCloseArea())
	
	nLin ++
    Endif
    
    if mv_par02 == "Negativos"
    
		If QrySD4->QtdSolicitada > QrySD4->SB2B2QATU
		
		@ nlin , 000 Psay QrySD4->D4_COD
		@ nLin , 020 Psay substr( QrySD4->B1_DESC,1,30 )
		@ nLin , 055 Psay QrySD4->B1_TIPO
		@ nLin , 060 Psay QrySD4->D4_LOCAL
		@ nLin , 070 Psay transform( QrySD4->QtdSolicitada , "@E 9,999,999.99")
		@ nLin , 090 Psay transform( QrySD4->SB2B2QATU     , "@E 9,999,999.99")
	
		&& Saldo Por OP em Aberto
		cQuery	:=	"SELECT "
		cQuery	+=		"B2_COD, SUM( B2_QATU ) B2QATU "
		cQuery	+=	"FROM "
		cQuery	+=		RETSQLNAME("SB2") + " "
		cQuery	+=	"WHERE "
		cQuery  +=  	"B2_COD = '" + QrySD4->D4_COD + "' And B2_LOCAL <> '" + QrySD4->D4_LOCAL + "' "
		cQuery	+=	"GROUP BY "
		cQuery  +=  	"B2_COD "
	
		TCQUERY cQuery ALIAS "QrySB2" NEW
	
		@ nLin , 110 Psay transform( QrySB2->B2QATU  , "@E 9,999,999.99")
	
		QrySB2->(DBCloseArea())
	
		nLin ++
    	
		Endif
	
	Endif
	
	QrySD4->(dbSkip())
	
End

return()

User Function Param()

Local aPergs := {}
Local cDatAte := (ddatabase)
Local aRet := {}
Local lRet

aAdd( aPergs ,{1,"Data até : ",cDatAte,"@!",'.T.',,'.T.',40,.F.})
aAdd( aPergs ,{2,"Saldos", "Todos", {"Todos", "Negativos"}, 50,'.T.',.T.})

If ParamBox(aPergs ,"Parametros ",aRet)
	lRet := .T.
Else
	lRet := .F.
EndIf

Return lRet
