%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Programacao em logica estendida
% Representacao de conhecimento imperfeito

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
%:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: definicoes iniciais

:- op( 900,xfy,'::' ).
:- dynamic jogo/3.
:- discontiguous jogo/3.
:- discontiguous excecao/1.
:- discontiguous '::'/2.
:- op( 1100,xfy,'??' ).


%--------------------------------- - - - - - - - - - -  -  questão i
jogo( 1,aa,500 ).  

%--------------------------------- - - - - - - - - - -  -  questão ii


jogo( 2,bb,xpto2123 ).
excecao( jogo( Jogo,Arbitro,_) ) :-
    jogo( Jogo,Arbitro,xpto0123 ).

%--------------------------------- - - - - - - - - - -  -  questão iii

excecao( jogo(3,cc,500)).
excecao( jogo(3,cc,2500)).

%--------------------------------- - - - - - - - - - -  -  questão iv
excecao( jogo( 4,dd,Ajudas ) ) :-
    Ajudas >= 250, Ajudas =< 750.

%--------------------------------- - - - - - - - - - -  -  questão v

jogo(5,ee,xpto5123).
nulo(xpto5123).
excecao(jogo(Jogo,Arbitro,_)) :- jogo(Jogo,Arbitro,xpto5123).

%--------------------------------- - - - - - - - - - -  -  questão vi

excecao( jogo(6,dd,250)).
excecao( jogo(6,dd,Ajudas)):-Ajudas >=5000.

%--------------------------------- - - - - - - - - - -  -  questão vii

-jogo(7,gg,2500).
jogo(7,gg,xpto7123).
excecao(jogo(Jogo,Arbitro,_)) :- jogo(Jogo,Arbitro,xpto7123).

%--------------------------------- - - - - - - - - - -  -  questão viii

cerca( X,Sup,Inf ) :-
    Sup is X * 1.25,
    Inf is X * 0.75.

excecao( jogo( 8,hh,Ajudas) ) :-
    cerca(1000,Max,Min),
    Ajudas >= Min, Ajudas =< Max.


%--------------------------------- - - - - - - - - - -  -  questão ix

proximo(X,Sup,Inf):-
    Sup is X * 1.01,
    Inf is X * 0.99.

excecao( jogo(9,ii,Ajudas)):-
    proximo(3000, Max, Min),
    Ajudas >= Min, Ajudas =< Max.

%--------------------------------- - - - - - - - - - -  -  questão x
% Invariante Estrutural: nao admitir mais do 1 arbritro para o mesmo jogo
+jogo( Id,_,_) :: (solucoes( (Arbitros),(jogo( Id,Arbitros,_)),S),
                  comprimento( S,N ), 
                  N ==1).

%--------------------------------- - - - - - - - - - -  -  questão xi
% Invariante Estrutural: um arbitro não pode abritrar mais do que 3 jogos
+jogo(_,Arbitro,_):: (solucoes( (Ids),(jogo( Ids,Arbitro,_)),S),
                    comprimento( S,N ), 
                    N =<3).

%--------------------------------- - - - - - - - - - -  -  questão xii
% Invariente Referencial: O mesmo árbitro não pode apitar duas partidas consecutivas
nao_consecutivos([]).
nao_consecutivos([_]).
nao_consecutivos([H1,H2|X]):- H1 =\= (H2-1), nao_consecutivos([H2|X]).

+jogo(_,Arbitro,_):: (solucoes( (Ids),(jogo( Ids,Arbitro,_)),S),
                        nao_consecutivos(S)).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extens�o do predicado que permite a evolucao do conhecimento

evolucao( Termo ) :-
    solucoes( Invariante, +Termo::Invariante,Lista ),  %coloca numa lista todos os invariantes
    insercao( Termo ), %insere o termo na base de informação para ser testado a seguir
    teste( Lista ).  % testa o termo contra os invariantes, se passar fica

insercao( Termo ) :-
    assert( Termo ). % o assert insere o termo na base de conhecimento
insercao( Termo ) :-
    retract( Termo ), !,fail. % se não o consegui inserir direito, tem de o remover
	
teste( [] ).
teste( [R|LR] ) :-  % verifica se todos os testes ao invariante são positivos
    R,   
    teste( LR ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extens�o do predicado que permite a involucao do conhecimento

involucao( Termo ) :-
    solucoes( Invariante,-Termo::Invariante,Lista ),
    remocao( Termo ),
    teste( Lista ).

remocao( Termo ) :-
    retract( Termo ).
remocao( Termo ) :- 
    assert( Termo ),!,fail.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado nao: Questao -> {V,F}

nao( Questao ) :-
    Questao, !, fail.
nao( _ ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -

solucoes( X,Y,Z ) :-
    findall( X,Y,Z ).

comprimento( S,N ) :-
    length( S,N ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado si: Questao,Resposta -> {V,F}
%                            Resposta = { verdadeiro,falso,desconhecido }
 
si( Questao,verdadeiro ) :-
    Questao.
si( Questao,falso ) :-
    -Questao.
si( Questao,desconhecido ) :-
    nao( Questao ),
    nao( -Questao ).
 
Questao ?? verdadeiro :-
    Questao.
Questao ?? falso :-
    -Questao.
Questao ?? desconhecido :-
    nao( Questao ),
    nao( -Questao ).
 