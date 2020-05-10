pertence(X, [X|_]).
pertence(X,[H|T]):- X\=H, pertence(X,T).

lengthL([],0).
lengthL([_|T],R):- lengthL(T,N), R is N+1.

nao(Questao):- Questao,!,fail.
nao(_).

diferentes([],0).
diferentes([H|T],N):- pertence(H,T), diferentes(T,N).
diferentes([H|T],R):- nao(pertence(H,T)), diferentes(T,N), R is N+1.

%% Construir a extensão do predicado «apaga1» que apaga a primeira ocorrência de um elemento de uma lista

delete_one(_, [], []).
delete_one(Term, [Term|Tail], Tail):-!.
delete_one(Term, [Head|Tail], [Head|Result]) :-
  delete_one(Term, Tail, Result).

delete_all(_,[],[]).
delete_all(Term, [Term|Tail],Result):-delete_all(Term,Tail,Result).
delete_all(Term, [Head|Tail],[Head|Result]):-
    delete_all(Term,Tail,Result).

% Construir a extensão do predicado «adicionar»que insereum elementonuma lista, sem o repetir;

adiciona(Term,[],[Term]).
adiciona(Term,[Term|Tail],[Term|Tail]).
adiciona(Termo,[Head|Tail],[Head|Result]):-
    adiciona(Termo, Tail,Result).

% Construir a extensão do predicado «concatenar», que resulta na concatenação doselementos da lista L1 com os elementos da lista L2;

concatena([],[Head|Tail],[Head|Tail]).
concatena([Head1|Tail1],[Head2|Tail2],[Head1|Result]):-
    concatena(Tail1,[Head2|Tail2],Result).

reverse([],Acc,Acc).
reverse([H|T],Acc,R) :- reverse(T,[H|Acc],R).

copy([],[]).
copy([Head1|Tail1],[Head1|Tail2]):-
    copy(Tail1, Tail2).

intercalar(_,[],[]).
intercalar(Termo,[Head|Tail],[Head,Termo|Result]):-
    intercalar(Termo, Tail, Result).
