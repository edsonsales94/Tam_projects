//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "rwmake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RMATR780.CH"
#INCLUDE "PRTOPDEF.CH"
#Include "FileIO.ch"

/*/
/*/
USER Function HSCHED01()

	Local lAmb := RpcSetEnv('02', '01',,,"FAT")
	Local aArea    := FWGetArea()
	Local cAlias    := GetNextAlias()
	Local nCont := 0
	Private cItem := '0000'

	// RpcSetType(3)

	DbSelectArea('SZX')
	dbSetOrder(1)

	while !SZX->(EOF())

		if select(cAlias) > 0
			(cAlias)->(dbCloseArea())
			cAlias    := GetNextAlias()
		endif

		BeginSql ALIAS cAlias
            select B8_PRODUTO,
				B1_UM,
				B1_DESC,
				B1_LOCPAD,
				B8_SALDO,
				B8_LOCAL,
				B8_LOTECTL,
				B8_DFABRIC,
				DataAtual,
				B8_DTVALID,
				DATEDIFF(DAY, DataAtual, B8_DTVALID)  AS  Dias
			from
				( 
				select B8_PRODUTO,
					B1_UM,
					B1_DESC,
					B1_LOCPAD,
					B8_SALDO,
					B8_LOCAL,
					B8_LOTECTL,
					B8_DFABRIC,
					CONVERT(VARCHAR, GETDATE(), 112)  AS  DataAtual,
					B8_DTVALID
				from SB8020 B8
					INNER JOIN SB1020 B1 ON B1.D_E_L_E_T_='' AND B1_COD=B8_PRODUTO AND B1_TIPO =%EXP:SZX->ZX_TIPO% AND B1_MSBLQL='2'
					INNER JOIN SB2020 B2 ON B2.D_E_L_E_T_='' AND B2_COD=B1_COD AND B2_LOCAL=B8_LOCAL AND B2_LOCAL = %EXP:SZX->ZX_LOCORI% AND B2_QATU > 0
				WHERE B8.D_E_L_E_T_=''
					AND B8_DTVALID > GETDATE()
					AND B8_LOCAL =%EXP:SZX->ZX_LOCORI%
					AND B8_SALDO>0
					AND B8_DFABRIC <> ''
					AND SUBSTRING(B8_DFABRIC,1,4) > '2021' 
				)  as  t
		EndSql

		count to nCont
		PROCESS(cAlias)
		SZX->(DbSkip())
	EndDo

	RestArea(aArea)
Return

