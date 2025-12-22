#INCLUDE "RWMAKE.CH"
#include "ap5mail.ch"
#include "Protheus.Ch"
#include "TopConn.Ch"
#include "TBIConn.Ch"
#include "TbiCode.ch"   
/*/{protheus.doc}A010TOK
Ponto de Entrada no botão ok do cadastro de produto
@author Eduardo Franco
@since 12/08/2009
@ObsLeandro Nasc  em 30/08/13 Realizada Validacaoes para WF de Produtos        
/*/

User Function A010TOK()

Local aArea  	:= GetArea()
Local lLibera 	:= .T.
Local cQueryFor := ""
Local cLog		:= ""
Local cPula    	:= CHR(13) + CHR(10)
Local i := 0				//ADD LUCIANO LAMBERTI - 19-09-2022

//Campos que foram Alterados
Local lAltCtb 	:= .F.
Local lAltPcp	:= .F.
Local lAltAlm 	:= .F.
Local lAltFis 	:= .F.
Local lAltComp 	:= .F.
Local lAltComPcp := .F. 

//Teste para ver possui restricao em algum campo
Local lBloq 	:= .F.

//Grupo que o usuario pertence
Private lAdmin 		:= .F.    

Private lCompras 	:= .F.
Private lPcp 		:= .F.
Private lFiscal 	:= .F.
Private lContabilidade := .F.
Private lUtilizaWF	:= GetMv( "HL_WFPROD" ) //Indica se Utiliza o WF de Produtos

Private cCodUsr := RetCodUsr()
Private aGrupos := UsrRetGrp(cCodUsr)
Private cUser   := UsrRetName(cCodUsr)
Private cNomeUsr:= UsrFullName(cCodUsr)
Private cId		:= ""
Private cNivelZB1 := ""
Private lNovoProcesso	 := .F.
Private lEncerraProcesso := .F.
Private	lAtualizaWF		 := .F.
Private lLiberaManual	 := .F.

//Destinatarios de E-mail
Private cEmailCom := ""
Private cEmailPcp := ""
Private cEmailFis := ""
Private cEmailCont := ""
Private cAssunto	:= ""
Private cMensagem	:= ""

//Private oModelB1 := PARAMIXB[1] //Atualização MVC - Guilherme Ricci - TOTVS IP - 21/05/2018 - Pendente criação MATA010_PE

xCOD := M->B1_COD
cId := Alltrim(xCOD)+"/"+Substr(dtos(date()),5,2)+Substr(dtos(date()),1,4)+"-"+Alltrim(Str(Randomize(10,1000)))
lOk := .T.
IF SB1->B1_TIPO = "MP" .AND. SB1->B1_PROC = ''
   msgalert("Informar o código do Fornecedor Padrao")
   lOk := .F. 
