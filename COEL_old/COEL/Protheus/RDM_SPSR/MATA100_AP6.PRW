#include "rwmake.ch"        

User Function mata100()     

SetPrvt("_CALIAS,_NORDER,_NRECNO,_CCODFIL,_ORDF1,_RECF1")
SetPrvt("_ORDE2,_RECE2,_CPREF,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATA100  ³ Autor ³Ricardo Correa de Souza³ Data ³16/12/1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava Conta Contabil no Contas a Pagar para IRRF/INSS/ISS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Correa³08/08/01³Alteracao do Codigo dos Fornecedores           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cAlias := Alias()
_nOrder := IndexOrd()
_nRecno := Recno()

_cCodFil:= SM0->M0_CODFIL  // Guarda o Codigo da Filial em uso

DbSelectArea("SF1")
_OrdF1:= IndexOrd() // Guardo a ordem padrao do arquivo
_RecF1:= Recno()    // Guardo o registro posicionado
DbSetOrder(1)

DbSelectArea("SE2")
_OrdE2:= IndexOrd() // Guardo a ordem padrao do arquivo
_RecE2:= Recno()    // Guardo o registro posicionado
DbSetOrder(1)

If _cCodFil == "01"
    _cPref:="SPO"
Else
    _cPref:="SRE"
EndIf

DbSeek(xFilial()+_cPref+SF1->F1_DOC)
While !Eof() .and. SE2->E2_PREFIXO+SE2->E2_NUM == _cPref+SF1->F1_DOC
    If SF1->F1_FORNECE+SF1->F1_LOJA == SE2->E2_FORNECE+SE2->E2_LOJA
        If NIRRF > 0
            DbSelectArea("SE2")
            DbSeek(xFilial("SE2")+_cPref+SF1->F1_DOC+"1"+"TX "+"900902") 
            RecLock("SE2",.F.)
              SE2->E2_CLCONTA := "200311"
            MsUnLock()
        EndIf
        If NVALINSS > 0
            DbSelectArea("SE2")
            DbSeek(xFilial("SE2")+_cPref+SF1->F1_DOC+"1"+"INS"+"900903") 
            RecLock("SE2",.F.)
              If _cCodFil == "01"
                  SE2->E2_CLCONTA := "200203"
              Else
                  SE2->E2_CLCONTA := "200204"
              EndIf
            MsUnLock()
        EndIf
    EndIf
    DbSkip()
EndDo

DbSelectArea(_cAlias)   // Retornando a Area Corrente antes do processamento
DbSetOrder(_nOrder)     // Retornando o Indice Corrente antes do processamento
DbGoTo(_nRecno)         // Retornando o Registro Corrente antes do processamento

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna ao ponto de sua chamada - MATA100                                 *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


