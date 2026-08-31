//#INCLUDE 'fivewin.ch'

#INCLUDE 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#Include "TOTVS.CH"
#include 'ap5mail.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FSFINBOL บAutor ณ Microsiga Sofware   บ Data ณ  11/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ BOLETO BANCARIO ( Imprime o boleto bancario )              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PROJETO : P00016                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
CAMPO: E1_SITUAC2
TIPO: CARACTERE
TAMANHO: 1
mascara: !
REAL, ALTERAR

TITULO: Situacao
DESCRICAO: Situacao do titulo
LISTA: 0=Carteira;1=Cob.Simples;2=Descontada;3=Caucionada;4=Vinculada;5=Advogado;6=Judicial
consulta f3 : situa็ใo de cobran็a
valida็ใo de usuario : pertence("0123456")
USADO.


ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
CAMPO: C5_TIPOPAG
TIPO: CARACTERE
TAMANHO: 3
REAL, ALTERAR
TITULO: Tipo Pgto
DESCRICAO: Tipo de Pagamento
LISTA: BOL=BOLETO;R$ =DINHEIRO;CH =CHEQUE
USADO.
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
campos a serem criados na SEE
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
CAMPO: EE_ARQCONF
TIPO: CARACTERE
TAMANHO: 15
REAL, ALTERAR, @!
TITULO: Arq. Config
DESCRICAO: Arquivo de configuracao
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
CAMPO: EE_ARQSAID
TIPO: CARACTERE
TAMANHO: 30
REAL, ALTERAR, @!
TITULO: Arq. Saida
DESCRICAO:arquivo de saida
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
CAMPO: EE_MODELO
TIPO: CARACTERE
TAMANHO: 8
REAL, ALTERAR, @!
TITULO:MODELO
DESCRICAO: MODELO
LISTA: Modelo 1;Modelo 2
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
CRIAR CONSULTA PADRAO NA TABELA SEE
COM 7 RETORNOS
RET1:SEE->EE_ARQCONF
RET2:SUBSTR(SEE->EE_ARQSAID,01,02)+SUBS(STRTRAN(DTOC(DDATABASE),"/",""),01,04)
RET3:SEE->EE_CODIGO
RET4:SEE->EE_AGENCIA
RET5:SEE->EE_CONTA
RET6:SEE->EE_SUBCTA
RET7:SEE->EE_MODELO
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ


ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
CALCULO DIGITO VERIFCADOR CODIGO DE BARRAS

Vejamos a seguir a linha digitแvel:

Banco	 Moeda	 CL 1-5	     DV	  CL 6-15	             DV	      CL 16-25	         DV	 DV	       FV	      VALOR
1 2 3	 4	    5 6 7 8 9	 0	 1 2 3 4 5 6 7 8 9 0	 1	 2 3 4 5 6 7 8 9 0 1     2	 3	 4 5 6 7	 8 9 0 1 2 3 4 5 6 7
Legenda:

CL - Campo Livre (varia de banco a banco).
DV - Dํgito Verificador (padrใo Febraban)
FV - Fator de Vencimento

Mแscara da linha digitแvel - 99999.9999-9 99999.99999-9 99999.99999-9 9 99999999999999

para se calcular o digito verificador de cada campo da linha digitavel deve-se

o calculo ้ feito por campo, o primeiro campo tem 9 digitos o restante tem 10 digitos

primeiro: de tras pra frente deve-se multiplicar cada digito alternando, um * por 2 outro * 1
comecando pelo dois, e depois efetuar a soma
se a multiplicacao der maior que 10 de 11 pra frente deve diminuir o resultado da multiplicacao de nove
se der 11 deve-se fazer 11 - 9 = 2 e usar o resultado da subtracao
ex.:

9  9  9  9  9 . 9  9  9  9  9 - 0
*  *  *  *  *   *  *  *  *  *
1  2  1  2  1   2  1  2  1  2
9+ 18+9+ 18+9   18+9+ 18+9+ 18 = 90
9    9      9     9     9

segundo pega o primeiro digito da soma e mais um
ex.:
90 = 9 + 1 = 10

terceiro pega-se o resultado e coloca um zero no final
ex.:
10 + 0 = 100

quarto pega-se o resultado e subtrai da soma encontrada anteriormente
ex.:
100 - 90 = 10

se o resultado for igual ou maior que 10 o digito ้ igual a 0
se nao, se for menor que 10 entao o digito ้ o numero encontrado.


ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ

aParametros[1]          //Do Prefixo
aParametros[2]          //At o Prefixo
aParametros[3]          //Do Tกtulo
aParametros[4]          //At o Tกtulo
aParametros[5]          //Do Banco
aParametros[6]          //At o Banco
aParametros[7]          //Do Cliente
aParametros[8]          //At o Cliente
aParametros[9]          //Da Loja
aParametros[10]         //At a Loja
aParametros[11]         //Do Vencimento
aParametros[12]         //At o Vencimento
aParametros[13]         //Da Emisso
aParametros[14]         //At a Emisso
aParametros[15]         //Selecionar Tกtulos
aParametros[16]         //Do Bordero
aParametros[17]         //At o Bordero

aParametros[18] //Banco para transferencia, caso o tํtulo ainda nใo tenha sido transferido.
aParametros[19] //Agencia
aParametros[20] //Conta

aParametros[21] //Tipo de Cobran็a, s๓ serใo aceitas 1-Simples ou 4-Vinculada/Registrada

aParametros[22] //Inibe a exibi็ใo da tela de sele็ใo dos tํtulos.
aParametros[23] //Tipo de Impressใo 1=Laser, 2=Deskjet (Passar como numerico)

*/

User Function FSFINBOL(_aTitulos1)

	Local cQuery		:= ''
	Local aArea 		:= GetArea()
	Local aAreaSE1		:= SE1->(GetArea())
	Local aAreaSX5		:= SX5->(GetArea())

	Local oBcoOrig
	Local oCboBox
	Local aSituacoes  	:= {}
	Local cCapital    	:= Space(55)
	Local cMvBcoBol		:= Space(20)
	Local nI			:= 0
	Local nP			:= 0

	Private cSituaca     := Space(25)
	Private cBcoOrig    := Space(3)
	Private cAgenOrig   := Space(5)
	Private cCtaOrig    := Space(10)
	Private cNomeBco     := Space(40)
	Private	lExec    	:= .F.
	Private	nQtdReg	:= 0
	Private	cPerg     	:= PADR('FSFINBOL',10,space(1))
	Private	cArqTemp	:= Criatrab(Nil,.F.)
	Private	aCpoBro 	:= {}
	Private	lInverte	:= .T.
	Private	cMarca    	:= GetMark()
	Private	lEnd		:= .f.
	Private lPortador   	:= .f.
	Private lSituacao   	:= .f.
	Private _Quebra     	:= Char(13) + Char(10)
	Private lInibeTela  	:= .f.
	Private aParametros 	:= {}
	Private cCompCart       := ""
	Private nValJuros   := 0
	Private lRetNewJur  := .F.
	Private nNewJuros   := 0
	Private dDate       := CtoD( "_/_/_" )
	Private dNewVencto  := CtoD( "_/_/_" )
	/*Private	aDadosEmp	:= {SM0->M0_NOMECOM,; //[1]Nome da Empresa
	SM0->M0_ENDCOB,; //[2]Endere็o
	AllTrim(SM0->M0_BAIRCOB)+', '+AllTrim(SM0->M0_CIDCOB)+', '+SM0->M0_ESTCOB ,; //[3]Complemento
	'CEP: '+Subs(SM0->M0_CEPCOB,1,5)+'-'+Subs(SM0->M0_CEPCOB,6,3),; //[4]CEP
	'PABX/FAX: '+SM0->M0_TEL,; //[5]Telefones
	'CNPJ: '+Subs(SM0->M0_CGC,1,2)+'.'+Subs(SM0->M0_CGC,3,3)+'.'+; //[6]
	Subs(SM0->M0_CGC,6,3)+'/'+Subs(SM0->M0_CGC,9,4)+'-'+; //[6]
	Subs(SM0->M0_CGC,13,2),; //[6]CGC
	'I.E.: ' + Subs(SM0->M0_INSC,1,3) + '.' + Subs(SM0->M0_INSC,4,3) + '.' +; //[7]
	Subs(SM0->M0_INSC,7,3) + '.' + Subs(SM0->M0_INSC,10,3)}  //[7]I.E

	*/

	IF !Empty( _aTitulos1 )
		aParametros := _aTitulos1
	EndIf
	DEFAULT aParametros := {}



	AjustaSx1(cPerg)

	If Len( aParametros ) = 0
		If	( !Pergunte(cPerg,.T.) )
			Return( Nil )
		EndIf
	Else
		Pergunte(cPerg,.F.)

		//Carrega os parametros pelo array passado.
		mv_par01 	:= aParametros[1]               //Do Prefixo
		mv_par02 	:= aParametros[2]               //At o Prefixo
		mv_par03 	:= aParametros[3]               //Do Tกtulo
		mv_par04 	:= aParametros[4]               //At o Tกtulo
		mv_par05 	:= aParametros[5]               //Do Banco
		mv_par06 	:= aParametros[6]               //At o Banco
		mv_par07 	:= aParametros[7]               //Do Cliente
		mv_par08 	:= aParametros[8]               //At o Cliente
		mv_par09 	:= aParametros[9]               //Da Loja
		mv_par10 	:= aParametros[10]              //At a Loja
		mv_par11 	:= aParametros[11]              //Do Vencimento
		mv_par12 	:= aParametros[12]              //At o Vencimento
		mv_par13 	:= aParametros[13]              //Da Emisso
		mv_par14 	:= aParametros[14]              //At a Emisso
		mv_par15 	:= aParametros[15]              //Selecionar Tกtulos
		mv_par16 	:= aParametros[16]              //Do Bordero
		mv_par17 	:= aParametros[17]              //At o Bordero
		mv_par18 	:= aParametros[18]				//Tipo de impressใo
		mv_par19 	:= aParametros[19]				//Do tipo de titulo
		mv_par20	:= aParametros[20]				//Ate tipo de titulo




		If Empty(aParametros[23]) //se o parametro banco estiver vazio, Seleciona o banco padrใo para emissใo.

			cMvBcoBol := GetNewPar('MV_BCOBOL','001')

			If Empty(cMvBcoBol)
				IW_MSGBOX('Banco padrใo para transfer๊ncia nใo informado! Verifique o Parโmetro MV_BCOBOL','Aten็ใo', "STOP")
				Return
			Else
				nP := 0
				For nI := 1 to Len(AllTrim(cMvBcoBol))
					if !(Substr(cMvBcoBol,nI,1) $ '/|#!')
						Do Case
							Case nP == 0
							cBcoOrig := AllTrim(cBcoOrig) + Substr(cMvBcoBol,nI,1)
							Case nP == 1
							cAgenOrig:= AllTrim(cAGenOrig) + Substr(cMvBcoBol,nI,1)
							Case nP == 2
							cCtaOrig := AllTrim(cCtaOrig) + Substr(cMvBcoBol,nI,1)
						EndCase
					Else
						nP++
					EndIf
				Next
			EndIf

			cQuery := "SELECT * "
			cQuery += "FROM "+ RetSQLName("SA6") + "  "
			cQuery += "WHERE  D_E_L_E_T_ != '*'   AND "
			cQuery += "A6_COD = '" + AllTrim(cBcoOrig) + "' AND "
			cQuery += "A6_AGENCIA = '" + AllTrim(cAgenOrig) + "' AND "
			cQuery += "A6_NUMCON = '" + AllTrim(cCtaOrig) + "' "

			If Select("BCO") > 0
				DBSelectArea("BCO")
				BCO->(DbCloseArea())
			EndIf
			TCQUERY cQuery NEW ALIAS "BCO"

			DBSelectArea("BCO")
			DBGoTop()

			if Empty("BCO")
				IW_MSGBOX('Banco padrใo para transfer๊ncia nใo Localizado! Verifique o Parโmetro MV_BCOBOL','Aten็ใo', "STOP")
				Return
			EndIf

			BCO->(DbCloseArea())

			DbSelectArea("SX5")
			If (dbSeek(xFilial("SX5")+"07"+aParametros[21]))
				cSituaca:= aParametros[21]+' '+SX5->X5_DESCRI //Tipo de Cobran็a ( 1 ou 4 )
			Else
				IW_MSGBOX('Situacao para transferencia nao localizado, verifique o parametro MV_SITBOL','Aten็ใo', "STOP")
				Return
			EndIf

		Else
			cBcoOrig := aParametros[23]               //Banco de Transferencia
			cAGenOrig:= aParametros[24]               //AGencia de Transferencia
			cCtaOrig := aParametros[25]               //Conta de Transferencia

			DbSelectArea("SX5")
			If (dbSeek(xFilial("SX5")+"07"+aParametros[21]))
				cSituaca:= aParametros[21]+' '+SX5->X5_DESCRI //Tipo de Cobran็a ( 1 ou 4 )
			Else
				IW_MSGBOX('Situacao para transferencia nao localizado, verifique o parametro MV_SITBOL','Aten็ใo', "STOP")
				Return
			EndIf
		EndIf

		//Se nใo houver nenhum banco informado, nใo pode inibir a tela.
		If !Empty(cBcoOrig)
			lInibeTela := aParametros[22]
		Else
			lInibeTela := .F.
		EndIf

	EndIf

	//Seta se vai trazer os titulos selecinados ou nao.
	lInverte := ( mv_par15 = 1 )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a tabela de situa็๖es de Tํtulos                                                                                                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX5")
	dbSeek(xFilial('SX5')+"07")
	While SX5->X5_FILIAL+SX5->X5_tabela == xFilial('SX5')+"07"

		If AllTrim(SX5->X5_CHAVE) $ ('1/4')  //Cobranca Simples e Cobranca Registrada
			cCapital := Capital(X5Descri())
			AADD( aSituacoes , SubStr(SX5->X5_CHAVE,1,2)+OemToAnsi(SubStr(cCapital,1,20)))
		EndIf

		dbSkip()
	EndDo

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampos que serao mostrados no browse.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCpoBro :=	{	{'E1_OK',,OemToAnsi(' '),' '},;
	{'E1_PREFIXO',,OemToAnsi('Prefixo'),'@!'},;
	{'E1_NUM',,OemToAnsi('Numero'),'@!'},;
	{'E1_NUMBOR',,OemToAnsi('Num. Bordero'),'@!'},;
	{'E1_PARCELA',,OemToAnsi('Parcela'),'@!'},;
	{'E1_TIPO',,OemToAnsi('Tipo'),'@!'},;
	{'A1_COD',,OemToAnsi('Cliente'),'@!'},;
	{'A1_LOJA',,OemToAnsi('Loja'),'@!'},;
	{'A1_NOME',,OemToAnsi('Nome'),'@!'},;
	{'E1_NUMBCO',,OemToAnsi('Num. Banco'),'@!'},;
	{'E1_PORTADO',,OemToAnsi('Portador'),'@!'},;
	{'E1_AGEDEP',,OemToAnsi('Ag. Dep.'),'@!'},;
	{'E1_CONTA',,OemToAnsi('Conta'),'@!'}	}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta a query com os registros a serem marcados.!ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery	:= "SELECT SE1.E1_OK, "
	cQuery	+= "SE1.E1_PREFIXO, "
	cQuery	+= "SE1.E1_NUM, "
	cQuery	+= "SE1.E1_NUMBOR, "
	cQuery	+= "SE1.E1_PARCELA, "
	cQuery	+= "SE1.E1_TIPO, "
	cQuery	+= "SA1.A1_COD, "
	cQuery	+= "SA1.A1_LOJA, "
	cQuery	+= "SA1.A1_NOME, "
	cQuery	+= "SA1.A1_EMAIL, "
	cQuery	+= "SE1.E1_NUMBCO, "
	cQuery	+= "SE1.E1_PORTADO, "
	cQuery	+= "SE1.E1_AGEDEP, "
	cQuery	+= "SE1.E1_CONTA, "
	cQuery	+= "SA1.A1_INSCR, "
	cQuery	+= "SA1.A1_CGC, "
	cQuery	+= "SE1.E1_SITUAC2 "
	cQuery	+= "FROM " + RetSqlName('SE1') + ' SE1, ' + RetSqlName('SA1') + ' SA1 '//+ RetSqlName('SC5') + ' SC5 '
	cQuery	+= "WHERE SA1.A1_COD =  SE1.E1_CLIENTE "
	cQuery	+= "AND SA1.A1_LOJA = SE1.E1_LOJA "
	cQuery	+= "AND SE1.E1_FILIAL = '" + xFilial('SE1') + "' "
	//	cQuery	+= "AND SE1.E1_NUM = SC5.C5_NUM"
	//	cQuery	+= "AND SC5.C5_FILIAL = '" + xFilial('SC5') + "' "
	cQuery	+= "AND SE1.E1_EMISSAO >= '" + Dtos(mv_par13) + "' "
	cQuery	+= "AND SE1.E1_EMISSAO <= '" + Dtos(mv_par14) + "' "
	cQuery	+= "AND SE1.E1_PREFIXO >= '" + mv_par01 + "' "
	cQuery	+= "AND SE1.E1_PREFIXO <= '" + mv_par02 + "' "
	cQuery	+= "AND SE1.E1_NUM >= '" + mv_par03 + "' "
	cQuery	+= "AND SE1.E1_NUM <= '" + mv_par04 + "' "
	cQuery	+= "AND SE1.E1_NUMBOR >= '" + mv_par16 + "' "
	cQuery	+= "AND SE1.E1_NUMBOR <= '" + mv_par17 + "' "
	cQuery	+= "AND SE1.E1_PORTADO >= '" + mv_par05 + "' "
	cQuery	+= "AND SE1.E1_PORTADO <= '" + mv_par06 + "' "
	cQuery	+= "AND SE1.E1_CLIENTE >= '" + mv_par07 + "' "
	cQuery	+= "AND SE1.E1_CLIENTE <= '" + mv_par08 + "' "
	cQuery	+= "AND SE1.E1_LOJA >= '" + mv_par09 + "' "
	cQuery	+= "AND SE1.E1_LOJA <= '" + mv_par10 + "' "
	cQuery	+= "AND SE1.E1_VENCREA >= '" + Dtos(mv_par11) + "' "
	cQuery	+= "AND SE1.E1_VENCREA <= '" + Dtos(mv_par12) + "' "
	cQuery	+= "AND SE1.E1_TIPO >= '" + mv_par19 + "' "
	cQuery	+= "AND SE1.E1_TIPO <= '" + mv_par20 + "' "
	cQuery	+= "AND SE1.E1_SALDO > 0 "
	cQuery	+= "AND SE1.D_E_L_E_T_ <> '*' "
	cQuery	+= "AND SA1.A1_FILIAL = '" + xFilial('SA1') + "' "
	cQuery	+= "AND SA1.D_E_L_E_T_ <> '*' "

	//Rech Tratores - Nao Mostrar titulos em situacao de desconto
	cQuery   += "AND SE1.E1_SITUACA NOT IN ('2','7') "

	cQuery	+= "ORDER BY SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO "
	cQuery	:= ChangeQuery(cQuery)

	MemoWrite("c:\temp\boleto.txt", cQuery)

	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TRA',.F.,.T.)

	DbSelectArea('TRA')
	Count to nQtdReg
	TRA->(DbGoTop())

	Copy to &cArqTemp

	TRA->(DbCloseArea())

	DbUseArea(.t.,,cArqTemp,'TRA',Nil,.f.)
	TRA->(DbGoTop())


	If !lInibeTela
		DEFINE MSDIALOG oDlg TITLE OemToAnsi('Sele็ใo dos Tํtulos para impressใo dos Boletos.') From 001,001 To 400,700 Of oMainWnd Pixel
		oMark:=MsSelect():New('TRA','E1_OK',,aCpoBro,@lInverte,@cMarca,{5,5,165,345})
		oMark:oBrowse:Refresh()

		@ 170, 010 SAY 'Banco/Ag๊ncia/Conta para transfer๊ncia' OF oDlg PIXEL
		@ 170, 185 SAY 'Situa็ใo' OF oDlg PIXEL
		@ 180, 010 MSGET oBcoOrig VAR cBcoOrig  Picture "@S3"  F3 "SA6" Valid {|| CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.,,.F.), cNomeBco := If( AllTrim(cBcoOrig) <> '', Posicione('SA6',1,xFilial('SA6')+cBcoOrig+cAgenOrig+cCtaOrig,'A6_NOME') , '' ) }  SIZE 25, 08 OF oDlg PIXEL
		@ 180, 039 MSGET cAgenOrig              Picture "@S5"           WHEN .F. Valid {|| CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.,,.T.),.F.}                          SIZE 20, 08 OF oDlg PIXEL
		@ 180, 068 MSGET cCtaOrig               Picture "@S10"          WHEN .F. Valid {|| If(CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.,,.T.),.T.,oBcoOrig:SetFocus()),.F.} SIZE 45, 08 OF oDlg PIXEL
		@ 180, 113 MSGET cNomeBco               WHEN {|| cNomeBco := If( AllTrim(cBcoOrig) <> '', Posicione('SA6',1,xFilial('SA6')+cBcoOrig+cAgenOrig+cCtaOrig,'A6_NOME') , '' ), .F. } SIZE 70,08 OF oDlg PIXEL
		@ 180, 185 COMBOBOX oCboBox VAR cSituaca ITEMS aSituacoes WHEN IF( Len(aParametros) >= 18 , AllTrim(aParametros[18])=='' , .T. ) Size 82,46 OF oDlg PIXEL

		oCboBox:nAt := 2
		oCboBox:bWhen:= {|| .f. }

		DEFINE SBUTTON FROM 180, 280 TYPE 01 ACTION (If(TudoOK(oDlg),(lExec:=.T.,oDlg:End()),lExec:=.F.)) ENABLE Of oDlg
		DEFINE SBUTTON FROM 180, 310 TYPE 02 ACTION (FERASE(cArqTemp  + GetDBExtension()),oDlg:End()) ENABLE Of oDlg
		ACTIVATE MSDIALOG oDlg CENTERED

	Else
		lExec := .T.
	EndIf

	TRA->(DbGoTop())

	If	lExec
		Processa({ |lEnd| MontaRel()})
	EndIf

	TRA->(DbCloseArea())

	RetIndex("SE1")
	Ferase(cArqTemp+GetDbExtension())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRetoma a area anterior ao processamento. !ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	RestArea(aAreaSX5)
	RestArea(aAreaSE1)
	RestArea(aArea)

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MONTAREL บAutor ณ JULIO STORINO       บ Data ณ  15/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaRel()

	Private	oPrint
	Private	nX			:= 0
	Private	cNroDoc 	:= ''
	Private	cConvenio	:= ''
	Private	cSeqCart	:= ''
	Private	cCarteira	:= ''
	Private	cCompCart   := ''
	Private	cDigCta     := ''
	Private	nI          := 1
	Private	aCB_RN_NN   := {}
	Private	nVlrAbat	:= 0
	Private	cQuery      := ''
	Private	cSituant    := ''
	Private	aDadosFat	:= {}	// Dados da Fatura
	Private	aDadosEmp	:= { Substr( SM0->M0_NOMECOM , 1 , 41 ),; //[1]Nome da Empresa
	SM0->M0_ENDCOB,; //[2]Endere็o
	AllTrim(SM0->M0_BAIRCOB)+', '+AllTrim(SM0->M0_CIDCOB)+', '+SM0->M0_ESTCOB ,; //[3]Complemento
	'CEP: '+Subs(SM0->M0_CEPCOB,1,5)+'-'+Subs(SM0->M0_CEPCOB,6,3),; //[4]CEP
	'PABX/FAX: '+SM0->M0_TEL,; //[5]Telefones
	'CNPJ: '+Subs(SM0->M0_CGC,1,2)+'.'+Subs(SM0->M0_CGC,3,3)+'.'+; //[6]
	Subs(SM0->M0_CGC,6,3)+'/'+Subs(SM0->M0_CGC,9,4)+'-'+; //[6]
	Subs(SM0->M0_CGC,13,2),; //[6]CGC
	'I.E.: '+Subs(SM0->M0_INSC,1,3)+'.'+Subs(SM0->M0_INSC,4,3)+'.'+; //[7]
	Subs(SM0->M0_INSC,7,3)+'.'+Subs(SM0->M0_INSC,10,3)}  //[7]I.E*/
	Private	aDadosTit	:= {}
	Private	aDadosBanco := {}
	Private	aDatSacado  := {}
	Private	aDadosBol   := {} // Dados do Boleto
	Private	aBolText    := {}

	//Monta o boleto
	RelPad()

Return


