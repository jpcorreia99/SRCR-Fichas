

avaliar_credito(VLM,Renda,Automovel, Credito):-
    Renda < 0.3*VLM,
    Renda+Automovel+Credito  < 0.4*VLM.


emprestimo( V,H,A,CC,sim ) :-
	P1 is (H/V)*100,
	P2 is ((H+A+CC)/V)*100,
	P1 < 30,	
	P2 < 40.

