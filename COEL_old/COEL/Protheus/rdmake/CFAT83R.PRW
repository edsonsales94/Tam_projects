#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Cfat83R()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,_CTES")
SetPrvt("CABEC1,CABEC2,_FLAG,NLIN,M_PAG,_CINDTRB")
SetPrvt("_CCHATRB,_CCODVEND,_CNOMVEND,AREGS,I,J")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT83R  ³ Autor ³Adilson M Takeshima    ³ Data ³07/06/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Posicao de Pedidos de Vendas por Vendedor                  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
DbSelectArea("SC5")         //----> Cabec dos Pedidos de Vendas
DbSetOrder(7)               //----> Filial + Data Emissao + Cod Vendedor

DbSelectArea("SC6")         //----> Itens dos Pedidos de Vendas
DbSetOrder(1)               //----> Filial + Numero 
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"CODVEND" ,"C",08,0})
AADD(aEstru1,{"NOMEVEN" ,"C",30,0})
AADD(aEstru1,{"EMISSAO" ,"D",08,0})               
AADD(aEstru1,{"PEDCLI"  ,"C",10,0})
AADD(aEstru1,{"PEDSIGA" ,"C",06,0})
AADD(aEstru1,{"ATENDE"  ,"C",10,0})
AADD(aEstru1,{"PRODUTO" ,"C",08,0})
AADD(aEstru1,{"ITEM"    ,"C",02,0})
AADD(aEstru1,{"TES"     ,"C",03,0})
AADD(aEstru1,{"DESCRI"  ,"C",30,0})
AADD(aEstru1,{"QUANT"   ,"N",11,2})
AADD(aEstru1,{"ENTRE"   ,"N",11,2})
AADD(aEstru1,{"CLIFOR"  ,"C",06,0})
AADD(aEstru1,{"LOJA"    ,"C",02,0})
AADD(aEstru1,{"NOMECF"  ,"C",30,0})
AADD(aEstru1,{"STATUS"  ,"C",11,0})
AADD(aEstru1,{"DFAT"    ,"D",08,0})               
AADD(aEstru1,{"DENT"    ,"D",08,0})               
AADD(aEstru1,{"NOTA"    ,"C",06,0})
AADD(aEstru1,{"SALDO"   ,"N",11,2})

_cTemp1 := CriaTrab( aEstru1, .T. )  
//dbUseArea(.T.,__cRdd,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. ) 
dbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. ) 

*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
wnrel     := "CFAT83R"
cDesc1    := "Posicao de Pedidos" 
cDesc2    := " "
cDesc3    := " "
cString   := "SC5"
lEnd      := .F.
tamanho   := "G"
limite    := 220
titulo    := "POSICAO DE PEDIDOS DE VENDAS POR VENDEDOR"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFAT83R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT83R"
_cTes     := "501/502/503/504/505/508"
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Do    Vendedor ?                                          *
* mv_par02  ----> Ate o Vendedor ?                                          *
* mv_par03  ----> Da  Dt.Emissao ?                                          *
* mv_par04  ----> Ate Dt.Emissao ?                                          *
* mv_par05  ----> Situacao       ?                                          *
*                                                                           *
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

*---------------------------------------------------------------------------*
Processa({||RunProc()},"Filtrando Dados ...")// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Processa({||Execute(RunProc)},"Filtrando Dados ...")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC5")
DbSetOrder(7)
DbSeek(xFilial("SC5")+DTOS(mv_par03),.t.)
ProcRegua(RecCount())

Do While !Eof() .And. Dtos(SC5->C5_EMISSAO) <= Dtos(mv_par04)

   IncProc("Selecionando Dados do Pedido: "+SC5->C5_NUM)

   If  SC5->C5_VEND1 < mv_par01 .OR. SC5->C5_VEND1 > mv_par02
         dbSkip()
         Loop
   EndIf

   If  SC5->C5_TIPO <> "N"
       dbSkip()
       Loop
   Endif

    DbSelectArea("SC6")
    DbSetOrder(1)
    DbSeek(xFilial("SC6")+SC5->C5_NUM)

    While SC6->C6_NUM == SC5->C5_NUM

        
        DbSelectArea("TRB")
        RecLock("TRB",.t.)

          TRB->CODVEND  :=      SC5->C5_VEND1  
          TRB->NOMEVEN  :=      Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME")               
          TRB->EMISSAO  :=      SC5->C5_EMISSAO
          TRB->PEDCLI   :=      SC5->C5_CLPEDCL
          TRB->PEDSIGA  :=      SC5->C5_NUM   
          TRB->ATENDE   :=      SC5->C5_CLATEND
          TRB->PRODUTO  :=      SC6->C6_PRODUTO
          TRB->ITEM     :=      SC6->C6_ITEM
          TRB->TES      :=      SC6->C6_TES 
          TRB->DESCRI   :=      Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC")            
          TRB->QUANT    :=      SC6->C6_QTDVEN           
          TRB->ENTRE    :=      SC6->C6_QTDENT           
          TRB->CLIFOR   :=      SC5->C5_CLIENTE                
          TRB->LOJA     :=      SC5->C5_LOJACLI             
          TRB->NOMECF   :=      Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
          TRB->NOTA     :=      SC6->C6_NOTA                
          TRB->DENT     :=      SC6->C6_ENTREG     
                  
          IF  !EMPTY(SC6->C6_NOTA)
              TRB->DFAT     :=      SC6->C6_DATFAT
          ENDIF
          TRB->SALDO     :=      SC6->C6_QTDVEN - SC6->C6_QTDENT
	  IF TRB->SALDO == 0
	     TRB->STATUS := "FATURADO   "
	  ELSEIF TRB->ENTRE == 0
	     TRB->STATUS :=  "PENDENTE   "
	  ELSE
	      TRB->STATUS := "FAT.PARCIAL"
      ENDIF
      MsUnLock() 
            
      DbSelectArea("SC6")
      DbSkip()
    Enddo
       

    DbSelectArea("SC5")
    DbSkip()
