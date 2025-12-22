#include "rwmake.ch"                         

User Function HFATR001()     
************************
SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2,CPERG")
SetPrvt("CCANCEL,M_PAG,WNREL,_DDATAINI,_DDATAFIM,LARGURA")
SetPrvt("CCABEC2,NTAMLIN,CCABEC3,NTAMTIT,CCABEC4,CITENS")
SetPrvt("CRODAPE,AL,NLIM,NLI,NPG,ATEMP,CTEMP,_NTOTAL,_CVENDEDOR")
SetPrvt("_NVALOR,ADADOS,_CCFO,CDBF,CNTX,NORDEM,AORD,_NREGPAR")
SetPrvt("_NSUBTOT,_NACRESC,_NDESCON,_NSUFRAM,_NIPI,_NICMS,_NSUBST")
SetPrvt("_CFILIAL,_DDATADE,_DDATAATE,_CVENDDE,_CVENDATE,_CNATDE,_CNATATE")
SetPrvt("_CCLIDE,_CCLIATE_NREGGER,_NITEM,_NDESCORI,_NQUANT,_NVALPRO")
SetPrvt("_NUNIT,_NTOTNF,_CNFANT,NTLI,_LD2FLAG_DDATA,_CNATUREZ,_CTIPONF,_CQTDREG")
SetPrvt("_NBONGER,_NSBTGER,_NACRGER,_NDESGER,_NIPIGER,_NICMGER,_NTOTGER")
SetPrvt("CDOC,CSERIE,_CNAT1,_CNAT2,_CNAT3,_CNAT4,_CNAT5")
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ HFATR001 ³ Autor ³ ROMUALDO              ³Criado³ 21/09/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Emite relatorio totalizador/prod (relacao de n.f. de saida)³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado  ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//Set Softseek on
cString   :="SD2"
cDesc1    := OemToAnsi("Este programa tem como objetivo, emitir Registro de ")
cDesc2    := OemToAnsi("Saidas por Produto.")
cDesc3    := ""
aOrd      := {" Produto "," Cliente "}
tamanho   :="M"
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  :="HFATR001"
aLinha    := { }
nLastKey  := 0
Titulo    := "Totalizado"
Cabec1    := ""
Cabec2    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
cPerg     := "FATR01"
wnrel     := "HFATR001" 
m_pag     :=  0  
nTipo     := 18
  //ROMUALDO
//CriPerg(cPerg)

Pergunte(cPerg,.F.)

If nLastKey == 27
	Return
Endif


wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Filial                               ³
//³ mv_par02             // Data De                              ³
//³ mv_par03             // Data Ate                             ³
//³ mv_par04             // Tipo NF (NF/Entrega/Geral)           ³
//³ mv_par05             // Natureza da Operacao                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cFilial  := ""   // Da Filial
_dDataDe  := mv_par01   // Data Emissao De
_dDataAte := mv_par02   // Data Emissao Ate
_cTiponf  := ""   // Tipo nf
_CQTDREG  := MV_PAR03


SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

Set Softseek on

nOrdem  := aReturn[8]
Titulo := Alltrim(Titulo) + "-Por Produto "

	Titulo := Titulo + ", Geral"

nLastKey  := 0
_nTotnf   := 0
_cNfAnt   := ""
_nTotReg  := 0

Processa({|| Gertmp() },"Aguarde Processamento Demorado...")
RptStatus({|| Listtmp() },"Gerando Relatorio...")


Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo temporario                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Gertmp()
************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query Seleciona campos do SD2 e SC6                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSerie := "X  "



cQuery := "SELECT TOP "+ALLTRIM(MV_PAR03)+" D2_COD PRODUTO, SUM(D2_QUANT) QUANT, SUM(D2_TOTAL) TOTAL ,B1_ESPECIF"
cQuery += " FROM SD2010,SB1010"
cQuery += " WHERE SD2010.D_E_L_E_T_ = '' AND SB1010.D_E_L_E_T_ = '' AND D2_COD = B1_COD AND"
cQuery += " D2_EMISSAO >= '"+DTOS(mv_par01)+"' AND"
cQuery += " D2_EMISSAO <= '"+DTOS(mv_par02)+"' AND"
cQuery += " D2_NFORI   = '      '     AND"  
cQuery += " D2_TIPO    <> 'D'" 
cQuery += " GROUP BY D2_COD,B1_ESPECIF " 
cQuery += " ORDER BY SUM(D2_TOTAL) DESC "   




cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRA",.T.,.T.)
TcSetField("TRA", "FILIAL" , "C",02,0)
TcSetField("TRA", "PRODUTO", "C",15,0)
TcSetField("TRA", "QUANT"  , "N",12,3)
TcSetField("TRA", "TOTAL"  , "N",14,2)

aTemp:={}
aadd(aTemp,{"FILIAL" ,"C",02,0})
aadd(aTemp,{"PRODUTO","C",15,0})
aadd(aTemp,{"QTD"    ,"N",13,3})
aadd(aTemp,{"DESCRIC","C",30,0})
aadd(aTemp,{"TOT"    ,"N",15,2})
aadd(aTemp,{"ITEM"   ,"N",03,0})