Static Function RelPad()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia o processo de impressao dos boletos. !ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (Len(aParametros) = 0) .OR. (Len(aParametros) <> 0 .AND. (GetNewPar('MV_IMPBOL',1) <> 3))
		oPrint := TMSPrinter():New('Impressใo de Boleto Bancแrio')
		oPrint:SetPortrait()
		oPrint:StartPage() //Inicia primeira pแgina
	EndIF

	TRA->(DbGoTop())
	ProcRegua(nQtdReg) //Exibe regua de processamento

	While TRA->( ! Eof() )

		If	( lEnd )
			If	MsgYesNo(OemToAnsi('Deseja abortar impressใo ?'))
				Exit
				Return( Nil )
			EndIf
		EndIf

		If	TRA->(Marked('E1_OK')) //Se o titulo foi selecionado para emissao de boleto

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPosiciona no titulo que sera processado.!ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			DbSelectArea('SE1')
			SE1->(DbSetOrder(1))
			If	! SE1->(DbSeek(xFilial('SE1') + TRA->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
				TRA->(DbSkip())
				Loop
			EndIf

			//Verifico se a data de vencimento estแ atrasada
			If Mv_Par21 == 1
				If dDataBase > SE1->E1_VENCREA
					//Atualizo a data de vencimento e o Juros
					If ( lRetNewJur := SFNewDate( @dDate , @nNewJuros ) )
						dNewVencto := @dDate
						nValJuros  := @nNewJuros
					Else
						Return ( Nil )
					EndIf
				EndIf
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica a carteira do titulo !ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If	'001' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO DO BRASILณ
				//ณ 17- REGISTRADOณ
				//ณ 18- SIMPLES   ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= IF( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','18','17')

			ElseIf	'033' == IIF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO SANTANDER   ณ
				//ณ 101 - REGISTRADO ณ
				//ณ 102 - S/ REGISTROณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= IF( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','102','101')
			ElseIf	'104' == IIF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO CEF         ณ
				//ณ CR- CART RAPIDA  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= '9' //Iif( (IIF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','??','9')

			ElseIf	'COB' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO DO BRASILณ
				//ณ 17- REGISTRADOณ
				//ณ 18- SIMPLES   ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= IF( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','18','17')
			ElseIf	'RED' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO BRADESCO   ณ
				//ณ006 - SIMPLES    ณ
				//ณ009 - REGISTRADO ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= Iif( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','07','09')
			ElseIf	'224' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO FIBRA      ณ
				//ณ006 - SIMPLES    ณ
				//ณ009 - REGISTRADO ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= Iif( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','00','19')
			ElseIf	'246' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO FIBRA      ณ
				//ณ006 - SIMPLES    ณ
				//ณ009 - REGISTRADO ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= Iif( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','00','009')
			ElseIf	'237' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO BRADESCO   ณ
				//ณ 06 - SIMPLES    ณ
				//ณ 09 - REGISTRADO ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= Iif( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','06','09')
			ElseIf	'320' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO BIC        ณ
				//ณ??? - SIMPLES    ณ
				//ณ 19 - REGISTRADO ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= Iif( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','000','09')
			ElseIf	'341' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO ITAU       ณ
				//ณ??? - SIMPLES    ณ
				//ณ109 - REGISTRADO ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= Iif( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','000','109')
			ElseIf	'356' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO REAL       ณ
				//ณ 20 - SIMPLES    ณ
				//ณ    - REGISTRADO ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= Iif( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','20','00')
			ElseIf	'399' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO HSBC        ณ
				//ณ CNR- CNR NORMAL  ณ
				//ณ CNR- CNR SIMPLES ณ
				//ณ    - REGISTRADO  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= Iif( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','CSB','019')
			ElseIf	'453' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO RURAL      ณ
				//ณ016 - SIMPLES    ณ
				//ณ019 - REGISTRADO ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= Iif( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','09','19')
			ElseIf '748' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO SICREDI    ณ
				//ณ 1  - SIMPLES    ณ
				//ณ    - REGISTRADO ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= Iif( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','1','1')
			ElseIf '756' == IF( Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) ), cBcoOrig, SE1->E1_PORTADO )
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณBANCO SICOOB     ณ
				//ณ 1  - SIMPLES    ณ
				//ณ    - REGISTRADO ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cCarteira	:= IF( (IF( Empty(SE1->E1_SITUAC2) .or. ( (SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)) .and. !Empty(cSituaca) ), Substr(cSituaca,1,1), SE1->E1_SITUAC2 )) == '1','01','02')

			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPosiciona na Arq de Parametros CNAB para ver se hแ informacoes      ณ
			// Verifica se o Tํtulo jแ tem portador, senใo pega o da transferencia.ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			DbSelectArea('SEE')
			SEE->(DbSetOrder(1))

			If Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) )
				IF !SEE->(DbSeek(xFilial('SEE')+SE1->(cBcoOrig+cAgenOrig+Padr(cCtaOrig,10,space(1))+padr(cCarteira,3,space(1))),.T.))
					//	IW_MSGBOX('Aten็ใo, Bco/Ag/Cta [' + cBcoOrig + '/' + cAgenOrig +'/' + AllTrim(cCtaOrig) + '], da carteira ['+ cCarteira + '] Nใo possui parโmetros cadastrados !, Favor Veriricar!','Aten็ใo', "STOP")
					//Exit
					//Return
				EndIf
			Else
				IF !SEE->(DbSeek(xFilial('SEE')+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA+padr(cCarteira,3,space(1))),.T.))
					//	IW_MSGBOX('Aten็ใo, Bco/Ag/Cta [' + SE1->E1_PORTADO + '/' + SE1->E1_AGEDEP +'/' + AllTrim(SE1->E1_CONTA) + '], da carteira ['+ cCarteira + '] Nใo possui parโmetros cadastrados !, Favor Veriricar!','Aten็ใo', "STOP")
					//Exit
					//	Return
				EndIf
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica Faixa Inicial e Final de Impressใo           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If (VAL(SEE->EE_FAXATU) < VAL(SEE->EE_FAXINI)) .OR. (VAL(SEE->EE_FAXATU) > VAL(SEE->EE_FAXFIM))
				IW_MSGBOX('Aten็ใo, Bco/Ag/Cta [' + SE1->E1_PORTADO + '/' + SE1->E1_AGEDEP +'/' + AllTrim(SE1->E1_CONTA) + '], da carteira ['+ cCarteira + '] esgotou a faixa de impressใo!, Favor Veriricar!','Aten็ใo', "STOP")
				Exit
				Return( Nil )
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณTransfere o titulo para o portador informado caso sejaณ
			//ณnecessแrio.                                           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If Empty(SE1->E1_PORTADO) .or. ( (SE1->E1_PORTADO <> cBcoOrig) .and. !Empty(cBcoOrig) )
				cSituant := SE1->E1_SITUAC2
				RecLock('SE1',.f.)

				Replace SE1->E1_PORTADO With cBcoOrig
				Replace SE1->E1_AGEDEP  With cAgenOrig
				Replace SE1->E1_CONTA   With cCtaOrig

				//Limpa o Campo E1_NUMBCO pois tem que pegar nova numera็ใo
				Replace SE1->E1_NUMBCO With ''

				If SE1->E1_SITUAC2 <> Substr(cSituaca,1,1)
					Replace SE1->E1_SITUAC2 With Substr(cSituaca,1,1)
				Endif

				//Criar um parโmetro para definir esta regra, jแ transfere a situacao do titulo para simples quanto for
				//este tipo de cobranca, ou deixa no 0-carteira e usa-se o bordero tamb้m para titulos simpes.
				If (GetNewPar('MV_TRFCART',.F.)) .And. (SE1->E1_SITUACA <> Substr(cSituaca,1,1)) .AND. (Substr(cSituaca,1,1) == '1')
					Replace SE1->E1_SITUACA With '1'
				EndIf

				SE1->(MsUnlock())

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณGrava a transferencia do titulo na tabela de titulos  ณ
				//ณenviados ao banco (                                   ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If RecLock('SEA',.T.)
					Replace SEA->EA_NUMBOR  With STRTRAN( TIME() , ':', '' )
					Replace SEA->EA_FILIAL  With xFilial('SEA')
					Replace SEA->EA_FILORIG With cFilAnt
					Replace SEA->EA_PREFIXO With SE1->E1_PREFIXO
					Replace SEA->EA_NUM     With SE1->E1_NUM
					Replace SEA->EA_PARCELA With SE1->E1_PARCELA
					Replace SEA->EA_PORTADO With SE1->E1_PORTADO
					Replace SEA->EA_AGEDEP  With SE1->E1_AGEDEP
					Replace SEA->EA_TIPO    With SE1->E1_TIPO
					Replace SEA->EA_CART    With 'R'
					Replace SEA->EA_NUMCON  With SE1->E1_CONTA
					Replace SEA->EA_SITUACA With SE1->E1_SITUACA
					Replace SEA->EA_SITUANT With cSituant
					SEA->(MsUnlock())
				Else
					If (Len(aParametros) = 0)
						Alert(OemToAnsi('Nใo foi possํvel gravar a transfer๊ncia do tํtulo, mas o processo continuarแ !'))
					Else
						ConOut(OemToAnsi('Nใo foi possํvel gravar a transfer๊ncia do tํtulo, mas o processo continuarแ !'))
					EndIf
				EndIf

			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica se o sistema esta preparado ou nao para imprimirณ
			//ณdependendo do portador...                                ณ
			//ณEste RdMake Imprime boletos dos seguintes banco...       ณ
			//ณ Brasil, Bradesco, Itau, Real, HSBC, Sicredi             ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If	( ! SE1->E1_PORTADO $ '001/COB/RED/033/224/246/237/320/341/356/399/453/748/104/756' ) .or. ( ! SE1->E1_SITUAC2 $ '14' )
				If (Len(aParametros) = 0)
					Alert(OemToAnsi('O Titulo: '+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+', nใo estแ preparado para impressใo. Verifique o Portador do titulo.'))
				Else
					ConOut(OemToAnsi('O Titulo: '+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+', nใo estแ preparado para impressใo. Verifique o Portador do titulo.'))
				EndIf
				TRA->(DbSkip())
				Loop
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPosiciona o SA6 (Bancos)ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			DbSelectArea('SA6')
			SA6->(DbSetOrder(1))
			SA6->(DbSeek(xFilial('SA6') + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA,.T.))

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPosiciona na Arq de Parametros CNABณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			DbSelectArea('SEE')
			SEE->(DbSetOrder(1))
			SEE->(DbSeek(xFilial('SEE') + SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA+padr(cCarteira,3,space(1)),.T.)) // STAN 14/08
			//	SEE->(DbSeek(xFilial('SEE') + SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA+cCarteira,.T.))
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//Se a Faixa Inicial for Zero ou vazia, entao passo para 1.
			//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

			//	If Empty(SEE->EE_BCOCOR)
			aDadosEmp := {SM0->M0_NOMECOM,; //[1]Nome da Empresa
			SM0->M0_ENDCOB,; //[2]Endere็o
			AllTrim(SM0->M0_BAIRCOB)+', '+AllTrim(SM0->M0_CIDCOB)+', '+SM0->M0_ESTCOB ,; //[3]Complemento
			'CEP: '+Subs(SM0->M0_CEPCOB,1,5)+'-'+Subs(SM0->M0_CEPCOB,6,3),; //[4]CEP
			'PABX/FAX: '+SM0->M0_TEL,; //[5]Telefones
			'CNPJ: '+Subs(SM0->M0_CGC,1,2)+'.'+Subs(SM0->M0_CGC,3,3)+'.'+; //[6]
			Subs(SM0->M0_CGC,6,3)+'/'+Subs(SM0->M0_CGC,9,4)+'-'+; //[6]
			Subs(SM0->M0_CGC,13,2),; //[6]CGC
			'I.E.: '+Subs(SM0->M0_INSC,1,3)+'.'+Subs(SM0->M0_INSC,4,3)+'.'+; //[7]
			Subs(SM0->M0_INSC,7,3)+'.'+Subs(SM0->M0_INSC,10,3)}  //[7]I.E
			/*Else
			aDadosEmp := {SA6->A6_NOME,; //[1]Nome da Empresa
			SA6->A6_END,; //[2]Endere็o
			AllTrim(SA6->A6_BAIRRO)+', '+AllTrim(SA6->A6_MUN)+', '+SA6->A6_EST ,; //[3]Complemento
			'CEP: '+Subs(SA6->A6_CEP,1,5)+'-'+Subs(SA6->A6_CEP,6,3),; //[4]CEP
			'PABX/FAX: '+SA6->A6_TEL,; //[5]Telefones
			'CNPJ: '+Subs(SA6->A6_CGC,1,2)+'.'+Subs(SA6->A6_CGC,3,3)+'.'+; //[6]
			Subs(SA6->A6_CGC,6,3)+'/'+Subs(SA6->A6_CGC,9,4)+'-'+; //[6]
			Subs(SA6->A6_CGC,13,2),; //[6]CGC
			' '}  //[7]I.E
			EndIf*/

			If !Empty(SEE->EE_FAXATU)
				If Val(SEE->EE_FAXATU) = 0
					RecLock('SEE',.F.)
					SEE->EE_FAXATU := StrZero(1,12)
					MsUnlock()
				EndIf
			Else
				RecLock('SEE',.F.)
				SEE->EE_FAXATU := StrZero(1,12)
				MsUnlock()
			EndIF


			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAqui defino parte do nosso numero.                                          ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If	( Empty(SE1->E1_NUMBCO) )

				Do Case
					Case SEE->EE_CODIGO $ '001'
					cConvenio := AllTrim(SEE->EE_CODEMP)
					cSeqCart	 := StrZero(Val(SEE->EE_FAXATU),12)
					Case SEE->EE_CODIGO = '033' //Banco Santander
					cSeqCart  := StrZero(Val(SEE->EE_FAXATU),12)
					Case SEE->EE_CODIGO = '104' //CAIXA ECONOMICA  // ANDRE VICENTE
					cSeqCart	 := AllTrim(SEE->EE_FAXATU)
					Case SEE->EE_CODIGO $ '224/246/320/453/RED'
					cConvenio := SUBST(SEE->EE_FAXATU,2,3)
					cSeqCart	 := StrZero(Val(SEE->EE_FAXATU),12)
					Case SEE->EE_CODIGO = '237' //Banco Bradesco
					cSeqCart  := AllTrim(SEE->EE_FAXATU)

					Case SEE->EE_CODIGO = '341'
					cConvenio := AllTrim(SEE->EE_SUBCTA)
					cSeqCart	 := StrZero(Val(SEE->EE_FAXATU),12)
					Case SEE->EE_CODIGO = '356'
					cSeqCart	 := StrZero(Val(SEE->EE_FAXATU),12)
					Case SEE->EE_CODIGO = '399'
					cConvenio := AllTrim(SEE->EE_CODEMP)
					cSeqCart	 := StrZero(Val(SEE->EE_FAXATU),12)

					Case SEE->EE_CODIGO = '748' //Banco Sicredi  - ANDRE VICENTE
					nSeqCart     := Val(SEE->EE_FAXATU)
					cSeqCart	 := StrZero(nSeqCart,5)

					Case SEE->EE_CODIGO = '756'  // SICOOB  - andre vicente
					cConvenio    := AllTrim(SEE->EE_CODEMP)
					cSeqCart	 := AllTrim(SEE->EE_FAXATU)

				EndCase

				Do Case
					Case SEE->EE_CODIGO $ '033'  //SANTANDER
					cNroDoc		:= cSeqCart
					Case SEE->EE_CODIGO $ '224/246/320/453/RED'  //BRADESCO
					cNroDoc		:= cConvenio + StrZero(Val(Substr(cSeqCart,5,9)),11-Len(cConvenio))
					//  cNroDoc		:= StrZero(Val(Substr(cSeqCart,2,11)))
					Case SEE->EE_CODIGO $ '341'  //ITAU
					cNroDoc		:= cConvenio + StrZero(Val(Substr(cSeqCart,5,9)),11-Len(cConvenio)) // 109 + 00180046  10900180046
					Case SEE->EE_CODIGO = '356'   //REAL
					cNroDoc		:= StrZero(Val(Substr(cSeqCart,8,6)),7)
					Case SEE->EE_CODIGO $ '399'  //HSBC
					cNroDoc		:= cConvenio + StrZero(Val(Substr(cSeqCart,5,9)),10-Len(cConvenio))
					Case SEE->EE_CODIGO = '104'   //CAIXA  -INCLUIDO POR  ANDRE VICENTE
					cNroDoc		:= Substr(cSeqCart,4,9)
					Case SEE->EE_CODIGO $ '756'     //SICOOB - INCLUIDO POR ANDRE VICENTE
					cNroDoc		:=  Substr(cSeqCart,8,5)

					Case SEE->EE_CODIGO $ '748'  //SICREDI - ANDRE VICENTE
					// cNroDoc		:= Substr(cSeqCart,4,9)
					cNroDoc		:= cSeqCart
					OtherWise
					cNroDoc		:= StrZero( Val( cConvenio ) , 6 ) + cSeqCart
				EndCase

				Do Case
					Case SEE->EE_CODIGO $ '001/COB'  //BRASIL
					Do Case
						Case Len(cConvenio) = 6
						cNroDoc		:= cConvenio + StrZero(Val(Substr(cSeqCart,5,9)),11-Len(cConvenio))
						Case Len(cConvenio) = 7
						cNroDoc		:= AllTrim( cConvenio ) + AllTrim( substr(cSeqCart,3,10) )
					EndCase
				EndCase

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza a tabela com o numero do proximo boleto. !ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If RecLock('SEE',.F.)
					Replace SEE->EE_FAXATU With Soma1( SEE->EE_FAXATU )
					MsUnLock()
				Else
					Help('',1,'REGNOIS')
				EndIf

			Else

				If SEE->EE_CODIGO $ '033'
					cNroDoc	:= AllTrim(Substr( SE1->E1_NUMBCO , 1 , 12 ) )
				ElseIf SEE->EE_CODIGO $ '001' .And. Len( AllTrim( SEE->EE_CODEMP ) ) == 7
					cNroDoc	:= AllTrim( SEE->EE_CODEMP ) + AllTrim( SE1->E1_NUMBCO )
				Else
					cNroDoc	:= AllTrim( SE1->E1_NUMBCO )
				EndIf

				cConvenio 	:= AllTrim(SEE->EE_CODEMP)

			EndIf

			// cCompCart

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSe for banco do brasil, apos a carteira vai um complementoณ
			//ณex: 17-019.                                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If SA6->A6_COD $ '001'
				cCompCart := '-019'
			Else
				cCompCart := ''
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSe for banco Real o digito da conta e um calculo usando   ณ
			//ณmodulo 10 composto de agencia+conta+nosso_numero          ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

			If SA6->A6_COD $ '341/356'

				cDigCta := U_DIGIT001( cNroDoc + SubStr(SA6->A6_AGENCIA,1,4) + StrZero(Val( SubStr(SA6->A6_NUMCON,1,If(At('-',SA6->A6_NUMCON) # 0,At('-',SA6->A6_NUMCON)-1,Len(AllTrim(SA6->A6_NUMCON))-1)) ),7) )
			Else

				IF SA6->A6_COD $ '001' .And. SubStr(SA6->A6_NUMCON,1,4) $ '6129'
					cDigCta := U_DIGIT001( cNroDoc + SubStr(SA6->A6_AGENCIA,1,4) + StrZero(Val( SubStr(SA6->A6_NUMCON,1,If(At('-',SA6->A6_NUMCON) # 0,At('-',SA6->A6_NUMCON)-1,Len(AllTrim(SA6->A6_NUMCON))-1)) ),7) )
					// cDigCta := SA6->A6_DVCTA  //  SA6->A6_DVCTA
				EndIf
			EndIf

			// [1] Numero do Banco
			// [2] Nome do Banco
			// [3] Agencia
			// [4] Conta Corrente
			// [5] Digito da conta corrente
			// [6] Codigo da Carteira
			// [7] Logotipo do banco
			// [8] C๓digo da Empresa dos Parโmetros Bancแrios
			// [9] C๓digo da Cobran็a Eletr๔nica dos Parโmetros Bancแrios


			If SA6->A6_COD $ '104'

				aDadosBanco  := {SA6->A6_COD,;
				SA6->A6_NREDUZ,;
				SubStr(SA6->A6_AGENCIA,1,4),;
				SubStr(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))),;
				cDigCta,;
				cCarteira,;
				AllTrim(SA6->A6_NREDUZ)+'.BMP',;
				SEE->EE_CODCOBE,;
				SEE->EE_CODEMP,}
				//	 AllTrim(SA1->A1_COD)+'-'+SA1->A1_LOJA,;
			ElseIf SA6->A6_COD $ '237'
				aDadosBanco  := {SA6->A6_COD,;
				SA6->A6_NREDUZ,;
				SubStr(AllTrim(SA6->A6_AGENCIA),2,5),;
				SubStr(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))),;
				cDigCta,;
				cCarteira,;
				AllTrim(SA6->A6_NREDUZ)+'.BMP',;
				SEE->EE_CODCOBE,;
				SEE->EE_CODEMP,}
				//	 AllTrim(SA1->A1_COD)+'-'+SA1->A1_LOJA,;
			ElseIf SA6->A6_COD $ '001' // xavier 27/08
				aDadosBanco  := {SA6->A6_COD,;
				SA6->A6_NREDUZ,;
				SubStr(SA6->A6_AGENCIA,1,5),;  // 1856-2
				SubStr(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))),;
				cDigCta,;
				cCarteira,;
				AllTrim(SA6->A6_NREDUZ)+'.BMP',;
				SEE->EE_CODEMP,;
				SEE->EE_CODCOBE,}
			ELSE
				aDadosBanco  := {	SA6->A6_COD,;
				SA6->A6_NREDUZ,;
				SubStr(SA6->A6_AGENCIA,1,4),;
				SubStr(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))),;
				cDigCta,;
				cCarteira,;
				AllTrim(SA6->A6_NREDUZ)+'.BMP',;
				SEE->EE_CODEMP,;
				SEE->EE_CODCOBE,}

				//	IIF(Empty(SEE->EE_BCOCOR), SEE->EE_BCOCOR, SA6->A6_COD),;
				//	SEE->EE_ZCIP}
			ENDIF

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPosiciona o SA1 (Cliente)ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			DbSelectArea('SA1')
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial('SA1')+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.))

			// [1] Razao Social
			// [2] Codigo
			// [3] Endere็o
			// [4] Cidade
			// [5] Estado
			// [6] CEP
			// [7] CGC
			// [8] PESSOA
			//  [9] EMAIL

			If	Empty(SA1->A1_ENDCOB)
				aDatSacado   := {AllTrim(SA1->A1_NOME),;
				AllTrim(SA1->A1_COD)+'-'+SA1->A1_LOJA,;
				AllTrim(SA1->A1_END)+' - '+AllTrim(SA1->A1_BAIRROC),;
				AllTrim(SA1->A1_MUNC),;
				SA1->A1_ESTC,;
				SA1->A1_CEP,;
				SA1->A1_CGC,;
				SA1->A1_PESSOA,;
				SA1->A1_EMAIL}
			Else
				aDatSacado   := {AllTrim(SA1->A1_NOME),;
				AllTrim(SA1->A1_COD)+'-'+SA1->A1_LOJA,;
				AllTrim(SA1->A1_END)+' - '+AllTrim(SA1->A1_BAIRRO),;
				AllTrim(SA1->A1_MUN),;
				SA1->A1_EST,;
				SA1->A1_CEP,;
				SA1->A1_CGC,;
				SA1->A1_PESSOA,;
				SA1->A1_EMAIL}
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPosiciona o SE1 (Contas a receber)ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			DbSelectArea('SE1')
			nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,'R',1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
			DbSelectArea('SE1')


			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณMonta codigo de barrasณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

			If	( AllTrim(SE1->E1_PORTADO) $ '001/COB' )  // BANCO DO BRASIL
				If Len(cConvenio) = 6
					aCB_RN_NN := xBBVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
					Subs(aDadosBanco[1],1,3),Subs(aDadosBanco[3],1,4),aDadosBanco[4],aDadosBanco[5]	,;
					cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9')
				Else
					aCB_RN_NN := xBBVerfBa7(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
					Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5]	,;
					cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9',cConvenio)
				EndIf
			ElseIf	( AllTrim(SE1->E1_PORTADO) == '033' )		//SANTANDER
				aCB_RN_NN := xSanVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
				Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5]	,;
				cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9',aDadosBanco[8])
			ElseIf	( AllTrim(SE1->E1_PORTADO) == '224' )		//FIBRA
				aCB_RN_NN := xBraVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
				Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5]	,;
				cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9')
				//Incluido por Tatiane Minamiya - altera็ใo feita pela J2A
			ElseIf	( AllTrim(SE1->E1_PORTADO)== '246' )		//ABC
				aCB_RN_NN := xAbcVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
				Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5]	,;
				cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9')
			ElseIf	( AllTrim(SE1->E1_PORTADO) $ '237/453/RED' )		//BRADESCO
				aCB_RN_NN := xBraVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
				Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5]	,;
				cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9',IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA ),aDadosBanco[8])
			ElseIf	( AllTrim(SE1->E1_PORTADO) == '320' )		//BIC
				aCB_RN_NN := xBraVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
				Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5]	,;
				cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9')
			ElseIf	( AllTrim(SE1->E1_PORTADO) == '341' )		//ITAU
				aCB_RN_NN := xItaVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
				Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5]	,;
				cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9')
			ElseIf	( AllTrim(SE1->E1_PORTADO) == '356' )		//ITAU
				aCB_RN_NN := xReaVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
				Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5]	,;
				cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9')
			ElseIf	( AllTrim(SE1->E1_PORTADO) == '399' )		//HSBC
				aCB_RN_NN := xHsbVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
				Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5]	,;
				cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9',IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA ),aDadosBanco[8])
			ElseIf	( AllTrim(SE1->E1_PORTADO) == '748' )		//SICREDI
				aCB_RN_NN := xSicVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
				Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],;
				cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9',IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA ),aDadosBanco[8],aDadosBanco[9])

				//Incluido por Andre Vicente 756 - SICOOB

			ElseIf	( AllTrim(SE1->E1_PORTADO) == '756' )		//SICOOB
				aCB_RN_NN := xSicoVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
				Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],;
				cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9',IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA ),aDadosBanco[8],aDadosBanco[9])

				//Incluido por Andre Vicente 104 CAIXA ECONOMICA FEDERAL

			ElseIf	( AllTrim(SE1->E1_PORTADO) == '104' )		//CAIXA
				aCB_RN_NN := xCaiVerfBar(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
				Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],;
				cNroDoc,(SE1->E1_SALDO - nVlrAbat),cCarteira,'9',IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA ),aDadosBanco[8],aDadosBanco[9])

			EndIf

			// [01] Numero do titulo
			// [02] Data da emissใo do titulo
			// [03] Data da emissใo do boleto
			// [04] Data do vencimento
			// [05] Valor do titulo
			// [06] Nosso numero (Ver formula para calculo)
			// [07] Prefixo da NF
			// [08] Tipo do Titulo
			// [09] Acrescimo
			// [10] Decrescimo
			aDadosTit := {AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA),;          // 01
			SE1->E1_EMISSAO,;                                       // 02
			dDataBase,;                                             // 03
			IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA ),;                                        // 04
			(SE1->E1_SALDO - nVlrAbat),;                            // 05
			aCB_RN_NN[3],;                                          // 06
			SE1->E1_PREFIXO,;                                       // 07
			SE1->E1_TIPO,;                                          // 08
			SE1->E1_SDACRESC,;                                      // 09
			SE1->E1_SDDECRESC,;                                      // 10
			nValJuros}												// 11


			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCARREGA AS INSTRUCOES A SEREM IMPRESSAS NO CORPO DO BOLETO!ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aBolText	:= {}  //Preencher as 7 posi็oes.
			If ( AllTrim(SE1->E1_PORTADO)== '246' )
				aAdd(aBolText, 'Tํtulo transferido ao Banco ABC Brasil S/A.')
			Else
				aAdd(aBolText, '' )
			EndIf
			If ( AllTrim(SE1->E1_PORTADO)== '320' )
				aAdd(aBolText, 'Titulo cedido fiduciariamente, nใo pagar direto a .')
			Else
				aAdd(aBolText, '' )
			EndIf

			//If ( AllTrim(SE1->E1_PORTADO)== '237' )
			_nMulta  := GetNewPar('MV_MULTBOL', 0 )   // Parametro com o percentual de multa por pagamento com atrazo.
			_nJurMes := GetNewPar('MV_JUROBOL', 0 )   // PARAMETRO COM A INFORMACAO DO JUROS COBRADOS POR MES.
			_nJurDia := (_nJurMes / 30) 				// CONTA PARA SABER O VALOR DO JUROS POR DIA
			//_nValJurD := Round( ((SE1->E1_VALOR * (_nJurMes / 100)) / 30), 06)
			_nValJurD := Round((SE1->E1_VALOR * _nJurDia) / 100, 06)
			_nValMulta := Round( ( ( SE1->E1_VALOR * (_nMulta / 100) ) ), 02)

			If GetNewPar('MV_JUROBOL',0.0) > 0
				aAdd(aBolText, "Juros......: "+ AllTrim(Transform(_nJurMes,'@E 999,999,999.99')) + "% ao m๊s - (R$ "  + cValToChar( _nValJurD ) + " ao dia)" )
			Else
				aAdd( aBolText, '' )
			EndIf

			
			If GetNewPar('MV_MULTBOL',0.0) > 0
				aAdd( aBolText, "Multa......: "+ cValToChar( _nMulta ) + "% ap๓s vencimento. (R$ " + cValToChar( _nValMulta ) + ")" )
			Else
				aAdd( aBolText, '' )
			EndIf

			If GetNewPar('MV_PROTBOL',0) > 0
				aAdd( aBolText, "SERASA...: " + Padl(GetNewPar('MV_PROTBOL',0),2,'0') +  " dias ๚teis a partir do vencimento" )
			Else
				aAdd( aBolText, '' )
			EndIF
			aAdd(aBolText, 'OBS: PROTESTO APำS O VENCIMENTO' )

			/*Else

			If GetNewPar('MV_JUROBOL',0.0) > 0
			aAdd(aBolText, 'APำS VENCIMENTO COBRAR MORA DIARIA DE '+AllTrim(Transform(GetNewPar('MV_JUROBOL',0.0)/30,'@E 999,999,999.99'))+'%  -   R$ ' + AllTrim(Transform( ((aDadosTit[5] * (GetNewPar('MV_JUROBOL',0.0)/100) / 30) ),'@E 999,999,999.99')) +   ' -  AO DIA' )
			Else
			aAdd( aBolText, '' )
			EndIf

			If GetNewPar('MV_MULTBOL',0.0) > 0
			aAdd( aBolText, 'APำS VENCIMENTO COBRAR MULTA DE '+cValToChar(GetNewPar('MV_MULTBOL', 2))+'%  -  R$ ' + AllTrim(Transform((aDadosTit[5] * (GetNewPar('MV_MULTBOL',2.0)/100)),'@E 999,999,999.99')) )
			Else
			aAdd( aBolText, '' )
			EndIf

			If GetNewPar('MV_PROTBOL',0) > 0
			aAdd( aBolText, '** PROTESTAR APำS ' + Padl(GetNewPar('MV_PROTBOL',0),2,'0') +  '  DIAS DO VENCIMENTO **' )
			Else
			aAdd( aBolText, '' )
			EndIF

			aAdd(aBolText, 'OBS: DEPOSITO NรO QUITA BOLETO' )

			EndIf*/

			aAdd(aBolText, '')

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSe for fatura, verifica os dados dos titulos integrantes. !ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If	( AllTrim(SE1->E1_PREFIXO) == 'FAT' )
				aDadosFat := xVerFatura(SE1->E1_NUM,SE1->E1_PREFIXO)
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณGrava Nosso Numero no Titulo                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			DbSelectArea('SE1')
			If	RecLock('SE1',.f.)

				If aDadosBanco[1] == '001' .And. Len( AllTrim( aDadosBanco[8] ) ) == 7
					Replace SE1->E1_NUMBCO 	With Substr( Right( aCB_RN_NN[ 3 ] , 17 ) , 8 , 10 )   // Nosso numero (Ver formula para cแlculo
				Else
					Replace SE1->E1_NUMBCO 	With Right(aCB_RN_NN[3],17)
				EndIf

				//REplace SE1->E1_TIPO    with 'BOL'

				MsUnlock()
			Else
				Help('',1,'REGNOIS')
			EndIf

			If (Len(aParametros) = 0) .OR. (Len(aParametros) <> 0 .AND. (GetNewPar('MV_IMPBOL','1') <> '3'))
				Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
			EndIF

			nX++

		EndIf

		IncProc()
		TRA->(DbSkip())
		nI++

	EndDo

	If (Len(aParametros) = 0) .OR. (Len(aParametros) <> 0 .AND. (GetNewPar('MV_IMPBOL',1) <> 3))
		oPrint:EndPage()     // Finaliza a pแgina
		oPrint:Preview()     // Visualiza antes de imprimir
	EndIF

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfEnviar() บAutor  ณDanyel Bernuci      บ Data ณ 02/06/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia e-mail de autoria com os dados da cotacao, para 	  บฑฑ
ฑฑบ          ณ um e-mail pre-determinado por parametro.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico			                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fEnviar(cAssunto, cMensagem ,cDestino, cArquivo)

	Local cAccount  := Lower(Alltrim(GetMv("MV_RELACNT")))
	Local cFrom     := Lower(Alltrim(GetMv("MV_RELFROM")))
	Local cPassword := Alltrim(GetMv("MV_RELPSW"))
	Local cServer   := Alltrim(GetMv("MV_RELSERV"))
	Local cEmailTo  := cDestino

	Local aFiles := {cArquivo}
	Local cEmailCc  := ""
	Local cEmailBcc := ""
	Local lResult   := .f.
	Local cError    := ""
	Local cAssunto  := cAssunto

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

	If lResult

		MailAuth(cAccount,cPassword)

		If Len(aFiles) > 0
			SEND MAIL FROM cFrom TO Lower(cEmailTo) CC Lower(cEmailCc) BCC Lower(cEmailBcc) ;
			SUBJECT cAssunto BODY cMensagem ;
			ATTACHMENT aFiles[1];
			RESULT lResult
		Else
			SEND MAIL FROM cFrom TO Lower(cDestino) CC Lower(cEmailCc) BCC Lower(cEmailBcc) ;
			SUBJECT cAssunto BODY cMensagem ;
			RESULT lResult
		EndIf

		If !lResult
			GET MAIL ERROR cError
			MsgInfo(cError,OemToAnsi("Aten็ใo"))
			//	Else
			//		MsgInfo("Notifica็ใo enviada!")
		EndIf
		DISCONNECT SMTP SERVER
	Else
		GET MAIL ERROR cError
		MsgInfo(cError,OemToAnsi("Aten็ใo"))
	EndIf

