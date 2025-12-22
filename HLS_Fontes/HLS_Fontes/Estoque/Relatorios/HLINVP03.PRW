#INCLUDE "rwmake.ch"
#INCLUDE "colors.ch"

//#define DMPAPER_LETTER      1           /* Letter 8 1/2 x 11 in             */
//#define DMPAPER_LETTERSMALL 2           /* Letter Small 8 1/2 x 11 in         */
//#define DMPAPER_TABLOID     3           /* Tabloid 11 x 17 in                 */
//#define DMPAPER_LEDGER      4           /* Ledger 17 x 11 in                  */
//#define DMPAPER_LEGAL       5           /* Legal 8 1/2 x 14 in                */
//#define DMPAPER_STATEMENT s  6           /* Statement 5 1/2 x 8 1/2 in         */
//#define DMPAPER_EXECUTIVE   7           /* Executive 7 1/4 x 10 1/2 in        */
//#define DMPAPER_A3          8           /* A3 297 x 420 mm                    */
//#define DMPAPER_A4          9           /* A4 210 x 297 mm                    */
//#define DMPAPER_A4SMALL     10          /* A4 Small 210 x 297 mm              */
//#define DMPAPER_A5          11          /* A5 148 x 210 mm                    */
//#define DMPAPER_B4          12          /* B4 250 x 354                       */
//#define DMPAPER_B5          13          /* B5 182 x 257 mm                    */
//#define DMPAPER_FOLIO       14          /* Folio 8 1/2 x 13 in                */
//#define DMPAPER_QUARTO      15          /* Quarto 215 x 275 mm                */
//#define DMPAPER_10X14       16          /* 10x14 in                           */
//#define DMPAPER_11X17       17          /* 11x17 in                           */
//#define DMPAPER_NOTE        18          /* Note 8 1/2 x 11 in                 */
//#define DMPAPER_ENV_9       19          /* Envelope #9 3 7/8 x 8 7/8          */
//#define DMPAPER_ENV_10      20          /* Envelope #10 4 1/8 x 9 1/2         */
//#define DMPAPER_ENV_11      21          /* Envelope #11 4 1/2 x 10 3/8        */
//#define DMPAPER_ENV_12      22          /* Envelope #12 4 \276 x 11           */
//#define DMPAPER_ENV_14      23          /* Envelope #14 5 x 11 1/2            */
//#define DMPAPER_CSHEET      24          /* C size sheet                       */
//#define DMPAPER_DSHEET      25          /* D size sheet                       */
//#define DMPAPER_ESHEET      26          /* E size sheet                       */
//#define DMPAPER_ENV_DL      27          /* Envelope DL 110 x 220mm            */
//#define DMPAPER_ENV_C5      28          /* Envelope C5 162 x 229 mm           */
//#define DMPAPER_ENV_C3      29          /* Envelope C3  324 x 458 mm          */
//#define DMPAPER_ENV_C4      30          /* Envelope C4  229 x 324 mm          */
//#define DMPAPER_ENV_C6      31          /* Envelope C6  114 x 162 mm          */
//#define DMPAPER_ENV_C65     32          /* Envelope C65 114 x 229 mm          */
//#define DMPAPER_ENV_B4      33          /* Envelope B4  250 x 353 mm          */
//#define DMPAPER_ENV_B5      34          /* Envelope B5  176 x 250 mm          */
//#define DMPAPER_ENV_B6      35          /* Envelope B6  176 x 125 mm          */
//#define DMPAPER_ENV_ITALY   36          /* Envelope 110 x 230 mm              */
//#define DMPAPER_ENV_MONARCH 37          /* Envelope Monarch 3.875 x 7.5 in    */
//#define DMPAPER_ENV_PERSONAL 38         /* 6 3/4 Envelope 3 5/8 x 6 1/2 in    */
//#define DMPAPER_FANFOLD_US  39          /* US Std Fanfold 14 7/8 x 11 in      */
//#define DMPAPER_FANFOLD_STD_GERMAN  40  /* German Std Fanfold 8 1/2 x 12 in   */
//#define DMPAPER_FANFOLD_LGL_GERMAN  41  /* German Legal Fanfold 8 1/2 x 13 in */
//#define DMPAPER_USER        256              
#define CWCOLFIM  2900
#define NQTLINHA   22


