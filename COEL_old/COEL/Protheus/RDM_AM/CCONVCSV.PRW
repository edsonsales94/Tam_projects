#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CCONVCSV ³ Autor ³ Carlos Nina           ³ Data ³ 03/04/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Este programa recebe um arquivo .csv e devolve um arquivo  ³±±
±±³          ³ de trabalho (dbf) ou um arquivo .txt com colunas fixas     ³±±
±±³          ³ conforme arquivo de layout (em .txt)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parâmetros³ [1] String 1 posição "1" - (.txt) ou "2" - alias (.dbf)    ³±±
±±³          ³ [2] Local e nome do arquivo original (.csv)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ [1] arquivo .txt                                           ³±±
±±³          ³ [2] alias de um arquivo temporário em .dbf                 ³±±
±±³          ³ [3] estrutura do arquivo de layout                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Diversos                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CCONVCSV(cRetFun, cFileOri, cLayout, cArqTemp)

//cRetFun  - tipo de arquivo a ser retornado pela função (1-.txt ou 2-alias do .dbf) //rf
//cFileOri - local e arquivo de dados .csv com separador ;  //rf

Local   aSays		:= {}
Local   aButtons	:= {}
Local   nOpca		:= 0
Local   cFileCfg	:= "" // local e arquivo de layout
Local   cAlias	   := ""
Local   cBuffer	:= ""
Local   aStruc	   := {}
Local   cStrAux	:= ""
Local   lFlag     := IIF(cRetFun==nil, .T. , .F.)
Private cPerg		:= "CCONVCSV01"
Private lErro		:= .F.
Private cCadastro	:= OemToAnsi("Formatação de arquivo .CSV para .TXT/.DBF")

ValidPerg()

Pergunte(cPerg,lFlag)

IF ( cRetFun==Nil )   

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta tela principal ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aSays,OemToAnsi("Este programa recebe um arquivo .csv e devolve um arquivo de trabalho (dbf) ou um arquivo"		))
	AADD(aSays,OemToAnsi(".txt com colunas fixas conforme arquivo de layout (em .txt), fornecido com a seguinte estrutura:"	))
	AADD(aSays,OemToAnsi("Nome do campo - 10 pos. / Tipo - 1 pos. (C,N ou D) / Tamanho - 3 pos. / Decimal - 1 pos."			))
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpca==0
		Return
	EndIf

	cLayout  := mv_par01
	cArqTemp := mv_par02

ENDIF
//cFileCfg	:= GetSrvProfString("RootPath","")+"\System\ConvCsv\"+RTRIM(cLayout)      //local e arquivo de layout
//cArqTemp := GetSrvProfString("RootPath","")+"\System\ConvCsv\"+RTRIM(cArqTemp)     //local e arquivo de destino .txt
cFileCfg	:= "System\ConvCsv\"+RTRIM(cLayout)      //local e arquivo de layout
cArqTemp := "System\ConvCsv\"+RTRIM(cArqTemp)     //local e arquivo de destino .txt

If !File(cFileCfg)
	Aviso('Atenção!!','Arquivo nao selecionado ou invalido!  Informe essa opção nos parâmetros.',;
	{"OK"},1,'Arquivo de Layout??')
	lErro := .T.
Endif

If !File(cFileOri)
	Aviso('Atenção!!','Arquivo nao selecionado ou invalido!  Informe essa opção nos parâmetros.',;
	{"OK"},1,'Arquivo de Dados??')
	lErro := .T.
Endif

If lErro
	Aviso("Termino","Houve problema na configuração de parâmetros ou arquivos invalidos",;
	{"Ok"},1,OemToAnsi("Processo não Concluido !"))
	Return({" ","",""})
EndIf

///Cria arquivo destino
///nHandle := MsfCreate(cFileDest,0)

// Cria o arquivo de trabalho conforme layout
FT_FUSE(cFileCfg)
FT_FGOTOP()

Do While !FT_FEOF()
	cBuffer := Alltrim(FT_FREADLN())
	// Cria Estrutura do Arquivo Temporario
	//	Aadd(aStruc,{"'"+ALLTRIM(Substr(cBuffer,1,15))+"'"	,"'"+Substr(cBuffer,16,1)+"'"	,Substr(cBuffer,17,3)	,Substr(cBuffer,20,1)})    rf
	IF !EMPTY(SUBS(cBuffer,1,10))
		Aadd(aStruc,{ALLTRIM(Substr(cBuffer,1,10)) , Substr(cBuffer,16,1) , val(Substr(cBuffer,17,3)) , val(Substr(cBuffer,20,1)) })
	ENDIF	
	FT_FSKIP()
