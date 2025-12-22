#include "Protheus.CH"
#INCLUDE "RWMAKE.CH"          


#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE

/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ JFLPEDCSV  ¦ Autor ¦Orismar Silva         ¦ Data ¦ 11/10/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦           ¦ Gera tela para carregar dados do arquivo CSV e informações    ¦¦¦
¦¦¦           ¦ do pedido.                                                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

User function JFLPEDCSV()

Local aArea         := GetArea()
Private cTes        := Space(3)
Private cLocal      := Space(2)
Private cTipo       := "Pedido (*.CSV)        | *.CSV | "
Private cTipo       := cTipo + "Todos os Arquivos (*.csv)   | *.csv     "
Private mvpar01     := Space(30)
Private cxPath      := ""
Private cCaminho    := Space(100)
Private oPed

@ 275,235 To 496,880 Dialog oPed Title OemToAnsi("Gerar os Itens do pedido de venda")
@ 5,2  To 41,292 Title OemToAnsi("ARQUIVO:")
@ 45,2 To 74,90 Title OemToAnsi("TES:")
@ 45,150 To 74,238 Title OemToAnsi("ARMAZÉM:")
@ 75,2 To 79,311
@ 20,10 MSGET cCaminho Size 204,10   PIXEL of oPed WHEN .F.
@ 57,7  MSGET cTes     F3 "SF4" Size 76,10  OF oPed PIXEL  VALID(PesqTES())
@ 57,155  MSGET cLocal     F3 "NNR" Size 76,10  OF oPed PIXEL  VALID(PesqLocal())

@ 18,224 Button OemToAnsi("Carregar arquivo CSV") Size 60,16 Action JFLPROC()
@ 85,175 Button OemToAnsi("Gerar Itens")          Size 55,20 Action JFLGRVITEM() 
@ 85,250 Button OemToAnsi("Fechar")               Size 55,20 Action Close(oPed) 

Activate Dialog oPed  CENTERED            



RestArea(aArea)
*
Return     


/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ JFLPROC    ¦ Autor ¦Orismar Silva         ¦ Data ¦ 11/10/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦           ¦ Rotina para exibir a pasta d arquivo CSV.                     ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

Static Function JFLPROC()

cArq := ( cxPath + RTRIM(mvpar01) + ".csv" )
lArq := .T.

IF ( !FILE(cArq) )
   lArq := .F.
   cArq := cGetFile( cTipo,"Selecione arquivo...",1  , cxPath , .T. , CGETFILE_TYPE )
   If Empty(cArq).AND.Empty(mvpar01)
      Aviso("Cancelada a Seleção!","Você cancelou a seleção do arquivo.",{"Ok"})
   Endif
ENDIF
IF ( !EMPTY(cArq) )
   cCaminho := cArq
   oPed:Refresh()
ENDIF

Return(.T.)     



*****************************
Static Function PesqTES()
*****************************

IF !Empty(cTes) 
   DBSelectArea("SF4")
   DBSetOrder(1)
   if !DBSeek(xFilial("SF4")+cTes)
      MsgStop("TES não cadastrada !!!")
      Return (.F.)
   Endif
ENDIF


Return(.T.)

*****************************
Static Function PesqLocal()
*****************************

IF !Empty(cLocal) 
   DBSelectArea("NNR")
   DBSetOrder(1)
   if !DBSeek(xFilial("NNR")+cLocal)
      MsgStop("Armazém não cadastrado !!!")
      Return (.F.)
   Endif
ENDIF


Return(.T.)


******************************
Static function JFLGRVITEM() 
******************************
Local n:=1
Local nTot          := 0
Local aCab          := {} 
Local aProdEst      := {}
Local lEnd          := .T.
Local cNum          := ""
Private aItem       := {} 
Private aItens      := {} 
Private lMsErroAuto := .F. 
Private aLogP	    := {}
Private aDados      := {}   //Armazena os dados do aquivo .CSV        
*
if Empty(cCaminho)
   Alert("Necessário informar o arquivo! ")
   Return .F.                             
endif

if Empty(cTes)
   Alert("Necessário informar a TES! ")
   Return .F.                             
endif
*
ProcOK()
Close(oPed) 
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
   Aviso("ATENÇÃO","Arquivo já processado.",{"Ok"})
ENDIF
Return(.T.)

