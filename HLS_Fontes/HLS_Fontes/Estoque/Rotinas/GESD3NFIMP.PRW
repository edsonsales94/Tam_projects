#include "totvs.ch"
#include "protheus.ch"
#include 'rwmake.ch'
#include 'topconn.ch'
#include "tbiconn.ch"
#include 'colors.ch'
#include 'font.ch'
#include "hbutton.ch"     
#include "ap5mail.ch"

/*/{protheus.doc}GESD3NFIMP
Gera a Transferência do Almoxarifado=11 (NFs Importação) para o Almoxarifado=10. Utilizando o Número da DI (Declaração de Importação) 
@author Ricardo Borges
@since 27/01/14
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GESD3NFIMP    º Autor ³Ricardo Borges º Data ³   27/01/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Gera a Transferência do Almoxarifado=11 (NFs Importação)   º±±
±±º          ³ para o Almoxarifado=10.									  º±±
±±º          ³ Utilizando o Número da DI (Declaração de Importação)       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HONDA LOCK                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                                                   
User Function GESD3NFIMP()	

SetPrvt("cPerg,nOpc_,cCad_,aSay_,aButt_,aCampos,lAbortPrint,TipoAfas,aArea_")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg       := "GSD3NI" // Nome do arquivo de perguntas do SX1
cCad_		:= ""
nOpc_		:= 0
aSay_		:= {}
aButt_		:= {}
aCampos 	:= {}
lAbortPrint := .F. 
TipoAfas    := ""       
aArea_      := GetArea()

//Processamento
cCad_		:= "** Gera a Transferência do Almoxarifado=11 (NFs Importação) para o Almoxarifado=10 **"

aAdd( aSay_, "Este programa tem como objetivo gerar uma Movimentação de  " )
aAdd( aSay_, "Transferência com informações das Notas de Importação " )
aAdd( aSay_, "utilizando o Número da DI (Declaração de Importação) " )

aAdd( aButt_, { 5,.T.,{|| Pergunte(cPerg,.T.)    }})
aAdd( aButt_, { 1,.T.,{|| FechaBatch(),nOpc_ := 1 }})
aAdd( aButt_, { 2,.T.,{|| FechaBatch()            }})

//Verifica Perguntas
//ValidPerg(cPerg)
Pergunte(cPerg,.F.)
                    
//Monta Tela Inicial
FormBatch( cCad_, aSay_, aButt_ )

If nOpc_ == 1
	Processa( {|| RunReport() }, "Processando..." )
Endif
        
Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RunReport ³ Autor ³Isamu Kawakami/JCGouveia³Data ³ 15.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Geracao da Planilha                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem  


		                    
    _cNumDI	    :=	mv_par01		
		                    
	/*
    _cFornec	:=	mv_par01
	_cLoja 		:=	mv_par02
	_DtIni		:=	mv_par03
	_DtFim		:=	mv_par04  
	*/
  
	If Select("TSD1") > 0
	   DBSelectArea("TSD1")
	   DBCloseArea()
	Endif
	
	//cQuery := " SELECT DISTINCT D2_FILIAL FILIAL, D2_NFORI NFORIG,D1_TES TESORIG,D1_DTDIGIT DTENTRADA, D1_EMISSAO DTEMISSAO,D1_QUANT QTDORIG, D1_TOTAL TOTORIG, D2_DOC NFDEVOL, D2_EMISSAO DTDEVOL, D2_TES TESDEVOL , D2_QUANT QTDEVOL, D2_TOTAL TOTDEVOL , D2_COD CODPRODUTO, D1_VUNIT CUSTOENTRA,  D1_ITEM ITEM, D1_FORNECE FORNECE, D1_LOJA LOJA "
	
	cQuery += " FROM " + RetSqlName("SD1") + " SD1 "
	
	//cQuery += " INNER JOIN " + RetSqlName("SD1") + " SD1 "
	                                               
	//cQuery += " ON D2_CLIENTE = D1_FORNECE AND D2_LOJA = D1_LOJA AND D2_NFORI = D1_DOC AND D2_SERIORI = D1_SERIE AND D2_COD = D1_COD "
	
	cQuery += " WHERE SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND "
	
	cQuery += " SD1.D1_FORNECE = '" + _cFornec + "' AND "
	
	//cQuery += " SD1.D1_FORNECE = '" + _cFornec + "' AND "
	
	//cQuery += " SD1.D1_LOJA    = '" + _cLoja   + "' AND "  
	
	//cQuery += " D1_DTDIGIT BETWEEN '"+DTOS(_DtIni)+"' AND '"+DTOS(_DtFim)+"' AND "       
	
	cQuery += " SD1.D_E_L_E_T_ = '' "
	
	cQuery += " ORDER BY D1_DI , D1_COD "
	
	TcQuery cQuery Alias TSD1 New        

	DbSelectArea("TSD1")
	TSD1->(DbGoTop())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//SetRegua(RecCount())
	ProcRegua( TSD1-> ( RecCount() ) )	
	
	//ApMsgAlert( strzero( TSD1->( RecCount() ), 9 ) )

	TSD1->(DbGoTop())                     

	If TSD1->(Eof())		
		TSD1->(DbCloseArea())
		RestArea(aArea_)          
		ApMsgAlert("Não existe dados para gerar as Movimentações de Transferência pela DI informada.Entre novamente com a DI correta.","Alerta DI")		
		Return
	Endif

	/*
	If TSD1->(!Eof())		
	  _XChave := TSD1->NFORIG + TSD1->CODPRODUTO + STR(TSD1->QTDORIG) + STR(TSD1->CUSTOENTRA) + TSD1->ITEM
	  _lZera := .F.
	Endif
	*/
	
	While TSD1->(!Eof())
                                        
      	TSD1->(DbSkip())

		/*      	
      	IF _XChave = TSD1->NFORIG + TSD1->CODPRODUTO + STR(TSD1->QTDORIG) + STR(TSD1->CUSTOENTRA) + TSD1->ITEM
      	   _lZera:=.T.
      	Else
		   _lZera:=.F.       
		   _XChave := TSD1->NFORIG + TSD1->CODPRODUTO + STR(TSD1->QTDORIG) + STR(TSD1->CUSTOENTRA) + TSD1->ITEM
      	Endif
      	*/
      	
     //Atualiza Regua	
	 IncProc("Gerando Movimentação de Transferência para o Almoxarifado = 10 ...")
	
	Enddo

	TSD1->(DbCloseArea()) 
          