ENDIF 
//Return lOk - RETIRADO PARA GERAR O WORKFLOW 
If lUtilizaWF
	
	/****************************************
	Verifica Grupos que o usuario Pertence
	****************************************/
	For i= 1 to len(aGrupos)
		If aGrupos[i] == "000000"  .Or. aGrupos[i] == "000007" .Or. cCodUsr = "000000"//Grupo Adminsitradores ou Usuários master do cadastro
			lAdmin := .T.
		ElseIf aGrupos[i] == "000001" 	//Grupo Compras
			lCompras := .T.
		ElseIf 	aGrupos[i] == "000002" 	//Grupo PCP
			lPcp := .T.
		ElseIf 	aGrupos[i] == "000003" 	//Grupo Fiscal
			lFiscal := .T.
		ElseIf 	aGrupos[i] == "000004" 	//Grupo Cotabilidade
			lContabilidade := .T.  

		Endif
	Next i
	
	/*
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³     Inicio do Codigo para validacoes do WorkFlow de Produtos              ³±±
	±±³     Desenvolvimento: Leandro do Nascimento - Data: 13/09/2013	          ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	
	If ALTERA
		
		/**************************************************************************
		Carrega Informacoes do Produto antes de realizar a alteracao no Cadastro
		***************************************************************************/
		cQueryFor	:= "SELECT * "
		cQueryFor	+= "FROM "
		cQueryFor	+=		RETSQLNAME("SB1") + " B1 "
		cQueryFor	+= "WHERE  "
		cQueryFor	+= "	B1_COD = '"+xCOD+"' "
		cQueryFor	+= "	AND D_E_L_E_T_ = ''"
		
		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea("TRB")
		Endif
		
		MPSysOpenQuery( cQueryFor, "TRB" ) // dbUseArea( .T., "TOPCONN", TCGenQry(,,cQueryFor), "TRB", .F., .F. )
		
		/*
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³     Caso esteja bloqueando o produto nao realiza validacoes				  ³±±
		±±³     Desenvolvimento: Leandro do Nascimento - Data: 13/09/2013	          ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		
		If TRB->B1_MSBLQL = "2" .And. M->B1_MSBLQL = "1"
			IF TRB->B1_ZZNIVWF <> "6"				
				If Aviso('BLOQUEIO - Em WorkFlow', 'O Produto: '+Alltrim(M->B1_COD)+' - '+Alltrim(M->B1_DESC)+' esta aguaradando processos WorkFlow, se continuar os processos atuais serão encerrados.'+cPula+'Deseja Continuar?', {'Continuar', 'Cancelar'}) == 1
					lEncerraProcesso := .T.
					WFPROD()
					Return(.T.)
				Endif				
			Else
				Return(.T.)
			Endif
		Endif
		
		/**************************************************************************
		Verifica se o produto esta em processo de WF, neste ponto pode se
		remover a pergunta, e nao pemritir a alteração de processos em WorkFlow.
		
		Aqui tambem eh verificado se a alteracao eh do nivel atual para atualizar o wf
		***************************************************************************/
		
		If !lAdmin  //Se for Administrador ou usuario master do cadastro nao Realiza Validacoes
			If M->B1_ZZNIVWF == "2" .And. lCompras
				cNivelZB1 := "1"
				lAtualizaWF := .T.
			ElseIf M->B1_ZZNIVWF == "3" .And. lPcp
				cNivelZB1 := "2"
				lAtualizaWF := .T.
			ElseIf M->B1_ZZNIVWF == "4" .And. lFiscal
				cNivelZB1 := "3"
				lAtualizaWF := .T.
			ElseIf M->B1_ZZNIVWF == "5" .And. lContabilidade
				cNivelZB1 := "4"
				lAtualizaWF := .T.
			ElseIf M->B1_ZZNIVWF == "6"
				lNovoProcesso	 := .T.
			Else
				If Aviso('Em WorkFlow', 'O Produto: '+Alltrim(M->B1_COD)+' - '+Alltrim(M->B1_DESC)+' esta aguaradando processos WorkFlow, se continuar os processos atuais serão encerrados e um novo fluxo será iniciado.'+cPula+'Deseja Continuar?', {'Continuar', 'Cancelar'}) == 1
					lEncerraProcesso := .T.
					lNovoProcesso	 := .T.
				else
					Return(.F.)
				Endif
			Endif
		Endif
		
		/*
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³     Verifica se o campo alterado possui restricao por Departamento        ³±±
		±±³     Desenvolvimento: Leandro do Nascimento - Data: 13/09/2013	          ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		
		/*
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		Filtra direito de Aletracoes do Grupo Compras e PCP
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		If M->B1_COD <> TRB->B1_COD .Or. M->B1_DESC <> TRB->B1_DESC .Or. M->B1_CODMATR <> TRB->B1_CODMATR;
			.Or. M->B1_CODMAT2 <> TRB->B1_CODMAT2 .Or. M->B1_UM <> TRB->B1_UM .Or. M->B1_TIPO <> TRB->B1_TIPO;
			.Or. M->B1_LOCPAD <> TRB->B1_LOCPAD .Or. M->B1_GRUPO <> TRB->B1_GRUPO .Or. M->B1_ORIGEM <> TRB->B1_ORIGEM;
			.Or. M->B1_LADO <> TRB->B1_LADO .Or. M->B1_QE <> TRB->B1_QE .Or. M->B1_ZZCOR <> TRB->B1_ZZCOR;
			.Or. M->B1_MRP <> TRB->B1_MRP .Or. M->B1_DESCNF <> TRB->B1_DESCNF .Or. M->B1_DESCHL <> TRB->B1_DESCHL
			
			If !lFiscal			
			   lAltComPcp := .T.
			Endif    
			
		Endif
		/*
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		Filtra direito de Aletracoes do Grupo Compras
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		If    M->B1_PROC <> TRB->B1_PROC .Or. M->B1_CONTRAT <> TRB->B1_CONTRAT;
			.Or. M->B1_CLVL <> TRB->B1_CLVL .Or. M->B1_QE <> TRB->B1_QE .Or. M->B1_EMIN <> TRB->B1_EMIN;
			.Or. M->B1_FORPRZ <> TRB->B1_FORPRZ .Or. M->B1_TIPE <> TRB->B1_TIPE .Or. M->B1_LM <> TRB->B1_LM;
			.Or. M->B1_PRVALID <> TRB->B1_PRVALID .Or. M->B1_IMPORT <> TRB->B1_IMPORT ;
 			.Or. M->B1_ESTSEG <> TRB->B1_ESTSEG .Or. M->B1_PE <> TRB->B1_PE;
			.Or. M->B1_LE <> TRB->B1_LE .Or. M->B1_TOLER <> TRB->B1_TOLER .Or. M->B1_DIAANT <> TRB->B1_DIAANT;
			.Or. M->B1_FABRIC <> TRB->B1_FABRIC
			
			lAltComp := .T.
		Endif
		/*
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		Filtra direito de Aletracoes do Grupo PCP
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		If M->B1_UM <> TRB->B1_UM .Or. M->B1_MSBLQL <> TRB->B1_MSBLQL .Or. M->B1_PESO <> TRB->B1_PESO;		
			.Or. M->B1_RASTRO <> TRB->B1_RASTRO .Or. M->B1_MRP <> TRB->B1_MRP .Or. M->B1_TIPCONV <> TRB->B1_TIPCONV;
			.Or. M->B1_TIPO <> TRB->B1_TIPO .Or. M->B1_GRUPO <> TRB->B1_GRUPO .Or. M->B1_SEGUM <> TRB->B1_SEGUM;
			.Or. M->B1_PRV1 <> TRB->B1_PRV1 .Or. M->B1_FANTASM <> TRB->B1_FANTASM .Or. M->B1_APROPRI <> TRB->B1_APROPRI;
			.Or. M->B1_CONV <> TRB->B1_CONV
			
			lAltPcp := .T.
		Endif
		/*
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		Filtra direito de Aletracoes do Grupo Fiscal
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		If M->B1_TE <> TRB->B1_TE .Or. M->B1_TS <> TRB->B1_TS;
 			.Or. M->B1_IPI <> TRB->B1_IPI .Or. M->B1_ORIGEM <> TRB->B1_ORIGEM;
			.Or. M->B1_PCOFINS <> TRB->B1_PCOFINS .Or. M->B1_PIS <> TRB->B1_PIS .Or. M->B1_COFINS <> TRB->B1_COFINS;
			.Or. M->B1_CC <> TRB->B1_CC .Or. M->B1_FORAEST <> TRB->B1_FORAEST .Or. M->B1_PICM <> TRB->B1_PICM;
			.Or. M->B1_ALIQISS <> TRB->B1_ALIQISS .Or. M->B1_REDPIS <> TRB->B1_REDPIS .Or. M->B1_RETOPER <> TRB->B1_RETOPER
			
			lAltFis := .T.
		Endif
		/*
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		Filtra direito de Aletracoes do Grupo Almoxarifado
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/  
		If M->B1_LOCPAD <> TRB->B1_LOCPAD .Or. M->B1_USAFEFO <> TRB->B1_USAFEFO .Or. M->B1_ZZIMPET <> TRB->B1_ZZIMPET;
			.Or. M->B1_LOCALIZ <> TRB->B1_LOCALIZ .Or. M->B1_EMAX <> TRB->B1_EMAX
			
			lAltAlm := .T.
		Endif
		/*
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		Filtra direito de Aletracoes do Grupo Contabilidade
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		If M->B1_CONTA <> TRB->B1_CONTA
			lAltCtb := .T.
		Endif

		/*
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³     Conferi se o usuario pode alterar o campo com restricao               ³±±
		±±³     Desenvolvimento: Leandro do Nascimento - Data: 13/09/2013	          ³±±
		±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		*/
		
		If !lAdmin //Se for Administrador ou usuario master do cadastro nao Realiza Validacoes
			If lAltCtb
				If !lContabilidade
					cLog += " Usuário Sem Permissão para alterar informações Contábeis" +cPula
					lBloq := .T.
				Endif
			Endif
			
			If lAltComp
				If !lCompras
					cLog += " Usuário Sem Permissão para alterar informações de Compras" +cPula
					lBloq := .T.
				Endif
			Endif
			
			If lAltFis
				If !lFiscal
					cLog += " Usuário Sem Permissão para alterar informações Fiscais"	+cPula
					lBloq := .T.
				Endif
			Endif
			
			If lAltPcp
				If !lPcp
					cLog += " Usuário Sem Permissão para alterar informações de PCP" +cPula
					lBloq := .T.
				Endif
			Endif
			
			If lAltComPcp
				If !(lPcp .Or. lCompras)
					cLog += " Usuário Sem Permissão para alterar informações de Compras e/ou PCP" +cPula
					lBloq := .T.
				Endif
			Endif  
 
			Endif 
		
	Endif
