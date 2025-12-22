#include "rwmake.ch"       
#Include "TOPCONN.CH"
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Cpcp01r()    


SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,LEND")
SetPrvt("TAMANHO,LIMITE,TITULO,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("ADRIVER,CBCONT,CPERG,NLIN,M_PAG,NCOUNT")
SetPrvt("CABEC1,CABEC2,REGUA1,REGUA2,_CDESCPAI,_CDESCCOMP")
SetPrvt("_CUNIDMED,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CPCP01R  ³ Autor ³Ricardo Correa de Souza³ Data ³11/07/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao dos Componentes da Estrutura                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 15/10/02 ==>     #DEFINE PSAY SAY
#ENDIF
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")         //----> Cadastro de Produtos
DbSetOrder(1)               //----> Codigo

DbSelectArea("SG1")         //----> Estrutura de Produtos         
DbSetOrder(1)               //----> Codigo + Componente     

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "CPCP01R"
cDesc1    := "Emissao da Lista de Materias - Estrutura"
cDesc2    := ""
cDesc3    := ""
cString   := "SG1"
lEnd      := .F.
tamanho   := "P"
limite    := 80 
titulo    := "Lista de Materiais - Estrutura"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "CPCP01R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "PCP01R"
nLin      := 8
m_pag     := 1
nCount    := 0

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Produto        ?                                          *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

#IFDEF WINDOWS
    RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 15/10/02 ==>     RptStatus({|| Execute(Imprime)},titulo)
#ELSE
    Imprime()
#ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 15/10/02 ==> Function Imprime
Static Function Imprime()

cabec1  := "COMPONENTE   DESCRICAO                         QUANTIDADE  UM LOCALIZACAO        "
cabec2  := ""
//regua1:= "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012"
//regua2:= "         10        20        30        40        50        60        70        80        90       100       110       120       130  "

DbSelectArea("SG1")
DbSetOrder(1)
DbSeek(xFilial("SG1")+mv_par01,.T.)

SetRegua(Lastrec())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)

@ nLin, 000 Psay "CODIGO ---->"
@ nLin, Pcol()+1 Psay Alltrim(SG1->G1_COD)
_cDescPai := Posicione("SB1",1,xFilial("SB1")+SG1->G1_COD,"B1_DESC")
@ nLin, Pcol()+1 Psay "- "+Alltrim(_cDescPai)
@ nLin, Pcol()+1 Psay "- REV "+Iif(mv_par22 == 1,"4",Iif(mv_par17 == 1,"3",Iif(mv_par12 == 1,"2",Iif(mv_par07 == 1,"1",Iif(mv_par02 == 1,"0"," ")))))
nLin := nLin + 2

Do While !Eof() .And. SG1->G1_FILIAL == xFilial("SG1") .And. SG1->G1_COD == mv_par01

    IncRegua()

    @ nLin, 000 Psay Alltrim(SG1->G1_COMP)
    _cDescComp:= Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_DESC")
    _cUnidMed := Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_UM")
    @ nLin, Pcol()+5 Psay LEFT(_cDescComp,30)
    @ nLin, Pcol()+4 Psay SG1->G1_QUANT Picture "@E 999,999.99"
    @ nLin, Pcol()+2 Psay _cUnidMed
    @ nLin, Pcol()+1 Psay SG1->G1_OBSERV
    nLin := nLin + 1

    nCount := nCount + 1
	 dbSelectArea("SG1")
    DbSkip()

    If nLin > 59
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
        nLin := 8
    Endif
EndDo

If nLin > 59
    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
    nLin := 8
Endif

nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1
@ nLin, 000      Psay "Numero de Itens ----> "
@ nLin, Pcol()+1 Psay nCount    Picture "@E 9999"

//----> imprime revisoes (sim/nao)
If mv_par27 == 1
    nLin := 46

    @ nLin,000 Psay "--------------------------------------------------------------------------------"
    nLin := nLin + 1
    @ nLin,000 Psay "| "+Iif(mv_par02 == 1,"0"," ")+"   |"+mv_par03+"|"+mv_par04+"|"+mv_par05+"|"+Dtoc(mv_par06)+" |"
    nLin := nLin + 1
    @ nLin,000 Psay "--------------------------------------------------------------------------------"
    nLin := nLin + 1
    @ nLin,000 Psay "| "+Iif(mv_par07 == 1,"1"," ")+"   |"+mv_par08+"|"+mv_par09+"|"+mv_par10+"|"+Dtoc(mv_par11)+" |"
    nLin := nLin + 1
    @ nLin,000 Psay "--------------------------------------------------------------------------------"
    nLin := nLin + 1
    @ nLin,000 Psay "| "+Iif(mv_par12 == 1,"2"," ")+"   |"+mv_par13+"|"+mv_par14+"|"+mv_par15+"|"+Dtoc(mv_par16)+" |"
    nLin := nLin + 1
    @ nLin,000 Psay "--------------------------------------------------------------------------------"
    nLin := nLin + 1
    @ nLin,000 Psay "| "+Iif(mv_par17 == 1,"3"," ")+"   |"+mv_par18+"|"+mv_par19+"|"+mv_par20+"|"+Dtoc(mv_par21)+" |"
    nLin := nLin + 1
    @ nLin,000 Psay "--------------------------------------------------------------------------------"
    nLin := nLin + 1
    @ nLin,000 Psay "| "+Iif(mv_par22 == 1,"4"," ")+"   |"+mv_par23+"|"+mv_par24+"|"+mv_par25+"|"+Dtoc(mv_par26)+" |"
    nLin := nLin + 1
    @ nLin,000 Psay "--------------------------------------------------------------------------------"
    nLin := nLin + 1
    @ nLin,000 Psay "| REV |          DESCRICAO           | ELABORADO POR | APROVADO POR  |   DATA  |"
    nLin := nLin + 1
    @ nLin,000 Psay "--------------------------------------------------------------------------------"
EndIf

Roda(cbCont,"Estrutura",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

MS_FLUSH()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 15/10/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)

    aRegs := {}

    aadd(aRegs,{cPerg,'01','Produto        ? ','','','mv_ch1','C',15, 0, 0,'G', '', 'mv_par01',''   ,'','','','',''  ,'','','','','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'02','Revisao 0      ? ','','','mv_ch2','N',01, 0, 0,'C', '', 'mv_par02','Sim','','','','','Nao','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Descricao 0    ? ','','','mv_ch3','C',30, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Elaboracao 0   ? ','','','mv_ch4','C',15, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Aprovacao 0    ? ','','','mv_ch5','C',15, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'06','Data 0         ? ','','','mv_ch6','D',08, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Revisao 1      ? ','','','mv_ch7','N',01, 0, 0,'C', '', 'mv_par07','Sim','','','','','Nao','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'08','Descricao 1    ? ','','','mv_ch8','C',30, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Elaboracao 1   ? ','','','mv_ch9','C',15, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'10','Aprovacao 1    ? ','','','mv_cha','C',15, 0, 0,'G', '', 'mv_par10','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'11','Data 1         ? ','','','mv_chb','D',08, 0, 0,'G', '', 'mv_par11','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'12','Revisao 2      ? ','','','mv_chc','N',01, 0, 0,'C', '', 'mv_par12','Sim','','','','','Nao','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'13','Descricao 2    ? ','','','mv_chd','C',30, 0, 0,'G', '', 'mv_par13','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'14','Elaboracao 2   ? ','','','mv_che','C',15, 0, 0,'G', '', 'mv_par14','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'15','Aprovacao 2    ? ','','','mv_chf','C',15, 0, 0,'G', '', 'mv_par15','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'16','Data 2         ? ','','','mv_chg','D',08, 0, 0,'G', '', 'mv_par16','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'17','Revisao 3      ? ','','','mv_chh','N',01, 0, 0,'C', '', 'mv_par17','Sim','','','','','Nao','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'18','Descricao 3    ? ','','','mv_chi','C',30, 0, 0,'G', '', 'mv_par18','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'19','Elaboracao 3   ? ','','','mv_chj','C',15, 0, 0,'G', '', 'mv_par19','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'20','Aprovacao 3    ? ','','','mv_chk','C',15, 0, 0,'G', '', 'mv_par20','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'21','Data 3         ? ','','','mv_chl','D',08, 0, 0,'G', '', 'mv_par21','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'22','Revisao 4      ? ','','','mv_chm','N',01, 0, 0,'C', '', 'mv_par22','Sim','','','','','Nao','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'23','Descricao 4    ? ','','','mv_chn','C',30, 0, 0,'G', '', 'mv_par23','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'24','Elaboracao 4   ? ','','','mv_cho','C',15, 0, 0,'G', '', 'mv_par24','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'25','Aprovacao 4    ? ','','','mv_chp','C',15, 0, 0,'G', '', 'mv_par25','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'26','Data 4         ? ','','','mv_chq','D',08, 0, 0,'G', '', 'mv_par26','','','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'27','Imprime Revisao? ','','','mv_chr','N',01, 0, 0,'C', '', 'mv_par27','Sim','','','','','Nao','','','','','','','','','','',''})

    For i:=1 to Len(aRegs)
	Dbseek(cPerg+StrZero(i,2))
	If found() == .f.
	    RecLock("SX1",.t.)
	    For j:=1 to len(aRegs[i])
		FieldPut(j,aRegs[i,j])
	    Next
	    MsUnLock()
	EndIf
    Next
EndIf
