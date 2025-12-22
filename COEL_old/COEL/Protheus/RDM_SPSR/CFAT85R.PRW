#include "rwmake.ch"

User Function Cfat85r()

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NTOTNF,_NTOTVL,_CNOMECLI,CABEC1,CABEC2")
SetPrvt("_NCONTADOR,_DDATA,_NOTA,AREGS,I,J")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT85R  ³ Autor ³Adilson M Takeshima    ³ Data ³03/05/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Notas Fiscais de Saidas Emitidas por Ordem de Numero       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda - expecifico para Expedicao  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
DbSelectArea("SD2")         //----> Itens da Nota Fiscal de Saida
DbSetOrder(3)               //----> Numero + Serie + Cliente

DbSelectArea("SF2")         //----> Cabecalho de Notas de Saidas
//DbSetOrder(6)               //----> Filial + Data Emissao + Documento + Serie
//dbOrderNickName("SF26")

*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*

wnrel     := "CFAT85R"
cDesc1    := "Relacao de Notas de Saidas"
cDesc2    := " "
cDesc3    := " "
cString   := "SD2"
lEnd      := .F.
tamanho   := "P"
limite    := 80
titulo    := "RELACAO DE NOTAS FISCAIS DE SAIDA"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFAT85R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT85R"
nLin      := 7
m_pag     := 1
_nTotNF   := { 0, 0}
_nTotVL   := { 0, 0}
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da Emissao     ?                                          *
* mv_par02  ----> Ate Emissao    ?                                          *
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
* Processamento                                                             *
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Filtrando Dados ...")
Return

Static Function RunProc()


*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"EMISSAO" ,"D",08,0})
AADD(aEstru1,{"NOTA"    ,"C",09,0})
AADD(aEstru1,{"TPN"     ,"C",01,0})
AADD(aEstru1,{"TOTNF"   ,"N",12,2})
AADD(aEstru1,{"CLIENTE" ,"C",06,0})
AADD(aEstru1,{"LOJA"    ,"C",02,0})
AADD(aEstru1,{"NOMEC"   ,"C",30,0})
AADD(aEstru1,{"ITNOTA"  ,"C",02,0})
AADD(aEstru1,{"CODIGO"  ,"C",15,0})
AADD(aEstru1,{"DESCRI"  ,"C",30,0})
AADD(aEstru1,{"QUANT"   ,"N",09,2})
AADD(aEstru1,{"PEDIDO"  ,"C",06,0})
AADD(aEstru1,{"ITEMPV"  ,"C",02,0})
AADD(aEstru1,{"TES"     ,"C",03,0})
AADD(aEstru1,{"CFO"     ,"C",04,0})

_cTemp1 := CriaTrab( aEstru1, .T. )
//dbUseArea(.T.,__cRdd,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )
dbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. )

DbSelectArea("SF2")
//DbSetOrder(6)               //----> Filial + Data Emissao + Documento + Serie
//dbOrderNickName("SF26")

//DbSeek(xFilial("SF2")+Dtos(mv_par01),.t.)
ProcRegua(RecCount())

//
//     INICIO DOS FILTROS DOS PARAMETROS NO SF2 CAB NOTAS FISCAIS
//
cQry  := "SELECT * FROM "+RetSqlName("SF2")
cQry  += " WHERE D_E_L_E_T_ = ' ' AND F2_FILIAL = '"+xFilial("SF2")+"' "
cQry  += " AND F2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQry  += " ORDER BY F2_EMISSAO,F2_DOC,F2_SERIE "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB3', .T., .T.)

TcSetField("TB3","F2_EMISSAO","D",08,0)
TcSetField("TB3","F2_VALBRUT","N",15,2)
TcSetField("TB3","F2_QUANT","N",11,2)