Endif
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³     Verifica se possui algum campo obrigatorio para o gupo 	              ³±±
±±³ 	Inicia o Processo WorkFlow, ultimo nivel contabilidade desbloqueia o  ³±±
±±³		Produto												                  ³±±
±±³     Desenvolvimento: Leandro do Nascimento - Data: 13/09/2013	          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


If lContabilidade  // Grupo Contabilidade
	If Empty(M->B1_CONTA)
		lBloq := .T.
		cLog += "Campo: Conta Contábil - Obrigatório"+cPula
	Endif
Endif

If lFiscal //Grupo Fiscal
	If Empty(M->B1_POSIPI)
		lBloq := .T.
		cLog += "Campo: POS.IPI/NCM - Obrigatório"+cPula
	Endif
	
	If Empty(M->B1_ORIGEM)
		lBloq := .T.
		cLog += "Campo: Origem - Obrigatório"+cPula
	Endif
		
Endif

If lPcp //Grupo PCP
	If Empty(M->B1_GRUPO)
		lBloq := .T.
		cLog += "Campo: Grupo - Obrigatório"+cPula
	Endif

	//PCP
	If Empty(M->B1_LADO)
		lBloq := .T.
		cLog += "Campo: Lado - Obrigatório"+cPula
	Endif
	
	//PCP
	If Empty(M->B1_DIAANT)
		lBloq := .T.
		cLog += "Campo: Dias Anteced - Obrigatório"+cPula
	Endif  
	
	//RICARDO - EM:08-04-2014
	If Empty(M->B1_COD)
		lBloq := .T.
		cLog += "Campo: Código - Obrigatório"+cPula
	Endif
	
	If Empty(M->B1_DESC)
		lBloq := .T.
		cLog += "Campo: Codigo HLS - Obrigatório"+cPula
	Endif
	
	If Empty(M->B1_DESCHL)
		lBloq := .T.
		cLog += "Campo: Descrição Produto - Obrigatório"+cPula
	Endif
	
	If Empty(M->B1_UM)
		lBloq := .T.
		cLog += "Campo: Unidade de Medida - Obrigatório"+cPula
	Endif
	
	If Empty(M->B1_TIPO)
		lBloq := .T.
		cLog += "Campo: Tipo- Obrigatório"+cPula
	Endif
	
	//PCP-ALMOX
	If Empty(M->B1_LOCPAD)
		lBloq := .T.
		cLog += "Campo: Armazém - Obrigatório"+cPula
	Endif
	
	//If Empty(M->B1_GRUPO)
		//lBloq := .T.
		//cLog += "Campo: Grupo - Obrigatório"+cPula
	//Endif
	
	//FIM RICARDO - EM:08-03-14

