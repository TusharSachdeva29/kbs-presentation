% flu_kb.pl - toy rule base (teaching example, NOT medical advice)
:- ensure_loaded(engine).
top_goal(diagnosis(_)).
m1 :: if has(fever) and has(cough)
        then respiratory_infection.
m2 :: if respiratory_infection
        and has(body_ache) and has(chills)
        then diagnosis(flu).
m3 :: if has(sore_throat) and has(runny_nose)
        and not(has(fever))
        then diagnosis(common_cold).
m4 :: if has(fever) and has(rash)
        and has(joint_pain)
        then diagnosis(dengue_suspected).
askable(has(_)).
