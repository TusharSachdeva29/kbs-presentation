# Presenter Guide: Rule-Based Programming in PROLOG

KBS (Knowledge Based Systems), Unit II · Group presentation

This guide goes through all 32 slides. For each one it gives:

- **Show:** what is on the slide
- **Say:** a short script you can speak from
- **Cross-questions:** questions the professor may ask, with answers

At the end there are:

- a live demo run-sheet
- a Prolog "viva" section with deeper technical questions
- a glossary
- a list of facts worth double-checking in the books

> **Files in this folder**
> - `Rule-Based Programming in PROLOG.pptx`: the slides, with speaker notes
> - `engine.pl`: the expert-system shell (inference engine, asking, WHY and HOW)
> - `zoo_kb.pl`: the animal identification knowledge base (15 rules)
> - `flu_kb.pl`: the fever/flu knowledge base (4 rules)
>
> All demo output on slides 21–24 was **checked by actually running the code** in SWI-Prolog 10.0.2.

---

## 0. Before the day

**Fill in slide 1.** Add the group number, member names and roll numbers.

**Suggested speaker split** (about 12–15 minutes in total; merge parts if your group is smaller):

| Speaker | Slides | Part |
|---|---|---|
| 1 | 1–4 | Title, outline, motivation, history |
| 2 | 5–12 | Core concepts |
| 3 | 13–20 | Building the system |
| 4 | 21–24 | Live demo |
| 5 | 25–27 | Case studies |
| 6 | 28–32 | Limitations, takeaways, references |

**Rehearse the demo twice** using the run-sheet in section 8. Keep slides 21–24 ready as a backup in case the laptop or projector fails.

**The one-sentence summary of the whole talk:**
An IF-THEN rule is a Horn clause, so Prolog can run rules directly by backward chaining. Adding "ask the user" and "explain WHY/HOW" turns that into a small expert system.

---

## 1. Title and outline

### Slide 1: Title

**Show:** Topic, course (KBS, Unit II), group number, members, roll numbers.

**Say:**
"Good morning. We are Group __. Our topic is Rule-Based Programming in Prolog. We will show:
- how IF-THEN rules are written as Prolog clauses
- how a program asks the user for facts it does not know
- how we built a small expert system that explains its answers, with a live demo"

### Slide 2: Outline

**Show:** Six parts: motivation, core concepts, building, demo, case studies, limits and takeaways.

**Say:** Read the six headings in one breath. Don't explain them yet.

---

## 2. Motivation and background

### Slide 3: Why rule-based programming?

**Show:** Four cards:
- Experts think in rules
- Knowledge is kept separate from code
- Every answer can be explained
- Prolog is already a rule engine

**Say:**
- Experts explain what they know as rules of thumb, for example "IF fever AND body ache THEN suspect flu".
- A rule-based system keeps that knowledge in a knowledge base, separate from the inference engine. So we change the rules, not the program.
- Every conclusion comes from a chain of rules, so the system can explain itself.
- Prolog fits perfectly: a Prolog clause IS an IF-THEN rule, and running it IS backward chaining.

**Cross-questions:**
- *Why not just use if-else statements in C or Java?*
  With if-else, the knowledge is mixed into the control flow. Adding one rule can mean restructuring the code, and the program cannot explain itself. In a rule base, each rule is independent data. The generic engine decides the order, and the rule chain doubles as an explanation.
- *What is a knowledge-based system?*
  A system whose behaviour comes from an explicit, separate body of knowledge (the knowledge base) plus a general reasoning mechanism (the inference engine). An expert system is a knowledge-based system that captures a human expert's knowledge in a narrow domain.

### Slide 4: A short history

**Show:** A timeline:
- 1965 DENDRAL
- 1972 Prolog
- 1976 MYCIN
- 1980 R1/XCON
- 1982 Fifth Generation project
- 2011 IBM Watson

**Say:**
- DENDRAL, at Stanford, was the first expert system; it inferred chemical structures.
- Prolog was created in 1972 by Alain Colmerauer and Philippe Roussel in Marseille. It builds on Robert Kowalski's idea that Horn clauses can be read as procedures.
- MYCIN brought rule-based medical diagnosis with HOW and WHY explanations.
- XCON saved DEC millions of dollars a year.
- Japan's Fifth Generation project bet on logic programming.
- IBM Watson used Prolog for part of its question analysis.