Endif

If lCompras //Grupo Compras
    
  	/*
	//PCP
	If Empty(M->B1_LADO)
		lBloq := .T.
		cLog += "Campo: Lado - Obrigatório"+cPula
	Endif
	
	//PCP
	If Empty(M->B1_DIAANT)
		lBloq := .T.
		cLog += "Campo: Dias Anteced - Obrigatório"+cPula
	Endif  
	*/
		
	If Empty(M->B1_COD)
		lBloq := .T.
		cLog += "Campo: Código - Obrigatório"+cPula
	Endif
	
	If Empty(M->B1_DESC)
		lBloq := .T.
		cLog += "Campo: Codigo HLS - Obrigatório"+cPula
	Endif
	
	If Empty(M->B1_DESCHL)
		lBloq := .T.
		cLog += "Campo: Descrição Produto - Obrigatório"+cPula
	Endif
	
	If Empty(M->B1_UM)
		lBloq := .T.
		cLog += "Campo: Unidade de Medida - Obrigatório"+cPula
	Endif
	
	If Empty(M->B1_TIPO)
		lBloq := .T.
		cLog += "Campo: Tipo- Obrigatório"+cPula
	Endif
	
	/*
	//PCP-ALMOX
	If Empty(M->B1_LOCPAD)
		lBloq := .T.
		cLog += "Campo: Armazém - Obrigatório"+cPula
	Endif
	*/
	
	If Empty(M->B1_GRUPO)
		lBloq := .T.
		cLog += "Campo: Grupo - Obrigatório"+cPula
	Endif
	
	/*
	If Empty(M->B1_POSIPI)
		lBloq := .T.
		cLog += "Campo: POS.IPI/NCM - Obrigatório"+cPula
	Endif                                                                 
	
	If Empty(M->B1_ORIGEM)
		lBloq := .T.
		cLog += "Campo: Origem - Obrigatório"+cPula
	Endif		
	*/  
 

Endif

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³     Verifica se existe alguma inconsistencia                              ³±±
±±³     Desenvolvimento: Leandro do Nascimento - Data: 13/09/2013	          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

If lBloq

	AVISO("Problema", "As seguintes inconsistencias foram encontradas: "+cPula+cPula+cLog,{"Ok"},,,,"CRITICA")
	lLibera := .F.