/*/{protheus.doc}HLINVP03
Impressão de Cartelas 
@author Diego Rafael 
@since 18/12/2009
/*/
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PLESTR04   ¦ Autor ¦ Diego Rafael         ¦ Data ¦ 18/12/2009 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Impressão de Cartelas                                      	¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function HLINVP03()

Local nOpcao   := 0
Local aSay     := {}
Local aButton  := {}
Local cDesc1   := OemToAnsi("Impressão das Cartelas das Contagens")
Local cDesc2   := OemToAnsi("")
Local oObj     := Nil
Private cTitulo := OemToAnsi("Cartelas")
Private lEnd   := .F.
Private cPerg  := PadR("PLCARTR04",10)
Private lExp   := .F.

//axcadastro("SZ4")
//axcadastro("SZ5")

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )

aAdd(aButton, { 5,.T.,{|| Pergunte(cPerg,.T.) } } )
aAdd(aButton, { 1,.T.,{|oObj| nOpcao := 1,oObj:oWnd:End() } } )
aAdd(aButton, { 2,.T.,{|oObj| oObj:oWnd:End() }} )

FormBatch( cTitulo, aSay, aButton )

if nOpcao == 1
	RunImpress()
Endif

Return Nil


Static Function RunImpress()

Local aCabecI  := {}
Local aCabecC  := {}
Local aCabecT  := {}
Local aAuxI    := {}
Local aAuxC    := {}
Local aCont1   := {}
Local aCont2   := {}
Local cTitulo  := ""
Local lId      := .F.
Local cCartela := ""
Local nCol1    := 70
Local nCol2    := 1800
Local nLinha   := "01"   
Local nTotal := ""

Private oPrint   := Nil
Private nwPag  := 1            

// wermeson em 18/02/10
If mv_par10 == 1
//	fGerCart()
EndIf

aAdd(aCabecI,{"LN"           ,0010,0000})
aAdd(aCabecI,{"P.N."         ,0250,0070})
aAdd(aCabecI,{"Descrição" ,0700,0460})
aAdd(aCabecI,{"Tipo"          ,1300,1290})
aAdd(aCabecI,{"Grupo"       ,1400,1380})
aAdd(aCabecI,{"Obs"          ,1900,1880})
aAdd(aCabecI,{"Arm."        ,2400,2380})
aAdd(aCabecI,{"U. M."        ,2500,2480})   
aAdd(aCabecI,{"Quantidade",2600,2580})   


/*aAdd(aCabecC,{"LIN"         ,0017,0000})
aAdd(aCabecC,{"P.N."        ,0270,0070})
aAdd(aCabecC,{"U.M."        ,0500,0470})
aAdd(aCabecC,{"Quantidade"  ,0900,0590})
  */
aAdd(aCabecT,{"Total"       ,0270,0000})
aAdd(aCabecT,{"      "      ,0850,0590})

aAuxI := aClone(aCabecI)
//aAuxC := aClone(aCabecC)

aCont1 := CleanPos(aClone(aCabecI))
//aCont2 := CleanPos(aClone(aCabecC))


aAuxI[02][02] := 0090
aAuxI[03][02] := 0480
aAuxI[04][02] := 1310
aAuxI[05][02] := 1410
aAuxI[06][02] := 1910
aAuxI[07][02] := 2410
aAuxI[08][02] := 2510
aAuxI[09][02] := 2610             
         