EndDo

*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*

RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==>	   RptStatus({|| Execute(Imprime)},titulo)

/*/
0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
VENDEDOR: 999999 - 12345678901234567890
0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17
012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
PV.CLIENTE N/PED. EMISSAO  ATENDENTE  IT CODIGO   DESCRICAO                        QTD.PED. QTD.ENTR    SALDO STATUS      DT.ENTR  DATA FAT N.NOTA CLIENTE   NOME DO CLIENTE
1234567890 123456 99/99/99 1234567890 12 12345678 123456789012345678901234567890   99,999,9 99,999.9 99,999.9 FAT.PARCIAL 99/99/99 99/99/99 123456 999999-99 12345678901234567890
N/PED. PED.CLIENT
999999 1234567890
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function Imprime
Static Function Imprime()
cabec1  := "N/PED. PED.CLIENT EMISSAO  ATENDENTE  IT CODIGO   DESCRICAO                        QTD.PED. QTD.ENTR    SALDO STATUS      DT.ENTR  DATA FAT N.NOTA CLIENTE   NOME DO CLIENTE"
cabec2  := ""
titulo  := "POSICAO DE PEDIDOS DE VENDAS POR VENDEDOR"

_flag := 0
nLin := 7
m_pag := 1

DbSelectArea("TRB")
_cIndTRB := CriaTrab(Nil,.f.)
_cChaTRB := "TRB->CODVEND+TRB->PEDSIGA"
IndRegua("TRB",_cIndTRB,_cChaTRB,,,"Selecionando Registros TRB (Indice Temp) ...")
DbGoTop()
Setregua(Lastrec())
@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
Do While !Eof()
   Incregua()

   _cCodVend := TRB->CODVEND
   _cNomVend := TRB->NOMEVEN
   @nLin, 00 PSAY "VENDEDOR: "+ _cCodVend + " - " + _cNomVend
   nLin := nLin + 2

   Do While TRB->CODVEND == _cCodVend
      If  !TRB->TES$ Alltrim(_cTes)
          DbSkip()
          Loop
      Endif
      @nLin,  00 PSAY TRB->PEDSIGA
      @nLin,  07 PSAY TRB->PEDCLI
      @nLin,  18 PSAY TRB->EMISSAO   
      @nLin,  27 PSAY TRB->ATENDE    
      @nLin,  38 PSAY TRB->ITEM      
      @nLin,  41 PSAY TRB->PRODUTO
      @nLin,  50 PSAY TRB->DESCRI
      @nLin,  83 PSAY TRB->QUANT    PICTURE "@E 99,999.9"
      @nLin,  92 PSAY TRB->ENTRE    PICTURE "@E 99,999.9"
      @nLin, 101 PSAY TRB->SALDO    PICTURE "@E 99,999.9"
      @nLin, 110 PSAY TRB->STATUS      
      @nLin, 122 PSAY TRB->DENT
      @nLin, 131 PSAY TRB->DFAT
      @nLin, 140 PSAY TRB->NOTA
      @nLin, 147 PSAY TRB->CLIFOR
      @nLin, 153 PSAY "-"      
      @nLin, 154 PSAY TRB->LOJA
      @nLin, 157 PSAY TRB->NOMECF
      nLin := nLin + 1
      If nLin > 56                            
         @ nLin, 000 Psay Replicate("-",190)+"Continua na Proxima Pagina----"
         cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
         nLin := 7
      Endif
      DbSkip()
   Enddo
   @nLin , 000 PSAY Replicate("-",limite)
   nLin := nLin + 1
   DbSkip()
Enddo

If nLin > 59
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
   nLin := 7
Endif

Roda(cbCont,"Pedidos",tamanho)

SET DEVICE TO SCREEN

If aReturn[5] == 1 
   Set Printer TO
   dbCommitAll()
   OurSpool(wnrel)
Endif

DbCloseArea("TRB")
Ferase(_cTemp1+".dbf")
Ferase(_cTemp1+".idx")
Ferase(_cTemp1+".mem")

MS_FLUSH()

*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Do    Vendedor ? ','mv_ch1','C',06, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'02','Ate o Vendedor ? ','mv_ch2','C',06, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'03','Da  Dt.Emissao ? ','mv_ch3','D',08, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate Dt.Emissao ? ','mv_ch4','D',08, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Situacao       ? ','mv_ch5','C',01, 0, 3,'C', '', 'mv_par05','Pendentes','','','Faturados','','','Todos','','','','','','','',''})

    For i:=1 to len(aRegs)
        Dbseek(cPerg+strzero(i,2))
        If found() == .f.
            RecLock("SX1",.t.)
            For j:=1 to fcount()
                FieldPut(j,aRegs[i,j])
            Next
            MsUnLock()
        EndIf
    Next
EndIf

