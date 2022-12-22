% display_column_tags(+BoardSize, +Counter)
display_column_tags(BoardSize, BoardSize) :-
    write('|').
display_column_tags(BoardSize, Counter) :-
    write('| '),
    Ascii is Counter + 97,
    put_code(Ascii),
    write(' '),
    CounterAux is Counter + 1,
    display_column_tags(BoardSize, CounterAux).

% display_line(+Line)
display_line([]) :- write('|').
display_line([Column | Rest]) :-
    write('| '),
    write(Column),
    write(' '),
    display_line(Rest).

% display_game_aux(+Board)
display_game_aux([]) :-
    write('-------------').
display_game_aux([Line | Rest]) :-
    write('-------------'),
    nl,
    display_line(Line),
    nl,
    display_game_aux(Rest).

/* TODO: Change in order to receive game state */
% display_game(+BoardSize, +Board)
display_game(BoardSize, Board) :-
    nl,
    display_column_tags(BoardSize, 0),
    nl,
    display_game_aux(Board).

/*
read_move(Line, Column) :- 
    read(N-L),
    number(N),
    is_alpha(L),
    Line is N-1,
    string_upper(L, L1)
    char_code('A', A),
    char_code(L1, Letter)
    Column is Letter-A.
*/

read_move(Row, Column) :- 
    read(R-C),
    number(R),
    number(C),
    Row is R-1,
    Column is C-1.

read_move_until_valid(Size, Move):- 
    repeat,
    write('Insert your move in Row-Column format'), nl,
    read_move(Row, Column),
    Row >= 0,
    Row =< Size-1,
    Column >= 0,
    Column =< Size-1,
    Move = [Row, Column],
    !.              


% valid_moves(GameState, Player, ListOfMoves) :- 
%valid_moves_aux(Board, ListOfMoves).

valid_moves_aux(Board, ListOfMoves) :- 
    valid_moves_aux(Board, 0, 0, ListOfMoves).

valid_moves_aux([[]], _, _, []) :- !.

valid_moves_aux([[]| Lines], Row, _, ListOfMoves) :- 
    Row1 is Row+1,
    valid_moves_aux(Lines, Row1, 0, ListOfMoves), 
    !.

valid_moves_aux([[e | Pieces] | Lines], Row, Col, ListOfMoves) :- 
    Col1 is Col + 1,
    valid_moves_aux([Pieces | Lines], Row, Col1, ListOfMoves1), 
    ListOfMoves = [[Row, Col] | ListOfMoves1],
    !.

valid_moves_aux([[_ | Pieces] | Lines], Row, Col, ListOfMoves) :-
    Col1 is Col + 1,
    valid_moves_aux([Pieces | Lines], Row, Col1, ListOfMoves).

insert_piece([_ | Rest], Piece, 0, [Piece | Rest]) :- !.
insert_piece([Member | Rest], Piece, Position, Result) :- 
    Position1 is Position-1,
    insert_piece(Rest, Piece, Position1, R1),
    Result = [Member | R1].

insert_piece([Row | Rest], Piece, 0, Col, NewBoard) :- 
    insert_piece(Row, Piece, Col, NewRow), 
    NewBoard = [NewRow | Rest], 
    !.
insert_piece([Row | Rest], Piece, R, Col, NewBoard) :- 
    Row1 is R-1,
    insert_piece(Rest, Piece, Row1, Col, NB1),
    NewBoard = [Row | NB1].