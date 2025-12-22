#include "rwmake.ch"       
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Cfat14i()    

SetPrvt("_CCLIENTE,_NREC,_CALIAS,_INDEX,_CDESCR,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT14I  ³ Autor ³Rosimeire P. D. Goes   ³ Data ³ 18/06/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Mensagem padrao para o Orcamento de Venda afim de orientar  ³±± 
±±³          ³a atendente sobre dados do cliente no momento da digitacao  ³±±
±±³          ³do codigo do Cliente                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Chamado por gatilho no campo CK_CLIENTE e consulta arquivo  ³±±
±±³          ³de desconto especifico da Coel - SZ2                        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Geral                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

If M->C5_TIPO $"BD"

   _cDesconto := 0

Else
    
   _cRot  := AllTrim(FunName())  
   
   _nRec   := RECNO()
   _cAlias := ALIAS()
   _index  := INDEXORD()
   _cDescr := space(40)                                    
   
   DBSELECTAREA("SA1")
   DBSETORDER(1)
   DBSEEK(XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)
   
   DBSELECTAREA("SZ2")
   DBSETORDER(1)
   DBSEEK(XFILIAL("SZ2")+SA1->A1_CLCLASI)
   _cDescr := Z2_CLPDES
   
   If _cRot <> "RFATM01"                          
      
    _cDesconto :=  Z2_CLPDES 
   EndIf     
   
   _cCliente := SA1->A1_COD

//   DBSELECTAREA(_cAlias)
//   DBSETORDER(_index)
//   DBGOTO(_nRec)

EndIf

Return(_cDesconto)


