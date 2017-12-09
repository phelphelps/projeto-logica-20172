
true(yes).

checkButton(Question, Title) :-
	new(Interface, dialog(Title)),
	new(Answer, menu(Question)),
	send_list(Answer, append, [yes, no]),
	new(Button, button('  Continue  ', message(Interface, return, Answer?selection))),
	send_list(Interface, append, [Answer, Button]),
	get(Interface, confirm, Answer1),
	free(Interface),
	true(Answer1).



% Time of symptoms
timeSym :-
	
    new(D, dialog('Number of hours after ingestion')),
    send(D, append, new(label)),
    send(D, append, new(Hours, text_item(hours))),

    send(Hours, type, int),

    send(D, append,
         button(create, message(@prolog, acuteOnset,
                                Hours?selection
                                ))),

    send(D, default_button, create),
    send(D, open).


% Acute onset symptoms diagnostic
acuteOnset(Hours):- Hours > 1, xdelayedSym; xacuteOnsetSym, [Hours].
	

% List of symptoms
delayedSym :- 
	checkButton('The pacient present one or more of these symptoms?\n\n. Severe colic\n. Reflux-GORD\n. Food refusal or aversion\n. Perianal redness\n. Constipation\n. Abdominal discomfort\n. Blood/mucus in stools (in an otherwise well infant)\n. Pruritus, erythema\n. Significant atopic eczema', 'DIAGNOSIS').

acuteOnsetSym_1 :-
	checkButton('The pacient present one or more of these symptoms?\n\n. Vomiting\n. Diarrhoea\n. Abdominal pain/colic\n. Acute pruritus, erythema, urticaria\n. Angioedema\n. Acute ‘flare up’ of atopic eczema', 'DIAGNOSIS').

acuteOnsetSym_2 :-
	checkButton('The pacient present one or more these symptoms?\n\nRespiratory cough\nwheeze\nvoice change or breathing\ndifficulty\nCVS faint, floppy, pale, collapsed\nfrom low blood pressure\nOr recurrent GI symptoms', 'DIAGNOSIS').

falteringGrowth :-
	checkButton('The pacient present signs of faltering growth?', 'DIAGNOSIS').

/*O tratamento e diferente dependendo do tempo que o paciente manifestou os sintomas, por isso dois 'breastfeds'*/

breastfedDelayed :-
	checkButton('Is the baby exclusively breastfed?', 'DIAGNOSIS').
	
breastfedDelayedCheck :- 
	breastfedDelayed -> write('(exclude breastfeeding technique issues first)\n\nExclude cows milk containing foods frommaternal diet for 2-4weeks.\nPrescribe for mother:\n\nCalcium carbonate 1.25g\nCholecalciferol 10mcg\nChewable tablets - 2 daily\n\nChallenge with normal maternal diet after 2-4 weeks to confirm diagnosis.\nIf symptoms return continue  maternal cows milk free diet till review by dietitian (if applicable).'); checkEhf.

breastfedOnset :-
	checkButton('Is the baby breastfed?', 'DIAGNOSIS').

breastfedOnsetCheck :- 
	not(breastfedOnset) -> write('Exclude cow’s milk containing foods from maternal diet for 2-4 weeks.
	\nDo not home challenge after 2-4 weeks if an improvement.\nPrescribe for mother:\n\nCalcium carbonate 1.25g\ncholecalciferol 10mcg
	\nchewable tablets - 2 daily', 'DYAGNOSTIC'); checkEhf.


% Prescription - EHF

checkEhf :-
	checkButton('Has the child ever had anaphylaxis or severe symtoms?','DIAGNOSIS'), aafPresc ; ehfPresc.
ehfAge :-
	checkButton('Is the pacient over 6 life months?','DIAGNOSIS').
ehfPresc:-
	not(ehfAge) -> write('Althera(450g)\nAptamil Pepiti 1(400/800g)\nNutramigen LGG 1 (400g)\nSimilac Alimentum (400g)') ; write('Aptamil Pepti 2 (400g/800g)\nNutramigen LGG 2 (400g)').

% Prescription - AAF

aafPresc :-
	write('Alfamino (400g)\nNeocate LCP(400g)\nNutramigen Puramino (400g)').



% Improvement checking 

improvementButton :-
	falteringGrowth -> improvementCheck_2; improvementCheck_1.
improvementQuestion_1 :-
	checkButton('Has there been improvement?','DIAGNOSIS').
	
improvementCheck_1 :-
	not(improvementQuestion_1) -> (write('If infant on EHF and CMPA still suspected prescribe AAF.\nIt is the options:\n\n'),aafPresc); write('Perform home challenge to confirm diagnosis, 2- 4 weeks after starting EHF. If symptoms return continue with EHF.').

improvementQuestion_2 :-
	checkButton('Has there been improvement?', 'DIAGNOSIS').
	
improvementCheck_2 :-
	not(improvementQuestion_2) -> (write('If infant on EHF and CMPA still suspected prescribe AAF.\nIt is the options:\n\n'),aafPresc); write('If improvement do not home challenge and continue with EHF.').

% Main

start :-
	timeSym.

xdelayedSym :-
	not(delayedSym) -> write('So, the pacient is fine.'); xfalteringGrowth.

xfalteringGrowth :-
	not(falteringGrowth) -> breastfedDelayedCheck; breastfedDelayedCheck.

xacuteOnsetSym :-
	acuteOnsetSym_1 -> breastfedOnsetCheck; xacuteOnsetSym_2.
xacuteOnsetSym_2 :-
	acuteOnsetSym_2 -> (write('Urgently treat symptoms.Immediately refer to specialist.\nPrescribe AAF.\nIt is the options:\n\n'),aafPresc); write('So, the pacient is fine').

% Graphic Interface

:-	pce_image_directory('./').
	resource(imagem, image, image('apvl.jpeg')).

:-  new(Interface, dialog('DIAGNOSIS')),
	new(Menu, menu_bar),
	send(Menu, append, new(Consultar, popup(menu))),

	% Menu options

	send_list(Consultar, append, [menu_item('Authors', message(@display, inform,
	"Developed by:\n- Emerson Victor\n- Ewerton Felipe\n- José Claudino\n- José Tomáx\n\n(C) 2017.")), menu_item(sair, and(message(Interface, destroy), message(Interface, free)))]),

	new(Imagem, label(nome, resource(imagem))),
	new(Title, text('CMPA Diagnostic System')),
	new(Button, button('  Start diagnosis  ', and(message(@prolog, start)))),
	
	send(Interface, append, button(  postDiagnosis, message(@prolog, improvementButton))),

    send(Interface,default_button,  postDiagnosis),


	% Formatting program title

	send(Title, font, font(times, bold, 20)),
	send_list(Interface, append, [Menu, Imagem, Title, Button]),
	send(Interface, open, point(300,300)).