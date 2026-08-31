//PEGA OS DADOS DO SIGAMAT

User Function __DADOSMAT(__cFilial)
	Local _cEmpAnt := SM0->M0_CODIGO
	Local _cFilAnt := SM0->M0_CODFIL
	Local cRet := ""
	SM0->( dbSeek( _cEmpAnt + __cFilial ) )
	//EXEMPLO: SM0->( dbSeek( "01" + "02" ) )



	cRet := SM0->M0_FILIAL     

	//RETORNAR À EMPRESA E FILIAL CORRENTE
	SM0->( dbSeek( _cEmpAnt + _cFilAnt ) )

return cRet