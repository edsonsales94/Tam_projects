/*
===========================================================================
Copyright (C) 2012-2014 Fvncional, Inc.

This file is part of Amazon Aço source code.

This source code is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.


This code is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Foobar; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================
*/

#include "Protheus.ch"
#include "rwmake.ch"
#include "font.ch"
#INCLUDE "TOPCONN.CH"
#include "Tbiconn.ch"

User Function 	AAESTT99(_sJanela,_sData,_sTurno)

Local _naPos := 1

Default _sData   := STOD("20131017")   
Default _sJanela := "" 
Default _sTurno  := "01"  

Private _daEmis  := _sData 
Private _caTurno := _sTurno
Private _oaGrid1 := Nil
Private _oaGrid2 := Nil
Private _oaGrid3 := Nil
Private _oaGrid4 := Nil
Private _aItens1 := {}        
Private _aItens2 := {}        
Private _aItens3 := {}        
Private _aItens4 := {}        
Private _Fields  := {}                
Private aCoors   := FwGetDialogSize(oMainWnd)//MsAdvSize()  
Private oWindow  := Nil  
Private aTFolder := {"Pessoal","Processo", "Qualidade", "5S"}
Private oTFolder := Nil  
Private _oaVerm 	 := LoadBitmap( nil, "BR_VERMELHO" )
Private _oaAzul 	 := LoadBitmap( nil, "BR_VERDE" )   

If vALType(_sJanela) = "O"
	_sJanela:End()
endif

GetSql()   