dbSelectArea("TB3")
dbGoTop()
Do While !Eof() //.And. TB3->F2_EMISSAO <= mv_par02
    IncProc("Selecionando Dados da NOTA: "+TB3->F2_DOC)

        If  TB3->F2_TIPO$ "N/C/I/P"
            _cNomeCli := Posicione("SA1",1,xFilial("SA1")+TB3->F2_CLIENTE + TB3->F2_LOJA,"A1_NOME")
        Else
            _cNomeCli := Posicione("SA2",1,xFilial("SA2")+TB3->F2_CLIENTE + TB3->F2_LOJA,"A2_NOME")
        Endif

    DbSelectArea("SD2")
    DbSeek(xFilial("SD2")+TB3->F2_DOC+TB3->F2_SERIE)
    Do While SD2->D2_DOC+SD2->D2_SERIE == TB3->F2_DOC+TB3->F2_SERIE

        DbSelectArea("TRB")
        RecLock("TRB",.t.)

          TRB->EMISSAO  :=      TB3->F2_EMISSAO
          TRB->NOTA     :=      SUBSTR(TB3->F2_DOC,4,6)
          TRB->TPN      :=      TB3->F2_TIPO
          TRB->TOTNF    :=      TB3->F2_VALBRUT
          TRB->TES      :=      SD2->D2_TES
          TRB->CFO      :=      SD2->D2_CF
          TRB->CLIENTE  :=      TB3->F2_CLIENTE
          TRB->LOJA     :=      TB3->F2_LOJA
          TRB->NOMEC    :=      _cNomeCli
          TRB->ITNOTA   :=      SD2->D2_ITEM
          TRB->CODIGO   :=      SD2->D2_COD
          TRB->DESCRI   :=      Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_DESC")
          TRB->QUANT    :=      SD2->D2_QUANT
          TRB->PEDIDO   :=      SD2->D2_PEDIDO
          TRB->ITEMPV   :=      SD2->D2_ITEMPV

        MsUnLock()

        DbSelectArea("SD2")
        DbSkip()
    EndDo

    DbSelectArea("TB3")
    DbSkip()
EndDo

TB3->(dbCloseArea())

*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*

#IFDEF WINDOWS
    RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>     RptStatus({|| Execute(Imprime)},titulo)
#ELSE
    Imprime()
#ENDIF


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Imprime
Static Function Imprime()

cabec1  := "DATA     NUM.NF TIPO  TOTAL DA NOTA CLIENTE   NOME DO CLIENTE"
cabec2  := ""
titulo  := "RELACAO DE NOTAS FISCAIS DE SAIDAS"

_nContador := 0

DbSelectArea("TRB")
DbGoTop()
Setregua(Lastrec())
@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
nLin := nLin + 1
Do While !Eof()
   Incregua()

  _ddata := TRB->EMISSAO

   @ nLin, 00 PSAY TRB->EMISSAO
   @ nLin, 09 PSAY TRB->NOTA
  /*
   If  TRB->TPN == "N"
          @ nLin, 16 PSAY "NORM"
     elseif TRB->TPN == "C"
          @ nLin, 16 PSAY "CPRE"
     elseif TRB->TPN == "I"
          @ nLin, 16 PSAY "CICM"
     elseif TRB->TPN == "P"
          @ nLin, 16 PSAY "CIPI"
     elseif TRB->TPN == "B"
          @ nLin, 16 PSAY "BENF"
     elseif TRB->TPN == "D"
          @ nLin, 16 PSAY "DEVL"
   Endif
    */
   @ nLin, 19 PSAY TRB->TPN 
   @ nLin, 21 PSAY TRB->TOTNF  PICTURE "@E 999,999,999.99"
   @ nLin, 36 PSAY TRB->CLIENTE
   @ nLin, 42 PSAY "-"
   @ nLin, 43 PSAY TRB->LOJA
   @ nLin, 46 PSAY TRB->NOMEC
   nLin := nLin + 1
   @ nLin, 00 PSAY "      ITEM CODIGO   DESCRICAO                      QUANTIDADE NR.PED IT TES CFO"
   nLin := nLin + 1

   _nota := TRB->NOTA
   _nTotNF[1] := _nTotNF[1] + 1
   _nTotNF[2] := _nTotNF[2] + 1
   _nTotVL[1] := _nTotVL[1] + TRB->TOTNF
   _nTotVL[2] := _nTotVL[2] + TRB->TOTNF

   Do  While _nota == TRB->NOTA
       @ nLin, 07 PSAY TRB->ITNOTA
       @ nLin, 11 PSAY SUBS(TRB->CODIGO,1,9)
       @ nLin, 21 PSAY TRB->DESCRI
       @ nLin, 52 PSAY TRB->QUANT    PICTURE "@E 999,999.99"
       @ nLin, 63 PSAY TRB->PEDIDO
       @ nLin, 70 PSAY TRB->ITEMPV  
       @ nLin, 73 PSAY TRB->TES
       @ nLin, 77 PSAY TRB->CFO
       nLin := nLin + 1
       If nLin > 59
          @ nLin, 000 Psay Replicate("-",50)+"Continua na Proxima Pagina----"
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
          nLin := 7
          @ nLin, 00 PSAY "      ITEM CODIGO   DESCRICAO                      QUANTIDADE NR.PED IT TES CFO"
          nLin := nLin + 1
       Endif

       DbSkip()
   Enddo
       If nLin > 56
          @ nLin, 000 Psay Replicate("-",50)+"Continua na Proxima Pagina----"
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
          nLin := 7
          @ nLin, 00 PSAY "      ITEM CODIGO   DESCRICAO                      QUANTIDADE NR.PED IT TES CFO"
          nLin := nLin + 1
       Endif

   @ nLin , 00 PSAY Replicate("-",limite)
   nLin := nLin + 1
   If   _ddata <> TRB->EMISSAO
        If   nLin > 56
             @ nLin, 000 Psay Replicate("-",50)+"Continua na Proxima Pagina----"
             cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
             nLin := 7
        Endif

        @ nLin, 00 PSAY Replicate("-",limite)
        nLin := nLin + 1
        @ nLin, 00 PSAY "TOTAL DO DIA -> " + Dtoc(_ddata) + " - "
        @ nLin, 25 PSAY _nTotVL[1]   Picture "@E 999,999,999.99"
        @ nLin, 50 PSAY " - "
        @ nLin, 55 PSAY _nTotNF[1]
        @ nLin, 62 PSAY "Notas Emitidas"
        _nTotNF[1] := 0
        _nTotVL[1] := 0
        nLin := nLin + 1
        @ nLin, 00 PSAY Replicate("-",limite)
        nLin := nLin + 1
   Endif


