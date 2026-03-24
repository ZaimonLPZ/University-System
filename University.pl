:- dynamic student/3.

load_students :-
    consult('C:/Users/alexandra/Desktop/University pl.txt').
    
save_students :-
    tell('C:/Users/alexandra/Desktop/University pl.txt'),
    listing(student),
    told.

check_in :-
    write('ID: '), read(ID),
    write('Hora entrada: '), read(Entrada),
    assertz(student(ID, Entrada, 0)),
    save_students.

search_student :-
    write('ID: '), read(ID),
    ( student(ID, E, S), S =:= 0 ->
        write('Dentro: '), write(student(ID,E,S)), nl
    ;
        write('No esta dentro'), nl
    ).

calculate_time :-
    write('ID: '), read(ID),
    ( student(ID, E, S), S =\= 0 ->
        Tiempo is S - E,
        write('Tiempo: '), write(Tiempo), nl
    ;
        write('No disponible'), nl
    ).

check_out :-
    write('ID: '), read(ID),
    write('Hora salida: '), read(Salida),
    retract(student(ID, E, _)),
    assertz(student(ID, E, Salida)),
    save_students.

show_students :-
    listing(student).

menu :-
    nl,
    write('1 Registrar Ingreso'), nl,
    write('2 Buscar Estudiante'), nl,
    write('3 Calcular Tiempo'), nl,
    write('4 Mostrar Estudiantes'), nl,
    write('5 Registrar Salida'), nl,
    write('6 Abrirse del parche'), nl,
    read(Opcion),
    ejecutar(Opcion).

ejecutar(1) :- check_in, menu.
ejecutar(2) :- search_student, menu.
ejecutar(3) :- calculate_time, menu.
ejecutar(4) :- show_students, menu.
ejecutar(5) :- check_out, menu.
ejecutar(6) :- write('Pico y chao 😎'), nl.
ejecutar(_) :- menu.

start :-
    load_students,
    menu.
