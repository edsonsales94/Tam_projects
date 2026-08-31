#INCLUDE "rwmake.ch"



User Function ECX010()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
setprvt("CPERG","GINSC","GEMISSAO","LI","estru","I","CABEC1","CABEC2","NLIN")
setprvt("IGNFE","IGSERIE","IGCUSTO","IGNCM","IGALIQ","CDESC1","CDESC2","CDESC3","TITULO","TITULO2")
setprvt("AORD","GNFE","GSERIE","GCUSTO","GNCM","GALIQ","GFORNEC","GCGC","CPICT","IMPRIME","GNOMECLI")
setprvt("CbTxt","lEnd","lAbortPrint","limite","TAMANHO","NOMEPROG","cbtxt","cbcont")
setprvt("GUND","GN","GCoponente","ASTRU","CONTFL","m_pag","NTIPO","aReturn","wnrel","cString","nLastKey","cTIPO")
setprvt("AREGTP0","AREGTP1","AREGTP2","AREGTP3","AREGTP4","AREGTP9","cIncEst","GDI","GADIDI","GDIITM")
//Private cString
aOrd 		   := {}
ASTRU          := {}
nEStru 		   := 0
IGSERIE        := ""
IGCUSTO        := 0
GN             := ""
IGNCM          := ""
IGALIQ         := ""
GNFE 		   := ""
IGNFE 		   := ""
GSERIE		   := ""
GINSC          := ""
GEMISSAO       := ""
GCUSTO		   := 0
IGNF           := SPACE(6)
GNCM           := ""
GALIQ		   := ""
GFORNEC		   := ""
GNOMECLI       := ""
GCGC           := ""
GUND		   := ""
GDI		   	   := ""
GADIDI		   := ""
GDIITM  	   := ""
estru          :={}
CbTxt          := ""
cDesc1         := "Este programa tem como objetivo imprimir relatorio "
cDesc2         := "de acordo com os parametros informados pelo usuario."
cDesc3         := "Relatorio de Estruturas"
cperg          := "ECX010"
cPict          := ""
lEnd           := .F.
lAbortPrint    := .F.
limite         := 220
tamanho        := "G"
cRodaTxt  	   := "REGISTRO(S)"
nCntImpr  	   := 0
nomeprog       := "ECX010" // Coloque aqui o nome do programa para impressao no cabecalho
nTipo          := 15
aReturn        := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
nLastKey       := 0
titulo         := "Athletic da Amazonia Industria e Com. Ltda"
titulo2        := "Relatorio de Estruturas"
nLin           := 0
Cabec1         := ""
Cabec2         := ""
cbtxt      	   := Space(10)
cbcont         := 00
CONTFL         := 01
m_pag          := 01
imprime        := .T.
wnrel          := "ECX010" // Coloque aqui o nome do arquivo usado para impressao em disco
ESTIM := {}
aRegDiv := {}
aRegs := {} 
aIncon := {}
VALOR := 0.01
I := 0

cString := "SG1"

//dbSelectArea("SG1")
//dbSetOrder(1)

/*
MV_PAR01 = CODIGO DO PRODUTO  15
MV_PAR02 = IDENTIFICAO DA SUFRAMA PPB   30
MV_PAR03 = SALARI OORDENADO 15
MV_PAR04 = ENCARGO SOCIAL TRABALHISTA    15
MV_PAR05 = TIPO DCR      01
MV_PAR06 = CPF DO REPRESENTANTE LEGAL    11
MV_PAR07 = TIPO DE COEFICIENTE DE REDUCAO F OU V   01
MV_PAR08 = CAMINHO  30  
MV_PAR09 = VALOR DO PA
*/

dbSelectArea("SX1")
dbSetOrder(1)
cPerg  :=  PADR(cPerg,   IIf(Alltrim(cVersao) == "MP8.11",6,10))

