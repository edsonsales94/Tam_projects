#include "rwmake.ch"      

User Function Cfat01r() 

SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,NOMEPROG,CPERG,LCONTINUA,NLIN,WNREL")
SetPrvt("CSTRING,NLASTKEY,NPAG,_CCLISP,_CTIPSP,_CTRASP")
SetPrvt("NITENS,XITENS,XDTENT,XQUANT,XSEMAN,XPEDCLI")
SetPrvt("XTOTAL,XDADOS,LCOMPLETE,NIPI,NVIPI,NBASEIPI")
SetPrvt("NVALBASE,LIPIBRUTO,I,CREFER,DREFER,NACRES")
SetPrvt("NSEM,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT01R  ³ Autor ³ Alberto N. Gama Junior³ Data ³ 05/10/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao de Pedidos de Venda                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para COEL Controles Eletricos Ltda              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBS       ³ Uso: Depto. Comercial                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

  ³ Variaveis utilizadas para parametros                         ³
  ³ mv_par01                Do Pedido N£mero                     ³
  ³ mv_par02                At‚ o Pedido N£mero                  ³ 
  ³ mv_par03                Com pre‡os S/N                       ³ 
  ³ mv_par04                Itens: Com Saldo/Todos               ³ 
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

nTamanho  := "P"
nLimite   := 132
cTitulo   := PADC( "Emissao de Pedidos", 74 )
cDesc1    := PADC( "Esta rotina imprime os pedidos de venda colocados, possibilitando ", 74 )
cDesc2    := PADC( "imprimir com ou sem os pre‡os/totais ou somente o saldo dos Itens.", 74 )
cDesc3    := PADC( "", 74 )
aReturn   := { "Especifico", 1, "Depto. Comercial", 1, 1, 1, "", 1 }
nomeprog  := "CFAT01R"
cPerg     := "FAT01R"
lContinua := .T.
nLin      := 0
wnrel     := "CFAT01R" //"PV" + Subst( time(), 1, 2 ) + Subst( time(), 4, 2 )
cString   := "SC6"
nLastKey  := 0

// **** Carrega as vari veis do dicion rio de perguntas
Pergunte( cPerg, .F. )

// **** Envia controle para a funcao SETPRINT 
wnrel := SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
   Return
Endif

// **** Verifica Posicao do Formulario na Impressora
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|| IMPCLEMSPV()})

Return