/*/{Protheus.doc} process/*/
Static Function process(cAlias)
	
	LOCAL lGravou := .F.
	LOCAL lexcAut := .F.
    Local cDestino := ''
    Local cDest := ''
    Local nx := 0
	Local cNumProc := GetSXENum('SZZ','ZZ_NUMPROC')
    Private CDOCSD3 := ''
	Private cArq := ''
	Private _aProd := {}
    /*  SE A QUANTIDADE DE DIAS QUE FALTA PARA VENCER 
        FOR MENOR OU IGUAL MEU LIMITE DO CADASTRO
        GRAVA E DISPARA EMAIL.
    */
    (cAlias)->(DBGOTOP())
    While !(cAlias)->(Eof())

        // definir o destino correto.
        if (cAlias)->Dias <= 540 .and. (cAlias)->Dias > 450
            cDestino := '11'
        elseif (cAlias)->Dias <= 450 .and. (cAlias)->Dias > 365
            cDestino := '16'
        elseif (cAlias)->Dias <= 365 .and. (cAlias)->Dias > 90
            cDestino := '12'
        elseif (cAlias)->Dias <= 90        
            cDestino := '19'
        else
            cDestino := (cAlias)->B8_LOCAL 
        endif

        // GRAVA O OQUE SERA PROCESSADO, CONFORME DEFINIDOS NAS REGRAS DO CADASTRO DA SZX.
        if (cAlias)->Dias <= SZX->ZX_DIASEXP .AND. (cAlias)->B8_SALDO > 0;
            .and. (cAlias)->B8_LOCAL != cDestino
			CITEM := SOMA1(CITEM)
			lGravou := .T.
			Begin Transaction
			//Iniciando controle de transações
				Reclock('SZZ' , .T.)
				SZZ->ZZ_NUMPROC := cNumProc
				SZZ->ZZ_DTPROC := dDatabase
				SZZ->ZZ_ITEM := CITEM
				SZZ->ZZ_COD := (cAlias)->B8_PRODUTO
				SZZ->ZZ_DESC := (cAlias)->B1_DESC
				SZZ->ZZ_QUANT := (cAlias)->B8_SALDO
				SZZ->ZZ_NUMLOTE := (cAlias)->B8_LOTECTL
				SZZ->ZZ_LOCORI := SZX->ZX_LOCORI
				SZZ->ZZ_TRANSF := SZX->ZX_TRANSF
				SZZ->ZZ_LOCDEST := SZX->ZX_LOCDEST
				SZZ->ZZ_DTVENC := STOD((cAlias)->B8_DTVALID)
				SZZ->ZZ_OBSERV := IIF(SZX->ZX_TRANSF=='S','Traferencia realizada.','Pronto para ser tranferido.')
				SZZ->ZZ_STATUS := IIF(SZX->ZX_TRANSF=='S','1','2')
				SZZ->(msUnLock())
				
				cUn := posicione('SB1',1,XFILIAL('SB1')+SZZ->ZZ_COD,'B1_UM')
				if SZZ->ZZ_STATUS == '1' .AND. SZZ->ZZ_TRANSF == 'S'
					aadd(_aProd,{.T.,SZZ->ZZ_COD,;
						SZZ->ZZ_DESC,;
						cUn,;
						SZZ->ZZ_QUANT,;
						SZZ->ZZ_LOCORI,;
						SZZ->ZZ_LOCDEST,;
						SZZ->ZZ_NUMLOTE,;
						SZZ->ZZ_DTVENC,;
						SZZ->ZZ_OBSERV,;
						iif(SZZ->ZZ_STATUS=='1','Transferido','Aguard. Transferencia')})
				endif
			//Finalizando controle de transações
			End Transaction
        endif
		(cAlias)->(DbSkip())
    EndDo
	
	if !Empty(_aProd)
		lexcAut := u_ExecMT261(_aProd,1)
		
		If !lexcAut
			Begin Transaction
			//Iniciando controle de transações
			// Atualizar a obs caso falhe o execAuto
			cObserv :='Falha na transferencia'

			cQry := " update " + RETSQLNAME("SZZ") + " SET ZZ_OBSERV = '"+cObserv+"' , ZZ_STATUS='2', ZZ_TRANSFE='N' " 
			cQry += " WHERE D_E_L_E_T_='' AND ZZ_NUMPROC= '" +cNumProc +"'"

			//Tenta executar o update
			nErro := TcSqlExec(cQry)
			
			//Se houve erro, mostra a mensagem e cancela a transação
			If nErro != 0
				MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
				DisarmTransaction()
			EndIf
			End Transaction
		Else
			Begin Transaction
			
			cQry := " update " + RETSQLNAME("SZZ") + " SET ZZ_DOCSD3 = '"+cDocSD3+"'" 
			cQry += " WHERE D_E_L_E_T_='' AND ZZ_NUMPROC= '" +cNumProc +"'"
			
			//Tenta executar o update
			nErro := TcSqlExec(cQry)
			//Se houve erro, mostra a mensagem e cancela a transação
			If nErro != 0
				MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
				DisarmTransaction()
			EndIf
			
			//Tenta executar o update
			nErro := TcSqlExec(cQry)

			End Transaction
		endif
	endif

	// cria HTML e disparar o email.
	if lGravou
		cEmail := SZX->ZX_EMAIL
        aUser := {}
        aUser  := StrTokArr(cEmail, ";")
        

        for nx:=1 to len(aUser)
            cDest += substr(aUser[nx],1,at('@',aUser[nx])-1) + iif(nx<len(aUser),', ','') 
        Next
        
    	cBody := fMontaHTML(cDest)
        
		aAnexos := {cArq}
		zEnvMail("Itens de transferencia por data de lote, em regra de vencimento.", cEmail, cBody, aAnexos, .F., .T.,.F.)
		cArq := ''
		aAnexos := {}
	endif

Return

