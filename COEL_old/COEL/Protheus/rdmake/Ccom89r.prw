#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Ccom89r()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NVAL,_CINDSC7,_CCHASC7,DDEMISSAO,_CNATU")
SetPrvt("_NMOED,_NFATOR,_NTAXA1,_VATU0,_VATU1,_VATU")
SetPrvt("CABEC1,CABEC2,_NCONTADOR,_CINDTRB,_CCHATRB,_NATU")
SetPrvt("_NATU1,_CNATU1,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CCOM89R  ³ Autor ³Adilson M Takeshima    ³ Data ³13/06/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ PEDIDOS DE COMPRAS POR DT.ENTREGA X NATUREZA               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda - expecifico para Expedicao  ³±±
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
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 02/09/02 ==>     #DEFINE PSAY SAY
#ENDIF
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
DbSelectArea("SC7")         //----> Pedido de Compras            
DbSetOrder(1)               //---->                           

*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"ENTREGA" ,"D",08,0})
AADD(aEstru1,{"EMISSAO" ,"D",08,0})
AADD(aEstru1,{"FORNECE" ,"C",06,0})
AADD(aEstru1,{"LOJA"    ,"C",02,0})
AADD(aEstru1,{"NATU"    ,"C",06,0})
AADD(aEstru1,{"NOMENAT" ,"C",30,0})
AADD(aEstru1,{"MOE"     ,"N",01,0})
AADD(aEstru1,{"VALORIG" ,"N",14,5})
AADD(aEstru1,{"VALREAL" ,"N",14,5})
AADD(aEstru1,{"TAXA"    ,"N",14,5})
AADD(aEstru1,{"TAXA1"   ,"N",14,5})

_cTemp1 := CriaTrab( aEstru1, .T. )  
//DbUseArea(.T.,__cRdd,cArqTrab,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )
DbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. )

*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*

wnrel     := "CCOM89R"
cDesc1    := "PC por Entrega x Nat"
cDesc2    := " "
cDesc3    := " "
cString   := "SC7"
lEnd      := .F.
tamanho   := "P"
limite    := 80
titulo    := "PC por Entrega x Natureza"      
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CCOM89R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "COM89R"
nLin      := 8
m_pag     := 1
_nVal     := { 0, 0, 0, 0}
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Data Entrega Inicial                                      *
* mv_par02  ----> Data Entrega Final                                        *
* mv_par03  ----> Moeda 2 Dolar Americano                                   *
* mv_par04  ----> Moeda 4 Marco Alemao                                      *
* mv_par05  ----> Moeda 5 Lira Italiana                                     *
* mv_par06  ----> Moeda 6 Franco Suico                                      *
* mv_par07  ----> Moeda 7 Franco Frances                                    *
* mv_par08  ----> Moeda 8 Yene Japones                                      *
* mv_par09  ----> Moeda 9 Euro                                              *
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

DbSelectArea("SC7")

_cIndSC7 := CriaTrab(Nil,.f.)
_cChaSC7 := "SC7->C7_FILIAL+DTOS(SC7->C7_DATPRF)+SC7->C7_NUM"
IndRegua("SC7",_cIndSC7,_cChaSC7,,,"Selecionando Registros SC7 (Indice Temp) ...")

DbSeek(xFilial("SC7")+Dtos(mv_par01),.t.)
ProcRegua(RecCount())

//
//     INICIO DOS FILTROS DOS PARAMETROS NO SC7 PEDIDOS DE COMPRAS
//

Do While !Eof() .And. SC7->C7_DATPRF <= mv_par02
    IncProc("Selecionando Dados do Pedido: "+SC7->C7_NUM)

   
        DbSelectArea("TRB")
        RecLock("TRB",.t.)

          TRB->EMISSAO  :=      SC7->C7_EMISSAO
          DDEMISSAO     :=      SC7->C7_EMISSAO
          TRB->ENTREGA  :=      SC7->C7_DATPRF
          TRB->FORNECE  :=      SC7->C7_FORNECE
          TRB->LOJA     :=      SC7->C7_LOJA   
          _cNatu        :=      Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NATUREZ")
          If  !Empty(_cNatu)
              TRB->NATU     :=      _cNatu
              TRB->NOMENAT :=  Posicione("SED",1,xFilial("SED")+_cNatu,"ED_DESCRIC")            
            Else
              _cNatu       := "9999"
              TRB->NATU     :=      _cNatu
              TRB->NOMENAT := "NAT.nao Definida"
          Endif
          TRB->MOE      :=      SC7->C7_MOEDA
          _nMoed        :=      SC7->C7_MOEDA

    Dbselectarea("SM2")
    Dbsetorder(1)

    If Dbseek(DDEMISSAO)
       Do Case
          Case _nMoed == 2      //----> dolar
               _nfator := SM2->M2_MOEDA2
               _nTaxa1 := mv_par03
               IF  _nfator == 0
                   _nfator := 1
               ENDIF
          Case _nMoed == 4      //----> marco alemao
               _nfator := SM2->M2_MOEDA4
               _nTaxa1 := mv_par04
               IF  _nfator == 0
                   _nfator := 1
               ENDIF
          Case _nMoed == 5      //----> lira italiana
               _nfator := SM2->M2_MOEDA5
               _nTaxa1 := mv_par05
               IF  _nfator == 0
                   _nfator := 1
               ENDIF
          Case _nMoed == 6      //----> franco suico
               _nfator := SM2->M2_MOEDA6
               _nTaxa1 := mv_par06
               IF  _nfator == 0
                   _nfator := 1
               ENDIF
          Case _nMoed == 7      //----> franco frances
               _nfator := SM2->M2_MOEDA7
               _nTaxa1 := mv_par07
               IF  _nfator == 0
                   _nfator := 1
               ENDIF
          Case _nMoed == 8      //----> yene
               _nfator := SM2->M2_MOEDA8
               _nTaxa1 := mv_par08
               IF  _nfator == 0
                   _nfator := 1
               ENDIF
          Case _nMoed == 9      //----> euro
               _nfator := SM2->M2_MOEDA9
               _nTaxa1 := mv_par09
               IF  _nfator == 0
                   _nfator := 1
               ENDIF
          Case _nMoed == 1
               _nfator := 1
               _nTaxa1 := 1
       EndCase
    Endif
          _vAtu0        :=      (SC7->C7_TOTAL / _nfator)
          _vAtu1        :=      (_vAtu0 * _nTaxa1)
          _vAtu         :=      SC7->C7_TOTAL
          TRB->VALORIG  :=      _vAtu
          TRB->VALREAL  :=      _vAtu1
          TRB->TAXA     :=  _nfator
          TRB->TAXA1    :=  _nTaxa1

        MsUnLock()

    DbSelectArea("SC7")
    DbSkip()
