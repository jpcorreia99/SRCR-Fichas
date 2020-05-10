%ex1

%Construir a extensão de um predicado que calcule a soma de dois valores

soma(X,Y, R):-R is X+Y.

%Construir a extensão de um predicado que calcule a soma de três valores

soma(X,Y,Z, R):-R is X+Y+Z.

%Construir a extensão de um predicado que calcule a soma de um conjunto de valores;

somaL([],0).
somaL([H|T],R):-somaL(T,N), R is N+H.

%%aritmetica(X,Y,SOMA,SUB,MUL,DIV):- SOMA is X+Y, SUB is X-Y, MUL is X*Y, DIV is X/Y.
aritmetica(X,Y,'SUM',R):- R is X+Y.
aritmetica(X,Y,'SUB',R):- R is X-Y.
aritmetica(X,Y,'MUL',R):- R is X*Y.
aritmetica(X,Y,'DIV',R):- R is X/Y.

%aritmeticaL([],0,1).
%aritmeticaL([H|T],S,M):- aritmeticaL(T,S_,M_), S is S_+H, M is M_*H. 

aritmeticaL([],'SUM',0).
aritmeticaL([],'MUL',1).
aritmeticaL([H|T],'SUM',R):- aritmeticaL(T,'SUM',N), R is N+H.
aritmeticaL([H|T],'MUL',R):- aritmeticaL(T,'MUL',N), R is N*H.

max_(X,Y,R):- R is max(X, Y).

maxT(X,Y,Z,R):- R is max(max(X,Y),Z).

maxL([H],R):-R is H.
maxL([H|T],R):- maxL(T,N), R is max(H,N).
 
media(L,R):-length(L, A), somaL(L,S), R is S/A.

vazios([],0).
vazios([[]|T],R):- vazios(T,N), R is N+1.
%%vazios([_|T],R):- vazios(T,R).


