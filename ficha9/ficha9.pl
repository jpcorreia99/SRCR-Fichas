% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Grafos (Ficha 9)

%--------------------------------- - - - - - - - - - -  -  -  -  -   -

grafo([a,b,c,d,e,f,g], [a(a,b),a(c,f),a(c,d),a(d,f),a(f,g)]).

adjacente(X,Y,grafo(_,L_arestas)):- 
    member(a(X,Y),L_arestas); member(a(Y,X),L_arestas).



nao( Questao ) :-
    Questao, !, fail.
nao( _ ).


caminho(Grafo,X,Y,P):-
    caminhoAux(Grafo,X,[Y],P).

caminhoAux(_,X,[X|T],[X|T]).
caminhoAux(G,X,[Y|T],P) :-
    adjacente(Prox_nodo,Y,G), nao(member(Prox_nodo,[Y|T])), caminhoAux(G,X,[Prox_nodo,Y|T],P).
     


ciclo(G,A,P) :- 
    adjacente(Nodo_final,A,G), %encontrar um nodo que ligue a A 
     caminho(G,A,Nodo_final,Ciclo_incompleto), % verificar se existe e guardar o caminho de A ao nodo que existe antes dele em P1
     length(Ciclo_incompleto,S1), %verificar o tamanho desse caminho
     S1 > 2, % Se o tamanho do caminho for 2 não serve porque na verdade é logo o A que está ligado ao nodo anterior
     append(Ciclo_incompleto,[A],P). % termina o ciclo 



append( [], X, X).                               
append( [X | Y], Z, [X | W]) :- append( Y, Z, W).