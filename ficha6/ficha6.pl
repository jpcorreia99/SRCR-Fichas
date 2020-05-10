% SICStus PROLOG: Declaracoes iniciais
 
:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
%:- set_prolog_flag( unknown,fail ).
 
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: definicoes iniciais
:- discontiguous ave/1.
:- discontiguous mamifero/1.
:- dynamic '-'/1.
:- dynamic mamifero/1.
:- dynamic morcego/1.
:- dynamic canario/1.
:- dynamic avestruz/1.
:- dynamic pinguim/1.
:- dynamic periquito/1.
:- dynamic cao/1.
:- dynamic gato/1.



:- op( 1100,xfy,'??' ).
 
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

excecao(voa(X)):- avestruz(X).
excecao(-voa(X)):- morcego(X).

% I)
voa( X ) :-
    ave( X ),nao( excecao( voa( X ) ) ).


% II)
 -voa( X ) :-
    mamifero( X ),nao( excecao( -voa( X ) ) ).

% III)
-voa( tweety ).

%IV)
ave(pitigui).

%V)
ave(X):- canario(X).

%VI)
ave(X):- periquito(X).

%VII)
canario(piupiu).

% VIII)
mamifero(silvestre).

% IX)
mamifero(X):- cao(X).

%X)
mamifero(X):- gato(X).

%XI)
cao(bobby).

%XII)
ave(X):- avestruz(X).

%XIII)

ave(X):- pinguim(X).

%IXV)
avestruz(trux).

% XV)
pinguim(pinguim).

% XVI)
mamifero(X):- morcego(X).
 
% XVII)
morcego(bateméme).
 
 
 
 
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
 
 
 
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado nao: Questao -> {V,F}
 
nao( Questao ) :-
    Questao, !, fail.
nao(_).