**Cross-questions:**
- *What does "Prolog" stand for?* PROgrammation en LOGique (French for "programming in logic").
- *Is Prolog standardised?* Yes, ISO/IEC 13211-1 (1995). We used SWI-Prolog, a free and widely used implementation.
- *What happened to the Fifth Generation project?* It ran from 1982 to 1992 and produced parallel logic-programming machines and languages. It did not reach its commercial goals, but it pushed logic-programming research forward.
- *What did Kowalski contribute?* The "procedural interpretation" of Horn clauses: a clause `A :- B, C` can be read both as logic ("A is true if B and C are") and as a procedure ("to solve A, solve B then C"). His 1979 paper was titled "Algorithm = Logic + Control".

---

## 3. Core concepts (slides 5–12)

### Slide 5: Anatomy of a rule-based expert system

**Show:** A diagram with: user, user interface, inference engine, knowledge base, working memory, explanation facility, domain expert. Each box names the Prolog predicate that plays that role.

**Say:**
- **Knowledge base:** the rules, supplied by a domain expert through a knowledge engineer.
- **Working memory:** the facts known in this consultation.
- **Inference engine:** decides which rules to apply.
- **User interface:** asks questions.
- **Explanation facility:** answers WHY and HOW.
- In our system these are `Id :: if … then …` facts, `known/2`, `prove/3`, `ask/2`, and `why/1` with `how/2`.

**Cross-questions:**
- *What is the difference between the knowledge base and working memory?*
  The knowledge base holds long-term, general knowledge: the rules, the same for every user. Working memory holds short-term, case-specific facts: this user's answers. We clear it with `retractall` at the start of each consultation.
- *What is a knowledge engineer?* The person who draws knowledge out of the domain expert and encodes it as rules.
- *What is an expert-system shell?* An expert system with the knowledge base removed: the engine, user interface and explanation parts, ready to take any rule base. `engine.pl` is our shell. Demo 3 proves this by swapping in a different knowledge base.

### Slide 6: IF-THEN rules

**Show:**
- A definition of a rule
- The IF / AND / THEN template
- Antecedent and consequent
- A table of rule types: relation, recommendation, directive, strategy, heuristic

**Say:**
- A rule links premises to a conclusion.
- The IF part is the antecedent; the THEN part is the consequent.
- A rule "fires" when all its conditions hold. Its conclusion becomes a new fact that other rules can use; this is chaining.
- Durkin and Negnevitsky classify rules into the five types in the table.

**Cross-questions:**
- *What is a production rule?* Another name for an IF-THEN rule (condition, then action or conclusion). The name comes from production systems such as OPS5.
- *What is a heuristic rule?* A rule of thumb that is usually, but not always, correct. It comes from expert experience rather than theory.
- *Can a rule have OR?* Yes. In Prolog we usually split it into two rules with the same conclusion (see slide 8).

### Slide 7: Prolog in one slide

