#include "rwmake.ch"        
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Cfat86s()     


SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,LEND")
SetPrvt("TAMANHO,LIMITE,TITULO,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("ADRIVER,CBCONT,CPERG,NLIN,M_PAG,_NQUANT")
SetPrvt("_NVALOR,AESTRU2,_CTEMP2,_CINDSD21,_CCHASD21,_FLAGT")
SetPrvt("CABEC1,CABEC2,_FLAG,NPAG,_DDTDIG,AREGS")
SetPrvt("I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT86S  ³ Autor ³Adilson M Takeshima    ³ Data ³02/05/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Saidas de Produtos por TES/Data de Emissao NF   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³ SO RESUMO POR DIA                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 02/09/02 ==>     #DEFINE PSAY SAY
#ENDIF
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*

wnrel     := "CFAT86S"
cDesc1    := "Resumo de Saidas"
cDesc2    := " "
cDesc3    := " "
cString   := "SD2"
lEnd      := .F.
tamanho   := "M"
limite    := 132
titulo    := "Resumo de Saidas"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CFAT86R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT86R"
nLin      := 7
m_pag     := 1
_nQuant   := { 0,0}
_nValor   := { 0,0}
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da   Data de Emissao                                      *
* mv_par02  ----> Ate  Data de Emissao                                      *
* mv_par03  ----> Tes de Saidas                                             *
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
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*

aEstru2 :={}
AADD(aEstru2,{"EMISSAO" ,"D",08,0})
AADD(aEstru2,{"NOTA"    ,"C",06,0})
AADD(aEstru2,{"PV"      ,"C",06,0})
AADD(aEstru2,{"TES"     ,"C",03,0})
AADD(aEstru2,{"TIPO"    ,"C",04,0})
AADD(aEstru2,{"PRODUTO" ,"C",15,0})
AADD(aEstru2,{"ITEM"    ,"C",02,0})
AADD(aEstru2,{"DESCRI"  ,"C",30,0})
AADD(aEstru2,{"QUANT"   ,"N",11,2})
AADD(aEstru2,{"VALOR"   ,"N",12,2})
AADD(aEstru2,{"CLIFOR"  ,"C",06,0})
AADD(aEstru2,{"LOJA"    ,"C",02,0})
AADD(aEstru2,{"NOMECF"  ,"C",30,0})

_cTemp2 := CriaTrab( aEstru2, .T. )  
dbUseArea(.T.,,_cTemp2,"TRB", NIL, .F. )
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
Processa({||RunProc()},"Filtrando Dados ...")
Return

Static Function RunProc()



DbSelectArea("SD2")         //----> Itens das Notas de Saidas  
_cIndSD21 := CriaTrab(Nil,.f.)
_cChaSD21 := "SD2->D2_FILIAL+DTOS(SD2->D2_EMISSAO)+SD2->D2_CLIENTE"

IndRegua("SD2",_cIndSD21,_cChaSD21,,,"Selecionando Registros SD2 (Indice Temp) ...")
ProcRegua(RecCount())

DbSeek(xFilial("SD2")+Dtos(mv_par01),.t.)

Do While !Eof() .AND. Dtos(SD2->D2_EMISSAO) <= Dtos(mv_par02)
    IncProc("Selecionando Dados da NOTA: "+SD2->D2_DOC)

   If !SD2->D2_TES $ AllTrim(mv_par03)
         dbSkip()
         Loop
   EndIf

        DbSelectArea("TRB")
        RecLock("TRB",.t.)

          TRB->EMISSAO  :=      SD2->D2_EMISSAO
          TRB->NOTA     :=      SD2->D2_DOC
          TRB->PV       :=      SD2->D2_PEDIDO
          TRB->TES      :=      SD2->D2_TES 
          If      SD2->D2_TIPO == "N"
                  TRB->TIPO := "NORM"
                  _flagt := 1
          Elseif  SD2->D2_TIPO == "B"
                  TRB->TIPO := "BENF"
                  _flagt := 2
          Elseif  SD2->D2_TIPO == "C"
                  TRB->TIPO := "COMP"
                  _flagt := 1
          Elseif  SD2->D2_TIPO == "D"
                  TRB->TIPO := "DEVL"
                  _flagt := 2
          Elseif  SD2->D2_TIPO == "P"
                  TRB->TIPO := "CIPI"
                  _flagt := 1
          Elseif  SD2->D2_TIPO == "I"
                  TRB->TIPO := "CICM"
                  _flagt := 1
          Endif
          TRB->PRODUTO  :=      SD2->D2_COD
          TRB->ITEM     :=      SD2->D2_ITEM
          TRB->DESCRI   :=      Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_DESC")            
          TRB->QUANT    :=      SD2->D2_QUANT            
          TRB->VALOR    :=      SD2->D2_TOTAL+SD2->D2_VALIPI            
          TRB->CLIFOR   :=      SD2->D2_CLIENTE                
          TRB->LOJA     :=      SD2->D2_LOJA                
          If      _flagt == 2
                  TRB->NOMECF := Posicione("SA2",1,xFilial("SA2")+SD2->D2_CLIENTE + SD2->D2_LOJA,"A2_NOME")
           Else
                  TRB->NOMECF := Posicione("SA1",1,xFilial("SA1")+SD2->D2_CLIENTE + SD2->D2_LOJA,"A1_NOME")
          Endif


        MsUnLock()

        DbSelectArea("SD2")
        DbSkip()
EndDo
*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*

RptStatus({|| Imprime()},titulo)

Return(nil)        

Static Function Imprime()

          //0         1         2         3         4         5         6         7         8         9        10         11  11
          //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567                 
cabec1  := "PRODUTO  DESCRICAO                      QUANTIDADE  VALOR+IPI DT.EMISS NR.NFS PD.VEN TES TIPO CLIENTE   NOME DO CLIENTE "
          //99999999 123456789012345678901234567890 999.999,99 999.999,99 99/99/99 123456 XXXXXX 999 XXXX 123456-12 1234567890123456789

cabec2  := ""
titulo  := " RELACAO DETALHADA DE SAIDAS POR TES/DATA EMISSAO" 

_flag := 0
nLin := 7
nPag := 1

DbSelectArea("TRB")
DbGoTop()
Setregua(Lastrec())
@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
Do While !Eof()
Incregua()

   If  _flag == 0
       _dDtdig := TRB->EMISSAO
       _flag := 1
   Endif

   If  _dDtdig <> TRB->EMISSAO
       Totaldia()
   Endif

// @nLin,  00 PSAY TRB->PRODUTO
// @ nLin, 10 PSAY TRB->DESCRI
// @nLin,  41 PSAY TRB->QUANT        Picture "@E 999,999.99"
   _nQuant[1] := _nQuant[1] + TRB->QUANT
   _nQuant[2] := _nQuant[2] + TRB->QUANT
// @nLin,  51 PSAY TRB->VALOR  Picture "@E 999,999.99"   
   _nValor[1] := _nValor[1] + TRB->VALOR
   _nValor[2] := _nValor[2] + TRB->VALOR
// @nLin,  62 PSAY TRB->EMISSAO   
// @nLin,  71 PSAY TRB->NOTA  
// @nLin,  78 PSAY TRB->PV    
// @nLin,  85 PSAY TRB->TES
// @nLin,  89 PSAY TRB->TIPO
// @nLin,  94 PSAY TRB->CLIFOR    
// @nLin,  100 PSAY "-"
// @nLin,  101 PSAY TRB->LOJA   
// @nLin,  104 PSAY TRB->NOMECF 
// nLin := nLin + 1

   If nLin > 56
      @ nLin, 000 Psay Replicate("-",87)+"Continua na Proxima Pagina----"
      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
      nLin := 7
   Endif

    DbSkip()

Enddo

If nLin > 59
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
   nLin := 7
Endif
@ nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1
@nLin,  01 PSAY " TOTAL DO DIA -> "+DTOC(_dDtdig)
@nLin,  41 PSAY _nQuant[1]        Picture "@E 999,999.99"
@nLin,  52 PSAY _nValor[1]       Picture "@E 999,999.99"
nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1
@nLin,  01 PSAY " TOTAL NO PERIODO -> "+DTOC(MV_PAR01)+" A "+DTOC(MV_PAR02)
@nLin,  41 PSAY _nQuant[2]       Picture "@E 999,999.99"
@nLin,  52 PSAY _nValor[2]       Picture "@E 99,999,999.99"

Roda(cbCont,"Pedidos",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

DbCloseArea("TRB")
Ferase(_cTemp2+".dbf")
Ferase(_cTemp2+".idx")
Ferase(_cTemp2+".mem")

MS_FLUSH()

Return

*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function Totaldia
Static Function Totaldia()
         nLin := nLin + 1
         @ nLin, 000 Psay Replicate("-",limite)
         nLin := nLin + 1
         @nLin,  01 PSAY " TOTAL DO DIA -> "+DTOC(_dDtdig)
         @nLin,  41 PSAY _nQuant[1]        Picture "@E 999,999.99"
         @nLin,  52 PSAY _nValor[1]        Picture "@E 99,999,999.99"
         _nQuant[1] := 0
         _nValor[1] := 0
         nLin := nLin + 1
         @ nLin, 000 Psay Replicate("-",limite)
         nLin := nLin + 1
         _dDtdig := TRB->EMISSAO
Return

Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Dta Incial Emissao   ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Dta Final  Emissao   ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Contem os Tes        ? ','mv_ch3','C',30, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})

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
