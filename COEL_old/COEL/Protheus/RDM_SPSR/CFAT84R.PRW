#include "rwmake.ch"

User Function Cfat84r()

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NTOTPRO,_NTOTAST,_NTOTSRV,_NTOTATV,_NTOTCMP")
SetPrvt("_NTOTIPI,_NTOTOPR,_NTOTOVL,_NTOTFAT,_NVALIPI,_NVALICM")
SetPrvt("_NVALISS,_CTES,_CTES1,CABEC1,CABEC2,_NCONTADOR")
SetPrvt("_DDATA,_NOTA,AREGS,I,J,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT84R  ³ Autor ³Adilson M Takeshima    ³ Data ³07/05/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ FATURAMENTO DIARIO E ACUMULADO                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda - expecifico para Expedicao  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
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
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"EMISSAO" ,"D",08,0})
AADD(aEstru1,{"NOTA"    ,"C",09,0})
AADD(aEstru1,{"TES"     ,"C",03,0})
AADD(aEstru1,{"TPRO"    ,"C",02,0})
AADD(aEstru1,{"TPN"     ,"C",01,0})
AADD(aEstru1,{"FTOVL"   ,"N",14,2})
AADD(aEstru1,{"VALFT"   ,"N",14,2})
AADD(aEstru1,{"VLIPI"   ,"N",14,2})
AADD(aEstru1,{"VLICM"   ,"N",14,2})

_cTemp1 := CriaTrab( aEstru1, .T. )  
//dbUseArea(.T.,__cRdd,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )
dbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. )

*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*

wnrel     := "CFAT84R"
cDesc1    := "Faturamento Diario"
cDesc2    := " "
cDesc3    := " "
cString   := "SD2"
lEnd      := .F.
tamanho   := "P"
limite    := 80
titulo    := "FATURAMENTO DIARIO / ACUMULADO"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFAT84R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT84R"
nLin      := 7
m_pag     := 1
_nTotPro  := { 0, 0}
_nTotAst  := { 0, 0}
_nTotSrv  := { 0, 0}
_nTotAtv  := { 0, 0}
_nTotCmp  := { 0, 0}
_nTotIpi  := { 0, 0}
_nTotOpr  := { 0, 0}
_nTotOvl  := { 0, 0}
_nTotFat  := { 0, 0}
_nValIpi  := { 0, 0}
_nValIcm  := { 0, 0}
_nValIss  := { 0, 0}
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Data Inicial   ?                                          *
* mv_par02  ----> Data Final     ?                                          *
* mv_par03  ----> Tes Venda Prod ?                                          *
* mv_par04  ----> Tes Venda Prod ?                                          *
* mv_par05  ----> Tes Assist Tec ?                                          *
* mv_par06  ----> Tes Outros Serv?                                          *
* mv_par07  ----> Tes Venda Ativo?                                          *
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

DbSelectArea("SF2")
//DbSetOrder(9)               //----> Filial + Data Emissao + Documento + Serie
//dbOrderNickName("SF26")

//DbSeek(xFilial("SF2")+Dtos(mv_par01),.t.)
ProcRegua(RecCount())

//
//     INICIO DOS FILTROS DOS PARAMETROS NO SF2 CAB NOTAS FISCAIS
//

_cTes := AllTrim(mv_par03)+"/"+AllTrim(mv_par04)+"/"+AllTrim(mv_par05)+"/"+AllTrim(mv_par06)+"/"+AllTrim(mv_par07)
_cTes1:= AllTrim(mv_par05)+"/"+AllTrim(mv_par06)

cQry  := "SELECT * FROM "+RetSqlName("SF2")
cQry  += " WHERE D_E_L_E_T_ = ' ' AND F2_FILIAL = '"+xFilial("SF2")+"' "
cQry  += " AND F2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQry  += " ORDER BY F2_EMISSAO,F2_DOC,F2_SERIE "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB3', .T., .T.)

TcSetField("TB3","F2_EMISSAO","D",08,0)
TcSetField("TB3","F2_VALBRUT","N",15,2)
TcSetField("TB3","F2_FRETE","N",15,2)
TcSetField("TB3","F2_SEGURO","N",15,2)
TcSetField("TB3","F2_DESPESA","N",15,2)
TcSetField("TB3","F2_QUANT","N",11,2)

