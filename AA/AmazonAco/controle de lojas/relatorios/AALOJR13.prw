#INCLUDE "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AALOJR13   ¦ Autor ¦ Autor!!!!            ¦ Data ¦ xx/xx/20xx ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ descricao sincretica do programa    			              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
*/

User Function AALOJR13()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := ""
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Local cPerg          := PadR("AALOJR13",Len(SX1->X1_GRUPO))
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "AALOJR13" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "AALOJR13" // Coloque aqui o nome do arquivo usado para impressao em disco
Private aCabec       := {}
Private cString      := ""
Private aCol         := {01,07,40} //VETOR PARA AS ORIENTAÇÕES DAS COLUNAS DOS RELATORIOS

CreatePerg(cPerg)
Pergunte(cPerg,.F.)

//VETOR COM O CABECALHO E O TAMANHO DAS COLUNAS 
If mv_par05 = 1
	aCabec := {{"PREFI",5},{"NUMERO",11},{"EMISSAO",12},{"COD CLIENTE",6},{"CLIENTE",33},{"TIPO",6},{"DESCRICAO",33},{"VALOR",15}}
Else
	aCabec := {{"TIPO",6},{"DESCRICAO",33},{"VALOR",15}}
EndIf
//FAZ O CABEÇALHO
aEval(aCabec,{|aPrm| Cabec1 += Padc(aPrm[01],aPrm[02]) + "|" })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return Nil
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return  Nil
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ RUNREPORT  ¦ Autor ¦ Autor!!!!            ¦ Data ¦ xx/xx/20xx ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS    ¦¦¦
¦¦¦ Desc Cont ¦ monta a janela com a regua de processamento.			      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local aLinha    := {}
Local cTabela   := ""
Private aExport := {}


//VETOR COM O CABECALHO E O TAMANHO DAS COLUNAS 
If mv_par05 = 1
	aCabec := {{"PREFI",5},{"NUMERO",11},{"EMISSAO",12},{"COD CLIENTE",6},{"CLIENTE",33},{"TIPO",6},{"DESCRICAO",33},{"VALOR",15}}
Else
	aCabec := {{"TIPO",6},{"DESCRICAO",33},{"VALOR",15}}
EndIf
//FAZ O CABEÇALHO
aEval(aCabec,{|aPrm| Cabec1 += Padc(aPrm[01],aPrm[02]) + "|" })


cTabela := CriaTrab(Nil,.F.)
SetRegua(GERATABELA(cTabela))

aEval(aCabec,{|aPrm| aAdd(aLinha,aPrm[01])})
aAdd(aExport,aClone(aLinha))
aLinha := {}

While !(cTabela)->(EOF())
	
	/* Verifica o cancelamento pelo usuario...  */
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	/* Impressao do cabecalho do relatorio. . . */
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	//insire suas colunas aqui
	@nLin,aCol[01] Psay (cTabela)->E1_TIPO
	@nLin,aCol[02] Psay (cTabela)->X5_DESCRI
	@nLin,aCol[03] Psay (cTabela)->VALOR
	
	//exportação do vetor para excel
	If mv_par05 = 1
		aAdd(aLinha,(cTabela)->E1_PREFIXO)
		aAdd(aLinha,(cTabela)->E1_NUM)
		aAdd(aLinha,DTOC(STOD((cTabela)->E1_EMISSAO)))
		aAdd(aLinha,(cTabela)->E1_CLIENTE)
		aAdd(aLinha,(cTabela)->A1_NOME)
	EndIf
	aAdd(aLinha,(cTabela)->E1_TIPO)
	aAdd(aLinha,(cTabela)->X5_DESCRI)
	aAdd(aLinha,TRANSFORM((cTabela)->VALOR,"@E 999,999,999.99"))
	
	aAdd(aExport,aClone(aLinha))
	aLinha := {}
	
	nLin := nLin + 1 // Avanca a linha de impressao
	
	(cTabela)->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

(cTabela)->(DbCloseArea())

