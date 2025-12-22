#include "rwmake.ch"        

User Function Cest90i()     


SetPrvt("CPERG,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CEST90I  ³ Autor ³Adilson M.Takeshima    ³ Data ³31/07/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera arquivo SB7-Inventario c/itens selecionados no parame ³±±
±±³          ³ tro com quantidades zeradas                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
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
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Parametros Utilizados                                                     *
*                                                                           *
* mv_par01      ----> Para Filial                                           *
* mv_par02      ----> Para Local                                            *
* mv_par03      ----> Produto Inicial                                       *
* mv_par04      ----> Produto Final                                         *                             
* mv_par05      ----> Numero para DOC                                       *                             
* mv_par06      ----> Data do Inventario                                    *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cPerg:= "EST90I"


//----> verifica se o usuario cancelou a execucao
If ! Pergunte(cPerg,.T.)
    Return
EndIf

Processa({||RunProc()},"Gera Registros Zerados no Inventario")

Return

Static Function RunProc()

DbSelectArea("SB2")
DbSetOrder(1)
DbSeek(xFilial("SB2")+MV_PAR03,.t.)

ProcRegua(LastRec())
While !Eof() .And. SB2->B2_COD <= MV_PAR04
   
   dbSelectArea("SB1")
   dbSetOrder(1)
   dbSeek(xFilial("SB1")+SB2->B2_COD)
                          
   
    If !SB1->B1_TIPO $ "PA/PP/PI/MP/MC"
       dbSelectArea("SB2")
       dbSkip()
       Loop    
    EndIf
                                           
    If !SB2->B2_LOCAL $ MV_PAR02 
       dbSelectArea("SB2")
       dbSkip()
       Loop    
    EndIf 
    
   
    
    IncProc("Selecionando Item "+SB2->B2_COD)

        DbSelectArea("SB7")
        RecLock("SB7",.t.)
          SB7->B7_FILIAL  := MV_PAR01
          SB7->B7_COD     := SB2->B2_COD
          SB7->B7_LOCAL   := MV_PAR02      
          SB7->B7_TIPO    := SB1->B1_TIPO
          SB7->B7_DOC     := MV_PAR05      
          SB7->B7_DATA    := MV_PAR06      
          SB7->B7_DTVALID := MV_PAR06      
        MsUnLock()

        DbSelectArea("SB2")
        DbSkip()
EndDo

Return

