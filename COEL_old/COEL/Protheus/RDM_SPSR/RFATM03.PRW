#include "rwmake.ch"

User Function RFATM03()


SetPrvt("_cCliente,_cLojacli,_cNome,_cNReduz,_cTel,_cFax,_cContato,_cTransp,_cEnd,_cBairro,_cMun,_cEst")
SetPrvt("_cCep,_cEnde,_cBairroe,_cMune,_cEste,_cCepe,_cEndcob,_cBairroc,_cMunc,_cEstc,_cCepc")

/*/
-----------------------------------------------------------------------------
® Programa  ® RFATM03  ® Autor ® Rogerio Batista        ® Data ® 07.06.04   ®
-----------------------------------------------------------------------------
® Descri‡…o ® Programa que permite visualizar Notas Fiscais, e atualizar    ®
®           ® a data de entrega                                             ®
-----------------------------------------------------------------------------
® Uso       ® SigaFat -                                                     ®
-----------------------------------------------------------------------------
/*/


_cCliente := SA1->A1_COD
_cLojaCli := SA1->A1_LOJA
_cNome    := SA1->A1_NOME
_cNReduz  := SA1->A1_NREDUZ
_cTel     := SA1->A1_TEL
_cFax     := SA1->A1_FAX
_cContato := SA1->A1_CONTATO
_cContato2:= SA1->A1_X_CONT2
_cDepto1  := SA1->A1_X_DPTO1
_cEmail1  := SA1->A1_X_MAIL1
_cDepto2  := SA1->A1_X_DPTO2
_cEmail2  := SA1->A1_X_MAIL2
_cTransp  := SA1->A1_TRANSP
//Endereco
_cEnd     := SA1->A1_END
_cBairro  := SA1->A1_BAIRRO
_cMun     := SA1->A1_MUN
_cEst     := SA1->A1_EST
_cCep     := SA1->A1_CEP
//End de entrega
_cEndE    := SA1->A1_ENDENT
_cBairroE := SA1->A1_BAIRROE
_cMunE    := SA1->A1_MUNE
_cEstE    := SA1->A1_ESTE
_cCepE    := SA1->A1_CEPE
//End de cobranca
_cEndCob  := SA1->A1_ENDCOB
_cBairroC := SA1->A1_BAIRROC
_cMunC    := SA1->A1_MUNC
_cEstC    := SA1->A1_ESTC
_cCepC    := SA1->A1_CEPC
_cAtende  := SA1->A1_X_ATEND
_dData    := dtoc(SA1->A1_X_DATA)


@ 30,42 TO 520,705 DIALOG oDlg5 TITLE "ALTERACAO DE DADOS CADASTRAIS"
@ 8,10 TO 227,322

@ 230,228 BMPBUTTON TYPE 1 ACTION OkProc()
@ 230,256 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 13,14   SAY "Cliente"               // Codigo do Cliente
@ 13,54   SAY _cCliente+"-"+_cLojaCli
@ 13,100  GET _cNome             SIZE 200,50
@ 28,14   SAY "Nome Fantasia"
@ 28,54   GET _cNReduz           SIZE 70,20
@ 28,134  SAY "Telefone"
@ 28,164  GET _cTel              SIZE 40,15
@ 28,234  SAY "Fax"
@ 28,254  GET _cFax              SIZE 40,15
@ 43,14  SAY "Endereco"
@ 43,54  GET _cEnd               SIZE 150,15
@ 43,214 SAY "Bairro"
@ 43,234 GET _cBairro            SIZE 70,15
@ 58,14  SAY "Municipio"
@ 58,54  GET _cMun               SIZE 70,15
@ 58,104 SAY "Estado"
@ 58,134 GET _cEst               SIZE 30,15
@ 58,214 SAY "Cep"
@ 58,234 GET _cCep               SIZE 40,15

@ 73,14   SAY "Contato 1"
@ 73,54   GET _cContato           SIZE 70,15
@ 73,125  SAY "Depto1"
@ 73,149  GET _cDepto1            SIZE 70,15
@ 73,234  SAY "Transp."
@ 73,254  GET _cTransp            SIZE 40,15 F3 "SA4" 
@ 88,14   SAY "E-Mail 1"
@ 88,54   GET _cEmail1            SIZE 165,15
@ 103,14  SAY "Contato 2"
@ 103,54  GET _cContato2          SIZE 70,15
@ 103,125 SAY "Depto2"
@ 103,149 GET _cDepto2            SIZE 70,15
@ 118,14  SAY "E-Mail 2"
@ 118,54  GET _cEmail2            SIZE 165,15

@ 131,14  SAY "ENDERECO DE ENTREGA"
@ 146,14  SAY "Endereco"
@ 146,54  GET _cEndE               SIZE 150,15
@ 146,214 SAY "Bairro"
@ 146,234 GET _cBairroE            SIZE 70,15
@ 161,14  SAY "Municipio"
@ 161,54  GET _cMunE               SIZE 70,15
@ 161,104 SAY "Estado"
@ 161,134 GET _cEstE               SIZE 30,15
@ 161,214 SAY "Cep"
@ 161,234 GET _cCepE               SIZE 40,15

@ 176,14  SAY "ENDERECO DE COBRANCA"
@ 191,14  SAY "Endereco"
@ 191,54  GET _cEndCob             SIZE 150,15
@ 191,214 SAY "Bairro"
@ 191,234 GET _cBairroC            SIZE 70,15
@ 209,14  SAY "Municipio"
@ 209,54  GET _cMunC               SIZE 70,15
@ 209,104 SAY "Estado"
@ 209,134 GET _cEstC               SIZE 30,15
@ 209,214 SAY "Cep"
@ 209,234 GET _cCepC               SIZE 40,15

@ 230,14  SAY "Ultima alteracao por:"
@ 230,94  SAY _cAtende
@ 230,154 SAY _dData


ACTIVATE DIALOG oDlg5
return

Static Function OkProc()
Close(oDlg5)
Processa( {|| RunProc() } )
Return

Static Function RunProc()


RecLock("SA1",.F.)
SA1->A1_NOME   := _cNome
SA1->A1_NREDUZ := _cNReduz
SA1->A1_TEL    := _cTel
SA1->A1_FAX    := _cFax
SA1->A1_CONTATO:= _cContato
SA1->A1_TRANSP := _cTransp
SA1->A1_END    := _cEnd
SA1->A1_BAIRRO := _cBairro
SA1->A1_MUN    := _cMun
SA1->A1_EST    := _cEst
SA1->A1_CEP    := _cCep
SA1->A1_ENDENT := _cEndE
SA1->A1_BAIRROE:= _cBairroE
SA1->A1_MUNE   := _cMunE
SA1->A1_ESTE   := _cEstE
SA1->A1_CEPE   := _cCepE
SA1->A1_ENDCOB := _cEndCob
SA1->A1_BAIRROC:= _cBairroC
SA1->A1_MUNC   := _cMunC
SA1->A1_ESTC   := _cEstC
SA1->A1_CEPC   := _cCepC
SA1->A1_CONTATO:= _cContato
SA1->A1_X_CONT2:= _cContato2
SA1->A1_X_DPTO1:= _cDepto1 
SA1->A1_X_MAIL1:= _cEmail1
SA1->A1_X_DPTO2:= _cDepto2 
SA1->A1_X_MAIL2:= _cEmail2
SA1->A1_X_ATEND:= subs(cUsuario,7,15)
SA1->A1_X_DATA := dDatabase

MsUnlock()

Return(nil)

