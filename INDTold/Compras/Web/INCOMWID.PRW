#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#include "ap5mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณW04IDIOM  บ Autor ณ Diego Rafael       บ Data ณ  18/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Controle de Indioma do formulแrio                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ INDT                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function INCOMWID(cIdioma)
  Local aIdioma := {}
/*01*/ // AAdd(aIdioma,IIf(cIdioma == "P","Visualiza็ใo do Pedido "         ,"Payment Request"))     //01  //wermeson  
/*01*/  AAdd(aIdioma,IIf(cIdioma == "P","Follow Up "                     ,"Follow Up"))     //01  //Alterado Ener - 18/07/08
/*02*/  AAdd(aIdioma,IIf(cIdioma == "P","Filial:"                        ,"Branch:"))             //02
/*03*/  AAdd(aIdioma,IIf(cIdioma == "P","Pedido/Requisi็ใo :"             ,"Request :"))     //03
/*04*/  AAdd(aIdioma,IIf(cIdioma == "P","Contato :"                      ,"Contact :"))         //04   
/*05*/  AAdd(aIdioma,IIf(cIdioma == "P","Dt. Emissao :"                  ,"Issue Date:"))    //05           
/*06*/  AAdd(aIdioma,IIf(cIdioma == "P","Nome do Fornecedor :"            ,"Supplier Name:"))      //06  //wermeson         
/*07*/  AAdd(aIdioma,IIf(cIdioma == "P","Codigo do Fornecedor :"         ,"Supplier Codigo :"))        //07  //wermeson
/*08*/  AAdd(aIdioma,IIf(cIdioma == "P","Condi็ใo de Pagamento :"        ,"Payment Condition:"))           //08  
/*09*/  AAdd(aIdioma,IIf(cIdioma == "P","Data de Entrega Prevista :"      ,"Data Delivery Forecast:"))        //09 //wermeson   

/*10*/  AAdd(aIdioma,IIf(cIdioma == "P","Conhecimento :"                  ,"Knowledge :"))       //10   
/*11*/  AAdd(aIdioma,IIf(cIdioma == "P","Data de Embarque :"              ,"Date of Board :"))      //11   
/*12*/  AAdd(aIdioma,IIf(cIdioma == "P","Data de Chegada :"               ,"Date of arrival :"))              //12   
/*13*/  AAdd(aIdioma,IIf(cIdioma == "P","Data de Recebimento :"           ,"Date Received :"))               //13   
/*14*/  AAdd(aIdioma,IIf(cIdioma == "P","Tempo em dias decorridos:"       ,"Time elapsed in days :"))          //14  //wermeson
/*15*/  AAdd(aIdioma,IIf(cIdioma == "P","Invoice/N.F. :"                  ,"Invoice/N.F.:"))      //15    
/*16*/  AAdd(aIdioma,IIf(cIdioma == "P","DI :"                            ,"DI :"))     //16  
/*17*/  AAdd(aIdioma,IIf(cIdioma == "P","Status :"                        ,"Status :"))     			 //17  //wermeson  
/*18*/  AAdd(aIdioma,IIf(cIdioma == "P","Status da Entrega :"             ,"Status Delivery :"))   		 //18  //wermeson
/*19*/  AAdd(aIdioma,IIf(cIdioma == "P","  Item "                          ,"  Item "))     //19  //wermeson
/*20*/  AAdd(aIdioma,IIf(cIdioma == "P","  Data  "                         ,"  Date  "))     //20      
/*21*/  AAdd(aIdioma,IIf(cIdioma == "P","  Descri็ใo  "                    ,"  Description ")) //21            
/*22*/  AAdd(aIdioma,IIf(cIdioma == "P","Clique aqui para visualiza็ใo Follow Up : ",;
                                         "Click here to view the Follow Up :"))  //22            

/*23*/  AAdd(aIdioma,IIf(cIdioma == "P","Digite um Pedido Valido Para a Filial Atual"              ,;
                                        "Enter a Request For Valid Branch Current"))                   //23            
/*24*/  AAdd(aIdioma,IIf(cIdioma == "P","Follow Up nใo Encontrado  "      ,"Follow Up not found"))                    //24            
/*25*/  AAdd(aIdioma,IIf(cIdioma == "P","Data de Entrega Fornecedor:"      ,"Data Delivery Provider:"))                 //25            
/*26*/  AAdd(aIdioma,IIf(cIdioma == "P","Data de Entrega Comprador:"       ,"Data Delivery Buyer:"))                          //26            
/*27*/  AAdd(aIdioma,IIf(cIdioma == "P","Comprador :"                       ,"Buyer :")) 
/*28*/  AAdd(aIdioma,IIf(cIdioma == "P","Detalhes da Aprova็ใo "           ,"Details of Approval "))      //28            

/*29*/  AAdd(aIdioma,IIf(cIdioma == "P","Nivel "               ,"Level "))      //28            
/*30*/  AAdd(aIdioma,IIf(cIdioma == "P","Usuario "             ,"User "))      //28            
/*31*/  AAdd(aIdioma,IIf(cIdioma == "P","Situa็ใo "            ,"Situation "))      //28  
/*32*/  AAdd(aIdioma,IIf(cIdioma == "P","Aprovado por "        ,"Approver by  "))      //28   	
/*33*/  AAdd(aIdioma,IIf(cIdioma == "P","Data de Envio : "     ,"Send Date : "))      //28 
/*34*/  AAdd(aIdioma,IIf(cIdioma == "P","Observa็ใo "          ,"Note  "))      //28    
/*35*/  AAdd(aIdioma,IIf(cIdioma == "P","Data Libera็ใo "      ,"Release Date  "))      //28 
/*36*/  AAdd(aIdioma,IIf(cIdioma == "P","Tipo "                ,"Type "))      //28
/*37*/  AAdd(aIdioma,IIf(cIdioma == "P","Pesquisar "           ,"Search"))
/*38*/  AAdd(aIdioma,IIf(cIdioma == "P","Campos Obrigat๓rios"  ,"Mandatory Fields"))
/*39*/  AAdd(aIdioma,IIf(cIdioma == "P","Informe o Periodo que deseja consultar para Centro Custo..."  ,"Enter the period want for Cost Centers..."))     //20      
/*40*/  AAdd(aIdioma,IIf(cIdioma == "P","Data Inicial"         ,"Start  Date  "))     //20      
/*41*/  AAdd(aIdioma,IIf(cIdioma == "P","Data Final"           ,"End  Date  "))     //20      
/*42*/  AAdd(aIdioma,IIf(cIdioma == "P","Detalhes do Follow-Up","Details of Follow-Up"))     //20      
/*43*/  AAdd(aIdioma,IIf(cIdioma == "P","Itens do Follow-Up"   ,"Items of Follow-Up"))     //20      

Return aIdioma