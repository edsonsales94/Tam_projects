#include "rwmake.ch"  

User Function Cfin03i()

SetPrvt("_CCONTADEB,")

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFIN03I  ³ Autor ³Ricardo Correa de Souza³ Data ³20/07/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Execblock que Retorna a Conta Debito no LP 560/01          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*

_cContaDeb := ""

// Alterado by Rogerio
                                
Do Case

   Case Alltrim(SE5->E5_NATUREZ)$"1105"
       _cContaDeb := "10134080"

   Case Alltrim(SE5->E5_NATUREZ)$"1106"
       _cContaDeb := Posicione("SED",1,xFilial("SED")+SE5->E5_NATUREZ,"ED_CLCONTA")

   Case ! Alltrim(SE5->E5_NATUREZ)$"1105/1106"
       _cContaDeb := Posicione("SA6",1,xFilial("SA6")+SE5->E5_BANCO,"A6_CONTA")

EndCase

                                               
/*
//----> natureza igual a "OUTRAS ENTRADAS"
If Alltrim(SE5->E5_NATUREZ)$"1105"
    _cContaDeb := "10134080"
                                  
//----> natureza igual a "ENTRADA ADIANT. C/C"
ElseIf Alltrim(SE5->E5_NATUREZ)$"1106"
    _cContaDeb := Posicione("SED",1,xFilial("SED")+SE5->E5_NATUREZ,"ED_CLCONTA")

//----> banco igual a "UNIBANCO CAUCAO"
ElseIf SE5->E5_BANCO $"006"
    _cContaDeb := "10018"

//----> banco igual a "ITAU CAUCAO 1" ou "ITAU CAUCAO 2"
ElseIf SE5->E5_BANCO $"011/012"
    _cContaDeb := "10013"

//----> banco igual a "DEMAIS BANCOS"
Else
    _cContaDeb := Posicione("SA6",1,xFilial("SA6")+SE5->E5_BANCO,"A6_CONTA")
EndIf
*/
Return(_cContaDeb)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
