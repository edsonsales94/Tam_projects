#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Cest05i()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CARQEST,_CINDEST,_CCHAEST,AESTRU1,_CTEMP1,_CPROD")
SetPrvt("TITULO,CABEC1,CABEC2,CDESC1,CDESC2,CSTRING")
SetPrvt("ARETURN,WNREL,TAMANHO,LIMITE,M_PAG,CBCONT")
SetPrvt("LI,NITENS,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CEST05I  ³ Autor ³Ricardo Correa de Souza³ Data ³14.08.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Importacao Consumo Mensal e Estoque Seguranca.             ³±±
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
* Arquivos Utilizados no Processamento                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")             //----> Cadastro de Produtos
DbSetOrder(1)                   //----> Codigo

DbSelectArea("SB3")             //----> Consumos Mensais
DbSetOrder(1)                   //----> Codigo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos Externos Utilizados no Processamento                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cArqEst := "CMES.DBF" //----> Arquivo que contem os consumos
				       //----> mensais a serem importados

//DbUseArea(.T.,__cRdd,_cArqEst,"EST",IF(.T. .OR. .F., !.F., NIL), .F. )
DbUseArea(.T.,,_cArqEst,"EST", NIL, .F. )

_cIndEst := CriaTrab(Nil,.f.)
_cChaEst := "EST->ID_PRODUTO"

IndRegua("EST",_cIndEst,_cChaEst,,,"Selecionando Consumos Mensais !!!")
//----> Indexando por PRODUTO

aEstru1 := {{"CODIGO" ,"C",8 ,0} , {"CMENSAL" ,"N",9,0} , {"SEGURANCA" ,"N",9,0}}

_cTemp1 := CriaTrab( aEstru1, .T. )  // Arquivo onde sera' gravado os novos produtos importados
DbUseArea( .T., , _cTemp1  , "TRB", .F., .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Atualiza Consumos Mensais")// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Processa({||Execute(RunProc)},"Atualiza Consumos Mensais")
Return(nil)	   // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RunProc
Static Function RunProc()

_cProd := Space(15)     //----> Armazena o codigo do produto acrescentando 
                        //----> os zeros necessarios na 3¦ e 6¦ posicao
DbSelectArea("EST")
DbGoTop()
ProcRegua(LastRec())
Do While Eof() == .f.
    _cProd := Subs(EST->ID_PRODUTO,1,2)+"0"+Subs(EST->ID_PRODUTO,3,2)+"0"+Subs(EST->ID_PRODUTO,5,2)

    IncProc("Processando Produto "+_cProd)

    DbSelectArea("SB1")
    If DbSeek(xFilial("SB1")+_cProd)
        RecLock("SB1",.f.)
          SB1->B1_ESTSEG :=  INT(VAL(EST->ARREDONDA))
          SB1->B1_TIPOCQ :=  IIF(EST->INSPECAO$"S","Q","M")
          SB1->B1_TIPE   :=  "D"
        MsUnLock()

        DbSelectArea("SB3")
        RecLock("SB3",.t.)
          SB3->B3_COD    :=  _cProd
          SB3->B3_Q01    :=  VAL(EST->C_MENSAL)
          SB3->B3_Q02    :=  VAL(EST->C_MENSAL)
          SB3->B3_Q03    :=  VAL(EST->C_MENSAL)
          SB3->B3_Q04    :=  VAL(EST->C_MENSAL)
          SB3->B3_Q05    :=  VAL(EST->C_MENSAL)
          SB3->B3_Q06    :=  VAL(EST->C_MENSAL)
          SB3->B3_Q07    :=  VAL(EST->C_MENSAL)
          SB3->B3_Q08    :=  VAL(EST->C_MENSAL)
          SB3->B3_Q09    :=  VAL(EST->C_MENSAL)
          SB3->B3_Q10    :=  VAL(EST->C_MENSAL)
          SB3->B3_Q11    :=  VAL(EST->C_MENSAL)
          SB3->B3_Q12    :=  VAL(EST->C_MENSAL)
          SB3->B3_MEDIA  :=  VAL(EST->C_MENSAL)
          SB3->B3_MES    :=  CTOD("28/02/01")
        MsUnLock()
    Else
        DbSelectArea("TRB")
        RecLock("TRB",.t.)
          _field->CODIGO        :=      _cProd
          _field->CMENSAL       :=      EST->C_MENSAL
          _field->SEGURANCA     :=      EST->ARREDONDA
        MsUnLock()
    EndIf

    DbSelectArea("EST")
    DbSkip()
EndDo

Imprime()

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim                                                                       *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function Imprime
Static Function Imprime()
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

titulo := "  Produtos nao encontrados SIGA            "
cabec1 := "CODIGO    CONSUMO MENSAL       ESTOQUE SEGURANCA"
cabec2 := ""
cDesc1 := "Este Relatorio tem o Objetivo de Listar os Produtos    "
cDesc2 := "Cadastrados pela Importacao de Dados Complementares    "
cString:= "EST"
aReturn:= { "Especial", 1, "Administracao", 1, 1, 1,"", 1 }
wnrel  := "CEST05I"
Tamanho:= "P"
Limite := 80 
m_pag  := 1
wnrel  := SetPrint( cString,wnrel,"",Titulo,cDesc1,cDesc2,"    ",.F.,,.T.,Tamanho,,.F.)
cbCont := 00

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

li := 60
nItens := 0

DbSelectArea("TRB")
DbGoTop()

While !Eof()
    If li > 59
        cabec(titulo,cabec1,cabec2,wnrel,Tamanho,18)
        //li := 0 
    EndIf

    @ li , 000 PSAY TRB->CODIGO
    @ li , 014 PSAY TRB->CMENSAL
    @ li , 038 PSAY TRB->SEGURANCA 
    li:= li + 1
    @ li , 000 PSAY Replicate("-",Limite)
    li:= li + 1
    nItens := nItens + 1
    DbSkip()
EndDo

li:= li + 1
@ li , 000 PSAY "Total de Itens: "+Str(nItens)

Roda(CbCont,"PRODUTOS","P")

If aReturn[5] == 1
   Set Printer TO
   OurSpool(Wnrel)
Endif

MS_FLUSH()

DbSelectArea("TRB")
DbCloseArea()

DbSelectArea("EST")
DbCloseArea()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna para sua chamada (CEST05I)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
