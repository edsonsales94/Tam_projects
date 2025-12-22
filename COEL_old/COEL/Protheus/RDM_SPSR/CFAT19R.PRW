#include "rwmake.ch"       
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Cfat19r()    

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NCONNF,_NTOTNF,_NTOTVF,_NTOTME,_NTOTIP")
SetPrvt("_NTOTIC,_NTOTIS,_NTOTFR,_NTOTSE,_CINDSF2,_CCHASF2")
SetPrvt("_CCODIVEND,_CNOMECLI,_CMUNICLI,_CESTACLI,_CTIPOCLI,_CNOMEVEND")
SetPrvt("CABEC1,CABEC2,_NCONTADOR,_DDATA,_DFLAG,AREGS")
SetPrvt("I,J,_DNOTA,_DTES,_DCFO,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT19R  ³ Autor ³Adilson M Takeshima    ³ Data ³13/12/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Notas Fiscais Emitidas de Saidas                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

DbSelectArea("SA1")         //----> Cadastro de Clientes
DbSetOrder(1)               //----> Codigo + Loja

DbSelectArea("SA2")         //----> Cadastro de Fornecedores
DbSetOrder(1)               //----> Codigo

DbSelectArea("SA3")         //----> Cadastro de Vendedores
DbSetOrder(1)               //----> Codigo

DbSelectArea("SD2")         //----> Itens da Nota Fiscal de Saida 
DbSetOrder(3)               //----> Numero + Serie + Cliente

DbSelectArea("SF2")         //----> Cabecalho de Notas de Saidas
DbSetOrder(1)               //----> Numero + Serie

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"EMISSAO" ,"D",08,0})
AADD(aEstru1,{"NOTA"    ,"C",09,0})
AADD(aEstru1,{"TPN"     ,"C",01,0})
AADD(aEstru1,{"TES"     ,"C",03,0})
AADD(aEstru1,{"CFO"     ,"C",04,0})
AADD(aEstru1,{"TOTNF"   ,"N",12,2})
AADD(aEstru1,{"VALFT"   ,"N",12,2})
AADD(aEstru1,{"TOTMER"  ,"N",12,2})
AADD(aEstru1,{"TOTIPI"  ,"N",11,2})
AADD(aEstru1,{"TOTICM"  ,"N",11,2})
AADD(aEstru1,{"TOTFRE"  ,"N",11,2})
AADD(aEstru1,{"TOTSEG"  ,"N",11,2})
AADD(aEstru1,{"VALISS"  ,"N",11,2})
AADD(aEstru1,{"CLIENTE" ,"C",06,0})
AADD(aEstru1,{"LOJA"    ,"C",02,0})
AADD(aEstru1,{"TPCLI"   ,"C",01,0})
AADD(aEstru1,{"NOMEC"   ,"C",25,0})
AADD(aEstru1,{"MUNIC"   ,"C",15,0})
AADD(aEstru1,{"UF"      ,"C",02,0})
AADD(aEstru1,{"VEND  "  ,"C",06,0})
AADD(aEstru1,{"NOMEV "  ,"C",15,0})

_cTemp1 := CriaTrab( aEstru1, .T. )  
//dbUseArea(.T.,__cRdd,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )
dbUseArea(.T.,,_cTemp1,"TRB", NIL, .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "CFAT19R"
cDesc1    := "Relacao de Notas de Saidas"
cDesc2    := " "
cDesc3    := " "
cString   := "SD2"
lEnd      := .F.
tamanho   := "G"
limite    := 220
titulo    := "RELACAO DE NOTAS FISCAIS DE SAIDA"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFAT19R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT19R"
nLin      := 8
m_pag     := 1
_nConNF   := { 0, 0}
_nTotNF   := { 0, 0}
_nTotVF   := { 0, 0}
_nTotME   := { 0, 0}
_nTotIP   := { 0, 0}
_nTotIC   := { 0, 0}
_nTotIS   := { 0, 0}
_nTotFR   := { 0, 0}
_nTotSE   := { 0, 0}

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da Emissao     ?                                          *
* mv_par02  ----> Ate Emissao    ?                                          *
* mv_par03  ----> Da Nota        ?                                          *
* mv_par04  ----> Ate a Nota     ?                                          *
* mv_par05  ----> Do Cliente     ?                                          *
* mv_par06  ----> Da Loja        ?                                          *
* mv_par07  ----> Ate o Cliente  ?                                          *
* mv_par08  ----> Ate a Loja     ?                                          *
* mv_par09  ----> Do Vendedor    ?                                          *
* mv_par10  ----> Ate o Vendedor ?                                          *
* mv_par11  ----> Tipo de Nota   ? (Todos/Normal/Complem/Benefic/Devolucoes)*
* mv_par12  ----> Tipo do Cliente? (Todos/Distrib/Revend/Produtor/Consum)   *
*                                                                           *
*---------------------------------------------------------------------------*
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
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Filtrando Dados ...")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Filtrando Dados ...")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SF2")

