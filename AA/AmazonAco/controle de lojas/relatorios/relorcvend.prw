#INCLUDE "rwmake.ch"

User Function relorcvend()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := ""
Local nLin         := 80
//                             1         2       3         4         5         6         7         8         9        10        11        12        13        14       15		 16        17        18        19        20        21
//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
LOCAL Cabec1       := "Num. Orçamento      Num. Nota          Data     Cliente                                           Valor  "
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "G"
Private nomeprog         := "Relatório de Orçamento por Vendedores" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := PAdr("relorcamen",len(SX1->X1_GRUPO))
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "relorcvend"   //Coloque aqui o nome do arquivo usado para impressao em disco
Private cCodvend   :=space(06)
Private nTotalgeral:=0
Private nTotalorcamento:=0

Private cString :="SL1"

dbSelectArea("SL1")  //VENDAS
dbSetOrder(3)

dbSelectArea("SA3")     //VENDEDOR
dbSetOrder(1)


ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

IF MV_PAR05==2
	
	Cabec1:= "Num. Orçamento      Num. Nota          Data     Cliente                                              Valor  "
	
ENDIF

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

dbSelectArea(cString)
dbSetOrder(3)        //Filial+Emissão


PRIVATE nTotal:=0 // valor total
PRIVATE nNumorcamento:=0  //Total de orçamentos


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())
dbGoTop()


IF !EMPTY (MV_PAR01)
	SL1->(dbSeek(xFilial("SL1")+MV_PAR01))
ENDIF

While !SL1->(EOF()).AND. SL1->L1_FILIAL==xFilial("SL1").AND. SL1->L1_VEND >=MV_PAR01 .And. SL1->L1_VEND <=MV_PAR02
	cCodvend:=SL1->L1_VEND
	SA3->(DbSeek(xFilial("SA3")+SL1->L1_VEND))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	
	//IF SL1->L1_VEND>=MV_PAR03 .And. SL1->L1_VEND<= MV_PAR04
	
	
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	IF !EMPTY(SL1->L1_NUM)
		@nLin,00 PSAY SA3->A3_COD+"-"+SA3->A3_NREDUZ
		nLin++
	ENDIF
	
	While !SL1->(EOF()).AND. SL1->L1_FILIAL==xFilial("SL1").AND. cCodvend==SL1->L1_VEND
		
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		
		IF SL1->L1_FILIAL == xFilial("SL1") .And. SL1->L1_EMISNF >= MV_PAR03 .And. SL1->L1_EMISNF <= MV_PAR04
			
			nNumorcamento++
			nTotal+=SL1->L1_VLRTOT
			nTotalgeral+=SL1->L1_VLRTOT
			nTotalorcamento++
			
			IF MV_PAR05==1
				
				
				@nLin,05 PSAY SL1->L1_NUM
				@nLin,19 PSAY SL1->L1_DOC+"-"+SL1->L1_SERIE
				@nLin,38 PSAY SL1->L1_EMISNF
				@nLin,50 PSAY SL1->L1_CLIENTE+"-"+SL1->L1_NOMCLI
				@nLin,93 PSAY transform (SL1->L1_VLRTOT,"@E 999,999,999.99")
				nLin := nLin + 1
			ENDIF
			
		ENDIF
		
		SL1->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		
	ENDDO
	@nLin,00 PSAY  "Total de Vendas:"
	@nLin,94 PSAY  transform (nTotal,"@E 999,999,999.99")
	nLin++
	@nLin,00 PSAY  "Numero de Orçamentos:"+CVALTOCHAR(nNumorcamento)
	nNumorcamento:=0
	nTotal:=0
	nLin++
	nLin++                                             
ENDDO
@nLin,00 PSAY  "Total De Atendimentos:"                                                  
@nLin,22 PSAY  transform (nTotalorcamento,"@E 999,999.99")
@nLin,35 PSAY  "Total Geral Vendido:"
@nLin,50 PSAY  transform (nTotalgeral,"@E 999,999,999.99")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ValidPerg(cPerg)
_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
aRegs :={}                                                                             //GET/COMBO
aAdd(aRegs,{cPerg,"01","Do Vendedor             ?", "" , "", "mv_ch1","C" ,06, 0 , 0 ,"G", "" , "MV_PAR01", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SA3",""})
aAdd(aRegs,{cPerg,"02","Ate o Vendedor          ?", "" , "", "mv_ch2","C" ,06, 0 , 0 ,"G", "" , "MV_PAR02", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SA3",""})
aAdd(aRegs,{cPerg,"03","Da Emissão              ?", "" , "", "mv_ch3","D" ,08, 0 , 0 ,"G", "" , "MV_PAR03", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Emissão           ?", "" , "", "mv_ch4","D" ,08, 0 , 0 ,"G", "" , "MV_PAR04", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Imprime                 ?", "" , "", "mv_ch5","N" ,01, 0 , 0 ,"C", "" , "MV_PAR05", "Analitico", "", "", "","","Sintetico","","","","","","","","","","","","","","","","",""," ","",""})


For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return

Static Function NewDlg1()
/*
A tag abaixo define a criação e ativação do novo diálogo. Você pode colocar esta tag
onde quer que deseje em seu código fonte. A linha exata onde esta tag se encontra, definirá
quando o diálogo será exibido ao usuário.
Nota: Todos os objetos definidos no diálogo serão declarados como Local no escopo da
função onde a tag se encontra no código fonte.
*/
Return