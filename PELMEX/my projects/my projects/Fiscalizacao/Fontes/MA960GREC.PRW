#include "protheus.ch" 
#include 'parmtype.ch' 
 
//-------------------------------------------------------------------
/*/{Protheus.doc} MA960GREC
Ponto de Entrada para preenchimento dos campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE e F6_CODPROD de acordo com o código de receita e UF.
 
@author 
@since 
/*/
//-------------------------------------------------------------------
user function SPCOBREC()
/* 
Paramixb[1] => Tipo GNRE
Paramixb[2] => ESTADO da GNRE
*/

//Local cTipoImp := Paramixb[1] // Tipo de Imposto (3 - ICMS ST ou B - Difal e Fecp de Difal)
//Local cEstado  := Paramixb[2] // Estado da GNRE
Local cCod     := "003" // Codigo a ser gravado no campo F6_COBREC

 
/* 
	If cTipoImp == "B"
		cCod := "000"
	Else 
		cCod := "999" 
	EndIf
*/
return cCod

User Function MA960GREC()
 
    Local aParam   := {0, '', '', 0, ''} //Parâmetros de retorno default
    Local cReceita := PARAMIXB[1]    //Código de Receita da guia atual
    Local cUF      := PARAMIXB[2]    //Sigla da UF da guia atual
 
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'PA' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'AC' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'AL' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'AM' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {22, '2', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'AP' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'BA' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'CE' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf 
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'DF' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'GO' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'MA' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'MG' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'MT' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'MS' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'PB' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'PE' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {22, '2', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'PI' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'PR' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'RJ' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'RN' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'RO' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'RR' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'RS' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {22, '2', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'SC' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {24, '2', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'SE' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    If Alltrim(cReceita) $ '100102' .And. cUF $ 'TO' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {10, '1', '', 0, ''}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf
    /*If Alltrim(cReceita) $ '1260' .And. cUF $ 'ES' //Valida o Código de Receita e sigla da UF da guia atual
        aParam := {24, '2', '', 7, '5'}          //Retorna os campos F6_TIPOGNU, F6_DOCORIG, F6_DETRECE, F6_CODPROD e F6_CODAREA de acordo com o código de receita e sigla da UF da guia atual.
    EndIf*/
Return aParam