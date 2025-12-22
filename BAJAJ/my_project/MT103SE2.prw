#INCLUDE "PROTHEUS.CH" 
#DEFINE ALIASCNAB "SE2"

/*/{Protheus.doc}MT103SE2
	@description
	Este ponto de entrada tem o objetivo de possibilitar a adição de campos ao aCols de informações do título financeiro gravado 
	para o documento de entrada, para as opções de visualização, inclusão e exclusão do documento.
	Ex.: Permite adicionar o campo de Vencimento Original ao aCols de informações quando visualizar ou excluir o documento.
	Localização: 
	Function NfeFldFin() - Função responsável pelo tratamento do folder financeiro no documento de entrada.
	@author	Marcel Robinson Grosselli
	@version	1.0
	@since		25/04/2018
	@return		aRet,Array,Obrigatório,Vetor contendo os campos que deverão ser incluídos ao aHeader de títulos financeiros, 
				deverão ser criados na mesma estrutura dos campso padrões.
	@param 		PARAMIXB[1],Vetor,Obrigatorio,Vetor contendo os registros adicionados por padrão para o aHeader de título financeiro.
	@param 		PARAMIXB[2],Vetor,Obrigatorio,Variável lógica que determina se a operação é de visualização (.T.) ou não (.F.).
/*/

User Function MT103SE2()
Local aHead:= PARAMIXB[1]
Local lVisual:= PARAMIXB[2]    
Local aRet:= {}      

SXA->( DbSetOrder(1) ) // XA_ALIAS+XA_ORDEM
SXA->( DbSeek(ALIASCNAB) )
while ( SXA->(!Eof()) .And. SXA->XA_ALIAS==ALIASCNAB )
    If Alltrim(SXA->XA_DESCRIC)=="Dados Gerais"
		DbSelectArea('SX3')
		DbSetOrder(4) // X3_ARQUIVO+X3_FOLDER+X3_ORDEM
		DbSeek(ALIASCNAB+SXA->XA_ORDEM)
		while ( SX3->(!Eof()) .And. X3_ARQUIVO+X3_FOLDER==ALIASCNAB+SXA->XA_ORDEM  )
			IF ALLTRIM(SX3->X3_CAMPO)=="E2_HIST" .OR. ALLTRIM(SX3->X3_CAMPO)=="E2_XCARTAO" .OR. ALLTRIM(SX3->X3_CAMPO)=="E2_XFILPAG"
			AADD(aRet,{ TRIM(X3Titulo()),SX3->X3_CAMPO, SX3->X3_PICTURE,SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL, "",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,;
			SX3->X3_CBOX, SX3->X3_RELACAO, ".T."})     
			ENDIF
			SX3->(dbSkip())
		End
	EndIf
	SXA->(dbSkip())
End                                          

SXA->(dbgotop())
SX3->(dbgotop())

SXA->( DbSetOrder(1) ) // XA_ALIAS+XA_ORDEM
SXA->( DbSeek(ALIASCNAB) )
while ( SXA->(!Eof()) .And. SXA->XA_ALIAS==ALIASCNAB )
    If Alltrim(SXA->XA_DESCRIC)=="Banco"
		DbSelectArea('SX3')
		DbSetOrder(4) // X3_ARQUIVO+X3_FOLDER+X3_ORDEM
		DbSeek(ALIASCNAB+SXA->XA_ORDEM)
		while ( SX3->(!Eof()) .And. X3_ARQUIVO+X3_FOLDER==ALIASCNAB+SXA->XA_ORDEM  )
			IF ALLTRIM(SX3->X3_CAMPO)=="E2_LINDIG" .OR. ALLTRIM(SX3->X3_CAMPO)=="E2_CODBAR" .OR. ALLTRIM(SX3->X3_CAMPO)=="E2_DATAAGE" .OR.ALLTRIM(SX3->X3_CAMPO)=="E2_FORMPAG"
			AADD(aRet,{ TRIM(X3Titulo()),SX3->X3_CAMPO, SX3->X3_PICTURE,SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL, "",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,;
			SX3->X3_CBOX, SX3->X3_RELACAO, ".T."})     
			ENDIF
			SX3->(dbSkip())
		End
	EndIf
	SXA->(dbSkip())
End

SXA->(dbgotop())
SX3->(dbgotop())

SXA->( DbSetOrder(1) ) // XA_ALIAS+XA_ORDEM
SXA->( DbSeek(ALIASCNAB) )
while ( SXA->(!Eof()) .And. SXA->XA_ALIAS==ALIASCNAB )
    If Alltrim(SXA->XA_DESCRIC)=="Contábil"
		DbSelectArea('SX3')
		DbSetOrder(4) // X3_ARQUIVO+X3_FOLDER+X3_ORDEM
		DbSeek(ALIASCNAB+SXA->XA_ORDEM)
		while ( SX3->(!Eof()) .And. X3_ARQUIVO+X3_FOLDER==ALIASCNAB+SXA->XA_ORDEM  )
			IF ALLTRIM(SX3->X3_CAMPO)=="E2_CCUSTO" 
			AADD(aRet,{ TRIM(X3Titulo()),SX3->X3_CAMPO, SX3->X3_PICTURE,SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL, "",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,;
			SX3->X3_CBOX, SX3->X3_RELACAO, ".T."})     
			ENDIF
			SX3->(dbSkip())
		End
	EndIf
	SXA->(dbSkip())
End                                           

Return (aRet)
