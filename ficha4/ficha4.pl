par(0).
par(-1):-!,fail.
par(X):- X < 0, N is X+2, par(N).
par(X):- X > 0, N is X-2, par(N).

impar(1).
impar(0):-!,fail.
impar(X):- X>0, N is X-2, impar(N).
impar(X):- X<0, N is X+2, impar(N).

natural(1).
natural(N):- N>0, AUX is N-1, natural(AUX).

inteiro(N):- integer(N).
          
isDiv(N,_):- N<1,!,fail.
isDiv(_,0):-!,fail.
isDiv(N,D):- N>=D, 0 is mod(N,D).

lDiv(_,0,[]).
lDiv(N1,N2,L):- isDiv(N1,N2),lDiv(N1,N2-1,L2), L2 is [N2|L].
lDiv(N1,N2,L):-lDiv(N1,N2-1,L).

%% greatest commo divisor 
gcd(0, X, X):- X > 0, !.
gcd(X, Y, Z):- X >= Y, X1 is X-Y, gcd(X1,Y,Z).
gcd(X, Y, Z):- X < Y, X1 is Y-X, gcd(X1,X,Z).

mdc( X,Y,R ) :-
    X > Y,
    X1 is X-Y,
    mdc( X1,Y,R ).
mdc( X,Y,R ) :-
    Y > X,
    Y1 is Y-X,
    mdc( X,Y1,R ).
mdc( X,X,X ).