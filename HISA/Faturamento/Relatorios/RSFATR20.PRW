#INCLUDE "rwmake.ch"

/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ RSFATR20   ¦ Autor ¦Orismar Silva         ¦ Data ¦ 14/08/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ RELGRU    ¦ Relatorio de Pedido de Venda para o Almoxarifado para a       ¦¦¦
¦¦¦           ¦ separação dos produtos para o cliente.                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

User Function RSFATR20()

Local cDesc1        := "Este programa ira emitir o Pedido de Venda, conforme"
Local cDesc2        := "os parametros solicitado"
Local cDesc3        := ""
Local titulo        := "Pedido de Venda"
Local nLin          := 80
Local Cabec1        := "Pedido de Venda"
Local Cabec2        := ""
Local aOrd 		     := ""
Local cPerg       := "RSFATR20"

Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "RSFATR20"
Private nTipo       := 10
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "RSFATR20"
Private cString     := "SC5"

// Cria as perguntas no SX1                                            
CriaSx1(cPerg)
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Cabec1 := "                                                                                                                                                                               Preço Referencial               Quantidade    "
//Cabec2 := " Produto                         Descrição do Produto                    Quantidade         Lote    Data Fabricação    Data Validade          Preço Venda               Unitário                Total       Caixa     Display"
Cabec2 := " Produto                         Descrição do Produto                    Quantidade         Lote    Data Fabricação    Data Validade                                                            Total       Caixa            "
//          9999999999999999  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA    999,999,999.999999    AAAAAAAAAA        99/99/9999       99/99/9999   999,999,999.999999     999,999,999.999999        999,999,999.99  999,999.99  999,999.99
//          0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)     

Return

*************************************************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin) 

Private cPedido	 := SC5->C5_NUM

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+mv_par01)