Static Function fMontaHTML(_cDest)
	Local cHtml := ""  
	Local cPath := '\system\lgrl.bmp' 
	
	cImgBase64 := FileToBase64(cPath)
	
	cHtml += ' <!doctype html> '
	cHtml += ' <html lang="pt-br"> '
	cHtml += '   <head> '
	cHtml += '     <meta charset="utf-8" /> '
	cHtml += '     <meta name="viewport" content="width=device-width, initial-scale=1" /> '
	cHtml += '     <meta http-equiv="x-ua-compatible" content="ie=edge" /> '
	cHtml += '     <title>Assunto do E-mail</title> '
	cHtml += '     <!--[if mso]> '
	cHtml += '       <style type="text/css"> '
	cHtml += '         body, table, td, a { font-family: Arial, sans-serif !important; } '
	cHtml += '       </style> '
	cHtml += '     <![endif]--> '
	cHtml += '     <style> '
	cHtml += '       .preheader { display:none !important; visibility:hidden; opacity:0; color:transparent; height:0; width:0; overflow:hidden; mso-hide:all; } '
	cHtml += '       a { text-decoration: none; } '
	cHtml += '     </style> '
	cHtml += '   </head> '
	cHtml += '   <body style="margin:0; padding:0; background-color:#f2f4f7;"> '
	cHtml += '     <div class="preheader">Regra de transferencia por validade do lote.</div> '
	cHtml += '  '
	cHtml += '     <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color:#f2f4f7;"> '
	cHtml += '       <tr> '
	cHtml += '         <td align="center" style="padding:24px 12px;"> '
	cHtml += '  '
	cHtml += '           <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="75" style="width:75; max-width:75; background-color:#ffffff; border-radius:12px; overflow:hidden;"> '
	cHtml += '  '
	cHtml += '             <tr> '
	cHtml += '               <td align="left" style="padding:24px; background-color:#111827; color:#ffffff; font-family:Arial, Helvetica, sans-serif;"> '
	cHtml += '                 <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"> '
	cHtml += '                   <tr> '
	cHtml += '                     <td style="font-size:20px; font-weight:bold;"><img width="100" src="data:image/bmp;base64,' + cImgBase64 + '" alt="" srcset=""></td> '
	cHtml += '                     <td align="right" style="font-size:12px; opacity:0.9;">#12345</td> '
	cHtml += '                   </tr> '
	cHtml += '                 </table> '
	cHtml += '               </td> '
	cHtml += '             </tr> '
	cHtml += '  '
	cHtml += '             <tr> '
	cHtml += '               <td align="left" style="padding:24px; font-family:Arial, Helvetica, sans-serif; color:#111827;"> '
	cHtml += '                 <h1 style="margin:0 0 8px 0; font-size:24px; line-height:1.3;">Controle de Lote.</h1> '
	cHtml += '                 <h2 style="margin:0 0 8px 0; font-size:24px; line-height:1.3;">Itens c/ '+cValToChar(SZX->ZX_DIASEXP)+' dias p/ Vencimento.</h2> '
	cHtml += '                 <p style="margin:0; font-size:14px; line-height:1.6; color:#4b5563;">Execução da rotina de controle de lote para acompanhamento desse processo, indicando os itens envolvidos e a ação de movimentação que pode ou não ter sido efetuada, dependendo da configuração definida na rotina de cadastro de controle de lote.</p> '
	cHtml += '               </td> '
	cHtml += '             </tr> '
	cHtml += '  '
	cHtml += '             <!-- Tabela substituindo o trecho anterior --> '
	cHtml += '             <tr> '
	cHtml += '               <td style="padding:12px 24px; font-size:14px; line-height:1.7; color:#374151; font-family:Arial, Helvetica, sans-serif;"> '
	cHtml += '                 <p style="margin:0 0 12px 0;">Olá, <strong>'+_cDest+'</strong>,</p> '
	cHtml += '                 <p style="margin:0 0 12px 0;">Segue abaixo tabela com dados processados:</p> '
	cHtml += '  '
	cHtml += '                 <table cellpadding="6" cellspacing="0" border="1" width="100%" style="border-collapse:collapse; font-size:13px; color:#111827; border:1px solid #d1d5db;"> '
	cHtml += '                   <thead style="background-color:#f3f4f6; font-weight:bold; text-align:left;"> '
	cHtml += '                     <tr> '
	cHtml += '                       <th width="10%">Codigo</th> '		
	cHtml += '                       <th width="30%">Descrição</th> '		
	cHtml += '                       <th width="10%">Quantidade</th> '		
	cHtml += '                       <th width="30%">Unid. Medida</th> '		
	cHtml += '                       <th width="15%">Origem</th> '		
	cHtml += '                       <th width="15%">Destino</th> '		
	cHtml += '                       <th width="15%">Lote</th> '		
	cHtml += '                       <th width="15%">Data Venc.</th> '		
	cHtml += '                       <th width="20%">Observacao</th> '		
	cHtml += '                       <th width="20%">Status</th> '		
	cHtml += '                     </tr> '
	cHtml += '                   </thead> '

	// produto
	dbSelectArea("SZZ") 
	dbSetOrder(1)
	SZZ->(dbSeek(xFilial("SZZ")+SZZ->ZZ_NUMPROC))
	cNumProc := SZZ->ZZ_NUMPROC

	While !SZZ->(Eof()) .and. cNumProc == SZZ->ZZ_NUMPROC //.AND. SZO->ZO_DOC == SZP->ZP_DOC .AND. SZO->ZO_SERIE == SZP->ZP_SERIE .AND. SZO->ZO_FORNECE == SZP->ZP_FORNECE .AND. SZO->ZO_LOJA == SZP->ZP_LOJA
		
		cUn := posicione('SB1',1,XFILIAL('SB1')+SZZ->ZZ_COD,'B1_UM')
		
		cHtml += '                   <tbody> '
		cHtml += '                     <tr> '
		cHtml += '                       <td>'+alltrim(SZZ->ZZ_COD)+'</td> '
		cHtml += '                       <td>'+alltrim(SZZ->ZZ_DESC)+'</td> '
		cHtml += '                       <td>'+cvaltochar(SZZ->ZZ_QUANT)+'</td> '
		cHtml += '                       <td>'+alltrim(cUn)+'</td> '
		cHtml += '                       <td>'+alltrim(SZZ->ZZ_LOCORI)+'</td> '
		cHtml += '                       <td>'+alltrim(SZZ->ZZ_LOCDEST)+'</td> '
		cHtml += '                       <td>'+alltrim(SZZ->ZZ_NUMLOTE)+'</td> '
		cHtml += '                       <td>'+alltrim(dToC(SZZ->ZZ_DTVENC))+'</td> '
		cHtml += '                       <td>'+alltrim(SZZ->ZZ_OBSERV)+'</td> '
		cHtml += '                       <td>'+alltrim(iif(SZZ->ZZ_STATUS=='1','Transferido','Aguard. Transferencia'))+'</td> '
		cHtml += '                     </tr> '

		SZZ->(DbSkip())
	EndDo

	cHtml += '                   </tbody> '
	cHtml += '                 </table> '
	cHtml += '  '               

	//  esse trecho é para consumir o excel salvo no servidor via endpoit.

	// cHtml += '                 <p style="margin:16px 0 0 0;">Para exportar os dados:</p> '
	// cHtml += '                 <a href="https://seusistema.com/exportar_excel?id=123"  '
	// cHtml += '                    target="_blank" '
	// cHtml += '                    style="display:inline-block; background-color:#2563eb; color:#ffffff; font-family:Arial, Helvetica, sans-serif; font-size:14px; font-weight:bold; line-height:40px; text-align:center; text-decoration:none; border-radius:6px; width:220px;"> '
	// cHtml += '                   Gerar Excel '
	// cHtml += '                 </a> '

	cHtml += '              </td> '
	cHtml += '            </tr> '
	cHtml += '  '
	cHtml += '             <tr> '
	cHtml += '               <td style="padding:0 24px 24px 24px;"> '
	cHtml += '                 <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0"> '
	cHtml += '                   <tr> '
	cHtml += '                     <td width="50%" valign="top" style="padding:12px; background-color:#f9fafb; border-radius:8px; font-family:Arial, Helvetica, sans-serif; font-size:13px; line-height:1.6; color:#374151;"> '
	cHtml += '                       <strong>Detalhe de movimento</strong> '
	cHtml += '                       <p style="margin:8px 0 0 0;">A Origem é o armazém de saída, Destino o armazém para onde o material foi ou será movimentado</p> '
	cHtml += '                     </td> '
	cHtml += '                     <td width="10" style="font-size:0; line-height:0;">&nbsp;</td> '
	cHtml += '                     <td width="50%" valign="top" style="padding:12px; background-color:#f9fafb; border-radius:8px; font-family:Arial, Helvetica, sans-serif; font-size:13px; line-height:1.6; color:#374151;"> '
	cHtml += '                       <strong>Observação</strong> '
	cHtml += '                       <p style="margin:8px 0 0 0;">Fique atento no status porque ele define se o processo de movimento ocorreu ou não.</p> '
	cHtml += '                     </td> '
	cHtml += '                   </tr> '
	cHtml += '                 </table> '
	cHtml += '               </td> '
	cHtml += '             </tr> '
	cHtml += '  '
	cHtml += '             <tr> '
	cHtml += '               <td align="center" style="padding:20px 24px 28px 24px; font-family:Arial, Helvetica, sans-serif; color:#6b7280; font-size:12px; background-color:#ffffff;"> '
	cHtml += '                 <p style="margin:0 0 8px 0;">Este email foi envido pelo sistema, por favor não responder.</em>.</p> '
	cHtml += '                 <p style="margin:0;"> '
	cHtml += '                   <p style="color:#2563eb;">Consulte o sistema em caso de inconformidades -</p> · '
	cHtml += '                   <p style="color:#2563eb;">ou contate a gestão responsável.</p> · '
	cHtml += '                 </p> '
	cHtml += '                 <p style="margin:8px 0 0 0;">Rua Exemplo, 123 — Sua Cidade/UF — 00000-000</p> '
	cHtml += '               </td> '
	cHtml += '             </tr> '
	cHtml += '  '
	cHtml += '           </table> '
	cHtml += '  '
	cHtml += '           <div style="line-height:24px; height:24px;">&nbsp;</div> '
	cHtml += '         </td> '
	cHtml += '       </tr> '
	cHtml += '     </table> '
	cHtml += '   </body> '
	cHtml += ' </html> '

	cArq := fGravExc(_aProd)

