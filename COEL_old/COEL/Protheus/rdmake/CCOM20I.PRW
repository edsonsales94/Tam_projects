#include "rwmake.ch"        

User Function cCOM20i()     

SetPrvt("_CPERG,AREGS,I,J,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CCOM20I  ³ Autor ³Ricardo Correa de Souza³ Data ³21/09/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Importa Notas Fiscais de Saida SR para Recebimento em SP   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

Processa({||ImpNota()},"Importacao das Notas Fiscais de Sao Roque")
Return() 


Static Function ImpNota()

_cPerg   := "COM20I"

//ValidPerg()     //----> Cria grupo de perguntas SX1

If !Pergunte(_cPerg,.t.)
    Return
EndIf

DbSelectArea("SF2")
//DbSetOrder(6)
dbOrderNickName("SF26")
If ! DbSeek("02"+Dtos(MV_PAR01))
    MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,15))+" nao existe notas fiscais de saida em Sao Roque no dia "+Dtoc(mv_par01)+". Comunique imediatamente o Departamento de Informatica.","Importacao de Notas Fiscais","Stop")
Else
    //----> a filial esta chumbada, pois so interessa registros de Sao Roque

    ProcRegua(LastRec())

    While Eof() == .f. .And. SF2->F2_FILIAL == "02" .And. Dtos(SF2->F2_EMISSAO) == Dtos(mv_par01)

        IncProc("Processando Nota Fiscal "+SF2->F2_DOC+"/"+SF2->F2_SERIE)

        //----> filtrando somente notas fiscais que ainda nao foram importadas
        If !Empty(F2_CLIMPSP)
            MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,15))+" a Nota Fiscal "+SF2->F2_DOC+"/"+SF2->F2_SERIE+" ja foi importada.","Validacao de Importacao","Alert")
            DbSkip()
            Loop
        EndIf

        //----> filtrando somente notas de saida de Sao Roque para Sao Paulo
        If !SF2->F2_CLIENTE+SF2->F2_LOJA $ "00064901"
            DbSkip()
            Loop
        EndIf

	// verifica se esta nf saida ja foi importada para mudar serie na 2a.
	// importacao, desta forma nao havera duplicidade de notas entrada
	DbSelectArea("SF1")
	DbSetOrder(2)
	DbSeek("01"+"00006702"+SF2->F2_DOC+"ZZZ",.t.)
	dbskip(-1)
	if F1_FILIAL == "01" .and. F1_FORNECE+F1_LOJA == "00006702" .and. F1_DOC == SF2->F2_DOC
	   _cSerie:= "1" + chr( asc(subs(F1_SERIE,2,1)) + 1 )
	else
	   _cSerie:= "2"
	endif

        DbSelectArea("SD2")
        DbSetOrder(3)
        DbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE)

        While SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE == SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE
    
            //----> filtrando somente itens que ainda nao foram importados
            If !Empty(SD2->D2_CLIMPSP)
                DbSkip()
                Loop
            EndIf

            //----> gerando os itens de entrada para pre-nota
            DbSelectArea("SD1")
            RecLock("SD1",.t.)
              SD1->D1_FILIAL    :=  "01"
              SD1->D1_COD       :=  SD2->D2_COD
              SD1->D1_UM        :=  SD2->D2_UM
              SD1->D1_SEGUM     :=  SD2->D2_SEGUM
              SD1->D1_QUANT     :=  SD2->D2_QUANT
              SD1->D1_VUNIT     :=  SD2->D2_PRCVEN
              SD1->D1_TOTAL     :=  SD2->D2_TOTAL
              SD1->D1_FORNECE   :=  "000067"
              SD1->D1_LOJA      :=  "02"
              SD1->D1_LOCAL     :=  SD2->D2_LOCAL
              SD1->D1_DOC       :=  SD2->D2_DOC
	          SD1->D1_SERIE  	:=  _cSerie
              SD1->D1_EMISSAO   :=  SD2->D2_EMISSAO
              SD1->D1_DTDIGIT   :=  dDataBase
              SD1->D1_GRUPO     :=  SD2->D2_GRUPO
              SD1->D1_TIPO      :=  SD2->D2_TIPO
              SD1->D1_QTSEGUM   :=  SD2->D2_QTSEGUM
              SD1->D1_ITEM      :=  SD2->D2_ITEM
              SD1->D1_DTVALID   :=  SD2->D2_DTVALID          
              SD1->D1_CLASFIS   := "0"
            MsUnLock()
    
            DbSelectArea("SD2")
            RecLock("SD2",.f.)
	     SD2->D2_CLIMPSP   :=  "S"
            MsUnLock()
            DbSkip()
        EndDo
    
        //----> gerando o cabecalho de entrada para pre-nota
        DbSelectArea("SF1")
        RecLock("SF1",.t.)
          SF1->F1_FILIAL    :=  "01"
          SF1->F1_DOC       :=  SF2->F2_DOC
	  SF1->F1_SERIE     :=	_cSerie
          SF1->F1_FORNECE   :=  "000067"
          SF1->F1_LOJA      :=  "02"
          SF1->F1_EMISSAO   :=  SF2->F2_EMISSAO
          SF1->F1_EST       :=  SF2->F2_EST
          SF1->F1_TIPO      :=  "N"
          SF1->F1_DTDIGIT   :=  dDataBase
          SF1->F1_FORMUL    :=  "N"
          SF1->F1_ESPECIE   :=  "NFE"
        MsUnLock()
    
        DbSelectArea("SF2")
        RecLock("SF2",.f.)
	 SF2->F2_CLIMPSP   :=  "S"
        MsUnLock()
        DbSkip()
    EndDo
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Fim do Programa                                                            *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)

aRegs :={}
Aadd(aRegs,{_cPerg,"01","Data Saida Sao Roque    ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
    If !DbSeek(_cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    EndIf
Next
Return

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Fim da Funcao ValidPerg                                                    *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

