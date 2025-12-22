#include "rwmake.ch"  
#INCLUDE "PROTHEUS.CH"

 /*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  MTA416BX  ¦ Autor ¦ORISMAR SILVA         ¦ Data ¦ 24/07/2023 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada para autorizar ou não a baixa do orçamento.  ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/  
User function MTA416BX(aProduto)
                                                    
Local nAux      := PARAMIXB //Quantidade de linhas no acols.  
Local dDatDia   := DDATABASE
Local lRet      := .T.
Local aDados    := {}
Local cTitulo   := "Pedidos de vendas gerados"
*
cMsgHtml := '<h3>Não existe pedido gerado para o orçamento! '+_aCols[nAux][2]+'<h3>'
//Alert("MTA416BX")
*
_cQry := " SELECT C5_FILIAL,C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_NOTA,C5_SERIE,C6_PRODUTO,SUM(C6_QTDVEN) C6_QTDVEN "
_cQry += " FROM " + RetSqlName("SC5") +" SC5, "+ RetSqlName("SC6")+ " SC6 "
_cQry += " WHERE SC5.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = '' "
_cQry += " AND C5_FILIAL = C6_FILIAL AND C5_NUM  = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA "
_cQry += " AND C5_CLIENTE = '"+SCJ->CJ_CLIENTE+"' AND C5_LOJACLI = '"+SCJ->CJ_LOJA+"'"
_cQry += " AND C6_PRODUTO = '"+_aCols[nAux][2]+"'"
_cQry += " AND C5_PEDCLI = '"+ALLTRIM(StrTran(StrTran(StrTran(SCJ->CJ_COTCLI,"/",""),"-",""),".",""))+"'"
_cQry += " AND C5_EMISSAO BETWEEN '20221001' AND '"+DTOS(dDatDia)+"'"
_cQry += " GROUP BY C5_FILIAL,C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_NOTA,C5_SERIE,C6_PRODUTO "
*      
dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_cQry)),"TMP",.T.,.F.)   

*
if !USED()
   MsgBox(_cQry+'. Query errada','Erro!!!','STOP')
endif

count to nReg

dbSelectArea("TMP")
dbGoTop()

*
if !TMP->(Eof())
   While !TMP->(Eof())
         cCliente   := TMP->C5_CLIENTE+"-"+TMP->C5_LOJACLI+" "+LTRIM(Posicione("SA1",1,XFILIAL("SA1")+TMP->C5_CLIENTE+TMP->C5_LOJACLI,"A1_NOME"))
         cOrcamento := SCJ->CJ_NUM
         AaDD(aDados, {TMP->C5_NUM,iif(EMPTY(TMP->C5_NOTA),"",TMP->C5_NOTA+" - "+TMP->C5_SERIE),TMP->C6_PRODUTO,LTRIM(Posicione("SB1",1,XFILIAL("SB1")+TMP->C6_PRODUTO,"B1_DESC")),TMP->C6_QTDVEN})
         AaDD(aProduto, {cOrcamento,cCliente,TMP->C5_NUM,iif(EMPTY(TMP->C5_NOTA),"",TMP->C5_NOTA+" - "+TMP->C5_SERIE),TMP->C6_PRODUTO,LTRIM(Posicione("SB1",1,XFILIAL("SB1")+TMP->C6_PRODUTO,"B1_DESC")),TMP->C6_QTDVEN})
        
         lRet      := .F.
         TMP->(DBSKIP())
   end 
endif
dbSelectArea("TMP")
dbCloseArea()

if Len(aDados) > 0

	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	
	DEFINE MSDIALOG oDlgACE TITLE cTitulo  FROM  1,0 TO 330,850 OF oMainWnd PIXEL
	
	@ 30,1.0 LISTBOX oLbx1 VAR cVarQ  FIELDS HEADER "Pedido de venda",;
													            "Nota Fiscal/serie",;
													            "Produto",;
                                                   "Descrição",;
													            "Quantidade",;
										                     SIZE  420,130 OF oDlgACE  PIXEL ON dblClick()
		
	oLbx1:SetArray(aDados)
	oLbx1:bLine:={|| {aDados[oLbx1:nAt,1],aDados[oLbx1:nAt,2],aDados[oLbx1:nAt,3],aDados[oLbx1:nAt,4],Transform(aDados[oLbx1:nAt,5],PesqPict("SC6","C6_QTDVEN"))}}                                     
	
   @ 04,001 Say "Cliente:"  Size 100,10 Pixel of oDlgACE
	@ 04,030 Say oCliente Var cCliente Font oBold Color(CLR_RED) Size 250,10 Pixel of oDlgACE
   @ 12,001 Say "Orçamento:"  Size 100,10 Pixel of oDlgACE
	@ 12,030 Say oOrcamento Var cOrcamento  Font oBold Color(CLR_RED) Size 100,10 Pixel of oDlgACE

	@ 010,360 Button oBtnFecha Prompt "Fechar" Size 35,13 Of oDlgACE Pixel Action (Close(oDlgACE))        
	
	ACTIVATE MSDIALOG oDlgACE CENTERED
   
endif

*

Return lRet
