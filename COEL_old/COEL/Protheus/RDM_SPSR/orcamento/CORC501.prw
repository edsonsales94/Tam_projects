#include "rwmake.ch"     

User Function Corc50i()  


SetPrvt("NPOS,_NPRCVEN,_NPRUNIT,_NPERCCOMI,_NPERCDESC,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CORC50I  ³ Autor ³ANDRE RODRIGUES        ³ Data ³29/07/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Calculo do Percentual de Comissao por Item                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Gatilho Disparado no Campo CK_PRCVEN                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/


//nPos       := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "CK_PRCVEN"})
//_nPrcVen   := aCols[n,nPos]
_nPrcVen   := TMP1->CK_PRCVEN

//nPos       := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "CK_PRUNIT"})
//_nPrUnit   := aCols[n,nPos]
_nPrUnit   := TMP1->CK_PRUNIT

//nPos       := Ascan(aHeader,{|x|upper(alltrim(x[2])) == "CK_COMIS1"})
//_nPercComi := aCols[n,nPos]
_nPercComi := TMP1->CK_COMIS1

//----> verifica se trata-se de pedidos normais
//If  M->C5_TIPO == "N"

    _nPercDesc := ABS((((_nPrcVen/_nPrUnit)-1)*100)*1)

    //----> tabela de descontos maximos/comissoes
    DbSelectArea("SZ4")
    DbSetOrder(2)
    DbGoTop()

    While Eof() == .f.
        If _nPercDesc < SZ4->Z4_CLMAX
            _nPercComi := SZ4->Z4_CLCOM
        EndIf
        DbSkip()
    EndDo

//Endif

Return(_nPercComi)