/*aAdd(aCabecI,{"LIN"           ,0020,0000})
aAdd(aCabecI,{"P.N."         ,0250,0070})
aAdd(aCabecI,{"Descrição" ,0690,0460})
aAdd(aCabecI,{"Tipo"          ,1090,1060})
aAdd(aCabecI,{"Grupo"       ,1190,1160})
aAdd(aCabecI,{"Desc. Grp" ,1350,1360})
aAdd(aCabecI,{"Armazém" ,1700,1700})
aAdd(aCabecI,{"U. M."       ,1800,1800})   
aAdd(aCabecI,{"Quantidade",1900,1900})   
  */
/*aAuxC[02][02] := 0090
aAuxC[03][02] := 0500
aAuxC[04][02] := 0610
  */
if mv_par09 = 01
	cTitulo := "1ª Contagem"
elseif mv_par09 = 02
	cTitulo := "2ª Contagem"
elseif mv_par09 = 03
	cTitulo := "3ª Contagem"
EndIf

oPrint := TMSPrinter():New("CARTELA")
//if mv_par09 = 1
  //	oPrint:SetLandScape()
//else
 //	oPrint:SetSize(150,210)
	oPrint:SetLandScape()
//EndIf

oFont08  := TFont():New("Arial",       9, 8, .T., .F., 5, .T., 5, .T., .F.)
oFont08n := TFont():New("Arial",       9, 8, .T., .T., 5, .T., 5, .T., .F.)
oFont09  := TFont():New("Arial",       9,  9, .T., .F., 5, .T., 5, .T., .F.)
oFont09n := TFont():New("Arial",       9,  9, .T., .T., 5, .T., 5, .T., .F.)
oFont10  := TFont():New("Arial",       9, 10, .T., .F., 5, .T., 5, .T., .F.)
oFont10n := TFont():New("Arial",       9, 10, .T., .T., 5, .T., 5, .T., .F.)
oFont24  := TFont():New("Arial",       9, 19, .T., .F., 5, .T., 5, .T., .F.)
oBrush   := TBrush():New("",4)

MountTable()   

 
If DROR->(EOF())
	Aviso("ERRO","Sem Dados a Exibir",{"Ok"},3)
	DROR->(dbCLoseArea("DROR"))  
	Return Nil
EndIF

While( !DROR->(EOF()) )
	
	oPrint:StartPage()
   
	cCartela := DROR->Z4_NUM
	cAnoMes  := SubStr(DROR->Z4_DATA,5,2)+"/"+SubStr(DROR->Z4_DATA,1,4)
//	if mv_par09 = 01
		nLin1 := PrintCabec(nCol1,cTitulo,{cAnoMes,DROR->Z4_NUM,DROR->Z4_OBS, DROR->Z4_AREA, DROR->Z4_FILIAL},DROR->Z4_AREA, nwPag)
		nLin1 := PrintItens(nLin1,nCol1,aCabecI,oFont09n)         
		nLin2 := nLin1
// 		nLin2 := PrintCabec(nCol2,cTitulo,{cAnoMes,DROR->Z4_NUM,DROR->Z4_OBS,DROR->Z4_AREA, DROR->Z4_FILIAL})
//		nLin2 := PrintItens(nLin2,nCol2,aCabecC,oFont09n)
 //	else
   /*		nCol2 := nCol1 + 500
		nLin2 := PrintCabec(nCol2,cTitulo,{cAnoMes,DROR->Z4_NUM,DROR->Z4_OBS,DROR->Z4_AREA, DROR->Z4_FILIAL})
		nLin2 := PrintItens(nLin2,nCol2,aCabecC,oFont09n)*/
   //	EndIF

	cLinha := "01"
//	nwPag := 1
	
	nTotal := 0
	
	While( !DROR->(EOF()) .And. cCartela = DROR->Z4_NUM) .And. Val(cLinha) <= NQTLINHA  
		