ElseIf lUtilizaWF 

	If Altera 

		If !lContabilidade  .and. !lAdmin  
				
		   If lFiscal .And. TRB->B1_MSBLQL = "2"
		   		   		      
		      If Aviso('Atencao', 'Este Produto deve entrar no Processo de Worflow?', {'Sim', 'Nao'}) == 2
			  	 
			  	 lLibera := .T.
			  	 Return(.T.)		    
			  	 
			  Else
				//RMMB - 07.02.14
				
				 If TRB->B1_MSBLQL == "2"
					 If Aviso('Atencao', 'Se Confirmar a alteração o Produto será Bloqueado.'+cPula+'Necessitando realizar os fluxos do WorkFlow para liberação.'+cPula+'Deseja Continuar?', {'Sim', 'Nao'}) == 2
						lLibera := .F.
						Return(.F.)
					 Endif
				 Endif   
			//	 Endif 
				 
				 If !lAtualizaWF
					 /*
					 M->B1_MSBLQL := "1"
					 M->B1_ZZIDWF := cId
					 If lCompras
					 M->B1_ZZNIVWF := "3" //Pcp
					 Else
					 M->B1_ZZNIVWF := "2" //Pcp
					 Endif
					 */
					 //Atualização MVC - Guilherme Ricci - TOTVS IP - 21/05/2018 - Pendente criação MATA010_PE
					 M->B1_MSBLQL := "1"
					 //oModelB1:SetValue("B1_MSBLQL", "1")
					 lNovoProcesso := .T.
					 MSAguarde({|| WFPROD()}, "Atualizando Processo WorkFlow... Aguarde!",,.F.)
				 Else
				 
					 If M->B1_ZZNIVWF <> "5"
						 If Aviso('WorkFlow', 'O Produto: '+Alltrim(M->B1_COD)+' - '+Alltrim(M->B1_DESC)+cPula+'Está em processo Workflow,'+cPula+' se confirmar, o próximo fluxo de liberação será inciado!', {'Confirma', 'Cancela'}) == 1
						 	MSAguarde({|| WFPROD()}, "Atualizando Processo WorkFlow... Aguarde!",,.F.)
						 Else
						 	Return(.F.)
				 	 	 EndIf
				  	 Else
						MSAguarde({|| WFPROD()}, "Atualizando Processo WorkFlow... Aguarde!",,.F.)
				 	 Endif
				 	 
				 Endif				
				//RMMB - 07.02.14
			  
			  Endif	 
			  
		   Else
		   
			 If TRB->B1_MSBLQL == "2"
				 If Aviso('Atencao', 'Se Confirmar a alteração o Produto será Bloqueado.'+cPula+'Necessitando realizar os fluxos do WorkFlow para liberação.'+cPula+'Deseja Continuar?', {'Sim', 'Nao'}) == 2
					lLibera := .F.
					Return(.F.)
				 Endif
			 Endif    
			 
			 If !lAtualizaWF
				 /*
				 M->B1_MSBLQL := "1"
				 M->B1_ZZIDWF := cId
				 If lCompras
				 M->B1_ZZNIVWF := "3" //Pcp
				 Else
				 M->B1_ZZNIVWF := "2" //Pcp
				 Endif
				 */
				 //Atualização MVC - Guilherme Ricci - TOTVS IP - 21/05/2018 - Pendente criação MATA010_PE
				 M->B1_MSBLQL := "1"
				 //oModelB1:SetValue("B1_MSBLQL", "1")
				 lNovoProcesso := .T.
				 MSAguarde({|| WFPROD()}, "Atualizando Processo WorkFlow... Aguarde!",,.F.)
			 Else
				 If M->B1_ZZNIVWF <> "5"
					 If Aviso('WorkFlow', 'O Produto: '+Alltrim(M->B1_COD)+' - '+Alltrim(M->B1_DESC)+cPula+'Está em processo Workflow,'+cPula+' se confirmar, o próximo fluxo de liberação será inciado!', {'Confirma', 'Cancela'}) == 1
					 	MSAguarde({|| WFPROD()}, "Atualizando Processo WorkFlow... Aguarde!",,.F.)
					 Else
					 	Return(.F.)
			 	 	 EndIf
			  	 Else
					MSAguarde({|| WFPROD()}, "Atualizando Processo WorkFlow... Aguarde!",,.F.)
			 	 Endif
			 Endif
		  Endif
		Endif
	ElseIf Inclui
		If Aviso('Atencao', 'Se Confirmar a inclusão o Produto será Bloqueado.'+cPula+'Iniciando os fluxos do WorkFlow para liberação.'+cPula+'Deseja Continuar?', {'Sim', 'Nao'}) == 1
			//Atualização MVC - Guilherme Ricci - TOTVS IP - 21/05/2018 - Pendente criação MATA010_PE
			M->B1_MSBLQL := "1"
			//oModelB1:SetValue("B1_MSBLQL", "1")
			
			lNovoProcesso := .T.
			MSAguarde({|| WFPROD()}, "Atualizando Processo WorkFlow... Aguarde!",,.F.)
		Else
			Return(.F.)
		Endif
	Endif
Else
	lLibera := .T.
Endif

If lUtilizaWF
	
	//Ultimo STEP do WorkFlow ou Usuarios Adminsitradores/Master do cadastro pergunta se ocorrera a liberacao
	If M->B1_MSBLQL <> "2" .And. !lBloq
		If (M->B1_ZZNIVWF == "5" .And. lContabilidade) .Or. lAdmin
			If Aviso('WorkFlow', 'Deseja realizar o desbloqueio deste produto?', {'Sim', 'Nao'}) == 1
				//Atualização MVC - Guilherme Ricci - TOTVS IP - 21/05/2018 - Pendente criação MATA010_PE
				M->B1_MSBLQL := "2"
				//oModelB1:SetValue("B1_MSBLQL", "2")
				
				lAtualizaWF := .T.
				MSAguarde({|| WFPROD()}, "Atualizando Processo WorkFlow... Aguarde!",,.F.)
				MSAguarde({|| NotSolicitante(M->B1_ZZIDWF)}, "Notificando Liberação do Produtos... Aguarde!",,.F.)
				If M->B1_ZZNIVWF <> "5" .And. lAdmin //Verifica se concluiu STEPs ou foi Liberacao Manual
					//Atualização MVC - Guilherme Ricci - TOTVS IP - 21/05/2018 - Pendente criação MATA010_PE
					M->B1_ZZNIVWF := "7" //Liberacao Manual
					//oModelB1:SetValue("B1_ZZNIVWF", "7")
					
					lLiberaManual := .T.
					MSAguarde({|| WFPROD()}, "Atualizando Processo WorkFlow... Aguarde!",,.F.)
				Else
					//Atualização MVC - Guilherme Ricci - TOTVS IP - 21/05/2018 - Pendente criação MATA010_PE
					M->B1_ZZNIVWF := "6" //Concluido
					//oModelB1:SetValue("B1_ZZNIVWF", "6")
				Endif
			Endif
		Endif
	Endif
	