Return(lResult)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Impress  บAutor ณ Microsiga Software  บ Data ณ  11/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ IMPRESSAO DO BOLETO LASER CONFORME O BANCO..               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)

	Local	oBrush		:= TBrush():New(,4),;
	nLin		:= 0,;
	oFont8  	:= TFont():New('Arial',9,8,.T.,.F.,5,.T.,5,.T.,.F.),;
	oFont9  	:= TFont():New('Arial',9,9,.T.,.F.,5,.T.,5,.T.,.F.),;
	oFont11c	:= TFont():New('Courier New',9,11,.T.,.T.,5,.T.,5,.T.,.F.),;
	oFont11 	:= TFont():New('Arial',9,11,.T.,.T.,5,.T.,5,.T.,.F.),;
	oFont10 	:= TFont():New('Arial',9,10,.T.,.T.,5,.T.,5,.T.,.F.),;
	oFont14 	:= TFont():New('Arial',9,14,.T.,.T.,5,.T.,5,.T.,.F.),;
	oFont20 	:= TFont():New('Arial',9,20,.T.,.T.,5,.T.,5,.T.,.F.),;
	oFont21 	:= TFont():New('Arial',9,21,.T.,.T.,5,.T.,5,.T.,.F.),;
	oFont16n	:= TFont():New('Arial',9,16,.T.,.F.,5,.T.,5,.T.,.F.),;
	oFont15 	:= TFont():New('Arial',9,15,.T.,.T.,5,.T.,5,.T.,.F.),;
	oFont15n	:= TFont():New('Arial',9,15,.T.,.F.,5,.T.,5,.T.,.F.),;
	oFont14n	:= TFont():New('Arial',9,14,.T.,.F.,5,.T.,5,.T.,.F.),;
	oFont24 	:= TFont():New('Arial',9,24,.T.,.T.,5,.T.,5,.T.,.F.),;
	nI 			:= 0,;
	nX			:= 0,;
	nQtdPrint	:= 0,;
	nLinhPrin	:= 1
	cDigBco     := ""

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia uma nova paginaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrint:StartPage()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณC O M P R O V A N T E   D E   E N T R E G Aณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nRow1 := 0

	oPrint:Line(nRow1+0150,0500,nRow1+0070,0500) //- linha pra baixo
	oPrint:Line(nRow1+0150,0710,nRow1+0070,0710)

	cString := StrImp(aDadosBanco[1],'PosLogo')

	oPrint:SayBitmap(0065,0100,aDadosBanco[7],cString[1],cString[2])
	oPrint:Say(nRow1+0084,cString[3],'',oFont10)	                 // [2] Nome do Banco

	cDigBco := StrImp(aDadosBanco[1],'DigBco')
	oPrint:Say(nRow1+0075,0513,aDadosBanco[1]+cDigBco,oFont21) // [1] Numero do Banco

	oPrint:Say(nRow1+0084,1900,'Comprovante de Entrega',oFont10)
	oPrint:Line(nRow1+0150,0100,nRow1+0150,2300)

	oPrint:Say(nRow1+0150,0100,'Beneficiario',oFont8)
	oPrint:Say(nRow1+0200,0100,aDadosEmp[1],oFont10) // Nome + CNPJ

	cString := StrImp(aDadosBanco[1],'AgCedente')
	oPrint:Say(nRow1+0150,1060,'Ag๊ncia/C๓digo Beneficiario',oFont8)
	oPrint:Say(nRow1+0200,1060,cString[1],oFont10)

	IF aDadosBanco[1] $ '104'
		cString := StrImp(aDadosBanco[1],'NroDoc')
		oPrint:Say(nRow1+0150,1510 ,'Nro.Documento',oFont8)
		oPrint:Say(nRow1+0200,1510 ,cString,oFont10) // Prefixo+Numero+Parcela

	ELSE

		oPrint:Say(nRow1+0150,1510,'Nro.Documento',oFont8)
		oPrint:Say(nRow1+0200,1510,aDadosTit[7]+ '-' + Substr(aDadosTit[1],1,9)+ '/' + Substr(aDadosTit[1],10,3),oFont10) // xavier 22/07 -TES-000009623C
		//	oPrint:Say(nRow1+0200,1510,aDadosTit[7]+ '-' + Substr(aDadosTit[1],1,6)+ '/' + Substr(aDadosTit[1],7,2),oFont10) // Prefixo +Numero+Parcela 

	ENDIF

	oPrint:Say(nRow1+0250,100 ,'Pagador',oFont8)
	oPrint:Say(nRow1+0300,100 ,aDatSacado[1],oFont10) // Nome

	oPrint:Say(nRow1+0250,1060,'Vencimento',oFont8)
	oPrint:Say(nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +'/'+ StrZero(Month(aDadosTit[4]),2) +'/'+ Right(Str(Year(aDadosTit[4])),4),oFont10)

	oPrint:Say(nRow1+0250,1510,'Valor do Documento',oFont8)
	oPrint:Say(nRow1+0300,1550,AllTrim(TransForm(aDadosTit[5],'@E 999,999,999.99')),oFont10)

	oPrint:Say(nRow1+0400,0100,'Recebi(emos) o bloqueto/tํtulo',oFont10)
	oPrint:Say(nRow1+0450,0100,'com as caracterํsticas acima.',oFont10)

	oPrint:Say(nRow1+0350,1060,'Carteira',oFont8)
	//manutencao boleto caixa andre vicente
	if aDadosBanco[1] $ '104'
		oPrint:Say(nRow1+0400,1060, 'CR' ,oFont10)
	ELSEIF aDadosBanco[1] $ '001'
		oPrint:Say(nRow1+0400,1060,aDadosBanco[6] + cCompCart ,oFont10)
	ELSE
		oPrint:Say(nRow1+0400,1060,aDadosBanco[6],oFont10)
	ENDIF
	//fim da manutencao

	cString := StrImp(aDadosBanco[1],'NossoNumero')
	oPrint:Say(nRow1+0350,1410,'Nosso Numero',oFont8)
	oPrint:Say(nRow1+0400,1410,cString,oFont10)

	oPrint:Say(nRow1+0450,1060,'Data',oFont8)
	oPrint:Say(nRow1+0450,1410,'Entregador',oFont8)

	oPrint:Line (nRow1+0250,0100,nRow1+0250,1900)
	oPrint:Line (nRow1+0350,0100,nRow1+0350,1900)
	oPrint:Line (nRow1+0450,1050,nRow1+0450,1900)
	oPrint:Line (nRow1+0550,0100,nRow1+0550,2300)

	oPrint:Line (nRow1+0550,1050,nRow1+0150,1050)
	oPrint:Line (nRow1+0550,1400,nRow1+0350,1400)
	oPrint:Line (nRow1+0350,1500,nRow1+0150,1500)
	oPrint:Line (nRow1+0550,1900,nRow1+0150,1900)

	oPrint:Say(nRow1+0165,1910,'(   ) Mudou-se',oFont8)
	oPrint:Say(nRow1+0205,1910,'(   ) Ausente',oFont8)
	oPrint:Say(nRow1+0245,1910,'(   ) Nใo existe nบ indicado',oFont8)
	oPrint:Say(nRow1+0285,1910,'(   ) Recusado',oFont8)
	oPrint:Say(nRow1+0325,1910,'(   ) Nใo procurado',oFont8)
	oPrint:Say(nRow1+0365,1910,'(   ) Endere็o insuficiente',oFont8)
	oPrint:Say(nRow1+0405,1910,'(   ) Desconhecido',oFont8)
	oPrint:Say(nRow1+0445,1910,'(   ) Falecido',oFont8)
	oPrint:Say(nRow1+0485,1910,'(   ) Outros(anotar no verso)',oFont8)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณR E C I B O    D O     S A C A D O / P A G A D O Rณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nRow2 := 0

	For nI := 100 to 2300 step 50
		oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
	Next nI

	oPrint:Line(nRow2+0710,0100,nRow2+0710,2300)
	oPrint:Line(nRow2+0710,0500,nRow2+0630,0500)
	oPrint:Line(nRow2+0710,0710,nRow2+0630,0710)

	cString := StrImp(aDadosBanco[1],'PosLogo')
	//oPrint:Say(nRow2+0625,0100,'Recibo do Pagador',oFont8) // xavier 27/08 segunda
	oPrint:SayBitmap(0625,0100,aDadosBanco[7],cString[1],cString[2])
	//IF aDadosBanco[1] $ '001'
	//oPrint:Say(nRow2+0610,cString[3],'BANCO BRASIL S/A.',oFont8) // [2] Nome do Banco  // xavier 27/08 segunda
	//oPrint:Say(nRow2+0644,cString[3],'',oFont10)		            // [2] Nome do Banco
	//ENDIF

	oPrint:Say(nRow2+0635,0513,aDadosBanco[1]+cDigBco,oFont21)	// [1] Numero do Banco

	oPrint:Say(nRow2+0580,0100,'Recibo do Pagador',oFont10) // xavier 15/07/19
	oPrint:Say(nRow2+0644,0755,aCB_RN_NN[2],oFont15n)    // Linha Digitavel do Codigo de Barras  // xavier 15/07/19
	// oPrint:Say(nRow2+2134,0755,aCB_RN_NN[2],oFont15n) // Linha Digitavel do Codigo de Barras  // xavier 15/07/19

	oPrint:Line(nRow2+0810,0100,nRow2+0810,2300)
	oPrint:Line(nRow2+0910,0100,nRow2+0910,2300)
	oPrint:Line(nRow2+0980,0100,nRow2+0980,2300)
	oPrint:Line(nRow2+1050,0100,nRow2+1050,2300)

	oPrint:Line(nRow2+0980,0500,nRow2+1050,0500)
	//oPrint:Line(nRow2+0980,0340,nRow2+1050,0340)
	//oPrint:Line(nRow2+0980,0750,nRow2+1050,0750)
	oPrint:Line(nRow2+0980,1000,nRow2+1050,1000)
	oPrint:Line(nRow2+0980,1300,nRow2+1050,1300)
	oPrint:Line(nRow2+0980,1480,nRow2+1050,1480)

	//------------- Teste de box ----------------//
	oPrint:Line(nRow2+1120,0500,nRow2+1050,0500)
	oPrint:Line(nRow2+1120,0340,nRow2+1050,0340)
	oPrint:Line(nRow2+1120,0750,nRow2+1050,0750)
	oPrint:Line(nRow2+1120,1000,nRow2+1050,1000)
	//oPrint:Line(nRow2+1030,1300,nRow2+0980,1300)
	oPrint:Line(nRow2+1120,1480,nRow2+1050,1480)

	oPrint:Line(nRow2+1120,0100,nRow2+1120,2300)

	//-------------------------------------------//

	cString := StrImp(aDadosBanco[1],'LOCALPAGTO')
	oPrint:Say(nRow2+0710,0100,'Local de Pagamento',oFont8)
	IF aDadosBanco[1] $ '001'
		// IF aDadosBanco[1] $ '001/341' // xavier 23/07 - removido itau 
		oPrint:Say(nRow2+0725,0370,cString[1],oFont10) // xavier - impressao somente uma linha 
	ELSE
		oPrint:Say(nRow2+0725,0370,cString[1],oFont10)
		oPrint:Say(nRow2+0765,0370,cString[2],oFont10) // xavier 
	ENDIF

	cString	:= StrZero(Day(aDadosTit[4]),2) +'/'+ StrZero(Month(aDadosTit[4]),2) +'/'+ Right(Str(Year(aDadosTit[4])),4)
	oPrint:Say(nRow2+0710,1810,'Vencimento',oFont8)
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say(nRow2+0750,nCol,cString,oFont11c)

	oPrint:Say(nRow2+0810,100 ,'Beneficiario',oFont8)
	oPrint:Say(nRow2+0850,100 ,aDadosEmp[1]+'          - '+aDadosEmp[6],oFont10) // Nome + CNPJ

	cString := StrImp(aDadosBanco[1],'AgCedente')
	oPrint:Say(nRow2+0810,1810,'Ag๊ncia/C๓digo Beneficiario',oFont8)

	// manutencao boleto caixa - realizado por andre vicente
	if aDadosBanco[1] $ '104'      // tratamento codigo cedente caixa 16 digitos
		oPrint:Say(nRow2+0850,1810,cString[1],oFont11c)
	else
		oPrint:Say(nRow2+0850,cString[2],cString[1],oFont11c)
	endif
	//fim da manutencao

	cString := AllTrim( aDadosEmp[2]+'-'+ aDadosEmp[4] ) // xavier 16/07 Endereco + Cep 
	//cString := AllTrim( aDadosEmp[2] )
	oPrint:Say(nRow2+0910,100 ,'Endereco',oFont8)
	oPrint:Say(nRow2+0940,100, cString ,oFont10)

	oPrint:Say(nRow2+0980,100 ,'Data do Documento',oFont8)
	oPrint:Say(nRow2+1010,100, StrZero(Day(aDadosTit[2]),2) +'/'+ StrZero(Month(aDadosTit[2]),2) +'/'+ Right(Str(Year(aDadosTit[2])),4),oFont10)

	// cString := StrImp(aDadosBanco[1],'NroDoc') // nr. titulo imprimia errado
	// oPrint:Say(nRow2+0980,505 ,'Nro.Documento',oFont8)
	// oPrint:Say(nRow2+1010,605 ,cString,oFont10)

	IF aDadosBanco[1] $ '104'
		cString := StrImp(aDadosBanco[1],'NroDoc')
		oPrint:Say(nRow2+0980,505 ,'Nro.Documento',oFont8)
		oPrint:Say(nRow2+1010,605 ,cString,oFont10) // Prefixo+Numero+Parcela
	ELSE
		oPrint:Say(nRow2+0980,505 ,'Nro.Documento',oFont8)
		oPrint:Say(nRow2+1010,605 ,aDadosTit[7]+ '-' + Substr(aDadosTit[1],1,9)+ '/' + Substr(aDadosTit[1],10,3),oFont10) // xavier 22/07 -TES-000009623C
		//	oPrint:Say(nRow1+0200,1510,aDadosTit[7]+ '-' + Substr(aDadosTit[1],1,6)+ '/' + Substr(aDadosTit[1],7,2),oFont10) // Prefixo +Numero+Parcela 

	ENDIF

	cString := StrImp(IIF(Empty(aDadosBanco[10]),aDadosBanco[1],aDadosBanco[10]),'Especie Doc')
	oPrint:Say(nRow2+0980,1005,'Esp้cie Doc.',oFont8)
	oPrint:Say(nRow2+1010,1050,cString,oFont10)

	cString := StrImp(IIF(Empty(aDadosBanco[10]),aDadosBanco[1],aDadosBanco[10]),'Aceite')
	oPrint:Say(nRow2+0980,1305,'Aceite',oFont8)
	oPrint:Say(nRow2+1010,1350,cString,oFont10)

	cString := StrImp(aDadosBanco[1],'DTPROC')
	oPrint:Say(nRow2+0980,1485,'Data do Processamento',oFont8)
	oPrint:Say(nRow2+1010,1550,cString,oFont10) // Data impressao

	cString := StrImp(aDadosBanco[1],'NossoNumero')
	oPrint:Say(nRow2+0910,1810,'Nosso N๚mero',oFont8)
	oPrint:Say(nRow2+0940,1880,cString,oFont11c)

	oPrint:Say(nRow2+1050,0100,'Uso do Banco',oFont8)

	cString := StrImp(IIF(Empty(aDadosBanco[10]),aDadosBanco[1],aDadosBanco[10]),'CIP')
	oPrint:Say(nRow2+1050,0350,'CIP',oFont8)
	oPrint:Say(nRow2+1080,0405,cString,oFont10)

	oPrint:Say(nRow2+1050,0505,'Carteira',oFont8)
	//manutencao boleto caixa andre vicente
	if aDadosBanco[1] $ '104'
		oPrint:Say(nRow2+1080,0555, 'CR' ,oFont10)
	ELSEIF aDadosBanco[1] $ '001'
		oPrint:Say(nRow2+1080,0555,aDadosBanco[6]+ cCompCart ,oFont10)
	ELSE
		oPrint:Say(nRow2+1080,0555,aDadosBanco[6],oFont10)
	ENDIF
	//fim da manutencao

	cString := StrImp(IIF(Empty(aDadosBanco[10]),aDadosBanco[1],aDadosBanco[10]),'Especie')
	oPrint:Say(nRow2+1050,0755,'Esp้cie',oFont8)
	oPrint:Say(nRow2+1080,0805,cString,oFont10)

	oPrint:Say(nRow2+1050,1005,'Quantidade',oFont8)
	oPrint:Say(nRow2+1050,1485,'Valor',oFont8)

	oPrint:Say(nRow2+0980,1810,'Valor do Documento',oFont8)
	cString := AllTrim(TransForm(aDadosTit[5],'@E 99,999,999.99'))
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say(nRow2+1010,nCol,cString ,oFont11c)

	
	/*oPrint:Say(nRow2+1120,0100,'Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do Beneficiario)',oFont8)
	oPrint:Say(nRow2+1090,0100,'',oFont9)
	oPrint:Say(nRow2+1130,0100,'',oFont9)
	oPrint:Say(nRow2+1170,0100,'',oFont9)
	oPrint:Say(nRow2+1210,0100,'',oFont9)
	oPrint:Say(nRow2+1250,0100,'',oFont9)
	oPrint:Say(nRow2+1290,0100,'',oFont10)
	*/
	//teste do junior 20/04/2021
	oPrint:Say(nRow2+1120,0100,'Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do Beneficiario)',oFont8)
	oPrint:Say(nRow2+1090,0100,aBolText[1],oFont9)
	oPrint:Say(nRow2+1130,0100,aBolText[2],oFont9)
	oPrint:Say(nRow2+1170,0100,aBolText[3],oFont9)
	oPrint:Say(nRow2+1210,0100,aBolText[4],oFont9)
	oPrint:Say(nRow2+1250,0100,aBolText[5],oFont9)
	oPrint:Say(nRow2+1290,0100,aBolText[6],oFont10)
	oPrint:Say(nRow2+1350,0100,aBolText[7],oFont10)
