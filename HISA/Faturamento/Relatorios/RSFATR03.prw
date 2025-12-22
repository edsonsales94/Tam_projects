#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"



/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦RSFATR03    ¦ Autor ¦ ORISMAR SILVA        ¦ Data ¦ 05/12/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatorio de Rastreamento do Numero de Lote.                  ¦¦¦ 
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/


User Function RSFATR03()

Private oReport, oSection1
Private nTotQtd   := 0
Private nTotCust  := 0
Private ntotCusto := 0
Private _nPag     := 01

ApRelRN() // Executa versão nao personalizada

Return


//=================================================================================
// relatorio de producao - formato padrao
//=================================================================================
Static Function ApRelRN()
Local cPerg     := "RSFATR03"

Private Tamanho  := "G"  // P- pequeno M- médio G- grande
Private titulo   := "Rastreamento de Lotes"
Private cDesc1   := "Emitirá Relatorio de Rastreamento de Lote " 
Private cDesc2   := ""
Private cDesc3   := ""
Private cString  := "SD2" 
Private limite   := 141
Private aOrd     := {}
Private wnrel    := "RSFATR03"

Private nFator   := 0

PRIVATE aReturn   := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private nNivel    := 0       
Private nLin		:= 80                


// Cria as perguntas no SX1                                            
CriaSx1(cPerg)
Pergunte(cPerg,.F.)
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

If nLastKey == 27
	Set Printer to
	Return
Endif

SetDefault(aReturn,cString)

RptStatus({|lEnd| RelProd(@lEnd,wnRel,cString,tamanho,titulo)},titulo) //Incluido devido o relatório gráfico.

Return NIL

//=================================================================================
// IMPRIME O RELATORIO NO MODO GRAFICO
//=================================================================================
Static Function RelProd(lEnd,WnRel,cString,tamanho,titulo)

Local nTotNF  := 0
Local nTotQtd := 0
Local cQuery  := ""

oPrint := TMSPrinter():New("Relatorio de Rastreamento de Lote")
oPrint:SetLandScape()
//                  New([acName], [nPar2], [anHeight], [lPar4], [alBold], [nPar6], [lPar7], [nPar8], [alItalic], [alUnderline]) 
oFont04  := TFont():New("Times New Roman", 7.5,  10, .T., .F., 5, .T., 5, .T., .F.)
oFont05  := TFont():New("Times New Roman", 7.5,  10, .T., .F., 5, .T., 5, .T., .F.)
oFont05n := TFont():New("Times New Roman", 7.5,  10, .T., .T., 5, .T., 5, .T., .F.)
oFont14n := TFont():New("Times New Roman", 7.5,  14, .T., .T., 5, .T., 5, .T., .F.)
oFont08  := TFont():New("Times New Roman",   9,   8, .T., .F., 5, .T., 5, .T., .F.)
oFont08n := TFont():New("Times New Roman",   9,  12, .T., .T., 5, .T., 5, .T., .F.)
oFont10  := TFont():New("Arial",       9,  10, .T., .T., 5, .T., 5, .T., .F.)
oFont24  := TFont():New("Arial",       9,  20, .T., .F., 5, .T., 5, .T., .F.)
oFont1   := TFont():New("Times New Roman", 8.5,20,.T.,.T.,,,15)
oFont2   := TFont():New("Courier New", 7.5,15,.T.,.T.,,,15)

oBrush   := TBrush():New("",4)

nLin     := 2500
_lPriImp := .T.

