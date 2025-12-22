#include "rwmake.ch"

User Function alt_cp()

SetPrvt("WE2_PREFIXO,WE2_NUM,WE2_PARCELA,WE2_FORNECE,WE2_LOJA,WE2_NOMFOR")


dbSelectArea("SE2")
dbSetOrder(1)

While .T.
      WE2_PREFIXO := SPACE(03)
      WE2_NUM     := SPACE(09)
      WE2_PARCELA := SPACE(02)
      WE2_FORNECE := SPACE(06)
      WE2_LOJA    := SPACE(02)
      WE2_NOMFOR  := SPACE(20)
                                                                                                                                   


      @ 0,0 TO 160,400 DIALOG oDlg1 TITLE "Pesquisa Titulo"
      @ 12,010 SAY "TITULO"
      @ 12,070 GET WE2_NUM     PICTURE "@!"   F3("SE2") SIZE 40,15
//    @ 27,010 SAY "ITEM DO PEDIDO"
//    @ 27,060 GET WC6_ITEM PICTURE "@!"   SIZE 20,15
      @ 57,015 BMPBUTTON TYPE 1 ACTION _ConfDados()
      @ 57,060 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
      ACTIVATE DIALOG oDlg1 CENTERED
      Exit
ENDDO

Return
/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³refrDlg   ³ Autor ³ Ary Medeiros          ³ Data ³ 15.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa o Refresh do Dialogo                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/  
Static Function _ConfDados()



_cWC5KEY := xFilial("SE2")+"1  "+WE2_NUM
dbSelectArea("SE2")
dbSetOrder(1)
dbSeek(_cWC5KEY)

If Eof()
    Tone(500,1)
    Alert("Titulos nao encontrado!!!")
Else  
 
// _Escolha :={iif(SC5->C5_TPFRETE=="C","C-CIF","F-FOB"),"C-CIF","F-FOB"}
// _Escolha2:={iif(SC5->C5_TPCARGA=="1","1-Utiliza","2-Nao utiliza"),"1-Utiliza","2-Nao utiliza"}
 
  
    WE2_PREFIXO := SE2->E2_PREFIXO
    WE2_NUM     := SE2->E2_NUM
    WE2_PARCELA := SE2->E2_PARCELA
    WE2_FORNECE := SE2->E2_FORNECE
    WE2_LOJA    := SE2->E2_LOJA
    WE2_NOMFOR  := SE2->E2_NOMFOR

    @ 0,0 TO 300,600 DIALOG oDlg2 TITLE "Alteracao de Titulos a Pagar"
    @ 07,008 SAY "TITULO     "
    @ 07,060 GET WE2_NUM                        F3("SE2") SIZE 50,15
    @ 17,008 SAY "FORNECE    "
    @ 17,060 GET WE2_FORNECE                    F3("SA2") SIZE 50,15
    @ 27,008 SAY "LOJA          "
    @ 27,060 GET WE2_LOJA               WHEN .T. SIZE 40,15

//  @ 87,008 SAY "COD.STATUS"
//  @ 87,050 GET WC6_STATU F3("YJ ")   SIZE 12,08

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
    RecLock("SE2",.F.)
       SE2->E2_FORNECE := WE2_FORNECE
       SE2->E2_LOJA    := WE2_LOJA   

    MsUnLock()
    MsgBox("Alteracao Gravada Com Sucesso!","Atençao","INFO" ) 
Else
    MsgBox("Alteracao Nao Efetuada!","Atençao","INFO" ) 
EndIf
Close(oDlg2)      
Return()
