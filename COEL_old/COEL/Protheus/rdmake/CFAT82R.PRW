#include "rwmake.ch"     

User Function Cfat82r()  

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NQTDPRO,_NTOTPRO,_CTES,CABEC1,CABEC2")
SetPrvt("_NCONTADOR,_CINDTRB,_CCHATRB,_DDATA,_NGRUPO,_GRUPO")
SetPrvt("_GRUPO1,_GRUPO2,AREGS,I,J,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT82R  ³ Autor ³Adilson M Takeshima    ³ Data ³13/06/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ FATURAMENTO DIARIO E ACUMULADO POR SUBGRUPO QTD E VALOR    ³±±
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
dbOrderNickName("SF26")
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"EMISSAO" ,"D",08,0})
AADD(aEstru1,{"NOTA"    ,"C",06,0})
AADD(aEstru1,{"TES"     ,"C",03,0})
AADD(aEstru1,{"TPRO"    ,"C",02,0})
AADD(aEstru1,{"TPN"     ,"C",01,0})
AADD(aEstru1,{"GRUPO"   ,"C",04,0})
AADD(aEstru1,{"NGRUPO"  ,"C",15,0})
AADD(aEstru1,{"QUANT"   ,"N",14,2})
AADD(aEstru1,{"VALFT"   ,"N",14,2})

_cTemp1 := CriaTrab( aEstru1, .T. )  
//dbUseArea(.T.,__cRdd,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )
dbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. )
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*

wnrel     := "CFAT82R"
cDesc1    := "Faturamento Diario"
cDesc2    := " "
cDesc3    := " "
cString   := "SD2"
lEnd      := .F.
tamanho   := "P"
limite    := 80
titulo    := "FATURAMENTO DIARIO / ACUMULADO"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFAT82R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT82R"
nLin      := 8
m_pag     := 1
_nQtdPro  := { 0, 0, 0, 0}
_nTotPro  := { 0, 0, 0, 0}
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Data Inicial   ?                                          *
* mv_par02  ----> Data Final     ?                                          *
* mv_par03  ----> Do    Grupo    ?                                          *
* mv_par04  ----> Ate o Grupo    ?                                          *
* mv_par05  ----> Lista de TES 1 ?                                          *
* mv_par06  ----> Lista de TES 2 ?                                          *
* mv_par07  ----> Tipo Produtos  ?                                          *
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

Processa({||RunProc()},"Filtrando Dados ...")// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Processa({||Execute(RunProc)},"Filtrando Dados ...")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SD2")
ProcRegua(RecCount())
DbSelectArea("SF2")
//DbSetOrder(6)               //----> Filial + Data Emissao + Documento + Serie
dbOrderNickName("SF26")

DbSeek(xFilial("SF2")+Dtos(mv_par01),.t.)

//
//     INICIO DOS FILTROS DOS PARAMETROS NO SF2 CAB NOTAS FISCAIS
//

_cTes := AllTrim(mv_par05)+"/"+AllTrim(mv_par06)

Do While !Eof() .And. SF2->F2_EMISSAO <= mv_par02

    DbSelectArea("SD2")
    DbSeek(xFilial("SD2")+SF2->F2_DOC)
    Do While SD2->D2_DOC == SF2->F2_DOC

       IncProc("Selecionando Dados da NOTA: "+SD2->D2_DOC+"/"+SD2->D2_ITEM)
//
//     FILTRANDO TES                                             
//
    If  !SD2->D2_TES $ AllTrim(_cTes)
        dbSkip()
        Loop
    EndIf
//
//     FILTRANDO TIPO DE PRODUTOS                                             
//
    If  mv_par07 == 1
        If  !SD2->D2_TP$ ALLTRIM("PA/PP")
             dbSkip()
             Loop
        EndIf
    EndIf
//
//     FILTRANDO TIPO DE NOTA                                             
//

    If   SF2->F2_TIPO == "B"
        dbSkip()
        Loop
    EndIf

    If   SF2->F2_TIPO == "D"
        dbSkip()
        Loop
    EndIf

    If   SF2->F2_TIPO == "I"
        dbSkip()
        Loop
    EndIf

    If   SF2->F2_TIPO == "C"
        dbSkip()
        Loop
    EndIf

        DbSelectArea("TRB")
        RecLock("TRB",.t.)

          TRB->EMISSAO  :=      SF2->F2_EMISSAO
          TRB->NOTA     :=      SF2->F2_DOC
          TRB->TPN      :=      SF2->F2_TIPO
          TRB->TES      :=      SD2->D2_TES
          TRB->TPRO     :=      SD2->D2_TP
          TRB->GRUPO    :=      SD2->D2_GRUPO
          TRB->NGRUPO   :=      Subs(Tabela("03",TRB->GRUPO,.f.),1,13)
          TRB->VALFT    :=      SD2->D2_TOTAL + SD2->D2_VALIPI
          TRB->QUANT    :=      SD2->D2_QUANT

        MsUnLock()

        DbSelectArea("SD2")
        DbSkip()
    EndDo

    DbSelectArea("SF2")
    DbSkip()
EndDo

*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*

RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==>	   RptStatus({|| Execute(Imprime)},titulo)

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function Imprime
Static Function Imprime()

cabec1  := "PERIODO DE :"+DTOC(MV_PAR01)+ " A "+DTOC(MV_PAR02)
cabec2  := "COD. SUBGRUPO        QTD.NO DIA  QTD.ACUMUL    VLR FATURADO      ACUMULADO"
titulo  := "FAT.DIARIO/ACUMULADO POR SUBGRUPO" 

