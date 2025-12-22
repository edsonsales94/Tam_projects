#include "Protheus.ch"
#include "rwmake.ch"
#Include "TOTVS.ch"
#include "TopConn.ch"
#include "TBIConn.ch"
#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE

User function ImportCT2()
    nTipo := 1
    Private cDoc        := Space(6)
    Private cLote       := Space(6)
    Private mvpar01     := Space(30)
    Private cCaminho    := Space(100)
    Private cTipo       := "Contabilidade (*.CSV)        | *.CSV |"
    Private cTipo       := cTipo + "Todos os Arquivos (*.csv)   | *.csv"
    Private cxPath      := ""
    Private lRet        := .T.
    DEFINE FONT oFnt1 Bold
 
    @ 195,308 To 587,650 Dialog oTela Title OemToAnsi("Lançamentos Contábil - Importar CSV")
    //Titulos
    @ 14,8 To 160,160 Title OemToAnsi("Informações Contábeis") 
    @ 34,14  Say OemToAnsi("N. Lote:")          Size 45,8 OF oTela PIXEL OF FONT oFnt1
    @ 54,14  Say OemToAnsi("Documento:")        Size 45,8 OF oTela PIXEL OF FONT oFnt1
    @ 75,14  Say OemToAnsi("Arquivo:")          Size 45,8 OF oTela PIXEL OF FONT oFnt1

    //Campos
    @ 32,66   MSGET cLote    F3 "LOTNUM"  Size 40,10  OF oTela PIXEL //Consulta Cadastrada na SXB
    @ 52,66   MSGET cDoc     F3 "999999"    Size 76,10  OF oTela PIXEL
    @ 85,14   MSGET cCaminho Size 132,10  PIXEL of oTela WHEN .F.

    @ 100,101 Button OemToAnsi("Arquivo")  Size 45,16 Action CarregaCSV() 
    @ 170,45  Button OemToAnsi("Executar") Size 45,16 Action  GravaCSV() 
    @ 170,101 Button OemToAnsi("Fechar")   Size 45,16 Action Close(oTela)

    Activate Dialog oTela  CENTERED


Return    


**************************
Static Function CarregaCSV()
**************************
cArq := ( cxPath + RTRIM(mvpar01) + ".csv" )
lArq := .T.

IF ( !FILE(cArq) )
   lArq := .F.
   cArq := cGetFile( cTipo,"Selecione arquivo...",1  , cxPath , .T. , CGETFILE_TYPE )
   If Empty(cArq).AND.Empty(mvpar01)
      Aviso("A T EN Ç Ã O!","Operação cancelada pelo usuário.",{"Ok"})
   Endif
ENDIF
IF ( !EMPTY(cArq) )
   cCaminho := cArq
   oTela:Refresh()
ENDIF
Return(.T.)



******************************
Static function GravaCSV() 
******************************
Local x
Local cLinha := StrZero(0,3)
Private aItem       := {} 
Private aItens      := {} 
Private lMsErroAuto := .F. 
Private aLogP	    := {}
Private aDados      := {}   //Armazena os dados do aquivo .CSV        

*
If Empty(cLote)
   Alert("Obrigatório informar o N. Lote")
   Return .F.
Elseif Empty(cCaminho)
   Alert("Obrigatório selecionar o arquivo! ")
   Return .F.                             
ElseIf Empty(cDoc) 
   Alert("Obrigatório informar o Documento! ")
   Return .F.                             
Endif
//Verifica o arquivo
ProcOK()

IF ( LEN(aDados) > 0 ) .AND. lRet
   //Gravação dos dados
    Processa( {|| GravOK() })
    FWAlertSuccess('Arquivo importar com sucesso!. Execute o "Recalculo de Saldos"!')
    Close(oTela)
Else
    FWAlertInfo("Não foi possivel importar o arquivo!","A T E N Ç Ã O")
Endif

Return

