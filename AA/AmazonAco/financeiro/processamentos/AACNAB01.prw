#INCLUDE "rwmake.ch"
#INCLUDE "Fileio.ch"

/*__________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+----------------------+-------------+---------------+¦
¦¦¦ Programa  ¦ MARCEL01  Autor ¦ ADSON CARLOS     | Data | xx/xx/xx¦
¦¦+-----------+----------------------+-------------+---------------+¦
¦¦¦ Descrição:|- Reescreve o cnab(lol)                              ¦
¦¦+------------+----------------------+-------------+---------------+
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function AACNAB01

Private oLeTela
Private cString := ""
Private cPerg   := "AACNAB01"

ValidPerg(cPerg)

@ 200,1 TO 380,380 DIALOG oLeTela TITLE OemToAnsi("Leitura de Arquivo")
@ 02,10 TO 080,190
@ 10,018 Say "Este programa irá ler o conteúdo de um arquivo CNAB (retorno), "
@ 18,018 Say "conforme os parametros definidos pelo usuario. "
@ 26,018 Say " "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTela)
@ 70,100 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTela Centered

Return


//---------------------------------------------------------------------------------------------------------------------------------
// Descricao.: Grupo de perguntas para consulta
Static Function ValidPerg(cPerg)

PutSX1(cPerg,"01",PADR("Origem ",29)+"?","","","mv_ch1","C",60,0,0,"G","","DIR","","",mv_par01)
PutSX1(cPerg,"02",PADR("Destino",29)+"?","","","mv_ch2","C",60,0,0,"G","","DIR","","",mv_par02)

Return Nil


//---------------------------------------------------------------------------------------------------------------------------
// OkLeTxt
Static Function OkLeTxt 

Private nHdl   	
Private cEOL    
 
Processa({|| RunCont()  },"Processando...")

Return



//---------------------------------------------------------------------------------------------------------------------------
// Le arquivo e Grava (MODELO 1).
Static Function RunCont

Local aVector   := {}     
Local cBanco, cMod, cTexto 

// Abre o arquivo
nHandle := FT_FUse(MV_PAR01)

// Se houver erro de abertura abandona processamento
if nHandle = -1
  ALERT("ERR0")
  return
endif

// Posiciona na primeria linha
FT_FGoTop()                     

// Retorna o número de linhas do arquivo
nLast := FT_FLastRec()         
ProcRegua(nLast)

cLine  := FT_FReadLn() // Retorna a linha corrente
nRecno := FT_FRecno()  // Retorna o recno da Linha     
  
cBanco := SubStr(cLine,77,3)   //Banco do Header 
aAdd(aVector,cLine)

FT_FSKIP()

While !FT_FEOF()     
  IncProc()
  cLine  := FT_FReadLn() // Retorna a linha corrente
  nRecno := FT_FRecno()  // Retorna o recno da Linha     

  cTrailler := SubStr(cLine,5,3)    //Usado na validacao da linha alterada
  cTexto    := SubStr(cLine,117,10) //Cousa alterada
  cSubst    := SubStr(cLine,38,10)  //Cousa a ser alterada
  
  If cTrailler <> cBanco .And. Len(StrTran(cTexto," ")) == 10
    cMod := StrTran(cLine,cSubst,cTexto)
  Else
    cMod := cLine  
  EndIf                         
  
  aAdd(aVector,cMod) //Grava a linha alterada no Vetor(ou naw)
  // Pula para próxima linha
  FT_FSKIP()
End
                                      
// Fecha o Arquivo
FT_FUSE()        

For x:=1 To Len(aVector)
 IncProc()
 Grava_Log(aVector[x]) //grava linha
Next

Grava_Log("",.T.) //fecha gravacao    
Close(oLeTela)
   
Return .T.


****************************************
STATIC FUNCTION Grava_Log(cTxt,lFecha)
****************************************
Local cNome,cString := cTxt, cFileName, cTmpFile

//cNome     := SubStr(Alltrim(mv_par02), RAT("\",ALLTRIM(MV_PAR02)),LEN(ALLTRIM(MV_PAR02) ) - 6 )
cFileName := AllTrim(mv_par02) //+ "\" + cNome
cFileName := StrTran(cFileName,"\\","\")
cTmpFile  := cFileName + ".tmp"

If lFecha == NIL .Or. lFecha == .F.
	If !File(cTmpFile)
		fHandle:=FCREATE(cTmpFile)
	Else
		fHandle := FOPEN(cTmpFile,2)
	Endif
	cString := cTxt+CHR(13)+CHR(10)
	FSEEK(fHandle,0,2)
	FWRITE(fHandle,cString)
	FCLOSE(fHandle)
Else
	If File(cFileName)
		FErase(cFileName)
	Endif
	FRename(cTmpFile, cFileName)
	MsgInfo("Foi gerado arquivo CNAB, arquivo: "+cFileName,"Informacao")
Endif
Return