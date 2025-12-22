#include "totvs.ch"
#include "protheus.ch"
#include "tbiconn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAESTR07   ¦ Autor ¦ DIEGO RAMOS          ¦ Data ¦ 13/03/2019 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Impressão do controle de corridas		                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAESTR07()
   
   Local aRet := {}
   Local aParamBox := {}
   aTipos := {"Rolo","Feixe"}
   aTpEtq := {"Apv/Rep","N/A"}
   //rpcsetenv("01","01")
   aAdd(aParamBox,{1,"Produto",Space(15),"","ExistCpo('SB1',mv_par01) .And. u_AAESTR7A()","SB1","",0,.T.})
   aAdd(aParamBox,{1,"Descricao",Space(15),"","","SB1","",0,.T.})

   aAdd(aParamBox,{1,"Diametro",0,"@E 999,999.99","Positivo()","","",50,.T.}) // Tipo caractere
   aAdd(aParamBox,{1,"Peso",0,"@E 999,999.9","Positivo()","","",50,.T.}) // Tipo caractere
   aAdd(aParamBox,{1,"Corrida",Space(9),"@!","","","",50,.T.}) // Tipo caractere
   aAdd(aParamBox,{1,"Num Ensaio",Space(6),"@!","","","",50,.T.}) // Tipo caractere   
   
   aAdd(aParamBox,{2,"Tipo ",1,{"Rolo","Feixe"},50,,.T.}) // Tipo caractere   

   //aAdd(aParamBox,{1,"Modelo ",Space(6),"@!","","","",50,.T.}) // Tipo caractere
   aAdd(aParamBox,{2,"Tipo Impressao",1, aTpEtq ,50,,.T.}) // Tipo caractere
   aAdd(aParamBox,{1,"Copias",0,"@E 99","Positivo()","","",50,.T.}) // Tipo caractere

  // aAdd(aParamBox,{1,"Etiqueta",Space(25),"","ExistCpo('CB0',mv_par10) ","CB0","",0,.T.})(alterado Francisco torres)
   //aAdd(aParamBox,{1,"Copias",0,"@E 99","Positivo()","","",50,.T.}) // Tipo caractere

   //Local aAdd(aParamBox,{1,"Corrida",0,"@E 999,999.99","Positivo()","","",15,.T.}) // Tipo caractere
   If ParamBox(aParamBox,"Impressão Etiqueta ",@aRet)
      _xdProduto := aRet[01]
      _xdDescri  := aRet[02]
	   _ndExp  := aRet[03]
	   _ndPeso := aRet[04]
	   _cdCorr := aRet[05]
	   _xdEnsaio  := aRet[06]
      _xdTipo  := if( ValType(aRet[07])=="N", aTipos[aRet[07]] , aRet[07])
      _ldTp    := If( ValType(aRet[08])=="N",aTpEtq[aRet[08]] , aRet[08] ) == "N/A"
      _cdCB0 := "" // aRet[10]

      Private _nCopy := aRet[09]
      Private cModel := "Z4M"

      u_AACOR01B(_ndExp, _ndPeso, _cdCorr, _xdEnsaio, _xdProduto, _xdTipo, _ldTp,_xdDescri,_nCopy,_cdCB0)
      /*
	  iF aRet[07] == 2
	     u_AACOR01B(_ndExp,_ndPeso,_cdCorr,_xdEnsaio,_xdProduto,_xdTipo)
	  Else
	     u_AACOR01A(_ndExp,_ndPeso,_cdCorr,_xdEnsaio,_xdProduto,_xdTipo)
	  EndIf
	   */
   Endif

Return Nil

//Imprime Etiqueta Aprovado / Reprovado
User Function AACOR01A(_ndExpessura,_ndPeso,_ndCorrida,_xdEnsaio,_xdProduto,_xdTipo,_xdDescri)
   Local _xdEtqQ := ""        
Return PrintEtq(_xdEtqQ,_ndExpessura,_ndPeso,_ndCorrida,_xdEnsaio,_xdProduto,_xdTipo,_xdDescri)

