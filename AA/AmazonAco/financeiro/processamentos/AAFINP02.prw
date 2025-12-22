#include "Protheus.ch"


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ AAFINP02   ¦ Autor ¦ Arlindo Neto         ¦ Data ¦ 26/09/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Rotina para recálculo de comissões para notas de devolução    ¦¦¦
¦¦¦           ¦ que não tiveram registros gerados no SE3 negativos            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFINP02()
Local lRet 	  	:= .F.
Local dDataDe 	:= STOD('')
Local dDataAte 	:= STOD('')
Local nOpc 		:= 0
Local cVenDe  	:= SPACE(6)
Local cVenAte  	:= SPACE(6)

While !lRet
	nOpc := 0
	lRet := .F.
	
	DEFINE MSDIALOG oDlg TITLE "Recalculo de Comissões" From 0,0 To 20,50
	
	@ 05,07 SAY "Data de:                ?" SIZE 200,80 PIXEL OF oDlg  
	@ 05,70 MSGET dDataDe PICTURE "@!" SIZE 50, 10 PIXEL OF oDlg
	
	@ 35,07 SAY "Data Ate:               ?" SIZE 200,80 PIXEL OF oDlg
	@ 35,70 MSGET dDataAte PICTURE "@!" SIZE 50, 10 PIXEL OF oDlg

	@ 65,07 SAY "Vendedor De:         ?" SIZE 200,80 PIXEL   OF oDlg 
	@ 65,70 MSGET cVenDe  PICTURE "@!" SIZE 50, 10 PIXEL F3 "SA3" OF oDlg	
	
	@ 95,07 SAY "Vendedor Ate:        ?" SIZE 200,80 PIXEL  OF oDlg 
	@ 95,70 MSGET cVenAte PICTURE "@!" SIZE 50, 10 PIXEL F3 "SA3" OF oDlg
	
	
	
	@ 120,050 BUTTON "Recalcular" SIZE 40,12 PIXEL OF oDlg ACTION (nOpc:=1,oDlg:End())
	@ 120,110 BUTTON "Cancelar" SIZE 40,12 PIXEL OF oDlg ACTION (nOpc:=0,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	//-- Validacoes
	If nOpc == 1
		If Empty(dDataDe) 
			MsgInfo("Favor preencher o campo Data de!","Atenção!!")
			lRet := .F.
		ElseIf Empty(dDataAte) 
			MsgInfo("Favor preencher o campo Data Ate!","Atenção!!")
			lRet := .F.
		ElseIf Empty(cVenDe) 
			MsgInfo("Favor preencher o campo Vendedor De!","Atenção!!")
			lRet := .F.
		ElseIf Empty(cVenAte) 
			MsgInfo("Favor preencher o campo Vendedor Ate!","Atenção!!")
			lRet := .F.
		Else
			lRet := .T.
		EndIf
	Else
		lRet := .T.
	EndIf
	
  	If lRet .And. nOpc == 1
		Processa({|| RunProc(dDataDe,dDataAte,cVenDe,cVenAte) },"Processando a leitura do arquivo.","Aguarde..")
	EndIf   
Enddo



/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ RunProc    ¦ Autor ¦ Arlindo Vieira       ¦ Data ¦ 26/09/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processo o Recálculo                                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function RunProc(dDataDe,dDataAte,cVenDe,cVenAte)

Local cQry		:=""
Local cFilSF2   := xFilial("SF2")
Local nQtdVend  := 0      
Local cVendedor := "" 
Local nComiss   := 0
Local cFilSD2   := xFilial("SD2")
Local cFilSA3   := xFilial("SA3") 
Local dDataEmi  
Local cGrupo    
Local cTabela := getNextAlias()

cQry := " SELECT SF2.F2_VEND1,SF1.F1_FILIAL,SD1.D1_NFORI,SD1.D1_SERIORI,SD1.D1_SERIE,SUM(SD1.D1_TOTAL-SD1.D1_VALDESC) AS TOTALVEND,SD1.D1_DOC,SD1.D1_EMISSAO,SF1.F1_FORNECE,SF1.F1_LOJA "
cQry += " FROM "+RetSQLName("SD1")+" SD1  "
cQry += " INNER JOIN "+RetSQLName("SF1")+" SF1 ON SF1.D_E_L_E_T_='' "
cQry += " AND SF1.F1_DOC=SD1.D1_DOC "
cQry += " AND SF1.F1_SERIE=SD1.D1_SERIE "
cQry += " AND SF1.F1_FILIAL=SD1.D1_FILIAL "
cQry += " AND SF1.F1_TIPO='D' "
cQry += " INNER JOIN "+RetSQLName("SF2")+" SF2 ON SF2.D_E_L_E_T_='' "
cQry += " AND SF2.F2_FILIAL=SF1.F1_FILIAL "
cQry += " AND SF2.F2_DOC=SD1.D1_NFORI "
cQry += " AND SF2.F2_SERIE=SD1.D1_SERIORI "     
cQry += " WHERE SD1.D_E_L_E_T_='' AND SD1.D1_NFORI<>'' "
cQry += " AND SF2.F2_VEND1 BETWEEN '"+Alltrim(cVenDe)+"' AND '"+Alltrim(cVenAte)+"' "
cQry += " AND SD1.D1_EMISSAO BETWEEN '"+DToS(dDataDe)+"' AND '"+DToS(dDataAte)+"' "
cQry += " GROUP BY SF2.F2_VEND1,SF1.F1_FILIAL,SD1.D1_NFORI,SD1.D1_SERIORI,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_EMISSAO,SF1.F1_FORNECE,SF1.F1_LOJA ORDER BY SF2.F2_VEND1 "

dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), cTabela, .T., .F. ) 
tcSetField(cTabela,"D1_EMISSAO","D",8,0)


