/*---------------------------------------------------------------------------*
 | Data       : 11/02/2026                                                   |
 | Rotina     : PEAPONT                                                      |
 | Responsável: Edson Pedro                                                  |
 | Descrição  : Rotina apontamento de producao automatico                    |
 *---------------------------------------------------------------------------*/

//Bibliotecas
#Include 'Protheus.ch'
#Include 'Protheus.ch'
#include "tbiconn.ch"

User Function PEAPONT()
    Local dData
    Local nOpc := 3 //-Opção de execução da rotina,
    Local cOp := "OP021201001 "
    Local cCod := "000000000000001"
    Local cLocal:= "01"
    Local cAlias:= GetNextAlias()
    Local aVetor := {}
    Local aErros := {}
    Local cPendente := 'P'
    Private lMsErroAuto := .F.

    RPCSETENV('10','01')

    // prepare environment empresa "99" filial "01" modulo "est"
    IF !IsBLind() // não Job
        if ZZJ->ZZJ_STATUS == 'A'
            FWAlertWarning('Etiqueta ja esta apontadado', 'NAO-APONTA')
            Return
        endif

        cEtiq  := ZZJ->ZZJ_CODETI
        cOp  := ZZJ->ZZJ_OP
        cCod := ZZJ->ZZJ_PRODUT
        cLocal :=  Posicione('CB0',1,xFilial('CB0')+ZZJ->ZZJ_CODETI,'CB0_LOCAL')
        nQuant := ZZJ->ZZJ_QUANT

        aadd(aVetor,{"D3_OP" ,cOp,Nil})
        aadd(aVetor,{"D3_COD",cCod,Nil})
        aadd(aVetor,{"D3_QUANT",nQuant,Nil})
        aadd(aVetor,{"D3_TM",'001',nil})   
        aadd(aVetor,{"D3_QTMAIOR",0,Nil})

        dData:=dDataBase
    
        MSExecAuto({|x, y| mata250(x, y)},aVetor, nOpc )

        If lMsErroAuto
            mostraerro()
            CONOUT("Erro")
            RecLock('ZZJ' , .F.)
                ZZJ_STATUS := 'E'
            ZZJ->(MsUnLock())
        Else
            RecLock('ZZJ' , .F.)
                ZZJ_STATUS := 'A'
            ZZJ->(MsUnLock())
            //CONOUT("Incluido com sucesso")
            FWAlertSuccess("Apontada com sucesso", 'APONTADA')
        Endif
    Else

        BeginSQL ALIAS cAlias
            Select * FROM %TABLE:ZZJ% ZZJ
            WHERE ZZJ.%NOTDEL% AND ZZJ_STATUS = %EXP:cPendente%
        endSQL

        while !(cAlias)->(EoF())

            cEtiq := (cAlias)->ZZJ_CODETI
            cProd := (cAlias)->ZZJ_PRODUT
            cOp := (cAlias)->ZZJ_OP
            nQuant := (cAlias)->ZZJ_QUANT

            aadd(aVetor,{"D3_OP" ,cOp,Nil})
            aadd(aVetor,{"D3_COD",cProd,Nil})
            aadd(aVetor,{"D3_QUANT",nQuant,Nil})
            aadd(aVetor,{"D3_TM",'001',nil})
            aadd(aVetor,{"D3_QTMAIOR",0,Nil})

            dData:=dDataBase
    
            MSExecAuto({|x, y| mata250(x, y)},aVetor, nOpc )

            If lMsErroAuto
                CONOUT("Erro")
                aLog := GetAutoGRLog()

                If Len(aLog) > 0
                    cErro := aLog[1]
                    cErro += 'ExecAuto Mata250 - PEAPONT.PRW'
                Else
                    cErro := mostraerro()
                    cErro += 'ExecAuto Mata250 - PEAPONT.PRW'
                EndIf

                aAdd(aErros,{cEtiq,cOp,cProd,nQuant,cErro})

                cMsg := f_html(aErros)           

                cTit := 'Falhas no Apomtamento de Ordens de Producao'
                cEmail := 'edson.pedro@totvs.com.br'
  
                SendMail(cTit,cEmail,cMsg)
                // RecLock('ZZJ' , .F.)
                //     ZZJ_STATUS := 'E'
                // ZZJ->(MsUnLock())
            Else
                RecLock('ZZJ' , .F.)
                    ZZJ_STATUS := 'A'
                ZZJ->(MsUnLock())
                //CONOUT("Incluido com sucesso")
                CONOUT("Incluido com sucesso")
            Endif
        
        aVetor := {}
            
        (cAlias)->(dbSkip())

        EndDo
    EndIF
    
return nil

Static Function SendMail(cTitulo,cEmail,cMsg)

  Local cAccount := GetMv('MV_RELACNT') // protheus@amazonaco.com.br //
  Local cServer  := GetMv('MV_RELSERV') // SMTP.AMAZONACO.COM.BR
  Local cPass    := GetMv('MV_RELPSW' ) // senha
 
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResult

If lResult
	If GetMv("MV_RELAUTH") //lRelauth
		lRet:= Mailauth(cAccount,alltrim(cPass))
	Else
		lRet:= .T.
	Endif
	If lRet
		cSubject:= cTitulo
		SEND MAIL FROM cAccount   ;
			TO cEmail;
			SUBJECT cSubject ;
			BODY Alltrim(cMsg)  RESULT lEnviado
		DISCONNECT SMTP SERVER
	EndIf
EndIf

if lEnviado
    alert()
endif
Return
Static Function f_html(aErros)
	Local cHtml := ''
    Local nx := 0

	cHtml += '  <html>  '
	cHtml += '  <head>  '
	cHtml += '  <meta charset="UTF-8">  '
	cHtml += '  <style> '
	cHtml += '  body {  '
	cHtml += '  font-family: Arial, sans-serif; '
	cHtml += '  	color: #333;    '
	cHtml += '  	}   '
	cHtml += '  .header {   '
	cHtml += '  background-color: #f2f2f2;  '
	cHtml += '  	padding: 10px;  '
	cHtml += '  	border-left: 4px solid #cc0000; '
	cHtml += '  	}   '
	cHtml += '  .title {    '
	cHtml += '  font-size: 18px;    '
	cHtml += '  	font-weight: bold;  '
	cHtml += '  	}   '
	cHtml += '  .subtitle { '
	cHtml += '  font-size: 13px;    '
	cHtml += '  	color: #666;    '
	cHtml += '  	}   '
	cHtml += '  .table {    '
	cHtml += '  border-collapse: collapse;  '
	cHtml += '  	width: 100%;    '
	cHtml += '  	margin-top: 15px;   '
	cHtml += '  	}   '
	cHtml += '  .table th, .table td {  '
	cHtml += '  border: 1px solid #ddd; '
	cHtml += '  	padding: 8px;   '
	cHtml += '  	text-align: left;   '
	cHtml += '  	}   '
	cHtml += '  .table th { '
	cHtml += '  background-color: #cc0000;  '
	cHtml += '  	color: #fff;    '
	cHtml += '  	}   '
	cHtml += '  .alert {    '
	cHtml += '  margin-top: 15px;   '
	cHtml += '  	font-weight: bold;  '
	cHtml += '  	color: #cc0000; '
	cHtml += '  	}   '
	cHtml += '  .footer {   '
	cHtml += '  margin-top: 20px;   '
	cHtml += '  	font-size: 12px;    '
	cHtml += '  	color: #888;    '
	cHtml += '  	}   '
	cHtml += '  </style>    '
	cHtml += '  </head> '
	cHtml += '      '
	cHtml += '  <body>  '
	cHtml += '      '
	cHtml += '  <div class="header">    '
	cHtml += '  <div class="title">PELMEX — Monitor de Apontamento RFID</div>   '
	cHtml += '  <div class="subtitle">Integração RFID x Protheus | Apontamento de Produção</div>    '
	cHtml += '  </div>  '
	cHtml += '      '
	cHtml += '  <p>Foram identificadas etiquetas RFID que <b>não foram apontadas no Protheus</b>.</p>   '
	cHtml += '      '
	cHtml += '  <div class="alert"> '
	cHtml += '  ? Verifique o monitor RFID para análise e correção.    '
	cHtml += '  </div>  '
	cHtml += '      '
	cHtml += '  <table class="table">   '
	cHtml += '  <tr>    '
	cHtml += '  <th>Etiqueta RFID</th>  '
	cHtml += '  <th>OP</th> '
	cHtml += '  <th>Produto</th>   '
	cHtml += '  <th>Quantidade</th> '
	cHtml += '  <th>Erro</th>   '
	cHtml += '  </tr>   '
	cHtml += '      '
	cHtml += '  <!-- Exemplo de linha -->   '

    for nx := 1 to len(aErros) 
        cHtml += '  <tr>    '
        cHtml += '  <td>'+aErros[nx,1]+'</td> '
        cHtml += '  <td>'+aErros[nx,2]+'</td>   '
        cHtml += '  <td>'+aErros[nx,3]+'</td>   '
        cHtml += '  <td>'+cvaltochar(aErros[nx,4])+'</td> '
        cHtml += '  <td>Falha na integração</td>    '
        cHtml += '  </tr>   '
    next nx

	cHtml += '      '
	cHtml += '  </table>    '
	cHtml += '      '
	cHtml += '  <div class="footer">    '
	cHtml += '  Mensagem automática — Monitor RFID | Integração Protheus    '
	cHtml += '  </div>  '
	cHtml += '      '
	cHtml += '  </body> '
	cHtml += '  </html> '

Return cHtml