Endif

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³     Faz atualizacoes na Estrutura do Produto                              ³±±
±±³     Desenvolvimento: Leandro do Nascimento - Data: 13/09/2013	          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

If lLibera
	
	DbSelectArea("SG1")
	DbSetOrder(2)
	DbSeek(xFilial("SG1")+xCOD,.F.)
	//
	Do While xCOD == SG1->G1_COMP .And. SG1->(!Eof())
		//
		RecLock("SG1",.F.)
		Replace G1_OBSERV WITH  "IMPORTADO - "+ SB1->B1_FABRIC
		MsUnLock("SG1")
		//
		SG1->(DbSkip())
	EndDo
	//
Endif

RestArea(aArea)

Return(lLibera)

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³     WFPROD - Atualiza WorkFlow de Produtos						          ³±±
±±³     Desenvolvimento: Leandro do Nascimento - Data: 13/09/2013	          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function WFPROD()

Local cNivel := ""
Local cDataA := Substring(dtos(date()),7,2)+"/"+Substring(dtos(date()),5,2)+"/"+Substring(dtos(date()),1,4)
Local cStatus := ""
Local cProxNivel := Alltrim((Str(Val(cNivelZB1)+1)))
Local cNivelSB1 := ""
Local i := 0 			//ADD LUCIANO LAMBERTI - 19-09-2022



/*************************************************
Localiza Processos WF em andamento para o Produto
**************************************************/

If lEncerraProcesso
	
	DbSelectArea("ZB1")
	DbSetOrder(4)
	DbSeek(xFilial("ZB1")+TRB->B1_ZZIDWF,.F.)
	
	Do While ZB1->ZB1_COD ==M->B1_COD .And. Alltrim(TRB->B1_ZZIDWF) = Alltrim(ZB1->ZB1_PROCES) .And. ZB1->(!Eof())
		IF  !ZB1->ZB1_STATUS $ ("3|4|") //Concluido ou Bloqueado
			RecLock ("ZB1", .F.)
			ZB1->ZB1_STATUS	:= "4" //Encerrado
			ZB1->ZB1_END	:= cCodUsr
			ZB1->ZB1_DTEND	:= dDataBase
			ZB1->ZB1_HREND	:= time()
			ZB1->ZB1_OBS	:= "Processo Encerrado - Data: "+cDataA+" Hora: "+time()+ " Usuário: "+Alltrim(cNomeUsr)
			MsUnlock ()
		Endif
		DbSkip()
	EndDo
	
Endif

/**********************************************
Caso seja novo Processo inclui todos os niveis
**********************************************/

If lNovoProcesso
	For i := 1 to 4
		Iif (i = 1,cNivel := "1" ,cNivel := cNivel) //Compras
		Iif (i = 2,cNivel := "2" ,cNivel := cNivel) //PCP
		Iif (i = 3,cNivel := "3" ,cNivel := cNivel) //Fiscal
		Iif (i = 4,cNivel := "4" ,cNivel := cNivel) //Contabilidade
		
