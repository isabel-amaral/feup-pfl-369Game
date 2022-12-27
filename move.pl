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
update_points([Size, Board, WPoints, BPoints, b], Move, NewGameState) :- 
    row_points(Board, Player, Move, RowPoints),
    column_points(Board, Player, Move, ColumnPoints),
    diagonal1_points(Board, Player, Move, Size, Diagonal1Points),
    diagonal2_points(Board, Player, Move, Size, Diagonal2Points),
    Points is WPoints + RowPoints + ColumnPoints + Diagonal1Points + Diagonal2Points,
    NewGameState = [Size, Board, Points, BPoints, b].
update_points([Size, Board, WPoints, BPoints, p], Move, NewGameState) :- 
    row_points(Board, Player, Move, RowPoints),
    column_points(Board, Player, Move, ColumnPoints),
    diagonal1_points(Board, Player, Move, Size, Diagonal1Points),
    diagonal2_points(Board, Player, Move, Size, Diagonal2Points),
    Points is BPoints + RowPoints + ColumnPoints + Diagonal1Points + Diagonal2Points,
    NewGameState = [Size, Board, WPoints, Points, p].

% update_next_player(+GameState, -NewGameState)
update_next_player([Size, Board, WPoints, BPoints, b], [Size,Board, WPoints, BPoints, p]).
update_next_player([Size, Board, WPoints, BPoints, p], [Size,Board, WPoints, BPoints, b]).

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
    valid_moves(GameState, Player, FreePositions),
    length(FreePositions, Size),
    Upper is Size - 1,
    random(0, Upper, Choice),
    nth0(Choice, FreePositions, [Line, Column]).