#include "TOTVS.CH"
#include "TBICONN.ch"

User Function AABROWSE()

Local oOK     := LoadBitmap(GetResources(),'LBOK')
Local oNO     := LoadBitmap(GetResources(),'LBNO')
Local aList   := {}    
Local aCabec  := {"Tipo","Filial","Documento","CLiente","Loja","Tipo Cliente","Vendedor","Emissao","End. Entrega","Bairro Entrega",;
                  "Mun. Entrega","Est. Entrega","Desconto","Peso Liquido","Peso Bruto","Fone Entrega","Observacao1","Observacao2","Bloqueio" }
Local aDimCab := {20,30,60,60,30,20,60,80,100,60,60,50,40,40,40,80,100,100,30}
Prepare Environment Empresa "01" Filial "01" Tables "SL1,SC5"
                    `
__cUserId := "000000"

aBrowse := Getregs()

  DEFINE DIALOG oDlg TITLE "Browse Orcamento" FROM 180,180 TO 550,1000 PIXEL
	                 
    // Vetor com elementos do Browse
    // Cria Browse
    oBrowse := TCBrowse():New( 001 , 050, 260, 156,,;
                              aCabec,aDimCab,;
                              oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
    // Seta vetor para a browse                            
    oBrowse:SetArray(aBrowse) 

    // Monta a linha a ser exibina no Browse
    oBrowse:bLine := {||{ If(aBrowse[oBrowse:nAt,01],oOK,oNO),;
                          aBrowse[oBrowse:nAt,02],;
                          aBrowse[oBrowse:nAt,03],;
                          aBrowse[oBrowse:nAt,04],;
                          aBrowse[oBrowse:nAt,05],;
                          aBrowse[oBrowse:nAt,06],;
                          aBrowse[oBrowse:nAt,07],;
                          aBrowse[oBrowse:nAt,08],;
                          aBrowse[oBrowse:nAt,09],;
                          aBrowse[oBrowse:nAt,10],;
                          aBrowse[oBrowse:nAt,11],;
                          aBrowse[oBrowse:nAt,12],;
                          Transform(aBrowse[oBrowse:nAt,13],PesqPict("SL1","L1_DESCONT",18,2) ),;
                          Transform(aBrowse[oBrowse:nAt,14],PesqPict("SL1","L1_PLIQUI" ,18,2) ),;
                          Transform(aBrowse[oBrowse:nAt,15],PesqPict("SL1","L1_PBRUTO" ,18,2) ),;
                          aBrowse[oBrowse:nAt,16],;
                          aBrowse[oBrowse:nAt,17],;
                          aBrowse[oBrowse:nAt,18],;
                          aBrowse[oBrowse:nAt,19]}}

    // Evento de clique no cabeçalho da browse
    oBrowse:bHeaderClick := {|| alert('bHeaderClick') } 
    // Evento de duplo click na celula
    oBrowse:bLDblClick   := {|| alert('bLDblClick') }
    
    // Cria Botoes com metodos básicos
    TButton():New( 001, 002, "Liberar"	, oDlg,{|| cRet := iIf(aBrowse[oBrowse:nAt][01],u_AALJ05V(),u_AAFT05V()) , oBrowse:setArray(Getregs()) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 001, 052, "Sair"    , oDlg,{|| oDlg:End() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    
  ACTIVATE DIALOG oDlg CENTERED 
Return

Static Function Getregs()
  
  Local cTable     := GetNextAlias()
  Local cQry       := ""
  Local _adLinregs := {}
  Local _adRegs    := {}
  
  cQry += " select * from (
  cQry += " SELECT 'O' TIPO ,L1_FILIAL,L1_NUM,L1_CLIENTE,L1_LOJA   ,L1_TIPOCLI,L1_VEND ,L1_EMISSAO,L1_ENDENT,L1_BAIRROE,L1_MUNE,L1_ESTE,L1_DESCONT,L1_PLIQUI,L1_PBRUTO,L1_FONEENT,L1_OBSENT1,L1_OBSENT2,L1_XBLQORC,R_E_C_N_O_,D_E_L_E_T_ FROM SL1010
  cQry += " union
  cQry += " SELECT 'P' TIPO,C5_FILIAL,C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_TIPOCLI,C5_VEND1,C5_EMISSAO,C5_ENDENT,C5_BAIRROE,C5_MUNE,C5_ESTE,C5_DESCONT,C5_PESOL,C5_PBRUTO ,C5_FONEENT,C5_OBSENT1,C5_OBSENT2,C5_XBLQORC,R_E_C_N_O_ ,D_E_L_E_T_ FROM SC5010
  cQry += " )TBL
  cQry += " WHERE D_E_L_E_T_ = ''
  
  
  If __cUserId$GetMv("MV_XLIBORG")
     cQry += " and L1_XBLQORC != ''
  elseif __cUserId$GetMv("MV_XLIBORC")
     cQry += " and L1_XBLQORC != '' And Left(SL1->L1_XBLQORC,1)='C' )}
  elseif __cUserId$GetMv("MV_XLIBORD")
     cQry += " and L1_XBLQORC != '' aND Right(SL1->L1_XBLQORC,1)='D' )}
  EndIf
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), cTable , .T., .T. )
  _adRegs := {}
  While !(cTable)->(Eof())
     _adLinRegs := {}
    aAdd(_adLinRegs, (cTable)->TIPO = "O" )
    aAdd(_adLinRegs, (cTable)->L1_FILIAL)
    aAdd(_adLinRegs, (cTable)->L1_NUM )
    aAdd(_adLinRegs, (cTable)->L1_CLIENTE )
    aAdd(_adLinRegs, (cTable)->L1_LOJA )
    aAdd(_adLinRegs, (cTable)->L1_TIPOCLI )
    aAdd(_adLinRegs, (cTable)->L1_VEND )
    aAdd(_adLinRegs, (cTable)->L1_EMISSAO )
    aAdd(_adLinRegs, (cTable)->L1_ENDENT )
    aAdd(_adLinRegs, (cTable)->L1_BAIRROE)
  
    aAdd(_adLinRegs, (cTable)->L1_MUNE )
    aAdd(_adLinRegs, (cTable)->L1_ESTE )
    aAdd(_adLinRegs, (cTable)->L1_DESCONT )
    aAdd(_adLinRegs, (cTable)->L1_PLIQUI )
    aAdd(_adLinRegs, (cTable)->L1_PBRUTO )

  
    aAdd(_adLinRegs, (cTable)->L1_FONEENT)
    aAdd(_adLinRegs, (cTable)->L1_OBSENT1)
    aAdd(_adLinRegs, (cTable)->L1_OBSENT2)
    aAdd(_adLinRegs, (cTable)->L1_XBLQORC)
    
    aAdd(_adRegs,_adLinregs)  
    (cTable)->(dbSkip())
  EndDo
  (cTable)->(dbCloseArea())
Return _adRegs