/*
	oPrint:Say(nRow2+1090,0100,aBolText[1],oFont9)
	oPrint:Say(nRow2+1130,0100,aBolText[2],oFont9)
	oPrint:Say(nRow2+1170,0100,aBolText[3],oFont9)
	oPrint:Say(nRow2+1210,0100,aBolText[4],oFont9)
	oPrint:Say(nRow2+1250,0100,aBolText[5],oFont9)
	oPrint:Say(nRow2+1290,0100,aBolText[6],oFont10)
	oPrint:Say(nRow2+1350,0100,aBolText[7],oFont10)
*/
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณImprime os titulos que se refere a tal cobran็a !ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrint:Say(nRow2+1400,0100,'Referente aos Documentos: ',oFont10)
	oPrint:Say(nRow2+1550,0100,'Vencimento Original ' + DtoC( SE1->E1_VENCREA ) , oFont9 )
	//  	oPrint:Say(nRow2+1400,1500,'Formas de Contato: ',oFont11)
	//  	oPrint:Say(nRow2+1400,1500,'Formas de Contato: ',oFont11)
	//  	oPrint:Say(nRow1+1410,1900, 'credito@petroluz.com.br   ou',oFont8)
	//	  	oPrint:Say(nRow1+1460,1900, '(0xx65) 2121-5700',oFont8)


	If	( Len(aDadosFat) > 0 ) // FAT

		nLin := 1450 // Posicao da Linha
		nCol := 0100 // Posicao da Coluna
		For nx:=1 to Len(aDadosFat)
			nQtdPrint++
			oPrint:Say(nRow2+nLin,nCol,aDadosFat[nx][3]+Iif(!Empty(aDadosFat[nx][4]),'-'+Alltrim(aDadosFat[nx][4]),'')+', ',oFont9)
			nCol += 190
			If	( nQtdPrint == 9 )
				nLin += 050
				nCol := 100
				nQtdPrint := 0
				nLinhPrin++
			EndIf
			If	( nLinhPrin > 7 )
				Exit
			EndIf
		Next nx

	Else	// Outros

		nLin := 1450 // Posicao da Linha
		nCol := 0100 // Posicao da Coluna
		// [01] Numero do titulo
		// [02] Data da emissใo do titulo
		// [03] Data da emissใo do boleto
		// [04] Data do vencimento
		// [05] Valor do titulo
		// [06] Nosso numero (Ver formula para calculo)
		// [07] Prefixo da NF
		// [08] Tipo do Titulo
		//oPrint:Say(nRow2+nLin,nCol,aDadosTit[7] +' - '+ aDadosTit[1],oFont9)
		oPrint:Say(nRow2+nLin,nCol,AllTrim(SubStr(aDadosTit[7],1,3)+' - '+SubStr(aDadosTit[1],1,9)+' / '+SubStr(aDadosTit[1],10,3)),oFont9) // xavier 01/08/19
		// oPrint:Say(nRow2+nLin,nCol,AllTrim(SubStr(aDadosTit[7],1,3)+' - '+SubStr(aDadosTit[1],1,6)+' / '+SubStr(aDadosTit[1],7,2)),oFont9)
	EndIf

	oPrint:Say(nRow2+1050,1810,'(-) Desconto/Abatimento',oFont8)
	oPrint:Say(nRow2+1120,1810,'(-) Outras Dedu็๕es',oFont8)
	If	( aDadosTit[10] > 0 )
		cString := AllTrim(TransForm(aDadosTit[10],'@E 99,999,999.99'))
		nCol := 1810+(374-(Len(cString)*22))
		oPrint:Say(nRow2+1150,nCol,cString ,oFont11c)
	EndIf
	oPrint:Say(nRow2+1190,1810,'(+) Mora/Multa',oFont8)
	oPrint:Say(nRow2+1260,1810,'(+) Outros Acr้scimos',oFont8)
	If	( aDadosTit[9] > 0 )
		cString := AllTrim(TransForm(aDadosTit[9],'@E 99,999,999.99'))
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say(nRow2+1290,nCol,cString ,oFont11c)
	EndIf
	If	( aDadosTit[11] > 0 )
		cString := AllTrim(TransForm(aDadosTit[11],'@E 99,999,999.99'))
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say(nRow2+1220,nCol,cString ,oFont11c)
	EndIf
	oPrint:Say(nRow2+1330,1810,'(=) Valor Cobrado',oFont8)

	oPrint:Say(nRow2+1600,0100,'Pagador',oFont8)
	oPrint:Say(nRow2+1630,0400,aDatSacado[1]+' ('+aDatSacado[2]+')',oFont10)
	oPrint:Say(nRow2+1683,0400,aDatSacado[3],oFont10)
	oPrint:Say(nRow2+1736,0400,aDatSacado[6]+'    '+aDatSacado[4]+'  -  '+aDatSacado[5],oFont10) // CEP+Cidade+Estado

	If	( aDatSacado[8] = 'J' )
		oPrint:Say(nRow2+1789,400 ,'CNPJ: '+TransForm(aDatSacado[7],'@R 99.999.999/9999-99'),oFont10) // CGC
	Else
		oPrint:Say(nRow2+1789,400 ,'CPF: '+TransForm(aDatSacado[7],'@R 999.999.999-99'),oFont10) 	// CPF
	EndIf

	oPrint:Say(nRow2+1789,1850,SubStr(aDadosTit[6],1,3)+SubStr(aDadosTit[6],4),oFont10)  // nosso numero

	oPrint:Say(nRow2+1845,0100,'Pagador/Avalista: ' ,oFont8)
	oPrint:Say(nRow2+1845,1500,'Autentica็ใo Mecโnica',oFont8)

	oPrint:Line(nRow2+0710,1800,nRow2+1400,1800)
	oPrint:Line(nRow2+1120,1800,nRow2+1120,2300)
	oPrint:Line(nRow2+1190,1800,nRow2+1190,2300)
	oPrint:Line(nRow2+1260,1800,nRow2+1260,2300)
	oPrint:Line(nRow2+1330,1800,nRow2+1330,2300)
	oPrint:Line(nRow2+1400,1800,nRow2+1400,2300)
	oPrint:Line(nRow2+1600,0100,nRow2+1600,2300)
	oPrint:Line(nRow2+1840,0100,nRow2+1840,2300)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณF I C H A     D E    C O M P E N S A C A O ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nRow3 := 0

	For nI := 100 to 2300 step 50
		oPrint:Line(nRow3+2080, nI, nRow3+2080, nI+30)
	Next nI

	oPrint:Line(nRow3+2200,0100,nRow3+2200,2300)
	oPrint:Line(nRow3+2200,0500,nRow3+2120,0500)
	oPrint:Line(nRow3+2200,0710,nRow3+2120,0710)


	cString := StrImp(aDadosBanco[1],'PosLogo')
	oPrint:SayBitmap(2115,0100,aDadosBanco[7],cString[1],cString[2])
	oPrint:Say(nRow3+2134,cString[3],'',oFont10) // [2] Nome do Banco

	oPrint:Say(nRow3+2125,0513,aDadosBanco[1]+cDigBco,oFont21) // [1]Numero do Banco

	oPrint:Say(nRow3+2134,0755,aCB_RN_NN[2],oFont15n) // Linha Digitavel do Codigo de Barras

	oPrint:Line(nRow3+2300,0100,nRow3+2300,2300)
	oPrint:Line(nRow3+2400,0100,nRow3+2400,2300)
	oPrint:Line(nRow3+2470,0100,nRow3+2470,2300)
	oPrint:Line(nRow3+2540,0100,nRow3+2540,2300)

	oPrint:Line(nRow3+2400,0500,nRow3+2540,0500)
	oPrint:Line(nRow3+2470,0340,nRow3+2540,0340)
	oPrint:Line(nRow3+2470,0750,nRow3+2540,0750)
	oPrint:Line(nRow3+2400,1000,nRow3+2540,1000)
	oPrint:Line(nRow3+2400,1300,nRow3+2570,1300)
	oPrint:Line(nRow3+2400,1480,nRow3+2540,1480)

	//cString := StrImp(aDadosBanco[1],'LOCALPAGTO')
	//oPrint:Say(nRow3+2200,0100,'Local de Pagamento',oFont8)
	//oPrint:Say(nRow3+2215,0370,cString[1],oFont10)
	//oPrint:Say(nRow3+2255,0370,cString[2],oFont10)

	cString := StrImp(aDadosBanco[1],'LOCALPAGTO')
	oPrint:Say(nRow3+0710,0100,'Local de Pagamento',oFont8)
	IF aDadosBanco[1] $ '001'
		// IF aDadosBanco[1] $ '001/341' //  xavier 23/07 removido itau 
		oPrint:Say(nRow3+2215,0370,cString[1],oFont10) // xavier - impressao somente uma linha 
	ELSE
		oPrint:Say(nRow3+2215,0370,cString[1],oFont10)
		oPrint:Say(nRow3+2255,0370,cString[2],oFont10) // xavier 
	ENDIF

	oPrint:Say(nRow3+2200,1810,'Vencimento',oFont8)
	cString := StrZero(Day(aDadosTit[4]),2) +'/'+ StrZero(Month(aDadosTit[4]),2) +'/'+ Right(Str(Year(aDadosTit[4])),4)
	nCol    := 1810+(374-(len(cString)*22))
	oPrint:Say(nRow3+2240,nCol,cString,oFont11c)

	oPrint:Say(nRow3+2300,0100,'Beneficiario',oFont8)
	oPrint:Say(nRow3+2340,0100,aDadosEmp[1]+'       - '+aDadosEmp[6],oFont10) // Nome + CNPJ
	//  oPrint:Say(nRow3+2340,0100,'J O COMERCIO DE TINTAS LTDA ME' + ' - '  +aDadosEmp[6],oFont10) // Nome + CNPJ TESTE

	cString := StrImp(aDadosBanco[1],'AgCedente')
	oPrint:Say(nRow3+2300,1810,'Ag๊ncia/C๓digo Beneficiario',oFont8)

	// alteracao andre vicente 22/10/2012
	if aDadosBanco[1] $ '104'                 // tratanto caixa -
		oPrint:Say(nRow3+2340,1810,cString[1],oFont11c)
	else
		oPrint:Say(nRow3+2340,cString[2],cString[1],oFont11c)
	endif
	// fim da manutencao

	//cString := AllTrim( aDadosEmp[2]+'-'+ aDadosEmp[4] ) // xavier 16/07 Endereco + Cep - solicitado pelo Bradesco 15/08 // Removido 20/08
	//oPrint:Say (nRow3+2400,100 ,'Endereco',oFont8)
	//oPrint:Say (nRow3+2430,100, cString ,oFont10)

	oPrint:Say (nRow3+2400,100 ,'Data do Documento',oFont8)
	oPrint:Say (nRow3+2430,100, StrZero(Day(aDadosTit[2]),2) +'/'+ StrZero(Month(aDadosTit[2]),2) +'/'+ Right(Str(Year(aDadosTit[2])),4), oFont10)

	//cString := StrImp(aDadosBanco[1],'NroDoc') // antes 220720/20
	//oPrint:Say(nRow3+2400,505 ,'Nro.Documento',oFont8) 
	//oPrint:Say(nRow3+2430,605 ,cString,oFont10) // Prefixo +Numero+Parcela

	IF aDadosBanco[1] $ '104'  // xavier 22/07
		oPrint:Say(nRow3+2400,505 ,'Nro.Documento',oFont8)
		oPrint:Say(nRow3+2430,605 ,cString,oFont10) // Prefixo +Numero+Parcela
	ELSE
		oPrint:Say(nRow3+2400,505 ,'Nro.Documento',oFont8)
		oPrint:Say(nRow3+2430,605,aDadosTit[7]+ '-' + Substr(aDadosTit[1],1,9)+ '/' + Substr(aDadosTit[1],10,3),oFont10) // xavier 22/07 -TES-000009623C
		//	oPrint:Say(nRow1+0200,1510,aDadosTit[7]+ '-' + Substr(aDadosTit[1],1,6)+ '/' + Substr(aDadosTit[1],7,2),oFont10) // Prefixo +Numero+Parcela 

	ENDIF

	cString := StrImp(IIF(Empty(aDadosBanco[10]),aDadosBanco[1],aDadosBanco[10]),'Especie Doc')
	oPrint:Say(nRow3+2400,1005,'Esp้cie Doc.',oFont8)
	oPrint:Say(nRow3+2430,1050,cString,oFont10)

	cString := StrImp(IIF(Empty(aDadosBanco[10]),aDadosBanco[1],aDadosBanco[10]),'Aceite')
	oPrint:Say(nRow3+2400,1305,'Aceite',oFont8)
	oPrint:Say(nRow3+2430,1400,cString,oFont10)

	oPrint:Say(nRow3+2400,1485,'Data do Processamento',oFont8)
	oPrint:Say(nRow3+2430,1550,StrZero(Day(aDadosTit[3]),2) +'/'+ StrZero(Month(aDadosTit[3]),2) +'/'+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

	cString := StrImp(aDadosBanco[1],'NossoNumero')
	oPrint:Say(nRow3+2400,1810,'Nosso Numero',oFont8)
	oPrint:Say(nRow3+2430,1880,cString,oFont11c)

	oPrint:Say(nRow3+2470,0100,'Uso do Banco',oFont8)

	cString := StrImp(IIF(Empty(aDadosBanco[10]),aDadosBanco[1],aDadosBanco[10]),'CIP')
	oPrint:Say(nRow3+2470,0350,'CIP',oFont8)
	oPrint:Say(nRow3+2500,0405,cString,oFont10)

	oPrint:Say(nRow3+2470,0505,'Carteira',oFont8)
	//manutencao boleto caixa andre vicente
	if aDadosBanco[1] $ '104'
		oPrint:Say(nRow3+2500,0555,'CR',oFont10)
	ELSEIF aDadosBanco[1] $ '001'
		oPrint:Say(nRow3+2500,0555,aDadosBanco[6]+ cCompCart ,oFont10)
	ELSE
		oPrint:Say(nRow3+2500,0555,aDadosBanco[6],oFont10)
	ENDIF
	//fim da manutencao

	cString := StrImp(IIF(Empty(aDadosBanco[10]),aDadosBanco[1],aDadosBanco[10]),'Especie')
	oPrint:Say(nRow3+2470,0755,'Esp้cie',oFont8)

	IF AllTrim(Upper(aDadosBanco[2])) == 'BRADESCO'
		oPrint:Say(nRow3+2500,0805,'R$',oFont10)
	ELSE
		oPrint:Say(nRow3+2500,0805,cString,oFont10)
	ENDIF

	oPrint:Say(nRow3+2470,1005,'Quantidade',oFont8)
	oPrint:Say(nRow3+2470,1485,'Valor',oFont8)

	oPrint:Say(nRow3+2470,1810,'Valor do Documento',oFont8)
	cString := AllTrim(TransForm(aDadosTit[5],'@E 99,999,999.99'))
	nCol 	:= 1810+(374-(len(cString)*22))
	oPrint:Say(nRow3+2500,nCol,cString,oFont11c)
/*
	oPrint:Say(nRow3+2540,0100,'Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do Beneficiario)',oFont8)
	oPrint:Say(nRow3+2580,0100,'',oFont9)
	oPrint:Say(nRow3+2620,0100,'',oFont9)
	oPrint:Say(nRow3+2660,0100,'',oFont9)
	oPrint:Say(nRow3+2700,0100,'',oFont9)
	oPrint:Say(nRow3+2740,0100,'',oFont9)
*/
// teste do junior
	oPrint:Say(nRow3+2540,0100,'Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do Beneficiario)',oFont8)
	oPrint:Say(nRow3+2580,0100,aBolText[1],oFont9)
	oPrint:Say(nRow3+2620,0100,aBolText[2],oFont9)
	oPrint:Say(nRow3+2660,0100,aBolText[3],oFont9)
	oPrint:Say(nRow3+2700,0100,aBolText[4],oFont9)
	oPrint:Say(nRow3+2740,0100,aBolText[5],oFont9)
	oPrint:Say(nRow3+2790,0100,aBolText[6],oFont10)
	oPrint:Say(nRow3+2840,0100,aBolText[7],oFont10)
	
	/*oPrint:Say(nRow3+2580,0100,aBolText[1],oFont9)
	oPrint:Say(nRow3+2620,0100,aBolText[2],oFont9)
	oPrint:Say(nRow3+2660,0100,aBolText[3],oFont9)
	oPrint:Say(nRow3+2700,0100,aBolText[4],oFont9)
	oPrint:Say(nRow3+2740,0100,aBolText[5],oFont9)*/
	//	oPrint:Say(nRow3+2790,0100,aBolText[6],oFont10)
	//	oPrint:Say(nRow3+2840,0100,aBolText[7],oFont10)

	oPrint:Say(nRow3+2540,1810,'(-) Desconto/Abatimento',oFont8)
	oPrint:Say(nRow3+2610,1810,'(-) Outras Dedu็๕es',oFont8)
	If	( aDadosTit[10] > 0 )
		cString := AllTrim(TransForm(aDadosTit[10],'@E 99,999,999.99'))
		nCol 	:= 1810+(374-(len(cString)*22))
		oPrint:Say(nRow3+2640,nCol,cString,oFont11c)
	EndIf
	oPrint:Say(nRow3+2680,1810,'(+) Mora/Multa',oFont8)
	oPrint:Say(nRow3+2750,1810,'(+) Outros Acr้scimos',oFont8)
	If	( aDadosTit[9] > 0 )
		cString := AllTrim(TransForm(aDadosTit[9],'@E 99,999,999.99'))
		nCol 	:= 1810+(374-(len(cString)*22))
		oPrint:Say(nRow3+2780,nCol,cString,oFont11c)
	EndIf
	oPrint:Say(nRow3+2820,1810,'(=) Valor Cobrado',oFont8)

	oPrint:Say(nRow3+2890,0100,'Pagador',oFont8)
	oPrint:Say(nRow3+2900,0400,aDatSacado[1]+' ('+aDatSacado[2]+')',oFont10)

	If	( aDatSacado[8] = 'J' )
		oPrint:Say(nRow3+2900,1750,'CNPJ: '+TransForm(aDatSacado[7],'@R 99.999.999/9999-99'),oFont10) // CGC
	Else
		oPrint:Say(nRow3+2900,1750,'CPF: '+TransForm(aDatSacado[7],'@R 999.999.999-99'),oFont10) 	// CPF
	EndIf

	oPrint:Say(nRow3+2953,0400,aDatSacado[3],oFont10)
	oPrint:Say(nRow3+3006,0400,aDatSacado[6]+'    '+aDatSacado[4]+'  -  '+ aDatSacado[5],oFont10) // CEP+Cidade+Estado
	oPrint:Say(nRow3+3006,1750,SubStr(aDadosTit[6],1,3)+SubStr(aDadosTit[6],4),oFont10)     //nosso numero

	oPrint:Say(nRow3+3055,0100,'Pagador/Avalista: ',oFont8)
	oPrint:Say(nRow3+3055,1500,'Autentica็ใo Mecโnica - Ficha de Compensa็ใo',oFont8)

	oPrint:Line(nRow3+2200,1800,nRow3+2890,1800)
	oPrint:Line(nRow3+2610,1800,nRow3+2610,2300)
	oPrint:Line(nRow3+2680,1800,nRow3+2680,2300)
	oPrint:Line(nRow3+2750,1800,nRow3+2750,2300)
	oPrint:Line(nRow3+2820,1800,nRow3+2820,2300)
	oPrint:Line(nRow3+2890,0100,nRow3+2890,2300)

	oPrint:Line(nRow3+3050,0100,nRow3+3050,2300)

	If mv_par18 = 2 //Impressใo Deskjet
		MsBar('INT25',13.3,0.6,aCB_RN_NN[1],oPrint,.f.,,,0.0134,0.61,,,'A',.f.)

	Else
		MsBar('INT25',26.5,1.4,aCB_RN_NN[1],oPrint,.f.,,,0.0234,0.86,,,'A',.F.)
	EndIf

	//MSBar( "INT25" , 59.9 , 3.3 , aCB_RN_NN[1], oPrint , .F. ,,, 0.025 , 1.5 ,,,'A', .F. )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFinaliza a paginaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrint:EndPage()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xBBVerfBar บAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica/Gera o Codigo de Barra ( Banco do Brasil )        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xBBVerfBar(	cPrefixo,cNumero,cParcela,cTipo,;
	cBanco,cAgencia,cConta,cDacCC,;
	cNroDoc,nVlrTit,cCart,cMoeda)
	Local	cNosso		:= '',;
	nNum		:= '',;
	cCampoL		:= '',;
	cFatorValor	:= '',;
	cLivre		:= '',;
	cDigBarra	:= '',;
	cBarra		:= '',;
	cParte1		:= '',;
	cDig1		:= '',;
	cParte2		:= '',;
	cDig2		:= '',;
	cParte3		:= '',;
	cDig3		:= '',;
	cParte4		:= '',;
	cParte5		:= '',;
	cDigital	:= '',;
	aRet		:= {}

	cAgencia	:= StrZero(Val(cAgencia),4)
	cNosso 		:= ''

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFormulacao do nosso numeroณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


	If	( Len(AllTrim(cNroDoc)) == 17 ) // Ja esta pronto nao precisa verificar digito
		nNum	:= SubStr(cNroDoc,1,17)
		cNosso	:= cNroDoc
	Else
		cNosso	:= SubStr(cNroDoc,1,11) + xBBCalcDigN(cNroDoc)
	EndIf

	// Campo livre -  verificar a conta e carteira
	//cCampoL := cNosso + cAgencia + StrZero(Val(cConta),8) + cCart
	cCampoL := SubStr(cNosso,1,11) + cAgencia + StrZero(Val(cConta),8) + cCart

	// Campo livre do codigo de barra - verificar a conta
	cFatorValor  := xFator()+StrZero(nVlrTit*100,10)

	cLivre := cBanco + cMoeda + cFatorValor + cCampoL

	// Campo do codigo de barra
	cDigBarra := U_Calc_5pBB(cLivre)
	cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,40)

	// Composicao da linha digitavel
	cParte1  := cBanco + cMoeda + SubStr( cNosso , 1 , 5 )
	cDig1    := U_DIGIT001( cParte1 )
	cParte2  := SubStr( cNosso , 6 , 6 ) + cAgencia
	cDig2    := U_DIGIT001( cParte2 )
	cParte3  := Substr( StrZero( Val( cConta ) , 8 ) , 1 , 8 ) + cCart
	cDig3    := U_DIGIT001( cParte3 )

	/*
	cDigital := SubStr(cParte1,1,5)+'.'+SubStr(cparte1,6,4)+cDig1+' '+;
	SubStr(cParte2,1,5)+'.'+SubStr(cparte2,6,5)+cDig2+' '+;
	SubStr(cParte3,1,5)+'.'+SubStr(cparte3,6,5)+cDig3+' '+;
	cParte4+;
	cParte5
	*/

	cDigital := cBanco + cMoeda + SubStr( cNosso , 1 , 1 ) + '.' + ;
	SubStr( cNosso , 2 , 4 ) + cDig1 + ' ' + ;
	SubStr( cNosso , 6 , 5 ) + '.' + SubStr( cNosso , 11 , 1 ) + cAgencia + cDig2 + ' ' + ;
	Substr( StrZero( Val( cConta ) , 8 ) , 1 , 5 ) + '.' + Substr( StrZero( Val( cConta ) , 8 ) , 6 , 3 ) + cCart + cDig3 + ' ' + ;
	cDigBarra + ' ' + cFatorValor

	Aadd(aRet,cBarra)
	Aadd(aRet,cDigital)
	Aadd(aRet,cNosso)

