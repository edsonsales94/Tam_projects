#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 07/10/02

User Function ROTPEN()        // incluido pelo assistente de conversao do AP6 IDE em 07/10/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBASEFOLHA,CBASEFERIAS,CBASE13SAL,NBASEFOLHA,NBASE13SAL,NBASEFERIAS")
SetPrvt("NACMINFOLHA,NACMIN13SAL,NACMINFERIAS,NACFIXFOLHA,NACFIX13SAL,NACFIXFERIAS")
SetPrvt("NPENSAO,CVERBAADTO,CVERBAFOLHA,CVERBAFERIAS,CVERBA131,CVERBA132")
SetPrvt("CFILMAT,NPERCPENSAO,NPOS,I,")

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡ao    ³ RotPen   ³ Autor ³Marinaldo de Jesus     ³ Data ³07/12/1999³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡ao ³ Calculo da Pensao Alimenticia.                             ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³ #RotPen                                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³                                                            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ Roteiros de Calculo (Antes do Calculo da Pensao)           ³
ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Programador ³ Data     ³         Motivo da Alteracao                   ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³            ³  /  /    ³                                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Define Variaveis Basicas                                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cBaseFolha   := ""
cBaseFerias  := ""
cBase13Sal   := ""
nBaseFolha   := 0
nBase13Sal   := 0
nBaseFerias  := 0
nAcMinFolha  := 0
nAcMin13Sal  := 0
nAcMinFerias := 0
nAcFixFolha  := 0
nAcFix13Sal  := 0
nAcFixFerias := 0
nPensao      := 0
cVerbaAdto   := ""
cVerbaFolha  := ""
cVerbaFerias := ""
cVerba131    := ""
cVerba132    := ""
cFilMat      := SRA->(RA_FILIAL + RA_MAT)
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Apura o I.R.R.F. (Ficticio) para Abatimento da Base da Pensao          ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF c__Roteiro == "FER" .or. c__Roteiro =="RES"
   fcIrFer(aCodfol,aTabIr,IF(c__Roteiro == "RES",.T.,.F.),IF(c__Roteiro == "RES",M->RG_DATAHOM,dDataBase))
ElseIF c__Roteiro == "132" .or. c__Roteiro == "RES"
       fcIr13o(aCodfol,IF(c__Roteiro == "RES",aTabIr,aTabIr13),.T.,IF(c__Roteiro == "RES" ,.T.,.F.) )
Else
    fCIr(aCodfol,aTabIr,,IF(c__Roteiro == "ADI",dDataPgto,dData_Pgto))
