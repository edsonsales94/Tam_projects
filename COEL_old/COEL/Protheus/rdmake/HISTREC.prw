#include "rwmake.ch"        

/*/

ฑฑษอออออออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa      ณ PEDCOM_DATA                                    บ Data ณ 10/05/2010  บฑฑ
ฑฑฬอออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricao     ณ Rotina de Altera็ใo de datas no pedido de vendas                    บฑฑ
ฑฑฬอออออออออออออออุออออออออออออออออออออออหอออออออออัออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Desenvolvedor ณ Andre Rodrigues        บ Empresa ณ Oliminet/COEL                    บฑฑ
ฑฑฬอออออออออออออออุออออออออออออหออออออออัสออออออหออฯออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Linguagem     ณ eAdvpl     บ Versao ณ 8     บ Sistema ณ Microsiga                   บฑฑ
ฑฑฬอออออออออออออออุออออออออออออสออออออออฯอออออออสอออออออออออออออออออออออออออออออออออออออนฑฑ
/*/

User Function HISTREC()      

xReg := "RECEB. TITULO "+ AllTrim(SE1->E1_NUM)+" - "+ AllTrim(SE1->E1_NOMCLI)

Return(xReg)    

User Function HISTPAG()      

xReg := "PAGTO DOC. "+ AllTrim(SE2->E2_NUM)+" - "+ AllTrim(SE2->E2_NOMFOR)

Return(xReg)