Enddo
        If   nLin > 56
             @ nLin, 000 Psay Replicate("-",50)+"Continua na Proxima Pagina----"
             cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
             nLin := 7
        Endif

//      @ nLin, 00 PSAY Replicate("-",limite)
//      nLin := nLin + 1
//      @ nLin, 00 PSAY "TOTAL DO DIA -> " + Dtoc(_ddata) + " - "
//      @ nLin, 25 PSAY _nTotVL[1]   Picture "@E 999,999,999.99"
//      @ nLin, 50 PSAY " - "
//      @ nLin, 51 PSAY _nTotNF[1]
//      @ nLin, 62 PSAY "Notas Emitidas"
//      _nTotNF[1] := 0
//      _nTotVL[1] := 0
//      nLin := nLin + 1
        @ nLin, 00 PSAY Replicate("-",limite)
        nLin := nLin + 1
        @ nLin, 00 PSAY "TOTAL GERAL de " + Dtoc(mv_par01) + " - " + Dtoc(mv_par02)
        @ nLin, 35 PSAY _nTotVL[2]   Picture "@E 999,999,999.99"
        @ nLin, 50 PSAY " - "
        @ nLin, 55 PSAY _nTotNF[2]
        @ nLin, 62 PSAY "Notas Emitidas"
        nLin := nLin + 1

Roda(cbCont,"Pedidos",tamanho)
Set Device to Screen
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

Return

*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*

Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Da Emissao     ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate Emissao    ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})

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

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
/*/
*---------------------------------------------------------------------------*
* Lay Out do Relatorio                                                      *
*---------------------------------------------------------------------------*
0         1         2         3         4         5         6         7         8         9        10        10
012345678901234567890123456789012345678901234567890123456789012345678901234567890
DATA     NUM.NF TIPO  TOTAL DA NOTA CLIENTE   NOME DO CLIENTE           
99/99/99 999999 XXXX 999.999.999,99 999999-99 1234567890123456789012345  
      ITEM CODIGO   DESCRICAO                      QUANTIDADE NR.PED IT TES CFO
       99  99999999 123456789012345678901234567890 999,999,99 999999 99 999 999

                                                                                                                                                                                 |
                       NORM=NORMAL                                                                                                                                                  |
                       CPRE=COMPLEMENTO DE PRECO                                                                                                         CATEGORIA DO CLIENTE >-----+
                       CICM=COMPLEMENTO DE ICMS                                                                                                          D=DISTRIBUIDOR
                       CIPI=COMPLEMENTO DO IPI                                                                                                           R=REVENDEDOR   
                       BENF=BENEFICIAMENTO  (FORNECEDOR)                                                                                                 P=PRODUTOR/INDUSTRIALIZACAO
                       DEVL=DEVOLUCAO       (FORNECEDOR)                                                                                                 C=CONSUMIDOR/MANUTENCAO
                                                                                                                                                      T=TODOS
/*/


