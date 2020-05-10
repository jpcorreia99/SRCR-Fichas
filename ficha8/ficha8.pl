%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Programacao em logica estendida
% Representacao de conhecimento imperfeito

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% SICStus PROLOG: definicoes iniciais

:- op( 900,xfy,'::' ).
:- discontiguous '::'/2.
:- discontiguous servico/2.
:- discontiguous ato/4.
:- discontiguous excecaoServico/1.
:- discontiguous excecaoAto/1.
:- discontiguous excecao/1.
:- dynamic servico/2. % permite adicionar conhecimento em runtime
:- dynamic ato/4.
:- dynamic excecaoServico/1.
:- dynamic excecaoAto/1.
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


%-------------------------------------------------------------------------
% a)
%
%   INCERTOS
%   excecaoServico(servico(Servico,Enfermeira)):-
%    servico(#007,teodora).

%   Marco Filipe Vieira Gomes .
%   Marco Filipe Vieira Gomes .
   
%nuloIncerto(#007).
%excecaoServico(servico(Servico,Enfermeira)):-
% servico(#007,teodora).

   %IMPRECISOS
%   excecaoData(ato(penso,ana,josefa,segunda)).
%   excecaoData(ato(penso,ana,josefa,sexta)).
   
% servico: Nome, Enfermeira -> {V,F,D}
% ato: Nome, Enfermeira, Utente, Data -> {V,F,D}

servico(ortopedia,amelia).
servico(obstetricia,ana).
servico(obstetricia,maria).
servico(obstetricia,mariana).
servico(geriatria,sofia).
servico(geriatria,susana).
% incerto
nuloIncerto(007).
excecaoServico(servico(_,Enfermeira)):-
    servico(007,Enfermeira).
servico(007,teodora).

% interdito
servico(np9,zulmira).
nuloInterdito(np9).
excecaoServico(_,Enfermeira):-
    servico(np9,Enfermeira).



% atos

ato(penso,ana,joana,sabado).
ato(gesso,amelia,jose,domingo).

% incerto
excecaoAto(ato(_,Enfermeira,Utente,Data)):-
    ato(017,Enfermeira,Utente,Data).
ato(017,mariana,joaquina,domingo).

% incerto
excecaoAto(ato(_,_,_,_)):-
    ato(domicilio,maria,121,251).
ato(domicilio,maria,121,251).

% impreciso
ato(domicilio,susana,[joao,jose],segunda).

excecao(ato(domicilio,joao,josefa,segunda)).
excecao(ato(domicilio,jose,josefa,segunda)).

% incerto
excecao(ato(Procedimento,_,Utente,Data)):-
    ato(Procedimento,313,Utente,Data).
ato(sutura,313,josue,segunda).

%
excecao(ato(sutura,Nome,josefa,Data)):- member(Nome,[maria,mariana]), member(Data,[terca,sexta]).

%
excecao(ato(penso,ana,jacinta,Data)):- member(Data,[segunda,terca,quarta,quinta,sexta]).

feriado('25_de_abril').

+ato(_,_,_,Dia) :: nao(feriado(Dia)).

+ato(_,_,_,Dia) :: (solucoes((Dia), feriado(Dia),S1),
                    comprimento(S1,N1),
                    N1==0).

-ato(_,Profissional,_,_) :: (solucoes((Profissional),ato(_,Profissional,_,_),S1),
                            comprimento(S1,N1),
                            N1==0).