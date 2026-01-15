#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/11/01

User Function Encops()        // incluido pelo assistente de conversao do AP5 IDE em 13/11/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CCODPAI,COP,DDATENC,")                                                                                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ENCOPS    ³ Autor ³ ELTON FIGUEIREDO      ³ Data ³ 09.01.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³PROCESSAMENTO PARA ENCERRAMENTO AUTOMATICO DE OP'S          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
           
ValidPerg("DELOPS")      

@ 96,42 TO 323,505 DIALOG oDlg TITLE "Encerramento de OP's"
@ 8,10 TO 84,222
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("DELOPS")
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 13/11/01 ==> @ 91,168 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@ 23,14 SAY "Este programa tem por objetivo encerrar de forma automatica as Ordens de Producao"
@ 33,14 SAY "que estiverem abertas e tiverem suas emissoes e numeros, dentro do periodo e "
@ 43,14 SAY "sequencia, respectivamente, especificados."
ACTIVATE DIALOG oDlg

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OkProc    ³ Autor ³ Ary Medeiros          ³ Data ³ 15.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Confirma o Processamento                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

// Substituido pelo assistente de conversao do AP5 IDE em 13/11/01 ==> Function OkProc
Static Function OkProc()
Close(oDlg)
Processa( {|| RunProc() } )// Substituido pelo assistente de conversao do AP5 IDE em 13/11/01 ==> Processa( {|| Execute(RunProc) } )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RunProc   ³ Autor ³ Ary Medeiros          ³ Data ³ 15.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa o Processamento                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 13/11/01 ==> Function RunProc
Static Function RunProc()
Pergunte("DELOPS",.f.)
//mv_par01 => Da Data
//mv_par02 => Ate a Data
//mv_par03 => Da OP
//mv_par04 => Ate a OP

dbSelectArea("SC2")
dbSetOrder(1)
Count all for c2_num+c2_item+c2_sequen >= mv_par03 .and. c2_num+c2_item+c2_sequen <= mv_par04 to nCont
ProcRegua(nCont)
dbSeek(xFilial()+mv_par03,.t.)
while ! eof() .and. c2_num+c2_item+c2_sequen <= mv_par04
   // VERIF.SE JA FOI ENCERRADA OU NAO TEM PRODUCAO
   if ! Empty(c2_datrf) .or. c2_quje == 0 .or. c2_emissao < mv_par01 .or. c2_emissao > mv_par02
      dbSkip()
      Incproc()
      Loop
   endif

   // ACERTA ACUMULADOS DO SB2
   cCodPai := c2_produto
   cOp     := Padr (c2_num+c2_item+c2_sequen , Len(SD4->D4_OP) )
   dbSelectArea("SD4")
   dbSetOrder(2)
   dbSeek(xFilial()+cOp)
   while ! eof() .and. d4_op == cOp
      if d4_quant <> 0
         // ACERTA ACUMULADOS DO SB2
         dbSelectArea("SB2")
         dbSetOrder(1)
         if dbSeek(xFilial()+sd4->d4_cod+sd4->d4_local)
            Reclock("SB2",.f.)
            sb2->b2_qemp := sb2->b2_qemp - sd4->d4_quant
            MSUnlock()
         endif
         dbSelectArea("SD4")
      endif
      Reclock("SD4",.f.)
      sd4->d4_quant := 0
      MSUnlock()
      dbSkip()
   end
   // APURA DATA DA ULTIMA PRODUCAO
   dbSelectArea("SD3")
   dbSetOrder(1)
   dbSeek(xFilial()+cOp+cCodPai)
   dDatEnc := sc2->c2_emissao
   while ! eof() .and. d3_op+d3_cod == cOp+cCodPai
      dDatEnc := iif(d3_emissao>dDatEnc,d3_emissao,dDatEnc)
      dbskip()
   end

   // ACERTA ACUMULADOS DO SB2
   dbSelectArea("SB2")
   dbSetOrder(1)
   if dbSeek(xFilial()+sc2->c2_produto+sc2->c2_local)
      Reclock("SB2",.f.)
      sb2->b2_salpedi := sb2->b2_salpedi - (sc2->c2_quant-sc2->c2_quje)
      MSUnlock()
   endif

   // MARCA OP COMO ENCERRADA
   dbSelectArea("SC2")
   Reclock("SC2")
   sc2->c2_datrf := dDatEnc
   MSUnlock()

   dbSkip()
   IncProc()
end

Return
//Criacao das perguntas
Static Function ValidPerg(cPerg)                                 
    PutSX1(cPerg,"01","Data Inicial","Data Inicial","Data Inicial" ,"mv_ch1","D" , 08, 0, 0, "G","","   "    ,"","","MV_PAR01")
    PutSX1(cPerg,"02","Data Final"  ,"Data Final"  ,"Data Final"   ,"mv_ch2","D" , 08, 0, 0, "G","","   "    ,"","","MV_PAR02")
    PutSX1(cPerg,"03","OP Inicial"  ,"OP Inicial"  ,"OP Inicial"   ,"mv_ch3","C" , 11, 0, 0, "G","","SC2"    ,"","","MV_PAR03")
    PutSX1(cPerg,"04","OP Final"    ,"OP Final"    ,"OP Final"     ,"mv_ch4","C" , 11, 0, 0, "G","","SC2"    ,"","","MV_PAR04")
Return

