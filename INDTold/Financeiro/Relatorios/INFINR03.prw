#INCLUDE "rwmake.ch"
#DEFINE NCOL1 01
#DEFINE NCOL2 07
#DEFINE NCOL3 31
#DEFINE NCOL4 40
#DEFINE NCOL5 53
#DEFINE NCOL6 64
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ INFINR03 บ Autor ณ Ener Fredes        บ Data ณ  03/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio que mostra a o Total de TiTulos                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ INDT                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function INFINR03
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatorio de Total de Titulos baixado"
Local titulo        := "Relatorio de Total de Titulos baixado"
Local nLin          := 80
Local Cabec1        := ""
Local Cabec2        := ""
Local aOrd          := {}
Local cPerg         := PADR("INFINR03",Len(SX1->X1_GRUPO))

Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "INFINR03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "INFINR03" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SE2"

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If MV_PAR05 == 1 
  Cabec1 := "Filial Cl.MCT                  Ano    Meses      Qtd Titulos      Vlr Baixados"/// Analitico
Else 
  Cabec1 := "Filial                         Ano    Meses      Qtd Titulos      Vlr Baixados"/// Sintetico
EndIf 

Processa({|| ExecProc(Cabec1,Cabec2,Titulo,nLin) }, "Filtrando dados")
Return

Static Function ExecProc(Cabec1,Cabec2,Titulo,nLin)
  Local cQuery
   
  If MV_PAR05 == 1 
    cQuery := " SELECT E2_FILIAL FILIAL,E2_CLVL MCT,CTH_DESC01 MCT_DESC,LEFT(E2_BAIXA,4) ANO,SUBSTRING(E2_BAIXA,5,2) MES,COUNT(*) QTD,SUM(E2_VALOR) VALOR 
    cQuery += " FROM "+RetSqlName("SE2")+" SE2"
    cQuery += " INNER JOIN "+RetSqlName("CTH")+" CTH ON CTH_CLVL = E2_CLVL AND CTH.D_E_L_E_T_ <> '*'"
    cQuery += " WHERE SE2.D_E_L_E_T_ <> '*' 
    cQuery += " AND E2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
    cQuery += " AND E2_BAIXA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"'
    cQuery += " GROUP BY E2_FILIAL,E2_CLVL,CTH_DESC01,LEFT(E2_BAIXA,4),SUBSTRING(E2_BAIXA,5,2)
    cQuery += " ORDER BY LEFT(E2_BAIXA,4),SUBSTRING(E2_BAIXA,5,2),E2_FILIAL,E2_CLVL
  Else
    cQuery := " SELECT E2_FILIAL FILIAL,LEFT(E2_BAIXA,4) ANO,SUBSTRING(E2_BAIXA,5,2) MES,COUNT(*) QTD,SUM(E2_VALOR) VALOR 
    cQuery += " FROM "+RetSqlName("SE2")+" SE2"
    cQuery += " WHERE SE2.D_E_L_E_T_ <> '*' 
    cQuery += " AND E2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
    cQuery += " AND E2_BAIXA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"'
    cQuery += " GROUP BY E2_FILIAL,LEFT(E2_BAIXA,4),SUBSTRING(E2_BAIXA,5,2)
    cQuery += " ORDER BY LEFT(E2_BAIXA,4),SUBSTRING(E2_BAIXA,5,2),E2_FILIAL
  EndIf
  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMP",.T.,.T.)
  If MV_PAR06 == 1
    Processa({|| RunExcel() }, "Gerando em Excel")
  Else
    RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
  EndIf
  DbSelectArea("TMP")
  dbCloseArea()
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  01/12/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
   Local nQtdParc := 0
   Local nQtdTotGeral := 0
   Local nQtdFilial := 0

   Local nVlrParc := 0
   Local nVlrTotGeral := 0
   Local nVlrFilial := 0
   Local cMes  := ''
   Local cFil  := ''
   dbSelectArea("TMP")
   dbGoTop()
   SetRegua(RecCount())  
   While !TMP->(EOF())
     If TMP->MES <> cMes
       nVlrParc := 0
       nQtdParc := 0
       cMes   := TMP->MES
     EndIf
     If TMP->FILIAL <> cFil
       nVlrFilial := 0
       nQtdFilial := 0
       cFil   := TMP->FILIAL
     EndIf

     If lAbortPrint
       @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
       Exit
     Endif
     If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       nLin := 8
     Endif

     If MV_PAR05 == 1
       @nLin,NCOL1 PSAY TMP->FILIAL
       @nLin,NCOL2 PSAY Alltrim(TMP->MCT)+" - "+Left(TMP->MCT_DESC,15)
       @nLin,NCOL3 PSAY TMP->ANO
       @nLin,NCOL4 PSAY TMP->MES
       @nLin,NCOL5 PSAY Transform(TMP->QTD,'999,999')
       @nLin,NCOL6 PSAY Transform(TMP->VALOR,'999,999,999.99')
     Else
       @nLin,NCOL1 PSAY TMP->FILIAL
       @nLin,NCOL3 PSAY TMP->ANO
       @nLin,NCOL4 PSAY TMP->MES
       @nLin,NCOL5 PSAY Transform(TMP->QTD,'999,999')
       @nLin,NCOL6 PSAY Transform(TMP->VALOR,'999,999,999.99')
     EndIf
     nVlrParc += TMP->VALOR
     nVlrTotGeral += TMP->VALOR
     nQtdParc += TMP->QTD
     nQtdFilial += TMP->QTD
     nVlrFilial += TMP->VALOR
     nQtdTotGeral += TMP->QTD
     nLin++
     TMP->(DbSkip())
     If MV_PAR05 == 1
       If TMP->FILIAL <> cFil
         @nLin,NCOL1 PSAY Replicate("-",80)
         nLin++
         @nLin,NCOL1 PSAY "Total Fililal -"
         @nLin,NCOL5 PSAY Transform(nQtdFilial,'999,999')
         @nLin,NCOL6 PSAY Transform(nVlrFilial,'999,999,999.99')
         nLin++
       EndIf
     EndIf
     If TMP->MES <> cMes
       @nLin,NCOL1 PSAY Replicate("-",80)
       nLin++
       @nLin,NCOL1 PSAY "Parcial -"
       @nLin,NCOL4 PSAY cMes
       @nLin,NCOL5 PSAY Transform(nQtdParc,'999,999')
       @nLin,NCOL6 PSAY Transform(nVlrParc,'999,999,999.99')
       nLin+= 2
     EndIf
   EndDo
   @nLin,NCOL1 PSAY "Total -"
   @nLin,NCOL5 PSAY Transform(nQtdTotGeral,'999,999')
   @nLin,NCOL6 PSAY Transform(nVlrTotGeral,'999,999,999.99')
   If aReturn[5]==1
      dbCommitAll()
      SET PRINTER TO
      OurSpool(wnrel)
   Endif
   MS_FLUSH()