//		if mv_par09 = 1
		    cwLinha := Val(cLinha)  + ( (nwPag-1) * NQTLINHA  ) 
			aAuxI[01][01] := strzero(cwLinha, 3)
			aAuxI[02][01] := DROR->Z5_COD
			aAuxI[03][01] := SubStr( DROR->Z5_DESC, 1,30)
			aAuxI[04][01] := DROR->Z5_TIPO
			aAuxI[05][01] := DROR->Z5_DESCGRP           			
			aAuxI[06][01] := DROR->Z5_OBS     			
			aAuxI[07][01] := DROR->Z5_LOCAL      
            aAuxI[08][01] := DROR->Z5_UM       
            aAuxI[09][01] := ""
                        
		nLin1 := PrintItens(nLin1,nCol1,aAuxI,oFont09)
  //		EndIf
		
 /*		aAuxC[01][01] := cLinha
		aAuxC[02][01] := DROR->Z5_COD    
		aAuxC[03][01] := DROR->B1_UM
		aAuxC[04][01] := ""
		
		nLin2 := PrintItens(nLin2,nCol2,aAuxC,oFont09)      */
		
		DROR->(dbSkip())
		
		cLinha := Soma1(cLinha,3)
		
	EndDo
	 
  	If ( DROR->(EOF()) .Or. cCartela <> DROR->Z4_NUM) 

		//if mv_par09 = 1
			nLin1 := PrintLeft(nLin1,nCol1,aCont1,cLinha, nwPag)
	  //	EndIf
	//	nLin2 := PrintLeft(nLin2,nCol2,aCont2,cLinha)
		
		aCabecT[02][01] := ""
		
	 //	nLin1 := PrintItens(nLin1,nCol2,aCabecT,oFont09)
		
		nLin1 += 100
		
		oPrint:Line (nLin1 + 030, nCol1 + 150 , nLin1 + 030, nCol1 + 0630)
		oPrint:Say  (nLin1 + 055, nCol1 + 300 , "CONTADOR", oFont08n)
		
		oPrint:Line (nLin1 + 030, nCol1 + 800 , nLin1 + 030, nCol1 + 1350)
		oPrint:Say  (nLin1 + 055, nCol1 + 1000 , "SUPERVISOR", oFont08n)
	
		oPrint:Line (nLin1 + 030, nCol1 + 1500 , nLin1 + 030, nCol1 + 1950)
		oPrint:Say  (nLin1 + 055, nCol1 + 1700 , "DIGITADOR", oFont08n)    
		   nwPag:= 1
	 	Else   
	 	// vfv 
	 	nLin1 += 100
	 	oPrint:Line (nLin1 + 030, nCol1 + 150 , nLin1 + 030, nCol1 + 0630)
		oPrint:Say  (nLin1 + 055, nCol1 + 300 , "CONTADOR", oFont08n)
		
		oPrint:Line (nLin1 + 030, nCol1 + 800 , nLin1 + 030, nCol1 + 1350)
		oPrint:Say  (nLin1 + 055, nCol1 + 1000 , "SUPERVISOR", oFont08n)
	
		oPrint:Line (nLin1 + 030, nCol1 + 1500 , nLin1 + 030, nCol1 + 1950)
		oPrint:Say  (nLin1 + 055, nCol1 + 1700 , "DIGITADOR", oFont08n)    
	   	   //vfv
	   	   nwPag++                                                          
	   	   	
	EndIf 	
	
	oPrint:EndPage()
	
EndDo
DROR->(dbCloseArea("DROR"))
//oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

Return Nil
          
//----VFV
Static Function TotalZ5()
Local cQry1   := ""      
Local _SZ5   := RetSqlName("SZ5")
cQry1 += " Select count(*) TOT From " + RetSqlName("SZ5")
cQry1 += " Where D_E_L_E_T_ <> '*'
cQry1 += " And Z5_NUM = '" + DROR->Z4_NUM + "'"
cQry1 += " and Z5_FILIAL = '" + xFilial("SZ5") + "' "

MPSysOpenQuery( cQry1, "HLS1" ) // dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry1)),"HLS1",.T.,.F.)  

