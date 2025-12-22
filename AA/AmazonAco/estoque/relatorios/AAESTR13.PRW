//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#include "tbiconn.ch"
//Constantes
#Define STR_PULA    Chr(13)+Chr(10)
 
    
User Function AAESTR13()
   
    Local aArea        := GetArea()
    Local cQuery       := ""
    Local oFWMsExcel   := Nil
    Local oExcel       := Nil
    Local cArquivo     := "\CPROVA\"+"estoque"+dtos(date())+".xls"
    Local cxAba        := "Estoque"
    Local xdTb2        := Nil
    Local _cxMail      := ""
    Private dData	   := DATE()
	
	//williams em 11/11
    RpcClearEnv()
    RpcSetType(3)
	Prepare Environment Empresa '01' Filial '01'  

    ConOut(Padc("Start - JOB Saldos - AmazonAço - Protheus  ==> "+Dtoc(dData)+" "+Time(),100))
	
	_cxMail := SuperGetMv("MV_XESUPER",.F.,"saldoestoque@amazonaco.com.br;williams.messa@amazonaco.com.br,francisco@amazonaco.com.br")//
    //_cxMail := SuperGetMv("MV_XESUPER",.F.,"williams.messa@amazonaco.com.br;francisco@amazonaco.com.br")//
 
    //Pegando os dados
    cQuery := " EXEC GETSALDOS "  + STR_PULA
    xdTb2  := MpSysOpenQUery(cQuery)
     
    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()
     	 
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cxAba) //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable(cxAba,cxAba)
        //Criando Colunas
        oFWMsExcel:AddColumn(cxAba,cxAba,"Empresa"   ,1,1)
		oFWMsExcel:AddColumn(cxAba,cxAba,"Filial"    ,1,1) 
		oFWMsExcel:AddColumn(cxAba,cxAba,"Grupo Cod" ,1,1)
		oFWMsExcel:AddColumn(cxAba,cxAba,"Grupo Desc",1,1) 
		oFWMsExcel:AddColumn(cxAba,cxAba,"Produto Cd",1,1) 
		oFWMsExcel:AddColumn(cxAba,cxAba,"Produto Dc",1,1) 
		oFWMsExcel:AddColumn(cxAba,cxAba,"Armazem"   ,1,1)
        oFWMsExcel:AddColumn(cxAba,cxAba,"Descri.Arm",1,1) 
		oFWMsExcel:AddColumn(cxAba,cxAba,"Endereco"  ,1,1) 
		oFWMsExcel:AddColumn(cxAba,cxAba,"Lote"      ,1,1) 
		oFWMsExcel:AddColumn(cxAba,cxAba,"Tipo"      ,1,1) 
		oFWMsExcel:AddColumn(cxAba,cxAba,"UM"        ,1,1) 
		oFWMsExcel:AddColumn(cxAba,cxAba,"Ult Fech"  ,2,2)
		oFWMsExcel:AddColumn(cxAba,cxAba,"Quantidade",2,2) 
		
     
        While !(xdTb2)->(EoF())
            oFWMsExcel:AddRow(cxAba,cxAba,{;
				 (xdTb2)->BF_EMPRESA,;	
				 (xdTb2)->BF_FILIAL,;	
				 (xdTb2)->BF_GRUPO,;	
				 (xdTb2)->BF_GDESC,;	
				 (xdTb2)->BF_PRODUTO,;
				 (xdTb2)->BF_PDESC,;
				 (xdTb2)->BF_LOCAL,;
                 (xdTb2)->NNR_DESCRI,;	
				 (xdTb2)->BF_LOCALIZ,;	
				 (xdTb2)->BF_LOTECTL,;	
				 (xdTb2)->BF_TIPO,;	
				 (xdTb2)->BF_UM,;
				 (xdTb2)->BF_UFECH,;	
				 (xdTb2)->BF_QUANT;
            })
         
            //Pulando Registro
            (xdTb2)->(DbSkip())
        EndDo
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
 
    (xdTb2)->(DbCloseArea())
    RestArea(aArea)
    
    u_AAFSEMAIL(_cxMail,"Saldos Produtos "+dtoc(date()),"<b>Segue Saldo das Empresas <b>",cArquivo)

    ConOut(Padc("End - JOB Saldos - AmazonAço - Protheus  ==> "+Dtoc(dData)+" "+Time(),100))
    RpcClearEnv()
Return   