Dbcreate("\Custo_Excell\HFATR001.CSV", aTemp)
   	
DbUseArea(.T.,,"\Custo_Excell\HFATR001.CSV","TMP",.T.)

DbSelectArea("TMP")

cInd := CriaTrab(NIL,.F.)

IndRegua("TMP",cInd,"PRODUTO",,,"Selecionando Registros...")

_nTotReg  := 0

ProcRegua(5000)

DBSelectArea("TRA") //Notas de Saida
DbGotop()
_nRec := 1

Do While !eof()
	
   _nTotReg  := _nTotReg  + 1
   
   DbSelectArea("TMP") //Arquivo Temporario a ser Feito
   
   If !DbSeek(TRA->PRODUTO)

	  Reclock("TMP",.T.)
	  
	  TMP->PRODUTO := TRA->PRODUTO
	  TMP->QTD     := TRA->QUANT
	  TMP->DESCRIC := GetAdvFval("SB1","B1_ESPECIF",xFilial("SB1")+TRA->PRODUTO,1,"")
      TMP->TOT     := TRA->TOTAL
      
   Else	                         
      
      Reclock("TMP",.F.)
	  TMP->QTD     := (TRA->QUANT + TMP->QTD)
      TMP->TOT     := TRA->TOTAL + TMP->TOT
      TMP->ITEM    := TMP->ITEM  + 1
   Endif
    
   Msunlock()
    	
   DBSelectArea("TRA")
   Dbskip()

   IncProc("Gerando Arquivo Temporario..."+StrZero(_nRec,5))
   _nRec := _nRec + 1
End

Dbselectarea("TRA")
DbClosearea()


Return


Static Function Listtmp()
*************************

nLin := 61

nTotQtd := 0
nTotVlr := 0

DbSelectArea("TMP")
Dbgotop()
SetRegua(Reccount()) 

Do While !Eof()

   If lAbortPrint
   
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   /*
             1         2         3         4         5         6         7         8         9        10        11        12        13   
   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
           Produto                 Descricao                    Quantidade/CX            Faturamento           Emissao        Item      
       123456789012345     123456789012345678901234567890      999,999,999.999        999,999,999,999.99      99/99/9999       999
                                           Total Geral CX    9,999,999,999.999  R$  9,999,999,999,999.99
   */

   If nLin > 60   
      
      Cabec2 := "        Produto                 Descricao                    Quantidade               Faturamento        "
      Cabec1 := "Periodo de: "+Dtoc(Mv_PAR01)+" a "+Dtoc(Mv_PAR02)
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif
  
   IncRegua()
   
   @nLin,004 PSAY TMP->PRODUTO
   @nLin,024 PSAY TMP->DESCRIC
   @nLin,060 PSAY TRANSFORM(TMP->QTD,"@E     999,999,999.999")
   @nLin,083 PSAY TRANSFORM(TMP->TOT,"@E 999,999,999,999.99")
   
   nTotQtd := nTotQtd + TMP->QTD
   nTotVlr := nTotVlr + TMP->TOT
   
   nLin := nLin + 1 

   dbSkip() 
EndDo

nLin := nLin + 1 

If nTotQtd > 0
      
   @nLin,040 PSAY "Total Geral    "
   @nLin,058 PSAY TRANSFORM(nTotQtd,"@E 9,999,999,999.999")
   @nLin,077 PSAY "      R$"
   @nLin,081 PSAY TRANSFORM(nTotVlr,"@E  9,999,999,999,999.99")
Endif   


SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Set Softseek off
Set Filter To

Dbselectarea("TMP")
DbCloseArea()

Return
   

//ROMUALDO
 
                      /*
Static Function CriPerg(cPerg)
*******************************

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)


aAdd(aRegs,{cPerg,"01","Filial             ","","","mv_ch1","C",2,0,0,"G","naovazio","mv_par01","          ","","","","","            ","","","","","     ","","","","","","","","","","","","","","SM0",""})
aAdd(aRegs,{cPerg,"02","Data de            ","","","mv_ch2","D",8,0,0,"G","        ","mv_par02","          ","","","","","            ","","","","","     ","","","","","","","","","","","","","","   ",""})
aAdd(aRegs,{cPerg,"03","Data ate           ","","","mv_ch3","D",8,0,0,"G","naovazio","mv_par03","          ","","","","","            ","","","","","     ","","","","","","","","","","","","","","   ",""})
aAdd(aRegs,{cPerg,"04","Tipo de Relatorio  ","","","mv_ch4","N",1,0,0,"C","        ","mv_par04","Nf Normais","","","","","Nf Entreguas","","","","","Geral","","","","","","","","","","","","","","   ",""})
aAdd(aRegs,{cPerg,"05","Natureza           ","","","mv_ch5","C",16,0,0,"G","        ","mv_par05","          ","","","","","            ","","","","","     ","","","","","","","","","","","","","","   ",""})


For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

dbSelectArea(_sAlias)

Return
                        */