aAdd(aExport,aClone(aLinha))
aLinha := {}
If mv_par05 = 2
	GERATABEL2(cTabela)
	While !(cTabela)->(EOF())
		//exportação do vetor para excel
		aAdd(aLinha,(cTabela)->E1_TIPO)
		aAdd(aLinha,(cTabela)->X5_DESCRI)
		aAdd(aLinha,TRANSFORM((cTabela)->VALOR,"@E 999,999,999.99"))
		
		aAdd(aExport,aClone(aLinha))
		aLinha := {}
		
		(cTabela)->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo
	
	(cTabela)->(DbCloseArea())
	
endif

/* Finaliza a execucao do relatorio...   */

SET DEVICE TO SCREEN

/* Se impressao em disco, chama o gerenciador de impressao...  */

//função de exportação para o excel
MsgRun("Exportando Dados, Aguarde...",,{|| Exporta()})

MS_FLUSH()

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GeraTabela ¦ Autor ¦ Autor!!!!            ¦ Data ¦ xx/xx/20xx ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Funcao auxiliar para a geração da tabela temporaria			  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
*/

Static Function GeraTabela(cTabela)
Local cQry := ""
Local cCampos := " * "

if mv_par05 = 2
	//ADEQUE A QUERY AQUI
	cQry +=                     " Select Count(*) NUMEROS From (
	
	cQry += Chr(13) + Chr(10) + " SELECT E1_TIPO, LTRIM(RTRIM(X5_DESCRI)) X5_DESCRI, ISNULL(SUM(VALOR),0) VALOR FROM ( "
	cQry += Chr(13) + Chr(10) + " SELECT CASE WHEN E1_TIPO IN ('BO','NF','CR') THEN 'CLI' ELSE E1_TIPO END E1_TIPO, CASE WHEN E1_TIPO IN ('BO','NF','CR') THEN 'CLIENTE' ELSE X5_DESCRI END X5_DESCRI , CASE WHEN E1_TIPO IN ('CC','CD','FI') THEN SUM(E1_VLRREAL) ELSE SUM(E1_VALOR) END VALOR FROM " + RetSqlName("SE1") +" SE1 WITH (NOLOCK) "
	cQry += Chr(13) + Chr(10) + " INNER JOIN SF2010 SF2 WITH (NOLOCK) ON F2_DOC = E1_NUM AND F2_SERIE = E1_PREFIXO AND F2_FILIAL = E1_FILORIG AND SE1.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " LEFT JOIN " + RetSqlName("SX5") +" SX5 WITH (NOLOCK) ON X5_TABELA = '24' AND X5_CHAVE = E1_TIPO AND SX5.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " WHERE SE1.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " AND E1_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' " "
	cQry += Chr(13) + Chr(10) + " AND E1_FILORIG BETWEEN '"+mv_par03+"' and '"+mv_par04+"' "
	cQry += Chr(13) + Chr(10) + " AND E1_ORIGEM NOT IN ('MATA100 ','FINA040 ') "
	cQry += Chr(13) + Chr(10) + " GROUP BY E1_TIPO,X5_DESCRI "
	cQry += Chr(13) + Chr(10) + " ) X "
	cQry += Chr(13) + Chr(10) + " GROUP BY E1_TIPO,X5_DESCRI "
	
	cQry += Chr(13) + Chr(10) + " UNION "
	
	cQry += Chr(13) + Chr(10) + " SELECT 'RES' E1_TIPO, 'RESERVA' X5_DESCRI , ISNULL(SUM(D2_TOTAL+D2_ICMSRET),0) VALOR 
   cQry += Chr(13) + Chr(10) + " 	  FROM " + RetSqlName("SD2") +" SD2 WITH (NOLOCK) "
	cQry += Chr(13) + Chr(10) + " LEFT JOIN " + RetSqlName("SE1") +" SE1 WITH (NOLOCK) ON D2_DOC = E1_NUM AND D2_SERIE = E1_PREFIXO AND D2_FILIAL = E1_FILORIG AND SE1.D_E_L_E_T_ = '' "
 	cQry += Chr(13) + Chr(10) + " LEFT JOIN " + RetSqlName('SF4') +" SF4 WITH (NOLOCK) ON F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " WHERE D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
	cQry += Chr(13) + Chr(10) + " AND 
	cQry += Chr(13) + Chr(10) + "    (  SUBSTRING(D2_CF,2,3) IN ('101','102','401','405','107','108','109','110','403','404','122','118','119') "
	cQry += Chr(13) + Chr(10) + "    Or ( SUBSTRING(D2_CF,2,3) In('949')  And F4_DUPLIC = 'S')  )
	cQry += Chr(13) + Chr(10) + " AND D2_FILIAL BETWEEN '"+mv_par03+"' and '"+mv_par04+"' "
	cQry += Chr(13) + Chr(10) + " AND SD2.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " AND  E1_TIPO IS NULL"
	//cQry += Chr(13) + Chr(10) + " )A
	
	cQry += Chr(13) + Chr(10) + " UNION "
	
	cQry += Chr(13) + Chr(10) + " Select 'RES'+E1_TIPO  E1_TIPO, 'RESERVA-'+X5_DESCRI X5_DESCRI , SUM(CASE WHEN E1_VALOR < E1_VLRREAL THEN E1_VLRREAL ELSE E1_VALOR END)  VALOR  "
   cQry += Chr(13) + Chr(10) + " 	 from " + RetSqlName('SE1') + " E1 with(nolock) "
   cQry += Chr(13) + Chr(10) + "     Left Outer Join " + RetSqlName('SF2') + " F2 WITH(NOLOCK) on F2_DOC = E1_NUM ANd F2_SERIE = E1_PREFIXO And F2_FILIAL = E1_FILORIG and F2.D_E_L_E_T_ = '' "
  	cQry += Chr(13) + Chr(10) + "     LEFT JOIN " + RetSqlName("SX5") +" SX5 WITH (NOLOCK) ON X5_TABELA = '24' AND X5_CHAVE = E1_TIPO AND SX5.D_E_L_E_T_ = '' "
   cQry += Chr(13) + Chr(10) + " Where E1.D_E_L_E_T_ = '' "
   cQry += Chr(13) + Chr(10) + " And E1_TIPO In('CC','CD','CH','CR','FI','R$') "
   cQry += Chr(13) + Chr(10) + " And E1_FILORIG BETWEEN '"+mv_par03+"' and '"+mv_par04+"' "
  	cQry += Chr(13) + Chr(10) + " And E1_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
   cQry += Chr(13) + Chr(10) + " And E1_ORIGEM In ('LOJA701','FATA701') "
   cQry += Chr(13) + Chr(10) + " AND F2_DOC IS NULL "
   cQry += Chr(13) + Chr(10) + "  Group by 'RES'+E1_TIPO , 'RESERVA-'+X5_DESCRI
  	cQry += Chr(13) + Chr(10) + " ) A
	