nTotal := round(HLS1->TOT/22,0)
Totall := nTotal
//HLS1->(dbCLoseArea("HLS1"))
//Return 
//-----VFV

Static Function PrintCabec(nCol,cTitulo,aDados, cwArea, nwPagina, nTotal)

//if mv_par09 =1
	nLin := 200
//else
 //	nLin := 650
//Endif

oPrint:SayBitmap(nLin-50,nCol + 20,"lgrl"+SM0->M0_CODIGO+".bmp", 370,130)
//oPrint:Say  (nLin - 50   , nCol + 1320, 'Filial - ' + aDados[05] , oFont24)      
oPrint:Say  (nLin - 50   , nCol + 1300, cwArea , oFont24)
oPrint:Say  (nLin - 50   , nCol + 2500, cTitulo , oFont24)

nLin += 100

oPrint:Box(nLin + 030,nCol + 0000 , nLin + 100 , nCol + CWCOLFIM)  //Imprime o Box Superior
//oPrint:Box(nLin + 0100,nCol + 0000 , nLin + 170 , nCol + CWCOLFIM) //Imprime o Box Inferior

oPrint:Say  (nLin + 055, nCol + 020 , "No Lista:", oFont10n)
oPrint:Say  (nLin + 055, nCol + 220  , aDados[02], oFont09n)

oPrint:Say  (nLin + 055, nCol + 1320  , "Data:", oFont10n)
oPrint:Say  (nLin + 055, nCol + 1500  , aDados[01], oFont09n)

//oPrint:Say  (nLin + 055, nCol + 2220  , ":", oFont08n)
oPrint:Say  (nLin + 055, nCol + 2500  ,"Pag.: " + StrZero(nwPagina, 3) + " / " + cValToChar(nTotal), oFont08n)  

/*oPrint:Say  (nLin + 125, nCol + 020  , "OBS:", oFont10n)
oPrint:Say  (nLin + 125, nCol + 200  , aDados[03], oFont09n)
oPrint:Say  (nLin + 125, nCol + 490  , "AREA:", oFont10n)
oPrint:Say  (nLin + 125, nCol + 750  , aDados[04], oFont09n)                                              
  */
//oPrint:Line (nLin + 030, 570, nLin + 170, 570)

nLin += 140

Return nLin
Return nTotal
	
Static Function PrintLeft(nLin,nCol,aInfo,cLinha, nwPagina)
nLinha := Val(cLinha)

for nLinha := Val(cLinha) to NQTLINHA 
	cwLinha := nLinha  + ( (nwPagina-1) * NQTLINHA  ) 
	
	aInfo[01][01] := StrZero(cwLinha,3)    

	nLin := PrintItens(nLin,nCol,aInfo,oFont09)
Next

Return nLin

Static Function PrintItens(nLin,nCol,aInfo,oFont)

oPrint:Box(nLin , nCol + 0000, nLin + 70,nCol + CWCOLFIM)

For nI := 1 to Len(aInfo)
	oPrint:Say(nLin + 010,nCol + aInfo[nI][02],aInfo[nI][01],oFont)
	oPrint:Line(nLin , nCol + aInfo[nI][03],nLin + 70,nCol + aInfo[nI][03])
Next

nLin += 070

Return nLin


Static Function ValidPerg(cPerg)

PutSX1(cPerg, "01", "Numero De?" ,"Numero De ?","Numero De"   , "mv_ch1", "C",10, 0, 0, "G", "", "", "", "", "mv_par01")
PutSX1(cPerg, "02", "Numero Ate?","Numero ATe?","Numero ATe?" , "mv_ch2", "C",10, 0, 0, "G", "", "", "", "", "mv_par02")

PutSX1(cPerg, "03", "Armazen De?" ,"Armazen De ?","Armazen De"   , "mv_ch3", "C",2, 0, 0, "G", "", "", "", "", "mv_par03")
PutSX1(cPerg, "04", "Armazen Ate?","Armazen ATe?","Armazen ATe?" , "mv_ch4", "C",2, 0, 0, "G", "", "", "", "", "mv_par04")