EndDo

*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*

#IFDEF WINDOWS
    RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==>     RptStatus({|| Execute(Imprime)},titulo)
#ELSE
    Imprime()
#ENDIF


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function Imprime
Static Function Imprime()

cabec1  := "PERIODO DE :"+DTOC(MV_PAR01)+ " A "+DTOC(MV_PAR02)
cabec2  := "CODIGO NATUREZA                        VALOR ORIGINAL  VALOR CORRIGIDO"
titulo  := "PC POR DT.ENTREGA x NATUREZA" 

_nContador := 0

DbSelectArea("TRB")
_cIndTRB := CriaTrab(Nil,.f.)
_cChaTRB := "TRB->NATU+DTOS(TRB->ENTREGA)"
IndRegua("TRB",_cIndTRB,_cChaTRB,,,"Selecionando Registros TRB (Indice Temp) ...")
DbGoTop()
Setregua(Lastrec())
@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
      _natu      := TRB->NATU
      _cnatu     := TRB->NOMENAT

Do While !Eof()
   Incregua()

  Do  While _natu == TRB->NATU
      _natu1     := _natu    
      _cnatu1    := _cnatu       

      _nVal[1] := _nVal[1] + TRB->VALORIG
      _nVal[2] := _nVal[2] + TRB->VALREAL
      _nVal[3] := _nVal[3] + TRB->VALORIG
      _nVal[4] := _nVal[4] + TRB->VALREAL
   DbSkip()
  Enddo

  ImpDet()

  _nVal[1] := 0
  _nVal[2] := 0

      _nVal[1] := _nVal[1] + TRB->VALORIG
      _nVal[2] := _nVal[2] + TRB->VALREAL
      _nVal[3] := _nVal[3] + TRB->VALORIG
      _nVal[4] := _nVal[4] + TRB->VALREAL

  _natu      := TRB->NATU
  _cnatu     := TRB->NOMENAT

  DbSkip()
Enddo
@nLin, 39 PSAY "==============   =============="
nLin := nLin +1
@nLin, 00 PSAY "TOTAL NO PERIODO....................."
@nLin, 39 PSAY _nVal[3]     Picture "@E 999,999,999.99"
@nLin, 56 PSAY _nVal[4]     Picture "@E 999,999,999.99"

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
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function ImpDet
Static Function ImpDet()
  @nLin , 01 PSAY _natu
  @nLin , 07 PSAY _cnatu
  @nLin , 39 PSAY _nVal[1]   Picture "@E 999,999,999.99"
  @nLin , 56 PSAY _nVal[2]   Picture "@E 999,999,999.99"

  nLin := nLin + 1
  
  If nLin > 56
     @ nLin, 000 Psay Replicate("-",50)+"Continua na Proxima Pagina----"
     cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
     nLin := 8
  Endif
Return

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}            
    aadd(aRegs,{cPerg,'01','Dt Entrega Inicial ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Dt Entrega Final   ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Moeda 2 Dolar Amer ? ','mv_ch3','N',10, 5, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Moeda 4 Marco Alem ? ','mv_ch4','N',10, 5, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Moeda 5 Lira Ital  ? ','mv_ch5','N',10, 5, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'06','Moeda 6 Fr Suico   ? ','mv_ch6','N',10, 5, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Moeda 7 Fr Frances ? ','mv_ch7','N',10, 5, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'08','Moeda 8 Yene Japon ? ','mv_ch8','N',10, 5, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Moeda 9 Euro       ? ','mv_ch9','N',10, 5, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','',''})

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
   CODIGO NATUREZA                        VALOR ORIGINAL  VALOR CORRIGIDO
    9999  123456789012345678901234567890  999,999,999.99   999,999,999.99

   TOTAL NO PERIODO.....................  999,999,999.99   999,999,999.99
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