_cIndSF2 := CriaTrab(Nil,.f.)
_cChaSF2 := "SF2->F2_FILIAL+DTOS(SF2->F2_EMISSAO)"
IndRegua("SF2",_cIndSF2,_cChaSF2,,,"Selecionando Registros SF2 (Indice Temp) ...")

ProcRegua(RecCount())
DbSeek(xFilial("SF2")+Dtos(mv_par01),.t.)

//
//     INICIO DOS FILTROS DOS PARAMETROS NO SF2 CAB NOTAS FISCAIS
//

Do While !Eof() .And. SF2->F2_EMISSAO <= mv_par02
    IncProc("Selecionando Dados da NOTA: "+SF2->F2_DOC)

    //----> filtrando intervalo de NOTAS definido nos parametros
    If SF2->F2_DOC < mv_par03 .Or. SF2->F2_DOC > mv_par04    
        DbSkip()
        Loop
    EndIf
    //----> filtrando intervalo de vendedores definido nos parametros
    If SF2->F2_VEND1 < mv_par09 .Or. SF2->F2_VEND1 > mv_par10
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de clientes definido nos parametros
    If SF2->F2_CLIENTE + SF2->F2_LOJA < mv_par05 + mv_par06 .Or. SF2->F2_CLIENTE +SF2->F2_LOJA > mv_par07 + mv_par08
        DbSkip()
        Loop
    EndIf

    //----> filtrando tipo de Notas definido nos parametros
    If mv_par11 == 1
       ElseIf mv_par11 == 2 .And. !SF2->F2_TIPO$ "N"
           DbSkip()
           Loop
       ElseIf mv_par11 == 3 .And. !SF2->F2_TIPO$ "C/I/P"
           DbSkip()
           Loop
       ElseIf mv_par11 == 4 .And. !SF2->F2_TIPO$ "B"
           DbSkip()
           Loop
       ElseIf mv_par11 == 5 .And. !SF2->F2_TIPO$ "D"
           DbSkip()
           Loop
    EndIf
    _cCodiVend :=  SF2->F2_VEND1

    DbSelectArea("SD2")
    DbSeek(xFilial("SD2")+SF2->F2_DOC)
    Do While SD2->D2_DOC == SF2->F2_DOC


        If  SF2->F2_TIPO$ "N/C/I/P"

            DbSelectArea("SA1")
            DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
            _cNomeCli := SA1->A1_NOME
            _cMuniCli := SA1->A1_MUN
            _cEstaCli := SA1->A1_EST
            _cTipoCli := SA1->A1_CLASCLI

            If mv_par12 == 1
            ElseIf mv_par12 == 2 .And. _cTipoCli #"D"
                DbSelectArea("SD2")
                DbSkip()
                Loop
            ElseIf mv_par12 == 3 .And. _cTipoCli #"R"
                DbSelectArea("SD2")
                DbSkip()
                Loop
            ElseIf mv_par12 == 4 .And. _cTipoCli #"P"
                DbSelectArea("SD2")
                DbSkip()
                Loop
            ElseIf mv_par12 == 5 .And. _cTipoCli #"C"
                DbSelectArea("SD2")
                DbSkip()
                Loop
            EndIf

            DbSelectArea("SA3")
            DbSeek(xFilial("SA3")+SF2->F2_VEND1)
            _cNomeVend := SA3->A3_NOME
            
         Else
            DbSelectArea("SA2")
            DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
            _cNomeCli := SA2->A2_NOME
            _cMuniCli := SA2->A2_MUN
            _cEstaCli := SA2->A2_EST
            _cTipoCli := "#"
            _cNomeVend:= "** FORNECEDOR *"

        Endif

        DbSelectArea("TRB")
        RecLock("TRB",.t.)

          TRB->EMISSAO  :=      SF2->F2_EMISSAO 
  //        If SM0->M0_CODIGO =="01"
             TRB->NOTA := SF2->F2_DOC //ACERTA DIGITOS NF(NFE)
 //         Else 
 //            TRB->NOTA := SUBSTR(SF2->F2_DOC,4,6)
 //         EndIf
          TRB->TPN      :=      SF2->F2_TIPO
          TRB->TOTNF    :=      SF2->F2_VALBRUT
          TRB->VALFT    :=      SF2->F2_VALFAT
          IF   SF2->F2_VALISS == 0 
               TRB->TOTMER := SF2->F2_VALMERC
             ELSE
               TRB->TOTMER := SF2->F2_VALBRUT - SF2->F2_VALFAT
          ENDIF
	  TRB->TOTIPI	:=	SF2->F2_VALIPI
	  TRB->TOTICM	:=	SF2->F2_VALICM
	  //TRB->TOTIPI   :=	  SD2->D2_VALIPI
	  //TRB->TOTICM   :=	  SD2->D2_VALICM
          TRB->TOTFRE   :=      SF2->F2_FRETE
          TRB->TOTSEG   :=      SF2->F2_SEGURO
          TRB->VALISS   :=      SF2->F2_VALISS
          TRB->TES      :=      SD2->D2_TES
          TRB->CFO      :=      SD2->D2_CF
          TRB->VEND     :=      _cCodiVend
          TRB->NOMEV    :=      _cNomeVend
          TRB->CLIENTE  :=      SF2->F2_CLIENTE
          TRB->LOJA     :=      SF2->F2_LOJA
          TRB->NOMEC    :=      _cNomeCli
          TRB->MUNIC    :=      _cMuniCli
          TRB->UF       :=      _cEstaCli
          TRB->TPCLI    :=      _cTipoCli

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