cQuery := " SELECT C6_LOTE1,D2_CLIENTE,D2_LOJA, D2_DOC,D2_SERIE, D2_COD,D2_EMISSAO,D2_QUANT " 
cQuery += " FROM "+RetSQLName("SD2")+" SD2, "+RetSQLName("SC6")+" SC6 " 
cQuery += " WHERE SD2.D_E_L_E_T_ = ''  AND SC6.D_E_L_E_T_ = '' " 
cQuery += " AND C6_FILIAL = D2_FILIAL " 
cQuery += " AND C6_NUM = D2_PEDIDO " 
cQuery += " AND C6_ITEM = D2_ITEMPV " 
cQuery += " AND C6_CLI = D2_CLIENTE " 
cQuery += " AND C6_LOJA = D2_LOJA "
cQuery += " AND C6_LOTE1 <> '' " 
cQuery += " AND D2_FILIAL = '"+SM0->M0_CODFIL+"'
cQuery += " AND C6_LOTE1 BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery += " AND D2_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQuery += " AND D2_DOC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"   
cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"'"
cQuery += " ORDER BY C6_LOTE1,D2_EMISSAO,D2_CLIENTE, D2_LOJA "    

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMP",.T.,.F.)
   
If ! USED()
   MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
EndIf

Count to _nQtdReg
ProcRegua(_nQtdReg) 
SetRegua(_nQtdReg)

dbSelectArea("TMP")
dbGoTop()


While !Eof()
      *
      cLote := TMP->C6_LOTE1
      nTotCusto  := 0
      *
	
	   If nLin > 2000
		   If !_lPriImp
			   oPrint:EndPage()
		   EndIf
		   oPrint:StartPage()
		   RSPRO2Cabec()
   	   nLin := 460		
    	EndIf
	
	   oPrint:Say (nLin, 030, "NUMERO DO LOTE: "+cLote, oFont05n)
      nLin += 40
      While TMP->( ! Eof() ) .and. cLote = TMP->C6_LOTE1

		      If nLin > 2000
			      If !_lPriImp
				      oPrint:EndPage()
			      EndIf
			      oPrint:StartPage()
			      RSPRO2Cabec()
			      nLin := 460
		      EndIf
		      *
			   IncRegua()
	         *
            oPrint:Say  (nLin + 015,  030, TMP->D2_CLIENTE+"-"+TMP->D2_LOJA+" "+SUBSTR(Posicione("SA1",1,xFilial("SA1")+TMP->D2_CLIENTE+TMP->D2_LOJA,"A1_NOME"),1,40),oFont05)
		      oPrint:Say  (nLin + 015, 1150, TMP->D2_DOC+"-"+TMP->D2_SERIE                                                                                             ,oFont05)
		      oPrint:Say  (nLin + 015, 1410, SUBSTR(TMP->D2_EMISSAO,7,2)+"/"+SUBSTR(TMP->D2_EMISSAO,5,2)+"/"+SUBSTR(TMP->D2_EMISSAO,1,4)                               ,oFont05)
		      oPrint:Say  (nLin + 015, 1680, SUBSTR(TMP->D2_COD,1,10)                                                                                                  ,oFont05) 
		      oPrint:Say  (nLin + 015, 1880, SUBSTR(Posicione("SB1",1,XFILIAL("SB1")+TMP->D2_COD,"B1_DESC"),1,40)                                                      ,oFont05)
		      oPrint:Say  (nLin + 015, 2900, Transform(TMP->D2_QUANT,  "@E 999,999,999.99")                                                                            ,oFont05)
            nLin += 40
            nTotNF++
       	   nTotQtd += TMP->D2_QUANT		
            dbSkip()
	   End 
	   nLin += 20
      oPrint:Line (nLin + 005, 000, nLin + 005, 3199)
      oPrint:Say  (nLin + 025, 0030, "TOTAL DE NOTA.: "                      ,oFont05n)
      oPrint:Say  (nLin + 025, 1200, Transform(nTotNF, "@E 99999")           ,oFont05)
      oPrint:Say  (nLin + 015, 1880, "TOTAL QUANTIDADE.: "                   ,oFont05n)
      oPrint:Say  (nLin + 015, 2900, Transform(nTotQtd,  "@E 999,999,999.99"),oFont05) 
      nTotNF  := 0
 	   nTotQtd := 0
   	nLin += 100
End

nLin += 50
TMP->(dbCloseArea())

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

Return

//=================================================================================
// CABEÇALHO DO RELATORIO
//=================================================================================
Static Function RSPRO2Cabec()
Local aBitmap	:= {}
Local aBMP     := aBitMap