else
	
	cQry +=                     " Select Count(*) NUMEROS From (
	
	cQry += Chr(13) + Chr(10) + " SELECT E1_PREFIXO, E1_NUM, E1_EMISSAO, E1_CLIENTE , A1_NOME,E1_TIPO, LTRIM(RTRIM(X5_DESCRI)) X5_DESCRI, ISNULL(SUM(VALOR),0) VALOR FROM ( "
	cQry += Chr(13) + Chr(10) + " SELECT E1_PREFIXO, E1_NUM, E1_EMISSAO, E1_CLIENTE , A1_NOME,CASE WHEN E1_TIPO IN ('BO','NF','CR') THEN 'CLI' ELSE E1_TIPO END E1_TIPO, CASE WHEN E1_TIPO IN ('BO','NF','CR') THEN 'CLIENTE' ELSE X5_DESCRI END X5_DESCRI , CASE WHEN E1_TIPO IN ('CC','CD','FI') THEN SUM(E1_VLRREAL) ELSE SUM(E1_VALOR) END VALOR FROM " + RetSqlName("SE1") +" SE1 WITH (NOLOCK) "
	cQry += Chr(13) + Chr(10) + " INNER JOIN SF2010 SF2 WITH (NOLOCK) ON F2_DOC = E1_NUM AND F2_SERIE = E1_PREFIXO AND F2_FILIAL = E1_FILORIG AND SE1.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " LEFT JOIN " + RetSqlName("SX5") +" SX5 WITH (NOLOCK) ON X5_TABELA = '24' AND X5_CHAVE = E1_TIPO AND SX5.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " LEFT JOIN " + RetSqlName("SA1") +" SA1 WITH (NOLOCK) ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " WHERE SE1.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " AND E1_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' " "
	cQry += Chr(13) + Chr(10) + " AND E1_FILORIG BETWEEN '"+mv_par03+"' and '"+mv_par04+"' "
	cQry += Chr(13) + Chr(10) + " AND E1_ORIGEM NOT IN ('MATA100 ','FINA040 ') "
	cQry += Chr(13) + Chr(10) + " GROUP BY E1_PREFIXO, E1_NUM, E1_EMISSAO, E1_CLIENTE , A1_NOME,E1_TIPO,X5_DESCRI "
	cQry += Chr(13) + Chr(10) + " ) X "
	cQry += Chr(13) + Chr(10) + " GROUP BY E1_PREFIXO, E1_NUM, E1_EMISSAO, E1_CLIENTE , A1_NOME,E1_TIPO,X5_DESCRI "
	
	cQry += Chr(13) + Chr(10) + " UNION "
	
	cQry += Chr(13) + Chr(10) + " SELECT                                     "
	cQry += Chr(13) + Chr(10) + "  D2_SERIE E1_PREFIXO,                      "
	cQry += Chr(13) + Chr(10) + "  D2_DOC E1_NUM,                            "
	cQry += Chr(13) + Chr(10) + "  D2_EMISSAO E1_EMISSAO,                    "
	cQry += Chr(13) + Chr(10) + "  D2_CLIENTE E1_CLIENTE ,                   "
	cQry += Chr(13) + Chr(10) + "  A1_NOME,                                  "
	cQry += Chr(13) + Chr(10) + "  'RES' E1_TIPO,                            "
	cQry += Chr(13) + Chr(10) + "  'RESERVA' X5_DESCRI ,                     "
	cQry += Chr(13) + Chr(10) + "  ISNULL(SUM(D2_TOTAL+D2_ICMSRET),0) VALOR  "
	
	cQry += Chr(13) + Chr(10) + " FROM " + RetSqlName("SD2") +" SD2 WITH (NOLOCK) "
	cQry += Chr(13) + Chr(10) + " LEFT JOIN " + RetSqlName("SE1") +" SE1 WITH (NOLOCK) ON D2_DOC = E1_NUM AND D2_SERIE = E1_PREFIXO AND D2_FILIAL = E1_FILORIG AND SE1.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " LEFT JOIN " + RetSqlName("SA1") +" SA1 WITH (NOLOCK) ON A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " LEFT JOIN " + RetSqlName('SF4') +" SF4 WITH (NOLOCK) ON F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " WHERE D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
	cQry += Chr(13) + Chr(10) + " AND 
	cQry += Chr(13) + Chr(10) + "    (  SUBSTRING(D2_CF,2,3) IN ('101','102','401','405','107','108','109','110','403','404','122','118','119') "
	cQry += Chr(13) + Chr(10) + "    Or ( SUBSTRING(D2_CF,2,3) In('949')  And F4_DUPLIC = 'S')  )
	cQry += Chr(13) + Chr(10) + " AND D2_FILIAL BETWEEN '"+mv_par03+"' and '"+mv_par04+"' "
	cQry += Chr(13) + Chr(10) + " AND SD2.D_E_L_E_T_ = '' "
	cQry += Chr(13) + Chr(10) + " AND  E1_TIPO IS NULL "
	cQry += Chr(13) + Chr(10) + " GROUP BY D2_SERIE, D2_DOC, D2_CLIENTE, D2_EMISSAO, A1_NOME "
	
	cQry += Chr(13) + Chr(10) + " UNION "
	
	cQry += Chr(13) + Chr(10) + " Select E1_PREFIXO,
   cQry += Chr(13) + Chr(10) + "        E1_NUM    ,
   cQry += Chr(13) + Chr(10) + "        E1_EMISSAO,
   cQry += Chr(13) + Chr(10) + "        E1_CLIENTE, 
   cQry += Chr(13) + Chr(10) + "        A1_NOME   ,
   cQry += Chr(13) + Chr(10) + "        'RES'+E1_TIPO E1_TIPO,
   cQry += Chr(13) + Chr(10) + "        'RESERVA'+X5_DESCRI X5_DESCRI, 
   cQry += Chr(13) + Chr(10) + "        sum( CASE WHEN E1_VALOR < E1_VLRREAL THEN E1_VLRREAL ELSE E1_VALOR END )  VALOR  
   cQry += Chr(13) + Chr(10) + " 	 from " + RetSqlName('SE1') + " E1 With(nolock) "
   cQry += Chr(13) + Chr(10) + "     Left Outer Join " + RetSqlName('SF2') + " F2 WITH(NOLOCK) on F2_DOC = E1_NUM ANd F2_SERIE = E1_PREFIXO And F2_FILIAL = E1_FILORIG and F2.D_E_L_E_T_ = '' "
 	cQry += Chr(13) + Chr(10) + "     LEFT JOIN " + RetSqlName("SA1") +" SA1 WITH (NOLOCK) ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = '' "
  	cQry += Chr(13) + Chr(10) + "     LEFT JOIN " + RetSqlName("SX5") +" SX5 WITH (NOLOCK) ON X5_TABELA = '24' AND X5_CHAVE = E1_TIPO AND SX5.D_E_L_E_T_ = '' "
   cQry += Chr(13) + Chr(10) + " Where E1.D_E_L_E_T_ = '' "
   cQry += Chr(13) + Chr(10) + " And E1_TIPO In('CC','CD','CH','CR','FI','R$') "
   cQry += Chr(13) + Chr(10) + " And E1_FILORIG BETWEEN '"+mv_par03+"' and '"+mv_par04+"' "
  	cQry += Chr(13) + Chr(10) + " And E1_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
   cQry += Chr(13) + Chr(10) + " And E1_ORIGEM In ('LOJA701','FATA701') "
   cQry += Chr(13) + Chr(10) + " AND F2_DOC IS NULL "
   cQry += Chr(13) + Chr(10) + " GROUP BY E1_PREFIXO, E1_NUM, E1_CLIENTE, E1_EMISSAO, A1_NOME ,'RES'+E1_TIPO,'RESERVA'+X5_DESCRI "
   
	cQry += Chr(13) + Chr(10) + " ) A