dbSelectArea("TB3")
dbGoTop()
Do While !Eof() //.And. TB3->F2_EMISSAO <= mv_par02
    IncProc("Selecionando Dados da NOTA: "+TB3->F2_DOC+TB3->F2_SERIE)

//If SF2->F2_DOC < mv_par08 .Or. SF2->F2_DOC > mv_par09
//        DbSkip()
//        Loop
//    EndIf

    DbSelectArea("SD2")
    DbSeek(TB3->F2_FILIAL+TB3->F2_DOC+TB3->F2_SERIE)
    Do While SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE == TB3->F2_FILIAL+TB3->F2_DOC+TB3->F2_SERIE
//
//     FILTRANDO TES
//
    If  !SD2->D2_TES $ AllTrim(_cTes)
        dbSkip()
        Loop
    EndIf

    If   TB3->F2_TIPO == "B"
        dbSkip()
        Loop
    EndIf

    If   TB3->F2_TIPO == "D"
        dbSkip()
        Loop
    EndIf

    If   TB3->F2_TIPO == "I"
        dbSkip()
        Loop
    EndIf

        DbSelectArea("TRB")
        RecLock("TRB",.t.)

          TRB->EMISSAO  :=      TB3->F2_EMISSAO
          TRB->NOTA     :=      TB3->F2_DOC+TB3->F2_SERIE
          TRB->TPN      :=      TB3->F2_TIPO
          TRB->TES      :=      SD2->D2_TES
          TRB->TPRO     :=      SD2->D2_TP
          If   TB3->F2_TIPO == "P"
             TRB->VALFT :=      SD2->D2_TOTAL
          Else
             TRB->VALFT :=      SD2->D2_TOTAL + SD2->D2_ICMSRET + SD2->D2_VALIPI
          EndIf
          TRB->FTOVL    :=      TB3->F2_FRETE + TB3->F2_SEGURO + TB3->F2_DESPESA
          TRB->VLIPI    :=      SD2->D2_VALIPI
          TRB->VLICM    :=      SD2->D2_VALICM


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

RptStatus({|| Imprime()},titulo)

Return(nil)

Static Function Imprime()

cabec1  := "PERIODO DE :"+DTOC(MV_PAR01)+ " A "+DTOC(MV_PAR02)
cabec2  := ""
titulo  := "FATURAMENTO DIARIO / ACUMULADO"

_nContador := 0