Return cHtml

Static Function FileToBase64(cPath)
    Local nHandle := 0
    Local nChunk  := 8192          // tamanho do bloco de leitura (8KB)
    Local cBuffer := ""            // vai acumular os dados do arquivo
    Local cPart   := Space(nChunk) // buffer temporário
    Local nRead   := 0
    Local cBase64 := ""

    // Verifica se o arquivo existe
    If !File(cPath)
        conout("Arquivo não encontrado: " + cPath)
        Return ""
    EndIf

    // Abre o arquivo
    nHandle := FOpen(cPath)
    If nHandle < 0
        conout("Não foi possível abrir o arquivo: " + cPath)
        Return ""
    EndIf

    // Lê em blocos
    FSeek(nHandle, 0, 0) // início
    While ( (nRead := FRead(nHandle, @cPart, nChunk)) > 0 )
        cBuffer += SubStr(cPart, 1, nRead)
    End While
    FClose(nHandle)

    // Converte para Base64
    cBase64 := Encode64(cBuffer)

Return cBase64     



User Function ExecMT261(aProduto,nOper) // 1 - incluir // 2 estornar - transferencia
Local aAuto := {}
Local aItem := {}
Local aLinha := {}
/*
É necessario que:
O parametro MV_LOCALIZ = S
O produto com codigo PA001 tenha controle de endereco ativo
O armazem padrao definido no produto deve ter 2 endereços: ENDER01 e ENDER02
Saldo inicial igual ou superior a 1
E este saldo deve ser enderecçado ao ENDER01
*/
Local nX
Local nOpcAuto := 0
Local cDocumen := ""
Local lContinua := .T.
Private lMsErroAuto := .F.

// PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST" TABLES "SB1", "SD3"
conout("inclusão de movimentação multipla")


//Itens a Incluir
aItem := {}

if nOper == 1
	//Cabecalho a Incluir
	cDocumen := GetSxeNum("SD3","D3_DOC")
	aadd(aAuto,{cDocumen,dDataBase}) //Cabecalho

	for nX := 1 to len(aProduto) 
		aLinha := {}
		//Origem
		aadd(aLinha,{"ITEM",'00'+cvaltochar(nX),Nil})
		aadd(aLinha,{"D3_COD", aProduto[nX,2], Nil}) //Cod Produto origem
		aadd(aLinha,{"D3_DESCRI", aProduto[nX,3], Nil}) //descr produto origem
		aadd(aLinha,{"D3_UM", aProduto[nX,4], Nil}) //unidade medida origem
		aadd(aLinha,{"D3_LOCAL", aProduto[nX,6], Nil}) //armazem origem
		aadd(aLinha,{"D3_LOCALIZ", '',Nil}) //Informar endereÃ§o origem
		
		//Destino
		aadd(aLinha,{"D3_COD", aProduto[nX,2], Nil}) //cod produto destino
		aadd(aLinha,{"D3_DESCRI", aProduto[nX,3], Nil}) //descr produto destino
		aadd(aLinha,{"D3_UM", aProduto[nX,4], Nil}) //unidade medida destino
		aadd(aLinha,{"D3_LOCAL", aProduto[nX,7], Nil}) //armazem destino
		aadd(aLinha,{"D3_LOCALIZ", ''}) //Informar endereÃ§o destino
		
		aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
		aadd(aLinha,{"D3_LOTECTL", aProduto[nX,8], Nil}) //Lote Origem
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
		aadd(aLinha,{"D3_DTVALID", aProduto[nX,9], Nil}) //data validade
		aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
		aadd(aLinha,{"D3_QUANT", aProduto[nX,5], Nil}) //Quantidade
		aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
		aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
		aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ
		
		aadd(aLinha,{"D3_LOTECTL", aProduto[nX,8], Nil}) //Lote destino
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
		aadd(aLinha,{"D3_DTVALID", aProduto[nX,9], Nil}) //validade lote destino
		aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
		
		aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
		aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino
		
		aAdd(aAuto,aLinha)

	Next nX

	nOpcAuto := 3 // Inclusao

	MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

	if lMsErroAuto
		MostraErro()
		lContinua := .F.
	else
		//
		cDocSD3 := cDocumen
		conout("Inclusão de movimentação multipla efetuada com sucesso")
		lContinua := .T.
	EndIf

	conout("Finalizado a inclusão de movimentação multipla")

	// RESET ENVIRONMENT
	else // estorno
		
		aAuto := {}
		
		//-- Preenchimento dos campos
		cNumProc := aProduto[1,12]
		aadd(aAuto,{"D3_DOC", aProduto[1,13], Nil})
		aadd(aAuto,{"D3_COD", aProduto[1,2], Nil})
		
		DbSelectArea("SD3")
		DbSetOrder(2)
		DbSeek(xFilial("SD3")+aProduto[1,13])
		
		//-- Teste de Estorno
		nOpcAuto := 6 // Estornar
		MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
		
		If lMsErroAuto
			MostraErro()
		Else
			Begin Transaction

			cObserv :='Aguard. Transferencia'

			cQry := " update " + RETSQLNAME("SZZ") + " SET ZZ_OBSERV = '"+cObserv+"' , ZZ_STATUS='2', ZZ_TRANSF='S' " 
			cQry += " WHERE D_E_L_E_T_='' AND ZZ_NUMPROC= '" +cNumProc +"'"

			//Tenta executar o update
			nErro := TcSqlExec(cQry)
			
			//Se houve erro, mostra a mensagem e cancela a transação
			If nErro != 0
				MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
				DisarmTransaction()
			EndIf
			End Transaction
			conout("Estorno de movimentação multipla efetuada com sucesso")
		EndIf

		conout("Finalizado a estorno de movimentação multipla")
	EndIf

