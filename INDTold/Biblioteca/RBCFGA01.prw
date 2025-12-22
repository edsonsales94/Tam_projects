#INCLUDE "Font.ch"
#Include "Protheus.ch" 
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RBCFGA01 º Autor ³ Ronilton O. Barros º Data ³  29/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para geração de objetos para relatórios gráficos    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RBCFGA01
   Private cCadastro := "Relatorios Graficos"
   Private aRotina   := { { "Pesquisar" , "AxPesqui",0,1} ,;
                          { "Visualizar", "u_RBCFGCad",0,2} ,;
                          { "Incluir"   , "u_RBCFGCad",0,3} ,;
                          { "Alterar"   , "u_RBCFGCad",0,4} ,;
                          { "Excluir"   , "u_RBCFGCad",0,5} ,;
                          { "Gerar Rel.", "u_RBCFGPrint",0,6} ,;
                          { "Gerar Cod.", "u_RBCFGCodig",0,7} }
   Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
   Private cAlias1   := "DRW"
   Private cFilDRW

   dbSelectArea(cAlias1)
   dbSetOrder(1)
   mBrowse( 6,1,22,75,cAlias1)

Return

User Function RBCFGPrint(cAlias, nRecNo, nOpc)
   Private oPrn := TMSPrinter():New( "Relatório Gráfico" )

   DEFINE FONT oFont08B NAME "Arial" SIZE 0,08 Bold OF oPrn;	DEFINE FONT oFont08 NAME "Arial" SIZE 0,08 OF oPrn
   DEFINE FONT oFont09B NAME "Arial" SIZE 0,09 Bold OF oPrn;	DEFINE FONT oFont09 NAME "Arial" SIZE 0,09 OF oPrn
   DEFINE FONT oFont10B NAME "Arial" SIZE 0,10 Bold OF oPrn;	DEFINE FONT oFont10 NAME "Arial" SIZE 0,10 OF oPrn
   DEFINE FONT oFont11B NAME "Arial" SIZE 0,11 Bold OF oPrn;	DEFINE FONT oFont11 NAME "Arial" SIZE 0,11 OF oPrn
   DEFINE FONT oFont12B NAME "Arial" SIZE 0,12 Bold OF oPrn;	DEFINE FONT oFont12 NAME "Arial" SIZE 0,12 OF oPrn
   DEFINE FONT oFont14B NAME "Arial" SIZE 0,14 Bold OF oPrn;	DEFINE FONT oFont14 NAME "Arial" SIZE 0,14 OF oPrn
   DEFINE FONT oFont16B NAME "Arial" SIZE 0,16 Bold OF oPrn;	DEFINE FONT oFont16 NAME "Arial" SIZE 0,16 OF oPrn
   DEFINE FONT oFont20B NAME "Arial" SIZE 0,20 Bold OF oPrn;	DEFINE FONT oFont20 NAME "Arial" SIZE 0,20 OF oPrn
   DEFINE FONT oFont22B NAME "Arial" SIZE 0,22 Bold OF oPrn;	DEFINE FONT oFont22 NAME "Arial" SIZE 0,22 OF oPrn
   DEFINE FONT oFont36B NAME "Arial" SIZE 0,36 Bold OF oPrn;	DEFINE FONT oFont36 NAME "Arial" SIZE 0,36 OF oPrn
   DEFINE FONT oFont48B NAME "Arial" SIZE 0,48 Bold OF oPrn;	DEFINE FONT oFont48 NAME "Arial" SIZE 0,48 OF oPrn
   
   DEFINE FONT oFntCN08B NAME "Courier New" SIZE 0,08 Bold OF oPrn;	DEFINE FONT oFntCN08 NAME "Courier New" SIZE 0,08 OF oPrn
   DEFINE FONT oFntCN09B NAME "Courier New" SIZE 0,09 Bold OF oPrn;	DEFINE FONT oFntCN09 NAME "Courier New" SIZE 0,09 OF oPrn
   DEFINE FONT oFntCN10B NAME "Courier New" SIZE 0,10 Bold OF oPrn;	DEFINE FONT oFntCN10 NAME "Courier New" SIZE 0,10 OF oPrn
   DEFINE FONT oFntCN11B NAME "Courier New" SIZE 0,11 Bold OF oPrn;	DEFINE FONT oFntCN11 NAME "Courier New" SIZE 0,11 OF oPrn
   DEFINE FONT oFntCN12B NAME "Courier New" SIZE 0,12 Bold OF oPrn;	DEFINE FONT oFntCN12 NAME "Courier New" SIZE 0,12 OF oPrn
   DEFINE FONT oFntCN14B NAME "Courier New" SIZE 0,14 Bold OF oPrn;	DEFINE FONT oFntCN14 NAME "Courier New" SIZE 0,14 OF oPrn
   DEFINE FONT oFntCN16B NAME "Courier New" SIZE 0,16 Bold OF oPrn;	DEFINE FONT oFntCN16 NAME "Courier New" SIZE 0,16 OF oPrn
   DEFINE FONT oFntCN20B NAME "Courier New" SIZE 0,20 Bold OF oPrn;	DEFINE FONT oFntCN20 NAME "Courier New" SIZE 0,20 OF oPrn
   DEFINE FONT oFntCN22B NAME "Courier New" SIZE 0,22 Bold OF oPrn;	DEFINE FONT oFntCN22 NAME "Courier New" SIZE 0,22 OF oPrn
   DEFINE FONT oFntCN36B NAME "Courier New" SIZE 0,36 Bold OF oPrn;	DEFINE FONT oFntCN36 NAME "Courier New" SIZE 0,36 OF oPrn
   DEFINE FONT oFntCN48B NAME "Courier New" SIZE 0,48 Bold OF oPrn;	DEFINE FONT oFntCN48 NAME "Courier New" SIZE 0,48 OF oPrn


   DEFINE FONT oFontX  NAME "Arial" SIZE 0,09 Bold Italic Underline OF oPrn
   DEFINE FONT oFontY  NAME "Arial" SIZE 0,09 Bold OF oPrn

   oPrn:SETPORTRAIT()

   oPrn:StartPage()   // Inicia uma nova página
      Processa({|X| lEnd := X, Imprime(.T.) })
   oPrn:EndPage()     // Finaliza a página

   oPrn:Preview()     // Visualiza antes de imprimir

   oFont10:End()
   oFont11:End()
   oFont16:End()
   oFont20:End()
   oFont22:End()
   oFont36:End()

   DRW->(dbGoTo(nRecNo))