***********************************
Static Function CargaArray(cArq)
***********************************
Local cLinha     := ""
Local nLin       := 1 
Local nTotLin    := 0
Local cFile      := cArq // Caminho+nome do arquivo .CSV
Local nHandle    := 0   
Local nLinTit    := 3    //Não considerar o cabeçalho do arquivo .CSV  
Local nPreco     := 0
Local nItem      := 1
Local nTot       := 0
Local nPreco     := 0
Local nEstrutura := 0
Local nUsado	 := 0
Local nQtd       := 1
Local cItem      := strzero(1,TamSX3("C6_ITEM")[1])
Local nUsado     := Len(aHeader)
Local aExport    := aClone(aCols) 
Private _cod     := AScan(aHeader,{|x|AllTrim(x[2])=="C6_PRODUTO"})
Private _Descri  := AScan(aHeader,{|x|AllTrim(x[2])=="C6_DESCRI"})
Private _Um      := AScan(aHeader,{|x|AllTrim(x[2])=="C6_UM"})
Private _Qtd     := AScan(aHeader,{|x|AllTrim(x[2])=="C6_QTDVEN"})
Private _Local   := AScan(aHeader,{|x|AllTrim(x[2])=="C6_LOCAL"}) 
Private _Prcven  := AScan(aHeader,{|x|AllTrim(x[2])=="C6_PRCVEN"})
Private _valor   := AScan(aHeader,{|x|AllTrim(x[2])=="C6_VALOR"})
Private _tes     := AScan(aHeader,{|x|AllTrim(x[2])=="C6_TES"})
Private _cf      := AScan(aHeader,{|x|AllTrim(x[2])=="C6_CF"})

nUsado  := Len(aHeader)
//abre o arquivo csv
nHandle := Ft_Fuse(cFile)
If nHandle == -1
   Return aDados
EndIf
Ft_FGoTop()                                                         
nLinTot := FT_FLastRec()
ProcRegua(nLinTot)

//Pula as linhas de cabeçalho
While nLinTit > 0 .AND. !Ft_FEof()
      Ft_FSkip()
      nLinTit--
EndDo

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
   nPos := aScan(aDados, {|x| x[2] == &cLinha[2] })
   if nPos = 0
      aAdd(aDados,&cLinha)
   else 
      aDados[nPos,7] := LTRIM(STR(VAL(aDados[nPos,7])+VAL(&cLinha[7])))
   endif
   
   //aAdd(aDados, &cLinha)
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
*
IF ( LEN(aDados) > 0 )
   ProcRegua(Len(aDados))
   cItem    := "01"
   nProduto := 0
   /*
   FOR ix:=1 TO LEN(aDados)
       if !EMPTY(aDados[ix,2])          
          dbSelectArea("SB1")            
          dbSetOrder(1)
          if !(dbSeek(xFilial("SB1")+aDados[ix,2])) .or. SB1->B1_MSBLQL == "1"   
             aAdd( aLogP, {aDados[ix,1],aDados[ix,2],aDados[ix,7],0})	
          endif
       else
          aAdd( aLogP, {aDados[ix,1],aDados[ix,2],aDados[ix,7],0})	
       endif
   NEXT
   */
   //if Len(aLogP) = 0
      FOR ix:=1 TO LEN(aDados)
       *
          if !EMPTY(aDados[ix,2])          
             IncProc("Carregando Produto :"+aDados[ix,2])
             SF4->(dbSetOrder(1))
	         SF4->(dbSeek(XFILIAL("SF4")+cTes)) 
             dbSelectArea("SB1")            
             dbSetOrder(1)
             if dbSeek(xFilial("SB1")+aDados[ix,2])  .and. SB1->B1_MSBLQL == "2"   
          	    cItem  := Soma1(cItem)
          	    aCols[n,_cod]    := aDados[ix,2]
	            aCols[n,_Descri] := SB1->B1_DESC
	            aCols[n,_Um]     := SB1->B1_UM
	            aCols[n,_Qtd]    := VAL(aDados[ix,7])
	            aCols[n,_Local]  := cLocal //SB1->B1_LOCPAD
	            aCols[n,_Prcven] := SB1->B1_UPRC
	            if SB1->B1_UPRC = 0
	              aAdd( aLogP, {aDados[ix,1],aDados[ix,2],aDados[ix,7],SB1->B1_UPRC})	
	            endif
	            aCols[n,_valor]  := ROUND(SB1->B1_UPRC*VAL(aDados[ix,7]),2)
	            aCols[n,_tes]    := cTes
	            aCols[n,_cf]     := SF4->F4_CF
                nProduto++
	            *	 
	           //Inseri nova linha.
	            if nProduto < LEN(aDados) 
	               if !Empty(aDados[nproduto+1,3])
	                            //   1 ,2 , 3, 4,5,6,7,8,9 ,10,11,12,13,14,15,16,  17     ,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102
	                  //aadd(aCols,{cItem,'','','',0,0,0,0,'',0,'','',0,'','', 0,dDataBase, 0, 0,'', 0,'','', 0,'',0 ,'','','',0,'','','','','',ctod(' / / '),'','','','','','','F','','','','','',0,'','','','','',dDataBase,'',0,0,0,'','','','2','','','','',0,'','','',ctod(' / / '),0,0,'','','','','','','','','','','',ctod(' / / '),'','1','','','','','','','','1','',0,'','SC6',0,.F.})
	                  //aadd(aCols,{cItem,'','','',0,0,0,0,'',0,'','',0,'','', 0,dDataBase, 0, 0,'', 0,'','', 0,'',0 ,'','','',0,'','','','','',ctod(' / / '),'','','','','','','F','','','','','',0,'','','','','',dDataBase,'',0,0,0,'','','','','','','2','','','','',0,'','','',ctod(' / / '),0,0,'','','','','','','','','','','',ctod(' / / '),'','1','','','','','','','','1','',0,'','SC6',0,.F.})
	                  //Montagem do aCols
                      AADD(aCols,Array(LEN(aHeader)+1)) 
                      aCols[LEN(aCols),LEN(aHeader)+1]:=.F. 
                      For i := 1 to LEN(aHeader) 
                           If !alltrim(aHeader[i,2]) $ 'C6_ALI_WT|C6_REC_WT|C6_ITEM'
                                aCols[LEN(aCols),i]:=CriaVar(aHeader[i,2]) 
                           ElseIf aHeader[i,2] == "C6_ALI_WT" 
                                aCols[LEN(aCols),i]:= "SC6" 
                           ElseIf aHeader[i,2] == "C6_REC_WT" 
                                aCols[LEN(aCols),i]:= 0 
                           ElseIf alltrim(aHeader[i,2]) == "C6_ITEM" 
			                    aCols[LEN(aCols),i]:= cItem
                           EndIf 
                      Next	                  
	                  n++
	               endif
                endif             
             else
                aAdd( aLogP, {aDados[ix,1],aDados[ix,2],aDados[ix,7],0})	
                nProduto++
             endif
          endif
      NEXT
     // n := 1
   //endif   