Return lContinua


// //--------------------------------------------------------------------
// //-	   Rotina de envio de Conexão, desconexão e Envio de Email    	-
// //-			Desenvolvida por: Nilson Neto		Data: 29/07					-
// //--------------------------------------------------------------------
// Static Function zEnvMail(cTitulo, cEmail, cMsg, lConecta, lDConecta)
// 	Local cAccount := Rtrim(GetMv("MV_RELACNT"))
// 	Local cServer  := Rtrim(GetMv("MV_RELSERV"))
// 	Local cPass    := Rtrim(GetMv("MV_RELPSW" ))
	
// 	If (lDConecta)
// 		DISCONNECT SMTP SERVER	  
// 		Return Nil
//  	EndIf
// 	If (lConecta)
// 		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult
// 		If lResult
// 		 	If GetMv("MV_RELAUTH")
// 				lRet:= MailAuth(AllTrim(cAccount), AllTrim(cPass)) 
// 		 	Else
// 		 		lRet:= .T.
// 		 	Endif
// 			CONout(iif(lRet, "Servidor de emails autenticado", "Falha na conexao/autenticacao"))
// 			SEND MAIL FROM cAccount;
// 					TO cEmail;
// 					SUBJECT cTitulo ;              
// 					BODY cMsg
// 		Endif 
// 	EndIf     
              
//     ConOut(cTitulo + "- Email enviado para: " + cEmail)
// Return Nil

