% valid_moves_aux(+Board, +Line, +Column, -ListOfMoves).
valid_moves_aux([[]], _, _, []) :- !.
valid_moves_aux([[]| Lines], Line, _, ListOfMoves) :- 
    Line1 is Line + 1,
    valid_moves_aux(Lines, Line1, 0, ListOfMoves), 
    !.
valid_moves_aux([[e | Pieces] | Lines], Line, Col, ListOfMoves) :- 
    Col1 is Col + 1,
    valid_moves_aux([Pieces | Lines], Line, Col1, ListOfMoves1), 
    ListOfMoves = [[Line, Col] | ListOfMoves1],
    !.
valid_moves_aux([[_ | Pieces] | Lines], Line, Col, ListOfMoves) :-
    Col1 is Col + 1,
    valid_moves_aux([Pieces | Lines], Line, Col1, ListOfMoves).

% valid_moves(+GameState, +Player, -ListOfMoves) 
valid_moves(GameState, _, ListOfMoves) :-
    get_board(GameState, Board),
    valid_moves_aux(Board, 0, 0, ListOfMoves).


% valid_moves_in_sequence(+Line, +LineCounter, -ListOfMoves)
% Determines all the empty positions in a given sequence, which may be one of the
% board´s lines, one of its columns or one of its diagonals 
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
% Determines all the empty positions in a given board line
valid_moves_in_line(Board, LineIndex, ListOfMoves) :-
    nth0(LineIndex, Board, Line),
    valid_moves_in_sequence(Line, 0, ListOfMoves).

% valid_moves_in_col(+Board, +ColumnIndex, -ListOfMoves)
% Determines all the empty positions in a given board column
valid_moves_in_col(Board, ColumnIndex, ListOfMoves) :-
    get_column(ColumnIndex, Board, Column),
    valid_moves_in_sequence(Column, 0, ListOfMoves).

% valid_moves_in_diagonal(+Board, +BoardSize, +Diagonal, -ListOfMoves)
% Determines all the empty positions in a given board diagonal
valid_moves_in_diagonal(Board, BoardSize, [StartingColumn, d1], ListOfMoves) :-
    get_diagonal1([0, StartingColumn], Board, BoardSize, Diagonal),
    valid_moves_in_sequence(Diagonal, 0, ListOfMoves).
valid_moves_in_diagonal(Board, BoardSize, [StartingColumn, d2], ListOfMoves) :-
    get_diagonal2([0, StartingColumn], Board, BoardSize, Diagonal),
    valid_moves_in_sequence(Diagonal, 0, ListOfMoves).


% insert_piece_into_line(+Line, +Piece, +Position, -NewLine)
insert_piece_into_line([_ | Rest], Piece, 0, [Piece | Rest]) :- !.
insert_piece_into_line([Member | Rest], Piece, Position, Result) :- 
    Position1 is Position-1,
    insert_piece_into_line(Rest, Piece, Position1, R1),
    Result = [Member | R1].

% insert_piece_into_board(+Board, +Piece, +Line, +Column, -NewBoard)
insert_piece_into_board([Line | Rest], Piece, 0, Col, NewBoard) :- 
    insert_piece_into_line(Line, Piece, Col, NewLine), 
    NewBoard = [NewLine | Rest], 
    !.
insert_piece_into_board([Line | Rest], Piece, R, Col, NewBoard) :- 
    Line1 is R-1,
    insert_piece_into_board(Rest, Piece, Line1, Col, NB1),
    NewBoard = [Line | NB1].   

% update_board(+GameState, +Board, -NewGameState)
update_board([BoardSize, _, Level, WhitePlayer, BlackPlayer, NextPlayer], NewBoard, NewGameState) :-
    NewGameState = [BoardSize, NewBoard, Level, WhitePlayer, BlackPlayer, NextPlayer].

% update_points(+GameState, +Move, -NewGameState)
update_points([Size, Board, Level, WPoints, BPoints, w], Move, NewGameState) :- 
    line_points(Board, w, Move, LinePoints),
    column_points(Board, w, Move, ColumnPoints),
    diagonal1_points(Board, w, Move, Size, Diagonal1Points),
    diagonal2_points(Board, w, Move, Size, Diagonal2Points),
    Points is WPoints + LinePoints + ColumnPoints + Diagonal1Points + Diagonal2Points,
    NewGameState = [Size, Board, Level, Points, BPoints, w].
