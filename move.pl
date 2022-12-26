:- use_module(library(lists)).
:- use_module(library(random)).

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


% valid_moves_aux(Board, ListOfMoves).
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

% valid_moves(+GameState, +Player, -ListOfMoves) 
valid_moves(GameState, _, ListOfMoves) :-
    get_board(GameState, Board),
    valid_moves_aux(Board, ListOfMoves).
    

% count_pieces_in_line(+Line, +Player, -Number)
count_pieces_in_line([], _, 0).
count_pieces_in_line([Player | Rest], Player, Number) :-
    count_pieces_in_line(Rest, Player, NumberAux),
    Number is NumberAux + 1,
    !.
count_pieces_in_line([_ | Rest], Player, Number) :-
    count_pieces_in_line(Rest, Player, Number).

% value_line(+Line, +Player, -Value)
value_line(Line, Player, Value) :-
    count_pieces_in_line(Line, Player, Number),
    Number = 2,
    Value is 1, 
    !.
value_line(Line, Player, Value) :-
    count_pieces_in_line(Line, Player, Number),
    Number = 5,
    Value is 2, 
    !.
value_line(Line, Player, Value) :-
    count_pieces_in_line(Line, Player, Number),
    Number = 8,
    Value is 3,
    !.
value_line(_, _, 0).

% choose_move(+GameState, +Player, +Level, -Move)
choose_move(GameState, Player, 1, [Line, Column]) :-
    valid_moves(GameState, Player, FreePositions),
    length(FreePositions, Size),
    Upper is Size - 1,
    random(0, Upper, Choice),
    nth0(Choice, FreePositions, [Line, Column]).