/*/{Protheus.doc} zEnvMail
Função para disparo do e-mail utilizando TMailMessage e tMailManager com opção de múltiplos anexos
@author Edson Pedro
@since 26/05/2017
@version 1.0
@type function
@param cPara, characters, Destinatário que irá receber o e-Mail
@param cAssunto, characters, Assunto do e-Mail
@param cCorpo, characters, Corpo do e-Mail (com suporte à html)
@param aAnexos, array, Anexos que estarão no e-mail (devem estar na mesma pasta da protheus data)
@param lMostraLog, logical, Define se será mostrado mensagem de log ao usuário (uma tela de aviso)
@param lUsaTLS, logical, Define se irá utilizar o protocolo criptográfico TLS
@return lRet, Retorna se houve falha ou não no disparo do e-Mail
@example Exemplos:
-----
1 - Mensagem Simples de envio
u_zEnvMail("teste@servidor.com.br", "Teste", "Teste TMailMessage - Protheus", , .T.)
-----
2 - Mensagem com anexos (devem estar dentro da Protheus Data)
aAnexos := {}
aAdd(aAnexos, "\pasta\arquivo1.pdf")
aAdd(aAnexos, "\pasta\arquivo2.pdf")
aAdd(aAnexos, "\pasta\arquivo3.pdf")
@obs Deve-se configurar os parâmetros:
* MV_RELACNT - Conta de login do e-Mail    - Ex.: email@servidor.com.br
* MV_RELPSW  - Senha de login do e-Mail    - Ex.: senha
* MV_RELSERV - Servidor SMTP do e-Mail     - Ex.: smtp.servidor.com.br:587
* MV_RELTIME - TimeOut do e-Mail           - Ex.: 120
/*/
Static Function zEnvMail(cAssunto, cPara, cCorpo, aAnexos, lMostraLog, lUsaTLS, lNovo)
	Local aArea        := GetArea()
	Local nAtual       := 0
	Local lRet         := .T.
	Local oMsg         := Nil
	Local oSrv         := Nil
	Local nRet         := 0
	Local cFrom        := Alltrim(GetMV("MV_RELACNT"))
	Local cUser        := SubStr(cFrom, 1, At('@', cFrom)-1)
	Local cPass        := Alltrim(GetMV("MV_RELPSW"))
	Local cSrvFull     := Alltrim(GetMV("MV_RELSERV"))
	Local cServer      := ""
	Local nPort        := 0
	Local nTimeOut     := GetMV("MV_RELTIME")
	Local cLog         := ""
	Local cContaAuth   := ""
	Local cPassAuth    := ""
	Local nAtu         := 0
	Local cProcessos   := ""
	Default cPara      := ""
	Default cAssunto   := ''
	Default cCorpo     := ''
	Default aAnexos    := {}
	Default lMostraLog := .F.
	Default lUsaTLS    := .T.
	Default lNovo      := .F.
	//Se tiver em branco o destinatário, o assunto ou o corpo do email
	If Empty(cPara) .Or. Empty(cAssunto) .Or. Empty(cCorpo)
		cLog += "001 - Destinatario, Assunto ou Corpo do e-Mail vazio(s)!" + CRLF
		lRet := .F.
	EndIf
	If lRet
		If lNovo
			cContaAuth := Alltrim(GetMV("MV_X_NCNT"))
			cPassAuth  := Alltrim(GetMV("MV_X_NPSW"))
			cSrvFull   := Alltrim(GetMV("MV_X_NSRV"))
		Else
			cContaAuth := cFrom
			cPassAuth  := cPass
		EndIf
		cServer      := Iif(':' $ cSrvFull, SubStr(cSrvFull, 1, At(':', cSrvFull)-1), cSrvFull)
		nPort        := Iif(':' $ cSrvFull, Val(SubStr(cSrvFull, At(':', cSrvFull)+1, Len(cSrvFull))), 587)
		//Cria a nova mensagem
		oMsg := TMailMessage():New()
		oMsg:Clear()
		//Define os atributos da mensagem
		//oMsg:cDate    := cValToChar(Date())
		oMsg:cFrom    := cFrom
		oMsg:cTo      := cPara
		oMsg:cSubject := cAssunto
		oMsg:cBody    := cCorpo
		//Percorre os anexos
		For nAtual := 1 To Len(aAnexos)
			//Se o arquivo existir
			If File(aAnexos[nAtual])
				//Anexa o arquivo na mensagem de e-Mail
				nRet := oMsg:AttachFile(aAnexos[nAtual])
				If nRet < 0
					cLog += "002 - Nao foi possivel anexar o arquivo '"+aAnexos[nAtual]+"'!" + CRLF
				EndIf
				//Senao, acrescenta no log
			Else
				cLog += "003 - Arquivo '"+aAnexos[nAtual]+"' nao encontrado!" + CRLF
			EndIf
		Next
		//Cria servidor para disparo do e-Mail
		oSrv := tMailManager():New()
		//Define se irá utilizar o TLS
		If lUsaTLS
			oSrv:SetUseTLS(.T.)
		EndIf
		//Inicializa conexão
		nRet := oSrv:Init("", cServer, cUser, cPass, 0, nPort)
		If nRet != 0
			cLog += "004 - Nao foi possivel inicializar o servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
			lRet := .F.
		EndIf
		If lRet
			//Define o time out
			nRet := oSrv:SetSMTPTimeout(nTimeOut)
			If nRet != 0
				cLog += "005 - Nao foi possivel definir o TimeOut '"+cValToChar(nTimeOut)+"'" + CRLF
			EndIf
			//Conecta no servidor
			nRet := oSrv:SMTPConnect()
			If nRet <> 0
				cLog += "006 - Nao foi possivel conectar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
				lRet := .F.
			EndIf
			If lRet
				//Realiza a autenticação do usuário e senha
				nRet := oSrv:SmtpAuth(cContaAuth, cPassAuth)
				If nRet <> 0
					cLog += "007 - Nao foi possivel autenticar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
					lRet := .F.
				EndIf
				If lRet
					//Envia a mensagem
					nRet := oMsg:Send(oSrv)
					If nRet <> 0
						cLog += "008 - Nao foi possivel enviar a mensagem: " + oSrv:GetErrorString(nRet) + CRLF
						lRet := .F.
					EndIf
				EndIf
				//Disconecta do servidor
				nRet := oSrv:SMTPDisconnect()
				If nRet <> 0
					cLog += "009 - Nao foi possivel disconectar do servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
				EndIf
			EndIf
		EndIf
	EndIf
	//Se tiver log de avisos/erros
	If !Empty(cLog)
		//Busca todas as funções
		nAtu := 0
		cProcessos := ""
        /*
        While ! (ProcName(nAtu) == '')
            cProcessos += ProcName(nAtu) + "; "
            nAtu++
        EndDo
        */
		// cLog := "+======================= zEnvMail =======================+" + CRLF + ;
			//     "zEnvMail  - "+dToC(Date())+ " " + Time() + CRLF + ;
			//     "Funcao    - " + FunName() + CRLF + ;
			//     "Processos - " + cProcessos + CRLF + ;
			//     "Para      - " + cPara + CRLF + ;
			//     "Assunto   - " + cAssunto + CRLF + ;
			//     "Corpo     - " + cCorpo + CRLF + ;
			//     "Existem mensagens de aviso: "+ CRLF +;
			//     cLog + CRLF +;
			//     "+======================= zEnvMail =======================+"
		// //ConOut(cLog)
		// //Se for para mostrar o log visualmente e for processo com interface com o usuário, mostra uma mensagem na tela
		// If lMostraLog .And. ! IsBlind()
		//     Aviso("Log", cLog, {"Ok"}, 2)
		// EndIf
	EndIf
	RestArea(aArea)
