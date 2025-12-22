#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

User Function Ccom05i()        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_NORDER,_NRECNO,_CPROD,_NVUNIT,_CPEDIDO")
SetPrvt("_NFATOR,NPOS,_CITEMPC,_NPRCANT,_NMOED,_NMARGEM")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CCOM05I  ³ Autor ³ RICARDO CORREA SOUZA  ³ Data ³ 18/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ COMPARA O PRECO DIGITADO NA NOTA FISCAL ENTRADA COM PEDIDO ³±±
±±³          ³ COMPRA. CALCULA A MARGEM PERCENTUAL DA DIFERENCA E MOSTRA  ³±±
±±³          ³ OU CONVERTE PELO VALOR DO DIA CONFORME TAXA DOLAR.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para COEL                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

_cAlias := Alias()
_nOrder := IndexOrd()
_nRecno := Recno()
_cProd  := ""
_nVunit := 0
_cPedido:= Space(6)
_nFator:= 1     // para os casos onde a moeda e' 1 - Real

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_COD"})
_cProd:=aCols[n,npos]

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_VUNIT"})
_nVunit:=aCols[n,npos]

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_PEDIDO"})
_cPedido :=aCols[n,npos]

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_ITEMPC"})
_cItemPC :=aCols[n,npos]

DbSelectArea("SC7")
DbSetOrder(4)
If DbSeek(xFilial("SC7")+_cProd+_cPedido+_cItemPC)
    _nPrcAnt := SC7->C7_PRECO2
    _nMoed   := SC7->C7_MOEDA
    Dbselectarea("SM2")
    Dbsetorder(1)

    If Dbseek(DDEMISSAO)
       Do Case
          Case _nMoed == 2      //----> dolar
               _nfator := SM2->M2_MOEDA2
               If MsgBox("Convertento o Preco Unitario com a Taxa Cambial de "+Str(_nFator,10,4)+" "+Iif(_nMoed == 2,"Dolar ",Iif(_nMoed == 4,"Marco Alemao ",Iif(_nMoed == 5,"Lira Italiana ",Iif(_nMoed == 6,"Franco Suico ",Iif(_nMoed == 7,"Franco Frances ",Iif(_nMoed == 8,"Yene ","Euro "))))))+"de "+DtoC(DDEMISSAO),"Continuar ?","YESNO") == .F.
                   _nVunit := M->D1_VUNIT
               Else
                   _nVunit := Iif(_nPrcAnt >0, noRound(_nPrcAnt * _nfator,2), _nVunit)
               EndIf
          Case _nMoed == 4      //----> marco alemao
               _nfator := SM2->M2_MOEDA4
               If MsgBox("Convertento o Preco Unitario com a Taxa Cambial de "+Str(_nFator,10,4)+" "+Iif(_nMoed == 2,"Dolar ",Iif(_nMoed == 4,"Marco Alemao ",Iif(_nMoed == 5,"Lira Italiana ",Iif(_nMoed == 6,"Franco Suico ",Iif(_nMoed == 7,"Franco Frances ",Iif(_nMoed == 8,"Yene ","Euro "))))))+"de "+DtoC(DDEMISSAO),"Continuar ?","YESNO") == .F.
                   _nVunit := M->D1_VUNIT
               Else
                   _nVunit := Iif(_nPrcAnt >0, noRound(_nPrcAnt * _nfator,2), _nVunit)
               EndIf
          Case _nMoed == 5      //----> lira italiana
               _nfator := SM2->M2_MOEDA5
               If MsgBox("Convertento o Preco Unitario com a Taxa Cambial de "+Str(_nFator,10,4)+" "+Iif(_nMoed == 2,"Dolar ",Iif(_nMoed == 4,"Marco Alemao ",Iif(_nMoed == 5,"Lira Italiana ",Iif(_nMoed == 6,"Franco Suico ",Iif(_nMoed == 7,"Franco Frances ",Iif(_nMoed == 8,"Yene ","Euro "))))))+"de "+DtoC(DDEMISSAO),"Continuar ?","YESNO") == .F.
                   _nVunit := M->D1_VUNIT
               Else
                   _nVunit := Iif(_nPrcAnt >0, noRound(_nPrcAnt * _nfator,2), _nVunit)
               EndIf
          Case _nMoed == 6      //----> franco suico
               _nfator := SM2->M2_MOEDA6
               If MsgBox("Convertento o Preco Unitario com a Taxa Cambial de "+Str(_nFator,10,4)+" "+Iif(_nMoed == 2,"Dolar ",Iif(_nMoed == 4,"Marco Alemao ",Iif(_nMoed == 5,"Lira Italiana ",Iif(_nMoed == 6,"Franco Suico ",Iif(_nMoed == 7,"Franco Frances ",Iif(_nMoed == 8,"Yene ","Euro "))))))+"de "+DtoC(DDEMISSAO),"Continuar ?","YESNO") == .F.
                   _nVunit := M->D1_VUNIT
               Else
                   _nVunit := Iif(_nPrcAnt >0, noRound(_nPrcAnt * _nfator,2), _nVunit)
               EndIf
          Case _nMoed == 7      //----> franco frances
               _nfator := SM2->M2_MOEDA7
               If MsgBox("Convertento o Preco Unitario com a Taxa Cambial de "+Str(_nFator,10,4)+" "+Iif(_nMoed == 2,"Dolar ",Iif(_nMoed == 4,"Marco Alemao ",Iif(_nMoed == 5,"Lira Italiana ",Iif(_nMoed == 6,"Franco Suico ",Iif(_nMoed == 7,"Franco Frances ",Iif(_nMoed == 8,"Yene ","Euro "))))))+"de "+DtoC(DDEMISSAO),"Continuar ?","YESNO") == .F.
                   _nVunit := M->D1_VUNIT
               Else
                   _nVunit := Iif(_nPrcAnt >0, noRound(_nPrcAnt * _nfator,2), _nVunit)
               EndIf
          Case _nMoed == 8      //----> yene
               _nfator := SM2->M2_MOEDA8
          
               If MsgBox("Convertento o Preco Unitario com a Taxa Cambial de "+Str(_nFator,10,4)+" "+Iif(_nMoed == 2,"Dolar ",Iif(_nMoed == 4,"Marco Alemao ",Iif(_nMoed == 5,"Lira Italiana ",Iif(_nMoed == 6,"Franco Suico ",Iif(_nMoed == 7,"Franco Frances ",Iif(_nMoed == 8,"Yene ","Euro "))))))+"de "+DtoC(DDEMISSAO),"Continuar ?","YESNO") == .F.
                   _nVunit := M->D1_VUNIT
               Else
                   _nVunit := Iif(_nPrcAnt >0, noRound(_nPrcAnt * _nfator,2), _nVunit)
               EndIf
          Case _nMoed == 9      //----> euro
               _nfator := SM2->M2_MOEDA9
          
               If MsgBox("Convertento o Preco Unitario com a Taxa Cambial de "+Str(_nFator,10,4)+" "+Iif(_nMoed == 2,"Dolar ",Iif(_nMoed == 4,"Marco Alemao ",Iif(_nMoed == 5,"Lira Italiana ",Iif(_nMoed == 6,"Franco Suico ",Iif(_nMoed == 7,"Franco Frances ",Iif(_nMoed == 8,"Yene ","Euro "))))))+"de "+DtoC(DDEMISSAO),"Continuar ?","YESNO") == .F.
                   _nVunit := M->D1_VUNIT
               Else
                   _nVunit := Iif(_nPrcAnt >0, noRound(_nPrcAnt * _nfator,2), _nVunit)
               EndIf
          Case _nMoed == 1
                 If _nVunit <> SC7->C7_PRECO
                    _nMargem := (( _nVunit / SC7->C7_PRECO ) -1 ) *100 
                    MsgBox(Alltrim(SubStr(cUsuario,7,15))+", o Preco Digitado esta divergente do Preco de Compra em "+Str(_nMargem,10,2)+" %","VALIDACAO PRECO UNITARIO","Alert")
                EndIf    
       EndCase
    Endif
EndIf
DbSelectArea(_cAlias)
DbSetOrder(_nOrder)
DbGoTo(_nRecno)

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> __RETURN(_nVunit)
Return(_nVunit)        // incluido pelo assistente de conversao do AP6 IDE em 03/09/02
