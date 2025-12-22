#include "rwmake.ch"

User Function COELETIQ()

SetPrvt("CPERG,_CPORTA,CINDEXSB1,DINDEXSB1,CCONDICAO,_SALIAS")
SetPrvt("AREGS,I,J,")

/*
-----------------------------------------------------------------------------
|  rdmake    | COELETIQ | Autor | FERNANDO AMORIM       | Data | 25.11.10   |
-----------------------------------------------------------------------------
|  Descricao | Rotina de impressao de etiquetas com codigo de Barras        |
|            | COM LOGOTIPO                                   		        |
-----------------------------------------------------------------------------
|  ALTERADO:                                                                |
-----------------------------------------------------------------------------

MV_PAR01 = CODIGO DO PRODUTO
MV_PAR02 = QUANTIDADE DE ETIQUETAS
MV_PAR03 = PORTA DA IMPRESSORA
MV_PAR04 = MODELO DE ETIQUETA
*/

cPerg      := "RESTR8"  // Nome da Pergunte


IF ! Pergunte(cPerg,.T.)               // Pergunta no SX1
	Return
Endif

Processa({|| _EtiQC() })

Return
//-----------------------------------------------------------------------------


Static Function _EtiQC()

cIndexSB1 := CriaTrab(nil,.f.)
DbSelectArea("SB1")
dIndexSB1 :="B1_COD"
cCondicao :=""
cCondicao := cCondicao + 'B1_COD     == "'+ mv_par01 +'" '

IndRegua("SB1",cIndexSB1,dIndexSB1,,cCondicao,"Selecionando Produtos..." )
SB1->(DBGoTop())

If  mv_par03 == 1
	MSCBPRINTER("S600","LPT1",,,.f.,,,,)
ElseIf mv_par03 == 2
	MSCBPRINTER("S300","COM1:9600,N,8,0",Nil,42) //Seta tipo de impressora no padrao ZPL  42
EndIf

MSCBCHKStatus(.f.)
//MSCBLOADGRF("LOGO.GRF") //Carrega o logotipo para impressora
MSCBLOADGRF("\USERS\FOTOS\COEL.GRF")
//Seta Impressora (Zebra)

ProcRegua(SB1->(RecCount()))