PutSX1(cPerg, "05", "Endereço De?" ,"Endereço De ?","Endereço De"   , "mv_ch5", "C",15, 0, 0, "G", "", "", "", "", "mv_par05")
PutSX1(cPerg, "06", "Endereço Ate?","Endereço ATe?","Endereço ATe?" , "mv_ch6", "C",15, 0, 0, "G", "", "", "", "", "mv_par06")

PutSX1(cPerg, "07", "Mes/Ano De?" ,"Mes/Ano De ?","Mes/Ano De"   , "mv_ch7", "C",2, 0, 0, "G", "", "", "", "", "mv_par07")
PutSX1(cPerg, "08", "Mes/Ano Ate?","Mes/Ano ATe?","Mes/Ano ATe?" , "mv_ch8", "C",2, 0, 0, "G", "", "", "", "", "mv_par08")

PutSX1(cPerg, "09", "Contagem ?","Contagem ? ","Contagem?" , "mv_ch9", "N",1, 0, 0, "C", "", "", "", "", "mv_par09",;
"Primeira ","Primeira","Primeira","","Segunda","Seguna","Segunda","Terceira","Terceira","Terceira","","","","","","","","","","")

PutSX1(cPerg, "10", "Gerar Cartelas?","Gerar Cartelas? ","Gerar Cartelas?","mv_cha", "N",1, 0, 0, "C", "", "", "", "", "mv_par10",;
"Sim","Sim","Sim","","Não","Não","Não","","","","","","","","","","","","","")


Return Nil      

Static Function MountTable()

Local cQry := ""
Local _SZ4 := RetSqlName("SZ4")
Local _SZ5 := RetSqlName("SZ5")
Local _SB1 := RetSqlName("SB1")
// Query Oficial
cQry += " Select * From " + _SZ4 + " Z4 "
cQry += " Left Outer Join ( Select * From SZ5010 Z51
cQry += "                   Left Outer Join (Select B1_COD,B1_UM,B1_DESCHL From SB1010 Where D_E_L_E_T_ <> '*'
cQry += "                                    )B1 on Z5_COD    = B1_COD
cQry += "                     Where Z51.D_E_L_E_T_  <> '*'
cQry += 								" AND Z5_FILIAL = '" + xFilial("SZ5") +"' "
cQry += "                  )Z5 on Z5_FILIAL = Z4_FILIAL
cQry += "                     And Z5_NUM    = Z4_NUM
cQry += " Where Z4.D_E_L_E_T_ =  ' ' "
cQry += "   AND Z4_FILIAL  = '"+xFilial("SZ4")+"' "       
cQry += "   And Z4_NUM BetWeen '" + mv_par01 + "' And '" + mv_par02 + "'
cQry += "   And Z4_OBS BetWeen '" + mv_par03 + "' And '" + mv_par04 + "'
//cQry += "   And Z4_OBSIZ BetWeen '" + mv_par05 + "' And '" + mv_par06 + "'
cQry += "   And SUBSTRING(Z4_DATA,1,6) BetWeen '" + mv_par07 + "' And '" + mv_par08 + "'
//cQry += "   And Z4_STATUS <> 0 And Z4_STATUS <> 7
cQry += "   And Z4_STATUS <> 7

If (mv_par09 = 2)
//	cQry += " And isNull(Z5_DIRV1,'D') = 'D' "
elseif (mv_par09 = 3)
 //	cQry += " And isNull(Z5_DIRV1,'D') = 'D' "
	cQry += " And isNull(Z5_DIRV2,'D') = 'D' "
EndIf

cQry += " Order by Z4_NUM, Z5.R_E_C_N_O_

Memowrit("PLESTR04.SQL",cQry)

MPSysOpenQuery( cQry, "DROR" ) // dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "DROR", .T., .F. )

Return Nil