RestArea(aArea_)          

/*
  
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"
User Function TMATA241()
Local _aCab1 := {}
Local _aItem := {}
Local _atotitem:={}
Local cCodigoTM:="500"
Local cCodProd:="00001 "
Local cUnid:="CX "

Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao

Private _acod:={"1","MP1"}
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST"

_aCab1 := { {"D3_TM" ,cCodigoTM , NIL},;
{"D3_EMISSAO" ,ddatabase, NIL}} 

_aCab1 := {{"D3_DOC"    ,cNumDoc    ,Nil},;
            {"D3_TM"     ,'410'      ,Nil},;
            {"D3_CC"     ,' '        ,Nil},;
            {"D3_EMISSAO",ZMI->ZMI_EMISSA ,Nil}}

_aItem:={ {"D3_COD" ,cCodProd ,NIL},;
          {"D3_UM" ,cUnid ,NIL},; 
		  {"D3_QUANT" ,11 ,NIL},;
		  {"D3_LOCAL" ,"01" ,NIL},;
	      {"D3_LOTECTL" ,"22968/C" ,NIL}}
	      
		aadd(aItem,{{"D3_FILIAL" ,ZMI->ZMI_FILIAL ,NIL},;
		  {"D3_COD"    ,ZMI->ZMI_COD    ,NIL},;
          {"D3_QUANT" ,ZMI->ZMI_QUANT ,NIL},;
          {"D3_LOCAL" ,ZMI->ZMI_LOCAL ,NIL}})	      

aadd(_atotitem,_aitem) 
MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)

If lMsErroAuto 
Mostraerro() 
DisarmTransaction() 
break

EndIf

Return

*/

Return

//Fim da Rotina