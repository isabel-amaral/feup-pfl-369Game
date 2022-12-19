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