/*
true(sim).
homem(homem).

caixaSimNao(Pergunta, Titulo) :-
	new(Interface, dialog(Titulo)),

	new(Resposta, menu(Pergunta)),
	send_list(Resposta, append, [sim, nao]),

	new(Botao, button('Continuar', message(Interface, return, Resposta?selection))),

	send_list(Interface, append, [Resposta, Botao]),
	get(Interface, confirm, Resposta1),
	free(Interface),
	true(Resposta1).
*/

% List of symptoms
delayedSym :- 
	write('The pacient present one or more of these symptoms?\n\n. Severe colic\n. Reflux-GORD\n. Food refusal or aversion\n. Perianal redness\n. Constipation\n. Abdominal discomfort\n. Blood/mucus in stools (in an otherwise well infant)\n. Pruritus, erythema\n. Significant atopic eczema').

acuteOnsetSym :-
	write('The pacient present one or more of these symptoms?\n\n. Vomiting\n. Diarrhoea\n. Abdominal pain/colic\n. Acute pruritus, erythema, urticaria\n. Angioedema\n. Acute ‘flare up’ of atopic eczema').

faltheringGrowth :-
	write('The paciente present signs of faltering growth?').

% Time of symptoms
timeSym :-
	write('Write the time(hours) that onset of symptoms after ingestion of cow’s milk protein'),
	nl,
	read(Input),
	acuteOnset(Input).

% Acute onset symptoms diagnostic
acuteOnset(Time):- Time > 1, delayedSym; acuteOnsetSym.




% Main
diag :- true; send(@display, inform, 'O paciente diagnosticado nao possui anemia.').

% Graphic Interface

:-	pce_image_directory('./').
	resource(imagem, image, image('apvl.jpeg')).

:-  	new(Interface, dialog('DIAGNOSTICO DE ANEMIA')),
	new(Menu, menu_bar),
	send(Menu, append, new(Consultar, popup(menu))),

	% OPCOES DO MENU

	send_list(Consultar, append, [menu_item('Autores', message(@display, inform,
	"Desenvolvido por:\n- Emerson Victor\n- Ewerton Felipe\n- José Claudino\n- José Tomáx\n\n(C) 2017.")), menu_item(sair, and(message(Interface, destroy), message(Interface, free)))]),

	new(Imagem, label(nome, resource(imagem))),
	new(Titulo, text('CMPA Diagnostic System')),
	new(Botao, button('Iniciar Consulta', and(message(@prolog, diag)))),

	% FORMATANDO O TITULO DO PROGRAMA

	send(Titulo, font, font(times, bold, 20)),
	send_list(Interface, append, [Menu, Imagem, Titulo, Botao]),
	send(Interface, open, point(300,300)).
