% GameState is saved in the format [BoardSize, Board, Level, WhitePlayer, BlackPlayer, NextPlayer]

% get_board_size(+GameState, -BoardSize)
% Determines the size of the game board given the game state
get_board_size([BoardSize, _, _, _, _, _], BoardSize).

% get_board(+GameState, -Board)
% Determines the game board given the game state
get_board([_, Board, _, _, _, _], Board).

% get_level(+GameState, -Level)
% Determines the game level given the game state
get_level([_, _, Level, _, _, _], Level).

% get_white_player_score(+GameState, -WhitePlayer)
% Determines the score of the player with the white pieces given the game state
get_white_player_score([_, _, _, WhitePlayer, _, _], WhitePlayer).

% get_black_player_score(+GameState, -BlackPlayer)
% Determines the score of the player with the black pieces given the game state
get_black_player_score([_, _, _, _, BlackPlayer, _], BlackPlayer).

% get_next_player(+GameState, -NextPlayer)
% Determines the player that will be playing next given the game state
get_next_player([_, _, _, _, _, NextPlayer], NextPlayer).


% get_column(+ColumnIndex, +Board, -Column)
% Retrieves a specific column from the board
get_column(_, [], []) :- !.
get_column(ColumnIndex, [Line | Lines], Column) :- 
    nth0(ColumnIndex, Line, Piece),
    get_column(ColumnIndex, Lines, Column1),
    Column = [Piece | Column1].

% get_diagonal1(+Move, +Board, +Size, -Diagonal)
% Computes the top leftmost of the major diagonal that passes through the player's move and 
% returns this major diagonal in the Diagonal variable
get_diagonal1([Line, Column], Board, Size, Diagonal) :-
    Column >= Line,
    Column1 is Column-Line,
    DiagonalStart = [0, Column1],
    get_diagonal1_aux(DiagonalStart, Board, Size, Diagonal),
    !.
get_diagonal1([Line, Column], Board, Size, Diagonal) :-
    Line1 is Line-Column,
    DiagonalStart = [Line1, 0],
    get_diagonal1_aux(DiagonalStart, Board, Size, Diagonal).

% get_diagonal1_aux(+Position, +Board, +Size, -Diagonal)
% Retrieves the major diagonal that starts at a given position
get_diagonal1_aux([R, C], Board, Size, Diagonal) :-
    Size1 is Size-1,
    C == Size1,  
    nth0(R, Board, Line),
    nth0(C, Line, Piece),
    Diagonal = [Piece],
    !.
get_diagonal1_aux([R, C], Board, Size, Diagonal) :-
    Size1 is Size-1,
    R == Size1,
    nth0(R, Board, Line),
    nth0(C, Line, Piece),
    Diagonal = [Piece],
    !.
get_diagonal1_aux([R, C], Board, Size, Diagonal) :-
    nth0(R, Board, Line),
    nth0(C, Line, Piece),
    R1 is R+1,
    C1 is C+1,
    NewPosition = [R1, C1],
    get_diagonal1_aux(NewPosition, Board, Size, Diagonal1),
    Diagonal = [Piece | Diagonal1].

% get_diagonal2(+Move, +Board, +Size, -Diagonal)
% Computes the top rightmost of the minor diagonal that passes through the player's move and 
% returns this minor diagonal in the Diagonal variable
get_diagonal2([Line, Column], Board, Size, Diagonal) :-
    Column + Line =< Size-1,
    Column1 is Column + Line,
    DiagonalStart = [0, Column1],
    get_diagonal2_aux(DiagonalStart, Board, Size, Diagonal),
    !.
get_diagonal2([Line, Column], Board, Size, Diagonal) :-
    Line1 is Line + Column - (Size - 1),
    Column1 is Size - 1,
    DiagonalStart = [Line1, Column1],
    get_diagonal2_aux(DiagonalStart, Board, Size, Diagonal).

% get_diagonal2_aux(+Position, +Board, +Size, -Diagonal)
% Retrieves the minor diagonal that starts at a given position
get_diagonal2_aux([R, C], Board, _, Diagonal) :-
    C == 0,  
    nth0(R, Board, Line),
    nth0(C, Line, Piece),
    Diagonal = [Piece],
    !.
get_diagonal2_aux([R, C], Board, Size, Diagonal) :-
    Size1 is Size-1,
    R == Size1,
    nth0(R, Board, Line),
    nth0(C, Line, Piece),
    Diagonal = [Piece],
    !.
get_diagonal2_aux([R, C], Board, Size, Diagonal) :-
    nth0(R, Board, Line),
    nth0(C, Line, Piece),
    R1 is R+1,
    C1 is C-1,
    NewPosition = [R1, C1],
    get_diagonal2_aux(NewPosition, Board, Size, Diagonal1),
    Diagonal = [Piece | Diagonal1].