EndIF
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Verifica se Funcionario Tem Beneficiaria da Pensao e Efetua o Desconto ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF SZB->( dbSeek(cFilMat,.T. ) )
   dbSelectArea("SZB")
   While SZB->( !Eof() .and. ZB_FILIAL + ZB_MAT == cFilMat )

         fVerbas_Pensao()
         fMontaBase_Pen()

         nPercPensao  := SZB->ZB_PERCENT / 100
         cVerbaAdto   := SZB->(IF(Empty(ZB_CODPADT),aCodFol[058,1],ZB_CODPADT))
         cVerbaFolha  := SZB->(IF(Empty(ZB_CODPFOL),aCodFol[056,1],ZB_CODPFOL))
         cVerbaFerias := SZB->(IF(Empty(ZB_CODPFER),aCodFol[170,1],ZB_CODPFER))
         cVerba131    := SZB->ZB_CODP131
         cVerba132    := SZB->ZB_CODP132

         IF c__Roteiro == "ADI"
            IF "AD" $ AllTrim(SZB->ZB_SOBRE) .or. "TT" $ AllTrim(SZB->ZB_SOBRE)
               nPensao := nBaseFolha * nPercPensao
               IF fLocaliaPD(cVerbaAdto) <> 0
                  IF aPD[fLocaliaPd(cVerbaAdto),7] != "I"
                     fDelPD(cVerbaAdto)
                  EndIF
               EndIF
               fGeraVerba(cVerbaAdto,nPensao,nPercPensao,,,,,,,,.T.)
            EndIF
         ElseIF c__Roteiro == "FOL"
                IF "FO" $ AllTrim(SZB->ZB_SOBRE) .or. "TT" $ AllTrim(SZB->ZB_SOBRE)
                   nPensao := nBaseFolha * nPercPensao
                   IF fLocaliaPD(cVerbaFolha) <> 0
                      IF aPD[fLocaliaPd(cVerbaFolha),7] != "I"
                         fDelPD(cVerbaFolha)
                      EndIF
                   EndIF
                   fGeraVerba(cVerbaFolha,nPensao,nPercPensao,,,,,,,,.T.)
                EndIF
         ElseIF c__Roteiro == "FER"
                IF "FE" $ AllTrim(SZB->ZB_SOBRE) .or. "TT" $ AllTrim(SZB->ZB_SOBRE)
                   nPensao := nBaseFerias * nPercPensao
                   IF fLocaliaPD(cVerbaFerias) <> 0
                      IF aPD[fLocaliaPd(cVerbaFerias),7] != "I"
                         fDelPD(cVerbaFerias)
                      EndIF
                   EndIF
                   fGeraVerba(cVerbaFerias,nPensao,nPercPensao,,,,,,,,.T.)
                EndIF
         ElseIF c__Roteiro == "131"
                IF "P1" $ AllTrim(SZB->ZB_SOBRE) .or. "TT" $ AllTrim(SZB->ZB_SOBRE)
                   nPensao := nBase13Sal * nPercPensao
                   IF fLocaliaPD(cVerba131) <> 0
                      IF aPD[fLocaliaPd(cVerba131),7] != "I"
                         fDelPD(cVerba131)
                      EndIF
                   EndIF
                   fGeraVerba(cVerba131,nPensao,nPercPensao,,,,,,,,.T.)
                EndIF
         ElseIF c__Roteiro == "132"
                IF "P2" $ AllTrim(SZB->ZB_SOBRE) .or. "TT" $ AllTrim(SZB->ZB_SOBRE)
                   nPensao := nBase13Sal * nPercPensao
                   IF fLocaliaPD(cVerba132) <> 0
                      IF aPD[fLocaliaPD(cVerba132),7] != "I"
                         fDelPD(cVerba132)
                      EndIF
                   EndIF
                   fGeraVerba(cVerba132,nPensao,nPercPensao,,,,,,,,.T.)
                EndIF
         ElseIF c__Roteiro == "RES"
                IF "FO" $ AllTrim(SZB->ZB_SOBRE) .or. "TT" $ AllTrim(SZB->ZB_SOBRE)
                   nPensao := nBaseFolha * nPercPensao
                   IF fLocaliaPD(cVerbaFolha) <> 0
                      IF aPD[fLocaliaPD(cVerbaFolha),7] != "I"
                         fDelPD(cVerbaFilha)
                      EndIF
                   EndIF
                   fGeraVerba(cVerbaFolha,nPensao,nPercPensao,,,,,,,,.T.)
                EndIF
                IF "FE" $ AllTrim(SZB->ZB_SOBRE) .or. "TT" $ AllTrim(SZB->ZB_SOBRE)
                   nPensao := nBaseFerias * nPercPensao
                   IF fLocaliaPD(cVerbaFerias) <> 0
                      IF aPD[fLocaliaPD(cVerbaFerias),7] != "I"
                         fDelPD(cVerbaFerias)
                      EndIF
                   EndIF
                   fGeraVerba(cVerbaFerias,nPensao,nPercPensao,,,,,,,,.T.)
                EndIF
                IF "P2" $ AllTrim(SZB->ZB_SOBRE) .or. "TT" $ AllTrim(SZB->ZB_SOBRE)
                   nPensao := nBase13Sal * nPercPensao
                   IF fLocaliaPD(cVerba132) <> 0
                      IF aPD[fLocaliaPDp(cVerba132),7] != "I"
                         fDelPD(cVerba132)
                      EndIF
                   EndIF
                   fGeraVerba(cVerba132,nPensao,nPercPensao,,,,,,,,.T.)
                EndIF
         EndIF
         /*
         ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         ³Reinicializa Variaveis                                                 ³
         ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
         cBaseFolha   := cBaseFerias  := cBase13Sal   := ""
         nBaseFolha   := nBase13Sal   := nBaseFerias  := nPensao := 0
         nAcMinFolha  := nAcMin13Sal  := nAcMinFerias := 0
         nAcFixFolha  := nAcFix13Sal  := nAcFixFerias := 0
         cVerbaAdto   := cVerbaFolha  := cVerbaFerias := ""
         cVerba131    := cVerba132    := ""
         SZB->(dbSkip())
   EndDo
EndIF
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Exclui a Base e o I.R.R.F. (Ficticio) Possibilitando o Recalculo.      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF c__Roteiro == "FER" .or. c__Roteiro =="RES" 
   nPos := Ascan(aPd, { |X| X[1] == aCodFol[16,1] .and. X[9] #"D" .and. X[7] # 'I' })
   IF nPos > 0
      fDelPd(aPd[nPos,1])
   EndIF
   nPos := Ascan(aPd, { |X| X[1] == aCodFol[67,1] .and. X[9] #"D" .and. X[7] # 'I' })
   IF nPos > 0
      fDelPd(aPd[nPos,1])
   EndIF
ElseIF c__Roteiro == "132" .or. c__Roteiro =="RES"
       nPos := Ascan(aPd, { |X| X[1] == aCodFol[27,1] .and. X[9] #"D" .and. X[7] # 'I' })
       IF nPos > 0
          fDelPd(aPd[nPos,1])
       EndIF
       nPos := Ascan(aPd, { |X| X[1] == aCodFol[71,1] .and. X[9] #"D" .and. X[7] # 'I' })
       IF nPos > 0
          fDelPd(aPd[nPos,1])
       EndIF
Else
       nPos := Ascan(aPd, { |X| X[1] == aCodFol[15,1] .and. X[9] #"D" .and. X[7] # 'I' })
       IF nPos > 0
          fDelPd(aPd[nPos,1])
       EndIF
       nPos := Ascan(aPd, { |X| X[1] == aCodFol[66,1] .and. X[9] #"D" .and. X[7] # 'I' })
       IF nPos > 0
          fDelPd(aPd[nPos,1])
       EndIF
EndIF

// Substituido pelo assistente de conversao do AP6 IDE em 07/10/02 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP6 IDE em 07/10/02
/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³fVerbas_Pensao³ Autor ³Marinaldo de Jesus     ³ Data ³15/06/1999³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Carrega as Verbas Para a Apuracao da Base de Calculo da Pensao  ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
// Substituido pelo assistente de conversao do AP6 IDE em 07/10/02 ==> Function fVerbas_Pensao
Static Function fVerbas_Pensao()
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Verbas Para a Folha de Pagamento                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF !Empty(SZB->ZB_VERBSAL)
   For i := 1 To Len(SZB->ZB_VERBSAL) Step 3
         IF !Empty(Subst(SZB->ZB_VERBSAL,i,3))
            cBaseFolha  := cBaseFolha + Subst(SZB->ZB_VERBSAL,i,3) + "_"
         EndIF
   Next i
EndIF

IF !Empty(SZB->ZB_VERBSA1)
   For i := 1 To Len(SZB->ZB_VERBSA1) Step 3
         IF !Empty(Subst(SZB->ZB_VERBSA1,i,3))
            cBaseFolha  := cBaseFolha + Subst(SZB->ZB_VERBSA1,i,3) + "_"
         EndIF
   Next i
EndIF
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Verbas Para Ferias                                            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF !Empty(SZB->ZB_VERBFER)
   For i := 1 To Len(SZB->ZB_VERBFER) Step 3
         IF !Empty(Subst(SZB->ZB_VERBFER,i,3))
            cBaseFerias := cBaseFerias + Subst(SZB->ZB_VERBFER,i,3) + "_"
         EndIF
   Next i
EndIF

IF !Empty(SZB->ZB_VERBFE1)
   For i := 1 To Len(SZB->ZB_VERBFE1) Step 3
         IF !Empty(Subst(SZB->ZB_VERBFE1,i,3))
            cBaseFerias := cBaseFerias + Subst(SZB->ZB_VERBFE1,i,3) + "_"
         EndIF
   Next i
EndIF
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Verbas Para 13o. Salario                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cBase13Sal  := ""
IF !Empty(SZB->ZB_VERB13S)
   For i := 1 To Len(SZB->ZB_VERB13S) Step 3
         IF !Empty(Subst(SZB->ZB_VERB13S,i,3))
            cBase13Sal := cBase13Sal + Subst(SZB->ZB_VERB13S,i,3) + "_"
         EndIF
   Next i
EndIF

IF !Empty(SZB->ZB_VERB13S)
   For i := 1 To Len(SZB->ZB_VERB131) Step 3
         IF !Empty(Subst(SZB->ZB_VERB131,i,3))
            cBase13Sal := cBase13Sal + Subst(SZB->ZB_VERB131,i,3) + "_"
         EndIF
   Next i
EndIF

// Substituido pelo assistente de conversao do AP6 IDE em 07/10/02 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP6 IDE em 07/10/02
/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³fMontaBase_Pen³ Autor ³Marinaldo de Jesus     ³ Data ³15/06/1999³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Monta a Base Para o Calculo da Pensao Alimenticia.              ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
// Substituido pelo assistente de conversao do AP6 IDE em 07/10/02 ==> Function fMontaBase_Pen
Static Function fMontaBase_Pen()

For i := 1 To Len(aPD)
      IF aPD[i,9] != "D"
         IF aPD[i,1] $ cBaseFolha .and. SZB->ZB_MINIMO != "S" .and. SZB->ZB_FIXO != "S"
            nBaseFolha  := nBaseFolha  + IF(aPD[i,1]>="101".and.aPD[i,1]<="399",aPd[i,5],apd[i,5]*(-1))
         ElseIF SZB->ZB_MINIMO == "S" .and. aPD[i,1] $ cBaseFolha 
                nAcMinFolha := nAcMinFolha + IF(aPD[i,1]>="101".and.aPD[i,1]<="399",aPd[i,5],apd[i,5]*(-1))
         ElseIF SZB->ZB_FIXO   == "S" .and. aPD[i,1] $ cBaseFolha 
                nAcFixFolha := nAcFixFolha + IF(aPD[i,1]>="101".and.aPD[i,1]<="399",aPd[i,5],apd[i,5]*(-1))
         ElseIF SZB->ZB_INCPENA == "S" .and. PosSrv(aPD[i,1],SRA->RA_FILIAL,"RV_PENSAO") == "S" ;
                                       .and. PosSrv(aPD[i,1],SRA->RA_FILIAL,"RV_REFFER") != "S" ;
                                       .and. PosSrv(aPD[i,1],SRA->RA_FILIAL,"RV_REF13" ) != "S"
                nBaseFolha  := nBaseFolha  + IF(aPD[i,1]>="101".and.aPD[i,1]<="399",aPd[i,5],0)
         EndIF
         IF aPD[i,1] $ cBaseFerias .and. SZB->ZB_MINIMO != "S"
            nBaseFerias := nBaseFerias + IF(aPD[i,1]>="101".and.aPD[i,1]<="399",aPd[i,5],apd[i,5]*(-1))
         ElseIF SZB->ZB_MINIMO == "S" .and. aPD[i,1] $ cBaseFerias 
                nAcMinFerias := nAcMinFerias + IF(aPD[i,1]>="101".and.aPD[i,1]<="399",aPd[i,5],apd[i,5]*(-1))
         ElseIF SZB->ZB_FIXO   == "S" .and. aPD[i,1] $ cBaseFerias
                nAcFixFerias := nAcFixFerias + IF(aPD[i,1]>="101".and.aPD[i,1]<="399",aPd[i,5],apd[i,5]*(-1))
         ElseIF SZB->ZB_INCPENA == "S" .and. PosSrv(aPD[i,1],SRA->RA_FILIAL,"RV_PENSAO") == "S" ;
                                       .and. PosSrv(aPD[i,1],SRA->RA_FILIAL,"RV_REFFER") == "S" 
                nBaseFerias  := nBaseFerias  + IF(aPD[i,1]>="101".and.aPD[i,1]<="399",aPd[i,5],0)
         EndIF
         IF aPD[i,1] $ cBase13Sal .and. SZB->ZB_MINIMO != "S"
            nBase13Sal  := nBase13Sal  + IF(aPD[i,1]>="101".and.aPD[i,1]<="399",aPd[i,5],apd[i,5]*(-1))
         ElseIF SZB->ZB_MINIMO == "S" .and. aPD[i,1] $ cBase13Sal 
                nAcMin13Sal := nAcMin13Sal + IF(aPD[i,1]>="101".and.aPD[i,1]<="399",aPd[i,5],apd[i,5]*(-1))
         ElseIF SZB->ZB_FIXO   == "S" .and. aPD[i,1] $ cBase13Sal 
                nAcFix13Sal := nAcFix13Sal + IF(aPD[i,1]>="101".and.aPD[i,1]<="399",aPd[i,5],apd[i,5]*(-1))
         ElseIF SZB->ZB_INCPENA == "S" .and. PosSrv(aPD[i,1],SRA->RA_FILIAL,"RV_PENSAO") == "S" ;
                                       .and. PosSrv(aPD[i,1],SRA->RA_FILIAL,"RV_REF13" ) == "S"
                nBase13Sal  := nBase13Sal  + IF(aPD[i,1]>="101".and.aPD[i,1]<="399",aPd[i,5],0)
         EndIF
      EndIF
Next i

IF SZB->ZB_MINIMO == "S"
   nBaseFolha  := ( ( Val_SalMin * SZB->ZB_QTDSALM ) + nAcMinFolha  )
   nBaseFerias := ( ( Val_SalMin * SZB->ZB_QTDSALM ) + nAcMinFerias )
   nBase13Sal  := ( ( Val_SalMin * SZB->ZB_QTDSALM ) + nAcMin13Sal  )
Else
   IF SZB->ZB_FIXO == "S"
      nBaseFolha  := ( SZB->ZB_VLRFIXO + nAcFixFolha  )
      nBaseFerias := ( SZB->ZB_VLRFIXO + nAcFixFerias )
      nBase13Sal  := ( SZB->ZB_VLRFIXO + nAcFix13Sal  )
   EndIF
EndIF

// Substituido pelo assistente de conversao do AP6 IDE em 07/10/02 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP6 IDE em 07/10/02

