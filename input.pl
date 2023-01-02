% read_move(-Line, -Column)
read_move(Line, Column) :- 
    read(N-L),
    number(N),
    Line is N-1,
    char_code('a', A),
    char_code(L, Letter),
    Column is Letter-A.

% read_move_until_valid(+ListOfValidMoves, -Move)
read_move_until_valid(ListOfValidMoves, Move):- 
    repeat, nl,
    write('Insert your move in Number-Letter format'), nl,
    read_move(Line, Column),
    Move = [Line, Column],
    member(Move, ListOfValidMoves),
    !.