Return lRet


//Constantes
	#Define STR_PULA    Chr(13)+Chr(10)

/*/{Protheus.doc} fGravExc
Função que cria um exemplo de FWMsExcel
@author Edson sales
@since 14/08/2025
@version 1.0
    @example
    u_fGravExc()
/*/

Static Function fGravExc(aDados)
	Local aArea        := GetArea()
	Local oFWMsExcel
	Local oExcel
	Local cArquivo    := '\SYSTEM\fGravExc.xls'
	Local nx := 0

	//Criando o objeto que irá gerar o conteúdo do Excel
	oFWMsExcel := FWMsExcelEx():New()

	cTituloExc := 'Itens processado na regra de transferencia por lote.'
	//Aba 01 - Produtos
	oFWMsExcel:AddworkSheet(cTituloExc)
	//Criando a Tabela
	oFWMsExcel:AddTable(cTituloExc,"Produtos")
	// oFWMsExcel:AddColumn(cTituloExc,"Produtos","Item",1)
	oFWMsExcel:AddColumn(cTituloExc,"Produtos","Codigo",1)
	oFWMsExcel:AddColumn(cTituloExc,"Produtos","Descricao",1)
	oFWMsExcel:AddColumn(cTituloExc,"Produtos","Unid",1)
	oFWMsExcel:AddColumn(cTituloExc,"Produtos","Quantidade",1)
	oFWMsExcel:AddColumn(cTituloExc,"Produtos","origem",1)
	oFWMsExcel:AddColumn(cTituloExc,"Produtos","Destino",1)
	oFWMsExcel:AddColumn(cTituloExc,"Produtos","Lote",1)
	oFWMsExcel:AddColumn(cTituloExc,"Produtos","Data Vencimento",1)
	oFWMsExcel:AddColumn(cTituloExc,"Produtos","Obs",1)
	oFWMsExcel:AddColumn(cTituloExc,"Produtos","Status",1)
	//Criando as Linhas... Enquanto não for fim da query
	for nx := 1 to len(aDados)

		oFWMsExcel:AddRow(cTituloExc,;
			"Produtos",{;
			aDados[nx,2],;
			aDados[nx,3],;
			aDados[nx,4],;
			cvaltochar(aDados[nx,5]),;
			aDados[nx,6],;
			aDados[nx,7],;
			aDados[nx,8],;
			dtoc(aDados[nx,9]),;
			aDados[nx,10],;
			IIF(aDados[nx,11]=='1','Transferido','Aguard. Transferencia');
			})
	next nx

	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	lCriou :=  oFWMsExcel:GetXMLFile(cArquivo)

	if lCriou
		Return cArquivo
	endif

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()            //Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo)      //Abre uma planilha
	// oExcel:SetVisible(.T.)            //Visualiza a planilha
	oExcel:Destroy()                     //Encerra o processo do gerenciador de tarefas


	RestArea(aArea)
Return


