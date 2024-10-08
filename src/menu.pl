% map_option_to_game_type(+Option, -GameType)
map_option_to_game_type(1, h/h).
map_option_to_game_type(2, h/pc).
map_option_to_game_type(3, pc/pc).

% choose_game_type(-GameType)
% Asks the user to choose the type of game by selecting a number between 1 and 3.
choose_game_type(GameType) :- 
    repeat, nl,
    write('Choose the game type: '), nl,
    write('1 - Human-Human (H/H)'),nl,
    write('2 - Human-Computer (H/PC)'), nl,
    write('3 - Computer-Computer (PC/PC)'), nl,
    read(N),
    number(N),
    N >= 1,
    N =< 3,
    map_option_to_game_type(N, GameType).

% choose_level(+GameType, -Level)
% Asks the user to choose the game level. If the game type is Human-Human (h/h), the level is automatically set to 1.
% Otherwise, the user is repeatedly asked to insert a level between 1 and 2.
choose_level(h/h, 1) :- !.

choose_level(_, Level) :-
    repeat, nl,
    write('Choose game level (1 or 2):'), nl,
    read(L),
    number(L),
    L >= 1,
    L =< 2,
    Level is L.

% choose_board_size(-Size)
% Repeatedly asks the user to insert the board size until a number is given.
choose_board_size(Size) :-
    repeat, nl,
    write('Choose board size:'), nl,
    read(S),
    number(S),
    Size is S.

% menu(-GameType, -Level, -Size)
% Displays the game menu, which allows the user to choose the level and type of game, as well as the board size.
menu(GameType, Level, Size) :- 
    nl, 
    choose_game_type(GameType),
    choose_level(GameType, Level),
    choose_board_size(Size).
