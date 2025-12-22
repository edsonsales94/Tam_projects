#include "rwmake.ch"

User Function Cfat90r() 

SetPrvt("ESTRUTURA,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,_VALFAT")
SetPrvt("_VTOTAL,_VNACION,_FLAG,M_PAG,_CTES,CABEC1")
SetPrvt("CABEC2,NLIN,AREGS,I,J,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT90R  ³ Autor ³Adilson M Takeshima    ³ Data ³01/03/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Exporta Dados de Faturamento por Especie/Natureza dos      ³±±
±±³          ³ Produtos gerando relatorio resumido no periodo             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

*---------------------------------------------------------------------------*
* Estrutura do Arquivo Temporario                                           *
*---------------------------------------------------------------------------*
Estrutura := {}

Aadd(Estrutura,{ "EMISSAO"      ,"D",08,0 } )
Aadd(Estrutura,{ "NOTA"         ,"C",06,0 } )
Aadd(Estrutura,{ "TPN"          ,"C",01,0 } )
Aadd(Estrutura,{ "ITEM"         ,"C",02,0 } )
Aadd(Estrutura,{ "CODIGO"       ,"C",15,0 } )
Aadd(Estrutura,{ "TOTITEM"      ,"N",12,4 } )
Aadd(Estrutura,{ "CDESPE"       ,"C",01,0 } )

_cTemp1 := CriaTrab ( Estrutura, .t.)
//DbUseArea( .T.,__cRdd,_cTemp1,"TRB",If(.t. .or. .f., !.f., Nil),.f.)
DbUseArea( .T.,,_cTemp1,"TRB", Nil,.f.)

*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*

wnrel     := "CFAT90R"
cDesc1    := "Resumo de Faturamento por Natureza do Produto"
cDesc2    := " "
cDesc3    := " "
cString   := "SD2"
lEnd      := .F.
tamanho   := "P"
limite    := 80 
titulo    := "RESUMO DE FATURAMENTO POR NATUREZA DO PRODUTO"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFAT90R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT90R"
_vALFAT   := {0, 0, 0, 0, 0, 0, 0, 0}
_vTOTAL   := 0
_vNACION  := 0
_fLAG     := 0
M_PAG     := 1
*---------------------------------------------------------------------------*
* Parametros Utilizados                                                     *
*                                                                           *
* mv_par01      ----> Data Inicial                                          *
* mv_par02      ----> Data Final                                            *
* mv_par03      ----> Contem os Tes                                         *                             
* mv_par04      ----> Contem os Tes1                                         *                             
*                                                                           *
*---------------------------------------------------------------------------*

ValidPerg()     //----> cria grupos de perguntas no arquivo SX1

Pergunte(cPerg,.f.)               

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

Processa({||RunProc()},"Selecinando Notas Fiscais")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Selecinando Notas Fiscais")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SF2")
//dbOrderNickName("SF26")

//DbSeek(xFilial("SF2")+Dtos(MV_PAR01),.t.)

ProcRegua(LastRec())

_cTes := AllTrim(mv_par03)+"/"+AllTrim(mv_par04)

cQry  := "SELECT * FROM "+RetSqlName("SF2")
cQry  += " WHERE D_E_L_E_T_ = ' ' AND F2_FILIAL = '"+xFilial("SF2")+"' "
cQry  += " AND F2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQry  += " ORDER BY F2_EMISSAO,F2_DOC,F2_SERIE "

cQry := ChangeQuery(cQry)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), 'TB3', .T., .T.)

TcSetField("TB3","F2_EMISSAO","D",08,0)

dbSelectArea("TB3")
dbGoTop()
While !Eof() //== .f. .And. Dtos(SF2->F2_EMISSAO) <= Dtos(MV_PAR02)

    IncProc("Selecionando Notas  "+TB3->F2_DOC)

    DbSelectArea("SD2")
    DbSetOrder(3)
    DbSeek(xFilial("SD2")+TB3->F2_DOC)

    While SD2->D2_DOC == TB3->F2_DOC

        //----> filtrando somente intervalo de tes informado no parametro
        If ! SD2->D2_TES $ Alltrim(_cTes)
            DbSkip()
            Loop
        EndIf

        DbSelectArea("TRB")
        RecLock("TRB",.t.)
          TRB->EMISSAO  := SD2->D2_EMISSAO
          TRB->NOTA     := SD2->D2_DOC
          TRB->TPN      := SD2->D2_TIPO
          TRB->ITEM     := SD2->D2_ITEM
          TRB->CODIGO   := SD2->D2_COD
          IF  TRB->TPN == "N"
              TRB->TOTITEM  := SD2->D2_TOTAL+SD2->D2_VALIPI
            ELSE
              TRB->TOTITEM  := 0
          ENDIF
          TRB->CDESPE   := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_CLESPEC")
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
*-------------------------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Imprime
Static Function Imprime()
*-------------------------------------------------------------------------------------------*
cabec1  := "REFERENTE AO PERIODO DE: "+DTOC(MV_PAR01)+" A "+DTOC(MV_PAR02)
cabec2  := "NATUREZA                                      VALORES"
titulo  := "* RESUMO DE FATURAMENTO POR NATUREZA *" 
                                                  
