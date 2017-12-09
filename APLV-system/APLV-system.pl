
true(yes).

caixaSimNao(Pergunta, Titulo) :-
	new(Interface, dialog(Titulo)),
	new(Resposta, menu(Pergunta)),
	send_list(Resposta, append, [yes, no]),
	new(Botao, button('Continuar', message(Interface, return, Resposta?selection))),
	send_list(Interface, append, [Resposta, Botao]),
	get(Interface, confirm, Resposta1),
	free(Interface),
	true(Resposta1).



% Time of symptoms
tim :-
	caixaSimNao('Does the patient have symptoms for 2 hours or more?','DIAGNOSIS').
timeSymAux :-
	tim -> xdelayedSym; xacuteOnsetSym.
% List of symptoms
delayedSym :- 
	caixaSimNao('The pacient present one or more of these symptoms?\n\n. Severe colic\n. Reflux-GORD\n. Food refusal or aversion\n. Perianal redness\n. Constipation\n. Abdominal discomfort\n. Blood/mucus in stools (in an otherwise well infant)\n. Pruritus, erythema\n. Significant atopic eczema', 'DIAGNOSIS').

acuteOnsetSym_1 :-
	caixaSimNao('The pacient present one or more of these symptoms?\n\n. Vomiting\n. Diarrhoea\n. Abdominal pain/colic\n. Acute pruritus, erythema, urticaria\n. Angioedema\n. Acute ‘flare up’ of atopic eczema', 'DIAGNOSIS').

acuteOnsetSym_2 :-
	caixaSimNao('The pacient present one or more these symptoms?\n\nRespiratory cough\nwheeze\nvoice change or breathing\ndifficulty\nCVS faint, floppy, pale, collapsed\nfrom low blood pressure\nOr recurrent GI symptoms', 'DIAGNOSIS').

falteringGrowth :-
	caixaSimNao('The pacient present signs of faltering growth?', 'DIAGNOSIS').

/*O tratamento e diferente dependendo do tempo que o paciente manifestou os sintomas, por isso dois 'breastfeds'*/

breastfedDelayed :-
	caixaSimNao('Is the baby exclusively breastfed?', 'DIAGNOSIS').
	
breastfedDelayedCheck :- 
	breastfedDelayed -> write('(exclude breastfeeding technique issues first)\n\nExclude cow’s milkcontaining foods frommaternal diet for 2-4weeks.\nPrescribe for mother:\n\nCalcium carbonate 1.25g\nCholecalciferol 10mcg\nChewable tablets - 2 daily\n\n
	Challenge with normal maternal diet after 2-4 weeks to confirm diagnosis.\nIf symptoms return continue 
	maternal cow’s milk free diet till review by dietitian 
	(if applicable).'); checkEhf.

breastfedOnset :-
	caixaSimNao('Is the baby breastfed?', 'DIAGNOSIS').

breastfedOnsetCheck :- 
	not(breastfedOnset) -> write('Exclude cow’s milk containing foods from maternal diet for 2-4 weeks.
	\nDo not home challenge after 2-4 weeks if an improvement.\nPrescribe for mother:\n\nCalcium carbonate 1.25g\ncholecalciferol 10mcg
	\nchewable tablets - 2 daily', 'DYAGNOSTIC'); checkEhf.


% Prescription - EHF

checkEhf :-
	caixaSimNao('Has the child ever had anaphylaxis or severe symtoms?','DIAGNOSIS'), aafPresc ; ehfPresc.
ehfAge :-
	caixaSimNao('Is the pacient over 6 life months?','DIAGNOSIS').
ehfPresc:-
	not(ehfAge) -> write('Althera(450g)\nAptamil Pepiti 1(400/800g)\n
	Nutramigen LGG 1 (400g)\nSimilac Alimentum (400g)') ; write('Aptamil Pepti 2 (400g/800g)\nNutramigen LGG 2 (400g)').

% Prescription - AAF

aafPresc :-
	write('Alfamino (400g)\nNeocate LCP(400g)\nNutramigen Puramino (400g)').

% Main
diag :- true; send(@display, inform, 'O paciente diagnosticado nao possui anemia.').

% Improvement checking 

improvementQuestion_1 :-
	caixaSimNao('Has there been improvement?','DIAGNOSIS').
	
improvementCheck_1 :-
	not(improvementQuestion_1) -> write('If infant on EHF and CMPA still suspected prescribe AAF.\nIt is the options:\n\nAlfamino (400g)\nNeocate LCP(400g)\nNutramigen Puramino (400g)'); write('Perform home challenge to confirm diagnosis, 2- 4 weeks after starting EHF. If symptoms return continue with EHF.').

improvementQuestion_2 :-
	caixaSimNao('Has there been improvement?', 'DIAGNOSIS').
	
improvementCheck_2 :-
	not(improvementQuestion_2) -> write('If infant on EHF and CMPA still suspected prescribe AAF.\nIt is the options:\n\nAlfamino (400g)\nNeocate LCP(400g)\nNutramigen Puramino (400g)'); write('If improvement do not home challenge and continue with EHF.').

start :- timeSymAux.

xdelayedSym :- not(delayedSym) -> write('So, the pacient is fine.'); xfalteringGrowth.

xfalteringGrowth :- not(falteringGrowth) -> breastfedDelayedCheck; checkEhf.

xacuteOnsetSym :- acuteOnsetSym_1 -> breastfedOnsetCheck; acuteOnsetSym_2.

% Graphic Interface

:-	pce_image_directory('./').
	resource(imagem, image, image('apvl.jpeg')).

:-  	new(Interface, dialog('DIAGNOSIS')),
	new(Menu, menu_bar),
	send(Menu, append, new(Consultar, popup(menu))),

	% OPCOES DO MENU

	send_list(Consultar, append, [menu_item('Authors', message(@display, inform,
	"Developed by:\n- Emerson Victor\n- Ewerton Felipe\n- José Claudino\n- José Tomáx\n\n(C) 2017.")), menu_item(sair, and(message(Interface, destroy), message(Interface, free)))]),

	new(Imagem, label(nome, resource(imagem))),
	new(Titulo, text('CMPA Diagnostic System')),
	new(Botao, button('  Start diagnosis  ', and(message(@prolog, diag)))),

	% FORMATANDO O TITULO DO PROGRAMA

	send(Titulo, font, font(times, bold, 20)),
	send_list(Interface, append, [Menu, Imagem, Titulo, Botao]),
	send(Interface, open, point(300,300)).