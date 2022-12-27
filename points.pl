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

% value_lines(+Board, -Line, +Player, -Number)
value_lines(Board, BestLine, Player, Number) :- 
    value_lines(Board, BestLine, 0, Player, Number).
value_lines([], BestLine, LineCounter, _, 0) :-
    BestLine is LineCounter.
value_lines([Line | Rest], BestLine, LineCounter, Player, Number) :-
    value_line(Line, Player, NumberAux1),
    LineCounterAux is LineCounter + 1,
    value_lines(Rest, BestLineAux, LineCounterAux, Player, NumberAux2),
    NumberAux1 < NumberAux2,
    Number is NumberAux2,
    BestLine is BestLineAux,
    !.
value_lines([Line | _], BestLine, LineCounter, Player, Number) :-
    value_line(Line, Player, Number),
    BestLine is LineCounter.

% value_columns(+Board, +BoardSize, -Column, +Player, -Number)
value_columns(Board, BoardSize, BestColumn, Player, Number) :-
    value_columns(Board, BoardSize, BestColumn, 0, Player, Number).
value_columns(_, BoardSize, BestColumn, BoardSize, _, 0) :-
    BestColumn is BoardSize.
value_columns(Board, BoardSize, BestColumn, ColumnCounter, Player, Number) :-
    get_column(Board, ColumnCounter, Column),
    value_line(Column, Player, NumberAux1),
    ColumnCounterAux is ColumnCounter + 1,
    value_columns(Board, BoardSize, BestColumnAux, ColumnCounterAux, Player, NumberAux2),
    NumberAux1 < NumberAux2,
    Number is NumberAux2,
    BestColumn is BestColumnAux,
    !.
value_columns(Board, _, BestColumn, ColumnCounter, Player, Number) :-
    get_column(Board, ColumnCounter, Column),
    value_line(Column, Player, NumberAux),
    Number is NumberAux,
    BestColumn is ColumnCounter.
