#include "rwmake.ch"   

User Function RESTR10() 

//
// Declaracao de variaveis utilizadas no programa atraves da funcao    
// SetPrvt, que criara somente as variaveis definidas pelo usuario,    
// identificando as variaveis publicas do sistema utilizadas no codigo 
// Incluido pelo assistente de conversao do AP5 IDE                    
//

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("CPERG,NLASTKEY,LI,M_PAG,TAMANHO,AORD")
SetPrvt("CABEC1,CABEC2,CSAVSCR1,CSAVCUR1,CSAVROW1,CSAVCOL1")
SetPrvt("CSAVCOR1,WNREL,NTIPO,_CARQTRB,_ACAMPOS,_CCHAVE")
SetPrvt("_CINDTRB,")

/*/


 PROGRAMA    RESTR01    AUTOR  Ricardo K. Yamashiro   DATA  14/12/01  

 Funao      Relacao para comparacao de digitacao de inventario	     

 Uso	       SIGAEST 						     


/*/

//
// Define Variaveis                                             
//
//
// Define Variaveis.                                            
//
titulo	:= "RELACAO DE DIFERENCA DE INVENTARIO"
cDesc1	:= "Este programa ir emitir os itens inventariados   "
cDesc2	:= "com diferenca entre os inventarios conforme os"
cDesc3	:= "parametros especificados."
cString := "SB7"
aReturn:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
cPerg  := "RESTR10"
nLastKey := 0
li := 80
m_pag  := 1
tamanho:= "M"
aOrd   := {}

//		     1	       2	 3	   4	     5	       6	 7	   8	     9	       0	 1	   2	     3
//	   0123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 12
cabec1 := "Produto         Descricao                      Loc Qtde 1#Cont   Qtde 2# Cont"
cabec2 := ""
//	   123456789012345 XXXXXXXXXXXXXXX(30)XXXXXXXXXXX 001 999,999,999.99 999,999,999.99
//	   210010047			1570	     0
//	   210010047			1570	     0
//
// Salva a Integridade dos dados de Entrada.                    
//
//
// Variaveis utilizadas para parametros	
// mv_par01		// Data 1 inventario	
// mv_par02		// Data 2 inventario	
//
//
// Verifica as perguntas selecionadas                           
//
pergunte(cPerg,.F.)

//
// Envia controle para a funcao SETPRINT.                       
//
wnrel:="RESTR10"

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.t.,Tamanho)
nTipo  := Iif(aReturn[4] == 1, 15, 18)

If LastKey() == 27 .Or. nLastKey == 27
   Return
Endif

_cArqTrb:= CriaTrab(nil,.f.)

_aCampos := {}

AAdd(_aCampos ,{"CODPROD   ", "C",15 , 0})
AAdd(_aCampos ,{"X_LOCAL   ", "C",1  , 0})
AAdd(_aCampos ,{"QUANT1    ", "N",12 , 2})
AAdd(_aCampos ,{"QUANT2    ", "N",12 , 2})

DBCreate(_cArqTrb,_aCampos)

_cChave    := "CODPROD" //"CODPROD+X_LOCAL"
_cIndTrb   := CriaTrab(nil,.f.)

DbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
INDREGUA("TRB",_cIndTrb,_cChave,,,"Criando Indice...",.F.)

Processa( {|| Fill_Trab(mv_par01,1)} )
//Processa( {|| Fill_Trab(mv_par02,2)} )

SetDefault(aReturn,cString)

       RptStatus({|| RptDetail()})
Return


Static Function RptDetail()

Set Print On
Set Device to Print

dbSelectArea("TRB")
dbSetOrder(1)
dbgotop()
SetRegua( Lastrec() )
while !eof()

    incregua()

    if QUANT1 == QUANT2
       dbskip()
       loop
    endif
    
    if li > 58
       Cabec(Titulo,cabec1,cabec2,wnrel,tamanho,nTipo)
    endif

    dbSelectArea("SB1")
    dbseek(xFilial() + TRB->CODPROD)
    dbSelectArea("TRB")

    @ Li,00 PSAY CODPROD
    @ Li,16 PSAY SUBS(SB1->B1_DESC,1,30)
    @ Li,47 PSAY X_LOCAL
    @ Li,51 PSAY QUANT1 PICTURE "@E 999,999,999.99"
    @ Li,66 PSAY QUANT2 PICTURE "@E 999,999,999.99"

    li:= li + 1
    dbskip()

enddo

Set Device to Screen
//
// Se impressao em Disco, chama Spool.                              
//
If aReturn[5] == 1
   Set Printer To
   dbCommitAll()
   ourspool(wnrel)
Endif

dbSelectArea("TRB")
dbclosearea()

Ferase(_cArqTrb+".DBF")
Ferase(_cIndTrb+OrdBagExt())

//
// Libera relatorio para Spool da Rede.                             
//
FT_PFLUSH()

Static Function Fill_Trab(_data,_nInvent)
Local _cChave

dbSelectArea("SB7")
dbSetOrder(1)
ProcRegua( Lastrec() )
dbseek(xFilial() + dtos(_data))
while !eof() .and. B7_DATA == _data

   incproc("Processando: " + B7_COD + " " + B7_X_LOCAL)                   
   
   if B7_X_LOCAL == "1"
      dbSelectArea("TRB")
      reclock("TRB",.T.)
      TRB->CODPROD:= SB7->B7_COD
      TRB->X_LOCAL:= SB7->B7_X_LOCAL
      TRB->QUANT1 := SB7->B7_QUANT
   else
      dbSelectArea("TRB")
      _cChave:= SB7->B7_COD //+ SB7->B7_X_LOCAL
      dbseek(_cChave)
      if eof()
     	 reclock("TRB",.f.)
	     TRB->CODPROD:= SB7->B7_COD
	     TRB->X_LOCAL:= SB7->B7_X_LOCAL
	     TRB->QUANT2 := SB7->B7_QUANT
      else
	     TRB->QUANT2 := SB7->B7_QUANT
      endif
   endif
   
   dbSelectArea("SB7")
   dbskip()

enddo
