

#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณCADSZA    บ Autor ณ AP6 IDE            บ Data ณ  14/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fonte do Cadastro Tabela de Repasse Fiscal                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออ
อออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
User Function CADSZA()


//ณ Declaracao de Variaveis                                             ณ

	Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".F." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

	Private cString := "SZA"

  	dbSelectArea(cString)
   dbSetOrder(1)

  	AxCadastro(cString,"Cadastro Tabela de Repasse Fiscal",cVldExc,cVldAlt)   


Return