endif

//SALVA A QUERY DENTRO SYSTEM PARA EVENTUAIS CONSULTAS
MemoWrit("AALOJR13.sql",cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTabela,.T.,.T.)
//OBTEM O NUMERO DE REGISTROS DA CONSULTA
nCont := (cTabela)->NUMEROS
(cTabela)->(dbCloseArea(cTabela))
//FAZ A SUBSTITUIÇÃO DA CONTAGEM PELOS CAMPOS QUE DEVEM SER BUSCADOS
cQry := StrTran(cQry,"Count(*) NUMEROS",cCampos)
//RETORNA A TABELA TEMPORARIA
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTabela,.T.,.T.)

Return nCont

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CreatePerg ¦ Autor ¦ Autor!!!!            ¦ Data ¦ xx/xx/20xx ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Funcao auxiliar para a geração dos parametros do relatorio	  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
*/

Static Function CreatePerg(cPerg)
Local nPerg := Len(SX1->X1_PERGUNT)

PutSX1(cPerg, "01", PadR("Data De  ",nPerg - 1) + "?" ,PadR("Data OF",nPerg - 1) + "?",PadR("Data De  ",nPerg - 1) + "?", "mv_ch1", "D",8, 0, 0, "G", "", "", "", "", "mv_par01")
PutSX1(cPerg, "02", PadR("Data Ate ",nPerg - 1) + "?" ,PadR("Data OF"  ,nPerg - 1) + "?",PadR("Data Ate ",nPerg - 1) + "?", "mv_ch2", "D",8, 0, 0, "G", "", "", "", "", "mv_par02")

