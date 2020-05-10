% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Grafos Pesados (Ficha 10)

%--------------------------------- - - - - - - - - - -  -  -  -  -   -

grafo([madrid, cordoba, sevilla, jaen, granada, huelva, cadiz],
  [aresta(huelva, sevilla, a49, 94),
   aresta(sevilla, cadiz,ap4, 125),
   aresta(sevilla, granada, a92, 256),
   aresta(granada, jaen,a44, 97),
   aresta(sevilla, cordoba, a4, 138),
   aresta(jaen,madrid, a4, 335),
   aresta(cordoba, madrid, a4, 400)]
 ).


adjacente(X,Y,Km,Es,grafo(_,L_arestas)):- 
    member(aresta(X,Y,Es,Km),L_arestas); 
    member(aresta(Y,X,Es,Km),L_arestas).


caminho(Grafo,X,Y,P,Km,Es):-
    caminhoAux(Grafo,X,[Y],P,Km,Es).

caminhoAux(_,X,[X|T],[X|T],0,[]).
caminhoAux(G,X,[Y|T],P,Km,Estradas) :-
    adjacente(Prox_nodo,Y,Ki,E,G), nao(member(Prox_nodo,[Y|T])), caminhoAux(G,X,[Prox_nodo,Y|T],P,K,Es), Km is K + Ki,
    append(Es,[E],Estradas).
     


nao( Questao ) :-
    Questao, !, fail.
nao( _ ).


ciclo(G,A,P,K,E) :-
    adjacente(Nodo_final,A,KS,ES,G),
    caminho(G,A,Nodo_final,Ciclo_incompleto,KM,EM),
    length(Ciclo_incompleto,S1),
    S1 > 2,
    append(Ciclo_incompleto,[A],P),
    K is KS + KM,
    append(EM,[ES], E).