While !Eof() .And. SC5->C5_NUM >= mv_par01 .and. SC5->C5_NUM <= mv_par02

   If LEFT(DTOS(SC5->C5_EMISSAO),4) = MV_PAR03
      
      titulo   := "Pedido de Venda"
      _nToTal  := 0
      nTotVal  := 0
      nTotDesc := 0
      nTotVal1 := 0
      nVlrTot  := 0
      titulo   := ALLTRIM(titulo)+" - N. "+SC5->C5_NUM

      dbSelectArea("SC6")
      dbSetOrder(1)
      dbSeek(xFilial("SC6")+SC5->C5_NUM)

      While !Eof() .And. SC5->(C5_FILIAL+C5_NUM) == SC6->(C6_FILIAL+C6_NUM)
            
         nQtdCaixa := 0

         If nLin > 55
         
            nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
         
            @ nLin,000 PSAY "Cliente        :" +SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+ " - " +POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME");nLin++
            @ nLin,000 PSAY "Cidade/UF      :" +ALLTRIM(POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_MUN"))+"/"+POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST");nLin++
            @ nLin,000 PSAY "Ped. Cliente   :" +ALLTRIM(StrTran(StrTran(StrTran(SC5->C5_PEDCLI,"/",""),"-",""),".",""));nLin++
            @ nLin,000 PSAY "Cond. Pag      :" +SC5->C5_CONDPAG+" - " +POSICIONE("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI");nLin++
            @ nLin,000 PSAY "Vendedor       :" +ALLTRIM(SC5->C5_VEND1)+" - " +POSICIONE("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME");nLin++   
            @ nLin,000 PSAY "Tabela         :" +SC5->C5_TABELA;nLin++   
            cTransp := POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_TRANSP")
            @ nLin,000 PSAY "Transportadora :" +ALLTRIM(POSICIONE("SA4",1,xFilial("SA4")+cTransp,"A4_NOME"));nLin++  
            @ nLin,000 PSAY "Peso Bruto     :"	+Transform(SC5->C5_PBRUTO,TM(SC5->C5_PBRUTO,TamSX3("C5_PBRUTO")[1],TamSX3("C5_PBRUTO")[2]));nLin++
            @ nLin,000 PSAY "Peso Liquido   :"	+Transform(SC5->C5_PESOL,TM(SC5->C5_PESOL,TamSX3("C5_PESOL")[1],TamSX3("C5_PESOL")[2]));nLin++
            @ nLin,000 PSAY "Volume         :"	+Transform(SC5->C5_VOLUME1,TM(SC5->C5_VOLUME1,TamSX3("C5_VOLUME1")[1],TamSX3("C5_VOLUME1")[2]));nLin++

            if SC5->C5_PDESCAB > 0
               @ nLin,000 PSAY "Desconto       :"+Transform(SC5->C5_PDESCAB,TM(SC5->C5_PDESCAB,TamSX3("C5_PDESCAB")[1],TamSX3("C5_PDESCAB")[2]))+"%" ;nLin++  
            endif
            
            @nLin,000 PSAY Replicate("-",Limite)
            nLin++
            
         Endif

         @ nLin,000 PSAY SC6->C6_PRODUTO
         @ nLin,018 PSAY SC6->C6_DESCRI
         //@ nLin,063 PSAY Transform(SC6->C6_QTDVEN,TM(SC6->C6_QTDVEN,TamSX3("C6_QTDVEN")[1],TamSX3("C6_QTDVEN")[2]))
         @ nLin,063 PSAY Transform(SC6->C6_QTDVEN,"@E 999,999,999.9999")
         @ nLin,085 PSAY SC6->C6_LOTECTL
         @ nLin,103 PSAY DTOC(SC6->c6_FABRIC)
         @ nLin,120 PSAY DTOC(SC6->C6_DTVALID)	  
         @ nLin,133 PSAY Transform(SC6->C6_PRCVEN,TM(SC6->C6_PRCVEN,TamSX3("C6_PRCVEN")[1],TamSX3("C6_PRCVEN")[2]))
         nVlrTot := POSICIONE("DA1",1,xFilial("DA1")+SC5->C5_TABELA+SC6->C6_PRODUTO,"DA1_XPRCFI")*SC6->C6_QTDVEN
         @ nLin,156 PSAY Transform(POSICIONE("DA1",1,xFilial("DA1")+SC5->C5_TABELA+SC6->C6_PRODUTO,"DA1_XPRCFI"),"@E 999,999,999.999999")	   
         @ nLin,182 PSAY Transform(nVlrTot,TM(nVlrTot,TamSX3("C6_VALOR")[1],TamSX3("C6_VALOR")[2]))
         nQtdCaixa := POSICIONE("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_XCAIXA") 
         //nQtdDipla := POSICIONE("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_XDISPLA")
         @ nLin,198 PSAY Transform(ROUND(SC6->C6_QTDVEN/nQtdCaixa,2),"@E 999,999.99")
         //@ nLin,210 PSAY Transform(ROUND(SC6->C6_QTDVEN/nQtdDipla,2),"@E 999,999.99")	   	   

         nLin++

         _nToTal += SC6->C6_VALOR
         SC6->(dbSkip())

      EndDo

      nTotVal += _nToTal
      nTotVal += SC5->C5_FRETE
      nTotVal += SC5->C5_SEGURO
      nTotVal += SC5->C5_DESPESA
      nTotVal += SC5->C5_FRETAUT
      nTotDesc += ROUND((nTotVal*SC5->C5_PDESCAB/100),2)

      if SC5->C5_DESC1 > 0

         nTotVal1 += nTotVal-nTotDesc
         nTotDesc += Round((nTotVal1*SC5->C5_DESC1/100),2)

      endif

      nLin++
      @nLin,000 PSAY Replicate("-",Limite)
      nLin++
      @ nLin,000 PSAY "Total do Pedido ---->"
      @ nLin,040 PSAY Transform(nTotVal ,"@E 999,999,999.99")
      @ nLin,079 PSAY "Desconto: "
      @ nLin,120 PSAY Transform(nTotDesc  ,"@E 999,999,999.99")
      @ nLin,164 PSAY "="
      @ nLin,200 PSAY Transform(nTotVal-nTotDesc  ,"@E 999,999,999.99")
      nLin++
      @nLin,000 PSAY Replicate("-",Limite)
      nLin := nLin +3
      @ nLin,000 PSAY "Separado por :"
      @ nLin,016 PSAY "________________________________________"
      nLin := nLin +3
      @ nLin,000 PSAY "Conferido por:"
      @ nLin,016 PSAY "________________________________________"
      @ nLin,150 PSAY "Nota Fiscal:"                            
      @ nLin,163 PSAY "________________________________________"
      nLin := nLin +3
      @ nLin,000 PSAY "Responsável  :"
      @ nLin,016 PSAY "________________________________________"
      @ nLin,150 PSAY "Data  :"
      @ nLin,163 PSAY "_______/_______/___________"

      nLin++
      nLin := 60

   EndIf

   SC5->(dbSkip())

EndDo

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)                  	
Endif

MS_FLUSH()

Return 

//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1(cPerg)

	u_HMPutSX1(cPerg, "01", PADR("Do Pedido        ",29)+"?" ,"","", "mv_ch1" , "C", 6  , 0, 0, "G", "","SC5", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Pedido       ",29)+"?" ,"","", "mv_ch2" , "C", 6  , 0, 0, "G", "","SC5", "", "", "mv_par02")  
	u_HMPutSX1(cPerg, "03", PADR("Ano              ",29)+"?" ,"","", "mv_ch2" , "C", 4  , 0, 0, "G", "","   ", "", "", "mv_par03")  

Return
