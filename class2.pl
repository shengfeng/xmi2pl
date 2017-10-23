%class
class(c1, 'Vehicle', f).
class(c2, 'Car', f).
class(c3, 'Motorcycle', f).
class(c4, 'Company', f).
class(c5, 'RentalStation', f).
class(c6, 'Person', f).
class(c7, 'Date', f).

attribute(a1, registration, string, c1).
attribute(a2, numWheels, integer, c1).
attribute(a3, category, integer, c2).
attribute(a4, numSaddles, integer, c3).
attribute(a5, cc, integer, c3).
attribute(a6, name, string, c4).
attribute(a7, numEmployee, integer, c4).
attribute(a8, location, string, c5).
attribute(a9, firstname, string, c6).
attribute(a10, lastname, string, c6).
attribute(a11, age, integer, c6).
attribute(a12, isMarried, boolean, c6).

operation(o1, stockPrice, [],  c4).
operation(o2, income, [p1],  c6).

parameter(p1, d, c7).

association(s1, c1, c4).
association(s2, c4, c5).
association(s3, c5, c6).
association(s4, c5, c6).

rolename(r1, vehicle, company, s1).
rolename(r2, company, rentalStation, s2).
rolename(r3, managedStation, manager, s3).
rolename(r4, employer, employee, s4).

multiplicity(m1, c1, 0, n, s1).
multiplicity(m2, c4, 0, 1, s1).
multiplicity(m3, c4, 1, 1, s2).
multiplicity(m4, c5, 1, n, s2).
multiplicity(m5, c5, 0, 1, s3).
multiplicity(m6, c6, 1, 1, s3).
multiplicity(m7, c5, 0, 1, s4).
multiplicity(m8, c6, 0, n, s4).

generalization(g1, c1, c2).
generalization(g2, c1, c3).


%objects
object(o1, p1, c6).
object(o2, p2, c6).
object(o3, r1, c5).
object(o4, c1, c4).
object(o5, v1, c2).
object(o6, v2, c2).
object(o7, v3, c3).

link(l1, o2, o3).
link(l2, o1, o3).
link(l3, o3, o4).
link(l4, o4, o5).
link(l5, o4, o6).
link(l6, o4, o7).

attrval(av1, a9, 'Oliver', o1).
attrval(av2, a10, 'Queen', o1).
attrval(av3, a11, 34, o1).
attrval(av4, a12, boolean, o1).
attrval(av5, a9, 'Jane', o2).
attrval(av6, a10, 'Quinn', o2).
attrval(av7, a11, 23, o2).
attrval(av8, a12, boolean, o2).
attrval(av9, a8, 'New York', o3).
attrval(av10, a6, 'Ford', o4).
attrval(av11, a7, 3000, o4).
attrval(av12, a1, 'VC1', o5).
attrval(av13, a2, 4, o5).
attrval(av14, a3, 1, o5).
attrval(av15, a1, 'VC2', o6).
attrval(av16, a2, 4, o6).
attrval(av17, a3, 2, o6).
attrval(av18, a1, 'VM1', o7).
attrval(av19, a2, 2, o7).
attrval(av20, a4, 2, o7).
attrval(av21, a5, 30, o7).

mcall(m1, getAge, [ ], o1, o2).


%Functions
parents(Superid, Subid) :-
  generalization(_, Superid, Subid).
parents(Superid, Subid) :-
  generalization(_, Superid, X),
  parents(X, Subid).


objects_from_class(X, Y) :-
    object(_, Y, X).
	
objects_from_class(X, Y) :-
    generalization(_, X, CN),
    objects_from_class(CN, Y).

%Distinct
list_reps([],[]).
list_reps([X|Xs],Ds1) :-
   x_reps_others_fromlist(X,Ds,Os,Xs),
   list_reps(Os,Ds0),
   append(Ds,Ds0,Ds1).

x_reps_others_fromlist(_X,[],[],[]).
x_reps_others_fromlist(X,[X|Ds],Os,[X|Ys]) :-
   x_reps_others_fromlist(X,Ds,Os,Ys).
x_reps_others_fromlist(X,Ds,[Y|Os],[Y|Ys]) :-
   dif(Y,X),
   x_reps_others_fromlist(X,Ds,Os,Ys).


%Subset
sublist( [], _ ).
sublist( [X|XS], [X|XSS] ) :- sublist( XS, XSS ).
sublist( [X|XS], [_|XSS] ) :- sublist( [X|XS], XSS ).
   
%Rules

gen_rule() :-
  generalization(_, Superid, Subid),
  findall(Y, objects_from_class(Subid, Y), IDS), 
  findall(Y, objects_from_class(Superid, Y), IDS2),
  sublist(IDS, IDS2).

%if the class not satisfied, execute the latter 
objcl_exist_rule(R) :-
	object(Objid, _, _),
	object(Objid, _, Classid),
	(\+class(Classid, _, _), atom_concat('Error: 301 in ', Objid, R));   
	fail.

%multiplicity 
multi_conform(R) :-
	association(AID, CA, CB),
	object(SID, _, CA),
	object(RID, _, CB),
	link(_, SID, RID, AID).


op_exist_rule():-
	mcall(_, Opname, _, _),
	operation(_,Opname,_,Classid),
    class(Classid, _).

assoc_exist(R):-
  link(Msgid, Sndobjid, Recobjid),
  object(Sndobjid, _, ClassA),
  object(Recobjid, _, ClassB),
  (\+association(_, ClassA, ClassB), 
   \+association(_, ClassB, ClassA), 
  atom_concat('Error: 303 in ', Msgid, R));
  fail.

