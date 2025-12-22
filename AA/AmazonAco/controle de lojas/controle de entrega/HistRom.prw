#INCLUDE "rwmake.ch"
//  .-----------------------------------------------------.
// |     Impressao do Historico do Romaneio - Template     |
//  '-----------------------------------------------------'

User Function HISTROM()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Histórico Do Romaneio"
Local nLin         := 80
Local cdFuncao     := FunName()

Local Cabec1       := "Sequência    Status Romaneio             Data/hora                  Resp.Recebimento "
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "M"
Private nomeprog         := "HIST_ROM" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := Padr("1",Len(SX1->X1_GRUPO))
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "HIST_ROM" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cNumOrc
Private cDoc
Private cSerie
Private nCnt      :=0
Private VetorDados :={}
Private VetorTest:={}
Private cString := "SZE"
Private VDadosSZE:={}

If Alltrim(cdFuncao) $ 'CONT_ENT'
  
    cNumOrc:=SZE->ZE_ORCAMEN
	cDoc   :=SZE->ZE_DOC
	cSerie :=SZE->ZE_SERIE
	
ELSE  
    ValidPerg()
	pergunte(cPerg,.F.)
	
	cNumOrc:=mv_par01
	cDoc   :=mv_par02
	cSerie :=mv_par03
	
ENDIF

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(8)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

dbGoTop()// Vai para o Inicio da tabela

/*
If lAbortPrint
@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
Exit
Endif
*/


VDadosSZE := u_DadosSZE()

FOR nCnt:=1 to len(VDadosSZE)
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		@nLin,00 PSAY "Cliente:"+VetorDados[nCnt][1]+"-"+VetorDados[nCnt][2]
		nLin++
		@nLin,00 PSAY "Bairro:"+VetorDados[nCnt][3]
		nLin++
		@nLin,00 PSAY "Num.Orçamento:"+VetorDados[nCnt][4]
		nLin++
		nLin++
	ENDIF
	
	@nLin,00 PSAY VetorDados[nCnt][5]
	
	IF VetorDados[nCnt][6]=="E"
		@nLin,13 PSAY "Entregue"
		
	ELSEIF VetorDados[nCnt][6]=="P"
		@nLin,13 PSAY "Pré Romaneio"
		
	ELSEIF VetorDados[nCnt][6]=="R"
		@nLin,13 PSAY "Em Romaneio"
		
	ELSEIF VetorDados[nCnt][6]=="B"
		@nLin,13 PSAY "Vem buscar na loja"
		
	ELSEIF VetorDados[nCnt][6]=="V"
		@nLin,13 PSAY "Nova entrega"
		
	ELSEIF VetorDados[nCnt][6]=="N"
		@nLin,13 PSAY "Endereço não encontrado"
		
	ELSEIF VetorDados[nCnt][6]=="F"
		@nLin,13 PSAY "Local fechado"
		
	ELSEIF VetorDados[nCnt][6]=="D"
		@nLin,13 PSAY "Devolução"
		
	ELSEIF VetorDados[nCnt][6]=="S"
		@nLin,13 PSAY "Estorno de Venda"
		
	ELSEIF Empty(VetorDados[nCnt][6])
		@nLin,13 PSAY "Em aberto"
		
	Endif
	
	@nLin,40 PSAY DTOC(VetorDados[nCnt][11])+" ÀS "+VetorDados[nCnt][12]
	
	@nLin,68 PSAY VetorDados[nCnt][13]
	
	
	nLin := nLin + 1 // Avanca a linha de impressao
	
next nCnt

if(len(VDadosSZE) > 1)
nLin++
@nLin,00 PSAY "Num.da Nota: "+VetorDados[1][7]+"-"+VetorDados[1][8]+"    Dt.Venda: "+DTOC(VetorDados[1][10])+"    Valor: "+ALLTRIM(transform (VetorDados[1][9],"@E 999,999,999.99"))
Endif

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

User Function DadosSZE()

dbSelectArea("SZE")
dbSetOrder(4)
dBgOtop()

SZE->(dbSeek(xFilial("SZE")+Padr(cDoc,Len(SZE->ZE_DOC)) + Padr(cSerie,Len(SZE->ZE_SERIE)) + Padr(cNumOrc,Len(SZE->ZE_ORCAMEN))))

While !SZE->(EOF()).AND.SZE->ZE_FILIAL==xFilial("SZE") .AND.;
	Padr(cDoc,Len(SZE->ZE_DOC)) + Padr(cSerie,Len(SZE->ZE_SERIE)) + Padr(cNumOrc,Len(SZE->ZE_ORCAMEN))==SZE->(ZE_DOC+ZE_SERIE+ZE_ORCAMEN)
	
	AADD (VetorDados,{SZE->ZE_CLIENTE,SZE->ZE_NOMCLI,SZE->ZE_BAIRRO,SZE->ZE_ORCAMEN,SZE->ZE_SEQ,SZE->ZE_STATUS,SZE->ZE_DOC,SZE->ZE_SERIE,;
	SZE->ZE_VALOR,SZE->ZE_DTVENDA,SZE->ZE_DTREC,SZE->ZE_HORREC,SZE->ZE_NOMREC,SZE->ZE_ORCAMEN })
	
	SZE->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	
ENDDO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o cancelamento pelo usuario...                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

bOrdem:={|a,b| a[5]>b[5]}
aSort(VetorDados,,,bOrdem)

Return(VetorDados)


Static Function ValidPerg()    



PutSX1(cPerg,"01",PADR("Orcamento           ?" ,29),PADR("Orcamento           ?" ,29),PADR("Orcamento           ?"   ,29),"mv_ch1","C",06,0,0,"G","","" ,""   ,"","","mv_par01")
PutSX1(cPerg,"02",PADR("Nota                ?" ,29),PADR("Nota                ?" ,29),PADR("Nota                ?"   ,29),"mv_ch2","C",09,0,0,"G","","" ,""   ,"","","mv_par02")
PutSX1(cPerg,"03",PADR("Serie               ?" ,29),PADR("Serie               ?" ,29),PADR("Serie               ?"   ,29),"mv_ch3","C",03,0,0,"G","","" ,""   ,"","","mv_par03")

Return