Return aRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณ Funcao    ณ xSanVerfBar() Autor ณ Flavio Novaes    ณ Data ณ 03/02/2005 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Descricao ณ Impressao de Boleto Bancario do Banco Santander com Codigo ณฑฑ
ฑฑณ           ณ de Barras, Linha Digitavel e Nosso Numero.                 ณฑฑ
ฑฑณ           ณ Baseado no Fonte TBOL001 de 01/08/2002 de Raimundo Pereira.ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso       ณ FINANCEIRO                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC FUNCTION xSanVerfBar(cPrefixo,cNumero,cParcela,cTipo,;
	cBanco,cAgencia,cConta,cDacCC,;
	cNroDoc,nVlrTit,cCart,cMoeda,cCodCed)

	LOCAL bldocnufinal := STRZERO(VAL(cNroDoc),8)
	LOCAL blvalorfinal := STRZERO(int(nVlrTit*100),10)
	LOCAL dvnn         := 0
	LOCAL dvcb         := 0
	LOCAL dv           := 0
	LOCAL NN           := ''
	LOCAL RN           := ''
	LOCAL CB           := ''
	LOCAL s            := ''
	LOCAL _cfator      := ''
	LOCAL cCart		   := '101'
	LOCAL cConta       := RIGHT(cConta,5)
	LOCAL _cNossoNum   := ''
	LOCAL aRet         := { }

	//-------- Definicao do NOSSO NUMERO

	_cNossoNum := StrZero(Val(cNroDoc),12) + xSanCalcDigN( cNroDoc )

	NN   := _cNossoNum


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo livre do codigo de barra - verificar a contaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cfator  := xFator()

	//	-------- Definicao do CODIGO DE BARRAS
	s    := cBanco + "9" + _cfator + blvalorfinal + "9" + AllTrim(cCodCed) + Alltrim(_cNossoNum) + "0" +cCart

	dvcb := xSanDigB(s)


	CB   := SUBSTR(s, 1, 4) + AllTrim(dvcb) + SUBSTR(s,5,40)

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	CAMPO 1:
	//	AAA = Codigo do banco na Camara de Compensacao
	//	  B = Codigo da moeda, sempre 9
	//	CCC = Codigo da Carteira de Cobranca
	//	 DD = Dois primeiros digitos no nosso numero
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	s    := cBanco + cMoeda + "9" + Substr( cCodCed , 1 , 4 )
	dv   := modulo10(s)
	RN   := SUBSTR(s, 1, 5) + '.' + SUBSTR(s, 6, 4) + AllTrim(Str(dv)) + '  '

	//	CAMPO 2:
	//	DDDDDD = Restante do Nosso Numero
	//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
	//	   FFF = Tres primeiros numeros que identificam a agencia
	//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	s    := Substr( cCodCed , 5 , 3 ) + SUBSTR(_cNossoNum,1,7)
	dv   := modulo10(s)
	RN   := RN + SUBSTR(s, 1, 5) + '.' + SUBSTR(s, 6, 5) + AllTrim(Str(dv)) + '  '

	//	CAMPO 3:
	//	     F = Restante do numero que identifica a agencia
	//	GGGGGG = Numero da Conta + DAC da mesma
	//	   HHH = Zeros (Nao utilizado)
	//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	s    := SUBSTR(_cNossoNum,8,6) + "0" + cCart
	dv   := modulo10(s)
	RN   := RN + SUBSTR(s, 1, 5) + '.' + SUBSTR(s, 6, 5) + AllTrim(Str(dv)) + '  '

	//	CAMPO 4:
	//	     K = DAC do Codigo de Barras

	RN   := RN + AllTrim(dvcb) + '  '

	//	CAMPO 5:
	//	      UUUU = Fator de Vencimento
	//	VVVVVVVVVV = Valor do Titulo

	RN   := RN + _cfator + STRZERO(Int(nVlrTit * 100),14-LEN(_cfator))
RETURN({CB,RN,NN})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxSicoVerfBar  บAutor Andre Vicente         บ Dataณ  12/28/12บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   BANCO SICOOB - CREDISUL                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xSicoVerfBar(cPrefixo,cNumero,cParcela,cTipo,;
	cBanco,cAgencia,cConta,cDacCC,cNroDoc,;
	nVlrTit,cCart,cMoeda,dVencto,cCedente,cConvenio)

	Local   nNroDoc     := 0
	Local   nCedente    := 0
	Local   nFatVct     := 0
	Local	cNosso		:= ''
	local   cResto      := ''
	Local	cBarra		:= ''
	Local	cDigBarra	:= ''
	Local   cCpoLivre   := ''

	Local	cParte1		:= ''
	Local	cDig1		:= ''
	Local	cParte2		:= ''
	Local	cDig2	    := ''
	Local	cParte3		:= ''
	Local	cDig3		:= ''
	Local	cParte4		:= ''
	Local	cParte5		:= ''
	Local	cDigital	:= ''

	Local	aRet		:= {}

	//Zera e ajusta algumas variแvels
	cAgencia    := StrZero(Val(cAgencia),4)
	cNosso 		:= ''

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFormulacao do nosso numero (N๚mero Bancแrio)
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(AllTrim(cNroDoc)) < 8               //EE_FAIXATU

		//Calculo do dํgito verificador
		nNroDoc    := 11 - Val(DigSicoob(alltrim(cCedente)+alltrim(Right(cValToChar(Year(dDataBase)),2))+cNroDoc,9,2,'C'))
		nNroDoc    := If( nNroDoc > 9,'0',cValToChar(nNroDoc))

		//Montagem do nosso n๚mero
		cNosso    := Right(cValToChar(Year(dDataBase)),2)			// ANO (DOIS DIGITOS)
		cNosso    += cNroDoc    //SEQUENCIAO EE_FAIXATU
		cNosso    += nNroDoc    //DIGITO
	Else
		cNosso := AllTrim(cNroDoc)
	EndIf


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Campo Livre ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cCpoLivre := Substr(cCart,2,1)  // Carteira 1 - 2
	cCpoLivre += cAgencia // Agencia
	cCpoLivre += Alltrim(cCart)  // Modalidade 01
	cCpoLivre += Substr(cCedente,8,7)  // Codigo do Cedente EE_CODEMP
	cCpoLivre += cNosso  // nosso numero
	cCpoLivre += StrZero(Val(cParcela),3)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cแlculo do C๓digo de Barras ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cBarra    := cBanco    // 756
	cBarra    += cMoeda    // 9
	cBarra    += xFator()  //10/07/1997 menos a data de vencimento  padrao febraban
	cBarra    += StrZero(nVlrTit*100,10)
	cBarra    += cCpoLivre

	cDigBarra := 11 - Val(xCalMod11(cBarra,1,4,'C') + (cBarra,5,44,'C'))
	cDigBarra := If(cDigBarra > 9 .Or. cDigBarra = 0 .Or. cDigBarra = 1,'1',cValToChar(cDigBarra))

	cBarra    := Substr(cBarra,1,4) + cDigBarra + Substr(cBarra,5,999)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณComposicao da linha digitavelณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cParte1  := cBanco + cMoeda + SubStr(cCpoLivre,1,5)
	cDig1    := U_DIGIT001( cParte1 )

	cParte2  := SubStr(cCpoLivre,6,10)
	cDig2    := U_DIGIT001( cParte2 )

	cParte3  := SubStr(cCpoLivre,16,10)
	cDig3    := U_DIGIT001( cParte3 )

	cParte4  := ' '+cDigBarra+' '

	cParte5  :=  xFator() + StrZero(nVlrTit*100,10)

	cDigital := 	SubStr(cParte1,1,5)+'.'+SubStr(cParte1,6,4)+cDig1+' '+;
	SubStr(cParte2,1,5)+'.'+SubStr(cParte2,6,5)+cDig2+' '+;
	SubStr(cParte3,1,5)+'.'+SubStr(cParte3,6,5)+cDig3+;
	cParte4+;
	cParte5

	Aadd(aRet,cBarra)   //C๓digo de Barras
	Aadd(aRet,cDigital) //Linha Digitแvel
	Aadd(aRet,cNosso)   //Nosso N๚mero


Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xBBVerfBar บAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica/Gera o Codigo de Barra ( Banco do Brasil )        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS CONVENIO COM 7 POSICOES                            บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xBBVerfBa7(cPrefixo,cNumero,cParcela,cTipo,;
	cBanco,cAgencia,cConta,cDacCC,;
	cNroDoc,nVlrTit,cCart,cMoeda,cConvenio)
	Local	cNosso		:= '',;
	nNum		:= '',;
	cCampoL		:= '',;
	cFatorValor	:= '',;
	cLivre		:= '',;
	cDigBarra	:= '',;
	cBarra		:= '',;
	cParte1		:= '',;
	cDig1		:= '',;
	cParte2		:= '',;
	cDig2		:= '',;
	cParte3		:= '',;
	cDig3		:= '',;
	cParte4		:= '',;
	cParte5		:= '',;
	cDigital	:= '',;
	aRet		:= {}

	cAgencia	:= StrZero(Val(cAgencia),4)
	cNosso 		:= cNroDoc

	// Campo livre -  verificar a conta e carteira
	cFatorValor := xFator() + StrZero(nVlrTit*100,10)
	cCampoL 		:= cBanco + cMoeda + cFatorValor + Replicate('0',6) + cNosso + cCart

	// Campo do codigo de barra
	cDigBarra := U_CalCpBB(cCampoL)
	cBarra    := SubStr(cCampoL,1,4)+cDigBarra+SubStr(cCampoL,5,40)

	// Composicao da linha digitavel
	cParte1  := cBanco+cMoeda
	cParte1  += SubStr(cBarra,20,5)
	cDig1    := U_DIGIT001( cParte1 )
	cParte2  := SubStr(cBarra,25,10)
	cDig2    := U_DIGIT001( cParte2 )
	cParte3  := SubStr(cBarra,35,10)
	cDig3    := U_DIGIT001( cParte3 )
	cParte4  := ' '+cDigBarra+' '
	cParte5  := cFatorValor

	cDigital := SubStr(cParte1,1,5)+'.'+SubStr(cparte1,6,4)+cDig1+' '+;
	SubStr(cParte2,1,5)+'.'+SubStr(cparte2,6,5)+cDig2+' '+;
	SubStr(cParte3,1,5)+'.'+SubStr(cparte3,6,5)+cDig3+' '+;
	cParte4+;
	cParte5

	Aadd(aRet,cBarra)
	Aadd(aRet,cDigital)
	Aadd(aRet,cNosso)

Return( aRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xBraVerfBarบAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica/Gera o Codigo de Barra ( Bradesco )               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xBraVerfBar(cPrefixo,cNumero,cParcela,cTipo,;
	cBanco,cAgencia,cConta,cDacCC,;
	cNroDoc,nVlrTit,cCart,cMoeda)
	Local	cNosso		:= '',;
	nNum		:= '',;
	cCampoL		:= '',;
	cFatorValor	:= '',;
	cLivre		:= '',;
	cDigBarra	:= '',;
	cBarra		:= '',;
	cParte1		:= '',;
	cDig1		:= '',;
	cParte2		:= '',;
	cDig2		:= '',;
	cParte3		:= '',;
	cDig3		:= '',;
	cParte4		:= '',;
	cParte5		:= '',;
	cDigital	:= '',;
	aRet		:= {}

	cAgencia	:= StrZero(Val(cAgencia),4)
	cNosso 		:= ''

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFormulacao do nosso numeroณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( Len(AllTrim(cNroDoc)) == 12 ) // Ja esta pronto nao precisa verificar digito
		nNum	:= SubStr(cNroDoc,1,11)
		cNosso	:= cNroDoc
	Else
		nNum	:= StrZero(Val(cNroDoc),11)
		CNosso	:= nNum + xBraCalcDigN(StrZero(Val(cCart),2)+nNum)
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo Livre -  Verificar a conta e carteiraณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// 01 a 04 - 04 - Agencia Cedente
	// 05 a 06 - 02 - Carteira
	// 07 a 17 - 11 - Nosso Numero sem o digito
	// 18 a 24 - 07 - Conta Corrente sem o digito
	// 25 a 25 - 01 - Zero
	cCampoL := cAgencia + StrZero(Val(cCart),2) + nNum + StrZero(Val(cConta),7) + '0'

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo livre do codigo de barra - verificar a contaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cFatorValor  := xFator()+StrZero(nVlrTit*100,10)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta o campo Livre:ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// 000000000111111111122222222223333333333444444444455555555556
	// 123456789012345678901234567890123456789012345678901234567890
	// 2379?XXXX$$$$$$$$$$LLLLLLLLLLLLLLLLLLLLLLLLL
	// x  xx         x          x           x
	cLivre := cBanco + cMoeda + cFatorValor + cCampoL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo do codigo de barraณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cDigBarra := U_Calc_5pBr(cLivre)
	cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,43)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณComposicao da linha digitavelณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cParte1  := cBanco + cMoeda + SubStr(cCampoL,1,5)
	cDig1    := U_DIGIT001( cParte1 )
	cParte2  := SubStr(cCampoL,6,10)
	cDig2    := U_DIGIT001( cParte2 )
	cParte3  := SubStr(cCampoL,16,10)
	cDig3    := U_DIGIT001( cParte3 )
	cParte4  := ' '+cDigBarra+' '
	cParte5  :=  cFatorValor

	cDigital := SubStr(cParte1,1,5)+'.'+SubStr(cParte1,6,4)+cDig1+' '+;
	SubStr(cParte2,1,5)+'.'+SubStr(cParte2,6,5)+cDig2+' '+;
	SubStr(cParte3,1,5)+'.'+SubStr(cParte3,6,6)+cDig3+;
	cParte4+;
	cParte5

	Aadd(aRet,cBarra)
	Aadd(aRet,cDigital)
	Aadd(aRet,cNosso)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xAbcVerfBarบAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica/Gera o Codigo de Barra ( ABC BRasil )             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xAbcVerfBar(cPrefixo,cNumero,cParcela,cTipo,;
	cBanco,cAgencia,cConta,cDacCC,;
	cNroDoc,nVlrTit,cCart,cMoeda)
	Local	cNosso		:= '',;
	nNum		:= '',;
	cCampoL		:= '',;
	cFatorValor	:= '',;
	cLivre		:= '',;
	cDigBarra	:= '',;
	cBarra		:= '',;
	cParte1		:= '',;
	cDig1		:= '',;
	cParte2		:= '',;
	cDig2		:= '',;
	cParte3		:= '',;
	cDig3		:= '',;
	cParte4		:= '',;
	cParte5		:= '',;
	cDigital	:= '',;
	aRet		:= {}

	cAgencia	:= StrZero(Val(cAgencia),4)
	cNosso 		:= ''

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFormulacao do nosso numeroณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( Len(AllTrim(cNroDoc)) == 12 ) // Ja esta pronto nao precisa verificar digito
		nNum	:= SubStr(cNroDoc,1,11)
		cNosso	:= cNroDoc
	Else
		nNum	:= StrZero(Val(cNroDoc),11)
		CNosso	:= nNum + xAbcCalcDigN(StrZero(Val(cCart),2)+nNum)
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo Livre -  Verificar a conta e carteiraณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// 01 a 04 - 04 - Agencia Cedente
	// 05 a 06 - 02 - Carteira
	// 07 a 17 - 11 - Nosso Numero sem o digito
	// 18 a 24 - 07 - Conta Corrente sem o digito
	// 25 a 25 - 01 - Zero
	cCampoL := cAgencia + StrZero(Val(cCart),2) + nNum + StrZero(Val(cConta),7) + '0'

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo livre do codigo de barra - verificar a contaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cFatorValor  := xFator()+StrZero(nVlrTit*100,10)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta o campo Livre:ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// 000000000111111111122222222223333333333444444444455555555556
	// 123456789012345678901234567890123456789012345678901234567890
	// 2379?XXXX$$$$$$$$$$LLLLLLLLLLLLLLLLLLLLLLLLL
	// x  xx         x          x           x
	cLivre := cBanco + cMoeda + cFatorValor + cCampoL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo do codigo de barraณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cDigBarra := U_Calc_5pBr(cLivre)
	cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,43)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณComposicao da linha digitavelณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cParte1  := cBanco + cMoeda + SubStr(cCampoL,1,5)
	cDig1    := U_DIGIT001( cParte1 )
	cParte2  := SubStr(cCampoL,6,10)
	cDig2    := U_DIGIT001( cParte2 )
	cParte3  := SubStr(cCampoL,16,10)
	cDig3    := U_DIGIT001( cParte3 )
	cParte4  := ' '+cDigBarra+' '
	cParte5  :=  cFatorValor

	cDigital := SubStr(cParte1,1,5)+'.'+SubStr(cParte1,6,4)+cDig1+' '+;
	SubStr(cParte2,1,5)+'.'+SubStr(cParte2,6,5)+cDig2+' '+;
	SubStr(cParte3,1,5)+'.'+SubStr(cParte3,6,6)+cDig3+;
	cParte4+;
	cParte5

	Aadd(aRet,cBarra)
	Aadd(aRet,cDigital)
	Aadd(aRet,cNosso)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xItaVerfBarบAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica/Gera o Codigo de Barra ( Bradesco )               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xItaVerfBar(cPrefixo,cNumero,cParcela,cTipo,;
	cBanco,cAgencia,cConta,cDacCC,;
	cNroDoc,nVlrTit,cCart,cMoeda)
	Local	cNosso		:= '',;
	nNum		:= '',;
	cCampoL		:= '',;
	cFatorValor	:= '',;
	cLivre		:= '',;
	cDigBarra	:= '',;
	cBarra		:= '',;
	cParte1		:= '',;
	cDig1		:= '',;
	cParte2		:= '',;
	cDig2		:= '',;
	cParte3		:= '',;
	cDig3		:= '',;
	cParte4		:= '',;
	cParte5		:= '',;
	cDigital	:= '',;
	aRet		:= {}

	cAgencia	:= StrZero(Val(cAgencia),4)
	cNosso 		:= ''

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFormulacao do nosso numeroณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( Len(AllTrim(cNroDoc)) == 12 ) // Ja esta pronto nao precisa verificar digito
		nNum	:= SubStr(cNroDoc,1,11)
		cNosso	:= cNroDoc
	Else
		nNum	:= StrZero(Val(cNroDoc),11)
		cNosso	:= nNum + U_DIGIT001(cAgencia+cConta+nNum)
	EndIf

	//ConOut('Nosso Numero s/ digito..:' + nNum)
	//ConOut('Nosso Numero c/ digito..:' + cNosso)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo Livre -  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cCampoL := AllTrim(cNosso) + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + U_DIGIT001(cAgencia+cConta) + '000'

	//ConOut('Agencia..:' + cAgencia )
	//ConOut('Carteira.:' + StrZero(val(cCart),2) )
	//ConOut('Nosso Num s/digito.:' + nNum )
	//ConOut('Conta Cedente..:' + StrZero(Val(cConta),7) )
	ConOut('Formado campo-livre..:' + cCampoL )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo livre do codigo de barra - verificar a contaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cFatorValor  := xFator()+StrZero(nVlrTit*100,10)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta o campo Livre:ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// 000000000111111111122222222223333333333444444444455555555556
	// 123456789012345678901234567890123456789012345678901234567890
	// 2379?XXXX$$$$$$$$$$LLLLLLLLLLLLLLLLLLLLLLLLL
	// x  xx         x          x           x
	cLivre := cBanco + cMoeda + cFatorValor + cCampoL

	//ConOut('Banco..:' + cBanco )
	//ConOut('Moeda..:' + cMoeda )
	ConOut('Fator+Valor..:' + cFatorValor )
	ConOut('Campo Livre..:' + cCampoL )

	//ConOut('Codigo para gerar o codigo de barras..:' + cLivre )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo do codigo de barraณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cDigBarra := U_Calc_5pIt(cLivre)
	cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,43)

	ConOut('Digito Calculado..:' + cDigBarra )
	ConOut('Codigo Completo...:' + cBarra )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณComposicao da linha digitavelณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cParte1  := cBanco + cMoeda + SubStr(cCampoL,1,5)
	cDig1    := U_DIGIT001( cParte1 )
	cParte2  := SubStr(cCampoL,6,10)
	cDig2    := U_DIGIT001( cParte2 )
	cParte3  := SubStr(cCampoL,16,10)
	cDig3    := U_DIGIT001( cParte3 )
	cParte4  := ' '+cDigBarra+' '
	cParte5  :=  cFatorValor

	cDigital := SubStr(cParte1,1,5)+'.'+SubStr(cParte1,6,4)+cDig1+' '+;
	SubStr(cParte2,1,5)+'.'+SubStr(cParte2,6,5)+cDig2+' '+;
	SubStr(cParte3,1,5)+'.'+SubStr(cParte3,6,6)+cDig3+;
	cParte4+;
	cParte5

	Aadd(aRet,cBarra)
	Aadd(aRet,cDigital)
	Aadd(aRet,cNosso)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xReaVerfBarบAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica/Gera o Codigo de Barra ( Real )                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xReaVerfBar(cPrefixo,cNumero,cParcela,cTipo,;
	cBanco,cAgencia,cConta,cDacCC,;
	cNroDoc,nVlrTit,cCart,cMoeda)
	Local	cNosso		:= '',;
	nNum		:= '',;
	cCampoL		:= '',;
	cFatorValor	:= '',;
	cLivre		:= '',;
	cDigBarra	:= '',;
	cBarra		:= '',;
	cParte1		:= '',;
	cDig1		:= '',;
	cParte2		:= '',;
	cDig2		:= '',;
	cParte3		:= '',;
	cDig3		:= '',;
	cParte4		:= '',;
	cParte5		:= '',;
	cDigital	:= '',;
	aRet		:= {}

	cAgencia	:= StrZero(Val(cAgencia),4)
	cNosso 		:= ''

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFormulacao do nosso numeroณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nNum	:= StrZero(Val(cNroDoc),7)
	cNosso	:= nNum

	//ConOut('Nosso Numero s/ digito..:' + nNum)
	//ConOut('Nosso Numero c/ digito..:' + cNosso)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo Livre -  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cCampoL := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + U_DIGIT001( cNosso + cAgencia + StrZero(Val(cConta),7) ) + StrZero(Val(cNosso),13)

	//ConOut('Agencia..:' + cAgencia )
	//ConOut('Carteira.:' + StrZero(val(cCart),2) )
	//ConOut('Nosso Num s/digito.:' + nNum )
	//ConOut('Conta Cedente..:' + StrZero(Val(cConta),7) )
	ConOut('Formado campo-livre..:' + cCampoL )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo livre do codigo de barra - verificar a contaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cFatorValor  := xFator()+StrZero(nVlrTit*100,10)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta o campo Livre:ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// 000000000111111111122222222223333333333444444444455555555556
	// 123456789012345678901234567890123456789012345678901234567890
	// 2379?XXXX$$$$$$$$$$LLLLLLLLLLLLLLLLLLLLLLLLL
	// x  xx         x          x           x
	cLivre := cBanco + cMoeda + cFatorValor + cCampoL

	//ConOut('Banco..:' + cBanco )
	//ConOut('Moeda..:' + cMoeda )
	ConOut('Fator+Valor..:' + cFatorValor )
	ConOut('Campo Livre..:' + cCampoL )

	//ConOut('Codigo para gerar o codigo de barras..:' + cLivre )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampo do codigo de barraณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cDigBarra := U_Calc_5pRe(cLivre)
	cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,43)

	ConOut('Digito Calculado..:' + cDigBarra )
	ConOut('Codigo Completo...:' + cBarra )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณComposicao da linha digitavelณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cParte1  := cBanco + cMoeda + SubStr(cCampoL,1,5)
	cDig1    := U_DIGIT001( cParte1 )
	cParte2  := SubStr(cCampoL,6,10)
	cDig2    := U_DIGIT001( cParte2 )
	cParte3  := SubStr(cCampoL,16,10)
	cDig3    := U_DIGIT001( cParte3 )
	cParte4  := ' '+cDigBarra+' '
	cParte5  :=  cFatorValor

	cDigital := SubStr(cParte1,1,5)+'.'+SubStr(cParte1,6,4)+cDig1+' '+;
	SubStr(cParte2,1,5)+'.'+SubStr(cParte2,6,5)+cDig2+' '+;
	SubStr(cParte3,1,5)+'.'+SubStr(cParte3,6,6)+cDig3+;
	cParte4+;
	cParte5

	Aadd(aRet,cBarra)
	Aadd(aRet,cDigital)
	Aadd(aRet,cNosso)

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xHsbVerfBarบAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica/Gera o Codigo de Barra ( Real )                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xHsbVerfBar(cPrefixo,cNumero,cParcela,cTipo,;
	cBanco,cAgencia,cConta,cDacCC,;
	cNroDoc,nVlrTit,cCart,cMoeda,dVencto,cCedente)

	Local nNroDoc     := 0
	Local nCedente    := 0
	Local nFatVct     := 0
	Local	cNosso		:= ''
	Local nParDig     := 0

	Local	cBarra		:= ''
	Local	cDigBarra	:= ''

	Local	cParte1		:= ''
	Local	cDig1		   := ''
	Local	cParte2		:= ''
	Local	cDig2		   := ''
	Local	cParte3		:= ''
	Local	cDig3		   := ''
	Local	cParte4		:= ''
	Local	cParte5		:= ''
	Local	cDigital	   := ''

	Local	aRet		   := {}

	//Zera e ajusta algumas variแvels
	cAgencia	:= StrZero(Val(cAgencia),4)
	cCC        := StrZero(Val(cConta + cDacCC ),7)
	cNosso 	:=  AllTrim(cNroDoc)
	cCedente    :=  StrZero(Val(cCedente),7)  // Alltrim(cCedente)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFormulacao do nosso numero (N๚mero Bancแrio) ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(AllTrim(cNroDoc)) != 11	//Quando jแ existe o Nosso N๚mero do banco ele vem com tamanho 15, entใo s๓ gero novamente
		//se for menor que este tamanho.

		//Calculo do dํgito verificador do Nosso N๚mero
		cDigNNum	:= xHSBCalcDigN(cNroDoc,7,2,'CL')
		cNroDoc	:= cNroDoc + cDigNNum
		cNosso		:= cNroDoc

	Else
		cNosso := AllTrim(cNroDoc)
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cแlculo do C๓digo de Barras ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	//Primeiro calculo o dํgito verificador

	cBarra := cBanco + cMoeda + xFator() + StrZero(nVlrTit*100,10) + cNosso + cAgencia + cCC + "00" + "1"

	cDigBarra :=  xHSBCalcDigN(cBarra,9,2,'CB') //11 - Val(xCalMod11(cBarra,9,2,'C'))

	cBarra := Substr(cBarra,1,4) + cDigBarra + Substr(cBarra,5,999)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณComposicao da linha digitavelณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cParte1  := cBanco + cMoeda + SubStr(cNosso,1,5)
	cDig1    := U_DIGIT001( cParte1 )

	cParte2  := SubStr(cNosso,6,6) + Substr(cAgencia,1,4)
	cDig2    := U_DIGIT001( cParte2 )

	cParte3  := cCC+"00"+"1"
	cDig3    := U_DIGIT001( cParte3 )

	cParte4  := ' '+cDigBarra+' '

	cParte5  :=  xFator() + StrZero(nVlrTit*100,10)

	cDigital :=	SubStr(cParte1,1,5)+'.'+SubStr(cParte1,6,4)+cDig1+' '+;
	SubStr(cParte2,1,5)+'.'+SubStr(cParte2,6,5)+cDig2+' '+;
	SubStr(cParte3,1,5)+'.'+SubStr(cParte3,6,6)+cDig3+;
	cParte4+;
	cParte5

	Aadd(aRet,cBarra)   //C๓digo de Barras
	Aadd(aRet,cDigital) //Linha Digitแvel
	Aadd(aRet,cNosso)   //Nosso N๚mero

