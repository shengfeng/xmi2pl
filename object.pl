class(c1, 'Vehicle', f).
class(c2, 'Car', f).
class(c3, 'Motorcycle', f).
class(c4, 'Company', f).
class(c5, 'RentalStation', f).
class(c6, 'Person', f).
class(c7, 'Date', f).

attribute(a1, registration, string, c1).
attribute(a2, numWheels, int, c1).
attribute(a3, category, int, c2).
attribute(a4, numSaddles, int, c3).
attribute(a5, cc, int, c3).
attribute(a6, name, string, c4).
attribute(a7, numEmployees, int, c4).
attribute(a8, location, string, c5).
attribute(a9, firstname, string, c6).
attribute(a10, lastname, string, c6).
attribute(a11, age, int, c6).
attribute(a12, isMarried, boolean, c6).

operation(o1, stockPrice, [],  c4).
operation(o2, income, [p1],  c6).

parameter(p1, d, c7).

association(s1, c5, c6).
association(s2, c1, c4).
association(s3, c4, c5).
association(s4, c5, c6).

rolename(r1, employee, employer, s1).
rolename(r2, vehicle, company, s2).
rolename(r3, company, rentalstation, s3).
rolename(r4, manager, managedStation, s4).

multiplicity(m1, c1, 0, 1, s2).
multiplicity(m2, c4, 0, n, s2).
multiplicity(m3, c4, 1, n, s3).
multiplicity(m4, c5, 0, n, s1).
multiplicity(m5, c5, 1, 1, s3).
multiplicity(m6, c5, 1, 1, s4).
multiplicity(m7, c6, 0, 1, s1).
multiplicity(m8, c6, 0, 1, s4).

generalization(g1, c1, c2).
generalization(g2, c1, c3).

