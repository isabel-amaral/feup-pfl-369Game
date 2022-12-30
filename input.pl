%read_move(-Row, -Column)
read_move(Row, Column) :- 
    read(N-L),
    number(N),
    Row is N-1,
    char_code('a', A),
    char_code(L, Letter),
    Column is Letter-A.

%read_move_until_valid(+ListOfValidMoves, -Move)
read_move_until_valid(ListOfValidMoves, Move):- 
    repeat,
    write('Insert your move in Row-Column format'), nl,
    read_move(Row, Column),
    Move = [Row, Column],
    member(Move, ListOfValidMoves),
    !.