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
    points(Diagonal, Player, 0, Points).

% diagonal2_points(+Board, +Player, +Move, +Size, -Points)
diagonal2_points(Board, Player, Move, Size, Points) :-
    get_diagonal2(Move, Board, Size, Diagonal),
    points(Diagonal, Player, 0, Points).


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
value_columns(_, BoardSize, BestColumn, BoardSize-1, _, 0) :-
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
