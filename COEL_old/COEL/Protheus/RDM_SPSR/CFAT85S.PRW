#include "rwmake.ch"        

User Function Cfat85s()      

SetPrvt("CPERG,ESTRUTURA,CARQTRAB,CINDEX,CCHAVE,CFILTRO")
SetPrvt("_NQTDTRA,_NCUSMED,_NCUSSTD,_CPROD,_CCFO,CARQENT")
SetPrvt("CARQSAI,AREGS,I,J,")
                                          
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CFAT85S  ³ Autor ³ADILSON TAKESHIMA      ³ Data ³20/06/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Exporta Dados de Transferencia Sao Roque                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
*---------------------------------------------------------------------------*
* Parametros Utilizados                                                     
*                                                                           
* mv_par01      ----> Do Produto                                     
* mv_par02      ----> Ate o Produto                                        
* mv_par03      ----> Data Inicial                                          
* mv_par04      ----> Data Final                                           
* mv_par05      ----> CFO
* mv_par06      ----> Nome do Arquivo Dbf                                  
*                                                                           
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
* Estrutura do Arquivo a ser Exportado                                      
*---------------------------------------------------------------------------*

cPerg:= "FAT85S"

ValidPerg()     //----> cria grupos de perguntas no arquivo SX1

If ! Pergunte(cPerg,.T.)
    Return
EndIf

Estrutura := {}

Aadd(Estrutura,{ "CFO"          ,"C",04,0 } )
Aadd(Estrutura,{ "CODIGO"       ,"C",08,0 } )
Aadd(Estrutura,{ "PRODUTO"      ,"C",30,0 } )
Aadd(Estrutura,{ "QUANT"        ,"N",12,2 } )
Aadd(Estrutura,{ "CUSMED"       ,"N",12,2 } )
Aadd(Estrutura,{ "TOTMED"       ,"N",12,2 } )
Aadd(Estrutura,{ "CUSSTD"       ,"N",12,4 } )
Aadd(Estrutura,{ "TOTSTD"       ,"N",12,4 } )

cArqTrab := MV_PAR06+".DBF"

DbCreate(cArqTrab,Estrutura)

//DbUseArea(.T.,__cRdd,cArqTrab,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )
DbUseArea(.T.,,cArqTrab,"TRB", NIL, .F. )

*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Exportacao de Dados Transferencia")
Return

Static Function RunProc()

DbSelectArea("SD2")
cIndex  := CriaTrab(Nil,.f.)
cChave  := "D2_FILIAL+D2_COD+DTOS(D2_EMISSAO)+D2_CF"
cFiltro := "D2_FILIAL == '02' .And. Dtos(D2_EMISSAO) >= '" + Dtos(mv_par03)
cFiltro := cFiltro + "' .And. Dtos(D2_EMISSAO) <= '" + Dtos(mv_par04) 
cFiltro := cFiltro + "' .And. D2_COD >= '" + MV_PAR01 + "' .AND. D2_COD <= '" + MV_PAR02
cFiltro := cFiltro + "' .And. ALLTRIM(D2_CF) $ '" + ALLTRIM(MV_PAR05) + "'"

//MSGBOX(CFILTRO)

IndRegua("SD2",cIndex,cChave,,cFiltro,"Indice Temporario")

ProcRegua(LastRec())

_nQtdTra := 0
_nCusMed := 0
_nCusStd := 0

While Eof() == .f.

    IncProc("Selecionando Nota "+SD2->D2_DOC)

    //----> filtrando somente intervalo de produtos informado no parametro
    //If SD2->D2_COD < mv_par01 .Or. SD2->D2_COD > mv_par02
	//DbSkip()
	//Loop
    //EndIf

    //----> filtrando somente intervalo de tes informado no parametro
    //If ! Alltrim(SD2->D2_CF) $ Alltrim(mv_par05)
	//DbSkip()
	//Loop
    //EndIf

    _cProd := SD2->D2_COD
    _cCfo  := SD2->D2_CF

    While SD2->D2_COD == _cProd
        If SD2->D2_CF == _cCfo
            _nQtdTra := _nQtdTra + SD2->D2_QUANT
        EndIf
        DbSkip()
    EndDo

    DbSelectArea("TRB")
    RecLock("TRB",.t.)
      TRB->CFO      := _cCfo
      TRB->CODIGO   := _cProd
      TRB->PRODUTO  := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_DESC")              
      TRB->QUANT    := _nQtdTra
      _nCusMed      := Posicione("SB2",1,"02"+_cProd,"B2_CM1")
      _nCusStd      := Posicione("SB1",1,"02"+_cProd,"B1_CUSTD")
      TRB->CUSMED   := _nCusMed
      TRB->TOTMED   := Round(_nQtdTra * _nCusMed,2)
      TRB->CUSSTD   := _nCusStd
      TRB->TOTSTD   := Round(_nQtdTra * _nCusStd,2)
    MsUnLock()

    _nQtdTra := 0
    DbSelectArea("SD2")
EndDo

DbSelectArea("TRB")
DbCloseArea()

cArqEnt := cArqTrab
cArqSai :="\EXP\"+cArqTrab

Copy File (cArqEnt) to (cArqSai)

Ferase(cArqEnt)

DbSelectArea("SD2")
RetIndex("SD2")

Return

*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*

Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Do Produto     ? ','mv_ch1','C',15, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'02','Ate o Produto  ? ','mv_ch2','C',15, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'03','Da Emissao     ? ','mv_ch3','D',08, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate Emissao    ? ','mv_ch4','D',08, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Contem os CFO  ? ','mv_ch5','C',30, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'06','Nome do Arquivo? ','mv_ch6','C',08, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})

    For i:=1 to len(aRegs)
        Dbseek(cPerg+strzero(i,2))
        If found() == .f.
            RecLock("SX1",.t.)
            For j:=1 to fcount()
                FieldPut(j,aRegs[i,j])
            Next
            MsUnLock()
        EndIf
    Next
EndIf

Return(nil) 

*---------------------------------------------------------------------------*
* Fim da Funcao ValidPerg                                                   
*---------------------------------------------------------------------------*
