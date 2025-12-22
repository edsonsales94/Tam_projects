#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function A060dele()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CROT,_CALIAS,_NORD,_NREC,LACHOU,")

// PRG PASSADO PELO SUPORTE AO SUPORTE EM 25/10/99 PARA CORRIGIR NAO CONFORMIDADES

cRot := FunName()

If Upper(AllTrim(cRot)) <> "MATA060"

	_cAlias := Alias()
	_nOrd   := IndexOrd()
	_nRec   := Recno()

	lAchou   :=.F.

	DbSelectArea("SA5")
	DbSetOrder(3)
	
	IF SW3->(DBSEEK(XFILIAL("SW3")+SA5->A5_PRODUTO))

	   DO WHILE SW3->(!EOF()) .AND. SW3->W3_FILIAL == XFILIAL("SW3") .AND.;
	            SW3->W3_COD_I == SA5->A5_PRODUTO

	      IF SW3->W3_COD_I == SA5->A5_PRODUTO .AND.;
    	     SW3->W3_FORN  == SA5->A5_FORNECE .AND.;
        	 SW3->W3_FABR  == SA5->A5_FABR
	         lAchou:=.T.
    	     EXIT
	      ENDIF

    	  SW3->(DBSKIP()); LOOP

	   ENDDO
   
	ENDIF


	IF lAchou
	   Help(" ",1,"E_DELFOFA2")
	ENDIF


	DbSelectArea(_cAlias)
	DbSetOrder(_nOrd)
	DbGoto(_nRec)

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> 	__RETURN(!lAchou)
Return(!lAchou)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

Endif

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __Return(.t.)
Return(.t.)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