DbSelectArea("TRB")
DbGoTop()
Setregua(Lastrec())
@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
Do While !Eof()
   Incregua()

  _ddata := TRB->EMISSAO

  _nTotOvl[1] := _nTotOvl[1] + TRB->FTOVL
  _nTotOvl[2] := _nTotOvl[2] + TRB->FTOVL

  _nota := TRB->NOTA

  Do  While _nota == TRB->NOTA

      If  TRB->TES $ AllTrim(mv_par03)
          If  TRB->TPN == "N"
              If  TRB->TPRO$ "PA/PP"
                  _nTotPro[1] := _nTotPro[1] + TRB->VALFT
                  _nTotPro[2] := _nTotPro[2] + TRB->VALFT
                Else
                  _nTotOpr[1] := _nTotOpr[1] + TRB->VALFT
                  _nTotOpr[2] := _nTotOpr[2] + TRB->VALFT
              Endif
          Elseif  TRB->TPN == "C"
                  _nTotCmp[1] := _nTotCmp[1] + TRB->VALFT
                  _nTotCmp[2] := _nTotCmp[2] + TRB->VALFT
          Elseif  TRB->TPN == "P"
                  _nTotIpi[1] := _nTotIpi[1] + TRB->VALFT
                  _nTotIpi[2] := _nTotIpi[2] + TRB->VALFT
          Endif
      Endif

      If  TRB->TES $ AllTrim(mv_par04)
          If  TRB->TPN == "N"
              If  TRB->TPRO$ "PA/PP"
                  _nTotPro[1] := _nTotPro[1] + TRB->VALFT
                  _nTotPro[2] := _nTotPro[2] + TRB->VALFT
                Else
                  _nTotOpr[1] := _nTotOpr[1] + TRB->VALFT
                  _nTotOpr[2] := _nTotOpr[2] + TRB->VALFT
              Endif
          Elseif  TRB->TPN == "C"
                  _nTotCmp[1] := _nTotCmp[1] + TRB->VALFT
                  _nTotCmp[2] := _nTotCmp[2] + TRB->VALFT
          Elseif  TRB->TPN == "P"
                  _nTotIpi[1] := _nTotIpi[1] + TRB->VALFT
                  _nTotIpi[2] := _nTotIpi[2] + TRB->VALFT
          Endif
      Endif


      If  TRB->TES $ AllTrim(mv_par05)
          _nTotAst[1] := _nTotAst[1] + TRB->VALFT
          _nTotAst[2] := _nTotAst[2] + TRB->VALFT
      Endif

      If  TRB->TES $ AllTrim(mv_par06)
          _nTotSrv[1] := _nTotSrv[1] + TRB->VALFT
          _nTotSrv[2] := _nTotSrv[2] + TRB->VALFT
      Endif

      If  TRB->TES $ AllTrim(mv_par07)
          _nTotAtv[1] := _nTotAtv[1] + TRB->VALFT
          _nTotAtv[2] := _nTotAtv[2] + TRB->VALFT
      Endif

      If  TRB->TES $ AllTrim(_cTes1)
          _nValIss[1] := _nValIss[1] + TRB->VLICM
          _nValIss[2] := _nValIss[2] + TRB->VLICM
        Else
          _nValIcm[1] := _nValIcm[1] + TRB->VLICM
          _nValIcm[2] := _nValIcm[2] + TRB->VLICM
      Endif

      _nValIpi[1] := _nValIpi[1] + TRB->VLIPI
      _nValIpi[2] := _nValIpi[2] + TRB->VLIPI

      DbSkip()
  Enddo

  If   _ddata <> TRB->EMISSAO
       ImpDet()
       _nContador := _nContador + 1
  Endif

  If   _nContador == 4  //alterado fernando de 5 para 4
       _nContador := 0
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
        nLin := 7
  Endif

Enddo

Roda(cbCont,"Adilson",tamanho)
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

