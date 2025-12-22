#include "Protheus.ch"
#include "protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MA410MNU   ¦ Autor ¦                      ¦ Data ¦          8 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Este programa irá realizar Implementar opção na rotina de    ¦¦¦
¦¦¦  (cont.)  ¦ Pedido de Vendas                                              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Alterações

¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/


User Function MA410MNU()

If ExistBlock("AAFATR03")
	aAdd(aRotina, { "Ordem de Carregamento","U_AA410MUC"	,0,4,0 ,NIL} 	)	//"Conhecimento"
EndIf

If existBlock("AAFATR04")
	aAdd(aRotina, { "Comprovante de Entrega","U_AA410MUA"	,0,4,0 ,NIL} 	)	//"Conhecimento"
ENdIf
If existBlock("AAFATR02")
	aAdd(aRotina, { "Lista de Separação    ","U_AA410MUB"	,0,4,0 ,NIL} 	)	//"Conhecimento"
EndIf

If existBlock("AAFATR20")
	aAdd(aRotina, { "Lista de Separação 2   ","U_AA410MUF"	,0,4,0 ,NIL} 	)	//"Conhecimento"
EndIf

If existBlock("AALOGE2B")
	aAdd(aRotina, { "Data Prevista de Entrega    ","U_AALOGE2B"	,0,4,0 ,NIL} 	)	//"Conhecimento"
EndIf
If existBlock("AAFATC04")
	aAdd(aRotina, { "Historico de Pedido    ","U_AAFATC04"	,0,4,0 ,NIL} 	)	//"Conhecimento"
	aAdd(aRotina, { "Follow Up Pedido","VIEWDEF.AAFATC04"	,0,4,0 ,NIL} 	)
EndIf

If existBlock("AAFATE11")
	aAdd(aRotina, { "Altera ARMAZEM/TES    ","U_AAFATE11"	,0,4,0 ,NIL} 	)	//"Conhecimento"
EndIf

If existBlock("AAFATE16")
	aAdd(aRotina, { "teste    ","U_AAFATE16"	,0,4,0 ,NIL} 	)	//"Conhecimento"
EndIf

If existBlock("WTROCACOD")
	aAdd(aRotina, { "TROCA CODIGOS         ","U_WTROCACOD"	,0,4,0 ,NIL} 	)	//"Conhecimento"
EndIf

If existBlock("WTROCACOD")
	aAdd(aRotina, { "TROCA CODIGOS         ","U_WTROCACOD"	,0,4,0 ,NIL} 	)	//"Conhecimento"
EndIf


// INCLUSAO REALIZADAS POR WERMESON EM 19-09-20 
// SOLICITANTE FELIPE COMERCIAL
If existBlock("WRESIDUOS") 
	aAdd(aRotina, { "RESIDOS AA           ","U_WRESIDUOS"	,0,4,0 ,NIL} 	)	//"Residuos AA"
EndIf


If existBlock("WSTRANSF") 
	aAdd(aRotina, { "Retorno            ","U_WSTRANSF"	,0,4,0 ,NIL} 	)	//"Residuos AA"
EndIf


Return Nil

User Function WSTRANSF()
	lExec := .F.
	If !EMPTY(SC5->C5_XORCRES)
			U_AAFATP12(SC5->C5_NUM,SC5->C5_FILIAL, , , ,.F.) 
		Else 
			MsgStop("Favor Selectionar um Pedido Reserva!")
	EndIf
Return Nil

User Function AA410MUA()
	lExec := .F.
	If ExistBlock('AAFATP07')
		lExec := u_AAFATP07(SC5->C5_FILIAL,SC5->C5_NUM)
	EndIf
	If !lExec
		U_AAFATR04(SC5->C5_NUM,SC5->C5_FILIAL, , , ,.F.) // Nao IMprimir Itens Bloqueados a pedido do Adelson
	EndIf
Return Nil

User Function AA410MUB()
	lExec := .F.
	If ExistBlock('AAFATP07')
		lExec := u_AAFATP07(SC5->C5_FILIAL,SC5->C5_NUM)
	EndIf
	If !lExec
		U_AAFATR02(SC5->C5_NUM,SC5->C5_FILIAL)//u_AAFATR20 //XWERMESON  falat definir para quem vai o email
	EndIf
Return Nil

User Function AA410MUF()
	lExec := .F.
	If ExistBlock('AAFATP07')
		lExec := u_AAFATP07(SC5->C5_FILIAL,SC5->C5_NUM)
	EndIf
	If !lExec
		U_AAFATR20(SC5->C5_NUM,SC5->C5_FILIAL)//u_AAFATR20 //XWERMESON  falat definir para quem vai o email
	EndIf
