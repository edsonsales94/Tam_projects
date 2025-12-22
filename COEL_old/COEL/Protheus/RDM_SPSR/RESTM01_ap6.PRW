#include "rwmake.ch"     

User Function RESTM01()   

SetPrvt("C_SVSCEST,LPERG,_CPRODUTO,_CLOCAL,_DDATA,_NVALORUN")
SetPrvt("_NQTD,_CKEY_TOT,_CIND_TOT,")

/*/
@---------------------------------------------------------------------------@
| Programa  | RESTM01  | Autor|Rogerio Batista         | Data |25.04.2001   |
@---------------------------------------------------------------------------@
| Descricao | Programa para importar o Custo unitario dos produtos.         |
@---------------------------------------------------------------------------@
| Uso       | Especifico                                                    |
@---------------------------------------------------------------------------@
/*/

        If !MsgBox("Esta  rotina  ira' importar um arquivo gerado pelo Reinaldo (Sao Roque)"+Chr(13);
                  +"com o custo do Produto apos a virada de saldos","Importacao de Custos","YesNo")
           Return 
        EndIf

AbreArq()

PROCESSA({|| _ProcArq()},"Processa Arquivos...")

Return()    

Static Function _ProcArq()

dbSelectArea("TOT")

    ProcRegua(Reccount())

While !Eof()

          IncProc()

        _cProduto := TOT->CODIGO
        _cLocal   := TOT->LOCAL
        _dData    := TOT->EMISSAO
        _nValorUn := TOT->CUSMED

        dbSelectArea("SB9")
        dbSetOrder(1)
        dbSeek(xfilial("SB9")+_cProduto+_cLocal+Dtos(_dData))

        If Found()
             _nQTD := SB9->B9_QINI

             RecLock("SB9",.F.)
               If _nQTD <= 0
                 SB9->B9_VINI1  := _nValorUn
               Else
                 SB9->B9_VINI1  := _nValorUn*_nQTD
               EndIf
               SB9->B9_VINI2  := 0
               SB9->B9_VINI3  := 0
               SB9->B9_VINI4  := 0
               SB9->B9_VINI5  := 0

             MsUnlock()
        EndIf

          _nQTD := "0"


      dbSelectArea("TOT")
      dbSkip()

EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno index e apaga index temporario                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB9")
RetIndex("SB9")

dbSelectArea("TOT")
dbCloseArea()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ABREARQ  ³ Autor ³Rogerio Batista        ³ Data ³ 25/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Abertura de Arquivos                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AbreArq()

dbUseArea(.T.,,"\ARQUIVOS\CUSTOMAO","TOT",.T.,.F.)
_cKey_TOT := "CODIGO"
_cInd_TOT := CriaTrab(Nil,.F.)
INDREGUA("TOT",_cInd_TOT,_cKey_TOT,,,"Filtrando Movimentos...")
dbGotop()

Return

