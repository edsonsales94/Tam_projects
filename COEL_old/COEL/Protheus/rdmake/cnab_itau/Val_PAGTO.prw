#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/05/02

User Function Val_PAGTO()        // incluido pelo assistente de conversao do AP5 IDE em 27/05/02

SetPrvt("_VALOR")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ VAL_CNAB ³ Autor ³ ANDRE CAMPOS          ³ Data ³ 05/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Calcular o valor do titulo a ser enviado para o banco      ³±±
±±³          ³ Segmento "A e J" Quando Doc / Boleto tiver desconto        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Geracao sispag         do Banco Itau/Hsbc/Real/            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

If SEE->EE_CODIGO $ "399" 

 	_valor  := 0
 	_valor := STRZERO(SE2->E2_SALDO*100+((SE2->E2_ACRESC*100)-(SE2->E2_DECRESC*100)),13)
    	
	
Else

	_valor  := 0
 	_valor := STRZERO(SE2->E2_SALDO*100+((SE2->E2_ACRESC*100)-(SE2->E2_DECRESC*100)),15)

Endif

Return(_valor)        // incluido pelo assistente de conversao do AP5 IDE em 27/05/02

