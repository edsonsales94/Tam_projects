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
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммммкммммммямммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё ImpXMLCTe      ╨ AutorЁFabiano Pereira╨ Data Ё 02/11/2011  ╨╠╠
╠╠лммммммммммьммммммммммммммммйммммммомммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁImporta Arquivo Xml Conhecimento de Frete                   ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╨╠╠
╠╠ЁObservacaoЁ Padrao                                                     ╨╠╠
╠╠Ё          Ё                                                            ╨╠╠
╠╠Ё          Ё Tabelas: ZXC,ZXD                                           ╨╠╠
╠╠Ё          Ё ZXC_ERROS_CTE.TXT                                          ╨╠╠
╠╠Ё          Ё TMPCTE -> TMPCTE                                           ╨╠╠
╠╠Ё          Ё                                                            ╨╠╠
╠╠Ё          Ё                                                            ╨╠╠
╠╠Ё          Ё                                                            ╨╠╠
╠╠Ё          Ё                                                            ╨╠╠
╠╠Ё          Ё                                                            ╨╠╠
╠╠Ё          Ё                                                            ╨╠╠
╠╠Ё          Ё                                                            ╨╠╠
╠╠Ё          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Protheus 10                                                ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
*/
*********************************************************************
User Function ImpXMLCTe()
*********************************************************************
Local lTableField	:=	.T.
Local aRetIni 		:=	{} 
Local lRetTela 		:=	.F.

Private	aAlias		:=	GetArea()
Private	cCadastro	:=	'Status CTe'
Private	cArqErro	:=	'ZXC_ERROS_CTE.TXT'
Private	aRotina		:=	{}
Private	aCores		:=	{}
Private	aLegenda	:=	{}
Private	aArqTemp	:=	{}

Static 	nHRes    	:=	IIF(Type('oMainWnd')!='U', oMainWnd:nClientWidth, )       // Resolucao horizontal do monitor



SetKey( VK_F12, {|| Aviso('Chave CT-e', ZXC->ZXC_CHAVE ,{'Ok'},3) })
SetKey( VK_F11, {|| ExecBlock("CTe_Visual" ,.F.,.F.,{"FRETE_COMPRA"})  })		//	Sobre Compra
SetKey( VK_F8,  {|| MATA116(), })	   											//	NF.Conhec.Frete
SetKey( VK_F9,  {|| ExecBlock("CTe_Visual" ,.F.,.F.,{"FRETE_VENDA"})  })		//	Sobre Venda



aPrw := GetAPOInfo('CTe_IniConfig.prw') 
If Len(aPrw) == 0
	Alert('O Path dessa rotina nЦo foi aplicado!'+ENTER+'Aplique o path de liberaГЦo de acesso para continuar...') 
	Final()
EndIf


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё INICIALIZACAO VARIAVEIS \ aEmpFil\PARAMETROS \ ARQ.TEMP    |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
MsgRun('Verificando arquivo de configuraГЦo...', 'Aguarde... ',{|| aRetIni := ExecBlock("CTe_IniConfig",.F.,.F.,) })
If !aRetIni[01]
	Return()
Else
	nX:=2      
	_StartPath	:=	aRetIni[nX]; nX++		//	2
	_RootPath	:=	aRetIni[nX]; nX++		//	3
	_RpoDb		:=	aRetIni[nX]; nX++		//	4
	_cPathTable	:=	aRetIni[nX]; nX++		//	5	-	_cPathTable
	_cArqIni	:=	aRetIni[nX]; nX++		//	6
	_cMail		:=	aRetIni[nX]; nX++		//	7
	_aEmpFil	:=	aRetIni[nX]				//	8     
	
EndIf

//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё INICIALIZA\ATUALIZA ARQUIVO CTE_CFG.DBF     |
//юддддддддддддддддддддддддддддддддддддддддддддды          
MsgRun('Verificando arquivo config...', 'Aguarde... ', {|| lRetTela := ExecBlock("CTe_TelaConfig",.F.,.F., {.F.}) })
If !lRetTela
	Return()
EndIf
//зддддддддддддддддддддддддддддддддд©
//Ё ABRE ARQUIVO DE CONFIGURACAO    |
//юддддддддддддддддддддддддддддддддды
********************************************
	ExecBlock('OpenArqCfg',.F., .F., {} )
********************************************

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VERIFICA SE ESTRUTURA DA TABELA ZXC                  |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*
DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()
If DbSeek(cEmpAnt+cFilAnt, .F.)     
   If !TMPCTE->ESTRUT_ZXC

       If !ExecBlock("CTe_CreateTable",.F.,.F.,{cEmpAnt} )
           MsgAlert('Estrutura da Tabela ZXC \ ZXD nЦo esta completa.')	
           Return()
       EndIf

   EndIf
EndIf
*/

DbSelectArea('ZXC');DbSetorder(1)
DbSelectArea('ZXD');DbSetorder(1)

aCores    := {  { 'ZXC->ZXC_SITUAC=="C" '		, 'BR_VERMELHO'	},;
                { 'ZXC->ZXC_STATUS=="*" '   	, 'BR_LARANJA'	},;
                { 'ZXC->ZXC_STATUS=="I" '   	, 'BR_AZUL'		},;
                { 'ZXC->ZXC_STATUS=="R" '   	, 'BR_CINZA'		},;
                { 'ZXC->ZXC_STATUS=="X" '   	, 'BR_CANCEL'		},;
                { 'ZXC->ZXC_STATUS=="G" '   	, 'BR_VERDE'		}}


aLegenda:= {	{ 'BR_AZUL'		,'XML CT-e Importado'			},;
                { 'BR_LARANJA'	,'XML CT-e Arquivado'			},;
                { 'BR_CINZA'	,'XML CT-e Recusado'			},;
                { 'BR_CANCEL'	,'XML CT-e Cancelado pelo Usuario'},;
                { 'BR_VERDE'	,'XML CT-e Gravado'				},;
                { 'BR_VERMELHO'	,'XML CT-e Cancelado na Sefaz'	}}



//Aadd( aRotina, { "Pesquisar"		, 'AxPesqui'                          	 ,	0, 1, 0, .F.})

Aadd( aRotina, { "Visualizar"		, 'ExecBlock("CTe_Visual" ,.F.,.F.,{""})',	0, 4 })        	

_aRot:={}
Aadd( _aRot, { "Sobre Compra    - F11"	, 'ExecBlock("CTe_Visual" ,.F.,.F.,{"FRETE_COMPRA"})',	0, 4 })     
Aadd( _aRot, { "NF.Conhec.Frete - F8"	, 'MATA116',	0, 3 })
Aadd( _aRot, { "Sobre Venda     - F9"	, 'ExecBlock("CTe_Visual" ,.F.,.F.,{"FRETE_VENDA"})',	0, 4 })        	
Aadd( _aRot, { "Frete Venda - VАrios"	, 'ExecBlock("MultFreteVenda" ,.F.,.F.,{""})',	0, 4 })        	

Aadd( aRotina,    { 'Frete',    _aRot, 0 , 4} )


Aadd( aRotina, { "Carregar CT-e"	, 'ExecBlock("CTe_Carrega",.F.,.F.,{""})',	0, 3 })
Aadd( aRotina, { "ConfiguraГУes"	, 'ExecBlock("CTe_TelaConfig",.F.,.F., {.T.} )',	0, 3 })          

_aRot:={}
Aadd( _aRot, { "Status XML"			, 'ExecBlock("CTe_ConsNFeSefaz",.F.,.F.,{""})',	0, 6 })  	
Aadd( _aRot, { "Status Sefaz"		, 'ExecBlock("CTe_SefazStatus",.F.,.F.,{""})',	0, 6 })     
Aadd( _aRot, { "Site Sefaz"       	, 'ExecBlock("CTe_SiteSefaz",.F.,.F.,{""})',	0, 6 })    	
Aadd( _aRot, { "Msg. Erro"			, 'ExecBlock("CTe_Erro",.F.,.F.,{""})',			0, 6 })

Aadd( aRotina,    { 'Consulta Sefaz',    _aRot, 0 , 4} )


Aadd( aRotina, { "Exportar"        	, 'ExecBlock("CTe_Exporta",.F.,.F.,{""})',	0, 4 })        	
Aadd( aRotina, { "Recusar XML"     	, 'ExecBlock("CTe_Recusar",.F.,.F.,{""})',	0, 4 })        	
Aadd( aRotina, { "Cancelar"        	, 'ExecBlock("CTe_Cancelar",.F.,.F.,{""})',	0, 4 })        	
Aadd( aRotina, { "Excluir"        	, 'ExecBlock("CTe_Excluir",.F.,.F.,{""})',	0, 4 })        	

#IFNDEF TOP
   Aadd( aRotina, { "Filtro"		, 'ExecBlock("CTe_Filtro",.F.,.F.,{""})',	0, 4 })         
#ENDIF
Aadd( aRotina, { "Legenda"			, 'BrwLegenda("Legenda Status XML CT-e","Status XML CT-e",aLegenda)',    0, 2 })


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё P.E. Utilizado para adicionar botoes ao Menu Principal       Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
IF ExistBlock("CTE_ROTIMPXML")
	aRotNew := ExecBlock("CTE_ROTIMPXML",.F.,.F.,aRotina)
	For nX := 1 To Len(aRotNew)
		aAdd(aRotina,aRotNew[nX])
	Next
Endif


MBrowse( 06, 01,22,75,"ZXC",,,,,,aCores)


//    APAGA ARQUIVOS TEMPORARIOS
If Len(aArqTemp) > 0
   For nX := 1 To Len(aArqTemp)
       FErase( aArqTemp[nX] )
   Next
EndIf

IIF(Select("ZXC")     != 0, ZXC->(DbCLoseArea()), )
IIF(Select("TMP")     != 0, TMP->(DbCLoseArea()), )
IIF(Select('TMPCTE')  != 0, TMPCTE->(DbCLoseArea()), )

RestArea(aAlias)
Return()
************************************************************************
User Function CTe_TelaConfig()
************************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё INICIALIZA\ATUALIZA ARQUIVO CTE_CFG.DBF     |
//Ё Chamada -> Inicio Programa e                |
//|            Rotina - Configuracao            Ё
//юддддддддддддддддддддддддддддддддддддддддддддды
Local	aFds            :=	{}
Local	aNewField		:=	{}
Local	aReturn			:=	{}
Local 	lCopia			:=	.F.

Static 	cCfgVersao 	:= '1.0'
Static 	nHRes    	:=	IIF(Type('oMainWnd')!='U', oMainWnd:nClientWidth, )       // Resolucao horizontal do monitor


Private	lMostraTela		:=	ParamIxb[01]
Private	lCheckArqCfg 	:=	IIF(Len(ParamIxb)>01, ParamIxb[02], .T.)
             

Private	cTpMail        	:=	_cMail
Private	cPathTables    	:=	IIF(!Empty(_cPathTable), _cPathTable, '' ) +Space(15)
Private	cEmail        	:=	Space(100)
Private	cPassword    	:=	Space(100)
Private	cPOrigem 		:= 	'Caixa de Entrada'+Space(095)
Private	cPDestino    	:= 	Space(100)
Private	cServerEnv		:= 	Alltrim(GetMv('MV_RELSERV'))+    Space(100)
Private	cServerRec		:= 	Alltrim(GetMv('MV_RELSERV'))+    Space(100)
Private	cNFe9Dig		:= 	'SIM'
Private	cSer3Dig		:= 	'SIM'
Private	cSerTransf    	:= 	Space(TamSX3('F1_SERIE')[1])
Private	cPreDoc        	:= 	'PRE'
Private	cPortRec    	:= 	IIF(Type('_cMail') != 'U',  IIF(Left(_cMail,3)=='POP','587',IIF(_cMail=='IMAP','143','##')), '') //IIF(Left(_cMail,3)=='POP','587',IIF(_cMail=='IMAP','143','##'))
Private	cPortEnv    	:= 	'25'
Private	cConect        	:= 	''
Private	cPath_XML      	:= 	Space(100)
Private	cProbEmail		:=	Space(100)
Private	cXmlCancFor		:=	Space(200)
Private	cProdxCTe		:=	Space(TamSx3('B1_COD')[1])
Private	cTesxCTe		:=	Space(TamSx3('B1_TE')[1])
Private	cEspxCTe		:=	Space(TamSx3('F1_ESPECIE')[1])

Private	lAutent			:= 	.F.
Private	lSegura			:=	.F.
Private	lSSL		 	:= 	.F.
Private	lTLS		 	:= 	.F.
Private	lEstrut_Xml 	:= 	.F.
Private	cSem_XML		:= 	'NцO'
Private	cGrv_Dif_A		:= 	'NцO'

Private	lTesteR			:=	.F.
Private	lTesteE			:=	.T.

Private nHoraCanc   	:=	GetMv('MV_SPEDEXC')
Private	cProbEmail   	:= 	Space(200)
Private	cDominio		:=	Space(100)

Private	aMyHeader   	:=	{}
Private	aMyCols     	:=	{}
Private	aConfig     	:=	{}

Private	lNewVersao		:=	.F.
Private	cDescProd:=''
Private	cDescTES:=''


SetPrvt('oDlgSM0'	,'oGrp1' ,'oGrp2' ,'oGrp3' ,'oGrp4'	,'oGrp5'	,'oFolder')
SetPrvt('oSay1'		,'oSay2' ,'oSay3' ,'oSay4' ,'oSay5'	,'oSay6' ,'oSay7' ,'oSay8' ,'oSay9' ,'oSay10')
SetPrvt('oSay11'	,'oSay12','oSay13','oSay14','oSay15','oSay16','oSay17','oSay18','oSay19','oSay20','oSay21')
SetPrvt('oGet1' 	,'oGet2' ,'oGet3' ,'oGet4' ,'oGet5'	,'oGet6' ,'oGet7' ,'oGet8' ,'oGet9' ,'oGet10')
SetPrvt('oGetr11'	,'oGet12','oGet13','oGet14','oGet15','oGet16','oGet17','oGet18','oGet19','oGet20','oGet21')
SetPrvt('oCBox4'	,'oCBox5','oCBox6','oCBox9','oCBox10','oCBox11','oCBox14','oCBox12b','oCBox12c')
SetPrvt('oBtnTest'	,'oOkConect','oNoConect','oSayProd')
SetPrvt('oSay1NomeFil','oSay2NomeFil','oSay3NomeFil')




//зддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁVERIFICA SE NUMERO DO HARDLOCK ESTA RELACIONADOЁ
//ЁPARA UTILIZAR A ROTINA                         Ё
//|												  |	
//|VALIDA TEMPO DE LICENCA FREE					  |
//юддддддддддддддддддддддддддддддддддддддддддддддды
*****************************************************
If !ExecBlock('CTe_CheckLS',.F.,.F.,{.F.})
	Return(.F.)
EndIf
*****************************************************


//зддддддддддддддддддддддддд©
//Ё CAMPOS DO MSNEWGETDADOS	|
//юддддддддддддддддддддддддды
Aadd( aMyHeader , {'Empresa'			,'M0_CODIGO'   	,'@!',002,000,'','','C','',''} )
Aadd( aMyHeader , {'Nome Empresa'		,'M0_NOME'    	,'@!',015,000,'','','C','',''} )
Aadd( aMyHeader , {'Filial'				,'M0_CODFIL'  	,'@!',002,000,'','','C','',''} )
Aadd( aMyHeader , {'Nome Filial'		,'M0_FILIAL'  	,'@!',015,000,'','','C','',''} )
Aadd( aMyHeader , {'CNPJ'				,'M0_CGC'     	,'@R 99.999.999/9999-99',014,000,'','','C','',''} )
Aadd( aMyHeader , {'Inscr Estadual'		,'M0_INSC'     	,'@!',014,000,'','','C','',''} )
Aadd( aMyHeader , {'EndereГo Entrega'	,'M0_ENDENT'    ,'@!',060,000,'','','C','',''} )
Aadd( aMyHeader , {'Compl End Entrega'	,'M0_COMPENT'   ,'@!',012,000,'','','C','',''} )
Aadd( aMyHeader , {'Bairro Entrega'		,'M0_BAIRENT'   ,'@!',020,000,'','','C','',''} )
Aadd( aMyHeader , {'Cidade Entrega'		,'M0_CIDENT'    ,'@!',020,000,'','','C','',''} )
Aadd( aMyHeader , {'Est Ent'			,'M0_ESTENT'    ,'@!',002,000,'','','C','',''} )
Aadd( aMyHeader , {'CEP Ent'			,'M0_CEPENT'    ,'@R 99999-999',008,000,'','','C','',''} )
Aadd( aMyHeader , {'Fone Ent'			,'M0_TEL'       ,'@!',014,000,'','','C','',''} )
Aadd( aMyHeader , {'FAX Ent'			,'M0_FAX'       ,'@!',014,000,'','','C','',''} )
Aadd( aMyHeader , {'EndereГo CobranГa'	,'M0_ENDCOB'   	,'@!',060,000,'','','C','',''} )
Aadd( aMyHeader , {'Bairro CobranГa'    ,'M0_BAIRCOB'	,'@!',020,000,'','','C','',''} )
Aadd( aMyHeader , {'Cidade CobranГa'    ,'M0_CIDCOB'	,'@!',020,000,'','','C','',''} )
Aadd( aMyHeader , {'Est Cob'			,'M0_ESTCOB'    ,'@!',002,000,'','','C','',''} )
Aadd( aMyHeader , {'CEP Cob'			,'M0_CEPCOB'    ,'@R 99999-999',008,000,'','','C','',''} )
Aadd( aMyHeader , {'CNAE'				,'M0_CNAE'		,'@!',007,000,'','','C','',''} )
Aadd( aMyHeader , {'CСdigo Municipio'	,'M0_CODMUN'    ,'@!',007,000,'','','C','',''} )
                             

//зддддддддддддддддддддддддддддддддддддд©
//Ё  CAMPOS DO ARQUIVO CTE_CFG.DBF 		Ё
//юддддддддддддддддддддддддддддддддддддды
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
Aadd( aFds, {"PRE_DOC"  		,"C",    003,000} )
Aadd( aFds, {"ESTRUT_ZXC" 	,"L",    001,000} )
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
Aadd( aFds, {"PRODXCTE"		,"C",    TamSx3('B1_COD')[1],000} )
Aadd( aFds, {"TESXCTE"		,"C",    TamSx3('B1_TE')[1],000} )
Aadd( aFds, {"ESPXCTE"		,"C",    TamSx3('F1_ESPECIE')[1],000} )
Aadd( aFds, {"VERSAO"		,"C",    003,000} )


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//|																							 |
//|				QDO ADICIONAR CAMPO ALTERAR VARIAVEL cCfgVersao                              |
//|																							 |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды


//зддддддддддддддддддддддддддддддддд©
//Ё ABRE ARQUIVO DE CONFIGURACAO    |
//юддддддддддддддддддддддддддддддддды
If lCheckArqCfg

	********************************************************
		lRetArqCfg := ExecBlock('OpenArqCfg',.F., .F., {} )
	********************************************************
Else
	lRetArqCfg := .F.
EndIf
	
//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё  VERFICA VERSAO DO ARQUIVO CTE_CFG.DBF 		Ё
//юддддддддддддддддддддддддддддддддддддддддддддды
If lRetArqCfg

	If Len(aFds) != TMPCTE->(FCount())
		lNewVersao	:= .T.		
	EndIf


	If lNewVersao .And. lCheckArqCfg
                
		********************************************************
			lCopia := ExecBlock('OpenArqCfg',.F., .F., {.T.} )
		********************************************************
		
		If lCopia
		
			//зддддддддддддддддддддддддддддддд©
			//Ё INCREMENTA CONTADOR DE VERSAO Ё
			//юддддддддддддддддддддддддддддддды
		    c1 := Left(cCfgVersao,1)
		    c2 := Right(cCfgVersao,1)
			 If c2 == '9'    
				c1 := Val(c1); c1++
			 	cCfgVersao :=  Alltrim(Str(c1)) + '.0'
			 Else
				c2 := Val(c2); c2++
			 	cCfgVersao :=  c1+'.'+Alltrim(Str(c2))
			 EndIf

			MsgInfo('Foi criado novo(s) parБmetro(s). Verifique arquivo de configuraГЦo.')
	    
	    EndIf


   	ElseIf !lMostraTela
		Return(.T.)
	EndIf

EndIf


//зддддддддддддддддддддддддддд©
//Ё   ALIMENTA CTE_CFG.DBF	  |
//юддддддддддддддддддддддддддды
IF !lRetArqCfg  .Or. (lNewVersao .And. lCopia)
	

	IIF(Select('TMPCTE') != 0, TMPCTE->(DbCLoseArea()), )
	
	If lNewVersao                       
	                           
   		cPathArq  := _StartPath+'CTE_CFG\'
	
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁVERIFICA SE TEM ALGUEM UTILIZANDO O ARQUIVO - TENTA ABRIR EXCLUSIVO 		|
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		
		//	DBUSEAREA (<Lnome Аrea>,<nome driver>, <arquivo> <apelido>,<Lconpartilhado>,<Lapenas leitura> ).
	   	DbUseArea(.T.,,cPathArq+cArqConfig, 'TMPCTE',.F.,.F.)
		If Select('TMPCTE') == 0
			Alert('O arquivo CTE_CFG.DBF esta sendo utilizado.'+ENTER+'O programa Importa XML CT-e nЦo pode estar sendo utilizado para continuar.')
			Return(.F.)
		Else	   

			// JA FEZ COPIA DO ARQUIVO CTE_CFG
			IIF(Select('TMPCTE') != 0, TMPCTE->(DbCLoseArea()), )
			FErase(cPathArq+cArqConfig)	//	APAGA CTE_CFG.DBF
			
			DbUseArea(.T.,,cPathArq+cOldArq_Cfg, 'TMPCTE_OLD',.T.,.F.)		//	 ABRE CTE_CFG_OLD.DBF
		   	DBCreateIndex('TMPCTE_OLD','EMPRESA+FILIAL', {|| 'EMPRESA+FILIAL' })
			Aadd(aArqTemp, cPathArq+'TMPCTE_OLD.CDX')   

		EndIf
		
	EndIf


	DbCreate(_StartPath+'CTE_CFG\'+cArqConfig, aFds )	// CRIA NOVO CTE_CFG.DBF 
	*********************************************                          
		ExecBlock('OpenArqCfg',.F., .F., {} )
	*********************************************
	

	DbSelectArea('SM0');DbGoTop()
	Do While !Eof()   

		If (lNewVersao .And. lCopia)  // __cRdd
			DbSelectArea('TMPCTE_OLD');DbSetOrder(1);DbGoTop()
			DbSeek(SM0->M0_CODIGO + SM0->M0_CODFIL, .F.)
		EndIf


			***************************
				GET_MV_ESPECIE()	//	BUSCA SERIE == SPED
			***************************


		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё   						ALIMENTA CTE_CFG.DBF	  						|
		//| SE CTE_CFG FOR NOVA VERSAO JOGA O CONTEUDO OLD PARA O NOVO CTE_CFG		|
		//| CASO CONTRARIO JOGA AS VARIAVEIS										|
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectArea('TMPCTE') 
       	RecLock('TMPCTE',.T.)
           	TMPCTE->VERSAO			:=	AllTrim(cCfgVersao)
           	TMPCTE->EMPRESA			:=	AllTrim(SM0->M0_CODIGO)
           	TMPCTE->NOME_EMP		:=	AllTrim(SM0->M0_NOME)
           	TMPCTE->FILIAL			:=	AllTrim(SM0->M0_CODFIL)
           	TMPCTE->NOME_FIL		:=	AllTrim(SM0->M0_FILIAL)
           	TMPCTE->CNPJ			:=	AllTrim(SM0->M0_CGC)
           	
           	TMPCTE->PATCHTABLE		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("PATCHTABLE"))>0,	TMPCTE_OLD->PATCHTABLE,		AllTrim(cPathTables))
           	TMPCTE->EMAIL			:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("EMAIL"))>0		, 	TMPCTE_OLD->EMAIL,			AllTrim(cEmail))
           	TMPCTE->SENHA			:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("SENHA"))>0		, 	TMPCTE_OLD->SENHA,			AllTrim(cPassword))
           	TMPCTE->PASTA_ORIG		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("PASTA_ORIG"))>0, 	TMPCTE_OLD->PASTA_ORIG,		AllTrim(cPOrigem)	)
           	TMPCTE->PASTA_DEST		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("PASTA_DEST"))>0, 	TMPCTE_OLD->PASTA_DEST,		AllTrim(cPDestino))
           	TMPCTE->TIPOEMAIL		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("TIPOEMAIL"))>0	, 	TMPCTE_OLD->TIPOEMAIL,		AllTrim(cTpMail))
           	TMPCTE->SERVERENV		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("SERVERENV"))>0	, 	TMPCTE_OLD->SERVERENV,		AllTrim(cServerEnv))
           	TMPCTE->SERVERREC		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("SERVERREC"))>0	, 	TMPCTE_OLD->SERVERREC,		AllTrim(cServerRec))           	
           	TMPCTE->NFE_9DIG		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("NFE_9DIG"))>0	, 	TMPCTE_OLD->NFE_9DIG,		'SIM'	)
           	TMPCTE->SER_3DIG		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("SER_3DIG"))>0	, 	TMPCTE_OLD->SER_3DIG,		'SIM'	)
           	TMPCTE->SER_TRANSF		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("SER_TRANSF"))>0, 	TMPCTE_OLD->SER_TRANSF,		AllTrim(cSerTransf))
           	TMPCTE->PRE_DOC			:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("PRE_DOC"))>0	,	TMPCTE_OLD->PRE_DOC,		AllTrim(cPreDoc))
           	TMPCTE->PORTA_REC		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("PORTA_REC"))>0	, 	TMPCTE_OLD->PORTA_REC,		AllTrim(cPortRec))
           	TMPCTE->PORTA_ENV		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("PORTA_ENV"))>0	, 	TMPCTE_OLD->PORTA_ENV,		AllTrim(cPortEnv))
           	TMPCTE->ESTRUT_ZXC		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("ESTRUT_ZXC"))>0, 	TMPCTE_OLD->ESTRUT_ZXC,		lEstrut_Xml	)
		   	TMPCTE->AUTENTIFIC		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("AUTENTIFIC"))>0, 	TMPCTE_OLD->AUTENTIFIC,		lAutent )
		   	TMPCTE->SSL				:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("SSL"))>0		, 	TMPCTE_OLD->SSL ,			lSSL )
		   	TMPCTE->PATH_XML		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("PATH_XML"))>0	, 	TMPCTE_OLD->PATH_XML ,		AllTrim(cPath_XML) )
		   	TMPCTE->PROB_EMAIL		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("PROB_EMAIL"))>0, 	TMPCTE_OLD->PROB_EMAIL,		AllTrim(cProbEmail))
		   	TMPCTE->FOR_CANC		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("FOR_CANC"))>0	, 	TMPCTE_OLD->FOR_CANC,		AllTrim(cXmlCancFor))
		   	TMPCTE->DOMINIO			:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("DOMINIO"))>0	, 	TMPCTE_OLD->DOMINIO,		AllTrim(cDominio) )
			TMPCTE->SEM_XML			:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("SEM_XML"))>0	, 	TMPCTE_OLD->SEM_XML,		AllTrim(cSem_XML) )
			TMPCTE->GRV_DIF_A		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("GRV_DIF_A"))>0	, 	TMPCTE_OLD->GRV_DIF_A,		AllTrim(cGrv_Dif_A) )
			TMPCTE->SEGURA    		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("SEGURA"))>0	, 	TMPCTE_OLD->SEGURA,			lSegura )
		   	TMPCTE->TLS				:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("TLS"))>0		, 	TMPCTE_OLD->TLS ,			lTLS )
		   	TMPCTE->PRODXCTE		:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("PRODXCTE"))>0		, 	TMPCTE_OLD->PRODXCTE ,			cProdxCTe )
		   	TMPCTE->TESXCTE			:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("TESXCTE"))>0		, 	TMPCTE_OLD->TESXCTE ,			cTesxCTe  )
		   	If TMPCTE->(FieldPos("ESPXCTE")) > 0
		   		TMPCTE->ESPXCTE			:=	IIF(lNewVersao .And. TMPCTE_OLD->(FieldPos("ESPXCTE"))>0		, 	TMPCTE_OLD->ESPXCTE ,			cEspxCTe  )
		   	EndIf
	   MsUnLock()
	   
       DbSelectArea('SM0')
       DbSkip()
   EndDo

 	If lNewVersao
	   IIF(Select('TMPCTE_OLD') != 0, TMPCTE_OLD->(DbCLoseArea()), )
	EndIf
	
EndIf


//зддддддддддддддддддддддддддддддддд©
//Ё ABRE ARQUIVO DE CONFIGURACAO    |
//юддддддддддддддддддддддддддддддддды
*********************************************
	ExecBlock('OpenArqCfg',.F., .F., {} )
*********************************************


//зддддддддддддддддддддддддддддддддд©                 ADMIN

//Ё        ALIMENTA aConfig   		Ё
//| aConfig == Itens MsNewGetDados	|
//юддддддддддддддддддддддддддддддддды
nRecno := Recno()
DbSelectArea('SM0');DbGoTop()
Do While !Eof()
   DbSelectArea('TMPCTE');DbGoTop()
   If DbSeek(SM0->M0_CODIGO + SM0->M0_CODFIL, .F.)
		cCfgVersao	:= 	TMPCTE->VERSAO
       	cPathTables	:= 	TMPCTE->PATCHTABLE
       	cEmail		:=	TMPCTE->EMAIL
       	cPassword	:=	TMPCTE->SENHA
       	cPOrigem	:=	TMPCTE->PASTA_ORIG
       	cPDestino	:=	TMPCTE->PASTA_DEST
       	cTpMail		:=	TMPCTE->TIPOEMAIL
       	cServerEnv	:=	TMPCTE->SERVERENV
       	cServerRec	:=	TMPCTE->SERVERREC
       	cNFe9Dig	:=	TMPCTE->NFE_9DIG
       	cSer3Dig	:=	TMPCTE->SER_3DIG
       	cSerTransf	:=	TMPCTE->SER_TRANSF
       	cPreDoc		:=	TMPCTE->PRE_DOC
       	cPortRec	:=	TMPCTE->PORTA_REC
       	cPortEnv	:=	TMPCTE->PORTA_ENV    
        lEstrut_Xml	:=	TMPCTE->ESTRUT_ZXC
		lAutent		:=	TMPCTE->AUTENTIFIC
		lSegura		:=	TMPCTE->SEGURA
		lSSL		:=	TMPCTE->SSL
		lTLS		:=	TMPCTE->TLS		
		cPath_XML	:=	TMPCTE->PATH_XML
		cProbEmail	:=	TMPCTE->PROB_EMAIL
		cXmlCancFor	:=	TMPCTE->FOR_CANC
		cDominio	:=	TMPCTE->DOMINIO
		cSem_XML	:=	TMPCTE->SEM_XML
		cGrv_Dif_A	:=	TMPCTE->GRV_DIF_A
		cProdxCTe	:=	TMPCTE->PRODXCTE
		cTesxCTe	:= 	TMPCTE->TESXCTE
		cEspxCTe	:= 	IIF(TMPCTE->(FieldPos("ESPXCTE")) > 0, TMPCTE->ESPXCTE, Space(TamSx3('F1_ESPECIE')[1]) )
		   	
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
		cSem_XML	:=	'NцO'
		cGrv_Dif_A	:=	'SIM'
		cProdxCTe	:=	Space(TamSx3('B1_COD')[1])
		cTesxCTe	:=	Space(TamSx3('B1_TE')[1])
		cEspxCTe	:=	Space(TamSx3('F1_ESPECIE')[1])
		
		
   EndIf                                           

	//здддддддддддддддддддддддддд©
	//Ё      ARRAY aConfig       Ё
	//юдддддддддддддддддддддддддды
   DbSelectArea('SM0')
   Aadd(aConfig, {     SM0->M0_CODIGO,    SM0->M0_NOME,        SM0->M0_CODFIL,    SM0->M0_FILIAL,    SM0->M0_CGC,        SM0->M0_INSC,;    //06
                       SM0->M0_ENDENT,    SM0->M0_COMPENT,    SM0->M0_BAIRENT,    SM0->M0_CIDENT,    SM0->M0_ESTENT,    SM0->M0_CEPENT,;  //12
                       SM0->M0_TEL,        SM0->M0_FAX,        SM0->M0_ENDCOB,    SM0->M0_BAIRCOB,    SM0->M0_CIDCOB,    SM0->M0_ESTCOB,;  //18
                       SM0->M0_CEPCOB,    SM0->M0_CNAE,        SM0->M0_CODMUN,    cTpMail, cPathTables  ,cEmail ,cPassword ,cPOrigem,cPDestino,;//27
                       cServerEnv,  cNFe9Dig,cSer3Dig,cSerTransf,cPreDoc, cPortEnv,cPortRec, lAutent , lSSL , cPath_XML,;	//	37
                       cProbEmail,  cXmlCancFor, cDominio, cSem_XML, cGrv_Dif_A, lSegura, lTLS, cServerRec, cProdxCTe, cTesxCTe, cEspxCTe, .F. })    // 48 + .F.
	DbSkip()
EndDo

DbGoTo(nRecno)


//здддддддддддддддддддддддддд©
//Ё   TELA DE CONFIGURACAO   Ё
//юдддддддддддддддддддддддддды
oFont1     := TFont():New( "Arial",0,IIF(nHRes<=800,-10,-12),,.T.,0,,700,.F.,.F.,,,,,, )
oFont2     := TFont():New( "Arial",0,IIF(nHRes<=800,-15,-17),,.T.,0,,700,.F.,.F.,,,,,, )
oFont3     := TFont():New( "Arial",0,IIF(nHRes<=800,-08,-10),,.T.,0,,700,.F.,.F.,,,,,, )

oDlgSM0    := MSDialog():New( D(050),D(050),D(485),D(720),"ConfiguraГЦo Empresas ImportaГЦo XML",,,.F.,,,,,,.T.,,oFont1,.T. )

oGrp1      := TGroup():New( D(004),D(004),D(088),D(330),"",oDlgSM0,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBrwSM0    := MsNewGetDados():New( D(010),D(008),D(084),D(320),GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','',,0,999,,'','AllwaysTrue()',oGrp1,aMyHeader,aConfig )


                              
//здддддддддддддддддддддддддд©
//Ё   	    FOLDERs			 Ё
//юдддддддддддддддддддддддддды
oFolder    := TFolder():New( D(092),D(008),{"Config. Empresa","Config. XML CT-e.","Config. e-mail"},{},oGrp1,,,,.T.,.F.,D(320),D(108),)
oFolder:bSetOption	:=	{|| IIF(oFolder:nOption==1, oGetPrd:SetFocus(), IIF(oFolder:nOption==2, oCBox9:SetFocus(), oCBox14:SetFocus()))}



//здддддддддддддддддддддддддд©
//Ё     CONFIG.EMPRESA       Ё
//юдддддддддддддддддддддддддды
//[ EMPRESA \ FILIAL ]
oSay1NomeFil := TSay():New( D(004),D(008),{|| Alltrim(aConfig[oBrwSM0:nAT][02])+' \ '+AllTrim(aConfig[oBrwSM0:nAT][04]) },oFolder:aDialogs[1],,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(150),D(008) )

oGrp2      := TGroup():New( D(012),D(006),D(095),D(170),"Config. Empresa",oFolder:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )


cToolTip  := 'Informar a quantidade de horas, conforme a SEFAZ de cada estado determina, para possibilitar o cancelamento da NFe.'+ENTER
cToolTip  += 'ParБmetro utilizado para verificar se fornecedor cancelou o XML.'+ENTER
cToolTip  += 'Caso o XML esteje Importado\Gravado, e o fornecedor cancelou o XML ANTES desse perМodo, И enviado um e-mail,'+ENTER
cToolTip  += 'para determinado(s) usuАrio(s) informando o cancelamento (e-mail disparado pelo workflow).'+ENTER
cToolTip  += 'ParБmetro MV_SPEDEXC.'
oSay1  := TSay():New( D(020),D(008),{||"Num. Horas Canc.XML"},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(100),D(008) )
oGet1  := TGet():New( D(026),D(008),{|u| If(PCount()>0,nHoraCanc:=u,nHoraCanc)},oFolder:aDialogs[1],D(060),D(008),'',/*{||PutMv( 'XM_SPEDEXP', nHoraCanc)}*/,CLR_HGRAY,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)
oGet1:Disable()
                            

cToolTip  := 'Caminho dos arquivos XML.'+ENTER+'Utilizado na opГЦo de carregar XML para selecionar o diretСrio.'
oSay2  := TSay():New( D(020),D(070),{||"Caminho arq. XML"},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(100),D(008) )
oBtn2  := TButton():New( D(026),D(160),"...",oFolder:aDialogs[1],{|| cPath_XML  := cGetFile("Anexos (*xml)|*xml|","Arquivos (*xml)",0,'',.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_MULTISELECT+GETF_RETDIRECTORY), aConfig[oBrwSM0:nAT][37]:= AllTrim(cPath_XML), cPath_XML+=Space(100), oGet2:Refresh() },D(010),D(010),,,,.T.,,"",,,,.F. )
oGet2  := TGet():New( D(026),D(070),{|u| If(PCount()>0,cPath_XML:=u,cPath_XML)},oFolder:aDialogs[1],D(090),D(008),'',{|| aConfig[oBrwSM0:nAT][37]:= AllTrim(cPath_XML), cPath_XML+=Space(100),oGet2:Refresh() },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)

cToolTip:= ''
cDescProd:=''
oSayProd:= TSay():New( D(048),D(070),{|| cDescProd  },oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,D(080),D(008) )
oSay3 	 := TSay():New( D(040),D(008),{|| "Produto X CT-e" },oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008) )
oGetPrd := TGet():New( D(046),D(008),{|u| If(PCount()>0,cProdxCTe:=u,cProdxCTe)},oFolder:aDialogs[1],D(060),D(008),'', {|| aConfig[oBrwSM0:nAT][46]:=cProdxCTe, oGetPrd:Refresh(), cDescProd:=AllTrim(Posicione('SB1',1,xFilial('SB1')+ cProdxCTe ,'B1_DESC')),oSayProd:Refresh() }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"SB1","",,)


cToolTip:= ''
cDescTES:=''
oSayTes := TSay():New( D(068),D(070),{|| cDescTES  },oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,D(080),D(008) )
oSay3 	:= TSay():New( D(060),D(008),{|| "TES X CT-e" },oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008) )
oGetTes := TGet():New( D(066),D(008),{|u| If(PCount()>0,cTesxCTe:=u,cTesxCTe)},oFolder:aDialogs[1],D(060),D(008),'', {|| aConfig[oBrwSM0:nAT][47]:=cTesxCTe, oGetTes:Refresh(), cDescTES:=Left(AllTrim(Posicione('SF4',1,xFilial('SF4')+ cTesxCTe ,'F4_TEXTO')),50),oSayProd:Refresh() }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"SF4","",,)
		
oSay6	:= TSay():New( D(078),D(008),{|| 'PrИ\Doc com Status <> Aprovado?' },oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(100),D(008) )
oCBox6  	:= TComboBox():New( D(084),D(008),{|u| If(PCount()>0,cGrv_Dif_A:=u,cGrv_Dif_A)},{"SIM","NцO"},D(060),D(012),oFolder:aDialogs[1],,,{|| aConfig[oBrwSM0:nAT][42]:=cGrv_Dif_A },CLR_BLACK,CLR_WHITE,.T.,oFont1,"",,,,,,, )
cToolTip := 'Grava PrИ-Nota\Doc.Entrada com Status <> Aprovado\Cancelado?'+ENTER+'Caso ocorra problema na consulta do XML na SEFAZ e nЦo retornar nenhum status И possivel incluir a PrИ-Nota\Doc.Entrada.'
oCBox6:cToolTip := cToolTip


oGrp3      := TGroup():New( D(012),D(176),D(095),D(312),"Recebem E-mail quando...",oFolder:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )

cToolTip  := 'Quando И disparado um e-mail e ocorre algum problema (e-mail destinatАrio invАlido),'+ENTER
cToolTip  += 'И possМvel enviar um e-mail, para determinado(s) usuАrio(s), e informar que o e-mail nЦo foi enviado para o(s) destinatАrio(s).'+ENTER
cToolTip  += 'Ex.: Ao recusar um XML e enviado um e-mail ao fornecedor e ocorrer algum erro no envio.'+ENTER
cToolTip  += 'Obs.: colocar apenas o nome da conta sem @. Coloque ";" para adicionar mais contas.'
oSay7  := TSay():New( D(020),D(180),{||"Ocorrer problema no envio dos e-mails"},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(170),D(008) )
oGet7  := TGet():New( D(026),D(180),{|u| If(PCount()>0,cProbEmail:=u,cProbEmail)},oFolder:aDialogs[1],D(130),D(008),'',{|| aConfig[oBrwSM0:nAT][38]:= AllTrim(cProbEmail), cProbEmail+=Space(100), oGet7:Refresh()  /*PutMv( 'XM_ADMIN_E', cProbEmail )*/  },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)

cToolTip  := 'Conta de e-mail do(s) usuАrio(s) para receber e-mail informando que XML foi cancelado pelo fornecedor.'
cToolTip  += 'Obs.: colocar apenas o nome da conta sem @. Coloque ";" para adicionar mais contas.'
oSay8  := TSay():New( D(040),D(180),{||"Fornecedor cancelar XML antes do prazo"},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(170),D(008) )
oGet8  := TGet():New( D(046),D(180),{|u| If(PCount()>0,cXmlCancFor:=u,cXmlCancFor)},oFolder:aDialogs[1],D(130),D(008),'',{|| aConfig[oBrwSM0:nAT][39]:= AllTrim(cXmlCancFor), cXmlCancFor+=Space(100),oGet8:Refresh() /*PutMv( 'XM_XMLCANC', cEmailCancXML )*/ },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)

cToolTip  := 'DomМnio da Empresa.'+ENTER+'Utilizado para enviar e-mail.'+ENTER
cToolTip  += 'Ex.: colocar empresaXYZ.com.br sem o nome da conta, sem @.'
oSay9  := TSay():New( D(060),D(180),{||"Dominio Empresa"},oFolder:aDialogs[1],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(170),D(008) )
oGet9  := TGet():New( D(066),D(180),{|u| If(PCount()>0,cDominio:=u,cDominio)},oFolder:aDialogs[1],D(130),D(008),'',{|| aConfig[oBrwSM0:nAT][40]:= AllTrim(cDominio), cXmlCancFor+=Space(100),oGet9:Refresh() },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)



//здддддддддддддддддддддддддд©
//Ё   CONFIG. FORNECEDOR	 |
//юдддддддддддддддддддддддддды
//[ EMPRESA \ FILIAL ]
oSay2NomeFil := TSay():New( D(004),D(008),{|| Alltrim(aConfig[oBrwSM0:nAT][02])+' \ '+AllTrim(aConfig[oBrwSM0:nAT][04]) },oFolder:aDialogs[2],,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(150),D(008) )

oGrp4      := TGroup():New( D(012),D(006),D(075),D(170),"XML CT-e",oFolder:aDialogs[2],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay9      := TSay():New( D(020),D(008),{||"Nota com 9 DМgitos"},oFolder:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oCBox9  := TComboBox():New( D(026),D(008),{|u| If(PCount()>0,cNFe9Dig:=u,cNFe9Dig)},{"SIM","NцO"},076,012,oFolder:aDialogs[2],,,{|| aConfig[oBrwSM0:nAT][29]:=cNFe9Dig },CLR_BLACK,CLR_WHITE,.T.,oFont1,"Nota com 9 Digitos",,,,,,, )
oCBox9:cToolTip := 'Completa com "0" Zeros o restante dos caracteres da Pre-Nota\Doc.Entrada.'

oSayS10  := TSay():New( D(020),D(070),{|| "SИrie com 3 DМgitos"},oFolder:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008) )
oCBox10  := TComboBox():New( D(026),D(070),{|u| If(PCount()>0,cSer3Dig:=u,cSer3Dig)},{"SIM","NцO"},076,012,oFolder:aDialogs[2],,,{|| aConfig[oBrwSM0:nAT][30]:=cSer3Dig },CLR_BLACK,CLR_WHITE,.T.,oFont1,"SИrie com 3 Digitos",,,,,,, )
oCBox10:cToolTip := 'Completa com "0" Zeros o restante dos caracteres da Pre-Nota\Doc.Entrada.'


oSay11   := TSay():New( D(040),D(008),{|| "SИrie CTe" },oFolder:aDialogs[2],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oGet11   := TGet():New( D(046),D(008),{|u| If(PCount()>0,cEspXCTe:=u,cEspXCTe)},oFolder:aDialogs[2],076,012,'',{|| aConfig[oBrwSM0:nAT][48]:=cEspXCTe },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"Informe a Especie do Documento de Entrada"+ENTER+"SPED, CTE, CTR....",,,.F.,.F.,,.F.,.F.,"","cEspXCTe",,)



//здддддддддддддддддддддддддд©
//Ё      CONFIG. EMAIL       Ё
//юдддддддддддддддддддддддддды
//	[ EMPRESA \ FILIAL  ]
oSay3NomeFil := TSay():New( D(004),D(008),{|| Alltrim(aConfig[oBrwSM0:nAT][02])+' \ '+AllTrim(aConfig[oBrwSM0:nAT][04]) },oFolder:aDialogs[3],,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(150),D(008) )



oGrp5      := TGroup():New( D(012),D(006),D(095),D(315),"",oFolder:aDialogs[3],CLR_BLACK,CLR_WHITE,.T.,.F. )

oCBox11 := TCheckBox():New( D(014),D(142),"AutentificaГЦo?",{|u| If(PCount()>0,lAutent:=u,lAutent)},oFolder:aDialogs[3],D(068),D(008),,		{|| aConfig[oBrwSM0:nAT][35]:= lAutent 	},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox11:cToolTip := 'Utiliza AutentificaГЦo ?'
oCBox12    := TCheckBox():New( D(014),D(215),"ConexЦo segura?",{|u| If(PCount()>0,lSegura:=u,lSegura)},oFolder:aDialogs[3],D(088),D(008),,	{|| aConfig[oBrwSM0:nAT][43]:= lSegura, PortPadrao(), IIF(lSegura,(oCBox12b:Show(),oCBox12c:Show()),(oCBox12b:Hide(),oCBox12c:Hide()) ),(lSSL:=.F.,aConfig[oBrwSM0:nAT][36]:=.F.,lTLS:=.F.,aConfig[oBrwSM0:nAT][44]:=.F.), oGet21:Refresh(), oGet20:Refresh()	},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox12:cToolTip := 'Utiliza conex"ao segura ?'

oCBox12b    := TCheckBox():New( D(014),D(275),"SSL",{|u| If(PCount()>0,lSSL:=u,lSSL)},oFolder:aDialogs[3],D(088),D(008),,{|| IIF( !VerBuild(),lSSL:=.F., (PortPadrao(), IIF(lSSL,lTLS:=.F.,IIF(lSSL,lSSL:=.F.,lSSL:=.T.)), aConfig[oBrwSM0:nAT][36]:= lSSL, oCBox12b:Refresh(), oCBox12c:Refresh(), oGet21:Refresh(), oGet20:Refresh()) )},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox12c    := TCheckBox():New( D(014),D(295),"TLS",{|u| If(PCount()>0,lTLS:=u,lTLS)},oFolder:aDialogs[3],D(088),D(008),,{|| IIF( !VerBuild(),lTLS:=.F., (PortPadrao(), IIF(lTLS,lSSL:=.F.,IIF(lTLS,lTLS:=.F.,lTLS:=.T.)), aConfig[oBrwSM0:nAT][44]:= lTLS, oCBox12b:Refresh(), oCBox12c:Refresh(), oGet21:Refresh(), oGet20:Refresh()) )},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )

oSay13  := TSay():New( D(022),D(008),{||"Path Table"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(060),D(008) )
oGet13  := TGet():New( D(028),D(008),{|u| If(PCount()>0,cPathTables:=u,cPathTables)},oFolder:aDialogs[3],D(060),D(008),'',{|| aConfig[oBrwSM0:nAT][23]:=cPathTables },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"Path Table - DiretСrio onde esta localizado os arquivos SX╢s",,,.F.,.F.,,.F.,.F.,"","cPathTables",,)


oSay14:= TSay():New( D(022),D(075),{||"Protocolo de E-mail"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008))
oCBox14  := TComboBox():New( D(028),D(075),{|u| If(PCount()>0,cTpMail:=u,cTpMail)},{"POP","IMAP","MAPI"},D(060),D(012),oFolder:aDialogs[3],,,{|| PortPadrao(), aConfig[oBrwSM0:nAT][22]:=cTpMail, IIF(cTpMail=='IMAP',(oGet18:Enable(),oGet18:SetColor(CLR_BLACK,CLR_WHITE)),(oGet18:Disable(),aConfig[oBrwSM0:nAT][27]:=cPDestino:=Space(100),oGet18:SetColor(CLR_BLACK,CLR_HGRAY)) ), oGet18:Refresh() },CLR_BLACK,CLR_WHITE,.T.,oFont1,"",,,,,,, )
oCBox14:cToolTip := 'Indica o protocolo de e-mail que serА usado para envio de e-mail.'

cToolTip   := 'O parБmetro permite informar a conta de e-mail que serА acessada. '+ENTER
cToolTip   += 'No entanto, dependendo da configuraГЦo do servidor, И necessАrio informar'+ENTER
cToolTip   += 'a conta de e-mail completa (usuario@provedor.com.br) ou apenas o nome do usuАrio.
oSay15  := TSay():New( D(022),D(142),{|| "E-mail"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oGet15  := TGet():New( D(028),D(142),{|u| If(PCount()>0,cEmail:=u,cEmail) },oFolder:aDialogs[3],D(125),D(008),'', {|| aConfig[oBrwSM0:nAT][24]:=cEmail }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)

oSay16  := TSay():New( D(022),D(270),{||"Senha"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008))                                                                                                         //.T.== ****
oGet16  := TGet():New( D(028),D(270),{|u| If(PCount()>0,cPassword:=u,cPassword)},oFolder:aDialogs[3],D(045),D(008),'',{|| aConfig[oBrwSM0:nAT][25]:=cPassword },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"Senha da conta de e-mail",,,.F.,.F.,,.F.,.T.,"","",,)

cToolTip   := 'Pasta de Origem.'+ENTER+'Onde o programa irА LER os e-mails e buscar os XML╢s.'+ENTER
oSay17  := TSay():New( D(042),D(008),{|| "Pasta Origem E-mail"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008))
oGet17  := TGet():New( D(048),D(008),{|u| If(PCount()>0,cPOrigem:=u,cPOrigem) },oFolder:aDialogs[3],D(060),D(008),'', {|| aConfig[oBrwSM0:nAT][26]:=cPOrigem }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)

cToolTip   := 'Pasta de Destino.'+ENTER+'Onde o programa irА MOVER os e-mails apСs importa-los para o sistema. '+ENTER+'OpГЦo apenas para Protocolo IMAP.'
oSay18  := TSay():New( D(042),D(075),{|| "Pasta Destino E-mail"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008) )
oGet18  := TGet():New( D(048),D(075),{|u| If(PCount()>0,cPDestino:=u,cPDestino) },oFolder:aDialogs[3],D(060),D(008),'', {|| aConfig[oBrwSM0:nAT][27]:=cPDestino, oGet18:Refresh() }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,cToolTip,,,.F.,.F.,,.F.,.F.,"","",,)


	//зддддддддддддддддддддд©
	//Ё  SERVIDOR DE ENVIO  Ё
	//юддддддддддддддддддддды
oSay19 := TSay():New( D(042),D(142),{|| "Servidor de Envio"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oGet19 := TGet():New( D(048),D(142),{|u| If(PCount()>0,cServerEnv:=u,cServerEnv) },oFolder:aDialogs[3],D(125),D(008),'', {|| aConfig[oBrwSM0:nAT][28]:=cServerEnv }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,'Indica o endereГo ou alias do servidor de e-mail IMAP/POP/MAPI/SMTP.',,,.F.,.F.,,.F.,.F.,"","",,)

oSay20  := TSay():New( D(042),D(270),{||"Porta SMTP" },oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oGet20  := TGet():New( D(048),D(270),{|u| If(PCount()>0,cPortEnv:=u,cPortEnv)},oFolder:aDialogs[3],D(020),D(008),'',{|| aConfig[oBrwSM0:nAT][33]:= cPortEnv },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,'Indica a porta de comunicaГЦo para conexЦo IMAP/POP/MAPI/SMTP.',,,.F.,.F.,,.F.,.F.,"","",,)


	//зддддддддддддддддддддддддддд©
	//Ё  SERVIDOR DE RECEBIMENTO  Ё
	//юддддддддддддддддддддддддддды
oSay19b := TSay():New( D(060),D(142),{|| "Servidor de Recebimento"},oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(088),D(008))
oGet19b := TGet():New( D(066),D(142),{|u| If(PCount()>0,cServerRec:=u,cServerRec) },oFolder:aDialogs[3],D(125),D(008),'', {|| aConfig[oBrwSM0:nAT][45]:=cServerRec }, CLR_BLACK,CLR_WHITE,oFont1,,,.T.,'Indica o endereГo ou alias do servidor de e-mail IMAP/POP/MAPI/SMTP.',,,.F.,.F.,,.F.,.F.,"","",,)

oSay21  := TSay():New( D(060),D(270),{||"Porta " + aConfig[oBrwSM0:nAT][22] },oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oGet21  := TGet():New( D(066),D(270),{|u| If(PCount()>0,cPortRec:=u,cPortRec)},oFolder:aDialogs[3],D(020),D(008),'',{|| aConfig[oBrwSM0:nAT][34]:= cPortRec },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,'Indica a porta de comunicaГЦo para conexЦo SMTP (PadrЦo 25).',,,.F.,.F.,,.F.,.F.,"","",,)


oCBox22b    := TCheckBox():New( D(070),D(010),"Envio",{|u| If(PCount()>0,lTesteE:=u,lTesteE)},oFolder:aDialogs[3],D(088),D(008),,	{|| IIF(lTesteE, lTesteR:=.F.,), (cConect:='',oOkConect:Refresh(),oNoConect:Refresh()), oCBox22b:Refresh(),oCBox22c:Refresh() },,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox22c    := TCheckBox():New( D(070),D(030),"Recebimento",{|u| If(PCount()>0,lTesteR:=u,lTesteR)},oFolder:aDialogs[3],D(088),D(008),,	{|| IIF(lTesteR, lTesteE:=.F.,), (cConect:='',oOkConect:Refresh(),oNoConect:Refresh()), oCBox22b:Refresh(),oCBox22c:Refresh() 	},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oBtnTest    := TButton():New( D(080),D(008),"Testar ConexЦo",oFolder:aDialogs[3],{|| IIF(lTesteE.Or.lTesteR, MsgRun('Testando ConexЦo...', 'Aguarde... ',{|| cConect := TestConect(IIF(lTesteE,'E','R')), IIF(cConect=='Conectado com Sucesso',(oOkConect:Show(),oNoConect:Hide()),(oNoConect:Show(),oOkConect:Hide())) }), MsgInfo('Marque uma opГЦo - Envio ou Recebimento')) },D(057),D(012),,oFont3,,.T.,,"",,,,.F. )

oOkConect  := TSay():New( D(085),D(070),{|u| If(PCount()>0,cConect:=u,cConect) },oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(200),D(008) )
oNoConect  := TSay():New( D(085),D(070),{|u| If(PCount()>0,cConect:=u,cConect) },oFolder:aDialogs[3],,oFont1,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE, D(200),D(008) )
oOkConect:Hide()
oNoConect:Hide()



//здддддддддддддддддддддддддд©
//Ё  BOTOES OK - CANCELA     Ё
//юдддддддддддддддддддддддддды
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
//зддддддддддддддддддддддддддддддддд©
//Ё	   VERIFICA VERSAO DA BUILD		Ё
//юддддддддддддддддддддддддддддддддды
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
//зддддддддддддддддддддддддддддддддд©
//Ё	   INFORMA A PARTA PADRAO  		Ё
//юддддддддддддддддддддддддддддддддды
cPortEnv	:=	'25 '

If Left(cTpMail,3) =='POP'
	cPortRec	:=	IIF(!lSegura,'587','995')
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
//зддддддддддддддддддддддддддддддддддддддддд©
//Ё	 BUSCA NO SX6 O PARAMETRO MV_ESPECIE	Ё
//Ё	 E SEPARA APENAS AS SERIES == SPED  	Ё
//юддддддддддддддддддддддддддддддддддддддддды
Local lSX6 	:= .F.


If File(_StartPath+'SX6'+SM0->M0_CODIGO+'0.'+Right(__LocalDriver,3))

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
	IIF(Select('SX6') != 0, SX6->(DbCLoseArea()), )
	DbUseArea(.T.,,_StartPath+'SX6'+cFilAnt+'0', 'SX6',.T.,.F.)
EndIf

Return()
***********************************************************************
Static Function AtuGets()
***********************************************************************
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё ATUALIZA aConfig QDO TROCAR DE LINHA DO BROWSER DE CONFIG.             Ё
//Ё Chamada -> TelaConfig()                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

// [Config.Empresa]
cPath_XML		:=	aConfig[oBrwSM0:nAT][37]; oGet2:Refresh()
//cSerTransf    	:=	aConfig[oBrwSM0:nAT][31]; oGet3:Refresh()
//cPreDoc         :=	aConfig[oBrwSM0:nAT][32]; oCBox4:Refresh()
//cSem_XML		:=	aConfig[oBrwSM0:nAT][41]; oCBox5:Refresh()
cGrv_Dif_A		:=	aConfig[oBrwSM0:nAT][42]; oCBox6:Refresh()
cProbEmail		:=	aConfig[oBrwSM0:nAT][38]; oGet7:Refresh()
cXmlCancFor		:=	aConfig[oBrwSM0:nAT][39]; oGet8:Refresh()
cDominio		:=	aConfig[oBrwSM0:nAT][40]; oGet9:Refresh()

cProdxCTe		:=	aConfig[oBrwSM0:nAT][46]; oGetPrd:Refresh()
cDescProd		:=	AllTrim(Posicione('SB1',1,xFilial('SB1')+ cProdxCTe ,'B1_DESC'))
oSayProd:Refresh()

cTesxCTe		:=	aConfig[oBrwSM0:nAT][47]; oGetTes:Refresh()
cDescTes		:=	Left(AllTrim(Posicione('SF4',1,xFilial('SF4')+ cTesxCTe ,'F4_TEXTO')),70)
oSayTes:Refresh()
                                                                  

// [Config.XML Fornecedor]
cNFe9Dig       	:=	aConfig[oBrwSM0:nAT][29]; oCBox9:Refresh()
cSer3Dig       	:=	aConfig[oBrwSM0:nAT][30]; oCBox10:Refresh()
cEspxCTe		:=	aConfig[oBrwSM0:nAT][48]; oGet11:Refresh()

    
   
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

oSay1NomeFil:Refresh()
oSay2NomeFil:Refresh()
oSay3NomeFil:Refresh()

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
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё ATUALIZA ARQUIVO DE CONFIGURACAO (CTE_CFG.DBF)                         Ё
//Ё Chamada -> TelaConfig()                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()    //    EMPRESA+FILIAL
For nX:=1 To Len(aConfig)
	If DbSeek(aConfig[nX][01]+aConfig[nX][03],.F.)
		RecLock('TMPCTE',.F.)
			//	[Config.Empresa]                   
			TMPCTE->PATH_XML	:=	AllTrim(aConfig[nX][37])
			TMPCTE->SER_TRANSF	:=	AllTrim(aConfig[nX][31])
			TMPCTE->PRE_DOC		:=	AllTrim(aConfig[nX][32])
			TMPCTE->SEM_XML		:=	AllTrim(aConfig[nX][41])
			TMPCTE->GRV_DIF_A	:=	AllTrim(aConfig[nX][42])
			TMPCTE->PROB_EMAIL	:=	AllTrim(aConfig[nX][38])
			TMPCTE->FOR_CANC	:=	AllTrim(aConfig[nX][39])
			TMPCTE->DOMINIO		:=	AllTrim(aConfig[nX][40])
			TMPCTE->PROB_EMAIL	:=	AllTrim(aConfig[nX][38])
			TMPCTE->PRODXCTE	:=	AllTrim(aConfig[nX][46])
			TMPCTE->TESXCTE		:=	AllTrim(aConfig[nX][47])
			If TMPCTE->(FieldPos("ESPXCTE")) > 0  
				TMPCTE->ESPXCTE		:=	AllTrim(aConfig[nX][48])
			EndIf
			
			//	Config.XML Fornecedor]
			TMPCTE->NFE_9DIG	:=	AllTrim(aConfig[nX][29])
			TMPCTE->SER_3DIG	:=	AllTrim(aConfig[nX][30])
			
			// [Config.e-mail]
			TMPCTE->AUTENTIFIC	:=	aConfig[nX][35]
			TMPCTE->SEGURA		:=	aConfig[nX][43]
			TMPCTE->PATCHTABLE	:=	AllTrim(aConfig[nX][23])
			TMPCTE->TIPOEMAIL	:=	AllTrim(aConfig[nX][22])
			TMPCTE->EMAIL		:=	AllTrim(aConfig[nX][24])
			TMPCTE->SENHA		:=	AllTrim(aConfig[nX][25])
			TMPCTE->PASTA_ORIG	:=	AllTrim(aConfig[nX][26])
			TMPCTE->PASTA_DEST	:=	AllTrim(aConfig[nX][27])
			TMPCTE->SERVERREC	:=	AllTrim(aConfig[nX][45])			
			TMPCTE->SERVERENV	:=	AllTrim(aConfig[nX][28])
			TMPCTE->PORTA_REC	:=	AllTrim(aConfig[nX][34])
			TMPCTE->PORTA_ENV	:=	AllTrim(aConfig[nX][33])
			TMPCTE->SSL 		:=	aConfig[nX][36]
			TMPCTE->TLS    		:=	aConfig[nX][44]			

		MsUnLock()
	Endif
   DbSelectArea('TMPCTE');DbGoTop()
Next

Return()
***********************************************************************
Static Function TestConect()
***********************************************************************
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё TESTA SE CONFIGURACAO DE EMAIL, SENHA, SERVIDOR ESTAO CORRETAS         Ё
//Ё Chamada -> TelaConfig()                                                |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cRetorno    :=	''
nNumMsg		:=	0
cTpConexao	:=	AllTrim(aConfig[oBrwSM0:nAT][22])   
lAutent		:=	aConfig[oBrwSM0:nAT][35]
lSegura		:=	aConfig[oBrwSM0:nAT][43] 
lSSL		:=	aConfig[oBrwSM0:nAT][36] 
lTLS 		:=	aConfig[oBrwSM0:nAT][44]

oServer    :=    TMailManager():New()

If lSegura .And. lTesteR
	oServer:SetUseSSL(lSSL)					//		Define o envio de e-mail utilizando uma comunicaГЦo segura atravИs do SSL - Secure Sockets Layer.
	oServer:SetUseTLS(lTLS)					//		Define no envio de e-mail o uso de STARTTLS durante o protocolo de comunicaГЦo.
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



//зддддддддддддддддддддддддддддддд©
//Ё	CONEXAO DE ENVIO == SMTP      Ё
//юддддддддддддддддддддддддддддддды
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
User Function CTe_Visual() 
*****************************************************************
//здддддддддддддддддддддддддддддддддддд©
//Ё ABRE XML NO BROSWER                Ё
//Ё Chamada -> Rotina Visualizar       Ё
//юдддддддддддддддддддддддддддддддддддды
Local   aArea3		:= GetArea()
Local   lRetorno	:=	.F.
Local	lValidDlg	:=	.T.
Local	aEditCpo	:=	{}                                                                                                                              
Local   cTpFrete	:=	ParamIxb[01]

Private	aMyHeader	:=  {}
Private aMyCols    	:=  {}
Private aProdxFor   :=  {}
Private bSavDblClick:=	Nil
Private lGravado    := 	.F.
Private cVTPrest   	:=	0
Private cXMLStatus  :=	''
Private aClixFor	:=	{}	
Private cMsgDevRet 	:= ''
Private cMsgF10		:= ''

PRIVATE aHeader 	:=	{}
PRIVATE aCols   	:=	{}
PRIVATE cTipo  		:=	'N'
PRIVATE cA100For	:= 	ZXC->ZXC_FORNEC
PRIVATE cLoja    	:=	ZXC->ZXC_LOJA
PRIVATE cNFiscal	:=	ZXC->ZXC_DOC
PRIVATE cSerie    	:= 	ZXC->ZXC_SERIE
PRIVATE cEspecie	:=	'SPED'
PRIVATE cFormul   	:=	'N'
PRIVATE cCondicao 	:= 	''
PRIVATE cForAntNFE	:= 	''
PRIVATE dDEmissao	:= 	dDataBase
PRIVATE n			:= 	1
PRIVATE nMoedaCor	:= 	1
PRIVATE L103AUTO 	:=	.F.
PRIVATE nCBoxFret	:=	0
Private cMsgF10		:= ''

Static aNFeDev 	 	:=  {}
Static aXMLOriginal	:= 	{}
Static cTpFormul 	:= 	''
Static oCBoxFret
Static oSayNFOrig

SetPrvt('oDlgV','oGrp1','oSay7','oSay10','oSay8','oSay9','oSay11','oSay12','oSay13','oSay14','oSay15','oSay16','oSay17')
SetPrvt('oSay18','oGrp2','oSayNF','oSayNFSeri','oSay1','oSay2','oSay3','oSay4','oSay5','oSay6','oSay71','oSay8','oGrp3')
SetPrvt('oBtn1','oBtn2','oBtn6SA1','oBtn4SA1','oBtn4SA2','oBtn4SA2','oBtnPreDoc','oBtn5','oSayF6','oSayStatus','oBrwV','oBtnPC')
SetPrvt('oSayDevRet')

oFont1    := TFont():New( "Arial",0,IIF(nHRes<=800,-12,-13),,.T.,0,,700,.F.,.F.,,,,,, )
oFont2    := TFont():New( "Arial",0,IIF(nHRes<=800,-14,-16),,.T.,0,,700,.F.,.F.,,,,,, )
oFont3    := TFont():New( "Arial",0,IIF(nHRes<=800,-17,-19),,.T.,0,,700,.F.,.F.,,,,,, )
oFont0    := TFont():New( "Arial",0,IIF(nHRes<=800,-09,-11),,.F.,0,,400,.F.,.F.,,,,,, )
oFontP    := TFont():New( "Arial",0,IIF(nHRes<=800,-08,-10),,.F.,0,,400,.F.,.F.,,,,,, )


//зддддддддддддддддддддддддддддддддд©
//Ё  ABRE ARQUIVO DE CONFIGURACAO   |
//юддддддддддддддддддддддддддддддддды
*********************************************
	ExecBlock('OpenArqCfg',.F., .F., {} )
*********************************************

//	aMyHeader = CABEC do MsNewGetDados
DbSelectArea('SX3');DbSetOrder(2);DbGoTop()
DbSeek('D1_ITEM'   ); 	Aadd(aMyHeader,{ 'Item  ',           X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, '', X3_USADO, X3_TIPO, X3_F3      })
DbSeek('D1_COD'    ); 	Aadd(aMyHeader,{ Trim(X3_TITULO),    X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, '', X3_USADO, X3_TIPO, 'SB1'      })
DbSeek('B1_DESC'   ); 	Aadd(aMyHeader,{ Trim(X3_TITULO),    X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, '', X3_USADO, X3_TIPO, X3_F3      })

//	Campos para EDICAO do MsNewGetDados
Aadd( aEditCpo,	'D1_COD')
Aadd( aEditCpo,	'D1_NFORI')	
Aadd( aEditCpo,	'D1_SERIORI')	
Aadd( aEditCpo,	'D1_ITEMORI')	



			
//	aMyHeader == TODO O SX3 DO SD1
DbSelectArea('SX3');DbSetOrder(1);DbGoTop()
DbSeek('SD101', .F.) 
Do While !Eof() .And. SX3->X3_ARQUIVO == 'SD1'
    
    If 	!(AllTrim(SX3->X3_CAMPO) $ 'D1_FILIAL#D1_ITEM#D1_COD') .And. AllTrim(SX3->X3_CAMPO) != 'D1_DESCR'.And.;
		  X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		
		If Ascan(aMyHeader, {|X| X[2] == Trim(SX3->X3_CAMPO) } ) == 0 
		
			Aadd(aMyHeader,{ Trim(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE,;
							  SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3 })
							  
			Aadd( aEditCpo,	AllTrim(SX3->X3_CAMPO))	// CAMPOS PARA EDICAO NO MSNEWGETDADOS
	
			nSX3Recno := SX3->(Recno())
			If AllTrim(SX3->X3_CAMPO) == 'D1_TES' 
				DbSelectArea('SX3');DbSetOrder(2)
				DbSeek('D1_NFORI');   Aadd(aMyHeader,{ Trim(X3_TITULO),    X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, '', X3_USADO, X3_TIPO, X3_F3 })
				DbSeek('D1_SERIORI'); Aadd(aMyHeader,{ Trim(X3_TITULO),    X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, '', X3_USADO, X3_TIPO, X3_F3 })
				DbSeek('D1_ITEMORI'); Aadd(aMyHeader,{ Trim(X3_TITULO),    X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, '', X3_USADO, X3_TIPO, X3_F3 })						
				DbSelectArea('SX3');DbSetOrder(1)
				DbGoTo(nSX3Recno)
			EndIf
		
		EndIf

	EndIf
	
	DbSkip()
EndDo


DbSelectArea('ZXC')

   ***************************************************************************************
       Processa ({|| CarregaACols(.T.)  },'Aguarde Carregando CT-e',  'Processando...', .T.)    //    [3.1]
   ***************************************************************************************



//здддддддддддддддддддддддддддддддддддддддддддд©
//Ё	VERIFICA STATUS DO XML IMPORTADO           Ё
//юдддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea('ZXC')
Do Case
	Case ZXC->ZXC_SITUAC == 'C'
	   cXMLStatus    :=    'Status CT-e: CANCELADO NA SEFAZ'
	Case ZXC->ZXC_STATUS == 'G'
	       cXMLStatus    :=  'Status CT-e: DOC.ENTRADA GRAVADO' //+IIF(lGravado, "DOC.ENTRADA GRAVADO", '')
	       lGravado 	 := .T.
	Case ZXC->ZXC_STATUS == 'I'
	       cXMLStatus    :=    'Status CT-e: IMPORTADO'
	Case ZXC->ZXC_STATUS == 'X'
	       cXMLStatus    :=    'Status CT-e: CANCELADO'
	Case ZXC->ZXC_STATUS == 'R'
	       cXMLStatus    :=    'Status CT-e: RECUSADO'
	Case Empty(ZXC->ZXC_SITUAC)
		cXMLStatus    :=    'Status CT-e invАlido. NЦo houve retorno da SEFAZ.'
EndCase


SA2->(DbSetOrder(3),DbGoTop(),DbSeek(xFilial('SA2')+ ZXC->ZXC_CGC, .F.) )
SA2Recno :=    SA2->(Recno())


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё	                      TELA PRINCIPAL - VISUALIZACAO             		| 
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

                            //   L1     C1      L2     C2
oDlgV      := MSDialog():New( D(090),D(300),D(545),D(1313),"XML CT-e",,,.F.,,,,,,.T.,,oFont0,.T. )
                                          
Aadd(aClixFor, "Fornecedor: " )
Aadd(aClixFor, SA2->A2_NOME	  )
Aadd(aClixFor, SA2->A2_COD +' - '+SA2->A2_LOJA )
Aadd(aClixFor, Transform( SA2->A2_CGC, IIF( Len(SA2->A2_CGC)==14,'@R 99.999.999/9999-99','@R 999.999.999-99')) )
Aadd(aClixFor, AllTrim(SA2->A2_END)+IIF(!Empty(SA2->A2_COMPLEM),'-'+SA2->A2_COMPLEM,'')+IIF(Empty(SA2->A2_NR_END),'',', '+SA2->A2_NR_END ) )
               
Aadd(aClixFor, AllTrim(SA2->A2_MUN)+' - '+SA2->A2_EST ) 
Aadd(aClixFor, IIF(!Empty(SA2->A2_DDD),'('+AllTrim(SA2->A2_DDD)+') - ','')+SA2->A2_TEL )

               

oGrp1      := TGroup():New( D(004),D(008),D(060),D(247),"",oDlgV,CLR_BLACK,CLR_WHITE,.T.,.F.	)
oSay71     := TSay():New( D(020),D(012),{|| aClixFor[1] },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(144),D(008)  )		
oSay14     := TSay():New( D(038),D(054),{|| aClixFor[5]	},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(160),D(008) )

oSay10     := TSay():New( D(020),D(054),{|| aClixFor[2] },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(136),D(008) )

oSay8      := TSay():New( D(011),D(012),{|| "CСdigo:" },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(032),D(008) )
oSay9      := TSay():New( D(011),D(054),{|| aClixFor[3] },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(052),D(008) )
oSay11     := TSay():New( D(029),D(012),{|| "CNPJ:" },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(032),D(008) )
oSay12     := TSay():New( D(029),D(054),{|| aClixFor[4] 	},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008) )
oSay13     := TSay():New( D(038),D(012),{|| "EndereГo:" },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(040),D(008) )
oSay14     := TSay():New( D(038),D(054),{|| aClixFor[5]	},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(160),D(008) )
oSay15     := TSay():New( D(048),D(012),{|| "Cidade:" },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(032),D(008) )
oSay16     := TSay():New( D(048),D(054),{|| aClixFor[6] },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(068),D(008) )
oSay17     := TSay():New( D(048),D(180),{|| "Fone:" },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(024),D(008) )
oSay18     := TSay():New( D(048),D(200),{|| aClixFor[7] },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(062),D(008) )



oGrp2      := TGroup():New( D(004),D(252),D(060),D(505),"",oDlgV,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayNF     := TSay():New( D(014),D(260),{|| "Nota Fiscal:"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(060),D(012) )
oSayNFSeri := TSay():New( D(014),D(320),{|| ZXC->ZXC_DOC +' - '+ ZXC->ZXC_SERIE},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(150),D(012) )
oSay1      := TSay():New( D(014),D(397),{|| "EmissЦo:"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(040),D(008) )
oSay2      := TSay():New( D(014),D(421),{|| dDHEmit  },oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(052),D(008) )
oSay3      := TSay():New( D(027),D(260),{|| "Total:"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(035),D(023) )
oSay4      := TSay():New( D(027),D(320),{|| "R$ "+AllTrim(Transform(Val(cVTPrest), '@E 999,999,999.99')) },oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(150),D(012) )
oSay5      := TSay():New( D(039),D(260),{|| "Nat.OperaГЦo:"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(052),D(008) )
oSay6      := TSay():New( D(039),D(320),{|| cNatOper },oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(170),D(008) )
oSay7      := TSay():New( D(048),D(260),{|| "Chave:"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(052),D(008) )
oSay8      := TSay():New( D(048),D(320),{|| ZXC->ZXC_CHAVE},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(170),D(008) )



oBtn1      := TButton():New( D(064),D(008),"Visualizar XML",oDlgV, {|| View_XML()	}, D(045),D(014),,oFont0,,.T.,,"Visualiza XML no Broswer",,,,.F. )
oBtn2      := TButton():New( D(064),D(055),"Mensagem Nota",oDlgV,  {|| MsgInfCpl()}, D(045),D(014),,oFont0,,.T.,,"Mensagem da Nota Fiscal",,,,.F. )

nDif := (055-008) // 47
nCol :=  055 + nDif

oBtn6SA2     := TButton():New( D(064),D(nCol),"Hist.Fornecedor",oDlgV,{|| HistFornec()},D(045),D(014),,oFont0,,.T.,,"HistСrico do Fornecedor",,,,.F. )

nCol +=  nDif
	
oBtn4SA2   := TButton():New( D(064),D(nCol),"Cad."+"Fornecedor",oDlgV, {|| MostraCadFor(SA2Recno) },D(045),D(014),,oFont0,,.T.,,"Cadastro Fornecedor",,,,.F. )

nCol +=  nDif
oBtnPC     := TButton():New( D(064),D(nCol),"Visualiza CT-e"   ,oDlgV, {|| ExecBlock('VizualCTe',.F.,.F.)},D(045),D(014),,oFont0,,.T.,,"Visualiza CT-e",,,,.F. )
nCol +=  nDif

oBtnPreDoc := TButton():New( D(064),D(nCol),"Doc.Entrada" , oDlgV, {|| CARGA_ACOLS() ,/*U_MT140TOK(),*/ IIF(lGravado, VisualNFE(), IIF(GeraPreDoc(), AtuPreDoc(), ) ) , VerifStatus() },D(045),D(014),,oFont0,,.T.,,"Gera Doc.Entrada",,,,.F. )
nCol +=  nDif


nCol+=10
oSayFret    := TSay():New( D(062),D(nCol),{|| "Tipo de Nota"},oDlgV,,oFont0,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(052),D(008) )
oCBoxFret	:= TComboBox():New( D(068),D(nCol),{|u| If(PCount()>0,nCBoxFret:=u,nCBoxFret)},{"CONHEC.FRETE","NORMAL"},D(060),D(010),oDlgV,,{|| CheckTpFrete() },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )



oBtn5       := TButton():New( D(064),D(460),"&Sair",oDlgV,{|| oDlgV:End() },D(045),D(014),,oFont0,,.T.,,"",,,,.F. )


Do Case
	Case ZXC->ZXC_STATUS == 'G'
	   oSayStatus:= TSay():New( D(082),D(013),{|| cXMLStatus },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,D(120),D(008) )
	Case ZXC->ZXC_STATUS == 'I'.And. ZXC->ZXC_SITUAC == 'A'
	   oSayStatus:= TSay():New( D(082),D(013),{|| cXMLStatus },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(100),D(008) )
	OtherWise
	   oSayStatus:= TSay():New( D(082),D(013),{|| cXMLStatus },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,D(100),D(008) )
EndCase



                               // L1     C1      L2     C2
oGrp3      := TGroup():New( D(080),D(008),D(224),D(505/*495*/),"",oDlgV,CLR_BLACK,CLR_WHITE,.T.,.F. )

//oBrwV := MsNewGetDados():New( D(087),D(012),D(220),D(500),GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','+D1_ITEM',aEditCpo,0,999,,'','AllwaysTrue()',oGrp3,aMyHeader,aMyCols )
oBrwV := MsNewGetDados():New( D(087),D(012),D(220),D(500),GD_UPDATE,'U_MT140LOK()','AllwaysTrue()','+D1_ITEM',aEditCpo,0,999,,'','AllwaysTrue()',oGrp3,aMyHeader,aMyCols )



oSayDevRet	:= TSay():New( D(082),D(415),{|| cMsgDevRet },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,D(120),D(008))
oSayNFOrig	:= TSay():New( D(082),D(378),{|u| If(PCount()>0,cMsgF10:=u,cMsgF10) },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,D(120),D(008))

*****************************
	CheckTpFrete(cTpFrete)
*****************************



//зддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VERIFICA SE EXISTE NO SA5 PROD.FORNECEDOR     Ё
//| aProdxFor=Array com ProdutoxFornecedor        |
//юддддддддддддддддддддддддддддддддддддддддддддддды
oBrwV:oBrowse:bLDblClick	:=	{|| PreDocRefresh(), VerifStatus(), ViewTrigger(oBrwV:NAT, oBrwV:oBrowse:ColPos), DadosSB1() }


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё FUNCAO CHAMA PONTOS DE ENTRADA CASO PE ESTAJA COMPILADO 	|
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//oBrwV:oBrowse:bDrawSelect  :=	{|| CheckingPE()  }


oBrwV:oBrowse:SetFocus()
oBrwV:oBrowse:Refresh()

oDlgV:Activate(,,,.T.,{|| IIF(!lValidDlg,oDlgV:End(),)},,{|| VerifStatus() })	

	  
RestArea(aArea3)
Return()            
************************************************************
Static Function CheckTpFrete(cOpcao)
************************************************************
Local nPosQtd  	:=	Ascan(aMyHeader,{|x| Alltrim(x[2]) == 'D1_QUANT' })


If oCBoxFret:nAT == 1	.Or.  ZXC->ZXC_TPFRET == 'E' .Or. cOpcao == 'FRETE_COMPRA'		//	FRETE SOBRE COMPRA -  oCBoxFret:nAT == 1 = CONHEC.FRETE
	cMsgDevRet		:=	IIF(lGravado, '  Tipo Nota: Compl. PreГo/Frete', '')
	cMsgF10			:=	'F10 - Doc.Original'
	oCBoxFret:nAT	:= 1
	
ElseIf oCBoxFret:nAT == 2 .Or.  ZXC->ZXC_TPFRET == 'S'	 .Or. cOpcao == 'FRETE_VENDA'	//	FRETE SOBRE VENDA -  oCBoxFret:nAT == 2 = NORMAL
	cMsgDevRet		:=	IIF(lGravado, '  Tipo Nota: Normal', '')
	cMsgF10			:=	''
	oCBoxFret:nAT	:= 2
Else                      
	cMsgF10			:=	''
	cMsgDevRet		:=	''

EndIf

If lGravado
	If oCBoxFret:nAT == 0
		_cTipoDoc := ''
		DbSelectArea('SF1');DbSetOrder(1);DbGoTop()    //    D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		If DbSeek( ZXC->ZXC_FILIAL + ZXC->ZXC_DOC + ZXC->ZXC_SERIE + ZXC->ZXC_FORNEC+ ZXC->ZXC_LOJA, .F.)
			_cTipoDoc := SF1->F1_TIPO
		Else
			DbSelectArea('SF1');DbSetOrder(1);DbGoTop()    //    D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			If DbSeek( xFilial('SF1') + ZXC->ZXC_DOC + ZXC->ZXC_SERIE + ZXC->ZXC_FORNEC+ ZXC->ZXC_LOJA, .F.)
				_cTipoDoc := SF1->F1_TIPO
			EndIf
		EndIf
		
		If _cTipoDoc == 'N'
			oCBoxFret:nAT	:=	2	//	FRETE SOBRE VENDA -  oCBoxFret:nAT == 2 = NORMAL
			
		ElseIf _cTipoDoc == 'C'
			oCBoxFret:nAT 	:=	1	//	FRETE SOBRE COMPRA -  oCBoxFret:nAT == 1 = CONHEC.FRETE
		EndIf
		
		DbSelectArea('ZXC')
		If Empty(ZXC->ZXC_TIPO)
			RecLock('ZXC',.F.)
				ZXC->ZXC_TIPO	:=	_cTipoDoc
			MsUnlock()
		EndIf
		
	EndIf
	oCBoxFret:Disable()

EndIf


//зддддддддддддддддддддддддддддд©
//Ё 	ATUALIZA QUANTIDADE		Ё
//юддддддддддддддддддддддддддддды
If Type('oBrwV')=='O'
	For nX := 1 To Len(oBrwV:aCols)
		If oCBoxFret:nAT == 2 // FRETE VENDA
			oBrwV:aCols[nX][nPosQtd] :=	 1
		Else
			oBrwV:aCols[nX][nPosQtd] :=	 0
		EndIf
	Next    
	oBrwV:oBrowse:Refresh()
EndIf

oCBoxFret:Refresh()
oSayNFOrig:Refresh()

Return()
************************************************************
Static Function DadosSB1()
************************************************************
nPosProd  	:=	aScan(aMyHeader,{|x| Alltrim(x[2]) == "D1_COD" })
cProduto  	:= 	oBrwV:aCols[oBrwV:NAT][nPosProd]

nPosALM		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_LOCAL'	})
cArmazem    := oBrwV:aCols[oBrwV:NAT][nPosALM]
			
nPosTES		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_TES' 	})
nPosCTA		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_CONTA'	})
nPosCUS		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_CC'  	})
nPosUM		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_UM'  	})
nPosPC		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_PEDIDO'	})
nPosIPC		:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'D1_ITEMPC'	})
nPosDesc	:= 	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'B1_DESC'	})	//	DESCRICAO PRODUTO EMPRESA

nPosNCM		:=	aScan(aMyHeader,{|x| Alltrim(x[2]) == 	'B1_POSIPI'	})
                                                                  

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё oBrwV:oBrowse:ColPos = POSICAO EM QUE SE ENCONTRA NO aCols  Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If oBrwV:oBrowse:ColPos == nPosProd

	SB1->(DbGoTop(), DbSetOrder(1))
	If SB1->(DbSeek(xFilial('SB1') + cProduto ,.F.) )
                
	    cAlmox 	:= 	IIF(!Empty(SB1->B1_LOCPAD),	AllTrim(SB1->B1_LOCPAD), 	Space(TamSx3('B1_LOCPAD')[1]) 	)	//	Local Padrao 
	    cTes	:= 	IIF(!Empty(SB1->B1_TE), 	AllTrim(SB1->B1_TE), 		Space(TamSx3('B1_TE')[1]) 		)	//	Codigo de Entrada padrao
	    cCtaCont:= 	IIF(!Empty(SB1->B1_CONTA), AllTrim(SB1->B1_CONTA), 	Space(TamSx3('B1_CONTA')[1]) 	)	//	Conta Contabil dn Prod.
		cCCusto	:=	IIF(!Empty(SB1->B1_CC), 	AllTrim(SB1->B1_CC), 		Space(TamSx3('B1_CC')[1]) 		)	//	Centro de Custo
		cUnidade:=	IIF(!Empty(SB1->B1_UM), 	AllTrim(SB1->B1_UM), 		Space(TamSx3('B1_UM')[1]) 		)	//	Centro de Custo
        
        DbSelectArea('SB2');DbSetOrder(1);DbGoTop()        
		If !DbSeek(xFilial('SB2')+PadR(cProduto,  TamSx3('B1_COD')[1], '' )+cAlmox, .F.)
	    	A103Alert(cProduto, cAlmox, .F.)
        EndIf


       	DbSelectArea('SB1')
		If nPosDesc > 0
			oBrwV:aCols[oBrwV:NAT][nPosDesc]:=	AllTrim(SB1->B1_DESC)
		EndIf
		If nPosUM > 0
			oBrwV:aCols[oBrwV:NAT][nPosUM]:=	cUnidade
		EndIf
		If nPosALM > 0
			oBrwV:aCols[oBrwV:NAT][nPosALM]	:=	cAlmox
		EndIf
		If nPosTES > 0
			oBrwV:aCols[oBrwV:NAT][nPosTES]	:=	cTes         		
		EndIf
		If nPosCTA > 0
			oBrwV:aCols[oBrwV:NAT][nPosCTA]	:=	cCtaCont
		EndIf
		If nPosCUS > 0
			oBrwV:aCols[oBrwV:NAT][nPosCUS]	:=	cCCusto
		EndIf
	
	   //зддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё   VERIFICA SE B1_POSIPI ESTA PREENCHIDO       Ё
	   //| SE EM BRANCO GRAVA NCM DO XML NO SB1			 |
	   //юддддддддддддддддддддддддддддддддддддддддддддддды
		If nPosNCM > 0
			If Empty(SB1->B1_POSIPI)
				Reclock('SB1',.F.)
					SB1->B1_POSIPI := oBrwV:aCols[oBrwV:NAT][nPosNCM]
				MsUnlock()
			EndIf
		EndIf	
			
	Else

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
		If nPosNCM > 0
			oBrwV:aCols[oBrwV:NAT][nPosNCM]	:=	Space(TamSx3('D1_POSIPI')[1])
		EndIf		
			
	EndIf
	
	oBrwV:oBrowse:Refresh()

ElseIf oBrwV:oBrowse:ColPos == nPosALM

    DbSelectArea('SB2');DbSetOrder(1);DbGoTop()
	If !DbSeek(xFilial('SB2')+PadR(cProduto,  TamSx3('B1_COD')[1], '' )+cArmazem, .F.)
    	A103Alert(cProduto, cArmazem, .F.)
 	EndIf

  	DbSelectArea('SB1')
        
   //зддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё   VERIFICA SE B1_POSIPI ESTA PREENCHIDO       Ё
   //| SE EM BRANCO GRAVA NCM DO XML NO SB1			 |
   //юддддддддддддддддддддддддддддддддддддддддддддддды
	If nPosNCM > 0
		If Empty(SB1->B1_POSIPI)
			Reclock('SB1',.F.)
				SB1->B1_POSIPI := oBrwV:aCols[oBrwV:NAT][nPosNCM]
			MsUnlock()
		EndIf
	EndIf

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

//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё P.E. Utilizado para chamar PE do Cliente	Ё
//юддддддддддддддддддддддддддддддддддддддддддддды
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
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё EXECUTADO APOS CLICAR NO CAMPO.                                                			Ё
//Ё	oBrwV:oBrowse:bLDblClick	:=	{|| ... ViewTrigger(oBrwV:NAT, oBrwV:oBrowse:ColPos) }	Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cCampo := AllTrim(oBrwV:aHeader[nPosCampo][2])

If ExistTrigger(cCampo) .And.  Left(cCampo,2) == 'D1' // VERIFICA SE EXISTE TRIGGER PARA ESTE CAMPO
	RunTrigger(2,nLin,Nil,,cCampo)
Endif	

Return()
************************************************************
Static Function PreDocRefresh()
************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё FUNCAO DISPARADA AO CLICAR NO GRID         		    Ё
//|	Chamada -> Visual_XML()->oBrwV:oBrowse:bLDblClick	|
//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
nPosItem := Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_ITEM'	})
nPosProd := Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_COD'	})
nPosLocal:= Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_LOCAL'	})
nPosNfOri:= Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_NFORI'	})
nPosDescr:= Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'B1_DESC'	})
   

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё oBrwV:oBrowse:ColPos = POSICAO EM QUE SE ENCONTRA NO aCols  Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If oBrwV:oBrowse:ColPos == nPosProd  .And. Len(aProdxFor) > 0 .And. Ascan(aProdxFor, {|X| X[1] == oBrwV:aCols[oBrwV:NAT][nPosItem] }) > 0

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё MOSTRA TELA COM OS PRODUTOS QUE JA ESTA AMARRADOS - SA5	|
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	Processa ({|| TMPProdxFor()  },'Verificando Produto X Fornecedor','Processando...', .T.)

Else

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё RETORNA O VALOR ORIGINAL DOS EVENTOS - PARA EDICAO NORMAL DO ACOLS	|
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    oBrwV:oBrowse:bLDblClick:=	{|| IIF( oBrwV:oBrowse:ColPos ==  Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_COD'}) .And. Len(aProdxFor) > 0 .And. Ascan(aProdxFor, {|X| X[1] == oBrwV:aCols[oBrwV:NAT][Ascan(oBrwV:aHeader, {|X| AllTrim(X[2])=='D1_ITEM'})] }) > 0,;
    									 (PreDocRefresh(), VerifStatus()), oBrwV:EditCell()) }
	oBrwV:Editcell()
	oBrwV:oBrowse:lModified	:= .T.

EndIf

oBrwV:oBrowse:Refresh() 
    
Return
************************************************************
Static Function AtuPreDoc()
************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//|	ATUALIZA VARIAVEIS												|
//Ё Apos Gerar Pre-Nota\Doc.Entrada                                	|
//Ё Chamada -> Visual_XML()->Btn Gera Pre-Nota\Doc.Entrada         	Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

lGravado        := .T.
oBrwV:lUpdate   := .F.
cXMLStatus      := 'Status XML: DOC.ENTRADA GRAVADO"
oBtnPreDoc:Refresh()
oBrwV:oBrowse:Refresh()
oBrwV:Refresh()
FreeObj(oSayStatus)
oSayStatus:= TSay():New( D(082),D(013),{|| cXMLStatus },oGrp2,,oFontP,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,100,008)
oSayStatus:Refresh()

Return()
************************************************************
Static Function VerifStatus()
************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё   ATUALIZA STATUS e VARIAVEIS                 		Ё
//|	Chamada -> Visual_XML()->oBrwV:oBrowse:bLDblClick	|
//юддддддддддддддддддддддддддддддддддддддддддддддддддддды

Do Case
	Case ZXC->ZXC_STATUS $ 'I\G' .And. ZXC->ZXC_SITUAC != 'C'//.And. ZXC->ZXC_SITUAC == 'A'
	   	//зддддддддддддддддддддддддддддддддддддддддддддддд©
	   	//Ё    XML - GRAVADO PRE-NOTA \ DOC.ENTRADA       Ё
	   	//юддддддддддддддддддддддддддддддддддддддддддддддды
	   	oBtnPreDoc:Enable()                                //    Habilita Botao
	   	oBrwV:lUpdate := IIF(lGravado,.F.,.T.)     //    Ativa\Desativa edicao Linha
	   	IF lGravado
	    	oBrwV:oBrowse:bLDblClick := {|| MsgAlert( 'DOC.ENTRADA jА gravado... NЦo И possМvel ediГЦo!!!'+ENTER+'Para VISUALIZAR o documento click no botЦo Doc.Entrada' ) }
		    oBrwV:lUpdate := .F.    //    Ativa\Desativa edicao Linha
			SetKey( VK_F10,{|| MsgAlert( 'DOC.ENTRADA jА gravado... NЦo И possМvel ediГЦo!!!'+ENTER+'Para VISUALIZAR o documento click no botЦo Doc.Entrada' ) })

		Else
			SetKey( VK_F10, {|| MsgRun('Verificando NF Origem... ', 'Aguarde... ',{|| Doc_DevRet() }), oBrwV:oBrowse:Refresh() })
	   	EndIf

	Case ZXC->ZXC_STATUS $ 'X\R' .And. ZXC->ZXC_SITUAC != 'C'
	   	//зддддддддддддддддддддддддддддддддддддддддддддддд©
	   	//Ё    XML - CANCELADO \ RECUSADO                 Ё
	   	//юддддддддддддддддддддддддддддддддддддддддддддддды
	   	oBtnPreDoc:Disable()    //    Desabilita Botao
	   	oBrwV:lUpdate := .F.    //    Desabilita Edicao Linha
       	oBrwV:oBrowse:lModified := .F.
	   	oBrwV:oBrowse:bLDblClick :=    {|| MsgAlert( cXMLStatus+'.   NЦo И possМvel ediГЦo !!!' ) }
		SetKey( VK_F10,{|| MsgAlert('XML '+IIF(ZXC->ZXC_STATUS=='C','CANCELADO','RECUSADO' )+'... NЦo И possМvel ediГЦo!!!') })	 
	   		
	Case ZXC->ZXC_SITUAC == 'C'
	   	//зддддддддддддддддддддддддддддддддддддддддддддддд©
	   	//Ё    XML - CANCELADO PELO FORNECEDOR            Ё
	   	//юддддддддддддддддддддддддддддддддддддддддддддддды
	   	oBtnPreDoc:Disable()    //    Desabilita Botao
	   	oBrwV:lUpdate := .F.    //    Desabilita Edicao Linha
       	oBrwV:oBrowse:lModified := .F.
	   	oBrwV:oBrowse:bLDblClick :=    {|| MsgAlert( cXMLStatus+'.   NЦo И possМvel ediГЦo !!!' ) }
		SetKey( VK_F10,{|| MsgAlert('XML CANCELADO... NЦo И possМvel ediГЦo!!!') })
		
	   	MsgAlert('XML Cancelado pelo Fornecedor.  NЦo И possМvel ediГЦo !!!' )
      
	Case Empty(ZXC->ZXC_SITUAC)
		lValidDlg	:=	.F.
		If MsgYesNo('Status XML invАlido. Deseja consultar XML na SEFAZ ?') 
			cRet := ExecBlock("CTe_ConsNFeSefaz",.F.,.F.,{""})
			lValidDlg	:=	.T.
		EndIf
	
EndCase

oBrwV:oBrowse:Refresh()
oBrwV:Refresh()

Return()
************************************************************
Static Function TMPProdxFor()
************************************************************
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ao clicar no campo Produto e existir mais de 1 Produto X Cod.For |
//| Browse para usuario informar qual produto ira amarrar com Cod.For|
//Ё Chamada -> Visual_XML()->bLDblClick                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local	nPosPFor    :=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'C7_PRODUTO' })
Local	nTamProd    :=	TamSX3('B1_COD')[1]
Local	cProduto    :=	Space(nTamProd)
Private	cMarca		:= 	''

SetPrvt("oFont1","oDlgSA5","oSay1","oSay2","oSay3","oSay4","oSay5","oGrp1","oBrwSA5","oBtn1","oBtn2")

oFont1     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-09,-11),,.T.,0,,700,.F.,.F.,,,,,, )

oDlgSA5    := MSDialog():New( D(095),D(232),D(475),D(702),"Produto X Fornecedor",,,.F.,,,,,,.T.,,oFont1,.T. )
oSay1      := TSay():New( D(004),D(008),{||"Os Produtos abaixo estЦo relacionados com o produto deste fornecedor."},oDlgSA5,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(210),D(008) )
oSay3      := TSay():New( D(019),D(008),{||"Produto: "+ oBrwV:aCols[oBrwV:NAT][nPosPFor] },oDlgSA5,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(150),D(008) )
oGet1      := TGet():New( D(026),D(008),{|u| If(PCount()>0,cProduto :=u,cProduto)},oDlgSA5,D(072),D(008),'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)

oBtn4      := TButton():New( D(024),D(090),"Adicionar",oDlgSA5,{|| AddProdxFor(cProduto), cProduto:= Space(nTamProd), oDlgSA5:Refresh() },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )

*******************************
   oTblSA5()
*******************************
cMarca     := GetMark()
DbSelectArea("TMPSA5")
oGrp1      := TGroup():New( D(038),D(004),D(164),D(228),"",oDlgSA5,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBrwSA5    := MsSelect():New( "TMPSA5","OK","",{{"OK","","",""},{"PRODUTO","","Produto",""},{"DESCR","","DescriГЦo",""}},.F.,cMarca,{D(042),D(008),D(157),D(220)},,, oGrp1 )

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
//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria\Limpa\Atualiza Tabela Temporaria       |
//Ё Chamada -> TMPProdxFor                      Ё
//юддддддддддддддддддддддддддддддддддддддддддддды
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

Return
************************************************************
Static Function MarcaSA5()
************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Marca apenas 1 para selecao                 |
//Ё Chamada -> TMPProdxFor                      Ё
//юддддддддддддддддддддддддддддддддддддддддддддды
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
//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Grava no aCols o item selecionado           |
//Ё Chamada -> TMPProdxFor                      Ё
//юддддддддддддддддддддддддддддддддддддддддддддды
Local    nPosProd    :=    Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_COD' })

oBrwV:aCols[oBrwV:NAT][nPosProd] := TMPSA5->PRODUTO

oBrwV:oBrowse:Refresh()

Return
************************************************************
Static Function AddProdxFor(cProduto)
************************************************************
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Usuario podera adicionar outro produto para amarrar - SA5  |
//Ё Chamada -> TMPProdxFor                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nTotRecno	:= 	0
nPosPFor    :=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'C7_PRODUTO' })
nPDescFor   :=	Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'B1_DESC' })	// DESCRICAO DO CODIGO DO FORNECEDOR [GRAVO NO SA5]
_nRecno     :=	TMPSA5->_RECNO

DbGoTop()
Do While !Eof()
   If AllTrim(TMPSA5->PRODUTO) == AllTrim(cProduto)
       Alert('PRODUTO '+SB1->B1_COD+' Jа RELACIONADO !!!')
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

DbSelectArea('ZXC')
DbSelectArea('SA5');DbSetOrder(1);DbGoTop()
If !Dbseek(xFilial("SA5")+ ZXC->ZXC_FORNEC + ZXC->ZXC_LOJA + SB1->B1_COD, .F.)
	If Reclock("SA5",.T.)
       SA5->A5_FILIAL    :=    xFilial("SA5")
       SA5->A5_FORNECE   :=    ZXC->ZXC_FORNEC
       SA5->A5_LOJA      :=    ZXC->ZXC_LOJA
       SA5->A5_CODPRF    :=    oBrwV:aCols[oBrwV:NAT][nPosPFor]
       SA5->A5_PRODUTO   :=    SB1->B1_COD
       SA5->A5_NOMPROD   :=    SubStr(oBrwV:aCols[oBrwV:NAT][nPDescFor],1,30) //SubStr(SB1->B1_DESC,1,30)
       SA5->A5_NOMEFOR   :=    Posicione("SA2",3,xFilial("SA2")+ZXC->ZXC_CGC,"A2_NOME")
	   MsUnlock()
	EndIf	   
EndIf

MsgInfo('PRODUTO RELACIONADO COM SUCESSO !!!'+ENTER+ENTER+ AllTrim(SB1->B1_COD)+' - '+AllTrim(SB1->B1_DESC) )

DbGoTop()

Return()
************************************************************
Static Function CarregaACols(lCheck)
************************************************************
//зддддддддддддддддддддддддддддддддд©
//Ё Carrega valores para aMyCols    Ё
//Ё Chamada -> Visual_XML()         Ё
//юддддддддддддддддддддддддддддддддды
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
Local cEanCod	:=	''
Local cCompSB1	:= 	''
Local cCtaCont	:= 	''
Local cCCusto	:=	''		           		
Local _cTipo	:=	''
Local cXML		:=	''
Local aItens 	:=	{}
Local nSD1Recno := 	0
Local nItemCTe	:= 	0

aXMLOriginal	:=	{}
cTpFormul 		:= 	''


//зддддддддддддддддддддддддддддддддд©
//Ё Verifica se SB1 eh compartilhado|
//юддддддддддддддддддддддддддддддддды
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('SB1'))
	cCompSB1	:= SX2->X2_MODO
EndIf

Private aItemProdxFor 	:= {}

//зддддддддддддддддддддддддддддддддд©
//Ё Var Private - Visual_XML        |
//юддддддддддддддддддддддддддддддддды
lGravado	:=	.F.
cVTPrest	:=	0
cVlrTotal	:=	0


cXML	:=	AllTrim(ZXC->ZXC_XML)
cXML	+=	ExecBlock("CTe_VerificaZXD",.F.,.F., {ZXC->ZXC_FILIAL, ZXC->ZXC_CHAVE})	//	VERIFICA SE O XML ESTA NA TABELA ZXD


//здддддддддддддддддддддддддддддддддддддддддд©
//Ё  CabecCTeParser -   ABRE XML - CABEC     Ё
//юдддддддддддддддддддддддддддддддддддддддддды 
*******************************************************************
   aRet	:=	ExecBlock("CabecCTeParser",.F.,.F., {cXML})
*******************************************************************

If aRet[1] == .T.	//	aRet[1] == .F. SIGNIFICA XML COM PROBLEMA NA ESTRUTURA

	ProcRegua(nItensCTe)
	
   	For nX := 1 To nItensCTe
                               
	   	IncProc('Verificando Item '+AllTrim(Str(nX)) +' de '+ AllTrim(Str(nItensCTe))  ) 

           	nItemCTe := PadL(AllTrim(Str(nX)),4,'0')
		
			DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()
			DbSeek(cEmpAnt+cFilAnt, .F.)     

		
           //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
           //Ё BUSCA DADOS DA PRE-NOTA \ DOC.ENTRADA, CASO JA TENHA GRAVADO    Ё
           //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
           	lGravado	:= 	IIF(lGravado, .T., .F.) // CASO TENHA INCLUSO 1 ITEM E OS OUTROS NAO.. EH MARCADO COMO GRAVADO.
           	cNumPC 		:= 	cItemPC  := cAlmox  :=  cTes	:=	cUM	:=	''
			cCtaCont    :=  cCCusto  := _cTipo	:=	cNCM    := ''
			cProdSD1	:=	Space(TamSx3('D1_COD')[1])
			cDescrProd	:=	Space(TamSx3('B1_DESC')[1])
			nQuant		:=	0

			If TMPCTE->(FieldPos("PRODXCTE")) > 0 
				cProdSD1	:=	AllTrim(TMPCTE->PRODXCTE) //'X_000007GERAL'
				cDescrProd	:=	IIF(!Empty(AllTrim(TMPCTE->PRODXCTE)), AllTrim(Posicione('SB1',1,xFilial('SB1')+ cProdSD1 ,'B1_DESC')), '')
			EndIf
			If Empty(cDescrProd)
				cProdSD1	:=	Space(TamSx3('D1_COD')[1])
				cDescrProd	:=	Space(TamSx3('B1_DESC')[1])
            EndIf


			If TMPCTE->(FieldPos("TESXCTE")) > 0  
				If !Empty(TMPCTE->TESXCTE)
					cTes	:=	AllTrim(TMPCTE->TESXCTE)
				EndIf
			EndIf
           			
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁVERIFICA SE XML ESTA GRAVADO NO DOC.ENTRADA       Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддды// D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			cChavePesq  := ''
			DbSelectArea('SD1');DbSetOrder(1);DbGoTop()    //    D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			If DbSeek( ZXC->ZXC_FILIAL + ZXC->ZXC_DOC + ZXC->ZXC_SERIE + ZXC->ZXC_FORNEC+ ZXC->ZXC_LOJA, .F.)
				cChavePesq	:=	SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE+ SD1->D1_LOJA
			Else
			
				DbSelectArea('SD1');DbSetOrder(1);DbGoTop()    //    D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
				If DbSeek( xFilial('SD1') + ZXC->ZXC_DOC + ZXC->ZXC_SERIE + ZXC->ZXC_FORNEC+ ZXC->ZXC_LOJA, .F.)
					cChavePesq	:=	SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE+ SD1->D1_LOJA
				EndIf
				
			EndIf
				
			If !Empty(cChavePesq)
				Do While !Eof() .And. cChavePesq == ZXC->ZXC_DOC + ZXC->ZXC_SERIE + ZXC->ZXC_FORNEC+ ZXC->ZXC_LOJA
					If  SD1->D1_ITEM == nItemCTe
						_cTipo		:=	SD1->D1_TIPO
						cNumPC		:=	SD1->D1_PEDIDO
						cItemPC		:=	SD1->D1_ITEMPC
						cAlmox		:=	SD1->D1_LOCAL
						cProdSD1	:=	SD1->D1_COD
						cDescrProd	:=	AllTrim(Posicione('SB1',1,xFilial('SB1')+ cProdSD1 ,'B1_DESC'))
						cTes		:=	SD1->D1_TES
			       		cCtaCont	:= 	SD1->D1_CONTA		//	Conta Contabil dn Prod.
		           		cCCusto		:=	SD1->D1_CC			//	Centro de Custo
						cNFOrig		:=	SD1->D1_NFORI
						cSerOrig	:=	SD1->D1_SERIORI
						cItemOrig	:=	SD1->D1_ITEMORI
						cVlrIcms	:=	AllTrim(Str(SD1->D1_VALICM))
						cPerIcms	:=	AllTrim(Str(SD1->D1_PICM))
						cBaseIcms	:=	AllTrim(Str(SD1->D1_BASEICM))
		                nQuant		:=	SD1->D1_QUANT
		                
						nSD1Recno	:=	SD1->(Recno())
						lGravado  	:=	.T.    
						cNCM		:=	AllTrim(Posicione('SB1',1,xFilial('SB1')+ cProdSD1 ,'B1_POSIPI'))
						
					EndIf
					
					DbSelectArea('SD1') 
					DbSkip()
					
					cChavePesq	:=	SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE+ SD1->D1_LOJA
					
				EndDo
			EndIf


           //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
           //Ё  ATUALIZA STATUS ZXC - CASO XML ESTEJA GRAVADO NO DOC.ENTRADA    Ё
           //|	CASO XML NAO ESTEJA CANCELADO NA SEFAZ							|
           //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
           If lGravado
				DbSelectArea("ZXC")
                If ZXC->ZXC_STATUS != 'G' .And. ZXC->ZXC_SITUAC != 'C'
                	If RecLock('ZXC',.F.)
        	            	ZXC->ZXC_STATUS := 'G'
                  			ZXC->ZXC_TIPO	:=	_cTipo
                  		MsUnlock()
					EndIf
               	EndIf
           EndIf



           // nPrecoNFe := (nTotal-nDescont)
           // cVTPrest  += (nTotal-nDescont)

           cCodFor 		:= 	cCodFor := ''
           aItemProdxFor:= 	{}
           aProdFil		:=	{}
	                        
	
	
           //зддддддддддддддддддддддддддддд©
           //Ё        XML - NORMAL         Ё
           //юддддддддддддддддддддддддддддды
           DbSelectarea("SA2");DbSetOrder(3);DbGoTop()
           If Dbseek(xFilial("SA2")+ZXC->ZXC_CGC, .F.)
               cCodFor    :=   SA2->A2_COD
               cLojaFor   :=   SA2->A2_LOJA
           EndIf                    

	           //зддддддддддддддддддддддддддддд©
	           //Ё        ARMAZEM PADRAO       Ё
	           //| Busca primeiro do Produto   |
	           //юддддддддддддддддддддддддддддды
				If !lGravado        
				
		           	SB1->(DbGoTop(), DbSetOrder(1))
		           	If SB1->(DbSeek(xFilial('SB1') + cProdSD1 ,.F.) )
		           		cAlmox 		:= 	AllTrim(SB1->B1_LOCPAD)		//	Local Padrao 
						cTes		:= 	IIF(!Empty(cTes), cTes, AllTrim(SB1->B1_TE))			//	Codigo de Entrada padrao
		           		cCtaCont	:= 	AllTrim(SB1->B1_CONTA)		//	Conta Contabil dn Prod.
		           		cCCusto		:=	AllTrim(SB1->B1_CC)			//	Centro de Custo
		           		cUM			:=	AllTrim(SB1->B1_UM)			//	Unidade de Medida
						cNCM		:=	AllTrim(SB1->B1_POSIPI)		//	NCM
					ElseIf SX6->(DbGoTop(), DbSeek( cFilAnt+'MV_LOCPAD' ,.F.) )
		               	cAlmox := AllTrim(SX6->X6_CONTEUD)		               
		            EndIf
	            
	            EndIf


	           //зддддддддддддддддддддддддддддд©
	           //Ё     ALIMENTA aMyACols       Ё
	           //юддддддддддддддддддддддддддддды
	
				aItens := {}
			
				Aadd( aItens, {'D1_ITEM', 		nItemCTe 	})
				Aadd( aItens, {'D1_COD',  		cProdSD1	})
				Aadd( aItens, {'B1_DESC', 		cDescrProd	})
				Aadd( aItens, {'D1_LOCAL', 		cAlmox 		})
				Aadd( aItens, {'D1_PEDIDO', 	cNumPC		})
	        	Aadd( aItens, {'D1_ITEMPC', 	cItemPC		})
	            Aadd( aItens, {'D1_TES',		cTes		})
	            Aadd( aItens, {'D1_NFORI',		cNFOrig		})
				Aadd( aItens, {'D1_SERIORI',	cSerOrig	})
				Aadd( aItens, {'D1_ITEMORI',	cItemOrig	})
				Aadd( aItens, {'D1_UM',			Upper(cUM)	})
				Aadd( aItens, {'D1_QUANT',		nQuant		})  
				Aadd( aItens, {'D1_VUNIT',		Val(cVTPrest)	})
				Aadd( aItens, {'D1_TOTAL', 		Val(cVTPrest)	})
		   		Aadd( aItens, {'D1_CC', 		cCCusto		})
		   		Aadd( aItens, {'D1_CONTA', 		cCtaCont	})
		   		
		   		Aadd( aItens, {'D1_VALICM', 	Val(cVlrIcms)	})
		   		Aadd( aItens, {'D1_PICM', 		Val(cPerIcms)	})
   				Aadd( aItens, {'D1_BASEICM', 	Val(cBaseIcms)	})
						

	    
	    
	           //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	           //Ё     ALIMENTA aMyACols com os dados de aMyHeader, SE NAO EXISTE NO aItens CRIA COM O CONTEUDO PADRAO DO SX3	|
			   //| 	   aMyHeader == TODO O SX3 DO SD1																			|
	           //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				Aadd(aMyCols, Array(Len(aMyHeader)))				//	GERA aMyCols do tamannho de aMyHeader
				nTam := Len(aMyCols)
				
				
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё  PRIMEIRO VERIFICA E CARREGA aMyCols COM O ARRAY aItens   Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				For _nX:=1 To Len(aItens)

	                SX3->(DbSetOrder(2), DbGoTop())                //	PROCURA NO SX3 OS CAMPOS DA aMyHeader
	                SX3->(DbSeek(aItens[_nX][1], .F.) )

					nPos := Ascan(aMyHeader, {|X| AllTrim(X[2]) == aItens[_nX][1] })
					If nPos > 0
						If aMyHeader[nPos][8] == 'C'                            //           TAMANHO DO CONTUDO DA TAG PODERA SER MAIOR QUE O TAMANHO PADRAO DO CAMPO.... EX.: PRODUTO
							aMyCols[nTam][nPos] := IIF(!Empty(aItens[_nX][2]), IIF(Len(aItens[_nX][2])>aMyHeader[nPos][4], Left(aItens[_nX][2],aMyHeader[nPos][4]), aItens[_nX][2]), Space(aMyHeader[nPos][4]) )
						ElseIf aMyHeader[nPos][8] == 'N'
							aMyCols[nTam][nPos] := IIF( aItens[_nX][2]!=0, aItens[_nX][2], CriaVar(aMyHeader[nPos][2],IIF(SX3->X3_CONTEXT=="V",.F.,.T.)) )
						EndIf
					Else
						aMyCols[nTam][_nX] := CriaVar(aMyHeader[_nX][2],IIF(SX3->X3_CONTEXT=="V",.F.,.T.))
					EndIf

				Next
				


	                
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё  SEGUNDO CARREGA OS VALORES DEFAULT no aMyCols         Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды	                
	            For _nX:=1 To Len(aMyHeader)
	
					If Ascan(aItens, {|X| AllTrim(X[1]) == AllTrim(aMyHeader[_nX][2])} ) == 0
	
		                SX3->(DbSetOrder(2), DbGoTop())                //	PROCURA NO SX3 OS CAMPOS DA aMyHeader
		                SX3->(DbSeek(aMyHeader[_nX][2], .F.) )
	
						aMyCols[nTam][_nX] := CriaVar(aMyHeader[_nX][2],IIF(SX3->X3_CONTEXT=="V",.F.,.T.))

				    EndIf

				Next

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё  ADICIONA +1 COLUNA NO aMyCols PARA CONTROLE DE ITEM DELETADO   Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				Aadd(aMyCols[nTam], .F. )
	                            
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё  GRAVA DADOS DO XML PARA DEPOIS COMPARAR COM DOC.ENTRADA	 	Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				Aadd(aXMLOriginal, {nItemCTe, Right(cProdSD1, TamSx3('D1_COD')[1]), cDescrProd, cNCM, nQuant, Val(cVTPrest) } )
	    
	
	Next

EndIf

RestArea(aArea3_2)
Return()
************************************************************
Static Function View_XML()
************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Visualiza arquivo XML no Broswer                |
//Ё Chamada -> Visual_XML()                         Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддды
Local cMsgMotivo := ''

DbSelectArea('ZXC')

cArqViewXml  := GetTempPath()+AllTrim(ZXC->ZXC_CHAVE)+'.XML'    //    DIRETORIO TEMPORARIO WINDOWS
MemoWrit(AllTrim(cArqViewXml), AllTrim(ZXC->ZXC_XML) )
Aadd(aArqTemp, cArqViewXml)

MsgRun("Aguarde... Abrindo XML...",,{|| ShellExecute("open",cArqViewXml,"","",1) } )

Return()
************************************************************
Static Function MsgInfCpl()
************************************************************
//здддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Visualiza Mensagem do XML                      |
//Ё Chamada -> Visual_XML()                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддды

oFont     := TFont():New( "Arial",0,-12,,.T.,0,,700,.F.,.F.,,,,,, )

Define MsDialog oMensNF From 0,0 To 290,415 Pixel Title "Mensagem da Nota Fiscal"
@ 005,005 Get oMemo Var cObs Memo Size 200,135 FONT oFont Pixel Of oMensNF
Activate MsDialog oMensNF Center

Return()
************************************************************
Static Function HistFornec()
************************************************************
//зддддддддддддддддддддддддддддддддддддд©
//Ё Visualiza Historico do Fornecedor   |
//Ё Chamada -> Visual_XML()             Ё
//юддддддддддддддддддддддддддддддддддддды

Local aArea3_4  := GetArea()

//зддддддддддддддддддддддддддддддддд©
//Ё    Historico do Fornecedor      Ё
//юддддддддддддддддддддддддддддддддды

DbSelectArea('ZXC')
cCadastro := 'HistСrico Fornecedor'

aRotina2  :=    {  	{"Perdas",					"U_PR_PERD()", 	0,2},;
                   	{"Trocas Produtos",       	"U_PR_TRO()", 	0,2},;
                   	{"DivergЙncias Pedidos",    "U_PR_DIV()", 	0,2},;
                   	{"Pedidos com cortes",     	"U_PR_COR()", 	0,2},;
                   	{"Pedidos NЦo Entregues", 	"U_PR_NAO()", 	0,2},;
                   	{"Saldos por Grupo",		"U_PR_SALG()",	0,2}}

aRotina   :=    { 	{"Pesquisar",             	'AxPesqui',		00,01},;
					{"Comprar",           		'U_PR_COM()',	00,08},;
	                {"TOTALizar",         		'U_PR_TOT()',	00,03},;
	    			{"Gerar Pedidos",          	'U_PR_PED()',	00,08},;
	    			{"F4-HistСrico",       		'U_PR_HIS()',	00,08},;
                  	{"Consultas",               aRotina2,		00,02,0 ,Nil},;
                  	{"SugestЦo",               	'U_PR_SUG()' ,	00,06},;
                  	{"PreГo FamМlia",         	'U_PR_FAM()',	00,07},;
                  	{"Incluir Produto",     	'U_PR_INCP()',	00,07},;
                  	{"Fora de Linha",        	'U_PR_FORL()',	00,07},;
                  	{"Legenda",           		'U_PR_LEG()',	00,09}}
	
If Pergunte("FIC030",.T.)
   ALTERA   	:=	.T.
   INCLUI  		:= 	.F.
   LF030TITAB	:=	.F.
   LF030TITPG	:=	.F.
   NVLGERALNF	:=	0
   FC030CON(ZXC->ZXC_FORNEC,ZXC->ZXC_LOJA)
EndIf

RestArea(aArea3_4)
Return()
************************************************************
Static Function MostraCadFor(SA2Recno)
************************************************************
//зддддддддддддддддддддддддддддддддд©
//Ё Visualiza Cadastro do Fornecedor|
//Ё Chamada -> Visual_XML()         Ё
//юддддддддддддддддддддддддддддддддды

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
Static Function VisualNFE()
************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//|	Quando ja foi gerado o Doc.Entrada do XML  apenas	|
//Ё Visualiza Pre-Nota\Doc.Entrada  					|
//Ё Chamada -> Visual_XML()         					Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aArea3_6  := GetArea()

DbSelectArea('ZXC')
DbSelectArea('SF1');DbSetOrder()
If DbSeek(xFilial('SF1')+ZXC->ZXC_DOC + ZXC->ZXC_SERIE + ZXC->ZXC_FORNEC + ZXC->ZXC_LOJA, .F.)
                                                                                 
	nSF1Recno := SF1->(Recno())

   //зддддддддддддддддддддддддддддддддд©
   //Ё    VISUALIZA NOTA FISCAL        Ё
   //юддддддддддддддддддддддддддддддддды
   MsgRun("Localizando DOC.ENTRADA para VISUALIZAгцO...",,{|| A103NFiscal('SF1', nSF1Recno, 2) })

      
Endif

RestArea(aArea3_6)
Return()
*****************************************************************
Static Function GeraPreDoc()
*****************************************************************
//зддддддддддддддддддддддддддддддддд©
//Ё Gera Pre-Nota\Doc.Entrada       |
//Ё Chamada -> Visual_XML()         Ё
//юддддддддддддддддддддддддддддддддды
Local aArea3_7  	:=	GetArea()
Local cCondPag   	:= 	Space(3)
Local cDuplic		:=	Space(1)
Local _cNatureza	:=	TamSx3('A2_NATUREZ')[1]
Local cNaoIdent  	:=	''
Local cUfOrig    	:=	''
Local cTipo			:=	'N'
Local cFormul		:=	'N'
Local aCabec    	:=	{}
Local aItens    	:=	{}
Local aLinha    	:=	{}
Local cRet       	:=	.F.
Local lMsErroAuTo	:=	.F.
Local lRetorno    	:=	.F.
Local lRet 			:= 	.F.
Local lCondPag		:=	.F.
Local nPosItem   	:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_ITEM'   })
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
Local nPValIcms		:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_VALICM' })
Local nPPerIcm		:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_PICM'	 })
Local nPBaseIcm		:=	Ascan(aMyHeader  ,{|X| Alltrim(X[2]) == 'D1_BASEICM'})

Local   nZXCRecno	:=	ZXC->(Recno())

Private aDiverg 	:=	{}


//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//| Campos Obrigatorios	e verificacao do NCM, QTD, R$	|
//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
For nX:=1 To Len(oBrwV:aCols)
   
   If Empty(oBrwV:aCols[nX][nPosProd])
       Msgbox("Campo CСdigo-Produtos nЦo esta identificado, corrija primeiro!"+ENTER+ENTER+'Item: '+oBrwV:aCols[nX][nPosItem]+'  -  Produto: '+oBrwV:aCols[nX][nPosProd],"AtenГЦo...","ALERT")
       Return(lRetorno)
	ElseIf Empty(oBrwV:aCols[nX][nPosTES])
		Msgbox("Campo TES nЦo esta identificado, corrija primeiro!"+ENTER+ENTER+'Item: '+oBrwV:aCols[nX][nPosItem]+'  -  Produto: '+oBrwV:aCols[nX][nPosProd],"AtenГЦo...","ALERT")
		Return(lRetorno)
   	//ElseIf !Empty(oBrwV:aCols[nX][nPosPC]) .And. Empty(oBrwV:aCols[nX][nPosPCItem])
    //   Msgbox("Campo Item do Ped. esta em branco, corrija primeiro!"+ENTER+ENTER+'Item: '+oBrwV:aCols[nX][nPosItem]+'  -  Produto: '+oBrwV:aCols[nX][nPosProd],"AtenГЦo...","ALERT")
    //   Return(lRetorno)			
   EndIf

	
	If oCBoxFret:nAT == 1 // FRETE SOBRE COMPRA		-  -  oCBoxFret:nAT == 1 = CONHEC.FRETE

		If Empty(oBrwV:aCols[nX][nPNFOrig])
			Msgbox(ENTER+"NOTA DO TIPO = CONHEC.FRETE"+ENTER+"Preencher os campos Nota\Serie\Item da Nota de Origem."+ENTER+ENTER+'Item: '+oBrwV:aCols[nX][nPosItem]+'  -  Produto: '+oBrwV:aCols[nX][nPosProd],"AtenГЦo...","ALERT")
			Return(lRetorno)
		ElseIf oBrwV:aCols[nX][nPosQuant] > 0
			Msgbox(+ENTER+"Nota de Conhec.Frete NцO deve ser preenchido a QUANTIDADE."+ENTER+ENTER,"AtenГЦo...","ALERT")
			Return(lRetorno)
	    EndIf

	ElseIf oCBoxFret:nAT == 2 // FRETE SOBRE VENDA	 -  oCBoxFret:nAT == 2 = NORMAL
		If !Empty(oBrwV:aCols[nX][nPNFOrig])
			Msgbox(ENTER+"NOTA DO TIPO = NORMAL"+ENTER+"NцO preencher nenhum dos campos NOTA \ SERIE \ ITEM  da Nota de Origem"+ENTER+ENTER,"AtenГЦo...","ALERT")
			Return(lRetorno)
		EndIf

	EndIf   


   	If AllTrim(Posicione("SF4",1,xFilial("SF4")+oBrwV:aCols[1][nPosTES],"F4_DUPLIC")) == 'S'
		lCondPag  := .T.
	EndIf
	

	//здддддддддддддддддддддддддддддддддддддддддддддд©
	//| VERIFICA DIVERGENCIA ENTRE XML E DOC.ENTRADA |
	//юдддддддддддддддддддддддддддддддддддддддддддддды
	//	Aadd(aXMLOriginal, {nItemCTe, Right(cProdFor, TamSx3('D1_COD')[1]), cDescrProd, cNCM, nQuant, nPreco } )
	//							1                   2                            3        4      5       6
	          
	lDiverg	:=	.F.
	nPosXML	:=	Ascan(aXMLOriginal, {|X| X[1] == oBrwV:aCols[nX][nPosItem]} )
	
	If nPosXML > 0
		If oBrwV:aCols[nX][nPosQuant] != aXMLOriginal[nPosXML][5]			//	QUANTIDADE
			lDiverg	:=	.T.
		ElseIf oBrwV:aCols[nX][nPosVunit] != aXMLOriginal[nPosXML][6]		//	VALOR UNITARIO
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


//зддддддддддддддддддддддддддддддддддддддддддддд©
//| Informa DIVERGENCIA ENTRE XML E DOC.ENTRADA |
//юддддддддддддддддддддддддддддддддддддддддддддды
If Len(aDiverg) > 0 

	//здддддддддддддддддддддддддддддд©
	//| TELA INFORMANDO DIVERGENCIAS |
	//юдддддддддддддддддддддддддддддды
	If !TelaDiverg()                                          
		IIF(Select("TMPDIV") != 0, TMPDIV->(DbCLoseArea()), )
		Return(lRetorno)
	EndIf

EndIf


//зддддддддддддддддддддддддддддддддддддддддддддд©
//| Grava status no fornecedor que manda o XML  |
//юддддддддддддддддддддддддддддддддддддддддддддды
If !ZXC->ZXC_TIPO $ 'D\B'
	DbSelectarea("SA2");DbSetOrder(3);DbGoTop()
	If Dbseek(xFilial("SA2")+ZXC->ZXC_CGC, .F.)
	   cUfOrig    :=    SA2->A2_EST
	   If Reclock("SA2",.F.)
	       	SA2->A2_STATUS    :=  "1"
		  MsUnlock()
		EndIf
	Endif
EndIf	

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//| BUSCA COND.PAGAMENTO CADSTRADO NO FORNECEDOR						|
//| CASO NAO TENHA CADASTRADO A COND.PAG - MOSTRA TELA PARA INFORMAR	|
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
SA2->(DbGoTop(), DbSetOrder(3))
If SA2->(DbSeek(xFilial("SA2") + ZXC->ZXC_CGC,.F.))
	cCondPag 	:= 	SA2->A2_COND
	_cNatureza 	:=	SA2->A2_NATUREZ
EndIf
               

//зддддддддддддддддддддддддддддддддддддддддддд©
//Ё	TELA PARA INFORMAR A COND.PAGAMENTO       Ё
//юддддддддддддддддддддддддддддддддддддддддддды
If lCondPag
	cDescCondP := Space(3)
	oFont1     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-09,-11),,.T.,0,,700,.F.,.F.,,,,,, )

	oDlgCondP  := MSDialog():New( D(095),D(232),D(276),D(624),"",,,.F.,,,,,,.T.,,oFont1,.T. )
	oGrp1      := TGroup():New( D(004),D(004),D(064),D(190),"",oDlgCondP,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( D(012),D(008),{||"NЦo hА uma Cond.Pagamento cadastrado para este Fornecedor."},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(200),D(008) )
	oSay2      := TSay():New( D(020),D(008),{||"Selecione a Cond.Pagamento."},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(100),D(008) )
	oSay3      := TSay():New( D(048),D(016),{||"Cond.Pag.:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(032),D(008) )

	oGet1      := TGet():New( D(044),D(056), {|u| If(PCount()>0,cCondPag :=u,cCondPag)},oGrp1,D(050),D(008),'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,{|| IIF(!Empty(cCondPag), cDescCondP:=Posicione('SE4',1,xFilial('SE4')+cCondPag,'E4_DESCRI'),), oSay4:Refresh() },.F.,.F.,,.F.,.F.,"SE4","cCondPag",,)
	oSay4      := TSay():New( D(048),D(110), {|| cDescCondP },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
		
	oBtn1      := TButton():New( D(068),D(048),"OK",oDlgCondP,{|| IIF(ExistCpo("SE4",cCondPag), oDlgCondP:End(),) },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( D(068),D(098),"Cancelar",oDlgCondP,{|| lRet := .T., oDlgCondP:End() },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )
		 
	oGet1:SetFocus()
	oDlgCondP:Activate(,,,.T.)

EndIf

If lRet
	Return(lRetorno)
EndIf




//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё  ARRAY CABEC PARA UTILIZAR NO MSExecAuto	Ё
//юддддддддддддддддддддддддддддддддддддддддддддды
//cTipo 	:= 	IIF(Empty(ZXC->ZXC_TIPO),'C',ZXC->ZXC_TIPO)

cTipo	  := IIF(oCBoxFret:nAT == 1, 'C', 'N') //oCBoxFret:nAT == 2 = NORMAL
cFormul	  := IIF(Empty(cTpFormul),'N',cTpFormul)

_cEspecie := Space(TamSX3('F1_ESPECIE')[1])
If TMPCTE->(FieldPos("ESPXCTE")) > 0  
	If !Empty(TMPCTE->ESPXCTE)
		_cEspecie	:=	AllTrim(TMPCTE->ESPXCTE)
	EndIf
EndIf

Aadd(aCabec,{"F1_TIPO",			cTipo          	, Nil })
Aadd(aCabec,{"F1_DOC",			ZXC->ZXC_DOC 	, Nil })
Aadd(aCabec,{"F1_SERIE",       	ZXC->ZXC_SERIE	, Nil })
Aadd(aCabec,{"F1_FORMUL",       cFormul        	, Nil })
Aadd(aCabec,{"F1_EMISSAO",      dDHEmit			, Nil })
Aadd(aCabec,{"F1_FORNECE",      ZXC->ZXC_FORNEC, Nil })
Aadd(aCabec,{"F1_LOJA",         ZXC->ZXC_LOJA	, Nil })
Aadd(aCabec,{"F1_EST",          cUfOrig			, Nil })
Aadd(aCabec,{"F1_ESPECIE",      _cEspecie		, Nil })
Aadd(aCabec,{"F1_COND",         cCondPag		, Nil })
Aadd(aCabec,{"F1_CHVNFE",       ZXC->ZXC_CHAVE	, Nil })
Aadd(aCabec,{"F1_HORA",         Left(Time(),5)	, Nil }) 
Aadd(aCabec,{"F1_TPCTE" ,       'N'         	, Nil })          //Roger


If SF1->(FieldPos("F1_TRANSP")) > 0  //.And. !Empty(cTranspCgc)
	cCodTransp := Posicione("SA4",3,xFilial("SA4")+ZXC->ZXC_FORNEC,"A4_COD")
	If !Empty(cCodTransp)
		Aadd(aCabec,{"F1_TRANSP", cCodTransp , Nil })
	EndIf
EndIf
                      
If SF1->(FieldPos("F1_CHVNFE")) <> 0  .And. !Empty(cChCTe) .And. Empty(ZXC->ZXC_CHAVE)
	Aadd(aCabec,{"F1_CHVNFE",  cChCTe , Nil })
EndIf


/*
If SF1->(FieldPos("F1_PLACA")) > 0 .And. !Empty()
	Aadd(aCabec,{"F1_PLACA",  cPlaca , Nil })
EndIf
If SF1->(FieldPos("F1_ESPECI1")) > 0 .And. !Empty(cEspecie)
	Aadd(aCabec,{"F1_ESPECI1", cEspecie , Nil })
EndIf

If SF1->(FieldPos("F1_VOLUME1")) > 0 .And. !Empty(cVolume)
	Aadd(aCabec,{"F1_VOLUME1",  Val(cVolume), Nil })
EndIf
If SF1->(FieldPos("F1_PLIQUI")) > 0 .And. !Empty(cPLiquido)
	Aadd(aCabec,{"F1_PLIQUI" ,  Val(cPLiquido), Nil })
EndIf
If SF1->(FieldPos("F1_PBRUTO")) > 0 .And. !Empty(cPBruto)
	Aadd(aCabec,{"F1_PBRUTO" ,  Val(cPBruto), Nil })
EndIf
If SF1->(FieldPos("F1_TPFRETE")) > 0 .And. !Empty(cTpFrete)    
	Aadd(aCabec,{"F1_TPFRETE" ,  IIF(AllTrim(cTpFrete)=='1','C','F') 	, Nil })
EndIf
*/

/*
If SF1->(FieldPos("F1_FORRET")) > 0
	Aadd(aCabec,{"F1_FORRET" ,   	, Nil })
EndIf
If SF1->(FieldPos("F1_LOJRET")) > 0
	Aadd(aCabec,{"F1_LOJRET" ,   	, Nil })
EndIf
*/
//F1_FORRET - Fornecedor Retirada     
//F1_LOJRET  - Loja Retirada           


//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё  ARRAY ITEM  PARA UTILIZAR NO MSExecAuto	Ё
//юддддддддддддддддддддддддддддддддддддддддддддды
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

			ElseIf AllTrim(aMyHeader[nPaCols][2]) == 'D1_ITEMPC' .And. !Empty(oBrwV:aCols[nLin][nPosPCItem])
				Aadd(aLinha,{'D1_ITEMPC',	oBrwV:aCols[nLin][nPosPCItem],	Nil })  
							
			ElseIf AllTrim(aMyHeader[nPaCols][2]) == 'D1_TES' 
   				Aadd(aLinha,{'D1_TES',		oBrwV:aCols[nLin][nPosTES],		Nil	})

   			ElseIf AllTrim(aMyHeader[nPaCols][2]) == 'D1_NFORI' .And. !Empty(oBrwV:aCols[nLin][nPNFOrig])
			   	Aadd(aLinha,{'D1_NFORI', 	oBrwV:aCols[nLin][nPNFOrig], 	Nil	})     
			   	
   			ElseIf AllTrim(aMyHeader[nPaCols][2]) == 'D1_SERIORI' .And. !Empty(oBrwV:aCols[nLin][nPSeriOri])
			   	Aadd(aLinha,{'D1_SERIORI', 	oBrwV:aCols[nLin][nPSeriOri],	Nil	})                       
   			
   			ElseIf AllTrim(aMyHeader[nPaCols][2]) == 'D1_ITEMORI' .And. !Empty(oBrwV:aCols[nLin][nPItemOri])
			   	Aadd(aLinha,{'D1_ITEMORI', 	oBrwV:aCols[nLin][nPItemOri],	Nil	})

			ElseIf !Empty(oBrwV:aCols[nLin][nPaCols]) .And.  Left(AllTrim(aMyHeader[nPaCols][2]), 3) == 'D1_' //'C7_PRODUTO/B1_DESCFOR/B1_POSIPI' )
					Aadd(aLinha,{ AllTrim(aMyHeader[nPaCols][2]),	oBrwV:aCols[nLin][nPaCols], Nil }) 
			EndIf
			
		EndIf   
	Next   

   	Aadd(aItens, aLinha)
   	
Next



//зддддддддддддддддддддддддд©
//Ё  GRAVA DOC. ENTRADA		Ё
//юддддддддддддддддддддддддды
If Len(aCabec) > 0 .And. Len(aItens) > 0

	BEGIN TRANSACTION
	
		
		DbSelectArea('SF1')
		MsAguarde( {|| MSExecAuto({|x, y, z, w, a | MATA103(x, y, z, w, a )}, aCabec,  aItens, 3, .T.)    },'Processando','Gerando Documento de Entrada...' )
		
		
		//зддддддддддддддддддддддддддддддддддддд©
		//Ё  ERRO AO TENTAR GRAVAR DOC.ENTRADA	|
		//юддддддддддддддддддддддддддддддддддддды
		If lMsErroAuto
			MostraErro()
			DisarmTransaction()
			MsgAlert('DOCUMENTO NцO GRAVADO !!!' )

		Else
			

			//зддддддддддддддддддддддддддддд©
			//Ё  TENTA GRAVAR DOC.ENTRADA	|
			//юддддддддддддддддддддддддддддды
			DbSelectArea('ZXC') 
			If ZXC->(Recno()) != nZXCRecno
				DbGoTo(nZXCRecno)
			EndIf
			      

			cSF1ChaveXML := ZXC->ZXC_DOC + ZXC->ZXC_SERIE + ZXC->ZXC_FORNEC + ZXC->ZXC_LOJA + cTipo


			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё VERIFICA SE USUARIO CONFIRMOU A PRE-NOTA \ DOC.ENTRADA  Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea('SF1');DbSetOrder(1);DbGoTop()    //    F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNEC +F1_LOJA+F1_TIPO
			If DbSeek( xFilial('SF1') + cSF1ChaveXML, .F.)
			
				DbSelectArea('ZXC')
				If Reclock('ZXC',.F.)
						lGravado		:=	.T.
						ZXC->ZXC_STATUS	:=	'G'    // XML GRAVADO + NFENTRADA
						ZXC->ZXC_DTNFE	:=	dDataBase
		                ZXC->ZXC_TIPO   :=  cTipo
		                If Empty(ZXC->ZXC_TPFRET)
							ZXC->ZXC_TPFRET :=	IIF(Type('oCBoxFret:oWnd')!='O','', IIF(oCBoxFret:nAT == 1, 'E', 'S') )
						EndIf
						If Empty(ZXC->ZXC_TIPO)
							ZXC->ZXC_TIPO	:=	IIF(!Empty(cTipoNFe),cTipoNFe, IIF(Type('oCBoxFret:oWnd')!='O','',IIF(oCBoxFret:nAT == 1, 'C', 'N')) ) // oCBoxFret:nAT == 1=CONHEC.FRETE, 2= NORMAL;				
                        EndIf
					MsUnlock() 
				EndIf
				
				
				lRetorno    :=    .T.
				MsgInfo('DOC.ENTRADA: '+AllTrim(SF1->F1_DOC)+' - SИrie: '+AllTrim(SF1->F1_SERIE)+'  gerado com sucesso !!!')
				
			
			Else                                                  
				//зддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё		CANCELOU A GRAVACAO DO DOC.ENTRADA      Ё
				//юддддддддддддддддддддддддддддддддддддддддддддды
				If Aviso('Documento nЦo gravado',ENTER+'Deseja verifica se houve erro?',{'Erro','Sair'}, 2) == 1
					MostraErro()
				EndIf
				
			EndIf
				
		Endif
	
	END TRANSACTION

Endif

oBrwV:oBrowse:Refresh()
oBrwV:Refresh()



SetKey( VK_F12, {|| Aviso('Chave CT-e', ZXC->ZXC_CHAVE ,{'Ok'},3) })
SetKey( VK_F11, {|| ExecBlock("CTe_Visual" ,.F.,.F.,{"FRETE_COMPRA"})  })		//	Sobre Compra
SetKey( VK_F8,  {|| MATA116(), })	   	//	NF.Conhec.Frete
SetKey( VK_F9,  {|| ExecBlock("CTe_Visual" ,.F.,.F.,{"FRETE_VENDA"})  })		//	Sobre Venda



RestArea(aArea3_7)
Return(lRetorno)  
************************************************************
Static Function TelaDiverg()
************************************************************
//здддддддддддддддддддддддддддддд©
//| TELA INFORMANDO DIVERGENCIAS |
//| GeraPreDoc()				 |
//юдддддддддддддддддддддддддддддды

Local lRet := .T.

SetPrvt("oFont1","oDlgDiverg","oGrp1","oBrwD","oBtnOK","oBtnRet",'oSayClik')

oFont1     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-10,-12),,.F.,0,,700,.F.,.F.,,,,,, )

oDlgDiverg := MSDialog():New( D(095),D(232),D(363),D(1000),"DivergЙncia",,,.F.,,,,,,.T.,,oFont1,.T. )
oGrp1      := TGroup():New( D(004),D(004),D(110),D(380),"",oDlgDiverg,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayClik 	:= TSay():New( D(006),D(008),{|| 'Duplo click para alterar' },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(120),D(008))


oTblDiverg()
DbSelectArea("TMPDIV")

oBrw1      := MsSelect():New( "TMPDIV","","", {{"ITEM","","Item",""},{"PRODFOR","","Prod.Fornec",""},{"PRODEMP","","Produto",""},{"DESCR","","DescriГЦo",""},;
												{"NCM_XML","","NCM no XML",""},{"NCM","","NCM Informado",""},;
												{"QTD_XML","","Quant. no XML","@E 99999999.9999"},{"QUANT","","Quant.Informado","@E 99999999.9999"},;	
												{"PRECOXML","","PreГo no XML","@E 9,999,999.999999"},{"PRECO","","PreГo Informado","@E 9,999,999.999999"}};
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
/*
			Aadd(aXMLOriginal, {nItemCTe, Right(cProdFor, TamSx3('D1_COD')[1]), \, cNCM, nQuant, nPreco } )
				
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

*/							

TMPDIV->(DbGoTop())    
Return()
************************************************************
Static Function AlteraDiverg()
************************************************************
SetPrvt("oFont1","oDlg","oGrp0","oSayProd","oSay1","oSay2","oGrp1","oSay3","oSay4","oGrp2","oSay5","oSay6")
SetPrvt("oBtn2")

oFont2     := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )

oDlg       := MSDialog():New( 199,243,385,1018,"DivergЙncia NCM",,,.F.,,,,,,.T.,,oFont2,.T. )
oGrp0      := TGroup():New( 005,005,064,380,"",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( 010,011,{|| "ITEM:"},oGrp0,,oFont2,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,030,010)
oSay2      := TSay():New( 010,030,{|| TMPDIV->ITEM },oGrp0,,oFont2,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,020,010)

oGrp1      := TGroup():New( 020,010,057,189,"XML",oDlg,CLR_HBLUE,CLR_WHITE,.T.,.F. )
oSay7      := TSay():New( 030,013,{|| 'Produto:  '+AllTrim(TMPDIV->PRODFOR) +' - '+ AllTrim(TMPDIV->DESCR) },oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,160,008)
oSay3      := TSay():New( 042,013,{|| "NCM:"},oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,022,010)
oSay4      := TSay():New( 042,033,{|| AllTrim(TMPDIV->NCM_XML) +'  -  '+Posicione("SYD",1,xFilial("SYD") + TMPDIV->NCM_XML, "YD_DESC_P") },oGrp1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,148,010)

oGrp2      := TGroup():New( 021,194,057,373,"Cad.Poduto",oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )
oSay8      := TSay():New( 030,196,{|| 'Produto:  '+AllTrim(TMPDIV->PRODEMP) +' - '+ AllTrim(Posicione('SB1',1,xFilial('SB1')+TMPDIV->PRODEMP,'B1_DESC')) },oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,172,008)
oSay5      := TSay():New( 042,196,{|| "NCM:"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,032,008)
oSay6      := TSay():New( 042,217,{|| AllTrim(TMPDIV->NCM) +'  -  '+Posicione("SYD",1,xFilial("SYD") + TMPDIV->NCM, "YD_DESC_P") },oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,148,008)

oBtn1      := TButton():New( 072,140,"Alterar",oDlg, {|| AlteraNCM(),oDlg:End() },036,012,,oFont2,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 072,208,"Cancelar",oDlg,{|| oDlg:End()  },037,012,,oFont2,,.T.,,"",,,,.F. )


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
				MsgYesNo('Outro usuАrio esta utilizando o cadastro deste produto'+ENTER+'Deseja aguardar alguns instantes?')
				InKey(2)
			EndIf

		EndDo
		
	EndIf


Else
	MsgInfo('AlteraГЦo NцO realizada.')
EndIf

Return()
*****************************************************************
User Function CTe_Carrega()
*****************************************************************
Local	aAlias4  := GetArea()
Private	cTpCarga :=	''


nOpc := Aviso('Carregar CT-e','Deseja Carregar CT-e de uma Pasta ou do Email???',{'Pasta','Email','Sair'}, 2)

If nOpc == 1
   MsgRun("Recebendo CT-e PASTA ",,{|| LoadFiles(cTpOpen:='IMPORTAR') })    					
ElseIf nOpc == 2
   Processa ({|| RecebeEmail(cTpOpen:='EMAIL') },"Recebendo XML EMAIL ",'Processando...', .T.)
EndIf


RestArea(aAlias4)
Return()
************************************************************
Static Function LoadFiles()
************************************************************
//зддддддддддддддддддддддддддддддддд©
//Ё Seleciona XML PASTA             Ё
//Ё Chamada -> Carrega_XML()        Ё
//юддддддддддддддддддддддддддддддддды
Private cMarca        	:=	GetMark()
Private nQtdArqXML  	:= 	0
Private aStatus			:= 	{}
Static cDiretorioXML	:=	Space(200)

SetPrvt('oDlg1','oGrp','oSay1','oGet1','oBrw1','oBtn1','oBtn2','oBtn3')



//зддддддддддддддддддддддддддддддддд©
//Ё  ABRE ARQUIVO DE CONFIGURACAO   |
//юддддддддддддддддддддддддддддддддды
*********************************************
	ExecBlock('OpenArqCfg',.F., .F., {} )
*********************************************

DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()
DbSeek(cEmpAnt+cFilAnt, .F.)     

//	COM "\" NO FINAL NAO ENCONTRA O DIRETORIO
cPathXML := AllTrim(TMPCTE->PATH_XML)
If 	Right(cPathXML,1)=='\'
	cPathXML := SubStr(cPathXML,1, Len(cPathXML)-1)
EndIf



//зддддддддддддддддддддддддддддддддд©
//Ё    TELA CARREGA ARQUIVO XML     Ё
//юддддддддддддддддддддддддддддддддды
oDlg1      := MSDialog():New( D(095),D(232),D(427),D(740),"Carregar arquivo XML CT-e",,,.F.,,,,,,.T.,,,.T. )
oGrp       := TGroup():New( D(004),D(004),D(146),D(250),"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( D(012),D(008),{||"Caminho do(s) Arquivo(s)"},oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(064),D(008) )
oGet1      := TGet():New( D(020),D(008),{|u| If(PCount()>0,cDiretorioXML :=u,cDiretorioXML)},oGrp,D(230),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,{|| IIF(!Empty(cDiretorioXML),(AdicionaAnexo(), oBrw1:oBrowse:Refresh()),) },.F.,.F.,"","",,)
oBtn1      := TButton():New( D(018),D(238),"...",oGrp,{|| cDiretorioXML  := 	cGetFile("Anexos (*xml)|*xml|","Arquivos (*xml)",0,cPathXML,.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_MULTISELECT+GETF_RETDIRECTORY),; 
																		IIF(!Empty(cDiretorioXML), Processa ({||AdicionaAnexo(),'Processando....','Carregando Arquivos CT-e',.F.}),), IIF(nQtdArqXML==0, oSay2:Hide(), oSay2:Show()),oBrw1:oBrowse:Refresh() },D(011),D(011),,,,.T.,,"",,,,.F. )

oSay2      := TSay():New( D(034),D(008),{|| AllTrim(Str(nQtdArqXML))+" arquivo(s) selecionado(s)"},oGrp,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(150),D(008) )
IIF(nQtdArqXML==0, oSay2:Hide(), oSay2:Show())
oSay2:Refresh()

****************************
   oTbl()    // CRIAR ARQ. TEMP
****************************
DbSelectArea("TMP")
oBrw1      := MsSelect():New( "TMP","OK","",{{"OK","","",""},{"ARQUIVO","","Arquivo",""}},.F.,cMarca,{D(040),D(008),D(140),D(245) },,, oGrp )

oBtn2      := TButton():New( D(150),D(086),"Ok"  ,oDlg1,{|| Processa ({|| Open_Xml('XML_TMP','','', cDiretorioXML,0,0)},'Verificando Arquivos XML CT-e','Processando...', .F.) ,oDlg1:End() },D(037),D(012),,,,.T.,,"",,,,.F. )
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
Static Function oTbl()
************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria\Limpa Arq. Temp            			Ё
//Ё Chamada -> Carrega_XML()->LoadFiles()       Ё
//юддддддддддддддддддддддддддддддддддддддддддддды
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
Static Function AdicionaAnexo()
***********************************************************
//здддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Adiciona no Browser os itens XML de uma pasta  |
//Ё Chamada -> Carrega_XML()->LoadFiles()          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддды
Local    aArqXml     :=    {}


If !Empty(cDiretorioXML)
	nQtdArqXML    := 0
	cDiretorioXML := cDiretorioXML+IIF(Right(AllTrim(cDiretorioXML),1)=='\','','\')
 //	aDir(AllTrim(cDiretorioXML)+'*.xml',aArqXml) // Roger                     
    aFiles := Directory(AllTrim(cDiretorioXML)+'*.xml', "")
    aEval(aFiles, {|X| Aadd(aArqXml, X[1] )} )
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
Static Function MarcaTMP(cPar)
***********************************************************
//здддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Desmarca TODOS os itens do Browse              |
//Ё Chamada -> Carrega_XML()->LoadFiles()          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддды
nQtdArqXML := 0
DbSelectArea('TMP');DbGoTop()
_cFlag    :=    IIF(!Empty(TMP->OK), cMarca,'')
Do While TMP->(!Eof())
   If !Empty(_cFlag)
       nQtdArqXML := 0
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
Static Function Des_MarcaTMP()
***********************************************************
//здддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Marca\Desmarca itens do Browse                 |
//Ё Chamada -> Carrega_XML()->LoadFiles()          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддды
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
Static Function LimpaTMP()
***********************************************************
//здддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Limpa Arq.Temp                                 |
//Ё Chamada -> Carrega_XML()->LoadFiles()          Ё
//Ё         -> oTbl(), AdicionaAnexo()             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддды

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
//зддддддддддддддддддддддддддддддддд©
//Ё Busca XML do EMAIL              Ё
//Ё Chamada -> Carrega_XML()        Ё
//юддддддддддддддддддддддддддддддддды


Private cTpConexao	:=	''
Private cServerEnv    :=	''
Private cServerRec    :=	''
Private cPassword    	:=	''
Private cAccount     	:=	''
Private cOrigFolder	:=	''
Private cDestFolder	:=	''
Private cPortEnv    	:=	''
Private cPortRec    	:=	''
Private nNumMsg		:= 	0
Private aAllFolder	:= 	{}
Private lConect		:=	.F.
Private lCreateFolder	:=	.F.
Private lMoveEmail	:=	.F.
Private lAutent
Private lSegura
Private lSSL
Private lTLS

Private nConfig
Private nConecTou

Private oMsg
Private oServer
Private aStatus    := {}

                      

//зддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁBUSCA AS CONFIGURACOES DEFINIDAS PELO USUARIOS Ё
//ЁNO PAINEL DE CONFIGURACAO                      Ё
//юддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()
If DbSeek(cEmpAnt+cFilAnt, .F.)

	cTpConexao	:=	Left( AllTrim(TMPCTE->TIPOEMAIL),3)
	cServerEnv	:=	AllTrim(TMPCTE->SERVERENV)
	cServerRec	:=	AllTrim(TMPCTE->SERVERREC)
	cPassword	:=	AllTrim(TMPCTE->SENHA)
	cAccount	:=	AllTrim(TMPCTE->EMAIL)
	cOrigFolder	:=	AllTrim(TMPCTE->PASTA_ORIG)
	cDestFolder	:=	AllTrim(TMPCTE->PASTA_DEST)
	cPortEnv	:=	AllTrim(TMPCTE->PORTA_ENV)
	cPortRec	:=	AllTrim(TMPCTE->PORTA_REC)
	lAutent		:=	TMPCTE->AUTENTIFIC
	lSegura		:=	TMPCTE->SEGURA
	lSSL		:=	TMPCTE->SSL
	lTLS		:=	TMPCTE->TLS
	
Else                

   MsgInfo('NЦo encontrado arquivo de configuraГЦo da Empresa: '+cEmpAnt+' \ Filial: '+cFilAnt+ENTER+ENTER+'Utilize o BotЦo de ConfiguraГЦo...')
   Return()

EndIf



oServer := TMailManager():New()

If lSegura
	oServer:SetUseSSL(lSSL)					//		Define o envio de e-mail utilizando uma comunicaГЦo segura atravИs do SSL - Secure Sockets Layer.
	oServer:SetUseTLS(lTLS)					//		Define no envio de e-mail o uso de STARTTLS durante o protocolo de comunicaГЦo.
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
Else
	nConecTou := 1  // Operation failed.
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
       MsgBox(	"NЦo foi possМvel ler emails da conta..."+ENTER+; 
       			"Servidor Recebimento: "+cServerRec+ENTER+;
           		"Servidor Envio: "    +cServerEnv+ENTER+;
				"UsuАrio:  "    +cAccount+ENTER+;
				"Porta "    +cTpConexao+": "+cPortRec+ENTER+;
				"Porta SMTP: "+cPortEnv+ENTER+ENTER+;
				"ERRO: "    +AllTrim(oServer:GetErrorString(nConecTou)) +ENTER+ENTER+;
				"Verifique a configuraГЦo de e-mail da filial.") 

Else


   //здддддддддддддддддддддддддддддд©
   //Ё VERIFICA SE PASTAS EXISTEM   Ё
   //юдддддддддддддддддддддддддддддды
   aAllFolder        :=    oServer:GetAllFolderList()        //    MOSTRA TODAS  AS PASTAS
   lCreateFolder    := .F.

   If cTpConexao == 'IMAP'

	   //здддддддддддддддддд©
	   //Ё PASTA DE ORIGEM	Ё
	   //юдддддддддддддддддды
       If !Empty(cOrigFolder)
           nPosFolder    :=    Ascan(aAllFolder, { |x| Upper(X[1]) == IIF(cOrigFolder=='Caixa de Entrada','INBOX', Upper(cOrigFolder) )} )
           If nPosFolder == 0
               If MsgYesNo('Pasta de Origem '+cOrigFolder+' nЦo existe...'+ENTER+'Deseja criar essa pasta ???')
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


	   //здддддддддддддддддд©
	   //Ё PASTA DE DESTINO	Ё
	   //юдддддддддддддддддды
       If !Empty(cDestFolder)
           lMoveEmail    :=    .T.
           nPosFolder    :=    Ascan(aAllFolder, { |x| Upper(X[1]) == Upper(cDestFolder) })
           If nPosFolder == 0
               If MsgYesNo('Pasta de Destino '+cDestFolder+' nЦo existe...'+ENTER+'Deseja criar essa pasta ???')
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


		lDelMsg := .F.
		
       	//здддддддддддддддддддддддддддддд©
       	//Ё  VERIFICA O TIPO DO ANEXO    Ё
       	//юдддддддддддддддддддддддддддддды
		For nY := 1 To oMsg:GetAttachCount()

           	aInfo        :=    {}
			aInfo        :=    oMsg:GetAttachInfo(nY)
			If Right(aInfo[1], 4) == '.xml'

               	cAnexo :=  oMsg:GetAttach(nY)

                   
               //здддддддддддддддддддддддддддддддддддддд©
               //Ё    ABRE E GRAVA ARQUIVO XML          Ё
               //юдддддддддддддддддддддддддддддддддддддды
               ***********************************************
                   lDelMsg := Open_Xml('XML_EMAIL', cAnexo, AllTrim(oMsg:cSubject)+' - '+AllTrim(aInfo[1]), '', nX, nNumMsg)
		       ***********************************************

               	If cTpCarga == 'EMAIL' .And. cTpConexao == 'IMAP'

                   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
                   //ЁMove uma mensagem da pasta em uso, do servidor IMAP         Ё
                   //Ёpara outra pasta contida na conta de e-mail.                |
                   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
                   If lMoveEmail
                       oServer:MoveMsg(nX, cDestFolder)

                   EndIf
				
				EndIf

			EndIf

		Next
        
        //	DELETA MSG DE E-MAIL
		If lDelMsg
			oServer:DeleteMsg(nX)
		EndIf

	Next


Endif
                


//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё MOSTRA TELA COM STATUS DA IMPORTACAO DO XML  Ё
//|	XML IMPORTADO VIA E-MAIL					 |
//юдддддддддддддддддддддддддддддддддддддддддддддды
If Len(aStatus) > 0
   ******************************
       MensStatus()	
   ******************************
EndIf


//зддддддддддддддддддддддддддддд©
//Ё DESCONECTA DE E-MAIL		|
//юддддддддддддддддддддддддддддды
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
Static Function Open_Xml(cTpOpen, cAnexo, cNomeArq, cDiretorioXML, nImportados, nMarcados)
*******************************************************************
//зддддддддддддддддддддддддддддддддддддддддд©
//Ё Abre XML                                Ё
//Ё Chamada -> LoadFiles()-> RecebeEmail()  |
//юддддддддддддддддддддддддддддддддддддддддды
Local _lRet		    := .F.
Private cDirArqXML 	:= ''
Private cArqCTe 	:= ''


//зддддддддддддддддддддддддддд©
//ЁBUSCA XML PELO DIRETORIO   Ё
//юддддддддддддддддддддддддддды
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
			IncProc('Importando arquivos CT-e... '+ AllTrim(Str(nImportados))+' de '+ AllTrim(Str(nMarcados))  )
	
			cDirArqXML	:=	AllTrim(TMP->ARQUIVO)
			cArqCTe	:=	''
	        
	        ProcRegua(Len(cArqCTe))
			
			//зддддддддддддддддддддддддддддддддд©
			//ЁREALIZA A LEITURA DO ARQUIVO XML Ё
			//юддддддддддддддддддддддддддддддддды
			If File(AllTrim(cDiretorioXML)+cDirArqXML)
				FT_FUSE(AllTrim(cDiretorioXML)+cDirArqXML)
				FT_FGOTOP()
				Do While !FT_FEOF()
					cArqCTe += FT_FREADLN()
					FT_FREADLN()
					FT_FSKIP()
	    		EndDo
	            FT_FUSE()
	
				//зддддддддддддддддддддддддддддддддд©
				//Ё REALIZA VERIFICACOES E GRAVA XMLЁ
				//юддддддддддддддддддддддддддддддддды
				******************************************************
					Grava_CTe(cArqCTe, cDirArqXML, nImportados, nMarcados)
				******************************************************
				
				
				If aStatus[Len(aStatus)][1] $ 'I/G'
					//зддддддддддддддддддддддддддддддддддддддддд©
					//Ё RENOMEA XML PARA NOMEXML_IMPORTADO		Ё
					//юддддддддддддддддддддддддддддддддддддддддды
						Renomea_XML(Len(aStatus))
					
				EndIf
	            
			EndIf
		EndIf
	
		IncProc()
		DbSelectArea('TMP')
		DbSkip()
	
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё JA IMPORTOU TODOS OS ARQUIVOS MARCADOS...        Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддды
		If nImportados == nMarcados
			Exit
		EndIf

	EndDo           
	
    TMP->(DbGoTop())


ElseIf cTpOpen == 'XML_EMAIL'
	//зддддддддддддддддддддддддддд©
	//ЁBUSCA XML PELO E-MAIL	  Ё
	//юддддддддддддддддддддддддддды
	
   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё NAO PRECISA ABRIR O XML E LER LINHA A LINHA...                     |
   //| NA FUNCAO QUE ABRE O ANEXO DO EMAIL JA VEM TODA A ESTRUTURA DO XML |
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   ****************************************
      _lRet := Grava_CTe(cAnexo, AllTrim(cNomeArq),nImportados, nMarcados, cDiretorioXML, cTpOpen )
   ****************************************

EndIf

Return(_lRet)
***********************************************************
Static Function Grava_CTe(cArqCTe, cDirArqXML, nImportados, nMarcados, cDiretorioXML, cTpOpen )
***********************************************************
Local cDestEmpAnt	:=	''
Local cDestFilial	:=	''
Local cStatus		:=	''
Local cDocSF1		:=	''
Local cSerieSF1   	:=	''
Local cCodSA2    	:=	''
Local cLojaSA2    	:=	''
Local cNomeSA2     	:=	''
Local cTipoNFe		:=	''
Local cError        :=	''
Local cWarning      :=	''
Local cRest			:=	''
Local cSA2Modo:=cSF1Modo:=cZXCModo:=cZXDModo:=''
Local dDtEntrada    :=	StoD('  \  \  ')
Local lStatus		:=	.F.
Local lEntrada		:=	.F.
Local _lRetGrava    :=  .F.

Private dDHEmit    :=	''
Private cEmitCnpj   :=	''
Private cEmitNome   :=	''
Private cDestNome   :=	''
Private cDestCnpj   :=	''
Private cNotaXML    :=	''
Private cSerieXML   := 	''
Private cCTeChave   :=	''
Private cNatOper    :=	''

Private cError		:=	''
Private cWarning	:=	''
Private aCTe		:= {}

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//| VERIFICA SE TABELAS SAO COMPARTILHADAS OU EXCLUSIVAS	|
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('SA2'))
   cSA2Modo	:=	AllTrim(SX2->X2_MODO)
EndIf
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('SF1'))
   cSF1Modo	:=	AllTrim(SX2->X2_MODO)
EndIf
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('ZXC'))
   cZXCModo	:=	AllTrim(SX2->X2_MODO)
EndIf
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('ZXD'))
   cZXDModo	:=	AllTrim(SX2->X2_MODO)
EndIf
					

//зддддддддддддддддддддддддддддд©
//Ё     ABRE CTe - CABEC        Ё
//юддддддддддддддддддддддддддддды
**************************************************************************************
    aRet := ExecBlock("CabecCTeParser",.F.,.F., { IIF(Empty(cArqCTe),'Erro',cArqCTe)} )
**************************************************************************************

If aRet[1] == .T.	//	aRet[1] == .F. SIGNIFICA XML COM PROBLEMA NA ESTRUTURA


   	nPos := Ascan(_aEmpFil, { |X| X[3] == cEmpCnpj /*cRemCnpj*/ } ) 
	If nPos == 0 

       	//зддддддддддддддддддддддддддддддддддддддд©
       	//Ё NAO ENCONTROU O CNPJ DO DESTINATARIO  Ё
       	//юддддддддддддддддддддддддддддддддддддддды
       	cStatus	:=    'C'
       	lStatus	:=	.T.
		Aadd(aStatus, {cStatus, cDirArqXML, Transform(cEmpCnpj /*cRemCnpj*/, IIF(Len(cEmpCnpj/*cRemCnpj*/)==14,'@R 99.999.999/9999-99','@R 999.999.999-99'))  +' - '+ cEmpCnpj/*cRemCnpj*/, cDiretorioXML, cDestCnpj })
        
    EndIf
    
	
	If nPos > 0


		//зддддддддддддддддддддддддддддддддддддддд©
		//Ё SALVA EMPRESA\FILIAL\NOME DESTINO     Ё
		//юддддддддддддддддддддддддддддддддддддддды
		cDestEmpAnt    :=    _aEmpFil[nPos][1]
		cDestFilial    :=    _aEmpFil[nPos][2]
		cNomeEmpFil    :=    _aEmpFil[nPos][4]
		cNomeFilial    :=    _aEmpFil[nPos][5]



		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё VERIFICA SE XML Eh PARA A MESMA EMPRESA QUE ESTA POSICIONADO  				|
		//Ё CASO XML FOR IMPORTADO PELA EMPRESA 01 E O XML SEJA PARA EMPRESA 02			|
		//| ABRE-SE AS TABELAS DA EMPRESA 02... NO FINAL DA ROTINA VOLTA PARA EMPRESA 01	|
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If cDestEmpAnt != cEmpAnt


			//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё VERIFICA SE TABELA ZXC ESTA COM TODOS CAMPOS CRIADOS |
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()
           	If DbSeek(cDestEmpAnt+cDestFilial, .F.)


				If !TMPCTE->ESTRUT_ZXC


					If !ExecBlock("CreateTable",.F.,.F.,{cDestEmpAnt} )

						//здддддддддддддддддддддддддддддддддддддддддд©
                       	//Ё TABELA ZXC NAO EXISTE NA EMPRESA DESTINO |
                       	//юдддддддддддддддддддддддддддддддддддддддддды
                       	cStatus  :=  'X'
                       	lStatus	:=	.T.
                       	Aadd(aStatus, {cStatus, cDirArqXML, cDestEmpAnt, cNomeEmpFil, cNomeFilial, cDiretorioXML, cEmpCnpj /*cRemCnpj*/ /*cDestCnpj*/ })

						//здддддддддддддддддддддддддддддддддддддддддд©
						//Ё RETORNA COM TABELAS DA EMPRESA ATUAL     Ё
						//юдддддддддддддддддддддддддддддддддддддддддды
						IIF(Select("SA2") != 0, SA2->(DbCLoseArea()), )
						IIF(Select("SF1") != 0, SF1->(DbCLoseArea()), )
						IIF(Select("ZXC") != 0, ZXC->(DbCLoseArea()), )
						IIF(Select("ZXN") != 0, ZXN->(DbCLoseArea()), )
						
						EmpOpenFile('SA2',"SA2",1,.T.,cEmpAnt,@cSA2Modo)
						EmpOpenFile('SF1',"SF1",1,.T.,cEmpAnt,@cSF1Modo)
						EmpOpenFile('ZXC',"ZXC",1,.T.,cEmpAnt,@cZXCModo)
						EmpOpenFile('ZXN',"ZXN",1,.T.,cEmpAnt,@cZXNModo)
						
						Return()

					EndIf

				EndIf

				//зддддддддддддддддддддддддддддддддддддддд©
				//Ё FECHA ARQUIVOS DA EMPRESA ATUAL       Ё
				//юддддддддддддддддддддддддддддддддддддддды
				IIF(Select("SA2") != 0, SA2->(DbCLoseArea()), )
				IIF(Select("SF1") != 0, SF1->(DbCLoseArea()), )
				IIF(Select("ZXC") != 0, ZXC->(DbCLoseArea()), )
				IIF(Select("ZXN") != 0, ZXN->(DbCLoseArea()), )

				//зддддддддддддддддддддддддддддддддддддддд©
				//Ё ABRE ARQUIVOS DA EMPRESA DESTINO      Ё
				//юддддддддддддддддддддддддддддддддддддддды
				EmpOpenFile('SA2',"SA2",1,.T.,cDestEmpAnt,@cSA2Modo)
				EmpOpenFile('SF1',"SF1",1,.T.,cDestEmpAnt,@cSF1Modo)
				EmpOpenFile('ZXC',"ZXC",1,.T.,cDestEmpAnt,@cZXCModo)
				EmpOpenFile('ZXN',"ZXN",1,.T.,cDestEmpAnt,@cZXNModo)
   
			Else
		
				MsgAlert('NЦo encontrado Empresa: '+cDestEmpAnt+'\'+cNomeEmpFil+' Filial: '+cDestFilial+'-'+cNomeFilial+' no arquivo CTE_CFG.DBF')
				Aadd(aStatus, {'XX', cDirArqXML, 'NЦo encontrado Empresa: '+cDestEmpAnt+'\'+cNomeEmpFil+' Filial: '+cDestFilial+'-'+cNomeFilial+' no arquivo CTE_CFG.DBF','','' })
				Return()      
			
			EndIf
        
        EndIf
	
	EndIf



	//зддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё  VERIFICA CONFIGURACAO DA EMPRESA ATUAL     Ё
	//юддддддддддддддддддддддддддддддддддддддддддддды
    DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()
 	If DbSeek(cEmpAnt + cFilAnt, .F.) .And. !lStatus

		//зддддддддддддддддддддддддддддддддддддддддддддд©
      	//Ё ATUALIZA VARIAVEIS CONFORME CNOFIGURACOES   Ё
       	//|	NOTA E SERIE - SE PREENCHE COM ZEROS OU NAO |	
       	//юддддддддддддддддддддддддддддддддддддддддддддды
       	cNumCTe :=  IIF(TMPCTE->NFE_9DIG=='SIM',PadL(AllTrim(cNumCTe),9,'0'), cNumCTe )
		
		If Left(TMPCTE->CNPJ,8) == Left(cEmpCnpj/*cRemCnpj*/,8)
		
			// BUSCA A SERIE DA FILIAL DE SAIDA DA NOTA DE TRANSFERENCIA
			DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()
			Do While !Eof()
 				If TMPCTE->CNPJ == cEmpCnpj /*cRemCnpj*/
					cSerieXML  := TMPCTE->SER_TRANSF
					Exit
				EndIf
				DbSkip()
			EndDo       
			
			//	 VOLTA PARA REGISTRO ANTERIOR
	       	DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()
	       	DbSeek(cEmpAnt + cFilAnt, .F.)
		       	
		ElseIf TMPCTE->SER_3DIG == 'SIM'
			cSerieCTe  := PadL(AllTrim(cSerieCTe),3,'0')
		Else
			 cSerieCTe := cSerieCTe
		EndIf
		

        //зддддддддддддддддддддддддддддддддд©
        //Ё  VERIFICA FORNECEDOR            Ё
        //юддддддддддддддддддддддддддддддддды
	    lFornece  := .F.
      	cTipoNFe  := ''
             
       	//зддддддддддддддддддддддддддддддддд©
       	//Ё  XML - TIPO DE ENTRADA NORMAL   Ё
       	//юддддддддддддддддддддддддддддддддды

		lFornece	:= 	ForCliMsBlql('SA2', cEmitCnpj, .F.)  // BUSCA POR CNPJ
		
		cCodSA2    	:=  SA2->A2_COD
       	cLojaSA2    :=  SA2->A2_LOJA
       	cNomeSA2    := 	AllTrim(SA2->A2_NOME)
       	cUFSA2		:=	SA2->A2_EST
           
        If lFornece
               
           	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
           	//Ё VERIFICA SE NOTA DO FORNECEDOR JA ESTA CADSATRADA NO SISTEMA     |
           	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
                                                                                     

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
           	//Ё SX2->X2_UNIC -> F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_FORMUL	 					|
           	//| REALIZA PESQUISA PELO F1_TIPO == N-NORMAL, SE FOR DEVOLUCAO\RETORNO PESQUISA SEM O F1_TIPO	|
           	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
           	DbSelectArea("SF1");DbSetOrder(1);DbGoTop()    //    F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
          	If Dbseek(cDestFilial + cNumCTe + cSerieCTe + cCodSA2 + cLojaSA2, .F.)
				lEntrada    :=	.T.
              	dDtEntrada 	:= 	SF1->F1_EMISSAO
			   	cTipoNFe	:= 	SF1->F1_TIPO
	
			   	cStatus    	:= 	'G'
				lStatus		:=	.T.
				Aadd(aStatus, {cStatus, cDirArqXML, cNomeEmpFil, cNomeFilial, cDiretorioXML, cEmpCnpj /*cRemCnpj*/ /*cEmitCnpj*/ })
	        	
       		               
			Else
				lEntrada    := 	.F.
				dDtEntrada  := 	StoD('  \  \  ')       				
			EndIf
            

        	
		Else

           	//зддддддддддддддддддддддддддддддддддддддд©
           	//Ё NAO ENCONTROU O CNPJ DO FORNECEDOR    Ё
          	//юддддддддддддддддддддддддддддддддддддддды
          	cStatus	:= 'F'
	       	lStatus	:= .T.
			Aadd(aStatus, {cStatus, cDirArqXML, Transform(cEmitCnpj, IIF(Len(cEmitCnpj)>0,'@R 99.999.999/9999-99','@R 999.999.999-99') ) +' - '+ cEmitNome, cDiretorioXML, cEmpCnpj/*cRemCnpj*/ /*cEmitCnpj*/ })
		
		Endif



		If !lStatus //.Or. cStatus == 'G' 
           	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
           	//Ё VERIFICA SE XML JA FOI IMPORTADO   															|
           	//| cStatus == 'G' -> CASO A NF-E JA TENHA INCLUSA NO SISTEMA (SF1) VERIFICA SE JA ESTA NO ZXC.	|
           	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
           	DbSelectArea('ZXC');DbSetOrder(6);DbGoTop()
           	If DbSeek( cCTeChave , .F.)
				cStatus	:=	'D'       									//    XML JA IMPORTADO
		        lStatus	:=	.T.
				If cTpCarga !='EMAIL'  
					Aadd(aStatus, {cStatus, cDirArqXML, cNomeEmpFil+' \ '+cNomeFilial +'  Nota: '+cNumCTe+' SИrie: '+cSerieCTe+' - Fornecedor: '+cCodSA2+'/'+cLojaSA2+'  -  '+cNomeSA2, cDiretorioXML, cEmpCnpj/*cRemCnpj*/ /*cDestCnpj*/ })
				EndIf               
           	
           	Else
	           	//здддддддддддддддддддддддддддддддддддд©
	           	//Ё 	IMPORTADO COM SUCESSO   	   |
	           	//юдддддддддддддддддддддддддддддддддддды
               	cStatus	:=	'I'	// IIF(SM0->M0_CGC==cDestCnpj,'I','J')
              	lStatus	:=	.T.
				Aadd(aStatus, {cStatus, cDirArqXML, cNomeEmpFil, cNomeFilial, cDiretorioXML, cEmpCnpj/*cRemCnpj*/, cNomeFilial })
				
           	EndIf

       	EndIf
	            
	
	       	//здддддддддддддддддддддддддддддддддддд©
	       	//Ё CONSULTA XML-SEFAZ \ GRAVA ZXC     |
	       	//юдддддддддддддддддддддддддддддддддддды
	    If cStatus $ 'I/G/J' 
	
			aRetorno := {}
	    	**************************************************************************************
				 MsgRun("Aguarde... Consultando CT-e na SEFAZ...  "+IIF(cTpCarga!='EMAIL',AllTrim(Str(nImportados))+' de '+ AllTrim(Str(nMarcados)) ,'') ,,{|| aRetorno :=   ExecBlock("CTe_ConsWebNfe",.F.,.F.,{cCTeChave, cDestFilial, dDHEmit}) })
	    	**************************************************************************************
	
			If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('SF1'))
			   cSF1Modo	:=	AllTrim(SX2->X2_MODO)
			EndIf
			If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('ZXC'))
			   cZXCModo	:=	AllTrim(SX2->X2_MODO)
			EndIf
					
			DbSelectArea('ZXC')
			RecLock('ZXC',.T.)
				ZXC->ZXC_FILIAL	:=	IIF(cSF1Modo=='C'.And.cZXCModo=='C','',cDestFilial)
				ZXC->ZXC_STATUS	:=	cStatus
				ZXC->ZXC_FORNEC	:=	cCodSA2
				ZXC->ZXC_LOJA	:=	cLojaSA2 
				If ZXC->(FieldPos("ZXC_NOMFOR")) > 0
					ZXC->ZXC_NOMFOR	:=	cNomeSA2
	            EndIf
				If ZXC->(FieldPos("ZXC_UFFOR")) > 0
					ZXC->ZXC_UFFOR	:=	cUFSA2
	            EndIf
				ZXC->ZXC_CGC	:=	cEmitCnpj
				ZXC->ZXC_DOC	:=	cNumCTe
				ZXC->ZXC_SERIE	:=	cSerieCTe
				ZXC->ZXC_DTIMP	:=	dDataBase
				ZXC->ZXC_CHAVE	:=	cCTeChave
				ZXC->ZXC_DTNFE	:=	dDHEmit
				ZXC->ZXC_USER	:=	AllTrim(UsrRetName(__cUserId))
				ZXC->ZXC_CODRET	:=	aRetorno[1]
				ZXC->ZXC_SITUAC	:=	IIF(Empty(aRetorno[1]),'',IIF(aRetorno[1]=='100','A',IIF(aRetorno[1]=='101','C','E')))
				ZXC->ZXC_DTXML	:=	aRetorno[2]
				ZXC->ZXC_TIPO	:=	IIF(!Empty(cTipoNFe),cTipoNFe, IIF(Type('oCBoxFret:oWnd')!='O','',IIF(oCBoxFret:nAT == 1, 'C', 'N')) ) // oCBoxFret:nAT == 1=CONHEC.FRETE, 2= NORMAL;				
				ZXC->ZXC_VLRFRE	:=	Val(cVTPrest) 
				ZXC->ZXC_TOTMER	:=	Val(cVlrTotal) 
				ZXC->ZXC_BSICMS	:=	Val(cBaseIcms)
				If ZXC->(FieldPos("ZXC_PICMS")) > 0				//	AJUSTE 26/03/2015
					ZXC->ZXC_PICMS	:=	Val(cPerIcms)
				EndIf
				ZXC->ZXC_VLICMS	:=	Val(cVlrIcms)
				ZXC->ZXC_TPFRET :=	IIF(Type('oCBoxFret:oWnd')!='O','', IIF(oCBoxFret:nAT == 1, 'E', 'S') )
	
		       	lTabZXD := .F.
		       	//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		       	//Ё CAMPO MEMO EM SQL SUPORTA APENAS 65.535 CARACTERES	|
		       	//|	TABELA ZXD GRAVA O RESTANTE DO XML					|
		       	//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
				#IFDEF TOP               
				
					If Len(AllTrim(cArqCTe)) > 65535
					          
						lTabZXD := .T.
											
				       	//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				       	//Ё  GRAVA NA TABELA AUXILIAR, ZXN, O RESTANTE DO XML	|
				       	//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
						**********************************************************************************
							TabSeqXML(cDestFilial, cCTeChave, SubStr(AllTrim(cArqCTe), 65535, Len(AllTrim(cArqCTe)))) 
						**********************************************************************************
				
						cArqCTe	:=	SubStr(cArqCTe, 1, 65534)
				
					EndIf
		
				#ENDIF
				
		     	ZXC->ZXC_XML := cArqCTe

			MsUnlock()
	         
			
			If cTpOpen == 'XML_EMAIL'
			
				cAnexoEmail := ZXC->ZXC_XML

				If lTabZXD
					DbSelectArea('ZXD');DbSetOrder(1);DbGoTop()
					If DbSeek( cDestFilial + cChaveXML, .F.)
						Do While ZXD->ZXD_CHAVE == cChaveXML
							cAnexoEmail += ZXD->ZXD_XML
							DbSkip()
						EndDo
					EndIf
				EndIf

				cPathXmlEmail := _RootPath+'XML_EMAIL_CTE\'
				If !File(cPathXmlEmail)
					MakeDir(cPathXmlEmail)
				EndIf

				cArqEmail := 'EMITENTE_'+cEmitCnpj+'__NOTA_'+cNumCTe+'_SERIE_'+cSerieCTe+'.XML'
				If MemoWrit(cPathXmlEmail+cArqEmail, cAnexoEmail )
					//	GRAVOU
					_lRetGrava := .T.
				EndIf

			EndIf
   		
   		
   		ElseIf cStatus == 'D' .And. cTpOpen == 'XML_EMAIL' 		// JA IMPORTADO DELETA E-MAIL
   			_lRetGrava := .T.
   		EndIf

	EndIf
	
	
Else           

	//	aRet[3] -> FLAG XML SEM TAG PROTOCOLO
   cStatus    :=   IIF(Len(aRet)==2, 'E', aRet[3])
   Aadd(aStatus, {cStatus, cDirArqXML, aRet[2], cDiretorioXML, '' })
   
	/*
   		Aadd(aRetCTe, .F., 'T')
   		Aadd(aRetCTe, 'CTe SEM TAG PROTOCOLO DE AUTORIZAгцO.')
   	*/
	
	/*
	   Aadd(aRetXML, lEstrut)
	   Aadd(aRetXML, IIF(lEstrut, '' , 'ESTRUTURA DO XML INVаLIDA') )
	   Aadd(aRetXML, cDestCnpj )	//	cEmitCnpj, cDestCnpj, cRemCnpj, cExpCnpj, cEmpCnpj
	   Aadd(aRetXML, cEmitCnpj )	//	cEmitCnpj, cDestCnpj, cRemCnpj, cExpCnpj, cEmpCnpj
	   Aadd(aRetXML, dDHEmit   )
	*/

EndIf


//здддддддддддддддддддддддддддддддддддддддд©
//Ё  VOLTA AS TABELAS DA EMPRESA ATUAL     Ё
//юдддддддддддддддддддддддддддддддддддддддды
If !Empty(cDestEmpAnt) .And. cDestEmpAnt != cEmpAnt 

	IIF(Select("SA2") != 0, SA2->(DbCLoseArea()), )
	IIF(Select("SF1") != 0, SF1->(DbCLoseArea()), )
	IIF(Select("ZXC") != 0, ZXC->(DbCLoseArea()), )
	IIF(Select("ZXN") != 0, ZXN->(DbCLoseArea()), )	
	
	EmpOpenFile('SA2',"SA2",1,.T.,cEmpAnt,@cSA2Modo)
	EmpOpenFile('SF1',"SF1",1,.T.,cEmpAnt,@cSF1Modo)
	EmpOpenFile('ZXC',"ZXC",1,.T.,cEmpAnt,@cZXCModo)
	EmpOpenFile('ZXN',"ZXN",1,.T.,cEmpAnt,@cZXNModo)
   
   DbGoTop()
   
EndIf
                      

Return(_lRetGrava)
************************************************************
User Function CabecCTeParser()
************************************************************
Local cArqCTe		:=	ParamIxb[01] 
Local cError    	:=	''
Local cWarning    	:=	''
Local aRetorno   	:=	{}
Local aRetCTe		:=	{}
Local lEstrut		:=	.T.  

Private _lMt116Tel	:=	IIF(Type('ParamIxb')=='U', .F., IIF(Len(ParamIxb)>1,ParamIxb[02],.F.))


Static oCTe			:=	''
Static nItensCTe   	:=	0

//здддддддддддддддддддддддддддддд©
//Ё       		IDE         	 |
//юдддддддддддддддддддддддддддддды
Static cNumCTe
Static cSerieCTe
Static cCFOP
Static cMunEmi
Static cMunIni
Static cMunFim
Static cUF
Static dDHEmit
Static cFormPag
Static cMod
Static cModal
Static cNatOper
Static cNCT
Static cProcEmit
Static cRetira
Static cTpAmb
Static cTpCTe
Static cTpEmis
Static cTpImp
Static cTpServ
Static cUFEmit
Static cUFFim
Static cUFIni
Static cxMunFim
Static cxMunIni
Static cToma03
Static cToma04

//здддддддддддддддддддддддддддддд©
//Ё       	COMPLEMENTO 		 |
//юдддддддддддддддддддддддддддддды
Static cObs


//здддддддддддддддддддддддддддддд©
//Ё       	DESTINATARIO		 |
//юдддддддддддддддддддддддддддддды
Static cDestNome
Static cDestCnpj
Static cDestCep
Static cDestMun
Static cDestNro
Static cDestUF
Static cDestBairro
Static cDestLograd
Static cDestMum
Static cDestEnd
Static cDestIE


//здддддддддддддддддддддддддддддд©
//Ё       	EMITENTE    		 |
//юдддддддддддддддддддддддддддддды
Static cEmitCnpj
Static cEmitCep
Static cEmitCodMun
Static cEmitNro
Static cEmitUF
Static cEmitBairro
Static cEmitCompl
Static cEmitLograd
Static cEmitMun
Static cEmitEnd
Static cEmitIE
Static cEmitNome
Static cEmit


//здддддддддддддддддддддддддддддд©
//Ё      INFORMACOES CARGA		 |
//юдддддддддддддддддддддддддддддды
Static cAeDtPrev
Static cAeNoca
Static cAeTarifa
Static cAeLagEmi
Static cCargaUnid
Static cCargaQtd
Static cCargaMed
Static cCargaProp
Static cCargaValor

//здддддддддддддддддддддддддддддд©
//Ё       	REMETENTE   		 |
//юдддддддддддддддддддддддддддддды
Static cRemNome
Static cRemCnpj
Static cRemCep
Static cRemCep
Static cRemNro
Static cRemUF
Static cRemBairro
Static cRemLograd
Static cRemMun
Static cRemIE
Static cRemDtEmis
// TAG INF
Static cInfCFOP
Static cInfDoc
Static cInfSerie
Static cInfVB
Static cInfVBCST
Static cInfVICMS
Static cInfTotal
Static cInfVlrProd
Static cInfVlrST
Static cInfNomeRem
//здддддддддддддддддддддддддддддд©
//Ё       	EXPEDIDOR   		 |
//юдддддддддддддддддддддддддддддды
Static cExpNome
Static cExpCnpj
Static cExpCep
Static cExpCep
Static cExpNro
Static cExpUF
Static cExpBairro
Static cExpLograd
Static cExpMun
Static cExpIE                                   


//здддддддддддддддддддддддддддддддддд©
//Ё 	VALOR PRESTACAO SERVICO 	 |
//юдддддддддддддддддддддддддддддддддды
Static cVComp
Static cxNome
Static cVRec
Static cVTPrest
Static cVlrTotal
       
Static cCompPeso
Static cCompValor
Static cCompPedagio
Static cCompGris
Static cCompOutros
Static cCompTas

//здддддддддддддддддддддддддддддддддд©
//Ё 		IMPOSTOS		 	 	 |
//юдддддддддддддддддддддддддддддддддды
Static cCST
Static cPerIcms
Static cBaseIcms
Static cVlrIcms 

		   					
//здддддддддддддддддддддддддддддддддд©
//Ё 		TAG PROTOCOLO	 	 	 |
//юдддддддддддддддддддддддддддддддддды
Static cChCTe
Static cDtRecto
Static cProtocolo
Static cMotivo
Static cCTeChave
Static cCTeVersao 
Static cDigVal


//здддддддддддддддддддддддддддддд©
//Ё       	CNPJ EMPRESA   		 |
//юдддддддддддддддддддддддддддддды
Static cEmpCnpj



//зддддддддддддддддддддддддддддд©
//Ё     ABRE XML - CTe          Ё
//юддддддддддддддддддддддддддддды
oCTe  := XmlParser(cArqCTe,"_",@cError, @cWarning )


	*************************************
		aRetorno	:=	ReadTagXml(cError)	//	LENDO TAGs DO XML
	*************************************


Return(aRetorno)
************************************************************
Static Function ReadTagXml(cError)
************************************************************
Local aColsCTe	:=	{}
Local aRetXML	:=	{}
Local lEstrut	:=	.T.                              



If Empty(cError)

	If TMPCTE->(FieldPos("TAGPROT"))>0
		If TMPCTE->TAGPROT == 'SIM'
		   //здддддддддддддддддддддддддддддддддддддд©
		   //Ё 	VERIFICA SE EXISTE A TAG PROTCTE	|
		   //юдддддддддддддддддддддддддддддддддддддды
		   If AllTrim(Type("oCTe:_CTEPROC:_PROTCTE")) != "O"
		
			   	Aadd(aRetCTe, .F., 'T')
		   		Aadd(aRetCTe, 'CTe SEM TAG PROTOCOLO DE AUTORIZAгцO.')
		
				Return(aRetXML)
			EndIf
        EndIf
	EndIf

   /*
   If AllTrim(Type("ooCTe:_CTEPROC")) == "O"
       aColsCTe := aClone(oCTe:_CTEPROC:_DET)
   EndIf                                                                  	

   If aColsCTe == Nil
       nItensCTe := 1
   Else
       nItensCTe := Len(aColsCTe)
   Endif
   */
   
   	nItensCTe 	:=	1
	cEmpCnpj	:=	''
	

    //здддддддддддддддддддддддддддддд©
    //Ё       VERSAO _INFNFE         |
    //юдддддддддддддддддддддддддддддды
	If AllTrim(Type("oCTe:_CTEPROC:_CTE:_INFCTE")) == "O"

	    //здддддддддддддддддддддддддддддд©
	    //Ё       		IDE         	 |
	    //юдддддддддддддддддддддддддддддды
		cNumCTe		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT
		cSerieCTe	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:TEXT
		cCFOP		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_CFOP:TEXT
		cMunEmi		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNEMI:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNEMI:TEXT, '' )
		cMunIni		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNINI:TEXT
		cMunFim		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNFIM:TEXT
		cUF			:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_CUF:TEXT
		dDHEmit		:=	StoD( StrTran( Left( oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT, 10) , "-","") )
		cFormPag	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_FORPAG:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_FORPAG:TEXT, '' )
		cMod		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_MOD:TEXT
		cModal		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_MODAL:TEXT
		cNatOper	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_NATOP:TEXT
		cNCT		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT
		cProcEmit	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_PROCEMI:TEXT
		cRetira		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_RETIRA:TEXT 
		cTpAmb		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_TPAMB:TEXT
		cTpCTe		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_TPCTE:TEXT
		cTpEmis		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_TPEMIS:TEXT
		cTpImp		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_TPIMP:TEXT
		cTpServ		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_TPSERV:TEXT
		cEmitUF		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_UFEMI:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_UFEMI:TEXT, '')
		cUFFim		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_UFFIM:TEXT
		cUFIni		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_UFINI:TEXT
		cEmitMun	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_XMUNEMI:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_XMUNEMI:TEXT,'')
		cxMunFim	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_XMUNFIM:TEXT
		cxMunIni	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT

		//cToma03	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA03:TEXT
	//	cToma03		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT
		cToma03		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT,'')
		cToma03		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT,  cToma03)
		
		/*
		<toma03> - Indicador do "papel" do tomador do ServiГo no CT-e   ( Tomador do servico = quem contrata )
			0-Remetente;
			1-Expedidor;
			2-Recebedor;
			3-DestinatАrio
			SerЦo utilizadas as informaГУes contidas no respectivo grupo, conforme indicado pelo conteЗdo deste campo

		<toma04>
		
		*/
		
		

	    //здддддддддддддддддддддддддддддд©
	    //Ё       	COMPLEMENTO 		 |
	    //юдддддддддддддддддддддддддддддды
	    cObs		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_COMPL:_XOBS:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_COMPL:_XOBS:TEXT,'')


	    //здддддддддддддддддддддддддддддд©
	    //Ё       	EMITENTE    		 |
	    //юдддддддддддддддддддддддддддддды         
	    cEmitCnpj	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
		cEmitCep	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_CEP:TEXT
		cEmitCodMun	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_CMUN:TEXT
		cEmitNro	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_NRO:TEXT
		cEmitUF		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT
		cEmitBairro	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT
		cEmitCompl	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XCPL:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XCPL:TEXT,'')
		cEmitLograd	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XLGR:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XLGR:TEXT,'')
		cEmitMun	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT
		cEmitEnd	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:TEXT,'')
		cEmitIE		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_IE:TEXT
		cEmitNome	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME:TEXT
		cEmit		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_EMIT:TEXT,'')


		cEmpCnpj	:=	IIF(Empty(cEmpCnpj), CheckCnpj(cEmitCnpj), cEmpCnpj)
		

	    //здддддддддддддддддддддддддддддд©
	    //Ё       	DESTINATARIO		 |
	    //юдддддддддддддддддддддддддддддды
		cDestNome	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_XNOME:TEXT
	    cDestCnpj	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT, '')
		// oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:
		cDestCep	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_CEP:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_CEP:TEXT,'')
		cDestMun	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_CMUN:TEXT
		cDestNro	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_NRO:TEXT
		cDestUF		:=	oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT
		cDestBairro	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_XBAIRRO:TEXT
		cDestLograd	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_XLGR:TEXT
		cDestMum	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_XMUN:TEXT
		cDestEnd	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:TEXT,'')
		cDestIE		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_IE:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_IE:TEXT,'')
		

		cEmpCnpj	:=	IIF(Empty(cEmpCnpj), CheckCnpj(cDestCnpj), cEmpCnpj)
		
		
	    //здддддддддддддддддддддддддддддд©
	    //Ё       	REMETENTE			 |
	    //юдддддддддддддддддддддддддддддды
	    cRemNome	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_XNOME:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_XNOME:TEXT, '')
		cRemCnpj	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT")=='C',  oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT,  '')
		cRemCep		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_CEP:TEXT")=='C',  oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_CEP:TEXT,  '')
		cRemCep		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_CMUN:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_CMUN:TEXT, '')
		cRemNro		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_NRO:TEXT")=='C',  oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_NRO:TEXT,  '')
		cRemUF		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_UF:TEXT")=='C', 	 oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_UF:TEXT,   '')
		cRemBairro	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_XBAIRRO:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_XBAIRRO:TEXT, '')
		cRemLograd	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_XLGR:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_XLGR:TEXT, '')
		cRemMun		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_XMUN:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_XMUN:TEXT, '')
		cRemIE		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_IE:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_IE:TEXT, '')
	   	cRemDtEmis	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_DEMI:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_DEMI:TEXT,'')


		cEmpCnpj	:=	IIF(Empty(cEmpCnpj), CheckCnpj(cRemCnpj), cEmpCnpj)
		
	                    
		
	    //здддддддддддддддддддддддддддддд©
	    //Ё      INFORMACOES CARGA		 |
	    //юдддддддддддддддддддддддддддддды
		// oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:
		// oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_AEREO:
		cAeDtPrev	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_AEREO:_DPREV:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_AEREO:_DPREV:TEXT, '')
		cAeNoca		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_AEREO:_NOCA:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_AEREO:_NOCA:TEXT, '')
		cAeTarifa	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_AEREO:_TARIFA:_CL:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_AEREO:_TARIFA:_CL:TEXT, '')
		cAeLagEmi	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_AEREO:_XLAGEMI:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_AEREO:_XLAGEMI:TEXT, '')
		
		// oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:
		// oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ <- ARRAY
		cCargaUnid	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[1]:_CUNID:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[1]:_CUNID:TEXT, '')
		cCargaQtd	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[1]:_QCARGA:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[1]:_QCARGA:TEXT, '')
		cCargaMed	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[1]:_TPMED:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[1]:_TPMED:TEXT, '')
		
		cCargaProp	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_PROPRED:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_PROPRED:TEXT, '')
		cCargaValor	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VMERC:TEXT")=='C',oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VMERC:TEXT, '')
		
		                                  
		/*          
		<toma03> - Indicador do "papel" do tomador do ServiГo no CT-e   ( Tomador do servico = quem contrata )
		Tipo de tomador do serviГo:
			0-Remetente;
			1-Expedidor;
			2-Recebedor;
			3-DestinatАrio;
			4-Outro
		*/

		/*
		If !(cToma03 $ '0/3')  .Or. _lMt116Tel
		    cRemNome	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_XNOME:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_XNOME:TEXT, '')
			cRemCnpj	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT")=='C',  oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT,  '')
			cRemCep		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_CEP:TEXT")=='C',  oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_CEP:TEXT,  '')
			cRemCep		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_CMUN:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_CMUN:TEXT, '')
			cRemNro		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_NRO:TEXT")=='C',  oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_NRO:TEXT,  '')
			cRemUF		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_UF:TEXT")=='C', 	 oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_UF:TEXT,   '')
			cRemBairro	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_XBAIRRO:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_XBAIRRO:TEXT, '')
			cRemLograd	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_XLGR:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_XLGR:TEXT, '')
			cRemMun		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_XMUN:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_XMUN:TEXT, '')
			cRemIE		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_IE:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_IE:TEXT, '')
		   	cRemDtEmis	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_DEMI:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_DEMI:TEXT,'')
		Else
			cRemNome	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_XNOME:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_XNOME:TEXT, '')
		    cRemCnpj	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT, '')		
			cRemCep		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_CEP:TEXT")=='C',  oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_CEP:TEXT,  '')
			cRemCep		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_CMUN:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_CMUN:TEXT, '')
			cRemNro		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_NRO:TEXT")=='C',  oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_NRO:TEXT,  '')
			cRemUF		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT")=='C',   oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT,   '')
			cRemBairro	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_XBAIRRO:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_XBAIRRO:TEXT, '')
			cRemLograd	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_XLGR:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_XLGR:TEXT, '')
			cRemMun		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_XMUN:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_XMUN:TEXT, '')
			cRemIE		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_IE:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_DEST:_IE:TEXT, '')
		EndIf
		*/		                                                      


		//	TAG	INF
		cInfoCFOP	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_NCFOP:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_NCFOP:TEXT,'')
		cInfDoc		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_NDOC:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_NDOC:TEXT,'')
		cInfSerie	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_SERIE:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_SERIE:TEXT,'')
		cInfVB		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_VBC:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_VBC:TEXT,'')
		cInfVBCST	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_VBCST:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_VBCST:TEXT,'')
		cInfVICMS	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_VICMS:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_VICMS:TEXT,'')
		cInfTotal	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_VNF:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_VNF:TEXT,'')
		cInfVlrProd	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_VPROD:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_VPROD:TEXT,'')
		cInfVlrST	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_VST:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF:_VST:TEXT,'')
		cInfNomeRem	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_XNOME:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_REM:_XNOME:TEXT,'')


	    //здддддддддддддддддддддддддддддд©
	    //Ё       	EXPEDIDOR   		 |
	    //юдддддддддддддддддддддддддддддды                          
		cExpNome	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_XNOME:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_XNOME:TEXT,'')
		cExpCnpj	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT,'')
		cExpIE		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_IE:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_IE:TEXT,'')
		cExpCep		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_CEP:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_CEP:TEXT,'')
		cExpCep		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_CMUN:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_CMUN:TEXT,'')
		cExpNro		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_NRO:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_NRO:TEXT,'')
		cExpUF		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_UF:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_UF:TEXT,'')
		cExpBairro	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XBAIRRO:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XBAIRRO:TEXT,'')
		cExpLograd	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XLGR:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XLGR:TEXT,'')
		cExpMun		:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XMUN:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XMUN:TEXT,'')
		                                      
		cEmpCnpj	:=	IIF(Empty(cEmpCnpj), CheckCnpj(cExpCnpj), cEmpCnpj)



	    //здддддддддддддддддддддддддддддддддд©
	    //Ё 	VALOR PRESTACAO SERVICO 	 |
	    //юдддддддддддддддддддддддддддддддддды
		// oCTe:_CTEPROC:_CTE:_INFCTE:_VPREST:
		cVComp	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP:_VCOMP:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP:_VCOMP:TEXT,'')
		cxNome	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP:_XNOME:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP:_XNOME:TEXT,'')
		cVRec	:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_VPREST:_VREC:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_VPREST:_VREC:TEXT,'')
		cVTPrest:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT,'')

		cVlrTotal:=	IIF(Type("oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VCARGA:TEXT")=='C', oCTe:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VCARGA:TEXT,'')

		If Type("oCTe:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP") == 'A'
			
			aComp	:=	oCTe:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP
			For _nX := 1 To Len(aComp)
			
				If AllTrim(aComp[_nX]:_XNOME:TEXT) == 'FRETE PESO'
					cCompPeso	:=	aComp[_nX]:_VCOMP:TEXT
				ElseIf AllTrim(aComp[_nX]:_XNOME:TEXT) == 'FRETE VALOR' 
					cCompValor	:=	aComp[_nX]:_VCOMP:TEXT
				ElseIf AllTrim(aComp[_nX]:_XNOME:TEXT) == 'PEDAGIO' 
					cCompPedagio:=	aComp[_nX]:_VCOMP:TEXT
				ElseIf AllTrim(aComp[_nX]:_XNOME:TEXT) == 'GRIS' 
					cCompGris	:=	aComp[_nX]:_VCOMP:TEXT
				ElseIf AllTrim(aComp[_nX]:_XNOME:TEXT) == 'OUTROS' 
					cCompOutros	:=	aComp[_nX]:_VCOMP:TEXT
				ElseIf AllTrim(aComp[_nX]:_XNOME:TEXT) == 'TAS' 
					cCompTas	:=	aComp[_nX]:_VCOMP:TEXT
				EndIf
				
            Next
                            	
		EndIf
		
	    //здддддддддддддддддддддддддддддд©
	    //Ё       	IMPOSTOS    		 |
	    //юдддддддддддддддддддддддддддддды
		If Type('oCTe:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00') == 'O'
			cCST	  := oCTe:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT
			cPerIcms  := oCTe:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT
			cBaseIcms := oCTe:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT
			cVlrIcms  := oCTe:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT
		Else
			cCST	  := '0'
			cPerIcms  := '0'
			cBaseIcms := '0'
			cVlrIcms  := '0'
		EndIf
		
		
	    //здддддддддддддддддддддддддддддддддд©
	    //Ё 		TAG PROTOCOLO	 	 	 |
	    //юдддддддддддддддддддддддддддддддддды		
		//oCTe:_CTEPROC:_PROTCTE:
		cChCTe		:=	oCTe:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT
		cDtRecto	:=	oCTe:_CTEPROC:_PROTCTE:_INFPROT:_DHRECBTO:TEXT
		cProtocolo	:=	oCTe:_CTEPROC:_PROTCTE:_INFPROT:_NPROT:TEXT		// PROTOCOLO
		cMotivo		:=	oCTe:_CTEPROC:_PROTCTE:_INFPROT:_XMOTIVO:TEXT
		cDigVal		:=	oCTe:_CTEPROC:_PROTCTE:_INFPROT:_DIGVAL:TEXT
		
		cCTeChave	:=	oCTe:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT

		cCTeVersao	:=	oCTe:_CTEPROC:_VERSAO:TEXT
    


   
   	Else
   		lEstrut	:=	.F.
   	EndIf
	
	
	   //здддддддддддддддддддддддддддддддддд©
	   //Ё VERIFICA STATUS ESTRUTURA DO XML	|
	   //юдддддддддддддддддддддддддддддддддды
	   Aadd(aRetXML, lEstrut)     													 //	 [01]
	   Aadd(aRetXML, IIF(lEstrut, '' , 'ESTRUTURA DO XML INVаLIDA') )               //  [02]
	   If _lMt116Tel
	   		Aadd(aRetXML, cEmpCnpj /*cRemCnpj*/  )	//	cEmitCnpj, cDestCnpj, cRemCnpj, cExpCnpj //  [03]
	   		Aadd(aRetXML, cEmitCnpj )				//	cEmitCnpj, cDestCnpj, cRemCnpj, cExpCnpj //  [04]
	   		Aadd(aRetXML, dDHEmit   )                                                //  [05]
	   EndIf

Else
  
   //If AllTrim(TYPE("oXML:_CTEPROC")) == "O"
	//	cError := "CT-e. NцO и POSSIVEL IMPORTAR CONHECIMENTO DE TRANSPORTE ELETRONICO."
   If AllTrim(TYPE("oXML:_NFES")) == "O"
   			cError := "NFS-e. NцO и POSSIVEL IMPORTAR NOTA FISCAL DE SERVIгO ELETRONICA."
   Else
	   //зддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё ERRO NO PARSE - PROBLEMA COM ESTRUTURA DO XML |
	   //юддддддддддддддддддддддддддддддддддддддддддддддды
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

Return(aRetXML)
*********************************************************************
Static Function TabSeqXML(cDestFilial, cCTeChave, cSeqXML)
*********************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё GRAVA NA TABELA AUXILIAR, ZXD, O RESTANTE DO XML	|
//Ё Chamada -> Grava XML()				 				|
//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local nSeq := 0

Do While !Empty(cSeqXML)
	
	DbSelectArea('ZXD')
	Reclock('ZXD',.T.)             
		nSeq++
		ZXD->ZXD_FILIAL	:=	cDestFilial
		ZXD->ZXD_CHAVE	:=	cCTeChave
		ZXD->ZXD_SEQ  	:=	StrZero(nSeq,3)
		ZXD->ZXD_XML  	:=	SubStr(cSeqXML, 1, 65534) 
	MsUnlock()

	cSeqXML := SubStr(cSeqXML, 65535, Len(cSeqXML) ) 

EndDo

Return()
*********************************************************************
User Function CTe_VerificaZXD()
*********************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё GRAVA NA TABELA AUXILIAR, ZXD, O RESTANTE DO XML	|
//Ё Chamada -> CarregaACols()				 			|
//Ё 		-> ExpXML()									|
//Ё 		-> ConsCTeSefaz()							|
//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local _cFilial	:=	ParamIxb[01]
Local cChave	:=	ParamIxb[02]
Local cRetorno 	:= ''

ZXD->(DbSetOrder(1), DbGoTop())
If ZXD->(DbSeek(_cFilial + cChave ,.F.))
	Do While ZXD->(!Eof()) .And. ZXD->ZXD_CHAVE == cChave
		cRetorno	+=	ZXD->ZXD_XML
	ZXD->(DbSkip())
	EndDo
EndIf

Return(cRetorno)
*********************************************************************
Static Function SA2_SA1ConsPad(cTabela)
*********************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta tela consulta para usuario pesquisar codigo do fornecedor |
//| quando fornecedor == exteriror									|
//Ё Chamada -> Grava_CTe()     										|
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local nCBox 	
Local lOk		  := .F.
Private aArea_1   := GetArea()
Private cPesquisa := Space(100)
Private cRetorno  :=	''
Private cArqTmp

	
SetPrvt("oDlgSA2","oCBox","oGet1","oBrw1","oSBtn1","oSBtn2")

	
oDlgSA2	:= MSDialog():New( D(113),D(321),D(486),D(897),"Consulta Fornecedor",,,.F.,,,,,,.T.,,,.T. )
oCBox	:= TComboBox():New( D(004),D(004),{|u| If(PCount()>0,nCBox:=u,nCBox)},{"CсDIGO+LOJA","NOME","NOME FANTASIA"},D(240),D(010),oDlgSA2,,{|| DbSelectArea("TMPSA2"),DbSetOrder(oCBox:nAT), DbGoTop(), oDlgSA2:Refresh(),  },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nCBox )
oGet1	:= TGet():New( D(016),D(004),{|u| If(PCount()>0,cPesquisa:=u,cPesquisa)},oDlgSA2,D(240),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,{||  TMP->(DbSeek(cPesquisa, .T.)), oBrw1:oBrowse:Refresh() },.F.,.F.,"","",,)
oBtn1   := TButton():New( D(004),D(247),"&Pesquisar",oDlgSA2,{|| TMPSA2->(DbSeek(cPesquisa, .T.)), oBrw1:oBrowse:Refresh() },D(040),D(011),,,,.T.,,"",,,,.F. )

MsgRun("Consulta Fornecedor...",,{|| oTblSA2(cTabela) } )

DbSelectArea("TMPSA2") 
oBrw1	:= MsSelect():New( "TMPSA2","","",  {{"CODIGO","","CСdigo",""},{"LOJA","","Loja",""},{"NOME","","Nome",""}, {"NFANT","","Nome Fantasia",""}},.F.,,{D(028),D(004),D(164),D(280)},,, oDlgSA2 ) 

oSBtn1	:= SButton():New( D(168),D(004),01,{|| TMPSA2->CNPJ, oDlgSA2:End() },oDlgSA2,,"", )
oSBtn3	:= SButton():New( D(168),D(040),15,{|| MostraRegSA2(cTabela) },oDlgSA2,,"", )

oDlgSA2:Activate(,,,.T.)

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

	cArqTmp := CriaTrab( aFds, .T. )
	Use (cArqTmp) Alias TMPSA2 New Exclusive
	Index On CODIGO+LOJA	TAG 1 To &cArqTmp
	Index On NOME       	TAG 2 To &cArqTmp
	Index On NFANT 			TAG 3 To &cArqTmp

EndIf


DbSelectArea("TMPSA2");DbSetOrder(1)

If cTabela == 'SA2'
	DbSelectArea('SA2');DbGoTop()
	Do While !Eof()
		If SA2->A2_EST == 'EX'
			RecLock("TMPSA2",.T.) 
		     	TMPSA2->CODIGO	:=	SA2->A2_COD
				TMPSA2->LOJA	:=	SA2->A2_LOJA	
				TMPSA2->NOME	:=	SA2->A2_NOME
				TMPSA2->NFANT	:=	SA2->A2_NFANT
				TMPSA2->MUN		:=	SA2->A2_MUN
				TMPSA2->EST		:=	SA2->A2_EST
				TMPSA2->PAIS	:=	SA2->A2_PAIS
				TMPSA2->CNPJ	:=	SA2->A2_CGC
				TMPSA2->_RECNO	:=	SA2->(Recno())
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
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Bota de visualizar cadastro do Fornecedor                       |
//| na consulta para usuario pesquisar codigo do fornecedor 		|
//Ё Chamada -> SA2_SA1ConsPad()     								|
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cCadastro	:=	'Fornecedor'
cAlias		:=	'SA2'
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
//зддддддддддддддддддддддддддддддддд©
//Ё Mostra Retorno da Importacao    Ё
//Ё Chamada -> RecebeEmail()        Ё
//|                LoadFiles()      |
//юддддддддддддддддддддддддддддддддды

Local 	cMsgXML  := cMsg_I := cMsg_D := cMsg_F := cMsg_C := cMsg_E := ''
Local	lRet		:=	.T.
Private	aStatusI 	:=	{} 
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


//зддддддддддддддддддддддддддддддддддддддд©
//Ё	SEPARA O ARRAY aStatus CONFORME TIPO  Ё
//юддддддддддддддддддддддддддддддддддддддды
aSort(aStatus,,, { |x,y| x[1] > y[1] })
For nX := 1 To Len(aStatus)

   If aStatus[nX][1] ==     'I'
       Aadd(aStatusI,    {aStatus[nX][2],aStatus[nX][3]+' \ '+aStatus[nX][4], aStatus[nX][1], aStatus[nX][4], aStatus[nX][6], aStatus[nX][7] })  
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


//зддддддддддддддддддддддддддддддддддддддд©
//Ё	  BROSWER COM STATUS DA IMPORTACAO    Ё
//юддддддддддддддддддддддддддддддддддддддды
oFontG     := TFont():New( "Arial",0,IIF(nHRes<=800,-16, -18),,.T.,0,,700,.F.,.F.,,,,,, )
oFontP     := TFont():New( "Arial",0,IIF(nHRes<=800,-09, -11),,.F.,0,,700,.F.,.F.,,,,,, )

oDlgS      := MSDialog():New( D(095),D(232),D(427),D(740),"STATUS ARQUIVOS IMPORTADOS...",,,.F.,,,,,,.T.,,,.T. )
oGrp       := TGroup():New( D(004),D(004),D(146),D(250),"",oDlgS,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayOK     := TSay():New( D(010),D(000),{|| cMsgStatus },oGrp,,oFontG,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(240),D(010))
oSayNO     := TSay():New( D(010),D(000),{|| cMsgStatus },oGrp,,oFontG,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,D(240), D(010))
oSayOK:Hide()
oSayNO:Hide()

oSayQtd    := TSay():New( D(022),D(010),{|| Alltrim(Str(nQtdStatus))+ ' arquivo(s) ' },oGrp,,oFontP,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(010) )

oSayImp    := TSay():New( D(022),D(055),{|| ' Arquivo(s) nЦo importado ' },oGrp,,oFontP,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,D(080),D(010) )
oSayImp:Hide()

*************************
   oTblStatus()
*************************

DbSelectArea("TMPSTATUS")
oBrw1 := MsSelect():New( "TMPSTATUS","","",{{"ARQUIVO","","Arquivo",""},{"CONTEUDO","","ObservaГЦo",""}},.F.,,{ D(030),D(008),D(140),D(245) },,, oGrp )

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
//зддддддддддддддддддддддддддддддддд©
//Ё Cria Arq. Temp                  Ё
//Ё Chamada -> MensStatus()         Ё
//юддддддддддддддддддддддддддддддддды
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
//зддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё ALIMENTA TABELA TEMPORARIA E ATUALIZA VARIAVEIS	|
//| SEPARA OS TIPOS E ALIMENTA aTmpStatus			|
//Ё Chamada -> MensStatus()         				Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддды

aTmpStatus := {}

If Len(aStatusI) > 0
                     
   // 				Aadd(aStatus, {cStatus, cArqCTe, cNomeEmpFil, cNomeFilial, cDiretorioXML, cDestCnpj, cNomeFilial })
	aCopia	:=	{}
	aSort(aStatusI,,, { |x,y| x[5] > y[5] })
	cCnpjFil := aStatusI[1][5]
	cNomeFil := aStatusI[1][6]
	
	If SM0->M0_CGC == cCnpjFil
    	cMsgStatus  :=	PadC('ARQUIVO IMPORTADO COM SUCESSO',080,'')
    Else
    	cMsgStatus	:=	PadC('XML IMPORTADO COM SUCESSO - FILIAIL '+cNomeFil,080,'')
   	EndIf
   	
	For _nX:=1 To Len(aStatusI)
		If cCnpjFil == aStatusI[_nX][5] .Or. Len(aStatusI) == 1
			Aadd(aTmpStatus, {aStatusI[_nX][1], aStatusI[_nX][2], aStatusI[_nX][3], aStatusI[_nX][4]} )
   		Else
   			Aadd(aCopia, aStatusI[_nX])
        EndIf
    Next
         
	aStatusI := aCopia
   		
   oSayOK:Show()
   oSayNO:Hide()
   oSayImp:Hide()


ElseIf Len(aStatusD) > 0
   cMsgStatus   :=	PadC('ARQUIVO Jа IMPORTADO',080,'')
   aTmpStatus   := 	aClone(aStatusD)
   aStatusD    	:= 	{}
   oSayOK:Hide()
   oSayNO:Show()
   oSayImp:Show()
ElseIf Len(aStatusF) > 0
   cMsgStatus	:=	PadC('CNPJ DO EMITENTE NцO ENCONTRADO',080,'')
   aTmpStatus   := 	aClone(aStatusF)
   aStatusF    	:=	{}
   oSayOK:Hide()
   oSayNO:Show()
   oSayImp:Show()
ElseIf Len(aStatusC) > 0
   cMsgStatus	:=	PadC('CNPJ DO DESTINATаRIO NцO ENCONTRADO',080,'')
   aTmpStatus	:=	aClone(aStatusC)
   aStatusC    	:=	{}
   oSayOK:Hide()
   oSayNO:Show()
   oSayImp:Show()
ElseIf Len(aStatusE) > 0  
   cMsgStatus	:=	PadC('XML COM FORMATAгцO INCORRETA',080,'')
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
   cMsgStatus	:=	PadC('XML SEM TAG PROTOCOLO DE AUTORIZAгцO',080,'')
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
//зддддддддддддддддддддддддддддддддд©
//Ё Renomea Arq.XML -Importado      Ё
//Ё Chamada -> MensStatus()         Ё
//юддддддддддддддддддддддддддддддддды


Local lCopia := .T.

//зддддддддддддддддддддддддддддддддд©
//Ё VERIFICO SE DIRETORIO EXISTE    Ё
//юддддддддддддддддддддддддддддддддды
If !File(cDiretorioXML+'XML_IMPORTADO') 
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё NAO EXISTINDO VERIFICO SE NO CAMINHO INFORMADO CONTEM A PALAVRA \XML_IMPORTADO Ё
	//Ё PARA QUE NAO SEJA NECESARIO CRIAR UMA PASTA \XML_IMPORTADO DENTRO DA MESMA.    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nPosXML := RAT('\XML_IMPORTADO', Upper(cDiretorioXML) )
	If nPosXML == 0
		If MakeDir(cDiretorioXML+'XML_IMPORTADO') != 0
			MsgAlert('и necessario criar a pasta '+cDiretorioXML+'XML_IMPORTADO'+' para separar os arquivos jА importados.') 
		EndIf
	Else
		lCopia := .F.
	EndIf
EndIf


nTam       	:=	Len(aStatus[nPos][2])-4
cArquivo 	:=	SubStr(aStatus[nPos][2],1, nTam )
cExtensao	:= 	Right(AllTrim(aStatus[nPos][2]), 4)  


//здддддддддддддддддддддд©
//Ё   RENOMEA ARQUIVO    Ё
//юдддддддддддддддддддддды
FRename( cDiretorioXML+aStatus[nPos][2], cDiretorioXML+cArquivo+'_IMPORTADO'+cExtensao)


If lCopia

	//зддддддддддддддддддддддддддддддддддддд©
	//Ё COPIA PARA DIRETORIO \_IMPORTARDO	|
	//юддддддддддддддддддддддддддддддддддддды
	_CopyFile(cDiretorioXML+cArquivo+'_IMPORTADO'+cExtensao, cDiretorioXML+'XML_IMPORTADO\'+cArquivo+'_IMPORTADO'+cExtensao )
	//зддддддддддддддддддддддддддддддддддддд©
	//| APAGA ARQUIVO DA PASTA ORIGINAL		|
	//юддддддддддддддддддддддддддддддддддддды
	FErase(cDiretorioXML+cArquivo+'_IMPORTADO'+cExtensao)

EndIf



//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё ALTERANDO O CAMINHO ANTIGO, COLOCANDO O NOVO CAMINHO, PARA QUE SEJA POSSIVEL ABRIR O XML COM 2 CLICKЁ
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aStatus[nPos][4] := cDiretorioXML+'XML_IMPORTADO\'+cArquivo+'_IMPORTADO'+cExtensao

Return()
*****************************************************************
User Function ConsCTeSefaz()    //    [5.0]
*****************************************************************
//зддддддддддддддддддддддддддддддддд©
//Ё Consulta Status XML - SEFAZ     Ё
//Ё Chamada -> Rotina Status XML    Ё
//юддддддддддддддддддддддддддддддддды
Local aArea5	:= GetArea()
Local aRetorno	:= {}
Local cRet		:= ''

DbSelectArea('ZXC')

MsgRun("Aguarde... Consultando XML na SEFAZ...",,{|| aRetorno := ExecBlock("CTe_ConsWebXML",.F.,.F.,{ZXC->ZXC_CHAVE, cEmpAnt, DtoS(ZXC->ZXC_DTXML) }) } )

//зддддддддддддддддддддддддддддддддд©
//Ё	GRAVA RETORNO DO STATUS DO XML  Ё
//юддддддддддддддддддддддддддддддддды
If	Reclock('ZXC',.F.)
		ZXC->ZXC_SITUAC	:=	IIF(Empty(aRetorno[1]),'',IIF(aRetorno[1]=='100','A',IIF(aRetorno[1]=='101','C','E')))
	   	ZXC->ZXC_CODRET	:=	aRetorno[1]
	   	ZXC->ZXC_DTXML	:=	aRetorno[2]
		cRet			:=	aRetorno[1]
	MsUnlock()
EndIf


	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё	  FUNCAO MOSTRA MENSAGEM DO CODIGO DE RETORNO DA SEFAZ      Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	********************************************************
		IIF(!Empty(ZXC->ZXC_CODRET), ExecBlock("CTe_Erro",.F.,.F.,{''}), MsgInfo('CСdigo de Retorno do XML esta em branco.') )
	********************************************************


RestArea(aArea5)
Return(cRet)
*****************************************************************
User Function CTe_SiteSefaz()    //    [6.0]
*****************************************************************
//зддддддддддддддддддддддддддддддддддддддд©
//Ё Abre Portal da Nota Fiscal Eletronica Ё
//Ё Chamada -> Rotina Site Sefaz          Ё
//юддддддддддддддддддддддддддддддддддддддды

DbSelectArea('ZXC')
ShellExecute("open",AllTrim(GetMv('XM_SEFAZ'))+AllTrim(ZXC->ZXC_CHAVE),"","",1)

Return()
*********************************************************************
User Function CTe_Erro()    //    [7.0]
*********************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Retorno mensagem do status do XML     				Ё
//|	\SYSTEM\ZXC_ERROS_NFE.TXT contem os erros de retorno|
//Ё Chamada -> Rotina Msg.Erro            				Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cErroXML	:= AllTrim(ZXC->ZXC_CODRET)
Local cLinha    :=	''
Local cLnErro  	:=	''
Local cMsgErro	:=	''

If Empty(cErroXML)
	Alert('Cod.Ret. XML esta em branco.  Verifique o Status do XML.'+ENTER+'OpГЦo: Consulta Sefaz-> Status XML') 
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
   Alert('Arquivo de Erros nЦo encontrado no caminho: '+_StartPath+cArqErro )
EndIf


Return()
*****************************************************************
User Function CTe_Exporta()    //    [8.0]
*****************************************************************
//зддддддддддддддддддддддддддддддддддддддд©
//Ё Exporta XML para Arquivo              Ё
//Ё Chamada -> Rotina Exportar            Ё
//юддддддддддддддддддддддддддддддддддддддды

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


//зддддддддддддддддддддддддддддддддддддддд©
//Ё       BROSWER COM PARAMETROS          Ё
//юддддддддддддддддддддддддддддддддддддддды
oFont1     := TFont():New( "Arial",0,IIF(nHRes<=800,-09, -11),,.F.,0,,400,.F.,.F.,,,,,, )
oDlg2      := MSDialog():New( D(151),D(347),D(496),D(791),"Exporta CT-e",,,.F.,,,,,,.T.,,oFont1,.T. )
oGrp1      := TGroup():New( D(000),D(001),D(144),D(220),"",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( D(028),D(005),{||"Nota Fiscal Inicial"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(052),D(008) )
oGetNF_Ini := TGet():New( D(024),D(065),{|u| If(PCount()>0,cNF_Ini:=u,cNF_IЖni)},oGrp1,D(060),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNF_Ini",,)
oSay10     := TSay():New( D(024),D(130),{||"SИrie"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(052),D(008) )
oGetSer_Ini:= TGet():New( D(024),D(144),{|u| If(PCount()>0,cSerie_Ini:=u,cSerie_Ini)},oGrp1,D(020),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSerie_Ini",,)

oSay2      := TSay():New( D(044),D(005),{||"Nota Fiscal Final"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(048),D(008) )
oGetNF_fin := TGet():New( D(040),D(065),{|u| If(PCount()>0,cNF_fin:=u,cNF_fin)},oGrp1,D(060),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNF_fin",,)
oSay11     := TSay():New( D(044),D(130),{||"SИrie"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(052),D(008) )
oGetSer_fin:= TGet():New( D(040),D(144),{|u| If(PCount()>0,cSerie_fin:=u,cSerie_fin)},oGrp1,D(020),D(008),'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSerie_fin",,)

oSay3      := TSay():New( D(060),D(005),{||"DiretСrio de Destino"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,D(052),D(008) )
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
//зддддддддддддддддддддддддддддддддддддддд©
//Ё Exporta XML para Arquivo              Ё
//| Seleciona os XML para exportar		  |
//Ё Chamada -> Rotina Exportar            Ё
//юддддддддддддддддддддддддддддддддддддддды
Local _nCount :=    0


If Empty(cExpDiretorio )
   Alert('Informe o diretСrio de Destino !!!')
Else
   DbSelectArea('ZXC');DbGoTop()
   Do While !Eof()
           If ZXC->ZXC_DOC >= cNF_Ini      .And. ZXC->ZXC_DOC <= cNF_Fin     .And.;
              ZXC->ZXC_SERIE >= cSerie_Ini    .And. ZXC->ZXC_SERIE <= cSerie_fin


           If !Empty(cFor_Ini)    .Or. !Empty(cFor_Fin)
               If !(ZXC->ZXC_FORNEC >= cFor_Ini  .And. ZXC->ZXC_FORNEC <= cFor_Fin)
                   DbSkip();Loop
               EndIf
           EndIf

           If !Empty(cForLj_In)    .Or. !Empty(cForLj_Fin)
               If !(ZXC->ZXC_LOJA >= cForLj_in     .And. ZXC->ZXC_LOJA <= cForLj_in)
                   DbSkip();Loop
               EndIf
           EndIf

           If !Empty(dData1)    .Or. !Empty(dData2)
               If !( ZXC->ZXC_DTIMP >= dData1    .And. ZXC->ZXC_DTIMP <= dData2 )
                   DbSkip();Loop
               EndIf
           EndIf

           cNomeXML :=    AllTrim(ZXC->ZXC_FORNEC)+'_'+AllTrim(ZXC->ZXC_LOJA)+'_'+AllTrim(ZXC->ZXC_DOC)+'_'+AllTrim(ZXC->ZXC_SERIE)

           cXML	:=	AllTrim(ZXC->ZXC_XML)
           cXML	+=	ExecBlock("CTe_VerificaZXD",.F.,.F., {ZXC->ZXC_FILIAL, ZXC->ZXC_CHAVE})	//	VERIFICA SE O XML ESTA NA TABELA ZXD

           MemoWrit( AllTrim(cExpDiretorio)+AllTrim(cNomeXML)+'.XML', cXML )

           _nCount++

       EndIf
       DbSkip()
   EndDo


EndIf

IIF(_nCount==0,Alert('Nenhum XML foi exportado !!!'), MsgInfo('XML exportado com sucesso!!!'))

DbSelectArea('ZXC');DbGoTop()

Return()
*****************************************************************
User Function CTe_Recusar()    //    [9.0]
*****************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Recusa XML \ Envia E-mail para Fornecedor   |
//Ё Chamada ->  Rotina Recusar                  Ё
//юддддддддддддддддддддддддддддддддддддддддддддды
Local cFornec	:=	Alltrim( Posicione('SA2',3,xFilial('SA2')+ ZXC->ZXC_CGC, 'A2_NOME') )
Local cChaveNFe	:=	AllTrim(ZXC->ZXC_CHAVE)

If ZXC->ZXC_STATUS=="R" 
	Alert('XML jА recusado !!!') 
EndIF

If MsgBox("Deseja recusar o recebimento da NOTA FISCAL: "+AllTrim(ZXC->ZXC_DOC)+"   SИrie: "+AllTrim(ZXC->ZXC_SERIE)+ENTER+;
            "Fornecedor: "+ZXC->ZXC_FORNEC+"-"+ZXC->ZXC_LOJA+" - "+AllTrim(cFornec)+"  ?","AtenГЦo...","YESNO")



	//зддддддддддддддддддддддддддддддддддддддд©
	//Ё VERIFICA SE DOC.ENTRADA FOI INCLUSO   Ё
	//юддддддддддддддддддддддддддддддддддддддды
   	DbSelectArea('SF1');DbSetOrder(1);DbGoTop()
   	If !DbSeek(xFilial('SF1')+ ZXC->ZXC_DOC + ZXC->ZXC_SERIE + ZXC->ZXC_FORNEC + ZXC->ZXC_LOJA + 'N' ,.F.)


       If MsgBox("Deseja enviar um email para o fornecedor para ficar documentado esta recusa?","AtenГЦo...","YESNO")
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё BROWSER PARA USER INFORMAR O MOTIVO DA RECUSA DO XML	|
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
           *************************
               MsgRecusarXML()
           *************************

       Endif


       DbSelectArea('ZXC');DbSetOrder(6);DbGoTop()
       If DbSeek( cChaveNFe, .F.)
           If Reclock('ZXC',.F.)
              	ZXC->ZXC_STATUS := 'R'    // RECUSADO RECEBIMENTO
           	  MsUnlock()
			EndIf
       	EndIf

       	MsgInfo('NOTA FISCAL: '+AllTrim(ZXC->ZXC_DOC)+' SиRIE: '+AllTrim(ZXC->ZXC_SERIE)+' RECUSADA COM SUCESSO!!!')

   	Else
		MsgAlert('XML nЦo pode ser recusado!!!'+ENTER+'Primeiro exclua o Doc.Entrada vinculado a esse XML.'+ENTER+'Documento:'+SF1->F1_DOC+' - '+SF1->F1_SERIE)
   	EndIf
   	
Endif

Return()
*****************************************************************
Static Function MsgRecusarXML()
*****************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Envia E-mail para Fornecedor                |
//Ё Chamada ->  Recusar_XML                     Ё
//юддддддддддддддддддддддддддддддддддддддддддддды

SetPrvt("oFont1","oDlg1","oGrp","oSay1","oSay2","oGet1","oMGet1","oBtn2")

cSubject   :=    'Nota Fiscal: '+ZXC->ZXC_DOC+' Serie: '+ZXC->ZXC_SERIE+' recebimento recusado'
cHtml      :=    ''
cMsgUser   :=    ''
cForEmail  :=    AllTrim(Posicione('SA2',3,xFilial('SA2')+ZXC->ZXC_CGC,'A2_EMAIL'))+Space(200)

oFont1     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-09, -11),,.T.,0,,700,.F.,.F.,,,,,, )
oDlgRec    := MSDialog():New( D(095),D(232),D(462),D(829),"Carregar arquivo XML",,,.F.,,,,,,.T.,,oFont1,.T. )
oGrp       := TGroup():New( D(004),D(004),D(156),D(284),"",oDlgRec,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( D(012),D(008),{||"Email Forncedor (Para adicionar mais e-mails separar por;) "},oGrp,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(208),D(008))
oGet1      := TGet():New( D(020),D(008),{|u| If(PCount()>0,cForEmail:=u,cForEmail)},oGrp,D(272),D(008),'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSay2      := TSay():New( D(036),D(008),{||"Adicionar informaГУes:"},oGrp,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(080),D(008))
oMGet1     := TMultiGet():New( D(044),D(008),{|u| If(PCount()>0,cMsgUser:=u,cMsgUser)},oGrp,D(272),D(108),oFont1,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oBtn2      := TButton():New( D(160),D(120),"Ok",oDlgRec,{|| oDlgRec:End() },D(037),D(012),,,,.T.,,"",,,,.F. )

oDlgRec:Activate(,,,.T.)


//зддддддддддддддддддддддддддддддддддддддддддддд©
//Ё 			CORPO DO E-MAIL                 |
//юддддддддддддддддддддддддддддддддддддддддддддды

cHtml += '<html>'
cHtml += '<head>'
cHtml += '<h3 align = Left><font size="3" color="#FF0000" face="Arial">Recusado Recebimento Nota Fiscal: '+AllTrim(ZXC->ZXC_DOC)+' SИrie: '+AllTrim(ZXC->ZXC_SERIE)+'</h3></font>'
cHtml += '</head>'

cHtml += '<body bgcolor = white text=black>'
cHtml += '<hr width=100% noshade>'
cHtml += '<br></br>'

cNomeFil    :=	AllTrim( Posicione('SM0', 1, cEmpAnt + cFilAnt,  'M0_FILIAL' ))
cCcgFil		:=	AllTrim( Posicione('SM0', 1, cEmpAnt + cFilAnt,  'M0_CGC'    ))
cEmpNome    :=	AllTrim( Posicione('SM0', 1, cEmpAnt + cFilAnt,  'M0_NOMECOM'))

cHtml += '<b><font size="3" face="Arial"> '+cEmpNome+'  -  '+ TransForm(cCcgFil,"@R 99.999.999/9999-99")+'</font></b>'
cHtml += '<br></br>'

cHtml += '<b><font size="3" face="Arial">Recusado  em: </font></b>'+'<b><font size="3" face="Arial"> '+Dtoc(Date())+' Юs '+Time()+'</font></b>'
cHtml += '<br></br>'

cMsgPadrao :=    'Recusado Recebimento Nota Fiscal: '+AllTrim(ZXC->ZXC_DOC)+' SИrie: '+AllTrim(ZXC->ZXC_SERIE)
cHtml += '<br></br>'
cHtml += '<b><font size="3" face="Arial"><I>'+cMsgPadrao+'</font></b></I>'
cHtml += '<br></br>'
cHtml += '<b><font size="3" face="Arial"><I>'+cMsgUser+'</font></b></I>'
cHtml += '<br></br>'
cHtml += '<br></br>'

cHtml += '<b><font size="2" color="#9C9C9C" face="Arial"> E-mail enviado automaticamente, nЦo responda este e-mail </font></b>'
cHtml += '</html>'


   ***********************************************************************************************
       lRetotno     := U_ENVIA_EMAIL('ImpXMLCTe', cSubject, AllTrim(cForEmail), '', '', cHtml, '', '')
   ***********************************************************************************************

If !lRetotno
   Alert('Problema no envio do email.'+ENTER+'Email nЦo enviado!!!')
EndIf

Return()
*****************************************************************
User Function CTe_Cancelar()    //    [10.0]
*****************************************************************
//зддддддддддддддддддддддддддддддддддддддд©
//Ё Cancela XML                           Ё
//Ё Chamada -> Rotina Cancelar            Ё
//юддддддддддддддддддддддддддддддддддддддды
Local    cMsgCanc    :=    ''
Local    ZXCnRecno    :=    ZXC->(Recno())

DbSelectArea('ZXC')

If ZXC->ZXC_STATUS == 'X' 
	Alert('XML jА cancelado !!!') 
EndIF

If MsgYesNo('Deseja realmente CANCELAR este XML???'+ENTER+ENTER+'FORNECEDOR: '+ZXC->ZXC_FORNEC+'-'+ZXC->ZXC_LOJA +ENTER+' NOTA: '+Alltrim(ZXC->ZXC_DOC)+'  SИrie: '+AllTrim(ZXC->ZXC_SERIE) )

	//зддддддддддддддддддддддддддддддддддддддд©
	//Ё VERIFICA SE DOC.ENTRADA FOI INCLUSO   Ё
	//юддддддддддддддддддддддддддддддддддддддды
	DbSelectArea('SF1');DbSetOrder(1);DbGoTop()
	If !DbSeek(xFilial('SF1')+ ZXC->ZXC_DOC + ZXC->ZXC_SERIE + ZXC->ZXC_FORNEC + ZXC->ZXC_LOJA + 'N' ,.F.)

		SetPrvt("oFont1","oDlgCanc","oGrp","oSay1","oSay2","oGet1","oMGet1","oBtn2")

		//зддддддддддддддддддддддддддддддддддддддд©
		//Ё       Motivo Cancelamento XML         Ё
		//юддддддддддддддддддддддддддддддддддддддды
		oFont1     := TFont():New( "MS Sans Serif",0,IIF(nHRes<=800,-09, -11),,.T.,0,,700,.F.,.F.,,,,,, )
		oDlgCanc   := MSDialog():New( D(095),D(232),D(462),D(829),"Motivo Cancelamento XML",,,.F.,,,,,,.T.,,oFont1,.T. )
		oGrp       := TGroup():New( D(004),D(004),D(156),D(284),"",oDlgCanc,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oSay2      := TSay():New( D(012),D(008),{||"Informe o Motivo Cancelamento XML:" },oGrp,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,D(150),D(008) )
		oMGet1     := TMultiGet():New(D(025),D(008),{|u| If(PCount()>0,cMsgCanc:=u,cMsgCanc)},oGrp,D(272),D(118),oFont1,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
		oBtn2      := TButton():New( D(160),D(120),"Ok",oDlgCanc,{|| IIF(Len(AllTrim(cMsgCanc))<5, Alert('Informe o motivo do cancelamento.') ,oDlgCanc:End()) },D(037),D(012),,,,.T.,,"",,,,.F. )

		oDlgCanc:Activate(,,,.T.)

		DbSelectArea('ZXC')
		If Reclock("ZXC",.F.)
				ZXC->ZXC_STATUS := 'X'
				ZXC->ZXC_OBS    := cMsgCanc
			MsUnlock()
		EndIf

		MsgInfo('XML cancelado com sucesso !!!') 
			
	Else
           MsgAlert('Arquivo nЦo pode ser cancelado!!!'+ENTER+'Primeiro exclua o Doc.Entrada vinculado a esse XML.'+ENTER+'Documento:'+SF1->F1_DOC+' - '+SF1->F1_SERIE)
	EndIf

EndIf


DbSelectArea('ZXC');DbGoTo(ZXCnRecno)

Return()
*****************************************************************
User Function CTe_Excluir()    //    [11.0]
*****************************************************************
//зддддддддддддддддддддддддддддддддддддддд©
//Ё Exclui  XML                           Ё
//Ё Chamada -> Rotina Excluir_XML         Ё
//юддддддддддддддддддддддддддддддддддддддды
Local ZXCnRecno	:=  ZXC->(Recno())
Local _cFilial 	:=	ZXC->ZXC_FILIAL
Local cChave	:=	ZXC->ZXC_CHAVE

DbSelectArea('ZXC')


If MsgYesNo('Deseja realmente EXCLUIR este XML???'+ENTER+ENTER+'FORNECEDOR: '+ZXC->ZXC_FORNEC+'-'+ZXC->ZXC_LOJA +ENTER+' NOTA: '+Alltrim(ZXC->ZXC_DOC)+'  SИrie: '+AllTrim(ZXC->ZXC_SERIE) )

		//зддддддддддддддддддддддддддддддддддддддд©
		//Ё VERIFICA SE DOC.ENTRADA FOI INCLUSO   Ё
		//юддддддддддддддддддддддддддддддддддддддды
		DbSelectArea('SF1');DbSetOrder(1);DbGoTop()
		If !DbSeek(xFilial('SF1')+ ZXC->ZXC_DOC + ZXC->ZXC_SERIE + ZXC->ZXC_FORNEC + ZXC->ZXC_LOJA + 'N' ,.F.)

           DbSelectArea('ZXC')
           If  Reclock("ZXC",.F.)
               		DbDelete()
           	  MsUnlock()
           EndIf
      
			ZXD->(DbSetOrder(1), DbGoTop())
			If ZXD->(DbSeek(_cFilial + cChave ,.F.))
				Do While ZXD->(!Eof()) .And. ZXD->ZXD_CHAVE == cChave
					Reclock('ZXD',.F.)
						DbDelete()
					MsUnlock()
				ZXD->(DbSkip())
				EndDo
			EndIf
			      
      
			MsgInfo('XML Excluido com sucesso !!!') 

     Else
           MsgAlert('Arquivo nЦo pode ser EXCLUIDO!!!'+ENTER+'Primeiro exclua o Doc.Entrada vinculado a esse XML.'+ENTER+'Documento:'+SF1->F1_DOC+' - '+SF1->F1_SERIE)
     EndIf

EndIf


DbSelectArea('ZXC');DbGoTo(ZXCnRecno)

Return()
*****************************************************************
User Function CTe_Filtro()    //    [11.00]
*****************************************************************
//зддддддддддддддддддддддддддддддддддддддд©
//Ё Opcao de Filtro - apenas DBF          Ё
//Ё Chamada -> Rotina Filtro              Ё
//юддддддддддддддддддддддддддддддддддддддды
Local aArea	  := GetArea()
Local aCampos := {}

Private	bFiltraBrw	:=	{|| Nil }
Static	cFiltroRet	:=	''
Static	aIndexXml	:=	''

DbSelectArea('SX3');DbSetOrder(1);DbGoTop()
Do While !Eof() .And. SX3->X3_ARQUIVO == 'ZXC'
	aAdd( aCampos, {SX3->X3_CAMPO	, SX3->X3_PICTURE, SX3->X3_TITULO })
	DbSkip()
EndDo                      

   cFiltroRet := BuildExpr('ZXC',,'',.T.,,,,'Filtro XML',,aCampos)
   EndFilBrw('ZXC',aIndexXml)
   aIndexXml     := {}
   bFiltraBrw        := {|| FilBrowse('ZXC',@aIndexXml,@cFiltroRet) }
   Eval(bFiltraBrw)
   DbSelectArea('ZXC');DbGoTop()


RestArea(aArea)
Return(Nil)
*********************************************************************
Static Function OpcaoRetorno()
*********************************************************************
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё DEVOLUCAO      - FUNCAO F4NFORI  PADRAO DO MICROSIGA				|
//Ё BENEFICIAMENTO - FUNCAO F4Poder3 PADRAO DO MICROSIGA				|
//|																		|
//|	Chamada -> Visual_XML()->oBrwV:oBrowse:bLDblClick->VerifStatus()	Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
                              
// 	NOVA VERSAO NAO PREENCHE COD.FORNECEDOR E LOJA DESSA MANEIRA APRESENTA A TELA A SEGUIR.


Private nPosCod  := Ascan( oBrwV:aHeader, {|X| AllTrim(X[2]) == 'D1_COD'	})
Private aTpNota  := {"Normal","DevoluГЦo","Beneficiamento","Compl. ICMS","Compl. IPI","Compl. PreГo/Frete" }
Private nTpNota  := 1
Private aTpForm  := {"Sim","NЦo"}
Private nTpForm  := 2
Private cVarCliFor := "Fornece:"
Private cNomeCliFor:= ""
Private cCodCliFor 	:= Space(06)
Private cCodLoja 	:= Space(02)
                    
SetPrvt("oFont1","oDlgBD","oGrp1","oCBoxTpNF","oCBoxTpNF","oCBoxNor","oCBoxDev","oCBoxBen","oGrp2","oCBoxSim","oCBoxNao","oBtn1")

nPosItem  := Ascan(oBrwV:aHeader,{|X| Alltrim(X[2])=="D1_ITEM"		})
nPosPFor  := Ascan(oBrwV:aHeader,{|X| Alltrim(X[2])=="C7_PRODUTO"	})
nPTES     := Ascan(oBrwV:aHeader,{|x| AllTrim(x[2])=="D1_TES"		})


If Empty(oBrwV:aCols[oBrwV:NAT][nPTES]) .And. !Empty(ZXC->ZXC_FORNEC).And. !Empty(ZXC->ZXC_LOJA)
	Msgbox("Campo TES nЦo esta identificado, corrija primeiro!"+ENTER+ENTER+'Item: '+oBrwV:aCols[oBrwV:NAT][nPosItem]+'  -  Prod.Fornec: '+oBrwV:aCols[oBrwV:NAT][nPosPFor],"AtenГЦo...","ALERT")
	Return()
EndIf			


If Empty(ZXC->ZXC_TIPO)

	oFont1     := TFont():New( "Verdana",0,IIF(nHRes<=800,-09, -11),,.T.,0,,700,.F.,.F.,,,,,, )
	oDlgBD     := MSDialog():New( D(142),D(361),D(299),D(674),"DevoluГЦo \ Retorno",,,.F.,,,,,,.T.,,oFont1,.T. )

	oGrp1      := TGroup():New( D(008),D(004),D(030),D(072),"Tipo Nota",oDlgBD,CLR_BLACK,CLR_WHITE,.T.,.F. ) 
	oCBoxTpNF  := TComboBox():New( D(018),D(010), {|u|if(PCount()>0,nTpNota:=u,nTpNota)},aTpNota,072,010,oDlgBD,,{|| AtualizaGet(), cCodCliFor:=Space(06), cCodLoja :=	Space(02), cNomeCliFor := "" },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,)
		
	oGrp2      := TGroup():New( D(008),D(080),D(030),D(148),"FormulАrio PrСprio",oDlgBD,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oCBoxTpFor := TComboBox():New( D(018),D(085), {|u|if(PCount()>0,nTpForm:=u,nTpForm)},aTpForm,062,010,oDlgBD,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )	
                  
	oSayCgc    := TSay():New( D(034),D(010),{|| "CNPJ:  "+ Transform(AllTrim(ZXC->ZXC_CGC), IIF(Len(AllTrim(ZXC->ZXC_CGC))==14,'@R 99.999.999/9999-99','@R 999.999.999-99'))  },oDlgBD,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)

	oSayCliFor := TSay():New( D(046),D(010),{|| cVarCliFor  },oDlgBD,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGetSA2    := TGet():New( D(044),D(035),{|u| If(PCount()>0,cCodCliFor:=u,cCodCliFor) },oDlgBD,040,008,'', {|| AtualizaGet() }, CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","",,)
	oGetSA1    := TGet():New( D(044),D(035),{|u| If(PCount()>0,cCodCliFor:=u,cCodCliFor) },oDlgBD,040,008,'', {|| AtualizaGet() }, CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","",,)		 	
	oGetLoja   := TGet():New( D(044),D(070),{|u| If(PCount()>0,cCodLoja:=u,cCodLoja)     },oDlgBD,005,008,'', {|| AtualizaGet() }, CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)		 	

	oSayNome   := TSay():New( D(057),D(010),{|| cNomeCliFor },oDlgBD,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)			
	
	oBtnOK     := TButton():New( D(065),D(056),"OK",oDlgBD,{|| IIF(ValidaDados(cCodCliFor),(Atu_SayDev(),oDlgBD:End()),) },D(037),D(012),,oFont1,,.T.,,"",,,,.F. )
	                  
	oBtnOK:SetFocus()
		
	oDlgBD:Activate(,,,.T.,,, {|| AtualizaGet(), oDlgBD:lEscClose := .F. } )
	
EndIf 
		
Return
*********************************************************************
Static Function AtualizaGet()
*********************************************************************

cVarCliFor := "Fornece: "
oGetSA1:Hide() 
oGetSA2:Show()
If !Empty(cCodCliFor) .And. !Empty(cCodLoja)
	SA2->(DbSetOrder(1),DbGoTop())
	If !SA2->(DbSeek(xFilial('SA2') + cCodCliFor + cCodLoja, .F. ))
		Alert('CСdigo Fornecedor nЦo existe!!!!') 
		cNomeCliFor := ""
		cCodLoja 	:= Space(02)
		cCodCliFor 	:= Space(06)
		cNomeCliFor := ""
	Else
		cCodCliFor 	:= SA2->A2_COD
		cCodLoja 	:= SA2->A2_LOJA
		cNomeCliFor := AllTrim(SA2->A2_NOME)
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
//зддддддддддддддддддддддддддддддддддддддддддддд©
//|	Chamada -> OpcaoRetorno - Botao OK			Ё
//юддддддддддддддддддддддддддддддддддддддддддддды
Local lReturn := .T. 

If Empty(cCodCliFor)

	Alert('Informe o cСdigo do Fornecedor !!!' )
	lReturn := .F.

Else
       
	_cCnpj := IIF(oCBoxTpNF:NAT==2.Or.oCBoxTpNF:NAT==3, AllTrim(SA1->A1_CGC), AllTrim(SA2->A2_CGC) )

	If AllTrim(ZXC->ZXC_CGC) != AllTrim(_cCnpj)
	   	Alert(	'CNPJ informado ['+Transform( AllTrim(_cCnpj), IIF(Len(AllTrim(_cCnpj))==14,'@R 99.999.999/9999-99','@R 999.999.999-99'))+'] '+ENTER+;
				'DIFERENTE'+ENTER+;
				'do CNPJ do XML ['+Transform( AllTrim(ZXC->ZXC_CGC), IIF(Len(AllTrim(ZXC->ZXC_CGC))==14,'@R 99.999.999/9999-99','@R 999.999.999-99'))+']' )
		
		lReturn := .F.

	Else

 		cTipoNota := ''
 		Do Case
 			Case oCBoxTpNF:NAT ==  1
		 		cTipoNota	:=	'N'
		 		cMsgDevRet	:=	'- Tipo Nota: Normal'
 			Case oCBoxTpNF:NAT == 2
 				cTipoNota	:=	'D'
				cMsgDevRet	:=	'- Tipo Nota: DevoluГЦo'
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
				cMsgDevRet	:=	'- Tipo Nota: Compl. PreГo/Frete'
 		EndCase

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё		GRAVA FORNECEDOR - TIPO DE NOTA NA TABELA ZXC        	        Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды	
		DbSelectArea('ZXC')
  		If Reclock('ZXC',.F.)               
				ZXC->ZXC_TIPO	:=	cTipoNota
				ZXC->ZXC_FORNEC	:=	cCodCliFor
				ZXC->ZXC_LOJA	:=	cCodLoja
			MsUnlock()
		EndIf                       
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё		ATUALIZA ALGUNS DADOS DO ACOLS, QDO EH FORNECEDOR            	Ё
		//Ё		APENAS QDO O PRODUTO JA ESTA RELACIONADO                     	Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		For nX := 1 To Len(aMyCols)                    
   
			nPLocal		:= Ascan(oBrwV:aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"	})
			nPTES		:= Ascan(oBrwV:aHeader,{|x| AllTrim(x[2])=="D1_TES"	})
			nPosCC		:= Ascan(oBrwV:aHeader,{|X| Alltrim(X[2])=="D1_CC"		})
			nPosConta	:= Ascan(oBrwV:aHeader,{|X| Alltrim(X[2])=="D1_CONTA"	})
			nPosCod		:= Ascan(oBrwV:aHeader,{|x| AllTrim(x[2])=="D1_COD"	}) 

	  		If !Empty(aMyCols[nX][nPosCod] )
				SB1->(DbGoTop(), DbSetOrder(1))
	           	If SB1->(DbSeek(xFilial('SB1') + oBrwV:aCols[nX][nPosCod] ,.F.) )
	           		oBrwV:aCols[nX][nPLocal] 	:= IIF(!Empty(SB1->B1_LOCPAD), AllTrim(SB1->B1_LOCPAD),)		//	Local Padrao 
	           		oBrwV:aCols[nX][nPTES]   	:= IIF(!Empty(SB1->B1_TE), 	AllTrim(SB1->B1_TE),)			//	Codigo de Entrada padrao
	           		oBrwV:aCols[nX][nPosCC] 	:= IIF(!Empty(SB1->B1_CONTA), 	AllTrim(SB1->B1_CONTA),)		//	Conta Contabil dn Prod.
	           		oBrwV:aCols[nX][nPosConta] 	:= IIF(!Empty(SB1->B1_CC), 	AllTrim(SB1->B1_CC),)			//	Centro de Custo
				ElseIf SX6->(DbGoTop(), DbSeek( cFilAnt+'MV_LOCPAD' ,.F.) )
					oBrwV:aCols[nX][nPLocal] 	:= IIF(!Empty(SX6->X6_CONTEUD), AllTrim(SX6->X6_CONTEUD),)
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

aClixFor[01] := "Fornecedor: "
aClixFor[02] := SA2->A2_NOME
aClixFor[03] := SA2->A2_COD +' - '+SA2->A2_LOJA
aClixFor[04] := Transform( SA2->A2_CGC, IIF( Len(SA2->A2_CGC)==14,'@R 99.999.999/9999-99','@R 999.999.999-99') ) 
aClixFor[05] := AllTrim(SA2->A2_END)+IIF(!Empty(SA2->A2_COMPLEM),'-'+SA2->A2_COMPLEM,'')+IIF(Empty(SA2->A2_NR_END),'',', '+SA2->A2_NR_END )   
               
aClixFor[06] := AllTrim(SA2->A2_MUN)+' - '+SA2->A2_EST
aClixFor[07] := IIF(!Empty(SA2->A2_DDD),'('+AllTrim(SA2->A2_DDD)+') - ','')+SA2->A2_TEL 


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

Return
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

cPrograma := 'IMPXMLCTE'


If Empty(cProduto) .Or. Empty(cTES)
	MsgAlert('Preencha os campos: PRODUTO e TIPO DE ENTRADA') 
	Return()
EndIf

SF4->(DbSetOrder(1), DbGoTop())
SF4->(DbSeek(xFilial('SF4') +  cTES ,.F.))


cCodDest  := Posicione("SA1",3,xFilial("SA1")+cDestCnpj,"A1_COD")
cLojaDest := Posicione("SA1",3,xFilial("SA1")+cDestCnpj,"A1_LOJA")
    
If oCBoxFret:nAT == 2	//	FRETE SOBRE COMPRAS	 -  oCBoxFret:nAT == 2 = NORMAL
	Help(" ",1,"F4NAONOTA")
	
Else
                                                                                                                           // A100-BUSCA INFO DO SD1 E A4440 DO SD2
 	MsgRun('Verificando NF Origem... Aguarde...', 'Aguarde... ',{|| MyF4Compl(,,,ZXC->ZXC_FORNEC,ZXC->ZXC_LOJA/*cCodDest, cLojaDest*/,cProduto,"A100"/*"A440"*/,/*@nRecSD1*/,"M->D1_NFORI") }) // .And. nRecSD1<>0
EndIf
    


    
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё APOS BUSCAR OS DADOS, PELA ROTINA PADRAO DO MICROSIGA, Ё
//Ё ALIMENTO aMyCols COM DADOS DE RETORNO DA BUSCA         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Gera DV para XML (Versao Old) que nao tenham Chave de Acesso   |
//|	VERSAO _INFNFE												   |
//Ё Chamada -> CabecCTeParser                                      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aChave	:= {}
Local nSoma    	:= 0
Local nResult	:= 0
Local nMult		:= 2
Local DV

//зддддддддддддддддддддддддддддддддддддд©
//Ё ALIMENTA aChave POSICAO a POSICAO	|
//юддддддддддддддддддддддддддддддддддддды
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

//SomatСria das ponderaГУes = 644
//Dividindo a somatСria das ponderaГУes por 11 teremos, 644 /11 = 58 restando 6.
//Como o dМgito verificador DV = 11 - (resto da divisЦo), portando 11 - 6 = 5
//Quando o resto da divisЦo for 0 (zero) ou 1 (um), o DV deverА ser igual a 0 (zero)

nResto     :=     Mod(nSoma,11)
If nResto == 0 .Or. nResto == 1
   DV     :=    0
Else
   DV     :=  11 - nResto
EndIf

Return( AllTrim(Str(DV)) )
***********************************************************************
User Function CTe_CreateTable()
***********************************************************************
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria SIX, SX2, SX3 da tabela ZXC, caso nao exista              |
//Ё Chamada -> Grava_CTe()                                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local   cField		:=	''
Local	aTabelaOK 	:=	{{'ZXC',.T.},{'ZXD',.T.}}
Local	lRet		:=	.F.
Private	cEmpDest	:=	ParamIxb[1]
Private	cNumEmpOrig	:=	cNumEmp    //    GUARDA VALOR ORIGINAL
Private	cEmpAntOrig	:=	cEmpAnt    //    GUARDA VALOR ORIGINAL
Private	cFilAntOrig	:=	cFilAnt    //    GUARDA VALOR ORIGINAL
Private	cNomeEmp	:=	''
Private cTabela		:=	''
Private cArqTab		:=	''
                                    

cZXCModo	:=  cZXDModo	:=    ''
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('ZXC'))
   cZXCModo	:=    AllTrim(SX2->X2_MODO)
EndIf
If SX2->(DbSetOrder(1),DbGoTop(),DbSeek('ZXD'))
   cZXDModo	:=    AllTrim(SX2->X2_MODO)
EndIf



For nI := 1 To 2

	cTabela	:=	IIF(nI==1,'ZXC','ZXD')                                   
	cArqTab :=  cTabela+cEmpDest +'0'
	nPosTab	:=	Ascan(aTabelaOK, {|X|X[1] == cTabela } )
	
	
	//зддддддддддддддддддддддддддд©
	//Ё  FECHA SX2 EMPRESA ATUAL  Ё
	//юддддддддддддддддддддддддддды
	IIF(Select('SX2')!=0, SX2->(DbCLoseArea()  ), )
	//зддддддддддддддддддддддддддд©
	//Ё  FECHA ZXC EMPRESA ATUAL  Ё
	//юддддддддддддддддддддддддддды
	IIF(Select(cArqTab)!=0, cTabela->(DbCLoseArea()  ), )
	
	//здддддддддддддддддддддддддддддддддддд©
	//Ё  RECEBE VALOR DA EMPRESA DESTINO   |
	//юдддддддддддддддддддддддддддддддддддды
	cNumEmp    :=    cEmpDest+'01'
	cEmpAnt    :=    cEmpDest
	cFilAnt    :=    '01'
	
	//зддддддддддддддддддддддддддддддддд©
	//Ё  BUSCA NOME DA EMPRESA DESTINO  |
	//юддддддддддддддддддддддддддддддддды
	nFilDest := Ascan(_aEmpFil, {|X| X[1] == cEmpDest })
	cNomeEmp := Alltrim(_aEmpFil[nFilDest][1]+'-'+_aEmpFil[nFilDest][2]+' \ '+_aEmpFil[nFilDest][4])
	
	
	//зддддддддддддддддддддддддддддд©
	//Ё ABRE SX2 DA EMPRESA DESTINO Ё
	//юддддддддддддддддддддддддддддды
	DbUseArea(.T.,,_StartPath+'SX2'+ cEmpDest +'0', 'SX2' ,.T.,.F.)
	DbSetIndex(_StartPath+'SX2'+ cEmpDest +'0')
	
	
	#IFDEF TOP
	   If !TCCanOpen(cArqTab)
	       Processa( {|| CriaZXC(cTabela,cEmpDest)},'Aguarde...','Criando arquivos SX╢s Tabela '+cTabela+', Empresa: '+cNomeEmp, .T.)
	   EndIf
	#ELSE
	   ChkFile(cTabela,.T.,cTabela,Processa({|| CriaZXC(cTabela,cEmpDest)},'Aguarde...','Criando arquivos SX╢s Tabela '+cTabela+' Empresa: '+cNomeEmp, .T.),,,'',.T.)
	#ENDIF
	
	
	//здддддддддддддддддддддддддддддддддддддддддд©
	//Ё VERIFICA SE TODOS CAMPOS FORAM CRIADOS   |
	//юдддддддддддддддддддддддддддддддддддддддддды
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
	   MsgAlert('NцO FOI POSSмVEL CRIAR TODOS OS CAMPOS DA TABELA '+cTabela+' !!!'+ENTER+;
	               'Empresa: '+cNomeEmp+ENTER+ENTER+;
	              'Verifique a estrutura da tabela.'+ENTER+;
	              'Entre no modulo Configurador e Crie\Recrie o(s) seguinte(s) campo(s):'+ENTER+ cField  )
	   cField	:=	''
	
	EndIf
		
Next


//зддддддддддддддддддддддддддддддддд©
//Ё ABRE ARQUIVO DE CONFIGURACAO    |
//юддддддддддддддддддддддддддддддддды
For nX:=1 To Len(aTabelaOK)

	lRet	:=	IIF(aTabelaOK[nX][2], .T., .F. )
	If !lRet
		Exit
	EndIf
	
Next

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё ATUALIZA CAMPO ESTRUT_ZXC DO ARQUIVO CTE_CFG.DBF     	 |
//Ё UTILIZADO PARA VERIFICAR SE ESTRUTURA DA TABELA ESTA OK  |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()
If DbSeek(cEmpAnt+cFilAnt, .F.)
   RecLock('TMPCTE',.F.)
       	TMPCTE->ESTRUT_ZXC := lRet
   MsUnLock()
EndIf

	
//зддддддддддддддддддддддддддд©
//Ё FECHA SX2 EMPRESA DESTINO Ё
//юддддддддддддддддддддддддддды
IIF(Select('SX2')!=0, SX2->(DbCLoseArea()  ), )
//зддддддддддддддддддддддддддд©
//Ё FECHA ZXC EMPRESA DESTINO Ё
//юддддддддддддддддддддддддддды
IIF(Select('ZXC')!=0, ZXC->(DbCLoseArea()  ), )
IIF(Select('ZXD')!=0, ZXD->(DbCLoseArea()  ), )


//зддддддддддддддддддддддддддд©
//Ё    VOLTA VALOR ORIGINAL   Ё
//юддддддддддддддддддддддддддды
cNumEmp    :=    cNumEmpOrig
cEmpAnt    :=    cEmpAntOrig
cFilAnt    :=    cFilAntOrig


//зддддддддддддддддддддддддддд©
//Ё  ABRE SX2 EMPRESA ATUAL   Ё
//юддддддддддддддддддддддддддды
DbUseArea(.T.,,_StartPath+'SX2'+ cEmpAnt +'0', 'SX2' ,.T.,.F.)
DbSetIndex(_StartPath+'SX2'+ cEmpAnt +'0')

//здддддддддддддддддддддддддддддддд©
//Ё  ABRE ZZXC\ZXD EMPRESA ATUAL   Ё
//юдддддддддддддддддддддддддддддддды
EmpOpenFile('ZXC',"ZXC",1,.T.,cEmpAnt,@cZXCModo)
EmpOpenFile('ZXD',"ZXD",1,.T.,cEmpAnt,@cZXDModo)

Return(lRet)
***********************************************************************
Static Function CriaZXC()
***********************************************************************

Processa({||CriaSIX(cTabela)},'SIX... ','Aguarde... Tabela'+cTabela, .T.)
Processa({||CriaSX2(cTabela)},'SX2... ','Aguarde... Tabela'+cTabela, .T.)
Processa({||CriaSX3(cTabela)},'SX3... ','Aguarde... Tabela'+cTabela, .T.)


IIF(Select('ZXC')!=0, ZXC->(DbCLoseArea()  ), )
IIF(Select('ZXD')!=0, ZXD->(DbCLoseArea()  ), )

Return()
***********************************************************************
Static Function CriaSIX()	//	CRIA SIX ou SINDEX
***********************************************************************
Local lSindex	:=	.F.

ProcRegua(3)

IIF( Select('SIX_ORIG') !=0, SIX_ORIG->(DbCLoseArea()  ), )

//зддддддддддддддддддддддддддд©
//Ё       VERIFICA  SIX  	  Ё
//юддддддддддддддддддддддддддды
If File(_StartPath+'SIX'+cEmpAntOrig+'0.'+Right(__LocalDriver,3))

	//зддддддддддддддддддддддддддд©
	//Ё ABRE SIX DA EMPRESA ATUAL Ё
	//юддддддддддддддддддддддддддды
	DbUseArea(.T.,,_StartPath+'SIX'+cEmpAntOrig+'0','SIX_ORIG',.T.,.F.)
	DbSetIndex(_StartPath+'SIX'+cEmpAntOrig+'0')
	                              
    
//зддддддддддддддддддддддддддд©
//Ё  VERIFICA  S I N D E X    Ё
//юддддддддддддддддддддддддддды
ElseIf File(_StartPath+'SINDEX.'+Right(__LocalDriver,3))
 
	//здддддддддддддддддддддддддддддд©
	//Ё ABRE SINDEX DA EMPRESA ATUAL Ё
	//юдддддддддддддддддддддддддддддды
	DbUseArea(.T.,,_StartPath+'SINDEX','SIX_ORIG',.T.,.F.)
	DbSetIndex(_StartPath+'SINDEX')
	lSindex	  := .T.

EndIf



DbSelectArea('SIX_ORIG');DbSetOrder(1);DbGoTop()
If DbSeek(cTabela+'1', .F.)    //    INDICE + ORDEM
   IncProc()

   //зддддддддддддддддддддддддддд©
   //ЁABRE SIX DA EMPRESA DESTINOЁ
   //юддддддддддддддддддддддддддды
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
   MsgAlert('NЦo encontrado INDICE "'+cTabela+'" da Empresa atual.... Verifique tabela de indices...'+ENTER+'Ou crie o indice: '+cTabela)
EndIf


IIF( Select('SIX_ORIG') !=0, SIX_ORIG->(DbCLoseArea() ),)
IIF( Select('SIX_DEST') !=0, SIX_DEST->(DbCLoseArea() ),)

Return()
***********************************************************************
Static Function CriaSX2()
***********************************************************************

ProcRegua(3);IncProc()

//зддддддддддддддддддддддддддд©
//ЁABRE SX2 DA EMPRESA ATUAL  Ё
//юддддддддддддддддддддддддддды
IIF( Select('SX2_ORIG') !=0, SX2_ORIG->(DbCLoseArea()  ), )
DbUseArea(.T.,,_StartPath+'SX2'+cEmpAntOrig+'0','SX2_ORIG',.T.,.F.)
DbSetIndex(_StartPath+'SX2'+cEmpAntOrig+'0')

DbSelectArea('SX2_ORIG');DbSetOrder(1);DbGoTop()
If DbSeek(cTabela, .F.)    //    CHAVE
   IncProc()

   //зддддддддддддддддддддддддддд©
   //ЁABRE SX2 DA EMPRESA DESTINOЁ
   //юддддддддддддддддддддддддддды
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
   MsgAlert('NЦo encontrado chave "'+cTabela+'" na tabela SX2 da Empresa atual.... Verifique tabela SX2...'+ENTER+'Ou crie a chave '+cTabela+' na tabela SX2.')
EndIf

IncProc()

IIF( Select('SX2_ORIG') !=0, SX2_ORIG->(DbCLoseArea() ),)
IIF( Select('SX2_DEST') !=0, SX2_DEST->(DbCLoseArea() ),)

Return()
***********************************************************************
Static Function CriaSX3()
***********************************************************************
ProcRegua(3);IncProc()

//зддддддддддддддддддддддддддд©
//ЁABRE SX3 DA EMPRESA ATUAL  Ё
//юддддддддддддддддддддддддддды
IIF( Select('SX3_ORIG') !=0, SX3_ORIG->(DbCLoseArea()  ), )
DbUseArea(.T.,,_StartPath+'SX3'+cEmpAntOrig+'0','SX3_ORIG',.T.,.F.)
DbSetIndex(_StartPath+'SX3'+cEmpAntOrig+'0')

DbSelectArea('SX3_ORIG');DbSetOrder(1);DbGoTop()
If DbSeek(cTabela+'01', .F.)        //    X3_ARQUIVO + Z3_ORDERM
   IncProc()

   //зддддддддддддддддддддддддддд©
   //ЁABRE SX3 DA EMPRESA DESTINOЁ
   //юддддддддддддддддддддддддддды
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
   MsgAlert('NЦo encontrado arquivo "'+cTabela+'" na tabela SX3 na Empresa atual.... Verifique tabela SX3...'+ENTER+'Ou crie os campos na tabela: '+cTabela)
EndIf

IncProc()

IIF( Select('SX3_ORIG') !=0, SX3_ORIG->(DbCLoseArea() ),)
IIF( Select('SX3_DEST') !=0, SX3_DEST->(DbCLoseArea() ),)

Return()
***********************************************************************
Static Function ForCliMsBlql(cTabela, cCnpj, cCodFornece, cLojaFornece)
***********************************************************************
Local _lRet := .T.

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁFUNCAO PARA VERIFICAR SE CADASTRO DE CLIENTE OU FORNECEDOR Ё
//ЁNAO ESTA BLOQUEADO                                         Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If cTabela == 'SA2' 

	DbSelectArea('SA2');DbSetOrder(3);DbGoTop()
	If DbSeek(xFilial('SA2')+ cCnpj, .F.) 
		Do While !Eof() .And. AllTrim(SA2->A2_CGC) == AllTrim(cCnpj) .And. SA2->A2_MSBLQL == '1'  // 1=Sim;2=NДo
			DbSkip()
		EndDo
	Else
		_lRet := .F.
	EndIf
	
	    
EndIf

Return(_lRet)
***********************************************************************
Static Function C(nTam)
***********************************************************************
//зддддддддддддддддддддддддддддддддддддддд©
//Ё Ajusta Tamanho dos Objetos            Ё
//юддддддддддддддддддддддддддддддддддддддды
Local nHRes    :=    oMainWnd:nClientWidth 		// Resolucao horizontal do monitor

   If nHRes == 640                              // Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
       nTam *= 0.8
   ElseIf (nHRes == 798).Or.(nHRes == 800)    	// Resolucao 800x600
       nTam *= 1
   Else                                        	// Resolucao 1024x768 e acima
       nTam *= 1.28
   EndIf

   //зддддддддддддддддддддддддддд©
   //ЁTratamento para tema "Flat"Ё
   //юддддддддддддддддддддддддддды
   If "MP8" $ oApp:cVersion
       If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
           nTam *= 0.90
       EndIf
   EndIf
Return Int(nTam)
***********************************************************************
Static Function D(nTam)	//	QDO TELA Eh DESENVOLVIDA COM RESOLUCAO 1080
***********************************************************************
//зддддддддддддддддддддддддддддддддддддддд©
//Ё Ajusta Tamanho dos Objetos            Ё
//юддддддддддддддддддддддддддддддддддддддды
Local nHRes    :=    oMainWnd:nClientWidth		// Resolucao horizontal do monitor

   If nHRes == 640                            	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
       nTam /= 1.28
   ElseIf (nHRes == 798).Or.(nHRes == 800)    	// Resolucao 800x600
       nTam /= 1.28
   Else                                        	// Resolucao 1024x768 e acima
      nTam *= 1.28
   EndIf

   //зддддддддддддддддддддддддддд©
   //ЁTratamento para tema "Flat"Ё
   //юддддддддддддддддддддддддддды
   If "MP8" $ oApp:cVersion .Or. '10' $ cVersao 
       If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
           nTam /= 1.04
       EndIf
   EndIf
Return Int(nTam)
***********************************************************************
User Function VizualCTe()
***********************************************************************


cXML	:=	AllTrim(ZXC->ZXC_XML)
cXML	+=	ExecBlock("CTe_VerificaZXD",.F.,.F., {ZXC->ZXC_FILIAL, ZXC->ZXC_CHAVE})	//	VERIFICA SE O XML ESTA NA TABELA ZXD

*************************************************
   ExecBlock("CabecCTeParser",.F.,.F., {cXML})
*************************************************


//зддддддддддддддддддддддддддддд©
//Ё  FOLDER I  -  CABEC  	    Ё
//юддддддддддддддддддддддддддддды


//зддддддддддддддддддддддддддддд©
//Ё  FOLDER I  -  VALORES	    Ё
//юддддддддддддддддддддддддддддды
 cF1TotServ	:=	cVlrTotal
 cF1BCIcms	:=	cBaseIcms
 cF1VlrIcms	:=	cVlrIcms


//зддддддддддддддддддддддддддддд©
//Ё  FOLDER I  -  EMITENTE	    Ё
//юддддддддддддддддддддддддддддды
 cF1ECNPJ	:=	cEmitCnpj
 cF1ENome	:=	cEmitNome
 cF1EInscr	:=	cEmitIE
 cF1EUF		:=	cEmitUF

//зддддддддддддддддддддддддддддд©
//Ё  FOLDER I  -  DESTINATARIO  Ё
//юддддддддддддддддддддддддддддды
 cF1DCNPJ	:=	cDestCnpj
 cF1DNome	:=	cDestNome
 cF1DInscr	:=	cDestIE
 cF1DUF		:=	cDestUF

//зддддддддддддддддддддддддддддд©
//Ё  FOLDER I  -  TOMADOR	    Ё
//юддддддддддддддддддддддддддддды
 cF1TCNPJ	:=	cRemCnpj
 cF1TNome	:=	cRemNome
 cF1TInscr	:=	cRemIE
 cF1TUF		:=	cRemUF
 
//зддддддддддддддддддддддддддддд©
//Ё  FOLDER I  -  REMENTE	    Ё
//юддддддддддддддддддддддддддддды
 cF1RCNPJ	:=	cRemCnpj
 cF1RNome	:=	cRemNome
 cF1RInscr	:=	cRemIE
 cF1RUF		:=	cRemUF


//зддддддддддддддддддддддддддддд©
//Ё  FOLDER I  -  EXPEDIDOR	    Ё
//юддддддддддддддддддддддддддддды
 cF1XCNPJ	:=	IIF(!Empty(cExpCnpj), cExpCnpj, cEmitCnpj )
 cF1XNome	:=	IIF(!Empty(cExpNome), cExpNome, cEmitNome )
 cF1XInscr	:=	IIF(!Empty(cExpIE),   cExpIE,   cEmitIE   )
 cF1XUF		:=	IIF(!Empty(cExpUF),   cExpUF,   cEmitUF   )


//зддддддддддддддддддддддддддддд©
//Ё  FOLDER I  -  RECEBEDOR	    Ё
//юддддддддддддддддддддддддддддды
 cF1RECnpj	:=	Space(TamSx3('A1_CGC')[1])
 cF1RENome	:=	Space(TamSx3('A1_NOME')[1])
 cF1REInscr	:=	Space(TamSx3('A1_INSCR')[1])
 cF1REUF		:=	Space(TamSx3('A1_EST')[1])


Do Case
	Case cModal == '01'
 		cF1CModal	:=	'RodoviАrio'
	Case cModal == '02'
 		cF1CModal	:=	'AИreo'
	Case cModal == '03'
 		cF1CModal	:=	'AquaviАrio'
	Case cModal == '04'
 		cF1CModal	:=	'FerroviАrio'
	Case cModal == '05'
 		cF1CModal	:=	'DutoviАrio'
	OtherWise
		cF1CModal	:=	Space(001)
EndCase

Do Case
	Case cTpServ == '0'
 		cF1CTpServ	:=	'Normal'
	Case cTpServ == '1'
 		cF1CTpServ	:=	'SubcontrataГЦo'
	Case cTpServ == '2'
 		cF1CTpServ	:=	'Redespacho'
	Case cTpServ == '3'
 		cF1CTpServ	:=	'Redespacho IntermediАrio'
	OtherWise
		cF1CTpServ	:=	Space(001)
EndCase



 cF1CFinalid	:=	Space(001)
/*
tpCTe
0 - CT-e Normal;
1 - CT-e de Complemento de Valores;
2 - CT-e de AnulaГЦo de Valores;
3 - CT-e Substituto
*/
 cF1CForma	:=	Space(TamSx3('A1_NOME')[1])
/*
tpEmis
1 - Normal;
5 - ContingЙncia FSDA;
7 - AutorizaГЦo pela SVC-RS;
8 - AutorizaГЦo pela SVC-SP
*/
 cF1CCFOP	:=	cCFOP
 cF1CDigV	:=	cDigVal
 cF1cNatOper:=	cNatOper
 cF1CIniPrest:=	cMunIni+' - '+cxMunIni
 cF1CFimPrest:=	cMunFim+' - '+cxMunFim


//зддддддддддддддддддддддддддддд©
//Ё  FOLDER II -  EMITENTE    	Ё
//юддддддддддддддддддддддддддддды
 cF2ENome		:=	IIF(!Empty(cEmitNome), cEmitNome, Space(TamSx3('A2_NOME')[1]))
 cF2ECnpj		:=	IIF(!Empty(cEmitCnpj), cEmitCnpj, Space(TamSx3('A2_CGC')[1]))
 cNomeReduz 	:= Posicione("SA2",3,xFilial("SA2")+cF2ECnpj,"A2_NREDUZ")
  cF2ENFan		:=	IIF(!Empty(cNomeReduz), cNomeReduz, Space(TamSx3('A2_NREDUZ')[1]))
 cF2EInscr		:=	IIF(!Empty(cEmitIE),   cEmitIE, Space(TamSx3('A2_INSCR')[1]))
 cF2EEnd		:=	IIF(!Empty(cEmitEnd),  cEmitEnd, Space(TamSx3('A2_END')[1]))
 cF2EBairro	:=	IIF(!Empty(cEmitBairro), cEmitBairro, Space(TamSx3('A2_BAIRRO')[1]))
 cF2ECep		:=	IIF(!Empty(cEmitCep), cEmitCep, Space(TamSx3('A2_CEP')[1]))
 cF2EMun		:=	IIF(!Empty(cEmitMun), cEmitMun, Space(TamSx3('A2_MUN')[1]))
 cF2EUF		:=	IIF(!Empty(cEmitUF), cEmitUF, Space(TamSx3('A2_EST')[1]))
 cTeleone 	:= Posicione("SA2",3,xFilial("SA2")+cF2ECnpj,"A2_TEL")
 cF2EFone		:=	IIF(!Empty(cTeleone), cTeleone, Space(TamSx3('A2_TEL')[1]))

//зддддддддддддддддддддддддддддд©
//Ё  FOLDER III -  TOMADOR    	Ё
//юддддддддддддддддддддддддддддды
 cF3TNome	:=	Space(TamSx3('A1_NOME')[1])
 cF3TNFan	:=	Space(TamSx3('A1_NREDUZ')[1])
 cF3TCnpj	:=	Space(TamSx3('A1_CGC')[1])
 cF3TInscr	:=	Space(TamSx3('A1_INSCR')[1])
 cF3TEnd	:=	Space(TamSx3('A1_END')[1])
 cF3TBairro	:=	Space(TamSx3('A1_BAIRRO')[1])
 cF3TCep	:=	Space(TamSx3('A1_CEP')[1])
 cF3TMun	:=	Space(TamSx3('A1_MUN')[1])
 cF3TUF		:=	Space(TamSx3('A1_EST')[1])
 cF3TFone	:=	Space(TamSx3('A1_TEL')[1])
 cF3TRelCarga:=	Space(TamSx3('A1_NOME')[1])
 cF3TPais	:=	Space(TamSx3('A1_PAIS')[1])


//зддддддддддддддддддддддддддддд©
//Ё  FOLDER IV - DESTINATARIO  	Ё
//юддддддддддддддддддддддддддддды
 cF4DNome	:=	Space(TamSx3('A1_NOME')[1])
 cF4DNFan	:=	Space(TamSx3('A1_NREDUZ')[1])
 cF4DCnpj	:=	Space(TamSx3('A1_CGC')[1])
 cF4DInscr	:=	Space(TamSx3('A1_INSCR')[1])
 cF4DEnd	:=	Space(TamSx3('A1_END')[1])
 cF4DBairro	:=	Space(TamSx3('A1_BAIRRO')[1])
 cF4DCep	:=	Space(TamSx3('A1_CEP')[1])
 cF4DMun	:=	Space(TamSx3('A1_MUN')[1])
 cF4DUF		:=	Space(TamSx3('A1_EST')[1])
 cF4DFone	:=	Space(TamSx3('A1_TEL')[1])
 cF4DPais	:=	Space(TamSx3('A1_PAIS')[1])

 cF4D2Cnpj	:=	Space(TamSx3('A1_CGC')[1])
 cF4D2Nome	:=	Space(TamSx3('A1_NOME')[1])
 cF4D2End	:=	Space(TamSx3('A1_END')[1])
 cF4D2Bairro:=	Space(TamSx3('A1_BAIRRO')[1])
 cF4D2Cep	:=	Space(TamSx3('A1_CEP')[1])
 cF4D2UF	:=	Space(TamSx3('A1_EST')[1])


//зддддддддддддддддддддддддддддд©
//Ё   FOLDER V - REMETENTE  	Ё
//юддддддддддддддддддддддддддддды
 cF5RNome	:=	Space(TamSx3('A1_NOME')[1])
 cF5RNFan	:=	Space(TamSx3('A1_NREDUZ')[1])
 cF5RCnpj	:=	Space(TamSx3('A1_CGC')[1])
 cF5RInscr	:=	Space(TamSx3('A1_INSCR')[1])
 cF5REnd	:=	Space(TamSx3('A1_END')[1])
 cF5RBairro	:=	Space(TamSx3('A1_BAIRRO')[1])
 cF5RFone	:=	Space(TamSx3('A1_TEL')[1])
 cF5RCep	:=	Space(TamSx3('A1_CEP')[1])
 cF5RMun	:=	Space(TamSx3('A1_MUN')[1])
 cF5RUF		:=	Space(TamSx3('A1_EST')[1])
 cF5RFone	:=	Space(TamSx3('A1_TEL')[1])
 cF5RNum	:=	Space(TamSx3('F1_DOC')[1])
 cF5RSerie	:=	Space(TamSx3('F1_SERIE')[1])
 cF5RVlrNF	:=	Space(TamSx3('F1_VALMERC')[1])
 cF5RBCICMS	:=	Space(TamSx3('F1_BASEICM')[1])
 cF5RVlrICMS:=	Space(TamSx3('F1_VALICM')[1])
 cF5RVlrSTICMS:=	Space(TamSx3('F1_VALICM')[1])
 cF5RPais	:=	Space(TamSx3('A1_EST')[1])

//зддддддддддддддддддддддддддддд©
//Ё    FOLDER  VI - TOTAIS  	Ё
//юддддддддддддддддддддддддддддды
 cF6TVlrServ		:=	Space(TamSx3('A1_NOME')[1])
 cF6TVlrRec		:=	Space(TamSx3('A1_NOME')[1])
 cF6CNome		:=	Space(TamSx3('A1_NOME')[1])
 cF6CValor		:=	Space(TamSx3('A1_NOME')[1])
 cF6IBCICMS		:=	Space(TamSx3('A1_NOME')[1])
 cF6IVlrICMS		:=	Space(TamSx3('A1_NOME')[1])
 cF6ICST			:=	Space(TamSx3('A1_NOME')[1])
 cF6IAliqICMS	:=	Space(TamSx3('A1_NOME')[1])


//здддддддддддддддддддддддддд©
//Ё  FOLDER VII -   CARGA  	 Ё
//юдддддддддддддддддддддддддды
 cF7VlrMerc	:=	Space(TamSx3('F1_VALMERC')[1])
 cF7Produto	:=	Space(TamSx3('B1_COD')[1])
 cF7Unid1	:=	Space(TamSx3('B1_UM')[1])
 cF7Unid2	:=	Space(TamSx3('B1_UM')[1])
 cF7Medi1	:=	Space(50)
 cF7Medi2	:=	Space(50)
 cF7Qtd1		:=	Space(TamSx3('D1_QUANT')[1])
 cF7Qtd2		:=	Space(TamSx3('D1_QUANT')[1])


//здддддддддддддддддддддддддд©
//Ё  FOLDER VIII -   AEREO 	 Ё
//юдддддддддддддддддддддддддды
 cF8AMinuta	:=	Space(50)
 cF8AConeh	:=	Space(50)
 cF8ADtEnt	:=	Space(08)
 cF8ALojaEmi	:=	Space(TamSx3('A1_LOJA')[1])
 cF8ATrecho	:=	Space(50)
 cF8ACL		:=	Space(50)
 cF8ACodigo	:=	Space(50)
 cF8AValor	:=	Space(TamSx3('F1_VALMERC')[1])


//зддддддддддддддддддддддддддддддддддддд©
//Ё  FOLDER IV  -   INF.ADICIONAIS  	Ё
//юддддддддддддддддддддддддддддддддддддды
cFVDescri := Space(100)



*********************************************************
	//CARREGAINFO()
*********************************************************


oFontN     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFontF     := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )


oDlg1      := MSDialog():New( D(010),D(228),D(490),D(985)," Conhecimento de Transporte eletrТnico",,,.F.,,,,,,.T.,,oFontN,.T. )
                        

//зддддддддддддддддддддд©
//Ё   CABEC - CTe    	Ё
//юддддддддддддддддддддды
oGrpCab      := TGroup():New( D(002),D(004),D(020),D(376),"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayCab2   := TSay():New( D(004),D(008),{||"NЗmero"},oGrpCab,,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetCab3   := TGet():New( D(010),D(008),{|u| If(PCount()>0,cNumCTe:=u,cNumCTe)},oGrpCab,076,008,'',,CLR_BLACK,CLR_WHITE,oFontF,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetCab3:Disable()

oSayCab4   := TSay():New( D(004),D(070),{||"SИrie"},oGrpCab,,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetCab5   := TGet():New( D(010),D(070),{|u| If(PCount()>0,cSerieCTe:=u,cSerieCTe)},oGrpCab,036,008,'',,CLR_BLACK,CLR_WHITE,oFontF,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetCab5:Disable()

oSayCab6   := TSay():New( D(004),D(100),{||"EmissЦo"},oGrpCab,,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
oGetCab7   := TGet():New( D(010),D(100),{|u| If(PCount()>0,dDHEmit :=u,dDHEmit )},oGrpCab,040,008,'  \  \  ',,CLR_BLACK,CLR_WHITE,oFontF,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetCab7:Disable()

oSayCab8   := TSay():New( D(004),D(138),{||"Chave de Acesso"},oGrpCab,,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
oGetCab9   := TGet():New( D(010),D(138),{|u| If(PCount()>0,cCTeChave:=u,cCTeChave)},oGrpCab,160,008,'',,CLR_BLACK,CLR_WHITE,oFontF,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
                                     
oSayCabA   := TSay():New( D(004),D(270),{||"VersЦo"},oGrpCab,,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
oGetCabB   := TGet():New( D(010),D(270),{|u| If(PCount()>0,cCTeVersao:=u,cCTeVersao)},oGrpCab,036,008,'',,CLR_BLACK,CLR_WHITE,oFontF,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetCabB:Disable()

oSayCabC   := TSay():New( D(010),D(300),{||"SituaГЦo:"},oGrpCab,,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
oSayCabD   := TSay():New( D(010),D(330),{||"APROVADO" },oGrpCab,,oFontN,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,076,008)
					                                                                       // CLR_HRED


//здддддддддддддд©
//Ё   FOLDERS    Ё
//юдддддддддддддды
oFolders := TFolder():New( D(023), D(004),{"CT-e","Emitente","Tomador","Remetente","DestinatАrio","Recebedor","Expedidor","Totais","Carga","Modal.","Compl.","Inf.Adic."},{},oDlg1,,,,.T.,.F.,D(372),D(213),) 
// oFolders:aDialogs[nFCte]
nFCte	:= 	01
nFEmi	:=	02
nFTom	:=	03
nFRem	:=	04
nFDes	:=	05
nFRec	:=	06
nFExp	:=	07
nFTot	:=	08
nFCar	:=	09
nFMod	:=	10
nFCom	:=	11
nFInf	:=	12



//зддддддддддддддддд©
//Ё   FOLDER I		Ё
//юддддддддддддддддды
//зддддддддддддддддддддддддддддд©
//Ё  CT-e	-  VALORES	    	Ё
//юддддддддддддддддддддддддддддды
oGrpF1V      := TGroup():New( D(002),D(004),D(024),D(365),"Valores",oFolders:aDialogs[nFCte],CLR_HBLUE,CLR_WHITE,.T.,.F. )
oSayF1V1     := TSay():New( D(008),D(008),{||"Valor Total do ServiГo"},oGrpF1V,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
oGetF1V2     := TGet():New( D(013),D(008),{|u| If(PCount()>0,cF1TotServ:=u,cF1TotServ)},oGrpF1V,092,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1V2:Disable()
oSayF1V3     := TSay():New( D(008),D(104),{||"Base CАculo ICMS"},oGrpF1V,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF1V4     := TGet():New( D(013),D(104),{|u| If(PCount()>0,cF1BCIcms:=u,cF1BCIcms)},oGrpF1V,088,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1V4:Disable()
oSayF1V5     := TSay():New( D(008),D(212),{||"Valor do ICMS"},oGrpF1V,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetF1V6     := TGet():New( D(013),D(208),{|u| If(PCount()>0,cF1VlrIcms:=u,cF1VlrIcms)},oGrpF1V,088,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1V6:Disable()

//зддддддддддддддддддддддддд©
//Ё    CT-e  - EMITENTE		Ё
//юддддддддддддддддддддддддды
oGrpF1E      := TGroup():New( D(025),D(004),D(045),D(365),"Emitente",oFolders:aDialogs[nFCte],CLR_HBLUE,CLR_WHITE,.T.,.F. )
oSayF1E1     := TSay():New( D(030),D(008),{||"CNPJ"},oGrpF1E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1E2     := TGet():New( D(035),D(008),{|u| If(PCount()>0,cF1ECNPJ:=u,cF1ECNPJ)},oGrpF1E,092,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1E2:Disable()
oSayF1E3     := TSay():New( D(030),D(104),{||"Nome / RazЦo Social"},oGrpF1E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF1E4     := TGet():New( D(035),D(104),{|u| If(PCount()>0,cF1ENome:=u,cF1ENome)},oGrpF1E,152,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1E4:Disable()
oSayF1E5     := TSay():New( D(030),D(240),{||"InscriГЦo Estadual"},oGrpF1E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oGetF1E6     := TGet():New( D(035),D(240),{|u| If(PCount()>0,cF1EInscr:=u,cF1EInscr)},oGrpF1E,084,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1E6:Disable()
oSayF1E7     := TSay():New( D(030),D(328),{||"UF"},oGrpF1E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1E8     := TGet():New( D(035),D(328),{|u| If(PCount()>0,cF1EUF:=u,cF1EUF)},oGrpF1E,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1E8:Disable()

//зддддддддддддддддддддддддддддд©
//Ё    CT-e  - DESTINATARIO		Ё
//юддддддддддддддддддддддддддддды
oGrpF1D      := TGroup():New( D(046),D(004),D(066),D(365),"DestinatАrio",oFolders:aDialogs[nFCte],CLR_HBLUE,CLR_WHITE,.T.,.F. )
oSayF1D1     := TSay():New( D(051),D(008),{||"CNPJ"},oGrpF1D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1D2     := TGet():New( D(056),D(008),{|u| If(PCount()>0,cF1DCnpj:=u,cF1DCnpj)},oGrpF1D,092,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1D2:Disable()
oSayF1D3     := TSay():New( D(051),D(105),{||"Nome / RazЦo Social"},oGrpF1D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF1D4     := TGet():New( D(056),D(105),{|u| If(PCount()>0,cF1DNome:=u,cF1DNome)},oGrpF1D,152,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1D4:Disable()
oSayF1D5     := TSay():New( D(051),D(241),{||"InscriГЦo Estadual"},oGrpF1D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oGetF1D6     := TGet():New( D(056),D(241),{|u| If(PCount()>0,cF1DInscr:=u,cF1DInscr)},oGrpF1D,084,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1D6:Disable()
oSayF1D7     := TSay():New( D(051),D(329),{||"UF"},oGrpF1D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1D8     := TGet():New( D(056),D(329),{|u| If(PCount()>0,cF1DUF:=u,cF1DUF)},oGrpF1D,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1D8:Disable()

//зддддддддддддддддддддддддддддддддддддд©
//Ё    CT-e  - TOMADOR DE SERVICO		Ё
//юддддддддддддддддддддддддддддддддддддды
oGrpF1T      := TGroup():New( D(067),D(004),D(087),D(365),"Tomador de ServiГo",oFolders:aDialogs[nFCte],CLR_HBLUE,CLR_WHITE,.T.,.F. )
oSayF1T1     := TSay():New( D(072),D(008),{||"CNPJ"},oGrpF1T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1T2     := TGet():New( D(077),D(008),{|u| If(PCount()>0,cF1TCnpj:=u,cF1TCnpj)},oGrpF1T,092,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1T2:Disable()
oSayF1T3     := TSay():New( D(072),D(105),{||"Nome / RazЦo Social"},oGrpF1T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF1T4     := TGet():New( D(077),D(105),{|u| If(PCount()>0,cF1TNome:=u,cF1TNome)},oGrpF1T,152,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1T4:Disable()
oSayF1T5     := TSay():New( D(072),D(241),{||"InscriГЦo Estadual"},oGrpF1T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oGetF1T6     := TGet():New( D(077),D(241),{|u| If(PCount()>0,cF1TInscr:=u,cF1TInscr)},oGrpF1T,084,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1T6:Disable()
oSayF1T7     := TSay():New( D(072),D(329),{||"UF"},oGrpF1T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1T8     := TGet():New( D(077),D(329),{|u| If(PCount()>0,cF1TUF:=u,cF1TUF)},oGrpF1T,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1T8:Disable()

//зддддддддддддддддддддддддддддд©
//Ё    CT-e  - REMETENTE		Ё
//юддддддддддддддддддддддддддддды
oGrpF1R      := TGroup():New( D(088),D(004),D(108),D(365),"Remetente",oFolders:aDialogs[nFCte],CLR_HBLUE,CLR_WHITE,.T.,.F. )
oSayF1R1     := TSay():New( D(093),D(008),{||"CNPJ"},oGrpF1R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1R2     := TGet():New( D(098),D(008),{|u| If(PCount()>0,cF1RCnpj:=u,cF1RCnpj)},oGrpF1R,092,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1R2:Disable()
oSayF1R3     := TSay():New( D(093),D(106),{||"Nome / RazЦo Social"},oGrpF1R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF1R4     := TGet():New( D(098),D(106),{|u| If(PCount()>0,cF1RNome:=u,cF1RNome)},oGrpF1R,152,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1R4:Disable()
oSayF1R5     := TSay():New( D(093),D(242),{||"InscriГЦo Estadual"},oGrpF1R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oGetF1R6     := TGet():New( D(098),D(242),{|u| If(PCount()>0,cF1RInscr:=u,cF1RInscr)},oGrpF1R,084,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1R6:Disable()
oSayF1R7     := TSay():New( D(093),D(330),{||"UF"},oGrpF1R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1R8     := TGet():New( D(098),D(330),{|u| If(PCount()>0,cF1RUF:=u,cF1RUF)},oGrpF1R,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1R8:Disable()

//зддддддддддддддддддддддддддддд©
//Ё    CT-e  - EXPEDIDOR		Ё
//юддддддддддддддддддддддддддддды
oGrpF1X      := TGroup():New( D(109),D(004),D(129),D(365),"Expedidor",oFolders:aDialogs[nFCte],CLR_HBLUE,CLR_WHITE,.T.,.F. )
oSayF1X1     := TSay():New( D(114),D(008),{||"CNPJ"},oGrpF1X,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1X2     := TGet():New( D(119),D(008),{|u| If(PCount()>0,cF1XCnpj:=u,cF1XCnpj)},oGrpF1X,092,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1X2:Disable()
oSayF1X3     := TSay():New( D(114),D(106),{||"Nome / RazЦo Social"},oGrpF1X,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF1X4     := TGet():New( D(119),D(106),{|u| If(PCount()>0,cF1XNome:=u,cF1XNome)},oGrpF1X,152,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1X4:Disable()
oSayF1X5     := TSay():New( D(114),D(242),{||"InscriГЦo Estadual"},oGrpF1X,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oGetF1X6     := TGet():New( D(119),D(242),{|u| If(PCount()>0,cF1XInscr:=u,cF1XInscr)},oGrpF1X,084,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1X6:Disable()
oSayF1X7     := TSay():New( D(114),D(330),{||"UF"},oGrpF1X,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1X8     := TGet():New( D(119),D(330),{|u| If(PCount()>0,cF1XUF:=u,cF1XUF)},oGrpF1X,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1X8:Disable()

//зддддддддддддддддддддддддддддд©
//Ё    CT-e  - RECEBEDOR		Ё
//юддддддддддддддддддддддддддддды
oGrF1RE      := TGroup():New( D(130),D(004),D(150),D(365),"Recebedor",oFolders:aDialogs[nFCte],CLR_HBLUE,CLR_WHITE,.T.,.F. )
oSaF1RE1     := TSay():New( D(135),D(008),{||"CNPJ"},oGrF1RE,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGeF1RE2     := TGet():New( D(140),D(008),{|u| If(PCount()>0,cF1RECnpj:=u,cF1RECnpj)},oGrF1RE,092,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGeF1RE2:Disable()
oSaF1RE3     := TSay():New( D(135),D(106),{||"Nome / RazЦo Social"},oGrF1RE,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGeF1RE4     := TGet():New( D(140),D(106),{|u| If(PCount()>0,cF1RENome:=u,cF1RENome)},oGrF1RE,152,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGeF1RE4:Disable()
oSaF1RE5     := TSay():New( D(135),D(242),{||"InscriГЦo Estadual"},oGrF1RE,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oGeF1RE6     := TGet():New( D(140),D(242),{|u| If(PCount()>0,cF1REInscr:=u,cF1REInscr)},oGrF1RE,084,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGeF1RE6:Disable()
oSaF1RE7     := TSay():New( D(135),D(330),{||"UF"},oGrF1RE,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGeF1RE8     := TGet():New( D(140),D(330),{|u| If(PCount()>0,cF1REUF:=u,cF1REUF)},oGrF1RE,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGeF1RE8:Disable()

//зддддддддддддддддддддддддддддд©
//Ё    CT-e  - CARACTERISTICA	Ё
//юддддддддддддддддддддддддддддды
oGrpF1C      := TGroup():New( D(151),D(004),D(198),D(365),"CaracterМstica",oFolders:aDialogs[nFCte],CLR_HBLUE,CLR_WHITE,.T.,.F. )
oSayF1C1     := TSay():New( D(156),D(008),{||"Modal"},oGrpF1C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1C2     := TGet():New( D(161),D(008),{|u| If(PCount()>0,cF1CModal:=u,cF1CModal)},oGrpF1C,072,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1C2:Disable()
oSayF1C3     := TSay():New( D(156),D(088),{||"Tipo de ServiГo"},oGrpF1C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oGetF1C4     := TGet():New( D(161),D(088),{|u| If(PCount()>0,cF1CTpServ:=u,cF1CTpServ)},oGrpF1C,084,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1C4:Disable()
oSayF1C5     := TSay():New( D(156),D(180),{||"Finalidade"},oGrpF1C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1C6     := TGet():New( D(161),D(180),{|u| If(PCount()>0,cF1CFinalid:=u,cF1CFinalid)},oGrpF1C,080,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1C6:Disable()
oSayF1C7     := TSay():New( D(156),D(272),{||"Forma"},oGrpF1C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)     
oGetF1C8     := TGet():New( D(161),D(272),{|u| If(PCount()>0,cF1CForma:=u,cF1CForma)},oGrpF1C,080,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1C8:Disable()

oSayF1C8     := TSay():New( D(169),D(008),{||"CFOP"},oGrpF1C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF1C9     := TGet():New( D(174),D(008),{|u| If(PCount()>0,cF1CCFOP:=u,cF1CCFOP)},oGrpF1C,072,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1C9:Disable()
oSayF1CA     := TSay():New( D(169),D(088),{||"Digest Value do CT-e"},oGrpF1C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
oGetF1CB     := TGet():New( D(174),D(088),{|u| If(PCount()>0,cF1CDigV:=u,cF1CDigV)},oGrpF1C,084,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1CB:Disable()
oSayF1CC     := TSay():New( D(169),D(180),{||"Natureza da OperaГЦo"},oGrpF1C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
oGetF1CD     := TGet():New( D(174),D(180),{|u| If(PCount()>0,cF1cNatOper:=u,cF1cNatOper)},oGrpF1C,172,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1CD:Disable()

oSayF1CE     := TSay():New( D(182),D(008),{||"Inicio PrestaГЦo"},oGrpF1C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oGetF1CF     := TGet():New( D(187),D(008),{|u| If(PCount()>0,cF1CIniPrest:=u,cF1CIniPrest)},oGrpF1C,164,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1CF:Disable()
oSayF1CG     := TSay():New( D(182),D(180),{||"Fim PrestaГЦo"},oGrpF1C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
oGetF1CH     := TGet():New( D(187),D(180),{|u| If(PCount()>0,cF1CFimPrest:=u,cF1CFimPrest)},oGrpF1C,172,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF1CH:Disable()



//зддддддддддддддддддддддддддддд©
//Ё  FOLDER II -  EMITENTE    	Ё
//юддддддддддддддддддддддддддддды
oSayF2E      := TSay():New( D(012),D(012),{||"Dados do Emitente"},oFolders:aDialogs[nFEmi],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
oGrpF2E      := TGroup():New( D(024),D(004),D(176),D(364),"",oFolders:aDialogs[nFEmi],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayF2E1     := TSay():New( D(032),D(008),{||"Nome / RazЦo Social"},oGrpF2E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF2E2     := TGet():New( D(039),D(008),{|u| If(PCount()>0,cF2ENome:=u,cF2ENome)},oGrpF2E,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF2E1     := TSay():New( D(032),D(188),{||"Nome Fantasia"},oGrpF2E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF2E2     := TGet():New( D(039),D(188),{|u| If(PCount()>0,cF2ENFan:=u,cF2ENFan)},oGrpF2E,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF2E3     := TSay():New( D(054),D(008),{||"CNPJ"},oGrpF2E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF2E4     := TGet():New( D(061),D(008),{|u| If(PCount()>0,cF2ECnpj:=u,cF2ECnpj)},oGrpF2E,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF2E5     := TSay():New( D(054),D(188),{||"InscriГЦo Estadual"},oGrpF2E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oGetF2E6     := TGet():New( D(061),D(188),{|u| If(PCount()>0,cF2EInscr:=u,cF2EInscr)},oGrpF2E,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF2E7     := TSay():New( D(076),D(008),{||"EndereГo"},oGrpF2E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF2E8     := TGet():New( D(083),D(188),{|u| If(PCount()>0,cF2EEnd:=u,cF2EEnd)},oGrpF2E,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF2E9     := TSay():New( D(076),D(188),{||"Bairro / Distrito"},oGrpF2E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetF2EA     := TGet():New( D(083),D(008),{|u| If(PCount()>0,cF2EBairro:=u,cF2EBairro)},oGrpF2E,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF2EH     := TSay():New( D(098),D(008),{||"Fone \ Fax"},oGrpF2E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF2EI     := TGet():New( D(105),D(008),{|u| If(PCount()>0,cF2EFone:=u,cF2EFone)},oGrpF2E,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF2EB     := TSay():New( D(098),D(188),{||"CEP"},oGrpF2E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF2EC     := TGet():New( D(105),D(188),{|u| If(PCount()>0,cF2ECep:=u,cF2ECep)},oGrpF2E,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF2ED     := TSay():New( D(120),D(008),{||"Municipio"},oGrpF2E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF2EE     := TGet():New( D(127),D(008),{|u| If(PCount()>0,cF2EMun:=u,cF2EMun)},oGrpF2E,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF2EF     := TSay():New( D(120),D(188),{||"UF"},oGrpF2E,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF2EG     := TGet():New( D(127),D(188),{|u| If(PCount()>0,cF2EUF:=u,cF2EUF)},oGrpF2E,028,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
                                                                   


//зддддддддддддддддддддддддддддд©
//Ё  FOLDER III -  TOMADOR    	Ё
//юддддддддддддддддддддддддддддды
oSayF3T1     := TSay():New( D(012),D(012),{||"Dados do Tomador"},oFolders:aDialogs[nFTom],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
oGrpF3T      := TGroup():New( D(024),D(004),D(176),D(364),"",oFolders:aDialogs[nFTom],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayF3T1     := TSay():New( D(032),D(008),{||"Nome / RazЦo Social"},oGrpF3T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF3T2     := TGet():New( D(039),D(008),{|u| If(PCount()>0,cF3TNome:=u,cF3TNome)},oGrpF3T,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3T1     := TSay():New( D(032),D(188),{||"Nome Fantasia"},oGrpF3T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF3T2     := TGet():New( D(039),D(188),{|u| If(PCount()>0,cF3TNFan:=u,cF3TNFan)},oGrpF3T,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3T3     := TSay():New( D(054),D(008),{||"CNPJ"},oGrpF3T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF3T4     := TGet():New( D(061),D(008),{|u| If(PCount()>0,cF3TCnpj:=u,cF3TCnpj)},oGrpF3T,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3T5     := TSay():New( D(054),D(188),{||"InscriГЦo Estadual"},oGrpF3T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oGetF3T6     := TGet():New( D(061),D(188),{|u| If(PCount()>0,cF3TInscr:=u,cF3TInscr)},oGrpF3T,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3T7     := TSay():New( D(076),D(008),{||"EndereГo"},oGrpF3T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF3T8     := TGet():New( D(083),D(188),{|u| If(PCount()>0,cF3TEnd:=u,cF3TEnd)},oGrpF3T,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3T9     := TSay():New( D(076),D(188),{||"Bairro / Distrito"},oGrpF3T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetF3TA     := TGet():New( D(083),D(008),{|u| If(PCount()>0,cF3TBairro:=u,cF3TBairro)},oGrpF3T,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3TH     := TSay():New( D(098),D(008),{||"Fone \ Fax"},oGrpF3T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF3TI     := TGet():New( D(105),D(008),{|u| If(PCount()>0,cF3TFone:=u,cF3TFone)},oGrpF3T,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3TB     := TSay():New( D(098),D(188),{||"CEP"},oGrpF3T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF3TC     := TGet():New( D(105),D(188),{|u| If(PCount()>0,cF3TCep:=u,cF3TCep)},oGrpF3T,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3TD     := TSay():New( D(120),D(008),{||"Municipio"},oGrpF3T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF3TE     := TGet():New( D(127),D(008),{|u| If(PCount()>0,cF3TMun:=u,cF3TMun)},oGrpF3T,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3TF     := TSay():New( D(120),D(188),{||"UF"},oGrpF3T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF3TG     := TGet():New( D(127),D(188),{|u| If(PCount()>0,cF3TUF:=u,cF3TUF)},oGrpF3T,028,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3TI     := TSay():New( D(141),D(008),{||"PaМs"},oGrpF3T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetF3TJ     := TGet():New( D(148),D(008),{|u| If(PCount()>0,cF3TPais:=u,cF3TPais)},oGrpF3T,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3TL     := TSay():New( D(141),D(188),{||"RelaГЦo com a Carga"},oGrpF3T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)
oGetF3TM     := TGet():New( D(148),D(188),{|u| If(PCount()>0,cF3TRelCarga:=u,cF3TRelCarga)},oGrpF3T	,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)


//зддддддддддддддддддддддддддддд©
//Ё   FOLDER V - REMETENTE  	Ё
//юддддддддддддддддддддддддддддды
oSayF5R      := TSay():New( D(012),D(012),{||"Dados do Remetente"},oFolders:aDialogs[nFRem],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,008)
oGrpF5R      := TGroup():New( D(024),D(004),D(166),D(364),"",oFolders:aDialogs[nFRem],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSF3R1       := TSay():New( D(032),D(008),{||"Nome / RazЦo Social"},oSayF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGF3R2       := TGet():New( D(039),D(008),{|u| If(PCount()>0,cF3TNome:=u,cF3TNome)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3R1     := TSay():New( D(032),D(188),{||"Nome Fantasia"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF3R2     := TGet():New( D(039),D(188),{|u| If(PCount()>0,cF3TNFan:=u,cF3TNFan)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3R3     := TSay():New( D(054),D(008),{||"CNPJ"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF3R4     := TGet():New( D(061),D(008),{|u| If(PCount()>0,cF3TCnpj:=u,cF3TCnpj)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3R5     := TSay():New( D(054),D(188),{||"InscriГЦo Estadual"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oGetF3R6     := TGet():New( D(061),D(188),{|u| If(PCount()>0,cF3TInscr:=u,cF3TInscr)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3R7     := TSay():New( D(076),D(008),{||"EndereГo"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF3R8     := TGet():New( D(083),D(188),{|u| If(PCount()>0,cF3TEnd:=u,cF3TEnd)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3R9     := TSay():New( D(076),D(188),{||"Bairro / Distrito"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetF3RA     := TGet():New( D(083),D(008),{|u| If(PCount()>0,cF3TBairro:=u,cF3TBairro)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3RH     := TSay():New( D(098),D(008),{||"Fone \ Fax"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF3RI     := TGet():New( D(105),D(008),{|u| If(PCount()>0,cF3TFone:=u,cF3TFone)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3RB     := TSay():New( D(098),D(188),{||"CEP"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF3RC     := TGet():New( D(105),D(188),{|u| If(PCount()>0,cF3TCep:=u,cF3TCep)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3RD     := TSay():New( D(120),D(008),{||"Municipio"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF3RE     := TGet():New( D(127),D(008),{|u| If(PCount()>0,cF3TMun:=u,cF3TMun)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3RF     := TSay():New( D(120),D(188),{||"UF"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF3RG     := TGet():New( D(127),D(188),{|u| If(PCount()>0,cF3TUF:=u,cF3TUF)},oGrpF5R,028,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF3RI     := TSay():New( D(141),D(008),{||"PaМs"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetF3RJ     := TGet():New( D(148),D(008),{|u| If(PCount()>0,cF3TPais:=u,cF3TPais)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

// FOLDER II
oGrpF5RI     := TGroup():New( D(170),D(004),D(200),D(364),"",oFolders:aDialogs[nFRem],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayF5RI     := TSay():New( D(174),D(008),{||"InformaГУes de Notas Fiscais"},oFolders:aDialogs[nFRem],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)

oSayF5RJ     := TSay():New( D(181),D(008),{||"NЗmero"},oGrpF5RI,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF5RL     := TGet():New( D(187),D(008),{|u| If(PCount()>0,cF5RNum:=u,cF5RNum)},oGrpF5RI,068,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5RM     := TSay():New( D(181),D(064),{||"SИrie"},oGrpF5RI,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF5RN     := TGet():New( D(187),D(064),{|u| If(PCount()>0,cF5RSerie:=u,cF5RSerie)},oGrpF5RI,020,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
                                                                                                                                                     
oSayF5RO     := TSay():New( D(181),D(108),{||"Valor Nota Fiscal"},oGrpF5RI,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetF5RP     := TGet():New( D(187),D(108),{|u| If(PCount()>0,cF5RVlrNF:=u,cF5RVlrNF)},oGrpF5RI,060,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5RQ     := TSay():New( D(181),D(172),{||"Valor BC ICMS"},oGrpF5RI,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGetF5RR     := TGet():New( D(187),D(172),{|u| If(PCount()>0,cF5RBCICMS:=u,cF5RBCICMS)},oGrpF5RI,060,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5RS     := TSay():New( D(181),D(236),{||"Valor ICMS"},oGrpF5RI,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF5RT     := TGet():New( D(187),D(236),{|u| If(PCount()>0,cF5RVlrICMS:=u,cF5RVlrICMS)},oGrpF5RI,060,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5RU     := TSay():New( D(181),D(300),{||"Valor ICMS ST"},oGrpF5RI,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGetF5RV     := TGet():New( D(187),D(300),{|u| If(PCount()>0,cF5RVlrSTICMS:=u,cF5RVlrSTICMS)},oGrpF5RI,060,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)



//зддддддддддддддддддддддддддддд©
//Ё  FOLDER IV - DESTINATARIO  	Ё
//юддддддддддддддддддддддддддддды
oSayF4D      := TSay():New( D(012),D(012),{||"Dados do DestinatАrio"},oFolders:aDialogs[nFDes],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
oGrpF4D      := TGroup():New( D(024),D(004),D(133),D(364),"",oFolders:aDialogs[nFDes],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayF4D1     := TSay():New( D(032),D(008),{||"Nome / RazЦo Social"},oGrpF4D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF4D2     := TGet():New( D(038),D(008),{|u| If(PCount()>0,cF4DNome:=u,cF4DNome)},oGrpF4D,406,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF4D3     := TSay():New( D(049),D(008),{||"CNPJ"},oGrpF4D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF4D4     := TGet():New( D(055),D(008),{|u| If(PCount()>0,cF4DCnpj:=u,cF4DCnpj)},oGrpF4D,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF4D5     := TSay():New( D(049),D(188),{||"InscriГЦo Estadual"},oGrpF4D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oGetF4D6     := TGet():New( D(055),D(188),{|u| If(PCount()>0,cF4DInscr:=u,cF4DInscr)},oGrpF4D,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF4D7     := TSay():New( D(066),D(008),{||"EndereГo"},oGrpF4D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF4D8     := TGet():New( D(072),D(188),{|u| If(PCount()>0,cF4DEnd:=u,cF4DEnd)},oGrpF4D,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF4D9     := TSay():New( D(066),D(188),{||"Bairro / Distrito"},oGrpF4D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetF4DA     := TGet():New( D(072),D(008),{|u| If(PCount()>0,cF4DBairro:=u,cF4DBairro)},oGrpF4D,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF4DB     := TSay():New( D(083),D(008),{||"CEP"},oGrpF4D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF4DC     := TGet():New( D(088),D(008),{|u| If(PCount()>0,cF4DCep:=u,cF4DCep)},oGrpF4D,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF4DD     := TSay():New( D(099),D(008),{||"Municipio"},oGrpF4D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF4DE     := TGet():New( D(104),D(008),{|u| If(PCount()>0,cF4DMun:=u,cF4DMun)},oGrpF4D,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF4DF     := TSay():New( D(099),D(188),{||"UF"},oGrpF4D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF4DG     := TGet():New( D(104),D(188),{|u| If(PCount()>0,cF4DUF:=u,cF4DUF)},oGrpF4D,028,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF4DI     := TSay():New( D(114),D(008),{||"PaМs"},oGrpF4D,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetF4DJ     := TGet():New( D(121),D(008),{|u| If(PCount()>0,cF4DPais:=u,cF4DPais)},oGrpF4D,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

// Folder II
oGrpF4D2     := TGroup():New( D(135),D(004),D(200),D(364),"",oFolders:aDialogs[nFDes],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayF4D2     := TSay():New( D(136),D(008),{||"Local de Entrega"},oFolders:aDialogs[nFDes],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)

oSF4D32      := TSay():New( D(144),D(008),{||"CNPJ"},oGrpF4D2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGF4D42      := TGet():New( D(150),D(008),{|u| If(PCount()>0,cF4D2Cnpj:=u,cF4D2Cnpj)},oGrpF4D2,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSF4D12      := TSay():New( D(144),D(188),{||"Nome / RazЦo Social"},oGrpF4D2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGF4D22      := TGet():New( D(150),D(188),{|u| If(PCount()>0,cF4D2Nome:=u,cF4D2Nome)},oGrpF4D2,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSF4D72      := TSay():New( D(161),D(008),{||"EndereГo"},oGrpF4D2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGF4D82      := TGet():New( D(167),D(008),{|u| If(PCount()>0,cF4D2End:=u,cF4D2End)},oGrpF4D2,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSF4D92      := TSay():New( D(161),D(188),{||"Bairro"},oGrpF4D2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGF4DA2      := TGet():New( D(167),D(188),{|u| If(PCount()>0,cF4D2Bairro:=u,cF4D2Bairro)},oGrpF4D2,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSF4DB2      := TSay():New( D(178),D(008),{||"Municipio"},oGrpF4D2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGF4DC2      := TGet():New( D(184),D(008),{|u| If(PCount()>0,cF4D2Cep:=u,cF4D2Cep)},oGrpF4D2,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSF4DE2      := TSay():New( D(178),D(188),{||"UF"},oGrpF4D2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGF4DF2      := TGet():New( D(184),D(188),{|u| If(PCount()>0,cF4D2UF:=u,cF4D2UF)},oGrpF4D2,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)


//зддддддддддддддддддддддддддддд©
//Ё  FOLDER IV - RECEBEDOR  	Ё    SO FALTA COLOCAR O FONE\FAX...
//юддддддддддддддддддддддддддддды 
oSayF5R      := TSay():New( D(012),D(012),{||"Dados do Recebedor"},oFolders:aDialogs[nFRec],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
oGrpF5R      := TGroup():New( D(024),D(004),D(176),D(364),"",oFolders:aDialogs[nFRec],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayF5D1     := TSay():New( D(032),D(008),{||"Nome / RazЦo Social"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF5D2     := TGet():New( D(038),D(008),{|u| If(PCount()>0,cF5RNome:=u,cF5RNome)},oGrpF5R,406,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5D3     := TSay():New( D(049),D(008),{||"CNPJ"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF5D4     := TGet():New( D(055),D(008),{|u| If(PCount()>0,cF5RCnpj:=u,cF5RCnpj)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5D5     := TSay():New( D(049),D(188),{||"InscriГЦo Estadual"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oGetF5D6     := TGet():New( D(055),D(188),{|u| If(PCount()>0,cF5RInscr:=u,cF5RInscr)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5D7     := TSay():New( D(066),D(008),{||"EndereГo"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF5D8     := TGet():New( D(072),D(188),{|u| If(PCount()>0,cF5REnd:=u,cF5REnd)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5D9     := TSay():New( D(066),D(188),{||"Bairro / Distrito"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetF5DA     := TGet():New( D(072),D(008),{|u| If(PCount()>0,cF5RBairro:=u,cF5RBairro)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5DB     := TSay():New( D(083),D(008),{||"Fone\Fax"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF5DC     := TGet():New( D(088),D(008),{|u| If(PCount()>0,cF5RFone:=u,cF5RFone)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5DB     := TSay():New( D(083),D(188),{||"CEP"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF5DC     := TGet():New( D(088),D(188),{|u| If(PCount()>0,cF5RCep:=u,cF5RCep)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5DD     := TSay():New( D(099),D(008),{||"Municipio"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF5DE     := TGet():New( D(104),D(008),{|u| If(PCount()>0,cF5RMun:=u,cF5RMun)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5DF     := TSay():New( D(099),D(188),{||"UF"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF5DG     := TGet():New( D(104),D(188),{|u| If(PCount()>0,cF5RUF:=u,cF5RUF)},oGrpF5R,028,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF5DI     := TSay():New( D(114),D(008),{||"PaМs"},oGrpF5R,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetF5DJ     := TGet():New( D(121),D(008),{|u| If(PCount()>0,cF5RPais:=u,cF5RPais)},oGrpF5R,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)


            
//зддддддддддддддддддддддддддддд©
//Ё    FOLDER  VI - TOTAIS  	Ё
//юддддддддддддддддддддддддддддды
oSayF6T      := TSay():New( D(016),D(012),{||"Valores Totais"},oFolders:aDialogs[nFTot],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
oGrpF6T      := TGroup():New( D(024),D(008),D(048),D(364),"",oFolders:aDialogs[nFTot],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayF6T1     := TSay():New( D(028),D(012),{||"Valor PrestaГЦo ServiГo"},oGrpF6T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
oGetF6T2     := TGet():New( D(034),D(012),{|u| If(PCount()>0,cF6TVlrServ:=u,cF6TVlrServ)},oGrpF6T,168,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF6T3     := TSay():New( D(028),D(188),{||"Valor a Receber"},oGrpF6T,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF6T4     := TGet():New( D(034),D(188),{|u| If(PCount()>0,cF6TVlrRec:=u,cF6TVlrRec)},oGrpF6T,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё    FOLDER  VI - COMPONENTES DO VALOR DA PRESTAГЦO DO SERVIГO	Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oSayF6C      := TSay():New( D(052),D(012),{||"Componentes do Valor da PrestaГЦo do ServiГo"},oFolders:aDialogs[nFTot],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,172,008)
oGrpF6C      := TGroup():New( D(050),D(008),D(140),D(364),"",oFolders:aDialogs[nFTot],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayF6C1     := TSay():New( D(061),D(012),{||"Nome"},oGrpF6C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oGetF6C2     := TGet():New( D(067),D(012),{|u| If(PCount()>0,cF6CNome:=u,cF6CNome)},oGrpF6C,168,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF6C3     := TSay():New( D(061),D(188),{||"Valor"},oGrpF6C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF6C4     := TGet():New( D(067),D(188),{|u| If(PCount()>0,cF6CValor:=u,cF6CValor)},oGrpF6C,184,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
  
//зддддддддддддддддддддддддддддд©
//Ё    FOLDER  VI - IMPOSTOS  	Ё
//юддддддддддддддддддддддддддддды
oSayF6I      := TSay():New( D(148),D(012),{||"Impostos"},oFolders:aDialogs[nFTot],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGrpF6I      := TGroup():New( D(144),D(008),D(200),D(364),"",oFolders:aDialogs[nFTot],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayF6I1     := TSay():New( D(156),D(012),{||"Base de CАculo ICMS"},oGrpF6I,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
oGetF6I2     := TGet():New( D(163),D(012),{|u| If(PCount()>0,cF6IBCICMS:=u,cF6IBCICMS)},oGrpF6I,128,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF6I3     := TSay():New( D(156),D(148),{||"Valor do ICMS"},oGrpF6I,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
oGetF6I4     := TGet():New( D(163),D(148),{|u| If(PCount()>0,cF6IVlrICMS:=u,cF6IVlrICMS)},oGrpF6I,100,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF6I5     := TSay():New( D(156),D(256),{||"CST"},oGrpF6I,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)               
oGetF6I6     := TGet():New( D(163),D(256),{|u| If(PCount()>0,cF6ICST:=u,cF6ICST)},oGrpF6I,096,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF6I7     := TSay():New( D(177),D(012),{||"AlМquota ICMS"},oGrpF6I,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
oGetF6I8     := TGet():New( D(184),D(012),{|u| If(PCount()>0,cF6IAliqICMS:=u,cF6IAliqICMS)},oGrpF6I,128,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)



//здддддддддддддддддддддддддд©
//Ё  FOLDER VII -   CARGA  	 Ё
//юдддддддддддддддддддддддддды
oSayF7       := TSay():New( D(012),D(012),{||"Carga"},oFolders:aDialogs[nFCar],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGrpF7C      := TGroup():New( D(028),D(008),D(064),D(364),"",oFolders:aDialogs[nFCar],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayF71      := TSay():New( D(036),D(012),{||"Valor Total da Mercadoria"},oGrpF7C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
oGetF72      := TGet():New( D(044),D(012),{|u| If(PCount()>0,cF7VlrMerc:=u,cF7VlrMerc)},oGrpF7C,156,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF73      := TSay():New( D(036),D(176),{||"Produto Predominante"},oGrpF7C,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
oGetF74      := TGet():New( D(044),D(176),{|u| If(PCount()>0,cF7Produto:=u,cF7Produto)},oGrpF7C,180,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)


oSayF7Q      := TSay():New( D(080),D(012),{||"Quantidade de Carga"},oFolders:aDialogs[nFCar],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
oGrpF7Q      := TGroup():New( D(092),D(008),D(144),D(364),"",oFolders:aDialogs[nFCar],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayF7Q1     := TSay():New( D(100),D(012),{||"Unidade"},oGrpF7Q,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF7Q2     := TGet():New( D(108),D(012),{|u| If(PCount()>0,cF7Unid1:=u,cF7Unid1)},oGrpF7Q,088,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF7Q3     := TGet():New( D(124),D(012),{|u| If(PCount()>0,cF7Unid2:=u,cF7Unid2)},oGrpF7Q,088,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF7Q4     := TSay():New( D(100),D(124),{||"Medida"},oGrpF7Q,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF7Q5     := TGet():New( D(108),D(124),{|u| If(PCount()>0,cF7Medi1:=u,cF7Medi1)},oGrpF7Q,096,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF7Q6     := TGet():New( D(124),D(124),{|u| If(PCount()>0,cF7Medi2:=u,cF7Medi2)},oGrpF7Q,096,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF7Q7     := TSay():New( D(100),D(244),{||"Quantidade"},oGrpF7Q,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF7Q8     := TGet():New( D(108),D(244),{|u| If(PCount()>0,cF7Qtd1:=u,cF7Qtd1)},oGrpF7Q,100,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGetF7Q9     := TGet():New( D(124),D(244),{|u| If(PCount()>0,cF7Qtd2:=u,cF7Qtd2)},oGrpF7Q,100,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
                                                                      

/*
//здддддддддддддддддддддддддд©
//Ё  FOLDER VIII -   AEREO 	 Ё
//юдддддддддддддддддддддддддды
oSayF8A       := TSay():New( D(012),D(008),{||"AИreo"},oFolders:aDialogs[nFMod],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGrpF8A       := TGroup():New( D(028),D(004),D(092),D(364),"",oFolders:aDialogs[nFMod],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayF8A1      := TSay():New( D(036),D(008),{||"Minuta"},oGrpF8A,,oFontF,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF8A2      := TGet():New( D(044),D(008),{|u| If(PCount()>0,cF8AMinuta:=u,cF8AMinuta)},oGrpF8A,144,010,'',,CLR_BLACK,CLR_WHITE,oFontF,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF8A3      := TSay():New( D(036),D(156),{||"Coneh. AИreo"},oGrpF8A,,oFontF,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGetF8A4      := TGet():New( D(044),D(156),{|u| If(PCount()>0,cF8AConeh:=u,cF8AConeh)},oGrpF8A,120,010,'',,CLR_BLACK,CLR_WHITE,oFontF,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF8A5      := TSay():New( D(036),D(280),{||"Data Prevista Entrega"},oGrpF8A,,oFontF,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
oGetF8A6      := TGet():New( D(044),D(280),{|u| If(PCount()>0,cF8ADtEnt:=u,cF8ADtEnt)},oGrpF8A,068,010,'',,CLR_BLACK,CLR_WHITE,oFontF,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF8A7      := TSay():New( D(064),D(008),{||"Loja Ag. Emissor"},oGrpF8A,,oFontF,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGetF8A8      := TGet():New( D(076),D(008),{|u| If(PCount()>0,cF8ALojaEmi:=u,cF8ALojaEmi)},oGrpF8A,144,010,'',,CLR_BLACK,CLR_WHITE,oFontF,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)


oSayF8A9      := TSay():New( D(108),D(008),{||"Tarifa"},oFolders:aDialogs[nFMod],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGrpF8AT      := TGroup():New( D(120),D(004),D(152),D(364),"",oFolders:aDialogs[nFMod],CLR_BLACK,CLR_WHITE,.T.,.F. )
oSayF8AA      := TSay():New( D(128),D(008),{||"Trecho"},oGrpF8AT,,oFontF,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF8AB      := TGet():New( D(136),D(008),{|u| If(PCount()>0,cF8ATrecho:=u,cF8ATrecho)},oGrpF8AT,144,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF8AC      := TSay():New( D(128),D(160),{||"CL"},oGrpF8AT,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF8AD      := TGet():New( D(136),D(160),{|u| If(PCount()>0,cF8ACL:=u,cF8ACL)},oGrpF8AT,040,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF8AE      := TSay():New( D(128),D(204),{||"CСdigo"},oGrpF8AT,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF8AF      := TGet():New( D(136),D(204),{|u| If(PCount()>0,cF8ACodigo:=u,cF8ACodigo)},oGrpF8AT,068,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSayF8AG      := TSay():New( D(128),D(280),{||"Valor"},oGrpF8AT,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetF8AH      := TGet():New( D(136),D(280),{|u| If(PCount()>0,cF8AValor:=u,cF8AValor)},oGrpF8AT,076,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
*/


//зддддддддддддддддддддддддддддддддддддд©
//Ё  FOLDER IV  -   COMPLEMENTO	 		Ё
//юддддддддддддддддддддддддддддддддддддды


//зддддддддддддддддддддддддддддддддддддд©
//Ё  FOLDER V   -   INF.ADICIONAIS  	Ё
//юддддддддддддддддддддддддддддддддддддды
oSayFVI       := TSay():New( D(012),D(008),{||"InformaГУes Complementares de Interesse do Contribuinte."},oFolders:aDialogs[nFInf],,oFontN,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,232,008)
oGrpFVI       := TGroup():New( D(028),D(004),D(063),D(364),"",oFolders:aDialogs[nFInf],CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayFVI1      := TSay():New( D(036),D(008),{||"DescriГЦo"},oGrpFVI,,oFontF,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGetFVI2      := TGet():New( D(045),D(008),{|u| If(PCount()>0,cFVDescri:=u,cFVDescri)},oGrpFVI,352,010,'',,CLR_BLACK,CLR_WHITE,oFontF,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)


oBtn1      := TButton():New( D(308),D(156),"Sair",oDlg1,,037,012,,oFontN,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return()
****************************************************************************
Static Function MyF4Compl(a,b,c,cCliFor,cLoja,cProd,cProg,nRecSD1,cVar)
****************************************************************************
Local aArrayF4[0]            

Local aObjects  := {}
Local aInfo     := {}
Local aPosObj   := {}
Local aSize     := MsAdvSize( .F. )
Local aRecSD1	:= {}

Local cSeek     := ""
Local cTexto1   := ""
Local cTexto2   := ""
Local cCadastro := ""
Local cCampo    := ""

Local nOpt1     := 1
Local nX        := 0 

Local nEndereco
Local cAlias    := Alias()
Local nOrdem    := IndexOrd()
Local nRec      := RecNo()
Local nOAT      := 0
Local nPosNf    := 0
Local nPosSer   := 0
Local nPosIt    := 0
Local nOpca     := 0
Local nHdl      := GetFocus()
Local nPosSeek  := 0

Local oDlg
Local oQual

Local cAliasQry	:= GetNextAlias()   
//Private cTipo := "C"

cVar := If(cVar==Nil,ReadVar(),cVar)       // variavel corrente

If Substr(cVar,6,6)!= "_NFORI"
	Return Nil
Endif

If cProg == "A440"
	cArq  := "SF2"
	cSeek := "F2_FILIAL+F2_CLIENTE+F2_LOJA"
Else
	cArq  := "SF1"
	cSeek := "F1_FILIAL+F1_FORNECE+F1_LOJA"
Endif

#IFDEF TOP
    If TcSrvType()<>"AS/400"
    	If cProg=="A440"
	    	BeginSql Alias cAliasQry
			SELECT 
				SD2.D2_FILIAL, SD2.D2_COD, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_ORIGLAN, SD2.D2_ITEM, SD2.D2_TOTAL, SD2.D2_VALIPI, D2_VALICM, SD2.D2_PRCVEN,
				SF2.F2_FILIAL, SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_TIPO, SF2.F2_DOC, SF2.F2_SERIE			
			FROM
				%table:SD2% SD2, %table:SF2% SF2
			WHERE 
				//SD2.D2_FILIAL=%xFilial:SD2% AND 
				//SD2.D2_COD=%Exp:cProd% AND
				SD2.D2_CLIENTE=%Exp:cCliFor% AND 
				SD2.D2_LOJA=%Exp:cLoja% AND 
				SD2.D2_ORIGLAN<>'LF' AND
				SD2.%NotDel% AND
			
				//SF2.F2_FILIAL=%xFilial:SF2% AND
				SF2.F2_DOC=SD2.D2_DOC AND
				SF2.F2_SERIE=SD2.D2_SERIE AND
				SF2.F2_CLIENTE=SD2.D2_CLIENTE AND
				SF2.F2_LOJA=SD2.D2_LOJA AND
				SF2.%NotDel% AND
				SF2.F2_TIPO NOT IN('D','B','P','I')
			ORDER BY 
				SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD, SD2.D2_ITEM
			EndSql    	

    	Else

	    	BeginSql Alias cAliasQry
			SELECT 
				SD1.D1_FILIAL, SD1.D1_COD, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_ORIGLAN, SD1.D1_ITEM, SD1.D1_TOTAL, SD1.D1_VALIPI, SD1.D1_VUNIT,
				SF1.F1_FILIAL, SF1.F1_FORNECE, SF1.F1_LOJA, SF1.F1_TIPO, SF1.F1_DOC, SF1.F1_SERIE			
			FROM
				%table:SD1% SD1, %table:SF1% SF1
			WHERE 
				SD1.D1_FILIAL=%xFilial:SD1% AND 
				SD1.D1_COD=%Exp:cProd% AND
				SD1.D1_FORNECE=%Exp:cCliFor% AND 
				SD1.D1_LOJA=%Exp:cLoja% AND 
				SD1.D1_ORIGLAN<>'LF' AND
				SD1.%NotDel% AND
			
				SF1.F1_FILIAL=%xFilial:SF1% AND
				SF1.F1_DOC=SD1.D1_DOC AND
				SF1.F1_SERIE=SD1.D1_SERIE AND
				SF1.F1_FORNECE=SD1.D1_FORNECE AND
				SF1.F1_LOJA=SD1.D1_LOJA AND
				SF1.%NotDel% AND
				SF1.F1_TIPO NOT IN('D','B','P','I')
			ORDER BY 
				SD1.D1_FILIAL, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_COD, SD1.D1_ITEM
			EndSql
		EndIf
		
		If (cAliasQry)->(Eof())
			HELP(" ",1,"F4NAONOTA")
			dbSelectArea(cAlias)
			dbSetOrder(nOrdem)
			dbGoto(nRec)
			Return .T.
		Endif
	
		For Nx:=1 to Len(aHeader)
			cCampo := Trim(aHeader[nx][2])
			cCampo := Subs(cCampo,3,len(cCampo)-2)
			If cCampo == "_NFORI"
				nPosNf	:= nx
			ElseIf cCampo == "_SERIORI"
				nPosSer	:= nx
			ElseIf cCampo == "_ITEMORI"
				nPosIt 	:= nx
			Endif
		Next Nx
	
		While !(cAliasQry)->(Eof())
			If cProg=="A440"
				AADD(aArrayF4,{(cAliasQry)->D2_DOC,(cAliasQry)->D2_SERIE,(cAliasQry)->D2_ITEM ,STR((cAliasQry)->D2_TOTAL,11,2),Str((cAliasQry)->D2_VALIPI,11,2),Str((cAliasQry)->D2_VALICM,11,2),Str((cAliasQry)->D2_PRCVEN,11,2) })
			Else
				AADD(aArrayF4,{(cAliasQry)->D1_DOC,(cAliasQry)->D1_SERIE,(cAliasQry)->D1_ITEM,STR((cAliasQry)->D1_TOTAL,11,2),Str((cAliasQry)->D1_VALIPI,11,2),Str((cAliasQry)->D1_VALIPI,11,2),Str((cAliasQry)->D1_VUNIT,11,2)})
				aAdd(aRecSD1,SD1->(RecNo()))
			EndIf
			(cAliasQry)->(dbSkip())
		End
	Else
#ENDIF
	DbSelectArea(cArq)
	DbSetOrder(2)
	
	MsSeek(xFilial(cArq)+cCliFor+cLoja)     // Verifica se Existe Nota para este Cliente/Fornecedor

	If Eof()
		HELP(" ",1,"F4NAONOTA")
		dbSelectArea(cAlias)
		dbSetOrder(nOrdem)
		dbGoto(nRec)
		Return .T.
	Endif
	
	For Nx:=1 to Len(aHeader)
		cCampo := Trim(aHeader[nx][2])
		cCampo := Subs(cCampo,3,len(cCampo)-2)
		If cCampo == "_NFORI"
			nPosNf	:= nx
		ElseIf cCampo == "_SERIORI"
			nPosSer	:= nx
		ElseIf cCampo == "_ITEMORI"
			nPosIt 	:= nx
		Endif
	Next Nx
	
	While !Eof() .And. xFilial(cArq)+cCliFor+cLoja == &cSeek
		
		If cProg = "A440"
			// Verifica o tipo da Nota Fiscal
			If SF2->F2_TIPO $ "DBPI"
				dbSkip()
				Loop
			Endif
			// Posiciona os Itens da Nota Fiscal
			dbSelectArea("SD2")
			dbSetOrder(3)
			dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+cProd)
		Else
			// Verifica o tipo da Nota Fiscal
			If SF1->F1_TIPO $ "DBPI"
				dbSkip()
				Loop
			Endif
			// Posiciona os Itens da Nota Fisca
			dbSelectArea("SD1")
			dbSetOrder(2)
			dbSeek(xFilial("SD1")+cProd+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		Endif
		
		// Nao existe este produto nesta Nota
		If Eof()
			dbSelectArea(cArq)
			dbSkip()
			Loop
		Endif
		
		If cProg == "A440"
			While !Eof() .and. SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+cProd == ;
					D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
				If SD2->D2_ORIGLAN # "LF"
					AADD(aArrayF4,{D2_DOC,D2_SERIE,D2_ITEM,STR(D2_TOTAL,11,2),Str(D2_VALIPI,11,2),Str(D2_VALICM,11,2),Str(D2_PRCVEN,11,2)})
				Endif
				dbSkip()
			End
		Else
			While !Eof() .and. cProd+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA= D1_COD+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
				IF SD1->D1_ORIGLAN # "LF"
					AADD(aArrayF4,{D1_DOC,D1_SERIE,D1_ITEM,STR(D1_TOTAL,11,2),Str(D1_VALIPI,11,2),Str(D1_VALIPI,11,2),Str(D1_VUNIT,11,2)})
					aAdd(aRecSD1,SD1->(RecNo()))
				Endif
				dbSkip()
			End
		Endif
		dbSelectArea(cArq)
		dbSetOrder(2)
		dbSkip()
	End
#IFDEF TOP
	EndIf
#ENDIF

If !Empty(aArrayF4)

	aSize[1] /= 1.5
	aSize[2] /= 1.5
	aSize[3] /= 1.5
	aSize[4] /= 1.3
	aSize[5] /= 1.5
	aSize[6] /= 1.3
	aSize[7] /= 1.5
	
	AAdd( aObjects, { 100, 020,.T.,.F.,.T.} )
	AAdd( aObjects, { 100, 060,.T.,.T.,.T.} )
	AAdd( aObjects, { 100, 020,.T.,.F.} )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)


	cCadastro:= OemToAnsi("Notas Fiscais de Origem")+"-"+OemToAnsi("Complemento - Frete") //STR0033) 	//"Notas Fiscais de Origem"
	nOpca := 0
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],000 To aSize[6],aSize[5] OF oMainWnd PIXEL

	@ aPosObj[1,1],aPosObj[1,2] MSPANEL oPanel PROMPT "" SIZE aPosObj[1,3],aPosObj[1,4] OF oDlg CENTERED LOWERED
    
    If cArq  == "SF1"
		cTexto1 := AllTrim(RetTitle("F1_FORNECE"))+"/"+AllTrim(RetTitle("F1_LOJA"))+": "+SA2->A2_COD+"/"+SA2->A2_LOJA+"  -  "+RetTitle("A2_NOME")+": "+SA2->A2_NOME
	Else
		cTexto1 := AllTrim(RetTitle("F2_CLIENTE"))+"/"+AllTrim(RetTitle("F2_LOJA"))+": "+SA1->A1_COD+"/"+SA1->A1_LOJA+"  -  "+RetTitle("A1_NOME")+": "+SA1->A1_NOME		
	EndIf
	@ 002,005 SAY cTexto1 SIZE aPosObj[1,3],008 OF oPanel PIXEL

	cDescProd := AllTrim(Posicione("SB1",1,xFilial("SB1")+cProd,"B1_COD"))
	cDescProd += +"/"+AllTrim(Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC"))

	cTexto2  := AllTrim(RetTitle("B1_COD"))+": "+cDescProd 

	@ 012,005 SAY cTexto2 SIZE aPosObj[1,3],008 OF oPanel PIXEL	
	
	@ aPosObj[2,1],aPosObj[2,2] LISTBOX oQual VAR cVar Fields HEADER OemToAnsi("Nota"),OemToAnsi("Serie"),OemToAnsi("Item"),OemToAnsi("Valor Item"),OemToAnsi("Valor IPI"),OemToAnsi("Valor ICMS"),OemToAnsi("Valor Unitario") SIZE aPosObj[2,3],aPosObj[2,4] ON DBLCLICK (nOpca := 1,oDlg:End()) PIXEL	
	//"Nota"###"S┌rie"###"Item"###"Valor Item"###"Valor IPI"
	oQual:SetArray(aArrayF4)
//	oQual:bLine := { || {aArrayF4[oQual:nAT][1],aArrayF4[oQual:nAT][2] /*,aArrayF4[oQual:nAT][3],aArrayF4[oQual:nAT][4],aArrayF4[oQual:nAT][5],aArrayF4[oQual:nAT][6],aArrayF4[oQual:nAT][7]*/ }}

	oQual:bLine := { || {aArrayF4[oQual:nAT][1],aArrayF4[oQual:nAT][2],aArrayF4[oQual:nAT][3],aArrayF4[oQual:nAT][4],aArrayF4[oQual:nAT][5],aArrayF4[oQual:nAT][6],aArrayF4[oQual:nAT][7] }}
		
	DEFINE SBUTTON FROM aPosObj[3,1]+000,aPosObj[3,4]-030  TYPE 1 ACTION (nOpca := 1,oDlg:End()) 	ENABLE OF oDlg PIXEL
	DEFINE SBUTTON FROM aPosObj[3,1]+012,aPosObj[3,4]-030 TYPE 2 ACTION oDlg:End() 					ENABLE OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg VALID (nOAT := oQual:nAT, .t.) CENTERED

	If nOpca == 1
		If cProg != "A440"
			nRecSD1	:= aRecSD1[nOAT]
		EndIf    
		 nPosNf  := Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_NFORI'  })
		 nPosSer := Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_SERIORI' })
		 nPosIt  := Ascan(aMyHeader, {|X| Alltrim(X[2]) == 'D1_ITEMORI'  })
		   
		oBrwV:aCols[n][nPosNf]	:= aArrayF4[nOAT][1]
		oBrwV:aCols[n][nPosSer]	:= aArrayF4[nOAT][2]
		oBrwV:aCols[n][nPosIt] 	:= aArrayF4[nOAT][3]
		//&(ReadVar()) 		:= aArrayF4[nOAT][1]
	Endif
Else
	HELP(" ",1,"F4NAONOTA")
Endif

dbSelectArea(cAlias)
dbSetOrder(nOrdem)
dbGoto(nRec)
SetFocus(nHdl)

Return(.T.)
*****************************************************************
User Function OpenArqCfg()
*****************************************************************
Local  lRetorno		:=	.T.
Local  lCopia		:=	IIF(Type('ParamIxb')=='U', .F., IIF(Len(ParamIxb)>0,ParamIxb[01], .F.) )
Static cArqConfig	:=	'CTE_CFG.DBF'
Static cIndConfig	:=	'TMPCTE.CDX'
Static cOldArq_Cfg	:=	Left(cArqConfig, (Len(cArqConfig)-4))+'_OLD'+Right(AllTrim(cArqConfig), 4)
Static _StartPath
Static _RootPath
Static _RpoDb
Static _cPathTable
Static _cArqIni
Static _cMail
Static _aEmpFil


If Type('_StartPath') == 'U' .And. Empty(_StartPath)

	//зддддддддддддддддддддддддддддддддддддддддд©
	//Ё    CARREGA INFORMACOES DE CONFIGURACAO	Ё
	//юддддддддддддддддддддддддддддддддддддддддды
	aRetIni := ExecBlock("CTe_IniConfig",.F.,.F.,{.F.})
	
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
	

	ExecBlock("CTe_TelaConfig",.F.,.F., {.F.} )
	
EndIf


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё    CRIA PASTA CTE_CFG PARA GUARDAR ARQUIVOS DE CONFIGURACAO     Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If !File(_StartPath+'CTE_CFG')
	MakeDir(_StartPath+'CTE_CFG')  
EndIf

//зддддддддддддддддддддддддддддддддд©
//Ё ABRE ARQUIVO DE CONFIGURACAO    |
//юддддддддддддддддддддддддддддддддды
If !File(_StartPath+'CTE_CFG\'+cArqConfig)
	ExecBlock("CTe_TelaConfig",.F.,.F., {.F., .F.} )
EndIf


//зддддддддддддддддддддддддддддддддд©
//Ё ABRE ARQUIVO DE CONFIGURACAO    |
//юддддддддддддддддддддддддддддддддды
If Select('TMPCTE') == 0
	DbUseArea(.T.,,_StartPath+'CTE_CFG\'+cArqConfig, 'TMPCTE',.T.,.F.)
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё VERIFICA SE INDICE EXISTE, CASO NEGATIVO CRIA NOVO INDICE	 |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды	
If !File(_StartPath+cIndConfig)						// TMPCTE.CDX
	DBCreateIndex('TMPCTE','EMPRESA+FILIAL', {|| 'EMPRESA+FILIAL' } )
EndIf


If File(_StartPath+'CTE_CFG\'+cArqConfig)
	If lCopia
		//здддддддддддддддддддддддддддддддддддддддддд©
		//Ё COPIA CTE_CFG.DBF PARA CTE_CFG_OLD.DBF	 |
		//юдддддддддддддддддддддддддддддддддддддддддды
		_CopyFile(_StartPath+'CTE_CFG\'+cArqConfig, _StartPath+'CTE_CFG\'+cOldArq_Cfg)
	
	EndIf
Else
	Alert('Problema ao carregar informaГУes! Rotina OpenArqCfg.' )
EndIf
		             


If Select('TMPCTE') != 0

	If TMPCTE->(IndexOrd()) == 0
		//TMPCTE->(IndexKey()) != 'EMPRESA+FILIAL'
		
		If Select('TMPCTE') == 0
			DbUseArea(.T.,,_StartPath+'CTE_CFG\'+cArqConfig, 'TMPCTE',.T.,.F.)
		Else
			DbSelectArea('TMPCTE')
		EndIf


		If !File(_StartPath+'CTE_CFG\'+cIndConfig)
			DBCreateIndex(_StartPath+'CTE_CFG\TMPCTE','EMPRESA+FILIAL', {|| 'EMPRESA+FILIAL' } )
		Else
			//cIndexArq := RetFileName(cIndConfig)
			//DbSetIndex(_StartPath+'CTE_CFG\'+cIndexArq)
			DbSetIndex(_StartPath+'CTE_CFG\'+cIndConfig)
		EndIf


	EndIf
	
EndIf

Return(lRetorno)
*****************************************************************
User Function MultFreteVenda()
*****************************************************************
Private cPerg		:=	'IMPCTE' 
Private cCadastro 	:= 	'Multiplos Frete de Venda'
Private cMarca		:= 	GetMark()
Private lInverte 	:= 	.T.
Private aCampos 	:= 	{}
Private aRotina 	:= 	{}
Private	cArq 		:= 	CriaTrab(,.F.)
Private cIndexTmp


aCores    := {  { 'LEFT(TMPTRB->ZXC_SITUAC,1)=="C" '	, 'BR_VERMELHO'	},;
                { 'LEFT(TMPTRB->ZXC_STATUS,1)=="*" '   	, 'BR_LARANJA'	},;
                { 'LEFT(TMPTRB->ZXC_STATUS,1)=="I" '   	, 'BR_AZUL'		},;
                { 'LEFT(TMPTRB->ZXC_STATUS,1)=="R" '   	, 'BR_CINZA'	},;
                { 'LEFT(TMPTRB->ZXC_STATUS,1)=="E" '   	, 'BR_CANCEL'	},;
                { 'LEFT(TMPTRB->ZXC_STATUS,1)=="G" '   	, 'BR_VERDE'	}}  
                


/*
aLegenda:= {	{ 'BR_AZUL'		,'XML CT-e Importado'			},;
                { 'BR_LARANJA'	,'XML CT-e Arquivado'			},;
                { 'BR_CINZA'	,'XML CT-e Recusado'			},;
                { 'BR_CANCEL'	,'XML CT-e Cancelado pelo Usuario'},;
                { 'BR_VERDE'	,'XML CT-e Gravado'				},;
                { 'BR_VERMELHO'	,'XML CT-e Cancelado na Sefaz'	}}
*/

Aadd( aRotina, { "Gerar"  ,'ExecBlock("GeraMultFrete")', 0, 6 })
//Aadd( aRotina, { "Legenda",'BrwLegenda("Status","Legenda",aLegenda)'  , 0, 2 })


Aadd(aCampos,  { 'FLAG', 'Marked()', 'X', '' } )
DbSelectArea('SX3');DbSetOrder(1);DbGoTop()
If DbSeek('ZXC'+'01',.F.)

	cX3Arq	:=	SX3->X3_ARQUIVO

	Do While cX3Arq == SX3->X3_ARQUIVO

			If TRIM(SX3->X3_CAMPO) == 'ZXC_XML'
				DbSkip()
				Loop
			ElseIf ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL ) 
				Aadd(aCampos,{ TRIM(SX3->X3_CAMPO), Nil, SX3->X3_TITULO, SX3->X3_PICTURE } ) 
			Endif	
			
	DbSkip()
	EndDo

	Aadd(aCampos, {'ZXC_RECNO'	, Nil, 'Recno'	, '' } )
	Aadd(aCampos, {'X'			, Nil, ''		, '' } )
EndIf

AjustaSx1()
If !Pergunte(cPerg,.T.) 
	Return
EndIf      

**********************************************************************************
	Processa ( { || GeraQuery() } ,'Processando...  Aguarde...' ,'Processando...   ' ,.T.)	
**********************************************************************************

DbSelectArea('SQL');DbGoTop()
MarkBrowse("TMPTRB","FLAG",,aCampos,@lInverte,@cMarca,,,,,,,,,aCores)

			// DOIS CLICK MOSTRA ERRO


FErase(cArq + '.dtc')
IIF(Select("SQL") != 0, SQL->( DbCLoseArea() ), )
IIF(Select('TMPTRB')!= 0, TMPTRB->( DbCLoseArea() ), )
Return()
*************************************************************************
Static Function GeraQuery()
*************************************************************************

ProcRegua(5);IncProc()
IIF(Select("SQL") != 0, SQL->( DbCLoseArea() ), )

cQuery := ""
cQuery += "	SELECT	'' AS 'FLAG',  "+ENTER	
cQuery += "	CASE "+ENTER
cQuery += "		WHEN ZXC_STATUS = 'C' THEN 'Cancelado na Sefaz' "+ENTER	
cQuery += "		WHEN ZXC_STATUS = '*' THEN 'Arquivado' "+ENTER	
cQuery += "		WHEN ZXC_STATUS = 'I' THEN 'Importado' "+ENTER	
cQuery += "		WHEN ZXC_STATUS = 'R' THEN 'Recusado'  "+ENTER	
cQuery += "		WHEN ZXC_STATUS = 'X' THEN 'Cancelado pelo Usuario' "+ENTER	
cQuery += "		WHEN ZXC_STATUS = 'G' THEN 'Gravado'  	"+ENTER
cQuery += "		WHEN ZXC_STATUS = 'E' THEN 'Erro'  		"+ENTER
cQuery += "	END AS ZXC_STATUS,  "+ENTER
cQuery += "	R_E_C_N_O_ AS ZXC_RECNO, '' AS 'X',  * "+ENTER	

IncProc()
cQuery += "	FROM	" +RetSqlName('ZXC')+" AS ZXC"+ENTER
cQuery += "	WHERE	ZXC.ZXC_STATUS	= 	'I'	"+ENTER  				
cQuery += "	AND		ZXC.ZXC_FORNEC	BETWEEN '"+MV_PAR01+"'	AND  '"+MV_PAR03+"'  "+ENTER
cQuery += "	AND		ZXC.ZXC_LOJA	BETWEEN '"+MV_PAR02+"'	AND  '"+MV_PAR04+"'  "+ENTER
cQuery += "	AND		ZXC.ZXC_DTNFE	BETWEEN '"+DtoS(MV_PAR05)+"'	AND  '"+DtoS(MV_PAR06)+"'  "+ENTER
cQuery += "	AND		ZXC.ZXC_DOC		BETWEEN '"+MV_PAR07+"'	AND  '"+MV_PAR08+"'  "+ENTER
cQuery += "	AND		ZXC.ZXC_SERIE	BETWEEN '"+MV_PAR09+"'	AND  '"+MV_PAR10+"'  "+ENTER
cQuery += "	AND		ZXC.D_E_L_E_T_ 	!= 	'*'	   "+ENTER
 cQuery += "	ORDER BY ZXC.ZXC_DOC, ZXC.ZXC_SERIE "+ENTER
IncProc()

MemoWrit(GetTempPath()+"MultFreteVenda.TXT", cQuery)            
MsAguarde({|| DbUseArea(.t.,'TOPCONN',TcGenQry(,,cQuery),'SQL',.f.,.f.)},'Aguarde...','Realizando Busca...' )

SQL->(DbGoTop())
Copy To &cArq
DbCloseArea()
IIF(Select('TMPTRB')!= 0, TMPTRB->( DbCLoseArea() ), )
DbUseArea(.T.,, cArq, 'TMPTRB', .T., .F.)
		
IncProc()
Return()
*****************************************************************
User Function GeraMultFrete()
*****************************************************************
Local lProssegue 	:= 	.F.                         
Private cGetProd   	:= 	Space(TamSx3('B1_COD')[01])
Private cDescrProd 	:= 	Space(TamSx3('B1_DESC')[01])
Private cGetTes    	:= 	Space(TamSx3('D1_TES')[01]) 
Private cDescrTes  	:= 	Space(TamSx3('F4_TEXTO')[01])
Private cGetSE4 	:= 	Space(TamSx3('E4_CODIGO')[01])
Private cDescSE4 	:= 	Space(TamSx3('E4_DESCRI')[01])
Private cEspecCTe 	:= 	Space(TamSx3('F1_ESPECIE')[01])
Private nGetQtd    	:=	1

SetPrvt("oFont1","oFontP","oDlgMult","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oGetProd","oGetTes")
SetPrvt("oBtnOK","oBtnSair","oGrp2","oSay6")


DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()
If DbSeek(cEmpAnt+cFilAnt, .F.)     
	cGetProd	:=	AllTrim(TMPCTE->PRODXCTE)
	cDescrProd	:=	IIF(!Empty(AllTrim(TMPCTE->PRODXCTE)), AllTrim(Posicione('SB1',1,xFilial('SB1')+ cGetProd ,'B1_DESC')), '')
   	cGetTes		:=	AllTrim(TMPCTE->TESXCTE)
   	cDescrTes	:=	IIF(!Empty(AllTrim(TMPCTE->TESXCTE)),  AllTrim(Posicione('SF4',1,xFilial('SF4')+ cGetTes ,'F4_TEXTO')), '')
   	cEspecCTe	:=	IIF(TMPCTE->(FieldPos("ESPXCTE")) > 0 , AllTrim(TMPCTE->ESPXCTE), Space(TamSx3('F1_ESPECIE')[01]) )
EndIf
        
oFont1     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oFontP     := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )

oDlgMult   := MSDialog():New( 116,234,398,874,"Multiplos Fretes Saida",,,.F.,,,,,,.T.,,oFont1,.T. )
oGrp2      := TGroup():New( 004,008,024,300,"",oDlgMult,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay6      := TSay():New( 012,036,{||"ParБmetros utilizados para gerar Multiplos Fretes de SaМda."},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,220,008)

oGrp1      := TGroup():New( 028,008,123,300,"",oDlgMult,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 040,016,{||"Produto:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetProd   := TGet():New( 036,058,{|u| If(PCount()>0,cGetProd:=u,cGetProd)},oGrp1,068,010,'',{|| cDescrProd := AllTrim(Posicione('SB1',1,xFilial('SB1')+ cGetProd ,'B1_DESC')), oSay2:Refresh() },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cGetProd",,)
oSay2      := TSay():New( 040,135,{|| cDescrProd },oGrp1,,oFontP,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,160,008)

oSay3      := TSay():New( 056,016,{||"TES:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetTes    := TGet():New( 052,058,{|u| If(PCount()>0,cGetTes:=u,cGetTes)},oGrp1,068,010,'',{|| cDescrTes := AllTrim(Posicione('SF4',1,xFilial('SF4')+ cGetTes ,'F4_TEXTO')), oSay4:Refresh() },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF4","cGetTes",,)
oSay4      := TSay():New( 056,135,{|| cDescrTes},oGrp1,,oFontP,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,160,008)

oSay5      := TSay():New( 072,016,{||"Quant.:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetQtd    := TGet():New( 068,058,{|u| If(PCount()>0,nGetQtd:=u,nGetQtd)},oGrp1,068,010,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nGetQtd",,)

oSaySE4    := TSay():New( 088,016,{||"Cond.Pag.:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oGetSE4    := TGet():New( 083,058,{|u| If(PCount()>0,cGetSE4:=u,cGetSE4)},oGrp1,068,010,'',{|| cDescSE4 := AllTrim(Posicione('SE4',1,xFilial('SE4')+ cDescSE4 ,'E4_DESCRI')), oSaySE4:Refresh() },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SE4","cDescSE4",,)
oSaySE4    := TSay():New( 087,135,{|| cDescSE4 },oGrp1,,oFontP,.F.,.F.,.F.,.T.,CLR_GRAY,CLR_WHITE,160,008)

oSaySE4    := TSay():New( 104,016,{||"Especie:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oGetSE4    := TGet():New( 100,058,{|u| If(PCount()>0,cEspecCTe:=u,cEspecCTe)},oGrp1,068,010,'',{|| },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEspecCTe",,)


oBtnOK     := TButton():New( 126,104,"OK"  ,oDlgMult,{|| lProssegue := .T.,  oDlgMult:End() },037,012,,oFont1,,.T.,,"",,,,.F. )
oBtnSair   := TButton():New( 126,168,"Sair",oDlgMult,{|| lProssegue := .F.,  oDlgMult:End() },037,012,,oFont1,,.T.,,"",,,,.F. )

oDlgMult:Activate(,,,.T.)



If lProssegue
	Processa ({|| ProcMutFrete()},'Aguarde Gerando Frete Vendas', 'Processando...', .T.)
EndIf


Return()
*****************************************************************
Static Function ProcMutFrete()
*****************************************************************
Local nCount 	:= 	0
Local _cEspecie	:=	Space(TamSX3('F1_ESPECIE')[1])
Private	aCabec  :=	{}
Private	aItens  :=	{}
                                             

If TMPCTE->(FieldPos("ESPXCTE")) > 0  
	If !Empty(TMPCTE->ESPXCTE)
		_cEspecie	:=	AllTrim(TMPCTE->ESPXCTE)
	EndIf
EndIf

			
SQL->(DbGoTop())
SQL->( dbEval( { || nCount++ } ) )

ProcRegua(nCount)
DbSelectArea('TMPTRB');DbGoTop()
Do While !Eof()
		
		
	IncProc()
	If !Marked("FLAG")
		DbSkip()
		Loop
	EndIf	
 
 	aCabec  	:=	{}
	aItens 		:=	{}
	cUfOrig   	:= 	''
	lCondPag  	:= 	.F.
		
	SA2->(DbGoTop(), DbSetOrder(3))
	If SA2->(DbSeek(xFilial("SA2") + ZXC->ZXC_CGC,.F.))
		//cCondPag  :=  SA2->A2_COND
		cUfOrig   :=  SA2->A2_EST
	EndIf
	
  
	//зддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё  ARRAY CABEC PARA UTILIZAR NO MSExecAuto	Ё
	//юддддддддддддддддддддддддддддддддддддддддддддды
	Aadd(aCabec,{"F1_TIPO",			'N'		      		, Nil })
	Aadd(aCabec,{"F1_DOC",			TMPTRB->ZXC_DOC 	, Nil })
	Aadd(aCabec,{"F1_SERIE",       	TMPTRB->ZXC_SERIE	, Nil })
	Aadd(aCabec,{"F1_FORMUL",       'N' 	       		, Nil })
	Aadd(aCabec,{"F1_EMISSAO",      STOD(TMPTRB->ZXC_DTNFE)   , Nil })//Roger ddatabase// dDHEmit
	Aadd(aCabec,{"F1_FORNECE",      TMPTRB->ZXC_FORNEC	, Nil })
	Aadd(aCabec,{"F1_LOJA",         TMPTRB->ZXC_LOJA	, Nil })
	Aadd(aCabec,{"F1_EST",          cUfOrig				, Nil })
	Aadd(aCabec,{"F1_ESPECIE",      _cEspecie			, Nil })
	Aadd(aCabec,{"F1_COND",         cGetSE4				, Nil })
	Aadd(aCabec,{"F1_CHVNFE",       TMPTRB->ZXC_CHAVE	, Nil })
	Aadd(aCabec,{"F1_HORA",         Left(Time(),5)		, Nil })
    Aadd(aCabec,{"F1_TPCTE",        'N'             	, Nil })  //Roger
	
	If SF1->(FieldPos("F1_TRANSP")) > 0
		cCodTransp := Posicione("SA4",3,xFilial("SA4")+TMPTRB->ZXC_FORNEC,"A4_COD")
		If !Empty(cCodTransp)
			Aadd(aCabec,{"F1_TRANSP", cCodTransp , Nil })
		EndIf
	EndIf
	     
//	If SF1->(FieldPos("F1_CHVNFE")) <> 0  .And. !Empty(cChCTe) .And. Empty(ZXC->ZXC_CHAVE)
//		Aadd(aCabec,{"F1_CHVNFE",  cChCTe , Nil })
//	EndIf
	

	//зддддддддддддддддддддддддддддд©
	//Ё     ALIMENTA aMyACols       Ё
	//юддддддддддддддддддддддддддддды

	//зддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё    ABRE XML E CARREGA INFORMACOES DO XML        |
	//юддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea('ZXC');DbGoTo(TMPTRB->ZXC_RECNO)
	cXML	:=	AllTrim(ZXC->ZXC_XML)                       
	
	cXML	+=	ExecBlock("CTe_VerificaZXD",.F.,.F., {TMPTRB->ZXC_FILIAL, TMPTRB->ZXC_CHAVE})	//	VERIFICA SE O XML ESTA NA TABELA ZXD
	
	
	//здддддддддддддддддддддддддддддддддддддддддд©
	//Ё  CabecCTeParser -   ABRE XML - CABEC     Ё
	//юдддддддддддддддддддддддддддддддддддддддддды 
	//зддддддддддддддддддддддддддддддддд©
	//Ё ABRE ARQUIVO DE CONFIGURACAO    |
	//юддддддддддддддддддддддддддддддддды
	********************************************
		ExecBlock('OpenArqCfg',.F., .F., {} )
	********************************************

	*******************************************************************
	   aRet	:=	ExecBlock("CabecCTeParser",.F.,.F., {cXML})
	*******************************************************************
	
	If aRet[1] == .T.	//	aRet[1] == .F. SIGNIFICA XML COM PROBLEMA NA ESTRUTURA
	
		
	   	For nX := 1 To nItensCTe

           	cNumPC 		:= 	cItemPC  := cAlmox  :=  cTes	:=	cUM	:=	''
			cCtaCont    :=  cCCusto  := _cTipo	:=	cNCM    := ''
	
           	SB1->(DbGoTop(), DbSetOrder(1))
           	If SB1->(DbSeek(xFilial('SB1') + cGetProd ,.F.) )
           		cAlmox 		:= 	AllTrim(SB1->B1_LOCPAD)		//	Local Padrao 
				cGetTes		:= 	IIF(!Empty(cGetTes), cGetTes, AllTrim(SB1->B1_TE))			//	Codigo de Entrada padrao
           		cCtaCont	:= 	AllTrim(SB1->B1_CONTA)		//	Conta Contabil dn Prod.
           		cCCusto		:=	AllTrim(SB1->B1_CC)			//	Centro de Custo
           		cUM			:=	AllTrim(SB1->B1_UM)			//	Unidade de Medida
				cNCM		:=	AllTrim(SB1->B1_POSIPI)		//	NCM
			ElseIf SX6->(DbGoTop(), DbSeek( cFilAnt+'MV_LOCPAD' ,.F.) )
               	cAlmox := AllTrim(SX6->X6_CONTEUD)		               
            EndIf

			_aItem := {}
			nItemCTe := PadL(AllTrim(Str(nX)),4,'0')
			           	
			Aadd( _aItem, {'D1_ITEM', 		nItemCTe , Nil		})
			Aadd( _aItem, {'D1_COD',  		cGetProd, Nil		})
			Aadd( _aItem, {'D1_LOCAL', 		cAlmox 	, Nil		})
			//Aadd( _aItem, {'D1_PEDIDO', 	cNumPC		, Nil	})
			//Aadd( _aItem, {'D1_ITEMPC', 	cItemPC		, Nil	})
			Aadd( _aItem, {'D1_TES',		cGetTes		, Nil	})
			Aadd( _aItem, {'D1_UM',			Upper(cUM)	, Nil	})
			Aadd( _aItem, {'D1_QUANT',		nGetQtd		, Nil	})  
			Aadd( _aItem, {'D1_VUNIT',		Val(cVTPrest), Nil	})
			Aadd( _aItem, {'D1_TOTAL', 		Val(cVTPrest), Nil	})
			Aadd( _aItem, {'D1_CC', 		cCCusto		, Nil	})
			Aadd( _aItem, {'D1_CONTA', 		cCtaCont	, Nil	})
			Aadd( _aItem, {'D1_VALICM', 	Val(cVlrIcms), Nil	})
			Aadd( _aItem, {'D1_PICM', 		Val(cPerIcms), Nil	})
			Aadd( _aItem, {'D1_BASEICM', 	Val(cBaseIcms), Nil	})
			
			Aadd(aItens, aClone(_aItem) )
		
		Next
		
		
		BEGIN TRANSACTION

		lMsHelpAuto := .T.
		lMsErroAuto := .F.
		
		DbSelectArea('SF1')                                                                         // .F. NAO MOSTRA TELA DOC.ENTRADA
		MsAguarde( {|| MSExecAuto({|x, y, z, w, a | MATA103(x, y, z, w, a )}, aCabec,  aItens, 3, .F.)    },'Processando','Gerando Documento de Entrada '+TMPTRB->ZXC_DOC + IIF(!Empty(TMPTRB->ZXC_SERIE), +' - '+TMPTRB->ZXC_SERIE, '') )
		//зддддддддддддддддддддддддддддддддддддд©
		//Ё  ERRO AO TENTAR GRAVAR DOC.ENTRADA	|
		//юддддддддддддддддддддддддддддддддддддды
		If lMsErroAuto
			//MostraErro()
			DisarmTransaction()

			DbSelectArea('TMPTRB')
  			Reclock('TMPTRB',.F.)               
				TMPTRB->ZXC_OBS		:=	MostraErro()
				TMPTRB->ZXC_STATUS	:=	'Erro'
			MsUnlock()
			
		Else

			DbSelectArea('TMPTRB')
  			Reclock('TMPTRB',.F.)               
				TMPTRB->ZXC_STATUS	:=	'Gravado com Sucesso'
			MsUnlock()

		DbSelectArea('ZXC')
		If ZXC->(Recno()) != TMPTRB->ZXC_RECNO
			DbGoTo(TMPTRB->ZXC_RECNO)
		EndIf

		Reclock('ZXC',.F.)               
			ZXC->ZXC_STATUS	:=	'G'
		MsUnlock()		


		EndIf
		
		
		END TRANSACTION
	
	Else
	
		DbSelectArea('TMPTRB')
  		Reclock('TMPTRB',.F.)               
			TMPTRB->ZXC_OBS		:=	MostraErro()
			TMPTRB->ZXC_STATUS	:=	'E'
		MsUnlock()

	EndIf    
    
	
	DbSelectArea('TMPTRB')
	DbSkip()

EndDo

Return()
*****************************************************************
Static Function AjustaSx1()
*****************************************************************
cAlias := Alias()
aRegs  :={}
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
Aadd(aRegs,{cPerg,"01","Do Fornecedor      ?","","", "MV_CH1","C", 06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
Aadd(aRegs,{cPerg,"02","Da Loja         	?","","", "MV_CH2","C", 02,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","AtИ Fornecedor   	?","","", "MV_CH3","C", 06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""} )
Aadd(aRegs,{cPerg,"04","AtИ Loja 			?","","", "MV_CH4","C", 02,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""} )
Aadd(aRegs,{cPerg,"05","Da Data CTe		  	?","","", "MV_CH5","D", 08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",""} )
Aadd(aRegs,{cPerg,"06","AtИ Data CTe		?","","", "MV_CH6","D", 08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""} )
Aadd(aRegs,{cPerg,"07","Do Documento       ?","","", "MV_CH7","C", 09,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","ZXC",""})
Aadd(aRegs,{cPerg,"08","AtИ Documento      ?","","", "MV_CH8","C", 09,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","ZXC",""})
Aadd(aRegs,{cPerg,"09","Da Serie         	?","","", "MV_CH9","C", 03,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"10","AtИ Serie        	?","","", "MV_CHa","C", 03,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","",""})


DbSelectArea("SX1")
DbSetOrder(1)
For i:=1 to Len(aRegs)
	RecLock("SX1",!DbSeek(PadR(cPerg,10,'')+aRegs[i,2]))
	For j:=1 to FCount()
		If j<=Len(aRegs[i]) .and. !(left(fieldname (j), 6) $ "X1_CNT/X1_PRESEL")
			FieldPut(j,aRegs[i,j])
		Endif
	Next
	MsUnlock()
Next

DbSelectArea(cAlias)
Return()
*****************************************************************
Static Function CheckCnpj(_cCnpj)
*****************************************************************
Local _cRetorno := ''

DbSelectArea('TMPCTE');DbSetOrder(1);DbGoTop()
Do While !Eof() 

	If 	AllTrim(TMPCTE->CNPJ) == AllTrim(_cCnpj)
		_cRetorno := AllTrim(TMPCTE->CNPJ)
		Exit
	EndIf

	DbSelectArea('TMPCTE')
	DbSkip()
EndDo

Return(_cRetorno)