aBmp 	:= "\SYSTEM\LGRL01.BMP"


nLin := 50                           
If File(aBmp)
   oPrint:Line(nLin, 000, nLin, 3199)
	oPrint:SayBitmap( nLin+10,0030,aBmp,nLin+50,0100 )
EndIf
nLin += 110                           
oPrint:Say  (nLin   , 0030, "SIGA/RSFATR03/v.11"                                                                               , oFont04)
oPrint:Say  (nLin   , 2850, "Emissao:  " + DtoC(dDataBase)                                                                     , oFont04)
oPrint:Say  (nLin+50, 0030, "Hora: " +LEFT(TIME(),8) +" Empresa:  " +RTRIM(SM0->M0_NOME)+" /Filial: "+RTRIM(SM0->M0_FILIAL)    , oFont04)
oPrint:Say  (nLin+50, 2850, "Pag:      " + Str(_nPag)                                                                          , oFont04)
oPrint:Say  (0180+50, 1100, "Relatorio de Rastreamento de Lote - " +ALLTRIM(mv_par01)+"  a  "+ALLTRIM(mv_par02)+" Periodo: "+dtoc(mv_par07)+" a "+dtoc(mv_par08)              , oFont14n)


nLin += 100

oPrint:Line (nLin + 030,  010, nLin + 030, 3199)
oPrint:Line (nLin + 030,  010, nLin + 100, 0010)
oPrint:Line (nLin + 030, 3199, nLin + 100, 3199)
oPrint:Line (nLin + 100,  010, nLin + 100, 3199)

oPrint:Say  (nLin + 055, 030, "Cliente"     , oFont08n)
oPrint:Say  (nLin + 055, 1150, "Nota Fiscal", oFont08n)
oPrint:Say  (nLin + 055, 1410, "Data"       , oFont08n)
oPrint:Say  (nLin + 055, 1680, "Código"     , oFont08n)
oPrint:Say  (nLin + 055, 1880, "Descrição"  , oFont08n)
oPrint:Say  (nLin + 055, 2900, "Quantidade" , oFont08n)


nLin += 100

_lPriImp := .F.

_nPag++

Return


//-------------------------------------------------------------------
//  Ajusta o arquivo de perguntas SX1
//-------------------------------------------------------------------
Static Function CriaSx1(cPerg)

	u_HMPutSX1(cPerg, "01", PADR("Do Lote ",29)+"?"              ,"","", "mv_ch1" , "C", 21 , 0, 0, "G", "",   "", "", "", "mv_par01")
	u_HMPutSX1(cPerg, "02", PADR("Ate Lote ",29)+"?"             ,"","", "mv_ch2" , "C", 21 , 0, 0, "G", "",   "", "", "", "mv_par02")
   	u_HMPutSX1(cPerg, "03", PADR("Da NF ",29)+"?"                ,"","", "mv_ch3" , "C", 9  , 0, 0, "G", "",   "", "", "", "mv_par03")
	u_HMPutSX1(cPerg, "04", PADR("Ate NF ",29)+"?"               ,"","", "mv_ch4" , "C", 9  , 0, 0, "G", "",   "", "", "", "mv_par04")
	u_HMPutSX1(cPerg, "05", PADR("Do Cliente ",29)+"?"           ,"","", "mv_ch5" , "C", 6  , 0, 0, "G", "","SA1", "", "", "mv_par05")
	u_HMPutSX1(cPerg, "06", PADR("Ate Cliente ",29)+"?"          ,"","", "mv_ch6" , "C", 6  , 0, 0, "G", "","SA1", "", "", "mv_par06")
	u_HMPutSX1(cPerg, "07", PADR("Da Data ",29)+"?"              ,"","", "mv_ch7" , "D", 8  , 0, 0, "G", "",   "", "", "", "mv_par07")
	u_HMPutSX1(cPerg, "08", PADR("Ate Data ",29)+"?"             ,"","", "mv_ch8" , "D", 8  , 0, 0, "G", "",   "", "", "", "mv_par08")	

Return Nil
