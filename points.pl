% count_pieces_in_line(+Line, +Player, -Number)
count_pieces_in_line([], _, 0).
count_pieces_in_line([Player | Rest], Player, Number) :-
    count_pieces_in_line(Rest, Player, NumberAux),
    Number is NumberAux + 1,
    !.
count_pieces_in_line([_ | Rest], Player, Number) :-
    count_pieces_in_line(Rest, Player, Number).


% points(+Sequence, +Player, -Points)
points(Sequence, Player, Points) :-
    count_pieces_in_line(Sequence, Player, Number),
    Number = 3,
    Points = 1,
    !.
points(Sequence, Player, Points) :-
    count_pieces_in_line(Sequence, Player, Number),
    Number = 6,
    Points = 2,
    !.
points(Sequence, Player, Points) :-
    count_pieces_in_line(Sequence, Player, Number),
    Number = 9,
    Points = 3,
    !.
points(_, _, 0).

% row_points(+Board, +Player, +Move, -Points)
row_points(Board, Player, [R, _], Points) :- 
    nth0(R, Board, Row),
    points(Row, Player, Points).

% column_points(+Board, +Player, +Move, -Points)
column_points(Board, Player, [_, C], Points) :-
    get_column(C, Board, Column),
    points(Column, Player, Points).

% diagonal1_points(+Board, +Player, +Move, +Size, -Points)
diagonal1_points(Board, Player, Move, Size, Points) :-
    get_diagonal1(Move, Board, Size, Diagonal),
    points(Diagonal, Player, Points).

% diagonal2_points(+Board, +Player, +Move, +Size, -Points)
diagonal2_points(Board, Player, Move, Size, Points) :-
    get_diagonal2(Move, Board, Size, Diagonal),
    points(Diagonal, Player, Points).


% value_line(+Line, +Player, -Value)
value_line(Line, Player, Value) :-
    count_pieces_in_line(Line, Player, Number),
    Number = 2,
    member(e, Line),
    Value is 1, 
    !.
value_line(Line, Player, Value) :-
    count_pieces_in_line(Line, Player, Number),
    Number = 5,
    member(e, Line),
    Value is 2, 
    !.
value_line(Line, Player, Value) :-
    count_pieces_in_line(Line, Player, Number),
    Number = 8,
    member(e, Line),
    Value is 3,
    !.
value_line(_, _, 0).

% value_lines(+Board, -Line, +Player, -Points)
value_lines(Board, BestLine, Player, Points) :- 
    value_lines(Board, BestLine, 0, Player, Points).
value_lines([], BestLine, LineCounter, _, 0) :-
    BestLine is LineCounter.
value_lines([Line | Rest], BestLine, LineCounter, Player, Points) :-
    value_line(Line, Player, PointsAux1),
    LineCounterAux is LineCounter + 1,
    value_lines(Rest, BestLineAux, LineCounterAux, Player, PointsAux2),
    PointsAux1 < PointsAux2,
    Points is PointsAux2,
    BestLine is BestLineAux,
    !.
value_lines([Line | _], BestLine, LineCounter, Player, Points) :-
    value_line(Line, Player, Points),
    BestLine is LineCounter.

% value_columns(+Board, +BoardSize, -Column, +Player, -Points)
value_columns(Board, BoardSize, BestColumn, Player, Points) :-
    value_columns(Board, BoardSize, BestColumn, 0, Player, Points).
value_columns(_, BoardSize, BestColumn, BoardSize, _, 0) :-
    BestColumn is BoardSize-1.
value_columns(Board, BoardSize, BestColumn, ColumnCounter, Player, Points) :-
    get_column(ColumnCounter, Board, Column),
    value_line(Column, Player, PointsAux1),
    ColumnCounterAux is ColumnCounter + 1,
    value_columns(Board, BoardSize, BestColumnAux, ColumnCounterAux, Player, PointsAux2),
    PointsAux1 < PointsAux2,
    Points is PointsAux2,
    BestColumn is BestColumnAux,
    !.
value_columns(Board, _, BestColumn, ColumnCounter, Player, Points) :-
    get_column(ColumnCounter, Board, Column),
    value_line(Column, Player, PointsAux),
    Points is PointsAux,
    BestColumn is ColumnCounter.

% choose_best_diagonal(+Diagonal1, +Diagonal2, +Player, -Dir, -Points)
choose_best_diagonal(Diagonal1, Diagonal2, Player, Dir, Points) :-
    value_line(Diagonal1, Player, PointsAux1),
    value_line(Diagonal2, Player, PointsAux2),
    PointsAux1 >= PointsAux2,
    Dir = d1,
    Points is PointsAux1,
    !.
choose_best_diagonal(_, Diagonal2, Player, Dir, Points) :-
    value_line(Diagonal2, Player, Points),
    Dir = d2.

% value_diagonals_aux(+Position1, +Points1, +Position2, +Points2, -Position, -Points)
value_diagonals_aux(Position1, Points1, _, Points2, Position, Points) :-
    Points1 >= Points2,
    Points is Points1,
    Position = Position1,
    !.
value_diagonals_aux(_, _, Position2, Points2, Position, Points) :-
    Points is Points2,
    Position = Position2.

% value_diagonals(+Board, +BoardSize, -Position, +Player, -Points)
value_diagonals(Board, BoardSize, BestPosition, Player, Points) :-
    value_diagonals(Board, BoardSize, BestPosition, 0, Player, Points).
value_diagonals(_, BoardSize, BestPosition, BoardSize, _, 0) :-
    BestPosition = [BoardSize-1, d2].
value_diagonals(Board, BoardSize, BestPosition, PositionCounter, Player, Points) :-
    get_diagonal1([0, PositionCounter], Board, BoardSize, Diagonal1),
    get_diagonal2([0, PositionCounter], Board, BoardSize, Diagonal2),
    choose_best_diagonal(Diagonal1, Diagonal2, Player, Dir, PointsAux1),
    PositionCounterAux is PositionCounter + 1,
    value_diagonals(Board, BoardSize, BestPositionAux, PositionCounterAux, Player, PointsAux2),
    value_diagonals_aux([PositionCounter, Dir], PointsAux1, BestPositionAux, PointsAux2, BestPosition, Points).


% value(+GameState, +Player, -Value)
value(GameState, w, Value) :-
    get_white_player_pontuation(GameState, Value).
value(GameState, b, Value) :-
    get_black_player_pontuation(GameState, Value).