Return aRet

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFormulacao do nosso numero (N๚mero Bancแrio) ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(cNroDoc) < 15  //Quando jแ existe o Nosso N๚mero do banco ele vem com tamanho 15, entใo s๓ gero novamente
//se for menor que este tamanho.

//Calculo do dํgito verificar primeira parte
nNroDoc   := Val(xCalMod11(cNroDoc,9,2,'D'))
nNroDoc   := If(nNroDoc=0 .Or. nNroDoc=10,'0',cValToChar(nNroDoc))
nNroDoc   := PadL(AllTrim(cNroDoc),13,'0') + nNroDoc

nNroDoc   += '4'   //A pen๚ltima posi็ใo ้ sempre o “tipo identificador”, sendo que:
//“4” - Vincula: “vencimento”, “c๓digo do cedente” e “c๓digo do documento”;
cNosso   := nNroDoc
nNroDoc	:= Val(nNroDoc)
nCedente	:= Val(cCedente)
nFatVct  := Val( Substr(DTOS(dVencto),7,2) + Substr(DTOS(dVencto),5,2) + Substr(DTOS(dVencto),3,2) )
nNroDoc  := nNroDoc + nCedente + nFatVct

nParDig	:= Val(xCalMod11(StrZero(nNroDoc,15),9,2,'D'))
nparDig  := If(nParDig=0 .Or. nParDig=10,'0',cValToChar(nParDig))

cNosso   := cNosso + nParDig
Else
cNosso := StrZero(Val(cNroDoc),16)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cแlculo do C๓digo de Barras ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Primeiro calculo o dํgito verificador

cBarra := cBanco + cMoeda + xFator() + StrZero(nVlrTit*100,10) + StrZero(Val(cCedente),7) + Substr(cNosso,1,13)

//Adiciona Data no Formato Juliano HSBC - Parametro MV_HSBCJUL
cBarra += If( GetNewPar('MV_HSBCJUL',.T.), xJuliano(dVencto), '0000' )

cBarra += '1'   //C๓digo do aplicativo CSB = 1

//se            0-10-1
cDigBarra := 11 - Val(xCalMod11(cBarra,9,2,'C'))
cDigBarra := If(cDigBarra=0 .Or. cDigBarra=10,'1',cValToChar(cDigBarra))

cBarra := Substr(cBarra,1,4) + cDigBarra + Substr(cBarra,5,999)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณComposicao da linha digitavelณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cParte1  := cBanco + cMoeda + SubStr(cCedente,1,5)
cDig1    := U_DIGIT001( cParte1 )

cParte2  := SubStr(cCedente,6,2) + Substr(cNosso,1,8)
cDig2    := U_DIGIT001( cParte2 )

cParte3  := SubStr(cNosso,9,5) + If( GetNewPar('MV_HSBCJUL',.T.),xJuliano(dVencto),'0000') + '2'
cDig3    := U_DIGIT001( cParte3 )

cParte4  := ' '+cDigBarra+' '

cParte5  :=  xFator() + StrZero(nVlrTit*100,10)

cDigital := SubStr(cParte1,1,5)+'.'+SubStr(cParte1,6,4)+cDig1+' '+;
SubStr(cParte2,1,5)+'.'+SubStr(cParte2,6,5)+cDig2+' '+;
SubStr(cParte3,1,5)+'.'+SubStr(cParte3,6,6)+cDig3+;
cParte4+;
cParte5

Aadd(aRet,cBarra)   //C๓digo de Barras
Aadd(aRet,cDigital) //Linha Digitแvel
Aadd(aRet,cNosso)   //Nosso N๚mero

Return aRet
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xSicVerfBarบAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica/Gera o Codigo de Barra ( Sicredi )                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//Alterada a fun็ใo por tatiane minamiya para fazer o cแlculo do dํgito verificador do Sicredi corretamente
Static Function xSicVerfBar(cPrefixo,cNumero,cParcela,cTipo,;
	cBanco,cAgencia,cConta,cDacCC,cNroDoc,;
	nVlrTit,cCart,cMoeda,dVencto,cCedente,cConvenio)

	Local   nNroDoc     := 0
	Local   nCedente    := 0
	Local   nFatVct     := 0
	Local	cNosso		:= ''

	Local	cBarra		:= ''
	Local	cDigBarra	:= ''
	Local   cCpoLivre   := ''

	Local	cParte1		:= ''
	Local	cDig1		   := ''
	Local	cParte2		:= ''
	Local	cDig2		   := ''
	Local	cParte3		:= ''
	Local	cDig3		   := ''
	Local	cParte4		:= ''
	Local	cParte5		:= ''
	Local	cDigital	   := ''

	Local	aRet		   := {}

	//Zera e ajusta algumas variแvels
	cAgencia	   := StrZero(Val(cAgencia),4)
	cNosso 		:= ''

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFormulacao do nosso numero (N๚mero Bancแrio) ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(AllTrim(cNroDoc)) < 9               //EE_CODCOBE
		//Calculo do dํgito verificador     748       20        04               99                          2   99999
		cNossoNum := cAgencia+cConvenio+alltrim(cCedente)+alltrim(Right(cValToChar(Year(dDataBase)),2))+'2'+cNroDoc
		//nNroDoc    := 11 - Val(xCalMod11(cAgencia+cConvenio+alltrim(cCedente)+alltrim(Right(cValToChar(Year(dDataBase)),2))+'2'+cNroDoc,9,2,'C'))
		//nNroDoc    := If( nNroDoc > 9,'0',cValToChar(nNroDoc))

		nSoma1 := Val(SubStr(cNossoNum,Len(cNossoNum),1))*2
		nSoma2 := Val(SubStr(cNossoNum,Len(cNossoNum)-1,1))*3
		nSoma3 := Val(SubStr(cNossoNum,Len(cNossoNum)-2,1))*4
		nSoma4 := Val(SubStr(cNossoNum,Len(cNossoNum)-3,1))*5
		nSoma5 := Val(SubStr(cNossoNum,Len(cNossoNum)-4,1))*6
		nSoma6 := Val(SubStr(cNossoNum,Len(cNossoNum)-5,1))*7
		nSoma7 := Val(SubStr(cNossoNum,Len(cNossoNum)-6,1))*8
		nSoma8 := Val(SubStr(cNossoNum,Len(cNossoNum)-7,1))*9
		nSoma9 := Val(SubStr(cNossoNum,Len(cNossoNum)-8,1))*2
		nSomaA := Val(SubStr(cNossoNum,Len(cNossoNum)-9,1))*3
		nSomaB := Val(SubStr(cNossoNum,Len(cNossoNum)-10,1))*4
		nSomaC := Val(SubStr(cNossoNum,Len(cNossoNum)-11,1))*5
		nSomaD := Val(SubStr(cNossoNum,Len(cNossoNum)-12,1))*6
		nSomaE := Val(SubStr(cNossoNum,Len(cNossoNum)-13,1))*7
		nSomaF := Val(SubStr(cNossoNum,Len(cNossoNum)-14,1))*8
		nSomaG := Val(SubStr(cNossoNum,Len(cNossoNum)-15,1))*9
		nSomaH := Val(SubStr(cNossoNum,Len(cNossoNum)-16,1))*2
		nSomaI := Val(SubStr(cNossoNum,Len(cNossoNum)-17,1))*3
		nSomaJ := Val(SubStr(cNossoNum,Len(cNossoNum)-18,1))*4

		nNroDoc := ( nSoma1+nSoma2+nSoma3+nSoma4+nSoma5+nSoma6+nSoma7+nSoma8+nSoma9+nSomaA+nSomaB+nSomaC+nSomaD+nSomaE+nSomaF+nSomaG+nSomaH+nSomaI+nSomaJ )
		nNroDoc := nNroDoc / 11
		nNroDoc := Int(nNroDoc) * 11
		nNroDoc := ( nSoma1+nSoma2+nSoma3+nSoma4+nSoma5+nSoma6+nSoma7+nSoma8+nSoma9+nSomaA+nSomaB+nSomaC+nSomaD+nSomaE+nSomaF+nSomaG+nSomaH+nSomaI+nSomaJ ) - nNroDoc
		nNroDoc := 11 - nNroDoc

		If nNroDoc > 9
			nNroDoc := 0
		EndIf

		nNroDoc := cValtochar(nNroDoc)

		//Montagem do nosso n๚mero
		cNosso    := Right(cValToChar(Year(dDataBase)),2)			// ANO (DOIS DIGITOS)
		cNosso    += '2'        //FIXO
		cNosso    += cNroDoc    //SEQUENCIAO EE_FAIXATU
		cNosso    += nNroDoc    //DIGITO
	Else
		cNosso := AllTrim(cNroDoc)
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cแlculo do C๓digo de Barras ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cCpoLivre := '1'   //C๓digo da cobran็a no Sicredi
	cCpoLivre += cCart
	cCpoLivre += cNosso
	cCpoLivre += cAgencia + cConvenio
	cCpoLivre += PadL(cCedente,5,'0')
	cCpoLivre += '1'    //Se hแ valor do documento, preencher com 1.
	cCpoLivre += '0'    //Filler Zeros

	_nSoma1 := Val(SubStr(cCpoLivre,Len(cCpoLivre),1))*2
	_nSoma2 := Val(SubStr(cCpoLivre,Len(cCpoLivre)-1,1))*3
	_nSoma3 := Val(SubStr(cCpoLivre,Len(cCpoLivre)-2,1))*4
	_nSoma4 := Val(SubStr(cCpoLivre,Len(cCpoLivre)-3,1))*5
	_nSoma5 := Val(SubStr(cCpoLivre,Len(cCpoLivre)-4,1))*6
	_nSoma6 := Val(SubStr(cCpoLivre,Len(cCpoLivre)-5,1))*7
	_nSoma7 := Val(SubStr(cCpoLivre,Len(cCpoLivre)-6,1))*8
	_nSoma8 := Val(SubStr(cCpoLivre,Len(cCpoLivre)-7,1))*9
	_nSoma9 := Val(SubStr(cCpoLivre,Len(cCpoLivre)-8,1))*2
	_nSomaA := Val(SubStr(cCpoLivre,Len(cCpoLivre)-9,1))*3
	_nSomaB := Val(SubStr(cCpoLivre,Len(cCpoLivre)-10,1))*4
	_nSomaC := Val(SubStr(cCpoLivre,Len(cCpoLivre)-11,1))*5
	_nSomaD := Val(SubStr(cCpoLivre,Len(cCpoLivre)-12,1))*6
	_nSomaE := Val(SubStr(cCpoLivre,Len(cCpoLivre)-13,1))*7
	_nSomaF := Val(SubStr(cCpoLivre,Len(cCpoLivre)-14,1))*8
	_nSomaG := Val(SubStr(cCpoLivre,Len(cCpoLivre)-15,1))*9
	_nSomaH := Val(SubStr(cCpoLivre,Len(cCpoLivre)-16,1))*2
	_nSomaI := Val(SubStr(cCpoLivre,Len(cCpoLivre)-17,1))*3
	_nSomaJ := Val(SubStr(cCpoLivre,Len(cCpoLivre)-18,1))*4
	_nSomaK := Val(SubStr(cCpoLivre,Len(cCpoLivre)-19,1))*5
	_nSomaL := Val(SubStr(cCpoLivre,Len(cCpoLivre)-20,1))*6
	_nSomaM := Val(SubStr(cCpoLivre,Len(cCpoLivre)-21,1))*7
	_nSomaN := Val(SubStr(cCpoLivre,Len(cCpoLivre)-22,1))*8
	_nSomaO := Val(SubStr(cCpoLivre,Len(cCpoLivre)-23,1))*9

	//cDigBarra := 11-Val(xCalMod11(cCpoLivre,9,2,'C'))
	//cDigBarra := If(cDigBarra>9,'0',cValToChar(cDigBarra))

	cDigBarra := _nSoma1 + _nSoma2 + _nSoma3 + _nSoma4 + _nSoma5 + _nSoma6 + _nSoma7 + _nSoma8 + _nSoma9 + _nSomaA + _nSomaB + _nSomaC + _nSomaD + _nSomaE + _nSomaF + _nSomaG + _nSomaH + _nSomaI + _nSomaJ + _nSomaK + _nSomaL + _nSomaM + _nSomaN + _nSomaO
	cDigBarra := cDigBarra / 11
	cDigBarra := Int(cDigBarra) * 11
	cDigBarra := ( _nSoma1 + _nSoma2 + _nSoma3 + _nSoma4 + _nSoma5 + _nSoma6 + _nSoma7 + _nSoma8 + _nSoma9 + _nSomaA + _nSomaB + _nSomaC + _nSomaD + _nSomaE + _nSomaF + _nSomaG + _nSomaH + _nSomaI + _nSomaJ + _nSomaK + _nSomaL + _nSomaM + _nSomaN + _nSomaO ) - cDigBarra
	If cDigBarra == 0 .Or. cDigBarra == 1
		cDigBarra := 0
	Else
		cDigBarra := 11 - cDigBarra
	EndIf
	If cDigBarra > 9
		cDigBarra := 0
	EndIf

	cDigBarra := cValtochar(cDigBarra)

	cCpoLivre := cCpoLivre + cDigBarra

	cBarra    := cBanco
	cBarra    += cMoeda
	cBarra    += xFator()
	cBarra    += StrZero(nVlrTit*100,10)
	cBarra    += cCpoLivre

	cDigBarra := 11 - Val(xCalMod11(cBarra,9,2,'C'))
	cDigBarra := If(cDigBarra > 9 .Or. cDigBarra = 0 .Or. cDigBarra = 1,'1',cValToChar(cDigBarra))

	cBarra    := Substr(cBarra,1,4) + cDigBarra + Substr(cBarra,5,999)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณComposicao da linha digitavelณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cParte1  := cBanco + cMoeda + SubStr(cCpoLivre,1,5)
	cDig1    := U_DIGIT001( cParte1 )

	cParte2  := SubStr(cCpoLivre,6,10)
	cDig2    := U_DIGIT001( cParte2 )

	cParte3  := SubStr(cCpoLivre,16,10)
	cDig3    := U_DIGIT001( cParte3 )

	cParte4  := ' '+cDigBarra+' '

	cParte5  :=  xFator() + StrZero(nVlrTit*100,10)

	cDigital := 	SubStr(cParte1,1,5)+'.'+SubStr(cParte1,6,4)+cDig1+' '+;
	SubStr(cParte2,1,5)+'.'+SubStr(cParte2,6,5)+cDig2+' '+;
	SubStr(cParte3,1,5)+'.'+SubStr(cParte3,6,6)+cDig3+;
	cParte4+;
	cParte5

	Aadd(aRet,cBarra)   //C๓digo de Barras
	Aadd(aRet,cDigital) //Linha Digitแvel
	Aadd(aRet,cNosso)   //Nosso N๚mero

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xCaiVerfBarบAutorณANDRE VICENTE       บ Data ณ  23/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica/Gera o Codigo de Barra ( CAIXA )                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*/

Static Function xCaiVerfBar(cPrefixo,cNumero,cParcela,cTipo,;
	cBanco,cAgencia,cConta,cDacCC,cNroDoc,;
	nVlrTit,cCart,cMoeda,dVencto,cCedente,cConvenio)

	Local   nNroDoc     := 0
	Local   nCedente    := 0
	Local   nFatVct     := 0
	Local	cNosso		:= ''
	local   cResto      := ''
	Local	cBarra		:= ''
	Local	cDigBarra	:= ''
	Local   cCpoLivre   := ''

	Local	cParte1		:= ''
	Local	cDig1		:= ''
	Local	cParte2		:= ''
	Local	cDig2	    := ''
	Local	cParte3		:= ''
	Local	cDig3		:= ''
	Local	cParte4		:= ''
	Local	cParte5		:= ''
	Local	cDigital	:= ''

	Local	aRet		:= {}

	//Zera e ajusta algumas variแvels
	cAgencia    := StrZero(Val(cAgencia),4)
	cNosso 		:= ''

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFormulacao do nosso numero (N๚mero Bancแrio) ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(AllTrim(cNroDoc)) <= 9               //SEQUENCIAL EE_FAIXATU

		//Calculo do dํgito verificador
		nNroDoc    := 11 - Val(xCalMod('9'+cNroDoc,1,10))      // DIGITO VERIFICADOR CAIXA
		nNroDoc    := If( nNroDoc > 9,'0',cValToChar(nNroDoc))

		//Montagem do nosso n๚mero
		cNosso    += '9'        //FIXO
		cNosso    += cNroDoc    //SEQUENCIAO EE_FAIXATU
		cNosso    += nNroDoc    //DIGITO
	Else
		cNosso := AllTrim(cNroDoc)
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cแlculo do C๓digo de Barras ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cCpoLivre := Substr(cNosso,1,10)  // nosso numero sem DV
	cCpoLivre += Substr(cConvenio,1,15)  // cod cedente sem DV


	cBarra    := cBanco    // 104
	cBarra    += cMoeda    // 9
	cBarra    += xFator()  //10/07/1997 menos a data de vencimento  padrao febraban
	cBarra    += StrZero(nVlrTit*100,10)
	cBarra    += Substr(cNosso,1,10)
	cBarra    += Substr(cConvenio,1,15)

	cDigBarra := 11 - Val(xCBCaixa(cBarra,1,4,'C') + (cBarra,5,44,'C'))
	cDigBarra := If(cDigBarra > 9 .Or. cDigBarra = 0 .Or. cDigBarra = 1,'1',cValToChar(cDigBarra))

	cBarra    := Substr(cBarra,1,4) + cDigBarra + Substr(cBarra,5,999)


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณComposicao da linha digitavelณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cParte1  := SubStr(cBarra,1,4) + SubStr(cCpoLivre,1,5)
	cDig1    := U_DIGIT001( cParte1 )

	cParte2  := SubStr(cCpoLivre,6,10)
	cDig2    := U_DIGIT001( cParte2 )

	cParte3  := SubStr(cCpoLivre,16,10)
	cDig3    := U_DIGIT001( cParte3 )

	cParte4  := ' '+cDigBarra+' '

	cParte5  := SubStr(cBarra,6,4) + SubStr(cBarra,10,10)

	cDigital := SubStr(cParte1,1,5)+'.'+SubStr(cParte1,6,4)+cDig1+' '+;
	SubStr(cParte2,1,5)+'.'+SubStr(cParte2,6,5)+cDig2+' '+;
	SubStr(cParte3,1,5)+'.'+SubStr(cParte3,6,6)+cDig3+;
	cParte4+;
	cParte5

	Aadd(aRet,cBarra)   //C๓digo de Barras
	Aadd(aRet,cDigital) //Linha Digitแvel
	Aadd(aRet,cNosso)   //Nosso N๚mero

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ FATOR	บAutor  ณMicrosiga           บ Data ณ  02/13/04      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo do FATOR de vencimento para linha digitavel.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xFator()

	If	Len(AllTrim(SubStr(DTOC(IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA )),7,4))) = 4
		cData := SubStr(DTOC(IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA )),7,4)+SubStr(DTOC(IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA )),4,2)+SubStr(DTOC(IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA )),1,2)
	Else
		cData := '20'+SubStr(DTOC(IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA )),7,2)+SubStr(DTOC(IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA )),4,2)+SubStr(DTOC(IIf ( !Empty( dNewVencto ) , dNewVencto , SE1->E1_VENCREA )),1,2)
	EndIf

	cFator := STR(1000+(STOD(cData)-STOD('20000703')),4)

Return(cFator)

/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xCalMod    บAutorณAndre Vicente       บ Data ณ  24/10/2012 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Para calculo do DV NOSSO NUMERO CAIXA ECONOMICA            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xCalMod(cVariavel) // nosso numero EE_FAIXAATU  Modulo 11 forma de Calculo

	Local nCont	:= 0

	nCont	:= nCont+(Val(Subs(cVariavel,10,1))*2)
	nCont	:= nCont+(Val(Subs(cVariavel,09,1))*3)
	nCont	:= nCont+(Val(Subs(cVariavel,08,1))*4)
	nCont	:= nCont+(Val(Subs(cVariavel,07,1))*5)
	nCont	:= nCont+(Val(Subs(cVariavel,06,1))*6)
	nCont	:= nCont+(Val(Subs(cVariavel,05,1))*7)
	nCont	:= nCont+(Val(Subs(cVariavel,04,1))*8)
	nCont	:= nCont+(Val(Subs(cVariavel,03,1))*9)
	nCont	:= nCont+(Val(Subs(cVariavel,02,1))*2)
	nCont	:= nCont+(Val(Subs(cVariavel,01,1))*3)

	nCont1  := int(nCont  / 11)
	nCont2	:= ncont1 * 11
	nResto  := ncont - ncont2

Return(Strzero(nResto,1))

/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xCBCaixa   บAutorณ Andre Vicente      บ Data ณ 24/10/2012  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Para calculo do DV Geral Cod Barra  Caixa Economica        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//   nBas1 = Base Maior    nBas2 = Base Menor

Static Function xCBCaixa(cVariavel)

	Local	Auxi	:= 0
	Local	SumDig	:= 0
	Local	nbase  	:= Len(cVariavel)
	Local	iDig   	:= nBase
	Local	base   	:= 0
	Local	sumdig 	:= 0
	Local	Auxi   	:= 0
	Local nBas1  := 9
	Local nBas2  := 2
	Local cOrdem := 'D'

	If Upper(cOrdem) == 'D'

		base := nBas2

		While	iDig >= 1
			If	( base == (nBas1+1) )
				base := nBas2
			EndIf

			auxi   := Val(SubStr(cVariavel, idig, 1)) * base
			sumdig += auxi
			base++
			iDig--
		End
	EndIF

	auxi := mod(Sumdig,11)

