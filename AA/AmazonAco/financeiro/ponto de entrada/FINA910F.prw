#Include 'Protheus.ch'
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ FINA910F   ¶ Autor ¶ WILLIAMS MESSA       ¶ Data ¶ 12/09/2019 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Ponto de Entrada para indicar qual o Banco a ser usado na .   ¶¶¶
¶¶+-----------+ conciliação SITEF                                              ¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 

User function FINA910F()
 
Local aRet    := {} // Array com os dados do Banco, Agência e Conta Corrente a serem gravadas na tabela SE1 e SE5.
Local cCodEmp := FWCodEmp()
 
 If cCodEmp =="01"
    aAdd (aRet,PADR("341",TamSX3("E1_PORTADO")[1])) // Numero do banco que serah gravado na SE1->E1_PORTADO
    aAdd (aRet,PADR("1677",TamSX3("E1_AGEDEP")[1])) // Numero da agencia que serah gravada no campo SE1->E1_AGENCIAA
    aAdd (aRet,PADR("11597-2   ",TamSX3("E1_CONTA")[1]))  // Numero da conta corrente
ElseIf cCodEmp =="05"
    aAdd (aRet,PADR("341",TamSX3("E1_PORTADO")[1])) // Numero do banco que serah gravado na SE1->E1_PORTADO
    aAdd (aRet,PADR("1677",TamSX3("E1_AGEDEP")[1])) // Numero da agencia que serah gravada no campo SE1->E1_AGENCIAA
    aAdd (aRet,PADR("56042-5   ",TamSX3("E1_CONTA")[1]))  // Numero da conta corrente
ElseIf cCodEmp =="06"
    aAdd (aRet,PADR("341",TamSX3("E1_PORTADO")[1])) // Numero do banco que serah gravado na SE1->E1_PORTADO
    aAdd (aRet,PADR("1677",TamSX3("E1_AGEDEP")[1])) // Numero da agencia que serah gravada no campo SE1->E1_AGENCIAA
    aAdd (aRet,PADR("62878-4   ",TamSX3("E1_CONTA")[1]))  // Numero da conta corrente
Endif

Return aRet
