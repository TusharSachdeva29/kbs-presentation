% zoo_kb.pl - animal identification rule base
% Adapted from Winston's ZOOKEEPER rules, as used in Bratko (2012), Ch. 15
:- ensure_loaded(engine).  % ops + engine

top_goal(animal(_)).  % what to prove

r1 :: if has(hair) then mammal.
r2 :: if gives(milk) then mammal.
r3 :: if has(feathers) then bird.
r4 :: if flies and lays(eggs) then bird.
r5 :: if mammal and eats(meat) then carnivore.
r6 :: if mammal and has(pointed_teeth) and has(claws)
         and has(forward_eyes) then carnivore.
r7 :: if mammal and has(hoofs) then ungulate.
r8 :: if mammal and chews(cud) then ungulate.

r9 :: if carnivore and has(tawny_colour)
         and has(dark_spots) then animal(cheetah).
r10 :: if carnivore and has(tawny_colour)
          and has(black_stripes) then animal(tiger).
r11 :: if ungulate and has(long_neck) and has(long_legs)
          and has(dark_spots) then animal(giraffe).
r12 :: if ungulate and has(black_stripes)
          then animal(zebra).
r13 :: if bird and not(flies) and has(long_neck)
          and has(long_legs) then animal(ostrich).
r14 :: if bird and not(flies) and swims
          and has(black_white_colour) then animal(penguin).
r15 :: if bird and flies_well then animal(albatross).

% leaf facts: ASK the user
askable(has(_)).
askable(gives(_)).
askable(eats(_)).
askable(lays(_)).
askable(chews(_)).
askable(flies).
askable(flies_well).
askable(swims).
