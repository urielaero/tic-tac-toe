#!/usr/bin/env swipl

:- initialization main.

eval :-
        current_prolog_flag(argv, Argv),
	jugar(Argv).


main :-
        catch(eval, E, (print_message(error, E), fail)),
        halt.
main :-
        halt(1). 


out(Tablero, '1') :- print(Tablero), print('1').
out(Tablero, '2') :- print(Tablero), print('2').
out(Tablero, '3') :- print(Tablero), print('3').
out(Tablero, '0') :- not(member('0', Tablero)), print(Tablero), print('3').
out(Tablero, '0') :- print(Tablero), print('0').

jugar([d|Argv]) :-
	insertar(Argv, Res),
	jugar_movimiento(Res).

jugar([_,'0', '0', '0', '0', '0', '0', '0', '0', '0']) :-
	random_between(1, 9, R),
	mover_to(R, Res),
	out(Res, '0').

jugar(['f'|Argv]) :-
	insertar(Argv, Res),
	jugar_facil(Res).


jugar([_|Argv]) :- jugar_movimiento(Argv).

/*me puedo equivocar*/
jugar_facil(Argv) :- random_between(1,5,Z), selecciona_facil(Z), jugar_movimiento_facil(Argv).
/*muevo lo mejor que puedo*/
jugar_facil(Argv) :- jugar_movimiento(Argv).

selecciona_facil(2).
selecciona_facil(3).
selecciona_facil(4).
selecciona_facil(5).

jugar_movimiento_facil(Argv) :- mover(Argv, '2', ResOtro),
	gano(ResOtro, '1', G1),
	esUno(G1),
	out(ResOtro, '1').

jugar_movimiento_facil(Argv) :- mover(Argv, '2', ResOtro),
	gano(ResOtro, '2', G2),
	esUno(G2),
	out(ResOtro, '2').

jugar_movimiento_facil(Argv) :- mover(Argv, '2', ResOtro),
	out(ResOtro, '0').

/*inserto y gano ?*/
jugar_movimiento(Res) :-
	gano(Res, '1', G1),
	esUno(G1), 
	out(Res, '1').

/*en mi siguiente movimiento gano ?*/
jugar_movimiento(Res) :-
	mover(Res, '2', ResOtro),
	gano(ResOtro, '2', G2),
	esUno(G2),
	out(ResOtro, '2').

/*tiene un siguiente movimiento ganador?*/
jugar_movimiento(Res) :-
	mover(Res, '2', ResOtro),
	not(puedeGanar(ResOtro)),
	out(ResOtro, '0').
	
/*cualquier otro caso*/
jugar_movimiento(Res) :-
	mover(Res, '2', ResOtro),
	out(ResOtro, '0').

/*Ya no queda movimientos posibles = empate*/
jugar_movimiento(Res) :-
  out(Res, '3').

esUno('1').

puedeGanar(Tablero) :- mover(Tablero, '1', Res), gano(Res, '1', G1), esUno(G1).

gano(Estado, Jugador, '1') :- ganoFila(Estado, Jugador); ganoColumna(Estado, Jugador); ganoDiagonal(Estado, Jugador).
gano(_,_, 0).
ganoFila(Estado, Jugador) :- Estado = [Jugador,Jugador,Jugador,_,_,_,_,_,_];
                   Estado = [_,_,_,Jugador,Jugador,Jugador,_,_,_];
		   Estado = [_,_,_,_,_,_,Jugador,Jugador,Jugador].

ganoColumna(Estado, Jugador) :- Estado = [Jugador,_,_,Jugador,_,_,Jugador,_,_];
                   Estado = [_,Jugador,_,_,Jugador,_,_,Jugador,_];
		   Estado = [_,_,Jugador,_,_,Jugador,_,_,Jugador].

ganoDiagonal(Estado, Jugador) :- Estado = [Jugador,_,_,_,Jugador,_,_,_,Jugador];
		   Estado = [_,_,Jugador,_,Jugador,_,Jugador,_,_].

mover(['0',B,C,D,E,F,G,H,I], Jugador, [Jugador,B,C,D,E,F,G,H,I]).
mover([A,'0',C,D,E,F,G,H,I], Jugador, [A,Jugador,C,D,E,F,G,H,I]).
mover([A,B,'0',D,E,F,G,H,I], Jugador, [A,B,Jugador,D,E,F,G,H,I]).
mover([A,B,C,'0',E,F,G,H,I], Jugador, [A,B,C,Jugador,E,F,G,H,I]).
mover([A,B,C,D,'0',F,G,H,I], Jugador, [A,B,C,D,Jugador,F,G,H,I]).
mover([A,B,C,D,E,'0',G,H,I], Jugador, [A,B,C,D,E,Jugador,G,H,I]).
mover([A,B,C,D,E,F,'0',H,I], Jugador, [A,B,C,D,E,F,Jugador,H,I]).
mover([A,B,C,D,E,F,G,'0',I], Jugador, [A,B,C,D,E,F,G,Jugador,I]).
mover([A,B,C,D,E,F,G,H,'0'], Jugador, [A,B,C,D,E,F,G,H,Jugador]).

insertar(['0',B,C,D,E,F,G,H,I,'1'], ['1',B,C,D,E,F,G,H,I]).
insertar([A,'0',C,D,E,F,G,H,I,'2'], [A,'1',C,D,E,F,G,H,I]).
insertar([A,B,'0',D,E,F,G,H,I,'3'], [A,B,'1',D,E,F,G,H,I]).
insertar([A,B,C,'0',E,F,G,H,I,'4'], [A,B,C,'1',E,F,G,H,I]).
insertar([A,B,C,D,'0',F,G,H,I,'5'], [A,B,C,D,'1',F,G,H,I]).
insertar([A,B,C,D,E,'0',G,H,I,'6'], [A,B,C,D,E,'1',G,H,I]).
insertar([A,B,C,D,E,F,'0',H,I,'7'], [A,B,C,D,E,F,'1',H,I]).
insertar([A,B,C,D,E,F,G,'0',I,'8'], [A,B,C,D,E,F,G,'1',I]).
insertar([A,B,C,D,E,F,G,H,'0','9'], [A,B,C,D,E,F,G,H,'1']).

mover_to(1, ['2','0','0','0','0','0','0','0','0']).
mover_to(2, ['0','2','0','0','0','0','0','0','0']).
mover_to(3, ['0','0','2','0','0','0','0','0','0']).
mover_to(4, ['0','0','0','2','0','0','0','0','0']).
mover_to(5, ['0','0','0','0','2','0','0','0','0']).
mover_to(6, ['0','0','0','0','0','2','0','0','0']).
mover_to(7, ['0','0','0','0','0','0','2','0','0']).
mover_to(8, ['0','0','0','0','0','0','0','2','0']).
mover_to(9, ['0','0','0','0','0','0','0','0','2']).
