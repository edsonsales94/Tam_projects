#include "Protheus.CH"
#INCLUDE "RWMAKE.CH"          


#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE

/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ HISPEDCSV  ¦ Autor ¦Orismar Silva         ¦ Data ¦ 28/12/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦           ¦ Gera tela para carregar dados do arquivo CSV e informações    ¦¦¦
¦¦¦           ¦ do pedido.                                                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

User function HISPEDCSV()

Local aArea         := GetArea()
Private cTes        := Space(3)
Private cLocal      := Space(2)
Private cTipo       := "Pedido (*.CSV)        | *.CSV | Todos os Arquivos (*.csv)   | *.csv     "
Private mvpar01     := Space(30)
Private cxPath      := ""
Private cCaminho    := Space(100)
Private oPed

@ 275,235 To 496,880 Dialog oPed Title OemToAnsi("Gerar os Itens do pedido de venda")
@ 5,2  To 41,292 Title OemToAnsi("ARQUIVO:")
//@ 45,2 To 74,90 Title OemToAnsi("TES:")
//@ 45,150 To 74,238 Title OemToAnsi("ARMAZÉM:")
@ 75,2 To 79,311
@ 20,10 MSGET cCaminho Size 204,10   PIXEL of oPed WHEN .F.
//@ 57,7  MSGET cTes     F3 "SF4" Size 76,10  OF oPed PIXEL  VALID(PesqTES())
//@ 57,155  MSGET cLocal F3 "NNR" Size 76,10  OF oPed PIXEL  VALID(PesqLocal())

@ 18,224 Button OemToAnsi("Carregar arquivo CSV") Size 60,16 Action HISPROC()
@ 85,175 Button OemToAnsi("Gerar Itens")          Size 55,20 Action HISGRVITEM() 
@ 85,250 Button OemToAnsi("Fechar")               Size 55,20 Action Close(oPed) 

Activate Dialog oPed  CENTERED            



RestArea(aArea)
*
Return     


/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ HISPROC    ¦ Autor ¦Orismar Silva         ¦ Data ¦ 11/10/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦           ¦ Rotina para exibir a pasta d arquivo CSV.                     ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

Static Function HISPROC()

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
Static function HISGRVITEM() 
******************************
//Local nTot          := 0
//Local aCab          := {} 
//Local aProdEst      := {}
//Local lEnd          := .T.
//Local cNum          := ""

Private aItem       := {} 
Private aItens      := {} 
Private lMsErroAuto := .F. 
Private aLogP	    := {}
Private aDados      := {}   //Armazena os dados do aquivo .CSV        
/*
if Empty(cCaminho)
   Alert("Necessário informar o arquivo! ")
   Return .F.                             
endif

if Empty(cTes)
   Alert("Necessário informar a TES! ")
   Return .F.                             
endif
*/
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
Local i, ix
Local cLinha     := ""
Local nLin       := 1 
Local nTotLin    := 0
Local cFile      := cArq // Caminho+nome do arquivo .CSV
Local nHandle    := 0   
Local nLinTit    := 1    //Não considerar o cabeçalho do arquivo .CSV  
Local nPreco     := 0
Local nItem      := 1
Local nTot       := 0
//Local nPreco     := 0
Local nEstrutura := 0
Local nUsado	 := 0
Local nQtd       := 1
Local cItem      := strzero(1,TamSX3("C6_ITEM")[1])
//Local nUsado     := Len(aHeader)
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
Private _clasfis := AScan(aHeader,{|x|AllTrim(x[2])=="C6_CLASFIS"})