While !(cTabela)->(EOF())         
	SE3->(DbSetOrder(2))
	                                                                              
	If !(SE3->(DbSeek(xFilial("SE3") + (cTabela)->F2_VEND1 + (cTabela)->D1_SERIE + (cTabela)->D1_DOC  )))
		nQtdVend  := -((cTabela)->TOTALVEND)                                                         
		dDataEmi  := (cTabela)->D1_EMISSAO
		nComiss	  := Posicione("SD2",1,cFilSD2 + (cTabela)->D1_NFORI + (cTabela)->D1_SERIORI,"D2_COMIS1" )	 
		cGrupo 	  := (cTabela)->F2_VEND1		
		if empty(nComiss)
			nComiss:=Posicione("SA3",1,cFilSA3 + cGrupo ,"A3_COMIS" )
		EndIf
		
		RecLock("SE3",.T.)
			SE3->E3_VEND	:= cGrupo
			SE3->E3_NUM 	:= (cTabela)->D1_DOC
			SE3->E3_EMISSAO := (cTabela)->D1_EMISSAO
			SE3->E3_SERIE 	:= (cTabela)->D1_SERIE
			SE3->E3_CODCLI 	:= (cTabela)->F1_FORNECE
			SE3->E3_LOJA 	:= (cTabela)->F1_LOJA
			SE3->E3_BASE 	:= nQtdVend
			SE3->E3_PORC 	:= nComiss
			SE3->E3_COMIS 	:= ROUND((nQtdVend * nComiss)/100,2)
			SE3->E3_PREFIXO := (cTabela)->D1_SERIE
			SE3->E3_TIPO 	:= "NCC"
			SE3->E3_BAIEMI 	:= "E"
			SE3->E3_ORIGEM 	:= "D"
			SE3->E3_VENCTO 	:= (cTabela)->D1_EMISSAO
			SE3->E3_MOEDA 	:= "01"  
		MsUnLock()
	EndIf
		(cTabela)->(DbSkip())
EndDo	      
                          /*
//chama a rotina para geração do relatório
PrintErro(aErro)        */

Return


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PrintErro  ¦ Autor ¦ Arlindo Vieira       ¦ Data ¦ 18/04/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para geração do Relatório de erros                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
/*
Static Function PrintErro(aErro)
Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2     := "de acordo com os parametros informados pelo usuario."
Local cDesc3     := "Divergencia arquivos Seguro"
Local titulo     := "Divergencia arquivos Seguro"
Local nLin       := 80
Local Cabec1     := ""
Local Cabec2     := ""
Local aOrd       := {}

Private limite   := 132
Private tamanho  := "M"
Private nomeprog := "RSLOJR27" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo    := 15
Private aReturn  := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey := 0
Private m_pag    := 01
Private wnrel    := "RSLOJR27" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec1 := "Nom. Cliente                     CPF/CNPJ           Data da venda                   "
//         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   99999999            xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//         000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111
//         000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,aErro) },Titulo)
Return
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,aErro)
Local nX
Local nY
Local nAux

SetRegua(Len(aErro))

For nX:=1 To Len(aErro)
	
	IncRegua()
	
	If nLin > 60
		nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) + 1 //Impressao do cabecalho
	EndIf
	
	@ nLin,000 PSAY aErro[nX,1]
	@ nLin,33 PSAY aErro[nX,2] Picture "@R 999.999.999-99 "
	@ nLin,53 PSAY aErro[nX,3]
	nLin++
	@nLin,05  PSAY "Cod. Erro"
	@nLin++
	For nY:=1 to Len(aErro[nX,4]) Step 2
		@nLin,010 PSAY extraErro(nY,aErro[nX,4])
		@nLin,012 PSAY " - "
		@nLin,015 PSAY verErro(extraErro(nY,aErro[nX,4]))
		@nLin++
	Next
	nLin:=nLin+2
Next
@ nLin,001 PSAY "Total de registros ==>> "+Str(Len(aErro),5)

Roda(0,Space(10),Tamanho)
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return*/