Static Function ImpDet()
_nTotFat [1] := _nTotPro[1] + _nTotAst[1] + _nTotSrv[1] + _nTotAtv[1] + _nTotCmp[1] + _nTotIpi[1] + _nTotOpr[1] + _nTotOvl[1]
_nTotFat [2] := _nTotFat[2] + _nTotFat[1]
@ nLin, 00 PSAY "DATA              PROD.FABRICADO  ASSIST.TECNICA  OUTROS SERVICOS  VENDA DE ATIVO"
nLin := nLin + 1
@ nLin, 00 PSAY _ddata
@ nLin, 09 PSAY "NO DIA->"
@ nLin, 18 PSAY _nTotPro[1]     Picture "@E 999,999,999.99"
@ nLin, 34 PSAY _nTotAst[1]     Picture "@E 999,999,999.99"
@ nLin, 51 PSAY _nTotSrv[1]     Picture "@E 999,999,999.99"
@ nLin, 67 PSAY _nTotAtv[1]     Picture "@E 999,999,999.99"
nLin := nLin + 1
@ nLin, 09 PSAY "ACUMUL->"
@ nLin, 18 PSAY _nTotPro[2]     Picture "@E 999,999,999.99"
@ nLin, 34 PSAY _nTotAst[2]     Picture "@E 999,999,999.99"
@ nLin, 51 PSAY _nTotSrv[2]     Picture "@E 999,999,999.99"
@ nLin, 67 PSAY _nTotAtv[2]     Picture "@E 999,999,999.99"
nLin := nLin + 2
@ nLin, 18 PSAY "COMPLEM.PRECOS  COMPLEM.DE IPI   OUTROS PRODUTO  FRT/SEG/O.DESP"
nLin := nLin + 1
@ nLin, 09 PSAY "NO DIA->"
@ nLin, 18 PSAY _nTotCmp[1]     Picture "@E 999,999,999.99"
@ nLin, 34 PSAY _nTotIpi[1]     Picture "@E 999,999,999.99"
@ nLin, 51 PSAY _nTotOpr[1]     Picture "@E 999,999,999.99"
@ nLin, 67 PSAY _nTotOvl[1]     Picture "@E 999,999,999.99"
nLin := nLin + 1
@ nLin, 09 PSAY "ACUMUL->"
@ nLin, 18 PSAY _nTotCmp[2]     Picture "@E 999,999,999.99"
@ nLin, 34 PSAY _nTotIpi[2]     Picture "@E 999,999,999.99"
@ nLin, 51 PSAY _nTotOpr[2]     Picture "@E 999,999,999.99"
@ nLin, 67 PSAY _nTotOvl[2]     Picture "@E 999,999,999.99"
nLin := nLin + 2
@ nLin, 18 PSAY "TOTAL FATURADO  IPI S/FATURAM.  ICMS S/FATURAM.  ISS S/FATURAM."
nLin := nLin + 1
@ nLin, 09 PSAY "NO DIA->"
@ nLin, 18 PSAY _nTotFat[1]     Picture "@E 999,999,999.99"
@ nLin, 34 PSAY _nValIpi[1]     Picture "@E 999,999,999.99"
@ nLin, 51 PSAY _nValIcm[1]     Picture "@E 999,999,999.99"
@ nLin, 67 PSAY _nValIss[1]     Picture "@E 999,999,999.99"
nLin := nLin + 1
@ nLin, 09 PSAY "ACUMUL->"
@ nLin, 18 PSAY _nTotFat[2]     Picture "@E 999,999,999.99"
@ nLin, 34 PSAY _nValIpi[2]     Picture "@E 999,999,999.99"
@ nLin, 51 PSAY _nValIcm[2]     Picture "@E 999,999,999.99"
@ nLin, 67 PSAY _nValIss[2]     Picture "@E 999,999,999.99"
nLin := nLin + 1
@ nLin, 00 PSAY Replicate("-",limite)
nLin := nLin + 1
_nTotPro[1] := 0
_nTotAst[1] := 0
_nTotSrv[1] := 0
_nTotAtv[1] := 0
_nTotCmp[1] := 0
_nTotIpi[1] := 0
_nTotOpr[1] := 0
_nTotOvl[1] := 0
_nValIpi[1] := 0
_nValIcm[1] := 0
_nValIss[1] := 0
_nTotFat[1] := 0

Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Data Inicial         ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Data Final           ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Tes Venda Produtos   ? ','mv_ch3','C',30, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Tes Venda Produtos1  ? ','mv_ch4','C',30, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Tes Assist Tecnica   ? ','mv_ch5','C',30, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'06','Tes Outros Servicos  ? ','mv_ch6','C',30, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Tes Venda Ativo      ? ','mv_ch7','C',30, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'08','Da Nota              ? ','mv_ch8','C',06, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Ate a Nota           ? ','mv_ch9','C',06, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','',''})


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

Return(nil)
/*/
*---------------------------------------------------------------------------*
* Lay Out do Relatorio                                                      *
*---------------------------------------------------------------------------*
L  0         1         2         3         4         5         6         7         8         9        10        10
C  012345678901234567890123456789012345678901234567890123456789012345678901234567890
1  DATA              PROD.FABRICADO  ASSIST.TECNICA  OUTROS SERVICOS  VENDA DE ATIVO
2  99/99/99 NO DIA-> 999,999,999.99  999,999,999.99   999,999,999.99  999,999,999.99
3           ACUMUL-> 999,999,999.99  999,999,999.99   999,999,999.99  999,999,999.99
4
5                    COMPLEM.PRECOS  COMPLEM.DE IPI   OUTROS PRODUTO  FRT/SEG/O.DESP
6           NO DIA-> 999,999,999.99  999,999,999.99   999,999,999.99  999,999,999.99
7           ACUMUL-> 999,999,999.99  999,999,999.99   999,999,999.99  999,999,999.99
8
9                    TOTAL FATURADO  IPI S/FATURAM.  ICMS S/FATURAM.  ISS S/FATURAM.
10          NO DIA-> 999,999,999.99  999,999,999.99   999,999,999.99  999,999,999.99
11          ACUMUL-> 999,999,999.99  999,999,999.99   999,999,999.99  999,999,999.99
12
/*/


