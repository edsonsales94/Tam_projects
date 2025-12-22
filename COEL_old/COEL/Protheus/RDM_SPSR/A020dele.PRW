#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function A020dele()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_NORD,_NREC,LACHOU,CMSG,")

// PRG ENVIADO PELO SUPORTE AO SUPORTE EM 25/10/99 PARA SOLUCIONAR PROBLEMAS DE DELECAO DE FORNECEDORES
// INSTRUCAO PARA COMPILAR E DISPONIBILIZAR NO SIGAADV


_cAlias := Alias()
_nOrd   := IndexOrd()
_nRec   := Recno()

DbSelectArea("SA5")
DbSetOrder(1)

IF SA5->(DBSEEK(XFILIAL("SA5")+SA2->A2_COD+SA2->A2_LOJA))
   lAchou:=.T.
ELSE
   lAchou:=.F.
ENDIF

IF !lAchou
 
	DbSelectArea("SA5")
	DbSetOrder(4)

   IF SA5->(DBSEEK(XFILIAL("SA5")+SA2->A2_COD))
      lAchou:=.T.
   ELSE
      lAchou:=.F.
   ENDIF
   
ENDIF

IF lAchou
/* cMsg:=OemtoAnsi("Este Forn/Fabr Pertence a Amarra‡Æo: Forn. "+;
         ALLTRIM(SA5->A5_FORNECE)+" Prod. "+ALLTRIM(SA5->A5_PRODUTO)+;
         " Fabr. "+ALLTRIM(SA5->A5_FABR))
   MSGINFO(cMsg)*/
   Help(" ",1,"E_DELFOFA1")
ENDIF

DbSelectArea(_cAlias)
DbSetOrder(_nOrd)
DbGoto(_nRec)

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __RETURN(!lAchou)
Return(!lAchou)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
