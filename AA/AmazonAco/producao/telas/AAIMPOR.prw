#include "RwMake.ch"
#include "Protheus.ch"
#include "TBICONN.ch"
#include "apwizard.ch"

User Function AAIMPOR()

Local aArq   := {}
Local _cAlias := "DROR"
Local _aStru := {}
Local _cDest := "DRO"

aArq := AAGETFILE()

For nK := 1 to Len(aArq)
   DBUseArea( .T.,"DBFCDXADS", aArq[01], _cAlias ,.T., .F. )
   
   _aStru := DBStruct()
   alert( aArq[02] )
   alert( ChkFile(aArq[02]) )
   If !ChkFile(aArq[02])
      DBUseArea( .T.,"TOPCONN", aArq[02], _cDest ,.T., .F. )
   else
     _cDest := aArq[02]
   EndIf
   
   For nStr := 1 To Len(_aStru)
       
      (_cDest)->(recLock(_cDest,.T.))
         (_cDest)->&(_aStru[nStr][01]) := (_cAlias)->&(_aStru[nStr][01])
      (_cDest)->(MsuNlock())
   
   Next
   (_cDest)->(dbCLoseArea(_cDest))
   (_cAlias)->(dbCLoseArea(_cAlias))
Next

Return Nil

Static Function ValidaP1()
Local _lRet := .T.
If !File(cGet1)
   If !ExistDir (  cGet1 )
     Aviso("ERRO","Informe Um Caminha de Arquivo/Pasta Valido",{"OK"})
     _lRet := .F.
   EndIf 
EndIf
    
Return _lRet

/*          
Local cMask  := PadR('Texto (*.txt)',27) + '|*.txt|' + PadR('Todos (*.*)',27)+ '|*.*|'     // mascara passada para Função cGetFile
cArquivo := cGetFile(PadR('Texto (*.dbf)',27) + '|*.dbf|' + PadR('Todos (*.*)',27)+ '|*.*|' , OemToAnsi("Arquivos dBase"),,,.T.,GETF_ONLYSERVER )//"Selecione arquivo "
*/
Static Function AAGETFILE()

Local _cFile := Space(400)
Local _cDest := Space(15)

Define Font oFnt3 Name "Ms Sans Serif" Bold

while !File(_cFile)

	DEFINE MSDIALOG oDialog TITLE "Parametro" FROM 190,170 TO 400,770 PIXEL 
	@ 005,004 SAY "Arquivo para Importacao:" SIZE 220,10 OF oDialog PIXEL Font oFnt3
	@ 005,050 MSGET _cFIle  SIZE 300,10  PICTURE "@!" Pixel of oDialog F3 "AAFILE"
	
	@ 025,004 SAY "Tabela Destino " SIZE 220,10 OF oDialog PIXEL Font oFnt3
	@ 025,050 MSGET _cDest  SIZE 300,10  PICTURE "@!" Pixel of oDialog //F3 "AAFILE"
	
	@ 045,042 BMPBUTTON TYPE 1 ACTION( nRet := IIF(File(_cFile), oDialog:End() ,Nil) )
	
	ACTIVATE DIALOG oDialog CENTERED
Enddo

Return {Alltrim(_cFile),Alltrim(_cDest)}