************************
Static Function ProcOK()
************************
cArqx     := cCaminho
lArq      := .T.
*                     
IF Len(aDados) = 0 
   *
   IF ( !EMPTY(cArqx) )
      Processa( {|| CargaArray(cArqx)})
   ENDIF
ELSE
   FWAlertInfo("Arquivo já processado.","A T E N Ç Ã O")
ENDIF
Return(.T.)

***********************************
Static Function CargaArray(cArq)
***********************************
Local ix,inx
Local cLinha  := ""
Local nLin    := 1 
Local nTotLin := 0
Local cFile   := cArq // Caminho+nome do arquivo .CSV
Local nHandle := 0   
Local nLinTit := 1    //Não considerar o cabeçalho do arquivo .CSV  
Local nPreco  := 0
Local nItem   := 1
Private aLogP := {}

//abre o arquivo csv
nHandle := Ft_Fuse(cFile)
If nHandle == -1
   Return aDados
EndIf
Ft_FGoTop()                                                         
nLinTot := FT_FLastRec()
ProcRegua(nLinTot)
if nTipo = 1
   //Pula as linhas de cabeçalho
   While nLinTit > 0 .AND. !Ft_FEof()
         Ft_FSkip()
         nLinTit--
   EndDo
endif

//percorre todas linhas do arquivo csv
Do While !Ft_FEof()
   //exibe a linha a ser lida
   IncProc("Carregando Linha "+AllTrim(Str(nLin))+" de "+AllTrim(Str(nLinTot)))
   nLin++
   //le a linha
   cLinha := Ft_FReadLn()
   //verifica se a linha está em branco, se estiver pula
   If Empty(AllTrim(StrTran(cLinha,';',''))) .or. Len(AllTrim(StrTran(cLinha,';',''))) < 11
      Ft_FSkip()
      Loop
   EndIf
   //transforma as aspas duplas em aspas simples
   cLinha := StrTran(cLinha,'"',"'")     
   cLinha += ";"+StrZero(nItem,4)
   cLinha := '{"'+cLinha+'"}' 
   //adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array 
   cLinha := StrTran(cLinha,';','","')
   AAdd(aDados,&cLinha)
   nItem  += 1
   //passa para a próxima linha
   FT_FSkip()
   //
EndDo
//libera o arquivo CSV
FT_FUse()             
//Exclui o arquivo csv
If File(cFile)
   //FErase(cFile)
EndIf

/*MONTAGEM DA TELA DE CONFERÊNCIA*/
aCabec := {}
AADD(aCabec, {"Lote"      , "Lote"    	  , "@!" , "06" , "00"})  // 01
AADD(aCabec, {"Documento" , "Documento"  , "@!" , "06" , "00"})  // 02
AADD(aCabec, {"Debito"    , "Debito"     , "@!" , "20" , "00"})  // 03
AADD(aCabec, {"Credito"   , "Credito"    , "@!" , "20" , "00"})  // 04
AADD(aCabec, {"Emissao"   , "Emissao"    , "@!" , "10" , "00"})  // 05
AADD(aCabec, {"Valor"     , "Valor"   	  , "@E 99,999,999,999.99" , "12" , "02"})  // 06
AADD(aCabec, {"Historico" , "Historico"  , "@!" , "40" , "00"})  // 07
AADD(aCabec, {"Obs"       , "Obs"        , "@!" , "40" , "00"})  // 07
    
Private aCampos := {}
AADD(aCampos, {"Lote"       , "C" , 06 , 00})  // 01
AADD(aCampos, {"Documento"  , "C" , 06 , 00})  // 02
AADD(aCampos, {"Debito"     , "C" , 20 , 00})  // 03
AADD(aCampos, {"Credito"    , "C" , 20 , 00})  // 04
AADD(aCampos, {"Emissao"    , "C" , 10 , 00})  // 05
AADD(aCampos, {"Valor"      , "N" , 12 , 02})  // 06
AADD(aCampos, {"Historico"  , "C" , 40 , 00})  // 07
AADD(aCampos, {"Obs"        , "C" , 40 , 00})  // 07

