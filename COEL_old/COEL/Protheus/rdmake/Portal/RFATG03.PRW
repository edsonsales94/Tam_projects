#include "rwmake.ch"

User Function RFATG03()

SetPrvt("_AAREA,_CCOD,_CRET,NPOS")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATG03  ³ Autor ³ FERNANDO AMORIM       ³ Data ³ 02/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para alertar o CAMPO ID DO USUARIO NO PEDIDO      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ EXECBLOCK no campo C5_CLIENTE SEQUENCIA 14                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

_aArea := GetArea()

//NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="C5_VEND1"})
//_cCod :=aCols[n,npos]

IF ALLTRIM(M->C5_VEND1) == '117'     //SE O VENDEDOR IGUAL 117 - TEXQUALY - INCLUI O ID DO USUARIO DA TEXQUALY (000084), SENAO INCLUI O ID DO USUARIO QUE DIGITOU
   _cRet := '000084'
ELSEIF ALLTRIM(M->C5_VEND1) == '113' //SE O VENDEDOR IGUAL 113 - SOLTEX   - INCLUI O ID DO USUARIO DA SOLTEX   (000134), SENAO INCLUI O ID DO USUARIO QUE DIGITOU
   _cRet := '000134'  
ELSEIF ALLTRIM(M->C5_VEND1) == '123' //SE O VENDEDOR IGUAL 123 - ZENITE   - INCLUI O ID DO USUARIO DA ZENITE   (000110), SENAO INCLUI O ID DO USUARIO QUE DIGITOU
   _cRet := '000110'
ELSE
   _cRet := __CUSERID
ENDIF

RestArea(_aArea)


Return(_cRet)