ENDIF
*
if Len(aLogP) > 0
   MsgAlert("Favor verificar o relatório!","Erro no CSV")
   JFLPEDIMP()      
else
   Aviso("Importação","Total de produto importados : "+ALLTRIM(TRANSFORM(nProduto,"@E 9999")),{"OK"})
endif
*
Return aDados     


/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ JFLPEDIMP  ¦ Autor ¦Orismar Silva         ¦ Data ¦ 17/10/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ DESCRIÇÃO ¦ Relatorio de produtos com erro CSV.                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/
Static Function JFLPEDIMP()      

	Private oReport, oSection1
	Private cPerg    := ""

	oReport := ReportDef()
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	oReport:PrintDialog()

Return

//=================================================================================
// relatorio de produtividade - formato personalizavel
//=================================================================================
Static Function ReportDef()

	Private cTitulo := 'Relação de produtos'

		
    oReport := TReport():New("JFLPEDIMP", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório com relação de produtos")

	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()

	oSection1 := TRSection():New(oReport,"Produtos não cadastrados/sem preço - CSV",{""})
	oSection1:SetTotalInLine(.F.)
                                        
   	TRCell():new(oSection1, "C_ITEM"    , "", "ITEM"                ,,10)
	TRCell():new(oSection1, "C_PROD"    , "", "PRODUTO"             ,,15)
    TRCell():new(oSection1, "C_DESC"    , "", "DESCRIÇÃO"           ,,35)	
    TRCell():new(oSection1, "C_QTD"     , "", "QUANTIDADE"          ,,10)	            
    TRCell():new(oSection1, "C_PRC"     , "", "PREÇO"               ,,10)	                
	

return (oReport)

//=================================================================================
// definicao para impressao do relatorio personalizado 
//=================================================================================
Static Function PrintReport(oReport)

	Local nReg
	Local lTitulo := .T.
	
	oSection1 := oReport:Section(1)

	oSection1:Init()
	oSection1:SetHeaderSection(.T.)   

	oReport:SetMeter(Len(aLogP))
	

	For ix:=1 to Len(aLogP)
	
		If oReport:Cancel()
			Exit
		EndIf 
        cDesc:=""
	    oReport:IncMeter()
  	    oSection1:Cell("C_ITEM"):SetValue(aLogP[ix,1])
	    oSection1:Cell("C_PROD"):SetValue(aLogP[ix,2])
	    cDesc := Posicione("SB1",1,XFILIAL("SB1")+aLogP[ix,2],"B1_DESC")
        oSection1:Cell("C_DESC"):SetValue(iif(Empty(cDesc),"",cDesc))
      	oSection1:Cell("C_QTD"):SetValue(aLogP[ix,3])      	   
      	oReport:SkipLine()
      	oSection1:PrintLine()

	Next
	oSection1:Finish()

Return
