#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function Mta410T()

SetPrvt("_CAREA,_NREC,_CIND,_LRETURN,_CNEWNUM,_NREGSC5")
SetPrvt("_WULTNUM1,M->C5_NUM,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MTA410T   ³ Autor ³Rogerio Oliveira      ³ Data ³23/08/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava um arquivo de log de pedidos deletados               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

Processa({|| RunCont() },"Processando...")

Return

Static Function RunCont

//Devem ser passados no array(s) todos os campos obrigatorios
Local _aVetor     := {}
Local lMsErroAuto := .F.
Local nReg        := 0
Local cQuery      := ""
Local _NumPed     := SC6->C6_NUM
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Query para Atualização                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := "SELECT C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_TES, C6_CF, C6_QTDVEN, C6_PRCVEN, C6_VALOR, C6_X_EMIS, C6_ENTREG, C6_DESCRI, C6_CLI, C6_LOJA, C6_QTDENT, C6_DATFAT, C6_X_DT2 "
cQuery := cQuery + "FROM SC6" + SM0->M0_CODIGO + "0 "
cQuery := cQuery + "WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND "
cQuery := cQuery + "D_E_L_E_T_ = '*' AND C6_NUM = '"+_NumPed+"' "
cQuery := cQuery + "ORDER BY C6_NUM"
TCQUERY cQuery NEW ALIAS "TMP"



dbSelectArea( "TMP" )
dbGoBottom()
nReg := Recno()
dbGoTop()

If nReg > 0
	
	ProcRegua( nReg ) // Numero de registros a processar
	
	While ! EOF()
		
		IncProc()
		
		dbSelectArea( "SZL" )
		dbSetOrder(2)
		If !dbSeek(xFilial("SZL")+TMP->C6_NUM+TMP->C6_ITEM+"  "+TMP->C6_PRODUTO)  
			RecLock("SZL",.T.)
			ZL_FILIAL := xFilial("SC6")
			ZL_NUM    := TMP->C6_NUM
			ZL_ITEM   := TMP->C6_ITEM
			ZL_PRODUTO:= TMP->C6_PRODUTO
			ZL_QTD    := TMP->C6_QTDVEN
			ZL_VLRUNIT:= TMP->C6_PRCVEN
			ZL_VLRTOT := TMP->C6_VALOR                                                      
			ZL_TES    := TMP->C6_TES
			ZL_CFOP   := TMP->C6_CF
			ZL_EMISSAO:= stod(TMP->C6_X_EMIS)
			ZL_DTDEL  := DDATABASE
			ZL_ENTREG := stod(TMP->C6_ENTREG)
			ZL_DESCRI := TMP->C6_DESCRI
			ZL_CLI    := TMP->C6_CLI
			ZL_USUARIO:= SUBST(CUSUARIO,7,15)
			ZL_QTDENT := TMP->C6_QTDENT
			ZL_LOJA   := TMP->C6_LOJA
			ZL_DATFAT := stod(TMP->C6_DATFAT)
			MsUnLock()
		EndIf
		     
/*
		  	dbSelectArea("ZX1") 
//		  	dbSetOrder(1)
//		  	If !dbSeek(xFilial("ZX1")+TMP->C6_NUM+TMP->C6_ITEM)
			  RecLock("ZX1",.T.)
		    	ZX1_FILIAL := xFilial("SC6")
	    	 	ZX1_PEDIDO := TMP->C6_NUM
	    		ZX1_ITEM   := TMP->C6_ITEM
	    		ZX1_PRODUT := TMP->C6_PRODUTO
		    	ZX1_DTNEW  := stod(TMP->C6_ENTREG)
	    		ZX1_DTOLD  := stod(TMP->C6_X_DT2)
		    	ZX1_HORA   := Time()
	     		ZX1_DTBASE := dDatabase
		    	ZX1_USUARI := SUBST(CUSUARIO,7,15)
		    	ZX1_ORIGEM := "DELETADO"
		    	ZX1_EMISSA := stod(TMP->C6_X_EMIS)
		    	ZX1_CLIENT := TMP->C6_CLI
		    	ZX1_LOJA   := TMP->C6_LOJA
			  MsUnLock()
 //			EndIf
 */
		dbSelectArea("TMP")
		dbSkip()
	EndDo
Else
	Alert("Não tem atualizacao")
EndIf

dbCloseArea("TMP")
Return

