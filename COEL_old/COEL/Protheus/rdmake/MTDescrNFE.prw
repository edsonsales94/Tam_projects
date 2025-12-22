#include "rwmake.ch"


User Function MTDescrNFE()

//MTDescrNFE ( < cNumRPS> , < cSerRPS> , < cCodCli> , < cLojaRPS> ) --> cDescr




Return()
/*Finalidade Compor a descrição dos serviços prestados na operação. 
Essa descrição será utilizada para a impressão do RPS e para geração 
do arquivo de exportação para a prefeitura.

Parâmetro [01] Número do RPS gerado (F3_NFISCAL)

Parâmetro [02] Série do RPS gerado

Parâmetro [03] Código do cliente

Parâmetro [04] Loja do cliente

Retorno String com a descrição a ser apresentada

Observações A string deverá ter, no máximo, 999 caracteres. Caso a 
descrição retornada pelo ponto de entrada ultrapasse esse limite, 
o programa irá reduzir o retorno em 999 caracteres.

Caso sejam necessárias quebras de linha na descrição a ser apresentada, 
inserir o caracter pipe "|" (chr124), porque, para o arquivo magnético 
de envio à prefeitura, é necessária a configuração de quebra de linha. 
Vale ressaltar que serão impressos 999 caracteres, incluindo as quebras 
de linha, ou seja, quanto mais quebras de linha forem configuradas, 
menos caracteres serão impressos, devido ao número de caracteres perdidos 
com a quebra.

Exemplo O ponto de entrada irá retornar quebras de linha da seguinte forma:

"Serviços prestados:|Lavagem|Polimento|"
*/




