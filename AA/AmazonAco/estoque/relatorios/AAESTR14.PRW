//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#include "tbiconn.ch"
//Constantes
#Define STR_PULA    Chr(13)+Chr(10)
 /*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ Fun??o    ¶ AAESTR14   ¶ Autor ¶ WILLIAMS MESSA       ¶ Data ¶ 15/01/2021 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ Descri??o ¶ AAESTR14 - WorkFlow de Movimentos do SD3                      ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
???????????????????????????????????????????????????????????????????????????????*/ 
 
User Function AAESTR14()
   
    Local aArea        := GetArea()
    Local cQuery       := ""
    Local oFWMsExcel   := Nil
    Local oExcel       := Nil
    Local cArquivo     := "\CPROVA\"+"movimentos"+dtos(date()-1)+".xls"
    Local cxAba        := "Relatorios Movimentos AA  S"
    Local xdTb2        := Nil
    Local _cxMail      := ""
    Local cNome        :=""
    Private dData	   := DATE()
	
	//williams em 11/11
    RpcClearEnv()
    RpcSetType(3)
	Prepare Environment Empresa '01' Filial '01'  

    ConOut(Padc("Start - Movimentos Estoque - AmazonAço - Protheus  ==> "+Dtoc(dData)+" "+Time(),100))
	
	_cxMail := SuperGetMv("MV_XMOVML",.F.,"qualidade@amazonaco.com.br")  
    //SuperGetMv("MV_XESUPER",.F.,"saldoestoque@amazonaco.com.br;williams.messa@amazonaco.com.br,francisco@amazonaco.com.br")//
    //_cxMail := SuperGetMv("MV_XESUPER",.F.,"williams.messa@amazonaco.com.br;francisco@amazonaco.com.br")//
 
    //Pegando os dados
    cQuery := " SELECT *FROM VW_AAESTR14 WHERE DT_EMISSAO = '"+DTOS(DATE()-1)+"'"  + STR_PULA
    xdTb2  := MpSysOpenQUery(cQuery)
     
    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()
     	 
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cxAba) //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable(cxAba,cxAba)
        //Criando Colunas
        oFWMsExcel:AddColumn(cxAba,cxAba,"FILIAL"              ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"TP_MOVIMENTO"        ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"RE_DE_TM"            ,1,1)  
        oFWMsExcel:AddColumn(cxAba,cxAba,"RE_DE_TM_1"          ,1,1)       
        oFWMsExcel:AddColumn(cxAba,cxAba,"TIPO_MOV"            ,1,1)
        oFWMsExcel:AddColumn(cxAba,cxAba,"PRODUTO"             ,1,1)                                                                             
        oFWMsExcel:AddColumn(cxAba,cxAba,"APONTAMENTO_SUCATA"  ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"APONTAMENTO_ESTOQUE" ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"HORA_INTEG"          ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"TURNO"               ,1,1)          
        oFWMsExcel:AddColumn(cxAba,cxAba,"QUANTIDADE"          ,2,2)             
        oFWMsExcel:AddColumn(cxAba,cxAba,"UNIDADE"             ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"TIPO_RE_DE"          ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"ARMAZEM"             ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"ENDERECO"            ,1,1)                
        oFWMsExcel:AddColumn(cxAba,cxAba,"DT_EMISSAO"          ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"DOCUMENTO"           ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"ORD_PRODUCAO"        ,1,1)   
        oFWMsExcel:AddColumn(cxAba,cxAba,"TIPO"                ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"ESTORNADO"           ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"GRUPO"               ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"SEQUENCIAL"          ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"USUARIO"             ,1,1)                   
        oFWMsExcel:AddColumn(cxAba,cxAba,"LOTE"                ,1,1)                 
        oFWMsExcel:AddColumn(cxAba,cxAba,"RECURSO"             ,1,1) 
        oFWMsExcel:AddColumn(cxAba,cxAba,"RECURSO2"            ,1,1)                       
        oFWMsExcel:AddColumn(cxAba,cxAba,"GRP_RECURSO"         ,1,1)
     
        While !(xdTb2)->(EoF())
            oFWMsExcel:AddRow(cxAba,cxAba,{;
				 (xdTb2)->FILIAL,;	
				 (xdTb2)->TP_MOVIMENTO,;	
				 (xdTb2)->RE_DE_TM,;	
				 (xdTb2)->RE_DE_TM_1,;	
				 (xdTb2)->TIPO_MOV,;
				 (xdTb2)->PRODUTO,;
				 (xdTb2)->APONTAMENTO_SUCATA,;
                 (xdTb2)->APONTAMENTO_ESTOQUE,;	
				 (xdTb2)->HORA_INTEG,;	
				 (xdTb2)->TURNO,;	
				 (xdTb2)->QUANTIDADE,;	
				 (xdTb2)->UNIDADE,;
				 (xdTb2)->TIPO_RE_DE,;	
				 (xdTb2)->ARMAZEM,;
                 (xdTb2)->ENDERECO,;
                 (xdTb2)->DT_EMISSAO,;
                 (xdTb2)->DOCUMENTO,;
                 (xdTb2)->ORD_PRODUCAO,;
                 (xdTb2)->TIPO,;
                 (xdTb2)->ESTORNADO,;
                 (xdTb2)->GRUPO,;
                 (xdTb2)->SEQUENCIAL,;
                 Upper((Alltrim((xdTb2)->USUARIO)))+"-"+Upper(UsrFullName(AllTrim((xdTb2)->USUARIO))),;
                 (xdTb2)->LOTE,;
                 (xdTb2)->RECURSO,;
                 (xdTb2)->RECURSO2,;
                 (xdTb2)->GRP_RECURSO;
            })
         
            //Pulando Registro
            (xdTb2)->(DbSkip())
        EndDo
        
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
    
    (xdTb2)->(DbCloseArea())
    RestArea(aArea)
    
    u_AAFSEMAIL(_cxMail,"Relatorio de Movimentação AA "+dtoc(date()),"<b> Segue Movimentos de Estoque <b>",cArquivo)

    ConOut(Padc("End - JOB Movimentos Estoque - AmazonAço - Protheus  ==> "+Dtoc(dData)+" "+Time(),100))
    RpcClearEnv() 
Return
