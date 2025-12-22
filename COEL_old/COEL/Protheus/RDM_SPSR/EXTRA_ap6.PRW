#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 07/10/02

User Function EXTRA()        // incluido pelo assistente de conversao do AP6 IDE em 07/10/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("FHORAS,")

fHoras:=FbuscaPd("796","H")

If  fHoras > 60
    FGeraVerba("215",1,(FHoras - 60),,,"H","I",,,,.T.)
    Fhoras := 60
Endif
If  fHoras > 40
    FGeraVerba("210",1,(FHoras - 40),,,"H","I",,,,.T.)
    Fhoras := 40
Endif

If  fHoras > 25
    FGeraVerba("208",1,(FHoras - 25),,,"H","I",,,,.T.)
    Fhoras := 25
Endif
If  fHoras > 00
    FGeraVerba("213",1,(FHoras),,,"H","I",,,,.T.)
    Fhoras := 00
Endif
Return                                                                                                                                                                                                                                      