#IFDEF WINDOWS
    RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==>     RptStatus({|| Execute(Imprime)},titulo)
#ELSE
    Imprime()
#ENDIF


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Imprime
Static Function Imprime()


cabec1  := "Data     Nr.NF  N TES CFO   TOTAL DA NOTA VALOR FATURADO   TOTAL MERCAD  TOTAL DO IPI TOTAL DO ICMS  TOTAL DO ISS   TOTAL FRETE  TOTAL SEGURO CLIENTE   NOME DO CLIENTE           C MUNICIPIO       UF VENDED NOME VENDEDOR  "
          //99/99/99 999999 X 999 9999 999.999.999,99 999.999.999,99 999.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 999999-99 1234567890123456789012345 X 123456789012345 XX 999999 123456789012345
          //012345789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234578901234567890
          //        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210      220
cabec2  := ""
titulo  := "**** RELACAO DE NOTAS FISCAIS DE SAIDAS - COEL ****" 

_nContador := 0

DbSelectArea("TRB")
DbGoTop()
Setregua(Lastrec())
@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
Do While !Eof()
Incregua()
 If     _nContador == 0
        ImpDet()
        Acumula()
        _dData := TRB->EMISSAO
        _nContador := _nContador + 1
        DbSkip()
        Loop
   Else
        If  TRB->EMISSAO == _dData
            _dFlag := 1
          Else
            ImpTotDia()
        Endif

        If  TRB->NOTA == _dNota
            If  TRB->TES == _dTES
                DbSkip()
                Loop
              else
                @ nLin, 018 Psay TRB->TES   
                @ nLin, 022 Psay TRB->CFO   
                nLin := nLin + 1
            Endif
            DbSkip()
            Loop
        Endif

        ImpDet()
         If nLin > 59
            @ nLin, 000 Psay Replicate("-",190)+"Continua na Proxima Pagina----"
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
            nLin := 8
         Endif
        Acumula()
        _dData := TRB->EMISSAO
        _nContador := _nContador + 1
        DbSkip()
        Loop
 Endif
 ImpTotDia()
 If nLin > 59
    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
    nLin := 8
 Endif

EndDo

If nLin > 59
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
   nLin := 8
Endif

