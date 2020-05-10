filho(joao,jose).
filho(jose, manuel).
filho(carlos,jose).
filho(F,P):-pai(P,F).

pai(paulo,filipe).
pai(andre,jose).
pai(paulo,maria).
pai(P,F):-filho(F,P).


avo(antonio,nadia).
avo(A,N):-filho(N,X),pai(A,X).

neto(nuno,ana).
neto(N,A):-avo(A,N).

masculino(joao).
masculino(jose).
feminino(maria).
feminino(joana).

descendente(X,Y):- avo(Y,X); pai(Y,X); filho(X,Y);neto(X,Y).

descendente( D,A,1 ) :-
    filho( D,A ).
descendente( D,A, G  ) :-
    filho( D,X ),
    descendente( X,A,N ),
	G is N+1.