Private _lote1   := AScan(aHeader,{|x|AllTrim(x[2])=="C6_LOTE1"})
Private _lote2   := AScan(aHeader,{|x|AllTrim(x[2])=="C6_LOTECTL"})
Private _qtdlote := AScan(aHeader,{|x|AllTrim(x[2])=="C6_QTDLOTE"})
Private _Fabric  := AScan(aHeader,{|x|AllTrim(x[2])=="C6_FABRIC"})
Private _LtValid := AScan(aHeader,{|x|AllTrim(x[2])=="C6_LTVALID"})
Private _Lotectl := AScan(aHeader,{|x|AllTrim(x[2])=="C6_LOTECTL"})
Private _DtValid := AScan(aHeader,{|x|AllTrim(x[2])=="C6_DTVALID"})




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
   aAdd(aDados,&cLinha)
   /*
   nPos := aScan(aDados, {|x| x[2] == &cLinha[2] })
   if nPos = 0
      aAdd(aDados,&cLinha)
   else 
      aDados[nPos,9] := LTRIM(STR(VAL(aDados[nPos,9])+VAL(&cLinha[9])))
   endif
   */
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
   *
   FOR ix:=1 TO LEN(aDados)
       if !EMPTY(aDados[ix,1])          
          IncProc("Carregando Produto :"+aDados[ix,1])
          SF4->(dbSetOrder(1))
          SF4->(dbSeek(XFILIAL("SF4")+aDados[ix,5])) 
          dbSelectArea("SB1")            
          dbSetOrder(1)
          if dbSeek(xFilial("SB1")+aDados[ix,1])  .and. SB1->B1_MSBLQL == "2"   
             cItem            := Soma1(cItem)
             aCols[n,_cod]    := aDados[ix,1]
	         aCols[n,_Descri] := SB1->B1_DESC
	         aCols[n,_Um]     := SB1->B1_UM 
	         nQtd             := iif(AT(",",aDados[ix,3])> 0,VAL(STUFF(aDados[ix,3],AT(",",aDados[ix,3]),1,".")),VAL(aDados[ix,3]))
	         aCols[n,_Qtd]    := nQtd  //VAL(aDados[ix,3])
	         aCols[n,_Local]  := aDados[ix,2]
	         aCols[n,_Prcven] := VAL(STUFF(aDados[ix,4],AT(",",aDados[ix,4]),1,".")) 
	         aCols[n,_valor]  := ROUND(VAL(STUFF(aDados[ix,4],AT(",",aDados[ix,4]),1,"."))*nQtd,2) //ROUND(VAL(STUFF(aDados[ix,4],AT(",",aDados[ix,4]),1,"."))*VAL(aDados[ix,3]),2)
	         aCols[n,_tes]    := aDados[ix,5]	         
	         aCols[n,_cf]     := SF4->F4_CF
	         aCols[n,_lote1]  := aDados[ix,6] 
	         if Posicione("SF4", 1, XFILIAL("SF4")+aDados[ix,5], "F4_ESTOQUE") = "S"
	            aCols[n,_lote2]  := aDados[ix,6]
	         endif
	         aCols[n,_qtdlote]:= nQtd  //VAL(aDados[ix,3])
	         aCols[n,_Fabric] := CTOD(aDados[ix,7])
	         aCols[n,_LtValid]:= CTOD(aDados[ix,8])
	         //aCols[n,_Lotectl]:= aDados[ix,6] << A TES PRECISA MOVIMENTAR ESTOQUE
	         aCols[n,_DtValid]:= CTOD(aDados[ix,8])
	         aCols[n,_clasfis]:= SB1->B1_ORIGEM+SF4->F4_SITTRIB
             nProduto++
	         *	 
	         //Inseri nova linha.
	         if nProduto < LEN(aDados) 
	            if !Empty(aDados[nproduto+1,3])
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
             aAdd( aLogP, {cItem,aDados[ix,1],aDados[ix,3],0})	
             nProduto++
          endif
       endif
   NEXT
ENDIF
*
if Len(aLogP) > 0
   MsgAlert("Favor verificar o relatório!","Erro no CSV")
   HISPEDIMP()      
else
   Aviso("Importação","Total de produto importados : "+ALLTRIM(TRANSFORM(nProduto,"@E 9999")),{"OK"})
endif
*
Return aDados     


/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ HISPEDIMP  ¦ Autor ¦Orismar Silva         ¦ Data ¦ 28/12/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ DESCRIÇÃO ¦ Relatorio de produtos com erro CSV.                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/
Static Function HISPEDIMP()      

	Private oReport, oSection1
	Private cPerg    := ""

	oReport := ReportDef()
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	oReport:PrintDialog()

Return

/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ ReportDef  ¦ Autor ¦Orismar Silva         ¦ Data ¦ 28/12/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ DESCRIÇÃO ¦ Relatorio de produtos não encontrados.                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

Static Function ReportDef()

	Private cTitulo := 'Relação de produtos'

		
    oReport := TReport():New("HISPEDIMP", cTitulo, cPerg , {|oReport| PrintReport(oReport)},"Emitirá Relatório com relação de produtos")

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


/*/
+-------------------------------------------------------------------------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ PrintReport¦ Autor ¦Orismar Silva         ¦ Data ¦ 28/12/2018 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ DESCRIÇÃO ¦ Monta o relatório.                                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
+-------------------------------------------------------------------------------+
/*/

Static Function PrintReport(oReport)
	Local ix
	
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