//            1     2      3                     4      5        6      7     8        9      10   11   12    13        14      15      16      17    18    19           20       21      22   23    24              25      26        27      28      29    30      31  32      33       34    35    36    37      38       39
//          Grupo/Ordem/Pergunta/              PerEsp/PerIng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/     Def01/DefEs01/Defeng01/Cnt01/Var02/Def02/        DefEs02/Defeng02/Cnt02/Var03/Def03/         DefEs03/Defeng03/DefEs03/Defeng03/Cnt03/Var04/Def04/DefEs04/Defeng04/Cnt04/Var05/Def05/DefEs05/Defeng05/Cnt05
aAdd(aRegs,{cPerg,"01"  ,"COD PRODUTO DE  ?   ","",    ""    ,"mv_ch1","C"  ,15    ,00     ,0     ,"G",""   ,"mv_par01",""    ,""    ,""      ,""   ,""    ,""           ,""    ,""      ,""    ,""   ,""           ,""     ,""     ,""     ,""      ,""   ,""   ,""    ,""    ,""      ,""   ,""   ,""   ,""     ,"SB1DCR"})
aAdd(aRegs,{cPerg,"02"  ,"IDENTIF. DA SUFR.?  ","",    ""    ,"mv_ch2","C"  ,80    ,00     ,0     ,"G",""   ,"mv_par02",""    ,""    ,""      ,""   ,""    ,""           ,""    ,""      ,""    ,""   ,""           ,""     ,""     ,""     ,""      ,""   ,""   ,""    ,""    ,""      ,""   ,""   ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"03"  ,"SALARI ORDENADO  ?  ","",    ""    ,"mv_ch3","N"  ,15    ,02     ,0     ,"G",""   ,"mv_par03",""    ,""    ,""      ,""   ,""    ,""           ,""    ,""      ,""    ,""   ,""           ,""     ,""     ,""     ,""      ,""   ,""   ,""    ,""    ,""      ,""   ,""   ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"04"  ,"ENC. SOCIAL TRAB. ? ","",    ""    ,"mv_ch4","N"  ,15    ,02     ,0     ,"G",""   ,"mv_par04",""    ,""    ,""      ,""   ,""    ,""           ,""    ,""      ,""    ,""   ,""           ,""     ,""     ,""     ,""      ,""   ,""   ,""    ,""    ,""      ,""   ,""   ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"05"  ,"TIPO DCR ?          ","",    ""    ,"mv_ch5","N"  ,01    ,00     ,0     ,"C",""   ,"mv_par05","NOVO",""    ,""      ,""   ,""    ,"RETIFICADOR",""    ,""      ,""    ,""   ,"SUBSTITUIDO",""     ,""     ,""     ,""      ,""   ,""   ,""    ,""    ,""      ,""   ,""   ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"06"  ,"CPF REPRESENTANTE ? ","",    ""    ,"mv_ch6","C"  ,15    ,00     ,0     ,"G",""   ,"mv_par06",""    ,""    ,""      ,""   ,""    ,""           ,""    ,""      ,""    ,""   ,""           ,""     ,""     ,""     ,""      ,""   ,""   ,""    ,""    ,""      ,""   ,""   ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"07"  ,"TP COEFICIENTE RED.?","",    ""    ,"mv_ch7","N"  ,01    ,00     ,0     ,"C",""   ,"mv_par07","FIXO",""    ,""      ,""   ,""    ,"VARIAVEL   ",""    ,""      ,""    ,""   ,""           ,""     ,""     ,""     ,""      ,""   ,""   ,""    ,""    ,""      ,""   ,""   ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"08"  ,"CAMINHO ?           ","",    ""    ,"mv_ch8","C"  ,30    ,00     ,0     ,"G",""   ,"mv_par08","    ",""    ,""      ,""   ,""    ,"           ",""    ,""      ,""    ,""   ,"           ",""     ,""     ,""     ,""      ,""   ,""   ,""    ,""    ,""      ,""   ,""   ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"09"  ,"Valor do produto ?  ","",    ""    ,"mv_ch9","N"  ,15    ,02     ,0     ,"G",""   ,"mv_par09",""    ,""    ,""      ,""   ,""    ,""           ,""    ,""      ,""    ,""   ,""           ,""     ,""     ,""     ,""      ,""   ,""   ,""    ,""    ,""      ,""   ,""   ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"10"  ,"Imp rel. Conferenc.?","",    ""    ,"mv_cha","N"  ,01    ,00     ,0     ,"C",""   ,"mv_par10","SIM ",""    ,""      ,""   ,""    ,"NAO        ",""    ,""      ,""    ,""   ,""           ,""     ,""     ,""     ,""      ,""   ,""   ,""    ,""    ,""      ,""   ,""   ,""   ,""     ,""})
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString
Private cPerg       := "ECX010"
Private oGeraTxt

Private cString := "SB1"