/*		//Realiza Bloqueio do Grupo de quem incluiu o Cadastro
		If cNivel == "1" .And. lCompras
			cStatus := "4"
		ElseIf cNivel == "2" .And. lPcp
			cStatus := "4"
		ElseIf cNivel == "3" .And. lFiscal
			cStatus := "4"
		ElseIf cNivel == "4" .And. lContabilidade
			cStatus := "4"
		Else
			cStatus := Iif (cNivel = "1","2" ,"1")
		Endif*/
		
		//Realiza Bloqueio do Grupo de quem incluiu o Cadastro
		If cNivel == "1" .And. lCompras
			cStatus := "4"
			cObs	:= "Processo Iniciado - Data: "+cDataA+" Hora: "+time()+ " Usuário: "+Alltrim(cNomeUsr)
		ElseIf cNivel == "2" .And. lPcp
			cStatus := "4"
			cObs	:= "Processo Iniciado - Data: "+cDataA+" Hora: "+time()+ " Usuário: "+Alltrim(cNomeUsr)
		ElseIf cNivel == "3" .And. lFiscal
			cStatus := "4"
			cObs	:= "Processo Iniciado - Data: "+cDataA+" Hora: "+time()+ " Usuário: "+Alltrim(cNomeUsr)
		ElseIf cNivel == "4" .And. lContabilidade
			cStatus := "4"
			cObs	:= "Processo Iniciado - Data: "+cDataA+" Hora: "+time()+ " Usuário: "+Alltrim(cNomeUsr)
		Else
			cStatus := Iif (cNivel = "1","2" ,"1")
		Endif
		
		If cNivel == "2" .And. !lPcp
		   If !M->B1_TIPO $ ("MP|PI|PA")
		   cStatus  := "4"
		   cObs 	:= "Processo Bloqueado - Tipo "+Alltrim(M->B1_TIPO)+" não necessita classificação PCP"
		   Endif
		Endif		
		
		RecLock ("ZB1", .T.)
		ZB1->ZB1_FILIAL	:= xFilial("ZB1")
		ZB1->ZB1_COD 	:= M->B1_COD
		ZB1->ZB1_DESC	:= M->B1_DESC
		ZB1->ZB1_STATUS	:= cStatus
		ZB1->ZB1_START	:= cCodUsr
		ZB1->ZB1_PROCES	:= cId
		ZB1->ZB1_NIVEL	:= cNivel
		ZB1->ZB1_DATA	:= dDataBase
		ZB1->ZB1_HORA	:= Time()
		
		If cStatus == "4"
			ZB1->ZB1_OBS	:= cObs
			ZB1->ZB1_END	:= cCodUsr
			ZB1->ZB1_DTEND	:= dDataBase
			ZB1->ZB1_HREND	:= time()
		Endif
		MsUnlock ()
	Next i
	
	//Atualização MVC - Guilherme Ricci - TOTVS IP - 21/05/2018 - Pendente criação MATA010_PE
	M->B1_ZZUSRWF	:= cCodUsr
	M->B1_ZZIDWF 	:= cId
	
	//oModelB1:SetValue("B1_ZZUSRWF", cCodUsr)
	//oModelB1:SetValue("B1_ZZIDWF", cID)	
	
	lAtualizaWF 	:= .T.
Endif

/**********************************************
Atualiza Nivel atual e inicia o Proximo Nivel do WF
**********************************************/

If lAtualizaWF
	DbSelectArea("ZB1")
	DbSetOrder(4)
	DbSeek(xFilial("ZB1")+M->B1_ZZIDWF,.F.)
	
	Do While ZB1->ZB1_COD = M->B1_COD .And. Alltrim(M->B1_ZZIDWF) = Alltrim(ZB1->ZB1_PROCES) .And. ZB1->(!Eof())
		IF  ZB1->ZB1_STATUS == "2" .And. ZB1->ZB1_NIVEL = cNivelZB1
			RecLock ("ZB1", .F.)
			ZB1->ZB1_STATUS	:= "3" //Concluido
			ZB1->ZB1_END	:= cCodUsr
			ZB1->ZB1_DTEND	:= dDataBase
			ZB1->ZB1_HREND	:= time()
			ZB1->ZB1_OBS	:= "Processo Concluido - Data: "+cDataA+" Hora: "+time()+ " Usuário: "+Alltrim(cNomeUsr)
			MsUnlock ()
		Endif
		//Torna Proximo Nivel Como Atual
		IF  !ZB1->ZB1_STATUS $ ("3|2") .And. ZB1->ZB1_NIVEL = cProxNivel
			If ZB1->ZB1_STATUS == "4" //Nivel Bloqueado pula para proximo
				cProxNivel := Alltrim(Str(val(cProxNivel)+1))
			Else
				RecLock ("ZB1", .F.)
				ZB1->ZB1_STATUS	:= "2" //Nivel Atual
				MsUnlock ()
				
				Iif(ZB1->ZB1_NIVEL == "1", cNivelSB1 := "2",cNivelSB1 )
				Iif(ZB1->ZB1_NIVEL == "2", cNivelSB1 := "3",cNivelSB1 )
				Iif(ZB1->ZB1_NIVEL == "3", cNivelSB1 := "4",cNivelSB1 )
				Iif(ZB1->ZB1_NIVEL == "4", cNivelSB1 := "5",cNivelSB1 )
			Endif
		Endif
		DbSkip()
	EndDo
	
	//Atualização MVC - Guilherme Ricci - TOTVS IP - 21/05/2018 - Pendente criação MATA010_PE
	M->B1_ZZNIVWF 	:= Iif(Empty(cNivelSB1),"2",cNivelSB1)
	//oModelB1:SetValue("B1_ZZNIVWF", Iif(Empty(cNivelSB1),"2",cNivelSB1))
	
Endif

/**********************************************
Caso ocorra Processo de Liberação Manual, sem passar pelo Processo WF
**********************************************/

