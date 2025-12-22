#include "rwmake.ch"        

User Function restm03()


SetPrvt("_CARQEST,_NCUSTOUNIT,_NCUSTOITEM,_NCUSTOTOTAL,_CINDEST,_CCHAEST")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CEST15I  ³ Autor ³Rogerio B.Oliveroa     ³ Data ³21/01/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Importa cadastro de produtos                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

_cPath       := "\ARQUIVOS\"
_cArqEst     := _cPath+"PRODUTOS.DBF"
_nCustoUnit  := 0   //----> custo unitario do componente
_nCustoItem  := 0   //----> 
_nCustoTotal := 0
                                           

DbSelectArea("SB1")     // Produtos       
DbSetOrder(1)           // Filial + Codigo                           


Processa({||RunProc()},"Importa Produtos")
Return

Static Function RunProc()

//DbUseArea(.T.,__cRdd,_cArqEst,"EST",IF(.T. .OR. .F., !.F., NIL), .F. )
DbUseArea(.T.,,_cArqEst,"PRO", NIL, .F. )

_cIndEst := CriaTrab(Nil,.f.)
_cChaEst := "PRO->B1_COD"

IndRegua("PRO",_cIndEst,_cChaEst,,,"Importando produtos")
//----> Indexando por PRODUTO

DbSelectArea("PRO")
DbGoTop()
ProcRegua(LastRec())

Do While Eof() == .f.

    IncProc("Processando Produto "+PRO->B1_COD)

    DbSelectArea("SB1")
    If !dbSeek(xFilial("SB1")+PRO->B1_COD)
        RecLock("SB1",.t.)
          SB1->B1_COD     := PRO->B1_COD
          SB1->B1_CLSTATU := "A"
          SB1->B1_DESC    := PRO->B1_DESC
          SB1->B1_NARRA   := PRO->B1_NARRA
          SB1->B1_DESCOMP := PRO->B1_DESCOMP
          SB1->B1_TIPO    := "MP"
          SB1->B1_CLESPEC := PRO->B1_CLESPEC
          SB1->B1_CLGOP   := PRO->B1_CLGOP
          SB1->B1_GRUPO   := PRO->B1_GRUPO
          SB1->B1_PICM    := PRO->B1_PICM
          SB1->B1_POSIPI  := PRO->B1_POSIPI
          SB1->B1_ORIGEM  := PRO->B1_ORIGEM
          SB1->B1_IMPZFRC := PRO->B1_IMPZFRC
          SB1->B1_UM      := PRO->B1_UM
          SB1->B1_SEGUM   := PRO->B1_SEGUM
          SB1->B1_TIPCONV := PRO->B1_TIPCONV
      //    SB1->B1_CUSTD   := PRO->B1_CUSTD
      //    SB1->B1_PESO    := PRO->B1_PESO
          SB1->B1_APROPRI := PRO->B1_APROPRI
          SB1->B1_TIPODEC := PRO->B1_TIPODEC
          SB1->B1_DATREF  := PRO->B1_DATREF
          SB1->B1_RASTRO  := PRO->B1_RASTRO
          SB1->B1_UREV    := PRO->B1_UREV
          SB1->B1_MRP     := PRO->B1_MRP
          SB1->B1_CODBAR  := PRO->B1_CODBAR
          SB1->B1_LOCALIZ := PRO->B1_LOCALIZ
          SB1->B1_CONTRAT := PRO->B1_CONTRAT
          SB1->B1_IMPORT  := PRO->B1_IMPORT
          SB1->B1_ANUENTE := PRO->B1_ANUENTE
          SB1->B1_OPAUTOM := PRO->B1_OPAUTOM
          SB1->B1_TIPOCQ  := PRO->B1_TIPOCQ
          SB1->B1_SOLICIT := PRO->B1_SOLICIT
          SB1->B1_CRTORG  := PRO->B1_CRTORG
          SB1->B1_INSS    := PRO->B1_INSS
          SB1->B1_CLSITE  := PRO->B1_CLSITE
          SB1->B1_CLTPCQ  := PRO->B1_CLTPCQ
          SB1->B1_CLASSVE := PRO->B1_CLASSVE
          SB1->B1_ENVOBR  := PRO->B1_ENVOBR
          SB1->B1_FLAGSUG := PRO->B1_FLAGSUG
          SB1->B1_MCUSTD  := PRO->B1_MCUSTD
          SB1->B1_QTDSER  := PRO->B1_QTDSER
          SB1->B1_ATIVO   := PRO->B1_ATIVO
          SB1->B1_X_VENDA := PRO->B1_X_VENDA
          SB1->B1_X_FABRI := PRO->B1_X_FABRI
          SB1->B1_X_MRPAM := PRO->B1_X_MRPAM
          SB1->B1_CPOTENC := PRO->B1_CPOTENC
          SB1->B1_MSBLQL  := PRO->B1_MSBLQL
          SB1->B1_AGREGCU := PRO->B1_AGREGCU
          SB1->B1_USAFEFO := PRO->B1_USAFEFO
          SB1->B1_PIS     := PRO->B1_PIS
          SB1->B1_COFINS  := PRO->B1_COFINS
          SB1->B1_CSLL    := PRO->B1_CSLL
          SB1->B1_RETOPER := PRO->B1_RETOPER
          SB1->B1_DESPIMP := PRO->B1_DESPIMP
     //     SB1->B1_FETHAB  := PRO->B1_FETH
     //     SB1->B1_ESCRIPI := PRO->B1_ESCRIPI
         MsUnLock()
    EndIf

    DbSelectArea("PRO")
    DbSkip()
EndDo

DbSelectArea("PRO")
DbCloseArea("PRO")

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02


/*
Observacoes:

ESTRUTURA DO ARQUIVO

CAMPO   TIPO    TAMANHO     DECIMAL
COD     C       15          0
PRECO   N       11          4

*/