While  ! SB1->(eof())
	
	IncProc("Imprimindo Etiqueta...")
	
	
	do case

		case mv_par04 = 1 //----------------  Etiqueta "1" - 5,1cm de largura cada
            /*
            _descprod1 := ""
            _descprod2 := ""  
            _lcontrol1 := .f.
            for i:=1 to len(ALLTRIM(SB1->B1_DESC))                                                             //divide a descrição corretamente
               if i < 19
                  _descprod1 := _descprod1 + substr(ALLTRIM(SB1->B1_DESC),i,1)
               else   
                  if _lcontrol1
                     _descprod2 := _descprod2 + substr(ALLTRIM(SB1->B1_DESC),i,1)
                  else
                     if substr(ALLTRIM(SB1->B1_DESC),i,1) <> " " .AND. i <= 23
                        _descprod1 := _descprod1 + substr(ALLTRIM(SB1->B1_DESC),i,1)
                     else
                        _lcontrol1 := .t.  
                        if substr(ALLTRIM(SB1->B1_DESC),i,1) <> " "
                           _descprod2 := _descprod2 + substr(ALLTRIM(SB1->B1_DESC),i,1)
                        endif   
                     endif
                  endif
               endif
            next
            */
            
			If  mv_par03 == 1  //ZEBRA Z4
				MSCBBEGIN(val(mv_par02),2) //Inicio da Imagem da Etiqueta //PASSA QUANTIDADE, VELOCIDADE, TAMANHO
				MSCBWRITE("^LH08,16^FS") 
				
				//1a. COLUNA
				MSCBGRAFIC(3.0,0.5,"COEL")                                                                            //LOGOTIPO 
				MSCBSAY(12,0.5,SUBSTR(ALLTRIM(SB1->B1_DESC),1,23),"P","D","18,10")//0.75                                       //DESCRICAO1 DO PRODUTO
				MSCBSAY(12,3.5,SUBSTR(ALLTRIM(SB1->B1_DESC),24,27),"P","D","18,10")//0.75                                       //DESCRICAO2 DO PRODUTO				
                //MSCBSAY(2.0,6.3, alltrim(SB1->B1_COD),"N","A","18,10")//7                                          //CODIGO DO PRODUTO
                MSCBSAY(3.0,6.3, alltrim("19210303"),"N","A","18,10")//7                                             //CODIGO DO PRODUTO CHUMBADO P TESTE
				MSCBSAY(30,6.3,alltrim("013993/1"),"N","A","18,10")//7                                             //NUMERO DA OP CHUMBADO P TESTE
      			MSCBSAY(3.0,9.3,alltrim(STR(Month(dDataBase)))+ "/" + ALLTRIM(STR(YEAR(dDataBase))),"N","A","18,10")//7                 //MES:ANO
				//MSCBSAYBAR(6.25,8.55,AllTrim("7895113" + ALLTRIM(SB1->B1_EAN)),"N","E",6.5,.F.,.t.,.f.,,2,1,.f.) //monta codigo de barras 9,25
				MSCBSAYBAR(13,12.55,AllTrim("7895113" + ALLTRIM("17782")),"N","E",6.5,.F.,.t.,.f.,,2,1,.f.)       //monta codigo de barras 9,25CHUMBADO P TESTE
	
				//2a. COLUNA 
				MSCBGRAFIC(53.0,0.5,"COEL")                                                                            //LOGOTIPO 
				MSCBSAY(62,0.5,SUBSTR(ALLTRIM(SB1->B1_DESC),1,23),"P","D","18,10")//0.75                                       //DESCRICAO1 DO PRODUTO
				MSCBSAY(62,3.5,SUBSTR(ALLTRIM(SB1->B1_DESC),24,27),"P","D","18,10")//0.75                                       //DESCRICAO2 DO PRODUTO				
                //MSCBSAY(2.0,6.3, alltrim(SB1->B1_COD),"N","A","18,10")//7                                          //CODIGO DO PRODUTO
                MSCBSAY(53.0,6.3, alltrim("19210303"),"N","A","18,10")//7                                             //CODIGO DO PRODUTO CHUMBADO P TESTE
				MSCBSAY(80,6.3,alltrim("013993/1"),"N","A","18,10")//7                                             //NUMERO DA OP CHUMBADO P TESTE
      			MSCBSAY(53.0,9.3,alltrim(STR(Month(dDataBase)))+ "/" + ALLTRIM(STR(YEAR(dDataBase))),"N","A","18,10")//7                 //MES:ANO
				//MSCBSAYBAR(6.25,8.55,AllTrim("7895113" + ALLTRIM(SB1->B1_EAN)),"N","E",6.5,.F.,.t.,.f.,,2,1,.f.) //monta codigo de barras 9,25
				MSCBSAYBAR(63,12.55,AllTrim("7895113" + ALLTRIM("17782")),"N","E",6.5,.F.,.t.,.f.,,2,1,.f.)       //monta codigo de barras 9,25CHUMBADO P TESTE
                MSCBEND() //Fim da Imagem da Etiqueta				
                
                
				/*
				MSCBGRAFIC(10,6,"COEL")
				//MSCBSAY(41,0.5,substr(SB1->B1_DESC,01,16),"N","F","26,13")
				//MSCBSAY(42.5,3.3,substr(SB1->B1_DESC,17,16),"N","F","26,13")
		    	MSCBSAY(40,0.5,ALLTRIM(_descprod1),"P","D","18,10")
				MSCBSAY(40.2,3.3,ALLTRIM(_descprod2),"P","D","18,10")
				MSCBSAY(52,6.3,alltrim(SB1->B1_COD),"N","A","18,10") 
			    //MSCBSAY(40,6.3,substr( SB1->B1_DESC,33,10)+" - "+alltrim(SB1->B1_COD),"N","A","18,10")
				MSCBSAYBAR(46.25,8.55,AllTrim(SB1->B1_EAN),"N","E",6.5,.F.,.t.,.f.,,2,1,.f.) //monta codigo de barras
				MSCBEND() //Fim da Imagem da Etiqueta
                */
                
			Else
                MSGBOX("PARAMETRO NÃO PERMITIDO")
			EndIf
	    OTHERWISE		
	       MSGBOX("PARAMETRO NÃO PERMITIDO")
	endcase
	SB1->(DbSkip())
End
//MSCBCLOSEPRINTER()

dbSelectArea("SB1")
RetIndex("SB1")
Ferase(cIndexSB1+OrdBagExt())
Return