**Show:** A fact, a rule, a query (Bratko's family example), and a reading guide:
- `:-` means IF
- `,` means AND
- `;` means OR
- `\+` means NOT
- capitalised names are variables, lower-case names are constants

**Say:** "Prolog has facts, rules and queries. `grandparent(tom, Who)` is solved by chaining two `parent` facts: tom → bob → ann."

This output is verified: `Who = ann.`

**Cross-questions:**
- *What is unification?*
  Making two terms identical by finding values for their variables. For example, `grandparent(tom, Who)` unifies with the head `grandparent(X, Z)` with X = tom and Z = Who. Prolog finds the most general such substitution, called the *most general unifier* (mgu).
- *What is the difference between a fact and a rule?* A fact is a clause with no body, so it is unconditionally true. A rule has a body, so it is true only if the body is true.
- *Is `Who` a variable?* Yes. Anything starting with a capital letter or `_` is a variable.

### Slide 8: Representing IF-THEN rules as Prolog clauses (key slide)

**Show:**
- The formula: IF p1 ∧ … ∧ pn THEN q ≡ q ← p1 ∧ … ∧ pn ≡ ¬p1 ∨ … ∨ ¬pn ∨ q (a Horn clause)
- A table of translations:
  - fact → `has(hair).`
  - AND → comma
  - OR → two clauses
  - NOT → `\+`
  - rules with variables → variables in head and body

**Say:**
- This is the heart of the topic. An IF-THEN rule is an implication.
- Written as a disjunction, it has exactly one positive literal, q. That makes it a Horn clause, which is exactly the shape of a Prolog clause.
- So the translation is mechanical: the conclusion becomes the head, the conditions become the body.

**Cross-questions:**
- *What exactly is a Horn clause?* A disjunction of literals with **at most one** positive (un-negated) literal. There are three kinds:
  - a *definite clause* has exactly one positive literal (a Prolog rule or fact)
  - a *fact* is a definite clause with no negative literals
  - a *goal* or query has no positive literal
- *Why does Prolog restrict itself to Horn clauses?* Resolution on Horn clauses (SLD resolution) is efficient and needs only one goal list. Full first-order logic would need general resolution, which is much more expensive.
- *Why is `p → q` the same as `¬p ∨ q`?* It is a logical equivalence: an implication is false only when p is true and q is false. That is exactly when `¬p ∨ q` is false.
- *How do you write "IF p OR q THEN r"?* Either as two clauses, `r :- p.` and `r :- q.`, or as one clause, `r :- p ; q.` Two clauses is the usual style.
- *Is `\+` the same as logical NOT?* No, it is **negation as failure**: `\+ q` succeeds if q *cannot be proven*. See slide 29 and section 9.

### Slide 9: Animal rules written directly in Prolog

**Show:** Three native rules (mammal, carnivore, cheetah), four facts, and queries.

This output is verified:
- `?- animal(X).` gives `X = cheetah.`
- `?- carnivore.` gives `true.`
- `?- animal(tiger).` gives `false.`

**Say:**
- Rules as plain Prolog clauses already work.
- But there are two gaps. The facts had to be typed in beforehand, and the answer comes with no explanation. The rest of the talk fixes both.

**Cross-questions:**
- *Why does `animal(tiger)` give false and not an error?* Prolog uses the **closed-world assumption**: what cannot be proven is treated as false. There is no tiger rule, so it fails.
- *Why do you get `true.` and not `true ;`?* No other clause could match, so Prolog left no choice point and prints a final `true.`

### Slide 10: How Prolog runs rules: backward chaining

**Show:**
- The five-step SLD algorithm
- A proof tree for `animal(cheetah)`: dark boxes were proved by a rule, outlined boxes matched a fact

**Say:**
- Prolog starts from the goal and finds a clause whose head unifies with it.
- It replaces the goal by that clause's body, and repeats.
- When the goal list is empty, it has succeeded. If a goal cannot be matched, it backtracks.
- The search is depth-first: goals left to right, clauses top to bottom.

**Cross-questions:**
- *What does SLD stand for?* **S**elective **L**inear resolution for **D**efinite clauses:
  - *selective*: a rule picks which goal to work on (Prolog always picks the leftmost)
  - *linear*: each step uses the latest goal list
  - *definite*: only Horn clauses with exactly one head
- *What is backtracking?* When a goal fails, Prolog returns to the most recent choice point (a goal that had other matching clauses) and tries the next alternative.
- *Is Prolog's search complete?* No. Depth-first search can go down an infinite branch and never return (slide 29), even when an answer exists. A breadth-first search would be complete but uses much more memory. Prolog chooses depth-first for efficiency.
- *What is a proof tree?* A tree whose root is the goal and whose children are the sub-goals from the clause used. Leaves are facts. Our HOW explanation prints exactly this tree.

### Slide 11: Backward vs forward chaining

**Show:** A comparison table: start point, direction, which questions are asked, best uses, classic systems, how each is done in Prolog.

**Say:**
- Backward chaining is goal-driven. Forward chaining is data-driven.
- Diagnosis and identification suit backward chaining, because it asks only what the current hypothesis needs.
- Configuration and monitoring suit forward chaining.
- Prolog gives us backward chaining for free.

**Cross-questions:**
- *Give an example of each.* MYCIN and Prolog programs are backward chaining. XCON (written in OPS5) and CLIPS are forward chaining.
- *How would you do forward chaining in Prolog?* Loop:
  1. Find a rule whose conditions are all known facts and whose conclusion is not yet known.
  2. `assert` the conclusion.
  3. Repeat until no rule can fire.
- *What is conflict resolution?* In forward chaining, several rules may match at once, and the engine must choose which to fire. Common strategies: rule order, most specific rule, most recent data (used in OPS5). In Prolog's backward chaining, clause order does this job.
- *What is the Rete algorithm?* An efficient pattern-matching algorithm for forward chaining (Charles Forgy, around 1979). It avoids re-testing every rule on every cycle. CLIPS and many production-rule engines use it.
- *Can one system use both?* Yes, this is called mixed or hybrid chaining. Many commercial shells support both.

### Slide 12: Asking the user for missing facts

**Show:** Five bullets and a flowchart:
1. Is the goal askable?
2. Has it already been answered?
3. Ask the user (yes / no / why).
4. Store the answer.

**Say:**
- We mark the leaf conditions, the ones no rule concludes, as `askable`.
- When backward chaining reaches one, we check memory first. If it is new, we ask.
- If the user types `why`, we explain and then ask again.
- The answer is stored so it is never asked twice.

**Cross-questions:**
- *Why not ask every question at the start?* That would ask irrelevant questions. Asking lazily, only when a rule needs the fact, asks far fewer. Demo 1 needed only 4 of the 13 possible leaf questions.
- *Why store "no" answers too?* Otherwise, when Prolog backtracks and tries another rule that needs the same fact, it would ask again.
- *What is "askable"?* A declaration that a condition is a primitive fact the user can supply, rather than something to derive from rules.

---

## 4. Building the system (slides 13–20)

### Slide 13: Four pieces make an expert system

**Say:** "Knowledge base plus inference engine plus asking plus explaining gives an expert system. Prolog does the hard work, unification and backtracking, so each piece is small. The whole shell is about 60 lines."

### Slide 14: Design step: rules as data

**Show:** The `op/3` declarations, one rule stored as data, and the internal term it becomes.

**Say:**
- A native clause cannot tell us *which* rule fired.
- So we store each rule as a named fact: `r5 :: if mammal and eats(meat) then carnivore.`
- `op/3` makes `::`, `if`, `then` and `and` into operators, so the rule is legal Prolog but reads like English. This is the same approach as Bratko's shell.

**Cross-questions:**
- *What does `op(700, xfx, then)` mean?*
  `op(Priority, Type, Name)`. The priority runs from 1 to 1200, and a **lower number binds tighter**. The type gives the position and associativity:
  - `xfx`: an infix operator that is not associative, so `a then b then c` is a syntax error
  - `xfy`: infix and right-associative, so `a and b and c` = `and(a, and(b, c))`
  - `fx`: a prefix operator
- *Why these particular priorities?*
  They must nest correctly. `and` (200) binds tightest, then `then` (700), then `if` (800), then `::` (900). So `r5 :: if A and B then C` is read as `::(r5, if(then(and(A, B), C)))`. All are below 999, so a whole rule can still be an argument or a body goal.
- *What is `::`? Is it built in?* No. We declare it ourselves as an operator. `r1 :: if ... then ...` is simply a fact of the predicate `::/2`.
- *Why not call the facts `rule/2`?* Recent SWI-Prolog versions have a built-in predicate `rule/2`, which could clash. `::` avoids that, and it is also Bratko's notation.

### Slide 15: The knowledge base at a glance

**Show:** An inference network: mammal/bird → carnivore/ungulate → seven animals, labelled with rules r1–r15.

**Say:**
- This is Winston's classic ZOOKEEPER rule base, which Bratko also uses.
- Intermediate conclusions such as mammal and carnivore are shared by several rules, which makes this a chain of reasoning rather than a lookup table.

**Cross-questions:**
- *What is an ungulate?* A hoofed mammal, such as a giraffe or a zebra.
- *What is an inference network?* A graph showing how evidence leads through intermediate conclusions to final conclusions.
- *Why are intermediate conclusions useful?* They avoid repeating conditions (each animal rule says "carnivore" instead of listing hair, meat, teeth and so on). They also make the rule base easier to maintain.

### Slides 16 and 17: The knowledge base code

**Show:** `zoo_kb.pl`:
- `ensure_loaded(engine)`
- `top_goal(animal(_))`
- rules r1–r15
- 8 `askable` declarations

**Say:**
- OR is two rules: r1 and r2 both conclude mammal.
- AND is inside one rule: r6 has four conditions.
- `askable` lists the leaf facts, the only ones we can ask the user.
- `not(flies)` uses negation as failure.

**Cross-questions:**
- *What does `ensure_loaded(engine)` do?* It loads `engine.pl` (the operators and the engine) once, before the rest of the file is read. The operators must exist before Prolog can parse `r1 :: if ...`.
- *What is `top_goal(animal(_))`?* It tells the generic engine which goal to prove. The `_` is an anonymous variable, filled in with the animal found. The flu knowledge base uses `top_goal(diagnosis(_))`.
- *How would you add a new animal, say a lion?*
  Add one rule: `r16 :: if carnivore and has(tawny_colour) and has(mane) then animal(lion).` Nothing else changes, because `has(_)` is already askable. That is the benefit of separating knowledge from the engine.
- *What happens if two animals' rules both match?* The first one in the file wins, because the engine takes the first proof. Rule order is effectively our conflict-resolution strategy.

### Slide 18: The inference engine, prove/3

**Show:** Four clauses of `prove/3` and the top-level predicate `go/0`.

**Say:** Clause by clause:
1. AND: prove both parts.
2. NOT: negation as failure.
3. Askable leaf fact: ask the user.
4. Otherwise: find a rule whose THEN part matches, and prove its IF part, pushing the rule id onto the trace.

"The Proof argument builds the proof tree for HOW. The Trace argument remembers which rules are waiting, for WHY."

**Cross-questions:**
- *What is a meta-interpreter?*
  A Prolog program that runs other programs or rules held as data. `prove/3` is a meta-interpreter for our rule language. Writing one takes only a few lines because Prolog programs can inspect terms.
- *What are the three arguments of `prove/3`?*
  - **Goal**: the input, what to prove
  - **Proof**: the output, the proof tree built as it goes
  - **Trace**: the input, the list of rule ids currently being tried
- *Why the cut (`!`) at the end of clause 4?*
  It commits to the first proof of a sub-goal. Without it, in Demo 2, a later failure would make Prolog backtrack into `mammal`, try rule r2, and ask about milk again. The cost: we only ever find the first proof, which is fine because we want one answer.
- *Why cuts in clauses 1–3?* So that an `and`, `not` or askable goal is never also tried against clause 4 (the rules).
- *What does `retractall(known(_, _))` do?* It deletes all remembered answers, so each `go` starts a fresh consultation.
- *What does `prompt(Old, '')` do?* SWI-Prolog normally shows `|:` when `read/1` waits for input. We hide it for a cleaner dialogue, then restore it at the end.
- *What does `->` mean in `go`?* If-then-else: `( Cond -> Then ; Else )`. If the goal can be proved, print the conclusion and HOW; otherwise print "Sorry, no rule matches."

### Slide 19: Asking the user, ask/2

**Show:** `ask/2`: the memory lookup, the question, `read/1`, the `why` loop, and `assertz`.

**Say:**
- Check memory first; if the fact was already answered, reuse the answer.
- Otherwise print the question and read the reply.
- If the reply is `why`, explain and ask again.
- Otherwise store it and succeed only on `yes`. A `no` simply fails, and backtracking tries the next rule.

**Cross-questions:**
- *Why is `known/2` declared `dynamic`?* We add clauses to it while the program runs. The `dynamic` declaration allows that, and it also makes calling `known/2` safe before any clauses exist.
- *`assert` vs `asserta` vs `assertz`?* `asserta` adds at the front; `assertz` (and plain `assert`) adds at the end. The order doesn't matter here.
- *Why must the user type a full stop?* `read/1` reads a Prolog **term**, and a term ends with `.`
- *What if the user types `y.` instead of `yes.`?* It is stored as `y`, which is not `yes`, so it is treated as "no". An improvement would be to check the input and ask again (see section 9).
- *Why `==` and not `=`?* `==` tests whether two terms are already identical, without binding anything. That is safer for comparisons.

### Slide 20: The explanation facility, WHY and HOW

**Show:**
- `why/1`: prints the trace of waiting rules, innermost first
- `show/1`: prints conditions joined by AND
- `how/2`: prints the proof tree, indented

**Say:**
- WHY is asked during a question: "Why do you need this?" We print the rules waiting for the fact.
- HOW is asked after a conclusion: "How did you conclude that?" We walk the proof tree.
- Durkin stresses that explanations build trust and help debug the rules.

**Cross-questions:**
- *What is the difference between WHY and HOW?*
  - WHY is *forward-looking*, during questioning: it shows what goal the question serves.
  - HOW is *backward-looking*, after concluding: it shows how the answer was derived.
- *What is a "why not" explanation?* It explains why an alternative conclusion was rejected. For example, "not an ostrich, because long neck = no". Our shell doesn't do this, but it could, by recording the condition that failed.
- *Where did HOW and WHY come from historically?* MYCIN, and the TEIRESIAS explanation work in the MYCIN project.

---

## 5. Working demo (slides 21–24)

All three runs were executed on SWI-Prolog 10.0.2 and match the slides line for line.

### Slide 21: Demo 1, a cheetah, with WHY

**Answers to type:** `why.` `yes.` `yes.` `yes.` `yes.`

**Say:**
- The first hypothesis tried is cheetah (r9), which needs carnivore (r5), which needs mammal (r1), which needs hair. So the first question is about hair.
- Typing `why.` shows the rule chain r1 → r5 → r9.
- It needed only four questions, because the first hypothesis succeeded.

### Slide 22: Demo 1, the HOW explanation

**Say:**
- Indentation shows depth in the proof tree.
- "by rule rN" means the conclusion came from a rule; "you told me" means the user supplied it.
- This is the same tree as on slide 10.

### Slide 23: Demo 2, a penguin (backtracking)

**Answers to type:** `no.` `no.` `yes.` `no.` `no.` `yes.` `yes.`

**Say:**
- Hair: no, and milk: no. So mammal is impossible, and cheetah, tiger, giraffe and zebra all fail **without new questions**, because the answers are remembered.
- Ostrich is tried: feathers yes, flies no, long neck no, so it fails.
- Penguin reuses the feathers and flies answers and asks only about swimming and colour. That makes 7 questions.

### Slide 24: Demo 3, fever/flu (same engine, new knowledge base)

**Answers to type:** `yes.` four times.

**Say:**
- We changed only the knowledge base file.
- m2 (flu) uses the intermediate conclusion from m1 (respiratory infection).
- This is a teaching example, not medical advice.

**Demo cross-questions:**
- *Why is the first question about hair, not feathers?* Rules are tried in file order. The first animal rule is r9 (cheetah), whose first condition leads down to `has(hair)`.
- *How many questions at most?* 13 leaf facts exist, but each consultation asks only those the hypotheses need, and never repeats one.
- *What if the animal is a lion?* The system asks 7 questions and then says "Sorry, no rule matches." (tested). This shows brittleness (slide 28). The fix is to add a lion rule.
- *Could the system handle "I don't know"?* Not yet; it would be treated as "no". You could add `unknown` answers or certainty factors.
- *Why doesn't it print "|:" before answers?* We hid SWI-Prolog's read prompt with `prompt/2` in `go/0`.
- *Is the order of questions optimal?* No. It follows rule order, not information gain. A smarter system would ask the question that splits the remaining hypotheses best (like a decision tree). This is listed as a limitation.

---

## 6. Case studies (slides 25–27)

### Slide 25: MYCIN

**Key points:**
- Stanford, 1970s (Shortliffe, Buchanan). It identified the bacteria behind blood infections and meningitis, and recommended antibiotics.
- About 450 rules (the figure Russell & Norvig give), used by backward chaining. It asked the doctor for lab facts and answered WHY and HOW.
- It used **certainty factors**.
- In a blinded evaluation (Yu et al., JAMA 1979), its recommendations were rated at least as good as those of Stanford infectious-disease experts.
- It was never used routinely, because of legal responsibility, ethics and slow typed consultations.

**Lesson:** Accuracy and explanation are not enough. A system must fit the workflow and settle who is responsible.

**Cross-questions:**
- *What is a certainty factor (CF)?* A number from −1 (definitely false) to +1 (definitely true) attached to a rule or fact. The rule on the slide concludes "bacteroides" with CF 0.6.
- *How are CFs combined?*
  - For a conjunction of premises, take the minimum CF.
  - Applying a rule: CF(conclusion) = CF(rule) × CF(premises).
  - Two rules supporting the same conclusion (both positive): CF = CF1 + CF2 × (1 − CF1).
- *Is MYCIN's approach probabilistic?* Not formally. CFs are an informal approximation. Later work moved to Bayesian networks.
- *What was EMYCIN?* "Empty MYCIN": MYCIN's shell with the medical knowledge removed, reused for other domains. This is exactly what our Demo 3 illustrates.

### Slide 26: The British Nationality Act in Prolog

**Key points:**
- In 1986, Sergot, Kowalski and colleagues at Imperial College translated the British Nationality Act 1981 into Prolog.
- Queries run backward chaining over the law and ask the user for missing facts.
- The work exposed ambiguities, for example the clause on abandoned new-born infants, which depends on default reasoning ("unless the contrary is shown").

**Lesson:** Executable rules are testable, and they reveal vagueness in the source text.

**Cross-questions:**
- *What is default reasoning?* Assuming something unless there is evidence against it. Prolog's negation as failure is a natural way to model "unless the contrary is shown".
- *Is the code on the slide the real program?* It is a **simplified** version of section 1(1); the real program also handled dates and many more sections.
- *Where else is legal or rule logic used?* Tax and benefit eligibility rules, compliance checking, and "rules as code" projects in government.

### Slide 27: IBM Watson and NASA Clarissa

**Key points:**
- **Watson (2011):** Prolog rules matched patterns over parsed Jeopardy! questions, for example finding the question's focus and the type of answer wanted (Lally & Fodor, 2011).
- **Clarissa (ISS, 2005):** a voice-operated procedure browser whose language rules were written in Prolog with the Regulus toolkit.

**Lessons:**
- Rules and statistical machine learning complement each other.
- Declarative rules are compact and inspectable, which matters where software must be trusted.

**Cross-questions:**
- *Was Watson a Prolog program?* No. Watson was a large system (the DeepQA architecture) combining many techniques. Prolog was used for specific pattern-matching rules in question analysis.
- *Why choose Prolog for pattern rules?* Unification and backtracking make "find this shape in a parse tree" rules short to write and easy to maintain.

---

## 7. Limitations and summary (slides 28–32)

### Slide 28: Limitations of rule-based expert systems

**Show:** Six limitations:
- knowledge acquisition bottleneck
- brittleness
- uncertainty
- maintenance at scale (XCON)
- rigid dialogue
- shallow explanations (Clancey)

**Cross-questions:**
- *What is the knowledge acquisition bottleneck?* Getting knowledge out of experts and into rules is slow and error-prone. Experts often can't state what they do intuitively. The term is commonly attributed to Edward Feigenbaum.
- *What does "brittle" mean?* The system works inside its narrow domain but fails badly just outside it (our lion example), with no common sense to fall back on.
- *How do modern systems address these?*
  - Machine learning learns from data instead of hand-written rules, though it is less explainable.
  - Probabilistic models (Bayesian networks) handle uncertainty.
  - Hybrid systems combine rules with learning.
- *What was Clancey's criticism?* MYCIN's explanations replayed rules but couldn't justify them. It had no deep knowledge of *why* a rule is medically valid, so it couldn't teach students well.

### Slide 29: Prolog-specific challenges

**Show:**
- Infinite loops on left recursion
- Order matters
- Closed world
- Cut
- Fragile input
- A code demo of a left-recursive `ancestor` and its fix

**Verified behaviour:**
- **Left-recursive version:** with the default 1 GB stack, SWI-Prolog appears to **hang** for minutes. Running `swipl --stack-limit=16m` stops it in about 2 seconds with `ERROR: Stack limit (16.0Mb) exceeded` and "Probable infinite recursion". **Don't run the 1 GB version live**; use the 16 MB flag if you demo it.
- **Fixed version:** answers `true` and leaves a choice point, so SWI-Prolog waits. Press Enter to get `true .`

**Cross-questions:**
- *Why does left recursion loop?* `ancestor(X, Z)` first calls `ancestor(X, Y)`, the same goal, before consuming any fact. So depth-first search goes down forever.
- *Doesn't the fix change the logic?* No. Both versions have the same logical meaning (declarative reading); only the procedural behaviour differs. That is exactly why "order matters".
- *What is tabling?* A way to remember goals already being solved. SWI-Prolog supports it with `:- table ancestor/2.`, which makes even the left-recursive version terminate.
- *Green cut vs red cut?* A green cut only removes useless search and doesn't change the answers. A red cut changes which answers are found. Ours in `prove/3` is effectively red (we keep only the first proof), but that is intended.
- *What is the closed-world assumption?* Anything not provable is assumed false. It is fine for databases and our knowledge base, but wrong where knowledge is incomplete (the open world).
- *What is floundering?* Using `\+` on a goal with unbound variables can give wrong answers. For example, `\+ X = a` fails even though some X is not `a`. The rule is to call `\+` only on ground (fully instantiated) goals.

### Slide 30: Key takeaways

Recite the six points, then thank the audience and invite questions.

### Slides 31 and 32: References

15 sources:
- the prescribed books: **Bratko** and **Durkin**
- Russell & Norvig, Negnevitsky, Winston, the MYCIN book, Giarratano & Riley
- the original papers: Kowalski, Yu et al., McDermott, Clancey, Sergot et al., Rayner et al., Lally & Fodor
- the SWI-Prolog manual

---

## 8. Live demo run-sheet

1. Open PowerShell and type:
   ```
   cd "C:\Users\Asus\OneDrive\Desktop\kbs presentation"
   swipl zoo_kb.pl
   ```
   If `swipl` is not found, open a **new** terminal (the installer updated your PATH), or use the full path:
   ```
   & "C:\Program Files\swipl\bin\swipl.exe" zoo_kb.pl
   ```
2. At the `?-` prompt, type `go.` and press Enter.
3. Answer with a full stop every time: `yes.` / `no.` / `why.`

| Run | Knowledge base | Answers in order | Expected result |
|---|---|---|---|
| Cheetah + WHY | zoo_kb.pl | why. yes. yes. yes. yes. | `Conclusion: animal(cheetah)` + HOW tree |
| Penguin | zoo_kb.pl | no. no. yes. no. no. yes. yes. | `Conclusion: animal(penguin)` |
| Lion (failure case) | zoo_kb.pl | yes. yes. no. no. no. no. no. | `Sorry, no rule matches.` |
| Flu | flu_kb.pl | yes. yes. yes. yes. | `Conclusion: diagnosis(flu)` |

- **Run again:** type `go.` again (memory is reset automatically).
- **Switch to the flu knowledge base:** type `halt.`, then `swipl flu_kb.pl`.
- **If it seems stuck:** you probably forgot the full stop. Type `.` and press Enter.
- **Emergency:** show slides 21–24; they are the real recorded output.

---

## 9. Deeper viva questions (quick answers)

| Question | Answer |
|---|---|
| Declarative vs procedural meaning? | Declarative: *what* is true (the logic). Procedural: *how* Prolog searches (order, depth-first). Good Prolog makes both agree. |
| What is a choice point? | A saved state where other clauses could still be tried. Backtracking returns to it. |
| What does `_` mean? | An anonymous variable: "any value, don't care". |
| Why no `if-then-else` statement in the rules? | The rules are *data*; control is the engine's job. That is the point of separating knowledge from inference. |
| How would you add certainty factors to your shell? | Store `Id :: if C then G with CF`. In `prove`, return a CF: min over AND, times the rule CF, and combine alternatives with CF1 + CF2(1 − CF1). Try all rules instead of cutting at the first one. |
| How would you add "why not"? | When a hypothesis fails, record which condition failed and print it (for example "ostrich rejected: has(long_neck) = no"). |
| How would you validate input? | Loop in `ask/2` until the answer is a member of `[yes, no, why]`. |
| How would you make it forward-chaining? | Collect all facts first, then repeatedly fire rules whose conditions are all known and assert their conclusions, until nothing changes. |
| Complexity? | In the worst case exponential in the depth of the rule chain. Our knowledge base is tiny, and memory of answers avoids repeated questions. |
| Can rules have variables? | Yes. For example, `Id :: if parent(X, Y) and parent(Y, Z) then grandparent(X, Z)`. Our animal rules are about one animal per consultation, so they don't need variables. |
| Expert system vs machine learning? | Expert system: hand-written, explainable rules, no training data needed, but brittle and costly to build. Machine learning: learned from data, handles noise, but harder to explain. |
| What is CLIPS? | A forward-chaining expert-system tool developed at NASA (1985) that uses the Rete algorithm. |
| What is a frame? (related Unit II topic) | A structured representation (slots and values) of a stereotyped object. It is an alternative or complement to rules. |

---

## 10. Glossary

- **Antecedent / consequent:** the IF part and the THEN part of a rule.
- **Askable:** a leaf fact the system may ask the user about.
- **Backward chaining:** goal-driven inference, from hypothesis back to facts.
- **Forward chaining:** data-driven inference, from facts forward to conclusions.
- **Backtracking:** retrying alternatives after a failure.
- **Closed-world assumption:** anything not provable is false.
- **Cut (`!`):** commits to the choices made so far in a clause.
- **Expert-system shell:** an engine, user interface and explanation parts without domain knowledge (e.g. EMYCIN, our `engine.pl`).
- **Horn clause:** a clause with at most one positive literal.
- **Inference engine:** the component that applies the rules.
- **Knowledge base:** the collection of domain rules.
- **Working memory:** the case-specific facts (here `known/2`).
- **Meta-interpreter:** a program that executes rules or programs represented as data.
- **Negation as failure (`\+`):** "not provable" is treated as "false".
- **SLD resolution:** Prolog's inference rule (leftmost goal, depth-first search).
- **Unification:** making two terms equal by binding variables.

---

## 11. Facts worth double-checking before presenting

The code and demo output have been **run and verified**. These historical figures came from memory, from standard sources. Check them quickly in the books, or soften the wording, in case someone asks:

- **MYCIN's size:** "about 450 rules" is the figure Russell & Norvig give. Other sources say around 500–600, depending on the version. "Several hundred rules" is always safe.
- **XCON savings:** "an estimated $40M a year by 1986" is Russell & Norvig's figure. Other sources quote about $25M. Say "tens of millions of dollars a year" if unsure.
- **Clarissa:** the Prolog/Regulus detail comes from Rayner et al. (2005). The safe claim is that its language processing was built with Prolog-based tools.
- **Book chapters:** check the Bratko chapter numbers (Ch. 1–2, 5, 15) against your edition (4th edition, 2012). Chapter numbering differs slightly between editions.
