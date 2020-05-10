%a) é um problema de estado único 

%b)

/*
 Estados: Conjunto de pares ordenados(X,Y), x pertence a [0..8] e y a [0..5]
 Estado inicial: (0,0)
 Estado objetico: (4,_) ; (_,4)
 Operações: encher()
            esvaziar(),
            transferir()
 Teste objetivo: final(4,_) ; final(_,4)
 Custo da solução: 1 por operação, logo é a soma do nº de operações
 
*/

/*
digraph G {
  "inicial(0,0)" -> "n1(8,0)"
  "inicial(0,0)" -> "n1(0,5)"
  "n1(8,0)" -> "n2(0,0)"
  "n1(8,0)" -> "n2(3,5)"
  "n1(8,0)" -> "n2_(8,5)"
  "n1(0,5)" -> "n2_(0,0)"
  "n1(0,5)" -> "n2(5,0)"
  "n1(0,5)" -> "n2(8,5)"
  "n2(0,0)" -> "n3(8,0)"
  "n2(0,0)" -> "n3(0,5)"
  "n2(3,5)" -> "n3(8,5)"
  "n2(3,5)" -> "n3___(0,5)"
  "n2(3,5)" -> "n3_(3,0)"
  "n2(3,5)" -> "n3_(8,0)"
  "n2_(0,0)" -> "n3___(8,0)"
  "n2_(0,0)" -> "n3_(0,5)"
  "n2(5,0)" -> "n3_(0,0)"
  "n2(5,0)" -> "n3__(8,0)"
  "n2(5,0)" -> "n3__(0,5)"
  "n2(5,0)" -> "n3_(5,5)"
  "n2(8,5)" -> "n3(0,8)"
  "n2(8,5)" -> "n3(5,0)"
  "n2_(8,5)" -> "n3____(0,5)"
  "n2_(8,5)" -> "n3____(8,0)"
}



*/

%d)

% estado inicial
inicial(jarros(0,0)).

% estado final
final(jarros(4,_)).
final(jarros(_,4)).

% transicoes possiveis: atual, operacao, estado "final"
transicao(jarros(V1,V2), encher(1), jarros(8,V2)) :- V1 < 8.
transicao(jarros(V1,V2), encher(2), jarros(V1,5)) :- V2 < 5.

transicao(jarros(V1,V2), vazio(1), jarros(0,V2)) :- V1 > 0.
transicao(jarros(V1,V2), vazio(2), jarros(V1,0)) :- V2 > 0.

transicao(jarros(V1,V2), transferir(1,2), jarros(NV1, NV2)):- 
    V1>0, 
    NV1 is max(V1 - 5 + V2, 0), 
    NV1 < V1, 
    NV2 is V2 + V1 - NV1.

transicao(jarros(V1,V2), transferir(2,1), jarros(NV1, NV2)):- 
    V2>0, 
    NV2 is max(V2 - 8 + V1, 0), 
    NV2 < V2, 
    NV1 is V1 + V2 - NV2.

% d
resolvedf(Solucao) :-
    inicial(Inicial),
    resolvedf(Inicial, [Inicial], Solucao).

resolvedf(Estado, _, []) :-
    final(Estado), !. % primeiro caminho que vá desde o inicio ao fim, cut e necessario

resolvedf(Estado, Historico, [Movimento|Solucao]) :-
    transicao(Estado, Movimento, Estado1),
    \+ memberchk(Estado1,Historico),
    resolvedf(Estado1, [Estado1|Historico], Solucao).

dfTodasSolucoes(L):- findall((S,C),(resolvedf(S),length(S,C)),L).





resolvebf(Solucao):-
	inicial(InicialEstado),
	resolvebf([(InicialEstado, [])|Xs]-Xs, [], Solucao).

resolvebf([(Estado, Vs)|_]-_, _, Rs):-
	final(Estado),!, inverso(Vs, Rs).

resolvebf([(Estado, _)|Xs]-Ys, Historico, Solucao):-
	membro(Estado, Historico),!,
	resolvebf(Xs-Ys, Historico, Solucao).

resolvebf([(Estado, Vs)|Xs]-Ys, Historico, Solucao):-
	setof((Move, Estado1), transicao(Estado, Move, Estado1), Ls),
	atualizar(Ls, Vs, [Estado|Historico], Ys-Zs),
	resolvebf(Xs-Zs, [Estado|Historico], Solucao).

atualizar([], _, _, X-X).
atualizar([(_, Estado)|Ls], Vs, Historico, Xs-Ys):-
	membro(Estado, Historico),!,
	atualizar(Ls, Vs, Historico, Xs-Ys).

atualizar([(Move, Estado)|Ls], Vs, Historico, [(Estado, [Move|Vs])|Xs]-Ys):-
	atualizar(Ls, Vs, Historico, Xs-Ys).

membro(X, [X|_]).
membro(X, [_|Xs]):-
	membro(X, Xs).

membros([], _).
membros([X|Xs], Members):-
	membro(X, Members),
	membros(Xs, Members).


inverso(Xs, Ys):-
	inverso(Xs, [], Ys).

inverso([], Xs, Xs).
inverso([X|Xs],Ys, Zs):-
	inverso(Xs, [X|Ys], Zs).

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).	

bfTodasSolucoes(L):- findall((S,C),(resolvebf(S),length(S,C)),L).



todos(L):-findall((S,C), (resolvedf(S), length(S,C)), L).


minimo([(P,X)],(P,X)).
minimo([(Px,X)|L],(Py,Y)):- minimo(L,(Py,Y)), X>Y. 
minimo([(Px,X)|L],(Px,X)):- minimo(L,(Py,Y)), X=<Y. 


melhorBF(S, Custo):- findall((S,C), (resolvebf(S), length(S,C)), L), minimo(L,(S,Custo)).
melhorDF(S, Custo):- findall((S,C), (resolvedf(S), length(S,C)), L), minimo(L,(S,Custo)).