EndDo
FT_FUSE()
*
cRetFun := IIF(cRetFun==Nil , "3" , cRetFun )
cAlias  := 'LAYOUT'  
cArqTmp := CriaTrab(aStruc,.T.)
dbUseArea(.T.,,cArqTmp,cAlias,.F.,.F.)

FT_FUSE(cFileOri)
FT_FGOTOP()
FT_FSKIP()

While !FT_FEOF()
	cBuffer := Alltrim(FT_FREADLN())
	RecLock(cAlias, .T.)
	_posvirg := 1
	for _i:=1 to Len(aStruc)
		_campo := ""
		while subst(cBuffer,_posvirg,1) <> ';' .and. _posvirg <= len(cBuffer)
			_campo += subst(cBuffer,_posvirg,1)
			_posvirg++
		enddo
		_descampo := aStruc[_i][1]
		if valtype((cAlias)->&_descampo) == 'C'
			(cAlias)->&_descampo := ALLTRIM(_campo)
		elseif valtype((cAlias)->&_descampo) == 'N'  
			nVrg := AT(",",_campo)
			nDcm := aStruc[_i,4]
			IF ( nVrg > 0 )
				cAux := val(strtran(_campo,",","."))
				cAux := strzero(cAux,aStruc[_i,3],nDcm)
				cAux := strtran(cAux,".","")
			ELSE
				cAux := strtran(_campo,",","")+repl("0",nDcm)
			ENDIF
			(cAlias)->&_descampo := val(cAux)  //val(strtran(cAux,",",""))
		else
			cAux := "'"+_campo+"'"
			(cAlias)->&_descampo := ctod(cAux)
		endif
		_posvirg++
	next _i
	MsUnlock()
	FT_FSKIP()
EndDo

FT_FUSE()

// gera arquivo .txt com colunas fixas conforme layout fornecido
(cAlias)->(dbgotop())
If cRetFun = "1"

	nHandle := MsFCreate( cArqTemp, 0 )

	While (cAlias)->(!Eof())

		cStrAux := ""

		For x:=1 to Len(aStruc)

			Do Case
				Case ValType( &(cAlias+"->"+aStruc[x][1]) ) = "C"

//					cStrAux += PADR( (cAlias)->(&(aStruc[x][1])) , Val(aStruc[x][3]) )
					cStrAux += PADR( (cAlias)->(&(aStruc[x][1])) , aStruc[x][3] )

				Case ValType( &(cAlias+"->"+aStruc[x][1]) ) = "N"

//					cStrAux += StrZero( (cAlias)->(&(aStruc[x][1])) , Val(aStruc[x][3]) )
					//cStrAux += StrZero( Int((cAlias)->(&(aStruc[x][1]))) , aStruc[x][3]-aStruc[x][4] ) + StrZero( RIGHT(ALLTRIM((cAlias)->(&(aStruc[x][1])))) , aStruc[x][4] )
					cStrAux += StrZero( (cAlias)->(&(aStruc[x][1])) , aStruc[x][3] )

				Case ValType( &(cAlias+"->"+aStruc[x][1]) ) = "D"

//					cStrAux += PADR( DTOS( (cAlias)->(&(aStruc[x][1])) ) , Val(aStruc[x][3]) )
					cStrAux += PADR( DTOS( (cAlias)->(&(aStruc[x][1])) ) , aStruc[x][3] )

				Case ValType( &(cAlias+"->"+aStruc[x][1]) ) = "L"

//					cStrAux += PADR( Iif( (cAlias)->(&(aStruc[x][1])) ,"T","F") , Val(aStruc[x][3]) )
					cStrAux += PADR( Iif( (cAlias)->(&(aStruc[x][1])) ,"T","F") , aStruc[x][3] )

			EndCase

		Next x

		//Grava a linha do arquivo original devidamente tratado em outro arquivo texto
		FWrite(nHandle, cStrAux+Chr(13)+Chr(10) )

		(cAlias)->(dbSkip())
	EndDo

	(cAlias)->(DBCLOSEAREA())
EndIf

fClose(nHandle)

If cRetFun = "1"
	Return({cArqTemp,"",aStruc})
ElseIf cRetFun = "2"
	Return({"",cAlias,aStruc})
Else
	Return
EndIf


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidPerg ³ Autor ³ Carlos Nina          ³ Data ³ 03/04/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta o grupo de perguntas (SX1)                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()

Local aRegs := {}
Local i,j


aHelpPor := {""}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"01","Arq. de Layout .txt  ?","","","mv_ch1","C",99,0,0,"G","","","","S","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSX1(cPerg,"02","Arq. de Destino .txt ?","","","mv_ch2","C",99,0,0,"G","","","","S","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return()