dbSelectArea("SB1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,390 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " SB1                                                           "

@ 60,098 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 60,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return



Static Function OkGeraTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



Private nHdl    := fCreate(mv_par08)

Private cEOL    := "CHR(13)+ CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+mv_par08+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

Processa({|| RunCont() },"Gerando arquivo DCR")
Return




Static Function RunCont

Local nTamLin, cLin, cCpo, nOrdem


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀLýô9ý¿
//³Gerçao do registo tipo 0 - Informações gerais de um DCR³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀLýô9ýÙ

nTamLin := 351
cLin    := Space(nTamLin)+cEOL

dbSelectArea("SM0")
dbSelectArea("SB1")
dbSetOrder(1)
DBSEEK(XFILIAL()+MV_PAR01)

TIPO := "0"


cCpo := PADR(TIPO,01)
cLin := Stuff(cLin,01,01,cCpo)
cCpo := PADR(SM0->M0_CGC,14) 
cLin := Stuff(cLin,02,14,cCpo)
cCpo := PADR(MV_PAR06,11)
cLin := Stuff(cLin,16,11,cCpo)
cCpo := PADR(MV_PAR02,80)
cLin := Stuff(cLin,27,80,cCpo)
cCpo := PADR(SB1->B1_DESC,80)
cLin := Stuff(cLin,107,80,cCpo)
cCpo := PADR(SB1->B1_POSIPI,08)
cLin := Stuff(cLin,187,08,cCpo)
cCpo := PADR(SB1->B1_UM,80)
cLin := Stuff(cLin,195,80,cCpo)
cCpo := Strzero((SB1->B1_PESBRU*100000),14)
cLin := Stuff(cLin,275,14,cCpo)
cCpo := StrZERO((MV_PAR03*100),15)
cLin := Stuff(cLin,289,15,cCpo)
cCpo := StrZERO((MV_PAR04*100),15)
cLin := Stuff(cLin,304,15,cCpo)
//cCpo := PADR(IIF(MV_PAR07=1,"F","V"),01)
//cLin := Stuff(cLin,319,01,cCpo)
cCpo := PADR(IIF(MV_PAR05=1,"N",IIF(MV_PAR05=2,"R","S")),01)
cLin := Stuff(cLin,319,01,cCpo)
cCpo := PADL(IIF(MV_PAR05=1,"          ",SB1->B1_DCRE),10,"0")
cLin := Stuff(cLin,320,10,cCpo)
cCpo := PADR("                 ",17)
cLin := Stuff(cLin,330,17,cCpo)
cCpo := PADR("    ",04)
cLin := Stuff(cLin,347,04,cCpo)
cCpo := PADR("2",01)
cLin := Stuff(cLin,351,01,cCpo)



//cLin := cLin + space(01)+CHR(13)//+CHR(10)

fWrite(nHdl,cLin)





//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro tipo 1 - Informações sobre modelos diferentes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TIPO := "1"
PRECO:= 0

nTamLin := 115
cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

cCpo := PADR(TIPO,01)
cLin := Stuff(cLin,01,01,cCpo)
cCpo := PADR("0001",04)
cLin := Stuff(cLin,02,04,cCpo)
cCpo := PADR(SB1->B1_DESC,80)
cLin := Stuff(cLin,06,80,cCpo)
cCpo := Strzero((MV_PAR09*100),15)
cLin := Stuff(cLin,86,15,cCpo)
cCpo := PADR(SB1->B1_COD,15)
cLin := Stuff(cLin,101,15,cCpo)

//cLin := cLin + space(01)+CHR(13)//+CHR(10)

fWrite(nHdl,cLin)

//SetRegua(RecCount())


aStru := Estrut(MV_PAR01)

cTIPO := "N"
DbSelectArea("SD1")
cIndex  := CriaTrab(nil,.F.)
cKey    := "D1_FILIAL+D1_COD+DTOS(D1_EMISSAO)"
cFilter := DbFilter()
cFilter := 'D1_FILIAL=="'+xFilial('SD1')+'".And. SD1->D1_TIPO == "'+CTIPO+'"'

IndRegua("SD1",cIndex,cKey,,cFilter,"Selecionando Registros...")
DbGoTop()

ProcRegua(LEN(aStru))

FOR I := 1 TO LEN(aStru)
	lValida := .T.
	IncProc()
	DbselectArea("SG1")
	DBSETORDER(1)
	dbGoTop()
	DbSeek(xFilial("SG1")+aStru[i,3])
	If !found()
		
		DbselectArea("SG1")
		DBSETORDER(1)
		dbGoTop()
		DbSeek(xFilial("SG1")+aStru[i,2]+aStru[i,3])
		
		GCoponente := subs(sg1->g1_comp,1,10)
		GN :=aStru[i,1]
		DbSelectArea("SB1")
		DbSetOrder(1) //Descricao do Item
		DbSeek(Xfilial()+aStru[i,3])
		GDESC := SUBS(SB1->B1_DESC,1,36)
		GNCM   :=SB1->B1_POSIPI
		GALIQ  :=SB1->B1_IPI
		GUND   :=SB1->B1_UM
		
		DbSelectArea("SD1")
		//DbSetorder (12) // FILIAL+CODIGO+EMISSAO
		DbSeek(xFilial()+aStru[i,3],.T.)
		WHILE !EOF("SD1").AND. (SD1->D1_COD == aStru[i,3]) //.AND. SD1->D1_TIPO == "N"
			DbSkip()
		END
		DbSelectArea("SD1")
		DBSKIP(-1)
		
		
		
		
		
		IF (SD1->D1_COD == aStru[i,3])
		
			If (SB1->B1_ORIGEM == "0" .or. SB1->B1_ORIGEM == "2")

				GDI     :=""//SD1->D1_DIDCRE
				GADIDI  :=""//SD1->D1_ADIC
				GDIITM  :=""//SD1->D1_DIIT			
				GNFE    :=SD1->D1_DOC
				GSERIE  :=SD1->D1_SERIE
				GCUSTO  :=SD1->D1_Vunit 
				GFORNEC := SD1->D1_FORNECE
				GLOJA   := SD1->D1_LOJA
		   		//GEMISSAO:= DTOS(SD1->D1_EMISSAO)
		   		//GEMISSAO:= (STR(DAY(SD1->D1_EMISSAO))+ALLTRIM(STR(MONTH(SD1->D1_EMISSAO)))+ALLTRIM(STR(YEAR(SD1->D1_EMISSAO))))
		   		DIA :=  SUBSTR(DTOS(SD1->D1_EMISSAO),7,2)
		   		MES :=  SUBSTR(DTOS(SD1->D1_EMISSAO),5,2)
				ANO :=  SUBSTR(DTOS(SD1->D1_EMISSAO),1,4)	
				//GEMISSAO:= DIA+MES+ANO
				GEMISSAO:= ANO+MES+DIA 
				
			Else  

				GDI     :=""//SD1->D1_DIDCRE
				GADIDI  :=""//SD1->D1_ADIC
				GDIITM  :=""//SD1->D1_DIIT					
				GNFE    :=SD1->D1_DOC
				GSERIE  :=SD1->D1_SERIE
				GCUSTO  :=SD1->D1_Vunit 
				GFORNEC := SD1->D1_FORNECE
				GLOJA   := SD1->D1_LOJA
		   		//GEMISSAO:= DTOS(SD1->D1_EMISSAO)
		   		//GEMISSAO:= (STR(DAY(SD1->D1_EMISSAO))+ALLTRIM(STR(MONTH(SD1->D1_EMISSAO)))+ALLTRIM(STR(YEAR(SD1->D1_EMISSAO))))
		   		DIA :=  SUBSTR(DTOS(SD1->D1_DTDI),7,2)
		   		MES :=  SUBSTR(DTOS(SD1->D1_DTDI),5,2)
				ANO :=  SUBSTR(DTOS(SD1->D1_DTDI),1,4)	
				//GEMISSAO:= DIA+MES+ANO
				GEMISSAO:= ANO+MES+DIA 	   
				
			EndIf			
				
		ELSE
			GDI     :=""
			GADIDI  :=""
			GDIITM  :=""		
			GNFE     :=""
			GSERIE   :=""
			GCUSTO   :=0
			GNCM     :=""
			GALIQ    :=""
			GFORNEC  :=""
			GNOMECLI := ""
			GEMISSAO := ""
			GFORNEC  := ""
			GLOJA    :=""
		ENDIF
		
		
		DBSELECTAREA("SA2")
		DbSetOrder(1)
		DbSeek(xFilial()+GFORNEC+GLOJA)
		IF (SD1->D1_COD == aStru[i,3])  		
			GCGC     :=SA2->A2_CGC
			GINSC    :=SA2->A2_INSCR    
			GNOMECLI := SUBSTR(SA2->A2_NOME,1,40) 
		Else
			GCGC     := ""
			GINSC    := ""
			GNOMECLI := ""
		Endif
		
		cIncEst := ""
		
		// Retirada de caracter do campo Incr. Estadual
		
		For J := 1 to 18
			
			//if substr(GINSC,J,1) <> "." .and. substr(GINSC,J,1) <> "\" .and. substr(GINSC,J,1) <> "/" .and. substr(GINSC,J,1) <> "-" .and. substr(GINSC,J,1) <> "_" .and. substr(GINSC,J,1) <> " "
         //IF substr(GINSC,J,1) >= "1" .and. substr(GINSC,J,1) <= "9"
         IF IsDigit(substr(GINSC,J,1)) 
				cIncEst = cIncEst + substr(GINSC,J,1)
			endIF
			
		Next
		
        ENTRADA := GNFE 
        SAIDA := ""
      	//For J := 1 to 6
      	For J := 1 to 9
			
			//if substr(GINSC,J,1) <> "." .and. substr(GINSC,J,1) <> "\" .and. substr(GINSC,J,1) <> "/" .and. substr(GINSC,J,1) <> "-" .and. substr(GINSC,J,1) <> "_" .and. substr(GINSC,J,1) <> " "
			IF substr(ENTRADA,J,1) <> " " 
				SAIDA = SAIDA + substr(ENTRADA,J,1)
				
			endIF
			
		Next		
		GNFE := SAIDA 
		
		ENTRADA := GSERIE
        SAIDA := ""
      	For J := 1 to 3
			
			IF substr(ENTRADA,J,1) <> " " 
				SAIDA = SAIDA + substr(ENTRADA,J,1)
				
			endIF
			
		Next		
		GSERIE := SAIDA
		
		
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄrHñî¿
		//³GERAÇAO DO RELATORIO DE INCONSISTENCIA E FILTRO DOS REGISTROS COM ERRO.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄrHñîÙ
		
	   	DbSelectArea("SYE")    
	   	//DbSelectArea("SM2")
		//DbSetOrder(2)
		//DbSeek(DTOS(SD1->D1_EMISSAO))
		  
		DbSetOrder(1)             
		//DbSeek(xFilial()+DTOS(SD1->D1_EMISSAO))
		DbSeek(xFilial()+GEMISSAO)
		
		
		If (SG1->G1_FIM < dDatabase)
			
			aadd(aIncon,{1," ITEM " + aStru[i,3] + " VENCIDO NA ESTRUTURA DO PRODUTO "})
			lValida := .F.	
			
		ElseIf EMPTY(GNFE) .and. EMPTY(GEMISSAO)
			
			aadd(aIncon,{1," NÃO EXISTE ENTRADA PARA O PRODUTO " + aStru[i,3]})
			lValida := .F.
			
		elseif EMPTY(GCGC) .AND. SB1->B1_ORIGEM != "1"
			
			aadd(aIncon,{2,"CGC DO FORNECEDOR INVALIDO " + GFORNEC+" "+GLOJA+" P/ O PROD. "+aStru[i,3]})
			lValida := .F.
			
		elseif EMPTY(GNCM) .OR. GNCM < "0000000000"
			
			aadd(aIncon,{3," PRODUTO SEM NCM " + aStru[i,3]})
			lValida := .F.    

		elseif SB1->B1_ORIGEM == "1" .AND. EMPTY(GDI)
		//elseif SM2->M2_MOEDA2 == 0
			
			aadd(aIncon,{4," A NOTA FISCAL NUMERO " + GNFE + " NÃO POSSSUI A DI INFORMADA PARA O PRODUTO " + aStru[i,3] + " COM ORIGEM 1 NO CADASTRO DO PRODUTO"})
			lValida := .F.       

		elseif SB1->B1_ORIGEM == "1" .AND. EMPTY(GEMISSAO) 
		//elseif SM2->M2_MOEDA2 == 0
			
			aadd(aIncon,{4," A DATA DA DI " + "GDI" + " NÃO CADASTRADO NA NOTA FISCAL " + GNFE + " P/ PRODUTO " + aStru[i,3]})
			lValida := .F.   
			
		elseif (SB1->B1_ORIGEM == "0" .OR. SB1->B1_ORIGEM == "2") .AND. SYE->YE_VLCON_C == 0 
		//elseif SM2->M2_MOEDA2 == 0
			
			aadd(aIncon,{4," TAXA DO DOLAR DE VENDA NÃO CADASTRADO "+DIA+"/"+MES+"/"+ANO +" P/ PRODUTO " + aStru[i,3]})
			lValida := .F.      
			
		elseif SB1->B1_ORIGEM == "1"  .AND. SYE->YE_VLFISCA == 0 
		//elseif SM2->M2_MOEDA2 == 0
			
			aadd(aIncon,{4," TAXA DO DOLAR FISCAL NÃO CADASTRADO "+DIA+"/"+MES+"/"+ANO +" P/ PRODUTO " + aStru[i,3]})
			lValida := .F.
		
		elseif GCUSTO == 0 .AND. lValida
			
			aadd(aIncon,{4," VALOR DA NOTA "+GSERIE+" "+GNFE+" P/ PRODUTO " + aStru[i,3]})
			lValida := .F.
	   
		end
		
	
		
		
		
		IF lValida
			
			//IF sb1->B1_IMPORT != "S"      
			
			IF SB1->B1_ORIGEM = "0"
				
				xVetor := Ascan(ESTRU,{|x| x[3] = GCOPONENTE})
				
				
				If xVetor == 0
					//	AADD(aprod,{aStru[i,3],SG1->G1_QUANT})
					////////////1     2            3         4        5         6   7      8      9      10       11                12    13     14       15       
					AADD(ESTRU,{GN,SG1->G1_COD,GCOPONENTE,GDESC,SG1->G1_QUANT,GUND,GNFE,GSERIE,GNOMECLI,GCGC,GCUSTO/SYE->YE_VLCON_C,GNCM,GALIQ,GEMISSAO,cIncEst})
					//xVetor := LEN(aprod)
				else
					
					ESTRU[xVetor,5] := ESTRU[xVetor,5] + SG1->G1_QUANT
					
				endif
				
			Else
				
				xVetor := Ascan(ESTIM,{|x| x[3] = GCOPONENTE})
				
				
				If xVetor == 0
				
					If SB1->B1_ORIGEM == "1"

						////////////1     2            3         4        5         6   7      8    9      10        11               12   13     14       15          16         17					
						AADD(ESTIM,{GN,SG1->G1_COD,GCOPONENTE,GDESC,SG1->G1_QUANT,GUND, "" ,GADIDI,GNOMECLI,GCGC,GCUSTO/SYE->YE_VLFISCA,GNCM,GALIQ,GEMISSAO,cIncEst,SB1->B1_ORIGEM,GDIITM})

						////////////1     2            3         4        5         6   7      8    9      10        11               12   13     14       15          16         17					
						//AADD(ESTIM,{GN,SG1->G1_COD,GCOPONENTE,GDESC,SG1->G1_QUANT,GUND,GNFE,GSERIE,GNOMECLI,GCGC,GCUSTO/SYE->YE_VLCON_C,GNCM,GALIQ,GEMISSAO,cIncEst,SB1->B1_ORIGEM,GDIITM})

					else
										
						//	AADD(aprod,{aStru[i,3],SG1->G1_QUANT})
						////////////1     2            3         4        5         6   7      8    9      10        11               12   13     14       15          16         17
						AADD(ESTIM,{GN,SG1->G1_COD,GCOPONENTE,GDESC,SG1->G1_QUANT,GUND,GNFE,GSERIE,GNOMECLI,GCGC,GCUSTO/SYE->YE_VLCON_C,GNCM,GALIQ,GEMISSAO,cIncEst,SB1->B1_ORIGEM,GDIITM})
						//xVetor := LEN(aprod) 
					EndIf
				else
					
					ESTIM[xVetor,5] := ESTIM[xVetor,5] + SG1->G1_QUANT
					
				endif
				
			ENDIF
	   
		ENDIF
   
	endif
	
NEXT



nFimVet := Len(ESTRU)
TIPO := "2"
CONT := 0
FOR I := 1 to Len(estru)
	CONT := CONT + 1
	
	nTamLin := 255
	cLin    := Space(nTamLin)+cEOL

	cCpo := PADR(TIPO,01)
	cLin := Stuff(cLin,01,01,cCpo)
	cCpo := StrZERO(CONT,04)
	cLin := Stuff(cLin,02,04,cCpo)
	cCpo := PADL(ESTRU[I,7],10,"0")
	cLin := Stuff(cLin,06,10,cCpo)
	cCpo := PADL(IIF(EMPTY(ESTRU[I,8]),"00000",ESTRU[I,8]),05," ")
	cLin := Stuff(cLin,16,05,cCpo)
	cCpo := PADL(ESTRU[I,10],14,"0")
	cLin := Stuff(cLin,21,14,cCpo)
	cCpo := PADR(IIF(EMPTY(ESTRU[I,15]),"000000000000000",ESTRU[I,15]),15," ")
	cLin := Stuff(cLin,35,15,cCpo)
	cCpo := PADR(ESTRU[I,14],8)
	cLin := Stuff(cLin,50,08,cCpo)
	cCpo := PADR(ESTRU[I,4],80)
	cLin := Stuff(cLin,58,80,cCpo)
	cCpo := PADR(ESTRU[I,6],80)
	cLin := Stuff(cLin,138,80,cCpo)
	cCpo := PADL(ESTRU[I,12],08,"0")
	cLin := Stuff(cLin,218,08,cCpo)
	cCpo := StrZERO((ESTRU[I,5]*10000000),15)
	cLin := Stuff(cLin,226,15,cCpo)
	cCpo := StrZERO((ESTRU[I,11]*1000000),15)
	cLin := Stuff(cLin,241,15,cCpo)
	
	//	cLin := cLin + space(01)+CHR(13)//+CHR(10)
	
	fWrite(nHdl,cLin)
	
	
NEXT

FOR I := 1 to Len(ESTIM)
	
	TIPO := "4"
	
	nTamLin := 273
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao    
	
	CONT := CONT + 1
	
	If ESTIM[I,16] == "2"

		cCpo := PADR(TIPO,01)
		cLin := Stuff(cLin,01,01,cCpo)
		cCpo := StrZERO(CONT,04)
		cLin := Stuff(cLin,02,04,cCpo)
		cCpo := PADR("N",01)
		cLin := Stuff(cLin,06,01,cCpo)
		cCpo := PADR("S",01)
		cLin := Stuff(cLin,07,01,cCpo)
		cCpo := PADR("0000000000",10) // Numero da DI
		cLin := Stuff(cLin,08,10,cCpo)
		cCpo := PADR("000",03)    // Adicao da DI
		cLin := Stuff(cLin,18,03,cCpo)
		cCpo := PADR("00",02)    // Numero do item da adicao
		cLin := Stuff(cLin,21,02,cCpo)
		cCpo := PADL(ESTIM[I,7],10,"0")  // Numero da NF
		cLin := Stuff(cLin,23,10,cCpo)
		cCpo := PADL(ESTIM[I,8],05," ")  // Serie da Nota fiscal
		cLin := Stuff(cLin,33,05,cCpo)
 		cCpo := PADR(ESTIM[I,10],14)  // CNPJ Fornecedor
		//cCpo := PADR("02793710000141",14)
		cLin := Stuff(cLin,38,14,cCpo)
		cCpo := PADR(ESTIM[I,15],15)   //Inscr. Estadual Fornecedor   
		//cCpo := PADR("062001094",15," ")   //Inscr. Estadual Fornecedor
		cLin := Stuff(cLin,52,15,cCpo)
		cCpo := PADR(ESTIM[I,14],08)   //Emissao da NF
		cLin := Stuff(cLin,67,08,cCpo)
		cCpo := PADR(ESTIM[I,4],80)   // especificação do componente obrigatorio se for NF
		cLin := Stuff(cLin,75,80,cCpo)
   		cCpo := PADR(ESTIM[I,6],80)        //Unidde demedida
		cLin := Stuff(cLin,155,80,cCpo)
		cCpo := PADR(ESTIM[I,12],08)      // NCM
		cLin := Stuff(cLin,235,08,cCpo)
		cCpo := StrZERO((ESTIM[I,5]*10000000),15)     // Quantidade
		cLin := Stuff(cLin,243,15,cCpo)
		//cCpo := Strzero((ESTIM[I,13]*100),05)    // Aliquota
		//cLin := Stuff(cLin,254,05,cCpo)
		cCpo := PADR("N",01)              // Reducao
		cLin := Stuff(cLin,258,01,cCpo)
		//cCpo := StrZERO((MV_PAR09*1000000),15)          // Custo Unitário     
		cCpo := StrZERO((ESTIM[I,11]*1000000),15)
		cLin := Stuff(cLin,259,15,cCpo)

	Else   
	
		cCpo := PADR(TIPO,01)
		cLin := Stuff(cLin,01,01,cCpo)
		cCpo := StrZERO(CONT,04)
		cLin := Stuff(cLin,02,04,cCpo)
		cCpo := PADR("S",01)
		cLin := Stuff(cLin,06,01,cCpo)
		cCpo := PADR("S",01)
		cLin := Stuff(cLin,07,01,cCpo)
		cCpo := PADL(ESTIM[I,7],10,"0") // Numero da DI
		cLin := Stuff(cLin,08,10,cCpo)
		cCpo := PADL(ESTIM[I,8],03,"0")    // Adicao da DI
		cLin := Stuff(cLin,18,03,cCpo)
		cCpo := PADL(ESTIM[I,17],02,"0")    // Numero do item da adicao
		cLin := Stuff(cLin,21,02,cCpo)
		cCpo := PADR("0000000000",10,"0")  // Numer da Nota
		cLin := Stuff(cLin,23,10,cCpo)
		cCpo := PADR("     ",5," ")  // Serie da Nota fiscal
		cLin := Stuff(cLin,33,05,cCpo)
 		cCpo := PADR("              ",14," ")  // CNPJ Fornecedor
		//cCpo := PADR("02793710000141",14)		
		cLin := Stuff(cLin,38,14,cCpo)
		cCpo := PADR("               ",15," ")   //Inscr. Estadual Fornecedor
		cLin := Stuff(cLin,52,15,cCpo)    
		cCpo := PADR("00000000",8,"0")	 //Emissao da NF			
		//cCpo := PADR(ESTIM[I,14],08)   //Emissao da NF
		cLin := Stuff(cLin,67,08,cCpo)
		cCpo := PADR(ESTIM[I,4],80)   // especificação do componente obrigatorio se for NF
		cLin := Stuff(cLin,75,80,cCpo)
   		cCpo := PADR(SPACE(80),80)        //Unidde demedida
		cLin := Stuff(cLin,155,80,cCpo)
		cCpo := PADR("00000000",8,"0")      // NCM
		cLin := Stuff(cLin,235,08,cCpo)
		cCpo := StrZERO((ESTIM[I,5]*10000000),15)     // Quantidade
		cLin := Stuff(cLin,243,15,cCpo)
		//cCpo := Strzero((ESTIM[I,13]*100),05)    // Aliquota
		//cLin := Stuff(cLin,254,05,cCpo)
		cCpo := PADR("S",01)              // Reducao
		cLin := Stuff(cLin,258,01,cCpo)
		//cCpo := StrZERO((MV_PAR09*1000000),15)          // Custo Unitário     
		cCpo := StrZERO((ESTIM[I,11]*1000000),15)
		cLin := Stuff(cLin,259,15,cCpo)
	
	EndIf
		

	fWrite(nHdl,cLin)
	
	
NEXT


TIPO := 9

nTamLin := 09
cLin    := Space(nTamLin)+cEOL

CONT := CONT + 3
cCpo := PADR(TIPO,01)
cLin := Stuff(cLin,01,01,cCpo)
cCpo := StrZERO(CONT,08)
cLin := Stuff(cLin,02,08,cCpo)

fWrite(nHdl,cLin)

fClose(nHdl)
Close(oGeraTxt)

Processa({|| ImpresCo()},"Imprimindo!")

Return 

*****************
// Substituido pelo assistente de conversao do AP5 IDE em 16/05/00 ==> FUNCTION IMPRESCO
Static FUNCTION IMPRESCO()
*****************
cString:="SA1"
cDesc1:= OemToAnsi("Este programa tem como objetivo, imprimir as Inconsistencias")
cDesc2:= OemToAnsi("geradas na geração do arquivo de DCR")

limite         := 220
tamanho        := "G"
nTipo          := 15

aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="math005"
aLinha  := { }
nLastKey := 0

titulo      :="Inconsistencias Geradas"
cabec1      :="OS registros abaixo não foram inclusos no Arquivo"
//             12345678*123456*12345678901234*123456789012345*12*12345678901234
cabec2      :=""

cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag := 1  //Variavel que acumula numero da pagina

wnrel:="math005"            //Nome Default do relatorio em Disco
SetPrint(cString,wnrel,   ,titulo,cDesc1,cDesc2,cDesc3,.F.,"",   ,tamanho,,.F.) 

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Set Filter To
	Return
Endif

nLin := 80
*SetRegua(len(aIncon)) 

aIncon := Asort(aIncon,,,{|x,y|x[1]<y[1]})
CONT := 0
For I := 1 to len(aIncon)  
    CONT := CONT + 1
	If nLin > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho) 
		nLin:=9
	Endif
	@ nLin, 001 PSAY STR(CONT)+" "+aIncon[I][2]
	nLin := nLin + 1