_nContador := 0

DbSelectArea("TRB")
_cIndTRB := CriaTrab(Nil,.f.)
_cChaTRB := "DTOS(TRB->EMISSAO)+TRB->NGRUPO"
IndRegua("TRB",_cIndTRB,_cChaTRB,,,"Selecionando Registros TRB (Indice Temp) ...")
DbGoTop()
Setregua(Lastrec())
@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
Do While !Eof()
   Incregua()

  _ddata := TRB->EMISSAO

  _ngrupo := TRB->NGRUPO
  _grupo  := TRB->GRUPO

  Do  While !EOF() .AND. _ngrupo == TRB->NGRUPO

     _grupo1 := _grupo     
     _grupo2 := _ngrupo

     _nQtdPro[1] := _nQtdPro[1] + TRB->QUANT
     _nQtdPro[2] := _nQtdPro[2] + TRB->QUANT
     _nQtdPro[3] := _nQtdPro[3] + TRB->QUANT
     _nQtdPro[4] := _nQtdPro[4] + TRB->QUANT
     _nTotPro[1] := _nTotPro[1] + TRB->VALFT
     _nTotPro[2] := _nTotPro[2] + TRB->VALFT
     _nTotPro[3] := _nTotPro[3] + TRB->VALFT
     _nTotPro[4] := _nTotPro[4] + TRB->VALFT

      DbSkip()
  Enddo
  @nLin , 00 PSAY _grupo1
  @nLin , 05 PSAY _grupo2     
  @nLin , 21 PSAY _nQtdPro[1]   Picture "@E 999,999.99"
//  @nLin , 33 PSAY _nQtdPro[2]   Picture "@E 999,999.99"
  @nLin , 45 PSAY _nTotPro[1]   Picture "@E 999,999,999.99"
//  @nLin , 60 PSAY _nTotPro[2]   Picture "@E 999,999,999.99"
  _nQtdPro[1] := 0
  _nTotPro[1] := 0
  nLin := nLin + 1
  
  If nLin > 56
     @ nLin, 000 Psay Replicate("-",50)+"Continua na Proxima Pagina----"
     cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
     nLin := 8
  Endif

  If   _ddata <> TRB->EMISSAO
       If nLin > 53
          @ nLin, 000 Psay Replicate("-",50)+"Continua na Proxima Pagina----"
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
          nLin := 8
       Endif
       nLin := nLin + 1
       @nLin , 00 PSAY "TOTAL EM "+DTOC(_ddata)
       @nLin , 21 PSAY _nQtdPro[3]   Picture "@E 999,999.99"
       @nLin , 33 PSAY _nQtdPro[4]   Picture "@E 999,999.99"
       @nLin , 45 PSAY _nTotPro[3]   Picture "@E 999,999,999.99"
       @nLin , 60 PSAY _nTotPro[4]   Picture "@E 999,999,999.99"
       nLin := nLin + 1
       @nLin , 00 PSAY Replicate("-",limite)
       nLin := nLin + 1
       _nQtdPro[3] := 0
       _nTotPro[3] := 0

  Endif

Enddo

Roda(cbCont,"Adilson",tamanho)
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

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Data Inicial         ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Data Final           ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Do    Subgrupo       ? ','mv_ch3','C',04, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','','03'})
    aadd(aRegs,{cPerg,'04','Ate o Subgrupo       ? ','mv_ch4','C',04, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','','03'})
    aadd(aRegs,{cPerg,'05','Lista de Tes 1       ? ','mv_ch5','C',30, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'06','Lista de Tes 2       ? ','mv_ch6','C',30, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Tipo de Produtos     ? ','mv_ch7','C',01, 0, 2,'C', '', 'mv_par07','So Produtos','','','Tudo','','','','','','','','','','',''})

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

/*/
*---------------------------------------------------------------------------*
* Lay Out do Relatorio                                                      *
*---------------------------------------------------------------------------*
L  0         1         2         3         4         5         6         7         8
C  012345678901234567890123456789012345678901234567890123456789012345678901234567890 
   COD. SUBGRUPO        QTD.NO DIA  QTD.ACUMUL    VLR FATURADO      ACUMULADO
   XXXX 123456789012345 999,999.99  999,999.99  999,999,999.99 999,999,999.99
   XXXX 123456789012345 999,999.99  999,999.99  999,999,999.99 999,999,999.99
   XXXX 123456789012345 999,999.99  999,999.99  999,999,999.99 999,999,999.99
   XXXX 123456789012345 999,999.99  999,999.99  999,999,999.99 999,999,999.99
   XXXX 123456789012345 999,999.99  999,999.99  999,999,999.99 999,999,999.99

   TOTAL EM 99/99/99    999,999.99  999,999.99  999,999,999.99 999,999,999.99
   ---------------------------------------------------------------------------------
   XXXX 123456789012345 999,999.99  999,999.99  999,999,999.99 999,999,999.99
   XXXX 123456789012345 999,999.99  999,999.99  999,999,999.99 999,999,999.99
   XXXX 123456789012345 999,999.99  999,999.99  999,999,999.99 999,999,999.99
   XXXX 123456789012345 999,999.99  999,999.99  999,999,999.99 999,999,999.99
   XXXX 123456789012345 999,999.99  999,999.99  999,999,999.99 999,999,999.99

   TOTAL EM 99/99/99    999,999.99  999,999.99  999,999,999.99 999,999,999.99
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