Static Function CleanPos(aVet)
For nI := 1 to Len(aVet)
	aVet[nI][01] := ""
Next
Return aVet



Static Function fGerCart()

Local cQry  := ""
Local nTipo := 0

//Geração da Cartela
cQry += " SELECT B2_FILIAL, B1_GRUPO, B2_LOCAL, B2_COD, B1_DESCHL, SUM(B2_QATU) AS B2_QATU "
cQry += "   FROM "+RetSqlName("SB1")+" D, " +RetSqlName("SB2")+" A "
cQry += "   LEFT JOIN (SELECT Z4_OBS, Z4_AREA, Z5_COD
cQry += "  			      FROM "+RetSqlName("SZ4")+" A, "+RetSqlName("SZ5")+" B
cQry += "  			     WHERE A.D_E_L_E_T_ = ''
cQry += "  			       AND B.D_E_L_E_T_ = ''
cQry += "  				    AND Z4_FILIAL    = Z5_FILIAL
cQry += "  				    AND SUBSTRING(Z4_DATA,1,6) = '" +SubStr( dTos( dDataBase ),1,6 )+ "' "
cQry += "  				    AND Z4_NUM       = Z5_NUM ) B "
cQry += "     ON A.B2_LOCAL   = B.Z4_LOCAL "
cQry += "    AND A.B2_COD = B.Z5_COD "
cQry += "  WHERE A.D_E_L_E_T_ = '' "
cQry += "    AND D.D_E_L_E_T_ = '' "
cQry += "    AND B2_FILIAL  = '"+xFilial("SB2")+"' "
cQry += "    AND B2_COD   = B1_COD "
cQry += "    AND B2_QATU <> 0 "
cQry += "    AND B.Z4_LOCAL IS NULL "
cQry += "    AND B2_LOCAL =  '06' "                                                                                                                       
cQry += "  GROUP BY B2_FILIAL, B1_GRUPO, B2_LOCAL, B2_COD, B1_DESCHL  "
cQry += "  ORDER BY B2_FILIAL, B1_GRUPO, B2_LOCAL, B2_COD, B1_DESCHL  "

MPSysOpenQuery( cQry, "WWW" ) // dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"WWW",.T.,.T.)

dbSelectArea("WWW")

While !WWW->(EOF())                                                                                                        
	cEnde := WWW->(B2_FILIAL + B1_GRUPO + B2_LOCAL)
	nTipo := 1
	While !WWW->(EOF()) .And. cEnde == WWW->(B2_FILIAL + B1_GRUPO + B2_LOCAL ) //.And. nTipo <= 20
		If nTipo == 1
			dbSelectARea("SZ4")                                                         
			RecLock("SZ4",.T.)
			SZ4->Z4_NUM     := U_fProxSZ4()
			SZ4->Z4_FILIAL  := WWW->B2_FILIAL           // xFilial("SZ4")   -  Aldrin, tem que gravar a filial do SBF
			SZ4->Z4_DATA    := dDataBase
			SZ4->Z4_STATUS  := "1"
			SZ4->(MsunLock())
		EndIf
		dbSelectARea("SZ5")
		RecLock("SZ5",.T.)
			SZ5->Z5_NUM     := SZ4->Z4_NUM
			SZ5->Z5_FILIAL  := SZ4->Z4_FILIAL
			SZ5->Z5_COD     := WWW->B2_COD
			SZ5->Z5_QTDE1   := -1
			SZ5->Z5_QTDE2   := -1
			SZ5->Z5_QTDE3   := -1
			SZ5->Z5_QATU    := WWW->B2_QATU
			SZ5->Z5_DESC    := WWW->B1_DESCHL
			SZ5->Z5_LOCAL   := WWW->B2_LOCAL
			SZ5->Z5_GRUPO   := WWW->B1_GRUPO  
		
		
		SZ5->(MsunLock())
		
		WWW->(dbSkip())
		
		nTipo++
		
	End
End
WWW->(dbCloseArea())

Return Nil   


