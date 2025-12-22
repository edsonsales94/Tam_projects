#include "rwmake.ch"

User Function altcad()

SetPrvt("WB1_COD,WB1_DESC,WB1_TIPO,WB1_POSIPI,WB1_X_DCR")


dbSelectArea("SB1")
dbSetOrder(1)

While .T.
      WB1_COD     := SPACE(15)
      WB1_DESC    := SPACE(30)
      WB1_TIPO    := SPACE(02)
      WB1_POSIPI  := SPACE(10)
      WB1_X_DCR   := SPACE(11)
      
      @ 0,0 TO 160,400 DIALOG oDlg1 TITLE "Pesquisa Produto"
      @ 12,010 SAY "CODIGO DO PRODUTO"
      @ 12,070 GET WB1_COD  PICTURE "@!"   F3("SB1") SIZE 40,15
//    @ 27,010 SAY "ITEM DO PEDIDO"
//    @ 27,060 GET WC6_ITEM PICTURE "@!"   SIZE 20,15
      @ 57,015 BMPBUTTON TYPE 1 ACTION _ConfDados()
      @ 57,060 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
      ACTIVATE DIALOG oDlg1 CENTERED
      Exit
ENDDO

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³refrDlg   ³ Autor ³ Ary Medeiros          ³ Data ³ 15.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa o Refresh do Dialogo                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
Static Function _ConfDados()

_cWB1KEY := xFilial("SB1")+WB1_COD
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(_cWB1KEY)

If Eof()
    Tone(500,1)
    Alert("Produto nao encontrado !!!")
Else
    WB1_COD     := SB1->B1_COD
    WB1_DESC    := SB1->B1_DESC
    WB1_TIPO    := SB1->B1_TIPO
    WB1_POSIPI  := SB1->B1_POSIPI
    WB1_X_DCR   := SB1->B1_X_DCR                                                                       
    WB1_CONTA   := SB1->B1_CONTA
    @ 0,0 TO 200,600 DIALOG oDlg2 TITLE "Alteracao de NCM e DCR do produto"
    @ 07,008 SAY "PRODUTO     "
    @ 07,050 GET WB1_COD                        WHEN .F. SIZE 40,15
    @ 17,008 SAY "DESC        "
    @ 17,050 GET WB1_DESC                       WHEN .F. SIZE 100,15
    @ 27,008 SAY "TIPO        "
    @ 27,050 GET WB1_TIPO                       WHEN .F. SIZE 40,15
    @ 37,008 SAY "NCM - POSIPI"
    @ 37,050 GET WB1_POSIPI                     SIZE 50,15
    @ 47,008 SAY "DCR         " 
    @ 47,050 GET WB1_X_DCR                      SIZE 50,15
    @ 57,008 SAY "CONTA         " 
    @ 57,050 GET WB1_CONTA                      SIZE 50,15

//  @ 87,008 SAY "COD.STATUS"
//  @ 87,050 GET WC6_STATU F3("YJ ")   SIZE 12,08
//    @ 87,100 SAY "STATUS"
//    @ 87,140 GET WC6_DESST                      SIZE 40,20

    @ 15,250 BUTTON "_Gravar" SIZE 40,15 ACTION _Gravar()
    @ 35,250 BUTTON "_Sair" SIZE 40,15 ACTION Close(oDlg2)      
    ACTIVATE DIALOG oDlg2 CENTERED
    End
    Return

Static Function _Gravar()

If MsgYesNo("Confirma Gravacao? ")
    nOpc := 1
Else
    nOpc := 2
Endif

If nOpc==1
    RecLock("SB1",.F.)
       SB1->B1_POSIPI  := WB1_POSIPI
       SB1->B1_X_DCR   := WB1_X_DCR 
       SB1->B1_CONTA   := WB1_CONTA
    MsUnLock()
    MsgBox("Alteracao Gravada Com Sucesso!","Atençao","INFO" ) 
Else
    MsgBox("Alteracao Nao Efetuada!","Atençao","INFO" ) 
EndIf
Close(oDlg2)      
Return()