PutSX1(cPerg, "03", PadR("Filial De ",nPerg - 1) + "?" ,PadR("From Part Number",nPerg - 1) + "?",PadR("Produto De  ",nPerg - 1) + "?", "mv_ch3", "C",2, 0, 0, "G", "", "", "", "", "mv_par03")
PutSX1(cPerg, "04", PadR("Filial Ate",nPerg - 1) + "?" ,PadR("To Part Number"  ,nPerg - 1) + "?",PadR("Produto Ate ",nPerg - 1) + "?", "mv_ch4", "C",2, 0, 0, "G", "", "", "", "", "mv_par04")

PutSX1(cPerg, "05", "Tipo :", "", "", "mv_ch5", "N", 01, 0, 0, "C", "", ""   , "", "", "mv_par05",;
"Analitico","","","","Sintetico","","","","","","","","","","","","","","","")

Return Nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ Exporta()  ¦ Autor ¦ Autor!!!!            ¦ Data ¦ xx/xx/20xx ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Funcao auxiliar para a geração do excel     				  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
*/

Static Function Exporta()

Local cArqTxt    := GetTempPath()+Str(Randomize(1,1000))+"Report.xls"
Local nHdl       := fCreate(cArqTxt)
Local cLinha     := ""

If !File(cArqTXT)
	MsgStop("O Arquivo " + cArqTXT + " não pode ser Criado!")
	Return nil
