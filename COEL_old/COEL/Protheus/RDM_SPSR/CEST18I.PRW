#include "rwmake.ch"        

User Function CEST18I()      

SetPrvt("_NCUSTOUNIT,_NCUSTOITEM,_NCUSTOTOTAL,_CPERG,CPRODUTO,AREGS")
SetPrvt("I,J,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CEST18I  ³ Autor ³Ricardo Correa de Souza³ Data ³22/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Custo Standard para Estrutura de Produtos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/


_nCustoUnit  := 0   //----> custo unitario do componente
_nCustoItem  := 0   //----> 
_nCustoTotal := 0
_cPerg       := "EST18I" 

                    
        If !MsgBox("Esta  rotina  ira clcular o custo dos produtos pelo standard, precisa rodar primeiro os PI's"+Chr(13);
                  +" depois rodar os PA's e PP's.","Calculo do custo Standard","YesNo")
           Return 
        EndIf       
        
Pergunte(_cPerg,.t.)
                     
        If !MsgBox("Confirma?","Calculo do custo Standard","YesNo")
           Return 
        EndIf                 

Processa({||RunProc()},"Atualiza Custo Standard Produtos")
Return

Static Function RunProc()


DbSelectArea("SG1")
DbSetOrder(1)
dbSeek(xFilial("SG1")+MV_PAR03)

//ProcRegua(LastRec())

cProduto := SG1->G1_COD

While !Eof() 
                                                                
    If SG1->G1_COD < mv_par03 .AND. SG1->G1_COD > mv_par04
        DbSkip()
        Loop
    EndIf

   IncProc("Processando Produtos "+SG1->G1_COD)

    DbSelectArea("SB1")
    DbSetOrder(1)
    DbSeek(xFilial("SB1")+cProduto)

    If SB1->B1_TIPO < mv_par01 .AND. SB1->B1_TIPO > mv_par02
        DbSkip()
        Loop
    EndIf

    While SG1->G1_COD == cProduto

        DbSelectArea("SB1")
        DbSetOrder(1)
        DbSeek(xFilial("SB1")+SG1->G1_COMP)     
        
        If mv_par05 == 1
        
         If SB1->B1_TIPO $ "MP/PI"
            _nCustoUnit  := SB1->B1_CUSTD
            _nCustoItem  := noRound(SG1->G1_QUANT * _nCustoUnit,4)
            _nCustoTotal := noRound(_nCustoTotal  + _nCustoItem,4)
         EndIf

        Else

          _nCustoUnit  := SB1->B1_CUSTD
          _nCustoItem  := noRound(SG1->G1_QUANT * _nCustoUnit,4)
          _nCustoTotal := noRound(_nCustoTotal  + _nCustoItem,4)

        EndIf
        
        DbSelectArea("SG1")
        DbSkip()
    EndDo

    DbSelectArea("SB1")
    DbSetOrder(1)
    DbSeek(xFilial("SB1")+cProduto)  
    
    If SB1->B1_TIPO $ "PA/PI/PP"
      RecLock("SB1",.f.)
        SB1->B1_CUSTD := noRound(_nCustoTotal,4)
      MsUnLock()               
    EndIf

    _nCustoTotal := 0

    DbSelectArea("SG1")    
    cProduto := SG1->G1_COD
EndDo


DbSelectArea("SB1")
DbSetOrder(1)
DbGoTop()

Return()