Next

IF MV_PAR10 == 1   

titulo      :="Relatório De Conferencia da estrutura "+mv_par01
cabec1      :="Produto     Componente   Descricao                               Qtd    UND NF.ENTR SERIE  NOME DO FORNECEDOR            CCGC                INSC.EST.      CUSTO R$     NCM     ALIQ  EMISSAO"
//             12345678*123456*12345678901234*123456789012345*12*12345678901234
cabec2      :=""

nLin := 80
*SetRegua(len(estru)+len(ESTIM)) 

estru := Asort(estru,,,{|x,y|x[3]<y[3]}) 


For I := 1 to len(estru)
	If nLin > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho) 
		nLin:=9
	Endif
	
	If i = 1
		nLin := nLin + 1
      @ nLin,004 psay "Produtos Nacionais"
   	nLin := nLin + 1
	Endif
		//@ nLin,000 psay SUBSTR(estru[i,1],1,1) // Nivel
	@ nLin,001 psay SUBSTR(estru[i,2],1,10) // Produto
	@ nLin,015 PSAY SUBSTR(estru[I,3],1,10) // COMPONENTE
	@ nLin,027 PSAY subsTR(estru[I,4],1,36) //Descricao do COMPONENTE
	@ nLin,065 PSAY estru[I,5] PICTURE "@R 99.9999" // Qtd
	@ nLin,073 PSAY SUBSTR(estru[I,6],1,2) // UND
	@ nLin,076 PSAY subsTR(estru[I,7],1,9)//nf de entrada
	@ nLin,087 PSAY SUBSTR(estru[I,8],1,3) //Serie
	@ nLin,093 PSAY SUBSTR(estru[I,9],1,30) // FORNECEDOR
	@ nLin,125 PSAY estru[I,10]  PICTURE "@R 99.999.999/9999-99" //CGC
	@ nLin,144 PSAY SUBSTR(estru[I,15],1,12) // INSC.ESTADUAL
	@ nLin,156 PSAY Estru[I,11] PICTURE "9999,999.9999" // Custo R$  15
	@ nLin,171 PSAY SUBSTR(estru[I,12],1,10) //NCM
	@ nLin,181 PSAY estru[I,13] PICTURE "99"  // ALIQIPI
	@ nLin,185 PSAY estru[I,14] // DATA EMISSAO
	
	nLin := nLin + 1

