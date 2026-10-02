% engine.pl - a tiny backward-chaining expert-system shell
% KBS presentation: Rule-Based Programming in PROLOG
% Run:  swipl zoo_kb.pl   (or swipl flu_kb.pl)   then   ?- go.
% Answer questions with  yes.  no.  or  why.  (full stop included)

:- op(900, xfx, ::).     % Id :: Rule
:- op(800, fx,  if).
:- op(700, xfx, then).
:- op(200, xfy, and).

:- dynamic known/2.  % known(Fact, yes/no)

% ---------- top level ----------
go :-
    retractall(known(_, _)),
    prompt(Old, ''),
    top_goal(Goal),
    (   prove(Goal, Proof, [])
    ->  format("~nConclusion: ~w~n", [Goal]),
        format("~nHOW did I conclude this?~n"),
        how(Proof, 0)
    ;   format("~nSorry, no rule matches.~n")
    ),
    prompt(_, Old).

% ---------- inference engine ----------
% prove(+Goal, -Proof, +Trace)
% Trace = ids of rules being tried (WHY)
prove(A and B, PA and PB, T) :- !,  % AND
    prove(A, PA, T),
    prove(B, PB, T).
prove(not(A), not(A), T) :- !,  % NOT as failure
    \+ prove(A, _, T).
prove(F, told(F), T) :-  % leaf fact: ask
    askable(F), !,
    ask(F, T).
prove(G, by(G, Id, P), T) :-  % derived: rule
    Id :: if C then G,
    prove(C, P, [Id|T]), !.

% ---------- asking the user ----------
ask(F, _) :-
    known(F, Ans), !,  % asked before?
    Ans == yes.  % reuse the answer
ask(F, T) :-
    format("Is it true: ~w ? (yes/no/why) ", [F]),
    read(Ans),
    (   Ans == why
    ->  why(T), ask(F, T)  % explain, ask again
    ;   assertz(known(F, Ans)),  % remember
        Ans == yes  % succeed only on yes
    ).

% ---------- explanation: WHY ----------
why([]).
why([Id|Ids]) :-
    Id :: if C then G,
    format("   trying rule ~w: IF ", [Id]),
    show(C),
    format(" THEN ~w~n", [G]),
    why(Ids).

show(A and B) :- !,
    show(A), write(' AND '), show(B).
show(X) :- write(X).

% ---------- explanation: HOW ----------
how(A and B, D) :- !,
    how(A, D), how(B, D).
how(told(F), D) :- !, tab(D),
    format("~w  <- you told me~n", [F]).
how(not(F), D) :- !, tab(D),
    format("not ~w  <- you said no~n", [F]).
how(by(G, Id, P), D) :- tab(D),
    format("~w  <- by rule ~w~n", [G, Id]),
    D1 is D + 4, how(P, D1).