User Function AAESTR7A()
   lApv := .F.
   /*if mv_par01 != SB1->B1_COD
    SB1->(dbSetOrder(1))
    SB1->(dbSeek(xFilial('SB1') + mv_par01))   
   EndIf

    if "TELA"$Alltrim(SB1->B1_DESC) .And.  "COLUNA"$Alltrim(SB1->B1_DESC)
            _xdDescricao := "TELA COLUNA"
            lApv := .T.
    Elseif "TELA"$Alltrim(SB1->B1_DESC) .And.  "PAINEL"$Alltrim(SB1->B1_DESC)
            _xdDescricao := "TELA PAINEL"
            lApv := .T.
    Elseif "TRELICA"$Alltrim(SB1->B1_DESC) //.And.  "PAINEL"$Alltrim(SB1->B1_DESC))
            _xdDescricao := "TRELIÇA"
            lApv := .T. 
    Else
        _xdDescricao := "VERGALHÃO CA 60"
    EndIf
    */
    mv_par02 :=  GetDescric(mv_par01)
    //mv_par02 := _xdDescricao

    _ndExp := 0
    SB5->(dbSetOrder(1))
    IF SB5->(dbSeek(xFilial('SB5') + SB1->B1_COD ))       
        _ndExp := SB5->B5_ESPESS       
    EndIf

    If Empty(_ndExp)
       cdVal := ""
       For _xdI := 01 To Len(Sb1->B1_DESC) - 1         
           IF "MM" == SUBSTR(SB1->B1_DESC,_xdI,2)
               For _xdK := _xdI - 01 To 1 step - 1
                   iF substr(SB1->B1_DESC,_xdK,1) == " " .And. _xdK < _xdI -1
                      cdVal := SubStr(SB1->B1_DESC,_xdK, _xdI - _xdK)
                      _xdK := 0
                      _xdI := Len(SB1->B1_DESC) + 1
                   EndIf
               Next
           EndIf
       Next
       Begin Sequence
          _ndExp := Val(cdVal)
       Recover
          _ndExp := 0
       End Sequence
    EndIf

    If lAPV 
       mv_par08 := 01
    EndIf

    mv_par03 := _ndExp
Return .T.

//Imprime Etiqueta Normal Sem Aprovado / Reprovado
User Function AACOR01B(_ndExpessura,_ndPeso,_ndCorrida,_xdEnsaio,_xdProduto,_xdTipo, _ldTp,_xdDescri,_nCopy,_cdCB0)
   Local _xdEtqN := ""

   Default _xdDescri := GetDescric(_xdProduto)

   cEnd := Chr(13)+Chr(10)
   _xdEtqN += "I8,A,001" + cEnd
   _xdEtqN += "" + cEnd
   _xdEtqN += ""  + cEnd
   _xdEtqN += "Q919,024" + cEnd
   _xdEtqN += "q831"  + cEnd
   _xdEtqN += "rN"  + cEnd
   _xdEtqN += "S3"  + cEnd
   _xdEtqN += "D7"  + cEnd
   _xdEtqN += "ZT"  + cEnd
   _xdEtqN += "JF"  + cEnd
   _xdEtqN += "O"  + cEnd
   _xdEtqN += "R136,0"  + cEnd
   _xdEtqN += "f100"  + cEnd
   _xdEtqN += "N"  + cEnd
 
   _xdEtqN += 'A400,560,2,3,1,1,N,"CNPJ:05.477.207/0001-75"'  + cEnd
 
   _xdEtqN += 'A524,540,2,f,1,1,N,"AMZ  60"'  + cEnd
   _xdEtqN += 'A244,532,2,c,1,1,N,"Ø"'  + cEnd
   _xdEtqN += 'A210,540,2,e,1,1,N,"[DIAMETRO]mm"'  + cEnd
   _xdEtqN += 'A524,480,2,f,1,1,N,"[DESCRICAO]"'  + cEnd
   _xdEtqN += 'A525,410,2,b,1,1,N,"ABNT NBR 7480:2007"'  + cEnd
   _xdEtqN += 'A528,360,2,c,1,1,N,"CORRIDA N° : [CORRIDA]"'  + cEnd
   _xdEtqN += 'A530,310,2,e,1,1,N,"[TIPO]"'  + cEnd
   _xdEtqN += 'A235,310,2,e,1,1,N,"[PESO] Kg"'  + cEnd
   _xdEtqN += 'A246,250,2,e,1,1,N,"[PRODUTO]"'  + cEnd
   _xdEtqN += 'A532,250,2,e,1,1,N,"Codigo"'  + cEnd
   _xdEtqN += 'B532,180,2,1B,1,3,59,N,"[CODBARRA]"'  + cEnd
   _xdEtqN += 'A534,117,2,2,1,1,N,"[CODBARRA]"'  + cEnd
   if _ldTp
        _xdEtqN += 'B532,75,2,1B,1,3,59,N,"[CODBARRA]"'  + cEnd
        _xdEtqN += 'A534,17,2,2,1,1,N,"[CODBARRA]"'  + cEnd

         //Diego Comentario - Adicao do Cod CB0
        //_xdEtqN += 'A534,17,2,2,1,1,N,"[CODBARRA]/' + _cdCB0 + ''  + cEnd        
   EndIf
   _xdEtqN += "P1" + cEnd
   _xdEtqN += Chr(13)+Chr(10)
    For _xdJ := 01 To _nCopy
      PrintEtq(_xdEtqN,_ndExpessura,_ndPeso,_ndCorrida,_xdEnsaio,_xdProduto,_xdTipo,_xdDescri)
    Next
