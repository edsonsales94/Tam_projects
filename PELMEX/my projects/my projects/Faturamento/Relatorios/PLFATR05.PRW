#include "rwmake.ch"  
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"   // incluido pelo assistente de conversao do AP5 IDE em 09/08/00

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PLFATR05  ºAutor  ³Microsiga           º Data ³  12/20/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime o Romaneio                                         º±±
±±º          ³ Antigo programa ROMANE                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PLFATR05()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
	SetPrvt("NLASTKEY,CPERG,WNREL,LI,M_PAG,I")
	SetPrvt("LA,")

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ ROMANE   ³ Autor ³ Ronilton O. Barros    ³ Data ³          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Romaneio                                                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Gen‚rico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	titulo    := "ROMANEIO"
	cDesc1    := OemToAnsi("Este programa ir  emitir o Romaneio,")
	cDesc2    := OemToAnsi("utilizando recursos do SIGA Advanced.")
	cDesc3    := OemToAnsi("")
	cString   := "SF2"
	aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
	nLastKey  := 0
	cPerg     := Padr("FATR05",Len(SX1->X1_GRUPO))
	wnrel     := "PLFATR05"
	li       := -66
	m_pag    := 1                                             





	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas, busca o padrao da NFPARV ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte(cPerg,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // De Nota                              ³
	//³ mv_par02             // At‚ a Nota                           ³ 
	//³ mv_par03             // Serie                                ³ 
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,'P') //CONFIGURAÇÃO DA IMPRESSORA (TAMANHO 'P' RETRATO 'M' OU 'G' PAISAGEM)

	if nLastKey == 27
		Set Filter To
		Return
	endif
	SetDefault(aReturn,cString,)
	if nLastKey == 27
		Set Filter To
		Return
	endif

	RptStatus({|| Corpo1() })
Return