Return( Str(auxi,1,0) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ DIGSICOOB บAutor  ณ Andre Vicente            ณ  03/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Para calculo usando modulo 10  -3791 FIXO                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DigSicoob(cVariavel)

	Local cNN  		:= cVariavel
	Local cDig	 	:=""
	Local nTotal 	:= 0
	Local Soma 		:= 0
	Local auxi 		:= 0
	Local nDigi 	:= 1
	Local i         := 0

	For i:= 1 to Len(cNN)+1

		auxi:=val(Substr(cNN,i,1))

		DO CASE
			CASE nDigi = 1
			nDigi := 3
			CASE nDigi = 3
			nDigi := 7
			CASE nDigi = 7
			nDigi := 9
			CASE nDigi = 9
			nDigi := 1
		ENDCASE

		Soma += nDigi * auxi
	Next i

	nTotal += Soma

	nCont1  := int(nTotal  / 11)
	nCont2	:= ncont1 * 11
	nResto  := nTotal - ncont2

Return(Strzero(nResto,1))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ CALCpBB  บAutor  ณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo do digito do nosso numero                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CALCpBB(cVariavel)
	Local	Auxi	:= 0,;
	sumdig	:= 0

	cbase	:= cVariavel
	lbase	:= LEN(cBase)
	base 	:= 2
	sumdig	:= 0
	Auxi 	:= 0
	iDig  	:= lBase

	While	( iDig >= 1 )
		If	( base >= 10 )
			base := 2
		EndIf
		auxi   := Val(SubStr(cBase, idig, 1)) * base
		sumdig := SumDig+auxi
		base++
		iDig--
	EndDo

	auxi := mod(sumdig,11)
	If	( auxi == 0 ) .or. ( auxi == 1 ) .or. ( auxi >= 10 )
		auxi := 1
	Else
		auxi := 11 - auxi
	EndIf

Return(Str(auxi,1,0))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xHSBCalcDigN NบAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุอออออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Para calculo do nosso numero do banco do HSBC                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                       บฑฑ
ฑฑฬออออออออออุออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                            บฑฑ
ฑฑฬออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                    บฑฑ
ฑฑศออออออออออฯออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xHSBCalcDigN(cVariavel,nBas1,nBas2,cOrdem,nSeZer,nSeDez,nSeUm)

	Local	Auxi	   := 0
	Local	SumDig	:= 0

	Local	nbase  	:= Len(cVariavel)
	Local	iDig   	:= nBase
	Local	base   	:= 0
	Local	sumdig 	:= 0
	Local	Auxi   	:= 0

	Default nBas1  := 9
	Default nBas2  := 2
	Default nSeZer := 0
	Default nSeDez := 0
	Default nSeUm  := 1
	Default cOrdem := 'D'

	If Upper(cOrdem) == 'D'
		base := nBas1
		While	iDig >= 1
			If	( base == (nBas2-1) )
				base := nBas1
			EndIf

			auxi   := Val(SubStr(cVariavel, idig, 1)) * base
			sumdig += auxi
			base--
			iDig--
		End
	Else
		base := nBas2
		While	iDig >= 1
			If	( base == (nBas1+1) )
				base := nBas2
			EndIf

			auxi   := Val(SubStr(cVariavel, idig, 1)) * base
			sumdig += auxi
			base++
			iDig--
		End
	EndIF

	auxi := mod(Sumdig,11)

	If Upper(cOrdem) == 'CL'
		If auxi = 0 .Or. auxi = 1
			auxi := 0
		Else
			auxi := 11 - auxi
		EndIF
	ElseIf Upper(cOrdem) == 'CB'
		If auxi = 0 .Or. auxi = 1 .Or. auxi = 10
			auxi := 1
		Else
			auxi := 11 - auxi
		EndIF
	EndIF

Return( Str(auxi,1,0) )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xCalMod11 NบAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Para calculo do nosso numero do banco do brasil            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

// Exemplo:    xCalMod11( '2292838' , 9 , 2 )   nBas1 = Base Maior    nBas2 = Base Menor

Static Function xCalMod11(cVariavel,nBas1,nBas2,cOrdem,nSeZer,nSeDez,nSeUm)

	Local	Auxi	:= 0
	Local	SumDig	:= 0
	Local	nbase  	:= Len(cVariavel)
	Local	iDig   	:= nBase
	Local	base   	:= 0
	Local	sumdig 	:= 0
	Local	Auxi   	:= 0
	Default nBas1  := 9
	Default nBas2  := 2
	Default nSeZer := 0
	Default nSeDez := 0
	Default nSeUm  := 1
	Default cOrdem := 'D'

	If Upper(cOrdem) == 'D'
		base := nBas1
		While	iDig >= 1
			If	( base == (nBas2-1) )
				base := nBas1
			EndIf

			auxi   := Val(SubStr(cVariavel, idig, 1)) * base
			sumdig += auxi
			base--
			iDig--
		EndDo
	Else
		base := nBas2
		While	iDig >= 1
			If	( base == (nBas1+1) )
				base := nBas2
			EndIf

			auxi   := Val(SubStr(cVariavel, idig, 1)) * base
			sumdig += auxi
			base++
			iDig--
		EndDo
	EndIF

	auxi := mod(Sumdig,11)

Return( Str(auxi,1,0) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ xBBCalcDigNบAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Para calculo do nosso numero do banco do brasil            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLETOS                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xBBCalcDigN(cVariavel)

	Local nCont	 := 0
	Local nCont1 := 0
	Local cCont2 := ""
	Local cResto := ""

	nCont	:= nCont+(Val(Subs(cVariavel,1,1))*7)
	nCont	:= nCont+(Val(Subs(cVariavel,2,1))*8)
	nCont	:= nCont+(Val(Subs(cVariavel,3,1))*9)
	nCont	:= nCont+(Val(Subs(cVariavel,4,1))*2)
	nCont	:= nCont+(Val(Subs(cVariavel,5,1))*3)
	nCont	:= nCont+(Val(Subs(cVariavel,6,1))*4)
	nCont	:= nCont+(Val(Subs(cVariavel,7,1))*5)
	nCont	:= nCont+(Val(Subs(cVariavel,8,1))*6)
	nCont	:= nCont+(Val(Subs(cVariavel,9,1))*7)
	nCont	:= nCont+(Val(Subs(cVariavel,10,1))*8)
	nCont	:= nCont+(Val(Subs(cVariavel,11,1))*9)

	nCont1  := Mod( nCont, 11 )
	Do Case
		Case nCont1 == 10
		cCont2 := "X"
		Case nCont1 < 10 .And. nCont1 > 0
		cCont2 := cValToChar( nCont1 )
		Case nCont1 == 0
		cCont2 := "0"
	EndCase
	cResto  := cCont2

Return(cResto)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณxBraCalcDigNบAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Para calculo do nosso numero do Bradesco....               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xBraCalcDigN(cVariavel)
	Local	Auxi	:= 0,;
	SumDig	:= 0

	cbase	:= cVariavel
	lbase  	:= Len(cBase)
	base   	:= 2
	sumdig 	:= 0
	Auxi   	:= 0
	iDig   	:= lBase

	//ConOut('Vou Calcular o Digito de..:' + cBase )

	While	iDig >= 1

		If	( base == 8 )
			base := 2
		EndIf

		auxi   := Val(SubStr(cBase, idig, 1)) * base
		sumdig += auxi
		base++
		iDig--
	EndDo

	//ConOut('Somado..:' + Str(sumdig) )

	auxi := 11 - mod(Sumdig,11)

	//ConOut('Digito inicial..:' + Str(auxi) )

	If	( auxi == 10 )
		auxi := 'P'
	ElseIf ( auxi == 11 )
		auxi := '0'
	Else
		auxi := str(auxi,1,0)
	EndIf

Return(auxi)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณ Funcao    ณ xSanCalcDigN()Autor ณ Flavio Novaes    ณ Data ณ 03/02/2005 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Descricao ณ Impressao de Boleto Bancario do Banco Santander com Codigo ณฑฑ
ฑฑณ           ณ de Barras, Linha Digitavel e Nosso Numero.                 ณฑฑ
ฑฑณ           ณ Baseado no Fonte TBOL001 de 01/08/2002 de Raimundo Pereira.ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso       ณ FINANCEIRO                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC FUNCTION xSanCalcDigN( cVariavel )

	Local nCont	 := 0
	Local nCont1 := 0
	Local nResto := 0

	nCont	:= nCont+(Val(Subs(cVariavel,12,1))*2)
	nCont	:= nCont+(Val(Subs(cVariavel,11,1))*3)
	nCont	:= nCont+(Val(Subs(cVariavel,10,1))*4)
	nCont	:= nCont+(Val(Subs(cVariavel,09,1))*5)
	nCont	:= nCont+(Val(Subs(cVariavel,08,1))*6)
	nCont	:= nCont+(Val(Subs(cVariavel,07,1))*7)
	nCont	:= nCont+(Val(Subs(cVariavel,06,1))*8)
	nCont	:= nCont+(Val(Subs(cVariavel,05,1))*9)
	nCont	:= nCont+(Val(Subs(cVariavel,04,1))*2)
	nCont	:= nCont+(Val(Subs(cVariavel,03,1))*3)
	nCont	:= nCont+(Val(Subs(cVariavel,02,1))*4)
	nCont	:= nCont+(Val(Subs(cVariavel,01,1))*5)


	nCont1  := int(nCont  / 11)

	nCont1  := abs((nCont1 *11) - nCont)

	Do Case
		Case nCont1 == 10
		nResto := 1
		Case nCont1 == 0 .Or. nCont1 == 1
		nResto := 0
		Otherwise
		nResto := Abs( 11 - nCont1 )
	EndCase

Return(Strzero(nResto,1))

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณ Funcao    ณ xSanCalcDigb()Autor ณ Flavio Novaes    ณ Data ณ 03/02/2005 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Descricao ณ Impressao de Boleto Bancario do Banco Santander com Codigo ณฑฑ
ฑฑณ           ณ de Barras, Linha Digitavel e Nosso Numero.                 ณฑฑ
ฑฑณ           ณ Baseado no Fonte TBOL001 de 01/08/2002 de Raimundo Pereira.ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso       ณ FINANCEIRO                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC FUNCTION xSanDigB( cVariavel )

	Local nCont	 := 0
	Local nCont1 := 0
	Local nResto := 0

	nCont	:= nCont+(Val(Subs(cVariavel,43,1))*2)
	nCont	:= nCont+(Val(Subs(cVariavel,42,1))*3)
	nCont	:= nCont+(Val(Subs(cVariavel,41,1))*4)
	nCont	:= nCont+(Val(Subs(cVariavel,40,1))*5)
	nCont	:= nCont+(Val(Subs(cVariavel,39,1))*6)
	nCont	:= nCont+(Val(Subs(cVariavel,38,1))*7)
	nCont	:= nCont+(Val(Subs(cVariavel,37,1))*8)
	nCont	:= nCont+(Val(Subs(cVariavel,36,1))*9)
	nCont	:= nCont+(Val(Subs(cVariavel,35,1))*2)
	nCont	:= nCont+(Val(Subs(cVariavel,34,1))*3)
	nCont	:= nCont+(Val(Subs(cVariavel,33,1))*4)
	nCont	:= nCont+(Val(Subs(cVariavel,32,1))*5)
	nCont	:= nCont+(Val(Subs(cVariavel,31,1))*6)
	nCont	:= nCont+(Val(Subs(cVariavel,30,1))*7)
	nCont	:= nCont+(Val(Subs(cVariavel,29,1))*8)
	nCont	:= nCont+(Val(Subs(cVariavel,28,1))*9)
	nCont	:= nCont+(Val(Subs(cVariavel,27,1))*2)
	nCont	:= nCont+(Val(Subs(cVariavel,26,1))*3)
	nCont	:= nCont+(Val(Subs(cVariavel,25,1))*4)
	nCont	:= nCont+(Val(Subs(cVariavel,24,1))*5)
	nCont	:= nCont+(Val(Subs(cVariavel,23,1))*6)
	nCont	:= nCont+(Val(Subs(cVariavel,22,1))*7)
	nCont	:= nCont+(Val(Subs(cVariavel,21,1))*8)
	nCont	:= nCont+(Val(Subs(cVariavel,20,1))*9)
	nCont	:= nCont+(Val(Subs(cVariavel,19,1))*2)
	nCont	:= nCont+(Val(Subs(cVariavel,18,1))*3)
	nCont	:= nCont+(Val(Subs(cVariavel,17,1))*4)
	nCont	:= nCont+(Val(Subs(cVariavel,16,1))*5)
	nCont	:= nCont+(Val(Subs(cVariavel,15,1))*6)
	nCont	:= nCont+(Val(Subs(cVariavel,14,1))*7)
	nCont	:= nCont+(Val(Subs(cVariavel,13,1))*8)
	nCont	:= nCont+(Val(Subs(cVariavel,12,1))*9)
	nCont	:= nCont+(Val(Subs(cVariavel,11,1))*2)
	nCont	:= nCont+(Val(Subs(cVariavel,10,1))*3)
	nCont	:= nCont+(Val(Subs(cVariavel,09,1))*4)
	nCont	:= nCont+(Val(Subs(cVariavel,08,1))*5)
	nCont	:= nCont+(Val(Subs(cVariavel,07,1))*6)
	nCont	:= nCont+(Val(Subs(cVariavel,06,1))*7)
	nCont	:= nCont+(Val(Subs(cVariavel,05,1))*8)
	nCont	:= nCont+(Val(Subs(cVariavel,04,1))*9)
	nCont	:= nCont+(Val(Subs(cVariavel,03,1))*2)
	nCont	:= nCont+(Val(Subs(cVariavel,02,1))*3)
	nCont	:= nCont+(Val(Subs(cVariavel,01,1))*4)

	nCont1  := (nCont  * 10)


	nCont1 := mod(nCont1,11)


	Do Case
		Case nCont1 == 10 .or. nCont1 == 0 .Or. nCont1 == 1
		nResto := 1
		Otherwise
		nResto := nCont1
	EndCase


Return(Strzero(nResto,1))

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณ Funcao    ณ MODULO10()  ณ Autor ณ Flavio Novaes    ณ Data ณ 03/02/2005 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Descricao ณ Impressao de Boleto Bancario do Banco Santander com Codigo ณฑฑ
ฑฑณ           ณ de Barras, Linha Digitavel e Nosso Numero.                 ณฑฑ
ฑฑณ           ณ Baseado no Fonte TBOL001 de 01/08/2002 de Raimundo Pereira.ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso       ณ FINANCEIRO                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC FUNCTION Modulo10(cData)
	LOCAL L,D,P := 0
	LOCAL B     := .F.
	L := Len(cData)
	B := .T.
	D := 0
	WHILE L > 0
		P := VAL(SUBSTR(cData, L, 1))
		IF (B)
			P := P * 2
			IF P > 9
				P := P - 9
			ENDIF
		ENDIF
		D := D + P
		L := L - 1
		B := !B
	ENDDO
	D := 10 - (Mod(D,10))
	IF D = 10
		D := 0
	ENDIF
RETURN(D)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณxAbcCalcDigNบAutorณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Para calculo do nosso numero do ABC Brasil....             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xAbcCalcDigN(cVariavel)
	Local	Auxi	:= 0,;
	SumDig	:= 0

	cbase	:= cVariavel
	lbase  	:= Len(cBase)
	base   	:= 2
	sumdig 	:= 0
	Auxi   	:= 0
	iDig   	:= lBase

	//ConOut('Vou Calcular o Digito de..:' + cBase )

	While	iDig >= 1

		If	( base == 8 )
			base := 2
		EndIf

		auxi   := Val(SubStr(cBase, idig, 1)) * base
		sumdig += auxi
		base++
		iDig--
	End

	//ConOut('Somado..:' + Str(sumdig) )

	_nResto := mod(Sumdig,11)

	If _nResto = 0
		auxi := '0'
	ElseIf _nResto = 1
		auxi := 'P'
	Else
		auxi := str( (11 - _nResto), 1, 0 )
	EndIf

Return(auxi)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ CALCpBr  บAutor  ณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo do digito do nosso numero do Bradesco              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CALC_5pBr(cVariavel)
	Local	Auxi	:= 0,;
	sumdig	:= 0

	cbase	:= cVariavel
	lbase	:= LEN(cBase)
	base 	:= 2
	sumdig	:= 0
	Auxi 	:= 0
	iDig  	:= lBase

	While	( iDig >= 1 )
		If	( base >= 10 )
			base := 2
		EndIf
		auxi   := Val(SubStr(cBase, idig, 1)) * base
		sumdig := SumDig+auxi
		base++
		iDig--
	EndDo

	auxi := mod(sumdig,11)

	If	( auxi == 0 ) .or. ( auxi == 1 ) .or. ( auxi > 9 )
		auxi := 1
	Else
		auxi := 11 - auxi
	EndIf

Return(Str(auxi,1,0))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ DIGIT001 บAutor  ณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Para calculo usando modulo 10                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DIGIT001(cVariavel)
	Local	Auxi 	:= 0,;
	sumdig 	:= 0

	cbase  := cVariavel
	lbase  := LEN(cBase)
	umdois := 2
	sumdig := 0
	Auxi   := 0
	iDig   := lBase

	While	 ( iDig >= 1 )

		auxi   := Val(SubStr(cBase, idig, 1)) * umdois
		sumdig := SumDig + If (auxi < 10, auxi, (auxi-9))
		umdois := 3 - umdois
		iDig := iDig-1

	End

	cValor	:= AllTrim(padl(Alltrim(str(sumdig)),12,'0'))
	nDezena	:= Val(AllTrim(Str(Val(SubStr(cvalor,11,1))+1))+'0')
	auxi 	:= nDezena - sumdig

	If	( auxi >= 10 )
		auxi := 0
	EndIf

Return(str(auxi,1,0))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ DIGRURAL บAutor  ณEdinilson Bonato Pereira   ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Para calculo usando modulo 10                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DIGRURAL()

	Local cNN := SUBS(SE1->E1_NUMBCO,5,7)
	Local cDig :=""
	Local nTotal := 114
	Local Soma := 0
	Local auxi := 0
	Local nDigi := 1
	Local i    := 0

	For i:= 1 to Len(cNN)+1

		auxi:=val(Substr(cNN,i,1))

		Soma += auxi *  (10 - nDigi)

		DO CASE
			CASE nDigi = 1
			nDigi := 3
			CASE nDigi = 3
			nDigi := 7
			CASE nDigi = 7
			nDigi := 9
			CASE nDigi = 9
			nDigi := 1
		ENDCASE

	Next i


	nTotal += Soma

	auxi := 10 - mod(nTotal,10)

	If	( auxi = 10 )
		auxi := 0
	EndIf

Return(str(auxi,1,0))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ CALC_5pItบ Autor ณMicrosiga           บ Data ณ  02/13/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo do digito do nosso numero do Itau                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CALC_5pIt(cVariavel)
	Local	Auxi	:= 0,;
	sumdig	:= 0

	cbase	:= cVariavel
	lbase	:= LEN(cBase)
	base 	:= 2
	sumdig	:= 0
	Auxi 	:= 0
	iDig  	:= lBase

	While	( iDig >= 1 )
		If	( base >= 10 )
			base := 2
		EndIf
		auxi   := Val(SubStr(cBase, idig, 1)) * base
		sumdig := SumDig+auxi
		base++
		iDig--
	End

	auxi := mod(sumdig,11)

	If	( auxi == 0 ) .or. ( auxi == 1 ) .or. ( auxi > 9 )
		auxi := 1
	Else
		auxi := 11 - auxi
	EndIf

Return(Str(auxi,1,0))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxVerFaturaบAutor ณ Julio Storino       บ Data ณ  15/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica os titulos integrantes das faturas. !!!           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xVerFatura(cNumFat,cPrefixo)
	Local	cQuery	:= '',;
	cAnoFut	:= AllTrim(Str(Year(dDataBase)+10))+'1231',;
	aReturn	:= {}

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica, os Titulos Originais, da FATURA Impressa Acima...ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( cPrefixo == "FAT" )
		cQuery	:= "SELECT SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, SE5.E5_VALOR, "
		cQuery	+= "SE5.E5_VLDESCO, SE5.E5_VLJUROS, SE5.E5_VLMULTA "
		cQuery	+= "FROM " + RetSqlName('SE5') + ' SE5 '
		cQuery	+= "WHERE SE5.E5_FILIAL = '" + xFilial('SE5') + "' "
		cQuery	+= "AND SE5.E5_TIPODOC = 'BA' "
		cQuery	+= "AND SE5.E5_DATA >= '19950101' "
		cQuery	+= "AND SE5.E5_DATA <= '" + cAnoFut + "' "
		cQuery	+= "AND SE5.E5_RECPAG = 'R' "
		cQuery	+= "AND SE5.E5_SITUACA <> 'C' "
		cQuery	+= "AND SE5.E5_MOTBX = 'FAT' "
		cQuery	+= "AND SE5.E5_HISTOR LIKE '%" + cNumFat + "%' "
		cQuery	+= "AND SE5.D_E_L_E_T_ <> '*' "
		cQuery	+= " ORDER BY SE5.E5_FILIAL, SE5.E5_DATA, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA "
	Else
		cQuery	+= "SELECT SD2.D2_PEDIDO NUMERO "
		cQuery	+= "FROM " + RetSqlName("SD2") + " AS SD2 "
		cQuery	+= "WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
		cQuery	+= "AND SD2.D2_DOC = '" + cNumFat + "' "
		cQuery	+= "AND SD2.D2_SERIE = '" + cPrefixo + "' "
		cQuery	+= "AND SD2.D_E_L_E_T_ = '' "
		cQuery	+= "GROUP BY SD2.D2_PEDIDO "
	EndIf
	cQuery	:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TR5',.F.,.T.)

	DbSelectArea('TR5')
	TR5->(DbGoTop())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณElementos da Arrayณ
	//ณ1o - Emissao      ณ
	//ณ2o - Prefixo      ณ
	//ณ3o - Numero       ณ
	//ณ4o - Parcela      ณ
	//ณ5o - Valor        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While	TR5->( ! Eof() )
		If	( cPrefixo == "FAT"	)
			aAdd(aReturn,{'',TR5->E5_PREFIXO,TR5->E5_NUMERO,TR5->E5_PARCELA,TR5->E5_VALOR+TR5->E5_VLDESCO-(TR5->E5_VLJUROS+TR5->E5_VLMULTA)})
		Else
			aAdd(aReturn,{	'','',TR5->NUMERO,'',0})
		EndIf
		TR5->(DbSkip())
	EndDo

	TR5->(DbCloseArea())

Return aReturn




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFuncao para validar os dados digitados na tela de sele็ใo com rela็ใoณ
//ณao banco e agencia de transferencia e ao tipo de cobran็a.           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
STATIC FUNCTION TudoOk(oDlg)

	Local _lRet   := .T.
	Local _Msg    := ''

	lPortador := .f.
	lSituacao := .f.

	TRA->(DbGoTop())

	//Define se vai precisar da obrigatoriedade de banco e Tipo de Cobran็a
	While TRA->(!EOF())
		IF TRA->(Marked('E1_OK')) .and. Empty(TRA->E1_PORTADO)
			lPortador := .t.
		EndIf
		If TRA->(Marked('E1_OK')) .and. !TRA->E1_SITUAC2 $ '1/4'
			lSituacao := .t.
		EndIf
		if lPortador .and. lSituacao
			Exit
		EndIf

		TRA->(DbSkip())
	EndDo

	If  lPortador .and. Empty(cBcoOrig)
		_lRet := .F.
		_Msg := 'Obrigat๓rio informar o banco de transfer๊ncia !'
	EndIf

	If lSituacao .and. Empty(cSituaca)
		_lRet := .F.
		_Msg  += _Quebra + 'Obrigat๓rio informar a situa็ใo de Transfer๊ncia !'
	EndIf

	If lSituacao .and. !Empty(cSituaca) .and. !Substr(cSituaca,1,1)$'1/4'
		_lRet := .F.
		_Msg  += _Quebra + 'Somente situa็๕es 1 ou 4 sใo permitidas !'
	EndIf

	If !Empty(cBcoOrig) .and. !Substr(cSituaca,1,1)$'1/4'
		_lRet := .F.
		_Msg  += _Quebra + 'Somente situa็๕es 1 ou 4 sใo permitidas !'
	EndIf

	If !Empty(_Msg)
		IW_MSGBOX(_Msg, 'Aten็ใo', "STOP")
	EndIf

Return _lRet



Static Function xJuliano(dData)

	Local cRet    := ''
	Local dDtIni  := SToD( StrZero(Year(dData),4) + '0101' )
	Local nDias   := (dData - dDtIni) + 1

	cRet := StrZero(nDias,3) + Right( Str(Year(dData)),1)

Return cRet




Static Function StrImp(cBco,cTipo)

	Local Ret

	Do Case
		Case Upper(cTipo) == 'DIGBCO'
		Do Case
			Case cBco = '001'
			Ret := '-9'
			case cBco = '033'
			Ret := '-7'
			Case cBco = '237'
			Ret := '-2'
			Case cBco = '341'
			Ret := '-7'
			Case cBco = '356'
			Ret := '-5'
			Case cBco = '399'
			Ret := '-9'
			Case cBco = '748'
			Ret := '-X'
			case cBco = '104'
			Ret := '-0'
			case cBco = '756'
			Ret := '-0'
		EndCase


		Case Upper(cTipo) == 'NOSSONUMERO'
		Do Case
			Case cBco == '001'
			// 	Ret := AllTrim(SubStr(aDadosTit[6],1,6)+' '+SubStr(aDadosTit[6],7,5)+' - '+SubStr(aDadosTit[6],12,1))
			Ret := AllTrim(SubStr(aDadosTit[6],1,7) + SubStr(aDadosTit[6],8,10))
			//	Do Case
			//		Case Len(aDadosTit[6]) = 12
			//		Ret := AllTrim(SubStr(aDadosTit[6],1,6)+' '+SubStr(aDadosTit[6],7,5)+' - '+SubStr(aDadosTit[6],12,1))
			//		Case Len(aDadosTit[6]) = 17
			//	Ret := AllTrim(SubStr(aDadosTit[6],1,7)+' '+SubStr(aDadosTit[6],8,10))
			//	EndCase
			Case cBco == '033'
			Ret := AllTrim(SubStr(aDadosTit[6],1,12)) + '-' + SubStr(aDadosTit[6],13,1)
			Case cBco == '237'
			Ret := AllTrim(StrZero(Val(aDadosBanco[6]),2)) + '/' + AllTrim(SubStr(aDadosTit[6],1,11)) + '-' + SubStr(aDadosTit[6],12,1)
			Case cBco == '341'
			Ret := AllTrim(SubStr(aDadosTit[6],1,3)) + '/' + AllTrim(SubStr(aDadosTit[6],4,8)) + '-' + AllTrim(SubStr(aDadosTit[6],12,1))
			// 109 + 00180046  10900180046  - 109+00180046+DV 
			Case cBco == '356'
			Ret := AllTrim(aDadosTit[6])
			Case cBco == '399'
			Ret :=  AllTrim(SubStr(aDadosTit[6],1,2)) + '.' + SubStr(aDadosTit[6],3,3)+ '.' + SubStr(aDadosTit[6],6,3)+ '.' + SubStr(aDadosTit[6],9,2)+ '.' + SubStr(aDadosTit[6],11,1)
			Case cBco == '748'
			Ret := Left(AllTrim(aDadosTit[6]),2) + '/' + Substr(AllTrim(aDadosTit[6]),3,6) + '-' + Right(AllTrim(aDadosTit[6]),1)
			Case cBco == '104'
			Ret := AllTrim(SubStr(aDadosTit[6],1,10)) + '-' +AllTrim(SubStr(aDadosTit[6],11))
			Case cBco == '756'
			Ret := AllTrim(aDadosTit[6])
		EndCase

		Case Upper(cTipo) == 'LOCALPAGTO'
		Do Case
			// Case cBco == '399'
			Case cBco $ '399/341'  // acrescent. 341 = Itau 
			Ret := {}
			aAdd( Ret, 'At้ o vencimento,preferencialmente no Ita๚')
			aAdd( Ret, 'Ap๓s o Vencimento, somente no '+aDadosBanco[2] ) 
			Case cBco == '237'
			Ret := {}
			aAdd( Ret, 'Pagแvel preferencialmente na Rede Bradesco ou Bradesco Expresso' )
			aAdd( Ret, ' ' )
			Case cBco == '104'
			Ret := {}
			aAdd( Ret, 'QUALQUER BANCO ATE O VENCIMENTO')
			aAdd( Ret, 'APOS O VENCIMENTO, SOMENTE NAS CASAS LOTERICAS E AGENCIAS '+aDadosBanco[2] )
			Case cBco == '756'
			Ret := {}
			aAdd( Ret, 'PAGAVEL EM QUALQUER BANCO ATษ O VENCIMENTO')
			aAdd( Ret, 'APOS O VENCIMENTO SOMENTE NAS AGENCIAS DO SICOOB' )
			Case cBco == '748'
			Ret := {}
			aAdd( Ret, 'PAGAVEL PREFERENCIALMENTE NAS COOP. DE CREDITO DO SICREDI')
			aAdd( Ret, '' )
			Case cBco == '033'
			Ret := {}
			aAdd( Ret, 'Pagavel Preferencialmente no Grupo Santander' )
			aAdd( Ret, '' )

			OtherWise
			Ret := {}
			aAdd( Ret, 'Pagแvel em qualquer banco.' )  // xavier 08/07/19
			//aAdd( Ret, 'Qualquer Banco Ate o Vencimento' )
			//aAdd( Ret, 'Ap๓s o Vencimento, somente no '+aDadosBanco[2] )
		EndCase

		Case Upper(cTipo) == 'NRODOC'
		Do Case
			Case cBco == '033'
			Ret := AllTrim(SubStr(aDadosTit[7],1,3)+' - '+ SubStr(aDadosTit[1],1,9) +' / '+ SubStr(aDadosTit[1],10,2))
			Case cBco == '399'
			Ret := AllTrim(SubStr(aDadosTit[7],1,3)+' - '+ SubStr(aDadosTit[1],1,9) +' / '+ SubStr(aDadosTit[1],10,2))
			Case cBco == '104'
			Ret := AllTrim(SubStr(aDadosTit[7],1,3)+' - '+SubStr(aDadosTit[1],1,9)+' / '+SubStr(aDadosTit[1],10,2))
			Case cBco == '756'
			Ret := AllTrim(SubStr(aDadosTit[7],1,3)+' - '+SubStr(aDadosTit[1],1,9)+' / '+SubStr(aDadosTit[1],10,2))
			Case cBco == '341'
			Ret := AllTrim(SubStr(aDadosTit[7],1,3)+' - '+ SubStr(aDadosTit[1],1,9) +' / '+ SubStr(aDadosTit[1],10,2))
			Case cBco == '237'
			Ret := AllTrim(SubStr(aDadosTit[7],1,3)+' - '+ SubStr(aDadosTit[1],1,6) +' / '+ SubStr(aDadosTit[1],7,2))
			OtherWise
			Ret := aDadosTit[7]+aDadosTit[1]
		EndCase

		Case Upper(cTipo) == 'ESPECIE'
		Do Case
			Case cBco=='COB'
			Ret := 'DM'
			Case cBco $ '001/033/224/246/453/104/237/756/341/748'
			Ret := 'R$'
			Case cBco == '399'
			Ret := 'R$'
			OtherWise
			Ret := aDadosTit[8]
		EndCase

		Case Upper(cTipo) == 'ESPECIE DOC'
		Do Case
			Case cBco $ '001/033/224/246/237/320/453/104/RED/756/341/748'
			Ret := 'DM'
			Case cBco == '399'
			Ret := 'DM'
			OtherWise
			Ret := aDadosTit[8]
		EndCase

		Case Upper(cTipo) == 'ACEITE'
		Do Case
			Case cBco == '399'
			Ret := 'N'
			OtherWise
			Ret := 'N'
		EndCase

		Case Upper(cTipo) == 'DTPROC'
		Do Case
			Case cBco == '399'
			Ret := StrZero(Day(aDadosTit[3]),2) +'/'+ StrZero(Month(aDadosTit[3]),2) +'/'+ Right(Str(Year(aDadosTit[3])),4)
			OtherWise
			Ret := StrZero(Day(aDadosTit[3]),2) +'/'+ StrZero(Month(aDadosTit[3]),2) +'/'+ Right(Str(Year(aDadosTit[3])),4)
		EndCase

		Case Upper(cTipo) == 'POSLOGO'
		Do Case
			//Case cBco == '399'
			//	Ret := {}
			//	aAdd( Ret, 110 )
			//	aAdd( Ret, 60 )
			//	aAdd( Ret, 220 )

			Case cBco $ '104/237/756/341/001/748/399/033'
			Ret := {}
			aAdd( Ret, 360 )
			aAdd( Ret, 85 )
			aAdd( Ret, 320 )

			OtherWise
			Ret := {}
			aAdd( Ret, 60 )
			aAdd( Ret, 60 )
			aAdd( Ret, 165 )
		EndCase

		Case Upper(cTipo) == 'AGCEDENTE'
		Do Case
			Case cBco == '033'
			Ret := {}
			aAdd( Ret, aDadosBanco[3]+'/'+aDadosBanco[8] )
			aAdd( Ret, 1810+(374-(len(Ret[1])*22)) )

			Case cBco == '748'
			Ret := {}
			aAdd( Ret, aDadosBanco[3]+'.'+aDadosBanco[9]+'.'+Alltrim(aDadosBanco[8]) )
			aAdd( Ret, 1810+(374-(len(Ret[1])*22)) )

			Case cBco == '104'
			Ret := {}
			aAdd( Ret, 	AllTrim(SubStr(aDadosBanco[9],1,4)) + '.' + AllTrim(SubStr(aDadosBanco[9],5,3)) + '.' + AllTrim(SubStr(aDadosBanco[9],8,8)) + '-' + AllTrim(SubStr(aDadosBanco[9],16,1)) )
			aAdd( Ret, 1810+(374-(len(Ret[1])*22)) )

			Case cBco == '237'
			Ret := {}
			aAdd( Ret, aDadosBanco[3]+'/'+aDadosBanco[4]+'-'+aDadosBanco[5] )
			aAdd( Ret, 1810+(374-(len(Ret[1])*22)) )

			Case cBco == '341' // xavier 23/07 tratar AAAA/CCCCC-D, onde AAAA = Nr. agencia,  CCCCC = Nr. conta e  D=Dac da ag๊ncia/conta
			Ret := {}
			aAdd( Ret, aDadosBanco[3]+'/'+aDadosBanco[4]+'-'+aDadosBanco[9] ) 
			aAdd( Ret, 1810+(374-(len(Ret[1])*22)) )
			//  aAdd( Ret, aDadosBanco[3]+'/'+aDadosBanco[4] ) //  Agencia / Conta corrente
			//  aAdd( Ret, aDadosBanco[3]+'/'+aDadosBanco[4]+'-'+aDadosBanco[9] )  = Agencia/conta-digito 

			Case cBco == '756'
			Ret := {}
			aAdd( Ret, 	AllTrim(SubStr(aDadosBanco[8],1,4)) + '/' + AllTrim(SubStr(aDadosBanco[8],12,3)))
			aAdd( Ret, 1810+(374-(len(Ret[1])*22)) )
			Case cBco == '399'
			Ret := {}
			aAdd( Ret, aDadosBanco[3] +'-'+ aDadosBanco[3] + StrZero(Val(aDadosBanco[4] + aDadosBanco[5] ),7))
			aAdd( Ret, 1810+(374-(len(Ret[1])*22)) )
			Case cBco == '001'	
			Ret := {}
			aAdd( Ret, AllTrim(SubStr(aDadosBanco[3],1,4))+'-'+AllTrim(SubStr(aDadosBanco[3],5,1))+'/'+AllTrim(SubStr(aDadosBanco[4],1,4))+'-'+aDadosBanco[9]) // xavier 27/08/19 
			// aAdd( Ret, aDadosBanco[3]+'-'+aDadosBanco[9]+'/'+aDadosBanco[4]+'-'+aDadosBanco[5]) // xavier 27/08/19 
			aAdd( Ret, 1810+(374-(len(Ret[1])*22)) )
			OtherWise
			Ret := {}
			aAdd( Ret, aDadosBanco[3]+'-'+aDadosBanco[9]+'/'+aDadosBanco[4]+IIf( .Not. Empty( aDadosBanco[5] ) , "-" + aDadosBanco[5] , "" ) ) // xavier 10/07/19 
			// aAdd( Ret, aDadosBanco[3]+'/'+aDadosBanco[4]+IIf( .Not. Empty( aDadosBanco[5] ) , "-" + aDadosBanco[5] , "" ) )
			// agencia + dv / conta + dv  -- AAAA-Z / CCCCC-Z, ou seja: 1856-2 / 3042-2  aDadosBanco[9] -> SEE->EE_CODCOBE ?
			aAdd( Ret, 1810+(374-(len(Ret[1])*22)) )
		EndCase
		Case Upper(cTipo) == 'CIP'
		Do Case
			Case cBco == "453"
			Ret := '775'
			Case cBco == "237"
			Ret := '000'
			OtherWise
			Ret :=''
		EndCase

		OtherWise
		Ret := '?'
	EndCase

Return( Ret )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaSX1บAutor ณ Julio Storino       บ Data ณ  15/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta o SX1 - Arquivo de Perguntas..                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX1(cPerg)
	Local   nX      := 0
	Local	aRegs   := {}
	_sAlias := Alias()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampos a serem grav. no SX1ณ
	//ณaRegs[nx][01] - X1_GRUPO   ณ
	//ณaRegs[nx][02] - X1_ORDEM   ณ
	//ณaRegs[nx][03] - X1_PERGUNTEณ
	//ณaRegs[nx][04] - X1_PERSPA  ณ
	//ณaRegs[nx][05] - X1_PERENG  ณ
	//ณaRegs[nx][06] - X1_VARIAVL ณ
	//ณaRegs[nx][07] - X1_TIPO    ณ
	//ณaRegs[nx][08] - X1_TAMANHO ณ
	//ณaRegs[nx][09] - X1_DECIMAL ณ
	//ณaRegs[nx][10] - X1_PRESEL  ณ
	//ณaRegs[nx][11] - X1_GSC     ณ
	//ณaRegs[nx][12] - X1_VALID   ณ
	//ณaRegs[nx][13] - X1_VAR01   ณ
	//ณaRegs[nx][14] - X1_DEF01   ณ
	//ณaRegs[nx][15] - X1_DEF02   ณ
	//ณaRegs[nx][16] - X1_DEF03   ณ
	//ณaRegs[nx][17] - X1_F3      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria uma array, contendo todos os valores...ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aRegs,{cPerg,'01','Do Prefixo         ?','Do Prefixo         ?','Do Prefixo         ?','mv_ch1','C', 3,0,0,'G','','mv_par01','','','','',''})
	aAdd(aRegs,{cPerg,'02','At o Prefixo      ?','At o Prefixo      ?','At o Prefixo      ?','mv_ch2','C', 3,0,0,'G','','mv_par02','','','','',''})
	aAdd(aRegs,{cPerg,'03','Do Tกtulo          ?','Do Tกtulo          ?','Do Tกtulo          ?','mv_ch3','C', 9,0,0,'G','','mv_par03','','','','',''})
	aAdd(aRegs,{cPerg,'04','At o Tกtulo       ?','At o Tกtulo       ?','At o Tกtulo       ?','mv_ch4','C', 9,0,0,'G','','mv_par04','','','','',''})
	aAdd(aRegs,{cPerg,'05','Do Banco           ?','Do Banco           ?','Do Banco           ?','mv_ch5','C', 3,0,0,'G','','mv_par05','','','','BC8',''})
	aAdd(aRegs,{cPerg,'06','At o Banco        ?','At o Banco        ?','At o Banco        ?','mv_ch6','C', 3,0,0,'G','','mv_par06','','','','BC8',''})
	aAdd(aRegs,{cPerg,'07','Do Cliente         ?','Do Cliente         ?','Do Cliente         ?','mv_ch7','C', 6,0,0,'G','','mv_par07','','','','CLI',''})
	aAdd(aRegs,{cPerg,'08','At o Cliente      ?','At o Cliente      ?','At o Cliente      ?','mv_ch8','C', 6,0,0,'G','','mv_par08','','','','CLI',''})
	aAdd(aRegs,{cPerg,'09','Da Loja            ?','Da Loja            ?','Da Loja            ?','mv_ch9','C', 2,0,0,'G','','mv_par09','','','','',''})
	aAdd(aRegs,{cPerg,'10','At a Loja         ?','At a Loja         ?','At a Loja         ?','mv_cha','C', 2,0,0,'G','','mv_par10','','','','',''})
	aAdd(aRegs,{cPerg,'11','Do Vencimento      ?','Do Vencimento      ?','Do Vencimento      ?','mv_chb','D', 8,0,0,'G','','mv_par11','','','','',''})
	aAdd(aRegs,{cPerg,'12','At o Vencimento   ?','At o Vencimento   ?','At o Vencimento   ?','mv_chc','D', 8,0,0,'G','','mv_par12','','','','',''})
	if cModulo = 'FAT'
		aAdd(aRegs,{cPerg,'13','Da Emisso         ?','Da Emisso         ?','Da Emisso         ?','mv_chd','D', 8,0,0,'G','','mv_par13','','','','',DTOS(dDataBase)})
		aAdd(aRegs,{cPerg,'14','At a Emisso      ?','At a Emisso      ?','At a Emisso      ?','mv_che','D', 8,0,0,'G','','mv_par14','','','','',DTOS(dDataBase)})
		aAdd(aRegs,{cPerg,'19','Do Tipo de Tํtulo  ?','Do Tipo de Tํtulo  ?','Do Tipo de Tํtulo  ?','mv_chj','C', 3,0,0,'G','','mv_par19','','','','05','NF'})
		aAdd(aRegs,{cPerg,'20','At้ Tipo de Tํtulo ?','At้ Tipo de Tํtulo ?','At้ Tipo de Tํtulo ?','mv_chk','C', 3,0,0,'G','','mv_par20','','','','05','NF'})
	Else
		aAdd(aRegs,{cPerg,'13','Da Emisso         ?','Da Emisso         ?','Da Emisso         ?','mv_chd','D', 8,0,0,'G','','mv_par13','','','','',''})
		aAdd(aRegs,{cPerg,'14','At a Emisso      ?','At a Emisso      ?','At a Emisso      ?','mv_che','D', 8,0,0,'G','','mv_par14','','','','',''})
		aAdd(aRegs,{cPerg,'19','Do Tipo de Tํtulo  ?','Do Tipo de Tํtulo  ?','Do Tipo de Tํtulo  ?','mv_chj','C', 3,0,0,'G','','mv_par19','','','','05',''})
		aAdd(aRegs,{cPerg,'20','At้ Tipo de Tํtulo ?','At้ Tipo de Tํtulo ?','At้ Tipo de Tํtulo ?','mv_chk','C', 3,0,0,'G','','mv_par20','','','','05',''})
	EndIf
	aAdd(aRegs,{cPerg,'15','Selecionar Tกtulos ?','Selecionar Tกtulos ?','Selecionar Tกtulos ?','mv_chf','N', 1,0,1,'C','','mv_par15','Sim','No','','',''})
	aAdd(aRegs,{cPerg,'16','Do Bordero         ?','Do Bordero         ?','Do Bordero         ?','mv_chg','C', 6,0,0,'G','','mv_par16','','','','',''})
	aAdd(aRegs,{cPerg,'17','At o Bordero      ?','At o Bordero      ?','At o Bordero      ?','mv_chh','C', 6,0,0,'G','','mv_par17','','','','',''})
	aAdd(aRegs,{cPerg,'18','Tipo de Impressใo  ?','Tipo de Impressใo  ?','Tipo de Impressใo  ?','mv_chi','N', 1,0,1,'C','','mv_par18','Laser','DeskJet','','',''})
	aAdd(aRegs,{cPerg,'21','Atualiza Vencto    ?','Atualiza Vencto    ?','Atualiza Vencto    ?','mv_chl','N', 1,0,1,'C','','mv_par21','Sim','No','','',''})
	// 		aAdd(aRegs,{cPerg,'21','Tipo de Cobran็a   ?','Tipo de Cobran็a   ?','Tipo de Cobran็a   ?','mv_chl','C', 1,0,0,'C','','mv_par21','1=Simples','4=Vinculada/Registrada','','',''})
	//		aAdd(aRegs,{cPerg,'22','Enviar por E-mail  ?','Enviar por E-mail ?','Enviar por E-mail   ?','mv_chf','N', 1,0,1,'C','','mv_par22','No','Sim','','',''})


	DbSelectArea('SX1')
	SX1->(DbSetOrder(1))

	For nX:=1 to Len(aRegs)
		If	( !SX1->(DbSeek(aRegs[nx][01]+aRegs[nx][02])) )
			If	RecLock('SX1',.T.)
				Replace X1_GRUPO	With aRegs[nx][01]
				Replace X1_ORDEM   	With aRegs[nx][02]
				Replace X1_PERGUNTE	With aRegs[nx][03]
				Replace X1_PERSPA	With aRegs[nx][04]
				Replace X1_PERENG	With aRegs[nx][05]
				Replace X1_VARIAVL	With aRegs[nx][06]
				Replace X1_TIPO		With aRegs[nx][07]
				Replace X1_TAMANHO	With aRegs[nx][08]
				Replace X1_DECIMAL	With aRegs[nx][09]
				Replace X1_PRESEL	With aRegs[nx][10]
				Replace X1_GSC		With aRegs[nx][11]
				Replace X1_VALID	With aRegs[nx][12]
				Replace X1_VAR01	With aRegs[nx][13]
				Replace X1_DEF01	With aRegs[nx][14]
				Replace X1_DEF02	With aRegs[nx][15]
				Replace X1_DEF03	With aRegs[nx][16]
				Replace X1_F3   	With aRegs[nx][17]
				Replace X1_CNT01    With aRegs[nx][18]
				MsUnlock('SX1')
			Else
				Help('',1,'')
			EndIf
			/*	Else
			If	RecLock('SX1',.F.)
			Replace X1_GRUPO	With aRegs[nx][01]
			Replace X1_ORDEM   	With aRegs[nx][02]
			Replace X1_PERGUNTE	With aRegs[nx][03]
			Replace X1_PERSPA	With aRegs[nx][04]
			Replace X1_PERENG	With aRegs[nx][05]
			Replace X1_VARIAVL	With aRegs[nx][06]
			Replace X1_TIPO		With aRegs[nx][07]
			Replace X1_TAMANHO	With aRegs[nx][08]
			Replace X1_DECIMAL	With aRegs[nx][09]
			Replace X1_PRESEL	With aRegs[nx][10]
			Replace X1_GSC		With aRegs[nx][11]
			Replace X1_VALID	With aRegs[nx][12]
			Replace X1_VAR01	With aRegs[nx][13]
			Replace X1_DEF01	With aRegs[nx][14]
			Replace X1_DEF02	With aRegs[nx][15]
			Replace X1_DEF03	With aRegs[nx][16]
			Replace X1_F3   	With aRegs[nx][17]
			Replace X1_CNT01    With aRegs[nx][18]
			MsUnlock('SX1')
			Else
			Help('',1,'')
			EndIf*/
		Endif
	Next nX

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SFNewDateบAutor ณ Otaviano Mattos     บ Data ณ  17/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de intera็ใo para o vencimento e juros                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SFNewDate( dDate , nNewJuros )

	Local   lRetorno   := .F.
	Private oMainWnd   := Nil
	Private oDlgMain   := Nil
	Private oDataVenc  := Nil
	Private oBtnOk     := Nil
	Private oBtnCancel := Nil

	//Mensagem de informa็ใo
	MsgInfo("Informe a nova data de vencimento. Lembrando que ela deve ser maior do que "+DtoC( SE1->E1_VENCREA ) , "Data de Vencimento" )

	//Box Principal
	oDlgMain 	:= TDialog():New( 010 , 030 , 80 , 240 , OemToAnsi( "Data de Vencimento" ) , , , , , , , , oMainWnd , .T. )
	//Get da informa็ใo
	oDataVenc	:= TGet():New( 005 , 035 , { |u| If(PCount()>0,dDate:=u,dDate)},oDlgMain,040,008,"",{ || IIf( dDate <= SE1->E1_VENCREA , ( MsgStop("A data de vencimento ้ informada deve ser maior do que a antiga") , ( lRetorno := .F. ) ) , .T. ) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDate",,)
	//Bot๕es
	oBtnOk     := TButton():New( 020, 035, "Processa" , oDlgMain , {|| Processa( { || SFCalcJur( @nNewJuros ) } , "Recalculo de Juros", "Processando...") , ( lRetorno := .T. ) , oDlgMain:End() }, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

	oDlgMain:Activate( , , , .T.)

Return ( lRetorno )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SFCalcJurบAutor ณ Otaviano Mattos     บ Data ณ  20/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza a nova data de vencimento e o Juros               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SFCalcJur()

	Local   nTxJuros   := GetNewPar( 'MV_TXPER' , 0.13 )
	Local   nDifDias   := ( dDate - SE1->E1_VENCREA )

	//Caso a data informada no parโmetro seja maior, realizo a grava็ใo da nova data
	If Reclock( "SE1" , .F. )
		SE1->E1_XVATUAL := dDate
		SE1->( MsUnlock() )
	EndIf

	//Novo valor de juros
	nNewJuros :=  ( SE1->E1_VALOR * nDifDias * ( nTxJuros / 100 ) )

	//Informo o valor do juros
	If !MsgYesNo("O valor do juros ้ de : R$"+AllTrim( Str( nNewJuros ) )+" . Deseja inserir o valor no boleto?","Juros")
		//zero o valor do juros
		nNewJuros := 0
	EndIf

Return ( .T. )