Return
Static Function GetDescric(xdProd)

   if xdProd != SB1->B1_COD
        SB1->(dbSetOrder(1))
        SB1->(dbSeek(xFilial('SB1') + xdProd))   
   EndIf

/*    if "TELA"$Alltrim(SB1->B1_DESC) .And.  "COLUNA"$Alltrim(SB1->B1_DESC)
            _xdDesc := "TELA COLUNA"
            lApv := .T.
    Elseif "TELA"$Alltrim(SB1->B1_DESC) .And.  "PAINEL"$Alltrim(SB1->B1_DESC)
            _xdDesc := "TELA PAINEL"
            lApv := .T.
    Elseif "TRELICA"$Alltrim(SB1->B1_DESC) //.And.  "PAINEL"$Alltrim(SB1->B1_DESC))
            _xdDesc := "TRELIÇA"
            lApv := .T. 
    Elseif "FIO"$Alltrim(SB1->B1_DESC) .And.  "MAQ"$Alltrim(SB1->B1_DESC) //.And.  "PAINEL"$Alltrim(SB1->B1_DESC))
            _xdDesc := "FIO MAQUINA"
            lApv := .T. 
    Else
        _xdDesc := "VERGALHÃO CA 60"
    EndIf  */
    _xdDesc := SUBSTR(SB1->B1_DESC,1,15)

Return _xdDesc
Static Function PrintEtq(_xdEtq, _ndExpessura,_ndPeso,_xdCorrida, _xdEnsaio,_xdProduto,_xdTipo,_xdDescricao)
   Local _xdCodBar := ""
   
   _xdCodBar += "789" //01
   _xdCodBar += StrZero(_ndExpessura*100,4)//02 (alterado francisco torres antes_ndExpessura*100,3)
   _xdCodBar += " "//03
   _xdCodBar += Right("000000"+_xdEnsaio,6)//04
   _xdCodBar += Right("000000000"+_xdCorrida,9)//05
   _xdCodBar += " "//06
   _xdCodBar += Left(Alltrim(_xdProduto),3) + SubStr(Alltrim(_xdProduto),6)//03
   _xdCodBar += StrZero(_ndPeso*10,7)
   _xdCodBar += StrZero(Day(dDataBase),2) + StrZero(Month(dDataBase),2) + Right(StrZero(Year(dDataBase),4),2)
   //_xdCodBar += 
   
   _xdEtq := StrTran(_xdEtq,"[PESO]", Transform(_ndPeso,"@E 999,999.9") )
   _xdEtq := StrTran(_xdEtq,"[DIAMETRO]", Alltrim(Str(_ndExpessura)) )
   _xdEtq := StrTran(_xdEtq,"[CORRIDA]", _xdCorrida )   
   _xdEtq := StrTran(_xdEtq,"[ENSAIO]" , _xdEnsaio )
   _xdEtq := StrTran(_xdEtq,"[PRODUTO]" , _xdProduto)
   _xdEtq := StrTran(_xdEtq,"[TIPO]"   , _xdTipo )
   _xdEtq := StrTran(_xdEtq,"[DESCRICAO]"   , _xdDescricao )
   
   _xdEtq := StrTran(_xdEtq,"[CODBARRA]" , _xdCodBar )
   _aModel:= {}
aAdd(_aModel,'S300')
//aAdd(_aModel,'S500-6')
//aAdd(_aModel,'S500-8')
//aAdd(_aModel,'Z105S-6')
//aAdd(_aModel,'Z105S-8')
//aAdd(_aModel,'Z160S-6')
//aAdd(_aModel,'Z160S-8')
//aAdd(_aModel,'Z140XI')
aAdd(_aModel,'S600')
aAdd(_aModel,'Z4M')
//aAdd(_aModel,'Z90XI')
//aAdd(_aModel,'Z170XI')
aAdd(_aModel,'ZEBRA')
//aAdd(_aModel,'QL320')
/*
aAdd(_aModel,'ELTRON')
aAdd(_aModel,'TLP 2722')
aAdd(_aModel,'TLP 2742')
aAdd(_aModel,'TLP 2844')
aAdd(_aModel,'TLP 3742')
aAdd(_aModel,'C4-8')
*/
//For _xdI := 01 To Len(_aModel)
   //alert('Imprimindo Modelo' + cModel)
   //MsCbPrinter(cModel,"LPT1",,,.F.,,,,)
   MSCBPRINTER(cModel,"LPT1", , , , , , , , )
   MsCbChkStatus(.F.)
   
   MSCBWRITE(_xdEtq)
   
   //MSCBEND()
   MsCbClosePrinter()
   //alert('Fim Impressao Modelo' + cModel )
//Next
   
Return