Return
                

Static Function RunExcel()
  Local oExcelApp                           
  Local cArqTxt    := "C:\Temp\infinr03.xls"
  Local nHdl       := fCreate(cArqTxt)
  Local cLinha     := ""
  Local nQtdParc := 0
  Local nQtdTotGeral := 0
  Local nQtdFilial := 0

  Local nVlrParc := 0
  Local nVlrTotGeral := 0
  Local nVlrFilial := 0
  Local cMes  := ''
  Local cFil  := ''

  If MV_PAR05 == 1 
    cLinha := "Filial"+Chr(9)+"Cl.MCT"+Chr(9)+"Ano"+Chr(9)+"Meses"+Chr(9)+"Qtd Titulos"+Chr(9)+"Vlr Baixados"+Chr(9)+chr(13)+chr(10)
  Else 
    cLinha := "Filial"+Chr(9)+Chr(9)+"Ano"+Chr(9)+"Meses"+Chr(9)+"Qtd Titulos"+Chr(9)+"Vlr Baixados"+Chr(9)+chr(13)+chr(10)
  EndIf 

  If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
  EndIf          

  dbSelectArea("TMP")
  dbGoTop()
  While !TMP->(EOF())
    If TMP->MES <> cMes
      nVlrParc := 0
      nQtdParc := 0
      cMes   := TMP->MES
    EndIf
    If TMP->FILIAL <> cFil
      nVlrFilial := 0
      nQtdFilial := 0
      cFil   := TMP->FILIAL
    EndIf

    If MV_PAR05 == 1
      cLinha := TMP->FILIAL+Chr(9)
      cLinha += Alltrim(TMP->MCT)+" - "+Left(TMP->MCT_DESC,15)+Chr(9)
      cLinha += TMP->ANO+Chr(9)
      cLinha += TMP->MES+Chr(9)
      cLinha += Transform(TMP->QTD,'999,999')+Chr(9)
      cLinha += Transform(TMP->VALOR,'999,999,999.99')+Chr(9)
      cLinha += chr(13)+chr(10)
    Else
      cLinha := TMP->FILIAL+Chr(9)
      cLinha += Chr(9)
      cLinha += TMP->ANO+Chr(9)
      cLinha += TMP->MES+Chr(9)
      cLinha += Transform(TMP->QTD,'999,999')+Chr(9)
      cLinha += Transform(TMP->VALOR,'999,999,999.99')+Chr(9)
      cLinha += chr(13)+chr(10)
   EndIf
    If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
    EndIf          


    nVlrParc += TMP->VALOR
    nVlrTotGeral += TMP->VALOR
    nQtdParc += TMP->QTD
    nQtdFilial += TMP->QTD
    nVlrFilial += TMP->VALOR
    nQtdTotGeral += TMP->QTD
    TMP->(DbSkip())
    If MV_PAR05 == 1
      If TMP->FILIAL <> cFil
        cLinha := "Total Fililal"+Chr(9)
        cLinha += Chr(9)
        cLinha += Chr(9)
        cLinha += Chr(9)
        cLinha += Transform(nQtdFilial,'999,999')+Chr(9)
        cLinha += Transform(nQtdFilial,'999,999,999.99')+Chr(9)
        cLinha += chr(13)+chr(10)
        If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
        EndIf          
      EndIf
    EndIf
    If TMP->MES <> cMes
      cLinha := "Parcial"+Chr(9)
      cLinha += Chr(9)
      cLinha += Chr(9)
      cLinha += cMes+Chr(9)
      cLinha += Transform(nQtdParc,'999,999')+Chr(9)
      cLinha += Transform(nVlrParc,'999,999,999.99')+Chr(9)
      cLinha += chr(13)+chr(10)
      If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
      EndIf          
    EndIf
  EndDo
  cLinha := "Total"+Chr(9)
  cLinha += Chr(9)
  cLinha += Chr(9)
  cLinha += Chr(9)
  cLinha += Transform(nQtdTotGeral,'999,999')+Chr(9)
  cLinha += Transform(nVlrTotGeral,'999,999,999.99')+Chr(9)
  cLinha += chr(13)+chr(10)
  If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
  EndIf          
  fClose(nHdl)     

  If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
    MsgStop( 'MsExcel nao instalado' ) 
    //Close(oDlg)
    Return
  EndIf  
  oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
  oExcelApp:WorkBooks:Open(cArqTxt) 
  oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.  
  
Return             

Static Function ValidPerg(cPerg)
   u_INPutSX1(cPerg,"01","Da Filial                    ?","","","mv_ch1","C",02,0,0,"G","","   ","","","mv_par01")
   u_INPutSX1(cPerg,"02","Ate a Filial                 ?","","","mv_ch2","C",02,0,0,"G","","   ","","","mv_par02")
   u_INPutSX1(cPerg,"03","Da Data                      ?","","","mv_ch3","D",08,0,0,"G","","   ","","","mv_par03")
   u_INPutSX1(cPerg,"04","Ate a Data                   ?","","","mv_ch4","D",08,0,0,"G","","   ","","","mv_par04")
   u_INPutSx1(cPerg,"05","Tipo Relat๓rio               ?","","","mv_ch5","N",01,0,0,"C","","","","","mv_par05","Analitico","","","","Sintetico","","","")
   u_INPutSx1(cPerg,"06","Gera Excel                   ?","","","mv_ch6","N",01,0,0,"C","","","","","mv_par06","Sim","","","","Nใo")
Return