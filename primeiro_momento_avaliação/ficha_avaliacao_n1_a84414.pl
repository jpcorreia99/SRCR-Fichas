:- dynamic data/3.
:- dynamic pai/2.
:- dynamic excecao/1.
:- dynamic nulo/1.
:- dynamic data_de_nascimento/2.
:- discontiguous (-)/1.

:- discontiguous pai/2.
:- discontiguous data_de_nascimento/2.
:- discontiguous excecao/1.
:- op( 900,xfy,'::' ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado data: Dia,Mes,Ano -> {V,F}
% Caso especial de Fevereiro em ano não bissexto
data(Dia,2,Ano):- 
    Dia >= 1,
    Dia =<29,
    0 =:= mod(Ano,4). % ano bissexto

data(Dia,2,_):- 
    Dia >= 1,
    Dia =< 28. % ano não bissexto

data(Dia,Mes,_):- 
    member(Mes,[4,6,9,11]), % meses de 30 dias
    Dia >=1,
    Dia =<30.

data(Dia,Mes,_):- 
    member(Mes,[1,3,5,7,8,10,12]), %meses de 31 dias
    Dia >=1,
    Dia =<31.

-pai(P,F):- nao(pai(P,F)), nao(excecao(pai(P,F))).
-data_de_nascimento(Data,Crianca):- nao(data_de_nascimento(Data,Crianca)) , nao(excecao(data_de_nascimento(Data,Crianca))).

% i
pai(abel,ana).
pai(alice, ana).
data_de_nascimento(data(1,1,2010),ana).

% ii
pai(antonio, anibal).
pai(alberta, anibal).
data_de_nascimento(data(2,1,2010),anibal).

% iii
pai(bras, berto).
pai(belem, berto).
data_de_nascimento(data(2,2,2010),berto).

pai(bras, berta).
pai(belem, berta).
data_de_nascimento(data,(2,2,2010),belem).

% iv

data_de_nascimento(data(3,3,2010),catia).


% v - conhecimento impreciso 
pai(catia,crispim).
excecao(pai(celso,crispim)).
excecao(pai(caio, crispim)).

% vi
pai(daniel,danilo).
pai(pai_desconhecido,danilo).
% é excecao se o pai desse filho for pai desconhecido
%o danilo está marcado como pai desconhecido logo vai dar desconhecido para qualquer pai que se lhe pergunte
excecao(pai(_,Filho)):- pai(pai_desconhecido,Filho).

% vii

pai(elias,eurico).
pai(elsa,eurico).

excecao(data_de_nascimento(data(5,5,2010)),eurico).
excecao(data_de_nascimento(data(15,5,2010)),eurico).
excecao(data_de_nascimento(data(25,5,2010)),eurico).

% viii
excecao(pai(fausto,fabia)).
excecao(pai(fausto,octavia)).


pai(mae_desconhecido,danilo).
excecao(pai(_,Filho)):- pai(mae_desconhecido,Filho).


% ix
pai(guido,golias).
pai(guida,golias).

data_de_nascimento('data_desconhecida',golias).
nulointerdito('data_desconhecida').
excecao(data_de_nascimento(_,Crianca)) :- data_de_nascimento(data_desconhecida,Crianca).


%x
-data_de_nascimento(data(8,08,2010),helder).

%xi
excecao(data_de_nascimento(data(Dia,08,2010),ivo)):- Dia >=1, Dia=<15.



%invariante estrutural: não permitir a existência de mais do que dois pais 
+pai(_,F) :: (
    solucoes(Ps,pai(Ps,F),S1),
    comprimento(S1,R1),
    R1 =< 2
).

% invariante estrutural: não permitir uma segunda data de nascimento
+data_de_nascimento(_,Filho):: (
    solucoes(Datas,data_de_nascimento(Datas,Filho),S1),
    comprimento(S1,R1),
    R1==1
).


% invariante referencial(pois usa o predicado nulo): não impedir inserir a inserção de uma data de nascimento caso seja interdito
% visto não estar implementado um sistema completo de evolução de conhecimento
% este predicado não é utilizado, porém se o sistema permitir evolução do conhecimento
% já é utilizado
+data_de_nascimento(_,Filho):: (
    solucoes((Data),data_de_nascimento(Data,Filho),S1),
    nao(isDataListNuloInterdito(S1))
).

%predicado auxiliar que verifica se alguma das datas é nula interdita
isDataListNuloInterdito([]):-!,fail.
isDataListNuloInterdito([Data|T]):- nulointerdito(Data);isDataListNuloInterdito(T).



evolucao( Termo ) :-
    solucoes( Invariante, +Termo::Invariante,Lista ),  %coloca numa lista todos os invariantes,
    insercao( Termo ), %insere o termo na base de informação para ser testado a seguir
    teste( Lista ).  % testa o termo contra os invariantes, se passar fica


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado que permite a evolucao do conhecimento

evolucao( Termo ) :-
    solucoes( Invariante, +Termo::Invariante,Lista ),  %coloca numa lista todos os invariantes,
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