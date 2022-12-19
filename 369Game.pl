/*
read_move(Line, Column) :- read(N-L),
                           number(N),
                           is_alpha(L),
                           Line is N-1,
                           string_upper(L, L1)
                           char_code('A', A),
                           char_code(L1, Letter)
                           Column is Letter-A.
*/

read_move(Row, Column) :- read(R-C),
                           number(R),
                           number(C),
                           Row is R-1,
                           Column is C-1.

read_move_until_valid(Size, Move):- repeat,
                                    write('Insert your move in Row-Column format'), nl,
                                    read_move(Row, Column),
                                    Row >= 0,
                                    Row =< Size-1,
                                    Column >= 0,
                                    Column =< Size-1,
                                    Move = [Row, Column],
                                    !.              


insert_piece([_ | Rest], Elem, 0, [Elem | Rest]) :- !.
insert_piece([Member | Rest], Elem, Position, Result) :- Position1 is Position-1,
                                                         insert_piece(Rest, Elem, Position1, R1),
                                                         Result = [Member | R1].

insert_piece([Line | Rest], Elem, 0, Col, NewBoard) :- insert_piece(Line, Elem, Col, NewLine), NewBoard = [NewLine | Rest], !.
insert_piece([Line | Rest], Elem, L, Col, NewBoard) :- Line1 is L-1,
                                                       insert_piece(Rest, Elem, Line1, Col, NB1),
                                                       NewBoard = [Line | NB1].