ImpTotDia()
If  _nContador == 0
    nLin := nLin + 1
    @nLin, 005 Psay " ***** SEM REGISTRO PARA OS PARAMETROS ESPECIFICADOS *****"
  Else
    @ nLin, 000 Psay "* TOTAL GERAL  --------->"
    @ nLin, 027 Psay _nTotNF[2]                  Picture "@E 999,999,999.99"
    @ nLin, 042 Psay _nTotVF[2]                  Picture "@E 999,999,999.99"
    @ nLin, 057 Psay _nTotME[2]                  Picture "@E 999,999,999.99"
    @ nLin, 072 Psay _nTotIP[2]                  Picture "@E 99,999,999.99"
    @ nLin, 086 Psay _nTotIC[2]                  Picture "@E 99,999,999.99"
    @ nLin, 100 Psay _nTotIS[2]                  Picture "@E 99,999,999.99"
    @ nLin, 114 Psay _nTotFR[2]                  Picture "@E 99,999,999.99"
    @ nLin, 128 Psay _nTotSE[2]                  Picture "@E 99,999,999.99"
    @ nLin, 142 Psay "- Quantidade de Notas: " + STR(_nConNF[2])
Endif
nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)
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

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Da Emissao     ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate Emissao    ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Da Nota        ? ','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate a Nota     ? ','mv_ch4','C',06, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Do Cliente     ? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'06','Da Loja        ? ','mv_ch6','C',02, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Ate o Cliente  ? ','mv_ch7','C',06, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'08','Ate a Loja     ? ','mv_ch8','C',02, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Do Vendedor    ? ','mv_ch9','C',06, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'10','Ate o Vendedor ? ','mv_cha','C',06, 0, 0,'G', '', 'mv_par10','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'11','Tipo de Nota   ? ','mv_chb','C',01, 0, 5,'C', '', 'mv_par12','Todos','','','Normal','','','Complementos','','','Beneficiamento','','','Devolucoes','',''})
    aadd(aRegs,{cPerg,'12','Tipo do Cliente? ','mv_chc','C',01, 0, 5,'C', '', 'mv_par13','Todos','','','Distribuidor','','','Revendedor','','','Produtor','','','Consumidor','',''})

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

*---------------------------------------------------------------------------*
* Retorna para sua Chamada (CFAT19R)                                        *
*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImpDet
Static Function ImpDet()
  @ nLin, 000 Psay Dtoc(TRB->EMISSAO)
  @ nLin, 009 Psay TRB->NOTA 
  @ nLin, 019 Psay TRB->TPN
  @ nLin, 021 Psay TRB->TES   
  @ nLin, 025 Psay TRB->CFO   
  @ nLin, 029 Psay TRB->TOTNF      Picture "@E 99,999,999.99"
  @ nLin, 042 Psay TRB->VALFT      Picture "@E 99,999,999.99"
  @ nLin, 057 Psay TRB->TOTMER     Picture "@E 99,999,999.99"
  @ nLin, 072 Psay TRB->TOTIPI     Picture "@E 99,999,999.99"
  @ nLin, 086 Psay TRB->TOTICM     Picture "@E 99,999,999.99"
  @ nLin, 100 Psay TRB->VALISS     Picture "@E 99,999,999.99"
  @ nLin, 114 Psay TRB->TOTFRE     Picture "@E 99,999,999.99"
  @ nLin, 128 Psay TRB->TOTSEG     Picture "@E 99,999,999.99"
  @ nLin, 142 Psay TRB->CLIENTE
  @ nLin, 149 Psay TRB->LOJA   
  @ nLin, 152 Psay TRB->NOMEC  
  @ nLin, 178 Psay TRB->TPCLI
  @ nLin, 180 Psay TRB->MUNIC  
  @ nLin, 196 Psay TRB->UF     
  @ nLin, 199 Psay TRB->VEND  
  @ nLin, 206 Psay TRB->NOMEV 
  nLin := nLin + 1
Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Acumula
Static Function Acumula()
  _nConNF[1] := _nConNF[1] + 1
  _nConNF[2] := _nConNF[2] + 1
  _nTotNF[1] := _nTotNF[1] + TRB->TOTNF
  _nTotNF[2] := _nTotNF[2] + TRB->TOTNF
  _nTotVF[1] := _nTotVF[1] + TRB->VALFT
  _nTotVF[2] := _nTotVF[2] + TRB->VALFT
  _nTotME[1] := _nTotME[1] + TRB->TOTMER
  _nTotME[2] := _nTotME[2] + TRB->TOTMER
  _nTotIP[1] := _nTotIP[1] + TRB->TOTIPI
  _nTotIP[2] := _nTotIP[2] + TRB->TOTIPI
  _nTotIC[1] := _nTotIC[1] + TRB->TOTICM
  _nTotIC[2] := _nTotIC[2] + TRB->TOTICM
  _nTotIS[1] := _nTotIS[1] + TRB->VALISS
  _nTotIS[2] := _nTotIS[2] + TRB->VALISS
  _nTotFR[1] := _nTotFR[1] + TRB->TOTFRE
  _nTotFR[2] := _nTotFR[2] + TRB->TOTFRE
  _nTotSE[1] := _nTotSE[1] + TRB->TOTSEG
  _nTotSE[2] := _nTotSE[2] + TRB->TOTSEG
  _dNota   := TRB->NOTA
  _dTes    := TRB->TES
  _dCfo    := TRB->CFO