Static Function Corpo1()
	Local i
	Local _Documento := ""
	Local _Serie := ""
	Local cQuery    := ""
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o SF2 para buscar os dados no Cabecalho da NF       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 00,00 PSAY chr(18)
	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek(XFILIAL("SF2")+mv_par01+mv_par03,.T.)
	SetRegua(RecCount())
	While ! Eof() .And. F2_DOC <= mv_par02 .And. XFILIAL("SF2") == F2_FILIAL

		IncRegua()
		_Documento := mv_par01
		_Serie     := mv_par03 
		If F2_SERIE <> mv_par03
			dbSkip()
			Loop
		Endif

		for i:=1 to 1 //Modificado o loop de 2 para 1 Stan Lee 28/11/2018 (cópia impressa) 
			li:=1
			@ li,000 PSAY chr(15)
			@ li,001 PSAY SM0->M0_NOMECOM
			@ li,025 PSAY chr(18) 
			@ li,028 PSAY "CONTROLE DE ENTREGA NO CLIENTE" 
			@ li,063 PSAY "Emissao: "+dtoc(ddatabase)
			li:=li+1
			@ li,001 PSAY "HORA.: "+time()
			@ li,063 PSAY "Pagina.: "+strzero(m_pag,2)
			li:=li+1
			@ li,001 PSAY repli("-",80)
			li:=li+1
			dbSelectArea("SD2")
			dbSetOrder(3)
			dbSeek(XFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE,.T.)

			if SF2->F2_TIPO $ "D,B"
				dbSelectArea("SA2")
				dbSetOrder(1)
				dbSeek(XFILIAL("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
				@ li,001 PSAY "Fornecedor: "+SA2->A2_NOME       ;li:=li+1
				@ li,001 PSAY "Endereco  : "+SA2->A2_END        ;li:=li+1
				@ li,001 PSAY "Cidade    : "+SA2->A2_MUN
				@ li,051 PSAY "Estado    : "+SA2->A2_EST        ;li:=li+1
				@ li,001 PSAY "CGC       : "+Transform(SA2->A2_CGC,"@R 99.999.999/9999-99") ;li++
				@ li,001 PSAY "N.F.      : "+SF2->F2_DOC         ;li:=li+1
			else
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek(XFILIAL("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
				@ li,001 PSAY "Cliente   : "+SA1->A1_NOME       ;li:=li+1
				@ li,001 PSAY "Endereco  : "+SA1->A1_END        ;li:=li+1
				@ li,001 PSAY "Complem.  : "+SA1->A1_COMPLEM    ;li:=li+1
				@ li,001 PSAY "Cidade    : "+SA1->A1_MUN
				@ li,051 PSAY "Estado    : "+SA1->A1_EST        ;li:=li+1
				@ li,001 PSAY "CGC       : "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99");li++
				@ li,001 PSAY "N.F.      : "+SF2->F2_DOC         ;li:=li+1
				//STAN LEE 04/12/2018
				
				
				cQuery := " SELECT PED_DTPROPEL DT_PROD "
			    cQuery += " FROM PED "
			    cQuery += " WHERE PED_NUM = '"+SD2->D2_PEDIDO+"'"
			    cQuery += " GROUP BY PED_DTPROPEL"
			
			    IF Select("cAlias") <> 0
				  DbSelectArea("cAlias")
				  DbCloseArea()
			    ENDIF
	
		        //crio o novo alias
		        TCQUERY cQuery NEW ALIAS "cAlias"
	
		        dbSelectArea("cAlias")
		        cAlias->(dbGoTop())
		        
				dbSelectArea("SC5")
				dbSetOrder(1)
				dbSeek(XFILIAL("SC5")+SD2->D2_PEDIDO)                   
				@ li,001 PSAY "Pedido    : "+SC5->C5_NUM         ;li:=li+1
				@ li,001 PSAY "Obs.: "
			
		
		
				If !(Trim(C5_ORCRES) == "")
					dbSelectArea("SL1")
					dbSetOrder(2)
					dbSeek(XFILIAL("SL1")+_Serie+_Documento)
					@ li,001 PSAY "          "+SL1->L1_XOBS        ;li:=li+1
					@ li,001 PSAY "          "+SL1->L1_XMENNOT     ;li:=li+1
				Else
					@ li,001 PSAY "          "+SC5->C5_OBS1        ;li:=li+1
					@ li,001 PSAY "          "+SC5->C5_OBS2        ;li:=li+1
					@ li,001 PSAY "          "+SC5->C5_OBS3        ;li:=li+1
					@ li,001 PSAY "          "+SC5->C5_MENNOTA     ;li:=li+1
				EndIf   
				dbSelectArea("SC6")
				dbSetOrder(1)
				dbSeek(XFILIAL("SC6")+SD2->D2_PEDIDO)
				@ li,001 PSAY "Dt.Entr.: "+dtoc(SC6->C6_ENTREG)  ;li:=li+1  
				@ li,001 PSAY "Dt.Prod.: "+cAlias->DT_PROD  ;li:=li+1                   
				//FIM
			endif
			@ li,001 PSAY repli("-",80)
			li:=li+1
			@ li,001 PSAY "QUANTIDADE"
			@ li,018 PSAY "DESCRICAO"
			li:=li+1
			@ li,001 PSAY repli("-",80)
			li:=li+1
			la:=li

			dbSelectArea("SD2")
			While XFILIAL("SD2")+SF2->(F2_DOC+F2_SERIE) == D2_FILIAL+D2_DOC+D2_SERIE
				@ li,001 PSAY SD2->D2_QUANT PICTURE "@e 999,999.99"
				dbSelectArea("SB1")
				dbSetorder(1)
				dbSeek(xFilial("SB1")+SD2->D2_COD)
				@ li,018 PSAY SB1->B1_DESC
				li:=li+1
				dbSelectArea("SD2")
				dbSkip()
			Enddo
			@ li,001 PSAY repli("-",80)
			li:=li+1
			@ li,001 PSAY "Recebemos "+if((li-la)>1,"as mercadorias ",;
			"a mercadoria ")+"acima relacionado em perfeito estado"
			li:=li+2

			@ li,001 PSAY "Montado: SIM( ) NAO( )"
			@ li,035 PSAY "OBS:"
			@ li,039 PSAY repli("_",30)
			li:=li+2
			@ li,001 PSAY "ASSINATURA DO MOTORISTA:"
			@ li,025 PSAY repli("_",20)
			@ li,050 PSAY "PLACA:"
			@ li,056 PSAY repli("_",10)
			li:= li+3
			@ li,024 PSAY "AVALIACAO DA ENTREGA"
			li:= li+2
			@ li,001 PSAY "OTIMO( )"
			li:= li+2
			@ li,001 PSAY "BOM( )"
			li:= li+2
			@ li,001 PSAY "REGULAR( )"
			li:= li+2
			@ li,001 PSAY "RUIM( )"
			li:= li+2
			@ li,001 PSAY "OBSERVACAO PRODUTO:"
			@ li,020 PSAY repli("_",50)
			li:= li+2
			@ li,001 PSAY "ASSINATURA DO CLIENTE:"
			@ li,023 PSAY repli("_",47) 
			li:= li+2
			@ li,001 PSAY "*CASO O CLIENTE APROVE O ESTADO FISICO DO PRODUTO, NAO SERA"
			li:= li+1
			@ li,001 PSAY "ACEITO DEVOLUCAO POR AVARIA EXTERNA."    
		next

		dbSelectArea("SF2")
		dbSkip()
	Enddo

	if aReturn[5] == 1
		Set Printer TO 
		dbcommitAll()
		ourspool(wnrel)
	endif
	MS_FLUSH()
Return
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³    Fim do Programa ROMANE.PRG, Obrigado pela Aten‡Æo !                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