cArqTrab := FWTemporaryTable():New("DADOS")
cArqTrab:SetFields(aCampos)
cArqTrab:Create()

lRet := .T.
dbSelectArea("CT1")
dbSetOrder(1)
For inx := 1 to Len(aDados)
   //VALIDAÇÕES DE CONTA
   If(!CT1->(Dbseek(xFilial("CT1")+aDados[inx][3])))
      xObs := "#Conta de Débito inválida#"
      lRet := .F.
   ElseIf(!CT1->(Dbseek(xFilial("CT1")+aDados[inx][4])))
      xObs := "#Conta de Crédito inválida#"
      lRet := .F.
   Else
      xObs := "OK"
   EndIf

	RecLock("DADOS",.T.)
        DADOS->Lote      := cLote
        DADOS->Documento := cDoc
        DADOS->Debito    := aDados[inx][3]
        DADOS->Credito   := aDados[inx][4]
        DADOS->Emissao   := aDados[inx][5]
        DADOS->Valor     := Val(StrTran(aDados[inx][6],",","."))
        DADOS->Historico := aDados[inx][7]
        DADOS->Obs       := xObs
	MsUnlock()     
Next inx
       
DADOS->(DbGotop())
@ 000,000 TO 600,1100 DIALOG oDlg TITLE cCaminho  // "dados csv" 
@ 010,010 to 270,530 Browse "DADOS" Fields aCabec
@ 280,470 BMPBUTTON TYPE 1 ACTION (oDlg:end()) 
@ 280,500 BMPBUTTON TYPE 2 ACTION (lRet := .F.,oDlg:end())      
         
ACTIVATE DIALOG oDlg CENTERED
DADOS->(DbCloseArea())
CT1->(DbCloseArea()) 

Return aDados

********************************
Static Function GravOK()
********************************
Local cLinha := StrZero(0,3)
Local inx
Local nLin    := 1
Local nLinTit := 1    //Não considerar o cabeçalho do arquivo .CSV 
//abre o arquivo csv
nHandle := Ft_Fuse(cCaminho)
If nHandle == -1
   Return aDados
EndIf
Ft_FGoTop()                                                         
nLinTot := FT_FLastRec()
ProcRegua(nLinTot)
if nTipo = 1
   //Pula as linhas de cabeçalho
   While nLinTit > 0 .AND. !Ft_FEof()
         Ft_FSkip()
         nLinTit--
   EndDo
endif

//INCLUSÃO NA TABELA CT2 S/EXECAUTO
For inx := 1 to Len(aDados)
   //exibe a linha a ser lida
   IncProc("Gravando linhas "+AllTrim(Str(nLin))+" de "+AllTrim(Str(nLinTot)))
   nLin++
         cLinha  := Soma1(cLinha,Len(CT2->CT2_LINHA))
         dbSelectArea("CT2")
         RecLock("CT2",.T.)
            CT2->CT2_SBLOTE := '001'  //ALTERAR
            CT2->CT2_MOEDLC := '01'   //ALTERAR
            CT2->CT2_DC     := '3'    //ALTERAR
            CT2->CT2_TPSALD := '1'    //ALTERAR
            CT2->CT2_LINHA  := cLinha // Utilizado a FWSOMA1 p/ Sequencia Alfanumerica
            CT2->CT2_LOTE   := cLote
            CT2->CT2_DOC    := StrZero(Val(cDoc),6) 
            CT2->CT2_DEBITO := aDados[inx][3] 
            CT2->CT2_CREDITO:= aDados[inx][4] 
            CT2->CT2_DATA   := CTOD(aDados[inx][5])
            CT2->CT2_VALOR  := Val(StrTran(aDados[inx][6],",","."))
            CT2->CT2_HIST   := aDados[inx][7]
         MsUnlock() 
         CT2->(DbCloseArea())
//passa para a próxima linha
FT_FSkip()	      
Next inx

Return