Next

ESTIM := Asort(ESTIM,,,{|x,y|x[3]<y[3]}) 
nLin := nLin + 1
	@ nLin,004 psay "Produtos Importados"
	nLin := nLin + 1
For I := 1 to len(ESTIM)
	If nLin > 60
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho) 
		nLin:=9
	Endif
	
		//@ nLin,000 psay SUBSTR(estru[i,1],1,1) // Nivel
	@ nLin,001 psay SUBSTR(ESTIM[i,2],1,10) // Produto
	@ nLin,015 PSAY SUBSTR(ESTIM[I,3],1,10) // COMPONENTE
	@ nLin,027 PSAY subsTR(ESTIM[I,4],1,36) //Descricao do COMPONENTE
	@ nLin,065 PSAY ESTIM[I,5] PICTURE "@R 99.9999" // Qtd
	@ nLin,073 PSAY SUBSTR(ESTIM[I,6],1,2) // UND
	@ nLin,076 PSAY subsTR(ESTIM[I,7],1,9)//nf de entrada
	@ nLin,087 PSAY SUBSTR(ESTIM[I,8],1,3) //Serie
	@ nLin,093 PSAY SUBSTR(ESTIM[I,9],1,30) // FORNECEDOR   
	//	@ nLin,125 PSAY 02793710000141  PICTURE "@R 99.999.999/9999-99" //CGC
	@ nLin,125 PSAY ESTIM[I,10] PICTURE "@R 99.999.999/9999-99" //CGC
	@ nLin,144 PSAY SUBSTR(ESTIM[I,15],1,12) // INSC.ESTADUAL
	@ nLin,156 PSAY ESTIM[I,11] PICTURE"9999,999.99" // Custo R$  15
	@ nLin,171 PSAY SUBSTR(ESTIM[I,12],1,10) //NCM
	@ nLin,181 PSAY ESTIM[I,13] picture"99" // ALIQIPI
	@ nLin,185 PSAY ESTIM[I,14] // DATA EMISSAO

	nLin := nLin + 1
	
Next

ENDIF
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return