/*/
  ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
  ³ FUNCAO   ³IMPCLEMSPV³ Autor ³ Alberto N. Gama Junior³ Data ³ 05/10/99 ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
  ³Descri‡Æo ³ Manipula‡Æo de dados e impressÆo do relat¢rio              ³
  ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ OBS      ³                                                            ³
  ÃÄÄÄÄÄÄÄÄÄÄÙ                                                            ³
  ³                                                                       ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

Static Function IMPCLEMSPV()

nLin := 0
nPag := 1

// **** Sele‡Æo e ordena‡Æo dos arquivos utilizados

DbSelectArea("SB1")                 // Produtos
DbSetOrder(1)                       // Codigo

DbSelectArea("SB5")                 // Dados Adicionais produtos
DbSetOrder(1)                       // Codigo

DbSelectArea("SA1")                 // Clientes
DbSetOrder(1)                       // Codigo

DbSelectArea("SA3")                 // Vendedores / Representantes
DbSetOrder(1)                       // Codigo

DbSelectArea("SA4")                 // Transportadoras
DbSetOrder(1)                       // Codigo

DbSelectArea("SE4")                 // Condi‡äes de Pagto
DbSetOrder(1)                       // Codigo

DbSelectArea("SF4")                 // TES
DbSetOrder(1)                       // Numero Pedido + Item + Produto

DbSelectArea("SC6")                 // Itens dos Pedidos
DbSetOrder(1)                       // Numero Pedido + Cod. Produto

DbSelectArea("SC5")                 // Pedidos de Venda
DbSetOrder(1)                       // Numero Pedido

DbSeek( xFilial("SC5") + mv_par01,.T. )

SetRegua( Val(mv_par02)-Val(mv_par01)+1 )
@ nLin,  00 PSAY AvalImp( nLimite )

Do While !Eof() .AND. SC5->C5_NUM >= mv_par01 .AND. SC5->C5_NUM <= mv_par02

   IncRegua()

   DbSelectArea("SC6")
   DbSeek( xFilial("SC6") + SC5->C5_NUM )

   DbSelectArea("SA1")
   DbSeek( xFilial("SA1")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI )

   DbSelectArea("SA3")
   DbSeek( xFilial("SA3") + SA1->A1_VEND )

   DbSelectArea("SE4")
   DbSeek( xFilial("SE4") + SC5->C5_CONDPAG )

   DbSelectArea("SA4")
   DbSeek( xFilial("SA4") + SC5->C5_TRANSP )

   @ nLin,  00 PSAY Replic( "_", 132 )
   @ 01  ,  02 PSAY "PEDIDO DE VENDA"
   @ 01  , 115 PSAY "NUMERO :"
   @ 01  , 124 PSAY SC5->C5_NUM
   @ 02  ,  02 PSAY "CFAT01R - POR ORDEM DE GRAVACAO DE ITENS"
   @ 03  ,  00 PSAY Replic( "_", 132 )

   @ 04  , 02 PSAY "Data Emissao :"
   @ 04  , 17 PSAY DTOC( SC5->C5_EMISSAO )
   @ 04  , 70 PSAY "Cliente      :"
   @ 04  , 85 PSAY SC5->C5_CLIENTE
   @ 04  , 92 PSAY SC5->C5_LOJACLI
   @ 04  , 95 PSAY Subst( SA1->A1_NOME, 1, 35 )

   @ 05  , 02 PSAY "CGC          :"
   @ 05  , 17 PSAY SA1->A1_CGC      Picture"@R 99.999.999/9999-99"
   @ 05  , 70 PSAY "Inscr. Est.  :"
   @ 05  , 85 PSAY SA1->A1_INSCR

   @ 06  , 02 PSAY "Endereco     :"
   @ 06  , 17 PSAY SA1->A1_END
   @ 06  , 70 PSAY "Bairro       :"
   @ 06  , 85 PSAY SA1->A1_BAIRRO

   @ 07  , 02 PSAY "Municipio    :"
   @ 07  , 17 PSAY SA1->A1_MUN
   @ 07  , 70 PSAY "CEP          :"
   @ 07  , 85 PSAY SA1->A1_CEP

   @ 08  , 02 PSAY "Telefone     :"
   @ 08  , 17 PSAY SA1->A1_TEL
   @ 08  , 70 PSAY "Fax          :"
   @ 08  , 85 PSAY SA1->A1_FAX   
     Do Case 
        Case SA1->A1_CLASCLI = "D"
             _cTipoCli := "Distribuidor"
        Case SA1->A1_CLASCLI = "R"
             _cTipoCli := "Revendedor"
        Case SA1->A1_CLASCLI = "P"
             _cTipoCli := "Prod/Industr"
        Case SA1->A1_CLASCLI = "C"
             _cTipoCli := "Consumidor"
        Case Empty(SA1->A1_CLASCLI)
             _cTipoCli := "Vazio"        
      End Case
   @ 08  , 100 PSAY "TIPO: "+_cTipoCli

   @ 10  , 02 PSAY "Local Entrega:"
   @ 10  , 17 PSAY SA1->A1_ENDENT
   @ 10  , 70 PSAY "Munic. Entreg:"
   @ 10  , 85 PSAY SA1->A1_MUNE

   @ 11  , 02 PSAY "CGC Entrega  :"
   @ 11  , 17 PSAY SA1->A1_CLCGCEN   Picture"@R 99.999.999/9999-99"
   @ 11  , 70 PSAY "I.E. Entrega :"
   @ 11  , 85 PSAY SA1->A1_CLIEENT

   @ 13  , 02 PSAY "Vendedor     :"
   @ 13  , 17 PSAY SA3->A3_COD +  " - " + SA3->A3_NOME
   @ 13  , 70 PSAY "Natureza     :"
   @ 13  , 85 PSAY Posicione( "SF4", 1, xFilial("SF4")+SC6->C6_TES, "F4_TEXTO" )

   @ 14  , 02 PSAY "Cond. Pagto  :"
   @ 14  , 17 PSAY SE4->E4_CODIGO + " - " + SE4->E4_DESCRI
   @ 14  , 70 PSAY "Taxa Financ. :"
   @ 14  , 85 PSAY SE4->E4_ACRSFIN  Picture"@E 999.9999"

   @ 15  , 02 PSAY "Tipo Frete   :"
   @ 15  , 17 PSAY Iif( SC5->C5_TPFRETE=="2", "A PAGAR", "PAGO" )
   @ 15  , 70 PSAY "Transportad. :"
   @ 15  , 85 PSAY SA4->A4_COD + " - " + SA4->A4_NOME

   @ 16  , 02 PSAY "Aceita Antec.:"
   @ 16  , 17 PSAY Iif( SC5->C5_CLANTE=="S", "SIM", Iif( SC5->C5_CLANTE=="N", "NAO", " " ) )
   @ 16  , 70 PSAY "Entrega Parc.:"
   @ 16  , 85 PSAY Iif( SC5->C5_CLPARC=="S", "SIM", Iif( SC5->C5_CLPARC=="N", "NAO", " " ) )

// @ 17  , 02 PSAY "Gera O.S.    :"
// @ 17  , 17 PSAY Iif( SC5->C5_CLOS=="S", "SIM", "NAO" )
   @ 17  , 70 PSAY "Destino      :"
   @ 17  , 85 PSAY Posicione( "SZ2", 1, xFilial("SZ2")+SA1->A1_CLCLASI, "Z2_CLDESC" )
   @ 18  , 02 PSAY "PEDIDO EFETUADO POR: " + SC5->C5_CLATEND
   @ 19  , 02 PSAY "OBSERVACOES"
   @ 20  , 00 PSAY Replic("_",132)
   @ 21  , 02 PSAY SC5->C5_CLMSPED

   If SM0->M0_CODFIL == "02"
       @ 22  , 02 PSAY "Cliente SP: "+SC5->C5_CLCLISP+"/"+SC5->C5_CLLOJSP
       _cCliSp := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLCLISP+SC5->C5_CLLOJSP,"A1_NOME")
       _cTipSp := Posicione("SZ2",1,xFilial("SZ2")+SA1->A1_CLCLASI,"Z2_CLDESC")
       _cTraSp := Posicione("SA4",1,xFilial("SA4")+SC5->C5_CLTRASP,"A4_NOME")
       @ 22  , 24 PSAY Alltrim(_cCliSp)+" - "+Alltrim(_cTipSp)
       @ 23  , 02 PSAY "Transp SP : "+SC5->C5_CLTRASP
       @ 23  , 21 PSAY _cTraSP
   EndIf

   @ 24  , 00 PSAY Replic( "-", 132 )
   @ 25  , 02 PSAY  "IT  CODIGO              DESCRICAO PEDIDO                                       QTDE    UN     Vlr. Unit    IPI              TOTAL"
   @ 26  , 00 PSAY Replic( "-", 132 )                                                                                                        

   DbSelectArea("SC6")
   nLin   := 27
   nItens := 1
   xITENS := {}
   xDTENT := {}
   xQUANT := {}
   xSEMAN := {}
   xPEDCLI:= {}
   xTOTAL := { 0, 0 }    // ** Total em Qtde, Total em R$
   xDADOS := .F.
   lComplete := .T.
   nIPI     :=0
   nVipi    :=0
   nBaseIPI :=100
   nValBase := 0
   lIpiBruto:=IIF(GETMV("MV_IPIBRUT")=="S",.T.,.F.)

   Do While !Eof() .AND. SC6->C6_NUM == SC5->C5_NUM
/*
      If SC6->C6_QTDENT >= SC6->C6_QTDVEN .AND. mv_par04 == 1
         DbSkip()
         Loop
      EndIf
*/
      If nLin > 59

         lComplete := .F.
         @ nLin, 00 PSAY Replic("_", 132 )
         @ nLin + 2, 02 PSAY "CONTINUA ..."
         nLin := 1

         @ nLin, 02 PSAY "CONTINUACAO..."
         nLin := nLin + 2
         @ nLin, 00 PSAY Replic( "-", 132 )
         nLin := nLin + 1
         @ nLin, 02 PSAY  "IT  CODIGO              DESCRICAO PEDIDO                                       QTDE    UN     Vlr. Unit    IPI              TOTAL"
         nLin := nLin + 1
         @ nLin, 00 PSAY Replic( "-", 132 )
         nLin := nLin + 1

      EndIf
                  
      DbSelectArea("SB1")
      DbSeek( xFilial("SB1") + SC6->C6_PRODUTO )

      DbSelectArea("SB5")
      DbSeek( xFilial("SB5") + SC6->C6_PRODUTO )

      DbSelectArea("SF4")
      DbSeek( xFilial("SF4") + SC6->C6_TES )

      @ nLin, 02  PSAY SC6->C6_ITEM
      @ nLin, 06  PSAY SUBS(SC6->C6_PRODUTO,1,20)  
      @ nLin, 16  PSAY SC6->C6_CLGOP  
