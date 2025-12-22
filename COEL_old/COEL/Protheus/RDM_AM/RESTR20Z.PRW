#include "rwmake.ch"

User Function RESTR20Z()

cPerg := "RESTR20Z  "
ValidPerg()
Pergunte(cPerg,.T.)

SET CENTURY ON
xData := DTOC(mv_par01)
SET CENTURY OFF

MSCBPRINTER("S600","LPT1",,,.f.,,,,)

MSCBCHKStatus(.f.)


		MSCBBEGIN(mv_par02,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
		MSCBWRITE("^LH08,16^FS") 

		//MSCBGRAFIC(1.0,-0.10,"COEL")   //1.0,0.25                                                               //LOGOTIPO 		
		MSCBSAY(4.0,1.0,xData,"R","F","18,10")//10.0,0.25    
		//MSCBLineV(12,01,24)		
		MSCBSAY(15.0,1.0,xData,"R","F","18,10")//10.0,0.25              
		//MSCBLineV(23,01,24)		
		MSCBSAY(26.0,1.0,xData,"R","F","18,10")//10.0,0.25              
		//MSCBLineV(33,01,24)		
		MSCBSAY(37.0,1.0,xData,"R","F","18,10")//10.0,0.25              

		MSCBSAY(54.0,1.0,xData,"R","F","18,10")//10.0,0.25              
		//MSCBLineV(62,01,24)		
		MSCBSAY(65.0,1.0,xData,"R","F","18,10")//10.0,0.25              
		//MSCBLineV(73,01,24)		
		MSCBSAY(77.0,1.0,xData,"R","F","18,10")//10.0,0.25              
		//MSCBLineV(83,01,24)		
		MSCBSAY(88.0,1.0,xData,"R","F","18,10")//10.0,0.25              
		
      MSCBEND() //Fim da Imagem da Etiqueta				
		
/*
MSCBLOADGRF("\ARQUIVOS\FOTOS\COEL.GRF")

	
		MSCBBEGIN(1,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
		MSCBWRITE("^LH08,16^FS") 

		MSCBGRAFIC(1.0,-0.10,"COEL")   //1.0,0.25                                                               //LOGOTIPO 		
		MSCBSAY(10.0,1.0,"B-217   19/05/2014","P","D","18,10")//10.0,0.25              
		MSCBSAY(10.0,3.5,"P03SFB-F-0FO--","N","D","18,10")//10.0,3.25               
		MSCBSAY(10.0,6.0,"S/N: 898","N","D","18,10")//35.5,3.25                            
		MSCBSAYBAR(10.0,9.0,"P03SFB-F-0FO--","N","C",6,.f.,.f.,.f.,,1,1,.f.) //30  

		MSCBGRAFIC(50.0,-0.10,"COEL")   //1.0,0.25                                                               //LOGOTIPO 		
		MSCBSAY(60.0,1.0,"B-217   19/05/2014","P","D","18,10")//10.0,0.25                 
		MSCBSAY(60.0,3.5,"P03SFB-F-0FO--","N","D","18,10")//10.0,3.25                   
		MSCBSAY(60.0,6.0,"S/N: 450","N","D","18,10")//35.5,3.25                       
		MSCBSAYBAR(60.0,9.0,"P03SFB-F-0FO--","N","C",6,.f.,.f.,.f.,,1,1,.f.) //30  
		
      MSCBEND() //Fim da Imagem da Etiqueta				

		MSCBBEGIN(1,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
		MSCBWRITE("^LH08,16^FS") 
		
		MSCBGRAFIC(1.0,-0.10,"COEL")   //1.0,0.25                                                               //LOGOTIPO 		
		MSCBSAY(10.0,1.0,"B-217   19/05/2014","P","D","18,10")//10.0,0.25                 
		MSCBSAY(10.0,3.5,"P03SFB-F-0FO--","N","D","18,10")//10.0,3.25                   
		MSCBSAY(10.0,6.0,"S/N: 425","N","D","18,10")//35.5,3.25                       
		MSCBSAYBAR(10.0,9.0,"P03SFB-F-0FO--","N","C",6,.f.,.f.,.f.,,1,1,.f.) //30  
		
      MSCBEND() //Fim da Imagem da Etiqueta				
		
		
		INKEY(2)
			
		MSCBBEGIN(1,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
		MSCBWRITE("^LH08,16^FS") 

		MSCBGRAFIC(1.0,-0.10,"COEL")   //1.0,0.25                                                               //LOGOTIPO 		
		MSCBSAY(10.0,1.0,"B-217   19/05/2014","P","D","18,10")//10.0,0.25                                  //DESCRICAO1 DO PRODUTO
		MSCBSAY(10.0,3.5,"B04FHRRRR----0FO02","N","D","18,10")//10.0,3.25                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(10.0,6.0,"S/N: 4087","N","D","18,10")//35.5,3.25                                     //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAYBAR(10.0,9.0,"B04FHRRRR----0FO02","N","C",6,.f.,.f.,.f.,,1,1,.F.) //30  

		MSCBGRAFIC(50.0,-0.10,"COEL")   //1.0,0.25                                                               //LOGOTIPO 		
		MSCBSAY(60.0,1.0,"B-217   19/05/2014","P","D","18,10")//10.0,0.25                                  //DESCRICAO1 DO PRODUTO
		MSCBSAY(60.0,3.5,"B04FHRRRR----0FO02","N","D","18,10")//10.0,3.25                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(60.0,6.0,"S/N: 4086","N","D","18,10")//35.5,3.25                                     //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAYBAR(60.0,9.0,"B04FHRRRR----0FO02","N","C",6,.f.,.f.,.f.,,1,1,.F.) //30  

      MSCBEND() //Fim da Imagem da Etiqueta				

		MSCBBEGIN(1,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
		MSCBWRITE("^LH08,16^FS") 
		
		MSCBGRAFIC(1.0,-0.10,"COEL")   //1.0,0.25                                                               //LOGOTIPO 		
		MSCBSAY(10.0,1.0,"B-217   19/05/2014","P","D","18,10")//10.0,0.25                                  //DESCRICAO1 DO PRODUTO
		MSCBSAY(10.0,3.5,"B04FHRRRR----0FO02","N","D","18,10")//10.0,3.25                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(10.0,6.0,"S/N: 4085","N","D","18,10")//35.5,3.25                                     //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAYBAR(10.0,9.0,"B04FHRRRR----0FO02","N","C",6,.f.,.f.,.f.,,1,1,.F.) //30  
		
      MSCBEND() //Fim da Imagem da Etiqueta				

		
		INKEY(2)
				
		MSCBBEGIN(1,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
		MSCBWRITE("^LH08,16^FS") 

		MSCBGRAFIC(1.0,-0.10,"COEL")   //1.0,0.25                                                               //LOGOTIPO 		
		MSCBSAY(10.0,1.0,"B-215   19/05/2014","P","D","18,10")//10.0,0.25                                  //DESCRICAO1 DO PRODUTO
		MSCBSAY(10.0,3.5,"R38-LTRR-----I----","N","D","18,10")//10.0,3.25                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(10.0,6.0,"S/N: 2594","N","D","18,10")//35.5,3.25                                     //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAYBAR(10.0,9.0,"R38-LTRR-----I----","N","C",6,.f.,.f.,.f.,,1,1,.F.) //30  

		MSCBGRAFIC(50.0,-0.10,"COEL")   //1.0,0.25                                                               //LOGOTIPO 		
		MSCBSAY(60.0,1.0,"B-215   19/05/2014","P","D","18,10")//10.0,0.25                                  //DESCRICAO1 DO PRODUTO
		MSCBSAY(60.0,3.5,"R38-LTRR-----I----","N","D","18,10")//10.0,3.25                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(60.0,6.0,"S/N: 2593","N","D","18,10")//35.5,3.25                                     //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAYBAR(60.0,9.0,"R38-LTRR-----I----","N","C",6,.f.,.f.,.f.,,1,1,.F.) //30  

      MSCBEND() //Fim da Imagem da Etiqueta				
		
		MSCBBEGIN(1,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
		MSCBWRITE("^LH08,16^FS") 
		
		MSCBGRAFIC(1.0,-0.10,"COEL")   //1.0,0.25                                                               //LOGOTIPO 		
		MSCBSAY(10.0,1.0,"B-215   19/05/2014","P","D","18,10")//10.0,0.25                                  //DESCRICAO1 DO PRODUTO
		MSCBSAY(10.0,3.5,"R38-LTRR-----I----","N","D","18,10")//10.0,3.25                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(10.0,6.0,"S/N: 2592","N","D","18,10")//35.5,3.25                                     //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAYBAR(10.0,9.0,"R38-LTRR-----I----","N","C",6,.f.,.f.,.f.,,1,1,.F.) //30  
		
      MSCBEND() //Fim da Imagem da Etiqueta				

		
		
		INKEY(2)
		
		MSCBBEGIN(1,2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
		MSCBWRITE("^LH08,16^FS") 

		MSCBGRAFIC(1.0,-0.10,"COEL")   //1.0,0.25                                                               //LOGOTIPO 		
		MSCBSAY(10.0,1.0,"        19/05/2014","P","D","18,10")//10.0,0.25                                  //DESCRICAO1 DO PRODUTO
		MSCBSAY(10.0,3.5,"Y39-HRRR-----I----","N","D","18,10")//10.0,3.25                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(10.0,6.0,"S/N: 3315","N","D","18,10")//35.5,3.25                                     //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAYBAR(10.0,9.0,"Y39-HRRR-----I----","N","C",6,.f.,.f.,.f.,,1,1,.F.) //30  

		MSCBGRAFIC(50.0,-0.10,"COEL")   //1.0,0.25                                                               //LOGOTIPO 		
		MSCBSAY(60.0,1.0,"        19/05/2014","P","D","18,10")//10.0,0.25                                  //DESCRICAO1 DO PRODUTO
		MSCBSAY(60.0,3.5,"Y39-HRRR-----I----","N","D","18,10")//10.0,3.25                                     //CODIGO DO PRODUTO CHUMBADO P TESTE
		MSCBSAY(60.0,6.0,"S/N: 3316","N","D","18,10")//35.5,3.25                                     //NUMERO DA OP CHUMBADO P TESTE
		MSCBSAYBAR(60.0,9.0,"Y39-HRRR-----I----","N","C",6,.f.,.f.,.f.,,1,1,.F.) //30  

      MSCBEND() //Fim da Imagem da Etiqueta				
	

//MSCBCLOSEPRINTER()
*/
MSGINFO("Printing successfully")

Return

***************************
Static Function ValidPerg()
***************************
   _sAlias := Alias()
   DbSelectArea("SX1")
   DbSetOrder(1)
   aRegs :={} //Grupo|Ordem| Pegunt                         | perspa | pereng | VariaVL  | tipo| Tamanho|Decimal| Presel| GSC | Valid         |   var01   | Def01              | DefSPA1 | DefEng1 | CNT01 | var02 | Def02           | DefSPA2 | DefEng2 | CNT02 | var03 | Def03           | DefSPA3 | DefEng3 | CNT03 | var04 | Def04 | DefSPA4 | DefEng4 | CNT04 | var05 | Def05 | DefSPA5 | DefEng5 | CNT05 | F3    | GRPSX5 |
   aAdd(aRegs,{ cPerg,"01" , "Data                        ?",   ""   ,  ""    , "mv_ch1" , "D" ,   08   ,   0   ,   0   , "G" , "          "  , "mv_par01", "                " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SZE" , "    " })
   aAdd(aRegs,{ cPerg,"02" , "Quantidade Etiquetas        ?",   ""   ,  ""    , "mv_ch2" , "N" ,   04   ,   0   ,   0   , "G" , "          "  , "mv_par02", "                " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "             " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "   " , "   " , "     " , "     " , "   " , "SZE" , "    " })
		For i:=1 to Len(aRegs)
			If !DbSeek(cPerg+aRegs[i,2])
				RecLock("SX1",.T.)
				For j:=1 to FCount()
					If j <= Len(aRegs[i])
						FieldPut(j,aRegs[i,j])
					Endif
				Next
				MsUnlock()
			Endif
		Next
		dbSelectArea(_sAlias)
Return