Return

User Function RBCFGCad(cAlias, nRecNo, nOpc)
Local nOpcA     := 0
Local oDlg      := Nil
Local oGet      := Nil

Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

cFilDRW := DRW->(XFILIAL("DRW"))

dbSelectArea("SX3")
dbSeek(cAlias1)
While !EOF() .And. X3_ARQUIVO == cAlias1
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .And. !(AllTrim(X3_CAMPO) $ "DRW_NUM,DRW_DESC")
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO    ,;
		               X3_PICTURE  ,;
		               X3_TAMANHO  ,;
		               X3_DECIMAL  ,;
		               X3_VALID    ,;
		               X3_USADO    ,;
		               X3_TIPO     ,;
		               X3_ARQUIVO  ,;
		               X3_CONTEXT  })
	Endif
	dbSkip()
End

If nOpc == 3
	M->DRW_NUM  := CriaVar("DRW_NUM")
	M->DRW_DESC := CriaVar("DRW_DESC")

	aAdd( aCOLS,Array(Len(aHeader)+1))
	
	dbSelectArea("SX3")
	dbSeek(cAlias1)
	nUsado:=0
	While !EOF() .And. X3_ARQUIVO == cAlias1
		IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .And. !(AllTrim(X3_CAMPO) $ "DRW_NUM,DRW_DESC")
			nUsado++
			IF X3_TIPO == "C"
				If Trim(aHeader[nUsado][2]) == "DRW_SEQ"
					aCOLS[1][nUsado] := StrZero(1,x3_tamanho)
				Else
					aCOLS[1][nUsado] := SPACE(x3_tamanho)
				Endif
			ELSEIF X3_TIPO == "N"
				aCOLS[1][nUsado] := 0
			ELSEIF X3_TIPO == "D"
				aCOLS[1][nUsado] := dDataBase
			ELSEIF X3_TIPO == "M"
				aCOLS[1][nUsado] := CriaVar(AllTrim(X3_CAMPO))
			ELSE
				aCOLS[1][nUsado] := .F.
			Endif
			If X3_CONTEXT == "V"
				aCols[1][nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS[1][nUsado+1] := .F.
Else
	M->DRW_NUM  := DRW->DRW_NUM
	M->DRW_DESC := DRW->DRW_DESC

	dbSelectArea(cAlias1)
	dbSeek( cFilDRW + M->DRW_NUM )
	
	nCnt := 0
	
	While !EOF() .And. DRW->DRW_FILIAL + DRW->DRW_NUM == cFilDRW + M->DRW_NUM
	   
	   aAdd( aCOLS, Array(Len(aHeader)+1))
	   
		nCnt++
		nUsado:=0
		dbSelectArea("SX3")
		dbSeek(cAlias1)
		While !EOF() .And. X3_ARQUIVO == cAlias1
			IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .And. !(AllTrim(X3_CAMPO) $ "DRW_NUM,DRW_DESC")
				nUsado++
				cVarTemp := cAlias1+"->"+(X3_CAMPO)
				If X3_CONTEXT # "V"
					aCOLS[nCnt][nUsado] := &cVarTemp
				ElseIF X3_CONTEXT == "V"
					aCOLS[nCnt][nUsado] := CriaVar(AllTrim(X3_CAMPO))
				Endif
			Endif
			dbSkip()
		End
		aCOLS[nCnt][nUsado+1] := .F.
		dbSelectArea(cAlias1)
		dbSkip()
	End
Endif
	
DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

@ 15, 2 TO 42,315 LABEL "" OF oDlg PIXEL

@ 24, 006 SAY "Codigo:"    SIZE 40,7 PIXEL OF oDlg
@ 24, 062 SAY "Descricao"  SIZE 100,7 PIXEL OF oDlg

@ 23, 026 MSGET M->DRW_NUM  PICTURE "@!" SIZE 030,7 PIXEL OF oDlg WHEN .F.
@ 23, 080 MSGET M->DRW_DESC PICTURE "@!" VALID NaoVazio() SIZE 78,7 PIXEL OF oDlg WHEN (nOpc == 3 .Or. nOpc == 4)

oGet := MSGetDados():New(41,2,130,315,nOpc,/*"u_Mod2LinOk()"*/,/*"u_Mod2TudOk()"*/,"+DRW_SEQ",.T.,,,,1000,,,,/*"u_LOJ11DelIt()"*/,oDlg)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(.T./*u_Mod2TudOk()*/,oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1 .And. (nOpc == 3 .Or. nOpc == 4)
	Begin Transaction
	   Mod2Grava(cAlias1)
	End Transaction
Endif
dbSelectArea(cAlias1)
Return

Static Function Mod2Grava(cAlias1)
Local lRet := .T.
Local nI := 0
Local nY := 0
Local cVar := ""
Local lOk := .T.
Local cMsg := ""

dbSelectArea(cAlias1)
dbSetOrder(1)

For nI := 1 To Len(aCols)
   dbSeek( cFilDRW + M->DRW_NUM + aCols[nI][Mod2Pesq("DRW_SEQ")] )

   If !aCols[nI][nUsado+1]            
      If Found()
         RecLock(cAlias1,.F.)
      Else
         RecLock(cAlias1,.T.)
      Endif
      
      DRW->DRW_FILIAL := cFilDRW
      DRW->DRW_NUM    := M->DRW_NUM
      DRW->DRW_DESC   := M->DRW_DESC
   
      For nY = 1 to Len(aHeader)
         If aHeader[nY][10] # "V"
            cVar := Trim(aHeader[nY][2])
            Replace &cVar. With aCols[nI][nY]
         Endif
      Next nY
      MsUnLock(cAlias1)      
   Else
      If !Found()
         Loop
      Endif
      //Fazer pesquisa para saber se o item poderar ser deletado e
      If lOk
         RecLock(cAlias1,.F.)
            dbDelete()
         MsUnLock(cAlias1)
      Else
         cMsg := "Nao foi possivel deletar o item "+aCols[nI][Mod2Pesq("DRW_SEQ")]+", o mesmo possui amarracao"
         Help("",1,"","NAOPODE",cMsg,1,0)
      Endif
   Endif
Next nI

Return( lRet )

Static Function Mod2Pesq(cCampo)
Local nPos := 0
nPos := aScan(aHeader,{|x|AllTrim(Upper(x[2]))==cCampo})
Return(nPos)

User Function RBCFGCodig(cAlias, nRecNo, nOpc)
   Imprime(.F.)
Return

Static Function Imprime(lImp)
   Local nHdl
   Local cEOL     := Chr(13)+Chr(10)
   Local cCodGra  := DRW->(DRW_FILIAL+DRW_NUM)
   Local cArquivo := SM0->M0_CODIGO+DRW->DRW_NUM

   If !lImp
      If File("\GRF"+cArquivo+".PRW")
         FErase("\GRF"+cArquivo+".PRW")
      Endif
      nHdl := FCreate("\GRF"+cArquivo+".PRW")

      FWrite(nHdl,'#include "rwmake.ch"'+cEOL)
      FWrite(nHdl,'#include "font.ch"'+cEOL)
      FWrite(nHdl,''+cEOL)
      FWrite(nHdl,'User Function GRF'+cArquivo+"()"+cEOL)
      FWrite(nHdl,'   Private oPrn := TMSPrinter():New( "Relatório Gráfico" )'+cEOL)
      FWrite(nHdl,''+cEOL)
      FWrite(nHdl,'   DEFINE FONT oFont09 NAME "Arial" SIZE 0,09 Bold OF oPrn'+cEOL)
      FWrite(nHdl,'   DEFINE FONT oFont10 NAME "Arial" SIZE 0,10 Bold OF oPrn'+cEOL)
      FWrite(nHdl,'   DEFINE FONT oFont11 NAME "Arial" SIZE 0,11 Bold OF oPrn'+cEOL)
      FWrite(nHdl,'   DEFINE FONT oFont12 NAME "Arial" SIZE 0,12 Bold OF oPrn'+cEOL)
      FWrite(nHdl,'   DEFINE FONT oFont14 NAME "Arial" SIZE 0,14 Bold OF oPrn'+cEOL)
      FWrite(nHdl,'   DEFINE FONT oFont16 NAME "Arial" SIZE 0,16 Bold OF oPrn'+cEOL)
      FWrite(nHdl,'   DEFINE FONT oFont20 NAME "Arial" SIZE 0,20 Bold OF oPrn'+cEOL)
      FWrite(nHdl,'   DEFINE FONT oFont22 NAME "Arial" SIZE 0,22 Bold OF oPrn'+cEOL)
      FWrite(nHdl,'   DEFINE FONT oFont36 NAME "Arial" SIZE 0,36 Bold OF oPrn'+cEOL)
      FWrite(nHdl,'   DEFINE FONT oFont48 NAME "Arial" SIZE 0,48 Bold OF oPrn'+cEOL)
      FWrite(nHdl,'   DEFINE FONT oFontX  NAME "Arial" SIZE 0,09 Bold Italic Underline OF oPrn'+cEOL)
      FWrite(nHdl,'   DEFINE FONT oFontY  NAME "Arial" SIZE 0,09 Bold OF oPrn'+cEOL)
      FWrite(nHdl,''+cEOL)
      FWrite(nHdl,'   oPrn:SetPortrait() // Estilo retrato'+cEOL)
      FWrite(nHdl,'   oPrn:StartPage()   // Inicia uma nova página'+cEOL)
      FWrite(nHdl,''+cEOL)
   Endif

   DRW->(dbSetOrder(1))
   DRW->(dbSeek(cCodGra,.T.))
   While !DRW->(Eof()) .And. cCodGra == DRW->(DRW_FILIAL+DRW_NUM)

      If DRW->DRW_ATIVO == "2"  // Ignora os objetos inativos
         DRW->(dbSkip())
         Loop
      Endif

      If DRW->DRW_OBJ == "1"      // Fonte
      ElseIf DRW->DRW_OBJ == "2"  // Linha
         If lImp
            DRW->(oPrn:Line(DRW_LINI,DRW_COLI,DRW_LINI+DRW_LINF,DRW_COLI+DRW_COLF))
         Else
            DRW->(FWrite(nHdl,'   oPrn:Line('+ConvStr(DRW_LINI)+','+ConvStr(DRW_COLI)+','+ConvStr(DRW_LINI+DRW_LINF)+','+;
                  ConvStr(DRW_COLI+DRW_COLF)+')'+cEOL))
         Endif
      ElseIf DRW->DRW_OBJ == "3"  // Caixa
         If lImp
            DRW->(oPrn:Box (DRW_LINI,DRW_COLI,DRW_LINI+DRW_COLF,DRW_COLI+DRW_LINF))
         Else
            DRW->(FWrite(nHdl,'   oPrn:Box ('+ConvStr(DRW_LINI)+','+ConvStr(DRW_COLI)+','+ConvStr(DRW_LINI+DRW_COLF)+','+;
                  ConvStr(DRW_COLI+DRW_LINF)+')'+cEOL))
         Endif
      ElseIf DRW->DRW_OBJ == "4"  // Texto
         If lImp
            DRW->(oPrn:Say(DRW_LINI,DRW_COLI,DRW_TEXTO,&(AllTrim(DRW->DRW_FONTE)),,,,3))
         Else
            DRW->(FWrite(nHdl,'   oPrn:Say('+ConvStr(DRW_LINI)+','+ConvStr(DRW_COLI)+',"'+Trim(DRW_TEXTO)+'",'+;
                  AllTrim(DRW->DRW_FONTE)+',,,,3)'+cEOL))
         Endif
      ElseIf DRW->DRW_OBJ == "5"  // BitMap
         If lImp
            DRW->(oPrn:SayBitmap(DRW_LINI,DRW_COLI,DRW_TEXTO,DRW_LINF,DRW_COLF))
         Else
            DRW->(FWrite(nHdl,'   oPrn:SayBitmap('+ConvStr(DRW_LINI)+','+ConvStr(DRW_COLI)+',"'+Trim(DRW_TEXTO)+'",'+;
                  ConvStr(DRW_LINF)+','+ConvStr(DRW_COLF)+')'+cEOL))
         Endif
      Endif

      DRW->(dbSkip())
   Enddo

   If !lImp
      FWrite(nHdl,''+cEOL)
      FWrite(nHdl,'   oPrn:EndPage()     // Finaliza a página'+cEOL)
      FWrite(nHdl,'   oPrn:Preview()     // Visualiza antes de imprimir'+cEOL)
      FWrite(nHdl,'Return'+cEOL)
      FClose(nHdl)

      If File("\GRF"+cArquivo+".PRW")
         Alert("Fonte \GRF"+cArquivo+".PRW gerado com sucesso !")
      Endif
   Endif
Return

Static Function ConvStr(nValor)
Return LTrim(Str(nValor,10))
