#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 16/09/02

User Function cpcp01i()        // incluido pelo assistente de conversao do AP6 IDE em 16/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NCUSTOUNIT,_NCUSTOITEM,_NCUSTOTOTAL,_CVALORIZA,I,CROT")
SetPrvt("_CD3_TM,_CPROD,_NQUANT,_NPOS,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CPCP01I  ³ Autor ³Ricardo Correa de Souza³ Data ³20/03/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valoriza Apontamento de Producoes de Produto Intermediario ³±±
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

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

if SM0->M0_CODIGO == "03"
   return( 0 )
endif

_nCustoUnit  := 0             //----> custo unitario do componente
_nCustoItem  := 0             //----> custo do item baseado na quantidade
_nCustoTotal := 0             //----> custo total do produto
_cValoriza   := ""            //----> indica se o TM e valorizado ou nao

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e indices utilizados no processamento                            *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cAlias:= alias()
DbSelectArea("SG1")     // Estrutura de Produtos
DbSetOrder(1)           // Filial + Produto Pai

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Inicio do Processamento                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

i := 0
cRot := UPPER(AllTrim(ProcName(i)))
While !Empty(cRot)
	If cRot $ "A240INCLUI"       //----> Incluir Internos Modelo 1
		_cD3_TM      := M->D3_TM
		_cProd       := M->D3_COD
		_nQuant      := M->D3_QUANT
		_nCustoTotal := M->D3_CUSTO1
	ElseIf cRot $ "A241INCLUI"   //----> Incluir Internos Modelo 2
		_cD3_TM      := cTM
		_npos        := ascan(aHeader,{|x| upper(alltrim(x[2]))="D3_COD"})
		_cProd       := aCols[n,_npos]
		_npos        := ascan(aHeader,{|x| upper(alltrim(x[2]))="D3_QUANT"})
		_nQuant      := aCols[n,_npos]
		_npos        := ascan(aHeader,{|x| upper(alltrim(x[2]))="D3_CUSTO1"})
		_nCustoTotal := aCols[n,_npos]
	ElseIf cRot $ "A250INCLUI"   //----> Incluir Movimento de Producao
		_cD3_TM      := M->D3_TM
		_cProd       := M->D3_COD
		_nQuant      := M->D3_QUANT
		_nCustoTotal := M->D3_CUSTO1
    ElseIf cRot $ "U_APONTAOP"   //----> Apontamento por Código de Barras
		_cD3_TM      := M->D3_TM
 		_cProd       := M->D3_COD
  		_nQuant      := M->D3_QUANT
		_nCustoTotal := M->D3_CUSTO1
	ElseIf cRot $ "U_EXPORT"	
         return( 0 )
  	EndIf
	i := i + 1
	cRot := UPPER(AllTrim(ProcName(i)))
EndDo

_cValoriza   := Posicione("SF5",1,xFilial("SF5")+_cD3_TM,"F5_VAL")

If _cValoriza == "S"
   _nCustoTotal := 0
 
   _nCustoTotal:= Posicione("SB2",1,xFilial("SB2")+_cProd,"B2_CM1")

   _nCustoTotal:= _nQuant * _nCustoTotal
EndIf

DbSelectArea(_cAlias)
Return(_nCustoTotal)
