% read_move(-Line, -Column)
% Reads the player´s move in N-L format, where N corresponds to a board line and should be a number
% and L corresponds to a board column and should be a letter.
% The Line variable is obtained by subtracting 1 from N and the Column variable is
% the result of subtracting the ASCII code of 'a' from the ASCII code of L
read_move(Line, Column) :- 
    read(N-L),
    number(N),
    Line is N-1,
    char_code('a', A),
    char_code(L, Letter),
    Column is Letter-A.

% read_move_until_valid(+ListOfValidMoves, -Move)
% Repeatedly asks the user´s next move until a valid one is inserted, i.e., the move is a member of
% ListOfValidMoves, if so, the chosen move is returned in the Move variable, in [Line, Column] format 
read_move_until_valid(ListOfValidMoves, Move):- 
    repeat, nl,
    write('Insert your move in Number-Letter format'), nl,
    read_move(Line, Column),
    Move = [Line, Column],
    member(Move, ListOfValidMoves),
    !.