update_points([Size, Board, Level, WPoints, BPoints, b], Move, NewGameState) :- 
    line_points(Board, b, Move, LinePoints),
    column_points(Board, b, Move, ColumnPoints),
    diagonal1_points(Board, b, Move, Size, Diagonal1Points),
    diagonal2_points(Board, b, Move, Size, Diagonal2Points),
    Points is BPoints + LinePoints + ColumnPoints + Diagonal1Points + Diagonal2Points,
    NewGameState = [Size, Board, Level, WPoints, Points, b].

% update_next_player(+GameState, -NewGameState)
update_next_player([Size, Board, Level, WPoints, BPoints, w], [Size, Board, Level, WPoints, BPoints, b]).
update_next_player([Size, Board, Level, WPoints, BPoints, b], [Size, Board, Level, WPoints, BPoints, w]).

% move(+GameState, +Move, -NewGameState) 
move(GameState, [Line, Column], NewGameState) :- 
    get_next_player(GameState, Player),
    get_board(GameState, Board),
    insert_piece_into_board(Board, Player, Line, Column, NewBoard),
    update_board(GameState, NewBoard, NewGameState1),
    update_points(NewGameState1, [Line, Column], NewGameState2),
    update_next_player(NewGameState2, NewGameState).  


% there_is_good_move(+LinePoints, +ColumnPoints, +DiagonalPoints)
% Checks if there is any move in either of the board´s lines, columns or diagonals that will guarantee 1 or more points
there_is_good_move(0, 0, 0).

% choose_move_aux(+Board, +BoardSize, +BestLine, +LinePoints, +BestColumn, +ColumnPoints, +BestDiagonal, +DiagonalPoints, -Move)
% If there is a move that will guarantee 1 or more points, checks if that move will be done in the best line, best column or best diagonal
choose_move_aux(Board, _, BestLine, LinePoints, _, ColumnPoints, _, DiagonalPoints, [Line, Column]) :-
    LinePoints >= ColumnPoints,
    LinePoints >= DiagonalPoints,
    Line is BestLine,
    valid_moves_in_line(Board, BestLine, ListOfMoves),
    length(ListOfMoves, Size),
    random(0, Size, Choice),
    nth0(Choice, ListOfMoves, Column),
    !.
choose_move_aux(Board, _, _, _, BestColumn, ColumnPoints, _, DiagonalPoints, [Line, Column]) :-
    ColumnPoints >= DiagonalPoints,
    Column is BestColumn,
    valid_moves_in_col(Board, BestColumn, ListOfMoves),
    length(ListOfMoves, Size),
    random(0, Size, Choice),
    nth0(Choice, ListOfMoves, Line),
    !.
choose_move_aux(Board, BoardSize, _, _, _, _, [StartingColumn, d1], _, [Line, Column]) :-
    valid_moves_in_diagonal(Board, BoardSize, [StartingColumn, d1], ListOfMoves),
    length(ListOfMoves, Size),
    random(0, Size, Choice),
    nth0(Choice, ListOfMoves, Line),
    Column is StartingColumn + Line.
choose_move_aux(Board, BoardSize, _, _, _, _, [StartingColumn, d2], _, [Line, Column]) :-
    valid_moves_in_diagonal(Board, BoardSize, [StartingColumn, d2], ListOfMoves),
    length(ListOfMoves, Size),
    random(0, Size, Choice),
    nth0(Choice, ListOfMoves, Line),
    Column is StartingColumn - Line.

% choose_move(+GameState, +Player, +Level, -Move)
% Choses a random move for the pc in level 1 or the best move in the current game iteration in level 2
choose_move(GameState, Player, 1, [Line, Column]) :-
    valid_moves(GameState, Player, ListOfMoves),
    length(ListOfMoves, Size),
    random(0, Size, Choice),
    nth0(Choice, ListOfMoves, [Line, Column]).
choose_move(GameState, Player, 2, [Line, Column]) :-
    get_board(GameState, Board),
    value_lines(Board, BestLine, Player, LinePoints),
    get_board_size(GameState, BoardSize),
    value_columns(Board, BoardSize, BestColumn, Player, ColumnPoints),
    value_diagonals(Board, BoardSize, BestDiagonal, Player, DiagonalPoints),
    \+there_is_good_move(LinePoints, ColumnPoints, DiagonalPoints),
    choose_move_aux(Board, BoardSize, BestLine, LinePoints, BestColumn, ColumnPoints, BestDiagonal, DiagonalPoints, [Line, Column]),
    !.
choose_move(GameState, Player, 2, [Line, Column]) :-
    nl,
    valid_moves(GameState, Player, ListOfMoves),
    length(ListOfMoves, Size),
    random(0, Size, Choice),
    nth0(Choice, ListOfMoves, [Line, Column]). 
