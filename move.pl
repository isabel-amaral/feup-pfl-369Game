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


% valid_moves_in_sequence(+Line, +LineCounter, -ListOfMoves)
valid_moves_in_sequence([], _, []).
valid_moves_in_sequence([e | Rest], LineCounter, ListOfMoves) :-
    LineCounterAux is LineCounter + 1,
    valid_moves_in_sequence(Rest, LineCounterAux, ListOfMovesAux),
    ListOfMoves = [LineCounter | ListOfMovesAux],
    !.
valid_moves_in_sequence([_ | Rest], LineCounter, ListOfMoves) :-
    LineCounterAux is LineCounter + 1,
    valid_moves_in_sequence(Rest, LineCounterAux, ListOfMoves).

% valid_moves_in_line(+Board, +LineIndex, -ListOfMoves)
valid_moves_in_line(Board, LineIndex, ListOfMoves) :-
    nth0(LineIndex, Board, Line),
    valid_moves_in_sequence(Line, 0, ListOfMoves).

% valid_moves_in_col(+Board, +ColumnIndex, -ListOfMoves)
valid_moves_in_col(Board, ColumnIndex, ListOfMoves) :-
    get_column(ColumnIndex, Board, Column),
    valid_moves_in_sequence(Column, 0, ListOfMoves).


% insert_piece_into_row(+Row, +Piece, +Position, -NewRow)
insert_piece_into_row([_ | Rest], Piece, 0, [Piece | Rest]) :- !.
insert_piece_into_row([Member | Rest], Piece, Position, Result) :- 
    Position1 is Position-1,
    insert_piece_into_row(Rest, Piece, Position1, R1),
    Result = [Member | R1].

% insert_piece_into_board(+Board, +Piece, +Row, +Column, -NewBoard)
insert_piece_into_board([Row | Rest], Piece, 0, Col, NewBoard) :- 
    insert_piece_into_row(Row, Piece, Col, NewRow), 
    NewBoard = [NewRow | Rest], 
    !.
insert_piece_into_board([Row | Rest], Piece, R, Col, NewBoard) :- 
    Row1 is R-1,
    insert_piece_into_board(Rest, Piece, Row1, Col, NB1),
    NewBoard = [Row | NB1].   

% update_board(+GameState, +Board, -NewGameState)
update_board([BoardSize, _, WhitePlayer, BlackPlayer, NextPlayer], NewBoard, NewGameState) :-
    NewGameState = [BoardSize, NewBoard, WhitePlayer, BlackPlayer, NextPlayer].

% update_points(+GameState, +Move, -NewGameState)
update_points([Size, Board, WPoints, BPoints, w], Move, NewGameState) :- 
    row_points(Board, Player, Move, RowPoints),
    column_points(Board, Player, Move, ColumnPoints),
    diagonal1_points(Board, Player, Move, Size, Diagonal1Points),
    diagonal2_points(Board, Player, Move, Size, Diagonal2Points),
    Points is WPoints + RowPoints + ColumnPoints + Diagonal1Points + Diagonal2Points,
    NewGameState = [Size, Board, Points, BPoints, w].
update_points([Size, Board, WPoints, BPoints, b], Move, NewGameState) :- 
    row_points(Board, Player, Move, RowPoints),
    column_points(Board, Player, Move, ColumnPoints),
    diagonal1_points(Board, Player, Move, Size, Diagonal1Points),
    diagonal2_points(Board, Player, Move, Size, Diagonal2Points),
    Points is BPoints + RowPoints + ColumnPoints + Diagonal1Points + Diagonal2Points,
    NewGameState = [Size, Board, WPoints, Points, b].

% update_next_player(+GameState, -NewGameState)
update_next_player([Size, Board, WPoints, BPoints, w], [Size,Board, WPoints, BPoints, b]).
update_next_player([Size, Board, WPoints, BPoints, b], [Size,Board, WPoints, BPoints, w]).

% move(+GameState, +Move, -NewGameState) 
move(GameState, [Row, Column], NewGameState) :- 
    get_next_player(GameState, Player),
    get_board(GameState, Board),
    insert_piece_into_board(Board, Player, Row, Column, NewBoard),
    update_board(GameState, NewBoard, NewGameState1),
    update_points(NewGameState1, [Row, Column], NewGameState2),
    update_next_player(NewGameState2, NewGameState).         


% choose_move(+GameState, +Player, +Level, -Move)
choose_move(GameState, Player, 1, [Line, Column]) :-
    valid_moves(GameState, Player, ListOfMoves),
    length(ListOfMoves, Size),
    random(0, Size, Choice),
    nth0(Choice, ListOfMoves, [Line, Column]).
