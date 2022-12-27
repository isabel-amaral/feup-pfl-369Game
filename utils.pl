% GameState is saved in the format [BoardSize, Board, WhitePlayer, BlackPlayer, NextPlayer]

% get_board_size(+GameState, -BoardSize)
get_board_size([BoardSize, _, _, _, _], BoardSize).

% get_board(+GameState, -Board)
get_board([_, Board, _, _, _], Board).

% get_white_player_pontuation(+GameState, -WhitePlayer)
get_white_player_pontuation([_, _, WhitePlayer, _, _], WhitePlayer).

% get_black_player_pontuation(+GameState, -BlackPlayer)
get_black_player_pontuation([_, _, _, BlackPlayer, _], BlackPlayer).

% get_next_player(+GameState, -NextPlayer)
get_next_player([_, _, _, _, NextPlayer], NextPlayer).


% get_column(+ColumnIndex, +Board, -Column)
get_column(_, [], []) :- !.
get_column(ColumnIndex, [Row | Rows], Column) :- 
    nth0(ColumnIndex, Row, Piece),
    get_column(ColumnIndex, Rows, Column1),
    Column = [Piece | Column1].

% get_diagonal1(+Move, +Board, +Size, -Diagonal)
get_diagonal1([Row, Column], Board, Size, Diagonal) :-
    Column >= Row,
    Column1 is Column-Row,
    DiagonalStart = [0, Column1],
    get_diagonal1_aux(DiagonalStart, Board, Size, Diagonal),
    !.
get_diagonal1([Row, Column], Board, Size, Diagonal) :-
    Row1 is Row-Column,
    DiagonalStart = [Row1, 0],
    get_diagonal1_aux(DiagonalStart, Board, Size, Diagonal).

% get_diagonal1_aux(+Position, +Board, +Size, -Diagonal)
get_diagonal1_aux([R, C], Board, Size, Diagonal) :-
    Size1 is Size-1,
    C == Size1,  
    nth0(R, Board, Row),
    nth0(C, Row, Piece),
    Diagonal = [Piece],
    !.
get_diagonal1_aux([R, C], Board, Size, Diagonal) :-
    Size1 is Size-1,
    R == Size1,
    nth0(R, Board, Row),
    nth0(C, Row, Piece),
    Diagonal = [Piece],
    !.
get_diagonal1_aux([R, C], Board, Size, Diagonal) :-
    nth0(R, Board, Row),
    nth0(C, Row, Piece),
    R1 is R+1,
    C1 is C+1,
    NewPosition = [R1, C1],
    get_diagonal1_aux(NewPosition, Board, Size, Diagonal1),
    Diagonal = [Piece | Diagonal1].

% get_diagonal2(+Move, +Board, +Size, -Diagonal)
get_diagonal2([Row, Column], Board, Size, Diagonal) :-
    Column + Row =< Size-1,
    Column1 is Column + Row,
    DiagonalStart = [0, Column1],
    get_diagonal2_aux(DiagonalStart, Board, Size, Diagonal),
    !.
get_diagonal2([Row, Column], Board, Size, Diagonal) :-
    Row1 is Row + Column - (Size - 1),
    Column1 is Size - 1,
    DiagonalStart = [Row1, Column1],
    get_diagonal2_aux(DiagonalStart, Board, Size, Diagonal).

% get_diagonal2_aux(+Position, +Board, +Size, -Diagonal)
get_diagonal2_aux([R, C], Board, _, Diagonal) :-
    C == 0,  
    nth0(R, Board, Row),
    nth0(C, Row, Piece),
    Diagonal = [Piece],
    !.
get_diagonal2_aux([R, C], Board, Size, Diagonal) :-
    Size1 is Size-1,
    R == Size1,
    nth0(R, Board, Row),
    nth0(C, Row, Piece),
    Diagonal = [Piece],
    !.
get_diagonal2_aux([R, C], Board, Size, Diagonal) :-
    nth0(R, Board, Row),
    nth0(C, Row, Piece),
    R1 is R+1,
    C1 is C-1,
    NewPosition = [R1, C1],
    get_diagonal2_aux(NewPosition, Board, Size, Diagonal1),
    Diagonal = [Piece | Diagonal1].