Return

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function ImpTotDia
Static Function ImpTotDia()
 nLin := nLin + 3
 If   nLin > 59
      nLin := nLin - 2
      @ nLin, 000 Psay Replicate("-",190)+"Continua na Proxima Pagina----"
      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
      nLin := 8
   else
      nLin := nLin - 2
 Endif

 If   _nContador == 0
      @nLin, 005 Psay " ***** SEM REGISTRO PARA OS PARAMETROS ESPECIFICADOS *****"
    Else
      @ nLin, 000 Psay "* TOTAL DO DIA -> "+Dtoc(_dData)
      @ nLin, 026 Psay _nTotNF[1]   Picture "@E 999,999,999.99"
      @ nLin, 042 Psay _nTotVF[1]   Picture "@E 999,999,999.99"
      @ nLin, 057 Psay _nTotME[1]   Picture "@E 999,999,999.99"
      @ nLin, 072 Psay _nTotIP[1]   Picture "@E 99,999,999.99"
      @ nLin, 086 Psay _nTotIC[1]   Picture "@E 99,999,999.99"
      @ nLin, 100 Psay _nTotIS[1]   Picture "@E 99,999,999.99"
      @ nLin, 114 Psay _nTotFR[1]   Picture "@E 99,999,999.99"
      @ nLin, 128 Psay _nTotSE[1]   Picture "@E 99,999,999.99"
      @ nLin, 142 Psay "- Quantidade de Notas: " + STR(_nConNF[1])
      _nConNF[1] := 0
      _nTotNF[1] := 0
      _nTotVF[1] := 0
      _nTotME[1] := 0
      _nTotIP[1] := 0
      _nTotIC[1] := 0
      _nTotIS[1] := 0
      _nTotFR[1] := 0
      _nTotSE[1] := 0
      nLin := nLin + 1
      @ nLin, 000 Psay Replicate("-",limite)
      nLin := nLin + 1
 Endif
Return
/*/
*---------------------------------------------------------------------------*
* Lay Out do Relatorio                                                      *
*---------------------------------------------------------------------------*
Data     Nr.NF  N TES CFO  TOTAL DA NOTA VALOR FATURADO   TOTAL MERCAD  TOTAL DO IPI TOTAL DO ICMS  TOTAL DO ISS   TOTAL FRETE  TOTAL SEGURO CLIENTE   NOME DO CLIENTE           C MUNICIPIO       UF VENDED NOME VENDEDOR
99/99/99 999999 X 999 999 999.999.999,99 999.999.999,99 999.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 999999-99 1234567890123456789012345 X 123456789012345 XX 999999 123456789012345
                |                                                                                                                                                                |
                +----- N=NORMAL                                                                                                                                                  |
                       C=COMPLEMENTO DE PRECO                                                                                                         CATEGORIA DO CLIENTE >-----+
                       I=COMPLEMENTO DE ICMS                                                                                                          D=DISTRIBUIDOR
                       P=COMPLEMENTO DO IPI                                                                                                           R=REVENDEDOR   
                       B=BENEFICIAMENTO  (FORNECEDOR)                                                                                                 P=PRODUTOR/INDUSTRIALIZACAO
                       D=DEVOLUCAO       (FORNECEDOR)                                                                                                 C=CONSUMIDOR/MANUTENCAO
                                                                                                                                                      T=TODOS
*/