Return Nil

User Function AA410MUC()
	lExec := .F.
	If ExistBlock('AAFATP07')
		lExec := u_AAFATP07(SC5->C5_FILIAL,SC5->C5_NUM)
	EndIf
	If !lExec
		U_AAFATR03(SC5->C5_FILIAL,SC5->C5_NUM)
	EndIf
Return Nil


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ WTROCACOD  ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 15/08/2020 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrdada para ajuste do endereco de consumo         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦           	
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function WTROCACOD()
 Local cQuery := ""
 
	Pergunte("WTROCA", .T.)
	
	cQuery += " Select SC6.* From " + RetSqlName("SC6") + " AS SC6 (NOLOCK)"
	cQuery += "  INNER JOIN " + RetSqlName("SC5") + " AS SC5 (NOLOCK) 
	cQuery += "     ON SC5.D_E_L_E_T_ = '' AND C5_FILIAL = C6_FILIAL AND  C5_NUM = C6_NUM AND C5_BLQ = '' AND C5_LIBEROK = '' and C5_XORCRES = '' " 
	cQuery += "  Where SC6.D_E_L_E_T_ = '' AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' 
	cQuery += "    AND SC6.C6_NUM     BETWEEN '" +MV_PAR01+ "' AND '" + MV_PAR02 + "' "
	cQuery += "    AND SC6.C6_PRODUTO = '" +MV_PAR03+ "' "
    cQuery += "    AND SC6.C6_FILIAL = '" +xFilial("SC6")+ "' "
	
	
	dbUseArea( .t., "TopConn", TCGenQry(,,ChangeQuery(cQuery)), "WWW7" , .F., .F. )
	
	SB1->(dbSetOrder(1))
				
	If WWW7->(Eof())
			MsgStop("Não foram encontrados dados para operação!")
		ElseIf SB1->(dbSeek( xFilial("SB1") + MV_PAR04))
			While !(WWW7->(Eof()))
				
				cQuery := " Select MAX(C6_ITEM) as CITEM From " + RetSqlName("SC6") + " AS SC6 (NOLOCK)"
				cQuery += "  Where SC6.D_E_L_E_T_ = '' 
				cQuery +=    " AND C6_FILIAL = '" + xFilial("SC6")+ "' "
				cQuery +=    " AND C6_NUM    = '" + WWW7->C6_NUM  + "' "
	
				dbUseArea( .t., "TopConn", TCGenQry(,,ChangeQuery(cQuery)), "WWW8" , .F., .F. )
				
				cwItem := IF ( WWW8->(EOF()), '01',  Soma1(WWW8->CITEM, Len(SC6->C6_ITEM)) )
				
				WWW8->(dbCloseArea())				
				
				SC6->(dbSetOrder(1))
				IF SC6->(dbSeek(WWW7->(C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO)))
					RECLOCK("SC6", .F.)
					If SC6->C6_QTDENT > 0 
							SC6->C6_QTDVEN  := SC6->C6_QTDENT
							SC6->C6_VALOR	:= SC6->C6_QTDENT * SC6->C6_PRCVEN
							SC6->C6_UNSVEN	:= ConvUM( SC6->C6_PRODUTO, SC6->C6_QTDENT * SC6->C6_PRCVEN,0,2)
						Else 
							SC6->(dbDelete())
					EndIf 
				
					MSUNLOCK()
				ENDIF 

				RECLOCK("SC6", .T.)
					SC6->C6_FILIAL	:= WWW7->C6_FILIAL
					SC6->C6_ITEM	:= cwItem
					SC6->C6_PRODUTO	:= SB1->B1_COD
					SC6->C6_DESCRI	:= SB1->B1_DESC
					SC6->C6_UM	    := SB1->B1_UM 
					SC6->C6_QTDVEN	:= WWW7->(C6_QTDVEN - C6_QTDENT)
					SC6->C6_PRCVEN	:= WWW7->C6_PRCVEN
					SC6->C6_VALOR	:= WWW7->(C6_QTDVEN - C6_QTDENT) * WWW7->C6_PRCVEN
					SC6->C6_SEGUM	:= SB1->B1_SEGUM
					SC6->C6_TES	    := WWW7->C6_TES
					SC6->C6_CF	    := WWW7->C6_CF
					SC6->C6_UNSVEN	:= ConvUM(SB1->B1_COD, WWW7->(C6_QTDVEN - C6_QTDENT),0,2)
					SC6->C6_LOCAL	:= WWW7->C6_LOCAL
					SC6->C6_CLI	    := WWW7->C6_CLI
					SC6->C6_DESCONT	:= WWW7->C6_DESCONT
					SC6->C6_ENTREG	:= DATE()
					SC6->C6_VALDESC	:= WWW7->C6_VALDESC 
					SC6->C6_LOJA	:= WWW7->C6_LOJA 
					SC6->C6_NUM	    := WWW7->C6_NUM 
					SC6->C6_COMIS1	:= WWW7->C6_COMIS1
					SC6->C6_COMIS2	:= WWW7->C6_COMIS2
					SC6->C6_COMIS3	:= WWW7->C6_COMIS3
					SC6->C6_COMIS4	:= WWW7->C6_COMIS4
					SC6->C6_COMIS5	:= WWW7->C6_COMIS5
					SC6->C6_PEDCLI	:= WWW7->C6_PEDCLI
					SC6->C6_PRUNIT	:= WWW7->C6_PRUNIT
					SC6->C6_OP	    := WWW7->C6_OP
					SC6->C6_IPIDEV	:= WWW7->C6_IPIDEV
					SC6->C6_PICMRET	:= WWW7->C6_PICMRET
					SC6->C6_CODISS	:= WWW7->C6_CODISS
					SC6->C6_CLASFIS	:= WWW7->C6_CLASFIS
					SC6->C6_SUGENTR	:= DATE()
					SC6->C6_TURNO	:= WWW7->C6_TURNO
					SC6->C6_USERLGI	:= WWW7->C6_USERLGI
					SC6->C6_USERLGA	:= WWW7->C6_USERLGA
					SC6->C6_XDCRE	:= WWW7->C6_XDCRE
					SC6->C6_XESPECI	:= WWW7->C6_XESPECI
					SC6->C6_XPROF	:= WWW7->C6_XPROF
					SC6->C6_XITEM	:= WWW7->C6_XITEM
					SC6->C6_XQUANT	:= WWW7->C6_XQUANT
					SC6->C6_XPRECO	:= WWW7->C6_XPRECO
					SC6->C6_XPRTAB	:= WWW7->C6_XPRTAB
					SC6->C6_XAGENTE	:= WWW7->C6_XAGENTE
					SC6->C6_XPCOMIS	:= WWW7->C6_XPCOMIS
					SC6->C6_XVLCOMI	:= WWW7->C6_XVLCOMI
					SC6->C6_XDESCON	:= WWW7->C6_XDESCON
					SC6->C6_XVLDESC	:= WWW7->C6_XVLDESC
					SC6->C6_XACRESC	:= WWW7->C6_XACRESC
					SC6->C6_XVLACRE	:= WWW7->C6_XVLACRE
					SC6->C6_XVLFRE	:= WWW7->C6_XVLFRE
					SC6->C6_XVLSEG	:= WWW7->C6_XVLSEG
					SC6->C6_XTOTINC	:= WWW7->C6_XTOTINC
					SC6->C6_XTEC	:= WWW7->C6_XTEC
					SC6->C6_XEXNCM	:= WWW7->C6_XEXNCM
					SC6->C6_XEXNBM	:= WWW7->C6_XEXNBM
					SC6->C6_XFABR	:= WWW7->C6_XFABR
					SC6->C6_XFABLOJ	:= WWW7->C6_XFABLOJ
					SC6->C6_XSALDO	:= WWW7->C6_XSALDO
					SC6->C6_CC	    := WWW7->C6_CC
					SC6->C6_CONTA	:= WWW7->C6_CONTA
					SC6->C6_CATEG	:= WWW7->C6_CATEG
					SC6->C6_DATAEMB	:= DATE()
					SC6->C6_XITENT	:= WWW7->C6_XITENT
					SC6->C6_XSERENT	:= WWW7->C6_XSERENT
					SC6->C6_XDOCENT	:= WWW7->C6_XDOCENT
					SC6->C6_XPPICMS	:= WWW7->C6_XPPICMS
					SC6->C6_XPDICMS	:= WWW7->C6_XPDICMS
					SC6->C6_XPGICMS	:= WWW7->C6_XPGICMS
					SC6->C6_XFEE	:= WWW7->C6_XFEE
					SC6->C6_XDESTAQ	:= WWW7->C6_XDESTAQ
					SC6->C6_XPRCVEN	:= WWW7->C6_XPRCVEN
					SC6->C6_XQTDPCA	:= WWW7->C6_XQTDPCA
					SC6->C6_OPER	:= WWW7->C6_OPER
					SC6->C6_TPREPAS	:= WWW7->C6_TPREPAS
					SC6->C6_XBTB    := WWW7->C6_XBTB
				SC6->(MSUNLOCK())
				
				WWW7->(dbSkip())
			End 
		Else 
			MsgStop("Produto destino nao encontrado!")
	EndIf 
	WWW7->(dbCloseArea())
	Pergunte("MTA410",.F.) 
	