If lLiberaManual
	DbSelectArea("ZB1")
	DbSetOrder(2)
	DbSeek(xFilial("ZB1")+M->B1_COD+TRB->B1_ZZIDWF,.F.)
	
	Do While ZB1->ZB1_COD == M->B1_COD .And. ZB1->(!Eof()) .And. TRB->B1_ZZIDWF = ZB1->ZB1_PROCES
		IF  !ZB1->ZB1_STATUS $ ("3|4|")
			RecLock ("ZB1", .F.)
			ZB1->ZB1_STATUS	:= "4" //Encerrado
			ZB1->ZB1_OBS	:= "Processo Liberado Manualmente - Data: "+cDataA+" Hora: "+time()+ " Usuário: "+Alltrim(cNomeUsr)
			MsUnlock ()
		Endif
		DbSkip()
	EndDo
Endif

Return()

Static Function NotSolicitante(cId)
Local cPula    	:= CHR(13) + CHR(10)

cAssunto := "Workflow de Produtos [CONCLUÍDO] - "+Alltrim(M->B1_COD)+" - "+Alltrim(M->B1_DESC)
cDestino := UsrRetMail(Alltrim(M->B1_ZZUSRWF))

cMensagem := " <font size='2'>  Prezado Sr(a). "+Alltrim(UsrFullName(Alltrim(M->B1_ZZUSRWF)))+",  </font> "+cPula+cPula
cMensagem += " <font size='2'> O fluxo do processo Workflow do produto foi concluído, </font> "+cPula
cMensagem += " <font size='2'>  verifique abaixo o histórico das liberações: </font> " +cPula+cPula
cMensagem += " <b> <font size='2'> Códgo: </b>"+Alltrim(M->B1_COD)+"</font> "+cPula
cMensagem += " <b> <font size='2'> Descrição: </b>"+Alltrim(M->B1_DESC)+"</font> "+cPula+cPula
cMensagem += " <table border=1 bgcolor='LightGray'>"
cMensagem += " <tr> "
cMensagem += " <td> <font size='2'>  <b> Nível </font> </b> </td>   "
cMensagem += " <td> <font size='2'>  <b> Comentário </font> </b> </td> "
cMensagem += " </tr> "

fConsSQLHist(cId)

dbSelectArea("TRH")
dbGoTop()
While !TRH->(Eof())
	cMensagem +=  "<tr> "
	cMensagem +=  " <td> <font size='2'> "+Alltrim(TRH->ZB1_NIVEL)+" </font> </td> "
	cMensagem +=  " <td> <font size='2'> "+Alltrim(TRH->ZB1_OBS)+" </font> </td> "
	cMensagem +=  "</tr> "
	TRH->(DbSkip())
Enddo

cMensagem +=  "</table> "
cMensagem += cPula

MonitMail( cAssunto, cMensagem, cDestino )

dbCloseArea("TRH")

Return()


/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³    Funcao para enviar e-mail as pessoas do proximo nivel e status ao	  ³±±
±±³		solicitante do produto 											      ³±±
±±³     Desenvolvimento: Leandro do Nascimento - Data: 13/09/2013	          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MonitMail( cAssunto, cMensagem, cDestino )

Local cMailServer := GETMV("MV_RELSERV")
Local cMailContX  := GETMV("MV_RELACNT")
Local cMailSenha  := GETMV("MV_RELAPSW")
Local cMailDest   := Alltrim(cDestino)
Local lConnect    := .f.
Local lEnv        := .f.
Local lFim        := .f.

CONNECT SMTP SERVER cMailServer ACCOUNT cMailContX PASSWORD cMailSenha RESULT lConnect

IF GetMv("MV_RELAUTH")
	MailAuth( cMailContX, cMailSenha )
EndIF

If (lConnect)  // testa se a conexão foi feita com sucesso
	SEND MAIL FROM cMailContX TO cMailDest SUBJECT cAssunto BODY cMensagem RESULT lEnv
Endif

If ! lEnv
	GET MAIL ERROR cErro
EndIf

DISCONNECT SMTP SERVER RESULT lFim


Return(nil)


Static Function fConsSQLHist(cIdwf)


cQryHist := "SELECT 	"
cQryHist += "	ZB1_PROCES, ZB1_OBS, 	"
cQryHist += "	CASE ZB1_NIVEL 	"
cQryHist += "		WHEN '1' THEN 'Compras' 	"
cQryHist += "		WHEN '2' THEN 'Pcp' 	"
cQryHist += "		WHEN '3' THEN 'Fiscal'   "
cQryHist += "		WHEN '4' THEN 'Contabilidade' END ZB1_NIVEL"
cQryHist += " FROM 	"
cQryHist += "	"+RetSqlName('ZB1')+ " ZB1 "
cQryHist += "WHERE 	 "
cQryHist += "	ZB1_PROCES = '"+Alltrim(cIdwf)+"'	 "
cQryHist += "	AND ZB1.D_E_L_E_T_ = ''	 "
cQryHist += "ORDER BY 	"
cQryHist += "	ZB1.R_E_C_N_O_"

If Select("TRH") > 0
	dbSelectArea("TRH")
	dbCloseArea("TRH")
Endif

MPSysOpenQuery( cQryHist, "TRH" ) // dbUseArea( .T., "TOPCONN", TCGenQry(,,cQryHist), "TRH", .F., .F. )

Return()