oWindow  := MSDialog():New(aCoors[1], aCoors[2],aCoors[3], aCoors[4],"Consulta Check List",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

@ 011, 036 SAY "Emissao:" SIZE 040, 009 OF oWindow COLORS 0, 16777215 PIXEL
@ 010, 055 MSGET _daEmis  SIZE 040, 010 OF oWindow COLORS 0, 16777215 PIXEL    

@ 011, 116 SAY "Turno:" SIZE 040, 009 OF oWindow COLORS 0, 16777215 PIXEL
@ 010, 150 MSGET _caTurno  SIZE 020, 010 OF oWindow COLORS 0, 16777215 PIXEL

oTFolder := TFolder():New( 40,06,aTFolder,,oWindow,,,,.T.,,640,240 )

TButton():New(010,420,'&Consultar',oWindow,{|| MsgRun('Filtrando Dados, Aguarde...',,{|| U_AAESTT99(@oWindow,_daEmis,_caTurno)  } )  } ,40,12,,,,.T.)
TButton():New(010,500,'&Fechar'   ,oWindow,{|| oWindow:End() } ,40,12,,,,.T.)

_oaGrid1 := TcBrowse():New ( 010,010,620,210 , , /*aCabec*/ ,/*[ aColSizes]*/, oTFolder:aDialogs[1] , /*[ cField]*/,  , , /*[ bChange]*/,  , /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/, , /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
_oaGrid1:SetArray(_aItens1) //Seta as informações   
fAdiciona(_oaGrid1,1)   
_oaGrid1:Refresh()         						//Atualização do Objeto    

_oaGrid2 := TcBrowse():New ( 010,010,620,210 , , /*aCabec*/ ,/*[ aColSizes]*/, oTFolder:aDialogs[2] , /*[ cField]*/,  , , /*[ bChange]*/,  , /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/, , /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
_oaGrid2:SetArray(_aItens2) //Seta as informações 
fAdiciona(_oaGrid2,2) 
_oaGrid2:Refresh()         						//Atualização do Objeto    

_oaGrid3 := TcBrowse():New ( 010,010,620,210 , , /*aCabec*/ ,/*[ aColSizes]*/, oTFolder:aDialogs[3] , /*[ cField]*/,  , , /*[ bChange]*/,  , /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/, , /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
_oaGrid3:SetArray(_aItens3) //Seta as informações       
fAdiciona(_oaGrid3,3)
_oaGrid3:Refresh()         						//Atualização do Objeto    

_oaGrid4 := TcBrowse():New ( 010,010,620,210 , , /*aCabec*/ ,/*[ aColSizes]*/, oTFolder:aDialogs[4] , /*[ cField]*/,  , , /*[ bChange]*/,  , /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/, , /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
_oaGrid4:SetArray(_aItens4) //Seta as informações      
fAdiciona(_oaGrid4,4)  
_oaGrid4:Refresh()         						//Atualização do Objeto   

//fReorder() 

oFont := TFont():New('Courier new',,-12,.T.)
oFont := TFont():New('Arial',,-12,.T.)  

oWindow:Refresh()         						//Atualização do Objeto 


ACTIVATE MSDIALOG oWindow CENTERED   
   

Return Nil


/*_______________________________________________________________________________
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ProProcedure¦ Autor ¦ 				      ¦ Data ¦ 17/01/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a Stored Procedure caso a mesma não Exista   		      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

Static Function ProProcedure(_caName)
	_cdSql := " "
	//verifica se existe
	if !TCSPExist(_caName)
		_cdSql +=                     " CREATE PROCEDURE " + _caName + "  @data Varchar(8)  "
//		_cdSql += Chr(13) + Chr(10) + "                                   @turno Varchar(2)
		_cdSql += Chr(13) + Chr(10) + " AS BEGIN

		_cdSql += Chr(13) + Chr(10) + " SET NOCOUNT ON;

		_cdSql += Chr(13) + Chr(10) + " DECLARE @cols AS NVARCHAR(MAX),
		_cdSql += Chr(13) + Chr(10) + " @valores  AS NVARCHAR(MAX),
		_cdSql += Chr(13) + Chr(10) + " @query  AS NVARCHAR(MAX);
		
		_cdSql += Chr(13) + Chr(10) + " SET @cols = STUFF((SELECT DISTINCT ',ISNULL(' + QUOTENAME(ZL_LINHA+ZL_TURNO) + ',' + CHAR(39)+ 'N' +CHAR(39) + ')' + QUOTENAME(ZL_LINHA+ZL_TURNO) 
        _cdSql += Chr(13) + Chr(10) + "    FROM SZL010 ZL WITH (NOLOCK)
        _cdSql += Chr(13) + Chr(10) + "    WHERE D_E_L_E_T_ = ''
        _cdSql += Chr(13) + Chr(10) + "    AND ZL_DATA = @data 
        //_cdSql += Chr(13) + Chr(10) + "    AND ZL_TURNO = @turno
        _cdSql += Chr(13) + Chr(10) + "    FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') ,1,1,'')    
		
	    _cdSql += Chr(13) + Chr(10) + " SET @valores = STUFF((SELECT DISTINCT ',' + QUOTENAME(ZL_LINHA+ZL_TURNO) 
        _cdSql += Chr(13) + Chr(10) + " 	FROM SZL010 ZL
        _cdSql += Chr(13) + Chr(10) + "	    WHERE D_E_L_E_T_ = ''
        _cdSql += Chr(13) + Chr(10) + "	    AND ZL_DATA = @data 
		//_cdSql += Chr(13) + Chr(10) + "    AND ZL_TURNO = @turno
        _cdSql += Chr(13) + Chr(10) + "	    FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)') ,1,1,'')	
  
		_cdSql += Chr(13) + Chr(10) + " SET @query = 'SELECT ZL_PERGUNT, ' + @cols + ' FROM (
        _cdSql += Chr(13) + Chr(10) + "         SELECT ZL_PERGUNT
        _cdSql += Chr(13) + Chr(10) + "             , ZL_RESPOST
        _cdSql += Chr(13) + Chr(10) + "             , ZL_LINHA+ZL_TURNO ZL_LINHA
        _cdSql += Chr(13) + Chr(10) + "         FROM SZL010 ZL WITH (NOLOCK)
        _cdSql += Chr(13) + Chr(10) + "         WHERE ZL_DATA = ' + @data + ' 
        //_cdSql += Chr(13) + Chr(10) + "         AND ZL_TURNO = ' + @turno + ' 
        _cdSql += Chr(13) + Chr(10) + "         AND D_E_L_E_T_ = SPACE(1)
        _cdSql += Chr(13) + Chr(10) + "     ) X
        _cdSql += Chr(13) + Chr(10) + "     PIVOT
        _cdSql += Chr(13) + Chr(10) + "     (
        _cdSql += Chr(13) + Chr(10) + "         MAX(ZL_RESPOST)
        _cdSql += Chr(13) + Chr(10) + "         FOR ZL_LINHA in (' + @valores + ')
        _cdSql += Chr(13) + Chr(10) + "      ) P ORDER BY ZL_PERGUNT ' 

		_cdSql += Chr(13) + Chr(10) + " execute(@query)
		_cdSql += Chr(13) + Chr(10) + " END
		//altera o nome da Tabela fixo para a respectiva da empresa/filial
		_cdSql := StrTran(_cdSql,'SZL010',RetSqlName('SZL'))
		//cria a stored
		_ndRet := TcSqlExec(_cdSql)
	Endif
	Return

/*_______________________________________________________________________________
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GetSql()   ¦ Autor ¦ 				      ¦ Data ¦ 17/01/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria a Area da Area de Trabalho da Consulta		 		      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/	
	
Static Function GetSql()

	Local _cdQry   := ""
	Local _cdTbl   := getNextAlias()   
	Local _Vector1 := {}   
	Local _Vector2 := {}   
	Local _Vector3 := {}   
	Local _Vector4 := {}   			
	Local aNovo    := {}       
	Local _natam   := 0 
	Local aNovo    := {}  
	
	_Fields := {}
	
	//verifica procedure
	_cdName := 'CHECKLISTPRO'+cEmpAnt 
	ProProcedure(_cdName)
	
	//executa a procedure
	_cdQry := " exec " + _cdName + "  '"+dtos(_daEmis)+"', '"+_caTurno+"'

	dbUseArea(.T.,'TOPCONN',tcGenQry(,,_cdQry),_cdTbl,.T.,.T.) 
	_naTam 	 := (_cdTbl)->(FCOUNT())  
	FOR _naPos := 1 TO _naTam    	
		aADD(aNovo,Field(_naPos)) 	
	NEXT    
	_Fields := aClone(aNovo)
	dbEval( {|| fProcessa(_Vector1,_Vector2,_Vector3,_Vector4)  }) 

	(_cdTbl)->(dbCloseArea(_cdTbl))  
	
	iF EMPTY(_VECTOR1) 
		FOR _nZ := 1 TO Len(_Fields)
			aADD(aNovo,"") 	
		NEXT    
	   aADD(_aItens1,aNovo)   
	   aADD(_aItens2,aNovo)   
	   aADD(_aItens3,aNovo)      
   	aADD(_aItens4,aNovo)      
   Else
   	_aItens1 := aClone(_Vector1)	
   	_aItens2 := aClone(_Vector2)	
   	_aItens3 := aClone(_Vector3)	   	
   	_aItens4 := aClone(_Vector4)	   	
	ENDIF   

Return 

Static Function fProcessa(_Vector1,_Vector2,_Vector3,_Vector4)
Local aNovo := {}
Local cTipo := Posicione("SZI",1,XFILIAL("SZI")+FieldGet(1),"ZI_TIPO")

FOR _nZ := 1 TO Len(_Fields)
	aADD(aNovo,FieldGet(_nz)) 	
NEXT          

If cTipo = "1"  
	aADD(_Vector1,aNovo)      
ElseIf cTipo = "2"   
	aADD(_Vector2,aNovo)   
ElseIf cTipo = "3" 
	aADD(_Vector3,aNovo)   
Else
	aADD(_Vector4,aNovo)   
EndIf

Return 


Static Function fAdiciona(Xobjeto,nRef)  
Local aSizes := {40,150}

FOR _naPos := 1 TO LEN(_FIELDS)                  
	If _naPos <= 2
		Xobjeto:AddColumn(TCColumn():New(_Fields[_naPos], &( "{|| _aItens"+ALLTRIM(STR(nRef))+"[_oaGrid"+ALLTRIM(STR(nRef))+":nAt," + ALLTRIM(STR(_napos)) + "]}") , "@!" ,,, "RIGTH"  ,aSizes[_napos],.F.,.F.,,,,.F.,))
	Else  
		Xobjeto:AddColumn(TCColumn():New(_Fields[_napos], &( "{|| iif(_aItens"+ALLTRIM(STR(nRef))+"[_oaGrid"+ALLTRIM(STR(nRef))+":nAt," + ALLTRIM(STR(_napos)) + "] = 'S',_oaAzul,_oaVerm) }" ) , ,,, ,40,.T.,.F.,,,,.F.,) )
	Endif
NEXT  
 
oWindow:Refresh()         						//Atualização do Objeto      

Return 

Static Function fAvalia(_Vetor,Posit)
Return _Vetor[Posit] = "S"  

Static Function fReorder()  
Local _naPos := 1        
Local _teste    := __ClsArr()
 
_oaGrid:DESTROY() 
oTFolder:DESTROY()                   
oTFolder := TFolder():New( 40,06,aTFolder,,oWindow,,,,.T.,,650,300 )

_oaGrid := TcBrowse():New ( 010,010,620,210 , , /*aCabec*/ ,/*[ aColSizes]*/, oTFolder:aDialogs[1] , /*[ cField]*/,  , , /*[ bChange]*/,  , /*[ bRClick]*/, /*[ oFont]*/, /*[ oCursor]*/, /*[ nClrFore]*/, /*[ nClrBack]*/,/* [ cMsg]*/, /*[ uParam20]*/, , /*[lPixel]*/ .T., {|| .T.} /* [ bWhen]*/, , /*[ bValid]*/ , /*[lHScroll]*/ , /*[lVScroll]*/ )
_oaGrid:SetArray(_aItens) //Seta as informações 

fAdiciona()              

_oaGrid:Refresh()         						//Atualização do Objeto    
oWindow:Refresh()         						//Atualização do Objeto   

Return 

/*_______________________________________________________________________________
|¦¦ Função    ¦ENFATC99    ¦ Autor ¦ ADSON CARLOS         ¦ Data ¦ 10/04/2013 ¦¦|
|¦+-----------+------------+-------+----------------------+------+------------+¦|
|¦¦ Descriçäo ¦Chamada direto do Programa Inicial lembrar de setar infos fixas no vetor _Itens (inutil agora :) )¦|
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function ENFATC99()
Return( EvalPrw( { || U_AAESTT99()  } , "01" , "01" , "SIGAFAT" , "AA3" ) )
                                                                                 

/*_______________________________________________________________________________
|¦¦ Função    ¦EvalPrw    ¦ Autor ¦ ADSON CARLOS         ¦ Data ¦ 10/04/2013 ¦¦|
|¦+-----------+------------+-------+----------------------+------+------------+¦|
|¦¦ Descriçäo ¦Avalia a chamada via RPC									       ¦|
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

Static Function EvalPrw( bExec , cEmp , cFil , cModulo , cTables )

Local bWindowInit	:= { || Eval( bExec ) }
Local lPrepEnv		:= ( IsBlind() .or. ( Select( "SM0" ) == 0 ) )

Local uRet

BEGIN SEQUENCE

IF ( lPrepEnv )
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA( cEmp ) FILIAL ( cFil ) MODULO ( cModulo ) TABLES ( cTables )

	InitPublic()
	SetsDefault()
EndIF

IF ( Type(  "oMainWnd" ) == "O" )
	uRet := Eval( bExec )
	BREAK
EndIF

bWindowInit	:= { || uRet := Eval( bExec ) }
DEFINE WINDOW oMainWnd FROM 0,0 TO 0,0 TITLE OemToAnsi( FunName() )
  	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT ( Eval( bWindowInit ) , oMainWnd:End() )

IF ( lPrepEnv )
	RESET ENVIRONMENT
EndIF	

END SEQUENCE

Return( uRet )
