% PARTE 1 - DEFINICOES GLOBAIS

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


% PARTE 2 - DIAGNOSTICO DE ANEMIA

sintomas :-
	caixaSimNao('O paciente apresenta algum dos sintomas abaixo?\n\n- Fraqueza\n- Tonturas\n- Desmaios\n- Taquicardia\n- Palidez\n- Palpitacoes\n- Ictericia', 'DIAGNOSTICO DE ANEMIA').

hemog :-
	new(Interface, dialog('DIAGNOSTICO DE ANEMIA')),

	new(Resposta, menu('Qual o sexo do paciente?')),
	send_list(Resposta, append, [homem, mulher]),

	new(Botao, button('Continuar', message(Interface, return, Resposta?selection))),

	send_list(Interface, append,[Resposta, Botao]),
	get(Interface, confirm, Sexo),
	free(Interface),
	homem(Sexo) -> hemogCheck(135);
	hemogCheck(120).

hemogCheck(Limite) :-
	new(Interface, dialog('DIAGNOSTICO DE ANEMIA')),
	new(Resposta, text_item('Qual a quantidade de hemoglobina no sangue do paciente? (g/L)')),
	new(Botao, button('Continuar', message(Interface, return, Resposta?selection))),

	send_list(Interface, append, [Resposta, Botao]),
	get(Interface, confirm, Hemo),
	atom_number(Hemo, Hemoint),
	free(Interface),
	Hemoint < Limite.

hemat :-
	new(Interface, dialog('DIAGNOSTICO DE ANEMIA')),

	new(Resposta, text_item('Qual o percentual do nivel de hematocritos do paciente? (% por dL)')),

	new(Botao, button('Continuar', message(Interface, return, Resposta?selection))),

	send_list(Interface, append, [Resposta, Botao]),
	get(Interface, confirm, Hemat),
	free(Interface),
	atom_number(Hemat, Hematint),
	Hematint < 36.

anemia :- sintomas,(hemog; hemat).


% PARTE 3 - SUBTIPO DE ANEMIA

historico :-
	caixaSimNao('O paciente apresenta evidencias de ictericia?', 'DIAGNOSTICO DO SUBTIPO');
	caixaSimNao('O paciente apresenta evidencias de calculos biliares?', 'DIAGNOSTICO DO SUBTIPO');
	caixaSimNao('O paciente apresenta evidencias de esfenomegalia?', 'DIAGNOSTICO DO SUBTIPO');
	caixaSimNao('O paciente apresenta evidencias de hepatomegalia?', 'DIAGNOSTICO DO SUBTIPO');
	caixaSimNao('O paciente apresenta evidencias de malformacoes osseas?', 'DIAGNOSTICO DO SUBTIPO');
	caixaSimNao('O paciente apresenta evidencias de retardo mental?', 'DIAGNOSTICO DO SUBTIPO').

determinante :-
	caixaSimNao('Existem resultados laboratoriais que apontam microcitose?', 'DIAGNOSTICO DO SUBTIPO');
	caixaSimNao('Existem resultados laboratoriais que apontam eliptoitose?', 'DIAGNOSTICO DO SUBTIPO');
	caixaSimNao('Existem resultados laboratoriais que apontam esferocitose?', 'DIAGNOSTICO DO SUBTIPO');
	caixaSimNao('Existem resultados laboratoriais que apontam anisopoikilocitose?', 'DIAGNOSTICO DO SUBTIPO');
	caixaSimNao('O paciente tem anemia relacionada a comida?', 'DIAGNOSTICO DO SUBTIPO').

congenita(RBC) :-
	RBC < 4, historico -> determinante.

adquirida :-
	new(Interface, dialog('DIAGNOSTICO DO SUBTIPO')),
	new(Resposta, text_item('Qual o nivel de LDH do paciente? (IU/L)')),
	new(Botao, button('Continuar', message(Interface, return, Resposta?selection))),
	send_list(Interface, append, [Resposta, Botao]),
	get(Interface, confirm, Resposta1),
	free(Interface),
	atom_number(Resposta1, LDHint),
	LDHint > 333.

subtipo :-
	send(@display, inform, 'O paciente diagnosticado possui anemia.\nAgora, o sistema determinara o subtipo.'),
	new(Interface, dialog('DIAGNOSTICO DO SUBTIPO')),
	new(Resposta, text_item('Qual o nivel de RBC no sangue? (mi/ul)')),
	new(Botao, button('Continuar', message(Interface, return, Resposta?selection))),
	send_list(Interface, append, [Resposta, Botao]),
	get(Interface, confirm, Resposta1),
	free(Interface),
	atom_number(Resposta1, RBCint),
	congenita(RBCint) -> send(@display, inform, 'DIAGNOSTICO: Anemia hemolitica congenita.\n\nEste tipo de anemia eh usualmente causado por problemas na producao\nde membranas de globulos vermelhos (como em casos de esferocitose\nou eliptocitose). Outras possiveis causas incluem:\n\n- Problemas na producao de hemoglobina\n- Problemas no metabolismo de globulos vermelhos\n- Talassemia');
	adquirida -> send(@display, inform, 'DIAGNOSTICO: Anemia hemolitica adquirida\n\nEste tipo de anemia costuma decorrer, na maioria dos casos, de\nictericia. Apesar disso, tambem pode possuir diversas causas\nimunomediadas ou consumo de drogas. Algumas de suas outras\npossiveis causas sao:\n\n- Hipersplenismo\n- Infeccoes bacterianas\n- Infeccoes causadas por queimaduras\n- Hemoglobinuria paroxistica noturna\n- Envenenamento (toxinas)');
	send(@display, inform, 'DIAGNOSTICO: Anemia por deficiencia\n\nEste tipo de anemia eh usualmente causado por uma ingestao\ndietetica e absorcao de ferro insuficiente, ou perda de ferro\ndevido a um sangramento gastrointestinal. Outras possiveis\ncausas para este tipo de anemia sao:\n\n- Parasitas (ex. ascaridiase)\n- Hemorragias (ex. cirurgia ou parto)\n- Hematuria\n- Ulceras \n- Hemorroidas\n- Cancer').


% PARTE 4 - DIAGNOSTICO GERAL

diag :- (anemia, subtipo); send(@display, inform, 'O paciente diagnosticado nao possui anemia.').


% PARTE EXTRA - INTERFACE GRAFICA

:-	pce_image_directory('./').
	resource(imagem, image, image('blood.jpg')).

:-  	new(Interface, dialog('DIAGNOSTICO DE ANEMIA')),
	new(Menu, menu_bar),
	send(Menu, append, new(Consultar, popup(menu))),

	% OPCOES DO MENU

	send_list(Consultar, append, [menu_item('Autores', message(@display, inform,
	"Desenvolvido por:\n- Ana Lima\n- Claudio Pacheco\n- Gabriel D'Luca\n- Iswarelly Marcela\n- Vitor Lima.\n\n(C) 2017.")), menu_item(sair, and(message(Interface, destroy), message(Interface, free)))]),

	new(Imagem, label(nome, resource(imagem))),
	new(Titulo, text('SISTEMA PARA DIAGNOSTICO DE ANEMIA')),
	new(Botao, button('Iniciar Consulta', and(message(@prolog, diag)))),

	% FORMATANDO O TITULO DO PROGRAMA

	send(Titulo, font, font(times, bold, 20)),
	send_list(Interface, append, [Menu, Imagem, Titulo, Botao]),
	send(Interface, open, point(300,300)).
