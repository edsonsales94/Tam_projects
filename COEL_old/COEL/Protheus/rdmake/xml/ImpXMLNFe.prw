#INCLUDE 'INKEY.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'XMLXFUN.CH'
#INCLUDE 'AP5MAIL.CH'
#INCLUDE 'SHELL.CH'
#INCLUDE 'XMLXFUN.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FIVEWIN.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#DEFINE  ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpXMLNFe      º Autor³Fabiano Pereiraº Data ³ 23/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa Arquivo Xml Nota Eletronica - Fornecedor            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄº±±
±±³Observacao³ Perflex                                                    º±±
±±³          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 11                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
**********************************************************************
User Function ImpXMLNFe()
**********************************************************************
Local lTableField	:=	.T.
Local aRetIni 		:=	{} 
Local lRetTela 		:=	.F.

Private	cArqConfig	:=	''
Private	cIndConfig	:=	''
Private	aAlias		:=	GetArea()
Private	cCadastro	:=	'Status XML'
Private	cOldArq_Cfg	:=	''
Private	cArqErro	:=	'ZXM_ERROS_NFE.TXT'
Private	aRotina		:=	{}
Private	aCores		:=	{}
Private	aLegenda	:=	{}
Private	aArqTemp	:=	{}

Static 	nHRes    	:=	IIF(Type('oMainWnd')!='U', oMainWnd:nClientWidth, )       // Resolucao horizontal do monitor

Private bSavDblClick:=	Nil
Static _StartPath
Static _RootPath
Static _RpoDb
Static _cPathTable
Static _cArqIni
Static _cMail
Static _aEmpFil
Static SA2Recno

SetKey( VK_F12, {|| Aviso('Chave NF-e', ZXM->ZXM_CHAVE ,{'Ok'},3) })


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE PATH ESTA APLICADO	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRpo := GetSrcArray("CHECKLS.PRW")
If Ascan( aRpo, "CHECKLS.PRW" ) == 0
	Alert(	'ATENÇÃO !!!'+ENTER+ENTER+'PATH COM FUNÇÕES PARA UTILIZAR ESSA ROTINA'+ENTER+'NÃO ESTA APLICADO.'+ENTER+ENTER+;
			'Entre em contato com o Administrador.') 
	Return()	
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INICIALIZACAO VARIAVEIS \ aEmpFil\PARAMETROS \ ARQ.TEMP    |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgRun('Verificando arquivo de configuração...', 'Aguarde... ',{|| aRetIni := ExecBlock("IniConfig",.F.,.F.,) }) 		//    [1.0]
If !aRetIni[01]
	Return()
Else
	nX:=2      
	_StartPath	:=	aRetIni[nX]; nX++
	_RootPath	:=	aRetIni[nX]; nX++
	_RpoDb		:=	aRetIni[nX]; nX++
	_cPathTable	:=	IIF(!Empty(aRetIni[nX]),aRetIni[nX],_StartPath); nX++
	_cArqIni	:=	aRetIni[nX]; nX++
	_cMail		:=	aRetIni[nX]; nX++
	_aEmpFil	:=	aRetIni[nX]
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INICIALIZA\ATUALIZA ARQUIVO ZXM_CFG.DBF     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ          
MsgRun('Verificando arquivo config...', 'Aguarde... ', {|| lRetTela := ExecBlock("TelaConfig",.F.,.F., {.F.}) })        //    [2.0]
If !aRetIni[01]
	Return()
Else
	nX:=2      
	_StartPath	:=	aRetIni[nX]; nX++
	_RootPath	:=	aRetIni[nX]; nX++
	_RpoDb		:=	aRetIni[nX]; nX++
	_cPathTable	:=	aRetIni[nX]; nX++
	_cArqIni	:=	aRetIni[nX]; nX++
	_cMail		:=	aRetIni[nX]; nX++
	_aEmpFil	:=	aRetIni[nX]
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INICIALIZA\ATUALIZA ARQUIVO ZXM_CFG.DBF     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ          
MsgRun('Verificando arquivo config...', 'Aguarde... ', {|| lRetTela := ExecBlock("TelaConfig",.F.,.F., {.F.}) })        //    [2.0]
lRetTela:= .T.
If !lRetTela
	Return()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE ARQUIVO DE CONFIGURACAO    |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select('TMPCFG') == 0
   DbUseArea(.T.,,_StartPath+cArqConfig, 'TMPCFG',.T.,.F.)
   DbSetIndex(_StartPath+cIndConfig)
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ RETIRA DO _aEmpFil A EMPRESA QUE NAO ESTA ATIVA      |
//| CUSTOMIZCAO LEONARDO SAMPAIO						 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   ExecBlock("AjustaEmpFil",.F.,.F. )



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE ESTRUTURA DA TABELA ZXM                  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()
If DbSeek(cEmpAnt+cFilAnt, .F.)     
   If !TMPCFG->ESTRUT_ZXM

       If !ExecBlock("CreateTable",.F.,.F.,{cEmpAnt} )
           MsgAlert('Estrutura da Tabela ZXM \ ZXN não esta completa.')
           Return()
       EndIf

   EndIf
EndIf


DbSelectArea('ZXM');DbSetorder(1)
DbSelectArea('ZXN');DbSetorder(1)

aCores    := {	{ 'ZXM->ZXM_SITUAC=="C" '	, 'BR_VERMELHO'	},;
                { 'ZXM->ZXM_STATUS=="*" '   , 'BR_LARANJA'	},;
                { 'ZXM->ZXM_STATUS $ "I\J" '   , 'BR_AZUL'		},;
                { 'ZXM->ZXM_STATUS=="R" '   , 'BR_CINZA'	},;
                { 'ZXM->ZXM_STATUS=="X" '   , 'BR_CANCEL'	},;
                { 'ZXM->ZXM_STATUS=="G" '   , 'BR_VERDE'	}}


aLegenda:= {	{ 'BR_AZUL'		,'XML Importado'			},;
                { 'BR_LARANJA'	,'XML Arquivado'			},;
                { 'BR_CINZA'	,'XML Recusado'				},;
                { 'BR_CANCEL'	,'XML Cancelado pelo Usuario'},;
                { 'BR_VERDE'	,'XML Gravado'				},;
                { 'BR_VERMELHO'	,'XML Cancelado na Sefaz'	}}




Aadd( aRotina, { "Pesquisar"		, 'AxPesqui'                            ,	0, 1, 0, .F.})
Aadd( aRotina, { "Visualizar"		, 'ExecBlock("Visual_XML",.F.,.F.,{""})' ,	0, 4 })        		//    [3.0]	-	BROWSER COM CABEC, ITEM DO XML, GERA DOC. ETC...

//Aadd( aRotina, {'Incluir Doc.Entrada', 'A103NFiscal("SF1",,3)'   , 0, 3 })

   	
Aadd( aRotina, { "Carregar XML"		, 'ExecBlock("Carrega_XML",.F.,.F.,{""})',	0, 3 })        		//    [4.0]	-	CARREGA XML

_aRot:={}
Aadd( _aRot, { "Status XML"			, 'ExecBlock("ConsNFeSefaz",.F.,.F.,{""})',	0, 6 })  	     	//    [5.0]	-	VERIFICA STATUS DO XML NA SEFAZ
Aadd( _aRot, { "Status Sefaz"		, 'ExecBlock("SefazStatus",.F.,.F.,{""})',	0, 6 })     	   	//    [5.1]	-	VERIFICA STATUS DA SEFAZ
Aadd( _aRot, { "Site Sefaz"       	, 'ExecBlock("SiteSefaz",.F.,.F.,{""})',	0, 6 })        		//    [6.0]	-	ABRE SITE SEFAZ, COM CHAVE DE ACESSO
Aadd( _aRot, { "Msg. Erro"			, 'ExecBlock("ErroNFe",.F.,.F.,{""})',		0, 6 })        	   	//    [7.0]	-	VERIFICA COD.RETORNO SEFAZ

Aadd( aRotina,    { 'Consulta Sefaz',    _aRot, 0 , 4} )


Aadd( aRotina, { "Exportar"        	, 'ExecBlock("Exporta_XML",.F.,.F.,{""})',	0, 4 })        		//    [8.0]	-	EXPORTA XML PARA ARQUIVO
Aadd( aRotina, { "Recusar XML"     	, 'ExecBlock("Recusar_XML",.F.,.F.,{""})',	0, 4 })        		//    [9.0]	-	RECUSA XML
Aadd( aRotina, { "Cancelar"        	, 'ExecBlock("Cancelar_XML",.F.,.F.,{""})',	0, 4 })        		//    [10.0]-	CANCELA XML - ALTERA STATUS
Aadd( aRotina, { "Excluir"        	, 'ExecBlock("Excluir_XML",.F.,.F.,{""})',	0, 4 })        		//    [10.0]-	CANCELA XML - ALTERA STATUS

#IFNDEF TOP
   Aadd( aRotina, { "Filtro"		, 'ExecBlock("Filtro_XML",.F.,.F.,{""})',	0, 4 })            //    [11.0]-	OPCAO DE FIILTRO PRA VERSAO DBF
#ENDIF
Aadd( aRotina, { "Configurações"	, 'ExecBlock("TelaConfig",.F.,.F., {.T.} )',	0, 3 })           	//    [2.0]
Aadd( aRotina, { "Legenda"			, 'BrwLegenda("Legenda Status XML","Status XML",aLegenda)',    0, 2 })


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ P.E. Utilizado para adicionar botoes ao Menu Principal       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF ExistBlock("ROTIMPXMLNFE")
	aRotNew := ExecBlock("ROTIMPXMLNFE",.F.,.F.,aRotina)
	For nX := 1 To Len(aRotNew)
		aAdd(aRotina,aRotNew[nX])
	Next
Endif


MBrowse( 06, 01,22,75,"ZXM",,,,,,aCores)


//    APAGA ARQUIVOS TEMPORARIOS
If Len(aArqTemp) > 0
   For nX := 1 To Len(aArqTemp)
       FErase( aArqTemp[nX] )
   Next
EndIf

IIF(Select("ZXM")     != 0, ZXM->(DbCLoseArea()), )
IIF(Select("TMP")     != 0, TMP->(DbCLoseArea()), )
IIF(Select('TMPCFG')  != 0, TMPCFG->(DbCLoseArea()), )

RestArea(aAlias)
Return()
************************************************************************
User Function TelaConfig()    //    [2.0]
************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INICIALIZA\ATUALIZA ARQUIVO ZXM_CFG.DBF     |
//³ Chamada -> Inicio Programa e                |
//|            Rotina - Configuracao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local	aFds            :=	{}
Local	aNewField		:=	{}
Local	aReturn			:=	{}

Static 	cCfgVersao 	:= '1.0'
Static 	nHRes    	:=	IIF(Type('oMainWnd')!='U', oMainWnd:nClientWidth, )       // Resolucao horizontal do monitor

Private	cArqConfig	:=	'ZXM_CFG.DBF'
Private	cIndConfig	:=	'TMPCFG.CDX'
Private	cOldArq_Cfg	:=	Left(cArqConfig, (Len(cArqConfig)-4))+'_OLD'+Right(AllTrim(cArqConfig), 4)

Private	lMostraTela	:=	ParamIxb[01]


Private	cTpMail        	:=	_cMail
Private	cPathTables    	:=	_cPathTable+Space(15)
Private	cEmail        	:=	Space(100)
Private	cPassword    	:=	Space(100)
Private	cPOrigem 		:= 	'Caixa de Entrada'+Space(095)
Private	cPDestino    	:= 	Space(100)
Private	cServerEnv		:= 	Alltrim(GetMv('MV_RELSERV'))+ Space(100)
Private	cServerRec		:= 	Alltrim(GetMv('MV_RELSERV'))+ Space(100)
Private	cNFe9Dig		:= 	'SIM'
Private	cSer3Dig		:= 	'SIM'
Private	cSerTransf    	:= 	Space(TamSX3('F1_SERIE')[1])
Private	cTagProt		:=	'NÃO'
Private	cDescFor		:=	'SIM'
Private	cDescEmp		:=	'SIM'
Private	cTamDFor		:=	'120'	//	TAMANHO PADRAO SEFAZ
Private	cTamDEmp		:=	AllTrim(Str(TamSX3('B1_DESC')[1]))

Private	cPreDoc        	:= 	'PRE'
Private	cPortRec    	:= 	IIF(Left(_cMail,3)=='POP','110',IIF(_cMail=='IMAP','143','##'))
Private	cPortEnv    	:= 	'25 '
Private	cConect        	:= 	''
Private	cPath_XML      	:= 	Space(100)
Private	cProbEmail		:=	Space(100)
Private	cXmlCancFor		:=	Space(200)
   
Private	lAutent			:= 	.F.
Private	lSegura			:=	.F.
Private	lSSL		 	:= 	.F.
Private	lTLS		 	:= 	.F.
Private	lEstrut_Xml 	:= 	.F.
Private	cSem_XML		:= 	'NÃO'
Private	cGrv_Dif_A		:= 	'NÃO'
Private	cEmpAtiva 		:= 	'SIM'
Private	lTesteR			:=	.F.
Private	lTesteE			:=	.T.

Private nHoraCanc   	:=	GetMv('MV_SPEDEXC')
Private	cProbEmail   	:= 	Space(200)
Private	cDominio		:=	Space(100)
Private	cVerifEsp       :=	Space(100)

Private	aMyHeader   	:=	{}
Private	aMyCols     	:=	{}
Private	aConfig     	:=	{}

Private	lNewVersao		:=	.F.

SetPrvt('oDlgSM0'	,'oGrp1' ,'oGrp2' ,'oGrp3' ,'oGrp4'	,'oGrp5'	,'oFolder')
SetPrvt('oSay1'		,'oSay2' ,'oSay3' ,'oSay4' ,'oSay5'	,'oSay6' ,'oSay7' ,'oSay8' ,'oSay9' ,'oSay10')
SetPrvt('oSay11'	,'oSay12','oSay13','oSay14','oSay15','oSay16','oSay17','oSay18','oSay19','oSay20','oSay21')
SetPrvt('oGet1' 	,'oGet2' ,'oGet3' ,'oGet4' ,'oGet5'	,'oGet6' ,'oGet7' ,'oGet8' ,'oGet9' ,'oGet10')
SetPrvt('oGetr11'	,'oGet12','oGet13','oGet14','oGet15','oGet16','oGet17','oGet18','oGet19','oGet20','oGet21')
SetPrvt('oCBox4'	,'oCBox5','oCBox6','oCBox9','oCBox10','oCBox11','oCBox14','oCBox12b','oCBox12c')
SetPrvt('oBtnTest'	,'oOkConect','oNoConect')
SetPrvt('oSay1NomeFil','oSay2NomeFil','oSay3NomeFil','oSay4NomeFil')




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VERIFICA SE NUMERO DO HARDLOCK ESTA RELACIONADO³
//³PARA UTILIZAR A ROTINA                         ³
//|												  |	
//|VALIDA TEMPO DE LICENCA FREE					  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*****************************************************
If !ExecBlock('CheckLS',.F.,.F.,{.F.})
	Return(.F.)
EndIf
*****************************************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CAMPOS DO MSNEWGETDADOS	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd( aMyHeader , {'Empresa'			,'M0_CODIGO'   	,'@!',002,000,'','','C','',''} )
Aadd( aMyHeader , {'Nome Empresa'		,'M0_NOME'    	,'@!',015,000,'','','C','',''} )
Aadd( aMyHeader , {'Filial'				,'M0_CODFIL'  	,'@!',002,000,'','','C','',''} )
Aadd( aMyHeader , {'Nome Filial'		,'M0_FILIAL'  	,'@!',015,000,'','','C','',''} )
Aadd( aMyHeader , {'CNPJ'				,'M0_CGC'     	,'@R 99.999.999/9999-99',014,000,'','','C','',''} )
Aadd( aMyHeader , {'Inscr Estadual'		,'M0_INSC'     	,'@!',014,000,'','','C','',''} )
Aadd( aMyHeader , {'Endereço Entrega'	,'M0_ENDENT'    ,'@!',060,000,'','','C','',''} )
Aadd( aMyHeader , {'Compl End Entrega'	,'M0_COMPENT'   ,'@!',012,000,'','','C','',''} )
Aadd( aMyHeader , {'Bairro Entrega'		,'M0_BAIRENT'   ,'@!',020,000,'','','C','',''} )
Aadd( aMyHeader , {'Cidade Entrega'		,'M0_CIDENT'    ,'@!',020,000,'','','C','',''} )
Aadd( aMyHeader , {'Est Ent'			,'M0_ESTENT'    ,'@!',002,000,'','','C','',''} )
Aadd( aMyHeader , {'CEP Ent'			,'M0_CEPENT'    ,'@R 99999-999',008,000,'','','C','',''} )
Aadd( aMyHeader , {'Fone Ent'			,'M0_TEL'       ,'@!',014,000,'','','C','',''} )
Aadd( aMyHeader , {'FAX Ent'			,'M0_FAX'       ,'@!',014,000,'','','C','',''} )
Aadd( aMyHeader , {'Endereço Cobrança'	,'M0_ENDCOB'   	,'@!',060,000,'','','C','',''} )
Aadd( aMyHeader , {'Bairro Cobrança'    ,'M0_BAIRCOB'	,'@!',020,000,'','','C','',''} )
Aadd( aMyHeader , {'Cidade Cobrança'    ,'M0_CIDCOB'	,'@!',020,000,'','','C','',''} )
Aadd( aMyHeader , {'Est Cob'			,'M0_ESTCOB'    ,'@!',002,000,'','','C','',''} )
Aadd( aMyHeader , {'CEP Cob'			,'M0_CEPCOB'    ,'@R 99999-999',008,000,'','','C','',''} )
Aadd( aMyHeader , {'CNAE'				,'M0_CNAE'		,'@!',007,000,'','','C','',''} )
Aadd( aMyHeader , {'Código Municipio'	,'M0_CODMUN'    ,'@!',007,000,'','','C','',''} )
                             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  CAMPOS DO ARQUIVO ZXM_CFG.DBF 		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd( aFds, {"EMPRESA"		,"C",    002,000} )
Aadd( aFds, {"NOME_EMP"   	,"C",    040,000} )
Aadd( aFds, {"FILIAL"      	,"C",    002,000} )
Aadd( aFds, {"NOME_FIL"   	,"C",    040,000} )
Aadd( aFds, {"CNPJ"       	,"C",    014,000} )
Aadd( aFds, {"PATCHTABLE"	,"C",    100,000} )
Aadd( aFds, {"EMAIL"       	,"C",    150,000} )
Aadd( aFds, {"SENHA"       	,"C",    100,000} )
Aadd( aFds, {"PASTA_ORIG" 	,"C",    100,000} )
Aadd( aFds, {"PASTA_DEST" 	,"C",    100,000} )
Aadd( aFds, {"TIPOEMAIL"   	,"C",    004,000} )    //    POP,IMAP,MAPI,SMTP
Aadd( aFds, {"SERVERENV"   	,"C",    100,000} )
Aadd( aFds, {"PORTA_ENV"   	,"C",    003,000} )
Aadd( aFds, {"SERVERREC"   	,"C",    100,000} )
Aadd( aFds, {"PORTA_REC"   	,"C",    003,000} )
Aadd( aFds, {"NFE_9DIG"   	,"C",    003,000} )
Aadd( aFds, {"SER_3DIG"   	,"C",    003,000} )
Aadd( aFds, {"SER_TRANSF" 	,"C",    003,000} )
Aadd( aFds, {"PRE_DOC"  	,"C",    003,000} )
Aadd( aFds, {"ESTRUT_ZXM" 	,"L",    001,000} )
Aadd( aFds, {"AUTENTIFIC" 	,"L",    001,000} )
Aadd( aFds, {"SEGURA" 	  	,"L",    001,000} )   	
Aadd( aFds, {"SSL"		   	,"L",    001,000} )
Aadd( aFds, {"TLS"		  	,"L",    001,000} )   	
Aadd( aFds, {"PATH_XML"   	,"C",    200,000} )
Aadd( aFds, {"PROB_EMAIL" 	,"C",    200,000} )   
Aadd( aFds, {"FOR_CANC"   	,"C",    200,000} )   
Aadd( aFds, {"DOMINIO" 	 	,"C",    200,000} )   
Aadd( aFds, {"SEM_XML"     	,"C",    003,000} )   
Aadd( aFds, {"GRV_DIF_A"   	,"C",    003,000} )
Aadd( aFds, {"VERSAO"		,"C",    003,000} )
Aadd( aFds, {"EMP_ATIVA"  	,"C",    003,000} )   	//	EMPRESA ATIVA
Aadd( aFds, {"ESPECIE" 	 	,"C",    100,000} )	
Aadd( aFds, {"TAGPROT" 	 	,"C",    003,000} )	
Aadd( aFds, {"DESCFOR" 	 	,"C",    003,000} )		//	DESCRICAO PRODUTO FORNECEDOR
Aadd( aFds, {"DESCEMP" 	 	,"C",    003,000} )		//	DESCRICAO PRODUTO EMPRESA
Aadd( aFds, {"TAMDFOR" 	 	,"C",    003,000} )	
Aadd( aFds, {"TAMDEMP" 	 	,"C",    003,000} )	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|																							 |
//|				QDO ADICIONAR CAMPO ALTERAR VARIAVEL cCfgVersao                              |
//|																							 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  VERFICA VERSAO DO ARQUIVO ZXM_CFG.DBF 		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(_StartPath+cArqConfig)

	If Select('TMPCFG') == 0
		DbUseArea(.T.,,_StartPath+cArqConfig, 'TMPCFG',.T.,.F.)
	  	If !File(_StartPath+cIndConfig)						// TMPCFG.CDX
		  	DBCreateIndex('TMPCFG','EMPRESA+FILIAL', {|| 'EMPRESA+FILIAL' } )
		EndIf
	  	DbSetIndex(_StartPath+cIndConfig)
	EndIf

	If Len(aFds) != TMPCFG->(FCount())
		lNewVersao	:= .T.		
	EndIf


	DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()
	                                                                
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE INDICE EXISTE, CASO NEGATIVO CRIA NOVO INDICE	 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If !File(_StartPath+cIndConfig)						// TMPCFG.CDX
	  	DBCreateIndex('TMPCFG','EMPRESA+FILIAL', {|| 'EMPRESA+FILIAL' } )
	EndIf


	
	If lNewVersao
                
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ COPIA ZXM_CFG.DBF PARA ZXM_CFG_OLD.DBF	 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_CopyFile(_StartPath+cArqConfig, _StartPath+cOldArq_Cfg)
		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ INCREMENTA CONTADOR DE VERSAO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    c1 := Left(cCfgVersao,1)
	    c2 := Right(cCfgVersao,1)
		 If c2 == '9'    
			c1 := Val(c1); c1++
		 	cCfgVersao :=  Alltrim(Str(c1)) + '.0'
		 Else
			c2 := Val(c2); c2++
		 	cCfgVersao :=  c1+'.'+Alltrim(Str(c2))
		 EndIf

		MsgInfo('Foi criado novo(s) parâmetro(s). Verifique arquivo de configuração.')

   	ElseIf !lMostraTela
		Return(.T.)
	EndIf

EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   ALIMENTA ZXM_CFG.DBF	  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !File(_StartPath+cArqConfig) .Or. lNewVersao      //    \SYSTEM\XML_CFG.DBF
	
	IIF(Select('TMPCFG') != 0, TMPCFG->(DbCLoseArea()), )

	If lNewVersao                       
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VERIFICA SE TEM ALGUEM UTILIZANDO O ARQUIVO - TENTA ABRIR EXCLUSIVO 		|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   	DbUseArea(.T.,,_StartPath+cArqConfig, 'TMPCFG',.F.,.F.)		//	DBUSEAREA (<Lnome área>,<nome driver>, <arquivo> <apelido>,<Lconpartilhado>,<Lapenas leitura> ).
		If Select('TMPCFG') == 0
			Alert('O arquivo ZXM_CFG.DBF esta sendo utilizado.'+ENTER+'Feche o arquivo para poder continuar.')
			Return(.F.)
		Else	   
	
			IIF(Select('TMPCFG') != 0, TMPCFG->(DbCLoseArea()), )
			FErase(_StartPath+cArqConfig)	//	APAGA ZXM_CFG.DBF
			DbUseArea(.T.,,_StartPath+cOldArq_Cfg, 'TMPCFG_OLD',.T.,.F.)		//	 ABRE ZXM_CFG_OLD.DBF
		   	DBCreateIndex('TMPCFG_OLD','EMPRESA+FILIAL', {|| 'EMPRESA+FILIAL' })
			Aadd(aArqTemp, _StartPath+'TMPCFG_OLD.CDX')   

		EndIf
		
	EndIf
		
	DbCreate(_StartPath+cArqConfig, aFds )	// CRIA NOVO ZXM_CFG.DBF 
	DbUseArea(.T.,,_StartPath+cArqConfig, 'TMPCFG',.T.,.F.)
  	DBCreateIndex('TMPCFG','EMPRESA+FILIAL', {|| 'EMPRESA+FILIAL' } )
	

	DbSelectArea('SM0');DbGoTop()
	Do While !Eof()   

		If lNewVersao  // __cRdd
			DbSelectArea('TMPCFG_OLD');DbSetOrder(1);DbGoTop()
			DbSeek(SM0->M0_CODIGO + SM0->M0_CODFIL, .F.)
		EndIf

			***************************
				GET_MV_ESPECIE()	//	BUSCA SERIE == SPED
			***************************

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³   						ALIMENTA ZXM_CFG.DBF	  						|
		//| SE ZXM_CFG FOR NOVA VERSAO JOGA O CONTEUDO OLD PARA O NOVO ZXM_CFG		|
		//| CASO CONTRARIO JOGA AS VARIAVEIS										|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea('TMPCFG') 
       	RecLock('TMPCFG',.T.)
           	TMPCFG->VERSAO			:=	AllTrim(cCfgVersao)
           	TMPCFG->EMPRESA			:=	AllTrim(SM0->M0_CODIGO)
           	TMPCFG->NOME_EMP		:=	AllTrim(SM0->M0_NOME)
           	TMPCFG->FILIAL			:=	AllTrim(SM0->M0_CODFIL)
           	TMPCFG->NOME_FIL		:=	AllTrim(SM0->M0_FILIAL)
           	TMPCFG->CNPJ			:=	AllTrim(SM0->M0_CGC)
           	
           	TMPCFG->PATCHTABLE		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("PATCHTABLE"))>0,	TMPCFG_OLD->PATCHTABLE,		AllTrim(cPathTables))
           	TMPCFG->EMAIL			:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("EMAIL"))>0		, 	TMPCFG_OLD->EMAIL,			AllTrim(cEmail))
           	TMPCFG->SENHA			:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("SENHA"))>0		, 	TMPCFG_OLD->SENHA,			AllTrim(cPassword))
           	TMPCFG->PASTA_ORIG		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("PASTA_ORIG"))>0, 	TMPCFG_OLD->PASTA_ORIG,		AllTrim(cPOrigem)	)
           	TMPCFG->PASTA_DEST		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("PASTA_DEST"))>0, 	TMPCFG_OLD->PASTA_DEST,		AllTrim(cPDestino))
           	TMPCFG->TIPOEMAIL		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("TIPOEMAIL"))>0	, 	TMPCFG_OLD->TIPOEMAIL,		AllTrim(cTpMail))
           	TMPCFG->SERVERENV		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("SERVERENV"))>0	, 	TMPCFG_OLD->SERVERENV,		AllTrim(cServerEnv))
           	TMPCFG->SERVERREC		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("SERVERREC"))>0	, 	TMPCFG_OLD->SERVERREC,		AllTrim(cServerRec))           	
           	TMPCFG->NFE_9DIG		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("NFE_9DIG"))>0	, 	TMPCFG_OLD->NFE_9DIG,		'SIM'	)
           	TMPCFG->SER_3DIG		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("SER_3DIG"))>0	, 	TMPCFG_OLD->SER_3DIG,		'SIM'	)
           	TMPCFG->SER_TRANSF		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("SER_TRANSF"))>0, 	TMPCFG_OLD->SER_TRANSF,		AllTrim(cSerTransf))
           	TMPCFG->PRE_DOC			:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("PRE_DOC"))>0	,	TMPCFG_OLD->PRE_DOC,		AllTrim(cPreDoc))
           	TMPCFG->PORTA_REC		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("PORTA_REC"))>0	, 	TMPCFG_OLD->PORTA_REC,		AllTrim(cPortRec))
           	TMPCFG->PORTA_ENV		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("PORTA_ENV"))>0	, 	TMPCFG_OLD->PORTA_ENV,		AllTrim(cPortEnv))
           	TMPCFG->ESTRUT_ZXM		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("ESTRUT_ZXM"))>0, 	TMPCFG_OLD->ESTRUT_ZXM,		lEstrut_Xml	)
		   	TMPCFG->AUTENTIFIC		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("AUTENTIFIC"))>0, 	TMPCFG_OLD->AUTENTIFIC,		lAutent )
		   	TMPCFG->SSL				:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("SSL"))>0		, 	TMPCFG_OLD->SSL ,			lSSL )
		   	TMPCFG->PATH_XML		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("PATH_XML"))>0	, 	TMPCFG_OLD->PATH_XML ,		AllTrim(cPath_XML) )
		   	TMPCFG->PROB_EMAIL		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("PROB_EMAIL"))>0, 	TMPCFG_OLD->PROB_EMAIL,		AllTrim(cProbEmail))
		   	TMPCFG->FOR_CANC		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("FOR_CANC"))>0	, 	TMPCFG_OLD->FOR_CANC,		AllTrim(cXmlCancFor))
		   	TMPCFG->DOMINIO			:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("DOMINIO"))>0	, 	TMPCFG_OLD->DOMINIO,		AllTrim(cDominio) )
			TMPCFG->SEM_XML			:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("SEM_XML"))>0	, 	TMPCFG_OLD->SEM_XML,		AllTrim(cSem_XML) )
			TMPCFG->GRV_DIF_A		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("GRV_DIF_A"))>0	, 	TMPCFG_OLD->GRV_DIF_A,		AllTrim(cGrv_Dif_A) )
			TMPCFG->SEGURA    		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("SEGURA"))>0	, 	TMPCFG_OLD->SEGURA,			lSegura )
		   	TMPCFG->TLS				:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("TLS"))>0		, 	TMPCFG_OLD->TLS ,			lTLS )            
		   	TMPCFG->EMP_ATIVA		:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("EMP_ATIVA"))>0	, 	TMPCFG_OLD->EMP_ATIVA,		cEmpAtiva )            
			TMPCFG->ESPECIE			:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("ESPECIE"))>0	, 	TMPCFG_OLD->ESPECIE,		cVerifEsp )	//	Ajuste - 22.12.2011
			TMPCFG->TAGPROT			:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("TAGPROT"))>0	, 	TMPCFG_OLD->TAGPROT,		cTagProt  )
			TMPCFG->DESCFOR			:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("DESCFOR"))>0	, 	TMPCFG_OLD->DESCFOR,		cDescFor  )
			TMPCFG->DESCEMP			:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("DESCEMP"))>0	, 	TMPCFG_OLD->DESCEMP,		cDescEmp  )
			TMPCFG->TAMDFOR			:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("TAMDFOR"))>0	, 	TMPCFG_OLD->TAMDFOR,		cTamDFor  )
			TMPCFG->TAMDEMP			:=	IIF(lNewVersao .And. TMPCFG_OLD->(FieldPos("TAMDEMP"))>0	, 	TMPCFG_OLD->TAMDEMP,		cTamDEmp  )
	   MsUnLock()
	   
       DbSelectArea('SM0')
       DbSkip()
   EndDo

   	If lNewVersao
	   IIF(Select('TMPCFG_OLD') != 0, TMPCFG_OLD->(DbCLoseArea()), )
	EndIf
	
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³        ALIMENTA aConfig   		³
//| aConfig == Itens MsNewGetDados	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nRecno := Recno()
DbSelectArea('SM0');DbGoTop()
Do While !Eof()
   DbSelectArea('TMPCFG');DbGoTop()
   If DbSeek(SM0->M0_CODIGO + SM0->M0_CODFIL, .F.)
		cCfgVersao	:= 	TMPCFG->VERSAO
       	cPathTables	:= 	TMPCFG->PATCHTABLE
       	cEmail		:=	TMPCFG->EMAIL
       	cPassword	:=	TMPCFG->SENHA
       	cPOrigem	:=	TMPCFG->PASTA_ORIG
       	cPDestino	:=	TMPCFG->PASTA_DEST
       	cTpMail		:=	TMPCFG->TIPOEMAIL
       	cServerEnv	:=	TMPCFG->SERVERENV
       	cServerRec	:=	TMPCFG->SERVERREC
       	cNFe9Dig	:=	TMPCFG->NFE_9DIG
       	cSer3Dig	:=	TMPCFG->SER_3DIG
       	cSerTransf	:=	TMPCFG->SER_TRANSF
       	cPreDoc		:=	TMPCFG->PRE_DOC
       	cPortRec	:=	TMPCFG->PORTA_REC
       	cPortEnv	:=	TMPCFG->PORTA_ENV    
        lEstrut_Xml	:=	TMPCFG->ESTRUT_ZXM
		lAutent		:=	TMPCFG->AUTENTIFIC
		lSegura		:=	TMPCFG->SEGURA
		lSSL		:=	TMPCFG->SSL
		lTLS		:=	TMPCFG->TLS		
		cPath_XML	:=	TMPCFG->PATH_XML
		cProbEmail	:=	TMPCFG->PROB_EMAIL
		cXmlCancFor	:=	TMPCFG->FOR_CANC
		cDominio	:=	TMPCFG->DOMINIO
		cSem_XML	:=	TMPCFG->SEM_XML
		cGrv_Dif_A	:=	TMPCFG->GRV_DIF_A
		cEmpAtiva	:=	TMPCFG->EMP_ATIVA
		cVerifEsp 	:= 	TMPCFG->ESPECIE	//	Ajuste - 22.12.2011
		cTagProt	:=	TMPCFG->TAGPROT
		cDescFor	:=	TMPCFG->DESCFOR
		cDescEmp	:=	TMPCFG->DESCEMP
		cTamDFor	:=	TMPCFG->TAMDFOR
		cTamDEmp	:=	TMPCFG->TAMDEMP
   Else                                                                                                                                  
       	cPathTables :=  _cPathTable  
       	cEmail      :=  Space(100)
       	cPassword   :=  Space(100)
       	cPOrigem    :=  Space(100)
       	cPDestino   :=  Space(100)
       	cServerEnv	:=  Alltrim(GetMv('MV_RELSERV'))+    Space(100)
       	cServerRec	:=  Alltrim(GetMv('MV_RELSERV'))+    Space(100)       	
       	cTpMail     :=  _cMail
       	cNFe9Dig    :=  'SIM'
       	cSer3Dig    :=  'SIM'
       	cSerTransf  :=  Space(TamSX3('F1_SERIE')[1])
       	cPreDoc     :=  'PRE'
       	cPortEnv    :=  Space(03)
       	cPortRec    :=  Space(03)
        lEstrut_Xml	:=	.F.
		cPath_XML	:=	Space(100)
		cProbEmail	:=	Space(100)
		cXmlCancFor	:=	Space(100)
		lAutent		:=	.F.
		lSegura		:=	.F.
		lSSL		:=	.F.
		lTLS		:=	.F.
		cDominio	:=	Space(100)
		cSem_XML	:=	'NÃO'
		cGrv_Dif_A	:=	'SIM'
		cEmpAtiva	:=	'SIM'
		cVerifEsp 	:=	Space(100)	//	Ajuste - 22.12.2011
		cTagProt	:=	'NÃO'
		cDescFor	:=	'SIM'
		cDescEmp	:=	'NÃO'
		cTamDFor	:=	'120'
		cTamDEmp	:=	AllTrim(Str(TamSX3('B1_DESC')[1]))
   EndIf                                           

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³      ARRAY aConfig       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   DbSelectArea('SM0')
   Aadd(aConfig, {     SM0->M0_CODIGO,    SM0->M0_NOME,        SM0->M0_CODFIL,    SM0->M0_FILIAL,    SM0->M0_CGC,        SM0->M0_INSC,;    //06
                       SM0->M0_ENDENT,    SM0->M0_COMPENT,    SM0->M0_BAIRENT,    SM0->M0_CIDENT,    SM0->M0_ESTENT,    SM0->M0_CEPENT,;  //12
                       SM0->M0_TEL,       SM0->M0_FAX,        SM0->M0_ENDCOB,    SM0->M0_BAIRCOB,    SM0->M0_CIDCOB,    SM0->M0_ESTCOB,;  //18
                       SM0->M0_CEPCOB,	   SM0->M0_CNAE,        SM0->M0_CODMUN,    cTpMail, cPathTables  ,cEmail ,cPassword ,cPOrigem,cPDestino,;//27
                       cServerEnv,  cNFe9Dig,cSer3Dig,cSerTransf,cPreDoc, cPortEnv,cPortRec, lAutent , lSSL , cPath_XML,;	//	37
                       cProbEmail,  cXmlCancFor, cDominio, cSem_XML, cGrv_Dif_A, lSegura, lTLS, cServerRec, cEmpAtiva, cVerifEsp,;    // 47 
			           cTagProt, 	cDescFor, 	cDescEmp,  cTamDFor, cTamDEmp, .F. })    // 52 + .F.
        
	DbSkip()
EndDo

DbGoTo(nRecno)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   TELA DE CONFIGURACAO   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFont1     := TFont():New( "Arial",0,IIF(nHRes<=800,-10,-12),,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Arial",0,IIF(nHRes<=800,-15,-17),,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "Arial",0,IIF(nHRes<=800,-08,-10),,.T.,0,,700,.F.,.F.,,,,,, )

oDlgSM0    := MSDialog():New( D(050),D(050),D(485),D(720),"Configuração Empresas Importação XML",,,.F.,,,,,,.T.,,oFont1,.T. )

oGrp1      := TGroup():New( D(004),D(004),D(088),D(330),"",oDlgSM0,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBrwSM0    := MsNewGetDados():New( D(010),D(008),D(084),D(320),GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','',,0,999,,'','AllwaysTrue()',oGrp1,aMyHeader,aConfig )


                              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   	    FOLDERs			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFolder    := TFolder():New( D(092),D(008),{"Config. Empresa","Config. XML Fornec.","Config. e-mail","Config.Extras"},{},oGrp1,,,,.T.,.F.,D(320),D(108),)
oFolder:bSetOption	:=	{|| IIF(oFolder:nOption==1, oCBox4:SetFocus(), IIF(oFolder:nOption==2, oCBox9:SetFocus(), oCBox14:SetFocus()))}



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³     CONFIG.EMPRESA       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//[ EMPRESA \ FILIAL ]
oSay1NomeFil := TSay():New( D(004),D(008),{|| Alltrim(aConfig[oBrwSM0:nAT][02])+' \ '+AllTrim(aConfig[oBrwSM0:nAT][04]) },oFolder:aDialogs[1],,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(150),D(008) )
                                                                           

oGrp2      := TGroup():New( D(012),D(006),D(095),D(170),"Config. Empresa",oFolder:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )

cToolTip  := 'Informar a quantidade de horas, conforme a SEFAZ de cada estado determina, para possibilitar o cancelamento da NFe.'+ENTER
cToolTip  += 'Parâmetro utilizado para verificar se fornecedor cancelou o XML.'+ENTER
cToolTip  += 'Caso o XML esteje Importado\Gravado, e o fornecedor cancelou o XML ANTES desse período, é enviado um e-mail,'+ENTER
cToolTip  += 'para determinado(s) usuário(s) informando o cancelamento (e-mail disparado pelo workflow).'+ENTER
cToolTip  += 'Parâmetro MV_SPEDEXC.'
oSay1  := TSay():New( D(020),D(008),{||"Num. Horas Canc.XML"},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(100),D(008) )
oGet1  := TGet():New( D(026),D(008),{|u| If(PCount()>0,nHoraCanc:=u,nHoraCanc)},oFolder:aDialogs[1],D(060),D(008),'',/*{||PutMv( 'XM_SPEDEXP', nHoraCanc)}*/,CLR_HGRAY,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)
oGet1:Disable()
                            

cToolTip:= 'Caminho dos arquivos XML.'+ENTER+'Utilizado na opção de carregar XML para selecionar o diretório.'
oSay2  := TSay():New( D(020),D(070),{||"Caminho arq. XML"},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(100),D(008) )
oBtn2  := TButton():New( D(026),D(160),"...",oFolder:aDialogs[1],{|| cPath_XML  := cGetFile("Anexos (*xml)|*xml|","Arquivos (*xml)",0,'',.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_MULTISELECT+GETF_RETDIRECTORY), aConfig[oBrwSM0:nAT][37]:= AllTrim(cPath_XML), cPath_XML+=Space(100), oGet2:Refresh() },D(010),D(010),,,,.T.,,"",,,,.F. )
oGet2  := TGet():New( D(026),D(070),{|u| If(PCount()>0,cPath_XML:=u,cPath_XML)},oFolder:aDialogs[1],D(090),D(008),'',{|| aConfig[oBrwSM0:nAT][37]:= AllTrim(cPath_XML), cPath_XML+=Space(100),oGet2:Refresh() },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)


cToolTip:= 'Série da NF Saída que a Filial utiliza.'+ENTER+'Parâmetro utiliza os XML´s que forem de transferencia.'
oSay3 := TSay():New( D(040),D(008),{|| "Série NF Saída" },oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008) )
oGet3 := TGet():New( D(046),D(008),{|u| If(PCount()>0,cSerTransf:=u,cSerTransf) },oFolder:aDialogs[1],D(060),D(008),'', {|| aConfig[oBrwSM0:nAT][31]:=cSerTransf, oGet3:Refresh() }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)

oSay4 := TSay():New( D(040),D(070),{|| 'Gerar Pré-Nota\Doc.Entr' },oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(090),D(008) )
oCBox4:= TComboBox():New( D(046),D(070),{|u| If(PCount()>0,cPreDoc:=u,IIF(cPreDoc=='PRE','PRE-NOTA','DOC.ENTRADA'))},{'PRE-NOTA','DOC.ENTRADA'},D(060),D(012),oFolder:aDialogs[1],,,{|| aConfig[oBrwSM0:nAT][32]:=cPreDoc},CLR_BLACK,CLR_WHITE,.T.,oFont1,"Pre-Nota\Doc.Entrada",,,,,,, )
oCBox4:cToolTip := 'Gerar Pré-Nota ou Doc.Entrada após realizar o vinculo Produto X Fornecedor'                    


oSay5	:= TSay():New( D(060),D(008),{|| 'Inclui Pré\Doc sem XML?' },oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008) )
oCBox5  := TComboBox():New( D(066),D(008),{|u| If(PCount()>0,cSem_XML:=u,cSem_XML)},{"SIM","NÃO"},D(060),D(012),oFolder:aDialogs[1],,,{|| aConfig[oBrwSM0:nAT][41]:=cSem_XML },CLR_BLACK,CLR_WHITE,.T.,oFont1,"",,,,,,, )
cToolTip:=	'Inclui Pré-Nota\Doc.Entrada sem XML ?'+ENTER+'Utilizado na inclusão da Pré-Nota\Doc.Entrada.'+ENTER+'Deverá ser informado um motivo da inclusão da Pré-Nota\Doc.Entrada sem o XML.'
oCBox5:cToolTip := cToolTip

oSay6	:= TSay():New( D(060),D(070),{|| 'Pré\Doc com Status <> Aprovado?' },oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(100),D(008) )
oCBox6  := TComboBox():New( D(066),D(070),{|u| If(PCount()>0,cGrv_Dif_A:=u,cGrv_Dif_A)},{"SIM","NÃO"},D(060),D(012),oFolder:aDialogs[1],,,{|| aConfig[oBrwSM0:nAT][42]:=cGrv_Dif_A },CLR_BLACK,CLR_WHITE,.T.,oFont1,"",,,,,,, )
cToolTip:= 'Grava Pré-Nota\Doc.Entrada com Status <> Aprovado\Cancelado?'+ENTER+'Caso ocorra problema na consulta do XML na SEFAZ e não retornar nenhum status é possivel incluir a Pré-Nota\Doc.Entrada.'
oCBox6:cToolTip := cToolTip
/*
oSay2  := TSay():New( D(077),D(045),{||"Empresa\Filial Ativa ?"},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(100),D(008) )
oCBoxEmpAtiva := TComboBox():New( D(083),D(045),{|u| If(PCount()>0,cEmpAtiva:=u,cEmpAtiva)},{"SIM","NÃO"},056,012,oFolder:aDialogs[1],,,{|| aConfig[oBrwSM0:nAT][46]:=cEmpAtiva },CLR_BLACK,CLR_WHITE,.T.,oFont1,'Considerar empresa no processamento do programa?',,,,,,, )
*/
oSay2  := TSay():New( D(077),D(008),{||"Empresa\Filial Ativa ?"},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(090),D(008) )
oCBoxEmpAtiva := TComboBox():New( D(083),D(008),{|u| If(PCount()>0,cEmpAtiva:=u,cEmpAtiva)},{"SIM","NÃO"},056,012,oFolder:aDialogs[1],,,{|| aConfig[oBrwSM0:nAT][46]:=cEmpAtiva },CLR_BLACK,CLR_WHITE,.T.,oFont1,'Considerar empresa no processamento do programa?',,,,,,, )

// CASO NAO = INCLUI DOC. SEM XML
cToolTip:= "Especifique as Espécies de Documento (Ex.: SPED) que o sistema deve verificar para que não haja Pré-Nota\Doc.Entrada sem XML. Separe por ; "
oSayTp:= TSay():New( D(077),D(070),{|| "Verificar apenas a(s) seguinte(s) Espécies:" 	},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(090),D(008) )
oGetTp:= TGet():New( D(083),D(070),{|u| If(PCount()>0,cVerifEsp:=u,cVerifEsp)	},oFolder:aDialogs[1],D(090),D(008),'', {|| aConfig[oBrwSM0:nAT][47]:=cVerifEsp, oGetTp:Refresh() }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)

                       
                       

oGrp3      := TGroup():New( D(012),D(176),D(095),D(312),"Recebem E-mail quando...",oFolder:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )

cToolTip  := 'Quando é disparado um e-mail e ocorre algum problema (e-mail destinatário inválido),'+ENTER
cToolTip  += 'é possível enviar um e-mail, para determinado(s) usuário(s), e informar que o e-mail não foi enviado para o(s) destinatário(s).'+ENTER
cToolTip  += 'Ex.: Ao recusar um XML e enviado um e-mail ao fornecedor e ocorrer algum erro no envio.'+ENTER
cToolTip  += 'Obs.: colocar apenas o nome da conta sem @. Coloque ";" para adicionar mais contas.'
oSay7  := TSay():New( D(020),D(180),{||"Ocorrer problema no envio dos e-mails"},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(170),D(008) )
oGet7  := TGet():New( D(026),D(180),{|u| If(PCount()>0,cProbEmail:=u,cProbEmail)},oFolder:aDialogs[1],D(130),D(008),'',{|| aConfig[oBrwSM0:nAT][38]:= AllTrim(cProbEmail), cProbEmail+=Space(100), oGet7:Refresh()  /*PutMv( 'XM_ADMIN_E', cProbEmail )*/  },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)

cToolTip  := 'Conta de e-mail do(s) usuário(s) para receber e-mail informando que XML foi cancelado pelo fornecedor.'
cToolTip  += 'Obs.: colocar apenas o nome da conta sem @. Coloque ";" para adicionar mais contas.'
oSay8  := TSay():New( D(040),D(180),{||"Fornecedor cancelar XML antes do prazo"},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(170),D(008) )
oGet8  := TGet():New( D(046),D(180),{|u| If(PCount()>0,cXmlCancFor:=u,cXmlCancFor)},oFolder:aDialogs[1],D(130),D(008),'',{|| aConfig[oBrwSM0:nAT][39]:= AllTrim(cXmlCancFor), cXmlCancFor+=Space(100),oGet8:Refresh() /*PutMv( 'XM_XMLCANC', cEmailCancXML )*/ },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)

cToolTip  := 'Domínio da Empresa.'+ENTER+'Utilizado para enviar e-mail.'+ENTER
cToolTip  += 'Ex.: colocar empresaXYZ.com.br sem o nome da conta, sem @.'
oSay9  := TSay():New( D(060),D(180),{||"Dominio Empresa"},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(170),D(008) )
oGet9  := TGet():New( D(066),D(180),{|u| If(PCount()>0,cDominio:=u,cDominio)},oFolder:aDialogs[1],D(130),D(008),'',{|| aConfig[oBrwSM0:nAT][40]:= AllTrim(cDominio), cXmlCancFor+=Space(100),oGet9:Refresh() },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   CONFIG. FORNECEDOR	 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//[ EMPRESA \ FILIAL ]
oSay2NomeFil := TSay():New( D(004),D(008),{|| Alltrim(aConfig[oBrwSM0:nAT][02])+' \ '+AllTrim(aConfig[oBrwSM0:nAT][04]) },oFolder:aDialogs[2],,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(150),D(008) )

oGrp4      := TGroup():New( D(012),D(006),D(045),D(170),"XML Fornecedor",oFolder:aDialogs[2],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay9      := TSay():New( D(020),D(008),{||"Nota com 9 Dígitos"},oFolder:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oCBox9  := TComboBox():New( D(026),D(008),{|u| If(PCount()>0,cNFe9Dig:=u,cNFe9Dig)},{"SIM","NÃO"},076,012,oFolder:aDialogs[2],,,{|| aConfig[oBrwSM0:nAT][29]:=cNFe9Dig },CLR_BLACK,CLR_WHITE,.T.,oFont1,"Nota com 9 Digitos",,,,,,, )
oCBox9:cToolTip := 'Completa com "0" Zeros o restante dos caracteres da Pre-Nota\Doc.Entrada.'

oSayS10  := TSay():New( D(020),D(070),{|| "Série com 3 Dígitos"},oFolder:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008) )
oCBox10  := TComboBox():New( D(026),D(070),{|u| If(PCount()>0,cSer3Dig:=u,cSer3Dig)},{"SIM","NÃO"},076,012,oFolder:aDialogs[2],,,{|| aConfig[oBrwSM0:nAT][30]:=cSer3Dig },CLR_BLACK,CLR_WHITE,.T.,oFont1,"Série com 3 Digitos",,,,,,, )
oCBox10:cToolTip := 'Completa com "0" Zeros o restante dos caracteres da Pre-Nota\Doc.Entrada.'



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³      CONFIG. EMAIL       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	[ EMPRESA \ FILIAL  ]
oSay3NomeFil := TSay():New( D(004),D(008),{|| Alltrim(aConfig[oBrwSM0:nAT][02])+' \ '+AllTrim(aConfig[oBrwSM0:nAT][04]) },oFolder:aDialogs[3],,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(150),D(008) )

oGrp5      := TGroup():New( D(012),D(006),D(095),D(315),"",oFolder:aDialogs[3],CLR_BLACK,CLR_WHITE,.T.,.F. )

oCBox11 := TCheckBox():New( D(014),D(142),"Autentificação?",{|u| If(PCount()>0,lAutent:=u,lAutent)},oFolder:aDialogs[3],D(068),D(008),,		{|| aConfig[oBrwSM0:nAT][35]:= lAutent 	},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox11:cToolTip := 'Utiliza Autentificação ?'
oCBox12    := TCheckBox():New( D(014),D(215),"Conexão segura?",{|u| If(PCount()>0,lSegura:=u,lSegura)},oFolder:aDialogs[3],D(088),D(008),,	{|| aConfig[oBrwSM0:nAT][43]:= lSegura, PortPadrao(), IIF(lSegura,(oCBox12b:Show(),oCBox12c:Show()),(oCBox12b:Hide(),oCBox12c:Hide()) ),(lSSL:=.F.,aConfig[oBrwSM0:nAT][36]:=.F.,lTLS:=.F.,aConfig[oBrwSM0:nAT][44]:=.F.), oGet21:Refresh(), oGet20:Refresh()	},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox12:cToolTip := 'Utiliza conex"ao segura ?'

oCBox12b    := TCheckBox():New( D(014),D(275),"SSL",{|u| If(PCount()>0,lSSL:=u,lSSL)},oFolder:aDialogs[3],D(088),D(008),,{|| IIF( !VerBuild(),lSSL:=.F., (PortPadrao(), IIF(lSSL,lTLS:=.F.,IIF(lSSL,lSSL:=.F.,lSSL:=.T.)), aConfig[oBrwSM0:nAT][36]:= lSSL, oCBox12b:Refresh(), oCBox12c:Refresh(), oGet21:Refresh(), oGet20:Refresh()) )},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox12c    := TCheckBox():New( D(014),D(295),"TLS",{|u| If(PCount()>0,lTLS:=u,lTLS)},oFolder:aDialogs[3],D(088),D(008),,{|| IIF( !VerBuild(),lTLS:=.F., (PortPadrao(), IIF(lTLS,lSSL:=.F.,IIF(lTLS,lTLS:=.F.,lTLS:=.T.)), aConfig[oBrwSM0:nAT][44]:= lTLS, oCBox12b:Refresh(), oCBox12c:Refresh(), oGet21:Refresh(), oGet20:Refresh()) )},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )

oSay13  := TSay():New( D(022),D(008),{||"Path Table"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(060),D(008) )
oGet13  := TGet():New( D(028),D(008),{|u| If(PCount()>0,cPathTables:=u,cPathTables)},oFolder:aDialogs[3],D(060),D(008),'',{|| aConfig[oBrwSM0:nAT][23]:=cPathTables },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"Path Table - Diretório onde esta localizado os arquivos SX´s",,,.F.,.F.,,.F.,.F.,"","cPathTables",,)


oSay14:= TSay():New( D(022),D(075),{||"Protocolo de E-mail"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008))
oCBox14  := TComboBox():New( D(028),D(075),{|u| If(PCount()>0,cTpMail:=u,cTpMail)},{"POP","IMAP","MAPI"},D(060),D(012),oFolder:aDialogs[3],,,{|| PortPadrao(), aConfig[oBrwSM0:nAT][22]:=cTpMail, IIF(cTpMail=='IMAP',(oGet18:Enable(),oGet18:SetColor(CLR_BLACK,CLR_WHITE)),(oGet18:Disable(),aConfig[oBrwSM0:nAT][27]:=cPDestino:=Space(100),oGet18:SetColor(CLR_BLACK,CLR_HGRAY)) ), oGet18:Refresh() },CLR_BLACK,CLR_WHITE,.T.,oFont1,"",,,,,,, )
oCBox14:cToolTip := 'Indica o protocolo de e-mail que será usado para envio de e-mail.'

cToolTip   := 'O parâmetro permite informar a conta de e-mail que será acessada para baixar os XML e enviar e-mail de notificação. '+ENTER
cToolTip   += 'No entanto, dependendo da configuração do servidor, é necessário informar'+ENTER
cToolTip   += 'a conta de e-mail completa (usuario@provedor.com.br) ou apenas o nome do usuário.
oSay15  := TSay():New( D(022),D(142),{|| "E-mail"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oGet15  := TGet():New( D(028),D(142),{|u| If(PCount()>0,cEmail:=u,cEmail) },oFolder:aDialogs[3],D(125),D(008),'', {|| aConfig[oBrwSM0:nAT][24]:=cEmail }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)

oSay16  := TSay():New( D(022),D(270),{||"Senha"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008))                                                                                                         //.T.== ****
oGet16  := TGet():New( D(028),D(270),{|u| If(PCount()>0,cPassword:=u,cPassword)},oFolder:aDialogs[3],D(045),D(008),'',{|| aConfig[oBrwSM0:nAT][25]:=cPassword },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"Senha da conta de e-mail",,,.F.,.F.,,.F.,.T.,"","",,)

cToolTip   := 'Pasta de Origem.'+ENTER+'Onde o programa irá LER os e-mails e buscar os XML´s.'+ENTER
oSay17  := TSay():New( D(042),D(008),{|| "Pasta Origem E-mail"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008))
oGet17  := TGet():New( D(048),D(008),{|u| If(PCount()>0,cPOrigem:=u,cPOrigem) },oFolder:aDialogs[3],D(060),D(008),'', {|| aConfig[oBrwSM0:nAT][26]:=cPOrigem }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)

cToolTip   := 'Pasta de Destino.'+ENTER+'Onde o programa irá MOVER os e-mails após importa-los para o sistema. '+ENTER+'Opção apenas para Protocolo IMAP.'
oSay18  := TSay():New( D(042),D(075),{|| "Pasta Destino E-mail"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008) )
oGet18  := TGet():New( D(048),D(075),{|u| If(PCount()>0,cPDestino:=u,cPDestino) },oFolder:aDialogs[3],D(060),D(008),'', {|| aConfig[oBrwSM0:nAT][27]:=cPDestino, oGet18:Refresh() }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  SERVIDOR DE ENVIO  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSay19 := TSay():New( D(042),D(142),{|| "Servidor de Envio"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oGet19 := TGet():New( D(048),D(142),{|u| If(PCount()>0,cServerEnv:=u,cServerEnv) },oFolder:aDialogs[3],D(125),D(008),'', {|| aConfig[oBrwSM0:nAT][28]:=cServerEnv }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,'Indica o endereço ou alias do servidor de e-mail IMAP/POP/MAPI/SMTP.',,,.F.,.F.,,.F.,.F.,"","",,)

oSay20  := TSay():New( D(042),D(270),{||"Porta SMTP" },oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oGet20  := TGet():New( D(048),D(270),{|u| If(PCount()>0,cPortEnv:=u,cPortEnv)},oFolder:aDialogs[3],D(020),D(008),'',{|| aConfig[oBrwSM0:nAT][33]:= cPortEnv },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,'Indica a porta de comunicação para conexão IMAP/POP/MAPI/SMTP.',,,.F.,.F.,,.F.,.F.,"","",,)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  SERVIDOR DE RECEBIMENTO  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSay19b := TSay():New( D(060),D(142),{|| "Servidor de Recebimento"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(088),D(008))
oGet19b := TGet():New( D(066),D(142),{|u| If(PCount()>0,cServerRec:=u,cServerRec) },oFolder:aDialogs[3],D(125),D(008),'', {|| aConfig[oBrwSM0:nAT][45]:=cServerRec }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,'Indica o endereço ou alias do servidor de e-mail IMAP/POP/MAPI/SMTP.',,,.F.,.F.,,.F.,.F.,"","",,)

oSay21  := TSay():New( D(060),D(270),{||"Porta " + aConfig[oBrwSM0:nAT][22] },oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oGet21  := TGet():New( D(066),D(270),{|u| If(PCount()>0,cPortRec:=u,cPortRec)},oFolder:aDialogs[3],D(020),D(008),'',{|| aConfig[oBrwSM0:nAT][34]:= cPortRec },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,'Indica a porta de comunicação para conexão SMTP (Padrão 25).',,,.F.,.F.,,.F.,.F.,"","",,)


oCBox22b    := TCheckBox():New( D(070),D(010),"Envio",{|u| If(PCount()>0,lTesteE:=u,lTesteE)},oFolder:aDialogs[3],D(088),D(008),,	{|| IIF(lTesteE, lTesteR:=.F.,), (cConect:='',oOkConect:Refresh(),oNoConect:Refresh()), oCBox22b:Refresh(),oCBox22c:Refresh() },,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox22c    := TCheckBox():New( D(070),D(030),"Recebimento",{|u| If(PCount()>0,lTesteR:=u,lTesteR)},oFolder:aDialogs[3],D(088),D(008),,	{|| IIF(lTesteR, lTesteE:=.F.,), (cConect:='',oOkConect:Refresh(),oNoConect:Refresh()), oCBox22b:Refresh(),oCBox22c:Refresh() 	},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oBtnTest    := TButton():New( D(080),D(008),"Testar Conexão",oFolder:aDialogs[3],{|| IIF(lTesteE.Or.lTesteR, MsgRun('Testando Conexão...', 'Aguarde... ',{|| cConect := TestConect(IIF(lTesteE,'E','R')), IIF(cConect=='Conectado com Sucesso',(oOkConect:Show(),oNoConect:Hide()),(oNoConect:Show(),oOkConect:Hide())) }), MsgInfo('Marque uma opção - Envio ou Recebimento')) },D(057),D(012),,oFont3,,.T.,,"",,,,.F. )

oOkConect  := TSay():New( D(085),D(070),{|u| If(PCount()>0,cConect:=u,cConect) },oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(200),D(008) )
oNoConect  := TSay():New( D(085),D(070),{|u| If(PCount()>0,cConect:=u,cConect) },oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE, D(200),D(008) )
oOkConect:Hide()
oNoConect:Hide()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³***** CONFIG.EXTRAS ******³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//[ EMPRESA \ FILIAL ]
oSay4NomeFil := TSay():New( D(004),D(008),{|| Alltrim(aConfig[oBrwSM0:nAT][02])+' \ '+AllTrim(aConfig[oBrwSM0:nAT][04]) },oFolder:aDialogs[4],,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(150),D(008) )

oGrp6      := TGroup():New( D(012),D(006),D(095),D(315),"Config. Extras",oFolder:aDialogs[4],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayE2      := TSay():New( D(020),D(015),{||"Verifica TAG de Protocolo no XML ?"},oFolder:aDialogs[4],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(098),D(008) )
oCBoxE21  	:= TComboBox():New( D(026),D(015),{|u| If(PCount()>0,cTagProt:=u,cTagProt)},{"SIM","NÃO"},076,012,oFolder:aDialogs[4],,,{|| aConfig[oBrwSM0:nAT][48]:= cTagProt },CLR_BLACK,CLR_WHITE,.T.,oFont1,"XML com TAG Protocolo",,,,,,, )
oCBoxE21:cToolTip := 'Verifica TAG ProtNFe no XML. Utilizado para verificar a validade do XML'


oGrp6       := TGroup():New( D(038),D(012),D(085),D(155),"Descrições, Tamanhos",oFolder:aDialogs[4],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayE3      := TSay():New( D(045),D(015),{||"Descriçao Prod.Fornec ?"},oFolder:aDialogs[4],,oFont1,.F.,.F.,.F.,.T.,CLR_HGRAY,CLR_WHITE,D(098),D(008) )
oCBoxE31  	:= TComboBox():New( D(051),D(015),{|u| If(PCount()>0,cDescFor:=u,cDescFor)},{"SIM","NÃO"},076,012,oFolder:aDialogs[4],,,{|| aConfig[oBrwSM0:nAT][49]:= cDescFor },CLR_BLACK,CLR_WHITE,.T.,oFont1,"Apresentar Descrição do Produto do Fornecedor contido no XML?",,,,,,, )
oCBoxE31:cToolTip := 'Apresentar Descrição do Produto do Fornecedor contido no XML?'+ENTER+'Opção necessária para funcionamento do porgrama.'
oCBoxE31:Disable()

oSayE31 	:= TSay():New( D(045),D(085),{|| "Tam. Descr. Fornec"},oFolder:aDialogs[4],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(088),D(008))
oGetE31 	:= TGet():New( D(051),D(085),{|u| If(PCount()>0,cTamDFor:=u,cTamDFor) },oFolder:aDialogs[4],D(045),D(008),'', {|| aConfig[oBrwSM0:nAT][51]:= cTamDFor }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,'Tamanho Descrição Produto do Fornecedor',,,.F.,.F.,,.F.,.F.,"","",,)

oSayE4      := TSay():New( D(065),D(015),{||"Descriçao Prod.Empresa ?"},oFolder:aDialogs[4],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(098),D(008) )
oCBoxE41  	:= TComboBox():New( D(071),D(015),{|u| If(PCount()>0,cDescEmp:=u,cDescEmp)},{"SIM","NÃO"},076,012,oFolder:aDialogs[4],,,{|| aConfig[oBrwSM0:nAT][50]:= cDescEmp },CLR_BLACK,CLR_WHITE,.T.,oFont1,"Apresentar Descrição do Produto da sua Empresa?",,,,,,, )
oCBoxE41:cToolTip := 'Apresentar Descrição do Produto da sua Empresa?'

oSayE41 	:= TSay():New( D(065),D(085),{|| "Tam. Descr. Empresa"},oFolder:aDialogs[4],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(088),D(008))
oGete41 	:= TGet():New( D(071),D(085),{|u| If(PCount()>0,cTamDEmp:=u,cTamDEmp) },oFolder:aDialogs[4],D(045),D(008),'', {|| aConfig[oBrwSM0:nAT][52]:= cTamDEmp }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,'Tamanho Descrição Produto da Empresa',,,.F.,.F.,,.F.,.F.,"","",,)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  BOTOES OK - CANCELA     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oBtnOK     := TButton():New( D(205),D(120),"&OK",oDlgSM0,{|| MsgRun("Gravando dados...",,{|| GravaConfig()}), oDlgSM0:End() },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )
oBtnCanc   := TButton():New( D(205),D(200),"&Cancela",oDlgSM0,{|| oDlgSM0:End() },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )


oBrwSM0:oBrowse:bChange := {|| AtuGets() }

oBrwSM0:oBrowse:Refresh()
oBrwSM0:oBrowse:SetFocus()

oDlgSM0:Activate(,,,.T.)


Return(.T.)
***********************************************************************
Static Function VerBuild()
***********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	   VERIFICA VERSAO DA BUILD		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lRet := .T.

If Left(GetBuild(),12) > '7.00.101220A'
	MsgInfo('O suporte aos protocolos  (SSL e/ou TLS) foram implementados a partir da build  7.00.101220A.'+ENTER+'Build uitilizada: '+AllTrim(GetBuild()))
	lRet := .F.	
	lSSL:=.F.;oCBox12b:Refresh()
	lTLS:=.F.;oCBox12c:Refresh()	
EndIf	
	
Return(lRet)
***********************************************************************
Static Function PortPadrao()
***********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	   INFORMA A PARTA PADRAO  		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPortEnv	:=	'25 '

If Left(cTpMail,3) =='POP'
	cPortRec	:=	IIF(!lSegura,'110','995')
ElseIf  cTpMail =='IMAP'
	cPortRec	:=	IIF(!lSegura,'143','993')
ElseIf cTpMail =='SMTP'
	cPortRec	:=	IIF(!lSegura,'25 ', IIF(lSSL,'587','465') )
Else
	cPortRec	:=	'## '
EndIf

Return()
***********************************************************************
Static Function Get_MV_ESPECIE()
***********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	 BUSCA NO SX6 O PARAMETRO MV_ESPECIE	³
//³	 E SEPARA APENAS AS SERIES == SPED  	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lSX6 	:= .F.
Local aAreaSX6:= GetArea()

If File(_StartPath+'SX6'+SM0->M0_CODIGO+'0.DBF')

	If cEmpAnt != SM0->M0_CODIGO
		lSX6 := .T.
		IIF(Select('SX6') != 0, SX6->(DbCLoseArea()), )
		DbUseArea(.T.,,_StartPath+'SX6'+SM0->M0_CODIGO+'0', 'SX6',.T.,.F.)
	EndIf
	
	SX6->(DbGoTop(), DbSetOrder(1))
	If SX6->(DbSeek(SM0->M0_CODFIL+'MV_ESPECIE',.F.))
		cMV_Especie := AllTrim(SX6->X6_CONTEUD)
		aMV_Especie := StrTokArr( cMv_Especie, ";" )
		
	Else
		aMV_Especie := StrTokArr( GetMv('MV_ESPECIE'), ";" )
	EndIf                                            
	
	For nX:=1 To Len(aMV_Especie)
		If 'SPED' $ aMV_Especie[nX]
			nPos := AT('=',aMV_Especie[nX])
			cSerTransf := AllTrim(Left(aMV_Especie[nX], nPos-1))
		Else
			cSerTransf := Space(TamSX3('F1_SERIE')[1])
		EndIf
	Next
	
Else
	cSerTransf := Space(TamSX3('F1_SERIE')[1])
EndIf

If lSX6
	If File(_StartPath+'SX6'+cFilAnt+'0')
		IIF(Select('SX6') != 0, SX6->(DbCLoseArea()), )
		DbUseArea(.T.,,_StartPath+'SX6'+cFilAnt+'0', 'SX6',.T.,.F.)
	EndIf
EndIf
                          
RestArea(aAreaSX6)
Return()
***********************************************************************
Static Function AtuGets()
***********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATUALIZA aConfig QDO TROCAR DE LINHA DO BROWSER DE CONFIG.             ³
//³ Chamada -> TelaConfig()                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// [Config.Empresa]
cPath_XML		:=	aConfig[oBrwSM0:nAT][37]; oGet2:Refresh()
cSerTransf    	:=	aConfig[oBrwSM0:nAT][31]; oGet3:Refresh()
cPreDoc         :=	aConfig[oBrwSM0:nAT][32]; oCBox4:Refresh()
cSem_XML		:=	aConfig[oBrwSM0:nAT][41]; oCBox5:Refresh()
cGrv_Dif_A		:=	aConfig[oBrwSM0:nAT][42]; oCBox6:Refresh()
cProbEmail		:=	aConfig[oBrwSM0:nAT][38]; oGet7:Refresh()
cXmlCancFor		:=	aConfig[oBrwSM0:nAT][39]; oGet8:Refresh()
cDominio		:=	aConfig[oBrwSM0:nAT][40]; oGet9:Refresh()
cEmpAtiva		:=	aConfig[oBrwSM0:nAT][46]; oCBoxEmpAtiva:Refresh()
cVerifEsp		:=	aConfig[oBrwSM0:nAT][47]; oGetTp:Refresh()		//	Ajuste - 22.12.2011
                                                                  
// [Config.XML Fornecedor]
cNFe9Dig       :=	aConfig[oBrwSM0:nAT][29]; oCBox9:Refresh()
cSer3Dig       :=	aConfig[oBrwSM0:nAT][30]; oCBox10:Refresh()
    
   
// [Config.e-mail]
lAutent    		:=	aConfig[oBrwSM0:nAT][35]; oCBox11:Refresh()
lSegura     	:=	aConfig[oBrwSM0:nAT][43]; oCBox12:Refresh()
cPathTables		:=	aConfig[oBrwSM0:nAT][23]; oGet13:Refresh()
cTpMail			:=	aConfig[oBrwSM0:nAT][22]; oCBox14:Refresh()
cEmail        	:=	aConfig[oBrwSM0:nAT][24]; oGet15:Refresh()
cPassword    	:=	aConfig[oBrwSM0:nAT][25]; oGet16:Refresh()
cPOrigem       	:=	aConfig[oBrwSM0:nAT][26]; oGet17:Refresh()
cPDestino   	:=	aConfig[oBrwSM0:nAT][27]; oGet18:Refresh()
cServerEnv		:=	aConfig[oBrwSM0:nAT][28]; oGet19:Refresh()
cServerRec		:=	aConfig[oBrwSM0:nAT][45]; oGet19b:Refresh()
cPortEnv    	:=	aConfig[oBrwSM0:nAT][33]; oGet20:Refresh()
cPortRec    	:=	aConfig[oBrwSM0:nAT][34]; oGet21:Refresh()
lSSL        	:=	aConfig[oBrwSM0:nAT][36]; oCBox12b:Refresh()
lTLS        	:=	aConfig[oBrwSM0:nAT][44]; oCBox12c:Refresh()

// [Config.Extra]                                                  
cTagProt		:=	aConfig[oBrwSM0:nAT][48]; oCBoxE21:Refresh()
cDescFor		:=	aConfig[oBrwSM0:nAT][49]; oCBoxE31:Refresh()
cDescEmp		:=	aConfig[oBrwSM0:nAT][50]; oCBoxE41:Refresh()
cTamDFor		:=	aConfig[oBrwSM0:nAT][51]; oGetE31:Refresh()
cTamDEmp		:=	aConfig[oBrwSM0:nAT][52]; oGetE41:Refresh()


oSay1NomeFil:Refresh()
oSay2NomeFil:Refresh()
oSay3NomeFil:Refresh()
oSay4NomeFil:Refresh()

cConect :=    ''
lTesteE	:=	.F.
lTesteR	:=	.F.
oOkConect:Hide()
oNoConect:Hide()
oBtnTest:Refresh()


oGet18:SetColor(CLR_BLACK,IIF(cTpMail=='IMAP',CLR_WHITE, CLR_HGRAY ))
IIF(cTpMail=='IMAP',oGet18:Enable(),oGet18:Disable())
oGet18:Refresh()

IIF(lSegura,(oCBox12b:Show(),oCBox12c:Show()),(oCBox12b:Hide(),oCBox12c:Hide()) )
oCBox12b:Refresh()
oCBox12c:Refresh()
oDlgSM0:Refresh()

Return()
***********************************************************************
Static Function GravaConfig()
***********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATUALIZA ARQUIVO DE CONFIGURACAO (ZXM_CFG.DBF)                         ³
//³ Chamada -> TelaConfig()                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()    //    EMPRESA+FILIAL
For nX:=1 To Len(aConfig)
	If DbSeek(aConfig[nX][01]+aConfig[nX][03],.F.)
		RecLock('TMPCFG',.F.)
			//	[Config.Empresa]                   
			TMPCFG->PATH_XML	:=	AllTrim(aConfig[nX][37])
			TMPCFG->SER_TRANSF	:=	AllTrim(aConfig[nX][31])
			TMPCFG->PRE_DOC		:=	AllTrim(aConfig[nX][32])
			TMPCFG->SEM_XML		:=	AllTrim(aConfig[nX][41])
			TMPCFG->GRV_DIF_A	:=	AllTrim(aConfig[nX][42])
			TMPCFG->PROB_EMAIL	:=	AllTrim(aConfig[nX][38])
			TMPCFG->FOR_CANC	:=	AllTrim(aConfig[nX][39])
			TMPCFG->DOMINIO		:=	AllTrim(aConfig[nX][40])
			TMPCFG->PROB_EMAIL	:=	AllTrim(aConfig[nX][38])
			TMPCFG->EMP_ATIVA 	:=	AllTrim(aConfig[nX][46])
			TMPCFG->ESPECIE   	:=	AllTrim(aConfig[nX][47])

	
			//	Config.XML Fornecedor]
			TMPCFG->NFE_9DIG	:=	AllTrim(aConfig[nX][29])
			TMPCFG->SER_3DIG	:=	AllTrim(aConfig[nX][30])
			
			// [Config.e-mail]
			TMPCFG->AUTENTIFIC	:=	aConfig[nX][35]
			TMPCFG->SEGURA		:=	aConfig[nX][43]
			TMPCFG->PATCHTABLE	:=	AllTrim(aConfig[nX][23])
			TMPCFG->TIPOEMAIL	:=	AllTrim(aConfig[nX][22])
			TMPCFG->EMAIL		:=	AllTrim(aConfig[nX][24])
			TMPCFG->SENHA		:=	AllTrim(aConfig[nX][25])
			TMPCFG->PASTA_ORIG	:=	AllTrim(aConfig[nX][26])
			TMPCFG->PASTA_DEST	:=	AllTrim(aConfig[nX][27])
			TMPCFG->SERVERENV	:=	AllTrim(aConfig[nX][28])
			TMPCFG->SERVERREC	:=	AllTrim(aConfig[nX][45])
			TMPCFG->PORTA_REC	:=	AllTrim(aConfig[nX][34])
			TMPCFG->PORTA_ENV	:=	AllTrim(aConfig[nX][33])
			TMPCFG->SSL 		:=	aConfig[nX][36]
			TMPCFG->TLS    		:=	aConfig[nX][44]
			
			// [Config.Extra]
			TMPCFG->TAGPROT		:=	aConfig[nX][48]
			TMPCFG->DESCFOR		:=	aConfig[nX][49]
			TMPCFG->DESCEMP		:=	aConfig[nX][50]
			TMPCFG->TAMDFOR		:=	aConfig[nX][51]
			TMPCFG->TAMDEMP		:=	aConfig[nX][52]

		MsUnLock()
	Endif
   DbSelectArea('TMPCFG');DbGoTop()
Next

Return()
***********************************************************************
Static Function TestConect()
***********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TESTA SE CONFIGURACAO DE EMAIL, SENHA, SERVIDOR ESTAO CORRETAS         ³
//³ Chamada -> TelaConfig()                                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cRetorno    :=	''
nNumMsg		:=	0
nConecTou   :=  0

cTpConexao	:=	AllTrim(aConfig[oBrwSM0:nAT][22])   
lAutent		:=	aConfig[oBrwSM0:nAT][35]
lSegura		:=	aConfig[oBrwSM0:nAT][43] 
lSSL		:=	aConfig[oBrwSM0:nAT][36] 
lTLS 		:=	aConfig[oBrwSM0:nAT][44]

oServer    :=    TMailManager():New()

If lSegura .And. lTesteR
	oServer:SetUseSSL(lSSL)					//		Define o envio de e-mail utilizando uma comunicação segura através do SSL - Secure Sockets Layer.
	oServer:SetUseTLS(lTLS)					//		Define no envio de e-mail o uso de STARTTLS durante o protocolo de comunicação.
EndIf	

							//	SERVER RECEBIMENTO,	 SERVER ENVIO	   ,		EMAIL		  ,	    SENHA	  	  , PORTA RECEBIMENTO  ,  PORTA ENVIO
nConfig    :=    oServer:Init( AllTrim(cServerRec), AllTrim(cServerEnv), AllTrim(cEmail), AllTrim(cPassword), IIF(lTesteR, Val(cPortRec),), Val(cPortEnv) )

If lAutent .And. lTesteE
	oServer:SMTPAuth(oServer:GetUser(), AllTrim(cPassword))
EndIf


If lTesteE
	nTimeConect	:=	 IIF(oServer:GetSMTPTimeOut()!=0, oServer:GetSMTPTimeOut(), 60 )
	oServer:SetSMTPTimeout(nTimeConect)  
Else
	nTimeConect	:=	 IIF(oServer:GetPOPTimeOut()!=0, oServer:GetPOPTimeOut(), 60 )
	oServer:SetPOPTimeout(nTimeConect)
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	CONEXAO DE ENVIO == SMTP      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lTesteE
	nConecTou    :=    oServer:SmtpConnect()  
Else

	If cTpConexao == 'IMAP'
	   nConecTou    :=    oServer:IMAPConnect()
	ElseIf Left(cTpConexao,3) == 'POP'
	   nConecTou    :=    oServer:PopConnect()
	ElseIf cTpConexao == 'MAPI'
	     nConecTou    :=    oServer:ImapConnect()
	ElseIf cTpConexao == 'SMTP'  
	     nConecTou    :=    oServer:SmtpConnect()  
	Else
		MsgAlert('NÃO IDENTIFICADO O TIPO DE PROTOCOLO DE E-MAIL.  ' + cTpConexao  )
	EndIf
EndIf  

If lTesteR
	nRet := oServer:GetNumMsgs(@nNumMsg)
	//Alert( oServer:GetErrorString(nRet) +ENTER+ 'NUM. Msg: '+AllTrim(Str(nNumMsg)))
EndIf

   

#IFDEF WINDOWS
   If nConectou == 0
       If cTpConexao == 'IMAP'
           oServer:SmtpDisconnect()
       ElseIf Left(cTpConexao,3) == 'POP'
           oServer:PopDisconnect()
       ElseIf cTpConexao == 'MAPI'
             oServer:ImapDisconnect()
       ElseIf cTpConexao == 'SMTP'
             oServer:SmtpDisconnect()
       EndIf
       cRetorno    +=    'Conectado com Sucesso'
   Else
       cRetorno    +=    'ERRO: '+ Alltrim(oServer:GetErrorString(nConecTou))
   EndIf
#ELSE
   If nConectou == 0 .And. cTpConexao != 'MAPI'
       If cTpConexao == 'IMAP'
           oServer:SmtpDisconnect()
       ElseIf Left(cTpConexao,3) == 'POP'
           oServer:PopDisconnect()
       ElseIf cTpConexao == 'SMTP'
             oServer:SmtpDisconnect()   
       EndIf
       cRetorno    +=    'Conectado com Sucesso'
   ElseIf nConecTou == 1 .And. cTpConexao == 'MAPI'
         oServer:ImapDisconnect()
       cRetorno    +=    'Conectado com Sucesso.'
   Else
       cRetorno    +=    'ERRO: '+ Alltrim(oServer:GetErrorString(nConecTou))
   EndIf
#ENDIF

Return(cRetorno)
*****************************************************************
User Function Visual_XML()    //    [3.0]
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE XML NO BROSWER                ³
//³ Chamada -> Rotina Visualizar       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local   aArea3		:= GetArea()
Local   lRetorno	:=	.F.
Local	lValidDlg	:=	.T.
Local	aEditCpo	:=	{}                                                                                                                              

Private	aMyHeader	:=  {}
Private aMyCols    	:=  {}
Private aProdxFor   :=  {}
Private lGravado    := 	.F.
Private nTotalNFe   :=	0
Private cPreDoc    	:= 	''
Private cXMLStatus  :=	''
Private aClixFor	:=	{}
Private cMsgDevRet 	:= ''
Private aPCxItem	:=	{}

PRIVATE aHeader 	:=	{}
PRIVATE aCols   	:=	{}
PRIVATE cTipo  		:=	'N'
PRIVATE cA100For	:= 	ZXM->ZXM_FORNEC
PRIVATE cLoja    	:=	ZXM->ZXM_LOJA
PRIVATE cNFiscal	:=	IIF(ZXM->ZXM_FORMUL!='S', ZXM->ZXM_DOC,   ZXM->ZXM_DOCREF )
PRIVATE cSerie    	:= 	IIF(ZXM->ZXM_FORMUL!='S', ZXM->ZXM_SERIE, ZXM->ZXM_SERREF )
PRIVATE cEspecie	:=	'SPED'
PRIVATE cFormul   	:=	IIF(ZXM->ZXM_FORMUL=='S', 'S', 'N')
PRIVATE cCondicao 	:= 	''
PRIVATE cForAntNFE	:= 	''
PRIVATE dDEmissao	:= 	dDataBase
PRIVATE n			:= 	1
PRIVATE nMoedaCor	:= 	1
PRIVATE L103AUTO 	:=	.F.
PRIVATE lConsLoja	:= .F.

Static lNFeDev 	 	:=  .F.
Static lImportacao	:=	.F.

Static aXMLOriginal	:= 	{}
Static cTpFormul 	:= 	''


SetPrvt('oDlgV','oGrp1','oSay7','oSay10','oSay8','oSay9','oSay11','oSay12','oSay13','oSay14','oSay15','oSay16','oSay17')
SetPrvt('oSay18','oGrp2','oSayNF','oSayNFSeri','oSay1','oSay2','oSay3','oSay4','oSay5','oSay6','oSay71','oSay8','oGrp3')
SetPrvt('oBtn1','oBtn2','oBtn6SA1','oBtn4SA1','oBtn4SA2','oBtn4SA2','oBtnPreDoc','oBtn5','oSayF6','oSayStatus','oBrwV','oBtnPC')
SetPrvt('oSayDevRet')

oFont1    := TFont():New( "Arial",0,IIF(nHRes<=800,-12,-13),,.T.,0,,700,.F.,.F.,,,,,, )
oFont2    := TFont():New( "Arial",0,IIF(nHRes<=800,-14,-16),,.T.,0,,700,.F.,.F.,,,,,, )
oFont3    := TFont():New( "Arial",0,IIF(nHRes<=800,-17,-19),,.T.,0,,700,.F.,.F.,,,,,, )
oFont0    := TFont():New( "Arial",0,IIF(nHRes<=800,-09,-11),,.F.,0,,400,.F.,.F.,,,,,, )
oFontP    := TFont():New( "Arial",0,IIF(nHRes<=800,-08,-10),,.F.,0,,400,.F.,.F.,,,,,, )
oFontP2   := TFont():New( "Arial",0,IIF(nHRes<=800,-10,-12),,.F.,0,,400,.F.,.F.,,,,,, )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  ABRE ARQUIVO DE CONFIGURACAO   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select('TMPCFG') == 0
   If Empty(cArqConfig)
   		cArqConfig	:=	'ZXM_CFG.DBF'
		cIndConfig	:=	'TMPCFG.CDX'
   EndIf
   DbUseArea(.T.,,_StartPath+cArqConfig, 'TMPCFG',.T.,.F.)
   DbSetIndex(_StartPath+cIndConfig)
EndIf

DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()
If DbSeek(cEmpAnt+cFilAnt, .F.)
   cPreDoc    :=    TMPCFG->PRE_DOC
EndIf


//	aMyHeader = CABEC do MsNewGetDados
DbSelectArea('SX3');DbSetOrder(2);DbGoTop()
DbSeek('D1_ITEM'); 	Aadd(aMyHeader,{ 'Item  ',           X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, '', X3_USADO, X3_TIPO, X3_F3      })

DbSeek('C7_PRODUTO'); 	Aadd(aMyHeader,{ 'Prod.Fornec',      X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, '', X3_USADO, X3_TIPO, X3_F3      })	                                  
If TMPCFG->DESCFOR == 'SIM'			//	DESCRICAO PRODUTO FORNECEDOR - XML
	DbSeek('B1_DESC'); 	Aadd(aMyHeader,{ Trim(X3_TITULO)+' Fornec',    AllTrim(X3_CAMPO)+'FOR', X3_PICTURE, Val(TMPCFG->TAMDFOR), X3_DECIMAL, '', X3_USADO, X3_TIPO, X3_F3      })
EndIf

DbSeek('D1_COD'); 	Aadd(aMyHeader,{ Trim(X3_TITULO)+'-'+TMPCFG->NOME_EMP,  X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, 'Vazio().Or.ExistCpo("SB1")', X3_USADO, X3_TIPO, 'SB1' })

If TMPCFG->DESCEMP == 'SIM'			//	DESCRICAO PRODUTO EMPRESA
	DbSeek('D1_DESCRI'); 	Aadd(aMyHeader,{ Trim(X3_TITULO)+'-'+TMPCFG->NOME_EMP,  X3_CAMPO, X3_PICTURE, Val(TMPCFG->TAMDEMP), X3_DECIMAL, '', X3_USADO, X3_TIPO, X3_F3  })
EndIf

//	Campos para EDICAO do MsNewGetDados
Aadd( aEditCpo,	'D1_COD')	


//	aMyHeader == TODO O SX3 DO SD1 - BUSCA TODOS OS CAMPOS DO SD1
DbSelectArea('SX3');DbSetOrder(1);DbGoTop()
DbSeek('SD101', .F.) 
Do While !Eof() .And. SX3->X3_ARQUIVO == 'SD1'
    If 	!(AllTrim(SX3->X3_CAMPO) $ 'D1_FILIAL#D1_ITEM#D1_COD') .And. AllTrim(SX3->X3_CAMPO) != 'D1_DESCR' .And.;
		  X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		
		If ( cPreDoc == 'PRE' .And. AllTrim(SX3->X3_CAMPO) $ 'D1_TES#D1_CF#D1_OPER' )
			// NAO MOSTRA NO HEADER
		Else
		
			Aadd(aMyHeader,{ Trim(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE,;
							  SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3 })
						  
			Aadd( aEditCpo,	AllTrim(SX3->X3_CAMPO))			// CAMPOS PARA EDICAO NO MSNEWGETDADOS
		
		EndIf
		
	EndIf
	
	DbSkip()
EndDo


DbSelectArea('ZXM')

   ***************************************************************************************
       Processa ({|| CarregaACols()  },'Aguarde Carregando XML',  'Processando...', .T.)    //    [3.1]
   ***************************************************************************************



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	VERIFICA STATUS DO XML IMPORTADO           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea('ZXM')
Do Case
	Case ZXM->ZXM_SITUAC == 'C'
	   cXMLStatus    :=    'Status XML: CANCELADO NA SEFAZ'
	Case ZXM->ZXM_STATUS == 'G'
	       cXMLStatus    :=  'Status XML:' +IIF(lGravado, IIF(cPreDoc=='PRE',"PRÉ NOTA","DOC.ENTRADA")+"  GRAVADO", '')
	Case ZXM->ZXM_STATUS == 'I'
	       cXMLStatus    :=    'Status XML: IMPORTADO'
	Case ZXM->ZXM_STATUS == 'X'
	       cXMLStatus    :=    'Status XML: CANCELADO'
	Case ZXM->ZXM_STATUS == 'R'
	       cXMLStatus    :=    'Status XML: RECUSADO'
	Case Empty(ZXM->ZXM_SITUAC)
		cXMLStatus    :=    'Status XML inválido. Não houve retorno da SEFAZ.
EndCase



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	                      TELA PRINCIPAL - VISUALIZACAO             		| 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                            //   L1     C1      L2     C2
oDlgV      := MSDialog():New( D(090),D(300),D(545),D(1313),"XML Fornecedor",,,.F.,,,,,,.T.,,oFont0,.T. )

***************************
	AtuClixFor()
***************************
               
oGrp1      := TGroup():New( D(004),D(008),D(060),D(247),"",oDlgV,CLR_BLACK,CLR_WHITE,.T.,.F.	)
oSay71     := TSay():New( D(020),D(012),{|| aClixFor[1] },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(144),D(008)  )		// [ ImpXmlNFe II ]
oSay14     := TSay():New( D(038),D(054),{|| aClixFor[5]	},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(160),D(008) )

oSay10     := TSay():New( D(020),D(054),{|| aClixFor[2] },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(136),D(008) )

oSay8      := TSay():New( D(011),D(012),{|| "Código:" },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(032),D(008) )
oSay9      := TSay():New( D(011),D(054),{|| aClixFor[3] },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(052),D(008) )
oSay11     := TSay():New( D(029),D(012),{|| "CNPJ:" },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(032),D(008) )
oSay12     := TSay():New( D(029),D(054),{|| aClixFor[4] 	},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008) )
oSay13     := TSay():New( D(038),D(012),{|| "Endereço:" },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(040),D(008) )
oSay14     := TSay():New( D(038),D(054),{|| aClixFor[5]	},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(160),D(008) )
oSay15     := TSay():New( D(048),D(012),{|| "Cidade:" },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(032),D(008) )
oSay16     := TSay():New( D(048),D(054),{|| aClixFor[6] },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oSay17     := TSay():New( D(048),D(180),{|| "Fone:" },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(024),D(008) )
oSay18     := TSay():New( D(048),D(200),{|| aClixFor[7] },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(062),D(008) )



oGrp2      := TGroup():New( D(004),D(252),D(060),D(505),"",oDlgV,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayNF     := TSay():New( D(012),D(260),{|| "Nota Fiscal:"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(060),D(012) )
oSayNFSeri := TSay():New( D(012),D(320),{|| ZXM->ZXM_DOC +' - '+ ZXM->ZXM_SERIE},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(150),D(012) )

oSayNNFRef := TSay():New( D(021),D(260),{|| IIF(ZXM->ZXM_FORMUL == 'S',"NF Referência:",'')},oGrp2,,oFontP2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(060),D(012) )
oSaySNFRef := TSay():New( D(021),D(320),{|| IIF(ZXM->ZXM_FORMUL == 'S',PadL(ZXM->ZXM_DOCREF, TamSx3('F1_DOC')[1],'') +' - '+ PadL(ZXM->ZXM_SERREF, TamSx3('F1_SERIE')[1],''),'')},oGrp2,,oFontP2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(150),D(012) )

oSay1      := TSay():New( D(014),D(397),{|| "Emissão:"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(040),D(008) )
oSay2      := TSay():New( D(014),D(421),{|| StoD(cDataNFe)  },oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(052),D(008) )

oSay3      := TSay():New( D(027),D(260),{|| "Total:"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(035),D(023) )
oSay4      := TSay():New( D(027),D(320),{|| "R$ "+Transform( nTotalNFe, '@E 999,999,999.99') },oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(150),D(012) )
oSay5      := TSay():New( D(039),D(260),{|| "Nat.Operação:"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(052),D(008) )
oSay6      := TSay():New( D(039),D(320),{|| cNatOper },oGrp2,,oFont1,.F.,.F.,.F.,.T.,IIF(lNFeDev,CLR_HRED, CLR_BLACK),CLR_WHITE,D(170),D(008) )
oSay7      := TSay():New( D(048),D(260),{|| "Chave:"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(052),D(008) )
oSay8      := TSay():New( D(048),D(320),{|| ZXM->ZXM_CHAVE},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(170),D(008) )



oBtn1      := TButton():New( D(064),D(008),"Visualizar XML",oDlgV, {|| View_XML()	}, D(045),D(014),,oFont0,,.T.,,"Visualiza XML no Broswer",,,,.F. )
oBtn2      := TButton():New( D(064),D(055),"Mensagem Nota",oDlgV,  {|| MsgInfCpl()}, D(045),D(014),,oFont0,,.T.,,"Mensagem da Nota Fiscal",,,,.F. )

nDif := (055-008) // 47
nCol :=  055 + nDif

oBtn6SA2     := TButton():New( D(064),D(nCol),"Hist.Fornecedor",oDlgV,{|| HistFornec()},D(045),D(014),,oFont0,,.T.,,"Histórico do Fornecedor",,,,.F. )
oBtn6SA1     := TButton():New( D(064),D(nCol),"Posição Cliente",oDlgV,{|| a450F4Con() },D(045),D(014),,oFont0,,.T.,,"Posição Cliente",,,,.F. )

nCol +=  nDif
	
oBtn4SA2   := TButton():New( D(064),D(nCol),"Cad."+"Fornecedor",oDlgV, {|| MostraCadFor(SA2Recno) },D(045),D(014),,oFont0,,.T.,,"Cadastro Fornecedor",,,,.F. )
oBtn4SA1   := TButton():New( D(064),D(nCol),"Cad."+"Cliente",oDlgV, {|| MostraCadCli(SA2Recno) },D(045),D(014),,oFont0,,.T.,,"Cadastro Cliente",,,,.F. )

If !lNFeDev
	oBtn6SA2:Show()
	oBtn6SA1:Hide()
	oBtn4SA2:Show()
	oBtn4SA1:Hide()
EndIf

nCol +=  nDif
oBtnPC     := TButton():New( D(064),D(nCol),"Item Ped.Compras",oDlgV, {|| SelItemPC() },D(045),D(014),,oFont0,,.T.,,"Item Pedido de Compras - Item - F6 ",,,,.F. )
nCol +=  nDif
oBtnReplic := TButton():New( D(064),D(nCol),"Replicar Produtos",oDlgV,{|| ReplicaProd('PROD')},D(045),D(014),,oFont0,,.T.,,"Replica para os itens selecionados um único Produto - F7 ",,,,.F. )
nCol +=  nDif

oBtnPreDoc := TButton():New( D(064),D(nCol),IIF(cPreDoc=='PRE',"Pré Nota","Doc.Entrada") , oDlgV, {|| IIF(lGravado, VisualNFE(), IIF(GeraPreDoc(), AtuPreDoc(), ) ) , VerifStatus() },D(045),D(014),,oFont0,,.T.,,"Gera "+IIF(cPreDoc=='PRE',"Pré Nota","Doc.Entrada"),,,,.F. )
//oBtnPreDoc := TButton():New( D(064),D(nCol),IIF(cPreDoc=='PRE',"Pré Nota","Doc.Entrada") , oDlgV, {|| CARGA_ACOLS() ,U_MT140TOK(), IIF(lGravado, VisualNFE(), IIF(GeraPreDoc(), AtuPreDoc(), ) ) , VerifStatus() },D(045),D(014),,oFont0,,.T.,,"Gera "+IIF(cPreDoc=='PRE',"Pré Nota","Doc.Entrada"),,,,.F. )

oBtn5      := TButton():New( D(064),D(460),"&Sair",oDlgV,{|| oDlgV:End() },D(045),D(014),,oFont0,,.T.,,"",,,,.F. )

Do Case
	Case ZXM->ZXM_STATUS == 'G'
	   oSayStatus:= TSay():New( D(082),D(013),{|| cXMLStatus },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,D(120),D(008) )
	Case ZXM->ZXM_STATUS == 'I'.And. ZXM->ZXM_SITUAC == 'A'
	   oSayStatus:= TSay():New( D(082),D(013),{|| cXMLStatus },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(100),D(008) )
	OtherWise
	   oSayStatus:= TSay():New( D(082),D(013),{|| cXMLStatus },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,D(100),D(008) )
EndCase


cMsgF6	:=  IIF(ZXM->ZXM_STATUS$'I' , 'F6 - Seleciona PC.' , '')
cMsgF7	:=  IIF(ZXM->ZXM_STATUS$'I' , 'F7 - Replica Prod.' , '')
cMsgF8	:=  IIF(ZXM->ZXM_STATUS$'I' , 'F8 - Alterar Almox.', '')
cMsgF9	:=  IIF(ZXM->ZXM_STATUS$'I' .And. cPreDoc == 'DOC', 'F9 - Replica TES.  ', '')
cMsgF10	:=  'F10 - Doc.Original' //IIF(ZXM->ZXM_STATUS$'I' .And. lNFeDev, 'F10 - Doc.Original', '')

If Empty(cMsgDevRet) .And. !Empty(ZXM->ZXM_TIPO)
	Do Case
		Case ZXM->ZXM_TIPO ==  'N'
	  		cMsgDevRet	:=	'  Tipo Nota: Normal'
	 	Case ZXM->ZXM_TIPO == 'D'
	 		cMsgDevRet	:=	'  Tipo Nota: Devolução'
	 	Case ZXM->ZXM_TIPO ==  'B'
	 		cMsgDevRet	:=	'  Tipo Nota: Beneficiamento'
	 	Case ZXM->ZXM_TIPO ==  'I'
	 		cMsgDevRet	:=	'  Tipo Nota: Compl. ICMS' 				
	 	Case ZXM->ZXM_TIPO == 'P'
	 		cMsgDevRet	:=	'  Tipo Nota: Compl. IPI' 				
	 	Case ZXM->ZXM_TIPO == 'C'
	 		cMsgDevRet	:=	'  Tipo Nota: Compl. Preço/Frete'
 	EndCase        
 	
 	cMsgDevRet += IIF(lImportacao,' - Importação','')
 	
EndIf 		      

		 		
oSayPedCom 	:= TSay():New( D(082),D(184),{|| cMsgF6 },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,D(120),D(008))
oSayReplic 	:= TSay():New( D(082),D(228),{|| cMsgF7 },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,D(120),D(008))
oSayLocal	:= TSay():New( D(082),D(278),{|| cMsgF8 },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,D(120),D(008))
oSay_TES 	:= TSay():New( D(082),D(328),{|| cMsgF9 },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,D(120),D(008))
oSayNFOrig	:= TSay():New( D(082),D(378),{|| cMsgF10 },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,D(120),D(008))
oSayDevRet	:= TSay():New( D(082),D(415),{|| cMsgDevRet },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,D(120),D(008))
                                                               

                               // L1     C1      L2     C2
oGrp3      := TGroup():New( D(080),D(008),D(224),D(505/*495*/),"",oDlgV,CLR_BLACK,CLR_WHITE,.T.,.F. )

oBrwV := MsNewGetDados():New( D(087),D(012),D(220),D(500),GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','+D1_ITEM',aEditCpo,0,999,,'','AllwaysTrue()',oGrp3,aMyHeader,aMyCols )
oBrwV:oBrowse:BDelOk  := {|| DelLnPC() } // APENAS DELETA ITENS ADICIONADO ATRAVES DE UM PEDIDO DE COMPRA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE EXISTE NO SA5 PROD.FORNECEDOR     ³
//| aProdxFor=Array com ProdutoxFornecedor        |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
bSavDblClick :=	oBrwV:oBrowse:bLDblClick
oBrwV:oBrowse:bLDblClick 	:=	{|| PreDocRefresh(),  VerifStatus(), ViewTrigger(oBrwV:NAT, oBrwV:oBrowse:ColPos), DadosSB1(), AtuCFOP(), GravaZXP(), oBrwV:Editcell(), oBrwV:oBrowse:Refresh() }
oBrwV:oBrowse:bEditCol		:= 	{|| PreDocRefresh(),  VerifStatus(), ViewTrigger(oBrwV:NAT, oBrwV:oBrowse:ColPos), DadosSB1(), AtuCFOP(), GravaZXP(), oBrwV:oBrowse:Refresh() }
//oBrwV:oBrowse:bDrawSelect 	:= 	{|| IIF(oBrwV:oBrowse:ColPos == aScan(aMyHeader,{|x| Alltrim(x[2]) == 'D1_TES'}) , AtuCFOP(), oBrwV:oBrowse:Refresh()) }
oBrwV:oBrowse:bDrawSelect 	:= 	{|| AtuCFOP(), oBrwV:oBrowse:Refresh() }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO CHAMA PONTOS DE ENTRADA CASO PE ESTAJA COMPILADO 	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oBrwV:oBrowse:bDrawSelect  :=	{|| CheckingPE()  }


oBrwV:oBrowse:SetFocus()
oBrwV:oBrowse:Refresh()

oDlgV:Activate(,,,.T.,{|| IIF(!lValidDlg,oDlgV:End(),)},, {|| VerifStatus(), IIF((!Empty(ZXM->ZXM_TIPO).Or.lNFeDev.Or.lImportacao), (lOpRet:= OpcaoRetorno(), IIF(!lOpRet,oDlgV:End(),) ), ) } )	// OpcaoRetorno() = Tela onde user define qual o tipo de retorno

	  
RestArea(aArea3)
Return()
************************************************************
Static Function AtuCFOP()
************************************************************
nPosProd  	:=	aScan(aMyHeader,{|x| Alltrim(x[2]) == 'D1_COD'  })
nPosTES		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 'D1_TES'  })
nPosCF		:=	aScan(aMyHeader,{|x| Alltrim(x[2]) == 'D1_CF'	 })
nPosSit		:= 	Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_CLASFIS'})
                                                                  
If oBrwV:oBrowse:ColPos == nPosTES

	cTes 	 	:= 	oBrwV:aCols[oBrwV:NAT][nPosTES]
	cCFOP 	 	:= 	oBrwV:aCols[oBrwV:NAT][nPosCF]
	
	lPoder3Dev	:=	.F.
	
	If nPosTES > 0 	//TMPCFG->PRE_DOC == 'DOC.ENTRADA'
	
		// VERIFICA SE ALGUMA TES CONTEM PODER3 == DEVOLUCAO
		For _nX := 1 To Len(oBrwV:aCols)
		    If AllTrim(Posicione("SF4",1,xFilial("SF4")+oBrwV:aCols[_nX][nPosTES],"F4_PODER3")) == 'D' 
				lPoder3Dev := .T.
				Exit
			EndIf
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ oBrwV:oBrowse:ColPos = POSICAO EM QUE SE ENCONTRA NO aCols  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If oBrwV:oBrowse:ColPos == nPosTES .And. !Empty(cTes)
		
				//	HABILITA F10 - Doc.original 
				IF ZXM->ZXM_STATUS $ 'I' .And. lNFeDev.Or.lPoder3Dev
					cMsgF10	:=  'F10 - Doc.Original'
					oSayNFOrig	:= TSay():New( D(082),D(378),{|| cMsgF10 },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,D(120),D(008))
					
					oSayNFOrig:Refresh()
					oSayDevRet:Refresh()
				
		        
		        Else   
		        	If Type("oSayNFOrig") == "O"
		        		FreeObj(oSayNFOrig)  // DESTROI OBJETO F10
		        	EndIf
		        EndIf
		        
		
				VerifStatus()	//	HABILITA O F10 PARA PROCURA DO DOC.ORIGEM
		
				
				MaAvalTes("E",cTes ) //M->D1_TES)
				MaFisRef("IT_TES","MT100", cTes) //M->D1_TES)
				oBrwV:aCols[oBrwV:NAT][nPosCF] := Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")


			cSitTrib := '' 
			cSitTrib += Left(AllTrim(Posicione('SB1', 1, xFilial("SB1") + oBrwv:aCols[oBrwV:NAT][nPosProd], 'B1_ORIGEM')),1)
			cSitTrib += AllTrim(Posicione('SF4',1,xFilial('SF4')+oBrwv:aCols[oBrwV:NAT][nPosTES],'F4_SITTRIB'))
			oBrwv:aCols[oBrwV:NAT][nPosSit] := cSitTrib


				oBrwV:oBrowse:Refresh()
	
		EndIf
		
	EndIf

EndIf

Return()
************************************************************
Static Function DadosSB1()
************************************************************
nPosProd  	:=	aScan(aMyHeader,{|x| Alltrim(x[2]) == "D1_COD" })
cProduto  	:= 	oBrwV:aCols[oBrwV:NAT][nPosProd]

nPosALM		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_LOCAL'	})
cArmazem    := oBrwV:aCols[oBrwV:NAT][nPosALM]
			
nPosTES		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_TES' 	})
nPosCF		:=	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_CF' 	})
nPosCTA		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_CONTA'	})
nPosCUS		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_CC'  	})
nPosPC		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_PEDIDO'	})
nPosIPC		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_ITEMPC'	})
nPosDesc	:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'B1_DESC'	})	//	DESCRICAO PRODUTO EMPRESA
nPosSit		:= 	Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_CLASFIS'})

nPosItem	:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_ITEM' 	})  
cItem	  	:= 	oBrwV:aCols[oBrwV:NAT][nPosItem]

nPosUM		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_UM'  	})
nPosQtd		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_QUANT'	})
nPSegUM		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_SEGUM'	})
nPQtdSeg	:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_QTSEGUM'})

nPB1Conv	:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'B1_CONV'  	})
nPB1Fator	:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'B1_TIPCONV'})

nPosVlr		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_VUNIT' 	})
nPosTot		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_TOTAL' 	})

				
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ oBrwV:oBrowse:ColPos = POSICAO EM QUE SE ENCONTRA NO aCols  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If oBrwV:oBrowse:ColPos == nPosProd

	SB1->(DbGoTop(), DbSetOrder(1))
	If SB1->(DbSeek(xFilial('SB1') + cProduto ,.F.) )
                
	    cAlmox 	:= 	IIF(!Empty(SB1->B1_LOCPAD),	AllTrim(SB1->B1_LOCPAD), 	Space(TamSx3('B1_LOCPAD')[1]) 	)	//	Local Padrao 
	    cTes	:= 	IIF(!Empty(SB1->B1_TE), 	AllTrim(SB1->B1_TE), 		Space(TamSx3('B1_TE')[1]) 		)	//	Codigo de Entrada padrao
	    cCtaCont:= 	IIF(!Empty(SB1->B1_CONTA), AllTrim(SB1->B1_CONTA), 	Space(TamSx3('B1_CONTA')[1]) 	)	//	Conta Contabil dn Prod.
		cCCusto	:=	IIF(!Empty(SB1->B1_CC), 	AllTrim(SB1->B1_CC), 		Space(TamSx3('B1_CC')[1]) 		)	//	Centro de Custo
		cUnidade:=	IIF(!Empty(SB1->B1_UM), 	AllTrim(SB1->B1_UM), 		Space(TamSx3('B1_UM')[1]) 		)	//	Primeira Unidade de Medida
		cSegUnid:=	IIF(!Empty(SB1->B1_SEGUM), 	AllTrim(SB1->B1_SEGUM), 	Space(TamSx3('B1_SEGUM')[1])	)	//	Segunda Unidade de Medida
		nFatConv:=	SB1->B1_CONV
		cTipConv:=	IIF(!Empty(SB1->B1_TIPCONV),AllTrim(SB1->B1_TIPCONV), 	Space(TamSx3('B1_TIPCONV')[1]) 	)	//	Tipo de Conversao da UM   - M=Multiplicador;D=Divisor
        
        DbSelectArea('SB2');DbSetOrder(1);DbGoTop()        
		If !DbSeek(xFilial('SB2')+PadR(cProduto,  TamSx3('B1_COD')[1], '' )+cAlmox, .F.)
	    	A103Alert(cProduto, cAlmox, .F.)
        EndIf


       	DbSelectArea('SB1')                  
       	
		oBrwV:aCols[oBrwV:NAT][nPosProd]:=	PadR(cProduto, TamSx3('B1_COD')[01],'')
		
		If nPosDesc > 0
			oBrwV:aCols[oBrwV:NAT][nPosDesc]:=	AllTrim(SB1->B1_DESC)
		EndIf

		
		/*
		If nPosUM > 0
		
			//	Aadd(aXMLOriginal, {nItemXML, Right(cProdFor, TamSx3('D1_COD')[1]), cDescrProd, cNCM, nQuant, nPreco } )
			nPosOri		:=	Ascan(aXMLOriginal, {|X| X[01] == cItem  }) //.And. X[02] == cProduto
			nQtdOrig	:=	aXMLOriginal[nPosOri][05]
			lConvSegUm 	:=	!Empty(cSegUnid) .And. !Empty(cTipConv) .And. nFatConv != 0
			
			If !lConvSegUm
				oBrwV:aCols[oBrwV:NAT][nPosQtd]	  :=  nQtdOrig
				oBrwV:aCols[oBrwV:NAT][nPosUM]   :=  cUnidade
				oBrwV:aCols[oBrwV:NAT][nPSegUM]  :=  cSegUnid
				oBrwV:aCols[oBrwV:NAT][nPQtdSeg] :=  0
				oBrwV:aCols[oBrwV:NAT][nPB1Conv]  :=  cTipConv
				oBrwV:aCols[oBrwV:NAT][nPB1Fator] :=  nFatConv
				//oBrwV:aCols[oBrwV:NAT][nPosTot]   :=  oBrwV:aCols[oBrwV:NAT][nPosQtd] * oBrwV:aCols[oBrwV:NAT][nPosVlr]
				MaFisRef("IT_QUANT","MT100",oBrwV:aCols[oBrwV:NAT][nPosQtd])
				
            Else
				// CONVERTE 1(XML) * 1.000 (B1_CONV)
				nQtdConv :=	0
				If cTipConv == 'D'			//	M=Multiplicador;D=Divisor
					nQtdConv :=	nQtdOrig * nFatConv
				Else
					nQtdConv :=	nQtdOrig / nFatConv
				EndIf
				
				oBrwV:aCols[oBrwV:NAT][nPosQtd]	  :=  nQtdConv
				oBrwV:aCols[oBrwV:NAT][nPosUM]   :=  cUnidade
				oBrwV:aCols[oBrwV:NAT][nPSegUM]  :=  cSegUnid
				oBrwV:aCols[oBrwV:NAT][nPQtdSeg] :=  nQtdOrig
				
				oBrwV:aCols[oBrwV:NAT][nPB1Conv]  :=  cTipConv
				oBrwV:aCols[oBrwV:NAT][nPB1Fator] :=  nFatConv
//				oBrwV:aCols[oBrwV:NAT][nPosTot]   :=  oBrwV:aCols[oBrwV:NAT][nPosQtd] * oBrwV:aCols[oBrwV:NAT][nPosVlr]
				MaFisRef("IT_QUANT","MT100",oBrwV:aCols[oBrwV:NAT][nPosQtd])
//				MaFisRef("IT_PRCUNI","MT100",M->D1_VUNIT)
//				MaFisRef("IT_VALMERC","MT100",M->D1_TOTAL)
				
            EndIf
            
		EndIf
        */

		If nPosALM > 0
			oBrwV:aCols[oBrwV:NAT][nPosALM]	:=	cAlmox
		EndIf
		

		If nPosTES > 0
		
			oBrwV:aCols[oBrwV:NAT][nPosTES]	:=	IIF(!Empty(oBrwV:aCols[oBrwV:NAT][nPosTES]), oBrwV:aCols[oBrwV:NAT][nPosTES], cTes)

			MaAvalTes("E",cTes ) //M->D1_TES)
			MaFisRef("IT_TES","MT100", cTes) //M->D1_TES)
			oBrwV:aCols[oBrwV:NAT][nPosCF] := Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")


			cSitTrib := '' 
			cSitTrib += Left(AllTrim(Posicione('SB1', 1, xFilial("SB1") + oBrwv:aCols[oBrwV:NAT][nPosProd], 'B1_ORIGEM')),1)
			cSitTrib += AllTrim(Posicione('SF4',1,xFilial('SF4')+oBrwv:aCols[oBrwV:NAT][nPosTES],'F4_SITTRIB'))
			oBrwv:aCols[oBrwV:NAT][nPosSit] := cSitTrib

			oBrwV:oBrowse:Refresh()			
		EndIf

		If nPosCTA > 0
			oBrwV:aCols[oBrwV:NAT][nPosCTA]	:=	cCtaCont
		EndIf
		If nPosCUS > 0
			oBrwV:aCols[oBrwV:NAT][nPosCUS]	:=	IIF(!Empty(oBrwV:aCols[oBrwV:NAT][nPosCUS]), oBrwV:aCols[oBrwV:NAT][nPosCUS], cCCusto)
		EndIf
	
	Else

		oBrwV:aCols[oBrwV:NAT][nPosProd]:=	PadR(cProduto, TamSx3('B1_COD')[01],'')
		
		If nPosDesc > 0
			oBrwV:aCols[oBrwV:NAT][nPosDesc]:=	Space(TamSx3('B1_DESC')[1])
		EndIf
		If nPosUM > 0
			oBrwV:aCols[oBrwV:NAT][nPosUM]:=	Space(TamSx3('B1_UM')[1])
		EndIf
		If nPosALM > 0
			oBrwV:aCols[oBrwV:NAT][nPosALM]	:=	Space(TamSx3('B1_LOCPAD')[1])
		EndIf
		If nPosTES > 0
			oBrwV:aCols[oBrwV:NAT][nPosTES]	:=	Space(TamSx3('B1_TE')[1])         		
		EndIf                                                         
		If nPosCTA > 0
			oBrwV:aCols[oBrwV:NAT][nPosCTA]	:=	Space(TamSx3('B1_CONTA')[1])
		EndIf
		If nPosCUS > 0
			oBrwV:aCols[oBrwV:NAT][nPosCUS]	:=	Space(TamSx3('B1_CC')[1])
		EndIf
		If nPosPC > 0
			oBrwV:aCols[oBrwV:NAT][nPosPC]	:=	Space(TamSx3('D1_PEDIDO')[1])
		EndIf
		If nPosIPC > 0
			oBrwV:aCols[oBrwV:NAT][nPosIPC]	:=	Space(TamSx3('D1_ITEMPC')[1])
		EndIf
			
	EndIf
	
	oBrwV:oBrowse:Refresh()

ElseIf oBrwV:oBrowse:ColPos == nPosALM

    DbSelectArea('SB2');DbSetOrder(1);DbGoTop()
	If !DbSeek(xFilial('SB2')+PadR(cProduto,  TamSx3('B1_COD')[1], '' )+cArmazem, .F.)
    	A103Alert(cProduto, cArmazem, .F.)
 	EndIf

  	DbSelectArea('SB1')
        
EndIf

Return()
************************************************************
Static Function CARGA_ACOLS()
************************************************************

aHeader 	:=	aMyHeader
aCols   	:=	oBrwV:aCols

RETURN
************************************************************
Static Function CheckingPE()
************************************************************
Local aRetorno := {}
Local xRet	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ P.E. Utilizado para chamar PE do Cliente	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF ExistBlock("ExecutaPE") 
	aRetorno := ExecBlock("ExecutaPE",.F.,.F.,)

	If 	ExistBlock(aRetorno[1])
		xRet := ExecBlock(aRetorno[1],.F.,.F.,)
	EndIf

Endif

Return(xRet)
************************************************************
Static Function ViewTrigger(nLin, nPosCampo)
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXECUTADO APOS CLICAR NO CAMPO.                                                			³
//³	oBrwV:oBrowse:bLDblClick	:=	{|| ... ViewTrigger(oBrwV:NAT, oBrwV:oBrowse:ColPos) }	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCampo := AllTrim(oBrwV:aHeader[nPosCampo][2])

DbSelectArea('SD1')
If ExistTrigger(cCampo) .And. Left(cCampo,2) == 'D1'  // VERIFICA SE EXISTE TRIGGER PARA ESTE CAMPO
	RunTrigger(2,nLin,Nil,,cCampo)
Endif	
               
Return()       
************************************************************
Static Function AtuClixFor()
************************************************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	lNFeDev - VARIAVEL VERIFICA SE Eh FORNECEDOR - ENTRADA NORMAL	|
//|								    OU CLIENTE   - DEVOLUCAO		|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !lNFeDev .And. !lImportacao

	// SA2->(DbSetOrder(3),DbGoTop(),DbSeek(xFilial('SA2')+ ZXM->ZXM_CGC, .F.) )
	// SA2Recno :=    SA2->(Recno())
       
	ForCliMsBlql('SA2', ZXM->ZXM_CGC, .F., ZXM->ZXM_FORNECE, ZXM->ZXM_LOJA)


	// TRANSFERENCIA
	If Left(TMPCFG->CNPJ, 08) == Left( ZXM->ZXM_CGC, 08)
		DbSelectArea('ZXM') 
		RecLock('ZXM',.F.)
			ZXM->ZXM_TIPO	:=	'N' 
			ZXM->ZXM_FORNEC	:=	SA2->A2_COD
			ZXM->ZXM_LOJA	:=	SA2->A2_LOJA
			If ZXM->(FieldPos("ZXM_NOMFOR")) > 0
				ZXM->ZXM_NOMFOR	:=	AllTrim(SA2->A2_NOME)
			EndIf
			If ZXM->(FieldPos("ZXM_UFFOR")) > 0
				ZXM->ZXM_UFFOR	:= SA2->A2_EST
			EndIf
		MsUnlock()
	EndIf


Else					//	DEVOLUCAO\RETORNO GRAVA FORNEC\LOJA e TIPO APOS USER SELECIONAR O TIPO [ NA ROTINA OpcaoRetorno ]	
       
	cTabela := IIF(ZXM->ZXM_TIPO $ 'D\B', 'SA1', 'SA2' )
  	*********************************************************************************
		ForCliMsBlql(cTabela, ZXM->ZXM_CGC, lImportacao, ZXM->ZXM_FORNECE, ZXM->ZXM_LOJA )
	*********************************************************************************
	SA2Recno := IIF(ZXM->ZXM_TIPO $ 'D\B', SA1->(Recno()), SA2->(Recno()) )

EndIf
         

If Empty(ZXM->ZXM_FORNEC).And.Empty(ZXM->ZXM_LOJA) .And. !lImportacao
	Aadd(aClixFor, "Fornec\Cli: ")	//	[1]
	Aadd(aClixFor, "") 				//	[2]
	Aadd(aClixFor, "")				//	[3]
	Aadd(aClixFor, Transform( IIF(!lNFeDev,SA2->A2_CGC,SA1->A1_CGC), IIF(IIF(!lNFeDev,Len(SA2->A2_CGC)==14,Len(SA1->A1_CGC)==14),'@R 99.999.999/9999-99','@R 999.999.999-99')) )		
	Aadd(aClixFor, "")				//	[5]
	Aadd(aClixFor, "")				//	[6]
	Aadd(aClixFor, "")				//	[7]
Else
	Aadd(aClixFor, IIF(!lNFeDev.Or.lImportacao, "Fornecedor: ", "Cliente: ") )
	Aadd(aClixFor, IIF(!lNFeDev.Or.lImportacao, SA2->A2_NOME, SA1->A1_NOME ) )
	Aadd(aClixFor, IIF(!lNFeDev.Or.lImportacao, (SA2->A2_COD +' - '+SA2->A2_LOJA), (SA1->A1_COD +' - '+SA1->A1_LOJA)) )
	Aadd(aClixFor, Transform( IIF(!lNFeDev.Or.lImportacao,SA2->A2_CGC,SA1->A1_CGC), IIF(IIF(!lNFeDev,Len(SA2->A2_CGC)==14,Len(SA1->A1_CGC)==14),'@R 99.999.999/9999-99','@R 999.999.999-99')) )
	Aadd(aClixFor, IIF(!lNFeDev.Or.lImportacao, (AllTrim(SA2->A2_END)+IIF(!Empty(SA2->A2_COMPLEM),'-'+SA2->A2_COMPLEM,'')+IIF(Empty(SA2->A2_NR_END),'',', '+SA2->A2_NR_END )), ;
															    (AllTrim(SA1->A1_END)+IIF(!Empty(SA1->A1_COMPLEM),'-'+SA1->A1_COMPLEM,'')+IIF(SA1->(FieldPos("A1_NR_END"))>0, IIF(Empty(SA1->A1_NR_END),'',', '+SA1->A1_NR_END ),'')) )  )
	               
	Aadd(aClixFor, IIF(!lNFeDev.Or.lImportacao,(AllTrim(SA2->A2_MUN)+' - '+SA2->A2_EST), AllTrim(SA1->A1_MUN)+' - '+SA1->A1_EST) )
	Aadd(aClixFor, IIF(!lNFeDev.Or.lImportacao, ( IIF(!Empty(SA2->A2_DDD),'('+AllTrim(SA2->A2_DDD)+') - ','')+SA2->A2_TEL),;
																( IIF(!Empty(SA1->A1_DDD),'('+AllTrim(SA1->A1_DDD)+') - ','')+SA1->A1_TEL)) )
EndIf

Return()
************************************************************
Static Function PreDocRefresh()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DISPARADA AO CLICAR NO GRID         		    ³
//|	Chamada -> Visual_XML()->oBrwV:oBrowse:bLDblClick	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosItem := Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_ITEM'	})
nPosProd := Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_COD'	})
nPosLocal:= Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_LOCAL'	})
nPosNfOri:= Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_NFORI'	})
nPosDescr:= Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'B1_DESC'	})
   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ oBrwV:oBrowse:ColPos = POSICAO EM QUE SE ENCONTRA NO aCols  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If oBrwV:oBrowse:ColPos == nPosProd  .And. Len(aProdxFor) > 0 .And. Ascan(aProdxFor, {|X| X[1] == oBrwV:aCols[oBrwV:NAT][nPosItem] }) > 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ MOSTRA TELA COM OS PRODUTOS QUE JA ESTA AMARRADOS - SA5	|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa ({|| TMPProdxFor()  },'Verificando Produto X Fornecedor','Processando...', .T.)

Else

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ RETORNA O VALOR ORIGINAL DOS EVENTOS - PARA EDICAO NORMAL DO ACOLS	|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
    oBrwV:oBrowse:bLDblClick:=	{|| IIF( oBrwV:oBrowse:ColPos ==  Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_COD'}) .And. Len(aProdxFor) > 0 .And. Ascan(aProdxFor, {|X| X[1] == oBrwV:aCols[oBrwV:NAT][Ascan(oBrwV:aHeader, {|X| AllTrim(X[2])=='D1_ITEM'})] }) > 0,;
    									 (PreDocRefresh(), VerifStatus()), oBrwV:EditCell()) }
	oBrwV:Editcell()
	oBrwV:oBrowse:lModified	:= .T.
*/

	If	oBrwV:oBrowse:ColPos == Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_COD'}) .And.;
	    Len(aProdxFor) > 0 .And. ;
	    Ascan(aProdxFor, {|X| X[1] == oBrwV:aCols[oBrwV:NAT][Ascan(oBrwV:aHeader, {|X| AllTrim(X[2])=='D1_ITEM'})] }) > 0
	    
	    //oBrwV:oBrowse:bLDblClick :=	{||	PreDocRefresh(), VerifStatus(), ViewTrigger(oBrwV:NAT, oBrwV:oBrowse:ColPos), DadosSB1(), GravaZXP()  }
	    oBrwV:oBrowse:bLDblClick 	:=	{|| PreDocRefresh(), VerifStatus(), ViewTrigger(oBrwV:NAT, oBrwV:oBrowse:ColPos), DadosSB1(), AtuCFOP(), GravaZXP(), oBrwV:oBrowse:Refresh() }
	
	//	oBrwV:Editcell()
		oBrwV:oBrowse:lModified	:= .T.
	
	    
	EndIf

	


EndIf

oBrwV:oBrowse:Refresh() 
    
Return()
************************************************************
Static Function GravaZXP(cRotina, nLin)
************************************************************
// CHAMADA AO INFORMAR O CODIGO DO PRODUTO
//         AO REPLICAR PRODUTO
//         QDO BUSCA O PRODUTO PELO PEDIDO DE COMPRA
                                      
DEFAULT cRotina := 	'SB1'
DEFAULT nLin	:=	oBrwV:NAT

nPosItem	:= 	AScan(aMyHeader	,{|x| Alltrim(x[2]) == "D1_ITEM" 	})
nPosProd	:= 	AScan(aMyHeader	,{|x| Alltrim(x[2]) == "D1_COD"  	})
nPosPC     	:=	Ascan(aMyHeader	,{|X| Alltrim(X[2]) == 'D1_PEDIDO' })
nPosIPC 	:=	Ascan(aMyHeader	,{|X| Alltrim(X[2]) == 'D1_ITEMPC' })
                                             

nXLin		:=	IIF(cRotina$'REPLICA#PEDCOM', nLin, oBrwV:NAT )

cItem 		:= 	oBrwV:aCols[nXLin][nPosItem]
cProdXML	:= 	oBrwV:aCols[nXLin][nPosProd]
cPedCom		:=	oBrwV:aCols[nXLin][nPosPC]
cItemPC		:=	oBrwV:aCols[nXLin][nPosIPC]
lDeletado 	:=  oBrwV:aCols[nXLin][Len(aMyHeader)+1]

                                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ oBrwV:oBrowse:ColPos = POSICAO EM QUE SE ENCONTRA NO aCols  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If oBrwV:oBrowse:ColPos == nPosProd .Or. (cRotina $ 'REPLICA#PEDCOM')
	
	If !Empty(cProdXML) .And. !lDeletado
	
		DbSelectArea('ZXP');DbSetOrder(1);DbGoTop()
		If DbSeek(xFilial('ZXP') + ZXM->ZXM_CHAVE + cItem, .F.)
			RecLock("ZXP", .F.)
				If AllTrim(ZXP->ZXP_PROD) != AllTrim(cProdXML) 
			       ZXP->ZXP_PROD  := AllTrim(cProdXML)
				EndIf
				If ZXP->(FieldPos("ZXP_PEDIDO")) > 0
			    	ZXP->ZXP_PEDIDO := cPedCom
			    EndIf
				If ZXP->(FieldPos("ZXP_ITEMPC")) > 0
			    	ZXP->ZXP_ITEMPC := cItemPC
			    EndIf
			MsUnLock()
			   
		Else
		
			RecLock("ZXP", .T.)
				ZXP->ZXP_FILIAL	:=	xFilial('ZXP')
				ZXP->ZXP_DOC  	:= 	ZXM->ZXM_DOC
				ZXP->ZXP_SERIE 	:= 	ZXM->ZXM_SERIE
				ZXP->ZXP_CHAVE 	:= 	ZXM->ZXM_CHAVE
				ZXP->ZXP_ITEM  	:= 	cItem
				ZXP->ZXP_PROD  	:= 	AllTrim(cProdXML)
				If ZXP->(FieldPos("ZXP_PEDIDO")) > 0
			    	ZXP->ZXP_PEDIDO := cPedCom
			    EndIf
				If ZXP->(FieldPos("ZXP_ITEMPC")) > 0
			    	ZXP->ZXP_ITEMPC := cItemPC
			    EndIf
			MsUnLock()
			   
		EndIf
	
	Else

		DbSelectArea('ZXP');DbSetOrder(1);DbGoTop()
		If DbSeek(xFilial('ZXP') + ZXM->ZXM_CHAVE + cItem, .F.)
			RecLock("ZXP", .F.)
				DbDelete()
			MsUnLock()
		EndIf

	EndIf

EndIf
	
Return()
************************************************************
Static Function AtuPreDoc()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|	ATUALIZA VARIAVEIS												|
//³ Apos Gerar Pre-Nota\Doc.Entrada                                	|
//³ Chamada -> Visual_XML()->Btn Gera Pre-Nota\Doc.Entrada         	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

lGravado        := .T.
oBrwV:lUpdate   := .F.
cXMLStatus      := 'Status XML:' +IIF(cPreDoc=='PRE',"PRÉ NOTA","DOC.ENTRADA")+"  GRAVADO"
SetKey( VK_F6,  Nil)
SetKey( VK_F7,  Nil)
SetKey( VK_F8,  Nil)
SetKey( VK_F9,  Nil)
SetKey( VK_F10, Nil)
oBtnPreDoc:Refresh()
oBtnReplic:Refresh()
oBtnPC:Refresh()
oBrwV:oBrowse:Refresh()
oBrwV:Refresh()
FreeObj(oSayStatus)
oSayStatus:= TSay():New( D(082),D(013),{|| cXMLStatus },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,100,008)
oSayStatus:Refresh()

If ZXM->ZXM_FORMUL == 'S'
	FreeObj(oSayNNFRef)
	FreeObj(oSaySNFRef)
	oSayNNFRef := TSay():New( D(021),D(260),{|| IIF(ZXM->ZXM_FORMUL == 'S',"NF Referência:",'')},oGrp2,,oFontP2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(060),D(012) )
	oSaySNFRef := TSay():New( D(021),D(320),{|| IIF(ZXM->ZXM_FORMUL == 'S',PadL(ZXM->ZXM_DOCREF, TamSx3('F1_DOC')[1],'') +' - '+ PadL(ZXM->ZXM_SERREF, TamSx3('F1_SERIE')[1],''),'')},oGrp2,,oFontP2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(150),D(012) )
	oSayNNFRef:Refresh()
	oSaySNFRef:Refresh()
EndIf               


Return()
************************************************************
Static Function VerifStatus()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   ATUALIZA STATUS e VARIAVEIS                 		³
//|	Chamada -> Visual_XML()->oBrwV:oBrowse:bLDblClick	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do Case
	Case ZXM->ZXM_STATUS $ 'I\G' .And. ZXM->ZXM_SITUAC != 'C'//.And. ZXM->ZXM_SITUAC == 'A'
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³    XML - GRAVADO PRE-NOTA \ DOC.ENTRADA       ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   oBtnPreDoc:Enable()                                //    Habilita Botao
	   oBtnReplic:Enable()
	   oBtnPC:Enable()
	   oBrwV:lUpdate := IIF(lGravado,.F.,.T.)     //    Ativa\Desativa edicao Linha
	   IF lGravado
	       	oBrwV:oBrowse:bLDblClick := {|| MsgAlert( IIF(cPreDoc=='PRE',"PRÉ NOTA","DOC.ENTRADA")+' já gravado... Não é possível edição!!!'+ENTER+'Para VISUALIZAR o documento click no botão '+IIF(cPreDoc=='PRE',"Pré Nota","Doc.Entrada") ) }
	   		SetKey( VK_F6, {|| MsgAlert( IIF(cPreDoc=='PRE',"PRÉ NOTA","DOC.ENTRADA")+' já gravado... Não é possível edição!!!'+ENTER+'Para VISUALIZAR o documento click no botão '+IIF(cPreDoc=='PRE',"Pré Nota","Doc.Entrada")) })
	   		SetKey( VK_F7, {|| MsgAlert( IIF(cPreDoc=='PRE',"PRÉ NOTA","DOC.ENTRADA")+' já gravado... Não é possível edição!!!'+ENTER+'Para VISUALIZAR o documento click no botão '+IIF(cPreDoc=='PRE',"Pré Nota","Doc.Entrada")) })
	   		SetKey( VK_F8, {|| MsgAlert( IIF(cPreDoc=='PRE',"PRÉ NOTA","DOC.ENTRADA")+' já gravado... Não é possível edição!!!'+ENTER+'Para VISUALIZAR o documento click no botão '+IIF(cPreDoc=='PRE',"Pré Nota","Doc.Entrada")) })
	   		SetKey( VK_F9, {|| MsgAlert( IIF(cPreDoc=='PRE',"PRÉ NOTA","DOC.ENTRADA")+' já gravado... Não é possível edição!!!'+ENTER+'Para VISUALIZAR o documento click no botão '+IIF(cPreDoc=='PRE',"Pré Nota","Doc.Entrada")) })
	   		SetKey( VK_F10,{|| MsgAlert( IIF(cPreDoc=='PRE',"PRÉ NOTA","DOC.ENTRADA")+' já gravado... Não é possível edição!!!'+ENTER+'Para VISUALIZAR o documento click no botão '+IIF(cPreDoc=='PRE',"Pré Nota","Doc.Entrada")) })

		   oBtnReplic:Disable()
		   oBtnPC:Disable()
		   oBrwV:lUpdate := .F.    //    Ativa\Desativa edicao Linha
	

	   Else
		   	SetKey( VK_F6, {|| SelItemPC() })    //    Click - F6   
			SetKey( VK_F7, {|| Processa ( ReplicaProd('PROD')	,'Selecionando Registros','Processando...', .T.) } )    //    Click - F7
			SetKey( VK_F8, {|| Processa ( ReplicaProd('ALMOX')	,'Selecionando Registros','Processando...', .T.) } )    //    Click - F8
		  	If cPreDoc=='DOC'
				SetKey( VK_F9, {|| Processa ( ReplicaProd('TES')	,'Selecionando Registros','Processando...', .T.) } )    //    Click - F9
			Else
				SetKey( VK_F9,{|| Nil })
			EndIf

			SetKey( VK_F10, {|| MsgRun('Verificando NF Origem... ', 'Aguarde... ',{|| Doc_DevRet() }), oBrwV:oBrowse:Refresh() })
				
//			If lNFeDev
//				SetKey( VK_F10, {|| IIF(lNFeDev, MsgRun('Verificando NF Origem... ', 'Aguarde... ',{|| Doc_DevRet() }) , ), oBrwV:oBrowse:Refresh() })
//			Else
//				SetKey( VK_F10,{|| Nil })
//			EndIf
		EndIf

	Case ZXM->ZXM_STATUS $ 'X\R' .And. ZXM->ZXM_SITUAC != 'C'
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³    XML - CANCELADO \ RECUSADO                 ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   oBtnPreDoc:Disable()    //    Desabilita Botao
	   oBtnReplic:Disable()
	   oBtnPC:Disable()
	   oBrwV:lUpdate := .F.    //    Desabilita Edicao Linha
       oBrwV:oBrowse:lModified := .F.
	   oBrwV:oBrowse:bLDblClick :=    {|| MsgAlert( cXMLStatus+'.   Não é possível edição !!!' ) }
	
	   SetKey( VK_F6, {|| MsgAlert('XML '+IIF(ZXM->ZXM_STATUS=='C','CANCELADO','RECUSADO' )+'... Não é possível edição!!!') })
	   SetKey( VK_F7, {|| MsgAlert('XML '+IIF(ZXM->ZXM_STATUS=='C','CANCELADO','RECUSADO' )+'... Não é possível edição!!!') })
	   SetKey( VK_F8, {|| MsgAlert('XML '+IIF(ZXM->ZXM_STATUS=='C','CANCELADO','RECUSADO' )+'... Não é possível edição!!!') })
	   SetKey( VK_F9, {|| MsgAlert('XML '+IIF(ZXM->ZXM_STATUS=='C','CANCELADO','RECUSADO' )+'... Não é possível edição!!!') })
	   SetKey( VK_F10,{|| MsgAlert('XML '+IIF(ZXM->ZXM_STATUS=='C','CANCELADO','RECUSADO' )+'... Não é possível edição!!!') })
	   		
	Case ZXM->ZXM_SITUAC == 'C'
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³    XML - CANCELADO PELO FORNECEDOR            ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   oBtnPreDoc:Disable()    //    Desabilita Botao
	   oBtnReplic:Disable()
	   oBtnPC:Disable()
	   oBrwV:lUpdate := .F.    //    Desabilita Edicao Linha
       oBrwV:oBrowse:lModified := .F.
	   oBrwV:oBrowse:bLDblClick :=    {|| MsgAlert( cXMLStatus+'.   Não é possível edição !!!' ) }
		
	   SetKey( VK_F6, {|| MsgAlert('XML CANCELADO... Não é possível edição!!!') })
	   SetKey( VK_F7, {|| MsgAlert('XML CANCELADO... Não é possível edição!!!') })
	   SetKey( VK_F8, {|| MsgAlert('XML CANCELADO... Não é possível edição!!!') })
	   SetKey( VK_F9, {|| MsgAlert('XML CANCELADO... Não é possível edição!!!') })
	   SetKey( VK_F10,{|| MsgAlert('XML CANCELADO... Não é possível edição!!!') })
	   	   
	   MsgAlert('XML Cancelado pelo Fornecedor.  Não é possível edição !!!' )
      
	Case Empty(ZXM->ZXM_SITUAC)
		lValidDlg	:=	.F.
		If MsgYesNo('Status XML inválido. Deseja consultar XML na SEFAZ ?') 
			cRet := ExecBlock("ConsNFeSefaz",.F.,.F.,{""})
			lValidDlg	:=	.T.
		EndIf
	
EndCase
                                               
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³    VERIFICA SE EH CLIENTE OU FORNECEDOR		  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lNFeDev .And. !Empty(ZXM->ZXM_TIPO)
	aClixFor[1] := IIF(ZXM->ZXM_TIPO$'D\B','Cliente: ','Fornecedor: ') 
EndIf
                                  

oBrwV:oBrowse:Refresh()
oBrwV:Refresh()
Return
************************************************************
Static Function TMPProdxFor()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ao clicar no campo Produto e existir mais de 1 Produto X Cod.For |
//| Browse para usuario informar qual produto ira amarrar com Cod.For|
//³ Chamada -> Visual_XML()->bLDblClick                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local	nPosPFor    :=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'C7_PRODUTO' })
Local	nTamProd    :=	TamSX3('B1_COD')[1]
Local	cProduto    :=	Space(nTamProd)
Private	cMarca		:= 	''

SetPrvt("oFont1","oDlgSA5","oSay1","oSay2","oSay3","oSay4","oSay5","oGrp1","oBrwSA5","oBtn1","oBtn2")

oFont1     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-09,-11),,.T.,0,,700,.F.,.F.,,,,,, )

oDlgSA5    := MSDialog():New( D(095),D(232),D(475),D(702),"Produto X Fornecedor",,,.F.,,,,,,.T.,,oFont1,.T. )
oSay1      := TSay():New( D(004),D(008),{||"Os Produtos abaixo estão relacionados com o produto deste fornecedor."},oDlgSA5,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(210),D(008) )
oSay3      := TSay():New( D(019),D(008),{||"Produto: "+ oBrwV:aCols[oBrwV:NAT][nPosPFor] },oDlgSA5,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(150),D(008) )
oGet1      := TGet():New( D(026),D(008),{|u| If(PCount()>0,cProduto :=u,cProduto)},oDlgSA5,D(072),D(008),'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)

oBtn4      := TButton():New( D(024),D(090),"Adicionar",oDlgSA5,{|| AddProdxFor(cProduto), cProduto:= Space(nTamProd), oDlgSA5:Refresh() },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )

*******************************
   oTblSA5()
*******************************
cMarca     := GetMark()
DbSelectArea("TMPSA5")
oGrp1      := TGroup():New( D(038),D(004),D(164),D(228),"",oDlgSA5,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBrwSA5    := MsSelect():New( "TMPSA5","OK","",{{"OK","","",""},{"PRODUTO","","Produto",""},{"DESCR","","Descrição",""}},.F.,cMarca,{D(042),D(008),D(157),D(220)},,, oGrp1 )

oBtn1      := TButton():New( D(170),D(068),"&OK",oDlgSA5, {|| OKProdxFor(), oDlgSA5:End() } ,D(037),D(012),,oFont1,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( D(170),D(116),"&Cancelar",oDlgSA5,{|| oDlgSA5:End() },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )

oBrwSA5:oBrowse:bLDblClick := {|| MarcaSA5(), oBrwSA5:oBrowse:Refresh() }
oBrwSA5:oBrowse:SetFocus()
oBrwSA5:oBrowse:Refresh()

oDlgSA5:Activate(,,,.T.)


IIF(Select("TMPSA5") != 0, TMPSA5->(DbCLoseArea()), )

Return
************************************************************
Static Function oTblSA5()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria\Limpa\Atualiza Tabela Temporaria       |
//³ Chamada -> TMPProdxFor                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aFds := {}
Local cTmp
Local nPosItem:=    Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_ITEM' })


If Select("TMPSA5") == 0
   Aadd( aFds , {"OK"      ,"C",002,000} )
   Aadd( aFds , {"PRODUTO" ,"C",015,000} )
   Aadd( aFds , {"DESCR"   ,"C",030,000} )
   Aadd( aFds , {"_RECNO"  ,"N",100,000} )

   cTmp := CriaTrab( aFds, .T. )
   Use (cTmp) Alias TMPSA5 New Exclusive
   Aadd(aArqTemp, cTmp)
Else
   DbSelectArea("TMPSA5")
   RecLock('TMPSA5', .F.)
       Zap
   MsUnLock()
EndIf

DbSelectArea("TMPSA5")
For nX := 1 To Len(aProdxFor)
	If oBrwV:aCols[oBrwV:NAT][nPosItem] == aProdxFor[nX][1]
   		RecLock("TMPSA5",.T.)  
       		TMPSA5->PRODUTO	:= aProdxFor[nX][3]
       		TMPSA5->DESCR   := aProdxFor[nX][4]
       		TMPSA5->_RECNO	:= nX
   		MsUnLock()
 	EndIf
Next

TMPSA5->(DbGoTop())

IIF(Type('oBrwSA5:oBrowse:Refresh()')!='U', (oBrwSA5:oBrowse:Refresh(),oBrwSA5:oBrowse:Setfocus()), )
oBrwV:oBrowse:Refresh()
oBrwV:Refresh()


Return
************************************************************
Static Function MarcaSA5()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Marca apenas 1 para selecao                 |
//³ Chamada -> TMPProdxFor                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nRecno    :=    TMPSA5->_RECNO

DbSelectArea('TMPSA5');DbGoTop()
Do While !Eof()
   RecLock("TMPSA5",.F.)
       TMPSA5->OK  := IIF(_nRecno==TMPSA5->_RECNO, cMarca, '')
   MsUnLock()
   DbSkip()
EndDo

DbGoTo(_nRecno)
IIF(Type('oBrwSA5:oBrowse:Refresh()')!='U', oBrwSA5:oBrowse:Refresh(), )

Return
************************************************************
Static Function OKProdxFor()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava no aCols o item selecionado           |
//³ Chamada -> TMPProdxFor                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local    nPosProd    :=    Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_COD' })

oBrwV:aCols[oBrwV:NAT][nPosProd] := PadR(TMPSA5->PRODUTO, TamSx3('B1_COD')[01],'')
		
oBrwV:oBrowse:Refresh()

Return
************************************************************
Static Function AddProdxFor(cProduto)
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Usuario podera adicionar outro produto para amarrar - SA5  |
//³ Chamada -> TMPProdxFor                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotRecno	:= 	0
nPosPFor    :=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'C7_PRODUTO' })
nPDescFor   :=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'B1_DESCFOR' })		// DESCRICAO DO CODIGO DO FORNECEDOR [GRAVO NO SA5]
_nRecno     :=	TMPSA5->_RECNO

DbGoTop()
Do While !Eof()
   If AllTrim(TMPSA5->PRODUTO) == AllTrim(cProduto)
       Alert('PRODUTO '+SB1->B1_COD+' JÁ RELACIONADO !!!')
       Return()
   EndIf

   RecLock("TMPSA5",.F.)
       TMPSA5->OK  := ''
   MsUnLock()

   nTotRecno++
   DbSkip()
EndDo

RecLock("TMPSA5",.T.)
   TMPSA5->OK  		:= cMarca
   TMPSA5->PRODUTO  := SB1->B1_COD
   TMPSA5->DESCR    := SB1->B1_DESC
   TMPSA5->_RECNO   := nTotRecno++
MsUnLock()

DbSelectArea('ZXM')
DbSelectArea('SA5');DbSetOrder(1);DbGoTop()
If !Dbseek(xFilial("SA5")+ ZXM->ZXM_FORNEC + ZXM->ZXM_LOJA + SB1->B1_COD, .F.)
	Reclock("SA5",.T.)
       SA5->A5_FILIAL    :=    xFilial("SA5")
       SA5->A5_FORNECE   :=    ZXM->ZXM_FORNEC
       SA5->A5_LOJA      :=    ZXM->ZXM_LOJA
       SA5->A5_CODPRF    :=    oBrwV:aCols[oBrwV:NAT][nPosPFor]
       SA5->A5_PRODUTO   :=    SB1->B1_COD
       SA5->A5_NOMPROD   :=    SubStr(oBrwV:aCols[oBrwV:NAT][nPDescFor],1,30) //SubStr(SB1->B1_DESC,1,30)
       SA5->A5_NOMEFOR   :=    Posicione("SA2",3,xFilial("SA2")+ZXM->ZXM_CGC,"A2_NOME")
   MsUnlock()
EndIf

MsgInfo('PRODUTO RELACIONADO COM SUCESSO !!!'+ENTER+ENTER+ AllTrim(SB1->B1_COD)+' - '+AllTrim(SB1->B1_DESC) )

DbGoTop()

Return()
************************************************************
Static Function CarregaACols()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega valores para aMyCols    ³
//³ Chamada -> Visual_XML()         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea3_2	:= GetArea()
Local cNumPC	:=	''
Local cItemPC	:=	''
Local cNFOrig	:=	''
Local cSerOrig	:=	''
Local cItemOrig	:=	''
Local cAlmox   	:=	''
Local cProdSD1	:=	''
Local cTes		:=	''
Local cAlmox  	:=	''
Local cProdSA5	:=	''
Local cEanCod	:=	''
Local cCompSB1	:= 	''
Local cCtaCont	:= 	''
Local cCCusto	:=	''		           		
Local _cTipo	:=	''
Local cXML		:=	''
Local aItens 	:=	{}
Local nSD1Recno := 	0
Local nItemXML	:= 	0
Local nPrecoNFe	:= 	0

aXMLOriginal	:=	{}
cTpFormul 		:= 	''


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se SB1 eh compartilhado|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('SB1'))
	cCompSB1	:= SX2->X2_MODO
EndIf

Private aItemProdxFor 	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Var Private - Visual_XML        |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lGravado	:=	.F.
nTotalNFe	:=	0



cXML	:=	AllTrim(ZXM->ZXM_XML)
cXML	+=	ExecBlock("VerificaZXN",.F.,.F., {ZXM->ZXM_FILIAL, ZXM->ZXM_CHAVE})	//	VERIFICA SE O XML ESTA NA TABELA ZXN


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  CabecXmlParser -   ABRE XML - CABEC     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
*******************************************************************
   aRet	:=	ExecBlock("CabecXmlParser",.F.,.F., {cXML})
*******************************************************************

If aRet[1] == .T.	//	aRet[1] == .F. SIGNIFICA XML COM PROBLEMA NA ESTRUTURA

	ProcRegua(nItensXML)
	
   	For nX := 1 To nItensXML
                               
	   	IncProc('Verificando Item '+AllTrim(Str(nX)) +' de '+ AllTrim(Str(nItensXML))  ) 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  ItemXmlParser -  ABRE XML - ITEM       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
       ****************************************
           ItemXmlParser(nX)   
       ****************************************


           	nItemXML := PadL(AllTrim(Str(nX)),4,'0')
		
		
           //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           //³ BUSCA DADOS DA PRE-NOTA \ DOC.ENTRADA, CASO JA TENHA GRAVADO    ³
           //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           	lGravado	:= IIF(lGravado, .T., .F.) // CASO TENHA INCLUSO 1 ITEM E OS OUTROS NAO.. EH MARCADO COMO GRAVADO.
           	cNumPC 		:= cItemPC  := cAlmox := cProdSD1 :=  cTes	:=	''
			cCtaCont    :=  cCCusto := _cTipo := cProdSA5 :=  ''
           	cCodFor 		:= ''
           	aItemProdxFor	:= 	{}
           	aProdFil		:=	{}


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³VERIFICA SE XML ESTA GRAVADO NO DOC.ENTRADA       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea('SD1');DbSetOrder(1);DbGoTop()    //    D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			If DbSeek( ZXM->ZXM_FILIAL + IIF(ZXM->ZXM_FORMUL!='S', ZXM->ZXM_DOC+ZXM->ZXM_SERIE, ZXM->ZXM_DOCREF+ZXM->ZXM_SERREF) + ZXM->ZXM_FORNEC+ ZXM->ZXM_LOJA, .F.)
				Do While !Eof() .And. SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE+ SD1->D1_LOJA == IIF(ZXM->ZXM_FORMUL!='S', ZXM->ZXM_DOC+ZXM->ZXM_SERIE, ZXM->ZXM_DOCREF+ZXM->ZXM_SERREF) + ZXM->ZXM_FORNEC+ ZXM->ZXM_LOJA
					If  SD1->D1_ITEM == nItemXML
						_cTipo		:=	SD1->D1_TIPO
						cNumPC		:=	SD1->D1_PEDIDO
						cItemPC		:=	SD1->D1_ITEMPC
						cAlmox		:=	SD1->D1_LOCAL
						cProdSD1	:=	PadR(SD1->D1_COD, TamSx3('B1_COD')[01],'')
						cTes		:=	SD1->D1_TES
			       		cCtaCont	:= 	SD1->D1_CONTA		//	Conta Contabil dn Prod.
		           		cCCusto		:=	SD1->D1_CC			//	Centro de Custo
						cNFOrig		:=	SD1->D1_NFORI
						cSerOrig	:=	SD1->D1_SERIORI
						cItemOrig	:=	SD1->D1_ITEMORI
						nSD1Recno	:=	SD1->(Recno())
						lGravado  	:=	.T.
						Exit
					EndIf
				DbSkip()
				EndDo
			EndIf


           nPrecoNFe := (nTotal) //-nDescont)
           nTotalNFe += (nTotal) //-nDescont)


           //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           //³        XML - NORMAL         ³
           //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lNFeDev

		       ************************************
					ForCliMsBlql('SA2', ZXM->ZXM_CGC)
			   ************************************
               cCodFor    :=   SA2->A2_COD
               cLojaFor   :=   SA2->A2_LOJA

			Else

	           //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	           //³        XML - DEVOLUCAO      ³
	           //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
	           cTabela := IIF(ZXM->ZXM_TIPO $ 'D\B' , 'SA1', 'SA2' )
	           
				************************************
					ForCliMsBlql(cTabela, ZXM->ZXM_CGC)
				************************************
				cCodFor    	:=   IIF(ZXM->ZXM_TIPO $ 'D\B', SA1->A1_COD, 	SA2->A2_COD)
				cLojaFor   	:=   IIF(ZXM->ZXM_TIPO $ 'D\B', SA1->A1_LOJA, 	SA2->A2_LOJA )
				SA2Recno	:=   IIF(ZXM->ZXM_TIPO $ 'D\B', SA1->(Recno()), SA2->(Recno()) )
				
			EndIf
								
		
		
			   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   //³        XML - NORMAL         ³
			   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !lNFeDev
				   DbSelectarea("SA2");DbSetOrder(3);DbGoTop()
				   If Dbseek(xFilial("SA2")+ZXM->ZXM_CGC, .F.)
					   cCodFor    :=   SA2->A2_COD
					   cLojaFor   :=   SA2->A2_LOJA
				   EndIf                    
				   
				Else

				   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				   //³        XML - DEVOLUCAO      ³
				   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
				   DbSelectarea("SA1");DbSetOrder(3);DbGoTop()
				   If Dbseek(xFilial("SA1")+ZXM->ZXM_CGC, .F.)
					   cCodFor    :=   SA1->A1_COD
					   cLojaFor   :=   SA1->A1_LOJA
				   EndIf
				EndIf
			   

		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           //³  ATUALIZA STATUS ZXM - CASO XML ESTEJA GRAVADO NO DOC.ENTRADA    ³
           //|	CASO XML NAO ESTEJA CANCELADO NA SEFAZ							|
           //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           If lGravado
				DbSelectArea("ZXM")
                If ZXM->ZXM_STATUS != 'G' .And. ZXM->ZXM_SITUAC != 'C'
                	RecLock('ZXM',.F.)
        	           	ZXM->ZXM_STATUS := 'G'
                  		ZXM->ZXM_TIPO	:=	_cTipo
                	MsUnlock()
				EndIf
               
           
           Else

			
			   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   //³ VERIFICA SE JA HOUVE ALGUMA GRAVACAO PARCIAL DOS ITENS DO XML	|
			   //| UTILIZADO PARA QUE USUARIO NAO PRECISE DIGITAR TUDO NOVAMENTE	|
			   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea('ZXP');DbSetOrder(1);DbGoTop()
				If DbSeek(xFilial('ZXP') + ZXM->ZXM_CHAVE + nItemXML, .F.) .And. !lGravado

					cProdSA5 :=  AllTrim(ZXP->ZXP_PROD)
				
					If ZXP->(FieldPos("ZXP_PEDIDO")) > 0
				    	cNumPC := ZXP->ZXP_PEDIDO
				    EndIf
					If ZXP->(FieldPos("ZXP_ITEMPC")) > 0
				    	cItemPC := ZXP->ZXP_ITEMPC
				    EndIf


				Else
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//| VERIFICA SE EH UMA TRANSFERENCIA E VERIFICA SE A TABELA SB1 E COMPARTIILHADA		|
					//| PEGO OS CODIGOS DE PRODUTO QUE ESTAO NO XML E JOGA PARA ACOLS                       |
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	Ascan(_aEmpFil, {|X| X[3] == ZXM->ZXM_CGC } ) != 0 .And. cCompSB1 == 'C'
						Aadd(aProdFil, cProdFor ) 
							
					Else
					   
					   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					   //³ BUSCA O CODIGO DO PRODUTO PELO EAN DO XML	 ³
					   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					   DbSelectArea('SB1');DbSetOrder(5);DbGoTop()	
					   If DbSeek( xFilial('SB1') + cEAN, .F. ) .And. !Empty(cEAN)
							cEanCod	:=	SB1->B1_COD
					   Else

							
							DbSelectArea('SA5');DbSetOrder(5);DbGoTop()
							cArquivo    	:= CriaTrab(NIL,.F.)
							cChave			:= 'A5_FILIAL+A5_FORNECE+A5_CODPRF' //IndexKey(6)
							Aadd(aArqTemp, cArquivo )
				
							cCondicao 		:= 'SA5->A5_FILIAL  == "'+ xFilial("SA5") + '" .And. '
							cCondicao 		+= 'SA5->A5_FORNECE == "'+ ZXM->ZXM_FORNEC+ '" .And. '
							cCondicao 		+= 'SA5->A5_LOJA    == "'+ ZXM->ZXM_LOJA  + '" .And. '
							cCondicao 		+= 'SA5->A5_CODPRF  == "'+ PadR( cProdFor,  TamSx3("A5_CODPRF")[1], '')+'" '
							IndRegua("SA5",cArquivo,cChave,,cCondicao,'Filtro Produto X Fornecedor')  // INDREGUA( cAlias, cIndice, cExpress, [ xOrdem] , [ cFor ], [ cMens ], [ lExibir ] ) -> nil
									 
						
						   Do While !Eof().And. SA5->A5_FORNECE == cCodFor .And. SA5->A5_LOJA == cLojaFor 
						   
								If AllTrim(SA5->A5_CODPRF) == AllTrim(cProdFor)
									If Ascan(aItemProdxFor, {|X|X[3] == SA5->A5_PRODUTO } ) == 0
										Aadd(aItemProdxFor, {nItemXML, SA5->A5_CODPRF, SA5->A5_PRODUTO, SA5->A5_NOMPROD} )
									EndIf
								EndIf
						   
							   DbSelectArea('SA5')
							   DbSkip()
						   EndDo

					
						EndIf

					EndIf
						

					If !Empty(cEanCod)				
					   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					   //³ CODIGO PRODUTO BUSCADO PELO EAN.	 ³
					   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cProdSA5 := cEanCod							
				   
					ElseIf Len(aItemProdxFor) > 1 .And. ZXM->ZXM_STATUS == 'I'
					   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					   //³ QDO XML ESTA IMPORTADO E TEM MAIS DE UM PRODUTO NO SA5...	 									³
					   //| UTILIZADO AO CLICAR NO GRID DA COLUNA PRODUTO... MOSTRAR TELA COM AMARRACAO JA EXISTENTES - SA5	|	
					   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cProdSA5 := ''
						For nY:=1 To Len(aItemProdxFor)
						   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						   //³ GUARDA EM aProdxFor(ITEM DO GRID, A5_CODPRF, COD.EMPRESA, DESCRICAO) OS PRODUTOS Q TEM NO SA5	|
						   //| UTILIZADO AO CLICAR NO GRID DA COLUNA PRODUTO... MOSTRAR TELA COM AMARRACAO JA EXISTENTES - SA5	|	
						   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

							// 	Aadd(aItemProdxFor, {nItemXML, SA5->A5_CODPRF, SA5->A5_PRODUTO, SA5->A5_NOMPROD} )
							Aadd(aProdxFor, aItemProdxFor[nY])	//	UTILIZO aProdxFor no Duplo click

						Next
				
					ElseIf Len(aProdFil) > 0
					   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					   //³ CASO FOR TRANSFERENCIA E SB1 COMPARTILHADO PEGA O COD. PRODUTO DO XML ³
					   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cProdSA5 := aProdFil[1]
				   
					Else
						cProdSA5 :=  IIF(Len(aItemProdxFor)==1, aItemProdxFor[1][3], Space(TamSX3('B1_DESC')[1]) )
					EndIf

				EndIf

				
			   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   //³        ARMAZEM PADRAO       ³
			   //| Busca primeiro do Produto   |
			   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SB1->(DbGoTop(), DbSetOrder(1))
				If SB1->(DbSeek(xFilial('SB1') + cProdSA5 ,.F.) )
					cAlmox 		:= 	AllTrim(SB1->B1_LOCPAD)		//	Local Padrao 
					cTes		:= 	AllTrim(SB1->B1_TE)			//	Codigo de Entrada padrao
					cCtaCont	:= 	AllTrim(SB1->B1_CONTA)		//	Conta Contabil dn Prod.
					cCCusto		:=	AllTrim(SB1->B1_CC)			//	Centro de Custo
				ElseIf SX6->(DbGoTop(), DbSeek( cFilAnt+'MV_LOCPAD' ,.F.) )
					cAlmox := AllTrim(SX6->X6_CONTEUD)		               
				EndIf
	

			EndIf
			

           //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           //³     ALIMENTA aMyACols       ³
           //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea('SD1')
			aItens := {}

			Aadd( aItens, {'D1_ITEM', 		nItemXML 	})

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³   CODIGO E DESCRICAO DO PRODUTO DO FORNECEDOR - XML  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Aadd( aItens, {'C7_PRODUTO',  	cProdFor    })
			If TMPCFG->(FieldPos('DESCFOR')) > 0
               	If TMPCFG->DESCFOR == 'SIM'
                	Aadd( aItens, {'B1_DESCFOR', cDescrProd	 })
               	EndIf
			Else
				Aadd( aItens, {'B1_DESCFOR', cDescrProd	})
			EndIf


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³   	 CODIGO E DESCRICAO DO PRODUTO DA EMPRESA        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			Aadd( aItens, {'D1_COD',  IIF(!Empty(cProdSD1), PadR(cProdSD1, TamSx3('B1_COD')[01],''), PadR(cProdSA5, TamSx3('B1_COD')[01],''))})
			
			If TMPCFG->(FieldPos('DESCEMP')) > 0
                	If TMPCFG->DESCEMP == 'SIM'
                		Aadd( aItens, {'D1_DESCRI', IIF(!Empty(cProdSD1+cProdSA5), (AllTrim(Posicione('SB1',1,xFilial('SB1')+ IIF(!Empty(cProdSD1), cProdSD1, cProdSA5) ,'B1_DESC'))), Space(TamSx3('B1_DESC')[1])) })
                	EndIf
			EndIf


			//	VERIFICA SE UNIDADE DE MEDIDA DO PRODUTO DO XML EXISTE NO CADASTRO DE MEDIDAS
			//  CASO NAO EXISTA BUSCA DO CADASTRO DE PRODUTO
			If !Empty(Posicione("SAH",1,xFilial("SAH")+Upper(cUM),'AH_UNIMED')) .And. Len(cUm) == 2
				Aadd( aItens, {'D1_UM',		Upper(cUM)	}) 
	
			Else
	
				nPosCod  := Ascan( aItens, {|X| AllTrim(X[1]) == 'D1_COD'	})
				cUM		 := Posicione('SB1',1,xFilial('SB1')+ aItens[nPosCod][2], 'B1_UM')
				If !Empty(cUM)
					Aadd( aItens, {'D1_UM',	 cUM })
				EndIf
			
			EndIf

		
			Aadd( aItens, {'D1_LOCAL', 		cAlmox 		})
			Aadd( aItens, {'D1_PEDIDO', 	cNumPC		})
        	Aadd( aItens, {'D1_ITEMPC', 	cItemPC		})
            Aadd( aItens, {'D1_TES',		cTes		})
            Aadd( aItens, {'D1_NFORI',		cNFOrig		})
			Aadd( aItens, {'D1_SERIORI',	cSerOrig	})
			Aadd( aItens, {'D1_ITEMORI',	cItemOrig	})
			Aadd( aItens, {'D1_QUANT',		nQuant		})
			Aadd( aItens, {'D1_VUNIT',		nPreco		})
			Aadd( aItens, {'D1_VALDESC',	nDescont	})
			Aadd( aItens, {'D1_TOTAL', 		nPrecoNFe	})
	   		Aadd( aItens, {'D1_CC', 		cCCusto		})
	   		Aadd( aItens, {'D1_CONTA', 		cCtaCont	})

           	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           	//³     ALIMENTA aMyACols com os dados de aMyHeader, SE NAO EXISTE NO aItens CRIA COM O CONTEUDO PADRAO DO SX3	|
		   	//| 	   aMyHeader == TODO O SX3 DO SD1																			|
           	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Aadd(aMyCols, Array(Len(aMyHeader)))				//	GERA aMyCols do tamannho de aMyHeader
			nTam := Len(aMyCols)
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  PRIMEIRO VERIFICA E CARREGA aMyCols COM O ARRAY aItens   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For _nX:=1 To Len(aItens)

                SX3->(DbSetOrder(2), DbGoTop())                //	PROCURA NO SX3 OS CAMPOS DA aMyHeader
                SX3->(DbSeek(aItens[_nX][1], .F.) )
				
				nPos := Ascan(aMyHeader, {|X| AllTrim(X[2]) == aItens[_nX][1] })
				If nPos > 0
					If aMyHeader[nPos][8] == 'C'                            //           TAMANHO DO CONTUDO DA TAG PODERA SER MAIOR QUE O TAMANHO PADRAO DO CAMPO.... EX.: PRODUTO
						aMyCols[nTam][nPos] := IIF(!Empty(aItens[_nX][2]), IIF(Len(aItens[_nX][2])>aMyHeader[nPos][4], Left(aItens[_nX][2],aMyHeader[nPos][4]), aItens[_nX][2]), Space(aMyHeader[nPos][4]) )
					ElseIf aMyHeader[nPos][8] == 'N'

						If ValType(aItens[_nX][2]) == 'N'
							aMyCols[nTam][nPos] := IIF( aItens[_nX][2]!=0, aItens[_nX][2], CriaVar(aMyHeader[nPos][2],IIF(SX3->X3_CONTEXT=="V",.F.,.T.)) )
       					Else
							aMyCols[nTam][nPos] := IIF(!Empty(aItens[_nX][2]), IIF(Len(aItens[_nX][2])>aMyHeader[nPos][4], Left(aItens[_nX][2],aMyHeader[nPos][4]), aItens[_nX][2]), Space(aMyHeader[nPos][4]) )                            
                        EndIf
					EndIf
				Else
					aMyCols[nTam][_nX] := CriaVar(aMyHeader[_nX][2],IIF(SX3->X3_CONTEXT=="V",.F.,.T.))
				EndIf

			Next
			
                
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  SEGUNDO CARREGA OS VALORES DEFAULT no aMyCols         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	                
            For _nX:=1 To Len(aMyHeader)

				If Ascan(aItens, {|X| AllTrim(X[1]) == AllTrim(aMyHeader[_nX][2])} ) == 0

	                SX3->(DbSetOrder(2), DbGoTop())                //	PROCURA NO SX3 OS CAMPOS DA aMyHeader
	                SX3->(DbSeek(aMyHeader[_nX][2], .F.) )

					aMyCols[nTam][_nX] := CriaVar(aMyHeader[_nX][2],IIF(SX3->X3_CONTEXT=="V",.F.,.T.))

			    EndIf

			Next

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  ADICIONA +1 COLUNA NO aMyCols PARA CONTROLE DE ITEM DELETADO   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Aadd(aMyCols[nTam], .F. )
                            
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  GRAVA DADOS DO XML PARA DEPOIS COMPARAR COM DOC.ENTRADA	 	³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Aadd(aXMLOriginal, {nItemXML, Right(cProdFor, TamSx3('D1_COD')[1]), cDescrProd, cNCM, nQuant, nPreco, nDescont } )
	
	Next

EndIf

RestArea(aArea3_2)
Return()
************************************************************
User Function CabecXmlParser()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE XML - CABEC                ³
//³ Chamada -> CarregaAcols()       ³
//³ Chamada -> Grava_Xml()          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cArquivo 		:=	ParamIxb[01]
Local cError    	:=	''
Local cWarning    	:=	''
Local aRetorno   	:=	{}

Static nItensXML    := 	0
Static cInfAdic     := 	''
Static cDataNFe    	:=	''
Static cEmitCnpj    :=	''
Static cEmitNome    :=	''
Static cDestNome    :=	''
Static cDestCnpj    :=	''
Static cNotaXML    	:=	''
Static cSerieXML	:=	''
Static cChaveXML	:=	''
Static cNatOper		:=	''  

Static cTranspCgc	:=	''
Static cPlaca		:=	''
Static cTpFrete		:=	''
Static cEspecie		:=	''
Static nVolume		:=	0
Static nPLiquido	:=	0
Static nPBruto		:=	0

Static _nAdicao
Static _nSeq
Static _cFabri
Static _cExpt
Static _dDtDesemb
Static _dDtDI
Static _cNumDI
Static _cUFDesemb
Static _cLocDesemb
Static _nXBCII
Static _nXValII
Static _nDespac
Static _nXValIOF

Static oXml			:=	''

lNFeDev    			:=  .F.
lImportacao			:=	.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 			PARSE DO XML              |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oXml  := 	XmlParser(cArquivo,"_",@cError, @cWarning )

	*************************************
		aRetorno	:=	ReadTagXml(cError)	//	LENDO TAGs DO XML
	*************************************


Return(aRetorno)
************************************************************
Static Function ReadTagXml(cError)
************************************************************
Local aColsXML	:=	{}
Local aRetXML	:=	{}
Local lEstrut	:=	.T.                              



If TMPCFG->TAGPROT == 'SIM'

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ 	VERIFICA SE EXISTE A TAG PROTNFE	|
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If AllTrim(Type("oXml:_NFEPROC:_PROTNFE")) != "O"

	   	Aadd(aRetXML, .F., 'T')
   		Aadd(aRetXML, 'XML SEM TAG PROTOCOLO DE AUTORIZAÇÃO.')

		Return(aRetXML)
	EndIf

EndIf



If Empty(cError) .And. ( 	AllTrim(Type("oXml:_INFNFE")) 	== "O" 	   .Or.;
							AllTrim(Type("oXml:_NFE:_INFNFE")) 	== "O" .Or.;
							AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE")) == "O" )

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ QUANTIDADE DE ITEMS DO XML   ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  	   
   If AllTrim(Type("oXml:_INFNFE")) == "O"
       aColsXML := aClone(oXml:_INFNFE:_DET)
   ElseIf AllTrim(Type("oXml:_NFE:_INFNFE")) == "O"
       aColsXML := aClone(oXml:_NFE:_INFNFE:_DET)
   ElseIf AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE")) == "O"
       aColsXML := aClone(oXml:_NFEPROC:_NFE:_INFNFE:_DET)
   Else
  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³NAO ENCONTROU NENHUM DAS TAG ACIMA... ENTAO PROCURA A TAG _NFE	 ³
		//³SE ENCONTROU CHAMA NOVAMENTE CabecXmlParser          			 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCount	:=	XmlChildCount(oXml) 
		oXml	:=	XmlGetChild(oXML, nCount)
			***********************************
				ReadTagXml()
			***********************************	
   Endif                                            
   

   If aColsXML == Nil
       nItensXML := 1
   Else
       nItensXML := Len(aColsXML)
   Endif


   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³       VERSAO _INFNFE         |
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If AllTrim(Type("oXml:_INFNFE")) == "O"

       If AllTrim(TYPE("oXml:_INFNFE:_INFADIC:_INFCPL:TEXT"))=="C"
           cInfAdic := AllTrim(oXml:_INFNFE:_INFADIC:_INFCPL:TEXT)
       Endif

	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³		EMITENTE		|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       cEmitNome    :=    AllTrim(oXml:_INFNFE:_EMIT:_NOME:TEXT)
       If oXml:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT  == 'EX'
           cEmitCnpj    :=  'EXTERIOR'
           lImportacao	:=	.T.
       Else
           cEmitCnpj    :=    AllTrim(oXml:_INFNFE:_EMIT:_CNPJ:TEXT)
       EndIf


	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³		DESTINATARIO	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       cDestNome    :=    AllTrim(oXml:_INFNFE:_DEST:_NOME:TEXT)
       If oXML:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT  == 'EX'
       		cDestCnpj    :=    'EXTERIOR'
			lImportacao	:=	.T.
       ElseIf AllTrim(Type("oXml:_INFNFE:_DEST:_CNPJ:TEXT"))=='C'
           cDestCnpj      := AllTrim(oXml:_INFNFE:_DEST:_CNPJ:TEXT)
       Else
           cDestCnpj      := AllTrim(oXml:_INFNFE:_DEST:_CPF:TEXT)
	   Endif
       
        If AllTrim(Type("oXml:_INFNFE:_IDE:_DEMI:TEXT"))=='C'
           cDataNFe    :=    StrTran(oXml:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
        ElseIf AllTrim(Type("oXml:_INFNFE:_IDE:_DHEMI:TEXT"))=='C'
           cDataNFe    :=    Left(StrTran(oXml:_INFNFE:_IDE:_DHEMI:TEXT, "-", "", 10), 08)
        EndIf
       cNotaXML    :=    oXml:_INFNFE:_IDE:_NNF:TEXT
       cSerieXML   :=    oXml:_INFNFE:_IDE:_SERIE:TEXT
       cNatOper    :=    oXml:_INFNFE:_IDE:_NATOP:TEXT


	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ TAG NFREF:_REFNF	 - DEVOLUCAO 		|
	   //| TAG NFREF:_REFECF - CUPOM FISCAL		|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   If AllTrim(Type("oXml:_INFNFE:_IDE:_NFREF")) == "O" 
			If AllTrim(Type("oXml:_INFNFE:_IDE:_NFREF:_REFNF")) == "O" 
				lNFeDev	:= .T.
			EndIf
       EndIf
      

	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       //| 				GERA CHAVE DE ACESSO					| 
	   //³ VERSAO ANTIGAS NAO TINHA A CHAVE DE ACESSO NO XML	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type('oXml:_INFNFE:_ID:TEXT')) != 'C'
           cChaveXML	:=     oXml:_INFNFE:_IDE:_CUF:TEXT                     //  Codigo UF
           // cChaveXML   	+=    SubStr(oXml:_INFNFE:_IDE:_DEMI:TEXT,3,2)+SubStr(oXml:_INFNFE:_IDE:_DEMI:TEXT,6,2)    //    AAMM

           If AllTrim(Type("oXml:_INFNFE:_IDE:_DEMI:TEXT"))=='C'           	   
           	   cChaveXML  +=    SubStr(oXml:_INFNFE:_IDE:_DEMI:TEXT,3,2)+SubStr(oXml:_INFNFE:_IDE:_DEMI:TEXT,6,2)    //    AAMM
           ElseIf AllTrim(Type("oXml:_INFNFE:_IDE:_DHEMI:TEXT"))=='C'               
               cChaveXML  +=    SubStr(oXml:_INFNFE:_IDE:_DHEMI:TEXT,3,2)+SubStr(oXml:_INFNFE:_IDE:_DHEMI:TEXT,6,2)    //    AAMM
           EndIf

           cChaveXML   	+=    AllTrim(oXml:_INFNFE:_EMIT:_CNPJ:TEXT)     		// 	CNPJ do Emitente
           cChaveXML   	+=    '55'												//	Modelo
           cChaveXML   	+=    PadL(oXml:_INFNFE:_IDE:_SERIE:TEXT,3,'0')    	//	Serie
           cChaveXML    +=    PadL(oXml:_INFNFE:_IDE:_NNF:TEXT,9,'0')        	//	Numero da NF-e
           cChaveXML    +=    oXml:_INFNFE:_IDE:_CNF:TEXT                      //	Codigo Numérico

           cChaveXML   	+=    GeraDV(cChaveXML)                                 //	DV

       Else
           cChaveXML    :=    AllTrim(SubStr(oXml:_INFNFE:_ID:TEXT,4,200))
       EndIf


	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	  TIPO FRETE    	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_INFNFE:_TRANSP:_MODFRETE:TEXT"))=='C'
	       cTpFrete    :=    AllTrim(oXml:_INFNFE:_TRANSP:_MODFRETE:TEXT)
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	  TRANSPORTADORA	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT"))=='C'
	       cTranspCgc    :=    AllTrim(oXml:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT)
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	     PLACA          |
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_INFNFE:_TRANSP:_VEICTRANSP:_PLACA:TEXT"))=='C'
	       cPlaca       :=    AllTrim(oXml:_INFNFE:_TRANSP:_VEICTRANSP:_PLACA:TEXT)
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	     ESPECIE        |
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_INFNFE:_TRANSP:_VOL:_ESP:TEXT"))=='C'
	       cEspecie    :=    AllTrim(oXml:_INFNFE:_TRANSP:_VOL:_ESP:TEXT)
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	     VOLUME         |
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT"))=='C'
	       nVolume    :=    Val(AllTrim(oXml:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT))
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³     PESO BRUTO    	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT"))=='C'
	       nPBruto    :=    Val(AllTrim(oXml:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT))
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³     PESO LIQUIDO    	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT"))=='C'
	       nPLiquido    :=    Val(AllTrim(oXml:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT))
	   Endif
	   

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³     VERSAO _NFE:_INFNFE      ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   ElseIf AllTrim(Type("oXml:_NFE:_INFNFE")) == "O"

       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT"))=="C"
           cInfAdic:=AllTrim(oXml:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT)
       Endif


	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³		EMITENTE		|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       cEmitNome    :=    AllTrim(oXml:_NFE:_INFNFE:_EMIT:_XNOME:TEXT)
       If oXml:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT  == 'EX'
           cEmitCnpj    :=    'EXTERIOR'
           lImportacao	:=	.T.
       Else
           cEmitCnpj    :=    AllTrim(oXml:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
       EndIf


	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³		DESTINATARIO	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       cDestNome    :=    AllTrim(oXml:_NFE:_INFNFE:_DEST:_XNOME:TEXT)
       If oXML:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT  == 'EX'
			cDestCnpj    :=    'EXTERIOR'
			lImportacao	:=	.T.
       ElseIf AllTrim(Type("oXml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT"))=='C'
           cDestCnpj      := AllTrim(oXml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
       Else
           cDestCnpj      := AllTrim(oXml:_NFE:_INFNFE:_DEST:_CPF:TEXT)
       Endif

       // cDataNFe    	:=	StrTran( oXml:_NFE:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
       If AllTrim(Type("oXml:_INFNFE:_IDE:_DEMI:TEXT"))=='C'
          cDataNFe    :=    StrTran(oXml:_NFE:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
       ElseIf AllTrim(Type("oXml:_INFNFE:_IDE:_DHEMI:TEXT"))=='C'
          cDataNFe        :=    Left(StrTran(oXml:_NFE:_INFNFE:_IDE:_DHEMI:TEXT, "-", "", 10), 08)
       EndIf


       cNotaXML    	:=	oXml:_NFE:_INFNFE:_IDE:_NNF:TEXT
       cSerieXML    :=	oXml:_NFE:_INFNFE:_IDE:_SERIE:TEXT
       cNatOper    	:=	oXml:_NFE:_INFNFE:_IDE:_NATOP:TEXT
       cChaveXML	:=	AllTrim(SubStr(oXml:_NFE:_INFNFE:_ID:TEXT,4,200))


	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ TAG NFREF:_REFNF	 - DEVOLUCAO 		|
	   //| TAG NFREF:_REFECF - CUPOM FISCAL		|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   If AllTrim(Type("oXml:_NFE:_INFNFE:_IDE:_NFREF")) == "O"
			If AllTrim(Type("oXml:_NFE:_INFNFE:_IDE:_NFREF:_REFNF")) == "O" 
				lNFeDev	:= .T.
			EndIf
       EndIf
       
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	  TIPO FRETE    	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFE:_INFNFE:_TRANSP:_MODFRETE:TEXT"))=='C'
	       cTpFrete    :=    AllTrim(oXml:_NFE:_INFNFE:_TRANSP:_MODFRETE:TEXT)
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	  TRANSPORTADORA	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT"))=='C'
	       cTranspCgc    :=    AllTrim(oXml:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT)
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	     PLACA          |
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFE:_INFNFE:_TRANSP:_VEICTRANSP:_PLACA:TEXT"))=='C'
	       cPlaca       :=    AllTrim(oXml:_NFE:_INFNFE:_TRANSP:_VEICTRANSP:_PLACA:TEXT)
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	     ESPECIE        |
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFE:_INFNFE:_TRANSP:_VOL:_ESP:TEXT"))=='C'
	       cEspecie    :=    AllTrim(oXml:_NFE:_INFNFE:_TRANSP:_VOL:_ESP:TEXT)
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	     VOLUME         |
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT"))=='C'
	       nVolume    :=    Val(AllTrim(oXml:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT))
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³     PESO BRUTO    	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT"))=='C'
	       nPBruto    :=    Val(AllTrim(oXml:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT))
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³     PESO LIQUIDO    	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT"))=='C'
	       nPLiquido    :=    Val(AllTrim(oXml:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT))
	   Endif
	          

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ VERSAO _NFEPROC:_NFE:_INFNFE ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   ElseIf AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE")) == "O"

       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT"))=="C"
           cInfAdic := AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT)
       Endif

	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³		EMITENTE		|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       cEmitNome    :=    AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT)
       If oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT  == 'EX'
           cEmitCnpj    :=    'EXTERIOR'
           lImportacao	:=	.T.
       Else
           cEmitCnpj    :=    AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
       EndIf


	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³		DESTINATARIO	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       cDestNome    :=    AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_DEST:_XNOME:TEXT)
       If oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT  == 'EX'
       		cDestCnpj    :=    'EXTERIOR'
			lImportacao	:=	.T.
       ElseIf AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT"))=='C'
           cDestCnpj      := AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
       Else
           cDestCnpj      := AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT)
       Endif


       cNotaXML    	:=	oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT
       cSerieXML    :=	oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
       cNatOper    	:=	oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT

       If AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT"))=='C'
          cDataNFe  :=    StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
       ElseIf AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT"))=='C'
          cDataNFe  :=    Left(StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT, "-", "", 10), 08)  
       ElseIf AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT"))=='N'
          cDataNFe  :=    StrTran ( oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT , "-", "")         
       EndIf
       
       
       cChaveXML	:=	AllTrim(SubStr(oXml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4,200))

	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ TAG NFREF:_REFNF	 - DEVOLUCAO 		|
	   //| TAG NFREF:_REFECF - CUPOM FISCAL		|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   If AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF")) == "O"
			If AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNF")) == "O" 
				lNFeDev	:= .T.
			EndIf
       EndIf




	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	  TIPO FRETE    	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_MODFRETE:TEXT"))=='C'
	       cTpFrete    :=    AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_MODFRETE:TEXT)
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	  TRANSPORTADORA	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT"))=='C'
	       cTranspCgc    :=    AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT)
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	     PLACA          |
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VEICTRANSP:_PLACA:TEXT"))=='C'
	       cPlaca       :=    AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VEICTRANSP:_PLACA:TEXT)
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	     ESPECIE        |
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_ESP:TEXT"))=='C'
	       cEspecie    :=    AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_ESP:TEXT)
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³	     VOLUME         |
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT"))=='C'
	       nVolume    :=    Val(AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT))
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³     PESO BRUTO    	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT"))=='C'
	       nPBruto    :=    Val(AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT))
	   Endif
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³     PESO LIQUIDO    	|
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT"))=='C'
	       nPLiquido    :=    Val(AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT))
	   Endif

         
   
   Else
	   	lEstrut	:=	.F.
   EndIf


   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ PROBLEMA COM ESTRUTURA DO XML	|
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   Aadd(aRetXML, lEstrut)
   Aadd(aRetXML, IIF(lEstrut, '' , 'ESTRUTURA DO XML INVÁLIDA') )


Else

       If AllTrim(TYPE("oXML:_CTEPROC")) == "O"
			cError := "CT-e. NÃO É POSSIVEL IMPORTAR CONHECIMENTO DE TRANSPORTE ELETRONICO."
	   ElseIf AllTrim(TYPE("oXML:_NFES")) == "O"
   			cError := "NFS-e. NÃO É POSSIVEL IMPORTAR NOTA FISCAL DE SERVIÇO ELETRONICA."
	   Else
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ ERRO NO PARSE - PROBLEMA COM ESTRUTURA DO XML |
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		   nXmlStatus := XMLError()
		   If ( nXmlStatus == XERROR_SUCCESS )
		       If FError() != 0
		           cError	:= "ERRO NO XML - Erro :" +AllTrim(Str(FError())) "
		       Endif
		   Else
		       cError :=	"ERRO NO XML  -  Erro (" + Str( nXmlStatus, 3 ) + ") no XML."
		   EndIf
	   EndIf
	   
   Aadd(aRetXML, .F. )
   Aadd(aRetXML, cError )

EndIf




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 	VERIFICA SE CFOP EH DE DEVOLUCAO		  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lNFeDev .And. aRetXML[1] == .T.

   	Processa( {|| },"Verificando Devolução \ Retorno \ Importação' ",'Processando...', .T.) 
	ProcRegua(nItensXML)
	
   	For nI := 1 To nItensXML
                               
	   	IncProc('Verificando Item '+AllTrim(Str(nI)) +' de '+ AllTrim(Str(nItensXML)) + ' Devolução \ Retorno ' ) 
		
		cCFOP := ''

		If AllTrim(Type("oXml:_INFNFE")) == "O"
			If nItensXML > 1
				cCfOp	:=	oXml:_INFNFE:_DET[nI]:_PROD:_CFOP:TEXT
			Else
				cCfOp	:=	oXml:_INFNFE:_DET:_PROD:_CFOP:TEXT
			EndIf
			
		ElseIf AllTrim(Type("oXml:_NFE:_INFNFE")) == "O"
			If nItensXML > 1
			   cCFOP	:=	oXml:_NFE:_INFNFE:_DET[nI]:_PROD:_CFOP:TEXT
			Else
			    cCFOP  	:=	oXml:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT
			EndIf
		
		ElseIf AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE")) == "O"
		   	If nItensXML > 1
		       cCFOP   	:=	oXml:_NFEPROC:_NFE:_INFNFE:_DET[nI]:_PROD:_CFOP:TEXT
			Else
			   cCFOP  	:=	oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT
			Endif
		
		EndIf
		
        // DEVOLUCAO
		cDevCFOP := '5201/5202/5208/5209/5210'
		cDevCFOP += '5410/5411/5412/5413/5503/5553/5555/5556/5660/5661/5662/5918/5919/5921'
		cDevCFOP += '6201/6202/6208/6209/6210/'
		cDevCFOP += '6410/6411/6412/6413/6503/6553/6555/6556/6660/6661/6662/6918/6919/6921/7201/7202/7210/7211'
		cDevCFOP += '7553/7556/7930'
		                            
		//	REMESSA PARA INDUSTRIALIZACAO
		// 5915                                                                                 
		// 6915                                                                                           
		// 5920
		cRemCFOP :=	'5414/5415/5451/5501/5502/5554/5657/5663/5901/5904/5905/5908/5910/5911/5912/5914/5917/5923/5924'
		cRemCFOP +=	'6414/6415/6501/6502/6554/6657/6663/6901/6904/6905/6908/6910/6911/6912/6914/6917/6920/6923/6924'
		cRemCFOP +=	'6414'
		cRemCFOP +=	'5915/6915'
                   
		cRessCFOP := '6603'

		// SE CONTEM A TAG NFREF E NAO FOR DEVOLUCAO... CASO DE RETORNO DE CONSERTO. (PESQUISA PELO FORNECEDOR)
		If (cCFOP $ cDevCFOP) .Or. (cCFOP $ cRemCFOP) .Or. (cCFOP $ cRessCFOP)
			lNFeDev := .T.
			Exit
		Else
			lNFeDev := .F.
		EndIf
		    
    Next
    
EndIf



Return(aRetXML)
************************************************************
Static Function ItemXmlParser(i)
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE XML - ITENS                ³
//³ Chamada -> CabecXmlParser()     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static cProdFor    	:=    ''
Static cDescrProd	:=    ''
Static cCfOP    	:=    ''
Static cEAN			:=    ''
Static cNCM			:=    ''
Static cUM          :=    ''
Static nQuant       :=    0
Static nPreco       :=    0
Static nTotal       :=    0
Static nDescont    	:=    0


If AllTrim(Type("oXml:_INFNFE")) == "O"

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³       VERSAO _INFNFE         |
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nItensXML > 1

       	cProdFor	:=	oXml:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT
       	cDescrProd	:=  oXml:_INFNFE:_DET[i]:_PROD:_PROD:TEXT
		nQuant		:= 	Val(oXml:_INFNFE:_DET[i]:_PROD:_QCOM:TEXT)
       	cUM         :=	oXml:_INFNFE:_DET[i]:_PROD:_UCOM:TEXT
	  
	   	cEAN		:=	IIF(AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_CEAN:TEXT"))=="C", oXml:_INFNFE:_DET[i]:_PROD:_CEAN:TEXT,'')
	   	cNCM		:=	IIF(AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_NCM:TEXT"))=="C", oXml:_INFNFE:_DET[i]:_PROD:_NCM:TEXT,'')
	   		                                                         
	   	cCfOp		:=	oXml:_INFNFE:_DET[i]:_PROD:_CFOP:TEXT
	   		
      	If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_VDESC:TEXT"))=="C"
       	    nDescont :=	Val(oXml:_INFNFE:_DET[i]:_PROD:_VDESC:TEXT)
       	Else
       		nDescont := 0
       	Endif
		
      	nPreco      :=	Val(oXml:_INFNFE:_DET[i]:_PROD:_VUNCOM:TEXT)
       	nTotal      := 	Val(oXml:_INFNFE:_DET[i]:_PROD:_VPROD:TEXT)
       	cNotaXML	:= 	oXml:_INFNFE:_IDE:_NNF:TEXT
       	cSerieXML   := 	oXml:_INFNFE:_IDE:_SERIE:TEXT
       	cNatOper    := 	oXml:_INFNFE:_IDE:_NATOP:TEXT
       	//cDataNFe    := 	StrTran(oXml:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
       	If AllTrim(Type("oXml:_INFNFE:_IDE:_DEMI:TEXT"))=='C'
           cDataNFe :=    StrTran(oXml:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
        ElseIf AllTrim(Type("oXml:_INFNFE:_IDE:_DHEMI:TEXT"))=='C'
           cDataNFe :=    Left(StrTran(oXml:_INFNFE:_IDE:_DHEMI:TEXT, "-", "", 10), 08)
        EndIf


       If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_ADI:_NADICAO:TEXT"))=="C"
			_nAdicao := Val(oXml:_INFNFE:_DET[i]:_PROD:_DI:_ADI:_NADICAO:TEXT)
	   Endif                
       If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_ADI:_NSEQADIC:TEXT"))=="C"
			_nSeq := Val(oXml:_INFNFE:_DET[i]:_PROD:_DI:_ADI:_NSEQADIC:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_ADI:_CFABRICANTE:TEXT"))=="C"
			_cFabri := oXml:_INFNFE:_DET[i]:_PROD:_DI:_ADI:_CFABRICANTE:TEXT
	   Endif  
       If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_CEXPORTADOR:TEXT"))=="C"
			_cExpt := oXml:_INFNFE:_DET[i]:_PROD:_DI:_CEXPORTADOR:TEXT 
	   Endif  
	   If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_DDESEMB:TEXT"))=="C" .And. Empty(_dDtDesemb)
			_dDtDesemb := StoD(StrTran(oXml:_INFNFE:_DET[i]:_PROD:_DI:_DDESEMB:TEXT, '-','',10))
	   Endif
	   If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_DDI:TEXT"))=="C" .And. Empty(_dDtDI)
			_dDtDI := StoD(StrTran(oXml:_INFNFE:_DET[i]:_PROD:_DI:_DDI:TEXT, '-','',10))
	   Endif
	   If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_NDI:TEXT"))=="C" .And. Empty(_cNumDI)
			_cNumDI := oXml:_INFNFE:_DET[i]:_PROD:_DI:_NDI:TEXT
	   Endif
	   If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_UFDESEMB:TEXT"))=="C" .And. Empty(_cUFDesemb)
			_cUFDesemb := oXml:_INFNFE:_DET[i]:_PROD:_DI:_UFDESEMB:TEXT
	   Endif
	   If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_XLOCDESEMB:TEXT"))=="C" .And. Empty(_cLocDesemb)
			_cLocDesemb := oXml:_INFNFE:_DET[i]:_PROD:_DI:_XLOCDESEMB:TEXT
	   Endif

								
       If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_II:_VBC:TEXT"))=="C"
			_nXBCII := Val(oXml:_INFNFE:_DET[i]:_IMPOSTO:_II:_VBC:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_II:_VII:TEXT"))=="C"
			_nXValII := Val(oXml:_INFNFE:_DET[i]:_IMPOSTO:_II:_VII:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_II:_VDESPADU:TEXT"))=="C"
			_nDespac := Val(oXml:_INFNFE:_DET[i]:_IMPOSTO:_II:_VDESPADU:TEXT)
	   Endif 
       If AllTrim(TYPE("oXml:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_II:_VIOF:TEXT"))=="C"
			_nXValIOF := Val(oXml:_INFNFE:_DET[i]:_IMPOSTO:_II:_VIOF:TEXT)
       Endif


   Else                                                                            
   
       cProdFor		:= 	oXml:_INFNFE:_DET:_PROD:_CPROD:TEXT
       cDescrProd	:=	oXml:_INFNFE:_DET:_PROD:_PROD:TEXT
       nQuant		:=	Val(oXml:_INFNFE:_DET:_PROD:_QCOM:TEXT)
       cUM			:=	oXml:_INFNFE:_DET:_PROD:_UCOM:TEXT

   	   cEAN			:=	IIF(AllTrim(TYPE("oXml:_INFNFE:_DET:_PROD:_CEAN:TEXT"))=="C", oXml:_INFNFE:_DET:_PROD:_CEAN:TEXT,'')
	   cNCM			:=	IIF(AllTrim(TYPE("oXml:_INFNFE:_DET:_PROD:_NCM:TEXT"))=="C", oXml:_INFNFE:_DET:_PROD:_NCM:TEXT,'')
	              
	   cCfOp		:=		oXml:_INFNFE:_DET:_PROD:_CFOP:TEXT
	   
       If AllTrim(TYPE("oXml:_INFNFE:_DET:_PROD:_VDESC:TEXT"))=="C"
       		nDescont := Val(oXml:_INFNFE:_DET:_PROD:_VDESC:TEXT)
       Else
       		nDescont := 0
       Endif

       nPreco   	:=	Val(oXml:_INFNFE:_DET:_PROD:_VUNCOM:TEXT)
       nTotal   	:=	Val(oXml:_INFNFE:_DET:_PROD:_VPROD:TEXT)
       cNotaXML 	:=	oXml:_INFNFE:_IDE:_NNF:TEXT
       cSerieXML	:=	oXml:_INFNFE:_IDE:_SERIE:TEXT
       cNatOper	 	:=	oXml:_INFNFE:_IDE:_NATOP:TEXT
       // cDataNFe 	:= 	StrTran(oXml:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
       If AllTrim(Type("oXml:_INFNFE:_IDE:_DEMI:TEXT"))=='C'
          cDataNFe  :=    StrTran(oXml:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
       ElseIf AllTrim(Type("oXml:_INFNFE:_IDE:_DHEMI:TEXT"))=='C'
          cDataNFe  :=    Left(StrTran(oXml:_INFNFE:_IDE:_DHEMI:TEXT, "-", "", 10), 08)
       EndIf
       
       If AllTrim(TYPE("oXml:_INFNFE:_DET:_PROD:_DI:_ADI:_NADICAO:TEXT"))=="C"
			_nAdicao := Val(oXml:_INFNFE:_DET:_PROD:_DI:_ADI:_NADICAO:TEXT)
	   Endif                
       If AllTrim(TYPE("oXml:_INFNFE:_DET:_PROD:_DI:_ADI:_NSEQADIC:TEXT"))=="C"
			_nSeq := Val(oXml:_INFNFE:_DET:_PROD:_DI:_ADI:_NSEQADIC:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_INFNFE:_DET:_PROD:_DI:_ADI:_CFABRICANTE:TEXT"))=="C"
			_cFabri := oXml:_INFNFE:_DET:_PROD:_DI:_ADI:_CFABRICANTE:TEXT
	   Endif  
       If AllTrim(TYPE("oXml:_INFNFE:_DET:_PROD:_DI:_CEXPORTADOR:TEXT"))=="C"
			_cExpt := oXml:_INFNFE:_DET:_PROD:_DI:_CEXPORTADOR:TEXT 
	   Endif  
	   If AllTrim(TYPE("oXml:_INFNFE:_DET:_PROD:_DI:_DDESEMB:TEXT"))=="C" .And. Empty(_dDtDesemb)
			_dDtDesemb := StoD(StrTran(oXml:_INFNFE:_DET:_PROD:_DI:_DDESEMB:TEXT,'-','',10))
	   Endif
	   If AllTrim(TYPE("oXml:_INFNFE:_DET:_PROD:_DI:_DDI:TEXT"))=="C" .And. Empty(_dDtDI)
			_dDtDI := StoD(StrTran(oXml:_INFNFE:_DET:_PROD:_DI:_DDI:TEXT, '-','',10)) 
	   Endif
	   If AllTrim(TYPE("oXml:_INFNFE:_DET:_PROD:_DI:_NDI:TEXT"))=="C" .And. Empty(_cNumDI)
			_cNumDI := oXml:_INFNFE:_DET:_PROD:_DI:_NDI:TEXT
	   Endif
	   If AllTrim(TYPE("oXml:_INFNFE:_DET:_PROD:_DI:_UFDESEMB:TEXT"))=="C" .And. Empty(_cUFDesemb)
			_cUFDesemb := oXml:_INFNFE:_DET:_PROD:_DI:_UFDESEMB:TEXT
	   Endif
	   If AllTrim(TYPE("oXml:_INFNFE:_DET:_PROD:_DI:_XLOCDESEMB:TEXT"))=="C" .And. Empty(_cLocDesemb)
			_cLocDesemb := oXml:_INFNFE:_DET:_PROD:_DI:_XLOCDESEMB:TEXT
	   Endif

 
       If AllTrim(TYPE("oXml:_INFNFE:_DET:_IMPOSTO:_II:_VBC:TEXT"))=="C"
			_nXBCII := Val(oXml:_INFNFE:_DET:_IMPOSTO:_II:_VBC:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_INFNFE:_DET:_IMPOSTO:_II:_VII:TEXT"))=="C"
			_nXValII := Val(oXml:_INFNFE:_DET:_IMPOSTO:_II:_VII:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_INFNFE:_DET:_IMPOSTO:_II:_VDESPADU:TEXT"))=="C"
			_nDespac := Val(oXml:_INFNFE:_DET:_IMPOSTO:_II:_VDESPADU:TEXT)
	   Endif 
       If AllTrim(TYPE("oXml:_INFNFE:_DET:_IMPOSTO:_II:_VIOF:TEXT"))=="C"
			_nXValIOF := Val(oXml:_INFNFE:_DET:_IMPOSTO:_II:_VIOF:TEXT)
	   Endif
	   
	          
   Endif                
   

ElseIf AllTrim(Type("oXml:_NFE:_INFNFE")) == "O"
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³    VERSAO _NFE:_INFNFE       |
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nItensXML > 1
       cProdFor 	:= 	oXml:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT
       cDescrProd 	:= 	oXml:_NFE:_INFNFE:_DET[i]:_PROD:_XPROD:TEXT
       nQuant   	:=	Val(oXml:_NFE:_INFNFE:_DET[i]:_PROD:_QCOM:TEXT)
       cUM 			:=	oXml:_NFE:_INFNFE:_DET[i]:_PROD:_UCOM:TEXT

	   cEAN			:=	IIF(AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_CEAN:TEXT"))=="C", oXml:_NFE:_INFNFE:_DET[i]:_PROD:_CEAN:TEXT,'')
	   cNCM			:=	IIF(AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_NCM:TEXT"))=="C", oXml:_NFE:_INFNFE:_DET[i]:_PROD:_NCM:TEXT,'')
	   	                                                           
	   cCFOP		:=	oXml:_NFE:_INFNFE:_DET[i]:_PROD:_CFOP:TEXT
	   	          
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_VDESC:TEXT"))=="C"
           nDescont := Val(oXml:_NFE:_INFNFE:_DET[i]:_PROD:_VDESC:TEXT)
       Else
       		nDescont := 0
       Endif

       nPreco      	:=	Val(oXml:_NFE:_INFNFE:_DET[i]:_PROD:_VUNCOM:TEXT)
       nTotal      	:=	Val(oXml:_NFE:_INFNFE:_DET[i]:_PROD:_VPROD:TEXT)
       cNotaXML    	:=	oXml:_NFE:_INFNFE:_IDE:_NNF:TEXT
       cSerieXML    :=	oXml:_NFE:_INFNFE:_IDE:_SERIE:TEXT
       cNatOper    	:=	oXml:_NFE:_INFNFE:_IDE:_NATOP:TEXT
       //cDataNFe 	:=	StrTran(oXml:_NFE:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
       If AllTrim(Type("oXml:_INFNFE:_IDE:_DEMI:TEXT"))=='C'
          cDataNFe  :=    StrTran(oXml:_NFE:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
       ElseIf AllTrim(Type("oXml:_INFNFE:_IDE:_DHEMI:TEXT"))=='C'
          cDataNFe  :=    Left(StrTran(oXml:_NFE:_INFNFE:_IDE:_DHEMI:TEXT, "-", "", 10), 08)
       EndIf


       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_ADI:_NADICAO:TEXT"))=="C"
			_nAdicao := Val(oXml:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_ADI:_NADICAO:TEXT)
	   Endif                
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_ADI:_NSEQADIC:TEXT"))=="C"
			_nSeq := Val(oXml:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_ADI:_NSEQADIC:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_ADI:_CFABRICANTE:TEXT"))=="C"
			_cFabri := oXml:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_ADI:_CFABRICANTE:TEXT
	   Endif  
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_CEXPORTADOR:TEXT"))=="C"
			_cExpt := oXml:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_CEXPORTADOR:TEXT 
	   Endif  
	   If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_DDESEMB:TEXT"))=="C" .And. Empty(_dDtDesemb)
			_dDtDesemb := StoD(StrTran(oXml:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_DDESEMB:TEXT,'-','',10))
	   Endif
	   If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_DDI:TEXT"))=="C" .And. Empty(_dDtDI)
			_dDtDI := StoD(StrTran(oXml:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_DDI:TEXT, '-','',10))
	   Endif
	   If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_NDI:TEXT"))=="C" .And. Empty(_cNumDI)
			_cNumDI := oXml:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_NDI:TEXT
	   Endif
	   If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_UFDESEMB:TEXT"))=="C" .And. Empty(_cUFDesemb)
			_cUFDesemb := oXml:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_UFDESEMB:TEXT
	   Endif
	   If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_XLOCDESEMB:TEXT"))=="C" .And. Empty(_cLocDesemb)
			_cLocDesemb := oXml:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_XLOCDESEMB:TEXT
	   Endif


       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_II:_VBC:TEXT"))=="C"
			_nXBCII := Val(oXml:_NFE:_INFNFE:_DET[i]:_IMPOSTO:_II:_VBC:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_II:_VII:TEXT"))=="C"
			_nXValII := Val(oXml:_NFE:_INFNFE:_DET[i]:_IMPOSTO:_II:_VII:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_II:_VDESPADU:TEXT"))=="C"
			_nDespac := Val(oXml:_NFE:_INFNFE:_DET[i]:_IMPOSTO:_II:_VDESPADU:TEXT)
	   Endif 
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_II:_VIOF:TEXT"))=="C"
			_nXValIOF := Val(oXml:_NFE:_INFNFE:_DET[i]:_IMPOSTO:_II:_VIOF:TEXT)
	   Endif
	   	   

	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³    	IMPOSTOS       |
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS:TEXT"))=="C"
			nAliqCof := Val(oXml:_NFE:_INFNFE:_DET[i]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS:TEXT)
	   Endif
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC:TEXT"))=="C"
			nBaseCof := Val(oXml:_NFE:_INFNFE:_DET[i]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC:TEXT)
	   Endif
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS:TEXT"))=="C"
			nValorCof := Val(oXml:_NFE:_INFNFE:_DET[i]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS:TEXT)
	   Endif

		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_ICMS:_ICMS00:_PICMS:TEXT
		For nX := 1 To 10
			If Type("oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_ICMS:_ICMS"+"00"+":_PICMS:TEXT" ) == "U"
		Next
*/
		
		/*
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_ICMS:_ICMS00:_PICMS:TEXT
		18.00
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_ICMS:_ICMS00:_VBC:TEXT
		2237.33
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT
		402.72
		
		
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_II:_VBC:TEXT
		1281.05
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_II:_VDESPADU:TEXT
		4.03
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_II:_VII:TEXT
		230.59
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_II:_VIOF:TEXT
		0.00
		
		
		
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT
		10.00
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_IPI:_IPITRIB:_VBC:TEXT
		1511.64
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT
		151.16
		
		
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_PIS:_PISALIQ:_PPIS:TEXT
		1.65
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_PIS:_PISALIQ:_VBC:TEXT
		1813.83
		oXml:_NFE:_INFNFE:_DET[1]:_IMPOSTO:_PIS:_PISALIQ:_VPIS:TEXT
		29.93
		
		
		oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT
		174184.59
		
		*/

      
   Else
 
       cProdFor   	:= 	oXml:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT
       cDescrProd	:=	oXml:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT
       nQuant    	:= 	Val(oXml:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)
       cUM         	:=	oXml:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT
       
	   cEAN			:=	IIF(AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_PROD:_CEAN:TEXT"))=="C", oXml:_NFE:_INFNFE:_DET:_PROD:_CEAN:TEXT,'')
	   cNCM			:=	IIF(AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT"))=="C", oXml:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT,'')
	   	   
       cCFOP      	:=	oXml:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT
       
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_PROD:_VDESC:TEXT"))=="C"
           nDescont := Val(oXml:_NFE:_INFNFE:_DET:_PROD:_VDESC:TEXT)
       Else
       		nDescont := 0
       Endif


       nPreco    	:= 	Val(oXml:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT)
       nTotal     	:= 	Val(oXml:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT)
       cNotaXML    	:= 	oXml:_NFE:_INFNFE:_IDE:_NNF:TEXT
       cSerieXML    := 	oXml:_NFE:_INFNFE:_IDE:_SERIE:TEXT
       cNatOper    	:= 	oXml:_NFE:_INFNFE:_IDE:_NATOP:TEXT
       //cDataNFe     := 	StrTran(oXml:_NFE:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)

        If AllTrim(Type("oXml:_INFNFE:_IDE:_DEMI:TEXT"))=='C'
           cDataNFe :=    StrTran(oXml:_NFE:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
        ElseIf AllTrim(Type("oXml:_INFNFE:_IDE:_DHEMI:TEXT"))=='C'
           cDataNFe :=    Left(StrTran(oXml:_NFE:_INFNFE:_IDE:_DHEMI:TEXT, "-", "", 10), 08)
        EndIf


       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_ADI:_NADICAO:TEXT"))=="C"
			_nAdicao := Val(oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_ADI:_NADICAO:TEXT)
	   Endif                
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_ADI:_NSEQADIC:TEXT"))=="C"
			_nSeq := Val(oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_ADI:_NSEQADIC:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_ADI:_CFABRICANTE:TEXT"))=="C"
			_cFabri := oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_ADI:_CFABRICANTE:TEXT
	   Endif  
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_CEXPORTADOR:TEXT"))=="C"
			_cExpt := oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_CEXPORTADOR:TEXT 
	   Endif  
	   If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_DDESEMB:TEXT"))=="C" .And. Empty(_dDtDesemb)
			_dDtDesemb := StoD(StrTran(oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_DDESEMB:TEXT, '-','',10))
	   Endif
	   If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_DDI:TEXT"))=="C" .And. Empty(_dDtDI)
			_dDtDI := StoD(StrTran(oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_DDI:TEXT, '-','',10))
	   Endif
	   If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_NDI:TEXT"))=="C" .And. Empty(_cNumDI)
			_cNumDI := oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_NDI:TEXT
	   Endif
	   If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_UFDESEMB:TEXT"))=="C" .And. Empty(_cUFDesemb)
			_cUFDesemb := oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_UFDESEMB:TEXT
	   Endif
	   If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_XLOCDESEMB:TEXT"))=="C" .And. Empty(_cLocDesemb)
			_cLocDesemb := oXml:_NFE:_INFNFE:_DET:_PROD:_DI:_XLOCDESEMB:TEXT
	   Endif
								

       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VBC:TEXT"))=="C"
			_nXBCII := Val(oXml:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VBC:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VII:TEXT"))=="C"
			_nXValII := Val(oXml:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VII:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VDESPADU:TEXT"))=="C"
			_nDespac := Val(oXml:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VDESPADU:TEXT)
	   Endif 
       If AllTrim(TYPE("oXml:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VIOF:TEXT"))=="C"
			_nXValIOF := Val(oXml:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VIOF:TEXT)
	   Endif

   Endif


ElseIf AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE")) == "O"
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ VERSAO _NFEPROC:_NFE:_INFNFE |
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nItensXML > 1

       cProdFor		:= 	oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CPROD:TEXT
       cDescrProd	:= 	oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_XPROD:TEXT
       nQuant    	:= 	Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_QCOM:TEXT)
       nPreco     	:=	Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_VUNCOM:TEXT)
       cUM        	:=	oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_UCOM:TEXT
       
	   cEAN			:=	IIF(AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_CEAN:TEXT"))=="C", oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CEAN:TEXT,'')
	   cNCM			:=	IIF(AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_NCM:TEXT"))=="C", oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_NCM:TEXT,'')

       cCFOP       	:=	oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_CFOP:TEXT
	   	   
       If AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_VDESC:TEXT"))=="C"
           nDescont :=	Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_VDESC:TEXT)
       Else
       		nDescont := 0
       Endif

       nTotal		:=	Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_VPROD:TEXT)
       cNotaXML    	:= 	oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT
       cSerieXML    :=	oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
       cNatOper    	:=	oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT
       //cDataNFe     :=	StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
       If AllTrim(Type("oXml:_INFNFE:_IDE:_DEMI:TEXT"))=='C'
          cDataNFe :=    StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
       ElseIf AllTrim(Type("oXml:_INFNFE:_IDE:_DHEMI:TEXT"))=='C'
          cDataNFe :=    Left(StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT, "-", "", 10), 08)
       EndIf


       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_ADI:_NADICAO:TEXT"))=="C"
			_nAdicao := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_ADI:_NADICAO:TEXT)
	   Endif                
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_ADI:_NSEQADIC:TEXT"))=="C"
			_nSeq := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_ADI:_NSEQADIC:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_ADI:_CFABRICANTE:TEXT"))=="C"
			_cFabri := oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_ADI:_CFABRICANTE:TEXT
	   Endif  
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_CEXPORTADOR:TEXT"))=="C"
			_cExpt := oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_CEXPORTADOR:TEXT 
	   Endif  
	   If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_DDESEMB:TEXT"))=="C" .And. Empty(_dDtDesemb)
			_dDtDesemb := StoD(StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_DDESEMB:TEXT, '-','',10))
	   Endif
	   If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_DDI:TEXT"))=="C" .And. Empty(_dDtDI)
			_dDtDI := StoD(StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_DDI:TEXT, '-','',10))
	   Endif
	   If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_NDI:TEXT"))=="C" .And. Empty(_cNumDI)
			_cNumDI := oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_NDI:TEXT
	   Endif
	   If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_UFDESEMB:TEXT"))=="C" .And. Empty(_cUFDesemb)
			_cUFDesemb := oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_UFDESEMB:TEXT
	   Endif
	   If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_PROD:_DI:_XLOCDESEMB:TEXT"))=="C" .And. Empty(_cLocDesemb)
			_cLocDesemb := oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_PROD:_DI:_XLOCDESEMB:TEXT
	   Endif
	   								
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_II:_VBC:TEXT"))=="C"
			_nXBCII := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_IMPOSTO:_II:_VBC:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_II:_VII:TEXT"))=="C"
			_nXValII := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_IMPOSTO:_II:_VII:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_II:_VDESPADU:TEXT"))=="C"
			_nDespac := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_IMPOSTO:_II:_VDESPADU:TEXT)
	   Endif 
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET["+AllTrim(Str(i))+"]:_IMPOSTO:_II:_VIOF:TEXT"))=="C"
			_nXValIOF := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET[i]:_IMPOSTO:_II:_VIOF:TEXT)
	   Endif


	Else

       cProdFor    	:=	oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT
       cDescrProd	:=	oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT
       nQuant    	:=	Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)
       cUM          :=	oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT
       
	   cEAN			:=	IIF(AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CEAN:TEXT"))=="C", oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CEAN:TEXT,'')
	   cNCM			:=	IIF(AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT"))=="C", oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT,'')

       cCFOP        :=	oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT
	   	   
       If AllTrim(Type("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VDESC:TEXT"))=="C"
           nDescont :=	Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VDESC:TEXT)
       Else
       		nDescont := 0
       Endif

       nPreco   	:=	Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT)
       nTotal    	:= 	Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT)
       cNotaXML   	:=	oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT
       cSerieXML    :=	oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
       cNatOper    	:=	oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT
       //cDataNFe     :=	StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
       If AllTrim(Type("oXml:_INFNFE:_IDE:_DEMI:TEXT"))=='C'
          cDataNFe  :=    StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT, "-", "", 10)
       ElseIf AllTrim(Type("oXml:_INFNFE:_IDE:_DHEMI:TEXT"))=='C'
          cDataNFe  :=    Left(StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT, "-", "", 10), 08)
       EndIf


       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_ADI:_NADICAO:TEXT"))=="C"
			_nAdicao := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_ADI:_NADICAO:TEXT)
	   Endif                
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_ADI:_NSEQADIC:TEXT"))=="C"
			_nSeq := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_ADI:_NSEQADIC:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_ADI:_CFABRICANTE:TEXT"))=="C"
			_cFabri := oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_ADI:_CFABRICANTE:TEXT
	   Endif  
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_CEXPORTADOR:TEXT"))=="C"
			_cExpt := oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_CEXPORTADOR:TEXT 
	   Endif  
	   If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_DDESEMB:TEXT"))=="C" .And. Empty(_dDtDesemb)
			_dDtDesemb := StoD(StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_DDESEMB:TEXT, '-','',10))
	   Endif
	   If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_DDI:TEXT"))=="C" .And. Empty(_dDtDI)
			_dDtDI := StoD(StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_DDI:TEXT, '-','',10))
	   Endif
	   If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_NDI:TEXT"))=="C" .And. Empty(_cNumDI)
			_cNumDI := oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_NDI:TEXT
	   Endif
	   If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_UFDESEMB:TEXT"))=="C" .And. Empty(_cUFDesemb)
			_cUFDesemb := oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_UFDESEMB:TEXT
	   Endif
	   If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_XLOCDESEMB:TEXT"))=="C" .And. Empty(_cLocDesemb)
			_cLocDesemb := oXml:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_DI:_XLOCDESEMB:TEXT
	   Endif

       
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VBC:TEXT"))=="C"
			_nXBCII := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VBC:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VII:TEXT"))=="C"
			_nXValII := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VII:TEXT)
	   Endif  
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VDESPADU:TEXT"))=="C"
			_nDespac := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VDESPADU:TEXT)
	   Endif 
       If AllTrim(TYPE("oXml:_NFEPROC:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VIOF:TEXT"))=="C"
			_nXValIOF := Val(oXml:_NFEPROC:_NFE:_INFNFE:_DET:_IMPOSTO:_II:_VIOF:TEXT)
	   Endif
	   
	   
   Endif

Endif

   

Return()
************************************************************
Static Function View_XML()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Visualiza arquivo XML no Broswer                |
//³ Chamada -> Visual_XML()                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cMsgMotivo := ''

DbSelectArea('ZXM')

cArqViewXml  := GetTempPath()+AllTrim(ZXM->ZXM_CHAVE)+'.XML'    //    DIRETORIO TEMPORARIO WINDOWS
MemoWrit(AllTrim(cArqViewXml), AllTrim(ZXM->ZXM_XML) )
Aadd(aArqTemp, cArqViewXml)

MsgRun("Aguarde... Abrindo XML...",,{|| ShellExecute("open",cArqViewXml,"","",1) } )

Return()
************************************************************
Static Function MsgInfCpl()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Visualiza Mensagem do XML                      |
//³ Chamada -> Visual_XML()                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oFont     := TFont():New( "Arial",0,-12,,.T.,0,,700,.F.,.F.,,,,,, )

Define MsDialog oMensNF From 0,0 To 290,415 Pixel Title "Mensagem da Nota Fiscal"
@ 005,005 Get oMemo Var cInfAdic Memo Size 200,135 FONT oFont Pixel Of oMensNF
Activate MsDialog oMensNF Center

Return()
************************************************************
Static Function HistFornec()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Visualiza Historico do Fornecedor   |
//³ Chamada -> Visual_XML()             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aArea3_4  := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³    Historico do Fornecedor      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea('ZXM')
cCadastro := 'Histórico Fornecedor'

aRotina2  :=    {  	{"Perdas",					"U_PR_PERD()", 	0,2},;
                   	{"Trocas Produtos",       	"U_PR_TRO()", 	0,2},;
                   	{"Divergências Pedidos",    "U_PR_DIV()", 	0,2},;
                   	{"Pedidos com cortes",     	"U_PR_COR()", 	0,2},;
                   	{"Pedidos Não Entregues", 	"U_PR_NAO()", 	0,2},;
                   	{"Saldos por Grupo",		"U_PR_SALG()",	0,2}}

aRotina   :=    { 	{"Pesquisar",             	'AxPesqui',		00,01},;
					{"Comprar",           		'U_PR_COM()',	00,08},;
	                {"TOTALizar",         		'U_PR_TOT()',	00,03},;
	    			{"Gerar Pedidos",          	'U_PR_PED()',	00,08},;
	    			{"F4-Histórico",       		'U_PR_HIS()',	00,08},;
                  	{"Consultas",               aRotina2,		00,02,0 ,Nil},;
                  	{"Sugestão",               	'U_PR_SUG()' ,	00,06},;
                  	{"Preço Família",         	'U_PR_FAM()',	00,07},;
                  	{"Incluir Produto",     	'U_PR_INCP()',	00,07},;
                  	{"Fora de Linha",        	'U_PR_FORL()',	00,07},;
                  	{"Legenda",           		'U_PR_LEG()',	00,09}}
	
If Pergunte("FIC030",.T.)
   ALTERA   	:=	.T.
   INCLUI  		:= 	.F.
   LF030TITAB	:=	.F.
   LF030TITPG	:=	.F.
   NVLGERALNF	:=	0
   LF030TITCOM  :=  .F.
   LF030TITFAT 	:=	.F.    
   FC030CON(ZXM->ZXM_FORNEC,ZXM->ZXM_LOJA)
EndIf

RestArea(aArea3_4)
Return()
************************************************************
Static Function MostraCadFor(SA2Recno)
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Visualiza Cadastro do Fornecedor|
//³ Chamada -> Visual_XML()         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aArea3_5    :=	GetArea()
cCadastro	:=	'Fornecedor'
cAlias    	:=	'SA2'
nReg        :=	SA2Recno
nOpc        :=	2


DbselectArea('SA2');DbGoTo(nReg)
AxVisual( cAlias, nReg, nOpc,,,,,)


RestArea(aArea3_5)
Return()
************************************************************
Static Function MostraCadCli(SA2Recno)
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Visualiza Cadastro do Cliente 	|
//³ Chamada -> Visual_XML()         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aArea3_5    :=	GetArea()
cCadastro	:=	'Cliente'
cAlias    	:=	'SA1'
nReg        :=	SA2Recno
nOpc        :=	2

DbselectArea('SA1');DbGoTo(nReg)
AxVisual( cAlias, nReg, nOpc,,,,,)


RestArea(aArea3_5)
Return()
************************************************************
Static Function VisualNFE()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|	Quando ja foi gerado o Doc.Entrada do XML  apenas	|
//³ Visualiza Pre-Nota\Doc.Entrada  					|
//³ Chamada -> Visual_XML()         					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea3_6  := GetArea()

DbSelectArea('ZXM')                
cSF1Chave := IIF(ZXM->ZXM_FORMUL!='S', ZXM->ZXM_DOC+ZXM->ZXM_SERIE, ZXM->ZXM_DOCREF+ZXM->ZXM_SERREF) + ZXM->ZXM_FORNEC + ZXM->ZXM_LOJA

DbSelectArea('SF1');DbSetOrder()
If DbSeek(xFilial('SF1')+ cSF1Chave , .F.)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³    VISUALIZA NOTA FISCAL        ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   MsgRun("Localizando "+IIF(cPreDoc=='PRE',"PRÉ NOTA","DOC.ENTRADA")+" para VISUALIZAÇÃO...",,{|| A103NFiscal('SF1',,1)  } )

Endif

RestArea(aArea3_6)
Return()
*****************************************************************
Static Function GeraPreDoc()
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Pre-Nota\Doc.Entrada       |
//³ Chamada -> Visual_XML()         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea3_7  	:=	GetArea()
Local cCondPag   	:= 	Space(3)
Local cDuplic		:=	Space(1)
Local _cNatureza	:=	TamSx3('A2_NATUREZ')[1]
Local cNaoIdent  	:=	''
Local cUfOrig    	:=	''
Local cPedCom    	:=	''
Local aCabec    	:=	{}
Local aItens    	:=	{}
Local aLinha    	:=	{}
Local cRet       	:=	.F.
Local lMsErroAuTo	:=	.F.
Local lRetorno    	:=	.F.
Local lRet 			:= 	.F.
Local lCondPag		:=	.F.
Local lTelaCond 	:= 	.F.
Local nPosItem   	:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_ITEM'   })
Local nPosPFor   	:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'C7_PRODUTO'})
Local nPosProd   	:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_COD'    })
Local nPosLocal  	:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_LOCAL'	 })
Local nPosQuant  	:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_QUANT'	 })
Local nPosVunit  	:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_VUNIT'	 })
Local nPosDesc   	:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_DESC'   })
Local nPosTotal  	:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_TOTAL'	 })
Local nPosPC     	:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_PEDIDO' })
Local nPosPCItem 	:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_ITEMPC' })
Local nPosTES		:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_TES'	 })
Local nPNFOrig		:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_NFORI'	 })
Local nPSeriOri		:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_SERIORI'})
Local nPItemOri		:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_ITEMORI'})
Local nPCC			:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_CC'	 })

Local	lObrgNat 	:= GetMv('MV_NFENAT')	//	PARAMETRO OBRIGANDO O PREENCHIMENTO DA NATUREZA NA DOC.ENTRADA
Local   nZXMRecno	:=	ZXM->(Recno())
Private aDiverg 	:=	{}
Private aFormul 	:=	{ ZXM->ZXM_DOC, ZXM->ZXM_SERIE }  // VARIAVEL PARA FORMULARIO PROPRIO


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Campos Obrigatorios	e verificacao do NCM, QTD, R$	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX:=1 To Len(oBrwV:aCols)
   
   cPedCom	:=	IIF(Empty(cPedCom), oBrwV:aCols[nX][nPosPC], cPedCom)
   
   If Empty(oBrwV:aCols[nX][nPosProd])
       Msgbox("Campo Código-Produtos não esta identificado, corrija primeiro!"+ENTER+ENTER+'Item: '+oBrwV:aCols[nX][nPosItem]+'  -  Prod.Fornec: '+oBrwV:aCols[nX][nPosPFor],"Atenção...","ALERT")
       Return(lRetorno)
	ElseIf !Empty(oBrwV:aCols[nX][nPosPC]) .And. Empty(oBrwV:aCols[nX][nPosPCItem])
       Msgbox("Campo Item do Ped. esta em branco, corrija primeiro!"+ENTER+ENTER+'Item: '+oBrwV:aCols[nX][nPosItem]+'  -  Prod.Fornec: '+oBrwV:aCols[nX][nPosPFor],"Atenção...","ALERT")
       Return(lRetorno)			
	ElseIf cPreDoc=='DOC' 
		If Empty(oBrwV:aCols[nX][nPosTES])
			Msgbox("Campo TES não esta identificado, corrija primeiro!"+ENTER+ENTER+'Item: '+oBrwV:aCols[nX][nPosItem]+'  -  Prod.Fornec: '+oBrwV:aCols[nX][nPosPFor],"Atenção...","ALERT")
			Return(lRetorno)
		EndIf
   EndIf
   
   If cPreDoc=='DOC'
  		If AllTrim(Posicione("SF4",1,xFilial("SF4")+oBrwV:aCols[1][nPosTES],"F4_DUPLIC")) == 'S'
			lCondPag	:=	.T.   
		EndIf	
	EndIf

	/*
	If lNFeDev .And. ( 	Empty(oBrwV:aCols[nX][nPNFOrig])  .Or.;
						Empty(oBrwV:aCols[nX][nPSeriOri]) .Or.;
						Empty(oBrwV:aCols[nX][nPItemOri]) )
		                                                    
		
			Msgbox("Campo NF.\ Série \ item ORIGINAL não esta identificado, corrija primeiro!"+ENTER+ENTER+'Item: '+oBrwV:aCols[nX][nPosItem]+'  -  Prod.Fornec: '+oBrwV:aCols[nX][nPosPFor],"Atenção...","ALERT")
			Return(lRetorno)
		
    EndIf            
	*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| VERIFICA DIVERGENCIA ENTRE XML E DOC.ENTRADA |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	Aadd(aXMLOriginal, {nItemXML, Right(cProdFor, TamSx3('D1_COD')[1]), cDescrProd, cNCM, nQuant, nPreco, nDescont } )
	//							1                   2                            3        4      5       6       7
	          
	lDiverg	:=	.F.
	nPosXML	:=	Ascan(aXMLOriginal, {|X| X[1] == oBrwV:aCols[nX][nPosItem]} )
	
	If nPosXML > 0
		If oBrwV:aCols[nX][nPosQuant] != aXMLOriginal[nPosXML][5]			//	QUANTIDADE
			lDiverg	:=	.T.
		ElseIf oBrwV:aCols[nX][nPosVunit] != (aXMLOriginal[nPosXML][6] - aXMLOriginal[nPosXML][7] )		//	VALOR UNITARIO
			lDiverg	:=	.T.
		EndIf
                                                                 
		cProdNCM := AllTrim(Posicione('SB1',1,xFilial('SB1')+ oBrwV:aCols[nX][nPosProd] ,'B1_POSIPI'))
		If AllTrim(aXMLOriginal[nPosXML][4]) != cProdNCM					//	NCM
			lDiverg	:=	.T.
		EndIf		

					
		If lDiverg
			Aadd(aDiverg, {	aXMLOriginal[nPosXML][1],;		//	ITEM  - 1
						 	aXMLOriginal[nPosXML][2],;		//	PROD.FORNECEDOR - 2
							oBrwV:aCols[nX][nPosProd],;		//	PROD.EMPRESA - 3
							aXMLOriginal[nPosXML][3],;		//	DESCRICAO PRODUTO - FORNECEDOR - 4
							aXMLOriginal[nPosXML][4],;		//	NCM - XML - 5
							cProdNCM,;						//	NCM - ACOLS - 6
							aXMLOriginal[nPosXML][5],;		//	QTD - XML - 7 
							oBrwV:aCols[nX][nPosQuant],;	//	QTD - ACOLS - 8 
							aXMLOriginal[nPosXML][6],;		//	PRECO - XML - 9 
							oBrwV:aCols[nX][nPosVunit],;	//	PRECO - ACOLS - 10
							.F. })	                        //  11
							
		EndIf
        
	EndIf
			
Next


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Informa DIVERGENCIA ENTRE XML E DOC.ENTRADA |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aDiverg) > 0 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| TELA INFORMANDO DIVERGENCIAS |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !TelaDiverg()                                          
		IIF(Select("TMPDIV") != 0, TMPDIV->(DbCLoseArea()), )
		Return(lRetorno)
	EndIf

EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Grava status no fornecedor que manda o XML  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ZXM->ZXM_TIPO $ 'D\B'
	DbSelectarea("SA2");DbSetOrder(3);DbGoTop()
	If Dbseek(xFilial("SA2")+ZXM->ZXM_CGC, .F.)
	   cUfOrig    :=    SA2->A2_EST
	   If Reclock("SA2",.F.)
	       	SA2->A2_STATUS    :=  "1"
		  MsUnlock()
		EndIf
	Endif
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| BUSCA COND.PAGAMENTO CADSTRADO NO FORNECEDOR						|
//| CASO NAO TENHA CADASTRADO A COND.PAG - MOSTRA TELA PARA INFORMAR	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !lNFeDev .And. !lImportacao

	SA2->(DbSetOrder(3),DbGoTop(),DbSeek(xFilial('SA2')+ ZXM->ZXM_CGC, .F.) )
	cUfOrig  	:=	SA2->A2_EST
	cCondPag 	:= 	SA2->A2_COND
	_cNatureza 	:=	SA2->A2_NATUREZ
	SA2Recno 	:=	SA2->(Recno())

Else					//	DEVOLUCAO\RETORNO GRAVA FORNEC\LOJA e TIPO APOS USER SELECIONAR O TIPO [ NA ROTINA OpcaoRetorno ]	
       
	cTabela := IIF(ZXM->ZXM_TIPO $ 'D\B', 'SA1', 'SA2' )
  	*********************************************************************************
		ForCliMsBlql(cTabela, ZXM->ZXM_CGC, lImportacao, ZXM->ZXM_FORNECE, ZXM->ZXM_LOJA )
	*********************************************************************************
	cUfOrig  	:=	IIF(ZXM->ZXM_TIPO $ 'D\B', SA1->A1_EST,  	SA2->A2_EST		)
	cCondPag 	:= 	IIF(ZXM->ZXM_TIPO $ 'D\B', SA1->A1_COND, 	SA2->A2_COND	)
	_cNatureza 	:=	IIF(ZXM->ZXM_TIPO $ 'D\B', SA1->A1_NATUREZ,SA2->A2_NATUREZ	)
	SA2Recno := IIF(ZXM->ZXM_TIPO $ 'D\B', SA1->(Recno()), SA2->(Recno()) )

EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	TELA PARA INFORMAR A COND.PAGAMENTO       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCondPag .And. ( Empty(cCondPag) .Or. Empty(_cNatureza) )
	
	If !Empty(cPedCom)
		DbSelectArea('SC7');DbSetOrder(1);DbGoTop()
		If DbSeek(xFilial('SC7')+cPedCom , .F.)
			cCondPag	:=	SC7->C7_COND
		EndIf		
    EndIf

	If lObrgNat
	    lTelaCond := IIF(Empty(cCondPag).Or.Empty(_cNatureza), .T., .F.)
    Else
		lTelaCond := IIF(Empty(cCondPag), .T., .F.)    
    EndIf
    
EndIf


If lTelaCond

	cDescNat   := IIF(!Empty(_cNatureza), AllTrim(Posicione('SED',1,xFilial('SED')+_cNatureza,'ED_DESCRIC')), Space(3))
	cDescCondP := IIF(!Empty(cCondPag),  AllTrim(Posicione('SE4',1,xFilial('SE4')+cCondPag,'E4_DESCRI') ),  Space(3))
	oFont1     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-09,-11),,.T.,0,,700,.F.,.F.,,,,,, )

	oDlgCondP  := MSDialog():New( D(095),D(232),D(276),D(624),"",,,.F.,,,,,,.T.,,oFont1,.T. )
	oGrp1      := TGroup():New( D(004),D(004),D(064),D(190),"",oDlgCondP,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( D(012),D(008),{||"Não há uma Cond.Pagamento\Natureza cadastrado para este Fornecedor."},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(200),D(008) )

	oSay5      := TSay():New( D(032),D(016),{||"Natureza.:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(032),D(008) )
	oGetC6     := TGet():New( D(030),D(056), {|u| If(PCount()>0,_cNatureza :=u,_cNatureza)},oGrp1,D(050),D(008),'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,{|| IIF(!Empty(_cNatureza), cDescNat:=Posicione('SED',1,xFilial('SED')+_cNatureza,'ED_DESCRIC'),), oSay7:Refresh() },.F.,.F.,,.F.,.F.,"SED","_cNatureza",,)
	oSay7      := TSay():New( D(032),D(110), {|| cDescNat },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	IIF(!lObrgNat, oGetC6:Disable(), oGetC6:Show())
	IIF(!lObrgNat, oSay7:Disable(),  oSay7:Show() )
	
	oSay3      := TSay():New( D(048),D(016),{||"Cond.Pag.:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(032),D(008) )
	oGetC1     := TGet():New( D(044),D(056), {|u| If(PCount()>0,cCondPag :=u,cCondPag)},oGrp1,D(050),D(008),'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,{|| IIF(!Empty(cCondPag), cDescCondP:=Posicione('SE4',1,xFilial('SE4')+cCondPag,'E4_DESCRI'),), oSay4:Refresh() },.F.,.F.,,.F.,.F.,"SE4","cCondPag",,)
	oSay4      := TSay():New( D(048),D(110), {|| cDescCondP },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
		
	oBtn1      := TButton():New( D(068),D(048),"OK",		oDlgCondP,{|| IIF(ExistCpo("SE4",cCondPag), oDlgCondP:End(),) },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( D(068),D(098),"Cancelar",	oDlgCondP,{|| lCloseCond := .T., oDlgCondP:End() },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )
		 
	oGetC6:SetFocus()
	oDlgCondP:Activate(,,,.T.)

EndIf

If lRet
	Return(lRetorno)
EndIf






//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³         PRIMEIRO ALIMENTA aITENS.           			³
//| PEDIDO DE COMPRA VINCULADO COM PRE-NOTA \ DOC.ENTRADA	|
//|	NAO PODERA INFORMAR O TIPO DE FRETE.					|
//|															|
//| HELP: A103FRETE                                         |
//|				Campo Tipo de Frete na aba: DANFE não       |
//|				poderá ser preenchido quando houver         |
//|				pedido vinculado a nota !                   |
//|                                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

lPedCom := .F.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  ARRAY ITEM  PARA UTILIZAR NO MSExecAuto	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 For nLin := 1 To Len(oBrwV:aCols)                      
 
 	//	NAO ADICIONA ITENS DELETADOS...
    If oBrwV:aCols[nLin][Len(aMyHeader)+1]
    	Loop
    EndIf
    
    aLinha 	  := {}                      
	nTam 	  := Len(oBrwV:aCols[nLin])
	
	For nPaCols := 1 To nTam   
		
		If nPaCols < nTam
 
			If AllTrim(aMyHeader[nPaCols][2]) == 'D1_ITEM'
				Aadd(aLinha,{'D1_ITEM',	PadL(AllTrim(Str(nLin)), TamSx3('D1_ITEM')[1],'0'), Nil })
			
			ElseIf AllTrim(aMyHeader[nPaCols][2]) == 'D1_LOCAL' .And. Empty(oBrwV:aCols[nLin][nPaCols])
			    _cLocal := AllTrim(Posicione('SB1', 1, xFilial("SB1") + oBrwV:aCols[nLin][nPosProd], 'B1_LOCPAD' ))
				Aadd(aLinha,{'D1_LOCPAD', IIF(!Empty(_cLocal), _cLocal, Space(TamSx3('D1_LOCPAD')[1]) ), Nil })
									
			ElseIf AllTrim(aMyHeader[nPaCols][2]) == 'D1_PEDIDO' .And. !Empty(oBrwV:aCols[nLin][nPosPC])
				Aadd(aLinha,{'D1_PEDIDO',	oBrwV:aCols[nLin][nPosPC],	  	Nil })
               
				lPedCom := .T.

			ElseIf AllTrim(aMyHeader[nPaCols][2]) == 'D1_ITEMPC' .And. !Empty(oBrwV:aCols[nLin][nPosPCItem])
				Aadd(aLinha,{'D1_ITEMPC',	oBrwV:aCols[nLin][nPosPCItem],	Nil })  
			
			ElseIf AllTrim(aMyHeader[nPaCols][2]) == 'D1_TES' .And. cPreDoc == 'DOC'
   				Aadd(aLinha,{'D1_TES',		oBrwV:aCols[nLin][nPosTES],		Nil	})

   			ElseIf AllTrim(aMyHeader[nPaCols][2]) == 'D1_NFORI' .And. !Empty(oBrwV:aCols[nLin][nPNFOrig])
			   	Aadd(aLinha,{'D1_NFORI', 	oBrwV:aCols[nLin][nPNFOrig], 	Nil	})     
			   	
   			ElseIf AllTrim(aMyHeader[nPaCols][2]) == 'D1_SERIORI' .And. !Empty(oBrwV:aCols[nLin][nPSeriOri])
			   	Aadd(aLinha,{'D1_SERIORI', 	oBrwV:aCols[nLin][nPSeriOri],	Nil	})                       
   			
   			ElseIf AllTrim(aMyHeader[nPaCols][2]) == 'D1_ITEMORI' .And. !Empty(oBrwV:aCols[nLin][nPItemOri])
			   	Aadd(aLinha,{'D1_ITEMORI', 	oBrwV:aCols[nLin][nPItemOri],	Nil	})

			ElseIf !Empty(oBrwV:aCols[nLin][nPaCols])
				Aadd(aLinha,{ AllTrim(aMyHeader[nPaCols][2]),	oBrwV:aCols[nLin][nPaCols], Nil }) 
			EndIf
			
		EndIf   
	Next   

   	Aadd(aItens,aLinha)
   	
Next



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  ARRAY CABEC PARA UTILIZAR NO MSExecAuto	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea('SF1')
_cTipo 		:= 	IIF(Empty(ZXM->ZXM_TIPO),'N',ZXM->ZXM_TIPO)
_cFormul	:=	IIF(Empty(cTpFormul),'N', cTpFormul)
_cFormul	:=	IIF(lImportacao,'S', _cFormul)	//	NOTA DE IMPORTACAO FORMULARIO Eh PROPRIO

Aadd(aCabec,{"F1_TIPO",			_cTipo          	, Nil })
Aadd(aCabec,{"F1_DOC",			IIF(_cFormul!='S'	, ZXM->ZXM_DOC,	Space(TamSx3('F1_DOC')[1]) ),  Nil })
Aadd(aCabec,{"F1_SERIE",       	IIF(_cFormul!='S'	, ZXM->ZXM_SERIE, Space(TamSx3('F1_SERIE')[1])), Nil })
Aadd(aCabec,{"F1_FORMUL",       _cFormul        	, Nil })
Aadd(aCabec,{"F1_EMISSAO",      StoD(cDataNFe)		, Nil })
Aadd(aCabec,{"F1_FORNECE",      ZXM->ZXM_FORNEC		, Nil })
Aadd(aCabec,{"F1_LOJA",         ZXM->ZXM_LOJA		, Nil })
Aadd(aCabec,{"F1_EST",          cUfOrig				, Nil })
Aadd(aCabec,{"F1_ESPECIE",      'SPED'				, Nil })
Aadd(aCabec,{"F1_COND",         cCondPag			, Nil })
Aadd(aCabec,{"F1_CHVNFE",       ZXM->ZXM_CHAVE		, Nil })
Aadd(aCabec,{"F1_HORA",         Left(Time(),5)		, Nil })

Aadd(aCabec,{"E2_NATUREZ",  	_cNatureza			, Nil })

If !Empty(cTranspCgc)
	cCodTransp := Posicione("SA4",3,xFilial("SA4")+cTranspCgc,"A4_COD")
	If !Empty(cCodTransp)
		Aadd(aCabec,{"F1_TRANSP", cCodTransp , Nil })
	EndIf
EndIf
If !Empty(cPlaca)
	Aadd(aCabec,{"F1_PLACA",  cPlaca , Nil })
EndIf
/*
If !Empty(cTpFrete) .And. !lPedCom
	Aadd(aCabec,{"F1_TPFRETE" ,  IIF(AllTrim(cTpFrete)=='1','C','F') 	, Nil })
EndIf
*/
If  SF1->(FieldPos("F1_ESPECI1")) > 0 .And.  !Empty(cEspecie)										//	Especie [C-10]	-	<vol><esp>BAU DE METAL</esp>
	Aadd(aCabec,{"F1_ESPECI1" ,   cEspecie	, Nil })
EndIf
If  SF1->(FieldPos("F1_PBRUTO")) > 0 .And.  !Empty(nPBruto)											//	Peso Bruto da N.F.[N-11]	-	<vol><pesoB>3212.000</pesoB>
	Aadd(aCabec,{"F1_PBRUTO" ,   nPBruto	, Nil })
EndIf
If  SF1->(FieldPos("F1_PLIQUI")) > 0 .And.  !Empty(nPLiquido)										//	Peso Liquido da N.F.[N-11]	-	<vol><pesoL>2777.338</pesoL>
	Aadd(aCabec,{"F1_PLIQUI" ,   nPLiquido	, Nil })
EndIf
If  SF1->(FieldPos("F1_PESOL")) > 0 .And.  !Empty(nPLiquido)										//	Peso Liquido[N-11]	-	<vol><pesoL>2777.338</pesoL>
	Aadd(aCabec,{"F1_PESOL" ,   nPLiquido	, Nil })
EndIf
If  SF1->(FieldPos("F1_VOLUME1")) > 0 .And.  !Empty(nVolume)											//	Volume[N-05]	-	<vol><qVol>1</qVol>
	Aadd(aCabec,{"F1_VOLUME1" ,   nVolume	, Nil })
EndIf 



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  GRAVA DOC. ENTRADA		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aCabec) > 0 .And. Len(aItens) > 0

	
	// BEGIN TRANSACTION		//	FORMULARIO PROPRIO + BEGIN TRANSCTION OCORRE PROBLEMA 
	
		
		DbSelectArea('SF1')
		If cPreDoc=='PRE'
			MsAguarde( {|| MSExecAuto({|x, y, z, w, a | MATA140(x, y, z, w, a )}, aCabec,  aItens, 3, .F., 1) },'Processando','Gerando Pré Nota...' )
		Else
			MsAguarde( {|| MSExecAuto({|x, y, z, w, a | MATA103(x, y, z, w, a )}, aCabec,  aItens, 3, .T.)    },'Processando','Gerando Documento de Entrada...' )
		EndIf
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  ERRO AO TENTAR GRAVAR DOC.ENTRADA	|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMsErroAuto
			MostraErro()
			DisarmTransaction()
			MsgAlert('DOCUMENTO NÃO GRAVADO !!!' )

		Else


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  TENTA GRAVAR DOC.ENTRADA	|
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea('ZXM')
			If ZXM->(Recno()) != nZXMRecno
				DbGoTo(nZXMRecno)
			EndIf
						
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ VERIFICA SE USUARIO CONFIRMOU A PRE-NOTA \ DOC.ENTRADA  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSF1ChaveXML := IIF(Empty(ZXM->ZXM_FORMUL), ZXM->ZXM_DOC + ZXM->ZXM_SERIE, ZXM->ZXM_DOCREF + ZXM->ZXM_SERREF ) + ZXM->ZXM_FORNEC + ZXM->ZXM_LOJA + cTipo
			
			DbSelectArea('SF1');DbSetOrder(1);DbGoTop()    //    F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNEC +F1_LOJA+F1_TIPO
			If DbSeek( xFilial('SF1') + cSF1ChaveXML, .F.)

				DbSelectArea('ZXM')
				Reclock('ZXM',.F.)
					lGravado		:=	.T.
					ZXM->ZXM_STATUS	:=	'G'    // XML GRAVADO + NFENTRADA
					ZXM->ZXM_DTNFE	:=	dDataBase
		            ZXM->ZXM_TIPO   := 	cTipo
				MsUnlock() 
				
				
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³  VERIFICA SA5 - PRODUTO X FORNECEDOR      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPosPFor	:= 	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'C7_PRODUTO'})
				nPosProd    :=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_COD'    })
				nPDescFor   :=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'B1_DESCFOR'})	// DESCRICAO DO CODIGO DO FORNECEDOR [GRAVO NO SA5]
				nPosItem   	:=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_ITEM'   })
				

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³  FOR EM TODOS OS ITENS DO GRID - VERIFICA SE Eh NECESSARIO FAZER AMARRACAO COM SA5    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nX:= 1 To Len(oBrwV:aCols)
				
	
					lExiste := .F.
					DbSelectArea('ZXM')
					IIF(Select("SQL")!= 0, SQL->(DbCLoseArea()), )
										
					#IFDEF TOP

						//	CHAVE UNICA SA5
						// A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO+A5_FABR+A5_FALOJA+A5_REFGRD
						
						cQuery 	:= " SELECT *   "+ENTER
						cQuery 	+= " FROM  	"+ RetSqlName('SA5')+ " SA5 " 								+ENTER
						cQuery 	+= " WHERE	A5_FILIAL	=	'"+xFilial('SA5')+"'"						+ENTER
						cQuery 	+= " AND	A5_FORNECE 	= 	'"+ZXM->ZXM_FORNEC+"'" 						+ENTER
						cQuery 	+= " AND	A5_LOJA    	= 	'"+ZXM->ZXM_LOJA+"'"						+ENTER
						cQuery 	+= " AND	A5_PRODUTO 	= 	'"+AllTrim(oBrwV:aCols[nX][nPosProd])+"'"	+ENTER
						//cQuery  += " AND	A5_CODPRF  	= 	'"+AllTrim(oBrwV:aCols[nX][nPosPFor])+"'" 	+ENTER
					   //	cQuery  += " AND	A5_CODPRF  	= 	''  "											+ENTER
						cQuery 	+= " AND	D_E_L_E_T_  != 	'*' "										+ENTER
						
												
						MemoWrit('C:\QUERY\IMPXMLNFE_SA5_ITEM_'+AllTrim(Str(nX))+'.TXT', cQuery )

						dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SQL', .F., .T.)
						
						nCount := 0
						SQL->(DbGotop())
						SQL->( dbEval( {||nCount++},,,1 ) )
						SQL->(DbGotop())
						
						lExiste := IIF(nCount>0,.T.,.F.)
											
						
					#ELSE
					
						DbSelectarea("SA5");DbSetOrder(1);DbGoTop()    //    A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
						If Dbseek(xFilial("SA5")+ ZXM->ZXM_FORNEC + ZXM->ZXM_LOJA + PadR(oBrwV:aCols[nX][nPosProd],TamSx3('A5_PRODUTO')[1],'') ,.F.)
							Do While !Eof() .And. AllTrim(SA5->A5_CODPRF) == AllTrim(oBrwV:aCols[nX][nPosPFor])
								lExiste :=    .T.
								Exit
							DbSkip()
							EndDo
						EndIf
					
					#ENDIF
					
					
					If !lExiste   
						//	CHAVE UNICA SA5
						// A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO+A5_FABR+A5_FALOJA+A5_REFGRD  
						// \A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO+A5_FABR+A5_FALOJA+A5_REFGRD                                                                                                                                                                                       
	
						DbSelectArea("SA5")
						Reclock("SA5",.T.)
							SA5->A5_FILIAL	:=	xFilial("SA5")
							SA5->A5_FORNECE :=	ZXM->ZXM_FORNEC
							SA5->A5_LOJA    :=	ZXM->ZXM_LOJA
							SA5->A5_CODPRF  :=	AllTrim(oBrwV:aCols[nX][nPosPFor])
							SA5->A5_PRODUTO :=	AllTrim(oBrwV:aCols[nX][nPosProd])
					        SA5->A5_NOMPROD :=	IIF(nPDescFor>0,SubStr(oBrwV:aCols[nX][nPDescFor],1,30),'') 
							SA5->A5_NOMEFOR :=	Posicione("SA2",1,xFilial("SA2")+ZXM->ZXM_FORNEC+ZXM->ZXM_LOJA,"A2_NOME")
						MsUnlock()
				
					Else

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³  VERIFICA SA5 CASO A5_CODPRF ESTA EM BRANCO            ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					    // CHAVE UNICA SA5 -> A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO+A5_FABR+A5_FALOJA+A5_REFGRD
					
						DbSelectArea("SA5");DbGoTop()
						DbGoTo(SQL->R_E_C_N_O_)
						If Empty(SQL->A5_CODPRF) .And. SA5->(Recno()) == SQL->R_E_C_N_O_
							Reclock("SA5", .F.)
								SA5->A5_CODPRF  :=	oBrwV:aCols[nX][nPosPFor]
							MsUnlock()
						EndIf
											
					EndIf

				Next   
				
				IIF(Select("SQL")!= 0, SQL->(DbCLoseArea()), )
				

				lRetorno    :=    .T.
				MsgInfo( 	ENTER+Space(10)+;
							IIF( cPreDoc=='PRE','PRÉ NOTA: ','DOC.ENTRADA: ') +AllTrim(SF1->F1_DOC)+' - Série: '+AllTrim(SF1->F1_SERIE)+;
						 	IIF( !Empty(ZXM->ZXM_FORMUL),  ENTER+Space(10)+'DOC.XML: '+AllTrim(ZXM->ZXM_DOC) +' - Série: '+AllTrim(ZXM->ZXM_SERIE)+ENTER, '')+;
						 	ENTER+Space(10)+'GERADO COM SUCESSO !!!'+Space(30))
			
			Else                                                  
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³		CANCELOU A GRAVACAO DO DOC.ENTRADA      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Aviso('Documento não gravado',ENTER+'Deseja verifica se houve erro?',{'Erro','Sair'}, 2) == 1
					MostraErro()
				EndIf
				
			EndIf
				
		Endif
	
	// END TRANSACTION

Endif

oBrwV:oBrowse:Refresh()
oBrwV:Refresh()

RestArea(aArea3_7)
Return(lRetorno)  
************************************************************
Static Function TelaDiverg()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| TELA INFORMANDO DIVERGENCIAS |
//| GeraPreDoc()				 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local lRet := .T.

SetPrvt("oFont1","oDlgDiverg","oGrp1","oBrwD","oBtnOK","oBtnRet",'oSayClik')

oFont1     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-10,-12),,.F.,0,,700,.F.,.F.,,,,,, )

oDlgDiverg := MSDialog():New( D(095),D(232),D(363),D(1000),"Divergência",,,.F.,,,,,,.T.,,oFont1,.T. )
oGrp1      := TGroup():New( D(004),D(004),D(110),D(380),"",oDlgDiverg,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayClik 	:= TSay():New( D(006),D(008),{|| 'Duplo click para alterar' },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(120),D(008))


oTblDiverg()
DbSelectArea("TMPDIV")

oBrw1      := MsSelect():New( "TMPDIV","","", {{"ITEM","","Item",""},{"PRODFOR","","Prod.Fornec",""},{"PRODEMP","","Produto",""},{"DESCR","","Descrição",""},;
												{"NCM_XML","","NCM no XML",""},{"NCM","","NCM Informado",""},;
												{"QTD_XML","","Quant. no XML","@E 99999999.9999"},{"QUANT","","Quant.Informado","@E 99999999.9999"},;	
												{"PRECOXML","","Preço no XML","@E 9,999,999.999999"},{"PRECO","","Preço Informado","@E 9,999,999.999999"}};
												,.F.,,{ D(012),D(008),D(108),D(378)},,, oGrp1 )

oBrw1:oBrowse:bLDblClick	:=	{|| AlteraDiverg()  }

/*
oBrw1:oBrowse:aColumns[1]:bClrBack := {|| 255 }
oBrw1:oBrowse:aColumns[1]:bClrFore := {|| 8388608 }
oBrwD := MsNewGetDados():New( D(012),D(008),D(100),D(300),GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','',,0,99,,'','AllwaysTrue()',oGrp1,aCabecDiv,aDiverg )
oBrwD:oBrowse:aColumns[1]:bClrFore := {||	IIF( oBrwD:aCols[1][5] <> oBrwD:aCols[1][6],;
								 	 		IIF(ALLTRIM(oBrwD:AHEADER[5][2]) == "B1_POSIPI", 255,   8388608 ), 16711935 )}
*/

oBtnOK     := TButton():New( D(120),D(140),"Confirma",oDlgDiverg,{|| lRet:=.T., oDlgDiverg:End() },037,012,,oFont1,,.T.,,"",,,,.F. )
oBtnRet    := TButton():New( D(120),D(204),"Retornar",oDlgDiverg,{|| lRet:=.F., oDlgDiverg:End() } ,037,012,,oFont1,,.T.,,"",,,,.F. )

oDlgDiverg:Activate(,,,.T.)

Return(lRet)
************************************************************
Static Function oTblDiverg()
************************************************************
Local aFds := {}
Local cTmp


If Select("TMPDIV") != 0
   DbSelectArea("TMPDIV") 
   RecLock('TMPDIV', .F.)
       Zap
   MsUnLock()

Else

	Aadd( aFds , {"X_NCM"   ,"L",001,000} )
	Aadd( aFds , {"X_QTD"   ,"L",001,000} )
	Aadd( aFds , {"X_PRECO" ,"L",001,000} )
	Aadd( aFds , {"ITEM"    ,"C",004,000} )
	Aadd( aFds , {"PRODFOR" ,"C",015,000} )
	Aadd( aFds , {"PRODEMP" ,"C",015,000} )
	Aadd( aFds , {"DESCR"   ,"C",030,000} )
	Aadd( aFds , {"NCM_XML" ,"C",010,000} )
	Aadd( aFds , {"NCM"     ,"C",010,000} )
	Aadd( aFds , {"DESC_NCM","C",040,000} )	
	Aadd( aFds , {"QTD_XML" ,"N",014,003} )
	Aadd( aFds , {"QUANT"   ,"N",014,003} )
	Aadd( aFds , {"PRECOXML","N",016,004} )
	Aadd( aFds , {"PRECO"   ,"N",016,004} )
	
	cTmp := CriaTrab( aFds, .T. )
	Use (cTmp) Alias TMPDIV New Exclusive
	Aadd(aArqTemp, cTmp)
EndIf


For nX:=1 To Len(aDiverg)                      

   cDescNCM :=	Posicione("SYD",1,xFilial("SYD") + aDiverg[nX][06], "YD_DESC_P") // cDesNCM 		 // YD_FILIAL+YD_TEC+YD_EX_NCM+YD_EX_NBM


   RecLock('TMPDIV', .T.)
		TMPDIV->ITEM		:=	aDiverg[nX][01]
		TMPDIV->PRODFOR		:=	aDiverg[nX][02]
		TMPDIV->PRODEMP		:=	aDiverg[nX][03]
		TMPDIV->DESCR		:=	aDiverg[nX][04]
		TMPDIV->NCM_XML		:=	aDiverg[nX][05]
		TMPDIV->NCM			:=	aDiverg[nX][06]
		TMPDIV->DESC_NCM	:=	cDescNCM
		TMPDIV->QTD_XML		:=	aDiverg[nX][07]
		TMPDIV->QUANT		:=	aDiverg[nX][08]
		TMPDIV->PRECOXML	:=	aDiverg[nX][09]
		TMPDIV->PRECO		:=	aDiverg[nX][10]
   MsUnLock()

Next

TMPDIV->(DbGoTop())    
Return()
************************************************************
Static Function AlteraDiverg()
************************************************************
SetPrvt("oFont1","oDlg","oGrp0","oSayProd","oSay1","oSay2","oGrp1","oSay3","oSay4","oGrp2","oSay5","oSay6")
SetPrvt("oBtn2")

oFont2     := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )

oDlg       := MSDialog():New( 199,300,440,1018,"Divergência NCM",,,.F.,,,,,,.T.,,oFont2,.T. )
oGrp0      := TGroup():New( 005,005,104,365,"",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
 
oSay1      := TSay():New( 010,011,{|| "ITEM:"},oGrp0,,oFont2,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,030,010)
oSay2      := TSay():New( 010,030,{|| TMPDIV->ITEM },oGrp0,,oFont2,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,020,010)
                                

oGrp1      := TGroup():New( 020,010,053,350,"XML",oDlg,CLR_HBLUE,CLR_WHITE,.T.,.F. )
oSay7      := TSay():New( 030,013,{|| 'Produto:  '+AllTrim(TMPDIV->PRODFOR) +' - '+ AllTrim(TMPDIV->DESCR) },oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,250,008)
oSay3      := TSay():New( 040,013,{|| "NCM:"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,250,010)
oSay4      := TSay():New( 040,033,{|| AllTrim(TMPDIV->NCM_XML) +'  -  '+Posicione("SYD",1,xFilial("SYD") + TMPDIV->NCM_XML, "YD_DESC_P") },oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,250,010)


oGrp2      := TGroup():New( 060,010,097,350,"Cad.Poduto",oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )
oSay8      := TSay():New( 070,013,{|| 'Produto:  '+AllTrim(TMPDIV->PRODEMP) +' - '+ AllTrim(Posicione('SB1',1,xFilial('SB1')+TMPDIV->PRODEMP,'B1_DESC')) },oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,250,008)
oSay5      := TSay():New( 080,013,{|| "NCM:"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,250,008)
oSay6      := TSay():New( 080,033,{|| AllTrim(TMPDIV->NCM) +'  -  '+Posicione("SYD",1,xFilial("SYD") + TMPDIV->NCM, "YD_DESC_P") },oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,250,008)
       

oBtn1      := TButton():New( 108,140,"Alterar",oDlg, {|| AlteraNCM(),oDlg:End() },036,012,,oFont2,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 108,208,"Cancelar",oDlg,{|| oDlg:End()  },037,012,,oFont2,,.T.,,"",,,,.F. )


oDlg:Activate(,,,.T.)

Return()
************************************************************
Static Function AlteraNCM()
************************************************************
Local lOk := .F.

If MsgYesNo('Deseja ALTERAR a NCM que esta cadastrada no Produto: '+AllTrim(TMPDIV->NCM)+'  -  '+Posicione("SYD",1,xFilial("SYD") + TMPDIV->NCM, "YD_DESC_P")+ENTER+;
			'para '+ENTER+;
			'NCM que esta no XML: '+AllTrim(TMPDIV->NCM_XML) +'  -  '+Posicione("SYD",1,xFilial("SYD") + TMPDIV->NCM_XML, "YD_DESC_P") +' ???' )
	
	DbSelectArea('SB1');DbSetOrder(1);DbGoTop()
	If DbSeek(xFilial('SB1')+ TMPDIV->PRODEMP, .F.)
		Do While !lOk
			If 	RecLock('SB1',.F.)
					SB1->B1_POSIPI := TMPDIV->NCM_XML
			   	MsUnLock()
				lOk := .T.                                                                                                
			
				MsgInfo('Produto: '+ AllTrim(TMPDIV->PRODEMP) +' - '+ AllTrim(Posicione('SB1',1,xFilial('SB1')+TMPDIV->PRODEMP,'B1_DESC'))+ENTER+;
						'NCM: '+ AllTrim(TMPDIV->NCM) +'  -  '+Posicione("SYD",1,xFilial("SYD") + TMPDIV->NCM, "YD_DESC_P") +ENTER+ENTER+;
						'ALTERADO para'+ENTER+ENTER+;
						'NCM: '+AllTrim(TMPDIV->NCM_XML) +'  -  '+Posicione("SYD",1,xFilial("SYD") + TMPDIV->NCM_XML, "YD_DESC_P")+ENTER+;
						'COM SUCESSO !!!')
			
			Else
				MsgYesNo('Outro usuário esta utilizando o cadastro deste produto'+ENTER+'Deseja aguardar alguns instantes?')
				InKey(2)
			EndIf

		EndDo
		
	EndIf


Else
	MsgInfo('Alteração NÃO realizada.')
EndIf

Return()
************************************************************
Static Function SelItemPC()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela para vincular Ped.Compra com Pre-Nota\Doc.Entrada  |
//³ Chamada -> Visual_XML()                                 ³
//| Padrao Microsiga - A103ItemPC							|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea3_8 	:=	GetArea()
Local n        	:= 	oBrwV:nAT
Local aHeader 	:=	aMyHeader
Local aCols   	:=	aMyCols
Local cTipo  	:=	IIF(Empty(ZXM->ZXM_TIPO), 'N', ZXM->ZXM_TIPO )
Local cA100For	:= 	ZXM->ZXM_FORNEC
Local cLoja    	:=	ZXM->ZXM_LOJA
Local cNFiscal	:=	IIF(ZXM->ZXM_FORMUL!='S', ZXM->ZXM_DOC,   ZXM->ZXM_DOCREF)
Local cSerie    := 	IIF(ZXM->ZXM_FORMUL!='S', ZXM->ZXM_SERIE, ZXM->ZXM_SERREF)
Local cEspecie	:=	'SPED'
Local cFormul   :=	IIF(Empty(ZXM->ZXM_FORMUL), 'N', ZXM->ZXM_FORMUL)
Local cCondicao := 	''
Local cForAntNFE:= 	''
Local dDEmissao	:= 	dDataBase


Local lConsLoja     := .T.
Local cSeek            :=    ''
Local nOpca            := 0
Local aArea            := GetArea()
Local aAreaSA2        := SA2->(GetArea())
Local aAreaSC7        := SC7->(GetArea())
Local aAreaSB1        := SB1->(GetArea())
Local aRateio        := {0,0,0}
Local aCab            := {}
Local aNew            := {}
Local aArrSldo        := {}
Local aTamCab        := {}
Local lGspInUseM    := If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local aButtons        := {    {'PESQUISA',{||A103VisuPC(aArrSldo[oQual:nAt][2])},OemToAnsi("Visualiza Pedido"),OemToAnsi("Pedido")},;
                               {'Pesquisa',{||A103PesqP(aCab,aCampos,aArrayF4,oQual)},OemToAnsi("Pesquisar")} }

Local aEstruSC7    := SC7->( dbStruct() )
Local bSavSetKey    := SetKey(VK_F4, Nil )
Local bSavKeyF5    := SetKey(VK_F5,Nil)
Local bSavKeyF7    := SetKey(VK_F7,Nil)
Local bSavKeyF8    := SetKey(VK_F8,Nil)
Local bSavKeyF9    := SetKey(VK_F9,Nil)
Local bSavKeyF10    := SetKey(VK_F10,Nil)
Local bSavKeyF11    := SetKey(VK_F11,Nil)

Local nFreeQt	:= 0
Local nPosPRD	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD" })
Local nPosPDD	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_PEDIDO" })
Local nPosITM	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMPC" })
Local nPosQTD	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_QUANT" })
Local nPosIte	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEM" })
Local cVar		:= oBrwV:aCols[n][nPosPrd]

Local cQuery   	:= ""
Local cAliasSC7	:= "SC7"
Local cCpoObri 	:= ""
Local nSavQual
Local nPed    	:= 0
Local nX      	:= 0
Local nAuxCNT 	:= 0
Local lMt103Vpc    := ExistBlock("MT103VPC")
Local lMt100C7D    := ExistBlock("MT100C7D")
Local lMt100C7C    := ExistBlock("MT100C7C")
Local lMt103Sel    := ExistBlock("MT103SEL")
Local nMT103Sel    := 0
Local nSelOk       := 1
Local lRet103Vpc   := .T.
Local lContinua    := .T.
Local lQuery       := .F.
Local oQual
Local oDlg
Local oPanel
Local aUsButtons  := {}
Local aLineNew    := {}
Local aNewF4      := {}
Local aLineF4     := {}
Local bLine       := {||.T.}
Local cLine       :=" "
Local oOk            := LoadBitMap(GetResources(), "LBOK")
Local oNo            := LoadBitMap(GetResources(), "LBNO")
Local cItem       := Strzero(0,Len(SD1->D1_ITEM ) )
Local lZeraAcols  := .T.
Local lReferencia := .F.
Local nPQtd       := 0
Local nLinha      := 0
Local nColuna     := 0
Local lUsaFiscal     := .T.
Local aPedido        := {}
Local lNfMedic       := .F.
Local lConsMedic     := .F.
Local aHeadSDE       := {}
Local aColsSDE       := {}
Local aGets          := {}

Private    aArrayF4    := {}
Private    aCampos    := {}

Private cPedGrade	:=	''
nPosPC   :=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_PEDIDO' })



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L"
   lContinua := !InConPad
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona botoes do usuario na EnchoiceBar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "MTIPCBUT" )
   If ValType( aUsButtons := ExecBlock( "MTIPCBUT", .F., .F. ) ) == "A"
       AEval( aUsButtons, { |x| AAdd( aButtons, x ) } )
   EndIf
EndIf

If lContinua
   lReferencia := MatgrdPrrf(@cVar)
   If lReferencia
       nPQtd     := aScan(ograde:acposCtrlGrd,{|x| AllTrim(x[1])=="D1_QUANT"})
   Endif


		/*
		For nX := 1 To Len(oBrwV:aCols)
			If !Empty(oBrwV:aCols[nX][nPosPC])
				cPedGrade := oBrwV:aCols[nX][nPosPC]
				Exit
			EndIf
		Next
		*/

       If cTipo == 'N'
           #IFDEF TOP
               DbSelectArea("SC7")
               If TcSrvType() <> "AS/400"

                   lQuery    := .T.
                   cAliasSC7 := "QRYSC7"

                   cQuery      := "SELECT "
                   For nAuxCNT := 1 To Len( aEstruSC7 )
                       If nAuxCNT > 1
                           cQuery += ", "
                       EndIf
                       cQuery += aEstruSC7[ nAuxCNT, 1 ]
                   Next
                   cQuery += ", R_E_C_N_O_ RECSC7 FROM "
                   cQuery += RetSqlName("SC7") + " SC7 "
                   cQuery += "WHERE "
                   cQuery += "C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND "

                   If Empty(cVar)
                       If lConsLoja
                           cQuery += "C7_FORNECE = '"+cA100For+"' AND "
                           cQuery += "C7_LOJA = '"+cLoja+"' AND "
                       Else
                           cQuery += "C7_FORNECE = '"+cA100For+"' AND "
                       Endif
                   Else
                       If lConsLoja
                           cQuery += "C7_FORNECE = '"+cA100For+"' AND "
                           cQuery += "C7_LOJA = '"+cLoja+"' AND "
                           cQuery += "C7_PRODUTO LIKE'"+cVar+"%' AND "
                       Else
                           cQuery += "C7_FORNECE = '"+cA100For+"' AND "
                           cQuery += "C7_PRODUTO LIKE'"+cVar+"%' AND "
                       Endif
                   Endif
	                

					If !Empty(cPedGrade)
                           cQuery += "C7_NUM = '"+cPedGrade+"' AND "					
					EndIf



                   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                   //³ Filtra os pedidos de compras de acordo com os contratos             ³
                   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                   If lConsMedic
                       If lNfMedic
                           //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                           //³ Traz apenas os pedidos oriundos de medicoes                         ³
                           //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                           cQuery += "C7_CONTRA<>'"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
                           cQuery += "C7_MEDICAO<>'" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "
                       Else
                           //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                           //³ Traz apenas os pedidos que nao possuem medicoes                     ³
                           //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                           cQuery += "C7_CONTRA='"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
                           cQuery += "C7_MEDICAO='" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "
                       EndIf
                   EndIf
                   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                   //³ Filtra os Pedidos Bloqueados e Previstos.                ³
                   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                   cQuery += "C7_TPOP <> 'P' AND "
                   If SuperGetMV("MV_RESTNFE") == "S"
                       cQuery += "C7_CONAPRO <> 'B' AND "
                   EndIf
                   cQuery += "SC7.C7_ENCER='"+Space(Len(SC7->C7_ENCER))+"' AND "
                   cQuery += "SC7.C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"' AND "
                             
                   cQuery += "SC7.D_E_L_E_T_ = ' '"

                   cQuery := ChangeQuery(cQuery)

                   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)
                   For nX := 1 To Len(aEstruSC7)
                       If aEstruSC7[nX,2]<>"C"
                           TcSetField(cAliasSC7,aEstruSC7[nX,1],aEstruSC7[nX,2],aEstruSC7[nX,3],aEstruSC7[nX,4])
                       EndIf
                   Next nX
               Else
           #ENDIF

               If Empty(cVar)
                   DbSelectArea("SC7")
                   DbSetOrder(9)
                   If lConsLoja
                       cCond := "C7_FILENT+C7_FORNECE+C7_LOJA"
                       cSeek := cA100For+cLoja
                       MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
                   Else
                       cCond := "C7_FILENT+C7_FORNECE"
                       cSeek := cA100For
                       MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
                   EndIf
               Else
                   If !lReferencia
                       DbSelectArea("SC7")
                       DbSetOrder(6)
                       If lConsLoja
                           cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE+C7_LOJA"
                           cSeek := cVar+cA100For+cLoja
                           MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
                       Else
                           cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE"
                           cSeek := cVar+cA100For
                           MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
                       EndIf
                   Else


                       If lConsLoja
                           DbSelectArea("SC7")
                           DbSetOrder(17)
                           cCond := "C7_FILENT+C7_FORNECE+C7_LOJA"
                           cSeek := cA100For+cLoja
                           MsSeek(xFilEnt(xFilial("SC7"))+cA100For+cLoja+cVar,.F.)
                       Else
                           DbSelectArea("SC7")
                           DbSetOrder(18)
                           cCond := "C7_FILENT+C7_FORNECE"
                           cSeek := cA100For
                           MsSeek(xFilEnt(xFilial("SC7"))+cA100For+cVar,.F.)
                       EndIf
                   Endif
               EndIf
               #IFDEF TOP
               EndIf
               #ENDIF

           If Empty(cVar)
               cCpoObri := "C7_LOJA|C7_PRODUTO|C7_QUANT|C7_DESCRI|C7_TIPO|C7_LOCAL|C7_OBS"
           Else
               cCpoObri := "C7_LOJA|C7_QUANT|C7_DESCRI|C7_TIPO|C7_LOCAL|C7_OBS"
           Endif

           If (cAliasSC7)->(!Eof())
               DbSelectArea("SX3"); DbSetOrder(2)

               If lNfMedic .And. lConsMedic

                   MsSeek("C7_MEDICAO")

                   AAdd(aCab,x3Titulo())
                   Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
                   aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

                   MsSeek("C7_CONTRA")

                   AAdd(aCab,x3Titulo())
                   Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
                   aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

                   MsSeek("C7_PLANILH")

                   AAdd(aCab,x3Titulo())
                   Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
                   aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

               EndIf

               MsSeek("C7_NUM")
               AAdd(aCab,x3Titulo())
               Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
               aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))


               DbSelectArea("SX3")
               DbSetOrder(1)
               MsSeek("SC7")
               While !Eof() .And. SX3->X3_ARQUIVO == "SC7"
                   IF ( SX3->X3_BROWSE=="S".And.X3Uso(SX3->X3_USADO).And. /*AllTrim(SX3->X3_CAMPO)<>"C7_PRODUTO" .And. */AllTrim(SX3->X3_CAMPO)<>"C7_NUM" .And.;
                           If( lConsMedic .And. lNfMedic, AllTrim(SX3->X3_CAMPO)<>"C7_MEDICAO" .And. AllTrim(SX3->X3_CAMPO)<>"C7_CONTRA" .And. AllTrim(SX3->X3_CAMPO)<>"C7_PLANILH", .T. )).Or.;
                           (AllTrim(SX3->X3_CAMPO) $ cCpoObri)
                       AAdd(aCab,x3Titulo())
                       Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
                       aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
                   EndIf
                   dbSkip()
               Enddo

               DbSelectArea(cAliasSC7)
               Do While If(lQuery, ;
                       (cAliasSC7)->(!Eof()), ;
                       (cAliasSC7)->(!Eof()) .And. xFilEnt(cFilial)+cSeek == &(cCond))

                   If lReferencia .And. !(Alltrim(cVar)==LEFT((cAliasSC7)->C7_PRODUTO,Len(cVar)))
                       dbSkip()
                       Loop
                   Endif
                   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                   //³ Filtra os Pedidos Bloqueados, Previstos e Eliminados por residuo   ³
                   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                   If !lQuery
                       If (SuperGetMV("MV_RESTNFE") == "S" .And. (cAliasSC7)->C7_CONAPRO == "B") .Or. ;
                               (cAliasSC7)->C7_TPOP == "P" .Or. !Empty((cAliasSC7)->C7_RESIDUO)
                           dbSkip()
                           Loop
                       EndIf
                   Endif

                   nFreeQT := 0

                   nPed    := aScan(aPedido,{|x| x[1] = (cAliasSC7)->C7_NUM+(cAliasSC7)->C7_ITEM})

                   nFreeQT -= If(nPed>0,aPedido[nPed,2],0)
                   If MaGrade() .And. !lUsaFiscal
                       If lReferencia
                           nAchou:= Ascan(aCols,{|x| x[nPosPDD] == SC7->C7_NUM .And. x[nPosITM] == SC7->C7_ITEM   })
                           If nAchou > 0
                               For nLinha:=1 to len(oGrade:aColsGrade[nAchou])
                                   For nColuna:=2 to len(oGrade:aHeadGrade[nAchou])

                                       If ( oGrade:aColsFieldByName("D1_QUANT",nAchou,nLinha,nColuna) <> 0) .And. !aCols[nAchou][Len(aHeader)+1]
                                           oGrade:nPosLinO:=nAchou
                                           cProdRef := oGrade:GetNameProd(Alltrim(cVar),nLinha,nColuna)
                                           If Alltrim(cProdRef) == Alltrim((cAliasSC7)->C7_PRODUTO)
                                               nFreeQT += oGrade:aColsFieldByName("D1_QUANT",nAchou,nLinha,nColuna)
                                           Endif
                                       Endif
                                   Next
                               Next
                           Endif
                       Else

                           For nAuxCNT := 1 To Len( aCols )
                               If (nAuxCNT # n) .And. ;
                                       (aCols[ nAuxCNT,nPosPRD ] == (cAliasSC7)->C7_PRODUTO) .And. ;
                                       (aCols[ nAuxCNT,nPosPDD ] == (cAliasSC7)->C7_NUM) .And. ;
                                       (aCols[ nAuxCNT,nPosITM ] == (cAliasSC7)->C7_ITEM) .And. ;
                                       !ATail( aCols[ nAuxCNT ] )
                                   nFreeQT += aCols[ nAuxCNT,nPosQTD ]
                               EndIf
                           Next

                       Endif
                   Else

                       For nAuxCNT := 1 To Len( aCols )
                           If (nAuxCNT # n) .And. ;
                                   (aCols[ nAuxCNT,nPosPRD ] == (cAliasSC7)->C7_PRODUTO) .And. ;
                                   (aCols[ nAuxCNT,nPosPDD ] == (cAliasSC7)->C7_NUM) .And. ;
                                   (aCols[ nAuxCNT,nPosITM ] == (cAliasSC7)->C7_ITEM) .And. ;
                                   !ATail( aCols[ nAuxCNT ] )
                               nFreeQT += aCols[ nAuxCNT,nPosQTD ]
                           EndIf
                       Next
                   Endif

                   lRet103Vpc := .T.

                   If lMt103Vpc
                       If lQuery
                           ('SC7')->(dbGoto((cAliasSC7)->RECSC7))
                       EndIf
                       lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
                   Endif

                   If lRet103Vpc
                       If ((nFreeQT := ((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE-(cAliasSC7)->C7_QTDACLA-nFreeQT)) > 0)
                           Aadd(aArrayF4,Array(Len(aCampos)))

                           SB1->(DbSetOrder(1))
                           SB1->(MsSeek(xFilial("SB1")+(cAliasSC7)->C7_PRODUTO))
                           For nX := 1 to Len(aCampos)

                               If aCampos[nX][3] != "V"
                                   If aCampos[nX][2] == "N"
                                       If Alltrim(aCampos[nX][1]) == "C7_QUANT"
                                           aArrayF4[Len(aArrayF4)][nX] :=Transform(nFreeQt,PesqPict("SC7",aCampos[nX][1]))
                                       ElseIf Alltrim(aCampos[nX][1]) == "C7_QTSEGUM"
                                           aArrayF4[Len(aArrayF4)][nX] :=Transform(ConvUm(SB1->B1_COD,nFreeQt,nFreeQt,2),PesqPict("SC7",aCampos[nX][1]))
                                       Else
                                           aArrayF4[Len(aArrayF4)][nX] := Transform((cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SC7",aCampos[nX][1]))
                                       Endif
                                   Else
                                       aArrayF4[Len(aArrayF4)][nX] := (cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1])))
                                   Endif
                               Else
                                   aArrayF4[Len(aArrayF4)][nX] := CriaVar(aCampos[nX][1],.T.)
                                   If Alltrim(aCampos[nX][1]) == "C7_CODGRP"
                                       aArrayF4[Len(aArrayF4)][nX] := SB1->B1_GRUPO
                                   EndIf
                                   If Alltrim(aCampos[nX][1]) == "C7_CODITE"
                                       aArrayF4[Len(aArrayF4)][nX] := SB1->B1_CODITE
                                   EndIf
                               Endif

                           Next

                           aAdd(aArrSldo, {nFreeQT, IIF(lQuery,(cAliasSC7)->RECSC7,(cAliasSC7)->(RecNo()))})

                           If lMT100C7D
                               If lQuery
                                   ('SC7')->(dbGoto((cAliasSC7)->RECSC7))
                               EndIf
                               aNew := ExecBlock("MT100C7D", .f., .f., aArrayF4[Len(aArrayF4)])
                               If ValType(aNew) = "A"
                                   aArrayF4[Len(aArrayF4)] := aNew
                               EndIf
                           EndIf
                       EndIf
                   Endif
                   (cAliasSC7)->(dbSkip())
               EndDo

               If !Empty(aArrayF4)


                   cLine := " { aArrayF4[oQual:nAt,1]
                   For nX := 2 To Len( aCampos )
                       cLine += ",aArrayF4[oQual:nAT][" + AllTrim( Str( nX ) ) + "]"
                   Next nX

                   cLine += " } "


                   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                   //³ Monta dinamicamente o bline do CodeBlock                 ³
                   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                   bLine := &( "{ || " + cLine + " }" )
                   DEFINE MSDIALOG oDlg FROM 30,20  TO 265,521 TITLE "Selecionar Pedido de Compra ( por item ) - <F6> " Of oMainWnd PIXEL

                   If lMT100C7C
                       aNew := ExecBlock("MT100C7C", .f., .f., aCab)
                       If ValType(aNew) == "A"
                           aCab := aNew
                       EndIf
                   EndIf

                   @ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,19 OF oDlg CENTERED LOWERED //"Botoes"
                   oPanel:Align := CONTROL_ALIGN_TOP

                   oQual := TWBrowse():New( 29,4,243,85,,aCab,aTamCab,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
                   oQual:SetArray(aArrayF4)
                   oQual:bLDblClick := {|| AtuPedCom(nSavQual:=oQual:nAT), oDlg:End() }
                   oQual:bLine := bLine

                   oQual:Align := CONTROL_ALIGN_ALLCLIENT

                   oQual:nFreeze := 1


                   If !Empty(cVar)
                       @ 6  ,4   SAY OemToAnsi("Produto"+Space(060)+ "- Item XML: "+oBrwV:aCols[n][nPosIte]  ) Of oPanel PIXEL SIZE 197 ,9 //"Produto"
                       @ 4  ,30  MSGET cVar PICTURE PesqPict('SB1','B1_COD') When .F. Of oPanel PIXEL SIZE 80,9
                   Else
                       @ 6  ,4   SAY OemToAnsi("Selecione o Pedido de Compra - Item XML: "+oBrwV:aCols[n][nPosIte]  ) Of oPanel PIXEL SIZE 120 ,9 //"Selecione o Pedido de Compra"
                   EndIf
                   

                   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| AtuPedCom(nSavQual:=oQual:nAT), oDlg:End() },{||oDlg:End()},,aButtons)

               Else
                   Help(" ",1,"A103F4")
               EndIf
           Else
               Help(" ",1,"A103F4")
           EndIf
       Else
           Help('   ',1,'A103TIPON')
       EndIf

Endif

If MaGrade() .And. Len(acols) >0 .And. !lUsaFiscal
   aCols := aColsGrade(oGrade, aCols, aHeader, "D1_COD", "D1_ITEM", "D1_ITEMGRD")
   aGets[SEGURO] := aRateio[1]
   aGets[VALDESP]:= aRateio[2]
   aGets[FRETE]  := aRateio[3]
Endif

If lQuery
   DbSelectArea(cAliasSC7)
   dbCloseArea()
   DbSelectArea("SC7")
Endif
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)
RestArea(aAreaSA2)
RestArea(aAreaSC7)
RestArea(aAreaSB1)
RestArea(aArea)
RestArea(aArea3_8)

Return()
***********************************************************************
Static Function a103PesqP(aCab,aCampos,aArrayF4,oQual)
***********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela para vincular Ped.Compra com Pre-Nota\Doc.Entrada - Botao Pesquisa |
//³ Chamada -> Visual_XML()->SelItemPC()                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aCpoBusca    := {}
Local aCpoPict        := {}
Local aComboBox    := { AllTrim( "Exata" ) , AllTrim( "Parcial" ) , AllTrim( "Contem" ) } //"Exata"###"Parcial"###"Contem"
Local bAscan        := { || .F. }
Local cPesq            := Space(30)
Local cBusca        := ""
Local cTitulo        := OemtoAnsi("Pesquisar")  //"Pesquisar"
Local cOpcAsc        := aComboBox[1]    //"Exata"
Local cAscan        := ""
Local nOpca            := 0
Local nPos        := 0
Local nx            := 0
Local nTipo         := 1
Local nBusca        := Iif(oQual:nAt == Len(aArrayF4) .Or. oQual:nAt == 1, oQual:nAt, oQual:nAt+1 )
Local oDlg
Local oBusca
Local oPesq1
Local oPesq2
Local oPesq3
Local oPesq4
Local oComboBox


For nX := 1 to Len(aCampos)
   AAdd(aCpoBusca,aCab[nX])
   AAdd(aCpoPict,aCampos[nX][4])
Next

If Len(aCampos) > 0 .And. Len(aArrayF4) > 0

   DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo)  FROM 00,0 TO 100,490 OF oMainWnd PIXEL

   @ 05,05 MSCOMBOBOX oBusca VAR cBusca ITEMS aCpoBusca SIZE 206, 36 OF oDlg PIXEL ON CHANGE (nTipo := oBusca:nAt,A103ChgPic(nTipo,aCampos,@cPesq,@oPesq1,@oPesq2,@oPesq3,@oPesq4))

   @ 022,005 MSGET oPesq1 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL

   @ 022,005 MSGET oPesq2 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL

   @ 022,005 MSGET oPesq3 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL

   @ 022,005 MSGET oPesq4 VAR cPesq Picture "@!" SIZE 206, 10 Of oDlg PIXEL

   oPesq1:Hide()
   oPesq2:Hide()
   oPesq3:Hide()
   oPesq4:Hide()

   Do Case
   Case aCampos[1][2] == "C"

       DbSelectArea("SX3")
       DbSetOrder(2)
       If MsSeek(aCampos[1][1])
           If !Empty(SX3->X3_F3)
               oPesq2:cF3 := SX3->X3_F3
               oPesq1:Hide()
               oPesq2:Show()
               oPesq3:Hide()
               oPesq4:Hide()
           Else
               oPesq1:Show()
               oPesq2:Hide()
               oPesq3:Hide()
               oPesq4:Hide()
           Endif
       Endif

   Case aCampos[1][2] == "D"
       oPesq1:Hide()
       oPesq2:Hide()
       oPesq3:Show()
       oPesq4:Hide()
   Case aCampos[1][2] == "N"
       oPesq1:Hide()
       oPesq2:Hide()
       oPesq3:Hide()
       oPesq4:Show()
   EndCase

   cPesq := CriaVar(aCampos[1][1],.F.)
   cPict := aCampos[1][4]

   DEFINE SBUTTON oBut1 FROM 05, 215 TYPE 1 ACTION ( nOpca := 1, oDlg:End() ) ENABLE of oDlg
   DEFINE SBUTTON oBut1 FROM 20, 215 TYPE 2 ACTION ( nOpca := 0, oDlg:End() )  ENABLE of oDlg

   @ 037,005 SAY OemtoAnsi("Tipo") SIZE 050,10 OF oDlg PIXEL //Tipo
   @ 037,030 MSCOMBOBOX oComboBox VAR cOpcAsc ITEMS aComboBox SIZE 050,10 OF oDlg PIXEL

   ACTIVATE MSDIALOG oDlg CENTERED

   If nOpca == 1

       Do Case

       Case aCampos[nTipo][2] == "C"
           IF ( cOpcAsc == aComboBox[1] )    //Exata
               cAscan := Padr( Upper( cPesq ) , TamSx3(aCampos[nTipo][1])[1] )
               bAscan := { |x| cAscan == Upper( x[ nTipo ] ) }
           ElseIF ( cOpcAsc == aComboBox[2] )    //Parcial
               cAscan := Upper( AllTrim( cPesq ) )
               bAscan := { |x| cAscan == Upper( SubStr( Alltrim( x[nTipo] ) , 1 , Len( cAscan ) ) ) }
           ElseIF ( cOpcAsc == aComboBox[3] )    //Contem
               cAscan := Upper( AllTrim( cPesq ) )
               bAscan := { |x| cAscan $ Upper( Alltrim( x[nTipo] ) ) }
           EndIF

           nPos := Ascan( aArrayF4 , bAscan )
       Case aCampos[nTipo][2] == "N"
           nPos := Ascan(aArrayF4,{|x| Transform(cPesq,PesqPict("SC7",aCampos[nTipo][1])) == x[nTipo]},nBusca)
       Case aCampos[nTipo][2] == "D"
           nPos := Ascan(aArrayF4,{|x| Dtos(cPesq) == Dtos(x[nTipo])},nBusca)
       EndCase

       If nPos > 0
           oQual:bLine := { || aArrayF4[oQual:nAT] }
           oQual:nFreeze := 1
           oQual:nAt := nPos
           oQual:Refresh()
           oQual:SetFocus()
       Else
           Help(" ",1,"REGNOIS")
       Endif

   EndIf

Endif

Return()
***********************************************************************
Static Function A103VisuPC(nRecSC7)
***********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela para vincular Ped.Compra com Pre-Nota\Doc.Entrada - Botao Visualizar|
//³ Chamada -> Visual_XML()->SelItemPC()                                  	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local n    :=    1
Local aArea        :=    GetArea()
Local aAreaSC7    := SC7->(GetArea())
Local nSavNF    := MaFisSave()
Local cSavCadastro:= cCadastro
Local cFilBak    := cFilAnt
Local nBack        :=    n
Private nTipoPed    := 1
Private cCadastro    := OemToAnsi("Consulta ao Pedido de Compra")
Private l120Auto    :=    .F.
Private LVLDHEAD     :=    .T.
Private LGATILHA  :=    .T.
Private aBackSC7    := {}

MaFisEnd()

DbSelectArea("SC7")
MsGoto(nRecSC7)

cFilAnt := IIf(!Empty(SC7->C7_FILIAL),SC7->C7_FILIAL,cFilAnt)

A120Pedido(Alias(),RecNo(),2)

cFilant     := cFilBak
n             := nBack
cCadastro:=    cSavCadastro

MaFisRestore(nSavNF)
RestArea(aAreaSC7)
RestArea(aArea)

Return(.T.)
********************************************************************************
Static Function A103ChgPic(nTipo,aCampos,cPesq,oPesq1,oPesq2,oPesq3,oPesq4)
********************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada -> Visual_XML()->Seleciona()->a103PesqP()          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPict   := ""
Local aArea   := GetArea()
Local aAreaSX3:= SX3->(GetArea())
Local bRefresh


DbSelectArea("SX3")
DbSetOrder(2)
If MsSeek(aCampos[nTipo][1])

   Do case

   Case aCampos[nTipo][2] == "C"
       If !Empty(SX3->X3_F3)
           oPesq2:cF3 := SX3->X3_F3
           oPesq1:Hide()
           oPesq2:Show()
           oPesq3:Hide()
           oPesq4:Hide()
           bRefresh := { || oPesq2:oGet:Picture := cPict,oPesq2:Refresh() }
       Else
           oPesq1:Show()
           oPesq2:Hide()
           oPesq3:Hide()
           oPesq4:Hide()
           bRefresh := { || oPesq1:oGet:Picture := cPict,oPesq1:Refresh() }
       Endif

   Case aCampos[nTipo][2] == "D"
       oPesq1:Hide()
       oPesq2:Hide()
       oPesq3:Show()
       oPesq4:Hide()
       bRefresh := { || oPesq3:oGet:Picture := cPict,oPesq3:Refresh() }
   Case aCampos[nTipo][2] == "N"
       oPesq1:Hide()
       oPesq2:Hide()
       oPesq3:Hide()
       oPesq4:Show()
       bRefresh := { || oPesq4:oGet:Picture := cPict,oPesq4:Refresh() }
   EndCase

Endif

If nTipo > 0
   cPesq := CriaVar(aCampos[nTipo][1],.F.)
   cPict := aCampos[nTipo][4]
EndIf

Eval(bRefresh)

RestArea(aAreaSX3)
RestArea(aArea)

Return()
***********************************************************************
Static Function AtuPedCom(nLnoQual)
***********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza aMyCols com Pedido\Item do Compra              |
//³ Chamada -> Visual_XML()->SelItemPC()                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLnaCols := oBrwV:NAT
lDeletado:=	oBrwV:aCols[oBrwV:NAT][Len(aMyHeader)+1]

nPos1    	:=	Ascan( aCampos, {|X| AllTrim(X[1])  == 'C7_NUM'    })
nPos2    	:=	Ascan( aCampos, {|X| AllTrim(X[1])  == 'C7_ITEM'   })
nPos4    	:=	Ascan( aCampos, {|X| AllTrim(X[1])  == 'C7_PRODUTO'})
nPos5    	:=	Ascan( aCampos, {|X| AllTrim(X[1])  == 'C7_QUANT'	})

nPosItem  	:=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_ITEM'   })
nPosProd  	:=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_COD'    })
nPosPC     	:=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_PEDIDO' })
nPosPCItem	:= 	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_ITEMPC' })
nPosQuant	:= 	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_QUANT'	})
nPosPreco	:= 	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_VUNIT' 	})
nPosTotal	:= 	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_TOTAL'  })

nPDescEmp  	:=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'B1_DESC'   })
nPosUM		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_UM'  	})
nPosALM		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_LOCAL'	})
nPosTES		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_TES' 	})

lOk			:=	.F.


If !lDeletado
	
	// VERIFICA SE PEDIDO DE COMPRA JA FOI UTILIZADO EM ALGUM OUTRO ITEM.
	nPosPcom := Ascan( oBrwV:aCols, {|X|  X[nPosPC] == aArrayF4[nLnoQual][nPos1] .And.  X[nPosPCItem] == aArrayF4[nLnoQual][nPos2] })
	If 	nPosPcom != 0
		MsgInfo('Pedido de Compra  '+aArrayF4[nLnoQual][nPos1]+'  Item: '+aArrayF4[nLnoQual][nPos2]+ENTER+;
				'  já utilizado no item  '+ oBrwV:aCols[nPosPcom][nPosItem] +' deste XML.'	) // PadL(AllTrim(Str(nPosPcom)), TamSx3('D1_ITEM')[1],'0') )
	EndIf
	
	If nPos1 != 0  // PARA VINCULAR 2OU+ PC AO MESMO ITEM DEVERA SELECIONAR UM PC AO ITEM E NOVAMENTE INFORMAR OUTRO PC.
		If !Empty(oBrwV:aCols[nLnaCols][nPosPC]) .And.;
   			( oBrwV:aCols[nLnaCols][nPosPC] 	!= aArrayF4[nLnoQual][nPos1]	.Or.;	//	NUM.PC
			  oBrwV:aCols[nLnaCols][nPosPCItem]	!= aArrayF4[nLnoQual][nPos2] 	.Or.;	//	ITEM PC
			  oBrwV:aCols[nLnaCols][nPosProd] 	!= aArrayF4[nLnoQual][nPos4]   ) 		//	PRODUTO

			If MsgYesNo('Item  '+oBrwV:aCols[nLnaCols][nPosItem]+' já vinculado com Pedido de Compra '+oBrwV:aCols[nLnaCols][nPosPC]+' Item: '+oBrwV:aCols[nLnaCols][nPosPCItem]+ENTER+;
						'Deseja adicionar novo Item ?')  
                                  
	   			If oBrwV:AddLine(.T.,.F.)	//	ADICIONA NOVA LINHA NO ACOLS

	   				oBrwV:aCols[Len(oBrwV:aCols)] := aClone(oBrwV:aCols[nLnaCols])		//	COPIA TODO CONTEUDO DA LINHA POSICIONADA PARA LINHA ADICIONADA
					oBrwV:aCols[Len(oBrwV:aCols)][nPosItem] := PadL(AllTrim(Str(Len(oBrwV:aCols))), TamSx3('D1_ITEM')[1],'0')
					nLnaCols := Len(oBrwV:aCols)										//	nLnaCols RECEBE O VALOR DO LEN() PARA GRAVAR DADOS... NA SEQUENCIA ABAIXO
	            
	   		         If Ascan(aPCxItem, Len(oBrwV:aCols) ) == 0
						Aadd(aPCxItem, Len(oBrwV:aCols) )
	        	    EndIf
	            
					oBrwV:Refresh()   
					oBrwV:oBrowse:Refresh()
					GetDRefresh()
				
				EndIf

			EndIf
		
		EndIf
	EndIf


	If nPos4 != 0
	   oBrwV:aCols[nLnaCols][nPosProd]  := aArrayF4[nLnoQual][nPos4]    //    PRODUTO
		lOk := .T.
	EndIf
	If nPos2 != 0
	   oBrwV:aCols[nLnaCols][nPosPCItem]:= aArrayF4[nLnoQual][nPos2]    //    ITEMPC
		lOk := .T.
	EndIf
	If nPos1 != 0
	   oBrwV:aCols[nLnaCols][nPosPC]    := aArrayF4[nLnoQual][nPos1]    //    NUM.PC
		lOk := .T.
	EndIf
	
	// OBS.: PARA QUE AO SELECIONAR O PC SEJA PREENCHIDO A QUANTIDADE QUE CONSTA NO PC DESCOMENTE ESSA LINHA.
	/*
	If nPos5 != 0
		oBrwV:aCols[nLnaCols][nPosQuant]:= Val( StrTran(StrTran(aArrayF4[nLnoQual][nPos5], '.',''), ',','.') )    //    QUANT.PC    
		oBrwV:aCols[nLnaCols][nPosTotal]:= Round( oBrwV:aCols[nLnaCols][nPosQuant]	* oBrwV:aCols[nLnaCols][nPosPreco], 2 )
	EndIf
	*/
	
	SB1->(DbGoTop(), DbSetOrder(1))
	If SB1->(DbSeek(xFilial('SB1') + oBrwV:aCols[nLnaCols][nPosProd] ,.F.) )

		If TMPCFG->(FieldPos('DESCEMP')) > 0
			If TMPCFG->DESCEMP == 'SIM'	.And. nPDescEmp > 0
				oBrwV:aCols[nLnaCols][nPDescEmp]:= SB1->B1_DESC
			EndIf
		EndIf

		If nPosUM > 0
			oBrwV:aCols[nLnaCols][nPosUM]:= SB1->B1_UM
		EndIf
		
		If nPosALM > 0
			oBrwV:aCols[nLnaCols][nPosALM]:= SB1->B1_LOCPAD
		EndIf

		If nPosTES > 0
			oBrwV:aCols[nLnaCols][nPosTES]:= SB1->B1_TE		
		EndIf
	
	EndIf

    If lOk
		GravaZXP('PEDCOM', nLnaCols)
    EndIf
    
	nLinAT  := 	oBrwV:oBrowse:nAT
	nLinRow := 	oBrwV:oBrowse:nRowPos
	nColPos	:=	oBrwV:oBrowse:ColPos

	oBrwV:Refresh()   
	oBrwV:oBrowse:Refresh()

	oBrwV:oBrowse:nRowPos	:= 	nLinRow
	oBrwV:oBrowse:nAT		:= 	nLinAT
	oBrwV:oBrowse:ColPos  	:=	nColPos
	
EndIf
	
Return()
*****************************************************************
Static Function DelLnPC()
*****************************************************************

nPosDel := Ascan(aPCxItem, oBrwV:NAT )
       
If nPosDel > 0
	// oBrwV:DelLine()
	oBrwV:aCols[oBrwV:NAT][Len(aMyHeader)+1] := .T.     
	aPCxItem[nPosDel] := 'XXXX'		//	FLAG
	oBrwV:Refresh()   
	oBrwV:oBrowse:Refresh()
	GetDRefresh()
	oBrwV:ForceRefresh()
Else
	Alert('Este item é original do XML NÃO pode ser DELETADO !!!') 
EndIf


Return()
*****************************************************************
Static Function ReplicaProd(cParam)
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ REPLICA CODIGO PRODUTO PARA OS ITENS SELECIONADOS   ³
//|	Chamada -> Visual_XML()-> Bota Replica				|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDescProd	:=	''
Local nPosProd 	:= Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_COD'	})
Local nPosLocal	:= Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_LOCAL'	})
Local nPosTES	:= Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_TES'	})

Private cOpcao 		:=	cParam
Private cProdAglut	:=	''
Private cMarca 		:=	''
Private _cTitulo	:=	''


If cOpcao == 'PROD'
	cProdAglut	:=	Space(TamSX3('D1_COD')[1])
	_cTitulo	:=	oBrwV:oBrowse:aColumns[nPosProd]:cHeading
ElseIf cOpcao == 'ALMOX'
	cProdAglut	:=	Space(TamSX3('D1_LOCAL')[1])
	_cTitulo	:=	oBrwV:oBrowse:aColumns[nPosLocal]:cHeading
ElseIf cOpcao == 'TES'
	cProdAglut	:=	Space(TamSX3('D1_TES')[1])
	_cTitulo	:=	'TES' //oBrwV:oBrowse:aColumns[nPosTES]:cHeading
EndIf	
                        

                                                     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   TELA - REPLICAR    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetPrvt("oFont1","oDlg1","oSay1","oGrp1","oBrw1","oGet1","oBtn1","oGrp2","oBrw2","oBtn2","oBtn3")
oFont0     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-08,-10),,.T.,0,,700,.F.,.F.,,,,,, )
oFont1     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-11,-13),,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-13,-15),,.T.,0,,700,.F.,.F.,,,,,, )

oDlg1      := MSDialog():New( D(091),D(232),D(400),D(700),'Replica Código',,,.F.,,,,,,.T.,,oFont1,.T. )
oGrp1      := TGroup():New( D(004),D(008),D(028),D(230),"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( D(008), D(012),{|| _cTitulo },oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(092),D(008) )



If cOpcao == 'PROD'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ REPLICA - PRODUTO    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGet1      := TGet():New( D(016),D(012),{|u| If(PCount()>0,cProdAglut :=u,cProdAglut)},oDlg1,D(074),D(008),'',{|| IIF(Empty(cProdAglut).Or.!ExistCpo("SB1",cProdAglut), (cDescProd:=''), (cDescProd := AllTrim(Posicione('SB1',1,xFilial('SB1')+cProdAglut,'B1_DESC')),oGet1:Refresh() ) ) },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)

ElseIf cOpcao == 'ALMOX'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ REPLICA - ALMOXARIFADO	|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cF3Local	  := ''
	If SX3->(DbSetOrder(2),DbGoTop(),DbSeek('D1_LOCAL',.F.))
		cF3Local	  := SX3->X3_F3
	EndIf	
	oGet1      := TGet():New( D(016),D(012),{|u| If(PCount()>0,cProdAglut :=u,cProdAglut)},oDlg1,D(074),D(008),'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,cF3Local,"",,)

ElseIf cOpcao == 'TES'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ REPLICA - TES	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGet1      := TGet():New( D(016),D(012),{|u| If(PCount()>0,cProdAglut :=u,cProdAglut)},oDlg1,D(074),D(008),'',{|| IIF(Empty(cProdAglut).Or.!ExistCpo("SF4",cProdAglut), (cDescProd:=''), (cDescProd := AllTrim(Posicione('SF4',1,xFilial('SF4')+cProdAglut,'F4_TEXTO')),oGet1:Refresh() ) ) },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF4","",,)
	
EndIf	

oSay1      := TSay():New( D(019),D(090),{|| Left(cDescProd,50) },oDlg1,,oFont0,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(150),D(008) )


**********************
oTblTRB2()              
**********************
cMarca 		:= GetMark()
DbSelectArea("TRB2")        

oGrp2      := TGroup():New( D(030),D(008),D(135),D(230),"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBrw2      := MsSelect():New( "TRB2","OK","",{{"OK","","",""},{"ITEM","","Item",""},{"CODFOR","","Cod.Fornec",""},{"DESCR","","Descrição",""}},.F.,cMarca,{D(035),D(012),D(130),D(225)},,, oGrp2 ) 

oBrw2:oBrowse:bAllMark  :=  {|| MarcaTRB2(), oBrw2:oBrowse:Refresh() }

oBtn2      := TButton():New( D(140),D(080),"&OK",oDlg1,{|| ConfirmaTRB2(),oDlg1:End() },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( D(140),D(120),"&Cancelar",oDlg1,{|| oDlg1:End() },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

IIF(Select("TRB2") != 0, TRB2->(DbCLoseArea()), )
oBrwV:oBrowse:Refresh()

Return()
*****************************************************************
Static Function oTblTRB2()
*****************************************************************
Local 	aFds := {}
Local 	cTmp
Local   nPosItem    := 	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_ITEM'    	})
Local   nPosPFor    :=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'C7_PRODUTO' 	})
Local	nPosDesc    :=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'B1_DESCFOR'  	})
Local	nPosLocal	:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_LOCAL'   	})
Local	nPosTES		:= 	Ascan(aMyHeader  ,{|X| AllTrim(X[2]) == 'D1_TES'		})
Local   nPosCF		:=	aScan(aMyHeader  ,{|x| Alltrim(x[2]) == 'D1_CF'	 	})

If Select("TRB2") == 0
	Aadd( aFds , {"OK"      ,"C",002,000} )
	Aadd( aFds , {"ITEM"    ,"C",004,000} )
	If cOpcao == 'ALMOX'
		Aadd( aFds , {"LOCALP"	,"C",002,000} )	
	ElseIf cOpcao == 'TES'
		Aadd( aFds , {"TES"	,"C",003,000} )
	EndIf
	Aadd( aFds , {"CODFOR"  ,"C",015,000} )
	Aadd( aFds , {"DESCR"	,"C",030,000} )
	
	cTmp := CriaTrab( aFds, .T. )
	Use (cTmp) Alias TRB2 New Exclusive
    Aadd(aArqTemp, cTmp)
Else
   DbSelectArea("TRB2") 
   RecLock('TRB2', .F.)
       Zap
   MsUnLock()
EndIf                 

DbSelectArea("TRB2")
For nX:=1 To Len(oBrwV:aCols)                                                       
   RecLock("TRB2",.T.)
		TRB2->ITEM  		:= oBrwV:aCols[nX][nPosItem]
		If cOpcao == 'ALMOX'
			TRB2->LOCALP 	:= oBrwv:aCols[nX][nPosLocal]
		ElseIf cOpcao == 'TES'
			TRB2->TES 	:= oBrwv:aCols[nX][nPosTES]
			MaAvalTes("E",TRB2->TES ) //M->D1_TES)
			MaFisRef("IT_TES","MT100", oBrwv:aCols[nX][nPosTES]) //M->D1_TES)
			oBrwV:aCols[oBrwV:NAT][nPosCF] := Posicione("SF4",1,xFilial("SF4")+oBrwv:aCols[nX][nPosTES],"F4_CF")
		EndIf
			
		TRB2->CODFOR  	:= oBrwv:aCols[nX][nPosPFor]
		TRB2->DESCR		:= IIF(nPosDesc>0, oBrwV:aCols[nX][nPosDesc], '' )
   MsUnLock()
Next

TRB2->(DbGoTop())

IIF(Type('oBrw1:oBrowse')!='U', (oBrw1:oBrowse:Refresh(),oBrw1:oBrowse:Setfocus()), )
IIF(Type('oBrwV:oBrowse')!='U', (oBrwV:oBrowse:Refresh(),oBrwV:oBrowse:Setfocus()), )
Return()                                             
*****************************************************************
Static Function ConfirmaTRB2()
*****************************************************************
Local   nPosItem    :=    Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_ITEM'	})
Local   nPosProd    :=    Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_COD'		})
Local   nPosLocal   :=    Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_LOCAL'	})
Local   nPosTES     :=    Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_TES'		})
Local   nPUm         :=    Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_UM'		})  
Local   nPosDesc    :=    Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'B1_DESC'	})	//	ATUALIZA COLUNA DESCRICAO PRODUTO EMPRESA

DbSelectArea('TRB2');DbGoTop()
Do While !Eof()

	lDeletado := oBrwV:aCols[Val(TRB2->ITEM)][Len(aMyHeader)+1]

	If IsMark('OK', cMarca ) .And. !lDeletado
	
		If cOpcao=='PROD' .And. nPosProd > 0
		
			oBrwv:aCols[Val(TRB2->ITEM)][nPosProd] :=  cProdAglut
			
			If nPosDesc > 0
				oBrwv:aCols[Val(TRB2->ITEM)][nPosDesc]:= Posicione('SB1', 1, xFilial("SB1") + cProdAglut, 'B1_DESC')			
			EndIf
						                            
			If nPosLocal > 0
				oBrwv:aCols[Val(TRB2->ITEM)][nPosLocal]:= Posicione('SB1', 1, xFilial("SB1") + cProdAglut, 'B1_LOCPAD')
			EndIf
	
			If 	nPosTES > 0
				oBrwv:aCols[Val(TRB2->ITEM)][nPosTES] 	:=   Posicione('SB1', 1, xFilial("SB1") + cProdAglut, 'B1_TE')
			EndIf						    

			If 	nPUm > 0
				oBrwv:aCols[Val(TRB2->ITEM)][nPUm] 	:=   AllTrim(Posicione('SB1',1,xFilial('SB1')+ cProdAglut ,'B1_UM'))
			EndIf	
					
		ElseIf cOpcao=='ALMOX' .And. nPosLocal > 0
			oBrwv:aCols[Val(TRB2->ITEM)][nPosLocal]:=  cProdAglut
		
		ElseIf cOpcao=='TES' .And. nPosTES > 0
			oBrwv:aCols[Val(TRB2->ITEM)][nPosTES] 	:=  cProdAglut
		
		EndIf

    	oBrwV:oBrowse:ColPos  := nPosProd
    	GravaZXP('REPLICA', Val(TRB2->ITEM))
    			
    EndIf

    DbSelectArea('TRB2')
    DbSkip()
    
EndDo

Return()
***********************************************************
Static Function MarcaTRB2(cPar)    //    [4.1.3]
***********************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desmarca TODOS os itens do Browse              |
//³ Chamada -> LoadFiles()                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRB2->(DbGoTop())
_cMarca    :=    IIF(Empty(TRB2->OK), cMarca,'')
Do While TRB2->(!Eof())
   RecLock("TRB2",.F.)
       TRB2->OK  := _cMarca
   MsUnLock()
   DbSkip()
EndDo

TRB2->(DbGoTop())

Return()
*****************************************************************
User Function Carrega_XML()    //    [4.0]
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona XML - Pasta\Email        |
//³ Chamada -> Rotina Carrega XML      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local	aAlias4  := GetArea()
Private	cTpCarga :=	''


nOpc := Aviso('Carega XML','Deseja Carregar XML de uma Pasta ou do Email???',{'Pasta','Email','Sair'}, 2)

If nOpc == 1
   MsgRun("Recebendo XML PASTA ",,{|| LoadFiles(cTpOpen:='IMPORTAR') })    						// [4.1]
ElseIf nOpc == 2
   Processa ({|| RecebeEmail(cTpOpen:='EMAIL') },"Recebendo XML EMAIL ",'Processando...', .T.)   	// [4.2]
EndIf


RestArea(aAlias4)
Return()
************************************************************
Static Function LoadFiles()    //    [4.1]
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona XML PASTA             ³
//³ Chamada -> Carrega_XML()        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cMarca        	:=	GetMark()
Private nQtdArqXML  	:= 	0
Private aStatus			:= 	{}
Static  cDiretorioXML	:=	Space(200)

SetPrvt('oDlg1','oGrp','oSay1','oGet1','oBrw1','oBtn1','oBtn2','oBtn3')



If Select('TMPCFG') == 0
   DbUseArea(.T.,,_StartPath+cArqConfig, 'TMPCFG',.T.,.F.)
   DbSetIndex(_StartPath+cIndConfig)
EndIf
DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()
DbSeek(cEmpAnt+cFilAnt, .F.)     

//	COM "\" NO FINAL NAO ENCONTRA O DIRETORIO
cPathXML := AllTrim(TMPCFG->PATH_XML)
If 	Right(cPathXML,1)=='\'
	cPathXML := SubStr(cPathXML,1, Len(cPathXML)-1)
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³    TELA CARREGA ARQUIVO XML     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDlg1      := MSDialog():New( D(095),D(232),D(427),D(740),"Carregar arquivo XML - IMPORTAR",,,.F.,,,,,,.T.,,,.T. )
oGrp       := TGroup():New( D(004),D(004),D(146),D(250),"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( D(012),D(008),{||"Caminho do(s) Arquivo(s)"},oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(064),D(008) )
oGet1      := TGet():New( D(020),D(008),{|u| If(PCount()>0,cDiretorioXML :=u,cDiretorioXML)},oGrp,D(230),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,{|| IIF(!Empty(cDiretorioXML),(AdicionaAnexo(), oBrw1:oBrowse:Refresh()),) },.F.,.F.,"","",,)
oBtn1      := TButton():New( D(018),D(238),"...",oGrp,{|| cDiretorioXML  := 	cGetFile("Anexos (*xml)|*xml|","Arquivos (*xml)",0,cPathXML,.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_MULTISELECT+GETF_RETDIRECTORY),; 
																		IIF(!Empty(cDiretorioXML), Processa ({||AdicionaAnexo(),'Processando....','Carregando Arquivos',.F.}),), IIF(nQtdArqXML==0, oSay2:Hide(), oSay2:Show()),oBrw1:oBrowse:Refresh() },D(011),D(011),,,,.T.,,"",,,,.F. )

oSay2      := TSay():New( D(034),D(008),{|| AllTrim(Str(nQtdArqXML))+" arquivo(s) selecionado(s)"},oGrp,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(150),D(008) )
IIF(nQtdArqXML==0, oSay2:Hide(), oSay2:Show())
oSay2:Refresh()

****************************
   oTbl()    // CRIAR ARQ. TEMP
****************************
DbSelectArea("TMP")
oBrw1      := MsSelect():New( "TMP","OK","",{{"OK","","",""},{"ARQUIVO","","Arquivo",""}},.F.,cMarca,{D(040),D(008),D(140),D(245) },,, oGrp )
                                                                                    
oBtn2      := TButton():New( D(150),D(086),"Ok"  ,oDlg1,{|| Processa ({|| Open_Xml('XML_TMP','','', cDiretorioXML,0,0)},'Verificando Arquivos XML','Processando...', .F.) ,oDlg1:End() },D(037),D(012),,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( D(150),D(146),"Sair",oDlg1,{|| oDlg1:End(), lClose:=.T.},D(037),D(012),,,,.T.,,"",,,,.F. )

oBrw1:oBrowse:bAllMark      :=    {|| MarcaTMP(),         oSay2:Refresh(), oBrw1:oBrowse:Refresh() }
oBrw1:oBrowse:bLDblClick    :=    {|| Des_MarcaTMP(),     oSay2:Refresh(), oSay2:Refresh()}


oDlg1:Activate(,,,.T.,{||.T.})


IIF(Select("TMP") != 0, TMP->(DbCLoseArea()), )

If Len(aStatus) > 0
   ******************************
       MensStatus()
   ******************************
EndIf


Return()
************************************************************
Static Function oTbl()    //    [4.1.1]
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria\Limpa Arq. Temp            			³
//³ Chamada -> Carrega_XML()->LoadFiles()       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aFds := {}
Local cTmp

If Select("TMP") == 0
   Aadd( aFds , {"OK"      ,"C",002,000} )
   Aadd( aFds , {"ARQUIVO" ,"C",200,000} )

   cTmp := CriaTrab( aFds, .T. )
   Use (cTmp) Alias TMP New Exclusive
   Aadd(aArqTemp, cTmp)
Else
   LimpaTMP()
EndIf

Return()
***********************************************************
Static Function AdicionaAnexo()		//	[4.1.2]
***********************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona no Browser os itens XML de uma pasta  |
//³ Chamada -> Carrega_XML()->LoadFiles()          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local    aArqXml     :=    {}


If !Empty(cDiretorioXML)
	nQtdArqXML    := 0
	cDiretorioXML := cDiretorioXML+IIF(Right(AllTrim(cDiretorioXML),1)=='\','','\')
	aDir(AllTrim(cDiretorioXML)+'*.xml',aArqXml)
Else
	cDiretorioXML := Space(200)
	Return()
EndIf                

**********************
   LimpaTMP()
**********************

For _X:=1 To Len(aArqXml)
   nQtdArqXML++
   RecLock("TMP",.T.)
       TMP->OK 	     := cMarca
       TMP->ARQUIVO  := aArqXml[_X]
   MsUnLock()
Next

TMP->(DbGoTop())

Return()
***********************************************************
Static Function MarcaTMP(cPar)    //    [4.1.3]
***********************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desmarca TODOS os itens do Browse              |
//³ Chamada -> Carrega_XML()->LoadFiles()          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nQtdArqXML := 0
DbSelectArea('TMP');DbGoTop()
_cFlag    :=    IIF(!Empty(TMP->OK), cMarca,'')
Do While TMP->(!Eof())
   If !Empty(_cFlag)
       nQtdArqXML :=	0
	Else
		nQtdArqXML++	
   EndIf
   RecLock("TMP",.F.)
       TMP->OK  := IIF(!Empty(_cFlag),'', cMarca)
   MsUnLock()
   DbSkip()
EndDo

TMP->(DbGoTop())

Return()
***********************************************************
Static Function Des_MarcaTMP()    //    [4.1.4]
***********************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Marca\Desmarca itens do Browse                 |
//³ Chamada -> Carrega_XML()->LoadFiles()          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cMarca    :=    IIF(Empty(TMP->OK), cMarca,'')
If !Empty(_cMarca)
   nQtdArqXML++
Else
   nQtdArqXML--
EndIf

RecLock("TMP",.F.)
   TMP->OK  := _cMarca
MsUnLock()


Return()
***********************************************************
Static Function LimpaTMP()    //    [4.1.5]
***********************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa Arq.Temp                                 |
//³ Chamada -> Carrega_XML()->LoadFiles()          ³
//³         -> oTbl(), AdicionaAnexo()             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select('TMP') > 0
   DbSelectArea("TMP")
   RecLock('TMP', .F.)
       Zap
   MsUnLock()
Endif

TMP->(DbGoTop())

Return()
*****************************************************************
Static Function RecebeEmail(cTpCarga)    //    [4.2]
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca XML do EMAIL              ³
//³ Chamada -> Carrega_XML()        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local cTpConexao	:=	''
Local cServerEnv    :=	''
Local cServerRec    :=	''
Local cPassword    	:=	''
Local cAccount     	:=	''
Local cOrigFolder	:=	''
Local cDestFolder	:=	''
Local cPortEnv    	:=	''
Local cPortRec    	:=	''
Local nNumMsg		:= 	0
Local aAllFolder	:= 	{}
Local lConect		:=	.F.
Local lCreateFolder	:=	.F.
Local lMoveEmail	:=	.F.
Local lAutent
Local lSegura
Local lSSL
Local lTLS

Local oServer
Local oMsg
Local nConfig
Local nConecTou

Private aStatus    := {}



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BUSCA AS CONFIGURACOES DEFINIDAS PELO USUARIOS ³
//³NO PAINEL DE CONFIGURACAO                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()
If DbSeek(cEmpAnt+cFilAnt, .F.)

	cTpConexao	:=	Left( AllTrim(TMPCFG->TIPOEMAIL),3)
	cServerEnv	:=	AllTrim(TMPCFG->SERVERENV)
	cServerRec	:=	AllTrim(TMPCFG->SERVERREC)
	cPassword	:=	AllTrim(TMPCFG->SENHA)
	cAccount	:=	AllTrim(TMPCFG->EMAIL)
	cOrigFolder	:=	AllTrim(TMPCFG->PASTA_ORIG)
	cDestFolder	:=	AllTrim(TMPCFG->PASTA_DEST)
	cPortEnv	:=	AllTrim(TMPCFG->PORTA_ENV)
	cPortRec	:=	AllTrim(TMPCFG->PORTA_REC)
	lAutent		:=	TMPCFG->AUTENTIFIC
	lSegura		:=	TMPCFG->SEGURA
	lSSL		:=	TMPCFG->SSL
	lTLS		:=	TMPCFG->TLS

Else                

   MsgInfo('Não encontrado arquivo de configuração da Empresa: '+cEmpAnt+' \ Filial: '+cFilAnt+ENTER+ENTER+'Utilize o Botão de Configuração...')
   Return()

EndIf
                                            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SMTP     -> PROTOCOLO DE ENVIO     	   ³
//³ POP\IMAP -> PROTOCOLO DE RECEBIMENTO   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oServer := TMailManager():New()

If lSegura
	oServer:SetUseSSL(lSSL)					//		Define o envio de e-mail utilizando uma comunicação segura através do SSL - Secure Sockets Layer.
	oServer:SetUseTLS(lTLS)					//		Define no envio de e-mail o uso de STARTTLS durante o protocolo de comunicação.
EndIf	


							//	SERVER RECEBIMENTO,	 SERVER ENVIO	   ,		EMAIL		  ,	    SENHA	  	  , PORTA RECEBIMENTO  ,  PORTA ENVIO
nConfig    :=    oServer:Init( AllTrim(cServerRec), AllTrim(cServerEnv), AllTrim(cAccount), AllTrim(cPassword), Val(cPortRec), Val(cPortEnv) )

If lAutent
	oServer:SMTPAuth(oServer:GetUser(), AllTrim(cPassword))
EndIf



If cTpConexao == 'IMAP'
   nConecTou     :=    oServer:IMAPConnect()
ElseIf Left(cTpConexao,3) == 'POP'
   nConecTou     :=    oServer:PopConnect()
ElseIf cTpConexao == 'MAPI'
     nConecTou   :=    oServer:ImapConnect()
ElseIf cTpConexao == 'SMTP'
     nConecTou   :=    oServer:SmtpConnect()
EndIf


#IFDEF WINDOWS
   lConect := IIF(nConectou != 0, .F., .T.)
#ELSE
   If nConectou == 0 .And. cTpConexao != 'MAPI'
       lConect := .T.
   ElseIf nConecTou == 1 .And. cTpConexao == 'MAPI'
       lConect := .T.
   Else
       lConect := .F.
   EndIf
#ENDIF


If  !lConect
       MsgBox(	"Não foi possível ler emails da conta..."+ENTER+; 
       			"Servidor Recebimento: "+cServerRec+ENTER+;
           		"Servidor Envio: "    +cServerEnv+ENTER+;
				"Usuário:  "    +cAccount+ENTER+;
				"Porta "    +cTpConexao+": "+cPortRec+ENTER+;
				"Porta SMTP: "+cPortEnv+ENTER+ENTER+;
				"ERRO: "    +AllTrim(oServer:GetErrorString(nConecTou)) +ENTER+ENTER+;
				"Verifique a configuração de e-mail da filial.") 

Else


   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ VERIFICA SE PASTAS EXISTEM   ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   aAllFolder        :=    oServer:GetAllFolderList()        //    MOSTRA TODAS  AS PASTAS
   lCreateFolder    := .F.

   If cTpConexao == 'IMAP'

	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ PASTA DE ORIGEM	³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If !Empty(cOrigFolder)
           nPosFolder    :=    Ascan(aAllFolder, { |x| Upper(X[1]) == IIF(cOrigFolder=='Caixa de Entrada','INBOX', Upper(cOrigFolder) )} )
           If nPosFolder == 0
               If MsgYesNo('Pasta de Origem '+cOrigFolder+' não existe...'+ENTER+'Deseja criar essa pasta ???')
                   lCreateFolder := .T.
                   Processa ({|| },'Aguarde criando pasta de Origem...','Processando...', .T.)

                   oServer:CreateFolder(cOrigFolder)                    //    CRIA PASTA
                   oServer:SetFolderSubscribe(cOrigFolder, .T.)        //    ASSINA PASTA, DEIXA ELA VISIVEL
                   aAllFolder     := oServer:GetFolder()               //    MOSTRA APENAS AS PASTAS ASSINADAS
               EndIf
            Else                                                   
              	  cOrigFolder := IIF(cOrigFolder=='Caixa de Entrada','INBOX', cOrigFolder )
                  oServer:ChangeFolder(cOrigFolder)
           EndIf

       Else
       	  cOrigFolder := IIF(cOrigFolder=='Caixa de Entrada','INBOX', cOrigFolder )
          oServer:ChangeFolder(cOrigFolder)
       EndIf


	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ PASTA DE DESTINO	³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       If !Empty(cDestFolder)
           lMoveEmail    :=    .T.
           nPosFolder    :=    Ascan(aAllFolder, { |x| Upper(X[1]) == Upper(cDestFolder) })
           If nPosFolder == 0
               If MsgYesNo('Pasta de Destino '+cDestFolder+' não existe...'+ENTER+'Deseja criar essa pasta ???')
                   lCreateFolder := .T.
                   Processa ({|| },'Aguarde criando pasta de Destino...','Processando...', .T.)

                   oServer:CreateFolder(cDestFolder)
                    oServer:SetFolderSubscribe(cDestFolder, .T.)
                   aAllFolder  := oServer:GetFolder()
               EndIf
           EndIf
      EndIf

       If lCreateFolder
           MsgAlert('Feche e abra novamente o gerenciador de e-mail para visualizar as pastas criadas...')
       EndIf
   EndIf


   // SELECIONA A PASTA DE E-MAIL DE ORIGEM
   cOrigFolder := IIF(cOrigFolder=='Caixa de Entrada','INBOX', cOrigFolder )
   oServer:ChangeFolder(cOrigFolder)


   If cTpConexao == 'IMAP'
       oServer:SetUseRealID( .T. )
   EndIf
   
   	nRet := oServer:GetNumMsgs(@nNumMsg)
	ProcRegua(nNumMsg)


   oMsg :=  TMailMessage():New()

   For nX :=1 To nNumMsg

       IncProc()
       oMsg:Clear()
       oMsg:Receive( oServer, nX )
       //aMsgHeader := oServer:GetMsgHeader(nX)
       //aMsgBody	  := oServer:GetMsgBody(nX)

       	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       	//³  VERIFICA O TIPO DO ANEXO    ³
       	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nY := 1 To oMsg:GetAttachCount()

           	aInfo        :=    {}
			aInfo        :=    oMsg:GetAttachInfo(nY)
			If Right(aInfo[1], 4) == '.xml'

               cAnexo  :=    oMsg:GetAttach(nY)
               //Aadd( aXMLEmail, {cAnexo} )

               //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
               //³    ABRE E GRAVA ARQUIVO XML          ³
               //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               ***********************************************
                   Open_Xml('XML_EMAIL', cAnexo, AllTrim(oMsg:cSubject)+' - '+AllTrim(aInfo[1]), cDiretorioXML, nX, nNumMsg)
               ***********************************************

               If cTpCarga == 'EMAIL' .And. cTpConexao == 'IMAP'

                   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                   //³Move uma mensagem da pasta em uso, do servidor IMAP         ³
                   //³para outra pasta contida na conta de e-mail.                |
                   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                   If lMoveEmail
                       oServer:MoveMsg(nX, cDestFolder)
                   EndIf
				
				EndIf
			
			EndIf

		Next

	Next


Endif
                


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MOSTRA TELA COM STATUS DA IMPORTACAO DO XML  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aStatus) > 0
   ******************************
       MensStatus()
   ******************************
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DESCONECTA DE E-MAIL		|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lConect
   If cTpConexao == 'IMAP'
       oServer:SmtpDisconnect()
   ElseIf Left(cTpConexao,3) == 'POP'
       oServer:PopDisconnect()
   ElseIf cTpConexao == 'MAPI'
       oServer:ImapDisconnect()
   ElseIf cTpConexao == 'SMTP'
       oServer:SmtpDisconnect()
   EndIf
EndIf

Return()
*****************************************************************
Static Function Open_Xml(cTpOpen, cAnexo, cNomeArq, cDiretorioXML, nImportados, nMarcados)    //    [4.1.6] - [4.2.1]
*******************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre XML                                ³
//³ Chamada -> LoadFiles()-> RecebeEmail()  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cArqXML := ''




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BUSCA XML PELO DIRETORIO   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTpOpen == 'XML_TMP'

	nMarcados	:=	0
	nImportados	:=	0	
	For nX:=1 To nQtdArqXML
		If !Empty(cMarca)
			nMarcados++
		EndIf
	Next

	ProcRegua(nMarcados)
	DbSelectArea('TMP');DbGoTop()
	Do While !Eof()
   
		If IsMark('OK', cMarca )

			nImportados++
			IncProc('Importando arquivos XML... '+ AllTrim(Str(nImportados))+' de '+ AllTrim(Str(nMarcados))  )

			cArqXML	:=	AllTrim(TMP->ARQUIVO)
			cAnexo	:=	''
           	ProcRegua(Len(cAnexo))

			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³REALIZA A LEITURA DO ARQUIVO XML ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If File(AllTrim(cDiretorioXML)+cArqXML)
				FT_FUSE(AllTrim(cDiretorioXML)+cArqXML)
				FT_FGOTOP()
				Do While !FT_FEOF()
					cAnexo    += FT_FREADLN()
					FT_FSKIP()
               	EndDo
               	FT_FUSE()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ REALIZA VERIFICACOES E GRAVA XML³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				******************************************************
					Grava_Xml(cAnexo, cArqXML, nImportados, nMarcados )
				******************************************************
				If  Len(aStatus) > 0 
					If aStatus[Len(aStatus)][1] $ 'I/G'
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ RENOMEA XML PARA NOMEXML_IMPORTADO		³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							Renomea_XML(Len(aStatus))
					EndIf
				EndIf

			EndIf
		EndIf

		IncProc()
		DbSelectArea('TMP')
		DbSkip()

		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ JA IMPORTOU TODOS OS ARQUIVOS MARCADOS...        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nImportados == nMarcados
			Exit
		EndIf

	EndDo

	TMP->(DbGoTop())


ElseIf cTpOpen == 'XML_EMAIL'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³BUSCA XML PELO E-MAIL	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ NAO PRECISA ABRIR O XML E LER LINHA A LINHA...                     |
   //| NA FUNCAO QUE ABRE O ANEXO DO EMAIL JA VEM TODA A ESTRUTURA DO XML |
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   ****************************************
       Grava_Xml(cAnexo, AllTrim(cNomeArq),nImportados, nMarcados)
   ****************************************

EndIf

Return()
***********************************************************
Static Function Grava_Xml(cAnexo, cArqXML, nImportados, nMarcados )
***********************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parse\Grava XML                         ³
//³ Chamada -> LoadFiles()->Open_Xml()      |
//³            RecebeEmail()->Open_Xml()    |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDestEmpAnt	:=	''
Local cDestFilial	:=	''
Local cStatus		:=	''
Local cDocSF1		:=	''
Local cSerieSF1   	:=	''
Local cCodSA2    	:=	''
Local cLojaSA2    	:=	''
Local cNomeSA2     	:=	''
Local cUFSA2     	:=	''
Local cTipoNFe		:=	''
Local cError        :=	''
Local cWarning      :=	''
Local cRest			:=	''
Local cSA2Modo:=cSF1Modo:=cZXMModo:=cZXNModo:=''
Local dDtEntrada    :=	StoD('  \  \  ')
Local lStatus		:=	.F.
Local lEntrada		:=	.F.
Local lExterior		:=	.F.

Private oXml        :=	Nil
Private nItensXML   :=	0
Private cInfAdic    :=	''
Private cDataNFe    :=	''
Private cEmitCnpj   :=	''
Private cEmitNome   :=	''
Private cDestNome   :=	''
Private cDestCnpj   :=	''
Private cNotaXML    :=	''
Private cSerieXML   := 	''
Private cChaveXML   :=	''
Private cNatOper    :=	''



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| VERIFICA SE TABELAS SAO COMPARTILHADAS OU EXCLUSIVAS	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('SA2'))
   cSA2Modo	:=	AllTrim(SX2->X2_MODO)
EndIf
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('SF1'))
   cSF1Modo	:=	AllTrim(SX2->X2_MODO)
EndIf
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('ZXM'))
   cZXMModo	:=	AllTrim(SX2->X2_MODO)
EndIf
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('ZXN'))
   cZXNModo	:=	AllTrim(SX2->X2_MODO)
EndIf
					

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³     ABRE XML - CABEC        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   **************************************************************************************
       aRet := ExecBlock("CabecXmlParser",.F.,.F., { IIF(Empty(cAnexo),'Erro',cAnexo)} )
   **************************************************************************************

If Type('_aEmpFil') == 'U'
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³Utilizado para criar variaveis Private |
	   //|Rotina xxxx nao cria essa var.         |
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       ExecBlock("IniConfig",.F.,.F.,)
EndIf



If aRet[1] == .T.	//	aRet[1] == .F. SIGNIFICA XML COM PROBLEMA NA ESTRUTURA


   	nPos := Ascan(_aEmpFil, { |X| X[3] == cDestCnpj } ) 
	If nPos == 0 .And. cDestCnpj != 'EXTERIOR'

       	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       	//³ NAO ENCONTROU O CNPJ DO DESTINATARIO  ³
       	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       	cStatus	:=    'C'
       	lStatus	:=	.T.
		Aadd(aStatus, {cStatus, cArqXML, Transform(cDestCnpj, IIF(Len(cDestCnpj)==14,'@R 99.999.999/9999-99','@R 999.999.999-99'))  +' - '+ cDestNome, cDiretorioXML, cDestCnpj })

	ElseIf cDestCnpj == 'EXTERIOR'
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  IMPORTACAO               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        	
       	cDestCnpj := cEmitCnpj
       	cEmitCnpj := 'EXTERIOR'
         	
	   	nPos := Ascan(_aEmpFil, {|X| X[3] == cDestCnpj } ) 
       	If nPos == 0
       		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       		//³ NAO ENCONTROU O CNPJ DO DESTINATARIO  ³
       		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       		cStatus	:=	'C'
       		lStatus	:=	.T.
			Aadd(aStatus, {cStatus, cArqXML, 'IMPORTAÇÃO.  '+Transform(cDestCnpj, IIF(Len(cDestCnpj)==14,'@R 99.999.999/9999-99','@R 999.999.999-99'))  +' - '+ cDestNome, cDiretorioXML, cDestCnpj })
         EndIf
         
    EndIf
    
	
	If nPos > 0


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ SALVA EMPRESA\FILIAL\NOME DESTINO     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDestEmpAnt    :=    _aEmpFil[nPos][1]
		cDestFilial    :=    _aEmpFil[nPos][2]
		cNomeEmpFil    :=    _aEmpFil[nPos][4]
		cNomeFilial    :=    _aEmpFil[nPos][5]



		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ VERIFICA SE XML Eh PARA A MESMA EMPRESA QUE ESTA POSICIONADO  				|
		//³ CASO XML FOR IMPORTADO PELA EMPRESA 01 E O XML SEJA PARA EMPRESA 02			|
		//| ABRE-SE AS TABELAS DA EMPRESA 02... NO FINAL DA ROTINA VOLTA PARA EMPRESA 01	|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cDestEmpAnt != cEmpAnt


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ VERIFICA SE TABELA ZXM ESTA COM TODOS CAMPOS CRIADOS |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()
           	If DbSeek(cDestEmpAnt+cDestFilial, .F.)


				If !TMPCFG->ESTRUT_ZXM


					If !ExecBlock("CreateTable",.F.,.F.,{cDestEmpAnt} )

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                       	//³ TABELA ZXM NAO EXISTE NA EMPRESA DESTINO |
                       	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                       	cStatus  :=  'X'
                       	lStatus	:=	.T.
                       	Aadd(aStatus, {cStatus, cArqXML, cDestEmpAnt, cNomeEmpFil, cNomeFilial, cDiretorioXML, cDestCnpj })

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ RETORNA COM TABELAS DA EMPRESA ATUAL     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						IIF(Select("SA2") != 0, SA2->(DbCLoseArea()), )
						IIF(Select("SF1") != 0, SF1->(DbCLoseArea()), )
						IIF(Select("ZXM") != 0, ZXM->(DbCLoseArea()), )
						IIF(Select("ZXN") != 0, ZXN->(DbCLoseArea()), )
						
						EmpOpenFile('SA2',"SA2",1,.T.,cEmpAnt,@cSA2Modo)
						EmpOpenFile('SF1',"SF1",1,.T.,cEmpAnt,@cSF1Modo)
						EmpOpenFile('ZXM',"ZXM",1,.T.,cEmpAnt,@cZXMModo)
						EmpOpenFile('ZXN',"ZXN",1,.T.,cEmpAnt,@cZXNModo)
						
						Return()

					EndIf

				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ FECHA ARQUIVOS DA EMPRESA ATUAL       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IIF(Select("SA2") != 0, SA2->(DbCLoseArea()), )
				IIF(Select("SF1") != 0, SF1->(DbCLoseArea()), )
				IIF(Select("ZXM") != 0, ZXM->(DbCLoseArea()), )
				IIF(Select("ZXN") != 0, ZXN->(DbCLoseArea()), )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ ABRE ARQUIVOS DA EMPRESA DESTINO      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				EmpOpenFile('SA2',"SA2",1,.T.,cDestEmpAnt,@cSA2Modo)
				EmpOpenFile('SF1',"SF1",1,.T.,cDestEmpAnt,@cSF1Modo)
				EmpOpenFile('ZXM',"ZXM",1,.T.,cDestEmpAnt,@cZXMModo)
				EmpOpenFile('ZXN',"ZXN",1,.T.,cDestEmpAnt,@cZXNModo)
   
			Else
		
				MsgAlert('Não encontrado Empresa: '+cDestEmpAnt+'\'+cNomeEmpFil+' Filial: '+cDestFilial+'-'+cNomeFilial+' no arquivo ZXM_CFG.DBF')
				Aadd(aStatus, {'XX', cArqXML, 'Não encontrado Empresa: '+cDestEmpAnt+'\'+cNomeEmpFil+' Filial: '+cDestFilial+'-'+cNomeFilial+' no arquivo ZXM_CFG.DBF','','' })
				Return()      
			EndIf
        EndIf
	EndIf



		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  VERIFICA CONFIGURACAO DA EMPRESA ATUAL     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       	DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()
       	If DbSeek(cEmpAnt + cFilAnt, .F.) .And. !lStatus

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           	//³ ATUALIZA VARIAVEIS CONFORME CNOFIGURACOES   ³
           	//|	NOTA E SERIE - SE PREENCHE COM ZEROS OU NAO |	
           	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           	cNotaXML     :=    IIF(TMPCFG->NFE_9DIG=='SIM',PadL(AllTrim(cNotaXML),9,'0'), cNotaXML    )
				
			If Left(TMPCFG->CNPJ,8) == Left(cEmitCnpj,8)
			
				// BUSCA A SERIE DA FILIAL DE SAIDA DA NOTA DE TRANSFERENCIA
				DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()
				Do While !Eof()
 					If TMPCFG->CNPJ == cEmitCnpj
							cSerieXML  := TMPCFG->SER_TRANSF
						Exit
					EndIf
					DbSkip()
				EndDo       
				
				//	 VOLTA PARA REGISTRO ANTERIOR
		       	DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()
		       	DbSeek(cEmpAnt + cFilAnt, .F.)
			       	
			ElseIf TMPCFG->SER_3DIG == 'SIM'	//	18/10/2011
				cSerieXML  := PadL(AllTrim(cSerieXML),3,'0')
			Else
				 cSerieXML := cSerieXML
			EndIf
			
           	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           	//³  SE FORNECEDOR FOR DO EXTERIOR USUARIOS DEVERA INFORMAR CODIGO DO FORNECE	|
           	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	        If cEmitCnpj == 'EXTERIOR'
				lExterior := .T.
		    Else
		    	lExterior := .F.
			EndIf
	
	
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³  VERIFICA FORNECEDOR \ CLIENTE  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    lCliente  := .F.
	    lFornece  := .F.
      	cTipoNFe  := ''
             
		If lExterior
           	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           	//³  XML - IMPORTACAO		³
           	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCodSA2    	:=  ''
           	cLojaSA2    :=  ''
           	cNomeSA2    := 	''
           	cUFSA2		:=	''
	
		ElseIf !lNFeDev
           	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           	//³  XML - TIPO DE ENTRADA NORMAL   ³
           	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           	//DbSelectarea("SA2");IIF(!lExterior,DbSetOrder(3),DbSetOrder(1));DbGoTop()
           	//If Dbseek(xFilial("SA2") + cEmitCnpj, .F.)
	
				lFornece	:= 	ForCliMsBlql('SA2', cEmitCnpj, .F.)  // BUSCA POR CNPJ
			
				cCodSA2    	:=  SA2->A2_COD
               	cLojaSA2    :=  SA2->A2_LOJA
               	cNomeSA2    := 	AllTrim(SA2->A2_NOME)
	           	cUFSA2		:=	SA2->A2_EST
	           	// lFornece	:= 	.T.
	
			//EndIf
        

		Else
            
           	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           	//³ XML - TIPO DEVOLUCAO - lNFeDev == TAG NFREF  ³
           	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           	//DbSelectarea("SA1");IIF(!lExterior,DbSetOrder(3),DbSetOrder(1));DbGoTop()
           	//If Dbseek(xFilial("SA1") + cEmitCnpj, .F.)

   				lCliente	:= ForCliMsBlql('SA1', cEmitCnpj, .F.)  // BUSCA POR CNPJ
   				
               	cCodSA2    	:=  SA1->A1_COD
               	cLojaSA2    :=  SA1->A1_LOJA
               	cNomeSA2    :=  AllTrim(SA1->A1_NOME)
	           	cUFSA2		:=	SA1->A1_EST
	           	// lCliente	:= .T.

           	//EndIf

		EndIf

           	
        If !lExterior .And. (lCliente .Or. lFornece)
               
           	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           	//³ VERIFICA SE NOTA DO FORNECEDOR JA ESTA CADSATRADA NO SISTEMA     |
           	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                                                                     

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           	//³ SX2->X2_UNIC -> F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_FORMUL	 					|
           	//| REALIZA PESQUISA PELO F1_TIPO == N-NORMAL, SE FOR DEVOLUCAO\RETORNO PESQUISA SEM O F1_TIPO	|
           	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           	DbSelectArea("SF1");DbSetOrder(1);DbGoTop()    //    F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
          	If Dbseek(cDestFilial + cNotaXML + cSerieXML + cCodSA2 + cLojaSA2, .F.)
				lEntrada    :=	.T.
              	dDtEntrada 	:= 	SF1->F1_EMISSAO
			   	cTipoNFe	:= 	SF1->F1_TIPO
	
			   	cStatus    	:= 	'G'
				lStatus		:=	.T.
				Aadd(aStatus, {cStatus, cArqXML, cNomeEmpFil, cNomeFilial, cDiretorioXML, cDestCnpj })
	        	
       		               
			Else
				lEntrada    := 	.F.
				dDtEntrada  := 	StoD('  \  \  ')       				
			EndIf
            

        	
		ElseIf !lExterior

           	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           	//³ NAO ENCONTROU O CNPJ DO FORNECEDOR    ³
          	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          	cStatus	:= 'F'
	       	lStatus	:= .T.
			Aadd(aStatus, {cStatus, cArqXML, Transform(cEmitCnpj, IIF(Len(cEmitCnpj)>0,'@R 99.999.999/9999-99','@R 999.999.999-99') ) +' - '+ cEmitNome, cDiretorioXML, cEmitCnpj })
		
		Endif



		If !lStatus .Or. cStatus == 'G' 
           	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           	//³ VERIFICA SE XML JA FOI IMPORTADO   															|
           	//| cStatus == 'G' -> CASO A NF-E JA TENHA INCLUSA NO SISTEMA (SF1) VERIFICA SE JA ESTA NO ZXM.	|
           	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           	DbSelectArea('ZXM');DbSetOrder(6);DbGoTop()
           	If DbSeek( cChaveXML , .F.)
				cStatus	:=	'D'       									//    XML JA IMPORTADO
		        lStatus	:=	.T.
				If cTpCarga !='EMAIL'  
					Aadd(aStatus, {cStatus, cArqXML, cNomeEmpFil+' \ '+cNomeFilial +'  Nota: '+cNotaXML+' Série: '+cSerieXML+' - Fornecedor: '+cCodSA2+'/'+cLojaSA2+'  -  '+cNomeSA2, cDiretorioXML, cDestCnpj })
				EndIf               
           	
           	Else
	           	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	           	//³ 	IMPORTADO COM SUCESSO   	   |
	           	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               	cStatus	:=	IIF(SM0->M0_CGC==cDestCnpj,'I','J')
              	lStatus	:=	.T.
				Aadd(aStatus, {cStatus, cArqXML, cNomeEmpFil, cNomeFilial, cDiretorioXML, cDestCnpj, cNomeFilial })
				
           	EndIf

       	EndIf
            

       	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       	//³ CONSULTA XML-SEFAZ \ GRAVA ZXM     |
       	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If cStatus $ 'I/G/J' 

		aRetorno := {}
    	**************************************************************************************
			 MsgRun("Aguarde... Consultando XML na SEFAZ...  "+IIF(cTpCarga!='EMAIL',AllTrim(Str(nImportados))+' de '+ AllTrim(Str(nMarcados)) ,'') ,,{|| aRetorno :=   ExecBlock("ConsWebNfe",.F.,.F.,{cChaveXML, cDestFilial, cDataNFe}) })
    	**************************************************************************************

		DbSelectArea('ZXM')
		RecLock('ZXM',.T.)
			ZXM->ZXM_FILIAL	:=	cDestFilial
			ZXM->ZXM_STATUS	:=	cStatus
			ZXM->ZXM_FORNEC	:=	IIF(lNFeDev.Or.lExterior,'',cCodSA2 ) // DEVOLUCAO\RETORNO\IMPORTACAO GRAVA FORNEC e LOJA APOS USER SELECIONAR O TIPO [ NA ROTINA OpcaoRetorno ]
			ZXM->ZXM_LOJA	:=	IIF(lNFeDev.Or.lExterior,'',cLojaSA2) 
			If ZXM->(FieldPos("ZXM_NOMFOR")) > 0
				ZXM->ZXM_NOMFOR	:=	cNomeSA2
            EndIf
			If ZXM->(FieldPos("ZXM_UFFOR")) > 0
				ZXM->ZXM_UFFOR	:=	IIF(!Empty(cUFSA2), cUFSA2, IIF(lExterior, 'EX', cUFSA2) )
            EndIf
			ZXM->ZXM_CGC	:=	cEmitCnpj
			ZXM->ZXM_DOC	:=	cNotaXML
			ZXM->ZXM_SERIE	:=	cSerieXML
			ZXM->ZXM_DTIMP	:=	dDataBase
			ZXM->ZXM_CHAVE	:=	cChaveXML
			ZXM->ZXM_DTNFE	:=	dDtEntrada
			ZXM->ZXM_USER	:=	AllTrim(UsrRetName(__cUserId))
			ZXM->ZXM_CODRET	:=	aRetorno[1]
			ZXM->ZXM_SITUAC	:=	IIF(Empty(aRetorno[1]),'',IIF(aRetorno[1]=='100','A',IIF(aRetorno[1]=='101','C','E')))
			ZXM->ZXM_DTXML	:=	aRetorno[2]
			ZXM->ZXM_TIPO	:=	cTipoNFe

	       	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	       	//³ CAMPO MEMO EM SQL SUPORTA APENAS 65.535 CARACTERES	|
	       	//|	TABELA ZXN GRAVA O RESTANTE DO XML					|
	       	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			#IFDEF TOP               
			
				If Len(AllTrim(cAnexo)) > 65535
				
			       	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			       	//³  GRAVA NA TABELA AUXILIAR, ZXN, O RESTANTE DO XML	|
			       	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					**********************************************************************************
						TabSeqXML(cDestFilial, cChaveXML, SubStr(AllTrim(cAnexo), 65535, Len(AllTrim(cAnexo)))) 
					**********************************************************************************
			
					cAnexo	:=	SubStr(cAnexo, 1, 65534)
			
				EndIf
	
			#ENDIF
			
	     	ZXM->ZXM_XML := cAnexo
               
		MsUnlock()

	EndIf

   	EndIf

Else           

	//	aRet[3] -> FLAG XML SEM TAG PROTOCOLO
   cStatus    :=   IIF(Len(aRet)==2, 'E', aRet[3])
   Aadd(aStatus, {cStatus, cArqXML, aRet[2], cDiretorioXML, '' })
   
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  VOLTA AS TABELAS DA EMPRESA ATUAL     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cDestEmpAnt) .And. cDestEmpAnt != cEmpAnt 

	IIF(Select("SA2") != 0, SA2->(DbCLoseArea()), )
	IIF(Select("SF1") != 0, SF1->(DbCLoseArea()), )
	IIF(Select("ZXM") != 0, ZXM->(DbCLoseArea()), )
	IIF(Select("ZXN") != 0, ZXN->(DbCLoseArea()), )	
	
	EmpOpenFile('SA2',"SA2",1,.T.,cEmpAnt,@cSA2Modo)
	EmpOpenFile('SF1',"SF1",1,.T.,cEmpAnt,@cSF1Modo)
	EmpOpenFile('ZXM',"ZXM",1,.T.,cEmpAnt,@cZXMModo)
	EmpOpenFile('ZXN',"ZXN",1,.T.,cEmpAnt,@cZXNModo)
   
   DbGoTop()
   
EndIf
                      

Return()
*********************************************************************
Static Function TabSeqXML(cDestFilial, cChaveXML, cSeqXML)
*********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA NA TABELA AUXILIAR, ZXN, O RESTANTE DO XML	|
//³ Chamada -> Grava XML()				 				|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nSeq := 0

Do While !Empty(cSeqXML)
	
	DbSelectArea('ZXN')
	Reclock('ZXN',.T.)             
		nSeq++
		ZXN->ZXN_FILIAL	:=	cDestFilial
		ZXN->ZXN_CHAVE	:=	cChaveXML
		ZXN->ZXN_SEQ  	:=	StrZero(nSeq,3)
		ZXN->ZXN_XML  	:=	SubStr(cSeqXML, 1, 65534) 
	MsUnlock()

	cSeqXML := SubStr(cSeqXML, 65535, Len(cSeqXML) ) 

EndDo

Return()
*********************************************************************
User Function VerificaZXN()
*********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA NA TABELA AUXILIAR, ZXN, O RESTANTE DO XML	|
//³ Chamada -> CarregaACols()				 			|
//³ 		-> ExpXML()									|
//³ 		-> ConsWebNfe()								|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cFilial	:=	ParamIxb[01]
Local cChave	:=	ParamIxb[02]
Local cRetorno 	:= ''

ZXN->(DbSetOrder(1), DbGoTop())
If ZXN->(DbSeek(_cFilial + cChave ,.F.))
	Do While ZXN->(!Eof()) .And. ZXN->ZXN_CHAVE == cChave
		cRetorno	+=	ZXN->ZXN_XML
	ZXN->(DbSkip())
	EndDo
EndIf

Return(cRetorno)
*********************************************************************
Static Function SA2_SA1ConsPad(cTabela)
*********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta tela consulta para usuario pesquisar codigo do fornecedor |
//| quando fornecedor == exteriror									|
//³ Chamada -> Grava_Xml()     										|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nCBox 	
Local lOk		  := .F.
Private aArea_1   := GetArea()
Private cPesquisa := Space(100)
Private cRetorno  :=	''
Private cArqTmp

	
SetPrvt("oDlgSA2","oCBox","oGet1","oBrw1","oSBtn1","oSBtn2")

	
oDlgSA2	:= MSDialog():New( D(113),D(321),D(486),D(897),"Consulta "+IIF(cTabela=='SA2',"Fornecedor","Cliente"),,,.F.,,,,,,.T.,,,.T. )
oCBox	:= TComboBox():New( D(004),D(004),{|u| If(PCount()>0,nCBox:=u,nCBox)},{"CÓDIGO+LOJA","NOME","NOME FANTASIA"},D(240),D(010),oDlgSA2,,{|| DbSelectArea("TMPSA2"),DbSetOrder(oCBox:nAT), DbGoTop(), oDlgSA2:Refresh(),  },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCBox )
oGet1	:= TGet():New( D(016),D(004),{|u| If(PCount()>0,cPesquisa:=u,cPesquisa)},oDlgSA2,D(240),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,{||  TMPSA2->(DbSeek(cPesquisa, .T.)), cRetorno := TMPSA2->CODIGO + TMPSA2->LOJA,oBrw1:oBrowse:Refresh() },.F.,.F.,"","",,)
oBtn1   := TButton():New( D(004),D(247),"&Pesquisar",oDlgSA2,{|| TMPSA2->(DbSetOrder(oCBox:nAT), DbSeek(cPesquisa, .T.)), cRetorno := TMPSA2->CODIGO + TMPSA2->LOJA, oBrw1:oBrowse:Refresh() },D(040),D(011),,,,.T.,,"",,,,.F. )

MsgRun("Consulta Fornecedor...",,{|| oTblSA2(cTabela) } )

DbSelectArea("TMPSA2") 
oBrw1	:= MsSelect():New( "TMPSA2","","",  {{"CODIGO","","Código",""},{"LOJA","","Loja",""},{"NOME","","Nome",""}, {"NFANT","","Nome Fantasia",""}},.F.,,{D(028),D(004),D(164),D(280)},,, oDlgSA2 ) 

oSBtn1	:= SButton():New( D(168),D(004),01,{|| cRetorno := TMPSA2->CODIGO + TMPSA2->LOJA , oDlgSA2:End() },oDlgSA2,,"", )
oSBtn3	:= SButton():New( D(168),D(040),15,{|| MostraRegSA2(cTabela) },oDlgSA2,,"", )

oDlgSA2:Activate(,,,.T., {|| .T.} )

IIF(Select("TMPSA2") != 0, TMPSA2->(DbCLoseArea()), )
FErase(cArqTmp)

RestArea(aArea_1)       

Return(cRetorno)
************************************************************
Static Function oTblSA2(cTabela)
************************************************************
Local aFds := {}
Local cTmp


If Select("TMPSA2") != 0
   DbSelectArea("TMPSA2")
   RecLock('TMPSA2', .F.)
       Zap
   MsUnLock()
   DbGoTop()

Else

	Aadd( aFds , {"CODIGO",	"C",006,000} )
	Aadd( aFds , {"LOJA",	"C",002,000} )
	Aadd( aFds , {"NOME",	"C",060,000} )
	Aadd( aFds , {"NFANT",	"C",035,000} )
	Aadd( aFds , {"MUN",	"C",025,000} )
	Aadd( aFds , {"EST",	"C",002,000} )
	Aadd( aFds , {"PAIS",	"C",003,000} )
	Aadd( aFds , {"CNPJ",	"C",014,000} )
	Aadd( aFds , {"_RECNO",	"N",010,000} )
	Aadd( aFds , {"TMPREC",	"N",010,000} )
	
	cArqTmp := CriaTrab( aFds, .T. )
	Use (cArqTmp) Alias TMPSA2 New Exclusive
	Index On CODIGO+LOJA	TAG 1 To &cArqTmp
	Index On NOME       	TAG 2 To &cArqTmp
	Index On NFANT 			TAG 3 To &cArqTmp
	Index On TMPREC			TAG 4 To &cArqTmp
EndIf


DbSelectArea("TMPSA2");DbSetOrder(1)

If cTabela == 'SA2'
	DbSelectArea('SA2');DbGoTop()        
	nCount := 0
	Do While !Eof()
		If SA2->A2_EST == 'EX'     
			nCount++
			RecLock("TMPSA2",.T.) 
		     	TMPSA2->CODIGO	:=	SA2->A2_COD
				TMPSA2->LOJA	:=	SA2->A2_LOJA	
				TMPSA2->NOME	:=	SA2->A2_NOME
				TMPSA2->NFANT	:=	IIF(SA2->(FieldPos("A2_NFANT"))>0, SA2->A2_NFANT, '' )
				TMPSA2->MUN		:=	SA2->A2_MUN
				TMPSA2->EST		:=	SA2->A2_EST
				TMPSA2->PAIS	:=	SA2->A2_PAIS
				TMPSA2->CNPJ	:=	SA2->A2_CGC
				TMPSA2->_RECNO	:=	SA2->(Recno())
				TMPSA2->TMPREC  :=	nCount
			MsUnLock()      	
		EndIf
		DbSelectArea('SA2') 
		DbSkip()
	EndDo
	
ElseIf cTabela == 'SA1'
	DbSelectArea('SA1');DbGoTop()
	Do While !Eof()
		If SA1->A1_EST == 'EX'
			RecLock("TMPSA2",.T.) 
		     	TMPSA2->CODIGO	:=	SA1->A1_COD
				TMPSA2->LOJA	:=	SA1->A1_LOJA	
				TMPSA2->NOME	:=	SA1->A1_NOME
				TMPSA2->NFANT	:=	SA1->A1_NFANT
				TMPSA2->MUN		:=	SA1->A1_MUN
				TMPSA2->EST		:=	SA1->A1_EST
				TMPSA2->PAIS	:=	SA1->A1_PAIS
				TMPSA2->CNPJ	:=	SA1->A1_CGC
				TMPSA2->_RECNO	:=	SA1->(Recno())
			MsUnLock()      	
		EndIf
		DbSelectArea('SA1') 
		DbSkip()
	EndDo

EndIf

DbSelectArea('TMPSA2');DbGoTop()

Return
************************************************************
Static Function MostraRegSA2()
************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Bota de visualizar cadastro do Fornecedor \ Cliente             |
//| na consulta para usuario pesquisar codigo do fornecedor 		|
//³ Chamada -> SA2_SA1ConsPad()     								|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCadastro	:=	IIF(cTabela=='SA2','Fornecedor','Cliente') 
cAlias		:=	IIF(cTabela=='SA2','SA2','SA1')
nReg		:=	TMPSA2->_RECNO
nOpc		:=	2
aArea_2  	:= GetArea()


DbselectArea(cAlias);DbGoTo(nReg)
AxVisual( cAlias, nReg, nOpc,,,,,)

RestArea(aArea_2)
Return()
*****************************************************************
Static Function MensStatus()
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra Retorno da Importacao    ³
//³ Chamada -> RecebeEmail()        ³
//|                LoadFiles()      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local 	cMsgXML  := cMsg_I := cMsg_D := cMsg_F := cMsg_C := cMsg_E := ''
Local	lRet		:=	.T.
Private	aStatusI 	:=	{}
Private	aStatusJ 	:=	{}
Private	aStatusD 	:= 	{}
Private	aStatusF 	:= 	{}
Private	aStatusC 	:= 	{}
Private	aStatusE 	:= 	{}
Private	aStatusX 	:= 	{}
Private	aStatusT 	:= 	{}
Private	aTmpStatus	:=	{}
Private	cMsgStatus	:=	''
Private	nQtdStatus	:=	0
Private lContinua 	:=	.T.

SetPrvt("oDlgS","oGrp","oSayOK","oSayNO",'oSayQtd','oBrw1','oSayXml','oBtn2','oSayImp')


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	SEPARA O ARRAY aStatus CONFORME TIPO  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSort(aStatus,,, { |x,y| x[1] > y[1] })
For nX := 1 To Len(aStatus)

   If aStatus[nX][1] ==     'I'  
       // Aadd(aStatus, {cStatus, cArqXML, cNomeEmpFil, cNomeFilial, cDiretorioXML, cDestCnpj, cNomeFilial })
       Aadd(aStatusI,    {aStatus[nX][2],aStatus[nX][3]+' \ '+aStatus[nX][4], aStatus[nX][1], aStatus[nX][4], aStatus[nX][6], aStatus[nX][7] }) 
   ElseIf aStatus[nX][1] ==     'J'  
       Aadd(aStatusJ,    {aStatus[nX][2],aStatus[nX][3]+' \ '+aStatus[nX][4], aStatus[nX][1], aStatus[nX][4], aStatus[nX][6], aStatus[nX][7] }) 
   ElseIf aStatus[nX][1]     ==    'D'
       Aadd(aStatusD,    {aStatus[nX][2],aStatus[nX][3], aStatus[nX][1], aStatus[nX][4] })
   ElseIf aStatus[nX][1]     ==    'F'
       Aadd(aStatusF,    {aStatus[nX][2],aStatus[nX][3], aStatus[nX][1], aStatus[nX][4] })
   ElseIf aStatus[nX][1]     ==    'C'
       Aadd(aStatusC,    {aStatus[nX][2],aStatus[nX][3], aStatus[nX][1], aStatus[nX][4] })
   ElseIf aStatus[nX][1]     ==    'E'
       Aadd(aStatusE,    {aStatus[nX][2],aStatus[nX][3], aStatus[nX][1], aStatus[nX][4] })
   ElseIf aStatus[nX][1]     ==    'X'
       Aadd(aStatusX,    {aStatus[nX][2], aStatus[nX][4]+' \ '+ aStatus[nX][5], aStatus[nX][1], aStatus[nX][4] })
   ElseIf aStatus[nX][1]     ==    'T'
       Aadd(aStatusT,    {aStatus[nX][2],aStatus[nX][3], aStatus[nX][1], aStatus[nX][4] })
   EndIf

Next


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	  BROSWER COM STATUS DA IMPORTACAO    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFontG     := TFont():New( "Arial",0,IIF(nHRes<=800,-16, -18),,.T.,0,,700,.F.,.F.,,,,,, )
oFontP     := TFont():New( "Arial",0,IIF(nHRes<=800,-09, -11),,.F.,0,,700,.F.,.F.,,,,,, )

oDlgS      := MSDialog():New( D(095),D(232),D(427),D(740),"STATUS ARQUIVOS IMPORTADOS...",,,.F.,,,,,,.T.,,,.T. )
oGrp       := TGroup():New( D(004),D(004),D(146),D(250),"",oDlgS,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayOK     := TSay():New( D(010),D(000),{|| cMsgStatus },oGrp,,oFontG,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(240),D(010))
oSayNO     := TSay():New( D(010),D(000),{|| cMsgStatus },oGrp,,oFontG,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,D(240), D(010))
oSayOK:Hide()
oSayNO:Hide()

oSayQtd    := TSay():New( D(022),D(010),{|| Alltrim(Str(nQtdStatus))+ ' arquivo(s) ' },oGrp,,oFontP,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(010) )

oSayImp    := TSay():New( D(022),D(055),{|| ' Arquivo(s) não importado ' },oGrp,,oFontP,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,D(080),D(010) )
oSayImp:Hide()

*************************
   oTblStatus()
*************************

DbSelectArea("TMPSTATUS")
oBrw1 := MsSelect():New( "TMPSTATUS","","",{{"ARQUIVO","","Arquivo",""},{"CONTEUDO","","Observação",""}},.F.,,{ D(030),D(008),D(140),D(245) },,, oGrp )

*************************
   MostraStatus()
*************************
oSayOK:Refresh()
oSayNO:Refresh()

If cTpCarga != 'EMAIL'
   	oSayXml	:=	TSay():New( D(146),D(008),{|| ' Duplo Click para visualizar XML' },oGrp,,oFontP,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(080),D(010) )
	oBrw1:oBrowse:bLDblClick := {|| IIF(cTpCarga!='EMAIL', MsgRun("Aguarde... Abrindo XML...",,{|| ShellExecute("open",IIF(!(TMPSTATUS->_STATUS$'I/G'),cDiretorioXML+AllTrim(TMPSTATUS->ARQUIVO),AllTrim(TMPSTATUS->CAMINHO)),"","",1)}), )}
EndIf

oBtn2    := TButton():New( D(152),D(097),"&Ok",oDlgS, {|| MostraStatus() },D(037),D(012),,,,.T.,,"",,,,.F. )

oDlgS:Activate(,,,.T.,,,)


IIF(Select("TMPSTATUS") != 0, TMPSTATUS->(DbCLoseArea()), )
aStatus    :=    {}

Return()
*****************************************************************
Static Function oTblStatus()
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arq. Temp                  ³
//³ Chamada -> MensStatus()         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aFds := {}
Local cTmp

If Select("TMPSTATUS") == 0

   Aadd( aFds , {"_STATUS" ,"C",001,000} )
   Aadd( aFds , {"ARQUIVO" ,"C",080,000} )
   Aadd( aFds , {"CONTEUDO","C",200,000} )
   Aadd( aFds , {"CAMINHO" ,"C",300,000} )
   
   cTmp := CriaTrab( aFds, .T. )
   Use (cTmp) Alias TMPSTATUS New Exclusive
   Aadd(aArqTemp, cTmp)

Else
   DbSelectArea("TMPSTATUS")
   RecLock('TMPSTATUS', .F.)
       Zap
   MsUnLock()

   DbGoTop()
EndIf

Return()
*****************************************************************
Static Function MostraStatus()
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALIMENTA TABELA TEMPORARIA E ATUALIZA VARIAVEIS	|
//| SEPARA OS TIPOS E ALIMENTA aTmpStatus			|
//³ Chamada -> MensStatus()         				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aTmpStatus := {}

If Len(aStatusI) > 0
   cMsgStatus	:=	PadR(Space(20)+'XML IMPORTADO COM SUCESSO ',080,'')
   aTmpStatus   := 	aClone(aStatusI)
   aStatusI    	:= 	{}
   oSayOK:Show()
   oSayNO:Hide()
   oSayImp:Hide()

ElseIf Len(aStatusJ) > 0
   cNomeFil := aStatusJ[1][6]
   cMsgStatus	:=	PadR(Space(10)+'XML IMPORTADO COM SUCESSO - FILIAL '+cNomeFil,100,'')
   aTmpStatus   := 	aClone(aStatusJ)
   aStatusJ    	:= 	{}
   oSayOK:Show()
   oSayNO:Hide()
   oSayImp:Hide()
ElseIf Len(aStatusD) > 0
   cMsgStatus   :=	PadC('ARQUIVO JÁ IMPORTADO',080,'')
   aTmpStatus   := 	aClone(aStatusD)
   aStatusD    	:= 	{}
   oSayOK:Hide()
   oSayNO:Show()
   oSayImp:Show()
ElseIf Len(aStatusF) > 0
   cMsgStatus	:=	PadC('CNPJ DO EMITENTE NÃO ENCONTRADO',080,'')
   aTmpStatus   := 	aClone(aStatusF)
   aStatusF    	:=	{}
   oSayOK:Hide()
   oSayNO:Show()
   oSayImp:Show()
ElseIf Len(aStatusC) > 0
   cMsgStatus	:=	PadC('CNPJ DO DESTINATÁRIO NÃO ENCONTRADO',080,'')
   aTmpStatus	:=	aClone(aStatusC)
   aStatusC    	:=	{}
   oSayOK:Hide()
   oSayNO:Show()
   oSayImp:Show()
ElseIf Len(aStatusE) > 0  
   cMsgStatus	:=	PadC('XML COM FORMATAÇÃO INCORRETA',080,'')
   aTmpStatus	:=	aClone(aStatusE)
   aStatusE    	:=	{}
   oSayOK:Hide()
   oSayNO:Show()
   oSayImp:Show()
ElseIf Len(aStatusX) > 0 
   cMsgStatus	:=	PadC('PROBLEMA COM ESTRUTURA DA TABELA',080,'')
   aTmpStatus	:=	aClone(aStatusX)
   aStatusX    	:=	{}
   oSayOK:Hide()
   oSayNO:Show()
   oSayImp:Show()
ElseIf Len(aStatusT) > 0 
   cMsgStatus	:=	PadC('XML SEM TAG PROTOCOLO DE AUTORIZAÇÃO',080,'')
   aTmpStatus	:=	aClone(aStatusT)
   aStatusT    	:=	{}
   oSayOK:Hide()
   oSayNO:Show()
   oSayImp:Show() 
EndIf


lContinua := IIF( Len(aTmpStatus) > 0, .T., .F.)


If lContinua

   ********************
   oTblStatus()
   ********************

   For nX:=1 To Len(aTmpStatus)
       DbSelectArea("TMPSTATUS")
       RecLock('TMPSTATUS', .T.)
           TMPSTATUS->ARQUIVO     :=    aTmpStatus[nX][1]
           TMPSTATUS->CONTEUDO    :=    aTmpStatus[nX][2]
           TMPSTATUS->_STATUS     :=    aTmpStatus[nX][3]
           TMPSTATUS->CAMINHO     :=    aTmpStatus[nX][4]
       MsUnLock()
   Next

   TMPSTATUS->(DbGoTop())
Else
   oDlgS:End()
EndIf

nQtdStatus := Len(aTmpStatus)

Return()
*****************************************************************
Static Function Renomea_XML(nPos)
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Renomea Arq.XML -Importado      ³
//³ Chamada -> MensStatus()         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local lCopia := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICO SE DIRETORIO EXISTE    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File(cDiretorioXML+'XML_IMPORTADO') 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ NAO EXISTINDO VERIFICO SE NO CAMINHO INFORMADO CONTEM A PALAVRA \XML_IMPORTADO ³
	//³ PARA QUE NAO SEJA NECESARIO CRIAR UMA PASTA \XML_IMPORTADO DENTRO DA MESMA.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPosXML := RAT('\XML_IMPORTADO', Upper(cDiretorioXML) )
	If nPosXML == 0
		If MakeDir(cDiretorioXML+'XML_IMPORTADO') != 0
			MsgAlert('É necessario criar a pasta '+cDiretorioXML+'XML_IMPORTADO'+' para separar os arquivos já importados.') 
		EndIf
	Else
		lCopia := .F.
	EndIf
EndIf


nTam       	:=	Len(aStatus[nPos][2])-4
cArquivo 	:=	SubStr(aStatus[nPos][2],1, nTam )
cExtensao	:= 	Right(AllTrim(aStatus[nPos][2]), 4)  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   RENOMEA ARQUIVO    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FRename( cDiretorioXML+aStatus[nPos][2], cDiretorioXML+cArquivo+'_IMPORTADO'+cExtensao)


If lCopia

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ COPIA PARA DIRETORIO \_IMPORTARDO	|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_CopyFile(cDiretorioXML+cArquivo+'_IMPORTADO'+cExtensao, cDiretorioXML+'XML_IMPORTADO\'+cArquivo+'_IMPORTADO'+cExtensao )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| APAGA ARQUIVO DA PASTA ORIGINAL		|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FErase(cDiretorioXML+cArquivo+'_IMPORTADO'+cExtensao)

EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALTERANDO O CAMINHO ANTIGO, COLOCANDO O NOVO CAMINHO, PARA QUE SEJA POSSIVEL ABRIR O XML COM 2 CLICK³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStatus[nPos][4] := cDiretorioXML+'XML_IMPORTADO\'+cArquivo+'_IMPORTADO'+cExtensao

Return()
*****************************************************************
User Function ConsNFeSefaz()    //    [5.0]
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Consulta Status XML - SEFAZ     ³
//³ Chamada -> Rotina Status XML    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea5	:= GetArea()
Local aRetorno	:= {}
Local cRet		:= ''

DbSelectArea('ZXM')

MsgRun("Aguarde... Consultando XML na SEFAZ...",,{|| aRetorno := ExecBlock("ConsWebNfe",.F.,.F.,{ZXM->ZXM_CHAVE, cEmpAnt, DtoS(ZXM->ZXM_DTXML) }) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	GRAVA RETORNO DO STATUS DO XML  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	Reclock('ZXM',.F.)
		ZXM->ZXM_SITUAC	:=	IIF(Empty(aRetorno[1]),'',IIF(aRetorno[1]=='100','A',IIF(aRetorno[1]=='101','C','E')))
	   	ZXM->ZXM_CODRET	:=	aRetorno[1]
	   	ZXM->ZXM_DTXML	:=	aRetorno[2]
		cRet			:=	aRetorno[1]
	MsUnlock()
EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	  FUNCAO MOSTRA MENSAGEM DO CODIGO DE RETORNO DA SEFAZ      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	********************************************************
		IIF(!Empty(ZXM->ZXM_CODRET), ExecBlock("ErroNFe",.F.,.F.,{''}), MsgInfo('Código de Retorno do XML esta em branco.') )
	********************************************************


RestArea(aArea5)
Return(cRet)
*****************************************************************
User Function SiteSefaz()    //    [6.0]
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre Portal da Nota Fiscal Eletronica ³
//³ Chamada -> Rotina Site Sefaz          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea('ZXM')
ShellExecute("open",AllTrim(GetMv('XML_SEFAZ'))+AllTrim(ZXM->ZXM_CHAVE),"","",1)

Return()
*********************************************************************
User Function ErroNFe()    //    [7.0]
*********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno mensagem do status do XML     				³
//|	\SYSTEM\ZXM_ERROS_NFE.TXT contem os erros de retorno|
//³ Chamada -> Rotina Msg.Erro            				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cErroXML	:= AllTrim(ZXM->ZXM_CODRET)
Local cLinha    :=	''
Local cLnErro  	:=	''
Local cMsgErro	:=	''

If Empty(cErroXML)
	Alert('Cod.Ret. XML esta em branco.  Verifique o Status do XML.'+ENTER+'Opção: Consulta Sefaz-> Status XML') 
ElseIf File(_StartPath+cArqErro)

   FT_FUSE(_StartPath+cArqErro)
   FT_FGOTOP()
   Do While !FT_FEOF()
       cLinha	:= 	FT_FREADLN()
       cLnErro	:=	SubStr(cLinha,1 ,AT(';', cLinha)-1)
       cMsgErro	:= 	SubStr(cLinha, AT(';',cLinha)+1, Len(AllTrim(cLinha)) )
       If cLnErro == cErroXML
           Exit
       EndIf
       FT_FSKIP()
   EndDo
   FT_FUSE()

   MsgInfo(cMsgErro)

Else
   Alert('Arquivo de Erros não encontrado no caminho: '+_StartPath+cArqErro )
EndIf


Return()
*****************************************************************
User Function Exporta_XML()    //    [8.0]
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta XML para Arquivo              ³
//³ Chamada -> Rotina Exportar            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cExpDiretorio:= Space(200)
Private cFor_Ini    :=	Space(TamSX3('A2_COD' )[1])
Private cFor_fin    :=	Space(TamSX3('A2_COD' )[1])
Private cForLj_in   :=	Space(TamSX3('A2_LOJA')[1])
Private cForLj_fin	:=	Space(TamSX3('A2_LOJA')[1])
Private cNF_Ini    	:=	Space(TamSX3('F2_DOC' )[1])
Private cNF_fin    	:=	Space(TamSX3('F2_DOC' )[1])
Private cSerie_Ini	:=	Space(TamSX3('F2_SERIE')[1])
Private cSerie_fin	:=	Space(TamSX3('F2_SERIE')[1])
Private dData1		:=	CtoD(" ")
Private dData2 		:=	CtoD(" ")

SetPrvt("oFont1","oDlg2","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oGetNF_Ini")
SetPrvt("oGetDir","oBtn1","oGetDt1","oGetDt2","oGetFor_ini","oGet2","oBtnOk","oBtnCanc","oForLj_in","oForLj_fin")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³       BROSWER COM PARAMETROS          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFont1     := TFont():New( "Arial",0,IIF(nHRes<=800,-09, -11),,.F.,0,,400,.F.,.F.,,,,,, )
oDlg2      := MSDialog():New( D(151),D(347),D(496),D(791),"Exporta XML",,,.F.,,,,,,.T.,,oFont1,.T. )
oGrp1      := TGroup():New( D(000),D(001),D(144),D(220),"",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( D(028),D(005),{||"Nota Fiscal Inicial"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(052),D(008) )
oGetNF_Ini := TGet():New( D(024),D(065),{|u| If(PCount()>0,cNF_Ini:=u,cNF_Iöni)},oGrp1,D(060),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNF_Ini",,)
oSay10     := TSay():New( D(024),D(130),{||"Série"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(052),D(008) )
oGetSer_Ini:= TGet():New( D(024),D(144),{|u| If(PCount()>0,cSerie_Ini:=u,cSerie_Ini)},oGrp1,D(020),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSerie_Ini",,)

oSay2      := TSay():New( D(044),D(005),{||"Nota Fiscal Final"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(048),D(008) )
oGetNF_fin := TGet():New( D(040),D(065),{|u| If(PCount()>0,cNF_fin:=u,cNF_fin)},oGrp1,D(060),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNF_fin",,)
oSay11     := TSay():New( D(044),D(130),{||"Série"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(052),D(008) )
oGetSer_fin:= TGet():New( D(040),D(144),{|u| If(PCount()>0,cSerie_fin:=u,cSerie_fin)},oGrp1,D(020),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSerie_fin",,)

oSay3      := TSay():New( D(060),D(005),{||"Diretório de Destino"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(052),D(008) )
oBtn1      := TButton():New( D(055),D(169),"Procurar",oGrp1,{|| cExpDiretorio  := cGetFile("Anexos (*)|*|","Arquivos (*)",0,'',.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY) },D(030),D(012),,,,.T.,,"",,,,.F. )
oGetDir    := TGet():New( D(056),D(065),{|u| If(PCount()>0,cExpDiretorio:=u,cExpDiretorio)},oGrp1,D(100),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetDir",,)

oSay4      := TSay():New( D(076),D(005),{||"Data Imp. Inicio"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(032),D(008) )
oGetDt1    := TGet():New( D(072),D(065),{|u| If(PCount()>0,dData1:=u,dData1)},oGrp1,D(060),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dGetData",,)
oSay5      := TSay():New( D(092),D(005),{||"Data Imp. Final"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(032),D(008) )
oGetDt2    := TGet():New( D(088),D(065),{|u| If(PCount()>0,dData2:=u,dData2)},oGrp1,D(060),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dData2",,)

oSay6      := TSay():New( D(108),D(005),{||"Fornecedor Inicial"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(052),D(008) )
oGetFor_in := TGet():New( D(108),D(065),{|u| If(PCount()>0,cFor_Ini:=u,cFor_Ini)},oGrp1,D(060),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","cFor_Ini",,)
oSay8      := TSay():New( D(108),D(130),{||"Loja"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(052),D(008) )
oForLj_in  := TGet():New( D(108),D(144),{|u| If(PCount()>0,cForLj_in:=u,cForLj_in)},oGrp1,D(020),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","cForLj_Ini",,)

oSay7      := TSay():New( D(124),D(005),{||"Fornecedor Final"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(048),D(008) )
oGetFor_fi := TGet():New( D(121),D(065),{|u| If(PCount()>0,cFor_fin:=u,cFor_fin)},oGrp1,D(060),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","cForLj_fin",,)
oSay9      := TSay():New( D(124),D(130),{||"Loja"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(052),D(008))
oForLj_fin := TGet():New( D(121),D(144),{|u| If(PCount()>0,cForLj_fin:=u,cForLj_fin)},oGrp1,D(020),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","cForLj_fin",,)


oBtnOk     := TButton():New( D(152),D(160),"Ok",oDlg2,{|| Processa( {|| ExpXML(),'Exportando arquivos...','Processando...',.F. }),oDlg2:End() },D(024),D(012),,oFont1,,.T.,,"",,,,.F. )
oBtnCanc   := TButton():New( D(152),D(188),"Cancela",oDlg2,{|| oDlg2:End() },D(028),D(012),,oFont1,,.T.,,"",,,,.F. )

oDlg2:Activate(,,,.T.)

Return()
*****************************************************************
Static Function ExpXML()
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta XML para Arquivo              ³
//| Seleciona os XML para exportar		  |
//³ Chamada -> Rotina Exportar            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nCount :=    0


If Empty(cExpDiretorio )
   Alert('Informe o diretório de Destino !!!')
Else
   DbSelectArea('ZXM');DbGoTop()
   Do While !Eof()
           If ZXM->ZXM_DOC >= cNF_Ini      .And. ZXM->ZXM_DOC <= cNF_Fin     .And.;
              ZXM->ZXM_SERIE >= cSerie_Ini    .And. ZXM->ZXM_SERIE <= cSerie_fin


           If !Empty(cFor_Ini)    .Or. !Empty(cFor_Fin)
               If !(ZXM->ZXM_FORNEC >= cFor_Ini  .And. ZXM->ZXM_FORNEC <= cFor_Fin)
                   DbSkip();Loop
               EndIf
           EndIf

           If !Empty(cForLj_In)    .Or. !Empty(cForLj_Fin)
               If !(ZXM->ZXM_LOJA >= cForLj_in     .And. ZXM->ZXM_LOJA <= cForLj_in)
                   DbSkip();Loop
               EndIf
           EndIf

           If !Empty(dData1)    .Or. !Empty(dData2)
               If !( ZXM->ZXM_DTIMP >= dData1    .And. ZXM->ZXM_DTIMP <= dData2 )
                   DbSkip();Loop
               EndIf
           EndIf

           cNomeXML :=    AllTrim(ZXM->ZXM_FORNEC)+'_'+AllTrim(ZXM->ZXM_LOJA)+'_'+AllTrim(ZXM->ZXM_DOC)+'_'+AllTrim(ZXM->ZXM_SERIE)

           cXML	:=	AllTrim(ZXM->ZXM_XML)
           cXML	+=	ExecBlock("VerificaZXN",.F.,.F., {ZXM->ZXM_FILIAL, ZXM->ZXM_CHAVE})	//	VERIFICA SE O XML ESTA NA TABELA ZXN

           MemoWrit( AllTrim(cExpDiretorio)+AllTrim(cNomeXML)+'.XML', cXML )

           _nCount++

       EndIf
       DbSkip()
   EndDo


EndIf

IIF(_nCount==0,Alert('Nenhum XML foi exportado !!!'), MsgInfo('XML exportado com sucesso!!!'))

DbSelectArea('ZXM');DbGoTop()

Return()
*****************************************************************
User Function Recusar_XML()    //    [9.0]
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recusa XML \ Envia E-mail para Fornecedor   |
//³ Chamada ->  Rotina Recusar                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cFornec	:=	Alltrim( Posicione('SA2',3,xFilial('SA2')+ ZXM->ZXM_CGC, 'A2_NOME') )
Local cChaveNFe	:=	AllTrim(ZXM->ZXM_CHAVE)

If ZXM->ZXM_STATUS=="R" 
	Alert('XML já recusado !!!') 
EndIF

If MsgBox("Deseja recusar o recebimento da NOTA FISCAL: "+AllTrim(ZXM->ZXM_DOC)+"   Série: "+AllTrim(ZXM->ZXM_SERIE)+ENTER+;
            "Fornecedor: "+ZXM->ZXM_FORNEC+"-"+ZXM->ZXM_LOJA+" - "+AllTrim(cFornec)+"  ?","Atenção...","YESNO")



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE DOC.ENTRADA FOI INCLUSO   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	DbSelectArea('SF1');DbSetOrder(1);DbGoTop()
	If ZXM->ZXM_FORMUL != 'S'
		cChaveSF1 := xFilial('SF1') + ZXM->ZXM_DOC + ZXM->ZXM_SERIE + ZXM->ZXM_FORNEC + ZXM->ZXM_LOJA + 'N' 
	Else
		cChaveSF1 := xFilial('SF1') + ZXM->ZXM_DOCREF + ZXM->ZXM_SERREF + ZXM->ZXM_FORNEC + ZXM->ZXM_LOJA + ZXM->ZXM_FORMUL
	EndIf
	
  	If !DbSeek( cChaveSF1, .F.)


       If MsgBox("Deseja enviar um email para o fornecedor para ficar documentado esta recusa?","Atenção...","YESNO")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ BROWSER PARA USER INFORMAR O MOTIVO DA RECUSA DO XML	|
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           *************************
               MsgRecusarXML()
           *************************

       Endif


       DbSelectArea('ZXM');DbSetOrder(6);DbGoTop()
       If DbSeek( cChaveNFe, .F.)
           Reclock('ZXM',.F.)
              	ZXM->ZXM_STATUS := 'R'    // RECUSADO RECEBIMENTO
           	  MsUnlock()
       EndIf

       	MsgInfo('NOTA FISCAL: '+AllTrim(ZXM->ZXM_DOC)+' SÉRIE: '+AllTrim(ZXM->ZXM_SERIE)+' RECUSADA COM SUCESSO!!!')

   	Else
		MsgAlert('XML não pode ser recusado!!!'+ENTER+'Primeiro exclua o Doc.Entrada vinculado a esse XML.'+ENTER+'Documento:'+SF1->F1_DOC+' - '+SF1->F1_SERIE)
   	EndIf
   	
Endif

Return()
*****************************************************************
Static Function MsgRecusarXML()
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia E-mail para Fornecedor                |
//³ Chamada ->  Recusar_XML                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("oFont1","oDlg1","oGrp","oSay1","oSay2","oGet1","oMGet1","oBtn2")

cSubject   :=    'Nota Fiscal: '+ZXM->ZXM_DOC+' Serie: '+ZXM->ZXM_SERIE+' recebimento recusado'
cHtml      :=    ''
cMsgUser   :=    ''
cForEmail  :=    AllTrim(Posicione('SA2',3,xFilial('SA2')+ZXM->ZXM_CGC,'A2_EMAIL'))+Space(200)

oFont1     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-09, -11),,.T.,0,,700,.F.,.F.,,,,,, )
oDlgRec    := MSDialog():New( D(095),D(232),D(462),D(829),"Carregar arquivo XML",,,.F.,,,,,,.T.,,oFont1,.T. )
oGrp       := TGroup():New( D(004),D(004),D(156),D(284),"",oDlgRec,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( D(012),D(008),{||"Email Forncedor (Para adicionar mais e-mails separar por;) "},oGrp,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(208),D(008))
oGet1      := TGet():New( D(020),D(008),{|u| If(PCount()>0,cForEmail:=u,cForEmail)},oGrp,D(272),D(008),'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSay2      := TSay():New( D(036),D(008),{||"Adicionar informações:"},oGrp,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008))
oMGet1     := TMultiGet():New( D(044),D(008),{|u| If(PCount()>0,cMsgUser:=u,cMsgUser)},oGrp,D(272),D(108),oFont1,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oBtn2      := TButton():New( D(160),D(120),"Ok",oDlgRec,{|| oDlgRec:End() },D(037),D(012),,,,.T.,,"",,,,.F. )

oDlgRec:Activate(,,,.T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 			CORPO DO E-MAIL                 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cHtml += '<html>'
cHtml += '<head>'
cHtml += '<h3 align = Left><font size="3" color="#FF0000" face="Arial">Recusado Recebimento Nota Fiscal: '+AllTrim(ZXM->ZXM_DOC)+' Série: '+AllTrim(ZXM->ZXM_SERIE)+'</h3></font>'
cHtml += '</head>'

cHtml += '<body bgcolor = white text=black>'
cHtml += '<hr width=100% noshade>'
cHtml += '<br></br>'

cNomeFil    :=	AllTrim( Posicione('SM0', 1, cEmpAnt + cFilAnt,  'M0_FILIAL' ))
cCcgFil		:=	AllTrim( Posicione('SM0', 1, cEmpAnt + cFilAnt,  'M0_CGC'    ))
cEmpNome    :=	AllTrim( Posicione('SM0', 1, cEmpAnt + cFilAnt,  'M0_NOMECOM'))

cHtml += '<b><font size="3" face="Arial"> '+cEmpNome+'  -  '+ TransForm(cCcgFil,"@R 99.999.999/9999-99")+'</font></b>'
cHtml += '<br></br>'

cHtml += '<b><font size="3" face="Arial">Recusado  em: </font></b>'+'<b><font size="3" face="Arial"> '+Dtoc(Date())+' às '+Time()+'</font></b>'
cHtml += '<br></br>'

cMsgPadrao :=    'Recusado Recebimento Nota Fiscal: '+AllTrim(ZXM->ZXM_DOC)+' Série: '+AllTrim(ZXM->ZXM_SERIE)
cHtml += '<br></br>'
cHtml += '<b><font size="3" face="Arial"><I>'+cMsgPadrao+'</font></b></I>'
cHtml += '<br></br>'
cHtml += '<b><font size="3" face="Arial"><I>'+cMsgUser+'</font></b></I>'
cHtml += '<br></br>'
cHtml += '<br></br>'

cHtml += '<b><font size="2" color="#9C9C9C" face="Arial"> E-mail enviado automaticamente, não responda este e-mail </font></b>'
cHtml += '</html>'


   ***********************************************************************************************
       lRetotno     := U_ENVIA_EMAIL('ImpXMLNFe', cSubject, AllTrim(cForEmail), '', '', cHtml, '', '')
   ***********************************************************************************************

If !lRetotno
   Alert('Problema no envio do email.'+ENTER+'Email não enviado!!!')
EndIf

Return()
*****************************************************************
User Function Cancelar_XML()    //    [10.0]
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cancela XML                           ³
//³ Chamada -> Rotina Cancelar            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local    cMsgCanc    :=    ''
Local    ZXMnRecno    :=    ZXM->(Recno())

DbSelectArea('ZXM')

If ZXM->ZXM_STATUS == 'X' 
	Alert('XML já cancelado !!!') 
EndIF

If MsgYesNo('Deseja realmente CANCELAR este XML???'+ENTER+ENTER+'FORNECEDOR: '+ZXM->ZXM_FORNEC+'-'+ZXM->ZXM_LOJA +ENTER+' NOTA: '+Alltrim(ZXM->ZXM_DOC)+'  Série: '+AllTrim(ZXM->ZXM_SERIE) )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE DOC.ENTRADA FOI INCLUSO   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea('SF1');DbSetOrder(1);DbGoTop()
	If ZXM->ZXM_FORMUL != 'S'
		cChaveSF1 := xFilial('SF1') + ZXM->ZXM_DOC + ZXM->ZXM_SERIE + ZXM->ZXM_FORNEC + ZXM->ZXM_LOJA + 'N' 
	Else
		cChaveSF1 := xFilial('SF1') + ZXM->ZXM_DOCREF + ZXM->ZXM_SERREF + ZXM->ZXM_FORNEC + ZXM->ZXM_LOJA + ZXM->ZXM_FORMUL
	EndIf
	
  	If !DbSeek( cChaveSF1, .F.)

		SetPrvt("oFont1","oDlgCanc","oGrp","oSay1","oSay2","oGet1","oMGet1","oBtn2")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³       Motivo Cancelamento XML         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oFont1     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-09, -11),,.T.,0,,700,.F.,.F.,,,,,, )
		oDlgCanc   := MSDialog():New( D(095),D(232),D(462),D(829),"Motivo Cancelamento XML",,,.F.,,,,,,.T.,,oFont1,.T. )
		oGrp       := TGroup():New( D(004),D(004),D(156),D(284),"",oDlgCanc,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oSay2      := TSay():New( D(012),D(008),{||"Informe o Motivo Cancelamento XML:" },oGrp,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(150),D(008) )
		oMGet1     := TMultiGet():New(D(025),D(008),{|u| If(PCount()>0,cMsgCanc:=u,cMsgCanc)},oGrp,D(272),D(118),oFont1,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
		oBtn2      := TButton():New( D(160),D(120),"Ok",oDlgCanc,{|| IIF(Len(AllTrim(cMsgCanc))<5, Alert('Informe o motivo do cancelamento.') ,oDlgCanc:End()) },D(037),D(012),,,,.T.,,"",,,,.F. )

		oDlgCanc:Activate(,,,.T.)

		DbSelectArea('ZXM')
	    Reclock("ZXM",.F.)
			ZXM->ZXM_STATUS := 'X'
			ZXM->ZXM_OBS    := cMsgCanc
		MsUnlock()

		MsgInfo('XML cancelado com sucesso !!!') 
			
	Else
           MsgAlert('Arquivo não pode ser cancelado!!!'+ENTER+'Primeiro exclua o Doc.Entrada vinculado a esse XML.'+ENTER+'Documento:'+SF1->F1_DOC+' - '+SF1->F1_SERIE)
	EndIf

EndIf


DbSelectArea('ZXM');DbGoTo(ZXMnRecno)

Return()
*****************************************************************
User Function Excluir_XML()    //    [11.0]
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exclui  XML                           ³
//³ Chamada -> Rotina Excluir_XML         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local ZXMnRecno	:=  ZXM->(Recno())
Local _cFilial 	:=	ZXM->ZXM_FILIAL
Local cChave	:=	ZXM->ZXM_CHAVE

DbSelectArea('ZXM')


If MsgYesNo('Deseja realmente EXCLUIR este XML???'+ENTER+ENTER+'FORNECEDOR: '+ZXM->ZXM_FORNEC+'-'+ZXM->ZXM_LOJA +ENTER+' NOTA: '+Alltrim(ZXM->ZXM_DOC)+'  Série: '+AllTrim(ZXM->ZXM_SERIE) )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ VERIFICA SE DOC.ENTRADA FOI INCLUSO   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea('SF1');DbSetOrder(1);DbGoTop()
		If ZXM->ZXM_FORMUL != 'S'
			cChaveSF1 := xFilial('SF1') + ZXM->ZXM_DOC + ZXM->ZXM_SERIE + ZXM->ZXM_FORNEC + ZXM->ZXM_LOJA + 'N' 
		Else
			cChaveSF1 := xFilial('SF1') + ZXM->ZXM_DOCREF + ZXM->ZXM_SERREF + ZXM->ZXM_FORNEC + ZXM->ZXM_LOJA + ZXM->ZXM_FORMUL
		EndIf
		
	  	
	  	If !DbSeek( cChaveSF1, .F.)
	                         
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ATUALIZA STATUS TABELA ZXP		³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea('ZXP'); DbSetOrder(1);DbGoTop()	//	ZXM_FILIAL+ZXM_FORNEC+ZXM_LOJA+ZXM_DOC+ZXM_SERIE
			If DbSeek( xFilial('ZXP') + ZXM->ZXM_CHAVE , .F.)
				Do While !Eof() .And. 	ZXM->ZXM_CHAVE == ZXP->ZXP_CHAVE
					DbSelectArea('ZXP')
					Reclock('ZXP',.F.)
						DbDelete()
					MsUnlock()
					DbSkip()
				EndDo
			EndIf
		

	       DbSelectArea('ZXM')
           Reclock("ZXM",.F.)
            	DbDelete()
           MsUnlock()
           
      
			ZXN->(DbSetOrder(1), DbGoTop())
			If ZXN->(DbSeek(_cFilial + cChave ,.F.))
				Do While ZXN->(!Eof()) .And. ZXN->ZXN_CHAVE == cChave
					Reclock('ZXN',.F.)
						DbDelete()
					MsUnlock()
				ZXN->(DbSkip())
				EndDo
			EndIf
			      
      
			MsgInfo('XML Excluido com sucesso !!!') 

     	Else         
     	
     	   DbSelectArea('ZXM')
     	   If ZXM->ZXM_STATUS != 'G'
	           Reclock("ZXM",.F.)
					ZXM->ZXM_STATUS := 'G'            	
        	   MsUnlock()
           EndIf
           
           MsgAlert('Arquivo não pode ser EXCLUIDO!!!'+ENTER+'Primeiro exclua o Doc.Entrada vinculado a esse XML.'+ENTER+'Documento:'+SF1->F1_DOC+' - '+SF1->F1_SERIE)
     	EndIf

EndIf


DbSelectArea('ZXM');DbGoTo(ZXMnRecno)

Return()
*****************************************************************
User Function Filtro_XML()    //    [11.00]
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcao de Filtro - apenas DBF          ³
//³ Chamada -> Rotina Filtro              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea	  := GetArea()
Local aCampos := {}

Private	bFiltraBrw	:=	{|| Nil }
Static	cFiltroRet	:=	''
Static	aIndexXml	:=	''

DbSelectArea('SX3');DbSetOrder(1);DbGoTop()
Do While !Eof() .And. SX3->X3_ARQUIVO == 'ZXM'
	aAdd( aCampos, {SX3->X3_CAMPO	, SX3->X3_PICTURE, SX3->X3_TITULO })
	DbSkip()
EndDo                      

   cFiltroRet := BuildExpr('ZXM',,'',.T.,,,,'Filtro XML',,aCampos)
   EndFilBrw('ZXM',aIndexXml)
   aIndexXml     := {}
   bFiltraBrw        := {|| FilBrowse('ZXM',@aIndexXml,@cFiltroRet) }
   Eval(bFiltraBrw)
   DbSelectArea('ZXM');DbGoTop()


RestArea(aArea)
Return(Nil)
*********************************************************************
Static Function OpcaoRetorno()
*********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DEVOLUCAO      - FUNCAO F4NFORI  PADRAO DO MICROSIGA				|
//³ BENEFICIAMENTO - FUNCAO F4Poder3 PADRAO DO MICROSIGA				|
//|																		|
//|	Chamada -> Visual_XML()->oBrwV:oBrowse:bLDblClick->VerifStatus()	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                              
// 	NOVA VERSAO NAO PREENCHE COD.FORNECEDOR E LOJA DESSA MANEIRA APRESENTA A TELA A SEGUIR.

Local  lOpRet  := .T.
Local  lBtnSair:= .F.

Private nPosCod  	:= Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_COD'	})
Private aTpNota  	:= {"Normal","Devolução","Beneficiamento","Compl. ICMS","Compl. IPI","Compl. Preço/Frete" }
Private nTpNota  	:= 1
Private aTpForm  	:= {"Sim","Não"}
Private nTpForm  	:= 2
Private cVarCliFor 	:= "Fornece:"
Private cNomeCliFor	:= ""
Private cCodCliFor 	:= Space(06)
Private cCodLoja 	:= Space(02)
Private cUFCliFor 	:= Space(02)

                    	
SetPrvt("oFont1","oDlgBD","oGrp1","oCBoxTpNF","oCBoxTpNF","oCBoxNor","oCBoxDev","oCBoxBen","oGrp2","oCBoxSim","oCBoxNao","oBtn1")


If Empty(ZXM->ZXM_TIPO)

	oFont1     := TFont():New( "Verdana",0,IIF(nHRes<=800,-09, -11),,.T.,0,,700,.F.,.F.,,,,,, )
	oDlgBD     := MSDialog():New( D(142),D(361),D(299),D(674),"Devolução\Retorno\Importação",,,.F.,,,,,,.T.,,oFont1,.T. )

	oGrp1      := TGroup():New( D(008),D(004),D(030),D(072),"Tipo Nota",oDlgBD,CLR_BLACK,CLR_WHITE,.T.,.F. ) 
	oCBoxTpNF  := TComboBox():New( D(018),D(010), {|u|if(PCount()>0,nTpNota:=u,nTpNota)},aTpNota,072,010,oDlgBD,,{|| AtualizaGet(), cCodCliFor:=Space(06), cCodLoja :=	Space(02), cNomeCliFor := "" },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,)
		
	oGrp2      := TGroup():New( D(008),D(080),D(030),D(148),"Formulário Próprio",oDlgBD,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oCBoxTpFor := TComboBox():New( D(018),D(085), {|u|if(PCount()>0,nTpForm:=u,nTpForm)},aTpForm,062,010,oDlgBD,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )	
                  
	oSayCgc    := TSay():New( D(034),D(010),{|| "CNPJ:  "+ Transform(AllTrim(ZXM->ZXM_CGC), IIF(Len(AllTrim(ZXM->ZXM_CGC))==14,'@R 99.999.999/9999-99','@R 999.999.999-99'))  },oDlgBD,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)

	oSayCliFor := TSay():New( D(046),D(010),{|| cVarCliFor  },oDlgBD,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGetSA2    := TGet():New( D(044),D(035),{|u| If(PCount()>0,cCodCliFor:=u,cCodCliFor) },oDlgBD,040,008,'', {|| AtualizaGet() }, CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","",,)
	oGetSA1    := TGet():New( D(044),D(035),{|u| If(PCount()>0,cCodCliFor:=u,cCodCliFor) },oDlgBD,040,008,'', {|| AtualizaGet() }, CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","",,)		 	
	oGetLoja   := TGet():New( D(044),D(070),{|u| If(PCount()>0,cCodLoja:=u,cCodLoja)     },oDlgBD,005,008,'', {|| AtualizaGet() }, CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)		 	

	oSayNome   := TSay():New( D(056),D(010),{|| cNomeCliFor },oDlgBD,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)			
	
	oBtnOK     := TButton():New( D(065),D(040),"OK",  oDlgBD,{|| IIF(ValidaDados(cCodCliFor),(Atu_SayDev(),oDlgBD:End()),) },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )
	oBtnNO     := TButton():New( D(065),D(080),"Sair",oDlgBD,{|| lBtnSair:=.T.,lOpRet:=.F.,oDlgBD:End() },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )

	                  
	oBtnOK:SetFocus()
		
	oDlgBD:Activate(,,,.T.,{|| IIF(!lBtnSair, (lOpRet:=ValidOpcDev(), lOpRet), .T.) },, {|| AtualizaGet(), oDlgBD:lEscClose := .F. } )

            	
EndIf 


// ATUALIZA DADOS DO FORNECEDOR \ CLIENTE
***************************                                           
	AtuClixFor()
***************************

		
Return(lOpRet)
*********************************************************************
Static Function ValidOpcDev()
*********************************************************************
Local lValid := .T.
If Empty(cCodCliFor).Or.Empty(cCodLoja)
	Alert('Preencha o Código-Loja do Fornecedor\Cliente')
	lValid := .F.
EndIf

Return(lValid)
*********************************************************************
Static Function AtualizaGet()
*********************************************************************

If oCBoxTpNF:NAT == 2 .Or. oCBoxTpNF:NAT == 3 

	cVarCliFor := "Cliente: "
	oGetSA1:Show()
	oGetSA2:Hide() 
	If !Empty(cCodCliFor) .And. !Empty(cCodLoja)
		SA1->(DbSetOrder(1),DbGoTop())
		If !SA1->(DbSeek(xFilial('SA1') + cCodCliFor + cCodLoja, .F. ))
			Alert('Código Cliente não existe!!!!') 
			cNomeCliFor := ""
			cCodLoja 	:= Space(02)
			cCodCliFor 	:= Space(06)
			cNomeCliFor := ""
			cUFCliFor 	:= ''
		Else                                    
			cNomeCliFor := AllTrim(SA1->A1_NOME)
			cCodCliFor 	:= SA1->A1_COD
			cCodLoja 	:= SA1->A1_LOJA         
			cUFCliFor	:= SA1->A1_EST
		EndIf
	EndIf
			
Else

	cVarCliFor := "Fornece: "
	oGetSA1:Hide() 
	oGetSA2:Show()
	If !Empty(cCodCliFor) .And. !Empty(cCodLoja)
		SA2->(DbSetOrder(1),DbGoTop())
		If !SA2->(DbSeek(xFilial('SA2') + cCodCliFor + cCodLoja, .F. ))
			Alert('Código Fornecedor não existe!!!!') 
			cNomeCliFor := ""
			cCodLoja 	:= Space(02)
			cCodCliFor 	:= Space(06)
			cNomeCliFor := ""
			cUFCliFor	:= ""
		Else                           
			cNomeCliFor := AllTrim(SA2->A2_NOME)
			cCodCliFor 	:= SA2->A2_COD
			cCodLoja 	:= SA2->A2_LOJA
			cUFCliFor	:= SA2->A2_EST
		EndIf
	EndIf
		
EndIf

oGetSA2:Refresh()
oGetSA1:Refresh()
oSayCliFor:Refresh()
oSayNome:Refresh()
oDlgBD:Refresh()


Return()
*********************************************************************
Static Function ValidaDados()
*********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|	Chamada -> OpcaoRetorno - Botao OK			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lReturn := .T. 

If Empty(cCodCliFor)

	Alert('Informe o código do '+IIF(oCBoxTpNF:NAT==2.Or.oCBoxTpNF:NAT==3,'Cliente','Fornecedor')+ '!!!' )
	lReturn := .F.

Else
       
	_cCnpj 	:= IIF(oCBoxTpNF:NAT==2.Or.oCBoxTpNF:NAT==3, AllTrim(SA1->A1_CGC), AllTrim(SA2->A2_CGC) )
	_cUF 	:= IIF(oCBoxTpNF:NAT==2.Or.oCBoxTpNF:NAT==3, AllTrim(SA1->A1_EST), AllTrim(SA2->A2_EST) )
	

	If AllTrim(ZXM->ZXM_CGC) != AllTrim(_cCnpj) .And. !lImportacao
	   	Alert(	'CNPJ informado ['+Transform( AllTrim(_cCnpj), IIF(Len(AllTrim(_cCnpj))==14,'@R 99.999.999/9999-99','@R 999.999.999-99'))+'] '+ENTER+;
				'DIFERENTE'+ENTER+;
				'do CNPJ do XML ['+Transform( AllTrim(ZXM->ZXM_CGC), IIF(Len(AllTrim(ZXM->ZXM_CGC))==14,'@R 99.999.999/9999-99','@R 999.999.999-99'))+']' )
		
		lReturn := .F.

	ElseIf lImportacao .And. _cUF != 'EX'
		Alert('NOTA DE IMPORTAÇÃO É OBRIGADO ESTADO = EX ') 
		lReturn := .F.
	Else

 		cTipoNota := ''
 		Do Case
 			Case oCBoxTpNF:NAT ==  1
		 		cTipoNota	:=	'N'
		 		cMsgDevRet	:=	'- Tipo Nota: Normal' 
 			Case oCBoxTpNF:NAT == 2
 				cTipoNota	:=	'D'
				cMsgDevRet	:=	'- Tipo Nota: Devolução'
 			Case oCBoxTpNF:NAT ==  3
 				cTipoNota	:=	'B'
				cMsgDevRet	:=	'- Tipo Nota: Beneficiamento'
 			Case oCBoxTpNF:NAT ==  4
 				cTipoNota	:=	'I'
				cMsgDevRet	:=	'- Tipo Nota: Compl. ICMS' 				
 			Case oCBoxTpNF:NAT == 5
 				cTipoNota	:=	'P'
				cMsgDevRet	:=	'- Tipo Nota: Compl. IPI' 				
 			Case oCBoxTpNF:NAT == 6
 				cTipoNota	:=	'C'
				cMsgDevRet	:=	'- Tipo Nota: Compl. Preço/Frete'
 		EndCase
                                                      
		cMsgDevRet += IIF(lImportacao,' - Importação','')

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³		GRAVA CLIENTE\FORNECEDOR - TIPO DE NOTA NA TABELA ZXM        	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		DbSelectArea('ZXM')
  		Reclock('ZXM',.F.)               
			ZXM->ZXM_TIPO	:=	cTipoNota
			ZXM->ZXM_FORNEC	:=	cCodCliFor  
			ZXM->ZXM_LOJA	:=	cCodLoja 
		
			If ZXM->(FieldPos("ZXM_NOMFOR")) > 0
				ZXM->ZXM_NOMFOR	:=	cNomeCliFor
            EndIf
			If ZXM->(FieldPos("ZXM_UFFOR")) > 0
				ZXM->ZXM_UFFOR	:=	cUFCliFor
            EndIf
					
		MsUnlock()
    			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³		ATUALIZA ALGUNS DADOS DO ACOLS, QDO EH CLIENTE OU FORNECEDOR	³
		//³		APENAS QDO O PRODUTO JA ESTA RELACIONADO                     	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 To Len(aMyCols)                    
   
			nPLocal		:= Ascan(oBrwV:aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"	})
			nPTES		:= Ascan(oBrwV:aHeader,{|x| AllTrim(x[2])=="D1_TES"	})
			nPosCC		:= Ascan(oBrwV:aHeader,{|X| Alltrim(X[2])=="D1_CC"		})
			nPosConta	:= Ascan(oBrwV:aHeader,{|X| Alltrim(X[2])=="D1_CONTA"	})
			nPosCod		:= Ascan(oBrwV:aHeader,{|x| AllTrim(x[2])=="D1_COD"	}) 

			If  nPosCod > 0
		  		If !Empty(aMyCols[nX][nPosCod] )
					SB1->(DbGoTop(), DbSetOrder(1))
		           	If SB1->(DbSeek(xFilial('SB1') + oBrwV:aCols[nX][nPosCod] ,.F.) )
		           		If nPLocal > 0
		           			oBrwV:aCols[nX][nPLocal] 	:= IIF(!Empty(SB1->B1_LOCPAD), AllTrim(SB1->B1_LOCPAD), Space(TamSx3('B1_LOCPAD')[1]))		//	Local Padrao 
		           		EndIf
		           		If nPTES > 0 
		           			oBrwV:aCols[nX][nPTES]   	:= IIF(!Empty(SB1->B1_TE), 	AllTrim(SB1->B1_TE),Space(TamSx3('B1_TE')[1]))			//	Codigo de Entrada padrao
		           		EndIf
		           		If nPosCC > 0
		           			oBrwV:aCols[nX][nPosCC] 	:= IIF(!Empty(SB1->B1_CONTA), 	AllTrim(SB1->B1_CONTA),Space(TamSx3('B1_CONTA')[1]))		//	Conta Contabil dn Prod.
		           		EndIf
		           		If nPosConta > 0
		           			oBrwV:aCols[nX][nPosConta] 	:= IIF(!Empty(SB1->B1_CC), 	AllTrim(SB1->B1_CC),Space(TamSx3('B1_CC')[1]))			//	Centro de Custo
						EndIf
					ElseIf SX6->(DbGoTop(), DbSeek( cFilAnt+'MV_LOCPAD' ,.F.) )
						If nPLocal > 0
							oBrwV:aCols[nX][nPLocal] 	:= IIF(!Empty(SX6->X6_CONTEUD), AllTrim(SX6->X6_CONTEUD),Space(TamSx3('B1_LOCPAD')[1]))
		            	EndIf
		            EndIf
	            
	            EndIf
			EndIf
			
     	Next
        
    
		oBrwV:oBrowse:Refresh()
	EndIf

EndIf

Return(lReturn)
*****************************************************************
Static Function Atu_SayDev()
*****************************************************************
lNFeDev := IIF(oCBoxTpNF:NAT == 2 .Or. oCBoxTpNF:NAT == 3, .T., .F.) 
	
aClixFor[01] := IIF(!lNFeDev, "Fornecedor: ", "Cliente: ") 
aClixFor[02] := IIF(!lNFeDev, SA2->A2_NOME, SA1->A1_NOME ) 
aClixFor[03] := IIF(!lNFeDev, (SA2->A2_COD +' - '+SA2->A2_LOJA), (SA1->A1_COD +' - '+SA1->A1_LOJA)) 
aClixFor[04] := Transform( IIF(!lNFeDev,SA2->A2_CGC,SA1->A1_CGC), IIF(IIF(!lNFeDev,Len(SA2->A2_CGC)==14,Len(SA1->A1_CGC)==14),'@R 99.999.999/9999-99','@R 999.999.999-99')) 
aClixFor[05] := IIF(!lNFeDev, (AllTrim(SA2->A2_END)+IIF(!Empty(SA2->A2_COMPLEM),'-'+SA2->A2_COMPLEM,'')+IIF(Empty(SA2->A2_NR_END),'',', '+SA2->A2_NR_END )), ;
														    (AllTrim(SA1->A1_END)+IIF(!Empty(SA1->A1_COMPLEM),'-'+SA1->A1_COMPLEM,'')+IIF(SA1->(FieldPos("A1_NR_END"))>0, IIF(Empty(SA1->A1_NR_END),'',', '+SA1->A1_NR_END ),'')) )  
               
aClixFor[06] := IIF(!lNFeDev,(AllTrim(SA2->A2_MUN)+' - '+SA2->A2_EST), AllTrim(SA1->A1_MUN)+' - '+SA1->A1_EST) 
aClixFor[07] := IIF(!lNFeDev, ( IIF(!Empty(SA2->A2_DDD),'('+AllTrim(SA2->A2_DDD)+') - ','')+SA2->A2_TEL),;
															( IIF(!Empty(SA1->A1_DDD),'('+AllTrim(SA1->A1_DDD)+') - ','')+SA1->A1_TEL)) 

If !lNFeDev
	oBtn6SA2:Show()
	oBtn6SA1:Hide()
	oBtn4SA2:Show()
	oBtn4SA1:Hide()

	oBtn6SA2:Refresh()
	oBtn6SA1:Refresh()
	oBtn4SA2:Refresh()
	oBtn4SA1:Refresh()
EndIf

oSay71:Refresh()
oSay10:Refresh()
oSay8:Refresh()
oSay9:Refresh()
oSay11:Refresh()
oSay12:Refresh()
oSay13:Refresh()
oSay14:Refresh()
oSay15:Refresh()
oSay16:Refresh()
oSay17:Refresh()
oSay18:Refresh()

oSayDevRet:Refresh()


oGrp1:Refresh()
oBrwV:oBrowse:Refresh()

Return()
*****************************************************************
Static Function Doc_DevRet()
*****************************************************************
lOk		  :=	.T.
nPTES     := Ascan(oBrwV:aHeader,{|x| AllTrim(x[2])=="D1_TES"		})
nPLocal   := Ascan(oBrwV:aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"	})
nPosCod	  := Ascan(oBrwV:aHeader,{|x| AllTrim(x[2])=="D1_COD"		})
nPosPFor  := Ascan(oBrwV:aHeader,{|X| Alltrim(X[2])=="C7_PRODUTO"	})
                                                                      

aHeader := 	aMyHeader
aCols	:=	aMyCols
n		:=	oBrwV:NAT
nLinha	:=	1
nRecSD2	:=	1
nRecSD1	:=	1
cRotina	:=	''
cReadVar:=	'D1_NFORI'        
cTES	:=	oBrwV:aCols[n][nPTES]
cProduto:=	oBrwV:aCols[n][nPosCod]
cLocal	:= 	oBrwV:aCols[n][nPLocal]

cPrograma := 'IMPXMLNFE'


If Empty(cProduto) .Or. Empty(cTES)
	MsgAlert('Preencha os campos: PRODUTO e TIPO DE ENTRADA') 
	Return()
EndIf

SF4->(DbSetOrder(1), DbGoTop())
SF4->(DbSeek(xFilial('SF4') +  cTES ,.F.))

cProduto	:=	PadR(cProduto, TamSx3('D1_COD')[1], '')
cLocal		:=	PadR(cLocal, TamSx3('D1_LOCAL')[1], '')
cFornece	:=	PadR(ZXM->ZXM_FORNEC, TamSx3('D1_FORNECE')[1], '')
cLoja		:=	PadR(ZXM->ZXM_LOJA, TamSx3('D1_LOJA')[1], '')
cTipoXML 	:= 	ZXM->ZXM_TIPO

//	SF4->F4_PODER3 -> R=Remessa;D=Devolucao;N=Nao Controla
If Empty(cTipoXML)
	If SF4->F4_PODER3 == "D"
 		cTipoXML := 'N'
  	EndIf
EndIf

Do Case  
  		
  	Case  Empty(cProduto) .Or. Empty(cTES)
			Help('   ',1,'A103TPNFOR')
			lOk := .F.
 	Case cTipoXML == "D" .And. SF4->F4_PODER3 <> "N"	
  			Help('   ',1,'A103TESNFD')
			lOk := .F.
  	Case cTipoXML $"NB" .And. SF4->F4_PODER3 <> "D"	
  			Help('   ',1,'A103TESNFB')
			lOk := .F.

  	Case SF4->F4_PODER3 == "N" 
		MsgRun('Verificando NF Origem... Aguarde...', 'Aguarde... ',{|| F4NFORI('', , "_NFORI", cFornece, cLoja, cProduto, 'IMPXMLNFE', cLocal, 1, 1)  })

	Case SF4->F4_PODER3 == "D"
		MsgRun('Verificando NF Origem... Aguarde...', 'Aguarde... ',{|| F4Poder3(cProduto, cLocal, cTipoXML, 'E', cFornece, cLoja, 1, '')  })
		
EndCase


    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ APOS BUSCAR OS DADOS, PELA ROTINA PADRAO DO MICROSIGA, ³
//³ ALIMENTO aMyCols COM DADOS DE RETORNO DA BUSCA         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOk
	For _nX:=1 To Len(aHeader)
		nPos :=	Ascan(aMyHeader, {|X| AllTrim(X[2]) == AllTrim(aHeader[_nX][2]) })
		If nPos > 0
			If oBrwV:aCols[n][nPos]	!= aCols[n][nPos] .And. !Empty(aCols[n][nPos])   
				oBrwV:aCols[n][nPos]	:= aCols[n][nPos]
			EndIf
		EndIf
	Next

	oBrwV:oBrowse:Refresh()
EndIf

Return()
*****************************************************************
Static Function GeraDV(xChave)
*****************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera DV para XML (Versao Old) que nao tenham Chave de Acesso   |
//|	VERSAO _INFNFE												   |
//³ Chamada -> CabecXmlParser                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aChave	:= {}
Local nSoma    	:= 0
Local nResult	:= 0
Local nMult		:= 2
Local DV

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ALIMENTA aChave POSICAO a POSICAO	|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do While !Empty(xChave)
   Aadd(aChave, Left(xChave,1) )
   xChave := Right(xChave, Len(xChave)-1,)
EndDo


For X := 0 To Len(aChave)

   nTam    :=    Len(aChave) - X
   If nTam == 0
       Exit
   EndIf

   nSoma    +=     Val(aChave[nTam]) * nMult

   If nMult == 9
       nMult := 2
   Else
        nMult++
   EndIf

Next

//Somatória das ponderações = 644
//Dividindo a somatória das ponderações por 11 teremos, 644 /11 = 58 restando 6.
//Como o dígito verificador DV = 11 - (resto da divisão), portando 11 - 6 = 5
//Quando o resto da divisão for 0 (zero) ou 1 (um), o DV deverá ser igual a 0 (zero)

nResto     :=     Mod(nSoma,11)
If nResto == 0 .Or. nResto == 1
   DV     :=    0
Else
   DV     :=  11 - nResto
EndIf

Return( AllTrim(Str(DV)) )
***********************************************************************
User Function CreateTable()
***********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria SIX, SX2, SX3 da tabela ZXM, caso nao exista              |
//³ Chamada -> Grava_Xml()                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local   cField		:=	''
Local	aTabelaOK 	:=	{{'ZXM',.T.},{'ZXN',.T.}}
Local	lRet		:=	.F.
Private	cEmpDest	:=	ParamIxb[1]
Private	cNumEmpOrig	:=	cNumEmp    //    GUARDA VALOR ORIGINAL
Private	cEmpAntOrig	:=	cEmpAnt    //    GUARDA VALOR ORIGINAL
Private	cFilAntOrig	:=	cFilAnt    //    GUARDA VALOR ORIGINAL
Private	cNomeEmp	:=	''
Private cTabela		:=	''
Private cArqTab		:=	''
                                    

cZXMModo	:=  cZXNModo	:=    ''
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('ZXM'))
   cZXMModo	:=    AllTrim(SX2->X2_MODO)
EndIf
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('ZXN'))
   cZXNModo	:=    AllTrim(SX2->X2_MODO)
EndIf



For nI := 1 To 2

	cTabela	:=	IIF(nI==1,'ZXM','ZXN')                                   
	cArqTab :=  cTabela+cEmpDest +'0'
	nPosTab	:=	Ascan(aTabelaOK, {|X|X[1] == cTabela } )
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  FECHA SX2 EMPRESA ATUAL  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IIF(Select('SX2')!=0, SX2->(DbCLoseArea()  ), )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  FECHA ZXM EMPRESA ATUAL  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IIF(Select(cArqTab)!=0, cTabela->(DbCLoseArea()  ), )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  RECEBE VALOR DA EMPRESA DESTINO   |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNumEmp    :=    cEmpDest+'01'
	cEmpAnt    :=    cEmpDest
	cFilAnt    :=    '01'
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  BUSCA NOME DA EMPRESA DESTINO  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nFilDest := Ascan(_aEmpFil, {|X| X[1] == cEmpDest })
	cNomeEmp := Alltrim(_aEmpFil[nFilDest][1]+'-'+_aEmpFil[nFilDest][2]+' \ '+_aEmpFil[nFilDest][4])
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ABRE SX2 DA EMPRESA DESTINO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbUseArea(.T.,,_StartPath+'SX2'+ cEmpDest +'0', 'SX2' ,.T.,.F.)
	DbSetIndex(_StartPath+'SX2'+ cEmpDest +'0')
	
	
	#IFDEF TOP
	   If !TCCanOpen(cArqTab)
	       Processa( {|| CriaZXM(cTabela,cEmpDest)},'Aguarde...','Criando arquivos SX´s Tabela '+cTabela+', Empresa: '+cNomeEmp, .T.)
	   EndIf
	#ELSE
	   ChkFile(cTabela,.T.,cTabela,Processa({|| CriaZXM(cTabela,cEmpDest)},'Aguarde...','Criando arquivos SX´s Tabela '+cTabela+' Empresa: '+cNomeEmp, .T.),,,'',.T.)
	#ENDIF
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA SE TODOS CAMPOS FORAM CRIADOS   |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea('SX3');DbSetOrder(1);DbGoTop()
	If DbSeek(cTabela+'01',.F.)
	   Do While !Eof() .And. SX3->X3_ARQUIVO == cTabela         
	       cCampo   :=    Alltrim(SX3->X3_CAMPO)
	       If &(cTabela)->(FieldPos(cCampo)) <= 0
	           	cField += cCampo + ENTER
				aTabelaOK[nPosTab][2] := .F.	
	       EndIf
	
	       DbSelectArea('SX3')
	       DbSkip()
	   EndDo
	Else
        nPos :=	 Ascan(aTabelaOK, {|X|X[1] == cTabela } )
		aTabelaOK[nPos][2] := .F.	
	EndIf
	
	
	If !Empty(cField)
	   MsgAlert('NÃO FOI POSSÍVEL CRIAR TODOS OS CAMPOS DA TABELA '+cTabela+' !!!'+ENTER+;
	               'Empresa: '+cNomeEmp+ENTER+ENTER+;
	              'Verifique a estrutura da tabela.'+ENTER+;
	              'Entre no modulo Configurador e Crie\Recrie o(s) seguinte(s) campo(s):'+ENTER+ cField  )
	   cField	:=	''
	
	EndIf
		
Next


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE ARQUIVO DE CONFIGURACAO    |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX:=1 To Len(aTabelaOK)

	lRet	:=	IIF(aTabelaOK[nX][2], .T., .F. )
	If !lRet
		Exit
	EndIf
	
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATUALIZA CAMPO ESTRUT_ZXM DO ARQUIVO ZXM_CFG.DBF     	 |
//³ UTILIZADO PARA VERIFICAR SE ESTRUTURA DA TABELA ESTA OK  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()
If DbSeek(cEmpAnt+cFilAnt, .F.)
   RecLock('TMPCFG',.F.)
       	TMPCFG->ESTRUT_ZXM := lRet
   MsUnLock()
EndIf

	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FECHA SX2 EMPRESA DESTINO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IIF(Select('SX2')!=0, SX2->(DbCLoseArea()  ), )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FECHA ZXM EMPRESA DESTINO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IIF(Select('ZXM')!=0, ZXM->(DbCLoseArea()  ), )
IIF(Select('ZXN')!=0, ZXN->(DbCLoseArea()  ), )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³    VOLTA VALOR ORIGINAL   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNumEmp    :=    cNumEmpOrig
cEmpAnt    :=    cEmpAntOrig
cFilAnt    :=    cFilAntOrig


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  ABRE SX2 EMPRESA ATUAL   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbUseArea(.T.,,_StartPath+'SX2'+ cEmpAnt +'0', 'SX2' ,.T.,.F.)
DbSetIndex(_StartPath+'SX2'+ cEmpAnt +'0')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  ABRE ZZXM\ZXN EMPRESA ATUAL   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EmpOpenFile('ZXM',"ZXM",1,.T.,cEmpAnt,@cZXMModo)
EmpOpenFile('ZXN',"ZXN",1,.T.,cEmpAnt,@cZXNModo)

Return(lRet)
***********************************************************************
Static Function CriaZXM()
***********************************************************************

Processa({||CriaSIX(cTabela)},'SIX... ','Aguarde... Tabela'+cTabela, .T.)
Processa({||CriaSX2(cTabela)},'SX2... ','Aguarde... Tabela'+cTabela, .T.)
Processa({||CriaSX3(cTabela)},'SX3... ','Aguarde... Tabela'+cTabela, .T.)


IIF(Select('ZXM')!=0, ZXM->(DbCLoseArea()  ), )
IIF(Select('ZXN')!=0, ZXN->(DbCLoseArea()  ), )

Return()
***********************************************************************
Static Function CriaSIX()	//	CRIA SIX ou SINDEX
***********************************************************************
Local lSindex	:=	.F.

ProcRegua(3)

IIF( Select('SIX_ORIG') !=0, SIX_ORIG->(DbCLoseArea()  ), )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³       VERIFICA  SIX  	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(_StartPath+'SIX'+cEmpAntOrig+'0.'+Right(__LocalDriver,3))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ABRE SIX DA EMPRESA ATUAL ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbUseArea(.T.,,_StartPath+'SIX'+cEmpAntOrig+'0','SIX_ORIG',.T.,.F.)
	DbSetIndex(_StartPath+'SIX'+cEmpAntOrig+'0')
	                              
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  VERIFICA  S I N D E X    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf File(_StartPath+'SINDEX.'+Right(__LocalDriver,3))
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ABRE SINDEX DA EMPRESA ATUAL ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbUseArea(.T.,,_StartPath+'SINDEX','SIX_ORIG',.T.,.F.)
	DbSetIndex(_StartPath+'SINDEX')
	lSindex	  := .T.

EndIf


DbSelectArea('SIX_ORIG');DbSetOrder(1);DbGoTop()
If DbSeek(cTabela+'1', .F.)    //    INDICE + ORDEM
   IncProc()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ABRE SIX DA EMPRESA DESTINO³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   IIF( Select('SIX_DEST')!=0, SIX_DEST->(DbCLoseArea()  ), )
   If !lSindex
	   DbUseArea(.T.,,_StartPath+'SIX'+cEmpDest+'0','SIX_DEST',.T.,.F.)
	   DbSetIndex(_StartPath+'SIX'+cEmpDest+'0')
   Else
	   DbUseArea(.T.,,_StartPath+'SINDEX','SIX_DEST',.T.,.F.)
	   DbSetIndex(_StartPath+'SINDEX')   
   EndIf

   DbSelectArea('SIX_DEST');DbGoTop()
   If !DbSeek(cTabela+'1', .F.)    //    INDICE + ORDEM

       DbSelectArea('SIX_ORIG')
       Do While !Eof() .And. SIX_ORIG->INDICE == cTabela
           DbSelectArea('SIX_DEST')
           RecLock('SIX_DEST',.T.)
               SIX_DEST->INDICE     :=    SIX_ORIG->INDICE
               SIX_DEST->ORDEM     	:=    SIX_ORIG->ORDEM
               SIX_DEST->CHAVE     	:=    SIX_ORIG->CHAVE
               SIX_DEST->DESCRICAO	:=    SIX_ORIG->DESCRICAO
               SIX_DEST->DESCSPA	:=    SIX_ORIG->DESCSPA
               SIX_DEST->DESCENG	:=    SIX_ORIG->DESCENG
               SIX_DEST->PROPRI 	:=    SIX_ORIG->PROPRI
               SIX_DEST->F3       	:=    SIX_ORIG->F3
               SIX_DEST->NICKNAME 	:=    SIX_ORIG->NICKNAME
               SIX_DEST->SHOWPESQ 	:=    SIX_ORIG->SHOWPESQ
           MsUnLock()

           DbSelectArea('SIX_ORIG')
           DbSkip()
       EndDo
   EndIf
Else
   MsgAlert('Não encontrado INDICE "'+cTabela+'" da Empresa atual.... Verifique tabela de indices...'+ENTER+'Ou crie o indice: '+cTabela)
EndIf


IIF( Select('SIX_ORIG') !=0, SIX_ORIG->(DbCLoseArea() ),)
IIF( Select('SIX_DEST') !=0, SIX_DEST->(DbCLoseArea() ),)

Return()
***********************************************************************
Static Function CriaSX2()
***********************************************************************

ProcRegua(3);IncProc()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ABRE SX2 DA EMPRESA ATUAL  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IIF( Select('SX2_ORIG') !=0, SX2_ORIG->(DbCLoseArea()  ), )
DbUseArea(.T.,,_StartPath+'SX2'+cEmpAntOrig+'0','SX2_ORIG',.T.,.F.)
DbSetIndex(_StartPath+'SX2'+cEmpAntOrig+'0')

DbSelectArea('SX2_ORIG');DbSetOrder(1);DbGoTop()
If DbSeek(cTabela, .F.)    //    CHAVE
   IncProc()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ABRE SX2 DA EMPRESA DESTINO³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   IIF( Select('SX2_DEST')  !=0, SX2_DEST->(DbCLoseArea()  ), )
   DbUseArea(.T.,,_StartPath+'SX2'+cEmpDest+'0','SX2_DEST',.T.,.F.)
   DbSetIndex(_StartPath+'SX2'+cEmpDest+'0')

   DbSelectArea('SX2_DEST');DbGoTop()
   If !DbSeek(cTabela, .F.)    //    INDICE + ORDEM

       DbSelectArea('SX2_ORIG')
       Do While !Eof() .And. SX2_ORIG->X2_CHAVE == cTabela
           DbSelectArea('SX2_DEST')
           RecLock('SX2_DEST',.T.)
               SX2_DEST->X2_CHAVE	:=	SX2_ORIG->X2_CHAVE
               SX2_DEST->X2_PATH	:=	SX2_ORIG->X2_PATH
               SX2_DEST->X2_ARQUIVO	:=	cTabela+cEmpDest+'0'
               SX2_DEST->X2_NOME	:=	SX2_ORIG->X2_NOME
               SX2_DEST->X2_NOMESPA	:=	SX2_ORIG->X2_NOMESPA
               SX2_DEST->X2_NOMEENG	:=	SX2_ORIG->X2_NOMEENG
               SX2_DEST->X2_ROTINA	:=	SX2_ORIG->X2_ROTINA
               SX2_DEST->X2_MODO	:=	SX2_ORIG->X2_MODO
               SX2_DEST->X2_DELET	:=	SX2_ORIG->X2_DELET
               SX2_DEST->X2_TTS		:=	SX2_ORIG->X2_TTS
               SX2_DEST->X2_UNICO	:=	SX2_ORIG->X2_UNICO
               SX2_DEST->X2_PYME	:=	SX2_ORIG->X2_PYME
               SX2_DEST->X2_TTS		:=	SX2_ORIG->X2_TTS
           MsUnLock()
           DbSelectArea('SX2_ORIG')
           DbSkip()
       EndDo
   EndIf
Else
   MsgAlert('Não encontrado chave "'+cTabela+'" na tabela SX2 da Empresa atual.... Verifique tabela SX2...'+ENTER+'Ou crie a chave '+cTabela+' na tabela SX2.')
EndIf

IncProc()

IIF( Select('SX2_ORIG') !=0, SX2_ORIG->(DbCLoseArea() ),)
IIF( Select('SX2_DEST') !=0, SX2_DEST->(DbCLoseArea() ),)

Return()
***********************************************************************
Static Function CriaSX3()
***********************************************************************
ProcRegua(3);IncProc()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ABRE SX3 DA EMPRESA ATUAL  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IIF( Select('SX3_ORIG') !=0, SX3_ORIG->(DbCLoseArea()  ), )
DbUseArea(.T.,,_StartPath+'SX3'+cEmpAntOrig+'0','SX3_ORIG',.T.,.F.)
DbSetIndex(_StartPath+'SX3'+cEmpAntOrig+'0')

DbSelectArea('SX3_ORIG');DbSetOrder(1);DbGoTop()
If DbSeek(cTabela+'01', .F.)        //    X3_ARQUIVO + Z3_ORDERM
   IncProc()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ABRE SX3 DA EMPRESA DESTINO³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   IIF( Select('SX3_DEST') !=0, SX3_DEST->(DbCLoseArea()  ), )
   DbUseArea(.T.,,_StartPath+'SX3'+cEmpDest+'0','SX3_DEST',.T.,.F.)
   DbSetIndex(_StartPath+'SX3'+cEmpDest+'0')

   DbSelectArea('SX3_DEST');DbGoTop()
   If !DbSeek(cTabela, .F.)    //    INDICE + ORDEM
       DbSelectArea('SX3_ORIG')
       Do While !Eof() .And. SX3_ORIG->X3_ARQUIVO == cTabela
           DbSelectArea('SX3_DEST')
           RecLock('SX3_DEST',.T.)
               SX3_DEST->X3_ARQUIVO		:=    SX3_ORIG->X3_ARQUIVO
               SX3_DEST->X3_ORDEM     	:=    SX3_ORIG->X3_ORDEM
               SX3_DEST->X3_CAMPO     	:=    SX3_ORIG->X3_CAMPO
               SX3_DEST->X3_TIPO		:=    SX3_ORIG->X3_TIPO
               SX3_DEST->X3_TAMANHO		:=    SX3_ORIG->X3_TAMANHO
               SX3_DEST->X3_DECIMAL		:=    SX3_ORIG->X3_DECIMAL
               SX3_DEST->X3_TITULO		:=    SX3_ORIG->X3_TITULO
               SX3_DEST->X3_TITSPA		:=    SX3_ORIG->X3_TITSPA
               SX3_DEST->X3_TITENG		:=    SX3_ORIG->X3_TITENG
               SX3_DEST->X3_DESCRIC 	:=    SX3_ORIG->X3_DESCRIC
               SX3_DEST->X3_DESCSPA     :=    SX3_ORIG->X3_DESCSPA
               SX3_DEST->X3_DESCENG     :=    SX3_ORIG->X3_DESCENG
               SX3_DEST->X3_PICTURE     :=    SX3_ORIG->X3_PICTURE
               SX3_DEST->X3_VALID     	:=    SX3_ORIG->X3_VALID
               SX3_DEST->X3_USADO     	:=    SX3_ORIG->X3_USADO
               SX3_DEST->X3_RELACAO     :=    SX3_ORIG->X3_RELACAO
               SX3_DEST->X3_F3          :=    SX3_ORIG->X3_F3
               SX3_DEST->X3_NIVEL     	:=    SX3_ORIG->X3_NIVEL
               SX3_DEST->X3_RESERV     	:=    SX3_ORIG->X3_RESERV
               SX3_DEST->X3_CHECK     	:=    SX3_ORIG->X3_CHECK
               SX3_DEST->X3_TRIGGER     :=    SX3_ORIG->X3_TRIGGER
               SX3_DEST->X3_PROPRI     	:=    SX3_ORIG->X3_PROPRI
               SX3_DEST->X3_BROWSE     	:=    SX3_ORIG->X3_BROWSE
               SX3_DEST->X3_VISUAL     	:=    SX3_ORIG->X3_VISUAL
               SX3_DEST->X3_CONTEXT		:=    SX3_ORIG->X3_CONTEXT
               SX3_DEST->X3_OBRIGAT		:=    SX3_ORIG->X3_OBRIGAT
               SX3_DEST->X3_VLDUSER		:=    SX3_ORIG->X3_VLDUSER
               SX3_DEST->X3_CBOX      	:=    SX3_ORIG->X3_CBOX
               SX3_DEST->X3_CBOXSPA     :=    SX3_ORIG->X3_CBOXSPA
               SX3_DEST->X3_CBOXENG     :=    SX3_ORIG->X3_CBOXENG
               SX3_DEST->X3_PICTVAR     :=    SX3_ORIG->X3_PICTVAR
               SX3_DEST->X3_WHEN		:=    SX3_ORIG->X3_WHEN
               SX3_DEST->X3_INIBRW     	:=    SX3_ORIG->X3_INIBRW
               SX3_DEST->X3_GRPSXG		:=    SX3_ORIG->X3_GRPSXG
               SX3_DEST->X3_FOLDER		:=    SX3_ORIG->X3_FOLDER
               SX3_DEST->X3_PYME		:=    SX3_ORIG->X3_PYME
               SX3_DEST->X3_CONDSQL    	:=    SX3_ORIG->X3_CONDSQL
               SX3_DEST->X3_CHKSQL     	:=    SX3_ORIG->X3_CHKSQL
               SX3_DEST->X3_IDXSRV 		:=    SX3_ORIG->X3_IDXSRV
               SX3_DEST->X3_ORTOGRA		:=    SX3_ORIG->X3_ORTOGRA
               SX3_DEST->X3_IDXFLD     	:=    SX3_ORIG->X3_IDXFLD
               SX3_DEST->X3_TELA      	:=    SX3_ORIG->X3_TELA
           MsUnLock()
           DbSelectArea('SX3_ORIG')
           DbSkip()
       EndDo
   EndIf
Else
   MsgAlert('Não encontrado arquivo "'+cTabela+'" na tabela SX3 na Empresa atual.... Verifique tabela SX3...'+ENTER+'Ou crie os campos na tabela: '+cTabela)
EndIf

IncProc()

IIF( Select('SX3_ORIG') !=0, SX3_ORIG->(DbCLoseArea() ),)
IIF( Select('SX3_DEST') !=0, SX3_DEST->(DbCLoseArea() ),)

Return()
***********************************************************************
User Function AjustaEmpFil()
***********************************************************************
DbSelectArea('TMPCFG');DbSetOrder(1);DbGoTop()
Do While !Eof()
                                           
	If TMPCFG->EMP_ATIVA == 'NÃO'
		nPos := Ascan(_aEmpFil, { |X| X[3] == TMPCFG->CNPJ } ) 
		If nPos > 0

	
			If 	AllTrim(TMPCFG->CNPJ)   == AllTrim(SM0->M0_CGC)   .And.;
				AllTrim(TMPCFG->EMPRESA)== AllTrim(SM0->M0_CODIGO).And.;
				AllTrim(TMPCFG->FILIAL) == AllTrim(SM0->M0_CODFIL)
				
				Alert('EMPRESA CONFIGURADA COMO NÃO ATIVA!!!'+ENTER+ENTER+;
					  'EMPRESA: '+AllTrim(TMPCFG->EMPRESA)+'\'+AllTrim(TMPCFG->FILIAL)+'  -  '+AllTrim(TMPCFG->NOME_EMP)+ENTER+;
					  'CNPJ:    '+Transform(AllTrim(TMPCFG->CNPJ),'@R 99.999.999/9999-99' )+ENTER+ENTER+;
					  'Poderá ocorrer problemas caso prossiga com a execução nesta EMPRESA\FILIAL.'+ENTER+;
				      'Verifique as configurações da empresa.') 

			EndIf

			_aEmpFil[nPos][3] := 'EMPRESA_NAO_ATIVA'
			
		EndIf
	
	EndIf
	DbSkip()
EndDo

Return()
***********************************************************************
Static Function ForCliMsBlql(cTabela, cCnpj, lImportacao, cCodFornece, cLojaFornece)
***********************************************************************
Local _lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FUNCAO PARA VERIFICAR SE CADASTRO DE CLIENTE OU FORNECEDOR ³
//³NAO ESTA BLOQUEADO                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTabela == 'SA2' 

	If !lImportacao
		DbSelectArea('SA2');DbSetOrder(3);DbGoTop()
		If DbSeek(xFilial('SA2')+ cCnpj, .F.) 
			Do While !Eof() .And. AllTrim(SA2->A2_CGC) == AllTrim(cCnpj) .And. SA2->A2_MSBLQL == '1'  // 1=Sim;2=Näo
				DbSkip()
			EndDo
		Else
			_lRet := .F.
		EndIf
		
	Else
	
		DbSelectArea('SA2');DbSetOrder(3);DbGoTop()
		If DbSeek(xFilial('SA2')+ cCodFornece + cLojaFornece, .F.)
			Do While !Eof() .And. AllTrim(SA2->A2_COD) == AllTrim(cCodFornece) .And. AllTrim(SA2->A2_LOJA) == AllTrim(cLojaFornece) .And. SA2->A2_MSBLQL == '1'
				DbSkip()
			EndDo	
		Else
			_lRet := .F.
		EndIf           
		
	EndIf
		    
		
ElseIf cTabela == 'SA1'
        

	If !lImportacao	
		DbSelectArea('SA1');DbSetOrder(3);DbGoTop()
		If DbSeek(xFilial('SA1')+ cCnpj, .F.) 
			Do While !Eof() .And. AllTrim(SA1->A1_CGC) == AllTrim(cCnpj) .And. SA1->A1_MSBLQL == '1' // BLOQUEADO
				DbSkip()
			EndDo
		Else 
			_lRet := .F.
		EndIf           
		
	Else
	
		DbSelectArea('SA1');DbSetOrder(3);DbGoTop()
		If DbSeek(xFilial('SA1')+  cCodFornece + cLojaFornece,, .F.) 
			Do While !Eof() .And. AllTrim(SA1->A1_COD) == AllTrim(cCodFornece) .And. AllTrim(SA1->A1_LOJA) == AllTrim(cLojaFornece) .And. SA1->A1_MSBLQL == '1' // BLOQUEADO
				DbSkip()
			EndDo
		Else
			_lRet := .F.
		EndIf

	EndIf
	
EndIf

Return(_lRet)
*****************************************************************
User Function NFeOpenArqCfg()
*****************************************************************
Local  lRetorno		:=	.T.
Local  lCopia		:=	IIF(Type('ParamIxb')=='U', .F., IIF(Len(ParamIxb)>0,ParamIxb[01], .F.) )
Static 	cArqConfig	:=	'ZXM_CFG.DBF'
Static 	cIndConfig	:=	'TMPCFG.CDX'
Static cOldArq_Cfg	:=	Left(cArqConfig, (Len(cArqConfig)-4))+'_OLD'+Right(AllTrim(cArqConfig), 4)
Static _StartPath
Static _RootPath
Static _RpoDb
Static _cPathTable
Static _cArqIni
Static _cMail
Static _aEmpFil


If Type('_StartPath') == 'U' .And. Empty(_StartPath)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³    CARREGA INFORMACOES DE CONFIGURACAO	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRetIni := ExecBlock("IniConfig",.F.,.F.,{.F.})
	
	If !aRetIni[01]
		lRetorno := .F.
	Else
		nX:=2      
		_StartPath	:=	aRetIni[nX]; nX++	//	[02]
		_RootPath	:=	aRetIni[nX]; nX++	//	[03]
		_RpoDb		:=	aRetIni[nX]; nX++	//	[04]
		_cPathTable	:=	aRetIni[nX]; nX++	//	[05]
		_cArqIni	:=	aRetIni[nX]; nX++	//	[06]
		_cMail		:=	aRetIni[nX]; nX++	//	[07]
		_aEmpFil	:=	aRetIni[nX]			//	[08]
	EndIf	
	

	ExecBlock("TelaConfig",.F.,.F., {.F.} )
	
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE ARQUIVO DE CONFIGURACAO    |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File(_StartPath+cArqConfig)
	ExecBlock("TelaConfig",.F.,.F., {.F., .F.} )
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE ARQUIVO DE CONFIGURACAO    |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select('TMPCFG') == 0
	DbUseArea(.T.,,_StartPath+cArqConfig, 'TMPCFG',.T.,.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VERIFICA SE INDICE EXISTE, CASO NEGATIVO CRIA NOVO INDICE	 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If !File(_StartPath+cIndConfig)						// TMPCFG.CDX
	DBCreateIndex('TMPCFG','EMPRESA+FILIAL', {|| 'EMPRESA+FILIAL' } )
EndIf


If File(_StartPath+cArqConfig)
	If lCopia
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ COPIA _CFG.DBF PARA _CFG_OLD.DBF	 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_CopyFile(_StartPath+cArqConfig, _StartPath+cOldArq_Cfg)
	
	EndIf
Else
	Alert('Problema ao carregar informações! Rotina NFeOpenArqCfg.' )
EndIf
		             


If Select('TMPCFG') != 0

	If TMPCFG->(IndexOrd()) == 0
		//TMPCTE->(IndexKey()) != 'EMPRESA+FILIAL'
		
		If Select('TMPCFG') == 0
			DbUseArea(.T.,,_StartPath+cArqConfig, 'TMPCFG',.T.,.F.)
		Else
			DbSelectArea('TMPCFG')
		EndIf


		If !File(_StartPath+cIndConfig)
			DBCreateIndex(_StartPath+'TMPCFG','EMPRESA+FILIAL', {|| 'EMPRESA+FILIAL' } )
		Else
			//cIndexArq := RetFileName(cIndConfig)
			//DbSetIndex(_StartPath+'CTE_CFG\'+cIndexArq)
			DbSetIndex(_StartPath+cIndConfig)
		EndIf


	EndIf
	
EndIf

Return(lRetorno)
***********************************************************************
Static Function C(nTam)
***********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta Tamanho dos Objetos            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nHRes    :=    oMainWnd:nClientWidth 		// Resolucao horizontal do monitor

   If nHRes == 640                              // Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
       nTam *= 0.8
   ElseIf (nHRes == 798).Or.(nHRes == 800)    	// Resolucao 800x600
       nTam *= 1
   Else                                        	// Resolucao 1024x768 e acima
       nTam *= 1.28
   EndIf

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³Tratamento para tema "Flat"³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If "MP8" $ oApp:cVersion
       If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
           nTam *= 0.90
       EndIf
   EndIf
Return Int(nTam)
***********************************************************************
Static Function D(nTam)	//	QDO TELA Eh DESENVOLVIDA COM RESOLUCAO 1080
***********************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta Tamanho dos Objetos            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nHRes    :=    oMainWnd:nClientWidth		// Resolucao horizontal do monitor

   If nHRes == 640                            	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
       nTam /= 1.28
   ElseIf (nHRes == 798).Or.(nHRes == 800)    	// Resolucao 800x600
       nTam /= 1.28
   Else                                        	// Resolucao 1024x768 e acima
      nTam *= 1.28
   EndIf

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³Tratamento para tema "Flat"³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If "MP8" $ oApp:cVersion .Or. '10' $ cVersao 
       If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
           nTam /= 1.04
       EndIf
   EndIf
Return Int(nTam)