Return Nil


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ WRESIDUOS  ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 15/08/2020 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrdada para ajuste do endereco de consumo         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦           	
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function WRESIDUOS()
 Local cQuery := ""
 
	Pergunte("WRESIDUOS", .T.)
	
	cQuery += " Select SC6.* From " + RetSqlName("SC6") + " AS SC6 (NOLOCK)"
	cQuery += "  INNER JOIN " + RetSqlName("SC5") + " AS SC5 (NOLOCK) 
	cQuery += "     ON SC5.D_E_L_E_T_ = '' AND C5_FILIAL = C6_FILIAL AND  C5_NUM = C6_NUM AND C5_BLQ = '' AND C5_LIBEROK = '' and C5_XORCRES = '' " 
	cQuery += "  INNER JOIN " + RetSqlName("SB1") + " AS SB1 (NOLOCK) ON SB1.D_E_L_E_T_ = '' AND B1_COD = C6_PRODUTO " 
	cQuery += "  Where SC6.D_E_L_E_T_ = '' AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' AND C6_QTDENT > 0  " 
	cQuery += "    AND SC6.C6_NUM              BETWEEN '" +             MV_PAR01  + "' AND '" +             MV_PAR02   + "' "
	cQuery += "    AND SC6.C6_PRODUTO          BETWEEN '" +             MV_PAR03  + "' AND '" +             MV_PAR04   + "' "
	cQuery += "    AND SB1.B1_GRUPO            BETWEEN '" +             MV_PAR05  + "' AND '" +             MV_PAR06   + "' "
	cQuery += "    AND SC5.C5_VEND1            BETWEEN '" +             MV_PAR09  + "' AND '" +             MV_PAR10   + "' "
	cQuery += "    AND (C6_QTDVEN - C6_QTDENT) BETWEEN  " + ALLTRIM(STR(MV_PAR07))+ "  AND  " + ALLTRIM(STR(MV_PAR08)) + "  "
    cQuery += "    AND SC6.C6_FILIAL = '" +xFilial("SC6")+ "' "
    	
	dbUseArea( .t., "TopConn", TCGenQry(,,ChangeQuery(cQuery)), "WWW7" , .F., .F. )
				
	If WWW7->(Eof())
			MsgStop("Não foram encontrados dados para operação!")
		Else
			While !(WWW7->(Eof()))				
				SC6->(dbSetOrder(1))
				IF SC6->(dbSeek(WWW7->(C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO)))
					RECLOCK("SC6", .F.)
					If SC6->C6_QTDENT > 0 
					    SC6->C6_XQUANT  := SC6->C6_QTDVEN 
						SC6->C6_QTDVEN  := SC6->C6_QTDENT
						SC6->C6_VALOR	:= SC6->C6_QTDENT * SC6->C6_PRCVEN
						SC6->C6_UNSVEN	:= ConvUM( SC6->C6_PRODUTO, SC6->C6_QTDENT * SC6->C6_PRCVEN,0,2)
						SC6->C6_BLQ     := "R"
						SC6->C6_XDESCID := SC6->C6_XDESCID +  " ELIMINADO RESIDUOS POR " + __CUSERID + " EM " + DTOC(DATE())
					EndIf 
					MSUNLOCK()
				ENDIF 
				WWW7->(dbSkip())
			End 
			
			MsgInfo("Operação finalizada!")
	EndIf 
	WWW7->(dbCloseArea())
	Pergunte("MTA410",.F.) 
	
Return Nil


/*********************************************************************************** 
*       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
*      AAAA       LL         LL         EE         CC        KK    KK   SS         *
*     AA  AA      LL         LL         EE        CC         KK  KK     SS         *
*    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   *
*   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  *
*  AA        AA   LL         LL         EE         CC        KK    KK          SS  *
* AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   * 
************************************************************************************
*         I want to change the world, but nobody gives me the source code!         * 