nLin := 9

DbSelectArea("TRB")
DbGoTop()
Setregua(Lastrec())
@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
Do While !Eof()
   Incregua()

        _vTOTAL := _vTOTAL + TRB->TOTITEM

        If  TRB->CDESPE == "1"
            _vALFAT[1] := _vALFAT[1] + TRB->TOTITEM
        Endif
        If  TRB->CDESPE == "2"
            _vALFAT[2] := _vALFAT[2] + TRB->TOTITEM
        Endif
        If  TRB->CDESPE == "3"
            _vALFAT[3] := _vALFAT[3] + TRB->TOTITEM
        Endif
        If  TRB->CDESPE == "4"
            _vALFAT[4] := _vALFAT[4] + TRB->TOTITEM
        Endif
        If  TRB->CDESPE == "5"
            _vALFAT[5] := _vALFAT[5] + TRB->TOTITEM
        Endif
        If  TRB->CDESPE == "6"
            _vALFAT[6] := _vALFAT[6] + TRB->TOTITEM
        Endif
        If  TRB->CDESPE == "7"
            _vALFAT[7] := _vALFAT[7] + TRB->TOTITEM
        Endif
        If  TRB->CDESPE == "9"
            _vALFAT[8] := _vALFAT[8] + TRB->TOTITEM
        Endif
    DbSkip()
EndDo

_vNACION := _vTOTAL - _vALFAT[3]

@nLin, 000 Psay "1- Componentes de Producao...........:"
@nLin, 040 Psay _vALFAT[1]     Picture "@E 999,999,999.99"
nLin := nLin + 1

@nLin, 000 Psay "2- Material Improdutivo..............:"
@nLin, 040 Psay _vALFAT[2]     Picture "@E 999,999,999.99"
nLin := nLin + 1

@nLin, 000 Psay "3- Produtos de Revenda Importado.....:"
@nLin, 040 Psay _vALFAT[3]     Picture "@E 999,999,999.99"
nLin := nLin + 1

@nLin, 000 Psay "4- Produtos de Revenda Nacional......:"
@nLin, 040 Psay _vALFAT[4]     Picture "@E 999,999,999.99"
nLin := nLin + 1

@nLin, 000 Psay "5- Produtos Bxo Indice Nacionalizacao:"
@nLin, 040 Psay _vALFAT[5]     Picture "@E 999,999,999.99"
nLin := nLin + 1

@nLin, 000 Psay "6- Produtos Importados MO Nacional...:"
@nLin, 040 Psay _vALFAT[6]     Picture "@E 999,999,999.99"
nLin := nLin + 1

@nLin, 000 Psay "7- Produtos de Fabricao Propria......:"
@nLin, 040 Psay _vALFAT[7]     Picture "@E 999,999,999.99"
nLin := nLin + 1

@nLin, 000 Psay "9- Outros Nao Especificados..........:"
@nLin, 040 Psay _vALFAT[8]     Picture "@E 999,999,999.99"
nLin := nLin + 1

@nLin, 039 Psay "---------------"
nLin := nLin + 1

@nLin, 000 Psay "     ********    TOTAL DO FATURAMENTO:"
@nLin, 040 Psay _vTOTAL        Picture "@E 999,999,999.99"
nLin := nLin + 1

@nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1

@nLin, 000 Psay "RESUMO 2 "
nLin := nLin + 1
@nLin, 000 Psay "======== "
nLin := nLin + 1

@nLin, 000 Psay "Faturamento de Produtos Nacionais....:"
@nLin, 040 Psay _vNACION       Picture "@E 999,999,999.99"
nLin := nLin + 1                             

@nLin, 000 Psay "Faturamento de Produtos Importados...:"
@nLin, 040 Psay _vALFAT[3]     Picture "@E 999,999,999.99"
nLin := nLin + 1

@nLin, 039 Psay "---------------"
nLin := nLin + 1

@nLin, 000 Psay "     ********    TOTAL DO FATURAMENTO:"
@nLin, 040 Psay _vTOTAL        Picture "@E 999,999,999.99"

Roda(cbCont,"Notas",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
        dbCommitAll()
        OurSpool(wnrel)
Endif

DbCloseArea("TRB")
Ferase(_cTemp1+".dbf")
Ferase(_cTemp1+".mem")

MS_FLUSH()

Return
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Da Emissao     ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate Emissao    ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Contem os Tes  ? ','mv_ch3','C',30, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Contem os Tes1 ? ','mv_ch4','C',30, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})

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

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao ValidPerg                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