EndIf

For i:=1 to Len(aExport)
	cLinha := ""
	IncRegua()
	If ValType(aExport[i])<>"A"
		cLinha += aExport[i]
	Else
		For j := 1 to Len(aExport[i])
			cLinha += aExport[i][j]+Chr(9)
		Next
	Endif
	
	cLinha += chr(13)+chr(10)
	
	If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	EndIf
Next

fClose(nHdl)
RunExcel(cArqTxt)
Return Nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ RunExcel() ¦ Autor ¦ Autor!!!!            ¦ Data ¦ xx/xx/20xx ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Funcao auxiliar para a geração do excel     				  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
*/

Static Function RunExcel(cwArq)
Local oExcelApp
Local aNome := {}

If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
	MsgStop( 'MsExcel nao instalado' )
	Return
EndIf
oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
oExcelApp:WorkBooks:Open(cwArq)
oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.

Return


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GeraTabel2 ¦ Autor ¦ Autor!!!!            ¦ Data ¦ xx/xx/20xx ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Funcao auxiliar para a geração da tabela temporaria			  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
*/

Static Function GeraTabel2(cTabela)
Local cQry := ""
Local cCampos := " * "

//ADEQUE A QUERY AQUI
cQry +=                     " Select Count(*) NUMEROS From (

cQry += Chr(13) + Chr(10) + " SELECT E1_TIPO, LTRIM(RTRIM(X5_DESCRI)) X5_DESCRI, ISNULL(SUM(VALOR),0) VALOR FROM ( "
cQry += Chr(13) + Chr(10) + " SELECT E1_TIPO, X5_DESCRI , SUM(E1_VALOR) VALOR FROM " + RetSqlName("SE1") +" SE1 WITH (NOLOCK) "
cQry += Chr(13) + Chr(10) + " INNER JOIN SF2010 SF2 WITH (NOLOCK) ON F2_DOC = E1_NUM AND F2_SERIE = E1_PREFIXO AND F2_FILIAL = E1_FILORIG AND SE1.D_E_L_E_T_ = '' "
cQry += Chr(13) + Chr(10) + " LEFT JOIN " + RetSqlName("SX5") +" SX5 WITH (NOLOCK) ON X5_TABELA = '24' AND X5_CHAVE = E1_TIPO AND SX5.D_E_L_E_T_ = '' "
cQry += Chr(13) + Chr(10) + " WHERE SE1.D_E_L_E_T_ = '' "
cQry += Chr(13) + Chr(10) + " AND E1_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' " "
cQry += Chr(13) + Chr(10) + " AND E1_FILORIG BETWEEN '"+mv_par03+"' and '"+mv_par04+"' "
cQry += Chr(13) + Chr(10) + " AND E1_ORIGEM NOT IN ('MATA100 ','FINA040 ') "
cQry += Chr(13) + Chr(10) + " AND E1_TIPO IN ('CR','BO', 'NF') "
cQry += Chr(13) + Chr(10) + " GROUP BY E1_TIPO,X5_DESCRI "
cQry += Chr(13) + Chr(10) + " ) X "
cQry += Chr(13) + Chr(10) + " GROUP BY E1_TIPO,X5_DESCRI "
cQry += Chr(13) + Chr(10) + " ) A

cQry := StrTran(cQry,"Count(*) NUMEROS",cCampos)
//RETORNA A TABELA TEMPORARIA
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cTabela,.T.,.T.)

Return nIL