//      @ nLin, 20  PSAY SUBS(SC6->C6_DESCRI,1,40)//Subst( SB5->B5_CEME, 1, 49 )
      @ nLin, 27  PSAY iif(!Empty(SB1->B1_X_DESCC),SUBS(SB1->B1_X_DESCC,1,50),SUBS(SC6->C6_DESCRI,1,50))//Subst( SB5->B5_CEME, 1, 49 )
  //    @ nLin, 79  PSAY Iif( mv_par04==1, SC6->C6_QTDVEN - SC6->C6_QTDENT, SC6->C6_QTDVEN )    Picture"@E 99,999.99"
      @ nLin, 79  PSAY SC6->C6_QTDVEN     Picture"@E 99,999.99"
      @ nLin, 90  PSAY SC6->C6_UM
   // @ nLin, 90  PSAY SB1->B1_TIPO
  //    @ nLin, 98  PSAY SC6->C6_X_STATU
      
      @ nLin, 92  PSAY Iif( mv_par03==1, SC6->C6_PRCVEN, 0 )   Picture"@E 9,999,999.9999"
 //   @ nLin, 101  PSAY Iif( mv_par03==1, SC6->C6_PRCDOL, 0 )   Picture"@E 9,999,999.9999"

      IF SF4->F4_IPI == "S"
         nBaseIPI    := IIF(SF4->F4_BASEIPI > 0,SF4->F4_BASEIPI,100)
         nIPI        := SB1->B1_IPI
         nValBase    := If(lIPIBruto .And. SC6->C6_PRUNIT > 0,SC6->C6_PRUNIT,SC6->C6_PRCVEN)*SC6->C6_QTDVEN
         nVipi       := nValBase * (nIPI/100)*(nBaseIPI/100)
      Endif
      @ nLin,109 PSAY nIPI Picture"@E 99.99"
      @ nLin,118 PSAY Iif( mv_par03==1, NoRound(SC6->C6_VALOR+nVIPI) , 0 )  Picture PesqPict("SC6","C6_VALOR",14)

      xTOTAL[1] := xTOTAL[1] + Iif( mv_par04==1, SC6->C6_QTDVEN - SC6->C6_QTDENT, SC6->C6_QTDVEN )
      xTOTAL[2] := xTOTAL[2] + NoRound(SC6->C6_VALOR+nVIPI)

      AADD( xITENS, SC6->C6_ITEM   )
      AADD( xDTENT, SC6->C6_ENTREG )
      AADD( xQUANT, Iif( mv_par04==1, SC6->C6_QTDVEN - SC6->C6_QTDENT, SC6->C6_QTDVEN ) )
      AADD( xPEDCLI,SC5->C5_CLPEDCL )
      _NumSemana()
      AADD( xSEMAN, nSem )

      nItens := nItens + 1
      nLin   := nLin + 1

      DbSelectArea("SC6")
      DbSkip()

   EndDo

   If lComplete == .T.
      For i := nLin To 41
          //@ i, 82 PSAY "----"
          //@ i,109 PSAY "----"
          @ i,125 PSAY "----"
      Next
      nLin := i + 1
   EndIf

   nLin := nLin + 1

   @ nLin, 45 PSAY "TOTAL DO PEDIDO --->"
   @ nLin, 69 PSAY xTOTAL[1]  Picture"@E 99,999.99"
   @ nLin,119 PSAY Iif( mv_par03==1, xTOTAL[2], 0 )  Picture"@E 9,999,999.99"

   nLin := nLin + 1

   @ nLin, 02  PSAY "CRONOGRAMA DE ENTREGA"
   If SM0->M0_CODFIL == "02"
       @ nLin, 024 PSAY Dtoc(dDataBase)
   EndIf
   nLin := nLin + 1
   @ nLin, 00  PSAY Replicate( "-", 132 )
   nLin := nLin + 1
   @ nLin, 02  PSAY "IT   DATA ENTREGA       SEMANA        QTDE       SUA OC"
   @ nLin, 68  PSAY "|"
   @ nLin, 71  PSAY "IT   DATA ENTREGA       SEMANA        QTDE       SUA OC"
   nLin := nLin + 1
   @ nLin, 00  PSAY Replic( "-", 132 )

   lComplete := .T.
   nLin := nLin + 1
   i := 1

   Do While i <= Len( xITENS )

       If nLin > 58

          lComplete := .F.
          @ nLin, 00  PSAY Replic("_",132)
          @ nLin+2, 02  PSAY "CONTINUA..."
          nLin := 1

          @ nLin, 02  PSAY "CRONOGRAMA DE ENTREGA  -  CONTINUACAO..."
          nLin := nLin + 1
          @ nLin, 00  PSAY Replicate( "-", 132 )
          nLin := nLin + 1
          @ nLin, 02  PSAY "IT   DATA ENTREGA       SEMANA        QTDE       SUA OC"
          @ nLin, 68  PSAY "|"
          @ nLin, 71  PSAY "IT   DATA ENTREGA       SEMANA        QTDE       SUA OC"
          nLin := nLin + 1
          @ nLin, 00  PSAY Replic( "-", 132 )
          nLin := nLin + 1

       EndIf

       @ nLin, 02 PSAY xITENS[i]
       @ nLin, 07 PSAY xDTENT[i]
       @ nLin, 26 PSAY xSEMAN[i]    Picture"999999"
       @ nLin, 35 PSAY xQUANT[i]    Picture"@E 99,999.99"
       @ nLin, 51 PSAY xPEDCLI[i]
       @ nLin, 68 PSAY "|"

       i := i + 1

       If i <= Len( xITENS )

          @ nLin, 71 PSAY xITENS[i]
          @ nLin, 76 PSAY xDTENT[i]
          @ nLin, 95 PSAY xSEMAN[i]    Picture"999999"
          @ nLin,104 PSAY xQUANT[i]    Picture"@E 99,999.99"
          @ nLin,120 PSAY xPEDCLI[i]
          i := i + 1

       EndIf

       nLin := nLin + 1

   EndDo

   If lComplete == .T.
      For i := nLin To 56
          @ i , 68 PSAY "|"
      Next
      nLin := i + 1
   EndIf

   @nLin, 00 PSAY Replic("_", 132 )

   nLin := nLin + 3
   @ nLin, 00 PSAY " _________________   _________________   _________________   _________________"

   nLin := nLin + 1
   @ nLin, 00 PSAY "      Vendedor            Gerencia           Diretoria            Cliente"

   nLin := 0
   DbSelectArea("SC5")
   DbSkip()

End

@ nLin, 00 PSAY " "
SetPrc(0,0)
RetIndex("SC5")

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()
Return

Static Function _NumSemana()

cRefer := "01/01/" + AllTrim( Str( Year( SC6->C6_ENTREG ), 4 ) )
dRefer := CToD( cRefer )
nAcres := Dow( dRefer ) - 1
nSem   := ( SC6->C6_ENTREG - dRefer ) + nAcres
nSem   := nSem / 7
nSem   := Iif( Subst( Str( nSem, 12, 2 ), 11, 2 )=="00", Int(nSem), Int(nSem)+1 )

Return( nSem )
